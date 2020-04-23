Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D691B5F03
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgDWPXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:23:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29196 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729008AbgDWPXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587655380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7iFOYOmmS/LbCdQbSLcBAQAHAEAS8jTJdGBKjzk/kY=;
        b=ROYvWIGT5tb9LHfpXBCQ26Xh5Mme3qkSRQdSb7VO5K6yoaMIQPaAnZaJfkX49QgvQ5wLTq
        DN/jTv00HOYMxidu5pPfIORdLodgz4Ev0EnxFFZAPkHlsZR8Ni+xU6hEQ4oWXcrk0R1ZQh
        5rb9YzI6VV6fqD/Xhno9lNTRsLIcPT8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-zTzQzN_9OraxZNejWWkhIw-1; Thu, 23 Apr 2020 11:22:57 -0400
X-MC-Unique: zTzQzN_9OraxZNejWWkhIw-1
Received: by mail-qk1-f198.google.com with SMTP id h186so7028180qkc.22
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i7iFOYOmmS/LbCdQbSLcBAQAHAEAS8jTJdGBKjzk/kY=;
        b=cUFgfuXp3yQs3dGmA561YqFIzsxcTBE2xKhBwbVzRraOqXvvChyggamKmZhLvDnoZ+
         SrCbNWftg3bzsmxfPwQRGnskJaT2ddpRWdE2TylCiGCmN4vDUUI7wrv8wAetzL5Z3bwf
         4NTt6hDhTWqGd35danjghomLjVL/yI93dfSyxrz8u2S3d7Nt2FDjXW2x7iTLgD47xyaj
         eOla3re4N68eRBS8he9MvEesd4GiZwhIHDMUsMM4iE2yOvXXsRiwxdj8/ae6p+omuC3A
         J97bFHGU9HQtMcNkIgXRuGO+9lHNDunVnh26/JCQI6l1mTm0N8jGfvdE4ZASYz6nQWkx
         Di3g==
X-Gm-Message-State: AGi0PuZHsEVSReEILOQ3gDlGG/515YXG4TuzRr/nO/4q78Gyjt3JEORo
        HY1ZhHZoUTS0LzTCB9jaD96r8IhPWIZ6dP5PNOM7jS0o0j407Xr+/NhcczuqUS5GN7mxj3bsU00
        Yk4/uJXK3i60m
X-Received: by 2002:ac8:6753:: with SMTP id n19mr4564962qtp.353.1587655376581;
        Thu, 23 Apr 2020 08:22:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ66H90IP6JPiDFyLFxwW3u6P5r9glVplzra9UyPP1kFhsPvhNCJkQNjXboygVCyzIm3bEeHw==
X-Received: by 2002:ac8:6753:: with SMTP id n19mr4564920qtp.353.1587655376185;
        Thu, 23 Apr 2020 08:22:56 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w27sm1923604qtc.18.2020.04.23.08.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 08:22:55 -0700 (PDT)
Date:   Thu, 23 Apr 2020 11:22:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 00/14] KVM: Dirty ring interface
Message-ID: <20200423152253.GB3596@xz-x1>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200422185155.GA3596@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D877A3B@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D877A3B@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 06:28:43AM +0000, Tian, Kevin wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Thursday, April 23, 2020 2:52 AM
> > 
> > Hi,
> > 
> > TL;DR: I'm thinking whether we should record pure GPA/GFN instead of
> > (slot_id,
> > slot_offset) tuple for dirty pages in kvm dirty ring to unbind kvm_dirty_gfn
> > with memslots.
> > 
> > (A slightly longer version starts...)
> > 
> > The problem is that binding dirty tracking operations to KVM memslots is a
> > restriction that needs synchronization to memslot changes, which further
> > needs
> > synchronization across all the vcpus because they're the consumers of
> > memslots.
> > E.g., when we remove a memory slot, we need to flush all the dirty bits
> > correctly before we do the removal of the memslot.  That's actually an
> > known
> > defect for QEMU/KVM [1] (I bet it could be a defect for many other
> > hypervisors...) right now with current dirty logging.  Meanwhile, even if we
> > fix it, that procedure is not scale at all, and error prone to dead locks.
> > 
> > Here memory removal is really an (still corner-cased but relatively) important
> > scenario to think about for dirty logging comparing to memory additions &
> > movings.  Because memory addition will always have no initial dirty page,
> > and
> > we don't really move RAM a lot (or do we ever?!) for a general VM use case.
> > 
> > Then I went a step back to think about why we need these dirty bit
> > information
> > after all if the memslot is going to be removed?
> > 
> > There're two cases:
> > 
> >   - When the memslot is going to be removed forever, then the dirty
> > information
> >     is indeed meaningless and can be dropped, and,
> > 
> >   - When the memslot is going to be removed but quickly added back with
> > changed
> >     size, then we need to keep those dirty bits because it's just a commmon
> > way
> >     to e.g. punch an MMIO hole in an existing RAM region (here I'd confess I
> >     feel like using "slot_id" to identify memslot is really unfriendly syscall
> >     design for things like "hole punchings" in the RAM address space...
> >     However such "punch hold" operation is really needed even for a common
> >     guest for either system reboots or device hotplugs, etc.).
> 
> why would device hotplug punch a hole in an existing RAM region? 

I thought it could happen because I used to trace the KVM ioctls and see the
memslot changes during driver loading.  But later when I tried to hotplug a
device I do see that it won't...  The new MMIO regions are added only into
0xfe000000 for a virtio-net:

  00000000fe000000-00000000fe000fff (prio 0, i/o): virtio-pci-common
  00000000fe001000-00000000fe001fff (prio 0, i/o): virtio-pci-isr
  00000000fe002000-00000000fe002fff (prio 0, i/o): virtio-pci-device
  00000000fe003000-00000000fe003fff (prio 0, i/o): virtio-pci-notify
  00000000fe840000-00000000fe84002f (prio 0, i/o): msix-table
  00000000fe840800-00000000fe840807 (prio 0, i/o): msix-pba

Does it mean that device plugging is guaranteed to not trigger RAM changes?  I
am really curious about what cases we need to consider in which we need to keep
the dirty bits for a memory removal, and if system reset is the only case, then
it could be even easier (because we might be able to avoid the sync in memory
removal but do that once in a sys reset hook)...

> 
> > 
> > The real scenario we want to cover for dirty tracking is the 2nd one.
> > 
> > If we can track dirty using raw GPA, the 2nd scenario is solved itself.
> > Because we know we'll add those memslots back (though it might be with a
> > different slot ID), then the GPA value will still make sense, which means we
> > should be able to avoid any kind of synchronization for things like memory
> > removals, as long as the userspace is aware of that.
> 
> A curious question. What about the backing storage of the affected GPA 
> is changed after adding back? Is recorded dirty info for previous backing 
> storage still making sense for the newer one?

It's the case of a permanent removal, plus another addition iiuc.  Then the
worst case is we get some extra dirty bits set on that new memory region, but
IMHO that's benigh (we'll migrate some extra pages even they could be zero pages).

Thanks,

> 
> Thanks
> Kevin
> 
> > 
> > With that, when we fetch the dirty bits, we lookup the memslot dynamically,
> > drop bits if the memslot does not exist on that address (e.g., permanent
> > removals), and use whatever memslot is there for that guest physical
> > address.
> > Though we for sure still need to handle memory move, that the userspace
> > needs
> > to still take care of dirty bit flushing and sync for a memory move, however
> > that's merely not happening so nothing to take care about either.
> > 
> > Does this makes sense?  Comments greatly welcomed..
> > 
> > Thanks,
> > 
> > [1] https://lists.gnu.org/archive/html/qemu-devel/2020-03/msg08361.html
> > 
> > --
> > Peter Xu
> 

-- 
Peter Xu

