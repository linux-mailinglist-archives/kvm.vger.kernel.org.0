Return-Path: <kvm+bounces-63544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AADC698F5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 14:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id C09E42ACDB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 13:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DAEF342C9D;
	Tue, 18 Nov 2025 13:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mAGIomI2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26368329E46;
	Tue, 18 Nov 2025 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763471694; cv=none; b=BVyvMDLsdbExqfx6uL0+aH/YDr6zeUYJhTotkIgNayZGUqsxE92L1gMGgkuT10/+d5MB7Ndnq7YDohh+yT54FMK3WYrqMOTJuB2hlMSAih+B4xwGOKOk1VMHm2FjHw6Q18ilHczTgvyhP+/WgnvSHvvflHp0sgZKfwq8fElV2jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763471694; c=relaxed/simple;
	bh=6eM5MEhpy8qjHBQhtFNZN0yn242L+U7uvd1kx4IHV/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYUp9yzvI1henfpViH0mQctxBPFjCUwoedFjK7r9e6uB7i4gD6mSRd7FZXY9vmbjhNmjT7Vy0FxhfvCZAHpE99PL5diCRaJDsbMNqxyCd18H8uIDLLxpX1yrIYe5/Jp/hB0LgEON4jmRMGws5lAiQZQzwGjAcj0ybwjYTNOBJyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mAGIomI2; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763471692; x=1795007692;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6eM5MEhpy8qjHBQhtFNZN0yn242L+U7uvd1kx4IHV/E=;
  b=mAGIomI2GRIWPp9ms0iyg8NbaUUnxz3aMLg433BKBwVsPVBBIijM5K9v
   CTEIumnBSTPbwvGiwp2qVLoQqvmtz9NoOtnfZGaFID8s5ehm4yKSxWB3A
   sKhK/GbmzvyuYF0gtxGn5bk1Ef3NUIEH2nY8dZaXF37IJrVALHFtZMWlf
   57eVq3mLqZH12jg0lLgMtRdQp2Z/QoZ7hwP2QfgLx38mZN0SdEYqQtpJY
   M0eN/5XZIpQy4oVlGw4EngWsZbQFWWOANp9/J/hASX12h+sGZOzB619N8
   ByY+6QkKzt+WY5QjMdOI5U7f1C2jlgSLUaz4BD71P6w8y+NMc580RYjl3
   A==;
X-CSE-ConnectionGUID: RfNB7KOSQ1axWoMPtoSNMw==
X-CSE-MsgGUID: JtSW52ERRfSR96apoBEtRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69361867"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69361867"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 05:14:51 -0800
X-CSE-ConnectionGUID: q0noG09pSv+jtV0xmXaiGA==
X-CSE-MsgGUID: NncBD5WsSnCq7CwXI6o+VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="194870125"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa003.jf.intel.com with ESMTP; 18 Nov 2025 05:14:48 -0800
Date: Tue, 18 Nov 2025 21:00:02 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 07/26] x86/virt/tdx: Read TDX global metadata for TDX
 Module Extensions
Message-ID: <aRxt0prMKusEEt2+@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-8-yilun.xu@linux.intel.com>
 <89a4e42d-b0fd-49b0-8d51-df7bac0d5e5b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89a4e42d-b0fd-49b0-8d51-df7bac0d5e5b@intel.com>

On Mon, Nov 17, 2025 at 08:52:36AM -0800, Dave Hansen wrote:
> On 11/16/25 18:22, Xu Yilun wrote:
> > +static __init int get_tdx_sys_info_ext(struct tdx_sys_info_ext *sysinfo_ext)
> > +{
> > +	int ret = 0;
> > +	u64 val;
> > +
> > +	if (!ret && !(ret = read_sys_metadata_field(0x3100000100000000, &val)))
> > +		sysinfo_ext->memory_pool_required_pages = val;
> > +	if (!ret && !(ret = read_sys_metadata_field(0x3100000100000001, &val)))
> > +		sysinfo_ext->ext_required = val;
> > +
> > +	return ret;
> > +}
> 
> These were OK-ish when they were being generated by a script.
> 
> Now that they're being generated by and edited by humans, they
> need to actually be readable.

I agree. Further more, let me figure out if we could require minimum
boilerplate code when a new field is added.

> 
> Can we please get this down to something that looks more like:
> 
> 	MACRO(&sysinfo_ext->memory_pool_required_pages, 0x3100000100000000);
> 	MACRO(&sysinfo_ext->ext_required,		0x3100000100000001);
> 
> You can generate code in that macro, or generate a struct like
> this:
> 
> static __init int get_tdx_sys_info_ext(struct tdx_sys_info_ext *sysinfo_ext)
> {
> 	int ret = 0;
> 	struct tdx_metadata_init[] = {
> 		MACRO(&sysinfo_ext->memory_pool_required_pages, 0x3100000100000000),
> 		MACRO(&sysinfo_ext->ext_required,		0x3100000100000001),
> 		{},
> 	};
> 
> 	return tdx_...(sysinfo_ext, tdx_metadata_init);
> }
> 
> and have the helper parse the structure.
> 
> But, either way, the method that's being proposed here needs to go.

I'll try and may need a seperate refactoring patch for the existing
code.



