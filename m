Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE767133A4
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 20:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbfECSgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 14:36:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33806 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfECSgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 14:36:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id e9so9055802wrc.1
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 11:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=I4iuJmgunaB3Su4nNDZvpQbmxq9bG4AhFpMkeJSSWm8=;
        b=IDANAHSYvhqmS8eY3eWRE2ZJVWFmFBf2TvDSRWz7UN1dUATvSO3tzVFMD0sT1cHyFh
         l1ABG0xOKZsPN+xyxc/R70lxrLL3i1dVlbCuy80Vkg8Gro9JDQs7N7qdj22w3fPZ/rtT
         ILbzaOBWbKrnHF0iJ9kqZ6Eb103uLT0QUxZve1zvL/jdcny5/HBUnFwASk06UtCMn5LL
         GetNaM9nFXv1A7+lUpfxP4FrMcsmvC7T5CbM6E8hN+vTlDJqv0pmUIry6oJrJkfvxwcV
         6V0w2Tz9Fvus9TEUS9X7XRLysMLFLCXlQaSdVSbObOHUdhvqY5tJAeDIlLB/6nkP18gk
         dnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=I4iuJmgunaB3Su4nNDZvpQbmxq9bG4AhFpMkeJSSWm8=;
        b=qzhxP9w6FMQbNfhmmXbyzYxl20QVzzlCDgAnVahxk1oDOcFDURC7Onn032Yi0hld8W
         0O+vlqWdBEltesI4zR4ddiv1EDx5/cX1I+Qhk8ia9XY9LnIlqtDJJpoJWZ55YPYwQByd
         p1c1RW5U0fnbYCK8a7iWMjD//sOIFSn6ssu7rKx8SDR4IalFc0CIn5ufUC5eZE/0Jtdc
         NCNmAvlS5IEKx8c1o1ddsgLwpB/EO61IyDP5vGNN7w9N6LMVWWVHio3QZ5/tcvdNsZ68
         WjxdNJJjXJnI/vNyotLLRdq4fQNIk5pj5HKQ9v8/wJi+7gBD/5detjqB1/NQnjbR/uM/
         hp3A==
X-Gm-Message-State: APjAAAXXNhve1SVnfCOEarNLy6c+z2f0hdcUAqG77qEDiitdWOr2EeI+
        qz/gj59E3TaFjByNEXsmly4=
X-Google-Smtp-Source: APXvYqwn+Pt+XqbIIQ6sybvjsspEUKQ8EW26qoSzEaG48ZHZzSAuO6czcWtTAK1uacGHcd3hx1A0cw==
X-Received: by 2002:a5d:4989:: with SMTP id r9mr8632358wrq.173.1556908569300;
        Fri, 03 May 2019 11:36:09 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id z9sm3696728wma.39.2019.05.03.11.36.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 11:36:08 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH v2] x86: Some cleanup of delay() and io_delay()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190503111307.10716-1-nadav.amit@gmail.com>
Date:   Fri, 3 May 2019 11:36:05 -0700
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3BB942B6-8293-455E-B5C6-3BEC537B5DC5@gmail.com>
References: <20190503111307.10716-1-nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This one regards KVM-unit-tests, of course.

> On May 3, 2019, at 4:13 AM, nadav.amit@gmail.com wrote:
>=20
> From: Nadav Amit <nadav.amit@gmail.com>
>=20
> There is no guarantee that a self-IPI would be delivered immediately.
> In eventinj, io_delay() is called after self-IPI is generated but does
> nothing.
>=20
> In general, there is mess in regard to delay() and io_delay(). There =
are
> two definitions of delay() and they do not really look on the =
timestamp
> counter and instead count invocations of "pause" (or even "nop"), =
which
> might be different on different CPUs/setups, for example due to
> different pause-loop-exiting configurations.
>=20
> To address these issues change io_delay() to really do a delay, based =
on
> timestamp counter, and move common functions into delay.[hc].
>=20
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
> lib/x86/delay.c | 9 ++++++---
> lib/x86/delay.h | 7 +++++++
> x86/eventinj.c  | 5 +----
> x86/ioapic.c    | 8 +-------
> 4 files changed, 15 insertions(+), 14 deletions(-)
>=20
> diff --git a/lib/x86/delay.c b/lib/x86/delay.c
> index 595ad24..e7d2717 100644
> --- a/lib/x86/delay.c
> +++ b/lib/x86/delay.c
> @@ -1,8 +1,11 @@
> #include "delay.h"
> +#include "processor.h"
>=20
> void delay(u64 count)
> {
> -	while (count--)
> -		asm volatile("pause");
> -}
> +	u64 start =3D rdtsc();
>=20
> +	do {
> +		pause();
> +	} while (rdtsc() - start < count);
> +}
> diff --git a/lib/x86/delay.h b/lib/x86/delay.h
> index a9bf894..a51eb34 100644
> --- a/lib/x86/delay.h
> +++ b/lib/x86/delay.h
> @@ -3,6 +3,13 @@
>=20
> #include "libcflat.h"
>=20
> +#define IPI_DELAY 1000000
> +
> void delay(u64 count);
>=20
> +static inline void io_delay(void)
> +{
> +	delay(IPI_DELAY);
> +}
> +
> #endif
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index d2dfc40..901b9db 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -7,6 +7,7 @@
> #include "apic-defs.h"
> #include "vmalloc.h"
> #include "alloc_page.h"
> +#include "delay.h"
>=20
> #ifdef __x86_64__
> #  define R "r"
> @@ -16,10 +17,6 @@
>=20
> void do_pf_tss(void);
>=20
> -static inline void io_delay(void)
> -{
> -}
> -
> static void apic_self_ipi(u8 v)
> {
> 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | =
APIC_DM_FIXED |
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index 2ac4ac6..c32dabd 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -4,6 +4,7 @@
> #include "smp.h"
> #include "desc.h"
> #include "isr.h"
> +#include "delay.h"
>=20
> static void toggle_irq_line(unsigned line)
> {
> @@ -165,13 +166,6 @@ static void test_ioapic_level_tmr(bool =
expected_tmr_before)
> 	       expected_tmr_before ? "true" : "false");
> }
>=20
> -#define IPI_DELAY 1000000
> -
> -static void delay(int count)
> -{
> -	while(count--) asm("");
> -}
> -
> static void toggle_irq_line_0x0e(void *data)
> {
> 	irq_disable();
> --=20
> 2.17.1


