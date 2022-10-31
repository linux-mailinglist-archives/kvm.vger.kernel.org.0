Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B092861350C
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 12:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJaL5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 07:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiJaL5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 07:57:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D976F58D
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 04:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667217405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=is2kyiKfcs0Jnce8w6Po94cmNanhClWWjKTTiNklvjc=;
        b=eKEwQvbHwSXGf69DdP0trnV4uvLscu0sTHI0g+uYvQibF3rP+qGfPwwITj54b1EMcIP5c2
        0X7U9D95bYAplhDzfjPZ5/nOa+3Gr7flARam8DrjuI2xGOJKtgLD3+k5dL9bDbJ6WxhVRS
        xbZpaDAgnrKS9zEmVFUeMzl7opKRa34=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-K1RvchIdMNezHL41J463Eg-1; Mon, 31 Oct 2022 07:56:44 -0400
X-MC-Unique: K1RvchIdMNezHL41J463Eg-1
Received: by mail-pl1-f197.google.com with SMTP id o7-20020a170902d4c700b001868cdac9adso8051344plg.13
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 04:56:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=is2kyiKfcs0Jnce8w6Po94cmNanhClWWjKTTiNklvjc=;
        b=AdcT9EeMuQEd+LQbikxSbxRqnW1mGWWjfGGYTb/3OsyXb+P+m1TRDYbrZ31whJWtH/
         VERL/zEZF/ZSarHyg2KZfAWBPxueIpsq8wkgtBiLcs83erYvIsNmLpbkuEOHZ84nuQAo
         ToPqmmpny2aGcQIiGWe76q0WlE6qmlpNESlVf548tgRDkLUuS+9TGE+8Yj4av0Q/2KJZ
         ZsnEEVsn9/47bEHZiq8J8piVWtck8ikXV6HQx6LAjNCnzmbDvl/X86qsHSY3UCg/LMGR
         rGzQC0cK+XuptU6KhxcPsXkhtMJXlLYVOgi8g/ARHd/afEfudt4tVhbrSSBlE806mSUh
         y5yw==
X-Gm-Message-State: ACrzQf39QZmvYgiJD1qH0dAEGdmK+P4VYGRL8hsVI+tWYejfPoxcjvUB
        3a/Gpctl64hxli0sK7W3tJyvxyXDUYzVa5xcTXkRkHD/ZvYFkQRfiTOjTIh74DatsYy9LyEwoEM
        7GvguL2DHS/YccVGx09jBZIs6wTsB
X-Received: by 2002:a05:6a00:170b:b0:56d:4b31:c4cf with SMTP id h11-20020a056a00170b00b0056d4b31c4cfmr7680503pfc.68.1667217403457;
        Mon, 31 Oct 2022 04:56:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6jNLfA45YaiVPR2aKe95bV6YNpfWp8EGXyRhtWDZbco2jkAj0u84LE/gTZRD/lKiZZAaL4B6tRbKn529pc76U=
X-Received: by 2002:a05:6a00:170b:b0:56d:4b31:c4cf with SMTP id
 h11-20020a056a00170b00b0056d4b31c4cfmr7680483pfc.68.1667217403192; Mon, 31
 Oct 2022 04:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221011104154.1209338-1-eperezma@redhat.com> <20221011104154.1209338-3-eperezma@redhat.com>
 <20221031041821-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221031041821-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 31 Oct 2022 12:56:06 +0100
Message-ID: <CAJaqyWcaZ32agF0CKPUU89NHj0Di9Q5kFJDsWcUwCG2q0u_kEQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] vdpa: Allocate SVQ unconditionally
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, Gautam Dawar <gdawar@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Harpreet Singh Anand <hanand@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 9:21 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Oct 11, 2022 at 12:41:50PM +0200, Eugenio P=C3=A9rez wrote:
> > SVQ may run or not in a device depending on runtime conditions (for
> > example, if the device can move CVQ to its own group or not).
> >
> > Allocate the resources unconditionally, and decide later if to use them
> > or not.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
>
> I applied this for now but I really dislike it that we are wasting
> resources like this.
>
> Can I just drop this patch from the series? It looks like things
> will just work anyway ...
>

It will not work simply dropping this patch, because new code expects
SVQ vrings to be already allocated. But that is doable with more work.

> I know, when one works on a feature it seems like everyone should
> enable it - but the reality is qemu already works quite well for
> most users and it is our resposibility to first do no harm.
>

I agree, but then it is better to drop this series entirely for this
merge window. I think it is justified to add it at the beginning of
the next merge window, and to give more time for testing and adding
more features actually.

However, I think shadow CVQ should start by default as long as the
device has the right set of both virtio and vdpa features. Otherwise,
we need another cmdline parameter, something like x-cvq-svq, and the
update of other layers like libvirt.

Thanks!

>
> > ---
> >  hw/virtio/vhost-vdpa.c | 33 +++++++++++++++------------------
> >  1 file changed, 15 insertions(+), 18 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 7f0ff4df5b..d966966131 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -410,6 +410,21 @@ static int vhost_vdpa_init_svq(struct vhost_dev *h=
dev, struct vhost_vdpa *v,
> >      int r;
> >      bool ok;
> >
> > +    shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
> > +    for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> > +        g_autoptr(VhostShadowVirtqueue) svq;
> > +
> > +        svq =3D vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> > +                            v->shadow_vq_ops_opaque);
> > +        if (unlikely(!svq)) {
> > +            error_setg(errp, "Cannot create svq %u", n);
> > +            return -1;
> > +        }
> > +        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> > +    }
> > +
> > +    v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> > +
> >      if (!v->shadow_vqs_enabled) {
> >          return 0;
> >      }
> > @@ -426,20 +441,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *h=
dev, struct vhost_vdpa *v,
> >          return -1;
> >      }
> >
> > -    shadow_vqs =3D g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
> > -    for (unsigned n =3D 0; n < hdev->nvqs; ++n) {
> > -        g_autoptr(VhostShadowVirtqueue) svq;
> > -
> > -        svq =3D vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
> > -                            v->shadow_vq_ops_opaque);
> > -        if (unlikely(!svq)) {
> > -            error_setg(errp, "Cannot create svq %u", n);
> > -            return -1;
> > -        }
> > -        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
> > -    }
> > -
> > -    v->shadow_vqs =3D g_steal_pointer(&shadow_vqs);
> >      return 0;
> >  }
> >
> > @@ -580,10 +581,6 @@ static void vhost_vdpa_svq_cleanup(struct vhost_de=
v *dev)
> >      struct vhost_vdpa *v =3D dev->opaque;
> >      size_t idx;
> >
> > -    if (!v->shadow_vqs) {
> > -        return;
> > -    }
> > -
> >      for (idx =3D 0; idx < v->shadow_vqs->len; ++idx) {
> >          vhost_svq_stop(g_ptr_array_index(v->shadow_vqs, idx));
> >      }
> > --
> > 2.31.1
>

