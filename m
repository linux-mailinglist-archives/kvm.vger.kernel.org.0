Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A78279D044
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbjILLls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbjILLlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:41:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B6410D8
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:41:10 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-573f722b86eso3866646a12.1
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694518870; x=1695123670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8HuXCWU/mHf3G1QXMivhWNbz0lFFlvRhydfD1CFY/Ts=;
        b=KREhus6M7ADUVqXuXTaaZ45Qv3rqZt20lJXDjr/BnW3S5z+pxqxFzRGZEVqhkxB/PC
         ZWfpU2q14McIdb3rN89lPOYNwQGkOhhvdPLWDpjCrEEFBnXB3n7QWfxMg6FTc3XnqXv5
         1aG3yasUiViHCNj7i4geMyL4N0rkYW/ZlCQpBYsmAKYXOlWfpNVPK0L0UqiUrDwPdpg5
         M3HBmdXi6PBMe1HfuYNPAM4BsgxN6XaSVuNYv8sN23U65hXrADhu/WABErD69EkavSzW
         qyrS7unpOVEQu4xANk6pI+yyytx6GmAW/qxaKH/n+8GkIGb/DVluw9tPd/0j0mYwxGmX
         af2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694518870; x=1695123670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8HuXCWU/mHf3G1QXMivhWNbz0lFFlvRhydfD1CFY/Ts=;
        b=mIHLeJjgtVLro+1ON59XZlGf8lpv7tp1NKgvoVe3/2O5Y7P5fYVqA5AJtQDxLYhA9D
         IrmysCbTYf3Xo8Omw658Afmwn9//wMAbvH4BLC/RPUzEMAAI519DlrysOGbJUrCzO63R
         lMM+9WlkwCfKDUb8NVDVf8hm8729TC64kwHGst5p8KeRUauxEQMA7S+WyuLoEBrIruHt
         7HoK9TRjMHkSSnqxHVCrsFeuYDJf39KoNwUP9IUeG2qJV/aqShJI1JH7yFGMUAtuFMAJ
         pdjKoZzExtFJQ15p6In3NFLegooWh72urNjh0z8cMbX71K1kAThR9p4U8vFFu/Iq7qrz
         rwlA==
X-Gm-Message-State: AOJu0YzgyYJpVrINz0gq4fnJnwyH69NL4pTh91isDqX46/d1oUf1LP7d
        U7ZlnDy6V6i/1BGCDgZX827grrYIwPxjKQO0
X-Google-Smtp-Source: AGHT+IHJOwvXGL6e5mrIYh8Kde3AljN6lTKq/m4PZRw0N2KRsTx452MBo9nfeBAOvYOOk/CDpIwhcQ==
X-Received: by 2002:a17:90b:1295:b0:273:ec9c:a7e3 with SMTP id fw21-20020a17090b129500b00273ec9ca7e3mr7431973pjb.17.1694518869636;
        Tue, 12 Sep 2023 04:41:09 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a20-20020a17090aa51400b00262e604724dsm8969601pjq.50.2023.09.12.04.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 04:41:09 -0700 (PDT)
Message-ID: <fe2efbb3-70eb-2ab2-9d13-b4e8c0c95216@gmail.com>
Date:   Tue, 12 Sep 2023 19:41:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 4/9] KVM: x86/pmu: Add MSR_PERF_GLOBAL_INUSE emulation
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, zhiyuan.lv@intel.com, zhenyu.z.wang@intel.com,
        kan.liang@intel.com, dapeng1.mi@linux.intel.com,
        kvm@vger.kernel.org
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-5-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230901072809.640175-5-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/9/2023 3:28 pm, Xiong Zhang wrote:
> Arch PMU v4 introduces a new MSR, IA32_PERF_GLOBAL_INUSE. It provides
> as "InUse" bit for each GP counter and fixed counter in processor.
> Additionally PMI InUse[bit 63] indicates if the PMI mechanism has been
> configured.
> 
> Each bit's definition references Architectural Performance Monitoring
> Version 4 section of SDM.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/include/asm/msr-index.h |  4 +++
>   arch/x86/kvm/vmx/pmu_intel.c     | 58 ++++++++++++++++++++++++++++++++
>   2 files changed, 62 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 7c8cf6b53a76..31bb425899fb 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1036,6 +1036,7 @@
>   #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
>   #define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
> +#define MSR_CORE_PERF_GLOBAL_INUSE	0x00000392
>   
>   #define MSR_PERF_METRICS		0x00000329
>   
> @@ -1048,6 +1049,9 @@
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT		63
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD			(1ULL << MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT)
>   
> +/* PERF_GLOBAL_INUSE bits */
> +#define MSR_CORE_PERF_GLOBAL_INUSE_PMI				BIT_ULL(63)
> +
>   /* Geode defined MSRs */
>   #define MSR_GEODE_BUSCONT_CONF0		0x00001900
>   
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index b25df421cd75..46363ac82a79 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -207,6 +207,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   	case MSR_CORE_PERF_FIXED_CTR_CTRL:
>   		return kvm_pmu_has_perf_global_ctrl(pmu);
>   	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
> +	case MSR_CORE_PERF_GLOBAL_INUSE:
>   		return vcpu_to_pmu(vcpu)->version >= 4;
>   	case MSR_IA32_PEBS_ENABLE:
>   		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
> @@ -347,6 +348,58 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>   	return true;
>   }
>   
> +static u64 intel_pmu_global_inuse_emulation(struct kvm_pmu *pmu)
> +{
> +	u64 data = 0;
> +	int i;
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		struct kvm_pmc *pmc = &pmu->gp_counters[i];
> +
> +		/*
> +		 * IA32_PERF_GLOBAL_INUSE.PERFEVTSELn_InUse[bit n]: This bit
> +		 * reflects the logical state of (IA32_PERFEVTSELn[7:0]),
> +		 * n < CPUID.0AH.EAX[15:8].
> +		 */
> +		if (pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT)
> +			data |= 1 << i;
> +		/*
> +		 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
> +		 * IA32_PERFEVTSELn.INT[bit 20], n < CPUID.0AH.EAX[15:8] is set.
> +		 */
> +		if (pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT)
> +			data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;

If this bit is already set, there is no need to repeat it to avoid wasting cycles.

> +	}
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		/*
> +		 * IA32_PERF_GLOBAL_INUSE.FCi_InUse[bit (i + 32)]: This bit
> +		 * reflects the logical state of
> +		 * IA32_FIXED_CTR_CTRL[i * 4 + 1, i * 4] != 0
> +		 */
> +		if (pmu->fixed_ctr_ctrl &
> +		    intel_fixed_bits_by_idx(i, INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER))
> +			data |= 1ULL << (i + INTEL_PMC_IDX_FIXED);
> +		/*
> +		 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
> +		 * IA32_FIXED_CTR_CTRL.ENi_PMI, i = 0, 1, 2 is set.
> +		 */
> +		if (pmu->fixed_ctr_ctrl &
> +		    intel_fixed_bits_by_idx(i, INTEL_FIXED_0_ENABLE_PMI))
> +			data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
> +	}
> +
> +	/*
> +	 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
> +	 * any IA32_PEBS_ENABLES bit is set, which enables PEBS for a GP or
> +	 * fixed counter.
> +	 */
> +	if (pmu->pebs_enable)
> +		data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
> +
> +	return data;
> +}
> +
>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -360,6 +413,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
>   		msr_info->data = 0;
>   		break;
> +	case MSR_CORE_PERF_GLOBAL_INUSE:
> +		msr_info->data = intel_pmu_global_inuse_emulation(pmu);
> +		break;
>   	case MSR_IA32_PEBS_ENABLE:
>   		msr_info->data = pmu->pebs_enable;
>   		break;
> @@ -409,6 +465,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (pmu->fixed_ctr_ctrl != data)
>   			reprogram_fixed_counters(pmu, data);
>   		break;
> +	case MSR_CORE_PERF_GLOBAL_INUSE:
> +		return 1;   /* RO MSR */

Is msrs_to_save_pmu[] updated?

>   	case MSR_IA32_PEBS_ENABLE:
>   		if (data & pmu->pebs_enable_mask)
>   			return 1;
