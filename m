Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE813308
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfECRQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:16:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38966 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfECRQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:16:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id e92so2990120plb.6
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 10:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nUBUDKnwb6quWmGwvQ3zS1ePfggilqqWztuUXrxV7GM=;
        b=qFDNVpwLpgvFkwlkN8iwq48QkVnQfQYPXq5il9mPQu3q9tYFHK3bHLmqv7gf0vJWOz
         Lu4CSt8U1qaQcKHa8/kI02a1R1/QLDCXDMqnupKtnPJEHlgg6Fn6jkIIFo/Da4Olgh2r
         2o6GrPuNgpqBhJyLHNNQdxiFq6lMLYKeS08sPkdYY803YDGOFRBhjWPMWpJA8gT4Q9N5
         4FoeK8SIpoZJhZ4vD+QxFufBMD8TQ2CJWC0ydJvBDVrPzKnbhMffNRATovTBixIhxxTN
         SEO2H077ynDp1IwP38BorGuyFhFnMr75VUObEZh0fD0AxTp9Vd6h6NpHEhg9pHdwygza
         BzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nUBUDKnwb6quWmGwvQ3zS1ePfggilqqWztuUXrxV7GM=;
        b=DfrjU3dL98Jvhc+jTESZuz1FT8tGiLVSLhVIURczEzzorAFhTdopTYM56mOljPtvt+
         wM6eFccifkZLhb6twihKi2Jp62rACn2gY77JAnQ3nukMNymiMd7rRCkKa/AgZtIZRdqX
         A3TOxwZRCgRkfc0e8YD1qkZBNzNfNsHPIE5I9Jzo2sKCo3nb882w6/UlStwJWqrH+oow
         x39dC0OHaLKnTM+yf4+pV1IqAsK27QvpdwxH8CZdZIp5Yn65mSu8Xgs3Yj0m+gwhD4Pz
         DQWu1Z6LYF/Fljk2gbsmGzDBuvvu+Z2LHMEesEqvjvzegFtD7Hju9kYAO3Jz57r8+zKe
         AW5A==
X-Gm-Message-State: APjAAAV9KyCoVCrx9dFRywzCG3sM9DjXNooRh30Co+R3cXHabRPawjV6
        UsMKtPegh3S76gJJckbBEHg=
X-Google-Smtp-Source: APXvYqxgMPzhbrj6r6mH43KSK+QP/FEzlfbsXv7Owr82Fvr9yo6rZ9MufxdiFuAnGT4OMx/i09txQg==
X-Received: by 2002:a17:902:6f17:: with SMTP id w23mr11572491plk.29.1556903811831;
        Fri, 03 May 2019 10:16:51 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id b128sm3441869pfa.167.2019.05.03.10.16.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:16:51 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] lib/alloc_page: Zero allocated pages
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190503081905.ua4htmjpqrhsqgn3@kamzik.brq.redhat.com>
Date:   Fri, 3 May 2019 10:16:48 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C9C4F5F3-584A-401A-9A65-7EA6AE8CE8FA@gmail.com>
References: <20190502154038.8267-1-nadav.amit@gmail.com>
 <20190503081905.ua4htmjpqrhsqgn3@kamzik.brq.redhat.com>
To:     Andrew Jones <drjones@redhat.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 3, 2019, at 1:19 AM, Andrew Jones <drjones@redhat.com> wrote:
>=20
> On Thu, May 02, 2019 at 08:40:38AM -0700, nadav.amit@gmail.com wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> One of the most important properties of tests is reproducibility. For
>> tests to be reproducible, the same environment should be set on each
>> test invocation.
>>=20
>> When it comes to memory content, this is not exactly the case in
>> kvm-unit-tests. The tests might, mistakenly or intentionally, assume
>> that memory is zeroed, which apparently is the case after seabios =
runs.
>> However, failures might not be reproducible if this assumption is
>> broken.
>>=20
>> As an example, consider x86 do_iret(), which mistakenly does not push
>> SS:RSP onto the stack on 64-bit mode, although they are popped
>> unconditionally.
>>=20
>> Do not assume that memory is zeroed. Clear it once it is allocated to
>> allow tests to easily be reproducible.
>>=20
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> lib/alloc_page.c | 1 +
>> 1 file changed, 1 insertion(+)
>>=20
>> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
>> index 730f2b5..b0f4515 100644
>> --- a/lib/alloc_page.c
>> +++ b/lib/alloc_page.c
>> @@ -65,6 +65,7 @@ void *alloc_page()
>> 	freelist =3D *(void **)freelist;
>> 	spin_unlock(&lock);
>>=20
>> +	memset(p, 0, PAGE_SIZE);
>> 	return p;
>> }
>>=20
>> --=20
>> 2.17.1
>=20
> I think this is reasonable, but if we make this change then we should
> remove the now redundant page zeroing too. A quick grep shows 20
> instances
>=20
> $ git grep -A1 alloc_page | grep memset | grep 0, | wc -l
> 20
>=20
> There may be more.

There are. I=E2=80=99ll send it in v2.=
