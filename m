Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39CD12A2AA
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 16:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLXPIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 10:08:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726183AbfLXPIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 10:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577200120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r2IqWszqhiaODJ3VSTJIKJm1d3UZt69T2PAl2fGiph0=;
        b=dCsd8qC819jhAL1Yi2zH/NWx1iJfmbL4SLb7Y+4wGappT9Pnfx/0p1yV2Cco6YKtsPqMO9
        zmQMKtIxH4nrp/ptjCI5XAfE5gW+iSavJ8uJ4VTBfi/pUf4HrwqG+qvgQfaugg6GNFRTUY
        EpibjTv8mPpqV0sx8osY7/Yjqlsiw4I=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-rKz54ZXCOG6tQGxrYDLcfg-1; Tue, 24 Dec 2019 10:08:39 -0500
X-MC-Unique: rKz54ZXCOG6tQGxrYDLcfg-1
Received: by mail-qt1-f198.google.com with SMTP id o18so13158886qtt.19
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2019 07:08:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r2IqWszqhiaODJ3VSTJIKJm1d3UZt69T2PAl2fGiph0=;
        b=LgiCqITkfH6oPtPTBqknlG5+9sxOQ4HRu4pdm1HxXwFpBtguEsOvIjEb529m5Z4I7y
         oCGjgAuLPDUUgLXDjzJI4g8xmoqmQauFD+lRjQNCMQowZ/LEQaCYhCB4C2Aj0flHQNW5
         nvW5r2kpuETJqEBix+vQxXEHeAeV5iwleONRWObUn20fK3k0cT6FSbrSglUZs7zenuu7
         RsKPLfTqxSf0NShQbR2xv8WOnylTUYwdNRPt0H/tGmkCVUFEeVgiZRmTWMTt05NhTFjE
         2cghDbrCnSh5QTwStvDAD8DplgR8GA5S8f2wSzRXZD5qCswgKxmgtx5CvFLZ4qUqmSLS
         DetA==
X-Gm-Message-State: APjAAAV7g2XaEDLOF6344JPyQl96bCDD0ESIraLfQj7VWDaWQ8X5NQdA
        FZlTL+OvPPanrmb+EsQJiXm2ZqUs/7xiGYBqqlGTAVTrLsiX6xJ0SodilEtVH7E2uOjiOsuRvzl
        Cl98Hebm5ko/t
X-Received: by 2002:ac8:42de:: with SMTP id g30mr27065633qtm.195.1577200118514;
        Tue, 24 Dec 2019 07:08:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqyFu6dsLYutcPXeCiApv9BVecPqD+r6LYYcjSds8RWHPY/3Rv3Dum8c+BDHsXrVwsDy9MU9Rg==
X-Received: by 2002:ac8:42de:: with SMTP id g30mr27065614qtm.195.1577200118273;
        Tue, 24 Dec 2019 07:08:38 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id r6sm7374000qtm.63.2019.12.24.07.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 07:08:37 -0800 (PST)
Date:   Tue, 24 Dec 2019 10:08:36 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty
 memory tracking
Message-ID: <20191224150836.GB3023@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com>
 <5b341dce-6497-ada4-a77e-2bc5af2c53ab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5b341dce-6497-ada4-a77e-2bc5af2c53ab@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 24, 2019 at 02:16:04PM +0800, Jason Wang wrote:
> > +struct kvm_dirty_ring {
> > +	u32 dirty_index;
> 
> 
> Does this always equal to indices->avail_index?

Yes, but here we keep dirty_index as the internal one, so we never
need to worry about illegal userspace writes to avail_index (then we
never read it from kernel).

> 
> 
> > +	u32 reset_index;
> > +	u32 size;
> > +	u32 soft_limit;
> > +	struct kvm_dirty_gfn *dirty_gfns;
> > +	struct kvm_dirty_ring_indices *indices;
> 
> 
> Any reason to keep dirty gfns and indices in different places? I guess it is
> because you want to map dirty_gfns as readonly page but I couldn't find such
> codes...

That's a good point!  We should actually map the dirty gfns as read
only.  I've added the check, something like this:

static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
{
	struct kvm_vcpu *vcpu = file->private_data;
	unsigned long pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;

	/* If to map any writable page within dirty ring, fail it */
	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
	    vma->vm_flags & VM_WRITE)
		return -EINVAL;

	vma->vm_ops = &kvm_vcpu_vm_ops;
	return 0;
}

I also changed the test code to cover this case.

[...]

> > +struct kvm_dirty_ring_indices {
> > +	__u32 avail_index; /* set by kernel */
> > +	__u32 fetch_index; /* set by userspace */
> 
> 
> Is this better to make those two cacheline aligned?

Yes, Paolo should have mentioned that but I must have missed it!  I
hope I didn't miss anything else.

[...]

> > +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > +{
> > +	u32 cur_slot, next_slot;
> > +	u64 cur_offset, next_offset;
> > +	unsigned long mask;
> > +	u32 fetch;
> > +	int count = 0;
> > +	struct kvm_dirty_gfn *entry;
> > +	struct kvm_dirty_ring_indices *indices = ring->indices;
> > +	bool first_round = true;
> > +
> > +	fetch = READ_ONCE(indices->fetch_index);
> > +
> > +	/*
> > +	 * Note that fetch_index is written by the userspace, which
> > +	 * should not be trusted.  If this happens, then it's probably
> > +	 * that the userspace has written a wrong fetch_index.
> > +	 */
> > +	if (fetch - ring->reset_index > ring->size)
> > +		return -EINVAL;
> > +
> > +	if (fetch == ring->reset_index)
> > +		return 0;
> > +
> > +	/* This is only needed to make compilers happy */
> > +	cur_slot = cur_offset = mask = 0;
> > +	while (ring->reset_index != fetch) {
> > +		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > +		next_slot = READ_ONCE(entry->slot);
> > +		next_offset = READ_ONCE(entry->offset);
> > +		ring->reset_index++;
> > +		count++;
> > +		/*
> > +		 * Try to coalesce the reset operations when the guest is
> > +		 * scanning pages in the same slot.
> > +		 */
> > +		if (!first_round && next_slot == cur_slot) {
> 
> 
> initialize cur_slot to -1 then we can drop first_round here?

cur_slot is unsigned.  We can force cur_slot to be s64 but maybe we
can also simply keep the first_round to be clear from its name.

[...]

> > +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> > +{
> > +	struct kvm_dirty_gfn *entry;
> > +	struct kvm_dirty_ring_indices *indices = ring->indices;
> > +
> > +	/*
> > +	 * Note: here we will start waiting even soft full, because we
> > +	 * can't risk making it completely full, since vcpu0 could use
> > +	 * it right after us and if vcpu0 context gets full it could
> > +	 * deadlock if wait with mmu_lock held.
> > +	 */
> > +	if (kvm_get_running_vcpu() == NULL &&
> > +	    kvm_dirty_ring_soft_full(ring))
> > +		return -EBUSY;
> > +
> > +	/* It will never gets completely full when with a vcpu context */
> > +	WARN_ON_ONCE(kvm_dirty_ring_full(ring));
> > +
> > +	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> > +	entry->slot = slot;
> > +	entry->offset = offset;
> > +	smp_wmb();
> 
> 
> Better to add comment to explain this barrier. E.g pairing.

Will do.

> 
> 
> > +	ring->dirty_index++;
> > +	WRITE_ONCE(indices->avail_index, ring->dirty_index);
> 
> 
> Is WRITE_ONCE() a must here?

I think not, but seems to be clearer that we're publishing something
explicilty to userspace.  Since asked, I'm actually curious on whether
immediate memory writes like this could start to affect perf from any
of your previous perf works?

Thanks,

-- 
Peter Xu

