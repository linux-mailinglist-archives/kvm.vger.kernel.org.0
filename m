Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBBA5266F1
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382370AbiEMQXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 12:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382375AbiEMQXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 12:23:40 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE0A3C713
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 09:23:34 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so5034132wmn.1
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 09:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P05jhA0WcF/hZv6hPGGv+IwSy9Etnh2buB8vtD3ctaw=;
        b=NbGqMSBPXMT8N2S9Mb/Dsg5lSZ+Q1JehG0g27ajHeCVpig2+23Km9JoVFr/ImPYFoO
         wJmh2nXKIDIII/vXFSfau8UNbJ5DJy18o9CrYBc7a9/NtK/YuUaf3AolOoaNxUrDOM7q
         Q6bqIo+8/dE7bkyPlhCmEkjd6AnOrD2OhH0pNxkmwIETys/pp9IK8GjEeaFuFYivzvmD
         gdTf3d0+GG/ftL3jXg8rtu2aDumAzRDQYSjyUvkD+w5EoHcKd9GNvo5O8R6/JDd1Mi60
         2jyTWDR3yNwOUThXmrpBuS7lvNeRMKW2aCC5EP/QH/EPpkCTf5DhQlw8Sa6acajQ+nyC
         /GXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P05jhA0WcF/hZv6hPGGv+IwSy9Etnh2buB8vtD3ctaw=;
        b=gL0Ns8cQ/serpZhv4M80OVxCUaAPgVlY92sVLMOJzxvwzIz7VkzlWT18IZJ5ljTA+A
         UDSah2FPRmIatGHMQpp6wkcgnuPL1tRbEywOyS4M7qp+gY4ZDPZD/VBWBnmkpFvAsK2H
         1eO7YMjRjVe1Xag9J1ySajNRaxAlBgQqzP28WMjGrTm5ibllRJ/tgxBi3dC4ieWwMIqn
         VMuHBR1qbse/uvVjxnDlgAwdKl+Q3XdA1mqPhjg97BslNqIvHIaIYUvcFQ/3423Fa7QQ
         Ot9QbupejGqdo1LfMHVY4+zgsOHLiY6x6sN9QRPuwH4MXHGC4qh3qVg+OQHBJzjm6kvM
         XYbg==
X-Gm-Message-State: AOAM530moeOgS2Cvd6pMZQXNGoTrlO6zE4Ni4c5N/S36n5mrbiZ/lcbb
        SZ41iqp+0yoo+lSpUM2PqM6K9xR3fTnhfFrzAKM0Wg==
X-Google-Smtp-Source: ABdhPJwMQHR1rV6RBNYyN9NXTYzZlmwu+UcKsnVAZ7vLR8pJMUCcm4gmI2KWG3egFgrVcfmqBhhxtSll0QHpKEJ76pM=
X-Received: by 2002:a05:600c:3490:b0:394:5616:ac78 with SMTP id
 a16-20020a05600c349000b003945616ac78mr5401973wmq.80.1652459013025; Fri, 13
 May 2022 09:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
In-Reply-To: <Yn6DeEGLyR4Q0cDp@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 13 May 2022 09:22:56 -0700
Message-ID: <CAJD7tkZ-pLKu=pY54DoUP7cX_Yn=XgTCpfFK+w+81D9WgbWRsA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks everyone for participating in this discussion and looking into this.

On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 13, 2022, Johannes Weiner wrote:
> > On Thu, May 12, 2022 at 11:29:38PM +0000, Sean Christopherson wrote:
> > > On Thu, May 12, 2022, Johannes Weiner wrote:
> > > > On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > > > > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > > > What do you plan to do for IOMMU page tables? After all, they serve
> > > > > > the exact same purpose, and I'd expect these to be handled the same
> > > > > > way (i.e. why is this KVM specific?).
> > > > >
> > > > > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > > > > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > > > > account other types of secondary page tables to this stat. It is just
> > > > > that we are currently interested in the KVM MMU usage.
> > > >
> > > > Do you actually care at the supervisor level that this memory is used
> > > > for guest page tables?
> > >
> > > Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
> > > for page tables, but except for page tables, the number/size of those allocations
> > > scales linearly with either the number of vCPUs or the amount of memory assigned
> > > to the VM (with no room for improvement barring KVM changes).
> > >
> > > Off the top of my head, KVM's secondary page tables are the only allocations that
> > > don't scale linearly, especially when nested virtualization is in use.
> >
> > Thanks, that's useful information.
> >
> > Are these other allocations accounted somewhere? If not, are they
> > potential containment holes that will need fixing eventually?
>
> All allocations that are tied to specific VM/vCPU are tagged GFP_KERNEL_ACCOUNT,
> so we should be good on that front.
>
> > > > It seems to me you primarily care that it is reported *somewhere*
> > > > (hence the piggybacking off of NR_PAGETABLE at first). And whether
> > > > it's page tables or iommu tables or whatever else allocated for the
> > > > purpose of virtualization, it doesn't make much of a difference to the
> > > > host/cgroup that is tracking it, right?
> > > >
> > > > (The proximity to nr_pagetable could also be confusing. A high page
> > > > table count can be a hint to userspace to enable THP. It seems
> > > > actionable in a different way than a high number of kvm page tables or
> > > > iommu page tables.)
> > >
> > > I don't know about iommu page tables, but on the KVM side a high count can also
> > > be a good signal that enabling THP would be beneficial.
> >
> > Well, maybe.
> >
> > It might help, but ultimately it's the process that's in control in
> > all cases: it's unmovable kernel memory allocated to manage virtual
> > address space inside the task.
> >
> > So I'm still a bit at a loss whether these things should all be lumped
> > in together or kept separately. meminfo and memory.stat are permanent
> > ABI, so we should try to establish in advance whether the new itme is
> > really a first-class consumer or part of something bigger.
> >
> > The patch initially piggybacked on NR_PAGETABLE. I found an email of
> > you asking why it couldn't be a separate item, but it didn't provide a
> > reasoning for that decision. Could you share your thoughts on that?
>
> It was mostly an honest question, I too am trying to understand what userspace
> wants to do with this information.  I was/am also trying to understand the benefits
> of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> already has specific stats for the number of leaf pages mapped into a VM, why not
> do the same for non-leaf pages?

Let me cast some light on this. The reason this started being
piggybacked on NR_PAGETABLE is that we had a remnant of an old
internal implementation of NR_PAGETABLE before it was introduced
upstream, that accounted KVM secondary page tables as normal page
tables. This made me think this behavior was preferable. Personally, I
wanted to make it a separate thing since the beginning. When I found
opinions here that also suggested a separate stat I went ahead for
that.

As for where to put this information, it does not have to be
NR_SECONDARY_PAGETABLE. Ultimately, people working on KVM are the ones
that will interpret and act upon this data, so if you have somewhere
else in mind please let me know, Sean.
