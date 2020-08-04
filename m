Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA3F23BC8D
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 16:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgHDOqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 10:46:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:46126 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHDOqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 10:46:48 -0400
IronPort-SDR: +Cp4ycQKCgN1f2McA/e4L/6qewZYI4rTgTur/gZhlP+/JhcZHvxsqdOGNNwQE57O5cSOP2Z9j9
 l69stIBZQOOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="149766952"
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="149766952"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 07:46:46 -0700
IronPort-SDR: 5bWjSithPV0Oq0tMhji8wu4ZfDsDLYRZd1SyJ7g4vGMo0Svq57KyLV7M+fbzispGQ0uqn+fsqW
 Wa9dRXsFcJ4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="324677258"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.37.210])
  by fmsmga002.fm.intel.com with ESMTP; 04 Aug 2020 07:46:43 -0700
Date:   Tue, 4 Aug 2020 16:46:42 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 0/4] Add a vhost RPMsg API
Message-ID: <20200804144642.GB19025@ubuntu>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200804082250-mutt-send-email-mst@kernel.org>
 <20200804131918.GA19025@ubuntu>
 <20200804100747-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804100747-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 10:10:23AM -0400, Michael S. Tsirkin wrote:
> On Tue, Aug 04, 2020 at 03:19:19PM +0200, Guennadi Liakhovetski wrote:
> > Hi Michael,
> > 
> > On Tue, Aug 04, 2020 at 08:26:53AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > > > Hi,
> > > > 
> > > > Now that virtio-rpmsg endianness fixes have been merged we can 
> > > > proceed with the next step.
> > > 
> > > OK my attempts to resolve conflicts just created a mess.
> > 
> > You just need to apply my previous patch for virtio-rpmsg first 
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/rpmsg/virtio_rpmsg_bus.c?id=111d1089700cdb752681ef44f54ab6137736f5c2
> > Then this series should apply cleanly.
> > 
> > Thanks
> > Guennadi
> 
> Hmm.  Could you test the vhost branch in my tree, and tell me if that looks
> good to you?

Sorry, I'm not sure I understand why you're trying to resolve conflicts 
manually. My previous patch is already in "next," if you don't pull from 
"next" you will have a conflict when pushing to it. What am I missing?

Thanks
Guennadi

> > > I dropped these for now, could you pls rebase on top
> > > of linux-next branch in my tree, and repost?
> > > Thanks!
> > > 
> > > 
> > > > v4:
> > > > - add endianness conversions to comply with the VirtIO standard
> > > > 
> > > > v3:
> > > > - address several checkpatch warnings
> > > > - address comments from Mathieu Poirier
> > > > 
> > > > v2:
> > > > - update patch #5 with a correct vhost_dev_init() prototype
> > > > - drop patch #6 - it depends on a different patch, that is currently
> > > >   an RFC
> > > > - address comments from Pierre-Louis Bossart:
> > > >   * remove "default n" from Kconfig
> > > > 
> > > > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > > > cases. It can however also be used for virtualisation scenarios,
> > > > e.g. when using KVM to run Linux on both the host and the guests.
> > > > This patch set adds a wrapper API to facilitate writing vhost
> > > > drivers for such RPMsg-based solutions. The first use case is an
> > > > audio DSP virtualisation project, currently under development, ready
> > > > for review and submission, available at
> > > > https://github.com/thesofproject/linux/pull/1501/commits
> > > > 
> > > > Thanks
> > > > Guennadi
> > > > 
> > > > Guennadi Liakhovetski (4):
> > > >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> > > >   rpmsg: move common structures and defines to headers
> > > >   rpmsg: update documentation
> > > >   vhost: add an RPMsg API
> > > > 
> > > >  Documentation/rpmsg.txt          |   6 +-
> > > >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> > > >  drivers/vhost/Kconfig            |   7 +
> > > >  drivers/vhost/Makefile           |   3 +
> > > >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> > > >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> > > >  include/linux/virtio_rpmsg.h     |  83 +++++++
> > > >  include/uapi/linux/rpmsg.h       |   3 +
> > > >  include/uapi/linux/vhost.h       |   4 +-
> > > >  9 files changed, 553 insertions(+), 80 deletions(-)
> > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > >  create mode 100644 include/linux/virtio_rpmsg.h
> > > > 
> > > > -- 
> > > > 2.27.0
> > > 
> 
