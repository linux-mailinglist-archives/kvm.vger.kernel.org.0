Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5F1A1031
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 17:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgDGP3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 11:29:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27690 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728306AbgDGP3F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 11:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586273343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWUgiHbWY/VnfopGlKJ1NN6MztUwrlxf5LJ/Y6VfBgk=;
        b=Sa6UUEE3aSK2KtPpLKJDGD2G/ZfV/Hs1ndotHKbPUCA5N4g0ugZDUhplBSdXz6XaiolsEw
        +/02Y8Cmj2IKPNWihg0rz5AF4O+ClMzVnxaEwr+i6CkpqUljGuWd/ZAqooSLzBqI4kVPbV
        sRNFdhjnUE1tyfAxux0a2V9Wu6nysmc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-mlFKJepnNdepCADdFH7RTw-1; Tue, 07 Apr 2020 11:29:00 -0400
X-MC-Unique: mlFKJepnNdepCADdFH7RTw-1
Received: by mail-wm1-f71.google.com with SMTP id u6so1037772wmm.6
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 08:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gWUgiHbWY/VnfopGlKJ1NN6MztUwrlxf5LJ/Y6VfBgk=;
        b=k4m2WBEZd1F09ixTCBqqenxLd5g3+tWwGjpOuFgkW4piZr1uWkUYE8xakbFwzNYflH
         tKD6g3QyRMMrKGSJ2EPbvqvu2YZR2HtQQysZGNqmsTwkMuQN122pz9NQ/zlV7zemKpCn
         SUuwBStrMhYqRz5gCGdvs5zefPZR+oTfTzq/cHAxwnvZiZOQCg/S7BK0heDNfORvYTNi
         1oTgghzb5IerTt7wDUxSKmpTxYnNR4Y6vRdrz+9j5Gs0rBqhMCfTWoLjLPPafkc1nU7c
         6m8H20ZfWj9KNCG5IJEI7QVGRDy77HZZivop3YOmTJiDZAq44mFxe4RxjvaLT/IVMVNP
         cCOQ==
X-Gm-Message-State: AGi0PuaICiRkvOeHNYb84u1MLSnP93FuOm53EeFwTPOYtalyiAnvpQg8
        mgEFw95I9gLiiwL3Ndpw521UMLFEbkL9JBIVyaMU6wq8vUO68tFFjjuc9KEcVyVUhA5TefpNFfa
        sl45StlgpDpeO
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr3021906wmm.171.1586273339156;
        Tue, 07 Apr 2020 08:28:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ6y8t8M3s1o6shGbsX5ew9e/lrfMaPAL2jkphzu7vRXsUNpkEsjGyjrf4I5PbpdhL9PhsXFQ==
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr3021882wmm.171.1586273338848;
        Tue, 07 Apr 2020 08:28:58 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v9sm21292630wrv.18.2020.04.07.08.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:28:58 -0700 (PDT)
Subject: Re: [PULL kvm-unit-tests 00/39] arm/arm64: The old and new
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200404143731.208138-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bbee7fe4-56c2-f958-cddc-18b92d8e4380@redhat.com>
Date:   Tue, 7 Apr 2020 17:28:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/20 16:36, Andrew Jones wrote:
> Hi Paolo,
> 
> This pull request is a repost of an older request, plus it
> contains Eric's new PMU and ITS tests.
> 
> Thanks,
> drew
> 
> 
> The following changes since commit ce27fa2c7cd4d07859a9a2e81c7ff641897818d1:
> 
>   x86: vmx: skip atomic_switch_overflow_msrs_test on bare metal (2020-03-31 13:01:41 -0400)
> 
> are available in the Git repository at:
> 
>   https://github.com/rhdrjones/kvm-unit-tests arm/queue
> 
> for you to fetch changes up to de582149c5be94a1ff7d3d8ee3526501b26c7f03:
> 
>   arm/arm64: ITS: pending table migration test (2020-04-04 10:03:44 +0200)
> 
> ----------------------------------------------------------------
> Alexandru Elisei (10):
>       Makefile: Use no-stack-protector compiler options
>       arm/arm64: psci: Don't run C code without stack or vectors
>       arm64: timer: Add ISB after register writes
>       arm64: timer: Add ISB before reading the counter value
>       arm64: timer: Make irq_received volatile
>       arm64: timer: EOIR the interrupt after masking the timer
>       arm64: timer: Wait for the GIC to sample timer interrupt state
>       arm64: timer: Check the timer interrupt state
>       arm64: timer: Test behavior when timer disabled or masked
>       arm/arm64: Perform dcache clean + invalidate after turning MMU off
> 
> Andrew Jones (2):
>       arm64: timer: Speed up gic-timer-state check
>       arm64: Provide read/write_sysreg_s
> 
> Eric Auger (24):
>       arm: pmu: Let pmu tests take a sub-test parameter
>       arm: pmu: Don't check PMCR.IMP anymore
>       arm: pmu: Add a pmu struct
>       arm: pmu: Introduce defines for PMU versions
>       arm: pmu: Check Required Event Support
>       arm: pmu: Basic event counter Tests
>       arm: pmu: Test SW_INCR event count
>       arm: pmu: Test chained counters
>       arm: pmu: test 32-bit <-> 64-bit transitions
>       arm: gic: Introduce gic_irq_set_clr_enable() helper
>       arm: pmu: Test overflow interrupts
>       libcflat: Add other size defines
>       page_alloc: Introduce get_order()
>       arm/arm64: gic: Introduce setup_irq() helper
>       arm/arm64: gicv3: Add some re-distributor defines
>       arm/arm64: gicv3: Set the LPI config and pending tables
>       arm/arm64: ITS: Introspection tests
>       arm/arm64: ITS: its_enable_defaults
>       arm/arm64: ITS: Device and collection Initialization
>       arm/arm64: ITS: Commands
>       arm/arm64: ITS: INT functional tests
>       arm/run: Allow Migration tests
>       arm/arm64: ITS: migration tests
>       arm/arm64: ITS: pending table migration test
> 
> Zenghui Yu (3):
>       arm/arm64: gic: Move gic_state enumeration to asm/gic.h
>       arm64: timer: Use the proper RDist register name in GICv3
>       arm64: timer: Use existing helpers to access counter/timers
> 
>  Makefile                   |   4 +-
>  arm/Makefile.arm64         |   1 +
>  arm/Makefile.common        |   2 +-
>  arm/cstart.S               |  22 ++
>  arm/cstart64.S             |  23 ++
>  arm/gic.c                  | 482 ++++++++++++++++++++++++--
>  arm/pmu.c                  | 831 +++++++++++++++++++++++++++++++++++++++++++--
>  arm/psci.c                 |  14 +-
>  arm/run                    |   2 +-
>  arm/timer.c                |  82 +++--
>  arm/unittests.cfg          | 101 +++++-
>  errata.txt                 |   1 +
>  lib/alloc_page.c           |   7 +-
>  lib/alloc_page.h           |   1 +
>  lib/arm/asm/gic-v3-its.h   |  27 ++
>  lib/arm/asm/gic-v3.h       |  33 ++
>  lib/arm/asm/gic.h          |  13 +
>  lib/arm/asm/processor.h    |  15 +
>  lib/arm/gic-v3.c           |  78 +++++
>  lib/arm/gic.c              | 116 ++++++-
>  lib/arm/io.c               |  28 ++
>  lib/arm/setup.c            |   8 +
>  lib/arm64/asm/gic-v3-its.h | 174 ++++++++++
>  lib/arm64/asm/processor.h  |  12 +
>  lib/arm64/asm/sysreg.h     |  17 +
>  lib/arm64/gic-v3-its-cmd.c | 459 +++++++++++++++++++++++++
>  lib/arm64/gic-v3-its.c     | 171 ++++++++++
>  lib/bitops.h               |   3 +
>  lib/libcflat.h             |   3 +
>  29 files changed, 2635 insertions(+), 95 deletions(-)
>  create mode 100644 lib/arm/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/gic-v3-its-cmd.c
>  create mode 100644 lib/arm64/gic-v3-its.c
> 

Pulled, thanks.

Paolo

