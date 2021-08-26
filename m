Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A89B3F83B0
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 10:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbhHZIWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 04:22:50 -0400
Received: from verein.lst.de ([213.95.11.211]:58505 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240315AbhHZIWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 04:22:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3204567373; Thu, 26 Aug 2021 10:22:00 +0200 (CEST)
Date:   Thu, 26 Aug 2021 10:21:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Message-ID: <20210826082159.GA23444@lst.de>
References: <20210825161916.50393-1-hch@lst.de> <20210825161916.50393-2-hch@lst.de> <BN9PR11MB54333E1472046CD30F3EFE5C8CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54333E1472046CD30F3EFE5C8CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 01:40:00AM +0000, Tian, Kevin wrote:
> > group %d\n",
> >  			 iommu_group_id(iommu_group));
> >  		vfio_device_put(existing_device);
> > -		vfio_group_put(group);
> > +		vfio_iommu_group_put(iommu_group, device->dev);
> 
> semantics change? the removed line is about vfio_group instead of
> iommu_group.

> > -	/* Matches the get in vfio_register_group_dev() */
> > -	vfio_group_put(group);
> > +	vfio_iommu_group_put(group->iommu_group, device->dev);
> 
> ditto

Yes, rebase/merge error.
