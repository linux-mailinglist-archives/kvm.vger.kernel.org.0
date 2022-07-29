Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77088584CA5
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 09:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiG2HcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 03:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiG2HcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 03:32:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 535EC7C1B4
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 00:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659079940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2q2utn2CzeOeojEKg/tCXnqvan/YkCeq0ehI4nAHW8=;
        b=Ix79ElaHHTmzpLH5aTqa9St7W+1g47xRjpTeRDz//JUcpEwNhJndb4mHlLLs9E0HvzO3Cy
        ubdzc/fZFOU+PBApV+b+E4RDOKD82JOqWr7L9gUKGq+xeVEEYt54ll28XhmXt+29hZB9Ct
        2y0LsEfbSq+wxaMGgmDYivnf023h6kE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-GV1eUwYjND22hR8LAtWFPw-1; Fri, 29 Jul 2022 03:32:16 -0400
X-MC-Unique: GV1eUwYjND22hR8LAtWFPw-1
Received: by mail-lj1-f197.google.com with SMTP id k2-20020a2ea282000000b0025dea602f7cso740330lja.0
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 00:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S2q2utn2CzeOeojEKg/tCXnqvan/YkCeq0ehI4nAHW8=;
        b=k09NYyllBet6d/Q9V2mBWWI/b/3dLcp6PFc/wrMR/8SBuBEc2jJUOlseiWJNmyBtLI
         xk+SytQRKm7cvzmR+/NLYril3RJ4UrHSaoh6B2ktOvNLY6stkEC0mfpaTHsJ8QAD98bD
         mOcdrX+ss+77H9KiRd+DwN/pKcG3fH/X36FLY1PnVo3oDQ7AoHrz6o4v9Pa/SU6hVaRA
         p7i2yKosC/gxWDcgAAN2UwFBDpUEJPGQW1KUzz7pMs60cAbtjWfDjZDcsaOERfxMQt/D
         zyl3zEAGDI9D33sz8lKiWR3oHuNhDzQhEmojWd496Ic81kSe2YkKYFc/f2BhPYpQHSwl
         V4Bg==
X-Gm-Message-State: AJIora9VU6BVM71na+JTtplC+FD+mZ0wfrakmRJ8IsG6lk4j+An7p5ZB
        6ZcaayrXVg8DjAn9sZ/rDu6o59ajaAiredvd0HgnNGsL9BI23j93pDfrfy9Xx/MpBNC9rtC1lLP
        +wkRAS/0X5pSPhnJEzTHKT2D7J4dq
X-Received: by 2002:a19:9145:0:b0:48a:7ee4:5eac with SMTP id y5-20020a199145000000b0048a7ee45eacmr849962lfj.641.1659079934548;
        Fri, 29 Jul 2022 00:32:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR724Z9TIFD4TBShsFS+WI+wVQDzXpDufX5nXFkZ8Tvp62c/qrPU4I1gK/YFs9x7sodZ+Vk2IgowAFkA5+mh0bs=
X-Received: by 2002:a19:9145:0:b0:48a:7ee4:5eac with SMTP id
 y5-20020a199145000000b0048a7ee45eacmr849942lfj.641.1659079934017; Fri, 29 Jul
 2022 00:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
 <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn> <16a232ad-e0a1-fd4c-ae3e-27db168daacb@redhat.com>
 <2a8838c4-2e6f-6de7-dcdc-572699ff3dc9@sjtu.edu.cn>
In-Reply-To: <2a8838c4-2e6f-6de7-dcdc-572699ff3dc9@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 29 Jul 2022 15:32:02 +0800
Message-ID: <CACGkMEuwgZRt=J_2i-XugMZtcG-xZ7ZF1RpTjmErT5+RCcZ1OQ@mail.gmail.com>
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     eperezma <eperezma@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 4:26 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> On 2022/7/26 15:36, Jason Wang wrote:
>
>
> =E5=9C=A8 2022/7/21 16:43, Guo Zhi =E5=86=99=E9=81=93:
>
> Device may not use descriptors in order, for example, NIC and SCSI may
> not call __vhost_add_used_n with buffers in order.  It's the task of
> __vhost_add_used_n to order them.
>
>
>
> I'm not sure this is ture. Having ooo descriptors is probably by design t=
o have better performance.
>
> This might be obvious for device that may have elevator or QOS stuffs.
>
> I suspect the right thing to do here is, for the device that can't perfor=
m better in the case of IN_ORDER, let's simply not offer IN_ORDER (zerocopy=
 or scsi). And for the device we know it can perform better, non-zercopy et=
hernet device we can do that.
>
>
>   This commit reorder the buffers using
> vq->heads, only the batch is begin from the expected start point and is
> continuous can the batch be exposed to driver.  And only writing out a
> single used ring for a batch of descriptors, according to VIRTIO 1.1
> spec.
>
>
>
> So this sounds more like a "workaround" of the device that can't consume =
buffer in order, I suspect it can help in performance.
>
> More below.
>
>
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
>   drivers/vhost/vhost.h |  3 +++
>   2 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826c..e2e77e29f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>       vq->used_flags =3D 0;
>       vq->log_used =3D false;
>       vq->log_addr =3D -1ull;
> +    vq->next_used_head_idx =3D 0;
>       vq->private_data =3D NULL;
>       vq->acked_features =3D 0;
>       vq->acked_backend_features =3D 0;
> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *=
dev)
>                         GFP_KERNEL);
>           if (!vq->indirect || !vq->log || !vq->heads)
>               goto err_nomem;
> +
> +        memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
>       }
>       return 0;
>   @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virt=
queue *vq,
>                   unsigned count)
>   {
>       vring_used_elem_t __user *used;
> +    struct vring_desc desc;
>       u16 old, new;
>       int start;
> +    int begin, end, i;
> +    int copy_n =3D count;
> +
> +    if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>
>
>
> How do you guarantee that ids of heads are contiguous?
>
> There is no need to be contiguous for ids of heads.
>
> For example, I have three buffer { .id =3D 0, 15}, {.id =3D 20, 30} {.id =
=3D 15, 20} for vhost_add_used_n. Then I will let the vq->heads[0].len=3D15=
. vq->heads[15].len=3D5, vq->heads[20].len=3D10 as reorder. Once I found th=
ere is no hold in the batched descriptors. I will expose them to driver.

So spec said:

"If VIRTIO_F_IN_ORDER has been negotiated, driver uses descriptors in
ring order: starting from offset 0 in the table, and wrapping around
at the end of the table."

And

"VIRTIO_F_IN_ORDER(35)This feature indicates that all buffers are used
by the device in the same order in which they have been made
available."

This means your example is not an IN_ORDER device.

The driver should submit buffers (assuming each buffer have one
descriptor) in order {id =3D 0, 15}, {id =3D 1, 30} and {id =3D 2, 20}.

And even if it is submitted in order, we can not use a batch because:

"The skipped buffers (for which no used ring entry was written) are
assumed to have been used (read or written) by the device completely."

This means for TX we are probably ok, but for rx, unless we know the
buffers were written completely, we can't write them in a batch.

I'd suggest to do cross testing for this series:

1) testing vhost IN_ORDER support with DPDK virtio PMD
2) testing virtio IN_ORDER with DPDK vhost-user via testpmd

Thanks


>
>
> +        /* calculate descriptor chain length for each used buffer */
>
>
>
> I'm a little bit confused about this comment, we have heads[i].len for th=
is?
>
> Maybe I should not use vq->heads, some misleading.
>
>
> +        for (i =3D 0; i < count; i++) {
> +            begin =3D heads[i].id;
> +            end =3D begin;
> +            vq->heads[begin].len =3D 0;
>
>
>
> Does this work for e.g RX virtqueue?
>
>
> +            do {
> +                vq->heads[begin].len +=3D 1;
> +                if (unlikely(vhost_get_desc(vq, &desc, end))) {
>
>
>
> Let's try hard to avoid more userspace copy here, it's the source of perf=
ormance regression.
>
> Thanks
>
>
> +                    vq_err(vq, "Failed to get descriptor: idx %d addr %p=
\n",
> +                           end, vq->desc + end);
> +                    return -EFAULT;
> +                }
> +            } while ((end =3D next_desc(vq, &desc)) !=3D -1);
> +        }
> +
> +        count =3D 0;
> +        /* sort and batch continuous used ring entry */
> +        while (vq->heads[vq->next_used_head_idx].len !=3D 0) {
> +            count++;
> +            i =3D vq->next_used_head_idx;
> +            vq->next_used_head_idx =3D (vq->next_used_head_idx +
> +                          vq->heads[vq->next_used_head_idx].len)
> +                          % vq->num;
> +            vq->heads[i].len =3D 0;
> +        }
> +        /* only write out a single used ring entry with the id correspon=
ding
> +         * to the head entry of the descriptor chain describing the last=
 buffer
> +         * in the batch.
> +         */
> +        heads[0].id =3D i;
> +        copy_n =3D 1;
> +    }
>         start =3D vq->last_used_idx & (vq->num - 1);
>       used =3D vq->used->ring + start;
> -    if (vhost_put_used(vq, heads, start, count)) {
> +    if (vhost_put_used(vq, heads, start, copy_n)) {
>           vq_err(vq, "Failed to write used");
>           return -EFAULT;
>       }
> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, st=
ruct vring_used_elem *heads,
>         start =3D vq->last_used_idx & (vq->num - 1);
>       n =3D vq->num - start;
> -    if (n < count) {
> +    if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>           r =3D __vhost_add_used_n(vq, heads, n);
>           if (r < 0)
>               return r;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index d9109107a..7b2c0fbb5 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
>       bool log_used;
>       u64 log_addr;
>   +    /* Sort heads in order */
> +    u16 next_used_head_idx;
> +
>       struct iovec iov[UIO_MAXIOV];
>       struct iovec iotlb_iov[64];
>       struct iovec *indirect;
>
>
>

