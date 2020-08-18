Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE08249013
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHRV0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHRV0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:26:47 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0D2C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:26:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i26so16423964edv.4
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ePPwe0gNv0+cOmOE/VdJkIsBV86QnUeFoDloYD9twhA=;
        b=iVnWjlKuj0ni0coqDj3MiH9yi8DjWK/9FizTUJd+Pmpa23v2FQPgynXsG2SCKqmAen
         8jsNDH6YjpAWlCCI+HXNMX+K2gXf8u0SyvWITTfL9ao1EDKAVC95FYscN2JxRAAZBrs9
         XUBchVp1mtFWlJGupbeKFeckyYV28HEprnQxluAYfGV2Gi65Y1eR+m8Kk0N6XyUwx6jc
         0YzTG9qMtS/OF4d4cdRqrL5tKUs9BN0IWTm+or5z3LEyHxJONShdeuLStrIV58N0lsS3
         7uleBgo+kN7/P1bYoW/Bn4+UDqfvMJCySuoLh+H+8WBZsQZMA+t7Y78O327/yvePkFTj
         PI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ePPwe0gNv0+cOmOE/VdJkIsBV86QnUeFoDloYD9twhA=;
        b=JVp4op5Kg264kPwYKu+CChnmsS0P2FCv1DGWg6KZh80TofKlr1dSF4gcIj/uLo6+pt
         RhvlqhREa4/0eecGxfKLb71X2Rb0QsRcvLAB3ujHloBe4KmTwtFNBmJg54nJSHWx7nQL
         UFvkVXfAab/PIiJ9EtwCebLcMFb75kGSzEKhaXdvJtdnEPQnoHJAcdTDwKN3kUK6ym6+
         iQ0N3lQX1x9NDwzTXytT9p9QzrBTqxbaulEKO07tCwj+WCUcbyRAm3TaCYYUR0uM7LPl
         NuFwT1KoBKc/KOVdu0idIhnlIx2t45mHPa2fnKTldGQqNiHcYc97WPBGg3fEOAuIJgPB
         R6FQ==
X-Gm-Message-State: AOAM531+TBBNkXoNyzMVy5WosXkpFm6/XnWBj9kwLXuvxhHftFVXzjGu
        Eq8n7G8CRoboHTNGg5TACpML/4OU9EZqdkLBH7UYOknml4E=
X-Google-Smtp-Source: ABdhPJyJke/NDVmBH/HYYBN9H3Vvm61a6xzFP4hpVSyBk8yG3rzXQwEzwDkPV49a2KiCxRyg9dlUC4le3ALIviCgbvE=
X-Received: by 2002:a05:6402:1758:: with SMTP id v24mr22034299edx.274.1597786004603;
 Tue, 18 Aug 2020 14:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
 <20200804042043.3592620-7-aaronlewis@google.com> <db97d3bc-801e-2adc-9351-0f536561c279@amazon.com>
In-Reply-To: <db97d3bc-801e-2adc-9351-0f536561c279@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 18 Aug 2020 14:26:32 -0700
Message-ID: <CAAAPnDE3p=gkQEftO2MEnZXQWk3DvGXctrL4Opt68FuHSYMjdA@mail.gmail.com>
Subject: Re: [PATCH 6/6] selftests: kvm: Add test to exercise userspace MSR list
To:     Alexander Graf <graf@amazon.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 4:28 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.08.20 06:20, Aaron Lewis wrote:
> >
> > Add a selftest to test that when ioctl KVM_SET_EXIT_MSRS is called with
> > an MSR list the guest exits to the host and then to userspace when an
> > MSR in that list is read from or written to.
> >
> > This test uses 3 MSRs to test these new features:
> >    1. MSR_IA32_XSS, an MSR the kernel knows about.
> >    2. MSR_IA32_FLUSH_CMD, an MSR the kernel does not know about.
> >    3. MSR_NON_EXISTENT, an MSR invented in this test for the purposes of
> >       passing a fake MSR from the guest to userspace and having the guest
> >       be able to read from and write to it, with userspace handling it.
> >       KVM just acts as a pass through.
> >
> > Userspace is also able to inject a #GP.  This is demonstrated when
> > MSR_IA32_XSS and MSR_IA32_FLUSH_CMD are misused in the test.  When this
> > happens a #GP is initiated in userspace to be thrown in the guest.  To
> > be able to handle this, exception handling was added to selftests, and a
> > #GP exception handler is registered in the test.  This allows the test
> > to inject a #GP and be able to handle it gracefully.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>
> This is so much cooler than my excuse of a self test :). I do think it
> makes for easier review (and reuse) if you split the interrupt handling
> logic from the actual user space msr bits though.

Exception handling has been moved into its own commit.

>
> > ---
> >   tools/testing/selftests/kvm/.gitignore        |   1 +
> >   tools/testing/selftests/kvm/Makefile          |  20 +-
> >   .../selftests/kvm/include/x86_64/processor.h  |  27 ++
> >   tools/testing/selftests/kvm/lib/kvm_util.c    |  17 ++
> >   .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
> >   .../selftests/kvm/lib/x86_64/handlers.S       |  83 ++++++
> >   .../selftests/kvm/lib/x86_64/processor.c      | 168 ++++++++++-
> >   .../testing/selftests/kvm/lib/x86_64/ucall.c  |   3 +
> >   .../selftests/kvm/x86_64/userspace_msr_exit.c | 271 ++++++++++++++++++
> >   9 files changed, 582 insertions(+), 10 deletions(-)
> >   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
> >   create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
> >
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 452787152748..33619f915857 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -14,6 +14,7 @@
> >   /x86_64/vmx_preemption_timer_test
> >   /x86_64/svm_vmcall_test
> >   /x86_64/sync_regs_test
> > +/x86_64/userspace_msr_exit
> >   /x86_64/vmx_close_while_nested_test
> >   /x86_64/vmx_dirty_log_test
> >   /x86_64/vmx_set_nested_state_test
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 4a166588d99f..66a6652ca305 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -34,7 +34,7 @@ ifeq ($(ARCH),s390)
> >   endif
> >
> >   LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c
> > -LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c
> > +LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> >   LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
> >   LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
> >
> > @@ -49,6 +49,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
> >   TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
> >   TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
> >   TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit
> >   TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> >   TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
> >   TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> > @@ -108,14 +109,21 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
> >   include ../lib.mk
> >
> >   STATIC_LIBS := $(OUTPUT)/libkvm.a
> > -LIBKVM_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM))
> > -EXTRA_CLEAN += $(LIBKVM_OBJ) $(STATIC_LIBS) cscope.*
> > +LIBKVM_C := $(filter %.c,$(LIBKVM))
> > +LIBKVM_S := $(filter %.S,$(LIBKVM))
> > +LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
> > +LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
> > +EXTRA_CLEAN += $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(STATIC_LIBS) cscope.*
> > +
> > +x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
> > +$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> > +       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> >
> > -x := $(shell mkdir -p $(sort $(dir $(LIBKVM_OBJ))))
> > -$(LIBKVM_OBJ): $(OUTPUT)/%.o: %.c
> > +$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
> >          $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> >
> > -$(OUTPUT)/libkvm.a: $(LIBKVM_OBJ)
> > +LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
> > +$(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
> >          $(AR) crs $@ $^
> >
> >   x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > index 0a65e7bb5249..a4de429eb408 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -36,6 +36,8 @@
> >   #define X86_CR4_SMAP           (1ul << 21)
> >   #define X86_CR4_PKE            (1ul << 22)
> >
> > +#define UNEXPECTED_VECTOR_PORT 0xfff0u
> > +
> >   /* General Registers in 64-Bit Mode */
> >   struct gpr64_regs {
> >          u64 rax;
> > @@ -239,6 +241,11 @@ static inline struct desc_ptr get_idt(void)
> >          return idt;
> >   }
> >
> > +static inline void outl(uint16_t port, uint32_t value)
> > +{
> > +       __asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
> > +}
> > +
> >   #define SET_XMM(__var, __xmm) \
> >          asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
> >
> > @@ -334,10 +341,30 @@ int _vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
> >   void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
> >                    uint64_t msr_value);
> >
> > +void kvm_set_exit_msrs(struct kvm_vm *vm, uint32_t nmsrs,
> > +       uint32_t msr_indices[]);
> > +
> >   uint32_t kvm_get_cpuid_max_basic(void);
> >   uint32_t kvm_get_cpuid_max_extended(void);
> >   void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
> >
> > +struct ex_regs {
> > +       uint64_t rax, rcx, rdx, rbx;
> > +       uint64_t dummy, rbp, rsi, rdi;
>
> Why the dummy?

It's there to match other regs layouts.  It isn't needed in this one
though, so I removed it.

>
> > +       uint64_t r8, r9, r10, r11;
> > +       uint64_t r12, r13, r14, r15;
> > +       uint64_t vector;
> > +       uint64_t error_code;
> > +       uint64_t rip;
> > +       uint64_t cs;
> > +       uint64_t rflags;
> > +};
> > +
> > +void vm_init_descriptor_tables(struct kvm_vm *vm);
> > +void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
> > +void vm_handle_exception(struct kvm_vm *vm, int vector,
> > +                       void (*handler)(struct ex_regs *));
> > +
> >   /*
> >    * Basic CPU control in CR0
> >    */
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 74776ee228f2..f8dde1cdbef0 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1195,6 +1195,21 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
> >          do {
> >                  rc = ioctl(vcpu->fd, KVM_RUN, NULL);
> >          } while (rc == -1 && errno == EINTR);
> > +
> > +#ifdef __x86_64__
> > +       if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
>
> This does feel a bit out of place here, no? Is there any particular
> reason not to handle it similar to the UCALL logic? In fact, would it
> hurt to just declare it as a new ucall? You do have a working stack
> after all ...
>

I left this as is for now.  I'm not sure it makes sense to move this
to the UCALL system because that system works on multiple platforms
and I only implemented exception handling on x86.

> > +               && vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> > +               && vcpu_state(vm, vcpuid)->io.size == 4) {
> > +               /* Grab pointer to io data */
> > +               uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> > +                       + vcpu_state(vm, vcpuid)->io.data_offset;
> > +
> > +               TEST_ASSERT(false,
> > +                           "Unexpected vectored event in guest (vector:0x%x)",
> > +                           *data);
> > +       }
> > +#endif
> > +
> >          return rc;
> >   }
> >
> > @@ -1590,6 +1605,8 @@ static struct exit_reason {
> >          {KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
> >          {KVM_EXIT_OSI, "OSI"},
> >          {KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
> > +       {KVM_EXIT_X86_RDMSR, "RDMSR"},
> > +       {KVM_EXIT_X86_WRMSR, "WRMSR"},
> >   #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
> >          {KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
> >   #endif
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> > index 2ef446520748..f07d383d03a1 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> > @@ -50,6 +50,8 @@ struct kvm_vm {
> >          vm_paddr_t pgd;
> >          vm_vaddr_t gdt;
> >          vm_vaddr_t tss;
> > +       vm_vaddr_t idt;
> > +       vm_vaddr_t handlers;
> >   };
> >
> >   struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/handlers.S b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
> > new file mode 100644
> > index 000000000000..783d2c0fc741
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
> > @@ -0,0 +1,83 @@
> > +handle_exception:
> > +       push %r15
> > +       push %r14
> > +       push %r13
> > +       push %r12
> > +       push %r11
> > +       push %r10
> > +       push %r9
> > +       push %r8
> > +
> > +       push %rdi
> > +       push %rsi
> > +       push %rbp
> > +       sub $8, %rsp
> > +       push %rbx
> > +       push %rdx
> > +       push %rcx
> > +       push %rax
> > +       mov %rsp, %rdi
> > +
> > +       call route_exception
> > +
> > +       pop %rax
> > +       pop %rcx
> > +       pop %rdx
> > +       pop %rbx
> > +       add $8, %rsp
> > +       pop %rbp
> > +       pop %rsi
> > +       pop %rdi
> > +       pop %r8
> > +       pop %r9
> > +       pop %r10
> > +       pop %r11
> > +       pop %r12
> > +       pop %r13
> > +       pop %r14
> > +       pop %r15
> > +
> > +       /* Discard vector and error code. */
> > +       add $16, %rsp
> > +       iretq
> > +
> > +/*
> > + * Build the handle_exception wrappers which push the vector/error code on the
> > + * stack and an array of pointers to those wrappers.
> > + */
> > +.pushsection .rodata
> > +.globl idt_handlers
> > +idt_handlers:
> > +.popsection
> > +
> > +.macro HANDLERS has_error from to
> > +       vector = \from
> > +       .rept \to - \from + 1
> > +       .align 8
> > +
> > +       /* Fetch current address and append it to idt_handlers. */
> > +       current_handler = .
> > +.pushsection .rodata
> > +.quad current_handler
> > +.popsection
> > +
> > +       .if ! \has_error
> > +       pushq $0
> > +       .endif
> > +       pushq $vector
> > +       jmp handle_exception
> > +       vector = vector + 1
> > +       .endr
> > +.endm
> > +
> > +.global idt_handler_code
> > +idt_handler_code:
> > +       HANDLERS has_error=0 from=0  to=7
> > +       HANDLERS has_error=1 from=8  to=8
> > +       HANDLERS has_error=0 from=9  to=9
> > +       HANDLERS has_error=1 from=10 to=14
> > +       HANDLERS has_error=0 from=15 to=16
> > +       HANDLERS has_error=1 from=17 to=17
> > +       HANDLERS has_error=0 from=18 to=255
> > +
> > +.section        .note.GNU-stack, "", %progbits
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index f6eb34eaa0d2..ff56753f205f 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -12,6 +12,13 @@
> >   #include "../kvm_util_internal.h"
> >   #include "processor.h"
> >
> > +#ifndef NUM_INTERRUPTS
> > +#define NUM_INTERRUPTS 256
> > +#endif
> > +
> > +#define DEFAULT_CODE_SELECTOR 0x8
> > +#define DEFAULT_DATA_SELECTOR 0x10
> > +
> >   /* Minimum physical address used for virtual translation tables. */
> >   #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
> >
> > @@ -392,11 +399,12 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
> >          desc->limit0 = segp->limit & 0xFFFF;
> >          desc->base0 = segp->base & 0xFFFF;
> >          desc->base1 = segp->base >> 16;
> > -       desc->s = segp->s;
> >          desc->type = segp->type;
> > +       desc->s = segp->s;
>
> This probably should go into the previous patch.

done

>
> >          desc->dpl = segp->dpl;
> >          desc->p = segp->present;
> >          desc->limit1 = segp->limit >> 16;
> > +       desc->avl = segp->avl;
> >          desc->l = segp->l;
> >          desc->db = segp->db;
> >          desc->g = segp->g;
> > @@ -556,9 +564,9 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_m
> >                  sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
> >
> >                  kvm_seg_set_unusable(&sregs.ldt);
> > -               kvm_seg_set_kernel_code_64bit(vm, 0x8, &sregs.cs);
> > -               kvm_seg_set_kernel_data_64bit(vm, 0x10, &sregs.ds);
> > -               kvm_seg_set_kernel_data_64bit(vm, 0x10, &sregs.es);
> > +               kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
> > +               kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
> > +               kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> >                  kvm_setup_tss_64bit(vm, &sregs.tr, 0x18, gdt_memslot, pgd_memslot);
> >                  break;
> >
> > @@ -843,6 +851,71 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
> >                  "  rc: %i errno: %i", r, errno);
> >   }
> >
> > +/*
> > + * _KVM Set Exit MSR
> > + *
> > + * Input Args:
> > + *   vm - Virtual Machine
> > + *   nmsrs - Number of msrs in msr_indices
> > + *   msr_indices[] - List of msrs.
> > + *
> > + * Output Args: None
> > + *
> > + * Return: The result of KVM_SET_EXIT_MSRS.
> > + *
> > + * Sets a list of MSRs that will force an exit to userspace when
> > + * any of them are read from or written to by the guest.
> > + */
> > +int _kvm_set_exit_msrs(struct kvm_vm *vm, uint32_t nmsrs,
> > +       uint32_t msr_indices[])
> > +{
> > +       const uint32_t max_nmsrs = 256;
> > +       struct kvm_msr_list *msr_list;
> > +       uint32_t i;
> > +       int r;
> > +
> > +       TEST_ASSERT(nmsrs <= max_nmsrs,
> > +               "'nmsrs' is too large.  Max is %u, currently %u.\n",
> > +               max_nmsrs, nmsrs);
> > +       uint32_t msr_list_byte_size = sizeof(struct kvm_msr_list) +
> > +                                                            (sizeof(msr_list->indices[0]) * nmsrs);
> > +       msr_list = alloca(msr_list_byte_size);
> > +       memset(msr_list, 0, msr_list_byte_size);
> > +
> > +       msr_list->nmsrs = nmsrs;
> > +       for (i = 0; i < nmsrs; i++)
> > +               msr_list->indices[i] = msr_indices[i];
> > +
> > +       r = ioctl(vm->fd, KVM_SET_EXIT_MSRS, msr_list);
> > +
> > +       return r;
> > +}
> > +
> > +/*
> > + * KVM Set Exit MSR
> > + *
> > + * Input Args:
> > + *   vm - Virtual Machine
> > + *   nmsrs - Number of msrs in msr_indices
> > + *   msr_indices[] - List of msrs.
> > + *
> > + * Output Args: None
> > + *
> > + * Return: None
> > + *
> > + * Sets a list of MSRs that will force an exit to userspace when
> > + * any of them are read from or written to by the guest.
> > + */
> > +void kvm_set_exit_msrs(struct kvm_vm *vm, uint32_t nmsrs,
> > +       uint32_t msr_indices[])
> > +{
> > +       int r;
> > +
> > +       r = _kvm_set_exit_msrs(vm, nmsrs, msr_indices);
> > +       TEST_ASSERT(r == 0, "KVM_SET_EXIT_MSRS IOCTL failed,\n"
> > +               "  rc: %i errno: %i", r, errno);
> > +}
> > +
> >   void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
> >   {
> >          va_list ap;
> > @@ -1118,3 +1191,90 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
> >                  *va_bits = (entry->eax >> 8) & 0xff;
> >          }
> >   }
> > +
> > +struct idt_entry {
> > +       uint16_t offset0;
> > +       uint16_t selector;
> > +       uint16_t ist : 3;
> > +       uint16_t : 5;
> > +       uint16_t type : 4;
> > +       uint16_t : 1;
> > +       uint16_t dpl : 2;
> > +       uint16_t p : 1;
> > +       uint16_t offset1;
> > +       uint32_t offset2; uint32_t reserved;
> > +};
> > +
> > +static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
> > +                         int dpl, unsigned short selector)
> > +{
> > +       struct idt_entry *base =
> > +               (struct idt_entry *)addr_gva2hva(vm, vm->idt);
> > +       struct idt_entry *e = &base[vector];
> > +
> > +       memset(e, 0, sizeof(*e));
> > +       e->offset0 = addr;
> > +       e->selector = selector;
> > +       e->ist = 0;
> > +       e->type = 14;
> > +       e->dpl = dpl;
> > +       e->p = 1;
> > +       e->offset1 = addr >> 16;
> > +       e->offset2 = addr >> 32;
> > +}
> > +
> > +void kvm_exit_unexpected_vector(uint32_t value)
> > +{
> > +       outl(UNEXPECTED_VECTOR_PORT, value);
> > +}
> > +
> > +void route_exception(struct ex_regs *regs)
> > +{
> > +       typedef void(*handler)(struct ex_regs *);
> > +       handler *handlers;
> > +
> > +       handlers = (handler *)rdmsr(MSR_GS_BASE);
> > +
> > +       if (handlers[regs->vector]) {
> > +               handlers[regs->vector](regs);
> > +               return;
> > +       }
> > +
> > +       kvm_exit_unexpected_vector(regs->vector);
> > +}
> > +
> > +void vm_init_descriptor_tables(struct kvm_vm *vm)
> > +{
> > +       extern void *idt_handlers;
> > +       int i;
> > +
> > +       vm->idt = vm_vaddr_alloc(vm, getpagesize(), 0x2000, 0, 0);
> > +       vm->handlers = vm_vaddr_alloc(vm, 256 * sizeof(void *), 0x2000, 0, 0);
> > +       /* Handlers have the same address in both address spaces.*/
> > +       for (i = 0; i < NUM_INTERRUPTS; i++)
> > +               set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> > +                       DEFAULT_CODE_SELECTOR);
> > +}
> > +
> > +void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +       struct kvm_sregs sregs;
> > +
> > +       vcpu_sregs_get(vm, vcpuid, &sregs);
> > +       sregs.idt.base = vm->idt;
> > +       sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
> > +       sregs.gdt.base = vm->gdt;
> > +       sregs.gdt.limit = getpagesize() - 1;
> > +       /* Use GS Base to pass the pointer to the handlers to the guest.*/
> > +       kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
> > +       sregs.gs.base = (unsigned long) vm->handlers;
> > +       vcpu_sregs_set(vm, vcpuid, &sregs);
> > +}
> > +
> > +void vm_handle_exception(struct kvm_vm *vm, int vector,
> > +                        void (*handler)(struct ex_regs *))
> > +{
> > +       vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
> > +
> > +       handlers[vector] = (vm_vaddr_t)handler;
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > index da4d89ad5419..a3489973e290 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > @@ -40,6 +40,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
> >          struct kvm_run *run = vcpu_state(vm, vcpu_id);
> >          struct ucall ucall = {};
> >
> > +       if (uc)
> > +               memset(uc, 0, sizeof(*uc));
> > +
> >          if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
> >                  struct kvm_regs regs;
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
> > new file mode 100644
> > index 000000000000..6c7868dbce08
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
> > @@ -0,0 +1,271 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2020, Google LLC.
> > + *
> > + * Tests for exiting into userspace on registered MSRs
> > + */
> > +
> > +#define _GNU_SOURCE /* for program_invocation_short_name */
> > +#include <sys/ioctl.h>
> > +
> > +#include "test_util.h"
> > +#include "kvm_util.h"
> > +#include "vmx.h"
> > +
> > +#define VCPU_ID              1
> > +
> > +#define MSR_NON_EXISTENT 0x474f4f00
> > +
> > +uint32_t msrs[] = {
> > +       /* Test an MSR the kernel knows about. */
> > +       MSR_IA32_XSS,
> > +       /* Test an MSR the kernel doesn't know about. */
> > +       MSR_IA32_FLUSH_CMD,
> > +       /* Test a fabricated MSR that no one knows about. */
> > +       MSR_NON_EXISTENT,
> > +};
> > +uint32_t nmsrs = ARRAY_SIZE(msrs);
> > +
> > +uint64_t msr_non_existent_data;
> > +int guest_exception_count;
> > +
> > +/*
> > + * Note: Force test_rdmsr() to not be inlined to prevent the labels,
> > + * rdmsr_start and rdmsr_end, from being defined multiple times.
> > + */
> > +static noinline uint64_t test_rdmsr(uint32_t msr)
> > +{
> > +       uint32_t a, d;
> > +
> > +       guest_exception_count = 0;
> > +
> > +       __asm__ __volatile__("rdmsr_start: rdmsr; rdmsr_end:" :
> > +                       "=a"(a), "=d"(d) : "c"(msr) : "memory");
>
> I personally would find
>
> asm volatile("rdmsr_start:");
> r = rdmsr(msr);
> asm volatile("rdmsr_end:");
>
> more readable. Same for wrmsr.
>
>
> The rest of the test looks very clean and nice to read. Kudos!
>
> Alex
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
