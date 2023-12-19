Return-Path: <kvm+bounces-4768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD90F81815E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 07:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3029F1F234A7
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 06:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAA68838;
	Tue, 19 Dec 2023 06:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2b1bxzH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296F3881E
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 06:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702966510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=N4xpaJDAj+StH+2TtuN2nBP+xYkEOxE/YoKqAKSnixo=;
	b=F2b1bxzHuVqkH5qnFSBO+LeOfRy4TGjWFz1XDxQxaJFB40McmlMOmXzTJYeZt/ypNeluUd
	J2m4zsV52d+h1TxgRsMRqrO81UGa3WHhtAld6XY4kYiAB43UPzqnwcerw6j37MS0YiSoPf
	cSxbru/q61ocf0oVDR61g6MlZpcIxQo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-3raFFbVuOmqYMdBsz_fSLw-1; Tue, 19 Dec 2023 01:15:02 -0500
X-MC-Unique: 3raFFbVuOmqYMdBsz_fSLw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-552853497acso1887213a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 22:15:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702966501; x=1703571301;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N4xpaJDAj+StH+2TtuN2nBP+xYkEOxE/YoKqAKSnixo=;
        b=G5Myb9Z7AVE4oz197d1b+/g+L5XBD1QPgBWfPfT1MwRVDSXxsxmD8O+zmy070C48GA
         aSNzSjOfG288pRbjAGfSgglU4xQHryX7WZ17Z8WzYd0KJAG22UrgsZYulJmTHgVRP9Fi
         ceIpcFpKiaUZ+6ueTHaj5dwiroPHHcifv9Jjet2IcSue1AKtryGACol/jlZ8tRKkpEzS
         kl1TZFu8EqxqYHrapZ6mXIhC3obhYVyncD7JSXKWtQ5iNWQdGNzwEiTnk3T48yPpdqG5
         nc+Q5jd+vwUMLdRJPRiQpEumzKcIYrGTfL6COmu5vlTkZqeDUC9NBU1/h0lwl8U/RCx1
         B+bA==
X-Gm-Message-State: AOJu0YwneTxv2dlEDcC+0uld6uiVcvcu4TfUEncWN8amoyfVP0NdOy3C
	5brrsUdlDRIULT1pzMrAGK8FwNlZQgM3LRUxobmE0tbnYRtSnCxwOM1YMde+9dAXXSphDhy1iGU
	4dOn6JJtUAgVk
X-Received: by 2002:a17:906:dd6:b0:a23:537a:a3cf with SMTP id p22-20020a1709060dd600b00a23537aa3cfmr1475063eji.135.1702966501301;
        Mon, 18 Dec 2023 22:15:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEH0UwRGUpzBCQ7lscPgvahcmeHybTOnpGKJdS5qfOqe+3S/cVYFVm7c5wX02ch1FjPqPqfsQ==
X-Received: by 2002:a17:906:dd6:b0:a23:537a:a3cf with SMTP id p22-20020a1709060dd600b00a23537aa3cfmr1475055eji.135.1702966500993;
        Mon, 18 Dec 2023 22:15:00 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-177-45.web.vodafone.de. [109.43.177.45])
        by smtp.gmail.com with ESMTPSA id uv8-20020a170907cf4800b00a1d232b39b9sm14813410ejc.184.2023.12.18.22.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Dec 2023 22:15:00 -0800 (PST)
Message-ID: <49fe69ad-828e-4ac7-8693-7fd983e5152e@redhat.com>
Date: Tue, 19 Dec 2023 07:14:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v5 10/29] powerpc/sprs: Specify SPRs with
 data rather than code
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-11-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231216134257.1743345-11-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/12/2023 14.42, Nicholas Piggin wrote:
> A significant rework that builds an array of 'struct spr', where each
> element describes an SPR. This makes various metadata about the SPR
> like name and access type easier to carry and use.
> 
> Hypervisor privileged registers are described despite not being used
> at the moment for completeness, but also the code might one day be
> reused for a hypervisor-privileged test.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/sprs.c | 643 ++++++++++++++++++++++++++++++++++---------------
>   1 file changed, 450 insertions(+), 193 deletions(-)
> 
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index 57e487ce..cd8b472d 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -28,231 +28,465 @@
>   #include <asm/processor.h>
>   #include <asm/barrier.h>
>   
> -uint64_t before[1024], after[1024];
> -
> -/* Common SPRs for all PowerPC CPUs */
> -static void set_sprs_common(uint64_t val)
> +/* "Indirect" mfspr/mtspr which accept a non-constant spr number */
> +static uint64_t __mfspr(unsigned spr)
>   {
> -	mtspr(9, val);		/* CTR */
> -	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
> -	mtspr(274, val);	/* SPRG2 */
> -	mtspr(275, val);	/* SPRG3 */
> +	uint64_t tmp;
> +	uint64_t ret;
> +
> +	asm volatile(
> +"	bcl	20, 31, 1f		\n"
> +"1:	mflr	%0			\n"
> +"	addi	%0, %0, (2f-1b)		\n"
> +"	add	%0, %0, %2		\n"
> +"	mtctr	%0			\n"
> +"	bctr				\n"
> +"2:					\n"
> +".LSPR=0				\n"
> +".rept 1024				\n"
> +"	mfspr	%1, .LSPR		\n"
> +"	b	3f			\n"
> +"	.LSPR=.LSPR+1			\n"
> +".endr					\n"
> +"3:					\n"
> +	: "=&r"(tmp),
> +	  "=r"(ret)
> +	: "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
> +	: "lr", "ctr");
> +
> +	return ret;
>   }
>   
> -/* SPRs from PowerPC Operating Environment Architecture, Book III, Vers. 2.01 */
> -static void set_sprs_book3s_201(uint64_t val)
> +static void __mtspr(unsigned spr, uint64_t val)
>   {
> -	mtspr(18, val);		/* DSISR */
> -	mtspr(19, val);		/* DAR */
> -	mtspr(152, val);	/* CTRL */
> -	mtspr(256, val);	/* VRSAVE */
> -	mtspr(786, val);	/* MMCRA */
> -	mtspr(795, val);	/* MMCR0 */
> -	mtspr(798, val);	/* MMCR1 */
> +	uint64_t tmp;
> +
> +	asm volatile(
> +"	bcl	20, 31, 1f		\n"
> +"1:	mflr	%0			\n"
> +"	addi	%0, %0, (2f-1b)		\n"
> +"	add	%0, %0, %2		\n"
> +"	mtctr	%0			\n"
> +"	bctr				\n"
> +"2:					\n"
> +".LSPR=0				\n"
> +".rept 1024				\n"
> +"	mtspr	.LSPR, %1		\n"
> +"	b	3f			\n"
> +"	.LSPR=.LSPR+1			\n"
> +".endr					\n"
> +"3:					\n"
> +	: "=&r"(tmp)
> +	: "r"(val),
> +	  "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
> +	: "lr", "ctr", "xer");
>   }
>   
> +static uint64_t before[1024], after[1024];
> +
> +#define SPR_PR_READ	0x0001
> +#define SPR_PR_WRITE	0x0002
> +#define SPR_OS_READ	0x0010
> +#define SPR_OS_WRITE	0x0020
> +#define SPR_HV_READ	0x0100
> +#define SPR_HV_WRITE	0x0200
> +
> +#define RW		0x333
> +#define RO		0x111
> +#define WO		0x222
> +#define OS_RW		0x330
> +#define OS_RO		0x110
> +#define OS_WO		0x220
> +#define HV_RW		0x300
> +#define HV_RO		0x100
> +#define HV_WO		0x200
> +
> +#define SPR_ASYNC	0x1000	/* May be updated asynchronously */
> +#define SPR_INT		0x2000	/* May be updated by synchronous interrupt */
> +#define SPR_HARNESS	0x4000	/* Test harness uses the register */
> +
> +struct spr {
> +	const char	*name;
> +	uint8_t		width;
> +	uint16_t	access;
> +	uint16_t	type;
> +};
> +
> +/* SPRs common denominator back to PowerPC Operating Environment Architecture */
> +static const struct spr sprs_common[1024] = {
> +  [1] = {"XER",		64,	RW,		SPR_HARNESS, }, /* Compiler */
> +  [8] = {"LR", 		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
> +  [9] = {"CTR",		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
> + [18] = {"DSISR",	32,	OS_RW,		SPR_INT, },
> + [19] = {"DAR",		64,	OS_RW,		SPR_INT, },
> + [26] = {"SRR0",	64,	OS_RW,		SPR_INT, },
> + [27] = {"SRR1",	64,	OS_RW,		SPR_INT, },
> +[268] = {"TB",		64,	RO	,	SPR_ASYNC, },
> +[269] = {"TBU",		32,	RO,		SPR_ASYNC, },
> +[272] = {"SPRG0",	64,	OS_RW,		SPR_HARNESS, }, /* Int stack */
> +[273] = {"SPRG1",	64,	OS_RW,		SPR_HARNESS, }, /* Scratch */
> +[274] = {"SPRG2",	64,	OS_RW, },
> +[275] = {"SPRG3",	64,	OS_RW, },
> +[287] = {"PVR",		32,	OS_RO, },

Just a little stylish nit: You've got a space before the closing "}", but no 
space after the opening "{". Looks a little bit weird to me. Maybe add a 
space after the "{", too?

  Thomas


