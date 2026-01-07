Return-Path: <kvm+bounces-67201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C59A6CFC51C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 08:23:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9949D3027CEA
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 07:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF0D27700D;
	Wed,  7 Jan 2026 07:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7qpeuCS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4792690D5
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 07:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767770512; cv=none; b=E4SAqgdOLZaRAQOtOMZI2UThQwwKyYPyXPN0/j+iUx38FwL1Iwwp3h1vB6FdOZLox+ovDiy94FuYvXkifd6saqTIOlsCHTSGS/1937UUMAAzp8nYrhnybWEMrl1YohtPJZaVHZw/xdTrxiHCWOVbrckPygrPLkn4DES1JTyYSnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767770512; c=relaxed/simple;
	bh=eECLbTr1DaGxSjoWz66Jd1rt+CG1mD7xd48W2lFlFOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jipr8aRiWCboh7TonQHTRlv1Fn/l2BGGks4mRBZayhRBSjOp1iKj9ZFDCYFCIDmDiUtjsRSqj6pGjHAme6/MEQ0d2kdC8NKM+AiRJB8PpeP2dQvAscadDsLYAyP95DE7TVI9eEO0QtCuVCbSmNS0a2hTR4XO0pIa3xbIvw8mqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7qpeuCS; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767770511; x=1799306511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eECLbTr1DaGxSjoWz66Jd1rt+CG1mD7xd48W2lFlFOE=;
  b=T7qpeuCS6Za2BIYO+QYfYAqcgcMPmqdJNfxePkCTS8rJobs7pgatDFL7
   4JOKGr9KT+/AjP5k+ImcLvIBA/6Zle5TuWp6tv9juDOiOofpZTU3Z88Q3
   Bv/52EnwyCI8B7cdTTu8U2MXXv/gGlikyySsufrNuuEfNcDgPKlLCKIfO
   qsL0XzQF2lYeh0yDQvr1ZbtuPef1FPSnNL4vfE8tWPPsDXIPbqyrEFRLG
   mOTo+juU3nrCB5WLI9MGTYl4NewxPoyd3Eyc1KBIRCeNFGbawVxYqu0aS
   zQ6ewsonp4O4ztYu/qh6gYhTMt8xzbvxpYZcTrTu8Ow5OLw8C0lufD8+2
   Q==;
X-CSE-ConnectionGUID: TSbqSoI3Rg6thbUwBPrcLQ==
X-CSE-MsgGUID: hgUkzh4ZQ22mNNsTabf9Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69211124"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="69211124"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 23:21:50 -0800
X-CSE-ConnectionGUID: zP3uEfjcR7y1s8+1Ellx8A==
X-CSE-MsgGUID: zF8aJ6ZATdqwPUgc9caCXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="233993578"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 06 Jan 2026 23:21:48 -0800
Date: Wed, 7 Jan 2026 15:47:13 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, seanjc@google.com, santosh.shukla@amd.com,
	nikunj.dadhania@amd.com, ravi.bangoria@amd.com, babu.moger@amd.com
Subject: Re: [PATCH 2/5] i386: Add CPU property x-force-cpuid-0x80000026
Message-ID: <aV4PgVwYVXHgmCi3@intel.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-3-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121083452.429261-3-shivansh.dhiman@amd.com>

On Fri, Nov 21, 2025 at 08:34:49AM +0000, Shivansh Dhiman wrote:
> Date: Fri, 21 Nov 2025 08:34:49 +0000
> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Subject: [PATCH 2/5] i386: Add CPU property x-force-cpuid-0x80000026
> X-Mailer: git-send-email 2.43.0
> 
> Introduce new CPU property x-force-cpuid-0x80000026 using which the CPUID
> 0x80000026 is enabled. It defaults to false.
> 
> If a vCPU's model is host, then CPUID is enabled based on CPU family/model.
> Implement x86_is_amd_zen4_or_above() helper to detect Zen4+ CPUs using
> family/model.
> 
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>  target/i386/cpu.c |  8 ++++++++
>  target/i386/cpu.h | 18 ++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b7827e448aa5..01c4da7cf134 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -9158,6 +9158,12 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>          if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
>              x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
>          }
> +
> +        /* Enable CPUID[0x80000026] for AMD Genoa models and above */
> +        if (cpu->force_cpuid_0x80000026 ||
> +            (!xcc->model && x86_is_amd_zen4_or_above(cpu))) {

I understand you want to address max/host CPU case here, but it's still
may not guarentee the compatibility with old QEMU PC mahinces, e.g.,
boot a old PC machine on v11.0 QEMU, it can still have this leaf.

So it would be better to add a compat option to disable 0x80000026 for
old PC machines by default.

If needed, to avoid unnecessarily enabling extended CPU topology, I think
it's possible to implement a check similar to x86_has_cpuid_0x1f().

> +            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000026);
> +        }
>      }

Thanks,
Zhao


