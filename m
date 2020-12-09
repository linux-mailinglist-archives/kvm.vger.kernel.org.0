Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4522D4502
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 16:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgLIPFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 10:05:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbgLIPFC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 10:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607526215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iw54FHHDuTFhDT6GwXV18fdfBrw8McPHYg/txzp+0d0=;
        b=Tck3UrXbfiOXizpPQ7zHI11kIS/6lfNj2LbM9tvRX300E4xWAbVUZiu1YzlOCVJVDClqDr
        krGXhfxQy4PuJuugc/wYK3Npc9laW4dHvJmSTHGxR/0gHbjudwKxDYWcZ/1wZbd68JkguX
        UdLvgpOK9FQ1fK9qNjJxA8lNQ98tgC4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-LAt8vYxzNcWwW1AkEoUU6g-1; Wed, 09 Dec 2020 10:03:33 -0500
X-MC-Unique: LAt8vYxzNcWwW1AkEoUU6g-1
Received: by mail-qk1-f197.google.com with SMTP id u9so1232505qkk.5
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 07:03:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iw54FHHDuTFhDT6GwXV18fdfBrw8McPHYg/txzp+0d0=;
        b=onfhX4JR9xxbFTs1Tr/uKiAvu65A/kF/JZmDYX7a5Ri8ckInpZVMiXPrh6KouSM0vq
         OWEBzFAGHJ2QS8DxDAesdapASTgvuyNZbu9qRW1uTRV0YPXhD067nvwGsNMJ+F8PEWZe
         Ue4Y70+K+IeN/uOBUrymbkqCX4PLT7c7xCENYgXw9SW/uA22eJJc6xi2mB83QB21Tvhi
         yoEqjfPrKFPJJX61Rhz1qdDGcPiayMQP+5L0YKF/WL38tSb4EYCe0rGe0+CjAhxbT7BR
         FMHu3qzfRM3YitRqxMRwW0jsCVibuS7ZiiOCQPNuhBd/FBujZog1To3oPkotcQo4DCyA
         y+3w==
X-Gm-Message-State: AOAM531Ry8dZal/RZk9hOpcghLzrUlIYtkl6r+VdjxbKmSxv+T0Z3ZW8
        gAOqUplI2mXkz0/WNISUB622Z3oG2XnUZ+pHaXvqWbJYNd4BJ+tNuTHerdsHy3HKfJjI/N00C6z
        XBxpbUyH+Z8JkanL8OrV+rshwCU4V
X-Received: by 2002:ad4:580f:: with SMTP id dd15mr1251615qvb.40.1607526213130;
        Wed, 09 Dec 2020 07:03:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweI8sxDZKlah6jmbApPxGkZoMpfGjjfiMSfW6H0Qu37ltmLba0tnkGPfFbXGJUmmuys6dh6d25LZZBCYIVmhc=
X-Received: by 2002:ad4:580f:: with SMTP id dd15mr1251570qvb.40.1607526212910;
 Wed, 09 Dec 2020 07:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-6-eperezma@redhat.com>
 <20201207165216.GL203660@stefanha-x1.localdomain>
In-Reply-To: <20201207165216.GL203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 16:02:56 +0100
Message-ID: <CAJaqyWfSUHD0MU=1yfU1N6pZ4TU7prxyoG6NY-VyNGt=MO9H4g@mail.gmail.com>
Subject: Re: [RFC PATCH 05/27] vhost: Add hdev->dev.sw_lm_vq_handler
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

On Mon, Dec 7, 2020 at 5:52 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:43PM +0100, Eugenio P=C3=A9rez wrote:
> > Only virtio-net honors it.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  include/hw/virtio/vhost.h |  1 +
> >  hw/net/virtio-net.c       | 39 ++++++++++++++++++++++++++++-----------
> >  2 files changed, 29 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> > index 4a8bc75415..b5b7496537 100644
> > --- a/include/hw/virtio/vhost.h
> > +++ b/include/hw/virtio/vhost.h
> > @@ -83,6 +83,7 @@ struct vhost_dev {
> >      bool started;
> >      bool log_enabled;
> >      uint64_t log_size;
> > +    VirtIOHandleOutput sw_lm_vq_handler;
>
> sw =3D=3D software?
> lm =3D=3D live migration?
>
> Maybe there is a name that is clearer. What are these virtqueues called?
> Shadow vqs? Logged vqs?
>
> Live migration is a feature that uses dirty memory logging, but other
> features may use dirty memory logging too. The name should probably not
> be associated with live migration.
>

I totally agree, I find shadow_vq a better name for it.

> >      Error *migration_blocker;
> >      const VhostOps *vhost_ops;
> >      void *opaque;
> > diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
> > index 9179013ac4..9a69ae3598 100644
> > --- a/hw/net/virtio-net.c
> > +++ b/hw/net/virtio-net.c
> > @@ -2628,24 +2628,32 @@ static void virtio_net_tx_bh(void *opaque)
> >      }
> >  }
> >
> > -static void virtio_net_add_queue(VirtIONet *n, int index)
> > +static void virtio_net_add_queue(VirtIONet *n, int index,
> > +                                 VirtIOHandleOutput custom_handler)
> >  {
>
> We talked about the possibility of moving this into the generic vhost
> code so that devices don't need to be modified. It would be nice to hide
> this feature inside vhost.

I'm thinking of tying it to VirtQueue, allowing the caller to override
the handler knowing it is not going to be called (I mean, not offering
race conditions protection, like before of starting processing
notifications in qemu calling vhost_dev_disable_notifiers).

Thanks!

