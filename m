Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697D15627CD
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 02:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiGAAn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 20:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiGAAn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 20:43:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3B62497B
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 17:43:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d5so843216plo.12
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 17:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qHbDamHfdCmLVB+hBdidQaC4pQGp6BoEwn9SpFp6hCQ=;
        b=WXmwqFIa3DbqcS0hOjmq8Mo6SHrwHQVKO+gov77oBwMdrr8iahLJ7Yd3ztcoGIFMPq
         L4gAJ1eiyEoCAWxzGqsbDMExjYgEvORpFrdSnGndU1gWXR8ZMCWCvZa0YZR5njtWLadA
         aDDhN3IJ2I42Sc8chPYvsHvKGD4HpjU+anIQhMjVq8e/rqwK4DXjec3WbUJwnyqYctMv
         c7TUjDSYp/gI8L/7Dt78JpybGyXsaFqyH131UqiDRUkwsWFxrGs+JJYpQcrz1tYD2g77
         QgyDYN+LGdzb/cD5eSs69vyohf7LcWN2LUSdO6jvCnfWtibQsBDz0Fnj41AJ2eyOLhHs
         P3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qHbDamHfdCmLVB+hBdidQaC4pQGp6BoEwn9SpFp6hCQ=;
        b=H58h3Vg91spvZqgKw6rnngPHKD6izO8EbXgvowLIKMyGNv9VzcTvEQQu+/GbXFSnc1
         9cJzjqzqrc7kbPPpqYIrtGcZt7cAeQCe2rSy1FrLDcINwFaOn/O7owSONn/g3inVSORf
         8tFn2a/V7a02hHFMoPGVGglGK+LZjQUrMDYpRHbjMrBSoY2fWsX6UXa1Cnq69TRSqhsk
         L7aJb8d7k5bnyfSaJO+CpJ8VFSn3l8THn9RDKelmUaBvwtfL0d3RVtFPX7uWpNCJuX85
         9+G4Wq9yE7alolH2abS0WVF+tFkyrwr3XbneISjw5Dvs0neYQSAh1A/ZT+SLvjNDuFkg
         ofKA==
X-Gm-Message-State: AJIora+V/aUTZ33gYajuFw6lTLuFU2ErnELBVFv+j9VBlyunb9n4Lgre
        i075e5CdzukVyO0/zF+BHbun6Q==
X-Google-Smtp-Source: AGRyM1t4PlEZvbTFZ4AqC53lXcF7ogLAVeGQ/l3KXE1SwwKCbWsv3nGjOQClkwK+f3g5nViOXTA3Vg==
X-Received: by 2002:a17:90a:4f0f:b0:1ee:f746:eca7 with SMTP id p15-20020a17090a4f0f00b001eef746eca7mr14840900pjh.122.1656636232660;
        Thu, 30 Jun 2022 17:43:52 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b00163ffe73300sm14080711plk.137.2022.06.30.17.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:43:52 -0700 (PDT)
Date:   Thu, 30 Jun 2022 17:43:49 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, drjones@redhat.com,
        pbonzini@redhat.com, jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 22/27] arm64: Use code from the gnu-efi
 when booting with EFI
Message-ID: <Yr5DRYxK65G4R8Zh@google.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-23-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-23-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 11:03:19AM +0100, Nikos Nikoleris wrote:
> arm/efi/crt0-efi-aarch64.S defines the header and the handover
> sequence from EFI to a efi_main. This change includes the whole file
> in arm/cstart64.S when we compile with EFI support.
> 
> In addition, we change the handover code in arm/efi/crt0-efi-aarch64.S
> to align the stack pointer. This alignment is necessary because we
> make assumptions about cpu0's stack alignment and most importantly we
> place its thread_info at the bottom of this stack.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/cstart64.S             |  6 ++++++
>  arm/efi/crt0-efi-aarch64.S | 21 +++++++++++++++++----
>  2 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 55b41ea..08cf02f 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -15,6 +15,10 @@
>  #include <asm/thread_info.h>
>  #include <asm/sysreg.h>
>  
> +#ifdef CONFIG_EFI
> +#include "efi/crt0-efi-aarch64.S"
> +#else
> +
>  .macro zero_range, tmp1, tmp2
>  9998:	cmp	\tmp1, \tmp2
>  	b.eq	9997f
> @@ -107,6 +111,8 @@ start:
>  	bl	exit
>  	b	halt
>  
> +#endif
> +
>  .text
>  
>  /*
> diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
> index d50e78d..03d29b0 100644
> --- a/arm/efi/crt0-efi-aarch64.S
> +++ b/arm/efi/crt0-efi-aarch64.S
> @@ -111,10 +111,19 @@ section_table:
>  
>  	.align		12
>  _start:
> -	stp		x29, x30, [sp, #-32]!
> +	stp		x29, x30, [sp, #-16]!
> +
> +	/* Align sp; this is necessary due to way we store cpu0's thread_info */
>  	mov		x29, sp
> +	and		x29, x29, #THREAD_MASK
> +	mov		x30, sp
> +	mov		sp, x29
> +	str		x30, [sp, #-16]!
> +
> +	mov             x29, sp

I wasn't sure what was this x29 for. But after some googling, this is
what I found [0]:

	The frame pointer (X29) should point to the previous frame pointer saved
	on stack, with the saved LR (X30) stored after it. 

The old code ended up with x29 pointing to the right place: the previous
(x29,x30).

	|   ...  |
	|   x1   |
	|   x0   |
	|   x30  |
x29 ->	|   x29  |

In the new code x29 is pointing to:

	|   ...  |
	|   x30  |
old_sp->|   x29  |
	|   ...  |
	|   x1   |
	|   x0   |
	|   pad  |
x29 ->	| old_sp |

I think the new version can be fixed by setting x29 to the old_sp,
conveniently stored in x30:

+	mov             x30, sp

> +
> +	stp		x0, x1, [sp, #-16]!
>  
> -	stp		x0, x1, [sp, #16]
>  	mov		x2, x0
>  	mov		x3, x1
>  	adr		x0, ImageBase
> @@ -123,8 +132,12 @@ _start:
>  	bl		_relocate
>  	cbnz		x0, 0f
>  
> -	ldp		x0, x1, [sp, #16]
> +	ldp		x0, x1, [sp], #16
>  	bl		efi_main
>  
> -0:	ldp		x29, x30, [sp], #32
> +	/* Restore sp */
> +	ldr		x30, [sp], #16
> +	mov             sp, x30
> +
> +0:	ldp		x29, x30, [sp], #16
>  	ret
> -- 
> 2.25.1
> 

[0] https://developer.arm.com/documentation/den0024/a/The-ABI-for-ARM-64-bit-Architecture/Register-use-in-the-AArch64-Procedure-Call-Standard/Indirect-result-location
