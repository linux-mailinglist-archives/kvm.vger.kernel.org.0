Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29C3533391
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 00:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242360AbiEXWcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 18:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242354AbiEXWcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 18:32:32 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C6E7521D
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 15:32:29 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x12so3418284wrg.2
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 15:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/hjeyXIou+bR7sgCBUUS9KBiw7ITkpAtyGQPK8WkjHQ=;
        b=E47CS0uk7HJ3B0+amVIKreQyHTGL6Id/MNM0NxjP7X6opvCgl1WcdBa5SnwKc3EDWw
         V2RSBPZ5PBv0+cdx0NAoNLXYDyjDup9mou8/UiOBU++4DVMVZrHzrWd+ZVhZFW2K8uMW
         p9b4jxU7DGV0i8n8hpbveKXjRPZjF7JZfelsg33lCxe6KvbM/3Kw2gy36RExYeMQcSnp
         QyMMPOr6T3TA59Xk7ew90wKydoDBGM28Fu7tgOmM6JcjUpxvmSbhb9njgSwtUUkrwV/Z
         SDvlO42njKkIejaVhIiCDGW4sF9Mf28i9mQR4sp9xyvJ2C1xtsrbm5Tfz8hGqHkzJQq/
         IEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/hjeyXIou+bR7sgCBUUS9KBiw7ITkpAtyGQPK8WkjHQ=;
        b=FP6ZYMwQAtAUoER8L3o48gIg6CetTaR+HlscWgQ+DtqjVMW1knwHI2fTO8LYFb1Wtx
         6363/Uht5lVqODPNT7+zlpUr+uNRgBMq4AigB4sjYNC0xup1ias6sdrFgvrDWZ5EVwJu
         80AIcO/4wUYSm8J7d9LHjrcusN+EDUJ6zd6gUFd1zTID40U7QSza0ZLi4PW4AKqBZvIe
         wgt4BRrS5zFoOFniE8mVZtp98wjXTqB/8qbwiSAvydtw9GB0nmo/dmJ1VquExLDDapyf
         KsaRYWANNcPJ/vwJtseBiUMvLfGSsvWaNh+/mIJ7duqy52yxFUuLBytVw8VxzNzIzf7N
         oLJQ==
X-Gm-Message-State: AOAM533ee7mO7S5I68AcfzkJ5CAHdl8xedShjJAbK/VBc9ebrQDqxGN6
        LdhcIW4ulEnDBeBXD0h6daUIBkexQg++CJd5T1SK7g==
X-Google-Smtp-Source: ABdhPJxT4ExN63oIrXSw4yucGOE3FdTxLSSWhIsKQP4q3l+uXQdQtcsiB0ShXvD15pANNDgeH4cCwpElZhKEPpNgNxo=
X-Received: by 2002:adf:fb05:0:b0:20a:e113:8f3f with SMTP id
 c5-20020adffb05000000b0020ae1138f3fmr25324902wrr.534.1653431548193; Tue, 24
 May 2022 15:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com> <YoeoLJNQTam5fJSu@cmpxchg.org>
In-Reply-To: <YoeoLJNQTam5fJSu@cmpxchg.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 24 May 2022 15:31:52 -0700
Message-ID: <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Sean Christopherson <seanjc@google.com>,
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
        Oliver Upton <oupton@google.com>,
        Cgroups <cgroups@vger.kernel.org>,
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

On Fri, May 20, 2022 at 7:39 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Thu, May 19, 2022 at 06:56:54PM -0700, Yosry Ahmed wrote:
> > On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > [...]
> > > >
> > > > It was mostly an honest question, I too am trying to understand what userspace
> > > > wants to do with this information.  I was/am also trying to understand the benefits
> > > > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > > > already has specific stats for the number of leaf pages mapped into a VM, why not
> > > > do the same for non-leaf pages?
> > >
> > > Let me answer why a more general stat is useful and the potential
> > > userspace reaction:
> > >
> > > For a memory type which is significant enough, it is useful to expose
> > > it in the general interfaces, so that the general data/stat collection
> > > infra can collect them instead of having workload dependent stat
> > > collectors. In addition, not necessarily that stat has to have a
> > > userspace reaction in an online fashion. We do collect stats for
> > > offline analysis which greatly influence the priority order of
> > > optimization workitems.
> > >
> > > Next the question is do we really need a separate stat item
> > > (secondary_pagetable instead of just plain pagetable) exposed in the
> > > stable API? To me secondary_pagetable is general (not kvm specific)
> > > enough and can be significant, so having a separate dedicated stat
> > > should be ok. Though I am ok with lump it with pagetable stat for now
> > > but we do want it to be accounted somewhere.
> >
> > Any thoughts on this? Johannes?
>
> I agree that this memory should show up in vmstat/memory.stat in some
> form or another.
>
> The arguments on whether this should be part of NR_PAGETABLE or a
> separate entry seem a bit vague to me. I was hoping somebody more
> familiar with KVM could provide a better picture of memory consumption
> in that area.
>
> Sean had mentioned that these allocations already get tracked through
> GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
> track, they should be represented in memory.stat in some form. Sean
> also pointed out though that those allocations tend to scale rather
> differently than the page tables, so it probably makes sense to keep
> those two things separate at least.
>
> Any thoughts on putting shadow page tables and iommu page tables into
> the existing NR_PAGETABLE item? If not, what are the cons?
>
> And creating (maybe later) a separate NR_VIRT for the other
> GPF_KERNEL_ACCOUNT allocations in kvm?

I agree with Sean that a NR_VIRT stat would be inaccurate by omission,
unless we account for all KVM allocations under this stat. This might
be an unnecessary burden according to what Sean said, as most other
allocations scale linearly with the number of vCPUs or the memory
assigned to the VM.

I don't have enough context to say whether we should piggyback KVM MMU
pages to the existing NR_PAGETABLE item, but from a high level it
seems like it would be more helpful if they are a separate stat.
Anyway, I am willing to go with whatever Sean thinks is best.
