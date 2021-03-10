Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9233366C
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCJHb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:31:26 -0500
Received: from verein.lst.de ([213.95.11.211]:34909 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhCJHbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:31:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 054B868BFE; Wed, 10 Mar 2021 08:31:16 +0100 (CET)
Date:   Wed, 10 Mar 2021 08:31:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 05/10] vfio/pci: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210310073115.GE2659@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <5-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> +	/*
> +	 * FIXME: vfio_register_group_dev() allows VFIO_GROUP_GET_DEVICE_FD to
> +	 * immediately return the device to userspace, but we haven't finished
> +	 * setting it up yet.
> +	 */
> +	ret = vfio_register_group_dev(&vdev->vdev);

Again, why not include a patch in the series to fix this up as well?

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
