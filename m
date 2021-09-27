Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D836419396
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhI0LvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:51:09 -0400
Received: from verein.lst.de ([213.95.11.211]:46375 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233983AbhI0LvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:51:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A297167373; Mon, 27 Sep 2021 13:49:28 +0200 (CEST)
Date:   Mon, 27 Sep 2021 13:49:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/15] vfio/iommu_type1: initialize pgsize_bitmap in
 ->open
Message-ID: <20210927114928.GA23909@lst.de>
References: <20210924155705.4258-1-hch@lst.de> <20210924155705.4258-14-hch@lst.de> <20210924174852.GZ3544071@ziepe.ca> <20210924123755.76041ee0.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924123755.76041ee0.alex.williamson@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 12:37:55PM -0600, Alex Williamson wrote:
> > > +	iommu->pgsize_bitmap = ULONG_MAX;  
> > 
> > I wonder if this needs the PAGE_MASK/SIZE stuff?
> > 
> >    iommu->pgsize_bitmap = ULONG_MASK & PAGE_MASK;
> > 
> > ?
> > 
> > vfio_update_pgsize_bitmap() goes to some trouble to avoid setting bits
> > below the CPU page size here
> 
> Yep, though PAGE_MASK should already be UL, so just PAGE_MASK itself
> should work.  The ULONG_MAX in the update function just allows us to
> detect sub-page, ex. if the IOMMU supports 2K we can expose 4K minimum,
> but we can't if the min IOMMU page is 64K.  Thanks,

Do you just want to update this or do you want a full resend of the
series?
