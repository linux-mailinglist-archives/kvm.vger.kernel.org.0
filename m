Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9DC6C9AE9
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 07:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjC0FjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 01:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjC0FjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 01:39:16 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8935F4C07
        for <kvm@vger.kernel.org>; Sun, 26 Mar 2023 22:39:11 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c18so7297061ple.11
        for <kvm@vger.kernel.org>; Sun, 26 Mar 2023 22:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679895551;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6RQjB5AQU67VhsjUHIEE77so4M91TfQuFLRA4PW0yk=;
        b=lS3ZQ0h8ZFGpvKXr2Ja5VCoFYF+tri8nncZ2njg/TckYYTyfj7mjp/T6O7xr2lUmDs
         dra8EyIJSkYGErjN9MmcQ8fXGSyGD6G02jEVHsc871M+kDATnWcm8O/MSwK/SQ2PTxoY
         QZmLVBb7exCaq8oSTyvZoantl58x6voAeJHid0a2mMYWd4fkW1+IOIj+39dUppZkGBOp
         FFvbF2fU7PFghPAR2C9hb8g3/Sys8L2RnizAkQJ8qayzwJGgZcJqwKaEDoMUTDTreODz
         f5falHjY1R5RaPvTmOohL6oGP1Q2piB95zPDP/EYOqvh3b8iIUr8wzv5gLmzKY5VuuZx
         0RlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679895551;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u6RQjB5AQU67VhsjUHIEE77so4M91TfQuFLRA4PW0yk=;
        b=fXluebtqlewcjt7DFnKJi9bUwecoNHPjBkBSEJHjB8XZkPIvDjF9iCORohXvkcZqlB
         JwoOP9eZsr651dsTfpG6eEVNbXATs23XuwwEebxjVBpIqffNhaizeTHAQ4zCCSXi3uky
         wtLrc/UwseyctYw0xjM2/HEd7uez85tNzjqOp9JnCOh953YjQ+93Mh6o2J9VSplg0qZC
         LaWCCsosLLlM6IHrQBmUbHieWB935WBHUSWtiR1Lo7VtsOD3jMd8yH9zSd3Rz4yO3+XC
         oQcWfzb2pzEUj8HI6OWeUf7Vy3ZQyRHl2aZp2Zhz80my7OFGQNVmdAyTFD0ZGYL4ZFi3
         6xqw==
X-Gm-Message-State: AO0yUKWIh9WmmtcsdV2S86dEnyvskcLAvQeCbA6i/BSDUEVIMqmHRyJT
        t4dMGDuujJuNckGn3t9bFZDN1D7j8EA=
X-Google-Smtp-Source: AK7set96Mple3307x12nOAs4ZV9sKCWYqBvaAlJNNetHDhAKMT3lYyDC1cWXzzkKC3+5vIL7ca0M2w==
X-Received: by 2002:a05:6a20:1221:b0:d9:5a7c:b1c5 with SMTP id v33-20020a056a20122100b000d95a7cb1c5mr9849309pzf.11.1679895551023;
        Sun, 26 Mar 2023 22:39:11 -0700 (PDT)
Received: from localhost ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id u20-20020aa78494000000b005d296facfa3sm18048021pfn.36.2023.03.26.22.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Mar 2023 22:39:10 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 27 Mar 2023 15:39:06 +1000
Message-Id: <CRGX9S9AO7V0.3LM275UZQB6CZ@bobo>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests v2 03/10] powerpc: abstract H_CEDE calls into a
 sleep functions
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-4-npiggin@gmail.com>
 <de36dbe8-de4a-ba05-12f7-2b8a37ef552a@redhat.com>
In-Reply-To: <de36dbe8-de4a-ba05-12f7-2b8a37ef552a@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu Mar 23, 2023 at 10:12 PM AEST, Thomas Huth wrote:
> On 20/03/2023 08.03, Nicholas Piggin wrote:
> > This consolidates several implementations, and it no longer leaves
> > MSR[EE] enabled after the decrementer interrupt is handled, but
> > rather disables it on return.
> >=20
> > The handler no longer allows a continuous ticking, but rather dec
> > has to be re-armed and EE re-enabled (e.g., via H_CEDE hcall) each
> > time.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/powerpc/asm/handlers.h  |  2 +-
> >   lib/powerpc/asm/ppc_asm.h   |  1 +
> >   lib/powerpc/asm/processor.h |  7 +++++++
> >   lib/powerpc/handlers.c      | 10 ++++-----
> >   lib/powerpc/processor.c     | 42 ++++++++++++++++++++++++++++++++++++=
+
> >   powerpc/sprs.c              |  6 +-----
> >   powerpc/tm.c                | 20 +-----------------
> >   7 files changed, 57 insertions(+), 31 deletions(-)
> >=20
> > diff --git a/lib/powerpc/asm/handlers.h b/lib/powerpc/asm/handlers.h
> > index 64ba727..e4a0cd4 100644
> > --- a/lib/powerpc/asm/handlers.h
> > +++ b/lib/powerpc/asm/handlers.h
> > @@ -3,6 +3,6 @@
> >  =20
> >   #include <asm/ptrace.h>
> >  =20
> > -void dec_except_handler(struct pt_regs *regs, void *data);
> > +void dec_handler_oneshot(struct pt_regs *regs, void *data);
> >  =20
> >   #endif /* _ASMPOWERPC_HANDLERS_H_ */
> > diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
> > index 1b85f6b..6299ff5 100644
> > --- a/lib/powerpc/asm/ppc_asm.h
> > +++ b/lib/powerpc/asm/ppc_asm.h
> > @@ -36,6 +36,7 @@
> >   #endif /* __BYTE_ORDER__ */
> >  =20
> >   /* Machine State Register definitions: */
> > +#define MSR_EE_BIT	15			/* External Interrupts Enable */
> >   #define MSR_SF_BIT	63			/* 64-bit mode */
> >  =20
> >   #endif /* _ASMPOWERPC_PPC_ASM_H */
> > diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
> > index ac001e1..ebfeff2 100644
> > --- a/lib/powerpc/asm/processor.h
> > +++ b/lib/powerpc/asm/processor.h
> > @@ -20,6 +20,8 @@ static inline uint64_t get_tb(void)
> >  =20
> >   extern void delay(uint64_t cycles);
> >   extern void udelay(uint64_t us);
> > +extern void sleep_tb(uint64_t cycles);
> > +extern void usleep(uint64_t us);
> >  =20
> >   static inline void mdelay(uint64_t ms)
> >   {
> > @@ -27,4 +29,9 @@ static inline void mdelay(uint64_t ms)
> >   		udelay(1000);
> >   }
> >  =20
> > +static inline void msleep(uint64_t ms)
> > +{
> > +	usleep(ms * 1000);
> > +}
> > +
> >   #endif /* _ASMPOWERPC_PROCESSOR_H_ */
> > diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
> > index c8721e0..296f14f 100644
> > --- a/lib/powerpc/handlers.c
> > +++ b/lib/powerpc/handlers.c
> > @@ -9,15 +9,13 @@
> >   #include <libcflat.h>
> >   #include <asm/handlers.h>
> >   #include <asm/ptrace.h>
> > +#include <asm/ppc_asm.h>
> >  =20
> >   /*
> >    * Generic handler for decrementer exceptions (0x900)
> > - * Just reset the decrementer back to the value specified when registe=
ring the
> > - * handler
> > + * Return with MSR[EE] disabled.
> >    */
> > -void dec_except_handler(struct pt_regs *regs __unused, void *data)
> > +void dec_handler_oneshot(struct pt_regs *regs, void *data)
> >   {
> > -	uint64_t dec =3D *((uint64_t *) data);
> > -
> > -	asm volatile ("mtdec %0" : : "r" (dec));
> > +	regs->msr &=3D ~(1UL << MSR_EE_BIT);
> >   }
> > diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> > index ec85b9d..e77a240 100644
> > --- a/lib/powerpc/processor.c
> > +++ b/lib/powerpc/processor.c
> > @@ -10,6 +10,8 @@
> >   #include <asm/ptrace.h>
> >   #include <asm/setup.h>
> >   #include <asm/barrier.h>
> > +#include <asm/hcall.h>
> > +#include <asm/handlers.h>
> >  =20
> >   static struct {
> >   	void (*func)(struct pt_regs *, void *data);
> > @@ -54,3 +56,43 @@ void udelay(uint64_t us)
> >   {
> >   	delay((us * tb_hz) / 1000000);
> >   }
> > +
> > +void sleep_tb(uint64_t cycles)
> > +{
> > +	uint64_t start, end, now;
> > +
> > +	start =3D now =3D get_tb();
> > +	end =3D start + cycles;
> > +
> > +	while (end > now) {
> > +		uint64_t left =3D end - now;
> > +
> > +		/* Could support large decrementer */
> > +		if (left > 0x7fffffff)
> > +			left =3D 0x7fffffff;
> > +
> > +		asm volatile ("mtdec %0" : : "r" (left));
> > +		handle_exception(0x900, &dec_handler_oneshot, NULL);
>
> Wouldn't it be better to first call handle_exception() before moving=20
> something into the decrementer?

It shouldn't really matter, the drecrementer could be anything here
(probably it's already -ve here if it starts at zero). It only matters
when MSR[EE]=3D1 or we make the H_CEDE call.

I'll add a comment at least.

Thanks,
Nick
