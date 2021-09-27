Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B961419572
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhI0Nz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 09:55:29 -0400
Received: from verein.lst.de ([213.95.11.211]:46846 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234589AbhI0Nz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 09:55:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 49FD567373; Mon, 27 Sep 2021 15:53:48 +0200 (CEST)
Date:   Mon, 27 Sep 2021 15:53:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/15] vfio/iommu_type1: initialize pgsize_bitmap in
 ->open
Message-ID: <20210927135348.GB757@lst.de>
References: <20210924155705.4258-1-hch@lst.de> <20210924155705.4258-14-hch@lst.de> <20210924174852.GZ3544071@ziepe.ca> <20210924123755.76041ee0.alex.williamson@redhat.com> <20210927114928.GA23909@lst.de> <20210927065637.696eb066.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927065637.696eb066.alex.williamson@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 06:56:37AM -0600, Alex Williamson wrote:
> > > Yep, though PAGE_MASK should already be UL, so just PAGE_MASK itself
> > > should work.  The ULONG_MAX in the update function just allows us to
> > > detect sub-page, ex. if the IOMMU supports 2K we can expose 4K minimum,
> > > but we can't if the min IOMMU page is 64K.  Thanks,  
> > 
> > Do you just want to update this or do you want a full resend of the
> > series?
> 
> So long as we have agreement, I can do it inline.  Are we doing
> s/ULONG_MAX/PAGE_MASK/ across both the diff and commit log?  Thanks,

Sounds good to me.
