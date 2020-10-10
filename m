Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0128A194
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgJJVrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731422AbgJJTV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 15:21:28 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177D4C08EA7C
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 10:30:43 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id u8so17605430ejg.1
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 10:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AkcMDQ9MzR0MXrPdl4Z5WIlaKuGLuztzGgHABJ/UwRo=;
        b=Tn1BNmOZPmbfirFetQOYO/ocDzjrlXPQ3LhwSZNpGIDc+8auCeevOxYV9x2mwnL+LJ
         B1X87tTja6iFvGiJMYchruyGKGyDa2qJyDYXpQ4MO9cDFl66eVBMa7wPbnL2v+lbkE61
         A3oosZUv6WC10KVVTloFe7vbgZMt3GHhIV9Zs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AkcMDQ9MzR0MXrPdl4Z5WIlaKuGLuztzGgHABJ/UwRo=;
        b=A8y8uj6F7IQCcGMWq2i2sNXOcVd8nY23SW/dMXzG/ojIV98MGfjfoV37vG1/seeQLD
         7hmuI3Stw5jQZlFSv/VmR5eEWZGspX/+UQhDJXwAGbpGiUS3SWJ0SspygFTZlBHl0ThX
         yHNwFyvJ0LDysSNBc27TUf5y62+rO1rnIUJLHyiSA9Wtua8rgZu85PT0b9V5JC73gXEF
         YxXUNmehi+DVREyivF//HNVc7LsuST6GCHT6rdxmXS2fqOO9zjSQL/PbGgNBlwepx6o4
         jAtzbkQdm7T4JN14QN4jqPFS+rb7fbSDY34Jbcar3C2MAjxRdp5LEHcM80OMFc80Xtho
         P+hQ==
X-Gm-Message-State: AOAM530DGb4dwwHSpd9fbQI24bOtZjbk5LtW6Wx4yl01VtlwTrUWZ7lg
        SKFOchVN147q8cBCQ+ClsB9LJTa42e47hw==
X-Google-Smtp-Source: ABdhPJzoY1qYy9LTUtVSmy5jSdjKiYoaM1YCHfOWLKiICOJc42I/YEMMsjbbg6JIQZkJKZJVF4GJsg==
X-Received: by 2002:a17:906:7045:: with SMTP id r5mr19986891ejj.355.1602351041278;
        Sat, 10 Oct 2020 10:30:41 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id u18sm8169013ejm.115.2020.10.10.10.30.40
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 10:30:41 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id j136so12858068wmj.2
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 10:30:40 -0700 (PDT)
X-Received: by 2002:a1c:2d85:: with SMTP id t127mr3480262wmt.22.1602350579384;
 Sat, 10 Oct 2020 10:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-10-daniel.vetter@ffwll.ch> <20201009123421.67a80d72@coco.lan>
 <20201009122111.GN5177@ziepe.ca> <20201009143723.45609bfb@coco.lan>
 <20201009124850.GP5177@ziepe.ca> <CAKMK7uF-hrSwzFQkp6qEP88hM1Qg8TMQOunuRHh=f2+D8MaMRg@mail.gmail.com>
In-Reply-To: <CAKMK7uF-hrSwzFQkp6qEP88hM1Qg8TMQOunuRHh=f2+D8MaMRg@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Sat, 10 Oct 2020 19:22:48 +0200
X-Gmail-Original-Message-ID: <CAAFQd5CTT0re4ssj9NNTxhejFX_v_rCjy6=mX7C+dc=Lw9GOHw@mail.gmail.com>
Message-ID: <CAAFQd5CTT0re4ssj9NNTxhejFX_v_rCjy6=mX7C+dc=Lw9GOHw@mail.gmail.com>
Subject: Re: [PATCH v2 09/17] mm: Add unsafe_follow_pfn
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Daniel,

On Fri, Oct 9, 2020 at 7:52 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> On Fri, Oct 9, 2020 at 2:48 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Oct 09, 2020 at 02:37:23PM +0200, Mauro Carvalho Chehab wrote:
> >
> > > I'm not a mm/ expert, but, from what I understood from Daniel's patch
> > > description is that this is unsafe *only if*  __GFP_MOVABLE is used.
> >
> > No, it is unconditionally unsafe. The CMA movable mappings are
> > specific VMAs that will have bad issues here, but there are other
> > types too.
> >
> > The only way to do something at a VMA level is to have a list of OK
> > VMAs, eg because they were creatd via a special mmap helper from the
> > media subsystem.
> >
> > > Well, no drivers inside the media subsystem uses such flag, although
> > > they may rely on some infrastructure that could be using it behind
> > > the bars.
> >
> > It doesn't matter, nothing prevents the user from calling media APIs
> > on mmaps it gets from other subsystems.
>
> I think a good first step would be to disable userptr of non struct
> page backed storage going forward for any new hw support. Even on
> existing drivers. dma-buf sharing has been around for long enough now
> that this shouldn't be a problem. Unfortunately right now this doesn't
> seem to exist, so the entire problem keeps getting perpetuated.
>
> > > If this is the case, the proper fix seems to have a GFP_NOT_MOVABLE
> > > flag that it would be denying the core mm code to set __GFP_MOVABLE.
> >
> > We can't tell from the VMA these kinds of details..
> >
> > It has to go the other direction, evey mmap that might be used as a
> > userptr here has to be found and the VMA specially created to allow
> > its use. At least that is a kernel only change, but will need people
> > with the HW to do this work.
>
> I think the only reasonable way to keep this working is:
> - add a struct dma_buf *vma_tryget_dma_buf(struct vm_area_struct *vma);
> - add dma-buf export support to fbdev and v4l

I assume you mean V4L2 and not the obsolete V4L that is emulated in
the userspace by libv4l. If so, every video device that uses videobuf2
gets DMA-buf export for free and there is nothing needed to enable it.

We probably still have a few legacy drivers using videobuf (non-2),
but IMHO those should be safe to put behind some disabled-by-default
Kconfig symbol or even completely drop, as the legacy framework has
been deprecated for many years already.

> - roll this out everywhere we still need it.
>
> Realistically this just isn't going to happen. And anything else just
> reimplements half of dma-buf, which is kinda pointless (you need
> minimally refcounting and some way to get at a promise of a permanent
> sg list for dma. Plus probably the vmap for kernel cpu access.
>
> > > Please let address the issue on this way, instead of broken an
> > > userspace API that it is there since 1991.
> >
> > It has happened before :( It took 4 years for RDMA to undo the uAPI
> > breakage caused by a security fix for something that was a 15 years
> > old bug.
>
> Yeah we have a bunch of these on the drm side too. Some of them are
> really just "you have to upgrade userspace", and there's no real fix
> for the security nightmare without that.

I think we need to phase out such userspace indeed. The Kconfig symbol
allows enabling the unsafe functionality for anyone who still needs
it, so I think it's not entirely a breakage.

Best regards,
Tomasz
