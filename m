Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8ABE3F6DAF
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 05:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbhHYDbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 23:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhHYDbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 23:31:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79497C061757;
        Tue, 24 Aug 2021 20:31:05 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so3209760pjw.2;
        Tue, 24 Aug 2021 20:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TK5iNDaPIK/+9t/imq7wDGwK0Vk2+RZy1o2tqwUHs00=;
        b=vNcOH120mICPZunlbCZRkm4NiDqkGuHGQnxE16Dpkgfhr0+VEY9VIkxsWJ5A/MVjK+
         JaWSGBXk+Ny6bMtxnTK8htCejJwvwGJEkFy2W0POBYJPg7J/Zt4di+VzzIoCmIdhIJp6
         ohR2wb8plRHnpjlRS0oimIBLn/LfRaKnW8bqArbR+gQwsZQLNMiHO5Oqo6ZntMn6ugpU
         rfo0GtzzKasp6ceQg5nsMfKPLPJv1n6VKfBnodma3sC/kzSkvYMsLqIyaZcRwsMJ6OWQ
         LXDs3B1PEWbVh0oOiAlCJTddVd7Lzi7nNxy+nVubKFCzDEf5IKbqk4rRNCYxxxu5i2mD
         sYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TK5iNDaPIK/+9t/imq7wDGwK0Vk2+RZy1o2tqwUHs00=;
        b=mZmJtgUb9kLR/tzpIovchwjzTk+Nyggevyal6WItc9stQN+twnaF1yBJVxxGSTfXkz
         aAqH8gQJcYxhtBR8+LsafUaIjOk09l6wEN+o0u+/XPfS70xNfa+P48chheZl3+Zyswp3
         64mC2iOqPxqYeNbe3/9kTAlPPIcLodlOAtXr6r0Qzr57xLHlRQpt/g0/D88A1aQ8cyMo
         lBPJKpHSjIlaE5PEBucfaBGxfZTrVZ8x+SEJxtSP8gdaaYG8XWkxJ5FnCApH9dGLzzvk
         iokYMbMw00LnD7da05rWAmp1CqX31jmEQEKweoW8TWW6d88Ayd1bUtAHDRgsyHpbJtYY
         fYQw==
X-Gm-Message-State: AOAM532ak6wTDa6KtxY0cp+11UhPaKEsIXQFQjgXsunMho1Agx0OTbkQ
        RRFhDgZuTqrvHypK0f2KRhM=
X-Google-Smtp-Source: ABdhPJw/OzLzJObgZNE4OoC27eBtl+nTDQ+yqONoupUwU1uDbZe7ViXRbIdwOvvnYgg1w4Vxcj6wPg==
X-Received: by 2002:a17:902:c38d:b0:135:509b:7ba0 with SMTP id g13-20020a170902c38d00b00135509b7ba0mr9210426plg.50.1629862264929;
        Tue, 24 Aug 2021 20:31:04 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y1sm24059178pga.50.2021.08.24.20.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 20:31:04 -0700 (PDT)
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        "Alexander Shishkin (hwtracing + intel_th + stm + R:perf)" 
        <alexander.shishkin@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-4-xiaoyao.li@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 3/5] KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on
 other CPUID bit
Message-ID: <711265db-f634-36ac-40d2-c09cea825df6@gmail.com>
Date:   Wed, 25 Aug 2021 11:30:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824110743.531127-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Alexander

On 24/8/2021 7:07 pm, Xiaoyao Li wrote:
> Per Intel SDM, RTIT_CTL_BRANCH_EN bit has no dependency on any CPUID
> leaf 0x14.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7ed96c460661..4a70a6d2f442 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7116,7 +7116,8 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>   
>   	/* Initialize and clear the no dependency bits */
>   	vmx->pt_desc.ctl_bitmask = ~(RTIT_CTL_TRACEEN | RTIT_CTL_OS |
> -			RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC);
> +			RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC |
> +			RTIT_CTL_BRANCH_EN);
>   
>   	/*
>   	 * If CPUID.(EAX=14H,ECX=0):EBX[0]=1 CR3Filter can be set otherwise
> @@ -7134,12 +7135,11 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>   				RTIT_CTL_CYC_THRESH | RTIT_CTL_PSB_FREQ);
>   
>   	/*
> -	 * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn BranchEn and
> -	 * MTCFreq can be set
> +	 * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn and MTCFreq can be set

If CPUID.(EAX=14H,ECX=0):EBX[3]=1,

	"indicates support of MTC timing packet and suppression of COFI-based packets."

Per 31.2.5.4 Branch Enable (BranchEn),

	"If BranchEn is not set, then relevant COFI packets (TNT, TIP*, FUP, MODE.*) 
are suppressed."

I think if the COFI capability is suppressed, the software can't set the 
BranchEn bit, right ?

>   	 */
>   	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc))
>   		vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_MTC_EN |
> -				RTIT_CTL_BRANCH_EN | RTIT_CTL_MTC_RANGE);
> +					      RTIT_CTL_MTC_RANGE);
>   
>   	/* If CPUID.(EAX=14H,ECX=0):EBX[4]=1 FUPonPTW and PTWEn can be set */
>   	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_ptwrite))
> 
