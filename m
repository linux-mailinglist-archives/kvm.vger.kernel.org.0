Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E899E36B4C2
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhDZOUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:20:55 -0400
Received: from verein.lst.de ([213.95.11.211]:41474 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233752AbhDZOUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:20:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C117968C4E; Mon, 26 Apr 2021 16:20:11 +0200 (CEST)
Date:   Mon, 26 Apr 2021 16:20:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 11/12] vfio/mdev: Use the driver core to create the
 'remove' file
Message-ID: <20210426142011.GI15209@lst.de>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com> <11-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 5a3873d1a275ae..0ccfeb3dda2455 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -244,11 +244,20 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>  
>  static DEVICE_ATTR_WO(remove);
>  
> -static const struct attribute *mdev_device_attrs[] = {
> +static struct attribute *mdev_device_attrs[] = {

Why does this lose the const?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
