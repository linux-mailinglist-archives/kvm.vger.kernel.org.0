Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC8219D629
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 13:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbgDCL4Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 3 Apr 2020 07:56:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:57454 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgDCL4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 07:56:16 -0400
IronPort-SDR: Bp0XxvRLo+5ivD791nErX0Aa9SC+DxTHYqY/KdYcl1Pka49bZ4zu8A1oKEJ+9shlR4R9oTBBFS
 oy3T6oqIYKUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 04:56:15 -0700
IronPort-SDR: Pp6CaFev95o78liw4lTnYEJR0DHLihUaGmowtgmyYMORQqe2+n8CaEBN6qxKVI1C2PISbMWp+G
 Ap82RDJi296g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="268338356"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2020 04:56:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 04:56:13 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 Apr 2020 04:56:13 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 3 Apr 2020 04:56:13 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.209]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 19:56:09 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbC4GB74LMekup8jIcF6WIFqhlZUwAgAH1tzA=
Date:   Fri, 3 Apr 2020 11:56:09 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A2209E3@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
 <20200402135240.GE1176452@myrica>
In-Reply-To: <20200402135240.GE1176452@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Thursday, April 2, 2020 9:53 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> 
> Hi Yi,
> 
> On Sun, Mar 22, 2020 at 05:31:58AM -0700, Liu, Yi L wrote:
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > For a long time, devices have only one DMA address space from platform
> > IOMMU's point of view. This is true for both bare metal and directed-
> > access in virtualization environment. Reason is the source ID of DMA in
> > PCIe are BDF (bus/dev/fnc ID), which results in only device granularity
> > DMA isolation. However, this is changing with the latest advancement in
> > I/O technology area. More and more platform vendors are utilizing the PCIe
> > PASID TLP prefix in DMA requests, thus to give devices with multiple DMA
> > address spaces as identified by their individual PASIDs. For example,
> > Shared Virtual Addressing (SVA, a.k.a Shared Virtual Memory) is able to
> > let device access multiple process virtual address space by binding the
> > virtual address space with a PASID. Wherein the PASID is allocated in
> > software and programmed to device per device specific manner. Devices
> > which support PASID capability are called PASID-capable devices. If such
> > devices are passed through to VMs, guest software are also able to bind
> > guest process virtual address space on such devices. Therefore, the guest
> > software could reuse the bare metal software programming model, which
> > means guest software will also allocate PASID and program it to device
> > directly. This is a dangerous situation since it has potential PASID
> > conflicts and unauthorized address space access.
> 
> It's worth noting that this applies to Intel VT-d with scalable mode, not
> IOMMUs that use one PASID space per VM

Oh yes. will add it.

> 
> > It would be safer to
> > let host intercept in the guest software's PASID allocation. Thus PASID
> > are managed system-wide.
> >
> > This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims to passdown
> > PASID allocation/free request from the virtual IOMMU. Additionally, such
> > requests are intended to be invoked by QEMU or other applications which
> > are running in userspace, it is necessary to have a mechanism to prevent
> > single application from abusing available PASIDs in system. With such
> > consideration, this patch tracks the VFIO PASID allocation per-VM. There
> > was a discussion to make quota to be per assigned devices. e.g. if a VM
> > has many assigned devices, then it should have more quota. However, it
> > is not sure how many PASIDs an assigned devices will use. e.g. it is
> > possible that a VM with multiples assigned devices but requests less
> > PASIDs. Therefore per-VM quota would be better.
> >
> > This patch uses struct mm pointer as a per-VM token. We also considered
> > using task structure pointer and vfio_iommu structure pointer. However,
> > task structure is per-thread, which means it cannot achieve per-VM PASID
> > alloc tracking purpose. While for vfio_iommu structure, it is visible
> > only within vfio. Therefore, structure mm pointer is selected. This patch
> > adds a structure vfio_mm. A vfio_mm is created when the first vfio
> > container is opened by a VM. On the reverse order, vfio_mm is free when
> > the last vfio container is released. Each VM is assigned with a PASID
> > quota, so that it is not able to request PASID beyond its quota. This
> > patch adds a default quota of 1000. This quota could be tuned by
> > administrator. Making PASID quota tunable will be added in another patch
> > in this series.
> >
> > Previous discussions:
> > https://patchwork.kernel.org/patch/11209429/
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/vfio/vfio.c             | 130 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio_iommu_type1.c | 104 ++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h            |  20 +++++++
> >  include/uapi/linux/vfio.h       |  41 +++++++++++++
> >  4 files changed, 295 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index c848262..d13b483 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/vfio.h>
> >  #include <linux/wait.h>
> >  #include <linux/sched/signal.h>
> > +#include <linux/sched/mm.h>
> >
> >  #define DRIVER_VERSION	"0.3"
> >  #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
> > @@ -46,6 +47,8 @@ static struct vfio {
> >  	struct mutex			group_lock;
> >  	struct cdev			group_cdev;
> >  	dev_t				group_devt;
> > +	struct list_head		vfio_mm_list;
> > +	struct mutex			vfio_mm_lock;
> >  	wait_queue_head_t		release_q;
> >  } vfio;
> >
> > @@ -2129,6 +2132,131 @@ int vfio_unregister_notifier(struct device *dev, enum
> vfio_notify_type type,
> >  EXPORT_SYMBOL(vfio_unregister_notifier);
> >
> >  /**
> > + * VFIO_MM objects - create, release, get, put, search
> > + * Caller of the function should have held vfio.vfio_mm_lock.
> > + */
> > +static struct vfio_mm *vfio_create_mm(struct mm_struct *mm)
> > +{
> > +	struct vfio_mm *vmm;
> > +	struct vfio_mm_token *token;
> > +	int ret = 0;
> > +
> > +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> > +	if (!vmm)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/* Per mm IOASID set used for quota control and group operations */
> > +	ret = ioasid_alloc_set((struct ioasid_set *) mm,
> 
> Hmm, either we need to change the token of ioasid_alloc_set() to "void *",
> or pass an actual ioasid_set struct, but this cast doesn't look good :)
>
> As I commented on the IOASID series, I think we could embed a struct
> ioasid_set into vfio_mm, pass that struct to all other ioasid_* functions,
> and get rid of ioasid_sid.

I think change to "void *" is better as we needs the token to ensure all
threads within a single VM share the same ioasid_set.

> > +			       VFIO_DEFAULT_PASID_QUOTA, &vmm->ioasid_sid);
> > +	if (ret) {
> > +		kfree(vmm);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	kref_init(&vmm->kref);
> > +	token = &vmm->token;
> > +	token->val = mm;
> 
> Why the intermediate token struct?  Could we just store the mm_struct
> pointer within vfio_mm?

Hmm, here we only want to use the pointer as a token, instead of using
the structure behind the pointer. If store the mm_struct directly, may
leave a space to further use its content, this is not good.

Regards,
Yi Liu

