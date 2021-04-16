Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054A6361B8C
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 10:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhDPI1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 04:27:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240292AbhDPI1J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Apr 2021 04:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618561605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GDfR8iVh8XSN4o8S9XIZ+vsfxmtqUP1R7YuCLZyLUbM=;
        b=f5BpE1EO5amrg6SW2ld+EhkrDGaL64c0ZBhoTLkIsE/2ZeYgEhLVOvpsWCxRBRdr7sBEmc
        jl5J/tWELPrrwwxBStvtQD++ea8pXiMoZU3tbevJmeov0BV/qGjK8+Ef9HdFJg9G9EEcl7
        79Ir+1++gGOtczPzBOMuTxx1MXTKUjw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-JGMkAiqmPAmDJ01pclWsew-1; Fri, 16 Apr 2021 04:26:43 -0400
X-MC-Unique: JGMkAiqmPAmDJ01pclWsew-1
Received: by mail-ed1-f71.google.com with SMTP id z3-20020a05640240c3b029037fb0c2bd3bso6644393edb.23
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 01:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GDfR8iVh8XSN4o8S9XIZ+vsfxmtqUP1R7YuCLZyLUbM=;
        b=sRMgybg308d0HcUXTx6Th9Ane3pq8OVCSjnVuJ41aFWB6gSsd+nl2YGoMBQeICgl2r
         wHkb4dgEjhBk+/NBMszfuAbSzOGT3sqzh4ktd/LDUAgt9tfUNADlO2cfASF1lm5eNF9A
         qLhaK9Osv9P2+MN1spi7glNmo4ZaYNA/y9Ih3ZnI3lhz6K4Oq/L00n8lpHId7R2OFGhA
         Rx4JJ5UlDkY0pJwyfPF1SQcZA6ppKF6y7qbwsMi8PKtmz1cniVvBi+oLsGKmKC6PYejm
         /w6i2eB86NvYU9LF007FlQZsGejRi0QbaZ0is1fgbcbSD2PjFW5lxtPRiF10Yfc9pCGg
         1/yQ==
X-Gm-Message-State: AOAM5312Lbaeo6nMRk8hCTZW3ZtX5Zax0btzjNfsJRUNYpL0EqeBHZcT
        LJqEhQ9awXJ5U0fXgqixogZlUcFuyuP6tYJGOu6+CbdLiPTEuD/XyrL1AJ5742J8UwHBnoPcTn3
        YKJd9H/Kw+3F3
X-Received: by 2002:a05:6402:7cf:: with SMTP id u15mr2496404edy.297.1618561602412;
        Fri, 16 Apr 2021 01:26:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjCNyDz0otPSAn5rP293qV2aUO2LfE/x9sXa+u6jjL4WGAVGA2gNPkgIpakzrGSlP22der0Q==
X-Received: by 2002:a05:6402:7cf:: with SMTP id u15mr2496382edy.297.1618561602274;
        Fri, 16 Apr 2021 01:26:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w13sm4585188edc.81.2021.04.16.01.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 01:26:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v2 1/7] hyperv: Detect Nested virtualization support for
 SVM
In-Reply-To: <9d12558549bc0c6f179b26f5b16c751bdfab3f74.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <9d12558549bc0c6f179b26f5b16c751bdfab3f74.1618492553.git.viremana@linux.microsoft.com>
Date:   Fri, 16 Apr 2021 10:26:40 +0200
Message-ID: <871rba8wjj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineeth Pillai <viremana@linux.microsoft.com> writes:

> Detect nested features exposed by Hyper-V if SVM is enabled.
>

It may make sense to expand this a bit as it is probably unclear how the
change is related to SVM.

Something like:

HYPERV_CPUID_NESTED_FEATURES CPUID leaf can be present on both Intel and
AMD Hyper-V guests. Previously, the code was using
HV_X64_ENLIGHTENED_VMCS_RECOMMENDED feature bit to determine the
availability of nested features leaf and this complies to TLFS:
"Recommend a nested hypervisor using the enlightened VMCS interface. 
Also indicates that additional nested enlightenments may be available
(see leaf 0x4000000A)". Enlightened VMCS, however, is an Intel only
feature so the detection method doesn't work for AMD. Use
HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS.EAX CPUID information ("The
maximum input value for hypervisor CPUID information.") instead, this
works for both AMD and Intel.


> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 3546d3e21787..c6f812851e37 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -252,6 +252,7 @@ static void __init hv_smp_prepare_cpus(unsigned int max_cpus)
>  
>  static void __init ms_hyperv_init_platform(void)
>  {
> +	int hv_max_functions_eax;
>  	int hv_host_info_eax;
>  	int hv_host_info_ebx;
>  	int hv_host_info_ecx;
> @@ -269,6 +270,8 @@ static void __init ms_hyperv_init_platform(void)
>  	ms_hyperv.misc_features = cpuid_edx(HYPERV_CPUID_FEATURES);
>  	ms_hyperv.hints    = cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
>  
> +	hv_max_functions_eax = cpuid_eax(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS);
> +
>  	pr_info("Hyper-V: privilege flags low 0x%x, high 0x%x, hints 0x%x, misc 0x%x\n",
>  		ms_hyperv.features, ms_hyperv.priv_high, ms_hyperv.hints,
>  		ms_hyperv.misc_features);
> @@ -298,8 +301,7 @@ static void __init ms_hyperv_init_platform(void)
>  	/*
>  	 * Extract host information.
>  	 */
> -	if (cpuid_eax(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS) >=
> -	    HYPERV_CPUID_VERSION) {
> +	if (hv_max_functions_eax >= HYPERV_CPUID_VERSION) {
>  		hv_host_info_eax = cpuid_eax(HYPERV_CPUID_VERSION);
>  		hv_host_info_ebx = cpuid_ebx(HYPERV_CPUID_VERSION);
>  		hv_host_info_ecx = cpuid_ecx(HYPERV_CPUID_VERSION);
> @@ -325,9 +327,11 @@ static void __init ms_hyperv_init_platform(void)
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
>  	}
>  
> -	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> +	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
>  		ms_hyperv.nested_features =
>  			cpuid_eax(HYPERV_CPUID_NESTED_FEATURES);
> +		pr_info("Hyper-V: Nested features: 0x%x\n",
> +			ms_hyperv.nested_features);
>  	}
>  
>  	/*

With the commit message expanded,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

