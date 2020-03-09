Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D94017D9E0
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 08:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCIHao convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Mar 2020 03:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgCIHan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 03:30:43 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206795] New: 4.19.108 Ryzen 1600X , kvm BUG
 kvm_mmu_set_mmio_spte_mask
Date:   Mon, 09 Mar 2020 07:30:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: hvtaifwkbgefbaei@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-206795-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206795

            Bug ID: 206795
           Summary: 4.19.108 Ryzen 1600X , kvm BUG
                    kvm_mmu_set_mmio_spte_mask
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.108
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hvtaifwkbgefbaei@gmail.com
        Regression: Yes

Created attachment 287841
  --> https://bugzilla.kernel.org/attachment.cgi?id=287841&action=edit
lspci

4.19.106 works, 4.19.108 doesn't.
Cc: thomas.lendacky at amd.com
maybe guilty patch: a4e761c9f63ae12c5e2fc586b77082fd07e54212

I'd like to remind:
https://www.kernel.org/doc/html/v4.19/process/stable-kernel-rules.html
 - It must be obviously correct and tested.


I boot with mem_encrypt=off because it doesn't boot with `on`.  Maybe due to my
RX550.

kvm: Nested Virtualization enabled
------------[ cut here ]------------
kernel BUG at arch/x86/kvm/mmu.c:296!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 5 PID: 5265 Comm: systemd-udevd Tainted: G                T 4.19.108+ #57
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X370 Taichi, BIOS
P6.20 01/03/2020
RIP: 0010:kvm_mmu_set_mmio_spte_mask+0x2f/0x40 [kvm]
Code: 48 89 f8 48 21 f0 48 39 f0 75 1f 48 ba 00 00 00 00 00 00 00 40 48 09 d0
48 09 d7 48 89 05 b9 63 06 00 48 89 3d ba 63 06 00 c3 <0f> 0b 66 66 2e 0f 1f 84
00 00 00 00 00 0f 1f 40 00 0f 1f 44 00 00
RSP: 0018:ffffbba083c77b80 EFLAGS: 00010297
RAX: 0000000000000000 RBX: ffffbba083c77b9c RCX: 000000000000002b
RDX: 000000000000002f RSI: 0000000000000006 RDI: 000ff80000000001
RBP: ffffe6f65fdfcc00 R08: ffffbba083c77b98 R09: ffffbba083c77b9c
R10: 0000000000000000 R11: 0000000000000001 R12: ffffbba083c77b98
R13: ffffbba083c77b94 R14: ffffbba083c77b90 R15: ffffffffc073f448
FS:  00007fcf817eb940(0000) GS:ffffa1b33e540000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff902017db8 CR3: 00000007ed3ea000 CR4: 00000000003406e0
Call Trace:
 svm_hardware_setup+0x376/0x556 [kvm_amd]
 kvm_arch_hardware_setup+0x38/0x2e0 [kvm]
 ? preempt_count_sub+0x43/0x50
 kvm_init+0x76/0x270 [kvm]
 ? svm_hardware_setup+0x556/0x556 [kvm_amd]
 do_one_initcall+0x4f/0x20d
 ? free_unref_page_commit+0x8b/0x110
 ? preempt_count_sub+0x43/0x50
 ? kmem_cache_alloc_trace+0x1a3/0x1b0
 do_init_module+0x5f/0x220
 load_module+0x23f5/0x25b0
 ? __se_sys_finit_module+0xbe/0xf0
 __se_sys_finit_module+0xbe/0xf0
 do_syscall_64+0x6f/0x329
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fcf82812e0d
Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48
89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01
c3 48 8b 0d 4b 90 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffec9e12898 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 0000560b19730190 RCX: 00007fcf82812e0d
RDX: 0000000000000000 RSI: 0000560b196dcd50 RDI: 0000000000000010
RBP: 0000000000020000 R08: 0000000000000000 R09: 0000000000000005
R10: 0000000000000010 R11: 0000000000000246 R12: 0000560b196dcd50
R13: 0000000000000000 R14: 0000560b19718840 R15: 0000560b19730190
Modules linked in: kvm_amd(+) mac80211 kvm pktcdvd irqbypass iwlwifi wmi_bmof
pcspkr k10temp sp5100_tco i2c_piix4 snd_hda_codec_realtek snd_hda_codec_generic
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hda_core cfg80211 rtc_cmos
acpi_cpufreq snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc snd_seq_device
snd_pcm sch_cake tcp_cubic tcp_westwood br_netfilter bridge stp llc ip_tables
uas usb_storage usbhid rfkill mxm_wmi ccp igb xhci_pci xhci_hcd usbcore
usb_common wmi button 8021q mrp sunrpc iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi snd_timer snd soundcore tun xt_tcpudp x_tables tcp_bbr
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 sch_fq_codel sch_htb sch_pie fuse
analog gameport joydev i2c_dev ecryptfs autofs4 amdkfd amd_iommu_v2
---[ end trace c1723d4d24214898 ]---


CPU:
   vendor_id = "AuthenticAMD"
   version information (1/eax):
      processor type  = primary processor (0)
      family          = 0xf (15)
      model           = 0x1 (1)
      stepping id     = 0x1 (1)
      extended family = 0x8 (8)
      extended model  = 0x0 (0)
      (family synth)  = 0x17 (23)
      (model synth)   = 0x1 (1)
      (simple synth)  = AMD (unknown type) (Summit Ridge/Naples ZP-B1) [Zen],
14nm
   miscellaneous (1/ebx):
      process local APIC physical ID = 0x9 (9)
      cpu count                      = 0x6 (6)
      CLFLUSH line size              = 0x8 (8)
      brand index                    = 0x0 (0)
   brand id = 0x00 (0): unknown
   feature information (1/edx):
      x87 FPU on chip                        = true
      VME: virtual-8086 mode enhancement     = true
      DE: debugging extensions               = true
      PSE: page size extensions              = true
      TSC: time stamp counter                = true
      RDMSR and WRMSR support                = true
      PAE: physical address extensions       = true
      MCE: machine check exception           = true
      CMPXCHG8B inst.                        = true
      APIC on chip                           = true
      SYSENTER and SYSEXIT                   = true
      MTRR: memory type range registers      = true
      PTE global bit                         = true
      MCA: machine check architecture        = true
      CMOV: conditional move/compare instr   = true
      PAT: page attribute table              = true
      PSE-36: page size extension            = true
      PSN: processor serial number           = false
      CLFLUSH instruction                    = true
      DS: debug store                        = false
      ACPI: thermal monitor and clock ctrl   = false
      MMX Technology                         = true
      FXSAVE/FXRSTOR                         = true
      SSE extensions                         = true
      SSE2 extensions                        = true
      SS: self snoop                         = false
      hyper-threading / multi-core supported = true
      TM: therm. monitor                     = false
      IA64                                   = false
      PBE: pending break event               = false
   feature information (1/ecx):
      PNI/SSE3: Prescott New Instructions     = true
      PCLMULDQ instruction                    = true
      DTES64: 64-bit debug store              = false
      MONITOR/MWAIT                           = true
      CPL-qualified debug store               = false
      VMX: virtual machine extensions         = false
      SMX: safer mode extensions              = false
      Enhanced Intel SpeedStep Technology     = false
      TM2: thermal monitor 2                  = false
      SSSE3 extensions                        = true
      context ID: adaptive or shared L1 data  = false
      SDBG: IA32_DEBUG_INTERFACE              = false
      FMA instruction                         = true
      CMPXCHG16B instruction                  = true
      xTPR disable                            = false
      PDCM: perfmon and debug                 = false
      PCID: process context identifiers       = false
      DCA: direct cache access                = false
      SSE4.1 extensions                       = true
      SSE4.2 extensions                       = true
      x2APIC: extended xAPIC support          = false
      MOVBE instruction                       = true
      POPCNT instruction                      = true
      time stamp counter deadline             = false
      AES instruction                         = true
      XSAVE/XSTOR states                      = true
      OS-enabled XSAVE/XSTOR                  = true
      AVX: advanced vector extensions         = true
      F16C half-precision convert instruction = true
      RDRAND instruction                      = true
      hypervisor guest status                 = false
   cache and TLB information (2):
   processor serial number = 0080-0F11-0000-0000-0000-0000
   MONITOR/MWAIT (5):
      smallest monitor-line size (bytes)       = 0x40 (64)
      largest monitor-line size (bytes)        = 0x40 (64)
      enum of Monitor-MWAIT exts supported     = true
      supports intrs as break-event for MWAIT  = true
      number of C0 sub C-states using MWAIT    = 0x0 (0)
      number of C1 sub C-states using MWAIT    = 0x0 (0)
      number of C2 sub C-states using MWAIT    = 0x0 (0)
      number of C3 sub C-states using MWAIT    = 0x0 (0)
      number of C4 sub C-states using MWAIT    = 0x0 (0)
      number of C5 sub C-states using MWAIT    = 0x0 (0)
      number of C6 sub C-states using MWAIT    = 0x0 (0)
      number of C7 sub C-states using MWAIT    = 0x0 (0)
   Thermal and Power Management Features (6):
      digital thermometer                     = false
      Intel Turbo Boost Technology            = false
      ARAT always running APIC timer          = true
      PLN power limit notification            = false
      ECMD extended clock modulation duty     = false
      PTM package thermal management          = false
      HWP base registers                      = false
      HWP notification                        = false
      HWP activity window                     = false
      HWP energy performance preference       = false
      HWP package level request               = false
      HDC base registers                      = false
      Intel Turbo Boost Max Technology 3.0    = false
      HWP capabilities                        = false
      HWP PECI override                       = false
      flexible HWP                            = false
      IA32_HWP_REQUEST MSR fast access mode   = false
      HW_FEEDBACK                             = false
      ignoring idle logical processor HWP req = false
      digital thermometer thresholds          = 0x0 (0)
      hardware coordination feedback          = true
      ACNT2 available                         = false
      performance-energy bias capability      = false
      performance capability reporting        = false
      energy efficiency capability reporting  = false
      size of feedback struct (4KB pages)     = 0x0 (0)
      index of CPU's row in feedback struct   = 0x0 (0)
   extended feature flags (7):
      FSGSBASE instructions                    = true
      IA32_TSC_ADJUST MSR supported            = false
      SGX: Software Guard Extensions supported = false
      BMI1 instructions                        = true
      HLE hardware lock elision                = false
      AVX2: advanced vector extensions 2       = true
      FDP_EXCPTN_ONLY                          = false
      SMEP supervisor mode exec protection     = true
      BMI2 instructions                        = true
      enhanced REP MOVSB/STOSB                 = false
      INVPCID instruction                      = false
      RTM: restricted transactional memory     = false
      RDT-CMT/PQoS cache monitoring            = false
      deprecated FPU CS/DS                     = false
      MPX: intel memory protection extensions  = false
      RDT-CAT/PQE cache allocation             = false
      AVX512F: AVX-512 foundation instructions = false
      AVX512DQ: double & quadword instructions = false
      RDSEED instruction                       = true
      ADX instructions                         = true
      SMAP: supervisor mode access prevention  = true
      AVX512IFMA: fused multiply add           = false
      PCOMMIT instruction                      = false
      CLFLUSHOPT instruction                   = true
      CLWB instruction                         = false
      Intel processor trace                    = false
      AVX512PF: prefetch instructions          = false
      AVX512ER: exponent & reciprocal instrs   = false
      AVX512CD: conflict detection instrs      = false
      SHA instructions                         = true
      AVX512BW: byte & word instructions       = false
      AVX512VL: vector length                  = false
      PREFETCHWT1                              = false
      AVX512VBMI: vector byte manipulation     = false
      UMIP: user-mode instruction prevention   = false
      PKU protection keys for user-mode        = false
      OSPKE CR4.PKE and RDPKRU/WRPKRU          = false
      WAITPKG instructions                     = false
      AVX512_VBMI2: byte VPCOMPRESS, VPEXPAND  = false
      CET_SS: CET shadow stack                 = false
      GFNI: Galois Field New Instructions      = false
      VAES instructions                        = false
      VPCLMULQDQ instruction                   = false
      AVX512_VNNI: neural network instructions = false
      AVX512_BITALG: bit count/shiffle         = false
      TME: Total Memory Encryption             = false
      AVX512: VPOPCNTDQ instruction            = false
      5-level paging                           = false
      BNDLDX/BNDSTX MAWAU value in 64-bit mode = 0x0 (0)
      RDPID: read processor D supported        = false
      CLDEMOTE supports cache line demote      = false
      MOVDIRI instruction                      = false
      MOVDIR64B instruction                    = false
      ENQCMD instruction                       = false
      SGX_LC: SGX launch config supported      = false
      AVX512_4VNNIW: neural network instrs     = false
      AVX512_4FMAPS: multiply acc single prec  = false
      fast short REP MOV                       = false
      AVX512_VP2INTERSECT: intersect mask regs = false
      VERW md-clear microcode support          = false
      hybrid part                              = false
      PCONFIG instruction                      = false
      CET_IBT: CET indirect branch tracking    = false
      IBRS/IBPB: indirect branch restrictions  = false
      STIBP: 1 thr indirect branch predictor   = false
      L1D_FLUSH: IA32_FLUSH_CMD MSR            = false
      IA32_ARCH_CAPABILITIES MSR               = false
      IA32_CORE_CAPABILITIES MSR               = false
      SSBD: speculative store bypass disable   = false
   Direct Cache Access Parameters (9):
      PLATFORM_DCA_CAP MSR bits = 0
   Architecture Performance Monitoring Features (0xa/eax):
      version ID                               = 0x0 (0)
      number of counters per logical processor = 0x0 (0)
      bit width of counter                     = 0x0 (0)
      length of EBX bit vector                 = 0x0 (0)
   Architecture Performance Monitoring Features (0xa/ebx):
      core cycle event not available           = false
      instruction retired event not available  = false
      reference cycles event not available     = false
      last-level cache ref event not available = false
      last-level cache miss event not avail    = false
      branch inst retired event not available  = false
      branch mispred retired event not avail   = false
   Architecture Performance Monitoring Features (0xa/edx):
      number of fixed counters    = 0x0 (0)
      bit width of fixed counters = 0x0 (0)
      anythread deprecation       = false
   XSAVE features (0xd/0):
      XCR0 lower 32 bits valid bit field mask = 0x00000007
      XCR0 upper 32 bits valid bit field mask = 0x00000000
         XCR0 supported: x87 state            = true
         XCR0 supported: SSE state            = true
         XCR0 supported: AVX state            = true
         XCR0 supported: MPX BNDREGS          = false
         XCR0 supported: MPX BNDCSR           = false
         XCR0 supported: AVX-512 opmask       = false
         XCR0 supported: AVX-512 ZMM_Hi256    = false
         XCR0 supported: AVX-512 Hi16_ZMM     = false
         IA32_XSS supported: PT state         = false
         XCR0 supported: PKRU state           = false
         XCR0 supported: CET_U state          = false
         XCR0 supported: CET_S state          = false
         IA32_XSS supported: HDC state        = false
      bytes required by fields in XCR0        = 0x00000340 (832)
      bytes required by XSAVE/XRSTOR area     = 0x00000340 (832)
   XSAVE features (0xd/1):
      XSAVEOPT instruction                        = true
      XSAVEC instruction                          = true
      XGETBV instruction                          = true
      XSAVES/XRSTORS instructions                 = true
      SAVE area size in bytes                     = 0x00000340 (832)
      IA32_XSS lower 32 bits valid bit field mask = 0x00000000
      IA32_XSS upper 32 bits valid bit field mask = 0x00000000
   AVX/YMM features (0xd/2):
      AVX/YMM save state byte size             = 0x00000100 (256)
      AVX/YMM save state byte offset           = 0x00000240 (576)
      supported in IA32_XSS or XCR0            = XCR0 (user state)
      64-byte alignment in compacted XSAVE     = false
   extended processor signature (0x80000001/eax):
      family/generation = 0xf (15)
      model           = 0x1 (1)
      stepping id     = 0x1 (1)
      extended family = 0x8 (8)
      extended model  = 0x0 (0)
      (family synth)  = 0x17 (23)
      (model synth)   = 0x1 (1)
      (simple synth)  = AMD (unknown type) (Summit Ridge/Naples ZP-B1) [Zen],
14nm
   extended feature flags (0x80000001/edx):
      x87 FPU on chip                       = true
      virtual-8086 mode enhancement         = true
      debugging extensions                  = true
      page size extensions                  = true
      time stamp counter                    = true
      RDMSR and WRMSR support               = true
      physical address extensions           = true
      machine check exception               = true
      CMPXCHG8B inst.                       = true
      APIC on chip                          = true
      SYSCALL and SYSRET instructions       = true
      memory type range registers           = true
      global paging extension               = true
      machine check architecture            = true
      conditional move/compare instruction  = true
      page attribute table                  = true
      page size extension                   = true
      multiprocessing capable               = false
      no-execute page protection            = true
      AMD multimedia instruction extensions = true
      MMX Technology                        = true
      FXSAVE/FXRSTOR                        = true
      SSE extensions                        = true
      1-GB large page support               = true
      RDTSCP                                = true
      long mode (AA-64)                     = true
      3DNow! instruction extensions         = false
      3DNow! instructions                   = false
   extended brand id (0x80000001/ebx):
      raw     = 0x20000000 (536870912)
      BrandId = 0x0 (0)
      PkgType = AM4 (2)
   AMD feature flags (0x80000001/ecx):
      LAHF/SAHF supported in 64-bit mode     = true
      CMP Legacy                             = true
      SVM: secure virtual machine            = true
      extended APIC space                    = true
      AltMovCr8                              = true
      LZCNT advanced bit manipulation        = true
      SSE4A support                          = true
      misaligned SSE mode                    = true
      3DNow! PREFETCH/PREFETCHW instructions = true
      OS visible workaround                  = true
      instruction based sampling             = false
      XOP support                            = false
      SKINIT/STGI support                    = true
      watchdog timer support                 = true
      lightweight profiling support          = false
      4-operand FMA instruction              = false
      TCE: translation cache extension       = true
      NodeId MSR C001100C                    = false
      TBM support                            = false
      topology extensions                    = true
      core performance counter extensions    = true
      NB/DF performance counter extensions   = true
      data breakpoint extension              = true
      performance time-stamp counter support = false
      LLC performance counter extensions     = true
      MWAITX/MONITORX supported              = true
      Address mask extension support         = false
   brand = "AMD Ryzen 5 1600X Six-Core Processor           "
   L1 TLB/cache information: 2M/4M pages & L1 TLB (0x80000005/eax):
      instruction # entries     = 0x40 (64)
      instruction associativity = 0xff (255)
      data # entries            = 0x40 (64)
      data associativity        = 0xff (255)
   L1 TLB/cache information: 4K pages & L1 TLB (0x80000005/ebx):
      instruction # entries     = 0x40 (64)
      instruction associativity = 0xff (255)
      data # entries            = 0x40 (64)
      data associativity        = 0xff (255)
   L1 data cache information (0x80000005/ecx):
      line size (bytes) = 0x40 (64)
      lines per tag     = 0x1 (1)
      associativity     = 0x8 (8)
      size (KB)         = 0x20 (32)
   L1 instruction cache information (0x80000005/edx):
      line size (bytes) = 0x40 (64)
      lines per tag     = 0x1 (1)
      associativity     = 0x4 (4)
      size (KB)         = 0x40 (64)
   L2 TLB/cache information: 2M/4M pages & L2 TLB (0x80000006/eax):
      instruction # entries     = 0x400 (1024)
      instruction associativity = 8-way (6)
      data # entries            = 0x600 (1536)
      data associativity        = 2-way (2)
   L2 TLB/cache information: 4K pages & L2 TLB (0x80000006/ebx):
      instruction # entries     = 0x400 (1024)
      instruction associativity = 8-way (6)
      data # entries            = 0x600 (1536)
      data associativity        = 8-way (6)
   L2 unified cache information (0x80000006/ecx):
      line size (bytes) = 0x40 (64)
      lines per tag     = 0x1 (1)
      associativity     = 8-way (6)
      size (KB)         = 0x200 (512)
   L3 cache information (0x80000006/edx):
      line size (bytes)     = 0x40 (64)
      lines per tag         = 0x1 (1)
      associativity         = 16-way (8)
      size (in 512KB units) = 0x20 (32)
   RAS Capability (0x80000007/ebx):
      MCA overflow recovery support = true
      SUCCOR support                = true
      HWA: hardware assert support  = false
      scalable MCA support          = true
   Advanced Power Management Features (0x80000007/ecx):
      CmpUnitPwrSampleTimeRatio = 0x0 (0)
   Advanced Power Management Features (0x80000007/edx):
      TS: temperature sensing diode           = true
      FID: frequency ID control               = false
      VID: voltage ID control                 = false
      TTP: thermal trip                       = true
      TM: thermal monitor                     = true
      STC: software thermal control           = false
      100 MHz multiplier control              = false
      hardware P-State control                = true
      TscInvariant                            = true
      CPB: core performance boost             = false
      read-only effective frequency interface = true
      processor feedback interface            = false
      APM power reporting                     = false
      connected standby                       = true
      RAPL: running average power limit       = true
   Physical Address and Linear Address Size (0x80000008/eax):
      maximum physical address bits         = 0x30 (48)
      maximum linear (virtual) address bits = 0x30 (48)
      maximum guest physical address bits   = 0x0 (0)
   Extended Feature Extensions ID (0x80000008/ebx):
      CLZERO instruction                       = true
      instructions retired count support       = true
      always save/restore error pointers       = true
      RDPRU instruction                        = false
      memory bandwidth enforcement             = false
      WBNOINVD instruction                     = false
      IBPB: indirect branch prediction barrier = true
      IBRS: indirect branch restr speculation  = false
      STIBP: 1 thr indirect branch predictor   = false
      STIBP always on preferred mode           = false
      ppin processor id number supported       = false
      SSBD: speculative store bypass disable   = false
      virtualized SSBD                         = false
      SSBD fixed in hardware                   = false
   Size Identifiers (0x80000008/ecx):
      number of threads                   = 0x6 (6)
      ApicIdCoreIdSize                    = 0x4 (4)
      performance time-stamp counter size = 0x0 (0)
   Feature Extended Size (0x80000008/edx):
      RDPRU instruction max input support = 0x0 (0)
   SVM Secure Virtual Machine (0x8000000a/eax):
      SvmRev: SVM revision = 0x1 (1)
   SVM Secure Virtual Machine (0x8000000a/edx):
      nested paging                           = true
      LBR virtualization                      = true
      SVM lock                                = true
      NRIP save                               = true
      MSR based TSC rate control              = true
      VMCB clean bits support                 = true
      flush by ASID                           = true
      decode assists                          = true
      SSSE3/SSE5 opcode set disable           = false
      pause intercept filter                  = true
      pause filter threshold                  = true
      AVIC: AMD virtual interrupt controller  = true
      virtualized VMLOAD/VMSAVE               = true
      virtualized global interrupt flag (GIF) = true
      GMET: guest mode execute trap           = false
      guest Spec_ctl support                  = false
   NASID: number of address space identifiers = 0x8000 (32768):
   L1 TLB information: 1G pages (0x80000019/eax):
      instruction # entries     = 0x40 (64)
      instruction associativity = full (15)
      data # entries            = 0x40 (64)
      data associativity        = full (15)
   L2 TLB information: 1G pages (0x80000019/ebx):
      instruction # entries     = 0x0 (0)
      instruction associativity = L2 off (0)
      data # entries            = 0x0 (0)
      data associativity        = L2 off (0)
   SVM Secure Virtual Machine (0x8000001a/eax):
      128-bit SSE executed full-width = true
      MOVU* better than MOVL*/MOVH*   = true
      256-bit SSE executed full-width = false
   Instruction Based Sampling Identifiers (0x8000001b/eax):
      IBS feature flags valid                  = true
      IBS fetch sampling                       = true
      IBS execution sampling                   = true
      read write of op counter                 = true
      op counting mode                         = true
      branch target address reporting          = true
      IbsOpCurCnt and IbsOpMaxCnt extend 7     = true
      invalid RIP indication support           = true
      fused branch micro-op indication support = true
      IBS fetch control extended MSR support   = true
      IBS op data 4 MSR support                = false
   Lightweight Profiling Capabilities: Availability (0x8000001c/eax):
      lightweight profiling                  = false
      LWPVAL instruction                     = false
      instruction retired event              = false
      branch retired event                   = false
      DC miss event                          = false
      core clocks not halted event           = false
      core reference clocks not halted event = false
      interrupt on threshold overflow        = false
   Lightweight Profiling Capabilities: Supported (0x8000001c/edx):
      lightweight profiling                  = false
      LWPVAL instruction                     = false
      instruction retired event              = false
      branch retired event                   = false
      DC miss event                          = false
      core clocks not halted event           = false
      core reference clocks not halted event = false
      interrupt on threshold overflow        = false
   Lightweight Profiling Capabilities (0x8000001c/ebx):
      LWPCB byte size             = 0x0 (0)
      event record byte size      = 0x0 (0)
      maximum EventId             = 0x0 (0)
      EventInterval1 field offset = 0x0 (0)
   Lightweight Profiling Capabilities (0x8000001c/ecx):
      latency counter bit size          = 0x0 (0)
      data cache miss address valid     = false
      amount cache latency is rounded   = 0x0 (0)
      LWP implementation version        = 0x0 (0)
      event ring buffer size in records = 0x0 (0)
      branch prediction filtering       = false
      IP filtering                      = false
      cache level filtering             = false
      cache latency filteing            = false
   Cache Properties (0x8000001d):
      --- cache 0 ---
      type                            = data (1)
      level                           = 0x1 (1)
      self-initializing               = true
      fully associative               = false
      extra cores sharing this cache  = 0x0 (0)
      line size in bytes              = 0x40 (64)
      physical line partitions        = 0x1 (1)
      number of ways                  = 0x8 (8)
      number of sets                  = 64
      write-back invalidate           = false
      cache inclusive of lower levels = false
      (synth size)                    = 32768 (32 KB)
      --- cache 1 ---
      type                            = instruction (2)
      level                           = 0x1 (1)
      self-initializing               = true
      fully associative               = false
      extra cores sharing this cache  = 0x0 (0)
      line size in bytes              = 0x40 (64)
      physical line partitions        = 0x1 (1)
      number of ways                  = 0x4 (4)
      number of sets                  = 256
      write-back invalidate           = false
      cache inclusive of lower levels = false
      (synth size)                    = 65536 (64 KB)
      --- cache 2 ---
      type                            = unified (3)
      level                           = 0x2 (2)
      self-initializing               = true
      fully associative               = false
      extra cores sharing this cache  = 0x0 (0)
      line size in bytes              = 0x40 (64)
      physical line partitions        = 0x1 (1)
      number of ways                  = 0x8 (8)
      number of sets                  = 1024
      write-back invalidate           = false
      cache inclusive of lower levels = true
      (synth size)                    = 524288 (512 KB)
      --- cache 3 ---
      type                            = unified (3)
      level                           = 0x3 (3)
      self-initializing               = true
      fully associative               = false
      extra cores sharing this cache  = 0x2 (2)
      line size in bytes              = 0x40 (64)
      physical line partitions        = 0x1 (1)
      number of ways                  = 0x10 (16)
      number of sets                  = 8192
      write-back invalidate           = true
      cache inclusive of lower levels = false
      (synth size)                    = 8388608 (8 MB)
   extended APIC ID = 9
   Core Identifiers (0x8000001e/ebx):
      core ID          = 0x9 (9)
      threads per core = 0x1 (1)
   Node Identifiers (0x8000001e/ecx):
      node ID             = 0x0 (0)
      nodes per processor = 0x1 (1)
   AMD Secure Encryption (0x8000001f):
      SME: secure memory encryption support    = true
      SEV: secure encrypted virtualize support = true
      VM page flush MSR support                = true
      SEV-ES: SEV encrypted state support      = false
      encryption bit position in PTE           = 0x2f (47)
      physical address space width reduction   = 0x5 (5)
      number of SEV-enabled guests supported   = 0xf (15)
      minimum SEV guest ASID                   = 0x0 (0)
   (instruction supported synth):
      CMPXCHG8B                = true
      conditional move/compare = true
      PREFETCH/PREFETCHW       = true
   (multi-processing synth) = multi-core (c=6)
   (multi-processing method) = AMD
   (APIC widths synth): CORE_width=3 SMT_width=0
   (APIC synth): PKG_ID=1 CORE_ID=1 SMT_ID=0
   (uarch synth) = AMD Zen, 14nm
   (synth) = AMD Ryzen (Summit Ridge ZP-B1) [Zen], 14nm

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
