Return-Path: <kvm+bounces-52852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE35B09AF6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 07:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6ED01AA172E
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FC81E3772;
	Fri, 18 Jul 2025 05:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYqnjROV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6804A930;
	Fri, 18 Jul 2025 05:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752816789; cv=none; b=JTuw2yOJyuqfNDWreTMZs4ENLjmUtmkijRPDvtTKA2pdMzhrjgEeAW37eFk/1XaPUAAi9mZu6hJ0iUD5K6reRW1wHIvJuP7bwZkjaDuhdKBNO2Z78msrj09SIMjaV7FRtGsgHcuJk21PsJkmxIsKJMsTAGFZc5Qttxk7nd4SPmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752816789; c=relaxed/simple;
	bh=skKA5qufp6yfNZDuBB5caSttx/BReKJ+preOQVYf5lE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qNVFzMdE/Y/p0cBq26i9zAOw097PuT+FeO9843vybbrGAs7evVll6hMRDZ4DhAfaFaLLMh6beh1cJycAvg1FchymR2x/PI5Ms2wq0ZvG5xQO0K48jUXr3s9sfJJt5+NZ/1xFjMN+IdYTOOvzZLiM6O56IFfkP2p82GszlPJ8jc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYqnjROV; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752816788; x=1784352788;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=skKA5qufp6yfNZDuBB5caSttx/BReKJ+preOQVYf5lE=;
  b=JYqnjROVmZs+DasIvJH1YzfI29lCkDv+AffPFGYZNUqpat/do1VbkZCi
   ZifulmWHMm8HdLq5Xe5+f+VIJRhS1CvGAx30I/A5Z5seeYdlt+dWr3KF0
   3jbXEmb//cpDZuY61a6jC+jZ7FElGCsrc2F6ZXzPiqXj2PlKYCijZFEeM
   OcPMY2gCNG0FtEmZaUPTeL6Kom2TkjyFIZZJDZyBYKI8LFpIW6h89/Y8a
   qomiPz0+k46atPPvzm79DsC/eTRz6j0LRARFw4xPCOMyJ4c2OD+mNeNqo
   47YcG1rMNMSgXB5ZVqA9oZFGttf68k6XMiztWAFx2FPh0bTTGx7x5npI7
   Q==;
X-CSE-ConnectionGUID: 8xMSDbtVRAui1qrnFy/6mQ==
X-CSE-MsgGUID: iHU/Ybh/QkqBlKvwUj5XhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65678688"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="65678688"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:33:07 -0700
X-CSE-ConnectionGUID: n0aEyWgCQzm9pzjS33gCdA==
X-CSE-MsgGUID: Km5RZh//Seue6XSZKZzFQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="181687772"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:32:51 -0700
Message-ID: <9b425918-1858-47d6-a1cd-1b44d5898ab4@intel.com>
Date: Fri, 18 Jul 2025 13:32:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/21] KVM: x86/mmu: Consult guest_memfd when
 computing max_mapping_level
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
 <20250717162731.446579-13-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-13-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Modify kvm_mmu_max_mapping_level() to consult guest_memfd for memory
> regions backed by it when computing the maximum mapping level,
> especially during huge page recovery.

IMHO, we need integrate the consultation of guest_memfd into 
__kvm_mmu_max_mapping_level, not kvm_mmu_max_mapping_level().

__kvm_mmu_max_mapping_level() (called by kvm_mmu_hugepage_adjust()) is 
the function KVM X86 uses to determine the final mapping level,
fault->goal_level.

