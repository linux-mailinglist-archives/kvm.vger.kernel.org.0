Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0AF2D4946
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 19:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgLISnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 13:43:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733201AbgLISn2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 13:43:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607539321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lk3sun6J6ZaKCEXmHk4Lr251oV6cGXMTlOHoLDL99QA=;
        b=A2O10HKXCjhpuTl9k5oMOsmDvH6ax0cTPyUwzA7TWVA2kVqUFfIbAPIzEBR67sYFXad64B
        nqGng/eNFcT5jLvXeAFSAsCCEcXIM4iysP/yb2JUTmSvJI15qZlUxTjzQdLeeVi/xIu2k1
        NdHFNQLNwOu+Mpq36ZkqIP1K9reKqWo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-jqnx9vu5NY-cFAl3j6NrVQ-1; Wed, 09 Dec 2020 13:42:00 -0500
X-MC-Unique: jqnx9vu5NY-cFAl3j6NrVQ-1
Received: by mail-qk1-f199.google.com with SMTP id 198so1764822qkj.7
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 10:42:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lk3sun6J6ZaKCEXmHk4Lr251oV6cGXMTlOHoLDL99QA=;
        b=lqXp+W7XCdkYheebcG3pavKcHqucL/4KjuvWjdz6V2aduFRD1dPKKeqYhJ6FlNbNXl
         9zmErGmtzFGQ6YOKEPGMqdwqBygBxptZX54q9H0m4ClaXsyd4lgVh6aGY2Enagsy9DLS
         Vm7lNy5+pfeXNQpIw9IOEysdGZ0GxrsJhJ1llVZSuIGvO1IYmm0jrUaw3E6M9mIqFvn9
         SLNi4D1KT1s3U6L35Byg7Kb1rGBgk4nKFKy1jbHT2WiJAN5a8Mp+vatbNuZxGem63NSY
         DzUycWIjjhb813iHjmk0zmFBcGLbiuF4CLzFbV8Cdni6rhWLbIYbtLtQkKZ7aJg25b83
         6oeQ==
X-Gm-Message-State: AOAM532R9EtfUy8nW4YeSUEjj+9lAihEXFP2mWS9jjY9KJ9AoIgy8FFM
        FJh5GKmRd3wVpZMdvRQWKQ7T6SaVWqc2HoIft2EZubl725CLiaEEYIutIIiIJK5w7kpmBQdUf81
        RGYvBdWimv7k/qLD79xs27uO21t6Y
X-Received: by 2002:a37:4658:: with SMTP id t85mr4608861qka.210.1607539319543;
        Wed, 09 Dec 2020 10:41:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXkGCcuiVm+epPlx+mW0vY7zLl3v75k/7Dp2jT6Sl5FNC8Dc6HdWJfZipNZNECFlpW33gUvQfa2MAbG9WCydA=
X-Received: by 2002:a37:4658:: with SMTP id t85mr4608817qka.210.1607539319246;
 Wed, 09 Dec 2020 10:41:59 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-14-eperezma@redhat.com>
 <20201208081621.GR203660@stefanha-x1.localdomain>
In-Reply-To: <20201208081621.GR203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 19:41:23 +0100
Message-ID: <CAJaqyWf13ta5MtzmTUz2N5XnQ+ebqFPYAivdggL64LEQAf=y+A@mail.gmail.com>
Subject: Re: [RFC PATCH 13/27] vhost: Send buffers to device
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

On Tue, Dec 8, 2020 at 9:16 AM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:51PM +0100, Eugenio P=C3=A9rez wrote:
> > -static inline bool vhost_vring_should_kick(VhostShadowVirtqueue *vq)
> > +static bool vhost_vring_should_kick_rcu(VhostShadowVirtqueue *vq)
>
> "vhost_vring_" is a confusing name. This is not related to
> vhost_virtqueue or the vhost_vring_* structs.
>
> vhost_shadow_vq_should_kick_rcu()?
>
> >  {
> > -    return virtio_queue_get_used_notify_split(vq->vq);
> > +    VirtIODevice *vdev =3D vq->vdev;
> > +    vq->num_added =3D 0;
>
> I'm surprised that a bool function modifies state. Is this assignment
> intentional?
>

It's from the kernel code, virtqueue_kick_prepare_split function. The
num_added member is internal (mutable) state, counting for the batch
so the driver sends a notification in case of uint16_t wrapping in
vhost_vring_add_split with no notification in between. I don't know if
some actual virtio devices could be actually affected from this, since
actual vqs are smaller than (uint16_t)-1 so they should be aware that
more buffers have been added anyway.

> > +/* virtqueue_add:
> > + * @vq: The #VirtQueue
> > + * @elem: The #VirtQueueElement
>
> The copy-pasted doc comment doesn't match this function.
>

Right, I will fix it.

> > +int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem)
> > +{
> > +    int host_head =3D vhost_vring_add_split(vq, elem);
> > +    if (vq->ring_id_maps[host_head]) {
> > +        g_free(vq->ring_id_maps[host_head]);
> > +    }
>
> VirtQueueElement is freed lazily? Is there a reason for this approach? I
> would have expected it to be freed when the used element is process by
> the kick fd handler.
>

Maybe it has more sense to free immediately in this commit and
introduce ring_id_maps in later commits, yes.

> > diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> > index 9352c56bfa..304e0baa61 100644
> > --- a/hw/virtio/vhost.c
> > +++ b/hw/virtio/vhost.c
> > @@ -956,8 +956,34 @@ static void handle_sw_lm_vq(VirtIODevice *vdev, Vi=
rtQueue *vq)
> >      uint16_t idx =3D virtio_get_queue_index(vq);
> >
> >      VhostShadowVirtqueue *svq =3D hdev->sw_lm_shadow_vq[idx];
> > +    VirtQueueElement *elem;
> >
> > -    vhost_vring_kick(svq);
> > +    /*
> > +     * Make available all buffers as possible.
> > +     */
> > +    do {
> > +        if (virtio_queue_get_notification(vq)) {
> > +            virtio_queue_set_notification(vq, false);
> > +        }
> > +
> > +        while (true) {
> > +            int r;
> > +            if (virtio_queue_full(vq)) {
> > +                break;
> > +            }
>
> Why is this check necessary? The guest cannot provide more descriptors
> than there is ring space. If that happens somehow then it's a driver
> error that is already reported in virtqueue_pop() below.
>

It's just checked because virtqueue_pop prints an error on that case,
and there is no way to tell the difference between a regular error and
another caused by other causes. Maybe the right thing to do is just to
not to print that error? Caller should do the error printing in that
case. Should we return an error code?

> I wonder if you added this because the vring implementation above
> doesn't support indirect descriptors? It's easy to exhaust the vhost
> hdev vring while there is still room in the VirtIODevice's VirtQueue
> vring.

