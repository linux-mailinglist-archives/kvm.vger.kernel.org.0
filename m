Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F329D1546C7
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgBFOvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:51:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgBFOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+ryQXThK+1JUVV4yzJL6CFcmCQNGKVDBk28FWUEG9JU=; b=NBNOAs84i34VYOuPbHOTSbmti3
        3tzI4b2bwFOvsUs/8oofMPoUu4DWpVJQ5XNsTc7RT3b67nICXudMpuhZmAfP9QbyUnyXnTcZttnRd
        Qd1FNnl8RtAVFVjXWjtOKr9CkmCnXdX9LtXklYjAFaDDP+FXeIO2Yt68yrziwqvhQ3+L/mZRZ5V3i
        9gcF5WnpTSYI0kxYlp/IJS+FPpPiY4AP60QK+oPtCRfSILoyDm4w54HHY5Aienp7zBSa6L1FVUawh
        bjZywCUlVPdZ5HdMU1P7ZJOqQe1F4NNpmEGBNUODdjWFCRGqq/n6Azu2r41f2Kq9ArZ9RIr4gnkbI
        GpgC14qg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004IP-AC; Thu, 06 Feb 2020 14:50:35 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nKf-DC; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 06/27] docs: virt: Convert msr.txt to ReST format
Date:   Thu,  6 Feb 2020 15:50:03 +0100
Message-Id: <43504c7b8aab378cb7019533885536c43787fed0.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use document title markup;
- Convert tables;
- Add blank lines and adjust indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst            |   1 +
 Documentation/virt/kvm/{msr.txt => msr.rst} | 147 ++++++++++++--------
 2 files changed, 93 insertions(+), 55 deletions(-)
 rename Documentation/virt/kvm/{msr.txt => msr.rst} (74%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index b39f4894b61d..cc6dde47b267 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -10,6 +10,7 @@ KVM
    amd-memory-encryption
    cpuid
    halt-polling
+   msr
    vcpu-requests
 
    arm/index
diff --git a/Documentation/virt/kvm/msr.txt b/Documentation/virt/kvm/msr.rst
similarity index 74%
rename from Documentation/virt/kvm/msr.txt
rename to Documentation/virt/kvm/msr.rst
index df1f4338b3ca..33892036672d 100644
--- a/Documentation/virt/kvm/msr.txt
+++ b/Documentation/virt/kvm/msr.rst
@@ -1,6 +1,10 @@
-KVM-specific MSRs.
-Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
-=====================================================
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
+KVM-specific MSRs
+=================
+
+:Author: Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
 
 KVM makes use of some custom MSRs to service some requests.
 
@@ -9,34 +13,39 @@ Custom MSRs have a range reserved for them, that goes from
 but they are deprecated and their use is discouraged.
 
 Custom MSR list
---------
+---------------
 
 The current supported Custom MSR list is:
 
-MSR_KVM_WALL_CLOCK_NEW:   0x4b564d00
+MSR_KVM_WALL_CLOCK_NEW:
+	0x4b564d00
 
-	data: 4-byte alignment physical address of a memory area which must be
+data:
+	4-byte alignment physical address of a memory area which must be
 	in guest RAM. This memory is expected to hold a copy of the following
-	structure:
+	structure::
 
-	struct pvclock_wall_clock {
+	 struct pvclock_wall_clock {
 		u32   version;
 		u32   sec;
 		u32   nsec;
-	} __attribute__((__packed__));
+	  } __attribute__((__packed__));
 
 	whose data will be filled in by the hypervisor. The hypervisor is only
 	guaranteed to update this data at the moment of MSR write.
 	Users that want to reliably query this information more than once have
 	to write more than once to this MSR. Fields have the following meanings:
 
-		version: guest has to check version before and after grabbing
+	version:
+		guest has to check version before and after grabbing
 		time information and check that they are both equal and even.
 		An odd version indicates an in-progress update.
 
-		sec: number of seconds for wallclock at time of boot.
+	sec:
+		 number of seconds for wallclock at time of boot.
 
-		nsec: number of nanoseconds for wallclock at time of boot.
+	nsec:
+		 number of nanoseconds for wallclock at time of boot.
 
 	In order to get the current wallclock time, the system_time from
 	MSR_KVM_SYSTEM_TIME_NEW needs to be added.
@@ -47,13 +56,15 @@ MSR_KVM_WALL_CLOCK_NEW:   0x4b564d00
 	Availability of this MSR must be checked via bit 3 in 0x4000001 cpuid
 	leaf prior to usage.
 
-MSR_KVM_SYSTEM_TIME_NEW:  0x4b564d01
+MSR_KVM_SYSTEM_TIME_NEW:
+	0x4b564d01
 
-	data: 4-byte aligned physical address of a memory area which must be in
+data:
+	4-byte aligned physical address of a memory area which must be in
 	guest RAM, plus an enable bit in bit 0. This memory is expected to hold
-	a copy of the following structure:
+	a copy of the following structure::
 
-	struct pvclock_vcpu_time_info {
+	  struct pvclock_vcpu_time_info {
 		u32   version;
 		u32   pad0;
 		u64   tsc_timestamp;
@@ -62,7 +73,7 @@ MSR_KVM_SYSTEM_TIME_NEW:  0x4b564d01
 		s8    tsc_shift;
 		u8    flags;
 		u8    pad[2];
-	} __attribute__((__packed__)); /* 32 bytes */
+	  } __attribute__((__packed__)); /* 32 bytes */
 
 	whose data will be filled in by the hypervisor periodically. Only one
 	write, or registration, is needed for each VCPU. The interval between
@@ -72,23 +83,28 @@ MSR_KVM_SYSTEM_TIME_NEW:  0x4b564d01
 
 	Fields have the following meanings:
 
-		version: guest has to check version before and after grabbing
+	version:
+		guest has to check version before and after grabbing
 		time information and check that they are both equal and even.
 		An odd version indicates an in-progress update.
 
-		tsc_timestamp: the tsc value at the current VCPU at the time
+	tsc_timestamp:
+		the tsc value at the current VCPU at the time
 		of the update of this structure. Guests can subtract this value
 		from current tsc to derive a notion of elapsed time since the
 		structure update.
 
-		system_time: a host notion of monotonic time, including sleep
+	system_time:
+		a host notion of monotonic time, including sleep
 		time at the time this structure was last updated. Unit is
 		nanoseconds.
 
-		tsc_to_system_mul: multiplier to be used when converting
+	tsc_to_system_mul:
+		multiplier to be used when converting
 		tsc-related quantity to nanoseconds
 
-		tsc_shift: shift to be used when converting tsc-related
+	tsc_shift:
+		shift to be used when converting tsc-related
 		quantity to nanoseconds. This shift will ensure that
 		multiplication with tsc_to_system_mul does not overflow.
 		A positive value denotes a left shift, a negative value
@@ -96,7 +112,7 @@ MSR_KVM_SYSTEM_TIME_NEW:  0x4b564d01
 
 		The conversion from tsc to nanoseconds involves an additional
 		right shift by 32 bits. With this information, guests can
-		derive per-CPU time by doing:
+		derive per-CPU time by doing::
 
 			time = (current_tsc - tsc_timestamp)
 			if (tsc_shift >= 0)
@@ -106,29 +122,34 @@ MSR_KVM_SYSTEM_TIME_NEW:  0x4b564d01
 			time = (time * tsc_to_system_mul) >> 32
 			time = time + system_time
 
-		flags: bits in this field indicate extended capabilities
+	flags:
+		bits in this field indicate extended capabilities
 		coordinated between the guest and the hypervisor. Availability
 		of specific flags has to be checked in 0x40000001 cpuid leaf.
 		Current flags are:
 
-		 flag bit   | cpuid bit    | meaning
-		-------------------------------------------------------------
-			    |	           | time measures taken across
-		     0      |	   24      | multiple cpus are guaranteed to
-			    |		   | be monotonic
-		-------------------------------------------------------------
-			    |		   | guest vcpu has been paused by
-		     1	    |	  N/A	   | the host
-			    |		   | See 4.70 in api.txt
-		-------------------------------------------------------------
+
+		+-----------+--------------+----------------------------------+
+		| flag bit  | cpuid bit    | meaning			      |
+		+-----------+--------------+----------------------------------+
+		|	    |		   | time measures taken across       |
+		|    0      |	   24      | multiple cpus are guaranteed to  |
+		|	    |		   | be monotonic		      |
+		+-----------+--------------+----------------------------------+
+		|	    |		   | guest vcpu has been paused by    |
+		|    1	    |	  N/A	   | the host			      |
+		|	    |		   | See 4.70 in api.txt	      |
+		+-----------+--------------+----------------------------------+
 
 	Availability of this MSR must be checked via bit 3 in 0x4000001 cpuid
 	leaf prior to usage.
 
 
-MSR_KVM_WALL_CLOCK:  0x11
+MSR_KVM_WALL_CLOCK:
+	0x11
 
-	data and functioning: same as MSR_KVM_WALL_CLOCK_NEW. Use that instead.
+data and functioning:
+	same as MSR_KVM_WALL_CLOCK_NEW. Use that instead.
 
 	This MSR falls outside the reserved KVM range and may be removed in the
 	future. Its usage is deprecated.
@@ -136,9 +157,11 @@ MSR_KVM_WALL_CLOCK:  0x11
 	Availability of this MSR must be checked via bit 0 in 0x4000001 cpuid
 	leaf prior to usage.
 
-MSR_KVM_SYSTEM_TIME: 0x12
+MSR_KVM_SYSTEM_TIME:
+	0x12
 
-	data and functioning: same as MSR_KVM_SYSTEM_TIME_NEW. Use that instead.
+data and functioning:
+	same as MSR_KVM_SYSTEM_TIME_NEW. Use that instead.
 
 	This MSR falls outside the reserved KVM range and may be removed in the
 	future. Its usage is deprecated.
@@ -146,7 +169,7 @@ MSR_KVM_SYSTEM_TIME: 0x12
 	Availability of this MSR must be checked via bit 0 in 0x4000001 cpuid
 	leaf prior to usage.
 
-	The suggested algorithm for detecting kvmclock presence is then:
+	The suggested algorithm for detecting kvmclock presence is then::
 
 		if (!kvm_para_available())    /* refer to cpuid.txt */
 			return NON_PRESENT;
@@ -163,8 +186,11 @@ MSR_KVM_SYSTEM_TIME: 0x12
 		} else
 			return NON_PRESENT;
 
-MSR_KVM_ASYNC_PF_EN: 0x4b564d02
-	data: Bits 63-6 hold 64-byte aligned physical address of a
+MSR_KVM_ASYNC_PF_EN:
+	0x4b564d02
+
+data:
+	Bits 63-6 hold 64-byte aligned physical address of a
 	64 byte memory area which must be in guest RAM and must be
 	zeroed. Bits 5-3 are reserved and should be zero. Bit 0 is 1
 	when asynchronous page faults are enabled on the vcpu 0 when
@@ -200,20 +226,22 @@ MSR_KVM_ASYNC_PF_EN: 0x4b564d02
 	Currently type 2 APF will be always delivered on the same vcpu as
 	type 1 was, but guest should not rely on that.
 
-MSR_KVM_STEAL_TIME: 0x4b564d03
+MSR_KVM_STEAL_TIME:
+	0x4b564d03
 
-	data: 64-byte alignment physical address of a memory area which must be
+data:
+	64-byte alignment physical address of a memory area which must be
 	in guest RAM, plus an enable bit in bit 0. This memory is expected to
-	hold a copy of the following structure:
+	hold a copy of the following structure::
 
-	struct kvm_steal_time {
+	  struct kvm_steal_time {
 		__u64 steal;
 		__u32 version;
 		__u32 flags;
 		__u8  preempted;
 		__u8  u8_pad[3];
 		__u32 pad[11];
-	}
+	  }
 
 	whose data will be filled in by the hypervisor periodically. Only one
 	write, or registration, is needed for each VCPU. The interval between
@@ -224,25 +252,32 @@ MSR_KVM_STEAL_TIME: 0x4b564d03
 
 	Fields have the following meanings:
 
-		version: a sequence counter. In other words, guest has to check
+	version:
+		a sequence counter. In other words, guest has to check
 		this field before and after grabbing time information and make
 		sure they are both equal and even. An odd version indicates an
 		in-progress update.
 
-		flags: At this point, always zero. May be used to indicate
+	flags:
+		At this point, always zero. May be used to indicate
 		changes in this structure in the future.
 
-		steal: the amount of time in which this vCPU did not run, in
+	steal:
+		the amount of time in which this vCPU did not run, in
 		nanoseconds. Time during which the vcpu is idle, will not be
 		reported as steal time.
 
-		preempted: indicate the vCPU who owns this struct is running or
+	preempted:
+		indicate the vCPU who owns this struct is running or
 		not. Non-zero values mean the vCPU has been preempted. Zero
 		means the vCPU is not preempted. NOTE, it is always zero if the
 		the hypervisor doesn't support this field.
 
-MSR_KVM_EOI_EN: 0x4b564d04
-	data: Bit 0 is 1 when PV end of interrupt is enabled on the vcpu; 0
+MSR_KVM_EOI_EN:
+	0x4b564d04
+
+data:
+	Bit 0 is 1 when PV end of interrupt is enabled on the vcpu; 0
 	when disabled.  Bit 1 is reserved and must be zero.  When PV end of
 	interrupt is enabled (bit 0 set), bits 63-2 hold a 4-byte aligned
 	physical address of a 4 byte memory area which must be in guest RAM and
@@ -274,11 +309,13 @@ MSR_KVM_EOI_EN: 0x4b564d04
 	clear it using a single CPU instruction, such as test and clear, or
 	compare and exchange.
 
-MSR_KVM_POLL_CONTROL: 0x4b564d05
+MSR_KVM_POLL_CONTROL:
+	0x4b564d05
+
 	Control host-side polling.
 
-	data: Bit 0 enables (1) or disables (0) host-side HLT polling logic.
+data:
+	Bit 0 enables (1) or disables (0) host-side HLT polling logic.
 
 	KVM guests can request the host not to poll on HLT, for example if
 	they are performing polling themselves.
-
-- 
2.24.1

