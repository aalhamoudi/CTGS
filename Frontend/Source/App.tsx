import * as React from 'react';
import * as ReactDOM from 'react-dom'
import * as injectTapEventPlugin from 'react-tap-event-plugin';
import {MuiThemeProvider} from "material-ui/styles";
import {Router, Route, IndexRoute, browserHistory} from 'react-router'


import {UserView} from './Views/UserView'

import {LoginScreen} from "./Screens/LoginScreen";
import {NotFoundScreen} from "./Screens/NotFoundScreen";

injectTapEventPlugin();


class Root extends React.Component<{}, {}> {
    render() {
        return (
            <MuiThemeProvider>
                <Router history={browserHistory}>
                    <Route path="/">
                        <IndexRoute component={UserView} />
                        <Route path="/login" component={LoginScreen} />
                        <Route path="*" component={NotFoundScreen} />
                    </Route>
                </Router>
            </MuiThemeProvider>
        )
    }
}



ReactDOM.render(
    <Root />,
    document.getElementById('app')
);