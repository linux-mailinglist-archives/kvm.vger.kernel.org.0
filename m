Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9EA36D78D
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 14:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhD1Mmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 08:42:40 -0400
Received: from verein.lst.de ([213.95.11.211]:49100 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhD1Mmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 08:42:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A655C68BEB; Wed, 28 Apr 2021 14:41:53 +0200 (CEST)
Date:   Wed, 28 Apr 2021 14:41:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to
 specify the device driver to bind
Message-ID: <20210428124153.GA28566@lst.de>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <20210428060300.GA4092@lst.de> <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 12:56:21AM -0700, Dan Williams wrote:
> > I still think this going the wrong way.  Why can't we enhance the core
> > driver code with a version of device_bind_driver() that does call into
> > ->probe?  That probably seems like a better model for those existing
> > direct users of device_bind_driver or device_attach with a pre-set
> > ->drv anyway.
> 
> Wouldn't that just be "export device_driver_attach()" so that drivers
> can implement their own custom bind implementation?

That looks like it might be all that is needed.
