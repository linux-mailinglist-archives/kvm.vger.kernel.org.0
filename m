Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CC62D54B7
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 08:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbgLJHf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 02:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730200AbgLJHf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 02:35:28 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E0DC0613D6
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 23:34:47 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so4407307edt.9
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 23:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mSANjgZFKBTbLfirnhu44h57UiUDVANz4g/iDt0zUqE=;
        b=P3RuHJVxn6YAscp7RFXqlxbE+CSiNKMKCk9kVETVVlfQ+1fRD7SchbmWu3KPbDldjY
         4Gy3VFXjUL+BGfEniryNzWz7XAcVS7UHkE/T7Y35CLqiv28OkzW+Cs4R5uXCbmRsm4oL
         IyG/OtJteI88IhGFPe543c396CWUJd/DVoRB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSANjgZFKBTbLfirnhu44h57UiUDVANz4g/iDt0zUqE=;
        b=mKDBlQ6VtuyGhfIw2IsZSgMxJaVPcNj+Cid9H1trNke4eJPJCIHyzo31RivFkzrayJ
         o+DrOPBn/XgmpngS7EY46XO7VCz7gG7cZuCqnvBVXpNij3wFKBXBVolkysR6i5Ebeutx
         qPf8eGC4uPgC7/RTaxUHb3OAWIWjmMrioYXFiQvLQIUJk7I1tKohCJMZ+o/yjWmYzvL9
         +o5bQ3uy1kWe5f4rjY266dkkZzLpW5tmQGhFAoo2wuvQBXygK9OnyTJq58X1rjIrj4T9
         31uW8Tc39LIGWWtw1I/jRokMrRtAbf4n9TtgyIrMcLRPopKufBN009owL317Q7D2hv0Y
         K01g==
X-Gm-Message-State: AOAM533X9oGjCV7DlAK/rHgSytOQW+LbZL3sN/VWaiLyyVgZpQfoYyQZ
        HZyXeVsTkYZeYQUwKwgzApqtCM5qQ3HG6x6TvvN/AxFhmf/LAvJdPhxGRaVrzJC5MOdgsUd3EfG
        slqDy4qTFs/ZWpDVS58k=
X-Google-Smtp-Source: ABdhPJz7Enhhit2gCtN7FNRzJo/EX2/trnN7n/gkwlp2DQpO0WVubgWsiBU2DbJAfHjkV7v88+4qwuKhRAbld2yAKK4=
X-Received: by 2002:aa7:d41a:: with SMTP id z26mr5525844edq.267.1607585685748;
 Wed, 09 Dec 2020 23:34:45 -0800 (PST)
MIME-Version: 1.0
References: <20201112175852.21572-1-vikas.gupta@broadcom.com>
 <20201124161646.41191-1-vikas.gupta@broadcom.com> <20201124161646.41191-2-vikas.gupta@broadcom.com>
 <73830e85-035f-88ac-7aec-a818e83c2d5a@redhat.com> <CAHLZf_tgZ7H76H3WjqXrSQeCC_CmKLrY6t46Ce-7Qo10TpMVZg@mail.gmail.com>
 <1871c5ad-9593-1a29-4f30-b21f337fd1be@redhat.com>
In-Reply-To: <1871c5ad-9593-1a29-4f30-b21f337fd1be@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Thu, 10 Dec 2020 13:04:33 +0530
Message-ID: <CAHLZf_uXRasOwt4FLrkYv8xyPeavFKUM-2CbrOuZn10N_z9n5Q@mail.gmail.com>
Subject: Re: [RFC v2 1/1] vfio/platform: add support for msi
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Ashwin Kamath <ashwin.kamath@broadcom.com>,
        Zac Schroff <zachary.schroff@broadcom.com>,
        Manish Kurup <manish.kurup@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c9f07905b61735bc"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--000000000000c9f07905b61735bc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

HI Eric,

On Tue, Dec 8, 2020 at 2:13 AM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
>
> On 12/3/20 3:50 PM, Vikas Gupta wrote:
> > Hi Eric,
> >
> > On Wed, Dec 2, 2020 at 8:14 PM Auger Eric <eric.auger@redhat.com> wrote=
:
> >>
> >> Hi Vikas,
> >>
> >> On 11/24/20 5:16 PM, Vikas Gupta wrote:
> >>> MSI support for platform devices.
> >>>
> >>> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> >>> ---
> >>>  drivers/vfio/platform/vfio_platform_common.c  |  99 ++++++-
> >>>  drivers/vfio/platform/vfio_platform_irq.c     | 260 ++++++++++++++++=
+-
> >>>  drivers/vfio/platform/vfio_platform_private.h |  16 ++
> >>>  include/uapi/linux/vfio.h                     |  43 +++
> >>>  4 files changed, 401 insertions(+), 17 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/v=
fio/platform/vfio_platform_common.c
> >>> index c0771a9567fb..b0bfc0f4ee1f 100644
> >>> --- a/drivers/vfio/platform/vfio_platform_common.c
> >>> +++ b/drivers/vfio/platform/vfio_platform_common.c
> >>> @@ -16,6 +16,7 @@
> >>>  #include <linux/types.h>
> >>>  #include <linux/uaccess.h>
> >>>  #include <linux/vfio.h>
> >>> +#include <linux/nospec.h>
> >>>
> >>>  #include "vfio_platform_private.h"
> >>>
> >>> @@ -344,9 +345,16 @@ static long vfio_platform_ioctl(void *device_dat=
a,
> >>>
> >>>       } else if (cmd =3D=3D VFIO_DEVICE_GET_IRQ_INFO) {
> >>>               struct vfio_irq_info info;
> >>> +             struct vfio_info_cap caps =3D { .buf =3D NULL, .size =
=3D 0 };
> >>> +             struct vfio_irq_info_cap_msi *msi_info =3D NULL;
> >>> +             unsigned long capsz;
> >>> +             int ext_irq_index =3D vdev->num_irqs - vdev->num_ext_ir=
qs;
> >>>
> >>>               minsz =3D offsetofend(struct vfio_irq_info, count);
> >>>
> >>> +             /* For backward compatibility, cannot require this */
> >>> +             capsz =3D offsetofend(struct vfio_irq_info, cap_offset)=
;
> >>> +
> >>>               if (copy_from_user(&info, (void __user *)arg, minsz))
> >>>                       return -EFAULT;
> >>>
> >>> @@ -356,9 +364,89 @@ static long vfio_platform_ioctl(void *device_dat=
a,
> >>>               if (info.index >=3D vdev->num_irqs)
> >>>                       return -EINVAL;
> >>>
> >>> +             if (info.argsz >=3D capsz)
> >>> +                     minsz =3D capsz;
> >>> +
> >>> +             if (info.index =3D=3D ext_irq_index) {
> >> nit: n case we add new ext indices afterwards, I would check info.inde=
x
> >> -  ext_irq_index against an VFIO_EXT_IRQ_MSI define.
> >>> +                     struct vfio_irq_info_cap_type cap_type =3D {
> >>> +                             .header.id =3D VFIO_IRQ_INFO_CAP_TYPE,
> >>> +                             .header.version =3D 1 };
> >>> +                     int i;
> >>> +                     int ret;
> >>> +                     int num_msgs;
> >>> +                     size_t msi_info_size;
> >>> +                     struct vfio_platform_irq *irq;
> >> nit: I think generally the opposite order (length) is chosen. This als=
o
> >> would better match the existing style in this file
> > Ok will fix it
> >>> +
> >>> +                     info.index =3D array_index_nospec(info.index,
> >>> +                                                     vdev->num_irqs)=
;
> >>> +
> >>> +                     irq =3D &vdev->irqs[info.index];
> >>> +
> >>> +                     info.flags =3D irq->flags;
> >> I think this can be removed given [*]
> > Sure.
> >>> +                     cap_type.type =3D irq->type;
> >>> +                     cap_type.subtype =3D irq->subtype;
> >>> +
> >>> +                     ret =3D vfio_info_add_capability(&caps,
> >>> +                                                    &cap_type.header=
,
> >>> +                                                    sizeof(cap_type)=
);
> >>> +                     if (ret)
> >>> +                             return ret;
> >>> +
> >>> +                     num_msgs =3D irq->num_ctx;
> >> do would want to return the cap even if !num_ctx?
> > If num_ctx =3D 0 then VFIO_IRQ_INFO_CAP_MSI_DESCS should not be written=
.
> > I`ll take care of same.
> >>> +
> >>> +                     msi_info_size =3D struct_size(msi_info, msgs, n=
um_msgs);
> >>> +
> >>> +                     msi_info =3D kzalloc(msi_info_size, GFP_KERNEL)=
;
> >>> +                     if (!msi_info) {
> >>> +                             kfree(caps.buf);
> >>> +                             return -ENOMEM;
> >>> +                     }
> >>> +
> >>> +                     msi_info->header.id =3D VFIO_IRQ_INFO_CAP_MSI_D=
ESCS;
> >>> +                     msi_info->header.version =3D 1;
> >>> +                     msi_info->nr_msgs =3D num_msgs;
> >>> +
> >>> +                     for (i =3D 0; i < num_msgs; i++) {
> >>> +                             struct vfio_irq_ctx *ctx =3D &irq->ctx[=
i];
> >>> +
> >>> +                             msi_info->msgs[i].addr_lo =3D ctx->msg.=
address_lo;
> >>> +                             msi_info->msgs[i].addr_hi =3D ctx->msg.=
address_hi;
> >>> +                             msi_info->msgs[i].data =3D ctx->msg.dat=
a;
> >>> +                     }
> >>> +
> >>> +                     ret =3D vfio_info_add_capability(&caps, &msi_in=
fo->header,
> >>> +                                                    msi_info_size);
> >>> +                     if (ret) {
> >>> +                             kfree(msi_info);
> >>> +                             kfree(caps.buf);
> >>> +                             return ret;
> >>> +                     }
> >>> +             }
> >>> +
> >>>               info.flags =3D vdev->irqs[info.index].flags;
> >> [*]
> > Will fix it.
> >>>               info.count =3D vdev->irqs[info.index].count;
> >>>
> >>> +             if (caps.size) {
> >>> +                     info.flags |=3D VFIO_IRQ_INFO_FLAG_CAPS;
> >>> +                     if (info.argsz < sizeof(info) + caps.size) {
> >>> +                             info.argsz =3D sizeof(info) + caps.size=
;
> >>> +                             info.cap_offset =3D 0;
> >>> +                     } else {
> >>> +                             vfio_info_cap_shift(&caps, sizeof(info)=
);
> >>> +                             if (copy_to_user((void __user *)arg +
> >>> +                                               sizeof(info), caps.bu=
f,
> >>> +                                               caps.size)) {
> >>> +                                     kfree(msi_info);
> >>> +                                     kfree(caps.buf);
> >>> +                                     return -EFAULT;
> >>> +                             }
> >>> +                             info.cap_offset =3D sizeof(info);
> >>> +                     }
> >>> +
> >>> +                     kfree(msi_info);
> >>> +                     kfree(caps.buf);
> >>> +             }
> >>> +
> >>>               return copy_to_user((void __user *)arg, &info, minsz) ?
> >>>                       -EFAULT : 0;
> >>>
> >>> @@ -366,6 +454,7 @@ static long vfio_platform_ioctl(void *device_data=
,
> >>>               struct vfio_irq_set hdr;
> >>>               u8 *data =3D NULL;
> >>>               int ret =3D 0;
> >>> +             int max;
> >>>               size_t data_size =3D 0;
> >>>
> >>>               minsz =3D offsetofend(struct vfio_irq_set, count);
> >>> @@ -373,8 +462,14 @@ static long vfio_platform_ioctl(void *device_dat=
a,
> >>>               if (copy_from_user(&hdr, (void __user *)arg, minsz))
> >>>                       return -EFAULT;
> >>>
> >>> -             ret =3D vfio_set_irqs_validate_and_prepare(&hdr, vdev->=
num_irqs,
> >>> -                                              vdev->num_irqs, &data_=
size);
> >>> +             if (hdr.index >=3D vdev->num_irqs)
> >>> +                     return -EINVAL;
> >>> +
> >>> +             max =3D vdev->irqs[hdr.index].count;
> >>> +
> >>> +             ret =3D vfio_set_irqs_validate_and_prepare(&hdr, max,
> >>> +                                                      vdev->num_irqs=
,
> >>> +                                                      &data_size);
> >>>               if (ret)
> >>>                       return ret;
> >>>
> >>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio=
/platform/vfio_platform_irq.c
> >>> index c5b09ec0a3c9..4066223e5b2e 100644
> >>> --- a/drivers/vfio/platform/vfio_platform_irq.c
> >>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> >>> @@ -8,10 +8,12 @@
> >>>
> >>>  #include <linux/eventfd.h>
> >>>  #include <linux/interrupt.h>
> >>> +#include <linux/eventfd.h>
> >>>  #include <linux/slab.h>
> >>>  #include <linux/types.h>
> >>>  #include <linux/vfio.h>
> >>>  #include <linux/irq.h>
> >>> +#include <linux/msi.h>
> >>>
> >>>  #include "vfio_platform_private.h"
> >>>
> >>> @@ -253,6 +255,195 @@ static int vfio_platform_set_irq_trigger(struct=
 vfio_platform_device *vdev,
> >>>       return 0;
> >>>  }
> >>>
> >>> +/* MSI/MSIX */
> >>> +static irqreturn_t vfio_msihandler(int irq, void *arg)
> >>> +{
> >>> +     struct eventfd_ctx *trigger =3D arg;
> >>> +
> >>> +     eventfd_signal(trigger, 1);
> >>> +     return IRQ_HANDLED;
> >>> +}
> >>> +
> >>> +static void msi_write(struct msi_desc *desc, struct msi_msg *msg)
> >>> +{
> >>> +     int i;
> >>> +     struct vfio_platform_irq *irq;
> >>> +     u16 index =3D desc->platform.msi_index;
> >>> +     struct device *dev =3D msi_desc_to_dev(desc);
> >>> +     struct vfio_device *device =3D dev_get_drvdata(dev);
> >>> +     struct vfio_platform_device *vdev =3D (struct vfio_platform_dev=
ice *)
> >>> +                                             vfio_device_data(device=
);
> >>> +
> >>> +     for (i =3D 0; i < vdev->num_irqs; i++)
> >>> +             if (vdev->irqs[i].type =3D=3D VFIO_IRQ_TYPE_MSI)
> >>> +                     irq =3D &vdev->irqs[i];
> >>> +
> >>> +     irq->ctx[index].msg.address_lo =3D msg->address_lo;
> >>> +     irq->ctx[index].msg.address_hi =3D msg->address_hi;
> >>> +     irq->ctx[index].msg.data =3D msg->data;
> >>> +}
> >>> +
> >>> +static int vfio_msi_enable(struct vfio_platform_device *vdev,
> >>> +                        struct vfio_platform_irq *irq, int nvec)
> >>> +{
> >>> +     int ret;
> >>> +     int msi_idx =3D 0;
> >>> +     struct msi_desc *desc;
> >>> +     struct device *dev =3D vdev->device;
> >>> +
> >>> +     irq->ctx =3D kcalloc(nvec, sizeof(struct vfio_irq_ctx), GFP_KER=
NEL);
> >>> +     if (!irq->ctx)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     /* Allocate platform MSIs */
> >>> +     ret =3D platform_msi_domain_alloc_irqs(dev, nvec, msi_write);
> >>> +     if (ret < 0) {
> >>> +             kfree(irq->ctx);
> >>> +             return ret;
> >>> +     }
> >>> +
> >>> +     for_each_msi_entry(desc, dev) {
> >>> +             irq->ctx[msi_idx].hwirq =3D desc->irq;
> >>> +             msi_idx++;
> >>> +     }
> >>> +
> >>> +     irq->num_ctx =3D nvec;
> >>> +     irq->config_msi =3D 1;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vfio_msi_set_vector_signal(struct vfio_platform_irq *irq,
> >>> +                                   int vector, int fd)
> >>> +{
> >>> +     struct eventfd_ctx *trigger;
> >>> +     int irq_num, ret;
> >>> +
> >>> +     if (vector < 0 || vector >=3D irq->num_ctx)
> >>> +             return -EINVAL;
> >>> +
> >>> +     irq_num =3D irq->ctx[vector].hwirq;
> >>> +
> >>> +     if (irq->ctx[vector].trigger) {
> >>> +             free_irq(irq_num, irq->ctx[vector].trigger);
> >>> +             kfree(irq->ctx[vector].name);
> >>> +             eventfd_ctx_put(irq->ctx[vector].trigger);
> >>> +             irq->ctx[vector].trigger =3D NULL;
> >>> +     }
> >>> +
> >>> +     if (fd < 0)
> >>> +             return 0;
> >>> +
> >>> +     irq->ctx[vector].name =3D kasprintf(GFP_KERNEL,
> >>> +                                       "vfio-msi[%d]", vector);
> >>> +     if (!irq->ctx[vector].name)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     trigger =3D eventfd_ctx_fdget(fd);
> >>> +     if (IS_ERR(trigger)) {
> >>> +             kfree(irq->ctx[vector].name);
> >>> +             return PTR_ERR(trigger);
> >>> +     }
> >>> +
> >>> +     ret =3D request_irq(irq_num, vfio_msihandler, 0,
> >>> +                       irq->ctx[vector].name, trigger);
> >>> +     if (ret) {
> >>> +             kfree(irq->ctx[vector].name);
> >>> +             eventfd_ctx_put(trigger);
> >>> +             return ret;
> >>> +     }
> >>> +
> >>> +     irq->ctx[vector].trigger =3D trigger;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vfio_msi_set_block(struct vfio_platform_irq *irq, unsigne=
d int start,
> >>> +                           unsigned int count, int32_t *fds)
> >>> +{
> >>> +     int i, j, ret =3D 0;
> >>> +
> >>> +     if (start >=3D irq->num_ctx || start + count > irq->num_ctx)
> >>> +             return -EINVAL;
> >>> +
> >>> +     for (i =3D 0, j =3D start; i < count && !ret; i++, j++) {
> >>> +             int fd =3D fds ? fds[i] : -1;
> >>> +
> >>> +             ret =3D vfio_msi_set_vector_signal(irq, j, fd);
> >>> +     }
> >>> +
> >>> +     if (ret) {
> >>> +             for (--j; j >=3D (int)start; j--)
> >>> +                     vfio_msi_set_vector_signal(irq, j, -1);
> >>> +     }
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vfio_msi_disable(struct vfio_platform_device *vdev,
> >>> +                          struct vfio_platform_irq *irq)
> >>> +{
> >>> +     struct device *dev =3D vdev->device;
> >>> +
> >>> +     vfio_msi_set_block(irq, 0, irq->num_ctx, NULL);
> >>> +
> >>> +     platform_msi_domain_free_irqs(dev);
> >>> +
> >>> +     irq->config_msi =3D 0;
> >>> +     irq->num_ctx =3D 0;
> >>> +
> >>> +     kfree(irq->ctx);
> >>> +}
> >>> +
> >>> +static int vfio_set_msi_trigger(struct vfio_platform_device *vdev,
> >>> +                             unsigned int index, unsigned int start,
> >>> +                             unsigned int count, uint32_t flags, voi=
d *data)
> >>> +{
> >>> +     int i;
> >>> +     struct vfio_platform_irq *irq =3D &vdev->irqs[index];
> >>> +
> >>> +     if (start + count > irq->count)
> >>> +             return -EINVAL;
> >>> +
> >>> +     if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> >>> +             vfio_msi_disable(vdev, irq);
> >>> +             return 0;
> >>> +     }
> >>> +
> >>> +     if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> >>> +             s32 *fds =3D data;
> >>> +             int ret;
> >>> +
> >>> +             if (irq->config_msi)
> >>> +                     return vfio_msi_set_block(irq, start, count,
> >>> +                                               fds);
> >>> +             ret =3D vfio_msi_enable(vdev, irq, start + count);
> >>> +             if (ret)
> >>> +                     return ret;
> >>> +
> >>> +             ret =3D vfio_msi_set_block(irq, start, count, fds);
> >>> +             if (ret)
> >>> +                     vfio_msi_disable(vdev, irq);
> >>> +
> >>> +             return ret;
> >>> +     }
> >>> +
> >>> +     for (i =3D start; i < start + count; i++) {
> >>> +             if (!irq->ctx[i].trigger)
> >>> +                     continue;
> >>> +             if (flags & VFIO_IRQ_SET_DATA_NONE) {
> >>> +                     eventfd_signal(irq->ctx[i].trigger, 1);
> >>> +             } else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> >>> +                     u8 *bools =3D data;
> >>> +
> >>> +                     if (bools[i - start])
> >>> +                             eventfd_signal(irq->ctx[i].trigger, 1);
> >>> +             }
> >>> +     }
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>>  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
> >>>                                uint32_t flags, unsigned index, unsign=
ed start,
> >>>                                unsigned count, void *data)
> >>> @@ -261,16 +452,29 @@ int vfio_platform_set_irqs_ioctl(struct vfio_pl=
atform_device *vdev,
> >>>                   unsigned start, unsigned count, uint32_t flags,
> >>>                   void *data) =3D NULL;
> >>>
> >>> -     switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> >>> -     case VFIO_IRQ_SET_ACTION_MASK:
> >>> -             func =3D vfio_platform_set_irq_mask;
> >>> -             break;
> >>> -     case VFIO_IRQ_SET_ACTION_UNMASK:
> >>> -             func =3D vfio_platform_set_irq_unmask;
> >>> -             break;
> >>> -     case VFIO_IRQ_SET_ACTION_TRIGGER:
> >>> -             func =3D vfio_platform_set_irq_trigger;
> >>> -             break;
> >>> +     struct vfio_platform_irq *irq =3D &vdev->irqs[index];
> >>> +
> >>> +     if (irq->type =3D=3D VFIO_IRQ_TYPE_MSI) {
> >>> +             switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> >>> +             case VFIO_IRQ_SET_ACTION_MASK:
> >>> +             case VFIO_IRQ_SET_ACTION_UNMASK:
> >>> +                     break;
> >>> +             case VFIO_IRQ_SET_ACTION_TRIGGER:
> >>> +                     func =3D vfio_set_msi_trigger;
> >>> +                     break;
> >>> +             }
> >>> +     } else {
> >>> +             switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> >>> +             case VFIO_IRQ_SET_ACTION_MASK:
> >>> +                     func =3D vfio_platform_set_irq_mask;
> >>> +                     break;
> >>> +             case VFIO_IRQ_SET_ACTION_UNMASK:
> >>> +                     func =3D vfio_platform_set_irq_unmask;
> >>> +                     break;
> >>> +             case VFIO_IRQ_SET_ACTION_TRIGGER:
> >>> +                     func =3D vfio_platform_set_irq_trigger;
> >>> +                     break;
> >>> +             }
> >>>       }
> >>>
> >>>       if (!func)
> >>> @@ -281,12 +485,21 @@ int vfio_platform_set_irqs_ioctl(struct vfio_pl=
atform_device *vdev,
> >>>
> >>>  int vfio_platform_irq_init(struct vfio_platform_device *vdev)
> >>>  {
> >>> -     int cnt =3D 0, i;
> >>> +     int i;
> >>> +     int cnt =3D 0;
> >>> +     int num_irqs;
> >>> +     struct device *dev =3D vdev->device;
> >>>
> >>>       while (vdev->get_irq(vdev, cnt) >=3D 0)
> >>>               cnt++;
> >>>
> >>> -     vdev->irqs =3D kcalloc(cnt, sizeof(struct vfio_platform_irq), G=
FP_KERNEL);
> >>> +     num_irqs =3D cnt;
> >>> +
> >>> +     if (dev->msi_domain)
> >>> +             num_irqs++;
> >>> +
> >>> +     vdev->irqs =3D kcalloc(num_irqs, sizeof(struct vfio_platform_ir=
q),
> >>> +                          GFP_KERNEL);
> >>>       if (!vdev->irqs)
> >>>               return -ENOMEM;
> >>>
> >>> @@ -309,7 +522,19 @@ int vfio_platform_irq_init(struct vfio_platform_=
device *vdev)
> >>>               vdev->irqs[i].masked =3D false;
> >>>       }
> >>>
> >>> -     vdev->num_irqs =3D cnt;
> >>> +     /*
> >>> +      * MSI block is added at last index and its an ext irq
> >> it is
> >>> +      */
> >>> +     if (dev->msi_domain) {
> >>> +             vdev->irqs[i].flags =3D VFIO_IRQ_INFO_EVENTFD;
> >>> +             vdev->irqs[i].count =3D NR_IRQS;
> >> why NR_IRQS?
> >  Since different devices can have different numbers of MSI(s) so we
> > need to initialize with max possible values. Can you please suggest if
> > this value does not seem appropriate?
> As opposed to PCIe, the userspace has no real way to guess how many
> vectors can be set (what vfio_pci_get_irq_count does). This also means
> we do not fully implement the original API as we are not able to report
> an accurate value for .count. How will the user determine how many
> vectors he can use?

I believe user space will know how many MSIs platform device can have.
We have assigned NR_IRQS because that=E2=80=99s what maximum number of
interrupt can be supported on a specific platform. In case user space
errantly tries to allocate any number of MSIs in kernel
platform_msi_domain_alloc_irqs should fail.
Do you think this approach can create an issue as .count is not
exactly the same as MSIs are existing with device? Is it necessary to
have a PCIe kind of approach as PCIe is standard but platform devices
do not have standards?

> >>> +             vdev->irqs[i].hwirq =3D 0;
> >>> +             vdev->irqs[i].masked =3D false;
> >>> +             vdev->irqs[i].type =3D VFIO_IRQ_TYPE_MSI;
> >>> +             vdev->num_ext_irqs =3D 1;
> >>> +     }
> >>> +
> >>> +     vdev->num_irqs =3D num_irqs;
> >>>
> >>>       return 0;
> >>>  err:
> >>> @@ -321,8 +546,13 @@ void vfio_platform_irq_cleanup(struct vfio_platf=
orm_device *vdev)
> >>>  {
> >>>       int i;
> >>>
> >>> -     for (i =3D 0; i < vdev->num_irqs; i++)
> >>> -             vfio_set_trigger(vdev, i, -1, NULL);
> >>> +     for (i =3D 0; i < vdev->num_irqs; i++) {
> >>> +             if (vdev->irqs[i].type =3D=3D VFIO_IRQ_TYPE_MSI)
> >>> +                     vfio_set_msi_trigger(vdev, i, 0, 0,
> >>> +                                          VFIO_IRQ_SET_DATA_NONE, NU=
LL);
> >>> +             else
> >>> +                     vfio_set_trigger(vdev, i, -1, NULL);
> >>> +     }
> >>>
> >>>       vdev->num_irqs =3D 0;
> >>>       kfree(vdev->irqs);
> >>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/=
vfio/platform/vfio_platform_private.h
> >>> index 289089910643..7bbb05988705 100644
> >>> --- a/drivers/vfio/platform/vfio_platform_private.h
> >>> +++ b/drivers/vfio/platform/vfio_platform_private.h
> >>> @@ -9,6 +9,7 @@
> >>>
> >>>  #include <linux/types.h>
> >>>  #include <linux/interrupt.h>
> >>> +#include <linux/msi.h>
> >>>
> >>>  #define VFIO_PLATFORM_OFFSET_SHIFT   40
> >>>  #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET=
_SHIFT) - 1)
> >>> @@ -19,9 +20,18 @@
> >>>  #define VFIO_PLATFORM_INDEX_TO_OFFSET(index) \
> >>>       ((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
> >>>
> >>> +struct vfio_irq_ctx {
> >>> +     int                     hwirq;
> >>> +     char                    *name;
> >>> +     struct msi_msg          msg;
> >>> +     struct eventfd_ctx      *trigger;
> >>> +};
> >>> +
> >>>  struct vfio_platform_irq {
> >>>       u32                     flags;
> >>>       u32                     count;
> >>> +     int                     num_ctx;
> >>> +     struct vfio_irq_ctx     *ctx;
> >>>       int                     hwirq;
> >>>       char                    *name;
> >>>       struct eventfd_ctx      *trigger;
> >>> @@ -29,6 +39,11 @@ struct vfio_platform_irq {
> >>>       spinlock_t              lock;
> >>>       struct virqfd           *unmask;
> >>>       struct virqfd           *mask;
> >>> +
> >>> +     /* for extended irqs */
> >>> +     u32                     type;
> >>> +     u32                     subtype;
> >>> +     int                     config_msi;
> >>>  };
> >>>
> >>>  struct vfio_platform_region {
> >>> @@ -46,6 +61,7 @@ struct vfio_platform_device {
> >>>       u32                             num_regions;
> >>>       struct vfio_platform_irq        *irqs;
> >>>       u32                             num_irqs;
> >>> +     int                             num_ext_irqs;
> >>>       int                             refcnt;
> >>>       struct mutex                    igate;
> >>>       struct module                   *parent_module;
> >>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>> index 2f313a238a8f..598d1c944283 100644
> >>> --- a/include/uapi/linux/vfio.h
> >>> +++ b/include/uapi/linux/vfio.h
> >>> @@ -697,11 +697,54 @@ struct vfio_irq_info {
> >>>  #define VFIO_IRQ_INFO_MASKABLE               (1 << 1)
> >>>  #define VFIO_IRQ_INFO_AUTOMASKED     (1 << 2)
> >>>  #define VFIO_IRQ_INFO_NORESIZE               (1 << 3)
> >>> +#define VFIO_IRQ_INFO_FLAG_CAPS              (1 << 4) /* Info suppor=
ts caps */
> >>>       __u32   index;          /* IRQ index */
> >>>       __u32   count;          /* Number of IRQs within this index */
> >>> +     __u32   cap_offset;     /* Offset within info struct of first c=
ap */
> >>>  };
> >>>  #define VFIO_DEVICE_GET_IRQ_INFO     _IO(VFIO_TYPE, VFIO_BASE + 9)
> >>>
> >>> +/*
> >>> + * The irq type capability allows IRQs unique to a specific device o=
r
> >>> + * class of devices to be exposed.
> >>> + *
> >>> + * The structures below define version 1 of this capability.
> >>> + */
> >>> +#define VFIO_IRQ_INFO_CAP_TYPE               3
> >>> +
> >>> +struct vfio_irq_info_cap_type {
> >>> +     struct vfio_info_cap_header header;
> >>> +     __u32 type;     /* global per bus driver */
> >>> +     __u32 subtype;  /* type specific */
> >>> +};
> >>> +
> >>> +/*
> >>> + * List of IRQ types, global per bus driver.
> >>> + * If you introduce a new type, please add it here.
> >>> + */
> >>> +
> >>> +/* Non PCI devices having MSI(s) support */
> >>> +#define VFIO_IRQ_TYPE_MSI            (1)
> >>> +
> >>> +/*
> >>> + * The msi capability allows the user to use the msi msg to
> >>> + * configure the iova for the msi configuration.
> >>> + * The structures below define version 1 of this capability.
> >>> + */
> >>> +#define VFIO_IRQ_INFO_CAP_MSI_DESCS  4
> >>> +
> >>> +struct vfio_irq_msi_msg {
> >>> +     __u32   addr_lo;
> >>> +     __u32   addr_hi;
> >>> +     __u32   data;
> >>> +};
> >>> +
> >>> +struct vfio_irq_info_cap_msi {
> >>> +     struct vfio_info_cap_header header;
> >>> +     __u32 nr_msgs;
> >> I think you should align a __u32   reserved field to have a 64b alignm=
ent
> > Sure.
> >>> +     struct vfio_irq_msi_msg msgs[];
> >> Please can you clarify why this cap is needed versus your prior approa=
ch.
> > In the previous patch, the reset module was configuring the device
> > with MSI msg/data now since the module is not available, user space
> > needs to have this data.
> > With this approach userspace just needs the pairs <msg and ctx >
> > associated with the MSI(s) and it can choose to configure the MSI(s)
> > sources accordingly.
> > Let me know if this approach does not look appropriate.
> This comes to the question I asked in my previous email, ie. could you
> give some more info about the expected MSI setup sequence? May be the
> opportunity to enhance the commit message ;-)

With our proposal, user space needs to know how many MSI sources there
are as we want user space to map msi-msg(s) to specific MSI sources.
Let us assume there are max =E2=80=98n=E2=80=99 MSI sources a platform devi=
ce have,
user-space requests =E2=80=98n=E2=80=99 msi(s) allocation in the kernel whi=
ch in turn
gets =E2=80=98n=E2=80=99 msi_msg with help of cap (VFIO_IRQ_INFO_CAP_MSI_DE=
SCS). User
space is free to map/configure msi_msg->data value to any particular
source. Since msi_msg->data is one to one mapped to eventfd,
user-space knows that particular eventfd corresponds to the same MSI
source which it has configured with the msi_msg->data value.

Steps:
a)   User space allocates nvec in kernel. Ioctl VFIO_DEVICE_SET_IRQS
b)   Kernel allocates nvec and does associated IRQ allocation, eventfd etc.
c)   User space gets the msi_msgs VFIO_DEVICE_GET_IRQ_INFO.
d)   User space configures the particular MSI source with msi_msg info.
Do these steps look OK?
We can add more information where this cap is introduced in the file
uapi/linux/vfio.h.

Thanks,
Vikas
>
> Thanks
>
> Eric
> >
> > Thanks,
> > Vikas
> >>> +};
> >>> +
> >>>  /**
> >>>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfi=
o_irq_set)
> >>>   *
> >>>
> >> Thanks
> >>
> >> Eric
> >>
>

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--000000000000c9f07905b61735bc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2lQ6rFUP408r38ha7ieLj9GoHHitwSmKYwUIGObe2Y57xYNj855BF4wx44Z80uM2ugKCZwIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUnmgVV8btvFtO
FD3kFjPWxD/aB8MwDQYJKoZIhvcNAQELBQADggEBAGCcuBN7G3mbQ7xMF8g8Lpz6WE+UFmkSSqU3
FZLC2I92SA5lRIthcdz4AEgte6ywnef3+2mG7HWMoQ1wriSG5qLppAD02Uku6yRD52Sn67DB2Ozk
yhBJayurzUxN1+R5E/YZtj2fkNajS5+i85e83PZPvVJ8/WnseIADGvDoouWqK7mxU/p8hELdb3PW
JH2nMg39SpVAwmRqfs6mYtenpMwKtQd9goGkIFXqdSvOPATkbS1YIGtU2byLK+/1rIWPoKNmRddj
WOu/loxldI1sJa1tOHgtb93YpIe0HEmgxLGS0KEnbM+rn9vXNKCe+9n0PhxJIfqcf6rAtK0prRwr
Y2MxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDDTZ
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg4WDWa8VIMo1LeC8l
lcgjSayi61Iegm2lIZj1aIa2NrcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMjEwMDczNDQ2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAD2sIqtU+efQTqX7KZC0SZ92dcxjXSRrr2SP
HBvxubIj9RQ/IIm2lIHP/hT3E7i9MMYKZfpJ2WgwC62wX6sWvqoiixz1HcYhjXDEmyRAE7AOgolS
EfZT+GxiyvGRxkjw+BPRdPzvGyrVA01jvTqJ8YypV50/pbYfvELAHXIY+PUZHUGGUTe+NmP1DSpq
oYr/KBJP4QnNSlq1ZEO0XTZmwXl7f1uTcln3tQP3UQ6quHBQbX5iItFnaZWRqQIt9Er+YUArFUWz
i5Zj7StPOMt5WUbrNukiK7uC4r6XfqZHbnhvM3+nctFTGXEyNjLWUhKMyFb4Wx1PSmq0z65u9xEI
qpM=
--000000000000c9f07905b61735bc--
