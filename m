Return-Path: <kvm+bounces-50160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE8BAE22CB
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 21:27:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F37763AD4C3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE892222BF;
	Fri, 20 Jun 2025 19:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="boplLT3A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7943C136988;
	Fri, 20 Jun 2025 19:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750447616; cv=none; b=Sgp+8RSAcE7vP6m1E9Tn2QdJrnOMV0bd5YnoOwNd1bqmoOkKF3sciO/N2y1zASe1qOLy6deWFDw9K2oNgPTbF8iu4F+o3Qkl8oOP+3leYMM/Q9waaInmJt5ouAEpVTYRE/UyH+TxMpqxpCN8Bgaimem9FSj5O2KTY1t9u6lR33Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750447616; c=relaxed/simple;
	bh=uDdeptkygJcnnql/KmH6/zOchGNV5b7mYzzCaZEXvmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ROx3/wdmgG/deCk8HFhBctoyiC7Ug5UMMHgieSgTk7NscNk7vM47oisRAYM7N2RJSNLncd1N9oYk+nOf2sbBebec+sSEw7I389CKLP5RcONYP51DvBwr5kp3mztbkoe/I8ON5GTVaXN7aTfM9ss9rPxDy0/o0Aa+Y/M8iOkzbIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=boplLT3A; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750447614; x=1781983614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uDdeptkygJcnnql/KmH6/zOchGNV5b7mYzzCaZEXvmA=;
  b=boplLT3AApqDF3F8aFgQsSVGRsB3+PXUWwxvUTf6RHog03YabroCBznU
   XbzC3QhI+q+gJZuNlWVKnMWa4tyOTtSY0G6BGJwLaV28zxT6wX+w+2kh3
   j9m766tYygQuu5zNbaiSanqx29AHENG4V8kZM7mZUmBdSNhxTk7jWDBcs
   0nlsQOpEGPMYJcb9VMGfORf+Au4+0JqHXG2SM1rxCH7z6CH6uCzJow27P
   uZnTGZugfgDYIVep9Q+mrAI+UeBQyTEpeSr6iUrT6tuVYIQDWbzhX2TVH
   eR1PRh68ckU/lF7dHpWGjol3wKGSK6E8UVU2QGooBOaHsBu/IAQGXPsKM
   g==;
X-CSE-ConnectionGUID: W3MrlbbfTWmblBktdbhtcQ==
X-CSE-MsgGUID: eKeXPVpLQGKqC94ClW1jFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="64157220"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="64157220"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 12:26:54 -0700
X-CSE-ConnectionGUID: ksn4zqVZSueVdGcqbCRcUQ==
X-CSE-MsgGUID: OOtCuvjQSeaiYfV+c8p9WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="174601618"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 20 Jun 2025 12:26:47 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 457E4109; Fri, 20 Jun 2025 22:26:46 +0300 (EEST)
Date: Fri, 20 Jun 2025 22:26:46 +0300
From: Kirill Shutemov <kirill.shutemov@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Fan Du <fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	Dave Hansen <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	Zhiquan1 Li <zhiquan1.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Chao P Peng <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, "tabba@google.com" <tabba@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, Jun Miao <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <kqzzfujanfc22spwuuqkwvrbtnx3xz5mua6vgkrc7oaztxzcla@z3am7lzyjxmz>
References: <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <803d857f730e205f0611ec97da449a9cf98e4ffb.camel@intel.com>
 <t6z42jxmbskbtiruoz2hj67d7dwffu6sgpsfcvkwl6mpysgx2b@5ssfh35xckyr>
 <aFWNLZQ7pqQahdEh@google.com>
 <4m25vi2w2r4zfmck4giiqryy64etpfvozyqifv4f3i636i7i2o@erv7a6wrtvyy>
 <aFWrH5EYg5ljBwNZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFWrH5EYg5ljBwNZ@google.com>

On Fri, Jun 20, 2025 at 11:40:31AM -0700, Sean Christopherson wrote:
> On Fri, Jun 20, 2025, Kirill Shutemov wrote:
> > On Fri, Jun 20, 2025 at 09:32:45AM -0700, Sean Christopherson wrote:
> > > On Wed, Jun 18, 2025, Kirill Shutemov wrote:
> > > > On Wed, Jun 18, 2025 at 04:22:59AM +0300, Edgecombe, Rick P wrote:
> > > > > On Tue, 2025-06-17 at 08:52 +0800, Yan Zhao wrote:
> > > > > > > hopefully is just handling accepting a whole range that is not 2MB aligned.
> > > > > > > But
> > > > > > > I think we need to verify this more.
> > > > > > Ok.
> > > > > 
> > > > > In Linux guest if a memory region is not 2MB aligned the guest will accept the
> > > 
> > > What is a "memory region" in this context?  An e820 region?  Something else?
> > 
> > EFI memory map entry.
> 
> I forget, for TDX, is the EFI map built by guest firmware or by the VMM?

Guest BIOS.

The BIOS would accept some memory on its own (typically the first 4G) and
leave the rest to be accepted by OS. EFI boot services can also accept
memory on OS request (e.g. on memory allocation), updating the map.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

