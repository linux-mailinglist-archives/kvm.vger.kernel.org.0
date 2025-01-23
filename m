Return-Path: <kvm+bounces-36323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 188A7A19F3F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 08:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB5673AED1A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 07:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE9320B7EE;
	Thu, 23 Jan 2025 07:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lvpTQxMO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE9D20B7F0;
	Thu, 23 Jan 2025 07:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737618139; cv=none; b=X4CwbdRW7yGedqSULT7AEJsMWzfKYgXc3VDK5KF2HvPUg5qaQsoJm3BQN7cG27xdiJt5T5GyRSVUGkmib0OBC9iL8pII6inFGJyuOFBfxBPod1PZAaaqEp0UYf35LwuDKZoh9r73ThhxST3IBw6KyVaT/i35mhNB+KFMk2/PQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737618139; c=relaxed/simple;
	bh=WfCoT8DAVyePFPdKpLI3f57LRfvllzvhy6jwVyfb9z0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XniMqwNszt0dz7zDmVLuDLbU9jIztzfvYY3Ibe5Y6Bs0F0nbkl+o2ZBl1B6IAHp9I5KhuZdWgUHA4YdcVPNTDcONPZOttQyEodzpqLpC/Q0NMxavufygNss/mGdEUI5Fi4Kdl0dbKmyMzNoxe4O3aoZNo8MPHF8WxPfNfuuJDbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lvpTQxMO; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737618138; x=1769154138;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WfCoT8DAVyePFPdKpLI3f57LRfvllzvhy6jwVyfb9z0=;
  b=lvpTQxMO0RhFFy3Y/lHaJhfOPvy5dLPsSI7f+AOWkEw88+1yJdgUGtfj
   zjXZWg4Cz2pGlUZFNTYfWgtKHXHGJG+vnLto8MS390LTYExKO1I3FzCWb
   9oV63jjLQ75Z/3Fr5EQxf8pkcvOQ8dyVqoG/de+RJiK/lzl+A5Utxrb/B
   mPpCqVVRFPKZDATUW9eW/38jz+bTdXLGpENCvAAgTs2HJrhLSAp71G8c1
   F3h30NLscQe/2oW275erPHKR9Di7xzy66jz8+cAbN7CrQ9CJSFhca5Ra4
   akDE1+WmIOWyS/No6QPBybQpzgWmTl2q5QHJ/Q7fY9+NCVRsP/ep3r/77
   Q==;
X-CSE-ConnectionGUID: L4g5SdwSR2uEPbcdzIHMwA==
X-CSE-MsgGUID: ZOvmbb0XQ5yoU21mbPNMlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="37992364"
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="37992364"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 23:42:16 -0800
X-CSE-ConnectionGUID: 1OH4uuflR5S+l2cqgHzD4w==
X-CSE-MsgGUID: Mc61jTczThiN5e0xUsKqtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112028936"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa005.fm.intel.com with ESMTP; 22 Jan 2025 23:42:10 -0800
Date: Thu, 23 Jan 2025 15:41:58 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <Z5HyxlaiXqp2/KOA@yilunxu-OptiPlex-7050>
References: <17cd9b77-4620-4883-9a6a-8d1cab822c88@amd.com>
 <20250115130102.GM5556@nvidia.com>
 <f1ac048f-64b1-4343-ab86-ad98c24a44f5@linux.intel.com>
 <20250117132523.GA5556@nvidia.com>
 <Znh+uTMe/wX2RIJm@yilunxu-OptiPlex-7050>
 <20250120132525.GH5556@nvidia.com>
 <ZnnhKtA2n4s1CLyf@yilunxu-OptiPlex-7050>
 <20250121174303.GV5556@nvidia.com>
 <Z5B0+OcLWsiHLRIA@yilunxu-OptiPlex-7050>
 <20250122125512.GD5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122125512.GD5556@nvidia.com>

On Wed, Jan 22, 2025 at 08:55:12AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 22, 2025 at 12:32:56PM +0800, Xu Yilun wrote:
> > On Tue, Jan 21, 2025 at 01:43:03PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Jun 25, 2024 at 05:12:10AM +0800, Xu Yilun wrote:
> > > 
> > > > When VFIO works as a TEE user in VM, it means an attester (e.g. PCI
> > > > subsystem) has already moved the device to RUN state. So VFIO & DPDK
> > > > are all TEE users, no need to manipulate TDISP state between them.
> > > > AFAICS, this is the most preferred TIO usage in CoCo-VM.
> > > 
> > > No, unfortunately. Part of the motivation to have the devices be
> > > unlocked when the VM starts is because there is an expectation that a
> > > driver in the VM will need to do untrusted operations to boot up the
> > 
> > I assume these operations are device specific.
> 
> Yes
> 
> > > device before it can be switched to the run state.
> > > 
> > > So any vfio use case needs to imagine that VFIO starts with an
> > > untrusted device, does stuff to it, then pushes everything through to
> > 
> > I have concern that VFIO has to do device specific stuff. Our current
> > expectation is a specific device driver deals with the untrusted
> > operations, then user writes a 'bind' device sysfs node which detaches
> > the driver for untrusted, do the attestation and accept, and try match
> > the driver for trusted (e.g. VFIO).
> 
> I don't see this as working, VFIO will FLR the device which will
> destroy anything that was done prior.
> 
> VFIO itself has to do the sequence and the VFIO userspace has to
> contain the device specific stuff.

I don't have a complete idea yet. But the goal is not to make any
existing driver seamlessly work with secure device. It is to provide a
generic way for bind/attestation/accept, and may save driver's effort
if they don't care about this startup process. There are plenty of
operations that a driver can't do to a secure device, FLR is one of
them. The TDISP SPEC has described some general rules but some are even
device specific.

So I think a driver (including VFIO) expects change to support trusted
device, but may not have to cover bind/attestation/accept flow.

Thanks,
Yilun

> 
> The bind/unbind dance for untrusted->trusted would need to be
> internalized in VFIO without unbinding. The main motivation for the
> bind/unbind flow was to manage the DMA API, which VFIO does not use.
> 
> Jason

