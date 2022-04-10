const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyPlugin = require("copy-webpack-plugin");

const path = require('path');
const webpack = require('webpack');

const srcPath = path.join(__dirname, "src");
const publicPath = path.join(__dirname, "public");
const distPath = path.join(__dirname, "dist");

module.exports = (env, argv) => {

    return {
        plugins: [
            new webpack.HotModuleReplacementPlugin(),
            new MonacoWebpackPlugin({
                languages: ['yaml'],
                customLanguages: [
                    {
                        label: 'yaml',
                        entry: 'monaco-yaml',
                        worker: {
                            id: 'monaco-yaml/yamlWorker',
                            entry: 'monaco-yaml/yaml.worker',
                        },
                    },
                ]
            }),
            new HtmlWebpackPlugin({
                inject: 'body',
                filename: 'index.html',
                template: path.join(srcPath, 'index.html'),
            }),
            new CopyPlugin({
                patterns: [{
                    from: path.join(srcPath, 'devfiles'),
                    to: path.join(distPath, 'devfiles')
                },
                {
                    from: path.join(srcPath, 'plugins'),
                    to: path.join(distPath, 'plugins')
                },
                {
                    from: path.join(srcPath, 'stacks.json'),
                    to: path.join(distPath, 'stacks.json')
                },
                {
                    from: path.join(srcPath, 'main.css'),
                    to: path.join(distPath, 'main.css')
                }
                ],
            })
        ],
        entry: './src/index.js',
        output: {
            filename: '[name].bundle.js',
            path: distPath,
        },
        devServer: {
            static: 'dist',
            hot: true,
            port: 8080,
            host: '0.0.0.0',
            historyApiFallback: {
                rewrites: [
                    { from: /.*/, to: '/' }
                ]
            }
        },
        module: {
            rules: [
                {
                    test: /\.elm$/,
                    exclude: [/elm-stuff/, /node_modules/],
                    use: [
                        { loader: 'elm-hot-webpack-loader' },
                        {
                            loader: 'elm-webpack-loader',
                            options: {
                                cwd: srcPath,
                                optimize: (argv.mode == 'production') ? true : false,
                                debug: (argv.mode == 'development') ? true : false,
                            }
                        }
                    ]
                },
                {
                    test: /\.css$/i,
                    use: [
                        'style-loader',
                        'css-loader',
                    ],
                },
                {
                    test: /\.(ttf|json)$/,
                    type: 'asset/resource'
                },
                {
                    test: /\.html$/i,
                    loader: 'html-loader'
                }
            ]
        }
    }
};
