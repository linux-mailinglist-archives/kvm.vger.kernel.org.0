Return-Path: <kvm+bounces-2990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B927FF8D8
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:54:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56A7DB20D4F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A4ED584E5;
	Thu, 30 Nov 2023 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bkalzxvg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318CD103
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701366854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CrFEpIsAN5CLxammhD+GAJP9cPsbGGrmnZDHNVsmekk=;
	b=bkalzxvgN6WGOFMR3MqFcAoqx8dltyY7GrUTKv1VIpwu+yikDh8rFSCXBbh25EOYfdak+n
	v/jpKqv7aeK6m90KegH9scD02/8xodAG3LPugHcJ1cOUbfeiAsi4iA3rijWrjY2jqzOGKC
	murPKwB7jwWk/wMp9e6Ci8nmSLxg/oU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-Zi8RJ3BCPk2l07mzDKr7UQ-1; Thu, 30 Nov 2023 12:54:12 -0500
X-MC-Unique: Zi8RJ3BCPk2l07mzDKr7UQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332ee20a3f0so1193203f8f.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:54:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701366851; x=1701971651;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CrFEpIsAN5CLxammhD+GAJP9cPsbGGrmnZDHNVsmekk=;
        b=tEKq0N84X4EzNa2VJRom2T2ZejwGvXxqScQkz+x0hO2B73y/kgQohGHLky7sWKmZyR
         Oti2Ux4PQ/c46d2+//CXIhPaNHTNOEfx/mceIyTDpWsTb0D17JNZWWXUaQtn/HWO6F1T
         P615p+jwAJFIEwl05uWbR3c4NaJQY0qD4tzcJgbibh7ODbheSPJgOFdJ7e18nUip9m8x
         cYQRRIxJKXGECS6zenoOdW1rPbZRU0BEiQfkSIWfL6aDeBBAwlvUseVYmt2bHWL0ZDez
         vFGNCwjkE6rvdfBQnZvBGdgrQRvIj+vEEgLZnWgAO/mdkGPQsJA9lHq9uXibHHToTP0e
         YXHQ==
X-Gm-Message-State: AOJu0YyGAjsJvkcEQtDXwF2KNheRB5Qd/UKPgVs8lGWc75wCC2Yeb9z2
	SNARAeddpWETWXV9dHBuWAepF4REE/YoQXay93q2NA7ViWFx+xzZj8o5y9wdRusSCX3+4PYE8jT
	eG+4clP/+SSxGZGrIDWee
X-Received: by 2002:adf:fcc8:0:b0:333:2fd2:7692 with SMTP id f8-20020adffcc8000000b003332fd27692mr743wrs.131.1701366848579;
        Thu, 30 Nov 2023 09:54:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDeqYIAaVd/veLSsPan4ItHCmZAXYpV0ezMbb4/NCI3nQ4Fjl7Bmf1Eq8wWcU569Tv8r8zRw==
X-Received: by 2002:a17:906:15c:b0:9e7:8ad0:a471 with SMTP id 28-20020a170906015c00b009e78ad0a471mr171135ejh.12.1701366013091;
        Thu, 30 Nov 2023 09:40:13 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id 6-20020ac24846000000b0050bc56dd0acsm213436lfy.184.2023.11.30.09.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:40:11 -0800 (PST)
Message-ID: <fe7d8df5b6774a83c38b8a6dc244782c943c84b7.camel@redhat.com>
Subject: Re: [PATCH v7 17/26] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:40:09 +0200
In-Reply-To: <20231124055330.138870-18-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-18-weijiang.yang@intel.com>
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
> Add CET MSRs to the list of MSRs reported to userspace if the feature,
> i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.
> 
> SSP can only be read via RDSSP. Writing even requires destructive and
> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
> for the GUEST_SSP field of the VMCS.
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
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index be20a60047b1..d3d0d74fef70 100644
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
> index 44b8cf459dfc..74d2d00a1681 100644
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
> @@ -7371,6 +7375,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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

I still think that pseudo MSR is a hack that might backfire,
but I am not going to argue much about this.

Best regards,
	Maxim Levitsky



