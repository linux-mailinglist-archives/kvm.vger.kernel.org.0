Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A37133CE
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 21:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfECTAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 15:00:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33619 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfECTAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 15:00:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id k19so3150417pgh.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 12:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NaPpGLmvdNMRXuOvQ42hWMhhxGry/fLdlG6BPc/F1nE=;
        b=bGEAqz9HjkkRquyP3Y6VpACOMIaWakwXNo5sk7HD8YNGOXuRPlen78S9N1xzUHb6v7
         Y2G/Yoek7JT7hlLOseF4z3ot8XOdmAmwYYpYESuF33p0nOHQD2AO2nKuXU+uT1HlAXrQ
         hIqo0jOI1mRIF3eiK4evwX7Zp0n1jLQR1Z09EoNDjXyGquuehOzVMvBUm3uGzZgHLUpn
         GYY1wPkNcrw8b9o7mYepTz0IljJ2t86whgIyJo/jvYibqaN5SvTA0UgtGCm6j9Imy80R
         FMxy3tcD47vvJQlKd0t0DCDOi+heysB8wmYhL5Y+Pf5mTXf2Ifb+1GrKYV8PltkcFTAe
         6xWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NaPpGLmvdNMRXuOvQ42hWMhhxGry/fLdlG6BPc/F1nE=;
        b=XtFm2uor11703hCsyfHAtoeaf3TtEiwluvjYJaVg03wWD9BCXP3sPUqjFLVoUuwgE8
         KqYc5YWLGkQRnQNnIbj14zA3cA8aFRXdvFSZ4x2HiV1XhJMLYVbvHNlShFhoF8WTOOKP
         lfl3v6XFnOe6m05ysCrMm/9rWVRVPxQkOCZWokr96P7/AmcsWwUIf3Y53MgYMibhprWI
         4LuAVkPp4AHXlXJOfZlIIwZpxDWGrXoun7BXN8gqeWmq62Id8ayE06FcSuWhukmUhzn7
         k+mHk5yljenVL5SjG0WF1Ix4E+EIa0MzS42vmGkpytVy7AErT3AIk4IhIiEgiwzcZ/4I
         ST6Q==
X-Gm-Message-State: APjAAAWX+jTPB8epMo39YWi6eDGLFIdWqkPxOPHHgBfhnNZvWx5o4wOK
        dWkgC+AziKhZ016OYul6E2E=
X-Google-Smtp-Source: APXvYqzdruJc9OXz0VjH0+hmNFiwxTTwsXSeCCGTXpDTqHs4JRI05+zzFW8z95mUK9Ns3kqX6ETUcw==
X-Received: by 2002:a63:d709:: with SMTP id d9mr12713721pgg.38.1556910014867;
        Fri, 03 May 2019 12:00:14 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y8sm3089404pgk.20.2019.05.03.12.00.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 12:00:14 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH v2] x86: Some cleanup of delay() and io_delay()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <cf379aae-07e2-cb51-745c-708f0dc02e05@oracle.com>
Date:   Fri, 3 May 2019 12:00:12 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <40F9D943-1C6C-4C55-B72B-38BB09C8678F@gmail.com>
References: <20190503111307.10716-1-nadav.amit@gmail.com>
 <cf379aae-07e2-cb51-745c-708f0dc02e05@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 3, 2019, at 11:57 AM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
>=20
> On 05/03/2019 04:13 AM, nadav.amit@gmail.com wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> There is no guarantee that a self-IPI would be delivered immediately.
>> In eventinj, io_delay() is called after self-IPI is generated but =
does
>> nothing.
>>=20
>> In general, there is mess in regard to delay() and io_delay(). There =
are
>> two definitions of delay() and they do not really look on the =
timestamp
>> counter and instead count invocations of "pause" (or even "nop"), =
which
>> might be different on different CPUs/setups, for example due to
>> different pause-loop-exiting configurations.
>>=20
>> To address these issues change io_delay() to really do a delay, based =
on
>> timestamp counter, and move common functions into delay.[hc].
>>=20
>> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  lib/x86/delay.c | 9 ++++++---
>>  lib/x86/delay.h | 7 +++++++
>>  x86/eventinj.c  | 5 +----
>>  x86/ioapic.c    | 8 +-------
>>  4 files changed, 15 insertions(+), 14 deletions(-)
>>=20
>> diff --git a/lib/x86/delay.c b/lib/x86/delay.c
>> index 595ad24..e7d2717 100644
>> --- a/lib/x86/delay.c
>> +++ b/lib/x86/delay.c
>> @@ -1,8 +1,11 @@
>>  #include "delay.h"
>> +#include "processor.h"
>>    void delay(u64 count)
>>  {
>> -	while (count--)
>> -		asm volatile("pause");
>> -}
>> +	u64 start =3D rdtsc();
>>  +	do {
>> +		pause();
>> +	} while (rdtsc() - start < count);
>> +}
>> diff --git a/lib/x86/delay.h b/lib/x86/delay.h
>> index a9bf894..a51eb34 100644
>> --- a/lib/x86/delay.h
>> +++ b/lib/x86/delay.h
>> @@ -3,6 +3,13 @@
>>    #include "libcflat.h"
>>  +#define IPI_DELAY 1000000
>> +
>>  void delay(u64 count);
>>  +static inline void io_delay(void)
>> +{
>> +	delay(IPI_DELAY);
>> +}
>> +
>>  #endif
>> diff --git a/x86/eventinj.c b/x86/eventinj.c
>> index d2dfc40..901b9db 100644
>> --- a/x86/eventinj.c
>> +++ b/x86/eventinj.c
>> @@ -7,6 +7,7 @@
>>  #include "apic-defs.h"
>>  #include "vmalloc.h"
>>  #include "alloc_page.h"
>> +#include "delay.h"
>>    #ifdef __x86_64__
>>  #  define R "r"
>> @@ -16,10 +17,6 @@
>>    void do_pf_tss(void);
>>  -static inline void io_delay(void)
>> -{
>> -}
>> -
>>  static void apic_self_ipi(u8 v)
>>  {
>>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | =
APIC_DM_FIXED |
>> diff --git a/x86/ioapic.c b/x86/ioapic.c
>> index 2ac4ac6..c32dabd 100644
>> --- a/x86/ioapic.c
>> +++ b/x86/ioapic.c
>> @@ -4,6 +4,7 @@
>>  #include "smp.h"
>>  #include "desc.h"
>>  #include "isr.h"
>> +#include "delay.h"
>>    static void toggle_irq_line(unsigned line)
>>  {
>> @@ -165,13 +166,6 @@ static void test_ioapic_level_tmr(bool =
expected_tmr_before)
>>  	       expected_tmr_before ? "true" : "false");
>>  }
>>  -#define IPI_DELAY 1000000
>> -
>> -static void delay(int count)
>> -{
>> -	while(count--) asm("");
>> -}
>> -
>>  static void toggle_irq_line_0x0e(void *data)
>>  {
>>  	irq_disable();
>=20
> May be the commit header can be re-worded to something like the =
following in order to summarize your changes in a better way ?
>=20
>=20
>         x86: Incorporate timestamp in delay() and call the latter in =
io_delay()

Sounds good. Let=E2=80=99s see if there is any additional feedback =
before I send v3
(and whether Paolo will just do the rewording when he applies the =
patch=E2=80=A6)

