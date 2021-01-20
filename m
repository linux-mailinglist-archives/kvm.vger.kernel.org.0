Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD72FD0CB
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbhATMwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390014AbhATMnW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611146515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+enVPPXnD3JV2eqAnDU93EX7gphRdJeeaNmJzhhKeA=;
        b=JbJHZEeEw/fjFhvObbvW8uUZ35ZZT47/D8d7Bc0LSh2fhVl70ieaj3eXRNLBAbbNHNRLcV
        dKEx810uazxtjt/YYLYmQF8CPTM+apvhynuJihhkrys6jFxg7170rY91QoJixRK7fsiw26
        bFl6HtQleV9iJa6jqeGU8BgGPfJWRgc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-NH3gbsjmNviH-grGsiMXvQ-1; Wed, 20 Jan 2021 07:41:54 -0500
X-MC-Unique: NH3gbsjmNviH-grGsiMXvQ-1
Received: by mail-ed1-f69.google.com with SMTP id u17so11060682edi.18
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 04:41:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R+enVPPXnD3JV2eqAnDU93EX7gphRdJeeaNmJzhhKeA=;
        b=K96Q74Ag/RRjS+ulISDGokfWVS4RPeIhRrGTBOxiWCwxB7Muny8y99beU+hJioKbI1
         BEa1yyBVr1zOfreroccPvF4v4qjRmmR1/9dTjtyPROlgGwPQzVWYWmggrQcUy/A1jcFM
         xgE+VcPp6UbeK7oOROUsTVuCf5nkUEQ+kJ89JNnoL8XIA0LkQR5uWRM2k2tcrx8nJeuo
         up+P2HtcmrttEkEenh0zK7dkUBFRGoFTqXnzvM1Jk12JNXgF2AGrhaj+oU49EZitruKi
         /WCR5x+HdEbS4wWaGyHBTFBngcZ/MBKeh/Miu4tHGBXwYPKWD+JbAL/VRWAaxuiJylMP
         aQnw==
X-Gm-Message-State: AOAM533B+wGm4myRmQJUWrZl7TIFHEXW4BR55r6Xv5gWEXAs8HsrAeTO
        3BgxGSIYIvcyBDlcq1aIdCeKD96qZ2cpjg2g+QoR9SiQW0iB07zTKWfIcTbKEO4p9zREnmbvvVi
        ULARXZdfkq0R4p0IWY4ik8KyjatzBEeAduyqtPMu364luIP1XfA/bLu/6iGkljAbG
X-Received: by 2002:a05:6402:2683:: with SMTP id w3mr7147978edd.378.1611146512461;
        Wed, 20 Jan 2021 04:41:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1es0n+uTBVNNQ4O2XoP63Ntb4ev2oqumkzHrQgEqDpUQM2xcK4+U30pqT1kKkYEM0HgVa+Q==
X-Received: by 2002:a05:6402:2683:: with SMTP id w3mr7147963edd.378.1611146512224;
        Wed, 20 Jan 2021 04:41:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l16sm1062977edw.10.2021.01.20.04.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 04:41:51 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Remove the CI file for Travis,
 it's of no use anymore
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20210120093525.463974-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4bda4d97-cfd7-07a9-68b6-eeed30273819@redhat.com>
Date:   Wed, 20 Jan 2021 13:41:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210120093525.463974-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/21 10:35, Thomas Huth wrote:
> With its new policy, Travis-CI has become completely useless for
> OSS projects like kvm-unit-tests. Thus remove the YML file now.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   .travis.yml | 180 ----------------------------------------------------
>   1 file changed, 180 deletions(-)
>   delete mode 100644 .travis.yml
> 
> diff --git a/.travis.yml b/.travis.yml
> deleted file mode 100644
> index 5af7344..0000000
> --- a/.travis.yml
> +++ /dev/null
> @@ -1,180 +0,0 @@
> -dist: focal
> -language: c
> -cache: ccache
> -git:
> -  submodules: false
> -
> -jobs:
> -  include:
> -
> -    - addons:
> -        apt_packages: gcc qemu-system-x86
> -      env:
> -      - CONFIG=""
> -      - BUILD_DIR="."
> -      - TESTS="access asyncpf debug emulator ept hypercall hyperv_clock
> -          hyperv_connections hyperv_stimer hyperv_synic idt_test intel_iommu
> -          ioapic ioapic-split kvmclock_test memory msr pcid pcid-disabled
> -          rdpru realmode rmap_chain s3 setjmp sieve smap smptest smptest3
> -          syscall tsc tsc_adjust tsx-ctrl umip vmexit_cpuid vmexit_inl_pmtimer
> -          vmexit_ipi vmexit_ipi_halt vmexit_mov_from_cr8 vmexit_mov_to_cr8
> -          vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
> -          vmexit_vmcall vmx_apic_passthrough_thread xsave"
> -      - ACCEL="kvm"
> -
> -    - addons:
> -        apt_packages: clang-10 qemu-system-x86
> -      compiler: clang
> -      env:
> -      - CONFIG="--cc=clang-10"
> -      - BUILD_DIR="x86-builddir"
> -      - TESTS="access asyncpf debug emulator ept hypercall hyperv_clock
> -          hyperv_connections hyperv_stimer hyperv_synic idt_test intel_iommu
> -          ioapic ioapic-split kvmclock_test memory msr pcid pcid-disabled
> -          rdpru realmode rmap_chain s3 setjmp sieve smap smptest smptest3
> -          syscall tsc tsc_adjust tsx-ctrl umip vmexit_cpuid vmexit_inl_pmtimer
> -          vmexit_ipi vmexit_ipi_halt vmexit_mov_from_cr8 vmexit_mov_to_cr8
> -          vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
> -          vmexit_vmcall vmx_apic_passthrough_thread xsave"
> -      - ACCEL="kvm"
> -
> -    - addons:
> -        apt_packages: gcc gcc-multilib qemu-system-x86
> -      env:
> -      - CONFIG="--arch=i386"
> -      - BUILD_DIR="."
> -      - TESTS="asyncpf kvmclock_test msr pmu realmode s3 setjmp sieve smap
> -          smptest smptest3 taskswitch taskswitch2 tsc tsc_adjust tsx-ctrl umip"
> -      - ACCEL="kvm"
> -
> -    - addons:
> -        apt_packages: gcc gcc-multilib qemu-system-x86
> -      env:
> -      - CONFIG="--arch=i386"
> -      - BUILD_DIR="i386-builddir"
> -      - TESTS="cmpxchg8b vmexit_vmcall vmexit_cpuid vmexit_ipi vmexit_ipi_halt
> -          vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
> -          vmexit_inl_pmtimer vmexit_tscdeadline vmexit_tscdeadline_immed"
> -      - ACCEL="kvm"
> -
> -    - addons:
> -        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
> -      env:
> -      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
> -      - BUILD_DIR="."
> -      - TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
> -
> -    - addons:
> -        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
> -      env:
> -      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
> -      - BUILD_DIR="arm-buildir"
> -      - TESTS="pci-test pmu gicv2-active gicv3-active psci selftest-setup"
> -
> -    - addons:
> -        apt_packages: gcc-aarch64-linux-gnu qemu-system-aarch64
> -      env:
> -      - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
> -      - BUILD_DIR="."
> -      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi pci-test
> -          pmu-cycle-counter pmu-event-counter-config pmu-sw-incr psci
> -          selftest-setup selftest-smp selftest-vectors-kernel
> -          selftest-vectors-user timer"
> -
> -    - arch: arm64
> -      addons:
> -        apt_packages: clang-10 qemu-system-aarch64
> -      compiler: clang
> -      env:
> -      - CONFIG="--arch=arm64 --cc=clang-10"
> -      - BUILD_DIR="arm64-buildir"
> -      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi pci-test
> -          pmu-cycle-counter pmu-event-counter-config pmu-sw-incr selftest-setup
> -          selftest-smp selftest-vectors-kernel selftest-vectors-user timer"
> -
> -    - addons:
> -        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
> -      env:
> -      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
> -      - BUILD_DIR="."
> -      - TESTS="selftest-setup spapr_hcall emulator rtas-set-time-of-day"
> -      - ACCEL="tcg,cap-htm=off"
> -
> -    - addons:
> -        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
> -      env:
> -      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
> -      - BUILD_DIR="ppc64le-buildir"
> -      - TESTS="rtas-get-time-of-day rtas-get-time-of-day-base"
> -      - ACCEL="tcg,cap-htm=off"
> -
> -    - addons:
> -        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
> -      env:
> -      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
> -      - BUILD_DIR="."
> -      - TESTS="cpumodel css diag10 diag288 diag308 emulator intercept sclp-1g
> -          sclp-3g selftest-setup"
> -      - ACCEL="tcg,firmware=s390x/run"
> -
> -    - addons:
> -        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
> -      env:
> -      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
> -      - BUILD_DIR="s390x-builddir"
> -      - TESTS="sieve skey stsi vector"
> -      - ACCEL="tcg,firmware=s390x/run"
> -
> -    - os: osx
> -      osx_image: xcode11.6
> -      addons:
> -        homebrew:
> -          packages:
> -            - bash
> -            - coreutils
> -            - gnu-getopt
> -            - qemu
> -            - x86_64-elf-gcc
> -      env:
> -      - CONFIG="--cross-prefix=x86_64-elf-"
> -      - BUILD_DIR="build"
> -      - TESTS="ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
> -               vmexit_mov_to_cr8 vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
> -               vmexit_ple_round_robin vmexit_tscdeadline
> -               vmexit_tscdeadline_immed eventinj msr port80 setjmp
> -               syscall tsc rmap_chain umip intel_iommu"
> -      - ACCEL="tcg"
> -      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
> -
> -    - os: osx
> -      osx_image: xcode11.6
> -      addons:
> -        homebrew:
> -          packages:
> -            - bash
> -            - coreutils
> -            - gnu-getopt
> -            - qemu
> -            - i686-elf-gcc
> -      env:
> -      - CONFIG="--arch=i386 --cross-prefix=i686-elf-"
> -      - BUILD_DIR="build"
> -      - TESTS="cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
> -               vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
> -               vmexit_ple_round_robin vmexit_tscdeadline
> -               vmexit_tscdeadline_immed eventinj port80 setjmp tsc
> -               taskswitch umip"
> -      - ACCEL="tcg"
> -      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
> -
> -before_script:
> -  - if [ "$ACCEL" = "kvm" ]; then
> -      sudo chgrp kvm /usr/bin/qemu-system-* ;
> -      sudo chmod g+s /usr/bin/qemu-system-* ;
> -    fi
> -  - mkdir -p $BUILD_DIR && cd $BUILD_DIR
> -  - $TRAVIS_BUILD_DIR/configure $CONFIG
> -script:
> -  - make -j3
> -  - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
> -  - grep -q PASS results.txt && ! grep -q FAIL results.txt
> 

Applied, thanks.

Paolo

