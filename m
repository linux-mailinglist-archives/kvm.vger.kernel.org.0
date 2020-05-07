Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870D81C9F50
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 01:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgEGXyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 19:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgEGXyY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 19:54:24 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F44C05BD09
        for <kvm@vger.kernel.org>; Thu,  7 May 2020 16:54:24 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id h6so3640770qvz.8
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 16:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/raYmft6nSaYLNIgpOxoChFcf5nF1Q2ACz6k5lK6B/4=;
        b=QSBVJtiYPNgCyg1Ax8MDmIonk9zKYH0IwrH/+u1j84YGMeisn3e+g5EGfpuObjJv7H
         wXFl0tfpZnxNnL053pF5sRWfIpTmu9eUL4M/zurqAuPqCZexdEgP1pM2dggKDOZjnEyy
         f6umf0+v8hfXZ4AZKWQYtiLz6vbcbQ/SZhptvHMrDLwUmI9k8+UWJ8gEEN+lNSZiuSKN
         rgbjcYlDgqSq19b+5VbYruXqDxWlnvU6ogiMB6YnPypcQltpT5B/nG/bL2YQfDfbt0yM
         FeKyBoa4zJpeEKZGnc4fSHBnCA/++Yf4pPt5kyhoPiECazyfelAm9wkjL4fNtPGd5gQE
         5vUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/raYmft6nSaYLNIgpOxoChFcf5nF1Q2ACz6k5lK6B/4=;
        b=GCEiWKwWA1xU6z4KlzUSULpo7WQC9QsGi8WTMbcJk7BITNf6+vgQZAeEt7Eu5b31xi
         WeCNFJ6UFh//8y362KyEB1YHx/BUuxka2NvHIKnk1EPGnf9xAYQ46NI+R+bNal2bfIWG
         na3K+/ZN8L8WCiA5V8rV+QyE35bQGEZroID9EgnHtPdNjUJ4f5sCHWJoFxjuQauHuioC
         97r1XVzeCtHXAlcJv1QNXnOz3tP91xCYQe3slqk7HpWeQ+9hT/52wmeKSfA7QkAKgiDr
         x6LnU23Bq6KmT+0q4ICWyx2yPpvRNjyshYgFSHxjbeOHAGKZHDBpPcGsg4sU3Bs9hO1h
         bBgg==
X-Gm-Message-State: AGi0PuZ79Po9kV6eGs8oc8KJ0ijUDnel7PL7DWmXmKrgB9XoKAltbYxe
        pguKN1CCYCh8J6DqQ+JoTK2GvA==
X-Google-Smtp-Source: APiQypJYoWIyvU8RY67V0VqBgsWt6nPorPZktKfWBDwkHhKb5x5+IKwxKG3GMtrHiOuUW542Jyo5Xw==
X-Received: by 2002:ad4:4966:: with SMTP id p6mr61018qvy.161.1588895663160;
        Thu, 07 May 2020 16:54:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id j11sm4877452qkk.33.2020.05.07.16.54.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2020 16:54:22 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jWqLN-00070n-OS; Thu, 07 May 2020 20:54:21 -0300
Date:   Thu, 7 May 2020 20:54:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200507235421.GK26002@ziepe.ca>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
 <20200507212443.GO228260@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507212443.GO228260@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 05:24:43PM -0400, Peter Xu wrote:
> On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > the range being faulted into the vma.  Add support to manually provide
> > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 33 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index cc1d64765ce7..4a4cb7cd86b2 100644
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> >  	return 0;
> >  }
> >  
> > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > +			    unsigned long vaddr, unsigned long *pfn,
> > +			    bool write_fault)
> > +{
> > +	int ret;
> > +
> > +	ret = follow_pfn(vma, vaddr, pfn);
> > +	if (ret) {
> > +		bool unlocked = false;
> > +
> > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > +				       FAULT_FLAG_REMOTE |
> > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > +				       &unlocked);
> > +		if (unlocked)
> > +			return -EAGAIN;
> 
> Hi, Alex,
> 
> IIUC this retry is not needed too because fixup_user_fault() will guarantee the
> fault-in is done correctly with the valid PTE as long as ret==0, even if
> unlocked==true.

It is true, and today it is fine, but be careful when reworking this
to use notifiers as unlocked also means things like the vma pointer
are invalidated.

Jason
