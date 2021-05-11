Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD68937B00E
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEKU2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhEKU2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 16:28:33 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B34DC061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:27:26 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id p20so2794737ljj.8
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uD3Tn3/t3xksFJrzjUTGoAzR35dWARbVrz0zLQVE3lw=;
        b=qK6NhCV9qC1vpuha/89CUYp4q4b/qjPBtzaz9YUIB/Pd8rJthSh8tEnQRgo1wBJAdd
         t1zn/ECxiOPsUd5VmmXMZmvNrJHocQMb1MVQDGgRHvyuXfjAkPL5mUAbDgAus3YvxOEe
         CKVmZ5oDoaL806J4RaVDOtJZeHWkFb3AZiMVN4zDFGV94TX69NixF0/YHeSknGaV/WXR
         5/zRnki6GItLVzu8p1h5arWRG/ZCKApnK4u/oiCGLZdKb0wK+ithZxDoS0wEWz7KXMCP
         uxiR9zkqchIjYYXB7xw2atrHs+Axqn8XEXLNg5uDA94Jkv2Fy7LGy5mEwW1kVEBenoU4
         L49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uD3Tn3/t3xksFJrzjUTGoAzR35dWARbVrz0zLQVE3lw=;
        b=YoX2+NVKWkWxbZPUTwNOz99Ra2xfilO61W/Yr9Lmt6eof5KfrfjyT6MYH9WPckhjsY
         YZGjFw6b7NgN7PL3BeVjKYBFr3GOksyj+nino3nXYJNfGeSuHVb1w1+H8Fk/B86GwCJM
         KTPb1Iht21RHq7eYJx75q2BqFOhLShViluwf1empgLrKDvlvlQyDqdIIkhQRRyf+CnTm
         apkNofzDS/4GNTyBhKu5xMJikTDT3Yuw1Mk07KyoqjPmzYE17bUaCklRZLDVcUMel1Eo
         37MRh6RbP8+kSRrE/17PDBROSCn5hnl4ggM0NEYtz8qgrZAXpf4ErvLjsPB8kbIOnDwe
         c01w==
X-Gm-Message-State: AOAM530JDawTE0F5HuG6iyunJdQoDGf3dGq4yklnwuJZT/HwuiPBROyL
        vaaclGZ0rnoJj8efOdwntXpZyfN13TqQ2fCJdo3T9A==
X-Google-Smtp-Source: ABdhPJz8F2taQWbbvLQ4csDbDduxplsj7pcTV4AGNabIuvIOb7VKReQ45NuULIB70zR6KvWrkzYwSnpxxkCGXeN/K+o=
X-Received: by 2002:a2e:b0c2:: with SMTP id g2mr25850334ljl.492.1620764844562;
 Tue, 11 May 2021 13:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210510174639.1130344-1-dmatlack@google.com> <20210511091131.dywh2mkpazizyjhb@gator>
In-Reply-To: <20210511091131.dywh2mkpazizyjhb@gator>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 11 May 2021 13:26:58 -0700
Message-ID: <CALzav=c9p2GBNJ-g4qxrpd_EBW_GxdXdAbWcz_9k2_mY7LrioQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: selftests: Print a message if /dev/kvm is missing
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 2:11 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, May 10, 2021 at 05:46:39PM +0000, David Matlack wrote:
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
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 45 +++++++++++++------
> >  .../selftests/kvm/lib/x86_64/processor.c      | 16 ++-----
> >  .../kvm/x86_64/get_msr_index_features.c       |  8 +---
> >  4 files changed, 38 insertions(+), 32 deletions(-)
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
> > index fc83f6c5902d..e53f4c0953dc 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -31,6 +31,33 @@ static void *align(void *x, size_t size)
> >       return (void *) (((size_t) x + mask) & ~mask);
> >  }
> >
> > +/*
> > + * Open KVM_DEV_PATH if available, otherwise exit the entire program.
> > + *
> > + * Input Args:
> > + *   flags - The flags to pass when opening KVM_DEV_PATH.
> > + *
> > + * Return:
> > + *   The opened file descriptor of /dev/kvm.
> > + */
> > +int _open_kvm_dev_path_or_exit(int flags)
>
> nit: Could be static or have its prototype added to kvm_util.h

Fixed in v4, thanks.

>
> > +{
> > +     int fd;
> > +
> > +     fd = open(KVM_DEV_PATH, flags);
> > +     if (fd < 0) {
> > +             print_skip("%s not available", KVM_DEV_PATH);
> > +             exit(KSFT_SKIP);
> > +     }
> > +
> > +     return fd;
> > +}
> > +
> > +int open_kvm_dev_path_or_exit(void)
> > +{
> > +     return _open_kvm_dev_path_or_exit(O_RDONLY);
> > +}
> > +
> >  /*
> >   * Capability
> >   *
> > @@ -52,10 +79,7 @@ int kvm_check_cap(long cap)
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
> > @@ -128,9 +152,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
> >
> >  static void vm_open(struct kvm_vm *vm, int perm)
> >  {
> > -     vm->kvm_fd = open(KVM_DEV_PATH, perm);
> > -     if (vm->kvm_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     vm->kvm_fd = _open_kvm_dev_path_or_exit(perm);
> >
> >       if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
> >               print_skip("immediate_exit not available");
> > @@ -925,9 +947,7 @@ static int vcpu_mmap_sz(void)
> >  {
> >       int dev_fd, ret;
> >
> > -     dev_fd = open(KVM_DEV_PATH, O_RDONLY);
> > -     if (dev_fd < 0)
> > -             exit(KSFT_SKIP);
> > +     dev_fd = open_kvm_dev_path_or_exit();
> >
> >       ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
> >       TEST_ASSERT(ret >= sizeof(struct kvm_run),
> > @@ -2015,10 +2035,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> >
> >       if (vm == NULL) {
> >               /* Ensure that the KVM vendor-specific module is loaded. */
> > -             f = fopen(KVM_DEV_PATH, "r");
> > -             TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
> > -                         errno);
> > -             fclose(f);
> > +             close(open_kvm_dev_path_or_exit());
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
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> Thanks,
> drew
>
