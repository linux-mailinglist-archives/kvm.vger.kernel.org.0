Return-Path: <kvm+bounces-223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FD47DD51D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AF11B20BE5
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377A220B10;
	Tue, 31 Oct 2023 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S4K0i1Dd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC36208C6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:47:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482D0B4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8gN1E0qkL8gM8KwD/+d6NxFSXLY+pIiGeicsPrALt8=;
	b=S4K0i1DdgrSGJAT08OYx6E/G3jin2XlcnWqdypSczy2xAnTOdyjtlF77IxCH4uwK+zvy5V
	BYcINmgOuCNb7DYpFQsxmY+nBHxGDimrNU9SNuA1jjWlBuUE34Lbo+ZK5b9Sl8lehWkKT7
	a8fb394Fa7Siny7HksdjkOoBbvdCo20=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-v5PPTJ25OFuS1E0Hqutpyw-1; Tue, 31 Oct 2023 13:47:05 -0400
X-MC-Unique: v5PPTJ25OFuS1E0Hqutpyw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32deb4e2eb7so2792729f8f.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774424; x=1699379224;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q8gN1E0qkL8gM8KwD/+d6NxFSXLY+pIiGeicsPrALt8=;
        b=BPSyHRySFTWH0qmPzsZASt3OlKtpnOIYI6dWVUalcH94pB3r9hJ6csh5sb/Te16/zf
         fEL4tQvEGIM8UhXI23W2i2VIFPNFeg+GSzaYsBKt4cr23M97wv/C+cXjN5UuMwoi5aah
         F9d5ihy/daesQQ1NxftNkBItyrE+QpB7LJSY9K73CcEv+lyhgX+VeKmV6jatpIHuwLnS
         za7vOffCjfoKR/mkat/4vPMY35rA6RKIJZfxBzmocGcVZHL0YC/BTVKVyFJLH5T7wc0a
         OX2C0OM9pvRJvmhuuFIpesTmanrBujAWVqdPFz/71mgxS03Mnkk30jvfW0aRnpiftx32
         pEZg==
X-Gm-Message-State: AOJu0Yx+6/WXTTysVR6gj9TRX0LBRFfqI6bLkhN/tYBcwLVs1WXPigNY
	yq93nqfOye0/G9ge162oCyT2pF9TR8CMNdcOqbGtFleWlyucf913RLwK7RIiDXSlkW8FDEVaTH6
	BG8FcdMLv2oFm38pUuS6d
X-Received: by 2002:adf:f286:0:b0:31a:d450:c513 with SMTP id k6-20020adff286000000b0031ad450c513mr11142591wro.26.1698774423894;
        Tue, 31 Oct 2023 10:47:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHP9BCCeLEq6xdvs0Wx3pQhh6AItnLCO3wuz6+zvdhlWsIln3ZP18nlHwSoZ2VX9KH84ZLWTQ==
X-Received: by 2002:adf:f286:0:b0:31a:d450:c513 with SMTP id k6-20020adff286000000b0031ad450c513mr11142577wro.26.1698774423599;
        Tue, 31 Oct 2023 10:47:03 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id w5-20020adfec45000000b0032d9523de65sm2008194wrn.48.2023.10.31.10.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:47:03 -0700 (PDT)
Message-ID: <92faa0085d1450537a111ed7d90faa8074201bed.camel@redhat.com>
Subject: Re: [PATCH v6 10/25] KVM: x86: Add kvm_msr_{read,write}() helpers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:47:01 +0200
In-Reply-To: <20230914063325.85503-11-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-11-weijiang.yang@intel.com>
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
> Wrap __kvm_{get,set}_msr() into two new helpers for KVM usage and use the
> helpers to replace existing usage of the raw functions.
> kvm_msr_{read,write}() are KVM-internal helpers, i.e. used when KVM needs
> to get/set a MSR value for emulating CPU behavior.

I am not sure if I like this patch or not. On one hand the code is cleaner this way,
but on the other hand now it is easier to call kvm_msr_write() on behalf of the guest.

For example we also have the 'kvm_set_msr()' which does actually set the msr on behalf of the guest.

How about we call the new function kvm_msr_set_host() and rename kvm_set_msr() to kvm_msr_set_guest(),
together with good comments explaning what they do?


Also functions like kvm_set_msr_ignored_check(), kvm_set_msr_with_filter() and such,
IMHO have names that are not very user friendly. 

A refactoring is very welcome in this area. At the very least they should gain 
thoughtful comments about what they do.


For reading msrs API, I can suggest similar names and comments:

/* 
 * Read a value of a MSR. 
 * Some MSRs exist in the KVM model even when the guest can't read them.
 */
int kvm_get_msr_value(struct kvm_vcpu *vcpu, u32 index, u64 *data);


/*  Read a value of a MSR on the behalf of the guest */

int kvm_get_guest_msr_value(struct kvm_vcpu *vcpu, u32 index, u64 *data);


Although I am not going to argue over this, there are multiple ways to improve this,
and also keeping things as is, or something similar to this patch is also fine with me.


Best regards,
	Maxim Levitsky

> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++-
>  arch/x86/kvm/cpuid.c            |  2 +-
>  arch/x86/kvm/x86.c              | 16 +++++++++++++---
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1a4def36d5bb..0fc5e6312e93 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1956,7 +1956,9 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>  
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> -int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
> +
> +int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> +int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
>  int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
>  int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
>  int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7c3e4a550ca7..1f206caec559 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1531,7 +1531,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  		*edx = entry->edx;
>  		if (function == 7 && index == 0) {
>  			u64 data;
> -		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> +		        if (!kvm_msr_read(vcpu, MSR_IA32_TSX_CTRL, &data) &&
>  			    (data & TSX_CTRL_CPUID_CLEAR))
>  				*ebx &= ~(F(RTM) | F(HLE));
>  		} else if (function == 0x80000007) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6c9c81e82e65..e0b55c043dab 100644
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
> @@ -12082,7 +12092,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
>  
>  		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
> -		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
> +		kvm_msr_write(vcpu, MSR_IA32_XSS, 0);
>  	}
>  
>  	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */







