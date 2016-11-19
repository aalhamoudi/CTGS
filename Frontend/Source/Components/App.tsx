import * as React from "react";
import RaisedButton from 'material-ui/RaisedButton';

export interface AppProps {}
export interface AppState {}

export class App extends React.Component<AppProps, AppState> {
    render() {
        return <RaisedButton label="Default" />;
    }
}