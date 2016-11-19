import * as React from "react";

export interface MainProps {}
export interface MainState {}

export class Main extends React.Component<MainProps, MainState> {
    render() {
        return <h1>Hello!</h1>;
    }
}