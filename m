Return-Path: <kvm+bounces-67200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7B6CFC454
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 08:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72EBF304814D
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 06:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C326426ED59;
	Wed,  7 Jan 2026 06:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FMb9HtuN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5C018C008
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 06:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767769192; cv=none; b=d9lk41+Xn0NnS9V7De92Gy6AbX5M1n5Y1yVM9h94LLf0bh5VRtJ97wEqTGdBIXA9vBYuPIYyI+ndyS3udnwIqzipRWgMWReg6gZP9CGcMP+xvYDyDgYDVQkWH6CERZWiS65J7HSnkdOgN7JH6ARZvGTijpUpC3PFiXxEzd7zf6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767769192; c=relaxed/simple;
	bh=gMisxaofBYxdozgayUag/9U3gcvpdLXLk+lKQ42GR/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gv2fqQONpkYF+lytTgT0EETOn7SSP60VMhfDxBo6SWMgnxZ32eiOgipLSy5Lho2aIyHh21j0Sj+Dq4+BIsigSgkL5iFZlGbGDPoFi8icGJ/MSSsMl2NtHQvAbEXFfYKZZHOxWJuAToL5jy4EraIL9GuylU/vibIshJfFV4JYAUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FMb9HtuN; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767769190; x=1799305190;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gMisxaofBYxdozgayUag/9U3gcvpdLXLk+lKQ42GR/Q=;
  b=FMb9HtuNdT/VRC5aRneOF+MeBzbP2VC55ocpNby494c5Id+gOauHw3+S
   xky7CWccFsZEFNBmQ+OKQ2lsuXol2A3W7McNKETW0LhhKVQKd6ygFcexD
   nAB/+lv+1ndKRhe/Bh0GeaBD2zJ6quRgWZ0qbno4m456EZ3G3q/+z9wAb
   Dpikr6FztalF64GjRc5uFK+Erzog2tNzyCcV9X8R4c2q/lSghHTzojwqs
   Rh4CM33xInxMFto0/a7JtDFzAPdeIZ70Qtjq+HG1aoeLDNSGyBS1RZwDr
   qOxwX37F0OL6j5isLmC5VPJFb+pin+92CAO9OOOm1qGfbCIoadQAcXK/A
   A==;
X-CSE-ConnectionGUID: XEvOXT3QRnm3EHTFvU6Rbw==
X-CSE-MsgGUID: 90t00bTDSWiMUzeXoDz4Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69046131"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="69046131"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 22:59:49 -0800
X-CSE-ConnectionGUID: 0oNHSyUsR52hBjQBsJmbLg==
X-CSE-MsgGUID: EA1t0KhxQY+CouqlGdmSpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="203301259"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 06 Jan 2026 22:59:44 -0800
Date: Wed, 7 Jan 2026 15:25:10 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, seanjc@google.com, santosh.shukla@amd.com,
	nikunj.dadhania@amd.com, ravi.bangoria@amd.com, babu.moger@amd.com
Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
Message-ID: <aV4KVjjZXZSB5YGw@intel.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-2-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121083452.429261-2-shivansh.dhiman@amd.com>

Hi Shivansh,

Sorry for late reply.

On Fri, Nov 21, 2025 at 08:34:48AM +0000, Shivansh Dhiman wrote:
> Date: Fri, 21 Nov 2025 08:34:48 +0000
> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Subject: [PATCH 1/5] i386: Implement CPUID 0x80000026
> X-Mailer: git-send-email 2.43.0
> 
> Implement CPUID leaf 0x80000026 (AMD Extended CPU Topology). It presents the
> complete topology information to guests via a single CPUID with multiple
> subleafs, each describing a specific hierarchy level, viz. core, complex,
> die, socket.
> 
> Note that complex/CCX level relates to "die" in QEMU, and die/CCD level is
> not supported in QEMU yet. Hence, use CCX at CCD level until diegroups are
> implemented.

I'm trying to understand AMD's topology hierarchy by comparing it to the
kernel's arch/x86/kernel/cpu/topology_ext.c file:

static const unsigned int topo_domain_map_0b_1f[MAX_TYPE_1F] = {
	[SMT_TYPE]	= TOPO_SMT_DOMAIN,
	[CORE_TYPE]	= TOPO_CORE_DOMAIN,
	[MODULE_TYPE]	= TOPO_MODULE_DOMAIN,
	[TILE_TYPE]	= TOPO_TILE_DOMAIN,
	[DIE_TYPE]	= TOPO_DIE_DOMAIN,
	[DIEGRP_TYPE]	= TOPO_DIEGRP_DOMAIN,
};

static const unsigned int topo_domain_map_80000026[MAX_TYPE_80000026] = {
	[SMT_TYPE]		= TOPO_SMT_DOMAIN,
	[CORE_TYPE]		= TOPO_CORE_DOMAIN,
	[AMD_CCD_TYPE]		= TOPO_TILE_DOMAIN,
	[AMD_SOCKET_TYPE]	= TOPO_DIE_DOMAIN,
};

What particularly puzzles me is that "complex" isn't listed here, yet it
should be positioned between "core" and CCD. Does this mean complex
actually corresponds to kernel's module domain?

Back to QEMU, now CCX is mapped as QEMU's die level, and AMD socket is mapped
to socket level. Should we revisit QEMU's topology level mapping for AMD, to
align with the above topology domain mapping?

If we want to go further: supporting CCD configuration would be quite
tricky. I feel that adding another new parameter between the smp.dies
and smp.sockets would create significant confusion.

> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>  target/i386/cpu.c     | 76 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/kvm.c | 17 ++++++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 641777578637..b7827e448aa5 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -495,6 +495,78 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
>      assert(!(*eax & ~0x1f));
>  }
>  
> +/*
> + * CPUID_Fn80000026: Extended CPU Topology
> + *
> + * EAX Bits Description
> + * 31:5 Reserved
> + *  4:0 Number of bits to shift Extended APIC ID right to get a unique
> + *      topology ID of the current hierarchy level.
> + *
> + * EBX Bits Description
> + * 31:16 Reserved
> + * 15:0  Number of logical processors at the current hierarchy level.
> + *
> + * ECX Bits Description
> + * 31:16 Reserved
> + * 15:8  Level Type. Values:
> + *       Value   Description
> + *       0h      Reserved
> + *       1h      Core
> + *       2h      Complex
> + *       3h      Die
> + *       4h      Socket
> + *       FFh-05h Reserved
> + * 7:0   Input ECX
> + *
> + * EDX Bits Description
> + * 31:0 Extended APIC ID of the logical processor
> + */

I feel this long comment is not necessary, since people could check APM for
details. Or this description could be included in commit message.

> +static void encode_topo_cpuid80000026(CPUX86State *env, uint32_t count,
> +                                X86CPUTopoInfo *topo_info,
> +                                uint32_t *eax, uint32_t *ebx,
> +                                uint32_t *ecx, uint32_t *edx)

Regards,
Zhao


