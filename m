Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9588376B4D
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhEGUxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhEGUxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 16:53:14 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AA9C061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 13:52:14 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id b7so13217095ljr.4
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 13:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pqx+Yh79oShnr9QLT0LC+g9cQjdIigmxb+qe4aXRsbU=;
        b=NhWhTSPAfqxipopv1tKRoCD7cLw3PjXFN7TPBoOB064Do+g8fC0VE8HFdm4LLwpGSw
         VmnGDlg1PhHLluk6h8ipWoo0iiRcDnocHarfnweR0XHBB2kuxGYrprNeT7AxF0mzDrkH
         QA6OWDLpo9CcIh6BNApmclgQ99Ede63db7eqzY2g3TaKhDjUZsFZMPZ1LS68SUVoJPoL
         W50VM0iUIVACMAFwQTdaPkRpRgTpUoLY2O4de/u9vME/JXwko6Yjfn41npMsbTFsFakA
         +ORltpFhwFwfkLW0AKJsoDegnfpNly+wDTbC4gb4LOBYZs92n4HpeeR99PcJ7EzSkgdB
         4V5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pqx+Yh79oShnr9QLT0LC+g9cQjdIigmxb+qe4aXRsbU=;
        b=REJ3ri0Z8Ay12/tIsgrZoa1JpH3v8kV2oRigheoQnKG9fHvq7BzL5JwKxoHCz7X2nO
         Yg5xLINie8+/mTAPBHixIP/7Gw9Trqj+dZKDAcK8/mG2I/YT2vlEjwsaLgSnlbV+dVa8
         3SfRe0ghIgXMxpqbvGZAD8Bn3/awJGVcu3ERgvuOuN+rRlUfo5HpRFzS3VY4r/KG411s
         pArwOsY8PgLR5e9kqzzr5Fzl7O3Y/yj2lctrsdASlOBIX1jozIH2HOrOLPBKOHCWONT/
         +wnzC4XdPR4BjK97yWaWFyIkGu2lpUdDp6HaeKjiyf88esDCG/g8694l52qbNTi60INK
         jm0g==
X-Gm-Message-State: AOAM5326dDLo6wQy0AroG19Iq+xPIp4vyY0WZOxJWp5YIRMAEObV5Ic3
        gUdyVaZpUnRgf01TqUDr6O+ufjKkxnpDo3zmepHI5Q==
X-Google-Smtp-Source: ABdhPJzBuza8TyWVdlyds2R3LyNzfin0JkaBKGtJVgU29SygpnE/D3ohPluK/2xVmRkYxBXPZ5iL7zBCw2Tc5G2R+yA=
X-Received: by 2002:a2e:954e:: with SMTP id t14mr9134852ljh.447.1620420731933;
 Fri, 07 May 2021 13:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210507190559.425518-1-dmatlack@google.com> <20210507201443.nvtmntp3tgeapwnw@gator.home>
In-Reply-To: <20210507201443.nvtmntp3tgeapwnw@gator.home>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 7 May 2021 13:51:45 -0700
Message-ID: <CALzav=dk_Z=hQE1Bjpfg8B3su7h2Jvk6RZoEFqBn+qqxmwzHMQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Print a message if /dev/kvm is missing
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 7, 2021 at 1:14 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, May 07, 2021 at 07:05:59PM +0000, David Matlack wrote:
> > If a KVM selftest is run on a machine without /dev/kvm, it will exit
> > silently. Make it easy to tell what's happening by printing an error
> > message.
> >
> > Opportunistically consolidate all codepaths that open /dev/kvm into a
> > single function so they all print the same message.
> >
> > This slightly changes the semantics of vm_is_unrestricted_guest() by
> > changing a TEST_ASSERT() to exit(KSFT_SKIP). However
> > vm_is_unrestricted_guest() is only called in one place
> > (x86_64/mmio_warning_test.c) and that is to determine if the test should
> > be skipped or not.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++--------
> >  .../selftests/kvm/lib/x86_64/processor.c      | 16 +++------
> >  .../kvm/x86_64/get_msr_index_features.c       |  8 ++---
> >  4 files changed, 28 insertions(+), 32 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index a8f022794ce3..84982eb02b29 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -77,6 +77,7 @@ struct vm_guest_mode_params {
> >  };
> >  extern const struct vm_guest_mode_params vm_guest_mode_params[];
> >
> > +int open_kvm_dev_path_or_exit(void);
> >  int kvm_check_cap(long cap);
> >  int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
> >  int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index fc83f6c5902d..bb7dc65d7fb5 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -31,6 +31,23 @@ static void *align(void *x, size_t size)
> >       return (void *) (((size_t) x + mask) & ~mask);
> >  }
> >
> > +/* Open KVM_DEV_PATH if available, otherwise exit the entire program.
> > + *
> > + * Return:
> > + *   The opened file descriptor of /dev/kvm.
> > + */
> > +int open_kvm_dev_path_or_exit(void) {
> > +  int fd;
> > +
> > +  fd = open(KVM_DEV_PATH, O_RDONLY);
> > +  if (fd < 0) {
> > +    print_skip("%s not available", KVM_DEV_PATH);
> > +    exit(KSFT_SKIP);
> > +  }
> > +
> > +  return fd;
> > +}
>
> Style issues in the function above '{' and 2 spaces vs. 1 tab.

Well that's sure embarrassing! Thanks for catching.

>
> > +
> >  /*
> >   * Capability
> >   *
> > @@ -52,10 +69,7 @@ int kvm_check_cap(long cap)
> >       int ret;
> >       int kvm_fd;
> >
> > -     kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > -
> > +     kvm_fd = open_kvm_dev_path_or_exit();
> >       ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
> >       TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
> >               "  rc: %i errno: %i", ret, errno);
> > @@ -128,9 +142,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
> >
> >  static void vm_open(struct kvm_vm *vm, int perm)
> >  {
> > -     vm->kvm_fd = open(KVM_DEV_PATH, perm);
>
> I don't think we should change this one, otherwise the user provided
> perms are ignored.

Good catch. I don't see any reason to exclude this case, but we do need
to pass `perm` down to open_kvm_dev_path_or_exit().


>
> > -     if (vm->kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     vm->kvm_fd = open_kvm_dev_path_or_exit();
> >
> >       if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
> >               print_skip("immediate_exit not available");
> > @@ -925,9 +937,7 @@ static int vcpu_mmap_sz(void)
> >  {
> >       int dev_fd, ret;
> >
> > -     dev_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (dev_fd < 0)
> > -             exit(KSFT_SKIP);
> > +        dev_fd = open_kvm_dev_path_or_exit();
>
> spaces vs. tab here
>
> >
> >       ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
> >       TEST_ASSERT(ret >= sizeof(struct kvm_run),
> > @@ -2015,10 +2025,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> >
> >       if (vm == NULL) {
> >               /* Ensure that the KVM vendor-specific module is loaded. */
> > -             f = fopen(KVM_DEV_PATH, "r");
> > -             TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
> > -                         errno);
> > -             fclose(f);
> > +                close(open_kvm_dev_path_or_exit());
>
> spaces
>
> >       }
> >
> >       f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index a8906e60a108..efe235044421 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -657,9 +657,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
> >               return cpuid;
> >
> >       cpuid = allocate_kvm_cpuid2();
> > -     kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     kvm_fd = open_kvm_dev_path_or_exit();
> >
> >       ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
> >       TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
> > @@ -691,9 +689,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
> >
> >       buffer.header.nmsrs = 1;
> >       buffer.entry.index = msr_index;
> > -     kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     kvm_fd = open_kvm_dev_path_or_exit();
> >
> >       r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
> >       TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
> > @@ -986,9 +982,7 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
> >       struct kvm_msr_list *list;
> >       int nmsrs, r, kvm_fd;
> >
> > -     kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     kvm_fd = open_kvm_dev_path_or_exit();
> >
> >       nmsrs = kvm_get_num_msrs_fd(kvm_fd);
> >       list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
> > @@ -1312,9 +1306,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
> >               return cpuid;
> >
> >       cpuid = allocate_kvm_cpuid2();
> > -     kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     kvm_fd = open_kvm_dev_path_or_exit();
> >
> >       ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
> >       TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
> > diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> > index cb953df4d7d0..8aed0db1331d 100644
> > --- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> > +++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> > @@ -37,9 +37,7 @@ static void test_get_msr_index(void)
> >       int old_res, res, kvm_fd, r;
> >       struct kvm_msr_list *list;
> >
> > -     kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     kvm_fd = open_kvm_dev_path_or_exit();
> >
> >       old_res = kvm_num_index_msrs(kvm_fd, 0);
> >       TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
> > @@ -101,9 +99,7 @@ static void test_get_msr_feature(void)
> >       int res, old_res, i, kvm_fd;
> >       struct kvm_msr_list *feature_list;
> >
> > -     kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     kvm_fd = open_kvm_dev_path_or_exit();
> >
> >       old_res = kvm_num_feature_msrs(kvm_fd, 0);
> >       TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
> > --
> > 2.31.1.607.g51e8a6a459-goog
> >
>
> Thanks,
> drew
>
