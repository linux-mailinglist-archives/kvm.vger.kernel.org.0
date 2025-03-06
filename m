Return-Path: <kvm+bounces-40258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9460A55172
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E284B189A4E5
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564532147EB;
	Thu,  6 Mar 2025 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFa5ogsH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFFF2139CD
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278603; cv=none; b=NPKKojgA9o2sp0rMxVYnlEL0eqKRioaerniwjfgkWfatnpD84OM/Aya8NiA11Banei62w42oh3vybqnetQAY8LFu6sYYrYUnp0NcuFfwbJ9qemdJ6PcytGX0+zHhmp29mlppMNWq8mMFHa19Wq/yejBH0P/K//ZahcNw0N0l8Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278603; c=relaxed/simple;
	bh=9JT6hQcuHPteGjoaNI+sWKgKEc5E/9AZD+AdonkE+gQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+OJ7nWrIqLR0hbRrU/tnsiTXLDc0qHkpBmp2Mx+CRGK7TB8eYu9toxXML2Pv9ByXGsb1r5mdZW+1FUSQ1adiYb5nTYp91WoTlfm7ufvOB9SMz9qcd2eR7vt5Xu+qOxMKLOwfGQOSOBjxHSWes9808OWqWnirdUIX8/UtEMrGqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFa5ogsH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741278601; x=1772814601;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9JT6hQcuHPteGjoaNI+sWKgKEc5E/9AZD+AdonkE+gQ=;
  b=jFa5ogsHCOYSIDkw3SsVCHNqxbpIcuuWZIrj+cnpEjGmZs8IHMjwEfEB
   mHT68sZQH99yNhGKsqso6e9PuNZPMEpCpGYg80xG8pJhqRr0eJv4OVXRU
   kbDXAWqGby1JnS41w06OcZ9QHqIJPBRyhApFW5r/mxW+YlPPdRk0NhK63
   ou2fR4HhGQlIRtTRdxUJMzqOzEKdWKhZZwNWRT63r3Wa16RJ6lJciQzUT
   aRv8J0w8bbJPlT33uVAMW/KedAqtXDNkPXkdPjTkWcljYHejxpP8bwMlh
   2FzFWj7wvPH1VNI6NA2zfO/ZVqcKG6h2WP9EG2Q02ikze8gsIh+3JWmBa
   g==;
X-CSE-ConnectionGUID: EezagPb2SDyOC035TWrrnA==
X-CSE-MsgGUID: Dy2Yk5lVTR6zvXb+ccGs+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46069632"
X-IronPort-AV: E=Sophos;i="6.14,226,1736841600"; 
   d="scan'208";a="46069632"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 08:30:01 -0800
X-CSE-ConnectionGUID: 6/o4d1CJRlmH59W6JvCY3g==
X-CSE-MsgGUID: 9vz7cgYqQKO18CkQEoPjYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119579483"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 06 Mar 2025 08:29:57 -0800
Date: Fri, 7 Mar 2025 00:50:05 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 02/10] target/i386: disable PERFCORE when "-pmu" is
 configured
Message-ID: <Z8nSPf4bUPICgf3g@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-3-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302220112.17653-3-dongli.zhang@oracle.com>

Hi Dongli,

> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b6d6167910..61a671028a 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7115,6 +7115,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              !(env->hflags & HF_LMA_MASK)) {
>              *edx &= ~CPUID_EXT2_SYSCALL;
>          }
> +
> +        if (kvm_enabled() && IS_AMD_CPU(env) && !cpu->enable_pmu) {

No need to check "kvm_enabled() && IS_AMD_CPU(env)" because:

 * "pmu" is a general CPU property option which should cover all PMU
   related features, and not kvm-specific/vendor-specific.
 * this bit is reserved on Intel. So the following operation doesn't
   affect Intel.

I think Xiaoyao's idea about checking in x86_cpu_expand_features() is
good. And I believe it's worth having another cleanup series to revisit
pmu dependencies. I can help you later to consolidate and move this
check to x86_cpu_expand_features(), so this patch can focus on correctly
defining the current dependency relationship.

With the above nit fixed,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>




