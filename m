Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA4A2F38B9
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436561AbhALSXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:23:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406632AbhALSXf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 13:23:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610475726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltzSMsOBmoKeRI1L4IOCgQ7n1ZwKFysvzmkyq562kMs=;
        b=jVj6xSJOSm65BeYrnYAI1HHEXzlLL2tgyIET/5o2de49gl9qc6Mt03Ss7Gio+H0CYwcBv5
        rf2HFXSfoBAGbD6KsdXxJ4Y+5gxCx/Ia7lFq2df2HXdzE59a7dx3fo30VWfGk8tJMTX88h
        1pyQk5VLPEaXznHbHdmcIQn26T68F/8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-d5jmNgDwMJSyqLKi2i6qjQ-1; Tue, 12 Jan 2021 13:22:04 -0500
X-MC-Unique: d5jmNgDwMJSyqLKi2i6qjQ-1
Received: by mail-qk1-f198.google.com with SMTP id 189so2178546qko.1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:22:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ltzSMsOBmoKeRI1L4IOCgQ7n1ZwKFysvzmkyq562kMs=;
        b=Rt+SBnOCTHapmpmsvgt3dcd7rg2FqBQ6SCiBj2Ie7xQWXJcJcRYHCFe+bdJlea+Hyf
         0wv34m8zJwrP7mnUAbWBY3NVSG9EjPJEhpnXWdDmvDijIaljL7UlCuA31emNVTRqm3j9
         BwSLBNUB/xSDGiwwtfuM2wG3zypIBrbImm9aH4EUFtN481WSbMsXUZL+kbeFoqx6FTlh
         ea34hq4pFXodRpJf+fq/dkADCgT8uevLUJGMdYqKCaMm6tbUy8Ccxss1EP+ogPz8C9H2
         wJxmK6Eor3ms9JLetzIUD2TPrWaheUdbXJxCdZpcm9HDAa68Qg98L5v3oSbZ4bmIBiBx
         dBiA==
X-Gm-Message-State: AOAM530fo5GHIzBMtsavOKkrMoD/Pz6X2FVgcjoX6Iqw4MvxeWe/G6Zo
        NUOb043LsRbpCwm+jFvXiqZ/96X1au+NF6e/XJq9bqpk6vQDX3t0kugDGW4etTGStwg8vqrcuiT
        /YOXW1mSHXpWfv6vKXScqUvRDCrRh
X-Received: by 2002:ac8:5441:: with SMTP id d1mr270421qtq.384.1610475724532;
        Tue, 12 Jan 2021 10:22:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxrsSzZftWuMuBvJWz3zjdZXTF9Rj/KikTBG5Gvotrb499zSfZZnuj1AhLDoewu2jIs4sw+lQd5WdkoGYx0ic=
X-Received: by 2002:ac8:5441:: with SMTP id d1mr270398qtq.384.1610475724263;
 Tue, 12 Jan 2021 10:22:04 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-7-eperezma@redhat.com>
 <20201207165848.GM203660@stefanha-x1.localdomain>
In-Reply-To: <20201207165848.GM203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 12 Jan 2021 19:21:27 +0100
Message-ID: <CAJaqyWc4oLzL02GKpPSwEGRxK+UxjOGBAPLzrgrgKRZd9C81GA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/27] virtio: Add virtio_queue_get_used_notify_split
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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

On Mon, Dec 7, 2020 at 5:58 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:44PM +0100, Eugenio P=C3=A9rez wrote:
> > This function is just used for a few commits, so SW LM is developed
> > incrementally, and it is deleted after it is useful.
> >
> > For a few commits, only the events (irqfd, eventfd) are forwarded.
>
> s/eventfd/ioeventfd/ (irqfd is also an eventfd)
>

Oops, will fix, thanks!

> > +bool virtio_queue_get_used_notify_split(VirtQueue *vq)
> > +{
> > +    VRingMemoryRegionCaches *caches;
> > +    hwaddr pa =3D offsetof(VRingUsed, flags);
> > +    uint16_t flags;
> > +
> > +    RCU_READ_LOCK_GUARD();
> > +
> > +    caches =3D vring_get_region_caches(vq);
> > +    assert(caches);
> > +    flags =3D virtio_lduw_phys_cached(vq->vdev, &caches->used, pa);
> > +    return !(VRING_USED_F_NO_NOTIFY & flags);
> > +}
>
> QEMU stores the notification status:
>
> void virtio_queue_set_notification(VirtQueue *vq, int enable)
> {
>     vq->notification =3D enable; <---- here
>
>     if (!vq->vring.desc) {
>         return;
>     }
>
>     if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
>         virtio_queue_packed_set_notification(vq, enable);
>     } else {
>         virtio_queue_split_set_notification(vq, enable);
>
> I'm wondering why it's necessary to fetch from guest RAM instead of
> using vq->notification? It also works for both split and packed
> queues so the code would be simpler.

To use vq->notification makes sense at the end of the series.

However, at this stage (just routing notifications, not descriptors),
vhost device is the one updating that flag, not qemu. Since we cannot
just migrate used ring memory to qemu without migrating descriptors
ring too, qemu needs to check guest's memory looking for vhost device
updates on that flag.

I can see how that deserves better documentation or even a better
name. Also, this function should be in the shadow vq file, not
virtio.c.

Thanks!

