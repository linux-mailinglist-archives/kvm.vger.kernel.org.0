Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED4B345F75
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhCWNSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:18:18 -0400
Received: from verein.lst.de ([213.95.11.211]:60542 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231838AbhCWNRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 09:17:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5642568C4E; Tue, 23 Mar 2021 14:17:09 +0100 (CET)
Date:   Tue, 23 Mar 2021 14:17:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210323131709.GA1982@lst.de>
References: <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com> <20210319092341.14bb179a@omen.home.shazbot.org> <20210319161722.GY2356281@nvidia.com> <20210319162033.GA18218@lst.de> <20210319162848.GZ2356281@nvidia.com> <20210319163449.GA19186@lst.de> <20210319113642.4a9b0be1@omen.home.shazbot.org> <20210319200749.GB2356281@nvidia.com> <20210322151125.GA1051@lst.de> <20210322164411.GV2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322164411.GV2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 01:44:11PM -0300, Jason Gunthorpe wrote:
> This isn't quite the scenario that needs solving. Lets go back to
> Max's V1 posting:
> 
> The mlx5_vfio_pci.c pci_driver matches this:
> 
> +	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1042,
> +			 PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID) }, /* Virtio SNAP controllers */
> 
> This overlaps with the match table in
> drivers/virtio/virtio_pci_common.c:
> 
>         { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> 
> So, if we do as you propose we have to add something mellanox specific
> to virtio_pci_common which seems to me to just repeating this whole
> problem except in more drivers.

Oh, yikes.  

> The general thing that that is happening is people are adding VM
> migration capability to existing standard PCI interfaces like VFIO,
> NVMe, etc

Well, if a migration capability is added to virtio (or NVMe) it should
be standardized and not vendor specific.
