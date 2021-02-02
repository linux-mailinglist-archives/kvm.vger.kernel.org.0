Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB49E30BD9D
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 13:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBBMCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 07:02:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhBBMCU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 07:02:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612267254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHGKh34huCoeQ10zAXIKIqStyqxcdVd3EczNNrrMJKo=;
        b=A9mxHpJmTJTTG0NJXB+6FtDGR09y3GZYk1tBK9c5jqr1I8aQZkZ7ZMklLJUeR3H77IaLvL
        ncsAMYwsX3vkydVm3uf4C2SCTQGpJtioPi8353L1ud44H5rmKcA/unyzf72g67dvF3cLzG
        ogw38A+j4RTrPNvP62+O5xhRVwtJAFA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-L_sdVnUrPeKJ17LRRBGEvQ-1; Tue, 02 Feb 2021 07:00:49 -0500
X-MC-Unique: L_sdVnUrPeKJ17LRRBGEvQ-1
Received: by mail-ed1-f71.google.com with SMTP id m16so9375323edd.21
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 04:00:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHGKh34huCoeQ10zAXIKIqStyqxcdVd3EczNNrrMJKo=;
        b=tb7dmtjhJg/JbtqbEBH1PZn2TLPYaIBUrgFQeQqYQ/yQJ4nezYAff1jaEJ8TXagKD8
         D4KnEn4a2UoJXfmhupbi+nLgFTmyETzFFgwbLB2XjWCJ5icOW/JQ59vNebZGYoACV2Kq
         lNwl/pq4ZKHaEXHHUq2RGtxsbk86C/7VO2OVPQlpfAGyj4Y5biio4iv5J38d2g1KuSjj
         KZZ9kTGRVKheBh/G3rspriYgXnvAGWaJNYgnW94n6gvjYxYL4eRayxAMiAxHDUVaTeOd
         dUdfonJfk+mM/ZSSxRA4DoGa2xkcCALHAmUcMD2+kmQA2f6Wh0G5jmGWsBm6Kkk1mptb
         8H2A==
X-Gm-Message-State: AOAM533kYdIHdAL2/qdx8oWxxK0W7mHR9+37btd7KkdKSoBFErFzwqzL
        47ScUKbV1HyyfXFwSnxAxJcqBdDk+Vi4HpygiAaNLrlkjO9cLa2EWxhFV7QvzHOxyFsYY6ymmqI
        D6AgVb38Eexys
X-Received: by 2002:aa7:db13:: with SMTP id t19mr6287736eds.74.1612267247603;
        Tue, 02 Feb 2021 04:00:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwAoDNQ+n37lIfK2cZm2KBd+D3ZU/PVDvl7vRG2S41PzSISFuqSXCIAJs/okgJWX3zfEz4F6w==
X-Received: by 2002:aa7:db13:: with SMTP id t19mr6287709eds.74.1612267247385;
        Tue, 02 Feb 2021 04:00:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z20sm9910231edx.15.2021.02.02.04.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 04:00:46 -0800 (PST)
Subject: Re: [PATCH v14 03/11] KVM: vmx/pmu: Add PMU_CAP_LBR_FMT check when
 guest LBR is enabled
To:     Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20210201051039.255478-1-like.xu@linux.intel.com>
 <20210201051039.255478-4-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a0ffee96-366c-205a-1507-7db1d8b44de5@redhat.com>
Date:   Tue, 2 Feb 2021 13:00:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201051039.255478-4-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 06:10, Like Xu wrote:
> Usespace could set the bits [0, 5] of the IA32_PERF_CAPABILITIES
> MSR which tells about the record format stored in the LBR records.
> 
> The LBR will be enabled on the guest if host perf supports LBR
> (checked via x86_perf_get_lbr()) and the vcpu model is compatible
> with the host one.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/capabilities.h |  1 +
>   arch/x86/kvm/vmx/pmu_intel.c    | 17 +++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c          |  7 +++++++
>   arch/x86/kvm/vmx/vmx.h          | 11 +++++++++++
>   4 files changed, 36 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index a58cf3655351..db1178a66d93 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -19,6 +19,7 @@ extern int __read_mostly pt_mode;
>   #define PT_MODE_HOST_GUEST	1
>   
>   #define PMU_CAP_FW_WRITES	(1ULL << 13)
> +#define PMU_CAP_LBR_FMT		0x3f
>   
>   struct nested_vmx_msrs {
>   	/*
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index f632039173ff..01b2cd8eca47 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -168,6 +168,21 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>   	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
>   }
>   
> +bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
> +
> +	/*
> +	 * As a first step, a guest could only enable LBR feature if its
> +	 * cpu model is the same as the host because the LBR registers
> +	 * would be pass-through to the guest and they're model specific.
> +	 */
> +	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
> +		return false;
> +
> +	return !x86_perf_get_lbr(lbr);

This seems the wrong place to me.  What about adding

+	if (intel_pmu_lbr_is_compatible(vcpu))
+		x86_perf_get_lbr(lbr_desc);
+	else
+		lbr_desc->records.nr = 0;
  }

at the end of intel_pmu_refresh instead?

Paolo

