Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A776C30CC
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 12:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCULtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 07:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCULtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 07:49:43 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD1037B69
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 04:49:26 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bi9so18702199lfb.12
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 04:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679399364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCEQEWiKcDx1SEV880+a7XA/x3hnnzOdm53OXdBRqOw=;
        b=UEyV8vnpUpW+NN83awF7j+tcrV+2+anuRlR7y6pfFAJNWPDpa/mDudlINvyJcabjUe
         RqlISdXLHAX+LmcbI+ffeNzuoNhdBC09SkG61suTsxgj4NSedV2RuIGl545glmJ4jNZk
         qiNnoRvBzIi+am8c3fY+YIfoBh29z58MatSGsUVEbFltlQ9RbMFHZCix0GrUj72m2BFk
         GBMGmusvV9Uqg5cWyY1ITp6K4J8yGrJHh5z9mWqbtnLspL8UXhanUA+VmCg9xCAGVRoD
         Krs4K8GiJdnEUjUMI8Hh6WB1L9DolduZxVFlSF9a0TtyqBkiuJAHfxC7xQCeuwVtJuLy
         26NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679399364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xCEQEWiKcDx1SEV880+a7XA/x3hnnzOdm53OXdBRqOw=;
        b=wMRmvqPWrKQ9tqVM7RtexiC0CB9MEifmU5LR1OFArzz9QrETvK149ExFSLBQqttTel
         zHw9GVX71idFFQ85bKyAhHPb+V7CMW7pxFuygvVKbJVTeOXUUe5uHP04ZiJHSrLQN5zN
         kAul5//NLLGlyYTRx83wW0pR1gJaYA5DpShFolwktjhQZqboptVY+nXoNvYhb6JizoAC
         o8ruscT3er53UwzKAAa2uCn11m9fbixiJY58TDH+1hbHhoHDvhH8IpUkI8FyTViZcEgG
         Ga3WTNFQgp3wFJ+Dg6e2dUpX/9p0Jm0uv6vzGgxr2t+wQMQnMGoqyYt3hOJ+TmTpSxit
         nSGw==
X-Gm-Message-State: AO0yUKUsxBBAMZmR4euPDfx5pYZKUr2Ui4XeGU+sLqfknwTqxIoHhu0V
        gO+Ng6GI1z2JY2bX3BhbSoWulY78GWDRayioLIa8gg==
X-Google-Smtp-Source: AK7set852b08LGFSqKXqBritgLjnzc+n58HMNMF1QCiwD9PQmP6K2NTBZoyFIjyu1UfgC79tHAKHV6UE//r6ysijobE=
X-Received: by 2002:a05:6512:15b:b0:4dd:9931:c555 with SMTP id
 m27-20020a056512015b00b004dd9931c555mr899271lfo.0.1679399364210; Tue, 21 Mar
 2023 04:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230320232115.1940587-1-viktor@daynix.com> <20230321050747-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230321050747-mutt-send-email-mst@kernel.org>
From:   Viktor Prutyanov <viktor@daynix.com>
Date:   Tue, 21 Mar 2023 14:49:13 +0300
Message-ID: <CAPv0NP4bGi8o6fmZ93X==FEfBB6+NVDzyuoZNeX5TT3s8Trymg@mail.gmail.com>
Subject: Re: [PATCH v2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, cohuck@redhat.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 12:23=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Tue, Mar 21, 2023 at 02:21:15AM +0300, Viktor Prutyanov wrote:
> > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> > indicates that the driver passes extra data along with the queue
> > notifications.
> >
> > In a split queue case, the extra data is 16-bit available index. In a
> > packed queue case, the extra data is 1-bit wrap counter and 15-bit
> > available index.
> >
> > Add support for this feature for MMIO and PCI transports. Channel I/O
> > transport will not accept this feature.
> >
> > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> > ---
> >
> >  v2: reject the feature in virtio_ccw, replace __le32 with u32
> >
> >  drivers/s390/virtio/virtio_ccw.c   |  4 +---
> >  drivers/virtio/virtio_mmio.c       | 15 ++++++++++++++-
> >  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
> >  drivers/virtio/virtio_pci_common.h |  4 ++++
> >  drivers/virtio/virtio_pci_legacy.c |  2 +-
> >  drivers/virtio/virtio_pci_modern.c |  2 +-
> >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
> >  include/linux/virtio_ring.h        |  2 ++
> >  include/uapi/linux/virtio_config.h |  6 ++++++
> >  9 files changed, 56 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index a10dbe632ef9..d72a59415527 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -789,9 +789,7 @@ static u64 virtio_ccw_get_features(struct virtio_de=
vice *vdev)
> >
> >  static void ccw_transport_features(struct virtio_device *vdev)
> >  {
> > -     /*
> > -      * Currently nothing to do here.
> > -      */
> > +     __virtio_clear_bit(vdev, VIRTIO_F_NOTIFICATION_DATA);
> >  }
> >
> >  static int virtio_ccw_finalize_features(struct virtio_device *vdev)
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.=
c
> > index 3ff746e3f24a..0e13da17fe0a 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -285,6 +285,19 @@ static bool vm_notify(struct virtqueue *vq)
> >       return true;
> >  }
> >
> > +static bool vm_notify_with_data(struct virtqueue *vq)
> > +{
> > +     struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vq->v=
dev);
> > +     u32 data =3D vring_fill_notification_data(vq);
> > +
> > +     writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> > +
> > +     return true;
> > +}
> > +
> > +#define VM_NOTIFY(vdev) (__virtio_test_bit((vdev), VIRTIO_F_NOTIFICATI=
ON_DATA) \
> > +     ? vm_notify_with_data : vm_notify)
> > +
> >  /* Notify all virtqueues on an interrupt. */
> >  static irqreturn_t vm_interrupt(int irq, void *opaque)
> >  {
> > @@ -397,7 +410,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_=
device *vdev, unsigned int in
> >
> >       /* Create the vring */
> >       vq =3D vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN=
, vdev,
> > -                              true, true, ctx, vm_notify, callback, na=
me);
> > +                     true, true, ctx, VM_NOTIFY(vdev), callback, name)=
;
>
> I don't see why is this macro useful.
>
>
>
> >       if (!vq) {
> >               err =3D -ENOMEM;
> >               goto error_new_virtqueue;
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio=
_pci_common.c
> > index a6c86f916dbd..535263abc2bd 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -43,6 +43,16 @@ bool vp_notify(struct virtqueue *vq)
> >       /* we write the queue's selector into the notification register t=
o
> >        * signal the other end */
> >       iowrite16(vq->index, (void __iomem *)vq->priv);
> > +
> > +     return true;
> > +}
> > +
> > +bool vp_notify_with_data(struct virtqueue *vq)
> > +{
> > +     u32 data =3D vring_fill_notification_data(vq);
> > +
> > +     iowrite32(data, (void __iomem *)vq->priv);
> > +
> >       return true;
> >  }
> >
> > diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio=
_pci_common.h
> > index 23112d84218f..9a7212dcbb32 100644
> > --- a/drivers/virtio/virtio_pci_common.h
> > +++ b/drivers/virtio/virtio_pci_common.h
> > @@ -105,6 +105,7 @@ static struct virtio_pci_device *to_vp_device(struc=
t virtio_device *vdev)
> >  void vp_synchronize_vectors(struct virtio_device *vdev);
> >  /* the notify function used when creating a virt queue */
> >  bool vp_notify(struct virtqueue *vq);
> > +bool vp_notify_with_data(struct virtqueue *vq);
> >  /* the config->del_vqs() implementation */
> >  void vp_del_vqs(struct virtio_device *vdev);
> >  /* the config->find_vqs() implementation */
> > @@ -114,6 +115,9 @@ int vp_find_vqs(struct virtio_device *vdev, unsigne=
d int nvqs,
> >               struct irq_affinity *desc);
> >  const char *vp_bus_name(struct virtio_device *vdev);
> >
> > +#define VP_NOTIFY(vdev) (__virtio_test_bit((vdev), VIRTIO_F_NOTIFICATI=
ON_DATA) \
> > +     ? vp_notify : vp_notify_with_data)
> > +
> >  /* Setup the affinity for a virtqueue:
> >   * - force the affinity for per vq vector
> >   * - OR over all affinities for shared MSI
> > diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio=
_pci_legacy.c
> > index 2257f1b3d8ae..b98e994cae48 100644
> > --- a/drivers/virtio/virtio_pci_legacy.c
> > +++ b/drivers/virtio/virtio_pci_legacy.c
> > @@ -131,7 +131,7 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
> >       vq =3D vring_create_virtqueue(index, num,
> >                                   VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev=
,
> >                                   true, false, ctx,
> > -                                 vp_notify, callback, name);
> > +                                 VP_NOTIFY(&vp_dev->vdev), callback, n=
ame);
> >       if (!vq)
> >               return ERR_PTR(-ENOMEM);
> >
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index 9e496e288cfa..7fcd8af5af7e 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -321,7 +321,7 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
> >       vq =3D vring_create_virtqueue(index, num,
> >                                   SMP_CACHE_BYTES, &vp_dev->vdev,
> >                                   true, true, ctx,
> > -                                 vp_notify, callback, name);
> > +                                 VP_NOTIFY(&vp_dev->vdev), callback, n=
ame);
> >       if (!vq)
> >               return ERR_PTR(-ENOMEM);
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.=
c
> > index 723c4e29e1d3..5e9e1800bb6e 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2699,6 +2699,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
> >  }
> >  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
> >
> > +u32 vring_fill_notification_data(struct virtqueue *_vq)
> > +{
> > +     struct vring_virtqueue *vq =3D to_vvq(_vq);
> > +     u16 next;
> > +
> > +     if (vq->packed_ring)
> > +             next =3D (vq->packed.next_avail_idx & ~(1 << 15)) |
> > +                     ((u16)vq->packed.avail_wrap_counter << 15);
>
> I don't think the cast is needed. Neither is () around << the second <<
> here (first is needed because gcc chooses to complain: apparently it
> considers bitwise and a math operation for some obscure reason).
>
> > +     else
> > +             next =3D virtio16_to_cpu(_vq->vdev, vq->split.vring.avail=
->idx);
> > +
> > +     return ((u32)next << 16) | _vq->index;
>
> I don't think the cast is needed. Neither is () around << needed.
>
> > +}
> > +EXPORT_SYMBOL_GPL(vring_fill_notification_data);
> > +
>
> I'd inline this - it's on data path ...

As far as I see, to be inlined in virtio_mmio.c, virtio_pci_common.c
and virtio_ccw.c, the function should be defined in some header, but
definitions such as vring_virtqueue, vring_virtqueue_split,
vring_virtqueue_packed will not be available, because they are in
virtio_ring.c. Looks like, they must be moved to a separate header
in this case, isn't it?

>
> >  /* Manipulates transport-specific feature bits. */
> >  void vring_transport_features(struct virtio_device *vdev)
> >  {
>
> > @@ -2718,6 +2733,8 @@ void vring_transport_features(struct virtio_devic=
e *vdev)
> >                       break;
> >               case VIRTIO_F_ORDER_PLATFORM:
> >                       break;
> > +             case VIRTIO_F_NOTIFICATION_DATA:
> > +                     break;
> >               default:
> >                       /* We don't understand this bit. */
> >                       __virtio_clear_bit(vdev, i);
> > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> > index 8b8af1a38991..1f65d2f77012 100644
> > --- a/include/linux/virtio_ring.h
> > +++ b/include/linux/virtio_ring.h
> > @@ -101,4 +101,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
> >  void vring_transport_features(struct virtio_device *vdev);
> >
> >  irqreturn_t vring_interrupt(int irq, void *_vq);
> > +
> > +u32 vring_fill_notification_data(struct virtqueue *_vq);
> >  #endif /* _LINUX_VIRTIO_RING_H */
> > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/vi=
rtio_config.h
> > index 3c05162bc988..2c712c654165 100644
> > --- a/include/uapi/linux/virtio_config.h
> > +++ b/include/uapi/linux/virtio_config.h
> > @@ -99,6 +99,12 @@
> >   */
> >  #define VIRTIO_F_SR_IOV                      37
> >
> > +/*
> > + * This feature indicates that the driver passes extra data (besides
> > + * identifying the virtqueue) in its device notifications.
> > + */
> > +#define VIRTIO_F_NOTIFICATION_DATA   38
> > +
> >  /*
> >   * This feature indicates that the driver can reset a queue individual=
ly.
> >   */
> > --
> > 2.35.1
>
