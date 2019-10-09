Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072F1D0C59
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 12:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfJIKNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 06:13:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726734AbfJIKNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 06:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570616012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O6LTbg+GdpTs5MkheeWOygIhqeSpnhgW7Q7IQDjyb24=;
        b=R1IM1WpdKhVzz81sHp/0eOtggwYFx/pxilrh8cMA+6zxo6o7iVh/6DUY7dlec3DSMBxogd
        6BA4VfjQV8tY1SooxDiiUrHdmdBji2QkjYlobdxWTHEvW1/X/MQdRv2QWnrJ18p4jjYN0K
        IGbgrLexqgWPVpWMSEGN/kKuxQzWDu8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-4v-E_wKnNK6KOzBzky2vfA-1; Wed, 09 Oct 2019 06:13:28 -0400
Received: by mail-wr1-f72.google.com with SMTP id w10so886989wrl.5
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 03:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v+TdmmkbZz4RkIc5ALmLtHoofkC/7aq2g8fvsiSrnro=;
        b=RxYXEV8+Yua3QpSxlEGTEklArRp5t8IkVHkGIFuPaNjc/6HpxPZTPaQ0eDecwHXhRv
         Fygt/bpSzEaKE5jkcKdWQDmGigaSjdQspDjj8by7BfBDL6NpdN0XJRZytXTH1ycy/ZNa
         zlGYaf0WB+iRzh9qRWWhpcpIZgS2B8kIefeWuBKgBjUTjeihzayGx14Fokiqr34ImUWo
         ZubA74ek4nskbbI3IuArX58OzF27+3QnEpF+NJcP93FFr3yJXGwSr/Lkfivr7doWIgp4
         5oaguOJX8XMl2kjotuOUDIcHjNMSGg91YVm+uz7HfNnXSs/wcIpwpzvDOXrhYKGb81uG
         sjUw==
X-Gm-Message-State: APjAAAV0WR04LlTA+rNy8E48jgCkf2WfZEaugFOnJexpU/1A4tFc9D0T
        mqVJ1VYIZDPJPzUmPyuDYwpZQiHCjvKk1oKpsuCBAds9UD/GEmTN3uiqMZqtvhANuIUE8TN11QN
        5lkZspJcVzOij
X-Received: by 2002:adf:e3cb:: with SMTP id k11mr2415149wrm.80.1570616007089;
        Wed, 09 Oct 2019 03:13:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxkvmzEz8gZl0UEpaE5VOitexHk1E4Qho3YJWvm3nv5fT76hzsjb6bXLQbF2h6C0KLcmx7g1Q==
X-Received: by 2002:adf:e3cb:: with SMTP id k11mr2415132wrm.80.1570616006820;
        Wed, 09 Oct 2019 03:13:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id f3sm2133225wrq.53.2019.10.09.03.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 03:13:26 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eaec7e5d-af18-7818-b6d8-871674a4348a@redhat.com>
Date:   Wed, 9 Oct 2019 12:13:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: 4v-E_wKnNK6KOzBzky2vfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/19 01:11, Bill Wendling wrote:
> Clang warns that passing an object that undergoes default argument
> promotion to "va_start" is undefined behavior:
>=20
> lib/report.c:106:15: error: passing an object that undergoes default
> argument promotion to 'va_start' has undefined behavior
> [-Werror,-Wvarargs]
>         va_start(va, pass);
>=20
> Using an "unsigned" type removes the need for argument promotion.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/libcflat.h | 4 ++--
>  lib/report.c   | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index b94d0ac..b6635d9 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -99,9 +99,9 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>   __attribute__((format(printf, 1, 2)));
>  extern void report_prefix_push(const char *prefix);
>  extern void report_prefix_pop(void);
> -extern void report(const char *msg_fmt, bool pass, ...)
> +extern void report(const char *msg_fmt, unsigned pass, ...)
>   __attribute__((format(printf, 1, 3)));
> -extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...=
)
> +extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass,=
 ...)
>   __attribute__((format(printf, 1, 4)));
>  extern void report_abort(const char *msg_fmt, ...)
>   __attribute__((format(printf, 1, 2)))
> diff --git a/lib/report.c b/lib/report.c
> index ca9b4fd..7d259f6 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -81,7 +81,7 @@ void report_prefix_pop(void)
>  }
>=20
>  static void va_report(const char *msg_fmt,
> - bool pass, bool xfail, bool skip, va_list va)
> + unsigned pass, bool xfail, bool skip, va_list va)
>  {
>   const char *prefix =3D skip ? "SKIP"
>     : xfail ? (pass ? "XPASS" : "XFAIL")
> @@ -104,7 +104,7 @@ static void va_report(const char *msg_fmt,
>   spin_unlock(&lock);
>  }
>=20
> -void report(const char *msg_fmt, bool pass, ...)
> +void report(const char *msg_fmt, unsigned pass, ...)
>  {
>   va_list va;
>   va_start(va, pass);
> @@ -112,7 +112,7 @@ void report(const char *msg_fmt, bool pass, ...)
>   va_end(va);
>  }
>=20
> -void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> +void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
>  {
>   va_list va;
>   va_start(va, pass);
>=20

Applied, thanks.

Paolo

