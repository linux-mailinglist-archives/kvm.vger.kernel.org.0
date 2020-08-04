Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A49223BB3C
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgHDNjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 09:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHDNiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 09:38:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0CEC061756
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 06:38:03 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u126so4905705iod.12
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 06:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8TQqvSOaTS+0vq0FcJG3YYGmNhVX2Wzyl+oJVhl1vEo=;
        b=cajUMW2EsmphVUl7tBq74ozfCLO9LuJOMnMxkAow2Q3C+oJA3QqFfFzOJL0V0CyuD2
         5Q60aaKn7lCJWyK7yXIfFzYY1WEndw1H46/gMGF4OmK3mNUxvb79DXQjcl6ufYyG+PBB
         2519caukgL8i1eK9OV1uJmcdLchteQZ+CwVxhjxz9uT8MU0y3vEVvleKEQez92xWaAOr
         GbXSXpC2Gl1I/o7uwLMspfxiMK6eCCgHnEu6ecSpei7vcfO5L7lRpnRbtLw7jNNqC9YE
         TrF1b4ZMaJ4AcxD5gGPMnc0W8Dfddh8dOub4Y5Pc/OhfehPTm5A2NeuJvrdBsvvfOOXV
         Webw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8TQqvSOaTS+0vq0FcJG3YYGmNhVX2Wzyl+oJVhl1vEo=;
        b=WsRfWzTBIAcRZ12ilabIBVCSzAApBRB4rRVt304eu4tj3lBXmOw61pckimTc5rv7NH
         K8PfnRjWKO78R5uobw2BlRkvAF4workY2IwXDDlq6otCO/22dgMIdEmMALf/srAbpM2j
         uB5/DF1zlgk3UgCpxoQy3Nh04EXXBebW/EejOKbmtH7BegpeM5AdwyOKiS+nNIMZuxeB
         Xp0xJkhKS3iz9gniEMwM2/uwICkNY89MwqJ9CtTuiDSZ7XqoYg+mik5AOKmeeqNEBz3T
         xzcfDGvEucyO+xdJCPXbOvVTubPP/v81X47bO7rfwa5f5FQXrR1t/xKoxoz8uUPo+0Ax
         bifg==
X-Gm-Message-State: AOAM532+wJbDDqaNtRz2JRaaKu+NwsHgEPqXfhDfjA+pf9sY//pXsri8
        D+c3qWWAeC2escCCv2q1JrOSreLQLYquSvqESMoXCw==
X-Google-Smtp-Source: ABdhPJyYJuAsPneR8NkGVpYThr7lt6UB+gAEYTcQUi82+DHwz0ACAAmEDzKodQF0dQ83Ow9jFNpHytgHugvozejgwQc=
X-Received: by 2002:a5d:848d:: with SMTP id t13mr5273506iom.73.1596548280306;
 Tue, 04 Aug 2020 06:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200730120805-mutt-send-email-mst@kernel.org> <20200731054752.GA28005@ubuntu>
 <CANLsYkxuCf6yeoqJ-T2x3LHvr9+DuxFdcsxJPmrh9A4H8yNr3w@mail.gmail.com> <20200803164605-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200803164605-mutt-send-email-mst@kernel.org>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Tue, 4 Aug 2020 07:37:49 -0600
Message-ID: <CANLsYkx9e=-2dU26Lx5JFrtrbV07Vtwsi3gFphxKW5QRiwqoHg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Add a vhost RPMsg API
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Aug 2020 at 14:47, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Aug 03, 2020 at 07:25:24AM -0600, Mathieu Poirier wrote:
> > On Thu, 30 Jul 2020 at 23:47, Guennadi Liakhovetski
> > <guennadi.liakhovetski@linux.intel.com> wrote:
> > >
> > > Hi Michael,
> > >
> > > On Thu, Jul 30, 2020 at 12:08:29PM -0400, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > > > > Hi,
> > > > >
> > > > > Now that virtio-rpmsg endianness fixes have been merged we can
> > > > > proceed with the next step.
> > > >
> > > > Which tree is this for?
> > >
> > > The essential part of this series is for drivers/vhost, so, I presume
> > > that should be the target tree as well. There is however a small part
> > > for the drivers/rpmsg, should I split this series in two or shall we
> > > first review is as a whole to make its goals clearer?
> >
> > I suggest to keep it whole for now.
>
>
> Ok can I get some acks please?

Yes, as soon as I have the opportunity to review the work.  There is a
lot of volume on the linux-remoteproc mailing list lately and
patchsets are reviewed in the order they have been received.

> Also, I put this in my linux-next branch on
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>
> there were some conflicts - could you pls test and report it's ok?
>
> > >
> > > Thanks
> > > Guennadi
> > >
> > > > > v4:
> > > > > - add endianness conversions to comply with the VirtIO standard
> > > > >
> > > > > v3:
> > > > > - address several checkpatch warnings
> > > > > - address comments from Mathieu Poirier
> > > > >
> > > > > v2:
> > > > > - update patch #5 with a correct vhost_dev_init() prototype
> > > > > - drop patch #6 - it depends on a different patch, that is currently
> > > > >   an RFC
> > > > > - address comments from Pierre-Louis Bossart:
> > > > >   * remove "default n" from Kconfig
> > > > >
> > > > > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > > > > cases. It can however also be used for virtualisation scenarios,
> > > > > e.g. when using KVM to run Linux on both the host and the guests.
> > > > > This patch set adds a wrapper API to facilitate writing vhost
> > > > > drivers for such RPMsg-based solutions. The first use case is an
> > > > > audio DSP virtualisation project, currently under development, ready
> > > > > for review and submission, available at
> > > > > https://github.com/thesofproject/linux/pull/1501/commits
> > > > >
> > > > > Thanks
> > > > > Guennadi
> > > > >
> > > > > Guennadi Liakhovetski (4):
> > > > >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> > > > >   rpmsg: move common structures and defines to headers
> > > > >   rpmsg: update documentation
> > > > >   vhost: add an RPMsg API
> > > > >
> > > > >  Documentation/rpmsg.txt          |   6 +-
> > > > >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> > > > >  drivers/vhost/Kconfig            |   7 +
> > > > >  drivers/vhost/Makefile           |   3 +
> > > > >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> > > > >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> > > > >  include/linux/virtio_rpmsg.h     |  83 +++++++
> > > > >  include/uapi/linux/rpmsg.h       |   3 +
> > > > >  include/uapi/linux/vhost.h       |   4 +-
> > > > >  9 files changed, 553 insertions(+), 80 deletions(-)
> > > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > > >  create mode 100644 include/linux/virtio_rpmsg.h
> > > > >
> > > > > --
> > > > > 2.27.0
> > > >
>
