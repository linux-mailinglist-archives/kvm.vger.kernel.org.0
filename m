Return-Path: <kvm+bounces-48110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF51AC9395
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 18:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 693924E79C4
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 16:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2FBB2343C0;
	Fri, 30 May 2025 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lNKdW1SA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEBF1DDC07;
	Fri, 30 May 2025 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748622596; cv=none; b=lFnaYW166DwK6ad896Od8n5IChRotMm4WGgcmpO7XKDoO263UMtXzOQA2qUHhoZKJyu0cYnmBEio96d1BTc/D1WSzMitVhyOKYPnXFmOOi/RdvW3hrD4W+CL7V0GFsvVChbYre04MxDuNV6MlBqfV1gkRLFOy/NQwEPDf8mvLc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748622596; c=relaxed/simple;
	bh=D2scOJFObbCx4KXsuqN5hyJ1uWi4EUmVo0sfkDiPW9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTzt9oQ7OG9yCvDkB5rJrJtAYR1yTxoALCCzp8ILnhIHNW7q1Vpu0eEchcIxSHhfGe/ppwAwrtcktwutefp2fqr05sDFSZ99coE/6pj7OYE9gfGPhk8jbR4LwJv+7zjz9nSAmiIoV6RbqZtnyJHDlM4LMoq508YKK18Lb4+cjLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lNKdW1SA; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748622595; x=1780158595;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D2scOJFObbCx4KXsuqN5hyJ1uWi4EUmVo0sfkDiPW9Q=;
  b=lNKdW1SAoWgKbPkdhUOEMWrEZ1SbSJ20BjGsdaahXZf6Asn+e6cSy5fT
   5K7QdXKlq7y/uXHbv+jU1HzC0KpX0nK0ULHWYmSEUERJPgzjGLDNzRltt
   RxFpsxpdyyApcvwzeEECotNZVDBJVmxLypfu4Q3ciKEzQwQ540bC2jZpI
   TgBWiMLj+Zy0/Bz0yXhnyfnPDi4PqTHcUaMM4NNRV6hh86yOb/0W4IkIy
   2Mnqfr/NcFMFNcj09pmQ+OhDNOHvwvhaovDgpe3pkd4ZKay0q6NiwXtqP
   tpLDUNlA1u4+2yttNJhyDg1zGJ84ccYgiNDlpenpaj3DpbY7HQaqUjKQ8
   Q==;
X-CSE-ConnectionGUID: l2qV2cjhQ1CJ4bxNRU2v6A==
X-CSE-MsgGUID: Neis9g1nRiKdsU3ZsIXtNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11449"; a="60977538"
X-IronPort-AV: E=Sophos;i="6.16,196,1744095600"; 
   d="scan'208";a="60977538"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 09:29:54 -0700
X-CSE-ConnectionGUID: gSdMvp93Re2stAr5qQaSYg==
X-CSE-MsgGUID: xmWbXOtqSKqnqwM/UkPvTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,196,1744095600"; 
   d="scan'208";a="149061981"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 30 May 2025 09:29:49 -0700
Date: Sat, 31 May 2025 00:23:28 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	christian.koenig@amd.com, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, daniel.vetter@ffwll.ch,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <aDnbgBbxF8IkH/cq@yilunxu-OptiPlex-7050>
References: <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <aCRAHRCKP1s0Oi0c@yilunxu-OptiPlex-7050>
 <20250514163339.GD382960@nvidia.com>
 <aCYQdDrYYZRAgsen@yilunxu-OptiPlex-7050>
 <9dea400f-a57b-43be-a2e4-24a9f51e6ba0@amd.com>
 <aDE5SPzOAU0sNIt+@yilunxu-OptiPlex-7050>
 <ae16db07-5fca-4369-aa67-cbe2e0fd60fd@amd.com>
 <aDhyC73r149syMpc@yilunxu-OptiPlex-7050>
 <79872224-4e81-446b-a451-28260f449ea9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79872224-4e81-446b-a451-28260f449ea9@amd.com>

On Fri, May 30, 2025 at 12:29:30PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 30/5/25 00:41, Xu Yilun wrote:
> > > > > > 
> > > > > > FLR to a bound device is absolutely fine, just break the CC state.
> > > > > > Sometimes it is exactly what host need to stop CC immediately.
> > > > > > The problem is in VFIO's pre-FLR handling so we need to patch VFIO, not
> > > > > > PCI core.
> > > > > 
> > > > > What is a problem here exactly?
> > > > > FLR by the host which equals to any other PCI error? The guest may or may not be able to handle it, afaik it does not handle any errors now, QEMU just stops the guest.
> > > > 
> > > > It is about TDX Connect.
> > > > 
> > > > According to the dmabuf patchset, the dmabuf needs to be revoked before
> > > > FLR. That means KVM unmaps MMIOs when the device is in LOCKED/RUN state.
> > > > That is forbidden by TDX Module and will crash KVM.
> > > 
> > > 
> > > FLR is something you tell the device to do, how/why would TDX know about it?
> > 
> > I'm talking about FLR in VFIO driver. The VFIO driver would zap bar
> > before FLR. The zapping would trigger KVM unmap MMIOs. See
> > vfio_pci_zap_bars() for legacy case, and see [1] for dmabuf case.
> 
> oh I did not know that we do this zapping, thanks for the pointer.
> > [1] https://lore.kernel.org/kvm/20250307052248.405803-4-vivek.kasireddy@intel.com/
> > 
> > A pure FLR without zapping bar is absolutely OK.
> > 
> > > Or it check the TDI state on every map/unmap (unlikely)?
> > 
> > Yeah, TDX Module would check TDI state on every unmapping.
> 
> _every_? Reading the state from DOE mailbox is not cheap enough (imho) to do on every unmap.

Sorry for confusing. TDX firmware just checks if STOP TDI firmware call
is executed, will not check the real device state via DOE. That means
even if device has physically exited to UNLOCKED, TDX host should still
call STOP TDI fwcall first, then MMIO unmap.

> 
> > > 
> > > > So the safer way is
> > > > to unbind the TDI first, then revoke MMIOs, then do FLR.
> > > > 
> > > > I'm not sure when p2p dma is involved AMD will have the same issue.
> > > 
> > > On AMD, the host can "revoke" at any time, at worst it'll see RMP events from IOMMU. Thanks,
> > 
> > Is the RMP event firstly detected by host or guest? If by host,
> 
> Host.
> 
> > host could fool guest by just suppress the event. Guest thought the
> > DMA writting is successful but it is not and may cause security issue.
> 
> An RMP event on the host is an indication that RMP check has failed and DMA to the guest did not complete so the guest won't see new data. Same as other PCI errors really. RMP acts like a firewall, things behind it do not need to know if something was dropped. Thanks,

Not really, guest thought the data is changed but it actually doesn't.
I.e. data integrity is broken.

Also please help check if the following relates to this issue:

SEV-TIO Firmware Interface SPEC, Section 2.11

If a bound TDI sends a request to the root complex, and the IOMMU detects a fault caused by host
configuration, the root complex fences the ASID from all further I/O to or from that guest. A host
fault is either a host page table fault or an RMP check violation. ASID fencing means that the
IOMMU blocks all further I/O from the root complex to the guest that the TDI was bound, and the
root complex blocks all MMIO accesses by the guest. When a guest writes to MMIO, the write is
silently dropped. When a guest reads from MMIO, the guest reads 1s.

Thanks,
Yilun

> 
> > 
> > Thanks,
> > Yilun
> 
> -- 
> Alexey
> 

