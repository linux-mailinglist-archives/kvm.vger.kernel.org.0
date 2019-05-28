Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22792BE27
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 06:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfE1ESe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 00:18:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbfE1ESe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 00:18:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 533EBC049E23;
        Tue, 28 May 2019 04:18:34 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A0A31001DD7;
        Tue, 28 May 2019 04:18:31 +0000 (UTC)
Date:   Mon, 27 May 2019 22:18:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Zhang, Tina" <tina.zhang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: Re: [PATCH 1/2] vfio: ABI for setting mdev display flip eventfd
Message-ID: <20190527221831.71bddcc5@x1.home>
In-Reply-To: <237F54289DF84E4997F34151298ABEBC87620FF2@SHSMSX101.ccr.corp.intel.com>
References: <20190527084312.8872-1-tina.zhang@intel.com>
        <20190527084312.8872-2-tina.zhang@intel.com>
        <20190527080430.28f40888@x1.home>
        <237F54289DF84E4997F34151298ABEBC87620FF2@SHSMSX101.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 28 May 2019 04:18:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 01:42:57 +0000
"Zhang, Tina" <tina.zhang@intel.com> wrote:

> > -----Original Message-----
> > From: intel-gvt-dev [mailto:intel-gvt-dev-bounces@lists.freedesktop.org] On
> > Behalf Of Alex Williamson
> > Sent: Monday, May 27, 2019 10:05 PM
> > To: Zhang, Tina <tina.zhang@intel.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > zhenyuw@linux.intel.com; Yuan, Hang <hang.yuan@intel.com>;
> > kraxel@redhat.com; intel-gvt-dev@lists.freedesktop.org; Lv, Zhiyuan
> > <zhiyuan.lv@intel.com>
> > Subject: Re: [PATCH 1/2] vfio: ABI for setting mdev display flip eventfd
> > 
> > On Mon, 27 May 2019 16:43:11 +0800
> > Tina Zhang <tina.zhang@intel.com> wrote:
> >   
> > > Add VFIO_DEVICE_SET_GFX_FLIP_EVENTFD ioctl command to set eventfd
> > > based signaling mechanism to deliver vGPU framebuffer page flip event
> > > to userspace.
> > >
> > > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > > ---
> > >  include/uapi/linux/vfio.h | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 02bb7ad6e986..27300597717f 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -696,6 +696,18 @@ struct vfio_device_ioeventfd {
> > >
> > >  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE +  
> > 16)  
> > >
> > > +/**
> > > + * VFIO_DEVICE_SET_GFX_FLIP_EVENTFD - _IOW(VFIO_TYPE, VFIO_BASE  
> > + 17,  
> > > +__s32)
> > > + *
> > > + * Set eventfd based signaling mechanism to deliver vGPU framebuffer
> > > +page
> > > + * flip event to userspace. A value of -1 is used to stop the page
> > > +flip
> > > + * delivering.
> > > + *
> > > + * Return: 0 on success, -errno on failure.
> > > + */
> > > +
> > > +#define VFIO_DEVICE_SET_GFX_FLIP_EVENTFD _IO(VFIO_TYPE,  
> > VFIO_BASE +  
> > > +17)
> > > +
> > >  /* -------- API for Type1 VFIO IOMMU -------- */
> > >
> > >  /**  
> > 
> > Why can't we use VFIO_DEVICE_SET_IRQS for this?  We can add a capability
> > to vfio_irq_info in the same way that we did for regions to describe device
> > specific IRQ support.  Thanks,  
> Add a new kind of index, like this?
> enum {
>         VFIO_PCI_INTX_IRQ_INDEX,
>         VFIO_PCI_MSI_IRQ_INDEX,
>         VFIO_PCI_MSIX_IRQ_INDEX,
>         VFIO_PCI_ERR_IRQ_INDEX,
>         VFIO_PCI_REQ_IRQ_INDEX,
> +      VFIO_PCI_GFX_FLIP_EVENT_INDEX,
>         VFIO_PCI_NUM_IRQS
> };
> Perhaps this is what we don't want. This
> VFIO_PCI_GFX_FLIP_EVENT_INDEX is specific to graphics card and it's
> actually an event which is reported by INTX/MSI/ MSIX IRQ. Thanks.

Right, that is not what I'm suggesting.  What I'm looking for is a
similar conversion to what we did for regions, where we extended the
data returned in GET_REGION_INFO to include capabilities
(c84982adb23b), capped the number of regions we define with fixed
indexes (c7bb4cb40f89), and added device specific regions, such as IGD
OpRegion (5846ff54e87d) and IGD host and LPC bridges (f572a960a15e).
The same thing should happen here, the current value of
VFIO_PCI_NUM_IRQS becomes fixed and part of the vfio-pci ABI,
vfio_irq_info is extended with capability support following the same
mechanism, headers, and helpers we use for regions, then the mdev device
simply exposes the extended (and backwards compatible) API without
requiring a device specific ioctl.  Thanks,

Alex
