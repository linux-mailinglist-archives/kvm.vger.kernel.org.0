Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E711457CE
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgAVO1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:27:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30509 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbgAVO1V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 09:27:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579703239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGY2bBMo5QrAHIhV9weytjcCx41PqAY35U3IVR3UOKw=;
        b=QQyKX4DRLKY089Hx3yJhP/10aVZcV/nyXAuL+dx0rK++yv+WTiOBF/hY5arka5Cf2CzBex
        PbRdFUza3f1QtFQmnoEgpu2JN6KhMXKAz8Luu5D2s5SBc6uLpWK+To3BJ4z8LZ8FJwXON/
        zRctsMc6qc4ixF/fcTju/b6CX/kaLPo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-4Aq5JF-WOmuc7awamIRRqw-1; Wed, 22 Jan 2020 09:27:16 -0500
X-MC-Unique: 4Aq5JF-WOmuc7awamIRRqw-1
Received: by mail-wm1-f70.google.com with SMTP id l11so1623795wmi.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:27:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGY2bBMo5QrAHIhV9weytjcCx41PqAY35U3IVR3UOKw=;
        b=GVn/18EwRX6TNAG5IWu8jD6xkeM98v3qgt1iD08oM4njwQjQJzRoHtCZuVpfmBHrQY
         AOx9b4Erx5ybtKen+jFfMeQFgsgIXUr/wE5H2HOo/fwKEkkxC5Gp7QlvZZjUrPlXS5pT
         pe8yhwsUhq90oGRikbMvcHpeAdx8OPIoL3l/7i3VhShX9F1jKKquV9fUxOUaZfF0UEBp
         wwrsbw7Nmhi+fsMyAPSYgzGjpKNK1IolN3/1uhXCImb8PTp5+e0p5eg0vmTdTpA4uSC2
         w5pj7l2vctMRbLLTPQog0qvCTBMaM4h2H1WIjOopsweMzcz2KrtTHAP+LJyTEZNB6BDJ
         2l4Q==
X-Gm-Message-State: APjAAAWqDz/8vIGPNCUmaplNtHVMCQwhekUKnCHUvD7k5jl89QZnIs8Z
        QIhJaNh5/42JWCMZslLjXxvc2hW3NTqbl3vuYbwDHFwP1rXybT6o6P+GwxhidBbhtbXgGAD8uT0
        0wXzioy1VdEBW
X-Received: by 2002:a1c:488a:: with SMTP id v132mr3359461wma.153.1579703235378;
        Wed, 22 Jan 2020 06:27:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRXjIxSt94DbbOmUmnwZqShqF/0AET/9WjXKqTEwqDvxnXmsFpQNaUdSOr3l5kp7r/Wg3jeA==
X-Received: by 2002:a1c:488a:: with SMTP id v132mr3359435wma.153.1579703234942;
        Wed, 22 Jan 2020 06:27:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id s16sm59458822wrn.78.2020.01.22.06.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:27:14 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] Remove the old api folder
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20200121174719.31156-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40209c54-b96d-0436-d1d3-0ee286b79f16@redhat.com>
Date:   Wed, 22 Jan 2020 15:27:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121174719.31156-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 18:47, Thomas Huth wrote:
> The api tests are quite neglected - the tests work for 32-bit i386 only
> and there hasn't been any change in this folder since more than 2.5 years.
> Additionally, there is nowadays another way of testing the KVM API - the
> KVM selftests (as part of the Linux kernel sources) have a much higher
> traction and feature much more tests already, so it's unlikely that the
> API tests in the kvm-unit-tests repository will get much more attention
> in the future. Thus let's delete the api folder now to remove the burder
> from the kvm-unit-test maintainers of dragging this code along.
> If someone still wants to run the dirty-log-perf test for example, they
> can check out an older state of the repository (and then e.g. port the
> code to the KVM selftests framework instead).
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Makefile              |   2 -
>  api/api-sample.cc     |  30 -------
>  api/dirty-log-perf.cc | 146 -------------------------------
>  api/dirty-log.cc      |  84 ------------------
>  api/exception.cc      |  33 -------
>  api/exception.hh      |  19 ----
>  api/identity.cc       | 120 -------------------------
>  api/identity.hh       |  45 ----------
>  api/kvmxx.cc          | 199 ------------------------------------------
>  api/kvmxx.hh          |  86 ------------------
>  api/memmap.cc         |  96 --------------------
>  api/memmap.hh         |  43 ---------
>  configure             |  17 ----
>  x86/Makefile.common   |  19 +---
>  14 files changed, 1 insertion(+), 938 deletions(-)
>  delete mode 100644 api/api-sample.cc
>  delete mode 100644 api/dirty-log-perf.cc
>  delete mode 100644 api/dirty-log.cc
>  delete mode 100644 api/exception.cc
>  delete mode 100644 api/exception.hh
>  delete mode 100644 api/identity.cc
>  delete mode 100644 api/identity.hh
>  delete mode 100644 api/kvmxx.cc
>  delete mode 100644 api/kvmxx.hh
>  delete mode 100644 api/memmap.cc
>  delete mode 100644 api/memmap.hh
> 
> diff --git a/Makefile b/Makefile
> index 4c716da..6020b10 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -79,8 +79,6 @@ CFLAGS += $(wmissing_parameter_type)
>  CFLAGS += $(wold_style_declaration)
>  CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>  
> -CXXFLAGS += $(COMMON_CFLAGS)
> -
>  autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>  
>  LDFLAGS += $(CFLAGS)
> diff --git a/api/api-sample.cc b/api/api-sample.cc
> deleted file mode 100644
> index f523e47..0000000
> --- a/api/api-sample.cc
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -
> -#include "kvmxx.hh"
> -#include "identity.hh"
> -#include "exception.hh"
> -#include <stdio.h>
> -
> -static int global = 0;
> -
> -static void set_global()
> -{
> -    global = 1;
> -}
> -
> -int test_main(int ac, char** av)
> -{
> -    kvm::system system;
> -    kvm::vm vm(system);
> -    mem_map memmap(vm);
> -    identity::vm ident_vm(vm, memmap);
> -    kvm::vcpu vcpu(vm, 0);
> -    identity::vcpu thread(vcpu, set_global);
> -    vcpu.run();
> -    printf("global %d\n", global);
> -    return global == 1 ? 0 : 1;
> -}
> -
> -int main(int ac, char** av)
> -{
> -    return try_main(test_main, ac, av);
> -}
> diff --git a/api/dirty-log-perf.cc b/api/dirty-log-perf.cc
> deleted file mode 100644
> index f87b4b4..0000000
> --- a/api/dirty-log-perf.cc
> +++ /dev/null
> @@ -1,146 +0,0 @@
> -#include "kvmxx.hh"
> -#include "exception.hh"
> -#include "memmap.hh"
> -#include "identity.hh"
> -#include <stdlib.h>
> -#include <stdio.h>
> -#include <sys/time.h>
> -
> -namespace {
> -
> -const int page_size	= 4096;
> -int64_t nr_total_pages	= 256 * 1024;
> -int64_t nr_slot_pages	= 256 * 1024;
> -
> -// Return the current time in nanoseconds.
> -uint64_t time_ns()
> -{
> -    struct timespec ts;
> -
> -    clock_gettime(CLOCK_MONOTONIC, &ts);
> -    return ts.tv_sec * (uint64_t)1000000000 + ts.tv_nsec;
> -}
> -
> -// Update nr_to_write pages selected from nr_pages pages.
> -void write_mem(void* slot_head, int64_t nr_to_write, int64_t nr_pages)
> -{
> -    char* var = static_cast<char*>(slot_head);
> -    int64_t interval = nr_pages / nr_to_write;
> -
> -    for (int64_t i = 0; i < nr_to_write; ++i) {
> -        ++(*var);
> -        var += interval * page_size;
> -    }
> -}
> -
> -// Let the guest update nr_to_write pages selected from nr_pages pages.
> -void do_guest_write(kvm::vcpu& vcpu, void* slot_head,
> -                    int64_t nr_to_write, int64_t nr_pages)
> -{
> -    identity::vcpu guest_write_thread(vcpu, std::bind(write_mem, slot_head,
> -                                                      nr_to_write, nr_pages));
> -    vcpu.run();
> -}
> -
> -// Check how long it takes to update dirty log.
> -void check_dirty_log(kvm::vcpu& vcpu, mem_slot& slot, void* slot_head)
> -{
> -    slot.set_dirty_logging(true);
> -    slot.update_dirty_log();
> -
> -    for (int64_t i = 1; i <= nr_slot_pages; i *= 2) {
> -        do_guest_write(vcpu, slot_head, i, nr_slot_pages);
> -
> -        uint64_t start_ns = time_ns();
> -        int n = slot.update_dirty_log();
> -        uint64_t end_ns = time_ns();
> -
> -        printf("get dirty log: %10lld ns for %10d dirty pages (expected %lld)\n",
> -               end_ns - start_ns, n, i);
> -    }
> -
> -    slot.set_dirty_logging(false);
> -}
> -
> -}
> -
> -void parse_options(int ac, char **av)
> -{
> -    int opt;
> -    char *endptr;
> -
> -    while ((opt = getopt(ac, av, "n:m:")) != -1) {
> -        switch (opt) {
> -        case 'n':
> -            errno = 0;
> -            nr_slot_pages = strtol(optarg, &endptr, 10);
> -            if (errno || endptr == optarg) {
> -                printf("dirty-log-perf: Invalid number: -n %s\n", optarg);
> -                exit(1);
> -            }
> -            if (*endptr == 'k' || *endptr == 'K') {
> -                nr_slot_pages *= 1024;
> -            }
> -            break;
> -        case 'm':
> -            errno = 0;
> -            nr_total_pages = strtol(optarg, &endptr, 10);
> -            if (errno || endptr == optarg) {
> -                printf("dirty-log-perf: Invalid number: -m %s\n", optarg);
> -                exit(1);
> -            }
> -            if (*endptr == 'k' || *endptr == 'K') {
> -                nr_total_pages *= 1024;
> -            }
> -            break;
> -        default:
> -            printf("dirty-log-perf: Invalid option\n");
> -            exit(1);
> -        }
> -    }
> -
> -    if (nr_slot_pages > nr_total_pages) {
> -        printf("dirty-log-perf: Invalid setting: slot %lld > mem %lld\n",
> -               nr_slot_pages, nr_total_pages);
> -        exit(1);
> -    }
> -    printf("dirty-log-perf: %lld slot pages / %lld mem pages\n",
> -           nr_slot_pages, nr_total_pages);
> -}
> -
> -int test_main(int ac, char **av)
> -{
> -    kvm::system sys;
> -    kvm::vm vm(sys);
> -    mem_map memmap(vm);
> -
> -    parse_options(ac, av);
> -
> -    void* mem_head;
> -    int64_t mem_size = nr_total_pages * page_size;
> -    if (posix_memalign(&mem_head, page_size, mem_size)) {
> -        printf("dirty-log-perf: Could not allocate guest memory.\n");
> -        exit(1);
> -    }
> -    uint64_t mem_addr = reinterpret_cast<uintptr_t>(mem_head);
> -
> -    identity::hole hole(mem_head, mem_size);
> -    identity::vm ident_vm(vm, memmap, hole);
> -    kvm::vcpu vcpu(vm, 0);
> -
> -    uint64_t slot_size = nr_slot_pages * page_size;
> -    uint64_t next_size = mem_size - slot_size;
> -    uint64_t next_addr = mem_addr + slot_size;
> -    mem_slot slot(memmap, mem_addr, slot_size, mem_head);
> -    mem_slot other_slot(memmap, next_addr, next_size, (void *)next_addr);
> -
> -    // pre-allocate shadow pages
> -    do_guest_write(vcpu, mem_head, nr_total_pages, nr_total_pages);
> -    check_dirty_log(vcpu, slot, mem_head);
> -    return 0;
> -}
> -
> -int main(int ac, char** av)
> -{
> -    return try_main(test_main, ac, av);
> -}
> diff --git a/api/dirty-log.cc b/api/dirty-log.cc
> deleted file mode 100644
> index 9891e98..0000000
> --- a/api/dirty-log.cc
> +++ /dev/null
> @@ -1,84 +0,0 @@
> -#include "kvmxx.hh"
> -#include "exception.hh"
> -#include "memmap.hh"
> -#include "identity.hh"
> -#include <thread>
> -#include <stdlib.h>
> -#include <stdio.h>
> -
> -namespace {
> -
> -void delay_loop(unsigned n)
> -{
> -    for (unsigned i = 0; i < n; ++i) {
> -        asm volatile("pause");
> -    }
> - }
> -
> -void write_mem(volatile bool& running, volatile int* shared_var)
> -{
> -    while (running) {
> -        ++*shared_var;
> -        delay_loop(1000);
> -    }
> -}
> -
> -void check_dirty_log(mem_slot& slot,
> -                     volatile bool& running,
> -                     volatile int* shared_var,
> -                     int& nr_fail)
> -{
> -    uint64_t shared_var_gpa = reinterpret_cast<uint64_t>(shared_var);
> -    slot.set_dirty_logging(true);
> -    slot.update_dirty_log();
> -    for (int i = 0; i < 10000000; ++i) {
> -        int sample1 = *shared_var;
> -        delay_loop(600);
> -        int sample2 = *shared_var;
> -        slot.update_dirty_log();
> -        if (!slot.is_dirty(shared_var_gpa) && sample1 != sample2) {
> -            ++nr_fail;
> -        }
> -    }
> -    running = false;
> -    slot.set_dirty_logging(false);
> -}
> -
> -}
> -
> -int test_main(int ac, char **av)
> -{
> -    kvm::system sys;
> -    kvm::vm vm(sys);
> -    mem_map memmap(vm);
> -    void* logged_slot_virt;
> -    int ret = posix_memalign(&logged_slot_virt, 4096, 4096);
> -    if (ret) {
> -        throw errno_exception(ret);
> -    }
> -    volatile int* shared_var = static_cast<volatile int*>(logged_slot_virt);
> -    identity::hole hole(logged_slot_virt, 4096);
> -    identity::vm ident_vm(vm, memmap, hole);
> -    kvm::vcpu vcpu(vm, 0);
> -    bool running = true;
> -    int nr_fail = 0;
> -    mem_slot logged_slot(memmap,
> -                         reinterpret_cast<uintptr_t>(logged_slot_virt),
> -                         4096, logged_slot_virt);
> -    std::thread host_poll_thread(check_dirty_log, std::ref(logged_slot),
> -                                   std::ref(running),
> -                                   shared_var, std::ref(nr_fail));
> -    identity::vcpu guest_write_thread(vcpu,
> -                                      std::bind(write_mem,
> -					       	std::ref(running),
> -						shared_var));
> -    vcpu.run();
> -    host_poll_thread.join();
> -    printf("Dirty bitmap failures: %d\n", nr_fail);
> -    return nr_fail == 0 ? 0 : 1;
> -}
> -
> -int main(int ac, char** av)
> -{
> -    return try_main(test_main, ac, av);
> -}
> diff --git a/api/exception.cc b/api/exception.cc
> deleted file mode 100644
> index 910bdff..0000000
> --- a/api/exception.cc
> +++ /dev/null
> @@ -1,33 +0,0 @@
> -#include "exception.hh"
> -#include <cstdio>
> -#include <cstring>
> -
> -errno_exception::errno_exception(int errno)
> -    : _errno(errno)
> -{
> -}
> -
> -int errno_exception::errno() const
> -{
> -    return _errno;
> -}
> -
> -const char *errno_exception::what()
> -{
> -    std::snprintf(_buf, sizeof _buf, "error: %s (%d)",
> -		  std::strerror(_errno), _errno);
> -    return _buf;
> -}
> -
> -int try_main(int (*main)(int argc, char** argv), int argc, char** argv,
> -	     int ret_on_exception)
> -{
> -    try {
> -        return main(argc, argv);
> -    } catch (std::exception& e) {
> -        std::fprintf(stderr, "exception: %s\n", e.what());
> -    } catch (...) {
> -        std::fprintf(stderr, "unknown exception\n");
> -    }
> -    return ret_on_exception;
> -}
> diff --git a/api/exception.hh b/api/exception.hh
> deleted file mode 100644
> index f78d9a1..0000000
> --- a/api/exception.hh
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -#ifndef EXCEPTION_HH
> -#define EXCEPTION_HH
> -
> -#include <exception>
> -
> -class errno_exception : public std::exception {
> -public:
> -    explicit errno_exception(int err_no);
> -    int errno() const;
> -    virtual const char *what();
> -private:
> -    int _errno;
> -    char _buf[1000];
> -};
> -
> -int try_main(int (*main)(int argc, char** argv), int argc, char** argv,
> -	     int ret_on_exception = 127);
> -
> -#endif
> diff --git a/api/identity.cc b/api/identity.cc
> deleted file mode 100644
> index 24609ef..0000000
> --- a/api/identity.cc
> +++ /dev/null
> @@ -1,120 +0,0 @@
> -
> -#include "identity.hh"
> -#include "exception.hh"
> -#include <stdlib.h>
> -#include <stdio.h>
> -
> -namespace identity {
> -
> -typedef unsigned long ulong;
> -
> -hole::hole()
> -    : address(), size()
> -{
> -}
> -
> -hole::hole(void* address, size_t size)
> -    : address(address), size(size)
> -{
> -}
> -
> -vm::vm(kvm::vm& vm, mem_map& mmap, hole h)
> -{
> -    int ret = posix_memalign(&tss, 4096, 4 * 4096);
> -    if (ret) {
> -        throw errno_exception(ret);
> -    }
> -
> -    uint64_t hole_gpa = reinterpret_cast<uintptr_t>(h.address);
> -    char* hole_hva = static_cast<char*>(h.address);
> -    uint64_t tss_addr = reinterpret_cast<uintptr_t>(tss);
> -    uint64_t tss_end = tss_addr + 4 * 4096;
> -    uint64_t hole_end = hole_gpa + h.size;
> -
> -    if (hole_gpa < tss_addr) {
> -        if (hole_gpa) {
> -            _slots.push_back(mem_slot_ptr(new mem_slot(mmap, 0, hole_gpa, NULL)));
> -        }
> -        _slots.push_back(mem_slot_ptr(new mem_slot(mmap, hole_end, tss_addr - hole_end,
> -						   hole_hva + h.size)));
> -        _slots.push_back(mem_slot_ptr(new mem_slot(mmap, tss_end, (uint32_t)-tss_end,
> -						   (char*)tss + 4 * 4096)));
> -    } else {
> -        _slots.push_back(mem_slot_ptr(new mem_slot(mmap, 0, tss_addr, NULL)));
> -        _slots.push_back(mem_slot_ptr(new mem_slot(mmap, tss_end, hole_gpa - tss_end,
> -						   (char*)tss + 4 * 4096)));
> -        _slots.push_back(mem_slot_ptr(new mem_slot(mmap, hole_end, (uint32_t)-hole_end,
> -						   hole_hva + h.size)));
> -    }
> -
> -    vm.set_tss_addr(tss_addr);
> -    vm.set_ept_identity_map_addr(tss_addr + 3 * 4096);
> -}
> -
> -vm::~vm()
> -{
> -    free(tss);
> -}
> -
> -void vcpu::setup_sregs()
> -{
> -    kvm_sregs sregs = { };
> -    kvm_segment dseg = { };
> -    dseg.base = 0; dseg.limit = -1U; dseg.type = 3; dseg.present = 1;
> -    dseg.dpl = 3; dseg.db = 1; dseg.s = 1; dseg.l = 0; dseg.g = 1;
> -    kvm_segment cseg = dseg;
> -    cseg.type = 11;
> -
> -    sregs.cs = cseg; asm ("mov %%cs, %0" : "=rm"(sregs.cs.selector));
> -    sregs.ds = dseg; asm ("mov %%ds, %0" : "=rm"(sregs.ds.selector));
> -    sregs.es = dseg; asm ("mov %%es, %0" : "=rm"(sregs.es.selector));
> -    sregs.fs = dseg; asm ("mov %%fs, %0" : "=rm"(sregs.fs.selector));
> -    sregs.gs = dseg; asm ("mov %%gs, %0" : "=rm"(sregs.gs.selector));
> -    sregs.ss = dseg; asm ("mov %%ss, %0" : "=rm"(sregs.ss.selector));
> -
> -    uint32_t gsbase;
> -    asm ("mov %%gs:0, %0" : "=r"(gsbase));
> -    sregs.gs.base = gsbase;
> -
> -    sregs.tr.base = reinterpret_cast<uintptr_t>(&*_stack.begin());
> -    sregs.tr.type = 11;
> -    sregs.tr.s = 0;
> -    sregs.tr.present = 1;
> -
> -    sregs.cr0 = 0x11; /* PE, ET, !PG */
> -    sregs.cr4 = 0;
> -    sregs.efer = 0;
> -    sregs.apic_base = 0xfee00000;
> -    _vcpu.set_sregs(sregs);
> -}
> -
> -void vcpu::thunk(vcpu* zis)
> -{
> -    zis->_guest_func();
> -    asm volatile("outb %%al, %%dx" : : "a"(0), "d"(0));
> -}
> -
> -void vcpu::setup_regs()
> -{
> -    kvm_regs regs = {};
> -    regs.rflags = 0x3202;
> -    regs.rsp = reinterpret_cast<ulong>(&*_stack.end());
> -    regs.rsp &= ~15UL;
> -    ulong* sp = reinterpret_cast<ulong *>(regs.rsp);
> -    *--sp = reinterpret_cast<ulong>((char*)this);
> -    *--sp = 0;
> -    regs.rsp = reinterpret_cast<ulong>(sp);
> -    regs.rip = reinterpret_cast<ulong>(&vcpu::thunk);
> -    printf("rip %llx\n", regs.rip);
> -    _vcpu.set_regs(regs);
> -}
> -
> -vcpu::vcpu(kvm::vcpu& vcpu, std::function<void ()> guest_func,
> -           unsigned long stack_size)
> -    : _vcpu(vcpu), _guest_func(guest_func), _stack(stack_size)
> -{
> -    setup_sregs();
> -    setup_regs();
> -}
> -
> -}
> diff --git a/api/identity.hh b/api/identity.hh
> deleted file mode 100644
> index b95cb15..0000000
> --- a/api/identity.hh
> +++ /dev/null
> @@ -1,45 +0,0 @@
> -#ifndef API_IDENTITY_HH
> -#define API_IDENTITY_HH
> -
> -#include "kvmxx.hh"
> -#include "memmap.hh"
> -#include <functional>
> -#include <memory>
> -#include <vector>
> -
> -namespace identity {
> -
> -struct hole {
> -    hole();
> -    hole(void* address, size_t size);
> -    void* address;
> -    size_t size;
> -};
> -
> -class vm {
> -public:
> -    vm(kvm::vm& vm, mem_map& mmap, hole address_space_hole = hole());
> -    ~vm();
> -private:
> -    void *tss;
> -    typedef std::shared_ptr<mem_slot> mem_slot_ptr;
> -    std::vector<mem_slot_ptr> _slots;
> -};
> -
> -class vcpu {
> -public:
> -    vcpu(kvm::vcpu& vcpu, std::function<void ()> guest_func,
> -	 unsigned long stack_size = 256 * 1024);
> -private:
> -    static void thunk(vcpu* vcpu);
> -    void setup_regs();
> -    void setup_sregs();
> -private:
> -    kvm::vcpu& _vcpu;
> -    std::function<void ()> _guest_func;
> -    std::vector<char> _stack;
> -};
> -
> -}
> -
> -#endif
> diff --git a/api/kvmxx.cc b/api/kvmxx.cc
> deleted file mode 100644
> index 313902e..0000000
> --- a/api/kvmxx.cc
> +++ /dev/null
> @@ -1,199 +0,0 @@
> -#include "kvmxx.hh"
> -#include "exception.hh"
> -#include <fcntl.h>
> -#include <sys/ioctl.h>
> -#include <sys/mman.h>
> -#include <stdlib.h>
> -#include <memory>
> -#include <algorithm>
> -
> -namespace kvm {
> -
> -static long check_error(long r)
> -{
> -    if (r == -1) {
> -	throw errno_exception(errno);
> -    }
> -    return r;
> -}
> -
> -fd::fd(int fd)
> -    : _fd(fd)
> -{
> -}
> -
> -fd::fd(const fd& other)
> -    : _fd(::dup(other._fd))
> -{
> -    check_error(_fd);
> -}
> -
> -fd::fd(std::string device_node, int flags)
> -    : _fd(::open(device_node.c_str(), flags))
> -{
> -    check_error(_fd);
> -}
> -
> -long fd::ioctl(unsigned nr, long arg)
> -{
> -    return check_error(::ioctl(_fd, nr, arg));
> -}
> -
> -vcpu::vcpu(vm& vm, int id)
> -    : _vm(vm), _fd(vm._fd.ioctl(KVM_CREATE_VCPU, id)), _shared(NULL)
> -    , _mmap_size(_vm._system._fd.ioctl(KVM_GET_VCPU_MMAP_SIZE, 0))
> -
> -{
> -    kvm_run *shared = static_cast<kvm_run*>(::mmap(NULL, _mmap_size,
> -						   PROT_READ | PROT_WRITE,
> -						   MAP_SHARED,
> -						   _fd.get(), 0));
> -    if (shared == MAP_FAILED) {
> -	throw errno_exception(errno);
> -    }
> -    _shared = shared;
> -}
> -
> -vcpu::~vcpu()
> -{
> -    munmap(_shared, _mmap_size);
> -}
> -
> -void vcpu::run()
> -{
> -    _fd.ioctl(KVM_RUN, 0);
> -}
> -
> -kvm_regs vcpu::regs()
> -{
> -    kvm_regs regs;
> -    _fd.ioctlp(KVM_GET_REGS, &regs);
> -    return regs;
> -}
> -
> -void vcpu::set_regs(const kvm_regs& regs)
> -{
> -    _fd.ioctlp(KVM_SET_REGS, const_cast<kvm_regs*>(&regs));
> -}
> -
> -kvm_sregs vcpu::sregs()
> -{
> -    kvm_sregs sregs;
> -    _fd.ioctlp(KVM_GET_SREGS, &sregs);
> -    return sregs;
> -}
> -
> -void vcpu::set_sregs(const kvm_sregs& sregs)
> -{
> -    _fd.ioctlp(KVM_SET_SREGS, const_cast<kvm_sregs*>(&sregs));
> -}
> -
> -class vcpu::kvm_msrs_ptr {
> -public:
> -    explicit kvm_msrs_ptr(size_t nmsrs);
> -    ~kvm_msrs_ptr() { ::free(_kvm_msrs); }
> -    kvm_msrs* operator->() { return _kvm_msrs; }
> -    kvm_msrs* get() { return _kvm_msrs; }
> -private:
> -    kvm_msrs* _kvm_msrs;
> -};
> -
> -vcpu::kvm_msrs_ptr::kvm_msrs_ptr(size_t nmsrs)
> -    : _kvm_msrs(0)
> -{
> -    size_t size = sizeof(kvm_msrs) + sizeof(kvm_msr_entry) * nmsrs;
> -    _kvm_msrs = static_cast<kvm_msrs*>(::malloc(size));
> -    if (!_kvm_msrs) {
> -	throw std::bad_alloc();
> -    }
> -}
> -
> -std::vector<kvm_msr_entry> vcpu::msrs(std::vector<uint32_t> indices)
> -{
> -    kvm_msrs_ptr msrs(indices.size());
> -    msrs->nmsrs = indices.size();
> -    for (unsigned i = 0; i < msrs->nmsrs; ++i) {
> -	msrs->entries[i].index = indices[i];
> -    }
> -    _fd.ioctlp(KVM_GET_MSRS, msrs.get());
> -    return std::vector<kvm_msr_entry>(msrs->entries,
> -				      msrs->entries + msrs->nmsrs);
> -}
> -
> -void vcpu::set_msrs(const std::vector<kvm_msr_entry>& msrs)
> -{
> -    kvm_msrs_ptr _msrs(msrs.size());
> -    _msrs->nmsrs = msrs.size();
> -    std::copy(msrs.begin(), msrs.end(), _msrs->entries);
> -    _fd.ioctlp(KVM_SET_MSRS, _msrs.get());
> -}
> -
> -void vcpu::set_debug(uint64_t dr[8], bool enabled, bool singlestep)
> -{
> -    kvm_guest_debug gd;
> -
> -    gd.control = 0;
> -    if (enabled) {
> -	gd.control |= KVM_GUESTDBG_ENABLE;
> -    }
> -    if (singlestep) {
> -	gd.control |= KVM_GUESTDBG_SINGLESTEP;
> -    }
> -    for (int i = 0; i < 8; ++i) {
> -	gd.arch.debugreg[i] = dr[i];
> -    }
> -    _fd.ioctlp(KVM_SET_GUEST_DEBUG, &gd);
> -}
> -
> -vm::vm(system& system)
> -    : _system(system), _fd(system._fd.ioctl(KVM_CREATE_VM, 0))
> -{
> -}
> -
> -void vm::set_memory_region(int slot, void *addr, uint64_t gpa, size_t len,
> -                           uint32_t flags)
> -{
> -    struct kvm_userspace_memory_region umr;
> -
> -    umr.slot = slot;
> -    umr.flags = flags;
> -    umr.guest_phys_addr = gpa;
> -    umr.memory_size = len;
> -    umr.userspace_addr = reinterpret_cast<uintptr_t>(addr);
> -    _fd.ioctlp(KVM_SET_USER_MEMORY_REGION, &umr);
> -}
> -
> -void vm::get_dirty_log(int slot, void *log)
> -{
> -    struct kvm_dirty_log kdl;
> -    kdl.slot = slot;
> -    kdl.dirty_bitmap = log;
> -    _fd.ioctlp(KVM_GET_DIRTY_LOG, &kdl);
> -}
> -
> -void vm::set_tss_addr(uint32_t addr)
> -{
> -    _fd.ioctl(KVM_SET_TSS_ADDR, addr);
> -}
> -
> -void vm::set_ept_identity_map_addr(uint64_t addr)
> -{
> -    _fd.ioctlp(KVM_SET_IDENTITY_MAP_ADDR, &addr);
> -}
> -
> -system::system(std::string device_node)
> -    : _fd(device_node, O_RDWR)
> -{
> -}
> -
> -bool system::check_extension(int extension)
> -{
> -    return _fd.ioctl(KVM_CHECK_EXTENSION, extension);
> -}
> -
> -int system::get_extension_int(int extension)
> -{
> -    return _fd.ioctl(KVM_CHECK_EXTENSION, extension);
> -}
> -
> -};
> diff --git a/api/kvmxx.hh b/api/kvmxx.hh
> deleted file mode 100644
> index e39bd5b..0000000
> --- a/api/kvmxx.hh
> +++ /dev/null
> @@ -1,86 +0,0 @@
> -#ifndef KVMXX_H
> -#define KVMXX_H
> -
> -#include <string>
> -#include <signal.h>
> -#include <unistd.h>
> -#include <vector>
> -#include <errno.h>
> -#include <linux/kvm.h>
> -#include <stdint.h>
> -
> -namespace kvm {
> -
> -class system;
> -class vm;
> -class vcpu;
> -class fd;
> -
> -class fd {
> -public:
> -    explicit fd(int n);
> -    explicit fd(std::string path, int flags);
> -    fd(const fd& other);
> -    ~fd() { ::close(_fd); }
> -    int get() { return _fd; }
> -    long ioctl(unsigned nr, long arg);
> -    long ioctlp(unsigned nr, void *arg) {
> -	return ioctl(nr, reinterpret_cast<long>(arg));
> -    }
> -private:
> -    int _fd;
> -};
> -
> -class vcpu {
> -public:
> -    vcpu(vm& vm, int fd);
> -    ~vcpu();
> -    void run();
> -    kvm_run *shared();
> -    kvm_regs regs();
> -    void set_regs(const kvm_regs& regs);
> -    kvm_sregs sregs();
> -    void set_sregs(const kvm_sregs& sregs);
> -    std::vector<kvm_msr_entry> msrs(std::vector<uint32_t> indices);
> -    void set_msrs(const std::vector<kvm_msr_entry>& msrs);
> -    void set_debug(uint64_t dr[8], bool enabled, bool singlestep);
> -private:
> -    class kvm_msrs_ptr;
> -private:
> -    vm& _vm;
> -    fd _fd;
> -    kvm_run *_shared;
> -    unsigned _mmap_size;
> -    friend class vm;
> -};
> -
> -class vm {
> -public:
> -    explicit vm(system& system);
> -    void set_memory_region(int slot, void *addr, uint64_t gpa, size_t len,
> -                           uint32_t flags = 0);
> -    void get_dirty_log(int slot, void *log);
> -    void set_tss_addr(uint32_t addr);
> -    void set_ept_identity_map_addr(uint64_t addr);
> -    system& sys() { return _system; }
> -private:
> -    system& _system;
> -    fd _fd;
> -    friend class system;
> -    friend class vcpu;
> -};
> -
> -class system {
> -public:
> -    explicit system(std::string device_node = "/dev/kvm");
> -    bool check_extension(int extension);
> -    int get_extension_int(int extension);
> -private:
> -    fd _fd;
> -    friend class vcpu;
> -    friend class vm;
> -};
> -
> -};
> -
> -#endif
> diff --git a/api/memmap.cc b/api/memmap.cc
> deleted file mode 100644
> index cf44824..0000000
> --- a/api/memmap.cc
> +++ /dev/null
> @@ -1,96 +0,0 @@
> -
> -#include "memmap.hh"
> -#include <numeric>
> -
> -mem_slot::mem_slot(mem_map& map, uint64_t gpa, uint64_t size, void* hva)
> -    : _map(map)
> -    , _slot(map._free_slots.top())
> -    , _gpa(gpa)
> -    , _size(size)
> -    , _hva(hva)
> -    , _dirty_log_enabled(false)
> -    , _log()
> -{
> -    map._free_slots.pop();
> -    if (_size) {
> -        update();
> -    }
> -}
> -
> -mem_slot::~mem_slot()
> -{
> -    if (!_size) {
> -        return;
> -    }
> -    _size = 0;
> -    try {
> -        update();
> -        _map._free_slots.push(_slot);
> -    } catch (...) {
> -        // can't do much if we can't undo slot registration - leak the slot
> -    }
> -}
> -
> -void mem_slot::set_dirty_logging(bool enabled)
> -{
> -    if (_dirty_log_enabled != enabled) {
> -        _dirty_log_enabled = enabled;
> -        if (enabled) {
> -            int logsize = ((_size >> 12) + bits_per_word - 1) / bits_per_word;
> -            _log.resize(logsize);
> -        } else {
> -            _log.resize(0);
> -        }
> -        if (_size) {
> -            update();
> -        }
> -    }
> -}
> -
> -void mem_slot::update()
> -{
> -    uint32_t flags = 0;
> -    if (_dirty_log_enabled) {
> -        flags |= KVM_MEM_LOG_DIRTY_PAGES;
> -    }
> -    _map._vm.set_memory_region(_slot, _hva, _gpa, _size, flags);
> -}
> -
> -bool mem_slot::dirty_logging() const
> -{
> -    return _dirty_log_enabled;
> -}
> -
> -static inline int hweight(uint64_t w)
> -{
> -    w -= (w >> 1) & 0x5555555555555555;
> -    w =  (w & 0x3333333333333333) + ((w >> 2) & 0x3333333333333333);
> -    w =  (w + (w >> 4)) & 0x0f0f0f0f0f0f0f0f;
> -    return (w * 0x0101010101010101) >> 56;
> -}
> -
> -int mem_slot::update_dirty_log()
> -{
> -    _map._vm.get_dirty_log(_slot, &_log[0]);
> -    return std::accumulate(_log.begin(), _log.end(), 0,
> -                           [] (int prev, ulong elem) -> int {
> -                               return prev + hweight(elem);
> -                           });
> -}
> -
> -bool mem_slot::is_dirty(uint64_t gpa) const
> -{
> -    uint64_t pagenr = (gpa - _gpa) >> 12;
> -    ulong wordnr = pagenr / bits_per_word;
> -    ulong bit = 1ULL << (pagenr % bits_per_word);
> -    return _log[wordnr] & bit;
> -}
> -
> -mem_map::mem_map(kvm::vm& vm)
> -    : _vm(vm)
> -{
> -    int nr_slots = vm.sys().get_extension_int(KVM_CAP_NR_MEMSLOTS);
> -    for (int i = 0; i < nr_slots; ++i) {
> -        _free_slots.push(i);
> -    }
> -}
> diff --git a/api/memmap.hh b/api/memmap.hh
> deleted file mode 100644
> index 48711ae..0000000
> --- a/api/memmap.hh
> +++ /dev/null
> @@ -1,43 +0,0 @@
> -#ifndef MEMMAP_HH
> -#define MEMMAP_HH
> -
> -#include "kvmxx.hh"
> -#include <stdint.h>
> -#include <vector>
> -#include <stack>
> -
> -class mem_map;
> -class mem_slot;
> -
> -class mem_slot {
> -public:
> -    mem_slot(mem_map& map, uint64_t gpa, uint64_t size, void *hva);
> -    ~mem_slot();
> -    void set_dirty_logging(bool enabled);
> -    bool dirty_logging() const;
> -    int update_dirty_log();
> -    bool is_dirty(uint64_t gpa) const;
> -private:
> -    void update();
> -private:
> -    typedef unsigned long ulong;
> -    static const int bits_per_word = sizeof(ulong) * 8;
> -    mem_map& _map;
> -    int _slot;
> -    uint64_t _gpa;
> -    uint64_t _size;
> -    void *_hva;
> -    bool _dirty_log_enabled;
> -    std::vector<ulong> _log;
> -};
> -
> -class mem_map {
> -public:
> -    mem_map(kvm::vm& vm);
> -private:
> -    kvm::vm& _vm;
> -    std::stack<int> _free_slots;
> -    friend class mem_slot;
> -};
> -
> -#endif
> diff --git a/configure b/configure
> index e6b4ca1..5797651 100755
> --- a/configure
> +++ b/configure
> @@ -3,7 +3,6 @@
>  srcdir=$(cd "$(dirname "$0")"; pwd)
>  prefix=/usr/local
>  cc=gcc
> -cxx=g++
>  ld=ld
>  objcopy=objcopy
>  objdump=objdump
> @@ -30,7 +29,6 @@ usage() {
>  	                           or kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
>  	    --cc=CC		   c compiler to use ($cc)
> -	    --cxx=CXX		   c++ compiler to use ($cxx)
>  	    --ld=LD		   ld linker to use ($ld)
>  	    --prefix=PREFIX        where to install things ($prefix)
>  	    --endian=ENDIAN        endianness to compile for (little or big, ppc64 only)
> @@ -72,9 +70,6 @@ while [[ "$1" = -* ]]; do
>  	--cc)
>  	    cc="$arg"
>  	    ;;
> -	--cxx)
> -	    cxx="$arg"
> -	    ;;
>  	--ld)
>  	    ld="$arg"
>  	    ;;
> @@ -149,16 +144,6 @@ EOF
>  u32_long=$("$cross_prefix$cc" -E lib-test.c | grep -v '^#' | grep -q long && echo yes)
>  rm -f lib-test.c
>  
> -# api/: check for dependent 32 bit libraries and gnu++11 support
> -if [ "$testdir" = "x86" ]; then
> -    echo 'int main () {}' > lib-test.c
> -    if $cc -m32 -o /dev/null -lstdc++ -lpthread -lrt lib-test.c &> /dev/null &&
> -       $cxx -m32 -o /dev/null -std=gnu++11 lib-test.c &> /dev/null; then
> -        api=yes
> -    fi
> -    rm -f lib-test.c
> -fi
> -
>  # Are we in a separate build tree? If so, link the Makefile
>  # and shared stuff so that 'make' and run_tests.sh work.
>  if test ! -e Makefile; then
> @@ -199,13 +184,11 @@ ARCH=$arch
>  ARCH_NAME=$arch_name
>  PROCESSOR=$processor
>  CC=$cross_prefix$cc
> -CXX=$cross_prefix$cxx
>  LD=$cross_prefix$ld
>  OBJCOPY=$cross_prefix$objcopy
>  OBJDUMP=$cross_prefix$objdump
>  AR=$cross_prefix$ar
>  ADDR2LINE=$cross_prefix$addr2line
> -API=$api
>  TEST_DIR=$testdir
>  FIRMWARE=$firmware
>  ENDIAN=$endian
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index b157154..ab67ca0 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -60,13 +60,7 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
>                 $(TEST_DIR)/hyperv_connections.flat \
>                 $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
>  
> -ifdef API
> -tests-api = api/api-sample api/dirty-log api/dirty-log-perf
> -
> -OBJDIRS += api
> -endif
> -
> -test_cases: $(tests-common) $(tests) $(tests-api)
> +test_cases: $(tests-common) $(tests)
>  
>  $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
>  
> @@ -86,14 +80,3 @@ $(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
>  arch_clean:
>  	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
>  	$(TEST_DIR)/.*.d lib/x86/.*.d \
> -	$(tests-api) api/*.o api/*.a api/.*.d
> -
> -api/%.o: CXXFLAGS += -m32 -std=gnu++11
> -
> -api/%: LDLIBS += -lstdc++ -lpthread -lrt
> -api/%: LDFLAGS += -m32
> -
> -api/libapi.a: api/kvmxx.o api/identity.o api/exception.o api/memmap.o
> -	$(AR) rcs $@ $^
> -
> -$(tests-api) : % : %.o api/libapi.a
> 

Queued, thanks.

Paolo

