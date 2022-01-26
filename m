Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C86949D5EE
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 00:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiAZXLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 18:11:07 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45371 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231251AbiAZXLH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 18:11:07 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 3A1F732021F8;
        Wed, 26 Jan 2022 18:11:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 26 Jan 2022 18:11:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=SsINKsVfZbLc2rjt6CAFAsLOfCc9RU+ghINqtw
        Xc60Q=; b=v97ltoXQLLu4ngCwNFD3W74YjKSDB4tZjHM7LtmMJb8omm6oBnYWIk
        HbznlwrJ99xkq1CWflPhlEjH6aQV8iUnWSXWX/nk55Zb5MXBRUjUgpk3LOcIoXYw
        TwCyJ2lAFPOa/4klrPCHqn16lHagXBiKb2CXveEKN/aSvtIV7h/NEaSlgvIiscqa
        ch9OsvbFW4UvWVFlTpW7D6Ok+tPolFmSNjq9H2PuwJVK2pp9BE30iJIXvs/Zsh5x
        KvX5gdNpnIrsrP1AEhjxJNbxL9LNFcy46Sa7lxLZBn6Wz3aoxIJ8SM0XHATNd//g
        mV8p7ejz1kDeOOyU7tfLxMafPkAoUF+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SsINKsVfZbLc2rjt6
        CAFAsLOfCc9RU+ghINqtwXc60Q=; b=WnOGCog26d0gNFHQOnLG12B+ef/BInpl5
        Rc9B5p8JVnQvfSyswXzZsJ/JcoECBx2Wv5Cn7HYJV8KiQzk/1WH3ugXbN9KO9Uga
        dy4tZZNctOsAUfcUoQd9n4zh5QThbX4Grv8Vt3yZlBTVztJ3sHXPlKZjJVFmlRJI
        8kKqdzM71XSZ0QXRfAvK9kaHzvr9o6vQi7s8Z4CeMPhOhbKoyClFy4bCrYQbpWUB
        Kvpl/DiIS8vgqqUwaY/Ugp92/I+74SLBuPM3iA4bLWdUo+R0VdgMwmRsaUPqkQMX
        zijGhvf0I7POfKcKqrQoOB35r7w6SlvuTywRI+LI6bZu7K/Ph4Fcw==
X-ME-Sender: <xms:CdXxYWGMVRN7IsJkJ1rkTJ-aQQ5Yws2gSMMNPDVN6cbz6fJNV2R5aQ>
    <xme:CdXxYXUH7ubw-C6nhWifLU09KnuHJBWVcHo8-cqfEm_DSeVxPfLiAURW_rAddSDXQ
    Iwg9bpM8NPiixk4y0Y>
X-ME-Received: <xmr:CdXxYQKjSHsQXxZjnh4qO-xMKKRvg0D6crHOBzroFQ678Or4lNClhO-M2vkgdYCwOjYlN-ZZAfPejzwnSy_FRP7oHXYcnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfedvgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeehud
    evleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:CdXxYQGgHAcl2i9-gkGgu7Ag-i7GGEAHSSK2BWudrXBSeFcXK79Ikg>
    <xmx:CdXxYcXKIFpYZCk3rGiM1vue7uohPp8h77yOf4n-ObTiS03x2SwcXw>
    <xmx:CdXxYTPwpRrHEh_gfbarufb7xGFcv9QMrWyJbET3P1AkwB9B-ZxpOA>
    <xmx:CdXxYZiLbmIq3XSLjv0fHj0q3UvkDEK5r0w95VLrXTGZwOTgOuQcKg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Jan 2022 18:11:05 -0500 (EST)
Date:   Wed, 26 Jan 2022 15:11:03 -0800
From:   Boris Burkov <boris@bur.io>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kernel-team@fb.com
Subject: Re: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Message-ID: <YfHVB5RmLZn2ku5M@zen>
References: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
 <YfHEJpP+1c9QZxA0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfHEJpP+1c9QZxA0@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 09:59:02PM +0000, Sean Christopherson wrote:
> On Wed, Jan 26, 2022, Boris Burkov wrote:
> > I tested this fix on the workload and it did prevent the hangs. However,
> > I am unsure if the fix is appropriate from a locking perspective, so I
> > hope to draw some extra attention to that aspect. set_page_dirty_lock in
> > mm/page-writeback.c has a comment about locking that says set_page_dirty
> > should be called with the page locked or while definitely holding a
> > reference to the mapping's host inode. I believe that the mmap should
> > have that reference, so for fear of hurting KVM performance or
> > introducing a deadlock, I opted for the unlocked variant.
> 
> KVM doesn't hold a reference per se, but it does subscribe to mmu_notifier events
> and will not mark the page dirty after KVM has been instructed to unmap the page
> (barring bugs, which we've had a slew of).  So yeah, the unlocked variant should
> be safe.
> 
> Is it feasible to trigger this behavior in a selftest?  KVM has had, and probably
> still has, many bugs that all boil down to KVM assuming guest memory is backed by
> either anonymous memory or something like shmem/HugeTLBFS/memfd that isn't typically
> truncated by the host.

I haven't been able to isolate a reproducer, yet. I am a bit stumped
because there isn't a lot for me to go off from that stack I shared--the
best I have so far is that I need to trick KVM into emulating
instructions at some point to get to this 'complete_userspace_io'
codepath? I will keep trying, since I think it would be valuable to know
what exactly happened. Open to try any suggestions you might have as
well.

Thanks for the response,
Boris
