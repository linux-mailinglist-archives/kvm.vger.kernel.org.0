Return-Path: <kvm+bounces-26063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3993C970197
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 12:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D9C4284F78
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 10:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C97158A30;
	Sat,  7 Sep 2024 10:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="BwPdePv7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ax7CXzye"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh3-smtp.messagingengine.com (fhigh3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6714BBE6C;
	Sat,  7 Sep 2024 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725704231; cv=none; b=p1Q0GbckF65+cFqn6jay6Jt+FfK8kappBh+fYywM0Mu3m6b1wHS4pHfQcK8nQWp9ytbKJm9gpXGkDGzSZTxXFHTkWYzrisuwXvWLr8R4igKrFnmESc4Wrr/UHwT30TdXtN+wci7O+UA4oRIJKWx/OpHIMAlbpoq/RtV3mWagv9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725704231; c=relaxed/simple;
	bh=+DyY6GPIk1WDZOgKzGI2dYuz/zLq3vDNhNWL4C4Q6BI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=d8SV4PZ12oS41GOGtEurB9cehcqeB4gRTLDpmmdbhqAH4Ql1zBCIbGcFsZ1E0Rx4nE6o42cfHMM2Aci0+0JRaSjSVu4K4sBosYtyOCn0gc1yOP9ABe+Dhs72N3O3O9kc9lQRgJYlSZ3r/floobKsMGgC5NC/VZFKd/Wpo+kf2cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=BwPdePv7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ax7CXzye; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8A2C811402A0;
	Sat,  7 Sep 2024 06:17:08 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Sat, 07 Sep 2024 06:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1725704228; x=1725790628; bh=kn
	sOpxEIaN0Ug/xUNvc2yVG6bIyAL1Mxw0s6/CJBbA4=; b=BwPdePv7XO6vWf0jsF
	9aJCZN9kuiGrMCQLVO+4XqVIQloRRlxqnuDSrkiCmTFfVaGF96bcgn6tcRSwjXGH
	0zlhQFEHgbUalDFYrgii8NgufSWaunfJ8ozfIs59C4HW2OUXenTU9DTnpYqDx7SJ
	pqIkn6GsRRVofN1bnXkK/xbPO9+NaFarLJNWrXpFJdMPBmBgW9dcis5MQggucLSW
	72MYrqVjlDV/P7mHYVtWW+yZs9KmhvzOa/tnq/EIMAKUT/bfAT/r2AM+h6CrlWuh
	DDVP9g9H91B466Qc44uqYW8IrD+bnjS/GwMmvoMjcTzoyXM25vGYvS/idklgK9E/
	0hmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1725704228; x=1725790628; bh=knsOpxEIaN0Ug
	/xUNvc2yVG6bIyAL1Mxw0s6/CJBbA4=; b=ax7CXzyeoZF45TpMrxsT1NoxhVWUB
	9PxUWMFOEURaHGqZ9SCQY8/JU+VO0GfGs7SRrDUka/tHfqeEdHkJaY43QkLqOGk0
	JmX58i8odqi+4UYQzrgPNKKgMcN3eYISHmpgNcGraN53JbPn1DK2V8sXS0Ad4lMk
	erP5kyg3aeAZG2wNpQW/h0kqxYJSnIjGqHsgM/Jc26AI631GKSamJCuFnMSypScz
	yv5+9CQFkSergdZOxpnmysMhbNHetRncFZb+BZiaiTqsxBd+nbp3vTq2JQx7WLrh
	7jTXoi1L49M1RSmso23jzwJLJz6A8xf5D4b87ISVM9aR6vrEm9Y5jVVsw==
X-ME-Sender: <xms:IyjcZno79q8cs2MloaS4eCszndO-7EfEGzCdBKSvoZwxus4u65FBVw>
    <xme:IyjcZhoLtQ1G04uisPdvBnoAqPtpsImC26fSG8GlgzRgjtMxdVIhNYGMEW-ZePPmt
    zUO4iFe4azhkyuwOCA>
X-ME-Received: <xmr:IyjcZkNuZz2hFVvcNJsMkSjmYvhjP9kQLj7FS8yQFhFf0D6XXqT93rAP6QOdRcwE9PU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeifedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephffufffkgggtgffvvefosehtjeertdertdejnecu
    hfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomheqnecuggftrfgrthhtvghrnhepudffffffhfeuheevhffgleevkeeugeet
    feegieeijeehfeekheekveduveeigeeunecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtgho
    mhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhn
    uhhtrhhonhhigidruggvpdhrtghpthhtoheptghhvghnhhhurggtrghisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehvihhrvghshhdrkhhumhgrrheslhhinhgrrhhordhorhhg
    pdhrtghpthhtoheplhhoohhnghgrrhgthheslhhishhtshdrlhhinhhugidruggvvhdprh
    gtphhtthhopehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmpdhrtghpthht
    ohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgrnhhkvghnrdguvgdprhgtphhtthhope
    hkvghrnhgvlhesgigvnhdtnhdrnhgrmhgvpdhrtghpthhtoheplhhinhhugidqmhhiphhs
    sehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:IyjcZq6QwRbxzgiwuZebXckyYZj6fEd7GDek9J2KRhmrLGEw0GlHvg>
    <xmx:IyjcZm6yEhlct0TDm7j7D2vJTw7K84ICVvYhjbeHpWmQ2LvBU1zFAQ>
    <xmx:IyjcZihpk9v8wVpC2zgZ44WtDqImDb6En3rtp8wn7zD4fflxPe-BWw>
    <xmx:IyjcZo5HuwFEKifXJAP7wIVbs_Q50zo_jnbVqTcdUiw93zD3Gy4QaQ>
    <xmx:JCjcZmxHIDq7uMXzwxa8h81IPQrPAsm-8kKMxs8ilKkmdX8Ukx1zlKHC>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Sep 2024 06:17:06 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 0/5] LoongArch, MIPS: Unify Loongson IOCSR handling
Date: Sat, 07 Sep 2024 11:17:02 +0100
Message-Id: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB4o3GYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDSwMz3cz85OIiXQsjSwNzUxNTC1NDQyWg2oKi1LTMCrA50bG1tQBNTQW
 LVwAAAA==
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2101;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=+DyY6GPIk1WDZOgKzGI2dYuz/zLq3vDNhNWL4C4Q6BI=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQ7Gkrn9jH/iw5jLnoV3va4f/eGC6b5TysXi13q+eZbr
 nb33dd5HaUsDGJcDLJiiiwhAkp9GxovLrj+IOsPzBxWJpAhDFycAjCRqFxGhidxOu+mfRMQdvNi
 61/b1HCROahz2u9FlS/X2i7afyWQbwLDP6XHq/VvNk6x8TTKuP/C5U3hVlnBz2VXznlLfao7VWl
 7nxEA
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Hi folks,

This series unfied LoongArch and MIPS's IOCSR functions and
macros so they will expose same interface to arch-indenpendent
drivers.

This can reduce code deuplication, and also help my unifed IPI driver
and MIPS extio driver effort.

This is touching many sub-systems in once so might be hard to merge.

Huacai, can you apply first three patch via loongarch-next tree.
For last two patch maybe better merge them via a second PR after
all subsystem PRs merged.

Please review.
Thanks

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
Jiaxun Yang (5):
      LoongArch: Rename cpu_has_csr as cpu_has_iocsr
      LoongArch: Probe more CPU features from CPUCFG
      LoongArch: cpu-probe: Move IOCSR probing out of cpu_probe_common
      LoongArch: Extract IOCSR definitions to standalone header
      MIPS: Loongson64: Use shared IOCSR header

 MAINTAINERS                                        |   1 +
 arch/loongarch/include/asm/cpu-features.h          |   2 +-
 arch/loongarch/include/asm/cpu.h                   |   4 +-
 arch/loongarch/include/asm/loongarch.h             |  90 ----------------
 arch/loongarch/kernel/cpu-probe.c                  | 111 ++++++++++++--------
 arch/loongarch/kernel/relocate_kernel.S            |   5 +-
 arch/loongarch/kernel/smp.c                        |  23 +++--
 .../include/asm/mach-loongson64/loongson_regs.h    |  58 +++--------
 arch/mips/kvm/vz.c                                 |   2 +-
 arch/mips/loongson64/smp.c                         |  44 ++++----
 drivers/cpufreq/loongson3_cpufreq.c                |  10 +-
 drivers/irqchip/irq-loongarch-avec.c               |   5 +-
 drivers/irqchip/irq-loongson-eiointc.c             |   5 +-
 drivers/platform/mips/cpu_hwmon.c                  |   7 +-
 include/linux/loongson/iocsr.h                     | 113 +++++++++++++++++++++
 15 files changed, 256 insertions(+), 224 deletions(-)
---
base-commit: 9aaeb87ce1e966169a57f53a02ba05b30880ffb8
change-id: 20240906-iocsr-829075458511

Best regards,
-- 
Jiaxun Yang <jiaxun.yang@flygoat.com>


