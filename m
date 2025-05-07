Return-Path: <kvm+bounces-45677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7BEAAD29E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27C84467682
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8551914A605;
	Wed,  7 May 2025 01:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iA/Z5IJf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEAB4B1E4A;
	Wed,  7 May 2025 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580885; cv=none; b=YjilfjTkSbmrO8oby8i3Sg2SBk4aIFYjhdCzVftxF7oxsJeNumltRlzEO+7dLcoqBgWg7w+JfK3WWRzjnfLZe9SzwIKSGb+hMzvQ/uGBN/xU3QPvby2brTS96CGAQOLEYbjlIBSgz8GoNHOkjZWk0Ri2B7Zjnw1FzlHJo4gQHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580885; c=relaxed/simple;
	bh=/lb3FGJmSYv11H6gc91EmfFIcEdAfBMEor2yOP8f4kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ad9gHBXqcYDsm8BCmDtm356hstl5UVvgEmnHR9P0DN0BT/nVEqFujn5LVsbJ7BFz6nxYkWpSrk6AJRXjbAh0c97aV4HU7vg54YblCz0vjf5Tyi3RG6k7w1Zjz6jL66jWsf+R2f99Lwe7o0wcFOEQeXjNaeHTwb6APgfHItST5cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iA/Z5IJf; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580883; x=1778116883;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/lb3FGJmSYv11H6gc91EmfFIcEdAfBMEor2yOP8f4kQ=;
  b=iA/Z5IJfTTl93tFG72dojgq5mDcvabymTR7dqrPgdZIBMQnbU4AS7sI2
   W6tO+M6rhzRVTF+ybMg9d4SjTS/SMmj7fMvFR5OESR2oWJnZra56hAB3K
   iVagxOSoFQWT4TgYLw6JUhahRZFRl44wrWI3crNx9hvWXsziBy0mHKHHr
   EyWaGcp7fhoegGWsv9/lYUpfle4wpZjAixodExpHT6goEaA+gYn/IjYnA
   GFcotDXVgrKFX728IGoFscZSyYQQJSCjnE4kwbXzhj7GNH7pu4nBf9sds
   0pIFcrZvDG3qXolsYp7VcCKHoC993CJ/78BmyC9R1tWJnDum0a4EJGS/a
   w==;
X-CSE-ConnectionGUID: 46wdAy0aTVWxhBSfz60t8g==
X-CSE-MsgGUID: Y0spb0IcTeW6FgywdcrFyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47383880"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47383880"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:21 -0700
X-CSE-ConnectionGUID: b18LCGHVSNiUPo+e119PPw==
X-CSE-MsgGUID: egZtneK8TLGHbV8WqcwvEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808735"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:20 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v5 0/9] x86: Add support for NMI-source reporting with FRED
Date: Tue,  6 May 2025 18:21:36 -0700
Message-ID: <20250507012145.2998143-1-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduction
============
NMI-source reporting with FRED [1] provides a new mechanism for
identifying the source of NMIs. As part of the FRED event delivery
framework, a 16-bit vector bitmap is provided that identifies one or
more sources that caused the NMI.

Using the source bitmap, the kernel can precisely run the relevant NMI
handlers instead of polling the entire NMI handler list. Additionally,
the source information would be invaluable for debugging misbehaving
handlers and unknown NMIs.

Changes since the last version
==============================
v4: https://lore.kernel.org/lkml/20240709143906.1040477-1-jacob.jun.pan@linux.intel.com/

Apart from the change of personnel, the patches include the following major
changes:

 * Reorder the patches to have the infrastructure changes precede the
   feature addition. (Sean)
 * Use a simplified encoding mechanism for NMI-source vectors. (Sean)
 * Get rid of the alternate NMI vector priority scheme. (below)
 * Simplify NMI handling logic with source bitmap. (below)

Existing NMI handling code already has a priority mechanism for the NMI
handlers, with CPU-specific (NMI_LOCAL) handlers executed first followed
by platform NMI handlers and unknown NMI (NMI_UNKNOWN) handlers being
last. Within each of these NMI types, the handlers registered with
NMI_FLAG_FIRST are given priority.

It is essential that new NMI-source handling follows the same scheme to
maintain consistent behavior with and without NMI-source. If there is a
need for a more granular priority scheme, it should be introduced at the
generic NMI handler level instead of assigning priorities to NMI-source
vectors.

This design choice leads to a simplification in the NMI handling logic
as well. It is now possible to get rid of the complexity introduced by a
new handler lookup table as well as the partial bitmap handling logic.
The updated code (patch 5) is significantly less intrusive and easier to
maintain.

Day in the life of an NMI-source vector
=======================================
A brief overview of how NMI-source vectors are used:

// Allocate a static source vector at compile time
#define NMIS_VECTOR_TEST	1

// Register an NMI handler with the vector
register_nmi_handler(NMI_LOCAL, test_handler, 0, "nmi_test", NMIS_VECTOR_TEST);

// Generate an NMI with the source vector using NMI encoded delivery
__apic_send_IPI_mask(cpumask, APIC_DM_NMI | NMIS_VECTOR_TEST);

// Handle an NMI with or without the source information (oversimplified)
source_bitmap = fred_event_data(regs);
if (!source_bitmap || (source_bitmap & BIT(NMIS_VECTOR_TEST)))
        test_handler();

// Unregister handler along with the vector
unregister_nmi_handler(NMI_LOCAL, "nmi_test");

Patch structure
===============
The patches are based on tip:x86/nmi because they depend on the NMI
cleanup series merged earlier [2].

Patch 1-2: Prepare FRED/KVM and enumerate NMI-source reporting
Patch 3-5: Register and handle NMI-source vectors 
Patch 6-8: APIC changes to generate NMIs with vectors
Patch   9: Improve trace and debug with NMI-source information

Many thanks to Sean Christopherson, Xin Li, H. Peter Anvin, Andi Kleen,
Tony Luck, Kan Liang, Jacob Pan Jun, Zeng Guang and others for their
contributions, reviews and feedback.

Future work / Opens
===================
I am considering a few additional changes that would be valuable for
enhancing NMI handling support. Any feedback, preferences or suggestions
on the following would be helpful.

Assigning more NMI-source vectors
---------------------------------
The current patches assign NMI vectors to a limited number of sources.
The microcode rendezvous and crash reboot code use NMI but do not go
through the typical register_nmi_handler() path. Their handling is
special-cased in exc_nmi(). To isolate blame and improve debugging, it
would be useful to assign vectors to them, even if the vectors are
ignored during handling.

Other NMI sources, such as GHES and Platform NMIs, can also be assigned
vectors to speed up their NMI handling and improve isolation. However,
this would require a software/hardware agreement on vector reservation
and usage. Such an endeavor is likely not worth the effort.

Explicitly enabling NMIs
------------------------
HPA brought up the idea [3] of explicitly enabling NMIs only when the
kernel is ready to take them. With FRED, if we enter the kernel with
NMIs disabled, they could remain disabled until returning back to
userspace.

DebugFS support
---------------
Currently, the kernel has counters for unknown NMIs, swallowed NMIs and
other NMI handling data. However, there is no easy way to access that.
To identify issues that happen over a longer timeframe, it might be
useful to add DebugFS support for NMI statistics.

KVM support
-----------
The NMI-source feature can be useful for perf users and other NMI use
cases in guest VMs. Exposing NMI-source to guests once FRED support is
in place should be relatively easier. The prototype code for this is
under evaluation.

Links
=====
[1]: Chapter 9, https://www.intel.com/content/www/us/en/content-details/819481/flexible-return-and-event-delivery-fred-specification.html
[2]: https://lore.kernel.org/lkml/20250327234629.3953536-1-sohil.mehta@intel.com/
[3]: https://lore.kernel.org/lkml/F5D36889-A868-46D2-A678-8EE26E28556D@zytor.com/

Jacob Pan (1):
  perf/x86: Enable NMI-source reporting for perfmon

Sohil Mehta (7):
  x86/cpufeatures: Add the CPUID feature bit for NMI-source reporting
  x86/nmi: Extend the registration interface to include the NMI-source
    vector
  x86/nmi: Assign and register NMI-source vectors
  x86/nmi: Add support to handle NMIs with source information
  x86/nmi: Prepare for the new NMI-source vector encoding
  x86/nmi: Enable NMI-source for IPIs delivered as NMIs
  x86/nmi: Include NMI-source information in tracepoint and debug prints

Zeng Guang (1):
  x86/fred, KVM: VMX: Pass event data to the FRED entry point from KVM

 arch/x86/entry/entry_64_fred.S      |  2 +-
 arch/x86/events/amd/ibs.c           |  2 +-
 arch/x86/events/core.c              |  6 ++--
 arch/x86/events/intel/core.c        |  6 ++--
 arch/x86/include/asm/apic.h         | 38 ++++++++++++++++++++++
 arch/x86/include/asm/apicdef.h      |  2 +-
 arch/x86/include/asm/cpufeatures.h  |  1 +
 arch/x86/include/asm/fred.h         |  9 +++---
 arch/x86/include/asm/nmi.h          | 37 ++++++++++++++++++++-
 arch/x86/kernel/apic/hw_nmi.c       |  5 ++-
 arch/x86/kernel/apic/ipi.c          |  4 +--
 arch/x86/kernel/apic/local.h        | 24 +++++++-------
 arch/x86/kernel/cpu/cpuid-deps.c    |  1 +
 arch/x86/kernel/cpu/mce/inject.c    |  4 +--
 arch/x86/kernel/cpu/mshyperv.c      |  3 +-
 arch/x86/kernel/kgdb.c              |  8 ++---
 arch/x86/kernel/kvm.c               |  9 +-----
 arch/x86/kernel/nmi.c               | 50 ++++++++++++++++++++++++++++-
 arch/x86/kernel/nmi_selftest.c      |  9 +++---
 arch/x86/kernel/smp.c               |  6 ++--
 arch/x86/kvm/vmx/vmx.c              |  5 +--
 arch/x86/platform/uv/uv_nmi.c       |  4 +--
 drivers/acpi/apei/ghes.c            |  2 +-
 drivers/char/ipmi/ipmi_watchdog.c   |  3 +-
 drivers/edac/igen6_edac.c           |  3 +-
 drivers/thermal/intel/therm_throt.c |  2 +-
 drivers/watchdog/hpwdt.c            |  6 ++--
 include/trace/events/nmi.h          | 13 +++++---
 28 files changed, 190 insertions(+), 74 deletions(-)


base-commit: f2e01dcf6df2d12e86c363ea9c37d53994d89dd6
-- 
2.43.0


