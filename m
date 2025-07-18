Return-Path: <kvm+bounces-52860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA562B09B41
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:19:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57B863AE249
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920FD1F4CB7;
	Fri, 18 Jul 2025 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eivs3cUq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617E21E9B19;
	Fri, 18 Jul 2025 06:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752819572; cv=none; b=rPLo40ViNfvWkzfvnnKleoR48IPzZIf7162FqVCxs7rIdzcc7ElDpP8E6b7oae//3V3lHO0jEHJDK348yLFFsiKHSWvzrXQx7Pen/Mnt99HMg7IIRiKd20Q8ShhCCwVvMFAB8qAVa3mSbfQbuPZ56lDJnrORC7oX0euQ9DYQKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752819572; c=relaxed/simple;
	bh=h6fTbzxB8EZ1LSr41gvQc07pwMx3ZFCzi8pYHbC1bNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iv65IB0gJzsI70ScJze7Om/9GFuNQ04BYAN5Helnn0XKJf8A9KnUk9zA0bte3p1wSXz84je5XH1F/yzF/nnXLe8jP053buVwkr1KmML0cq7fC0a2tZ83w/x8UZhONOctcPdgebbWFZE/kEGmLItxCoQFNJH9EonreqoXluJSJTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eivs3cUq; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752819571; x=1784355571;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h6fTbzxB8EZ1LSr41gvQc07pwMx3ZFCzi8pYHbC1bNk=;
  b=Eivs3cUqRS80GmiY1eIaskY9QNMkBIMBsdtIJKWW9poIdX3CWCoIFw5S
   T9W+rirC2rRNdLFtTmGiXOBTMjZnYPn/gVnjzV1cPbMGt5bhjh2RqVgoz
   j8I/X70GFRM19nI7vKHg/3eR9jU5ekBYg1czGoVnZXEnRpDhUIB5o+Y0w
   XIS/YmkGUt9QwY/e6+dOmUUAVATMLpfDIbL59Flzc9b5s6rgGpszX+mnk
   IKMKvnqWK0IenVh65gA0ZBjOJY63svODvgZ/0FX8jSbQTV+ESo/GuZ5kY
   E4kUapeTnmi6rePbWzstswI2Xopd25viWuSwr4ZP+BbWuDhldq830a04b
   A==;
X-CSE-ConnectionGUID: HAtlq+v7Tw6KcJKyN99qtw==
X-CSE-MsgGUID: pTHbmB60QHm93xAvGcD9gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="80553632"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="80553632"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:19:31 -0700
X-CSE-ConnectionGUID: WVyscegLRjOjWNORncxODw==
X-CSE-MsgGUID: ytwcFLY5SsuuOC44yR5wMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157797786"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:19:15 -0700
Message-ID: <39dccffe-ac30-45e2-9146-e26e958ef9d9@intel.com>
Date: Fri, 18 Jul 2025 14:19:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 10/21] KVM: x86/mmu: Generalize
 private_max_mapping_level x86 op to max_mapping_level
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
 <20250717162731.446579-11-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-11-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Generalize the private_max_mapping_level x86 operation to
> max_mapping_level.
> 
> The private_max_mapping_level operation allows platform-specific code to
> limit mapping levels (e.g., forcing 4K pages for certain memory types).
> While it was previously used exclusively for private memory, guest_memfd
> can now back both private and non-private memory. Platforms may have
> specific mapping level restrictions that apply to guest_memfd memory
> regardless of its privacy attribute. Therefore, generalize this
> operation.
> 
> Rename the operation: Removes the "private" prefix to reflect its
> broader applicability to any guest_memfd-backed memory.
> 
> Pass kvm_page_fault information: The operation is updated to receive a
> struct kvm_page_fault object instead of just the pfn. This provides
> platform-specific implementations (e.g., for TDX or SEV) with additional
> context about the fault, such as whether it is private or shared,
> allowing them to apply different mapping level rules as needed.
> 
> Enforce "private-only" behavior (for now): Since the current consumers
> of this hook (TDX and SEV) still primarily use it to enforce private
> memory constraints, platform-specific implementations are made to return
> 0 for non-private pages. A return value of 0 signals to callers that
> platform-specific input should be ignored for that particular fault,
> indicating no specific platform-imposed mapping level limits for
> non-private pages. This allows the core MMU to continue determining the
> mapping level based on generic rules for such cases.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

