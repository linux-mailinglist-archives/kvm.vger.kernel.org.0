Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78C12C3F7F
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 13:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgKYMD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 07:03:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727626AbgKYMD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 07:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606305836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sBi4zzPTjwPa6ezOJc3qVXmspXQKwftdXTLsylIrXVc=;
        b=TMPVhjwMcZXcwPyFT5xt9Tja6DHnaAUlzQRlt5vBJnOngh+7JIGfmIH6+/VC49o1uy1ciP
        3Tj+VY6Iuhtdw6HZU6Kl9QRQyLXXw0lkiwM3ZcHuQuC5hRiJ9iYOtN9uApr5HzIo4L3oAj
        j4/7jKoI5lukX52Je7jy3r6cet7UVHY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-4wElO6V8NWm5L9W1DY0ruA-1; Wed, 25 Nov 2020 07:03:53 -0500
X-MC-Unique: 4wElO6V8NWm5L9W1DY0ruA-1
Received: by mail-qk1-f198.google.com with SMTP id p129so2211639qkc.20
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 04:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sBi4zzPTjwPa6ezOJc3qVXmspXQKwftdXTLsylIrXVc=;
        b=ubxBlZMeEtvVFLFQ4Q1Tjl+JUFg2UuNE4rjra4QOAJvoW37uHgqClaeLBtCrss3Agf
         BFGad8zuto0SbhMxTBolPET0kdVB+GisnEtt0qW5D3s8Ri1GG5XnFlgvBXCqRldlXZvv
         sWGbXAFwgibi9hRUgeZ2ih3/PwhhxQ8Omb1/ejF8RMkKT6Ldbu/fj7N7+A1m8uP+7oeg
         tL4fyaCbnh/wlLIn+xMxPT8XZ9l2Soi73fKX5NtcdYG/z3j9CTc7Al4ea2ap2efi/HZp
         liVAMsED/YQCb9cuv6sXkBq4lTf6VbCsi7yx0morqXzm+vyOJLF+Tz7YsIK6IVorF8Q8
         Yxig==
X-Gm-Message-State: AOAM530xErAPmHaNwkNIFTGNYhCRjmkleBkc+/eMVamgdDMtOBbaHp5n
        dMJsng3KqG+Lg/2h8Gbqu3n6HWunPOiGGC1qke3Kd+/2vKt11EDwuQkZ8Nv7M3VC0d8ZUEY9pXN
        UPDguogINnaOObv/fP8utxESs2/QP
X-Received: by 2002:aed:33c4:: with SMTP id v62mr2617115qtd.19.1606305832973;
        Wed, 25 Nov 2020 04:03:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKP8TG3FLn1iuX+VkpqM+uw/CDSl4Sw66nN8a8exNAAObTTprlTJlIEkyK3jUPhy74hYtYQpwHUSYsGX/RRRE=
X-Received: by 2002:aed:33c4:: with SMTP id v62mr2617074qtd.19.1606305832640;
 Wed, 25 Nov 2020 04:03:52 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <5a4d0b7a-fb62-9e78-9e85-9262dca57f1c@redhat.com>
In-Reply-To: <5a4d0b7a-fb62-9e78-9e85-9262dca57f1c@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 25 Nov 2020 13:03:16 +0100
Message-ID: <CAJaqyWf+6yoMHJuLv=QGLMP4egmdm722=V2kKJ_aiQAfCCQOFw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/27] vDPA software assisted live migration
To:     Jason Wang <jasowang@redhat.com>
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

On Wed, Nov 25, 2020 at 8:09 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/11/21 =E4=B8=8A=E5=8D=882:50, Eugenio P=C3=A9rez wrote:
> > This series enable vDPA software assisted live migration for vhost-net
> > devices. This is a new method of vhost devices migration: Instead of
> > relay on vDPA device's dirty logging capability, SW assisted LM
> > intercepts dataplane, forwarding the descriptors between VM and device.
> >
> > In this migration mode, qemu offers a new vring to the device to
> > read and write into, and disable vhost notifiers, processing guest and
> > vhost notifications in qemu. On used buffer relay, qemu will mark the
> > dirty memory as with plain virtio-net devices. This way, devices does
> > not need to have dirty page logging capability.
> >
> > This series is a POC doing SW LM for vhost-net devices, which already
> > have dirty page logging capabilities. None of the changes have actual
> > effect with current devices until last two patches (26 and 27) are
> > applied, but they can be rebased on top of any other. These checks the
> > device to meet all requirements, and disable vhost-net devices logging
> > so migration goes through SW LM. This last patch is not meant to be
> > applied in the final revision, it is in the series just for testing
> > purposes.
> >
> > For use SW assisted LM these vhost-net devices need to be instantiated:
> > * With IOMMU (iommu_platform=3Don,ats=3Don)
> > * Without event_idx (event_idx=3Doff)
>
>
> So a question is at what level do we want to implement qemu assisted
> live migration. To me it could be done at two levels:
>
> 1) generic vhost level which makes it work for both vhost-net/vhost-user
> and vhost-vDPA
> 2) a specific type of vhost
>
> To me, having a generic one looks better but it would be much more
> complicated. So what I read from this series is it was a vhost kernel
> specific software assisted live migration which is a good start.
> Actually it may even have real use case, e.g it can save dirty bitmaps
> for guest with large memory. But we need to address the above
> limitations first.
>
> So I would like to know what's the reason for mandating iommu platform
> and ats? And I think we need to fix case of event idx support.
>

There is no specific reason for mandating iommu & ats, it was just
started that way.

I will extend the patch to support those cases too.

>
> >
> > Just the notification forwarding (with no descriptor relay) can be
> > achieved with patches 7 and 9, and starting migration. Partial applies
> > between 13 and 24 will not work while migrating on source, and patch
> > 25 is needed for the destination to resume network activity.
> >
> > It is based on the ideas of DPDK SW assisted LM, in the series of
>
>
> Actually we're better than that since there's no need the trick like
> hardcoded IOVA for mediated(shadow) virtqueue.
>
>
> > DPDK's https://patchwork.dpdk.org/cover/48370/ .
>
>
> I notice that you do GPA->VA translations and try to establish a VA->VA
> (use VA as IOVA) mapping via device IOTLB. This shortcut should work for
> vhost-kernel/user but not vhost-vDPA. The reason is that there's no
> guarantee that the whole 64bit address range could be used as IOVA. One
> example is that for hardware IOMMU like intel, it usually has 47 or 52
> bits of address width.
>
> So we probably need an IOVA allocator that can make sure the IOVA is not
> overlapped and fit for [1]. We can probably build the IOVA for guest VA
> via memory listeners. Then we have
>
> 1) IOVA for GPA
> 2) IOVA for shadow VQ
>
> And advertise IOVA to VA mapping to vhost.
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D1b48dc03e575a872404f33b04cd237953c5d7498
>

Got it, will control it too.

Maybe for vhost-net we could directly send iotlb miss for [0,~0ULL].

>
> >
> > Comments are welcome.
> >
> > Thanks!
> >
> > Eugenio P=C3=A9rez (27):
> >    vhost: Add vhost_dev_can_log
> >    vhost: Add device callback in vhost_migration_log
> >    vhost: Move log resize/put to vhost_dev_set_log
> >    vhost: add vhost_kernel_set_vring_enable
> >    vhost: Add hdev->dev.sw_lm_vq_handler
> >    virtio: Add virtio_queue_get_used_notify_split
> >    vhost: Route guest->host notification through qemu
> >    vhost: Add a flag for software assisted Live Migration
> >    vhost: Route host->guest notification through qemu
> >    vhost: Allocate shadow vring
> >    virtio: const-ify all virtio_tswap* functions
> >    virtio: Add virtio_queue_full
> >    vhost: Send buffers to device
> >    virtio: Remove virtio_queue_get_used_notify_split
> >    vhost: Do not invalidate signalled used
> >    virtio: Expose virtqueue_alloc_element
> >    vhost: add vhost_vring_set_notification_rcu
> >    vhost: add vhost_vring_poll_rcu
> >    vhost: add vhost_vring_get_buf_rcu
> >    vhost: Return used buffers
> >    vhost: Add vhost_virtqueue_memory_unmap
> >    vhost: Add vhost_virtqueue_memory_map
> >    vhost: unmap qemu's shadow virtqueues on sw live migration
> >    vhost: iommu changes
> >    vhost: Do not commit vhost used idx on vhost_virtqueue_stop
> >    vhost: Add vhost_hdev_can_sw_lm
> >    vhost: forbid vhost devices logging
> >
> >   hw/virtio/vhost-sw-lm-ring.h      |  39 +++
> >   include/hw/virtio/vhost.h         |   5 +
> >   include/hw/virtio/virtio-access.h |   8 +-
> >   include/hw/virtio/virtio.h        |   4 +
> >   hw/net/virtio-net.c               |  39 ++-
> >   hw/virtio/vhost-backend.c         |  29 ++
> >   hw/virtio/vhost-sw-lm-ring.c      | 268 +++++++++++++++++++
> >   hw/virtio/vhost.c                 | 431 +++++++++++++++++++++++++----=
-
> >   hw/virtio/virtio.c                |  18 +-
> >   hw/virtio/meson.build             |   2 +-
> >   10 files changed, 758 insertions(+), 85 deletions(-)
> >   create mode 100644 hw/virtio/vhost-sw-lm-ring.h
> >   create mode 100644 hw/virtio/vhost-sw-lm-ring.c
>
>
> So this looks like a pretty huge patchset which I'm trying to think of
> ways to split. An idea is to do this is two steps
>
> 1) implement a shadow virtqueue mode for vhost first (w/o live
> migration). Then we can test descriptors relay, IOVA allocating, etc.

How would that mode be activated if it is not tied to live migration?
New backend/command line switch?

Maybe it is better to also start with no iommu & ats support and add it on =
top.

> 2) add live migration support on top
>
> And it looks to me it's better to split the shadow virtqueue (virtio
> driver part) into an independent file. And use generic name (w/o
> "shadow") in order to be reused by other use cases as well.
>

I think the same.

Thanks!

> Thoughts?
>

