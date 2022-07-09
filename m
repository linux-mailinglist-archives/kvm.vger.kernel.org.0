Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D061C56C99D
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiGINnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiGINnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:43:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CFB2A243;
        Sat,  9 Jul 2022 06:43:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3KjMSWvnbsIIjKEvUmPRkEKde5It+GolRTimFZPn6JsS1RIg9L1AP/1cvb05LyvFLtA/b5Fbt2zJCxH6dw+w+x8au2nXN4k6fSWYDfiRWl0tRuQCwPK6Ac5RrHiM3inUTiRVTHD1fC2TzUz/FFjlQxUgZBKUEz0H9EfEuBxCT34yAJPyaWjwu/2M31hxI+lF9KgZfDxlqvUi8rLcV3h60A2Zv8O8DF3JeoC3zIH3J9OsEwexWzKrbAClNC4apYw9D7A8VH1ot2QhwTIbq8QRwonUXnSlzSlnNz2BnPozrjC0G/Ae55UNvI2Vt8nUt/XUKIC0pT/zPz0OnrDbuS4yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuLAWyjcFvPe5L4IXWgWHUqzNoVbFPfUnhccGbGKIf8=;
 b=UbudUrxvLgCwzOY/pemW/dEMkpme9N1mkLeyIeVfAQEYuzCZqQ0WxcoCph7JpgddrSM178TjN1Oo2heiK7tvxDG9BxWnHVSpNTfrnEdB2k9eQOyothktSt5814Z3xx3CaynndDvV4WKuJ2VUVYKJz3ODG/jC1misrjjXrvFzjBxiDaq8KuP/XE2MT0lzHDHrifvw4DrcEkW89gwwj6qxKOpjG3zoXwTctgGh5khtfNb+ZNk/9yR1h1ItqjoG1frxZm9fLeNN3FkBuA0t1tWWBZ5W0olvHeAs347wyeAJs/LJwI2pUYnil5pl/EQSsvS6Vah2yOsJUvoP2Teor44B9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuLAWyjcFvPe5L4IXWgWHUqzNoVbFPfUnhccGbGKIf8=;
 b=M3I5yezxDrMhPGHnbiKvVu53kBqlMoqsCp3w3+XmU5skQC+chCujoexIh2S3MvGljdRBoxIKMnUq58ifEDOXidQGvv2LAo8RgmurzYmtBsfLuv3XKM8XZBDK6nC0vjluIs/XzDKTxIBWLWNe3IxxjZUMMqWnya4bQhcD2sNA/y0=
Received: from DM6PR02CA0071.namprd02.prod.outlook.com (2603:10b6:5:177::48)
 by DM4PR12MB6160.namprd12.prod.outlook.com (2603:10b6:8:a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 13:43:25 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::3d) by DM6PR02CA0071.outlook.office365.com
 (2603:10b6:5:177::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Sat, 9 Jul 2022 13:43:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:43:25 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:43:21 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 2/7] KVM: SVM: Add VNMI bit definition
Date:   Sat, 9 Jul 2022 19:12:25 +0530
Message-ID: <20220709134230.2397-3-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220709134230.2397-1-santosh.shukla@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7a30d47-eef7-4565-00d6-08da61b0ffb4
X-MS-TrafficTypeDiagnostic: DM4PR12MB6160:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QykM/ke3Qt90gMl+qzXRtROCBxfVxcKrszZxZTGF/lApHABJC92tCWKZa6jJJN8++LlvYSPj/iOngDOQmGxWppGbhv/yHJnxq/jFsCxm7Bk/PL5ks+/p++pXrP+AlywdjDssoWKIEXYaSzA1tE8ngF/VebUB/7Xp2+QINw7tnOGCUJe1CbH88AkL4v4Vgv/cscYA3bA3ivR/tU0Lm7pMf0gjUHNUtU0yQzmA0st6xYzTaUb/35v1IU0Un2iUl2J0nknrxXt+2vjvB2NpG7DXcou6HvY1rdjkICB3Brhf0IvU7CBv00w3kMl31E5nxMbT56ywbvwzIM/Ms8QgZvvu4thE9UIw00CFDLLkHNfNVpPnxiHMirsS2zSuXC0wj4O/H3+AZy/MmEhZHEt1FBmYO8/ecT5vpHGg+U/8vZPIHJXmBlZRzbQTLvnegJmSCOhxhl7s1RD0BrSrDSayja0Z85YvyZQhU35c+dzYbh7I6m1FrA3rpp4FFcCxXRF58GsQQafEflevd2dx5NwxcKuEwhWMF5JaWAqgtyHe6HReJlxjiQ6pnKUI/+f17LM0aXCXo6rFNGlCQWqrXYzobnNVRAPNf1BkEHfaqIQQKnnZO+lqz2fSRZrzXlWH1pGy2bsjb+pImIZj8xd4zmX/xtj85Zw8dRyLD6TKozuO3LoPUw7C8O0n+1+hffVSQl8r1czuyhCMw6zxe1RW3xMSxZyfQnJ3Ty8QyJr0pmJn6cZFnnRPVhnRZ1XEidI2+sV5sYXiEWNZ18QnRqPKHnc8pxlkqJCXJzblCAFH9VEiVwsDP52YUzfR9T8tqfEo4sc6zthGezFn8vo4iKWaBGKqTGQUEzY74T6GzVraqevjeFCAdVoFHbsoAxIyIswCGM5eTQ4Y
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(40470700004)(82740400003)(81166007)(44832011)(40480700001)(47076005)(16526019)(82310400005)(70586007)(34020700004)(36756003)(54906003)(70206006)(356005)(316002)(8676002)(4326008)(186003)(36860700001)(2616005)(6916009)(86362001)(426003)(5660300002)(2906002)(40460700003)(478600001)(8936002)(26005)(41300700001)(7696005)(1076003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:43:25.7534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a30d47-eef7-4565-00d6-08da61b0ffb4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
virtualize NMI and NMI_MASK, Those capability bits are part of
VMCB::intr_ctrl -
V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.

When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
handling NMI, After the guest handled the NMI, The processor will clear
the V_NMI_MASK on the successful completion of IRET instruction Or if
VMEXIT occurs while delivering the virtual NMI.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE bit 1.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v2:
- Added Maxim reviwed-by.

 arch/x86/include/asm/svm.h | 7 +++++++
 arch/x86/kvm/svm/svm.c     | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1b07fba11704..22d918555df0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -195,6 +195,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
+#define V_NMI_PENDING_SHIFT 11
+#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
+#define V_NMI_MASK_SHIFT 12
+#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
+#define V_NMI_ENABLE_SHIFT 26
+#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
+
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 44bbf25dfeb9..baaf35be36e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -198,6 +198,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+static bool vnmi;
+module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -4933,6 +4935,10 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
 	}
 
+	vnmi = vnmi && boot_cpu_has(X86_FEATURE_V_NMI);
+	if (vnmi)
+		pr_info("V_NMI enabled\n");
+
 	if (vls) {
 		if (!npt_enabled ||
 		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
-- 
2.25.1

