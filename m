Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94A81C8D8C
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 16:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgEGOGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 10:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgEGOGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 10:06:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A048CC05BD43;
        Thu,  7 May 2020 07:06:42 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r26so6994561wmh.0;
        Thu, 07 May 2020 07:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+aQ+iWJtTlzvsD3O2ITCsYtNNFRLe3AecxY3imabsd8=;
        b=khDXSpGwapNMmlhylLz/6Mk+CnEra5lCL0OPUi5q+Cnsa2lM8MXNpd1HZmI8dFLYaG
         tcoQ/F+JUev7CrL6JmDD59WWH+9bI4xjyVlHnJTicHX4gkS/n6UmmE/w30RUVEkh+ldr
         Oj1VBZjIapPdI1MVHLg0zxJAsHPrv+KcQdkVgs59fvqvvCd7jmH2cHVYV3VNGOxE0REO
         NA3sk0pReUia0BZCdo8JLIemI6UoHAdkPJHE3E5SkFRVygRsdL2xdrqNUbQusyAjH7iB
         N7mu3/YcHm6ae+ttcfv2c2ZH6AY/YaBywSUHBZrCfWRwf5e4Agv4DCLtViaPIXGX33X9
         Uiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+aQ+iWJtTlzvsD3O2ITCsYtNNFRLe3AecxY3imabsd8=;
        b=tvSt6gzj+SPs2kME9TpUQwPwyKTVG896A+alTD1wK+3QLFbPx6w3UgN6QpJdcsIo4a
         XiRDARq4UogPiP0rRwTjz+KbJmNr1w3HY8Iu6zOHhSNhEnl/K2q8dvNYX5JTwQKyGMA1
         fRSTNjCHKMrIt57eZFJX5/bsMYkcUw5OzyskBQNRlCZEMAsSPhJT4BXU1yKxvAKUvLMa
         X2Tuy2hbQvF2agQPWqDfSAbfgp1uHkNTHPL08NZOvMSlhI7JAbet63OM7aPtKCfwnben
         v9MaUqxvDPZM3DrORbzaVGJCN6CKTEEjL4R/OHl+limG6b0e7f87gQxucJiryQ7T4ggb
         H+Jw==
X-Gm-Message-State: AGi0PuZLnDYyILcRcGZaPH6SDHgboBx8KONcQkKUUgI2a1DqJSdmcTXZ
        LsH+dJpLlL3xY5aAWOuli1yMIS1qyKLIr1aSNKUFHATZefg=
X-Google-Smtp-Source: APiQypKh6M97mrJpLTUKpwAL4sa3NeR7OHWBIyL14CIeMc/Pa4lvzDLFMKSILqEgHY89bJSU4fGGd1iEywdfPQ3wbco=
X-Received: by 2002:a1c:7f91:: with SMTP id a139mr10008195wmd.164.1588860401319;
 Thu, 07 May 2020 07:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200507140139.17083-1-david@redhat.com> <20200507140139.17083-12-david@redhat.com>
In-Reply-To: <20200507140139.17083-12-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 7 May 2020 16:06:30 +0200
Message-ID: <CAM9Jb+jXy6Adhg=GstpMZN3roo1uQuikj2hpsxGj6-JUQU3oGA@mail.gmail.com>
Subject: Re: [PATCH v4 11/15] virtio-mem: Add parent resource for all added
 "System RAM"
To:     David Hildenbrand <david@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Let's add a parent resource, named after the virtio device (inspired by
> drivers/dax/kmem.c). This allows user space to identify which memory
> belongs to which virtio-mem device.
>
> With this change and two virtio-mem devices:
>         :/# cat /proc/iomem
>         00000000-00000fff : Reserved
>         00001000-0009fbff : System RAM
>         [...]
>         140000000-333ffffff : virtio0
>           140000000-147ffffff : System RAM
>           148000000-14fffffff : System RAM
>           150000000-157ffffff : System RAM
>         [...]
>         334000000-3033ffffff : virtio1
>           338000000-33fffffff : System RAM
>           340000000-347ffffff : System RAM
>           348000000-34fffffff : System RAM
>         [...]
>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/virtio/virtio_mem.c | 52 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index eb4c16d634e0..80cdb9e6b3c4 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -99,6 +99,9 @@ struct virtio_mem {
>         /* Id of the next memory bock to prepare when needed. */
>         unsigned long next_mb_id;
>
> +       /* The parent resource for all memory added via this device. */
> +       struct resource *parent_resource;
> +
>         /* Summary of all memory block states. */
>         unsigned long nb_mb_state[VIRTIO_MEM_MB_STATE_COUNT];
>  #define VIRTIO_MEM_NB_OFFLINE_THRESHOLD                10
> @@ -1741,6 +1744,44 @@ static int virtio_mem_init(struct virtio_mem *vm)
>         return 0;
>  }
>
> +static int virtio_mem_create_resource(struct virtio_mem *vm)
> +{
> +       /*
> +        * When force-unloading the driver and removing the device, we
> +        * could have a garbage pointer. Duplicate the string.
> +        */
> +       const char *name = kstrdup(dev_name(&vm->vdev->dev), GFP_KERNEL);
> +
> +       if (!name)
> +               return -ENOMEM;
> +
> +       vm->parent_resource = __request_mem_region(vm->addr, vm->region_size,
> +                                                  name, IORESOURCE_SYSTEM_RAM);
> +       if (!vm->parent_resource) {
> +               kfree(name);
> +               dev_warn(&vm->vdev->dev, "could not reserve device region\n");
> +               return -EBUSY;
> +       }
> +
> +       /* The memory is not actually busy - make add_memory() work. */
> +       vm->parent_resource->flags &= ~IORESOURCE_BUSY;
> +       return 0;
> +}
> +
> +static void virtio_mem_delete_resource(struct virtio_mem *vm)
> +{
> +       const char *name;
> +
> +       if (!vm->parent_resource)
> +               return;
> +
> +       name = vm->parent_resource->name;
> +       release_resource(vm->parent_resource);
> +       kfree(vm->parent_resource);
> +       kfree(name);
> +       vm->parent_resource = NULL;
> +}
> +
>  static int virtio_mem_probe(struct virtio_device *vdev)
>  {
>         struct virtio_mem *vm;
> @@ -1770,11 +1811,16 @@ static int virtio_mem_probe(struct virtio_device *vdev)
>         if (rc)
>                 goto out_del_vq;
>
> +       /* create the parent resource for all memory */
> +       rc = virtio_mem_create_resource(vm);
> +       if (rc)
> +               goto out_del_vq;
> +
>         /* register callbacks */
>         vm->memory_notifier.notifier_call = virtio_mem_memory_notifier_cb;
>         rc = register_memory_notifier(&vm->memory_notifier);
>         if (rc)
> -               goto out_del_vq;
> +               goto out_del_resource;
>         rc = register_virtio_mem_device(vm);
>         if (rc)
>                 goto out_unreg_mem;
> @@ -1788,6 +1834,8 @@ static int virtio_mem_probe(struct virtio_device *vdev)
>         return 0;
>  out_unreg_mem:
>         unregister_memory_notifier(&vm->memory_notifier);
> +out_del_resource:
> +       virtio_mem_delete_resource(vm);
>  out_del_vq:
>         vdev->config->del_vqs(vdev);
>  out_free_vm:
> @@ -1848,6 +1896,8 @@ static void virtio_mem_remove(struct virtio_device *vdev)
>             vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL] ||
>             vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE])
>                 dev_warn(&vdev->dev, "device still has system memory added\n");
> +       else
> +               virtio_mem_delete_resource(vm);
>
>         /* remove all tracking data - no locking needed */
>         vfree(vm->mb_state);
> --

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
