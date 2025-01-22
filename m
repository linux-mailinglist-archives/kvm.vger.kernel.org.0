Return-Path: <kvm+bounces-36234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8BECA18E88
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 10:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E186188897C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2C9210F56;
	Wed, 22 Jan 2025 09:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9XPkgqz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58CB210184
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 09:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737538906; cv=none; b=F+weZd9Hgg3DbF7VUwxPoWHUr1pwAdM2yaG+LAfMeLu5TivH5LRAuJg7Y7PJPV2zUThXnjZa7Ff4fGkjZ6enIQKHrkryXRKKSw3USC/7Wn19G+Ga8lrSlzuLcIl4FspR5OTCNOGiSudrAXncwxcdxfg+dXZ4vccQPmnQARZhoew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737538906; c=relaxed/simple;
	bh=owsEZA7axqN2tzMnFMwmr8Y1RsBH0gepw5uM/bZOsI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rKoBQz3eJNeWo890a2oSQJrmm1XJU0kjvsGpXIvlrzW6+wcHSQWheI6qZO6ZZVRO7C7/g2oX0alxmFjez8iVS7HTu9MnLYvIzgBbq4kOyG+uS0Jyk+XpaLEI+gImm/8DTPPfd+4owlATsLZzFDiCWBwY18HT7cuO6k3CrZXHLBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l9XPkgqz; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737538905; x=1769074905;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=owsEZA7axqN2tzMnFMwmr8Y1RsBH0gepw5uM/bZOsI0=;
  b=l9XPkgqzy/ZcvR+jAm24iRvZoAbOaqySHNjIs/NJgYfwkL37DStKk1h3
   srBVn+3qiNOxZLoQwkAn9KeRPf0Wjfv/pBnpZ3zlwpRlGNqpsWqFy0BpH
   p2tnSaM+F/BvkqI92fRfiOiO3Y3kbIDCj8WCrJJWWFdASlH0Z++OQBz2j
   evCL2fSwopVBUnR+uu1vFDJW4LwlRqsz2vV2OryA1hh480P9qD4iyHxi3
   f1oz21VtAkV1FWW2mmvl4oaGcqdOeNLNiWgsKix2N78dDW9YN7TfDStWX
   CjiFbXEQOX1E2AhmtdLJ+Iv2EgCtu7UStF9FI+0JgXlsghIC3TeSMx2di
   w==;
X-CSE-ConnectionGUID: 4Mb/s4FdSX+N7UkBgon3oA==
X-CSE-MsgGUID: B2X+5P1DRemYLXqyiWxc7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="55537244"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="55537244"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 01:41:44 -0800
X-CSE-ConnectionGUID: pwElfivTTTaVwZNRiKbgxw==
X-CSE-MsgGUID: KLNJcEWXTJe9+yRx0qnWng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="112099494"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 22 Jan 2025 01:41:41 -0800
Date: Wed, 22 Jan 2025 17:41:31 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Peter Xu <peterx@redhat.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
References: <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>

On Wed, Jan 22, 2025 at 03:30:05PM +1100, Alexey Kardashevskiy wrote:
> 
> 
> On 22/1/25 02:18, Peter Xu wrote:
> > On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
> > > On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> > > > On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > > > > It is still uncertain how to implement the private MMIO. Our assumption
> > > > > > is the private MMIO would also create a memory region with
> > > > > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > > > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > > > > listener.
> > > > > 
> > > > > My current working approach is to leave it as is in QEMU and VFIO.
> > > > 
> > > > Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
> > > 
> > > The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
> > > normal assigned MMIO is always set ram=true,
> > > 
> > > void memory_region_init_ram_device_ptr(MemoryRegion *mr,
> > >                                         Object *owner,
> > >                                         const char *name,
> > >                                         uint64_t size,
> > >                                         void *ptr)
> > > {
> > >      memory_region_init(mr, owner, name, size);
> > >      mr->ram = true;
> > > 
> > > 
> > > So I don't think ram=true is a problem here.
> > 
> > I see.  If there's always a host pointer then it looks valid.  So it means
> > the device private MMIOs are always mappable since the start?
> 
> Yes. VFIO owns the mapping and does not treat shared/private MMIO any
> different at the moment. Thanks,

mm.. I'm actually expecting private MMIO not have a host pointer, just
as private memory do.

But I'm not sure why having host pointer correlates mr->ram == true.

Thanks,
Yilun

> 
> > 
> > Thanks,
> > 
> 
> -- 
> Alexey
> 

