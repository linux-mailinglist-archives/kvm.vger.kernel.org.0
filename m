Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAF0597E7A
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 08:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243560AbiHRGRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 02:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243554AbiHRGRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 02:17:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C72094ED3
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 23:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660803438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ot2vwFR1T222PfgSIh5m6p32mZzeyGGRnrrO3d0V6sE=;
        b=clm3hCaU4fxQBa2REfiv9L+jOdzd+06kcesl/yAGs6gdima8g+J/5EXJW4CN9SXciWYpqs
        AvVBFWoloN3S1CxUs1PZqAdUFV2Li2ZRwTTNfWrcWc80UVlcXb98h7I9LGnpUAVCTgzqbq
        CMXg0PS9cQn19l40v//jvJ/90mlgsYo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-EO6QPhAYMli6uF3ThzK9lw-1; Thu, 18 Aug 2022 02:17:17 -0400
X-MC-Unique: EO6QPhAYMli6uF3ThzK9lw-1
Received: by mail-qt1-f199.google.com with SMTP id bq11-20020a05622a1c0b00b003434f125b77so505748qtb.20
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 23:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ot2vwFR1T222PfgSIh5m6p32mZzeyGGRnrrO3d0V6sE=;
        b=KBjZcvvKD4VK2GFgTnPvJgpyg2HFXCdRrHPl453kF5MEP0Yf8bXBBX3p9WbqgspDUL
         Cmvl+18PQcaxOOpDEf54CWmtKHm41e0koCNomt24HpLdWjqudok16jKqvk9HuzJ+Lp2x
         zGP/Uw0DUybdbSNBH4Hdjar3UfPqKSYCZ62dXqykw0BBfYs9FDx4zqtbYmK4vuG1c3nn
         E63/kiCZQIgsDUyW5eiUwl9Bd30NnFYrxzitDoFYg28ZHI51HwjvWeN1h6DC0F8PB8QQ
         /p3B0TXkssnoZ2wZVMWG2wJP3miehAK77GjUlRHCSATZ3g3+JUh1ZxWa4uhQv+a7ERSJ
         KKHg==
X-Gm-Message-State: ACgBeo1onyPTX1rcuTYP6w6nbx/Pen5+lQoxo7OYxIpwOQZREEi3he0v
        ImhCrMquJ7U8VED098oT6eenDmbLgvPctFvohlGxBHLuo52k8l/KPvT2VLNGsQmkceay+wkQI0R
        suNJSzQYzd9aTvt5XA3/Nw/EDM2nT
X-Received: by 2002:a05:6214:238e:b0:470:8ee8:52e6 with SMTP id fw14-20020a056214238e00b004708ee852e6mr1168250qvb.45.1660803436767;
        Wed, 17 Aug 2022 23:17:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4jOUEuptwDAtnL8E4DdAIzT5M/rSapK91fG0oRQXL0a2bCI0/d5RqvVeH6gz5JpjOR1xu8CsXuvg+Q3SwTLBM=
X-Received: by 2002:a05:6214:238e:b0:470:8ee8:52e6 with SMTP id
 fw14-20020a056214238e00b004708ee852e6mr1168238qvb.45.1660803436530; Wed, 17
 Aug 2022 23:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-2-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220817135718.2553-2-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 18 Aug 2022 08:16:40 +0200
Message-ID: <CAJaqyWcq++TmtMsGnn-j=6oAb7+f32P-WC5XRz0L2rEKJ4Sotw@mail.gmail.com>
Subject: Re: [RFC v2 1/7] vhost: expose used buffers
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 3:58 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
> of descriptors.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/vhost.c | 14 ++++++++++++--
>  drivers/vhost/vhost.h |  1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..7b20fa5a46c3 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2376,10 +2376,20 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>         vring_used_elem_t __user *used;
>         u16 old, new;
>         int start;
> +       int copy_n = count;
>
> +       /**
> +        * If in order feature negotiated, devices can notify the use of a batch of buffers to
> +        * the driver by only writing out a single used ring entry with the id corresponding
> +        * to the head entry of the descriptor chain describing the last buffer in the batch.
> +        */
> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> +               copy_n = 1;
> +               heads = &heads[count - 1];
> +       }
>         start = vq->last_used_idx & (vq->num - 1);
>         used = vq->used->ring + start;
> -       if (vhost_put_used(vq, heads, start, count)) {
> +       if (vhost_put_used(vq, heads, start, copy_n)) {
>                 vq_err(vq, "Failed to write used");
>                 return -EFAULT;
>         }
> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>
>         start = vq->last_used_idx & (vq->num - 1);
>         n = vq->num - start;
> -       if (n < count) {
> +       if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>                 r = __vhost_add_used_n(vq, heads, n);
>                 if (r < 0)
>                         return r;

It would be simpler to use vhost_add_used in vsock/vhost_test to add a
batch of used descriptors, and leave vhost_add_used_n untouched.

Since it's the upper layer the one that manages the in_order in this
version, we could:
* Always call vhost_add_used(vq, last_head_of_batch, ...) for the tx
queue, that does not need used length info.
* Call vhost_add_used_n for the rx queue, since the driver needs the
used length info.

> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index d9109107af08..0d5c49a30421 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -236,6 +236,7 @@ enum {
>         VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
>                          (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
>                          (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> +                        (1ULL << VIRTIO_F_IN_ORDER) |
>                          (1ULL << VHOST_F_LOG_ALL) |
>                          (1ULL << VIRTIO_F_ANY_LAYOUT) |
>                          (1ULL << VIRTIO_F_VERSION_1)
> --
> 2.17.1
>

