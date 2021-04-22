Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC00368202
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 15:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbhDVN6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 09:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236365AbhDVN6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 09:58:11 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7FBC06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 06:57:37 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id y14-20020a056830208eb02902a1c9fa4c64so5705049otq.9
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 06:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RdiVZ4Gaxra/3V1KziNUMgfJgsbPGuE+sO4D2qlPtZ8=;
        b=dQWo7xwq/z9e0+Bo6Mi1snK8/pkMsXVeRlrZGzJ++LnsIx3xAFrIrKwScKKP8khkgu
         54J+y8XLAvUpKd3LQULCpLyAVJqURg6MrLwOeeHifgU5GbZxO91MDy6FLgeF3+th+VLS
         Vsmw75tvPamQ+sdD0nHYh1VMv5ODB0eBAOJIBncmWcKb/+7wHjKcPc5f5SiKDS8IWiw+
         cWg+xBPpPwhIHlT/EXpytdfGYOb7eImRKXTvxvulTgzS5cXOnCachOvZ62Pb0Rad5RbA
         MmTNPbfqNfdEv+MYjJ8FJKtEragM5Dz6AsAuHcSzTzZ8keE/cMbsXtvaj3d33qGDKmUA
         8aXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RdiVZ4Gaxra/3V1KziNUMgfJgsbPGuE+sO4D2qlPtZ8=;
        b=sA70lZNah0m4rOSBms1LcOXJ5NKvc9LGlpmIx0rzMUo0N8L25JFKxyKLhLY+GS5Gr9
         6JevbXcUJ0itlrTGQh/A17VFGy1gveZaUnOGMtCGN17qLusXtBFk+bWR7kUEbHnEiNVF
         Y55G1zgcnWXLUgHKxj7atJdYhPxhYph7fq7fPX5imKDh3EBV+PmUxvwEbaP9HcS7ZpHb
         gf/OfJ3XrijZl+W0mDHwLjUekrh+AMM1K8L389S4gx9Xg4jVf57Q56Y/SRDVxbzwqtyG
         8sJn+077E9u+L1l1+As0I23hPgoyZDKjW/zQGUKIqWk3QP6WyrSCko9khCkhEWQ80QTR
         bpcg==
X-Gm-Message-State: AOAM531lG+ch7qofDyywQXAYxP2ZAMqqnDeyaHEf9/M4UeCx2+2Gy/Yc
        0ItRc7x6Q6VLYuVdJHnkl/3yLurLSvZ2FZSFpFB07g==
X-Google-Smtp-Source: ABdhPJxDypWN2hO6nbS1OVgw04mMpsrzhe/elj+oSJJqJSdoRCN5zAYRa0XsrgGeaZiUoNZ8ZDU/mWhEki2SSuELpOA=
X-Received: by 2002:a9d:342:: with SMTP id 60mr2916586otv.295.1619099856042;
 Thu, 22 Apr 2021 06:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210421162225.3924641-1-aaronlewis@google.com> <20210421162225.3924641-2-aaronlewis@google.com>
In-Reply-To: <20210421162225.3924641-2-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 22 Apr 2021 13:57:25 +0000
Message-ID: <CALMp9eRHpBd96j3ZFkoeabCbwUbTzkaP2+OnxNyN7TLOa=myig@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: kvm: Allows userspace to handle
 emulation errors.
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 9:23 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> This test exercises the feature KVM_CAP_EXIT_ON_EMULATION_FAILURE.  When
> enabled, errors in the in-kernel instruction emulator are forwarded to
> userspace with the instruction bytes stored in the exit struct for
> KVM_EXIT_INTERNAL_ERROR.  So, when the guest attempts to emulate an
> 'flds' instruction, which isn't able to be emulated in KVM, instead
> of failing, KVM sends the instruction to userspace to handle.
>
> For this test to work properly the module parameter
> 'allow_smaller_maxphyaddr' has to be set.

Can you at least test for this?

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/processor.h  |   3 +
>  .../selftests/kvm/lib/x86_64/processor.c      |  58 +++++
>  .../kvm/x86_64/emulator_error_test.c          | 209 ++++++++++++++++++
>  5 files changed, 272 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c
>
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 7bd7e776c266..ec9e20a2f752 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -7,6 +7,7 @@
>  /x86_64/cr4_cpuid_sync_test
>  /x86_64/debug_regs
>  /x86_64/evmcs_test
> +/x86_64/emulator_error_test
>  /x86_64/get_cpuid_test
>  /x86_64/get_msr_index_features
>  /x86_64/kvm_pv_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 67eebb53235f..5ff705d92d02 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -41,6 +41,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_ha
>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>  TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
>  TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
>  TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 0b30b4e15c38..40f70f91e6a2 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -394,6 +394,9 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
>  void vm_handle_exception(struct kvm_vm *vm, int vector,
>                         void (*handler)(struct ex_regs *));
>
> +uint64_t vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
> +void vm_set_page_table_entry(struct kvm_vm *vm, uint64_t vaddr, uint64_t mask);
> +
>  /*
>   * set_cpuid() - overwrites a matching cpuid entry with the provided value.
>   *              matches based on ent->function && ent->index. returns true
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..1aa4fc5e84c6 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -292,6 +292,64 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>         pte[index[0]].present = 1;
>  }
>
> +static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm,
> +                                                      uint64_t vaddr)
> +{
> +       uint16_t index[4];
> +       struct pageMapL4Entry *pml4e;
> +       struct pageDirectoryPointerEntry *pdpe;
> +       struct pageDirectoryEntry *pde;
> +       struct pageTableEntry *pte;
> +
> +       TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
> +               "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> +       TEST_ASSERT((vaddr % vm->page_size) == 0,
> +               "Virtual address not on page boundary,\n"
> +               "  vaddr: 0x%lx vm->page_size: 0x%x",
> +               vaddr, vm->page_size);

Why not allow the caller to query the PTE for *any* (valid) virtual address?
Speaking of valid virtual addresses, should there be a canonical check here?

> +       TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
> +               (vaddr >> vm->page_shift)),
> +               "Invalid virtual address, vaddr: 0x%lx",
> +               vaddr);
> +
> +       index[0] = (vaddr >> 12) & 0x1ffu;
> +       index[1] = (vaddr >> 21) & 0x1ffu;
> +       index[2] = (vaddr >> 30) & 0x1ffu;
> +       index[3] = (vaddr >> 39) & 0x1ffu;
> +
> +       pml4e = addr_gpa2hva(vm, vm->pgd);
> +       TEST_ASSERT(pml4e[index[3]].present,
> +               "Expected pml4e to be present for gva: 0x%08lx", vaddr);

Should we verify that no reserved bits are set before continuing the walk?

> +       pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
> +       TEST_ASSERT(pdpe[index[2]].present,
> +               "Expected pdpe to be present for gva: 0x%08lx", vaddr);

Should we verify that no reserved bits are set (and that the superpage
bit is clear) before continuing the walk?

> +       pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
> +       TEST_ASSERT(pde[index[1]].present,
> +               "Expected pde to be present for gva: 0x%08lx", vaddr);

Should we verify that no reserved bits are set (and that the superpage
bit is clear) before continuing the walk?

> +       pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
> +       TEST_ASSERT(pte[index[0]].present,
> +               "Expected pte to be present for gva: 0x%08lx", vaddr);

As long as we're checking for present before returning the PTE
pointer, should we also check for reserved bits?

> +       return &pte[index[0]];
> +}
> +
> +uint64_t vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
> +{
> +       struct pageTableEntry *pte = _vm_get_page_table_entry(vm, vaddr);
> +
> +       return *(uint64_t *)pte;
> +}
> +
> +void vm_set_page_table_entry(struct kvm_vm *vm, uint64_t vaddr, uint64_t mask)
> +{
> +       struct pageTableEntry *pte = _vm_get_page_table_entry(vm, vaddr);
> +
> +       *(uint64_t *)pte |= mask;
> +}

I'm not sure this is the best API. What if we want to clear bits, or
change the PFN? Why not have the caller construct the desired PTE and
pass that in?

>  void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  {
>         struct pageMapL4Entry *pml4e, *pml4e_start;
> diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
> new file mode 100644
> index 000000000000..825da57ad791
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
> @@ -0,0 +1,209 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020, Google LLC.
> + *
> + * Tests for KVM_CAP_EXIT_ON_EMULATION_FAILURE capability.
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "vmx.h"
> +
> +#define VCPU_ID           1
> +#define PAGE_SIZE  4096
> +#define MAXPHYADDR 36
> +
> +#define MEM_REGION_GVA 0x0000123456789000
> +#define MEM_REGION_GPA 0x0000000700000000
> +#define MEM_REGION_SLOT        10
> +#define MEM_REGION_SIZE PAGE_SIZE
> +
> +extern char fld_start, fld_end;
> +
> +static void guest_code(void)
> +{
> +       __asm__ __volatile__("fld_start: flds (%[addr]); fld_end:"
> +                            :: [addr]"r"(MEM_REGION_GVA));
> +
> +       GUEST_DONE();
> +}
> +
> +static void run_guest(struct kvm_vm *vm)
> +{
> +       int rc;
> +
> +       rc = _vcpu_run(vm, VCPU_ID);
> +       TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
> +}
> +
> +/*
> + * Accessors to get R/M, REG, and Mod bits described in the SDM vol 2,
> + * figure 2-2 "Table Interpretation of ModR/M Byte (C8H)".
> + */
> +#define GET_RM(insn_byte) (insn_byte & 0x7)
> +#define GET_REG(insn_byte) ((insn_byte & 0x38) >> 3)
> +#define GET_MOD(insn_byte) ((insn_byte & 0xc) >> 6)
> +
> +bool is_flds(uint8_t *insn_bytes, uint8_t insn_size)
> +{
> +       return insn_size >= 2 &&
> +              insn_bytes[0] == 0xd9 &&
> +              GET_REG(insn_bytes[1]) == 0x0;
> +}
> +
> +static void process_exit_on_emulation_error(struct kvm_vm *vm)
> +{
> +       struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +       struct kvm_regs regs;
> +       uint8_t *insn_bytes;
> +       uint8_t insn_size;
> +       uint64_t flags;
> +
> +       TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
> +                   "Unexpected exit reason: %u (%s)",
> +                   run->exit_reason,
> +                   exit_reason_str(run->exit_reason));
> +
> +       TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
> +                   "Unexpected suberror: %u",
> +                   run->emulation_failure.suberror);
> +
> +       if (run->emulation_failure.ndata >= 1) {
> +               flags = run->emulation_failure.flags;
> +               if ((flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES) &&
> +                   run->emulation_failure.ndata >= 3) {
> +                       insn_size = run->emulation_failure.insn_size;
> +                       insn_bytes = run->emulation_failure.insn_bytes;
> +
> +                       TEST_ASSERT(insn_size <= 15 && insn_size > 0,
> +                                   "Unexpected instruction size: %u",
> +                                   insn_size);
> +
> +                       TEST_ASSERT(is_flds(insn_bytes, insn_size),
> +                                   "Unexpected instruction.  Expected 'flds' (0xd9 /0), encountered (0x%x /%u)",
> +                                   insn_bytes[0], (insn_size >= 2) ? GET_REG(insn_bytes[1]) : 0);

If you don't get 'flds', you shouldn't assume that the second byte is
the modr/m byte. Even if it is, the reg field may not be part of the
opcode.

> +                       vcpu_regs_get(vm, VCPU_ID, &regs);
> +                       regs.rip += (uintptr_t)(&fld_end) - (uintptr_t)(&fld_start);

A general purpose hypervisor wouldn't normally have access to these
labels, so you should really determine the length of the instruction
by decoding, *and* ensure that kvm gave you sufficient instruction
bytes. For instance, if the addressing mode involves a SIB byte and a
32-bit displacement, you would need kvm to give you at least 7 bytes.
Speaking of sufficient bytes, it would be nice to see your test
exercise the case where kvm's in-kernel emulator can't actually fetch
the full 15 bytes.

Can you comment on what else would have to be done to actually emulate
this instruction in userspace?

> +                       vcpu_regs_set(vm, VCPU_ID, &regs);
> +               }
> +       }
> +}
> +
> +static void do_guest_assert(struct kvm_vm *vm, struct ucall *uc)
> +{
> +       TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0], __FILE__,
> +                 uc->args[1]);
> +}
> +
> +static void check_for_guest_assert(struct kvm_vm *vm)
> +{
> +       struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +       struct ucall uc;
> +
> +       if (run->exit_reason == KVM_EXIT_IO &&
> +           get_ucall(vm, VCPU_ID, &uc) == UCALL_ABORT) {
> +               do_guest_assert(vm, &uc);
> +       }
> +}
> +
> +static void process_ucall_done(struct kvm_vm *vm)
> +{
> +       struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +       struct ucall uc;
> +
> +       check_for_guest_assert(vm);
> +
> +       TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +                   "Unexpected exit reason: %u (%s)",
> +                   run->exit_reason,
> +                   exit_reason_str(run->exit_reason));
> +
> +       TEST_ASSERT(get_ucall(vm, VCPU_ID, &uc) == UCALL_DONE,
> +                   "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
> +                   uc.cmd, UCALL_DONE);
> +}
> +
> +static uint64_t process_ucall(struct kvm_vm *vm)
> +{
> +       struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +       struct ucall uc;
> +
> +       TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +                   "Unexpected exit reason: %u (%s)",
> +                   run->exit_reason,
> +                   exit_reason_str(run->exit_reason));
> +
> +       switch (get_ucall(vm, VCPU_ID, &uc)) {
> +       case UCALL_SYNC:
> +               break;
> +       case UCALL_ABORT:
> +               do_guest_assert(vm, &uc);
> +               break;
> +       case UCALL_DONE:
> +               process_ucall_done(vm);
> +               break;
> +       default:
> +               TEST_ASSERT(false, "Unexpected ucall");
> +       }
> +
> +       return uc.cmd;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       struct kvm_enable_cap emul_failure_cap = {
> +               .cap = KVM_CAP_EXIT_ON_EMULATION_FAILURE,
> +               .args[0] = 1,
> +       };
> +       struct kvm_cpuid_entry2 *entry;
> +       struct kvm_cpuid2 *cpuid;
> +       struct kvm_vm *vm;
> +       uint64_t *hva;
> +       uint64_t gpa;
> +       int rc;
> +
> +       /* Tell stdout not to buffer its content */
> +       setbuf(stdout, NULL);
> +
> +       vm = vm_create_default(VCPU_ID, 0, guest_code);
> +
> +       cpuid = kvm_get_supported_cpuid();
> +
> +       entry = kvm_get_supported_cpuid_index(0x80000008, 0);
> +       if (entry) {
> +               entry->eax = (entry->eax & 0xffffff00) | MAXPHYADDR;
> +               set_cpuid(cpuid, entry);
> +       }
> +
> +       vcpu_set_cpuid(vm, VCPU_ID, cpuid);
> +
> +       entry = kvm_get_supported_cpuid_index(0x80000008, 0);
> +
> +       rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
> +       TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
> +       vm_enable_cap(vm, &emul_failure_cap);
> +
> +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +                                   MEM_REGION_GPA, MEM_REGION_SLOT,
> +                                   MEM_REGION_SIZE / PAGE_SIZE, 0);
> +       gpa = vm_phy_pages_alloc(vm, MEM_REGION_SIZE / PAGE_SIZE,
> +                                MEM_REGION_GPA, MEM_REGION_SLOT);
> +       TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
> +       virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1, 0);
> +       hva = addr_gpa2hva(vm, MEM_REGION_GPA);
> +       memset(hva, 0, PAGE_SIZE);
> +       vm_set_page_table_entry(vm, MEM_REGION_GVA, 1ull << 36);
> +
> +       run_guest(vm);
> +       process_exit_on_emulation_error(vm);
> +       run_guest(vm);
> +
> +       TEST_ASSERT(process_ucall(vm) == UCALL_DONE, "Expected UCALL_DONE");
> +
> +       kvm_vm_free(vm);
> +
> +       return 0;
> +}
> --
> 2.31.1.498.g6c1eba8ee3d-goog
>
