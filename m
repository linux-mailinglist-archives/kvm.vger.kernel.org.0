Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A493C4DA89
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfFTTrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 15:47:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45258 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFTTrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 15:47:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id u10so3253890lfm.12
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 12:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+6GpvkkLHBzblr7dSrSSfB3sGjhWPdhP4XeAV3nfyo=;
        b=IBNhwV1/aPVV8rYe/QO7b5Zlp1O4nRXfQmy3KEoHJM+sSi9AjNNonJphRPrZ2fYXbX
         1niYqaQifG/7nMfID2NLE4oeSe62bB6p8ZRqJOxU/YyMcR808EBmNvxtF0AOZiU87b+f
         R9FYnu/5HprAOPjrAt4kXxBXL3jywWBhssiqS0gfEMJQ6SZ77hVXiseHvauwBKTvsV9r
         YTCEd71ARSiqYsYIrkPN3rn/AbXXK0k786GmR3e01Qjn1kjK79OYirD8ysJSzdQ9AwgZ
         fyksV06yi8tKR1U74XSyGTn4815d5lSpRl3OLlCqp09Koi0JBElLzRPsWxtySSt2J0pC
         eSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+6GpvkkLHBzblr7dSrSSfB3sGjhWPdhP4XeAV3nfyo=;
        b=eNI0Ev4JCigY2ZtJWX2LvqCI2sfp+lQqCkiKZmSy2vsxfniJWsdozlgqWP9kdD0RV3
         jPydPbfAtNZweBxfXogS8nd6EJDo3MMpdQi9H2Z/e0MGdWYdQax2WORNj+q3unYwxt6n
         qacNzFFqqcniMuvrK8Job59VQNaDRbm75UfgZg/fovZXyPEGqBPySpimXzNjarM2sk9F
         EFYQNb5KLsUKhX+A/8ypWM6Z7KELMZiDvR8osX9i5mX5apCBbknXuYPEJq97qQbAYTrp
         s5knKdTro4IVEXRLsUWgphOhxYKWjLuZ3OM3tmmsMwtDav0o8qSPOH6PPWWifDwTMRI6
         sWLg==
X-Gm-Message-State: APjAAAX0EMYn2esVBH3gAq+NgSqlUjE8MSEkHp1Axfw5x2EDTHcrJa5G
        8+9ShUGxH8faskCeilW5D9MKmRpyik6nV2AkwjJ4dA==
X-Google-Smtp-Source: APXvYqyaetXs0QoMSpIEwul15AngBUz+Ar7h3mBttlKwz9Xnp8vTirZpuGQdi85vpgQyCKyOXQetXkK4iegNPOnNYzQ=
X-Received: by 2002:ac2:53a5:: with SMTP id j5mr24846346lfh.172.1561060067455;
 Thu, 20 Jun 2019 12:47:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190531141452.158909-1-aaronlewis@google.com>
 <CAAAPnDHLk=8SMKVy9-mPWWt2t+WX4xS+BKLQJox7vbnHwK50BA@mail.gmail.com>
 <4fdb4b8f-2c8e-c148-6f94-cb51d620a49b@oracle.com> <CAAAPnDERqGrYJoe4nUP9FefHGx4Wx=ioKiiSwBy0iimbvqwJLw@mail.gmail.com>
 <8774fa34-fccd-5828-026e-af91f3f0fa40@oracle.com>
In-Reply-To: <8774fa34-fccd-5828-026e-af91f3f0fa40@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 20 Jun 2019 12:47:36 -0700
Message-ID: <CAAAPnDGcGrKnrrUowWgBz6aKEv0YrE02rHgBMLEKsd-=5L77iw@mail.gmail.com>
Subject: Re: [PATCH] tests: kvm: Check for a kernel warning
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 20, 2019 at 11:17 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 6/20/19 7:12 AM, Aaron Lewis wrote:
> > On Tue, Jun 18, 2019 at 12:38 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >>
> >>
> >> On 06/18/2019 07:13 AM, Aaron Lewis wrote:
> >>> On Fri, May 31, 2019 at 7:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >>>> When running with /sys/module/kvm_intel/parameters/unrestricted_guest=N,
> >>>> test that a kernel warning does not occur informing us that
> >>>> vcpu->mmio_needed=1.  This can happen when KVM_RUN is called after a
> >>>> triple fault.
> >>>> This test was made to detect a bug that was reported by Syzkaller
> >>>> (https://groups.google.com/forum/#!topic/syzkaller/lHfau8E3SOE) and
> >>>> fixed with commit bbeac2830f4de ("KVM: X86: Fix residual mmio emulation
> >>>> request to userspace").
> >>>>
> >>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >>>> Reviewed-by: Jim Mattson <jmattson@google.com>
> >>>> Reviewed-by: Peter Shier <pshier@google.com>
> >>>> ---
> >>>>    tools/testing/selftests/kvm/.gitignore        |   1 +
> >>>>    tools/testing/selftests/kvm/Makefile          |   1 +
> >>>>    .../testing/selftests/kvm/include/kvm_util.h  |   2 +
> >>>>    .../selftests/kvm/include/x86_64/processor.h  |   2 +
> >>>>    tools/testing/selftests/kvm/lib/kvm_util.c    |  36 +++++
> >>>>    .../selftests/kvm/lib/x86_64/processor.c      |  16 +++
> >>>>    .../selftests/kvm/x86_64/mmio_warning_test.c  | 126 ++++++++++++++++++
> >>>>    7 files changed, 184 insertions(+)
> >>>>    create mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> >>>>
> >>>> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> >>>> index df1bf9230a74..41266af0d3dc 100644
> >>>> --- a/tools/testing/selftests/kvm/.gitignore
> >>>> +++ b/tools/testing/selftests/kvm/.gitignore
> >>>> @@ -2,6 +2,7 @@
> >>>>    /x86_64/evmcs_test
> >>>>    /x86_64/hyperv_cpuid
> >>>>    /x86_64/kvm_create_max_vcpus
> >>>> +/x86_64/mmio_warning_test
> >>>>    /x86_64/platform_info_test
> >>>>    /x86_64/set_sregs_test
> >>>>    /x86_64/smm_test
> >>>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> >>>> index 79c524395ebe..670b938f1049 100644
> >>>> --- a/tools/testing/selftests/kvm/Makefile
> >>>> +++ b/tools/testing/selftests/kvm/Makefile
> >>>> @@ -22,6 +22,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> >>>>    TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> >>>>    TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
> >>>>    TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> >>>> +TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> >>>>    TEST_GEN_PROGS_x86_64 += dirty_log_test
> >>>>    TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
> >>>>
> >>>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> >>>> index 8c6b9619797d..c5c427c86598 100644
> >>>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> >>>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> >>>> @@ -137,6 +137,8 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_size,
> >>>>                                    void *guest_code);
> >>>>    void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
> >>>>
> >>>> +bool vm_is_unrestricted_guest(struct kvm_vm *vm);
> >>>> +
> >>>>    struct kvm_userspace_memory_region *
> >>>>    kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> >>>>                                    uint64_t end);
> >>>> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> >>>> index 6063d5b2f356..af4d26de32d1 100644
> >>>> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> >>>> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> >>>> @@ -303,6 +303,8 @@ static inline unsigned long get_xmm(int n)
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> +bool is_intel_cpu(void);
> >>>> +
> >>>>    struct kvm_x86_state;
> >>>>    struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
> >>>>    void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
> >>>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> >>>> index e9113857f44e..b93b09ad9a11 100644
> >>>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> >>>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> >>>> @@ -1584,3 +1584,39 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
> >>>>    {
> >>>>           return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
> >>>>    }
> >>>> +
> >>>> +/*
> >>>> + * Is Unrestricted Guest
> >>>> + *
> >>>> + * Input Args:
> >>>> + *   vm - Virtual Machine
> >>>> + *
> >>>> + * Output Args: None
> >>>> + *
> >>>> + * Return: True if the unrestricted guest is set to 'Y', otherwise return false.
> >>>> + *
> >>>> + * Check if the unrestricted guest flag is enabled.
> >>>> + */
> >>>> +bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> >>>> +{
> >>>> +       char val = 'N';
> >>>> +       size_t count;
> >>>> +       FILE *f;
> >>>> +
> >>>> +       if (vm == NULL) {
> >>>> +               /* Ensure that the KVM vendor-specific module is loaded. */
> >>>> +               f = fopen(KVM_DEV_PATH, "r");
> >>>> +               TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
> >>>> +                           errno);
> >>>> +               fclose(f);
> >>>> +       }
> >>>> +
> >>>> +       f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> >>>> +       if (f) {
> >>>> +               count = fread(&val, sizeof(char), 1, f);
> >>>> +               TEST_ASSERT(count == 1, "Unable to read from param file.");
> >>>> +               fclose(f);
> >>>> +       }
> >>>> +
> >>>> +       return val == 'Y';
> >>>> +}
> >>>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> >>>> index dc7fae9fa424..bcc0e70e1856 100644
> >>>> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> >>>> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> >>>> @@ -1139,3 +1139,19 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
> >>>>                           r);
> >>>>           }
> >>>>    }
> >>>> +
> >>>> +bool is_intel_cpu(void)
> >>>> +{
> >>>> +       int eax, ebx, ecx, edx;
> >>>> +       const uint32_t *chunk;
> >>>> +       const int leaf = 0;
> >>>> +
> >>>> +       __asm__ __volatile__(
> >>>> +               "cpuid"
> >>>> +               : /* output */ "=a"(eax), "=b"(ebx),
> >>>> +                 "=c"(ecx), "=d"(edx)
> >>>> +               : /* input */ "0"(leaf), "2"(0));
> >>>> +
> >>>> +       chunk = (const uint32_t *)("GenuineIntel");
> >>>> +       return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
> >>>> +}
> >>>> diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> >>>> new file mode 100644
> >>>> index 000000000000..00bb97d76000
> >>>> --- /dev/null
> >>>> +++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> >>>> @@ -0,0 +1,126 @@
> >>>> +/*
> >>>> + * mmio_warning_test
> >>>> + *
> >>>> + * Copyright (C) 2019, Google LLC.
> >>>> + *
> >>>> + * This work is licensed under the terms of the GNU GPL, version 2.
> >>>> + *
> >>>> + * Test that we don't get a kernel warning when we call KVM_RUN after a
> >>>> + * triple fault occurs.  To get the triple fault to occur we call KVM_RUN
> >>>> + * on a VCPU that hasn't been properly setup.
> >>>> + *
> >>>> + */
> >>>> +
> >>>> +#define _GNU_SOURCE
> >>>> +#include <fcntl.h>
> >>>> +#include <kvm_util.h>
> >>>> +#include <linux/kvm.h>
> >>>> +#include <processor.h>
> >>>> +#include <pthread.h>
> >>>> +#include <stdio.h>
> >>>> +#include <stdlib.h>
> >>>> +#include <string.h>
> >>>> +#include <sys/ioctl.h>
> >>>> +#include <sys/mman.h>
> >>>> +#include <sys/stat.h>
> >>>> +#include <sys/types.h>
> >>>> +#include <sys/wait.h>
> >>>> +#include <test_util.h>
> >>>> +#include <unistd.h>
> >>>> +
> >>>> +#define NTHREAD 4
> >>>> +#define NPROCESS 5
> >>>> +
> >>>> +struct thread_context {
> >>>> +       int kvmcpu;
> >>>> +       struct kvm_run *run;
> >>>> +};
> >>>> +
> >>>> +void *thr(void *arg)
> >>>> +{
> >>>> +       struct thread_context *tc = (struct thread_context *)arg;
> >>>> +       int res;
> >>>> +       int kvmcpu = tc->kvmcpu;
> >>>> +       struct kvm_run *run = tc->run;
> >>>> +
> >>>> +       res = ioctl(kvmcpu, KVM_RUN, 0);
> >>>> +       printf("ret1=%d exit_reason=%d suberror=%d\n",
> >>>> +               res, run->exit_reason, run->internal.suberror);
> >>>> +
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>> +void test(void)
> >>>> +{
> >>>> +       int i, kvm, kvmvm, kvmcpu;
> >>>> +       pthread_t th[NTHREAD];
> >>>> +       struct kvm_run *run;
> >>>> +       struct thread_context tc;
> >>>> +
> >>>> +       kvm = open("/dev/kvm", O_RDWR);
> >>>> +       TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
> >>>> +       kvmvm = ioctl(kvm, KVM_CREATE_VM, 0);
> >>>> +       TEST_ASSERT(kvmvm != -1, "KVM_CREATE_VM failed");
> >>>> +       kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
> >>>> +       TEST_ASSERT(kvmcpu != -1, "KVM_CREATE_VCPU failed");
> >>>> +       run = (struct kvm_run *)mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
> >>>> +                                   kvmcpu, 0);
> >>>> +       tc.kvmcpu = kvmcpu;
> >>>> +       tc.run = run;
> >>>> +       srand(getpid());
> >>>> +       for (i = 0; i < NTHREAD; i++) {
> >>>> +               pthread_create(&th[i], NULL, thr, (void *)(uintptr_t)&tc);
> >>>> +               usleep(rand() % 10000);
> >>>> +       }
> >>>> +       for (i = 0; i < NTHREAD; i++)
> >>>> +               pthread_join(th[i], NULL);
> >>>> +}
> >>>> +
> >>>> +int get_warnings_count(void)
> >>>> +{
> >>>> +       int warnings;
> >>>> +       FILE *f;
> >>>> +
> >>>> +       f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
> >>>> +       fscanf(f, "%d", &warnings);
> >>>> +       fclose(f);
> >>>> +
> >>>> +       return warnings;
> >>>> +}
> >>>> +
> >>>> +int main(void)
> >>>> +{
> >>>> +       int warnings_before, warnings_after;
> >>>> +
> >>>> +       if (!is_intel_cpu()) {
> >>>> +               printf("Must be run on an Intel CPU, skipping test\n");
> >>>> +               exit(KSFT_SKIP);
> >>>> +       }
> >>>> +
> >>>> +       if (vm_is_unrestricted_guest(NULL)) {
> >>>> +               printf("Unrestricted guest must be disabled, skipping test\n");
> >>>> +               exit(KSFT_SKIP);
> >>>> +       }
> >>>> +
> >>>> +       warnings_before = get_warnings_count();
> >>>> +
> >>>> +       for (int i = 0; i < NPROCESS; ++i) {
> >>>> +               int status;
> >>>> +               int pid = fork();
> >>>> +
> >>>> +               if (pid < 0)
> >>>> +                       exit(1);
> >>>> +               if (pid == 0) {
> >>>> +                       test();
> >>>> +                       exit(0);
> >>>> +               }
> >>>> +               while (waitpid(pid, &status, __WALL) != pid)
> >>>> +                       ;
> >>>> +       }
> >>>> +
> >>>> +       warnings_after = get_warnings_count();
> >> Since you are grep'ing for the word "WARNING",  is there a possibility
> >> that the test can detect a false positive based on Warnings generated
> >> due to some other cause while it ran ?
> >>
> > Yes, this is a possibility, however, it is still a warning and should
> > still be dealt with.  We could special case the grep message to be
> > more specific to the case we are dealing with here, but I'd prefer to
> > keep it this way to alert on any warning.  That way other warnings,
> > should they occur, are brought to our attention.
>
>
> OK.  In that case, does it make sense to provide some additional info in
> the ASSERT message below ? dmesg can contain Warnings that may have
> occurred either before or after the run of this test and so we can at
> least link the false positives to this test.
>

I can go either way on this.  While there can be false positives in
dmesg, if this asset fires there will be warnings worth looking at and
addressing as it only fires if it detects warnings occurred during the
test.  That's the reason I made the asset message general and only say
to look at warnings.  We could add a more long winded message to the
end of this informing the user that because the test doesn't clear
dmesg there could be warnings not related to the test.  However, there
will be warnings caused by running this test as well.

>
> >
> >>>> +       TEST_ASSERT(warnings_before == warnings_after,
> >>>> +                  "Warnings found in kernel.  Run 'dmesg' to inspect them.");
> >>>> +
> >>>> +       return 0;
> >>>> +}
> >>>> --
> >>>> 2.22.0.rc1.311.g5d7573a151-goog
> >>>>
> >>> ping
