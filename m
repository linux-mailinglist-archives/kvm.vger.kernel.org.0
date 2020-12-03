Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4212CD995
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgLCOv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgLCOv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 09:51:27 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E18C061A51
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 06:50:47 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id h21so4201982wmb.2
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 06:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+VyVF/Yyv5VpQ+XGVXW/UUvGODQ1llk/tZBLKvldOA0=;
        b=PrOT6pHm+wC8p2Xz0mWrpUuGNSyOzbw/I8WN6vmyQj5rxRGI8I6GNbBpI1Xl3aZGFq
         Vqp2+DxH/WTXvFCutoljlqdsQZIdXv129zN/AYX+oXGG1PNUEItsD9WqXxtnGc7ysEgT
         EEBCOyYX5Cd7kloLg8tBD7WE4yZzKAvSiuwiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+VyVF/Yyv5VpQ+XGVXW/UUvGODQ1llk/tZBLKvldOA0=;
        b=ulKMr0kfnupuxUpXuG0HKrSUxVZTfPeSYOgR0KviQ0MPui885fhjYZCuQ3IlHyBwN1
         DstQVwUdZFYQV2ZOIymEcpj213uG9gVVCWofFNsyNDCAuIjqCrLNAHhDemT4JsQZGTYE
         Ordt4z24Q6hV39b6Md/+hyvN8nEoLyadRYHnOzREhgvCKXWMRcHvgK2f5vejPNw9LSl/
         EC5A5lWjIvoLLDVMf9T/XIUemDGB6XakdacxrQ5l1DRTRFp/EUmVQyx6gmZu+ZLpsjxu
         WRqzzkMgydNOhLbwI8d7XvdXt2pCSgguxrhq3KuYbXCZfaWT1DEc7O1pJCxoEZXAu7F8
         00cA==
X-Gm-Message-State: AOAM533ujO2SIYbX+/Or8gCq16i6o58OEYOesB5ZKGoyEOAOxzSBWZ8/
        aiPvFqNAKi/cLA3Js2dUYvFuzRw2tvWdAHmd3OD7KQ==
X-Google-Smtp-Source: ABdhPJyfp7muDOF8GO+gObuYtaVMkP1Eatp4Fo8zWi0p8bnUl44NpSZdsI7t2U9KRIRnM4EzoMZWhRP3GGl7SJPYl2U=
X-Received: by 2002:a1c:e042:: with SMTP id x63mr3819854wmg.68.1607007045264;
 Thu, 03 Dec 2020 06:50:45 -0800 (PST)
MIME-Version: 1.0
References: <20201112175852.21572-1-vikas.gupta@broadcom.com>
 <20201124161646.41191-1-vikas.gupta@broadcom.com> <20201124161646.41191-2-vikas.gupta@broadcom.com>
 <73830e85-035f-88ac-7aec-a818e83c2d5a@redhat.com>
In-Reply-To: <73830e85-035f-88ac-7aec-a818e83c2d5a@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Thu, 3 Dec 2020 20:20:33 +0530
Message-ID: <CAHLZf_tgZ7H76H3WjqXrSQeCC_CmKLrY6t46Ce-7Qo10TpMVZg@mail.gmail.com>
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
        boundary="00000000000020add105b5907c05"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000020add105b5907c05
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Wed, Dec 2, 2020 at 8:14 PM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
>
> On 11/24/20 5:16 PM, Vikas Gupta wrote:
> > MSI support for platform devices.
> >
> > Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> > ---
> >  drivers/vfio/platform/vfio_platform_common.c  |  99 ++++++-
> >  drivers/vfio/platform/vfio_platform_irq.c     | 260 +++++++++++++++++-
> >  drivers/vfio/platform/vfio_platform_private.h |  16 ++
> >  include/uapi/linux/vfio.h                     |  43 +++
> >  4 files changed, 401 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> > index c0771a9567fb..b0bfc0f4ee1f 100644
> > --- a/drivers/vfio/platform/vfio_platform_common.c
> > +++ b/drivers/vfio/platform/vfio_platform_common.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/types.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/vfio.h>
> > +#include <linux/nospec.h>
> >
> >  #include "vfio_platform_private.h"
> >
> > @@ -344,9 +345,16 @@ static long vfio_platform_ioctl(void *device_data,
> >
> >       } else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
> >               struct vfio_irq_info info;
> > +             struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> > +             struct vfio_irq_info_cap_msi *msi_info = NULL;
> > +             unsigned long capsz;
> > +             int ext_irq_index = vdev->num_irqs - vdev->num_ext_irqs;
> >
> >               minsz = offsetofend(struct vfio_irq_info, count);
> >
> > +             /* For backward compatibility, cannot require this */
> > +             capsz = offsetofend(struct vfio_irq_info, cap_offset);
> > +
> >               if (copy_from_user(&info, (void __user *)arg, minsz))
> >                       return -EFAULT;
> >
> > @@ -356,9 +364,89 @@ static long vfio_platform_ioctl(void *device_data,
> >               if (info.index >= vdev->num_irqs)
> >                       return -EINVAL;
> >
> > +             if (info.argsz >= capsz)
> > +                     minsz = capsz;
> > +
> > +             if (info.index == ext_irq_index) {
> nit: n case we add new ext indices afterwards, I would check info.index
> -  ext_irq_index against an VFIO_EXT_IRQ_MSI define.
> > +                     struct vfio_irq_info_cap_type cap_type = {
> > +                             .header.id = VFIO_IRQ_INFO_CAP_TYPE,
> > +                             .header.version = 1 };
> > +                     int i;
> > +                     int ret;
> > +                     int num_msgs;
> > +                     size_t msi_info_size;
> > +                     struct vfio_platform_irq *irq;
> nit: I think generally the opposite order (length) is chosen. This also
> would better match the existing style in this file
Ok will fix it
> > +
> > +                     info.index = array_index_nospec(info.index,
> > +                                                     vdev->num_irqs);
> > +
> > +                     irq = &vdev->irqs[info.index];
> > +
> > +                     info.flags = irq->flags;
> I think this can be removed given [*]
Sure.
> > +                     cap_type.type = irq->type;
> > +                     cap_type.subtype = irq->subtype;
> > +
> > +                     ret = vfio_info_add_capability(&caps,
> > +                                                    &cap_type.header,
> > +                                                    sizeof(cap_type));
> > +                     if (ret)
> > +                             return ret;
> > +
> > +                     num_msgs = irq->num_ctx;
> do would want to return the cap even if !num_ctx?
If num_ctx = 0 then VFIO_IRQ_INFO_CAP_MSI_DESCS should not be written.
I`ll take care of same.
> > +
> > +                     msi_info_size = struct_size(msi_info, msgs, num_msgs);
> > +
> > +                     msi_info = kzalloc(msi_info_size, GFP_KERNEL);
> > +                     if (!msi_info) {
> > +                             kfree(caps.buf);
> > +                             return -ENOMEM;
> > +                     }
> > +
> > +                     msi_info->header.id = VFIO_IRQ_INFO_CAP_MSI_DESCS;
> > +                     msi_info->header.version = 1;
> > +                     msi_info->nr_msgs = num_msgs;
> > +
> > +                     for (i = 0; i < num_msgs; i++) {
> > +                             struct vfio_irq_ctx *ctx = &irq->ctx[i];
> > +
> > +                             msi_info->msgs[i].addr_lo = ctx->msg.address_lo;
> > +                             msi_info->msgs[i].addr_hi = ctx->msg.address_hi;
> > +                             msi_info->msgs[i].data = ctx->msg.data;
> > +                     }
> > +
> > +                     ret = vfio_info_add_capability(&caps, &msi_info->header,
> > +                                                    msi_info_size);
> > +                     if (ret) {
> > +                             kfree(msi_info);
> > +                             kfree(caps.buf);
> > +                             return ret;
> > +                     }
> > +             }
> > +
> >               info.flags = vdev->irqs[info.index].flags;
> [*]
Will fix it.
> >               info.count = vdev->irqs[info.index].count;
> >
> > +             if (caps.size) {
> > +                     info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
> > +                     if (info.argsz < sizeof(info) + caps.size) {
> > +                             info.argsz = sizeof(info) + caps.size;
> > +                             info.cap_offset = 0;
> > +                     } else {
> > +                             vfio_info_cap_shift(&caps, sizeof(info));
> > +                             if (copy_to_user((void __user *)arg +
> > +                                               sizeof(info), caps.buf,
> > +                                               caps.size)) {
> > +                                     kfree(msi_info);
> > +                                     kfree(caps.buf);
> > +                                     return -EFAULT;
> > +                             }
> > +                             info.cap_offset = sizeof(info);
> > +                     }
> > +
> > +                     kfree(msi_info);
> > +                     kfree(caps.buf);
> > +             }
> > +
> >               return copy_to_user((void __user *)arg, &info, minsz) ?
> >                       -EFAULT : 0;
> >
> > @@ -366,6 +454,7 @@ static long vfio_platform_ioctl(void *device_data,
> >               struct vfio_irq_set hdr;
> >               u8 *data = NULL;
> >               int ret = 0;
> > +             int max;
> >               size_t data_size = 0;
> >
> >               minsz = offsetofend(struct vfio_irq_set, count);
> > @@ -373,8 +462,14 @@ static long vfio_platform_ioctl(void *device_data,
> >               if (copy_from_user(&hdr, (void __user *)arg, minsz))
> >                       return -EFAULT;
> >
> > -             ret = vfio_set_irqs_validate_and_prepare(&hdr, vdev->num_irqs,
> > -                                              vdev->num_irqs, &data_size);
> > +             if (hdr.index >= vdev->num_irqs)
> > +                     return -EINVAL;
> > +
> > +             max = vdev->irqs[hdr.index].count;
> > +
> > +             ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
> > +                                                      vdev->num_irqs,
> > +                                                      &data_size);
> >               if (ret)
> >                       return ret;
> >
> > diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> > index c5b09ec0a3c9..4066223e5b2e 100644
> > --- a/drivers/vfio/platform/vfio_platform_irq.c
> > +++ b/drivers/vfio/platform/vfio_platform_irq.c
> > @@ -8,10 +8,12 @@
> >
> >  #include <linux/eventfd.h>
> >  #include <linux/interrupt.h>
> > +#include <linux/eventfd.h>
> >  #include <linux/slab.h>
> >  #include <linux/types.h>
> >  #include <linux/vfio.h>
> >  #include <linux/irq.h>
> > +#include <linux/msi.h>
> >
> >  #include "vfio_platform_private.h"
> >
> > @@ -253,6 +255,195 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
> >       return 0;
> >  }
> >
> > +/* MSI/MSIX */
> > +static irqreturn_t vfio_msihandler(int irq, void *arg)
> > +{
> > +     struct eventfd_ctx *trigger = arg;
> > +
> > +     eventfd_signal(trigger, 1);
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static void msi_write(struct msi_desc *desc, struct msi_msg *msg)
> > +{
> > +     int i;
> > +     struct vfio_platform_irq *irq;
> > +     u16 index = desc->platform.msi_index;
> > +     struct device *dev = msi_desc_to_dev(desc);
> > +     struct vfio_device *device = dev_get_drvdata(dev);
> > +     struct vfio_platform_device *vdev = (struct vfio_platform_device *)
> > +                                             vfio_device_data(device);
> > +
> > +     for (i = 0; i < vdev->num_irqs; i++)
> > +             if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
> > +                     irq = &vdev->irqs[i];
> > +
> > +     irq->ctx[index].msg.address_lo = msg->address_lo;
> > +     irq->ctx[index].msg.address_hi = msg->address_hi;
> > +     irq->ctx[index].msg.data = msg->data;
> > +}
> > +
> > +static int vfio_msi_enable(struct vfio_platform_device *vdev,
> > +                        struct vfio_platform_irq *irq, int nvec)
> > +{
> > +     int ret;
> > +     int msi_idx = 0;
> > +     struct msi_desc *desc;
> > +     struct device *dev = vdev->device;
> > +
> > +     irq->ctx = kcalloc(nvec, sizeof(struct vfio_irq_ctx), GFP_KERNEL);
> > +     if (!irq->ctx)
> > +             return -ENOMEM;
> > +
> > +     /* Allocate platform MSIs */
> > +     ret = platform_msi_domain_alloc_irqs(dev, nvec, msi_write);
> > +     if (ret < 0) {
> > +             kfree(irq->ctx);
> > +             return ret;
> > +     }
> > +
> > +     for_each_msi_entry(desc, dev) {
> > +             irq->ctx[msi_idx].hwirq = desc->irq;
> > +             msi_idx++;
> > +     }
> > +
> > +     irq->num_ctx = nvec;
> > +     irq->config_msi = 1;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vfio_msi_set_vector_signal(struct vfio_platform_irq *irq,
> > +                                   int vector, int fd)
> > +{
> > +     struct eventfd_ctx *trigger;
> > +     int irq_num, ret;
> > +
> > +     if (vector < 0 || vector >= irq->num_ctx)
> > +             return -EINVAL;
> > +
> > +     irq_num = irq->ctx[vector].hwirq;
> > +
> > +     if (irq->ctx[vector].trigger) {
> > +             free_irq(irq_num, irq->ctx[vector].trigger);
> > +             kfree(irq->ctx[vector].name);
> > +             eventfd_ctx_put(irq->ctx[vector].trigger);
> > +             irq->ctx[vector].trigger = NULL;
> > +     }
> > +
> > +     if (fd < 0)
> > +             return 0;
> > +
> > +     irq->ctx[vector].name = kasprintf(GFP_KERNEL,
> > +                                       "vfio-msi[%d]", vector);
> > +     if (!irq->ctx[vector].name)
> > +             return -ENOMEM;
> > +
> > +     trigger = eventfd_ctx_fdget(fd);
> > +     if (IS_ERR(trigger)) {
> > +             kfree(irq->ctx[vector].name);
> > +             return PTR_ERR(trigger);
> > +     }
> > +
> > +     ret = request_irq(irq_num, vfio_msihandler, 0,
> > +                       irq->ctx[vector].name, trigger);
> > +     if (ret) {
> > +             kfree(irq->ctx[vector].name);
> > +             eventfd_ctx_put(trigger);
> > +             return ret;
> > +     }
> > +
> > +     irq->ctx[vector].trigger = trigger;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vfio_msi_set_block(struct vfio_platform_irq *irq, unsigned int start,
> > +                           unsigned int count, int32_t *fds)
> > +{
> > +     int i, j, ret = 0;
> > +
> > +     if (start >= irq->num_ctx || start + count > irq->num_ctx)
> > +             return -EINVAL;
> > +
> > +     for (i = 0, j = start; i < count && !ret; i++, j++) {
> > +             int fd = fds ? fds[i] : -1;
> > +
> > +             ret = vfio_msi_set_vector_signal(irq, j, fd);
> > +     }
> > +
> > +     if (ret) {
> > +             for (--j; j >= (int)start; j--)
> > +                     vfio_msi_set_vector_signal(irq, j, -1);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static void vfio_msi_disable(struct vfio_platform_device *vdev,
> > +                          struct vfio_platform_irq *irq)
> > +{
> > +     struct device *dev = vdev->device;
> > +
> > +     vfio_msi_set_block(irq, 0, irq->num_ctx, NULL);
> > +
> > +     platform_msi_domain_free_irqs(dev);
> > +
> > +     irq->config_msi = 0;
> > +     irq->num_ctx = 0;
> > +
> > +     kfree(irq->ctx);
> > +}
> > +
> > +static int vfio_set_msi_trigger(struct vfio_platform_device *vdev,
> > +                             unsigned int index, unsigned int start,
> > +                             unsigned int count, uint32_t flags, void *data)
> > +{
> > +     int i;
> > +     struct vfio_platform_irq *irq = &vdev->irqs[index];
> > +
> > +     if (start + count > irq->count)
> > +             return -EINVAL;
> > +
> > +     if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> > +             vfio_msi_disable(vdev, irq);
> > +             return 0;
> > +     }
> > +
> > +     if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> > +             s32 *fds = data;
> > +             int ret;
> > +
> > +             if (irq->config_msi)
> > +                     return vfio_msi_set_block(irq, start, count,
> > +                                               fds);
> > +             ret = vfio_msi_enable(vdev, irq, start + count);
> > +             if (ret)
> > +                     return ret;
> > +
> > +             ret = vfio_msi_set_block(irq, start, count, fds);
> > +             if (ret)
> > +                     vfio_msi_disable(vdev, irq);
> > +
> > +             return ret;
> > +     }
> > +
> > +     for (i = start; i < start + count; i++) {
> > +             if (!irq->ctx[i].trigger)
> > +                     continue;
> > +             if (flags & VFIO_IRQ_SET_DATA_NONE) {
> > +                     eventfd_signal(irq->ctx[i].trigger, 1);
> > +             } else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> > +                     u8 *bools = data;
> > +
> > +                     if (bools[i - start])
> > +                             eventfd_signal(irq->ctx[i].trigger, 1);
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
> >                                uint32_t flags, unsigned index, unsigned start,
> >                                unsigned count, void *data)
> > @@ -261,16 +452,29 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
> >                   unsigned start, unsigned count, uint32_t flags,
> >                   void *data) = NULL;
> >
> > -     switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> > -     case VFIO_IRQ_SET_ACTION_MASK:
> > -             func = vfio_platform_set_irq_mask;
> > -             break;
> > -     case VFIO_IRQ_SET_ACTION_UNMASK:
> > -             func = vfio_platform_set_irq_unmask;
> > -             break;
> > -     case VFIO_IRQ_SET_ACTION_TRIGGER:
> > -             func = vfio_platform_set_irq_trigger;
> > -             break;
> > +     struct vfio_platform_irq *irq = &vdev->irqs[index];
> > +
> > +     if (irq->type == VFIO_IRQ_TYPE_MSI) {
> > +             switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> > +             case VFIO_IRQ_SET_ACTION_MASK:
> > +             case VFIO_IRQ_SET_ACTION_UNMASK:
> > +                     break;
> > +             case VFIO_IRQ_SET_ACTION_TRIGGER:
> > +                     func = vfio_set_msi_trigger;
> > +                     break;
> > +             }
> > +     } else {
> > +             switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> > +             case VFIO_IRQ_SET_ACTION_MASK:
> > +                     func = vfio_platform_set_irq_mask;
> > +                     break;
> > +             case VFIO_IRQ_SET_ACTION_UNMASK:
> > +                     func = vfio_platform_set_irq_unmask;
> > +                     break;
> > +             case VFIO_IRQ_SET_ACTION_TRIGGER:
> > +                     func = vfio_platform_set_irq_trigger;
> > +                     break;
> > +             }
> >       }
> >
> >       if (!func)
> > @@ -281,12 +485,21 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
> >
> >  int vfio_platform_irq_init(struct vfio_platform_device *vdev)
> >  {
> > -     int cnt = 0, i;
> > +     int i;
> > +     int cnt = 0;
> > +     int num_irqs;
> > +     struct device *dev = vdev->device;
> >
> >       while (vdev->get_irq(vdev, cnt) >= 0)
> >               cnt++;
> >
> > -     vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq), GFP_KERNEL);
> > +     num_irqs = cnt;
> > +
> > +     if (dev->msi_domain)
> > +             num_irqs++;
> > +
> > +     vdev->irqs = kcalloc(num_irqs, sizeof(struct vfio_platform_irq),
> > +                          GFP_KERNEL);
> >       if (!vdev->irqs)
> >               return -ENOMEM;
> >
> > @@ -309,7 +522,19 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
> >               vdev->irqs[i].masked = false;
> >       }
> >
> > -     vdev->num_irqs = cnt;
> > +     /*
> > +      * MSI block is added at last index and its an ext irq
> it is
> > +      */
> > +     if (dev->msi_domain) {
> > +             vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
> > +             vdev->irqs[i].count = NR_IRQS;
> why NR_IRQS?
 Since different devices can have different numbers of MSI(s) so we
need to initialize with max possible values. Can you please suggest if
this value does not seem appropriate?
> > +             vdev->irqs[i].hwirq = 0;
> > +             vdev->irqs[i].masked = false;
> > +             vdev->irqs[i].type = VFIO_IRQ_TYPE_MSI;
> > +             vdev->num_ext_irqs = 1;
> > +     }
> > +
> > +     vdev->num_irqs = num_irqs;
> >
> >       return 0;
> >  err:
> > @@ -321,8 +546,13 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
> >  {
> >       int i;
> >
> > -     for (i = 0; i < vdev->num_irqs; i++)
> > -             vfio_set_trigger(vdev, i, -1, NULL);
> > +     for (i = 0; i < vdev->num_irqs; i++) {
> > +             if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
> > +                     vfio_set_msi_trigger(vdev, i, 0, 0,
> > +                                          VFIO_IRQ_SET_DATA_NONE, NULL);
> > +             else
> > +                     vfio_set_trigger(vdev, i, -1, NULL);
> > +     }
> >
> >       vdev->num_irqs = 0;
> >       kfree(vdev->irqs);
> > diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> > index 289089910643..7bbb05988705 100644
> > --- a/drivers/vfio/platform/vfio_platform_private.h
> > +++ b/drivers/vfio/platform/vfio_platform_private.h
> > @@ -9,6 +9,7 @@
> >
> >  #include <linux/types.h>
> >  #include <linux/interrupt.h>
> > +#include <linux/msi.h>
> >
> >  #define VFIO_PLATFORM_OFFSET_SHIFT   40
> >  #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
> > @@ -19,9 +20,18 @@
> >  #define VFIO_PLATFORM_INDEX_TO_OFFSET(index) \
> >       ((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
> >
> > +struct vfio_irq_ctx {
> > +     int                     hwirq;
> > +     char                    *name;
> > +     struct msi_msg          msg;
> > +     struct eventfd_ctx      *trigger;
> > +};
> > +
> >  struct vfio_platform_irq {
> >       u32                     flags;
> >       u32                     count;
> > +     int                     num_ctx;
> > +     struct vfio_irq_ctx     *ctx;
> >       int                     hwirq;
> >       char                    *name;
> >       struct eventfd_ctx      *trigger;
> > @@ -29,6 +39,11 @@ struct vfio_platform_irq {
> >       spinlock_t              lock;
> >       struct virqfd           *unmask;
> >       struct virqfd           *mask;
> > +
> > +     /* for extended irqs */
> > +     u32                     type;
> > +     u32                     subtype;
> > +     int                     config_msi;
> >  };
> >
> >  struct vfio_platform_region {
> > @@ -46,6 +61,7 @@ struct vfio_platform_device {
> >       u32                             num_regions;
> >       struct vfio_platform_irq        *irqs;
> >       u32                             num_irqs;
> > +     int                             num_ext_irqs;
> >       int                             refcnt;
> >       struct mutex                    igate;
> >       struct module                   *parent_module;
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 2f313a238a8f..598d1c944283 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -697,11 +697,54 @@ struct vfio_irq_info {
> >  #define VFIO_IRQ_INFO_MASKABLE               (1 << 1)
> >  #define VFIO_IRQ_INFO_AUTOMASKED     (1 << 2)
> >  #define VFIO_IRQ_INFO_NORESIZE               (1 << 3)
> > +#define VFIO_IRQ_INFO_FLAG_CAPS              (1 << 4) /* Info supports caps */
> >       __u32   index;          /* IRQ index */
> >       __u32   count;          /* Number of IRQs within this index */
> > +     __u32   cap_offset;     /* Offset within info struct of first cap */
> >  };
> >  #define VFIO_DEVICE_GET_IRQ_INFO     _IO(VFIO_TYPE, VFIO_BASE + 9)
> >
> > +/*
> > + * The irq type capability allows IRQs unique to a specific device or
> > + * class of devices to be exposed.
> > + *
> > + * The structures below define version 1 of this capability.
> > + */
> > +#define VFIO_IRQ_INFO_CAP_TYPE               3
> > +
> > +struct vfio_irq_info_cap_type {
> > +     struct vfio_info_cap_header header;
> > +     __u32 type;     /* global per bus driver */
> > +     __u32 subtype;  /* type specific */
> > +};
> > +
> > +/*
> > + * List of IRQ types, global per bus driver.
> > + * If you introduce a new type, please add it here.
> > + */
> > +
> > +/* Non PCI devices having MSI(s) support */
> > +#define VFIO_IRQ_TYPE_MSI            (1)
> > +
> > +/*
> > + * The msi capability allows the user to use the msi msg to
> > + * configure the iova for the msi configuration.
> > + * The structures below define version 1 of this capability.
> > + */
> > +#define VFIO_IRQ_INFO_CAP_MSI_DESCS  4
> > +
> > +struct vfio_irq_msi_msg {
> > +     __u32   addr_lo;
> > +     __u32   addr_hi;
> > +     __u32   data;
> > +};
> > +
> > +struct vfio_irq_info_cap_msi {
> > +     struct vfio_info_cap_header header;
> > +     __u32 nr_msgs;
> I think you should align a __u32   reserved field to have a 64b alignment
Sure.
> > +     struct vfio_irq_msi_msg msgs[];
> Please can you clarify why this cap is needed versus your prior approach.
In the previous patch, the reset module was configuring the device
with MSI msg/data now since the module is not available, user space
needs to have this data.
With this approach userspace just needs the pairs <msg and ctx >
associated with the MSI(s) and it can choose to configure the MSI(s)
sources accordingly.
Let me know if this approach does not look appropriate.

Thanks,
Vikas
> > +};
> > +
> >  /**
> >   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
> >   *
> >
> Thanks
>
> Eric
>

--00000000000020add105b5907c05
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg5lmW4r8GYw1/ftI2
bPndDZmAlbb081u21GgIjzz7j30wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMjAzMTQ1MDQ1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADTvX5YEjodb9BvtBJdle8KzVCnvU3+4VpbX
hBW0lUnAvIiSX8q/1RUOTiuewR17yL6PpYzAlweO3PGLWzuYqJwasv/5A3piLwVRxht6cQmtsc0n
EgzqS4N+A4cXMawtYG3OArgE11WCG3XEf3TgVkxwT3asIma3lN7uW9sL5ESV9LyPMWAAcf9qIWyG
4qHWpywjUiEozZNHaxW7wF2oPHbRKtecVnoaDu+KxbzpF7lDVPIal7K3SgTuhE7VDlqAeSD8g9b/
H7FaQDkKitUiZMAPxft0RU8WtOCIjAPdJoD+2KRHJGNMBVwMaAdZw/ETEh5uoF0yDifhbbCs7YZu
nSI=
--00000000000020add105b5907c05--
