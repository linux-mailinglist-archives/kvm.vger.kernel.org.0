Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CDE16AC53
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 17:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgBXQzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 11:55:31 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46588 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgBXQzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 11:55:31 -0500
Received: by mail-lf1-f68.google.com with SMTP id u2so4595569lfk.13
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 08:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPBtqOuezx43iAV8YxQ5F2Hqcukun6Rbcr0diEr/bx4=;
        b=cn/R65AZcJCtcX1WAN4Du3SL5Qh0hLzFLAcwExZJ894sD5R4VWyf/o2NhUZ3TBUHDJ
         rD5EggmazQ/UgRkHrG2KP9iDrDthA+bn14rfYsgqo571H1yN2XvadUCfNJKxYvAmlrTu
         QEMTSXkI2o2uK+3oQ4sE+/xdW9tjYZ0rzSDoph3pqjpnrb6+JU9i1lhAv9GOX+eXfJIC
         X0r0ET1cNO5YihySbLITznwG+DIUV+OLeW9pujJZ6rY8mfqfQHclt9YAMhcfE5WGsxow
         zspoJwwV7vDRSZPMNv/XfpdHlIsdagP0npg/chIMGeEvfoKj0vHemNiwrbzqrk4IOr+F
         b39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPBtqOuezx43iAV8YxQ5F2Hqcukun6Rbcr0diEr/bx4=;
        b=LND+4VLPoV+DeVgRUnbmbmRcna1pzNqlWaPEX7VcV5S2dyivXtmjYPHUABuK52UArj
         AiTn0jAMJ2eXLxlhlwKghPS61y6FiDiBkvXyGfpPAoDEP149KQJLrjgLNiI7rbc+4/KV
         O6rjho9LDK7ZfSQCnY0RU0TP4GyRJJUwGA2tgMp6ijPtIgaead5gmIGR1efdEsADnymb
         qdlOZ4UGrvut4Bi9mAQS5dxK+ii4UtIoa6aAtWzt8K/W1Bo7VZiDoP97B31DQ9w/EPeo
         Czm5yEZSx8T3z/gKsNDW303j57En8SIANUvZJHFc7sSMq7WfgsahRgSu4KsqQ/pxTeX2
         e6aA==
X-Gm-Message-State: APjAAAXR83dDE8IHOUfx3nI8cqJAtEsbUgB6gMrkc4k9+poTGoZ3eaT5
        Uyj+FHqsgMxy3EDZC/eMBEclqOhmKOQdMMz3le0Xyg==
X-Google-Smtp-Source: APXvYqxLN8ToSLf9C+gOJfY7tg0uM2LsQh+D/esMUghpylBv7oL2lnKK1ijCUkaCgAcswmxCytBrsOWIgm0wOO9/WfI=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr26954249lfc.6.1582563324817;
 Mon, 24 Feb 2020 08:55:24 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com> <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com> <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
In-Reply-To: <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Feb 2020 22:25:13 +0530
Message-ID: <CA+G9fYvt2LyqU5G2j_EFKzgPXzt8sDYYm8NxP+zD6Do07REsYw@mail.gmail.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Andrew Jones <drjones@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: multipart/mixed; boundary="000000000000cfa520059f553cdc"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--000000000000cfa520059f553cdc
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Feb 2020 at 20:29, Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Feb 24, 2020 at 01:47:44PM +0000, Alexandru Elisei wrote:
> > Hi,
> >
> > On 2/24/20 1:38 PM, Andrew Jones wrote:
> > > On Mon, Feb 24, 2020 at 01:21:23PM +0000, Alexandru Elisei wrote:
> > >> Hi Naresh,
> > >>
> > >> On 2/24/20 12:53 PM, Naresh Kamboju wrote:
> > >>> [Sorry for the spam]
> > >>>
> > >>> Greeting from Linaro !
> > >>> We are running kvm-unit-tests on our CI Continuous Integration and
> > >>> testing on x86_64 and arm64 Juno-r2.
> > >>> Linux stable branches and Linux mainline and Linux next.
> > >>>
> > >>> Few tests getting fail and skipped, we are interested in increasing the
> > >>> test coverage by adding required kernel config fragments,
> > >>> kernel command line arguments and user space tools.
> > >>>
> > >>> Your help is much appreciated.
> > >>>
> > >>> Here is the details of the LKFT kvm unit test logs,
> > >>>
> > >>> [..]
> > >> I am going to comment on the arm64 tests. As far as I am aware, you don't need any
> > >> kernel configs to run the tests.

Thanks for the confirmation on Kconfig part for arm64.
The next question is, How to enable and run nested virtual testing ?

> > >>
> > >> From looking at the java log [1], I can point out a few things:
> > >>
> > >> - The gicv3 tests are failing because Juno has a gicv2 and the kernel refuses to
> > >> create a virtual gicv3. It's normal.

Got it.
Because of heterogeneous big.LITTLE CPU architecture of Juno device caused
test hang and "taskset -c 0 ./run_tests.sh -a -v -t " solved this problem.

> > > Yup

timers test is intermittent failure due to timeout on the CPU 0 which
is configured
as LITTLE cpu cortext a53. If i change test to run on big CPU then it
always PASS.
"taskset -c $BIG_CPU_ID ./run_tests.sh -a -v -t"

> > >
> > >> - I am not familiar with the PMU test, so I cannot help you with that.
> > > Where is the output from running the PMU test? I didn't see it in the link
> > > below.
> >
> > It's toward the end, it just says that 2 tests failed:
>
> If the test runner isn't capturing all the output of the tests somewhere,
> then it should. Naresh, is the pmu.log file somewhere?

For more detail I have shared LAVA log [1] and attached detail run output.

timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/pmu.flat -smp 1 # -initrd /tmp/tmp.ZJ05lRvgc4
INFO: PMU version: 3
INFO: pmu: PMU implementer/ID code/counters: 0x41(\"A\")/0x3/6
PASS: pmu: Control register
Read 0 then 0.
FAIL: pmu: Monotonically increasing cycle count
instrs : cycles0 cycles1 ...
4:    0
cycles not incrementing!
FAIL: pmu: Cycle/instruction ratio
SUMMARY: 3 tests, 2 unexpected failures

arm64 juno-r2 TAP13 output and log file details.
ok 1 - selftest: setup: smp: number of CPUs matches expectation
ok 2 - selftest: setup: mem: memory size matches expectation
ok 3 - selftest: vectors-kernel: und
ok 4 - selftest: vectors-kernel: svc
ok 5 - selftest: vectors-kernel: pabt
ok 6 - selftest: vectors-user: und
ok 7 - selftest: vectors-user: svc
ok 8 - selftest: smp: PSCI version
ok 9 - selftest: smp: MPIDR test on all CPUs
ok 10 - pci: PCI test device passed 6/6 tests
ok 11 - pmu: Control register
not ok 12 - pmu: Monotonically increasing cycle count
not ok 13 - pmu: Cycle/instruction ratio
ok 14 - gicv2: ipi: self: IPI: self
ok 15 - gicv2: ipi: target-list: IPI: directed
ok 16 - gicv2: ipi: broadcast: IPI: broadcast
ok 17 - gicv2: mmio: all CPUs have interrupts
ok 18 - gicv2: mmio: GICD_TYPER is read-only
ok 19 - gicv2: mmio: GICD_IIDR is read-only
ok 20 - gicv2: mmio: ICPIDR2 is read-only
ok 21 - gicv2: mmio: IPRIORITYR: consistent priority masking
ok 22 - gicv2: mmio: IPRIORITYR: implements at least 4 priority bits
ok 23 - gicv2: mmio: IPRIORITYR: clearing priorities
ok 24 - gicv2: mmio: IPRIORITYR: accesses beyond limit RAZ/WI
ok 25 - gicv2: mmio: IPRIORITYR: accessing last SPIs
ok 26 - gicv2: mmio: IPRIORITYR: priorities are preserved
ok 27 - gicv2: mmio: IPRIORITYR: byte reads successful
ok 28 - gicv2: mmio: IPRIORITYR: byte writes successful
ok 29 - gicv2: mmio: ITARGETSR: bits for non-existent CPUs masked
ok 30 - gicv2: mmio: ITARGETSR: accesses beyond limit RAZ/WI
ok 31 - gicv2: mmio: ITARGETSR: register content preserved
ok 32 - gicv2: mmio: ITARGETSR: byte reads successful
ok 33 - gicv2: mmio: ITARGETSR: byte writes successful
ok 34 - gicv2: mmio: all CPUs have interrupts
ok 35 - gicv2: mmio: GICD_TYPER is read-only
ok 36 - gicv2: mmio: GICD_IIDR is read-only
ok 37 - gicv2: mmio: ICPIDR2 is read-only
ok 38 - gicv2: mmio: IPRIORITYR: consistent priority masking
ok 39 - gicv2: mmio: IPRIORITYR: implements at least 4 priority bits
ok 40 - gicv2: mmio: IPRIORITYR: clearing priorities
ok 41 - gicv2: mmio: IPRIORITYR: accesses beyond limit RAZ/WI
ok 42 - gicv2: mmio: IPRIORITYR: accessing last SPIs
ok 43 - gicv2: mmio: IPRIORITYR: priorities are preserved
ok 44 - gicv2: mmio: IPRIORITYR: byte reads successful
ok 45 - gicv2: mmio: IPRIORITYR: byte writes successful
ok 46 - gicv2: mmio: ITARGETSR: bits for non-existent CPUs masked
ok 47 - gicv2: mmio: ITARGETSR: accesses beyond limit RAZ/WI
ok 48 - gicv2: mmio: ITARGETSR: register content preserved
ok 49 - gicv2: mmio: ITARGETSR: byte reads successful
ok 50 - gicv2: mmio: ITARGETSR: byte writes successful
ok 51 - gicv2: mmio: all CPUs have interrupts
ok 52 - gicv2: mmio: GICD_TYPER is read-only
ok 53 - gicv2: mmio: GICD_IIDR is read-only
ok 54 - gicv2: mmio: ICPIDR2 is read-only
ok 55 - gicv2: mmio: IPRIORITYR: consistent priority masking
ok 56 - gicv2: mmio: IPRIORITYR: implements at least 4 priority bits
ok 57 - gicv2: mmio: IPRIORITYR: clearing priorities
ok 58 - gicv2: mmio: IPRIORITYR: accesses beyond limit RAZ/WI
ok 59 - gicv2: mmio: IPRIORITYR: accessing last SPIs
ok 60 - gicv2: mmio: IPRIORITYR: priorities are preserved
ok 61 - gicv2: mmio: IPRIORITYR: byte reads successful
ok 62 - gicv2: mmio: IPRIORITYR: byte writes successful
ok 63 - gicv2: mmio: ITARGETSR: bits for non-existent CPUs masked
ok 64 - gicv2: mmio: ITARGETSR: accesses beyond limit RAZ/WI
ok 65 - gicv2: mmio: ITARGETSR: register content preserved
ok 66 - gicv2: mmio: ITARGETSR: byte reads successful
ok 67 - gicv2: mmio: ITARGETSR: byte writes successful
ok 68 - gicv2: active: self: IPI: self
ok 69 - psci: invalid-function
ok 70 - psci: affinity-info-on
ok 71 - psci: affinity-info-off
ok 72 - psci: cpu-on
ok 73 - vtimer-busy-loop: not pending before
ok 74 - vtimer-busy-loop: interrupt signal pending
ok 75 - vtimer-busy-loop: interrupt signal no longer pending
ok 76 - vtimer-busy-loop: latency within 10 ms
ok 77 - vtimer-busy-loop: interrupt received
ok 78 - vtimer-busy-loop: interrupt received after TVAL/WFI
ok 79 - vtimer-busy-loop: timer has expired
ok 80 - ptimer-busy-loop: not pending before
ok 81 - ptimer-busy-loop: interrupt signal pending
ok 82 - ptimer-busy-loop: interrupt signal no longer pending
ok 83 - ptimer-busy-loop: latency within 10 ms
ok 84 - ptimer-busy-loop: interrupt received
ok 85 - ptimer-busy-loop: interrupt received after TVAL/WFI
ok 86 - ptimer-busy-loop: timer has expired
ok 87 - IDC-DIC: code generation
1..87
+ ls logs/cache.log logs/gicv2-active.log logs/gicv2-ipi.log
logs/gicv2-mmio-3p.log logs/gicv2-mmio-up.log logs/gicv2-mmio.log
logs/gicv3-active.log logs/gicv3-ipi.log logs/micro-bench.log
logs/pci-test.log logs/pmu.log logs/psci.log logs/selftest-setup.log
logs/selftest-smp.log logs/selftest-vectors-kernel.log
logs/selftest-vectors-user.log logs/timer.log
logs/cache.log logs/gicv3-active.log  logs/selftest-setup.log
logs/gicv2-active.log logs/gicv3-ipi.log     logs/selftest-smp.log
logs/gicv2-ipi.log logs/micro-bench.log   logs/selftest-vectors-kernel.log
logs/gicv2-mmio-3p.log logs/pci-test.log      logs/selftest-vectors-user.log
logs/gicv2-mmio-up.log logs/pmu.log        logs/timer.log
logs/gicv2-mmio.log logs/psci.log

+ cat logs/cache.log logs/gicv2-active.log logs/gicv2-ipi.log
logs/gicv2-mmio-3p.log logs/gicv2-mmio-up.log logs/gicv2-mmio.log
logs/gicv3-active.log logs/gicv3-ipi.log logs/micro-bench.log
logs/pci-test.log logs/pmu.log logs/psci.log logs/selftest-setup.log
logs/selftest-smp.log logs/selftest-vectors-kernel.log
logs/selftest-vectors-user.log logs/timer.log
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/cache.flat -smp 1 # -initrd /tmp/tmp.m99CM6guY4
INFO: IDC-DIC: dcache clean to PoU required
INFO: IDC-DIC: icache invalidation to PoU required
PASS: IDC-DIC: code generation
SUMMARY: 1 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -smp 6 -machine gic-version=2 -append active # -initrd
/tmp/tmp.T4AwRe5sDM
PASS: gicv2: active: self: IPI: self
SUMMARY: 1 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -smp 6 -machine gic-version=2 -append ipi # -initrd
/tmp/tmp.Lm1tKKNrS6
PASS: gicv2: ipi: self: IPI: self
PASS: gicv2: ipi: target-list: IPI: directed
PASS: gicv2: ipi: broadcast: IPI: broadcast
SUMMARY: 3 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -smp 3 -machine gic-version=2 -append mmio # -initrd
/tmp/tmp.IRrNzwPw2R
INFO: gicv2: mmio: number of implemented SPIs: 256
INFO: gicv2: mmio: nr_cpus=3
PASS: gicv2: mmio: all CPUs have interrupts
INFO: gicv2: mmio: IIDR: 0x4b00243b
PASS: gicv2: mmio: GICD_TYPER is read-only
PASS: gicv2: mmio: GICD_IIDR is read-only
PASS: gicv2: mmio: ICPIDR2 is read-only
INFO: gicv2: mmio: value of ICPIDR2: 0x00000000
PASS: gicv2: mmio: IPRIORITYR: consistent priority masking
INFO: gicv2: mmio: IPRIORITYR: priority mask is 0xf8f8f8f8
PASS: gicv2: mmio: IPRIORITYR: implements at least 4 priority bits
INFO: gicv2: mmio: IPRIORITYR: 5 priority bits implemented
PASS: gicv2: mmio: IPRIORITYR: clearing priorities
PASS: gicv2: mmio: IPRIORITYR: accesses beyond limit RAZ/WI
PASS: gicv2: mmio: IPRIORITYR: accessing last SPIs
PASS: gicv2: mmio: IPRIORITYR: priorities are preserved
PASS: gicv2: mmio: IPRIORITYR: byte reads successful
PASS: gicv2: mmio: IPRIORITYR: byte writes successful
PASS: gicv2: mmio: ITARGETSR: bits for non-existent CPUs masked
INFO: gicv2: mmio: ITARGETSR: 5 non-existent CPUs
PASS: gicv2: mmio: ITARGETSR: accesses beyond limit RAZ/WI
PASS: gicv2: mmio: ITARGETSR: register content preserved
PASS: gicv2: mmio: ITARGETSR: byte reads successful
PASS: gicv2: mmio: ITARGETSR: byte writes successful
SUMMARY: 17 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -smp 1 -machine gic-version=2 -append mmio # -initrd
/tmp/tmp.mLksHaaXvI
INFO: gicv2: mmio: number of implemented SPIs: 256
INFO: gicv2: mmio: nr_cpus=1
PASS: gicv2: mmio: all CPUs have interrupts
INFO: gicv2: mmio: IIDR: 0x4b00243b
PASS: gicv2: mmio: GICD_TYPER is read-only
PASS: gicv2: mmio: GICD_IIDR is read-only
PASS: gicv2: mmio: ICPIDR2 is read-only
INFO: gicv2: mmio: value of ICPIDR2: 0x00000000
PASS: gicv2: mmio: IPRIORITYR: consistent priority masking
INFO: gicv2: mmio: IPRIORITYR: priority mask is 0xf8f8f8f8
PASS: gicv2: mmio: IPRIORITYR: implements at least 4 priority bits
INFO: gicv2: mmio: IPRIORITYR: 5 priority bits implemented
PASS: gicv2: mmio: IPRIORITYR: clearing priorities
PASS: gicv2: mmio: IPRIORITYR: accesses beyond limit RAZ/WI
PASS: gicv2: mmio: IPRIORITYR: accessing last SPIs
PASS: gicv2: mmio: IPRIORITYR: priorities are preserved
PASS: gicv2: mmio: IPRIORITYR: byte reads successful
PASS: gicv2: mmio: IPRIORITYR: byte writes successful
PASS: gicv2: mmio: ITARGETSR: bits for non-existent CPUs masked
INFO: gicv2: mmio: ITARGETSR: 7 non-existent CPUs
PASS: gicv2: mmio: ITARGETSR: accesses beyond limit RAZ/WI
PASS: gicv2: mmio: ITARGETSR: register content preserved
PASS: gicv2: mmio: ITARGETSR: byte reads successful
PASS: gicv2: mmio: ITARGETSR: byte writes successful
SUMMARY: 17 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -smp 6 -machine gic-version=2 -append mmio # -initrd
/tmp/tmp.tboRkZvIS4
INFO: gicv2: mmio: number of implemented SPIs: 256
INFO: gicv2: mmio: nr_cpus=6
PASS: gicv2: mmio: all CPUs have interrupts
INFO: gicv2: mmio: IIDR: 0x4b00243b
PASS: gicv2: mmio: GICD_TYPER is read-only
PASS: gicv2: mmio: GICD_IIDR is read-only
PASS: gicv2: mmio: ICPIDR2 is read-only
INFO: gicv2: mmio: value of ICPIDR2: 0x00000000
PASS: gicv2: mmio: IPRIORITYR: consistent priority masking
INFO: gicv2: mmio: IPRIORITYR: priority mask is 0xf8f8f8f8
PASS: gicv2: mmio: IPRIORITYR: implements at least 4 priority bits
INFO: gicv2: mmio: IPRIORITYR: 5 priority bits implemented
PASS: gicv2: mmio: IPRIORITYR: clearing priorities
PASS: gicv2: mmio: IPRIORITYR: accesses beyond limit RAZ/WI
PASS: gicv2: mmio: IPRIORITYR: accessing last SPIs
PASS: gicv2: mmio: IPRIORITYR: priorities are preserved
PASS: gicv2: mmio: IPRIORITYR: byte reads successful
PASS: gicv2: mmio: IPRIORITYR: byte writes successful
PASS: gicv2: mmio: ITARGETSR: bits for non-existent CPUs masked
INFO: gicv2: mmio: ITARGETSR: 2 non-existent CPUs
PASS: gicv2: mmio: ITARGETSR: accesses beyond limit RAZ/WI
PASS: gicv2: mmio: ITARGETSR: register content preserved
PASS: gicv2: mmio: ITARGETSR: byte reads successful
PASS: gicv2: mmio: ITARGETSR: byte writes successful
SUMMARY: 17 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 6 -machine gic-version=3 -append active #
-initrd /tmp/tmp.N6d5klgltd
qemu-system-aarch64: Initialization of device kvm-arm-gicv3 failed:
error creating in-kernel VGIC: No such device
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 6 -machine gic-version=3 -append ipi # -initrd
/tmp/tmp.PUI0VvHEuT
qemu-system-aarch64: Initialization of device kvm-arm-gicv3 failed:
error creating in-kernel VGIC: No such device
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/micro-bench.flat -smp 2 # -initrd /tmp/tmp.urqlMsBpJd
Timer Frequency 50000000 Hz (Output in microseconds)
name                                    total ns                         avg ns
--------------------------------------------------------------------------------------------
hvc                                 296915440.0                         4530.0
mmio_read_user                     1322325100.0                        20177.0
mmio_read_vgic                      462255460.0                         7053.0
eoi                                   6779880.0                          103.0
qemu-system-aarch64: terminating on signal 15 from pid 3097 (timeout)
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/pci-test.flat -smp 1 # -initrd /tmp/tmp.7bpqvRWF8Z
00.00.0 1b36:0008 type 00 progif 00 class 06 subclass 00
00.01.0 1b36:0005 type 00 progif 00 class 00 subclass ff
BAR#0 [10000000-10000fff MEM32]
BAR#1 [3eff0000-3eff00ff PIO]
pci-testdev mem: mmio-no-eventfd
pci-testdev mem: mmio-wildcard-eventfd
pci-testdev mem: mmio-datamatch-eventfd
pci-testdev  io: portio-no-eventfd
pci-testdev  io: portio-wildcard-eventfd
pci-testdev  io: portio-datamatch-eventfd
PASS: pci: PCI test device passed 6/6 tests
SUMMARY: 1 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/pmu.flat -smp 1 # -initrd /tmp/tmp.ZJ05lRvgc4
INFO: PMU version: 3
INFO: pmu: PMU implementer/ID code/counters: 0x41(\"A\")/0x3/6
PASS: pmu: Control register
Read 0 then 0.
FAIL: pmu: Monotonically increasing cycle count
instrs : cycles0 cycles1 ...
4:    0
cycles not incrementing!
FAIL: pmu: Cycle/instruction ratio
SUMMARY: 3 tests, 2 unexpected failures
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/psci.flat -smp 6 # -initrd /tmp/tmp.F1CbWD7wLo
INFO: psci: PSCI version 1.0
PASS: psci: invalid-function
PASS: psci: affinity-info-on
PASS: psci: affinity-info-off
PASS: psci: cpu-on
SUMMARY: 4 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/selftest.flat -smp 2 -m 256 -append setup smp=2 mem=256 # -initrd
/tmp/tmp.VNiBOSgM9H
PASS: selftest: setup: smp: number of CPUs matches expectation
INFO: selftest: setup: smp: found 2 CPUs
PASS: selftest: setup: mem: memory size matches expectation
INFO: selftest: setup: mem: found 256 MB
SUMMARY: 2 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/selftest.flat -smp 6 -append smp # -initrd /tmp/tmp.OoV3Gn6wac
PSCI version 1.0
PASS: selftest: smp: PSCI version
INFO: selftest: smp: CPU  1: MPIDR=0080000001
INFO: selftest: smp: CPU  2: MPIDR=0080000002
INFO: selftest: smp: CPU  3: MPIDR=0080000003
INFO: selftest: smp: CPU  4: MPIDR=0080000004
INFO: selftest: smp: CPU  0: MPIDR=0080000000
INFO: selftest: smp: CPU  5: MPIDR=0080000005
PASS: selftest: smp: MPIDR test on all CPUs
INFO: selftest: smp: 6 CPUs reported back
SUMMARY: 2 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/selftest.flat -smp 1 -append vectors-kernel # -initrd
/tmp/tmp.dBkubcCv7q
PASS: selftest: vectors-kernel: und
PASS: selftest: vectors-kernel: svc
PASS: selftest: vectors-kernel: pabt
SUMMARY: 3 tests
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/selftest.flat -smp 1 -append vectors-user # -initrd
/tmp/tmp.sYzNVU4dPt
PASS: selftest: vectors-user: und
PASS: selftest: vectors-user: svc
SUMMARY: 2 tests
timeout -k 1s --foreground 2s /usr/bin/qemu-system-aarch64 -nodefaults
-machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/timer.flat -smp 1 # -initrd /tmp/tmp.n02ue5jzon
CNTFRQ_EL0   : 0x0000000002faf080
CNTPCT_EL0   : 0x00000002833698b6
CNTP_CTL_EL0 : 0x0000000000000004
CNTP_CVAL_EL0: 0x0000000000000000
CNTVCT_EL0   : 0x0000000001043c98
CNTV_CTL_EL0 : 0x0000000000000000
CNTV_CVAL_EL0: 0x0000000000000000
PASS: vtimer-busy-loop: not pending before
PASS: vtimer-busy-loop: interrupt signal pending
PASS: vtimer-busy-loop: interrupt signal no longer pending
INFO: vtimer-busy-loop: After timer: 0x0000000001265c31
INFO: vtimer-busy-loop: Expected   : 0x00000000012659d1
INFO: vtimer-busy-loop: Difference : 12 us
PASS: vtimer-busy-loop: latency within 10 ms
PASS: vtimer-busy-loop: interrupt received
INFO: vtimer-busy-loop: waiting for interrupt...
PASS: vtimer-busy-loop: interrupt received after TVAL/WFI
PASS: vtimer-busy-loop: timer has expired
INFO: vtimer-busy-loop: TVAL is -1848 ticks
PASS: ptimer-busy-loop: not pending before
PASS: ptimer-busy-loop: interrupt signal pending
PASS: ptimer-busy-loop: interrupt signal no longer pending
INFO: ptimer-busy-loop: After timer: 0x0000000283ab412b
INFO: ptimer-busy-loop: Expected   : 0x0000000283ab3c47
INFO: ptimer-busy-loop: Difference : 25 us
PASS: ptimer-busy-loop: latency within 10 ms
PASS: ptimer-busy-loop: interrupt received
INFO: ptimer-busy-loop: waiting for interrupt...
PASS: ptimer-busy-loop: interrupt received after TVAL/WFI
PASS: ptimer-busy-loop: timer has expired
INFO: ptimer-busy-loop: TVAL is -2365 ticks
SUMMARY: 14 tests


Test log link,
https://lkft.validation.linaro.org/scheduler/job/1249193#L1513

--000000000000cfa520059f553cdc
Content-Type: text/x-log; charset="US-ASCII"; name="kvm-unit-test-juno-r2-tap-13-full.log"
Content-Disposition: attachment; 
	filename="kvm-unit-test-juno-r2-tap-13-full.log"
Content-Transfer-Encoding: base64
Content-ID: <f_k70otj0b0>
X-Attachment-Id: f_k70otj0b0

b2sgMSAtIHNlbGZ0ZXN0OiBzZXR1cDogc21wOiBudW1iZXIgb2YgQ1BVcyBtYXRjaGVzIGV4cGVj
dGF0aW9uCm9rIDIgLSBzZWxmdGVzdDogc2V0dXA6IG1lbTogbWVtb3J5IHNpemUgbWF0Y2hlcyBl
eHBlY3RhdGlvbgpvayAzIC0gc2VsZnRlc3Q6IHZlY3RvcnMta2VybmVsOiB1bmQKb2sgNCAtIHNl
bGZ0ZXN0OiB2ZWN0b3JzLWtlcm5lbDogc3ZjCm9rIDUgLSBzZWxmdGVzdDogdmVjdG9ycy1rZXJu
ZWw6IHBhYnQKb2sgNiAtIHNlbGZ0ZXN0OiB2ZWN0b3JzLXVzZXI6IHVuZApvayA3IC0gc2VsZnRl
c3Q6IHZlY3RvcnMtdXNlcjogc3ZjCm9rIDggLSBzZWxmdGVzdDogc21wOiBQU0NJIHZlcnNpb24K
b2sgOSAtIHNlbGZ0ZXN0OiBzbXA6IE1QSURSIHRlc3Qgb24gYWxsIENQVXMKb2sgMTAgLSBwY2k6
IFBDSSB0ZXN0IGRldmljZSBwYXNzZWQgNi82IHRlc3RzCm9rIDExIC0gcG11OiBDb250cm9sIHJl
Z2lzdGVyCm5vdCBvayAxMiAtIHBtdTogTW9ub3RvbmljYWxseSBpbmNyZWFzaW5nIGN5Y2xlIGNv
dW50Cm5vdCBvayAxMyAtIHBtdTogQ3ljbGUvaW5zdHJ1Y3Rpb24gcmF0aW8Kb2sgMTQgLSBnaWN2
MjogaXBpOiBzZWxmOiBJUEk6IHNlbGYKb2sgMTUgLSBnaWN2MjogaXBpOiB0YXJnZXQtbGlzdDog
SVBJOiBkaXJlY3RlZApvayAxNiAtIGdpY3YyOiBpcGk6IGJyb2FkY2FzdDogSVBJOiBicm9hZGNh
c3QKb2sgMTcgLSBnaWN2MjogbW1pbzogYWxsIENQVXMgaGF2ZSBpbnRlcnJ1cHRzCm9rIDE4IC0g
Z2ljdjI6IG1taW86IEdJQ0RfVFlQRVIgaXMgcmVhZC1vbmx5Cm9rIDE5IC0gZ2ljdjI6IG1taW86
IEdJQ0RfSUlEUiBpcyByZWFkLW9ubHkKb2sgMjAgLSBnaWN2MjogbW1pbzogSUNQSURSMiBpcyBy
ZWFkLW9ubHkKb2sgMjEgLSBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogY29uc2lzdGVudCBwcmlv
cml0eSBtYXNraW5nCm9rIDIyIC0gZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGltcGxlbWVudHMg
YXQgbGVhc3QgNCBwcmlvcml0eSBiaXRzCm9rIDIzIC0gZ2ljdjI6IG1taW86IElQUklPUklUWVI6
IGNsZWFyaW5nIHByaW9yaXRpZXMKb2sgMjQgLSBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogYWNj
ZXNzZXMgYmV5b25kIGxpbWl0IFJBWi9XSQpvayAyNSAtIGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlS
OiBhY2Nlc3NpbmcgbGFzdCBTUElzCm9rIDI2IC0gZ2ljdjI6IG1taW86IElQUklPUklUWVI6IHBy
aW9yaXRpZXMgYXJlIHByZXNlcnZlZApvayAyNyAtIGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBi
eXRlIHJlYWRzIHN1Y2Nlc3NmdWwKb2sgMjggLSBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogYnl0
ZSB3cml0ZXMgc3VjY2Vzc2Z1bApvayAyOSAtIGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IGJpdHMg
Zm9yIG5vbi1leGlzdGVudCBDUFVzIG1hc2tlZApvayAzMCAtIGdpY3YyOiBtbWlvOiBJVEFSR0VU
U1I6IGFjY2Vzc2VzIGJleW9uZCBsaW1pdCBSQVovV0kKb2sgMzEgLSBnaWN2MjogbW1pbzogSVRB
UkdFVFNSOiByZWdpc3RlciBjb250ZW50IHByZXNlcnZlZApvayAzMiAtIGdpY3YyOiBtbWlvOiBJ
VEFSR0VUU1I6IGJ5dGUgcmVhZHMgc3VjY2Vzc2Z1bApvayAzMyAtIGdpY3YyOiBtbWlvOiBJVEFS
R0VUU1I6IGJ5dGUgd3JpdGVzIHN1Y2Nlc3NmdWwKb2sgMzQgLSBnaWN2MjogbW1pbzogYWxsIENQ
VXMgaGF2ZSBpbnRlcnJ1cHRzCm9rIDM1IC0gZ2ljdjI6IG1taW86IEdJQ0RfVFlQRVIgaXMgcmVh
ZC1vbmx5Cm9rIDM2IC0gZ2ljdjI6IG1taW86IEdJQ0RfSUlEUiBpcyByZWFkLW9ubHkKb2sgMzcg
LSBnaWN2MjogbW1pbzogSUNQSURSMiBpcyByZWFkLW9ubHkKb2sgMzggLSBnaWN2MjogbW1pbzog
SVBSSU9SSVRZUjogY29uc2lzdGVudCBwcmlvcml0eSBtYXNraW5nCm9rIDM5IC0gZ2ljdjI6IG1t
aW86IElQUklPUklUWVI6IGltcGxlbWVudHMgYXQgbGVhc3QgNCBwcmlvcml0eSBiaXRzCm9rIDQw
IC0gZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGNsZWFyaW5nIHByaW9yaXRpZXMKb2sgNDEgLSBn
aWN2MjogbW1pbzogSVBSSU9SSVRZUjogYWNjZXNzZXMgYmV5b25kIGxpbWl0IFJBWi9XSQpvayA0
MiAtIGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBhY2Nlc3NpbmcgbGFzdCBTUElzCm9rIDQzIC0g
Z2ljdjI6IG1taW86IElQUklPUklUWVI6IHByaW9yaXRpZXMgYXJlIHByZXNlcnZlZApvayA0NCAt
IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBieXRlIHJlYWRzIHN1Y2Nlc3NmdWwKb2sgNDUgLSBn
aWN2MjogbW1pbzogSVBSSU9SSVRZUjogYnl0ZSB3cml0ZXMgc3VjY2Vzc2Z1bApvayA0NiAtIGdp
Y3YyOiBtbWlvOiBJVEFSR0VUU1I6IGJpdHMgZm9yIG5vbi1leGlzdGVudCBDUFVzIG1hc2tlZApv
ayA0NyAtIGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IGFjY2Vzc2VzIGJleW9uZCBsaW1pdCBSQVov
V0kKb2sgNDggLSBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiByZWdpc3RlciBjb250ZW50IHByZXNl
cnZlZApvayA0OSAtIGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IGJ5dGUgcmVhZHMgc3VjY2Vzc2Z1
bApvayA1MCAtIGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IGJ5dGUgd3JpdGVzIHN1Y2Nlc3NmdWwK
b2sgNTEgLSBnaWN2MjogbW1pbzogYWxsIENQVXMgaGF2ZSBpbnRlcnJ1cHRzCm9rIDUyIC0gZ2lj
djI6IG1taW86IEdJQ0RfVFlQRVIgaXMgcmVhZC1vbmx5Cm9rIDUzIC0gZ2ljdjI6IG1taW86IEdJ
Q0RfSUlEUiBpcyByZWFkLW9ubHkKb2sgNTQgLSBnaWN2MjogbW1pbzogSUNQSURSMiBpcyByZWFk
LW9ubHkKb2sgNTUgLSBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogY29uc2lzdGVudCBwcmlvcml0
eSBtYXNraW5nCm9rIDU2IC0gZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGltcGxlbWVudHMgYXQg
bGVhc3QgNCBwcmlvcml0eSBiaXRzCm9rIDU3IC0gZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGNs
ZWFyaW5nIHByaW9yaXRpZXMKb2sgNTggLSBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogYWNjZXNz
ZXMgYmV5b25kIGxpbWl0IFJBWi9XSQpvayA1OSAtIGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBh
Y2Nlc3NpbmcgbGFzdCBTUElzCm9rIDYwIC0gZ2ljdjI6IG1taW86IElQUklPUklUWVI6IHByaW9y
aXRpZXMgYXJlIHByZXNlcnZlZApvayA2MSAtIGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBieXRl
IHJlYWRzIHN1Y2Nlc3NmdWwKb2sgNjIgLSBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogYnl0ZSB3
cml0ZXMgc3VjY2Vzc2Z1bApvayA2MyAtIGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IGJpdHMgZm9y
IG5vbi1leGlzdGVudCBDUFVzIG1hc2tlZApvayA2NCAtIGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6
IGFjY2Vzc2VzIGJleW9uZCBsaW1pdCBSQVovV0kKb2sgNjUgLSBnaWN2MjogbW1pbzogSVRBUkdF
VFNSOiByZWdpc3RlciBjb250ZW50IHByZXNlcnZlZApvayA2NiAtIGdpY3YyOiBtbWlvOiBJVEFS
R0VUU1I6IGJ5dGUgcmVhZHMgc3VjY2Vzc2Z1bApvayA2NyAtIGdpY3YyOiBtbWlvOiBJVEFSR0VU
U1I6IGJ5dGUgd3JpdGVzIHN1Y2Nlc3NmdWwKb2sgNjggLSBnaWN2MjogYWN0aXZlOiBzZWxmOiBJ
UEk6IHNlbGYKb2sgNjkgLSBwc2NpOiBpbnZhbGlkLWZ1bmN0aW9uCm9rIDcwIC0gcHNjaTogYWZm
aW5pdHktaW5mby1vbgpvayA3MSAtIHBzY2k6IGFmZmluaXR5LWluZm8tb2ZmCm9rIDcyIC0gcHNj
aTogY3B1LW9uCm9rIDczIC0gdnRpbWVyLWJ1c3ktbG9vcDogbm90IHBlbmRpbmcgYmVmb3JlCm9r
IDc0IC0gdnRpbWVyLWJ1c3ktbG9vcDogaW50ZXJydXB0IHNpZ25hbCBwZW5kaW5nCm9rIDc1IC0g
dnRpbWVyLWJ1c3ktbG9vcDogaW50ZXJydXB0IHNpZ25hbCBubyBsb25nZXIgcGVuZGluZwpvayA3
NiAtIHZ0aW1lci1idXN5LWxvb3A6IGxhdGVuY3kgd2l0aGluIDEwIG1zCm9rIDc3IC0gdnRpbWVy
LWJ1c3ktbG9vcDogaW50ZXJydXB0IHJlY2VpdmVkCm9rIDc4IC0gdnRpbWVyLWJ1c3ktbG9vcDog
aW50ZXJydXB0IHJlY2VpdmVkIGFmdGVyIFRWQUwvV0ZJCm9rIDc5IC0gdnRpbWVyLWJ1c3ktbG9v
cDogdGltZXIgaGFzIGV4cGlyZWQKb2sgODAgLSBwdGltZXItYnVzeS1sb29wOiBub3QgcGVuZGlu
ZyBiZWZvcmUKb2sgODEgLSBwdGltZXItYnVzeS1sb29wOiBpbnRlcnJ1cHQgc2lnbmFsIHBlbmRp
bmcKb2sgODIgLSBwdGltZXItYnVzeS1sb29wOiBpbnRlcnJ1cHQgc2lnbmFsIG5vIGxvbmdlciBw
ZW5kaW5nCm9rIDgzIC0gcHRpbWVyLWJ1c3ktbG9vcDogbGF0ZW5jeSB3aXRoaW4gMTAgbXMKb2sg
ODQgLSBwdGltZXItYnVzeS1sb29wOiBpbnRlcnJ1cHQgcmVjZWl2ZWQKb2sgODUgLSBwdGltZXIt
YnVzeS1sb29wOiBpbnRlcnJ1cHQgcmVjZWl2ZWQgYWZ0ZXIgVFZBTC9XRkkKb2sgODYgLSBwdGlt
ZXItYnVzeS1sb29wOiB0aW1lciBoYXMgZXhwaXJlZApvayA4NyAtIElEQy1ESUM6IGNvZGUgZ2Vu
ZXJhdGlvbgoxLi44NworIGxzIGxvZ3MvY2FjaGUubG9nIGxvZ3MvZ2ljdjItYWN0aXZlLmxvZyBs
b2dzL2dpY3YyLWlwaS5sb2cgbG9ncy9naWN2Mi1tbWlvLTNwLmxvZyBsb2dzL2dpY3YyLW1taW8t
dXAubG9nIGxvZ3MvZ2ljdjItbW1pby5sb2cgbG9ncy9naWN2My1hY3RpdmUubG9nIGxvZ3MvZ2lj
djMtaXBpLmxvZyBsb2dzL21pY3JvLWJlbmNoLmxvZyBsb2dzL3BjaS10ZXN0LmxvZyBsb2dzL3Bt
dS5sb2cgbG9ncy9wc2NpLmxvZyBsb2dzL3NlbGZ0ZXN0LXNldHVwLmxvZyBsb2dzL3NlbGZ0ZXN0
LXNtcC5sb2cgbG9ncy9zZWxmdGVzdC12ZWN0b3JzLWtlcm5lbC5sb2cgbG9ncy9zZWxmdGVzdC12
ZWN0b3JzLXVzZXIubG9nIGxvZ3MvdGltZXIubG9nCmxvZ3MvY2FjaGUubG9nCQlsb2dzL2dpY3Yz
LWFjdGl2ZS5sb2cgIGxvZ3Mvc2VsZnRlc3Qtc2V0dXAubG9nCmxvZ3MvZ2ljdjItYWN0aXZlLmxv
Zwlsb2dzL2dpY3YzLWlwaS5sb2cgICAgIGxvZ3Mvc2VsZnRlc3Qtc21wLmxvZwpsb2dzL2dpY3Yy
LWlwaS5sb2cJbG9ncy9taWNyby1iZW5jaC5sb2cgICBsb2dzL3NlbGZ0ZXN0LXZlY3RvcnMta2Vy
bmVsLmxvZwpsb2dzL2dpY3YyLW1taW8tM3AubG9nCWxvZ3MvcGNpLXRlc3QubG9nICAgICAgbG9n
cy9zZWxmdGVzdC12ZWN0b3JzLXVzZXIubG9nCmxvZ3MvZ2ljdjItbW1pby11cC5sb2cJbG9ncy9w
bXUubG9nCSAgICAgICBsb2dzL3RpbWVyLmxvZwpsb2dzL2dpY3YyLW1taW8ubG9nCWxvZ3MvcHNj
aS5sb2cKKyBjYXQgbG9ncy9jYWNoZS5sb2cgbG9ncy9naWN2Mi1hY3RpdmUubG9nIGxvZ3MvZ2lj
djItaXBpLmxvZyBsb2dzL2dpY3YyLW1taW8tM3AubG9nIGxvZ3MvZ2ljdjItbW1pby11cC5sb2cg
bG9ncy9naWN2Mi1tbWlvLmxvZyBsb2dzL2dpY3YzLWFjdGl2ZS5sb2cgbG9ncy9naWN2My1pcGku
bG9nIGxvZ3MvbWljcm8tYmVuY2gubG9nIGxvZ3MvcGNpLXRlc3QubG9nIGxvZ3MvcG11LmxvZyBs
b2dzL3BzY2kubG9nIGxvZ3Mvc2VsZnRlc3Qtc2V0dXAubG9nIGxvZ3Mvc2VsZnRlc3Qtc21wLmxv
ZyBsb2dzL3NlbGZ0ZXN0LXZlY3RvcnMta2VybmVsLmxvZyBsb2dzL3NlbGZ0ZXN0LXZlY3RvcnMt
dXNlci5sb2cgbG9ncy90aW1lci5sb2cKdGltZW91dCAtayAxcyAtLWZvcmVncm91bmQgOTBzIC91
c3IvYmluL3FlbXUtc3lzdGVtLWFhcmNoNjQgLW5vZGVmYXVsdHMgLW1hY2hpbmUgdmlydCxnaWMt
dmVyc2lvbj1ob3N0LGFjY2VsPWt2bSAtY3B1IGhvc3QgLWRldmljZSB2aXJ0aW8tc2VyaWFsLWRl
dmljZSAtZGV2aWNlIHZpcnRjb25zb2xlLGNoYXJkZXY9Y3RkIC1jaGFyZGV2IHRlc3RkZXYsaWQ9
Y3RkIC1kZXZpY2UgcGNpLXRlc3RkZXYgLWRpc3BsYXkgbm9uZSAtc2VyaWFsIHN0ZGlvIC1rZXJu
ZWwgYXJtL2NhY2hlLmZsYXQgLXNtcCAxICMgLWluaXRyZCAvdG1wL3RtcC5tOTlDTTZndVk0CklO
Rk86IElEQy1ESUM6IGRjYWNoZSBjbGVhbiB0byBQb1UgcmVxdWlyZWQKSU5GTzogSURDLURJQzog
aWNhY2hlIGludmFsaWRhdGlvbiB0byBQb1UgcmVxdWlyZWQKUEFTUzogSURDLURJQzogY29kZSBn
ZW5lcmF0aW9uClNVTU1BUlk6IDEgdGVzdHMKdGltZW91dCAtayAxcyAtLWZvcmVncm91bmQgOTBz
IC91c3IvYmluL3FlbXUtc3lzdGVtLWFhcmNoNjQgLW5vZGVmYXVsdHMgLW1hY2hpbmUgdmlydCxn
aWMtdmVyc2lvbj1ob3N0LGFjY2VsPWt2bSAtY3B1IGhvc3QgLWRldmljZSB2aXJ0aW8tc2VyaWFs
LWRldmljZSAtZGV2aWNlIHZpcnRjb25zb2xlLGNoYXJkZXY9Y3RkIC1jaGFyZGV2IHRlc3RkZXYs
aWQ9Y3RkIC1kZXZpY2UgcGNpLXRlc3RkZXYgLWRpc3BsYXkgbm9uZSAtc2VyaWFsIHN0ZGlvIC1r
ZXJuZWwgYXJtL2dpYy5mbGF0IC1zbXAgNiAtbWFjaGluZSBnaWMtdmVyc2lvbj0yIC1hcHBlbmQg
YWN0aXZlICMgLWluaXRyZCAvdG1wL3RtcC5UNEF3UmU1c0RNClBBU1M6IGdpY3YyOiBhY3RpdmU6
IHNlbGY6IElQSTogc2VsZgpTVU1NQVJZOiAxIHRlc3RzCnRpbWVvdXQgLWsgMXMgLS1mb3JlZ3Jv
dW5kIDkwcyAvdXNyL2Jpbi9xZW11LXN5c3RlbS1hYXJjaDY0IC1ub2RlZmF1bHRzIC1tYWNoaW5l
IHZpcnQsZ2ljLXZlcnNpb249aG9zdCxhY2NlbD1rdm0gLWNwdSBob3N0IC1kZXZpY2UgdmlydGlv
LXNlcmlhbC1kZXZpY2UgLWRldmljZSB2aXJ0Y29uc29sZSxjaGFyZGV2PWN0ZCAtY2hhcmRldiB0
ZXN0ZGV2LGlkPWN0ZCAtZGV2aWNlIHBjaS10ZXN0ZGV2IC1kaXNwbGF5IG5vbmUgLXNlcmlhbCBz
dGRpbyAta2VybmVsIGFybS9naWMuZmxhdCAtc21wIDYgLW1hY2hpbmUgZ2ljLXZlcnNpb249MiAt
YXBwZW5kIGlwaSAjIC1pbml0cmQgL3RtcC90bXAuTG0xdEtLTnJTNgpQQVNTOiBnaWN2MjogaXBp
OiBzZWxmOiBJUEk6IHNlbGYKUEFTUzogZ2ljdjI6IGlwaTogdGFyZ2V0LWxpc3Q6IElQSTogZGly
ZWN0ZWQKUEFTUzogZ2ljdjI6IGlwaTogYnJvYWRjYXN0OiBJUEk6IGJyb2FkY2FzdApTVU1NQVJZ
OiAzIHRlc3RzCnRpbWVvdXQgLWsgMXMgLS1mb3JlZ3JvdW5kIDkwcyAvdXNyL2Jpbi9xZW11LXN5
c3RlbS1hYXJjaDY0IC1ub2RlZmF1bHRzIC1tYWNoaW5lIHZpcnQsZ2ljLXZlcnNpb249aG9zdCxh
Y2NlbD1rdm0gLWNwdSBob3N0IC1kZXZpY2UgdmlydGlvLXNlcmlhbC1kZXZpY2UgLWRldmljZSB2
aXJ0Y29uc29sZSxjaGFyZGV2PWN0ZCAtY2hhcmRldiB0ZXN0ZGV2LGlkPWN0ZCAtZGV2aWNlIHBj
aS10ZXN0ZGV2IC1kaXNwbGF5IG5vbmUgLXNlcmlhbCBzdGRpbyAta2VybmVsIGFybS9naWMuZmxh
dCAtc21wIDMgLW1hY2hpbmUgZ2ljLXZlcnNpb249MiAtYXBwZW5kIG1taW8gIyAtaW5pdHJkIC90
bXAvdG1wLklSck56d1B3MlIKSU5GTzogZ2ljdjI6IG1taW86IG51bWJlciBvZiBpbXBsZW1lbnRl
ZCBTUElzOiAyNTYKSU5GTzogZ2ljdjI6IG1taW86IG5yX2NwdXM9MwpQQVNTOiBnaWN2MjogbW1p
bzogYWxsIENQVXMgaGF2ZSBpbnRlcnJ1cHRzCklORk86IGdpY3YyOiBtbWlvOiBJSURSOiAweDRi
MDAyNDNiClBBU1M6IGdpY3YyOiBtbWlvOiBHSUNEX1RZUEVSIGlzIHJlYWQtb25seQpQQVNTOiBn
aWN2MjogbW1pbzogR0lDRF9JSURSIGlzIHJlYWQtb25seQpQQVNTOiBnaWN2MjogbW1pbzogSUNQ
SURSMiBpcyByZWFkLW9ubHkKSU5GTzogZ2ljdjI6IG1taW86IHZhbHVlIG9mIElDUElEUjI6IDB4
MDAwMDAwMDAKUEFTUzogZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGNvbnNpc3RlbnQgcHJpb3Jp
dHkgbWFza2luZwpJTkZPOiBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogcHJpb3JpdHkgbWFzayBp
cyAweGY4ZjhmOGY4ClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBpbXBsZW1lbnRzIGF0
IGxlYXN0IDQgcHJpb3JpdHkgYml0cwpJTkZPOiBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogNSBw
cmlvcml0eSBiaXRzIGltcGxlbWVudGVkClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBj
bGVhcmluZyBwcmlvcml0aWVzClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBhY2Nlc3Nl
cyBiZXlvbmQgbGltaXQgUkFaL1dJClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBhY2Nl
c3NpbmcgbGFzdCBTUElzClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBwcmlvcml0aWVz
IGFyZSBwcmVzZXJ2ZWQKUEFTUzogZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGJ5dGUgcmVhZHMg
c3VjY2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogYnl0ZSB3cml0ZXMgc3Vj
Y2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBiaXRzIGZvciBub24tZXhpc3Rl
bnQgQ1BVcyBtYXNrZWQKSU5GTzogZ2ljdjI6IG1taW86IElUQVJHRVRTUjogNSBub24tZXhpc3Rl
bnQgQ1BVcwpQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBhY2Nlc3NlcyBiZXlvbmQgbGlt
aXQgUkFaL1dJClBBU1M6IGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IHJlZ2lzdGVyIGNvbnRlbnQg
cHJlc2VydmVkClBBU1M6IGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IGJ5dGUgcmVhZHMgc3VjY2Vz
c2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBieXRlIHdyaXRlcyBzdWNjZXNzZnVs
ClNVTU1BUlk6IDE3IHRlc3RzCnRpbWVvdXQgLWsgMXMgLS1mb3JlZ3JvdW5kIDkwcyAvdXNyL2Jp
bi9xZW11LXN5c3RlbS1hYXJjaDY0IC1ub2RlZmF1bHRzIC1tYWNoaW5lIHZpcnQsZ2ljLXZlcnNp
b249aG9zdCxhY2NlbD1rdm0gLWNwdSBob3N0IC1kZXZpY2UgdmlydGlvLXNlcmlhbC1kZXZpY2Ug
LWRldmljZSB2aXJ0Y29uc29sZSxjaGFyZGV2PWN0ZCAtY2hhcmRldiB0ZXN0ZGV2LGlkPWN0ZCAt
ZGV2aWNlIHBjaS10ZXN0ZGV2IC1kaXNwbGF5IG5vbmUgLXNlcmlhbCBzdGRpbyAta2VybmVsIGFy
bS9naWMuZmxhdCAtc21wIDEgLW1hY2hpbmUgZ2ljLXZlcnNpb249MiAtYXBwZW5kIG1taW8gIyAt
aW5pdHJkIC90bXAvdG1wLm1Ma3NIYWFYdkkKSU5GTzogZ2ljdjI6IG1taW86IG51bWJlciBvZiBp
bXBsZW1lbnRlZCBTUElzOiAyNTYKSU5GTzogZ2ljdjI6IG1taW86IG5yX2NwdXM9MQpQQVNTOiBn
aWN2MjogbW1pbzogYWxsIENQVXMgaGF2ZSBpbnRlcnJ1cHRzCklORk86IGdpY3YyOiBtbWlvOiBJ
SURSOiAweDRiMDAyNDNiClBBU1M6IGdpY3YyOiBtbWlvOiBHSUNEX1RZUEVSIGlzIHJlYWQtb25s
eQpQQVNTOiBnaWN2MjogbW1pbzogR0lDRF9JSURSIGlzIHJlYWQtb25seQpQQVNTOiBnaWN2Mjog
bW1pbzogSUNQSURSMiBpcyByZWFkLW9ubHkKSU5GTzogZ2ljdjI6IG1taW86IHZhbHVlIG9mIElD
UElEUjI6IDB4MDAwMDAwMDAKUEFTUzogZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGNvbnNpc3Rl
bnQgcHJpb3JpdHkgbWFza2luZwpJTkZPOiBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogcHJpb3Jp
dHkgbWFzayBpcyAweGY4ZjhmOGY4ClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBpbXBs
ZW1lbnRzIGF0IGxlYXN0IDQgcHJpb3JpdHkgYml0cwpJTkZPOiBnaWN2MjogbW1pbzogSVBSSU9S
SVRZUjogNSBwcmlvcml0eSBiaXRzIGltcGxlbWVudGVkClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJ
T1JJVFlSOiBjbGVhcmluZyBwcmlvcml0aWVzClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlS
OiBhY2Nlc3NlcyBiZXlvbmQgbGltaXQgUkFaL1dJClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJ
VFlSOiBhY2Nlc3NpbmcgbGFzdCBTUElzClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJVFlSOiBw
cmlvcml0aWVzIGFyZSBwcmVzZXJ2ZWQKUEFTUzogZ2ljdjI6IG1taW86IElQUklPUklUWVI6IGJ5
dGUgcmVhZHMgc3VjY2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVBSSU9SSVRZUjogYnl0ZSB3
cml0ZXMgc3VjY2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBiaXRzIGZvciBu
b24tZXhpc3RlbnQgQ1BVcyBtYXNrZWQKSU5GTzogZ2ljdjI6IG1taW86IElUQVJHRVRTUjogNyBu
b24tZXhpc3RlbnQgQ1BVcwpQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBhY2Nlc3NlcyBi
ZXlvbmQgbGltaXQgUkFaL1dJClBBU1M6IGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IHJlZ2lzdGVy
IGNvbnRlbnQgcHJlc2VydmVkClBBU1M6IGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6IGJ5dGUgcmVh
ZHMgc3VjY2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBieXRlIHdyaXRlcyBz
dWNjZXNzZnVsClNVTU1BUlk6IDE3IHRlc3RzCnRpbWVvdXQgLWsgMXMgLS1mb3JlZ3JvdW5kIDkw
cyAvdXNyL2Jpbi9xZW11LXN5c3RlbS1hYXJjaDY0IC1ub2RlZmF1bHRzIC1tYWNoaW5lIHZpcnQs
Z2ljLXZlcnNpb249aG9zdCxhY2NlbD1rdm0gLWNwdSBob3N0IC1kZXZpY2UgdmlydGlvLXNlcmlh
bC1kZXZpY2UgLWRldmljZSB2aXJ0Y29uc29sZSxjaGFyZGV2PWN0ZCAtY2hhcmRldiB0ZXN0ZGV2
LGlkPWN0ZCAtZGV2aWNlIHBjaS10ZXN0ZGV2IC1kaXNwbGF5IG5vbmUgLXNlcmlhbCBzdGRpbyAt
a2VybmVsIGFybS9naWMuZmxhdCAtc21wIDYgLW1hY2hpbmUgZ2ljLXZlcnNpb249MiAtYXBwZW5k
IG1taW8gIyAtaW5pdHJkIC90bXAvdG1wLnRib1JrWnZJUzQKSU5GTzogZ2ljdjI6IG1taW86IG51
bWJlciBvZiBpbXBsZW1lbnRlZCBTUElzOiAyNTYKSU5GTzogZ2ljdjI6IG1taW86IG5yX2NwdXM9
NgpQQVNTOiBnaWN2MjogbW1pbzogYWxsIENQVXMgaGF2ZSBpbnRlcnJ1cHRzCklORk86IGdpY3Yy
OiBtbWlvOiBJSURSOiAweDRiMDAyNDNiClBBU1M6IGdpY3YyOiBtbWlvOiBHSUNEX1RZUEVSIGlz
IHJlYWQtb25seQpQQVNTOiBnaWN2MjogbW1pbzogR0lDRF9JSURSIGlzIHJlYWQtb25seQpQQVNT
OiBnaWN2MjogbW1pbzogSUNQSURSMiBpcyByZWFkLW9ubHkKSU5GTzogZ2ljdjI6IG1taW86IHZh
bHVlIG9mIElDUElEUjI6IDB4MDAwMDAwMDAKUEFTUzogZ2ljdjI6IG1taW86IElQUklPUklUWVI6
IGNvbnNpc3RlbnQgcHJpb3JpdHkgbWFza2luZwpJTkZPOiBnaWN2MjogbW1pbzogSVBSSU9SSVRZ
UjogcHJpb3JpdHkgbWFzayBpcyAweGY4ZjhmOGY4ClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJT1JJ
VFlSOiBpbXBsZW1lbnRzIGF0IGxlYXN0IDQgcHJpb3JpdHkgYml0cwpJTkZPOiBnaWN2MjogbW1p
bzogSVBSSU9SSVRZUjogNSBwcmlvcml0eSBiaXRzIGltcGxlbWVudGVkClBBU1M6IGdpY3YyOiBt
bWlvOiBJUFJJT1JJVFlSOiBjbGVhcmluZyBwcmlvcml0aWVzClBBU1M6IGdpY3YyOiBtbWlvOiBJ
UFJJT1JJVFlSOiBhY2Nlc3NlcyBiZXlvbmQgbGltaXQgUkFaL1dJClBBU1M6IGdpY3YyOiBtbWlv
OiBJUFJJT1JJVFlSOiBhY2Nlc3NpbmcgbGFzdCBTUElzClBBU1M6IGdpY3YyOiBtbWlvOiBJUFJJ
T1JJVFlSOiBwcmlvcml0aWVzIGFyZSBwcmVzZXJ2ZWQKUEFTUzogZ2ljdjI6IG1taW86IElQUklP
UklUWVI6IGJ5dGUgcmVhZHMgc3VjY2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVBSSU9SSVRZ
UjogYnl0ZSB3cml0ZXMgc3VjY2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBi
aXRzIGZvciBub24tZXhpc3RlbnQgQ1BVcyBtYXNrZWQKSU5GTzogZ2ljdjI6IG1taW86IElUQVJH
RVRTUjogMiBub24tZXhpc3RlbnQgQ1BVcwpQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBh
Y2Nlc3NlcyBiZXlvbmQgbGltaXQgUkFaL1dJClBBU1M6IGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6
IHJlZ2lzdGVyIGNvbnRlbnQgcHJlc2VydmVkClBBU1M6IGdpY3YyOiBtbWlvOiBJVEFSR0VUU1I6
IGJ5dGUgcmVhZHMgc3VjY2Vzc2Z1bApQQVNTOiBnaWN2MjogbW1pbzogSVRBUkdFVFNSOiBieXRl
IHdyaXRlcyBzdWNjZXNzZnVsClNVTU1BUlk6IDE3IHRlc3RzCnRpbWVvdXQgLWsgMXMgLS1mb3Jl
Z3JvdW5kIDkwcyAvdXNyL2Jpbi9xZW11LXN5c3RlbS1hYXJjaDY0IC1ub2RlZmF1bHRzIC1tYWNo
aW5lIHZpcnQsZ2ljLXZlcnNpb249aG9zdCxhY2NlbD1rdm0gLWNwdSBob3N0IC1kZXZpY2Ugdmly
dGlvLXNlcmlhbC1kZXZpY2UgLWRldmljZSB2aXJ0Y29uc29sZSxjaGFyZGV2PWN0ZCAtY2hhcmRl
diB0ZXN0ZGV2LGlkPWN0ZCAtZGV2aWNlIHBjaS10ZXN0ZGV2IC1kaXNwbGF5IG5vbmUgLXNlcmlh
bCBzdGRpbyAta2VybmVsIF9OT19GSUxFXzRVaGVyZV8gLXNtcCA2IC1tYWNoaW5lIGdpYy12ZXJz
aW9uPTMgLWFwcGVuZCBhY3RpdmUgIyAtaW5pdHJkIC90bXAvdG1wLk42ZDVrbGdsdGQKcWVtdS1z
eXN0ZW0tYWFyY2g2NDogSW5pdGlhbGl6YXRpb24gb2YgZGV2aWNlIGt2bS1hcm0tZ2ljdjMgZmFp
bGVkOiBlcnJvciBjcmVhdGluZyBpbi1rZXJuZWwgVkdJQzogTm8gc3VjaCBkZXZpY2UKdGltZW91
dCAtayAxcyAtLWZvcmVncm91bmQgOTBzIC91c3IvYmluL3FlbXUtc3lzdGVtLWFhcmNoNjQgLW5v
ZGVmYXVsdHMgLW1hY2hpbmUgdmlydCxnaWMtdmVyc2lvbj1ob3N0LGFjY2VsPWt2bSAtY3B1IGhv
c3QgLWRldmljZSB2aXJ0aW8tc2VyaWFsLWRldmljZSAtZGV2aWNlIHZpcnRjb25zb2xlLGNoYXJk
ZXY9Y3RkIC1jaGFyZGV2IHRlc3RkZXYsaWQ9Y3RkIC1kZXZpY2UgcGNpLXRlc3RkZXYgLWRpc3Bs
YXkgbm9uZSAtc2VyaWFsIHN0ZGlvIC1rZXJuZWwgX05PX0ZJTEVfNFVoZXJlXyAtc21wIDYgLW1h
Y2hpbmUgZ2ljLXZlcnNpb249MyAtYXBwZW5kIGlwaSAjIC1pbml0cmQgL3RtcC90bXAuUFVJMFZ2
SEV1VApxZW11LXN5c3RlbS1hYXJjaDY0OiBJbml0aWFsaXphdGlvbiBvZiBkZXZpY2Uga3ZtLWFy
bS1naWN2MyBmYWlsZWQ6IGVycm9yIGNyZWF0aW5nIGluLWtlcm5lbCBWR0lDOiBObyBzdWNoIGRl
dmljZQp0aW1lb3V0IC1rIDFzIC0tZm9yZWdyb3VuZCA5MHMgL3Vzci9iaW4vcWVtdS1zeXN0ZW0t
YWFyY2g2NCAtbm9kZWZhdWx0cyAtbWFjaGluZSB2aXJ0LGdpYy12ZXJzaW9uPWhvc3QsYWNjZWw9
a3ZtIC1jcHUgaG9zdCAtZGV2aWNlIHZpcnRpby1zZXJpYWwtZGV2aWNlIC1kZXZpY2UgdmlydGNv
bnNvbGUsY2hhcmRldj1jdGQgLWNoYXJkZXYgdGVzdGRldixpZD1jdGQgLWRldmljZSBwY2ktdGVz
dGRldiAtZGlzcGxheSBub25lIC1zZXJpYWwgc3RkaW8gLWtlcm5lbCBhcm0vbWljcm8tYmVuY2gu
ZmxhdCAtc21wIDIgIyAtaW5pdHJkIC90bXAvdG1wLnVycWxNc0JwSmQKVGltZXIgRnJlcXVlbmN5
IDUwMDAwMDAwIEh6IChPdXRwdXQgaW4gbWljcm9zZWNvbmRzKQpuYW1lICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgdG90YWwgbnMgICAgICAgICAgICAgICAgICAgICAgICAgYXZn
IG5zCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCmh2YyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIDI5NjkxNTQ0MC4wICAgICAgICAgICAgICAgICAgICAgICAgIDQ1
MzAuMAptbWlvX3JlYWRfdXNlciAgICAgICAgICAgICAgICAgICAgIDEzMjIzMjUxMDAuMCAgICAg
ICAgICAgICAgICAgICAgICAgIDIwMTc3LjAKbW1pb19yZWFkX3ZnaWMgICAgICAgICAgICAgICAg
ICAgICAgNDYyMjU1NDYwLjAgICAgICAgICAgICAgICAgICAgICAgICAgNzA1My4wCmVvaSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgNjc3OTg4MC4wICAgICAgICAgICAgICAgICAg
ICAgICAgICAxMDMuMApxZW11LXN5c3RlbS1hYXJjaDY0OiB0ZXJtaW5hdGluZyBvbiBzaWduYWwg
MTUgZnJvbSBwaWQgMzA5NyAodGltZW91dCkKdGltZW91dCAtayAxcyAtLWZvcmVncm91bmQgOTBz
IC91c3IvYmluL3FlbXUtc3lzdGVtLWFhcmNoNjQgLW5vZGVmYXVsdHMgLW1hY2hpbmUgdmlydCxn
aWMtdmVyc2lvbj1ob3N0LGFjY2VsPWt2bSAtY3B1IGhvc3QgLWRldmljZSB2aXJ0aW8tc2VyaWFs
LWRldmljZSAtZGV2aWNlIHZpcnRjb25zb2xlLGNoYXJkZXY9Y3RkIC1jaGFyZGV2IHRlc3RkZXYs
aWQ9Y3RkIC1kZXZpY2UgcGNpLXRlc3RkZXYgLWRpc3BsYXkgbm9uZSAtc2VyaWFsIHN0ZGlvIC1r
ZXJuZWwgYXJtL3BjaS10ZXN0LmZsYXQgLXNtcCAxICMgLWluaXRyZCAvdG1wL3RtcC43YnBxdlJX
RjhaCjAwLjAwLjAgMWIzNjowMDA4IHR5cGUgMDAgcHJvZ2lmIDAwIGNsYXNzIDA2IHN1YmNsYXNz
IDAwCjAwLjAxLjAgMWIzNjowMDA1IHR5cGUgMDAgcHJvZ2lmIDAwIGNsYXNzIDAwIHN1YmNsYXNz
IGZmCkJBUiMwIFsxMDAwMDAwMC0xMDAwMGZmZiBNRU0zMl0KQkFSIzEgWzNlZmYwMDAwLTNlZmYw
MGZmIFBJT10KcGNpLXRlc3RkZXYgbWVtOiBtbWlvLW5vLWV2ZW50ZmQKcGNpLXRlc3RkZXYgbWVt
OiBtbWlvLXdpbGRjYXJkLWV2ZW50ZmQKcGNpLXRlc3RkZXYgbWVtOiBtbWlvLWRhdGFtYXRjaC1l
dmVudGZkCnBjaS10ZXN0ZGV2ICBpbzogcG9ydGlvLW5vLWV2ZW50ZmQKcGNpLXRlc3RkZXYgIGlv
OiBwb3J0aW8td2lsZGNhcmQtZXZlbnRmZApwY2ktdGVzdGRldiAgaW86IHBvcnRpby1kYXRhbWF0
Y2gtZXZlbnRmZApQQVNTOiBwY2k6IFBDSSB0ZXN0IGRldmljZSBwYXNzZWQgNi82IHRlc3RzClNV
TU1BUlk6IDEgdGVzdHMKdGltZW91dCAtayAxcyAtLWZvcmVncm91bmQgOTBzIC91c3IvYmluL3Fl
bXUtc3lzdGVtLWFhcmNoNjQgLW5vZGVmYXVsdHMgLW1hY2hpbmUgdmlydCxnaWMtdmVyc2lvbj1o
b3N0LGFjY2VsPWt2bSAtY3B1IGhvc3QgLWRldmljZSB2aXJ0aW8tc2VyaWFsLWRldmljZSAtZGV2
aWNlIHZpcnRjb25zb2xlLGNoYXJkZXY9Y3RkIC1jaGFyZGV2IHRlc3RkZXYsaWQ9Y3RkIC1kZXZp
Y2UgcGNpLXRlc3RkZXYgLWRpc3BsYXkgbm9uZSAtc2VyaWFsIHN0ZGlvIC1rZXJuZWwgYXJtL3Bt
dS5mbGF0IC1zbXAgMSAjIC1pbml0cmQgL3RtcC90bXAuWkowNWxSdmdjNApJTkZPOiBQTVUgdmVy
c2lvbjogMwpJTkZPOiBwbXU6IFBNVSBpbXBsZW1lbnRlci9JRCBjb2RlL2NvdW50ZXJzOiAweDQx
KFwiQVwiKS8weDMvNgpQQVNTOiBwbXU6IENvbnRyb2wgcmVnaXN0ZXIKUmVhZCAwIHRoZW4gMC4K
RkFJTDogcG11OiBNb25vdG9uaWNhbGx5IGluY3JlYXNpbmcgY3ljbGUgY291bnQKaW5zdHJzIDog
Y3ljbGVzMCBjeWNsZXMxIC4uLgo0OiAgICAwCmN5Y2xlcyBub3QgaW5jcmVtZW50aW5nIQpGQUlM
OiBwbXU6IEN5Y2xlL2luc3RydWN0aW9uIHJhdGlvClNVTU1BUlk6IDMgdGVzdHMsIDIgdW5leHBl
Y3RlZCBmYWlsdXJlcwp0aW1lb3V0IC1rIDFzIC0tZm9yZWdyb3VuZCA5MHMgL3Vzci9iaW4vcWVt
dS1zeXN0ZW0tYWFyY2g2NCAtbm9kZWZhdWx0cyAtbWFjaGluZSB2aXJ0LGdpYy12ZXJzaW9uPWhv
c3QsYWNjZWw9a3ZtIC1jcHUgaG9zdCAtZGV2aWNlIHZpcnRpby1zZXJpYWwtZGV2aWNlIC1kZXZp
Y2UgdmlydGNvbnNvbGUsY2hhcmRldj1jdGQgLWNoYXJkZXYgdGVzdGRldixpZD1jdGQgLWRldmlj
ZSBwY2ktdGVzdGRldiAtZGlzcGxheSBub25lIC1zZXJpYWwgc3RkaW8gLWtlcm5lbCBhcm0vcHNj
aS5mbGF0IC1zbXAgNiAjIC1pbml0cmQgL3RtcC90bXAuRjFDYldEN3dMbwpJTkZPOiBwc2NpOiBQ
U0NJIHZlcnNpb24gMS4wClBBU1M6IHBzY2k6IGludmFsaWQtZnVuY3Rpb24KUEFTUzogcHNjaTog
YWZmaW5pdHktaW5mby1vbgpQQVNTOiBwc2NpOiBhZmZpbml0eS1pbmZvLW9mZgpQQVNTOiBwc2Np
OiBjcHUtb24KU1VNTUFSWTogNCB0ZXN0cwp0aW1lb3V0IC1rIDFzIC0tZm9yZWdyb3VuZCA5MHMg
L3Vzci9iaW4vcWVtdS1zeXN0ZW0tYWFyY2g2NCAtbm9kZWZhdWx0cyAtbWFjaGluZSB2aXJ0LGdp
Yy12ZXJzaW9uPWhvc3QsYWNjZWw9a3ZtIC1jcHUgaG9zdCAtZGV2aWNlIHZpcnRpby1zZXJpYWwt
ZGV2aWNlIC1kZXZpY2UgdmlydGNvbnNvbGUsY2hhcmRldj1jdGQgLWNoYXJkZXYgdGVzdGRldixp
ZD1jdGQgLWRldmljZSBwY2ktdGVzdGRldiAtZGlzcGxheSBub25lIC1zZXJpYWwgc3RkaW8gLWtl
cm5lbCBhcm0vc2VsZnRlc3QuZmxhdCAtc21wIDIgLW0gMjU2IC1hcHBlbmQgc2V0dXAgc21wPTIg
bWVtPTI1NiAjIC1pbml0cmQgL3RtcC90bXAuVk5pQk9TZ005SApQQVNTOiBzZWxmdGVzdDogc2V0
dXA6IHNtcDogbnVtYmVyIG9mIENQVXMgbWF0Y2hlcyBleHBlY3RhdGlvbgpJTkZPOiBzZWxmdGVz
dDogc2V0dXA6IHNtcDogZm91bmQgMiBDUFVzClBBU1M6IHNlbGZ0ZXN0OiBzZXR1cDogbWVtOiBt
ZW1vcnkgc2l6ZSBtYXRjaGVzIGV4cGVjdGF0aW9uCklORk86IHNlbGZ0ZXN0OiBzZXR1cDogbWVt
OiBmb3VuZCAyNTYgTUIKU1VNTUFSWTogMiB0ZXN0cwp0aW1lb3V0IC1rIDFzIC0tZm9yZWdyb3Vu
ZCA5MHMgL3Vzci9iaW4vcWVtdS1zeXN0ZW0tYWFyY2g2NCAtbm9kZWZhdWx0cyAtbWFjaGluZSB2
aXJ0LGdpYy12ZXJzaW9uPWhvc3QsYWNjZWw9a3ZtIC1jcHUgaG9zdCAtZGV2aWNlIHZpcnRpby1z
ZXJpYWwtZGV2aWNlIC1kZXZpY2UgdmlydGNvbnNvbGUsY2hhcmRldj1jdGQgLWNoYXJkZXYgdGVz
dGRldixpZD1jdGQgLWRldmljZSBwY2ktdGVzdGRldiAtZGlzcGxheSBub25lIC1zZXJpYWwgc3Rk
aW8gLWtlcm5lbCBhcm0vc2VsZnRlc3QuZmxhdCAtc21wIDYgLWFwcGVuZCBzbXAgIyAtaW5pdHJk
IC90bXAvdG1wLk9vVjNHbjZ3YWMKUFNDSSB2ZXJzaW9uIDEuMApQQVNTOiBzZWxmdGVzdDogc21w
OiBQU0NJIHZlcnNpb24KSU5GTzogc2VsZnRlc3Q6IHNtcDogQ1BVICAxOiBNUElEUj0wMDgwMDAw
MDAxCklORk86IHNlbGZ0ZXN0OiBzbXA6IENQVSAgMjogTVBJRFI9MDA4MDAwMDAwMgpJTkZPOiBz
ZWxmdGVzdDogc21wOiBDUFUgIDM6IE1QSURSPTAwODAwMDAwMDMKSU5GTzogc2VsZnRlc3Q6IHNt
cDogQ1BVICA0OiBNUElEUj0wMDgwMDAwMDA0CklORk86IHNlbGZ0ZXN0OiBzbXA6IENQVSAgMDog
TVBJRFI9MDA4MDAwMDAwMApJTkZPOiBzZWxmdGVzdDogc21wOiBDUFUgIDU6IE1QSURSPTAwODAw
MDAwMDUKUEFTUzogc2VsZnRlc3Q6IHNtcDogTVBJRFIgdGVzdCBvbiBhbGwgQ1BVcwpJTkZPOiBz
ZWxmdGVzdDogc21wOiA2IENQVXMgcmVwb3J0ZWQgYmFjawpTVU1NQVJZOiAyIHRlc3RzCnRpbWVv
dXQgLWsgMXMgLS1mb3JlZ3JvdW5kIDkwcyAvdXNyL2Jpbi9xZW11LXN5c3RlbS1hYXJjaDY0IC1u
b2RlZmF1bHRzIC1tYWNoaW5lIHZpcnQsZ2ljLXZlcnNpb249aG9zdCxhY2NlbD1rdm0gLWNwdSBo
b3N0IC1kZXZpY2UgdmlydGlvLXNlcmlhbC1kZXZpY2UgLWRldmljZSB2aXJ0Y29uc29sZSxjaGFy
ZGV2PWN0ZCAtY2hhcmRldiB0ZXN0ZGV2LGlkPWN0ZCAtZGV2aWNlIHBjaS10ZXN0ZGV2IC1kaXNw
bGF5IG5vbmUgLXNlcmlhbCBzdGRpbyAta2VybmVsIGFybS9zZWxmdGVzdC5mbGF0IC1zbXAgMSAt
YXBwZW5kIHZlY3RvcnMta2VybmVsICMgLWluaXRyZCAvdG1wL3RtcC5kQmt1YmNDdjdxClBBU1M6
IHNlbGZ0ZXN0OiB2ZWN0b3JzLWtlcm5lbDogdW5kClBBU1M6IHNlbGZ0ZXN0OiB2ZWN0b3JzLWtl
cm5lbDogc3ZjClBBU1M6IHNlbGZ0ZXN0OiB2ZWN0b3JzLWtlcm5lbDogcGFidApTVU1NQVJZOiAz
IHRlc3RzCnRpbWVvdXQgLWsgMXMgLS1mb3JlZ3JvdW5kIDkwcyAvdXNyL2Jpbi9xZW11LXN5c3Rl
bS1hYXJjaDY0IC1ub2RlZmF1bHRzIC1tYWNoaW5lIHZpcnQsZ2ljLXZlcnNpb249aG9zdCxhY2Nl
bD1rdm0gLWNwdSBob3N0IC1kZXZpY2UgdmlydGlvLXNlcmlhbC1kZXZpY2UgLWRldmljZSB2aXJ0
Y29uc29sZSxjaGFyZGV2PWN0ZCAtY2hhcmRldiB0ZXN0ZGV2LGlkPWN0ZCAtZGV2aWNlIHBjaS10
ZXN0ZGV2IC1kaXNwbGF5IG5vbmUgLXNlcmlhbCBzdGRpbyAta2VybmVsIGFybS9zZWxmdGVzdC5m
bGF0IC1zbXAgMSAtYXBwZW5kIHZlY3RvcnMtdXNlciAjIC1pbml0cmQgL3RtcC90bXAuc1l6TlZV
NGRQdApQQVNTOiBzZWxmdGVzdDogdmVjdG9ycy11c2VyOiB1bmQKUEFTUzogc2VsZnRlc3Q6IHZl
Y3RvcnMtdXNlcjogc3ZjClNVTU1BUlk6IDIgdGVzdHMKdGltZW91dCAtayAxcyAtLWZvcmVncm91
bmQgMnMgL3Vzci9iaW4vcWVtdS1zeXN0ZW0tYWFyY2g2NCAtbm9kZWZhdWx0cyAtbWFjaGluZSB2
aXJ0LGdpYy12ZXJzaW9uPWhvc3QsYWNjZWw9a3ZtIC1jcHUgaG9zdCAtZGV2aWNlIHZpcnRpby1z
ZXJpYWwtZGV2aWNlIC1kZXZpY2UgdmlydGNvbnNvbGUsY2hhcmRldj1jdGQgLWNoYXJkZXYgdGVz
dGRldixpZD1jdGQgLWRldmljZSBwY2ktdGVzdGRldiAtZGlzcGxheSBub25lIC1zZXJpYWwgc3Rk
aW8gLWtlcm5lbCBhcm0vdGltZXIuZmxhdCAtc21wIDEgIyAtaW5pdHJkIC90bXAvdG1wLm4wMnVl
NWp6b24KQ05URlJRX0VMMCAgIDogMHgwMDAwMDAwMDAyZmFmMDgwCkNOVFBDVF9FTDAgICA6IDB4
MDAwMDAwMDI4MzM2OThiNgpDTlRQX0NUTF9FTDAgOiAweDAwMDAwMDAwMDAwMDAwMDQKQ05UUF9D
VkFMX0VMMDogMHgwMDAwMDAwMDAwMDAwMDAwCkNOVFZDVF9FTDAgICA6IDB4MDAwMDAwMDAwMTA0
M2M5OApDTlRWX0NUTF9FTDAgOiAweDAwMDAwMDAwMDAwMDAwMDAKQ05UVl9DVkFMX0VMMDogMHgw
MDAwMDAwMDAwMDAwMDAwClBBU1M6IHZ0aW1lci1idXN5LWxvb3A6IG5vdCBwZW5kaW5nIGJlZm9y
ZQpQQVNTOiB2dGltZXItYnVzeS1sb29wOiBpbnRlcnJ1cHQgc2lnbmFsIHBlbmRpbmcKUEFTUzog
dnRpbWVyLWJ1c3ktbG9vcDogaW50ZXJydXB0IHNpZ25hbCBubyBsb25nZXIgcGVuZGluZwpJTkZP
OiB2dGltZXItYnVzeS1sb29wOiBBZnRlciB0aW1lcjogMHgwMDAwMDAwMDAxMjY1YzMxCklORk86
IHZ0aW1lci1idXN5LWxvb3A6IEV4cGVjdGVkICAgOiAweDAwMDAwMDAwMDEyNjU5ZDEKSU5GTzog
dnRpbWVyLWJ1c3ktbG9vcDogRGlmZmVyZW5jZSA6IDEyIHVzClBBU1M6IHZ0aW1lci1idXN5LWxv
b3A6IGxhdGVuY3kgd2l0aGluIDEwIG1zClBBU1M6IHZ0aW1lci1idXN5LWxvb3A6IGludGVycnVw
dCByZWNlaXZlZApJTkZPOiB2dGltZXItYnVzeS1sb29wOiB3YWl0aW5nIGZvciBpbnRlcnJ1cHQu
Li4KUEFTUzogdnRpbWVyLWJ1c3ktbG9vcDogaW50ZXJydXB0IHJlY2VpdmVkIGFmdGVyIFRWQUwv
V0ZJClBBU1M6IHZ0aW1lci1idXN5LWxvb3A6IHRpbWVyIGhhcyBleHBpcmVkCklORk86IHZ0aW1l
ci1idXN5LWxvb3A6IFRWQUwgaXMgLTE4NDggdGlja3MKUEFTUzogcHRpbWVyLWJ1c3ktbG9vcDog
bm90IHBlbmRpbmcgYmVmb3JlClBBU1M6IHB0aW1lci1idXN5LWxvb3A6IGludGVycnVwdCBzaWdu
YWwgcGVuZGluZwpQQVNTOiBwdGltZXItYnVzeS1sb29wOiBpbnRlcnJ1cHQgc2lnbmFsIG5vIGxv
bmdlciBwZW5kaW5nCklORk86IHB0aW1lci1idXN5LWxvb3A6IEFmdGVyIHRpbWVyOiAweDAwMDAw
MDAyODNhYjQxMmIKSU5GTzogcHRpbWVyLWJ1c3ktbG9vcDogRXhwZWN0ZWQgICA6IDB4MDAwMDAw
MDI4M2FiM2M0NwpJTkZPOiBwdGltZXItYnVzeS1sb29wOiBEaWZmZXJlbmNlIDogMjUgdXMKUEFT
UzogcHRpbWVyLWJ1c3ktbG9vcDogbGF0ZW5jeSB3aXRoaW4gMTAgbXMKUEFTUzogcHRpbWVyLWJ1
c3ktbG9vcDogaW50ZXJydXB0IHJlY2VpdmVkCklORk86IHB0aW1lci1idXN5LWxvb3A6IHdhaXRp
bmcgZm9yIGludGVycnVwdC4uLgpQQVNTOiBwdGltZXItYnVzeS1sb29wOiBpbnRlcnJ1cHQgcmVj
ZWl2ZWQgYWZ0ZXIgVFZBTC9XRkkKUEFTUzogcHRpbWVyLWJ1c3ktbG9vcDogdGltZXIgaGFzIGV4
cGlyZWQKSU5GTzogcHRpbWVyLWJ1c3ktbG9vcDogVFZBTCBpcyAtMjM2NSB0aWNrcwpTVU1NQVJZ
OiAxNCB0ZXN0cwo=
--000000000000cfa520059f553cdc--
