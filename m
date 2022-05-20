Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475EA52E233
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 03:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiETB5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 21:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiETB5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 21:57:36 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686D9EBEA1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 18:57:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w4so9523537wrg.12
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 18:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/NS3+bOivmdn/Z8oAqTayRG5MjC4lANEwiPrpSX5IA=;
        b=lC1A71c86K3b210P5MINYKI+0nEPTtRGK3LeWj2Npew4lX9mJGgrpWWegiuNtMwlJO
         P1IlUwgqu95jwD3J+mnRGelGqXz+HoaJ7VCJk9hhvvF66jPz+hrvF0dmKSe2LLL2Vgq/
         rwXqca2l71+mfz5tl8pRhTv4LCsg9QGocKsxdwCfWXbGVabJpfgNFG9+rBVSpj/uhude
         6hLQ+JpxChsTxgZBARTq2zFr80q+S2jttKKsRPO0P7o9moE/Iyx8K/oNzwHCGA7J5UxE
         CJjZ0hW/O6s0vTeoubWTNpA5gAfGug3OjBmx35+8T9dkzXFSpzM7/kEn0mCCEAR9GuP4
         zRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/NS3+bOivmdn/Z8oAqTayRG5MjC4lANEwiPrpSX5IA=;
        b=7Gyi4fWJzIgzFRZUVHIdQbVZN7LLxb3WJ/4o60+H/n4Ilji9aSvtUMHQ/Y8HFHos0b
         6t37ABDFsloFfmVKUWFGvKJ+twzsVDef7Vi/Hc6dsaoFsqZXBMwiIUvkcSI65CU00oAn
         KtAbKIvYrrVyDV//PKtiophV1bsZze21oimD4ejSDFc3JgPE7edebOlsDwP7zBxLsLIL
         204/oTIFXhYIPVNOLnTWO2gHRCld2vQMKi4O3AyZ7I/q8YzgsHcShgrZC7zIbUWLNStW
         jsxdfva1+vJXctQHLiOxZ/Cm4s1+1I3ZhJl0u9k3452w9tzIFoAn9x7949mt4bonrgZF
         a4Dg==
X-Gm-Message-State: AOAM532tBrexamay3NvPLCHRLDz+gqst/XLLT7FRC8xvMyakEvtr0kC5
        u7SUJVi4etMxA6/+qTYsxW4INT7lZgLkRUi6O5MPTQ==
X-Google-Smtp-Source: ABdhPJwkT9Ky/oISspASS8FjtELCGMc/VI5WvnHs18qGYZT5kAwspcv3o3fkcjB+NGakAekQntgOyy/dXNI6HrW1Wu8=
X-Received: by 2002:adf:f042:0:b0:20e:5be7:f473 with SMTP id
 t2-20020adff042000000b0020e5be7f473mr6249346wro.80.1653011850753; Thu, 19 May
 2022 18:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com> <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
In-Reply-To: <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 19 May 2022 18:56:54 -0700
Message-ID: <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
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

On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> [...]
> >
> > It was mostly an honest question, I too am trying to understand what userspace
> > wants to do with this information.  I was/am also trying to understand the benefits
> > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > already has specific stats for the number of leaf pages mapped into a VM, why not
> > do the same for non-leaf pages?
>
> Let me answer why a more general stat is useful and the potential
> userspace reaction:
>
> For a memory type which is significant enough, it is useful to expose
> it in the general interfaces, so that the general data/stat collection
> infra can collect them instead of having workload dependent stat
> collectors. In addition, not necessarily that stat has to have a
> userspace reaction in an online fashion. We do collect stats for
> offline analysis which greatly influence the priority order of
> optimization workitems.
>
> Next the question is do we really need a separate stat item
> (secondary_pagetable instead of just plain pagetable) exposed in the
> stable API? To me secondary_pagetable is general (not kvm specific)
> enough and can be significant, so having a separate dedicated stat
> should be ok. Though I am ok with lump it with pagetable stat for now
> but we do want it to be accounted somewhere.

Any thoughts on this? Johannes?
