Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A99E48FAE
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 21:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfFQTj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 15:39:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42887 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfFQTj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 15:39:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so2318033plb.9
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 12:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Artx+b2BEYN9gZQQpUJQ26pbCFQwHfBmiRQJtB6FDro=;
        b=MW9L67KK+69d5/raWuI9GuccGwT4s80j18aKmXGhkBia1YZNkixfV6w1uNGBGNxUY2
         Slyx8cnWcP+Kj2vQZXhK0VYJoTMNEeK8T+SYtCUoQSTLl69xhWWa6uC4y3yo31GUvPNR
         Cj9jzukOGlKx5xWXCz7ZiRjwQ1h/3ManLka+p4aoaK5aI+Oie7rZmKx2jL25sri47QPW
         cv6PdcLQts0gS56rh74dYz7MTuSOZYhJ3USIGWKUsY7S/ZkQdggp4A/FIYOwVN4o81kD
         stB05Ab1aw6u5uSgNCqxFTFmx6YHw6Z2We12sgFSaa/3vsyEGfK7wovIZ6U5mmNHAlP6
         J50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Artx+b2BEYN9gZQQpUJQ26pbCFQwHfBmiRQJtB6FDro=;
        b=RevJqhkB/di/G8fVZf5FSVlGLgqjR5kH9R3Gba5O6EE3T2dW7C/+wRJ+G2tv/dVIYN
         MyeKmoJ+7eC0mfNGjOqsGfTENMV9kZb+u5ug6YeNIIhjACgK2e3IoPZ+dB83g8qR7xSl
         9F5iSH0M8hg+UFfIUaDWRJauCss1QImSh5DUSE0F1KbSlpt31abGGz9XQunTz2eEEFap
         RXiXmsm4BZ7wwz0RP/VjrCaPmijlaC0NqfGhZ6L6k2VQSbTyNu+/ZyLZY6ZMfWATYFiK
         dv73anxoWp1j4sLHA3far4/e492s+sdB8yiiG/gwQLWP7ZPQrBZZfNgqK2qFM4yth8Au
         ELqg==
X-Gm-Message-State: APjAAAVJSIOD/3VzfIHNUs/4Fq6VqYS899dROz35peyFwwnOKZ6WPKfb
        3PzwnayGnk+kFyRc4wB7AbY=
X-Google-Smtp-Source: APXvYqzANuaSOGqY+fIcpAmNfURKGaSqS6UbwX2zH+gL/x1DPXPSIbQaE5pNFixf0WrPGIZYMa/bUQ==
X-Received: by 2002:a17:902:4643:: with SMTP id o61mr56806884pld.101.1560800368786;
        Mon, 17 Jun 2019 12:39:28 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x9sm9255200pgi.39.2019.06.17.12.39.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 12:39:28 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: fix syntax error
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190613150641.4304-1-naresh.kamboju@linaro.org>
Date:   Mon, 17 Jun 2019 12:39:26 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        karl.heubaum@oracle.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <01B902DE-6191-4FF2-A51B-F7E1AA87E87C@gmail.com>
References: <20190613150641.4304-1-naresh.kamboju@linaro.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 13, 2019, at 8:06 AM, Naresh Kamboju =
<naresh.kamboju@linaro.org> wrote:
>=20
> This patch fixes this build error,
> kvm-unit-tests/lib/x86/processor.h:497:45: error: expected =E2=80=98)=E2=
=80=99 before =E2=80=98;=E2=80=99 token
>  return !!((cpuid(0x80000001).d & (1 << 20));
>           ~                                 ^
>                                            =20

Fixes: ddbb68a60534b ("kvm-unit-test: x86: Add a wrapper to check if the =
CPU supports NX bit in MSR_EFER")
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: Karl Heubaum <karl.heubaum@oracle.com>


> Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> ---
> lib/x86/processor.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 0a65808..823d65d 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -494,7 +494,7 @@ static inline int has_spec_ctrl(void)
>=20
> static inline int cpu_has_efer_nx(void)
> {
> -	return !!((cpuid(0x80000001).d & (1 << 20));
> +	return !!((cpuid(0x80000001).d & (1 << 20)));

Just because I also encountered this issue: why would you add another
bracket instead of removing one?


