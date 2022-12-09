Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070D8647E25
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiLIG5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLIG4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:56:45 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAA17D04A;
        Thu,  8 Dec 2022 22:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568883; x=1702104883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A8Dl7ZGsiYbv17bp8M14VPIPaDUgGEKolvJTmYFdtsE=;
  b=dVVDUHt+TRtq6V3Ej2jzo1XECMUzBHMVwsLrp+uaLKBCM8fH/00rYDCY
   WAxzbcEsIO8kTYsQC2dFYMPZo6NBSlW9Fa8382iwesjzt0u0OspNolicz
   Ydb4OK/YqBKT/dLNMVjuzPrUnrfWckX5nu3JDd1EUJF/S+MHt7GiwPPEg
   4KVETfsIxt/+XUK9tDdtlA8bUBczfVaRLoQxeWzgijt/r3cTDFWIYD8h4
   SC/ML9Gfv1b2TNy1bXgN3+PkwR8Cj8xIulAyH2FCAXvdRW92qiEzIQ30q
   6qzkhyPvlWIgHzk8QcNIMEx0q/w9Vomy/jSQUfvdjlf1u4JRBNu920OrR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551557"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551557"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679837193"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679837193"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:19 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 16/16] Documentation/x86: Add documentation for TDX host support
Date:   Fri,  9 Dec 2022 19:52:37 +1300
Message-Id: <11fb07f0ca78c89c4850adbf9b0d146201c98ef2.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/x86/tdx.rst | 169 +++++++++++++++++++++++++++++++++++---
 1 file changed, 158 insertions(+), 11 deletions(-)

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index dc8d9fd2c3f7..207b91610b36 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -10,6 +10,153 @@ encrypting the guest memory. In TDX, a special module running in a special
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
+TDX module detection and initialization
+---------------------------------------
+
+There is no CPUID or MSR to detect the TDX module.  The kernel detects it
+by initializing it.
+
+The kernel talks to the TDX module via the new SEAMCALL instruction.  The
+TDX module implements SEAMCALL leaf functions to allow the kernel to
+initialize it.
+
+Initializing the TDX module consumes roughly ~1/256th system RAM size to
+use it as 'metadata' for the TDX memory.  It also takes additional CPU
+time to initialize those metadata along with the TDX module itself.  Both
+are not trivial.  The kernel initializes the TDX module at runtime on
+demand.  The caller to call tdx_enable() to initialize the TDX module::
+
+        ret = tdx_enable();
+        if (ret)
+                goto no_tdx;
+        // TDX is ready to use
+
+One step of initializing the TDX module requires at least one online cpu
+for each package.  The caller needs to guarantee this otherwise the
+initialization will fail.
+
+Making SEAMCALL requires the CPU already being in VMX operation (VMXON
+has been done).  For now tdx_enable() doesn't handle VMXON internally,
+but depends on the caller to guarantee that.  So far only KVM calls
+tdx_enable() and KVM already handles VMXON.
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
+  [..] tdx: 65667 pages allocated for PAMT.
+  [..] tdx: TDX module initialized.
+
+If the TDX module failed to initialize, dmesg also shows it failed to
+initialize::
+
+  [..] tdx: initialization failed ...
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
+still TDX private pages (i.e. metadata used by the TDX module, and any
+TDX guest memory if kexec() is executed when there's live TDX guests).
+2) There might be dirty cachelines associated with TDX private pages.
+
+Because the hardware doesn't guarantee cache coherency among different
+KeyIDs, the old kernel needs to flush cache (of TDX private pages)
+before booting to the new kernel.  Also, the kernel doesn't convert all
+TDX private pages back to normal because of below considerations:
+
+1) Neither the kernel nor the TDX module has existing infrastructure to
+   track which pages are TDX private page.
+2) The number of TDX private pages can be large, and converting all of
+   them (cache flush + using MOVDIR64B to clear the page) can be time
+   consuming.
+3) The new kernel will almost only use KeyID 0 to access memory.  KeyID
+   0 doesn't support integrity-check, so it's OK.
+4) The kernel doesn't (and may never) support MKTME.  If any 3rd party
+   kernel ever supports MKTME, it can/should do MOVDIR64B to clear the
+   page with the new MKTME KeyID (just like TDX does) before using it.
+
+TDX Guest Support
+=================
 Since the host cannot directly access guest registers or memory, much
 normal functionality of a hypervisor must be moved into the guest. This is
 implemented using a Virtualization Exception (#VE) that is handled by the
@@ -20,7 +167,7 @@ TDX includes new hypercall-like mechanisms for communicating from the
 guest to the hypervisor or the TDX module.
 
 New TDX Exceptions
-==================
+------------------
 
 TDX guests behave differently from bare-metal and traditional VMX guests.
 In TDX guests, otherwise normal instructions or memory accesses can cause
@@ -30,7 +177,7 @@ Instructions marked with an '*' conditionally cause exceptions.  The
 details for these instructions are discussed below.
 
 Instruction-based #VE
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - Port I/O (INS, OUTS, IN, OUT)
 - HLT
@@ -41,7 +188,7 @@ Instruction-based #VE
 - CPUID*
 
 Instruction-based #GP
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - All VMX instructions: INVEPT, INVVPID, VMCLEAR, VMFUNC, VMLAUNCH,
   VMPTRLD, VMPTRST, VMREAD, VMRESUME, VMWRITE, VMXOFF, VMXON
@@ -52,7 +199,7 @@ Instruction-based #GP
 - RDMSR*,WRMSR*
 
 RDMSR/WRMSR Behavior
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 MSR access behavior falls into three categories:
 
@@ -73,7 +220,7 @@ trapping and handling in the TDX module.  Other than possibly being slow,
 these MSRs appear to function just as they would on bare metal.
 
 CPUID Behavior
---------------
+~~~~~~~~~~~~~~
 
 For some CPUID leaves and sub-leaves, the virtualized bit fields of CPUID
 return values (in guest EAX/EBX/ECX/EDX) are configurable by the
@@ -93,7 +240,7 @@ not know how to handle. The guest kernel may ask the hypervisor for the
 value with a hypercall.
 
 #VE on Memory Accesses
-======================
+----------------------
 
 There are essentially two classes of TDX memory: private and shared.
 Private memory receives full TDX protections.  Its content is protected
@@ -107,7 +254,7 @@ entries.  This helps ensure that a guest does not place sensitive
 information in shared memory, exposing it to the untrusted hypervisor.
 
 #VE on Shared Memory
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 Access to shared mappings can cause a #VE.  The hypervisor ultimately
 controls whether a shared memory access causes a #VE, so the guest must be
@@ -127,7 +274,7 @@ be careful not to access device MMIO regions unless it is also prepared to
 handle a #VE.
 
 #VE on Private Pages
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 An access to private mappings can also cause a #VE.  Since all kernel
 memory is also private memory, the kernel might theoretically need to
@@ -145,7 +292,7 @@ The hypervisor is permitted to unilaterally move accepted pages to a
 to handle the exception.
 
 Linux #VE handler
-=================
+-----------------
 
 Just like page faults or #GP's, #VE exceptions can be either handled or be
 fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
@@ -167,7 +314,7 @@ While the block is in place, any #VE is elevated to a double fault (#DF)
 which is not recoverable.
 
 MMIO handling
-=============
+-------------
 
 In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
 mapping which will cause a VMEXIT on access, and then the hypervisor
@@ -189,7 +336,7 @@ MMIO access via other means (like structure overlays) may result in an
 oops.
 
 Shared Memory Conversions
-=========================
+-------------------------
 
 All TDX guest memory starts out as private at boot.  This memory can not
 be accessed by the hypervisor.  However, some kernel users like device
-- 
2.38.1

