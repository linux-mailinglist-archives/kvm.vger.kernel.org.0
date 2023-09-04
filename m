Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F09C791547
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbjIDJ5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbjIDJ5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:57:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20621.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41747126;
        Mon,  4 Sep 2023 02:57:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzGt9bavp34aJ2SRQPcXf19dhx6tdL+fmTQo6tYFdvJrOT30o1zijkLGVdGFa5MI9DVY6ntyIGPIr3P0wDw+oxo8gE1uPFMUkPlYVUlZjmSgn652xlzz8Vk6JT5zjLyh8i+n2su9VjoOYVEHPNcpWf1DV9b1pgnEH94VJSUYBxtfcl5mpLQ0JgNuZvTzqpzLo+b59c7Cq6Ng06WhVXBpXQSJS58lsupPz1U4F/j6pXPkiA6AsI5svRrKhrzphnIEu0a7zBOW54j0i8ydTKF+s6msEREZdxh7t2uJiuvmm+3PzVhqdOJMdntrDPSe8JrceTLBkF51GkzcBuOxO3L9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bsR9tWJlrIJ0NHxdYwPvyIoLLqkmlzE6aCngB25qck=;
 b=LTkfxVYJsDU5y0o/CxZpBm8Il88ZHmwukAB+dGwfQ8RKu5kiT2haXRNZqUXfxfEDSWfcSI69ZplqYze2agg3xV9Rfeg8WFHYe98dSL/QfNwt+DA9jldX/7RvS8YUl9iy2KNV1MqVxb3OK5ZNEkIuUOr07GN7iBUZXG/KS0YUtw2HC3EfXQ2Br6P/kKVd2S1Pnc1LQu0Vjt8mz0yO0Ar+En6h1PoamSJwVaNaGdgtvvKHUCG5b+pCd94VcnNOL1ipRwYh2H+XnsyPcq5ZtH6k/NqJS8BqQJh9i3taBBWOa0d/mtOG649UG+/WzTC4IH9k5C2TaheLd0V39gMRO2FPFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bsR9tWJlrIJ0NHxdYwPvyIoLLqkmlzE6aCngB25qck=;
 b=qA6SQ84w0mH6BcI2XhIRhhcT6VHWiZkiMiYC6WvW/biqZaPvD9nWqGjliJd4h2wjPBExE0fWaGGWayEp1kEt7fUbf4n5FSFt+MOWV2Loq/k6PKooBr7t26yFZ8+ixwyg8gaUK5KZcE6U87F/+IVX3QJyYNhpUpTiWUgweLjkT4w=
Received: from CH0PR08CA0007.namprd08.prod.outlook.com (2603:10b6:610:33::12)
 by CY8PR12MB7339.namprd12.prod.outlook.com (2603:10b6:930:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 09:57:11 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::d6) by CH0PR08CA0007.outlook.office365.com
 (2603:10b6:610:33::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33 via Frontend
 Transport; Mon, 4 Sep 2023 09:57:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:57:10 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:57:06 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 10/13] x86/cpufeatures: Add CPUID feature bit for VIBS in SEV-ES guest
Date:   Mon, 4 Sep 2023 09:53:44 +0000
Message-ID: <20230904095347.14994-11-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|CY8PR12MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 9926ec71-319f-476f-cb60-08dbad2d4e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z62fDVqVx6EybhCnlxI3Xn82wGOYr84sEwIS5aHawz4qpIutANfL3Mmc9z07nn+ssjYJIjnlhsY8WyeIipyKWgoymCjK2KkGsOOlpHRYJDXo+rVUaAuayd+14Naahm7rxGL0k9j0PwSKuxGNvdTebcOCZciPSJshbHeOhsCRXH2OYHZfqfyNvFb22u139sZf6M4bd78OIQ/540dTNu+3KmLzvxRsq1Ge3Cu4BTUDdFMDCpd0aGrXf58StG13vmjUWKDR3LRzCiAJ3Gll/tKbYrOd9cUjKH7RajB44P7mIPgGkwVUs5ITfMon2rYVBX9riONA0ydF308ujkMp42riVreJLOquyrS7AflE2DBoNXcRFz4rOIRnBLV9He7ejntVYkBGBCShe17ZplOhPj+3Nc2INT+O99y/W4hL0OTNeQsqRvKM+3aNyoFc/NwAsuseV82k4nLWdygRM5y2EuCM4ylW9SRKs6pMzAbJOdfi2B+x8Pg3IESVMLQjAeWGDNIOTsUovGExWioPPa3Dip6HLJ7beKYYzj/RJSv1yhIYR3R8ymgjXQJutJB+aMeDEPfm9Zh6zSlpLqIpKzolM5VVH0hJKeVGNv+/Q53Y+XdZiSP6Qmq+lsMFCPFyPQSEp9bB3cpKtI6Rmz88ZKhpZXC/PzMtAzP34p5qv4uzSpTaGA2+2y2Fw4R7kZsNS2rH7wmY75uPp8gjW7ODiwjWg2TGosgMBNamDojhrw1ExGRgndaG/28PwQpVVa5IUowRcBEOBcHXdKxYKerv3NI1nA7bbw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(396003)(376002)(186009)(1800799009)(82310400011)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(41300700001)(478600001)(356005)(82740400003)(81166007)(6666004)(86362001)(2616005)(336012)(26005)(16526019)(1076003)(7696005)(36860700001)(40480700001)(426003)(47076005)(70206006)(70586007)(54906003)(2906002)(110136005)(36756003)(316002)(8936002)(5660300002)(8676002)(44832011)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:57:10.5718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9926ec71-319f-476f-cb60-08dbad2d4e93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7339
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VIBS feature allows the guest to collect IBS samples without exiting.

Presence of the VIBS feature for SEV-ES guests is indicated via CPUID
function 0x8000001F_EAX[19].

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8f92fa6d8319..022ccee197e2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -439,6 +439,7 @@
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
+#define X86_FEATURE_SEV_ES_VIBS		(19*32+19) /* "" IBS virtualization for SEV-ES guests */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
-- 
2.34.1

