Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D6ADF1A0
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbfJUPdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:33:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25204 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727771AbfJUPdG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Oct 2019 11:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571671983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7N9C+YvpkhA42qlkXXCTzpRO094/Es1vVnkANbh1gcs=;
        b=YLQ1QI5gsYTOCuqGFxw6kKf73Unfo1bD0QTQo5QNZJ35GOqUfwz5APVmPQM/O+Mna40ulH
        X4Vc8qEE8ueMOFH+lSqFxwO7GiQ5XJ9UeFTkBMZ5D/qtJSGESN2cOu0bh/zWx7F2SjmPrU
        j1Zo4iHwRDufnHcMNCe+powSEInVIao=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-DOtJMa-rMR6KCCvNDV9G4w-1; Mon, 21 Oct 2019 11:33:00 -0400
Received: by mail-wm1-f69.google.com with SMTP id l184so3580346wmf.6
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iy3Vj6pwygJprRApHBFrU4XQuiFEITNu65q6mCX5jX4=;
        b=rwR/upqmArvUGFkIZZCi/OK6IQ3JmrBUox5g8imJjxQmMY4JOh6Mb0hUG5jUSbEFMM
         wX9Bp0Cp2fer2CzkesJJICoKB2qO2bIuJy71xb0fHn5FW163NU+sZILSW8Bs4lsHXNfJ
         MBMFIn8OsOlTvqPbYE5aBBad6f2DcazOt9x/IkrWybWabm206//nzDMLRkng0FZGSuih
         GDRO4GZuNolHvX4YEtSjooTSF7U4+/1nrOIFkd3CU8iJfaKNryidQ66mQ28adzrMGDY1
         Jkq9Y8KBaSmYthXyh46pRW4KBLadNXC3ffkdU540hOEgNhmBkrOmjGi+AlVC1lTvs2m6
         QA0g==
X-Gm-Message-State: APjAAAU+mkq+VRs+uiRI8sh/P08TbX1KE3SxcPLyt9zkNhFN+n5u/zww
        rES1ofbwCKeiVXjvVHgY5uvgdL8t+W7Q9y2hXndiH4Zey6K1KP3T8bJMBDqFzfjNFTQsLOtVhkz
        2l0xvegDjqUMZ
X-Received: by 2002:adf:e302:: with SMTP id b2mr19161307wrj.298.1571671979597;
        Mon, 21 Oct 2019 08:32:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwhj831vqwprHvFgJOTIhohukKm7UbZPEUsdLFAxK3882syAFLEzRzczAoJa7lXYQy2d5Yhzg==
X-Received: by 2002:adf:e302:: with SMTP id b2mr19161283wrj.298.1571671979254;
        Mon, 21 Oct 2019 08:32:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id n3sm16093927wrr.50.2019.10.21.08.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:32:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] Use a status enum for reporting
 pass/fail
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com
References: <20191012074454.208377-1-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <81877082-d6c9-9573-4b44-184695386f4f@redhat.com>
Date:   Mon, 21 Oct 2019 17:32:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012074454.208377-1-morbo@google.com>
Content-Language: en-US
X-MC-Unique: DOtJMa-rMR6KCCvNDV9G4w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/19 09:44, Bill Wendling wrote:
> Some values passed into "report" as "pass/fail" are larger than the
> size of the parameter. Instead use a status enum so that the size of the
> argument no longer matters.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>

I'm going to apply Thomas's argument reversal patch.  Note that the
commit message doesn't describe very well what is it that you're fixing
(or rather, why it needs fixing).

Paolo

> ---
>  lib/libcflat.h | 13 +++++++++++--
>  lib/report.c   | 24 ++++++++++++------------
>  2 files changed, 23 insertions(+), 14 deletions(-)
>=20
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index b6635d9..8f80a1c 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -95,13 +95,22 @@ extern int vsnprintf(char *buf, int size, const char =
*fmt, va_list va)
>  extern int vprintf(const char *fmt, va_list va)
>  =09=09=09=09=09__attribute__((format(printf, 1, 0)));
> =20
> +enum status { PASSED, FAILED };
> +
> +#define STATUS(x) ((x) !=3D 0 ? PASSED : FAILED)
> +
> +#define report(msg_fmt, status, ...) \
> +=09report_status(msg_fmt, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
> +#define report_xfail(msg_fmt, xfail, status, ...) \
> +=09report_xfail_status(msg_fmt, xfail, STATUS(status) __VA_OPT__(,) __VA=
_ARGS__)
> +
>  void report_prefix_pushf(const char *prefix_fmt, ...)
>  =09=09=09=09=09__attribute__((format(printf, 1, 2)));
>  extern void report_prefix_push(const char *prefix);
>  extern void report_prefix_pop(void);
> -extern void report(const char *msg_fmt, unsigned pass, ...)
> +extern void report_status(const char *msg_fmt, unsigned pass, ...)
>  =09=09=09=09=09__attribute__((format(printf, 1, 3)));
> -extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass,=
 ...)
> +extern void report_xfail_status(const char *msg_fmt, bool xfail, enum st=
atus status, ...)
>  =09=09=09=09=09__attribute__((format(printf, 1, 4)));
>  extern void report_abort(const char *msg_fmt, ...)
>  =09=09=09=09=09__attribute__((format(printf, 1, 2)))
> diff --git a/lib/report.c b/lib/report.c
> index 2a5f549..4ba2ac0 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -80,12 +80,12 @@ void report_prefix_pop(void)
>  =09spin_unlock(&lock);
>  }
> =20
> -static void va_report(const char *msg_fmt,
> -=09=09bool pass, bool xfail, bool skip, va_list va)
> +static void va_report(const char *msg_fmt, enum status status, bool xfai=
l,
> +               bool skip, va_list va)
>  {
>  =09const char *prefix =3D skip ? "SKIP"
> -=09=09=09=09  : xfail ? (pass ? "XPASS" : "XFAIL")
> -=09=09=09=09=09  : (pass ? "PASS"  : "FAIL");
> +=09=09=09=09  : xfail ? (status =3D=3D PASSED ? "XPASS" : "XFAIL")
> +=09=09=09=09=09  : (status =3D=3D PASSED ? "PASS"  : "FAIL");
> =20
>  =09spin_lock(&lock);
> =20
> @@ -96,27 +96,27 @@ static void va_report(const char *msg_fmt,
>  =09puts("\n");
>  =09if (skip)
>  =09=09skipped++;
> -=09else if (xfail && !pass)
> +=09else if (xfail && status =3D=3D FAILED)
>  =09=09xfailures++;
> -=09else if (xfail || !pass)
> +=09else if (xfail || status =3D=3D FAILED)
>  =09=09failures++;
> =20
>  =09spin_unlock(&lock);
>  }
> =20
> -void report(const char *msg_fmt, unsigned pass, ...)
> +void report_status(const char *msg_fmt, enum status status, ...)
>  {
>  =09va_list va;
> -=09va_start(va, pass);
> -=09va_report(msg_fmt, pass, false, false, va);
> +=09va_start(va, status);
> +=09va_report(msg_fmt, status, false, false, va);
>  =09va_end(va);
>  }
> =20
> -void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
> +void report_xfail_status(const char *msg_fmt, bool xfail, enum status st=
atus, ...)
>  {
>  =09va_list va;
> -=09va_start(va, pass);
> -=09va_report(msg_fmt, pass, xfail, false, va);
> +=09va_start(va, status);
> +=09va_report(msg_fmt, status, xfail, false, va);
>  =09va_end(va);
>  }
> =20
>=20

