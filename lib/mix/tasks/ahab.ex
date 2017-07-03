defmodule Mix.Tasks.Ahab.Init do
  use Mix.Task

  def run(_) do
    create_directories()  
    create_files()
  end

  defp create_directories() do
    ["drafts", "content", "published"]
    |> Enum.map(fn directory -> 
                System.cmd("mkdir", [directory]) end)
  end

  defp create_files() do
    ["site.css", "index.html", "template.html.hml"]
    |> Enum.map(fn file -> 
                "type NUL > #{file}"
                |> String.to_char_list
                |> :os.cmd end)
  end
end

defmodule Mix.Tasks.Ahab.Draft do
  use Mix.Task

  def run([title| _rest]) do
    Content.create_draft title
   
  end

end

defmodule Mix.Tasks.Ahab.Publish do

  def run([title|_rest]) do
    result = Content.publish title

    case result do
      {:ok, _message}   -> IO.puts "#{title} published" 
      {:error, message} -> IO.puts message 
    end 
  end

end
