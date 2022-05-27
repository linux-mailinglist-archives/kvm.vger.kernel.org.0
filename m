Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873105366F4
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 20:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354037AbiE0SeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 14:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiE0SeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 14:34:07 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BAB5715B
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 11:34:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v17so2688465wrv.2
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 11:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZMRaR78nxxjwROTv5Xv0uCrlGpUNKsmrgGJVBdvr8Ow=;
        b=MkzqrGgvYlJnACcMhuImZMacQWLHV1sfIdXNuvsTHnrOm/OtJW/K9hyD3QxlczsLoT
         y8wk264wphMEIWY/RDJ7JWPjvXefBQcB7eVBOUBhZ+RsMwz/xaX7hq5oPUFVoNm6gk+9
         ECC8TXoBKcjMQzd/Lx+VaeiZUjV0ikBmp5ZprAw/qhOBi6WaPZolyclGk7kbaG4wUmNU
         +mIFZCiGrm+cA09ar5e2i9xVloL7GuFnwLMsoJoJXN3aAZ1DbrqnVYdqcioLJkScP577
         ZEsHAj7/WcJolt2zrK/cc8Q5BlFMYbDm2Oga3A+8NHOYgCiMkGz8pf41smTE0Irti5Jf
         eM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZMRaR78nxxjwROTv5Xv0uCrlGpUNKsmrgGJVBdvr8Ow=;
        b=enX+Uz89gwXnTuCOBntmUzgHvuwrQoZBsiyYwOza4P2JE8JnqoYIQTWTTMjbf6RvRu
         gSvltGkOdCYAxa/CWCMXhHZsSB8Hlgp1dZFw0FpShTJ82R0bVPFPRNfue1X0M3l/Hqzr
         tJKPh5qJRLW7tOipdGWs2dxwi58bkqqoqP+4468Rvx2wMaHFwfU25SErGr2idwK/OhKQ
         d8erkX/MRm5EOjraJDUUa9uuFcf3AHQIY1AMmQdtgOgiYCSP/ggTBcoph+nFHiDK/IpO
         h0vqKwdtRbGdD2BTiNQIYXXKUf4AuJNV7SwnsaVZc01gX5xzOFd+fTsgjx5D7kbwKg0+
         2dbQ==
X-Gm-Message-State: AOAM5328feNv9x4vlj2w2Ile8D6VTPn2QMhouVuJ/fzWHYkZKfqX55aY
        oH0d0FuOKZW8C9XvulI0NF/2LVQVk8vOeBjbAr5v2w==
X-Google-Smtp-Source: ABdhPJxUkKLq8UKhcdaeqCHY4EBxsrPSLnU5/L22u7NUw4uGgA00AplmrdnobCWk7FoVQrgXmXTGsKhVFFO9PCXmQT8=
X-Received: by 2002:a05:6000:544:b0:20f:ca41:cc4c with SMTP id
 b4-20020a056000054400b0020fca41cc4cmr26548956wrf.582.1653676444165; Fri, 27
 May 2022 11:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org> <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org> <Yo7MHA2aUaprvgl8@google.com>
In-Reply-To: <Yo7MHA2aUaprvgl8@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 27 May 2022 11:33:27 -0700
Message-ID: <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
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

On Wed, May 25, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 25, 2022, Johannes Weiner wrote:
> > On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > > I don't have enough context to say whether we should piggyback KVM MMU
> > > pages to the existing NR_PAGETABLE item, but from a high level it
> > > seems like it would be more helpful if they are a separate stat.
> > > Anyway, I am willing to go with whatever Sean thinks is best.
> >
> > Somebody should work this out and put it into a changelog. It's
> > permanent ABI.
>
> After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.
>
> It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
> scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
> allocate a large number of page tables even though the guest isn't accessing that
> much memory.
>
> But, someone would need to either understand how KVM works to make that connection,
> or know (or be told) to go look at KVM's stats if they're running VMs to better
> decipher the stats.
>
> And even in the little bit of time I played with this, I found having
> nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
> informative.  E.g. when backing a VM with THP versus HugeTLB,
> nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
> order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
> something triggering DoubleMap, but now I want to find out why that's happening.
>
> So while I'm pretty sure a clever user could glean the same info by cross-referencing
> NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
> very least prove to be helpful for understanding tradeoffs between VM backing types,
> and likely even steer folks towards potential optimizations.
>
> Baseline:
>   # grep page_table /proc/vmstat
>   nr_page_table_pages 2830
>   nr_secondary_page_table_pages 0
>
> THP:
>   # grep page_table /proc/vmstat
>   nr_page_table_pages 7584
>   nr_secondary_page_table_pages 140
>
> HugeTLB:
>   # grep page_table /proc/vmstat
>   nr_page_table_pages 3153
>   nr_secondary_page_table_pages 153
>

Interesting findings! Thanks for taking the time to look into this, Sean!
I will refresh this patchset and summarize the discussion in the
commit message, and also fix some nits on the KVM side. Does this
sound good to everyone?
