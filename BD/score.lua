local sqlite3 = require( "sqlite3" )
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local score = {}


local criarJogador = [[CREATE TABLE IF NOT EXISTS jogador (Pontuacao INTEGER);]]
print(criarJogador)
db:exec( criarJogador )

local inserir = [[INSERT INTO jogador (Pontuacao) VALUES (0);]]
print(inserir)
db:exec(inserir)

-- local remover = [[DELETE FROM jogador]]
-- db:exec(remover)

-- db:exec[=[
--           CREATE TABLE jogador (Pontuacao);
--           INSERT INTO jogador VALUES(Pontuacao);
--         ]=]


function score:atualizarPontuacao(novaPontuacao)

  local pontuacao =  self:getPontuacao()
  if(pontuacao < novaPontuacao) then
    print("print da pontuacao" .. pontuacao)
    print("print da nova pontuacao" .. novaPontuacao)
     local script = [[UPDATE jogador SET Pontuacao = ']]..novaPontuacao..[[';]]
      print(script)
      db:exec(script)
  end

end

function score:getPontuacao()
  for row in db:urows('SELECT DISTINCT Pontuacao from jogador') do
        return row
    end
    return 0
end 

function score:fecharBanco()
  if ( db and db:isopen() ) then
    print(close)
      db:close()
  end
end

return score

