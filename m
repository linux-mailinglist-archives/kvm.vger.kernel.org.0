Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1563F6EDA
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 07:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhHYFgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 01:36:36 -0400
Received: from verein.lst.de ([213.95.11.211]:54768 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232427AbhHYFge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 01:36:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7E4426736F; Wed, 25 Aug 2021 07:35:47 +0200 (CEST)
Date:   Wed, 25 Aug 2021 07:35:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Message-ID: <20210825053547.GD26806@lst.de>
References: <20210824144649.1488190-1-hch@lst.de> <20210824144649.1488190-14-hch@lst.de> <20210825003629.GT543798@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825003629.GT543798@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 09:36:29PM -0300, Jason Gunthorpe wrote:
> > +	/*
> > +	 * Tracks the fake iommu groups created by vfio to support mediated
> > +	 * devices.  These are not backed by an actual IOMMU.
> > +	 */
> > +	struct list_head	mediated_groups;
> 
> Though again I'd prefer another name to mediated here.. These are
> domainless groups?

I think they should use whatever named we use for/instead of the mediated
groups as these are the same concept.  Using an unrelated name like
external did causes major confusion.
