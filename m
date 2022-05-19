Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3359052D07E
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiESK2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiESK1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B70BA7E31;
        Thu, 19 May 2022 03:27:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmQfA1kKYPsW/OGAgfOqoYzfLelpzBVizwDnlSAbqXRXDAgHQUmm20dd7p4sXFIpfFcPgjJoq7xGRPurUAw0CVTvNUuVYyxt7KRMBjn4rYtjq7wHCiA7tw2M9F/v0bKwOFPYBQT8B5p5qDhr1dP6eJyFCJLaAXFTQiEekonL6LoaiVyLI9mtN5S2YK8Mt2tEGuKP+5ckCbqZxNeYz26aDkY8rFAYPcxRnH85Oup3nAcGecvis67oZGkFjLTl85gDimlqrsC7Zsg4cuBYnzqZxLFsPEISdJhH3Wkb1/j/Zpu8pwMtLcUoIRQBhex+BANgP6RtE1rIsGwlzv+4TLUa3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXunKw91AziOXjcu05kGRHnt4FdkawppGowMHSMaU3Y=;
 b=HatJJHyVlBoYuyCNo5AnSzgh7ceIoqqZQSf4OxwPxQ+S9WpmynN0a/87ijnli3fRkbswgKxxNTSnaQg9iHtZjhpt0vAQWCCbBUGTiPNFChrfkTezDxJ4ke8mCGvX4GBQdRBpdbOAgr9rBR4q2h2OdW5y9WIpgGC2fROGFTawPTcBnjEHl5IWwgxYgBM9EZ57Xh+ulDHtxs8aJpV9MzEcKQ3vck/5JzH3ET/5fzdLBnDXY0mNHqMGDXyWeoFzd3+cGQMC/N/z1HCwrZmcrNuskxaQwsRmalj0+/bGRAQhqE9G3J9xD2qkNZKqIKFqfYiXbojYnsjPnt/3Z0crOlruyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXunKw91AziOXjcu05kGRHnt4FdkawppGowMHSMaU3Y=;
 b=VWei6o61KGkMsFyEFJjqNwFBbp02W3RPRdHQkHOk0O+cQkA4vb0HtVbO2GN5kH3gC/waXyzzkvMk6IJ0MOMuHz6WUPiBsikDIjqTiKTw+iupslt3pFa08bPyEsP7BonrLzwmY9SmplfV1wUIzAImv4SvmrWnZ0lGaeM3taKkRLY=
Received: from DM5PR11CA0014.namprd11.prod.outlook.com (2603:10b6:3:115::24)
 by CH0PR12MB5300.namprd12.prod.outlook.com (2603:10b6:610:d7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Thu, 19 May
 2022 10:27:38 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::86) by DM5PR11CA0014.outlook.office365.com
 (2603:10b6:3:115::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27 via Frontend
 Transport; Thu, 19 May 2022 10:27:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:37 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:36 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 15/17] KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
Date:   Thu, 19 May 2022 05:27:07 -0500
Message-ID: <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fd3de3f-f8ca-4efc-a77d-08da3982325b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5300:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB53000095A0E833B8F77F0734F3D09@CH0PR12MB5300.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ass6eyHuyLA1kliYUpI4UFnXcT6oIVw1UBHLQ8gXXWocmJ2ZF8fiMCdDsICydDtC7OXIlIQY1GcpGQyAzcHPSn/MwF9q98+mS14GMuCd1Kd0zrrQeJJZn66Qtl71dS2cDx7ZA+QYyndlncOnaXtLGDOf0N5WgZ5siyjBDGXI49cErU5vy4654Qw8mFitng3T3bkfEU0NvrS0Q6C/1n9izpP0Q11h0B+t09EYyDlooj4suk9hUvpkxnf2K09sgCPwcdQ7x8Xn2JkosTxcjT87A6MiGw2qvVnj2OBGg8ZgNCQmd0PkbIdW4oyHMH2aT/Evh3V1/RDYBnb7glBcKR6u0PQiB59ejKaWl8zxKecAlcuHZ9T2zPKfDpDthz3EOARhT+AnMnx+5LDgL00SZeyh/EaE0xw4UlIaWeKmzcpzrX+Bo19D4cUnW2JTQV3z2mrug6h0FQ0dqKlKT1Zl/bS8zZv7OznyrYN2Q1ZDEDzC0ESsb0VjLdvDZILTbyGY77fn0iwPY1T0ZzqinKGjzegixEPDH8bj/0aM1QUbW6cR9aLV6f179Osew5VOl1tAMP3qlE14eN97nxdv4CwzNcte9A0YCcGMWoKzHiSrlW5C77WG91G/gtKEUPD0RDzfQ7rjIHooufqtjLANcf80a9ILuf8nQbtVtba7wCZIglxzUvtyd8NEyQ6mxCo8TxXwu6+YOtWzOptAw7UbMGSdSNSiyw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7696005)(8936002)(1076003)(5660300002)(508600001)(2906002)(82310400005)(6666004)(47076005)(44832011)(336012)(36860700001)(426003)(83380400001)(86362001)(40460700003)(316002)(26005)(16526019)(2616005)(36756003)(4326008)(81166007)(8676002)(70586007)(70206006)(186003)(356005)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:37.8651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd3de3f-f8ca-4efc-a77d-08da3982325b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5300
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

