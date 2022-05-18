Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F4752C067
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbiERQ2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240211AbiERQ1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEA1986DD;
        Wed, 18 May 2022 09:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWpcWt6D9TG/fZw35N9G4dw4nzwlyVQ39VmU9hAwITMvKKRnW6kyda+UKoaoaxYHLAkPa/E+DT9AFT8MoruOfogkhFXBC6oVnuLJV+7T/DvASxW0g4806GSqyi9zHjn3Lsq4n5bU+KAgUsBWeQYj4U59mQIfDZh+G4yfjx23DfLlwxSUBB5jol4dduv+Zh2lEgI0yOLdHoEDaBiN9i+HLt7iJc1fHyHOVS4DevOk10Ms8wbWC6bMYPE1by+5mogQEQxz9eQ2pahpbxBhLhkid6xjyhRxpkQhP7rXGFpsi+kKl2cg0rZzTtKrlG5C3gzk2Hry6cV06zG6A470Vm7GhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXunKw91AziOXjcu05kGRHnt4FdkawppGowMHSMaU3Y=;
 b=h9QawsoAfRUumOTF05TkAmGt00qzofGaGMzOsxn837Lnqy7ENNeVqe7pAG5Elq8ZTDvJBYmyqpjnBga2Uh6hQT7zo2MzsSnlmb4Z++AHO98xZpwbvznCTrMY9xi3REmKcPlEFT+KORXwvdw77q3iacfyxEj27xk/D4vqZdX2ni/oXyMD10Ht2OGyWljMmXeVrbPOiFuJ5DRa9cbafFCerdT1Nf0YPfiW/9nt4JWkSRcMvPA460MnDuPdvNTVlEk2FGF92pAh6JBdlWnMM+Zw2W+EkYNHvnTqeRvy5bFZkDlE+oYg9ZkbAXyertuLCS7XQ0ETzcM2nFO09nKTw6IXig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXunKw91AziOXjcu05kGRHnt4FdkawppGowMHSMaU3Y=;
 b=5K3el0lSJx1aFKdrTMlN1rQMYymoZUAgKZLl3vW7HeqjyjQJOIFJXTVJrALguqKNMppSs4GI2orq7VUZQydo7jk9dTPBX3DktKQrqbws2w68TKhXrEn2z+pLZfSBSE/fgkT+bRE0yErKcWnAosyDhQLCuEb/rPEkgrzRydyK4xA=
Received: from BN7PR02CA0011.namprd02.prod.outlook.com (2603:10b6:408:20::24)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 16:27:18 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::e6) by BN7PR02CA0011.outlook.office365.com
 (2603:10b6:408:20::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Wed, 18 May 2022 16:27:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:17 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:16 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 14/17] KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
Date:   Wed, 18 May 2022 11:26:49 -0500
Message-ID: <20220518162652.100493-15-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fd94a5d-fd5c-485c-3a72-08da38eb46ab
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5176BB780E458B88A5F923EFF3D19@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCqVeXDBEPyzbuyT6/2rYVGNDGkWZM9v7J5JFuRqwNhlqPNiy6sEh89RAGII+VoKq+4MzsywT4ttSP8FxmazYUFL23XPkUSK57/3mVchLwz85SwjCcG9i6A1367Bne46QjM7R9a9+U1j0qLY6lmhScy7hnHeVwbVscaYoP4xTgBJGgxTHP/e04rktLlGc0+jrtx7ItH7K0VLlbJ0Ue+6fytvKTLCWZ35HyQjcdPoOyBSpwf3KhQxoNU+/97CzWDjS/QuNmv8qKySLJQjminy5HRlnE9iOJCNB4yNfLP90uMWakToBWzkv6AQyhVBnrtRJQwuOI4L21cQ1w5F14VuwkwoEj5M/z2G+6buRowIMEikY2c+1k6OHZ43uFmfyM3g41oCaNSF1qeNsrgIPgt7AUC+C3woVfL/QQab9ILGt2fwEJcmreNkxw4u/65wMGKrfrgFPXP0qUny9B1/Pm/UHY6a/6T7Nq52oqI6dW7r+b/vNBLd3S4VPLFStgLV8Y4Rai9ty8ZM8G0zy3DYXUtD5rJ+OVLs2n5XhLN6SjesxpicN0UJr57mfNvWhMfzX4PeDl1KwWqw1rMin3j2JywzsJ8dz8yBUq3XfcRcKRLyuiDxTvoQbBvPLZVf9qwA3ORaeYm8NkF4AS7ZgpI6WvZgLf5ntCDmCWi6PTZlDcVYUYfWbco/Va7BAD14RLTq3VYYvePpFZsfgUrIOTlxIOOK1A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(16526019)(7696005)(36860700001)(356005)(2616005)(86362001)(508600001)(186003)(44832011)(81166007)(8936002)(36756003)(40460700003)(426003)(47076005)(70586007)(1076003)(316002)(54906003)(82310400005)(110136005)(4326008)(8676002)(70206006)(6666004)(2906002)(26005)(336012)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:17.9662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd94a5d-fd5c-485c-3a72-08da38eb46ab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For x2AVIC, the index from incomplete IPI #vmexit info is invalid
for logical cluster mode. Only ICRH/ICRL values can be used
to determine the IPI destination APIC ID.

Since QEMU defines guest physical APIC ID to be the same as
vCPU ID, it can be used to quickly identify the target vCPU to deliver IPI,
and avoid the overhead from searching through all vCPUs to match the target
vCPU.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bac876bb1cf1..9c439a32c343 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -358,7 +358,26 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			/* For xAPIC logical mode, the index is for logical APIC table. */
 			apic_id = avic_logical_id_table[index] & 0x1ff;
 		} else {
-			return -EINVAL;
+			/* For x2APIC logical mode, cannot leverage the index.
+			 * Instead, calculate physical ID from logical ID in ICRH.
+			 */
+			int apic;
+			int first = ffs(icrh & 0xffff);
+			int last = fls(icrh & 0xffff);
+			int cluster = (icrh & 0xffff0000) >> 16;
+
+			/*
+			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
+			 * or more than 1 bits, we cannot match just one vcpu to kick for
+			 * fast path.
+			 */
+			if (!first || (first != last))
+				return -EINVAL;
+
+			apic = first - 1;
+			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
+				return -EINVAL;
+			apic_id = (cluster << 4) + apic;
 		}
 	}
 
-- 
2.25.1

