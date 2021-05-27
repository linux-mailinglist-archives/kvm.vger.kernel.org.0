Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7AE392D00
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhE0Lqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 07:46:31 -0400
Received: from verein.lst.de ([213.95.11.211]:38478 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234259AbhE0Lq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 07:46:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DDCB268AFE; Thu, 27 May 2021 13:44:52 +0200 (CEST)
Date:   Thu, 27 May 2021 13:44:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>, dave.jiang@intel.com
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to
 specify the device driver to bind
Message-ID: <20210527114452.GB18214@lst.de>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <20210428060300.GA4092@lst.de> <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com> <20210428124153.GA28566@lst.de> <20210428140005.GS1370958@nvidia.com> <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com> <20210526004230.GA3563025@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526004230.GA3563025@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 09:42:30PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 28, 2021 at 12:58:29PM -0700, Dan Williams wrote:
> 
> > I have an ulterior motive / additional use case in mind here which is
> > the work-in-progress cleanup of the DSA driver. 
> 
> Well, I worked on it for a while, please take a look at this:
> 
> https://github.com/jgunthorpe/linux/commits/device_driver_attach
> 
> It makes device_driver_attach() into what this mdev stuff needs, and I
> think improves the sysfs bind file as a side effect.

This looks great.  Please get it out to Greg ASAP!
