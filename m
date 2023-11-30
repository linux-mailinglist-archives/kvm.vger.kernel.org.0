Return-Path: <kvm+bounces-2997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0757F7FF928
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B680B21075
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EE25916A;
	Thu, 30 Nov 2023 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7JLUKWj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8331B3
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701368072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvL/GRiB3ohW1/RXmKMbz07n0kcGAk0YLHsA8KF+86I=;
	b=f7JLUKWjalWUJR4ShHkTXe1v8xfIkhDB9OdaadHx7o0HMR2lPUu9W3uDq8A1Q9F0fitGgD
	RwEMfA/ROS3qQyWimAc7PpaJNygY6vKpWwJAbPLN2dv1Zgfi0jto/I51iNh5YdKEIQkjp2
	ywp6GADiLrChqHqZpfxuAy7aCQAKab4=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-J13jhXdnObCti_YkILo3Fw-1; Thu, 30 Nov 2023 13:14:30 -0500
X-MC-Unique: J13jhXdnObCti_YkILo3Fw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c9d707de25so761941fa.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:14:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701368069; x=1701972869;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rvL/GRiB3ohW1/RXmKMbz07n0kcGAk0YLHsA8KF+86I=;
        b=NlUyH9RrgT+v1RAVfZo49cjY+narj5dOfJtrGqlk16LR2JG2SE7sOKd3Ud8xjaxIke
         yG0l4/WPTTgKezVsECo1vou6m64t7S4+3sY2t7bp2bk6eiJxbaSbEosFqhiLyTl/5W4z
         0R9BIXSMueYnx2guWqTo2I01vYMu5JS7/yiB+ZNPJILx3KfjyiN03ikD96FrsWdk6+DW
         ODPYm1eRgdTjdF6JxWu0b94ohUo+LqM20d/U3SRCkpyts28EDU+bcEeuRT/3TomQHGm6
         V5WlEcchcD/oeY9c4kHkDJ9PVc7kWvcRYrUxKwmbJYTAuUtJernpXKvzP50ujq95aV0C
         MLQA==
X-Gm-Message-State: AOJu0YxqEIpW/52ojrw9RQcjmQztWuUiO5G6IigXMQB/aJynSPxpMPUs
	pz9Cbm1YA3pMHwru7JTsF3NxtNCAL9x+c0C05vPbCDe7itR0nQ3AVnYf+UOEbMUrGvCFuHvKcNX
	Et4GYgHt94lyt7tey8YC4
X-Received: by 2002:a2e:964c:0:b0:2c9:b8d8:ebfc with SMTP id z12-20020a2e964c000000b002c9b8d8ebfcmr233ljh.14.1701368067279;
        Thu, 30 Nov 2023 10:14:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGyKvgHz7todxCgJJegCikLcKqPimvWknXUdQe2aeHXvFyHNzcrR9oL14XVeBMt7QmSk55gZQ==
X-Received: by 2002:a05:6512:368a:b0:50b:d3ac:2889 with SMTP id d10-20020a056512368a00b0050bd3ac2889mr1039lfs.44.1701366099951;
        Thu, 30 Nov 2023 09:41:39 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id h23-20020ac25977000000b0050a765b7e81sm213944lfp.236.2023.11.30.09.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:41:39 -0800 (PST)
Message-ID: <cfe2b18af68ed258ded12f1aa58bea467e380d8e.camel@redhat.com>
Subject: Re: [PATCH v7 20/26] KVM: VMX: Emulate read and write to CET MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:41:37 +0200
In-Reply-To: <20231124055330.138870-21-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-21-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> Add emulation interface for CET MSR access. The emulation code is split
> into common part and vendor specific part. The former does common checks
> for MSRs, e.g., accessibility, data validity etc., then pass the operation
> to either XSAVE-managed MSRs via the helpers or CET VMCS fields.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 18 +++++++++
>  arch/x86/kvm/x86.c     | 88 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 106 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f6ad5ba5d518..554f665e59c3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2111,6 +2111,15 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> +	case MSR_IA32_S_CET:
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
> +	case MSR_KVM_SSP:
> +		msr_info->data = vmcs_readl(GUEST_SSP);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>  		break;
> @@ -2420,6 +2429,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> +	case MSR_IA32_S_CET:
> +		vmcs_writel(GUEST_S_CET, data);
> +		break;
> +	case MSR_KVM_SSP:
> +		vmcs_writel(GUEST_SSP, data);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		break;
>  	case MSR_IA32_PERF_CAPABILITIES:
>  		if (data && !vcpu_to_pmu(vcpu)->version)
>  			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 74d2d00a1681..5792ed16e61b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1847,6 +1847,36 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>  }
>  EXPORT_SYMBOL_GPL(kvm_msr_allowed);
>  
> +#define CET_US_RESERVED_BITS		GENMASK(9, 6)
> +#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
> +#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
> +#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
> +
> +static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
> +				   bool host_initiated)
> +{
> +	bool msr_ctrl = index == MSR_IA32_S_CET || index == MSR_IA32_U_CET;
> +
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +		return true;
> +
> +	if (msr_ctrl && guest_can_use(vcpu, X86_FEATURE_IBT))
> +		return true;
> +
> +	/*
> +	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
> +	 * userspace, then userspace is allowed to write '0' irrespective of
> +	 * whether or not the MSR is exposed to the guest.
> +	 */
> +	if (!host_initiated || data)
> +		return false;
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +		return true;
> +
> +	return msr_ctrl && kvm_cpu_cap_has(X86_FEATURE_IBT);

This is reasonable.

> +}
> +
>  /*
>   * Write @data into the MSR specified by @index.  Select MSR specific fault
>   * checks are bypassed if @host_initiated is %true.
> @@ -1906,6 +1936,43 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  
>  		data = (u32)data;
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> +			return 1;
> +		if (data & CET_US_RESERVED_BITS)
> +			return 1;
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> +		    (data & CET_US_SHSTK_MASK_BITS))
> +			return 1;
> +		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> +		    (data & CET_US_IBT_MASK_BITS))
> +			return 1;
> +		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
> +			return 1;
> +		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
> +		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
> +			return 1;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated) ||
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
> +			return 1;
> +		if (is_noncanonical_address(data, vcpu))
> +			return 1;
> +		break;
> +	case MSR_KVM_SSP:
> +		if (!host_initiated)
> +			return 1;
> +		fallthrough;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> +			return 1;
> +		if (is_noncanonical_address(data, vcpu))
> +			return 1;
> +		if (!IS_ALIGNED(data, 4))
> +			return 1;
> +		break;
>  	}
>  
>  	msr.data = data;
> @@ -1949,6 +2016,19 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
> +			return 1;
> +		break;
> +	case MSR_KVM_SSP:
> +		if (!host_initiated)
> +			return 1;
> +		fallthrough;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +			return 1;
> +		break;
>  	}
>  
>  	msr.index = index;
> @@ -4118,6 +4198,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		vcpu->arch.guest_fpu.xfd_err = data;
>  		break;
>  #endif
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		kvm_set_xstate_msr(vcpu, msr_info);
> +		break;
>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr))
>  			return kvm_pmu_set_msr(vcpu, msr_info);
> @@ -4475,6 +4559,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
>  		break;
>  #endif
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		kvm_get_xstate_msr(vcpu, msr_info);
> +		break;
>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>  			return kvm_pmu_get_msr(vcpu, msr_info);

Overall looks OK to me, although I still object to the idea of having the MSR_KVM_SSP.

Best regards,
	Maxim Levitsky



