Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8583F6ED4
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 07:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhHYFdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 01:33:25 -0400
Received: from verein.lst.de ([213.95.11.211]:54757 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231816AbhHYFdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 01:33:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B05FB6736F; Wed, 25 Aug 2021 07:32:37 +0200 (CEST)
Date:   Wed, 25 Aug 2021 07:32:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for
 mediated devices
Message-ID: <20210825053237.GB26806@lst.de>
References: <20210824144649.1488190-1-hch@lst.de> <20210824144649.1488190-8-hch@lst.de> <20210825001916.GN543798@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825001916.GN543798@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 09:19:16PM -0300, Jason Gunthorpe wrote:
> The mechanism looks fine, but I think the core code is much clearer if
> the name is not 'mediated' but 'sw_iommu' or something that implies
> the group is running with a software page table. mediated has become
> so overloaded in this code.

I thought that was sort of the definition of mediated - there needs to
ben entify that "mediates" access so that a user of this interface
can't trigger undmediated DMA to arbitrary addresses.  My other choice
that I used for a while was "virtual".  sw_iommu sounds a little clumsy.

I guess either way we need some documentation describing it along the
above lines.
