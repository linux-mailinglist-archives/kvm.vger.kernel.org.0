Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B07C58973D
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 07:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbiHDFEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 01:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiHDFEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 01:04:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A7385FAEC
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 22:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659589470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BgLzkyxivpxssxT30ZKZR41YIXRw12sSiCVIsAhFrQ=;
        b=HIE+gHsnpiJarDMY7Xf4TENSAeJTZ5IIfGZBmTPuxgHrV2kP7FXG3zOMksNPAfgmtsAfiI
        cCtkCkJ435Wq6keWzwroB9zFPDZioIXWNgnQowT0thSbWJnJAL4S09AlJZbbNCC2Ty13Vp
        R75XsafhIdcTC4qIsbxGjNlPHMa5ueI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-VaRrfyLUMJmHjyXKvKqvIQ-1; Thu, 04 Aug 2022 01:04:29 -0400
X-MC-Unique: VaRrfyLUMJmHjyXKvKqvIQ-1
Received: by mail-lf1-f72.google.com with SMTP id w18-20020ac25d52000000b0048af13b6ef6so3435209lfd.7
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 22:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6BgLzkyxivpxssxT30ZKZR41YIXRw12sSiCVIsAhFrQ=;
        b=yfYrIBnlLDzbamYeUpqudwXzNT+kSRJvfbw5lt/ZWEkO2uu6+e/qYaRBq9A2trAI4X
         yQkZbaVflVTbr2O4ddQz6l/CEBFFyJO7lL3V3V57fmfPz4fH8kKWCQd6Lr8+Z9aRedVS
         BeBxfey8NOZJRoUke7p/Rdu9bjGVChGtwXV9vdfs4rLcjXBszMb28T+trmCo5klKHVmC
         xv5c24jyTQ+oNjauaDZSyHJrKeF2lM7LOsIkoLhe2B4ZyMAIPSJ0JsMy/2qzkZK14SlG
         D9Doux1hp0uFImamoVEShhRpCmx03ufY5fLcaczZcVSestPAuVYz0gZ1oo9qSCoe8cMg
         4Eug==
X-Gm-Message-State: ACgBeo2lpkwrfXVNm8gqeCaSHKIAh03aIKvBI4ecc6/U+v/YBvjurCof
        EQQzypYgvyVn1dzx0m3Ek2F0NP6C3iZPoWaQ6S7t1KGY5DdLZpb/orVUkeZxt1nxQyMBzOdYdmT
        XS+phK753NEyzdoJnhiGWrM4hxyzu
X-Received: by 2002:a19:ac09:0:b0:48a:d1b5:1791 with SMTP id g9-20020a19ac09000000b0048ad1b51791mr89512lfc.397.1659589467815;
        Wed, 03 Aug 2022 22:04:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4t/K2cGtun6THXBNHPloepeMXgVEufBLuHVeiLudT98dIeu2GyjvQqL3UL5dgFI7QeRnYBIPno+nD0SyHPerE=
X-Received: by 2002:a19:ac09:0:b0:48a:d1b5:1791 with SMTP id
 g9-20020a19ac09000000b0048ad1b51791mr89499lfc.397.1659589467615; Wed, 03 Aug
 2022 22:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
 <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn> <16a232ad-e0a1-fd4c-ae3e-27db168daacb@redhat.com>
 <2a8838c4-2e6f-6de7-dcdc-572699ff3dc9@sjtu.edu.cn> <CACGkMEuwgZRt=J_2i-XugMZtcG-xZ7ZF1RpTjmErT5+RCcZ1OQ@mail.gmail.com>
 <682271447.4491372.1659449548731.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <682271447.4491372.1659449548731.JavaMail.zimbra@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 4 Aug 2022 13:04:16 +0800
Message-ID: <CACGkMEt4GzC7t0qqc2SgUWDRB9Amr+XDKiYOKmogrOyfCBFwvA@mail.gmail.com>
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 2, 2022 at 10:12 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
>
>
> ----- Original Message -----
> > From: "jasowang" <jasowang@redhat.com>
> > To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> > Cc: "eperezma" <eperezma@redhat.com>, "sgarzare" <sgarzare@redhat.com>,=
 "Michael Tsirkin" <mst@redhat.com>, "netdev"
> > <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>=
, "kvm list" <kvm@vger.kernel.org>,
> > "virtualization" <virtualization@lists.linux-foundation.org>
> > Sent: Friday, July 29, 2022 3:32:02 PM
> > Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
>
> > On Thu, Jul 28, 2022 at 4:26 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrot=
e:
> >>
> >> On 2022/7/26 15:36, Jason Wang wrote:
> >>
> >>
> >> =E5=9C=A8 2022/7/21 16:43, Guo Zhi =E5=86=99=E9=81=93:
> >>
> >> Device may not use descriptors in order, for example, NIC and SCSI may
> >> not call __vhost_add_used_n with buffers in order.  It's the task of
> >> __vhost_add_used_n to order them.
> >>
> >>
> >>
> >> I'm not sure this is ture. Having ooo descriptors is probably by desig=
n to have
> >> better performance.
> >>
> >> This might be obvious for device that may have elevator or QOS stuffs.
> >>
> >> I suspect the right thing to do here is, for the device that can't per=
form
> >> better in the case of IN_ORDER, let's simply not offer IN_ORDER (zeroc=
opy or
> >> scsi). And for the device we know it can perform better, non-zercopy e=
thernet
> >> device we can do that.
> >>
> >>
> >>   This commit reorder the buffers using
> >> vq->heads, only the batch is begin from the expected start point and i=
s
> >> continuous can the batch be exposed to driver.  And only writing out a
> >> single used ring for a batch of descriptors, according to VIRTIO 1.1
> >> spec.
> >>
> >>
> >>
> >> So this sounds more like a "workaround" of the device that can't consu=
me buffer
> >> in order, I suspect it can help in performance.
> >>
> >> More below.
> >>
> >>
> >>
> >> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> >> ---
> >>   drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++=
--
> >>   drivers/vhost/vhost.h |  3 +++
> >>   2 files changed, 45 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> >> index 40097826c..e2e77e29f 100644
> >> --- a/drivers/vhost/vhost.c
> >> +++ b/drivers/vhost/vhost.c
> >> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> >>       vq->used_flags =3D 0;
> >>       vq->log_used =3D false;
> >>       vq->log_addr =3D -1ull;
> >> +    vq->next_used_head_idx =3D 0;
> >>       vq->private_data =3D NULL;
> >>       vq->acked_features =3D 0;
> >>       vq->acked_backend_features =3D 0;
> >> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_de=
v *dev)
> >>                         GFP_KERNEL);
> >>           if (!vq->indirect || !vq->log || !vq->heads)
> >>               goto err_nomem;
> >> +
> >> +        memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
> >>       }
> >>       return 0;
> >>   @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_v=
irtqueue
> >>   *vq,
> >>                   unsigned count)
> >>   {
> >>       vring_used_elem_t __user *used;
> >> +    struct vring_desc desc;
> >>       u16 old, new;
> >>       int start;
> >> +    int begin, end, i;
> >> +    int copy_n =3D count;
> >> +
> >> +    if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> >>
> >>
> >>
> >> How do you guarantee that ids of heads are contiguous?
> >>
> >> There is no need to be contiguous for ids of heads.
> >>
> >> For example, I have three buffer { .id =3D 0, 15}, {.id =3D 20, 30} {.=
id =3D 15, 20}
> >> for vhost_add_used_n. Then I will let the vq->heads[0].len=3D15.
> >> vq->heads[15].len=3D5, vq->heads[20].len=3D10 as reorder. Once I found=
 there is no
> >> hold in the batched descriptors. I will expose them to driver.
> >
> > So spec said:
> >
> > "If VIRTIO_F_IN_ORDER has been negotiated, driver uses descriptors in
> > ring order: starting from offset 0 in the table, and wrapping around
> > at the end of the table."
> >
> > And
> >
> > "VIRTIO_F_IN_ORDER(35)This feature indicates that all buffers are used
> > by the device in the same order in which they have been made
> > available."
> >
> > This means your example is not an IN_ORDER device.
> >
> > The driver should submit buffers (assuming each buffer have one
> > descriptor) in order {id =3D 0, 15}, {id =3D 1, 30} and {id =3D 2, 20}.
> >
> > And even if it is submitted in order, we can not use a batch because:
> >
> > "The skipped buffers (for which no used ring entry was written) are
> > assumed to have been used (read or written) by the device completely."
> >
> > This means for TX we are probably ok, but for rx, unless we know the
> > buffers were written completely, we can't write them in a batch.
> >
> > I'd suggest to do cross testing for this series:
> >
> > 1) testing vhost IN_ORDER support with DPDK virtio PMD
> > 2) testing virtio IN_ORDER with DPDK vhost-user via testpmd
> >
> > Thanks
> >
> You are correct, for rx we can't do a batch because we have to let the dr=
iver know the length of buffers.

Note that we can do a batch for rx when we know all the buffers have
been fully written.

>
> I think these circumstances can offer batch:
> 1. tx
> 2. rx with RX_MRGBUF feature, which introduce a header for each received =
buffer
>
> Consider batch is not a mandatory requirement for in order feature accord=
ing to spec.
> I'd like to let current RFC patch focus on in order implementation, and s=
end another
> patch series to improve performance by batching on above circumstances.

That's fine, how about simply starting from the patch that offers
IN_ORDER when zerocopy is disabled?

Thanks

>
> What's your opinon.
>
> Thanks
> >
> >>
> >>
> >> +        /* calculate descriptor chain length for each used buffer */
> >>
> >>
> >>
> >> I'm a little bit confused about this comment, we have heads[i].len for=
 this?
> >>
> >> Maybe I should not use vq->heads, some misleading.
> >>
> >>
> >> +        for (i =3D 0; i < count; i++) {
> >> +            begin =3D heads[i].id;
> >> +            end =3D begin;
> >> +            vq->heads[begin].len =3D 0;
> >>
> >>
> >>
> >> Does this work for e.g RX virtqueue?
> >>
> >>
> >> +            do {
> >> +                vq->heads[begin].len +=3D 1;
> >> +                if (unlikely(vhost_get_desc(vq, &desc, end))) {
> >>
> >>
> >>
> >> Let's try hard to avoid more userspace copy here, it's the source of p=
erformance
> >> regression.
> >>
> >> Thanks
> >>
> >>
> >> +                    vq_err(vq, "Failed to get descriptor: idx %d addr=
 %p\n",
> >> +                           end, vq->desc + end);
> >> +                    return -EFAULT;
> >> +                }
> >> +            } while ((end =3D next_desc(vq, &desc)) !=3D -1);
> >> +        }
> >> +
> >> +        count =3D 0;
> >> +        /* sort and batch continuous used ring entry */
> >> +        while (vq->heads[vq->next_used_head_idx].len !=3D 0) {
> >> +            count++;
> >> +            i =3D vq->next_used_head_idx;
> >> +            vq->next_used_head_idx =3D (vq->next_used_head_idx +
> >> +                          vq->heads[vq->next_used_head_idx].len)
> >> +                          % vq->num;
> >> +            vq->heads[i].len =3D 0;
> >> +        }
> >> +        /* only write out a single used ring entry with the id corres=
ponding
> >> +         * to the head entry of the descriptor chain describing the l=
ast buffer
> >> +         * in the batch.
> >> +         */
> >> +        heads[0].id =3D i;
> >> +        copy_n =3D 1;
> >> +    }
> >>         start =3D vq->last_used_idx & (vq->num - 1);
> >>       used =3D vq->used->ring + start;
> >> -    if (vhost_put_used(vq, heads, start, count)) {
> >> +    if (vhost_put_used(vq, heads, start, copy_n)) {
> >>           vq_err(vq, "Failed to write used");
> >>           return -EFAULT;
> >>       }
> >> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq,=
 struct
> >> vring_used_elem *heads,
> >>         start =3D vq->last_used_idx & (vq->num - 1);
> >>       n =3D vq->num - start;
> >> -    if (n < count) {
> >> +    if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> >>           r =3D __vhost_add_used_n(vq, heads, n);
> >>           if (r < 0)
> >>               return r;
> >> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> >> index d9109107a..7b2c0fbb5 100644
> >> --- a/drivers/vhost/vhost.h
> >> +++ b/drivers/vhost/vhost.h
> >> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
> >>       bool log_used;
> >>       u64 log_addr;
> >>   +    /* Sort heads in order */
> >> +    u16 next_used_head_idx;
> >> +
> >>       struct iovec iov[UIO_MAXIOV];
> >>       struct iovec iotlb_iov[64];
> >>       struct iovec *indirect;
> >>
> >>
> >>
>

