Return-Path: <kvm+bounces-65759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 644E3CB59F5
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 75E58301143F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C3A3081B8;
	Thu, 11 Dec 2025 11:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N1Q/dmBI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B8729C351
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 11:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765451894; cv=none; b=bc0YHcqZwm8Vyq4KCXmHIA8d+l3ZdLoduRpLT/dkfIKkKjxk1g5eYyBBB5sfyBXYtJ40PULeM93uXI13lAMSi9osq25pe+ePHlPXV65FiMcY5V8t/5jzcOt8882OPiywJatpdPxGPysV2QxRnmdrywg2waJLNKwSNo5Vct7X8TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765451894; c=relaxed/simple;
	bh=/PavwmTPXgf2RFgfCgkbjsWUgrq8AQllM7S/czmU9N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kI2fnWkfq0KE0aSLkDuZztmlXpWJLKwErsRFv2GZeg5STu/+zJraSKJlh/icG3I1SJ3wd/koxS2xXiH+8nLlsqaGBrK3g8vysckPvC+fhcDsQGWJCeuLebPqk6UShH3qvO3D1fZgXiL0DOj/iBxJk3vCzHOvNBhlxSgi8MmUN9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N1Q/dmBI; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765451893; x=1796987893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/PavwmTPXgf2RFgfCgkbjsWUgrq8AQllM7S/czmU9N0=;
  b=N1Q/dmBIlx/VApiCXEFj2K3rLJ3CnTHSHPk5dMXcDw5TUrF6uOrRYZju
   9+Wd/D+9XXmvEyAyp/DkRjhJX4/tX6zzblICCxnFvMlW/Riu5p4JmOK32
   q/4RQZp4RiqWGtZq/KpQHfVUx+Kz8hVz5pe3XE1OcOUtDf+0Qeu4C/N8l
   c6L7phRtzkyJnj6tj7g+/NruKaJZyp1zFOVjPg1OL2JvHI2W10b57xlzv
   VCHtwrAKSU70ytzzQG4pFVK1DCrqB/Tit0wLGZxw6S4Fawik+ZrQhZk6w
   lSdGSboxMY5Ps6ksI7tPoOmf3/E6OYt/OSFwjVOITZlNAcVVCkEkSHq4C
   g==;
X-CSE-ConnectionGUID: bXH4foZmQG+Gr8qxM5/F8w==
X-CSE-MsgGUID: 4c1cIsa9RV+GhUt6hahJkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="78135215"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="78135215"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 03:18:12 -0800
X-CSE-ConnectionGUID: n7oOztxsS0C0JqrUfAh9tQ==
X-CSE-MsgGUID: yNbwLSB4TqaHeCzHM6soxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196384546"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 11 Dec 2025 03:18:10 -0800
Date: Thu, 11 Dec 2025 19:42:56 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>, Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH v2 0/9] i386/cpu: Support APX for KVM
Message-ID: <aTquQJkiwKmuqCG2@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
 <16e0fc49-0cdf-4e54-b692-5f58e18c747b@redhat.com>
 <aTqMBtkOxx6mZhn+@intel.com>
 <df96afb2-f99c-48ae-81be-ccadf0fc3496@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df96afb2-f99c-48ae-81be-ccadf0fc3496@redhat.com>

> No problem, I have done a quick pass with "sed" on the patches and reapplied
> them.  I do ask you to respin the Diamond Rapids series though, on top of
> the for-upstream tag of https://gitlab.com/bonzini/qemu (currently going
> through CI).
> 
> Applied for 11.0!

Thank you!

BTW, could you please have a look at this clean up on outdated SPR
comments:

https://lore.kernel.org/qemu-devel/20251118080837.837505-1-zhao1.liu@intel.com/

I feel it's better to clear SPR comments before DMR touches AMX.

Thanks,
Zhao


