Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6937AC3C
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhEKQoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:44:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhEKQol (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620751414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CrGA+D+8f54f1+nxV7IrzOSl9kjMbEITXdJTmR0d2xM=;
        b=PNkQ2RQdRaUFmnTQx2kzanNKWQ/D5Ade0lhEGmUljq594HAmEbkZ13lbLbc+MBdgPZr5Z3
        IhYNYhn3kNK4Mn/XZJbkWziqnH+rTtAMBikzulhIHsKRKWT2dppvdREvlebOhH7+gIunB3
        sGw5fU5k57G0ik4goW/GswnwUtOb4Zs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-WM8h6GpaPCWV_lWvzlzJVA-1; Tue, 11 May 2021 12:43:33 -0400
X-MC-Unique: WM8h6GpaPCWV_lWvzlzJVA-1
Received: by mail-ed1-f71.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so11256335edd.2
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:43:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CrGA+D+8f54f1+nxV7IrzOSl9kjMbEITXdJTmR0d2xM=;
        b=s0s5kqWW8T2I4pj8bge3pbN/7griuM3O7UmzAYJ2NN2AeWQk62YF8uchgk7ZYdbA+R
         SmZv9fuIAQ/JFwsKXhV93cD15X+PdPUh5YT35ve/UuALkUmiyXvoYqhkIyQJShYXejbG
         DAsdrupdeLd3+kmCZjvXAVnKevYsebK0iV4kT9/nrd7N+TMkvFxOF5Gwcj/au7aD9byr
         Z3l1XPXT7I5fEszBYjYPApOpBimbvohF8RJmsueLc40ZUC+34I5YCynGSyXt+aoFobzv
         L/jDte4mRtXkaxEfNUDjpMhb/dId6j2xPxoMFVK/3eVHJBx5GEybj0XBoFB6kBzf7KZ/
         25FA==
X-Gm-Message-State: AOAM533XwORDWDQ+iUUjDH6+/n9yFX+Pk1+n/yXGXY2UuwY6kwXoNNXM
        jDClN/TbQFL4VLXpuIo4p5Ynzn9LtiWbDkqnbm8ZXFZRsUSal/2dPum4V4Y7QXgjU1lrvNsMrj+
        KVz397Egfqhpt
X-Received: by 2002:a17:907:3f08:: with SMTP id hq8mr32471616ejc.240.1620751411571;
        Tue, 11 May 2021 09:43:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7LEBazZuNjjeyOKzf6kpQzUc1ilpWqgIgbuK6Aon1KOjeokHhMN6rG5rWq4MOW+24fVtixw==
X-Received: by 2002:a17:907:3f08:: with SMTP id hq8mr32471595ejc.240.1620751411318;
        Tue, 11 May 2021 09:43:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d24sm15028690edp.31.2021.05.11.09.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 09:43:18 -0700 (PDT)
Subject: Re: [kvm-unit-tests BUG] lib/ldiv32.c breaks arm compilation
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
References: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <604b1638-452f-e8e3-b674-014d634e2767@redhat.com>
Date:   Tue, 11 May 2021 18:43:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/21 17:43, Alexandru Elisei wrote:
> Hello,
> 
> Commit 0b2d3dafc0d3 ("libcflat: provide long division routines"), which added the
> lib/ldiv32.c file, breaks compilation for the arm architecture; arm64 seems to be
> working just fine.

The Fedora one is fixed in the commit immediately after, which replaces 
inttypes.h with stdint.h.

For Arch Linux I'm not sure what the compiler is complaining about 
(especially since there are no options such as -fno-null-pointer-checks) 
but perhaps we can just initialize rem to 0?  Any chance you can check 
if that affects the assembly output?  (It shouldn't).

Paolo

> On Arch Linux:
> 
> $ ./configure --arch=arm --cross-prefix=arm-none-eabi-
> $ make clean && make
> rm -f lib/arm/asm-offsets.h lib/arm/asm-offsets.s \
>        lib/generated/asm-offsets.h
> rm -f arm/*.{o,flat,elf} lib/arm/libeabi.a lib/arm/eabi_compat.o \
>        arm/.*.d lib/arm/.*.d
>    CLEAN (libfdt)
> rm -f lib/libfdt/*.o lib/libfdt/.*.d
> rm -f lib/libfdt/libfdt.so.1
> rm -f lib/libfdt/libfdt.a
> rm -f lib/.*.d lib/libcflat.a lib/argv.o lib/printf.o lib/string.o lib/abort.o
> lib/report.o lib/stack.o lib/arm/spinlock.o lib/arm/processor.o lib/arm/stack.o
> lib/ldiv32.o lib/util.o lib/getchar.o lib/alloc_phys.o lib/alloc_page.o
> lib/vmalloc.o lib/alloc.o lib/devicetree.o lib/pci.o lib/pci-host-generic.o
> lib/pci-testdev.o lib/virtio.o lib/virtio-mmio.o lib/chr-testdev.o lib/arm/io.o
> lib/arm/setup.o lib/arm/mmu.o lib/arm/bitops.o lib/arm/psci.o lib/arm/smp.o
> lib/arm/delay.o lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
> [..]
> arm-none-eabi-gcc -marm -mfpu=vfp -mcpu=cortex-a15 -mno-unaligned-access
> -std=gnu99 -ffreestanding -O2 -I /home/alex/data/repos/kvm-unit-tests/lib -I
> /home/alex/data/repos/kvm-unit-tests/lib/libfdt -I lib -g -MMD -MF lib/.ldiv32.d
> -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body
> -Wuninitialized -Wignored-qualifiers -Werror  -fno-omit-frame-pointer
> -fno-stack-protector    -Wno-frame-address -D__U32_LONG_FMT__  -fno-pic  -no-pie
> -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type
> -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> -c -o lib/ldiv32.o lib/ldiv32.c
> lib/ldiv32.c: In function '__moddi3':
> lib/ldiv32.c:73:11: error: 'rem' may be used uninitialized in this function
> [-Werror=maybe-uninitialized]
>     73 |  uint64_t rem;
>        |           ^~~
> lib/ldiv32.c: In function '__umoddi3':
> lib/ldiv32.c:75:9: error: 'rem' may be used uninitialized in this function
> [-Werror=maybe-uninitialized]
>     75 |  return rem;
>        |         ^~~
> cc1: all warnings being treated as errors
> make: *** [<builtin>: lib/ldiv32.o] Error 1
> $ arm-none-eabi-gcc --version
> arm-none-eabi-gcc (Arch Repository) 10.3.0
> Copyright (C) 2020 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> On Fedora 33:
> 
> $ ./configure --arch=arm --cross-prefix=arm-linux-gnu-
> $ make clean && make
> rm -f lib/arm/asm-offsets.h lib/arm/asm-offsets.s \
>        lib/generated/asm-offsets.h
> rm -f arm/*.{o,flat,elf} lib/arm/libeabi.a lib/arm/eabi_compat.o \
>        arm/.*.d lib/arm/.*.d
>    CLEAN (libfdt)
> rm -f lib/libfdt/*.o lib/libfdt/.*.d
> rm -f lib/libfdt/libfdt.so.1
> rm -f lib/libfdt/libfdt.a
> rm -f lib/.*.d lib/libcflat.a lib/argv.o lib/printf.o lib/string.o lib/abort.o
> lib/report.o lib/stack.o lib/arm/spinlock.o lib/arm/processor.o lib/arm/stack.o
> lib/ldiv32.o lib/util.o lib/getchar.o lib/alloc_phys.o lib/alloc_page.o
> lib/vmalloc.o lib/alloc.o lib/devicetree.o lib/pci.o lib/pci-host-generic.o
> lib/pci-testdev.o lib/virtio.o lib/virtio-mmio.o lib/chr-testdev.o lib/arm/io.o
> lib/arm/setup.o lib/arm/mmu.o lib/arm/bitops.o lib/arm/psci.o lib/arm/smp.o
> lib/arm/delay.o lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
> [..]
> arm-linux-gnu-gcc -marm -mfpu=vfp -mcpu=cortex-a15 -mno-unaligned-access
> -std=gnu99 -ffreestanding -O2 -I /home/alex/data/repos/kvm-unit-tests/lib -I
> /home/alex/data/repos/kvm-unit-tests/lib/libfdt -I lib -g -MMD -MF lib/.ldiv32.d
> -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body
> -Wuninitialized -Wignored-qualifiers -Werror  -fno-omit-frame-pointer
> -fno-stack-protector    -Wno-frame-address   -fno-pic  -no-pie  -Wclobbered
> -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration
> -Woverride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o lib/ldiv32.o
> lib/ldiv32.c
> lib/ldiv32.c:1:10: fatal error: inttypes.h: No such file or directory
>      1 | #include <inttypes.h>
>        |          ^~~~~~~~~~~~
> compilation terminated.
> make: *** [<builtin>: lib/ldiv32.o] Error 1
> $ arm-linux-gnu-gcc --version
> arm-linux-gnu-gcc (GCC) 10.2.1 20200826 (Red Hat Cross 10.2.1-3)
> Copyright (C) 2020 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> Reverting the commit makes arm build again. I am not familiar with toolchains, and
> unfortunately I can't propose a fix.
> 
> Thanks,
> 
> Alex
> 

