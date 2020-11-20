Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE042BA4D0
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 09:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgKTIiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 03:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgKTIiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 03:38:16 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CA8C0613CF
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 00:38:16 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id f11so12321806lfs.3
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 00:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CSkCdCaqLBM0bWRHZ00ADxnd+NBE6b99YIUgGCXQ0N8=;
        b=b0w6ldKpDUpMxM+H9MUxFarymLOND8rU0+XNOChF0O2Py4IV00Gt47AXtaGeXw0t2r
         wHUIYai3iA2izngwjfCKMot50mClxBEGuQx4AYiM8qhD4pjCPBDtKuI2ns6damGBZZ29
         fteKSJKPs2hjKnRux2ro3BntaD5Y1UZDqK8Mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CSkCdCaqLBM0bWRHZ00ADxnd+NBE6b99YIUgGCXQ0N8=;
        b=NnXMpZO3f3G5Z9bpbHmINKvxJY1R/jZQSxFNkuz2NXmNZC+agMbQglEtS4UPC55wwT
         k3uD5P+EpF5vFovbI3Enbt/myis4c5Z5UxQgCb5+x3pWp72BRlhISk/JzmB24R8hbaH/
         9Wdjt2mn3ECoNQL7VsSzTCF/znU9i1WYDv0RjJXe1h6eOFNRcEvOCCa6xy0OH5ohLcy1
         FTGkGrKCV3BYR5WwAN7hsFkTZqEP8A0j+vaRf/spfopOZDyuk32oHXYPkn9HwoHOMwlL
         m+4dxZI06FykS/lGM53R9pZ/LVsPNMzqmWoUbRPkSFMvO2vsEVBUm9W/FRTS5WNSAAo2
         36uw==
X-Gm-Message-State: AOAM532xNikZAh6yo7nS4RVWN5CIIGTGIb5NNds9l86HDhtqoEdPyZCq
        zibvkML6IivhGtYcdVTLeltw+2iXTQyZFQ==
X-Google-Smtp-Source: ABdhPJxRdu19TetCjM09R0DrKUIWPq6TTnYdYJt3gGmutsLNBeLs3Azc4M0sQH72oUWpNL8mcdiRWA==
X-Received: by 2002:a05:6512:104e:: with SMTP id c14mr8297028lfb.345.1605861494563;
        Fri, 20 Nov 2020 00:38:14 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id e69sm266737lfd.106.2020.11.20.00.38.14
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 00:38:14 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id l11so12357432lfg.0
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 00:38:14 -0800 (PST)
X-Received: by 2002:adf:fb90:: with SMTP id a16mr13977920wrr.192.1605861181149;
 Fri, 20 Nov 2020 00:33:01 -0800 (PST)
MIME-Version: 1.0
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-10-daniel.vetter@ffwll.ch> <f1f3a1d8-d62a-6e93-afc1-87a8e51081e9@xs4all.nl>
 <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl>
In-Reply-To: <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 20 Nov 2020 17:32:49 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BWUp6XbYN84bYGL62_bT553Y5G+ynPA3wjk6rFvGU=OQ@mail.gmail.com>
Message-ID: <CAAFQd5BWUp6XbYN84bYGL62_bT553Y5G+ynPA3wjk6rFvGU=OQ@mail.gmail.com>
Subject: Re: [PATCH v6 09/17] media/videbuf1|2: Mark follow_pfn usage as unsafe
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 5:28 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 20/11/2020 09:06, Hans Verkuil wrote:
> > On 19/11/2020 15:41, Daniel Vetter wrote:
> >> The media model assumes that buffers are all preallocated, so that
> >> when a media pipeline is running we never miss a deadline because the
> >> buffers aren't allocated or available.
> >>
> >> This means we cannot fix the v4l follow_pfn usage through
> >> mmu_notifier, without breaking how this all works. The only real fix
> >> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> >> tell everyone to cut over to dma-buf memory sharing for zerocopy.
> >>
> >> userptr for normal memory will keep working as-is, this only affects
> >> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
> >> videobuf2-dma-sg: Support io userptr operations on io memory").
> >>
> >> Acked-by: Tomasz Figa <tfiga@chromium.org>
> >
> > Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
> Actually, cancel this Acked-by.
>
> So let me see if I understand this right: VM_IO | VM_PFNMAP mappings can
> move around. There is a mmu_notifier that can be used to be notified when
> that happens, but that can't be used with media buffers since those buffe=
rs
> must always be available and in the same place.
>
> So follow_pfn is replaced by unsafe_follow_pfn to signal that what is att=
empted
> is unsafe and unreliable.
>
> If CONFIG_STRICT_FOLLOW_PFN is set, then unsafe_follow_pfn will fail, if =
it
> is unset, then it writes a warning to the kernel log but just continues w=
hile
> still unsafe.
>
> I am very much inclined to just drop VM_IO | VM_PFNMAP support in the med=
ia
> subsystem. For vb2 there is a working alternative in the form of dmabuf, =
and
> frankly for vb1 I don't care. If someone really needs this for a vb1 driv=
er,
> then they can do the work to convert that driver to vb2.
>
> I've added Mauro to the CC list and I'll ping a few more people to see wh=
at
> they think, but in my opinion support for USERPTR + VM_IO | VM_PFNMAP
> should just be killed off.
>
> If others would like to keep it, then frame_vector.c needs a comment befo=
re
> the 'while' explaining why the unsafe_follow_pfn is there and that using
> dmabuf is the proper alternative to use. That will make it easier for
> developers to figure out why they see a kernel warning and what to do to
> fix it, rather than having to dig through the git history for the reason.

I'm all for dropping that code.

Best regards,
Tomasz

>
> Regards,
>
>         Hans
>
> >
> > Thanks!
> >
> >       Hans
> >
> >> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> >> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> >> Cc: Kees Cook <keescook@chromium.org>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: John Hubbard <jhubbard@nvidia.com>
> >> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> >> Cc: Jan Kara <jack@suse.cz>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Cc: linux-samsung-soc@vger.kernel.org
> >> Cc: linux-media@vger.kernel.org
> >> Cc: Pawel Osciak <pawel@osciak.com>
> >> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> >> Cc: Tomasz Figa <tfiga@chromium.org>
> >> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> >> Cc: Michel Lespinasse <walken@google.com>
> >> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> --
> >> v3:
> >> - Reference the commit that enabled the zerocopy userptr use case to
> >>   make it abundandtly clear that this patch only affects that, and not
> >>   normal memory userptr. The old commit message already explained that
> >>   normal memory userptr is unaffected, but I guess that was not clear
> >>   enough.
> >> ---
> >>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
> >>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/m=
edia/common/videobuf2/frame_vector.c
> >> index a0e65481a201..1a82ec13ea00 100644
> >> --- a/drivers/media/common/videobuf2/frame_vector.c
> >> +++ b/drivers/media/common/videobuf2/frame_vector.c
> >> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned i=
nt nr_frames,
> >>                      break;
> >>
> >>              while (ret < nr_frames && start + PAGE_SIZE <=3D vma->vm_=
end) {
> >> -                    err =3D follow_pfn(vma, start, &nums[ret]);
> >> +                    err =3D unsafe_follow_pfn(vma, start, &nums[ret])=
;
> >>                      if (err) {
> >>                              if (ret =3D=3D 0)
> >>                                      ret =3D err;
> >> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/m=
edia/v4l2-core/videobuf-dma-contig.c
> >> index 52312ce2ba05..821c4a76ab96 100644
> >> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> >> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> >> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct vid=
eobuf_dma_contig_memory *mem,
> >>      user_address =3D untagged_baddr;
> >>
> >>      while (pages_done < (mem->size >> PAGE_SHIFT)) {
> >> -            ret =3D follow_pfn(vma, user_address, &this_pfn);
> >> +            ret =3D unsafe_follow_pfn(vma, user_address, &this_pfn);
> >>              if (ret)
> >>                      break;
> >>
> >>
> >
>
