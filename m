Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE025136326
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgAIWSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:18:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45267 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725840AbgAIWSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 17:18:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578608314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6JmtSOJYmxM6pVQp9MRBbQsVDw9QXYHW6+VCBNr1xzY=;
        b=dzQnfLdi2FfBkByuWMwXgLSUFTJ/nFNq/8HfdtfuOJ9jPHBn8hpbu1AiIulqynFqS8J/hq
        S0By+SL9THMmyRgHwBYoYA7sCkALf8V1hq6vulwlurMGJflsKRJUcyj764/uaic3KkjI5Q
        eBMolnJCmpXS1IH2rSj9HmrO6wjDnrU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-nOnPrK6DNsqd1u__w4rf8g-1; Thu, 09 Jan 2020 17:18:33 -0500
X-MC-Unique: nOnPrK6DNsqd1u__w4rf8g-1
Received: by mail-qk1-f200.google.com with SMTP id a6so5135127qkl.7
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 14:18:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6JmtSOJYmxM6pVQp9MRBbQsVDw9QXYHW6+VCBNr1xzY=;
        b=Hxqaq63ZXhOVfnvvaHtZ80l3kw8WEeILxxNzENH0byoPaEN0BNz1Z7kLgsJTCE3kbP
         HFYjabJHZSHl4Q1irjtj308onxI8ZR8VDp2Ip0mYm3O+Up4SNoSITRILCJN9PYd0/lC9
         uRiv6+tTk0goCvXezuUriCmAJw8CMQi/WGeOeUmfYBZOZFjY4yIxRU6B6KW9VliEVTu5
         Y7eyZQJogxRlM0i4nMl5Y5EFRl34/qMSLb2fuDiywh1c88SQVfxnqn8XASyhsdPIiT8Z
         N5Ne7FrDPRXsfeeiwPggAxserYvE+rfi/knid2bLBGywTcFhzWQlnN//jEteg3DkA5is
         FFzQ==
X-Gm-Message-State: APjAAAW0Q2UaGpRsPfaZFA0H8RmYW8tKGgUe8VOn/W9ttr0xRbUlvnqO
        vsO18g3sNM8wfBPwvfgAoSgnCMJsV8ieRmIeFNUl2cclUyxXruvwfLgZgXWQEKeOSl21ITeUQ31
        PEhF7yPp+zWL8
X-Received: by 2002:ac8:220c:: with SMTP id o12mr10024363qto.134.1578608312501;
        Thu, 09 Jan 2020 14:18:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0xRAEn2JsH2IQ/vVWufPMooeKQXg1ICPyBQbbYBEIrRHYP7CEMJNLfl0IpFJXh1VTI9a1nw==
X-Received: by 2002:ac8:220c:: with SMTP id o12mr10024347qto.134.1578608312185;
        Thu, 09 Jan 2020 14:18:32 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id r12sm3695176qkm.94.2020.01.09.14.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 14:18:31 -0800 (PST)
Date:   Thu, 9 Jan 2020 17:18:24 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200109171154-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <20200109141634-mutt-send-email-mst@kernel.org>
 <20200109201916.GH36997@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109201916.GH36997@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 03:19:16PM -0500, Peter Xu wrote:
> > > while for virtio, both sides (hypervisor,
> > > and the guest driver) are trusted.
> > 
> > What gave you the impression guest is trusted in virtio?
> 
> Hmm... maybe when I know virtio can bypass vIOMMU as long as it
> doesn't provide IOMMU_PLATFORM flag? :)

If guest driver does not provide IOMMU_PLATFORM, and device does,
then negotiation fails.

> I think it's logical to trust a virtio guest kernel driver, could you
> guide me on what I've missed?


guest driver is assumed to be part of guest kernel. It can't
do anything kernel can't do anyway.

> > 
> > 
> > >  Above means we need to do these to
> > > change to the new design:
> > > 
> > >   - Allow the GFN array to be mapped as writable by userspace (so that
> > >     userspace can publish bit 2),
> > > 
> > >   - The userspace must be trusted to follow the design (just imagine
> > >     what if the userspace overwrites a GFN when it publishes bit 2
> > >     over a valid dirty gfn entry?  KVM could wrongly unprotect a page
> > >     for the guest...).
> > 
> > You mean protect, right?  So what?
> 
> Yes, I mean with that, more things are uncertain from userspace.  It
> seems easier to me that we restrict the userspace with one index.

Donnu how to treat vague statements like this.  You need to be specific
with threat models. Otherwise there's no way to tell whether code is
secure.

> > 
> > > While if we use the indices, we restrict the userspace to only be able
> > > to write to one index only (which is the reset_index).  That's all it
> > > can do to mess things up (and it could never as long as we properly
> > > validate the reset_index when read, which only happens during
> > > KVM_RESET_DIRTY_RINGS and is very rare).  From that pov, it seems the
> > > indices solution still has its benefits.
> > 
> > So if you mess up index how is this different?
> 
> We can't mess up much with that.  We simply check fetch_index (sorry I
> meant this when I said reset_index, anyway it's the only index that we
> expose to userspace) to make sure:
> 
>   reset_index <= fetch_index <= dirty_index
> 
> Otherwise we fail the ioctl.  With that, we're 100% safe.

safe from what? userspace can mess up guest memory trivially.
for example skip sending some memory or send junk.

> > 
> > I agree RO page kind of feels safer generally though.
> > 
> > I will have to re-read how does the ring works though,
> > my comments were based on the old assumption of mmaped
> > page with indices.
> 
> Yes, sorry again for a bad cover letter.
> 
> It's basically the same as before, just that we only have per-vcpu
> ring now, and the indices are exposed from kvm_run so we don't need
> the extra page, but we still expose that via mmap.

So that's why changelogs are useful.
Can you please write a changelog for this version so I don't
need to re-read all of it? Thanks!

> > 
> > 
> > 
> > > > 
> > > > 
> > > > 
> > > > >  The larger the ring buffer, the less
> > > > > +likely the ring is full and the VM is forced to exit to userspace. The
> > > > > +optimal size depends on the workload, but it is recommended that it be
> > > > > +at least 64 KiB (4096 entries).
> > > > 
> > > > Where's this number coming from? Given you have indices as well,
> > > > 4K size rings is likely to cause cache contention.
> > > 
> > > I think we've had some similar discussion in previous versions on the
> > > size of ring.  Again imho it's really something that may not have a
> > > direct clue as long as it's big enough (4K should be).
> > > 
> > > Regarding to the cache contention: could you explain more?
> > 
> > 4K is a whole cache way. 64K 16 ways.  If there's anything else is a hot
> > path then you are pushing everything out of cache.  To re-read how do
> > indices work so see whether an index is on hot path or not. If yes your
> > structure won't fit in L1 cache which is not great.
> 
> I'm not sure whether I get the point correct, but logically we
> shouldn't read the whole ring buffer as a whole, but only partly (just
> like when we say the ring shouldn't even reach soft-full).  Even if we
> read the whole ring, I don't see a difference here comparing to when
> we read a huge array of data (e.g. "char buf[65536]") in any program
> that covers 64K range - I don't see a good way to fix this but read
> the whole chunk in.  It seems to be common in programs where we have
> big dataset.
> 
> [...]
> 
> > > > > +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > > > > +{
> > > > > +	u32 cur_slot, next_slot;
> > > > > +	u64 cur_offset, next_offset;
> > > > > +	unsigned long mask;
> > > > > +	u32 fetch;
> > > > > +	int count = 0;
> > > > > +	struct kvm_dirty_gfn *entry;
> > > > > +	struct kvm_dirty_ring_indices *indices = ring->indices;
> > > > > +	bool first_round = true;
> > > > > +
> > > > > +	fetch = READ_ONCE(indices->fetch_index);
> > > > 
> > > > So this does not work if the data cache is virtually tagged.
> > > > Which to the best of my knowledge isn't the case on any
> > > > CPU kvm supports. However it might not stay being the
> > > > case forever. Worth at least commenting.
> > > 
> > > This is the read side.  IIUC even if with virtually tagged archs, we
> > > should do the flushing on the write side rather than the read side,
> > > and that should be enough?
> > 
> > No.
> > See e.g.  Documentation/core-api/cachetlb.rst
> > 
> >   ``void flush_dcache_page(struct page *page)``
> > 
> >         Any time the kernel writes to a page cache page, _OR_
> >         the kernel is about to read from a page cache page and
> >         user space shared/writable mappings of this page potentially
> >         exist, this routine is called.
> 
> But I don't understand why.  I feel like for such arch even the
> userspace must flush cache after publishing data onto shared memories,
> otherwise if the shared memory is between two userspace processes
> they'll get inconsistent state.  Then if with that, I'm confused on
> why the read side needs to flush it again.
> 
> > 
> > 
> > > Also, I believe this is the similar question that Jason has asked in
> > > V2.  Sorry I should mention this earlier, but I didn't address that in
> > > this series because if we need to do so we probably need to do it
> > > kvm-wise, rather than only in this series.
> > 
> > You need to document these things.
> > 
> > >  I feel like it's missing
> > > probably only because all existing KVM supported archs do not have
> > > virtual-tagged caches as you mentioned.
> > 
> > But is that a fact? ARM has such a variety of CPUs,
> > I can't really tell. Did you research this to make sure?
> 
> I didn't.  I only tried to find all callers of flush_dcache_page()
> through the whole Linux tree and I cannot see any kvm related code.
> To make this simple, let me address the dcache flushing issue in the
> next post.
> 
> Thanks,
> 
> -- 
> Peter Xu

