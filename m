Return-Path: <kvm+bounces-4600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C58881534E
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAA11B2412E
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F306356381;
	Fri, 15 Dec 2023 22:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="r+mwdqB4"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA3D18EB5
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.19.72])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 5E515108D954E;
	Fri, 15 Dec 2023 22:06:47 +0000 (UTC)
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.165.80])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 7D169100004DC;
	Fri, 15 Dec 2023 22:06:40 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677999.039000
X-TM-MAIL-UUID: e89fab8d-f901-4680-9eb2-6350fabcb655
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 09B2C1000179A;
	Fri, 15 Dec 2023 22:06:39 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mN9CBsYr1igp1Q5ecL+5LKNdiZ9a5IljsVGyXe4GaNIIlNgmV2GLsJFhztiLqEmZpNE+YUOs85kzF1wRbFTZdR2ZAVwGc4lKBYRk7EAd3dAimLBdP6Ltbwrq4+ikORJ/+RIxorN4Ac/N2YbLbSYailEhalR+7K/tyd5xtYusPIphP6fxP1GkurkiXfwu1hP09WU4dqDWOcBVjw1LZmO1HQeV3g271oytIbRafzMjyr2sKyJ1zx0TIRXDryoKIHBazY0tKewJygqX+M3fGZGWdf99yFya12qL++y6VSGJ9ZLK3RE1V9tMwBMnRIi76BDQIpYLLrn9ZBOzyy5BTBIIdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8igrOwD5gdm1nUNms67uxinoVx8SWxrYCVAZOEIjgAU=;
 b=dcy5hbOQkcbH16D0561GyGY2u+Xdt7xLRzJpx3giZWd5QHkM+QQ0JzltehGZm3OviFqmyounFEkVgSd//yqo0CItvLnclb5zXcLZfGrz0EQB5ET2V4de8zHVvrr01FMxUZCBN852Q8FZm4a/mg09pzW+pQe4A4oSFfZCchi5qVwaF5YYzHe33lwszGQt0aFTpkD5x+xzXtIZdKEnKFPnzcu/7Lud3Irin5HwMIuFj2a3Ut9z9f8EZTG2jRne9P/SRznbKypm2Th834WCty+cKogcUnCOob4h/yuzykDrj7VAYVSPczThsAGkCT0QQjceA+FcVoj2D6WwCvnSS5pa2g==
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
	andriy.shevchenko@linux.intel.com,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
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
Subject: [RFC PATCH v2 7/7] kvmclock: Unexport kvmclock clocksource
Date: Fri, 15 Dec 2023 23:06:12 +0100
Message-Id: <20231215220612.173603-8-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231215220612.173603-1-peter.hilber@opensynergy.com>
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR05FT061:EE_|FR2P281MB1733:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0d53975a-360b-442a-0e6e-08dbfdba1b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kygg9/BQQbOtJaKlA8sRe5x3+SnVFB+qyEhStITrXPHNIJNYXpDuCc94uJUe08Wug+LbMdQdyxbzvNodGlBU/OAiUH7FRcPIwufE45LFq2hChSLbE0qAGh8wL5un/YSyp8Tf/T5j9qX/GmB9BPMR3b3r1Id4fxLZNcIbm19nAgMN828qMS2gg0NvTuItQbdqQeGQXN2pbU7wqYasVHSHk0Zmj0zZV49ibF+XR3zBUNhC4CO3nt5njksHkRHjmV70MHZkuFWtZmmdmbLZqWLnetgdvdJYj7utoK+YlNFAeO/DH5cLpYBGUMFiElnC1Fkewjlzq7ecooZzXpYNmH+E9uCqcNdBfkzuBHriySq6m2s0CiXWAkteDx1Je3ModAl6aPWUiAqWXSW54uBBNrurScnrHdeu2M4SoksSIgWwa171M3AFHPiH8DlgmIRrQ6K0fKUGLSYiEyGz0Jc8mB1CgzLAaob+CscBHxLx7ZDtPAJw0U4+4k8GrMY5bm1bZ/kCPhK/qICV03AbaXb93h3hhkY5XVPIpKNYIldqQxktltaLVIT4mXdMU0ArXggnd+wLhHn/dXsHiJuMoCaH4f47j/bmNDZwP1zyx0vFubzlvJ9u1yzEOkzgBPbdH/YfM30S53Ug/q0CQJXBqwk6dnOjKvtGckwz6MJJdL6OTKkT75yMY1/58dpJqmF1gAZiKynL9PAqMYW9KJlMK0PjXyOmEP3RS8U3gH2pF8CoTKlEeF0VTSvjjHeY6cn4pqYOMfC6oFbGJx9aYbMkJ/vY9fkCm0HHJaPWznPrkoyDptE3nSM=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(376002)(39830400003)(230922051799003)(451199024)(82310400011)(64100799003)(186009)(1800799012)(46966006)(36840700001)(47076005)(83380400001)(1076003)(2616005)(336012)(26005)(36860700001)(4326008)(8676002)(8936002)(5660300002)(44832011)(41300700001)(7416002)(2906002)(478600001)(42186006)(54906003)(70206006)(6916009)(316002)(70586007)(36756003)(81166007)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:36.8323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d53975a-360b-442a-0e6e-08dbfdba1b72
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT061.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1733
X-TM-AS-ERS: 104.47.7.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10--1.575700-4.000000
X-TMASE-MatchedRID: BoYRaA2j95x5JK6VZ/y/JZIdC0Q5JDAc3O2+pOfl+vcwLJ9PZUBQhdqK
	Kei3fK/BwLkzWLqYXGIPTxis+8SzNY5D3dtciD32DnyoB5C0LDMhB2S/EqeA6zB4jJltGVDbLN5
	wGPX3TPXYeXOEzfM22ez1ZBVjJwp/DeUZOJCXHMgCZpI9UgJMHqJYuGaIjh0/fiAqrjYtFiQxS9
	94xGDNKqw9tW5jEvZ438AP4uzP/tN9ZAWWNlw3BX7cGd19dSFd
X-TMASE-XGENCLOUD: c5e42938-9243-421a-96da-f6f86875924b-0-0-200-0
X-TM-Deliver-Signature: 2C4C557BE2D73A0C7566D672411B7F6A
X-TM-Addin-Auth: c3PzKypaMfdlFzSvm1CTlzQhM7QWSsUjNbvDp+1029UD6iRC9gqXd1TlEtE
	uEg32fULegaxi7y4PjHdqNMzFAw7Ux6XfGQKsa/qb0+CY9LfLa3oQ6bJJggMKnmemJfVy0fbYrB
	Z1+U5fkL6zz5YqrGNsZx2kvPMT3gaV1kytMkUNgZd9A1kYq+svYDgye/y1vyqsZI7Q0p71oF+T1
	Zfgxc0sWMT5bCMjCJTD2kCxRMpLCTpIaWLRSjKYo9bsHLyW+zSz4IrD0KQ3P0JDBF5RtrwpVdHD
	4ZbrjBwX5zS8AHE=.1kwie91cxv0TfL2bi29pDFdm5YUQkJhesAriKE+DNolxR58P5MSNZ1zus8
	a0VS2OPRiGy8cafFIrBtQ0vYEum/DbXcf1CBu6Ho5lV/WELG60xLhGGHk3sWT34We5wsRPbO394
	mhw3N+M05MhUlYYfr0xZcEfipH9rsc8Nd6nZKSw6BQ7GfskrdxjUmmMbM/HngKU0n1U4m1UFxVc
	7xeYVe4SaxnbkXMRkLDm1PTX0f2Ge2s+KFF45og96CoWLDQ29SJsKgvbCQ+GeezUyXXIa+EOM/X
	lIIIa42/jxniwVE+mRAVyT8vLEdV32Z7RNLJpUVQYMV1QtUmUGyn59HJcQg==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702678000;
	bh=IpcNBYNAwG6Ko4w5APrpa6SbF+s2i99WUAExpUxxx5s=; l=1567;
	h=From:To:Date;
	b=r+mwdqB48AOofF6R/gA5tImU3XQKaFH8R3Bk1c6Bbo718GiPES5Kp5aCSLYNqPKws
	 zFHHeQAU8hu9kY/eRSGQkSBob4s+hMULieqXKEusUbn4n07H3RCNtltQ9Nu+n5oeGw
	 GhiHfmVPJkkNwN1HGFORnWMa9zmAPFvbd+Tt/+pmjehC9ow+bZOQGbp3v925Swn7XP
	 nYRK9aym/gsqOakPL/ufU+600SpFGOuMj3e7WQl6gUvLSON9tDu4VQc4YQj11a47Ew
	 dJD27K6ZjOG0wzKmrPe7qEKmNBjCBjPw+NDYVAJYvgfVVtWdvOCY+qbqbgszDJnkJ9
	 Rld+QuLI74yEg==

The KVM PTP driver now refers to the clocksource id CSID_X86_KVM_CLK, so
does not need to refer to the clocksource itself any more. There are no
remaining users of the clocksource export.

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
index 25d6bf743b03..9dfbcd2f4244 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -155,7 +155,7 @@ static int kvm_cs_enable(struct clocksource *cs)
 	return 0;
 }
 
-struct clocksource kvm_clock = {
+static struct clocksource kvm_clock = {
 	.name	= "kvm-clock",
 	.read	= kvm_clock_get_cycles,
 	.rating	= 400,
@@ -164,7 +164,6 @@ struct clocksource kvm_clock = {
 	.id     = CSID_X86_KVM_CLK,
 	.enable	= kvm_cs_enable,
 };
-EXPORT_SYMBOL_GPL(kvm_clock);
 
 static void kvm_register_clock(char *txt)
 {
-- 
2.40.1


