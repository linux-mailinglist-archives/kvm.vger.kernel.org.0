Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6537B39320B
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbhE0PPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 11:15:02 -0400
Received: from verein.lst.de ([213.95.11.211]:39565 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236932AbhE0POw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 11:14:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5DEF36736F; Thu, 27 May 2021 17:13:14 +0200 (CEST)
Date:   Thu, 27 May 2021 17:13:13 +0200
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
        Tarun Gupta <targupta@nvidia.com>, dave.jiang@intel.com
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to
 specify the device driver to bind
Message-ID: <20210527151313.GA2733@lst.de>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <20210428060300.GA4092@lst.de> <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com> <20210428124153.GA28566@lst.de> <20210428140005.GS1370958@nvidia.com> <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com> <20210526004230.GA3563025@nvidia.com> <20210527114452.GB18214@lst.de> <20210527145342.GE1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527145342.GE1002214@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 11:53:42AM -0300, Jason Gunthorpe wrote:
> > This looks great.  Please get it out to Greg ASAP!
> 
> Thanks, I need to test it all carefully it is pretty tricky. You are
> OK with the funky in/out flag? That was the most ick part

It is a little ugly, but what are the alternatives?  Would an input
flag to never return EPROBE_DEFER work instead?
