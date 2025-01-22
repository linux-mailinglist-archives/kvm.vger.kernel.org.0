Return-Path: <kvm+bounces-36222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DFEA18CCB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AEBE3A50F6
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 07:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC441BD9DD;
	Wed, 22 Jan 2025 07:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lhYm4saV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09FF1DFFD;
	Wed, 22 Jan 2025 07:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737531171; cv=none; b=u+jqxf9t/KTHz8Ua+Z81gYxv+PHLHaQ7Shp2Dupc3KYYR1xRNv69Eq7plHfH/r/k5vXzN5uUXATwC9ISNZEsiMRBurmHOfPEXaBOUcPIC7dgH3amhUxhM2PzpUGlcNeYVMfQh5SOlZaP10GVmm38v4HW9dZXodyCc7AAnI755vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737531171; c=relaxed/simple;
	bh=i9lcmQNs7p1C2VsffX3arkDkz72DI3qAvujhMIbulP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8lsDhfBFSZ/n6Zl7iKvMuymyGkZZWMW7Ey9A86wKPuiAqv1Dqfs/KiFYRAP0JlUeAgzu0BAyv2N1ewUAY0+xFRla6RSVkGAW7ODKP1G4Xpgs6V/8eQf70v+tojU74nUoXF0CUMxHWt7yvlhqzo8y6uI2smTka8TYG0+y4bdUBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lhYm4saV; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737531170; x=1769067170;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i9lcmQNs7p1C2VsffX3arkDkz72DI3qAvujhMIbulP4=;
  b=lhYm4saVcgIfhypx9fLXHk+N26ynyhg0JNLARAYgCUDFOhfEJevqG/Zv
   yvraalpUpEXpFDKjkT2IqSJHbW2uR13R8BPw8YGCIFGlZNU0Oc3nEZahC
   4c5z+zQiV4eXRvBXf+Vhl/C4J4yRRNd8xiIiTZg6iVOkNWLVgdIxsUeoE
   7wugtRrTEPScwAQu3dHjnPA6L7H9nvCgXA9X15uemp5BHJ62bZa5kWkU/
   t9MaFhD4XKsJQ2i5d51382MIOAb7Klcfi1kx9ZC45Ts0hThL+3lsntopx
   Klz8ify6uULUzHE2msWLNTw3sgVqQEu0A3qr5M/K8W5OZsheYF02yrcsW
   A==;
X-CSE-ConnectionGUID: JFk90CVmRj2TFWcqkwrttQ==
X-CSE-MsgGUID: exd+NvL8S2+6sEwHG/TlGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="37859000"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="37859000"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 23:32:49 -0800
X-CSE-ConnectionGUID: TGU5O9xfRnahjM4pXhQCCg==
X-CSE-MsgGUID: 6FDIFdX6RYq7sYsqURw+XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107938912"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 21 Jan 2025 23:32:45 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 36131170; Wed, 22 Jan 2025 09:32:43 +0200 (EET)
Date: Wed, 22 Jan 2025 09:32:43 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, 
	jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, pgonda@google.com, 
	sidtelang@google.com, mizhang@google.com, rientjes@google.com, manalinandan@google.com, 
	szy0127@sjtu.edu.cn
Subject: Re: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
Message-ID: <aomvugehkmfj6oi7bwmtiqfbdyet7zyd2llri3c5rgcmgqjkfz@tslxstgihjb5>
References: <20250122001329.647970-1-kevinloughlin@google.com>
 <20250122013438.731416-1-kevinloughlin@google.com>
 <20250122013438.731416-2-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122013438.731416-2-kevinloughlin@google.com>

On Wed, Jan 22, 2025 at 01:34:37AM +0000, Kevin Loughlin wrote:
> In line with WBINVD usage, add WBONINVD helper functions. For the
> wbnoinvd() helper, fall back to WBINVD if X86_FEATURE_WBNOINVD is not
> present.
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
> ---
>  arch/x86/include/asm/smp.h           |  7 +++++++
>  arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
>  arch/x86/lib/cache-smp.c             | 12 ++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index ca073f40698f..ecf93a243b83 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -112,6 +112,7 @@ void native_play_dead(void);
>  void play_dead_common(void);
>  void wbinvd_on_cpu(int cpu);
>  int wbinvd_on_all_cpus(void);
> +int wbnoinvd_on_all_cpus(void);
>  
>  void smp_kick_mwait_play_dead(void);
>  
> @@ -160,6 +161,12 @@ static inline int wbinvd_on_all_cpus(void)
>  	return 0;
>  }
>  
> +static inline int wbnoinvd_on_all_cpus(void)
> +{
> +	wbnoinvd();
> +	return 0;
> +}
> +
>  static inline struct cpumask *cpu_llc_shared_mask(int cpu)
>  {
>  	return (struct cpumask *)cpumask_of(0);
> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> index 03e7c2d49559..94640c3491d7 100644
> --- a/arch/x86/include/asm/special_insns.h
> +++ b/arch/x86/include/asm/special_insns.h
> @@ -117,7 +117,20 @@ static inline void wrpkru(u32 pkru)
>  
>  static __always_inline void wbinvd(void)
>  {
> -	asm volatile("wbinvd": : :"memory");
> +	asm volatile("wbinvd" : : : "memory");
> +}
> +
> +/*
> + * Cheaper version of wbinvd(). Call when caches
> + * need to be written back but not invalidated.
> + */
> +static __always_inline void wbnoinvd(void)
> +{
> +	/*
> +	 * Use the compatible but more destructive "invalidate"
> +	 * variant when no-invalidate is unavailable.
> +	 */
> +	alternative("wbinvd", "wbnoinvd", X86_FEATURE_WBNOINVD);

The minimal version of binutils kernel supports is 2.25 which doesn't
know about WBNOINVD.

I think you need to do something like.

	alternative("wbinvd", ".byte 0xf3; wbinvd", X86_FEATURE_WBNOINVD);

Or propose to bump minimal binutils version.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

