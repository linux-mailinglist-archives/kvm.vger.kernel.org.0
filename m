Return-Path: <kvm+bounces-53276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8881B0F964
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C4CD169616
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C13229B13;
	Wed, 23 Jul 2025 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UjtK9F7w";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MStWZygL"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAF52222A7;
	Wed, 23 Jul 2025 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753292211; cv=none; b=e8URht4kKaWoOnDgnDM8C3BKdXFSihLsOBJ46EWT66FOtBtcooto0PjLwgpch3EUOD55/cV6opSdc3xMJhhJt8eCe3h/YJg9aP9xG6b8Ojqar6ylKCylk/LFQTLN9JSPElqVyl9f6oJwrDZFzpqQgrGVyhNHfSBMfDfjZJCNM8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753292211; c=relaxed/simple;
	bh=VzX3sfnWfk98H4v6dG8+sWCT/7se1UzSQrgiTmFOdog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b4UplqgWF+Mx0MjQq2NU5xXsxQRSnUYOXOyL/zRhqCDmBlRUfEgPWb0hNBev2ll4Hp7Rd/twKQ9HtiyuhJo0TCNjdeiW4HR7GhKx6vTiHN9Mukpno70Ag6y2drKoxgzZkcnlvNOU2CCi+gwvS0m44N80tXPHl/evlKcRxdj3RXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UjtK9F7w; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MStWZygL; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753292207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jSuKHlqSbUOQ+ZegzC3pG0Efo47TugY4O4WwuY1A7HM=;
	b=UjtK9F7wLkNVvtuyxG2XNQBCI44YmgLXwTylyOkYqjKmQ+qCAwkjALb0dpJMdLnHDhJKdy
	Wigt/FTs66KQY7QYWo3kK5e2y516tHERntmZqFndZNdhlig2gv2sadJKWVCg0TlL0G86vE
	VyA6pZ3FAycHLr5zUwJxM7F+L1ixE5Lxtx2Ht9B2SRxiIT7fl62MOHSd2MP53j0oEIuj2v
	fA99GHNz1H5O0IKVkfBE4VHgpTaTzJZWTs7QWb8R4aKRscSfJ1nD0AQWfl2z5c0KDjENyg
	xd1aynDqRPKPG3rHU8fp+2R0AeznEXpSUYKbekdrl7aEshWXC45oO2Th5W+4UQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753292207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jSuKHlqSbUOQ+ZegzC3pG0Efo47TugY4O4WwuY1A7HM=;
	b=MStWZygLBc4XuBWDdPzdF/rOSQjccExpisFt7/FP7IAtpvWBUYJHPiUyiZssbLoSM7ItCv
	0RzU4QFcmBaa2TBQ==
To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: [PATCH v4 0/4] x86: Disentangle <asm/processor.h> dependency on CPUID headers
Date: Wed, 23 Jul 2025 19:36:39 +0200
Message-ID: <20250723173644.33568-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This series stops <asm/processor.h> from including <asm/cpuid/api.h>
since there is no code at the former which needs the latter.

For this to work, modify all CPUID call sites that implicitly include the
CPUID <asm/cpuid/api.h> header to explicitly include it instead

This allows the CPUID API header to include <asm/processor.h> without
inducing a circular dependency — which is needed for the upcoming CPUID
model and parser.


Changelog v4
~~~~~~~~~~~~

Per feedback at:

    https://lore.kernel.org/lkml/aH-dqcMWj3cFDos2@google.com

Remove the two patches doing the include lines alphabetical and section
reorderings.

I leave it to the maintainers to merge this series or version 3 of it:
highest priority is to keep the CPUID parser work ongoing (by
disentangling the headers…)


Changelog v3
~~~~~~~~~~~~

( [PATCH v3 0/6] x86: Disentangle <asm/processor.h> dependency on CPUID headers
  https://lore.kernel.org/lkml/20250722065448.413503-1-darwi@linutronix.de )

* For the KVM CPUID call sites:

    arch/x86/kvm/mmu/mmu.c
    arch/x86/kvm/svm/sev.c
    arch/x86/kvm/svm/svm.c
    arch/x86/kvm/vmx/pmu_intel.c
    arch/x86/kvm/vmx/sgx.c
    arch/x86/kvm/vmx/vmx.c

  Let them explicitly include <asm/cpuid/api.h> instead of letting their
  internal arch/x86/kvm/cpuid.h header does it.  The latter header does
  not need the former, so making it include a itnot just for the sake of
  its call sites was not correct.

* While at it, modify /all/ call sites that use the CPUID API to
  explicitly include <asm/cpuid/api.h>.

  Previous iterations only modified the CPUID call sites which implicitly
  included the CPUID headers through <asm/processor.h>.  Since we're at
  it anyway, there's no reason not to complete the task across the whole
  kernel tree.

  Thus, also convert below arch/x86/ sites:

    arch/x86/kernel/apic/apic.c
    arch/x86/kernel/cpu/sgx/driver.c
    arch/x86/kernel/cpu/vmware.c
    arch/x86/kernel/jailhouse.c
    arch/x86/kernel/kvm.c
    arch/x86/mm/pti.c
    arch/x86/pci/xen.c
    arch/x86/xen/enlighten_hvm.c
    arch/x86/xen/pmu.c
    arch/x86/xen/time.c

  and below drivers/ sites:

    drivers/gpu/drm/gma500/mmu.c
    drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
    drivers/ras/amd/fmpm.c
    drivers/virt/acrn/hsm.c
    drivers/xen/events/events_base.c
    drivers/xen/grant-table.c
    drivers/xen/xenbus/xenbus_xs.c

  to explicitly include the CPUID API header.

* Fix the v2 i386 compilation error:

    https://lore.kernel.org/x86-cpuid/202507150403.hKKg9xjJ-lkp@intel.com

  by making drivers/char/agp/efficeon-agp.c explicitly include the CPUID
  API.

* Make sure that an "i386 allyesconfig" build is successful this time.

* Based on v6.16-rc7.


Changelog v2
~~~~~~~~~~~~

( [PATCH v2 0/6] x86: Disentangle <asm/processor.h> dependency on CPUID headers
  https://lore.kernel.org/lkml/20250709203033.90125-1-darwi@linutronix.de )

Remove the <asm/cpuid/types.h> include from <asm/processor.h> since only
the upcoming CPUID model needed that — not current mainline code.  That
include was kept in v1, by mistake, because this series was originally
part of the CPUID model patch queue.

Due to the CPUID types include remove above, let
arch/x86/kvm/reverse_cpuid.h include <asm/cpuid/types.h> since it
references the CPUID_EAX..EDX macros.  At this series v1, the KVM header
implicitly included such CPUID types header through <asm/cpufeature.h>,
through <asm/processor.h>.

Drop the "x86/cpuid: Rename cpuid_leaf()/cpuid_subleaf() APIs" patch from
this series.  After a second look, it should be part of the CPUID model
PQ instead.


Changelog v1
~~~~~~~~~~~~

( [PATCH v1 0/7] x86: Disentangle <asm/processor.h> dependency on CPUID APIs
  https://lore.kernel.org/lkml/20250612234010.572636-1-darwi@linutronix.de )

This series avoids including the full CPUID API from <asm/processor.h>.
That header only needs the CPUID data types and not the full API.

Let <asm/processor.h> include <asm/cpuid/types.h> instead of
<asm/cpuid/api.h>.

Modify all CPUID call sites which implicitly included the CPUID API
though <asm/processor.h> to explicitly include <asm/cpuid/api.h> instead.

This work prepares for an upcoming v4 of the CPUID model:

    [PATCH v3 00/44] x86: Introduce a centralized CPUID data model
    https://lore.kernel.org/lkml/20250612234010.572636-1-darwi@linutronix.de

where <asm/cpuid/api.h> needs to include <asm/processor.h>, thus creating
a circular dependency if not resolved beforehand…  Patches 1->19 of the
v3 above had parts of this series circular dependency disentanglement.

Per Boris' remarks above, merge the header includes reorderings into two
patches only: one patch for x86 and one for drivers.

The 0-day bot x86-32 compilation error:

    Re: [PATCH v3 41/44] x86/cpu: <asm/processor.h>: Do not include CPUID…
    https://lore.kernel.org/lkml/202506132039.imS2Pflx-lkp@intel.com

is also fixed in this series.

Beside the call sites converted at CPUID model v3 above, this series also
switches below files:

    arch/x86/kernel/cpu/microcode/core.c
    arch/x86/kernel/cpu/microcode/intel.c
    arch/x86/kernel/cpu/mshyperv.c
    drivers/cpufreq/longrun.c
    drivers/cpufreq/powernow-k7.c
    drivers/cpufreq/powernow-k8.c

to explicitly include <asm/cpuid/api.h>.

Based on v6.16-rc5.

Thanks!


8<----

Ahmed S. Darwish (4):
  x86/cpuid: Remove transitional <asm/cpuid.h> header
  ASoC: Intel: avs: Include CPUID header at file scope
  treewide: Explicitly include the x86 CPUID headers
  x86/cpu: <asm/processor.h>: Do not include the CPUID API header

 arch/x86/boot/compressed/pgtable_64.c         |  1 +
 arch/x86/boot/startup/sme.c                   |  1 +
 arch/x86/coco/tdx/tdx.c                       |  1 +
 arch/x86/events/amd/core.c                    |  2 ++
 arch/x86/events/amd/ibs.c                     |  1 +
 arch/x86/events/amd/lbr.c                     |  2 ++
 arch/x86/events/amd/power.c                   |  3 +++
 arch/x86/events/amd/uncore.c                  |  1 +
 arch/x86/events/intel/core.c                  |  1 +
 arch/x86/events/intel/lbr.c                   |  1 +
 arch/x86/events/zhaoxin/core.c                |  1 +
 arch/x86/include/asm/acrn.h                   |  2 ++
 arch/x86/include/asm/cpuid.h                  |  8 ------
 arch/x86/include/asm/microcode.h              |  1 +
 arch/x86/include/asm/processor.h              |  1 -
 arch/x86/include/asm/xen/hypervisor.h         |  1 +
 arch/x86/kernel/apic/apic.c                   |  1 +
 arch/x86/kernel/cpu/amd.c                     |  1 +
 arch/x86/kernel/cpu/centaur.c                 |  1 +
 arch/x86/kernel/cpu/hygon.c                   |  1 +
 arch/x86/kernel/cpu/mce/core.c                |  1 +
 arch/x86/kernel/cpu/mce/inject.c              |  1 +
 arch/x86/kernel/cpu/microcode/amd.c           |  1 +
 arch/x86/kernel/cpu/microcode/core.c          |  1 +
 arch/x86/kernel/cpu/microcode/intel.c         |  1 +
 arch/x86/kernel/cpu/mshyperv.c                |  1 +
 arch/x86/kernel/cpu/resctrl/core.c            |  1 +
 arch/x86/kernel/cpu/resctrl/monitor.c         |  1 +
 arch/x86/kernel/cpu/scattered.c               |  1 +
 arch/x86/kernel/cpu/sgx/driver.c              |  3 +++
 arch/x86/kernel/cpu/sgx/main.c                |  3 +++
 arch/x86/kernel/cpu/topology_amd.c            |  1 +
 arch/x86/kernel/cpu/topology_common.c         |  1 +
 arch/x86/kernel/cpu/topology_ext.c            |  1 +
 arch/x86/kernel/cpu/transmeta.c               |  3 +++
 arch/x86/kernel/cpu/vmware.c                  |  1 +
 arch/x86/kernel/cpu/zhaoxin.c                 |  1 +
 arch/x86/kernel/cpuid.c                       |  1 +
 arch/x86/kernel/jailhouse.c                   |  1 +
 arch/x86/kernel/kvm.c                         |  1 +
 arch/x86/kernel/paravirt.c                    |  1 +
 arch/x86/kvm/mmu/mmu.c                        |  1 +
 arch/x86/kvm/mmu/spte.c                       |  1 +
 arch/x86/kvm/reverse_cpuid.h                  |  2 ++
 arch/x86/kvm/svm/svm.c                        |  1 +
 arch/x86/kvm/vmx/pmu_intel.c                  |  1 +
 arch/x86/kvm/vmx/sgx.c                        |  1 +
 arch/x86/kvm/vmx/vmx.c                        |  1 +
 arch/x86/mm/pti.c                             |  1 +
 arch/x86/pci/xen.c                            |  2 +-
 arch/x86/xen/enlighten_hvm.c                  |  1 +
 arch/x86/xen/pmu.c                            |  1 +
 arch/x86/xen/time.c                           |  1 +
 drivers/char/agp/efficeon-agp.c               |  1 +
 drivers/cpufreq/longrun.c                     |  1 +
 drivers/cpufreq/powernow-k7.c                 |  2 +-
 drivers/cpufreq/powernow-k8.c                 |  1 +
 drivers/cpufreq/speedstep-lib.c               |  1 +
 drivers/firmware/efi/libstub/x86-5lvl.c       |  1 +
 drivers/gpu/drm/gma500/mmu.c                  |  2 ++
 drivers/hwmon/fam15h_power.c                  |  1 +
 drivers/hwmon/k10temp.c                       |  2 ++
 drivers/hwmon/k8temp.c                        |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  1 +
 drivers/ras/amd/fmpm.c                        |  1 +
 drivers/thermal/intel/intel_hfi.c             |  1 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |  1 +
 drivers/virt/acrn/hsm.c                       |  1 +
 drivers/xen/events/events_base.c              |  1 +
 drivers/xen/grant-table.c                     |  1 +
 drivers/xen/xenbus/xenbus_xs.c                |  3 +++
 sound/soc/intel/avs/tgl.c                     | 25 ++++++++++++-------
 72 files changed, 101 insertions(+), 20 deletions(-)
 delete mode 100644 arch/x86/include/asm/cpuid.h

base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
-- 
2.50.1


