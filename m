Return-Path: <kvm+bounces-3005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B49317FFAC7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6848E28198A
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4874A5FF07;
	Thu, 30 Nov 2023 19:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WdDldz1D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB11D48
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701371172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qh2iQI1ztXeis76Y0kVKsrBeV19ZxrXIlDJBIndDl5E=;
	b=WdDldz1DxpdyycgDEdyFadjyCgAQK9VA7Htv7wc/EwPU123SiFDdDALUB5XOlPh8v3kbnx
	4k5H2GPuwgor/Kldx8PdItzC9sz47YIrjyY79rlGO6OAFpKTQrdqyXaEQwtahnNNdzUkEj
	JuCN9ORm4PXAzQVWmet/9KD8Fna+Uk4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-WjfLGCUQOwmC6eZIqRoYrw-1; Thu, 30 Nov 2023 14:06:10 -0500
X-MC-Unique: WjfLGCUQOwmC6eZIqRoYrw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50bbec0e9d9so1455069e87.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701371168; x=1701975968;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qh2iQI1ztXeis76Y0kVKsrBeV19ZxrXIlDJBIndDl5E=;
        b=MZdXByOxH4tGfwZv6PRyv2NFX5w9GHg8Rk8ZCVUH43QIR2b3MotedEaQqWOTCCNLyM
         OjYXNz6X/QBg7GlLaqKAJJ7lVu3V9ZYtuAvhMxe6wDR0sCcvkfnOwTYZBnoDXfmmKbL9
         +l7rnDFypThZ/P9cYVYcHoXM9pBn9zEIj/s4YjwJ76xipvcCIuCrN99g5reEJv7uA3XZ
         FBqr+zb5Zurwvl3IbzZUGaenBmpD4vmvghTZ3x8UzMNBYHUqHqp7b9CwB7NyUNFB5AGY
         mppqfOcT+tdYuGpOI66Kyoiu5sYeqLb69x0Im4+8i9wUtfX9DKfgv8/qX3gGhTiTJ8Ub
         sciA==
X-Gm-Message-State: AOJu0YwwazjWPq+Xlxcip5NWAKxKWZWm6kFzBUDYZaNYlwLp1S0fiPwP
	5sEDBxSZY0CWpU8Yoehm1MzY8EpVy2HK1/GkkcujCGJvLxyBEvSoHiQSwco9VSZaGg8O4PiETla
	I2XeyldeHZYgzycu9nJlQ
X-Received: by 2002:ac2:5495:0:b0:50b:c9e7:2942 with SMTP id t21-20020ac25495000000b0050bc9e72942mr15084lfk.14.1701366558570;
        Thu, 30 Nov 2023 09:49:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+6s4MYOhaFS5PKsAqpJ5K2jaDd7gb7TvhnIPf5H9XMi3/xfKGrICSbsosQ1R5HQsWb0dRIg==
X-Received: by 2002:a2e:9cd1:0:b0:2c9:caf3:e748 with SMTP id g17-20020a2e9cd1000000b002c9caf3e748mr51910ljj.5.1701365884905;
        Thu, 30 Nov 2023 09:38:04 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id s30-20020a05651c201e00b002c887ca5a70sm197252ljo.51.2023.11.30.09.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:38:04 -0800 (PST)
Message-ID: <ef8b40540c6cf1ed506928ec842e5602169ecdb6.camel@redhat.com>
Subject: Re: [PATCH v7 15/26] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:38:02 +0200
In-Reply-To: <20231124055330.138870-16-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-16-weijiang.yang@intel.com>
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
> From: Sean Christopherson <seanjc@google.com>
> 
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
> to facilitate access to such kind of MSRs.
> 
> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
> the guest MSRs are swapped with host's before vCPU exits to userspace and
> after it reenters kernel before next VM-entry.
> 
> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
> explicitly check @vcpu is non-null before attempting to load guest state.
> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
> loading guest FPU state (which doesn't exist).
> 
> Note that guest_cpuid_has() is not queried as host userspace is allowed to
> access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> The two helpers are put here in order to manifest accessing xsave-managed MSRs
> requires special check and handling to guarantee the correctness of read/write
> to the MSRs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.h | 24 ++++++++++++++++++++++++
>  2 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 607082aca80d..fd48b825510c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -133,6 +133,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>  static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>  
>  static DEFINE_MUTEX(vendor_module_lock);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> +
>  struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  
>  #define KVM_X86_OP(func)					     \
> @@ -4482,6 +4485,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>  
> +/*
> + *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
> + *  switched with the rest of guest FPU state.
> + */
> +static bool is_xstate_managed_msr(u32 index)
> +{
> +	switch (index) {
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /*
>   * Read or write a bunch of msrs. All parameters are kernel addresses.
>   *
> @@ -4492,11 +4510,26 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
>  		    int (*do_msr)(struct kvm_vcpu *vcpu,
>  				  unsigned index, u64 *data))
>  {
> +	bool fpu_loaded = false;
>  	int i;
>  
> -	for (i = 0; i < msrs->nmsrs; ++i)
> +	for (i = 0; i < msrs->nmsrs; ++i) {
> +		/*
> +		 * If userspace is accessing one or more XSTATE-managed MSRs,
> +		 * temporarily load the guest's FPU state so that the guest's
> +		 * MSR value(s) is resident in hardware, i.e. so that KVM can
> +		 * get/set the MSR via RDMSR/WRMSR.
> +		 */
> +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
> +		    is_xstate_managed_msr(entries[i].index)) {
> +			kvm_load_guest_fpu(vcpu);
> +			fpu_loaded = true;
> +		}
>  		if (do_msr(vcpu, entries[i].index, &entries[i].data))
>  			break;
> +	}
> +	if (fpu_loaded)
> +		kvm_put_guest_fpu(vcpu);
>  
>  	return i;
>  }
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 5184fde1dc54..6e42ede335f5 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -541,4 +541,28 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>  
> +/*
> + * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
> + * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
> + * guest FPU should have been loaded already.
> + */
> +
> +static inline void kvm_get_xstate_msr(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr_info)
> +{
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +	kvm_fpu_get();
> +	rdmsrl(msr_info->index, msr_info->data);
> +	kvm_fpu_put();
> +}
> +
> +static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr_info)
> +{
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +	kvm_fpu_get();
> +	wrmsrl(msr_info->index, msr_info->data);
> +	kvm_fpu_put();
> +}
> +
>  #endif


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky




