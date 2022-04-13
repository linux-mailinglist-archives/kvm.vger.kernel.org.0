Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9EF50011C
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 23:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiDMVZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 17:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbiDMVZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 17:25:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CE16A077
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:23:12 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id u7so5783725lfs.8
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dYAKe9Fpp2p080RFNVrX8nvH48ftci+REg/42hZxgoc=;
        b=nwDnkOa38P1VoIYbkttIE0rGKyT3F3PN9ICR23k5xZJPv7udw9nzhaXDpU2MeS+Q6R
         G7n4BMgGJrU+SgepxYg2qU/L3zAcZp/BR8O7GBZue2XuSjQWbNC5WpD71CukDXO7VS47
         slPyPyCa6ui4Ed2YfQAaCRKSHrWb9O2FF4Ct0wgIMqLCkC9AB0qfeiqL5UIBu1n1nP9g
         2gQgXKMoBYcAVFhLVRXIM8v4hv/fuIDBB7gKVHnxZOuRPz9Xz7i1RNFgQf2/Y824xVNP
         WuIhkLkB31k0g5V7iKS+GKCreRt5g5K0vSauR8kYpYufkFG+dbjlKaP/BJLDeM2L0ZIf
         uBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dYAKe9Fpp2p080RFNVrX8nvH48ftci+REg/42hZxgoc=;
        b=tsbuGMG+SngOyNwK35ACVES34R06swnGXGcLfwHtqfGM0RPgfy7k1mYLQ+pPHeX+Mg
         y9pG8Ilj5S1f/om4S0laRgvzU2rHewdFc4EUlXh8dD4XeSmK0T+mAJdxFj0AffJSI64O
         fzHCUimErBjIHMLw9WFZ4KDZDlplfbNwhEYJyncxmB13eCGRjnrHPO6x8PtMxpUGbkdQ
         N7mXVBYI4pLV3NeuvP17RMLcrw4Mv4uJudNYEadLBNhC0SvPGE2H67QnbmoTqBbJ475C
         mW7vkkNLlCQYTWKetPm7Gf2TBYeEnnIpNRnor0POxmH+96PYhH1iYGOsgBF/PSUuFsxF
         /zkw==
X-Gm-Message-State: AOAM530Zmznsq2tFYB9RCHt99s0FXMIII67+T/uSXgJWDo4CelaR/Qn2
        olhY2OAC6+bC8ex2jSm9q8Nxncf5Er9Nk+dDBzhHOg==
X-Google-Smtp-Source: ABdhPJzr3FVsm7oEAVBg9PQFhteEP/ns+lhODUER5Jh8hvabbPpL5e0XXIARvqMywuPMVxDtDEKCm0Sos0EVpgJ0wu4=
X-Received: by 2002:a05:6512:21cd:b0:46b:b89e:186c with SMTP id
 d13-20020a05651221cd00b0046bb89e186cmr7223606lft.250.1649884990280; Wed, 13
 Apr 2022 14:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com> <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com> <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com> <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
 <YlYhO7GvjKY1cwHr@google.com> <YlcPIYJ0CB2qnfpT@google.com> <YlcWP5Z3osvUg0Ia@google.com>
In-Reply-To: <YlcWP5Z3osvUg0Ia@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 13 Apr 2022 14:22:43 -0700
Message-ID: <CALzav=cg32bxLwCJKG0vBfgKRSXoHmeRnA-NOYC0Px7BsMgfGw@mail.gmail.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
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

On Wed, Apr 13, 2022 at 11:28 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Apr 13, 2022, David Matlack wrote:
> > On Wed, Apr 13, 2022 at 01:02:51AM +0000, Sean Christopherson wrote:
> > > There will be one wart due to unsync pages needing @vcpu, but we can pass in NULL
> > > for the split case and assert that @vcpu is non-null since all of the children
> > > should be direct.
> >
> > The NULL vcpu check will be a little gross,
>
> Yeah, I would even call it a lot gross :-)
>
> > but it should never trigger in practice since eager page splitting always
> > requests direct SPs. My preference has been to enforce that in code by
> > splitting out
>
> It still is enforced in code, just at different points.  The split version WARNs
> and continues after finding a page, the below WARNs and rejects _while_ finding
> the page.
>
> Speaking of WARNs, that reminds me... it might be worth adding a WARN in
> kvm_mmu_get_child_sp() to document (and detect, but more to document) that @direct
> should never encounter an page with unsync or unsync_children, e.g.
>
>         union kvm_mmu_page_role role;
>         struct kvm_mmu_page *sp;
>
>         role = kvm_mmu_child_role(sptep, direct, access);
>         sp = kvm_mmu_get_page(vcpu, gfn, role);
>
>         /* Comment goes here about direct pages in shadow MMUs? */
>         WARN_ON(direct && (sp->unsync || sp->unsync_children));
>         return sp;
>
> The indirect walk of FNAME(fetch)() handles unsync_children, but none of the other
> callers do.  Obviously shouldn't happen, but especially in the huge page split
> case it took me a second to understand exactly why it can't happen.

Will do.

>
> > but I can see the advantage of your proposal is that eager page splitting and
> > faults will go through the exact same code path to get a kvm_mmu_page.
> > __kvm_mmu_find_shadow_page(), but I can see the advantage of your
> > proposal is that eager page splitting and faults will go through the
> > exact same code path to get a kvm_mmu_page.
> >
> > >
> > >             if (sp->unsync) {
> > >                     if (WARN_ON_ONCE(!vcpu)) {
> > >                             kvm_mmu_prepare_zap_page(kvm, sp,
> > >                                                      &invalid_list);
> > >                             continue;
> > >                     }
> > >
> > >                     /*
> > >                      * The page is good, but is stale.  kvm_sync_page does
> > >                      * get the latest guest state, but (unlike mmu_unsync_children)
> > >                      * it doesn't write-protect the page or mark it synchronized!
> > >                      * This way the validity of the mapping is ensured, but the
> > >                      * overhead of write protection is not incurred until the
> > >                      * guest invalidates the TLB mapping.  This allows multiple
> > >                      * SPs for a single gfn to be unsync.
> > >                      *
> > >                      * If the sync fails, the page is zapped.  If so, break
> > >                      * in order to rebuild it.
> > >                      */
> > >                     if (!kvm_sync_page(vcpu, sp, &invalid_list))
> > >                             break;
> > >
> > >                     WARN_ON(!list_empty(&invalid_list));
> > >                     kvm_flush_remote_tlbs(kvm);
> > >             }
