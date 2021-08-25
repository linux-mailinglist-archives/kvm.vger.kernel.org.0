Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512643F753C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbhHYMnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:43:51 -0400
Received: from verein.lst.de ([213.95.11.211]:56069 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhHYMnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:43:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4A5396736F; Wed, 25 Aug 2021 14:43:03 +0200 (CEST)
Date:   Wed, 25 Aug 2021 14:43:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Message-ID: <20210825124303.GA17334@lst.de>
References: <20210824144649.1488190-1-hch@lst.de> <20210824144649.1488190-2-hch@lst.de> <20210824142508.3a72fe4a.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824142508.3a72fe4a.alex.williamson@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 02:25:08PM -0600, Alex Williamson wrote:
> I think this turns into the patch below on top of Yishai's
> vfio-pci-core series.  Please verify.  If you'd like something
> different, please post an update.  Thanks,

The change looks fine to me.  Does that mean you want me to rebase
on top of the above series?
