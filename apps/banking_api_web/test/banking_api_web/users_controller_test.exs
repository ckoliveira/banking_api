defmodule BankingApiWeb.UsersControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.User

  describe "create/2" do
    setup do
      params = %{name: "dummy", cpf: "12365487900", password: "c1b2m49nv03"}
      {:ok, params: params}
    end

    test "sucessfully create user", ctx do
      %{name: name, cpf: cpf} = ctx.params

      assert %{
               "name" => ^name,
               "cpf" => ^cpf
             } =
               ctx.conn
               |> post("api/user/", ctx.params)
               |> json_response(200)
    end

    test "fails when creating user with a cpf already registered", ctx do
      %{name: name, cpf: cpf} = ctx.params

      assert %{
               "name" => ^name,
               "cpf" => ^cpf
             } =
               ctx.conn
               |> post("api/user/", ctx.params)
               |> json_response(200)

      assert %{
               "description" => "cpf already being used",
               "type" => "invalid input"
             } =
               ctx.conn
               |> post("api/user/", ctx.params)
               |> json_response(400)
    end

    test "fails when creating user with invalid cpf", ctx do
      params = %{ctx.params | cpf: "invalid cpf"}

      assert %{
               "description" => "[cpf: {\"has invalid format\", [validation: :format]}]",
               "type" => "invalid input"
             } =
               ctx.conn
               |> post("api/user/", params)
               |> json_response(400)
    end

    test "fails when creating user passing a blank string as cpf", ctx do
      params = %{ctx.params | cpf: ""}

      assert %{
               "description" => "[cpf: {\"can't be blank\", [validation: :required]}]",
               "type" => "invalid input"
             } =
               ctx.conn
               |> post("api/user/", params)
               |> json_response(400)
    end

    test "fails when creating user with cpf of invalid lenght", ctx do
      params = %{ctx.params | cpf: "1"}

      assert %{
               "description" =>
                 "[cpf: {\"should be at least %{count} character(s)\", [count: 11, validation: :length, kind: :min, type: :string]}]",
               "type" => "invalid input"
             } =
               ctx.conn
               |> post("api/user/", params)
               |> json_response(400)
    end

    test "fails when creating with password of invalid lenght", ctx do
      params = %{ctx.params | password: "1"}

      assert %{
               "description" =>
                 "[password: {\"should be at least %{count} character(s)\", [count: 8, validation: :length, kind: :min, type: :string]}]",
               "type" => "invalid input"
             } =
               ctx.conn
               |> post("api/user/", params)
               |> json_response(400)
    end

    test "fails when creating user with blank password", ctx do
      params = %{ctx.params | password: ""}

      assert %{
               "description" => "[password: {\"can't be blank\", [validation: :required]}]",
               "type" => "invalid input"
             } =
               ctx.conn
               |> post("api/user/", params)
               |> json_response(400)
    end
  end

  describe "fetch/2" do
    setup do
      password = "7yf8j4f8j9"

      params = %{
        name: "user",
        cpf: "33366699969",
        password_hash: Argon2.hash_pwd_salt(password)
      }

      user = User.create(params)

      {:ok, user: user, params: params, password: password}
    end

    test "sucessfully fetches user", ctx do
      assert %{
               "balance" => 1000,
               "cpf" => "33366699969",
               "name" => "user"
             } =
               ctx.conn
               |> get("api/user/fetch", %{cpf: ctx.params.cpf, password: ctx.password})
               |> json_response(200)
    end

    test "fails when fetching a user with invalid cpf", ctx do
      assert %{
               "description" => "invalid cpf and/or password",
               "type" => "credential error"
             } =
               ctx.conn
               |> get("api/user/fetch", %{cpf: "invalid cpf", password: ctx.password})
               |> json_response(412)
    end

    test "fails when fetching user with invalid password", ctx do
      assert %{
               "description" => "invalid cpf and/or password",
               "type" => "credential error"
             } =
               ctx.conn
               |> get("api/user/fetch", %{cpf: ctx.params.cpf, password: "wrong password"})
               |> json_response(412)
    end
  end
end
