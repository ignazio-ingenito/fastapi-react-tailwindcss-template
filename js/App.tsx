import React from "react"
import ReactDom from "react-dom"

interface AppProps {
    userName: string;
    language: string;
}

const App = ({userName, language}: AppProps) => (
  <div className="app">
    <h1>
      Hello world {userName} I speack {language} !!!
    </h1>
  </div>
)

ReactDom.render(
    <App userName="user" language="en"/>,
    document.getElementById("app")
)