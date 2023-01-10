Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A97664783
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbjAJRgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjAJRgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:36:09 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3407642B
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:36:06 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-150b06cb1aeso12845669fac.11
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=izLnKJo3NnuVz6+xH34RW6V0lANIYRq3mZ7+s+Gq/Rg=;
        b=cnO2zDRO2RO+f+bjFcK5ttWZEMhTCLlLIOTBfRmKm4hMPIARy0GJ+7RUdrFlM3/4hJ
         2NOsiPrlfj6NtD3viyW0M2Tj2Ito5g9J+8kFSQOrXG/Ik6sPvcJqUvua+VLmhHTpPcpE
         90kXQVTEm9pXNSpR+in4J57XoSMUTxvtrwKtQu0jTzD1MewFEf+7t6NM5ARkfXUSu+pH
         5A9UtOV2RrWJR98Ze//VemhYPskanwzxG1vNB+UYog4L1mUJHYCqkk8zretDJA9U62tL
         LrzlAZJGHa5Mg1gEvZN7nGBiIdsYHvaAVUXCX+o7acCw+Ch2wgfkVIwMgtoSz0ffKVzN
         sq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izLnKJo3NnuVz6+xH34RW6V0lANIYRq3mZ7+s+Gq/Rg=;
        b=a3aP1oi0O5EJL3SpKjkJ485MHY1UTl1gPemuekmN/FrtcukMA9GzGKvJJDkde/zSbf
         Gct6MjCUEZKBnqFuxCdl9o0SDE+5arXwPk18LNQa4y3enH7G09cy3HKUW+RmOzKOD9XC
         K47YD6lPFVghKNy8FUdxp/FaR7IEaR+OH+DwQ3619uF7rAxx0lKU+vmARc48mpZUI5XO
         kB4G3F0G1QCa2pKOwP/CRKBJ4aGmk51oJLhQoJ6VVAcMPwUlcfC6o9XczaRuC5hRmdFC
         tV5ho/3vcKhylOiF7Ky/ZAC0D8bfa3tUv/ZGGg4p7drq42GNhyVN4OPzJXAMsJvxydmR
         U2lg==
X-Gm-Message-State: AFqh2kqHW6TH+TKSnn5LzfovBAcm4J2nGmSe9lwcsdTK/hExfB+gOfXZ
        nrkmCLzt5sJxPTtyJGlEvyIAS5silWM5ycJuEgEUIw==
X-Google-Smtp-Source: AMrXdXuJ/riFg6KAidqJrw3ToWKW0YlE99K2uIfcSlIQ+4dH7LaudwxBiRWmQNQ5clFUoBCErV7kbfON1SU6k0huLA8=
X-Received: by 2002:a05:6870:6327:b0:15b:d2e:d059 with SMTP id
 s39-20020a056870632700b0015b0d2ed059mr888917oao.179.1673372165985; Tue, 10
 Jan 2023 09:36:05 -0800 (PST)
MIME-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com> <20230109215347.3119271-4-rananta@google.com>
 <Y7ymEiU1ZC/gzs9s@google.com>
In-Reply-To: <Y7ymEiU1ZC/gzs9s@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 10 Jan 2023 09:35:54 -0800
Message-ID: <CAJHc60yJwoC+OAYX3KmJuG2dM+ER3OWSXtEYKkE2i4FL_W=ZKw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] KVM: Define kvm_flush_remote_tlbs_range
To:     David Matlack <dmatlack@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Mon, Jan 9, 2023 at 3:41 PM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Jan 09, 2023 at 09:53:44PM +0000, Raghavendra Rao Ananta wrote:
> > Define kvm_flush_remote_tlbs_range() to limit the TLB flush only
> > to a certain range of addresses. Replace this with the existing
> > call to kvm_flush_remote_tlbs() in the MMU notifier path.
> > Architectures such as arm64 can define this to flush only the
> > necessary addresses, instead of the entire range.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c     | 10 ++++++++++
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/kvm_main.c      |  7 ++++++-
> >  3 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 39d9a334efb57..70f76bc909c5d 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -91,6 +91,16 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >       kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> >  }
> >
> > +void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)
> > +{
> > +     struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > +
> > +     if (system_supports_tlb_range())
> > +             kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, start, end, 0);
> > +     else
> > +             kvm_flush_remote_tlbs(kvm);
> > +}
> > +
> >  static bool kvm_is_device_pfn(unsigned long pfn)
> >  {
> >       return !pfn_is_map_memory(pfn);
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f51eb9419bfc3..a76cede9dc3bb 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
> >  void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
> >
> >  void kvm_flush_remote_tlbs(struct kvm *kvm);
> > +void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end);
> >
> >  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> >  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 03e6a38094c17..f538ecc984f5b 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -376,6 +376,11 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >               ++kvm->stat.generic.remote_tlb_flush;
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> > +
> > +void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)
>
> It's ambiguous what start/end represent. Case in point,
> __kvm_handle_hva_range() is passing in HVAs but then patch 4 passes in
> GFNs.
>
> Probably kvm_flush_tlbs_range() should accept GFN and there can be a
> helper wrapper that does the HVA-to-GFN conversion.
>
> > +{
> > +     kvm_flush_remote_tlbs(kvm);
> > +}
>
You are right, that should've been GFNs, and the function should
operate on GPAs. I can think about a wrapper.

> FYI I also proposed a common kvm_flush_remote_tlbs() in my Common MMU
> series [1].
>
> Could I interest you in grabbing patches 29-33 from that series, which
> has the same end result (common kvm_flush_remote_tlbs_range()) but also
> hooks up the KVM/x86 range-based flushing, and folding them into this
> series?
>
Of course! I'll grab them in my next version.

Thank you.
Raghavendra

> [1] https://lore.kernel.org/kvm/20221208193857.4090582-33-dmatlack@google.com/
>
> >  #endif
> >
> >  static void kvm_flush_shadow_all(struct kvm *kvm)
> > @@ -637,7 +642,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
> >       }
> >
> >       if (range->flush_on_ret && ret)
> > -             kvm_flush_remote_tlbs(kvm);
> > +             kvm_flush_remote_tlbs_range(kvm, range->start, range->end - 1);
> >
> >       if (locked) {
> >               KVM_MMU_UNLOCK(kvm);
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
