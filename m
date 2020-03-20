Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D718DAF0
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCTWRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:17:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25516 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgCTWRT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 18:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584742637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u8GNq+OP92R4iBcY079mAsYo3DdHqGBvboHuDfaqdes=;
        b=AeRQ9I0pBrN4bk4/JHK+zkA6Ug6Vfk5+x5iLnFEYeYyZMkusmbPbhOU/lxv36nlNjFXC5D
        WHpgBcH5qFrIfGW35qnQlThkLMTkFlWujo+UmQHqg1UIDY/Ne3oIoTLv21aThl8cRb3+dd
        UdErPwoeE2itdgKpVe5bYmvJVTrHD1A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-pZgs-PwKOTK3t_oZi0VkhQ-1; Fri, 20 Mar 2020 18:17:16 -0400
X-MC-Unique: pZgs-PwKOTK3t_oZi0VkhQ-1
Received: by mail-wm1-f71.google.com with SMTP id h203so2174081wme.2
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 15:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u8GNq+OP92R4iBcY079mAsYo3DdHqGBvboHuDfaqdes=;
        b=IDQUv4WSOdbRzEnARb+y0LD+yhjl/SevdrcyPCDjnD31S3Ob5Eq5b8sN55bRfp8wYT
         TaPvxPcaHX5YRDQgduqT0PO6ItrFyQ86QFq4LAftkYYWCqvsJ1uPV8xINDifTRRjAbsh
         4Cd+3Yh2sbCsfvLsW5xsKD1HpZvssFI6CKDV0kuzSCkyTzj1VN6/LCixvcg8vt5P3RGd
         9qEP/4vpVpZrS03ra8BYWwTXtDoeKTTwcQA+vLScQm5PPiM24SsXgzq6CUQfT3R7oxaO
         48noYYzHmanBRBTtq/jlJVqRp93rC/sq6ueDpxnPz52luJs/1CYvcSCMChYNV/aSmZ7k
         Y7wA==
X-Gm-Message-State: ANhLgQ0Ujt2GMAqdhGS08nq6kQAdUP5vW+V+RsIhxfWQmarAS2TdIlZ7
        KpDTIQkV5lbftXArBB1FniNbF6tNkqrsFtzNToy5sbrefo2EiMdXVB0lZJmWIyHqS+cxwfQ/0jf
        ckW8fui9eJjoW
X-Received: by 2002:a5d:5290:: with SMTP id c16mr13036224wrv.235.1584742635067;
        Fri, 20 Mar 2020 15:17:15 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsHAj/sDvf+2yJCWb0vwNzdthKf09Zc1TXGWHrd55TefkcTAIKJq+rWF7JAa4y+Rzn60P8yYQ==
X-Received: by 2002:a5d:5290:: with SMTP id c16mr13036200wrv.235.1584742634748;
        Fri, 20 Mar 2020 15:17:14 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id z188sm7454248wme.46.2020.03.20.15.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 15:17:14 -0700 (PDT)
Date:   Fri, 20 Mar 2020 18:17:08 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 1/7] KVM: Fix out of range accesses to memslots
Message-ID: <20200320221708.GF127076@xz-x1>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320205546.2396-2-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 01:55:40PM -0700, Sean Christopherson wrote:
> Reset the LRU slot if it becomes invalid when deleting a memslot to fix
> an out-of-bounds/use-after-free access when searching through memslots.
> 
> Explicitly check for there being no used slots in search_memslots(), and
> in the caller of s390's approximation variant.
> 
> Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")
> Reported-by: Qian Cai <cai@lca.pw>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 3 +++
>  include/linux/kvm_host.h | 3 +++
>  virt/kvm/kvm_main.c      | 3 +++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 807ed6d722dd..cb15fdda1fee 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2002,6 +2002,9 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
>  	struct kvm_memslots *slots = kvm_memslots(kvm);
>  	struct kvm_memory_slot *ms;
>  
> +	if (unlikely(!slots->used_slots))
> +		return 0;
> +
>  	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
>  	ms = gfn_to_memslot(kvm, cur_gfn);
>  	args->count = 0;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 35bc52e187a2..b19dee4ed7d9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1032,6 +1032,9 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
>  	int slot = atomic_read(&slots->lru_slot);
>  	struct kvm_memory_slot *memslots = slots->memslots;
>  
> +	if (unlikely(!slots->used_slots))
> +		return NULL;
> +
>  	if (gfn >= memslots[slot].base_gfn &&
>  	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
>  		return &memslots[slot];
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 28eae681859f..f744bc603c53 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -882,6 +882,9 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>  
>  	slots->used_slots--;
>  
> +	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
> +		atomic_set(&slots->lru_slot, 0);

Nit: could we drop the atomic ops?  The "slots" is still only used in
the current thread before the rcu assignment, so iirc it's fine (and
RCU assignment should have a mem barrier when needed anyway).

I thought resetting lru_slot to zero would be good enough when
duplicating the slots... however if we want to do finer grained reset,
maybe even better to reset also those invalidated ones (since we know
this information)?

   	if (slots->lru_slot >= slots->id_to_index[memslot->id])
   		slots->lru_slot = 0;
  
Thanks,

> +
>  	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
>  		mslots[i] = mslots[i + 1];
>  		slots->id_to_index[mslots[i].id] = i;
> -- 
> 2.24.1
> 

-- 
Peter Xu

