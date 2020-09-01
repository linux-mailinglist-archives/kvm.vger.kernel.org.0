Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6671F259FFF
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 22:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgIAUbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 16:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgIAUbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 16:31:34 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D790C061244
        for <kvm@vger.kernel.org>; Tue,  1 Sep 2020 13:31:34 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id t20so1984788qtr.8
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 13:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRWJ2DFxuPL1t5fPcigerfgR9pIxvLhLBfoQu8JlkOs=;
        b=P287RbQ+XCT8QCuowvzP4MGbuYje4LpLhQrdYhfILPHVYwrrV45a0aysN5+QhmjZcO
         1aegXRtjcZd7beMwXy9O01eNxPPIn+EVML5KVB3lN8N3DD+L3EHFob4J/kZDjmmy/1/J
         UC8Q0JJPyt01aP/AE8gbElTp2DbdEh7Hyk/8zoOWUMgq2o79EdBjIjliEpXYqDOFmOrF
         5FEKJzXzz4P2YOndom/jM54yShEQPyazam5cIeE3gPWLts6AVYnyuwbY9UN79RMlF5Hs
         uuRjIyaRuH6KDx+2mBbXPvnulp1Hbr1nJ2CQo6jzrFvLBLa9Qx+5EgKJlP6ZC7nh80y4
         svGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRWJ2DFxuPL1t5fPcigerfgR9pIxvLhLBfoQu8JlkOs=;
        b=jT1q0vcEpPDoUeKUh7+xXfbbcO8eWFZ1l7mEbXpSPVkxMenvlBXUhrmFIiDl1XUily
         536QNDKKvXl3NtZs5/K/hN3IyS1ajcyegFi5YRTxwgS2TW4o6qktFzreti3cRg9HBSX9
         kVBSR0V1wE1z7TBR8pgtZeFrk3qJsL7YeR4lNn7qq9bdubBfAbxnArK2Iul4v78Zy0+t
         oDHZlutKvDApaUbBwXWVyLQ6x8xVtWvpcxg8N9YU93vJsEdzVy20jyriduwA8w6UCf7R
         injFkkary9Dn23fd9HiyGw3esjakQ+CyG9VIYDv/khw4cAcmh+7LJ0wxd3RMy7ufpuya
         CPuA==
X-Gm-Message-State: AOAM5305XdjHPlepwSs9iH5sDfJdAsgG7fkST7kc7UxomT/PDBR3ulvQ
        7W0F4ScVv2iLf+d0QvUTbec4+iFoPpjX89HpzhDJ7bLllS99RA==
X-Google-Smtp-Source: ABdhPJypPlANxgPOicRiU7vGjHBMcyJPJzHJLIIeOQJrVzfvM2h6ooEil7TCuXxKG3EvhQ+fD7gnZWhvuFUyih/OHXc=
X-Received: by 2002:aed:2555:: with SMTP id w21mr2820991qtc.132.1598992292617;
 Tue, 01 Sep 2020 13:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200819205633.1393378-1-pshier@google.com>
In-Reply-To: <20200819205633.1393378-1-pshier@google.com>
From:   Peter Shier <pshier@google.com>
Date:   Tue, 1 Sep 2020 13:31:21 -0700
Message-ID: <CACwOFJRtgj13ZMn7h6g8_noks86ca1n5UGEGqwRkGuKAd-1-=g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: vmx: Add test for MTF on a guest
 MOV-to-CR0 that enables PAE
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 1:56 PM Peter Shier <pshier@google.com> wrote:
>
> Verify that when L2 guest enables PAE paging and L0 intercept of L2
> MOV to CR0 reflects MTF exit to L1, subsequent resume to L2 correctly
> preserves PDPTE array specified by L2 CR3.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by:   Peter Shier <pshier@google.com>
> Signed-off-by: Peter Shier <pshier@google.com>
> ---
>  lib/x86/asm/page.h |   8 +++
>  x86/vmx_tests.c    | 173 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 181 insertions(+)
>
> diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
> index 7e2a3dd4b90a..1359eb74cde4 100644
> --- a/lib/x86/asm/page.h
> +++ b/lib/x86/asm/page.h
> @@ -36,10 +36,18 @@ typedef unsigned long pgd_t;
>  #define PT64_NX_MASK           (1ull << 63)
>  #define PT_ADDR_MASK           GENMASK_ULL(51, 12)
>
> +#define PDPTE64_PAGE_SIZE_MASK   (1ull << 7)
> +#define PDPTE64_RSVD_MASK        GENMASK_ULL(51, cpuid_maxphyaddr())
> +
>  #define PT_AD_MASK              (PT_ACCESSED_MASK | PT_DIRTY_MASK)
>
> +#define PAE_PDPTE_RSVD_MASK     (GENMASK_ULL(63, cpuid_maxphyaddr()) | \
> +                                GENMASK_ULL(8, 5) | GENMASK_ULL(2, 1))
> +
> +
>  #ifdef __x86_64__
>  #define        PAGE_LEVEL      4
> +#define        PDPT_LEVEL      3
>  #define        PGDIR_WIDTH     9
>  #define        PGDIR_MASK      511
>  #else
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 32e3d4f47b33..22f0c7b975be 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5250,6 +5250,178 @@ static void vmx_mtf_test(void)
>         enter_guest();
>  }
>
> +extern char vmx_mtf_pdpte_guest_begin;
> +extern char vmx_mtf_pdpte_guest_end;
> +
> +asm("vmx_mtf_pdpte_guest_begin:\n\t"
> +    "mov %cr0, %rax\n\t"    /* save CR0 with PG=1                 */
> +    "vmcall\n\t"            /* on return from this CR0.PG=0       */
> +    "mov %rax, %cr0\n\t"    /* restore CR0.PG=1 to enter PAE mode */
> +    "vmcall\n\t"
> +    "retq\n\t"
> +    "vmx_mtf_pdpte_guest_end:");
> +
> +static void vmx_mtf_pdpte_test(void)
> +{
> +       void *test_mtf_pdpte_guest;
> +       pteval_t *pdpt;
> +       u32 guest_ar_cs;
> +       u64 guest_efer;
> +       pteval_t *pte;
> +       u64 guest_cr0;
> +       u64 guest_cr3;
> +       u64 guest_cr4;
> +       u64 ent_ctls;
> +       int i;
> +
> +       if (setup_ept(false))
> +               return;
> +
> +       if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
> +               printf("CPU does not support 'monitor trap flag.'\n");
> +               return;
> +       }
> +
> +       if (!(ctrl_cpu_rev[1].clr & CPU_URG)) {
> +               printf("CPU does not support 'unrestricted guest.'\n");
> +               return;
> +       }
> +
> +       vmcs_write(EXC_BITMAP, ~0);
> +       vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
> +
> +       /*
> +        * Copy the guest code to an identity-mapped page.
> +        */
> +       test_mtf_pdpte_guest = alloc_page();
> +       memcpy(test_mtf_pdpte_guest, &vmx_mtf_pdpte_guest_begin,
> +              &vmx_mtf_pdpte_guest_end - &vmx_mtf_pdpte_guest_begin);
> +
> +       test_set_guest(test_mtf_pdpte_guest);
> +
> +       enter_guest();
> +       skip_exit_vmcall();
> +
> +       /*
> +        * Put the guest in non-paged 32-bit protected mode, ready to enter
> +        * PAE mode when CR0.PG is set. CR4.PAE will already have been set
> +        * when the guest started out in long mode.
> +        */
> +       ent_ctls = vmcs_read(ENT_CONTROLS);
> +       vmcs_write(ENT_CONTROLS, ent_ctls & ~ENT_GUEST_64);
> +
> +       guest_efer = vmcs_read(GUEST_EFER);
> +       vmcs_write(GUEST_EFER, guest_efer & ~(EFER_LMA | EFER_LME));
> +
> +       /*
> +        * Set CS access rights bits for 32-bit protected mode:
> +        * 3:0    B execute/read/accessed
> +        * 4      1 code or data
> +        * 6:5    0 descriptor privilege level
> +        * 7      1 present
> +        * 11:8   0 reserved
> +        * 12     0 available for use by system software
> +        * 13     0 64 bit mode not active
> +        * 14     1 default operation size 32-bit segment
> +        * 15     1 page granularity: segment limit in 4K units
> +        * 16     0 segment usable
> +        * 31:17  0 reserved
> +        */
> +       guest_ar_cs = vmcs_read(GUEST_AR_CS);
> +       vmcs_write(GUEST_AR_CS, 0xc09b);
> +
> +       guest_cr0 = vmcs_read(GUEST_CR0);
> +       vmcs_write(GUEST_CR0, guest_cr0 & ~X86_CR0_PG);
> +
> +       guest_cr4 = vmcs_read(GUEST_CR4);
> +       vmcs_write(GUEST_CR4, guest_cr4 & ~X86_CR4_PCIDE);
> +
> +       guest_cr3 = vmcs_read(GUEST_CR3);
> +
> +       /*
> +        * Turn the 4-level page table into a PAE page table by following the 0th
> +        * PML4 entry to a PDPT page, and grab the first four PDPTEs from that
> +        * page.
> +        *
> +        * Why does this work?
> +        *
> +        * PAE uses 32-bit addressing which implies:
> +        * Bits 11:0   page offset
> +        * Bits 20:12  entry into 512-entry page table
> +        * Bits 29:21  entry into a 512-entry directory table
> +        * Bits 31:30  entry into the page directory pointer table.
> +        * Bits 63:32  zero
> +        *
> +        * As only 2 bits are needed to select the PDPTEs for the entire
> +        * 32-bit address space, take the first 4 PDPTEs in the level 3 page
> +        * directory pointer table. It doesn't matter which of these PDPTEs
> +        * are present because they must cover the guest code given that it
> +        * has already run successfully.
> +        *
> +        * Get a pointer to PTE for GVA=0 in the page directory pointer table
> +        */
> +       pte = get_pte_level(
> +            (pgd_t *)phys_to_virt(guest_cr3 & ~X86_CR3_PCID_MASK), 0,
> +            PDPT_LEVEL);
> +
> +       /*
> +        * Need some memory for the 4-entry PAE page directory pointer
> +        * table. Use the end of the identity-mapped page where the guest code
> +        * is stored. There is definitely space as the guest code is only a
> +        * few bytes.
> +        */
> +       pdpt = test_mtf_pdpte_guest + PAGE_SIZE - 4 * sizeof(pteval_t);
> +
> +       /*
> +        * Copy the first four PDPTEs into the PAE page table with reserved
> +        * bits cleared. Note that permission bits from the PML4E and PDPTE
> +        * are not propagated.
> +        */
> +       for (i = 0; i < 4; i++) {
> +               TEST_ASSERT_EQ_MSG(0, (pte[i] & PDPTE64_RSVD_MASK),
> +                                  "PDPTE has invalid reserved bits");
> +               TEST_ASSERT_EQ_MSG(0, (pte[i] & PDPTE64_PAGE_SIZE_MASK),
> +                                  "Cannot use 1GB super pages for PAE");
> +               pdpt[i] = pte[i] & ~(PAE_PDPTE_RSVD_MASK);
> +       }
> +       vmcs_write(GUEST_CR3, virt_to_phys(pdpt));
> +
> +       enable_mtf();
> +       enter_guest();
> +       assert_exit_reason(VMX_MTF);
> +       disable_mtf();
> +
> +       /*
> +        * The four PDPTEs should have been loaded into the VMCS when
> +        * the guest set CR0.PG to enter PAE mode.
> +        */
> +       for (i = 0; i < 4; i++) {
> +               u64 pdpte = vmcs_read(GUEST_PDPTE + 2 * i);
> +
> +               report(pdpte == pdpt[i], "PDPTE%d is 0x%lx (expected 0x%lx)",
> +                      i, pdpte, pdpt[i]);
> +       }
> +
> +       /*
> +        * Now, try to enter the guest in PAE mode. If the PDPTEs in the
> +        * vmcs are wrong, this will fail.
> +        */
> +       enter_guest();
> +       skip_exit_vmcall();
> +
> +       /*
> +        * Return guest to 64-bit mode and wrap up.
> +        */
> +       vmcs_write(ENT_CONTROLS, ent_ctls);
> +       vmcs_write(GUEST_EFER, guest_efer);
> +       vmcs_write(GUEST_AR_CS, guest_ar_cs);
> +       vmcs_write(GUEST_CR0, guest_cr0);
> +       vmcs_write(GUEST_CR4, guest_cr4);
> +       vmcs_write(GUEST_CR3, guest_cr3);
> +
> +       enter_guest();
> +}
> +
>  /*
>   * Tests for VM-execution control fields
>   */
> @@ -10112,6 +10284,6 @@ struct vmx_test vmx_tests[] = {
>         TEST(atomic_switch_overflow_msrs_test),
>         TEST(rdtsc_vmexit_diff_test),
>         TEST(vmx_mtf_test),
> +       TEST(vmx_mtf_pdpte_test),
>         { NULL, NULL, NULL, NULL, NULL, {0} },
>  };
> --
>

Ping. Thx
