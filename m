Return-Path: <kvm+bounces-48250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A319ACBF6B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 06:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 863BB16F7A0
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 04:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4211F4CAA;
	Tue,  3 Jun 2025 04:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q4uLpHRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0EF139B;
	Tue,  3 Jun 2025 04:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748926612; cv=none; b=U/MpZxWWjsbbJgiJ83y4UTudxnGXzAC2mzM3D/VEmi6+Ap2mJTdExrpE7HEO+dc2oNMzgPMw/cGdmz9ihxVpyXivKRzGpJtj4pAGpW7sNk3NJ6ffB9/8s5emWM0LZ0Bco5c4PJVZAzPKuRCs77q+aIza399C/AeYZiBEv718EOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748926612; c=relaxed/simple;
	bh=p6Uliwjeb9aiPXavhCVIq0Xv1uYAO1wNjq9ELL7jF9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enXiSjK5j8pUSneOuFqVMgNKsI+wnh4OudDfWQDPw701ZiF3EdBCpOrjRMgKJWfcBmpERNWCL19M5lI82qlWEdLOrlx6CDAsPPGlVgBh0DEkRQcfe4k4+qzwTmzFd1NsCxJ3rGB1B57FOXF31nvdt8QZ/STB0J//c2+HB2LRELc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q4uLpHRZ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748926609; x=1780462609;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p6Uliwjeb9aiPXavhCVIq0Xv1uYAO1wNjq9ELL7jF9s=;
  b=Q4uLpHRZu/t0o7QfJOdhDhV6k/mFl3qIOzhhkyWbZxaZ34sx1pVIXwB9
   j0wyzqnhM1W5Ry+uYaPGz8bxBKEzLUy3Gy/1eB8Ol1ou2aRat3itAMMLN
   rAj87AJfHTFylEuLUsIV+CqdPNKUnVUPXCKu1iWc1TeYyqg4wtPIl0iz4
   AxDRKdtdoNfSXxHn08T2L8Ahfn4HBixK/ODtOh4UyVAtG5zjQ0jR9iPp7
   7YPC07LgXHPhu3qAWXQn0QF7tGwjGXFRrbbWl/gY/be8fYRiO7SLAowS4
   vZGqhfW5OG7Dp+S1/jjY7LO1NvUlFRO5JY0kKem2BYUkQdNgVPi1nBEL9
   g==;
X-CSE-ConnectionGUID: 2B4IGweST1Snt6Qjn5bTgA==
X-CSE-MsgGUID: QYbOKG0KT7i0KBVsbntu2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="62004247"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="62004247"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 21:56:48 -0700
X-CSE-ConnectionGUID: +R3KxD5fSay5O/7fDmdhSg==
X-CSE-MsgGUID: JbKyM8ULSPaqs7NuuQafDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="175593681"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 02 Jun 2025 21:56:43 -0700
Date: Tue, 3 Jun 2025 12:50:10 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com, yilun.xu@intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 20/30] vfio/pci: Do TSM Unbind before zapping bars
Message-ID: <aD5/AjaQQOKydUWz@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-21-yilun.xu@linux.intel.com>
 <yq5ar002jlao.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ar002jlao.fsf@kernel.org>

On Mon, Jun 02, 2025 at 07:30:15PM +0530, Aneesh Kumar K.V wrote:
> Xu Yilun <yilun.xu@linux.intel.com> writes:
> 
> > When device is TSM Bound, some of its MMIO regions are controlled by
> > secure firmware. E.g. TDX Connect would require these MMIO regions
> > mappeed in S-EPT and never unmapped until device Unbound. Zapping bars
> > irrespective of TSM Bound state may cause unexpected secure firmware
> > errors. It is always safe to do TSM Unbind first, transiting the device
> > to shared, then do whatever needed as before.
> >
> > Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c |  4 +++
> >  drivers/vfio/pci/vfio_pci_core.c   | 41 +++++++++++++++++++-----------
> >  drivers/vfio/pci/vfio_pci_priv.h   |  3 +++
> >  3 files changed, 33 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index 7ac062bd5044..4ffe661c9e59 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -590,6 +590,7 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
> >  		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
> >  
> >  		if (!new_mem) {
> > +			vfio_pci_tsm_unbind(vdev);
> >  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> >  			vfio_pci_dma_buf_move(vdev, true);
> >
> 
> For a secure device mmio range instead of vfio_pci_zap_and_down_write_memory_lock()
> -> unmap_mapping_range() we want the vfio_pci_dma_buf_move right?

Yes.

> Also is that expected to get called twice as below?

Yes for TDX Connect. First time zap the private MMIOs during unbind.
Second time block all mmio mapping.

Other platforms don't need these tsm handlers. They don't have this
awkwardness.

Thanks,
Yilun

> 
> vfio_pci_tsm_unbind-> pci_tsm_unbind -> tdx_tsm_unbind ->
> tsm_handler->disable_mmio() -> vfio_pci_core_tsm_disable_mmio -> vfio_pci_dma_buf_move(vdev, true);
> 
> -aneesh

