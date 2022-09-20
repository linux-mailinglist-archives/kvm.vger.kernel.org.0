Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665155BEC85
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 20:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiITSJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 14:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiITSJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 14:09:08 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56A065242
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:09:06 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id i3so2242416qkl.3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=PeN1RcuQCUj1AaYPYRKMExfsBbior2SClHPctysKngU=;
        b=ggFCO0+hykBT6WHMuAite/PFcgFf/Y7+JkO6OFit1JV+mBnMrmPqlh51H8nJcdEva4
         hhEoN82FclFB2lqCsyBzur8cuC4qQIAMpVNeZRbELgzh2aiqqLUyGXdNAPE4lZmF/sMr
         WaDppnlEWZTkYqbb6UaE9BU+1F7dz/0jeT4YR2X7M7wDTMwxP6mTjWMzYOimq12e57Wr
         5kBFfsZSBH9pn3tdXOaOIiWKBm/PTeQrGz8s/qjLFqtRtT7Ie3O90r/oDmoalw+3th0s
         qktVwh65HMegNkhCrAT3PVrvBSfEt1G3zeWftltwPZXhfxJ/NkVdrEA3gsp1hRUVrFa2
         iRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PeN1RcuQCUj1AaYPYRKMExfsBbior2SClHPctysKngU=;
        b=HczOMmxLJ+ADlkvTwxq+iXuYQHrAdwk8SumBu+SCVGs8D6x21fLquwzqTV0PLJI2Wl
         pmRZGyUBhTybBXAokpu40gOm70bAc/Lwof6HjoHRUaop5IJ6EDXMi8Fs2pjnpoIzUQbl
         swNlPGKSz0RW6lT5Hevxt4NRd6xI3hCAmhh8HzzF0rr3necEV4g6EzP3fp/naPOE2LcV
         Ac1tltRIGhI6j+5P6Zo5hE7/7v1DlDUH/k7GMGPvErVMc76KHEqVy2EsyTLmWuuKq0S/
         MmU7titZo2fmDx/B5ywnIhpbEfZe3zOErxVOnj2OBqzrYm1RPEeqj742tE27DsMfIpgo
         UpWA==
X-Gm-Message-State: ACrzQf3U5pxaNkKGLheQsS521MiaFZpeXe1nbaNmbmn0cJRthqX18wzz
        5MJvmQ7x2qxCO+bkMU+zxW961bjsPpTrlznP6M0ToQ==
X-Google-Smtp-Source: AMsMyM4V9BFblFd1GBs4ErrZZNitnuQsNJNObS7a+nR7d7JhHTXU0bVlYsv0ZSpUSe88sX4NjDAUg1VSSrdAnv/dzRE=
X-Received: by 2002:a05:620a:4447:b0:6c6:c438:1ced with SMTP id
 w7-20020a05620a444700b006c6c4381cedmr18055169qkp.658.1663697345804; Tue, 20
 Sep 2022 11:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
 <YxjYWtgLZMxFBrjl@google.com> <20220913120721.GA113257@k08j02272.eu95sqa> <CACZJ9cWP6fXNHuL6r3sHkTDEtR8q1Aw=7DG2Mkj24XCONNL+Yg@mail.gmail.com>
In-Reply-To: <CACZJ9cWP6fXNHuL6r3sHkTDEtR8q1Aw=7DG2Mkj24XCONNL+Yg@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 20 Sep 2022 11:08:39 -0700
Message-ID: <CALzav=f4nTrG6vxvrhnYgnFQCjHbRRj+qGQUR6m-ev08bcCuMg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in validate_direct_spte()
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     Hou Wenlong <houwenlong.hwl@antgroup.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Sep 15, 2022 at 4:47 AM Liam Ni <zhiguangni01@gmail.com> wrote:
>
> On Tue, 13 Sept 2022 at 20:13, Hou Wenlong <houwenlong.hwl@antgroup.com> =
wrote:
> >
> > On Thu, Sep 08, 2022 at 01:43:54AM +0800, David Matlack wrote:
> > > On Wed, Aug 24, 2022 at 05:29:18PM +0800, Hou Wenlong wrote:
> > > > The spte pointing to the children SP is dropped, so the
> > > > whole gfn range covered by the children SP should be flushed.
> > > > Although, Hyper-V may treat a 1-page flush the same if the
> > > > address points to a huge page, it still would be better
> > > > to use the correct size of huge page. Also introduce
> > > > a helper function to do range-based flushing when a direct
> > > > SP is dropped, which would help prevent future buggy use
> > > > of kvm_flush_remote_tlbs_with_address() in such case.
> > > >
> > > > Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new=
 one to flush a specified range.")
> > > > Suggested-by: David Matlack <dmatlack@google.com>
> > > > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
> > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index e418ef3ecfcb..a3578abd8bbc 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -260,6 +260,14 @@ void kvm_flush_remote_tlbs_with_address(struct=
 kvm *kvm,
> > > >     kvm_flush_remote_tlbs_with_range(kvm, &range);
> > > >  }
> > > >
> > > > +/* Flush all memory mapped by the given direct SP. */
> > > > +static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struc=
t kvm_mmu_page *sp)
> > > > +{
> > > > +   WARN_ON_ONCE(!sp->role.direct);
> > > > +   kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> > > > +                                      KVM_PAGES_PER_HPAGE(sp->role=
.level + 1));
>
> Do we need "+1" here?    sp->role.level=3D1 means 4k page.
> I think here should be   =E2=80=9CKVM_PAGES_PER_HPAGE(sp->role.level)=E2=
=80=9D

Yes we need the "+ 1" here. kvm_flush_remote_tlbs_direct_sp() must
flush all memory mapped by the shadow page, which is equivalent to the
amount of memory mapped by a huge page at the next higher level. For
example, a shadow page with role.level =3D=3D PG_LEVEL_4K maps 2 MiB of
the guest physical address space since 512 PTEs x 4KiB per PTE =3D 2MiB.

>
> > >
> > > nit: I think it would make sense to introduce
> > > kvm_flush_remote_tlbs_gfn() in this patch since you are going to
> > > eventually use it here anyway.
> > >
> > OK, I'll do it in the next version. Thanks!
> >
> > > > +}
> > > > +
> > > >  static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 =
gfn,
> > > >                        unsigned int access)
> > > >  {
> > > > @@ -2341,7 +2349,7 @@ static void validate_direct_spte(struct kvm_v=
cpu *vcpu, u64 *sptep,
> > > >                     return;
> > > >
> > > >             drop_parent_pte(child, sptep);
> > > > -           kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gf=
n, 1);
> > > > +           kvm_flush_remote_tlbs_direct_sp(vcpu->kvm, child);
> > > >     }
> > > >  }
> > > >
> > > > --
> > > > 2.31.1
> > > >
