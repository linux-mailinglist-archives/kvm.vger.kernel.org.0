Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A0E2D4878
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 19:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgLIR7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 12:59:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730721AbgLIR7U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 12:59:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607536674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/TyFuiiN7T8ztg3J+dkXREgPHoexWcv0xcyj6tH0TjY=;
        b=iEeAxQxUZUWWmjUDgxPI7QAFNgHbyqwA1P0M1iWJHHVWitWMLBaV+u3YdTGOUFJrvYlu35
        jvB1J4eYrW124d8DllYnGBH89Woi/E99njj+GG/5/p9vpPj9egLWo1UZ0ThPObrereogZS
        4U+E6JB/PXIeUlKnZVuuzG14B58cItQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-xQyUcCdpMqin9twmRJXqag-1; Wed, 09 Dec 2020 12:57:50 -0500
X-MC-Unique: xQyUcCdpMqin9twmRJXqag-1
Received: by mail-qk1-f198.google.com with SMTP id c25so1634845qko.19
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 09:57:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/TyFuiiN7T8ztg3J+dkXREgPHoexWcv0xcyj6tH0TjY=;
        b=P3OJntD/kIK7Nn6EO/pxzUkIzOHI5VcMBbS8Y43dOmgOJJD+r7MrkyixT7oV9ALjFi
         j4W5Kc/4EgLzKcPMOimDAknJU5R0wIrcrve3cLgqscRlf4uCUXrKR++LnbJk1eG7rTTP
         yi9zlW5sgDkU9ygTUlL+4O3kyZinKlOTvO8J58+PjiBHcyPBN2z2IAZfmQ2Jcsk/Js5Q
         phwfb9rZs4xKBRLUeEHKy99/BS97ELScX35UlMHNsv3voi1R4f3/a+Pvu85Zakq9ri8Z
         aJaGe8xpnsDyHa7tltVZfQOQocFf1w+FQmgli7TkIsBZbCxLAiCckzwcJBW4mwWMdH7j
         6GVA==
X-Gm-Message-State: AOAM533JaZwKsr8Dkhmeg4fSpEDsmIwua2QGECb6fxBgWKPGcQ3FrfVr
        /EQ1QoMZqdChK2aMFyrsewPOIGyjhCPsMKFQQKRLdhfto0qvHmKLvxGUCVPTJnyBuOcjMFRjfKO
        3tL+/nxmpOTy9bI5JTWN2qFkvfMqo
X-Received: by 2002:a37:b987:: with SMTP id j129mr1641815qkf.131.1607536669866;
        Wed, 09 Dec 2020 09:57:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPk1684Ru5rlDYOwl7BoAgTKuEcvaEAnSF0249oHQ/8MPs97gHSBbXi1zddK6zsparPuktdrs4tC120cCgL0c=
X-Received: by 2002:a37:b987:: with SMTP id j129mr1641779qkf.131.1607536669584;
 Wed, 09 Dec 2020 09:57:49 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-9-eperezma@redhat.com>
 <20201208072051.GO203660@stefanha-x1.localdomain>
In-Reply-To: <20201208072051.GO203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 18:57:12 +0100
Message-ID: <CAJaqyWeYV8jmXOFcvoB9LzY471KzWGT=iX+emB=O+GzWqDUjOw@mail.gmail.com>
Subject: Re: [RFC PATCH 08/27] vhost: Add a flag for software assisted Live Migration
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

On Tue, Dec 8, 2020 at 8:21 AM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:46PM +0100, Eugenio P=C3=A9rez wrote:
> > @@ -1571,6 +1577,13 @@ void vhost_dev_disable_notifiers(struct vhost_de=
v *hdev, VirtIODevice *vdev)
> >      BusState *qbus =3D BUS(qdev_get_parent_bus(DEVICE(vdev)));
> >      int i, r;
> >
> > +    if (hdev->sw_lm_enabled) {
> > +        /* We've been called after migration is completed, so no need =
to
> > +           disable it again
> > +        */
> > +        return;
> > +    }
> > +
> >      for (i =3D 0; i < hdev->nvqs; ++i) {
> >          r =3D virtio_bus_set_host_notifier(VIRTIO_BUS(qbus), hdev->vq_=
index + i,
> >                                           false);
>
> What is the purpose of this?

It is again a quick hack to get shadow_vq POC working. Again, it
deserves a better comment :).

If I recall correctly, vhost-net calls vhost_dev_disable_notifiers
again on destruction, and it calls to memory_region_del_eventfd, then
virtio_pci_ioeventfd_assign, which is not safe to call again because
of the i !=3D mr->ioeventfd_nb assertion.

The right fix for this should be either in virtio-pci (more generic,
but not sure if calling it again is the expected semantic of it),
individual vhost devices (less generic) or where it is at this moment,
but with the right comment.

Thanks!

