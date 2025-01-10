Return-Path: <kvm+bounces-34991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B7AAA089F3
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51E637A260F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB222080D9;
	Fri, 10 Jan 2025 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qir8mpX/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0168205E01;
	Fri, 10 Jan 2025 08:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736497405; cv=none; b=DskZ4X8zAvV5qfRDOvGaDquWPzYe+nE1W3rjyO7wYvkm1U4AXK8IDl5dRrTKyHXexyDPxq2y/005nozS7tamZvwuCxjHkRyjax+UtNC64T7+fvNYDvk4yFrWs4PT1tZUmpTrh7pwlpkOVK+HVafvz7bra/MEi0dEVAAoCra/srY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736497405; c=relaxed/simple;
	bh=jNvuQibS0xK4U0HYnCR0DoZ6udjEAkihfqb9QI2WsVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R88/F4gmUHu70tf+OyrMS8a3sNMcFUZrvsah6FbZ3ra0mzS7pLPtyHWUYSBOt7ZOtI/WK1TiYfldFtC7tap7qvPbNxNTzDPC6wlj/OvmllU5Fd4agk4tVXFHcTtugf6cNtd3UgbdttmGWuyeSHxA5WSPO5S0XGm3/nHe6dBogd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qir8mpX/; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736497404; x=1768033404;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jNvuQibS0xK4U0HYnCR0DoZ6udjEAkihfqb9QI2WsVY=;
  b=Qir8mpX/uZM4jjSOtfAQXQrvnHALQZYqO8yFp81Fvow4HK7Vzaab1kht
   brln6TMsMi1LrgWc7m/jYP0xq9thi/narKWi35TXAoboNyaae12M+ATvh
   JTaPMgP/K8LVN1FGndI27q0CgxE7iZK/vSV0wR9vZnd3iUhKkw4ItuILh
   tUAq3ktiNXxzPfleTyiUXufBe+B+kJSKPeis6PFc12gZ+Qni6FxKzv6YD
   9op8yOUMUZDQn53jn0ZucaWNtPczaafZwbFHs02KnAoo51YHz/TKM+7J/
   h4FmLATYiFy8ZdsSfvUHNZQ3TEhEUxjm0P3FFFMIAu+Hi04basNU12oBR
   g==;
X-CSE-ConnectionGUID: IZzPoTvLQFOkbVgSkxzidQ==
X-CSE-MsgGUID: map4Cx+wSj6kgnYnwmNnjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="35999035"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="35999035"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 00:23:23 -0800
X-CSE-ConnectionGUID: qupFSsmuT3mZJ8LQ8BN/hQ==
X-CSE-MsgGUID: d/QEXwFjQ0mLSQzjVCC+jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="103852088"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa008.fm.intel.com with ESMTP; 10 Jan 2025 00:23:18 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 743D13C3; Fri, 10 Jan 2025 10:23:17 +0200 (EET)
Date: Fri, 10 Jan 2025 10:23:17 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, 
	dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, rientjes@google.com, 
	szy0127@sjtu.edu.cn
Subject: Re: [PATCH v2 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
Message-ID: <szkkdk35keb6ibdy2d2p2q6qiykeo2aoj2iqpzx3h6k2wzs2ob@iuidkwpeoxua>
References: <20250109225533.1841097-1-kevinloughlin@google.com>
 <20250109225533.1841097-3-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109225533.1841097-3-kevinloughlin@google.com>

On Thu, Jan 09, 2025 at 10:55:33PM +0000, Kevin Loughlin wrote:
> @@ -710,6 +711,14 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  	}
>  }
>  
> +static void sev_wb_on_all_cpus(void)
> +{
> +	if (boot_cpu_has(X86_FEATURE_WBNOINVD))
> +		wbnoinvd_on_all_cpus();
> +	else
> +		wbinvd_on_all_cpus();

I think the X86_FEATURE_WBNOINVD check should be inside wbnoinvd().
wbnoinvd() should fallback to WBINVD if the instruction is not supported
rather than trigger #UD.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

