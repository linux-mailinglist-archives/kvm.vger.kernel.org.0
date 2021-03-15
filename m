Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9CA33ADDA
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 09:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhCOIrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 04:47:07 -0400
Received: from verein.lst.de ([213.95.11.211]:52922 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhCOIqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 04:46:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1039668C4E; Mon, 15 Mar 2021 09:46:38 +0100 (CET)
Date:   Mon, 15 Mar 2021 09:46:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Message-ID: <20210315084637.GD29269@lst.de>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com> <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 08:56:00PM -0400, Jason Gunthorpe wrote:
> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
> 
> For instance vfio_pci_reflck_attach() sets vdev->reflck and
> vfio_pci_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.
> 
> Fixes: cc20d7999000 ("vfio/pci: Introduce VF token")
> Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> Fixes: 6eb7018705de ("vfio-pci: Move idle devices to D3hot power state")
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
