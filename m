Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F68218DB65
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCTW6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:58:14 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58655 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgCTW6N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 18:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584745092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UNjVT/x9G5I9C0c9EGviEToxc1QrdxoKplmLqUKbfGo=;
        b=faT5+QYLoFQIiCZMDOh88wPvdsh6xUbhEZni4+S5wrwn94efKJKdF1777di1gBRWbU6uaO
        /Leoes5Uu8lDd9naEUFB65cwOYUNkgtx4MMdUM8Pa8lD0jngsf18zXL1b6rkeqqHD3VbY/
        SUS/IXTJtuKKh9wFyOi95hLSAgvvwFM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-7HatZ6cpOoCEM75s5TOrKQ-1; Fri, 20 Mar 2020 18:58:10 -0400
X-MC-Unique: 7HatZ6cpOoCEM75s5TOrKQ-1
Received: by mail-wr1-f69.google.com with SMTP id t4so3361627wrv.9
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 15:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UNjVT/x9G5I9C0c9EGviEToxc1QrdxoKplmLqUKbfGo=;
        b=ADotUeyx3mxWwOYab9g0f0xYsQNtHD7UEr1Y9Yo8YRjPefedSZ0xcqPLE8hWSqb7QR
         J8z/ch7YTYFpS/4n0woeOUzydjF7FOVXR6L5vAkRqTyed6QTYiFO34LO+LIloskVemz0
         SXXMqi7BY79zfLTKjCYtnYTDyXLOucL1t/B4izCM3ey3RLZ/yGmo0hhF67Xm/1Oy9g6z
         pENcJFiBWbqZB6TRvlB0HAVnB6jrEmPkJLAXyi8qAwsBmevlO7THJ9LAzOBrLWEchtw7
         ji2SyNxTk+HNGFisZOAwUgdXGc2CzyAF1RKafKP0jCyZ6JKG8VvW2g4zMLifHkNGqPy+
         9SRQ==
X-Gm-Message-State: ANhLgQ32oCLYa8/X5DtvnKSTI2647I/rT/K0mzZe7qaJPf2XUZ1whGgP
        6oFdiWzxX7wdYbiJZJGsnQ2Xv56YIXQzD6bWEC2ZGJXagxhgt5woxX/7nrzNgBkI1DLPmqHKdQu
        bkLxoycuyKdTQ
X-Received: by 2002:a7b:cc8a:: with SMTP id p10mr12696826wma.10.1584745089252;
        Fri, 20 Mar 2020 15:58:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuHLC6+KmHNHTPhWrKmv7yuw1D4Pq5T48cCJ1EJzxrzPMBQ/2IYPrYlIUUYZKTyJ0DiF/1aLQ==
X-Received: by 2002:a7b:cc8a:: with SMTP id p10mr12696772wma.10.1584745088240;
        Fri, 20 Mar 2020 15:58:08 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id z188sm7594238wme.46.2020.03.20.15.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 15:58:07 -0700 (PDT)
Date:   Fri, 20 Mar 2020 18:58:02 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 1/7] KVM: Fix out of range accesses to memslots
Message-ID: <20200320225802.GH127076@xz-x1>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-2-sean.j.christopherson@intel.com>
 <20200320221708.GF127076@xz-x1>
 <20200320224041.GB3866@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200320224041.GB3866@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 03:40:41PM -0700, Sean Christopherson wrote:
> On Fri, Mar 20, 2020 at 06:17:08PM -0400, Peter Xu wrote:
> > On Fri, Mar 20, 2020 at 01:55:40PM -0700, Sean Christopherson wrote:
> > > Reset the LRU slot if it becomes invalid when deleting a memslot to fix
> > > an out-of-bounds/use-after-free access when searching through memslots.
> > > 
> > > Explicitly check for there being no used slots in search_memslots(), and
> > > in the caller of s390's approximation variant.
> > > 
> > > Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")
> > > Reported-by: Qian Cai <cai@lca.pw>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/s390/kvm/kvm-s390.c | 3 +++
> > >  include/linux/kvm_host.h | 3 +++
> > >  virt/kvm/kvm_main.c      | 3 +++
> > >  3 files changed, 9 insertions(+)
> > > 
> > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > index 807ed6d722dd..cb15fdda1fee 100644
> > > --- a/arch/s390/kvm/kvm-s390.c
> > > +++ b/arch/s390/kvm/kvm-s390.c
> > > @@ -2002,6 +2002,9 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
> > >  	struct kvm_memslots *slots = kvm_memslots(kvm);
> > >  	struct kvm_memory_slot *ms;
> > >  
> > > +	if (unlikely(!slots->used_slots))
> > > +		return 0;
> > > +
> > >  	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
> > >  	ms = gfn_to_memslot(kvm, cur_gfn);
> > >  	args->count = 0;
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 35bc52e187a2..b19dee4ed7d9 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -1032,6 +1032,9 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
> > >  	int slot = atomic_read(&slots->lru_slot);
> > >  	struct kvm_memory_slot *memslots = slots->memslots;
> > >  
> > > +	if (unlikely(!slots->used_slots))
> > > +		return NULL;
> > > +
> > >  	if (gfn >= memslots[slot].base_gfn &&
> > >  	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
> > >  		return &memslots[slot];
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 28eae681859f..f744bc603c53 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -882,6 +882,9 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
> > >  
> > >  	slots->used_slots--;
> > >  
> > > +	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
> > > +		atomic_set(&slots->lru_slot, 0);
> > 
> > Nit: could we drop the atomic ops?  The "slots" is still only used in
> > the current thread before the rcu assignment, so iirc it's fine (and
> > RCU assignment should have a mem barrier when needed anyway).
> 
> No, atomic_t wraps an int inside a struct to prevent direct usage, e.g.
> 
> virt/kvm/kvm_main.c: In function ‘kvm_memslot_delete’:
> virt/kvm/kvm_main.c:885:22: error: invalid operands to binary >= (have ‘atomic_t {aka struct <anonymous>}’ and ‘int’)
>   if (slots->lru_slot >= slots->used_slots)
>                       ^
> virt/kvm/kvm_main.c:886:19: error: incompatible types when assigning to type ‘atomic_t {aka struct <anonymous>}’ from type ‘int’
>    slots->lru_slot = 0;
> 
> 
> Buy yeah, the compiler barrier associated with atomic_read() isn't
> necessary.

Oops, sorry. I was obviously thinking about QEMU's atomic helpers.

> 
> > I thought resetting lru_slot to zero would be good enough when
> > duplicating the slots... however if we want to do finer grained reset,
> > maybe even better to reset also those invalidated ones (since we know
> > this information)?
> > 
> >    	if (slots->lru_slot >= slots->id_to_index[memslot->id])
> >    		slots->lru_slot = 0;
> 
> I'd prefer to go with the more obviously correct version.  This code will
> rarely trigger, e.g. larger slots have lower indices and are more likely to
> be the LRU (by virtue of being the biggest), and dynamic memslot deletion
> is usually for relatively small ranges that are being remapped by the guest.

IMHO the more obvious correct version could be unconditionally setting
lru_slot to something invalid (e.g. -1) in kvm_dup_memslots(), then in
the two search_memslots() skip the cache if lru_slot is invalid.
That's IMHO easier to understand than the "!slots->used_slots" checks.
But I've no strong opinion.

Thanks,

-- 
Peter Xu

