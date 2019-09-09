Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0028ADC2D
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388393AbfIIPfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 11:35:36 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34289 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbfIIPff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 11:35:35 -0400
Received: by mail-ed1-f66.google.com with SMTP id c20so4353984eds.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 08:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MTFOT5bdM6X72YjVAZIbcsExbwxE+XqxokMEIsUljgM=;
        b=wHAxZhcK+gVPgAgJF9PbCYhlVGAsrovsuFXW5bqK8U3w5EFk2zZCX1PS4KAWztk+tV
         aZPQUgB2szFFTowwsoVdApg2W0IWLJC/PYf3C5DTflhYhuY+iO5/3mwiha3DgnVu+Gnx
         v7L3al5qh8zdC+vfxTXAPiBMUhFc8k3n4NzOwwxptdbzgwK+T4XW/yezGIalQ9lX0P7U
         zpPoMANq/LhN3bwqGkzdrMNI2S7izV0couusSwfyWmSfxsP24uBJ1IzeHkipd6qvJrDP
         qP3aTxM2VI4aaPYi2lI4N2kG0/wn8MF3cHPJGzk9gZILa1VAr8ILUgrz4z2kJLX/t/vz
         1Hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MTFOT5bdM6X72YjVAZIbcsExbwxE+XqxokMEIsUljgM=;
        b=L9dtzoCT9VmPCsIedTrdwlna7VCsY3Anh0IviQX+QmzzFuS6uXyraQlnmZiVTnprbT
         GqfKLOa7QyIGb7WFsLZbWykn8hiXH0QY+/awLQCMboxlofS9ti5ecM2haeLRehIzvUnk
         k9N5cM3q+4R8fk/cI+jMp4tAuOTVPQtGVo62xabOXsix+/lSqO23A+GJmJo4jWdpWTuC
         sSzyhdPJvZKM9xr4ApauC4a/vgi11eDmbZzLzNq2MKMR0hgCnVVxSR6cuHJ9I6I+DkCc
         sA2uyaQ85eDxvm6CElA4FVUKQ94nlp6dLCitwwca/6pnZQQCY/CNvsAfu5Vmo6vnQbis
         h5fw==
X-Gm-Message-State: APjAAAWqYELQCOUMsErsqXnzJ3DKfEXseuX/xHgzdyQOYGJLL6grYtZ2
        2xGsAwbR7DpgEv2LmnfmTgcruA==
X-Google-Smtp-Source: APXvYqwJ7k9v4XDLW5K97XhqdK5YLrM7D4qHSrwZ/QMa9DMyngci97EGxAlQTwRoMZkMga2tS9GZKw==
X-Received: by 2002:a50:d084:: with SMTP id v4mr25600401edd.48.1568043331860;
        Mon, 09 Sep 2019 08:35:31 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j5sm3017703edj.62.2019.09.09.08.35.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 08:35:31 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id CD6C71003B5; Mon,  9 Sep 2019 18:35:29 +0300 (+03)
Date:   Mon, 9 Sep 2019 18:35:29 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 2/8] mm: Adjust shuffle code to allow for future
 coalescing
Message-ID: <20190909153529.3crs74uraos27ffh@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172520.10910.83100.stgit@localhost.localdomain>
 <20190909094700.bbslsxpuwvxmodal@box>
 <22a896255cba877cf820f552667e1bc14268fa20.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22a896255cba877cf820f552667e1bc14268fa20.camel@linux.intel.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 09, 2019 at 08:22:11AM -0700, Alexander Duyck wrote:
> > > +	area = &zone->free_area[order];
> > > +	if (is_shuffle_order(order) ? shuffle_pick_tail() :
> > > +	    buddy_merge_likely(pfn, buddy_pfn, page, order))
> > 
> > Too loaded condition to my taste. Maybe
> > 
> > 	bool to_tail;
> > 	...
> > 	if (is_shuffle_order(order))
> > 		to_tail = shuffle_pick_tail();
> > 	else if (buddy_merge_likely(pfn, buddy_pfn, page, order))
> > 		to_tail = true;
> > 	else
> > 		to_tail = false;
> 
> I can do that, although I would tweak this slightly and do something more
> like:
>         if (is_shuffle_order(order))
>                 to_tail = shuffle_pick_tail();
>         else
>                 to_tail = buddy+_merge_likely(pfn, buddy_pfn, page, order);

Okay. Looks fine.

> > 	if (to_tail)
> > 		add_to_free_area_tail(page, area, migratetype);
> > 	else
> > 		add_to_free_area(page, area, migratetype);
> > 
> > > +		add_to_free_area_tail(page, area, migratetype);
> > >  	else
> > > -		add_to_free_area(page, &zone->free_area[order], migratetype);
> > > -
> > > +		add_to_free_area(page, area, migratetype);
> > >  }
> > >  
> > >  /*
> > > diff --git a/mm/shuffle.c b/mm/shuffle.c
> > > index 9ba542ecf335..345cb4347455 100644
> > > --- a/mm/shuffle.c
> > > +++ b/mm/shuffle.c
> > > @@ -4,7 +4,6 @@
> > >  #include <linux/mm.h>
> > >  #include <linux/init.h>
> > >  #include <linux/mmzone.h>
> > > -#include <linux/random.h>
> > >  #include <linux/moduleparam.h>
> > >  #include "internal.h"
> > >  #include "shuffle.h"
> > 
> > Why do you move #include <linux/random.h> from .c to .h?
> > It's not obvious to me.
> 
> Because I had originally put the shuffle logic in an inline function. I
> can undo that now as I when back to doing the randomness in the .c
> sometime v5 I believe.

Yes, please. It's needless change now.

> 
> > > @@ -190,8 +189,7 @@ struct batched_bit_entropy {
> > >  
> > >  static DEFINE_PER_CPU(struct batched_bit_entropy, batched_entropy_bool);
> > >  
> > > -void add_to_free_area_random(struct page *page, struct free_area *area,
> > > -		int migratetype)
> > > +bool __shuffle_pick_tail(void)
> > >  {
> > >  	struct batched_bit_entropy *batch;
> > >  	unsigned long entropy;
> > > @@ -213,8 +211,5 @@ void add_to_free_area_random(struct page *page, struct free_area *area,
> > >  	batch->position = position;
> > >  	entropy = batch->entropy_bool;
> > >  
> > > -	if (1ul & (entropy >> position))
> > > -		add_to_free_area(page, area, migratetype);
> > > -	else
> > > -		add_to_free_area_tail(page, area, migratetype);
> > > +	return 1ul & (entropy >> position);
> > >  }
> > > diff --git a/mm/shuffle.h b/mm/shuffle.h
> > > index 777a257a0d2f..0723eb97f22f 100644
> > > --- a/mm/shuffle.h
> > > +++ b/mm/shuffle.h
> > > @@ -3,6 +3,7 @@
> > >  #ifndef _MM_SHUFFLE_H
> > >  #define _MM_SHUFFLE_H
> > >  #include <linux/jump_label.h>
> > > +#include <linux/random.h>
> > >  
> > >  /*
> > >   * SHUFFLE_ENABLE is called from the command line enabling path, or by
> > > @@ -22,6 +23,7 @@ enum mm_shuffle_ctl {
> > >  DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
> > >  extern void page_alloc_shuffle(enum mm_shuffle_ctl ctl);
> > >  extern void __shuffle_free_memory(pg_data_t *pgdat);
> > > +extern bool __shuffle_pick_tail(void);
> > >  static inline void shuffle_free_memory(pg_data_t *pgdat)
> > >  {
> > >  	if (!static_branch_unlikely(&page_alloc_shuffle_key))
> > > @@ -43,6 +45,11 @@ static inline bool is_shuffle_order(int order)
> > >  		return false;
> > >  	return order >= SHUFFLE_ORDER;
> > >  }
> > > +
> > > +static inline bool shuffle_pick_tail(void)
> > > +{
> > > +	return __shuffle_pick_tail();
> > > +}
> > 
> > I don't see a reason in __shuffle_pick_tail() existing if you call it
> > unconditionally.
> 
> That is for compilation purposes. The function is not used in the
> shuffle_pick_tail below that always returns false.

Wouldn't it be the same if you rename __shuffle_pick_tail() to
shuffle_pick_tail() and put its declaration under the same #ifdef?

-- 
 Kirill A. Shutemov
