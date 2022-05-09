Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9709851F6DB
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 10:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiEIIMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 04:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbiEIIJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 04:09:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 217D1164CB3
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 01:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652083341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L0dEJhPvtpVY9vKuKdRWMDwwctVUgQ9NezFDM8exNt8=;
        b=B1AImJcqZ3oQPt4E33u3t9ZAg3RfQ2z2m30lckw6s5/Awk2iSdE0diteM2VmAu7jC6ztL2
        yx6ni9UvtWgOMplQLcvLK+mAPk+1mTdwsCBYjriU4gA/LImWcx+pq1pOV6TlyCL5fCeT6T
        0AkwaFIodEMAQOBs167i4JyHn81GukY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-9AONnmQpPDa2s9NVQQ1Zlw-1; Mon, 09 May 2022 04:02:20 -0400
X-MC-Unique: 9AONnmQpPDa2s9NVQQ1Zlw-1
Received: by mail-lf1-f69.google.com with SMTP id q20-20020a194314000000b00473e5bc3752so3687636lfa.16
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 01:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0dEJhPvtpVY9vKuKdRWMDwwctVUgQ9NezFDM8exNt8=;
        b=tiNJbY4faTbMAFiV22UjT7TPtCjqbKtc2aI5Bb0Sz6Ojim5xzBEeSjZkSHeKPeRK+F
         khoBzQd5Mo+8gk4NAgCBEu8YvYrKnruJq0M7BaTLciKHk8s/Kl2svYhXpn59k+xrvjfp
         VozDtih5vVV4FVErjgR8TcFsiPZFLxB7dR1SO4iskkpPWAnIEodks8TBD06jv4P1fxES
         n6SUHGkHcXewLNYKzgKoG0QNYnJJivUigBUzdo6mwIL4qjwNs/rRn5M5sPImNW0uV80u
         97igmE2X6AVoEPOMdKDJjX+jzfqeG03gCMajTLehoX4Kl0qVy8cE09XOSmPCncduwqTN
         l4NQ==
X-Gm-Message-State: AOAM533dP8k5X0JGUCNObgepugngbapgcLVL0PGIHOTFYC5i3+1HPOHS
        fElXwctcDWgy/Ba40V+YAXOdHKyP2jqqK/Ys6p0/UsYatTbbYqbvooZAAxm4W5Kdq1qhOqlRGC/
        1sOJdoEfux9OD8/1ypkFrcSh0CNUM
X-Received: by 2002:a05:651c:89:b0:250:87c9:d4e6 with SMTP id 9-20020a05651c008900b0025087c9d4e6mr9955090ljq.315.1652083338899;
        Mon, 09 May 2022 01:02:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+R1VfoIPFwnxs6fui5BsHA9rC2X2yYYrOq5wpGklCNwM4/hEwSYAJG1Ghk78Cjqu1eMIefFsXW/FXguj6+c8=
X-Received: by 2002:a05:651c:89:b0:250:87c9:d4e6 with SMTP id
 9-20020a05651c008900b0025087c9d4e6mr9955078ljq.315.1652083338682; Mon, 09 May
 2022 01:02:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220509071426.155941-1-lulu@redhat.com>
In-Reply-To: <20220509071426.155941-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 9 May 2022 16:02:06 +0800
Message-ID: <CACGkMEuPoXp7kC1yVoTJ8jpgV8c+0=LcPbuZdzxm8D3v6jAmbQ@mail.gmail.com>
Subject: Re: [PATCH v1] vdpa: Do not count the pages that were already pinned
 in the vhost-vDPA
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 9, 2022 at 3:15 PM Cindy Lu <lulu@redhat.com> wrote:
>
> We count pinned_vm as follow in vhost-vDPA
>
>         lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>         if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
>                 ret = -ENOMEM;
>                 goto unlock;
>         }
> This means if we have two vDPA devices for the same VM the pages would be counted twice
> So we add a tree to save the page that counted and we will not count it again
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vhost/vdpa.c     | 79 ++++++++++++++++++++++++++++++++++++++--
>  include/linux/mm_types.h |  2 +
>  2 files changed, 78 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 05f5fd2af58f..48cb5c8264b5 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -24,6 +24,9 @@
>  #include <linux/vhost.h>
>
>  #include "vhost.h"
> +#include <linux/rbtree.h>
> +#include <linux/interval_tree.h>
> +#include <linux/interval_tree_generic.h>
>
>  enum {
>         VHOST_VDPA_BACKEND_FEATURES =
> @@ -505,6 +508,50 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>         mutex_unlock(&d->mutex);
>         return r;
>  }
> +int vhost_vdpa_add_range_ctx(struct rb_root_cached *root, u64 start, u64 last)
> +{
> +       struct interval_tree_node *new_node;
> +
> +       if (last < start)
> +               return -EFAULT;
> +
> +       /* If the range being mapped is [0, ULONG_MAX], split it into two entries
> +        * otherwise its size would overflow u64.
> +        */
> +       if (start == 0 && last == ULONG_MAX) {
> +               u64 mid = last / 2;
> +
> +               vhost_vdpa_add_range_ctx(root, start, mid);
> +               start = mid + 1;
> +       }
> +
> +       new_node = kmalloc(sizeof(struct interval_tree_node), GFP_ATOMIC);
> +       if (!new_node)
> +               return -ENOMEM;
> +
> +       new_node->start = start;
> +       new_node->last = last;
> +
> +       interval_tree_insert(new_node, root);
> +
> +       return 0;
> +}
> +
> +void vhost_vdpa_del_range(struct rb_root_cached *root, u64 start, u64 last)
> +{
> +       struct interval_tree_node *new_node;
> +
> +       while ((new_node = interval_tree_iter_first(root, start, last))) {
> +               interval_tree_remove(new_node, root);
> +               kfree(new_node);
> +       }
> +}
> +
> +struct interval_tree_node *vhost_vdpa_search_range(struct rb_root_cached *root,
> +                                                  u64 start, u64 last)
> +{
> +       return interval_tree_iter_first(root, start, last);
> +}
>
>  static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>  {
> @@ -513,6 +560,7 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>         struct vhost_iotlb_map *map;
>         struct page *page;
>         unsigned long pfn, pinned;
> +       struct interval_tree_node *new_node = NULL;
>
>         while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
>                 pinned = PFN_DOWN(map->size);
> @@ -523,7 +571,18 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>                                 set_page_dirty_lock(page);
>                         unpin_user_page(page);
>                 }
> -               atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
> +
> +               new_node = vhost_vdpa_search_range(&dev->mm->root_for_vdpa,
> +                                                  map->start,
> +                                                  map->start + map->size - 1);
> +
> +               if (new_node) {
> +                       vhost_vdpa_del_range(&dev->mm->root_for_vdpa,
> +                                            map->start,
> +                                            map->start + map->size - 1);
> +                       atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
> +               }
> +
>                 vhost_iotlb_map_free(iotlb, map);
>         }
>  }
> @@ -591,6 +650,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
>         struct vdpa_device *vdpa = v->vdpa;
>         const struct vdpa_config_ops *ops = vdpa->config;
>         int r = 0;
> +       struct interval_tree_node *new_node = NULL;
>
>         r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
>                                       pa, perm, opaque);
> @@ -611,9 +671,22 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
>                 return r;
>         }
>
> -       if (!vdpa->use_va)
> -               atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
> +       if (!vdpa->use_va) {
> +               new_node = vhost_vdpa_search_range(&dev->mm->root_for_vdpa,
> +                                                  iova, iova + size - 1);
> +
> +               if (new_node == 0) {
> +                       r = vhost_vdpa_add_range_ctx(&dev->mm->root_for_vdpa,
> +                                                    iova, iova + size - 1);
> +                       if (r) {
> +                               vhost_iotlb_del_range(dev->iotlb, iova,
> +                                                     iova + size - 1);
> +                               return r;
> +                       }
>
> +                       atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
> +               }

This seems not sufficient, consider:

vhost-vDPA-A: add [A, B)
vhost-vDPA-B: add [A, C) (C>B)

We lose the accounting for [B, C)?

> +       }
>         return 0;
>  }
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 5140e5feb486..46eaa6d0560b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -634,6 +634,8 @@ struct mm_struct {
>  #ifdef CONFIG_IOMMU_SUPPORT
>                 u32 pasid;
>  #endif
> +               struct rb_root_cached root_for_vdpa;
> +

Let's avoid touching mm_structure unless it's a must.

We can allocate something like vhost_mm if needed during SET_OWNER.

Thanks

>         } __randomize_layout;
>
>         /*
> --
> 2.34.1
>

