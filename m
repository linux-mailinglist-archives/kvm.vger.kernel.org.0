Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93F978C889
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 17:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbjH2PZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 11:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237304AbjH2PZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 11:25:03 -0400
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF20CC2;
        Tue, 29 Aug 2023 08:24:53 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qb0aI-002aOd-2Z;
        Tue, 29 Aug 2023 17:24:50 +0200
Date:   Tue, 29 Aug 2023 17:24:50 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <ZO4NwhOF7PBnA/Ua@torres.zugschlus.de>
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de>
 <ZO2piz5n1MiKR-3-@debian.me>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="H5U3twqR8womlfTq"
Content-Disposition: inline
In-Reply-To: <ZO2piz5n1MiKR-3-@debian.me>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--H5U3twqR8womlfTq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Aug 29, 2023 at 03:17:15PM +0700, Bagas Sanjaya wrote:
> Can you attach full journalctl log so that we can see which services
> timed out?

I have attached the log taken after the machine was ready to log in.
Shutdown -r now also takes tens of minutes since the units shut down in
the 30 second interval as well.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

--H5U3twqR8womlfTq
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="journal.1"

Aug 29 16:48:39 lasso kernel: Linux version 6.5.0-zgsrv20080 (builder@fan-sid-buildd-amd64-e1c7) (gcc (Debian 13.2.0-2) 13.2.0, GNU ld (GNU Binutils for Debian) 2.41) #1 SMP PREEMPT_DYNAMIC Mon Aug 28 11:53:33 CEST 2023
Aug 29 16:48:39 lasso kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-6.5.0-zgsrv20080 root=/dev/vda2 ro rng_core.default_quality=200 console=ttyS0,57600n8
Aug 29 16:48:39 lasso kernel: KERNEL supported cpus:
Aug 29 16:48:39 lasso kernel:   Intel GenuineIntel
Aug 29 16:48:39 lasso kernel:   AMD AuthenticAMD
Aug 29 16:48:39 lasso kernel:   Centaur CentaurHauls
Aug 29 16:48:39 lasso kernel: BIOS-provided physical RAM map:
Aug 29 16:48:39 lasso kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Aug 29 16:48:39 lasso kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Aug 29 16:48:39 lasso kernel: BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
Aug 29 16:48:39 lasso kernel: BIOS-e820: [mem 0x0000000000100000-0x000000002ffd6fff] usable
Aug 29 16:48:39 lasso kernel: BIOS-e820: [mem 0x000000002ffd7000-0x000000002fffffff] reserved
Aug 29 16:48:39 lasso kernel: BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
Aug 29 16:48:39 lasso kernel: BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
Aug 29 16:48:39 lasso kernel: NX (Execute Disable) protection: active
Aug 29 16:48:39 lasso kernel: SMBIOS 2.8 present.
Aug 29 16:48:39 lasso kernel: DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Aug 29 16:48:39 lasso kernel: Hypervisor detected: KVM
Aug 29 16:48:39 lasso kernel: kvm-clock: Using msrs 4b564d01 and 4b564d00
Aug 29 16:48:39 lasso kernel: kvm-clock: using sched offset of 189644104439 cycles
Aug 29 16:48:39 lasso kernel: clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
Aug 29 16:48:39 lasso kernel: tsc: Detected 998.127 MHz processor
Aug 29 16:48:39 lasso kernel: e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
Aug 29 16:48:39 lasso kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
Aug 29 16:48:39 lasso kernel: AGP: No AGP bridge found
Aug 29 16:48:39 lasso kernel: last_pfn = 0x2ffd7 max_arch_pfn = 0x400000000
Aug 29 16:48:39 lasso kernel: MTRR map: 4 entries (3 fixed + 1 variable; max 19), built from 8 variable MTRRs
Aug 29 16:48:39 lasso kernel: x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
Aug 29 16:48:39 lasso kernel: found SMP MP-table at [mem 0x000f5a40-0x000f5a4f]
Aug 29 16:48:39 lasso kernel: RAMDISK: [mem 0x2ede7000-0x2f970fff]
Aug 29 16:48:39 lasso kernel: ACPI: Early table checksum verification disabled
Aug 29 16:48:39 lasso kernel: ACPI: RSDP 0x00000000000F5870 000014 (v00 BOCHS )
Aug 29 16:48:39 lasso kernel: ACPI: RSDT 0x000000002FFE12AA 00002C (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
Aug 29 16:48:39 lasso kernel: ACPI: FACP 0x000000002FFE11BE 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
Aug 29 16:48:39 lasso kernel: ACPI: DSDT 0x000000002FFE0040 00117E (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
Aug 29 16:48:39 lasso kernel: ACPI: FACS 0x000000002FFE0000 000040
Aug 29 16:48:39 lasso kernel: ACPI: APIC 0x000000002FFE1232 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
Aug 29 16:48:39 lasso kernel: ACPI: Reserving FACP table memory at [mem 0x2ffe11be-0x2ffe1231]
Aug 29 16:48:39 lasso kernel: ACPI: Reserving DSDT table memory at [mem 0x2ffe0040-0x2ffe11bd]
Aug 29 16:48:39 lasso kernel: ACPI: Reserving FACS table memory at [mem 0x2ffe0000-0x2ffe003f]
Aug 29 16:48:39 lasso kernel: ACPI: Reserving APIC table memory at [mem 0x2ffe1232-0x2ffe12a9]
Aug 29 16:48:39 lasso kernel: No NUMA configuration found
Aug 29 16:48:39 lasso kernel: Faking a node at [mem 0x0000000000000000-0x000000002ffd6fff]
Aug 29 16:48:39 lasso kernel: NODE_DATA(0) allocated [mem 0x2ffd3000-0x2ffd6fff]
Aug 29 16:48:39 lasso kernel: Zone ranges:
Aug 29 16:48:39 lasso kernel:   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
Aug 29 16:48:39 lasso kernel:   DMA32    [mem 0x0000000001000000-0x000000002ffd6fff]
Aug 29 16:48:39 lasso kernel:   Normal   empty
Aug 29 16:48:39 lasso kernel: Movable zone start for each node
Aug 29 16:48:39 lasso kernel: Early memory node ranges
Aug 29 16:48:39 lasso kernel:   node   0: [mem 0x0000000000001000-0x000000000009efff]
Aug 29 16:48:39 lasso kernel:   node   0: [mem 0x0000000000100000-0x000000002ffd6fff]
Aug 29 16:48:39 lasso kernel: Initmem setup node 0 [mem 0x0000000000001000-0x000000002ffd6fff]
Aug 29 16:48:39 lasso kernel: On node 0, zone DMA: 1 pages in unavailable ranges
Aug 29 16:48:39 lasso kernel: On node 0, zone DMA: 97 pages in unavailable ranges
Aug 29 16:48:39 lasso kernel: On node 0, zone DMA32: 41 pages in unavailable ranges
Aug 29 16:48:39 lasso kernel: ACPI: PM-Timer IO Port: 0x608
Aug 29 16:48:39 lasso kernel: ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
Aug 29 16:48:39 lasso kernel: IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
Aug 29 16:48:39 lasso kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Aug 29 16:48:39 lasso kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
Aug 29 16:48:39 lasso kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Aug 29 16:48:39 lasso kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
Aug 29 16:48:39 lasso kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Aug 29 16:48:39 lasso kernel: ACPI: Using ACPI (MADT) for SMP configuration information
Aug 29 16:48:39 lasso kernel: smpboot: Allowing 1 CPUs, 0 hotplug CPUs
Aug 29 16:48:39 lasso kernel: [mem 0x30000000-0xfeffbfff] available for PCI devices
Aug 29 16:48:39 lasso kernel: Booting paravirtualized kernel on KVM
Aug 29 16:48:39 lasso kernel: clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
Aug 29 16:48:39 lasso kernel: setup_percpu: NR_CPUS:8 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
Aug 29 16:48:39 lasso kernel: percpu: Embedded 47 pages/cpu s155240 r8192 d29080 u2097152
Aug 29 16:48:39 lasso kernel: pcpu-alloc: s155240 r8192 d29080 u2097152 alloc=1*2097152
Aug 29 16:48:39 lasso kernel: pcpu-alloc: [0] 0 
Aug 29 16:48:39 lasso kernel: Kernel command line: BOOT_IMAGE=/boot/vmlinuz-6.5.0-zgsrv20080 root=/dev/vda2 ro rng_core.default_quality=200 console=ttyS0,57600n8
Aug 29 16:48:39 lasso kernel: Unknown kernel command line parameters "BOOT_IMAGE=/boot/vmlinuz-6.5.0-zgsrv20080", will be passed to user space.
Aug 29 16:48:39 lasso kernel: Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
Aug 29 16:48:39 lasso kernel: Inode-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
Aug 29 16:48:39 lasso kernel: Fallback order for Node 0: 0 
Aug 29 16:48:39 lasso kernel: Built 1 zonelists, mobility grouping on.  Total pages: 193239
Aug 29 16:48:39 lasso kernel: Policy zone: DMA32
Aug 29 16:48:39 lasso kernel: mem auto-init: stack:all(zero), heap alloc:off, heap free:off
Aug 29 16:48:39 lasso kernel: AGP: Checking aperture...
Aug 29 16:48:39 lasso kernel: AGP: No AGP bridge found
Aug 29 16:48:39 lasso kernel: Memory: 734492K/785876K available (12288K kernel code, 816K rwdata, 3576K rodata, 1640K init, 2288K bss, 51128K reserved, 0K cma-reserved)
Aug 29 16:48:39 lasso kernel: SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Aug 29 16:48:39 lasso kernel: Dynamic Preempt: full
Aug 29 16:48:39 lasso kernel: rcu: Preemptible hierarchical RCU implementation.
Aug 29 16:48:39 lasso kernel: rcu:         RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=1.
Aug 29 16:48:39 lasso kernel: rcu:         RCU debug extended QS entry/exit.
Aug 29 16:48:39 lasso kernel:         Trampoline variant of Tasks RCU enabled.
Aug 29 16:48:39 lasso kernel:         Tracing variant of Tasks RCU enabled.
Aug 29 16:48:39 lasso kernel: rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
Aug 29 16:48:39 lasso kernel: rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
Aug 29 16:48:39 lasso kernel: NR_IRQS: 4352, nr_irqs: 256, preallocated irqs: 16
Aug 29 16:48:39 lasso kernel: rcu: srcu_init: Setting srcu_struct sizes based on contention.
Aug 29 16:48:39 lasso kernel: Console: colour VGA+ 80x25
Aug 29 16:48:39 lasso kernel: printk: console [ttyS0] enabled
Aug 29 16:48:39 lasso kernel: ACPI: Core revision 20230331
Aug 29 16:48:39 lasso kernel: APIC: Switch to symmetric I/O mode setup
Aug 29 16:48:39 lasso kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Aug 29 16:48:39 lasso kernel: clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x1cc65b93289, max_idle_ns: 881590487074 ns
Aug 29 16:48:39 lasso kernel: Calibrating delay loop (skipped) preset value.. 1996.25 BogoMIPS (lpj=3992508)
Aug 29 16:48:39 lasso kernel: Last level iTLB entries: 4KB 512, 2MB 255, 4MB 127
Aug 29 16:48:39 lasso kernel: Last level dTLB entries: 4KB 512, 2MB 255, 4MB 127, 1GB 0
Aug 29 16:48:39 lasso kernel: Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
Aug 29 16:48:39 lasso kernel: Spectre V2 : Mitigation: Retpolines
Aug 29 16:48:39 lasso kernel: Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
Aug 29 16:48:39 lasso kernel: Spectre V2 : Spectre v2 / SpectreRSB : Filling RSB on VMEXIT
Aug 29 16:48:39 lasso kernel: x86/fpu: x87 FPU will use FXSAVE
Aug 29 16:48:39 lasso kernel: Freeing SMP alternatives memory: 32K
Aug 29 16:48:39 lasso kernel: pid_max: default: 32768 minimum: 301
Aug 29 16:48:39 lasso kernel: LSM: initializing lsm=capability,apparmor,integrity
Aug 29 16:48:39 lasso kernel: AppArmor: AppArmor initialized
Aug 29 16:48:39 lasso kernel: Mount-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
Aug 29 16:48:39 lasso kernel: Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
Aug 29 16:48:39 lasso kernel: smpboot: CPU0: AMD Opteron 23xx (Gen 3 Class Opteron) (family: 0xf, model: 0x6, stepping: 0x1)
Aug 29 16:48:39 lasso kernel: RCU Tasks: Setting shift to 0 and lim to 1 rcu_task_cb_adjust=1.
Aug 29 16:48:39 lasso kernel: RCU Tasks Trace: Setting shift to 0 and lim to 1 rcu_task_cb_adjust=1.
Aug 29 16:48:39 lasso kernel: Performance Events: AMD PMU driver.
Aug 29 16:48:39 lasso kernel: ... version:                0
Aug 29 16:48:39 lasso kernel: ... bit width:              48
Aug 29 16:48:39 lasso kernel: ... generic registers:      4
Aug 29 16:48:39 lasso kernel: ... value mask:             0000ffffffffffff
Aug 29 16:48:39 lasso kernel: ... max period:             00007fffffffffff
Aug 29 16:48:39 lasso kernel: ... fixed-purpose events:   0
Aug 29 16:48:39 lasso kernel: ... event mask:             000000000000000f
Aug 29 16:48:39 lasso kernel: signal: max sigframe size: 1440
Aug 29 16:48:39 lasso kernel: rcu: Hierarchical SRCU implementation.
Aug 29 16:48:39 lasso kernel: rcu:         Max phase no-delay instances is 1000.
Aug 29 16:48:39 lasso kernel: smp: Bringing up secondary CPUs ...
Aug 29 16:48:39 lasso kernel: smp: Brought up 1 node, 1 CPU
Aug 29 16:48:39 lasso kernel: smpboot: Max logical packages: 1
Aug 29 16:48:39 lasso kernel: smpboot: Total of 1 processors activated (1996.25 BogoMIPS)
Aug 29 16:48:39 lasso kernel: devtmpfs: initialized
Aug 29 16:48:39 lasso kernel: clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
Aug 29 16:48:39 lasso kernel: futex hash table entries: 256 (order: 2, 16384 bytes, linear)
Aug 29 16:48:39 lasso kernel: prandom: seed boundary self test passed
Aug 29 16:48:39 lasso kernel: prandom: 100 self tests passed
Aug 29 16:48:39 lasso kernel: pinctrl core: initialized pinctrl subsystem
Aug 29 16:48:39 lasso kernel: NET: Registered PF_NETLINK/PF_ROUTE protocol family
Aug 29 16:48:39 lasso kernel: audit: initializing netlink subsys (disabled)
Aug 29 16:48:39 lasso kernel: thermal_sys: Registered thermal governor 'fair_share'
Aug 29 16:48:39 lasso kernel: thermal_sys: Registered thermal governor 'bang_bang'
Aug 29 16:48:39 lasso kernel: audit: type=2000 audit(1693319494.603:1): state=initialized audit_enabled=0 res=1
Aug 29 16:48:39 lasso kernel: thermal_sys: Registered thermal governor 'step_wise'
Aug 29 16:48:39 lasso kernel: thermal_sys: Registered thermal governor 'user_space'
Aug 29 16:48:39 lasso kernel: thermal_sys: Registered thermal governor 'power_allocator'
Aug 29 16:48:39 lasso kernel: cpuidle: using governor ladder
Aug 29 16:48:39 lasso kernel: cpuidle: using governor menu
Aug 29 16:48:39 lasso kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Aug 29 16:48:39 lasso kernel: PCI: Using configuration type 1 for base access
Aug 29 16:48:39 lasso kernel: HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
Aug 29 16:48:39 lasso kernel: HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
Aug 29 16:48:39 lasso kernel: ACPI: Added _OSI(Module Device)
Aug 29 16:48:39 lasso kernel: ACPI: Added _OSI(Processor Device)
Aug 29 16:48:39 lasso kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Aug 29 16:48:39 lasso kernel: ACPI: Added _OSI(Processor Aggregator Device)
Aug 29 16:48:39 lasso kernel: ACPI: 1 ACPI AML tables successfully acquired and loaded
Aug 29 16:48:39 lasso kernel: ACPI: Interpreter enabled
Aug 29 16:48:39 lasso kernel: ACPI: PM: (supports S0 S5)
Aug 29 16:48:39 lasso kernel: ACPI: Using IOAPIC for interrupt routing
Aug 29 16:48:39 lasso kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Aug 29 16:48:39 lasso kernel: PCI: Using E820 reservations for host bridge windows
Aug 29 16:48:39 lasso kernel: ACPI: Enabled 2 GPEs in block 00 to 0F
Aug 29 16:48:39 lasso kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Aug 29 16:48:39 lasso kernel: acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI HPX-Type3]
Aug 29 16:48:39 lasso kernel: acpi PNP0A03:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
Aug 29 16:48:39 lasso kernel: acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended configuration space under this bridge
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [3] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [4] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [6] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [7] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [8] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [9] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [10] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [11] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [12] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [13] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [14] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [15] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [16] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [17] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [18] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [19] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [20] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [21] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [22] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [23] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [24] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [25] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [26] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [27] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [28] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [29] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [30] registered
Aug 29 16:48:39 lasso kernel: acpiphp: Slot [31] registered
Aug 29 16:48:39 lasso kernel: PCI host bridge to bus 0000:00
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: root bus resource [mem 0x30000000-0xfebfffff window]
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: root bus resource [bus 00-ff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.1: reg 0x20: [io  0xc180-0xc18f]
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: [1b36:0100] type 00 class 0x030000
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: reg 0x10: [mem 0xf4000000-0xf7ffffff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: reg 0x14: [mem 0xf8000000-0xfbffffff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: reg 0x18: [mem 0xfc054000-0xfc055fff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: reg 0x1c: [io  0xc080-0xc09f]
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: reg 0x30: [mem 0xfc040000-0xfc04ffff pref]
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
Aug 29 16:48:39 lasso kernel: pci 0000:00:03.0: reg 0x10: [io  0xc0a0-0xc0bf]
Aug 29 16:48:39 lasso kernel: pci 0000:00:03.0: reg 0x14: [mem 0xfc056000-0xfc056fff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:03.0: reg 0x30: [mem 0xfc000000-0xfc03ffff pref]
Aug 29 16:48:39 lasso kernel: pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
Aug 29 16:48:39 lasso kernel: pci 0000:00:04.0: reg 0x10: [mem 0xfc050000-0xfc053fff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.0: [8086:2934] type 00 class 0x0c0300
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.0: reg 0x20: [io  0xc0c0-0xc0df]
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.1: [8086:2935] type 00 class 0x0c0300
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.1: reg 0x20: [io  0xc0e0-0xc0ff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.2: [8086:2936] type 00 class 0x0c0300
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.2: reg 0x20: [io  0xc100-0xc11f]
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.7: [8086:293a] type 00 class 0x0c0320
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.7: reg 0x10: [mem 0xfc057000-0xfc057fff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:06.0: [1af4:1003] type 00 class 0x078000
Aug 29 16:48:39 lasso kernel: pci 0000:00:06.0: reg 0x10: [io  0xc120-0xc13f]
Aug 29 16:48:39 lasso kernel: pci 0000:00:06.0: reg 0x14: [mem 0xfc058000-0xfc058fff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
Aug 29 16:48:39 lasso kernel: pci 0000:00:07.0: reg 0x10: [io  0xc000-0xc03f]
Aug 29 16:48:39 lasso kernel: pci 0000:00:07.0: reg 0x14: [mem 0xfc059000-0xfc059fff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:08.0: [1af4:1002] type 00 class 0x00ff00
Aug 29 16:48:39 lasso kernel: pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc15f]
Aug 29 16:48:39 lasso kernel: pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
Aug 29 16:48:39 lasso kernel: pci 0000:00:09.0: reg 0x10: [io  0xc040-0xc07f]
Aug 29 16:48:39 lasso kernel: pci 0000:00:09.0: reg 0x14: [mem 0xfc05a000-0xfc05afff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:0a.0: [1af4:1005] type 00 class 0x00ff00
Aug 29 16:48:39 lasso kernel: pci 0000:00:0a.0: reg 0x10: [io  0xc160-0xc17f]
Aug 29 16:48:39 lasso kernel: ACPI: PCI: Interrupt link LNKA configured for IRQ 10
Aug 29 16:48:39 lasso kernel: ACPI: PCI: Interrupt link LNKB configured for IRQ 10
Aug 29 16:48:39 lasso kernel: ACPI: PCI: Interrupt link LNKC configured for IRQ 11
Aug 29 16:48:39 lasso kernel: ACPI: PCI: Interrupt link LNKD configured for IRQ 11
Aug 29 16:48:39 lasso kernel: ACPI: PCI: Interrupt link LNKS configured for IRQ 9
Aug 29 16:48:39 lasso kernel: iommu: Default domain type: Translated
Aug 29 16:48:39 lasso kernel: iommu: DMA domain TLB invalidation policy: strict mode
Aug 29 16:48:39 lasso kernel: SCSI subsystem initialized
Aug 29 16:48:39 lasso kernel: NetLabel: Initializing
Aug 29 16:48:39 lasso kernel: NetLabel:  domain hash size = 128
Aug 29 16:48:39 lasso kernel: NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
Aug 29 16:48:39 lasso kernel: NetLabel:  unlabeled traffic allowed by default
Aug 29 16:48:39 lasso kernel: PCI: Using ACPI for IRQ routing
Aug 29 16:48:39 lasso kernel: PCI: pci_cache_line_size set to 64 bytes
Aug 29 16:48:39 lasso kernel: e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
Aug 29 16:48:39 lasso kernel: e820: reserve RAM buffer [mem 0x2ffd7000-0x2fffffff]
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: vgaarb: setting as boot VGA device
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: vgaarb: bridge control possible
Aug 29 16:48:39 lasso kernel: pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
Aug 29 16:48:39 lasso kernel: vgaarb: loaded
Aug 29 16:48:39 lasso kernel: clocksource: Switched to clocksource kvm-clock
Aug 29 16:48:39 lasso kernel: VFS: Disk quotas dquot_6.6.0
Aug 29 16:48:39 lasso kernel: VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Aug 29 16:48:39 lasso kernel: AppArmor: AppArmor Filesystem Enabled
Aug 29 16:48:39 lasso kernel: pnp: PnP ACPI init
Aug 29 16:48:39 lasso kernel: pnp 00:03: [dma 2]
Aug 29 16:48:39 lasso kernel: pnp: PnP ACPI: found 5 devices
Aug 29 16:48:39 lasso kernel: clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
Aug 29 16:48:39 lasso kernel: NET: Registered PF_INET protocol family
Aug 29 16:48:39 lasso kernel: IP idents hash table entries: 16384 (order: 5, 131072 bytes, linear)
Aug 29 16:48:39 lasso kernel: tcp_listen_portaddr_hash hash table entries: 512 (order: 1, 8192 bytes, linear)
Aug 29 16:48:39 lasso kernel: Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
Aug 29 16:48:39 lasso kernel: TCP established hash table entries: 8192 (order: 4, 65536 bytes, linear)
Aug 29 16:48:39 lasso kernel: TCP bind hash table entries: 8192 (order: 6, 262144 bytes, linear)
Aug 29 16:48:39 lasso kernel: TCP: Hash tables configured (established 8192 bind 8192)
Aug 29 16:48:39 lasso kernel: MPTCP token hash table entries: 1024 (order: 2, 24576 bytes, linear)
Aug 29 16:48:39 lasso kernel: UDP hash table entries: 512 (order: 2, 16384 bytes, linear)
Aug 29 16:48:39 lasso kernel: UDP-Lite hash table entries: 512 (order: 2, 16384 bytes, linear)
Aug 29 16:48:39 lasso kernel: NET: Registered PF_UNIX/PF_LOCAL protocol family
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
Aug 29 16:48:39 lasso kernel: pci_bus 0000:00: resource 7 [mem 0x30000000-0xfebfffff window]
Aug 29 16:48:39 lasso kernel: pci 0000:00:01.0: PIIX3: Enabling Passive Release
Aug 29 16:48:39 lasso kernel: pci 0000:00:00.0: Limiting direct PCI/PCI transfers
Aug 29 16:48:39 lasso kernel: ACPI: \_SB_.LNKA: Enabled at IRQ 10
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.0: quirk_usb_early_handoff+0x0/0x7b0 took 227991 usecs
Aug 29 16:48:39 lasso kernel: ACPI: \_SB_.LNKB: Enabled at IRQ 11
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.1: quirk_usb_early_handoff+0x0/0x7b0 took 225011 usecs
Aug 29 16:48:39 lasso kernel: ACPI: \_SB_.LNKC: Enabled at IRQ 11
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.2: quirk_usb_early_handoff+0x0/0x7b0 took 225172 usecs
Aug 29 16:48:39 lasso kernel: ACPI: \_SB_.LNKD: Enabled at IRQ 10
Aug 29 16:48:39 lasso kernel: pci 0000:00:05.7: quirk_usb_early_handoff+0x0/0x7b0 took 226657 usecs
Aug 29 16:48:39 lasso kernel: PCI: CLS 0 bytes, default 64
Aug 29 16:48:39 lasso kernel: Trying to unpack rootfs image as initramfs...
Aug 29 16:48:39 lasso kernel: clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1cc65b93289, max_idle_ns: 881590487074 ns
Aug 29 16:48:39 lasso kernel: Initialise system trusted keyrings
Aug 29 16:48:39 lasso kernel: Key type blacklist registered
Aug 29 16:48:39 lasso kernel: workingset: timestamp_bits=40 max_order=18 bucket_order=0
Aug 29 16:48:39 lasso kernel: integrity: Platform Keyring initialized
Aug 29 16:48:39 lasso kernel: integrity: Machine keyring initialized
Aug 29 16:48:39 lasso kernel: Key type asymmetric registered
Aug 29 16:48:39 lasso kernel: Asymmetric key parser 'x509' registered
Aug 29 16:48:39 lasso kernel: Running certificate verification selftests
Aug 29 16:48:39 lasso kernel: Loaded X.509 cert 'Certificate verification self-testing key: f58703bb33ce1b73ee02eccdee5b8817518fe3db'
Aug 29 16:48:39 lasso kernel: Freeing initrd memory: 11816K
Aug 29 16:48:39 lasso kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
Aug 29 16:48:39 lasso kernel: io scheduler mq-deadline registered
Aug 29 16:48:39 lasso kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Aug 29 16:48:39 lasso kernel: ACPI: button: Power Button [PWRF]
Aug 29 16:48:39 lasso kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Aug 29 16:48:39 lasso kernel: 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
Aug 29 16:48:39 lasso kernel: lp: driver loaded but no devices found
Aug 29 16:48:39 lasso kernel: ppdev: user-space parallel port driver
Aug 29 16:48:39 lasso kernel: Linux agpgart interface v0.103
Aug 29 16:48:39 lasso kernel: AMD-Vi: AMD IOMMUv2 functionality not available on this system - This is not a bug.
Aug 29 16:48:39 lasso kernel: Fusion MPT base driver 3.04.20
Aug 29 16:48:39 lasso kernel: Copyright (c) 1999-2008 LSI Corporation
Aug 29 16:48:39 lasso kernel: Fusion MPT SPI Host driver 3.04.20
Aug 29 16:48:39 lasso kernel: i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Aug 29 16:48:39 lasso kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 29 16:48:39 lasso kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 29 16:48:39 lasso kernel: mousedev: PS/2 mouse device common for all mice
Aug 29 16:48:39 lasso kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Aug 29 16:48:39 lasso kernel: rtc_cmos 00:00: RTC can wake from S4
Aug 29 16:48:39 lasso kernel: rtc_cmos 00:00: registered as rtc0
Aug 29 16:48:39 lasso kernel: rtc_cmos 00:00: setting system clock to 2023-08-29T14:31:38 UTC (1693319498)
Aug 29 16:48:39 lasso kernel: rtc_cmos 00:00: alarms up to one day, y3k, 114 bytes nvram
Aug 29 16:48:39 lasso kernel: amd_pstate: the _CPC object is not present in SBIOS or ACPI disabled
Aug 29 16:48:39 lasso kernel: hid: raw HID events driver (C) Jiri Kosina
Aug 29 16:48:39 lasso kernel: GACT probability on
Aug 29 16:48:39 lasso kernel: NET: Registered PF_INET6 protocol family
Aug 29 16:48:39 lasso kernel: Segment Routing with IPv6
Aug 29 16:48:39 lasso kernel: RPL Segment Routing with IPv6
Aug 29 16:48:39 lasso kernel: In-situ OAM (IOAM) with IPv6
Aug 29 16:48:39 lasso kernel: NET: Registered PF_PACKET protocol family
Aug 29 16:48:39 lasso kernel: NET: Registered PF_KEY protocol family
Aug 29 16:48:39 lasso kernel: Key type dns_resolver registered
Aug 29 16:48:39 lasso kernel: IPI shorthand broadcast: enabled
Aug 29 16:48:39 lasso kernel: sched_clock: Marking stable (5192048533, 707480089)->(6235069870, -335541248)
Aug 29 16:48:39 lasso kernel: registered taskstats version 1
Aug 29 16:48:39 lasso kernel: Loading compiled-in X.509 certificates
Aug 29 16:48:39 lasso kernel: Key type .fscrypt registered
Aug 29 16:48:39 lasso kernel: Key type fscrypt-provisioning registered
Aug 29 16:48:39 lasso kernel: AppArmor: AppArmor sha1 policy hashing enabled
Aug 29 16:48:39 lasso kernel: alg: No test for 842 (842-scomp)
Aug 29 16:48:39 lasso kernel: alg: No test for 842 (842-generic)
Aug 29 16:48:39 lasso kernel: input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
Aug 29 16:48:39 lasso kernel: clk: Disabling unused clocks
Aug 29 16:48:39 lasso kernel: Freeing unused kernel image (initmem) memory: 1640K
Aug 29 16:48:39 lasso kernel: Write protecting the kernel read-only data: 16384k
Aug 29 16:48:39 lasso kernel: Freeing unused kernel image (rodata/data gap) memory: 520K
Aug 29 16:48:39 lasso kernel: x86/mm: Checked W+X mappings: passed, no W+X pages found.
Aug 29 16:48:39 lasso kernel: Run /init as init process
Aug 29 16:48:39 lasso kernel:   with arguments:
Aug 29 16:48:39 lasso kernel:     /init
Aug 29 16:48:39 lasso kernel:   with environment:
Aug 29 16:48:39 lasso kernel:     HOME=/
Aug 29 16:48:39 lasso kernel:     TERM=linux
Aug 29 16:48:39 lasso kernel:     BOOT_IMAGE=/boot/vmlinuz-6.5.0-zgsrv20080
Aug 29 16:48:39 lasso kernel: FDC 0 is a S82078B
Aug 29 16:48:39 lasso kernel: piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, revision 0
Aug 29 16:48:39 lasso kernel: libata version 3.00 loaded.
Aug 29 16:48:39 lasso kernel: ata_piix 0000:00:01.1: version 2.13
Aug 29 16:48:39 lasso kernel: ACPI: bus type USB registered
Aug 29 16:48:39 lasso kernel: scsi host0: ata_piix
Aug 29 16:48:39 lasso kernel: usbcore: registered new interface driver usbfs
Aug 29 16:48:39 lasso kernel: scsi host1: ata_piix
Aug 29 16:48:39 lasso kernel: ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc180 irq 14
Aug 29 16:48:39 lasso kernel: usbcore: registered new interface driver hub
Aug 29 16:48:39 lasso kernel: ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc188 irq 15
Aug 29 16:48:39 lasso kernel: usbcore: registered new device driver usb
Aug 29 16:48:39 lasso kernel: ata1: found unknown device (class 0)
Aug 29 16:48:39 lasso kernel: ata1.00: ATAPI: QEMU DVD-ROM, 2.1.0, max UDMA/100
Aug 29 16:48:39 lasso kernel: scsi 0:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.1. PQ: 0 ANSI: 5
Aug 29 16:48:39 lasso kernel: virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
Aug 29 16:48:39 lasso kernel: virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
Aug 29 16:48:39 lasso kernel: ehci-pci 0000:00:05.7: EHCI Host Controller
Aug 29 16:48:39 lasso kernel: ehci-pci 0000:00:05.7: new USB bus registered, assigned bus number 1
Aug 29 16:48:39 lasso kernel: ehci-pci 0000:00:05.7: irq 10, io mem 0xfc057000
Aug 29 16:48:39 lasso kernel: ehci-pci 0000:00:05.7: USB 2.0 started, EHCI 1.00
Aug 29 16:48:39 lasso kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.05
Aug 29 16:48:39 lasso kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug 29 16:48:39 lasso kernel: usb usb1: Product: EHCI Host Controller
Aug 29 16:48:39 lasso kernel: usb usb1: Manufacturer: Linux 6.5.0-zgsrv20080 ehci_hcd
Aug 29 16:48:39 lasso kernel: usb usb1: SerialNumber: 0000:00:05.7
Aug 29 16:48:39 lasso kernel: hub 1-0:1.0: USB hub found
Aug 29 16:48:39 lasso kernel: hub 1-0:1.0: 6 ports detected
Aug 29 16:48:39 lasso kernel: sr 0:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
Aug 29 16:48:39 lasso kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Aug 29 16:48:39 lasso kernel: sr 0:0:0:0: Attached scsi CD-ROM sr0
Aug 29 16:48:39 lasso kernel: virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
Aug 29 16:48:39 lasso kernel: usb 1-1: new high-speed USB device number 2 using ehci-pci
Aug 29 16:48:39 lasso kernel: virtio-pci 0000:00:08.0: virtio_pci: leaving for legacy driver
Aug 29 16:48:39 lasso kernel: usb 1-1: New USB device found, idVendor=0627, idProduct=0001, bcdDevice= 0.00
Aug 29 16:48:39 lasso kernel: usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=5
Aug 29 16:48:39 lasso kernel: usb 1-1: Product: QEMU USB Tablet
Aug 29 16:48:39 lasso kernel: usb 1-1: Manufacturer: QEMU
Aug 29 16:48:39 lasso kernel: virtio-pci 0000:00:09.0: virtio_pci: leaving for legacy driver
Aug 29 16:48:39 lasso kernel: usb 1-1: SerialNumber: 42
Aug 29 16:48:39 lasso kernel: input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:00:05.7/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input4
Aug 29 16:48:39 lasso kernel: hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Mouse [QEMU QEMU USB Tablet] on usb-0000:00:05.7-1/input0
Aug 29 16:48:39 lasso kernel: usbcore: registered new interface driver usbhid
Aug 29 16:48:39 lasso kernel: usbhid: USB HID core driver
Aug 29 16:48:39 lasso kernel: virtio-pci 0000:00:0a.0: virtio_pci: leaving for legacy driver
Aug 29 16:48:39 lasso kernel: virtio_blk virtio2: 1/0/0 default/read/poll queues
Aug 29 16:48:39 lasso kernel: virtio_blk virtio2: [vda] 12582912 512-byte logical blocks (6.44 GB/6.00 GiB)
Aug 29 16:48:39 lasso kernel:  vda: vda1 vda2
Aug 29 16:48:39 lasso kernel: virtio_net virtio0 ens3: renamed from eth0
Aug 29 16:48:39 lasso kernel: virtio_blk virtio4: 1/0/0 default/read/poll queues
Aug 29 16:48:39 lasso kernel: virtio_blk virtio4: [vdb] 1048576 512-byte logical blocks (537 MB/512 MiB)
Aug 29 16:48:39 lasso kernel: EXT4-fs (vda2): mounted filesystem 21d5f876-049d-417d-9369-6d678bac44bc ro with ordered data mode. Quota mode: none.
Aug 29 16:48:39 lasso systemd[1]: Inserted module 'autofs4'
Aug 29 16:48:39 lasso kernel: random: crng init done
Aug 29 16:48:39 lasso systemd[1]: systemd 252.12-1~deb12u1 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -BPF_FRAMEWORK -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
Aug 29 16:48:39 lasso systemd[1]: Detected virtualization kvm.
Aug 29 16:48:39 lasso systemd[1]: Detected architecture x86-64.
Aug 29 16:48:39 lasso systemd[1]: Hostname set to <lasso>.
Aug 29 16:48:39 lasso systemd[1]: Queued start job for default target graphical.target.
Aug 29 16:48:39 lasso systemd[1]: Created slice system-getty.slice - Slice /system/getty.
Aug 29 16:48:39 lasso systemd[1]: Created slice system-modprobe.slice - Slice /system/modprobe.
Aug 29 16:48:39 lasso systemd[1]: Created slice system-serial\x2dgetty.slice - Slice /system/serial-getty.
Aug 29 16:48:39 lasso systemd[1]: Created slice user.slice - User and Session Slice.
Aug 29 16:48:39 lasso systemd[1]: Started systemd-ask-password-console.path - Dispatch Password Requests to Console Directory Watch.
Aug 29 16:48:39 lasso systemd[1]: Started systemd-ask-password-wall.path - Forward Password Requests to Wall Directory Watch.
Aug 29 16:48:39 lasso systemd[1]: Set up automount proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats File System Automount Point.
Aug 29 16:48:39 lasso systemd[1]: Reached target cryptsetup.target - Local Encrypted Volumes.
Aug 29 16:48:39 lasso systemd[1]: Reached target integritysetup.target - Local Integrity Protected Volumes.
Aug 29 16:48:39 lasso systemd[1]: Reached target paths.target - Path Units.
Aug 29 16:48:39 lasso systemd[1]: Reached target remote-fs.target - Remote File Systems.
Aug 29 16:48:39 lasso systemd[1]: Reached target slices.target - Slice Units.
Aug 29 16:48:39 lasso systemd[1]: Reached target veritysetup.target - Local Verity Protected Volumes.
Aug 29 16:48:39 lasso systemd[1]: Listening on syslog.socket - Syslog Socket.
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-fsckd.socket - fsck to fsckd communication Socket.
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-initctl.socket - initctl Compatibility Named Pipe.
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-journald-audit.socket - Journal Audit Socket.
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-journald-dev-log.socket - Journal Socket (/dev/log).
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-journald.socket - Journal Socket.
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-networkd.socket - Network Service Netlink Socket.
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-udevd-control.socket - udev Control Socket.
Aug 29 16:48:39 lasso systemd[1]: Listening on systemd-udevd-kernel.socket - udev Kernel Socket.
Aug 29 16:48:39 lasso systemd[1]: Mounting dev-hugepages.mount - Huge Pages File System...
Aug 29 16:48:39 lasso systemd[1]: Mounting dev-mqueue.mount - POSIX Message Queue File System...
Aug 29 16:48:39 lasso systemd[1]: Mounting sys-kernel-debug.mount - Kernel Debug File System...
Aug 29 16:48:39 lasso systemd[1]: sys-kernel-tracing.mount - Kernel Trace File System was skipped because of an unmet condition check (ConditionPathExists=/sys/kernel/tracing).
Aug 29 16:48:39 lasso systemd[1]: Starting keyboard-setup.service - Set the console keyboard layout...
Aug 29 16:48:39 lasso systemd[1]: Starting kmod-static-nodes.service - Create List of Static Device Nodes...
Aug 29 16:48:39 lasso systemd[1]: Starting modprobe@configfs.service - Load Kernel Module configfs...
Aug 29 16:48:39 lasso systemd[1]: Starting modprobe@dm_mod.service - Load Kernel Module dm_mod...
Aug 29 16:48:39 lasso kernel: device-mapper: ioctl: 4.48.0-ioctl (2023-03-01) initialised: dm-devel@redhat.com
Aug 29 16:48:39 lasso systemd[1]: Starting modprobe@drm.service - Load Kernel Module drm...
Aug 29 16:48:39 lasso systemd[1]: Starting modprobe@efi_pstore.service - Load Kernel Module efi_pstore...
Aug 29 16:48:39 lasso systemd[1]: Starting modprobe@fuse.service - Load Kernel Module fuse...
Aug 29 16:48:39 lasso kernel: fuse: init (API version 7.38)
Aug 29 16:48:39 lasso systemd[1]: Starting modprobe@loop.service - Load Kernel Module loop...
Aug 29 16:48:39 lasso kernel: loop: module loaded
Aug 29 16:48:39 lasso systemd[1]: systemd-fsck-root.service - File System Check on Root Device was skipped because of an unmet condition check (ConditionPathExists=!/run/initramfs/fsck-root).
Aug 29 16:48:39 lasso systemd[1]: Starting systemd-journald.service - Journal Service...
Aug 29 16:48:39 lasso systemd-journald[215]: Journal started
Aug 29 16:48:39 lasso systemd-journald[215]: Runtime Journal (/run/log/journal/15338d79b87748dab72ff706bd05dadf) is 936.0K, max 7.3M, 6.3M free.
Aug 29 16:49:09 lasso systemd[1]: Starting systemd-modules-load.service - Load Kernel Modules...
Aug 29 16:49:40 lasso systemd[1]: Starting systemd-remount-fs.service - Remount Root and Kernel File Systems...
Aug 29 16:49:40 lasso kernel: EXT4-fs (vda2): re-mounted 21d5f876-049d-417d-9369-6d678bac44bc r/w. Quota mode: none.
Aug 29 16:50:11 lasso systemd[1]: Starting systemd-udev-trigger.service - Coldplug All udev Devices...
Aug 29 16:50:42 lasso systemd[1]: Started systemd-journald.service - Journal Service.
Aug 29 16:51:12 lasso systemd[1]: Mounted dev-hugepages.mount - Huge Pages File System.
Aug 29 16:51:43 lasso systemd[1]: Mounted dev-mqueue.mount - POSIX Message Queue File System.
Aug 29 16:51:43 lasso systemd[1]: Mounted sys-kernel-debug.mount - Kernel Debug File System.
Aug 29 16:52:14 lasso systemd[1]: Finished keyboard-setup.service - Set the console keyboard layout.
Aug 29 16:52:14 lasso systemd[1]: Finished kmod-static-nodes.service - Create List of Static Device Nodes.
Aug 29 16:52:44 lasso systemd[1]: modprobe@configfs.service: Deactivated successfully.
Aug 29 16:52:44 lasso systemd[1]: Finished modprobe@configfs.service - Load Kernel Module configfs.
Aug 29 16:52:44 lasso systemd[1]: modprobe@dm_mod.service: Deactivated successfully.
Aug 29 16:52:44 lasso systemd[1]: Finished modprobe@dm_mod.service - Load Kernel Module dm_mod.
Aug 29 16:53:15 lasso systemd[1]: modprobe@drm.service: Deactivated successfully.
Aug 29 16:53:15 lasso systemd[1]: Finished modprobe@drm.service - Load Kernel Module drm.
Aug 29 16:53:15 lasso systemd[1]: modprobe@efi_pstore.service: Deactivated successfully.
Aug 29 16:53:15 lasso systemd[1]: Finished modprobe@efi_pstore.service - Load Kernel Module efi_pstore.
Aug 29 16:53:46 lasso systemd[1]: modprobe@fuse.service: Deactivated successfully.
Aug 29 16:53:46 lasso systemd[1]: Finished modprobe@fuse.service - Load Kernel Module fuse.
Aug 29 16:54:17 lasso systemd[1]: modprobe@loop.service: Deactivated successfully.
Aug 29 16:54:17 lasso systemd[1]: Finished modprobe@loop.service - Load Kernel Module loop.
Aug 29 16:54:47 lasso systemd[1]: Finished systemd-modules-load.service - Load Kernel Modules.
Aug 29 16:54:47 lasso systemd[1]: Finished systemd-remount-fs.service - Remount Root and Kernel File Systems.
Aug 29 16:55:18 lasso systemd[1]: Finished systemd-udev-trigger.service - Coldplug All udev Devices.
Aug 29 16:55:18 lasso systemd[1]: dev-disk-by\x2dlabel-lasso\x2dswap0.device: Job dev-disk-by\x2dlabel-lasso\x2dswap0.device/start timed out.
Aug 29 16:55:18 lasso systemd[1]: Timed out waiting for device dev-disk-by\x2dlabel-lasso\x2dswap0.device - /dev/disk/by-label/lasso-swap0.
Aug 29 16:55:49 lasso systemd[1]: Dependency failed for dev-disk-by\x2dlabel-lasso\x2dswap0.swap - /dev/disk/by-label/lasso-swap0.
Aug 29 16:55:49 lasso systemd[1]: dev-disk-by\x2dlabel-lasso\x2dswap0.swap: Job dev-disk-by\x2dlabel-lasso\x2dswap0.swap/start failed with result 'dependency'.
Aug 29 16:55:49 lasso systemd[1]: dev-disk-by\x2dlabel-lasso\x2dswap0.device: Job dev-disk-by\x2dlabel-lasso\x2dswap0.device/start failed with result 'timeout'.
Aug 29 16:55:49 lasso systemd[1]: dev-ttyS0.device: Job dev-ttyS0.device/start timed out.
Aug 29 16:55:49 lasso systemd[1]: Timed out waiting for device dev-ttyS0.device - /dev/ttyS0.
Aug 29 16:56:19 lasso systemd[1]: Dependency failed for serial-getty@ttyS0.service - Serial Getty on ttyS0.
Aug 29 16:56:19 lasso systemd[1]: serial-getty@ttyS0.service: Job serial-getty@ttyS0.service/start failed with result 'dependency'.
Aug 29 16:56:19 lasso systemd[1]: dev-ttyS0.device: Job dev-ttyS0.device/start failed with result 'timeout'.
Aug 29 16:56:19 lasso systemd[1]: Reached target swap.target - Swaps.
Aug 29 16:56:50 lasso systemd[1]: Mounting sys-fs-fuse-connections.mount - FUSE Control File System...
Aug 29 16:57:21 lasso systemd[1]: Mounting sys-kernel-config.mount - Kernel Configuration File System...
Aug 29 16:57:52 lasso systemd[1]: systemd-firstboot.service - First Boot Wizard was skipped because of an unmet condition check (ConditionFirstBoot=yes).
Aug 29 16:57:52 lasso systemd[1]: Starting systemd-journal-flush.service - Flush Journal to Persistent Storage...
Aug 29 16:57:52 lasso systemd-journald[215]: Runtime Journal (/run/log/journal/15338d79b87748dab72ff706bd05dadf) is 936.0K, max 7.3M, 6.3M free.
Aug 29 16:57:52 lasso systemd-journald[215]: Received client request to flush runtime journal.
Aug 29 16:58:22 lasso systemd[1]: systemd-pstore.service - Platform Persistent Storage Archival was skipped because of an unmet condition check (ConditionDirectoryNotEmpty=/sys/fs/pstore).
Aug 29 16:58:22 lasso systemd[1]: Starting systemd-random-seed.service - Load/Save Random Seed...
Aug 29 16:58:53 lasso systemd[1]: systemd-repart.service - Repartition Root Disk was skipped because no trigger condition checks were met.
Aug 29 16:58:53 lasso systemd[1]: Starting systemd-sysctl.service - Apply Kernel Variables...
Aug 29 16:59:24 lasso systemd[1]: Starting systemd-sysusers.service - Create System Users...
Aug 29 16:59:54 lasso systemd[1]: Mounted sys-fs-fuse-connections.mount - FUSE Control File System.
Aug 29 17:00:25 lasso systemd[1]: Mounted sys-kernel-config.mount - Kernel Configuration File System.
Aug 29 17:00:25 lasso systemd[1]: Finished systemd-journal-flush.service - Flush Journal to Persistent Storage.
Aug 29 17:00:56 lasso systemd[1]: Finished systemd-random-seed.service - Load/Save Random Seed.
Aug 29 17:00:56 lasso systemd[1]: Finished systemd-sysctl.service - Apply Kernel Variables.
Aug 29 17:01:27 lasso systemd[1]: Finished systemd-sysusers.service - Create System Users.
Aug 29 17:01:27 lasso systemd[1]: first-boot-complete.target - First Boot Complete was skipped because of an unmet condition check (ConditionFirstBoot=yes).
Aug 29 17:01:27 lasso systemd[1]: Starting systemd-tmpfiles-setup-dev.service - Create Static Device Nodes in /dev...
Aug 29 17:01:27 lasso systemd[1]: Finished systemd-tmpfiles-setup-dev.service - Create Static Device Nodes in /dev.
Aug 29 17:01:27 lasso systemd[1]: Reached target local-fs-pre.target - Preparation for Local File Systems.
Aug 29 17:01:27 lasso systemd[1]: Mounting tmp.mount - mount /tmp with secure defaults...
Aug 29 17:01:27 lasso systemd[1]: Starting systemd-udevd.service - Rule-based Manager for Device Events and Files...
Aug 29 17:01:27 lasso systemd[1]: Mounted tmp.mount - mount /tmp with secure defaults.
Aug 29 17:01:27 lasso systemd[1]: Reached target local-fs.target - Local File Systems.
Aug 29 17:01:27 lasso systemd[1]: Starting apparmor.service - Load AppArmor profiles...
Aug 29 17:01:27 lasso systemd[1]: Starting console-setup.service - Set console font and keymap...
Aug 29 17:01:27 lasso systemd[1]: Starting systemd-binfmt.service - Set Up Additional Binary Formats...
Aug 29 17:01:27 lasso systemd[1]: systemd-machine-id-commit.service - Commit a transient machine-id on disk was skipped because of an unmet condition check (ConditionPathIsMountPoint=/etc/machine-id).
Aug 29 17:01:27 lasso systemd[1]: Starting systemd-tmpfiles-setup.service - Create Volatile Files and Directories...
Aug 29 17:01:27 lasso apparmor.systemd[239]: Restarting AppArmor
Aug 29 17:01:27 lasso apparmor.systemd[239]: Reloading AppArmor profiles
Aug 29 17:01:27 lasso systemd[1]: Finished console-setup.service - Set console font and keymap.
Aug 29 17:01:27 lasso systemd[1]: proc-sys-fs-binfmt_misc.automount: Got automount request for /proc/sys/fs/binfmt_misc, triggered by 244 (systemd-binfmt)
Aug 29 17:01:27 lasso systemd[1]: Mounting proc-sys-fs-binfmt_misc.mount - Arbitrary Executable File Formats File System...
Aug 29 17:01:27 lasso audit[251]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="ping" pid=251 comm="apparmor_parser"
Aug 29 17:01:27 lasso kernel: audit: type=1400 audit(1693321287.920:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="ping" pid=251 comm="apparmor_parser"
Aug 29 17:01:27 lasso audit[253]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="lsb_release" pid=253 comm="apparmor_parser"
Aug 29 17:01:27 lasso kernel: audit: type=1400 audit(1693321287.992:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="lsb_release" pid=253 comm="apparmor_parser"
Aug 29 17:01:28 lasso systemd[1]: Mounted proc-sys-fs-binfmt_misc.mount - Arbitrary Executable File Formats File System.
Aug 29 17:01:28 lasso audit[255]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="nvidia_modprobe" pid=255 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.076:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="nvidia_modprobe" pid=255 comm="apparmor_parser"
Aug 29 17:01:28 lasso audit[255]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="nvidia_modprobe//kmod" pid=255 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.088:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="nvidia_modprobe//kmod" pid=255 comm="apparmor_parser"
Aug 29 17:01:28 lasso systemd[1]: Finished systemd-tmpfiles-setup.service - Create Volatile Files and Directories.
Aug 29 17:01:28 lasso audit[256]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="php-fpm" pid=256 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.148:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="php-fpm" pid=256 comm="apparmor_parser"
Aug 29 17:01:28 lasso systemd[1]: Finished systemd-binfmt.service - Set Up Additional Binary Formats.
Aug 29 17:01:28 lasso audit[257]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-bgqd" pid=257 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.208:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-bgqd" pid=257 comm="apparmor_parser"
Aug 29 17:01:28 lasso systemd[1]: Starting systemd-resolved.service - Network Name Resolution...
Aug 29 17:01:28 lasso systemd[1]: Starting systemd-update-utmp.service - Record System Boot/Shutdown in UTMP...
Aug 29 17:01:28 lasso audit[259]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-dcerpcd" pid=259 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.316:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-dcerpcd" pid=259 comm="apparmor_parser"
Aug 29 17:01:28 lasso systemd-udevd[238]: Using default interface naming scheme 'v252'.
Aug 29 17:01:28 lasso audit[261]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-rpcd" pid=261 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.400:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-rpcd" pid=261 comm="apparmor_parser"
Aug 29 17:01:28 lasso audit[262]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-rpcd-classic" pid=262 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.480:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-rpcd-classic" pid=262 comm="apparmor_parser"
Aug 29 17:01:28 lasso systemd[1]: Finished systemd-update-utmp.service - Record System Boot/Shutdown in UTMP.
Aug 29 17:01:28 lasso systemd[1]: Started systemd-udevd.service - Rule-based Manager for Device Events and Files.
Aug 29 17:01:28 lasso audit[263]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-rpcd-spoolss" pid=263 comm="apparmor_parser"
Aug 29 17:01:28 lasso kernel: audit: type=1400 audit(1693321288.580:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="samba-rpcd-spoolss" pid=263 comm="apparmor_parser"
Aug 29 17:01:28 lasso audit[267]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="klogd" pid=267 comm="apparmor_parser"
Aug 29 17:01:28 lasso systemd[1]: Starting systemd-networkd.service - Network Configuration...
Aug 29 17:01:28 lasso audit[270]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="syslog-ng" pid=270 comm="apparmor_parser"
Aug 29 17:01:28 lasso audit[273]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="syslogd" pid=273 comm="apparmor_parser"
Aug 29 17:01:28 lasso audit[274]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="tcpdump" pid=274 comm="apparmor_parser"
Aug 29 17:01:28 lasso audit[275]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="avahi-daemon" pid=275 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[276]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="dnsmasq" pid=276 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[276]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="dnsmasq//libvirt_leaseshelper" pid=276 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[277]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/haveged" pid=277 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[278]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="identd" pid=278 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[279]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="mdnsd" pid=279 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[280]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="named" pid=280 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[281]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="nmbd" pid=281 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[282]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="nscd" pid=282 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[283]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/ntpd" pid=283 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[285]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="smbd" pid=285 comm="apparmor_parser"
Aug 29 17:01:29 lasso systemd-networkd[271]: lo: Link UP
Aug 29 17:01:29 lasso systemd-networkd[271]: lo: Gained carrier
Aug 29 17:01:29 lasso systemd-journald[215]: Data hash table of /run/log/journal/15338d79b87748dab72ff706bd05dadf/system.journal has a fill level at 75.1 (1537 of 2047 items, 958464 file size, 623 bytes per hash table item), suggesting rotation.
Aug 29 17:01:29 lasso systemd-journald[215]: /run/log/journal/15338d79b87748dab72ff706bd05dadf/system.journal: Journal header limits reached or header out-of-date, rotating.
Aug 29 17:01:29 lasso systemd-networkd[271]: Enumeration completed
Aug 29 17:01:29 lasso systemd[1]: Started systemd-networkd.service - Network Configuration.
Aug 29 17:01:29 lasso systemd-networkd[271]: ens3: Configuring with /etc/systemd/network/lasso.network.
Aug 29 17:01:29 lasso systemd-resolved[258]: Positive Trust Anchors:
Aug 29 17:01:29 lasso kernel: sr 0:0:0:0: Attached scsi generic sg0 type 5
Aug 29 17:01:29 lasso systemd-resolved[258]: . IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d
Aug 29 17:01:29 lasso systemd-resolved[258]: Negative trust anchors: home.arpa 10.in-addr.arpa 16.172.in-addr.arpa 17.172.in-addr.arpa 18.172.in-addr.arpa 19.172.in-addr.arpa 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 24.172.in-addr.arpa 25.172.in-addr.arpa 26.172.in-addr.arpa 27.172.in-addr.arpa 28.172.in-addr.arpa 29.172.in-addr.arpa 30.172.in-addr.arpa 31.172.in-addr.arpa 168.192.in-addr.arpa d.f.ip6.arpa corp home internal intranet lan local private test
Aug 29 17:01:29 lasso systemd-networkd[271]: ens3: Link UP
Aug 29 17:01:29 lasso systemd-networkd[271]: ens3: Gained carrier
Aug 29 17:01:29 lasso systemd[1]: Starting systemd-networkd-wait-online.service - Wait for Network to be Configured...
Aug 29 17:01:29 lasso audit[288]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="smbldap-useradd" pid=288 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[288]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="smbldap-useradd///etc/init.d/nscd" pid=288 comm="apparmor_parser"
Aug 29 17:01:29 lasso audit[292]: AVC apparmor="STATUS" operation="profile_load" profile="unconfined" name="traceroute" pid=292 comm="apparmor_parser"
Aug 29 17:01:30 lasso systemd[1]: Finished apparmor.service - Load AppArmor profiles.
Aug 29 17:01:30 lasso systemd[1]: Started haveged.service - Entropy Daemon based on the HAVEGE algorithm.
Aug 29 17:01:30 lasso systemd-networkd[271]: ens3: Gained IPv6LL
Aug 29 17:01:30 lasso haveged[294]: haveged: command socket is listening at fd 3
Aug 29 17:01:31 lasso systemd-resolved[258]: Using system hostname 'lasso'.
Aug 29 17:01:31 lasso systemd[1]: Started systemd-resolved.service - Network Name Resolution.
Aug 29 17:01:33 lasso kernel: kvm_amd: SVM not supported by CPU 0, can't execute cpuid_8000000a
Aug 29 17:01:33 lasso kernel: powernow_k8: Power state transitions not supported
Aug 29 17:01:34 lasso haveged[294]: haveged: ver: 1.9.14; arch: x86; vend: AuthenticAMD; build: (gcc 12.2.0 ITV); collect: 128K
Aug 29 17:01:34 lasso haveged[294]: haveged: cpu: (A8 VC); data: 64K (A5 V); inst: 64K (A5 V); idx: 39/40; sz: 53875/53875
Aug 29 17:01:34 lasso haveged[294]: haveged: tot tests(BA8): A:1/1 B:1/1 continuous tests(B):  last entropy estimate 8.00083
Aug 29 17:01:34 lasso haveged[294]: haveged: fills: 0, generated: 0
Aug 29 17:02:01 lasso systemd[1]: Finished systemd-networkd-wait-online.service - Wait for Network to be Configured.
Aug 29 17:02:32 lasso systemd[1]: Reached target network.target - Network.
Aug 29 17:03:03 lasso systemd[1]: Reached target network-online.target - Network is Online.
Aug 29 17:03:03 lasso systemd[1]: Reached target sysinit.target - System Initialization.
Aug 29 17:03:34 lasso systemd[1]: Started apt-daily.timer - Daily apt download activities.
Aug 29 17:03:34 lasso systemd[1]: Started apt-daily-upgrade.timer - Daily apt upgrade and clean activities.
Aug 29 17:04:04 lasso systemd[1]: Started atop-rotate.timer - Daily atop restart.
Aug 29 17:04:04 lasso systemd[1]: Started cron-apt.timer - Trigger daily cron-apt run.
Aug 29 17:04:35 lasso systemd[1]: Started cron-apt@hourly.timer - Trigger hourly cron-apt run.
Aug 29 17:04:35 lasso systemd[1]: Started dailyaidecheck.timer - Daily AIDE check.
Aug 29 17:05:06 lasso systemd[1]: Started dpkg-db-backup.timer - Daily dpkg database backup timer.
Aug 29 17:05:06 lasso systemd[1]: Started e2scrub_all.timer - Periodic ext4 Online Metadata Check for All Filesystems.
Aug 29 17:05:36 lasso systemd[1]: Started exim4-base.timer - Daily exim4-base housekeeping.
Aug 29 17:05:37 lasso systemd[1]: Started logrotate.timer - Daily rotation of log files.
Aug 29 17:06:07 lasso systemd[1]: Started ntpsec-rotate-stats.timer - Rotate ntpd stats daily.
Aug 29 17:06:07 lasso systemd[1]: Started systemd-tmpfiles-clean.timer - Daily Cleanup of Temporary Directories.
Aug 29 17:06:38 lasso systemd[1]: Started zg2-rebootscript.timer - Zg2 Reboot Script.
Aug 29 17:06:38 lasso systemd[1]: Reached target timers.target - Timer Units.
Aug 29 17:07:09 lasso systemd[1]: Listening on dbus.socket - D-Bus System Message Bus Socket.
Aug 29 17:07:09 lasso systemd[1]: Listening on ssh.socket - OpenBSD Secure Shell server socket.
Aug 29 17:07:09 lasso systemd[1]: Reached target sockets.target - Socket Units.
Aug 29 17:07:09 lasso systemd[1]: systemd-pcrphase-sysinit.service - TPM2 PCR Barrier (Initialization) was skipped because of an unmet condition check (ConditionPathExists=/sys/firmware/efi/efivars/StubPcrKernelImage-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f).
Aug 29 17:07:09 lasso systemd[1]: Reached target basic.target - Basic System.
Aug 29 17:07:09 lasso systemd[1]: Starting atopacct.service - Atop process accounting daemon...
Aug 29 17:07:09 lasso systemd[1]: Starting console-log.service - LSB: Puts a logfile pager on virtual consoles...
Aug 29 17:07:09 lasso systemd[1]: Started cron.service - Regular background program processing daemon.
Aug 29 17:07:09 lasso cron[313]: (CRON) INFO (pidfile fd = 3)
Aug 29 17:07:09 lasso cron[313]: (CRON) INFO (Running @reboot jobs)
Aug 29 17:07:09 lasso systemd[1]: Starting dbus.service - D-Bus System Message Bus...
Aug 29 17:07:09 lasso systemd[1]: Starting e2scrub_reap.service - Remove Stale Online ext4 Metadata Check Snapshots...
Aug 29 17:07:09 lasso systemd[1]: getty-static.service - getty on tty2-tty6 if dbus and logind are not available was skipped because of an unmet condition check (ConditionPathExists=!/usr/bin/dbus-daemon).
Aug 29 17:07:09 lasso systemd[1]: Starting named.service - BIND Domain Name Server...
Aug 29 17:07:09 lasso systemd[1]: Starting rsyslog.service - System Logging Service...
Aug 29 17:07:09 lasso systemd[1]: Starting systemd-logind.service - User Login Management...
Aug 29 17:07:09 lasso rsyslogd[321]: action '*' treated as ':omusrmsg:*' - please use ':omusrmsg:*' syntax instead, '*' will not be supported in the future [v8.2302.0 try https://www.rsyslog.com/e/2184 ]
Aug 29 17:07:09 lasso rsyslogd[321]: error during parsing file /etc/rsyslog.d/90_zgserver.conf, on or before line 4: warnings occurred in file '/etc/rsyslog.d/90_zgserver.conf' around line 4 [v8.2302.0 try https://www.rsyslog.com/e/2207 ]
Aug 29 17:07:09 lasso rsyslogd[321]: warning: ~ action is deprecated, consider using the 'stop' statement instead [v8.2302.0 try https://www.rsyslog.com/e/2307 ]
Aug 29 17:07:09 lasso rsyslogd[321]: action '*' treated as ':omusrmsg:*' - please use ':omusrmsg:*' syntax instead, '*' will not be supported in the future [v8.2302.0 try https://www.rsyslog.com/e/2184 ]
Aug 29 17:07:09 lasso rsyslogd[321]: error during parsing file /etc/rsyslog.conf, on or before line 91: warnings occurred in file '/etc/rsyslog.conf' around line 91 [v8.2302.0 try https://www.rsyslog.com/e/2207 ]
Aug 29 17:07:09 lasso rsyslogd[321]: warning: ~ action is deprecated, consider using the 'stop' statement instead [v8.2302.0 try https://www.rsyslog.com/e/2307 ]
Aug 29 17:07:09 lasso rsyslogd[321]: imuxsock: Acquired UNIX socket '/run/systemd/journal/syslog' (fd 3) from systemd.  [v8.2302.0]
Aug 29 17:07:09 lasso rsyslogd[321]: [origin software="rsyslogd" swVersion="8.2302.0" x-pid="321" x-info="https://www.rsyslog.com"] start
Aug 29 17:07:09 lasso systemd[1]: systemd-pcrphase.service - TPM2 PCR Barrier (User) was skipped because of an unmet condition check (ConditionPathExists=/sys/firmware/efi/efivars/StubPcrKernelImage-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f).
Aug 29 17:07:09 lasso systemd[1]: Starting systemd-user-sessions.service - Permit User Sessions...
Aug 29 17:07:09 lasso systemd[1]: Started dbus.service - D-Bus System Message Bus.
Aug 29 17:07:10 lasso systemd[1]: Started rsyslog.service - System Logging Service.
Aug 29 17:07:10 lasso systemd[1]: e2scrub_reap.service: Deactivated successfully.
Aug 29 17:07:10 lasso systemd[1]: Finished e2scrub_reap.service - Remove Stale Online ext4 Metadata Check Snapshots.
Aug 29 17:07:10 lasso systemd[1]: Finished systemd-user-sessions.service - Permit User Sessions.
Aug 29 17:07:10 lasso atopacctd[333]: Version: 2.8.1 - 2023/01/07 14:27:57  <gerlof.langeveld@atoptool.nl>
Aug 29 17:07:10 lasso kernel: Process accounting resumed
Aug 29 17:07:10 lasso atopacctd[333]: accounting to /run/pacct_source
Aug 29 17:07:10 lasso systemd[1]: Started atopacct.service - Atop process accounting daemon.
Aug 29 17:07:10 lasso systemd[1]: Starting atop.service - Atop advanced performance monitor...
Aug 29 17:07:10 lasso systemd[1]: Started getty@tty1.service - Getty on tty1.
Aug 29 17:07:10 lasso systemd[1]: Reached target getty.target - Login Prompts.
Aug 29 17:07:10 lasso systemd[1]: Starting systemd-tmpfiles-clean.service - Cleanup of Temporary Directories...
Aug 29 17:07:10 lasso systemd-logind[322]: Watching system buttons on /dev/input/event0 (Power Button)
Aug 29 17:07:10 lasso systemd[1]: Starting zg2-rebootscript.service - Zg2 Reboot-Script...
Aug 29 17:07:10 lasso su[344]: (to Debian-console-log) root on none
Aug 29 17:07:10 lasso systemd-logind[322]: Watching system buttons on /dev/input/event1 (AT Translated Set 2 keyboard)
Aug 29 17:07:10 lasso systemd-logind[322]: New seat seat0.
Aug 29 17:07:10 lasso su[344]: pam_unix(su:session): session opened for user Debian-console-log(uid=106) by (uid=0)
Aug 29 17:07:11 lasso systemd[1]: Started systemd-logind.service - User Login Management.
Aug 29 17:07:11 lasso systemd[1]: systemd-tmpfiles-clean.service: Deactivated successfully.
Aug 29 17:07:11 lasso systemd[1]: Finished systemd-tmpfiles-clean.service - Cleanup of Temporary Directories.
Aug 29 17:07:11 lasso systemd[1]: run-credentials-systemd\x2dtmpfiles\x2dclean.service.mount: Deactivated successfully.
Aug 29 17:07:11 lasso systemd[1]: Started atop.service - Atop advanced performance monitor.
Aug 29 17:07:11 lasso systemd[1]: Created slice user-106.slice - User Slice of UID 106.
Aug 29 17:07:11 lasso systemd[1]: Starting user-runtime-dir@106.service - User Runtime Directory /run/user/106...
Aug 29 17:07:11 lasso systemd[1]: Finished user-runtime-dir@106.service - User Runtime Directory /run/user/106.
Aug 29 17:07:11 lasso systemd[1]: Starting user@106.service - User Manager for UID 106...
Aug 29 17:07:11 lasso (systemd)[365]: pam_unix(systemd-user:session): session opened for user Debian-console-log(uid=106) by (uid=0)
Aug 29 17:07:11 lasso systemd[1]: zg2-rebootscript.service: Deactivated successfully.
Aug 29 17:07:11 lasso systemd[1]: Finished zg2-rebootscript.service - Zg2 Reboot-Script.
Aug 29 17:07:12 lasso kernel: memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=365 'systemd'
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: kauditd_printk_skb: 18 callbacks suppressed
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.184:30): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.192:31): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.196:32): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.204:33): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.212:34): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.220:35): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.232:36): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.240:37): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.252:38): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso kernel: audit: type=1400 audit(1693321632.260:39): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:12 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:07:13 lasso audit[320]: AVC apparmor="DENIED" operation="capable" class="cap" profile="named" pid=320 comm="named" capability=12  capname="net_admin"
Aug 29 17:07:13 lasso systemd[1]: Started named.service - BIND Domain Name Server.
Aug 29 17:07:13 lasso systemd[1]: Reached target nss-lookup.target - Host and Network Name Lookups.
Aug 29 17:07:13 lasso systemd[365]: Queued start job for default target default.target.
Aug 29 17:07:13 lasso systemd[365]: Created slice app.slice - User Application Slice.
Aug 29 17:07:13 lasso systemd[365]: Reached target paths.target - Paths.
Aug 29 17:07:13 lasso systemd[365]: Reached target timers.target - Timers.
Aug 29 17:07:13 lasso systemd[365]: Listening on dirmngr.socket - GnuPG network certificate management daemon.
Aug 29 17:07:13 lasso systemd[365]: Listening on gpg-agent-browser.socket - GnuPG cryptographic agent and passphrase cache (access for web browsers).
Aug 29 17:07:13 lasso systemd[365]: Listening on gpg-agent-extra.socket - GnuPG cryptographic agent and passphrase cache (restricted).
Aug 29 17:07:13 lasso systemd[365]: Listening on gpg-agent-ssh.socket - GnuPG cryptographic agent (ssh-agent emulation).
Aug 29 17:07:13 lasso systemd[365]: Listening on gpg-agent.socket - GnuPG cryptographic agent and passphrase cache.
Aug 29 17:07:13 lasso systemd[365]: Reached target sockets.target - Sockets.
Aug 29 17:07:13 lasso systemd[365]: Reached target basic.target - Basic System.
Aug 29 17:07:13 lasso systemd[365]: Reached target default.target - Main User Target.
Aug 29 17:07:13 lasso systemd[365]: Startup finished in 1.150s.
Aug 29 17:07:43 lasso systemd[1]: Starting exim4.service - LSB: exim Mail Transport Agent...
Aug 29 17:08:14 lasso systemd[1]: Starting ippl.service - LSB: IP protocols logger...
Aug 29 17:08:45 lasso systemd[1]: Starting ntpsec.service - Network Time Service...
Aug 29 17:08:45 lasso ntpd[393]: INIT: ntpd ntpsec-1.2.2: Starting
Aug 29 17:08:45 lasso ntp-systemd-wrapper[393]: 2023-08-29T17:08:45 ntpd[393]: INIT: ntpd ntpsec-1.2.2: Starting
Aug 29 17:08:45 lasso ntpd[393]: INIT: Command line: /usr/sbin/ntpd -p /run/ntpd.pid -c /etc/ntpsec/ntp.conf -g -N -u ntpsec:ntpsec
Aug 29 17:08:45 lasso ntp-systemd-wrapper[393]: 2023-08-29T17:08:45 ntpd[393]: INIT: Command line: /usr/sbin/ntpd -p /run/ntpd.pid -c /etc/ntpsec/ntp.conf -g -N -u ntpsec:ntpsec
Aug 29 17:08:45 lasso ntpd[395]: INIT: pthread_setschedparam(): Operation not permitted
Aug 29 17:08:45 lasso ntpd[395]: INIT: set_process_priority: No way found to improve our priority
Aug 29 17:08:45 lasso ntpd[395]: INIT: precision = 0.373 usec (-21)
Aug 29 17:08:45 lasso ntpd[395]: INIT: successfully locked into RAM
Aug 29 17:08:45 lasso ntpd[395]: CONFIG: readconfig: parsing file: /etc/ntpsec/ntp.conf
Aug 29 17:08:45 lasso ntpd[395]: CONFIG: restrict notrap ignored
Aug 29 17:08:45 lasso ntpd[395]: CONFIG: restrict nopeer ignored
Aug 29 17:08:45 lasso ntpd[395]: CONFIG: restrict notrap ignored
Aug 29 17:08:45 lasso ntpd[395]: CONFIG: restrict nopeer ignored
Aug 29 17:08:45 lasso ntpd[395]: CONFIG: restrict notrap ignored
Aug 29 17:08:45 lasso ntpd[395]: CLOCK: leapsecond file ('/usr/share/zoneinfo/leap-seconds.list'): good hash signature
Aug 29 17:08:45 lasso ntpd[395]: CLOCK: leapsecond file ('/usr/share/zoneinfo/leap-seconds.list'): loaded, expire=2023-12-28T00:00Z last=2017-01-01T00:00Z ofs=37
Aug 29 17:08:45 lasso ntpd[395]: INIT: Using SO_TIMESTAMPNS(ns)
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen and drop on 0 v6wildcard [::]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen and drop on 1 v4wildcard 0.0.0.0:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 2 lo 127.0.0.1:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 3 ens3 192.168.181.164:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 4 ens3 192.168.181.53:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 5 lo [::1]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 6 ens3 [2a01:238:42bc:a181:5054:ff:fe9e:9a15]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 7 ens3 [2a01:238:42bc:a181::35:100]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 8 ens3 [2a01:238:42bc:a181::a4:100]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 9 ens3 [fec0:0:0:ffff::3]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 10 ens3 [fec0:0:0:ffff::2]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 11 ens3 [fec0:0:0:ffff::1]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listen normally on 12 ens3 [fe80::5054:ff:fe9e:9a15%2]:123
Aug 29 17:08:45 lasso ntpd[395]: IO: Listening on routing socket on fd #29 for interface updates
Aug 29 17:08:45 lasso ntpd[395]: INIT: MRU 10922 entries, 13 hash bits, 65536 bytes
Aug 29 17:08:45 lasso ntpd[395]: INIT: OpenSSL 3.0.9 30 May 2023, 30000090
Aug 29 17:08:45 lasso ntpd[395]: NTSc: Using system default root certificates.
Aug 29 17:08:45 lasso ntpd[395]: statistics directory /var/log/ntpsec/ does not exist or is unwriteable, error No such file or directory
Aug 29 17:08:46 lasso ntpd[395]: DNS: dns_probe: torres.zugschlus.de, cast_flags:1, flags:20901
Aug 29 17:08:47 lasso ntpd[395]: DNS: dns_check: processing torres.zugschlus.de, 1, 20901
Aug 29 17:08:47 lasso ntpd[395]: DNS: Server taking: 2a01:238:42bc:a101::2:100
Aug 29 17:08:47 lasso ntpd[395]: DNS: dns_take_status: torres.zugschlus.de=>good, 0
Aug 29 17:08:47 lasso ntpd[395]: DNS: dns_probe: gancho.zugschlus.de, cast_flags:1, flags:20901
Aug 29 17:08:47 lasso ntpd[395]: DNS: dns_check: processing gancho.zugschlus.de, 1, 20901
Aug 29 17:08:47 lasso ntpd[395]: DNS: Server taking: 2a01:4f8:140:246a::2
Aug 29 17:08:47 lasso ntpd[395]: DNS: dns_take_status: gancho.zugschlus.de=>good, 0
Aug 29 17:08:48 lasso ntpd[395]: DNS: dns_probe: alemana.zugschlus.de, cast_flags:1, flags:20901
Aug 29 17:08:48 lasso ntpd[395]: DNS: dns_check: processing alemana.zugschlus.de, 1, 20901
Aug 29 17:08:49 lasso ntpd[395]: DNS: Server taking: 2001:67c:24f8:1002::45:100
Aug 29 17:08:49 lasso ntpd[395]: DNS: dns_take_status: alemana.zugschlus.de=>good, 0
Aug 29 17:08:49 lasso ntpd[395]: DNS: dns_probe: ptbtime1.ptb.de, cast_flags:1, flags:20901
Aug 29 17:08:50 lasso ntpd[395]: DNS: dns_check: processing ptbtime1.ptb.de, 1, 20901
Aug 29 17:08:50 lasso ntpd[395]: DNS: Server taking: 2001:638:610:be01::108
Aug 29 17:08:50 lasso ntpd[395]: DNS: dns_take_status: ptbtime1.ptb.de=>good, 0
Aug 29 17:08:50 lasso ntpd[395]: DNS: dns_probe: ptbtime2.ptb.de, cast_flags:1, flags:20901
Aug 29 17:08:51 lasso ntpd[395]: DNS: dns_check: processing ptbtime2.ptb.de, 1, 20901
Aug 29 17:08:51 lasso ntpd[395]: DNS: Server taking: 2001:638:610:be01::104
Aug 29 17:08:51 lasso ntpd[395]: DNS: dns_take_status: ptbtime2.ptb.de=>good, 0
Aug 29 17:08:51 lasso ntpd[395]: DNS: dns_probe: ptbtime3.ptb.de, cast_flags:1, flags:20901
Aug 29 17:08:52 lasso ntpd[395]: DNS: dns_check: processing ptbtime3.ptb.de, 1, 20901
Aug 29 17:08:52 lasso ntpd[395]: DNS: Server taking: 2001:638:610:be01::103
Aug 29 17:08:52 lasso ntpd[395]: DNS: dns_take_status: ptbtime3.ptb.de=>good, 0
Aug 29 17:08:58 lasso systemd-resolved[258]: Clock change detected. Flushing caches.
Aug 29 17:08:58 lasso ntpd[395]: CLOCK: time stepped by 1.085879
Aug 29 17:08:58 lasso ntpd[395]: INIT: MRU 10922 entries, 13 hash bits, 65536 bytes
Aug 29 17:09:12 lasso su[344]: pam_systemd(su:session): Failed to create session: Connection timed out
Aug 29 17:09:12 lasso su[344]: pam_unix(su:session): session closed for user Debian-console-log
Aug 29 17:09:12 lasso console-log[312]: Starting console-log:
Aug 29 17:09:12 lasso su[422]: (to Debian-console-log) root on none
Aug 29 17:09:12 lasso su[422]: pam_unix(su:session): session opened for user Debian-console-log(uid=106) by (uid=0)
Aug 29 17:09:16 lasso exim4[384]: Starting MTA: exim4.
Aug 29 17:09:17 lasso systemd[1]: Started user@106.service - User Manager for UID 106.
Aug 29 17:09:46 lasso ippl[387]: Starting IP protocols logger: ippl.
Aug 29 17:09:47 lasso ippl[790]: IP Protocols Logger: started.
Aug 29 17:09:47 lasso systemd[1]: Started exim4.service - LSB: exim Mail Transport Agent.
Aug 29 17:10:13 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:10:13 lasso kernel: kauditd_printk_skb: 3 callbacks suppressed
Aug 29 17:10:13 lasso kernel: audit: type=1400 audit(1693321813.993:43): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:10:18 lasso systemd[1]: Started ippl.service - LSB: IP protocols logger.
Aug 29 17:10:43 lasso systemd-journald[215]: Data hash table of /run/log/journal/15338d79b87748dab72ff706bd05dadf/system.journal has a fill level at 75.1 (1537 of 2047 items, 958464 file size, 623 bytes per hash table item), suggesting rotation.
Aug 29 17:10:43 lasso systemd-journald[215]: /run/log/journal/15338d79b87748dab72ff706bd05dadf/system.journal: Journal header limits reached or header out-of-date, rotating.
Aug 29 17:10:49 lasso systemd[1]: Started ntpsec.service - Network Time Service.
Aug 29 17:11:07 lasso systemd-logind[322]: Failed to start session scope session-c2.scope: Connection timed out
Aug 29 17:11:07 lasso su[422]: pam_systemd(su:session): Failed to create session: Connection timed out
Aug 29 17:11:07 lasso su[422]: pam_unix(su:session): session closed for user Debian-console-log
Aug 29 17:11:07 lasso console-log[338]:  /var/log/syslog/syslog /var/log/exim4/mainlog
Aug 29 17:11:07 lasso console-log[312]: .
Aug 29 17:11:20 lasso systemd[1]: Started console-log.service - LSB: Puts a logfile pager on virtual consoles.
Aug 29 17:11:51 lasso systemd[1]: session-c1.scope: Couldn't move process 344 to requested cgroup '/user.slice/user-106.slice/session-c1.scope': No such process
Aug 29 17:11:51 lasso systemd[1]: session-c1.scope: Failed to add PIDs to scope's control group: No such process
Aug 29 17:11:51 lasso systemd[1]: session-c1.scope: Failed with result 'resources'.
Aug 29 17:11:51 lasso systemd[1]: Failed to start session-c1.scope - Session c1 of User Debian-console-log.
Aug 29 17:12:21 lasso systemd[1]: Created slice system-ssh.slice - Slice /system/ssh.
Aug 29 17:12:52 lasso systemd[1]: Reached target multi-user.target - Multi-User System.
Aug 29 17:12:52 lasso systemd[1]: Reached target graphical.target - Graphical Interface.
Aug 29 17:13:22 lasso systemd[1]: Started ssh@0-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:39482.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:39482).
Aug 29 17:13:23 lasso sshd[809]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:13:23 lasso sshd[809]: Connection closed by 2a01:4f8:140:246a::32:100 port 39482
Aug 29 17:13:53 lasso systemd[1]: Started ssh@1-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:44980.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:44980).
Aug 29 17:13:53 lasso sshd[810]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:13:53 lasso sshd[810]: Connection closed by 2a01:4f8:140:246a::32:100 port 44980
Aug 29 17:14:24 lasso systemd[1]: Started ssh@2-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:55654.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:55654).
Aug 29 17:14:24 lasso sshd[811]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:14:24 lasso sshd[811]: Connection closed by 2a01:4f8:140:246a::32:100 port 55654
Aug 29 17:14:55 lasso systemd[1]: Started ssh@3-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:58080.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:58080).
Aug 29 17:14:55 lasso sshd[812]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:14:55 lasso sshd[812]: Connection closed by 2a01:4f8:140:246a::32:100 port 58080
Aug 29 17:15:25 lasso systemd[1]: Starting systemd-update-utmp-runlevel.service - Record Runlevel Change in UTMP...
Aug 29 17:15:56 lasso systemd[1]: ssh@0-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:39482.service: Deactivated successfully.
Aug 29 17:15:56 lasso systemd[1]: ssh@1-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:44980.service: Deactivated successfully.
Aug 29 17:15:56 lasso systemd[1]: ssh@2-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:55654.service: Deactivated successfully.
Aug 29 17:15:56 lasso systemd[1]: ssh@3-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:58080.service: Deactivated successfully.
Aug 29 17:15:56 lasso systemd[1]: systemd-update-utmp-runlevel.service: Deactivated successfully.
Aug 29 17:15:56 lasso systemd[1]: Finished systemd-update-utmp-runlevel.service - Record Runlevel Change in UTMP.
Aug 29 17:15:57 lasso systemd[1]: Started ssh@4-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:33502.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:33502).
Aug 29 17:15:57 lasso systemd[1]: Started ssh@5-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:39416.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:39416).
Aug 29 17:15:57 lasso systemd[1]: Started ssh@6-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:44054.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:44054).
Aug 29 17:15:57 lasso systemd[1]: Started ssh@7-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:60324.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:60324).
Aug 29 17:15:57 lasso systemd[1]: Startup finished in 9.335s (kernel) + 44min 13.527s (userspace) = 44min 22.862s.
Aug 29 17:15:57 lasso sshd[823]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:15:57 lasso sshd[823]: Connection closed by 2a01:4f8:140:246a::32:100 port 33502
Aug 29 17:15:57 lasso systemd[1]: ssh@4-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:33502.service: Deactivated successfully.
Aug 29 17:15:57 lasso sshd[824]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:15:57 lasso sshd[824]: Connection closed by 2a01:4f8:140:246a::32:100 port 39416
Aug 29 17:15:57 lasso systemd[1]: ssh@5-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:39416.service: Deactivated successfully.
Aug 29 17:15:57 lasso sshd[825]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:15:57 lasso sshd[825]: Connection closed by 2a01:4f8:140:246a::32:100 port 44054
Aug 29 17:15:57 lasso systemd[1]: ssh@6-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:44054.service: Deactivated successfully.
Aug 29 17:15:57 lasso sshd[826]: error: kex_exchange_identification: Connection closed by remote host
Aug 29 17:15:57 lasso sshd[826]: Connection closed by 2a01:4f8:140:246a::32:100 port 60324
Aug 29 17:15:57 lasso systemd[1]: ssh@7-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:60324.service: Deactivated successfully.
Aug 29 17:16:07 lasso systemd[1]: Stopping user@106.service - User Manager for UID 106...
Aug 29 17:16:07 lasso systemd[365]: Activating special unit exit.target...
Aug 29 17:16:07 lasso systemd[365]: Stopped target default.target - Main User Target.
Aug 29 17:16:07 lasso systemd[365]: Stopped target basic.target - Basic System.
Aug 29 17:16:07 lasso systemd[365]: Stopped target paths.target - Paths.
Aug 29 17:16:07 lasso systemd[365]: Stopped target sockets.target - Sockets.
Aug 29 17:16:07 lasso systemd[365]: Stopped target timers.target - Timers.
Aug 29 17:16:07 lasso systemd[365]: Closed dirmngr.socket - GnuPG network certificate management daemon.
Aug 29 17:16:07 lasso systemd[365]: Closed gpg-agent-browser.socket - GnuPG cryptographic agent and passphrase cache (access for web browsers).
Aug 29 17:16:07 lasso systemd[365]: Closed gpg-agent-extra.socket - GnuPG cryptographic agent and passphrase cache (restricted).
Aug 29 17:16:07 lasso systemd[365]: Closed gpg-agent-ssh.socket - GnuPG cryptographic agent (ssh-agent emulation).
Aug 29 17:16:07 lasso systemd[365]: Closed gpg-agent.socket - GnuPG cryptographic agent and passphrase cache.
Aug 29 17:16:07 lasso systemd[365]: Removed slice app.slice - User Application Slice.
Aug 29 17:16:07 lasso systemd[365]: Reached target shutdown.target - Shutdown.
Aug 29 17:16:07 lasso systemd[365]: Finished systemd-exit.service - Exit the Session.
Aug 29 17:16:07 lasso systemd[365]: Reached target exit.target - Exit the Session.
Aug 29 17:16:07 lasso systemd[1]: user@106.service: Deactivated successfully.
Aug 29 17:16:07 lasso systemd[1]: Stopped user@106.service - User Manager for UID 106.
Aug 29 17:16:07 lasso systemd[1]: Stopping user-runtime-dir@106.service - User Runtime Directory /run/user/106...
Aug 29 17:16:07 lasso systemd[1]: run-user-106.mount: Deactivated successfully.
Aug 29 17:16:07 lasso systemd[1]: user-runtime-dir@106.service: Deactivated successfully.
Aug 29 17:16:07 lasso systemd[1]: Stopped user-runtime-dir@106.service - User Runtime Directory /run/user/106.
Aug 29 17:16:07 lasso systemd[1]: Removed slice user-106.slice - User Slice of UID 106.
Aug 29 17:16:40 lasso systemd[1]: Started ssh@8-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:39918.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:39918).
Aug 29 17:16:40 lasso sshd[833]: Connection closed by 2a01:4f8:140:246a::32:100 port 39918 [preauth]
Aug 29 17:16:40 lasso systemd[1]: ssh@8-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:39918.service: Deactivated successfully.
Aug 29 17:17:01 lasso CRON[836]: pam_unix(cron:session): session opened for user root(uid=0) by (uid=0)
Aug 29 17:17:01 lasso CRON[837]: (root) CMD (cd / && run-parts --report /etc/cron.hourly)
Aug 29 17:17:01 lasso CRON[836]: pam_unix(cron:session): session closed for user root
Aug 29 17:17:39 lasso systemd[1]: Started ssh@9-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:60790.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:60790).
Aug 29 17:17:39 lasso sshd[840]: Connection closed by 2a01:4f8:140:246a::32:100 port 60790 [preauth]
Aug 29 17:17:39 lasso systemd[1]: ssh@9-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:60790.service: Deactivated successfully.
Aug 29 17:18:35 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:18:35 lasso kernel: audit: type=1400 audit(1693322315.652:44): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:18:37 lasso systemd[1]: Started ssh@10-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:49946.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:49946).
Aug 29 17:18:38 lasso sshd[844]: Connection closed by 2a01:4f8:140:246a::32:100 port 49946 [preauth]
Aug 29 17:18:38 lasso systemd[1]: ssh@10-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:49946.service: Deactivated successfully.
Aug 29 17:19:08 lasso systemd[1]: Started ssh@11-2a01:238:42bc:a181::a4:100:22-2a01:238:42bc:a182::1c:100:37921.service - OpenBSD Secure Shell server per-connection daemon ([2a01:238:42bc:a182::1c:100]:37921).
Aug 29 17:19:11 lasso sshd[848]: Connection closed by authenticating user mh 2a01:238:42bc:a182::1c:100 port 37921 [preauth]
Aug 29 17:19:11 lasso systemd[1]: ssh@11-2a01:238:42bc:a181::a4:100:22-2a01:238:42bc:a182::1c:100:37921.service: Deactivated successfully.
Aug 29 17:19:12 lasso systemd[1]: Started ssh@12-2a01:238:42bc:a181::a4:100:22-2a01:238:42bc:a182::1c:100:49905.service - OpenBSD Secure Shell server per-connection daemon ([2a01:238:42bc:a182::1c:100]:49905).
Aug 29 17:19:14 lasso sshd[852]: Accepted publickey for mh from 2a01:238:42bc:a182::1c:100 port 49905 ssh2: RSA SHA256:8fnWmoGb4Nz/nhQVYTP+89ba1ZasPWKCpCtUyu/Er9g
Aug 29 17:19:14 lasso sshd[852]: pam_unix(sshd:session): session opened for user mh(uid=1001) by (uid=0)
Aug 29 17:19:14 lasso systemd-logind[322]: New session 3 of user mh.
Aug 29 17:19:14 lasso systemd[1]: Created slice user-1001.slice - User Slice of UID 1001.
Aug 29 17:19:14 lasso systemd[1]: Starting user-runtime-dir@1001.service - User Runtime Directory /run/user/1001...
Aug 29 17:19:14 lasso systemd[1]: Finished user-runtime-dir@1001.service - User Runtime Directory /run/user/1001.
Aug 29 17:19:14 lasso systemd[1]: Starting user@1001.service - User Manager for UID 1001...
Aug 29 17:19:14 lasso (systemd)[855]: pam_unix(systemd-user:session): session opened for user mh(uid=1001) by (uid=0)
Aug 29 17:19:15 lasso systemd[855]: Queued start job for default target default.target.
Aug 29 17:19:15 lasso systemd[855]: Created slice app.slice - User Application Slice.
Aug 29 17:19:15 lasso systemd[855]: Reached target paths.target - Paths.
Aug 29 17:19:15 lasso systemd[855]: Reached target timers.target - Timers.
Aug 29 17:19:15 lasso systemd[855]: Listening on dirmngr.socket - GnuPG network certificate management daemon.
Aug 29 17:19:15 lasso systemd[855]: Listening on gpg-agent-browser.socket - GnuPG cryptographic agent and passphrase cache (access for web browsers).
Aug 29 17:19:15 lasso systemd[855]: Listening on gpg-agent-extra.socket - GnuPG cryptographic agent and passphrase cache (restricted).
Aug 29 17:19:15 lasso systemd[855]: Listening on gpg-agent-ssh.socket - GnuPG cryptographic agent (ssh-agent emulation).
Aug 29 17:19:15 lasso systemd[855]: Listening on gpg-agent.socket - GnuPG cryptographic agent and passphrase cache.
Aug 29 17:19:15 lasso systemd[855]: Reached target sockets.target - Sockets.
Aug 29 17:19:15 lasso systemd[855]: Reached target basic.target - Basic System.
Aug 29 17:19:15 lasso systemd[1]: Started user@1001.service - User Manager for UID 1001.
Aug 29 17:19:15 lasso systemd[855]: Reached target default.target - Main User Target.
Aug 29 17:19:15 lasso systemd[855]: Startup finished in 602ms.
Aug 29 17:19:15 lasso systemd[1]: Started session-3.scope - Session 3 of User mh.
Aug 29 17:19:16 lasso sshd[852]: pam_env(sshd:session): deprecated reading of user environment enabled
Aug 29 17:19:18 lasso audit[320]: AVC apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:19:18 lasso kernel: audit: type=1400 audit(1693322358.044:45): apparmor="DENIED" operation="open" class="file" profile="named" name="/var/local/chroot/bind/" pid=320 comm="named" requested_mask="r" denied_mask="r" fsuid=111 ouid=0
Aug 29 17:19:32 lasso sudo[1086]:       mh : TTY=pts/2 ; PWD=/home/mh ; USER=root ; COMMAND=/usr/bin/journalctl
Aug 29 17:19:32 lasso sudo[1086]: pam_unix(sudo:session): session opened for user root(uid=0) by mh(uid=1001)
Aug 29 17:19:36 lasso systemd[1]: Started ssh@13-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:35018.service - OpenBSD Secure Shell server per-connection daemon ([2a01:4f8:140:246a::32:100]:35018).
Aug 29 17:19:36 lasso sshd[1091]: Connection closed by 2a01:4f8:140:246a::32:100 port 35018 [preauth]
Aug 29 17:19:36 lasso systemd[1]: ssh@13-2a01:238:42bc:a181::a4:100:22-2a01:4f8:140:246a::32:100:35018.service: Deactivated successfully.
Aug 29 17:19:37 lasso sudo[1086]: pam_unix(sudo:session): session closed for user root
Aug 29 17:19:43 lasso sudo[1099]:       mh : TTY=pts/2 ; PWD=/home/mh ; USER=root ; COMMAND=/usr/bin/journalctl
Aug 29 17:19:43 lasso sudo[1099]: pam_unix(sudo:session): session opened for user root(uid=0) by mh(uid=1001)

--H5U3twqR8womlfTq--
