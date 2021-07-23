Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E73B3D3A3D
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 14:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhGWLse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 07:48:34 -0400
Received: from verein.lst.de ([213.95.11.211]:38351 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhGWLse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 07:48:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6277167373; Fri, 23 Jul 2021 14:29:03 +0200 (CEST)
Date:   Fri, 23 Jul 2021 14:29:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 06/14] vfio/fsl: Move to the device set
 infrastructure
Message-ID: <20210723122903.GA24436@lst.de>
References: <0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com> <6-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com> <20210723074435.GA2795@lst.de> <20210723122227.GR1117491@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723122227.GR1117491@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 23, 2021 at 09:22:27AM -0300, Jason Gunthorpe wrote:
> > But do we even need the else part?  Assingning &mc_dev->dev is
> > equivalent to the default per-device set anyway, isn't it?
> 
> Not quite, the default is this:
> 
>         if (!device->dev_set)
>                 vfio_assign_device_set(device, device);
> 
> Where 'device' is the vfio_device itself, the above is connecting to
> the struct fsl_mc_device.

Isn't there a 1:1 relation?
