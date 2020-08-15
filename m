Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26124548B
	for <lists+kvm@lfdr.de>; Sun, 16 Aug 2020 00:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgHOW2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Aug 2020 18:28:13 -0400
Received: from lavender.maple.relay.mailchannels.net ([23.83.214.99]:16643
        "EHLO lavender.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726598AbgHOW2N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 15 Aug 2020 18:28:13 -0400
X-Sender-Id: dreamhost|x-authsender|contact@kevinloughlin.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 995824012B1
        for <kvm@vger.kernel.org>; Sat, 15 Aug 2020 21:08:59 +0000 (UTC)
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (100-96-7-27.trex.outbound.svc.cluster.local [100.96.7.27])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id DC08D4011B0
        for <kvm@vger.kernel.org>; Sat, 15 Aug 2020 21:08:58 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|contact@kevinloughlin.org
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Sat, 15 Aug 2020 21:08:59 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|contact@kevinloughlin.org
X-MailChannels-Auth-Id: dreamhost
X-Language-Industry: 437238696730d39f_1597525739345_1753357456
X-MC-Loop-Signature: 1597525739345:2317480423
X-MC-Ingress-Time: 1597525739344
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a66.g.dreamhost.com (Postfix) with ESMTP id 7E99A7F60C
        for <kvm@vger.kernel.org>; Sat, 15 Aug 2020 14:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=kevinloughlin.org; h=
        mime-version:references:in-reply-to:from:date:message-id:subject
        :to:content-type; s=kevinloughlin.org; bh=PLLn71yw70w+FHnL0XBKkp
        560eM=; b=6C4BA3NPhwRIRcojG45mKQYOq4VpVu/YmyO9/ZOv/rTwsCcQYFGMEo
        8Owh4Xg8D9o+Qvu5Vi0U/jZVhnZbntiuis9Y5x957lMitfsXFGyj1Gd6+i3pOQgO
        eqVLPqiO/2KuCn2ch0zBlNviOWtVlAV8YnMexxLAcOpGGEgPMJvNk=
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: contact@kevinloughlin.org)
        by pdx1-sub0-mail-a66.g.dreamhost.com (Postfix) with ESMTPSA id C2F227F608
        for <kvm@vger.kernel.org>; Sat, 15 Aug 2020 14:08:56 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id t15so14064520iob.3
        for <kvm@vger.kernel.org>; Sat, 15 Aug 2020 14:08:56 -0700 (PDT)
X-Gm-Message-State: AOAM532bpYX3LlEW9dI80F+CaE4XyG5/Sqa/5H9ytLLJtWzHYhq6bD0M
        zukctH3LiERQqrPNhAmNrJUntD149aFEUqDCCSM=
X-Google-Smtp-Source: ABdhPJxENn7VLRN4pk9tFxIoQ4tl0D4rU4bksdA2SyL9YI/OiCqpq+IK3jjL353gLWoc+5mYq/pyuHefOhdAWX5CSs0=
X-Received: by 2002:a6b:da0d:: with SMTP id x13mr6983127iob.138.1597525735864;
 Sat, 15 Aug 2020 14:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <d49ad8fb155e2ebc6e54d8b83c335926@kevinloughlin.org> <20200720154901.GB20375@linux.intel.com>
In-Reply-To: <20200720154901.GB20375@linux.intel.com>
X-DH-BACKEND: pdx1-sub0-mail-a66
From:   Kevin Loughlin <contact@kevinloughlin.org>
Date:   Sat, 15 Aug 2020 17:08:45 -0400
X-Gmail-Original-Message-ID: <CAB30WPe1F6D3e=AkR=QiSAhCib6X5ufJnZjaHQD0wTo79_+Z2g@mail.gmail.com>
Message-ID: <CAB30WPe1F6D3e=AkR=QiSAhCib6X5ufJnZjaHQD0wTo79_+Z2g@mail.gmail.com>
Subject: Re: x86 MMU: RMap Interface
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrleelgdduheekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeggfhgjhfffkffuvfgtsehttdertddttdejnecuhfhrohhmpefmvghvihhnucfnohhughhhlhhinhcuoegtohhnthgrtghtsehkvghvihhnlhhouhhghhhlihhnrdhorhhgqeenucggtffrrghtthgvrhhnpeffjefhtdelvdfhteevfeefvdfhjefgheetheetgefftdeghffgvedtvdevhfdvheenucfkphepvddtledrkeehrdduieeirdehvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehmrghilhdqihhouddqfhehvddrghhoohhglhgvrdgtohhmpdhinhgvthepvddtledrkeehrdduieeirdehvddprhgvthhurhhnqdhprghthhepmfgvvhhinhcunfhouhhghhhlihhnuceotghonhhtrggttheskhgvvhhinhhlohhughhhlhhinhdrohhrgheqpdhmrghilhhfrhhomheptghonhhtrggttheskhgvvhhinhhlohhughhhlhhinhdrohhrghdpnhhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given this info, am I correct in saying that all non-MMIO guest pages
are (1) added to the rmap upon being marked present, and (2) removed
from the rmap upon being marked non-present?

I primarily ask because I'm observing behavior (running x86-64 guest
with TDP/EPT enabled) wherein multiple SPTEs appear to be added to the
rmap for the same GFN<->PFN mapping (sometimes later followed by
multiple removals of the same GFN<->PFN mapping). My understanding was
that, for a given guest, each GFN<->PFN mapping corresponds to exactly
one rmap entry (and vice versa). Is this incorrect?

I observe the behavior I mentioned whether I log upon rmap updates, or
upon mmu_spte_set() (for non-present->present) and
mmu_clear_track_bits() (for present->non-present). Perhaps I'm missing
a more obvious interface for logging when the PFNs backing guest pages
are marked as present/non-present?

Best wishes, and thanks again for the help,

Kevin

On Mon, Jul 20, 2020 at 11:49 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sun, Jul 19, 2020 at 06:32:22PM -0400, contact@kevinloughlin.org wrote:
> > Hi,
> >
> > I'm a bit confused by the interface for interacting with the page rmap. For
> > context, on a TDP-enabled x86-64 host, I'm logging each time a GFN->PFN
> > mapping is created/modified/removed for a non-MMIO page (kernel version
> > 5.4).
> >
> > First, my understanding is that the page rmap is a mapping of non-MMIO PFNs
> > back to the GFNs that use them. The interface for creating an rmap entry
> > (and thus, a new GFN->PFN mapping) appears to be rmap_add() and is quite
> > straightforward. However, rmap_remove() does not appear to be the (only)
> > function for removing an entry from the page rmap. For instance,
> > kvm_zap_rmapp()---used by the mmu_notifier for invalidations---jumps
> > straight to pte_list_remove(), while drop_spte() uses rmap_remove().
>
> The rmaps are associated with the memslot, the drop_spte() path allows KVM
> to clean up SPTEs without having to guarantee the validity of the memslot
> that was used to create the SPTE.
>
> > Would it be fair to say that mmu_spte_clear_track_bits() is found on all
> > paths for removing an entry from the page rmap?
>
> Yes, that should hold true.
>
> > Second, for updates to the frame numbers in an existing SPTE, there are both
> > mmu_set_spte() and mmu_spte_set(). Could someone please clarify the
> > difference between these functions?
>
> mmu_set_spte() is the higher level helper that is used during a page fault
> or prefetch to convert a host PFN and basic access permissions into a SPTE
> value, handle large/huge page interactions and accounting, add the rmap,
> etc..., and of course eventually update the SPTE.
>
> mmu_spte_set() is a low level helper that does nothing more than write a
> SPTE.  It's just a wrapper to __set_spte() that also WARNs if the old SPTE
> is present.
>
> > Finally, much of the logic between the page rmap and parent PTE rmaps
> > (understandably) overlaps. However, with TDP-enabled, I'm not entirely sure
> > what the role of the parent PTE rmaps is relative to the page rmap. Could
> > someone possibly clarify?
>
> KVM needs the backpointers to remove the SPTE for a shadow page, which
> exists in the parent shadow page, when the child is zapped, e.g. if a L2 SP
> is removed, its SPTE in a L3 SP needs to be updated.
