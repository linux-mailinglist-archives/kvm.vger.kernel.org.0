Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F596407342
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 00:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhIJWPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 18:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbhIJWPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 18:15:43 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B72AC061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:14:31 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n2so7023780lfk.0
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TA6suC0Bve+igd/7LKYeC0ZIyexn7MlL+eU3pyKRHoI=;
        b=bYZoX19xoaM5s7DcJBrMQFUgxfbCPxVbpJXouHY7eGkfkYHaXSHmOam3/yOxf8Di3z
         isWJWgBMNObSH87mJFjKHazi7UoX9fB/0wz/RNz18giS9XnnNKKNQlaHYZsFENmSaCiO
         uv/fRzutb1OapEDZ72m2siua19bXYtagwkyzMzR0a03y7dbcbkfITPExc0wU4M7X9mKl
         N103bEmYF9XpJZP6W6b1oOP8/+jEVfAy2A0aPtldn9kO3IQnugzv5t8tU+QebUblVAIY
         N6UGJhk8FsXOAsgAfCpBFrt/YjBYjMgRuYeJeW9sXaiUpVMqlRzrq/VrQuDrrSQZ8dXo
         a/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TA6suC0Bve+igd/7LKYeC0ZIyexn7MlL+eU3pyKRHoI=;
        b=Pp273Ner2Ydu6ij9luiNY/bORNEuDsvwJjdUrzbEVlOkpwbtDnWBCdxh3NbyJkuS7W
         0xr9X4Rc8y/y8yIn8Fx1cmLZokLyAqoIy+sRnGg0Mv0rHXDmYRUVuW/5biWJ2oE6vBxN
         dK6qZ0mHdjSl/D4xOnEM54zm7SRGfNeMzdxmzOrkQxBLxP1MNxskZZvcQDrajgeyAml+
         /EWtvpf7oYfj/53joiZnRoWq6GQ9SWTkt35Mpja1sf7sUHkbe+IsOml62YVsuAiMA5El
         232sa/X2t2MQClyebXBVAPWRep3rckhIZKZy3YDf/U7zeDwsL5OpxmQY0j/LCetXd04e
         QV+Q==
X-Gm-Message-State: AOAM5336kZuA5jIiqJjNpigH/YuIPMSakVKK8zRvAp/X0VZ2RRDCG6Hh
        rNYXsDP4mMA8POGYdzL2i/gSdMcj5h/5YPKe7z6sXw==
X-Google-Smtp-Source: ABdhPJxvfovj3ZwasyBWO+STHHSS9r49tm28A55PXd3hIkMnx3ED8JWjaI0m2XZEBdZbk6+gnDMBTnyFeEDmpJBozsw=
X-Received: by 2002:a19:c313:: with SMTP id t19mr5368510lff.644.1631312069409;
 Fri, 10 Sep 2021 15:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210902181751.252227-1-pgonda@google.com> <20210902181751.252227-4-pgonda@google.com>
 <YTuS3iHN7GgK4oQr@google.com>
In-Reply-To: <YTuS3iHN7GgK4oQr@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 10 Sep 2021 16:14:17 -0600
Message-ID: <CAMkAt6rDYdKOQniszX=zq6F92TDCfKQC+0PGFabAXtYWgCmC1A@mail.gmail.com>
Subject: Re: [PATCH 3/3 V7] selftest: KVM: Add intra host migration tests
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021 at 11:16 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 02, 2021, Peter Gonda wrote:
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
> > +     static int fd;
> > +
> > +     if (fd != 0)
> > +             return fd;
>
> Caching the file here is unnecessary, it's used in exactly one function.
>
> > +     fd = open(SEV_DEV_PATH, flags);
> > +     if (fd < 0) {
> > +             print_skip("%s not available, is SEV not enabled? (errno: %d)",
> > +                        SEV_DEV_PATH, errno);
> > +             exit(KSFT_SKIP);
> > +     }
> > +
> > +     return fd;
> > +}
>
> Rather than copy-paste _open_kvm_dev_path_or_exit(), it's probably worth factoring
> out a helper in a separate patch, e.g.

So the suggestion would be to move open_sev_dev_path_or_exit into
tools/testing/selftests/kvm/include/x86_64/svm_util.h

If so, wouldn't it make sense to keep the caching of the FD?

>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..06a6c04010fb 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -31,6 +31,19 @@ static void *align(void *x, size_t size)
>         return (void *) (((size_t) x + mask) & ~mask);
>  }
>
> +int open_path_or_exit(const char *path, int flags)
> +{
> +       int fd;
> +
> +       fd = open(path, flags);
> +       if (fd < 0) {
> +               print_skip("%s not available (errno: %d)", path, errno);
> +               exit(KSFT_SKIP);
> +       }
> +
> +       return fd;
> +}
> +
>  /*
>   * Open KVM_DEV_PATH if available, otherwise exit the entire program.
>   *
> @@ -42,16 +55,7 @@ static void *align(void *x, size_t size)
>   */
>  static int _open_kvm_dev_path_or_exit(int flags)
>  {
> -       int fd;
> -
> -       fd = open(KVM_DEV_PATH, flags);
> -       if (fd < 0) {
> -               print_skip("%s not available, is KVM loaded? (errno: %d)",
> -                          KVM_DEV_PATH, errno);
> -               exit(KSFT_SKIP);
> -       }
> -
> -       return fd;
> +       return open_path_or_exit(KVM_DEV_PATH, flags);
>  }
>
>  int open_kvm_dev_path_or_exit(void)
>
>
> > +
> > +static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> > +{
> > +     struct kvm_sev_cmd cmd = {
> > +             .id = cmd_id,
> > +             .data = (uint64_t)data,
> > +             .sev_fd = open_sev_dev_path_or_exit(0),
> > +     };
> > +     int ret;
> > +
> > +     TEST_ASSERT(cmd_id < KVM_SEV_NR_MAX && cmd_id >= 0,
> > +                 "Unknown SEV CMD : %d\n", cmd_id);
>
> LOL, I like sanity checks, but asserting that the test itself isn't horrendously
> broken is a bit much.  And someone manages to screw up that badly, the ioctl()
> below will fail.

Ack. I'll remove this.

>
> > +     ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> > +     TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> > +                 "%d failed: return code: %d, errno: %d, fw error: %d",
> > +                 cmd_id, ret, errno, cmd.error);
> > +}
> > +
> > +static struct kvm_vm *sev_vm_create(bool es)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct kvm_sev_launch_start start = { 0 };
> > +     int i;
>
> Rather than cache /dev/sev in a helper, you can do:
>
>         int sev_fd = open_path_or_exit(SEV_DEV_PATH, 0);
>
>         sev_ioctl(vm, sev_fd, ...);
>
> > +     vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> > +     sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
> > +     for (i = 0; i < MIGRATE_TEST_NUM_VCPUS; ++i)
> > +             vm_vcpu_add(vm, i);
> > +     start.policy |= (es) << 2;
>
> I had to go spelunking to confirm this is the "ES" policy, please do:
>
>         if (es)
>                 start.policy |= SEV_POLICY_ES;
>
> > +     sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
> > +     if (es)
> > +             sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
>
>
> And with sev_fd scoped to this function:
>
>         close(sev_fd);
>
> which I think is legal?
>
> > +     return vm;
> > +}
> > +
> > +static void test_sev_migrate_from(bool es)
> > +{
> > +     struct kvm_vm *vms[MIGRATE_TEST_VMS];
>
> Prefix this and LOCK_TESTING_THREAD with NR_ so that it's clear these are arbitrary
> numbers of things.  And I guess s/MIGRATE_TEST_NUM_VCPUS/NR_MIGRATE_TEST_VCPUS to
> be consistent.
>
> > +     struct kvm_enable_cap cap = {
> > +             .cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
> > +     };
> > +     int i;
> > +
> > +     for (i = 0; i < MIGRATE_TEST_VMS; ++i) {
> > +             vms[i] = sev_vm_create(es);
>
> It doesn't really matter, but closing these fds tests that KVM doesn't explode
> when VMs are destroyed without the process exiting.
>

Can do, I spot checked a couple other tests and didn't see any close
calls so didn't clutter the test here.

> > +             if (i > 0) {
> > +                     cap.args[0] = vms[i - 1]->fd;
> > +                     vm_enable_cap(vms[i], &cap);
> > +             }
> > +     }
>
> For giggles, we can also test migrating back (with some feedback from below
> mixed in):
>
>         /* Initial migration from the src to the first dst. */
>         sev_migrate_from(dst_vms[0]->fd, src_vm->fd);
>
>         for (i = 1; i < NR_MIGRATE_TEST_VMS; i++)
>                 sev_migrate_from(vms[i]->fd, vms[i - 1]->fd);
>
>         /* Migrate the guest back to the original VM. */
>         sev_migrate_from(src_vm->fd, dst_vms[NR_MIGRATE_TEST_VMS - 1]->fd);
>
> > +}
> > +
> > +struct locking_thread_input {
> > +     struct kvm_vm *vm;
> > +     int source_fds[LOCK_TESTING_THREADS];
> > +};
> > +
> > +static void *locking_test_thread(void *arg)
> > +{
> > +     /*
> > +      * This test case runs a number of threads all trying to use the intra
> > +      * host migration ioctls. This tries to detect if a deadlock exists.
> > +      */
> > +     struct kvm_enable_cap cap = {
> > +             .cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
> > +     };
> > +     int i, j;
> > +     struct locking_thread_input *input = (struct locking_test_thread *)arg;
> > +
> > +     for (i = 0; i < LOCK_TESTING_ITERATIONS; ++i) {
> > +             j = input->source_fds[i % LOCK_TESTING_THREADS];
> > +             cap.args[0] = input->source_fds[j];
>
> This looks wrong, it's indexing source_fds with a value from source_fds.  Did
> you intend?
>
>                 j = i % LOCK_TESTING_THREADS;
>                 cap.args[0] = input->source_fds[j];
>

Yup that's wrong I'll update.

> > +             /*
> > +              * Call IOCTL directly without checking return code or
> > +              * asserting. We are * simply trying to confirm there is no
> > +              * deadlock from userspace * not check correctness of
> > +              * migration here.
> > +              */
> > +             ioctl(input->vm->fd, KVM_ENABLE_CAP, &cap);
>
> For readability and future extensibility, I'd say create a single helper and use
> it even in the happy case, e.g.
>
> static int __sev_migrate_from(int dst_fd, int src_fd)
> {
>         struct kvm_enable_cap cap = {
>                 .cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM,
>                 .args = { src_fd } // No idea if this is correct syntax
>         };
>
>         return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
> }
>
>
> static void sev_migrate_from(...)
> {
>         ret = __sev_migrate_from(...);
>         TEST_ASSERT(!ret, "Migration failed, blah blah blah");
> }
>
> > +     }
> > +}
> > +
> > +static void test_sev_migrate_locking(void)
> > +{
> > +     struct locking_thread_input input[LOCK_TESTING_THREADS];
> > +     pthread_t pt[LOCK_TESTING_THREADS];
> > +     int i;
> > +
> > +     for (i = 0; i < LOCK_TESTING_THREADS; ++i) {
>
> With a bit of refactoring, the same VMs from the happy case can be reused for
> the locking test, and we can also get concurrent SEV+SEV-ES migration (see below).
>
> > +             input[i].vm = sev_vm_create(/* es= */ false);
> > +             input[0].source_fds[i] = input[i].vm->fd;
> > +     }
> > +     for (i = 1; i < LOCK_TESTING_THREADS; ++i)
> > +             memcpy(input[i].source_fds, input[0].source_fds,
> > +                    sizeof(input[i].source_fds));
> > +
> > +     for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> > +             pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
> > +
> > +     for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> > +             pthread_join(pt[i], NULL);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     test_sev_migrate_from(/* es= */ false);
> > +     test_sev_migrate_from(/* es= */ true);
> > +     test_sev_migrate_locking();
>
>
> With a little refactoring, this can add other tests, e.g. illegal dst.  Assuming
> KVM requires the dst to be !SEV, SEV and SEV-ES can use the same set of destination
> VMs.  And the locking test can take 'em all.  E.g. something like:
>
>         struct kvm_vm *sev_vm, *sev_es_vm;
>
>         sev_vm = sev_vm_create(false);
>         sev_es_vm = sev_vm_create(true);
>
>         for (i = 0; i < NR_MIGRATE_TEST_VMS; i++)
>                 dst_vms[i] = sev_dst_vm_create();
>
>         test_sev_migrate_from(sev_vms, dst_vms);
>         test_sev_migrate_from(sev_es_vms, dst_vms);
>
>         ret = __sev_migrate_from(sev_es_vms[0], sev_vms[0]);
>         TEST_ASSERT(ret == -EINVAL, ...);
>
>         ret = __sev_migrate_from(sev_vms[0], sev_es_vms[0]);
>         TEST_ASSERT(ret == -EINVAL, ...);
>
>         ret = __sev_migrate_from(dst_vms[0], dst_vms[1]);
>         TEST_ASSERT(ret == -EINVAL, ....);
>
>         test_sev_migrate_locking(sev_vm, sev_es_vm, dst_vms);
>

Ack. I'll add these parameter validation tests.

> > +     return 0;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
