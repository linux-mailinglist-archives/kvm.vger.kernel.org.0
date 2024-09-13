Return-Path: <kvm+bounces-26865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C8D9789F6
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 22:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9990C282148
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6510814AD0C;
	Fri, 13 Sep 2024 20:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="uGLjy0i6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="B/8x7+oz"
X-Original-To: kvm@vger.kernel.org
Received: from fout6-smtp.messagingengine.com (fout6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D518B67D;
	Fri, 13 Sep 2024 20:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726259556; cv=none; b=JwO8jRoMcFr2DQOIn8gMzzacpc/iyHFY0/cpXgCPJjzjd1o9Q3Pk1UY5sHl0xw2qPpW9kKdSXgM+ygL02ZtdfORTJcgDmlaXMuuSu2n7lP39WOxTAZU2XYRslpkD/Cds2mbP4VyQ1SkyCZ7pEPQ2MyVIU8jzfilnc5/bNVp36Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726259556; c=relaxed/simple;
	bh=kqsiXM0S++WxqpWKu2II5x53gByCoP6EQXpczcBR94E=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Q1WsdCmny4AhMSZaqhh7MtATurElP/za0tdeRKZMtb4zos0e1X2SidDhiueY6c4AaMUaIeDIl0mcWxMTgL5ByCl75uKeSPwyzNTJI/+m1QPqHZTUqyF40/toLyb86ZSGyGNaus6D77aLzjB1U+sApkRKRQySkT4btAwQa+E4D5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=uGLjy0i6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=B/8x7+oz; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 574CF13803C0;
	Fri, 13 Sep 2024 16:32:32 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 13 Sep 2024 16:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1726259552; x=1726345952; bh=3z
	JOCIYn3qAAdrWtdQVt/+s7stHa4sbT9r8Q+kl3DPM=; b=uGLjy0i67qW5ev4LA2
	vPotFEFa1uE0YguMb/LUaKZWX9RzmmEL5NHlVI8POhqVhNuqrti6vVyn9fsfUxYN
	rje6FlN3mHnIj0YNWfEqwjm1KCiq/I0vfuLBL+1jXJdiQHoeblzxwfi1OrM4fx0/
	/xpDmKBdFYG7Sqwo/3AEOBm/Xav5tXL6njk0Fjjc6JZaJhju3dyoxyp30wT5GUte
	s8rNqgviqU8/qUhZX6xOTYaMm5oqC3DDUIqwDZGp2LSVBWPEb5eF3Vp1//ytwyHs
	mV8pN9dG//Tm3A3gicgsFJglv/MNZgVy/KUt6ZNWCmy3GdxqCfEFnlwX/z/Etp4w
	3jeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1726259552; x=1726345952; bh=3zJOCIYn3qAAd
	rWtdQVt/+s7stHa4sbT9r8Q+kl3DPM=; b=B/8x7+ozb0aCjNFb9H210wi5Q+327
	3Mvo6moh3Tex2SFL5DhpjpaQOjUt5vpMEa6OPb5cqlpIag0O+ewnQ4fJde97pqZC
	HvzFuohvmqnJGcpUhGdce/EoxQEzvBR/Ai5gwIh0bT3weRe1tWkcxzPjF2/sL6AX
	YnJ7V0ZXisw1Y4tN72mQNrue1EPUGUfJx9xC6eP5k0VWC8S8GhAIv9opIkRg/Kp6
	8+8554KOQ1Pqis5dmuVO6iVtMIGbjaVVnXiW/ru+JAze8viD6cr6ROQONNMN8z2q
	+X8YqXomCdqhlXdy1G4d8oNbTuQzoxRyung9khg1qEY0Muy88d9Q0knaA==
X-ME-Sender: <xms:X6HkZuNI28K0oAslpoB9p7Zw6f1F-bTz2V9uzE3aJUErsFs5xRHS2w>
    <xme:X6HkZs8WFE43AgDBUrkwP1170zN4IO2DjAKyzR0fS220hojrY3ReoP9cU_lWP0Diy
    4v0f8Cqq8Lt2Sqy-tQ>
X-ME-Received: <xmr:X6HkZlQIQMtyMaQ6aF-oOdWBNpJ8cmmi5pFGZ9J_QOGeKwuFiDqiBiXB-PutfjdQ8as>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephffufffkgggtgffvvefosehtjeertdertdejnecu
    hfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomheqnecuggftrfgrthhtvghrnhepgfevffejteegjeeflefgkeetleekhfeu
    gfegvdeuueejkeejteekkedvfffffedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgr
    gihunhdrhigrnhhgsehflhihghhorghtrdgtohhmpdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheptghhvghnhhhurggtrghisehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqmhhiphhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepvhhirhgvshhhrdhkuhhmrghrsehlihhnrghrohdrohhrghdprhgtphhtthhope
    hjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmpdhrtghpthhtoheplhhinhhu
    gidqphhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlse
    igvghntdhnrdhnrghmvgdprhgtphhtthhopehrrghfrggvlheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:X6HkZutvEtwU4rtyEsnplhQCiubClCl2jPaBd3FqUnMX0DSUNXo-WA>
    <xmx:X6HkZmeNTncvnJhh8dMZG4L2bY0yyZX9n8OyJWxtHTA6wthKNmIq0Q>
    <xmx:X6HkZi1bV41AnA8kO-ddIwq_UDH6KKG1rCuQzjfVBJJ_oOiDdcZTlg>
    <xmx:X6HkZq_RNTCXfNbJxvzYMnGDIPxgLy-2qfV85SxWqDe94gOGEcAHcQ>
    <xmx:YKHkZs2bRfMyHS1ChtJHwNs6kzUEiJ7tyWjrcQiguUMAJsI-eLQnRHGh>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Sep 2024 16:32:27 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v3 0/4] LoongArch, MIPS: Unify Loongson IOCSR handling
Date: Fri, 13 Sep 2024 21:32:03 +0100
Message-Id: <20240913-iocsr-v3-0-81a57f60350d@flygoat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEOh5GYC/12MzQqDMBAGX0X23JT8mCbpqe9RetAYdaE1kkioi
 O/eKBVK9zbLN7NAdAFdhGuxQHAJI/ohgzgVYPtq6BzBJjNwyktq6IWgtzEQzQ1VspRaMgZ5Owb
 X4nvv3B+Ze4yTD/OeTWz7HgX1LSRGKKHWmFoIUea7tc+589V0tv4FWyPxH4/xw+PZc1q3StZCN
 dWft67rBw9JlRPUAAAA
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2419;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=kqsiXM0S++WxqpWKu2II5x53gByCoP6EQXpczcBR94E=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQnC6N1ZPXOWXQskFwT2rKDx1Yq3GaJ5eLQMoVKK0k+x
 e7E/G8dpSwMYlwMsmKKLCECSn0bGi8uuP4g6w/MHFYmkCEMXJwCMJGFggz/MxT23rPz193Hdu7e
 d6uVcY2bVaouMV3S2mvY0lZ48ICYHSND1w+hj9WNi28dnrzo4O2rIhHRq1m7nntxpbw9Piun6hQ
 3OwA=
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

No functional change so hope it's not too late for 6.12 :-)

Please review.
Thanks

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
Changes in v3:
- Convert if to switch case in patch 1
- Fix typo in patch 2
- Link to v2: https://lore.kernel.org/r/20240912-iocsr-v2-0-e88f75b37da4@flygoat.com

Changes in v2:
- Drop patch 1
- Move IOCSR probing to cpu_probe_loongson
- Fix build error for CPUFREQ driver
- Link to v1: https://lore.kernel.org/r/20240907-iocsr-v1-0-0c99b3334444@flygoat.com

---
Jiaxun Yang (4):
      LoongArch: Probe more CPU features from CPUCFG
      LoongArch: cpu-probe: Move IOCSR probing out of cpu_probe_common
      LoongArch: Extract IOCSR definitions to standalone header
      MIPS: Loongson64: Use shared IOCSR header

 MAINTAINERS                                        |   1 +
 arch/loongarch/include/asm/cpu.h                   |   4 +
 arch/loongarch/include/asm/loongarch.h             |  93 +---------------
 arch/loongarch/kernel/cpu-probe.c                  | 117 ++++++++++++---------
 arch/loongarch/kernel/relocate_kernel.S            |   5 +-
 arch/loongarch/kernel/smp.c                        |  23 ++--
 .../include/asm/mach-loongson64/loongson_regs.h    |  58 +++-------
 arch/mips/kvm/vz.c                                 |   2 +-
 arch/mips/loongson64/smp.c                         |  44 ++++----
 drivers/cpufreq/loongson3_cpufreq.c                |  11 +-
 drivers/irqchip/irq-loongarch-avec.c               |   5 +-
 drivers/irqchip/irq-loongson-eiointc.c             |   5 +-
 drivers/platform/mips/cpu_hwmon.c                  |   7 +-
 include/linux/loongson/iocsr.h                     | 113 ++++++++++++++++++++
 14 files changed, 258 insertions(+), 230 deletions(-)
---
base-commit: 9aaeb87ce1e966169a57f53a02ba05b30880ffb8
change-id: 20240906-iocsr-829075458511

Best regards,
-- 
Jiaxun Yang <jiaxun.yang@flygoat.com>


