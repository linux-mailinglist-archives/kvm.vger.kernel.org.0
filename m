Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE73156F14
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgBJGDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:03:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgBJGDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PCOYorxp5B66Bz7dLpdri3RiULamlM3oIiU8p4XbyRM=; b=CwID2ypUiVS4KSCL4PaxfFZG8z
        PvMuFFKerubiFW4Gfiu0rdhLZ5JqtvUzsmOzivZrLW9IapSUfKzHi5djXqYEkrAxGP8maRzVhAHYW
        b3ao5ZqbLQ+0nZKDVfgoshwwz9+If0pGQKT31lEOKPyY9xrt3IIrH07fG9FVci1bJr/BkQJ4WDRpK
        Tv3xCjD0KItoP/Ao6tfwFmDO+weMvKdpgCnTqUzFcEU96yfl1dNhX/qPysBpxpl71Y0wq/6RvJ630
        Tbml4Ro6Su8BoUbqZyJwVJpgEVvfLPlG+4XPupJ3Khy6kyjD5XgHL3MhCP6EVXpSPgZyY2qSReY5O
        BxFYx4OQ==;
Received: from [80.156.29.194] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12A4-0006Tu-5J; Mon, 10 Feb 2020 06:03:12 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1j12A2-00C2WA-El; Mon, 10 Feb 2020 07:03:10 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 20/28] docs: kvm: Convert hypercalls.txt to ReST format
Date:   Mon, 10 Feb 2020 07:02:58 +0100
Message-Id: <48904ada2b9d61f513fc081358cbc4406926c999.1581314317.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581314316.git.mchehab+huawei@kernel.org>
References: <cover.1581314316.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use document title and chapter markups;
- Convert tables;
- Add markups for literal blocks;
- use :field: for field descriptions;
- Add blank lines and adjust indentation

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../kvm/{hypercalls.txt => hypercalls.rst}    | 129 ++++++++++--------
 Documentation/virt/kvm/index.rst              |   2 +
 2 files changed, 75 insertions(+), 56 deletions(-)
 rename Documentation/virt/kvm/{hypercalls.txt => hypercalls.rst} (55%)

diff --git a/Documentation/virt/kvm/hypercalls.txt b/Documentation/virt/kvm/hypercalls.rst
similarity index 55%
rename from Documentation/virt/kvm/hypercalls.txt
rename to Documentation/virt/kvm/hypercalls.rst
index 5f6d291bd004..dbaf207e560d 100644
--- a/Documentation/virt/kvm/hypercalls.txt
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -1,5 +1,9 @@
-Linux KVM Hypercall:
+.. SPDX-License-Identifier: GPL-2.0
+
 ===================
+Linux KVM Hypercall
+===================
+
 X86:
  KVM Hypercalls have a three-byte sequence of either the vmcall or the vmmcall
  instruction. The hypervisor can replace it with instructions that are
@@ -20,7 +24,7 @@ S390:
   For further information on the S390 diagnose call as supported by KVM,
   refer to Documentation/virt/kvm/s390-diag.txt.
 
- PowerPC:
+PowerPC:
   It uses R3-R10 and hypercall number in R11. R4-R11 are used as output registers.
   Return value is placed in R3.
 
@@ -34,7 +38,8 @@ MIPS:
   the return value is placed in $2 (v0).
 
 KVM Hypercalls Documentation
-===========================
+============================
+
 The template for each hypercall is:
 1. Hypercall name.
 2. Architecture(s)
@@ -43,56 +48,64 @@ The template for each hypercall is:
 
 1. KVM_HC_VAPIC_POLL_IRQ
 ------------------------
-Architecture: x86
-Status: active
-Purpose: Trigger guest exit so that the host can check for pending
-interrupts on reentry.
+
+:Architecture: x86
+:Status: active
+:Purpose: Trigger guest exit so that the host can check for pending
+          interrupts on reentry.
 
 2. KVM_HC_MMU_OP
-------------------------
-Architecture: x86
-Status: deprecated.
-Purpose: Support MMU operations such as writing to PTE,
-flushing TLB, release PT.
+----------------
+
+:Architecture: x86
+:Status: deprecated.
+:Purpose: Support MMU operations such as writing to PTE,
+          flushing TLB, release PT.
 
 3. KVM_HC_FEATURES
-------------------------
-Architecture: PPC
-Status: active
-Purpose: Expose hypercall availability to the guest. On x86 platforms, cpuid
-used to enumerate which hypercalls are available. On PPC, either device tree
-based lookup ( which is also what EPAPR dictates) OR KVM specific enumeration
-mechanism (which is this hypercall) can be used.
+------------------
+
+:Architecture: PPC
+:Status: active
+:Purpose: Expose hypercall availability to the guest. On x86 platforms, cpuid
+          used to enumerate which hypercalls are available. On PPC, either
+	  device tree based lookup ( which is also what EPAPR dictates)
+	  OR KVM specific enumeration mechanism (which is this hypercall)
+	  can be used.
 
 4. KVM_HC_PPC_MAP_MAGIC_PAGE
-------------------------
-Architecture: PPC
-Status: active
-Purpose: To enable communication between the hypervisor and guest there is a
-shared page that contains parts of supervisor visible register state.
-The guest can map this shared page to access its supervisor register through
-memory using this hypercall.
+----------------------------
+
+:Architecture: PPC
+:Status: active
+:Purpose: To enable communication between the hypervisor and guest there is a
+	  shared page that contains parts of supervisor visible register state.
+	  The guest can map this shared page to access its supervisor register
+	  through memory using this hypercall.
 
 5. KVM_HC_KICK_CPU
-------------------------
-Architecture: x86
-Status: active
-Purpose: Hypercall used to wakeup a vcpu from HLT state
-Usage example : A vcpu of a paravirtualized guest that is busywaiting in guest
-kernel mode for an event to occur (ex: a spinlock to become available) can
-execute HLT instruction once it has busy-waited for more than a threshold
-time-interval. Execution of HLT instruction would cause the hypervisor to put
-the vcpu to sleep until occurrence of an appropriate event. Another vcpu of the
-same guest can wakeup the sleeping vcpu by issuing KVM_HC_KICK_CPU hypercall,
-specifying APIC ID (a1) of the vcpu to be woken up. An additional argument (a0)
-is used in the hypercall for future use.
+------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: Hypercall used to wakeup a vcpu from HLT state
+:Usage example:
+  A vcpu of a paravirtualized guest that is busywaiting in guest
+  kernel mode for an event to occur (ex: a spinlock to become available) can
+  execute HLT instruction once it has busy-waited for more than a threshold
+  time-interval. Execution of HLT instruction would cause the hypervisor to put
+  the vcpu to sleep until occurrence of an appropriate event. Another vcpu of the
+  same guest can wakeup the sleeping vcpu by issuing KVM_HC_KICK_CPU hypercall,
+  specifying APIC ID (a1) of the vcpu to be woken up. An additional argument (a0)
+  is used in the hypercall for future use.
 
 
 6. KVM_HC_CLOCK_PAIRING
-------------------------
-Architecture: x86
-Status: active
-Purpose: Hypercall used to synchronize host and guest clocks.
+-----------------------
+:Architecture: x86
+:Status: active
+:Purpose: Hypercall used to synchronize host and guest clocks.
+
 Usage:
 
 a0: guest physical address where host copies
@@ -101,6 +114,8 @@ a0: guest physical address where host copies
 a1: clock_type, ATM only KVM_CLOCK_PAIRING_WALLCLOCK (0)
 is supported (corresponding to the host's CLOCK_REALTIME clock).
 
+       ::
+
 		struct kvm_clock_pairing {
 			__s64 sec;
 			__s64 nsec;
@@ -123,15 +138,16 @@ Returns KVM_EOPNOTSUPP if the host does not use TSC clocksource,
 or if clock type is different than KVM_CLOCK_PAIRING_WALLCLOCK.
 
 6. KVM_HC_SEND_IPI
-------------------------
-Architecture: x86
-Status: active
-Purpose: Send IPIs to multiple vCPUs.
+------------------
 
-a0: lower part of the bitmap of destination APIC IDs
-a1: higher part of the bitmap of destination APIC IDs
-a2: the lowest APIC ID in bitmap
-a3: APIC ICR
+:Architecture: x86
+:Status: active
+:Purpose: Send IPIs to multiple vCPUs.
+
+- a0: lower part of the bitmap of destination APIC IDs
+- a1: higher part of the bitmap of destination APIC IDs
+- a2: the lowest APIC ID in bitmap
+- a3: APIC ICR
 
 The hypercall lets a guest send multicast IPIs, with at most 128
 128 destinations per hypercall in 64-bit mode and 64 vCPUs per
@@ -143,12 +159,13 @@ corresponds to the APIC ID a2+1, and so on.
 Returns the number of CPUs to which the IPIs were delivered successfully.
 
 7. KVM_HC_SCHED_YIELD
-------------------------
-Architecture: x86
-Status: active
-Purpose: Hypercall used to yield if the IPI target vCPU is preempted
+---------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: Hypercall used to yield if the IPI target vCPU is preempted
 
 a0: destination APIC ID
 
-Usage example: When sending a call-function IPI-many to vCPUs, yield if
-any of the IPI target vCPUs was preempted.
+:Usage example: When sending a call-function IPI-many to vCPUs, yield if
+	        any of the IPI target vCPUs was preempted.
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 6fe79185b9bc..ac83bc588f7e 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -11,8 +11,10 @@ KVM
    amd-memory-encryption
    cpuid
    halt-polling
+   hypercalls
    msr
    vcpu-requests
 
    arm/index
+
    devices/index
-- 
2.24.1

