Return-Path: <kvm+bounces-51383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9E4AF6B7D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 774501C42CF2
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C843B298CA7;
	Thu,  3 Jul 2025 07:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R3/ocehI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4943D2989BA
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527575; cv=none; b=qkVSWt3G6m3vajAO/v+p2CXBDoAiDqrXV/kebUvI3a/jva6k3BlhF6getZEbwGIzpQxOnHA7HSGc59MONKDW7y14Nc3wJEHOH2kJBGRGKRr96ocfU29w8KQ+C43Nc5fDXuB4+RKyrW1+K2AfBi2iGc/WjhcQK6PCcjoCbxpjy8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527575; c=relaxed/simple;
	bh=3tAVBMJz1cgvIFrjrSwAWbsjRKTYk2yoea1N3PHem44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdFanRM1cFDAFQja0X7oSgpF5TLEIeVW+izyS4uRKbBT0R5WQi61h1qWNuYIObjm3jzKGWbGxOT4Syeh6KNY13i1IvsAXr/IsHHmIwHKSLA8aHVNyrT+jQaMR4clpijrlVeqWyYBPprvMfkD4AG/FYYFy3jna+zK2qNVJVA453k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R3/ocehI; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751527573; x=1783063573;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3tAVBMJz1cgvIFrjrSwAWbsjRKTYk2yoea1N3PHem44=;
  b=R3/ocehIfyfCpIG18PnfCBFv6QoHz6NorcbWxUCuDJSpioYobnD69WWV
   ppLV6HCw12vt71X/DPmns5nUyKaObd5ilKrES9ITFyzGKMkm/6S+IGKnX
   1+n5c//HbMINe+1SFs+aM5nS794kQeffXsQBbJ5hKSdf6Q+asQp/Y0GMv
   B1LrsioM35MarrwV3MhIuBBKHrDIVu0QhOTncOjAXG0yJaZaVG80a5gsp
   4U3soXJNEOszKWyGw1ZKa/jqUOB3xq1l4dmQ93GTu8Dyjwpu3J1S9OZxi
   Kfe8We1bLLmjg3gHj6ZLODUBmYvOLZh6KctM+vyjg2R7G5YRYW8RzpkrS
   Q==;
X-CSE-ConnectionGUID: zWq7WsG1Tvq3OOwMl+bY3w==
X-CSE-MsgGUID: VSF4Y3cLSyyD18HUXqeWaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="41467332"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="41467332"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:26:13 -0700
X-CSE-ConnectionGUID: HCE289wUS4mKi25F3mAoUw==
X-CSE-MsgGUID: MT9r+anOR4mYdgY7IIJqfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158340963"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 03 Jul 2025 00:26:09 -0700
Date: Thu, 3 Jul 2025 15:47:34 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 03/16] i386/cpu: Add default cache model for Intel CPUs
 with level < 4
Message-ID: <aGY1llcyArD3T5wD@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-4-zhao1.liu@intel.com>
 <c93dce97-735b-4a1d-b766-f882e53eb50e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c93dce97-735b-4a1d-b766-f882e53eb50e@linux.intel.com>

> > +/*
> > + * Only used for the CPU models with CPUID level < 4.
> > + * These CPUs (CPUID level < 4) only use CPUID leaf 2 to present
> > + * cache information.
> > + *
> > + * Note: This cache model is just a default one, and is not
> > + *       guaranteed to match real hardwares.
> > + */
> > +static const CPUCaches legacy_intel_cpuid2_cache_info = {
> > +    .l1d_cache = &(CPUCacheInfo) {
> > +        .type = DATA_CACHE,
> > +        .level = 1,
> > +        .size = 32 * KiB,
> > +        .self_init = 1,
> > +        .line_size = 64,
> > +        .associativity = 8,
> > +        .sets = 64,
> > +        .partitions = 1,
> > +        .no_invd_sharing = true,
> > +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> > +    },
> > +    .l1i_cache = &(CPUCacheInfo) {
> > +        .type = INSTRUCTION_CACHE,
> > +        .level = 1,
> > +        .size = 32 * KiB,
> > +        .self_init = 1,
> > +        .line_size = 64,
> > +        .associativity = 8,
> > +        .sets = 64,
> > +        .partitions = 1,
> > +        .no_invd_sharing = true,
> > +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> > +    },
> > +    .l2_cache = &(CPUCacheInfo) {
> > +        .type = UNIFIED_CACHE,
> > +        .level = 2,
> > +        .size = 2 * MiB,
> > +        .self_init = 1,
> > +        .line_size = 64,
> > +        .associativity = 8,
> > +        .sets = 4096,
> > +        .partitions = 1,
> > +        .no_invd_sharing = true,
> > +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> > +    },
> > +    .l3_cache = &(CPUCacheInfo) {
> > +        .type = UNIFIED_CACHE,
> > +        .level = 3,
> > +        .size = 16 * MiB,
> > +        .line_size = 64,
> > +        .associativity = 16,
> > +        .sets = 16384,
> > +        .partitions = 1,
> > +        .lines_per_tag = 1,
> > +        .self_init = true,
> > +        .inclusive = true,
> > +        .complex_indexing = true,
> > +        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
> > +    },
> 
> Does this cache information match the real legacy HW or just an emulation
> of Qemu?

This is the pure emulation and it doesn't macth any HW :-(, and is a
"hybrid" result of continuously modifying and adding new cache features
(like the virtual L3). But for compatibility reasons, I abstracte it
into this special cache model, used only for older CPUs.

This way, at least modern CPUs won't be burdened by old historical
issues.

Thanks,
Zhao



