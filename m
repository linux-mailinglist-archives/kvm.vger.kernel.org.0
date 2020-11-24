Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21E2C2936
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 15:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388763AbgKXORA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 09:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388752AbgKXOQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 09:16:59 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C522AC0613D6
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 06:16:57 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id t4so9537998wrr.12
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 06:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lxaE8Not9jvLvGdPE1uCtN/cVkn9pPEtSLdbQyT9QXw=;
        b=Jqu3MmOxKtv9AEVJ44kKeuVO3gO1NOKfm+ACsbPcrxj2eHlEcRRMnE0TnNyC+zJYnI
         MKrPTvaoz4din/kg4k7SyOw5E6Rymxd/rfxXl/XrvCFIkFNXPpHJXYjcLwa+ea5x8oiU
         SW2i+f/oPr9w2wLEKdEgW7VtTgihlydGLaYjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=lxaE8Not9jvLvGdPE1uCtN/cVkn9pPEtSLdbQyT9QXw=;
        b=erbej4vSFhZC3x/2hRi5iqRkdRMecRT8NAJXmxUZ0ZoRXWWJy2AhuHkuC93VL1nUuX
         xN1bJwJWQmmaLNP+0iJzOao0EiqFG/pJDUmTjITVLRKe+3dMi2ooRqwwDf9Vuac7luIj
         Lip+ZUWyqHNzEGDfV7V4uvKwW17MrW6tiO6+BwgUzlrOHLaAwkqadFtdFeNSNrd2sCbh
         DRvOA9XvYcDEmqidlUd0+UJ7SsL40BR2hBR2OArKMIpkbzKjjvyITlyMKaiKwUHAOMI5
         QFYiXBA9eH95eASW7c/KX4qd0WVoadUNkuvMv+9re/FAow5Tl3t5UwTzz/r96TM5N+yZ
         IS6w==
X-Gm-Message-State: AOAM5304Bg2fRh+E8oPtAvC6TLLBLZUwaaI2yN4BieZQL3N7MBo8LspH
        phC7bNnFDYsnpW7wVSBZ8fqEYA==
X-Google-Smtp-Source: ABdhPJyvnAcNxBa7hPAnh3R0lC3dqHK5F5aliN5y0/6utGHWrgRKu8r7ObJFr2IEqd22MvzLgTn5ig==
X-Received: by 2002:adf:9cc6:: with SMTP id h6mr5554394wre.341.1606227416430;
        Tue, 24 Nov 2020 06:16:56 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id h2sm6243879wme.45.2020.11.24.06.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 06:16:55 -0800 (PST)
Date:   Tue, 24 Nov 2020 15:16:52 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v6 09/17] media/videbuf1|2: Mark follow_pfn usage as
 unsafe
Message-ID: <20201124141652.GL401619@phenom.ffwll.local>
Mail-Followup-To: Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-10-daniel.vetter@ffwll.ch>
 <f1f3a1d8-d62a-6e93-afc1-87a8e51081e9@xs4all.nl>
 <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl>
 <CAKMK7uEzFAtr9yxjaxi-kiuZhb+hWT3q6E41OegJr+J2-zkT8w@mail.gmail.com>
 <9035555a-af6b-e2dd-dbad-41ca70235e21@xs4all.nl>
 <CAKMK7uFrXJh9jc5-v02A=JE8B3aThbYtTxFN-CGQUB=0TGmKgQ@mail.gmail.com>
 <d44c6518-bd9c-87e0-dce4-2b63890e0f7e@xs4all.nl>
 <CAAFQd5DMTwUKE0B5L-WC5ehrrQVeRD_af+TG0FpYiPg0g=89Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAFQd5DMTwUKE0B5L-WC5ehrrQVeRD_af+TG0FpYiPg0g=89Hg@mail.gmail.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 09:23:12PM +0900, Tomasz Figa wrote:
> On Fri, Nov 20, 2020 at 9:08 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 20/11/2020 11:51, Daniel Vetter wrote:
> > > On Fri, Nov 20, 2020 at 11:39 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >>
> > >> On 20/11/2020 10:18, Daniel Vetter wrote:
> > >>> On Fri, Nov 20, 2020 at 9:28 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >>>>
> > >>>> On 20/11/2020 09:06, Hans Verkuil wrote:
> > >>>>> On 19/11/2020 15:41, Daniel Vetter wrote:
> > >>>>>> The media model assumes that buffers are all preallocated, so that
> > >>>>>> when a media pipeline is running we never miss a deadline because the
> > >>>>>> buffers aren't allocated or available.
> > >>>>>>
> > >>>>>> This means we cannot fix the v4l follow_pfn usage through
> > >>>>>> mmu_notifier, without breaking how this all works. The only real fix
> > >>>>>> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> > >>>>>> tell everyone to cut over to dma-buf memory sharing for zerocopy.
> > >>>>>>
> > >>>>>> userptr for normal memory will keep working as-is, this only affects
> > >>>>>> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
> > >>>>>> videobuf2-dma-sg: Support io userptr operations on io memory").
> > >>>>>>
> > >>>>>> Acked-by: Tomasz Figa <tfiga@chromium.org>
> > >>>>>
> > >>>>> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > >>>>
> > >>>> Actually, cancel this Acked-by.
> > >>>>
> > >>>> So let me see if I understand this right: VM_IO | VM_PFNMAP mappings can
> > >>>> move around. There is a mmu_notifier that can be used to be notified when
> > >>>> that happens, but that can't be used with media buffers since those buffers
> > >>>> must always be available and in the same place.
> > >>>>
> > >>>> So follow_pfn is replaced by unsafe_follow_pfn to signal that what is attempted
> > >>>> is unsafe and unreliable.
> > >>>>
> > >>>> If CONFIG_STRICT_FOLLOW_PFN is set, then unsafe_follow_pfn will fail, if it
> > >>>> is unset, then it writes a warning to the kernel log but just continues while
> > >>>> still unsafe.
> > >>>>
> > >>>> I am very much inclined to just drop VM_IO | VM_PFNMAP support in the media
> > >>>> subsystem. For vb2 there is a working alternative in the form of dmabuf, and
> > >>>> frankly for vb1 I don't care. If someone really needs this for a vb1 driver,
> > >>>> then they can do the work to convert that driver to vb2.
> > >>>>
> > >>>> I've added Mauro to the CC list and I'll ping a few more people to see what
> > >>>> they think, but in my opinion support for USERPTR + VM_IO | VM_PFNMAP
> > >>>> should just be killed off.
> > >>>>
> > >>>> If others would like to keep it, then frame_vector.c needs a comment before
> > >>>> the 'while' explaining why the unsafe_follow_pfn is there and that using
> > >>>> dmabuf is the proper alternative to use. That will make it easier for
> > >>>> developers to figure out why they see a kernel warning and what to do to
> > >>>> fix it, rather than having to dig through the git history for the reason.
> > >>>
> > >>> I'm happy to add a comment, but otherwise if you all want to ditch
> > >>> this, can we do this as a follow up on top? There's quite a bit of
> > >>> code that can be deleted and I'd like to not hold up this patch set
> > >>> here on that - it's already a fairly sprawling pain touching about 7
> > >>> different subsystems (ok only 6-ish now since the s390 patch landed).
> > >>> For the comment, is the explanation next to unsafe_follow_pfn not good
> > >>> enough?
> > >>
> > >> No, because that doesn't mention that you should use dma-buf as a replacement.
> > >> That's really the critical piece of information I'd like to see. That doesn't
> > >> belong in unsafe_follow_pfn, it needs to be in frame_vector.c since it's
> > >> vb2 specific.
> > >
> > > Ah makes sense, I'll add that.
> > >
> > >>>
> > >>> So ... can I get you to un-cancel your ack?
> > >>
> > >> Hmm, I really would like to see support for this to be dropped completely.
> > >>
> > >> How about this: just replace follow_pfn() by -EINVAL instead of unsafe_follow_pfn().
> > >>
> > >> Add a TODO comment that this code now can be cleaned up a lot. Such a clean up patch
> > >> can be added on top later, and actually that is something that I can do once this
> > >> series has landed.
> > >>
> > >> Regardless, frame_vector.c should mention dma-buf as a replacement in a comment
> > >> since I don't want users who hit this issue to have to dig through git logs
> > >> to find that dma-buf is the right approach.
> > >>
> > >> BTW, nitpick: the subject line of this patch says 'videbuf' instead of 'videobuf'.
> > >
> > > Will fix to, and next round will have the additional -EINVAL on top.
> > > Iirc Mauro was pretty clear that we can't just delete this, so I kinda
> > > don't want to get stuck in this discussion with my patches :-)
> >
> > Ah, I found that discussion for the v2 of this series.
> >
> > Yes, add that on top and we can discuss whether to Ack that -EINVAL patch or
> > not.
> >
> > I don't see why we would want to continue supporting a broken model that is
> > also a security risk, as I understand it.
> >
> > Tomasz, can you look at the discussion for this old RFC patch of mine:
> >
> > https://patchwork.linuxtv.org/project/linux-media/patch/20200221084531.576156-9-hverkuil-cisco@xs4all.nl/
> >
> > Specifically, if we just drop support for follow_pfn(), would that cause
> > problems for Chromium since that is apparently still using USERPTR for encoders?
> >
> 
> Nope, we use regular page-backed user pointers and not IO/PFNMAP ones.
> 
> By the way, for any inter-device sharing we're using DMABUF. USERPTR
> is left only in case of the data coming from the CPU, e.g. network.

Yeah Mauro wasn't too enthusiastic even about this patch here, so I think
I'll just leave it as-is. I fixed the typo in the commit message subject.
-Daniel

> 
> > Regards,
> >
> >         Hans
> >
> > > -Daniel
> > >
> > >>
> > >> Regards,
> > >>
> > >>         Hans
> > >>
> > >>>
> > >>> Thanks, Daniel
> > >>>
> > >>>>
> > >>>> Regards,
> > >>>>
> > >>>>         Hans
> > >>>>
> > >>>>>
> > >>>>> Thanks!
> > >>>>>
> > >>>>>       Hans
> > >>>>>
> > >>>>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > >>>>>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > >>>>>> Cc: Kees Cook <keescook@chromium.org>
> > >>>>>> Cc: Dan Williams <dan.j.williams@intel.com>
> > >>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> > >>>>>> Cc: John Hubbard <jhubbard@nvidia.com>
> > >>>>>> Cc: Jérôme Glisse <jglisse@redhat.com>
> > >>>>>> Cc: Jan Kara <jack@suse.cz>
> > >>>>>> Cc: Dan Williams <dan.j.williams@intel.com>
> > >>>>>> Cc: linux-mm@kvack.org
> > >>>>>> Cc: linux-arm-kernel@lists.infradead.org
> > >>>>>> Cc: linux-samsung-soc@vger.kernel.org
> > >>>>>> Cc: linux-media@vger.kernel.org
> > >>>>>> Cc: Pawel Osciak <pawel@osciak.com>
> > >>>>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > >>>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > >>>>>> Cc: Tomasz Figa <tfiga@chromium.org>
> > >>>>>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> > >>>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
> > >>>>>> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> > >>>>>> Cc: Michel Lespinasse <walken@google.com>
> > >>>>>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > >>>>>> --
> > >>>>>> v3:
> > >>>>>> - Reference the commit that enabled the zerocopy userptr use case to
> > >>>>>>   make it abundandtly clear that this patch only affects that, and not
> > >>>>>>   normal memory userptr. The old commit message already explained that
> > >>>>>>   normal memory userptr is unaffected, but I guess that was not clear
> > >>>>>>   enough.
> > >>>>>> ---
> > >>>>>>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
> > >>>>>>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
> > >>>>>>  2 files changed, 2 insertions(+), 2 deletions(-)
> > >>>>>>
> > >>>>>> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
> > >>>>>> index a0e65481a201..1a82ec13ea00 100644
> > >>>>>> --- a/drivers/media/common/videobuf2/frame_vector.c
> > >>>>>> +++ b/drivers/media/common/videobuf2/frame_vector.c
> > >>>>>> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
> > >>>>>>                      break;
> > >>>>>>
> > >>>>>>              while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
> > >>>>>> -                    err = follow_pfn(vma, start, &nums[ret]);
> > >>>>>> +                    err = unsafe_follow_pfn(vma, start, &nums[ret]);
> > >>>>>>                      if (err) {
> > >>>>>>                              if (ret == 0)
> > >>>>>>                                      ret = err;
> > >>>>>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> > >>>>>> index 52312ce2ba05..821c4a76ab96 100644
> > >>>>>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> > >>>>>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> > >>>>>> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
> > >>>>>>      user_address = untagged_baddr;
> > >>>>>>
> > >>>>>>      while (pages_done < (mem->size >> PAGE_SHIFT)) {
> > >>>>>> -            ret = follow_pfn(vma, user_address, &this_pfn);
> > >>>>>> +            ret = unsafe_follow_pfn(vma, user_address, &this_pfn);
> > >>>>>>              if (ret)
> > >>>>>>                      break;
> > >>>>>>
> > >>>>>>
> > >>>>>
> > >>>>
> > >>>
> > >>>
> > >>
> > >
> > >
> >

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
