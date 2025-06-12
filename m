Return-Path: <kvm+bounces-49224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB844AD6751
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 07:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BFE917C5F0
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 05:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028711E9B1C;
	Thu, 12 Jun 2025 05:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TT07/vRz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8AA1E25F2;
	Thu, 12 Jun 2025 05:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706188; cv=none; b=YAEwXswNDecVd21x2jtpQpUXHMrWRj9miyKoufEFDzzWbqURpKvgg1Kdb7NX2mbk6XjMHkoCJOya4GoNs4MufjafgpbuQfncwTvwnr4vqe3VFmvpdw0QDUl8dp6maSU2rVeSqFSYoD22Vzysdy5eWyhgNYjQi92wRIYGiVGYSeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706188; c=relaxed/simple;
	bh=AE3+Ai7lW9yV7Ac20q5WllK+ofoz5XA1y3tE02Fp5yI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gUb5UNkE1Ph8TlNOszSbWtJFXnfUzaDfaVscmYJa+JHovOVYVGkWRYojYypCbUG0u0Pu5etneXJ3Xkkk5v16KoOJkAdaTcS+kk8GNY/pxar2eE3CUwxejD+cnWx4c2CQUMtkWu/0/dgZhh73BADCPmhMFCAhb8TSVKpVmabIcIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TT07/vRz; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749706186; x=1781242186;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AE3+Ai7lW9yV7Ac20q5WllK+ofoz5XA1y3tE02Fp5yI=;
  b=TT07/vRzIBOadGPAjadI8HiMoj5uZjdP+CyrmNO8f1QJKYOI+73Zr9zy
   9RuJTGfq4VEi4Gt4SmT9aBjharHmop++VCp+CWgDeBKDl8eEXSItr9af9
   H3kusK+h0qYiMqeh5LsF7TBmAGSpknOQufTJE6JauapbJpyQT9ee3q9ce
   W4K8qzI+gMUmvQJaCWzG6w1apP83jZ82Z5jNgB/8LnfmwohuPYGOVg2dO
   vLr8EXeH7pW178FHT0fjCIdO4xaywyiyCs6JO2xHN8qpa+TqNKm3RtNhI
   IEyKDUXc0q6NB7YAlp6nASwGgpdRSai1sCgNS2HtOQiClWQa7BVCUrVlv
   Q==;
X-CSE-ConnectionGUID: eftHv64mS5mUqT+gXxZWxg==
X-CSE-MsgGUID: bqpWRNqeSK+mavjAQx3T1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="52012676"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="52012676"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 22:29:45 -0700
X-CSE-ConnectionGUID: Iyt6SaMpTViTsFcwh9KemA==
X-CSE-MsgGUID: Bs/kYdOYRVOHKLwURPii/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="184633000"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 22:29:43 -0700
Message-ID: <cfd99e56-551b-49c5-b486-05c9f6d8cf11@intel.com>
Date: Thu, 12 Jun 2025 13:29:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Reject direct bits in gpa passed to
 KVM_PRE_FAULT_MEMORY
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, yan.y.zhao@intel.com
References: <20250612044943.151258-1-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250612044943.151258-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/2025 12:49 PM, Paolo Bonzini wrote:
> Only let userspace pass the same addresses that were used in KVM_SET_USER_MEMORY_REGION
> (or KVM_SET_USER_MEMORY_REGION2); gpas in the the upper half of the address space
> are an implementation detail of TDX and KVM.
> 
> Extracted from a patch by Sean Christopherson <seanjc@google.com>.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a4040578b537..4e06e2e89a8f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4903,6 +4903,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>   	if (!vcpu->kvm->arch.pre_fault_allowed)
>   		return -EOPNOTSUPP;
>   
> +	if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
> +		return -EINVAL;

Do we need to worry about the case (range->gpa + range->size) becomes alias?

>   	/*
>   	 * reload is efficient when called repeatedly, so we can do it on
>   	 * every iteration.


