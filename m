Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB242304112
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391059AbhAZO4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:56:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391048AbhAZJes (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 04:34:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611653595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcrXNhlDKomMCLfJNYybeh+OpNdfCtsOzQcjyLVp37M=;
        b=X0Ifkv8l54+viFxAkaSi1fbsb4dVqMdGtdoB1qTmYmRxJ1O+JenK7RY4+J1bW1hkmBck2c
        6oNO+6jn1rXTD32EGE3EifTEbezsXCq7wHnoyvWb7TRklLbakmHRblNn1Ogfo/244L/YHO
        6vZQjUmkhlme79xyjGCsqAZHAw51GoI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-iWIgjWDLP_eWD3wCoZyWQQ-1; Tue, 26 Jan 2021 04:33:13 -0500
X-MC-Unique: iWIgjWDLP_eWD3wCoZyWQQ-1
Received: by mail-ej1-f70.google.com with SMTP id h4so4770269eja.12
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 01:33:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PcrXNhlDKomMCLfJNYybeh+OpNdfCtsOzQcjyLVp37M=;
        b=jgGsa1zoZ6h5KX3r5IPKz4T54ZxJDIh299dzxZf68t63DRh8gOkqsmiVzBVpYFiwPN
         Isf57WIA6DhxOZDzgBwlB6JKE9y3Zlf+pzvB8/uZ3+BKOAD4oaGDZlSMTYI6YU5wyo5v
         hBHrMhfnaFdSEGkLX3rWzcGE31XUo6RpA+2QvAAV5RbVn8mCSKsNhXyEe4Z/JYf8BBVo
         RA8+5oti8on74ZpCeYsNUYo7zb5Osva5P7uHLWYZ0ECHZ7DI0bPDbDDWEwFO3cHWHbRu
         V8KV+4HVKW4CVIfa8ZLjwCZwABv27OILm4XSsXZt9CKQhvazfIKT7GGtq1okxQN2NxCZ
         RRjQ==
X-Gm-Message-State: AOAM533k7OgETJQTv1sL/X5wHfbXA3qQLccr/2JLofDkRmk5/viBWVmL
        RIAEilnCsxCH28r2AKhyvg/r7AC9yniZ0DYcrXJ458AWrU1nvDXydG2BOt9Y+GdiYoljU+BIkOR
        U/g8xI/k64OSD
X-Received: by 2002:a17:907:9710:: with SMTP id jg16mr3017562ejc.286.1611653592009;
        Tue, 26 Jan 2021 01:33:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyR/KtoRSXk3hGJDjmpgB2IHv1y+LGmFyGanS7w1DkJt6Hjfu5vnx33qOdP9bqKL93pCOatbw==
X-Received: by 2002:a17:907:9710:: with SMTP id jg16mr3017552ejc.286.1611653591863;
        Tue, 26 Jan 2021 01:33:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ke7sm9484812ejc.7.2021.01.26.01.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 01:33:11 -0800 (PST)
Subject: Re: [RESEND v13 10/10] KVM: vmx/pmu: Release guest LBR event via lazy
 release mechanism
To:     Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108013704.134985-1-like.xu@linux.intel.com>
 <20210108013704.134985-11-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <310d674c-44e7-7b46-064f-7cb88c456d0f@redhat.com>
Date:   Tue, 26 Jan 2021 10:33:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108013704.134985-11-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/21 02:37, Like Xu wrote:
> The vPMU uses GUEST_LBR_IN_USE_IDX (bit 58) in 'pmu->pmc_in_use' to
> indicate whether a guest LBR event is still needed by the vcpu. If the
> vcpu no longer accesses LBR related registers within a scheduling time
> slice, and the enable bit of LBR has been unset, vPMU will treat the
> guest LBR event as a bland event of a vPMC counter and release it
> as usual. Also, the pass-through state of LBR records msrs is cancelled.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> ---
>   arch/x86/kvm/pmu.c           |  7 +++++++
>   arch/x86/kvm/pmu.h           |  4 ++++
>   arch/x86/kvm/vmx/pmu_intel.c | 17 ++++++++++++++++-
>   3 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 405890c723a1..e7c72eea07d4 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -463,6 +463,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>   	struct kvm_pmc *pmc = NULL;
>   	DECLARE_BITMAP(bitmask, X86_PMC_IDX_MAX);
>   	int i;
> +	bool extra_cleanup = false;
>   
>   	pmu->need_cleanup = false;
>   
> @@ -474,8 +475,14 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>   
>   		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
>   			pmc_stop_counter(pmc);
> +
> +		if (i == INTEL_GUEST_LBR_INUSE)
> +			extra_cleanup = true;
>   	}
>   
> +	if (extra_cleanup && kvm_x86_ops.pmu_ops->cleanup)
> +		kvm_x86_ops.pmu_ops->cleanup(vcpu);
> +

You can call this function always, it's cleaner than hardcoding 
INTEL_GUEST_LBR_INUSE.

You can also use INTEL_PMC_IDX_FIXED_VLBR directly instead of 
INTEL_GUEST_LBR_INUSE.

Paolo

