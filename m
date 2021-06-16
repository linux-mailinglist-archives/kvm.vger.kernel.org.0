Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239913A92DE
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 08:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhFPGm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 02:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231856AbhFPGlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 02:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3476061107;
        Wed, 16 Jun 2021 06:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623825585;
        bh=EaiCM4M1HV/P3rmM6VEHDeHmAfCx+R4BQyVTxflK9Rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epaxgNqHuYyJv4EAYE7ldLg69Mxe1hHr3+3rsbNb30tg0BFhlw89SENvOIoieBf33
         HrKpn2jASbD8+ltQq/PkXuqainx2eVE7VIqE0yaDtRGv8wkEGBTI5LfsFDoT7cZ3tm
         FQktllr0bRzKCGZXXqa4iSepc5k04YuH8udl+DhY=
Date:   Wed, 16 Jun 2021 08:39:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 07/10] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <YMmcrbgzPByvQDrX@kroah.com>
References: <20210615133519.754763-1-hch@lst.de>
 <20210615133519.754763-8-hch@lst.de>
 <YMi1EcrhatlaH4AX@kroah.com>
 <20210616000040.GE1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616000040.GE1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 09:00:40PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 15, 2021 at 04:11:29PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jun 15, 2021 at 03:35:16PM +0200, Christoph Hellwig wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > 
> > > This allows a mdev driver to opt out of using vfio_mdev.c, instead the
> > > driver will provide a 'struct mdev_driver' and register directly with the
> > > driver core.
> > > 
> > > Much of mdev_parent_ops becomes unused in this mode:
> > > - create()/remove() are done via the mdev_driver probe()/remove()
> > > - mdev_attr_groups becomes mdev_driver driver.dev_groups
> > > - Wrapper function callbacks are replaced with the same ones from
> > >   struct vfio_device_ops
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Messy, but ok...
> 
> Is there something you'd like to see changed, eg in later patches?
> This whole work still has another approx 30 patches to go and much of
> this ends up being erased once the drivers are all converted.

If this mostly gets removed in the end, I'm happy.  Let's see how it
looks after all of that is done.  This is going forward in the right
way, so I do not object to this at all.

thanks,

greg k-h
