Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57383F755F
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhHYMvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:51:10 -0400
Received: from verein.lst.de ([213.95.11.211]:56094 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhHYMvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:51:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4D5366736F; Wed, 25 Aug 2021 14:50:22 +0200 (CEST)
Date:   Wed, 25 Aug 2021 14:50:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for
 mediated devices
Message-ID: <20210825125022.GA18232@lst.de>
References: <20210824144649.1488190-1-hch@lst.de> <20210824144649.1488190-8-hch@lst.de> <20210825001916.GN543798@ziepe.ca> <20210825053237.GB26806@lst.de> <20210825122144.GV543798@ziepe.ca> <20210825122400.GA16194@lst.de> <20210825123454.GW543798@ziepe.ca> <20210825123742.GA17251@lst.de> <20210825124538.GB1162709@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825124538.GB1162709@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 09:45:38AM -0300, Jason Gunthorpe wrote:
> I think so, in context of a group or iommu function it kind of makes
> sense emulated would refer to the page table/dma process
> 
> The driver entry point can have the extra words
>  vfio_register_emulated_dma_dev()

Not my preference, but I could live with it.  Or maybe emulated_iommu?
