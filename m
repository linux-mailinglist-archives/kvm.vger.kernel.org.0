Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B388658904
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 19:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfF0Ro1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 13:44:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46473 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfF0RoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 13:44:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so1574052pfy.13
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 10:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=89rQuimhO2tkrQOBysMfUI04ESrErcQK7Lw+LxUuDbY=;
        b=PbxvJyAKI4B1+8ZBt45Bw5NYDNXexfdTfeFOtgZz1l6ES7yHXvRUFmhCQnScTHMrPX
         Qi9GfOWGrA71n0Iqm28SNqtRKhdwImCEi7AFnP7ozBc3CtnEAir72e8X/SVOq1s8KCRG
         y+Ex66/nbt4XqRUbBdSHRw7EzhRGDhS0EQ3Bis8ufJUHkyA5dqb2x7ZZ55uVPpRwW/sK
         uWcmvAhETPYMl23vmIl5dyAzuwaYo1UZB8MAJv++N2nqG1Ac1q6G6ReP6AQlIEcHeLrD
         y4WrACF29Os1l/jRLnFHBSGslzEcFn2JmCdAXmhbSdrO6NdexYFgQllsJpAneql2xwdr
         sa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=89rQuimhO2tkrQOBysMfUI04ESrErcQK7Lw+LxUuDbY=;
        b=nUVuuqsiDB63KYgSHbaxfzReNltXv+2PAX7FK24ivVAILK7Dza36CjZhTzge97oFVf
         0vtWO3ttPKcHxsxuVMgUYKU4v8alH1u2zJeT4zfAUny2sBd0Pzt9qUhjjlix2uI7ytCF
         YY35yYQZQjaV3vqPjsViVpODeq4X4Ll/m8Q3PcHaRdJQYISvDCELGqWVo6uQXwRkg7OL
         lNEXvev2pbchgUfCvOYoI5S3uCnT8+B8Os+MQWYGCDjMTSHDcWv5IL1maQ6J+9t5Yip7
         eh6fAzFHGimay/Lm/dGUqmXdBgmH+N/venZOi9Y1QKgmoT8udLSitqGYx2+xfp7vqOVz
         23UA==
X-Gm-Message-State: APjAAAUUJUYSRIcEXVf1UQc5T2rpp1e6wx8S0qGsr+lVSXjny2wxWgy+
        yVADvGkrxwMhhGmshDkGSlVH+IRDtyg=
X-Google-Smtp-Source: APXvYqw5cZHI9b3rLMw9mq/IrYppjigtvRb+tiv+lxAEkPpyuDrP/tsj0M7ztsCQ0VoZtNnae5Mu7w==
X-Received: by 2002:a65:5c0a:: with SMTP id u10mr5025315pgr.412.1561657460029;
        Thu, 27 Jun 2019 10:44:20 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p2sm5713984pfb.118.2019.06.27.10.44.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:44:19 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: Memory barrier before setting ICR
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <e7ff39ef-5d09-6aa0-a3ac-e23707355e99@oracle.com>
Date:   Thu, 27 Jun 2019 10:44:17 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <04225212-29F6-4C73-B5BF-B00C36D6B038@gmail.com>
References: <20190625125836.9149-1-nadav.amit@gmail.com>
 <e7ff39ef-5d09-6aa0-a3ac-e23707355e99@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 26, 2019, at 6:07 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
> On 6/25/19 5:58 AM, Nadav Amit wrote:
>> The wrmsr that is used in x2apic ICR programming does not behave as a
>> memory barrier. There is a hidden assumption that it is. Add an =
explicit
>> memory barrier for this reason.
>>=20
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  lib/x86/apic.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>=20
>> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
>> index bc2706e..1514730 100644
>> --- a/lib/x86/apic.c
>> +++ b/lib/x86/apic.c
>> @@ -2,6 +2,7 @@
>>  #include "apic.h"
>>  #include "msr.h"
>>  #include "processor.h"
>> +#include "asm/barrier.h"
>>    void *g_apic =3D (void *)0xfee00000;
>>  void *g_ioapic =3D (void *)0xfec00000;
>> @@ -71,6 +72,7 @@ static void x2apic_write(unsigned reg, u32 val)
>>    static void x2apic_icr_write(u32 val, u32 dest)
>>  {
>> +    mb();
>>      asm volatile ("wrmsr" : : "a"(val), "d"(dest),
>>                    "c"(APIC_BASE_MSR + APIC_ICR/16));
>>  }
>=20
>=20
> Regarding non-serializing forms, the SDM mentions,
>=20
>         "X2APIC MSRs (MSR indices 802H to 83FH)"
>=20
>=20
> (APIC_BASE_MSR + APIC_ICR/16) is a different value. So I am wondering =
why we need a barrier here.

What am I missing here?

APIC_BASE_MSR =3D 0x800
APIC_ICR =3D 0x300

So 0x800 + (0x300 / 16) =3D 0x830 , and 0x802 <=3D 0x830 <=3D 0x83f

Hence, writes to APIC_ICR do not seem to be serializing. No?=
