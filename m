Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8549438990D
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 00:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhESWFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 18:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhESWFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 18:05:18 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E46C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 15:03:57 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h15so10723616ilr.2
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 15:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DHPp5dFe4661NAQ9YjGdxmJrJmUrsmOq7WtKD4ddN7s=;
        b=HBAODJKKUijlVggNYGOWYIGxWYk4G+D2MQvWauqSlfji5VEf4ImhXlg1LpWyJRna1o
         dZmU0Gw1rQJJO5OIiQLZCJn4Qr320bVFgYsttQUdjRzGUJT3hefgjsyQJw9XLxwyzNn3
         QpiRssJweEUgRJtKseFmWLxWV+9GpRMVS/k2ZY+KMzeB+gPFbKftJs21nao264aIrMZO
         r+IN1U0E74zBtNx1nYtfaEkviAqu+s3xKYzkIJK6JyQzY0z+Jop78gMfHcItJtvf6wN5
         xmFsDvMU6v/O0zUkLvR2kXTAU1+C/aSybGWM/Ol4hAr7SIJEMq2opG2KHI33H/kWkUP4
         QWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DHPp5dFe4661NAQ9YjGdxmJrJmUrsmOq7WtKD4ddN7s=;
        b=dbw2E9Evu8Qkm77xUdXfrV3MI893v1bvma6XbMNF8Tdx+nJ8T2VyD671nNzOOlbgXO
         hObmROj4MBzYPOVjZ7OaLKGJfXCWjA//FbgmKPT9foTDEL15rPrp5zCb9e6I9cUKF9Lo
         NJErveCAwhqbU8OPxGsa+45Q7hroo4ifV1H+UNRbv1ijjUBceWzk3gxdDmJiyvfk3h6C
         Nj687R6u4sLLG4vGURb6QGQvUv8hVwr54SMSWXaId/RNtqLvEjOlKa5Nw5kDOTwlQ3+e
         z/a53IdOphVYuGY0r7JDl+ZF5vVGNwdVMItRqgSDKamOcj0Z8OtpTrjOguLXQ/L/aIIY
         f1+g==
X-Gm-Message-State: AOAM531cC2SYoq9AmDiskhvDyKIqbpfdXg6wGPMe9SIv8526jUPqNIj9
        Yfq6lupmGmZTTBB1i2DCnIRC4svqMsnEmDE3yzAA2g==
X-Google-Smtp-Source: ABdhPJzvOa4UAerVrB7M8OLxjCg5uuHwY/VZ9mkWkkYYTtlBpg74yUXaUI00sk12G4Kx6v+wrPN124Cetzj9ghUTsp4=
X-Received: by 2002:a05:6e02:1a49:: with SMTP id u9mr1425014ilv.306.1621461836410;
 Wed, 19 May 2021 15:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210519200339.829146-1-axelrasmussen@google.com> <20210519200339.829146-8-axelrasmussen@google.com>
In-Reply-To: <20210519200339.829146-8-axelrasmussen@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 19 May 2021 15:03:45 -0700
Message-ID: <CANgfPd8r2TeBjrypBgkBTOkQWuYFW6UsfU36_XbB6wQiPu89qg@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] KVM: selftests: add shmem backing source type
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 1:04 PM Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> This lets us run the demand paging test on top of a shmem-backed area.
> In follow-up commits, we'll 1) leverage this new capability to create an
> alias mapping, and then 2) use the alias mapping to exercise UFFD minor
> faults.
>
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  tools/testing/selftests/kvm/include/test_util.h |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c      | 15 +++++++++++++++
>  tools/testing/selftests/kvm/lib/test_util.c     |  5 +++++
>  3 files changed, 21 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index fade3130eb01..7377f00469ef 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -84,6 +84,7 @@ enum vm_mem_backing_src_type {
>         VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB,
>         VM_MEM_SRC_ANONYMOUS_HUGETLB_2GB,
>         VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,
> +       VM_MEM_SRC_SHMEM,
>         NUM_SRC_TYPES,
>  };
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index bc405785ac8b..e4a8d0c43c5e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -757,6 +757,21 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>         if (alignment > 1)
>                 region->mmap_size += alignment;
>
> +       region->fd = -1;

Ah I guess this is the corresponding change from the previous patch.

> +       if (src_type == VM_MEM_SRC_SHMEM) {
> +               region->fd = memfd_create("kvm_selftest", MFD_CLOEXEC);
> +               TEST_ASSERT(region->fd != -1,
> +                           "memfd_create failed, errno: %i", errno);
> +
> +               ret = ftruncate(region->fd, region->mmap_size);
> +               TEST_ASSERT(ret == 0, "ftruncate failed, errno: %i", errno);
> +
> +               ret = fallocate(region->fd,
> +                               FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
> +                               region->mmap_size);
> +               TEST_ASSERT(ret == 0, "fallocate failed, errno: %i", errno);
> +       }
> +
>         region->mmap_start = mmap(NULL, region->mmap_size,
>                                   PROT_READ | PROT_WRITE,
>                                   vm_mem_backing_src_alias(src_type)->flag,
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 06ddde068736..c7a265da5090 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -236,6 +236,10 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i)
>                         .name = "anonymous_hugetlb_16gb",
>                         .flag = anon_huge_flags | MAP_HUGE_16GB,
>                 },
> +               [VM_MEM_SRC_SHMEM] = {
> +                       .name = "shmem",
> +                       .flag = MAP_SHARED,
> +               },
>         };
>         _Static_assert(ARRAY_SIZE(aliases) == NUM_SRC_TYPES,
>                        "Missing new backing src types?");
> @@ -253,6 +257,7 @@ size_t get_backing_src_pagesz(uint32_t i)
>
>         switch (i) {
>         case VM_MEM_SRC_ANONYMOUS:
> +       case VM_MEM_SRC_SHMEM:
>                 return getpagesize();
>         case VM_MEM_SRC_ANONYMOUS_THP:
>                 return get_trans_hugepagesz();
> --
> 2.31.1.751.gd2f1c929bd-goog
>
