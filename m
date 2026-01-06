Return-Path: <kvm+bounces-67094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0CACF6A6A
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 05:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 19806301E980
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 04:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57CD27CB04;
	Tue,  6 Jan 2026 04:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uk9ihiEO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4AE1F19A;
	Tue,  6 Jan 2026 04:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767673124; cv=none; b=nF1DY+RYC4MWONcTIcczMXcRq3wA6K2KgQI55bsogZ8IS4VQWRyfZkWa244eph16d/iVDIrpyJBjnMytI/nRcq4fsIzt5fs1oSh65OYsjzKRZoG88fqhkFBa8rN0iWEPRBukQp71nnA0JCD/f1C/3sZRCAS0wNYAPSGqGt3cy6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767673124; c=relaxed/simple;
	bh=FJht4+x+AmNn8jLnsmkZ6PpTRb3wUqY3p+sCsXEcRpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfsQ7D43qjpKEgrZ+AZG+ueZZkuau9JR5GI1EfZ/+oegkfBUgmVwvcPng0O2BXiILStaAqK3vfFsGzjc6MMXLGbpO2LHcwlvB8E7Q3h5F/6ugquCJhiYI8NhbbymXD52RQ1Rj0rixl1wSzHJuUVOlnNLFXpwRG9UbA43CkRgk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uk9ihiEO; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767673123; x=1799209123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FJht4+x+AmNn8jLnsmkZ6PpTRb3wUqY3p+sCsXEcRpE=;
  b=Uk9ihiEOFTCNnjp2cZFU5XAqU9+9dMM9IlgypyfYl/5L4Oi9D9YpdiZS
   LtamanAf4u/iSOPmsM13OFJY6WmaXZtpPEr5SYnl+05vBe14XvaHmXuKL
   g8s/855fK912gHVFgRKhvzFiJGFgsq/yv9654Nye17EHytEN3t2o77B/4
   lmE5VlWZCAOberKWfg4FkGuY7DEfKvWO4d6Rsn5vfuwyKJ3GFQ8L9Vzu5
   +eZAZoaz6pLevUUzRWrGF+U1s9XMNRIXUvicXs8e1XpNULCBV5R9MKqyz
   rkRd+al0CP8wk/L5HriJ7hSId2GNBg7/FS8wS/TE08NqB1YiVkJW1OWBQ
   w==;
X-CSE-ConnectionGUID: feGXlLPDTtelNvHftHHoVw==
X-CSE-MsgGUID: IquSEQ2mSjqhb/LA0f7NnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72898788"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72898788"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 20:18:42 -0800
X-CSE-ConnectionGUID: XJbA1t1XSZC1O1Is0oSFKA==
X-CSE-MsgGUID: DaICeh5XROmKtQGBrTqgBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202176993"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 05 Jan 2026 20:18:38 -0800
Date: Tue, 6 Jan 2026 12:01:31 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Message-ID: <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>

On Mon, Jan 05, 2026 at 10:06:31PM +0000, Edgecombe, Rick P wrote:
> On Wed, 2025-12-24 at 17:10 +0800, Xu Yilun wrote:
> > Is it better we seal the awkward pattern inside the if (dpamt supported)  block:
> > 
> > 	if (tdx_support_dynamic_pamt(&tdx_sysinfo))
> > 		if (!ret && !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
> > 			sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;
> 
> The extra indentation might be objectionable.

Yes the extra indentation is unconventional, but everything here is, and
we know we will eventually change them all. So I more prefer simple
changes based on:

  if (!ret && !(ret = read_sys_metadata_field(0xABCDEF, &val)))

rather than neat but more LOC (when both are easy to read).

Anyway, this is trivial concern. I have more optional fields to add and
will follow the final decision.

