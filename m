Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC8D368643
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 19:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhDVR55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 13:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbhDVR54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 13:57:56 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D92C06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 10:57:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n10so12775810plc.0
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 10:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LPNuZ3CwmXmYC2FOdA5xPRoooqia6WEbrp0AxJN/oo4=;
        b=OeEcI35L89PDF8PPgJo+bs3JIK1XHd3+xKZjxRBj+o8xlZ0RPonvDHoB2pV+5UnVM0
         ewLSSp38E+cded4uNVa8IFLQsTH3MTwcEnkxZXc5dn/h13NJyAd1UMgcjt9zYc4lyJN7
         JDZa9emOMI18adv2qr6e38Hr6AFZMx0sKD1bxAN/t/BwY1uRVOI/0TUf5SshivLtg7/V
         hnT3O4cqvp/qB5wpcERGe51zIcqavx13AFkxnLi+nc+0ja67ayIl/SO9IRPMqVcq7JgX
         v4rYV5WvMhfUYJoZ97HGB3Up46XpVNq+OJFNPS1bPaAGPa2Zm/Nvb9eU1EQn/Dm8t78N
         sOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LPNuZ3CwmXmYC2FOdA5xPRoooqia6WEbrp0AxJN/oo4=;
        b=jz6LMS9Jl/0C2ynj+XtF0ZZpcyvbVCO0psIRz1E6SmIa5RKsxfCV/59OuOnGFJKBih
         2bRDV02QxUmY6p/9PmTMeVWZ52Tc3FazAP8lCrgloU3LOoqiWULCGqK1pOex1XoDIih8
         mLm8imjqxkd3Qij13ils93MdNIiQSImeHAiat+CDIxcCBAqfFtk0pNcm6YpIznL5ANmS
         uYReCD1VbQJ06grz7QUrXDtkDNG1d2c2x53ZB/gZAGQDYM0lvBka4ctrqDmrFkqJ/jLo
         By9MhDy6SfGbNSgDSkZJWgyh/DzwzMcYtPiPZ0y9JygPij0ZFDrY/IufgMH9CLo6Y3Va
         iDqw==
X-Gm-Message-State: AOAM532W01Vv3oPIzsn5mX5xKVXUma7w9PB2jVE9TLg+SjkWEymhNHwc
        z27QYCbbJKXEzV8+eOck3gHg3Pum+yJKsA==
X-Google-Smtp-Source: ABdhPJznX75Tv1RHoHmp8l3Wt8EmOFlOjAYTOggoVUhdXa2f1YlzYNNioOpfOa8f77C79SbSTd5QFA==
X-Received: by 2002:a17:90a:6c88:: with SMTP id y8mr5450316pjj.38.1619114239227;
        Thu, 22 Apr 2021 10:57:19 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a6sm2775349pfh.135.2021.04.22.10.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 10:57:18 -0700 (PDT)
Date:   Thu, 22 Apr 2021 17:57:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 01/14] x86/cstart: Don't use MSR_GS_BASE
 in 32-bit boot code
Message-ID: <YIG4+0WW7K9zw/f+@google.com>
References: <20210422030504.3488253-1-seanjc@google.com>
 <20210422030504.3488253-2-seanjc@google.com>
 <24a92fa2-6d31-f1c2-6661-8b6f3f41766c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24a92fa2-6d31-f1c2-6661-8b6f3f41766c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Paolo Bonzini wrote:
> On 22/04/21 05:04, Sean Christopherson wrote:
> > Load the per-cpu GS.base for 32-bit build by building a temporary GDT
> > and loading a "real" segment.  Using MSR_GS_BASE is wrong and broken,
> > it's a 64-bit only MSR and does not exist on 32-bit CPUs.  The current
> > code works only because 32-bit KVM VMX incorrectly disables interception
> > of MSR_GS_BASE, and no one runs KVM on an actual 32-bit physical CPU,
> > i.e. the MSR exists in hardware and so everything "works".
> > 
> > 32-bit KVM SVM is not buggy and correctly injects #GP on the WRMSR, i.e.
> > the tests have never worked on 32-bit SVM.
> 
> Hmm, this breaks task switch.  But setting up separate descriptors is
> not hard:

Much better.

> diff --git a/x86/cstart.S b/x86/cstart.S
> index 489c561..7d9ed96 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -58,6 +58,10 @@ tss_descr:
>          .rept max_cpus
>          .quad 0x000089000000ffff // 32-bit avail tss
>          .endr
> +percpu_descr:
> +        .rept max_cpus
> +        .quad 0x00cf93000000ffff // 32-bit data segment for perCPU area
> +        .endr
>  gdt32_end:
> 
>  i = 0
> @@ -89,13 +93,23 @@ mb_flags = 0x0
>  	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
>  mb_cmdline = 16
> 
> -MSR_GS_BASE = 0xc0000101
> -
>  .macro setup_percpu_area
>  	lea -4096(%esp), %eax
> -	mov $0, %edx
> -	mov $MSR_GS_BASE, %ecx
> -	wrmsr
> +
> +	/* fill GS_BASE in the GDT */
> +	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %ebx

Using %ebx crushes the mbi_bootinfo pointer.  The easiest fix is to use %edx or
%ecx.

> +	mov (%ebx), %ebx

No need to load the address into a reg, just drop the "$" above and encode
"mov [imm32], <reg>".

Want to fold this into your patch?

diff --git a/x86/cstart.S b/x86/cstart.S
index 7d9ed96..fb6eda5 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -97,17 +97,16 @@ mb_cmdline = 16
        lea -4096(%esp), %eax

        /* fill GS_BASE in the GDT */
-       mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %ebx
-       mov (%ebx), %ebx
-       shr $24, %ebx
-       or %ax, percpu_descr+2(,%ebx,8)
+       mov (APIC_DEFAULT_PHYS_BASE + APIC_ID), %edx
+       shr $24, %edx
+       or %ax, percpu_descr+2(,%edx,8)

        shr $16, %eax
-       or %al, percpu_descr+4(,%ebx,8)
-       or %ah, percpu_descr+7(,%ebx,8)
+       or %al, percpu_descr+4(,%edx,8)
+       or %ah, percpu_descr+7(,%edx,8)

        lgdtl gdt32_descr
-       lea percpu_descr-gdt32(,%ebx,8), %eax
+       lea percpu_descr-gdt32(,%edx,8), %eax
        mov %ax, %gs

 .endm

> +	shr $24, %ebx
> +	or %ax, percpu_descr+2(,%ebx,8)
> +
> +	shr $16, %eax
> +	or %al, percpu_descr+4(,%ebx,8)
> +	or %ah, percpu_descr+7(,%ebx,8)
> +
> +	lgdtl gdt32_descr
> +	lea percpu_descr-gdt32(,%ebx,8), %eax
> +	mov %ax, %gs
> +
>  .endm
> 
>  .macro setup_segments
> @@ -188,16 +202,14 @@ load_tss:
>  	mov (%eax), %eax
>  	shr $24, %eax
>  	mov %eax, %ebx
> -	shl $3, %ebx
>  	mov $((tss_end - tss) / max_cpus), %edx
>  	imul %edx
>  	add $tss, %eax
> -	mov %ax, tss_descr+2(%ebx)
> +	mov %ax, tss_descr+2(,%ebx,8)
>  	shr $16, %eax
> -	mov %al, tss_descr+4(%ebx)
> -	shr $8, %eax
> -	mov %al, tss_descr+7(%ebx)
> -	lea tss_descr-gdt32(%ebx), %eax
> +	mov %al, tss_descr+4(,%ebx,8)
> +	mov %ah, tss_descr+7(,%ebx,8)

Is there a functional change here?  If not, can you throw this into a separate
patch?

Thanks!

> +	lea tss_descr-gdt32(,%ebx,8), %eax
>  	ltr %ax
>  	ret
> 
> 
> Paolo
> 
