Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6AE5A71FA
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiH3Xsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiH3Xsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:48:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE24367C93
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:48:50 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id az24-20020a05600c601800b003a842e4983cso4516368wmb.0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=tGVEnlLMpBamjr5zlczXq7fmwaznwoQ3idHABhgUuYM=;
        b=KO+U0jA43GLZcwdXeyIX5nApqOewvbCN/kEwEioSXyjvoFoRRmxVAcOEse3v+CVhbj
         jLnHHxVADcF5HhHRpQWGwFrUyrKwk/ndVvQHr5H0dAMUG9zgcyZoOT4OnkbuHncsWNgp
         IkNnbqP9J0Dxp7txF3JCyMDpfIQ1B2h7kA+vEyRJqPQlMXi0WVQapPgKkZ3OF2ek4sMn
         p7/0r48ezijpvcOm73x2lrXy/ZNJIVDm0GMPqolOSYldXS2Sms+cdrIs9fxhD8wqcVvN
         GHItupLX5AYb2kO185XF6k+WC4V1D2cTOf9gvnN9lUQf3v7aPT+RAye8vYV/E7rrdfK6
         dVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tGVEnlLMpBamjr5zlczXq7fmwaznwoQ3idHABhgUuYM=;
        b=dPqh2MhQwJfESLgwNFmbYnJ04KeOzCBA/QxY9ofhGFligKnC27cjHHxWF+XWJv6UP5
         qhOEb2xMV1sqpxQ3Zn/npRKZpbq5ypCz2S9t0EswH7YaXkxqo1YgHQJ5ZfMQ6zZTs/5E
         9/YqgVgIKJ2awZ0XBmj9epEJKn9Gt8KhgnUKDPSIPQRVL6wHavXl80Uys+WEtbX50F2f
         HAKAH/P7L0p2Hrc8vF/IVrb3LU+0zg06ilIOVMaYkevT9PBFR3FI/+qg6Niu46FwIDPo
         FdvFVe1wxrwgdHscsWJ6sp7jlIomAtLlkE7W2xhbKcj3e7IpgMwQR4iCXNYBWC3s4xg/
         flxw==
X-Gm-Message-State: ACgBeo3HPRHSvqWTejO83SDOIZjBzeX4d/gAWGSzB9MucZOca+fCPWRP
        jNkVHEkY0R+Oo4Ub6TxdSRMQUnZmGa0mSGlpfmtD4g==
X-Google-Smtp-Source: AA6agR7kuj8FMBlUqHe1KsZByANta0qdtZ6dMTJPpi0P8kKLcTUdSOfhQ26jHFWjNyun/bjf1Y0GHPcdkLlVKxphkH4=
X-Received: by 2002:a05:600c:1e05:b0:3a5:b441:e9c with SMTP id
 ay5-20020a05600c1e0500b003a5b4410e9cmr231944wmb.24.1661903329205; Tue, 30 Aug
 2022 16:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-4-yosryahmed@google.com> <Ywkq8HYyTI1eStSO@google.com>
 <Yw6GoWY411PrIRMx@google.com>
In-Reply-To: <Yw6GoWY411PrIRMx@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 30 Aug 2022 16:48:12 -0700
Message-ID: <CAJD7tkafp25jfH1cTQksMa-xt6bAu3LKEWT0pCNYqtijhvjRYQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
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

On Tue, Aug 30, 2022 at 2:52 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 26, 2022, Sean Christopherson wrote:
> > On Tue, Aug 23, 2022, Yosry Ahmed wrote:
> > > Count the pages used by KVM mmu on x86 in memory stats under secondary
> > > pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> > > visibility into the memory consumption of KVM mmu in a similar way to
> > > how normal user page tables are accounted.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
> > >  2 files changed, 26 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e418ef3ecfcb..4d38e4eba772 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1665,6 +1665,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
> > >     percpu_counter_add(&kvm_total_used_mmu_pages, nr);
> > >  }
> > >
> > > +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > > +{
> > > +   kvm_mod_used_mmu_pages(kvm, +1);
> > > +   kvm_account_pgtable_pages((void *)sp->spt, +1);
> > > +}
> > > +
> > > +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > > +{
> > > +   kvm_mod_used_mmu_pages(kvm, -1);
> > > +   kvm_account_pgtable_pages((void *)sp->spt, -1);
> > > +}
> >
> > Hrm, this is causing build on x86 issues for me.  AFAICT, modpost doesn't detect
> > that this creates a new module dependency on __mod_lruvec_page_state() and so doesn't
> > refresh vmlinux.symvers.
> >
> >   ERROR: modpost: "__mod_lruvec_page_state" [arch/x86/kvm/kvm.ko] undefined!
> >   make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
> >   make[1]: *** [Makefile:1769: modules] Error 2
> >   make[1]: *** Waiting for unfinished jobs....
> >   Kernel: arch/x86/boot/bzImage is ready  (#128)
> >   make[1]: Leaving directory '/usr/local/google/home/seanjc/build/kernel/vm'
> >   make: *** [Makefile:222: __sub-make] Error 2
> >
> > Both gcc and clang yield the same behavior, so I doubt it's the compiler doing
> > something odd.  Cleaning the build makes the problem go away, but that's a poor
> > band-aid.
> >
> > If I squash this with the prior patch that adds kvm_account_pgtable_pages() to
> > kvm_host.h, modpost detects the need to refresh and all is well.
> >
> > Given that ARM doesn't support building KVM as a module, i.e. can't run afoul
> > of whatever modpost weirdness I'm hitting, I'm inclined to squash this with the
> > previous patch and punt on the modpost issue so that we can get this merged.
> >
> > Any objections?  Or thoughts on what's going wrong?
>
> Pushed the series with the squash to branch `for_paolo/6.1` at:
>

Thanks Sean!

>     https://github.com/sean-jc/linux.git
>
> Unless you hear otherwise, it will make its way to kvm/queue "soon".
>
> Please yell if there are objections.
