Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812FD553E8C
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 00:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354033AbiFUWcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 18:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiFUWct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 18:32:49 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC4F3190B
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:32:48 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 184so14377146pga.12
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/3O2LWBbOXfJ4ZXSx1dx9gcYSMerGZQCAOg59Vfth3s=;
        b=E5T4dLgRo5shBqjOJlgImNBqjxAzXPnOskJ+63lPpTwj/rSC6rtEUqJb9lywFaJ0FC
         50Ds5jXdaaw6BsGnu2vuuP/SCQv7W8zUx+DQ4yhhcTnF0NAyrEFxFAxqbn4G2XpEPF7i
         vqm4J0ySnIFUk61Te1aeDmnplW5OFKTXMi2mJmFuUZuCFmJ1rPQ42V+aWR+MsoIH1S+y
         9oTBkxWgl5NrKoxbE4N32l95bZ55oCt2IaP6UKMX320uD5gPmroXt59/j4axmaUbW8Qs
         mv3Z4l9Zp/WDNVzoJIgF1RIb22sgAU0TN0tvFgh3NFofQOcuqV0mCnfuZug8bghrm+Lv
         HTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/3O2LWBbOXfJ4ZXSx1dx9gcYSMerGZQCAOg59Vfth3s=;
        b=zSmOogJQ5sIyaL+blemoqZaDxdJ88Ueb8l9J+jLPPPgzIpnxOOzjL2QCancF3tuZWz
         xWkMpugVKcKYNwpQDyAr/jt18d4lN5C4ALJh7CN2+zeif6KXeXxEjsawgPfoPF6804UB
         Na1zG7usvwuV5QedvG1UR33/aF2QK7mCdQcPCXWexEpBlplV7Jauy4a3dNiUpC4Nv4sG
         7VYIzFRoRuZT7vQgtYAfHE+38PT87FIOW12upSw/rBrpuDCUtiRf/ySOg43i1PufyfRk
         UFpjX0rbjaZL+eKl/iwGCK1z9xi5PfkPKUq9S/JvWonhKRxfuU6vwWzvDb75Ga8b3lF7
         0YCQ==
X-Gm-Message-State: AJIora+c2RL1uSwltP24tPbR2P3LXxFVSny27R0Ibmat7qsVtl4kSZaT
        gClvOcrwAT4rgMyQdhuECkN02w==
X-Google-Smtp-Source: AGRyM1vIl7PHb/fWKHNlfq1vvYAhO0fNZounDNCSaSBhT1SZ4x/ogXV8GnOQwQrPGee8fVvKAcjDTQ==
X-Received: by 2002:a62:1652:0:b0:525:4253:6f5a with SMTP id 79-20020a621652000000b0052542536f5amr1775803pfw.59.1655850767898;
        Tue, 21 Jun 2022 15:32:47 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902ed8b00b00161e50e2245sm7971291plj.178.2022.06.21.15.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:32:47 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:32:44 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 19/23] arm64: Use code from the gnu-efi
 when booting with EFI
Message-ID: <YrJHDBeTGgd+dpDP@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-20-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-20-nikos.nikoleris@arm.com>
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

On Fri, May 06, 2022 at 09:56:01PM +0100, Nikos Nikoleris wrote:
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
>  arm/efi/crt0-efi-aarch64.S | 17 +++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
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
> index d50e78d..11a062d 100644
> --- a/arm/efi/crt0-efi-aarch64.S
> +++ b/arm/efi/crt0-efi-aarch64.S
> @@ -111,10 +111,19 @@ section_table:
>  
>  	.align		12
>  _start:
> -	stp		x29, x30, [sp, #-32]!
> +	stp		x29, x30, [sp, #-16]!

Is this and the "ldp x29, x30, [sp], #16" change below needed?
why is #-32 not good?

> +
> +	// Align sp; this is necessary due to way we store cpu0's thread_info

/* */ comment style

>  	mov		x29, sp
> +	and		x29, x29, #THREAD_MASK
> +	mov		x30, sp
> +	mov		sp, x29
> +	str		x30, [sp, #-32]!
> +
> +	mov             x29, sp
>  
>  	stp		x0, x1, [sp, #16]
> +
>  	mov		x2, x0
>  	mov		x3, x1
>  	adr		x0, ImageBase
> @@ -126,5 +135,9 @@ _start:
>  	ldp		x0, x1, [sp, #16]
>  	bl		efi_main
>  
> -0:	ldp		x29, x30, [sp], #32
> +	// Restore sp

/* */ comment style

> +	ldr		x30, [sp]

I'm not able to understand this. Is this ldr restoring the value pushed
with "str x30, [sp, #-32]!" above? in that case, shouldn't this be at
[sp - 32]? But, given that this code is unreachable when efi_main is
called, do you even need to restore the sp?

> +	mov             sp, x30
> +
> +0:	ldp		x29, x30, [sp], #16
>  	ret
> -- 
> 2.25.1
> 
