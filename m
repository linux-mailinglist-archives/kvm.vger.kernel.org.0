Return-Path: <kvm+bounces-65196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C67ADC9ECF3
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 12:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6AD43A2489
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 11:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A0A2EA146;
	Wed,  3 Dec 2025 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oyd3+z7l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199242741BC
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764759970; cv=none; b=W84+8RjtNTxpkpMKM5BubK4gvwqDH15M4m/R66WFCoRjdfJi3dbeD2U0P86EeB4369zDkMRUZWfeJSA2XKVdEhOV7YKUa/2Bs9tmRvIomvBZygZe+wErnH8U9ccXo9sOJLB13U0WOGeKopCDLtSW058o8Mo5R5DnzNW5O3+8Ru0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764759970; c=relaxed/simple;
	bh=S3zEWqt2WDEkieWuJEpVZ1iQbEtIUwDQynod8PDBc3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AtbeioTinCTCHPqkLp5OvOHXgavF/iDyoNNkRQO3oH3OhzWAfBVNPfdhQR02vuu+X/YAgeFFBXZvMmPnY66aD7ue20AV7zmU1rW5vf6ifvkdmEpQ4nyWkXhle/OrJ5GDcwC91nbXyXW4cCDbtG8nu8+a3+inOd0KcsGzpp9MQpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oyd3+z7l; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764759969; x=1796295969;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S3zEWqt2WDEkieWuJEpVZ1iQbEtIUwDQynod8PDBc3g=;
  b=Oyd3+z7l4R/4u1pQsLwbdesCWtOt/boTBg8kk3F2BQUU+GJRdGSJp23a
   ucTeJ9koIGzqpMhG2mKi1fI2RTjDK958YgYCLDrFNB+punaD2F37WOF9D
   GUsfLzc77dPuKgXcPUJrFvloLkwH+N/RBn3g3cxVp/OTNcrVQNpp0zKOG
   dQyh7/yZgZgBLx40VI4XQamYZlzuZd63vH5NAp0i6YiBJLMdGtrrI6KEv
   ibnz4YhaQfArA6y1qUPOpcrlzuoizBpMpyqPW0rqheOxQabxNIMDa7C7g
   w+RlSJY5tcwexDP2NOuavLBn0bJmsfen7eAyUUS6WCY1Qyr0UlkCdjyjf
   g==;
X-CSE-ConnectionGUID: rPAXgLj0RN6IZHC58h07Pg==
X-CSE-MsgGUID: jLDfNnv4Qyiou6+vFEzNxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66689637"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="66689637"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 03:06:09 -0800
X-CSE-ConnectionGUID: wASkKCcpQsqcOhweGoPbNA==
X-CSE-MsgGUID: KEkZEq7HQUaxDAuMoZMxDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="195065351"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 03 Dec 2025 03:06:05 -0800
Date: Wed, 3 Dec 2025 19:30:48 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>, John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v4 06/23] i386/kvm: Initialize x86_ext_save_areas[] based
 on KVM support
Message-ID: <aTAfaIPST8skLrUs@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
 <20251118034231.704240-7-zhao1.liu@intel.com>
 <5675fe47-f8ca-468a-abb6-449c88030a5f@redhat.com>
 <aS/uGsU39/ZbXDij@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS/uGsU39/ZbXDij@intel.com>

> > Can you move the call to kvm_cpu_xsave_init() after
> > x86_cpu_enable_xsave_components()?  Is it used anywhere before the CPU is
> > running?
> 
> Yes, this is an "ugly" palce. I did not fully defer the initialization
> of the xstate array earlier also because I observed that both HVF and
> TCG have similar xsave initialization interfaces within their accelerator's
> cpu_instance_init() function.
> 
> I think it might be better to do the same thing for HVF & TCG as well
> (i.e., defer xstate initialization). Otherwise, if we only modify QEMU
> KVM logic, it looks a bit fragmented... What do you think?

Ah, kvm_arch_get_supported_cpuid() currently caches the obtained CPUID.
Delaying xstate initialization would require refreshing the previously
cached old CPUID... This makes the cost of delaying xstate
initialization higher, and I think this way becames not appropriate.

Either keep the current different ways, or back to use host_cpuid for
everything :( . Which do you think is better?

Regards,
Zhao


