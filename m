Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BCB7D025
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 23:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbfGaVdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 17:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728928AbfGaVdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 17:33:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B44F630872C2;
        Wed, 31 Jul 2019 21:33:30 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CE355D9C9;
        Wed, 31 Jul 2019 21:33:28 +0000 (UTC)
Date:   Wed, 31 Jul 2019 15:33:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: re-arrange vfio region definitions
Message-ID: <20190731153327.7d65b90d@x1.home>
In-Reply-To: <05e97697-70a3-51dd-dd2a-4a8bf6c380bb@redhat.com>
References: <20190717114956.16263-1-cohuck@redhat.com>
        <05e97697-70a3-51dd-dd2a-4a8bf6c380bb@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 31 Jul 2019 21:33:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Jul 2019 20:47:07 +0200
Auger Eric <eric.auger@redhat.com> wrote:

> Hi Connie,
> 
> On 7/17/19 1:49 PM, Cornelia Huck wrote:
> > It is easy to miss already defined region types. Let's re-arrange
> > the definitions a bit and add more comments to make it hopefully
> > a bit clearer.
> > 
> > No functional change.
> > 
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> >  include/uapi/linux/vfio.h | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 8f10748dac79..d9bcf40240be 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -295,15 +295,23 @@ struct vfio_region_info_cap_type {
> >  	__u32 subtype;	/* type specific */
> >  };
> >  
> > +/*
> > + * List of region types, global per bus driver.
> > + * If you introduce a new type, please add it here.
> > + */
> > +
> > +/* PCI region type containing a PCI vendor part */
> >  #define VFIO_REGION_TYPE_PCI_VENDOR_TYPE	(1 << 31)
> >  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
> > +#define VFIO_REGION_TYPE_GFX                    (1)
> > +#define VFIO_REGION_TYPE_CCW			(2)
> >  
> > -/* 8086 Vendor sub-types */
> > +/* 8086 vendor PCI sub-types */
> >  #define VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION	(1)
> >  #define VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG	(2)
> >  #define VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG	(3)
> >  
> > -#define VFIO_REGION_TYPE_GFX                    (1)
> > +/* GFX sub-types */
> >  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
> >  
> >  /**
> > @@ -353,20 +361,17 @@ struct vfio_region_gfx_edid {
> >  #define VFIO_DEVICE_GFX_LINK_STATE_DOWN  2
> >  };
> >  
> > -#define VFIO_REGION_TYPE_CCW			(2)
> >  /* ccw sub-types */
> >  #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
> >  
> > +/* 10de vendor PCI sub-types */
> >  /*
> > - * 10de vendor sub-type
> > - *
> >   * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
> >   */
> >  #define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
> >  
> > +/* 1014 vendor PCI sub-types*/
> >  /*
> > - * 1014 vendor sub-type  
> Maybe the 10de vendor sub-type and 1014 vendor sub-type could be put
> just after /* 8086 vendor PCI sub-types */
> 
> More generally if it were possible to leave the subtypes close to their
> parent type too, this would be beneficial I think.
> 
> Besides that becomes sensible to put all those definitions together.

Any sort of consolidation or grouping is an improvement here, thanks
for taking this on, Connie!  I haven't started my branch yet for v5.4,
but if you want to iterate to something agreeable, I'll happily take
the end product :)  The original patch here looks like a good degree of
consolidating the type definitions and improving consistency without
moving large chunks of code.  Thanks,

Alex
