Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EABD64A7F
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfGJQKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:10:14 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37256 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbfGJQKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:10:14 -0400
Received: by mail-lf1-f68.google.com with SMTP id c9so2006042lfh.4
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 09:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=S7zvKh6p6qpA/vLKCYBkAebgOYj4b99n6LbGLr0JVhM=;
        b=L9VkRSv4nkjz0ghb2mnNzFriKzm5qhMe44KYljJbM0afKqeJNfZFLsHmvidbAd66Bu
         CwUrV48455Z87bc2D1B/yDPDVov4LbCrUmW5qdzzOlvEJnmphoL69Cbjl+11uE3RCVi/
         fvWvhMKOfK8hM25e/FLCI4AddO9zs9DNj+Siqy9YIf+/xQZ8Xbbno1NdHqp/wanYIheb
         LDhVISe7uSJc3JSBzovwJCWUpUCRqKXSkrbr94mHxiIdMsG/mVRJmXynUlktP8JMiqIm
         YvHO4jy9DRwLB2U3VhphOfYOJqIzF0YDGmt93fVyXI0R0YFEL2OPVvM705GNeBDbPNW6
         KiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=S7zvKh6p6qpA/vLKCYBkAebgOYj4b99n6LbGLr0JVhM=;
        b=VeE574O+GA9ttFlLN14goql5nt0H16ytB+UKoA72SchIfXYgkKOEXSmLFeWJ+13wkK
         NEtQwnfv0Hhx+mxmUjI3xT7GvpizoDKoPJu1/GpB+G46ZZGkn9ecMZEZ64iC4nYeyk9f
         CPb1J271zyCm2+ldN5QYWZ30bY67onL/iGATUGmxuvGZSR0yEGGTB44+ozTC4DRG5U/s
         CEpUeTb8xaqduOviasv8I9Ew4YRbgoZ2nNE9BlmeaRjVjKbDKenGXTHz84QT3oHvCgFw
         oEqQoOQYexhJ0FNCF/QqN0yL0k0x5+XW0edoQUgfiuJX0t+3c3WscUafnXkSTYoaCRi8
         wdVQ==
X-Gm-Message-State: APjAAAUyBZRU5aEDiVIyNlXMC1YEDD4uVOQa8YjnW+aX6QtwRHdBvLu8
        e6bOo0AL1tHi7B6qvE7FEWNK3UXOl+pAB5vjx+wxby+djMY=
X-Google-Smtp-Source: APXvYqzM4G/yjFi5gkeQA6iKHQmQAL87kcI505yvplqksjX7arUGQnVqxcD+KipwlGoYDALXDhFJxJSPj3lkoQNjGbQ=
X-Received: by 2002:a19:4349:: with SMTP id m9mr15168536lfj.64.1562775010116;
 Wed, 10 Jul 2019 09:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190531184236.261042-1-aaronlewis@google.com> <CAAAPnDHFUCCXSufNfy-hcF0AUBaxXsy6ZLjGiuzuS+bJ2_aZOw@mail.gmail.com>
In-Reply-To: <CAAAPnDHFUCCXSufNfy-hcF0AUBaxXsy6ZLjGiuzuS+bJ2_aZOw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 10 Jul 2019 09:09:58 -0700
Message-ID: <CAAAPnDGiP==iBuKUCnLYyVFo2_2vxF1JodV1RfZfNM1N_GumkA@mail.gmail.com>
Subject: Re: [PATCH 2/2] tests: kvm: Test virtualization of VMX capability MSRs
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 7:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> On Fri, May 31, 2019 at 11:42 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > This tests three main things:
> > 1. Test that the VMX capability MSRs can be written to and read from
> >    based on the rules in the SDM.
> > 2. Test that the MSR_IA32_VMX_CR4_FIXED1 is correctly updated in
> >    response to CPUID changes.
> > 3. Test that the VMX preemption timer rate can be cleared when the
> >    preemption timer is disabled.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
> >  .../kvm/x86_64/vmx_capability_msr_test.c      | 567 ++++++++++++++++++
> >  5 files changed, 576 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_capability_msr_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 2689d1ea6d7a..94ca75f9f4cd 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -3,6 +3,7 @@
> >  /x86_64/platform_info_test
> >  /x86_64/set_sregs_test
> >  /x86_64/sync_regs_test
> > +/x86_64/vmx_capability_msr_test
> >  /x86_64/vmx_close_while_nested_test
> >  /x86_64/vmx_tsc_adjust_test
> >  /x86_64/state_test
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index f8588cca2bef..a635a2c42592 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -18,6 +18,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/state_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> > +TEST_GEN_PROGS_x86_64 += x86_64/vmx_capability_msr_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> >  TEST_GEN_PROGS_x86_64 += dirty_log_test
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 07b71ad9734a..6a2e27cad877 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -133,6 +133,8 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_size,
> >                                  void *guest_code);
> >  void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
> >
> > +int vcpu_fd(struct kvm_vm *vm, uint32_t vcpuid);
> > +
> >  struct kvm_userspace_memory_region *
> >  kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> >                                  uint64_t end);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 4ca96b228e46..3bc4d2f633c8 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -402,6 +402,11 @@ static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
> >         free(vcpu);
> >  }
> >
> > +int vcpu_fd(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +       return vcpu_find(vm, vcpuid)->fd;
> > +}
> > +
> >  void kvm_vm_release(struct kvm_vm *vmp)
> >  {
> >         int ret;
> > diff --git a/tools/testing/selftests/kvm/x86_64/vmx_capability_msr_test.c b/tools/testing/selftests/kvm/x86_64/vmx_capability_msr_test.c
> > new file mode 100644
> > index 000000000000..161a037299f0
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/vmx_capability_msr_test.c
> > @@ -0,0 +1,567 @@
> > +/*
> > + * vmx_capability_msr_test
> > + *
> > + * Copyright (C) 2019, Google LLC.
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2.
> > + *
> > + * Test virtualization of VMX capability MSRs.
> > + */
> > +
> > +#define _GNU_SOURCE /* for program_invocation_short_name */
> > +#include <fcntl.h>
> > +#include <linux/bits.h>
> > +#include <linux/kernel.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <sys/ioctl.h>
> > +#include <sys/stat.h>
> > +#include <test_util.h>
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "vmx.h"
> > +
> > +#define VCPU_ID 0
> > +
> > +struct kvm_single_msr {
> > +       struct kvm_msrs header;
> > +       struct kvm_msr_entry entry;
> > +} __packed;
> > +
> > +struct vmx_msr {
> > +       uint32_t index;
> > +       const char *name;
> > +};
> > +#define VMX_MSR(_msr) { _msr, #_msr }
> > +
> > +struct vmx_msr vmx_msrs[] = {
> > +       VMX_MSR(MSR_IA32_VMX_BASIC),
> > +       VMX_MSR(MSR_IA32_VMX_TRUE_PINBASED_CTLS),
> > +       VMX_MSR(MSR_IA32_VMX_TRUE_PROCBASED_CTLS),
> > +       VMX_MSR(MSR_IA32_VMX_PROCBASED_CTLS2),
> > +       VMX_MSR(MSR_IA32_VMX_TRUE_EXIT_CTLS),
> > +       VMX_MSR(MSR_IA32_VMX_TRUE_ENTRY_CTLS),
> > +       VMX_MSR(MSR_IA32_VMX_MISC),
> > +       VMX_MSR(MSR_IA32_VMX_EPT_VPID_CAP),
> > +       VMX_MSR(MSR_IA32_VMX_CR0_FIXED0),
> > +       VMX_MSR(MSR_IA32_VMX_CR0_FIXED1),
> > +       VMX_MSR(MSR_IA32_VMX_CR4_FIXED0),
> > +       VMX_MSR(MSR_IA32_VMX_CR4_FIXED1),
> > +       VMX_MSR(MSR_IA32_VMX_VMCS_ENUM),
> > +};
> > +
> > +struct kvm_vm *vm;
> > +
> > +void guest_code(void)
> > +{
> > +       __asm__ __volatile__(
> > +               "1:"
> > +               "rdmsr;"
> > +               "outw $0;"
> > +               "jmp 1b;"
> > +       );
> > +}
> > +
> > +uint64_t read_msr_from_guest(uint32_t msr)
> > +{
> > +       unsigned int exit_reason, expected_exit = KVM_EXIT_IO;
> > +       struct kvm_regs regs;
> > +
> > +       vcpu_regs_get(vm, VCPU_ID, &regs);
> > +       regs.rcx = msr;
> > +       regs.rax = 0;
> > +       regs.rdx = 0;
> > +       vcpu_regs_set(vm, VCPU_ID, &regs);
> > +
> > +       vcpu_run(vm, VCPU_ID);
> > +       vcpu_regs_get(vm, VCPU_ID, &regs);
> > +
> > +       exit_reason = vcpu_state(vm, VCPU_ID)->exit_reason;
> > +       TEST_ASSERT(exit_reason == expected_exit,
> > +                   "Unexpected exit reason: expected %u (%s), got %u (%s) [guest rip: %llx]",
> > +                   expected_exit, exit_reason_str(expected_exit),
> > +                   exit_reason, exit_reason_str(exit_reason),
> > +                   regs.rip);
> > +
> > +       return (regs.rdx << 32) | regs.rax;
> > +}
> > +
> > +int try_kvm_get_msr(int vcpu_fd, uint32_t msr, uint64_t *data)
> > +{
> > +       struct kvm_single_msr buffer;
> > +       int rv;
> > +
> > +       memset(&buffer, 0, sizeof(buffer));
> > +       buffer.header.nmsrs = 1;
> > +       buffer.entry.index = msr;
> > +
> > +       /* Returns the number of MSRs read. */
> > +       rv = ioctl(vcpu_fd, KVM_GET_MSRS, &buffer);
> > +       *data = buffer.entry.data;
> > +       return rv;
> > +}
> > +
> > +uint64_t kvm_get_msr(int vcpu_fd, uint32_t msr)
> > +{
> > +       uint64_t data;
> > +       int rv;
> > +
> > +       rv = try_kvm_get_msr(vcpu_fd, msr, &data);
> > +       TEST_ASSERT(rv == 1, "KVM_GET_MSR of MSR %x failed. (rv %d)",
> > +                   msr, rv);
> > +
> > +       return data;
> > +}
> > +
> > +void kvm_get_msr_expect_fail(int vcpu_fd, uint32_t msr)
> > +{
> > +       uint64_t data;
> > +       int rv;
> > +
> > +       rv = try_kvm_get_msr(vcpu_fd, msr, &data);
> > +       TEST_ASSERT(rv != 1, "Expected KVM_GET_MSR of MSR %x to fail.", msr);
> > +}
> > +
> > +int try_kvm_set_msr(int vcpu_fd, uint32_t msr, uint64_t data)
> > +{
> > +       struct kvm_single_msr buffer;
> > +       int rv;
> > +
> > +       memset(&buffer, 0, sizeof(buffer));
> > +       buffer.header.nmsrs = 1;
> > +       buffer.entry.index = msr;
> > +       buffer.entry.data = data;
> > +
> > +       /* Returns the number of MSRs written. */
> > +       rv = ioctl(vcpu_fd, KVM_SET_MSRS, &buffer);
> > +       return rv;
> > +}
> > +
> > +void kvm_set_msr_expect_fail(int vcpu_fd, uint32_t msr, uint64_t data)
> > +{
> > +       int rv;
> > +
> > +       rv = try_kvm_set_msr(vcpu_fd, msr, data);
> > +       TEST_ASSERT(rv != 1, "Expected KVM_SET_MSR of MSR %x to fail.", msr);
> > +}
> > +
> > +void kvm_set_msr(int vcpu_fd, uint32_t msr, uint64_t data)
> > +{
> > +       int rv;
> > +
> > +       rv = try_kvm_set_msr(vcpu_fd, msr, data);
> > +       TEST_ASSERT(rv == 1, "KVM_SET_MSR %x (data %lx) failed.", msr, data);
> > +}
> > +
> > +void test_set_vmx_msr(int vcpu_fd, uint32_t msr, uint64_t data)
> > +{
> > +       uint64_t guest, kvm;
> > +       uint64_t non_true;
> > +
> > +       kvm_set_msr(vcpu_fd, msr, data);
> > +
> > +       guest = read_msr_from_guest(msr);
> > +       kvm = kvm_get_msr(vcpu_fd, msr);
> > +
> > +       TEST_ASSERT(guest == data,
> > +                   "KVM_SET_MSR %x not visible from guest (guest %lx, expected %lx)",
> > +                   msr, guest, data);
> > +
> > +       TEST_ASSERT(kvm == data,
> > +                   "KVM_SET_MSR %x not visible from host (host %lx, expected %lx)",
> > +                   msr, kvm, data);
> > +
> > +#define IA32_VMX_PINBASED_CTLS_DEFAULT1 (BIT_ULL(1) | BIT_ULL(2) | BIT_ULL(4))
> > +#define IA32_VMX_PROCBASED_CTLS_DEFAULT1 (BIT_ULL(1) | BIT_ULL(4) | \
> > +                                         BIT_ULL(5) | BIT_ULL(6) | \
> > +                                         BIT_ULL(8) | BIT_ULL(13) | \
> > +                                         BIT_ULL(14) | BIT_ULL(15) | \
> > +                                         BIT_ULL(16) | BIT_ULL(26))
> > +#define IA32_VMX_EXIT_CTLS_DEFAULT1 (BIT_ULL(0) | BIT_ULL(1) | BIT_ULL(2) | \
> > +                                    BIT_ULL(3) | BIT_ULL(4) | BIT_ULL(5) | \
> > +                                    BIT_ULL(6) | BIT_ULL(7) | BIT_ULL(8) | \
> > +                                    BIT_ULL(10) | BIT_ULL(11) | BIT_ULL(13) | \
> > +                                    BIT_ULL(14) | BIT_ULL(16) | BIT_ULL(17))
> > +#define IA32_VMX_ENTRY_CTLS_DEFAULT1 (BIT_ULL(0) | BIT_ULL(1) | BIT_ULL(2) | \
> > +                                     BIT_ULL(3) | BIT_ULL(4) | BIT_ULL(5) | \
> > +                                     BIT_ULL(6) | BIT_ULL(7) | BIT_ULL(8) | \
> > +                                     BIT_ULL(12))
> > +       /*
> > +        * Make sure non-true MSRs are equal to the true MSRs with all the
> > +        * default1 bits set.
> > +        */
> > +       switch (msr) {
> > +       case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
> > +               non_true = kvm_get_msr(vcpu_fd, MSR_IA32_VMX_PINBASED_CTLS);
> > +               TEST_ASSERT(non_true ==
> > +                           (data | IA32_VMX_PINBASED_CTLS_DEFAULT1),
> > +                           "Incorrect IA32_VMX_PINBASED_CTLS MSR: %lx\n",
> > +                           non_true);
> > +               break;
> > +       case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
> > +               non_true = kvm_get_msr(vcpu_fd, MSR_IA32_VMX_PROCBASED_CTLS);
> > +               TEST_ASSERT(non_true ==
> > +                           (data | IA32_VMX_PROCBASED_CTLS_DEFAULT1),
> > +                           "Incorrect IA32_VMX_PROCBASED_CTLS MSR: %lx\n",
> > +                           non_true);
> > +               break;
> > +       case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> > +               non_true = kvm_get_msr(vcpu_fd, MSR_IA32_VMX_EXIT_CTLS);
> > +               TEST_ASSERT(non_true == (data | IA32_VMX_EXIT_CTLS_DEFAULT1),
> > +                           "Incorrect IA32_VMX_EXIT_CTLS MSR: %lx\n",
> > +                           non_true);
> > +               break;
> > +       case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> > +               non_true = kvm_get_msr(vcpu_fd, MSR_IA32_VMX_ENTRY_CTLS);
> > +               TEST_ASSERT(non_true == (data | IA32_VMX_ENTRY_CTLS_DEFAULT1),
> > +                           "Incorrect IA32_VMX_ENTRY_CTLS MSR: %lx\n",
> > +                           non_true);
> > +               break;
> > +       }
> > +}
> > +
> > +/*
> > + * Reset the VCPU and return its file descriptor.
> > + *
> > + * The VCPU should be reset in between subsequent restores of the
> > + * same VMX MSR.
> > + */
> > +int reset_vcpu_fd(bool vmx_supported)
> > +{
> > +       struct kvm_cpuid2 *cpuid;
> > +       int fd;
> > +
> > +       if (vm)
> > +               kvm_vm_free(vm);
> > +
> > +       vm = vm_create_default(VCPU_ID, 0, guest_code);
> > +       fd = vcpu_fd(vm, VCPU_ID);
> > +
> > +       /* Enable/Disable VMX */
> > +       if (vmx_supported)
> > +               kvm_get_supported_cpuid_entry(0x1)->ecx |= (1 << 5);
> > +       else
> > +               kvm_get_supported_cpuid_entry(0x1)->ecx &= ~(1 << 5);
> > +       cpuid = kvm_get_supported_cpuid();
> > +       vcpu_set_cpuid(vm, VCPU_ID, cpuid);
> > +
> > +       return fd;
> > +}
> > +
> > +void test_msr_bits(uint32_t index, int high, int low, bool allowed_1)
> > +{
> > +       int fd = reset_vcpu_fd(true);
> > +       uint64_t value = kvm_get_msr(fd, index);
> > +       int i;
> > +
> > +       for (i = low; i <= high; i++) {
> > +               uint64_t mask = 1ull << i;
> > +               bool is_1 = value & mask;
> > +
> > +               fd = reset_vcpu_fd(true);
> > +
> > +               /*
> > +                * Following VMX nomenclature:
> > +                *
> > +                * allowed-1 means a bit is high when it can be 0 or 1. The
> > +                * bit is low when it must be 0.
> > +                *
> > +                * allowed-0 (!allowed_1) means a bit is low when it can be
> > +                * 0 or 1. The bit is high when it must be 1.
> > +                */
> > +               if (allowed_1 && is_1)
> > +                       test_set_vmx_msr(fd, index, value & ~mask);
> > +               else if (!allowed_1 && !is_1)
> > +                       test_set_vmx_msr(fd, index, value | mask);
> > +               else if (allowed_1 && !is_1)
> > +                       kvm_set_msr_expect_fail(fd, index, value | mask);
> > +               else
> > +                       kvm_set_msr_expect_fail(fd, index, value & ~mask);
> > +       }
> > +}
> > +
> > +void test_allowed_1_bits(uint32_t index, int high, int low)
> > +{
> > +       test_msr_bits(index, high, low, true);
> > +}
> > +#define test_allowed_1_bit(_index, _bit) \
> > +       test_allowed_1_bits(_index, _bit, _bit)
> > +
> > +void test_allowed_0_bits(uint32_t index, int high, int low)
> > +{
> > +       test_msr_bits(index, high, low, false);
> > +}
> > +
> > +uint64_t get_bits(uint64_t value, int high, int low)
> > +{
> > +       return (value & GENMASK_ULL(high, low)) >> low;
> > +}
> > +
> > +uint64_t set_bits(uint64_t value, int high, int low, uint64_t new_value)
> > +{
> > +       uint64_t mask = GENMASK_ULL(high, low);
> > +
> > +       return (value & ~mask) | ((new_value << low) & mask);
> > +}
> > +
> > +/*
> > + * Test MSR[high:low].
> > + *
> > + * lt : KVM should support values less than the default.
> > + * gt : KVM should support values greater than the default.
> > + */
> > +void __test_msr_bits_eq(uint32_t index, int high, int low, bool lt, bool gt)
> > +{
> > +       int fd = reset_vcpu_fd(true);
> > +       uint64_t value = kvm_get_msr(fd, index);
> > +       uint64_t bits = get_bits(value, high, low);
> > +       uint64_t new_value;
> > +
> > +       if (bits > 0) {
> > +               fd = reset_vcpu_fd(true);
> > +               new_value = set_bits(value, high, low, bits - 1);
> > +               if (lt)
> > +                       test_set_vmx_msr(fd, index, new_value);
> > +               else
> > +                       kvm_set_msr_expect_fail(fd, index, new_value);
> > +       }
> > +
> > +       if (bits < get_bits(-1ull, high, low)) {
> > +               fd = reset_vcpu_fd(true);
> > +               new_value = set_bits(value, high, low, bits + 1);
> > +               if (gt)
> > +                       test_set_vmx_msr(fd, index, new_value);
> > +               else
> > +                       kvm_set_msr_expect_fail(fd, index, new_value);
> > +       }
> > +}
> > +
> > +#define test_msr_bits_eq(...) __test_msr_bits_eq(__VA_ARGS__, false, false)
> > +#define test_msr_bits_le(...) __test_msr_bits_eq(__VA_ARGS__, true, false)
> > +
> > +void test_rw_vmx_capability_msrs(void)
> > +{
> > +       int i;
> > +
> > +       printf("VMX MSR default values:\n");
> > +
> > +       for (i = 0; i < ARRAY_SIZE(vmx_msrs); i++) {
> > +               uint32_t msr = vmx_msrs[i].index;
> > +               uint64_t guest, kvm;
> > +               int vcpu_fd;
> > +
> > +               /*
> > +                * If VMX is not supported, test that reading the VMX MSRs
> > +                * fails.
> > +                */
> > +               vcpu_fd = reset_vcpu_fd(false);
> > +               kvm_get_msr_expect_fail(vcpu_fd, msr);
> > +
> > +               vcpu_fd = reset_vcpu_fd(true);
> > +               guest = read_msr_from_guest(msr);
> > +               kvm = kvm_get_msr(vcpu_fd, msr);
> > +
> > +               TEST_ASSERT(guest == kvm,
> > +                           "MSR %x mismatch: guest %lx kvm %lx.",
> > +                           msr, guest, kvm);
> > +
> > +               printf("{ %s, 0x%lx },\n", vmx_msrs[i].name, guest);
> > +
> > +               /* VM Execution Control Capability MSRs */
> > +               switch (msr) {
> > +               case MSR_IA32_VMX_BASIC:
> > +                       test_set_vmx_msr(vcpu_fd, msr, guest); /* identity */
> > +                       test_msr_bits_eq(msr, 30, 0); /* vmcs revision */
> > +                       test_allowed_1_bit(msr, 31); /* reserved */
> > +                       test_allowed_1_bit(msr, 48); /* VMCS phys bits */
> > +                       test_allowed_1_bit(msr, 49); /* dual-monitor SMI/SMM */
> > +                       test_allowed_1_bit(msr, 54); /* ins/outs info */
> > +                       test_allowed_1_bit(msr, 55); /* true ctls */
> > +                       break;
> > +               case MSR_IA32_VMX_MISC:
> > +                       test_set_vmx_msr(vcpu_fd, msr, guest); /* identity */
> > +                       test_msr_bits_eq(msr, 4, 0); /* preempt timer rate */
> > +                       test_allowed_1_bit(msr, 5); /* store IA-32e mode */
> > +                       test_allowed_1_bits(msr, 8, 6); /* activity states */
> > +                       test_allowed_1_bits(msr, 13, 9); /* reserved */
> > +                       test_allowed_1_bit(msr, 14); /* pt in vmx mode */
> > +                       test_allowed_1_bit(msr, 15); /* smbase msr in smm */
> > +                       test_msr_bits_le(msr, 24, 16); /* CR3-target values */
> > +                       test_msr_bits_le(msr, 27, 25); /* MSR-store list size */
> > +                       test_allowed_1_bit(msr, 28); /* smm_monitor_ctl 1 */
> > +                       test_allowed_1_bit(msr, 29); /* vmwrite to any */
> > +                       test_allowed_1_bit(msr, 30); /* insn len 0 allowed */
> > +                       test_allowed_1_bit(msr, 31); /* reserved */
> > +                       test_msr_bits_eq(msr, 63, 32); /* MSEG Revision */
> > +                       break;
> > +               case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
> > +               case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
> > +               case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> > +               case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> > +               case MSR_IA32_VMX_PROCBASED_CTLS2:
> > +                       test_set_vmx_msr(vcpu_fd, msr, guest); /* identity */
> > +                       test_allowed_0_bits(msr, 31, 0); /* allowed-1 bits */
> > +                       test_allowed_1_bits(msr, 63, 32); /* allowed-0 bits */
> > +                       break;
> > +               case MSR_IA32_VMX_EPT_VPID_CAP:
> > +                       test_set_vmx_msr(vcpu_fd, msr, guest); /* identity */
> > +                       test_allowed_1_bits(msr, 63, 0); /* feature/reserved */
> > +                       break;
> > +               case MSR_IA32_VMX_CR0_FIXED0:
> > +               case MSR_IA32_VMX_CR4_FIXED0:
> > +                       test_set_vmx_msr(vcpu_fd, msr, guest); /* identity */
> > +                       test_allowed_0_bits(msr, 63, 0); /* allowed-0 bits */
> > +                       break;
> > +               case MSR_IA32_VMX_CR0_FIXED1:
> > +               case MSR_IA32_VMX_CR4_FIXED1:
> > +                       /* These MSRs do not allow save-restore. */
> > +                       kvm_set_msr_expect_fail(vcpu_fd, msr, guest);
> > +                       break;
> > +               case MSR_IA32_VMX_PROCBASED_CTLS:
> > +               case MSR_IA32_VMX_PINBASED_CTLS:
> > +               case MSR_IA32_VMX_EXIT_CTLS:
> > +               case MSR_IA32_VMX_ENTRY_CTLS:
> > +                       test_set_vmx_msr(vcpu_fd, msr, guest); /* identity */
> > +                       break;
> > +               case MSR_IA32_VMX_VMCS_ENUM:
> > +                       test_allowed_1_bit(msr, 0); /* reserved */
> > +                       test_allowed_1_bits(msr, 63, 10); /* reserved */
> > +                       break;
> > +               default:
> > +                       TEST_ASSERT(false, "Untested MSR: 0x%x.", msr);
> > +               }
> > +       }
> > +}
> > +
> > +struct msr {
> > +       uint32_t index;
> > +       uint64_t data;
> > +};
> > +
> > +/*
> > + * Test that MSR_IA32_VMX_CR4_FIXED1 is correctly updated in response to
> > + * CPUID changes.
> > + */
> > +void test_cr4_fixed1_cpuid(void)
> > +{
> > +       struct test {
> > +               uint64_t cr4_mask;
> > +               int function;
> > +               enum x86_register reg;
> > +               int cpuid_bit;
> > +               const char *name;
> > +       } tests[] = {
> > +               { X86_CR4_VME,        1, RDX, 1,  "VME" },
> > +               { X86_CR4_PVI,        1, RDX, 1,  "PVI" },
> > +               { X86_CR4_TSD,        1, RDX, 4,  "TSD" },
> > +               { X86_CR4_DE,         1, RDX, 2,  "DE" },
> > +               { X86_CR4_PSE,        1, RDX, 3,  "PSE" },
> > +               { X86_CR4_PAE,        1, RDX, 6,  "PAE" },
> > +               { X86_CR4_MCE,        1, RDX, 7,  "MCE" },
> > +               { X86_CR4_PGE,        1, RDX, 13, "PGE" },
> > +               { X86_CR4_OSFXSR,     1, RDX, 24, "OSFXSR" },
> > +               { X86_CR4_OSXMMEXCPT, 1, RDX, 25, "OSXMMEXCPT" },
> > +               { X86_CR4_UMIP,       7, RCX, 2,  "UMIP" },
> > +               { X86_CR4_VMXE,       1, RCX, 5,  "VMXE" },
> > +               { X86_CR4_SMXE,       1, RCX, 6,  "SMXE" },
> > +               { X86_CR4_FSGSBASE,   7, RBX, 0,  "FSGSBASE" },
> > +               { X86_CR4_PCIDE,      1, RCX, 17, "PCIDE" },
> > +               { X86_CR4_OSXSAVE,    1, RCX, 26, "OSXSAVE" },
> > +               { X86_CR4_SMEP,       7, RBX, 7,  "SMEP" },
> > +               { X86_CR4_SMAP,       7, RBX, 20, "SMAP" },
> > +               { X86_CR4_PKE,        7, RCX, 3,  "PKE" },
> > +       };
> > +       int vcpu_fd = reset_vcpu_fd(true);
> > +       int i;
> > +
> > +       kvm_get_supported_cpuid_entry(0x1)->ecx |= (1 << 5);
> > +
> > +       for (i = 0; i < ARRAY_SIZE(tests); i++) {
> > +               struct test *test = &tests[i];
> > +               struct kvm_cpuid_entry2 *entry;
> > +               struct kvm_cpuid2 *cpuid = kvm_get_supported_cpuid();
> > +               const char *reg_name = NULL;
> > +               uint64_t fixed1;
> > +               uint32_t *reg = NULL;
> > +
> > +               entry = kvm_get_supported_cpuid_entry(test->function);
> > +               TEST_ASSERT(entry, "CPUID lookup failed: CPUID.%02xH",
> > +                           test->function);
> > +
> > +               switch (test->reg) {
> > +               case RAX:
> > +                       reg = &entry->eax; reg_name = "EAX";
> > +                       break;
> > +               case RBX:
> > +                       reg = &entry->ebx; reg_name = "EBX";
> > +                       break;
> > +               case RCX:
> > +                       reg = &entry->ecx; reg_name = "ECX";
> > +                       break;
> > +               case RDX:
> > +                       reg = &entry->edx; reg_name = "EDX";
> > +                       break;
> > +               default:
> > +                       TEST_ASSERT(false, "Unrecognized reg: %d", test->reg);
> > +               }
> > +
> > +               printf("MSR_IA32_VMX_CR4_FIXED1[%d] (%s) == CPUID.%02xH:%s[%d]\n",
> > +                      __builtin_ffsll(test->cr4_mask) - 1, test->name,
> > +                      test->function, reg_name, test->cpuid_bit);
> > +
> > +
> > +               *reg |= 1ull << test->cpuid_bit;
> > +               vcpu_set_cpuid(vm, VCPU_ID, cpuid);
> > +               fixed1 = kvm_get_msr(vcpu_fd, MSR_IA32_VMX_CR4_FIXED1);
> > +               TEST_ASSERT(fixed1 & test->cr4_mask, "set bit");
> > +               TEST_ASSERT(fixed1 & X86_CR4_PCE, "PCE");
> > +
> > +               /*
> > +                * Skipping clearing support for VMX. VMX is required for
> > +                * MSR_IA32_VMX_CR4_FIXED1 to even exist.
> > +                */
> > +               if (test->cr4_mask == X86_CR4_VMXE)
> > +                       continue;
> > +
> > +               *reg &= ~(1ull << test->cpuid_bit);
> > +               vcpu_set_cpuid(vm, VCPU_ID, cpuid);
> > +               fixed1 = kvm_get_msr(vcpu_fd, MSR_IA32_VMX_CR4_FIXED1);
> > +               TEST_ASSERT(!(fixed1 & test->cr4_mask), "clear bit");
> > +               TEST_ASSERT(fixed1 & X86_CR4_PCE, "PCE");
> > +       };
> > +}
> > +
> > +void test_preemption_timer_capability(void)
> > +{
> > +       int fd = reset_vcpu_fd(true);
> > +       uint64_t vmx_misc = kvm_get_msr(fd, MSR_IA32_VMX_MISC);
> > +       uint64_t pinbased = kvm_get_msr(fd, MSR_IA32_VMX_TRUE_PINBASED_CTLS);
> > +
> > +#define VMX_PREEMPTION_TIMER_CONTROL \
> > +       ((uint64_t) PIN_BASED_VMX_PREEMPTION_TIMER << 32)
> > +#define VMX_PREEMPTION_TIMER_RATE 0x1f
> > +
> > +       TEST_ASSERT(pinbased & VMX_PREEMPTION_TIMER_CONTROL,
> > +                   "Expected support for VMX preemption timer.");
> > +
> > +       /* Test that we can disable the VMX preemption timer. */
> > +       test_set_vmx_msr(fd, MSR_IA32_VMX_TRUE_PINBASED_CTLS,
> > +                        pinbased & ~VMX_PREEMPTION_TIMER_CONTROL);
> > +
> > +       /*
> > +        * Test that we can clear the VMX preemption timer rate when
> > +        * the preemption timer is disabled.
> > +        */
> > +       test_set_vmx_msr(fd, MSR_IA32_VMX_MISC,
> > +                        vmx_misc & ~VMX_PREEMPTION_TIMER_RATE);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +       test_rw_vmx_capability_msrs();
> > +       test_cr4_fixed1_cpuid();
> > +       test_preemption_timer_capability();
> > +       return 0;
> > +}
> > --
> > 2.22.0.rc1.311.g5d7573a151-goog
> >
>
> ping

ping
