Return-Path: <kvm+bounces-67202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 93175CFC52E
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 08:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD6D5303DD2C
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 07:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03A62737F8;
	Wed,  7 Jan 2026 07:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cWtI5Z9A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916C51FBEA8
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 07:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767770544; cv=none; b=Ng8w7JD9dJDrGPE3j0PnSjxEggEwy7IEM4Mw2mLfL8zZ+yvaHoKZr+A3q+Z8rFuP/wRDajrKNrcNzi7Z3H2qQ2Q9Drvq7v9inKY75StenW+7uSHsHEKDqgv335xxTnGy1n4/VX3V1/C/sQUcbViyqcMbkuecChgk0DfvKK8YJAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767770544; c=relaxed/simple;
	bh=7lXZuzLzfx6HVQQePV4kMY1/hONMlODrwOZeuTwuKGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wr0BfaWKgBGricTLYevfAgSudIGFqB2/Jbt+e9ZPKDt+Y5M51+LQ5dFND2QqSCIFGzYJ/0nZvKbuljU5DJxXbiPLp2yYZGvOs12BNaU5k9ZXawyDCfcbbRDjnGr0xkdYFJSVErX/CmqrRhtolG1MbDN8zI7FFgPE2eItTe8fbY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cWtI5Z9A; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767770543; x=1799306543;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7lXZuzLzfx6HVQQePV4kMY1/hONMlODrwOZeuTwuKGQ=;
  b=cWtI5Z9AW2LgLqyKVRgKDrNsAsrWN0WQYG8fvi9dMB3vATp/oe7VgYgG
   8wNdVlrmORtV1Vd7bfBVHkrgc+0rCtRgMYV1/yG3AUwWQRdecKwHvp9xK
   CbHSSXMFSlyQHPuUqooStSKHUlNd4/7bm/+3xKseOmkSEVn+BFz+YTdzu
   YoFwPSMttivPtM5dhCkd3v5yOxT4qgGNuIb6QRzHTOa/kfHmunT9lIxvU
   7QvqjGwGVhyXtljOIsuyBgI6Oxe9aSH6M+gZIayYFUJiQ/hSJNa/gfS7m
   N3rLiOEOubcYpR6LCgPa/rAg2P65Kc3JpXbYPulHFNIqxs92fsGAzTkcn
   g==;
X-CSE-ConnectionGUID: 8Cf1taHwSK2WXyOvmE7nHQ==
X-CSE-MsgGUID: RCgD67GUTV6/pVMO2jQofA==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69211155"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="69211155"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 23:22:22 -0800
X-CSE-ConnectionGUID: iXiuRILPSECNlthpJH7zSg==
X-CSE-MsgGUID: YPri1uymQ/m08GxZoIpDLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="203304854"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 06 Jan 2026 23:22:20 -0800
Date: Wed, 7 Jan 2026 15:47:45 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, seanjc@google.com, santosh.shukla@amd.com,
	nikunj.dadhania@amd.com, ravi.bangoria@amd.com, babu.moger@amd.com
Subject: Re: [PATCH 3/5] i386: Enable CPUID 80000026 for EPYC-Genoa/Turin vCPU
Message-ID: <aV4PoetP0e319jyL@intel.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-4-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121083452.429261-4-shivansh.dhiman@amd.com>

On Fri, Nov 21, 2025 at 08:34:50AM +0000, Shivansh Dhiman wrote:
> Date: Fri, 21 Nov 2025 08:34:50 +0000
> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Subject: [PATCH 3/5] i386: Enable CPUID 80000026 for EPYC-Genoa/Turin vCPU
> X-Mailer: git-send-email 2.43.0
> 
> Enable CPUID leaf 0x80000026 (Extended CPU Topology) for AMD Zen4+ processors,
> i.e, Genoa and above. Add version 3 to EPYC-Genoa and version 2 to EPYC-Turin
> CPU models with x-force-cpuid-0x80000026 property enabled.
> 
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>  target/i386/cpu.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


