Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D002D48C8
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 19:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgLISRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 13:17:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732477AbgLISRX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 13:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607537756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LCO20VEqHn7kh1peBYJr6YHeYgR9igxb9bxHxv1SRhY=;
        b=H/+MmGDsvdYPx/0SIDvQUyNjXAx9J3H8NUCwJI3NQRlcgELqLGmHQKPFxovhpwHawrvwDB
        hUSo3y+tPP1auGeyzrPDaX45h9iFDZjusgLDWfDSlyDM8P0dSah/l6aKAipuToQeS9bhDF
        2r8JpWXy5ZfsvP01I2w+j8o0/WchJGM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-qDGXBBs2Pl2_ztxXSXAFVg-1; Wed, 09 Dec 2020 13:15:54 -0500
X-MC-Unique: qDGXBBs2Pl2_ztxXSXAFVg-1
Received: by mail-qt1-f199.google.com with SMTP id e14so1843708qtr.8
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 10:15:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LCO20VEqHn7kh1peBYJr6YHeYgR9igxb9bxHxv1SRhY=;
        b=kL/A9wvsJzpoxjybPHIFitf6eci3CwCrx9giIDynf4YyL39yLd7+i9N6tXFIhYfx/K
         aRMEbp+ztu1tlXbrsuM66vcwuG5VFcv3UewkFahQZMkppEua7gx0jytWOivT+pk1tXxn
         DpY2mk9H+mJnR9zXwxebkIUQP2srxOyop5yPEz3Btq77PHMvVeDNEU8z5mD2jygufhnD
         yZRlDxzxn/xBvt68iJ0YbB4k1sIXupuHX/1OGPGH3MRccAg0Bec5AP5EbsA7o96xw6jf
         32+7DgOyCrU8btrVsZw/ehD87fzIVAApt3dS9PcOcH3rozffSBEefqpKwvO1l22k3MsL
         XQQQ==
X-Gm-Message-State: AOAM533CjudA55sWcjIaYsiyJDAxLrlQIrzd8O9B8WexDidm1Ch10g2N
        5JD00vLVBYs52BnJAWE4YHIqAMWnf1cs3UQ+F9hOBeQ9mX74jLC7SMo9WMAHwH8jg3qpIoWf/c2
        5iTCf4dDMUvxVSYKWc4LpOa/UE/vW
X-Received: by 2002:aed:2742:: with SMTP id n60mr4525080qtd.221.1607537754326;
        Wed, 09 Dec 2020 10:15:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRR7eTmC6fUaKX0udwkL3ONw4tu9eb9neNhi5/HstFuag8F4I8eIY3AujcOjLz0M0eITRDUoT9ahz2b/eZm9w=
X-Received: by 2002:aed:2742:: with SMTP id n60mr4525061qtd.221.1607537754124;
 Wed, 09 Dec 2020 10:15:54 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-11-eperezma@redhat.com>
 <20201208081755.GS203660@stefanha-x1.localdomain>
In-Reply-To: <20201208081755.GS203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 19:15:17 +0100
Message-ID: <CAJaqyWdLyVCzm-WAxaGPvs6kO09ks1cPe1nzM52JHe2KxuYqgw@mail.gmail.com>
Subject: Re: [RFC PATCH 10/27] vhost: Allocate shadow vring
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

On Tue, Dec 8, 2020 at 9:18 AM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:48PM +0100, Eugenio P=C3=A9rez wrote:
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  hw/virtio/vhost-sw-lm-ring.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.=
c
> > index cbf53965cd..cd7b5ba772 100644
> > --- a/hw/virtio/vhost-sw-lm-ring.c
> > +++ b/hw/virtio/vhost-sw-lm-ring.c
> > @@ -16,8 +16,11 @@
> >  #include "qemu/event_notifier.h"
> >
> >  typedef struct VhostShadowVirtqueue {
> > +    struct vring vring;
> >      EventNotifier hdev_notifier;
> >      VirtQueue *vq;
> > +
> > +    vring_desc_t descs[];
> >  } VhostShadowVirtqueue;
>
> Looking at later patches I see that this is the vhost hdev vring state,
> not the VirtIODevice vring state. That makes more sense.

I will add a comment here too.

