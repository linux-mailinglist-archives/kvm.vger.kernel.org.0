Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A2F1CB27C
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgEHPFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 11:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgEHPFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 11:05:43 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B86C061A0C
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 08:05:43 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id v4so547330qte.3
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 08:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IhwHM3vWsZyNiLOz6qrYkX84URnnDzt9jte52kOygqQ=;
        b=TFzl/YNStMC7c/QO4v5za8XO+KdWc8V3Wd8lfoEEFivJ45eAabfZwazGMN+/jcEkzo
         xig3oNkFG8G1NbfhmPaNtCG7zmj7A96+13gjzJL3s7roQ6Jtzmvmjnwa6pChGt8KdQDP
         iwopRVy6jwdAuPvbQzWXoxHzTzwTXFf0OEqHSEvgVAvxLhm4G+cQ/0RkGRzXst6FSjX1
         G9hBAZSNHljo8WNWLgNMwT+rfJipymy6Qhjis4QaVTLGf+f2YhrKWyPi4CXnwnuYA6ha
         8MCYs3K1Sg84Iu3kbMKf7OnoyGDX4bvdPrb6yoBat/Bm3hlBKYOCIZk7/EWsQAaIgVFz
         tltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IhwHM3vWsZyNiLOz6qrYkX84URnnDzt9jte52kOygqQ=;
        b=a4Rw29jIH2qG5J3ytELyToLoM6UedHWKKSYySuDkZf34VDMvJqiBUKNLbFkWxoB1GN
         CEk4+9dorjKHAzk037HQ+s2hE/X9ymhHGbwQ3Mvikhff52H0Ws9bJGB1grQ5UY/ZqN1N
         GQ2RKyr2tBeB5oAOrHjWIkPMax5T/E1qGaJMLUyi16dELHeeMayRUvtFegLOtPCvxDmH
         cRDnoM9wwMuex1iuI4Lt/5tivvCuuCKC6CtRemnm8R7CH6YULrCMDJeFKNztq149N1HT
         d0z+I1hLhzlE9KhbfhGn1WJXMGn1BVdkNBJy2jTrlvvio803/j4c7U4GguTDOqANSGit
         M+gw==
X-Gm-Message-State: AGi0PuaswIIIaKiBeFZhTvnR6hqlvKmN2rxi5yp5Qn8Q366JcG5a1KGy
        8yITtjk0ETQh8OZdZ+njKACxSA==
X-Google-Smtp-Source: APiQypIzfpPPpWkThEtQHQ+2L99BXJTCmi6V8H/s7oDAx98Nk4vgzA4mIqR8Yb8KQY1WKgC0JZAz1Q==
X-Received: by 2002:ac8:7758:: with SMTP id g24mr3275992qtu.85.1588950341927;
        Fri, 08 May 2020 08:05:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id z18sm1598288qti.47.2020.05.08.08.05.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 08:05:41 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jX4ZI-0006Yk-Fu; Fri, 08 May 2020 12:05:40 -0300
Date:   Fri, 8 May 2020 12:05:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200508150540.GP26002@ziepe.ca>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
 <20200507212443.GO228260@xz-x1>
 <20200507235421.GK26002@ziepe.ca>
 <20200508021939.GT228260@xz-x1>
 <20200508121013.GO26002@ziepe.ca>
 <20200508143042.GY228260@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508143042.GY228260@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 10:30:42AM -0400, Peter Xu wrote:
> On Fri, May 08, 2020 at 09:10:13AM -0300, Jason Gunthorpe wrote:
> > On Thu, May 07, 2020 at 10:19:39PM -0400, Peter Xu wrote:
> > > On Thu, May 07, 2020 at 08:54:21PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, May 07, 2020 at 05:24:43PM -0400, Peter Xu wrote:
> > > > > On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> > > > > > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > > > > > the range being faulted into the vma.  Add support to manually provide
> > > > > > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > > > > > 
> > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> > > > > >  1 file changed, 33 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > > > index cc1d64765ce7..4a4cb7cd86b2 100644
> > > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> > > > > >  	return 0;
> > > > > >  }
> > > > > >  
> > > > > > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > > > > > +			    unsigned long vaddr, unsigned long *pfn,
> > > > > > +			    bool write_fault)
> > > > > > +{
> > > > > > +	int ret;
> > > > > > +
> > > > > > +	ret = follow_pfn(vma, vaddr, pfn);
> > > > > > +	if (ret) {
> > > > > > +		bool unlocked = false;
> > > > > > +
> > > > > > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > > > > > +				       FAULT_FLAG_REMOTE |
> > > > > > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > > > > > +				       &unlocked);
> > > > > > +		if (unlocked)
> > > > > > +			return -EAGAIN;
> > > > > 
> > > > > Hi, Alex,
> > > > > 
> > > > > IIUC this retry is not needed too because fixup_user_fault() will guarantee the
> > > > > fault-in is done correctly with the valid PTE as long as ret==0, even if
> > > > > unlocked==true.
> > > > 
> > > > It is true, and today it is fine, but be careful when reworking this
> > > > to use notifiers as unlocked also means things like the vma pointer
> > > > are invalidated.
> > > 
> > > Oh right, thanks for noticing that.  Then we should probably still keep the
> > > retry logic... because otherwise the latter follow_pfn() could be referencing
> > > an invalid vma already...
> > 
> > I looked briefly and thought this flow used the vma only once?
> 
>         ret = follow_pfn(vma, vaddr, pfn);
>         if (ret) {
>                 bool unlocked = false;
>  
>                 ret = fixup_user_fault(NULL, mm, vaddr,
>                                        FAULT_FLAG_REMOTE |
>                                        (write_fault ?  FAULT_FLAG_WRITE : 0),
>                                        &unlocked);
>                 if (unlocked)
>                         return -EAGAIN;
>  
>                 if (ret)
>                         return ret;
>  
>                 ret = follow_pfn(vma, vaddr, pfn);      <--------------- [1]
>         }
> 
> So imo the 2nd follow_pfn() [1] could be racy if without the unlocked check.

Ah yes, I didn't notice that, you can't touch vma here if unlocked is true.

Jason
