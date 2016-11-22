import * as React from "react";
import Paper from "material-ui/Paper";

export interface LoginScreenProps {

}
export interface LoginScreenState {}


export class LoginScreen extends React.Component<LoginScreenProps, LoginScreenState> {
    pageStyle = {
        padding: '10% 0',
    };

    formStyle = {
        height: 300,
        width: 500,
        margin: 'auto',
        textAlign: 'center',
    };


    render() {
        return (
            <div style={this.pageStyle}>
                <Paper style={this.formStyle} zDepth={3}>
                    <h1>Hello!</h1>
                </Paper>
            </div>
        )
    }
}