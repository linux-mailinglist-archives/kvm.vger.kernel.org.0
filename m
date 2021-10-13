Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6404142C74C
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 19:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbhJMRKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 13:10:54 -0400
Received: from verein.lst.de ([213.95.11.211]:46686 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhJMRKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 13:10:53 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 70E7868B05; Wed, 13 Oct 2021 19:08:47 +0200 (CEST)
Date:   Wed, 13 Oct 2021 19:08:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Message-ID: <20211013170847.GA2954@lst.de>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com> <5-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +/* returns true if the get was obtained */
> +static bool vfio_group_try_get(struct vfio_group *group)
>  {
> +	return refcount_inc_not_zero(&group->users);
>  }

Do we even need this helper?  Just open coding the refcount_inc_not_zero
would seem easier to read to me, and there is just a single caller
anyway.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
