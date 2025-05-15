Return-Path: <kvm+bounces-46704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C90FCAB8C06
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 18:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670773B9660
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 16:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDCF021C189;
	Thu, 15 May 2025 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VtiLpe5k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FD120C000;
	Thu, 15 May 2025 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747325390; cv=none; b=HzZuGOj05B102mY1LnFurRiGjPMQyZcqj9JPmfK+Hwj/xbte1qk/eQwjdZF7nDgwFWR1nI2CviKobYTzZacn3++2cBrQAj+rPyC1vf3s5YBONKZJiJWpJfIgzfvl9Zn3uZJsazl+waT4TS5/ZM/iWcpTUHQnwHbrXEhAMmZDarM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747325390; c=relaxed/simple;
	bh=tpCgJy/zSCkczp+40MhbYRBqr/P+RllTPVB7OGZpVXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rugIEBxK19ldrsXiIgDzKkSoKc83O1ImO3/5ybWjZ3XAEnMSG4i6k3aAq07l4Q8EHxtHuMs7q0Dts0Yl6rjJHU8JtYdufBBjWdambeAGVKYNgQipaaO3q6G1MPdm11zgW0Se/hauLsOJCEeb8etdgen/DOmsqn+1bSanDXLL2Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VtiLpe5k; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747325388; x=1778861388;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tpCgJy/zSCkczp+40MhbYRBqr/P+RllTPVB7OGZpVXc=;
  b=VtiLpe5kXWSmiOg9+wMrXvwR5j/Mul76iNtyOLLe/XDdmmAC6SW31T4R
   cbl/kgLuQ7/rmRbNrBUUE9YddpEJJLYfwyjk3CTvh/Z60D9Xs4UGOdK6m
   uoCDc7E+0T+qOMwctjIrKhuC+rbftCTMyK+1Od0nDanFj4oLx2mxz5l4m
   HVk6VkkxZolSN8g3X/2fwrA02N62QhMNwh1p+cGgwyNhjEJi9e5yVQvee
   17kBPDrcpx7Mi4NWxJeuxYNxqa5VxsLGHw9EptREoEBjICL+mToPjcciS
   jrO5wV9eo91JvfbkSO+VYTMnH21NIWwchwAvKCNQ3YE/A5zz8Z6Eav4Uc
   A==;
X-CSE-ConnectionGUID: /RCSu13iTkK8HbZAuRGQSw==
X-CSE-MsgGUID: FFJVDiw3SoORgoMOlE2t0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="74678608"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="74678608"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 09:09:47 -0700
X-CSE-ConnectionGUID: UlvHWocqSc21JeBS3puygw==
X-CSE-MsgGUID: nodxmg8eSV+502A0s6JSLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="143370749"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 15 May 2025 09:09:42 -0700
Date: Fri, 16 May 2025 00:04:04 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
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
Message-ID: <aCYQdDrYYZRAgsen@yilunxu-OptiPlex-7050>
References: <4b6dc759-86fd-47a7-a206-66b25a0ccc6d@amd.com>
 <c10bf9c2-e073-479d-ad1c-6796c592d333@amd.com>
 <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <aCRAHRCKP1s0Oi0c@yilunxu-OptiPlex-7050>
 <20250514163339.GD382960@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514163339.GD382960@nvidia.com>

On Wed, May 14, 2025 at 01:33:39PM -0300, Jason Gunthorpe wrote:
> On Wed, May 14, 2025 at 03:02:53PM +0800, Xu Yilun wrote:
> > > We have an awkward fit for what CCA people are doing to the various
> > > Linux APIs. Looking somewhat maximally across all the arches a "bind"
> > > for a CC vPCI device creation operation does:
> > > 
> > >  - Setup the CPU page tables for the VM to have access to the MMIO
> > 
> > This is guest side thing, is it? Anything host need to opt-in?
> 
> CPU hypervisor page tables.
> 
> > >  - Revoke hypervisor access to the MMIO
> > 
> > VFIO could choose never to mmap MMIO, so in this case nothing to do?
> 
> Yes, if you do it that way.
>  
> > >  - Setup the vIOMMU to understand the vPCI device
> > >  - Take over control of some of the IOVA translation, at least for T=1,
> > >    and route to the the vIOMMU
> > >  - Register the vPCI with any attestation functions the VM might use
> > >  - Do some DOE stuff to manage/validate TDSIP/etc
> > 
> > Intel TDX Connect has a extra requirement for "unbind":
> > 
> > - Revoke KVM page table (S-EPT) for the MMIO only after TDISP
> >   CONFIG_UNLOCK
> 
> Maybe you could express this as the S-EPT always has the MMIO mapped
> into it as long as the vPCI function is installed to the VM?

Yeah.

> Is KVM responsible for the S-EPT?

Yes.

> 
> > Another thing is, seems your term "bind" includes all steps for
> > shared -> private conversion. 
> 
> Well, I was talking about vPCI creation. I understand that during the
> vPCI lifecycle the VM will do "bind" "unbind" which are more or less
> switching the device into a T=1 mode. Though I understood on some

I want to introduce some terms about CC vPCI.

1. "Bind", guest requests host do host side CC setup & put device in
CONFIG_LOCKED state, waiting for attestation. Any further change which
has secuity concern breaks "bind", e.g. reset, touch MMIO, physical MSE,
BAR addr...

2. "Attest", after "bind", guest verifies device evidences (cert,
measurement...).

3. "Accept", after successful attestation, guest do guest side CC setup &
switch the device into T=1 mode (TDISP RUN state)

4. "Unbind", guest requests host put device in CONFIG_UNLOCK state +
remove all CC setup.

> arches this was mostly invisible to the hypervisor?

Attest & Accept can be invisible to hypervisor, or host just help pass
data blobs between guest, firmware & device.

Bind cannot be host agnostic, host should be aware not to touch device
after Bind.

> 
> > But in my mind, "bind" only includes
> > putting device in TDISP LOCK state & corresponding host setups required
> > by firmware. I.e "bind" means host lockes down the CC setup, waiting for
> > guest attestation.
> 
> So we will need to have some other API for this that modifies the vPCI
> object.

IIUC, in Alexey's patch ioctl(iommufd, IOMMU_VDEVICE_TSM_BIND) does the
"Bind" thing in host.

> 
> It might be reasonable to have VFIO reach into iommufd to do that on
> an already existing iommufd VDEVICE object. A little weird, but we
> could probably make that work.

Mm, Are you proposing an uAPI in VFIO, and a kAPI from VFIO -> IOMMUFD like:

 ioctl(vfio_fd, VFIO_DEVICE_ATTACH_VDEV, vdev_id)
 -> iommufd_device_attach_vdev()
    -> tsm_tdi_bind()

> 
> But you have some weird ordering issues here if the S-EPT has to have
> the VFIO MMIO then you have to have a close() destruction order that

Yeah, by holding kvm reference.

> sees VFIO remove the S-EPT and release the KVM, then have iommufd
> destroy the VDEVICE object.

Regarding VM destroy, TDX Connect has more enforcement, VM could only be
destroyed after all assigned CC vPCI devices are destroyed.

Nowadays, VFIO already holds KVM reference, so we need

close(vfio_fd)
-> iommufd_device_detach_vdev()
   -> tsm_tdi_unbind()
      -> tdi stop
      -> callback to VFIO, dmabuf_move_notify(revoke)
         -> KVM unmap MMIO
      -> tdi metadata remove
-> kvm_put_kvm()
   -> kvm_destroy_vm()


> 
> > > It doesn't mean that iommufd is suddenly doing PCI stuff, no, that
> > > stays in VFIO.
> > 
> > I'm not sure if Alexey's patch [1] illustates your idea. It calls
> > tsm_tdi_bind() which directly does device stuff, and impacts MMIO.
> > VFIO doesn't know about this.
> > 
> > I have to interpret this as VFIO firstly hand over device CC features
> > and MMIO resources to IOMMUFD, so VFIO never cares about them.
> > 
> > [1] https://lore.kernel.org/all/20250218111017.491719-15-aik@amd.com/
> 
> There is also the PCI layer involved here and maybe PCI should be
> participating in managing some of this. Like it makes a bit of sense
> that PCI would block the FLR on platforms that require this?

FLR to a bound device is absolutely fine, just break the CC state.
Sometimes it is exactly what host need to stop CC immediately.
The problem is in VFIO's pre-FLR handling so we need to patch VFIO, not
PCI core.

Thanks,
Yilun

> 
> Jason

