Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B2E481046
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 07:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbhL2GW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 01:22:58 -0500
Received: from mail-bn8nam08on2071.outbound.protection.outlook.com ([40.107.100.71]:19552
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238916AbhL2GW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 01:22:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeYmzFsu5DQShgr+V0a/5ECNwlSbnk/hh0A6U8qakbQJqJ4zC8X9tsoIps9NVJyAPJBastRkSz7TarA9//RjS4Zd9UlrkLB42J/CefGScCIChsWTq3yxBEPvp/EwipNs20IHRysrSbFYVHLKGr7F2dRI/6aHXxlHBCGLE5yXTIVRI1SI7xZqCYszYOwk8iaHIKRlUrbunaYXlteXtm+P3/THNgBE7qTJp8TUPeevh0dhtF2Yq2e4f5BSU4hwUuuaB+K/Cs0PVb2hXzkaCUfFmb7xYXURTgdTTxcHqzdfQpvpOrL3a9skxjEqd7WTchAkagbmH9jmvPQV0swVuhBcGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTOwOwKW7UPeQhjFSr+q7fPvs2ELSRaFrsWIFg3Dcf4=;
 b=QwHm7uT131/Vxgvv44Oeu6RGabidkLUCDUzIvuYnIY526jlMzgbGsH0fk30s5wkB5PbxfJ0HFZ1IhdgUCLGttKuOnRcoZDNs/5jVKbPtZViMBiEsjBo3C6ClDIaopmS0vixVHcE18TDNnCEh6hMHOgw2ZxUYnNtyB9Ar70KkdYEJC1bS3V2lc7dNR/2i3OJ0lrbSQa7ndEH4zI5vtc/1/x5m/VrN6lrVVFJaOhsvYA2/goc2j29Q6PR9fj8FznYHcVdu2K60Pyspvh3cMNd25zUve0GaM0IH/mQq3liP2D5iiOVpBl2pMD0g6SXj83ay1Rmcq5xno7wmdydeI3TWGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTOwOwKW7UPeQhjFSr+q7fPvs2ELSRaFrsWIFg3Dcf4=;
 b=35Wu9+wfcZlr976cDK1i+93l915pvvTPw6979zFtIjLBCfjQsR4e6/UnwCUOs1b6oMfdrMPfNqxuK5m68BnkpPqbMAGuAsB+uUsBKtzV2QkOZRHDtBaqcphA/ZgsG785y4vWCESZ+QcjVUCOjEBKEN3rmwLz9/NSI+bwF1OA2uA=
Received: from DM5PR11CA0005.namprd11.prod.outlook.com (2603:10b6:3:115::15)
 by DM6PR12MB3980.namprd12.prod.outlook.com (2603:10b6:5:1cc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 06:22:55 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::af) by DM5PR11CA0005.outlook.office365.com
 (2603:10b6:3:115::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Wed, 29 Dec 2021 06:22:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Wed, 29 Dec 2021 06:22:53 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 29 Dec
 2021 00:22:52 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 2/3] x86: nSVM: Check #BP exception handling in L2
Date:   Wed, 29 Dec 2021 06:22:00 +0000
Message-ID: <20211229062201.26269-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211229062201.26269-1-manali.shukla@amd.com>
References: <20211229062201.26269-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3943b854-7810-493f-d1fa-08d9ca93a58f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3980:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB398008E60BA590AFEBF9B995FD449@DM6PR12MB3980.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ncpHevovM+m+Nu1XOsUQzXxKBn/hssEo9Qbh3wVMI//N8L1vEgZQrvAFfa4b9X6wea4OTHUBSloqYWdk1CaeQB+otrDKQQjsZVcRmzyTSd391nu7e9GHbrrBw5Hby5Umjvo0DfMZ13fh7fG2hVXzDD+IZP8IARGgSrUizCbtXBiom7An369BjRVwza4LGb1zAwCr4HN52gR67XbNBRSXqghA4/LnWzES7d+Py9+YuKPCH2o1dyhVHTbllH0JKNUPylvHjVd+aNuWcHeTZpdyiAwORcObn8EA55RYkFnhJbT1x0UdGfMZDbbEttZIYHC+uFLExCdLkW47i3tkfxxh2syuVaPM/5wyyttKF/6vtRtTKVBD2UY1zQ4GdN/JSvDEX+R07Oe0zHAo/BYgx/aaC70hKyxCx3aX/f4uy6LD2R/nzcVEtXPGRmCjRFJgOGI1XroEVnQ52zk5KiB/zA4bJrFe9B/V54PZzwLkjZiyzojun8ppCvyPBb9fcnG9nKYTPEfW6oK4t1XVZ2grxwl6fylYEAbUlWwj7f1C9U2KOwD1UQnEppUs0x/h8r0GOLI2mh/Dqz0nEujjOr4Wx66BI+aOa7mxOPpCtJDwk7oZu5OgbCX9A6ijWZ0/8rAq1oWvzOQppZtuESXPiYAq+2nYssN4Tq4Jht/0UzAMVaC051KgobSAgIhyOEOWjXGlyw+M8KG4CsJyQMiUSCwiib7hk16VY+ioTZIFnDuhNEtjR4ipgU4k80E/X/7+gy+H6wyj/1aCRDcn2pvaETuvfAhoHErpzCa2aFIaH4PPavAemqs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(316002)(8676002)(426003)(2906002)(7696005)(81166007)(5660300002)(8936002)(356005)(6666004)(36860700001)(6916009)(1076003)(40460700001)(26005)(82310400004)(36756003)(336012)(86362001)(508600001)(16526019)(44832011)(186003)(2616005)(47076005)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 06:22:53.5523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3943b854-7810-493f-d1fa-08d9ca93a58f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3980
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add coverage for BP exception handling in L2 when only L2 BP
exception handler is registered

BP exception is generated using int3 instruction and it is handled
by L2 BP exception handler.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 681272c..ed67ae1 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2962,6 +2962,26 @@ static bool vgif_check(struct svm_test *test)
     return get_test_stage(test) == 3;
 }
 
+static int bp_test_counter;
+
+static void guest_test_bp_handler(struct ex_regs *r)
+{
+    bp_test_counter++;
+}
+
+static void svm_bp_test_guest(struct svm_test *test)
+{
+    asm volatile("int3");
+}
+
+static void svm_int3_test(void)
+{
+    handle_exception(BP_VECTOR, guest_test_bp_handler);
+    test_set_guest(svm_bp_test_guest);
+    report(svm_vmrun() == SVM_EXIT_VMMCALL && bp_test_counter == 1,
+        "#BP is handled in L2 exception handler");
+}
+
 static int nm_test_counter;
 
 static void guest_test_nm_handler(struct ex_regs *r)
@@ -3127,5 +3147,6 @@ struct svm_test svm_tests[] = {
     TEST(svm_vmload_vmsave),
     TEST(svm_test_singlestep),
     TEST(svm_nm_test),
+    TEST(svm_int3_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.30.2

