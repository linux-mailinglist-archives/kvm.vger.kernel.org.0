Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35D3E9B2C
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 01:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhHKXTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 19:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhHKXTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 19:19:54 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C5EC061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 16:19:30 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j1so6150342pjv.3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 16:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+bX2sp1axxYnWFlZJMUhX3cjK2cHR4yyuMcVt3BXJss=;
        b=oYWqOxyInvJb6AVVC2Cav5hFXNaHuZ8QmueHRT2WOJpB7VfpmYxTucORfPon/oYo4y
         kY1fbRNnacIp0Qxc1DrwRIN+bKRzbE5zxmqm6QBdURg/raB2GPzOEwr8IPcgTQJ/Uwux
         gNtjSg03umLkRkPyjvDtwlvWufYhM1hS8IRHhZNLwxxI/Oc3YN61NeSYgN07Z1aNNzqH
         4OlzC5HXtYCwavy6C7CQ1ZvrmmfDxweMjrXX+QserseYCTzpMX8lUACqX5NEhRVZBz4c
         E/P0qXvDHeTcYOtY+8qZVDghBYJRFptDTZiAshcygoO3NlQQ9T6c8U8Sg7yZxnr7UrmY
         W7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+bX2sp1axxYnWFlZJMUhX3cjK2cHR4yyuMcVt3BXJss=;
        b=luxepzhbWfly0kDptcs7c5+P2PJEUC79Gs1nQtYpq0S2bffRyMVJHNjhzSI2SxxHIK
         uLqXVZXbcWzAOGyKXiBf91I5widJcHmDVpQxV3Y6jvfLjByL3NjzwE9GTV3OxU85oAar
         rrqhhlzopau+bUfxBjnfr7ECIW9JnkOU7qm8vk8tpDp2pDf8eeN/r1nF2e/xwY21ZPbg
         /YjwVy0phewMsZ7NrCTrRYr/hVYKjd830DhLzMcPamqewt5qe2KfEcIpBUVgaSFG/HbX
         Tbg1VIgl3r/ur3Fxkf++JWDYdahpIsIkUPdDWKw8J8qBMPkNGIy9WQmzVVxqena1jbqI
         xGTQ==
X-Gm-Message-State: AOAM5300eXoj4hywHXzTtfXqUqs9/uJldyUevg10Qv+i6elCAodo587L
        6Ml7MsDP7IIhWlIRshBQFk6QVYhyX3uivrqKjKN8sw==
X-Google-Smtp-Source: ABdhPJwewKtmXnDM8ZgPyXzOKv/BE5te6txj0j/4JtJJ6n6C+JCR2DiOeULE/a1zgn9AU14vGHamcKJt//WU/AvisCE=
X-Received: by 2002:a63:48c:: with SMTP id 134mr1070380pge.122.1628723969337;
 Wed, 11 Aug 2021 16:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210810223238.979194-1-jingzhangos@google.com>
 <CAM3pwhH+c9K0X5me7668QBjtT3vomZdToG8k6u-f5bXvNYuLNg@mail.gmail.com> <CAAdAUthNkXHwxGoU4Qrp5iG1m5zPXx296hEBLOGbXEKuLmt5mg@mail.gmail.com>
In-Reply-To: <CAAdAUthNkXHwxGoU4Qrp5iG1m5zPXx296hEBLOGbXEKuLmt5mg@mail.gmail.com>
From:   Peter Feiner <pfeiner@google.com>
Date:   Wed, 11 Aug 2021 16:19:17 -0700
Message-ID: <CAM3pwhHg2jp0AbqnjiCb3oZ8zioqijS-SnmRnZshTmKZ+cj8cQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of
 dirty pages
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 3:53 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> Hi Peter,
>
> On Tue, Aug 10, 2021 at 3:45 PM Peter Feiner <pfeiner@google.com> wrote:
> >
> > On Tue, Aug 10, 2021 at 3:32 PM Jing Zhang <jingzhangos@google.com> wrote:
> > >
> > > Add a generic VM stats dirty_pages to record the number of dirty pages
> > > reflected in dirty_bitmap at the moment.
> > >
> > > Original-by: Peter Feiner <pfeiner@google.com>
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  8 ++++++--
> > >  arch/powerpc/kvm/book3s_64_mmu_radix.c |  1 +
> > >  arch/powerpc/kvm/book3s_hv_rm_mmu.c    |  1 +
> > >  include/linux/kvm_host.h               |  3 ++-
> > >  include/linux/kvm_types.h              |  1 +
> > >  virt/kvm/kvm_main.c                    | 26 +++++++++++++++++++++++---
> > >  6 files changed, 34 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > > index c63e263312a4..e4aafa10efa1 100644
> > > --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > > +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > > @@ -1122,8 +1122,10 @@ long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
> > >                  * since we always put huge-page HPTEs in the rmap chain
> > >                  * corresponding to their page base address.
> > >                  */
> > > -               if (npages)
> > > +               if (npages) {
> > >                         set_dirty_bits(map, i, npages);
> > > +                       kvm->stat.generic.dirty_pages += npages;
> > > +               }
> > >                 ++rmapp;
> > >         }
> > >         preempt_enable();
> > > @@ -1178,8 +1180,10 @@ void kvmppc_unpin_guest_page(struct kvm *kvm, void *va, unsigned long gpa,
> > >         gfn = gpa >> PAGE_SHIFT;
> > >         srcu_idx = srcu_read_lock(&kvm->srcu);
> > >         memslot = gfn_to_memslot(kvm, gfn);
> > > -       if (memslot && memslot->dirty_bitmap)
> > > +       if (memslot && memslot->dirty_bitmap) {
> > >                 set_bit_le(gfn - memslot->base_gfn, memslot->dirty_bitmap);
> > > +               ++kvm->stat.generic.dirty_pages;
> > > +       }
> > >         srcu_read_unlock(&kvm->srcu, srcu_idx);
> > >  }
> > >
> > > diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > > index b5905ae4377c..3a6cb3854a44 100644
> > > --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > > +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > > @@ -1150,6 +1150,7 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
> > >                 j = i + 1;
> > >                 if (npages) {
> > >                         set_dirty_bits(map, i, npages);
> > > +                       kvm->stat.generic.dirty_pages += npages;
> > >                         j = i + npages;
> > >                 }
> > >         }
> > > diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> > > index 632b2545072b..16806bc473fa 100644
> > > --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> > > +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> > > @@ -109,6 +109,7 @@ void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
> > >         npages = (psize + PAGE_SIZE - 1) / PAGE_SIZE;
> > >         gfn -= memslot->base_gfn;
> > >         set_dirty_bits_atomic(memslot->dirty_bitmap, gfn, npages);
> > > +       kvm->stat.generic.dirty_pages += npages;
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvmppc_update_dirty_map);
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index f50bfcf225f0..1e8e66fb915b 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -1421,7 +1421,8 @@ struct _kvm_stats_desc {
> > >                 KVM_STATS_BASE_POW10, -9)
> > >
> > >  #define KVM_GENERIC_VM_STATS()                                                \
> > > -       STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
> > > +       STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),                      \
> > > +       STATS_DESC_COUNTER(VM_GENERIC, dirty_pages)
> > >
> > >  #define KVM_GENERIC_VCPU_STATS()                                              \
> > >         STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),                \
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index ed6a985c5680..6c05df00aebf 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -78,6 +78,7 @@ struct kvm_mmu_memory_cache {
> > >
> > >  struct kvm_vm_stat_generic {
> > >         u64 remote_tlb_flush;
> > > +       u64 dirty_pages;
> > >  };
> > >
> > >  struct kvm_vcpu_stat_generic {
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index a438a7a3774a..93f0ca2ea326 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -1228,6 +1228,19 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
> > >         return 0;
> > >  }
> > >
> > > +static inline unsigned long hweight_dirty_bitmap(
> > > +                                               struct kvm_memory_slot *memslot)
> > > +{
> > > +       unsigned long i;
> > > +       unsigned long count = 0;
> > > +       unsigned long n = kvm_dirty_bitmap_bytes(memslot);
> > > +
> > > +       for (i = 0; i < n / sizeof(long); ++i)
> > > +               count += hweight_long(memslot->dirty_bitmap[i]);
> > > +
> > > +       return count;
> > > +}
> > > +
> > >  /*
> > >   * Delete a memslot by decrementing the number of used slots and shifting all
> > >   * other entries in the array forward one spot.
> > > @@ -1612,6 +1625,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
> > >         if (r)
> > >                 return r;
> > >
> > > +       kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(old);
> > >         kvm_free_memslot(kvm, old);
> > >         return 0;
> > >  }
> > > @@ -1733,8 +1747,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >         if (r)
> > >                 goto out_bitmap;
> > >
> > > -       if (old.dirty_bitmap && !new.dirty_bitmap)
> > > +       if (old.dirty_bitmap && !new.dirty_bitmap) {
> > > +               kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(&old);
> > >                 kvm_destroy_dirty_bitmap(&old);
> > > +       }
> > >         return 0;
> > >
> > >  out_bitmap:
> > > @@ -1895,6 +1911,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
> > >                         offset = i * BITS_PER_LONG;
> > >                         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> > >                                                                 offset, mask);
> > > +                       kvm->stat.generic.dirty_pages -= hweight_long(mask);
> > >                 }
> > >                 KVM_MMU_UNLOCK(kvm);
> > >         }
> > > @@ -2012,6 +2029,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
> > >                         flush = true;
> > >                         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> > >                                                                 offset, mask);
> > > +                       kvm->stat.generic.dirty_pages -= hweight_long(mask);
> > >                 }
> > >         }
> > >         KVM_MMU_UNLOCK(kvm);
> > > @@ -3062,11 +3080,13 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> > >                 unsigned long rel_gfn = gfn - memslot->base_gfn;
> > >                 u32 slot = (memslot->as_id << 16) | memslot->id;
> > >
> > > -               if (kvm->dirty_ring_size)
> > > +               if (kvm->dirty_ring_size) {
> > >                         kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
> > >                                             slot, rel_gfn);
> > > -               else
> > > +               } else {
> > >                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > > +                       ++kvm->stat.generic.dirty_pages;
> >
> > Couple of problems here:
> >
> > - Calls to mark_page_dirty_in_slot aren't serialized by the mmu_lock,
> > so these updates will race.
> > - The page might already be dirty in the bitmap, so you're potentially
> > double counting here
> >
> > You can fix both of these problems by changing set_bit_le to a
> > test_and_set_bit_le (might not be the function name -- but you get the
> > idea) and conditionally incrementing dirty_pages.
> >
> >
> Since we need to consider the dirty ring situation and it is not
> trivial to check if the page is already in the dirty ring, I'll not
> change set_bit_le. Anyway, we are going to define the stat
> "dirty_pages" as dirtied pages in the life cycle of a VM, we only care
> about its growth rate for your use case.

To be clear, I don't have a use case anymore. It was years ago that I
came up with the idea of doing a kind of light memory dirty tracking
to predict how expensive pre-copy migration was going to be. However,
I didn't follow through on the idea; so if this never saw the light of
day in an upstream kernel, I'd be no worse for wear.

With that said, the use case I imagined did require knowing how many
pages were in the dirty bitmap at any moment. The number of pages
dirtied across the lifetime of the VM wouldn't have served that
purpose. So unless you have a use case for this new stat that's been
thought through end-to-end, I would suggest just dropping this patch
here (and from Google's kernel fork as well).



> I'll send out another version of the patch and we'll see if it is good enough.
> > > +               }
> > >         }
> > >  }
> > >  EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
> > >
> > > base-commit: d0732b0f8884d9cc0eca0082bbaef043f3fef7fb
> > > --
> > > 2.32.0.605.g8dce9f2422-goog
> > >
>
> Thanks,
> Jing
