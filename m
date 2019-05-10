Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809C919729
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 05:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfEJDeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 23:34:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33712 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfEJDeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 23:34:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id y3so2142043plp.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 20:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2pgIIrZLViJSh9vPMPRmSqDmfvSvjM7wWRo99KAjncA=;
        b=ho+rzJzyK1nDC6L97bjxWL/BcUmJElB/HNzksPX2/dht0cQi/Ewri1j+HJW8bXC6OU
         jwL88tyB1+DhPjrox0kWryeRzu+aza/yKcvA086Q4xpfOEUpO90twThsr56JpGcrqEB/
         TSFpR7enW+n6mklcpCoqT28VL7DtIwd94Mfi2q82CG5QG+uaifGHM25fhJqBfKavTY/l
         iRBgpu6vbNjr0uX4wEGVFviPfAwpYKpseRL93I4Dq9+huY0/YpY4d53WvC8qBYK6RJv9
         IjRQfm8slR3Ez4IDY+G+SH3tWDa4ENT+B+3TI2lFxpwF3oFie03c7Z5+ehquZmhmEqPd
         ubCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2pgIIrZLViJSh9vPMPRmSqDmfvSvjM7wWRo99KAjncA=;
        b=f3TEJqnYmNF3IDfBmMev02/8410+sMFZRP9ZY/w8x+WebJXT/2nvWln8PjFWXsem3D
         xaibBSSHeQprqj5IhLiYXbeZLEf7bvPIGGy3HPiEcott8qtvt5np2BqGdYJ6vIu7etTY
         IgXifyhsNAJDbymG1S/8zjmlgDu3tLb9LeMraCInRfBEPPD57xD0/ZwywCqK12+dSf0a
         +8Vw0HIa+PV9B15GvKRDm/fRgKX3zqf0RbUouTTM0Ihdu5av/VnN4nw57pTkTCn6dunu
         GCF0u3+wY8U4svR2RJqZoS4tbui3jXN9cycIRuhNIr7lWc6ejjVJS/FJlFhSFZS3NzvU
         j2ww==
X-Gm-Message-State: APjAAAXQwzdU7r3OXZe3yR1U8Qx6QHicOL9p0/DvfiBlTlCGWBBWDyEZ
        iqaM+NNF9fjswSF1YrOaTkQ=
X-Google-Smtp-Source: APXvYqxnFSwsJBmlf6Bb+sipdrKPSaDiipOpshW1T0m7QU3DFn+TIYetw7KQTfVEImU/81nNt27ykg==
X-Received: by 2002:a17:902:5e1:: with SMTP id f88mr9985300plf.226.1557459260817;
        Thu, 09 May 2019 20:34:20 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id 15sm4698445pfy.88.2019.05.09.20.34.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 20:34:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH] x86: Halt on exit
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190509195023.11933-1-nadav.amit@gmail.com>
Date:   Thu, 9 May 2019 20:34:18 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6A5B897E-FF0F-4CD9-85D8-2C071CEF59CC@gmail.com>
References: <20190509195023.11933-1-nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Err=E2=80=A6 kvm-unit-tests patch if there is any doubt.

> On May 9, 2019, at 12:50 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> In some cases, shutdown through the test device and Bochs might fail.
> Just hang in a loop that executes halt in such cases.
>=20
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
> lib/x86/io.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/lib/x86/io.c b/lib/x86/io.c
> index f3e01f7..e6372c6 100644
> --- a/lib/x86/io.c
> +++ b/lib/x86/io.c
> @@ -99,6 +99,10 @@ void exit(int code)
> #else
>         asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
> #endif
> +	/* Fallback */
> +	while (1) {
> +		asm volatile ("hlt" ::: "memory");
> +	}
> 	__builtin_unreachable();
> }
>=20
> --=20
> 2.17.1


