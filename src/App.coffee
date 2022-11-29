import { useState } from 'react'
import reactLogo from 'assets/react.svg'
import coffeeScriptLogo from 'assets/coffeescript.svg'

import 'App.css'


App = ->
    [count, setCount] = useState 0

    <div className='App'>
      <div>
        <a href='https://coffeescript.org' target='_blank'>
          <img src={coffeeScriptLogo} className='logo' alt='Coffeescript logo' />
        </a>
        <a href='https://reactjs.org' target='_blank'>
          <img src={reactLogo} className='logo react' alt='React logo' />
        </a>
      </div>
      <h1>Coffee & React</h1>
      <div className='card'>
        <button onClick={() => setCount (count) => count + 1 }>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.coffee</code> and save to test HMR
        </p>
      </div>
      <p className='read-the-docs'>
        Click on the Coffee and React logos to learn more
      </p>
    </div>

export default App
