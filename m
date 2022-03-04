Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5F74CD25A
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiCDK05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiCDK04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:26:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A7B51A2748
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646389568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dg2DjhTzspXnkPdxQ4L1gE7F4LBl/cnUsJCfA7PY7HU=;
        b=GjoSA7vwD353jDcuo6/J4baUOGUFsWiJWlU5O4uhbcYZ9gygiUsD89AdCJVuORN35h31FH
        oEHsDAc3vdwRDhwYfx9QJwzbKacsPPOtejKQmI+9KO5Kj26HWG39VglhsEqmyV3CsGVLvQ
        fyF7+Yi8O1BUMOprDPF22CleNT+AB2A=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-NGyjwF-zNCiU11jzus5aUw-1; Fri, 04 Mar 2022 05:26:05 -0500
X-MC-Unique: NGyjwF-zNCiU11jzus5aUw-1
Received: by mail-qv1-f72.google.com with SMTP id b3-20020a056214134300b004352de5b5f0so4973633qvw.20
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:26:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dg2DjhTzspXnkPdxQ4L1gE7F4LBl/cnUsJCfA7PY7HU=;
        b=WaBJ5xM1k27xZVJailMrP2VTqis8zn3Jv6CE6miKwRloZxtie+G8pXhF8ha8Vm4DXJ
         8akfpUASw1GAJJitlsVqTyEuIfuYhVm/JzUtaqdKEbGQaZWXVhLNBx6unuhmQtiKZGJq
         l93hCUWRFo0tFOk3D+IgIb1cCMH3vQ20I1nUv3xjSqP7NOoaPWdUP6Bco78zl9nYpI0v
         TS1WxgOGdzg5tgxHsnDgDrTAgb2qw4fMlCmRZ5yqc+aFr/xYQHmR9Utd41gyfP9sHE67
         FwHTHi7zpWxNRn4736mUIEs9WvUddIN0okeJCE8eetQ/KuIb+fVv28KBDI4tsKgXZKgF
         zVjg==
X-Gm-Message-State: AOAM533hkDNji9iqZRwDJcNWrpN5SopsPPrHURlYh9yKFoy9jIMtmBo9
        KcHe9yLtsc5onM9+Ky+tr4unhOQH4eSETblyJOlLn2APLMz3nxTs73kvUtykTVLFa+bjN5rxvdg
        kaOCBr14r62VyCISQ29MFOiF6WIN8
X-Received: by 2002:a05:620a:22a6:b0:662:e97d:c7bc with SMTP id p6-20020a05620a22a600b00662e97dc7bcmr2045279qkh.486.1646389564505;
        Fri, 04 Mar 2022 02:26:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1kvpYAW//FncPCrmWqRNA2ZHLRo4go2ItEjZkcWjMdDDeSf32X9DZm+GH63oF+p5dNcZRS3Kz9G/HtkiuCqU=
X-Received: by 2002:a05:620a:22a6:b0:662:e97d:c7bc with SMTP id
 p6-20020a05620a22a600b00662e97dc7bcmr2045261qkh.486.1646389564236; Fri, 04
 Mar 2022 02:26:04 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-10-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-10-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 4 Mar 2022 11:25:28 +0100
Message-ID: <CAJaqyWe=o=JLM800oxn8_wa3hOnMBB0MCTut_vturfpHi9+hbw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/19] vhost: support ASID in IOTLB API
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, tanujk@xilinx.com,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 10:26 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> This patches allows userspace to send ASID based IOTLB message to
> vhost. This idea is to use the reserved u32 field in the existing V2
> IOTLB message. Vhost device should advertise this capability via
> VHOST_BACKEND_F_IOTLB_ASID backend feature.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vhost/vdpa.c             |  5 ++++-
>  drivers/vhost/vhost.c            | 23 ++++++++++++++++++-----
>  drivers/vhost/vhost.h            |  4 ++--
>  include/uapi/linux/vhost_types.h |  6 +++++-
>  4 files changed, 29 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 6bf755f84d26..d0aacc0cc79a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -836,7 +836,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>                                  msg->perm);
>  }
>
> -static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
> +static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>                                         struct vhost_iotlb_msg *msg)
>  {
>         struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
> @@ -847,6 +847,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>
>         mutex_lock(&dev->mutex);
>
> +       if (asid != 0)
> +               return -EINVAL;
> +

Should we check for asid != 0 before acquiring the mutex? Otherwise
the code never releases it.

>         r = vhost_dev_check_owner(dev);
>         if (r)
>                 goto unlock;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..1f514d98f0de 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -468,7 +468,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>                     struct vhost_virtqueue **vqs, int nvqs,
>                     int iov_limit, int weight, int byte_weight,
>                     bool use_worker,
> -                   int (*msg_handler)(struct vhost_dev *dev,
> +                   int (*msg_handler)(struct vhost_dev *dev, u32 asid,
>                                        struct vhost_iotlb_msg *msg))
>  {
>         struct vhost_virtqueue *vq;
> @@ -1090,11 +1090,14 @@ static bool umem_access_ok(u64 uaddr, u64 size, int access)
>         return true;
>  }
>
> -static int vhost_process_iotlb_msg(struct vhost_dev *dev,
> +static int vhost_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>                                    struct vhost_iotlb_msg *msg)
>  {
>         int ret = 0;
>
> +       if (asid != 0)
> +               return -EINVAL;
> +
>         mutex_lock(&dev->mutex);
>         vhost_dev_lock_vqs(dev);
>         switch (msg->type) {
> @@ -1141,6 +1144,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>         struct vhost_iotlb_msg msg;
>         size_t offset;
>         int type, ret;
> +       u32 asid = 0;
>
>         ret = copy_from_iter(&type, sizeof(type), from);
>         if (ret != sizeof(type)) {
> @@ -1156,7 +1160,16 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>                 offset = offsetof(struct vhost_msg, iotlb) - sizeof(int);
>                 break;
>         case VHOST_IOTLB_MSG_V2:
> -               offset = sizeof(__u32);
> +               if (vhost_backend_has_feature(dev->vqs[0],
> +                                             VHOST_BACKEND_F_IOTLB_ASID)) {
> +                       ret = copy_from_iter(&asid, sizeof(asid), from);
> +                       if (ret != sizeof(asid)) {
> +                               ret = -EINVAL;
> +                               goto done;
> +                       }
> +                       offset = sizeof(__u16);
> +               } else
> +                       offset = sizeof(__u32);
>                 break;
>         default:
>                 ret = -EINVAL;
> @@ -1171,9 +1184,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>         }
>
>         if (dev->msg_handler)
> -               ret = dev->msg_handler(dev, &msg);
> +               ret = dev->msg_handler(dev, asid, &msg);
>         else
> -               ret = vhost_process_iotlb_msg(dev, &msg);
> +               ret = vhost_process_iotlb_msg(dev, asid, &msg);
>         if (ret) {
>                 ret = -EFAULT;
>                 goto done;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 638bb640d6b4..9f238d6c7b58 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -161,7 +161,7 @@ struct vhost_dev {
>         int byte_weight;
>         u64 kcov_handle;
>         bool use_worker;
> -       int (*msg_handler)(struct vhost_dev *dev,
> +       int (*msg_handler)(struct vhost_dev *dev, u32 asid,
>                            struct vhost_iotlb_msg *msg);
>  };
>
> @@ -169,7 +169,7 @@ bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
>  void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
>                     int nvqs, int iov_limit, int weight, int byte_weight,
>                     bool use_worker,
> -                   int (*msg_handler)(struct vhost_dev *dev,
> +                   int (*msg_handler)(struct vhost_dev *dev, u32 asid,
>                                        struct vhost_iotlb_msg *msg));
>  long vhost_dev_set_owner(struct vhost_dev *dev);
>  bool vhost_dev_has_owner(struct vhost_dev *dev);
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
> index 76ee7016c501..634cee485abb 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -87,7 +87,7 @@ struct vhost_msg {
>
>  struct vhost_msg_v2 {
>         __u32 type;
> -       __u32 reserved;
> +       __u32 asid;
>         union {
>                 struct vhost_iotlb_msg iotlb;
>                 __u8 padding[64];
> @@ -157,5 +157,9 @@ struct vhost_vdpa_iova_range {
>  #define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
>  /* IOTLB can accept batching hints */
>  #define VHOST_BACKEND_F_IOTLB_BATCH  0x2
> +/* IOTLB can accept address space identifier through V2 type of IOTLB
> + * message
> + */
> +#define VHOST_BACKEND_F_IOTLB_ASID  0x3
>
>  #endif
> --
> 2.25.0
>

