Return-Path: <kvm+bounces-48258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED51DACBFF8
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED3D77A248A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D1A205501;
	Tue,  3 Jun 2025 05:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QJZp+y+T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FC4AD23;
	Tue,  3 Jun 2025 05:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748930348; cv=none; b=h+UQFNJcV+EF/5Ot/rc0rMXUT62si+gWuq+9NASrOI0XOOs+8+lJM8y0Wf1K4FqmU/dq5AH0nliijnA/GhGp9HfXH4e218CMKgQjpNyK7RM7do+FvS36XU74JYcAxXnwemv9ewO0r8RwIBYs1zHARq2EH45I3v4ovVQBdM88uiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748930348; c=relaxed/simple;
	bh=0SZMc9RMAD3OL6AmtIwhsT0nSCxX2GAwLNNSSQsvmVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OihkIAVqqIQAyL8+T2B9Urj3ZXxdHyjEGPuoowRqm3fFIaTe6U6NAYvdGSWbWIssZHNipTU9ASqnNlfngAAhXVhM8o6O8fYVkx99nJGy0kUykF3rqAkM0DY1t6jwZpg7wjfctU52yVdDZckPBJWIff780EzFA4DQR9wQCjp5gbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QJZp+y+T; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748930346; x=1780466346;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0SZMc9RMAD3OL6AmtIwhsT0nSCxX2GAwLNNSSQsvmVE=;
  b=QJZp+y+TuD6DioW1ZnNJN+Vv5LTYFg30TbcYOLPkw4SVaKvavKo3wuMN
   vDTeu72cK+lb2igvCsmaAmoBbohx8STE58XW+FXJimD8MfhIxf+nQYru5
   xVAQmfcVOjx9gFuYFINdU335rJcR5PQ/uPwEvE1ArWB9dOiGnFYt8766J
   g2YEtDKMXkoASqJcZJkK4q9WE7/amQaak9u74+GbkAfs2b6JSCfnZ0cQS
   TJbEqL3t12h9KVXEQrJ/h3SytEWsPMnA/VFKoa5+vbTR1nXCUOYZ3JgCA
   LA1loEizQJmBtJXB4TpLP3HWgViDasokrziWhSH7fEjZYcDzfR4gdXM+z
   w==;
X-CSE-ConnectionGUID: X8aoT0lzRAGRUHs6oRWDRQ==
X-CSE-MsgGUID: 1rAQj+B6Qf64D/uuccvPeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="73485490"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="73485490"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 22:59:05 -0700
X-CSE-ConnectionGUID: YBlVT30SRWmnzwryX2WviQ==
X-CSE-MsgGUID: Ve/oAFGISO6sRzGF6gBGcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="149801571"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 02 Jun 2025 22:58:59 -0700
Date: Tue, 3 Jun 2025 13:52:27 +0800
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
Subject: Re: [RFC PATCH 27/30] PCI/TSM: Add PCI driver callbacks to handle
 TSM requirements
Message-ID: <aD6Nm7bBGddTc+pr@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-28-yilun.xu@linux.intel.com>
 <yq5att4yjns2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5att4yjns2.fsf@kernel.org>

On Mon, Jun 02, 2025 at 06:36:37PM +0530, Aneesh Kumar K.V wrote:
> Xu Yilun <yilun.xu@linux.intel.com> writes:
> 
> > Add optional PCI driver callbacks to notify TSM events. For now, these
> > handlers may be called during pci_tsm_unbind(). By calling these
> > handlers, TSM driver askes for external collaboration to finish entire
> > TSM unbind flow.
> >
> > If platform TSM driver could finish TSM bind/unbind all by itself, don't
> > call these handlers.
> >
> > Host may need to configure various system components according to
> > platform trusted firmware's requirements. E.g. for Intel TDX Connect,
> > host should do private MMIO mapping in S-EPT, trusted DMA setup, device
> > ownership claiming and device TDISP state transition. Some operations are
> > out of control of PCI TSM, so need collaboration by external components
> > like IOMMU driver, KVM.
> >
> > Further more, trusted firmware may enforce executing these operations
> > in a fixed sequence. E.g. Intel TDX Connect enforces the following
> > sequences for TSM unbind:
> >
> >   1. STOP TDI via TDISP message STOP_INTERFACE
> >   2. Private MMIO unmap from Secure EPT
> >   3. Trusted Device Context Table cleanup for the TDI
> >   4. TDI ownership reclaim and metadata free
> >
> > PCI TSM could do Step 1 and 4, but need KVM for Step 2 and IOMMU driver
> > for Step 3. While it is possible TSM provides finer grained APIs like
> > tdi_stop() & tdi_free(), and the caller ensures the sequence, it is
> > better these specific enforcement could be managed in platform TSM
> > driver. By introducing TSM handlers, platform TSM driver controls the
> > operation sequence and notify other components to do the real work.
> >
> > Currently add 3 callbacks for TDX Connect. disable_mmio() is for
> > VFIO to invalidate MMIO so that KVM could unmap them from S-EPT.
> > recover_mmio() is to re-validate MMIO so that KVM could map them
> > again for shared assigned device. disable_trusted_dma() is to cleanup
> > trusted IOMMU setup.
> >
> > Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> > ---
> >  include/linux/pci-tsm.h | 7 +++++++
> >  include/linux/pci.h     | 3 +++
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
> > index 737767f8a9c5..ed549724eb5b 100644
> > --- a/include/linux/pci-tsm.h
> > +++ b/include/linux/pci-tsm.h
> > @@ -157,6 +157,13 @@ struct pci_tsm_ops {
> >  	int (*accept)(struct pci_dev *pdev);
> >  };
> >  
> > +/* pci drivers callbacks for TSM */
> > +struct pci_tsm_handlers {
> > +	void (*disable_mmio)(struct pci_dev *dev);
> > +	void (*recover_mmio)(struct pci_dev *dev);
> > +	void (*disable_trusted_dma)(struct pci_dev *dev);
> > +};
> > +
> >  enum pci_doe_proto {
> >  	PCI_DOE_PROTO_CMA = 1,
> >  	PCI_DOE_PROTO_SSESSION = 2,
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 5f37957da18f..4f768b4658e8 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -545,6 +545,7 @@ struct pci_dev {
> >  #endif
> >  #ifdef CONFIG_PCI_TSM
> >  	struct pci_tsm *tsm;		/* TSM operation state */
> > +	void *trusted_dma_owner;
> >  #endif
> >  	u16		acs_cap;	/* ACS Capability offset */
> >  	u8		supported_speeds; /* Supported Link Speeds Vector */
> > @@ -957,6 +958,7 @@ struct module;
> >   * @sriov_get_vf_total_msix: PF driver callback to get the total number of
> >   *              MSI-X vectors available for distribution to the VFs.
> >   * @err_handler: See Documentation/PCI/pci-error-recovery.rst
> > + * @tsm_handler: Optional driver callbacks to handle TSM requirements.
> >   * @groups:	Sysfs attribute groups.
> >   * @dev_groups: Attributes attached to the device that will be
> >   *              created once it is bound to the driver.
> > @@ -982,6 +984,7 @@ struct pci_driver {
> >  	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
> >  	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
> >  	const struct pci_error_handlers *err_handler;
> > +	struct pci_tsm_handlers *tsm_handler;
> >  	const struct attribute_group **groups;
> >  	const struct attribute_group **dev_groups;
> >  	struct device_driver	driver;
> > -- 
> > 2.25.1
> 
> It looks like the TSM feature is currently interacting with several
> components: struct pci_driver, VFIO, iommufd, and pci_tsm_ops.
> 
> Should we consider limiting this scattering? Would it make sense to
> encapsulate this logic within pci_tsm_ops?

I'm keeping on trying which is a better solution. Encapsulating all in
pci_tsm_ops is the most attactive one from SW POV, but only if the TSM
operations has no impact/dependency to other components. Unfortunately
it is not true, e.g. the private MMIO mapping/unmapping is actually
a writting to leaf S-EPT entry, but it requires non-leaf page-table-page
management in KVM.

Thanks,
Yilun

> 
> -aneesh

