Return-Path: <kvm+bounces-2998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 536547FF934
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:18:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83E671C21007
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA58859173;
	Thu, 30 Nov 2023 18:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W62i7v8s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C15D6C
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701368312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPhpj/A0n+X4U7+YF4qn5WwPaR+rmzk/ZuOqptCZK6E=;
	b=W62i7v8sOlJBs+WlBdFbY3qOXDt++DoXHo+jKrrTM8sbj6wEA8aDkqcW9j2i+ObbRgn39K
	XJVh2Rs0OiPqixoY2lfx8hUoimn5XdstLVAipWIzJh9o6Q27gGfulUzrxbnbVwglga3Nji
	H7YiSOmyImI/QQBLIp/2lvEARJtrJu4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-vgbJ8JOoOQCoxm5JmeXcmA-1; Thu, 30 Nov 2023 13:18:31 -0500
X-MC-Unique: vgbJ8JOoOQCoxm5JmeXcmA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-543f45ab457so932342a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:18:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701368309; x=1701973109;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LPhpj/A0n+X4U7+YF4qn5WwPaR+rmzk/ZuOqptCZK6E=;
        b=DfjvXwwwrgONyCmH8f37azB7VTS45NbYDSIPMOUqEtQX+9w92O5HejpeFcs64uHOMy
         HI+wfznjfS2bEgKlbjScKKf13RYWDMrkvftrESDrbD2gREnTPkdMapsrZfjRrrHSyd2W
         y/ahXKr6+7ldHf5y86P0jR/8X7iwCPRuyNUrcnjI3V8kWfTlk5w3EotgZ0PzDqqYUhDZ
         lZQaBeDxvyozpREP7GpBS1ezoXc3fQ8/zot7jc8BSBC04ezvniMD4cRno4M9zmC2nsBw
         Eo7c+ZCAl6PD6YqE+xd6jhfkp8qaR5cTzcNolsA0XHveIPAprEcpp/dcvxSBwU2PFkUV
         glIA==
X-Gm-Message-State: AOJu0YywCakvTXJLT8Y4WwSSLJrpcCmvDuIgp95QUfXmFUwBXGs3kojf
	4j9J8jam8MmO0JCYuyT3/G/I0yMzS/+/IW3n1PYouGr/ZRfrG6BknE+3DMugRK0enPA+zQXQTf+
	ok6+Sv0hk8+KoMC0Gi9mk
X-Received: by 2002:a50:ab45:0:b0:54c:4837:9a9b with SMTP id t5-20020a50ab45000000b0054c48379a9bmr854edc.66.1701368308728;
        Thu, 30 Nov 2023 10:18:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZelmu7uaSeXSssVnLywvQIGoRpU1YHk/jvrg5YamPvbTcEuIUmu8QD5HyLuAP/iFyPFU75Q==
X-Received: by 2002:a2e:3207:0:b0:2c9:c5a6:62d8 with SMTP id y7-20020a2e3207000000b002c9c5a662d8mr17958ljy.0.1701366288443;
        Thu, 30 Nov 2023 09:44:48 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id h15-20020a2e9ecf000000b002c9c22c52e4sm188158ljk.103.2023.11.30.09.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:44:48 -0800 (PST)
Message-ID: <393d82243b7f44731439717be82b20fbeda45c77.camel@redhat.com>
Subject: Re: [PATCH v7 22/26] KVM: VMX: Set up interception for CET MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:44:45 +0200
In-Reply-To: <20231124055330.138870-23-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-23-weijiang.yang@intel.com>
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
> Enable/disable CET MSRs interception per associated feature configuration.
> Shadow Stack feature requires all CET MSRs passed through to guest to make
> it supported in user and supervisor mode while IBT feature only depends on
> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
> 
> Note, this MSR design introduced an architectural limitation of SHSTK and
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
> index 554f665e59c3..e484333eddb0 100644
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
> @@ -7766,6 +7770,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
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
> @@ -7843,6 +7883,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
> +
> +	vmx_update_intercept_for_cet_msr(vcpu);
>  }
>  
>  static u64 vmx_get_perf_capabilities(void)

My review feedback from the previous patch still applies as well,

I still think that we should either try a best effort approach to plug
this virtualization hole, or we at least should fail guest creation
if the virtualization hole is present as I said:

"Another, much simpler option is to fail the guest creation if the shadow stack + indirect branch tracking
state differs between host and the guest, unless both are disabled in the guest.
(in essence don't let the guest be created if (2) or (3) happen)"

Please at least tell me what do you think about this.

Best regards,
	Maxim Levitsky



