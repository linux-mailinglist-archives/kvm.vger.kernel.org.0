Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BCA60EC44
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiJZXUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiJZXTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:19:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F810D259D;
        Wed, 26 Oct 2022 16:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826307; x=1698362307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DXhfNmG40eNX4hHO1I24XinTjEqsVrNktuvvwcnfUjE=;
  b=YajoDtyBpf1J9M/vCqSQfqJv+mz6VGshAG4yNB2tHptumEXAKQNk2xCT
   9l9l06kT9nJHuPeFCt7FqP2vWEPOIRawL8ks34fUzRLEy7Q6cfUG8PWFo
   z5VZs/oQm7Ky7rqgmd8GSIl9L4MPKkjjKmyq+ptTRxQRPq7B0bpZa9pGa
   O48TskW5Gcm6Gz3+OGr9zFFINY6rAYp5kKReOjY5kTzafCXn5Hoct/b2V
   Jwyls0IGA1UryjcoRMs747Eg2FnffxRZr2rr3qjziycpwlwH6C0x7ZvPj
   sj27p00nStPN/Vugw6irRoIrjkzKU0OayNWqoycko2NVXMhjBEQXoptHf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175677"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175677"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:27 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446583"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446583"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 21/21] Documentation/x86: Add documentation for TDX host support
Date:   Thu, 27 Oct 2022 12:16:20 +1300
Message-Id: <a3783eb87c0b3e652938dfd8714ed2fe93989c76.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/x86/tdx.rst | 209 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 198 insertions(+), 11 deletions(-)

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index b8fa4329e1a5..59481dbe64b2 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -10,6 +10,193 @@ encrypting the guest memory. In TDX, a special module running in a special
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
+  [..] tdx: TDX enabled by BIOS. TDX private KeyID range: [16, 64).
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
+Initializing the TDX module requires all logical CPUs being online.
+tdx_enable() internally temporarily disables CPU hotplug to prevent any
+CPU from going offline, but the caller still needs to guarantee all
+present CPUs are online before calling tdx_enable().
+
+Also, tdx_enable() requires all CPUs are already in VMX operation
+(requirement of making SEAMCALL).  Currently, tdx_enable() doesn't handle
+VMXON internally, but depends on the caller to guarantee that.  So far
+KVM is the only user of TDX and KVM already handles VMXON.
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
+If the TDX module failed to initialize, dmesg shows below::
+
+  [..] tdx: Failed to initialize TDX module. Shut it down.
+
+TDX Interaction to Other Kernel Components
+------------------------------------------
+
+TDX Memory Policy
+~~~~~~~~~~~~~~~~~
+
+The TDX module reports a list of "Convertible Memory Region" (CMR) to
+indicate which memory regions are TDX-capable.  Those regions are
+generated by BIOS and verified by the MCHECK so that they are truly
+present during platform boot and can meet security guarantees.
+
+However those TDX convertible memory regions are not automatically usable
+to the TDX module.  The kernel needs to choose all TDX-usable memory
+regions and pass those regions to the TDX module when initializing it.
+After TDX module is initialized, no more TDX-usable memory can be added
+to the TDX module.
+
+To keep things simple, this initial implementation chooses to use all
+boot-time present memory managed by the page allocator as TDX memory.
+This _requires_ all boot-time present memory is TDX convertible memory,
+which is true in practice.  If there's any boot-time memory isn't TDX
+convertible memory (which is allowed from TDX architecture's point of
+view), it will be caught later during TDX module initialization and the
+initialization will fail.
+
+However one machine may support both TDX and non-TDX memory both at
+machine boot time and runtime.  For example, any memory hot-added at
+runtime cannot be TDX memory.  Also, for now NVDIMM and CXL memory are
+not TDX memory, no matter whether they are present at machine boot time
+or not.
+
+This raises a problem that, if any non-TDX memory is hot-added to the
+system-wide memory allocation pool, a non-TDX page may be allocated to a
+TDX guest, which will result in failing to create the TDX guest, or
+killing it at runtime.
+
+The current implementation doesn't explicitly prevent adding any non-TDX
+memory to system-wide memory pool, but depends on the machine owner to
+make sure such operation won't happen.  For example, the machine owner
+should never plug any NVDIMM or CXL memory to the machine, or use kmem
+driver to hot-add any to the core-mm.
+
+This will be enhanced in the future.  One solution is the kernel can be
+enforced to always guarantee all pages in the page allocator are TDX
+memory (i.e. by rejecting non-TDX memory in memory hotplug).  Another
+option is the kernel may support different memory capabilities on basis
+of NUMA node.  For example, the kernel can have both TDX-compatible NUMA
+node and non-TDX-compatible memory NUMA node, and the userspace needs to
+explicitly bind TDX guests to those TDX-compatible memory NUMA nodes.
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
+Memory Hotplug
+~~~~~~~~~~~~~~
+
+TDX doesn't support ACPI memory hotplug of convertible memory.  The list
+of "Convertible Memory Regions" (CMR) is static during machine's runtime.
+TDX also assumes convertible memory won't be hot-removed.  A non-buggy
+BIOS should never support physical hot-removal of convertible memory.
+Currently the kernel doesn't handle hot-removal of convertible memory but
+depends on the BIOS to behave correctly.
+
+It's possible that one machine can have both TDX and non-TDX memory.
+Specifically, all hot-added physical memory are not TDX convertible
+memory.  Also, for now NVDIMM and CXL memory are not TDX convertible
+memory, no matter whether they are physically present during boot or not.
+
+Plug non-TDX memory to the page allocator could result in failing to
+create a TDX guest, or killing a running TDX guest.
+
+To keep things simple, this series doesn't handle memory hotplug at all,
+but depends on the machine owner to not do any memory hotplug operation.
+For example, the machine owner should not plug any NVDIMM or CXL memory
+into the machine, or use kmem driver to plug NVDIMM or CXL memory to the
+core-mm.
+
+Kexec()
+~~~~~~~
+
+TDX (and MKTME) doesn't guarantee cache coherency among different KeyIDs.
+If the TDX module is ever initialized, the kernel needs to flush dirty
+cachelines associated with any TDX private KeyID, otherwise they may
+slightly corrupt the new kernel.
+
+Similar to SME support, the kernel uses wbinvd() to flush cache in
+stop_this_cpu().
+
+The current TDX module architecture doesn't play nicely with kexec().
+The TDX module can only be initialized once during its lifetime, and
+there is no SEAMCALL to reset the module to give a new clean slate to
+the new kernel.  Therefore, ideally, if the module is ever initialized,
+it's better to shut down the module.  The new kernel won't be able to
+use TDX anyway (as it needs to go through the TDX module initialization
+process which will fail immediately at the first step).
+
+However, there's no guarantee CPU is in VMX operation during kexec(), so
+it's impractical to shut down the module.  Currently, the kernel just
+leaves the module in open state.
+
+TDX Guest Support
+=================
 Since the host cannot directly access guest registers or memory, much
 normal functionality of a hypervisor must be moved into the guest. This is
 implemented using a Virtualization Exception (#VE) that is handled by the
@@ -20,7 +207,7 @@ TDX includes new hypercall-like mechanisms for communicating from the
 guest to the hypervisor or the TDX module.
 
 New TDX Exceptions
-==================
+------------------
 
 TDX guests behave differently from bare-metal and traditional VMX guests.
 In TDX guests, otherwise normal instructions or memory accesses can cause
@@ -30,7 +217,7 @@ Instructions marked with an '*' conditionally cause exceptions.  The
 details for these instructions are discussed below.
 
 Instruction-based #VE
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - Port I/O (INS, OUTS, IN, OUT)
 - HLT
@@ -41,7 +228,7 @@ Instruction-based #VE
 - CPUID*
 
 Instruction-based #GP
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - All VMX instructions: INVEPT, INVVPID, VMCLEAR, VMFUNC, VMLAUNCH,
   VMPTRLD, VMPTRST, VMREAD, VMRESUME, VMWRITE, VMXOFF, VMXON
@@ -52,7 +239,7 @@ Instruction-based #GP
 - RDMSR*,WRMSR*
 
 RDMSR/WRMSR Behavior
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 MSR access behavior falls into three categories:
 
@@ -73,7 +260,7 @@ trapping and handling in the TDX module.  Other than possibly being slow,
 these MSRs appear to function just as they would on bare metal.
 
 CPUID Behavior
---------------
+~~~~~~~~~~~~~~
 
 For some CPUID leaves and sub-leaves, the virtualized bit fields of CPUID
 return values (in guest EAX/EBX/ECX/EDX) are configurable by the
@@ -93,7 +280,7 @@ not know how to handle. The guest kernel may ask the hypervisor for the
 value with a hypercall.
 
 #VE on Memory Accesses
-======================
+----------------------
 
 There are essentially two classes of TDX memory: private and shared.
 Private memory receives full TDX protections.  Its content is protected
@@ -107,7 +294,7 @@ entries.  This helps ensure that a guest does not place sensitive
 information in shared memory, exposing it to the untrusted hypervisor.
 
 #VE on Shared Memory
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 Access to shared mappings can cause a #VE.  The hypervisor ultimately
 controls whether a shared memory access causes a #VE, so the guest must be
@@ -127,7 +314,7 @@ be careful not to access device MMIO regions unless it is also prepared to
 handle a #VE.
 
 #VE on Private Pages
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 An access to private mappings can also cause a #VE.  Since all kernel
 memory is also private memory, the kernel might theoretically need to
@@ -145,7 +332,7 @@ The hypervisor is permitted to unilaterally move accepted pages to a
 to handle the exception.
 
 Linux #VE handler
-=================
+-----------------
 
 Just like page faults or #GP's, #VE exceptions can be either handled or be
 fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
@@ -167,7 +354,7 @@ While the block is in place, any #VE is elevated to a double fault (#DF)
 which is not recoverable.
 
 MMIO handling
-=============
+-------------
 
 In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
 mapping which will cause a VMEXIT on access, and then the hypervisor
@@ -189,7 +376,7 @@ MMIO access via other means (like structure overlays) may result in an
 oops.
 
 Shared Memory Conversions
-=========================
+-------------------------
 
 All TDX guest memory starts out as private at boot.  This memory can not
 be accessed by the hypervisor.  However, some kernel users like device
-- 
2.37.3

