Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5C233EBE
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 07:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbgGaFr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 01:47:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:43594 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbgGaFr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 01:47:57 -0400
IronPort-SDR: GfinqARzCYAcKlQhy669qliiWt9aueHIWJ4UHfkdHNpRNMrcl/QnxuetuXdAPyPSE0X6FbXPRP
 FiyUDZMi0gQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149562587"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149562587"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 22:47:57 -0700
IronPort-SDR: hbcNTevyAWMt+2nnPf0zbJbC725StjdyYUxsO/paaJPrS2V3HrM5T3aO4C+q/0gLZWkZqpdNfy
 1PdHJnsVg+sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="287084802"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.60.109])
  by orsmga003.jf.intel.com with ESMTP; 30 Jul 2020 22:47:54 -0700
Date:   Fri, 31 Jul 2020 07:47:53 +0200
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
Message-ID: <20200731054752.GA28005@ubuntu>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200730120805-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730120805-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On Thu, Jul 30, 2020 at 12:08:29PM -0400, Michael S. Tsirkin wrote:
> On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > Hi,
> > 
> > Now that virtio-rpmsg endianness fixes have been merged we can 
> > proceed with the next step.
> 
> Which tree is this for?

The essential part of this series is for drivers/vhost, so, I presume 
that should be the target tree as well. There is however a small part 
for the drivers/rpmsg, should I split this series in two or shall we 
first review is as a whole to make its goals clearer?

Thanks
Guennadi

> > v4:
> > - add endianness conversions to comply with the VirtIO standard
> > 
> > v3:
> > - address several checkpatch warnings
> > - address comments from Mathieu Poirier
> > 
> > v2:
> > - update patch #5 with a correct vhost_dev_init() prototype
> > - drop patch #6 - it depends on a different patch, that is currently
> >   an RFC
> > - address comments from Pierre-Louis Bossart:
> >   * remove "default n" from Kconfig
> > 
> > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > cases. It can however also be used for virtualisation scenarios,
> > e.g. when using KVM to run Linux on both the host and the guests.
> > This patch set adds a wrapper API to facilitate writing vhost
> > drivers for such RPMsg-based solutions. The first use case is an
> > audio DSP virtualisation project, currently under development, ready
> > for review and submission, available at
> > https://github.com/thesofproject/linux/pull/1501/commits
> > 
> > Thanks
> > Guennadi
> > 
> > Guennadi Liakhovetski (4):
> >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> >   rpmsg: move common structures and defines to headers
> >   rpmsg: update documentation
> >   vhost: add an RPMsg API
> > 
> >  Documentation/rpmsg.txt          |   6 +-
> >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> >  drivers/vhost/Kconfig            |   7 +
> >  drivers/vhost/Makefile           |   3 +
> >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> >  include/linux/virtio_rpmsg.h     |  83 +++++++
> >  include/uapi/linux/rpmsg.h       |   3 +
> >  include/uapi/linux/vhost.h       |   4 +-
> >  9 files changed, 553 insertions(+), 80 deletions(-)
> >  create mode 100644 drivers/vhost/rpmsg.c
> >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> >  create mode 100644 include/linux/virtio_rpmsg.h
> > 
> > -- 
> > 2.27.0
> 
