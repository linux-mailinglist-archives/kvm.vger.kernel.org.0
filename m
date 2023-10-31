Return-Path: <kvm+bounces-233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D92457DD5A0
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FB10B21126
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC32E210F0;
	Tue, 31 Oct 2023 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQ4dRQI0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEF620B2F
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:55:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6014E8
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEMBX5k/UL1AFBCbkHv72CwPsR9mFYeb4l/l1A7sNpk=;
	b=gQ4dRQI0boxW8umm7pp4VbnN1Cxpv1+EVOZcIK8i3veBLpXb4dkjahcYt3Mb/OCuQe6MAU
	0kycBuQ6FtRcpQZibbnVriuvezF6weGjg9wnK3gEixcEdKZRx6t7lWQvXvRxLFwfPDht7h
	kXr+RcdhooJBs8e0jMDvTVi+YFzO824=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-8XYBUx_0OeeDvWBWiX7N8g-1; Tue, 31 Oct 2023 13:55:47 -0400
X-MC-Unique: 8XYBUx_0OeeDvWBWiX7N8g-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32de95ec119so2985724f8f.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774946; x=1699379746;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZEMBX5k/UL1AFBCbkHv72CwPsR9mFYeb4l/l1A7sNpk=;
        b=pjCAeCpSIhwoesjwmQ80/dPfLDNkyJQuvfKf29t9/e4nkDS8M5gr4miDE6N6axnKHt
         KCAQ1mriTFmQXUU6t7ghYi7CQJHiZdLP1C8xQ1r1mrZNGOhvklWdubkwEVHHIp7CAiXs
         Su3xtrgKNrM8y7P6Y/02CZpvUmdfzCHEmfadY+F6O0wpcJ/zQMmPoMJfDOvP5tiy8iwF
         HPbR6esJXBlZaTZmXC6WBm9kGMDi4KrbVMbzvjWwbReNvKYRxGc9cKxBXqgTy3sdGmuU
         W7OieRrqdjr/5iaVHjx4iMJeOZu94z0cLmrZNHQSc1vcDbkLv2wfzW3MMKjMeOEq4aYC
         XaZg==
X-Gm-Message-State: AOJu0Yz6seEi10v1i+Sk2TAbKqYHJIESi5SWgeYQ1uXyFZ2+WGnCH8c7
	hk9WB/jUjVVe7TXXQHtWozGvsp+79mK+hWz5YusBXy0GFsX+nh4mT2+As3QK8wB4nufrTmMPlJ5
	MBcRwNOKj1aUK
X-Received: by 2002:a5d:5889:0:b0:32f:7649:2648 with SMTP id n9-20020a5d5889000000b0032f76492648mr10186333wrf.46.1698774946112;
        Tue, 31 Oct 2023 10:55:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEcswWNBhV0Rza559G755pu7BaFjuPsNpUZ5lhUqhz1s5OmIVgG5C9Xp06tdvn4neIMkTNJA==
X-Received: by 2002:a5d:5889:0:b0:32f:7649:2648 with SMTP id n9-20020a5d5889000000b0032f76492648mr10186314wrf.46.1698774945677;
        Tue, 31 Oct 2023 10:55:45 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id i4-20020a5d4384000000b00326f0ca3566sm2006794wrq.50.2023.10.31.10.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:55:45 -0700 (PDT)
Message-ID: <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
Subject: Re: [PATCH v6 19/25] KVM: VMX: Emulate read and write to CET MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:55:43 +0200
In-Reply-To: <20230914063325.85503-20-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-20-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> Add emulation interface for CET MSR access. The emulation code is split
> into common part and vendor specific part. The former does common check
> for MSRs and reads/writes directly from/to XSAVE-managed MSRs via the
> helpers while the latter accesses the MSRs linked to VMCS fields.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 18 +++++++++++
>  arch/x86/kvm/x86.c     | 71 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fd5893b3a2c8..9f4b56337251 100644
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
> index 73b45351c0fc..c85ee42ab4f1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1847,6 +1847,11 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>  }
>  EXPORT_SYMBOL_GPL(kvm_msr_allowed);
>  
> +#define CET_US_RESERVED_BITS		GENMASK(9, 6)
> +#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
> +#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
> +#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
> +
>  /*
>   * Write @data into the MSR specified by @index.  Select MSR specific fault
>   * checks are bypassed if @host_initiated is %true.
> @@ -1856,6 +1861,7 @@ EXPORT_SYMBOL_GPL(kvm_msr_allowed);
>  static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  			 bool host_initiated)
>  {
> +	bool host_msr_reset = host_initiated && data == 0;

I really don't like this boolean. While 0 is usually the reset value, it doesn't have to
be (like SVM tsc ratio reset value is 1 for example).
Also its name is confusing.

I suggest to just open code this instead.

>  	struct msr_data msr;
>  
>  	switch (index) {
> @@ -1906,6 +1912,46 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  
>  		data = (u32)data;
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (host_msr_reset && (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> +				       kvm_cpu_cap_has(X86_FEATURE_IBT)))
> +			break;
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> +		    !guest_can_use(vcpu, X86_FEATURE_IBT))
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
> +
> +		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
> +		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
> +			return 1;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
> +			return 1;
> +		fallthrough;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +	case MSR_KVM_SSP:
> +		if (host_msr_reset && kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +			break;
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +			return 1;
> +		if (index == MSR_KVM_SSP && !host_initiated)
> +			return 1;
> +		if (is_noncanonical_address(data, vcpu))
> +			return 1;
> +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
> +			return 1;
> +		break;
Once again I'll prefer to have an ioctl for setting/getting SSP, this will make the above
code simpler (e.g there will be no need to check that write comes from the host/etc).

>  	}
>  
>  	msr.data = data;
> @@ -1949,6 +1995,23 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> +		    !guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +			return 1;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
> +			return 1;
> +		fallthrough;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +	case MSR_KVM_SSP:
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +			return 1;
> +		if (index == MSR_KVM_SSP && !host_initiated)
> +			return 1;
> +		break;
>  	}
>  
>  	msr.index = index;
> @@ -4009,6 +4072,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		vcpu->arch.guest_fpu.xfd_err = data;
>  		break;
>  #endif
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		kvm_set_xstate_msr(vcpu, msr_info);

Ah, so here these functions (kvm_set_xstate_msr/kvm_get_xstate_msr) are used. 
I think that this patch should introduce them.

Also I will appreciate a comment to kvm_set_xstate_msr/kvm_get_xstate_msr saying something like:

"This function updates a guest MSR which value is saved in the guest FPU state. 
Wrap the write with load/save of the guest FPU state to keep the state consistent with the new MSR value"

Or something similar, although I will not argue over this.

> +		break;
>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr))
>  			return kvm_pmu_set_msr(vcpu, msr_info);
> @@ -4365,6 +4432,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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


Best regards,
	Maxim Levitsky





