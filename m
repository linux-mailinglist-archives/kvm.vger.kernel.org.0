Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2F42D478D
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 18:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbgLIRK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 12:10:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732362AbgLIRKW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 12:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607533733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAvF4aO/uVkLC5sMDyd70RK51ZlPJ4N8Kvsowu313nM=;
        b=TvKXTEsKzwRR5HFp2PD+l0X2MX2B901ULSqeeGFLndWDdLyZVXatA1zI2k4EI9XvIJCINP
        TfndP28SE/b2boBfT3OgXNESqyUpthheqyQYiFDHEmCKGaEFafTvm+xR0FClUIFzj9ANdK
        DcrcelCEnNP5bXUO0kBUzxK1WsQDy1A=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-S9d23xrlNMSGizpHYiQv3w-1; Wed, 09 Dec 2020 12:08:52 -0500
X-MC-Unique: S9d23xrlNMSGizpHYiQv3w-1
Received: by mail-qt1-f198.google.com with SMTP id z8so1655278qti.17
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 09:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BAvF4aO/uVkLC5sMDyd70RK51ZlPJ4N8Kvsowu313nM=;
        b=NKbH2nIxYMFGjOrA+9oDqeZheierJ4gSZjsJCKSfiVdynj/P9kaBiz5OBxWNZGyflA
         21WopoZXdY6WgXIPMUsjL7Fb/v1QP3/kAdD8ReevmBHbGimLK9I54+6YTQvmjl34e3bU
         hJMBm4jsb2fr01RsVvhq9+vmigklDS0RS7mR04O2ns942rZNJGu75ezYqah4XGw1i0LZ
         LH49OazPLEd7EitoCUiHT5xwv7z1bAviT0dxvXhns0lAgiPvOcE58fmsLP1YMYOpHu4a
         BRpfoY1AJRlhrdDQyJ1DT2CoaSy/rVgHWoXLQqNtB0ZYb2hIv5a+UvuRT1RsOiSaVNIM
         DqXw==
X-Gm-Message-State: AOAM533eE0lzloLWw4kYZQ5+A0ZhLlyOQ+8aek1Lk7uwS2kqoWnTIP26
        VS7RPNi6qFL625y4xzAyfD3EqDIbQ4ZHt5arT1p97adIOfXWjTy274h3z0rRIDGnSUIsJRU5bls
        eHJNmJIaaxfHEdKNMvdjkwySl4aa+
X-Received: by 2002:a05:620a:b0e:: with SMTP id t14mr4053358qkg.484.1607533731397;
        Wed, 09 Dec 2020 09:08:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJys3U2Bs1iNsuxs3nVeT5GKyB90P1DnfUjosr+fZTdxItuetNZEeeXC4p3taqaoJppCTAT2nXawYyeAisnpeDw=
X-Received: by 2002:a05:620a:b0e:: with SMTP id t14mr4053307qkg.484.1607533730962;
 Wed, 09 Dec 2020 09:08:50 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-8-eperezma@redhat.com>
 <20201207174233.GN203660@stefanha-x1.localdomain>
In-Reply-To: <20201207174233.GN203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 18:08:14 +0100
Message-ID: <CAJaqyWfiMsRP9FgSv7cOj=3jHx=DJS7hRJTMbRcTTHHWng0eKg@mail.gmail.com>
Subject: Re: [RFC PATCH 07/27] vhost: Route guest->host notification through qemu
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

On Mon, Dec 7, 2020 at 6:42 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:45PM +0100, Eugenio P=C3=A9rez wrote:
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  hw/virtio/vhost-sw-lm-ring.h |  26 +++++++++
> >  include/hw/virtio/vhost.h    |   3 ++
> >  hw/virtio/vhost-sw-lm-ring.c |  60 +++++++++++++++++++++
> >  hw/virtio/vhost.c            | 100 +++++++++++++++++++++++++++++++++--
> >  hw/virtio/meson.build        |   2 +-
> >  5 files changed, 187 insertions(+), 4 deletions(-)
> >  create mode 100644 hw/virtio/vhost-sw-lm-ring.h
> >  create mode 100644 hw/virtio/vhost-sw-lm-ring.c
> >
> > diff --git a/hw/virtio/vhost-sw-lm-ring.h b/hw/virtio/vhost-sw-lm-ring.=
h
> > new file mode 100644
> > index 0000000000..86dc081b93
> > --- /dev/null
> > +++ b/hw/virtio/vhost-sw-lm-ring.h
> > @@ -0,0 +1,26 @@
> > +/*
> > + * vhost software live migration ring
> > + *
> > + * SPDX-FileCopyrightText: Red Hat, Inc. 2020
> > + * SPDX-FileContributor: Author: Eugenio P=C3=A9rez <eperezma@redhat.c=
om>
> > + *
> > + * SPDX-License-Identifier: GPL-2.0-or-later
> > + */
> > +
> > +#ifndef VHOST_SW_LM_RING_H
> > +#define VHOST_SW_LM_RING_H
> > +
> > +#include "qemu/osdep.h"
> > +
> > +#include "hw/virtio/virtio.h"
> > +#include "hw/virtio/vhost.h"
> > +
> > +typedef struct VhostShadowVirtqueue VhostShadowVirtqueue;
>
> Here it's called a shadow virtqueue while the file calls it a
> sw-lm-ring. Please use a single name.
>

I will switch to shadow virtqueue.

> > +
> > +bool vhost_vring_kick(VhostShadowVirtqueue *vq);
>
> vhost_shadow_vq_kick()?
>
> > +
> > +VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int=
 idx);
>
> vhost_dev_get_shadow_vq()? This could be in include/hw/virtio/vhost.h
> with the other vhost_dev_*() functions.
>

I agree, that is a better place.

> > +
> > +void vhost_sw_lm_shadow_vq_free(VhostShadowVirtqueue *vq);
>
> Hmm...now I wonder what the lifecycle is. Does vhost_sw_lm_shadow_vq()
> allocate it?
>
> Please add doc comments explaining these functions either in this header
> file or in vhost-sw-lm-ring.c.
>

Will document.

> > +
> > +#endif
> > diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> > index b5b7496537..93cc3f1ae3 100644
> > --- a/include/hw/virtio/vhost.h
> > +++ b/include/hw/virtio/vhost.h
> > @@ -54,6 +54,8 @@ struct vhost_iommu {
> >      QLIST_ENTRY(vhost_iommu) iommu_next;
> >  };
> >
> > +typedef struct VhostShadowVirtqueue VhostShadowVirtqueue;
> > +
> >  typedef struct VhostDevConfigOps {
> >      /* Vhost device config space changed callback
> >       */
> > @@ -83,6 +85,7 @@ struct vhost_dev {
> >      bool started;
> >      bool log_enabled;
> >      uint64_t log_size;
> > +    VhostShadowVirtqueue *sw_lm_shadow_vq[2];
>
> The hardcoded 2 is probably for single-queue virtio-net? I guess this
> will eventually become VhostShadowVirtqueue *shadow_vqs or
> VhostShadowVirtqueue **shadow_vqs, depending on whether each one should
> be allocated individually.
>

Yes, I will switch to one way or another for the next series.

> >      VirtIOHandleOutput sw_lm_vq_handler;
> >      Error *migration_blocker;
> >      const VhostOps *vhost_ops;
> > diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.=
c
> > new file mode 100644
> > index 0000000000..0192e77831
> > --- /dev/null
> > +++ b/hw/virtio/vhost-sw-lm-ring.c
> > @@ -0,0 +1,60 @@
> > +/*
> > + * vhost software live migration ring
> > + *
> > + * SPDX-FileCopyrightText: Red Hat, Inc. 2020
> > + * SPDX-FileContributor: Author: Eugenio P=C3=A9rez <eperezma@redhat.c=
om>
> > + *
> > + * SPDX-License-Identifier: GPL-2.0-or-later
> > + */
> > +
> > +#include "hw/virtio/vhost-sw-lm-ring.h"
> > +#include "hw/virtio/vhost.h"
> > +
> > +#include "standard-headers/linux/vhost_types.h"
> > +#include "standard-headers/linux/virtio_ring.h"
> > +
> > +#include "qemu/event_notifier.h"
> > +
> > +typedef struct VhostShadowVirtqueue {
> > +    EventNotifier hdev_notifier;
> > +    VirtQueue *vq;
> > +} VhostShadowVirtqueue;
> > +
> > +static inline bool vhost_vring_should_kick(VhostShadowVirtqueue *vq)
> > +{
> > +    return virtio_queue_get_used_notify_split(vq->vq);
> > +}
> > +
> > +bool vhost_vring_kick(VhostShadowVirtqueue *vq)
> > +{
> > +    return vhost_vring_should_kick(vq) ? event_notifier_set(&vq->hdev_=
notifier)
> > +                                       : true;
> > +}
>
> How is the return value used? event_notifier_set() returns -errno so
> this function returns false on success, and true when notifications are
> disabled or event_notifier_set() failed. I'm not sure this return value
> can be used for anything.
>

I think you are right, this is bad. It could be used for retry, but
the failure is unlikely and the fail path is easy to add in the future
if needed.

It will be void.

> > +
> > +VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int=
 idx)
>
> I see now that this function allocates the VhostShadowVirtqueue. Maybe
> adding _new() to the name would make that clear?
>

Yes, I will rename.

> > +{
> > +    struct vhost_vring_file file =3D {
> > +        .index =3D idx
> > +    };
> > +    VirtQueue *vq =3D virtio_get_queue(dev->vdev, idx);
> > +    VhostShadowVirtqueue *svq;
> > +    int r;
> > +
> > +    svq =3D g_new0(VhostShadowVirtqueue, 1);
> > +    svq->vq =3D vq;
> > +
> > +    r =3D event_notifier_init(&svq->hdev_notifier, 0);
> > +    assert(r =3D=3D 0);
> > +
> > +    file.fd =3D event_notifier_get_fd(&svq->hdev_notifier);
> > +    r =3D dev->vhost_ops->vhost_set_vring_kick(dev, &file);
> > +    assert(r =3D=3D 0);
> > +
> > +    return svq;
> > +}
>
> I guess there are assumptions about the status of the device? Does the
> virtqueue need to be disabled when this function is called?
>

Yes. Maybe an assertion checking the notification state?

> > +
> > +void vhost_sw_lm_shadow_vq_free(VhostShadowVirtqueue *vq)
> > +{
> > +    event_notifier_cleanup(&vq->hdev_notifier);
> > +    g_free(vq);
> > +}
> > diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> > index 9cbd52a7f1..a55b684b5f 100644
> > --- a/hw/virtio/vhost.c
> > +++ b/hw/virtio/vhost.c
> > @@ -13,6 +13,8 @@
> >   * GNU GPL, version 2 or (at your option) any later version.
> >   */
> >
> > +#include "hw/virtio/vhost-sw-lm-ring.h"
> > +
> >  #include "qemu/osdep.h"
> >  #include "qapi/error.h"
> >  #include "hw/virtio/vhost.h"
> > @@ -61,6 +63,20 @@ bool vhost_has_free_slot(void)
> >      return slots_limit > used_memslots;
> >  }
> >
> > +static struct vhost_dev *vhost_dev_from_virtio(const VirtIODevice *vde=
v)
> > +{
> > +    struct vhost_dev *hdev;
> > +
> > +    QLIST_FOREACH(hdev, &vhost_devices, entry) {
> > +        if (hdev->vdev =3D=3D vdev) {
> > +            return hdev;
> > +        }
> > +    }
> > +
> > +    assert(hdev);
> > +    return NULL;
> > +}
> > +
> >  static bool vhost_dev_can_log(const struct vhost_dev *hdev)
> >  {
> >      return hdev->features & (0x1ULL << VHOST_F_LOG_ALL);
> > @@ -148,6 +164,12 @@ static int vhost_sync_dirty_bitmap(struct vhost_de=
v *dev,
> >      return 0;
> >  }
> >
> > +static void vhost_log_sync_nop(MemoryListener *listener,
> > +                               MemoryRegionSection *section)
> > +{
> > +    return;
> > +}
> > +
> >  static void vhost_log_sync(MemoryListener *listener,
> >                            MemoryRegionSection *section)
> >  {
> > @@ -928,6 +950,71 @@ static void vhost_log_global_stop(MemoryListener *=
listener)
> >      }
> >  }
> >
> > +static void handle_sw_lm_vq(VirtIODevice *vdev, VirtQueue *vq)
> > +{
> > +    struct vhost_dev *hdev =3D vhost_dev_from_virtio(vdev);
>
> If this lookup becomes a performance bottleneck there are other options
> for determining the vhost_dev. For example VirtIODevice could have a
> field for stashing the vhost_dev pointer.
>

I would like to have something like that for the definitive patch
series, yes. I would not like to increase the virtio knowledge of
vhost, but it seems the most straightforward change for it.

> > +    uint16_t idx =3D virtio_get_queue_index(vq);
> > +
> > +    VhostShadowVirtqueue *svq =3D hdev->sw_lm_shadow_vq[idx];
> > +
> > +    vhost_vring_kick(svq);
> > +}
>
> I'm a confused. Do we need to pop elements from vq and push equivalent
> elements onto svq before kicking? Either a todo comment is missing or I
> misunderstand how this works.
>

At this commit only notifications are forwarded, buffers are still
fetched directly from the guest. A TODO comment would have been
helpful, yes :).

> > +
> > +static int vhost_sw_live_migration_stop(struct vhost_dev *dev)
> > +{
> > +    int idx;
> > +
> > +    vhost_dev_enable_notifiers(dev, dev->vdev);
> > +    for (idx =3D 0; idx < dev->nvqs; ++idx) {
> > +        vhost_sw_lm_shadow_vq_free(dev->sw_lm_shadow_vq[idx]);
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> > +static int vhost_sw_live_migration_start(struct vhost_dev *dev)
> > +{
> > +    int idx;
> > +
> > +    for (idx =3D 0; idx < dev->nvqs; ++idx) {
> > +        dev->sw_lm_shadow_vq[idx] =3D vhost_sw_lm_shadow_vq(dev, idx);
> > +    }
> > +
> > +    vhost_dev_disable_notifiers(dev, dev->vdev);
>
> There is a race condition if the guest kicks the vq while this is
> happening. The shadow vq hdev_notifier needs to be set so the vhost
> device checks the virtqueue for requests that slipped in during the
> race window.
>

I'm not sure if I follow you. If I understand correctly,
vhost_dev_disable_notifiers calls virtio_bus_cleanup_host_notifier,
and the latter calls virtio_queue_host_notifier_read. That's why the
documentation says "This might actually run the qemu handlers right
away, so virtio in qemu must be completely setup when this is
called.". Am I missing something?

> > +
> > +    return 0;
> > +}
> > +
> > +static int vhost_sw_live_migration_enable(struct vhost_dev *dev,
> > +                                          bool enable_lm)
> > +{
> > +    if (enable_lm) {
> > +        return vhost_sw_live_migration_start(dev);
> > +    } else {
> > +        return vhost_sw_live_migration_stop(dev);
> > +    }
> > +}
> > +
> > +static void vhost_sw_lm_global_start(MemoryListener *listener)
> > +{
> > +    int r;
> > +
> > +    r =3D vhost_migration_log(listener, true, vhost_sw_live_migration_=
enable);
> > +    if (r < 0) {
> > +        abort();
> > +    }
> > +}
> > +
> > +static void vhost_sw_lm_global_stop(MemoryListener *listener)
> > +{
> > +    int r;
> > +
> > +    r =3D vhost_migration_log(listener, false, vhost_sw_live_migration=
_enable);
> > +    if (r < 0) {
> > +        abort();
> > +    }
> > +}
> > +
> >  static void vhost_log_start(MemoryListener *listener,
> >                              MemoryRegionSection *section,
> >                              int old, int new)
> > @@ -1334,9 +1421,14 @@ int vhost_dev_init(struct vhost_dev *hdev, void =
*opaque,
> >          .region_nop =3D vhost_region_addnop,
> >          .log_start =3D vhost_log_start,
> >          .log_stop =3D vhost_log_stop,
> > -        .log_sync =3D vhost_log_sync,
> > -        .log_global_start =3D vhost_log_global_start,
> > -        .log_global_stop =3D vhost_log_global_stop,
> > +        .log_sync =3D !vhost_dev_can_log(hdev) ?
> > +                    vhost_log_sync_nop :
> > +                    vhost_log_sync,
>
> Why is this change necessary now? It's not clear to me why it was
> previously okay to call vhost_log_sync().
>

This is only needed because I'm hijacking the vhost log system to know
when migration has started. Since vhost log is not allocated, the call
to vhost_log_sync() will fail to write in the bitmap.

Likely, this change will be discarded in the final patch series, since
another way of detecting live migration will be used.

> > +        .log_global_start =3D !vhost_dev_can_log(hdev) ?
> > +                            vhost_sw_lm_global_start :
> > +                            vhost_log_global_start,
> > +        .log_global_stop =3D !vhost_dev_can_log(hdev) ? vhost_sw_lm_gl=
obal_stop :
> > +                                                      vhost_log_global=
_stop,
> >          .eventfd_add =3D vhost_eventfd_add,
> >          .eventfd_del =3D vhost_eventfd_del,
> >          .priority =3D 10
> > @@ -1364,6 +1456,8 @@ int vhost_dev_init(struct vhost_dev *hdev, void *=
opaque,
> >              error_free(hdev->migration_blocker);
> >              goto fail_busyloop;
> >          }
> > +    } else {
> > +        hdev->sw_lm_vq_handler =3D handle_sw_lm_vq;
> >      }
> >
> >      hdev->mem =3D g_malloc0(offsetof(struct vhost_memory, regions));
> > diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
> > index fbff9bc9d4..17419cb13e 100644
> > --- a/hw/virtio/meson.build
> > +++ b/hw/virtio/meson.build
> > @@ -11,7 +11,7 @@ softmmu_ss.add(when: 'CONFIG_ALL', if_true: files('vh=
ost-stub.c'))
> >
> >  virtio_ss =3D ss.source_set()
> >  virtio_ss.add(files('virtio.c'))
> > -virtio_ss.add(when: 'CONFIG_VHOST', if_true: files('vhost.c', 'vhost-b=
ackend.c'))
> > +virtio_ss.add(when: 'CONFIG_VHOST', if_true: files('vhost.c', 'vhost-b=
ackend.c', 'vhost-sw-lm-ring.c'))
> >  virtio_ss.add(when: 'CONFIG_VHOST_USER', if_true: files('vhost-user.c'=
))
> >  virtio_ss.add(when: 'CONFIG_VHOST_VDPA', if_true: files('vhost-vdpa.c'=
))
> >  virtio_ss.add(when: 'CONFIG_VIRTIO_BALLOON', if_true: files('virtio-ba=
lloon.c'))
> > --
> > 2.18.4
> >

