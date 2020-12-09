Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818E12D3EBC
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 10:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgLIJ2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 04:28:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728884AbgLIJ2p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 04:28:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607506037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bkbNrnwLg4MCQBfK6YxYOGZihNEG5026HVI+jw2DPYc=;
        b=A+JzE0u6fZzx7wrYrZMQFE6PL1mWK9wf1fQgE9D1nMCtjaK/nsuZmJrKgcjMrtUnfLRy44
        JhzMLtm78pQ3av0wftWxGGwOJajqQquJIrjCkAwnE2QwucRSpm5H5jIrwZRg7OOD7dQaX8
        xX0Anvwy+ZjAsEjx0r5DWp8iRm7BfLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-_4IPs0VPO1es2zo-zKkK4w-1; Wed, 09 Dec 2020 04:27:13 -0500
X-MC-Unique: _4IPs0VPO1es2zo-zKkK4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50B981005504;
        Wed,  9 Dec 2020 09:27:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F71D18E59;
        Wed,  9 Dec 2020 09:27:10 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 852DF4BB7B;
        Wed,  9 Dec 2020 09:27:09 +0000 (UTC)
Date:   Wed, 9 Dec 2020 04:26:50 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Eugenio =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org, Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Message-ID: <1410217602.34486578.1607506010536.JavaMail.zimbra@redhat.com>
In-Reply-To: <20201208093715.GX203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com> <20201208093715.GX203660@stefanha-x1.localdomain>
Subject: Re: [RFC PATCH 00/27] vDPA software assisted live migration
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.18]
Thread-Topic: vDPA software assisted live migration
Thread-Index: UAk5pFR+aaXpJfnw1iW4417H+q8oRQ==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

----- Original Message -----
> On Fri, Nov 20, 2020 at 07:50:38PM +0100, Eugenio P=C3=A9rez wrote:
> > This series enable vDPA software assisted live migration for vhost-net
> > devices. This is a new method of vhost devices migration: Instead of
> > relay on vDPA device's dirty logging capability, SW assisted LM
> > intercepts dataplane, forwarding the descriptors between VM and device.
>=20
> Pros:
> + vhost/vDPA devices don't need to implement dirty memory logging
> + Obsoletes ioctl(VHOST_SET_LOG_BASE) and friends
>=20
> Cons:
> - Not generic, relies on vhost-net-specific ioctls
> - Doesn't support VIRTIO Shared Memory Regions
>   https://github.com/oasis-tcs/virtio-spec/blob/master/shared-mem.tex

I may miss something but my understanding is that it's the
responsiblity of device to migrate this part?

> - Performance (see below)
>=20
> I think performance will be significantly lower when the shadow vq is
> enabled. Imagine a vDPA device with hardware vq doorbell registers
> mapped into the guest so the guest driver can directly kick the device.
> When the shadow vq is enabled a vmexit is needed to write to the shadow
> vq ioeventfd, then the host kernel scheduler switches to a QEMU thread
> to read the ioeventfd, the descriptors are translated, QEMU writes to
> the vhost hdev kick fd, the host kernel scheduler switches to the vhost
> worker thread, vhost/vDPA notifies the virtqueue, and finally the
> vDPA driver writes to the hardware vq doorbell register. That is a lot
> of overhead compared to writing to an exitless MMIO register!

I think it's a balance. E.g we can poll the virtqueue to have an
exitless doorbell.

>=20
> If the shadow vq was implemented in drivers/vhost/ and QEMU used the
> existing ioctl(VHOST_SET_LOG_BASE) approach, then the overhead would be
> reduced to just one set of ioeventfd/irqfd. In other words, the QEMU
> dirty memory logging happens asynchronously and isn't in the dataplane.
>=20
> In addition, hardware that supports dirty memory logging as well as
> software vDPA devices could completely eliminate the shadow vq for even
> better performance.

Yes. That's our plan. But the interface might require more thought.

E.g is the bitmap a good approach? To me reporting dirty pages via
virqueue is better since it get less footprint and is self throttled.

And we need an address space other than the one used by guest for
either bitmap for virtqueue.

>=20
> But performance is a question of "is it good enough?". Maybe this
> approach is okay and users don't expect good performance while dirty
> memory logging is enabled.

Yes, and actually such slow down may help for the converge of the
migration.

Note that the whole idea is try to have a generic solution for all
types of devices. It's good to consider the performance but for the
first stage, it should be sufficient to make it work and consider to
optimize on top.

> I just wanted to share the idea of moving the
> shadow vq into the kernel in case you like that approach better.

My understanding is to keep kernel as simple as possible and leave the
polices to userspace as much as possible. E.g it requires us to
disable doorbell mapping and irq offloading, all of which were under
the control of userspace.

Thanks

>=20
> Stefan
>

