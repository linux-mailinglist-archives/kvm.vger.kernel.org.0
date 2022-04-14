Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C329501947
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240239AbiDNQ7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 12:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344391AbiDNQ6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 12:58:45 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAEA9F6E0;
        Thu, 14 Apr 2022 09:32:18 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2ef4a241cc5so54193897b3.2;
        Thu, 14 Apr 2022 09:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fdEEqqrKzs/3274zBD/YaWisZaBNOP4L2LR8YW1baHw=;
        b=epZa5nITfJI2m97kCFx+vNtRg4MHtmfEUMolvICzsn1jko+a8J67e9/CCLceB2vI2M
         lDsf/Wh+Nbm2suVzkaBCWpyOgVi1/9cI0BjenFsVQetNC/l+t+WwF2mJbQioRx5uhn91
         W6pC7sATbmxXXYyomwHDngtqTxwLQe4ErgJpB6mGugt1J0BIomqsHkC/dfT05R5uoS4u
         HJHEL0//3vA0ftkAlyy0Kf3lM0MS3RKYaJICOcDZ7tASW37OQ6s4pUqMOeITKnE8ApFT
         eOD4t+bVKbX0coZB17+BEz967UQpaSRjROjmVZLEhOAGGPtl3FRsGzFra4IOh/F4/Xcn
         asdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fdEEqqrKzs/3274zBD/YaWisZaBNOP4L2LR8YW1baHw=;
        b=sqNUAd2Dm1YfyVV/nLWyJtyivfy8bbgxirvjKm2F/J2FfYxKiBg7DqfvbXTr7Rb4Ub
         d/zISk1H1AroPmcQDmZ5KBi46FQfuKogO07cZDk8rCF9PgfP/J9CEK9H/IeVj4irEaCR
         YhHstDiY+u28LsF+hrSKcqG8rVsfgNRe0iIEJNeX1rMwzdYVIIpMAIOoj/ENK1Q2HOGc
         0OQ1WMlTx3S3ZddXLF5lrgBKpXkttdSNA7Eakvie/OvgQiJzoYwupOQmNuVAD9qjr+za
         ke1jTLKIMJ8hg6IA18eZKG6gVvaMtCOy9kExVtsMw5jSH1pt3SjfVhcJ0xPxclb7Gt3s
         7uHg==
X-Gm-Message-State: AOAM530paMmHuk995wZKZ1K4Jd00MleHKECYSfwJGovOJJA0dJ7xJ7G3
        Jtn8MV4wT9abuTInBSumxeSzrquJK9bDuIccMzs=
X-Google-Smtp-Source: ABdhPJxNu9eO7mTH0mGGXSBUX+pHhpC3Y7C+1R14VEol1GHJTWqG0895N1899gpoMkuMBWuAuLq2FhQU6yyKFPNSCUs=
X-Received: by 2002:a81:db05:0:b0:2ea:2b92:c317 with SMTP id
 u5-20020a81db05000000b002ea2b92c317mr2688217ywm.329.1649953937497; Thu, 14
 Apr 2022 09:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220330132152.4568-1-jiangshanlai@gmail.com> <20220330132152.4568-3-jiangshanlai@gmail.com>
 <YlXvtMqWpyM9Bjox@google.com> <caffa434-5644-ee73-1636-45a87517bae2@redhat.com>
 <YlbhVov4cvM26FnC@google.com> <d2122fb0-7327-0490-9077-c69bbfba4830@redhat.com>
 <YlbtEorfabzkRucF@google.com> <e549d4c4-ca56-da1d-cc50-1a73621ba487@redhat.com>
 <YlhC86CFDRghdd5v@google.com>
In-Reply-To: <YlhC86CFDRghdd5v@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 15 Apr 2022 00:32:05 +0800
Message-ID: <CAJhGHyB642oXE71Sk_NFSgUeeNfk7nkB3zkKugp-iE1z6dEy6Q@mail.gmail.com>
Subject: Re: [RFC PATCH V3 2/4] KVM: X86: Introduce role.glevel for level
 expanded pagetable
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 11:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Apr 13, 2022, Paolo Bonzini wrote:
> > On 4/13/22 17:32, Sean Christopherson wrote:
> > > > > Are we planning on removing direct?
> > > >
> > > > I think so, it's redundant and the code almost always checks
> > > > direct||passthrough (which would be passthrough_delta > 0 with your scheme).
> > >
> > > I'm ok dropping direct and rolling it into target_level, just so long as we add
> > > helpers, e.g. IIUC they would be
> > >
> > > static inline bool is_sp_direct(...)
> > > {
> > >     return !sp->role.target_level;
> > > }
> > >
> > > static inline bool is_sp_direct_or_passthrough(...)
> > > {
> > >     return sp->role.target_level != sp->role.level;
> > > }
> >
> > Yes of course.  Or respectively:
> >
> >       return sp->role.passthrough_levels == s->role.level;
> >
> >       return sp->role.passthrough_levels > 0;
> >
> > I'm not sure about a more concise name for the latter.  Maybe
> > sp_has_gpt(...) but I haven't thought it through very much.
> >
> > > > > Hmm, it's not a raw level though.
> > > >
> > > > Hence the plural. :)
> > >
> > > LOL, I honestly thought that was a typo.  Making it plural sounds like it's passing
> > > through to multiple levels.
> >
> > I meant it as number of levels being passed through.  I'll leave that to
> > Jiangshan, either target_level or passthrough_levels will do for me.
>
> It took me until like 9pm last night to finally understand what you meant by
> "passthrough level".   Now that I actually have my head wrapped around this...
>
> Stepping back, "glevel" and any of its derivations is actually just a combination
> of CR0.PG, CR4.PAE, EFER.LMA, and CR4.LA57.  And "has_4_byte_gpte" is CR0.PG && !CR4.PAE.
> When running with !tdp_enabled, CR0.PG is tracked by "direct".  And with TDP enabled,
> CR0.PG is either a don't care (L1 or nested EPT), or is guaranteed to be '1' (nested NPT).

glevel in the patchset is the page level of the corresponding page
table in the guest, not the level of the guest *root* page table.

role.glevel is initialized as the guest root level, and changed to the
level of the guest page in kvm_mmu_get_page().

role.glevel is a bad name and is not sufficient to handle other
purposes like role.pae_root, role.guest_pae_root.

role.root_level is much better.

role.root_level is a combination of CR0.PG, CR4.PAE, EFER.LMA, and
CR4.LA57 as you said.


>
> So, rather than add yet more synthetic information to the role, what about using
> the info we already have?  I don't think it changes the number of bits that need to
> be stored, but I think the result would be easier for people to understand, at
> least superficially, e.g. "oh, the mode matters, got it".  We'd need a beefy comment
> to explain the whole "passthrough levels" thing, but I think it the code would be
> more approachable for most people.
>
> If we move efer_lma and cr4_la57 from kvm_mmu_extended_role to kvm_mmu_page_role,
> and rename has_4_byte_gpte to cr4_pae, then we don't need passthrough_levels.
> If needed for performance, we could still have a "passthrough" bit, but otherwise
> detecting a passthrough SP would be
>
> static inline bool is_passthrough_sp(struct kvm_mmu_page *sp)
> {
>         return !sp->role.direct && sp->role.level > role_to_root_level(sp->role);
> }
>
> where role_to_root_level() is extracted from kvm_calc_cpu_role() is Paolo's series.
>

I'm going to add

static inline bool sp_has_gpte(struct kvm_mmu_page *sp)
{
   return !sp->role.direct && (

   /* passthrough */
   sp->role.level > role_to_root_level(sp->role) ||

   /* guest pae root */
   (sp->role.level == 3 && role_to_root_level(sp->role) == 3)

   );
}

And rename for_each_gfn_indirect_valid_sp() to
for_each_gfn_valid_sp_has_gpte() which use sp_has_gpte() instead.

I'm not objecting using efer_lma and cr4_la57. But I think role.root_level
is more convenient than role_to_root_level(sp->role).

cr4_pae, efer_lma and cr4_la57 are more natrual than has_4_byte_gpte
and root_level.
