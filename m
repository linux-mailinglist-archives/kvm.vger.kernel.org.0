Return-Path: <kvm+bounces-12971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1C588F803
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 07:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B393A29797A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:36:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6092D052;
	Thu, 28 Mar 2024 06:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Tl3z5jfp"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EAD21101;
	Thu, 28 Mar 2024 06:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607795; cv=none; b=FOuYAWePihZ4l/CWu13DXMqkXFVg/g4BsOFX/SiCGshSsv4dkLg3Y7sInjSBLI3bgHJP14af4hETIcdptdOuJ2LmMZfK/aTpan8E4AFVrC+AW/0s4gxu07Oa/ce/0TM3GM/MxQhzzIkvUGR6dv6smUj+/xHaC08Oorgj9T4K/5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607795; c=relaxed/simple;
	bh=BVgXDDR4fE8RUTJuomzxI5gWmO7lcX+hHgsE2YpxZNE=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=MY+gPvzT/upagM959mOdN077EJhvLEWqdWPa3cwnxvvOq3aLA/qr+vqlZb6oe9M08it8JqMENRVeg0UC+MZAfioSQGXgtjToB2IOM4N5HsSwjTLwSyqwsiHmxljdb4AQy/XsHy+QpuoDr0KEOtaWKDyz0GFiuRR+27KslVMZBm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Tl3z5jfp; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711607790; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=MdsRtpsETPSDV9a2OLHr4zV3VI6K5kBQSHV1t1/MGHY=;
	b=Tl3z5jfpvo3OeGPxNBb+Vo4RmEQ95PExLDj01DfP7P2HucHenwjHzO/L3qmPzYf7u9hVjYUD9CI+m7jF1maDN/fipZGahS+jfQXgRrNzU1iZ4u0GbAU5iOJDrzxayHufDuPOfo6WgT+mTgMeCcCEv65ki4RvoElXuBUUCYv6REQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W3R40rF_1711607788;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3R40rF_1711607788)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 14:36:29 +0800
Message-ID: <1711607764.9887197-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v6 2/6] virtio: remove support for names array entries being null.
Date: Thu, 28 Mar 2024 14:36:04 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 David Hildenbrand <david@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240327095741.88135-1-xuanzhuo@linux.alibaba.com>
 <20240327095741.88135-3-xuanzhuo@linux.alibaba.com>
 <CACGkMEtvf98gRQCB1qDY+fR-2xD-Xya_dnFcb1j_o0bnVqA5ow@mail.gmail.com>
In-Reply-To: <CACGkMEtvf98gRQCB1qDY+fR-2xD-Xya_dnFcb1j_o0bnVqA5ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 28 Mar 2024 12:19:04 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Wed, Mar 27, 2024 at 5:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> > support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
> > doesn't apply. And not one uses this.
> >
> > On the other side, that makes some trouble for us to refactor the
> > find_vqs() params.
> >
> > So I remove this support.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  arch/um/drivers/virtio_uml.c           |  8 ++++----
> >  drivers/remoteproc/remoteproc_virtio.c | 11 ++++-------
> >  drivers/s390/virtio/virtio_ccw.c       |  8 ++++----
> >  drivers/virtio/virtio_mmio.c           |  8 ++++----
> >  drivers/virtio/virtio_pci_common.c     | 18 +++++++++---------
> >  drivers/virtio/virtio_vdpa.c           | 11 ++++-------
> >  include/linux/virtio_config.h          |  2 +-
> >  7 files changed, 30 insertions(+), 36 deletions(-)
> >
> > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > index 8adca2000e51..773f9fc4d582 100644
> > --- a/arch/um/drivers/virtio_uml.c
> > +++ b/arch/um/drivers/virtio_uml.c
> > @@ -1019,8 +1019,8 @@ static int vu_find_vqs(struct virtio_device *vdev=
, unsigned nvqs,
> >                        struct irq_affinity *desc)
> >  {
> >         struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
> > -       int i, queue_idx =3D 0, rc;
> >         struct virtqueue *vq;
> > +       int i, rc;
> >
> >         /* not supported for now */
> >         if (WARN_ON(nvqs > 64))
> > @@ -1032,11 +1032,11 @@ static int vu_find_vqs(struct virtio_device *vd=
ev, unsigned nvqs,
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> >                 if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > +                       rc =3D -EINVAL;
> > +                       goto error_setup;
> >                 }
> >
> > -               vqs[i] =3D vu_setup_vq(vdev, queue_idx++, callbacks[i],=
 names[i],
> > +               vqs[i] =3D vu_setup_vq(vdev, i, callbacks[i], names[i],
> >                                      ctx ? ctx[i] : false);
> >                 if (IS_ERR(vqs[i])) {
> >                         rc =3D PTR_ERR(vqs[i]);
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remotepro=
c/remoteproc_virtio.c
> > index 83d76915a6ad..8fb5118b6953 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -119,9 +119,6 @@ static struct virtqueue *rp_find_vq(struct virtio_d=
evice *vdev,
> >         if (id >=3D ARRAY_SIZE(rvdev->vring))
> >                 return ERR_PTR(-EINVAL);
> >
> > -       if (!name)
> > -               return NULL;
> > -
> >         /* Search allocated memory region by name */
> >         mem =3D rproc_find_carveout_by_name(rproc, "vdev%dvring%d", rvd=
ev->index,
> >                                           id);
> > @@ -187,15 +184,15 @@ static int rproc_virtio_find_vqs(struct virtio_de=
vice *vdev, unsigned int nvqs,
> >                                  const bool * ctx,
> >                                  struct irq_affinity *desc)
> >  {
> > -       int i, ret, queue_idx =3D 0;
> > +       int i, ret;
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> >                 if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > +                       ret =3D -EINVAL;
> > +                       goto error;
> >                 }
> >
> > -               vqs[i] =3D rp_find_vq(vdev, queue_idx++, callbacks[i], =
names[i],
> > +               vqs[i] =3D rp_find_vq(vdev, i, callbacks[i], names[i],
> >                                     ctx ? ctx[i] : false);
> >                 if (IS_ERR(vqs[i])) {
> >                         ret =3D PTR_ERR(vqs[i]);
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index ac67576301bf..508154705554 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -659,7 +659,7 @@ static int virtio_ccw_find_vqs(struct virtio_device=
 *vdev, unsigned nvqs,
> >  {
> >         struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> >         unsigned long *indicatorp =3D NULL;
> > -       int ret, i, queue_idx =3D 0;
> > +       int ret, i;
> >         struct ccw1 *ccw;
> >
> >         ccw =3D ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
> > @@ -668,11 +668,11 @@ static int virtio_ccw_find_vqs(struct virtio_devi=
ce *vdev, unsigned nvqs,
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> >                 if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > +                       ret =3D -EINVAL;
> > +                       goto out;
> >                 }
> >
> > -               vqs[i] =3D virtio_ccw_setup_vq(vdev, queue_idx++, callb=
acks[i],
> > +               vqs[i] =3D virtio_ccw_setup_vq(vdev, i, callbacks[i],
>
> Nit:
>
> This seems an unnecessary change or we need to remove the queue_idx varia=
ble.


YES. queue_idx is removed.

Thanks.


>
> >                                              names[i], ctx ? ctx[i] : f=
alse,
> >                                              ccw);
> >                 if (IS_ERR(vqs[i])) {
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index 59892a31cf76..82ee4a288728 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -496,7 +496,7 @@ static int vm_find_vqs(struct virtio_device *vdev, =
unsigned int nvqs,
> >  {
> >         struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vde=
v);
> >         int irq =3D platform_get_irq(vm_dev->pdev, 0);
> > -       int i, err, queue_idx =3D 0;
> > +       int i, err;
> >
> >         if (irq < 0)
> >                 return irq;
> > @@ -511,11 +511,11 @@ static int vm_find_vqs(struct virtio_device *vdev=
, unsigned int nvqs,
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> >                 if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > +                       vm_del_vqs(vdev);
> > +                       return -EINVAL;
> >                 }
> >
> > -               vqs[i] =3D vm_setup_vq(vdev, queue_idx++, callbacks[i],=
 names[i],
> > +               vqs[i] =3D vm_setup_vq(vdev, i, callbacks[i], names[i],
>
> Similar issue as above.
>
> >                                      ctx ? ctx[i] : false);
> >                 if (IS_ERR(vqs[i])) {
> >                         vm_del_vqs(vdev);
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio=
_pci_common.c
> > index b655fccaf773..eda71c6e87ee 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -292,7 +292,7 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
> >  {
> >         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> >         u16 msix_vec;
> > -       int i, err, nvectors, allocated_vectors, queue_idx =3D 0;
> > +       int i, err, nvectors, allocated_vectors;
> >
> >         vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> >         if (!vp_dev->vqs)
> > @@ -302,7 +302,7 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
> >                 /* Best option: one for change interrupt, one per vq. */
> >                 nvectors =3D 1;
> >                 for (i =3D 0; i < nvqs; ++i)
> > -                       if (names[i] && callbacks[i])
> > +                       if (callbacks[i])
> >                                 ++nvectors;
> >         } else {
> >                 /* Second best: one for change, shared for all vqs. */
> > @@ -318,8 +318,8 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
> >         allocated_vectors =3D vp_dev->msix_used_vectors;
> >         for (i =3D 0; i < nvqs; ++i) {
> >                 if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > +                       err =3D -EINVAL;
> > +                       goto error_find;
> >                 }
> >
> >                 if (!callbacks[i])
> > @@ -328,7 +328,7 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
> >                         msix_vec =3D allocated_vectors++;
> >                 else
> >                         msix_vec =3D VP_MSIX_VQ_VECTOR;
> > -               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, callbacks[i],=
 names[i],
> > +               vqs[i] =3D vp_setup_vq(vdev, i, callbacks[i], names[i],
> >                                      ctx ? ctx[i] : false,
> >                                      msix_vec);
> >                 if (IS_ERR(vqs[i])) {
> > @@ -363,7 +363,7 @@ static int vp_find_vqs_intx(struct virtio_device *v=
dev, unsigned int nvqs,
> >                 const char * const names[], const bool *ctx)
> >  {
> >         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > -       int i, err, queue_idx =3D 0;
> > +       int i, err;
> >
> >         vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> >         if (!vp_dev->vqs)
> > @@ -378,10 +378,10 @@ static int vp_find_vqs_intx(struct virtio_device =
*vdev, unsigned int nvqs,
> >         vp_dev->per_vq_vectors =3D false;
> >         for (i =3D 0; i < nvqs; ++i) {
> >                 if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > +                       err =3D -EINVAL;
> > +                       goto out_del_vqs;
> >                 }
> > -               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, callbacks[i],=
 names[i],
> > +               vqs[i] =3D vp_setup_vq(vdev, i, callbacks[i], names[i],
> >                                      ctx ? ctx[i] : false,
> >                                      VIRTIO_MSI_NO_VECTOR);
> >                 if (IS_ERR(vqs[i])) {
> > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> > index e803db0da307..e82cca24d6e6 100644
> > --- a/drivers/virtio/virtio_vdpa.c
> > +++ b/drivers/virtio/virtio_vdpa.c
> > @@ -161,9 +161,6 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, un=
signed int index,
> >         bool may_reduce_num =3D true;
> >         int err;
> >
> > -       if (!name)
> > -               return NULL;
> > -
> >         if (index >=3D vdpa->nvqs)
> >                 return ERR_PTR(-ENOENT);
> >
> > @@ -370,7 +367,7 @@ static int virtio_vdpa_find_vqs(struct virtio_devic=
e *vdev, unsigned int nvqs,
> >         struct cpumask *masks;
> >         struct vdpa_callback cb;
> >         bool has_affinity =3D desc && ops->set_vq_affinity;
> > -       int i, err, queue_idx =3D 0;
> > +       int i, err;
> >
> >         if (has_affinity) {
> >                 masks =3D create_affinity_masks(nvqs, desc ? desc : &de=
fault_affd);
> > @@ -380,11 +377,11 @@ static int virtio_vdpa_find_vqs(struct virtio_dev=
ice *vdev, unsigned int nvqs,
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> >                 if (!names[i]) {
> > -                       vqs[i] =3D NULL;
> > -                       continue;
> > +                       err =3D -EINVAL;
> > +                       goto err_setup_vq;
> >                 }
> >
> > -               vqs[i] =3D virtio_vdpa_setup_vq(vdev, queue_idx++,
> > +               vqs[i] =3D virtio_vdpa_setup_vq(vdev, i,
>
> And here.
>
> With those fixed.
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>
> >                                               callbacks[i], names[i], c=
tx ?
> >                                               ctx[i] : false);
> >                 if (IS_ERR(vqs[i])) {
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_confi=
g.h
> > index da9b271b54db..1c79cec258f4 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -56,7 +56,7 @@ typedef void vq_callback_t(struct virtqueue *);
> >   *     callbacks: array of callbacks, for each virtqueue
> >   *             include a NULL entry for vqs that do not need a callback
> >   *     names: array of virtqueue names (mainly for debugging)
> > - *             include a NULL entry for vqs unused by driver
> > + *             MUST NOT be NULL
> >   *     Returns 0 on success or error status
> >   * @del_vqs: free virtqueues found by find_vqs().
> >   * @synchronize_cbs: synchronize with the virtqueue callbacks (optiona=
l)
> > --
> > 2.32.0.3.g01195cf9f
> >
> >
>

