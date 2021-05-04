Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CA0372821
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 11:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhEDJhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 05:37:50 -0400
Received: from verein.lst.de ([213.95.11.211]:38734 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229883AbhEDJhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 05:37:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C31C468AFE; Tue,  4 May 2021 11:36:36 +0200 (CEST)
Date:   Tue, 4 May 2021 11:36:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20210504093636.GA24834@lst.de>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <20210428060300.GA4092@lst.de> <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com> <20210428124153.GA28566@lst.de> <20210428140005.GS1370958@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428140005.GS1370958@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 11:00:05AM -0300, Jason Gunthorpe wrote:
> I thought about doing it like that, it is generally a good idea,
> however, if I add new API surface to the driver core I really want to
> get rid of device_bind_driver(), or at least most of its users.
> 
> I'm pretty sure Greg will ask for it too.
> 
> So, I need a way to sequence that which doesn't mean I have to shelf
> the mdev stuff for ages while I try to get acks from lots of places.
> 
> Leave this alone and fix it after? Export device_driver_attach() and
> say to try and fix the rest after?

Maybe.  Or convert one or two samples.

> I think this will still need the ugly errno capture though..

Why?
