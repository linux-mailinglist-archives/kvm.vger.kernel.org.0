Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C2B16A680
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 13:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgBXMyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 07:54:13 -0500
Received: from mail-lf1-f51.google.com ([209.85.167.51]:41151 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgBXMyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 07:54:13 -0500
Received: by mail-lf1-f51.google.com with SMTP id y17so3615150lfe.8
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 04:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DFrYvtB5+rYtbugsSZJb9ZUsO7uG7yvX2h03fbrfMEg=;
        b=lBsfySQ3AZyEQO+jvUbhFFOzMz094d5/783M68soDURpY4+v3EmSYu46Hug+Mzk50R
         SJMjGDicVS4WidxzLemKE/o/uNKOwzLmyk/S0Ar7FqdILUJKXGcxQ/8cYtagUmScH5lV
         dxz1O7HyZwIvLDoRYiexi/U6L+TwN8KbxwSquAwRxISUn3+Y9KOBLmoceE1u4RzPZSVC
         0NDgtgpEtGXKkt3sVLIi7GVNS/mduSP6Z9sGrrw6BlCqnGlGKAekOEqOKqaIkxL1WDCs
         DixsypbScLBABvWwIon0CrefmMLoAOrg1XlZDCGKNdr0yIPFQw3hhW8SKmhIHv0sguNp
         l4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DFrYvtB5+rYtbugsSZJb9ZUsO7uG7yvX2h03fbrfMEg=;
        b=Mkmi2gaqlmlX+IuDtWLS8+87EMawGXc4Ml6weGgZZ+L4uyWog0D7LjynfEm5owCr8v
         c+nJL8Pgs4fpxT63GRCaSkGHPNd/hvEbEHIYooos5mJdL6OWUWo20ngy3HJIwKL0zuAb
         lwtG95XiEo3xHjYOtSaOCQfJbfceZiOKxznnJgLTfivPKCHKLz7Uy88o6icJCmIJgtWt
         6zY6hNu4rBvetuwSoJD7Md6JzXdDidbEPVluno75opA8pSb9zlPYDOA3rhsyCBL1X1xC
         W6AVAKg4G3H/yslB///tnbZiTS1gPHaOT+vZViQZRxyA4Q9aj9S6xAg5q2diPBIDKXeP
         22Og==
X-Gm-Message-State: APjAAAX4QEKZzRfvDPUDN8GhSGb8RZHosdd3Ns51JOyjiMTpTkvR+bfP
        6qDzkjR9eXEjBkS9fVYXCX99oy1wAlzA4xz1QjTsKCVClgQ=
X-Google-Smtp-Source: APXvYqwxrfgTsxOPZB0XPRXYQtiF6Q7SDnt9GNms77RGzM/L5dZG9eGLUiuAH9XXs+MRSuogiyoKUSoeamASWOi+394=
X-Received: by 2002:ac2:4467:: with SMTP id y7mr4971001lfl.167.1582548846145;
 Mon, 24 Feb 2020 04:54:06 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Feb 2020 18:23:54 +0530
Message-ID: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
Subject: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>, alexandru.elisei@arm.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Sorry for the spam]

Greeting from Linaro !
We are running kvm-unit-tests on our CI Continuous Integration and
testing on x86_64 and arm64 Juno-r2.
Linux stable branches and Linux mainline and Linux next.

Few tests getting fail and skipped, we are interested in increasing the
test coverage by adding required kernel config fragments,
kernel command line arguments and user space tools.

Your help is much appreciated.

Here is the details of the LKFT kvm unit test logs,

x86_64 test output log,
+ ./run_tests.sh -a -v
<>
TESTNAME=apic-split TIMEOUT=90s ACCEL= ./x86/run x86/apic.flat -smp 2
-cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
PASS  apic-split (53 tests)
TESTNAME=ioapic-split TIMEOUT=90s ACCEL= ./x86/run x86/ioapic.flat
-smp 1 -cpu qemu64 -machine kernel_irqchip=split
PASS  ioapic-split (19 tests)
TESTNAME=apic TIMEOUT=30 ACCEL= ./x86/run x86/apic.flat -smp 2 -cpu
qemu64,+x2apic,+tsc-deadline
PASS  apic (53 tests)
TESTNAME=ioapic TIMEOUT=90s ACCEL= ./x86/run x86/ioapic.flat -smp 4 -cpu qemu64
PASS  ioapic (26 tests)
SKIP  cmpxchg8b (i386 only)
TESTNAME=smptest TIMEOUT=90s ACCEL= ./x86/run x86/smptest.flat -smp 2
PASS  smptest (1 tests)
TESTNAME=smptest3 TIMEOUT=90s ACCEL= ./x86/run x86/smptest.flat -smp 3
PASS  smptest3 (1 tests)
TESTNAME=vmexit_cpuid TIMEOUT=90s ACCEL= ./x86/run x86/vmexit.flat
-smp 1 -append 'cpuid'
PASS  vmexit_cpuid
TESTNAME=vmexit_vmcall TIMEOUT=90s ACCEL= ./x86/run x86/vmexit.flat
-smp 1 -append 'vmcall'
PASS  vmexit_vmcall
TESTNAME=vmexit_mov_from_cr8 TIMEOUT=90s ACCEL= ./x86/run
x86/vmexit.flat -smp 1 -append 'mov_from_cr8'
PASS  vmexit_mov_from_cr8
[   68.348949] APIC base relocation is unsupported by KVM
[   91.669828] grep (2166) used greatest stack depth: 11928 bytes left
TESTNAME=vmexit_mov_to_cr8 TIMEOUT=90s ACCEL= ./x86/run
x86/vmexit.flat -smp 1 -append 'mov_to_cr8'
PASS  vmexit_mov_to_cr8
TESTNAME=vmexit_inl_pmtimer TIMEOUT=90s ACCEL= ./x86/run
x86/vmexit.flat -smp 1 -append 'inl_from_pmtimer'
PASS  vmexit_inl_pmtimer
TESTNAME=vmexit_ipi TIMEOUT=90s ACCEL= ./x86/run x86/vmexit.flat -smp
2 -append 'ipi'
PASS  vmexit_ipi
TESTNAME=vmexit_ipi_halt TIMEOUT=90s ACCEL= ./x86/run x86/vmexit.flat
-smp 2 -append 'ipi_halt'
PASS  vmexit_ipi_halt
TESTNAME=vmexit_ple_round_robin TIMEOUT=90s ACCEL= ./x86/run
x86/vmexit.flat -smp 1 -append 'ple_round_robin'
PASS  vmexit_ple_round_robin
TESTNAME=vmexit_tscdeadline TIMEOUT=90s ACCEL= ./x86/run
x86/vmexit.flat -smp 1 -cpu qemu64,+x2apic,+tsc-deadline -append
tscdeadline
PASS  vmexit_tscdeadline
TESTNAME=vmexit_tscdeadline_immed TIMEOUT=90s ACCEL= ./x86/run
x86/vmexit.flat -smp 1 -cpu qemu64,+x2apic,+tsc-deadline -append
tscdeadline_immed
PASS  vmexit_tscdeadline_immed
TESTNAME=access TIMEOUT=90s ACCEL= ./x86/run x86/access.flat -smp 1 -cpu host
PASS  access
TESTNAME=smap TIMEOUT=90s ACCEL= ./x86/run x86/smap.flat -smp 1 -cpu host
PASS  smap (18 tests)
TESTNAME=pku TIMEOUT=90s ACCEL= ./x86/run x86/pku.flat -smp 1 -cpu host
SKIP  pku (0 tests)
TESTNAME=asyncpf TIMEOUT=90s ACCEL= ./x86/run x86/asyncpf.flat -smp 1 -m 2048
PASS  asyncpf (1 tests)
TESTNAME=emulator TIMEOUT=90s ACCEL= ./x86/run x86/emulator.flat -smp 1
[  117.428273] kvm: emulating exchange as write
PASS  emulator (131 tests, 1 skipped)
TESTNAME=eventinj TIMEOUT=90s ACCEL= ./x86/run x86/eventinj.flat -smp 1
PASS  eventinj (13 tests)
TESTNAME=hypercall TIMEOUT=90s ACCEL= ./x86/run x86/hypercall.flat -smp 1
PASS  hypercall (2 tests)
TESTNAME=idt_test TIMEOUT=90s ACCEL= ./x86/run x86/idt_test.flat -smp 1
PASS  idt_test (4 tests)
TESTNAME=memory TIMEOUT=90s ACCEL= ./x86/run x86/memory.flat -smp 1 -cpu host
PASS  memory (8 tests)
TESTNAME=msr TIMEOUT=90s ACCEL= ./x86/run x86/msr.flat -smp 1
PASS  msr (12 tests)
cat: /proc/sys/kernel/nmi_watchdog: No such file or directory
SKIP  pmu (/proc/sys/kernel/nmi_watchdog not equal to 0)
TESTNAME=vmware_backdoors TIMEOUT=90s ACCEL= ./x86/run
x86/vmware_backdoors.flat -smp 1 -machine vmport=on -cpu host
PASS  vmware_backdoors (11 tests)
TESTNAME=port80 TIMEOUT=90s ACCEL= ./x86/run x86/port80.flat -smp 1
PASS  port80
TESTNAME=realmode TIMEOUT=90s ACCEL= ./x86/run x86/realmode.flat -smp 1
PASS  realmode
TESTNAME=s3 TIMEOUT=90s ACCEL= ./x86/run x86/s3.flat -smp 1
PASS  s3
TESTNAME=setjmp TIMEOUT=90s ACCEL= ./x86/run x86/setjmp.flat -smp 1
PASS  setjmp (10 tests)
TESTNAME=sieve TIMEOUT=180 ACCEL= ./x86/run x86/sieve.flat -smp 1
PASS  sieve
TESTNAME=syscall TIMEOUT=90s ACCEL= ./x86/run x86/syscall.flat -smp 1
-cpu Opteron_G1,vendor=AuthenticAMD
PASS  syscall (2 tests)
TESTNAME=tsc TIMEOUT=90s ACCEL= ./x86/run x86/tsc.flat -smp 1 -cpu kvm64,+rdtscp
PASS  tsc (3 tests)
TESTNAME=tsc_adjust TIMEOUT=90s ACCEL= ./x86/run x86/tsc_adjust.flat
-smp 1 -cpu host
PASS  tsc_adjust (5 tests)
TESTNAME=xsave TIMEOUT=90s ACCEL= ./x86/run x86/xsave.flat -smp 1 -cpu host
PASS  xsave (17 tests)
TESTNAME=rmap_chain TIMEOUT=90s ACCEL= ./x86/run x86/rmap_chain.flat -smp 1
PASS  rmap_chain
TESTNAME=svm TIMEOUT=90s ACCEL= ./x86/run x86/svm.flat -smp 2 -cpu host,+svm
SKIP  svm (0 tests)
SKIP  taskswitch (i386 only)
SKIP  taskswitch2 (i386 only)
TESTNAME=kvmclock_test TIMEOUT=90s ACCEL= ./x86/run
x86/kvmclock_test.flat -smp 2 --append \"10000000 `date +%s`\"
PASS  kvmclock_test
TESTNAME=pcid TIMEOUT=90s ACCEL= ./x86/run x86/pcid.flat -smp 1 -cpu
qemu64,+pcid
PASS  pcid (3 tests)
TESTNAME=rdpru TIMEOUT=90s ACCEL= ./x86/run x86/rdpru.flat -smp 1 -cpu host
PASS  rdpru (1 tests)
TESTNAME=umip TIMEOUT=90s ACCEL= ./x86/run x86/umip.flat -smp 1 -cpu
qemu64,+umip
PASS  umip (21 tests)
TESTNAME=vmx TIMEOUT=90s ACCEL= ./x86/run x86/vmx.flat -smp 1 -cpu
host,+vmx -append \"-exit_monitor_from_l2_test -ept_access* -vmx_smp*
-vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test
-vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test\"
[  176.338834] kvm [6439]: vcpu0, guest rIP: 0x4041d2
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x1, nop
[  176.349414] kvm [6439]: vcpu0, guest rIP: 0x409eb6
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
[  176.359036] kvm [6439]: vcpu0, guest rIP: 0x40cc37
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x1, nop
[  176.368929] kvm [6439]: vcpu0, guest rIP: 0x409f57
kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
[31mFAIL  vmx (408624 tests, 3 unexpected failures, 2 expected
failures, 5 skipped)
TESTNAME=ept TIMEOUT=90s ACCEL= ./x86/run x86/vmx.flat -smp 1 -cpu
host,host-phys-bits,+vmx -m 2560 -append \"ept_access*\"
SKIP  ept (0 tests)
TESTNAME=vmx_eoi_bitmap_ioapic_scan TIMEOUT=90s ACCEL= ./x86/run
x86/vmx.flat -smp 2 -cpu host,+vmx -m 2048 -append
vmx_eoi_bitmap_ioapic_scan_test
SKIP  vmx_eoi_bitmap_ioapic_scan (1 tests, 1 skipped)
TESTNAME=vmx_hlt_with_rvi_test TIMEOUT=10 ACCEL= ./x86/run
x86/vmx.flat -smp 1 -cpu host,+vmx -append vmx_hlt_with_rvi_test
SKIP  vmx_hlt_with_rvi_test (1 tests, 1 skipped)
TESTNAME=vmx_apicv_test TIMEOUT=10 ACCEL= ./x86/run x86/vmx.flat -smp
1 -cpu host,+vmx -append \"apic_reg_virt_test virt_x2apic_mode_test\"
SKIP  vmx_apicv_test (2 tests, 2 skipped)
TESTNAME=vmx_apic_passthrough_thread TIMEOUT=90s ACCEL= ./x86/run
x86/vmx.flat -smp 2 -cpu host,+vmx -m 2048 -append
vmx_apic_passthrough_thread_test
PASS  vmx_apic_passthrough_thread (8 tests)
TESTNAME=vmx_init_signal_test TIMEOUT=10 ACCEL= ./x86/run x86/vmx.flat
-smp 2 -cpu host,+vmx -m 2048 -append vmx_init_signal_test
PASS  vmx_init_signal_test (9 tests)
TESTNAME=vmx_apic_passthrough_tpr_threshold_test TIMEOUT=10 ACCEL=
./x86/run x86/vmx.flat -smp 1 -cpu host,+vmx -m 2048 -append
vmx_apic_passthrough_tpr_threshold_test
PASS  vmx_apic_passthrough_tpr_threshold_test (6 tests)
TESTNAME=vmx_vmcs_shadow_test TIMEOUT=90s ACCEL= ./x86/run
x86/vmx.flat -smp 1 -cpu host,+vmx -append vmx_vmcs_shadow_test
PASS  vmx_vmcs_shadow_test (142218 tests)
TESTNAME=debug TIMEOUT=90s ACCEL= ./x86/run x86/debug.flat -smp 1
PASS  debug (11 tests)
TESTNAME=hyperv_synic TIMEOUT=90s ACCEL= ./x86/run
x86/hyperv_synic.flat -smp 2 -cpu kvm64,hv_vpindex,hv_synic -device
hyperv-testdev
PASS  hyperv_synic (1 tests)
TESTNAME=hyperv_connections TIMEOUT=90s ACCEL= ./x86/run
x86/hyperv_connections.flat -smp 2 -cpu kvm64,hv_vpindex,hv_synic
-device hyperv-testdev
SKIP  hyperv_connections (1 tests, 1 skipped)
TESTNAME=hyperv_stimer TIMEOUT=90s ACCEL= ./x86/run
x86/hyperv_stimer.flat -smp 2 -cpu
kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device hyperv-testdev
PASS  hyperv_stimer (12 tests)
TESTNAME=hyperv_clock TIMEOUT=90s ACCEL= ./x86/run
x86/hyperv_clock.flat -smp 2 -cpu kvm64,hv_time
PASS  hyperv_clock
TESTNAME=intel_iommu TIMEOUT=30 ACCEL= ./x86/run x86/intel-iommu.flat
-smp 4 -M q35,kernel-irqchip=split -device
intel-iommu,intremap=on,eim=off -device edu
PASS  intel_iommu (11 tests)
TESTNAME=tsx-ctrl TIMEOUT=90s ACCEL= ./x86/run x86/tsx-ctrl.flat -smp
1 -cpu host
PASS  tsx-ctrl

summary:
--------------
access: pass
apic: pass
apic-split: pass
asyncpf: pass
cmpxchg8b: skip
debug: pass
emulator: pass
ept: skip
eventinj: pass
hypercall: pass
hyperv_clock: pass
hyperv_connections: skip
hyperv_stimer: pass
hyperv_synic: pass
idt_test: pass
intel_iommu: pass
ioapic: pass
ioapic-split: pass
kvmclock_test: pass
memory: pass
msr: pass
pcid: pass
pku: skip
pmu: skip
port80: pass
rdpru: pass
realmode: pass
rmap_chain: pass
s3: pass
setjmp: pass
sieve: pass
smap: pass
smptest: pass
smptest3: pass
svm: skip
syscall: pass
taskswitch: skip
taskswitch2: skip
tsc: pass
tsc_adjust: pass
tsx-ctrl: pass
umip: pass
vmexit_cpuid: pass
vmexit_inl_pmtimer: pass
vmexit_ipi: pass
vmexit_ipi_halt: pass
vmexit_mov_from_cr8: pass
vmexit_mov_to_cr8: pass
vmexit_ple_round_robin: pass
vmexit_tscdeadline: pass
vmexit_tscdeadline_immed: pass
vmexit_vmcall: pass
vmware_backdoors: pass
vmx: fail
vmx_apic_passthrough_thread: pass
vmx_apic_passthrough_tpr_threshold_test: pass
vmx_apicv_test: skip
vmx_eoi_bitmap_ioapic_scan: skip
vmx_hlt_with_rvi_test: skip
vmx_init_signal_test: pass
vmx_vmcs_shadow_test: pass
xsave: pass

Reference links,
test sources link,
https://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git/

extra_kernel_args:
kvm.enable_vmware_backdoor=1 kvm.force_emulation_prefix=1

x86 kvm unit test run,
https://qa-reports.linaro.org/lkft/linux-mainline-oe/build/v5.6-rc2-17-g0a44cac81050/testrun/1232942/suite/kvm-unit-tests/tests/

Test job on lava link,
x86:
https://lkft.validation.linaro.org/scheduler/job/1232942
Juno-r2:
https://lkft.validation.linaro.org/scheduler/job/1242488

Configs:
x86:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-mainline/2487/config
Juno-r2:
http://builds.tuxbuild.com/wI08H1E5eDb63gYjzt2OUg/kernel.config

-- 
Linaro LKFT
https://lkft.linaro.org
