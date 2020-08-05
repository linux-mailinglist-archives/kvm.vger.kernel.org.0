Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAFB23CFDE
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgHET0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:26:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53987 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728748AbgHERO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2J9LJah/aWCk57IzVK6fx/wEiWGV1AN7ftTN0d7Z7L0=;
        b=c5feeV6isMViIGc3J1ZgfS21KWW2pTbSgL7fzaFO/Q8QFgQ/e6OGxG+qKfwjAM1zhXrKUr
        IEOzkJ5BBsoa7emHL6h+NgeRYuZ8WbUuayVnGlzrv2vnDpKZDfY6YXAMRSh+OyA2u070pl
        qTMl1ASZezCynPQdZ3l0ihcgzUfkVq8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Z9EQF295MG-1KhS46ZV88Q-1; Wed, 05 Aug 2020 07:34:12 -0400
X-MC-Unique: Z9EQF295MG-1KhS46ZV88Q-1
Received: by mail-wm1-f69.google.com with SMTP id q15so2605771wmj.6
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 04:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2J9LJah/aWCk57IzVK6fx/wEiWGV1AN7ftTN0d7Z7L0=;
        b=kPyv7+gjEKCnhj5+ZHetJqJHanJqgO8hPYR2WXwbUYJjHKSeu6jJkgei/1LHN+BAjP
         yAxOcLzN4nLGas9bxD9TxotLHPyim8UZJPzOa8BN8qGIuRYZkJCDxORd4/BDXao/iyyN
         bMYRrJQbDB0C6y9TsXUvBJ+8IuhwSkEyKmlj/J0TURE4frCu9SufytOcc9Ef8qfBqi+i
         vrquyHTYbPEwfcZKPmfI+guitkqZzkCGRb3ZAkJtvOgxzgkbzG6xxrd7FflgpVCES/mF
         gG3YHmwYSmO1e2jUzeGq6MasJHF6fmxH/X7gFADaaHjl5SZcD8YgsYQd9wwmsYwqP2c2
         uDLA==
X-Gm-Message-State: AOAM530nGAJ6oF5pkcFME5YnB8zPq71CyFpOPCthsLkrBA4ydXwJzJMN
        5rpRaKwl73bQ8AY5AiV3jIjTJfmnM3DPOvenrcfKm+tPUYsFKB5U+kZdF6w4Ief55lp4MkFMt9e
        HoGg9/AR8dAGZ
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr2721069wml.29.1596627251690;
        Wed, 05 Aug 2020 04:34:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUHoMIFdt/4QubWV9RKUWmzgFURf9uw07yiy0Uaimh1czYGUqufIiAYoZ9lh96it76IKA3Qg==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr2721038wml.29.1596627251392;
        Wed, 05 Aug 2020 04:34:11 -0700 (PDT)
Received: from redhat.com (bzq-79-178-123-8.red.bezeqint.net. [79.178.123.8])
        by smtp.gmail.com with ESMTPSA id c10sm2340858wro.84.2020.08.05.04.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 04:34:10 -0700 (PDT)
Date:   Wed, 5 Aug 2020 07:34:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        kvm@vger.kernel.org,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 0/4] Add a vhost RPMsg API
Message-ID: <20200805073253-mutt-send-email-mst@kernel.org>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200730120805-mutt-send-email-mst@kernel.org>
 <20200731054752.GA28005@ubuntu>
 <CANLsYkxuCf6yeoqJ-T2x3LHvr9+DuxFdcsxJPmrh9A4H8yNr3w@mail.gmail.com>
 <20200803164605-mutt-send-email-mst@kernel.org>
 <CANLsYkx9e=-2dU26Lx5JFrtrbV07Vtwsi3gFphxKW5QRiwqoHg@mail.gmail.com>
 <20200804100640-mutt-send-email-mst@kernel.org>
 <CANLsYkzqvev1es_J-FYaBv02jkGHZwpn2cNwZKamAsZ_D=QB7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkzqvev1es_J-FYaBv02jkGHZwpn2cNwZKamAsZ_D=QB7g@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 01:30:32PM -0600, Mathieu Poirier wrote:
> On Tue, 4 Aug 2020 at 08:07, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Aug 04, 2020 at 07:37:49AM -0600, Mathieu Poirier wrote:
> > > On Mon, 3 Aug 2020 at 14:47, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Aug 03, 2020 at 07:25:24AM -0600, Mathieu Poirier wrote:
> > > > > On Thu, 30 Jul 2020 at 23:47, Guennadi Liakhovetski
> > > > > <guennadi.liakhovetski@linux.intel.com> wrote:
> > > > > >
> > > > > > Hi Michael,
> > > > > >
> > > > > > On Thu, Jul 30, 2020 at 12:08:29PM -0400, Michael S. Tsirkin wrote:
> > > > > > > On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > Now that virtio-rpmsg endianness fixes have been merged we can
> > > > > > > > proceed with the next step.
> > > > > > >
> > > > > > > Which tree is this for?
> > > > > >
> > > > > > The essential part of this series is for drivers/vhost, so, I presume
> > > > > > that should be the target tree as well. There is however a small part
> > > > > > for the drivers/rpmsg, should I split this series in two or shall we
> > > > > > first review is as a whole to make its goals clearer?
> > > > >
> > > > > I suggest to keep it whole for now.
> > > >
> > > >
> > > > Ok can I get some acks please?
> > >
> > > Yes, as soon as I have the opportunity to review the work.  There is a
> > > lot of volume on the linux-remoteproc mailing list lately and
> > > patchsets are reviewed in the order they have been received.
> >
> > Well the merge window is open, I guess I'll merge this and
> > any issues can be addressed later then?
> 
> Please don't do that.  I prefer to miss a merge window than impacting
> upstream consumers.  This patch will be reviewed, just not in time for
> this merge window.

OK then.


> >
> > > > Also, I put this in my linux-next branch on
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
> > > >
> > > > there were some conflicts - could you pls test and report it's ok?
> > > >
> > > > > >
> > > > > > Thanks
> > > > > > Guennadi
> > > > > >
> > > > > > > > v4:
> > > > > > > > - add endianness conversions to comply with the VirtIO standard
> > > > > > > >
> > > > > > > > v3:
> > > > > > > > - address several checkpatch warnings
> > > > > > > > - address comments from Mathieu Poirier
> > > > > > > >
> > > > > > > > v2:
> > > > > > > > - update patch #5 with a correct vhost_dev_init() prototype
> > > > > > > > - drop patch #6 - it depends on a different patch, that is currently
> > > > > > > >   an RFC
> > > > > > > > - address comments from Pierre-Louis Bossart:
> > > > > > > >   * remove "default n" from Kconfig
> > > > > > > >
> > > > > > > > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > > > > > > > cases. It can however also be used for virtualisation scenarios,
> > > > > > > > e.g. when using KVM to run Linux on both the host and the guests.
> > > > > > > > This patch set adds a wrapper API to facilitate writing vhost
> > > > > > > > drivers for such RPMsg-based solutions. The first use case is an
> > > > > > > > audio DSP virtualisation project, currently under development, ready
> > > > > > > > for review and submission, available at
> > > > > > > > https://github.com/thesofproject/linux/pull/1501/commits
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > > Guennadi
> > > > > > > >
> > > > > > > > Guennadi Liakhovetski (4):
> > > > > > > >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> > > > > > > >   rpmsg: move common structures and defines to headers
> > > > > > > >   rpmsg: update documentation
> > > > > > > >   vhost: add an RPMsg API
> > > > > > > >
> > > > > > > >  Documentation/rpmsg.txt          |   6 +-
> > > > > > > >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> > > > > > > >  drivers/vhost/Kconfig            |   7 +
> > > > > > > >  drivers/vhost/Makefile           |   3 +
> > > > > > > >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> > > > > > > >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> > > > > > > >  include/linux/virtio_rpmsg.h     |  83 +++++++
> > > > > > > >  include/uapi/linux/rpmsg.h       |   3 +
> > > > > > > >  include/uapi/linux/vhost.h       |   4 +-
> > > > > > > >  9 files changed, 553 insertions(+), 80 deletions(-)
> > > > > > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > > > > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > > > > > >  create mode 100644 include/linux/virtio_rpmsg.h
> > > > > > > >
> > > > > > > > --
> > > > > > > > 2.27.0
> > > > > > >
> > > >
> >

