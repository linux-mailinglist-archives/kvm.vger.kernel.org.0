Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9675A46D2
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiH2KKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiH2KKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:10:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8E2E57;
        Mon, 29 Aug 2022 03:09:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSlRA0k+uNAL6AbqIHq+pIuBPGULvSM7cOLs7wcr87Hx+SxjE+mxRcx5zLK9a10lG6/6HafCcDsqvRBY0Ao7hi+lUefMyaU9mR99YZQBMADDik0gHYe0FraMIf0WsJdqL4YKwIZYYFh7yHPL703EeSntKxnniaextrJMbJ948RR1O0m+AsT7N6OHuzwZFTcZHjKZL+MeBDMV2kuHjLVTT/yoWu9XlKwjI53twH+lxEZF6JobCzZcjrv1kqTw32XQPUgvd52tLeQjTDyhiOmVlWlETFMyZ7OoT5FS+NVpvQsIlqMQWwkNABGE7b67HS+JPqiC4Q6dhdlzSIgCoe0W9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XA6vdXLhGOUkb5BTwjeCIo8SWwEktYYo72tm1B6l5o=;
 b=OtbKASs9IMxkXb5GEgsArFrEf7EDVxPp+/80F/yL9rk641zNNuJRI+7ukLL9ByxyLnXm4+N9r/AfrWl5gZVPZF0oe4Oqiu3uz8M9gOxnzFJDRPzUy/WOJq+g7644v8di3aigDfCWBwKpiGNDAlzwcFCc+zocsdLKY7lmHtyhmBGNyfflriKD/6+OqBvH/t/wZfydwB5IZkDSQYQ+0w8u8JoxsUCgoJ81sp1wSidCuSzrwMPSY5y/+ZfRpUolK6M5db49ezVZyhik6KoxzoukId6QaG/OA5lTGU5REbrBZkQXPb7fax9RmlnnrWtaysGqBXDotYsgAdEyKwtOkxx8Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XA6vdXLhGOUkb5BTwjeCIo8SWwEktYYo72tm1B6l5o=;
 b=z1/nMuNM1n9aegnaQCW8WDOhnrTXRNkl2OHKzjj8wSmpKdNXh4ve06LnDJvlJuKoLlA60e1/VvUCjwVDlDdmEMB6P9ihIF/YOCXv3W2/AZZyQ1xC2bNPNKdUGxib5Axw6VpDrTUPWxlRSHnDwMtA1vsM3WRzI2iMSkiW0i9Qzt4=
Received: from MW4PR03CA0154.namprd03.prod.outlook.com (2603:10b6:303:8d::9)
 by DM6PR12MB2955.namprd12.prod.outlook.com (2603:10b6:5:181::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Mon, 29 Aug
 2022 10:09:48 +0000
Received: from CO1PEPF00001A5F.namprd05.prod.outlook.com
 (2603:10b6:303:8d:cafe::65) by MW4PR03CA0154.outlook.office365.com
 (2603:10b6:303:8d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.18 via Frontend
 Transport; Mon, 29 Aug 2022 10:09:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A5F.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.7 via Frontend Transport; Mon, 29 Aug 2022 10:09:47 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:09:32 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 1/8] x86/cpu: Add CPUID feature bit for VNMI
Date:   Mon, 29 Aug 2022 15:38:43 +0530
Message-ID: <20220829100850.1474-2-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829100850.1474-1-santosh.shukla@amd.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c5740cb-54ae-409c-b95d-08da89a69aa7
X-MS-TrafficTypeDiagnostic: DM6PR12MB2955:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTj3AyArotWsznZbFmyx2To/rReI6tPyMtXQCRU7PezShKux2g3wypWqoUxTp52Z3G4TfLV9u98M0w0lBwuUo+xja1/jR8omXSM9fA7R7R/IkBhtuCn//Dm/8lfbSPHovkkovcM5iqUklvTm9tcsSq1ovlrBc/DXy05OkyY+hqD5UXvAXiASRyfBdz2Q7hwN8GQrGTklk9zeCplEDHRCiiCVv6rIm7i18s/SFdG+qtwRtBDdcBs0EROPY9Ie2vRJP0WzrGBkdcCdpoZvlXvnl9tyNjNO4F8pYWndCBRe2QZ54ASPa4+o+sWYfOA/PssbuhYrSFAxehp2K76hMBdh+cldFGPD6pTRp7wGV7YdhVh5s98CpG9Oegf7j3i9SnzZuJEAE4XYYw9yWwWZs77iBNMkvYiOKENAhXZ7P8NQvWSGnPsX+wNA+RmR3nv0YAtIITItN5EEKhKXoTZ6hVEkg9cAKLJPl2cWLssnUE/6daVIjlfKrRnxub6sroUV9IydC4GYBRmPhJR7lIQsxxn3m26jQZL2esVMJWJl7h6vDZy2EuZ8sOr66AglmZj46yO5eUSAcXZxjEfSzz9GQrYx2NhJXUypH5LCq1bs0Utz4fMPFjxYe7SA1/1FPmUVphCJfHij0KEuXAvQxDoU31IAf/iHp6H/Grv6hW6qXRkQibR4oO2KP0HqzHkknaNit8rO/zwkZKlYd0X9E5baK3p+5s2rXAOI5BIPDMzXSiKsOrrELspU46xMJLiy5d0+csnpIvoHB1CPmNnZ+NNaXb+Gu5cdFnm98ztLcipcNcynilBV5d2rQc3XpI2NtmcuVmpR
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(136003)(376002)(36840700001)(40470700004)(46966006)(6666004)(86362001)(7696005)(26005)(36756003)(426003)(336012)(186003)(16526019)(2616005)(47076005)(478600001)(41300700001)(1076003)(40480700001)(40460700003)(82310400005)(8676002)(6916009)(54906003)(70586007)(70206006)(316002)(82740400003)(81166007)(356005)(8936002)(4326008)(36860700001)(44832011)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:09:47.6575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5740cb-54ae-409c-b95d-08da89a69aa7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2955
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI feature allows the hypervisor to inject NMI into the guest w/o
using Event injection mechanism, The benefit of using VNMI over the
event Injection that does not require tracking the Guest's NMI state and
intercepting the IRET for the NMI completion. VNMI achieves that by
exposing 3 capability bits in VMCB intr_cntrl which helps with
virtualizing NMI injection and NMI_Masking.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ef4775c6db01..33e3603be09e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -356,6 +356,7 @@
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
+#define X86_FEATURE_V_NMI		(15*32+25) /* Virtual NMI */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.25.1

