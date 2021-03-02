Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D432B57B
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379185AbhCCHRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350274AbhCBSgf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 13:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614710099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tkxzT6eGQQunGDeBfXZ5nUwmm4W221ZStlrJWqytAHo=;
        b=gSVYYDN7/vodTMGqPXlIgOp1EC2BR/VFed7XMVclA1KVUZkjktKmN+KDMVd2PmnSb8A4rO
        UoJ9aBl+05NzLYFryx+UrsiFWi9UQ1KFP2TuxX/Rqah5jOYplhlRCok5KX/tXSPvgMIDVZ
        sj6hhpkmOTzCcMiEthmt6L/9KwqDZ3E=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-HP-VPsrqM9KgXh773SPKyA-1; Tue, 02 Mar 2021 13:34:57 -0500
X-MC-Unique: HP-VPsrqM9KgXh773SPKyA-1
Received: by mail-qv1-f72.google.com with SMTP id u17so6108109qvq.23
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:34:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tkxzT6eGQQunGDeBfXZ5nUwmm4W221ZStlrJWqytAHo=;
        b=r8TKad6gffqVR6Eu6Q+ArpMKSDmaifqYs9WITjdRLRuLxiPM7Fto5KMBRNrB4XuI6P
         kSZsOzQZuiidUFTu8mqnOf2Z977sB2mXlpbmbJ/p7uJBu8R+JrorrLxuN8E9bMXc59j4
         k2EGWa1fX8q7MXakXicldhZ8v60vHrF/mjb1SkXcQiRVZZ92uan2m5zAbRROChhlwZIs
         dRS0ikj9zE80kNsDl+c4cW73oZ/yT5t8UPCVDYBSGZ9GAe82bR7yUKYD1FLk0MPIOY/s
         Da63ViLh2ZZI9JUgQQ/872fSKMnlJPLIfTAB/3DbRQirMhQQAVltyV3ejQPFQbrnmcdk
         NwNA==
X-Gm-Message-State: AOAM533S4IS0dmPbTZ8AzbNQgVN7TR5vbJsC1Rpt52UBoIQXqq0H1Ft/
        W0MkTpz7svktrHIlnZc+PFvydE7xujyNbQr7cujkF2W8E3BevKFq667Bgc7rIHoS+HWBfOXPmvX
        xuo4BjxHLziEu3py1I34FyIvup6tH
X-Received: by 2002:a37:a785:: with SMTP id q127mr1189793qke.425.1614710097257;
        Tue, 02 Mar 2021 10:34:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyM1RgDFsSo8eAG5i1uUEDF42mlVywf5r9ywIBg4y0XWNnvPp9gd/vAMbtuh4g8pVo6SmdIHTGoPK0tZrUU+wo=
X-Received: by 2002:a37:a785:: with SMTP id q127mr1189751qke.425.1614710096940;
 Tue, 02 Mar 2021 10:34:56 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-7-eperezma@redhat.com>
 <20201207165848.GM203660@stefanha-x1.localdomain> <CAJaqyWc4oLzL02GKpPSwEGRxK+UxjOGBAPLzrgrgKRZd9C81GA@mail.gmail.com>
 <YD4f4KEIYRlTUP4/@stefanha-x1.localdomain>
In-Reply-To: <YD4f4KEIYRlTUP4/@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 2 Mar 2021 19:34:20 +0100
Message-ID: <CAJaqyWd0iRUUW5Hu=U3mwQ4f43kA=bse3EkN4+QauFR4BJwObQ@mail.gmail.com>
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

On Tue, Mar 2, 2021 at 12:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 07:21:27PM +0100, Eugenio Perez Martin wrote:
> > On Mon, Dec 7, 2020 at 5:58 PM Stefan Hajnoczi <stefanha@gmail.com> wro=
te:
> > >
> > > On Fri, Nov 20, 2020 at 07:50:44PM +0100, Eugenio P=C3=A9rez wrote:
> > > > This function is just used for a few commits, so SW LM is developed
> > > > incrementally, and it is deleted after it is useful.
> > > >
> > > > For a few commits, only the events (irqfd, eventfd) are forwarded.
> > >
> > > s/eventfd/ioeventfd/ (irqfd is also an eventfd)
> > >
> >
> > Oops, will fix, thanks!
> >
> > > > +bool virtio_queue_get_used_notify_split(VirtQueue *vq)
> > > > +{
> > > > +    VRingMemoryRegionCaches *caches;
> > > > +    hwaddr pa =3D offsetof(VRingUsed, flags);
> > > > +    uint16_t flags;
> > > > +
> > > > +    RCU_READ_LOCK_GUARD();
> > > > +
> > > > +    caches =3D vring_get_region_caches(vq);
> > > > +    assert(caches);
> > > > +    flags =3D virtio_lduw_phys_cached(vq->vdev, &caches->used, pa)=
;
> > > > +    return !(VRING_USED_F_NO_NOTIFY & flags);
> > > > +}
> > >
> > > QEMU stores the notification status:
> > >
> > > void virtio_queue_set_notification(VirtQueue *vq, int enable)
> > > {
> > >     vq->notification =3D enable; <---- here
> > >
> > >     if (!vq->vring.desc) {
> > >         return;
> > >     }
> > >
> > >     if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> > >         virtio_queue_packed_set_notification(vq, enable);
> > >     } else {
> > >         virtio_queue_split_set_notification(vq, enable);
> > >
> > > I'm wondering why it's necessary to fetch from guest RAM instead of
> > > using vq->notification? It also works for both split and packed
> > > queues so the code would be simpler.
> >
> > To use vq->notification makes sense at the end of the series.
> >
> > However, at this stage (just routing notifications, not descriptors),
> > vhost device is the one updating that flag, not qemu. Since we cannot
> > just migrate used ring memory to qemu without migrating descriptors
> > ring too, qemu needs to check guest's memory looking for vhost device
> > updates on that flag.
> >
> > I can see how that deserves better documentation or even a better
> > name. Also, this function should be in the shadow vq file, not
> > virtio.c.
>
> I can't think of a reason why QEMU needs to know the flag value that the
> vhost device has set. This flag is a hint to the guest driver indicating
> whether the device wants to receive notifications.
>
> Can you explain why QEMU needs to look at the value of the flag?
>
> Stefan

My bad, "need" is not the right word: SVQ could just forward the
notification at this point without checking the flag. Taking into
account that it's not used in later series, and it's even removed in
patch 14/27 of this series, I can see that it just adds noise to the
entire patchset

This function just allows svq to re-check the flag after the guest
sends the notification. This way svq is able to drop the kick as a
(premature?) optimization in case the device sets it just after the
guest sends the kick.

Until patch 13/27, only notifications are forwarded, not buffers. VM
guest's drivers and vhost device still read and write at usual
addresses, but ioeventfd and kvmfd are intercepted by qemu. This
allows us to test if the notification forwarding part is doing ok.
From patch 14 of this series, svq offers a new vring to the device in
qemu's VAS, so the former does not need to check the guest's memory
anymore, and this function can be dropped.

Is it clearer now? Please let me know if I should add something else.

Thanks!

