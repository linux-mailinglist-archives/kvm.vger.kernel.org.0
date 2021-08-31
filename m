Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739B73FC82E
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 15:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbhHaN1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 09:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbhHaN1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 09:27:05 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851D1C061575
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 06:26:10 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id q39so24253013oiw.12
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 06:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w+OGVM7mlO+rbT4FsYj2MnmdM50qACz9pjvpcU7+PMY=;
        b=KbmAfbw/vdflbdPCVYj6tkOs3YSbhZrP+l0T3EpxWZ/wLsl4JhKpnWaPb/uduSHpBI
         x/N2tXtNpqMZH/EgyvVUKytKfTelcjEVKevakpywjiulvRjPpx4udIBFZliT11MPpziZ
         lrxHzCbakSPKwFw4V/cPHbb1euBzfjx/JGd16W9vzOzZj2ZZgbPphuUusd8VXBw4RQcm
         mbXZ65z/OMQ+U6QSJy1rtdeZDpOtBjvDTegl7xli6TyMtSS4sXDIvtZ4fEB6i5mzh5bd
         Z6ekv1QrkOSa+kQJ5dQO4zB6tgfMeA1+j6CvJhpec3W0vcVbc5qvcIA0vUhNon5oHktd
         urhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w+OGVM7mlO+rbT4FsYj2MnmdM50qACz9pjvpcU7+PMY=;
        b=IKLwPZ4DvUKCizlufG2M5bNhpautivJMI8g++elCnnxbCp/jovYthTb9s0fr83HrjD
         zqbt4JHE+4FA/kIXqp4ajI0M9yHsk1UFWcPQ7vbOq4jcqWjYzFBa3pZAi5hmTaRBHqA8
         xO9GeL+3ZHQOpSVO8C33NlQbJg2EnAZV8sdSX/pxiRWTfzldkHdbKw5JroUtPqKppQ6C
         +MpjLSonmi5mDfGf8WRrEBSivm7hoJdKi4iZ0MH2WPm0eQfUQEecvsDmzRIDz3jdHzIq
         T1ETpODaco8fFH59HZY1U/lQ7/KHj0F46QLjb95EGf0my3EChVqr5Vl0qxkMYBKGIzqD
         zpLw==
X-Gm-Message-State: AOAM533QpMdJYXO+UZN+vmWfzs77RiqWIb4XkQ64Hy+j353EjHN9pYzm
        tAyT7K7jwynPYE2Z0jOeeI1vjOpdUy47ndKf2C4NVg==
X-Google-Smtp-Source: ABdhPJwi4Gy5jptuKvQY3nJdJnbPO9GEVAw3SKF8q1ChR09PXNJkFEisB7zDtwSFv1GYybWiq/TUkN47zTuTkKNJHP8=
X-Received: by 2002:a05:6808:21a5:: with SMTP id be37mr3131695oib.172.1630416369618;
 Tue, 31 Aug 2021 06:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210830212951.3541589-1-pgonda@google.com> <CAA03e5Fd2aes=euzXv51d6b3E0S3tK45hkqQhONsmWA5dE33dw@mail.gmail.com>
In-Reply-To: <CAA03e5Fd2aes=euzXv51d6b3E0S3tK45hkqQhONsmWA5dE33dw@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 31 Aug 2021 06:25:58 -0700
Message-ID: <CAA03e5G9TEsmzbQw_m_Zh+Evdief0hgiuMmBGF40xctMAwjY2w@mail.gmail.com>
Subject: Re: [PATCH 3/3 V6] selftest: KVM: Add intra host migration
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021 at 6:24 AM Marc Orr <marcorr@google.com> wrote:
>
> On Mon, Aug 30, 2021 at 2:29 PM Peter Gonda <pgonda@google.com> wrote:
> >
> > Adds testcases for intra host migration for SEV and SEV-ES. Also adds
> > locking test to confirm no deadlock exists.
> >
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/x86_64/sev_vm_tests.c       | 152 ++++++++++++++++++
> >  2 files changed, 153 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> >
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 5832f510a16c..de6e64d5c9c4 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -71,6 +71,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/sev_vm_tests
> >  TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
> >  TEST_GEN_PROGS_x86_64 += demand_paging_test
> >  TEST_GEN_PROGS_x86_64 += dirty_log_test
> > diff --git a/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> > new file mode 100644
> > index 000000000000..50a770316628
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> > @@ -0,0 +1,150 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <linux/kvm.h>
> > +#include <linux/psp-sev.h>
> > +#include <stdio.h>
> > +#include <sys/ioctl.h>
> > +#include <stdlib.h>
> > +#include <errno.h>
> > +#include <pthread.h>
> > +
> > +#include "test_util.h"
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "svm_util.h"
> > +#include "kvm_util.h"
> > +#include "kselftest.h"
> > +#include "../lib/kvm_util_internal.h"
> > +
> > +#define SEV_DEV_PATH "/dev/sev"
> > +
> > +/*
> > + * Open SEV_DEV_PATH if available, otherwise exit the entire program.
> > + *
> > + * Input Args:
> > + *   flags - The flags to pass when opening SEV_DEV_PATH.
> > + *
> > + * Return:
> > + *   The opened file descriptor of /dev/sev.
> > + */
> > +static int open_sev_dev_path_or_exit(int flags)
> > +{
> > +       static int fd;
> > +
> > +       if (fd != 0)
> > +               return fd;
> > +
> > +       fd = open(SEV_DEV_PATH, flags);
> > +       if (fd < 0) {
> > +               print_skip("%s not available, is SEV not enabled? (errno: %d)",
> > +                          SEV_DEV_PATH, errno);
> > +               exit(KSFT_SKIP);
> > +       }
> > +
> > +       return fd;
> > +}
> > +
> > +static void sev_ioctl(int fd, int cmd_id, void *data)
> > +{
> > +       struct kvm_sev_cmd cmd = { 0 };
> > +       int ret;
> > +
> > +       TEST_ASSERT(cmd_id < KVM_SEV_NR_MAX, "Unknown SEV CMD : %d\n", cmd_id);
> > +
> > +       cmd.id = cmd_id;
> > +       cmd.sev_fd = open_sev_dev_path_or_exit(0);
> > +       cmd.data = (uint64_t)data;
> > +       ret = ioctl(fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> > +       TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> > +                   "%d failed: return code: %d, errno: %d, fw error: %d",
> > +                   cmd_id, ret, errno, cmd.error);
> > +}
>
> nit: Since this function has two file descriptors, `fd` and
> `cmd.sev_fd`, can we rename `fd` to `vm_fd`?
>
> > +
> > +static struct kvm_vm *sev_vm_create(bool es)
> > +{
> > +       struct kvm_vm *vm;
> > +       struct kvm_sev_launch_start start = { 0 };
> > +       int i;
> > +
> > +       vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> > +       sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
> > +       for (i = 0; i < 3; ++i)
>
> nit: Consider moving `3` to a macro, like `MAX_VCPU_IDX` or maybe
> better defining something like `NUM_VCPUS` to be 4.
>
> > +               vm_vcpu_add(vm, i);
> > +       start.policy |= (es) << 2;
> > +       sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
> > +       if (es)
> > +               sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
> > +       return vm;
> > +}
> > +
> > +static void test_sev_migrate_from(bool es)
> > +{
> > +       struct kvm_vm *vms[3];
>
> If we create a `NUM_VCPUS` macro, then we can use it here.
>
> > +       struct kvm_enable_cap cap = { 0 };
> > +       int i;
> > +
> > +       for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *); ++i)
> > +               vms[i] = sev_vm_create(es);
> > +
> > +       cap.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM;
> > +       for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *) - 1; ++i) {
> > +               cap.args[0] = vms[i]->fd;
> > +               vm_enable_cap(vms[i + 1], &cap);
> > +       }
>
> nit/optional: To me, the code would be more clear if we combined this
> loop with the one above and guarded calling `vm_enable_cap()` with `if
> (i > 0)`. Also, maybe we can initialize `cap` when it's declared.
>
>      struct kvm_enable_cap cap = { .cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM };
>      int i;
>
>      for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *); ++i) {
>           vms[i] = sev_vm_create(es);
>           if (i > 0)
>                vm_enable_cap(vms[i], &cap);
>      }
>
> > +}
> > +
> > +#define LOCK_TESTING_THREADS 3
>
> nit: Consider moving this macro to the top of the file.
>
> > +
> > +struct locking_thread_input {
> > +       struct kvm_vm *vm;
> > +       int source_fds[LOCK_TESTING_THREADS];
> > +};
> > +
> > +static void *locking_test_thread(void *arg)
> > +{
> > +       struct kvm_enable_cap cap = { 0 };
>
> Maybe:
> struct kvm_enable_cap cap = { .cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM };
>
> > +       int i, j;
> > +       struct locking_thread_input *input = (struct locking_test_thread *)arg;
> > +
> > +       cap.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM;
>
> If we initialize the cap field during the declaration, then this line goes away.
>
> > +
> > +       for (i = 0; i < 1000; ++i) {
> > +               j = input->source_fds[i % LOCK_TESTING_THREADS];
> > +               cap.args[0] = input->source_fds[j];
> > +               /*
> > +                * Call IOCTL directly without checking return code. We are
> > +                * simply trying to confirm there is no deadlock from userspace
> > +                * not check correctness of migration here.
> > +                */
> > +               ioctl(input->vm->fd, KVM_ENABLE_CAP, &cap);
>
> Should we use `vm_enable_cap()` here?
>
> > +       }
> > +}
> > +
> > +static void test_sev_migrate_locking(void)
> > +{
> > +       struct locking_thread_input input[LOCK_TESTING_THREADS];
> > +       pthread_t pt[LOCK_TESTING_THREADS];
> > +       int i;
> > +
> > +       for (i = 0; i < LOCK_TESTING_THREADS; ++i) {
> > +               input[i].vm = sev_vm_create(/* es= */ false);
> > +               input[0].source_fds[i] = input[i].vm->fd;
> > +       }
> > +       memcpy(input[1].source_fds, input[0].source_fds,
> > +              sizeof(input[1].source_fds));
> > +       memcpy(input[2].source_fds, input[0].source_fds,
> > +              sizeof(input[2].source_fds));
> > +
> > +       for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> > +               pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
> > +
> > +       for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> > +               pthread_join(pt[i], NULL);
> > +}
>
> I think this function/test case deserves a comment to capture some of
> the conversation we had on the list that led to Sean suggesting this
> test case. Speaking of which, should this test case have a
> Suggested-by tag for Sean, since he suggested this test?

Gah. I forgot to check the tags before sending my feedback. Of course,
the suggested-by tag is already there. Second time I made this gaffe
in the last couple of weeks. Sorry for the noise.

>
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +       test_sev_migrate_from(/* es= */ false);
> > +       test_sev_migrate_from(/* es= */ true);
> > +       test_sev_migrate_locking();
> > +       return 0;
> > +}
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> Nice test!
