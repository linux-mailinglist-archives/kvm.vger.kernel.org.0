Return-Path: <kvm+bounces-238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D06C97DD5AC
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E1D4B2110E
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C0721363;
	Tue, 31 Oct 2023 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i5TBoDIL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477F20B2A
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:57:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1260FE4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698775040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jwM6l4UP2hePaKuVtl/torPOAgeleMKMhh2GlXx3fG0=;
	b=i5TBoDILMCH2UdO/kki7Ms540ZaGZj1ceCPbOfG6xEVQvoCsPtHJgOyTiBB6Thsqb+T+VR
	V7L10xNCWjRu80JcXcK64PduqJREJEeT/FmX2jYhkIKnYv+yc/X9rhAahI+v0rCdXvpuZE
	lx9wY2oZsMYd9UntyRv4bSn1hVKdq3k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-PlOYq6yUPj2AcuW3JDFjqw-1; Tue, 31 Oct 2023 13:57:18 -0400
X-MC-Unique: PlOYq6yUPj2AcuW3JDFjqw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4084e4ce543so44068255e9.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698775037; x=1699379837;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jwM6l4UP2hePaKuVtl/torPOAgeleMKMhh2GlXx3fG0=;
        b=rI+fZkaKgP8U2vfXCiNJeWvxW202VfPyi3fYoBt9zvqzz71TAuqiYA2Db4HDCgIusE
         StMuZv7HzuL98eOlEeuegERbYszgg+rMTTFLl4y12jT/LmNl88bIJVliCZdt52Y7OlBK
         d877jnSWZinsk70IOrXFwrLB9xgtlB7IrCn/EZotbNIOYPuvFvR5snnUxptYK0nqR9nr
         ks3sB73Eq1xgbsc969KjPGsEj6IjmedrAdfhwcEPRijuyADyoR2OyL4zsfOu0iZ00VIz
         omtPQLuuNQ87msjANeCrNKY6LGPrDC+lwStVz1OpZtJOvZX9lGfAs8D2nQfiLwKbRCfI
         fn4w==
X-Gm-Message-State: AOJu0YwiSkj75N74q+wHIz+egReU3WzoRPlYuIoY/u2V/9nMy4iwnF5T
	x8COJwpegKrHjE01z2johquyEMow+z0fGKcpYYkk2CGDCTSoCYANWNhfALTeXJPEpWonQbYAm5n
	GoOcrMF/U770z
X-Received: by 2002:a05:600c:1913:b0:408:3c10:ad47 with SMTP id j19-20020a05600c191300b004083c10ad47mr10919171wmq.40.1698775037580;
        Tue, 31 Oct 2023 10:57:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGldAPCxh5HZ96ed5VhGrfk/0fS3sb6eA8cyFdWcD3ew/QHd5flUQgCQuE/1xqBkV/N5rawsQ==
X-Received: by 2002:a05:600c:1913:b0:408:3c10:ad47 with SMTP id j19-20020a05600c191300b004083c10ad47mr10919162wmq.40.1698775037220;
        Tue, 31 Oct 2023 10:57:17 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id l12-20020adffe8c000000b0030647449730sm2017630wrr.74.2023.10.31.10.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:57:16 -0700 (PDT)
Message-ID: <2b17583bad87cfd11cd7bc1f824869669833a072.camel@redhat.com>
Subject: Re: [PATCH v6 24/25] KVM: nVMX: Introduce new VMX_BASIC bit for
 event error_code delivery to L1
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:57:14 +0200
In-Reply-To: <20230914063325.85503-25-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-25-weijiang.yang@intel.com>
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
> Per SDM description(Vol.3D, Appendix A.1):
> "If bit 56 is read as 1, software can use VM entry to deliver a hardware
> exception with or without an error code, regardless of vector"
> 
> Modify has_error_code check before inject events to nested guest. Only
> enforce the check when guest is in real mode, the exception is not hard
> exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
> other case ignore the check to make the logic consistent with SDM.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++--------
>  arch/x86/kvm/vmx/nested.h |  5 +++++
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c5ec0ef51ff7..78a3be394d00 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1205,9 +1205,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>  {
>  	const u64 feature_and_reserved =
>  		/* feature (except bit 48; see below) */
> -		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
> +		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
>  		/* reserved */
> -		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
> +		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
>  	u64 vmx_basic = vmcs_config.nested.basic;
>  
>  	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
> @@ -2846,12 +2846,16 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>  		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
>  			return -EINVAL;
>  
> -		/* VM-entry interruption-info field: deliver error code */
> -		should_have_error_code =
> -			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> -			x86_exception_has_error_code(vector);
> -		if (CC(has_error_code != should_have_error_code))
> -			return -EINVAL;
> +		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
> +		    !nested_cpu_has_no_hw_errcode_cc(vcpu)) {
> +			/* VM-entry interruption-info field: deliver error code */
> +			should_have_error_code =
> +				intr_type == INTR_TYPE_HARD_EXCEPTION &&
> +				prot_mode &&
> +				x86_exception_has_error_code(vector);
> +			if (CC(has_error_code != should_have_error_code))
> +				return -EINVAL;
> +		}
>  
>  		/* VM-entry exception error code */
>  		if (CC(has_error_code &&
> @@ -6968,6 +6972,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
>  
>  	if (cpu_has_vmx_basic_inout())
>  		msrs->basic |= VMX_BASIC_INOUT;
> +	if (cpu_has_vmx_basic_no_hw_errcode())
> +		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE_CC;
>  }
>  
>  static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index b4b9d51438c6..26842da6857d 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -284,6 +284,11 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
>  	       __kvm_is_valid_cr4(vcpu, val);
>  }
>  
> +static inline bool nested_cpu_has_no_hw_errcode_cc(struct kvm_vcpu *vcpu)
> +{
> +	return to_vmx(vcpu)->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
> +}
> +
>  /* No difference in the restrictions on guest and host CR4 in VMX operation. */
>  #define nested_guest_cr4_valid	nested_cr4_valid
>  #define nested_host_cr4_valid	nested_cr4_valid

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





