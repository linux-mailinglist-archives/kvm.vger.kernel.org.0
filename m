Return-Path: <kvm+bounces-2984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E2EA7FF88F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:41:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58570281853
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3932C58132;
	Thu, 30 Nov 2023 17:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M4fHUyhB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4060197
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701366070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ROI9QsVBebZ2z46uwx8HAg7XDg30OxxOQZ6JWNYVYc=;
	b=M4fHUyhB2Ql7PQHz4mOygjJGfL9iEAsAUwUaLyGVRyCuTSul3JbUSVNZIm7+60ZQ/Xzrie
	d4zp3HmeMEilbzYmow0gZ0/6F4KfluUI1NKbhnx8brr8TFQe3CU5mUfyv2OlzsK7UYrXsj
	4FwfQfLk8NBkMSQucx4FC2jItZtupfs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-lXmxg1fCPEmOyeY65-tdQw-1; Thu, 30 Nov 2023 12:41:08 -0500
X-MC-Unique: lXmxg1fCPEmOyeY65-tdQw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-54af5bc3253so1678279a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701366067; x=1701970867;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ROI9QsVBebZ2z46uwx8HAg7XDg30OxxOQZ6JWNYVYc=;
        b=YAmZx17uz0H/IzMffoN96nRKMHnBBS6apsNJA3oX+z4D+Qp5tsSR7MXf+x7eV6fjft
         KduvhFE/Ume6Y+6yiDLXaAK+5XRNA/iPgnpnyL+HhhS2793SL95iJToblfPo6wB+vmC+
         aYtKpTtTHYEop4zqgk9512OdUYrBGemaF83sLL168mcUOp19LTdE6AiJtxa9lpUiIwPw
         p1pi1ktS2+gEiXoKSm7ACrF/fworlnEAlJLC/0s4SN0LP2N2BmjpEzoJxOSHzkjCP+R2
         5Ipbz7UIN00jVsBBNLeAVtERGIlS4zCs33kIDvCQSvzBnUiYbN4422tJFKIWhAl2qicf
         IYfw==
X-Gm-Message-State: AOJu0YxsY2yUpcdGkbvZvTUDc/+BRSgG/p3gapmNiFXiBLOpqq7GjBiA
	Um4Xw8LWsvDo7kz/h500mzFKtwOc2ljFBSevX5hHk6MmCHTpJ3fgM4kdx7d7sS4Qd1zf2NkwfVc
	JwFQz6L5WkfPDy1GqmS8G
X-Received: by 2002:a17:906:cf84:b0:a04:98ef:c73c with SMTP id um4-20020a170906cf8400b00a0498efc73cmr7378ejb.23.1701366066873;
        Thu, 30 Nov 2023 09:41:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4QjnJOrbKfLEuFMzMmje8PoqSYFHn0lGEviE5VHDMLAbPObRw2OxFYlFP3L4fHrNjcg39jA==
X-Received: by 2002:a05:6512:50b:b0:50b:d552:267c with SMTP id o11-20020a056512050b00b0050bd552267cmr42172lfb.3.1701365812565;
        Thu, 30 Nov 2023 09:36:52 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id v13-20020a056512048d00b0050bbdf9616bsm214270lfq.217.2023.11.30.09.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:36:52 -0800 (PST)
Message-ID: <156f037f96407f77dd71373be504da50b78f671c.camel@redhat.com>
Subject: Re: [PATCH v7 10/26] KVM: x86: Refine xsave-managed guest
 register/MSR reset handling
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:36:49 +0200
In-Reply-To: <20231124055330.138870-11-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-11-weijiang.yang@intel.com>
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
> Tweak the code a bit to facilitate resetting more xstate components in
> the future, e.g., adding CET's xstate-managed MSRs.
> 
> No functional change intended.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b9c2c0cd4cf5..16b4f2dd138a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12132,6 +12132,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  		static_branch_dec(&kvm_has_noapic_vcpu);
>  }
>  
> +static inline bool is_xstate_reset_needed(void)
> +{
> +	return kvm_cpu_cap_has(X86_FEATURE_MPX);
> +}
> +
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct kvm_cpuid_entry2 *cpuid_0x1;
> @@ -12189,7 +12194,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	kvm_async_pf_hash_reset(vcpu);
>  	vcpu->arch.apf.halted = false;
>  
> -	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
> +	if (vcpu->arch.guest_fpu.fpstate && is_xstate_reset_needed()) {
>  		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
>  
>  		/*
> @@ -12199,8 +12204,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		if (init_event)
>  			kvm_put_guest_fpu(vcpu);
>  
> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
> +		if (kvm_cpu_cap_has(X86_FEATURE_MPX)) {
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_BNDREGS);
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_BNDCSR);
> +		}
>  
>  		if (init_event)
>  			kvm_load_guest_fpu(vcpu);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


