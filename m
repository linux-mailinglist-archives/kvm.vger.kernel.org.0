Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E151E2F1E
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 21:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391034AbgEZTeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 15:34:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:57751 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389491AbgEZSz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 14:55:27 -0400
IronPort-SDR: Vwz34E6wMnBKBOp0E6pFixQhKiLID71F5l6yT9VZJeLl2+Em+q0bGqGL5Ik5GOk+CN6EhTp2wC
 fPdZJw+JoO3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 11:55:25 -0700
IronPort-SDR: LM8Rw2civZIYcAzaibIqLsIxMtiExBEGRfS9EcMikWRkbrKkBBVxqfVFXBc89l2TIM4QIyNZcU
 Pa09HC0Hu5KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="468453839"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.45.66])
  by fmsmga006.fm.intel.com with ESMTP; 26 May 2020 11:55:24 -0700
Date:   Tue, 26 May 2020 20:55:22 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: Re: [Sound-open-firmware] [PATCH 5/6] vhost: add an rpmsg API
Message-ID: <20200526185522.GA6992@ubuntu>
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
 <20200516101109.2624-6-guennadi.liakhovetski@linux.intel.com>
 <9737e3f2-e59c-0174-9254-a2d8f29f30b7@linux.intel.com>
 <20200525135336.GB6761@ubuntu>
 <59029e07-f49b-8d1a-4eb4-2f6d5775cf54@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59029e07-f49b-8d1a-4eb4-2f6d5775cf54@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Pierre,

On Tue, May 26, 2020 at 01:30:24PM -0500, Pierre-Louis Bossart wrote:
> 
> 
> On 5/25/20 8:53 AM, Guennadi Liakhovetski wrote:
> > Hi Pierre,
> > 
> > On Sat, May 16, 2020 at 12:00:35PM -0500, Pierre-Louis Bossart wrote:
> > > 
> > > > +config VHOST_RPMSG
> > > > +	tristate
> > > > +	depends on VHOST
> > > 
> > > depends on RPMSG_VIRTIO?
> > 
> > No, RPMSG_VIRTIO is used on the guest side, VHOST_RPMSG (as well as
> > all other vhost drivers) on the host side.
> 
> I vaguely recalled something about sockets, and was wondering if there isn't
> a dependency on this:
> 
> config VHOST_VSOCK
> 	tristate "vhost virtio-vsock driver"
> 	depends on VSOCKETS && EVENTFD && VHOST_DPN
> 	select VHOST

You probably are thinking about the first patch in the series "vhost: convert 
VHOST_VSOCK_SET_RUNNING to a generic ioctl." But no, this RPMsg driver 
doesn't depend on vsock, on the contrary, it takes a (albeit tiny) piece of 
functionality from vsock and makes it global.

Thanks
Guennadi
