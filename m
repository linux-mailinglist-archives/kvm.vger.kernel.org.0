Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E26F2A69A9
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 17:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbgKDQ1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 11:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbgKDQ1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 11:27:12 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2C4C0613D4
        for <kvm@vger.kernel.org>; Wed,  4 Nov 2020 08:27:11 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id i18so15114765ots.0
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 08:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+jKBsc1XM8CUKlg3VqmwM4QNdUSjpFH4yWF5dp0NTz8=;
        b=i+/uTvjsk976DicxcEHtNNkKd5tdb/MRp5JTe2+pAxIGQwwKIuIcHCZ9gIfNuEktop
         Ir1VcTIHdqTsD4wZdHCdfVujbxPqzBZ00Mm5Mu7qHa2cbwKkBevm00cgHWq320ih38Ge
         yItaK3iWE/DQC0jvHc3VxVW7uMRTu+v2PtiCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+jKBsc1XM8CUKlg3VqmwM4QNdUSjpFH4yWF5dp0NTz8=;
        b=eLgnjXYTPpMGpB5Txr/CU0wSPdcozwjQpTyBEuf+Ua6IZidYOlun3UgeRmooNTpQWW
         oLEFrJ77MU9UAzvf4CGZotuoSfkICfnBq6Pt2xMeZpvwsD0DZpaHt2VhMw1qXQfChTUM
         +ohpywVOYuqu68vfEJIOVUxP3428Utp8YrVtskaGbWYbI3q8rIIrBiPITJ4YT6XKRVJH
         diPR6ytJtxIkV/2VZcKuJyMWoE7ne740HJ235zFEyvF+sm70q/HQu0AYdJ4cnawN7JQk
         /SXiokA1RX707HtAPmB9vgp9XVjywtm9vPs32SSlwJoy0GnXa6Xr+ghk7yy1fU5onl2I
         ic8w==
X-Gm-Message-State: AOAM531AXrcfo/wwlo4NMCUIScnXVAaGnTjyiJ05ye3fuvzFaL5GDljm
        SgHR7lC4Ug79/WwqQ/EfSWOALVatNKaH+BxJyRjA7w==
X-Google-Smtp-Source: ABdhPJwUkm33VhszJycM92X0W59/Lqj2SzkWRtSj8SP7VfVhLWlLHPhV+pa9uC6mpn9OH9RSQm2eEqL7TT7PFN/zowU=
X-Received: by 2002:a9d:3b4:: with SMTP id f49mr18948455otf.188.1604507229909;
 Wed, 04 Nov 2020 08:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch> <20201030100815.2269-6-daniel.vetter@ffwll.ch>
 <446b2d5b-a1a1-a408-f884-f17a04b72c18@nvidia.com> <CAKMK7uGDW2f0oOvwgryCHxQFHyh3Tsk6ENsMGmtZ-EnH57tMSA@mail.gmail.com>
 <1f7cf690-35e2-c56f-6d3f-94400633edd2@nvidia.com> <CAKMK7uFYDSqnNp_xpohzCEidw_iLufNSoX4v55sNZj-nwTckSg@mail.gmail.com>
 <7f29a42a-c408-525d-90b7-ef3c12b5826c@nvidia.com> <CAKMK7uEw701AWXNJbRNM8Z+FkyUB5FbWegmSzyWPy9cG4W7OLA@mail.gmail.com>
 <20201104140023.GQ36674@ziepe.ca> <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
 <20201104162125.GA13007@infradead.org>
In-Reply-To: <20201104162125.GA13007@infradead.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 4 Nov 2020 17:26:58 +0100
Message-ID: <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "J??r??me Glisse" <jglisse@redhat.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        KVM list <kvm@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux MM <linux-mm@kvack.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 4, 2020 at 5:21 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Nov 04, 2020 at 04:54:19PM +0100, Daniel Vetter wrote:
> > I don't really have a box here, but dma_mmap_attrs() and friends to
> > mmap dma_alloc_coherent memory is set up as VM_IO | VM_PFNMAP (it's
> > actually enforced since underneath it uses remap_pfn_range), and
> > usually (except if it's pre-cma carveout) that's just normal struct
> > page backed memory. Sometimes from a cma region (so will be caught by
> > the cma page check), but if you have an iommu to make it
> > device-contiguous, that's not needed.
>
> dma_mmap_* memory may or may not be page backed, but it absolutely
> must not be resolved by get_user_pages and friends as it is special.
> So yes, not being able to get a struct page back from such an mmap is
> a feature.

Yes, that's clear.

What we're discussing is whether gup_fast and pup_fast also obey this,
or fall over and can give you the struct page that's backing the
dma_mmap_* memory. Since the _fast variant doesn't check for
vma->vm_flags, and afaict that's the only thing which closes this gap.
And like you restate, that would be a bit a problem. So where's that
check which Jason&me aren't spotting?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
