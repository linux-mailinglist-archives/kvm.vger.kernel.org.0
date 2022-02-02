Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D404A6F2E
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 11:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245466AbiBBKwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 05:52:33 -0500
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:63713
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229831AbiBBKwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 05:52:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UX7jNnycBjUugSGeDTxhzXtBeb8gUnBAaDfEUDX/weXWLfedNF1UrYBbziyjprkXqyXl0mKgAR5i00pF0vuzhbnSg9ZtBHwALyitCUbUbttR6tubbtiMSFvr2aGj0Ej+j/9WMOHTk1CsI7qRXCMf25ZOb9t8zXqqg5UZxXQvzMi5CekS6lB8pjYcGjmH4mVUMUWX+OqyDlzGw5aee4Ig5+YASEmmA4y2r2bpyJ7IcsSbdN0ZUBK8Wt6ckBog/9MCH0TNzzCnQNSLjKwDXgzYL3/3Hk1jOkHB72P0+wIcqSk089nGTPguaSoQJv2ih/JhwATz/Avwwim9Em3lHPYTVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QvTztrFYDw5c3Y0v+68WY5AGApejch2wiA6/aKQdW4=;
 b=AizJz9rKhNGAmjHeHu/mk7eQlt2miadzJF1ocdsaZDJtDB4zKkXnMrJuRAA4rQx2EPEYjjgAZ0UlV5uMQZKyr+wwDw+3GhEcpLXBL1elIfetxAI0COnTB/AeOJSmPcFoaRzbqgZ0gKMuqU55lcTRNTJh+zrQ1YOtjDUJI491g8Dt9tBPrP/Hbh7MPpJsZgsd9YGN+TZGgxYtsOtzOxoprPVrG88fEVlHFHEj/LXICIOothDNt6giOQROKZlDUPnubi1albHvObZqr6mBWZHDRcglpLCy9lZeq1/XA8uvuc/TsU1iRvlZ/PIGmizH+tH7F2eOn0k8OGVKHYDAFFuRtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QvTztrFYDw5c3Y0v+68WY5AGApejch2wiA6/aKQdW4=;
 b=FbY6+Ce7l3kerIhOpQwGG8N5pJzWIgAkuT7OcHaIM39IQCtRA8GuJG7JuNV2MOQnzHxZG1jPDK0Cnbxj778MOAkqLjdqnNzsaIjYITeoeDjn2Ulg5AFDl7i09ZYhQc2wmFVwbp/L2o/YwdhKdAaR5riQHtyqKZRIjb+PI661jwY=
Received: from BN0PR03CA0009.namprd03.prod.outlook.com (2603:10b6:408:e6::14)
 by CY4PR1201MB0053.namprd12.prod.outlook.com (2603:10b6:910:23::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Wed, 2 Feb
 2022 10:52:30 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::53) by BN0PR03CA0009.outlook.office365.com
 (2603:10b6:408:e6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Wed, 2 Feb 2022 10:52:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 10:52:30 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 2 Feb
 2022 04:52:20 -0600
From:   Ravi Bangoria <ravi.bangoria@amd.com>
To:     <like.xu.linux@gmail.com>, <jmattson@google.com>,
        <eranian@google.com>
CC:     <ravi.bangoria@amd.com>, <santosh.shukla@amd.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <wanpengli@tencent.com>, <vkuznets@redhat.com>, <joro@8bytes.org>,
        <peterz@infradead.org>, <mingo@redhat.com>,
        <alexander.shishkin@linux.intel.com>, <tglx@linutronix.de>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-perf-users@vger.kernel.org>, <ananth.narayan@amd.com>,
        <kim.phillips@amd.com>
Subject: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h M00-0Fh
Date:   Wed, 2 Feb 2022 16:21:58 +0530
Message-ID: <20220202105158.7072-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ef9cc79-fce6-49dd-99e3-08d9e63a1c22
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0053:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB005386BBD8DBA72BA593CA4DE0279@CY4PR1201MB0053.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AfMs+1j9ou37d/oOxW2RU8CiRv0v08pJxfqjGnMMqVqVKOsJIr4bkUac3ARsn7Db9iAB3zWjzSupSvJgUIWD2dqbOJ3y4s4muv80Jnk66DzrKnI26hteVgd5JDnJZvhIbXw0HTB37SgzO8Yf1OFFz3dQNFJzFcMOTVRZVjWqBh3rSX5thiHCVg49CvXVF/YRElSxeLIZxJfwEF+WB6NVmNIaxwd25bTbXpZMx6peSV3xn+nVSCVKAxbcTp6cqZKg/BtVq6KJrB4xbELYRpymTSx6DSI4geQnuf0Ljhrb4lVd+2mBBACjmX4qPzWI4OG5J/vzcPogUZ39fMK6nipQhttSf2X0Iq/TSpo1WieBiJXOSC1y0CDZM0bR98LhXxFoI8chs6YtFKetjOkRX983ux48+xSdYGp1AUveGCFX85yCjGjXKPzITiXXNa3RrZ4p9eSObxqGmQbrEDG+q83Mr5VTf+fxtKMFwcucWuti+ekt+i2jOkkqaQFoKBDFQwi5Q12eehjnDAKM1JUyji8YZFKzvmY7kQZ9f9s2ZD9cBYBA91g5bTNf+dNfkspsnXlbp4Y0rFwaTTHiTl8+ePowfpuEgn2/L+i7QSEK/LsPRgAnY3CYulO4WSeyBG0oWaZWNRh5tqesZcjKTxmV3FxpC/s6/zPvN3d+KXj8zqFnXmeU9LZWlEefpVC6zenz5S0QYcCKhRCzKmQWQNJOu0qgOik2xBhinAbH85Z5dmkJ+VACLayLCqKJVC9dmIAFKCMfrPa5odrm8OjQMGsesQQTb69wTUfo6tWeY+w63OObgzMyjFBQQSsaPAQe4lr3Z9EU1oNxVYI3EMasTjmiUgbbTw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(81166007)(36756003)(966005)(2906002)(5660300002)(40460700003)(44832011)(47076005)(6666004)(7696005)(356005)(16526019)(186003)(336012)(70586007)(2616005)(316002)(86362001)(82310400004)(54906003)(7416002)(1076003)(26005)(4326008)(426003)(8676002)(8936002)(36860700001)(110136005)(508600001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 10:52:30.3532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef9cc79-fce6-49dd-99e3-08d9e63a1c22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0053
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

Note that the specified workaround applies only to counting events and
not to sampling events. Thus sampling event will continue functioning
as is.

Although the issue exists on all previous Zen revisions, the workaround
is different and thus not included in this patch.

This patch needs Like's patch[2] to make it work on kvm guest.

[1] https://bugzilla.kernel.org/attachment.cgi?id=298241
[2] https://lore.kernel.org/lkml/20220117055703.52020-1-likexu@tencent.com

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
v1: https://lore.kernel.org/r/20220202042838.6532-1-ravi.bangoria@amd.com
v1->v2:
- Don't put any constraint on sampling events
- s/errata/erratum/


 arch/x86/events/amd/core.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 9687a8aef01c..d4dc5ff35366 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -874,6 +874,24 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, int idx,
 	}
 }
 
+/* Overcounting of Retire Based Events Erratum */
+static struct event_constraint retire_event_constraints[] __read_mostly = {
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
 static struct event_constraint pair_constraint;
 
 static struct event_constraint *
@@ -881,10 +899,30 @@ amd_get_event_constraints_f17h(struct cpu_hw_events *cpuc, int idx,
 			       struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct event_constraint *c;
 
 	if (amd_is_pair_event_code(hwc))
 		return &pair_constraint;
 
+	/*
+	 * Although 'Overcounting of Retire Based Events' erratum exists
+	 * for older generation cpus, workaround to set bit 43 works only
+	 * for Family 19h Model 00-0Fh as per the Revision Guide.
+	 */
+	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model <= 0xf) {
+		if (is_sampling_event(event))
+			goto out;
+
+		for_each_event_constraint(c, retire_event_constraints) {
+			if (constraint_match(c, event->hw.config)) {
+				event->hw.config |= (1ULL << 43);
+				event->hw.config &= ~(1ULL << 20);
+				return c;
+			}
+		}
+	}
+
+out:
 	return &unconstrained;
 }
 
-- 
2.27.0

