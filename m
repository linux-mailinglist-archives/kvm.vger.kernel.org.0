Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3DF13342
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfECRpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:45:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44413 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfECRpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:45:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id y13so3217504pfm.11
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 10:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=x1vHwidVW2iqiue6QlEO7msowRc4CzTmFAfk84+WEko=;
        b=O1uJU6qzYXEysdJuN16Ez2JagPGxNLSKaeFOA8N6C+RZr/kAJxKmdHHSVsmxHwfxSS
         +I98Ce1dOJo46f6DyY4/3kCO2abMffY2guC/k6LTw16ALGUV5Gok+ZYEpw3Uf99A3gKn
         daRzFamSkcvycYYx47ofe5EuoCTHpFhk/BK9arSVg5NuEZwS9hPSqhYlMZ48FDQe7rlZ
         5P2W+lx1YuZtWK9pWdPmSEfggq4KwQzEbz4dbXNpzYVzfegr9GaLk+01y5viGqU3YDMK
         P/YTINpGHD/PZjEgzaNoAlQdVSwe0EGg+wiziw9AEQyMCkrQWF4Xby3ph4QNEkVNnoDx
         ILgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=x1vHwidVW2iqiue6QlEO7msowRc4CzTmFAfk84+WEko=;
        b=JyawrGh4rlwDsh27R1BTr1AutnPO3cg5khJZLQp9TtPS56aCFVO1b9RoE7aN8uploV
         TjU8UWbaA3A9TgBbqf4jpD18kG6ladk4yPGbxisrYGiP+hAWUEQ8ImDj8TlD2bS823/K
         BhVxBLLE3KiZ2IG+c2IJHqkhfkBAdE2GX+Cxh6OwIoK+2A9YoOrF4wS1i8L+TXX2IVK7
         LvseIMIo/MqV5DRlZSOlfPrl/Cbat3Wv/oZOJZYKK++4yGeZRUSTRBDD41qe63ZRjC5W
         oGWERkzfiCAm7xiNbqMNPjDWtA7w3hso8q0UMguW8Teq2RHqFVvEj4Iw8SWNRV6qz6jY
         HONg==
X-Gm-Message-State: APjAAAWFd8V+gGxyhfWu6nS2b5pfM5ESryHpn2EQq9DhemxU7eSKnWyR
        nlExB7HyVyvuxqsK73Q9jQF33KYp4XE=
X-Google-Smtp-Source: APXvYqyHEbvjexXhN0M7ri48TWLWic7VzyZAKj/mL7AAa/T3QRlCwGEmIf0Qmoi1bocI61Tkb5dkyA==
X-Received: by 2002:a63:2ad3:: with SMTP id q202mr12100492pgq.423.1556905506258;
        Fri, 03 May 2019 10:45:06 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id p81sm6072349pfa.26.2019.05.03.10.45.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:45:05 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: eventinj: Do a real io_delay()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <57fcfc11-ec47-8f54-a6d2-e40a706e3a71@oracle.com>
Date:   Fri, 3 May 2019 10:45:03 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D0191F2-105B-4446-89DB-38CC9A3B0527@gmail.com>
References: <20190502184913.10138-1-nadav.amit@gmail.com>
 <57fcfc11-ec47-8f54-a6d2-e40a706e3a71@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 3, 2019, at 10:38 AM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
> On 5/2/19 11:49 AM, nadav.amit@gmail.com wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> There is no guarantee that a self-IPI would be delivered immediately.
>> io_delay() is called after self-IPI is generated but does nothing.
>> Instead, change io_delay() to wait for 10000 cycles, which should be
>> enough on any system whatsoever.
>>=20
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  x86/eventinj.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>=20
>> diff --git a/x86/eventinj.c b/x86/eventinj.c
>> index 8064eb9..250537b 100644
>> --- a/x86/eventinj.c
>> +++ b/x86/eventinj.c
>> @@ -18,6 +18,11 @@ void do_pf_tss(void);
>>    static inline void io_delay(void)
>>  {
>> +	u64 start =3D rdtsc();
>> +
>> +	do {
>> +		pause();
>> +	} while (rdtsc() - start < 10000);
>>  }
>>    static void apic_self_ipi(u8 v)
>=20
> Perhaps call delay() (in delay.c) inside of io_delay() OR perhaps =
replace
> all instances of io_delay() with delay() ?

There is such a mess with this delay(). It times stuff based on number =
of
pause() invocations. There is an additional implementation in ioapic.c
(which by itself is broken, since there is no compiler barrier).

Let me see what I can do...=
