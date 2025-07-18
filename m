Return-Path: <kvm+bounces-52828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA83DB09958
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED3497A49BD
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8742191F72;
	Fri, 18 Jul 2025 01:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GeiZKkhg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F311712;
	Fri, 18 Jul 2025 01:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802977; cv=none; b=McH/YJ/0hfWK3oeCJDFoPAV4R0dqAqtwfqDARkeI8wf8P+/WjhikG3rylRH7a/s+BeO3wyXkZB98LvxEn/OKtIbHlHq30Msw8l9D4u6uEH1Wdo2DQ3dOQnlnUbB0/ezK2MBgqJiu+V+5INAEB5K0GIfuugZkrDCrmJTTrrlKLA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802977; c=relaxed/simple;
	bh=nALzQ13/hKtBqXb8rfNtCTmHGGtFpFLO/y5dIAkAQfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KL8s4feO58b6yW98UR/Fba96jIKcqu2Jk8zM+6/ffNL+9eIrSf00nyXnf3SCJcn3ep7CxBGP2gM/eYtcqqaqybJEC3BC+rI9r2RhGhe52vevR9OVp7NlHYoFDVWY78Pa+xDFbYsiHg2Rj39wYxNaszIX0HnW53Mp+/vYIJ27rE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GeiZKkhg; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802976; x=1784338976;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nALzQ13/hKtBqXb8rfNtCTmHGGtFpFLO/y5dIAkAQfY=;
  b=GeiZKkhggLMerCycTOca4mSA4KOxmxrdEONrl2zKF3g3xD4otfEdMle1
   NIt2nk0haMu/yj1TGz+fh11XWEp4heA6mdfXp+2aLkGjJhNn5iSA0kRIb
   QXyBWo6FdvAlhXU1qJRzqws7bScOdqZ+MOrvgFjZNYaN7GM5yKQkLPWBS
   aI4QtGWnBuEGGStLnIl/GVFbUKFr8suKLTp38UgfGW8Vx+c30xm2PilIr
   xmADptvaG7Yp3hgUDZrDKytnsNw87J+0tzhhISEXsGEz/yUcWdHIM2I25
   8j1zQgCRm3qnN0S1mkOXhZCPTCDakvIRWFtkg30rbOhZhKJweKIB6QpzR
   w==;
X-CSE-ConnectionGUID: OvkIr1KfRUqIchvpcPFIrg==
X-CSE-MsgGUID: 13pPtwk9SwmOed85rkaa9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="77632278"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="77632278"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:42:55 -0700
X-CSE-ConnectionGUID: ZkS0VEoES4W3YCuvt7mYLA==
X-CSE-MsgGUID: koIEcje3TW2XcXgRJ6Mvag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157754551"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:42:40 -0700
Message-ID: <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
Date: Fri, 18 Jul 2025 09:42:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
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
 <20250717162731.446579-4-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> -/* SMM is currently unsupported for guests with private memory. */
> +/* SMM is currently unsupported for guests with guest_memfd private memory. */
>   # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)

As I commented in the v14, please don't change the comment.

It is checking kvm_arch_has_private_mem(), *not* 
kvm_arch_supports_gmem(). So why bother mentioning guest_memfd here?


