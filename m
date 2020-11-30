Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3D22C820D
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgK3KWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 05:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgK3KWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 05:22:25 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ED9C0613D2
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 02:21:44 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id x22so17805172wmc.5
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 02:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fClK9dYPgSK1URS64wSbMulejn6T5yvpN8jKUjDOmSs=;
        b=VDQYTXZA9JFPGhZ+UKdSNhvFmqlc/Lc5kkB3FkebjR6HzNooh88aluRs6YSmHfsBcI
         Kgxj1m8crgwwpPEWkBssWVhXvuL54FcDlf/uu65aH9JbMQ7Zdk7ObiptMwd+/TcbfX6v
         cHD1y9SFGO1h3i/lY4cKPEv8xUiFGYTnRhd0Vhvtl6JZ0WzYrGWYHbcvgUk75FtfJZU8
         0m4QsIF7NpfLKUdoiwnYdjV2s/PV75ReEQOIEmZUvJOFBFfS5mqIBglFGsQP51cMOO9o
         AoXAwFIiwF2AOyfdXvfs7jy3cq5K2R0luMhl+t32By/ye7m0I06pkouc9hgDpFL4b/4M
         hwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fClK9dYPgSK1URS64wSbMulejn6T5yvpN8jKUjDOmSs=;
        b=dRnthiKbK5fIcpfPaNqC489LFDwbeOm6WkXNDujIPlbqFMGh4WtlmuH6afMX0QTa6O
         Hj+OXpV80ZYRePvvBtVarhvzo2ifAxzT7dnj5hcRgZ4npJPAcqxkfrSrWzHRF2Z4BYDF
         IMsVAfzZViMskl32mA4nY4qdAhOp2YCUhPtJw09wBmAPZA3TJ+79TeACy9awcFHaq2SO
         EtcoFlA5l4AAeLYmObxqu1cxvQI7E2xCKzASnm+O9AKr5gEVPVEtBsWltE3t70ZjKKeN
         zoYYlDBvdc3CApOIQVdlN6NwNEdfZCr+RuHWs6h6+YneNuqyYM4ftU1DKUNAvayrTLKR
         kmYg==
X-Gm-Message-State: AOAM5310zk+K+QIIzAjmAFdbyiQbP0tIwoty38Pg9n/admo1SgkVObCz
        M3qahJ398CLOjEvW3A91d4GoV9nRaLfMYDTqr/2WpA==
X-Google-Smtp-Source: ABdhPJzib+BpTbU31xlUoWNFiPqoHFb5TY4jwtgOrWeTXAM7S/LG4dEzhQ2uSNYnr4smOgLLxmVzcrTTZd50LNIwqzU=
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr4115261wmf.134.1606731703433;
 Mon, 30 Nov 2020 02:21:43 -0800 (PST)
MIME-Version: 1.0
References: <20201109113240.3733496-1-anup.patel@wdc.com> <20201109113240.3733496-11-anup.patel@wdc.com>
 <186ade3c372b44ef8ca1830da8c5002b@huawei.com> <CAAhSdy1sx_oLGGoGjzr5ZrPStwCyFF4mBDEBw5zpsbSGcCRJjg@mail.gmail.com>
In-Reply-To: <CAAhSdy1sx_oLGGoGjzr5ZrPStwCyFF4mBDEBw5zpsbSGcCRJjg@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 30 Nov 2020 15:51:31 +0530
Message-ID: <CAAhSdy13nQqzfK-Voz-aBtGzEfjw_0V1fOrydijc3FLWy_W4nw@mail.gmail.com>
Subject: Re: [PATCH v15 10/17] RISC-V: KVM: Implement stage2 page table programming
To:     Jiangyifei <jiangyifei@huawei.com>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        yinyipeng <yinyipeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020 at 2:56 PM Anup Patel <anup@brainfault.org> wrote:
>
> On Mon, Nov 16, 2020 at 2:59 PM Jiangyifei <jiangyifei@huawei.com> wrote:
> >
> >
> > > -----Original Message-----
> > > From: Anup Patel [mailto:anup.patel@wdc.com]
> > > Sent: Monday, November 9, 2020 7:33 PM
> > > To: Palmer Dabbelt <palmer@dabbelt.com>; Palmer Dabbelt
> > > <palmerdabbelt@google.com>; Paul Walmsley <paul.walmsley@sifive.com>;
> > > Albert Ou <aou@eecs.berkeley.edu>; Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Alexander Graf <graf@amazon.com>; Atish Patra <atish.patra@wdc.com>;
> > > Alistair Francis <Alistair.Francis@wdc.com>; Damien Le Moal
> > > <damien.lemoal@wdc.com>; Anup Patel <anup@brainfault.org>;
> > > kvm@vger.kernel.org; kvm-riscv@lists.infradead.org;
> > > linux-riscv@lists.infradead.org; linux-kernel@vger.kernel.org; Anup Patel
> > > <anup.patel@wdc.com>; Jiangyifei <jiangyifei@huawei.com>
> > > Subject: [PATCH v15 10/17] RISC-V: KVM: Implement stage2 page table
> > > programming
> > >
> > > This patch implements all required functions for programming the stage2 page
> > > table for each Guest/VM.
> > >
> > > At high-level, the flow of stage2 related functions is similar from KVM
> > > ARM/ARM64 implementation but the stage2 page table format is quite
> > > different for KVM RISC-V.
> > >
> > > [jiangyifei: stage2 dirty log support]
> > > Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> > > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  arch/riscv/include/asm/kvm_host.h     |  12 +
> > >  arch/riscv/include/asm/pgtable-bits.h |   1 +
> > >  arch/riscv/kvm/Kconfig                |   1 +
> > >  arch/riscv/kvm/main.c                 |  19 +
> > >  arch/riscv/kvm/mmu.c                  | 649
> > > +++++++++++++++++++++++++-
> > >  arch/riscv/kvm/vm.c                   |   6 -
> > >  6 files changed, 672 insertions(+), 16 deletions(-)
> > >
> >
> > ......
> >
> > >
> > >  int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, @@ -69,27 +562,163 @@
> > > int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
> > >                        gpa_t gpa, unsigned long hva,
> > >                        bool writeable, bool is_write)
> > >  {
> > > -     /* TODO: */
> > > -     return 0;
> > > +     int ret;
> > > +     kvm_pfn_t hfn;
> > > +     short vma_pageshift;
> > > +     gfn_t gfn = gpa >> PAGE_SHIFT;
> > > +     struct vm_area_struct *vma;
> > > +     struct kvm *kvm = vcpu->kvm;
> > > +     struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
> > > +     bool logging = (memslot->dirty_bitmap &&
> > > +                     !(memslot->flags & KVM_MEM_READONLY)) ? true : false;
> > > +     unsigned long vma_pagesize;
> > > +
> > > +     mmap_read_lock(current->mm);
> > > +
> > > +     vma = find_vma_intersection(current->mm, hva, hva + 1);
> > > +     if (unlikely(!vma)) {
> > > +             kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> > > +             mmap_read_unlock(current->mm);
> > > +             return -EFAULT;
> > > +     }
> > > +
> > > +     if (is_vm_hugetlb_page(vma))
> > > +             vma_pageshift = huge_page_shift(hstate_vma(vma));
> > > +     else
> > > +             vma_pageshift = PAGE_SHIFT;
> > > +     vma_pagesize = 1ULL << vma_pageshift;
> > > +     if (logging || (vma->vm_flags & VM_PFNMAP))
> > > +             vma_pagesize = PAGE_SIZE;
> > > +
> > > +     if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
> > > +             gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> > > +
> > > +     mmap_read_unlock(current->mm);
> > > +
> > > +     if (vma_pagesize != PGDIR_SIZE &&
> > > +         vma_pagesize != PMD_SIZE &&
> > > +         vma_pagesize != PAGE_SIZE) {
> > > +             kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
> > > +             return -EFAULT;
> > > +     }
> > > +
> > > +     /* We need minimum second+third level pages */
> > > +     ret = stage2_cache_topup(pcache, stage2_pgd_levels,
> > > +                              KVM_MMU_PAGE_CACHE_NR_OBJS);
> > > +     if (ret) {
> > > +             kvm_err("Failed to topup stage2 cache\n");
> > > +             return ret;
> > > +     }
> > > +
> > > +     hfn = gfn_to_pfn_prot(kvm, gfn, is_write, NULL);
> > > +     if (hfn == KVM_PFN_ERR_HWPOISON) {
> > > +             send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
> > > +                             vma_pageshift, current);
> > > +             return 0;
> > > +     }
> > > +     if (is_error_noslot_pfn(hfn))
> > > +             return -EFAULT;
> > > +
> > > +     /*
> > > +      * If logging is active then we allow writable pages only
> > > +      * for write faults.
> > > +      */
> > > +     if (logging && !is_write)
> > > +             writeable = false;
> > > +
> > > +     spin_lock(&kvm->mmu_lock);
> > > +
> > > +     if (writeable) {
> >
> > Hi Anup,
> >
> > What is the purpose of "writable = !memslot_is_readonly(slot)" in this series?
>
> Where ? I don't see this line in any of the patches.
>
> >
> > When mapping the HVA to HPA above, it doesn't know that the PTE writeable of stage2 is "!memslot_is_readonly(slot)".
> > This may causes the difference between the writability of HVA->HPA and GPA->HPA.
> > For example, GPA->HPA is writeable, but HVA->HPA is not writeable.
>
> Yes, this is possible particularly when Host kernel is updating writability
> of HVA->HPA mappings for swapping in/out pages.
>
> >
> > Is it better that the writability of HVA->HPA is also determined by whether the memslot is readonly in this change?
> > Like this:
> > -    hfn = gfn_to_pfn_prot(kvm, gfn, is_write, NULL);
> > +    hfn = gfn_to_pfn_prot(kvm, gfn, writeable, NULL);
>
> The gfn_to_pfn_prot() needs to know what type of fault we
> got (i.e read/write fault). Rest of the information (such as whether
> slot is writable or not) is already available to gfn_to_pfn_prot().
>
> The question here is should we pass "&writeable" or NULL as
> last parameter to gfn_to_pfn_prot(). The recent JUMP label
> support in Linux RISC-V causes problem on HW where PTE
> 'A' and 'D' bits are not updated by HW so I have to change
> last parameter of gfn_to_pfn_prot() from "&writeable" to NULL.
>
> I am still investigating this.

This turned-out to be a bug in Spike which is not fixed.

I will include following change in v16 patch series:


diff --git a/arch/riscv/include/asm/kvm_host.h
b/arch/riscv/include/asm/kvm_host.h
index 241030956d47..dc2666b4180b 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -232,8 +232,7 @@ void __kvm_riscv_hfence_gvma_all(void);

 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
              struct kvm_memory_slot *memslot,
-             gpa_t gpa, unsigned long hva,
-             bool writeable, bool is_write);
+             gpa_t gpa, unsigned long hva, bool is_write);
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index fcaeadc9b34d..56fda9ef70fd 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -689,11 +689,11 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)

 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
              struct kvm_memory_slot *memslot,
-             gpa_t gpa, unsigned long hva,
-             bool writeable, bool is_write)
+             gpa_t gpa, unsigned long hva, bool is_write)
 {
     int ret;
     kvm_pfn_t hfn;
+    bool writeable;
     short vma_pageshift;
     gfn_t gfn = gpa >> PAGE_SHIFT;
     struct vm_area_struct *vma;
@@ -742,7 +742,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,

     mmu_seq = kvm->mmu_notifier_seq;

-    hfn = gfn_to_pfn_prot(kvm, gfn, is_write, NULL);
+    hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
     if (hfn == KVM_PFN_ERR_HWPOISON) {
         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
                 vma_pageshift, current);
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index f054406792a6..058cfa168abe 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -445,7 +445,7 @@ static int stage2_page_fault(struct kvm_vcpu
*vcpu, struct kvm_run *run,
         };
     }

-    ret = kvm_riscv_stage2_map(vcpu, memslot, fault_addr, hva, writeable,
+    ret = kvm_riscv_stage2_map(vcpu, memslot, fault_addr, hva,
         (trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
     if (ret < 0)
         return ret;

Regards,
Anup
