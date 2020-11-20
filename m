Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB20C2BA7C8
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 11:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgKTKvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 05:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgKTKvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 05:51:33 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D179C0613CF
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 02:51:31 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id g19so8274696otp.13
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 02:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9N1VJa6PgaSrJK1UStrZa9k9hVHdgTE/3/Vb+F7qDfg=;
        b=MpezDlRHhDSLM+N5cZzIEzt77SYyy+A3JHsWxp1YZhY1ZVLefqezDmgWeeVuLW+0Sz
         hNspdaDLmjlNt+Tms4qqJ/jndEuNmpgedZxgoIIUiCQI7bUtpNW3IvL2VvfxCvxRYz8A
         tm+ce3BzWttaGumHJxGVfC2fzpl5+ui467JMg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9N1VJa6PgaSrJK1UStrZa9k9hVHdgTE/3/Vb+F7qDfg=;
        b=S9RJwhpAFq0QhlQ8JFJpa1y+D3trBi/surh5NROj7CVm1jitawVDn1JTIjNRIrjasS
         fUGUE6PxNVwMf42j7QK9KFcfO+95WMuVV5u3o5i5lnyxmbY56TPnvyReK3YnTR2Q/5CM
         scNYjqBRawrAN5KuOYTodrCFLXCc5kOw4gYn/6ZyI/+vtk66r28kaDrS9SFeODc3tLzJ
         3z6tErv7S1JBjUqusGlnEqJpyswjX9Lc/MdT8irGkyzaoxdHYKt6Np7QQcVkyQEQasq6
         6RZKhF1j0MFroUj6h3LJISJhQJQ2z4ASFUSjUkT4lW6iTaIyNKlwO5pSoDAryBlBxMjj
         Fu0w==
X-Gm-Message-State: AOAM530p9grhST3a76LJBTkTgbGSoTIDmXO7CJlr7wLgGDJQ86mk7Dl6
        /t/qbUDcj8qE/kbzVfDaKzjEyex3aqwmT1MEFuDxbA==
X-Google-Smtp-Source: ABdhPJwaUr0TH4lPLa5FMJrImRPu3iblpyE9hZFNrMyCqKJhe/bQLEuDQvgi+ftqAXbnts12Il5Vkgn/R3iSW/a/ylM=
X-Received: by 2002:a9d:3b4:: with SMTP id f49mr14063332otf.188.1605869490350;
 Fri, 20 Nov 2020 02:51:30 -0800 (PST)
MIME-Version: 1.0
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-10-daniel.vetter@ffwll.ch> <f1f3a1d8-d62a-6e93-afc1-87a8e51081e9@xs4all.nl>
 <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl> <CAKMK7uEzFAtr9yxjaxi-kiuZhb+hWT3q6E41OegJr+J2-zkT8w@mail.gmail.com>
 <9035555a-af6b-e2dd-dbad-41ca70235e21@xs4all.nl>
In-Reply-To: <9035555a-af6b-e2dd-dbad-41ca70235e21@xs4all.nl>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 20 Nov 2020 11:51:18 +0100
Message-ID: <CAKMK7uFrXJh9jc5-v02A=JE8B3aThbYtTxFN-CGQUB=0TGmKgQ@mail.gmail.com>
Subject: Re: [PATCH v6 09/17] media/videbuf1|2: Mark follow_pfn usage as unsafe
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, Tomasz Figa <tfiga@chromium.org>,
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

On Fri, Nov 20, 2020 at 11:39 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 20/11/2020 10:18, Daniel Vetter wrote:
> > On Fri, Nov 20, 2020 at 9:28 AM Hans Verkuil <hverkuil@xs4all.nl> wrote=
:
> >>
> >> On 20/11/2020 09:06, Hans Verkuil wrote:
> >>> On 19/11/2020 15:41, Daniel Vetter wrote:
> >>>> The media model assumes that buffers are all preallocated, so that
> >>>> when a media pipeline is running we never miss a deadline because th=
e
> >>>> buffers aren't allocated or available.
> >>>>
> >>>> This means we cannot fix the v4l follow_pfn usage through
> >>>> mmu_notifier, without breaking how this all works. The only real fix
> >>>> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> >>>> tell everyone to cut over to dma-buf memory sharing for zerocopy.
> >>>>
> >>>> userptr for normal memory will keep working as-is, this only affects
> >>>> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
> >>>> videobuf2-dma-sg: Support io userptr operations on io memory").
> >>>>
> >>>> Acked-by: Tomasz Figa <tfiga@chromium.org>
> >>>
> >>> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>
> >> Actually, cancel this Acked-by.
> >>
> >> So let me see if I understand this right: VM_IO | VM_PFNMAP mappings c=
an
> >> move around. There is a mmu_notifier that can be used to be notified w=
hen
> >> that happens, but that can't be used with media buffers since those bu=
ffers
> >> must always be available and in the same place.
> >>
> >> So follow_pfn is replaced by unsafe_follow_pfn to signal that what is =
attempted
> >> is unsafe and unreliable.
> >>
> >> If CONFIG_STRICT_FOLLOW_PFN is set, then unsafe_follow_pfn will fail, =
if it
> >> is unset, then it writes a warning to the kernel log but just continue=
s while
> >> still unsafe.
> >>
> >> I am very much inclined to just drop VM_IO | VM_PFNMAP support in the =
media
> >> subsystem. For vb2 there is a working alternative in the form of dmabu=
f, and
> >> frankly for vb1 I don't care. If someone really needs this for a vb1 d=
river,
> >> then they can do the work to convert that driver to vb2.
> >>
> >> I've added Mauro to the CC list and I'll ping a few more people to see=
 what
> >> they think, but in my opinion support for USERPTR + VM_IO | VM_PFNMAP
> >> should just be killed off.
> >>
> >> If others would like to keep it, then frame_vector.c needs a comment b=
efore
> >> the 'while' explaining why the unsafe_follow_pfn is there and that usi=
ng
> >> dmabuf is the proper alternative to use. That will make it easier for
> >> developers to figure out why they see a kernel warning and what to do =
to
> >> fix it, rather than having to dig through the git history for the reas=
on.
> >
> > I'm happy to add a comment, but otherwise if you all want to ditch
> > this, can we do this as a follow up on top? There's quite a bit of
> > code that can be deleted and I'd like to not hold up this patch set
> > here on that - it's already a fairly sprawling pain touching about 7
> > different subsystems (ok only 6-ish now since the s390 patch landed).
> > For the comment, is the explanation next to unsafe_follow_pfn not good
> > enough?
>
> No, because that doesn't mention that you should use dma-buf as a replace=
ment.
> That's really the critical piece of information I'd like to see. That doe=
sn't
> belong in unsafe_follow_pfn, it needs to be in frame_vector.c since it's
> vb2 specific.

Ah makes sense, I'll add that.

> >
> > So ... can I get you to un-cancel your ack?
>
> Hmm, I really would like to see support for this to be dropped completely=
.
>
> How about this: just replace follow_pfn() by -EINVAL instead of unsafe_fo=
llow_pfn().
>
> Add a TODO comment that this code now can be cleaned up a lot. Such a cle=
an up patch
> can be added on top later, and actually that is something that I can do o=
nce this
> series has landed.
>
> Regardless, frame_vector.c should mention dma-buf as a replacement in a c=
omment
> since I don't want users who hit this issue to have to dig through git lo=
gs
> to find that dma-buf is the right approach.
>
> BTW, nitpick: the subject line of this patch says 'videbuf' instead of 'v=
ideobuf'.

Will fix to, and next round will have the additional -EINVAL on top.
Iirc Mauro was pretty clear that we can't just delete this, so I kinda
don't want to get stuck in this discussion with my patches :-)
-Daniel

>
> Regards,
>
>         Hans
>
> >
> > Thanks, Daniel
> >
> >>
> >> Regards,
> >>
> >>         Hans
> >>
> >>>
> >>> Thanks!
> >>>
> >>>       Hans
> >>>
> >>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> >>>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> >>>> Cc: Kees Cook <keescook@chromium.org>
> >>>> Cc: Dan Williams <dan.j.williams@intel.com>
> >>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>>> Cc: John Hubbard <jhubbard@nvidia.com>
> >>>> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> >>>> Cc: Jan Kara <jack@suse.cz>
> >>>> Cc: Dan Williams <dan.j.williams@intel.com>
> >>>> Cc: linux-mm@kvack.org
> >>>> Cc: linux-arm-kernel@lists.infradead.org
> >>>> Cc: linux-samsung-soc@vger.kernel.org
> >>>> Cc: linux-media@vger.kernel.org
> >>>> Cc: Pawel Osciak <pawel@osciak.com>
> >>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> >>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> >>>> Cc: Tomasz Figa <tfiga@chromium.org>
> >>>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> >>>> Cc: Vlastimil Babka <vbabka@suse.cz>
> >>>> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> >>>> Cc: Michel Lespinasse <walken@google.com>
> >>>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>>> --
> >>>> v3:
> >>>> - Reference the commit that enabled the zerocopy userptr use case to
> >>>>   make it abundandtly clear that this patch only affects that, and n=
ot
> >>>>   normal memory userptr. The old commit message already explained th=
at
> >>>>   normal memory userptr is unaffected, but I guess that was not clea=
r
> >>>>   enough.
> >>>> ---
> >>>>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
> >>>>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
> >>>>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers=
/media/common/videobuf2/frame_vector.c
> >>>> index a0e65481a201..1a82ec13ea00 100644
> >>>> --- a/drivers/media/common/videobuf2/frame_vector.c
> >>>> +++ b/drivers/media/common/videobuf2/frame_vector.c
> >>>> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned=
 int nr_frames,
> >>>>                      break;
> >>>>
> >>>>              while (ret < nr_frames && start + PAGE_SIZE <=3D vma->v=
m_end) {
> >>>> -                    err =3D follow_pfn(vma, start, &nums[ret]);
> >>>> +                    err =3D unsafe_follow_pfn(vma, start, &nums[ret=
]);
> >>>>                      if (err) {
> >>>>                              if (ret =3D=3D 0)
> >>>>                                      ret =3D err;
> >>>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers=
/media/v4l2-core/videobuf-dma-contig.c
> >>>> index 52312ce2ba05..821c4a76ab96 100644
> >>>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> >>>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> >>>> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct v=
ideobuf_dma_contig_memory *mem,
> >>>>      user_address =3D untagged_baddr;
> >>>>
> >>>>      while (pages_done < (mem->size >> PAGE_SHIFT)) {
> >>>> -            ret =3D follow_pfn(vma, user_address, &this_pfn);
> >>>> +            ret =3D unsafe_follow_pfn(vma, user_address, &this_pfn)=
;
> >>>>              if (ret)
> >>>>                      break;
> >>>>
> >>>>
> >>>
> >>
> >
> >
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
