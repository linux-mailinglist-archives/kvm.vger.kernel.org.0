Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5159CFB2DC
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 15:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKMOu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 09:50:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33951 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727112AbfKMOu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 09:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573656624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/snImS3RCKQAYFTgaKwplx20AQSBVTMtKOickQ1zjek=;
        b=L6oy0R1HaanRo2xP0TiNNfnm8z7IYyNwIZFEOuPD+CJGQyjcn/kpDQLYVkaKbrRt+2/93c
        fQJoVScQ3ztHjOZNzHtx7rlkA5aHx6T3XyY4WKjLQxsuF65X0kj2vDENitPuXy1W9cxBd/
        Jmb6WR4S+gRkuBbgb4/FmC7+u825OEk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-8OtSwPD3OaSkju3kXE773Q-1; Wed, 13 Nov 2019 09:50:23 -0500
Received: by mail-wr1-f70.google.com with SMTP id q12so1735415wrr.3
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 06:50:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uViOOaW7gnxtknMFLeEqHtocS46dbL1si5U9obMvnSQ=;
        b=F6LhLxgLxd+bqGbQLIOmP6GQ3bTn+FpKlrY+cIARypRtiSzsxNE225IG9J/v++rTiy
         AEb58KP7fWR1E9oMXVRPfnUoY8AKzAtv0nQaP9S/sowfgMcL+JpIag3rv7zahXy2Hp6e
         4xF6JigYBacNiXPSigKPMZkqOSt21K0hMFYGtvkl0YMJoOyq8UFvFia6Qv7BLnV3pMNb
         mcSXvKxPf6rYhErjARK++ziIxjOb0Wis+2a4nshcg657mIMKn1bVTjp4t2Y8QKPy5NeG
         dDRv66Iopsvo9cMZwg6ER6UKWvd2BsPRWsRieTSDkGWG6WkRTW1dePZQmP+iAkZpNkAK
         4qPw==
X-Gm-Message-State: APjAAAVLXTvWcco4vARWWgONMws8DUIT3H/lw3CZN2Hx27tKnTQYCaMn
        ITjUy8a6Q+0C1VAoqJY+Pe314OFCY4Qdbo9jDOHx7xLD5aQq6VSyibjOSCxkQ4N6+xjKHlL3b9k
        39drHlcX+IJ48
X-Received: by 2002:a1c:e08a:: with SMTP id x132mr3243581wmg.146.1573656622264;
        Wed, 13 Nov 2019 06:50:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqw8zZDrTrbAsSBcam9XAe1XyTZ49/fsICTdL15pb5rY1nR6f3+ALNUTDuNholRDP5e0NqxU+g==
X-Received: by 2002:a1c:e08a:: with SMTP id x132mr3243550wmg.146.1573656621979;
        Wed, 13 Nov 2019 06:50:21 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:64a1:540d:6391:74a9? ([2001:b07:6468:f312:64a1:540d:6391:74a9])
        by smtp.gmail.com with ESMTPSA id l1sm3116596wrw.33.2019.11.13.06.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 06:50:21 -0800 (PST)
Subject: Re: [kvm-unit-test PATCH 0/5] Improvements for the Travis CI
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20191113112649.14322-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <81f71e72-eb74-07c2-6f35-d17634c9c7a7@redhat.com>
Date:   Wed, 13 Nov 2019 15:50:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113112649.14322-1-thuth@redhat.com>
Content-Language: en-US
X-MC-Unique: 8OtSwPD3OaSkju3kXE773Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/19 12:26, Thomas Huth wrote:
> The first two patches make the test matrix a little bit more flexible,
> and the fourth patch enables the 32-bit builds on x86.
>=20
> But the most important patch is likely the third one: It is possible to
> test with KVM on Travis now, so we can run the tests within a real KVM
> environment, without TCG! The only caveat is that qemu-system-x86_64
> has to run as root ... fixing only the permissions of /dev/kvm did
> not help here, I still got a "Permission denied" in that case.

Ah, that's Debian.  You need to be in group kvm or root to run KVM.

Looks good, can you include it in the next pull request?

Paolo

> Thomas Huth (5):
>   travis.yml: Re-arrange the test matrix
>   travis.yml: Install only the required packages for each entry in the
>     matrix
>   travis.yml: Test with KVM instead of TCG (on x86)
>   travis.yml: Test the i386 build, too
>   travis.yml: Expect that at least one test succeeds
>=20
>  .travis.yml | 155 +++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 104 insertions(+), 51 deletions(-)
>=20

