Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B56D31366D
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhBHPKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:10:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232524AbhBHPIw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 10:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612796846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnvj6hEq9W4hKQ8IqalMG8SwCbXO9Y4nqAk6OidgryE=;
        b=f0x8oy1IpyFoNagMUP1Re5Kgcmz7SOxm/aFFZAS5sg6cYZ0l7hogUu0VLah4Oc7WYkWEeE
        9DfXacy0+6yqGZAfjsru3hQgmplByp1CsTYuVZHETnr/aZSg15mY2s32LFZXVOqo3WdInv
        8v/XVQSekyxS5TtwMQRyn6R+aMck9ao=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-v6ZBpa4TOAaH5I6VBcyyqg-1; Mon, 08 Feb 2021 10:07:23 -0500
X-MC-Unique: v6ZBpa4TOAaH5I6VBcyyqg-1
Received: by mail-wm1-f69.google.com with SMTP id t128so5636888wmg.4
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 07:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fnvj6hEq9W4hKQ8IqalMG8SwCbXO9Y4nqAk6OidgryE=;
        b=hPOoV4v5lcSFPNne7AXiqZMaNNTv3JfVXMuFolmZXM2cUMEHS3ASM6aN+iQv7TdRkx
         V8By7GohxiMgQrd+8GGA0z9w5lx7F/gTaguRtb0MSmqORduPQCGh8GFcYkXkZOOiHs7o
         hN6JHIX2oKNaRLClaRr6b0pWKTMjizvTyqik0dfx3kUyQZ4jL8MaGRe06fCcIghMZ1RR
         COK4aXt8qvJUAOm8TV3jj2SgTsianCInWx5lAx2HusXe5mxmWUK7jjFOSX69Hts8W248
         ECvJc1+FnSO+UiWrsiPgZvKt2WAZsMVc9Nv2qqyiSkB68d+Colb3awISvumOzlPw0B7D
         NgtQ==
X-Gm-Message-State: AOAM5302gw6BP8EhSgzcELv7qT4Ta2TvwVs/vH96wSxD3mdO0ZeVJc61
        VIoN3M9dh3cUocdUhMd+1D64psX4i6JdSUDqP3Wotmo0MaUmg8/J55Zx2OjLaTLfEj1qGeg5rtJ
        JRzOJ9WwD/t/F
X-Received: by 2002:a5d:4ad0:: with SMTP id y16mr2781086wrs.399.1612796842735;
        Mon, 08 Feb 2021 07:07:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdaSqrenqoqKN2Bt84pZI5v0YQqyvw3NJTt1jR0U/psUx5oNW4b5Wx/UZL3BMLKd/vIfUeoA==
X-Received: by 2002:a5d:4ad0:: with SMTP id y16mr2781061wrs.399.1612796842394;
        Mon, 08 Feb 2021 07:07:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z8sm28391101wrh.83.2021.02.08.07.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:07:21 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Add new s390x targets to
 run tests with TCG and KVM accel
To:     Marcelo Bandeira Condotta <mbandeir@redhat.com>, thuth@redhat.com,
        kvm@vger.kernel.org
Cc:     Marcelo Bandeira Condotta <mcondotta@redhat.com>
References: <20210208150227.178953-1-mbandeir@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f34cddf-84bf-0726-8074-1688974a74d8@redhat.com>
Date:   Mon, 8 Feb 2021 16:07:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208150227.178953-1-mbandeir@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 16:02, Marcelo Bandeira Condotta wrote:
> From: Marcelo Bandeira Condotta <mcondotta@redhat.com>
> 
> A new s390x z15 VM provided by IBM Community Cloud will be used to run
> the s390x KVM Unit tests natively with both TCG and KVM accel options.
> 
> Signed-off-by: Marcelo Bandeira Condotta <mbandeir@redhat.com>
> ---
>   .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index d97e27e..bc7a115 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -155,3 +155,31 @@ cirrus-ci-macos-i386:
>   
>   cirrus-ci-macos-x86-64:
>    <<: *cirrus_build_job_definition
> +
> +test-s390x-tcg:
> +  stage: test
> +  before_script: []
> +  tags:
> +    - s390x-z15-vm
> +  script:
> +    - ./configure --arch=s390x
> +    - make -j2
> +    - ACCEL=tcg ./run_tests.sh
> +     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
> +     stsi sclp-1g sclp-3g
> +     | tee results.txt
> +    - if grep -q FAIL results.txt ; then exit 1 ; fi
> +
> +test-s390x-kvm:
> +  stage: test
> +  before_script: []
> +  tags:
> +    - s390x-z15-vm
> +  script:
> +    - ./configure --arch=s390x
> +    - make -j2
> +    - ACCEL=kvm ./run_tests.sh
> +     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
> +     stsi sclp-1g sclp-3g
> +     | tee results.txt
> +    - if grep -q FAIL results.txt ; then exit 1 ; fi
> 

So it will have a custom runner?  That's nice!

Do you have an example run already?

Paolo

