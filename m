Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662723A6890
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhFNN6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:58:37 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:46803 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbhFNN6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 09:58:36 -0400
Received: by mail-lf1-f44.google.com with SMTP id m21so21198817lfg.13;
        Mon, 14 Jun 2021 06:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rfiTiAsaGwFfBsojv2IuZ/vi3R4Qmqml2BB/SXTuMxk=;
        b=ntDdfnb4AnV08fR6j4kCDhcqslMOtURBHNun1Y+WyDgZJhgLmTDuAqILNkJfI2+2nh
         Z7k7auT3eWIB4Jkjf7pwctPWx+D043MYJXHztIJf3S9+o8uSmaL9PTnrBvDgmatelZep
         qWPCqEpXZxWe9PDuaBdlbzbDbdCzldc+klBsh7EyxYU+LKvnba5CHJw6xcUp3A7Laf7e
         bHdqlOdkA4TI5X9vIjFIGHRGi+s3zdyCBrCWLVOl6+ETrOE60ssgwi3TG289hdrqtNLI
         tgmkmHt3z7ulRdznsybFVZu0WI2BNMot973+5C/4eO8Rcf81mys6ZrT6bWmt672FgwXh
         6R2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rfiTiAsaGwFfBsojv2IuZ/vi3R4Qmqml2BB/SXTuMxk=;
        b=lodAjoN1AgmYIkJGJAiDeTxmX5cC1uZsgZU0C1gnBY662wCzGKUJ/bZkq2Rkx9yPYN
         +fvfuM0/sTI5GET+d2fR8kHYhRBN7S9AR1TrSyGgz7G+YJjhJNoEo1Nz3/gRZ/SNwDvW
         eMCeNoIxafzdYQTwpxYVq49ivCGTovoFgRspbZU1usbXplmllZ70+UZd+HJkYkf64Idr
         QX5atjv6XMX7J4paNj7/XMLepYX/1V/eAMX1tPsVfxHLP0USHkjbz4D4hE3Qkx7ga1R1
         rajLxaGC1xSM3WZz5kLihzm5IzXb8IZOpLVRIWv01/frZs66cPMqnuXJ071bz67l2obi
         YSHw==
X-Gm-Message-State: AOAM532AOBfTxOhlBDp9n6J5iWdts5xRXEGWP0W2t4aCB2Rbj8+EJqd3
        6CESzFCbfIKSbLQLdejEU1Q=
X-Google-Smtp-Source: ABdhPJwcoyNr5z2508ee5VPUu2JVpFWe38lsHh000t9UPgmNgU01qmagswsQ//h6nHGZIuAKUQGMUA==
X-Received: by 2002:ac2:44c9:: with SMTP id d9mr12317154lfm.290.1623678932767;
        Mon, 14 Jun 2021 06:55:32 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id y24sm505239ljj.16.2021.06.14.06.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:55:32 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Mon, 14 Jun 2021 15:55:30 +0200
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 1/2] mm/vmalloc: add vmalloc_no_huge
Message-ID: <20210614135530.GA1858@pc638.lan>
References: <20210614132357.10202-1-imbrenda@linux.ibm.com>
 <20210614132357.10202-2-imbrenda@linux.ibm.com>
 <8f24292e-e8c9-9b9b-0429-2ac984a01611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f24292e-e8c9-9b9b-0429-2ac984a01611@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On 14.06.21 15:23, Claudio Imbrenda wrote:
> > Commit 121e6f3258fe3 ("mm/vmalloc: hugepage vmalloc mappings") added
> > support for hugepage vmalloc mappings, it also added the flag
> > VM_NO_HUGE_VMAP for __vmalloc_node_range to request the allocation to
> > be performed with 0-order non-huge pages.  This flag is not accessible
> > when calling vmalloc, the only option is to call directly
> > __vmalloc_node_range, which is not exported.
> > 
> > This means that a module can't vmalloc memory with small pages.
> > 
> > Case in point: KVM on s390x needs to vmalloc a large area, and it needs
> > to be mapped with non-huge pages, because of a hardware limitation.
> > 
> > This patch adds the function vmalloc_no_huge, which works like vmalloc,
> > but it is guaranteed to always back the mapping using small pages. This
> > new function is exported, therefore it is usable by modules.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > Acked-by: Nicholas Piggin <npiggin@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Nicholas Piggin <npiggin@gmail.com>
> > Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > ---
> >   include/linux/vmalloc.h |  1 +
> >   mm/vmalloc.c            | 16 ++++++++++++++++
> >   2 files changed, 17 insertions(+)
> > 
> > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > index 4d668abb6391..bfaaf0b6fa76 100644
> > --- a/include/linux/vmalloc.h
> > +++ b/include/linux/vmalloc.h
> > @@ -135,6 +135,7 @@ extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
> >   			const void *caller);
> >   void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
> >   		int node, const void *caller);
> > +void *vmalloc_no_huge(unsigned long size);
> >   extern void vfree(const void *addr);
> >   extern void vfree_atomic(const void *addr);
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index a13ac524f6ff..296a2fcc3fbe 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -2998,6 +2998,22 @@ void *vmalloc(unsigned long size)
> >   }
> >   EXPORT_SYMBOL(vmalloc);
> > +/**
> > + * vmalloc_no_huge - allocate virtually contiguous memory using small pages
> > + * @size:    allocation size
> > + *
> > + * Allocate enough non-huge pages to cover @size from the page level
> > + * allocator and map them into contiguous kernel virtual space.
> > + *
> > + * Return: pointer to the allocated memory or %NULL on error
> > + */
> > +void *vmalloc_no_huge(unsigned long size)
> > +{
> > +	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END, GFP_KERNEL, PAGE_KERNEL,
> > +				    VM_NO_HUGE_VMAP, NUMA_NO_NODE, __builtin_return_address(0));
> > +}
> > +EXPORT_SYMBOL(vmalloc_no_huge);
> > +
> >   /**
> >    * vzalloc - allocate virtually contiguous memory with zero fill
> >    * @size:    allocation size
> > 
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Vlad Rezki
