// TODO: Fazer todas as tipagens do jeito correto (todos os locales possíveis do linux etc)

declare module "config.json" {
  const value: {
    app: string;
    globalStyle: string;
    locale: string;
    barPlacement: "bottom";
  };
  export default value;
}
