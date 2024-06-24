Return-Path: <kvm+bounces-36080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEAEA175A3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 02:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BCA93A2896
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 01:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CCFC3B19A;
	Tue, 21 Jan 2025 01:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnU/a3+i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E334B5AE
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 01:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737422683; cv=none; b=h1b0Es0ybdzOaDrGG5V2vyJMxc5tVBn4ZODwldyDSNrTrvCwSAVevFoxNuyA3vUiPitBqxOVa9otvypOkaJdRuuWC+BsU8FrUo818ZAQl+gg0dTx6zO6/GYOdJdIXheHLVs3BY6XHXuf0zdAIRBWrZGWanwg71QOtcvb6facYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737422683; c=relaxed/simple;
	bh=FPg3TuHPY7jtHz85ISGqMg2kzizpxcy1l51R+UxE23U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oc0OYXIDmeWYfuo2RSORK9C89/jrTJeakSCo7svKo/tWyXM7hk+96rBgmsilC7niGVmsqUDy+vNNEuOnhnLNRDJX4nErWuYLb1KqhWJZ4qUi0DDJ/1wPY2s3C4t6J2CnsDaf6ol/1WFKhloYSWlTE1AcgqVi2FEXuQ+IBK2OSpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnU/a3+i; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737422682; x=1768958682;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FPg3TuHPY7jtHz85ISGqMg2kzizpxcy1l51R+UxE23U=;
  b=fnU/a3+i7redkmMFSRq97zq1YpWmlxWPy1OVTst6KoiN9bDKvCm1NRj7
   4HncVWU06IezbB4Rgl75/eZd82rZE6z5nWsigsYyVJ3cKEU+lxYrrXsGW
   LAx4Qjr5Wpp/4tXYBewV6PBr4O4ZYHPrxHgrv1OttkrO4BY4RjOxxxO4c
   wqJ5RTiQeHnFQtwMMzTgwqEYK7b31zsDRwxeaHxt61SUAPn+/lCFgRavy
   YWdvOeVILmXhycr4Ow4M8r628Dk5lR47KRQjntDmOA7oRV0zbvot+Jfiz
   McOYy+nGibcNHYvfxmgjqBrDQ2xIZk8YRpDETtBhRbTdiK9zszUok0oJm
   Q==;
X-CSE-ConnectionGUID: eC0qtFTlRnqjl+pExsVwsg==
X-CSE-MsgGUID: XO57ITopQdqGkMavlkDeZg==
X-IronPort-AV: E=McAfee;i="6700,10204,11321"; a="41582954"
X-IronPort-AV: E=Sophos;i="6.13,220,1732608000"; 
   d="scan'208";a="41582954"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2025 17:24:42 -0800
X-CSE-ConnectionGUID: dtDZMTL1Q1+tmX9xtX/OAQ==
X-CSE-MsgGUID: v7KlY8qVQRG7mxL/M8gSPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,220,1732608000"; 
   d="scan'208";a="107257927"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 20 Jan 2025 17:24:38 -0800
Date: Tue, 25 Jun 2024 00:31:13 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Peter Xu <peterx@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
References: <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z462F1Dwm6cUdCcy@x1n>

On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > It is still uncertain how to implement the private MMIO. Our assumption
> > > is the private MMIO would also create a memory region with
> > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > listener.
> > 
> > My current working approach is to leave it as is in QEMU and VFIO.
> 
> Agreed.  Setting ram=true to even private MMIO sounds hackish, at least

The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
normal assigned MMIO is always set ram=true,

void memory_region_init_ram_device_ptr(MemoryRegion *mr,
                                       Object *owner,
                                       const char *name,
                                       uint64_t size,
                                       void *ptr)
{
    memory_region_init(mr, owner, name, size);
    mr->ram = true;


So I don't think ram=true is a problem here.

Thanks,
Yilun

> currently QEMU heavily rely on that flag for any possible direct accesses.
> E.g., in memory_access_is_direct().
> 
> -- 
> Peter Xu
> 
> 

