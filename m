Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655D214BEB4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 18:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgA1Rhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 12:37:35 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:38697 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1Rhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 12:37:34 -0500
Received: by mail-ua1-f68.google.com with SMTP id c7so5116917uaf.5
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 09:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MrPGa2t97To8Zc7wiLiZ1JY/i83JnwG5vjQGgIcOTa8=;
        b=pU3FCiKFdZs5dVJAsyj+fpO10m4PeIlbLWW0cbYpSA46H8wcpAUqlwDXi5neSlx4BD
         hSKO9idP/yfGlwlYeEg9y0AQMMRzk8bHCVdJHg+8Gb3usbLDCM3QvNDcVDNIZz2iGlK8
         uqBH9NfjLlZOdve42q4/lO7VjncL+nLRZpJV7v3rJLzEjScpXXvKW7vg62p1vdo/J4my
         vgK+E2mfXEGyHtFXrxdcmcn36yXg7ePfuUQ6XeYJq7DuCf6PrrrFr4fZbZGeQhSF1GnE
         eHO/Z6KIHHrQbTwkFdq0KKH8RbkUahjjKRPQgjU7udluGR6RwCYq3rZTdGTCOEpEkV/P
         D9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MrPGa2t97To8Zc7wiLiZ1JY/i83JnwG5vjQGgIcOTa8=;
        b=XJcjSkWq8T3FVSyO3mIle7wAxPfPtSOnY50gdbuWSMdMbM7NJ9lEN4hLo2zCnQoDYp
         Skio3/NDfDb0c+A6AnYNIJqB5qQmEOLIQ5N762ziBgieatEr/tnRS6srY9ircurx/v17
         1NcUbNGkvFiWqid08jfp/VSZHc8UBYQpNnVvqEl4ykIUjcWO2weUG2PQVmpeG/Hw8Aoo
         WD/XxXQyzN6Sqotg+nvdULOfqEPSMfPFDTA0Ahc/hQYOhxlRFGVEOiyDPe1fu4kNcwS1
         MUqIQt0QF/aLpImrTIHdebQGHCGAUSIW7zbZiWOJmel4hrgXf7pjpzWzqvRTPZX/tVUZ
         d83Q==
X-Gm-Message-State: APjAAAUpExNUI3C4/swuQpr44e5yGpQoheR44YA6+sXwW4TPXycne8VI
        juFZRZN+p5uwk3uWBD8Qyye/kCkz5IC96v5IGhcNuw==
X-Google-Smtp-Source: APXvYqwtmrZyXCBVV1XadNvRQmWyvxgzdlAvr+t7Xo3/mjjYVDSa/nHKk5QX/pp0CiFRKxpBdf9IORwzXjWTCsHKdBU=
X-Received: by 2002:a9f:3e84:: with SMTP id x4mr13160981uai.83.1580233053043;
 Tue, 28 Jan 2020 09:37:33 -0800 (PST)
MIME-Version: 1.0
References: <20200128093443.25414-1-drjones@redhat.com>
In-Reply-To: <20200128093443.25414-1-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 28 Jan 2020 09:37:21 -0800
Message-ID: <CANgfPd-xYX5Y=ajjP62z-jwKepeFaRVwSMQKq3N1oc1zO57mRg@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: selftests: Introduce num-pages conversion utilities
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        thuth@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 1:34 AM Andrew Jones <drjones@redhat.com> wrote:
>
> Guests and hosts don't have to have the same page size. This means
> calculations are necessary when selecting the number of guest pages
> to allocate in order to ensure the number is compatible with the
> host. Provide utilities to help with those calculations.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  | 10 ++++----
>  .../testing/selftests/kvm/include/kvm_util.h  |  3 +++
>  .../testing/selftests/kvm/include/test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++++++++++++
>  4 files changed, 33 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 5614222a6628..2383c55a1a1a 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -178,12 +178,11 @@ static void *vcpu_worker(void *data)
>         return NULL;
>  }
>
> -static void vm_dirty_log_verify(unsigned long *bmap)
> +static void vm_dirty_log_verify(struct kvm_vm *vm, unsigned long *bmap)
>  {
> +       uint64_t step = vm_num_host_pages(vm, 1);
>         uint64_t page;
>         uint64_t *value_ptr;
> -       uint64_t step = host_page_size >= guest_page_size ? 1 :
> -                               guest_page_size / host_page_size;
>
>         for (page = 0; page < host_num_pages; page += step) {
>                 value_ptr = host_test_mem + page * host_page_size;
> @@ -295,8 +294,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
>  #endif
>         host_page_size = getpagesize();
> -       host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
> -                        !!((guest_num_pages * guest_page_size) % host_page_size);
> +       host_num_pages = vm_num_host_pages(vm, guest_num_pages);
>
>         if (!phys_offset) {
>                 guest_test_phys_mem = (vm_get_max_gfn(vm) -
> @@ -369,7 +367,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>                 kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
>                                        host_num_pages);
>  #endif
> -               vm_dirty_log_verify(bmap);
> +               vm_dirty_log_verify(vm, bmap);
>                 iteration++;
>                 sync_global_to_guest(vm, iteration);
>         }
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 29cccaf96baf..0d05ade3022c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -158,6 +158,9 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
>  unsigned int vm_get_page_shift(struct kvm_vm *vm);
>  unsigned int vm_get_max_gfn(struct kvm_vm *vm);
>
> +unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest_pages);
> +unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host_pages);
> +
>  struct kvm_userspace_memory_region *
>  kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>                                  uint64_t end);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index a41db6fb7e24..25c27739e085 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -19,6 +19,8 @@
>  #include <fcntl.h>
>  #include "kselftest.h"
>
> +#define getpageshift() (__builtin_ffs(getpagesize()) - 1)
> +
>  ssize_t test_write(int fd, const void *buf, size_t count);
>  ssize_t test_read(int fd, void *buf, size_t count);
>  int test_seq_read(const char *path, char **bufp, size_t *sizep);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 41cf45416060..d9bca2f1cc95 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1667,3 +1667,27 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
>  {
>         return vm->max_gfn;
>  }
> +
> +static unsigned int vm_calc_num_pages(unsigned int num_pages,
> +                                     unsigned int page_shift,
> +                                     unsigned int new_page_shift)
> +{
> +       unsigned int n = 1 << (new_page_shift - page_shift);
> +
> +       if (page_shift >= new_page_shift)
> +               return num_pages * (1 << (page_shift - new_page_shift));
> +
> +       return num_pages / n + !!(num_pages % n);
> +}
> +
> +unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest_pages)
> +{
> +       return vm_calc_num_pages(num_guest_pages, vm_get_page_shift(vm),
> +                                getpageshift());
> +}
> +
> +unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host_pages)
> +{
> +       return vm_calc_num_pages(num_host_pages, getpageshift(),
> +                                vm_get_page_shift(vm));
> +}

This function appears to be unused. I don't have any opposition to
adding it since it is simple, unlikely to bitrot, and seems like a
useful utility.

> --
> 2.21.1
>
