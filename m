Return-Path: <kvm+bounces-66729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5B3CE5903
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2EE98300A327
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0B02E092E;
	Sun, 28 Dec 2025 23:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="McNibI1x"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster3-host10-snip4-10.eps.apple.com [57.103.66.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82553A1E6F
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966136; cv=none; b=pKJ5x0TfV0QOrrlP2ZxxzOtSv81+QeLI7AFKUMx152LcJ8TKHIbzcE55nEE51hg8zpFwFi68Yq3GZEexEI/NKhe39oOJzUaSpWKG/q0YTplNUgUF6xITZQ9PVIGPCEAUMj8cAo/MXyF0D5NBz4qWON/Dkr/SX8LzfGZlawwWuYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966136; c=relaxed/simple;
	bh=+nxe+xN/8y3cAoBMtrdtMhcmPz529Yj5iH0XRJK/4Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lmP87R9227fQIf6Dehcf0IRcddehVCrz+owoLu5CPPuYL/FdBjQ8QPPr2kD20X3ZQBEbXko5b9lV+LYMT7OIokZbU4lqEjW1BHV3YK8cbUTt5sstpE7KV0a0Eqx02KUF1/qCvE+K4RJJ6savHO7Qg4+fSEzLVHn5TGrCzkYikVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=McNibI1x; arc=none smtp.client-ip=57.103.66.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 03069180017B;
	Sun, 28 Dec 2025 23:55:27 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=MXyTfsS3Exr6vWZBJzRakUCy3b3wWprjWQ3CBZSD7XU=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=McNibI1xE8LTCyTCzx6ZOHdHKx0te+UZk7MCcAq8rkAW2VCykxeMaD9cs0cCwQIefabbKogLM0YG7FeJUCtKvVhmzh+Qq6bynlCBG5KQvtUL5r5RXOHTiB2Hlt7gQl9tsGHSLWuJcanVsYipeOoP+2Wl2RuRijtsLJlpS5LCPthedHOF6DBnsRFo2LzC5pYCcFcjX1kgS+52deP6WEliMnBc5iVYYUxrzmQxKRCYTCAieWxmPLKKqlO5F9rPURv5ue5Ann/ufC7WHAPt7fNiE2q34wKk6oqhKAzomlzG0wccSFAyA4vuA85BRufjJL59XMPbkM2YKuH1GQlIwx95uA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id CC9411800746;
	Sun, 28 Dec 2025 23:54:35 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org,
	mohamed@unpredictable.fr
Cc: Alexander Graf <agraf@csgraf.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	qemu-arm@nongnu.org,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v12 00/28] WHPX support for Arm
Date: Mon, 29 Dec 2025 00:53:54 +0100
Message-ID: <20251228235422.30383-1-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Authority-Info: v=2.4 cv=RLy+3oi+ c=1 sm=1 tr=0 ts=6951c370 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=2CSUmbMKgiS_FIm3Z54A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: CV5DIS3fhEksdZvl5R936elFk7UBQMN9
X-Proofpoint-GUID: CV5DIS3fhEksdZvl5R936elFk7UBQMN9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX5pIlQ5E7T2Ps
 RnPb9Wq85tLyoOOp4QJt0d/pgNYogYAjyIfSnJXi7ArqOakcMwmHJT+dmP+dpx/IyOwH5xCxzyD
 dytHIkdtegdwwlyjpbobcjJH1E/Ddeud13kBlLDBiFvEz5YtK7wMdEAiH7GTnB5vgrbKnCGdQ49
 Xoo5BeSFW71T0xLJwo2r1LcwrvRUiwjNsocN3JiIoiLl85iV5gjliO+Z3H4C576z2tsEexqBoX+
 pqzK7dz+bXK1Enj4HzrAW54xg1VNA9whMje5Z++ha5JsCd8XlPF3KYTGfrQug8t0oj8NicV8ARw
 6lN9sbCvV53JFUcpdKj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 clxscore=1030 suspectscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 classifier=spam authscore=0
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512280223
X-JNJ: AAAAAAABi+H8Fi9psbtbOh1Dir5rcfRaDq0J39Ehe2az8oXy3IPRpuJhXC4ZIclNHcDCRrdKLIH2AQMX9K8tnVVbxP6ewjES8ZynHWRoNtA+lu7FQ8pr8px2v1mDsKHbKwLQENUPAkGmlWdcXbwZVpTEQrHEOgItb+suVPlxoL+MdMbttidLWHsAhjkVCw7coJ4DNf9Qea0Ccnp0yrdn1ELalm7Y9T9hOa8vjITbnbND3rJr3FIwMxfR6M/LFFHvoGiA/SpCEMxUwHPebUw5KmyLi2kh76VVBNc0vcmQxvwEes7xPOh6bC6Y3EmrFOsD/AjkpO6+Q+XNoWj2wecuycaYwFqLhJ51XeM+8gJzEp6iLMHy20oRASKVvnWEyvYSckkvDRb39FEKCwi6e0awaRsvT/vSYYTCEMmd9+oSJU277cZDMWhUfFIx6e4dKzZ8mxTagas/95/l24CbxRueHahFTrwmq8PrXqPC4aSofAhtFLoV47vV4SJIveuuM4EElLQJhq/S0US2R69akrXo/7jkozJuxK7Tku0U3B4Wee0uYUBsETm2/PaHk4RpN8UZliXnMj7obLbOkj/bNOBNzJW7UyK8nA1Jh/UH0sFk2gqW8pt0dV6E0JB+494oBeubaLUCLCdwnlNsyRIbyJsIVK09N2keDZS2LKyr4ZpFof8vSNQ9fp/rWFo48JhA5g8HhzRbZAfh+2BWCXNoKqBpLr/qKabWJa2pAfUEBD5bJeK9J2fRhO5VJZoNM3ft+sfVRTY6BP/JpW9ZKenj39aEqukngMosIecqr0ywd84jERLx3pE3G0TohkaXIH9BRr+8e6eePrl0Yp5Dks9tnVHGQEN+ADvl8vXWQuusoaMiyZs948fwXLJ8/s4p4tNwVbzEe4aklAGVmmxk794C/gLPxsVlZO7umv9+n6BDN0Gc2mh8IUBZTUXjiT93KTkZa+nnfnRHh67eTDgQC1NXD6g=

Link to branch: https://github.com/mediouni-m/qemu whpx (tag for this submission: whpx-v12)

Missing features:
- VM save-restore: interrupt controller state notably
- SVE register sync: I didn't have the time to test this on pre-release hardware with SVE2 support yet.
So SVE2 is currently masked for VMs when running this.

Known bugs:
- U-Boot still doesn't work (hangs when trying to parse firmware) but EDK2 does.

Note:

"target/arm/kvm: add constants for new PSCI versions" taken from the mailing list.

"accel/system: Introduce hwaccel_enabled() helper" taken from the mailing list, added here
as part of this series to make it compilable as a whole.

"hw/arm: virt: add GICv2m for the case when ITS is not available" present in both the HVF
vGIC and this series.

"hw: arm: virt-acpi-build: add temporary hack to match existing behavior" is not proper" is
for ACPI stability but what is the right approach to follow there?

And another note:

Seems that unlike HVF there isn't direct correspondence between WHv registers and the actual register layout,
so didn't do changes there to a sysreg.inc.

Updates since v11:
- Address review comments
- Rebase up to latest staging
- Switch to assuming Qemu 11.0 as the newest machine model

Updates since v10:
- Bring forward to latest Qemu
- Fix a typo in the GICv3+GICv2m PR

Updates since v9:
- Adding partition reset on the reboot side of things...

Updates since v8:
- v9 and v8 were not submitted properly because of my MTA not behaving, sorry for that.
- v10 introduces a new argument, -M msi=, to handle MSI-X configuration more granularly.
- That surfaced what I think is a bug (?), with vms->its=1 on GICv2 configurations... or I did understand everything wrong.
- Oopsie due to email provider ratelimiting.

Updates since v7:
- Oops, fixing bug in "hw/arm: virt: cleanly fail on attempt to use the platform vGIC together with ITS".
Other commits are unchanged.

Updates since v6:
- Rebasing
- Fixing a bug in the GICv3+GICv2m case for ACPI table generation
- getting rid of the slots infrastructure for memory management
- Place the docs commit right after the "cleanly fail on attempt to run GICv3+GICv2m on an unsupported config" one
as that's what switches ITS to a tristate.
- Fixing a build issue when getting rid of the arch-specific arm64 hvf-stub.

Updates since v5:
- Rebasing
- Address review comments
- Rework ITS enablement to a tristate
- On x86: move away from deprecated APIs to get/set APIC state

Updates since v4:
- Taking into account review comments
- Add migration blocker in the vGICv3 code due to missing interrupt controller save/restore
- Debug register sync

Updates since v3:
- Disabling SVE on WHPX
- Taking into account review comments incl:

- fixing x86 support
- reduce the amount of __x86_64__ checks in common code to the minimum (winhvemulation)
which can be reduced even further down the road.
- generalize get_physical_address_range into something common between hvf and whpx

Updates since v2:
- Fixed up a rebase screwup for whpx-internal.h
- Fixed ID_AA64ISAR1_EL1 and ID_AA64ISAR2_EL1 feature probe for -cpu host
- Switched to ID_AA64PFR1_EL1/ID_AA64DFR0_EL1 instead of their non-AA64 variant

Updates since v1:
- Shutdowns and reboots
- MPIDR_EL1 register sync
- Fixing GICD_TYPER_LPIS value
- IPA size clamping
- -cpu host now implemented

Mohamed Mediouni (26):
  qtest: hw/arm: virt: skip ACPI test for ITS off
  hw/arm: virt: add GICv2m for the case when ITS is not available
  tests: data: update AArch64 ACPI tables
  hw/arm: virt: cleanly fail on attempt to use the platform vGIC
    together with ITS
  hw: arm: virt: rework MSI-X configuration
  hw: arm: virt-acpi-build: add temporary hack to match existing
    behavior
  docs: arm: update virt machine model description
  whpx: Move around files before introducing AArch64 support
  whpx: reshuffle common code
  whpx: ifdef out winhvemulation on non-x86_64
  whpx: common: add WHPX_INTERCEPT_DEBUG_TRAPS define
  hw, target, accel: whpx: change apic_in_platform to kernel_irqchip
  whpx: interrupt controller support
  whpx: add arm64 support
  whpx: change memory management logic
  target/arm: cpu: mark WHPX as supporting PSCI 1.3
  whpx: arm64: clamp down IPA size
  hw/arm, accel/hvf, whpx: unify get_physical_address_range between WHPX
    and HVF
  whpx: arm64: implement -cpu host
  target/arm: whpx: instantiate GIC early
  whpx: arm64: gicv3: add migration blocker
  whpx: enable arm64 builds
  whpx: apic: use non-deprecated APIs to control interrupt controller
    state
  whpx: arm64: check for physical address width after WHPX availability
  whpx: arm64: add partition-wide reset on the reboot path
  MAINTAINERS: update the list of maintained files for WHPX

Philippe Mathieu-Daudé (1):
  accel/system: Introduce hwaccel_enabled() helper

Sebastian Ott (1):
  target/arm/kvm: add constants for new PSCI versions

 MAINTAINERS                                   |    6 +
 accel/hvf/hvf-all.c                           |    7 +-
 accel/meson.build                             |    1 +
 accel/stubs/whpx-stub.c                       |    1 +
 accel/whpx/meson.build                        |    7 +
 {target/i386 => accel}/whpx/whpx-accel-ops.c  |    6 +-
 accel/whpx/whpx-common.c                      |  540 +++++++++
 docs/system/arm/virt.rst                      |   13 +-
 hw/arm/virt-acpi-build.c                      |   16 +-
 hw/arm/virt.c                                 |  140 ++-
 hw/i386/x86-cpu.c                             |    4 +-
 hw/intc/arm_gicv3_common.c                    |    3 +
 hw/intc/arm_gicv3_whpx.c                      |  249 ++++
 hw/intc/meson.build                           |    1 +
 include/hw/arm/virt.h                         |    8 +-
 include/hw/core/boards.h                      |    3 +-
 include/hw/intc/arm_gicv3_common.h            |    3 +
 include/system/hvf_int.h                      |    5 +
 include/system/hw_accel.h                     |   13 +
 .../whpx => include/system}/whpx-accel-ops.h  |    4 +-
 include/system/whpx-all.h                     |   20 +
 include/system/whpx-common.h                  |   26 +
 .../whpx => include/system}/whpx-internal.h   |   25 +-
 include/system/whpx.h                         |    5 +-
 meson.build                                   |   20 +-
 target/arm/cpu.c                              |    3 +
 target/arm/cpu64.c                            |   17 +-
 target/arm/hvf-stub.c                         |   20 -
 target/arm/hvf/hvf.c                          |    6 +-
 target/arm/hvf_arm.h                          |    3 -
 target/arm/kvm-consts.h                       |    2 +
 target/arm/meson.build                        |    2 +-
 target/arm/whpx/meson.build                   |    5 +
 target/arm/whpx/whpx-all.c                    | 1020 +++++++++++++++++
 target/arm/whpx/whpx-stub.c                   |   15 +
 target/arm/whpx_arm.h                         |   17 +
 target/i386/cpu-apic.c                        |    2 +-
 target/i386/hvf/hvf.c                         |   11 +
 target/i386/whpx/meson.build                  |    1 -
 target/i386/whpx/whpx-all.c                   |  569 +--------
 target/i386/whpx/whpx-apic.c                  |   48 +-
 tests/data/acpi/aarch64/virt/APIC.its_off     |  Bin 164 -> 188 bytes
 42 files changed, 2219 insertions(+), 648 deletions(-)
 create mode 100644 accel/whpx/meson.build
 rename {target/i386 => accel}/whpx/whpx-accel-ops.c (96%)
 create mode 100644 accel/whpx/whpx-common.c
 create mode 100644 hw/intc/arm_gicv3_whpx.c
 rename {target/i386/whpx => include/system}/whpx-accel-ops.h (92%)
 create mode 100644 include/system/whpx-all.h
 create mode 100644 include/system/whpx-common.h
 rename {target/i386/whpx => include/system}/whpx-internal.h (88%)
 delete mode 100644 target/arm/hvf-stub.c
 create mode 100644 target/arm/whpx/meson.build
 create mode 100644 target/arm/whpx/whpx-all.c
 create mode 100644 target/arm/whpx/whpx-stub.c
 create mode 100644 target/arm/whpx_arm.h

-- 
2.50.1 (Apple Git-155)


