Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDFE3F941F
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 07:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhH0Fm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 01:42:59 -0400
Received: from verein.lst.de ([213.95.11.211]:32853 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhH0Fm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 01:42:59 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C46696736F; Fri, 27 Aug 2021 07:42:07 +0200 (CEST)
Date:   Fri, 27 Aug 2021 07:42:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for
 mediated devices
Message-ID: <20210827054207.GA21797@lst.de>
References: <20210826133424.3362-1-hch@lst.de> <20210826133424.3362-8-hch@lst.de> <20210826165921.3736f766.alex.williamson@redhat.com> <BN9PR11MB5433CB3FD43C0891E15E20928CC89@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433CB3FD43C0891E15E20928CC89@BN9PR11MB5433.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 02:17:14AM +0000, Tian, Kevin wrote:
> > flags suggests to me a bit field, but we can't have EMULATED|NOIOMMU.
> > Should this be an enum iommu_type?
> > 
> 
> and I wonder whether we should also define a type (VFIO_IOMMU)
> for the remaining groups which are backed by IOMMU. This can be
> set implicitly when the caller doesn't specify a specific type when
> creating the group. It's not checked in any place now, but it might
> be helpful for readability and diagnostic purpose? or change the
> name to noiommu_flags then no confusion on its scope...

If we move to a type field we should definitively define a value for
the normal case as well.  The advantage of the flags is that we can
also use it for other needs it it arises.  An emum OTOH would be
easier to follow.
