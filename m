Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFA428BAA5
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389028AbgJLOTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 10:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389027AbgJLOTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 10:19:12 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E339AC0613D1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 07:19:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d81so17317389wmc.1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 07:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SuTUuPoSnGpk/kjzh2rwLKMK0NV61T2wKUHxGWe1zb8=;
        b=b2jM2N7c7mPZ8EQ74nK4as+DJOk3QIe1TTYSZ7oaXJ3365OVv4YcNg0qxxuCOPCxWm
         vCNnR/PtgLnbnCWWMkgiKiOIBral0E0p/MHJyNO76dWYwluCVeZIJCQEYXYML0RprK+3
         MPKg0NsB7G5eAb0oAe3c/PxZvmGkrVc0l8J4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=SuTUuPoSnGpk/kjzh2rwLKMK0NV61T2wKUHxGWe1zb8=;
        b=bhT0HKw5/fjLkCLK1jLD/18OsMBFCmq5yoKv1C2kJZySGIJYgz6+Logd35g3fhAUl1
         kL9OLqOXVlNZXQHMIweElREhrbnn5C6+QKQQJeIyIcf0pPIJbpsjftmWk9SxDmAjPOLg
         9wFtcl9sz8hG/rA79nKUI03lITy7PQPvjSHnMeVjRwFWnqi8upTVDPsOspwtBb69HyUt
         uQ1YtIljST4aBVIakzt0Bl7BaUwb1pqt/zCpFtQNE2wkgtW1F89rXvTxYqXBByNmpCuy
         MdGVZGavJStqm3TaRDlntMNg/KgOy2YR/acksB0g1bi+52ftiFDL/DUQAd1CBl37G8eW
         qIJg==
X-Gm-Message-State: AOAM530Pk4AImgoVk387AOfaH3N5GrHNXLH91/bm1FoyrsqNuv7Rj3qt
        ED94KLHZClPGDjpP/DbreGZliA==
X-Google-Smtp-Source: ABdhPJzGnqdPcnQQAOL/8bt/9LG14tDuHDf/7FLmVEbsTsUaPr2zgpHozg5qRzqt8PtLD2kO4LhHrw==
X-Received: by 2002:a1c:5685:: with SMTP id k127mr11456739wmb.135.1602512349502;
        Mon, 12 Oct 2020 07:19:09 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z127sm23493365wmc.2.2020.10.12.07.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 07:19:08 -0700 (PDT)
Date:   Mon, 12 Oct 2020 16:19:06 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 08/17] s390/pci: Remove races against pte updates
Message-ID: <20201012141906.GX438822@phenom.ffwll.local>
Mail-Followup-To: Niklas Schnelle <schnelle@linux.ibm.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-9-daniel.vetter@ffwll.ch>
 <6deb08dd-46f3-bf26-5362-fdc696f6fd74@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6deb08dd-46f3-bf26-5362-fdc696f6fd74@linux.ibm.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 04:03:28PM +0200, Niklas Schnelle wrote:
> Hi Daniel,
> 
> freshly back from my vacation I've just taken a look at your patch.
> First thanks for this fix and the detailed commit description.
> Definitely makes sense to fix this and you can add my
> 
> Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
> 
> Content wise it all looks sane and clear and since Gerald did the testing,
> I would have applied it to our tree already, but I got some trivial
> checkpatch violations that probably apply to the whole series.
> I've commented them inline below.
> If you confirm there I can do the fixups when applying or you can resend.
> 
> On 10/9/20 9:59 AM, Daniel Vetter wrote:
> > Way back it was a reasonable assumptions that iomem mappings never
> > change the pfn range they point at. But this has changed:
> > 
> > - gpu drivers dynamically manage their memory nowadays, invalidating
> > ptes with unmap_mapping_range when buffers get moved
> > 
> > - contiguous dma allocations have moved from dedicated carvetouts to
> > cma regions. This means if we miss the unmap the pfn might contain
> > pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> > 
> > - even /dev/mem now invalidates mappings when the kernel requests that
> > iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> 
> The above commit mention should use the format
> 'commit 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims the region")'
> otherwise this results in a checkpatch ERROR.
> 
> > ("/dev/mem: Revoke mappings when a driver claims the region")
> > 
> > Accessing pfns obtained from ptes without holding all the locks is
> > therefore no longer a good idea. Fix this.
> > 
> > Since zpci_memcpy_from|toio seems to not do anything nefarious with
> > locks we just need to open code get_pfn and follow_pfn and make sure
> > we drop the locks only after we've done. The write function also needs
> 
> just a typo but just saw it "we're" instead of "we've"
> 
> > the copy_from_user move, since we can't take userspace faults while
> > holding the mmap sem.
> > 
> > Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> > 
> No empty line after the Revied-by tag.
> 
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> 
> Your Signed-off-by mail address does not match the one you're sending from,
> this yields a checkpatch warning when using git am with your mail.
> This is probably just a silly misconfiguration but since Signed-offs
> are signatures should I change this to 
> "Daniel Vetter <daniel.vetter@ffwll.ch>" which is the one you're
> sending from and also in the MAINTAINERS file?
> 
> 
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Jérôme Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> 
> The above Cc: line for Dan Williams is a duplicate
> 
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> > Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> > Cc: linux-s390@vger.kernel.org
> > --
> > v2: Move VM_IO | VM_PFNMAP checks around so they keep returning EINVAL
> > like before (Gerard)
> 
> I think the above should go before the CC/Signed-off/Reviewev block.

This is a per-subsystem bikeshed :-) drivers/gpu definitely wants it
above, but most core subsystems want it below. I'll move it.

> > ---
> >  arch/s390/pci/pci_mmio.c | 98 +++++++++++++++++++++++-----------------
> >  1 file changed, 57 insertions(+), 41 deletions(-)
> > 
> > diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> > index 401cf670a243..1a6adbc68ee8 100644
> > --- a/arch/s390/pci/pci_mmio.c
> > +++ b/arch/s390/pci/pci_mmio.c
> > @@ -119,33 +119,15 @@ static inline int __memcpy_toio_inuser(void __iomem *dst,
> >  	return rc;
> >  }
> >  
> > -static long get_pfn(unsigned long user_addr, unsigned long access,
> > -		    unsigned long *pfn)
> > -{
> > -	struct vm_area_struct *vma;
> > -	long ret;
> > -
> > -	mmap_read_lock(current->mm);
> > -	ret = -EINVAL;
> > -	vma = find_vma(current->mm, user_addr);
> > -	if (!vma)
> > -		goto out;
> > -	ret = -EACCES;
> > -	if (!(vma->vm_flags & access))
> > -		goto out;
> > -	ret = follow_pfn(vma, user_addr, pfn);
> > -out:
> > -	mmap_read_unlock(current->mm);
> > -	return ret;
> > -}
> > -
> >  SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
> >  		const void __user *, user_buffer, size_t, length)
> >  {
> >  	u8 local_buf[64];
> >  	void __iomem *io_addr;
> >  	void *buf;
> > -	unsigned long pfn;
> > +	struct vm_area_struct *vma;
> > +	pte_t *ptep;
> > +	spinlock_t *ptl;
> 
> With checkpatch.pl --strict the above yields a complained
> "CHECK: spinlock_t definition without comment" but I think
> that's really okay since your commit description is very clear.
> Same oin line 277.

I think this is a falls positive, checkpatch doesn't realize that
SYSCALL_DEFINE3 is a function, not a structure. And in a structure I'd
have added the kerneldoc or comment.

I'll fix up all the nits you've found for the next round. Thanks for
taking a look.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
