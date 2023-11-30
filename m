Return-Path: <kvm+bounces-2992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A63B77FF8FA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35F17281892
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CAB59143;
	Thu, 30 Nov 2023 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ByzgMRY9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82273106
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701367285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Do1i0rNcXTm7UcBN64yemTg3geXjs/ArAehAZPE2x/s=;
	b=ByzgMRY9DyHQaiFLjTbKb36FnGcrgmjUvjvLQ5o+Q+gllNWM1kWxUt+UlY1J+UQKrSsDqB
	p4MimzczSxwyLvpjwNQiAQ+EYoDhotGh8YBsR/AcKloZFvCyiGzYuQ0dmR8sjH6NwiXusX
	Mqjdv2ckgYu66LH3IkHrCQJE/OPBCV8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-5OOKQQuAPPulvd_ttXzEcQ-1; Thu, 30 Nov 2023 13:01:24 -0500
X-MC-Unique: 5OOKQQuAPPulvd_ttXzEcQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-332e11a22a0so1076695f8f.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:01:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701367283; x=1701972083;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Do1i0rNcXTm7UcBN64yemTg3geXjs/ArAehAZPE2x/s=;
        b=mUgDurz9UAipp1po1hj0FYo9KGIn7RKTSTwetG6fUbi3Bijqf9rqnfui6GgWjyFftj
         es5LfwZnjKe0dMFmbEpO0/d/bfidKDmBWxq+Z7y+AklUdfB10rkpwBA+h8gG1DtiGgKQ
         hTIYfPsnmXt5vovBE3VddyU9FftHEbfCR5w0/PlCVD8cCCv6sfQlTdEpB1DNSn+o216U
         AstIjmKF9mJ94o5T0K5txpfCOdF9TAOOaN+H10xWL6V61lbXorHUXBB2I9PlYlPLwpdn
         ur0RXnH25LeBZjYss7nqMY7U0vwMCd0sh9ud5haV8myAjWMVUnGWND43P4Cb7VXRZRou
         QmFg==
X-Gm-Message-State: AOJu0Yx192C4+iaK+dP5iuRkniN+kciSa/Zlpvv6OJBdas1jYTleMxTy
	AGSvbJak63zrIA4ZH/gRdUnFepA76RP9MhVSMLdQZ3PonTv0tTGi2fkA56vqRyXdgw4oZkdNSHk
	7y4pNMqEA+py6Fcu++s9R
X-Received: by 2002:a5d:4402:0:b0:333:a21:baff with SMTP id z2-20020a5d4402000000b003330a21baffmr141252wrq.28.1701367282185;
        Thu, 30 Nov 2023 10:01:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIoOShcGXrmT4a2nVJJ5Y/xGQjRCjLVycLPsYi48o8AqnX+pdnieJV+iz12s++pWoByaIM3Q==
X-Received: by 2002:a2e:894e:0:b0:2c9:c5dc:9a26 with SMTP id b14-20020a2e894e000000b002c9c5dc9a26mr16252ljk.12.1701365800688;
        Thu, 30 Nov 2023 09:36:40 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id u23-20020a2eb817000000b002c02e57c72bsm191667ljo.140.2023.11.30.09.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:36:40 -0800 (PST)
Message-ID: <b23c9dbc953b6bae4d3bff4aa1dff4c349a49a04.camel@redhat.com>
Subject: Re: [PATCH v7 09/26] KVM: x86: Rename kvm_{g,s}et_msr() to menifest
 emulation operations
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:36:37 +0200
In-Reply-To: <20231124055330.138870-10-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-10-weijiang.yang@intel.com>
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
> Rename kvm_{g,s}et_msr() to kvm_emulate_msr_{read,write}() to make it
> more obvious that KVM uses these helpers to emulate guest behaviors,
> i.e., host_initiated == false in these helpers.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++--
>  arch/x86/kvm/smm.c              |  4 ++--
>  arch/x86/kvm/vmx/nested.c       | 13 +++++++------
>  arch/x86/kvm/x86.c              | 10 +++++-----
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d7036982332e..5cfa18aaf33f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1967,8 +1967,8 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
>  int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
> -int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> -int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
> +int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> +int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
>  int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
>  int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
>  int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index dc3d95fdca7d..45c855389ea7 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -535,7 +535,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>  
>  	vcpu->arch.smbase =         smstate->smbase;
>  
> -	if (kvm_set_msr(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
> +	if (kvm_emulate_msr_write(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
>  		return X86EMUL_UNHANDLEABLE;
>  
>  	rsm_load_seg_64(vcpu, &smstate->tr, VCPU_SREG_TR);
> @@ -626,7 +626,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>  
>  		/* And finally go back to 32-bit mode.  */
>  		efer = 0;
> -		kvm_set_msr(vcpu, MSR_EFER, efer);
> +		kvm_emulate_msr_write(vcpu, MSR_EFER, efer);
>  	}
>  #endif
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c5ec0ef51ff7..2034337681f9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -927,7 +927,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>  				__func__, i, e.index, e.reserved);
>  			goto fail;
>  		}
> -		if (kvm_set_msr(vcpu, e.index, e.value)) {
> +		if (kvm_emulate_msr_write(vcpu, e.index, e.value)) {
>  			pr_debug_ratelimited(
>  				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
>  				__func__, i, e.index, e.value);
> @@ -963,7 +963,7 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> -	if (kvm_get_msr(vcpu, msr_index, data)) {
> +	if (kvm_emulate_msr_read(vcpu, msr_index, data)) {
>  		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
>  			msr_index);
>  		return false;
> @@ -2649,7 +2649,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>  	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
> -	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> +	    WARN_ON_ONCE(kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>  				     vmcs12->guest_ia32_perf_global_ctrl))) {
>  		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>  		return -EINVAL;
> @@ -4524,8 +4524,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  	}
>  	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>  	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
> -		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> -					 vmcs12->host_ia32_perf_global_ctrl));
> +		WARN_ON_ONCE(kvm_emulate_msr_write(vcpu,
> +					MSR_CORE_PERF_GLOBAL_CTRL,
> +					vmcs12->host_ia32_perf_global_ctrl));
>  
>  	/* Set L1 segment info according to Intel SDM
>  	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
> @@ -4700,7 +4701,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  				goto vmabort;
>  			}
>  
> -			if (kvm_set_msr(vcpu, h.index, h.value)) {
> +			if (kvm_emulate_msr_write(vcpu, h.index, h.value)) {
>  				pr_debug_ratelimited(
>  					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
>  					__func__, j, h.index, h.value);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c924075f6f1..b9c2c0cd4cf5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1973,17 +1973,17 @@ static int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
>  	return kvm_set_msr_ignored_check(vcpu, index, data, false);
>  }
>  
> -int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> +int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
>  {
>  	return kvm_get_msr_ignored_check(vcpu, index, data, false);
>  }
> -EXPORT_SYMBOL_GPL(kvm_get_msr);
> +EXPORT_SYMBOL_GPL(kvm_emulate_msr_read);
>  
> -int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
> +int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
>  {
>  	return kvm_set_msr_ignored_check(vcpu, index, data, false);
>  }
> -EXPORT_SYMBOL_GPL(kvm_set_msr);
> +EXPORT_SYMBOL_GPL(kvm_emulate_msr_write);
>  
>  static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
>  {
> @@ -8329,7 +8329,7 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
>  static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
>  			    u32 msr_index, u64 *pdata)
>  {
> -	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
> +	return kvm_emulate_msr_read(emul_to_vcpu(ctxt), msr_index, pdata);
>  }
>  
>  static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



