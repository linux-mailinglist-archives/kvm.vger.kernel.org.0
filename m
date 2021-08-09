Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DCF3E4655
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 15:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhHINRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 09:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbhHINRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 09:17:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64189C0613D3;
        Mon,  9 Aug 2021 06:16:56 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oa17so3020684pjb.1;
        Mon, 09 Aug 2021 06:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1RRkVd602yGR6zdKpY6uMFnu2l223se8972sEu0gYHw=;
        b=gBPNsDbNupuDjk4KCmAIjlbKIwtmdylvupz1Jc2TaHfKrO1554flIIzmoiw4VbMBlS
         vwxNyQmhKFlPv4zHGDuGaGHr8wmiR+Yu3skq3idVAyUl0niMriE8I+xdg57/irdsit0H
         pZ/ea+dfZXSqVhDFz3xrPtuv0tNj9Z6VOe6PJE0FcYnAHktXtczZuBANrqweP2PdET7B
         PPvCudcju6tuInQBMtLJSf3MtX29bJVS5EuV5SsjzgpikTi40Piqg6cww4/QBkxXsV0g
         VSYrGgaQ9S2Cn+DLhbjiNMUHbGHYRiQ14P0jT11aLr060d8OP+CfVJUPMtsdSW3mLplB
         2IBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1RRkVd602yGR6zdKpY6uMFnu2l223se8972sEu0gYHw=;
        b=e1VMf8ELFgKZkX/6MeE7IBsRh/27N2T81m1TEIeC3VT0lbq4F2UWzpgldEQr8GK5tY
         p6OX4GIZl0grkUkKTv/eknCTHX7jJLtclIucWehlG9WDuYtOK+rrEMEZqNdUHHRLzCs+
         tVK85efw1ITg5tjgmD7hqTf5EInmgNRJZMrEqJadIznJcLsNlqqNuN6qD7Jzl+lcLSaD
         uq1EhZwyvj3+4cm2omxcS371V+URj5S/Q1w0P27oPrgqoGf1K+u5GQUqd1AI6QoQGia6
         wZZdRz0HQ4jqGPLVpPDT/fo9AL1eRQJvf6BZ3R5J7XmKwhCEi9R088CIWLZZ9DK+cfA0
         vn5g==
X-Gm-Message-State: AOAM532KrW6oxnvTgZ+mfUSAKEL0XqSP5HBKUsDM4bsT/cTwsbOMPntC
        XIJwatUoLRfF7oUU5WaY//CEbFm3Q1il1Q==
X-Google-Smtp-Source: ABdhPJw0t1HBMdL6R5jJ5efuwkP0GCZnTTKkRPdcDTbqxcPLPhKF6gmLxDlinBVlsEg+MkFPcm+H+A==
X-Received: by 2002:a63:e807:: with SMTP id s7mr171625pgh.200.1628515015894;
        Mon, 09 Aug 2021 06:16:55 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b204sm20825481pfb.81.2021.08.09.06.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 06:16:55 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-5-git-send-email-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v7 04/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Message-ID: <e739722a-b875-6e5b-3e77-38586d799485@gmail.com>
Date:   Mon, 9 Aug 2021 21:16:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628235745-26566-5-git-send-email-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/2021 3:42 pm, Yang Weijiang wrote:
> From: Like Xu <like.xu@linux.intel.com>

...

> 
> The number of Arch LBR entries available is determined by the value
> in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
> enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
> in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
> supported.
> 
> On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
> KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
> (this is safe because the two values will be the same) when the Arch LBR
> records MSRs are pass-through to the guest.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 35 ++++++++++++++++++++++++++++++++++-
>   1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 9efc1a6b8693..a4ef5bbce186 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -211,7 +211,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>   static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	int ret;
> +	int ret = 0;
>   
>   	switch (msr) {
>   	case MSR_CORE_PERF_FIXED_CTR_CTRL:
> @@ -220,6 +220,10 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>   		ret = pmu->version > 1;
>   		break;
> +	case MSR_ARCH_LBR_DEPTH:
> +		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> +		break;
>   	default:
>   		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
>   			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
> @@ -348,10 +352,28 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>   	return true;
>   }
>   
> +/*
> + * Check if the requested depth value the same as that of host.
> + * When guest/host depth are different, the handling would be tricky,
> + * so now only max depth is supported for both host and guest.
> + */
> +static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		return false;
> +
> +	cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);

I really don't understand why the sanity check of the
guest lbr depth needs to read the host's cpuid entry and it's pretty slow.

KVM has reported the maximum host LBR depth as the only supported value.

> +
> +	return (depth == fls(eax & 0xff) * 8);
> +}
> +
>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   	struct kvm_pmc *pmc;
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>   	u32 msr = msr_info->index;
>   
>   	switch (msr) {
> @@ -367,6 +389,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>   		msr_info->data = pmu->global_ovf_ctrl;
>   		return 0;
> +	case MSR_ARCH_LBR_DEPTH:
> +		msr_info->data = lbr_desc->records.nr;
> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -393,6 +418,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   	struct kvm_pmc *pmc;
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>   	u32 msr = msr_info->index;
>   	u64 data = msr_info->data;
>   
> @@ -427,6 +453,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 0;
>   		}
>   		break;
> +	case MSR_ARCH_LBR_DEPTH:
> +		if (!arch_lbr_depth_is_valid(vcpu, data))
> +			return 1;
> +		lbr_desc->records.nr = data;
> +		if (!msr_info->host_initiated)
> +			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);

Resetting the host msr here is dangerous,
what if the guest LBR event doesn't exist or isn't scheduled on?

> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> 
