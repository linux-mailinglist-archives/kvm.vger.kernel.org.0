Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35B526CBF5
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgIPUhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgIPRKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:10:15 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85098C061352
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 10:10:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id u18so7154307iln.13
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 10:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qz1a2Cp+XdbzMKFssweM33TDfGPcO2oTQCiJorXg/Pw=;
        b=d388WhHY4B6cd6B0jdOctM0gA3DPY2DLJhZ9eqUf2SiRS4CfBFCZVvFMw4rala5L8D
         t9rfEh/9CaJTob6DW1cmcbmVzi5RxzKHezvLdeYagcOtBcaMPoi1VJUeP0I4k0K+w1ou
         xjIVjMLEIveU0qH2hZ6m4q3kXiBvfVW3WN5PbdYPisCSn1Qj9Ko7pymNXHVOX4FNVvf5
         Xk8Jwb0zVSGs7gur/oAn77CM0LHlAQKCVfrWSdL7Ioa2rw9D039XmjmOV6u+TpLec8oN
         iL1zTrCmHSwR2lmV42SxLKUvhlVhY6457NWUmBwY7JQA7h8pujCxtGjzes2HT9Bht87/
         uV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qz1a2Cp+XdbzMKFssweM33TDfGPcO2oTQCiJorXg/Pw=;
        b=UyXEojwakAg5Ak9iD7Jpsf0DzvWHUrYrxWTPFSQWv3Usu5vsY8eFHjWULtCzEliQUO
         ioDOTRQ+gWNMnlvH1zbx55R9zKrIZqsuMzsZv5qvEd7HgS10/118bWLcX8w1SOxPjlKy
         TNuxnPEM1v8CCXdrkGxojIvAvHC4sF2gt7guMhj5EcbVAmkGZvg7WKkiPyxYKZnSWLjf
         Q1eDpRjJ1uKNH6rQqfm0MXTsVIiVjmjwj89pTBBnMhasZHJ3voJ9HUSyWxDzVENOsOYs
         B7x+n30EomX8vAfWOlcWlNEBnriz+7b/gMqDiQ3T2LGjZ2U4/FpjJ7H6ugg9Gp4VBgNe
         Ihwg==
X-Gm-Message-State: AOAM532VsUGLjkEfvwq7lPKuKahobj1Z4rZdT/+PAO91F33v4nAIan7G
        QOvP5xR7WhquIb8JbL3RcwB0dDN/iiUL/ucF7SgH4A==
X-Google-Smtp-Source: ABdhPJxocOklMKg6HOi6czw32/egqU9eRHwyQHEOY/p/IjKBsxxN0fkk5bRJURfSUvSRjazUtIJLEwExfSzdep9IU/A=
X-Received: by 2002:a92:d648:: with SMTP id x8mr3007910ilp.140.1600276202452;
 Wed, 16 Sep 2020 10:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-5-guennadi.liakhovetski@linux.intel.com>
 <20200909223946.GA562265@xps15> <20200910083853.GB17698@ubuntu>
 <20200910172211.GB579940@xps15> <20200911074655.GA26801@ubuntu>
 <20200911173313.GA613136@xps15> <20200915124852.GA12554@ubuntu>
In-Reply-To: <20200915124852.GA12554@ubuntu>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Wed, 16 Sep 2020 11:09:51 -0600
Message-ID: <CANLsYkzG60QY_w4tBd52oY_XQMFKbvxirNO7ZwZc_vC3_cgBoQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] vhost: add an RPMsg API
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 at 06:49, Guennadi Liakhovetski
<guennadi.liakhovetski@linux.intel.com> wrote:
>
> On Fri, Sep 11, 2020 at 11:33:13AM -0600, Mathieu Poirier wrote:
> > On Fri, Sep 11, 2020 at 09:46:56AM +0200, Guennadi Liakhovetski wrote:
> > > Hi Mathieu,
> > >
> > > On Thu, Sep 10, 2020 at 11:22:11AM -0600, Mathieu Poirier wrote:
> > > > Good morning Guennadi,
> > > >
> > > > On Thu, Sep 10, 2020 at 10:38:54AM +0200, Guennadi Liakhovetski wrote:
> > > > > Hi Mathieu,
> > > > >
> > > > > On Wed, Sep 09, 2020 at 04:39:46PM -0600, Mathieu Poirier wrote:
> > > > > > Good afternoon,
> > > > > >
> > > > > > On Wed, Aug 26, 2020 at 07:46:36PM +0200, Guennadi Liakhovetski wrote:
> > > > > > > Linux supports running the RPMsg protocol over the VirtIO transport
> > > > > > > protocol, but currently there is only support for VirtIO clients and
> > > > > > > no support for a VirtIO server. This patch adds a vhost-based RPMsg
> > > > > > > server implementation.
> > > > > >
> > > > > > This changelog is very confusing...  At this time the name service in the
> > > > > > remoteproc space runs as a server on the application processor.  But from the
> > > > > > above the remoteproc usecase seems to be considered to be a client
> > > > > > configuration.
> > > > >
> > > > > I agree that this isn't very obvious. But I think it is common to call the
> > > > > host "a server" and guests "clients." E.g. in vhost.c in the top-of-thefile
> > > > > comment:
> > > >
> > > > Ok - that part we agree on.
> > > >
> > > > >
> > > > >  * Generic code for virtio server in host kernel.
> > > > >
> > > > > I think the generic concept behind this notation is, that as guests boot,
> > > > > they send their requests to the host, e.g. VirtIO device drivers on guests
> > > > > send requests over VirtQueues to VirtIO servers on the host, which can run
> > > > > either in the user- or in the kernel-space. And I think you can follow that
> > > >
> > > > I can see that process taking place.  After all virtIO devices on guests are
> > > > only stubs that need host support for access to HW.
> > > >
> > > > > logic in case of devices or remote processors too: it's the main CPU(s)
> > > > > that boot(s) and start talking to devices and remote processors, so in that
> > > > > sence devices are servers and the CPUs are their clients.
> > > >
> > > > In the remote processor case, the remoteproc core (application processor) sets up
> > > > the name service but does not initiate the communication with a remote
> > > > processor.  It simply waits there for a name space request to come in from the
> > > > remote processor.
> > >
> > > Hm, I don't see that in two examples, that I looked at: mtk and virtio. In both
> > > cases the announcement seems to be directly coming from the application processor
> > > maybe after some initialisation.
> >
> > Can you expand on that part - perhaps point me to the (virtio) code you are
> > referring to?
>
> Ok, we're both right: it goes both ways.
>
> Here's my understanding of the control flow of virtio_rpmsg_bus.c:
>
> 1. The driver registers a VirtIO driver with the VIRTIO_ID_RPMSG ID.

s/virtIO driver/virtIO device

> 2. When the driver is probed, if the server / the application processor supports the
>    VIRTIO_RPMSG_F_NS feature, the driver calls __rpmsg_create_ept() to create an
>    endpoint with rpmsg_ns_cb() as a callback.
> 3. When a namespace announcement arrives from the server, the callback is called,
>    which then registers a new channel (in case of CREATE). That then created an
>    rpmsg device.
> 4. If there's a matching rpmsg driver for that device, it's .probe() method is
>    called, so it can then add its own rpmsg endpoints, to be used for its proper
>    communication.

The above depiction is correct.

>
> Now there was indeed something in virtio_rpmsg_bus.c that I didn't fully understand:
> virtio_rpmsg_announce_create() and virtio_rpmsg_announce_destroy() functions. Now I
> understood, that as the client registers its custom channels, it also then can
> send name service announcements to the application processor, using those functions.

Function virtio_rpmsg_announce_create/destroy() are not used when
channels are created on the application processor after the reception
of a name service announcement from a remote processor.  Indeed, the
address of the remote service is already conveyed in
rpmsg_ns_msg::addr and need not be announced because it is already
known by the remote processor.

Create/destroy() functions are useful when the application processor
registers a channel on its own, i.e not prodded by the remote
processor (rpmsg_ns_cb()).  It is important to note that at this point
we do not have an rpmsg device (that is virtIO based) that uses this
functionality.

> This is also described in [1] as:
>
> <quote>
> Name Service sub-component (optional)
>
> This subcomponent is a minimum implementation of the name service which is present
> in the Linux Kernel implementation of RPMsg. It allows the communicating node both
> to send announcements about "named" endpoint (in other words, channel) creation or
> deletion and to receive these announcement taking any user-defined action in an
> application callback.

Right, we are talking about the same thing.

> </quote>
>
> Also in Documentation/rpmsg.txt
>
> <quote>
> ...the remote processor announces the existence of a remote rpmsg service by
> sending a name service message (which contains the name and rpmsg addr of the
> remote service, see struct rpmsg_ns_msg).
> </quote>
>
> in [2]:
>
> <quote>
> In the current protocol, at startup, the master sends notification to remote to let
> it know that it can receive name service announcement.

The RPMSG protocol is not involved in that path.  The only
notification send by the application processor goes through the virtIO
framework with virtio_device_ready() and virtqueue_notify():

https://elixir.bootlin.com/linux/v5.9-rc4/source/drivers/rpmsg/virtio_rpmsg_bus.c#L973

> </quote>
>
> > > > > And yes, the name-space announcement use-case seems confusing to me too - it
> > > > > reverts the relationship in a way: once a guest has booted and established
> > > > > connections to any rpmsg "devices," those send their namespace announcements
> > > > > back. But I think this can be regarded as server identification: you connect
> > > > > to a server and it replies with its identification and capabilities.
> > > >
> > > > Based on the above can I assume vhost_rpmsg_ns_announce() is sent from the
> > > > guest?
> > >
> > > No, it's "vhost_..." so it's running on the host.
> >
> > Ok, that's better and confirms the usage of the VIRTIO_RPMSG_RESPONSE queue.
> > When reading your explanation above, I thought the term "those" referred to the
> > guest.  In light of your explanation I now understand that "those" referred to
> > the rpmgs devices on the host.
> >
> > In the above paragraph you write:
> >
> > ... "once a guest has booted and established connections to any rpmsg "devices",
> > those send their namespace announcements back".
> >
> > I'd like to unpack a few things about this sentence:
> >
> > 1) In this context, how is a "connection" established between a guest and a host?
>
> That's handled by the VirtIO / VirtQueues in the case of virtio_rpmsg_bus.c but in
> general, as mentioned in [2]
>
> <quote>
> However, master does not consider the fact that if the remote is ready to handle
> notification at this point in time.
> </quote>
>
> > 2) How does the guest now about the rpmsg devices it has made a connection to?
>
> Again, that's the same as with all other VirtIO / KVM / Qemu devices: in a common
> Qemu case, it's the Qemu which emulates the hardware and registers those devices.
>
> > 3) Why is a namespace announcement needed at all when guests are aware of the
> > rpmsg devices instantiated on the host, and have already connected to them?
>
> It is indeed optional according to the protocol, but as described above, without
> it the virtio_rpmsg_bus.c driver won't create rpmsg channels / devices, so, no
> probing will take place.

I now have a better understanding of what you are trying to do.  On
the flip side this thread is too long to continue with it - I will
review V7 and we can pickup from there.

Mathieu

>
> > > The host (the server, an
> > > analogue of the application processor, IIUC) sends NS announcements to guests.
> >
> > I think we have just found the source of the confusion - in the remoteproc world
> > the application processor receives name announcements, it doesn't send them.
>
> Interesting, well, we know now that both directions are possible, but I still
> don't know whether all configurations are valid: only down, only up, none or both.
>
> Thanks
> Guennadi
>
> [1] https://nxpmicro.github.io/rpmsg-lite/
> [2] https://github.com/OpenAMP/open-amp/wiki/RPMsg-Messaging-Protocol
>
> > > > I saw your V7, something I will look into.  In the mean time I need to bring
> > > > your attention to this set [1] from Arnaud.  Please have a look as it will
> > > > impact your work.
> > > >
> > > > https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338335
> > >
> > > Yes, I've had a look at that series, thanks for forwarding it to me. TBH I
> > > don't quite understand some choices there, e.g. creating a separate driver and
> > > then having to register devices just for the namespace announcement. I don't
> > > think creating virtual devices is taken easily in Linux. But either way I
> > > don't think our series conflict a lot, but I do hope that I can merge my
> > > series first, he'd just have to switch to using the header, that I'm adding.
> > > Hardly too many changes otherwise.
> >
> > It is not the conflicts between the series that I wanted to highlight but the
> > fact that name service is in the process of becoming a driver on its own, and
> > with no dependence on the transport mechanism.
> >
> > >
> > > > > > And I don't see a server implementation per se...  It is more like a client
> > > > > > implementation since vhost_rpmsg_announce() uses the RESPONSE queue, which sends
> > > > > > messages from host to guest.
> > > > > >
> > > > > > Perhaps it is my lack of familiarity with vhost terminology.
> > > > > >
> > > > > > >
> > > > > > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > > > > ---
> > > > > > >  drivers/vhost/Kconfig       |   7 +
> > > > > > >  drivers/vhost/Makefile      |   3 +
> > > > > > >  drivers/vhost/rpmsg.c       | 373 ++++++++++++++++++++++++++++++++++++
> > > > > > >  drivers/vhost/vhost_rpmsg.h |  74 +++++++
> > > > > > >  4 files changed, 457 insertions(+)
> > > > > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > > > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > > > > >
> > > > > > > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > > > > > > index 587fbae06182..046b948fc411 100644
> > > > > > > --- a/drivers/vhost/Kconfig
> > > > > > > +++ b/drivers/vhost/Kconfig
> > > > > > > @@ -38,6 +38,13 @@ config VHOST_NET
> > > > > > >       To compile this driver as a module, choose M here: the module will
> > > > > > >       be called vhost_net.
> > > > > > >
> > > > > > > +config VHOST_RPMSG
> > > > > > > +   tristate
> > > > > > > +   select VHOST
> > > > > > > +   help
> > > > > > > +     Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> > > > > > > +     drivers, using the RPMsg over VirtIO protocol.
> > > > > >
> > > > > > I had to assume vhost drivers are running on the host and virtIO drivers on the
> > > > > > guests.  This may be common knowledge for people familiar with vhosts but
> > > > > > certainly obscur for commoners  Having a help section that is clear on what is
> > > > > > happening would remove any ambiguity.
> > > > >
> > > > > It is the terminology, yes, but you're right, the wording isn't very clear, will
> > > > > improve.
> > > > >
> > > > > > > +
> > > > > > >  config VHOST_SCSI
> > > > > > >     tristate "VHOST_SCSI TCM fabric driver"
> > > > > > >     depends on TARGET_CORE && EVENTFD
> > > > > > > diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> > > > > > > index f3e1897cce85..9cf459d59f97 100644
> > > > > > > --- a/drivers/vhost/Makefile
> > > > > > > +++ b/drivers/vhost/Makefile
> > > > > > > @@ -2,6 +2,9 @@
> > > > > > >  obj-$(CONFIG_VHOST_NET) += vhost_net.o
> > > > > > >  vhost_net-y := net.o
> > > > > > >
> > > > > > > +obj-$(CONFIG_VHOST_RPMSG) += vhost_rpmsg.o
> > > > > > > +vhost_rpmsg-y := rpmsg.o
> > > > > > > +
> > > > > > >  obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
> > > > > > >  vhost_scsi-y := scsi.o
> > > > > > >
> > > > > > > diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..c26d7a4afc6d
> > > > > > > --- /dev/null
> > > > > > > +++ b/drivers/vhost/rpmsg.c
> > > > > > > @@ -0,0 +1,373 @@
> > > > > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > > > > +/*
> > > > > > > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > > > > > > + *
> > > > > > > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > > > > + *
> > > > > > > + * Vhost RPMsg VirtIO interface. It provides a set of functions to match the
> > > > > > > + * guest side RPMsg VirtIO API, provided by drivers/rpmsg/virtio_rpmsg_bus.c
> > > > > >
> > > > > > Again, very confusing.  The changelog refers to a server implementation but to
> > > > > > me this refers to a client implementation, especially if rpmsg_recv_single() and
> > > > > > rpmsg_ns_cb() are used on the other side of the pipe.
> > > > >
> > > > > I think the above is correct. "Vhost" indicates, that this is running on the host.
> > > > > "match the guest side" means, that you can use this API on the host and it is
> > > > > designed to work together with the RPMsg VirtIO drivers running on guests, as
> > > > > implemented *on guests* by virtio_rpmsg_bus.c. Would "to work together" be a better
> > > > > description than "to match?"
> > > >
> > > > Lets forget about this part now and concentrate on the above conversation.
> > > > Things will start to make sense at one point.
> > >
> > > I've improved that description a bit, it was indeed rather clumsy.
> >
> > Much appreciated - I'll take a look a V7 next week.
> >
> > >
> > > [snip]
> > >
> > > > > > > diff --git a/drivers/vhost/vhost_rpmsg.h b/drivers/vhost/vhost_rpmsg.h
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..30072cecb8a0
> > > > > > > --- /dev/null
> > > > > > > +++ b/drivers/vhost/vhost_rpmsg.h
> > > > > > > @@ -0,0 +1,74 @@
> > > > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > > > +/*
> > > > > > > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > > > > > > + *
> > > > > > > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > > > > + */
> > > > > > > +
> > > > > > > +#ifndef VHOST_RPMSG_H
> > > > > > > +#define VHOST_RPMSG_H
> > > > > > > +
> > > > > > > +#include <linux/uio.h>
> > > > > > > +#include <linux/virtio_rpmsg.h>
> > > > > > > +
> > > > > > > +#include "vhost.h"
> > > > > > > +
> > > > > > > +/* RPMsg uses two VirtQueues: one for each direction */
> > > > > > > +enum {
> > > > > > > +   VIRTIO_RPMSG_RESPONSE,  /* RPMsg response (host->guest) buffers */
> > > > > > > +   VIRTIO_RPMSG_REQUEST,   /* RPMsg request (guest->host) buffers */
> > > > > > > +   /* Keep last */
> > > > > > > +   VIRTIO_RPMSG_NUM_OF_VQS,
> > > > > > > +};
> > > > > > > +
> > > > > > > +struct vhost_rpmsg_ept;
> > > > > > > +
> > > > > > > +struct vhost_rpmsg_iter {
> > > > > > > +   struct iov_iter iov_iter;
> > > > > > > +   struct rpmsg_hdr rhdr;
> > > > > > > +   struct vhost_virtqueue *vq;
> > > > > > > +   const struct vhost_rpmsg_ept *ept;
> > > > > > > +   int head;
> > > > > > > +   void *priv;
> > > > > >
> > > > > > I don't see @priv being used anywhere.
> > > > >
> > > > > That's logical: this is a field, private to the API users, so the core shouldn't
> > > > > use it :-) It's used in later patches.
> > > >
> > > > That is where structure documentation is useful.  I will let Michael decide what
> > > > he wants to do.
> > >
> > > I can add some kerneldoc documentation there, no problem.
> > >
> > > > Thanks for the feedback,
> > >
> > > Thanks for your reviews! I'd very much like to close all the still open points
> > > and merge the series ASAP.
> > >
> > > Thanks
> > > Guennadi
> > >
> > > > Mathieu
> > > >
> > > > >
> > > > > >
> > > > > > > +};
> > > > > > > +
> > > > > > > +struct vhost_rpmsg {
> > > > > > > +   struct vhost_dev dev;
> > > > > > > +   struct vhost_virtqueue vq[VIRTIO_RPMSG_NUM_OF_VQS];
> > > > > > > +   struct vhost_virtqueue *vq_p[VIRTIO_RPMSG_NUM_OF_VQS];
> > > > > > > +   const struct vhost_rpmsg_ept *ept;
> > > > > > > +   unsigned int n_epts;
> > > > > > > +};
> > > > > > > +
> > > > > > > +struct vhost_rpmsg_ept {
> > > > > > > +   ssize_t (*read)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > > > > > > +   ssize_t (*write)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > > > > > > +   int addr;
> > > > > > > +};
> > > > > > > +
> > > > > > > +static inline size_t vhost_rpmsg_iter_len(const struct vhost_rpmsg_iter *iter)
> > > > > > > +{
> > > > > > > +   return iter->rhdr.len;
> > > > > > > +}
> > > > > >
> > > > > > Again, I don't see where this is used.
> > > > >
> > > > > This is exported API, it's used by users.
> > > > >
> > > > > > > +
> > > > > > > +#define VHOST_RPMSG_ITER(_vq, _src, _dst) {                        \
> > > > > > > +   .rhdr = {                                               \
> > > > > > > +                   .src = cpu_to_vhost32(_vq, _src),       \
> > > > > > > +                   .dst = cpu_to_vhost32(_vq, _dst),       \
> > > > > > > +           },                                              \
> > > > > > > +   }
> > > > > >
> > > > > > Same.
> > > > >
> > > > > ditto.
> > > > >
> > > > > Thanks
> > > > > Guennadi
> > > > >
> > > > > > Thanks,
> > > > > > Mathieu
> > > > > >
> > > > > > > +
> > > > > > > +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> > > > > > > +                 unsigned int n_epts);
> > > > > > > +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr);
> > > > > > > +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
> > > > > > > +                       unsigned int src);
> > > > > > > +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr,
> > > > > > > +                      struct vhost_rpmsg_iter *iter,
> > > > > > > +                      unsigned int qid, ssize_t len);
> > > > > > > +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > > > > > > +                   void *data, size_t size);
> > > > > > > +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> > > > > > > +                         struct vhost_rpmsg_iter *iter);
> > > > > > > +
> > > > > > > +#endif
> > > > > > > --
> > > > > > > 2.28.0
> > > > > > >
