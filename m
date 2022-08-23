Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CAA59CCC5
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiHWAFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbiHWAFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:05:36 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D1754CB0
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:05:35 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h24so15076938wrb.8
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=qokcu5tCtpQLCQgO9pVTazHLwMpC9kMD5hOC340KS1I=;
        b=jBPLk8bHlDLGIvGVE4zL26EtBtv9avfUdg557Lw4E+XzpuWZRA6yrM8jemnayVxmTu
         HFUGMWr/PHR8LguRaK0GVi7w26Qnt3CxyVGcW0n7UF3R4pU31QDsJO6/jSpmu9xmtRvy
         GHEx+99kDAzCMm28iwalvBDKvUcqcKRg/skmcRT/eIrUVHr5GG/kBpafDR+G5cad3XCs
         SCh0iHzLtcfdouEA1DsVo0u8G4R8t2qE8/4a4DAj7CCMmsaTPR1R4XpS2cOFX5Kk+Ew+
         PN7CoifI1ft5ccWK48IE5B74fHCM7d5LD91G37VfgpN9TcT7S+yGetYQj7xs0JO8WSdi
         opgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=qokcu5tCtpQLCQgO9pVTazHLwMpC9kMD5hOC340KS1I=;
        b=aChLvKSXjcgvspQThzea1/9SejAxNI8/dR6liyvQAVlmUVtuv7OrXHhpjmZKim6fbd
         ymqkzth3AFi+esF1T+qmbKtx+AbSmqUHhgx5SoPMgadX8Zi/yRrflc4bkZuP5YHYfVX6
         zvP9QcFe+WLY7jRhHl+OjvNL96XXOMOeUi/iZpm1chT53jBNEitb8OqiRpys4ai3mEMq
         C7UVO3wSMJxDj3rZNKcPWusBj/0rXmwBK3w0ErhYDOWRU4o6N+J4IUtg2EdD74BWyFTY
         0DdnGME0IdHdb31xecWvQv9SuHtVh+MUZv7mcZ4a7BmUnBF0CS5qBVssV/4NgerwyeeC
         iMcQ==
X-Gm-Message-State: ACgBeo1ks+tHfOe0zsWQppoWqfSbRDZyXazZ4cZEH6eda8Sy+W1BzMlj
        wuhFgkgUx8dhnpxtqCUSCXDUZT1re+p3tLYJcr25SQ==
X-Google-Smtp-Source: AA6agR5Lo8c+tVx21B5A2il5HGzGcfxxCY5VNzyOQ8xHSFF9B9ZhcgyTcMW2pafj/S8owJMHXTCJIeOP/v9Ei+X67uo=
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id
 g8-20020a056000118800b002206c20fbf6mr12350055wrx.372.1661213133858; Mon, 22
 Aug 2022 17:05:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
 <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
In-Reply-To: <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 22 Aug 2022 17:04:57 -0700
Message-ID: <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>,
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

On Wed, Aug 17, 2022 at 3:27 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Wed, Aug 17, 2022 at 10:24 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 28 Jun 2022 22:09:35 +0000 Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > > We keep track of several kernel memory stats (total kernel memory, page
> > > tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> > > per-memcg, etc). These stats give insights to users to how much memory
> > > is used by the kernel and for what purposes.
> > >
> > > Currently, memory used by kvm mmu is not accounted in any of those
> > > kernel memory stats. This patch series accounts the memory pages
> > > used by KVM for page tables in those stats in a new
> > > NR_SECONDARY_PAGETABLE stat. This stat can be later extended to account
> > > for other types of secondary pages tables (e.g. iommu page tables).
> > >
> > > KVM has a decent number of large allocations that aren't for page
> > > tables, but for most of them, the number/size of those allocations
> > > scales linearly with either the number of vCPUs or the amount of memory
> > > assigned to the VM. KVM's secondary page table allocations do not scale
> > > linearly, especially when nested virtualization is in use.
> > >
> > > >From a KVM perspective, NR_SECONDARY_PAGETABLE will scale with KVM's
> > > per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> > > bizarre (e.g. accessing only 4kb chunks of 2mb pages so that KVM is
> > > forced to allocate a large number of page tables even though the guest
> > > isn't accessing that much memory). However, someone would need to either
> > > understand how KVM works to make that connection, or know (or be told) to
> > > go look at KVM's stats if they're running VMs to better decipher the stats.
> > >
> > > Furthermore, having NR_PAGETABLE side-by-side with NR_SECONDARY_PAGETABLE
> > > is informative. For example, when backing a VM with THP vs. HugeTLB,
> > > NR_SECONDARY_PAGETABLE is roughly the same, but NR_PAGETABLE is an order
> > > of magnitude higher with THP. So having this stat will at the very least
> > > prove to be useful for understanding tradeoffs between VM backing types,
> > > and likely even steer folks towards potential optimizations.
> > >
> > > The original discussion with more details about the rationale:
> > > https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org
> > >
> > > This stat will be used by subsequent patches to count KVM mmu
> > > memory usage.
> >
> > Nits and triviata:
> >
> > > --- a/Documentation/filesystems/proc.rst
> > > +++ b/Documentation/filesystems/proc.rst
> > > @@ -977,6 +977,7 @@ Example output. You may not have all of these fields.
> > >      SUnreclaim:       142336 kB
> > >      KernelStack:       11168 kB
> > >      PageTables:        20540 kB
> > > +    SecPageTables:         0 kB
> > >      NFS_Unstable:          0 kB
> > >      Bounce:                0 kB
> > >      WritebackTmp:          0 kB
> > > @@ -1085,6 +1086,9 @@ KernelStack
> > >                Memory consumed by the kernel stacks of all tasks
> > >  PageTables
> > >                Memory consumed by userspace page tables
> > > +SecPageTables
> > > +              Memory consumed by secondary page tables, this currently
> > > +           currently includes KVM mmu allocations on x86 and arm64.
> >
> > Something happened to the whitespace there.
>
> Yeah I have the fix for this queued for v7. Thanks!
>
> >
> > > +                          "Node %d SecPageTables:  %8lu kB\n"
> > > ...
> > > +                          nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
> >
> > The use of "sec" in the user-facing changes and "secondary" in the
> > programmer-facing changes is irksome.  Can we be consistent?  I'd
> > prefer "secondary" throughout.
> >
>
> SecondaryPageTables is too long (unfortunately), it messes up the
> formatting in node_read_meminfo() and meminfo_proc_show(). I would
> prefer "secondary" as well, but I don't know if breaking the format in
> this way is okay.

Any thoughts here Andrew? Change to SecondaryPageTables anyway? Change
all to use "sec" instead of "secondary"? Leave as-is?


>
> This is what I mean by breaking the format btw (the numbers become misaligned):
>
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 5ad56a0cd593..4f85750a0f8e 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -433,7 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>                              "Node %d ShadowCallStack:%8lu kB\n"
>  #endif
>                              "Node %d PageTables:     %8lu kB\n"
> -                            "Node %d SecPageTables:  %8lu kB\n"
> +                            "Node %d SecondaryPageTables:  %8lu kB\n"
>                              "Node %d NFS_Unstable:   %8lu kB\n"
>                              "Node %d Bounce:         %8lu kB\n"
>                              "Node %d WritebackTmp:   %8lu kB\n"
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 208efd4fa52c..b7166d09a38f 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -115,7 +115,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  #endif
>         show_val_kb(m, "PageTables:     ",
>                     global_node_page_state(NR_PAGETABLE));
> -       show_val_kb(m, "SecPageTables:  ",
> +       show_val_kb(m, "SecondaryPageTables:    ",
>                     global_node_page_state(NR_SECONDARY_PAGETABLE));
>
>         show_val_kb(m, "NFS_Unstable:   ", 0);
