Return-Path: <kvm+bounces-7642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB95844EAA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A381C2AB13
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDED4C60;
	Thu,  1 Feb 2024 01:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="S2xv7JtR"
X-Original-To: kvm@vger.kernel.org
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0036D442A
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706750969; cv=fail; b=V2l9XM0/xRD1vDilhijnV/Dv8r1exWxoDrCY/g1rpVvX7bmRCjkUtfNaXoRZ96g+7sktSCEwvpyowB1bGl7DNLOgIDxqPELwCtm3V+VfG7IAT8iZaMmKznUTzWyQ3cqrgw2kAuu3rr+mQTTJ+cUCM+bc9yR0QjvCHoREOy2lDjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706750969; c=relaxed/simple;
	bh=zk85uvIQqp/ot0OdT5DejcghRs82+xu4izURtMvuhQE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YIobk1mAuugeUkkBqUdYK9UUyigPa1W9rIzswqa1WmXvDYr/pU/arq+TNNMl3HRAMQ6pIB8Tjb3yyrKEnu0WEfyCCy6IM2nmhP+4ae0aDmqTzi35AFkF+O+h2T6JQXIdSjtLVvG2CswTgZIQz7tKcZDWu3bxYdtCTmoXTOBWV6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=S2xv7JtR; arc=fail smtp.client-ip=18.185.115.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.10.202])
	by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 5DD3010A7E2DE;
	Thu,  1 Feb 2024 01:06:31 +0000 (UTC)
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.181.221])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 5F0CD10000467;
	Thu,  1 Feb 2024 01:06:24 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749551.393000
X-TM-MAIL-UUID: c251587e-0784-4822-aaaa-ce694d2446bc
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 601041000006C;
	Thu,  1 Feb 2024 01:05:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMAXjbBwdTirr7a8YVsKo/UCwcvyFH6AW6aW5ynzOXvHCA8O0CwXwj06tAU7KlrqyIJ89+bKCjdkYrZ7spjBHce4VdNn3QCrimq69a3GYIWGIcebQl5V1ZSFcq6EepnIV+/mSFZ11izRzWUWO6enGJC6p6aJicUbLMo0DA6CjkUph5HrO2xmkhX0RH+j2+naiuD1sjpFFDFZJILQLyTiDggcSl3Hom44XOj7+jqLOIsbwSLmS1gheiLBCWIa0RKJeAHayfy6wbOycLnaA9NkMl9liz5grU4lJhEz1kHtQ5bVtO7atMe7DYmWU+4cP+nd4oRpMIaAAB18/8DLYtJYeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68UszWC6u1kb+YBX2FtVzcNWjvSlFHvLWP68hbFsEfk=;
 b=cP1HvY+x1Ecki6ol0Cq5gvttjDeDOahAaGdCMaPzqPv1vAqCzmdKf5cbbgiyGseUAZV4aFkBV0KbbmDHhXRRdofigspsQbv1OlWyN5yEZiHx4TWvSnpJ2K/MsKy338iWknjtim1EFpz+heq5XYtcpFL/2E51fgq78FRzN/x+7AuQVd9t9BG9HnNNkPZXUBc6qEadmJCAN190/KC34Qnx+eLACdGe75FkxuPe238N1QBcLvYvWHSWbLVWvQSzSF3+298P27iv5ULUUKxRQHsev6kC7kQo+hkM7fGWwsOuay/lxlaEkXHftfWg42Rq8DUUSiEMZPc9XncCuZjsA5Zv3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=alien8.de smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=opensynergy.com; dkim=none (message not signed); arc=none (0)
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From: Peter Hilber <peter.hilber@opensynergy.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hilber <peter.hilber@opensynergy.com>,
	"D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	jstultz@google.com,
	giometti@enneenne.com,
	corbet@lwn.net,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Simon Horman <horms@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Richard Cochran <richardcochran@gmail.com>,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 8/8] kvmclock: Unexport kvmclock clocksource
Date: Thu,  1 Feb 2024 02:04:53 +0100
Message-Id: <20240201010453.2212371-9-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
References: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR05FT032:EE_|FR0P281MB1772:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: c14f677c-f065-4500-e808-08dc22c1ed98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pEBVQBoI7ER14sO37xJWJ1AOU6PqRSWdL5pil9aOxK4Ii4WV90SPDMcI5loyElujHD6B1CuDnhgTgWPRWZB0Blru+VeWrHkkRmVVqQzEKAOvqBBAWCceMZ6RovcjqrYzNGOITFZeS43mXI3yS1HPbD6qocDM7uCkcYutShu2hUJ2O6kHo/6jchbhyWQ7M+nnsFxU0B3IGHMa+CTFUt8hE6E3BLaAEtNDrjvaHWMEtyXrtMAE/wpuPMMkgyRzGdFub+BtNBSq/2+2k6mQPFSjFAKmZIQpgbvzbgMGVIhmKLYlswufmbibbzPIDXYMrW/ZlVrRzLDy1i8xn1cS3rMw0P3CleoifZcOUOcSYMZp0wOewLQSIaiZWAOX5ANlrt+r3ordhi6+X4iRzxxEiqhujCE40VQLirsdRWTynt3gZQHxsTVJ2f1Oa6K0nHj9RIvhBvqcVfG2kx9oYs6IleU2Dvq9dp0yoLduvAan3e8REDvuIbFZejZP8HiR+vFe4ZtsKlLEmyhntgszMHl/xor0rjUgAFJe5R9hJWqOels0xmx/aRzCtjEGa578NMY8pXi8m1vxthXGe6KJkyda8bGxnkcWL+gqDJpyKzA3hEzxqI3904LP/0i3agQut6Qp3NXZE6RgjDHCpveHvuzQZfnXW82FOQBEkHnzqBKeqh4lkckh7uU67JcXWFH/hcWDAmVa9XaYmgIOezPgcfK0llXWQiyGqwzMrcnyrBmPOmr0to1W+wdvqJR4mcZh12usu5DR
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(136003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82310400011)(36840700001)(46966006)(478600001)(70586007)(2616005)(82740400003)(5660300002)(7416002)(44832011)(81166007)(41300700001)(2906002)(54906003)(336012)(36860700001)(1076003)(86362001)(8676002)(4326008)(83380400001)(36756003)(8936002)(6916009)(26005)(47076005)(70206006)(42186006)(316002)(40480700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:48.8771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c14f677c-f065-4500-e808-08dc22c1ed98
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT032.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB1772
X-TM-AS-ERS: 104.47.11.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10--1.575700-4.000000
X-TMASE-MatchedRID: BoYRaA2j95x5JK6VZ/y/JZIdC0Q5JDAc3O2+pOfl+vcwLJ9PZUBQhdqK
	Kei3fK/BwLkzWLqYXGIPTxis+8SzNY5D3dtciD32DnyoB5C0LDMhB2S/EqeA6zB4jJltGVDbLN5
	wGPX3TPXYeXOEzfM22ez1ZBVjJwp/DeUZOJCXHMgCZpI9UgJMHqJYuGaIjh0/fiAqrjYtFiT3az
	xU5+I+Ep2+6DCWmW4Hr44iRWuVPqIG9pdpHgJL8H7cGd19dSFd
X-TMASE-XGENCLOUD: eea5c0c0-86de-44e7-8521-2a9364c6a452-0-0-200-0
X-TM-Deliver-Signature: D157937CD86D805F530F564B2F0A321C
X-TM-Addin-Auth: Vaa7inNIa4Kf4UMh99Ebri8D1i4dm2eKOqZvseVqXrsbZRwjQtOM6PzGMjy
	5TzBaknLnNz2cEimtzDRWvv+xmBLR7CIQxUum61DMqJjBKpCxGcGedulQR4ZQN92yynXa1fij0k
	vocD1ZklCfanlgFUWZoGujN7kM9xxIMcHITRdpIeXWaJ+0IGXdBa40PLZrApm7SJm3027CvkRLw
	daHR9vhYEjL7bQPfpAAgBuFOkRDsCp1FHNdj6IrfheLVrgJcJN2Q3oCTSZjoU6xVgOgxRnuZ95e
	ZGeuH+QD/J3r8YfCPDiblMMps/PTTTKuxE6J.xsND+Adgvd/qzlxtk+lr0WvcLsnJnV9xKdIYB4
	UODIVl5rF+BU3zHE1zlQGJ4AUrqv7+PoYYZCF24E8WXB8VDiqDT7p5pqj2V2fzz4OQbNyGOShai
	UV1UqTeE37GWz8iQyvF519L9EOQRtX0m3pMj7iA7cRN4sjgULtSYUkfDzqYaJEvseeq62BPBNIp
	l4CJ5IgbN0zYQh6SV6ouGdvpHCMBu4o0EwQkgXPSQ+pfseli4u6yaSY9sCu/r4c2HDY+tZDvFcH
	WIqurLcLuVUY1PpGuZe5lA/bCy9LZYW+rhbBy4nAQZQMzVVffABSLRKCJ6k6nWoEMoR/nWVszgj
	BOUQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749584;
	bh=zk85uvIQqp/ot0OdT5DejcghRs82+xu4izURtMvuhQE=; l=1545;
	h=From:To:Date;
	b=S2xv7JtRyCjSV3LgQnsvmudC0BquLZmiEPO1HPmtnQDWiQ8e5yaPb6n4GKpLGAZ9e
	 b80FpCZ0mAmkA4H7kSCEYB+mhcC9X+SRs25BpFkUpisgSfGojMoci2akybUQp5O9VV
	 g2m1Fndfe+mtWJ5sjFnnvO227iR/4XnBW5nMO3QEEeYELLlQLKG5XmMGwDCUjmTOCP
	 gHNvUg6pnjOpufemFLgnhk354vpF9cVCwGV/rF/UAKNO6zdc++dKrVHAZYY4bGRyqF
	 qSXXExP/Q5MQDPkYp3s/xKcR6KnZsv1gEd/tgFbVAZPohrOgdMtoGwRgQ3qE3YDRfK
	 hjVuuMFshAZ4A==

The KVM PTP driver now refers to the clocksource ID CSID_X86_KVM_CLK, not
to the clocksource itself any more. There are no remaining users of the
clocksource export.

Therefore, make the clocksource static again.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    Added in v2.

 arch/x86/include/asm/kvmclock.h | 2 --
 arch/x86/kernel/kvmclock.c      | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index 511b35069187..f163176d6f7f 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -4,8 +4,6 @@
 
 #include <linux/percpu.h>
 
-extern struct clocksource kvm_clock;
-
 DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 
 static __always_inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 2f1bbf730f45..5b2c15214a6b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -154,7 +154,7 @@ static int kvm_cs_enable(struct clocksource *cs)
 	return 0;
 }
 
-struct clocksource kvm_clock = {
+static struct clocksource kvm_clock = {
 	.name	= "kvm-clock",
 	.read	= kvm_clock_get_cycles,
 	.rating	= 400,
@@ -163,7 +163,6 @@ struct clocksource kvm_clock = {
 	.id     = CSID_X86_KVM_CLK,
 	.enable	= kvm_cs_enable,
 };
-EXPORT_SYMBOL_GPL(kvm_clock);
 
 static void kvm_register_clock(char *txt)
 {
-- 
2.40.1


