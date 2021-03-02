require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "returns an array of posts" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      Post.create!([
        { user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I" },
        { user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/131/200/300.jpg?hmac=9q7mRSOguNBFGg_gPPRKlfjNINGjXWeDBTYPP1_gEas" },
        {user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/852/200/300.jpg?hmac=6IMZOkPF_q5nf8IwfYdfxPUyKnyPL1w8moDjTeMOT5g"},
      ])
      get "/api/posts"
      posts = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(3)
    end
  end
  describe "GET /posts/:id" do
    it "should return a hash with the appropriate attributes" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      post = Post.create!({ user_id: user.id, title: "Networked bifurcated definition", body: "Vhs pbr\u0026b vice humblebrag banjo ugh pop-up selvage. Pbr\u0026b tattooed 90's humblebrag. Asymmetrical photo booth artisan roof occupy yuccie. Kinfolk next level meditation narwhal letterpress small batch. Humblebrag goth occupy narwhal master shoreditch organic. Fashion axe beard humblebrag lo-fi messenger bag. Tumblr normcore iphone pork belly messenger bag master umami franzen.", image: "https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I" })
      
      get "/api/posts/#{post.id}"
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("Networked bifurcated definition")
      expect(post["body"]).to eq("Vhs pbr\u0026b vice humblebrag banjo ugh pop-up selvage. Pbr\u0026b tattooed 90's humblebrag. Asymmetrical photo booth artisan roof occupy yuccie. Kinfolk next level meditation narwhal letterpress small batch. Humblebrag goth occupy narwhal master shoreditch organic. Fashion axe beard humblebrag lo-fi messenger bag. Tumblr normcore iphone pork belly messenger bag master umami franzen.")
      expect(post["image"]).to eq("https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I")
    end
  end
  describe "POST /posts" do
    it "creates a post and returns the data" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      jwt = JWT.encode(
        { user: user.id, exp: 24.hours.from_now.to_i },
        "random", 'HS256'
      )

      post "/api/posts",
        params: {
          title: "New title",
          body: "New body",
          image: "New image",
        },
        headers: {
          "Authorization" => "Bearer #{jwt}",
        }
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("New title")
    end

    it "creates prevents saving a post with invalid data" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      jwt = JWT.encode(
        { user: user.id, exp: 24.hours.from_now.to_i },
        "random", 'HS256'
      )

      post "/api/posts",
        params: {
        body: "New body",
        image: "New image",
        },
        headers: {
        "Authorization" => "Bearer #{jwt}",
        }
      post = JSON.parse(response.body)

      expect(response).to have_http_status(400)
    end

    it "creates prevents saving a post with invalid login" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")

      post "/api/posts",
        params: {
        title: "New title",
        body: "New body",
        image: "New image",
        }

      post = JSON.parse(response.body)

      expect(response).to have_http_status(401)
    end
  end
  describe  "PATCH /posts/:id" do
    it "updates a post and returns the data" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      post = Post.create!({ user_id: user.id, title: "Networked bifurcated definition", body: "Vhs pbr\u0026b vice humblebrag banjo ugh pop-up selvage. Pbr\u0026b tattooed 90's humblebrag. Asymmetrical photo booth artisan roof occupy yuccie. Kinfolk next level meditation narwhal letterpress small batch. Humblebrag goth occupy narwhal master shoreditch organic. Fashion axe beard humblebrag lo-fi messenger bag. Tumblr normcore iphone pork belly messenger bag master umami franzen.", image: "https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I" })
      jwt = JWT.encode(
      { user: user.id, exp: 24.hours.from_now.to_i },
      "random", 'HS256'
      )
      
      patch "/api/posts/#{post.id}",
        params: {
        title: "New title",
        body: "New body",
        image: "New image",
      },
      headers: {
        "Authorization" => "Bearer #{jwt}",
      }
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("New title")
    end
  end
  describe  "DELETE /posts/:id" do
    it "deletes a post and returns confirmation message" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      post = Post.create!({ user_id: user.id, title: "Networked bifurcated definition", body: "Vhs pbr\u0026b vice humblebrag banjo ugh pop-up selvage. Pbr\u0026b tattooed 90's humblebrag. Asymmetrical photo booth artisan roof occupy yuccie. Kinfolk next level meditation narwhal letterpress small batch. Humblebrag goth occupy narwhal master shoreditch organic. Fashion axe beard humblebrag lo-fi messenger bag. Tumblr normcore iphone pork belly messenger bag master umami franzen.", image: "https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I" })
      jwt = JWT.encode(
      { user: user.id, exp: 24.hours.from_now.to_i },
      "random", 'HS256'
      )
      
      delete "/api/posts/#{post.id}"

      headers: {
        "Authorization" => "Bearer #{jwt}",
      }
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post.id).to eq("Post successfully destroyed!")
    end
  end
end