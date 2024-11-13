Return-Path: <kvm+bounces-31783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF909C78E7
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 17:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F2B81F21F49
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F00166F29;
	Wed, 13 Nov 2024 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N7hHpXsG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84D14AD17
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731515431; cv=none; b=YRJ91R4pl3tpZm5iM9rDC0biN2/OY/BtSlIzyjQlNyIpUnreVzf/s1KYf+fbsnxkS26FauqVUcye2e2kJB9BF3rRu+CPsKZaX9ov0AjzReEgh/feyXbu9ssdNRj+z6XqELNSiZzDlDcstso4+UumHZeZOtAoK7U0AgATHioubCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731515431; c=relaxed/simple;
	bh=r5qLpRURZWKqh+qzltYbHLtKz5Eb8VMEBe7FX268juo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WAsXbM6J0+AX5qExyf6pvbhQvqXuGIyInGmAUVxCc77e2D2aTJUYWk+j1XpQgLcyXTzUHjgUJC9oOPjll62FdnHDXkXZKU1BxTInFocVrqk5e0xrfJCiVfNmNb5M5roVEir431NCdYWn7i/DDX2EDwb9KpVACNF1C6ShtTZ4Tyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N7hHpXsG; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731515431; x=1763051431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=r5qLpRURZWKqh+qzltYbHLtKz5Eb8VMEBe7FX268juo=;
  b=N7hHpXsGHidmv2w7kP5V7I5ST2U7gLunbVVqYK9wLFIFYVDdRGhqNT7h
   7AdBXcdr1vDHHdGnLeaiQsyuO6XBY1XzrVsNnqiymP2Gy080kfHWcV7vC
   kTuQfpIa0SRUOUxCmBDbZmYNp6uJ2fOaQJmvYQLaIpn+wU6hHTHrhXJ3L
   00/k0xbSN60pcA4UYafR2npa1qTiEan+D2P28D6QzPp0iXOplJihaNOjI
   gGiuQpNnavgVOVyFa7jgFp/wBKpXAP6aqxF+59h08y/Dk0G2n11cgVts5
   KEz2PI0JMO4wnYoF5ZZ5L1GIOvVRv60Ant5NOp5Dx9splMnYb6PQiECK3
   w==;
X-CSE-ConnectionGUID: OTu9fspoTdqCBbtRjvw0Sg==
X-CSE-MsgGUID: VI7JXJBJSSCcrUC2t/UICA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41977186"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41977186"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 08:30:30 -0800
X-CSE-ConnectionGUID: etMJktvSTm6SYva+9vNDyA==
X-CSE-MsgGUID: V4tr+zkcQwWJ6CY3HotHQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="91961625"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 13 Nov 2024 08:30:25 -0800
Date: Thu, 14 Nov 2024 00:48:24 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: dongli.zhang@oracle.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, joe.jin@oracle.com, davydov-max@yandex-team.ru
Subject: Re: [PATCH 3/7] target/i386/kvm: init PMU information only once
Message-ID: <ZzTYWMM9bUAkn+c8@intel.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-4-dongli.zhang@oracle.com>
 <ZzDRZcy7EdK40PO1@intel.com>
 <418a42f0-13d6-4f1e-8733-2d05ddd1959d@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <418a42f0-13d6-4f1e-8733-2d05ddd1959d@oracle.com>

On Tue, Nov 12, 2024 at 05:50:26PM -0800, dongli.zhang@oracle.com wrote:
> Date: Tue, 12 Nov 2024 17:50:26 -0800
> From: dongli.zhang@oracle.com
> Subject: Re: [PATCH 3/7] target/i386/kvm: init PMU information only once
> 
> Hi Zhao,
> 
> On 11/10/24 7:29 AM, Zhao Liu wrote:
> > Hi Dongli,
> > 
> >>  int kvm_arch_init_vcpu(CPUState *cs)
> >>  {
> >>      struct {
> >> @@ -2237,6 +2247,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
> >>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
> >>      cpuid_data.cpuid.nent = cpuid_i;
> >>  
> >> +    /*
> >> +     * Initialize PMU information only once for the first vCPU.
> >> +     */
> >> +    if (cs == first_cpu) {
> >> +        kvm_init_pmu_info(env);
> >> +    }
> >> +
> > 
> > Thank you for the optimization. However, I think it¡¯s not necessary
> > because:
> > 
> > * This is not a hot path and not a performance bottleneck.
> > * Many CPUID leaves are consistent across CPUs, and 0xA is just one of them.
> > * And encoding them all in kvm_x86_build_cpuid() is a common pattern.
> >   Separating out 0xa disrupts code readability and fragments the CPUID encoding.
> > 
> > Therefore, code maintainability and correctness might be more important here,
> > than performance concern.
> 
> I am going to remove this patch in v2.
> 
> Just a reminder, we may have more code in this function by other patches,
> including the initialization of both Intel and AMD PMU infortmation (PerfMonV2).

Yes, I mean we can just remove "first_cpu" check and move this function
into kvm_x86_build_cpuid() again. Your function wrapping is fine for me.

> Dongli Zhang
> 
> > 
> >>      if (((env->cpuid_version >> 8)&0xF) >= 6
> >>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
> >>             (CPUID_MCE | CPUID_MCA)) {
> >> -- 
> >> 2.39.3
> >>
> 

