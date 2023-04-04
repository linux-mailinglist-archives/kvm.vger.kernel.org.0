Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A996D6F13
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 23:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbjDDVje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 17:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbjDDVjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 17:39:32 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463594216
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 14:39:31 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-17aeb49429eso36253396fac.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 14:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680644370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgsHBuR1JCiS/kCWx0dnvnASkNVPo+HZZkzbYVM3KlI=;
        b=MuNihkv60/dw1sHWeHVoLEdQZgd3CzvUoCDIeu6Deb6Bvxj+65j/nLvrl1fXz61C6j
         Q0DQSwOqdN6iOsDGzhEXgLFK2zr5E3plsQI75C3Ii668c/H9SOyfWOM+/dvNQDh8VDdX
         stjzXWOzCZ6ACbiLOCSpf9oX/I9/2zaBpedGv0t/ETkkcJOwZMMNZ6bU/lha0HVf6Ovo
         9JKcc1xHp5YTNeUYzEO0vBj+kBySh3Ma0TJLvygYHWfA7AGRdcDxfdcxE0OvtaGBzrzq
         ddHITrM42b5EGo7g+x+FbtybeSyi2mTuuHB/GP0pXADhJH19IlUy+4SMmZRdrBhLLMRs
         L8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680644370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgsHBuR1JCiS/kCWx0dnvnASkNVPo+HZZkzbYVM3KlI=;
        b=fS/3dyoPPyWGsKoJzQ5x/3WzQyVwjigWuB73VS+znaUX+B4AOF8ELEFZ1OMPDNrCko
         DbHmRcDvnRXlusaokE0MyOil7vQ9V8wApGtzni3FYAtqKAvL6XdZV/3frn4sVxCKE8KU
         nwcG3Hlk9eLYCn7b/wcl2wUOauG8Q4DKx3+L1LFJON6MpLaOvIDMNlRQyNodmf/33Ljz
         YkaTCw5l7SOGj7BtQWJfByBDOVFs3I095iUDUixNeokEM2ZFZ/ku6WP1v/yfXjItGPEM
         C6aGEvsJ4HMiFXJwBIdP93iQ9t7zs7Z6RfgC3yMLTifk6k8+LYMZ8aKJQL+UJYT+Gnzy
         cUqg==
X-Gm-Message-State: AAQBX9cNgC4gghkFLc65pa1cSDALCuqMb/UkXHwo4pkGvex6D0TlPR+Z
        yqG8f/aN3McH5DPYxemmm9LxAiuSL7BbwbypA3DVbA==
X-Google-Smtp-Source: AKy350YI01RZ913r86Uj+mNlWwCKJQaqcSjvbxMsdhMGQNm7HvIq/UI90tkqfhSR5EWKc3FXTsEzo5hVt4+WfEhUTD0=
X-Received: by 2002:a05:6870:339e:b0:17e:7674:8df0 with SMTP id
 w30-20020a056870339e00b0017e76748df0mr1941907oae.9.1680644370441; Tue, 04 Apr
 2023 14:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-3-rananta@google.com>
 <ZCTjirkCgBkT65eP@linux.dev> <CAJHc60y1BLQC4c0qXCuqF7JfewBC_fG2xuH0Wj0AHJh9x3CK5g@mail.gmail.com>
 <ZCxvXq0dftq/Szra@linux.dev>
In-Reply-To: <ZCxvXq0dftq/Szra@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 4 Apr 2023 14:39:18 -0700
Message-ID: <CAJHc60x2kkkHi=tO4UymOeFeKA315bibhHgSeXZpdEReFUh4-g@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Add FEAT_TLBIRANGE support
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 4, 2023 at 11:41=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Apr 03, 2023 at 10:26:01AM -0700, Raghavendra Rao Ananta wrote:
> > Hi Oliver,
> >
> > On Wed, Mar 29, 2023 at 6:19=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Mon, Feb 06, 2023 at 05:23:35PM +0000, Raghavendra Rao Ananta wrot=
e:
> > > > Define a generic function __kvm_tlb_flush_range() to
> > > > invalidate the TLBs over a range of addresses. The
> > > > implementation accepts 'op' as a generic TLBI operation.
> > > > Upcoming patches will use this to implement IPA based
> > > > TLB invalidations (ipas2e1is).
> > > >
> > > > If the system doesn't support FEAT_TLBIRANGE, the
> > > > implementation falls back to flushing the pages one by one
> > > > for the range supplied.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_asm.h | 18 ++++++++++++++++++
> > > >  1 file changed, 18 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/=
asm/kvm_asm.h
> > > > index 43c3bc0f9544d..995ff048e8851 100644
> > > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > > @@ -221,6 +221,24 @@ DECLARE_KVM_NVHE_SYM(__per_cpu_end);
> > > >  DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
> > > >  #define __bp_harden_hyp_vecs CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
> > > >
> > > > +#define __kvm_tlb_flush_range(op, mmu, start, end, level, tlb_leve=
l) do {    \
> > > > +     unsigned long pages, stride;                                 =
           \
> > > > +                                                                  =
           \
> > > > +     stride =3D kvm_granule_size(level);                          =
             \
> > >
> > > Hmm... There's a rather subtle and annoying complication here that I
> > > don't believe is handled.
> > >
> > > Similar to what I said in the last spin of the series, there is no
> > > guarantee that a range of IPAs is mapped at the exact same level
> > > throughout. Dirty logging and memslots that aren't hugepage aligned
> > > could lead to a mix of mapping levels being used within a range of th=
e
> > > IPA space.
> > >
> > Unlike the comment on v1, the level/stride here is used to jump the
> > addresses in case the system doesn't support TLBIRANGE. The TTL hint
> > is 0.
>
> Right. So we agree that the level is not uniform throughout the provided
> range. The invalidation by IPA is also used if 'pages' is odd, even on
> systems with TLBIRANGE. We must assume the worst case here, in that the
> TLBI by IPA invalidated a single PTE-level entry. You could wind up
> over-invalidating in that case, but you'd still be correct.
>
Sure, let's always assume the stride as 4k. But with
over-invalidation, do you think the penalty is acceptable, especially
when invalidating say >2M blocks for systems without TLBIRANGE?
In __kvm_tlb_flush_vmid_range(), what if we just rely on the iterative
approach for invalidating odd number pages on systems with TLBIRANGE.
For !TLBIRANGE systems simply invalidate all of TLB (like we do
today). Thoughts?

Thank you.
Raghavendra


> > That being said, do you think we can always assume the least possible
> > stride (say, 4k) and hardcode it?
> > With respect to alignment, since the function is only called while
> > breaking the table PTE,  do you think it'll still be a problem even if
> > we go with the least granularity stride?
>
> I believe so. If we want to apply the range-based invalidations generally
> in KVM then we will not always be dealing with a block-aligned chunk of
> address.
>
> > > > +     start =3D round_down(start, stride);                         =
             \
> > > > +     end =3D round_up(end, stride);                               =
             \
> > > > +     pages =3D (end - start) >> PAGE_SHIFT;                       =
             \
> > > > +                                                                  =
           \
> > > > +     if ((!system_supports_tlb_range() &&                         =
           \
> > > > +          (end - start) >=3D (MAX_TLBI_OPS * stride)) ||          =
             \
> > >
> > > Doesn't checking for TLBIRANGE above eliminate the need to test again=
st
> > > MAX_TLBI_OPS?
> > >
> > Derived from __flush_tlb_range(), I think the condition is used to
> > just flush everything if the range is too large to iterate and flush
> > when the system doesn't support TLBIRANGE. Probably to prevent
> > soft-lockups?
>
> Right, but you test above for system_supports_tlb_range(), meaning that
> you'd unconditionally call __kvm_tlb_flush_vmid() below.
>
> > > > +         pages >=3D MAX_TLBI_RANGE_PAGES) {                       =
             \
> > > > +             __kvm_tlb_flush_vmid(mmu);                           =
           \
> > > > +             break;                                               =
           \
> > > > +     }                                                            =
           \
> > > > +                                                                  =
           \
> > > > +     __flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, =
false);    \
> > > > +} while (0)
>
> --
> Thanks,
> Oliver
