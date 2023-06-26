Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2511173E1E2
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjFZORr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjFZORZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:17:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F25D2728;
        Mon, 26 Jun 2023 07:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687789001; x=1719325001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQktyAbtdZBS432xYsZBwAB18tndlfwU9Pgj+CVTLyg=;
  b=oIczBCxnT6/2YBLznOQ4m4f4jrC0VhoaDTSNcyVSgagHYuzABx2URTaD
   h9kNPl7NpZwnkkvcjV7hNNwSmixlYgY02Gj8f9fxkPzO2r7dWB4ly5w0+
   bnPFg29WFN/z5meaPyApybsPZbFOTW0FxuDapkkwolVcV0okFDpOySzQJ
   1UrJ6wV3FuuSB6FQV/dVq/8qN64/jDfu0p5DwGCyUrafqPyNGPsc0sHCw
   N3avSUFY2OQ1bYyDFGVLR3J1EK9et33MPafbERkd9UZ3ajLqzyuyIDu47
   oIcx37klrwTTKt8vQFvS7m6mQALUGHtgKsSOD6KRDPZRW3QZn4oMDrBKL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346034310"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346034310"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:16:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292512"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292512"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:15:57 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v12 22/22] Documentation/x86: Add documentation for TDX host support
Date:   Tue, 27 Jun 2023 02:12:52 +1200
Message-Id: <180efee808936fcf017af4e79caec2b7111028a4.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for TDX host kernel support.  There is already one
file Documentation/x86/tdx.rst containing documentation for TDX guest
internals.  Also reuse it for TDX host kernel support.

Introduce a new level menu "TDX Guest Support" and move existing
materials under it, and add a new menu for TDX host kernel support.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v11 -> v12:
 - Removed "no CPUID/MSR to detect TDX module" related (Dave).
 - Fixed some spelling errors.

---
 Documentation/arch/x86/tdx.rst | 189 +++++++++++++++++++++++++++++++--
 1 file changed, 178 insertions(+), 11 deletions(-)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index dc8d9fd2c3f7..f8017a2a663e 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -10,6 +10,173 @@ encrypting the guest memory. In TDX, a special module running in a special
 mode sits between the host and the guest and manages the guest/host
 separation.
 
+TDX Host Kernel Support
+=======================
+
+TDX introduces a new CPU mode called Secure Arbitration Mode (SEAM) and
+a new isolated range pointed by the SEAM Ranger Register (SEAMRR).  A
+CPU-attested software module called 'the TDX module' runs inside the new
+isolated range to provide the functionalities to manage and run protected
+VMs.
+
+TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
+provide crypto-protection to the VMs.  TDX reserves part of MKTME KeyIDs
+as TDX private KeyIDs, which are only accessible within the SEAM mode.
+BIOS is responsible for partitioning legacy MKTME KeyIDs and TDX KeyIDs.
+
+Before the TDX module can be used to create and run protected VMs, it
+must be loaded into the isolated range and properly initialized.  The TDX
+architecture doesn't require the BIOS to load the TDX module, but the
+kernel assumes it is loaded by the BIOS.
+
+TDX boot-time detection
+-----------------------
+
+The kernel detects TDX by detecting TDX private KeyIDs during kernel
+boot.  Below dmesg shows when TDX is enabled by BIOS::
+
+  [..] tdx: BIOS enabled: private KeyID range: [16, 64).
+
+TDX module initialization
+---------------------------------------
+
+The kernel talks to the TDX module via the new SEAMCALL instruction.  The
+TDX module implements SEAMCALL leaf functions to allow the kernel to
+initialize it.
+
+If the TDX module isn't loaded, the SEAMCALL instruction fails with a
+special error.  In this case the kernel fails the module initialization
+and reports the module isn't loaded::
+
+  [..] tdx: Module isn't loaded.
+
+Initializing the TDX module consumes roughly ~1/256th system RAM size to
+use it as 'metadata' for the TDX memory.  It also takes additional CPU
+time to initialize those metadata along with the TDX module itself.  Both
+are not trivial.  The kernel initializes the TDX module at runtime on
+demand.
+
+Besides initializing the TDX module, a per-cpu initialization SEAMCALL
+must be done on one cpu before any other SEAMCALLs can be made on that
+cpu.
+
+The kernel provides two functions, tdx_enable() and tdx_cpu_enable() to
+allow the user of TDX to enable the TDX module and enable TDX on local
+cpu.
+
+Making SEAMCALL requires the CPU already being in VMX operation (VMXON
+has been done).  For now both tdx_enable() and tdx_cpu_enable() don't
+handle VMXON internally, but depends on the caller to guarantee that.
+
+To enable TDX, the caller of TDX should: 1) hold read lock of CPU hotplug
+lock; 2) do VMXON and tdx_enable_cpu() on all online cpus successfully;
+3) call tdx_enable().  For example::
+
+        cpus_read_lock();
+        on_each_cpu(vmxon_and_tdx_cpu_enable());
+        ret = tdx_enable();
+        cpus_read_unlock();
+        if (ret)
+                goto no_tdx;
+        // TDX is ready to use
+
+And the caller of TDX must guarantee the tdx_cpu_enable() has been
+successfully done on any cpu before it wants to run any other SEAMCALL.
+A typical usage is do both VMXON and tdx_cpu_enable() in CPU hotplug
+online callback, and refuse to online if tdx_cpu_enable() fails.
+
+User can consult dmesg to see the presence of the TDX module, and whether
+it has been initialized.
+
+If the TDX module is not loaded, dmesg shows below::
+
+  [..] tdx: TDX module is not loaded.
+
+If the TDX module is initialized successfully, dmesg shows something
+like below::
+
+  [..] tdx: TDX module: attributes 0x0, vendor_id 0x8086, major_version 1, minor_version 0, build_date 20211209, build_num 160
+  [..] tdx: 262668 KBs allocated for PAMT.
+  [..] tdx: TDX module initialized.
+
+If the TDX module failed to initialize, dmesg also shows it failed to
+initialize::
+
+  [..] tdx: TDX module initialization failed ...
+
+TDX Interaction to Other Kernel Components
+------------------------------------------
+
+TDX Memory Policy
+~~~~~~~~~~~~~~~~~
+
+TDX reports a list of "Convertible Memory Region" (CMR) to tell the
+kernel which memory is TDX compatible.  The kernel needs to build a list
+of memory regions (out of CMRs) as "TDX-usable" memory and pass those
+regions to the TDX module.  Once this is done, those "TDX-usable" memory
+regions are fixed during module's lifetime.
+
+To keep things simple, currently the kernel simply guarantees all pages
+in the page allocator are TDX memory.  Specifically, the kernel uses all
+system memory in the core-mm at the time of initializing the TDX module
+as TDX memory, and in the meantime, refuses to online any non-TDX-memory
+in the memory hotplug.
+
+This can be enhanced in the future, i.e. by allowing adding non-TDX
+memory to a separate NUMA node.  In this case, the "TDX-capable" nodes
+and the "non-TDX-capable" nodes can co-exist, but the kernel/userspace
+needs to guarantee memory pages for TDX guests are always allocated from
+the "TDX-capable" nodes.
+
+Physical Memory Hotplug
+~~~~~~~~~~~~~~~~~~~~~~~
+
+Note TDX assumes convertible memory is always physically present during
+machine's runtime.  A non-buggy BIOS should never support hot-removal of
+any convertible memory.  This implementation doesn't handle ACPI memory
+removal but depends on the BIOS to behave correctly.
+
+CPU Hotplug
+~~~~~~~~~~~
+
+TDX module requires the per-cpu initialization SEAMCALL (TDH.SYS.LP.INIT)
+must be done on one cpu before any other SEAMCALLs can be made on that
+cpu, including those involved during the module initialization.
+
+The kernel provides tdx_cpu_enable() to let the user of TDX to do it when
+the user wants to use a new cpu for TDX task.
+
+TDX doesn't support physical (ACPI) CPU hotplug.  During machine boot,
+TDX verifies all boot-time present logical CPUs are TDX compatible before
+enabling TDX.  A non-buggy BIOS should never support hot-add/removal of
+physical CPU.  Currently the kernel doesn't handle physical CPU hotplug,
+but depends on the BIOS to behave correctly.
+
+Note TDX works with CPU logical online/offline, thus the kernel still
+allows to offline logical CPU and online it again.
+
+Kexec()
+~~~~~~~
+
+There are two problems in terms of using kexec() to boot to a new kernel
+when the old kernel has enabled TDX: 1) Part of the memory pages are
+still TDX private pages; 2) There might be dirty cachelines associated
+with TDX private pages.
+
+The first problem doesn't matter.  KeyID 0 doesn't have integrity check.
+Even the new kernel wants use any non-zero KeyID, it needs to convert
+the memory to that KeyID and such conversion would work from any KeyID.
+
+However the old kernel needs to guarantee there's no dirty cacheline
+left behind before booting to the new kernel to avoid silent corruption
+from later cacheline writeback (Intel hardware doesn't guarantee cache
+coherency across different KeyIDs).
+
+Similar to AMD SME, the kernel just uses wbinvd() to flush cache before
+booting to the new kernel.
+
+TDX Guest Support
+=================
 Since the host cannot directly access guest registers or memory, much
 normal functionality of a hypervisor must be moved into the guest. This is
 implemented using a Virtualization Exception (#VE) that is handled by the
@@ -20,7 +187,7 @@ TDX includes new hypercall-like mechanisms for communicating from the
 guest to the hypervisor or the TDX module.
 
 New TDX Exceptions
-==================
+------------------
 
 TDX guests behave differently from bare-metal and traditional VMX guests.
 In TDX guests, otherwise normal instructions or memory accesses can cause
@@ -30,7 +197,7 @@ Instructions marked with an '*' conditionally cause exceptions.  The
 details for these instructions are discussed below.
 
 Instruction-based #VE
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - Port I/O (INS, OUTS, IN, OUT)
 - HLT
@@ -41,7 +208,7 @@ Instruction-based #VE
 - CPUID*
 
 Instruction-based #GP
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - All VMX instructions: INVEPT, INVVPID, VMCLEAR, VMFUNC, VMLAUNCH,
   VMPTRLD, VMPTRST, VMREAD, VMRESUME, VMWRITE, VMXOFF, VMXON
@@ -52,7 +219,7 @@ Instruction-based #GP
 - RDMSR*,WRMSR*
 
 RDMSR/WRMSR Behavior
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 MSR access behavior falls into three categories:
 
@@ -73,7 +240,7 @@ trapping and handling in the TDX module.  Other than possibly being slow,
 these MSRs appear to function just as they would on bare metal.
 
 CPUID Behavior
---------------
+~~~~~~~~~~~~~~
 
 For some CPUID leaves and sub-leaves, the virtualized bit fields of CPUID
 return values (in guest EAX/EBX/ECX/EDX) are configurable by the
@@ -93,7 +260,7 @@ not know how to handle. The guest kernel may ask the hypervisor for the
 value with a hypercall.
 
 #VE on Memory Accesses
-======================
+----------------------
 
 There are essentially two classes of TDX memory: private and shared.
 Private memory receives full TDX protections.  Its content is protected
@@ -107,7 +274,7 @@ entries.  This helps ensure that a guest does not place sensitive
 information in shared memory, exposing it to the untrusted hypervisor.
 
 #VE on Shared Memory
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 Access to shared mappings can cause a #VE.  The hypervisor ultimately
 controls whether a shared memory access causes a #VE, so the guest must be
@@ -127,7 +294,7 @@ be careful not to access device MMIO regions unless it is also prepared to
 handle a #VE.
 
 #VE on Private Pages
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 An access to private mappings can also cause a #VE.  Since all kernel
 memory is also private memory, the kernel might theoretically need to
@@ -145,7 +312,7 @@ The hypervisor is permitted to unilaterally move accepted pages to a
 to handle the exception.
 
 Linux #VE handler
-=================
+-----------------
 
 Just like page faults or #GP's, #VE exceptions can be either handled or be
 fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
@@ -167,7 +334,7 @@ While the block is in place, any #VE is elevated to a double fault (#DF)
 which is not recoverable.
 
 MMIO handling
-=============
+-------------
 
 In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
 mapping which will cause a VMEXIT on access, and then the hypervisor
@@ -189,7 +356,7 @@ MMIO access via other means (like structure overlays) may result in an
 oops.
 
 Shared Memory Conversions
-=========================
+-------------------------
 
 All TDX guest memory starts out as private at boot.  This memory can not
 be accessed by the hypervisor.  However, some kernel users like device
-- 
2.40.1

