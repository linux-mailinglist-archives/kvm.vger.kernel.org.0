Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A912BB4CC
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgKTTDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 14:03:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730102AbgKTTDm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 14:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605899020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8UpoDNvLCM+M0RvdtXWxICqCloKh5IfInwxaMT4Cg4k=;
        b=enBhRZqb/ScvkeKeWNPszvEAXCw/BJGpF2RUB5MVR3RsXjsXRkz6HlPzz07KRj9rSnPSb6
        aWob6+GSvwTPdRTGQoETVomJgNAnveyyBlx18XaPR4+7i2qN2mM2wBEmBuab28ukepZSOU
        CPXQHkjjccAJN/TJr95lNrxykkQdTv0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-xwq064R0M1-XkciEDNa_zA-1; Fri, 20 Nov 2020 14:03:38 -0500
X-MC-Unique: xwq064R0M1-XkciEDNa_zA-1
Received: by mail-qv1-f72.google.com with SMTP id bl3so7782975qvb.8
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 11:03:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8UpoDNvLCM+M0RvdtXWxICqCloKh5IfInwxaMT4Cg4k=;
        b=X8fFuNI3NBLFjJSuJ+tkTl44Z4a+6e1YgeQULPf/g2PUqOHiBbyz4pUGNSQHpiEAZo
         oKVEsi6AuTkQqpKwaYyRNJGstEogv2liKf9sMjWkMx64Z3MCzLQ7aXqYRT/V9nVOKyYx
         Oc3GyEiYV6UzK6Zxq5Jcp+G56/g783yZRBPqcGgv+359TtaPsAdMKtczcUYc/xeyg2V4
         24iLn5f32sdzL5d0z6I64AAW7UcCYD3SReTgCFzlAzYcf1I0A03e2fmekTXoyvnfYkap
         /iOW6Zzsl4oNZEKHEnxcN0ZA1/ZyTD3FFlXmUci7VX+F2yxfsccTap6SYSJsUTf0tm1q
         xn8Q==
X-Gm-Message-State: AOAM530/fVcr4wZN2/Y4ZD05Cm2gI9iLhwdWxOj/fmFs0sVsObK7H1HW
        2tVfDLsb5XApHnZKa9L7ynE8afEWZBATiEAdmyHfkMrQG0K4XM9iu5mOF0e+R0mDGzd2kCTqRBz
        SbRzUr18ooz53yG9Mfgwk35vySkUw
X-Received: by 2002:a37:9c84:: with SMTP id f126mr17330753qke.484.1605899018373;
        Fri, 20 Nov 2020 11:03:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzagcEmUDx/GCW7LReFtHvEjhHy/aw1ygtlXKFvZxRpzjWbJy6uEELelA+5UzQIgsfxs9z8XJn8ulVkTu+Z7SY=
X-Received: by 2002:a37:9c84:: with SMTP id f126mr17330702qke.484.1605899018067;
 Fri, 20 Nov 2020 11:03:38 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 20 Nov 2020 20:03:01 +0100
Message-ID: <CAJaqyWfXEgRC4x+GTxCXkOzBVgVmq9naFCZC+d-W26J4CyumKg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/27] vDPA software assisted live migration
To:     qemu-level <qemu-devel@nongnu.org>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Daniel Daly <dandaly0@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Liran Alon <liralon@gmail.com>, Eli Cohen <eli@mellanox.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Lee Ballard <ballle98@gmail.com>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Howard Cai <howard.cai@gmail.com>,
        Parav Pandit <parav@mellanox.com>, vm <vmireyno@marvell.com>,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Siwei Liu <loseweigh@gmail.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Michael Lilja <ml@napatech.com>,
        Max Gurtovoy <maxgu14@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main intention with this POC/RFC is to serve as a base to
implement SW LM in vdpa devices.

To implement in vhost-vdpa devices, the high priority is to achieve an
interface for vdpa to stop the device without losing its state, i.e.,
the avail_idx the destination device should start fetching descriptors
from. Following this POC, an implementation on vdpa_sim will be
performed.

Apart from that, there is a TODO list about this series, they will be
solved as the code is marked as valid. They don't affect the device,
just internal qemu's code, and in case of change of direction it is
easy to modify or delete. Comments about these are welcome.

- Currently, it hijacks the log mechanism to know when migration is
starting/done. Maybe it would be cleaner to forward migrate status
from virtio_vmstate_change, since there is no need for the memory
listener. However, this could make "memory backend" abstraction (also
TODO) more complicated. This would drop patches 2,3 entirely.
- There is a reverse search in a list on "vhost_dev_from_virtio" for
each notification. Not really efficient, and it leads to a race
condition at device destruction.
- Implement new capabilities (no iommu, packed vq, event_idx, ...)
- Lot of assertions need to be converted to proper error handling.

Thanks!

On Fri, Nov 20, 2020 at 8:02 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> This series enable vDPA software assisted live migration for vhost-net
> devices. This is a new method of vhost devices migration: Instead of
> relay on vDPA device's dirty logging capability, SW assisted LM
> intercepts dataplane, forwarding the descriptors between VM and device.
>
> In this migration mode, qemu offers a new vring to the device to
> read and write into, and disable vhost notifiers, processing guest and
> vhost notifications in qemu. On used buffer relay, qemu will mark the
> dirty memory as with plain virtio-net devices. This way, devices does
> not need to have dirty page logging capability.
>
> This series is a POC doing SW LM for vhost-net devices, which already
> have dirty page logging capabilities. None of the changes have actual
> effect with current devices until last two patches (26 and 27) are
> applied, but they can be rebased on top of any other. These checks the
> device to meet all requirements, and disable vhost-net devices logging
> so migration goes through SW LM. This last patch is not meant to be
> applied in the final revision, it is in the series just for testing
> purposes.
>
> For use SW assisted LM these vhost-net devices need to be instantiated:
> * With IOMMU (iommu_platform=3Don,ats=3Don)
> * Without event_idx (event_idx=3Doff)
>
> Just the notification forwarding (with no descriptor relay) can be
> achieved with patches 7 and 9, and starting migration. Partial applies
> between 13 and 24 will not work while migrating on source, and patch
> 25 is needed for the destination to resume network activity.
>
> It is based on the ideas of DPDK SW assisted LM, in the series of
> DPDK's https://patchwork.dpdk.org/cover/48370/ .
>
> Comments are welcome.
>
> Thanks!
>
> Eugenio P=C3=A9rez (27):
>   vhost: Add vhost_dev_can_log
>   vhost: Add device callback in vhost_migration_log
>   vhost: Move log resize/put to vhost_dev_set_log
>   vhost: add vhost_kernel_set_vring_enable
>   vhost: Add hdev->dev.sw_lm_vq_handler
>   virtio: Add virtio_queue_get_used_notify_split
>   vhost: Route guest->host notification through qemu
>   vhost: Add a flag for software assisted Live Migration
>   vhost: Route host->guest notification through qemu
>   vhost: Allocate shadow vring
>   virtio: const-ify all virtio_tswap* functions
>   virtio: Add virtio_queue_full
>   vhost: Send buffers to device
>   virtio: Remove virtio_queue_get_used_notify_split
>   vhost: Do not invalidate signalled used
>   virtio: Expose virtqueue_alloc_element
>   vhost: add vhost_vring_set_notification_rcu
>   vhost: add vhost_vring_poll_rcu
>   vhost: add vhost_vring_get_buf_rcu
>   vhost: Return used buffers
>   vhost: Add vhost_virtqueue_memory_unmap
>   vhost: Add vhost_virtqueue_memory_map
>   vhost: unmap qemu's shadow virtqueues on sw live migration
>   vhost: iommu changes
>   vhost: Do not commit vhost used idx on vhost_virtqueue_stop
>   vhost: Add vhost_hdev_can_sw_lm
>   vhost: forbid vhost devices logging
>
>  hw/virtio/vhost-sw-lm-ring.h      |  39 +++
>  include/hw/virtio/vhost.h         |   5 +
>  include/hw/virtio/virtio-access.h |   8 +-
>  include/hw/virtio/virtio.h        |   4 +
>  hw/net/virtio-net.c               |  39 ++-
>  hw/virtio/vhost-backend.c         |  29 ++
>  hw/virtio/vhost-sw-lm-ring.c      | 268 +++++++++++++++++++
>  hw/virtio/vhost.c                 | 431 +++++++++++++++++++++++++-----
>  hw/virtio/virtio.c                |  18 +-
>  hw/virtio/meson.build             |   2 +-
>  10 files changed, 758 insertions(+), 85 deletions(-)
>  create mode 100644 hw/virtio/vhost-sw-lm-ring.h
>  create mode 100644 hw/virtio/vhost-sw-lm-ring.c
>
> --
> 2.18.4
>
>

