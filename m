Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CED3A8F3A
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 05:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhFPDPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 23:15:25 -0400
Received: from verein.lst.de ([213.95.11.211]:52116 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFPDPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 23:15:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3993968AFE; Wed, 16 Jun 2021 05:13:14 +0200 (CEST)
Date:   Wed, 16 Jun 2021 05:13:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: Allow mdev drivers to directly create the vfio_device (v3)
Message-ID: <20210616031313.GA24992@lst.de>
References: <20210615133519.754763-1-hch@lst.de> <20210615133549.362e5a9e.alex.williamson@redhat.com> <20210615203515.GW1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615203515.GW1002214@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 05:35:15PM -0300, Jason Gunthorpe wrote:
> Yes, the rest of the drivers will get converted eventually too. There
> is no reason to hold things back. Depending on timelines we might be
> able to get AP into this cycle too...

And I have a WIP tree to get rid of the weird indirections in i915/gvt.
Once I find some cycles to test that I'll also test the vfio interface
conversion.  This will probably be for next cycle, though.
