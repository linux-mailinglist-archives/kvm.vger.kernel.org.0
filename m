Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73BC4FCCA9
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 04:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiDLCvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 22:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243573AbiDLCvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 22:51:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB198222A5
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 19:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649731775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fJBNte/3e7GfibiQrK4sBywM+oAime7uDuFoDGQDJlo=;
        b=gj+WqOnWhxr4+wex08XSZu5v+xmNjqBBAxlvEziCCljR/4GVmcfkzioM8FvJfO3q/4m9xD
        a6vSvgTIlgLbLVmfBRYa+0Z2d26k3NHlw3xP+/h3ovq6Yxpu6UsuecSiPtxTeGzC6jgnP5
        avfFjkVeD/6wyvl9hwvV9o/Nj05wbfk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-d61m28YMPAeNHa6kqrUv9g-1; Mon, 11 Apr 2022 22:49:33 -0400
X-MC-Unique: d61m28YMPAeNHa6kqrUv9g-1
Received: by mail-lf1-f70.google.com with SMTP id d12-20020a05651233cc00b0044ad60fe93dso5315935lfg.11
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 19:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fJBNte/3e7GfibiQrK4sBywM+oAime7uDuFoDGQDJlo=;
        b=zmTeiET26kY+nSYCaoy+PKMKjs3VmJtcemMH78C9CXTXPnwscYIrt86DsptAgYkPS9
         T9DzzfdXbh+MDgOX3/1WWF63aphjtAcWrWk2+D+EfS7/eqmCuszCsNgH4u2CR87wNNbY
         /UoGPhySZSbPFuDckWrWcHbRwJfhpvM9WQXcIQgIJ043GspcO+twuJ0Jm8rdXRAHwxo8
         PbsYCfADXLrCm8v9CBP44ftkoFPpAaCu4x5OMeEykSeJlZR6S85QHsM8kw/6kF8D7SOo
         hpzuq9Lvkd+hIEjEJW5Bm318Is2SHZ0UUlajumQ/WvPLS4LoGo9unp2JuX0KNwzlN4u8
         32XA==
X-Gm-Message-State: AOAM532PV893gCljl1ClYQ6lGPm3gX7uDoL8g2sx7369Kj+K5qqGFF8a
        aBESdYfDaR7l4SpVcYCx5msI7zoZlfE02k0DSizFXFQbslMnfczJwcNQGm2g8dqa1uedHcUpvcU
        ALltxUkoCSFLGpUfwFjJ3JzapPV16
X-Received: by 2002:a2e:b53a:0:b0:24b:12f7:237b with SMTP id z26-20020a2eb53a000000b0024b12f7237bmr22142537ljm.177.1649731772164;
        Mon, 11 Apr 2022 19:49:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5gifaFaCekGQJ1T+aENC3f64ZQLZ890sWCpVm+zpEZs7NBKRTWSl38qWP6QLR7AWdmzIlDvMoCmEZyQhCI0I=
X-Received: by 2002:a2e:b53a:0:b0:24b:12f7:237b with SMTP id
 z26-20020a2eb53a000000b0024b12f7237bmr22142498ljm.177.1649731771824; Mon, 11
 Apr 2022 19:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-3-xuanzhuo@linux.alibaba.com> <9868de23-c171-2492-a43f-78f51df84640@redhat.com>
In-Reply-To: <9868de23-c171-2492-a43f-78f51df84640@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 12 Apr 2022 10:49:20 +0800
Message-ID: <CACGkMEvgO=QsBjHZLhW72gsnWUp6JWOZkSrVZYHBmPoP+KhTZg@mail.gmail.com>
Subject: Re: [PATCH v9 02/32] virtio: struct virtio_config_ops add callbacks
 for queue_reset
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 10:47 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > Performing reset on a queue is divided into four steps:
> >
> >   1. transport: notify the device to reset the queue
> >   2. vring:     recycle the buffer submitted
> >   3. vring:     reset/resize the vring (may re-alloc)
> >   4. transport: mmap vring to device, and enable the queue
>
>
> Nit: it looks to me we'd better say it's an example (since step 3 or
> even 2 is not a must).
>
>
> >
> > In order to support queue reset, add two callbacks(reset_vq,
> > enable_reset_vq) in struct virtio_config_ops to implement steps 1 and 4=
.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   include/linux/virtio_config.h | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_confi=
g.h
> > index 4d107ad31149..d4adcd0e1c57 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -74,6 +74,16 @@ struct virtio_shm_region {
> >    * @set_vq_affinity: set the affinity for a virtqueue (optional).
> >    * @get_vq_affinity: get the affinity for a virtqueue (optional).
> >    * @get_shm_region: get a shared memory region based on the index.
> > + * @reset_vq: reset a queue individually (optional).
> > + *   vq: the virtqueue
> > + *   Returns 0 on success or error status
> > + *   reset_vq will guarantee that the callbacks are disabled and synch=
ronized.
> > + *   Except for the callback, the caller should guarantee that the vri=
ng is
>
>
> I wonder what's the implications for virtio hardening[1]. In that

For [1] I meant
https://lore.kernel.org/lkml/20220406083538.16274-1-jasowang@redhat.com/

Thanks


> series, we agree to have a synchronize_vqs() config ops to make sure
> callbacks are synchronized.
>
> It uses a global flag and a device wise synchronization mechanism. It
> looks to me we need to switch to
>
> 1) per virtqueue flag
> 2) per virtqueue synchronization
>
> Thanks
>
>
> > + *   not accessed by any functions of virtqueue.
> > + * @enable_reset_vq: enable a reset queue
> > + *   vq: the virtqueue
> > + *   Returns 0 on success or error status
> > + *   If reset_vq is set, then enable_reset_vq must also be set.
> >    */
> >   typedef void vq_callback_t(struct virtqueue *);
> >   struct virtio_config_ops {
> > @@ -100,6 +110,8 @@ struct virtio_config_ops {
> >                       int index);
> >       bool (*get_shm_region)(struct virtio_device *vdev,
> >                              struct virtio_shm_region *region, u8 id);
> > +     int (*reset_vq)(struct virtqueue *vq);
> > +     int (*enable_reset_vq)(struct virtqueue *vq);
> >   };
> >
> >   /* If driver didn't advertise the feature, it will never appear. */

