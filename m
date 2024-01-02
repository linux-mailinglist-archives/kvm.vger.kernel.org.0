Return-Path: <kvm+bounces-5475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 518D08224CE
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7747B1C22DC3
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE86171D6;
	Tue,  2 Jan 2024 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FS63appV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C546E171C6
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0ymMbFltWZ5pQNjAU9KkujHoH+I47LSiBpa1K2OeSM=;
	b=FS63appVVOJdYI5jarntlcTIOvSxaTTxay+tCZyKCVWSembdDZy8pEN4d8BI8z/ifViQXa
	qFgajlihnoNEB7nRPLm2WMzCAjLR4NOzkssNNXF4ostLL/36YXM9FPNon0YTbVFik9UTK/
	foJgV0mQokWguMBlph7lbbidwDctbHE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-TDD_mSy6OPKAedm9q0DKCA-1; Tue, 02 Jan 2024 17:34:42 -0500
X-MC-Unique: TDD_mSy6OPKAedm9q0DKCA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40d45be1ce2so47172775e9.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:34:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234881; x=1704839681;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d0ymMbFltWZ5pQNjAU9KkujHoH+I47LSiBpa1K2OeSM=;
        b=cstB+em+2VxA5RbuIlhImjH2IhmqhA2q7FApdwx3TdEU484/NaTz6FO+Wp4JpZBRLA
         1gvYq7ev++XqUQn+4tdiZGyV+rKG8/FTz7cqyu9uD73vRM1kUri39mwr4Qe0vCLwLQcA
         vIftqrmLuxCPA1ti5Njkv7n3tomHGktMeM40qURTQ8JuafADiBl3EoWzdCNgIYqOJhIA
         XmdqBWrRKzwPATIsWhRQWQjjyPuewbOEpZW6BMU3xsdhi9XhoAwZEga8r2ejh5h7uuSW
         X/BAl2SuMT1G2wqQO1Z2fRFqsZeVKJ2WJlE21gsCAxfad5IKuOO4EPY2XbHYyVxZZP9Y
         nZUw==
X-Gm-Message-State: AOJu0YwsqWJeWFxVW/Y6EsnM+wMX8ATA4xmPmDKMeMIUfQDnNxopDgZQ
	8B+jLHxsx+dXrYb4x3pApokfXT44vP5/t19xDa8L8V5lU7ka/OhVuCmu29vYSXhdjMNGemrEe3q
	m+lajhry9DnMiq6/HFmQI
X-Received: by 2002:a05:600c:548e:b0:40d:1d1c:ffaa with SMTP id iv14-20020a05600c548e00b0040d1d1cffaamr51594wmb.169.1704234881426;
        Tue, 02 Jan 2024 14:34:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGamn3RuTsOpRu6QcfyYmmYsGfTC9bmPP/GTjRiXSTiCirude9eeHpwq3a5V6MEhrM6WpboXw==
X-Received: by 2002:a05:600c:548e:b0:40d:1d1c:ffaa with SMTP id iv14-20020a05600c548e00b0040d1d1cffaamr51585wmb.169.1704234881148;
        Tue, 02 Jan 2024 14:34:41 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d4612000000b003367bb8898dsm29494717wrq.66.2024.01.02.14.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:34:40 -0800 (PST)
Message-ID: <2de1d89ba1aff043de8fdc5462e5d9c1ef2a0ef6.camel@redhat.com>
Subject: Re: [PATCH v8 22/26] KVM: VMX: Set up interception for CET MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Wed, 03 Jan 2024 00:34:39 +0200
In-Reply-To: <20231221140239.4349-23-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-23-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
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
> index 064a5fe87948..08058b182893 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -692,6 +692,10 @@ static bool is_valid_passthrough_msr(u32 msr)
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
> @@ -7767,6 +7771,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
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
> @@ -7845,6 +7885,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
> +
> +	vmx_update_intercept_for_cet_msr(vcpu);
>  }
>  
>  static u64 vmx_get_perf_capabilities(void)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


