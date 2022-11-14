Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432A4627528
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 05:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbiKNEEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 23:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiKNEEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 23:04:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B243915FF1
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668398581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oq5eZXf0XhukK2gu36VDoVydSFlALZ6mBLTD6YCisaQ=;
        b=TKbuABHXFo4QlVDQAG4/N2F8CPWgqjhC8EzsKCV9SIj0poqEVq4U3Xcf1zaV8e9+UiTvV9
        KdHtDauF8W7RzWJr8q3zghTxQMVbBrknT0Fn2feW7A+dYkdWFW2QhmHEsuvt5UnwE96ryH
        4/hPuCbFqoDU7mrnfRdc+jdbDFDDZi0=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-316-KR3gkf3tPLSpbyCLsDzyzA-1; Sun, 13 Nov 2022 23:03:00 -0500
X-MC-Unique: KR3gkf3tPLSpbyCLsDzyzA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-13b041fd3cbso4894702fac.16
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:03:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oq5eZXf0XhukK2gu36VDoVydSFlALZ6mBLTD6YCisaQ=;
        b=lLjUR9rSM2wc3m/LOLnr5N52/Qiv6N9bBx7daKheOf1GGEP2gv+tqXeyFMGt6jnZSO
         Q8XDIfqH/TLWNzRovvdsLBCeJ1amlh0T7E0j3lpWxjucb9YRpoGTkYGI17b1vtEMto/H
         xTcAvKpVcjpvDARqy528HIYp5L7n+gswFfnWnMTRxcI+UApDib1yyViXnYOcoRToOlD/
         UY3NsDNTqMO9/8STG0/1PD5HCsIufljrZCLpGqCkUbVRjhZLouX8Q94VbYpIYvaeDUsp
         MIM8O0dU9fghq78giywQDILoq9lZ0vF+Rf9kv/ZBmd9w9VmkBx33sOcEgT2w1Bo8jMnE
         sj+Q==
X-Gm-Message-State: ANoB5pk8vC1IYJUB51TG1x88JlQxAlP/gGbFgztdX8jj+YCVwQuXWY+4
        djQUtWEcgZJfcGJa8LT/el3fUlGSj2ER4VR4PyGmZ2RH1qu7xCF0ziOQuKTWAgKeyqxFabPlMB0
        yaY3jUjOO/CE1lvKqMsOWri6xa/vF
X-Received: by 2002:a05:6870:4693:b0:132:7b3:29ac with SMTP id a19-20020a056870469300b0013207b329acmr5866556oap.35.1668398578350;
        Sun, 13 Nov 2022 20:02:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4xjudomhrvG+/XAwTBGmLMookiQ0Mk6p2vSEBVqpGEMBIhFS9oqAY4w4rOGA3n360voc4bxmeg1XO2H4Y++h0=
X-Received: by 2002:a05:6870:4693:b0:132:7b3:29ac with SMTP id
 a19-20020a056870469300b0013207b329acmr5866535oap.35.1668398577988; Sun, 13
 Nov 2022 20:02:57 -0800 (PST)
MIME-Version: 1.0
References: <20221111153555.1295-1-longpeng2@huawei.com>
In-Reply-To: <20221111153555.1295-1-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 14 Nov 2022 12:02:47 +0800
Message-ID: <CACGkMEuZp4GskMjAvGcNNRTmrmgzg1e4ufzJDekBBQ5BE9Nk=Q@mail.gmail.com>
Subject: Re: [RFC] vdpa: clear the device when opening/releasing it
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     stefanha@redhat.com, mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org, arei.gonglei@huawei.com,
        yechuan@huawei.com, huangzhichao@huawei.com,
        linux-kernel@vger.kernel.org, xiehong@huawei.com, parav@nvidia.com,
        kvm@vger.kernel.org, lingshan.zhu@intel.com, lulu@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 11:36 PM Longpeng(Mike) <longpeng2@huawei.com> wrote:
>
> From: Longpeng <longpeng2@huawei.com>
>
> We should do some deeply cleanup when opening or releasing the device,
> e.g trigger FLR if it is PCIe device.

Why is this needed? We're resetting at the virtio level instead of the
transport level.

Thanks

>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>  drivers/vdpa/alibaba/eni_vdpa.c    | 2 +-
>  drivers/vdpa/ifcvf/ifcvf_main.c    | 2 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 2 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c   | 2 +-
>  drivers/vdpa/vdpa_user/vduse_dev.c | 2 +-
>  drivers/vdpa/virtio_pci/vp_vdpa.c  | 2 +-
>  drivers/vhost/vdpa.c               | 4 ++--
>  drivers/virtio/virtio_vdpa.c       | 2 +-
>  include/linux/vdpa.h               | 7 ++++---
>  9 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/vdpa/alibaba/eni_vdpa.c b/drivers/vdpa/alibaba/eni_vdpa.c
> index 5a09a09cca70..07215b174dd6 100644
> --- a/drivers/vdpa/alibaba/eni_vdpa.c
> +++ b/drivers/vdpa/alibaba/eni_vdpa.c
> @@ -226,7 +226,7 @@ static void eni_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
>                 eni_vdpa_free_irq(eni_vdpa);
>  }
>
> -static int eni_vdpa_reset(struct vdpa_device *vdpa)
> +static int eni_vdpa_reset(struct vdpa_device *vdpa, bool clear)
>  {
>         struct eni_vdpa *eni_vdpa = vdpa_to_eni(vdpa);
>         struct virtio_pci_legacy_device *ldev = &eni_vdpa->ldev;
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index f9c0044c6442..b9a6ac18f358 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -496,7 +496,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>         ifcvf_set_status(vf, status);
>  }
>
> -static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
> +static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev, bool clear)
>  {
>         struct ifcvf_adapter *adapter;
>         struct ifcvf_hw *vf;
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 90913365def4..6f06f9c464a3 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2560,7 +2560,7 @@ static void init_group_to_asid_map(struct mlx5_vdpa_dev *mvdev)
>                 mvdev->group2asid[i] = 0;
>  }
>
> -static int mlx5_vdpa_reset(struct vdpa_device *vdev)
> +static int mlx5_vdpa_reset(struct vdpa_device *vdev, bool clear)
>  {
>         struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>         struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index b071f0d842fb..7438a89ce939 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -504,7 +504,7 @@ static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
>         spin_unlock(&vdpasim->lock);
>  }
>
> -static int vdpasim_reset(struct vdpa_device *vdpa)
> +static int vdpasim_reset(struct vdpa_device *vdpa, bool clear)
>  {
>         struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index 35dceee3ed56..e5fee28233c0 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -691,7 +691,7 @@ static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
>         /* Now we only support read-only configuration space */
>  }
>
> -static int vduse_vdpa_reset(struct vdpa_device *vdpa)
> +static int vduse_vdpa_reset(struct vdpa_device *vdpa, bool clear)
>  {
>         struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>         int ret = vduse_dev_set_status(dev, 0);
> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> index d35fac5cde11..3db25b622a57 100644
> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> @@ -226,7 +226,7 @@ static void vp_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
>         vp_modern_set_status(mdev, status);
>  }
>
> -static int vp_vdpa_reset(struct vdpa_device *vdpa)
> +static int vp_vdpa_reset(struct vdpa_device *vdpa, bool clear)
>  {
>         struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
>         struct virtio_pci_modern_device *mdev = vp_vdpa_to_mdev(vp_vdpa);
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 166044642fd5..fdda08cd7e7a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -212,7 +212,7 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>
>         v->in_batch = 0;
>
> -       return vdpa_reset(vdpa);
> +       return vdpa_reset(vdpa, true);
>  }
>
>  static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
> @@ -269,7 +269,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>                         vhost_vdpa_unsetup_vq_irq(v, i);
>
>         if (status == 0) {
> -               ret = vdpa_reset(vdpa);
> +               ret = vdpa_reset(vdpa, false);
>                 if (ret)
>                         return ret;
>         } else
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index 9670cc79371d..8f6ae689547e 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -99,7 +99,7 @@ static void virtio_vdpa_reset(struct virtio_device *vdev)
>  {
>         struct vdpa_device *vdpa = vd_get_vdpa(vdev);
>
> -       vdpa_reset(vdpa);
> +       vdpa_reset(vdpa, false);
>  }
>
>  static bool virtio_vdpa_notify(struct virtqueue *vq)
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 6d0f5e4e82c2..a0b917743b66 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -218,6 +218,7 @@ struct vdpa_map_file {
>   *                             @status: virtio device status
>   * @reset:                     Reset device
>   *                             @vdev: vdpa device
> + *                             @clear: need device/function level clear or not, e.g pcie_flr.
>   *                             Returns integer: success (0) or error (< 0)
>   * @suspend:                   Suspend or resume the device (optional)
>   *                             @vdev: vdpa device
> @@ -322,7 +323,7 @@ struct vdpa_config_ops {
>         u32 (*get_vendor_id)(struct vdpa_device *vdev);
>         u8 (*get_status)(struct vdpa_device *vdev);
>         void (*set_status)(struct vdpa_device *vdev, u8 status);
> -       int (*reset)(struct vdpa_device *vdev);
> +       int (*reset)(struct vdpa_device *vdev, bool clear);
>         int (*suspend)(struct vdpa_device *vdev);
>         size_t (*get_config_size)(struct vdpa_device *vdev);
>         void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> @@ -427,14 +428,14 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
>         return vdev->dma_dev;
>  }
>
> -static inline int vdpa_reset(struct vdpa_device *vdev)
> +static inline int vdpa_reset(struct vdpa_device *vdev, bool clear)
>  {
>         const struct vdpa_config_ops *ops = vdev->config;
>         int ret;
>
>         down_write(&vdev->cf_lock);
>         vdev->features_valid = false;
> -       ret = ops->reset(vdev);
> +       ret = ops->reset(vdev, clear);
>         up_write(&vdev->cf_lock);
>         return ret;
>  }
> --
> 2.23.0
>

