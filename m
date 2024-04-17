Return-Path: <kvm+bounces-15000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C88BF8A8BAC
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:54:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 671CB1F255CC
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F79D1DA58;
	Wed, 17 Apr 2024 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQ+lCLWe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562CA1BF53;
	Wed, 17 Apr 2024 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713380075; cv=none; b=oVw+zWT8WZsGWF4D4N0WtmdrJfv9UWZgN1s6oVgEQoj0/FrTQIyfxbM7JiuaKOVKaQZ4PdGW/jMzt8MUsaeh7WR2URzrEmnp8iEV8n72FGBJI67ksM6RW0KI/ndNeb/TCIZ0vUCZp6AVWpD8knf/5+2bghhk3KMKN6PyRXivBFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713380075; c=relaxed/simple;
	bh=hyCQyZHf2ncj/nXm1VIUe6nfA7at8m+jSmVswf1Wnnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Te3w6j4KwKSFIyQgchhhFHKi7vKVtKS0/7IAZpp0kyn9SevL+HHHFAyhXQ7N2CsS42TI/azF+f0/f7WRKqtLrIQIl6VPP3sx3fmykbHPXGZAksEIYwwoeb8g725CSTE7heQ7C9eMD3JF3qAE67FjnyHZsqOrPKFE0kpLw0mUKS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQ+lCLWe; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713380074; x=1744916074;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hyCQyZHf2ncj/nXm1VIUe6nfA7at8m+jSmVswf1Wnnc=;
  b=IQ+lCLWervtdqjtpe7jjl3H1R/H5KCO2y8b8UEJQGHeZxCAda5G/dSY/
   JXG/M9GMA29CxzYYHADASFyKQFpedY1i0RM+Q6cUc1OoBIz3TvF+NW/JR
   WW21asAuwNaRpRyPKXTPG2xLjaQ0RA8ZwLHu0Dw+Nv5ylV5I+xaOdFd/G
   7kaJGFA9fdooh+Az9K1gmPksu157Jip8m9IN1kfYGiagI2phjVzv6UxnL
   ILGHuecXlsX2cFlCeDfydNkghvm7Gsof8WnvsF7XS9cKCTOQ4v4VY+Y0M
   segmovyGeSXeyYm14dkWQyw1QVsApxCuat7gPzGZWfPwr22NcAt3H4FW5
   w==;
X-CSE-ConnectionGUID: jiVHNqO2Q4CiwlJHlhB/Qw==
X-CSE-MsgGUID: j5sM6DohQGCcEVvzZuqtVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9441220"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="9441220"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:54:34 -0700
X-CSE-ConnectionGUID: PsnZ84biQUCxtewMM+gp4g==
X-CSE-MsgGUID: IIUXUP1qTau8TFgvTNTJ+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="22729937"
Received: from wangc3-mobl.amr.corp.intel.com (HELO desk) ([10.209.4.219])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:54:33 -0700
Date: Wed, 17 Apr 2024 11:54:27 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>, kvm@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [linus:master] [x86/bugs] 6613d82e61:
 general_protection_fault:#[##]
Message-ID: <20240417185427.4msriy5rrt5gej2x@desk>
References: <202403281553.79f5a16f-lkp@intel.com>
 <20240328211742.bh2y3zsscranycds@desk>
 <8c77ccfd-d561-45a1-8ed5-6b75212c7a58@leemhuis.info>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c77ccfd-d561-45a1-8ed5-6b75212c7a58@leemhuis.info>

On Sun, Apr 14, 2024 at 08:41:52AM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
> Hi, Thorsten here, the Linux kernel's regression tracker.
> 
> On 28.03.24 22:17, Pawan Gupta wrote:
> > On Thu, Mar 28, 2024 at 03:36:28PM +0800, kernel test robot wrote:
> >> compiler: clang-17
> >> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> >>
> >> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> >> the same patch/commit), kindly add following tags
> >> | Reported-by: kernel test robot <oliver.sang@intel.com>
> >> | Closes: https://lore.kernel.org/oe-lkp/202403281553.79f5a16f-lkp@intel.com
> 
> TWIMC, a user report general protection faults with dosemu that were
> bisected to a 6.6.y backport of the commit that causes the problem
> discussed in this thread (6613d82e617dd7 ("x86/bugs: Use ALTERNATIVE()
> instead of mds_user_clear static key")).
> 
> User compiles using gcc, so it might be a different problem. Happens
> with 6.8.y as well.
> 
> The problem occurs with x86-32 kernels, but strangely only on some of
> the x86-32 systems the reporter has (e.g. on some everything works
> fine). Makes me wonder if the commit exposed an older problem that only
> happens on some machines.
> 
> For details see https://bugzilla.kernel.org/show_bug.cgi?id=218707
> Could not CC the reporter here due to the bugzilla privacy policy; if
> you want to get in contact, please use bugzilla.

Sorry for the late response, I was off work. I will look into this and
get back. I might need help reproducing this issue, but let me first see
if I can reproduce with the info in the bugzilla.

