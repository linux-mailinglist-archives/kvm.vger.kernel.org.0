Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC273468E7
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhCWTYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:24:03 -0400
Received: from verein.lst.de ([213.95.11.211]:33947 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhCWTXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:23:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 45E3268BEB; Tue, 23 Mar 2021 20:23:31 +0100 (CET)
Date:   Tue, 23 Mar 2021 20:23:30 +0100
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
Subject: Re: [PATCH 11/18] vfio/mdev: Add mdev/mtype_get_type_group_id()
Message-ID: <20210323192330.GI17735@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 02:55:28PM -0300, Jason Gunthorpe wrote:
> +/*
> + * Return the index in supported_type_groups that this mdev_device was created
> + * from.
> + */
> +unsigned int mdev_get_type_group_id(struct mdev_device *mdev)
> +{
> +	return mdev->type->type_group_id;
> +}
> +EXPORT_SYMBOL(mdev_get_type_group_id);
> +
> +/*
> + * Used in mdev_type_attribute sysfs functions to return the index in the
> + * supported_type_groups that the sysfs is called from.
> + */
> +unsigned int mtype_get_type_group_id(struct kobject *mtype_kobj)
> +{
> +	return container_of(mtype_kobj, struct mdev_type, kobj)->type_group_id;
> +}
> +EXPORT_SYMBOL(mtype_get_type_group_id);

The single field accessors are a little silly..

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
