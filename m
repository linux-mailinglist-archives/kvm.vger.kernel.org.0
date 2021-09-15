Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9840CBB2
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhIOR3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 13:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhIOR3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 13:29:20 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D705C061575
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 10:28:01 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id bi4so5129335oib.9
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 10:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8zUWKPUgTZABevow7z0k9jmN0O/6BSh3As22IG3b64=;
        b=HAQH5/gGAxa+81crhk6Hx+MOwpYF5prlm2W2nAqX3OrwZ7nZHGBLGgcgBrlJf6ETj2
         6+O5wNpcOeHihQDP1EVLq2UiXVqrVSdcd24zqkTsVd8ARmlBtWlzVdAOKWfAPQQVS37z
         LM2Rp8oxN6EYiLS2lmYRdwLu4BKEsTdwhTBg7vm34JZY98QdljfTChACENIlLDTlU0Lt
         n1O8dgRZSvQ/ziR7P9Bygq6ivU2cSuV6MNOLjS2r/GdQVYQNG2zCtdHhmHcS56jYVsiv
         CDijH1owZ+IWe8ptp8hs+c5xlDPeHOfp+qLUkteSU5yEh19EJpPqdA3a7G3AvziBGdeT
         h1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8zUWKPUgTZABevow7z0k9jmN0O/6BSh3As22IG3b64=;
        b=faCQHJYJQViIoldaQTd5p2L5m8uxBIB1x8U1qQH5CYIcDcnSStCNinFj/cqojIfKMj
         eRaoP8u3b3R/jMvx53JA7f72ZJZxN8LgjLcdhpkdyuAbHXKNFmSsiyU9gljhN1GMgGaG
         xKvxbSFNLDwdPjA3mWepqGqpfSQapkDE80yfyHPIsI0li2RlMfAkvNOIy9YLMi6hVtBQ
         ixBcWVSjUk1tO9m8fXDzfrNcBzYa9wfQUIUXLpAVTlZCpbOxOeTXGD4vfhku4XqCmQCO
         4kKxrz5m+Q2nHKy6UBfggzQ/OCJIHaR6Gb4b42VPvQZNrMCIU1e912EWnEK0yhNg1bRT
         JPJA==
X-Gm-Message-State: AOAM531s7s2BFTNtkGRT17adTM/K0himJ94HKATWWtw/7IumE+o/F4Mi
        n/WhapMPi1RNMZ+EHiqDTqSEVYjC2UDY4EYAmIHEgA==
X-Google-Smtp-Source: ABdhPJxkqNKf3VSBi4jAjYYBibMyvn7Hvgz/QsNT/Bw7Vz+1LNhJJixcOgb7IJDS676erMJt/FhFAwZbE1XGz9XrCZg=
X-Received: by 2002:a05:6808:21a5:: with SMTP id be37mr606899oib.172.1631726880229;
 Wed, 15 Sep 2021 10:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210914164727.3007031-1-pgonda@google.com> <20210914164727.3007031-5-pgonda@google.com>
In-Reply-To: <20210914164727.3007031-5-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 15 Sep 2021 10:27:49 -0700
Message-ID: <CAA03e5EtxED=9C8tL8hwstHBMbj6nzDwA87yMfK9kk5BUTqF2w@mail.gmail.com>
Subject: Re: [PATCH 4/4 V8] selftest: KVM: Add intra host migration tests
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 9:47 AM Peter Gonda <pgonda@google.com> wrote:
>
> Adds testcases for intra host migration for SEV and SEV-ES. Also adds
> locking test to confirm no deadlock exists.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/sev_vm_tests.c       | 203 ++++++++++++++++++
>  2 files changed, 204 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c103873531e0..44fd3566fb51 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -72,6 +72,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
> +TEST_GEN_PROGS_x86_64 += x86_64/sev_vm_tests
>  TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86_64 += demand_paging_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> new file mode 100644
> index 000000000000..ec3bbc96e73a
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
> @@ -0,0 +1,203 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/kvm.h>
> +#include <linux/psp-sev.h>
> +#include <stdio.h>
> +#include <sys/ioctl.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <pthread.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +#include "kselftest.h"
> +#include "../lib/kvm_util_internal.h"
> +
> +#define SEV_POLICY_ES 0b100
> +
> +#define NR_MIGRATE_TEST_VCPUS 4
> +#define NR_MIGRATE_TEST_VMS 3
> +#define NR_LOCK_TESTING_THREADS 3
> +#define NR_LOCK_TESTING_ITERATIONS 10000
> +
> +static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> +{
> +       struct kvm_sev_cmd cmd = {
> +               .id = cmd_id,
> +               .data = (uint64_t)data,
> +               .sev_fd = open_sev_dev_path_or_exit(),
> +       };
> +       int ret;
> +
> +       ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> +       TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> +                   "%d failed: return code: %d, errno: %d, fw error: %d",
> +                   cmd_id, ret, errno, cmd.error);
> +}
> +
> +static struct kvm_vm *sev_vm_create(bool es)
> +{
> +       struct kvm_vm *vm;
> +       struct kvm_sev_launch_start start = { 0 };
> +       int i;
> +
> +       vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +       sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
> +       for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
> +               vm_vcpu_add(vm, i);
> +       if (es)
> +               start.policy |= SEV_POLICY_ES;
> +       sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
> +       if (es)
> +               sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
> +       return vm;
> +}

I should've suggested this in my original review. But is it worth
moving `sev_vm_create()` and `sev_ioctl()` into the broader selftests
library, so others can leverage this function to write selftests?

> +
> +static struct kvm_vm *__vm_create(void)
> +{
> +       struct kvm_vm *vm;
> +       int i;
> +
> +       vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +       for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
> +               vm_vcpu_add(vm, i);
> +
> +       return vm;
> +}
> +
> +static int __sev_migrate_from(int dst_fd, int src_fd)
> +{
> +       struct kvm_enable_cap cap = {
> +               .cap = KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM,
> +               .args = { src_fd }
> +       };
> +
> +       return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
> +}
> +
> +
> +static void sev_migrate_from(int dst_fd, int src_fd)
> +{
> +       int ret;
> +
> +       ret = __sev_migrate_from(dst_fd, src_fd);
> +       TEST_ASSERT(!ret, "Migration failed, ret: %d, errno: %d\n", ret, errno);
> +}
> +
> +static void test_sev_migrate_from(bool es)
> +{
> +       struct kvm_vm *src_vm;
> +       struct kvm_vm *dst_vms[NR_MIGRATE_TEST_VMS];
> +       int i;
> +
> +       src_vm = sev_vm_create(es);
> +       for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
> +               dst_vms[i] = __vm_create();
> +
> +       /* Initial migration from the src to the first dst. */
> +       sev_migrate_from(dst_vms[0]->fd, src_vm->fd);
> +
> +       for (i = 1; i < NR_MIGRATE_TEST_VMS; i++)
> +               sev_migrate_from(dst_vms[i]->fd, dst_vms[i - 1]->fd);
> +
> +       /* Migrate the guest back to the original VM. */
> +       sev_migrate_from(src_vm->fd, dst_vms[NR_MIGRATE_TEST_VMS - 1]->fd);
> +
> +       kvm_vm_free(src_vm);
> +       for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
> +               kvm_vm_free(dst_vms[i]);
> +}
> +
> +struct locking_thread_input {
> +       struct kvm_vm *vm;
> +       int source_fds[NR_LOCK_TESTING_THREADS];
> +};
> +
> +static void *locking_test_thread(void *arg)
> +{
> +       int i, j;
> +       struct locking_thread_input *input = (struct locking_test_thread *)arg;
> +
> +       for (i = 0; i < NR_LOCK_TESTING_ITERATIONS; ++i) {
> +               j = i % NR_LOCK_TESTING_THREADS;
> +               __sev_migrate_from(input->vm->fd, input->source_fds[j]);
> +       }
> +
> +       return NULL;
> +}
> +
> +static void test_sev_migrate_locking(void)
> +{
> +       struct locking_thread_input input[NR_LOCK_TESTING_THREADS];
> +       pthread_t pt[NR_LOCK_TESTING_THREADS];
> +       int i;
> +
> +       for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i) {
> +               input[i].vm = sev_vm_create(/* es= */ false);
> +               input[0].source_fds[i] = input[i].vm->fd;
> +       }
> +       for (i = 1; i < NR_LOCK_TESTING_THREADS; ++i)
> +               memcpy(input[i].source_fds, input[0].source_fds,
> +                      sizeof(input[i].source_fds));
> +
> +       for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
> +               pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
> +
> +       for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
> +               pthread_join(pt[i], NULL);
> +}
> +
> +static void test_sev_migrate_parameters(void)
> +{
> +       struct kvm_vm *sev_vm, *sev_es_vm, *vm_no_vcpu, *vm_no_sev,
> +               *sev_es_vm_no_vmsa;
> +       int ret;
> +
> +       sev_vm = sev_vm_create(/* es= */ false);
> +       sev_es_vm = sev_vm_create(/* es= */ true);
> +       vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +       vm_no_sev = __vm_create();
> +       sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +       sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
> +       vm_vcpu_add(sev_es_vm_no_vmsa, 1);
> +
> +
> +       ret = __sev_migrate_from(sev_vm->fd, sev_es_vm->fd);
> +       TEST_ASSERT(
> +               ret == -1 && errno == EINVAL,
> +               "Should not be able migrate to SEV enabled VM. ret: %d, errno: %d\n",
> +               ret, errno);
> +
> +       ret = __sev_migrate_from(sev_es_vm->fd, sev_vm->fd);
> +       TEST_ASSERT(
> +               ret == -1 && errno == EINVAL,
> +               "Should not be able migrate to SEV-ES enabled VM. ret: %d, errno: %d\n",
> +               ret, errno);
> +
> +       ret = __sev_migrate_from(vm_no_vcpu->fd, sev_es_vm->fd);
> +       TEST_ASSERT(
> +               ret == -1 && errno == EINVAL,
> +               "SEV-ES migrations require same number of vCPUS. ret: %d, errno: %d\n",
> +               ret, errno);

How do we know that this failed because `vm_no_vcpu` has no vCPUs or
because it's not a SEV-ES VM?

> +
> +       ret = __sev_migrate_from(vm_no_vcpu->fd, sev_es_vm_no_vmsa->fd);
> +       TEST_ASSERT(
> +               ret == -1 && errno == EINVAL,
> +               "SEV-ES migrations require UPDATE_VMSA. ret %d, errno: %d\n",
> +               ret, errno);

Same question. How do we know why this failed? `sev_es_vm_no_vmsa` did
not have any vCPUs added. Would it be cleaner to add an additional
param to `sev_vm_create()` to skip calling UPDATE_VMSA? Then,
`sev_es_vm_no_vmsa` can be created from `sev_vm_create()` and it's
obvious to the read that the VMs are identical except for this aspect.

> +
> +       ret = __sev_migrate_from(vm_no_vcpu->fd, vm_no_sev->fd);
> +       TEST_ASSERT(ret == -1 && errno == EINVAL,
> +                   "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
> +                   errno);

`vm_no_sev` has vCPUs. Therefore, how do we know why this failed --
(a) differing vCPU counts or (b) no SEV?

> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       test_sev_migrate_from(/* es= */ false);
> +       test_sev_migrate_from(/* es= */ true);
> +       test_sev_migrate_locking();
> +       test_sev_migrate_parameters();
> +       return 0;
> +}
> --
> 2.33.0.309.g3052b89438-goog
>
