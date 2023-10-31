Return-Path: <kvm+bounces-235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E747DD5A4
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0196C280BEE
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9802230F;
	Tue, 31 Oct 2023 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1oQBf3j"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8193622301
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:56:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39C0A6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WgMjQYwxlUZjBnG/eePgFyOUyxWaXqAMDNc4VKXZvIw=;
	b=b1oQBf3jGVmLWTBwHE13lkJa4PCOB9QIB+7rK3i+mIA6rO0CyqBszVPE6BF/edRgzr9Pj9
	5oxNDTWCg5QnOqr/3lDRnFuQud6+It8fqmZJ4kHAFJCQdngyzJDoK+IkgJAltBS74DsQl9
	tG6fwwPugGJSh2cwd6atKYXHlc1d/os=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-5sTnD20VNce957wjsck4yQ-1; Tue, 31 Oct 2023 13:56:19 -0400
X-MC-Unique: 5sTnD20VNce957wjsck4yQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-408508aa81cso42953615e9.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:56:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774978; x=1699379778;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WgMjQYwxlUZjBnG/eePgFyOUyxWaXqAMDNc4VKXZvIw=;
        b=lpDk0jKdkUmtWuDN2Sc2Tsp89uNjQCAVV4K+3TVawWU8UzPDqcMZaRJck1ioEFrih6
         JLCosGVJEVxP58CRt4YiapEGpC9DLLOwI5pJ/Ioej0BHgasg8SX1f/ssTxd2hwHEOfJO
         UnUAdW6bI5sy8k5kWP5yzoP6Fe9SuHnS0nxnHLxdZ+hpvN5iMcP4mikNac0gYOvBRicl
         QWLoZH4/SNbwxL9Yl7bBr/YsAZdsdICjZ9+PK4I/9/y5nhyt0ZlU8FQ3k4Vhye0sgi/M
         0w2R5cj6TWK/UOI/r0YT1J3S35eR/LVUxMmsdE/eaAxvjsU1m77iVXK0nziHRUvVl3p2
         X2Eg==
X-Gm-Message-State: AOJu0YxRBBs/iXrmgkrjhVjHGntW8qjdn+Mt77QPQjMtzpPKg5Wt+WGc
	EqiEJnJ46ydNSa478bgnlxr2eWExiSvDH1udYs9hq7rcc+Tfs9QkF9DbJcFgrQuADzUGF4r3Ogb
	zVOIuFT7Vuv2v
X-Received: by 2002:a05:600c:4748:b0:409:325:e499 with SMTP id w8-20020a05600c474800b004090325e499mr10664056wmo.32.1698774978339;
        Tue, 31 Oct 2023 10:56:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZXqKvPELJSZvcnqgdT38rJyf5Aq3LiLtqUFKHm+qL4V3FyMw3/3yVzj4VwUC9vLfaUoRLmA==
X-Received: by 2002:a05:600c:4748:b0:409:325:e499 with SMTP id w8-20020a05600c474800b004090325e499mr10664035wmo.32.1698774978006;
        Tue, 31 Oct 2023 10:56:18 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id j26-20020a05600c1c1a00b003fefb94ccc9sm2458756wms.11.2023.10.31.10.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:56:17 -0700 (PDT)
Message-ID: <65b52f509d7f9147917f85c7db7de8fd3fe8fb44.camel@redhat.com>
Subject: Re: [PATCH v6 21/25] KVM: VMX: Set up interception for CET MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:56:15 +0200
In-Reply-To: <20230914063325.85503-22-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-22-weijiang.yang@intel.com>
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
> Enable/disable CET MSRs interception per associated feature configuration.
> Shadow Stack feature requires all CET MSRs passed through to guest to make
> it supported in user and supervisor mode while IBT feature only depends on
> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.

I don't think that this statement is 100% true.

KVM can still technically intercept wrmsr/rdmsr access to all CET msrs because they should not be used
often by the guest and this way allow to show the guest different values than what the actual
hardware values are.

For example KVM can hide (and maybe it should) indirect branch tracking bits in the MSR_IA32_S_CET
if only the shadow stack is enabled and indirect branch tracking is disabled.

The real problem is that MSR_IA32_U_CET is indirectly allowed to be read/written unintercepted,
because of XSAVES (CET_U state component 11).

Note that on the other hand the MSR_IA32_S_CET is not saved/restored by XSAVES.

So this is what I think would be the best effort that KVM can do to separate the
two features:

1. If support state of shadow stack and indirect branch tracking matches the host (the common case) then
it is simple:
	- allow both CET_S and CET_U XSAVES components
	- allow unintercepted access to all CET msrs

2. If only indirect branch is enabled in the guest CPUID, but *host also supports shadow stacks*:
	- don't expose to the guest either the CET_S nor CET_U XSAVES components.
	- only support IA32_S_CET/IA32_U_CET msrs, intercept them, 
          and hide the shadow stack bits from the guest.

3. If only shadow stacks are enabled in the guest CPUID but the *host also supports indirect branch tracking*:

	- intercept access to IA32_S_CET and IA32_U_CET and disallow 
	  indirect branch tracking bits to be set there.

	- for the sake of performance allow both CET_S and CET_U XSAVES components,
	  and accept the fact that these instructions can enable the hidden indirect branch
	  tracking bits there (this causes no harm to the host, and will likely let the
	  guest keep both pieces, fair for using undocumented features).

	  -or-

	  don't enable CET_U XSAVES component and hope that the guest can cope with this
	  by context switching the msrs instead.


	  Yet another solution is to enable the intercept of the XSAVES, and adjust
	  the saved/restored bits of CET_U msrs in the image after its emulation/execution.
	  (This can't be done on AMD, but at least this can be done on Intel, and AMD
	  so far doesn't support the indirect branch tracking at all).


Another, much simpler option is to fail the guest creation if the shadow stack + indirect branch tracking
state differs between host and the guest, unless both are disabled in the guest.
(in essence don't let the guest be created if (2) or (3) happen)

Best regards,
	Maxim Levitsky


> 
> Note, this MSR design introduced an architectual limitation of SHSTK and
> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> to guest from architectual perspective since IBT relies on subset of SHSTK
> relevant MSRs.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9f4b56337251..30373258573d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -699,6 +699,10 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>  		return true;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> +		return true;
>  	}
>  
>  	r = possible_passthrough_msr_slot(msr) != -ENOENT;
> @@ -7769,6 +7773,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>  
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	bool incpt;
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> +						  MSR_TYPE_RW, incpt);
> +		if (!incpt)
> +			return;
> +	}
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> +					  MSR_TYPE_RW, incpt);
> +	}
> +}
> +
>  static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7846,6 +7886,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
> +
> +	vmx_update_intercept_for_cet_msr(vcpu);
>  }
>  
>  static u64 vmx_get_perf_capabilities(void)






