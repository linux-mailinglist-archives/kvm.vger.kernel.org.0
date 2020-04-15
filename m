Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7551A94C7
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 09:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635236AbgDOHm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 03:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635175AbgDOHmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 03:42:21 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0D4C061A0C;
        Wed, 15 Apr 2020 00:42:21 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id u13so17386247wrp.3;
        Wed, 15 Apr 2020 00:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtXbCZDs7ibkcelB6jYoQjEYDWqEbd8VasJpaRXeEtw=;
        b=ixuMqDNX+IoOhekTl1hWbPoOxx64db5GS2yOpkq13nssQ2oKhz4zBTwuSQc2VrtG6q
         FRzkGS1LY6x9nmcWU4wN/1wrc/ulzJ7/7aylISrwfJikQ0huarxRRgqL5TCTo/g2fLhP
         q9YVlkGzU/9QUowv859Gjx59ZxNCIBTY4gjZvG8OMAIl9xkPwD/m6XGEjpcksFQe2wd/
         yxtNSX/gx9WNwt0VOYglCcpa9TWqhepgvNIiaaoVVh/YrXsPc4NjaImNS33+aOhWAWcG
         12YcOOW1c0Dy3LrrUegvVjgyGgzGxJsRYOrZKXBo3qZZcy2MqxJJTqP4JeJmPHtTtQAv
         Gcww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtXbCZDs7ibkcelB6jYoQjEYDWqEbd8VasJpaRXeEtw=;
        b=uacYOJYpJCFRR9o5yn9fasXhrYBqCO3vDHgKUZUWnkpoYg0dgRBoGZnVb1csjw/GOd
         SKaOn8d/qYGBrkjI3GGbZtMsqBQfqA4A1f0bK5zSzIq3vmGacbcwX6+OTi+kN2WQNZ2u
         SLwtH1KaWQOVvCFb6/L9T7KbvxRe+PahEfDmGw3OI6CnV8EwAIEmFkZkVaPi2Demszue
         Am98CaKDsifWVvnJQlEbY/IJTzCcM3RbgFwK1R65ZVVNc08G7y4b+Z88DqmSNjdiOFny
         u/2wBzwFSWVYk9Mf5EV4ef2TqN/9lXvg1fxdJpwsZ+gwj6faHBHMZ6XvQZPp4tVkHT+v
         Mz1A==
X-Gm-Message-State: AGi0PuaAFaVHtA3/hfO3U6P+iAwMNxKNWsp/qNB+IshT52+eDxt45cfC
        TrAq3f4jJt8Kua9bCcGc9WU5rOMYiWObkU5rUIo=
X-Google-Smtp-Source: APiQypLdNC089W+BRnfSD6BJAuS9Fq32ncyasRH+4xBCau93mDuIW3Mqg/0mjusEJ42V63dCpLPpL5YV+LYfdUXuDCs=
X-Received: by 2002:a5d:4d8f:: with SMTP id b15mr6609450wru.107.1586936539667;
 Wed, 15 Apr 2020 00:42:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200311171422.10484-1-david@redhat.com> <20200311171422.10484-9-david@redhat.com>
In-Reply-To: <20200311171422.10484-9-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 15 Apr 2020 09:42:08 +0200
Message-ID: <CAM9Jb+iuZ4hzP1ik+RUib3Vi1ymc9y5++8_EX50=MCTBsC+1fQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] virtio-mem: Offline and remove completely
 unplugged memory blocks
To:     David Hildenbrand <david@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Let's offline+remove memory blocks once all subblocks are unplugged. We
> can use the new Linux MM interface for that. As no memory is in use
> anymore, this shouldn't take a long time and shouldn't fail. There might
> be corner cases where the offlining could still fail (especially, if
> another notifier NACKs the offlining request).
>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/virtio/virtio_mem.c | 47 +++++++++++++++++++++++++++++++++----
>  1 file changed, 43 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index 35f20232770c..aa322e7732a4 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -443,6 +443,28 @@ static int virtio_mem_mb_remove(struct virtio_mem *vm, unsigned long mb_id)
>         return remove_memory(nid, addr, memory_block_size_bytes());
>  }
>
> +/*
> + * Try to offline and remove a memory block from Linux.
> + *
> + * Must not be called with the vm->hotplug_mutex held (possible deadlock with
> + * onlining code).
> + *
> + * Will not modify the state of the memory block.
> + */
> +static int virtio_mem_mb_offline_and_remove(struct virtio_mem *vm,
> +                                           unsigned long mb_id)
> +{
> +       const uint64_t addr = virtio_mem_mb_id_to_phys(mb_id);
> +       int nid = vm->nid;
> +
> +       if (nid == NUMA_NO_NODE)
> +               nid = memory_add_physaddr_to_nid(addr);
> +
> +       dev_dbg(&vm->vdev->dev, "offlining and removing memory block: %lu\n",
> +               mb_id);
> +       return offline_and_remove_memory(nid, addr, memory_block_size_bytes());
> +}
> +
>  /*
>   * Trigger the workqueue so the device can perform its magic.
>   */
> @@ -535,7 +557,13 @@ static void virtio_mem_notify_offline(struct virtio_mem *vm,
>                 break;
>         }
>
> -       /* trigger the workqueue, maybe we can now unplug memory. */
> +       /*
> +        * Trigger the workqueue, maybe we can now unplug memory. Also,
> +        * when we offline and remove a memory block, this will re-trigger
> +        * us immediately - which is often nice because the removal of
> +        * the memory block (e.g., memmap) might have freed up memory
> +        * on other memory blocks we manage.
> +        */
>         virtio_mem_retry(vm);
>  }
>
> @@ -1282,7 +1310,8 @@ static int virtio_mem_mb_unplug_any_sb_offline(struct virtio_mem *vm,
>   * Unplug the desired number of plugged subblocks of an online memory block.
>   * Will skip subblock that are busy.
>   *
> - * Will modify the state of the memory block.
> + * Will modify the state of the memory block. Might temporarily drop the
> + * hotplug_mutex.
>   *
>   * Note: Can fail after some subblocks were successfully unplugged. Can
>   *       return 0 even if subblocks were busy and could not get unplugged.
> @@ -1338,9 +1367,19 @@ static int virtio_mem_mb_unplug_any_sb_online(struct virtio_mem *vm,
>         }
>
>         /*
> -        * TODO: Once all subblocks of a memory block were unplugged, we want
> -        * to offline the memory block and remove it.
> +        * Once all subblocks of a memory block were unplugged, offline and
> +        * remove it. This will usually not fail, as no memory is in use
> +        * anymore - however some other notifiers might NACK the request.
>          */
> +       if (virtio_mem_mb_test_sb_unplugged(vm, mb_id, 0, vm->nb_sb_per_mb)) {
> +               mutex_unlock(&vm->hotplug_mutex);
> +               rc = virtio_mem_mb_offline_and_remove(vm, mb_id);
> +               mutex_lock(&vm->hotplug_mutex);
> +               if (!rc)
> +                       virtio_mem_mb_set_state(vm, mb_id,
> +                                               VIRTIO_MEM_MB_STATE_UNUSED);
> +       }
> +
>         return 0;
>  }
>

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

> --
