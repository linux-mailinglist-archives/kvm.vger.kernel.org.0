Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC9F40A621
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 07:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbhINFrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 01:47:39 -0400
Received: from verein.lst.de ([213.95.11.211]:58495 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239689AbhINFri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 01:47:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 45F3E67357; Tue, 14 Sep 2021 07:46:18 +0200 (CEST)
Date:   Tue, 14 Sep 2021 07:46:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Message-ID: <20210914054618.GB26026@lst.de>
References: <20210913071606.2966-1-hch@lst.de> <20210913071606.2966-2-hch@lst.de> <BN9PR11MB5433CB67B7E36821E0F1716F8CDA9@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433CB67B7E36821E0F1716F8CDA9@BN9PR11MB5433.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 01:57:55AM +0000, Tian, Kevin wrote:
> > Since the drivers never use the group move this all into the core code.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I gave my reviewed-by in last version. Looks it's lost here.

There were a few changes, so I'd prefer everyone to re-review it
carefully.
