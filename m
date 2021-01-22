Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA62300B73
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 19:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbhAVShJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 13:37:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729743AbhAVSV1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 13:21:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611339558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i5uG3VkTMr9TyU6fW63sMt/tjIFddnD19fqLFaikmWM=;
        b=ZnSt9YtU6LDG7+FzlEdCmdTJs3bhILFqyuluHdHHah/qyAx9tE4A+q1zL+RrSdKEpCRLek
        6Jza3LTQsMYia3p/7+mKQLaaNpJ9kd+NzGufIVeWuyE/gyMdlUWqTEEsItHpBpNDTHdG22
        aNtuA7Ur6B5o2G3zqFAgMwLfD8+VK6E=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-4Rh_mlqUMTi3ALf4nIQxCw-1; Fri, 22 Jan 2021 13:19:16 -0500
X-MC-Unique: 4Rh_mlqUMTi3ALf4nIQxCw-1
Received: by mail-qk1-f200.google.com with SMTP id w204so4725587qka.18
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 10:19:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i5uG3VkTMr9TyU6fW63sMt/tjIFddnD19fqLFaikmWM=;
        b=TP+Y09jCdc7XGEpAXSzi9cZIG5FRgVL4uI/Yby+Fr9M0tKbf1lP33Sf9zjJehtutUn
         v2GtB6yuk2HhRcvRKS8OumY3qZ8VcUBAz3t+O/eyM1oSoyOk+mNzuprJ4vgZ5zA8xCOd
         SKGTisy7d8OmNzW45sS3oiHjxwLj8vUvfxby9mqXrZqV9S/eYFc+neqve18QK/74TOSF
         TDd6shT8BNYQtBXc95nnGww3KVNr60xKOmkhbTPEAXtHhs+TiWOdl6W60uJ0/P9vnRe9
         q3MWq8dBl3YXvP4DWGLNPh3nXBaMfCK3p96jbUJA1dTbhHRXgrp/3EiSsjc4t3t7ioqi
         bTKQ==
X-Gm-Message-State: AOAM533WnO9CVU1IdxbkbkaReL9uQvV8EC7hwFllyzzBXS+J8jUQf8Kh
        nocu65AzXwzp733rX6/UIIkecU6jdiAfnTs6n0f8+vSLO1pwum3dnNXXmX7M7nmx71tqxtXuBFU
        1t3n9uDu+lcqviIFyjLkjwtJM1tVL
X-Received: by 2002:aed:3ac1:: with SMTP id o59mr5439439qte.203.1611339555674;
        Fri, 22 Jan 2021 10:19:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpPu8drxNo1TOf01hRflaUbJD4hoWniIU5vblEAujNTjuxLzJtBLkYPa8MgoCrN1bnI0xumA6K4af+E0k4B48=
X-Received: by 2002:aed:3ac1:: with SMTP id o59mr5439388qte.203.1611339555418;
 Fri, 22 Jan 2021 10:19:15 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-14-eperezma@redhat.com>
 <20201208081621.GR203660@stefanha-x1.localdomain> <CAJaqyWf13ta5MtzmTUz2N5XnQ+ebqFPYAivdggL64LEQAf=y+A@mail.gmail.com>
 <20201210115547.GH416119@stefanha-x1.localdomain>
In-Reply-To: <20201210115547.GH416119@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 22 Jan 2021 19:18:39 +0100
Message-ID: <CAJaqyWe3EKiHHxgtabeZ8d7TS3LKP_BsCvHjt3YUDGLxy-Egjg@mail.gmail.com>
Subject: Re: [RFC PATCH 13/27] vhost: Send buffers to device
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 10, 2020 at 12:55 PM Stefan Hajnoczi <stefanha@redhat.com> wrot=
e:
>
> On Wed, Dec 09, 2020 at 07:41:23PM +0100, Eugenio Perez Martin wrote:
> > On Tue, Dec 8, 2020 at 9:16 AM Stefan Hajnoczi <stefanha@gmail.com> wro=
te:
> > > On Fri, Nov 20, 2020 at 07:50:51PM +0100, Eugenio P=C3=A9rez wrote:
> > > > +        while (true) {
> > > > +            int r;
> > > > +            if (virtio_queue_full(vq)) {
> > > > +                break;
> > > > +            }
> > >
> > > Why is this check necessary? The guest cannot provide more descriptor=
s
> > > than there is ring space. If that happens somehow then it's a driver
> > > error that is already reported in virtqueue_pop() below.
> > >
> >
> > It's just checked because virtqueue_pop prints an error on that case,
> > and there is no way to tell the difference between a regular error and
> > another caused by other causes. Maybe the right thing to do is just to
> > not to print that error? Caller should do the error printing in that
> > case. Should we return an error code?
>
> The reason an error is printed today is because it's a guest error that
> never happens with correct guest drivers. Something is broken and the
> user should know about it.
>
> Why is "virtio_queue_full" (I already forgot what that actually means,
> it's not clear whether this is referring to avail elements or used
> elements) a condition that should be silently ignored in shadow vqs?
>

TL;DR: It can be changed to a check of the number of available
descriptors in shadow vq, instead of returning as a regular operation.
However, I think that making it a special return of virtqueue_pop
could help in devices that run to completion, avoiding having to
duplicate the count logic in them.

The function virtio_queue_empty checks if the vq has all descriptors
available, so the device has no more work to do until the driver makes
another descriptor available. I can see how it can be a bad name
choice, but virtio_queue_full means the opposite: device has pop()
every descriptor available, and it has not returned any, so the driver
cannot progress until the device marks some descriptors as used.

As I understand, if vq->in_use >vq->num would mean we have a bug in
the device vq code, not in the driver. virtio_queue_full could even be
changed to "assert(vq->inuse <=3D vq->vring.num); return vq->inuse =3D=3D
vq->vring.num", as long as vq->in_use is operated right.

If we hit vq->in_use =3D=3D vq->num in virtqueue_pop it means the device
tried to pop() one more buffer after having all of them available and
pop'ed. This would be invalid if the device is counting right the
number of in_use descriptors, but then we are duplicating that logic
in the device and the vq.

In shadow vq this situation happens with the correct guest network
driver, since the rx queue is filled for the device to write. Network
device in qemu fetch descriptors on demand, but shadow vq fetch all
available in batching. If the driver just happens to fill the queue of
available descriptors, the log will raise, so we need to check in
handle_sw_lm_vq before calling pop(). Of course the shadow vq can
duplicate guest_vq->in_use instead of checking virtio_queue_full, but
then it needs to check two things for every virtqueue_pop() [1].

Having said that, would you prefer a checking of available slots in
the shadow vq?

Thanks!

[1] if we don't change virtqueue_pop code.

