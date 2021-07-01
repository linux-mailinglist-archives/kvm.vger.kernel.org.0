Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A3F3B917F
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 14:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhGAMLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 08:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbhGAMLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 08:11:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7BDC061756
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 05:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lCu1PfQZkVR84Had3CDedJ1AfFR4DmELtRDrF/eDCwk=; b=gD2+EgcszzlzRGSNYbP+MSdh8j
        bxQBTHSVC+vhGWDsPF6Uy0UTmpNf3WJ9phckjaPRdDdOYH3QghZSdEjdFb2KXSsmOkSY7ByRWm0Qg
        mHFmlqnUfIsRqgjvnKiDAIVWcxYz0y+vx4G9qtBr2krZa/Miy9IHqFfUCJcnRZGPZzXH7aWB3kF6W
        GkJllDD5lqqZNW6hKCtxIrk1NsJ7Qla4gdV/+YB30ONdXTr8AasryTz4sDA+iZ0MCPr93cN0KUH0A
        R43s0nn16Y5+oktY9+GFKzZNLliGWQwIm5RJr21cNZQmdVW2efyWnG1XLyboxl00JZXvXV36Nchai
        psnIDLcg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyvUK-006Wof-U9; Thu, 01 Jul 2021 12:08:18 +0000
Date:   Thu, 1 Jul 2021 13:08:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, kvm <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>, Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Fast page fault support for the TDP
 MMU
Message-ID: <YN2wLHWpNkLXvDEB@casper.infradead.org>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <YN0XRZvCrvroItQQ@casper.infradead.org>
 <CABgObfZUFWCAvKoxDzGjmksFnwZgbnpX9GuC+nhiVLa-Fhwj6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZUFWCAvKoxDzGjmksFnwZgbnpX9GuC+nhiVLa-Fhwj6A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01, 2021 at 08:47:06AM +0200, Paolo Bonzini wrote:
> Il gio 1 lug 2021, 03:17 Matthew Wilcox <willy@infradead.org> ha scritto:
> 
> > On Wed, Jun 30, 2021 at 09:47:56PM +0000, David Matlack wrote:
> > > This patch series adds support for the TDP MMU in the fast_page_fault
> >
> > Nowhere in this message do you explain what the TDP MMU is.
> >
> 
> I don't know if you rolled a 1 too much in your last D&D session or what,
> but this seems like a slightly petty remark given the wealth of information
> that was in the commit message.

Yes, there was a wealth of information, but I couldn't understand any of
it because I have no idea what a TDP MMU is.  Actually, the length of
the intro message annoyed me, because I had to scan the whole thing to
try to figure out whether he explained what a TDP MMU is anywhere in it.

> The patches only touch kvm code, therefore David probably expected only kvm
> reviewers to be interested---in which case, anyone who hasn't lived under a
> rock for a year or two would know.

He cc'd me.  That's usually a request for a review.  So I had to try
to understand why I would care.  At this point, I don't think I care.
Somebody explain to me why I should care?  That's the point of a cover
letter.

> Anyway the acronym is fairly
> Google-friendly:
> https://lore.kernel.org/kvm/20201014182700.2888246-1-bgardon@google.com/
> http://lkml.iu.edu/hypermail/linux/kernel/2010.2/07021.html

Now I'm really confused, and I don't understand why I was cc'd at all.
get_maintainer.pl going wild?
