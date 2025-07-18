Return-Path: <kvm+bounces-52837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4820DB099FC
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853591C451BB
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A4A1C861A;
	Fri, 18 Jul 2025 02:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Liyy2nFE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3EA1A23A0;
	Fri, 18 Jul 2025 02:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752807430; cv=none; b=Lea+ga2I+BF1PivqGBQ2SCPaiu0nKfFDldce8ql/+jj2g7Ox0e7Wf7bXwAxJRBLU5XxakGdt7RGyuXHNUadFPWBrRUv62QROddP2bAFgpqYy2WUR9mNpCwLtvKVKfs5iWT8WOvzMNaEJC5KEPEFmK+Jb/GSKOvEEY4AkzAJCsbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752807430; c=relaxed/simple;
	bh=VNm2yIjyNR+4MfYbdw7jgNE502i3pDkkpT5hsJAXhcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0kIKuWR9HsMkjl5NUmVFSvafjjHrqRvqoVzNIt0m/SornAGOJfvSkvgxX0GCW/OJYNJYhf64FZ3dsgUKlisFJVffJPp0685+bRKUEzzgeKYAW4Uqchq4NS8C8Fln5mglI1FBqNrZhDyQLB5Y7JEOc6X+SN0HjzUXN3jJ7KPUVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Liyy2nFE; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752807427; x=1784343427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VNm2yIjyNR+4MfYbdw7jgNE502i3pDkkpT5hsJAXhcQ=;
  b=Liyy2nFELVMIHEAHmvpKLLfZQy8xqkXINx8KYsi56ehNzu34T2NTC8jr
   Q+iOyxWJDH6QhUtA4kSjc6Xq71SolJ8VNc18XvB+oKV839HTa+XKfIPCb
   /uFbxvDCcaV2zv6AhZ+RJkhE/SnG+OGtTk1A5Y7JQyAio1ZbshTC31Oyb
   8Uv+CezNwOC/Ax4rODTrbTNV2DxNJN8uyaBiAY43XvI437uZ7BEMBJrpZ
   siNJiJ+8vjUjdp/4hmBm2IKYTCsuWs8IlptyMRFu084+odk6g5j+X3+Xe
   FViA90ve6ucVC1c2lRh1cU/HTa0WijqSu6aPDY3aNPK6OaRwT91y7aLcz
   g==;
X-CSE-ConnectionGUID: q/AKncLIS820ddFdeVhpzA==
X-CSE-MsgGUID: H6ctt6itQKmG0ww4fZhN3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54977952"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54977952"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 19:57:06 -0700
X-CSE-ConnectionGUID: 4aAcsyaETE28nvuGRlN+zw==
X-CSE-MsgGUID: BbAsaMudTLW2zflXrSC6Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157340783"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 19:56:52 -0700
Message-ID: <cfa96c5a-3301-4f57-b14a-1243d0556e64@intel.com>
Date: Fri, 18 Jul 2025 10:56:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 08/21] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-9-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1ec71648824c..9ac21985f3b5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -740,6 +740,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>   }
>   #endif
>   
> +/*
> + * Returns true if this VM supports mmap() in guest_memfd.
> + *
> + * Arch code must define kvm_arch_supports_gmem_mmap if support for guest_memfd
> + * is enabled.
> + */
> +#if !defined(kvm_arch_supports_gmem_mmap)

Unless being given a reason or you change it to

#if !defined(kvm_arch_supports_gmem_mmap) && !IS_ENABLED(CONFIG_KVM_GMEM)

I will repeat my opinion as what on v14[*]

* It describes the similar requirement as kvm_arch_has_private_mem and
* kvm_arch_supports_gmem, but it doesn't have the check of
*
*	&& !IS_ENABLED(CONFIG_KVM_GMEM)
*
* So it's straightforward for people to wonder why.
*
* I would suggest just adding the check of !IS_ENABLED(CONFIG_KVM_GMEM)
* like what for kvm_arch_has_private_mem and kvm_arch_supports_gmem.
* So it will get compilation error if any ARCH enables CONFIG_KVM_GMEM
* without defining kvm_arch_supports_gmem_mmap.

[*] 
https://lore.kernel.org/all/e1470c54-fe2b-4fdf-9b4b-ce9ef0d04a1b@intel.com/
  > +static inline bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +


