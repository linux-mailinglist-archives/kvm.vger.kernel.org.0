Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A4E1A9457
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635178AbgDOHgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 03:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635170AbgDOHft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 03:35:49 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC003C061A0C;
        Wed, 15 Apr 2020 00:35:48 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a201so17289193wme.1;
        Wed, 15 Apr 2020 00:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2PnPX+IXLMxHQhocmFsN9EnKpVsBEOL6jEKQXmubIZY=;
        b=hO45c4hR06tLylAL0NdxMtKX35mMSKm39HNyEbJ4X+oT9vzdlZ3GkfntRR6LqspePR
         IKc8WMTCwA3E5qPQbITy7bcS3eZ3ZzSXLF9he3yEgXJmUb1bS8OiyFSoVVYJe8vmZ4xv
         v+JaYUie5vpK2l31zccuEjSZrXkWiSj9grh8aLtKyyDUNM6z9Z3QRcxuolDT1LV8JFTx
         IR5O+n0hmqmjmRfvV2Am/ZjblhoR+TK8ETJW3YSq2K+zSeM1Z8rXHYecelaCLFHOr2Lk
         ksBtf2ry9h38/GD4NjzaJudx4c1jMY13R7S3eZuQpHR2+lI3l17b8PXOsMLKBxGRoXKZ
         n0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2PnPX+IXLMxHQhocmFsN9EnKpVsBEOL6jEKQXmubIZY=;
        b=f2P/O4ZnXpYKlH7KvP7z8xB4GnvPzslyA3LMgWN6dtRFC5xOR2SZewiIiedd38nZne
         mHJTdJKzLmbSXn4ijuUYxREywRBUEOZFoTr8fyauyJG8QuwGo4j3sDXPmQ2SdPwQoN5s
         R04UQEJO0u4fpA7mTUiOhuTesf5UMSkrpy3xlCpekcq8uSUoFo6sUaZfoEb/GgfX8mUd
         tdYGUjSGo6FvZ+r7XMPZBtUj9tPaINBEpKPtjExXrQYkOtPSOZ6PZC9gEx1PpY3/B6Xm
         2YFVdzTKSwLxt7BTh5Jkk5cKBtoPaO3KnD03kQ4O2+oQ/QdYr1ynBHFC8hNQW1OQsEM6
         QYyw==
X-Gm-Message-State: AGi0Pub+0VV36dqu81oEEcJD5FoSmTFWnbT9H38P5t5BHhPE546heEZZ
        CUUTorO5Q3Raq3LNmSqPKWWES3Yq8U0AKo6Z5LOn7IHK
X-Google-Smtp-Source: APiQypJhqfNm57B+b/xSyUfGm2xCR/5dvLHapQPwkX1JccEyHbvzfEx+m92Sfd2KvGn9ToRfL2WDrcR4vVHPnQiJyyc=
X-Received: by 2002:a7b:c20f:: with SMTP id x15mr3638234wmi.2.1586936147523;
 Wed, 15 Apr 2020 00:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200311171422.10484-1-david@redhat.com> <20200311171422.10484-8-david@redhat.com>
In-Reply-To: <20200311171422.10484-8-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 15 Apr 2020 09:35:36 +0200
Message-ID: <CAM9Jb+iz+meQ-fR+ZAHNeNFefTcoujCgEaSHLO6SJ6C6eTLLXg@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] mm/memory_hotplug: Introduce offline_and_remove_memory()
To:     David Hildenbrand <david@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Oscar Salvador <osalvador@suse.com>,
        Michal Hocko <mhocko@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> virtio-mem wants to offline and remove a memory block once it unplugged
> all subblocks (e.g., using alloc_contig_range()). Let's provide
> an interface to do that from a driver. virtio-mem already supports to
> offline partially unplugged memory blocks. Offlining a fully unplugged
> memory block will not require to migrate any pages. All unplugged
> subblocks are PageOffline() and have a reference count of 0 - so
> offlining code will simply skip them.
>
> All we need is an interface to offline and remove the memory from kernel
> module context, where we don't have access to the memory block devices
> (esp. find_memory_block() and device_offline()) and the device hotplug
> lock.
>
> To keep things simple, allow to only work on a single memory block.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Qian Cai <cai@lca.pw>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/memory_hotplug.h |  1 +
>  mm/memory_hotplug.c            | 37 ++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index f4d59155f3d4..a98aa16dbfa1 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -311,6 +311,7 @@ extern void try_offline_node(int nid);
>  extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
>  extern int remove_memory(int nid, u64 start, u64 size);
>  extern void __remove_memory(int nid, u64 start, u64 size);
> +extern int offline_and_remove_memory(int nid, u64 start, u64 size);
>
>  #else
>  static inline bool is_mem_section_removable(unsigned long pfn,
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index ab1c31e67fd1..d0d337918a15 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1818,4 +1818,41 @@ int remove_memory(int nid, u64 start, u64 size)
>         return rc;
>  }
>  EXPORT_SYMBOL_GPL(remove_memory);
> +
> +/*
> + * Try to offline and remove a memory block. Might take a long time to
> + * finish in case memory is still in use. Primarily useful for memory devices
> + * that logically unplugged all memory (so it's no longer in use) and want to
> + * offline + remove the memory block.
> + */
> +int offline_and_remove_memory(int nid, u64 start, u64 size)
> +{
> +       struct memory_block *mem;
> +       int rc = -EINVAL;
> +
> +       if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> +           size != memory_block_size_bytes())
> +               return rc;
> +
> +       lock_device_hotplug();
> +       mem = find_memory_block(__pfn_to_section(PFN_DOWN(start)));
> +       if (mem)
> +               rc = device_offline(&mem->dev);
> +       /* Ignore if the device is already offline. */
> +       if (rc > 0)
> +               rc = 0;
> +
> +       /*
> +        * In case we succeeded to offline the memory block, remove it.
> +        * This cannot fail as it cannot get onlined in the meantime.
> +        */
> +       if (!rc) {
> +               rc = try_remove_memory(nid, start, size);
> +               WARN_ON_ONCE(rc);
> +       }
> +       unlock_device_hotplug();
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory);
>  #endif /* CONFIG_MEMORY_HOTREMOVE */

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
