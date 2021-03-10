Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350E333366B
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhCJHaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:30:22 -0500
Received: from verein.lst.de ([213.95.11.211]:34908 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232239AbhCJHaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:30:04 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1104B68C4E; Wed, 10 Mar 2021 08:30:02 +0100 (CET)
Date:   Wed, 10 Mar 2021 08:30:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 04/10] vfio/fsl-mc: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210310073001.GD2659@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <4-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +	ret = vfio_register_group_dev(&vdev->vdev);
>  	if (ret) {
>  		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
> -		goto out_group_put;
> +		goto out_kfree;
>  	}
> +	dev_set_drvdata(dev, vdev);
>  
> +	/*
> +	 * FIXME: vfio_register_group_dev() allows VFIO_GROUP_GET_DEVICE_FD to
> +	 * immediately return the device to userspace, but we haven't finished
> +	 * setting it up yet.
> +	 */

This should be trivial to fix.  Can you throw in a patch to move the
vfio_register_group_dev later?
