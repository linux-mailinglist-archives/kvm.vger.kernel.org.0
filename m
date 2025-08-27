Return-Path: <kvm+bounces-55840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63578B3795F
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 06:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F96E1B65211
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 04:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E972A30AD17;
	Wed, 27 Aug 2025 04:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jA5Kb8ch"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35BE30ACFB;
	Wed, 27 Aug 2025 04:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756270661; cv=none; b=XR/ro7MBQeAhpG8HT3MVVX5U+AF5wIznMjftIC5hpwhACfE5fKhmVxFW7c6XxtvjwRwZsKn5R8ASrjqz4kdlFIA3r/VbIEp8xzJHCg8fw4yn3e32eTwFonqL6KF9QZzuD9sPTpSTgGN255c3p8579DCz4dO7EGjHl4/I6t6vSFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756270661; c=relaxed/simple;
	bh=sPZ7qFxktwh9lJA/W7gHHheGm5ILGH9k79B/lOMqmzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mkf0l9jZq0CbubIf0+THRCKKAiVqtUL460+Brnsn3qNrJhxmFLXZLTbZscGvzRkVikhz7zyI0vWx793oAYJ4ynYbMAfx385DBVonYi3Py2bgKarSEbnFbSPqvnj8LxGrN8CpDl9ndYmETau/GyvD56WdPvp3olbNB9ibfkPf+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jA5Kb8ch; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57R4v0AJ1455839
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 26 Aug 2025 21:57:00 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57R4v0AJ1455839
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756270622;
	bh=0gtMo7Q5t6Htt/R+vOAdfENQjHWiNRcIEYBbLuCWw6Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jA5Kb8chHhQGUf3FBRw6639SkbbP+p9a+sTC2czkU3XmFZUDu99Wgn8AeNlfpgi+g
	 5/Rym+Su1vggX13j/QOJq+b2o1WK49aBawBwbwl1YZjfqLz+c3e7pb8euq9E0j8aTt
	 mEfK6K/vNkbAqDnhYPJKM19X059zfJWDhtrSZvoxMJJa7GvwS8byxUvxcUW8ufl5dR
	 3g6uYqQgbF2LGd6LSojWuZ1LlUjYnKfAS0HTnSB7pGTEX4LRYsGNGHWRHtG+mTuGh9
	 YCLX6OWEXtYAj1X12LWvYcffM+xRBodUsoABwLmsD45BNb5Agj0rm25+XbmP95lggq
	 IX+SzWc+KvyUA==
Message-ID: <ae363ab5-8985-4c4e-910e-969d442cd7ed@zytor.com>
Date: Tue, 26 Aug 2025 21:56:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/21] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        john.allen@amd.com, mingo@redhat.com, minipli@grsecurity.net,
        mlevitsk@redhat.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        seanjc@google.com, tglx@linutronix.de, weijiang.yang@intel.com,
        x86@kernel.org
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-6-chao.gao@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250821133132.72322-6-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/2025 6:30 AM, Chao Gao wrote:
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index eb3088684e8a..d90f1009ac10 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -701,4 +701,28 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
>   
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
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

s/rdmsrl/rdmsrq/

> +	kvm_fpu_put();
> +}
> +
> +static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr_info)
> +{
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +	kvm_fpu_get();
> +	wrmsrl(msr_info->index, msr_info->data);

s/wrmsrl/wrmsrq/


Perhaps it's time to remove rdmsrl() and wrmsrl(), as keeping them around
won't trigger any errors when the old APIs are still being used.

> +	kvm_fpu_put();
> +}
> +
>   #endif


