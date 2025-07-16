Return-Path: <kvm+bounces-52562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B16BB06CB4
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD5DE7A6EAD
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 04:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBEE245038;
	Wed, 16 Jul 2025 04:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZPjhuDkK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED472E3715
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752640453; cv=none; b=JPoBxEb4mwx434Bg6pkgqglqRZi/TSwhy2Q1vCYFyRlGDNrGB6Z/2R5sOSkPau2vOrIlleVjE6RdvGL+RnmJ6t5LhcPosKKKhqnTnfgOi9WKEoWrMfy8GYa4rlQeo6/UMfhh+RmJ3GayOrH97bXI8VBiyrKjFD+BZB0rDtO8AiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752640453; c=relaxed/simple;
	bh=hup3CwDErWU2vwExe2NkM/8/9ILhHcpWQJJ/GZbPCH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpZuE8H1zgz5mZG/K9POdknPgPuU/VvXRYkT8QDds4IVXZV3W+eKIgf4gfiZjyerPb1ZIKXeAyyTXrmzByZzSRszYOwUzqjx1EGJXgylTohwbM2c9+4gRcoACJJQ3UZpZYKZ2/P4xXQqbWhlJwkMVm4iWQ0AJN+g8hivz8PuMHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZPjhuDkK; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752640452; x=1784176452;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hup3CwDErWU2vwExe2NkM/8/9ILhHcpWQJJ/GZbPCH0=;
  b=ZPjhuDkKsYG5vnVmJoAj34cUKqbVYRz049Fnslos9DBpyCqtvW5xVleR
   ZSMgwzPBzrVyTIFqPMtzIhVY5xfGi8WAbTbgZJ9061lub9RZ/mb5nWEXZ
   xDvhYCpe/2qW4SLWY6frN6BBXSp/qjBnp0o/S1VKqDYlGtHO2uKGuWT3S
   UDRsUgNpAlctQhpKBSjt80cCDmnuDFZbGASwQpIxD3lR0xp7ThOOK1ASL
   zG9jhw5U3897CwWY6qesKHbIB3r4fcmLPurciavthhwA2NtD5Zwh3rBlb
   E63adFBCXu4Kjm31V0e9gkSmxbIaaaTfTdSx9bwXmpXbT4ZnXna8Is1NH
   w==;
X-CSE-ConnectionGUID: pFzOPNSFSz+Cc49ba/l/3g==
X-CSE-MsgGUID: AwejRlpvQRinBKRyHVjP7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54997136"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="54997136"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 21:34:11 -0700
X-CSE-ConnectionGUID: DZbXId9MRSWw5oqweECDvw==
X-CSE-MsgGUID: u56ysXoBR8SStOEa8o1s+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="163039185"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 15 Jul 2025 21:34:09 -0700
Date: Wed, 16 Jul 2025 12:55:39 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, bp@alien8.de, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] target/i386: Add TSA feature flag verw-clear
Message-ID: <aHcwy7BRIh219WHh@intel.com>
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
 <e6362672e3a67a9df661a8f46598335a1a2d2754.1752176771.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6362672e3a67a9df661a8f46598335a1a2d2754.1752176771.git.babu.moger@amd.com>

On Thu, Jul 10, 2025 at 02:46:11PM -0500, Babu Moger wrote:
> Date: Thu, 10 Jul 2025 14:46:11 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH v2 2/2] target/i386: Add TSA feature flag verw-clear
> X-Mailer: git-send-email 2.34.1
> 
> Transient Scheduler Attacks (TSA) are new speculative side channel attacks
> related to the execution timing of instructions under specific
> microarchitectural conditions. In some cases, an attacker may be able to
> use this timing information to infer data from other contexts, resulting in
> information leakage
> 
> CPUID Fn8000_0021 EAX[5] (VERW_CLEAR). If this bit is 1, the memory form of
> the VERW instruction may be used to help mitigate TSA.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
> Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v2: Split the patches into two.
>     Not adding the feature bit in CPU model now. Users can add the feature
>     bits by using the option "-cpu EPYC-Genoa,+verw-clear".
> 
> v1: https://lore.kernel.org/qemu-devel/20250709104956.GAaG5JVO-74EF96hHO@fat_crate.local/
> ---
>  target/i386/cpu.c | 2 +-
>  target/i386/cpu.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


