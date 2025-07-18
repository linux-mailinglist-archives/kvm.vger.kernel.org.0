Return-Path: <kvm+bounces-52859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA07DB09B33
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A46D05A5D24
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5DB1FBE9B;
	Fri, 18 Jul 2025 06:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5Dbznuf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033851F03C7;
	Fri, 18 Jul 2025 06:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752819280; cv=none; b=qIEz9jDkjGvwirTdgPluHYOPLAb33sU42yI5SxLBqWvnsHAJF4JFGm2m+i0EzXyWm2tBmFiKrESAaPdAHTNG/v7Erevos31arCBuKcm0TljiVUA2xpnSrSqolLhpfMy+zEZDlv1/KHyysssTcoaDS/ZF1B1kxdduJ4z0+YFQA8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752819280; c=relaxed/simple;
	bh=XcJZ6mYKjvZl9/FELeN8l47ZXRZ5CIivhly0oeD5djo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a1PUWCpXngWjlELhaizrUQvBvjfPPzjaKlzCygN9hsQeNeiNYw+6E65zMCR/bqjolREN0ItzzVN8KEfMigGJKryqUmA2UKWvdal6grhdU0GjqfK0yRVFprs8XM0oTrjU/Eh7FAN52T80bVSHK/cQANHPelgMpGRLsaPyw2QJqVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k5Dbznuf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752819280; x=1784355280;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XcJZ6mYKjvZl9/FELeN8l47ZXRZ5CIivhly0oeD5djo=;
  b=k5DbznufScE0dHBblibrPyEYkIfBvh+8wtxAx7kVey85ThGBqc8v6dyZ
   dnrK9l5/sn2tyPYv5p7U7KEdtvkqY6Iow35X469RTxobqoZZ3RrVI/vfP
   QzV+KEbPJB0FTOCkPBA99ZanNs2/Y8tviB0ofm45e2JwECU/epvm25keq
   9vMYO87ExYmPJTMf+Rg+UdSoemKcwYHlsiFOVTQ+HOOaPJz1SgO92Qhg5
   wrTTPrHR29WbuM2A2EHH4UHM0F21cBW/lSfgmO8Ww1kyXGR8+9GPe7iMU
   zlM4t9/G6w4nf4zWhNrHov1xaYa9xGfx4/ks80eVPXT+H1dz8+saTIMeJ
   A==;
X-CSE-ConnectionGUID: z45sjKxiSGGmwXc8YhM/9w==
X-CSE-MsgGUID: VeJhsbOBSIq2685+tmzhuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="55231641"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="55231641"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:14:39 -0700
X-CSE-ConnectionGUID: QjMd2QMOTIW9uNutYiZLDg==
X-CSE-MsgGUID: tZgUpPdKQHO9i74VxV/2pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="158062418"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:14:23 -0700
Message-ID: <0f31ab50-e30a-40d5-96ae-ee54742d98f9@intel.com>
Date: Fri, 18 Jul 2025 14:14:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 19/21] KVM: Introduce the KVM capability
 KVM_CAP_GMEM_MMAP
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
 <20250717162731.446579-20-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-20-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> Introduce the new KVM capability KVM_CAP_GMEM_MMAP. This capability
> signals to userspace that a KVM instance supports host userspace mapping
> of guest_memfd-backed memory.
> 
> The availability of this capability is determined per architecture, and
> its enablement for a specific guest_memfd instance is controlled by the
> GUEST_MEMFD_FLAG_MMAP flag at creation time.
> 
> Update the KVM API documentation to detail the KVM_CAP_GMEM_MMAP
> capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
> information regarding support for mmap in guest_memfd.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Though I have comments on some patches, the general functionality for 
x86 seems to be work. I plan to do a POC with QEMU to test non-coco VM 
with guest_memfd with mmap support as the memory backend.

