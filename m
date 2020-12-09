Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7032D41A4
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 13:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbgLIMCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 07:02:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731046AbgLIMCZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 07:02:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607515258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swJyXfHdLUgSl0keTb4tv1Zg2o/rljVaHBscj8NqdsQ=;
        b=RIVWHCQ1gHOq/yTwI7gJXHSnRZ4TBKl1uQz83a0i6Sd9QnkM6ScFIB6DmAXcegIFumxdGM
        6RdyknPKUtiOwHD3MOxAV1m/eCV+/73kifCDif4tcAl42PBmXOLR2rsah7R8cLYp6VcKlc
        MdJZ8lca5Pfrt5OJryi5Dq4aEaqFXyA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-FaJUMGJuPZGCYZ01ovYmSA-1; Wed, 09 Dec 2020 07:00:57 -0500
X-MC-Unique: FaJUMGJuPZGCYZ01ovYmSA-1
Received: by mail-qv1-f69.google.com with SMTP id 102so922605qva.0
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 04:00:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=swJyXfHdLUgSl0keTb4tv1Zg2o/rljVaHBscj8NqdsQ=;
        b=DCsGqWmPGLDi0Xw7f71OoF/Ku/Lr9FMoo0mFzfh2bnMSX37Ln00u9avyaEp8gjAWA3
         RUI+iNzLiVFha7K5EJaFpNryMBEVJLjP3EetEprP3rv2FqMS+1xmCrli5fw9QwhvJM6s
         JPtm3UC8dP7HyGcp2JFGEeXPzp09mA3j+QBetJVWoqtiJ1FTx9O57baBsL3NsSjl0W/C
         w4QRlrKbvqhvvmWZcgzpsYSIDjNLho40oLi4sgZ02SIASXanmumvSbdWymQOMLFV/T30
         wDx/APUQ7rqvpDTT5rW7p1jpAhcLSkUrfpy36NWtSeWfyPuETRLPEhVL8UM4BXTXy80A
         OCLA==
X-Gm-Message-State: AOAM5338JW3pzixjpCTy2TJiw4bvudc1/Ub63754ymdh/eQOQeyD5Yym
        XLk0wcGY81ELXMl280hKzkCAIwCGTFq2NE1CS7Ntm63dDr46tAq0CO7t+TCqt9NNRQjEhab2eQt
        mFgwGZ+XNhLQgd4aemZWaUNOo9LsW
X-Received: by 2002:ae9:dcc1:: with SMTP id q184mr2482633qkf.425.1607515255954;
        Wed, 09 Dec 2020 04:00:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcJSG02TAyUTW+VNdiN2re1N9kAh2N75Xi7v7CXyvg3kf2iqP7u2vinBaagIz7uHe3uMaKmoLrXvjkvH01MEM=
X-Received: by 2002:ae9:dcc1:: with SMTP id q184mr2482593qkf.425.1607515255708;
 Wed, 09 Dec 2020 04:00:55 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-5-eperezma@redhat.com>
 <20201207164323.GK203660@stefanha-x1.localdomain>
In-Reply-To: <20201207164323.GK203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 13:00:19 +0100
Message-ID: <CAJaqyWd5oAJ4kJOhyDz+1KNvwzqJi3NO+5Z7X6W5ju2Va=LTMQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/27] vhost: add vhost_kernel_set_vring_enable
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 7, 2020 at 5:43 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:42PM +0100, Eugenio P=C3=A9rez wrote:
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  hw/virtio/vhost-backend.c | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
> > index 222bbcc62d..317f1f96fa 100644
> > --- a/hw/virtio/vhost-backend.c
> > +++ b/hw/virtio/vhost-backend.c
> > @@ -201,6 +201,34 @@ static int vhost_kernel_get_vq_index(struct vhost_=
dev *dev, int idx)
> >      return idx - dev->vq_index;
> >  }
> >
> > +static int vhost_kernel_set_vq_enable(struct vhost_dev *dev, unsigned =
idx,
> > +                                      bool enable)
> > +{
> > +    struct vhost_vring_file file =3D {
> > +        .index =3D idx,
> > +    };
> > +
> > +    if (!enable) {
> > +        file.fd =3D -1; /* Pass -1 to unbind from file. */
> > +    } else {
> > +        struct vhost_net *vn_dev =3D container_of(dev, struct vhost_ne=
t, dev);
> > +        file.fd =3D vn_dev->backend;
> > +    }
> > +
> > +    return vhost_kernel_net_set_backend(dev, &file);
>
> This is vhost-net specific even though the function appears to be
> generic. Is there a plan to extend this to all devices?
>

I expected each vhost backend to enable-disable in its own terms, but
I think it could be 100% virtio-device generic with something like the
device state capability:
https://lists.oasis-open.org/archives/virtio-comment/202012/msg00005.html
.

> > +}
> > +
> > +static int vhost_kernel_set_vring_enable(struct vhost_dev *dev, int en=
able)
> > +{
> > +    int i;
> > +
> > +    for (i =3D 0; i < dev->nvqs; ++i) {
> > +        vhost_kernel_set_vq_enable(dev, i, enable);
> > +    }
> > +
> > +    return 0;
> > +}
>
> I suggest exposing the per-vq interface (vhost_kernel_set_vq_enable())
> in VhostOps so it follows the ioctl interface.

It was actually the initial plan, I left as all-or-nothing to make less cha=
nges.

> vhost_kernel_set_vring_enable() can be moved to vhost.c can loop over
> all vqs if callers find it convenient to loop over all vqs.

I'm ok with it. Thinking out loud, I don't know if it is easier for
some devices to enable/disable all of it (less syscalls? less downtime
somehow?) but I find more generic and useful the per-virtqueue
approach.

Thanks!

