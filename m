Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840AC4A6AE1
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 05:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244041AbiBBE32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 23:29:28 -0500
Received: from mail-sn1anam02on2063.outbound.protection.outlook.com ([40.107.96.63]:20481
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232908AbiBBE30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 23:29:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktb2Y5TMHx7Gufc9HPdkV3lIUZCPYAxRYbaImJ/QfdJSxMSRuFccW3bMJAnRLu47y/5aYD83tR0o9aAqB0kO9+5WNLJJy7Dl5aF7Lftb988oNE74nlNWLJb2h6CGRQWxda9ysX3n6VZ+7Uwl9gcoi7s5QhcbeIYCYuLYpysgDDmx3dshQopEkhpGpcylPgbh6Xu9N3BUSew0JjnhvPzJkPFsk7xr32o/ArG8qjE0nH3fIT0GWTg9Bv2Kwi2wTWLxjFJdvaS8T3gFt2vcpqpE0ErEw9wwjObEp9Wc6Z6G+/hXIHGeUwCNiYxgFlmxq+pFmJz/npjkFxAFUc89aFyOvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqgMcUfhDrCwffj0CjUnqhMl1CtCUvkbCfnkbEx/aNM=;
 b=cZzcyTZ1tUM9jz2EIfxAUhVWIkER205E4W3GpYJjWuxT9wDtvXN5juEMbmkbQ2D7RBgjUGVRGxL8BRGdACFKmOiMTLbyJ00Jraerc4ZGERjIARDV0Ut5d7YmMl085G1gs/5Kq3/Z4zu3Eu4M3HFt/iPJ3/YQJxG12ItDE45T4k/PoG09aAeJpSNOIy1DNziVtd68gAB7Dwh5lpZSEPFEemgQAoAZlzkAXTUUM/ivNgllluVdFrKqcFnchWT6+iQAyDi4CQL/cAdtTcYQUOSj0mcYWKXutRvgLkZ8uIVE/VGAWsx7eW4iQ3UOEXEfmclurFfIly3Yect5J5ThXfVWnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqgMcUfhDrCwffj0CjUnqhMl1CtCUvkbCfnkbEx/aNM=;
 b=QBMnqKiCKETaTYU88kFZ5x57yBEJ/jOOTWDUCkH0xkGy4qOWF5NXq5o5PJAEPYIoGsXCHfYYtfVLngTm+K046VmhiFjJxa92K4fImlw+CxUzMCYNOj80etynQ64WOAzcLX+yE2T6KK6bKusEfN7YpsP7uqySh3i56Mk2nAb1lEk=
Received: from BN6PR20CA0067.namprd20.prod.outlook.com (2603:10b6:404:151::29)
 by MN2PR12MB4439.namprd12.prod.outlook.com (2603:10b6:208:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 2 Feb
 2022 04:29:23 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::d4) by BN6PR20CA0067.outlook.office365.com
 (2603:10b6:404:151::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Wed, 2 Feb 2022 04:29:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 04:29:23 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Feb
 2022 22:29:12 -0600
From:   Ravi Bangoria <ravi.bangoria@amd.com>
To:     <like.xu.linux@gmail.com>, <jmattson@google.com>
CC:     <ravi.bangoria@amd.com>, <santosh.shukla@amd.com>,
        <pbonzini@redhat.com>, <eranian@google.com>, <seanjc@google.com>,
        <wanpengli@tencent.com>, <vkuznets@redhat.com>, <joro@8bytes.org>,
        <peterz@infradead.org>, <mingo@redhat.com>,
        <alexander.shishkin@linux.intel.com>, <tglx@linutronix.de>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-perf-users@vger.kernel.org>, <ananth.narayan@amd.com>,
        <kim.phillips@amd.com>
Subject: [PATCH] perf/amd: Implement errata #1292 workaround for F19h M00-0Fh
Date:   Wed, 2 Feb 2022 09:58:38 +0530
Message-ID: <20220202042838.6532-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117055703.52020-1-likexu@tencent.com>
References: <20220117055703.52020-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6734e2e-5f6a-4b09-c768-08d9e60496e6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4439:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4439EA80ABD110686DE85410E0279@MN2PR12MB4439.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8oAxAfe1IeuTQYiy2Ge/3qhgtY3hcCKK5keFCs3+qxU/VX0i2TwUDiOd1BFIDehrtivUdfApkWnsob1ob+JkTfsGkN+5hbVEQOJuK8eSReaT3L6O0OiHTWa+XBI6MaawJAXGHT7m/+1fHfQPjELT+/ceMt6C9VZsiiz0w9WNm2uPNs/cd6LcOEkj5MgpycFYiuRvUb7ndUQuM9i18M2uipKVZgp5m2u1sNT96hxpzrISM6EKYFvEv/LHSZjA4lK41WfMuQSTQmoaMcGO0p6XDzfONWugm9uGvbhGdGBzyqdHVU3yUMyege+nxjYYCwZ0ci8e6HdvzoS1vGY1KU8tkQ1IA32kUW/8FnaUadosRX3x0suAIQ5TCs3uwQQdTo2ZXdGCyd3pbTDd1dv6lu/wmsTKGlbF5tGpJ2a6VB98MNFhbHRgF/Mk/mcwI/ia+r9ceHQybfV4v6LmcMbcpVNmeYwlsPqNZmC12i/HMEPUjZ0pmzemjuJCaDcQUwPooOr6+lFnI/1R13V22x+HxaO3fDn+KZ7abueOlANGwz08bhxDOeQB6O0aYYfXP0/ttnGMq1PoiAbmTxXPF1tQTdplcK8NOkA3WFRTA4YMKF0XZnwJJH3H+W188FXHC3OsO+fMscXhdHJdYgp0ioVBrqKJB9qwW/uogCk56loyMX/ytcyGgMrffjrn1dIuUHNICBA4bcNMueGChiQzFj8ZkQ089+pRlw8zYuWBCuBTes9yfxFFkrj/arnI8r1QKrI1etMyPoEPsPURvXSEV3DlMFRgbRl26yWCuETcH5EA1VNdihimjZCYEZk8oIBUty1nPgC95DkechzbZnstvpPRD2+8g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(83380400001)(2906002)(44832011)(36756003)(36860700001)(508600001)(54906003)(110136005)(47076005)(7416002)(8676002)(81166007)(86362001)(4326008)(186003)(336012)(26005)(16526019)(356005)(8936002)(1076003)(82310400004)(316002)(426003)(2616005)(40460700003)(70586007)(966005)(6666004)(7696005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:29:23.4975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6734e2e-5f6a-4b09-c768-08d9e60496e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4439
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perf counter may overcount for a list of Retire Based Events. Implement
workaround for Zen3 Family 19 Model 00-0F processors as suggested in
Revision Guide[1]:

  To count the non-FP affected PMC events correctly:
    o Use Core::X86::Msr::PERF_CTL2 to count the events, and
    o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
    o Program Core::X86::Msr::PERF_CTL2[20] to 0b.

Above workaround suggests to clear PERF_CTL2[20], but that will disable
sampling mode. Given the fact that, there is already a skew between
actual counter overflow vs PMI hit, we are anyway not getting accurate
count for sampling events. Also, using PMC2 with both bit43 and bit20
set can result in additional issues. Hence Linux implementation of
workaround uses non-PMC2 counter for sampling events.

Although the issue exists on all previous Zen revisions, the workaround
is different and thus not included in this patch.

This patch needs Like's patch[2] to make it work on kvm guest.

[1] https://bugzilla.kernel.org/attachment.cgi?id=298241
[2] https://lore.kernel.org/lkml/20220117055703.52020-1-likexu@tencent.com

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/events/amd/core.c | 75 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 9687a8aef01c..e2f172e75ce8 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -874,8 +874,78 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, int idx,
 	}
 }
 
+/* Errata 1292: Overcounting of Retire Based Events */
+static struct event_constraint retire_event_count_constraints[] __read_mostly = {
+	EVENT_CONSTRAINT(0xC0, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC1, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC2, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC3, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC4, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC5, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC8, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC9, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xCA, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xCC, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xD1, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0x1000000C7, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0x1000000D0, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT_END
+};
+
+#define SAMPLE_IDX_MASK	(((1ULL << AMD64_NUM_COUNTERS_CORE) - 1) & ~0x4ULL)
+
+static struct event_constraint retire_event_sample_constraints[] __read_mostly = {
+	EVENT_CONSTRAINT(0xC0, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC0, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC1, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC2, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC3, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC4, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC5, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC8, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xC9, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xCA, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xCC, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xD1, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0x1000000C7, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0x1000000D0, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT_END
+};
+
 static struct event_constraint pair_constraint;
 
+/*
+ * Although 'Overcounting of Retire Based Events' errata exists
+ * for older generation cpus, workaround to set bit 43 works only
+ * for Family 19h Model 00-0Fh as per the Revision Guide.
+ */
+static struct event_constraint *
+amd_get_event_constraints_f19h_m00_0fh(struct cpu_hw_events *cpuc, int idx,
+				       struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	if (amd_is_pair_event_code(&event->hw))
+		return &pair_constraint;
+
+	if (is_sampling_event(event)) {
+		for_each_event_constraint(c, retire_event_sample_constraints) {
+			if (constraint_match(c, event->hw.config))
+				return c;
+		}
+	} else {
+		for_each_event_constraint(c, retire_event_count_constraints) {
+			if (constraint_match(c, event->hw.config)) {
+				event->hw.config |= (1ULL << 43);
+				event->hw.config &= ~(1ULL << 20);
+				return c;
+			}
+		}
+	}
+
+	return &unconstrained;
+}
+
 static struct event_constraint *
 amd_get_event_constraints_f17h(struct cpu_hw_events *cpuc, int idx,
 			       struct perf_event *event)
@@ -983,7 +1053,10 @@ static int __init amd_core_pmu_init(void)
 				    x86_pmu.num_counters / 2, 0,
 				    PERF_X86_EVENT_PAIR);
 
-		x86_pmu.get_event_constraints = amd_get_event_constraints_f17h;
+		if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model <= 0xf)
+			x86_pmu.get_event_constraints = amd_get_event_constraints_f19h_m00_0fh;
+		else
+			x86_pmu.get_event_constraints = amd_get_event_constraints_f17h;
 		x86_pmu.put_event_constraints = amd_put_event_constraints_f17h;
 		x86_pmu.perf_ctr_pair_en = AMD_MERGE_EVENT_ENABLE;
 		x86_pmu.flags |= PMU_FL_PAIR;
-- 
2.27.0

