Return-Path: <kvm+bounces-55823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D4DB377CE
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 04:32:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59E647C143E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851B8274FEA;
	Wed, 27 Aug 2025 02:32:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDE713C9C4;
	Wed, 27 Aug 2025 02:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756261963; cv=none; b=IRnsdX5xmS+Ll5m3fiwosLEAAhSgZSASbj2V+S4vJ9gputxcwZEbMuG2vqeiIdghOezbjrSogXLolhdFgE7yZueoJ94cYxrnl/kfSLooGlJcfBDZwOAqugDtCdSLkin8YF8sJxkYigAhbFhoUHnIKDiFh331SBjFlJSoOzbb4Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756261963; c=relaxed/simple;
	bh=tM4NryZJs6GQGYE6ScL3QFX0jBO6MscpaIpuSf538RA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D7N6smpYpwNoZ04RHXdlOkWfdACTn6TL4MsVTBrMLv/Y/3At4nuOWhxWY0e/EegLN0biEgwCujT6x2Zs0r9lzkIoCj0+mwNvAMbDsui1bFlesyfzTdeTW5ZBfavZszPP5+6QPQgIM35TNjMQYxYaIdoksDn5kHPvbf9UOhxN2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1690209e82ee11f0b29709d653e92f7d-20250827
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:47738ced-a2cf-4a9c-b6ce-8380b7cf3455,IP:0,U
	RL:0,TC:0,Content:30,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:46aa175651b4578b186727c6037c583c,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850,TC:nil,Content:4|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 1690209e82ee11f0b29709d653e92f7d-20250827
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1728057702; Wed, 27 Aug 2025 10:32:34 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 56943E008FAA;
	Wed, 27 Aug 2025 10:32:33 +0800 (CST)
X-ns-mid: postfix-68AE6E40-207889202
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id C0D71E008FAA;
	Wed, 27 Aug 2025 10:32:14 +0800 (CST)
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
To: "Rafael J . wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Eduardo Valentin <edubezval@gmail.com>,
	Keerthy <j-keerthy@ti.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: zhenglifeng <zhenglifeng1@huawei.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <lenb@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Beata Michalska <beata.michalska@arm.com>,
	Fabio Estevam <festevam@gmail.com>,
	Pavel Machek <pavel@kernel.org>,
	Sumit Gupta <sumitg@nvidia.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	linux-pm@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	imx@lists.linux.dev,
	linux-omap@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [PATCH v2 00/18] cpufreq: use __free() for all cpufreq_cpu_get() references
Date: Wed, 27 Aug 2025 10:31:44 +0800
Message-Id: <20250827023202.10310-1-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This patchset converts all remaining cpufreq users to rely on the
__free(put_cpufreq_policy) annotation for policy references, instead of
calling cpufreq_cpu_put() manually.

Motivation:
- Reduce the chance of reference counting mistakes
- Make the code more consistent with the latest kernel style
- behavior remains the same, but reference counting is now safer=20
  and easier to maintain.

The changes are split into 18 patches as they touch different subsystems
and are maintained by different people. There is no functional change.

V2:
 - Fix compile error in powernv-cpufreq.c
 - Split patch to separate logical changes

Zihuan Zhang (18):
  arm64: topology: Use __free(put_cpufreq_policy) for policy reference
  KVM: x86: Use __free(put_cpufreq_policy) for policy reference
  ACPI: processor: thermal: Use __free(put_cpufreq_policy) for policy
    reference
  cpufreq: brcmstb-avs-cpufreq: Use __free(put_cpufreq_policy) for
    policy reference
  cpufreq: CPPC: Use __free(put_cpufreq_policy) for policy reference
  cpufreq: intel_pstate: Use __free(put_cpufreq_policy) for policy
    reference
  cpufreq: longhaul: Use __free(put_cpufreq_policy) for policy reference
  cpufreq: mediatek: Use __free(put_cpufreq_policy) for policy reference
  cpufreq: powernv: Use __free(put_cpufreq_policy) for policy reference
  cpufreq: s5pv210: Use __free(put_cpufreq_policy) for policy reference
  cpufreq: tegra186: Use __free(put_cpufreq_policy) for policy reference
  PM / devfreq: Use __free(put_cpufreq_policy) for policy reference
  drm/i915: Use __free(put_cpufreq_policy) for policy reference
  cpufreq: powerpc: macintosh: Use __free(put_cpufreq_policy) for policy
    reference
  powercap: dtpm_cpu: Use __free(put_cpufreq_policy) for policy
    reference
  thermal: imx: Use __free(put_cpufreq_policy) for policy reference
  thermal/drivers/ti-soc-thermal:  Use __free(put_cpufreq_policy) for
    policy reference
  PM: EM: Use __free(put_cpufreq_policy) for policy reference

 arch/arm64/kernel/topology.c                  |  9 +++----
 arch/x86/kvm/x86.c                            | 10 ++++----
 drivers/acpi/processor_thermal.c              | 12 +++-------
 drivers/cpufreq/brcmstb-avs-cpufreq.c         |  4 +---
 drivers/cpufreq/cppc_cpufreq.c                |  4 +---
 drivers/cpufreq/intel_pstate.c                |  3 +--
 drivers/cpufreq/longhaul.c                    |  3 +--
 drivers/cpufreq/mediatek-cpufreq.c            |  6 ++---
 drivers/cpufreq/powernv-cpufreq.c             |  7 +++---
 drivers/cpufreq/s5pv210-cpufreq.c             |  3 +--
 drivers/cpufreq/tegra186-cpufreq.c            |  3 +--
 drivers/devfreq/governor_passive.c            | 19 ++++-----------
 drivers/gpu/drm/i915/gt/intel_llc.c           |  3 +--
 drivers/macintosh/windfarm_cpufreq_clamp.c    |  4 +---
 drivers/powercap/dtpm_cpu.c                   | 24 ++++++-------------
 drivers/thermal/imx_thermal.c                 | 13 ++++------
 .../ti-soc-thermal/ti-thermal-common.c        | 12 ++++------
 kernel/power/energy_model.c                   |  7 ++----
 18 files changed, 46 insertions(+), 100 deletions(-)

--=20
2.25.1


