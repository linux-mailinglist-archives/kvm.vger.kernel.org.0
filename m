Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E9123BFF9
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 21:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgHDTap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 15:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgHDTao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 15:30:44 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BD2C06174A
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 12:30:44 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so28189905iow.11
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 12:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TH73Zs5fTt6lUTuR4sPJqLcMpqOz88yMBN6BKWQQy/A=;
        b=WpvTZtuBfEGOJOm3847waxD858IWsSQ2bPwHEf/Td8uLA1TgyFe/fXJZm77duojPZf
         k3DFhifFTC3YMHZoP1YUmaEqSXXIRUbTZbXFcyrgO7IECDtiqo499RXv9IKtMoPN3RCY
         XL81rv1i0SExMo4EDObAStEuAgolWUb2R6bzjm3t1kmicA0SFSSGbw/CsTHKg/4skY+F
         HKMGokFBdtQZ0HIEwv8YdiSQXDliPAJjR+IC/mnsOvZMwlm658fTsyyFBPAObdi5u51n
         8DN28Ah/3fauwF5wZ5sBg6trqz75KJWRYJ6Y1ACtUGF9X8xOOpqHJgNP+j0EWKFfSNlM
         HrWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TH73Zs5fTt6lUTuR4sPJqLcMpqOz88yMBN6BKWQQy/A=;
        b=HFiHiG8JflKErzUS+QKfMMJh8VW7e32n3u1HA/hqrgKB9sJiw/fXcra5I8bhTDezHE
         5E4sKepZQBl2j/nrp0sIE2z4SRRAoBoL97GCi/VbdgUEyabSt0CUar1ACSvSJC9CEaRU
         Qs5kp9/utSzGVB3pmdFEfn4ZG5yelDKRG9WRVn/s7HjqcxSJZDSrr6bR+P0zNH1ymuQy
         Lvmyn8Z59eZuWKNJGnwryG5WCkM9EkEVC4Hpkf1Qn4iqC4RB7fA94eC3G5e0eRy5Mu+F
         dzCl9M8MbdLzzW797Ic+Kcvs3L1c2g4J1gq334GP4kkziVHpiVPeqICjLNTpJ/F9+GCV
         /kWg==
X-Gm-Message-State: AOAM53094tN/J8zaKAq5XS7rngb6dlDpTd6ZW+m7YVKcTTQhUJk12h3K
        CA3QeCD4Tpl2jyX/jjiDOfFRfMv72womThmAqbUsmw==
X-Google-Smtp-Source: ABdhPJyj3bm1UhhYOwzX6GHut7QFOJCm/8pB+sq342eCfuEnXKhWHKNFV01sPPsRCp/NdT/XabIi2Y/NroOAT2hbQXU=
X-Received: by 2002:a05:6638:d95:: with SMTP id l21mr7395826jaj.98.1596569443567;
 Tue, 04 Aug 2020 12:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200730120805-mutt-send-email-mst@kernel.org> <20200731054752.GA28005@ubuntu>
 <CANLsYkxuCf6yeoqJ-T2x3LHvr9+DuxFdcsxJPmrh9A4H8yNr3w@mail.gmail.com>
 <20200803164605-mutt-send-email-mst@kernel.org> <CANLsYkx9e=-2dU26Lx5JFrtrbV07Vtwsi3gFphxKW5QRiwqoHg@mail.gmail.com>
 <20200804100640-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200804100640-mutt-send-email-mst@kernel.org>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Tue, 4 Aug 2020 13:30:32 -0600
Message-ID: <CANLsYkzqvev1es_J-FYaBv02jkGHZwpn2cNwZKamAsZ_D=QB7g@mail.gmail.com>
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

On Tue, 4 Aug 2020 at 08:07, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Aug 04, 2020 at 07:37:49AM -0600, Mathieu Poirier wrote:
> > On Mon, 3 Aug 2020 at 14:47, Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Aug 03, 2020 at 07:25:24AM -0600, Mathieu Poirier wrote:
> > > > On Thu, 30 Jul 2020 at 23:47, Guennadi Liakhovetski
> > > > <guennadi.liakhovetski@linux.intel.com> wrote:
> > > > >
> > > > > Hi Michael,
> > > > >
> > > > > On Thu, Jul 30, 2020 at 12:08:29PM -0400, Michael S. Tsirkin wrote:
> > > > > > On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > > > > > > Hi,
> > > > > > >
> > > > > > > Now that virtio-rpmsg endianness fixes have been merged we can
> > > > > > > proceed with the next step.
> > > > > >
> > > > > > Which tree is this for?
> > > > >
> > > > > The essential part of this series is for drivers/vhost, so, I presume
> > > > > that should be the target tree as well. There is however a small part
> > > > > for the drivers/rpmsg, should I split this series in two or shall we
> > > > > first review is as a whole to make its goals clearer?
> > > >
> > > > I suggest to keep it whole for now.
> > >
> > >
> > > Ok can I get some acks please?
> >
> > Yes, as soon as I have the opportunity to review the work.  There is a
> > lot of volume on the linux-remoteproc mailing list lately and
> > patchsets are reviewed in the order they have been received.
>
> Well the merge window is open, I guess I'll merge this and
> any issues can be addressed later then?

Please don't do that.  I prefer to miss a merge window than impacting
upstream consumers.  This patch will be reviewed, just not in time for
this merge window.

>
> > > Also, I put this in my linux-next branch on
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
> > >
> > > there were some conflicts - could you pls test and report it's ok?
> > >
> > > > >
> > > > > Thanks
> > > > > Guennadi
> > > > >
> > > > > > > v4:
> > > > > > > - add endianness conversions to comply with the VirtIO standard
> > > > > > >
> > > > > > > v3:
> > > > > > > - address several checkpatch warnings
> > > > > > > - address comments from Mathieu Poirier
> > > > > > >
> > > > > > > v2:
> > > > > > > - update patch #5 with a correct vhost_dev_init() prototype
> > > > > > > - drop patch #6 - it depends on a different patch, that is currently
> > > > > > >   an RFC
> > > > > > > - address comments from Pierre-Louis Bossart:
> > > > > > >   * remove "default n" from Kconfig
> > > > > > >
> > > > > > > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > > > > > > cases. It can however also be used for virtualisation scenarios,
> > > > > > > e.g. when using KVM to run Linux on both the host and the guests.
> > > > > > > This patch set adds a wrapper API to facilitate writing vhost
> > > > > > > drivers for such RPMsg-based solutions. The first use case is an
> > > > > > > audio DSP virtualisation project, currently under development, ready
> > > > > > > for review and submission, available at
> > > > > > > https://github.com/thesofproject/linux/pull/1501/commits
> > > > > > >
> > > > > > > Thanks
> > > > > > > Guennadi
> > > > > > >
> > > > > > > Guennadi Liakhovetski (4):
> > > > > > >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> > > > > > >   rpmsg: move common structures and defines to headers
> > > > > > >   rpmsg: update documentation
> > > > > > >   vhost: add an RPMsg API
> > > > > > >
> > > > > > >  Documentation/rpmsg.txt          |   6 +-
> > > > > > >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> > > > > > >  drivers/vhost/Kconfig            |   7 +
> > > > > > >  drivers/vhost/Makefile           |   3 +
> > > > > > >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> > > > > > >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> > > > > > >  include/linux/virtio_rpmsg.h     |  83 +++++++
> > > > > > >  include/uapi/linux/rpmsg.h       |   3 +
> > > > > > >  include/uapi/linux/vhost.h       |   4 +-
> > > > > > >  9 files changed, 553 insertions(+), 80 deletions(-)
> > > > > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > > > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > > > > >  create mode 100644 include/linux/virtio_rpmsg.h
> > > > > > >
> > > > > > > --
> > > > > > > 2.27.0
> > > > > >
> > >
>
