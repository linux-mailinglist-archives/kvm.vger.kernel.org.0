Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C342C1F65B6
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 12:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgFKKcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 06:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgFKKcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 06:32:46 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E747AC08C5C1;
        Thu, 11 Jun 2020 03:32:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so5605402wrc.7;
        Thu, 11 Jun 2020 03:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S1DHOFo6gIegKvTMa5vbni7NQMyet4sax/6N+ioAZRQ=;
        b=pI/ZXc1eS0mK6/HSIeSOkMR5Ulb1J0U1FAAMsjazR2pRoXOesvMKckUWV5e5ad67Mn
         iY0jcieN+vghiUkZWeEsKFFU6o/pg9xedcTeMfDMIpEtQYFzhT2frUj5u58c6BhzdC4/
         IRdoSj9rKrKpRR2cE4tIYJuV5ts33u/tzYhKmU71+6mvT3qDtfkZbo1+jpd5Fr/6rjkI
         Q1YwaINlhCR8qGEUfsFG4X1NFTkXCcrOk+9RcjEHo3duAar+dHbma+0DkNRpdwUHn9M8
         9dvlUk1Tbtaq5LPkmzZmxKE9EmPO5hdOKFZUC+3nKkdzRR+85NX0zsyZ0orvDNZ8ZFa8
         cHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S1DHOFo6gIegKvTMa5vbni7NQMyet4sax/6N+ioAZRQ=;
        b=FgD7mws96W6FsANpTYDfxrh0y0fnsFHqss5lVzsuoZHJJ3DF4fpz9L173L92PdyvvF
         SztkdJea9/kw6QUm3FTHi4VJEwLPAz268Ij5OvLj24dZRNLS9SfMfOS2RFPfp9u9eloB
         sLNLmGgLKcIHDucHPpKHL23F7i5OeCbmNbUOh6G78FbJSIs4aRudsBfQ21xSuKIeBw6I
         Z53Rdj2JyYoMwQg5r7DbNQHmN/P6fEwwQFd75rJvQUitws6LWZeBYiPK4DUBtoVXrOWd
         dBqkwHSBkTNbRAPKrUyV13Nl1gI+gZKXJkgp9GoBNhCg+qgK/xupSx8wPOw9L0ChBv2S
         FIVw==
X-Gm-Message-State: AOAM530DCYqa3ySkiO4jJ0g7u8MvKeZ2w2aS+CHsID2JlQn/HhVNFol0
        0/rd6+lNdlHTv7EgF87A8N1raCibINDFTJR4kYPMeHykfDc4Nw==
X-Google-Smtp-Source: ABdhPJxjK3svYNT9cJJ+Ew1PeDQwIvwXhWHUG/rQXV+svRZUBu1+K3XXVBzHIKJWELOu9xonGk0kl0vLaU+gucmQ9bU=
X-Received: by 2002:adf:fd81:: with SMTP id d1mr9042165wrr.96.1591871564244;
 Thu, 11 Jun 2020 03:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200611093518.5737-1-david@redhat.com>
In-Reply-To: <20200611093518.5737-1-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 11 Jun 2020 12:32:33 +0200
Message-ID: <CAM9Jb+jk=mHHQtLJ78=xZrebo6X6euGK_-aEjgQb-qtKjke-FA@mail.gmail.com>
Subject: Re: [PATCH v1] virtio-mem: add memory via add_memory_driver_managed()
To:     David Hildenbrand <david@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Virtio-mem managed memory is always detected and added by the virtio-mem
> driver, never using something like the firmware-provided memory map.
> This is the case after an ordinary system reboot, and has to be guaranteed
> after kexec. Especially, virtio-mem added memory resources can contain
> inaccessible parts ("unblocked memory blocks"), blindly forwarding them
> to a kexec kernel is dangerous, as unplugged memory will get accessed
> (esp. written).
>
> Let's use the new way of adding special driver-managed memory introduced
> in commit 75ac4c58bc0d ("mm/memory_hotplug: introduce
> add_memory_driver_managed()").

Is this commit id correct?
>
> This will result in no entries in /sys/firmware/memmap ("raw firmware-
> provided memory map"), the memory resource will be flagged
> IORESOURCE_MEM_DRIVER_MANAGED (esp., kexec_file_load() will not place
> kexec images on this memory), and it is exposed as "System RAM
> (virtio_mem)" in /proc/iomem, so esp. kexec-tools can properly handle it.
>
> Example /proc/iomem before this change:
>   [...]
>   140000000-333ffffff : virtio0
>     140000000-147ffffff : System RAM
>   334000000-533ffffff : virtio1
>     338000000-33fffffff : System RAM
>     340000000-347ffffff : System RAM
>     348000000-34fffffff : System RAM
>   [...]
>
> Example /proc/iomem after this change:
>   [...]
>   140000000-333ffffff : virtio0
>     140000000-147ffffff : System RAM (virtio_mem)
>   334000000-533ffffff : virtio1
>     338000000-33fffffff : System RAM (virtio_mem)
>     340000000-347ffffff : System RAM (virtio_mem)
>     348000000-34fffffff : System RAM (virtio_mem)
>   [...]
>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: teawater <teawaterz@linux.alibaba.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>
> Based on latest Linus' tree (and not a tag) because
> - virtio-mem has just been merged via the vhost tree
> - add_memory_driver_managed() has been merged a week ago via the -mm tree
>
> I'd like to have this patch in 5.8, with the initial merge of virtio-mem
> if possible (so the user space representation of virtio-mem added memory
> resources won't change anymore).
>
> ---
>  drivers/virtio/virtio_mem.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index 50c689f250450..d2eab3558a9e1 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -101,6 +101,11 @@ struct virtio_mem {
>
>         /* The parent resource for all memory added via this device. */
>         struct resource *parent_resource;
> +       /*
> +        * Copy of "System RAM (virtio_mem)" to be used for
> +        * add_memory_driver_managed().
> +        */
> +       const char *resource_name;
>
>         /* Summary of all memory block states. */
>         unsigned long nb_mb_state[VIRTIO_MEM_MB_STATE_COUNT];
> @@ -414,8 +419,20 @@ static int virtio_mem_mb_add(struct virtio_mem *vm, unsigned long mb_id)
>         if (nid == NUMA_NO_NODE)
>                 nid = memory_add_physaddr_to_nid(addr);
>
> +       /*
> +        * When force-unloading the driver and we still have memory added to
> +        * Linux, the resource name has to stay.
> +        */
> +       if (!vm->resource_name) {
> +               vm->resource_name = kstrdup_const("System RAM (virtio_mem)",
> +                                                 GFP_KERNEL);
> +               if (!vm->resource_name)
> +                       return -ENOMEM;
> +       }
> +
>         dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
> -       return add_memory(nid, addr, memory_block_size_bytes());
> +       return add_memory_driver_managed(nid, addr, memory_block_size_bytes(),
> +                                        vm->resource_name);
>  }
>
>  /*
> @@ -1890,10 +1907,12 @@ static void virtio_mem_remove(struct virtio_device *vdev)
>             vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL] ||
>             vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE] ||
>             vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL] ||
> -           vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE])
> +           vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE]) {
>                 dev_warn(&vdev->dev, "device still has system memory added\n");
> -       else
> +       } else {
>                 virtio_mem_delete_resource(vm);
> +               kfree_const(vm->resource_name);
> +       }
>
>         /* remove all tracking data - no locking needed */
>         vfree(vm->mb_state);

Looks good to me.
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
