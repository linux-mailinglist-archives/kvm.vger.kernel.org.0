Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A5B6D6E78
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 22:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbjDDU7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 16:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236159AbjDDU7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 16:59:45 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E50B49D6
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 13:59:44 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id f4-20020a9d0384000000b0069fab3f4cafso18048705otf.9
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 13:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680641983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8XB956O45UzVksOyeGhwxzyBdQXHDRc1Q4yj23qYiJg=;
        b=RN3hkQEhO24vo0vfwd4s0t68KhyLFB5bobj6eS6kQ1lCvGABwa562qwkSJpKBLhHsI
         j9WyV/bZ9XUUkmDYf+xx+nqLQRXXyoH1MuACy1KypDYbTisxMcFFPsQ27f1Wt48z1eCe
         Eff/XBDWq153oNecKmgeVWIXX2Wk5Cl2Wz2mDFmKW4gLy/ix+eYT7xT7Z8Onc9v69H+P
         akaXzFzIepYWUiCTz/CfJFD8qj4ynB6JoyOmjfvskEHLgdwgbEkTOaNBwplMqrR2YZQl
         92xCtdgJd+LiU2AY20nwNoj0e73AWfEbcYIiJBKhfeBA1W8r725EEmwGfIftOIdiMXdj
         dSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680641983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XB956O45UzVksOyeGhwxzyBdQXHDRc1Q4yj23qYiJg=;
        b=lTvH7Elf+WQ1qhzTyOv8ruCCM0Rs1L4PkjCNInMzIErhXui3Y8ydSlwBeCAICFHTN5
         /y+ZyVivakXnZCcV3t7HFS37dt1Gh4sfTyfIskVqj4tk4h/ud4PFdtKsUYMlY/XqroSN
         zfst9xnFxVwoRmixbPLqbIHVW+Q7xIQrBrKA80VW+HYRGSkJxNHKPliEalJEmAMCs6bs
         iYfSDN3WzvgrKNEQezbF1RmJ05JKa5473RcfEEzuevU4h4D3p/z/lRxlRV72HaygH0X6
         nZBZq6NeTaP/hj7MeMGgQvFDJmCdvconoeT9oGH43Wh1mT0tQQI8i2pLzgTfOLA1Pxyj
         y5Bw==
X-Gm-Message-State: AAQBX9cdIXzMvRN51DjZiLO+aW2L0D0RKAfqy+MleFovG5bVDFpqmVm/
        R0UgIFXDCBq4fwI6X+IIwIO/2cM5pAETPyoL6mxZjQ==
X-Google-Smtp-Source: AKy350Yb1ENyDDt/RXMy8DJfza/HP2Xi2qT3CKtQ2KekykdBNnmTfFThnO0XbepJYeJpk18FCS4o4myYZqokMZsT8/Y=
X-Received: by 2002:a9d:6191:0:b0:699:7883:940d with SMTP id
 g17-20020a9d6191000000b006997883940dmr1276983otk.7.1680641983242; Tue, 04 Apr
 2023 13:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-5-rananta@google.com>
 <ZCTdcJLxWBRXItSM@linux.dev> <CAJHc60xbhyiVieqzeMcB1S7UWw_J3Jyh8PqjA9GLOhudja5nmA@mail.gmail.com>
 <ZCx13Q4nyRghItcI@linux.dev>
In-Reply-To: <ZCx13Q4nyRghItcI@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 4 Apr 2023 13:59:31 -0700
Message-ID: <CAJHc60z49Hfp0j39owGP1f+5Jv496ViVUfduAvSO36sv_2C1OA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
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

On Tue, Apr 4, 2023 at 12:09=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Apr 03, 2023 at 02:23:17PM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Mar 29, 2023 at 5:53=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Mon, Feb 06, 2023 at 05:23:37PM +0000, Raghavendra Rao Ananta wrot=
e:
> > > > Implement kvm_arch_flush_remote_tlbs_range() for arm64,
> > > > such that it can utilize the TLBI range based instructions
> > > > if supported.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  3 +++
> > > >  arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
> > > >  2 files changed, 18 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include=
/asm/kvm_host.h
> > > > index dee530d75b957..211fab0c1de74 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> > > >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > > >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > > >
> > > > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_=
gfn, u64 pages);
> > > > +
> > > >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> > > >  {
> > > >       return false;
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index e98910a8d0af6..409cb187f4911 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> > > >       return 0;
> > > >  }
> > > >
> > > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_=
gfn, u64 pages)
> > > > +{
> > > > +     phys_addr_t start, end;
> > > > +
> > > > +     if (!system_supports_tlb_range())
> > > > +             return -EOPNOTSUPP;
> > >
> > > There's multiple layers of fallback throughout this series, as it wou=
ld
> > > appear that deep in __kvm_tlb_flush_range() you're blasting the whole
> > > VMID if either the range is too large or the feature isn't supported.
> > >
> > > Is it possible to just normalize on a single spot to gate the use of
> > > range-based invalidations? I have a slight preference for doing it de=
ep
> > > in the handler, as it keeps the upper layers of code a bit more
> > > readable.
> > >
> > I was a little skeptical on this part, since the
> > kvm_arch_flush_remote_tlbs_range() expects to return -EOPNOTSUPP if
> > indeed there's no support.
>
> Well, the arch-neutral code can expect whatever it wants :) The only
> real contract we have with it is to return 0 iff the specified range has
> been invalidated, even if that comes with over-invalidating.
>
> > But I see your point. The if-else in kvm_pgtable_stage2_flush_range()
> > seems redundant and I can simply manage this conditions inside
> > __kvm_tlb_flush_range_vmid_ipa() itself, but I'll leave the
> > kvm_arch_flush_remote_tlbs_range()'s implementation as is. Thoughts?
>
> The largest concern I had is that the series is testing for FEAT_TLBIRANG=
E
> all over the shop and I just raised that concern on this patch. AFAICT,
> the iterative approach to invalidating a range of IPAs is effectively
> dead code, as all flows into __kvm_tlb_flush_range_vmid_ipa() are gated
> by system_supports_tlb_range() somewhere.
>
> Personally, I prefer keeping the higher level software models making
> aggressive use of range-based interfaces and letting the actual
> implementation under the hood select the appropriate instruction. That
> helps readability, as it directly communicates the expected outcome of
> the invalidation.
>
> So, if you want to make use of the iterative approach to TLB invalidation=
s on
> !TLBIRANGE systems, then this function should _not_ return EOPNOTSUPP.
>
Thanks for the explanation. I can make the calls consistent across the
code, and let the actual handler deal TLBIRANGE support.

- Raghavendra
> --
> Thanks,
> Oliver
