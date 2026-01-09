Return-Path: <kvm+bounces-67541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA27D07DA2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 513CE301AFCD
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC26347BD9;
	Fri,  9 Jan 2026 08:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PATfIEXL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677F50094E
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767947887; cv=none; b=prewPNK4v/AJFSjc7aUrsDftFxhOrsnYSpc4qddGbzecS/lw9TIEA0AwsNP1lXM2sfk1798umURNqO+c2Gr7BTRvj7K6aGie5rCw1iN4I7/ofUDOAW1gvSrB9mjvGRh+vdMgTH3xw4kP1XaYK7YAmXN7Rm9vy3wzANyp3YO0//o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767947887; c=relaxed/simple;
	bh=XB5BqyiJ0HStQI24NfA+b6hvilKeGtYlfr455n7jD5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYA7WjCh+Y5dDYDftYZCLjHsp2J2BHaT+Qgf6cPm3PIXY/meINSstXIInWfBJiaTxvlyLJYLCSxPqcijljrTDVhPmfwvTIShi8QhxwOOqYorbqZ8I1uVIwTuqVYAGSouTEs+/KeK5ZQhvllRArdl4xo6X4sCW0fXCsXEfKMvCxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PATfIEXL; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767947885; x=1799483885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XB5BqyiJ0HStQI24NfA+b6hvilKeGtYlfr455n7jD5A=;
  b=PATfIEXLO+xq1uHX8mNk5zQWKEsaMBdKlAgDjwQkXbgfKeCj6yn30TIx
   3AxK4WRChcyKrA8ubriLLkmAXbhqIUuIEPXmzyT0wCDHjiCgKrh2ultgZ
   yrW1B/y+9n4y9SbAW3uDq6McfrXD8K8+pBfJrGpXDZ2QFIe23CHQFPIeS
   B3qB03wSyDrKReq7AheqF8kVK6mDS6OdZZvr0DMH/G9T4uS1JjkZjBC1/
   mtMPEpFWW7mjHIfRhxHEW8GkA+jAt+kBfkAOt0bJAik0xEWxGUEa036Nq
   ofhiUxBsdSZE0JIm9ofRdR8BX/TznRm6c6vubTv8NOCTFGzdN6pBzTyWP
   g==;
X-CSE-ConnectionGUID: GtKVrddnSguS95hNbY0LcA==
X-CSE-MsgGUID: CO9jafhEQceL9lj7J32jiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69241023"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="69241023"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 00:38:04 -0800
X-CSE-ConnectionGUID: tIEt/mlYS7eP0p8PG3gv8Q==
X-CSE-MsgGUID: ox6bWr8ORUiMe8FHDzG4Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="240923576"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 09 Jan 2026 00:38:02 -0800
Date: Fri, 9 Jan 2026 17:03:28 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, seanjc@google.com, santosh.shukla@amd.com,
	nikunj.dadhania@amd.com, ravi.bangoria@amd.com, babu.moger@amd.com,
	zhao1.liu@intel.com
Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
Message-ID: <aWDEYEfB4va41+Tv@intel.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-2-shivansh.dhiman@amd.com>
 <aV4KVjjZXZSB5YGw@intel.com>
 <eb712000-bc67-468a-b691-097688233659@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb712000-bc67-468a-b691-097688233659@amd.com>

On Thu, Jan 08, 2026 at 04:03:12PM +0530, Shivansh Dhiman wrote:
> Date: Thu, 8 Jan 2026 16:03:12 +0530
> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
> 
> Hi Zhao,
> 
> On 07-01-2026 12:55, Zhao Liu wrote:
> > Hi Shivansh,
> > 
> > Sorry for late reply.
> > 
> > On Fri, Nov 21, 2025 at 08:34:48AM +0000, Shivansh Dhiman wrote:
> >> Date: Fri, 21 Nov 2025 08:34:48 +0000
> >> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
> >> Subject: [PATCH 1/5] i386: Implement CPUID 0x80000026
> >> X-Mailer: git-send-email 2.43.0
> >>
> >> Implement CPUID leaf 0x80000026 (AMD Extended CPU Topology). It presents the
> >> complete topology information to guests via a single CPUID with multiple
> >> subleafs, each describing a specific hierarchy level, viz. core, complex,
> >> die, socket.
> >>
> >> Note that complex/CCX level relates to "die" in QEMU, and die/CCD level is
> >> not supported in QEMU yet. Hence, use CCX at CCD level until diegroups are
> >> implemented.
> > 
> > I'm trying to understand AMD's topology hierarchy by comparing it to the
> > kernel's arch/x86/kernel/cpu/topology_ext.c file:
> > 
> > static const unsigned int topo_domain_map_0b_1f[MAX_TYPE_1F] = {
> > 	[SMT_TYPE]	= TOPO_SMT_DOMAIN,
> > 	[CORE_TYPE]	= TOPO_CORE_DOMAIN,
> > 	[MODULE_TYPE]	= TOPO_MODULE_DOMAIN,
> > 	[TILE_TYPE]	= TOPO_TILE_DOMAIN,
> > 	[DIE_TYPE]	= TOPO_DIE_DOMAIN,
> > 	[DIEGRP_TYPE]	= TOPO_DIEGRP_DOMAIN,
> > };
> > 
> > static const unsigned int topo_domain_map_80000026[MAX_TYPE_80000026] = {
> > 	[SMT_TYPE]		= TOPO_SMT_DOMAIN,
> > 	[CORE_TYPE]		= TOPO_CORE_DOMAIN,
> > 	[AMD_CCD_TYPE]		= TOPO_TILE_DOMAIN,
> > 	[AMD_SOCKET_TYPE]	= TOPO_DIE_DOMAIN,
> > };
> 
> These mappings reuse some original names (SMT_TYPE and CORE_TYPE) along with the
> new ones (AMD_CCD_TYPE and AMD_SOCKET_TYPE). I think to avoid defining more AMD
> specific types the original names are used. So, essentially you can read them
> like this:
> 
> static const unsigned int topo_domain_map_80000026[MAX_TYPE_80000026] = {
> 	[AMD_CORE_TYPE]		= TOPO_SMT_DOMAIN,
> 	[AMD_CCX_TYPE]		= TOPO_CORE_DOMAIN,
> 	[AMD_CCD_TYPE]		= TOPO_TILE_DOMAIN,
> 	[AMD_SOCKET_TYPE]	= TOPO_DIE_DOMAIN,
> };

Thank you! It's clear and I see the difference.
 
> > What particularly puzzles me is that "complex" isn't listed here, yet it
> > should be positioned between "core" and CCD. Does this mean complex
> > actually corresponds to kernel's module domain?
> 
> There is a nuance with CPUID 80000026h related to the shifting of x2APIC ID.
> According to APM, EAX[4:0] tells us the number of bits to shift x2APIC ID right
> to get unique topology ID of the next instance of the current level type.
> 
> So, all logical processors with the same next level ID share current level. This
> results in mapping the Nth level type to (N-1)th domain. This is unlike Intel's
> CPUID 0xb which maps Nth level type to Nth domain.

Yes, it's the core difference. I think it's better to have a helper
clearly define the mapping between QEMU general topo level v.s. AMD topo
types, similar to cpuid1f_topo_type().

> Back to your question, the complex is same as tile since both represent a L3
> cache boundary.

Yeah, this makes sense. CCD->die, and CCX->tile.

> > Back to QEMU, now CCX is mapped as QEMU's die level, and AMD socket is mapped
> > to socket level. Should we revisit QEMU's topology level mapping for AMD, to
> > align with the above topology domain mapping?
> > 
> > If we want to go further: supporting CCD configuration would be quite
> > tricky. I feel that adding another new parameter between the smp.dies
> > and smp.sockets would create significant confusion.
> 
> The current kernel doesn't have sensitivity to a level between L3 boundary and
> socket. Also, most production systems in current AMD CPU landscape have CCD=CCX.
> Only a handful of models feature CCD=2CCX, so this isn't an immediate pressing need.
> 
> In QEMU's terminology, socket represents an actual socket and die represents the
> L3 cache boundary. There is no intermediate level between them. Looking ahead,
> when more granular topology information (like CCD) becomes necessary for VMs,
> introducing a "diegroup" level would be the logical approach. This level would
> fit naturally between die and socket, as its role cannot be fulfilled by
> existing topology levels.

With your nice clarification, I think this problem has become a bit easier.

In fact, we can consider that CCD=CCX=die is currently the default
assumption in QEMU. When future implementations require distinguishing between
these CCD/CCX concepts, we can simply introduce an additional "smp.tiles" and
map CCX to it. This may need a documentation or a compatibility option, but I
believe these extra efforts are worthwhile.

And "smp.tiles" means "how many tiles in a die", so I feel it's perfect
to describe CCX.

> Also, I was looking at Intel's SDM Vol. 2A "Instruction Set Reference, A-Z"
> Table 3-8. "Information Returned by CPUID Instruction". The presence of a
> "diegrp" level between die and socket suggests Intel has already recognized the
> need for this intermediate topology level. If this maps to a similar concept as
> AMD's CCD, it would indeed strengthen the case for introducing a new level in QEMU.

SDM has "diedrp" but currently no product is using it. So it's hard for me
to say what this layer will look like in the future, especially with
topology-aware features/MSRs. Therefore, I prefer to add the "tile" if
needed, as it aligns better with the existing hierarchy definition. Anyway,
this is the future topic (though it is related with the last statement in your
commit message). At least for now, how to map the AMD hierarchy is fairly
clear.

Thanks,
Zhao


