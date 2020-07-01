Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BB1210981
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 12:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgGAKhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 06:37:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27947 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729927AbgGAKhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 06:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593599836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XfRM4oyQbh0X6OuyTT0VCNaVySIRjFMGGxEwC/fngnM=;
        b=QLCnsevdMNIyAAabl2A2x2IQKPFL7DXwNcWyGV0DujVoZ95Q1BPl8bibN7pXGh2e2ytyXZ
        3RdsNvpkxK9pCyMVhl/MV3vJFcgYCq2WnKSbeq2Q86usqX/lzodfXn//lxpoYRowSj87lA
        iitIkZCBovatulsQTvmo98wgaDWWYEY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-3T26A0K5MNKO_5FwAFO_tQ-1; Wed, 01 Jul 2020 06:37:13 -0400
X-MC-Unique: 3T26A0K5MNKO_5FwAFO_tQ-1
Received: by mail-ej1-f69.google.com with SMTP id d16so7674945eje.20
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 03:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XfRM4oyQbh0X6OuyTT0VCNaVySIRjFMGGxEwC/fngnM=;
        b=CG1xt7xAbPocBGH9qCgkrL/tlRemt7bx7olZpRrAL0oRsBkRK6QFSvJUiW3HEr6A20
         q1B9Q2eKewOyb/DvP4VMp5blRmJCcT9yD4hy9NFujwYAEc4xKdhsrYy1XzA2X0e4b2UG
         lLAeiy4O2tIchnVkydMRcDQokLe5MXbOPb+S6EMgoG7HVECbOTE4znp/GFcKs1VOoK7W
         EQBibUWLdwoBTSf+gzFr14+Qd7BJJ4DdeYBMRpkfn3slL0s9WnfqNaBGBvudUtYjBTVb
         7vMsDRot4t6uW6DOCVbtKGafyEHPVg+PqOq24oKyxh7WdGBM+3oRZ++P3wWPlRl54nnH
         oSIw==
X-Gm-Message-State: AOAM531No5UjTmMoRvzWnaHkTVg27zPC/iD8FI6uYVhEmzJDNaSdffn+
        XZjPWLGC2JpNorLVZaoTFPwYWORXjZyrXIBj9DSorHM0Q1g8J7w+YshrLjW2zIMVHBxy7JLksP1
        E1IO4hdhRi477
X-Received: by 2002:a17:906:7253:: with SMTP id n19mr23088502ejk.31.1593599831765;
        Wed, 01 Jul 2020 03:37:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNPBbbBZdD2Bwfu/Fm5l/3lhBupgHW1zMoHZBvi8gMW/1oM9o80Yo9NOapPKdoJdrvSvZ2aQ==
X-Received: by 2002:a17:906:7253:: with SMTP id n19mr23088491ejk.31.1593599831540;
        Wed, 01 Jul 2020 03:37:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1142:70d6:6b9b:3cd1? ([2001:b07:6468:f312:1142:70d6:6b9b:3cd1])
        by smtp.gmail.com with ESMTPSA id h10sm2255823edz.31.2020.07.01.03.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 03:37:11 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Extend the lists of tests
 that we run with TCG
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200701100615.7975-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <38846a44-2e55-4c5f-5846-d4bca6eda8ee@redhat.com>
Date:   Wed, 1 Jul 2020 12:37:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200701100615.7975-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/20 12:06, Thomas Huth wrote:
> Thank to the recent fixes, there are now quite a lot of additional 32-bit
> x86 tests that we can run in the CI.
> And thanks to the update to Fedora 32 (that introduced a newer version of
> QEMU), there are now also some additional tests that we can run with TCG
> for the other architectures.
> Note that for arm/aarch64, we now also set the MAX_SMP to be able to run
> SMP-tests with TCG in the single-threaded CI containers, too.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Note: taskswitch2 for 32-bit x86 is still broken, and thus has not been
>  added back again. It used to work with F30 ... maybe it's a QEMU regression?

It's on my todo list to check.  One thing (sorry about the constant
nitpicking), should tests be listed one per line so that it's clearer
when we add them?

But anyway I'm queuing this patch.

Paolo

>  .gitlab-ci.yml | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 3af53f0..d042cde 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -9,9 +9,10 @@ build-aarch64:
>   - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu
>   - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
>   - make -j2
> - - ACCEL=tcg ./run_tests.sh
> + - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
>       selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
> -     pci-test pmu gicv2-active gicv3-active psci timer
> +     pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr gicv2-ipi
> +     gicv2-mmio gicv3-ipi gicv2-active gicv3-active psci timer cache
>       | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
> @@ -20,9 +21,10 @@ build-arm:
>   - dnf install -y qemu-system-arm gcc-arm-linux-gnu
>   - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
>   - make -j2
> - - ACCEL=tcg ./run_tests.sh
> + - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
>       selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
> -     pci-test pmu gicv2-active gicv3-active psci
> +     pci-test pmu-cycle-counter gicv2-ipi gicv2-mmio gicv3-ipi gicv2-active
> +     gicv3-active psci
>       | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
> @@ -54,7 +56,8 @@ build-s390x:
>   - ./configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     selftest-setup intercept emulator sieve diag10
> +     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
> +     stsi sclp-1g sclp-3g
>       | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
> @@ -64,10 +67,10 @@ build-x86_64:
>   - ./configure --arch=x86_64
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
> +     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
>       vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
>       vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
> -     eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
> +     eventinj msr port80 setjmp sieve syscall tsc rmap_chain umip intel_iommu
>       | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
> @@ -77,7 +80,10 @@ build-i386:
>   - ./configure --arch=i386
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     cmpxchg8b eventinj port80 setjmp sieve tsc taskswitch umip
> +     cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
> +     vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt vmexit_ple_round_robin
> +     vmexit_tscdeadline vmexit_tscdeadline_immed eventinj port80 setjmp sieve
> +     tsc taskswitch umip
>       | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
> @@ -87,7 +93,7 @@ build-clang:
>   - ./configure --arch=x86_64 --cc=clang
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
> +     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
>       vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
>       vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
>       eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
> 

