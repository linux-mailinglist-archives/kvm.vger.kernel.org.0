Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD2B40F185
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 07:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbhIQFHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 01:07:08 -0400
Received: from verein.lst.de ([213.95.11.211]:43548 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhIQFHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 01:07:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DB3CD67373; Fri, 17 Sep 2021 07:05:43 +0200 (CEST)
Date:   Fri, 17 Sep 2021 07:05:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20210917050543.GA22003@lst.de>
References: <20210913071606.2966-1-hch@lst.de> <20210913071606.2966-12-hch@lst.de> <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com> <20210916221854.GT3544071@ziepe.ca> <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 17, 2021 at 04:49:41AM +0000, Tian, Kevin wrote:
> > You just use the new style mdev API and directly call
> > vfio_register_group_dev and it will pick up the
> > parent->dev->iommu_group naturally like everything else using physical
> > iommu groups.
> > 
> 
> For above usage (wrap pdev into mdev), isn't the right way to directly add 
> vendor vfio-pci driver since vfio-pci-core has been split out now? It's not 
> necessary to fake a mdev just for adding some mediation in the r/w path...

Exactly.

> Another type of IOMMU-backed mdev is with pasid support. But for this
> case we discussed earlier that it doesn't have group and will follow the
> new /dev/iommu proposal instead.

Indeed.
