Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC74757FC3
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbjGROiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbjGROiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:38:08 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB601990
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 07:38:03 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-52176fdad9dso5537361a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 07:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689691081; x=1692283081;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=75L/3OVtvZjuTDZO1U5NULzORO9HoUjrPecBU88kFVg=;
        b=s6UQ+0D+YlNZU5kMLy7TOrWhyfunsVOoqmewL6INjtZt+yul2arKXwZrb77/8pX/uc
         xVBjSC/kxi5n/dBfttJmZ5rVkEwpaaPjfIdulQelmfsTMrqPpKW8yu6C43HXrzDNWPcP
         FZYEXjbxSvXQHC9mq7KCjp/XhVHRIvhc6/dAmmeAFq1J5//ISpLWG4VHw8zCAYJp8wFc
         2l6eRTZE2d1vPFtwRcsX3I7ca5S+OIq3/gAG3awTn36P4K9qAWOQLnAtY++qvkIsg/fS
         vKZXyWLlYzX4WDCK4A+Qo8aMrZnHyYLgN9Bdwz0DkV2WOhU0DJpHfvuOqUJLk0d7hmab
         3WBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689691081; x=1692283081;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=75L/3OVtvZjuTDZO1U5NULzORO9HoUjrPecBU88kFVg=;
        b=dYdELOMNL6WDqZvudy1RtM6HMh5UYKrEBMp+rUHAhCMq+PdFVdgwXLEPgiusIvYe81
         9G88MU03Y8UoZIqOINs8QTyIOpN5fa15+1bB02gqS6tGBQf/qB0xowYS3hmfCFoS/aJh
         pezyPVzSeiyCJlpoheM8NWVS38gxXJbXQxbwVEhzOMk/67yoRTl15ien7DIE+IOHGlB5
         KhDB0xZPcJN50N+0zO+dEUbkYvvBlh72TcmF1kenryOJzpV/UaAoLxth6F1ZBXUgG/SR
         1/uONE+VHIEoTpCucZ4r8MbLe9a9mvrpNUmf7B41fXBZHn7uPT3wFSjlySW401Oanttc
         nAhQ==
X-Gm-Message-State: ABy/qLZr9+WOXj8QPuYsOXAlj/SRJo3dBd87Ls1YTFLezOqIO+gSVOB/
        G0/vHH6vpNLcS3oRfpqahti+DT2LZcnqUXM9fhWl4g==
X-Google-Smtp-Source: APBJJlF7p9wEN9sukd1YSop4aAYl8/qlgo9aJIhNuJpIH0XfrkjYqMQFEB7+XzJiNM59aUYsL91Zx6WoKY9MwC3uf9A=
X-Received: by 2002:aa7:d5d4:0:b0:51e:3558:5eb8 with SMTP id
 d20-20020aa7d5d4000000b0051e35585eb8mr106354eds.19.1689691081360; Tue, 18 Jul
 2023 07:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230717201547.359923764@linuxfoundation.org>
In-Reply-To: <20230717201547.359923764@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Jul 2023 20:07:49 +0530
Message-ID: <CA+G9fYujXH8J99m8ZKoijGhWJAS+r1SPqd8y+gB-B9DVjsgAzA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        conor@kernel.org, Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jul 2023 at 02:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


As you know LKFT runs latest kselftests from stable 6.4 on
stable rc 6.1 branches and found two test failures on this
round of stable rc review 6.1.39-rc3 compared with 6.1.37.

Test regressions:

* bcm2711-rpi-4-b, kselftest-kvm
  - kvm_get-reg-list

* x86, kselftest-kvm
  - kvm_vmx_pmu_caps_test

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.39-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: ce7ec101118789331617601d680d905c318b4ab6
* git describe: v6.1.38-590-gce7ec1011187
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.38-590-gce7ec1011187

## Test Regressions (compared to v6.1.37-14-g185484ee4c4f)
* bcm2711-rpi-4-b, kselftest-kvm
  - kvm_get-reg-list

logs:
--
# selftests: kvm: get-reg-list
# vregs: Number blessed registers:   242
# vregs: Number registers:           242 (includes 3 filtered registers)
#
# vregs: There are 3 missing registers.
# The following lines are missing registers:
#
# ARM64_SYS_REG(3, 3, 14, 0, 1),
# ARM64_SYS_REG(3, 3, 14, 2, 1),
# ARM64_SYS_REG(3, 3, 14, 2, 2),
#
# ==== Test Assertion Failure ====
#   aarch64/get-reg-list.c:541: !missing_regs && !failed_get &&
!failed_set && !failed_reject
#   pid=658 tid=658 errno=7 - Argument list too long
#      1 0x0000000000402def: ?? ??:0
#      2 0x0000000000401aff: ?? ??:0
#      3 0x0000ffff81dfb22f: ?? ??:0
#      4 0x0000ffff81dfb30b: ?? ??:0
#      5 0x0000000000401bef: ?? ??:0
#   vregs: There are 3 missing registers; 0 registers failed get; 0
registers failed set; 0 registers failed reject
# vregs+pmu: Number blessed registers:   316
# vregs+pmu: Number registers:           316 (includes 3 filtered registers)
#
# vregs+pmu: There are 3 missing registers.
# The following lines are missing registers:
#
# ARM64_SYS_REG(3, 3, 14, 0, 1),
# ARM64_SYS_REG(3, 3, 14, 2, 1),
# ARM64_SYS_REG(3, 3, 14, 2, 2),
#
# ==== Test Assertion Failure ====
#   aarch64/get-reg-list.c:541: !missing_regs && !failed_get &&
!failed_set && !failed_reject
#   pid=662 tid=662 errno=7 - Argument list too long
#      1 0x0000000000402def: ?? ??:0
#      2 0x0000000000401aff: ?? ??:0
#      3 0x0000ffff81dfb22f: ?? ??:0
#      4 0x0000ffff81dfb30b: ?? ??:0
#      5 0x0000000000401bef: ?? ??:0
#   vregs+pmu: There are 3 missing registers; 0 registers failed get;
0 registers failed set; 0 registers failed reject
# 1..0 # SKIP - sve: sve not available, skipping tests
#
# 1..0 # SKIP - sve+pmu: sve not available, skipping tests
#
# 1..0 # SKIP - vregs+pauth_address+pauth_generic: pauth_address not
available, skipping tests
#
# 1..0 # SKIP - vregs+pauth_address+pauth_generic+pmu: pauth_address
not available, skipping tests
#
not ok 4 selftests: kvm: get-reg-list # exit=1

Links:
  - https://lkft.validation.linaro.org/scheduler/job/6596193#L1173
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.38-590-gce7ec1011187/testrun/18431257/suite/kselftest-kvm/test/kvm_get-reg-list/history/
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.38-590-gce7ec1011187/testrun/18431257/suite/kselftest-kvm/test/kvm_get-reg-list/details/

* x86, kselftest-kvm
  - kvm_vmx_pmu_caps_test

Test log:
--------
# selftests: kvm: vmx_pmu_caps_test
# ==== Test Assertion Failure ====
#   x86_64/vmx_pmu_caps_test.c:111: !r
#   pid=2323 tid=2323 errno=4 - Interrupted system call
#      1 0x0000000000402c5c: ?? ??:0
#      2 0x00007f229a0af57a: ?? ??:0
#      3 0x00007f229a0af62f: ?? ??:0
#      4 0x0000000000402f14: ?? ??:0
#   Post-KVM_RUN write '0' didn't fail
not ok 51 selftests: kvm: vmx_pmu_caps_test # exit=254

links:
 - https://lkft.validation.linaro.org/scheduler/job/6595836#L1841
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.38-590-gce7ec1011187/testrun/18434308/suite/kselftest-kvm/test/kvm_vmx_pmu_caps_test/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.38-590-gce7ec1011187/testrun/18434308/suite/kselftest-kvm/test/kvm_vmx_pmu_caps_test/details/



## Metric Regressions (compared to v6.1.37-14-g185484ee4c4f)

## Test Fixes (compared to v6.1.37-14-g185484ee4c4f)

## Metric Fixes (compared to v6.1.37-14-g185484ee4c4f)

## Test result summary
total: 170933, pass: 143114, fail: 2918, skip: 24710, xfail: 191

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

## Test suites summary
* boot
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesytems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
