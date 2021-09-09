Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E108405BB9
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 19:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbhIIRFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbhIIRFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:05:53 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957CDC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 10:04:43 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x27so5053633lfu.5
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ElUi2zLG+FPdz2UbE6Ray8TiRA1vza4HIfAFJ/kfzDA=;
        b=sBGGF2kG+kvjABV883GUjWQBbQ2wX1NxELksiUeFov5Sj5rAv40ysH20N7VQgc/5cg
         DGTsfaPG76W7jKp6lCHQGpeb3qMg1jfkETHtMBdCxdXh5c2gOBgpg89a3WqziPY/83MM
         Ot6A5TOx+m7J0m84VaOwWv6ZwAdoTewLWePlIxQIxd7apvaH1oIskbpkSd7PwYz6oOPl
         JUmIjLWW1pLO63L6urfiluhdEyGC/ZeSUrpEqVBHtbdPaNCTONO5mm9fPOt/IiiZwOBJ
         Lld0qL0BiHZq3hUIfIXyBjAJk7u3WMKgB/VkWdPuL7XN/co3wq76VPdvD4K2hf+3X2HV
         lCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElUi2zLG+FPdz2UbE6Ray8TiRA1vza4HIfAFJ/kfzDA=;
        b=4GGgUcE71W2T2erZcOTZWR53EZM9lUyQuU90Gq+m+InvJgtxjcRHL9r2aM3NK4+0r8
         n+Xe/eBdxn5c18tzS+lsCO9uDHWvnwWF9tqMwWIGoGqRrKcnhAMQSCoYqp7de4YA8Vt8
         49JfBqCu/fV7kob1Rt5ApewqRlNV7RS35IXh1aBWcNMokA597wO6UNqUpXWYGDp6C5BM
         nB5Lr57UbHrrZSzl+syqcSD2Dx2dqg6K8b1ohsLNZo6OstIuajzHSacxsuz4HO1lBYz0
         B7C1CqsnViwEIOb9tI4F5B4+GnJmIrFO9RBt4XH6iy8EGoIo2AxTpfi9KqSWez8oHlTC
         Jq1Q==
X-Gm-Message-State: AOAM533jEHIf7z7EsZQ8vwo9F8KGKB7eQ6UTGDE7AYeAlpZNP5Cz0dUX
        jXhivz2YV8jzDpkNYYMhTvcDDy1u69LQbia5i4edlA==
X-Google-Smtp-Source: ABdhPJzgsnReiX6zBBk7VBYxWyPOlu6Rnz6b1gSn1eWpE9n3+TwnrWeVYgZ5PlPI5XB3FPGSVGVg8crba8eh2NTMT9Y=
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr700974lfg.150.1631207081580;
 Thu, 09 Sep 2021 10:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-10-rananta@google.com>
 <YTmW7/pY0E9cHQ+c@google.com> <CAJHc60zk6vJg4dj4hm7sCHK08TEr=GtXemDJHb22mgvg2eUfXA@mail.gmail.com>
In-Reply-To: <CAJHc60zk6vJg4dj4hm7sCHK08TEr=GtXemDJHb22mgvg2eUfXA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 9 Sep 2021 13:04:30 -0400
Message-ID: <CAOQ_QsiBqfD+j9EpOxVFOg=YPdeUCZnkwBJHLv-ACcHevhpx0A@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 12:59 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Wed, Sep 8, 2021 at 10:09 PM Oliver Upton <oupton@google.com> wrote:
> >
> > On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> > > At times, such as when in the interrupt handler, the guest wants
> > > to get the vcpuid that it's running on. As a result, introduce
> > > get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> > > backend, the VMM prepares a map of vcpuid and mpidr during VM
> > > initialization and exports the map to the guest for it to read.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/include/aarch64/processor.h |  3 ++
> > >  .../selftests/kvm/lib/aarch64/processor.c     | 46 +++++++++++++++++++
> > >  2 files changed, 49 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > index b6088c3c67a3..150f63101f4c 100644
> > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > @@ -133,6 +133,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
> > >               int vector, handler_fn handler);
> > >  void vm_install_sync_handler(struct kvm_vm *vm,
> > >               int vector, int ec, handler_fn handler);
> > > +void vm_vcpuid_map_init(struct kvm_vm *vm);
> > >
> > >  static inline void cpu_relax(void)
> > >  {
> > > @@ -194,4 +195,6 @@ static inline void local_irq_disable(void)
> > >       asm volatile("msr daifset, #3" : : : "memory");
> > >  }
> > >
> > > +int get_vcpuid(void);
> > > +
> >
> > I believe both of these functions could use some documentation. The
> > former has implicit ordering requirements (can only be called after all
> > vCPUs are created) and the latter can only be used within a guest.
> >
> > >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > index 632b74d6b3ca..9844b62227b1 100644
> > > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > @@ -13,9 +13,17 @@
> > >  #include "processor.h"
> > >
> > >  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN  0xac0000
> > > +#define VM_VCPUID_MAP_INVAL                  -1
> > >
> > >  static vm_vaddr_t exception_handlers;
> > >
> > > +struct vm_vcpuid_map {
> > > +     uint64_t mpidr;
> > > +     int vcpuid;
> > > +};
> > > +
> > > +static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
> > > +
> >
> > Hmm.
> >
> > I'm not too big of a fan that the KVM_MAX_VCPUS macro is defined in the
> > KVM selftests. Really, userspace should discover the limit from the
> > kernel. Especially when we want to write tests that test behavior at
> > KVM's limit.
> >
> > That being said, there are more instances of these static allocations in
> > the selftests code, so you aren't to be blamed.
> >
> > Related: commit 074c82c8f7cf ("kvm: x86: Increase MAX_VCPUS to 1024")
> > has raised this limit.
> >
> I'm not a fan of static allocations either, but the fact that
> sync_global_to_guest() doesn't have a size argument (yet), makes me
> want to take a shorter route. Anyway, if you want I can allocate it
> dynamically and copy it to the guest's memory by hand, or come up with
> a utility wrapper while I'm at it.
> (Just wanted to make sure we are not over-engineering our needs here).

No, please don't worry about it in your series. I'm just openly
whining is all :-)

> > >  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> > >  {
> > >       return (v + vm->page_size) & ~(vm->page_size - 1);
> > > @@ -426,3 +434,41 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> > >       assert(vector < VECTOR_NUM);
> > >       handlers->exception_handlers[vector][0] = handler;
> > >  }
> > > +
> > > +void vm_vcpuid_map_init(struct kvm_vm *vm)
> > > +{
> > > +     int i = 0;
> > > +     struct vcpu *vcpu;
> > > +     struct vm_vcpuid_map *map;
> > > +
> > > +     list_for_each_entry(vcpu, &vm->vcpus, list) {
> > > +             map = &vcpuid_map[i++];
> > > +             map->vcpuid = vcpu->id;
> > > +             get_reg(vm, vcpu->id,
> > > +                     ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &map->mpidr);
> > > +             map->mpidr &= MPIDR_HWID_BITMASK;
> > > +     }
> > > +
> > > +     if (i < KVM_MAX_VCPUS)
> > > +             vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
> > > +
> > > +     sync_global_to_guest(vm, vcpuid_map);
> > > +}
> > > +
> > > +int get_vcpuid(void)
> >
> > nit: guest_get_vcpuid()
> >
> Sounds nice. Since we have a lot of guest utility functions now, I'm
> fancying a world where we prefix guest_ with all of them to avoid
> confusion.
>

Sounds good to me!

--
Thanks,
Oliver
