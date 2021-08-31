Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3A3FCA7C
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 17:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhHaPE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 11:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhHaPE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 11:04:56 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2FEC061760
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 08:04:01 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id j12so32324917ljg.10
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 08:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Fn4UZmVWhb7Bzvp1FoQQ7qfnZgNzUwT5A3uCCmGDj0=;
        b=cdfjp6SVsuxqd4fltHdv9vJ1ZOrV00nXaLXFRWNyrWwlDEpcVCsVSzniXR+eEBRSAI
         8xN0+xrgRv/xoPOhyhee4AiLqAjeQdvE6wBT3AM+GaO/FDPI/Z8ibTlR4oj/gi+EKhfH
         WheZuSGPwB9l2Zfj9sosh1GhJfSZRX6Fe2T5pyo8QT9+L0kZAuSPTacOMAzk97pzAvQf
         PHFDYeiLmvDGRUFsSayJ2jg5J7VTpNIwGLOJdIXvRYj/Rqr3bZ7bpDGyCcKnQRfEN+lA
         eyRxBew4PNzkdzOpuh9Dxqv4y+itg5Pj3L8j8Tl2ea8PnK9ASRdGreKC25SEWsDj8Wjk
         Dy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Fn4UZmVWhb7Bzvp1FoQQ7qfnZgNzUwT5A3uCCmGDj0=;
        b=hcL2eBEUNqifqDarvJlnjd5WAutwT4wDMeK8JjtdbNHzGxhMuTJsTSMPSWPPfz2ijy
         Ra5Sazdr/kpT3Ii8s0nT69NQfhM0A3R/8BEvkEKuAFHqA3VuvzfzpVIX30Swy3IWU8VB
         +iKDdtt07vQDqFwlyRz5OQwnZ9+87mgUWgxEvP27E+IGFso//XpZJmcbZGCWgr5kByaE
         Yg+qPvIdy38jppMhrarijtQU2VuuTUEMAm9Vsee97Q4bCfgYsOtgh9hJt2OVJNvw2nTo
         5tnpv7k6SkenzBDvZVX0QZ03TcG82Tz23FzlQK+S18GGuS/XJ43piFpXtH/uU8g1LfC5
         tD0g==
X-Gm-Message-State: AOAM532PLIZJH/oJ+WlMw3YuoOA0kU5+/8xBlD3OKTng9sUw+NZJiENd
        lQqhubnX3zKWo8UMIbIaMIcjkt9jaz0jdACfpXSptw==
X-Google-Smtp-Source: ABdhPJz7R8yS4tFq5OIt5U9b9AwBlSVoxf+LlWKsuk9kKOCQLPYDxpxb4go5g5kLf6mFhZ12nLnYq9g/o1AU0vuqcm0=
X-Received: by 2002:a2e:a7d0:: with SMTP id x16mr25654175ljp.494.1630422239046;
 Tue, 31 Aug 2021 08:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210830212951.3541589-1-pgonda@google.com> <CAA03e5Fd2aes=euzXv51d6b3E0S3tK45hkqQhONsmWA5dE33dw@mail.gmail.com>
 <CAA03e5G9TEsmzbQw_m_Zh+Evdief0hgiuMmBGF40xctMAwjY2w@mail.gmail.com>
In-Reply-To: <CAA03e5G9TEsmzbQw_m_Zh+Evdief0hgiuMmBGF40xctMAwjY2w@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 31 Aug 2021 09:03:47 -0600
Message-ID: <CAMkAt6r8X5XbhRSbfX5vfHn+F40Mp_Ou+qmtUqeDBCtTF1oTxg@mail.gmail.com>
Subject: Re: [PATCH 3/3 V6] selftest: KVM: Add intra host migration
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021 at 7:26 AM Marc Orr <marcorr@google.com> wrote:
>
> On Tue, Aug 31, 2021 at 6:24 AM Marc Orr <marcorr@google.com> wrote:
> >
> > On Mon, Aug 30, 2021 at 2:29 PM Peter Gonda <pgonda@google.com> wrote:
> > >
> > > Adds testcases for intra host migration for SEV and SEV-ES. Also adds
> > > locking test to confirm no deadlock exists.
> > >
> > > ---
> > >  tools/testing/selftests/kvm/Makefile          |   1 +
> > >  .../selftests/kvm/x86_64/sev_vm_tests.c       | 152 ++++++++++++++++++
> > >  2 files changed, 153 insertions(+)
> > >  create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> > >
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Cc: Marc Orr <marcorr@google.com>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > >
> > > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > > index 5832f510a16c..de6e64d5c9c4 100644
> > > --- a/tools/testing/selftests/kvm/Makefile
> > > +++ b/tools/testing/selftests/kvm/Makefile
> > > @@ -71,6 +71,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
> > >  TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
> > >  TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
> > >  TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
> > > +TEST_GEN_PROGS_x86_64 += x86_64/sev_vm_tests
> > >  TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
> > >  TEST_GEN_PROGS_x86_64 += demand_paging_test
> > >  TEST_GEN_PROGS_x86_64 += dirty_log_test
> > > diff --git a/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> > > new file mode 100644
> > > index 000000000000..50a770316628
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> > > @@ -0,0 +1,150 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +#include <linux/kvm.h>
> > > +#include <linux/psp-sev.h>
> > > +#include <stdio.h>
> > > +#include <sys/ioctl.h>
> > > +#include <stdlib.h>
> > > +#include <errno.h>
> > > +#include <pthread.h>
> > > +
> > > +#include "test_util.h"
> > > +#include "kvm_util.h"
> > > +#include "processor.h"
> > > +#include "svm_util.h"
> > > +#include "kvm_util.h"
> > > +#include "kselftest.h"
> > > +#include "../lib/kvm_util_internal.h"
> > > +
> > > +#define SEV_DEV_PATH "/dev/sev"
> > > +
> > > +/*
> > > + * Open SEV_DEV_PATH if available, otherwise exit the entire program.
> > > + *
> > > + * Input Args:
> > > + *   flags - The flags to pass when opening SEV_DEV_PATH.
> > > + *
> > > + * Return:
> > > + *   The opened file descriptor of /dev/sev.
> > > + */
> > > +static int open_sev_dev_path_or_exit(int flags)
> > > +{
> > > +       static int fd;
> > > +
> > > +       if (fd != 0)
> > > +               return fd;
> > > +
> > > +       fd = open(SEV_DEV_PATH, flags);
> > > +       if (fd < 0) {
> > > +               print_skip("%s not available, is SEV not enabled? (errno: %d)",
> > > +                          SEV_DEV_PATH, errno);
> > > +               exit(KSFT_SKIP);
> > > +       }
> > > +
> > > +       return fd;
> > > +}
> > > +
> > > +static void sev_ioctl(int fd, int cmd_id, void *data)
> > > +{
> > > +       struct kvm_sev_cmd cmd = { 0 };
> > > +       int ret;
> > > +
> > > +       TEST_ASSERT(cmd_id < KVM_SEV_NR_MAX, "Unknown SEV CMD : %d\n", cmd_id);
> > > +
> > > +       cmd.id = cmd_id;
> > > +       cmd.sev_fd = open_sev_dev_path_or_exit(0);
> > > +       cmd.data = (uint64_t)data;
> > > +       ret = ioctl(fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> > > +       TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> > > +                   "%d failed: return code: %d, errno: %d, fw error: %d",
> > > +                   cmd_id, ret, errno, cmd.error);
> > > +}
> >
> > nit: Since this function has two file descriptors, `fd` and
> > `cmd.sev_fd`, can we rename `fd` to `vm_fd`?
> >
> > > +
> > > +static struct kvm_vm *sev_vm_create(bool es)
> > > +{
> > > +       struct kvm_vm *vm;
> > > +       struct kvm_sev_launch_start start = { 0 };
> > > +       int i;
> > > +
> > > +       vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> > > +       sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
> > > +       for (i = 0; i < 3; ++i)
> >
> > nit: Consider moving `3` to a macro, like `MAX_VCPU_IDX` or maybe
> > better defining something like `NUM_VCPUS` to be 4.
> >
> > > +               vm_vcpu_add(vm, i);
> > > +       start.policy |= (es) << 2;
> > > +       sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
> > > +       if (es)
> > > +               sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
> > > +       return vm;
> > > +}
> > > +
> > > +static void test_sev_migrate_from(bool es)
> > > +{
> > > +       struct kvm_vm *vms[3];
> >
> > If we create a `NUM_VCPUS` macro, then we can use it here.
> >
> > > +       struct kvm_enable_cap cap = { 0 };
> > > +       int i;
> > > +
> > > +       for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *); ++i)
> > > +               vms[i] = sev_vm_create(es);
> > > +
> > > +       cap.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM;
> > > +       for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *) - 1; ++i) {
> > > +               cap.args[0] = vms[i]->fd;
> > > +               vm_enable_cap(vms[i + 1], &cap);
> > > +       }
> >
> > nit/optional: To me, the code would be more clear if we combined this
> > loop with the one above and guarded calling `vm_enable_cap()` with `if
> > (i > 0)`. Also, maybe we can initialize `cap` when it's declared.
> >
> >      struct kvm_enable_cap cap = { .cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM };
> >      int i;
> >
> >      for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *); ++i) {
> >           vms[i] = sev_vm_create(es);
> >           if (i > 0)
> >                vm_enable_cap(vms[i], &cap);
> >      }
> >
> > > +}
> > > +
> > > +#define LOCK_TESTING_THREADS 3
> >
> > nit: Consider moving this macro to the top of the file.
> >
> > > +
> > > +struct locking_thread_input {
> > > +       struct kvm_vm *vm;
> > > +       int source_fds[LOCK_TESTING_THREADS];
> > > +};
> > > +
> > > +static void *locking_test_thread(void *arg)
> > > +{
> > > +       struct kvm_enable_cap cap = { 0 };
> >
> > Maybe:
> > struct kvm_enable_cap cap = { .cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM };
> >
> > > +       int i, j;
> > > +       struct locking_thread_input *input = (struct locking_test_thread *)arg;
> > > +
> > > +       cap.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM;
> >
> > If we initialize the cap field during the declaration, then this line goes away.
> >
> > > +
> > > +       for (i = 0; i < 1000; ++i) {
> > > +               j = input->source_fds[i % LOCK_TESTING_THREADS];
> > > +               cap.args[0] = input->source_fds[j];
> > > +               /*
> > > +                * Call IOCTL directly without checking return code. We are
> > > +                * simply trying to confirm there is no deadlock from userspace
> > > +                * not check correctness of migration here.
> > > +                */
> > > +               ioctl(input->vm->fd, KVM_ENABLE_CAP, &cap);
> >
> > Should we use `vm_enable_cap()` here?
> >

I took all other suggestions but this one I just updated the comment.
vm_enable_cap TEST_ASSERT()s if the ioctl fails. Since we are just
randomly iterating through a bunch of ioclts we fail often so this
would kill the test.

> > > +       }
> > > +}
> > > +
> > > +static void test_sev_migrate_locking(void)
> > > +{
> > > +       struct locking_thread_input input[LOCK_TESTING_THREADS];
> > > +       pthread_t pt[LOCK_TESTING_THREADS];
> > > +       int i;
> > > +
> > > +       for (i = 0; i < LOCK_TESTING_THREADS; ++i) {
> > > +               input[i].vm = sev_vm_create(/* es= */ false);
> > > +               input[0].source_fds[i] = input[i].vm->fd;
> > > +       }
> > > +       memcpy(input[1].source_fds, input[0].source_fds,
> > > +              sizeof(input[1].source_fds));
> > > +       memcpy(input[2].source_fds, input[0].source_fds,
> > > +              sizeof(input[2].source_fds));
> > > +
> > > +       for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> > > +               pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
> > > +
> > > +       for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> > > +               pthread_join(pt[i], NULL);
> > > +}
> >
> > I think this function/test case deserves a comment to capture some of
> > the conversation we had on the list that led to Sean suggesting this
> > test case. Speaking of which, should this test case have a
> > Suggested-by tag for Sean, since he suggested this test?
>
> Gah. I forgot to check the tags before sending my feedback. Of course,
> the suggested-by tag is already there. Second time I made this gaffe
> in the last couple of weeks. Sorry for the noise.
>
> >
> > > +
> > > +int main(int argc, char *argv[])
> > > +{
> > > +       test_sev_migrate_from(/* es= */ false);
> > > +       test_sev_migrate_from(/* es= */ true);
> > > +       test_sev_migrate_locking();
> > > +       return 0;
> > > +}
> > > --
> > > 2.33.0.259.gc128427fd7-goog
> > >
> >
> > Nice test!
