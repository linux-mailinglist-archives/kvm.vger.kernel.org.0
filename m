Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354B528A1BB
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgJJWQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 18:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbgJJV7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 17:59:25 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB86AC0613D0;
        Sat, 10 Oct 2020 14:48:06 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x62so14280177oix.11;
        Sat, 10 Oct 2020 14:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TcUpz461OVaqzlBeUFIMXlvPExV4UXfJ2XMipbjkTIo=;
        b=iQ1ZNhOk7qeRWES3fueyt86xPb/cmebxQQuRHkMBy0nlluZwYRU3feNsXuLg5b0jOf
         7P8HlPemHyuvBM2DboRpCK45fJ8F+rvcFr43a/cqycQ3xqqUG9ajofFm1WMPliomxe1C
         WTyCXTZGBcrlxA1mq1OLXpYgKYOVnNwRebFaEP1XpwfOvnwJ2lEErb2sYA/I2Yby+7bx
         /6K+qzCVlAx5ZBHufhGlQ9VZ52h8UIh1a4k6EnjwrHmqr7tBtr6tMyrVp4AIQip0MNXs
         L8HpCjCucZtMtMmtIzC8p0QFx+9OxymkGafjv73Dbdc6oHDmGdT14NGdVImp/klJm8yA
         Ttig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TcUpz461OVaqzlBeUFIMXlvPExV4UXfJ2XMipbjkTIo=;
        b=ILTSSu5q+R4qiuRurRBucSs3sY4Jadq1/euMcxjGmmUuiAcDo6GFWYIPyq0v1R2c1v
         cSq8wdK9Ph98F+f8oQLkdCMCcNeYJO74Lv/uwTynAOPZhJU4FRLI3b6NQJjiIQzfSXNp
         n+OBYDroyikIWhZ3/zhz0q1ZyABJt8UyokRNM5XE5tdaXlmHf65h+Jz4fQP3SposMdte
         KrZw2NqNa/ijvNEL9HudocfxOLaaIvSBAPNMovdfVHyoLI35rMhRM/FlDYXKXrpkvBc5
         3bco9kp2jp5zRaNewTvnMRNhzuxVv2qikMvjmXFMgY3vloNCDfLv02SyQIoiVeyMn04k
         s1bg==
X-Gm-Message-State: AOAM533zIdTU/mqi4UKqPn2V0ZeS22rgxURnujNJwEK6aVpAVfIlNDas
        nvWSVInbWy9ZZ2vnZJvnhUAGS1dODQND9RT3LT4=
X-Google-Smtp-Source: ABdhPJw6azhCa1CtVIoU0/HjpPxr0pBaYe5iIN/WY3VaKZgAPU2JLYzasaY+kJofWl4CnyzXINNmGNNxNAlv10f/ODw=
X-Received: by 2002:aca:750c:: with SMTP id q12mr6703039oic.154.1602366485786;
 Sat, 10 Oct 2020 14:48:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-4-daniel.vetter@ffwll.ch> <CAFCwf1194Ce98y8tWxKzXT1rsdHDkzEcnERiaU=3-=t7hygmXg@mail.gmail.com>
 <CAKMK7uG_kBpmuQDRgKdyh8SycFDhE7kuB2MEOsx+D5wRmerWKA@mail.gmail.com> <CAKMK7uFUtkd7j1WZZoSmeO3mKG2zZ9SpwEO08EFJKromU0LV4Q@mail.gmail.com>
In-Reply-To: <CAKMK7uFUtkd7j1WZZoSmeO3mKG2zZ9SpwEO08EFJKromU0LV4Q@mail.gmail.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Sun, 11 Oct 2020 00:47:39 +0300
Message-ID: <CAFCwf12+fGqfB8AyJR=Aeon7tLwePkJYULAJyK+Pxz3DE7isNQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/17] misc/habana: Stop using frame_vector helpers
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
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

On Sun, Oct 11, 2020 at 12:41 AM Daniel Vetter <daniel.vetter@ffwll.ch> wro=
te:
>
> On Sat, Oct 10, 2020 at 11:32 PM Daniel Vetter <daniel.vetter@ffwll.ch> w=
rote:
> >
> > On Sat, Oct 10, 2020 at 10:27 PM Oded Gabbay <oded.gabbay@gmail.com> wr=
ote:
> > >
> > > On Fri, Oct 9, 2020 at 10:59 AM Daniel Vetter <daniel.vetter@ffwll.ch=
> wrote:
> > > >
> > > > All we need are a pages array, pin_user_pages_fast can give us that
> > > > directly. Plus this avoids the entire raw pfn side of get_vaddr_fra=
mes.
> > > >
> > > Thanks for the patch Daniel.
> > >
> > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > > Cc: Jan Kara <jack@suse.cz>
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > Cc: linux-mm@kvack.org
> > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > Cc: linux-samsung-soc@vger.kernel.org
> > > > Cc: linux-media@vger.kernel.org
> > > > Cc: Oded Gabbay <oded.gabbay@gmail.com>
> > > > Cc: Omer Shpigelman <oshpigelman@habana.ai>
> > > > Cc: Ofir Bitton <obitton@habana.ai>
> > > > Cc: Tomer Tayar <ttayar@habana.ai>
> > > > Cc: Moti Haimovski <mhaimovski@habana.ai>
> > > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Pawel Piskorski <ppiskorski@habana.ai>
> > > > --
> > > > v2: Use unpin_user_pages_dirty_lock (John)
> > > > ---
> > > >  drivers/misc/habanalabs/Kconfig             |  1 -
> > > >  drivers/misc/habanalabs/common/habanalabs.h |  3 +-
> > > >  drivers/misc/habanalabs/common/memory.c     | 49 ++++++++---------=
----
> > > >  3 files changed, 20 insertions(+), 33 deletions(-)
> > > >
> > > > diff --git a/drivers/misc/habanalabs/Kconfig b/drivers/misc/habanal=
abs/Kconfig
> > > > index 8eb5d38c618e..2f04187f7167 100644
> > > > --- a/drivers/misc/habanalabs/Kconfig
> > > > +++ b/drivers/misc/habanalabs/Kconfig
> > > > @@ -6,7 +6,6 @@
> > > >  config HABANA_AI
> > > >         tristate "HabanaAI accelerators (habanalabs)"
> > > >         depends on PCI && HAS_IOMEM
> > > > -       select FRAME_VECTOR
> > > >         select DMA_SHARED_BUFFER
> > > >         select GENERIC_ALLOCATOR
> > > >         select HWMON
> > > > diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/=
misc/habanalabs/common/habanalabs.h
> > > > index edbd627b29d2..c1b3ad613b15 100644
> > > > --- a/drivers/misc/habanalabs/common/habanalabs.h
> > > > +++ b/drivers/misc/habanalabs/common/habanalabs.h
> > > > @@ -881,7 +881,8 @@ struct hl_ctx_mgr {
> > > >  struct hl_userptr {
> > > >         enum vm_type_t          vm_type; /* must be first */
> > > >         struct list_head        job_node;
> > > > -       struct frame_vector     *vec;
> > > > +       struct page             **pages;
> > > > +       unsigned int            npages;
> > > Can you please update the kerneldoc comment section of this structure
> > > according to your changes ?
> >
> > Apologies I missed the nice kerneldoc. I'll fix that in the next round.
> >
> >
> > > >         struct sg_table         *sgt;
> > > >         enum dma_data_direction dir;
> > > >         struct list_head        debugfs_list;
> > > > diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc=
/habanalabs/common/memory.c
> > > > index 5ff4688683fd..327b64479f97 100644
> > > > --- a/drivers/misc/habanalabs/common/memory.c
> > > > +++ b/drivers/misc/habanalabs/common/memory.c
> > > > @@ -1281,45 +1281,41 @@ static int get_user_memory(struct hl_device=
 *hdev, u64 addr, u64 size,
> > > >                 return -EFAULT;
> > > >         }
> > > >
> > > > -       userptr->vec =3D frame_vector_create(npages);
> > > > -       if (!userptr->vec) {
> > > > +       userptr->pages =3D kvmalloc_array(npages, sizeof(*userptr->=
pages),
> > > > +                                       GFP_KERNEL);
> > > > +       if (!userptr->pages) {
> > > >                 dev_err(hdev->dev, "Failed to create frame vector\n=
");
> > > >                 return -ENOMEM;
> > > >         }
> > > >
> > > > -       rc =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WR=
ITE,
> > > > -                               userptr->vec);
> > > > +       rc =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL=
_WRITE,
> > > > +                                userptr->pages);
> > > >
> > > >         if (rc !=3D npages) {
> > > >                 dev_err(hdev->dev,
> > > >                         "Failed to map host memory, user ptr probab=
ly wrong\n");
> > > >                 if (rc < 0)
> > > > -                       goto destroy_framevec;
> > > > +                       goto destroy_pages;
> > > > +               npages =3D rc;
> > > >                 rc =3D -EFAULT;
> > > > -               goto put_framevec;
> > > > -       }
> > > > -
> > > > -       if (frame_vector_to_pages(userptr->vec) < 0) {
> > > > -               dev_err(hdev->dev,
> > > > -                       "Failed to translate frame vector to pages\=
n");
> > > > -               rc =3D -EFAULT;
> > > > -               goto put_framevec;
> > > > +               goto put_pages;
> > > >         }
> > > > +       userptr->npages =3D npages;
> > > >
> > > >         rc =3D sg_alloc_table_from_pages(userptr->sgt,
> > > > -                                       frame_vector_pages(userptr-=
>vec),
> > > > -                                       npages, offset, size, GFP_A=
TOMIC);
> > > > +                                      userptr->pages,
> > > > +                                      npages, offset, size, GFP_AT=
OMIC);
> > > I think that because the call to kvmalloc_array() is done with
> > > GFP_KERNEL, there is no point in using GFP_ATOMIC here.
> > > And actually, this path only needs to avoid yielding when using a
> > > special debug mode.
> > > So I suggest putting here GFP_KERNEL.
> >
> > Huh, I didn't even notice the GFP_ATOMIC here. This looks indeed
> > strange and GFP_KERNEL should be perfectly fine in a function that
> > also calls pin_user_pages (since that one can allocate and do worse
> > stuff like userspace pagefaults).
> >
> > But since that GFP_ATOMIC is there already I'll do that in a separate p=
atch.
>
> Ok I read up on your usage of GFP_ATOMIC in habanalabs, and I'm not
> going to touch this. But I'm pretty sure it's broken.
>
> You seem to have some requirement of not allocating memory with
> blocking (see hl_cb_alloc()), and that seems to be way you allocate
> tons of structures with GFP_ATOMIC. There's 2 pretty tough problems
> with that:
> - GFP_ATOMIC can fail, even when the system hasn't run out of memory
> yet. You _must_ have a fallback back to handle allocation failures for
> these. Quick survey shows you a ton of GFP_ATOMIC callsites, and very
> little fallback code - I've found none, but I didn't check the failure
> handlers all going up the possible callchains.
> - pin_user_pages can allocate memory, so you're breaking your own "no
> sleeping in these paths" rules.
>
> This isn't going to get fixed with a quick oneliner patch, depending
> what's needed you're looking at a driver rearchitecture here :-/ Hence
> I'm not going to touch this in the next patch, but leave it all as-is.
>
Most of those requirements come from code that is only relevant in
initial bringup and in our first ASIC (GOYA) for the first few months
we had it.
I'm going to remove all that code from the upstream driver as it's not
needed there.

Then, I'll go and look at all other uses of GFP_ATOMIC to see how they
can be improved/removed, maybe with pre-allocated stuff.
Thanks for pointing this out.
Oded

> Cheers, Daniel
>
> >
> > > In the meanwhile, I'll run this patch (coupled with the next patch) i=
n
> > > our C/I to make sure there are no regressions.
> >
> > Excellent. I'll wait with v3 until that's done, just in case you hit a
> > snag I need to fix.
> >
> > Cheers, Daniel
> >
> > > Thanks,
> > > Oded
> > >
> > > >         if (rc < 0) {
> > > >                 dev_err(hdev->dev, "failed to create SG table from =
pages\n");
> > > > -               goto put_framevec;
> > > > +               goto put_pages;
> > > >         }
> > > >
> > > >         return 0;
> > > >
> > > > -put_framevec:
> > > > -       put_vaddr_frames(userptr->vec);
> > > > -destroy_framevec:
> > > > -       frame_vector_destroy(userptr->vec);
> > > > +put_pages:
> > > > +       unpin_user_pages(userptr->pages, npages);
> > > > +destroy_pages:
> > > > +       kvfree(userptr->pages);
> > > >         return rc;
> > > >  }
> > > >
> > > > @@ -1405,8 +1401,6 @@ int hl_pin_host_memory(struct hl_device *hdev=
, u64 addr, u64 size,
> > > >   */
> > > >  void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userpt=
r *userptr)
> > > >  {
> > > > -       struct page **pages;
> > > > -
> > > >         hl_debugfs_remove_userptr(hdev, userptr);
> > > >
> > > >         if (userptr->dma_mapped)
> > > > @@ -1414,15 +1408,8 @@ void hl_unpin_host_memory(struct hl_device *=
hdev, struct hl_userptr *userptr)
> > > >                                                         userptr->sg=
t->nents,
> > > >                                                         userptr->di=
r);
> > > >
> > > > -       pages =3D frame_vector_pages(userptr->vec);
> > > > -       if (!IS_ERR(pages)) {
> > > > -               int i;
> > > > -
> > > > -               for (i =3D 0; i < frame_vector_count(userptr->vec);=
 i++)
> > > > -                       set_page_dirty_lock(pages[i]);
> > > > -       }
> > > > -       put_vaddr_frames(userptr->vec);
> > > > -       frame_vector_destroy(userptr->vec);
> > > > +       unpin_user_pages_dirty_lock(userptr->pages, userptr->npages=
, true);
> > > > +       kvfree(userptr->pages);
> > > >
> > > >         list_del(&userptr->job_node);
> > > >
> > > > --
> > > > 2.28.0
> > > >
> >
> >
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
