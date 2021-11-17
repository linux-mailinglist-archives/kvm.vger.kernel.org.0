Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE93454B92
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 18:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhKQRGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 12:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhKQRGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 12:06:35 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2D3C061766
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:03:36 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b1so11523190lfs.13
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7ZeURsfm4AXTkpamKINmOYQ2FnZeIesqVe6cwEr2gs=;
        b=USJ25q1qWLEmVBtuZdhzZDnFTgIx6J22he/rofO0Y6oxw2IoClQMT3CyDDmPB0bUTt
         TmPYItv349ILML9FLTtPpuGWJEbFzhSul/km5g4W9xXA9qNxwntSMGKs0Lwq0CWbay9+
         o810U4Jy3V6XaBiRH8WLIF0nJ3FTknEOnipsnJ7X4VNrOcQfJglCzGHjkONGY3Cd4U0C
         LTybn766Z9YqcD2y+Bd4wV4PLgij8xooadNwj2rz0vYwhSP/agBCwQlbhlxwY9i7nvhD
         QlZeRhO9h6rkofI+jE6piHE4pRnm8++9N6PJt7JEpjpuuiDglEsGlxc5B+A8Ji4fws3H
         pv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7ZeURsfm4AXTkpamKINmOYQ2FnZeIesqVe6cwEr2gs=;
        b=nS08REHgI3MDQl0iDp19wdIB/+5/3upm8bSRSS0XsxRs2yDzjJmpmSxiflGTdBZt7Q
         nH/DAbr9yZhF7Gdjbe9KRPVOiV7dGyzWbKYMsduONINCJXNtt7Bapyv4czjisOqk45O1
         JOnbnk4fFD3VjckJIIi33+R7jNHwiCPq/9gd2En2OGIA0fDmtNsozz1aIyq9cZjsjOq6
         wmqKz7V7IlKVzU3F+MD4kgdZen+akLRTES52GdGNU4VQarBLWMWGzkPXKSR3wrPEhdp5
         lpomWj1ykmzO4BKBjGxwHnlcjx9JjfTBtjnvbLwm1tjBl/AXdcJx9Ke3+QsLd/rhr28O
         Karg==
X-Gm-Message-State: AOAM531EBw4nVJ4ZI3sEU5tGvsaT1DPLLCSiAXKMy8zSVnOs+b1WuBB5
        zA9em2N8PAweXCpfcIpO244h+Rcz8/aDE5d8nfmsaA==
X-Google-Smtp-Source: ABdhPJz2+ZgVZPUFNriljP9knn2VW6oUwJ/0xUnylq0kDkM7qQJivs9PWiHBDV0++fWcUaP2IHYaVftvkjjW5nz9cuc=
X-Received: by 2002:ac2:4ad9:: with SMTP id m25mr16722932lfp.193.1637168612274;
 Wed, 17 Nov 2021 09:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20211117163809.1441845-1-pbonzini@redhat.com> <20211117163809.1441845-3-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-3-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 17 Nov 2021 10:03:20 -0700
Message-ID: <CAMkAt6ovkWTxwhcWMG7UT8X68TogG-0L_6rwTisTfgcWVNapSQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] selftests: sev_migrate_tests: add tests for KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 9:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> I am putting the tests in sev_migrate_tests because the failure conditions are
> very similar and some of the setup code can be reused, too.
>
> The tests cover both successful creation of a mirror VM, and error
> conditions.
>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../selftests/kvm/x86_64/sev_migrate_tests.c  | 106 ++++++++++++++++--
>  1 file changed, 99 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index 4a5d3728412b..986dc2ede61d 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -54,12 +54,15 @@ static struct kvm_vm *sev_vm_create(bool es)
>         return vm;
>  }
>
> -static struct kvm_vm *__vm_create(void)
> +static struct kvm_vm *aux_vm_create(bool with_vcpus)
>  {
>         struct kvm_vm *vm;
>         int i;
>
>         vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +       if (!with_vcpus)
> +               return vm;
> +
>         for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
>                 vm_vcpu_add(vm, i);
>
> @@ -93,7 +96,7 @@ static void test_sev_migrate_from(bool es)
>
>         src_vm = sev_vm_create(es);
>         for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
> -               dst_vms[i] = __vm_create();
> +               dst_vms[i] = aux_vm_create(true);
>
>         /* Initial migration from the src to the first dst. */
>         sev_migrate_from(dst_vms[0]->fd, src_vm->fd);
> @@ -157,7 +160,7 @@ static void test_sev_migrate_parameters(void)
>         sev_vm = sev_vm_create(/* es= */ false);
>         sev_es_vm = sev_vm_create(/* es= */ true);
>         vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> -       vm_no_sev = __vm_create();
> +       vm_no_sev = aux_vm_create(true);
>         sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
>         sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
>         vm_vcpu_add(sev_es_vm_no_vmsa, 1);
> @@ -198,11 +201,100 @@ static void test_sev_migrate_parameters(void)
>         kvm_vm_free(vm_no_sev);
>  }
>
> +static int __sev_mirror_create(int dst_fd, int src_fd)
> +{
> +       struct kvm_enable_cap cap = {
> +               .cap = KVM_CAP_VM_COPY_ENC_CONTEXT_FROM,
> +               .args = { src_fd }
> +       };
> +
> +       return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
> +}
> +
> +
> +static void sev_mirror_create(int dst_fd, int src_fd)
> +{
> +       int ret;
> +
> +       ret = __sev_mirror_create(dst_fd, src_fd);
> +       TEST_ASSERT(!ret, "Migration failed, ret: %d, errno: %d\n", ret, errno);

Should this read "Mirroring failed..." or something?

> +}
> +
> +static void test_sev_mirror(bool es)
> +{
> +       struct kvm_vm *src_vm, *dst_vm;
> +       struct kvm_sev_launch_start start = {
> +               .policy = es ? SEV_POLICY_ES : 0
> +       };
> +       int i;
> +
> +       src_vm = sev_vm_create(es);
> +       dst_vm = aux_vm_create(false);
> +
> +       sev_mirror_create(dst_vm->fd, src_vm->fd);
> +
> +       /* Check that we can complete creation of the mirror VM.  */
> +       for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
> +               vm_vcpu_add(dst_vm, i);

Style question. I realized I didn't do this myself but should there
always be blank line after these conditionals/loops without {}s? Tom
had me add them to work in ccp driver, unsure if that should be
maintained everywhere.

> +       sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_START, &start);
> +       if (es)
> +               sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
> +
> +       kvm_vm_free(src_vm);
> +       kvm_vm_free(dst_vm);
> +}
> +
> +static void test_sev_mirror_parameters(void)
> +{
> +       struct kvm_vm *sev_vm, *sev_es_vm, *vm_no_vcpu, *vm_with_vcpu;
> +       int ret;
> +
> +       sev_vm = sev_vm_create(/* es= */ false);
> +       sev_es_vm = sev_vm_create(/* es= */ true);
> +       vm_with_vcpu = aux_vm_create(true);
> +       vm_no_vcpu = aux_vm_create(false);
> +
> +       ret = __sev_mirror_create(sev_vm->fd, sev_es_vm->fd);
> +       TEST_ASSERT(
> +               ret == -1 && errno == EINVAL,
> +               "Should not be able copy context to SEV enabled VM. ret: %d, errno: %d\n",

"Should not be able *to* copy ..." (Yea I think the exiting error is
missing the 'to')

> +               ret, errno);
> +
> +       ret = __sev_mirror_create(sev_es_vm->fd, sev_vm->fd);
> +       TEST_ASSERT(
> +               ret == -1 && errno == EINVAL,
> +               "Should not be able copy context to SEV-ES enabled VM. ret: %d, errno: %d\n",

"Should not be able *to* copy ..."

> +               ret, errno);
> +
> +       ret = __sev_mirror_create(vm_no_vcpu->fd, vm_with_vcpu->fd);
> +       TEST_ASSERT(ret == -1 && errno == EINVAL,
> +                   "Copy context requires SEV enabled. ret %d, errno: %d\n", ret,
> +                   errno);
> +
> +       ret = __sev_mirror_create(vm_with_vcpu->fd, sev_vm->fd);
> +       TEST_ASSERT(
> +               ret == -1 && errno == EINVAL,
> +               "SEV copy context requires no vCPUS on the destination. ret: %d, errno: %d\n",
> +               ret, errno);
> +
> +       kvm_vm_free(sev_vm);
> +       kvm_vm_free(sev_es_vm);
> +       kvm_vm_free(vm_with_vcpu);
> +       kvm_vm_free(vm_no_vcpu);
> +}
> +
>  int main(int argc, char *argv[])
>  {
> -       test_sev_migrate_from(/* es= */ false);
> -       test_sev_migrate_from(/* es= */ true);
> -       test_sev_migrate_locking();
> -       test_sev_migrate_parameters();
> +       if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
> +               test_sev_migrate_from(/* es= */ false);
> +               test_sev_migrate_from(/* es= */ true);
> +               test_sev_migrate_locking();
> +               test_sev_migrate_parameters();
> +       }
> +       if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
> +               test_sev_mirror(/* es= */ false);
> +               test_sev_mirror(/* es= */ true);
> +               test_sev_mirror_parameters();
> +       }
>         return 0;
>  }
> --
> 2.27.0
>
>
