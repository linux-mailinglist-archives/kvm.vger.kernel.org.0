Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD6F2F72DD
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 07:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbhAOG1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 01:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbhAOG1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 01:27:51 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CB5C061757
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 22:27:09 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r5so8300810eda.12
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 22:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wTxllT9aeA2savDQKEa2DXTavm0zTvxdU71UzirFO+c=;
        b=dn07zv5GhEz4BQDcG+3WIkGkDgTFu2opmRq7ToKKknLkuasUJxL6jsWadS33kDSvGU
         lMV19ITD/QBbYJCsf3GsR1Ujcdi8tuL0K0HLKXI0ny1ORVLZOAExEim+/aXDWBmGJwGC
         5R1PVVMLFTnW46jC1uqg7RLVp39R+aQGyfn9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wTxllT9aeA2savDQKEa2DXTavm0zTvxdU71UzirFO+c=;
        b=c8FSNzgMfySDQ4iMTE5p+o4Urj6Qas+sQcfAkCCCNmE0F3R+lRFdN4KZDmUpf1TWJJ
         CZXiuvVMwzut7UPXQK6U0xMo1+5lLnXY83ZFd+WgYT1uVBfSujO1XL5zxPZoSiSImMqJ
         8fYdD17R1e+ySjAzs3cB4Odiz7IObUBdTYGAKtxaxySQc5eDNoCC3YCp7HR0BXvAtb62
         AlP9+Rwmal7zFUDlxO5bG968Cn8FJq0/wFbpL3n5rIXmg6AMXRuemrKCzoXzKDilbLa1
         DmaKa0xKBI4kd0i8kWwLGxb/02RugBk6RCpKoZd760P2kgb7zCBsCp9Bw4Ys0o4oVWxW
         ntSA==
X-Gm-Message-State: AOAM533YCl88N+tUgTWBfZHRXB2987zcVK264UESqGl7nbrmD3ZVNma5
        JtLaHII0r9EItGMhS8AiHmxGtrKLlt1JjLLpv6GWCw==
X-Google-Smtp-Source: ABdhPJzyI5eEwjRB6NDOktbnQmR8SC32Tb2O8C7e7proUYb8DUpO1OIFiFLTb/Jv6ntzxNFKd7dt89uiXxDZT+vOHO0=
X-Received: by 2002:a05:6402:510f:: with SMTP id m15mr8544004edd.267.1610692028115;
 Thu, 14 Jan 2021 22:27:08 -0800 (PST)
MIME-Version: 1.0
References: <20201124161646.41191-1-vikas.gupta@broadcom.com>
 <20201214174514.22006-1-vikas.gupta@broadcom.com> <20201214174514.22006-2-vikas.gupta@broadcom.com>
 <0a8b9c66-a40c-1e0b-df36-41c566ce2fa9@redhat.com> <CAHLZf_u0mADmrJHuiJeizYPXGvbm6=u0xHhmFR_QmGui4CWQWA@mail.gmail.com>
 <58d8e706-4710-7902-baf5-2e07b70ad069@redhat.com>
In-Reply-To: <58d8e706-4710-7902-baf5-2e07b70ad069@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Fri, 15 Jan 2021 11:56:56 +0530
Message-ID: <CAHLZf_v4rDh-+K9cVn=4rA+DbpwRV7aNDfCjX6F=1Y_OwKT=7Q@mail.gmail.com>
Subject: Re: [RFC v3 1/2] vfio/platform: add support for msi
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
        boundary="000000000000375c3505b8ea76fa"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--000000000000375c3505b8ea76fa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, Jan 12, 2021 at 2:30 PM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
>
> On 1/5/21 6:53 AM, Vikas Gupta wrote:
> > On Tue, Dec 22, 2020 at 10:57 PM Auger Eric <eric.auger@redhat.com> wro=
te:
> >>
> >> Hi Vikas,
> >>
> >> On 12/14/20 6:45 PM, Vikas Gupta wrote:
> >>> MSI support for platform devices.The MSI block
> >>> is added as an extended IRQ which exports caps
> >>> VFIO_IRQ_INFO_CAP_TYPE and VFIO_IRQ_INFO_CAP_MSI_DESCS.
> >>>
> >>> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> >>> ---
> >>>  drivers/vfio/platform/vfio_platform_common.c  | 179 +++++++++++-
> >>>  drivers/vfio/platform/vfio_platform_irq.c     | 260 ++++++++++++++++=
+-
> >>>  drivers/vfio/platform/vfio_platform_private.h |  32 +++
> >>>  include/uapi/linux/vfio.h                     |  44 +++
> >>>  4 files changed, 496 insertions(+), 19 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/v=
fio/platform/vfio_platform_common.c
> >>> index fb4b385191f2..c936852f35d7 100644
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
> >>> @@ -26,6 +27,8 @@
> >>>  #define VFIO_PLATFORM_IS_ACPI(vdev) ((vdev)->acpihid !=3D NULL)
> >>>
> >>>  static LIST_HEAD(reset_list);
> >>> +/* devices having MSI support */
> >> nit: for devices using MSIs?
> >>> +static LIST_HEAD(msi_list);
> >>>  static DEFINE_MUTEX(driver_lock);
> >>>
> >>>  static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const cha=
r *compat,
> >>> @@ -47,6 +50,25 @@ static vfio_platform_reset_fn_t vfio_platform_look=
up_reset(const char *compat,
> >>>       return reset_fn;
> >>>  }
> >>>
> >>> +static bool vfio_platform_lookup_msi(struct vfio_platform_device *vd=
ev)
> >>> +{
> >>> +     bool has_msi =3D false;
> >>> +     struct vfio_platform_msi_node *iter;
> >>> +
> >>> +     mutex_lock(&driver_lock);
> >>> +     list_for_each_entry(iter, &msi_list, link) {
> >>> +             if (!strcmp(iter->compat, vdev->compat) &&
> >>> +                 try_module_get(iter->owner)) {
> >>> +                     vdev->msi_module =3D iter->owner;
> >>> +                     vdev->of_get_msi =3D iter->of_get_msi;
> >>> +                     has_msi =3D true;
> >>> +                     break;
> >>> +             }
> >>> +     }
> >>> +     mutex_unlock(&driver_lock);
> >>> +     return has_msi;
> >>> +}
> >>> +
> >>>  static int vfio_platform_acpi_probe(struct vfio_platform_device *vde=
v,
> >>>                                   struct device *dev)
> >>>  {
> >>> @@ -126,6 +148,19 @@ static int vfio_platform_get_reset(struct vfio_p=
latform_device *vdev)
> >>>       return vdev->of_reset ? 0 : -ENOENT;
> >>>  }
> >>>
> >>> +static int vfio_platform_get_msi(struct vfio_platform_device *vdev)
> >>> +{
> >>> +     bool has_msi;
> >>> +
> >>> +     has_msi =3D vfio_platform_lookup_msi(vdev);
> >>> +     if (!has_msi) {
> >>> +             request_module("vfio-msi:%s", vdev->compat);
> >>> +             has_msi =3D vfio_platform_lookup_msi(vdev);
> >>> +     }
> >>> +
> >>> +     return has_msi ? 0 : -ENOENT;
> >>> +}
> >>> +
> >>>  static void vfio_platform_put_reset(struct vfio_platform_device *vde=
v)
> >>>  {
> >>>       if (VFIO_PLATFORM_IS_ACPI(vdev))
> >>> @@ -135,6 +170,12 @@ static void vfio_platform_put_reset(struct vfio_=
platform_device *vdev)
> >>>               module_put(vdev->reset_module);
> >>>  }
> >>>
> >>> +static void vfio_platform_put_msi(struct vfio_platform_device *vdev)
> >>> +{
> >>> +     if (vdev->of_get_msi)
> >>> +             module_put(vdev->msi_module);
> >>> +}
> >>> +
> >>>  static int vfio_platform_regions_init(struct vfio_platform_device *v=
dev)
> >>>  {
> >>>       int cnt =3D 0, i;
> >>> @@ -343,9 +384,17 @@ static long vfio_platform_ioctl(void *device_dat=
a,
> >>>
> >>>       } else if (cmd =3D=3D VFIO_DEVICE_GET_IRQ_INFO) {
> >>>               struct vfio_irq_info info;
> >>> +             struct vfio_info_cap caps =3D { .buf =3D NULL, .size =
=3D 0 };
> >>> +             struct vfio_irq_info_cap_msi *msi_info =3D NULL;
> >>> +             int ext_irq_index =3D vdev->num_irqs - vdev->num_ext_ir=
qs;
> >>> +             unsigned long capsz;
> >>> +             u32 index;
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
> >>> @@ -355,8 +404,94 @@ static long vfio_platform_ioctl(void *device_dat=
a,
> >>>               if (info.index >=3D vdev->num_irqs)
> >>>                       return -EINVAL;
> >>>
> >>> -             info.flags =3D vdev->irqs[info.index].flags;
> >>> -             info.count =3D vdev->irqs[info.index].count;
> >>> +             if (info.argsz >=3D capsz)
> >>> +                     minsz =3D capsz;
> >>> +
> >>> +             index =3D info.index;
> >>> +
> >>> +             info.flags =3D vdev->irqs[index].flags;
> >>> +             info.count =3D vdev->irqs[index].count;
> >>> +
> >>> +             if (ext_irq_index - index =3D=3D VFIO_EXT_IRQ_MSI) {
> >>> +                     struct vfio_irq_info_cap_type cap_type =3D {
> >>> +                             .header.id =3D VFIO_IRQ_INFO_CAP_TYPE,
> >>> +                             .header.version =3D 1 };
> >>> +                     struct vfio_platform_irq *irq;
> >>> +                     size_t msi_info_size;
> >>> +                     int num_msgs;
> >>> +                     int ret;
> >>> +                     int i;
> >>> +
> >>> +                     index =3D array_index_nospec(index,
> >>> +                                                vdev->num_irqs);
> >>> +                     irq =3D &vdev->irqs[index];
> >>> +
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
> >>> +                     if (num_msgs) {
> >>> +                             msi_info_size =3D struct_size(msi_info,
> >>> +                                                         msgs, num_m=
sgs);
> >>> +
> >>> +                             msi_info =3D kzalloc(msi_info_size, GFP=
_KERNEL);
> >>> +                             if (!msi_info) {
> >>> +                                     kfree(caps.buf);
> >>> +                                     return -ENOMEM;
> >>> +                             }
> >>> +
> >>> +                             msi_info->header.id =3D
> >>> +                                             VFIO_IRQ_INFO_CAP_MSI_D=
ESCS;
> >> I thought you would remove this cap now the module is back. What is th=
e
> >> motivation to keep it?
> >
> > Hi Eric,
> > The earlier module was serving two purposes
> > a)   Max number of MSI(s) supported by the device. Since the module is
> > back this information can be filled in .count.
> understood
> > b)   Writing msi_msg(s) to devices for MSI sources.
> >  We want b) to be handled in the user space so that they need not be
> > dependent on the kernel.
> I fail to understand the problem with the "dependency on the kernel".
> What is the functional difference when exposing this to the userspace,
> please could you highlight the benefits?
We do not see any functional difference here, the benefit we see is
that user space can configure MSI sources with msi_msg rather than
doing it in the kernel.

>
>  VFIO_IRQ_INFO_CAP_MSI_DESCS is helping user
> > space to get MSI configuration data and thus they can independently
> > configure MSI sources. For example, user space can just ask for =E2=80=
=98N=E2=80=99
> > MSI vectors and related msi_msg for =E2=80=98N=E2=80=99 vectors
> this is induced by vfio_msi_enable(), right?
>
Yes
>
>  is exported to user
> > space using this CAP. User space can now use =E2=80=98N=E2=80=99 vector=
s to configure
> > any =E2=80=98N=E2=80=99 MSI sources and these sources might be in any o=
rder.
> > However, this design is different from vfio-pci as MSI configuration
> > is being handled in kernel only.
> > Let us know if implementing VFIO_IRQ_INFO_CAP_MSI_DESCS does not fit
> > with the CAP framework.
> I think it is OK reporting them through the cap but I fail to understand
> the benefits.

I believe, since there is no significant benefit this CAP should be
avoided. I plan to remove this CAP in the next patch set.

Thanks,
Vikas
>
> Thanks
>
> Eric
> >
> > Thanks,
> > Vikas
> >
> >  >
> >> Thanks
> >>
> >> Eric
> >>> +                             msi_info->header.version =3D 1;
> >>> +                             msi_info->nr_msgs =3D num_msgs;
> >>> +
> >>> +                             for (i =3D 0; i < num_msgs; i++) {
> >>> +                                     struct vfio_irq_ctx *ctx =3D &i=
rq->ctx[i];
> >>> +
> >>> +                                     msi_info->msgs[i].addr_lo =3D
> >>> +                                                     ctx->msg.addres=
s_lo;
> >>> +                                     msi_info->msgs[i].addr_hi =3D
> >>> +                                                     ctx->msg.addres=
s_hi;
> >>> +                                     msi_info->msgs[i].data =3D ctx-=
>msg.data;
> >>> +                             }
> >>> +
> >>> +                             ret =3D vfio_info_add_capability(&caps,
> >>> +                                                     &msi_info->head=
er,
> >>> +                                                     msi_info_size);
> >>> +                             if (ret) {
> >>> +                                     kfree(msi_info);
> >>> +                                     kfree(caps.buf);
> >>> +                                     return ret;
> >>> +                             }
> >>> +                     }
> >>> +             }
> >>> +
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
> >>>
> >>>               return copy_to_user((void __user *)arg, &info, minsz) ?
> >>>                       -EFAULT : 0;
> >>> @@ -365,6 +500,7 @@ static long vfio_platform_ioctl(void *device_data=
,
> >>>               struct vfio_irq_set hdr;
> >>>               u8 *data =3D NULL;
> >>>               int ret =3D 0;
> >>> +             int max;
> >>>               size_t data_size =3D 0;
> >>>
> >>>               minsz =3D offsetofend(struct vfio_irq_set, count);
> >>> @@ -372,8 +508,14 @@ static long vfio_platform_ioctl(void *device_dat=
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
> >>> @@ -678,6 +820,10 @@ int vfio_platform_probe_common(struct vfio_platf=
orm_device *vdev,
> >>>               return ret;
> >>>       }
> >>>
> >>> +     ret =3D vfio_platform_get_msi(vdev);
> >>> +     if (ret)
> >>> +             dev_info(vdev->device, "msi not supported\n");
> >> I don't think we should output this message. This is printed for
> >> amd-xgbe which does not have msi so this is misleading. I would say
> >> either the vfio_platform_get_msi() can return an actual error or we
> >> return a void?
> > Will check on this what
> >>
> >> Thanks
> >>
> >> Eric
> >>> +
> >>>       group =3D vfio_iommu_group_get(dev);
> >>>       if (!group) {
> >>>               dev_err(dev, "No IOMMU group for device %s\n", vdev->na=
me);
> >>> @@ -697,6 +843,7 @@ int vfio_platform_probe_common(struct vfio_platfo=
rm_device *vdev,
> >>>  put_iommu:
> >>>       vfio_iommu_group_put(group, dev);
> >>>  put_reset:
> >>> +     vfio_platform_put_msi(vdev);
> >>>       vfio_platform_put_reset(vdev);
> >>>       return ret;
> >>>  }
> >>> @@ -744,6 +891,30 @@ void vfio_platform_unregister_reset(const char *=
compat,
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
> >>>
> >>> +void __vfio_platform_register_msi(struct vfio_platform_msi_node *nod=
e)
> >>> +{
> >>> +     mutex_lock(&driver_lock);
> >>> +     list_add(&node->link, &msi_list);
> >>> +     mutex_unlock(&driver_lock);
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(__vfio_platform_register_msi);
> >>> +
> >>> +void vfio_platform_unregister_msi(const char *compat)
> >>> +{
> >>> +     struct vfio_platform_msi_node *iter, *temp;
> >>> +
> >>> +     mutex_lock(&driver_lock);
> >>> +     list_for_each_entry_safe(iter, temp, &msi_list, link) {
> >>> +             if (!strcmp(iter->compat, compat)) {
> >>> +                     list_del(&iter->link);
> >>> +                     break;
> >>> +             }
> >>> +     }
> >>> +
> >>> +     mutex_unlock(&driver_lock);
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(vfio_platform_unregister_msi);
> >>> +
> >>>  MODULE_VERSION(DRIVER_VERSION);
> >>>  MODULE_LICENSE("GPL v2");
> >>>  MODULE_AUTHOR(DRIVER_AUTHOR);
> >>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio=
/platform/vfio_platform_irq.c
> >>> index c5b09ec0a3c9..e0f4696afedd 100644
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
> >>> +     int msi_cnt =3D 0;
> >>>
> >>>       while (vdev->get_irq(vdev, cnt) >=3D 0)
> >>>               cnt++;
> >>>
> >>> -     vdev->irqs =3D kcalloc(cnt, sizeof(struct vfio_platform_irq), G=
FP_KERNEL);
> >>> +     if (vdev->of_get_msi) {
> >>> +             msi_cnt =3D vdev->of_get_msi(vdev);
> >>> +             num_irqs++;
> >>> +     }
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
> >>> +      * MSI block is added at last index and it is an ext irq
> >>> +      */
> >>> +     if (msi_cnt > 0) {
> >>> +             vdev->irqs[i].flags =3D VFIO_IRQ_INFO_EVENTFD;
> >>> +             vdev->irqs[i].count =3D msi_cnt;
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
> >>> index 289089910643..1307feddda21 100644
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
> >>> @@ -19,9 +20,21 @@
> >>>  #define VFIO_PLATFORM_INDEX_TO_OFFSET(index) \
> >>>       ((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
> >>>
> >>> +/* IRQ index for MSI in ext IRQs */
> >>> +#define VFIO_EXT_IRQ_MSI     0
> >>> +
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
> >>> @@ -29,6 +42,11 @@ struct vfio_platform_irq {
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
> >>> @@ -46,12 +64,14 @@ struct vfio_platform_device {
> >>>       u32                             num_regions;
> >>>       struct vfio_platform_irq        *irqs;
> >>>       u32                             num_irqs;
> >>> +     int                             num_ext_irqs;
> >>>       int                             refcnt;
> >>>       struct mutex                    igate;
> >>>       struct module                   *parent_module;
> >>>       const char                      *compat;
> >>>       const char                      *acpihid;
> >>>       struct module                   *reset_module;
> >>> +     struct module                   *msi_module;
> >>>       struct device                   *device;
> >>>
> >>>       /*
> >>> @@ -65,11 +85,13 @@ struct vfio_platform_device {
> >>>               (*get_resource)(struct vfio_platform_device *vdev, int =
i);
> >>>       int     (*get_irq)(struct vfio_platform_device *vdev, int i);
> >>>       int     (*of_reset)(struct vfio_platform_device *vdev);
> >>> +     u32     (*of_get_msi)(struct vfio_platform_device *vdev);
> >>>
> >>>       bool                            reset_required;
> >>>  };
> >>>
> >>>  typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device =
*vdev);
> >>> +typedef u32 (*vfio_platform_get_msi_fn_t)(struct vfio_platform_devic=
e *vdev);
> >>>
> >>>  struct vfio_platform_reset_node {
> >>>       struct list_head link;
> >>> @@ -78,6 +100,13 @@ struct vfio_platform_reset_node {
> >>>       vfio_platform_reset_fn_t of_reset;
> >>>  };
> >>>
> >>> +struct vfio_platform_msi_node {
> >>> +     struct list_head link;
> >>> +     char *compat;
> >>> +     struct module *owner;
> >>> +     vfio_platform_get_msi_fn_t of_get_msi;
> >>> +};
> >>> +
> >>>  extern int vfio_platform_probe_common(struct vfio_platform_device *v=
dev,
> >>>                                     struct device *dev);
> >>>  extern struct vfio_platform_device *vfio_platform_remove_common
> >>> @@ -94,6 +123,9 @@ extern int vfio_platform_set_irqs_ioctl(struct vfi=
o_platform_device *vdev,
> >>>  extern void __vfio_platform_register_reset(struct vfio_platform_rese=
t_node *n);
> >>>  extern void vfio_platform_unregister_reset(const char *compat,
> >>>                                          vfio_platform_reset_fn_t fn)=
;
> >>> +void __vfio_platform_register_msi(struct vfio_platform_msi_node *n);
> >>> +void vfio_platform_unregister_msi(const char *compat);
> >>> +
> >>>  #define vfio_platform_register_reset(__compat, __reset)             =
 \
> >>>  static struct vfio_platform_reset_node __reset ## _node =3D {  \
> >>>       .owner =3D THIS_MODULE,                                   \
> >>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>> index d1812777139f..53a7ff2b524e 100644
> >>> --- a/include/uapi/linux/vfio.h
> >>> +++ b/include/uapi/linux/vfio.h
> >>> @@ -697,11 +697,55 @@ struct vfio_irq_info {
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
> >>> +     __u32   nr_msgs;
> >>> +     __u32   reserved;
> >>> +     struct vfio_irq_msi_msg msgs[];
> >>> +};
> >>> +
> >>>  /**
> >>>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfi=
o_irq_set)
> >>>   *
> >>>
> >>
> >
>

--000000000000375c3505b8ea76fa
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgG2mYXGNn/jxeSbVl
xKTtgkIulcRBezKREF6khksGungwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjEwMTE1MDYyNzA4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAFeAwu4M5D9FvTyymwrRXD9tJL9bAiVB8LS
zJqSvj7vNrIs8H6DXrlmQInEpOUv1GxcfGe+YpdVg/pNlirz2Xk2/aNwh6FgJpY+b9nj8AXK9YS1
MCKUNjhqavywI4nImPR1eNikmRcIKVPERA9p+bEB4hU4m0McFnpuyet20YCbv/Dt2cY4UuiBudXe
uGDaUmIgMsvippoSBzTFKs0K8aYrFfm9SZ9MIjybNRXxE/WqE3HxT+0V/1VkQrDNSBlJrJa0hB2A
LsLmnH8MN5ltXZYT0bbMoDuH39CZkT3pcGOWl5uCXOvk8O7/Qf0+6kgjFw9938vNsxxHFFyxfSgS
MF4=
--000000000000375c3505b8ea76fa--
