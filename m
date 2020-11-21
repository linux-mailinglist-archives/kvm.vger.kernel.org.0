Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57122BBF0A
	for <lists+kvm@lfdr.de>; Sat, 21 Nov 2020 13:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgKUMre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Nov 2020 07:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbgKUMrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Nov 2020 07:47:33 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14067C0613CF;
        Sat, 21 Nov 2020 04:47:33 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id d9so13960604oib.3;
        Sat, 21 Nov 2020 04:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FlSNWJmNWiQiTz/L3So6lTyhHOBK1+EUvQhZPXGeudI=;
        b=mLymZ4jYEYnHEMUGmJGhbkCkm1/1qhhUhOnp9qFSCFG2Dxje5uBk1Cu74PjQWtH6b5
         4meVf+nGBt24oxg5D64fUDpYxNPXcFJ3JWirTSlcfcbkEXHfIfA7ryvdgRH7Pg+TdZSE
         dXaqVbw2dDru151HevP7AdbOrmVOFzpq6gwTytqG99SrZRo9HT8jxqccu5LbPFDciEjK
         73dQt+jHxzIchZmrsV9kc/D+EIubFH/d9GrQZfH7Ef62qaz1/BCyVf0uIUsUtVCSJIBQ
         KGgGvmw8sADN7mTwRTiaZGW1oqtzyDge51JVHpD0LL9DGy9LuVKt7/YUO+W9kh9V3uLD
         9uiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FlSNWJmNWiQiTz/L3So6lTyhHOBK1+EUvQhZPXGeudI=;
        b=IlJsAhYVnh6dci5uAWjQxR+/R1Z2bmxyxWZIc0/WtSmpuuWZBy2xE+BZLCkeqWt836
         C1xjX3WEm59vy5V9yMeDJIABm6AS6g5B/5caaZBD/COEbnjC1HAztxhIUWtOtfSC3NNf
         5XTCkdAubRC1zGV5kocjyQwP1fhn6BdO+Avk2o4Uud3SzuoUK1Qj77t1Vot2G9pQQOaa
         +AJdb8gZFVjx9oguTz7+St31gzuxuPgnqq4gsxtPHlnglYf2LwgU4RKuYwWgB9+toPtN
         dKYqx2xebdP/mG8WPxJSBB+11ju1MaBUfqVeVEPiXjcE9XYvo91WePzfj3KMSRqwQUPW
         aQYw==
X-Gm-Message-State: AOAM530TFlbJvMv84bhMBki/0RGBrVJRRIff736IXADAhZPmBXzzo7ij
        n+65wrwBVRPZnYvtG6rvxScZp17rWSagzwggQTnB+k0FTJFw0Q==
X-Google-Smtp-Source: ABdhPJwm/h9kUMFqlGm0lJmnxV9/hlp30MxHOKOag39ZoEYRMrUPlCrFLaqhGvcbUmpwSXdstBWktehEKaGSR9+lNnw=
X-Received: by 2002:aca:a896:: with SMTP id r144mr2111725oie.154.1605962852497;
 Sat, 21 Nov 2020 04:47:32 -0800 (PST)
MIME-Version: 1.0
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch> <20201119144146.1045202-4-daniel.vetter@ffwll.ch>
In-Reply-To: <20201119144146.1045202-4-daniel.vetter@ffwll.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Sat, 21 Nov 2020 14:47:05 +0200
Message-ID: <CAFCwf12Hrjm1La_qgrpW_E0WryiBXYzOobMMGEYsxh9kg=3_AA@mail.gmail.com>
Subject: Re: [PATCH v6 03/17] misc/habana: Stop using frame_vector helpers
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Omer Shpigelman <oshpigelman@habana.ai>,
        Ofir Bitton <obitton@habana.ai>,
        Tomer Tayar <ttayar@habana.ai>,
        Moti Haimovski <mhaimovski@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Piskorski <ppiskorski@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 19, 2020 at 4:41 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> All we need are a pages array, pin_user_pages_fast can give us that
> directly. Plus this avoids the entire raw pfn side of get_vaddr_frames.
>
> Note that pin_user_pages_fast is a safe replacement despite the
> seeming lack of checking for vma->vm_flasg & (VM_IO | VM_PFNMAP). Such
> ptes are marked with pte_mkspecial (which pup_fast rejects in the
> fastpath), and only architectures supporting that support the
> pin_user_pages_fast fastpath.
>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Oded Gabbay <oded.gabbay@gmail.com>
> Cc: Omer Shpigelman <oshpigelman@habana.ai>
> Cc: Ofir Bitton <obitton@habana.ai>
> Cc: Tomer Tayar <ttayar@habana.ai>
> Cc: Moti Haimovski <mhaimovski@habana.ai>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Pawel Piskorski <ppiskorski@habana.ai>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v2: Use unpin_user_pages_dirty_lock (John)
> v3: Update kerneldoc (Oded)
> v6: Explain why pup_fast is safe, after discussions with John and
> Christoph.
> ---
>  drivers/misc/habanalabs/Kconfig             |  1 -
>  drivers/misc/habanalabs/common/habanalabs.h |  6 ++-
>  drivers/misc/habanalabs/common/memory.c     | 49 ++++++++-------------
>  3 files changed, 22 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/misc/habanalabs/Kconfig b/drivers/misc/habanalabs/Kc=
onfig
> index 1640340d3e62..293d79811372 100644
> --- a/drivers/misc/habanalabs/Kconfig
> +++ b/drivers/misc/habanalabs/Kconfig
> @@ -6,7 +6,6 @@
>  config HABANA_AI
>         tristate "HabanaAI accelerators (habanalabs)"
>         depends on PCI && HAS_IOMEM
> -       select FRAME_VECTOR
>         select GENERIC_ALLOCATOR
>         select HWMON
>         help
> diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/h=
abanalabs/common/habanalabs.h
> index 80d4d7385ffe..272aa3f29200 100644
> --- a/drivers/misc/habanalabs/common/habanalabs.h
> +++ b/drivers/misc/habanalabs/common/habanalabs.h
> @@ -921,7 +921,8 @@ struct hl_ctx_mgr {
>   * struct hl_userptr - memory mapping chunk information
>   * @vm_type: type of the VM.
>   * @job_node: linked-list node for hanging the object on the Job's list.
> - * @vec: pointer to the frame vector.
> + * @pages: pointer to struct page array
> + * @npages: size of @pages array
>   * @sgt: pointer to the scatter-gather table that holds the pages.
>   * @dir: for DMA unmapping, the direction must be supplied, so save it.
>   * @debugfs_list: node in debugfs list of command submissions.
> @@ -932,7 +933,8 @@ struct hl_ctx_mgr {
>  struct hl_userptr {
>         enum vm_type_t          vm_type; /* must be first */
>         struct list_head        job_node;
> -       struct frame_vector     *vec;
> +       struct page             **pages;
> +       unsigned int            npages;
>         struct sg_table         *sgt;
>         enum dma_data_direction dir;
>         struct list_head        debugfs_list;
> diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/haban=
alabs/common/memory.c
> index 84227819e4d1..0b220221873d 100644
> --- a/drivers/misc/habanalabs/common/memory.c
> +++ b/drivers/misc/habanalabs/common/memory.c
> @@ -1291,45 +1291,41 @@ static int get_user_memory(struct hl_device *hdev=
, u64 addr, u64 size,
>                 return -EFAULT;
>         }
>
> -       userptr->vec =3D frame_vector_create(npages);
> -       if (!userptr->vec) {
> +       userptr->pages =3D kvmalloc_array(npages, sizeof(*userptr->pages)=
,
> +                                       GFP_KERNEL);
> +       if (!userptr->pages) {
>                 dev_err(hdev->dev, "Failed to create frame vector\n");
>                 return -ENOMEM;
>         }
Hi Daniel, sorry but missed this in my initial review.
The error message no longer fits the code, and actually it isn't
needed as we don't print error messages on malloc failures.
With that fixed, this patch is:
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>

>
> -       rc =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
> -                               userptr->vec);
> +       rc =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE=
,
> +                                userptr->pages);
>
>         if (rc !=3D npages) {
>                 dev_err(hdev->dev,
>                         "Failed to map host memory, user ptr probably wro=
ng\n");
>                 if (rc < 0)
> -                       goto destroy_framevec;
> +                       goto destroy_pages;
> +               npages =3D rc;
>                 rc =3D -EFAULT;
> -               goto put_framevec;
> -       }
> -
> -       if (frame_vector_to_pages(userptr->vec) < 0) {
> -               dev_err(hdev->dev,
> -                       "Failed to translate frame vector to pages\n");
> -               rc =3D -EFAULT;
> -               goto put_framevec;
> +               goto put_pages;
>         }
> +       userptr->npages =3D npages;
>
>         rc =3D sg_alloc_table_from_pages(userptr->sgt,
> -                                       frame_vector_pages(userptr->vec),
> -                                       npages, offset, size, GFP_ATOMIC)=
;
> +                                      userptr->pages,
> +                                      npages, offset, size, GFP_ATOMIC);
>         if (rc < 0) {
>                 dev_err(hdev->dev, "failed to create SG table from pages\=
n");
> -               goto put_framevec;
> +               goto put_pages;
>         }
>
>         return 0;
>
> -put_framevec:
> -       put_vaddr_frames(userptr->vec);
> -destroy_framevec:
> -       frame_vector_destroy(userptr->vec);
> +put_pages:
> +       unpin_user_pages(userptr->pages, npages);
> +destroy_pages:
> +       kvfree(userptr->pages);
>         return rc;
>  }
>
> @@ -1415,8 +1411,6 @@ int hl_pin_host_memory(struct hl_device *hdev, u64 =
addr, u64 size,
>   */
>  void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr *use=
rptr)
>  {
> -       struct page **pages;
> -
>         hl_debugfs_remove_userptr(hdev, userptr);
>
>         if (userptr->dma_mapped)
> @@ -1424,15 +1418,8 @@ void hl_unpin_host_memory(struct hl_device *hdev, =
struct hl_userptr *userptr)
>                                                         userptr->sgt->nen=
ts,
>                                                         userptr->dir);
>
> -       pages =3D frame_vector_pages(userptr->vec);
> -       if (!IS_ERR(pages)) {
> -               int i;
> -
> -               for (i =3D 0; i < frame_vector_count(userptr->vec); i++)
> -                       set_page_dirty_lock(pages[i]);
> -       }
> -       put_vaddr_frames(userptr->vec);
> -       frame_vector_destroy(userptr->vec);
> +       unpin_user_pages_dirty_lock(userptr->pages, userptr->npages, true=
);
> +       kvfree(userptr->pages);
>
>         list_del(&userptr->job_node);
>
> --
> 2.29.2
>
