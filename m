Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8981D2C1C
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 12:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgENKES convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 May 2020 06:04:18 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:54444 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgENKER (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 06:04:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=teawaterz@linux.alibaba.com;NM=1;PH=DS;RN=41;SR=0;TI=SMTPD_---0TyWng6Y_1589450561;
Received: from 127.0.0.1(mailfrom:teawaterz@linux.alibaba.com fp:SMTPD_---0TyWng6Y_1589450561)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 May 2020 18:02:56 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [virtio-dev] [PATCH v3 00/15] virtio-mem: paravirtualized memory
From:   teawater <teawaterz@linux.alibaba.com>
In-Reply-To: <31c5d2f9-c104-53e8-d9c8-cb45f7507c85@redhat.com>
Date:   Thu, 14 May 2020 18:02:41 +0800
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A3BBAEEE-FBB9-4259-8BED-023CCD530021@linux.alibaba.com>
References: <20200507103119.11219-1-david@redhat.com>
 <7848642F-6AA7-4B5E-AE0E-DB0857C94A93@linux.alibaba.com>
 <31c5d2f9-c104-53e8-d9c8-cb45f7507c85@redhat.com>
To:     David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> 2020年5月14日 16:48，David Hildenbrand <david@redhat.com> 写道：
> 
> On 14.05.20 08:44, teawater wrote:
>> Hi David,
>> 
>> I got a kernel warning with v2 and v3.
> 
> Hi Hui,
> 
> thanks for playing with the latest versions. Surprisingly, I can
> reproduce even by hotplugging a DIMM instead as well - that's good, so
> it's not related to virtio-mem, lol. Seems to be some QEMU setup issue
> with older machine types.
> 
> Can you switch to a newer qemu machine version, especially
> pc-i440fx-5.0? Both, hotplugging DIMMs and virtio-mem works for me with
> that QEMU machine just fine.

I still could reproduce this issue with pc-i440fx-5.0 or pc.  Did I miss anything?

> 
> What also seems to make it work with pc-i440fx-2.1, is giving the
> machine 4G of initial memory (-m 4g,slots=10,maxmem=5G).

After I changed command, I got error when guest kernel boot:
sudo /home/teawater/qemu/qemu/x86_64-softmmu/qemu-system-x86_64 -machine pc,accel=kvm,usb=off -cpu host -no-reboot -nographic -device ide-hd,drive=hd -drive if=none,id=hd,file=/home/teawater/old.img,format=raw -kernel /home/teawater/kernel/bk2/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/sda nokaslr swiotlb=noforce" -m 4g,slots=10,maxmem=5G -smp 1 -s -monitor unix:/home/teawater/qemu/m,server,nowait
SeaBIOS (version rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org)


iPXE (http://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+BFF905B0+BFEF05B0 CA00



Booting from ROM..
[    0.000000] Linux version 5.7.0-rc4-next-20200507+ (teawater@iZbp1bv6xzjxt9vmytkdnmZ) (gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-39), GNU ld version0
[    0.000000] Command line: console=ttyS0 root=/dev/sda nokaslr swiotlb=noforce
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x020: 'AVX-512 opmask'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x040: 'AVX-512 Hi256'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x080: 'AVX-512 ZMM_Hi256'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: xstate_offset[5]:  960, xstate_sizes[5]:   64
[    0.000000] x86/fpu: xstate_offset[6]: 1024, xstate_sizes[6]:  512
[    0.000000] x86/fpu: xstate_offset[7]: 1536, xstate_sizes[7]: 1024
[    0.000000] x86/fpu: Enabled xstate features 0xff, context size is 2560 bytes, using 'compacted' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bffe0000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 2f12001, primary cpu clock
[    0.000000] kvm-clock: using sched offset of 227993437 cycles
[    0.000002] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000003] tsc: Detected 2499.998 MHz processor
[    0.001618] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.001659] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.001666] last_pfn = 0xbffe0 max_arch_pfn = 0x400000000
[    0.005474] found SMP MP-table at [mem 0x000f5ab0-0x000f5abf]
[    0.005649] check: Scanning 1 areas for low memory corruption
[    0.005676] Using GB pages for direct mapping
[    0.006325] ACPI: Early table checksum verification disabled
[    0.006328] ACPI: RSDP 0x00000000000F58B0 000014 (v00 BOCHS )
[    0.006330] ACPI: RSDT 0x00000000BFFE1F1E 000038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.006334] ACPI: FACP 0x00000000BFFE1CF2 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.006339] ACPI: DSDT 0x00000000BFFE0040 001CB2 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.006341] ACPI: FACS 0x00000000BFFE0000 000040
[    0.006343] ACPI: APIC 0x00000000BFFE1D66 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.006345] ACPI: HPET 0x00000000BFFE1DDE 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.006347] ACPI: SRAT 0x00000000BFFE1E16 0000E0 (v01 BOCHS  BXPCSRAT 00000001 BXPC 00000001)
[    0.006349] ACPI: WAET 0x00000000BFFE1EF6 000028 (v01 BOCHS  BXPCWAET 00000001 BXPC 00000001)
[    0.006421] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.006424] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.006426] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.006428] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x13fffffff]
[    0.006429] ACPI: SRAT: Node 0 PXM 0 [mem 0x140000000-0x3ffffffff] hotplug
[    0.006433] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.006435] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x13fffffff] -> [mem 0x00000000-0x13fffffff]
[    0.006449] NODE_DATA(0) allocated [mem 0x13ffd4000-0x13fffdfff]
[    0.007109] Zone ranges:
[    0.007110]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.007111]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.007112]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
[    0.007113]   Device   empty
[    0.007114] Movable zone start for each node
[    0.007116] Early memory node ranges
[    0.007117]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.007119]   node   0: [mem 0x0000000000100000-0x00000000bffdffff]
[    0.007119]   node   0: [mem 0x0000000100000000-0x000000013fffffff]
[    0.007880] Zeroed struct page in unavailable ranges: 130 pages
[    0.007881] Initmem setup node 0 [mem 0x0000000000001000-0x000000013fffffff]
[    0.023595] ACPI: PM-Timer IO Port: 0x608
[    0.023611] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.023643] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.023646] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.023647] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.023648] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.023649] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.023650] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.023656] Using ACPI (MADT) for SMP configuration information
[    0.023657] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.023663] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.023674] KVM setup pv remote TLB flush
[    0.023690] PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.023692] PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.023694] PM: hibernation: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.023695] PM: hibernation: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.023698] PM: hibernation: Registered nosave memory: [mem 0xbffe0000-0xbfffffff]
[    0.023699] PM: hibernation: Registered nosave memory: [mem 0xc0000000-0xfeffbfff]
[    0.023701] PM: hibernation: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.023702] PM: hibernation: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.023703] PM: hibernation: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.023706] [mem 0xc0000000-0xfeffbfff] available for PCI devices
[    0.023708] Booting paravirtualized kernel on KVM
[    0.023711] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.028274] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
[    0.028748] percpu: Embedded 55 pages/cpu s188376 r8192 d28712 u2097152
[    0.028778] KVM setup async PF for cpu 0
[    0.028784] kvm-stealtime: cpu 0, msr 13bc19580
[    0.028791] Built 1 zonelists, mobility grouping on.  Total pages: 1032041
[    0.028793] Policy zone: Normal
[    0.028794] Kernel command line: console=ttyS0 root=/dev/sda nokaslr swiotlb=noforce
[    0.029720] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.030154] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.030188] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.037244] Memory: 4086692K/4193784K available (14339K kernel code, 2474K rwdata, 4860K rodata, 2408K init, 3324K bss, 107092K reserved, 0K cma-r)
[    0.037640] random: get_random_u64 called from cache_random_seq_create+0x74/0x120 with crng_init=0
[    0.037687] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.037696] ftrace: allocating 43405 entries in 170 pages
[    0.050874] ftrace: allocated 170 pages with 4 groups
[    0.051295] rcu: Hierarchical RCU implementation.
[    0.051296] rcu: 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=1.
[    0.051297] 	Trampoline variant of Tasks RCU enabled.
[    0.051298] 	Rude variant of Tasks RCU enabled.
[    0.051299] 	Tracing variant of Tasks RCU enabled.
[    0.051299] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.051300] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.054124] NR_IRQS: 524544, nr_irqs: 256, preallocated irqs: 16
[    0.061561] Console: colour VGA+ 80x25
[    0.142370] printk: console [ttyS0] enabled
[    0.142809] ACPI: Core revision 20200326
[    0.143320] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
[    0.144321] APIC: Switch to symmetric I/O mode setup
[    0.144988] x2apic enabled
[    0.145454] Switched APIC routing to physical x2apic.
[    0.145969] KVM setup pv IPIs
[    0.147050] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.147674] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x240937b9988, max_idle_ns: 440795218083 ns
[    0.148748] Calibrating delay loop (skipped) preset value.. 4999.99 BogoMIPS (lpj=9999992)
[    0.149579] pid_max: default: 32768 minimum: 301
[    0.150058] LSM: Security Framework initializing
[    0.150536] Yama: becoming mindful.
[    0.150912] AppArmor: AppArmor initialized
[    0.151331] TOMOYO Linux initialized
[    0.151726] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.152754] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.153769] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    0.154479] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.155015] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.155619] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.156469] Spectre V2 : Mitigation: Enhanced IBRS
[    0.156749] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.157531] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.158326] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
[    0.159236] TAA: Vulnerable: Clear CPU buffers attempted, no microcode
[    0.163546] Freeing SMP alternatives memory: 40K
[    0.165628] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8269CY CPU @ 2.50GHz (family: 0x6, model: 0x55, stepping: 0x7)
[    0.166697] Performance Events: Skylake events, Intel PMU driver.
[    0.167301] ... version:                2
[    0.167684] ... bit width:              48
[    0.168081] ... generic registers:      4
[    0.168466] ... value mask:             0000ffffffffffff
[    0.168746] ... max period:             000000007fffffff
[    0.168746] ... fixed-purpose events:   3
[    0.168749] ... event mask:             000000070000000f
[    0.169286] rcu: Hierarchical SRCU implementation.
[    0.170873] smp: Bringing up secondary CPUs ...
[    0.171317] smp: Brought up 1 node, 1 CPU
[    0.171705] smpboot: Max logical packages: 1
[    0.172117] smpboot: Total of 1 processors activated (4999.99 BogoMIPS)
[    0.172930] devtmpfs: initialized
[    0.173284] x86/mm: Memory block size: 128MB
[    0.173995] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.174923] futex hash table entries: 256 (order: 2, 16384 bytes, linear)
[    0.175607] pinctrl core: initialized pinctrl subsystem
[    0.176208] PM: RTC time: 10:00:50, date: 2020-05-14
[    0.176688] thermal_sys: Registered thermal governor 'fair_share'
[    0.176689] thermal_sys: Registered thermal governor 'bang_bang'
[    0.176753] thermal_sys: Registered thermal governor 'step_wise'
[    0.177332] thermal_sys: Registered thermal governor 'user_space'
[    0.177982] NET: Registered protocol family 16
[    0.179042] audit: initializing netlink subsys (disabled)
[    0.179577] audit: type=2000 audit(1589450451.021:1): state=initialized audit_enabled=0 res=1
[    0.180450] cpuidle: using governor ladder
[    0.180753] cpuidle: using governor menu
[    0.181162] ACPI: bus type PCI registered
[    0.181548] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.182236] PCI: Using configuration type 1 for base access
[    0.183818] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.184470] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.185279] ACPI: Added _OSI(Module Device)
[    0.185693] ACPI: Added _OSI(Processor Device)
[    0.186119] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.186572] ACPI: Added _OSI(Processor Aggregator Device)
[    0.187089] ACPI: Added _OSI(Linux-Dell-Video)
[    0.187516] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.188027] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.189526] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.190963] ACPI: Interpreter enabled
[    0.191333] ACPI: (supports S0 S3 S4 S5)
[    0.191716] ACPI: Using IOAPIC for interrupt routing
[    0.192199] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.192891] ACPI: Enabled 3 GPEs in block 00 to 0F
[    0.196692] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.196758] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI HPX-Type3]
[    0.197500] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.199151] acpiphp: Slot [3] registered
[    0.199546] acpiphp: Slot [4] registered
[    0.199941] acpiphp: Slot [5] registered
[    0.200333] acpiphp: Slot [6] registered
[    0.200729] acpiphp: Slot [7] registered
[    0.200770] acpiphp: Slot [8] registered
[    0.201160] acpiphp: Slot [9] registered
[    0.201555] acpiphp: Slot [10] registered
[    0.201952] acpiphp: Slot [11] registered
[    0.202353] acpiphp: Slot [12] registered
[    0.202750] acpiphp: Slot [13] registered
[    0.203151] acpiphp: Slot [14] registered
[    0.203553] acpiphp: Slot [15] registered
[    0.203952] acpiphp: Slot [16] registered
[    0.204355] acpiphp: Slot [17] registered
[    0.204756] acpiphp: Slot [18] registered
[    0.205155] acpiphp: Slot [19] registered
[    0.205559] acpiphp: Slot [20] registered
[    0.205956] acpiphp: Slot [21] registered
[    0.206358] acpiphp: Slot [22] registered
[    0.206756] acpiphp: Slot [23] registered
[    0.207154] acpiphp: Slot [24] registered
[    0.207557] acpiphp: Slot [25] registered
[    0.207957] acpiphp: Slot [26] registered
[    0.208360] acpiphp: Slot [27] registered
[    0.208756] acpiphp: Slot [28] registered
[    0.209154] acpiphp: Slot [29] registered
[    0.209558] acpiphp: Slot [30] registered
[    0.209955] acpiphp: Slot [31] registered
[    0.210351] PCI host bridge to bus 0000:00
[    0.210742] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.211390] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.212033] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.212745] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff window]
[    0.212749] pci_bus 0000:00: root bus resource [mem 0x400000000-0x47fffffff window]
[    0.213475] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.214026] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.214916] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.215901] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.218196] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.219476] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.220155] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.220750] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.221430] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.222181] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.223058] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
[    0.223752] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
[    0.224604] pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
[    0.225627] pci 0000:00:02.0: reg 0x10: [mem 0xfd000000-0xfdffffff pref]
[    0.227840] pci 0000:00:02.0: reg 0x18: [mem 0xfebf0000-0xfebf0fff]
[    0.230963] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.231766] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.233184] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.234628] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.239497] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.240716] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.240833] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.241449] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.242063] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.242642] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.243547] iommu: Default domain type: Translated
[    0.244050] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.244631] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.244750] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.245300] vgaarb: loaded
[    0.245684] SCSI subsystem initialized
[    0.246080] ACPI: bus type USB registered
[    0.246485] usbcore: registered new interface driver usbfs
[    0.247015] usbcore: registered new interface driver hub
[    0.247532] usbcore: registered new device driver usb
[    0.248053] EDAC MC: Ver: 3.0.0
[    0.248488] PCI: Using ACPI for IRQ routing
[    0.248889] NetLabel: Initializing
[    0.249220] NetLabel:  domain hash size = 128
[    0.249642] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.250192] NetLabel:  unlabeled traffic allowed by default
[    0.250793] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.251268] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.255814] clocksource: Switched to clocksource kvm-clock
[    0.263083] VFS: Disk quotas dquot_6.6.0
[    0.263479] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.264215] AppArmor: AppArmor Filesystem Enabled
[    0.264683] pnp: PnP ACPI init
[    0.265570] pnp: PnP ACPI: found 6 devices
[    0.271088] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.271958] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.272551] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.273150] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.273805] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff window]
[    0.274463] pci_bus 0000:00: resource 8 [mem 0x400000000-0x47fffffff window]
[    0.275178] NET: Registered protocol family 2
[    0.275726] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
[    0.276548] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    0.277341] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    0.278089] TCP: Hash tables configured (established 32768 bind 32768)
[    0.279086] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    0.279734] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    0.280450] NET: Registered protocol family 1
[    0.280896] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.281455] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.282028] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.282652] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.283463] PCI: CLS 0 bytes, default 64
[    0.283865] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.284483] software IO TLB: mapped [mem 0xbffdf000-0xbffdf800] (0MB)
[    0.285199] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x240937b9988, max_idle_ns: 440795218083 ns
[    0.286167] check: Scanning for low memory corruption every 60 seconds
[    0.286998] Initialise system trusted keyrings
[    0.287462] workingset: timestamp_bits=36 max_order=20 bucket_order=0
[    0.288814] zbud: loaded
[    0.289224] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.289871] fuse: init (API version 7.31)
[    0.297407] Key type asymmetric registered
[    0.297815] Asymmetric key parser 'x509' registered
[    0.298289] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
[    0.299015] io scheduler mq-deadline registered
[    0.299548] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.300278] ACPI: Power Button [PWRF]
[    0.300786] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.301606] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.302840] Linux agpgart interface v0.103
[    0.304481] loop: module loaded
[    0.305665] scsi host0: ata_piix
[    0.306042] scsi host1: ata_piix
[    0.306385] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 14
[    0.307031] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 15
[    0.307930] libphy: Fixed MDIO Bus: probed
[    0.308331] tun: Universal TUN/TAP device driver, 1.6
[    0.308847] PPP generic driver version 2.4.2
[    0.309281] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.309907] ehci-pci: EHCI PCI platform driver
[    0.310340] ehci-platform: EHCI generic platform driver
[    0.310846] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.311437] ohci-pci: OHCI PCI platform driver
[    0.311869] ohci-platform: OHCI generic platform driver
[    0.312375] uhci_hcd: USB Universal Host Controller Interface driver
[    0.313181] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.314458] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.314934] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.315476] mousedev: PS/2 mouse device common for all mice
[    0.316182] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.317177] rtc_cmos 00:00: RTC can wake from S4
[    0.317895] rtc_cmos 00:00: registered as rtc0
[    0.318368] rtc_cmos 00:00: setting system clock to 2020-05-14T10:00:50 UTC (1589450450)
[    0.319151] rtc_cmos 00:00: alarms up to one day, y3k, 114 bytes nvram, hpet irqs
[    0.319867] i2c /dev entries driver
[    0.320229] device-mapper: uevent: version 1.0.3
[    0.320704] device-mapper: ioctl: 4.42.0-ioctl (2020-02-27) initialised: dm-devel@redhat.com
[    0.321515] intel_pstate: CPU model not supported
[    0.321972] ledtrig-cpu: registered to indicate activity on CPUs
[    0.322567] drop_monitor: Initializing network drop monitor service
[    0.323263] NET: Registered protocol family 10
[    0.323814] Segment Routing with IPv6
[    0.324183] NET: Registered protocol family 17
[    0.324631] Key type dns_resolver registered
[    0.325105] IPI shorthand broadcast: enabled
[    0.325522] sched_clock: Marking stable (238560739, 86481164)->(334226795, -9184892)
[    0.326296] registered taskstats version 1
[    0.326696] Loading compiled-in X.509 certificates
[    0.328051] Loaded X.509 cert 'Build time autogenerated kernel key: bd0fe972797988f0782b694de4de56b1ff6c4bc3'
[    0.329022] zswap: loaded using pool lzo/zbud
[    0.329489] Key type ._fscrypt registered
[    0.329877] Key type .fscrypt registered
[    0.330259] Key type fscrypt-provisioning registered
[    0.330851] Key type big_key registered
[    0.331274] Key type encrypted registered
[    0.331662] AppArmor: AppArmor sha1 policy hashing enabled
[    0.332190] ima: No TPM chip found, activating TPM-bypass!
[    0.332716] ima: Allocated hash algorithm: sha1
[    0.333171] ima: No architecture policies found
[    0.333646] evm: Initialising EVM extended attributes:
[    0.334144] evm: security.selinux
[    0.334463] evm: security.SMACK64
[    0.334782] evm: security.SMACK64EXEC
[    0.335138] evm: security.SMACK64TRANSMUTE
[    0.335531] evm: security.SMACK64MMAP
[    0.335884] evm: security.apparmor
[    0.336215] evm: security.ima
[    0.336504] evm: security.capability
[    0.336855] evm: HMAC attrs: 0x1
[    0.337354] PM:   Magic number: 4:67:22
[    0.473227] ata2.00: ATA-7: QEMU HARDDISK, 2.5+, max UDMA/100
[    0.473785] ata2.00: 524288 sectors, multi 16: LBA48
[    0.474659] scsi 1:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
[    0.475536] sd 1:0:0:0: [sda] 524288 512-byte logical blocks: (268 MB/256 MiB)
[    0.476237] sd 1:0:0:0: [sda] Write Protect is off
[    0.476704] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    0.477239] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.478205] ------------[ cut here ]------------
[    0.478652] ata_piix 0000:00:01.1: DMA addr 0x0000000139e4f000+4096 overflow (mask ffffffff, bus limit 0).
[    0.479580] WARNING: CPU: 0 PID: 6 at /home/teawater/kernel/linux2/kernel/dma/direct.c:400 dma_direct_map_page+0x118/0x130
[    0.480630] Modules linked in:
[    0.480933] CPU: 0 PID: 6 Comm: kworker/0:0H Not tainted 5.7.0-rc4-next-20200507+ #10
[    0.481681] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[    0.482770] Workqueue: kblockd blk_mq_run_work_fn
[    0.483230] RIP: 0010:dma_direct_map_page+0x118/0x130
[    0.483715] Code: 8b 1f e8 6b 48 5b 00 48 8d 4c 24 08 48 89 c6 4c 89 2c 24 4d 89 e1 49 89 e8 48 89 da 48 c7 c7 48 e4 34 82 31 c0 e8 18 77 f7 ff <00
[    0.485484] RSP: 0000:ffffc9000003bbe8 EFLAGS: 00010082
[    0.485984] RAX: 0000000000000000 RBX: ffff88813b3db310 RCX: ffffffff82667968
[    0.486663] RDX: 0000000000000001 RSI: 0000000000000096 RDI: 0000000000000046
[    0.487342] RBP: 0000000000001000 R08: 00000000000001bb R09: 00000000000001bb
[    0.488017] R10: 0000000000000000 R11: ffffc9000003b958 R12: 00000000ffffffff
[    0.488699] R13: 0000000000000000 R14: 0000000000000000 R15: ffff888139e272a8
[    0.489379] FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[    0.490148] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.490698] CR2: 0000000000000000 CR3: 000000000260a001 CR4: 0000000000360ef0
[    0.491377] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.492057] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    0.492736] Call Trace:
[    0.492985]  dma_direct_map_sg+0x64/0xb0
[    0.493369]  ? ata_scsi_write_same_xlat+0x350/0x350
[    0.493837]  ata_qc_issue+0x214/0x260
[    0.494199]  ? ata_scsi_write_same_xlat+0x350/0x350
[    0.494665]  __ata_scsi_queuecmd+0x190/0x410
[    0.495077]  ata_scsi_queuecmd+0x40/0x80
[    0.495455]  scsi_queue_rq+0x697/0xa90
[    0.495819]  blk_mq_dispatch_rq_list+0x90/0x590
[    0.496259]  ? elv_rb_del+0x1f/0x30
[    0.496597]  ? deadline_remove_request+0x6a/0xb0
[    0.497042]  blk_mq_do_dispatch_sched+0xe9/0x130
[    0.497488]  __blk_mq_sched_dispatch_requests+0xd8/0x160
[    0.497996]  blk_mq_sched_dispatch_requests+0x30/0x60
[    0.498483]  __blk_mq_run_hw_queue+0x7e/0x130
[    0.498904]  process_one_work+0x166/0x370
[    0.499296]  worker_thread+0x49/0x3e0
[    0.499650]  kthread+0xf8/0x130
[    0.499957]  ? max_active_store+0x80/0x80
[    0.500347]  ? kthread_bind+0x10/0x10
[    0.500701]  ret_from_fork+0x1f/0x30
[    0.501048] ---[ end trace cfd92832ca2f7781 ]---
[    0.524773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.525404] ata2.00: failed command: READ DMA
[    0.525824] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.525824]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.527275] ata2.00: status: { DRDY }
[    0.528160] ata2.00: configured for MWDMA2
[    0.528558] ata2: EH complete
[    0.540770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.541399] ata2.00: failed command: READ DMA
[    0.541818] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.541818]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.543265] ata2.00: status: { DRDY }
[    0.544129] ata2.00: configured for MWDMA2
[    0.544525] ata2: EH complete
[    0.556771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.557389] ata2.00: failed command: READ DMA
[    0.557810] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.557810]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.559255] ata2.00: status: { DRDY }
[    0.560115] ata2.00: configured for MWDMA2
[    0.560509] ata2: EH complete
[    0.572770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.573398] ata2.00: failed command: READ DMA
[    0.573818] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.573818]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.575264] ata2.00: status: { DRDY }
[    0.576125] ata2.00: configured for MWDMA2
[    0.576522] ata2: EH complete
[    0.588772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.589409] ata2.00: failed command: READ DMA
[    0.589831] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.589831]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.591275] ata2.00: status: { DRDY }
[    0.592136] ata2.00: configured for MWDMA2
[    0.592532] ata2: EH complete
[    0.604771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.605400] ata2.00: failed command: READ DMA
[    0.605821] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.605821]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.607273] ata2.00: status: { DRDY }
[    0.608135] ata2.00: configured for MWDMA2
[    0.608535] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    0.609415] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    0.610074] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    0.610703] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    0.611402] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    0.612336] Buffer I/O error on dev sda, logical block 0, async page read
[    0.612987] ata2: EH complete
[    0.636771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.637389] ata2.00: failed command: READ DMA
[    0.637808] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.637808]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.639254] ata2.00: status: { DRDY }
[    0.640112] ata2.00: configured for MWDMA2
[    0.640511] ata2: EH complete
[    0.652772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.653398] ata2.00: failed command: READ DMA
[    0.653818] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.653818]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.655267] ata2.00: status: { DRDY }
[    0.656126] ata2.00: configured for MWDMA2
[    0.656523] ata2: EH complete
[    0.668771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.669396] ata2.00: failed command: READ DMA
[    0.669815] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.669815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.671264] ata2.00: status: { DRDY }
[    0.672124] ata2.00: configured for MWDMA2
[    0.672521] ata2: EH complete
[    0.684770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.685390] ata2.00: failed command: READ DMA
[    0.685807] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.685807]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.687252] ata2.00: status: { DRDY }
[    0.688109] ata2.00: configured for MWDMA2
[    0.688506] ata2: EH complete
[    0.700769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.701388] ata2.00: failed command: READ DMA
[    0.701805] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.701805]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.703249] ata2.00: status: { DRDY }
[    0.704107] ata2.00: configured for MWDMA2
[    0.704502] ata2: EH complete
[    0.716769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.717389] ata2.00: failed command: READ DMA
[    0.717806] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.717806]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.719251] ata2.00: status: { DRDY }
[    0.720110] ata2.00: configured for MWDMA2
[    0.720507] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    0.721389] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    0.722042] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    0.722676] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    0.723374] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    0.724308] Buffer I/O error on dev sda, logical block 0, async page read
[    0.724959] ata2: EH complete
[    0.748770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.749390] ata2.00: failed command: READ DMA
[    0.749810] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.749810]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.751271] ata2.00: status: { DRDY }
[    0.752134] ata2.00: configured for MWDMA2
[    0.752533] ata2: EH complete
[    0.764771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.765388] ata2.00: failed command: READ DMA
[    0.765809] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.765809]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.767257] ata2.00: status: { DRDY }
[    0.768115] ata2.00: configured for MWDMA2
[    0.768511] ata2: EH complete
[    0.780773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.781390] ata2.00: failed command: READ DMA
[    0.781813] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.781813]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.783263] ata2.00: status: { DRDY }
[    0.784123] ata2.00: configured for MWDMA2
[    0.784520] ata2: EH complete
[    0.796771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.797394] ata2.00: failed command: READ DMA
[    0.797814] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.797814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.799262] ata2.00: status: { DRDY }
[    0.800122] ata2.00: configured for MWDMA2
[    0.800519] ata2: EH complete
[    0.812770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.813395] ata2.00: failed command: READ DMA
[    0.813815] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.813815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.815263] ata2.00: status: { DRDY }
[    0.816121] ata2.00: configured for MWDMA2
[    0.816517] ata2: EH complete
[    0.828770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.829395] ata2.00: failed command: READ DMA
[    0.829814] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.829814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.831267] ata2.00: status: { DRDY }
[    0.832126] ata2.00: configured for MWDMA2
[    0.832524] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    0.833403] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    0.834060] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    0.834692] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    0.835389] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    0.836319] Buffer I/O error on dev sda, logical block 0, async page read
[    0.836970] ata2: EH complete
[    0.837267] ldm_validate_partition_table(): Disk read failed.
[    0.860772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.861401] ata2.00: failed command: READ DMA
[    0.861822] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.861822]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.863269] ata2.00: status: { DRDY }
[    0.864132] ata2.00: configured for MWDMA2
[    0.864528] ata2: EH complete
[    0.876771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.877397] ata2.00: failed command: READ DMA
[    0.877817] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.877817]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.879266] ata2.00: status: { DRDY }
[    0.880127] ata2.00: configured for MWDMA2
[    0.880524] ata2: EH complete
[    0.892773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.893399] ata2.00: failed command: READ DMA
[    0.893820] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.893820]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.895273] ata2.00: status: { DRDY }
[    0.896133] ata2.00: configured for MWDMA2
[    0.896531] ata2: EH complete
[    0.908770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.909394] ata2.00: failed command: READ DMA
[    0.909814] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.909814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.911257] ata2.00: status: { DRDY }
[    0.912116] ata2.00: configured for MWDMA2
[    0.912512] ata2: EH complete
[    0.924770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.925398] ata2.00: failed command: READ DMA
[    0.925817] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.925817]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.927261] ata2.00: status: { DRDY }
[    0.928118] ata2.00: configured for MWDMA2
[    0.928515] ata2: EH complete
[    0.940771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.941387] ata2.00: failed command: READ DMA
[    0.941805] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.941805]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.943250] ata2.00: status: { DRDY }
[    0.944108] ata2.00: configured for MWDMA2
[    0.944505] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    0.945382] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    0.946039] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    0.946671] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    0.947370] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    0.948302] Buffer I/O error on dev sda, logical block 0, async page read
[    0.948956] ata2: EH complete
[    0.972774] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.973395] ata2.00: failed command: READ DMA
[    0.973812] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.973812]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.975262] ata2.00: status: { DRDY }
[    0.976126] ata2.00: configured for MWDMA2
[    0.976524] ata2: EH complete
[    0.988770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    0.989396] ata2.00: failed command: READ DMA
[    0.989815] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    0.989815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    0.991257] ata2.00: status: { DRDY }
[    0.992117] ata2.00: configured for MWDMA2
[    0.992511] ata2: EH complete
[    1.004769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.005398] ata2.00: failed command: READ DMA
[    1.005818] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.005818]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.007261] ata2.00: status: { DRDY }
[    1.008122] ata2.00: configured for MWDMA2
[    1.008518] ata2: EH complete
[    1.020770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.021398] ata2.00: failed command: READ DMA
[    1.021819] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.021819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.023262] ata2.00: status: { DRDY }
[    1.024123] ata2.00: configured for MWDMA2
[    1.024519] ata2: EH complete
[    1.036771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.037396] ata2.00: failed command: READ DMA
[    1.037816] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.037816]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.039262] ata2.00: status: { DRDY }
[    1.040120] ata2.00: configured for MWDMA2
[    1.040515] ata2: EH complete
[    1.052772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.053397] ata2.00: failed command: READ DMA
[    1.053818] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.053818]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.055264] ata2.00: status: { DRDY }
[    1.056125] ata2.00: configured for MWDMA2
[    1.056525] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    1.057404] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    1.058066] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    1.058695] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    1.059393] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    1.060325] Buffer I/O error on dev sda, logical block 0, async page read
[    1.060973] ata2: EH complete
[    1.084771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.085395] ata2.00: failed command: READ DMA
[    1.085814] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.085814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.087259] ata2.00: status: { DRDY }
[    1.088119] ata2.00: configured for MWDMA2
[    1.088514] ata2: EH complete
[    1.100770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.101395] ata2.00: failed command: READ DMA
[    1.101814] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.101814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.103259] ata2.00: status: { DRDY }
[    1.104118] ata2.00: configured for MWDMA2
[    1.104515] ata2: EH complete
[    1.116769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.117388] ata2.00: failed command: READ DMA
[    1.117805] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.117805]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.119248] ata2.00: status: { DRDY }
[    1.120106] ata2.00: configured for MWDMA2
[    1.120503] ata2: EH complete
[    1.132770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.133390] ata2.00: failed command: READ DMA
[    1.133807] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.133807]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.135253] ata2.00: status: { DRDY }
[    1.136113] ata2.00: configured for MWDMA2
[    1.136509] ata2: EH complete
[    1.148770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.149389] ata2.00: failed command: READ DMA
[    1.149806] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.149806]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.151248] ata2.00: status: { DRDY }
[    1.152108] ata2.00: configured for MWDMA2
[    1.152503] ata2: EH complete
[    1.164770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.165395] ata2.00: failed command: READ DMA
[    1.165814] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.165814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.167258] ata2.00: status: { DRDY }
[    1.168119] ata2.00: configured for MWDMA2
[    1.168515] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    1.169397] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    1.170054] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    1.170685] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    1.171382] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    1.172315] Buffer I/O error on dev sda, logical block 0, async page read
[    1.172965] ata2: EH complete
[    1.196770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.197391] ata2.00: failed command: READ DMA
[    1.197811] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.197811]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.199265] ata2.00: status: { DRDY }
[    1.200128] ata2.00: configured for MWDMA2
[    1.200525] ata2: EH complete
[    1.212770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.213389] ata2.00: failed command: READ DMA
[    1.213809] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.213809]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.215253] ata2.00: status: { DRDY }
[    1.216114] ata2.00: configured for MWDMA2
[    1.216510] ata2: EH complete
[    1.228773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.229398] ata2.00: failed command: READ DMA
[    1.229819] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.229819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.231273] ata2.00: status: { DRDY }
[    1.232132] ata2.00: configured for MWDMA2
[    1.232528] ata2: EH complete
[    1.244773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.245399] ata2.00: failed command: READ DMA
[    1.245821] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.245821]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.247269] ata2.00: status: { DRDY }
[    1.248128] ata2.00: configured for MWDMA2
[    1.248525] ata2: EH complete
[    1.260770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.261391] ata2.00: failed command: READ DMA
[    1.261813] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.261813]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.263263] ata2.00: status: { DRDY }
[    1.264124] ata2.00: configured for MWDMA2
[    1.264520] ata2: EH complete
[    1.276771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.277389] ata2.00: failed command: READ DMA
[    1.277809] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.277809]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.279253] ata2.00: status: { DRDY }
[    1.280112] ata2.00: configured for MWDMA2
[    1.280510] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    1.281385] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    1.282040] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    1.282672] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    1.283371] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    1.284305] Buffer I/O error on dev sda, logical block 0, async page read
[    1.284960] ata2: EH complete
[    1.285254] Dev sda: unable to read RDB block 0
[    1.308770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.309404] ata2.00: failed command: READ DMA
[    1.309825] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.309825]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.311278] ata2.00: status: { DRDY }
[    1.312142] ata2.00: configured for MWDMA2
[    1.312538] ata2: EH complete
[    1.324770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.325398] ata2.00: failed command: READ DMA
[    1.325817] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.325817]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.327269] ata2.00: status: { DRDY }
[    1.328127] ata2.00: configured for MWDMA2
[    1.328520] ata2: EH complete
[    1.340770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.341396] ata2.00: failed command: READ DMA
[    1.341813] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.341813]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.343258] ata2.00: status: { DRDY }
[    1.344120] ata2.00: configured for MWDMA2
[    1.344515] ata2: EH complete
[    1.356771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.357396] ata2.00: failed command: READ DMA
[    1.357815] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.357815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.359258] ata2.00: status: { DRDY }
[    1.360118] ata2.00: configured for MWDMA2
[    1.360514] ata2: EH complete
[    1.372772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.373399] ata2.00: failed command: READ DMA
[    1.373822] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.373822]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.375275] ata2.00: status: { DRDY }
[    1.376135] ata2.00: configured for MWDMA2
[    1.376533] ata2: EH complete
[    1.388773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.389397] ata2.00: failed command: READ DMA
[    1.389817] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.389817]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.391263] ata2.00: status: { DRDY }
[    1.392122] ata2.00: configured for MWDMA2
[    1.392522] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    1.393400] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    1.394057] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    1.394687] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    1.395388] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    1.396323] Buffer I/O error on dev sda, logical block 0, async page read
[    1.396975] ata2: EH complete
[    1.420771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.421400] ata2.00: failed command: READ DMA
[    1.421819] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.421819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.423267] ata2.00: status: { DRDY }
[    1.424124] ata2.00: configured for MWDMA2
[    1.424521] ata2: EH complete
[    1.436771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.437395] ata2.00: failed command: READ DMA
[    1.437813] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.437813]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.439261] ata2.00: status: { DRDY }
[    1.440120] ata2.00: configured for MWDMA2
[    1.440516] ata2: EH complete
[    1.452770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.453399] ata2.00: failed command: READ DMA
[    1.453816] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.453816]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.455259] ata2.00: status: { DRDY }
[    1.456116] ata2.00: configured for MWDMA2
[    1.456512] ata2: EH complete
[    1.468769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.469387] ata2.00: failed command: READ DMA
[    1.469802] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.469802]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.471246] ata2.00: status: { DRDY }
[    1.472105] ata2.00: configured for MWDMA2
[    1.472501] ata2: EH complete
[    1.484769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.485403] ata2.00: failed command: READ DMA
[    1.485822] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.485822]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.487269] ata2.00: status: { DRDY }
[    1.488128] ata2.00: configured for MWDMA2
[    1.488524] ata2: EH complete
[    1.500770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.501389] ata2.00: failed command: READ DMA
[    1.501807] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.501807]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.503252] ata2.00: status: { DRDY }
[    1.504114] ata2.00: configured for MWDMA2
[    1.504512] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    1.505395] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    1.506054] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    1.506685] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
[    1.507383] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    1.508319] Buffer I/O error on dev sda, logical block 0, async page read
[    1.508972] ata2: EH complete
[    1.532770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.533402] ata2.00: failed command: READ DMA
[    1.533825] ata2.00: cmd c8/00:08:18:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.533825]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.535282] ata2.00: status: { DRDY }
[    1.536143] ata2.00: configured for MWDMA2
[    1.536542] ata2: EH complete
[    1.548771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.549394] ata2.00: failed command: READ DMA
[    1.549817] ata2.00: cmd c8/00:08:18:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.549817]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.551272] ata2.00: status: { DRDY }
[    1.552132] ata2.00: configured for MWDMA2
[    1.552530] ata2: EH complete
[    1.564771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.565392] ata2.00: failed command: READ DMA
[    1.565814] ata2.00: cmd c8/00:08:18:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.565814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.567271] ata2.00: status: { DRDY }
[    1.568129] ata2.00: configured for MWDMA2
[    1.568530] ata2: EH complete
[    1.580769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.581390] ata2.00: failed command: READ DMA
[    1.581812] ata2.00: cmd c8/00:08:18:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.581812]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.583257] ata2.00: status: { DRDY }
[    1.584114] ata2.00: configured for MWDMA2
[    1.584510] ata2: EH complete
[    1.596770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.597389] ata2.00: failed command: READ DMA
[    1.597809] ata2.00: cmd c8/00:08:18:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.597809]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.599260] ata2.00: status: { DRDY }
[    1.600119] ata2.00: configured for MWDMA2
[    1.600515] ata2: EH complete
[    1.612770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.613394] ata2.00: failed command: READ DMA
[    1.613814] ata2.00: cmd c8/00:08:18:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.613814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.615276] ata2.00: status: { DRDY }
[    1.616139] ata2.00: configured for MWDMA2
[    1.616539] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[    1.617421] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[    1.618081] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[    1.618714] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 18 00 00 08 00
[    1.619418] blk_update_request: I/O error, dev sda, sector 24 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    1.620369] Buffer I/O error on dev sda, logical block 3, async page read
[    1.621028] ata2: EH complete
[    1.644770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.645397] ata2.00: failed command: READ DMA
[    1.645819] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.645819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.647272] ata2.00: status: { DRDY }
[    1.648136] ata2.00: configured for MWDMA2
[    1.648536] ata2: EH complete
[    1.660769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.661389] ata2.00: failed command: READ DMA
[    1.661809] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.661809]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.663260] ata2.00: status: { DRDY }
[    1.664119] ata2.00: configured for MWDMA2
[    1.664516] ata2: EH complete
[    1.676770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.677393] ata2.00: failed command: READ DMA
[    1.677812] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.677812]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.679262] ata2.00: status: { DRDY }
[    1.680120] ata2.00: configured for MWDMA2
[    1.680517] ata2: EH complete
[    1.692769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.693390] ata2.00: failed command: READ DMA
[    1.693810] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.693810]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.695265] ata2.00: status: { DRDY }
[    1.696128] ata2.00: configured for MWDMA2
[    1.696526] ata2: EH complete
[    1.708769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.709395] ata2.00: failed command: READ DMA
[    1.709817] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.709817]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.711277] ata2.00: status: { DRDY }
[    1.712138] ata2.00: configured for MWDMA2
[    1.712535] ata2: EH complete
[    1.724769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.725393] ata2.00: failed command: READ DMA
[    1.725814] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.725814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.727265] ata2.00: status: { DRDY }
[    1.728125] ata2.00: configured for MWDMA2
[    1.728525] ata2: EH complete
[    1.752770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.753396] ata2.00: failed command: READ DMA
[    1.753815] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.753815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.755272] ata2.00: status: { DRDY }
[    1.756130] ata2.00: configured for MWDMA2
[    1.756525] ata2: EH complete
[    1.768769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.769386] ata2.00: failed command: READ DMA
[    1.769803] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.769803]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.771250] ata2.00: status: { DRDY }
[    1.772108] ata2.00: configured for MWDMA2
[    1.772503] ata2: EH complete
[    1.784769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.785390] ata2.00: failed command: READ DMA
[    1.785812] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.785812]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.787264] ata2.00: status: { DRDY }
[    1.788127] ata2.00: configured for MWDMA2
[    1.788525] ata2: EH complete
[    1.800769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.801392] ata2.00: failed command: READ DMA
[    1.801813] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.801813]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.803264] ata2.00: status: { DRDY }
[    1.804126] ata2.00: configured for MWDMA2
[    1.804522] ata2: EH complete
[    1.816770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.817391] ata2.00: failed command: READ DMA
[    1.817813] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.817813]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.819264] ata2.00: status: { DRDY }
[    1.820126] ata2.00: configured for MWDMA2
[    1.820523] ata2: EH complete
[    1.832773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.833398] ata2.00: failed command: READ DMA
[    1.833819] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[    1.833819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.835275] ata2.00: status: { DRDY }
[    1.836136] ata2.00: configured for MWDMA2
[    1.836537] ata2: EH complete
[    1.836833]  sda: unable to read partition table
[    1.837393] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.837855] md: Waiting for all devices to be available before autodetect
[    1.838510] md: If you don't use raid, use raid=noautodetect
[    1.839152] sda: detected capacity change from 0 to 268435456
[    1.839759] sda: detected capacity change from 0 to 268435456
[    1.840346] md: Autodetecting RAID arrays.
[    1.840741] md: autorun ...
[    1.841018] md: ... autorun DONE.
[    1.864774] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.865398] ata2.00: failed command: READ DMA
[    1.865821] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.865821]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.867274] ata2.00: status: { DRDY }
[    1.868146] ata2.00: configured for MWDMA2
[    1.868546] ata2: EH complete
[    1.880772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.881393] ata2.00: failed command: READ DMA
[    1.881816] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.881816]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.883269] ata2.00: status: { DRDY }
[    1.884130] ata2.00: configured for MWDMA2
[    1.884531] ata2: EH complete
[    1.896771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.897392] ata2.00: failed command: READ DMA
[    1.897816] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.897816]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.899265] ata2.00: status: { DRDY }
[    1.900125] ata2.00: configured for MWDMA2
[    1.900524] ata2: EH complete
[    1.912771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.913395] ata2.00: failed command: READ DMA
[    1.913821] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.913821]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.915281] ata2.00: status: { DRDY }
[    1.916144] ata2.00: configured for MWDMA2
[    1.916544] ata2: EH complete
[    1.928769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.929392] ata2.00: failed command: READ DMA
[    1.929814] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.929814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.931269] ata2.00: status: { DRDY }
[    1.932129] ata2.00: configured for MWDMA2
[    1.932529] ata2: EH complete
[    1.944769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.945402] ata2.00: failed command: READ DMA
[    1.945826] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.945826]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.947295] ata2.00: status: { DRDY }
[    1.948156] ata2.00: configured for MWDMA2
[    1.948561] ata2: EH complete
[    1.948860] EXT4-fs (sda): unable to read superblock
[    1.972772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.973397] ata2.00: failed command: READ DMA
[    1.973819] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.973819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.975278] ata2.00: status: { DRDY }
[    1.976142] ata2.00: configured for MWDMA2
[    1.976541] ata2: EH complete
[    1.988771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    1.989390] ata2.00: failed command: READ DMA
[    1.989812] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    1.989812]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    1.991263] ata2.00: status: { DRDY }
[    1.992126] ata2.00: configured for MWDMA2
[    1.992526] ata2: EH complete
[    2.004773] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.005394] ata2.00: failed command: READ DMA
[    2.005817] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.005817]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.007276] ata2.00: status: { DRDY }
[    2.008141] ata2.00: configured for MWDMA2
[    2.008542] ata2: EH complete
[    2.020770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.021394] ata2.00: failed command: READ DMA
[    2.021815] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.021815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.023273] ata2.00: status: { DRDY }
[    2.024138] ata2.00: configured for MWDMA2
[    2.024538] ata2: EH complete
[    2.036771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.037392] ata2.00: failed command: READ DMA
[    2.037815] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.037815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.039272] ata2.00: status: { DRDY }
[    2.040135] ata2.00: configured for MWDMA2
[    2.040533] ata2: EH complete
[    2.052771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.053393] ata2.00: failed command: READ DMA
[    2.053816] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.053816]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.055273] ata2.00: status: { DRDY }
[    2.056136] ata2.00: configured for MWDMA2
[    2.056538] ata2: EH complete
[    2.056834] EXT4-fs (sda): unable to read superblock
[    2.080771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.081394] ata2.00: failed command: READ DMA
[    2.081815] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.081815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.083272] ata2.00: status: { DRDY }
[    2.084137] ata2.00: configured for MWDMA2
[    2.084536] ata2: EH complete
[    2.096770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.097393] ata2.00: failed command: READ DMA
[    2.097814] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.097814]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.100505] ata2.00: status: { DRDY }
[    2.101411] ata2.00: configured for MWDMA2
[    2.101809] ata2: EH complete
[    2.112771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.113392] ata2.00: failed command: READ DMA
[    2.113812] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.113812]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.115270] ata2.00: status: { DRDY }
[    2.116137] ata2.00: configured for MWDMA2
[    2.116537] ata2: EH complete
[    2.128770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.129395] ata2.00: failed command: READ DMA
[    2.129819] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.129819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.131275] ata2.00: status: { DRDY }
[    2.132138] ata2.00: configured for MWDMA2
[    2.132538] ata2: EH complete
[    2.144772] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.145403] ata2.00: failed command: READ DMA
[    2.145825] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.145825]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.147286] ata2.00: status: { DRDY }
[    2.148149] ata2.00: configured for MWDMA2
[    2.148549] ata2: EH complete
[    2.160771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.161400] ata2.00: failed command: READ DMA
[    2.161822] ata2.00: cmd c8/00:02:02:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.161822]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.163282] ata2.00: status: { DRDY }
[    2.164146] ata2.00: configured for MWDMA2
[    2.164548] ata2: EH complete
[    2.164846] EXT4-fs (sda): unable to read superblock
[    2.184771] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.185398] ata2.00: failed command: READ DMA
[    2.185820] ata2.00: cmd c8/00:02:00:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.185820]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.187280] ata2.00: status: { DRDY }
[    2.188146] ata2.00: configured for MWDMA2
[    2.188548] ata2: EH complete
[    2.200770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.201397] ata2.00: failed command: READ DMA
[    2.201820] ata2.00: cmd c8/00:02:00:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.201820]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.203281] ata2.00: status: { DRDY }
[    2.204144] ata2.00: configured for MWDMA2
[    2.204543] ata2: EH complete
[    2.216770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.217404] ata2.00: failed command: READ DMA
[    2.217825] ata2.00: cmd c8/00:02:00:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.217825]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.219290] ata2.00: status: { DRDY }
[    2.220152] ata2.00: configured for MWDMA2
[    2.220551] ata2: EH complete
[    2.232770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.233396] ata2.00: failed command: READ DMA
[    2.233819] ata2.00: cmd c8/00:02:00:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.233819]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.235281] ata2.00: status: { DRDY }
[    2.236145] ata2.00: configured for MWDMA2
[    2.236545] ata2: EH complete
[    2.248769] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.249396] ata2.00: failed command: READ DMA
[    2.249818] ata2.00: cmd c8/00:02:00:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.249818]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.251279] ata2.00: status: { DRDY }
[    2.252145] ata2.00: configured for MWDMA2
[    2.252543] ata2: EH complete
[    2.264770] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[    2.265393] ata2.00: failed command: READ DMA
[    2.265815] ata2.00: cmd c8/00:02:00:00:00/00:00:00:00:00/e0 tag 0 dma 1024 in
[    2.265815]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[    2.267271] ata2.00: status: { DRDY }
[    2.268133] ata2.00: configured for MWDMA2
[    2.268534] ata2: EH complete
[    2.268833] SQUASHFS error: Failed to read block 0x0: -5
[    2.269346] unable to read squashfs_super_block
[    2.269785] VFS: Cannot open root device "sda" or unknown-block(8,0): error -5
[    2.270481] Please append a correct "root=" boot option; here are the available partitions:
[    2.271284] 0800          262144 sda
[    2.271285]  driver: sd
[    2.271881] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,0)
[    2.272673] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.7.0-rc4-next-20200507+ #10
[    2.273527] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[    2.274614] Call Trace:
[    2.274861]  dump_stack+0x6b/0x83
[    2.275189]  panic+0x102/0x2f3
[    2.275491]  mount_block_root+0x290/0x339
[    2.275879]  prepare_namespace+0x13d/0x16c
[    2.276277]  kernel_init_freeable+0x246/0x270
[    2.276699]  ? rdinit_setup+0x28/0x28
[    2.277056]  ? rest_init+0xb0/0xb0
[    2.277387]  kernel_init+0xa/0x110
[    2.277718]  ret_from_fork+0x1f/0x30
[    2.278414] Kernel Offset: disabled
[    2.278755] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,0) ]---
qemu-system-x86_64: terminating on signal 2

Best,
Hui

> 
> Cheers!
> 
> 
>> // start a QEMU that is get from https://github.com/davidhildenbrand/qemu/tree/virtio-mem-v2 and setup a file as a ide disk.
>> /home/teawater/qemu/qemu/x86_64-softmmu/qemu-system-x86_64 -machine pc-i440fx-2.1,accel=kvm,usb=off -cpu host -no-reboot -nographic -device ide-hd,drive=hd -drive if=none,id=hd,file=/home/teawater/old.img,format=raw -kernel /home/teawater/kernel/bk2/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/sda nokaslr swiotlb=noforce" -m 1g,slots=10,maxmem=2G -smp 1 -s -monitor unix:/home/teawater/qemu/m,server,nowait
>> 
>> // Setup virtio-mem and plug 256m memory in qemu monitor:
>> object_add memory-backend-ram,id=mem1,size=256m
>> device_add virtio-mem-pci,id=vm0,memdev=mem1
>> qom-set vm0 requested-size 256M
>> 
>> // Go back to the terminal and access file system will got following kernel warning.
>> [   19.515549] pci 0000:00:04.0: [1af4:1015] type 00 class 0x00ff00
>> [   19.516227] pci 0000:00:04.0: reg 0x10: [io  0x0000-0x007f]
>> [   19.517196] pci 0000:00:04.0: BAR 0: assigned [io  0x1000-0x107f]
>> [   19.517843] virtio-pci 0000:00:04.0: enabling device (0000 -> 0001)
>> [   19.535957] PCI Interrupt Link [LNKD] enabled at IRQ 11
>> [   19.536507] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
>> [   19.537528] virtio_mem virtio0: start address: 0x100000000
>> [   19.538094] virtio_mem virtio0: region size: 0x10000000
>> [   19.538621] virtio_mem virtio0: device block size: 0x200000
>> [   19.539186] virtio_mem virtio0: memory block size: 0x8000000
>> [   19.539752] virtio_mem virtio0: subblock size: 0x400000
>> [   19.540357] virtio_mem virtio0: plugged size: 0x0
>> [   19.540834] virtio_mem virtio0: requested size: 0x0
>> [   20.170441] virtio_mem virtio0: plugged size: 0x0
>> [   20.170933] virtio_mem virtio0: requested size: 0x10000000
>> [   20.172247] Built 1 zonelists, mobility grouping on.  Total pages: 266012
>> [   20.172955] Policy zone: Normal
>> 
>> / # ls
>> [   26.724565] ------------[ cut here ]------------
>> [   26.725047] ata_piix 0000:00:01.1: DMA addr 0x000000010fc14000+49152 overflow (mask ffffffff, bus limit 0).
>> [   26.726024] WARNING: CPU: 0 PID: 179 at /home/teawater/kernel/linux2/kernel/dma/direct.c:364 dma_direct_map_page+0x118/0x130
>> [   26.727141] Modules linked in:
>> [   26.727456] CPU: 0 PID: 179 Comm: ls Not tainted 5.6.0-rc5-next-20200311+ #9
>> [   26.728163] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>> [   26.729305] RIP: 0010:dma_direct_map_page+0x118/0x130
>> [   26.729825] Code: 8b 1f e8 3b 70 59 00 48 8d 4c 24 08 48 89 c6 4c 89 2c 24 4d 89 e1 49 89 e8 48 89 da 48 c7 c7 08 6c 34 82 31 c0 e8 d8 8e f7 ff <00
>> [   26.731683] RSP: 0000:ffffc90000213838 EFLAGS: 00010082
>> [   26.732205] RAX: 0000000000000000 RBX: ffff88803ebeb1b0 RCX: ffffffff82665148
>> [   26.732913] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 0000000000000046
>> [   26.733621] RBP: 000000000000c000 R08: 00000000000001df R09: 00000000000001df
>> [   26.734338] R10: 0000000000000000 R11: ffffc900002135a8 R12: 00000000ffffffff
>> [   26.735054] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88803d55f5b0
>> [   26.735772] FS:  00000000024e9880(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
>> [   26.736579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   26.737162] CR2: 00000000005bfc7f CR3: 0000000107e12004 CR4: 0000000000360ef0
>> [   26.737879] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   26.738591] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   26.739307] Call Trace:
>> [   26.739564]  dma_direct_map_sg+0x64/0xb0
>> [   26.739969]  ? ata_scsi_write_same_xlat+0x350/0x350
>> [   26.740461]  ata_qc_issue+0x214/0x260
>> [   26.740839]  ata_scsi_queuecmd+0x16a/0x490
>> [   26.741255]  scsi_queue_rq+0x679/0xa60
>> [   26.741639]  blk_mq_dispatch_rq_list+0x90/0x510
>> [   26.742099]  ? elv_rb_del+0x1f/0x30
>> [   26.742456]  ? deadline_remove_request+0x6a/0xb0
>> [   26.742926]  blk_mq_do_dispatch_sched+0x78/0x100
>> [   26.743397]  blk_mq_sched_dispatch_requests+0xf9/0x170
>> [   26.743924]  __blk_mq_run_hw_queue+0x7e/0x130
>> [   26.744365]  __blk_mq_delay_run_hw_queue+0x107/0x150
>> [   26.744874]  blk_mq_run_hw_queue+0x61/0x100
>> [   26.745299]  blk_mq_sched_insert_requests+0x71/0x110
>> [   26.745798]  blk_mq_flush_plug_list+0x14b/0x210
>> [   26.746258]  blk_flush_plug_list+0xbf/0xe0
>> [   26.746675]  blk_finish_plug+0x27/0x40
>> [   26.747056]  read_pages+0x7c/0x190
>> [   26.747399]  __do_page_cache_readahead+0x19c/0x1b0
>> [   26.747886]  filemap_fault+0x54e/0x9a0
>> [   26.748268]  ? alloc_set_pte+0x102/0x610
>> [   26.748673]  ? walk_component+0x64/0x2e0
>> [   26.749072]  ? filemap_map_pages+0xfa/0x3f0
>> [   26.749498]  ext4_filemap_fault+0x2c/0x3b
>> [   26.749911]  __do_fault+0x38/0xb0
>> [   26.750251]  __handle_mm_fault+0xd2a/0x16d0
>> [   26.750678]  handle_mm_fault+0xe2/0x1f0
>> [   26.751069]  do_page_fault+0x250/0x590
>> [   26.751448]  async_page_fault+0x34/0x40
>> [   26.751841] RIP: 0033:0x5bfc7f
>> [   26.752155] Code: Bad RIP value.
>> [   26.752481] RSP: 002b:00007ffef0289cd8 EFLAGS: 00010246
>> [   26.752999] RAX: 0000000000000001 RBX: 00007ffef028af81 RCX: 00007ffef028af84
>> [   26.753715] RDX: 00007ffef0289e01 RSI: 00007ffef0289ea8 RDI: 0000000000000001
>> [   26.754424] RBP: 00000000000000ac R08: 0000000000000001 R09: 0000000000000006
>> [   26.755144] R10: 000000000089fc18 R11: 0000000000000246 R12: 00007ffef0289ea8
>> [   26.755853] R13: 000000000043a5f0 R14: 0000000000000000 R15: 0000000000000000
>> [   26.756560] ---[ end trace 23cc3e9021358587 ]---
>> [   26.778034] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.778690] ata2.00: failed command: READ DMA
>> [   26.779131] ata2.00: cmd c8/00:e8:92:ad:00/00:00:00:00:00/e0 tag 0 dma 118784 in
>> [   26.779131]          res 50/00:00:0a:80:03/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.780691] ata2.00: status: { DRDY }
>> [   26.781603] ata2.00: configured for MWDMA2
>> [   26.782034] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
>> [   26.782958] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
>> [   26.783646] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
>> [   26.784321] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad 92 00 00 e8 00
>> [   26.785056] blk_update_request: I/O error, dev sda, sector 44434 op 0x0:(READ) flags 0x80700 phys_seg 3 prio class 0
>> [   26.786118] ata2: EH complete
>> [   26.810033] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.810690] ata2.00: failed command: READ DMA
>> [   26.811133] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.811133]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.812681] ata2.00: status: { DRDY }
>> [   26.813569] ata2.00: configured for MWDMA2
>> [   26.813992] ata2: EH complete
>> [   26.826031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.826687] ata2.00: failed command: READ DMA
>> [   26.827131] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.827131]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.828668] ata2.00: status: { DRDY }
>> [   26.829552] ata2.00: configured for MWDMA2
>> [   26.829972] ata2: EH complete
>> [   26.842030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.842686] ata2.00: failed command: READ DMA
>> [   26.843127] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.843127]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.844656] ata2.00: status: { DRDY }
>> [   26.845538] ata2.00: configured for MWDMA2
>> [   26.845961] ata2: EH complete
>> [   26.858030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.858690] ata2.00: failed command: READ DMA
>> [   26.859132] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.859132]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.860656] ata2.00: status: { DRDY }
>> [   26.861542] ata2.00: configured for MWDMA2
>> [   26.861960] ata2: EH complete
>> [   26.874030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.874693] ata2.00: failed command: READ DMA
>> [   26.875131] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.875131]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.876675] ata2.00: status: { DRDY }
>> [   26.877554] ata2.00: configured for MWDMA2
>> [   26.877976] ata2: EH complete
>> [   26.890030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.890655] ata2.00: failed command: READ DMA
>> [   26.891082] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.891082]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.892544] ata2.00: status: { DRDY }
>> [   26.893408] ata2.00: configured for MWDMA2
>> [   26.893812] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
>> [   26.894698] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
>> [   26.895356] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
>> [   26.895993] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad fa 00 00 08 00
>> [   26.896693] blk_update_request: I/O error, dev sda, sector 44538 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [   26.897668] ata2: EH complete
>> [   26.922032] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.922652] ata2.00: failed command: READ DMA
>> [   26.923080] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.923080]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.924538] ata2.00: status: { DRDY }
>> [   26.925404] ata2.00: configured for MWDMA2
>> [   26.925807] ata2: EH complete
>> [   26.938031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.938650] ata2.00: failed command: READ DMA
>> [   26.939076] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.939076]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.940529] ata2.00: status: { DRDY }
>> [   26.941391] ata2.00: configured for MWDMA2
>> [   26.941793] ata2: EH complete
>> [   26.954031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.954652] ata2.00: failed command: READ DMA
>> [   26.955079] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.955079]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.956536] ata2.00: status: { DRDY }
>> [   26.957400] ata2.00: configured for MWDMA2
>> [   26.957800] ata2: EH complete
>> [   26.970031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.970653] ata2.00: failed command: READ DMA
>> [   26.971079] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.971079]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.972536] ata2.00: status: { DRDY }
>> [   26.973402] ata2.00: configured for MWDMA2
>> [   26.973804] ata2: EH complete
>> [   26.986030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   26.986654] ata2.00: failed command: READ DMA
>> [   26.987082] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   26.987082]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   26.988541] ata2.00: status: { DRDY }
>> [   26.989406] ata2.00: configured for MWDMA2
>> [   26.989807] ata2: EH complete
>> [   27.002031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   27.002653] ata2.00: failed command: READ DMA
>> [   27.003083] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
>> [   27.003083]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>> [   27.004541] ata2.00: status: { DRDY }
>> [   27.005404] ata2.00: configured for MWDMA2
>> [   27.005806] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
>> [   27.006688] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
>> [   27.007346] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
>> [   27.007982] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad fa 00 00 08 00
>> [   27.008680] blk_update_request: I/O error, dev sda, sector 44538 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [   27.009649] ata2: EH complete
>> Bus error
>> 
>> I cannot reproduce this warning with set file as nvdimm with following command.
>> sudo /home/teawater/qemu/qemu/x86_64-softmmu/qemu-system-x86_64 -machine pc,accel=kvm,kernel_irqchip,nvdimm -no-reboot -nographic -kernel /home/teawater/kernel/bk2/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/pmem0 swiotlb=noforce" -m 1g,slots=1,maxmem=2G -smp 1 -device nvdimm,id=nv0,memdev=mem0 -object memory-backend-file,id=mem0,mem-path=/home/teawater/old.img,size=268435456 -monitor unix:/home/teawater/qemu/m,server,nowait
>> 
>> Best,
>> Hui
> 
> 
> -- 
> Thanks,
> 
> David / dhildenb

