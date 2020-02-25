Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6E16BBB6
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgBYIVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:21:03 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43487 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729360AbgBYIVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:21:03 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so12990213ljm.10
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 00:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1oNb9AMx6C5uQOfoywNSmQAuPih8254eQSZA8FjCVo=;
        b=edo8WPgCckmEi697/1+N7Imoc8ABvjc3Nys6qXdrRYF0/uyweguSLxUhorGcZqnx4k
         KJvmL0dsekm/Ltm2cHbVaICF/Vfn3o7z9kmBTP9BB7k9tMm5FtEVcp8cspGVvdUZ1464
         fnPPtclKdHgL476s7KpRy5spRnI1lEX6Qqcgx3BfRkbRSdO0nEngB2b57JMgB8njcKQA
         hEfMeMqPeQMibPnoHzSP4ZUEdslv8Z8r0ihumBoiVOV/Iqlx9m74E2VdvkXUE4+N+hK7
         Vml5Q5JfHTE7uyUXfmFeObGat93gr5cOlxAQKiipyO3SY+lsqonhgJP9h31gB5zNqZAQ
         eRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1oNb9AMx6C5uQOfoywNSmQAuPih8254eQSZA8FjCVo=;
        b=mwKFvrfspSoGcyo+P24mYRVl/6ZIpOkplSXCW37hioFx4XYnxYVhLh3oJzL/Rv96MU
         5M2APC2fX9OnkNzwkfUJ2ydsHCaCovGwGZiSH9AKTuHb1J+ATs5pxyyP1eRwIqL7feb8
         FVfmaApuHP7phgsMkSPXLDzPuRa8F3VKL/eml2QPLKswKFaLEUDmVBX2vBkb+rVcR1+W
         hGpXvxR8AWvf3w4dm9t0HH+wmwde8u2n3/j8537aC7Cs/6XJ1vgH054KbI6RCKOvdtvA
         4vhHmenI/P0CjmzKH7vdxMpHdzhUgKMoGkJoCZkmv+s+fcgGBiSwpH7GSxLa+WpRo/AT
         8HHQ==
X-Gm-Message-State: APjAAAWNarFvFB014BT7jfuPpAYd1G5pWIGaiHxAsjlRdS6ho9xJ56Pl
        R1pfQAwPdOpSJxGjjjb9Y8WN+QP3gD6bxUtE7pGrOw==
X-Google-Smtp-Source: APXvYqypfZVT2tXFJb/DYv6AwPAe+lb7UU0LwBUNu4k+SL6+sGX4XHSO/+rE2Pb0TGwL7OAlsoJ3yz6Iz/fAEX3r31k=
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr33445298ljk.245.1582618859162;
 Tue, 25 Feb 2020 00:20:59 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com> <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com> <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
 <CA+G9fYvt2LyqU5G2j_EFKzgPXzt8sDYYm8NxP+zD6Do07REsYw@mail.gmail.com>
 <7b9209be-f880-a791-a2b9-c7e98bf05ecd@arm.com> <CA+G9fYvjoeLV5B951yFb8fc7r+WAejz+0kHcFYTNzW6+HfouXw@mail.gmail.com>
In-Reply-To: <CA+G9fYvjoeLV5B951yFb8fc7r+WAejz+0kHcFYTNzW6+HfouXw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Feb 2020 13:50:47 +0530
Message-ID: <CA+G9fYuEfrhW_7vLCdK4nKBhDv6aQkK_knUY7mbgeDcuaETLyQ@mail.gmail.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On Mon, 24 Feb 2020 at 23:14, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > I think this is because you are running it on one physical CPU (it's exactly the
> > same message I am getting when I use taskset to run the tests). Can you try and
> > run it without taskset and see if it solves your issue?

We have a new problem when running [1] without taskset on Juno-r2.
None of the test got pass [2] when running without taskset on Juno-r2.

Test results summary on arm64 juno-r2.
selftest-setup fail
selftest-vectors-kernel fail
selftest-vectors-user fail
selftest-smp fail
pci-test skip
pmu skip
gicv2-ipi skip
gicv2-mmio fail
gicv2-mmio-up skip
gicv2-mmio-3p fail
gicv3-ipi skip
gicv2-active skip
gicv3-active skip
psci fail
timer skip
micro-bench skip

TAP 13 version and logs output on arm64 juno-r2.

+ ./run_tests.sh -a -v -t
+ tee -a /lava-1250334/1/tests/2_kvm-unit-tests-tap13-1/automated/linux/kvm-unit-tests/output/result_log.txt
TAP version 13
[  129.497212] audit: type=1701 audit(1582614457.002:23):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=3718
comm=\"qemu-system-aar\" exe=\"/usr/bin/qemu-system-aarch64\" sig=6
res=1
[  129.513615] audit: type=1701 audit(1582614457.018:24):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=3715 comm=\"timeout\"
exe=\"/usr/bin/timeout.coreutils\" sig=6 res=1
[  131.516562] audit: type=1701 audit(1582614459.022:25):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=4008
comm=\"qemu-system-aar\" exe=\"/usr/bin/qemu-system-aarch64\" sig=6
res=1
[  131.535440] audit: type=1701 audit(1582614459.038:26):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=4005 comm=\"timeout\"
exe=\"/usr/bin/timeout.coreutils\" sig=6 res=1
[  137.918204] audit: type=1701 audit(1582614465.418:27):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=5020
comm=\"qemu-system-aar\" exe=\"/usr/bin/qemu-system-aarch64\" sig=6
res=1
[  137.944969] audit: type=1701 audit(1582614465.446:28):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=5017 comm=\"timeout\"
exe=\"/usr/bin/timeout.coreutils\" sig=6 res=1
[  138.934361] audit: type=1701 audit(1582614466.438:29):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=5169
comm=\"qemu-system-aar\" exe=\"/usr/bin/qemu-system-aarch64\" sig=6
res=1
[  138.950974] audit: type=1701 audit(1582614466.450:30):
auid=4294967295 uid=0 gid=0 ses=4294967295 pid=5166 comm=\"timeout\"
exe=\"/usr/bin/timeout.coreutils\" sig=6 res=1
1..0
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
arm/cache.flat -smp 1 # -initrd /tmp/tmp.34XgPJlN9a
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -smp 6 -machine gic-version=2 -append active # -initrd
/tmp/tmp.OjpYr51BSm
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 6 -machine gic-version=2 -append ipi # -initrd
/tmp/tmp.Tu8YjEjozY
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 3 -machine gic-version=2 -append mmio # -initrd
/tmp/tmp.tP5NfvXIN1
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 1 -machine gic-version=2 -append mmio # -initrd
/tmp/tmp.YCCzSHAXbL
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 6 -machine gic-version=2 -append mmio # -initrd
/tmp/tmp.uotwZXn3uL
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 6 -machine gic-version=3 -append active #
-initrd /tmp/tmp.W2NfOxzsXx
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 6 -machine gic-version=3 -append ipi # -initrd
/tmp/tmp.VoJWeZB3q5
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/micro-bench.flat -smp 2 # -initrd /tmp/tmp.oOL0QMcBXU
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 1 # -initrd /tmp/tmp.SxqK7GfycP
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/pmu.flat -smp 1 # -initrd /tmp/tmp.ikueOgLcuz
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/psci.flat -smp 6 # -initrd /tmp/tmp.DnL8Q0I9uT
kvm_arm_vcpu_init failed: Invalid argument
timeout: the monitored command dumped core
QEMU Aborted
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/selftest.flat -smp 2 -m 256 -append setup smp=2 mem=256 # -initrd
/tmp/tmp.BXVafuVRMR
kvm_arm_vcpu_init failed: Invalid argument
timeout: the monitored command dumped core
QEMU Aborted
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
_NO_FILE_4Uhere_ -smp 6 -append smp # -initrd /tmp/tmp.oxILXsU6Lz
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/selftest.flat -smp 1 -append vectors-kernel # -initrd
/tmp/tmp.04kmwQgtRW
kvm_init_vcpu failed: Invalid argument
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/selftest.flat -smp 1 -append vectors-user # -initrd
/tmp/tmp.xd7EZ8XBHo
kvm_arm_vcpu_init failed: Invalid argument
timeout: the monitored command dumped core
QEMU Aborted
timeout -k 1s --foreground 2s /usr/bin/qemu-system-aarch64 -nodefaults
-machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/timer.flat -smp 1 # -initrd /tmp/tmp.NmNBOxyyxP
kvm_arm_vcpu_init failed: Invalid argument
timeout: the monitored command dumped core
QEMU Aborted

[1] https://lkft.validation.linaro.org/scheduler/job/1250335#L2594
[2] https://lkft.validation.linaro.org/scheduler/job/1250336#L1578

- Naresh
