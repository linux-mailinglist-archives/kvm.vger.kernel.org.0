Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5DF1CAA4F
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEHMKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 08:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHMKQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 08:10:16 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2CFC05BD43
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 05:10:15 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f13so658956qkh.2
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 05:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T0bwJhmZX5+Xfje3cc7GfqzOVet+PwPBaosSI1LQ/BM=;
        b=NpVIIqpQIkTIDP4ctgUVLKD/ijmn0VwlHZQutY6d1NaCdjKgqUgZ7epptypxj8UDGq
         QFGHVukpOl/TDiUhlPgUf5aGx9imCMdwoH2Szuilbt4Tz/byRKkq7okhvL7tXW+wDoGc
         t9f5GfPEaRxjv70Sl+LHF85Yt6UQTVzd9pK9d5AxfVJ2/M3NR6P/f0+N5ZdeNkuZXtCY
         +FuVpvcB/Pc1G8TgMsUuugqdxEYBIyTUm2vsvzuO46qw+ksMPUvuC9LYITItdPRTi+tg
         ZomDEHo/EG3K/4vo4ODKZWTlQ+qxr+2bbQNqGcOJpAU4X8P/50R6hm4qr5uBn2RzMczx
         RUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T0bwJhmZX5+Xfje3cc7GfqzOVet+PwPBaosSI1LQ/BM=;
        b=XHtuq1I/Mr8LRZ3+lDOJ8HzUQHA6kVhW9cLNohOVYA1nPLhpmU99YUbym7kk2YDCHd
         elQtawJnF2yhgTb2/zNrLUoHB6qbWyuyjIqs+NInJZam05rRkFLtBhuMsl1YcOZKLnAm
         UQgmEtBAIy3pVtS2OGZWVpOtE6qx2yIyWNK2blL8ozwocbzS62kCuQaLlJ0xt7UU2Z5U
         kh14xb0yco75SF2XcJKrmMmCb9jWvLTC1dyba3QOdDkcCc8BNC3KTsod90wY4KbOpUME
         wusSVmV363gq5reTS+BM4H5HHW5+OK+pLONkyrHahws1pRMjYwewLy+YrsINYQlD/oWl
         zfcw==
X-Gm-Message-State: AGi0PuZRUQRONXC6T0BixVA0PudNuIkAQKOyGZoDhy61FPunIA/yt/I6
        VWmesl0B2LgZ9EzhnARbg5CjJw==
X-Google-Smtp-Source: APiQypL1+5apUx/WYX2DmI0oO76nrb4O3J+WtEZoL0V8tGDi8MVBdkF5sDw2wN7Txr6wU1o9CLWOqg==
X-Received: by 2002:a37:9ec4:: with SMTP id h187mr2479331qke.72.1588939814279;
        Fri, 08 May 2020 05:10:14 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id q32sm1311548qta.13.2020.05.08.05.10.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 05:10:13 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jX1pV-0003a7-5Z; Fri, 08 May 2020 09:10:13 -0300
Date:   Fri, 8 May 2020 09:10:13 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200508121013.GO26002@ziepe.ca>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
 <20200507212443.GO228260@xz-x1>
 <20200507235421.GK26002@ziepe.ca>
 <20200508021939.GT228260@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508021939.GT228260@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 10:19:39PM -0400, Peter Xu wrote:
> On Thu, May 07, 2020 at 08:54:21PM -0300, Jason Gunthorpe wrote:
> > On Thu, May 07, 2020 at 05:24:43PM -0400, Peter Xu wrote:
> > > On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> > > > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > > > the range being faulted into the vma.  Add support to manually provide
> > > > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > > > 
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> > > >  1 file changed, 33 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > index cc1d64765ce7..4a4cb7cd86b2 100644
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > > > +			    unsigned long vaddr, unsigned long *pfn,
> > > > +			    bool write_fault)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	ret = follow_pfn(vma, vaddr, pfn);
> > > > +	if (ret) {
> > > > +		bool unlocked = false;
> > > > +
> > > > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > > > +				       FAULT_FLAG_REMOTE |
> > > > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > > > +				       &unlocked);
> > > > +		if (unlocked)
> > > > +			return -EAGAIN;
> > > 
> > > Hi, Alex,
> > > 
> > > IIUC this retry is not needed too because fixup_user_fault() will guarantee the
> > > fault-in is done correctly with the valid PTE as long as ret==0, even if
> > > unlocked==true.
> > 
> > It is true, and today it is fine, but be careful when reworking this
> > to use notifiers as unlocked also means things like the vma pointer
> > are invalidated.
> 
> Oh right, thanks for noticing that.  Then we should probably still keep the
> retry logic... because otherwise the latter follow_pfn() could be referencing
> an invalid vma already...

I looked briefly and thought this flow used the vma only once?

Jason
