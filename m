Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F783662F77
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 19:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbjAISr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 13:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237227AbjAISrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 13:47:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6166B1A067
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 10:47:23 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qk9so22516131ejc.3
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 10:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VSLCkgRxPXWXMTSkxLq4wqVTmi1HEC8Jc15sBo3hsxU=;
        b=o6BX2rq01AVrJKPxEo13bfQkBfaDVMK+QbxAZSUlU2ecB54iCbjdCSG/9fRT4kFNR2
         9Lkpw/ICRmplQursH2brjIrKyYwCMpcFPev81YyObFN37wUnSCI71Ox2hF7eGH0utLtc
         PThzAHjJOFWiayUCPbqXLzIFGQ56l0tXJlLjxOdoRMZCn26Q8k5l9UFKaOWefkIOPEAf
         /1cF/mCknvjFeS2vQGJqGj/pQm3H6+SD49oR5WHqXTjkyqa1GPJzfPzWTQrzs1ggwodi
         S+MATMuYeJWMpXltu/DRtnz7+En9Ji0pGPt2Awnp6+zFRAfITvjMTM9jRacUJbHg9rTd
         6lOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VSLCkgRxPXWXMTSkxLq4wqVTmi1HEC8Jc15sBo3hsxU=;
        b=l+3mhM0tc3TlgnVpptf7xtu+n/RXWWOmysTBrAjzNReByIvvd/kqhGOPNymXYrRtli
         /Aj+z96CIoMJ8j1hXpHBu4NvmmvKlTZoIVFtJMnuLpiNju19EOPMpWppIrhHLrzYuDil
         iVex9h08CGEwZ7n36P+wZfauFa4mkj0UVMU8wrM/kyPAz3FEKr3uUJqx7ZtkUBbJSAdB
         uYp2f1zlGuXuYoh6ngkBWzyHV7uUvr60NcScBjkH6qiigzj4kiUcSf72lkMyQaHkRRRb
         Z/3PLBBqS/FIhTnPL7jyn9duPkUYm+n9CQ4kCoO+3gebKdA68QngJyqks/TNPGIM0WOu
         Vk+Q==
X-Gm-Message-State: AFqh2kpzXqHyhAl0If3gyBt0KoOt8XXXtn+K+Yzys9BOqkk6FJN0pTvL
        JWvbKEKFYzSlET6RtRqb6F4nXqJL/wsOWyurB4Pj2g==
X-Google-Smtp-Source: AMrXdXvo5wUENKzrMfZI2ewVd2Uu0zsa5mESC6RMQY0/fFvr0uUuVvcJd9KHpXWwQiPUSV+TO9DbGaRFNbFPr9Tk4qw=
X-Received: by 2002:a17:907:91cd:b0:854:cd76:e982 with SMTP id
 h13-20020a17090791cd00b00854cd76e982mr46397ejz.364.1673290041879; Mon, 09 Jan
 2023 10:47:21 -0800 (PST)
MIME-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com> <20221221222418.3307832-5-bgardon@google.com>
 <Y7h7QPI5YcJ/FO02@google.com>
In-Reply-To: <Y7h7QPI5YcJ/FO02@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 9 Jan 2023 10:47:10 -0800
Message-ID: <CANgfPd8uOgTTF4whwyYw_CWnBhUahAauEryVHmFAL2wZNpwR8w@mail.gmail.com>
Subject: Re: [RFC 04/14] KVM: x86/MMU: Expose functions for paging_tmpl.h
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 6, 2023 at 11:49 AM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Dec 21, 2022 at 10:24:08PM +0000, Ben Gardon wrote:
> > In preparation for moving paging_tmpl.h to shadow_mmu.c, expose various
> > functions it needs through mmu_internal.h. This includes modifying the
> > BUILD_MMU_ROLE_ACCESSOR macro so that it does not automatically include
> > the static label, since some but not all of the accessors are needed by
> > paging_tmpl.h.
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 32 ++++++++++++++++----------------
> >  arch/x86/kvm/mmu/mmu_internal.h | 16 ++++++++++++++++
> >  2 files changed, 32 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index bf14e181eb12..a17e8a79e4df 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -153,18 +153,18 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
> >   * and the vCPU may be incorrect/irrelevant.
> >   */
> >  #define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)              \
> > -static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)     \
> > +inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)    \
> >  {                                                            \
> >       return !!(mmu->cpu_role. base_or_ext . reg##_##name);   \
> >  }
> >  BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
> > -BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
> > +static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
> >  BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
> > -BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
> > -BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
> > -BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
> > +static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
> > +static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
> > +static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
> >  BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
> > -BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
> > +static BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
>
> Suggest moving all the BUILD_MMU_ROLE*() macros to mmu_internal.h, since
> they are already static inline. That would be a cleaner patch and reduce
> future churn if shadow_mmu.c ever needs to use a different role accessor
> at some point.

That sounds reasonable. Will do in V1.

>
> >
> >  static inline bool is_cr0_pg(struct kvm_mmu *mmu)
> >  {
> > @@ -210,7 +210,7 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
> >       kvm_flush_remote_tlbs_with_range(kvm, &range);
> >  }
> >
> > -static gfn_t get_mmio_spte_gfn(u64 spte)
> > +gfn_t get_mmio_spte_gfn(u64 spte)
> >  {
> >       u64 gpa = spte & shadow_nonpresent_or_rsvd_lower_gfn_mask;
> >
> > @@ -240,7 +240,7 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
> >       return likely(kvm_gen == spte_gen);
> >  }
> >
> > -static int is_cpuid_PSE36(void)
> > +int is_cpuid_PSE36(void)
> >  {
> >       return 1;
> >  }
>
> Can we just drop is_cpuid_PSE36(), e.g. as a precursor patch? It just
> returns 1...

Yeah, good idea. Looks like we can eliminate a little dead code doing that too.
