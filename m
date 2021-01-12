Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199FE2F39DE
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 20:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392838AbhALTS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 14:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389021AbhALTSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 14:18:25 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AAAC061795
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:18:10 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id h186so1987805pfe.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y3BN6cdHxTPioMesR4FBydVJOaDJxTOw5Es7yLBlgtQ=;
        b=Bjo+TQpWX3cDqpcuJkY96UOghaTmpGhXsI+LVtsfjQ6+BGjFmU06v1fGF9UcFMlPBz
         cExL1+MMhC2VIRF2TbJJTVcTx3bDc0tXzyjtUq2FAZTrDTZkRv8Netu3/zmUvbgfGoDH
         8AJVAUh9EUHvhqCdaQ6uA2V5efeqP1dK6U9TAQ92hqmHVFE8f1iIUKJzF/AmBc8LmGmD
         kVTDW9Lc+CF9eYTWLAUrrpUWAlr00YeIuqbRRtdCIZjFIuo+49ZCd4ScgIkb3D7mqrvr
         fhFRDZoP81lqG4HeWPalex0+TgKjrW2O5VN4Y6ucoUdDHE7peJwqXc3AWy3l1XdZr6Gx
         t3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y3BN6cdHxTPioMesR4FBydVJOaDJxTOw5Es7yLBlgtQ=;
        b=JvM/BwIOsr8BHwSLNpn95t3EhbT1N9j/2IWqAVUSO3dddky3EYOraAPWLR3HWAg98n
         3/2zRC9IKD+tAzpZPJNUDZ8moS+Y+fwckeQnCdCPHTb7xa2MJQVflV+N2WUafEZ/B1BF
         HvaEKSvHvdenbunhsk9QDpg1jZUNcDPab4Cfc2r7BPrQMS3M5U6vLnPy3miiJp+AVAQC
         ZWbbUuFzVzYjHI2m0pn5WJoW+seLLNDXryofzd0v7dvmj5sf4PzWjFkrOB9m/N6YIOWM
         hnMtjJbxcOQobqaWJPzDuoLOjG26I3xJLHMQjB+ChkqDfuYwsMdjXbjRT+6gNQI8RbiU
         WKMA==
X-Gm-Message-State: AOAM532qIGwNGnBEkoee4jvqzAVXm1lra1YBGjHyQFBVQUP7h2DQLfim
        UH5VeZAHUpMZduC99vd5mjVEMQ==
X-Google-Smtp-Source: ABdhPJw2cjhmkHAzXKnmpwEFKsmWLUpJQuEDmFw0r2VJArhupFouvew9WPFjuAS2lmY15rrfyGHyMg==
X-Received: by 2002:a62:5e44:0:b029:1a4:daae:e765 with SMTP id s65-20020a625e440000b02901a4daaee765mr757856pfb.8.1610479089830;
        Tue, 12 Jan 2021 11:18:09 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id g26sm3995862pfo.35.2021.01.12.11.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 11:18:09 -0800 (PST)
Date:   Tue, 12 Jan 2021 11:18:02 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for VMCB address check change
Message-ID: <X/316tCByxsBQP5t@google.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <20210112063703.539893-2-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112063703.539893-2-wei.huang2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Wei Huang wrote:
> New AMD CPUs have a change that checks VMEXIT intercept on special SVM
> instructions before checking their EAX against reserved memory region.
> This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, KVM
> doesn't need to intercept and emulate #GP faults for such instructions
> because #GP isn't supposed to be triggered.
> 
> Co-developed-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/svm/svm.c             | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b887825f12..ea89d6fdd79a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -337,6 +337,7 @@
>  #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
>  #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
>  #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
> +#define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */

Heh, KVM should advertise this to userspace by setting the kvm_cpu_cap bit.  KVM
KVM forwards relevant VM-Exits to L1 without checking if rAX points at an
invalid L1 GPA.

>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>  #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 74620d32aa82..451b82df2eab 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -311,7 +311,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  	svm->vmcb->save.efer = efer | EFER_SVME;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
>  	/* Enable GP interception for SVM instructions if needed */
> -	if (efer & EFER_SVME)
> +	if ((efer & EFER_SVME) && !boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
>  		set_exception_intercept(svm, GP_VECTOR);
>  
>  	return 0;
> -- 
> 2.27.0
> 
