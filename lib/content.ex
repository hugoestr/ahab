defmodule Content do
  use Timex
  use Calliope

  @moduledoc """
    The Content module provides functions to create content
    for the site. This module is intented to be used by 
    the mix tasks interface.
  """

  @doc """
    Creates a draft markup file with minimum values needed

    It takes a title and creates a markdown file with that name.

    example: mix ahab.draft "New blog entry"  
  """
  def create_draft(title) do
    underscored_title = Ahab.Utils.underscore(title)

    {:ok, f} = File.open "drafts/#{underscored_title}.md", [:write]

    IO.write f, "title: #{title}\n"
    IO.write f, "summary: \n"
    IO.write f, "tags: \n"
    IO.write f, "published_date: date_stub\n"
    IO.write f, "tags: \n"
    IO.write f, "related_links: \n"
    IO.write f, "previous_links: \n"
    IO.write f, "---\n"

    File.close f
  end


  @doc """
    Publishes a draft.

    It takes the draft, processes it to be published, and 
    then renders the page in the content folder.

    example: mix ahab.publish "New blog entry"
  """
  def publish(title) do
    started =  Application.ensure_all_started :ahab

    case started do
      {:ok, _apps} ->    start_processing(title) 
      {:error, _apps} -> {:error, "yamerl couldn't start"} 
    end
  end

  defp start_processing(title) do
    paths = create_paths title 
    %{draft: draft} = paths

    response = File.exists? draft

    case response do
      :true    -> process(paths)
      :false   -> {:error, "file '#{title}' not found in drafts"}
    end
  end


  defp process(%{draft: draft, published: published, built: built}) do
    process_to_published draft, published  
    write_post published, built
    {:ok, "all right"}
  end

  defp process_to_published(draft, published) do
    add_published_date draft
    move_draft_to_published draft, published
  end


  defp add_published_date(path) do
    response = File.read path 

    case response do
      {:ok, data} -> 
        {:ok, today} = Timex.format(Timex.now, "{ISO:Extended:Z}") 
        updated = String.replace(data, "date_stub", today)
        
        File.open!( path, [:write], fn file ->
          IO.write file, updated end)  
      {:error, message} -> IO.puts message
    end
  end

  defp move_draft_to_published(draft, published) do
    File.cp! draft, published
    File.rm! draft
  end

  defp write_post(path, built) do
    [data, markdown] = split path

    meta = :yamerl.decode(data) |> List.flatten 
    html = Earmark.as_html! markdown
  
    values = meta ++  [content: html]
    render "template.html.haml", built, values 
  end

  defp render(template_path, output_path, values) do
    template = 
      template_path
      |> File.read!
      |> String.replace("\r", "")


    metadata = 
      values
      |> Enum.map(fn {key, value} -> 
                  {String.to_atom(to_string(key)), value} end)

    variables = preprocess_metadata metadata

    IO.inspect variables

    page = Calliope.render template, variables 

    File.open!(output_path, [:write, :utf8], fn file ->
      IO.write file, page
    end)
  end

  defp preprocess_metadata(metadata) do
    {:ok, pdate} = Keyword.fetch metadata, :published_date

    IO.inspect pdate 

    {:ok, date} = Timex.parse (to_string pdate), "{ISO:Extended:Z}"

    IO.inspect date 
    formatted = Timex.format! date, "{D} {Mfull}, {YYYY}"
    
    Keyword.put metadata, :published_date, formatted 
  end

  defp split(path) do
    {:ok, content} = File.read path
    String.split content, "---"
  end

  defp create_paths(title) do
    [name|_tail] = String.split title, "."
    underscored_title = Ahab.Utils.underscore(name)

    draft = "drafts/#{underscored_title}.md"
    published = "published/#{underscored_title}.md"
    built = "content/#{underscored_title}.html"

    %{title: name, draft: draft, published: published, built: built}
  end
end
