Return-Path: <kvm+bounces-229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D84627DD581
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:52:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4082B2818F6
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1BD22308;
	Tue, 31 Oct 2023 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXMNxv2u"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECC2219FE
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:52:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C0BED
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H2l+voE7edXbyWqws5S7PyDj/LZlwoVxQ/K7xh9L/c4=;
	b=YXMNxv2uZ6czk+fYbF1FyaRqzp2BOTv/v6KL1QLNEdK+vX/BBCUxjRyLTTDI3wN4BGfObx
	n/OVwq9tEAT5L87xIFuAeRbjQDA2fciYiWpy8rv6hRi5dgmdaMLUb8InvCb36jio+4v7WF
	X7u/XmgNIdv4kaAJJv/OJ2zs1XMGF0c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623--aCZxqwPM6WHkbqmimu-rw-1; Tue, 31 Oct 2023 13:52:33 -0400
X-MC-Unique: -aCZxqwPM6WHkbqmimu-rw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32d9602824dso3008244f8f.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774752; x=1699379552;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H2l+voE7edXbyWqws5S7PyDj/LZlwoVxQ/K7xh9L/c4=;
        b=kGBfNCLg8LmjQy7tx25LLEChpPHl1f97qJVXbW4aptFXOAjHo5UC6F6lKJSI+8QT0a
         OxJrpdLWFyhALYEzGbc3RQH9ppUab2LrTzOJAlo22UZLv/9kaFiLAx7Qr/Hd9bc0ASeE
         KkVKLRPAN06YQAUdcXV1EVjfl9MHZm8Oy8TaSC4Fko4Cn9VkmMfUqoorm78bdShOslXv
         NujoEDTdU6pwDEHwkeGWEXOESNphv4itS+5omGN7ngdyhQYxx6rewIYhATyT3ouaTjzc
         kENCQMSGdzgO+q9WcLc2cK9FWCtnxhvkWbuV3wTtxcAtNTY5yEyoOULfhi5+YhxLN97x
         G9Uw==
X-Gm-Message-State: AOJu0YxLf2CcIF9MYNVZnIK2To9KmK0uju39pRhm0cVtj3CjERTGYRrL
	pR3+FK06pHVVIBE2crrctb2/IklLBVOT1qwOstWrPmmvcEX042Sj4LZWE9niFAH+O87gG2B7EqL
	+JcfWL14GUnIo
X-Received: by 2002:adf:d1c9:0:b0:32d:b06c:b382 with SMTP id b9-20020adfd1c9000000b0032db06cb382mr11582136wrd.39.1698774752225;
        Tue, 31 Oct 2023 10:52:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnD8DWgMmcWKLaza6Ss9qnpd1GsmRq+M0Z1R66H4nGHGUi5kosl3xrtfku+9e95gUzhw851A==
X-Received: by 2002:adf:d1c9:0:b0:32d:b06c:b382 with SMTP id b9-20020adfd1c9000000b0032db06cb382mr11582120wrd.39.1698774751900;
        Tue, 31 Oct 2023 10:52:31 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d5447000000b003176c6e87b1sm2021452wrv.81.2023.10.31.10.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:52:31 -0700 (PDT)
Message-ID: <9d232c1ddd4385cf2cb65a2723bb03c798c9d76d.camel@redhat.com>
Subject: Re: [PATCH v6 16/25] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:52:29 +0200
In-Reply-To: <20230914063325.85503-17-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-17-weijiang.yang@intel.com>
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
> Add CET MSRs to the list of MSRs reported to userspace if the feature,
> i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.
> 
> SSP can only be read via RDSSP. Writing even requires destructive and
> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
> for the GUEST_SSP field of the VMCS.

Fake MSR just feels wrong for the future generations of readers of this code. 
This is not a MSR no matter how we look at it, and KVM never supported such
fake MSRs - this is the first one.

I'll say its better to define a new ioctl for this register,
or if you are feeling adventurous, you can try to add support for 
KVM_GET_ONE_REG/KVM_SET_ONE_REG which is what at least arm uses
for this purpose.


Also I think it will be better to split this patch into two - first patch that adds new ioctl,
and the second patch will add the normal CET msrs to the list of msrs to be saved.


> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm_para.h |  1 +
>  arch/x86/kvm/vmx/vmx.c               |  2 ++
>  arch/x86/kvm/x86.c                   | 18 ++++++++++++++++++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 6e64b27b2c1e..9864bbcf2470 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -58,6 +58,7 @@
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>  #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
> +#define MSR_KVM_SSP	0x4b564d09

Another reason for not doing this - someone will think that this is a KVM PV msr.

>  
>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 72e3943f3693..9409753f45b0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7009,6 +7009,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
>  	case MSR_AMD64_TSC_RATIO:
>  		/* This is AMD only.  */
>  		return false;
> +	case MSR_KVM_SSP:
> +		return kvm_cpu_cap_has(X86_FEATURE_SHSTK);
>  	default:
>  		return true;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dda9c7141ea1..73b45351c0fc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1476,6 +1476,9 @@ static const u32 msrs_to_save_base[] = {
>  
>  	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
>  	MSR_IA32_XSS,
> +	MSR_IA32_U_CET, MSR_IA32_S_CET,
> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
> +	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
>  };
>  
>  static const u32 msrs_to_save_pmu[] = {
> @@ -1576,6 +1579,7 @@ static const u32 emulated_msrs_all[] = {
>  
>  	MSR_K7_HWCR,
>  	MSR_KVM_POLL_CONTROL,
> +	MSR_KVM_SSP,
>  };
>  
>  static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
> @@ -7241,6 +7245,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>  		if (!kvm_caps.supported_xss)
>  			return;
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +		    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +			return;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_LM))
> +			return;
> +		fallthrough;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +			return;
> +		break;
>  	default:
>  		break;
>  	}

Best regards,
	Maxim Levitsky






