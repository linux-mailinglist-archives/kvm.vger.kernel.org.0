Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887A71C216E
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 01:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgEAXug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 19:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgEAXuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 19:50:35 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EB2C061A0C
        for <kvm@vger.kernel.org>; Fri,  1 May 2020 16:50:34 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id 71so9243486qtc.12
        for <kvm@vger.kernel.org>; Fri, 01 May 2020 16:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SVjVQDn0bfQKipgWAWViUU9wfzrIQi3Sg9RKS8Emo3Y=;
        b=duGxTfRuSNX9fF3Iz58VWaJHAjOH0aZ5CbGe2i6jVrybPtIEtmVWZrUcMn1jVE1TsH
         c7l5bWxXh+4LUk7KchdkcRT9AtJqdc6hJJomLtXXFnoZBR6uw7KcYAqPKb/JL1U0/+xf
         Nx8eLBrS2pHDyM3UbaHzMdu9YdPfABjGXLSu0vuSAlbDCPD9yOopsgYJz38tLynB3giW
         NLlsBo50OH7i2Wqhbf+M2zjVVwooGIToUmPnO4LvwR37W6FHYpiULXDRFQ+x42u4DkHb
         1SMBcxLWG0ej39z9W9dNDwPa0coXZ/Kz2UWkZJdwSirg+LKgSEW5910EA+UDUAPCfkeR
         WnRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SVjVQDn0bfQKipgWAWViUU9wfzrIQi3Sg9RKS8Emo3Y=;
        b=e3giJ3d4EZ0NKAkv2z5shFNdrpP91ujgY2MdNonk2SqnKB+fEkRMREi9ioa6DR7+iP
         Folz0ySthFaEYBuh7Aje78YXqL8Iv24NUNAxUhv6m/T1ZFHmT9q6T10W8BNJPRlrUw/X
         5O/gLX2yDfaSMiyADj+EGodNNUp+lLJupQ/UkZzeG+P3lVmloV05+NzO1ptFy67Lvy25
         1iqK3V5Nlj482Ce6MD7EAczqrQEkHVwAjeqawQYcM+RPESYdlEaJPgP0YcvPtWSMB7B1
         spQcKMh6LCFLYc5liJzfFe1AyrYnMb7ik0Rt8LLBa4VEvbd4Ysxqf40iswuFWOtLHm84
         HwOQ==
X-Gm-Message-State: AGi0PuaFpt9Iqzbk6MNz1OoBTQcnt8odCnczNX/hM4GpCl5GjcZOGyVE
        3tKJlxQ4jOIxS8dFopjko5v9Dg==
X-Google-Smtp-Source: APiQypLpDSv73N6lzAdYh64o7wePUptTyDJylee4LveyxcCPdcx2qXfBiakHgR0S2eQb2haAd+2U9w==
X-Received: by 2002:aed:2468:: with SMTP id s37mr6495973qtc.305.1588377034097;
        Fri, 01 May 2020 16:50:34 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id p24sm4155246qtp.59.2020.05.01.16.50.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 16:50:33 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jUfQP-0005ur-3f; Fri, 01 May 2020 20:50:33 -0300
Date:   Fri, 1 May 2020 20:50:33 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200501235033.GA19929@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
 <158836914801.8433.9711545991918184183.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158836914801.8433.9711545991918184183.stgit@gimli.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 03:39:08PM -0600, Alex Williamson wrote:
> With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> the range being faulted into the vma.  Add support to manually provide
> that, in the same way as done on KVM with hva_to_pfn_remapped().
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
>  1 file changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index cc1d64765ce7..4a4cb7cd86b2 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
>  	return 0;
>  }
>  
> +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> +			    unsigned long vaddr, unsigned long *pfn,
> +			    bool write_fault)
> +{
> +	int ret;
> +
> +	ret = follow_pfn(vma, vaddr, pfn);
> +	if (ret) {
> +		bool unlocked = false;
> +
> +		ret = fixup_user_fault(NULL, mm, vaddr,
> +				       FAULT_FLAG_REMOTE |
> +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> +				       &unlocked);
> +		if (unlocked)
> +			return -EAGAIN;
> +
> +		if (ret)
> +			return ret;
> +
> +		ret = follow_pfn(vma, vaddr, pfn);
> +	}
> +
> +	return ret;
> +}
> +
>  static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  			 int prot, unsigned long *pfn)
>  {
> @@ -339,12 +365,16 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  
>  	vaddr = untagged_addr(vaddr);
>  
> +retry:
>  	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
>  
>  	if (vma && vma->vm_flags & VM_PFNMAP) {
> -		if (!follow_pfn(vma, vaddr, pfn) &&
> -		    is_invalid_reserved_pfn(*pfn))
> -			ret = 0;
> +		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
> +		if (ret == -EAGAIN)
> +			goto retry;
> +
> +		if (!ret && !is_invalid_reserved_pfn(*pfn))
> +			ret = -EFAULT;

I suggest checking vma->vm_ops == &vfio_pci_mmap_ops and adding a
comment that this is racy and needs to be fixed up. The ops check
makes this only used by other vfio bars and should prevent some
abuses of this hacky thing

However, I wonder if this chould just link itself into the
vma->private data so that when the vfio that owns the bar goes away,
so does the iommu mapping?

I feel like this patch set is not complete unless it also handles the
shootdown of this path too?

Jason
