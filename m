Return-Path: <kvm+bounces-67699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F38D10E19
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E4DB8301A0C5
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 07:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC873328FB;
	Mon, 12 Jan 2026 07:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBqNoCZb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E7A314B72
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 07:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768203124; cv=none; b=Uc2SAA0Ys4DSm85sgOHsvBHNjlbK6ti2a8PN65U+c2PncoypSrLWxmQgdWJ/EtHMmOdP0qNkRcdu2RlKgqIkt5joTufcB5X4INZBUCTz4eq15CtQzDdcc5wL/555lsd3Ik/YOipwSV5ybTkYJFEdVAhaG1NU5wKGzuZyliyYGpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768203124; c=relaxed/simple;
	bh=wCdVxv++vV4zY3U/Uah3D3XPw6RJeI7tbc9d7yTBM7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNMMx5ehdrbScvXGlXmkqAeEeVy7MgYtlWvBeT0DRH3UhB0UxHNymHonlmqB5Mod7Cg0I/lOWO5EDuXKGJhWThJcYRJcv18kLyZP1wEkgL0/W/MLiAOxeGYOcOE0xF8Ump7oym2CdNFYQiweDLkjdIDcbKF2kVEDg7wC5AH7Hfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBqNoCZb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768203123; x=1799739123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wCdVxv++vV4zY3U/Uah3D3XPw6RJeI7tbc9d7yTBM7o=;
  b=MBqNoCZb0mAEwhQnyi1UQF0nceDHW56E+gnfoLVsB4oxTNx4HAkpAMtD
   TEu+NRQjyC4kCcYxDbV8oMBWiymGI/9rfVXVogntJLgbu7aYSVMYGGL9q
   UY9ijlE45LKnHcF46FQjQ+0Mlo0Rp6oEy0OAKavTDgofkN8WoHi2X/0kL
   MXVwaP4Rqv04QTBs7sCNQ9CWL73yutHZ4q55XrboR8dAB/VQX0Xr29Zzn
   byC7HAtAlKuwNEV9/OHtcP1zJdTCDUXl5SNsMZHhHHgWyCXHNY65dgrRg
   HOTrRNjw72xC72G1N1Ng99KiSGsblqQXTjZ+W9bqkrypKb8/tIxZurUV3
   Q==;
X-CSE-ConnectionGUID: cJi0K2fUReqdrEnnc6zmGA==
X-CSE-MsgGUID: ozIXr1x/SVeOu9jZ3CQqRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="79766995"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="79766995"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 23:32:03 -0800
X-CSE-ConnectionGUID: CiYmraRrTG2+bJ4JHwrfKA==
X-CSE-MsgGUID: 61hwoF19S3Cw0+KZP2FN0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203175604"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 11 Jan 2026 23:32:00 -0800
Date: Mon, 12 Jan 2026 15:57:27 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, seanjc@google.com, santosh.shukla@amd.com,
	nikunj.dadhania@amd.com, ravi.bangoria@amd.com, babu.moger@amd.com
Subject: Re: [PATCH 2/5] i386: Add CPU property x-force-cpuid-0x80000026
Message-ID: <aWSpZxg7kKrdBifu@intel.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-3-shivansh.dhiman@amd.com>
 <aV4PgVwYVXHgmCi3@intel.com>
 <8ef42171-5473-449f-bd72-e9874fa6f7f1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ef42171-5473-449f-bd72-e9874fa6f7f1@amd.com>

> On 07-01-2026 13:17, Zhao Liu wrote:
> > On Fri, Nov 21, 2025 at 08:34:49AM +0000, Shivansh Dhiman wrote:
> >> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> >> index b7827e448aa5..01c4da7cf134 100644
> >> --- a/target/i386/cpu.c
> >> +++ b/target/i386/cpu.c
> >> @@ -9158,6 +9158,12 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
> >>          if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
> >>              x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
> >>          }
> >> +
> >> +        /* Enable CPUID[0x80000026] for AMD Genoa models and above */
> >> +        if (cpu->force_cpuid_0x80000026 ||
> >> +            (!xcc->model && x86_is_amd_zen4_or_above(cpu))) {
> > 
> > I understand you want to address max/host CPU case here, but it's still
> > may not guarentee the compatibility with old QEMU PC mahinces, e.g.,
> > boot a old PC machine on v11.0 QEMU, it can still have this leaf.
> 
> Wouldn't initializing x-force-cpuid-0x80000026 default to false prevent this?
> Oh, but, this CPUID can still be enabled on an older machine-type with latest
> QEMU with the existing checks. And probably this could also affect live migration.

Yes, on a zen4 host, booting an older machine with latest QEMU will have
this CPUID leaf.
 
> > So it would be better to add a compat option to disable 0x80000026 for
> > old PC machines by default.
> 
> Does this look fine?
> 
> GlobalProperty pc_compat_10_2[] = {
>     { TYPE_X86_CPU, "x-force-cpuid-0x80000026", "false" },
> };
> const size_t pc_compat_10_2_len = G_N_ELEMENTS(pc_compat_10_2);

It looks fine if we only check "if (cpu->force_cpuid_0x80000026)".

> > If needed, to avoid unnecessarily enabling extended CPU topology, I think
> > it's possible to implement a check similar to x86_has_cpuid_0x1f().
> 
> Do you mean something like this? I avoided it initially because it is
> functionally same as current one, and a bit lengthy.

Sorry for confusion. Could we get rid of model check
(x86_is_amd_zen4_or_above)? and could we do something like 0x1f leaf,

static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
{
    return cpu->force_cpuid_0x1f ||
           x86_has_extended_topo(cpu->env.avail_cpu_topo);
	   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
}

similarly, apply x86_has_extended_topo() for AMD CPU as well?

x86_has_extended_topo() also checks "module" level, but I think we could
return error in encode_topo_cpuid80000026() for unsupported "moduel"
level?

Thus, when users explicitly set these levels, the 0x80000026 leaf will be
enabled.

Furthermore, I think it's better that different x86 vendors could adopt
similar behavior for these extended topology levels, especially since
they are all all configured through a unified "-smp" interface.

Thanks,
Zhao


