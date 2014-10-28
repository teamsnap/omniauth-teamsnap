# OmniAuth TeamSnap

This is the official OmniAuth strategy for authenticating to TeamSnap. To
use it, you'll need to sign up for an OAuth2 Application Id and Secret
on [Cogsworth](https://auth.teamsnap.com).

## Basic Usage

    use OmniAuth::Builder do
      provider :teamsnap, ENV['TEAMSNAP_KEY'], ENV['TEAMSNAP_SECRET']
    end

## Scopes

TeamSnap API v3 lets you set scopes to provide granular access to different types of data:

    use OmniAuth::Builder do
      provider :teamsnap, ENV['TEAMSNAP_KEY'], ENV['TEAMSNAP_SECRET'], scope: "read write"
    end

