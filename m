Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB6F3468D5
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhCWTUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:20:46 -0400
Received: from verein.lst.de ([213.95.11.211]:33912 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231953AbhCWTUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:20:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8C7C568C65; Tue, 23 Mar 2021 20:20:40 +0100 (CET)
Date:   Tue, 23 Mar 2021 20:20:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Message-ID: <20210323192040.GF17735@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  	up_read(&parent->unreg_sem);
> -	put_device(&mdev->dev);
>  mdev_fail:
>
>
>
> -	mdev_put_parent(parent);
> +	put_device(&mdev->dev);

That mdev_fail label is not very descriptive, what about free_device
instead?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
