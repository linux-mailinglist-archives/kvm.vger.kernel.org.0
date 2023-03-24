Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795FE6C792A
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 08:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjCXHok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 03:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCXHoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 03:44:39 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ABD22790
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 00:44:35 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 20so824891lju.0
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 00:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679643874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9w1qXuzTtwtpSj2jaTWarcEi2ki0FPlOD7K1WJkPeI=;
        b=AIMEMhitBUJFg/ULL1Mwz6MZIz8blqS35ugBFUm+XPssXpkDqb+Ps5GwhFjnJWnvQs
         HhogUgV32luvcOg7kvauU44h07ZFwR1OY+cIT6Ct0czOyp7Y4wCTHHyVfyHeZICSuGkG
         pLjrLoOIrxbxKuA898PGyCQvrshPIzrddoojZIw+lJaeN78vn69ycCtELnJmv6E89qcw
         rBM7ifEVLMbAppM2DvGF/NJifstnU6adrxVOQuZlT7DKa9N7dc0l86uO6iyw2h6Akdrs
         OKFkMk+4vLI6gqtEUmZFf2DUf0LKUbKpLSBYZZBTXeSetMtc9fNKfRjnDAEUmLS1tNYd
         oVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679643874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9w1qXuzTtwtpSj2jaTWarcEi2ki0FPlOD7K1WJkPeI=;
        b=DHSMc+9u3FfUfPjrU78oVHhEZd0vrgQh8PMtQYY0B0LxuoK9H1CFmquchAF/KTwDyE
         1IAG1qWRRJMz9SomFXMfvDemf4UyfzNr9mbQGq7FZHRVQRwBxNDxnegk/PdtRx+2gJ19
         Eic6OuM3krzLFltGhEHHfOCXi79yxLaQeep640l+Utr1j2KVmMcuQ8xTiq/wAxt3trfh
         n714zpVuCZyWHtmHMYaSeAD1RoU0KvXUsMAwUHsMR1k/MRW0lgxsZkwErjlMMPLvabbs
         o/ZoNtTN9ZrCofatfQo7+Ib1hfVUdwVOXFPk0lFhLtfpuKG0mpzHcc0RvHDveZb+rdey
         LCOg==
X-Gm-Message-State: AAQBX9eoVGfBBz9AUKMshp/uNVeO2rdpqNMpA0cdz/DFMlRCci0MwWcL
        TaMKMsueo+oLSWs5qb3sU0G/JB90biFIgNQg6ljnyw==
X-Google-Smtp-Source: AKy350ZibvxZC3E8dTFsIlI/8oigkLc6N5q6smkSLUPq5mp+R5NijLPFAldMTF7XNtRKhy1xT2wuPma8TZMHAY6uaoM=
X-Received: by 2002:a2e:95cc:0:b0:298:7034:836e with SMTP id
 y12-20020a2e95cc000000b002987034836emr564898ljh.8.1679643874075; Fri, 24 Mar
 2023 00:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230323085551.2346411-1-viktor@daynix.com> <CACGkMEsTpdES6Gzsx7eobJsac8a1V0dqfRm3vExrd1e+TJ_bVg@mail.gmail.com>
 <20230324011454-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230324011454-mutt-send-email-mst@kernel.org>
From:   Viktor Prutyanov <viktor@daynix.com>
Date:   Fri, 24 Mar 2023 10:44:23 +0300
Message-ID: <CAPv0NP6EM_49nDPALhhjVNDgbOCyYjQTKzK7Zr=J+BNVOVRiWw@mail.gmail.com>
Subject: Re: [PATCH v5] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, cohuck@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 8:31=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, Mar 24, 2023 at 11:09:19AM +0800, Jason Wang wrote:
> > On Thu, Mar 23, 2023 at 4:56=E2=80=AFPM Viktor Prutyanov <viktor@daynix=
.com> wrote:
> > >
> > > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> > > indicates that the driver passes extra data along with the queue
> > > notifications.
> > >
> > > In a split queue case, the extra data is 16-bit available index. In a
> > > packed queue case, the extra data is 1-bit wrap counter and 15-bit
> > > available index.
> > >
> > > Add support for this feature for MMIO, channel I/O and modern PCI
> > > transports.
> > >
> > > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> > > ---
> > >  v5: replace ternary operator with if-else
> > >  v4: remove VP_NOTIFY macro and legacy PCI support, add
> > >     virtio_ccw_kvm_notify_with_data to virtio_ccw
> > >  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_s=
hadow,
> > >     remove byte swap, rename to vring_notification_data
> > >  v2: reject the feature in virtio_ccw, replace __le32 with u32
> > >
> > >  Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
> > >  (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
> > >  virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-p=
ci)
> > >  to make sure nothing is broken.
> > >  Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linu=
x
> > >  and my hardware implementation of virtio-rng with MMIO.
> > >
> > >  drivers/s390/virtio/virtio_ccw.c   | 22 +++++++++++++++++++---
> > >  drivers/virtio/virtio_mmio.c       | 18 +++++++++++++++++-
> > >  drivers/virtio/virtio_pci_modern.c | 17 ++++++++++++++++-
> > >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
> > >  include/linux/virtio_ring.h        |  2 ++
> > >  include/uapi/linux/virtio_config.h |  6 ++++++
> > >  6 files changed, 77 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/v=
irtio_ccw.c
> > > index 954fc31b4bc7..9a9c5d34454c 100644
> > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > @@ -391,7 +391,7 @@ static void virtio_ccw_drop_indicator(struct virt=
io_ccw_device *vcdev,
> > >         ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinin=
t_area));
> > >  }
> > >
> > > -static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> > > +static inline bool virtio_ccw_do_kvm_notify(struct virtqueue *vq, u3=
2 data)
> > >  {
> > >         struct virtio_ccw_vq_info *info =3D vq->priv;
> > >         struct virtio_ccw_device *vcdev;
> > > @@ -402,12 +402,22 @@ static bool virtio_ccw_kvm_notify(struct virtqu=
eue *vq)
> > >         BUILD_BUG_ON(sizeof(struct subchannel_id) !=3D sizeof(unsigne=
d int));
> > >         info->cookie =3D kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
> > >                                       *((unsigned int *)&schid),
> > > -                                     vq->index, info->cookie);
> > > +                                     data, info->cookie);
> > >         if (info->cookie < 0)
> > >                 return false;
> > >         return true;
> > >  }
> > >
> > > +static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> > > +{
> > > +       return virtio_ccw_do_kvm_notify(vq, vq->index);
> > > +}
> > > +
> > > +static bool virtio_ccw_kvm_notify_with_data(struct virtqueue *vq)
> > > +{
> > > +       return virtio_ccw_do_kvm_notify(vq, vring_notification_data(v=
q));
> > > +}
> > > +
> > >  static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
> > >                                    struct ccw1 *ccw, int index)
> > >  {
> > > @@ -501,6 +511,12 @@ static struct virtqueue *virtio_ccw_setup_vq(str=
uct virtio_device *vdev,
> > >         u64 queue;
> > >         unsigned long flags;
> > >         bool may_reduce;
> > > +       bool (*notify)(struct virtqueue *vq);
> > > +
> > > +       if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
> > > +               notify =3D virtio_ccw_kvm_notify_with_data;
> > > +       else
> > > +               notify =3D virtio_ccw_kvm_notify;
> > >
> > >         /* Allocate queue. */
> > >         info =3D kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNE=
L);
> > > @@ -524,7 +540,7 @@ static struct virtqueue *virtio_ccw_setup_vq(stru=
ct virtio_device *vdev,
> > >         may_reduce =3D vcdev->revision > 0;
> > >         vq =3D vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RI=
NG_ALIGN,
> > >                                     vdev, true, may_reduce, ctx,
> > > -                                   virtio_ccw_kvm_notify, callback, =
name);
> > > +                                   notify, callback, name);
> > >
> > >         if (!vq) {
> > >                 /* For now, we fail if we can't get the requested siz=
e. */
> > > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmi=
o.c
> > > index 3ff746e3f24a..7e87f745f68d 100644
> > > --- a/drivers/virtio/virtio_mmio.c
> > > +++ b/drivers/virtio/virtio_mmio.c
> > > @@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
> > >         return true;
> > >  }
> > >
> > > +static bool vm_notify_with_data(struct virtqueue *vq)
> > > +{
> > > +       struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(v=
q->vdev);
> > > +       u32 data =3D vring_notification_data(vq);
> > > +
> > > +       writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> > > +
> > > +       return true;
> > > +}
> > > +
> > >  /* Notify all virtqueues on an interrupt. */
> > >  static irqreturn_t vm_interrupt(int irq, void *opaque)
> > >  {
> > > @@ -368,6 +378,12 @@ static struct virtqueue *vm_setup_vq(struct virt=
io_device *vdev, unsigned int in
> > >         unsigned long flags;
> > >         unsigned int num;
> > >         int err;
> > > +       bool (*notify)(struct virtqueue *vq);
> > > +
> > > +       if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
> > > +               notify =3D vm_notify_with_data;
> > > +       else
> > > +               notify =3D vm_notify;
> > >
> > >         if (!name)
> > >                 return NULL;
> > > @@ -397,7 +413,7 @@ static struct virtqueue *vm_setup_vq(struct virti=
o_device *vdev, unsigned int in
> > >
> > >         /* Create the vring */
> > >         vq =3D vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_A=
LIGN, vdev,
> > > -                                true, true, ctx, vm_notify, callback=
, name);
> > > +                                true, true, ctx, notify, callback, n=
ame);
> > >         if (!vq) {
> > >                 err =3D -ENOMEM;
> > >                 goto error_new_virtqueue;
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virt=
io_pci_modern.c
> > > index 9e496e288cfa..3bfc368b279e 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -288,6 +288,15 @@ static u16 vp_config_vector(struct virtio_pci_de=
vice *vp_dev, u16 vector)
> > >         return vp_modern_config_vector(&vp_dev->mdev, vector);
> > >  }
> > >
> > > +static bool vp_notify_with_data(struct virtqueue *vq)
> > > +{
> > > +       u32 data =3D vring_notification_data(vq);
> > > +
> > > +       iowrite32(data, (void __iomem *)vq->priv);
> > > +
> > > +       return true;
> > > +}
> > > +
> > >  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> > >                                   struct virtio_pci_vq_info *info,
> > >                                   unsigned int index,
> > > @@ -301,6 +310,12 @@ static struct virtqueue *setup_vq(struct virtio_=
pci_device *vp_dev,
> > >         struct virtqueue *vq;
> > >         u16 num;
> > >         int err;
> > > +       bool (*notify)(struct virtqueue *vq);
> > > +
> > > +       if (__virtio_test_bit(&vp_dev->vdev, VIRTIO_F_NOTIFICATION_DA=
TA))
> > > +               notify =3D vp_notify_with_data;
> > > +       else
> > > +               notify =3D vp_notify;
> > >
> > >         if (index >=3D vp_modern_get_num_queues(mdev))
> > >                 return ERR_PTR(-EINVAL);
> > > @@ -321,7 +336,7 @@ static struct virtqueue *setup_vq(struct virtio_p=
ci_device *vp_dev,
> > >         vq =3D vring_create_virtqueue(index, num,
> > >                                     SMP_CACHE_BYTES, &vp_dev->vdev,
> > >                                     true, true, ctx,
> > > -                                   vp_notify, callback, name);
> > > +                                   notify, callback, name);
> > >         if (!vq)
> > >                 return ERR_PTR(-ENOMEM);
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_rin=
g.c
> > > index 4c3bb0ddeb9b..837875cc3190 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -2752,6 +2752,21 @@ void vring_del_virtqueue(struct virtqueue *_vq=
)
> > >  }
> > >  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
> > >
> > > +u32 vring_notification_data(struct virtqueue *_vq)
> > > +{
> > > +       struct vring_virtqueue *vq =3D to_vvq(_vq);
> > > +       u16 next;
> > > +
> > > +       if (vq->packed_ring)
> > > +               next =3D (vq->packed.next_avail_idx & ~(1 << 15)) |
> > > +                       vq->packed.avail_wrap_counter << 15;
> >
> > Nit: We have VRING_PACKED_EVENT_F_WRAP_CTR which could be used for
> > replacing 15 here.
> >
> > And we have many places for packing them into u16, it might be better
> > to introduce a helper.
>
> Not sure about a helper, I'd leave that for a future cleanup.
>
> However I would use
>
> & (-(1 << VRING_PACKED_EVENT_F_WRAP_CTR))

Do you mean
& (~(1 << VRING_PACKED_EVENT_F_WRAP_CTR))
or maybe I missed something?

>
> that's more robust - works for any value of VRING_PACKED_EVENT_F_WRAP_CTR
> giving low bits 0 to VRING_PACKED_EVENT_F_WRAP_CTR,
> and will keep working if someone copypasted it and changed
> counter to a value different from 15.
>
>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> >
> > Thanks
> >
> > > +       else
> > > +               next =3D vq->split.avail_idx_shadow;
> > > +
> > > +       return next << 16 | _vq->index;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vring_notification_data);
> > > +
> > >  /* Manipulates transport-specific feature bits. */
> > >  void vring_transport_features(struct virtio_device *vdev)
> > >  {
> > > @@ -2771,6 +2786,8 @@ void vring_transport_features(struct virtio_dev=
ice *vdev)
> > >                         break;
> > >                 case VIRTIO_F_ORDER_PLATFORM:
> > >                         break;
> > > +               case VIRTIO_F_NOTIFICATION_DATA:
> > > +                       break;
> > >                 default:
> > >                         /* We don't understand this bit. */
> > >                         __virtio_clear_bit(vdev, i);
> > > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.=
h
> > > index 8b95b69ef694..2550c9170f4f 100644
> > > --- a/include/linux/virtio_ring.h
> > > +++ b/include/linux/virtio_ring.h
> > > @@ -117,4 +117,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
> > >  void vring_transport_features(struct virtio_device *vdev);
> > >
> > >  irqreturn_t vring_interrupt(int irq, void *_vq);
> > > +
> > > +u32 vring_notification_data(struct virtqueue *_vq);
> > >  #endif /* _LINUX_VIRTIO_RING_H */
> > > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/=
virtio_config.h
> > > index 3c05162bc988..2c712c654165 100644
> > > --- a/include/uapi/linux/virtio_config.h
> > > +++ b/include/uapi/linux/virtio_config.h
> > > @@ -99,6 +99,12 @@
> > >   */
> > >  #define VIRTIO_F_SR_IOV                        37
> > >
> > > +/*
> > > + * This feature indicates that the driver passes extra data (besides
> > > + * identifying the virtqueue) in its device notifications.
> > > + */
> > > +#define VIRTIO_F_NOTIFICATION_DATA     38
> > > +
> > >  /*
> > >   * This feature indicates that the driver can reset a queue individu=
ally.
> > >   */
> > > --
> > > 2.35.1
> > >
>
