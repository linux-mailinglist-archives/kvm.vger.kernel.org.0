Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A6F4F870F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240025AbiDGS2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiDGS2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:28:34 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A20F1A81F
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:26:33 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2eb46d33db9so71171587b3.12
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZO/VaBzICUogwa8JxPcQT1vXwwEwrQ7C+OQ5NQuWNk=;
        b=T8UgJy3FCHeiWK9+EQXtDrNPlt7oFz0wH2AbUybiMiuNaZGK428ch2DSQ1KNP0rkXl
         dRIONg6yNMtbzr8udMf9NN6BSUcn6EyvD2LLOsDfH2TDGf9cgPNyjLo2FJPGEQQSD//Y
         1pbi4ZgrAXF+QYIWiAMe2rSaG2cTRHAeRkKyfbXI04MK6eiqvTQr8MdLZ5U7ciOOwmQI
         UsAtge3witqfJ6ck5E+Xy3VyJaRzMk1ye9bhuYVxD0P5zMu8RaTEfM7FghbHnBV4Xklg
         nWIH+SF4/6i0+j4Vv4bEfjg6s1lPlO5AIxsjS5XqsaKpGLGFe8IHl8cLSxc2vrtsf6kX
         hR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZO/VaBzICUogwa8JxPcQT1vXwwEwrQ7C+OQ5NQuWNk=;
        b=UbcRYc6KytNaLOFg1u4ngxuMZN5RAUTKYg1yGXmHtQ1tevXzpdJXoHA7q7C3D4564R
         1G0IGHkbuiz67ILglS7KDwzNd3NJSEB2TEu8QUJsPlywlKNYriuZ+v4v2ilyPp3ABFMU
         Zu/BumsBTtYXqE1cU7Juxo9Uxb20BQ94YiuCSM3mBwkRky6Dxqn5RCb5UOseCTWbPLZq
         ZJJ5yPXhxwGSUH8KDraJk8ZHRwIMRkIs3vnlM5fEruUNZ5Yy/b6zNaCJCXzY3XFExzrm
         Rwe2NROYIUdWQAHd12XGsQ3xsWB7hok7PAoQYP5TlKPMNu3iwZP7AhIutzb7nXmwM5Mu
         KxlA==
X-Gm-Message-State: AOAM531KoQWX/9kzOg9ifvv3clkDcfymZ0gmDM0Fvz0P6koISYt3r+vz
        SIp1mIOehM4lDWUA5rHd3IMZGIuOZVWQXcihSQbcpQ==
X-Google-Smtp-Source: ABdhPJzyvB1ppvjImNgEJMCp5fyJrDHBBiASxp9xCnf8Y24mDH+MvZUu0P8mkVhtjvnELsfKFiCl/0wHzyfbBHsqM0E=
X-Received: by 2002:a0d:d5c3:0:b0:2e5:cc05:1789 with SMTP id
 x186-20020a0dd5c3000000b002e5cc051789mr12339828ywd.472.1649355992361; Thu, 07
 Apr 2022 11:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-12-bgardon@google.com>
 <YkzI2CL13ZMnPOb2@google.com>
In-Reply-To: <YkzI2CL13ZMnPOb2@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 7 Apr 2022 11:26:21 -0700
Message-ID: <CANgfPd9b90NTM5CS19KU187-mFD3Kx_0FYX1cZ1YEonhbYqL0A@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] selftests: KVM: Test disabling NX hugepages on a VM
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 5, 2022 at 3:55 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Mar 30, 2022 at 10:46:21AM -0700, Ben Gardon wrote:
> > Add an argument to the NX huge pages test to test disabling the feature
> > on a VM using the new capability.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |  2 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |  7 ++
> >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 67 ++++++++++++++++---
> >  .../kvm/x86_64/nx_huge_pages_test.sh          |  2 +-
> >  4 files changed, 66 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 72163ba2f878..4db8251c3ce5 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -411,4 +411,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
> >
> >  uint32_t guest_get_vcpuid(void);
> >
> > +void vm_disable_nx_huge_pages(struct kvm_vm *vm);
> > +
> >  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 9d72d1bb34fa..46a7fa08d3e0 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2765,3 +2765,10 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
> >       return value;
> >  }
> >
> > +void vm_disable_nx_huge_pages(struct kvm_vm *vm)
> > +{
> > +     struct kvm_enable_cap cap = { 0 };
> > +
> > +     cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
> > +     vm_enable_cap(vm, &cap);
> > +}
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > index 2bcbe4efdc6a..a0c79f6ddc08 100644
> > --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > @@ -13,6 +13,8 @@
> >  #include <fcntl.h>
> >  #include <stdint.h>
> >  #include <time.h>
> > +#include <linux/reboot.h>
> > +#include <sys/syscall.h>
> >
> >  #include <test_util.h>
> >  #include "kvm_util.h"
> > @@ -57,13 +59,56 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
> >                   expected_splits, actual_splits);
> >  }
> >
> > +static void help(void)
> > +{
> > +     puts("");
> > +     printf("usage: nx_huge_pages_test.sh [-x]\n");
> > +     puts("");
> > +     printf(" -x: Allow executable huge pages on the VM.\n");
>
> Making it a flag means we won't exercise it by default. Is there are
> reason to avoid exercising KVM_CAP_VM_DISABLE_NX_HUGE_PAGES by default?
>
> Assuming no, I would recommend factoring out the test to a helper
> function that takes a parameter that tells it if nx_huge_pages is
> enabled or disabled. Then run this helper function multiple times. E.g.
> once with nx_huge_pages enabled, once with nx_huge_pages disabled via
> KVM_CAP_VM_DISABLE_NX_HUGE_PAGES. This would also then let you test that
> disabling via module param also works.
>
> By the way, that brings up another issue. What if NX HugePages is not
> enabled on this host? e.g. we're running on AMD, or we're running on a
> non-affected Intel host, or we're running on a machine where nx huge
> pages has been disabled by the admin? The test should probably return
> KSFT_SKIP in those cases.

That's all a good idea. Will do.

>
> > +     puts("");
> > +     exit(0);
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >       struct kvm_vm *vm;
> >       struct timespec ts;
> > +     bool disable_nx = false;
> > +     int opt;
> > +     int r;
> > +
> > +     while ((opt = getopt(argc, argv, "x")) != -1) {
> > +             switch (opt) {
> > +             case 'x':
> > +                     disable_nx = true;
> > +                     break;
> > +             case 'h':
> > +             default:
> > +                     help();
> > +                     break;
> > +             }
> > +     }
> >
> >       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> >
> > +     if (disable_nx) {
> > +             /*
> > +              * Check if this process has the reboot permissions needed to
> > +              * disable NX huge pages on a VM.
> > +              *
> > +              * The reboot call below will never have any effect because
> > +              * the magic values are not set correctly, however the
> > +              * permission check is done before the magic value check.
> > +              */
> > +             r = syscall(SYS_reboot, 0, 0, 0, NULL);
> > +             if (r == -EPERM)
> > +                     return KSFT_SKIP;
> > +             TEST_ASSERT(r == -EINVAL,
> > +                         "Reboot syscall should fail with -EINVAL");
>
> Just check if KVM_CAP_VM_DISABLE_NX_HUGE_PAGES returns -EPERM?
>
> > +
> > +             vm_disable_nx_huge_pages(vm);
> > +     }
> > +
> >       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
> >                                   HPAGE_PADDR_START, HPAGE_SLOT,
> >                                   HPAGE_SLOT_NPAGES, 0);
> > @@ -83,21 +128,21 @@ int main(int argc, char **argv)
> >        * at 2M.
> >        */
> >       run_guest_code(vm, guest_code0);
> > -     check_2m_page_count(vm, 2);
> > -     check_split_count(vm, 2);
> > +     check_2m_page_count(vm, disable_nx ? 4 : 2);
> > +     check_split_count(vm, disable_nx ? 0 : 2);
> >
> >       /*
> >        * guest_code1 is in the same huge page as data1, so it will cause
> >        * that huge page to be remapped at 4k.
> >        */
> >       run_guest_code(vm, guest_code1);
> > -     check_2m_page_count(vm, 1);
> > -     check_split_count(vm, 3);
> > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> > +     check_split_count(vm, disable_nx ? 0 : 3);
> >
> >       /* Run guest_code0 again to check that is has no effect. */
> >       run_guest_code(vm, guest_code0);
> > -     check_2m_page_count(vm, 1);
> > -     check_split_count(vm, 3);
> > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> > +     check_split_count(vm, disable_nx ? 0 : 3);
> >
> >       /*
> >        * Give recovery thread time to run. The wrapper script sets
> > @@ -110,7 +155,7 @@ int main(int argc, char **argv)
> >       /*
> >        * Now that the reclaimer has run, all the split pages should be gone.
> >        */
> > -     check_2m_page_count(vm, 1);
> > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> >       check_split_count(vm, 0);
> >
> >       /*
> > @@ -118,13 +163,13 @@ int main(int argc, char **argv)
> >        * again to check that pages are mapped at 2M again.
> >        */
> >       run_guest_code(vm, guest_code0);
> > -     check_2m_page_count(vm, 2);
> > -     check_split_count(vm, 2);
> > +     check_2m_page_count(vm, disable_nx ? 4 : 2);
> > +     check_split_count(vm, disable_nx ? 0 : 2);
> >
> >       /* Pages are once again split from running guest_code1. */
> >       run_guest_code(vm, guest_code1);
> > -     check_2m_page_count(vm, 1);
> > -     check_split_count(vm, 3);
> > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> > +     check_split_count(vm, disable_nx ? 0 : 3);
> >
> >       kvm_vm_free(vm);
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > index 19fc95723fcb..29f999f48848 100755
> > --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > @@ -14,7 +14,7 @@ echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> >  echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> >  echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> >
> > -./nx_huge_pages_test
> > +./nx_huge_pages_test "${@}"
> >  RET=$?
> >
> >  echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> > --
> > 2.35.1.1021.g381101b075-goog
> >
