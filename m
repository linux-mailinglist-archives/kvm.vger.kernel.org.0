Return-Path: <kvm+bounces-3030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 897317FFD37
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 22:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D33C1C2110D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E50555C10;
	Thu, 30 Nov 2023 21:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V4KgDL/H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9721708
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 13:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701378163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnILF2v/UzJSC3TfPsanWxRS5vhVZJoM93lB9ErtfnU=;
	b=V4KgDL/HioblTHo8bYGbPTkIbJgNbZJ6rLpBLZCUUq+mRVqlVoSVf5yyrrvvr9F4qLG+kf
	fkpqdHYYcdKzqG39nmcQoU16vpWRQ9oO9mXF0sIIslaEfNBqyoaeci5atObzCxVKubcNlp
	AXxvvb0n1tpaz7JFFCuqZa/4YR3vuM4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-L0QAQoXuPU2r2YA0xsHB6Q-1; Thu, 30 Nov 2023 16:02:42 -0500
X-MC-Unique: L0QAQoXuPU2r2YA0xsHB6Q-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b346a11d9so10285425e9.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 13:02:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701378160; x=1701982960;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vnILF2v/UzJSC3TfPsanWxRS5vhVZJoM93lB9ErtfnU=;
        b=j7fxSYDFiM667LPPjO22Z477g1gfyER9mewDBKJPT4Xsa1GBMypB+O2fEltRuQuknQ
         gvQ/45NexsDyGaf+GDVC6rj099NyUR+NfBobEF1mui6Dr7fIZC3BagUgde3vp4s04TTG
         ivKyNbcB1IrIjKktcR+HFqEWHE9YP47WBIhmNoAiIvYgtVrEgBzWWKtRGEyHR9xUNwoU
         cMZGl1K7dzABFf+G4G8F7VqkRKJFH+sPozLKjb8HClI6Kze5mHcJEy2iMKeyDn6+ddyH
         MXk+u6KFYN9l53faSL3yuxoKXlAazGfsfhPxjZC47carHt/Z1i7cjZsv1c0iLwHTAfxD
         fh1g==
X-Gm-Message-State: AOJu0YxHAo1uKtIPPTZqiSUBwzd22vJFqt1I8wR62SJYTbBhIejwP79K
	X+YpJ3ilcj6mI+8hpsSlRgBTGVgGXFesaVvD72HVwqZYDpCDqjxpcUtCs+TBXgb6/ei6/utbuMy
	ECT9GNvQ/HJkIkykTL68V
X-Received: by 2002:a05:600c:1ca0:b0:40b:578d:2472 with SMTP id k32-20020a05600c1ca000b0040b578d2472mr43738wms.1.1701378160541;
        Thu, 30 Nov 2023 13:02:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGN4k847W+sNMTAQ1rVITqOi2a2slCKD3b7VwuEiUy32DuKveRfuk3Ji+UhnvOR79GVGLtzAg==
X-Received: by 2002:a17:906:5306:b0:a19:34e1:990a with SMTP id h6-20020a170906530600b00a1934e1990amr123778ejo.22.1701365832293;
        Thu, 30 Nov 2023 09:37:12 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id e17-20020ac25471000000b00500b19152cbsm212362lfn.8.2023.11.30.09.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:37:11 -0800 (PST)
Message-ID: <b59246b1ab68941eb62984bc220f071a9e8e58f7.camel@redhat.com>
Subject: Re: [PATCH v7 11/26] KVM: x86: Add kvm_msr_{read,write}() helpers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:37:09 +0200
In-Reply-To: <20231124055330.138870-12-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-12-weijiang.yang@intel.com>
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
> Wrap __kvm_{get,set}_msr() into two new helpers for KVM usage and use the
> helpers to replace existing usage of the raw functions.
> kvm_msr_{read,write}() are KVM-internal helpers, i.e. used when KVM needs
> to get/set a MSR value for emulating CPU behavior, i.e., host_initiated ==
> %true in the helpers.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/cpuid.c            |  2 +-
>  arch/x86/kvm/x86.c              | 16 +++++++++++++---
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5cfa18aaf33f..499bd42e3a32 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1966,9 +1966,10 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>  
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> -int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
>  int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
>  int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
> +int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> +int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
>  int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
>  int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
>  int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d0315e469d92..0351e311168a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1527,7 +1527,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  		*edx = entry->edx;
>  		if (function == 7 && index == 0) {
>  			u64 data;
> -		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> +		        if (!kvm_msr_read(vcpu, MSR_IA32_TSX_CTRL, &data) &&
>  			    (data & TSX_CTRL_CPUID_CLEAR))
>  				*ebx &= ~(F(RTM) | F(HLE));
>  		} else if (function == 0x80000007) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 16b4f2dd138a..360f4b8a4944 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1917,8 +1917,8 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
>   * Returns 0 on success, non-0 otherwise.
>   * Assumes vcpu_load() was already called.
>   */
> -int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
> -		  bool host_initiated)
> +static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
> +			 bool host_initiated)
>  {
>  	struct msr_data msr;
>  	int ret;
> @@ -1944,6 +1944,16 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  	return ret;
>  }
>  
> +int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
> +{
> +	return __kvm_set_msr(vcpu, index, data, true);
> +}
> +
> +int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> +{
> +	return __kvm_get_msr(vcpu, index, data, true);
> +}
> +
>  static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>  				     u32 index, u64 *data, bool host_initiated)
>  {
> @@ -12224,7 +12234,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
>  
>  		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
> -		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
> +		kvm_msr_write(vcpu, MSR_IA32_XSS, 0);
>  	}
>  
>  	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


