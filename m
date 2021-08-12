Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73B3E9F6B
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 09:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhHLH0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 03:26:47 -0400
Received: from verein.lst.de ([213.95.11.211]:43227 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234586AbhHLH0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 03:26:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 754C267373; Thu, 12 Aug 2021 09:26:18 +0200 (CEST)
Date:   Thu, 12 Aug 2021 09:26:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/14] vfio: refactor noiommu group creation
Message-ID: <20210812072617.GA28507@lst.de>
References: <20210811151500.2744-1-hch@lst.de> <20210811151500.2744-6-hch@lst.de> <20210811160341.573a5b82.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811160341.573a5b82.alex.williamson@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 04:03:41PM -0600, Alex Williamson wrote:
> > +			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
> > +			return vfio_noiommu_group_alloc(dev);
> 
> Nit, we taint regardless of the success of this function, should we
> move the tainting back into the function (using the flags to skip for
> mdev in subsequent patches) or swap the order to check the return value
> before tainting?  Thanks,

Does it really matter to have the extra thread if a memory allocation
failed when going down this route?
