Return-Path: <kvm+bounces-5136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5512F81C82C
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 11:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B264284746
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF4F17998;
	Fri, 22 Dec 2023 10:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fWmctpRm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6700017984
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 10:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6d77c6437f0so840091b3a.2
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 02:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703241177; x=1703845977; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Poe65Z2yDaErk/4LWhHXog9xzSO4kyIOOR5KpTUL6AQ=;
        b=fWmctpRm9L8ih3lsnWt4XmpGFMINtKWRdJC8TymgoECk0CD+rrtA3IyEkQRS1mhuly
         zxGGg+5mQLbLq/xThGdtPqCajjxlrydRULFXj9TsZUv33z4dVU7bc+Pi6DKVsz8bpoVK
         tyj1vDTLMN3w8M7Hfdrz/atHL5EjAIarcuaTFvTVWrcEXVWaLyAyG6EoPriBojg3cygd
         sJYEvbecTtU8Oe9uulbFL0u0wIVVFYFsvIDPHdwXeuw/kZlaXqMDTl5zY63KTvIfZevb
         EI+FbP6YA0QNXR3IBijiIEf2OrA9JgRRt9rfG0YgHf+dDGSftOuXsqaQOUfgv6uWznGi
         loEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703241177; x=1703845977;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Poe65Z2yDaErk/4LWhHXog9xzSO4kyIOOR5KpTUL6AQ=;
        b=ZoaQFQ2Rj/yzOJUQy8y2C+BL+mZA0SLcjEnkLxepNGNtYBqeUahJWiSacjWkv5mr93
         1YoF1N79b0MUcqc+WarSjeLB1ZvLLUvicKHW51aXdaihpLmuQ/RCqbNixFwYmOpQm/2j
         bK2jxNholZ/c7j4EC+FFnsKz8E7XN8kntEeUahT62nFK33j7vbbhzD7SglVqdXr7C/BY
         6r1D3AE/p4oGXoOGiEvd79A3y4taFqgCpTLD3/4l4m/w9nFpkWt+NfFCkZmidUkRDQYo
         iSeQqXLXWcS/1tYNVOHCxul+q/binONk785a7q2ZDyP5vM+2sl8ekzeG9gFgzoKKXfRj
         VVqg==
X-Gm-Message-State: AOJu0YzHlgtncSaopUbEPmexmQsF3/RO3eNMUWbU0x7BWg9L3Z8v/Zn2
	XWMqZ60H8i3Tj/685PCsRag=
X-Google-Smtp-Source: AGHT+IGvnoH20jMcgBcVZMJvPAKQdE467EA25TN2MUEGXMYmuHqbRdnZibE+be+1Ra73zZ4leCoP1w==
X-Received: by 2002:a17:902:ce89:b0:1d4:13ca:ab26 with SMTP id f9-20020a170902ce8900b001d413caab26mr885263plg.68.1703241176665;
        Fri, 22 Dec 2023 02:32:56 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id ja22-20020a170902efd600b001d078445059sm3147807plb.143.2023.12.22.02.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 02:32:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Dec 2023 20:32:51 +1000
Message-Id: <CXUSLS07KV0L.1YBG3AE5BLHU0@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, "Laurent Vivier" <lvivier@redhat.com>,
 "Shaoqin Huang" <shahuang@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 10/29] powerpc/sprs: Specify SPRs with
 data rather than code
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-11-npiggin@gmail.com>
 <49fe69ad-828e-4ac7-8693-7fd983e5152e@redhat.com>
In-Reply-To: <49fe69ad-828e-4ac7-8693-7fd983e5152e@redhat.com>

On Tue Dec 19, 2023 at 4:14 PM AEST, Thomas Huth wrote:
> On 16/12/2023 14.42, Nicholas Piggin wrote:
> > A significant rework that builds an array of 'struct spr', where each
> > element describes an SPR. This makes various metadata about the SPR
> > like name and access type easier to carry and use.
> >=20
> > Hypervisor privileged registers are described despite not being used
> > at the moment for completeness, but also the code might one day be
> > reused for a hypervisor-privileged test.
> >=20
> > Acked-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/sprs.c | 643 ++++++++++++++++++++++++++++++++++--------------=
-
> >   1 file changed, 450 insertions(+), 193 deletions(-)
> >=20
> > diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> > index 57e487ce..cd8b472d 100644
> > --- a/powerpc/sprs.c
> > +++ b/powerpc/sprs.c
> > @@ -28,231 +28,465 @@
> >   #include <asm/processor.h>
> >   #include <asm/barrier.h>
> >  =20
> > -uint64_t before[1024], after[1024];
> > -
> > -/* Common SPRs for all PowerPC CPUs */
> > -static void set_sprs_common(uint64_t val)
> > +/* "Indirect" mfspr/mtspr which accept a non-constant spr number */
> > +static uint64_t __mfspr(unsigned spr)
> >   {
> > -	mtspr(9, val);		/* CTR */
> > -	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
> > -	mtspr(274, val);	/* SPRG2 */
> > -	mtspr(275, val);	/* SPRG3 */
> > +	uint64_t tmp;
> > +	uint64_t ret;
> > +
> > +	asm volatile(
> > +"	bcl	20, 31, 1f		\n"
> > +"1:	mflr	%0			\n"
> > +"	addi	%0, %0, (2f-1b)		\n"
> > +"	add	%0, %0, %2		\n"
> > +"	mtctr	%0			\n"
> > +"	bctr				\n"
> > +"2:					\n"
> > +".LSPR=3D0				\n"
> > +".rept 1024				\n"
> > +"	mfspr	%1, .LSPR		\n"
> > +"	b	3f			\n"
> > +"	.LSPR=3D.LSPR+1			\n"
> > +".endr					\n"
> > +"3:					\n"
> > +	: "=3D&r"(tmp),
> > +	  "=3Dr"(ret)
> > +	: "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
> > +	: "lr", "ctr");
> > +
> > +	return ret;
> >   }
> >  =20
> > -/* SPRs from PowerPC Operating Environment Architecture, Book III, Ver=
s. 2.01 */
> > -static void set_sprs_book3s_201(uint64_t val)
> > +static void __mtspr(unsigned spr, uint64_t val)
> >   {
> > -	mtspr(18, val);		/* DSISR */
> > -	mtspr(19, val);		/* DAR */
> > -	mtspr(152, val);	/* CTRL */
> > -	mtspr(256, val);	/* VRSAVE */
> > -	mtspr(786, val);	/* MMCRA */
> > -	mtspr(795, val);	/* MMCR0 */
> > -	mtspr(798, val);	/* MMCR1 */
> > +	uint64_t tmp;
> > +
> > +	asm volatile(
> > +"	bcl	20, 31, 1f		\n"
> > +"1:	mflr	%0			\n"
> > +"	addi	%0, %0, (2f-1b)		\n"
> > +"	add	%0, %0, %2		\n"
> > +"	mtctr	%0			\n"
> > +"	bctr				\n"
> > +"2:					\n"
> > +".LSPR=3D0				\n"
> > +".rept 1024				\n"
> > +"	mtspr	.LSPR, %1		\n"
> > +"	b	3f			\n"
> > +"	.LSPR=3D.LSPR+1			\n"
> > +".endr					\n"
> > +"3:					\n"
> > +	: "=3D&r"(tmp)
> > +	: "r"(val),
> > +	  "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
> > +	: "lr", "ctr", "xer");
> >   }
> >  =20
> > +static uint64_t before[1024], after[1024];
> > +
> > +#define SPR_PR_READ	0x0001
> > +#define SPR_PR_WRITE	0x0002
> > +#define SPR_OS_READ	0x0010
> > +#define SPR_OS_WRITE	0x0020
> > +#define SPR_HV_READ	0x0100
> > +#define SPR_HV_WRITE	0x0200
> > +
> > +#define RW		0x333
> > +#define RO		0x111
> > +#define WO		0x222
> > +#define OS_RW		0x330
> > +#define OS_RO		0x110
> > +#define OS_WO		0x220
> > +#define HV_RW		0x300
> > +#define HV_RO		0x100
> > +#define HV_WO		0x200
> > +
> > +#define SPR_ASYNC	0x1000	/* May be updated asynchronously */
> > +#define SPR_INT		0x2000	/* May be updated by synchronous interrupt */
> > +#define SPR_HARNESS	0x4000	/* Test harness uses the register */
> > +
> > +struct spr {
> > +	const char	*name;
> > +	uint8_t		width;
> > +	uint16_t	access;
> > +	uint16_t	type;
> > +};
> > +
> > +/* SPRs common denominator back to PowerPC Operating Environment Archi=
tecture */
> > +static const struct spr sprs_common[1024] =3D {
> > +  [1] =3D {"XER",		64,	RW,		SPR_HARNESS, }, /* Compiler */
> > +  [8] =3D {"LR", 		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr *=
/
> > +  [9] =3D {"CTR",		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr *=
/
> > + [18] =3D {"DSISR",	32,	OS_RW,		SPR_INT, },
> > + [19] =3D {"DAR",		64,	OS_RW,		SPR_INT, },
> > + [26] =3D {"SRR0",	64,	OS_RW,		SPR_INT, },
> > + [27] =3D {"SRR1",	64,	OS_RW,		SPR_INT, },
> > +[268] =3D {"TB",		64,	RO	,	SPR_ASYNC, },
> > +[269] =3D {"TBU",		32,	RO,		SPR_ASYNC, },
> > +[272] =3D {"SPRG0",	64,	OS_RW,		SPR_HARNESS, }, /* Int stack */
> > +[273] =3D {"SPRG1",	64,	OS_RW,		SPR_HARNESS, }, /* Scratch */
> > +[274] =3D {"SPRG2",	64,	OS_RW, },
> > +[275] =3D {"SPRG3",	64,	OS_RW, },
> > +[287] =3D {"PVR",		32,	OS_RO, },
>
> Just a little stylish nit: You've got a space before the closing "}", but=
 no=20
> space after the opening "{". Looks a little bit weird to me. Maybe add a=
=20
> space after the "{", too?

Yes that is inconsistent. I'll fix.

Thanks,
Nick

