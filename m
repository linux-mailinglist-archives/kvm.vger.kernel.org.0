Return-Path: <kvm+bounces-19254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD8D9028A0
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 20:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70159B220F2
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2155414E2F1;
	Mon, 10 Jun 2024 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NryYOI1v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BC414BF89;
	Mon, 10 Jun 2024 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718043946; cv=none; b=LCdBtuP7lCL5pivwzE045YQ078h+vMikOm1ysTOXxvSwgdRTsjRkxrjaP8h8bOM5Cd+M7bu3m9gljroi99/W/17wSJIC/3h37dejHfuknbqFwp103ISS5j5RUvhqweCalqpIOEtTFapW8ozWhofuRWnG5kq8eJuLOuLOBlELo7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718043946; c=relaxed/simple;
	bh=CgmItXHuKGWcIesgbvrU1YmJC+ezBX6HnPlt5t9/mW4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=R13rzZn7zgpOH9V7trfU6AxWNU807xqlKeFaX4OvlA2Ex9Cv8qmMj7AXNICiq3OeGIfMTYY4uk2OhNA+jeC+csq4QHLcx9aUzu95NyRMtyLVWgti2+52zCzOlj+o68c3DwxsfLKy3do02dSA/TPfLZq+CG9jmHeKv9tHTbaYSX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NryYOI1v; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718043943; x=1749579943;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CgmItXHuKGWcIesgbvrU1YmJC+ezBX6HnPlt5t9/mW4=;
  b=NryYOI1voFAeFymqbO1zlyqHj4mJ/qnuYozuO3Q6M98eSjYjobOiaIqi
   vM+KZdYGkOzVERcUXSuUGyGmi3Ha+X3R34mjQbRqXW0zk9lTYkD1fAP5C
   zGm7KvhejypenGx/UFCMkOCs5BBp+ZKfCVdedz4QhuY3pw1JDqENXPHsu
   DcAO8yCBpoBdK90pOJ3LGeVsOUHRm5jDByFI51swxt5WwaroiBp9Jdr57
   /ARc3uHigHHUrjh4epL6LGGAlMwC+WYRpZ/kLN90ADx+tLc+zv4V6ZiQh
   ClJGEmaahz5F09jXoIOoEfafwsJZXX7eXIVGXQPdMupOvoRNhvZK751VU
   Q==;
X-CSE-ConnectionGUID: KKXZA2BsTzubx1INK6vSzw==
X-CSE-MsgGUID: WKoy/RoFRbyeemWn3sTEAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="14875069"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="14875069"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:25:40 -0700
X-CSE-ConnectionGUID: NiCEtLYBR4uuKU4UnhCsvg==
X-CSE-MsgGUID: NUJPxep2SRmonOwv0NR+dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="44072142"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:25:41 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: isaku.yamahata@intel.com,
	pbonzini@redhat.com,
	erdemaktas@google.com,
	vkuznets@redhat.com,
	seanjc@google.com,
	vannapurve@google.com,
	jmattson@google.com,
	mlevitsk@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	yuan.yao@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V8 0/2] KVM: x86: Make bus clock frequency for vAPIC timer configurable
Date: Mon, 10 Jun 2024 11:25:33 -0700
Message-Id: <cover.1718043121.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes from v7:
- v7: https://lore.kernel.org/lkml/cover.1717695426.git.reinette.chatre@intel.com/
- Use appropriate ioctl() return type.
- Let new tsc_khz used by KVM selftest be of the same type as same variable
  used in kernel.
- Please refer to individual patches for detailed changes.

Changes from v6:
- V6: https://lore.kernel.org/lkml/cover.1715017765.git.reinette.chatre@intel.com/
- KVM changes were merged into kvm-x86 misc and subsequently dropped from
  this submission. This submission only contains the selftest changes.
  https://lore.kernel.org/lkml/ZmBw9R_jkNLYXkJh@google.com/
- New patch to add udelay() utility to x86_64 KVM selftests. (Sean)
- Many changes to APIC bus frequency selftest. Please refer to the patch
  for detailed changes.
- Series applies cleanly to next branch of kvm-x86 with HEAD
  af0903ab52ee6d6f0f63af67fa73d5eb00f79b9a.

Changes from v5:
- v5: https://lore.kernel.org/lkml/cover.1714081725.git.reinette.chatre@intel.com/
- Rebased on latest of "next" branch of https://github.com/kvm-x86/linux.git
- Added Xiaoyao Li and Yuan Yao's Reviewed-by tags.
- Use the KVM selftest vm_create() wrapper instead of open coding it. (Zide)
- Improve grammar of selftest description. (Zide)

Changes from v4:
- v4: https://lore.kernel.org/lkml/cover.1711035400.git.reinette.chatre@intel.com/
- Rename capability from KVM_CAP_X86_APIC_BUS_FREQUENCY to
  KVM_CAP_X86_APIC_BUS_CYCLES_NS. (Xiaoyao Li).
- Include "Testing" section in cover letter.
- Add Rick's Reviewed-by tags.
- Rebased on latest of "next" branch of https://github.com/kvm-x86/linux.git

Changes from v3:
- v3: https://lore.kernel.org/all/cover.1702974319.git.isaku.yamahata@intel.com/
- Reworked all changelogs.
- Regarding code changes: patches #1 and #2 are unchanged, patch #3 was
  reworked according to Sean's guidance, and patch #4 (the test)
  needed changes after rebase to kvm-x86/next and the implementation
  (patch #3) changes.
- Added Reviewed-by tags to patches #1, #2, and #4, but removed
  Maxim's Reviewed-by tag from patch #3 because it changed so much.
- Added a "Suggested-by" to patch #4 to reflect that it represents
  Sean's guidance.
- Reworked cover to match customs (in subject line) and reflect feedback
  to patches: capability renamed to KVM_CAP_X86_APIC_BUS_FREQUENCY, clarify
  distinction between "core crystal clock" and "bus clock", and update
  pro/con list.
- Please refer to individual patches for detailed changes.

Changes from v2:
- v2: https://lore.kernel.org/lkml/cover.1699936040.git.isaku.yamahata@intel.com/
- Removed APIC_BUS_FREQUENCY and apic_bus_frequency of struct kvm-arch.
- Update the commit messages.
- Added reviewed-by (Maxim Levitsky)
- Use 1.5GHz instead of 1GHz as frequency for the test case.

Changes from v1:
- v1: https://lore.kernel.org/all/cover.1699383993.git.isaku.yamahata@intel.com/
- Added a test case
- Fix a build error for i386 platform
- Add check if vcpu isn't created.
- Add check if lapic chip is in-kernel emulation.
- Updated api.rst

Summary
-------
Add KVM_CAP_X86_APIC_BUS_CYCLES_NS capability to configure the APIC
bus clock frequency for APIC timer emulation.
Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_CYCLES_NS) to set the
frequency in nanoseconds. When using this capability, the user space
VMM should configure CPUID leaf 0x15 to advertise the frequency.

Description
-----------
Vishal reported [1] that the TDX guest kernel expects a 25MHz APIC bus
frequency but ends up getting interrupts at a significantly higher rate.

The TDX architecture hard-codes the core crystal clock frequency to
25MHz and mandates exposing it via CPUID leaf 0x15. The TDX architecture
does not allow the VMM to override the value.

In addition, per Intel SDM:
    "The APIC timer frequency will be the processor’s bus clock or core
     crystal clock frequency (when TSC/core crystal clock ratio is
     enumerated in CPUID leaf 0x15) divided by the value specified in
     the divide configuration register."

The resulting 25MHz APIC bus frequency conflicts with the KVM hardcoded
APIC bus frequency of 1GHz.

The KVM doesn't enumerate CPUID leaf 0x15 to the guest unless the user
space VMM sets it using KVM_SET_CPUID. If the CPUID leaf 0x15 is
enumerated, the guest kernel uses it as the APIC bus frequency. If not,
the guest kernel measures the frequency based on other known timers like
the ACPI timer or the legacy PIT. As reported in [1] the TDX guest kernel
expects a 25MHz timer frequency but gets timer interrupt more frequently
due to the 1GHz frequency used by KVM.

To ensure that the guest doesn't have a conflicting view of the APIC bus
frequency, allow the userspace to tell KVM to use the same frequency that
TDX mandates instead of the default 1Ghz.

There are several options to address this:
1. Make the KVM able to configure APIC bus frequency (this series).
   Pro: It resembles the existing hardware.  The recent Intel CPUs
        adopts 25MHz.
   Con: Require the VMM to emulate the APIC timer at 25MHz.
2. Make the TDX architecture enumerate CPUID leaf 0x15 to configurable
   frequency or not enumerate it.
   Pro: Any APIC bus frequency is allowed.
   Con: Deviates from TDX architecture.
3. Make the TDX guest kernel use 1GHz when it's running on KVM.
   Con: The kernel ignores CPUID leaf 0x15.
4. Change CPUID leaf 0x15 under TDX to report the crystal clock frequency
   as 1 GHz.
   Pro: This has been the virtual APIC frequency for KVM guests for 13
        years.
   Pro: This requires changing only one hard-coded constant in TDX.
   Con: It doesn't work with other VMMs as TDX isn't specific to KVM.
   Con: Core crystal clock frequency is also used to calculate TSC frequency.
   Con: If it is configured to value different from hardware, it will
        break the correctness of INTEL-PT Mini Time Count (MTC) packets
        in TDs.

Testing
-------
Tested on non-TDX host using included kselftest. Host running kernel
with this series applied to "next" branch of
https://github.com/kvm-x86/linux.git

Tested on TDX host and TD using a modified version
of x86/apic.c:test_apic_timer_one_shot() available from
https://github.com/intel/kvm-unit-tests-tdx/blob/tdx/x86/apic.c.
Host running TDX KVM development patches and QEMU with corresponding TDX
changes.
The test needed to be modified to (a) stop any lingering timers before the
test starts, and (b) use CPUID 0x15 in TDX to accurately determine the TSC
and APIC frequencies instead of making 1GHz assumption and use similar
check as the kselftest test introduced in this series (while increasing
the amount with which the frequency is allowed to deviate by 1%).

The core changes made to x86/apic.c:test_apic_timer_one_shot() for this
testing are shown below for reference. Work is in progress to upstream
these modifications.

@@ -477,11 +478,29 @@ static void lvtt_handler(isr_regs_t *regs)
 
 static void test_apic_timer_one_shot(void)
 {
-	uint64_t tsc1, tsc2;
 	static const uint32_t interval = 0x10000;
+	uint64_t measured_apic_freq, tsc2, tsc1;
+	uint32_t tsc_freq = 0, apic_freq = 0;
+	struct cpuid cpuid_tsc = {};
 
 #define APIC_LVT_TIMER_VECTOR    (0xee)
 
+	/*
+	 * CPUID 0x15 is not available in VMX, can use it to obtain
+	 * TSC and APIC frequency for accurate testing
+	 */
+	if (is_tdx_guest()) {
+		cpuid_tsc = raw_cpuid(0x15, 0);
+		tsc_freq = cpuid_tsc.c * cpuid_tsc.b / cpuid_tsc.a;
+		apic_freq = cpuid_tsc.c;
+	}
+	/*
+	   stop already fired local timer
+	   the test case can be negative failure if the timer fired
+	   after installed lvtt_handler but *before*
+	   write to TIMICT again.
+	 */
+	apic_write(APIC_TMICT, 0);
 	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
 
 	/* One shot mode */
@@ -503,8 +522,16 @@ static void test_apic_timer_one_shot(void)
 	 * cases, the following should satisfy on all modern
 	 * processors.
 	 */
-	report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
-	       "APIC LVT timer one shot");
+	if (is_tdx_guest()) {
+		measured_apic_freq = interval * (tsc_freq / (tsc2 - tsc1));
+		report((lvtt_counter == 1) &&
+		       (measured_apic_freq < apic_freq * 102 / 100) &&
+		       (measured_apic_freq > apic_freq * 98 / 100),
+		       "APIC LVT timer one shot");
+	} else {
+		report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
+		"APIC LVT timer one shot");
+	}
 }

[1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/

Isaku Yamahata (1):
  KVM: selftests: Add test for configure of x86 APIC bus frequency

Reinette Chatre (1):
  KVM: selftests: Add x86_64 guest udelay() utility

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   8 +
 .../selftests/kvm/include/x86_64/processor.h  |  15 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  12 +
 .../kvm/x86_64/apic_bus_clock_test.c          | 219 ++++++++++++++++++
 5 files changed, 255 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c

-- 
2.34.1


