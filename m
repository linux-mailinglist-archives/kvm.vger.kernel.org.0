Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217EC473303
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 18:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241405AbhLMRep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 12:34:45 -0500
Received: from mail-dm3nam07on2087.outbound.protection.outlook.com ([40.107.95.87]:65346
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241360AbhLMRek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 12:34:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzpMO9fT1l+zSUSkrfD6XJ7QMmt4wB9lwXNuB36+dEb22XVZCDVaB9A0k8dJVVv2vpQtFGAN7btfLNWXNV64+FPRbM6lxeHf+ty7leSwslbsF2o8OIZxq2CVC4OeJkrSHkBn5jaDS2Ah3wQeDSu3pKccL2WnyCD3P1OgsXXpRdZcKdn+O0zNj3LMCEsGGK+XD6aErhM1+ERfgWp6btdmFyhgvy9PJRpEskt7kLmoP0uOb2tCdi8ez/1al6IG6pNOYcMBguFGAyxXLf72V+4ZX+R2ifMvj5l8XCkBMSmEGiiWIcXbf9Kfk4aMaVqKQbnuGaqBE2kVySBQ3OPEFa4B7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWdTGxes1QVQwa15EBnHEnXYqoT2r+wHLhrsR9xj5z4=;
 b=jnYv8ZQ62ZFWhT5MEpBeqrAu4JXMV6r68du5W9RLvp2OqaFyhsqKj/EZr2R4Wd8kipZYbOmdk2V8QsWqOZCJmF4p7haMzgfxJ8j7ZyJd3TnKtiC27cvs79qyIYGeN+y2iFl7gNtEK+Jg9lcsla/2c0a1oPnLwtUGjlBeR+UliVP4nmIimkwRAxFntvQXHGj2lAzX4HpEp6nXkvJbddr6u6Vbnok9P+8eWdB5M4XQND86TEzhSQ9l5mJekodvQoXC54IVvbH6mhdOfn9E+z/Nuy8moX4+ftlpsUJDK6wZt/2QmiTHhrz3FXTe5DPwgaS8Zw8Oe361xzm95aERt2fIOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWdTGxes1QVQwa15EBnHEnXYqoT2r+wHLhrsR9xj5z4=;
 b=n0MPp7vfNolCjt7oU/E+MdauLSakoXj3p/70cv86Yn8fnzrHW6giwiMORlnAneL9j4o33/SR9TKUAl4odbvjvzpDZPveuBpBO16iFTx18jWL24XmGUWSRJa230U3gdMt3oQT54zg7qjA5KEJpsvbA7q27ZTOtviAO/FO04LfZm4=
Received: from BN6PR17CA0033.namprd17.prod.outlook.com (2603:10b6:405:75::22)
 by BYAPR12MB2710.namprd12.prod.outlook.com (2603:10b6:a03:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Mon, 13 Dec
 2021 17:34:35 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::a8) by BN6PR17CA0033.outlook.office365.com
 (2603:10b6:405:75::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11 via Frontend
 Transport; Mon, 13 Dec 2021 17:34:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 17:34:35 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 13 Dec
 2021 11:34:27 -0600
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        Borislav Petkov <bp@alien8.de>, <hpa@zytor.com>,
        <marcorr@google.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 3/4] KVM: SVM: Create a separate mapping for the GHCB save area
Date:   Mon, 13 Dec 2021 11:33:55 -0600
Message-ID: <20211213173356.138726-4-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213173356.138726-1-brijesh.singh@amd.com>
References: <20211213173356.138726-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2873742c-f714-47bd-974d-08d9be5ed47f
X-MS-TrafficTypeDiagnostic: BYAPR12MB2710:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB271094C93BF2086432FAD4C4E5749@BYAPR12MB2710.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ae5ebNvGZ+6Gp7qv+mTO3olRO91uMIfzsDVI1y/0II0eLJwlXJAtlcDFqoG3x2lRMf+7Ij0+iZ6nsvkcAPZWISx366JqfRXK6rpSSeXzRM31Jqu8DhZQdYoaKWiiCGQ3hwElgbRz6yQIXgR/qQA1gDt/BP1V50cRUOvWcwb7nebNMOfiBGQlVm97rhf4/mekJ1sU3UbY39WZaFJE3MMfUt6YO1gYAGlX6Hp3cp36O7xYxHhGiH4IUTcdOLHAgGKvVe1gX+wlvbCRlGvDIDk43gqbqUtb62wY9UGYNTBI7vH1S5n/8MO1oVliTtRs4hBhQ8fku5HDNCSSUMPs4cLSmdA1TBSL/IxOOYOflLoX5e7CKiZRnkqeiNwf5mhFNzXcCKQk4ZInibVy4IO4I2QZHPtBEoSTsklrEYOejnCQtTaO5dkun7oiQLbDeLq0ucwmGCCxGc4qdHJJ1ncvZNhVqsSaJCyDxHTsTTtImFstVWh9xR9sTxelIORx97PwfkDAEJLAgWl+1SEqpS0F/n9jpJAdVrJwnMgjlI957uEKzkE0qYT0xKz8NgR26RfuhUubg56ZncnX1kEKUe1/SXYNHw/3VKG4KLspUWwCUSGccDs6FtCzLyqgDCn4YwmR5IQct4vo7M8NiTtC3wtLaYpS9WyltKGqVck75xnNtUMxHpWkhaxRiJDxt75oFicnyWuY6bOcqU+JdW6XLlpGbNGUyLfLGVED3FnfXFfVPJtxw/nkmM2eg636MGBRvGafl38W0kUEDDPs53P0Jd6eQQivO07IInKCBuwQSAOoRRPwmVQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(26005)(36756003)(356005)(2616005)(336012)(186003)(5660300002)(316002)(16526019)(2906002)(44832011)(426003)(4326008)(7416002)(54906003)(70586007)(6666004)(40460700001)(36860700001)(508600001)(1076003)(8936002)(8676002)(47076005)(6916009)(82310400004)(7696005)(86362001)(81166007)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 17:34:35.0541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2873742c-f714-47bd-974d-08d9be5ed47f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2710
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The initial implementation of the GHCB spec was based on trying to keep
the register state offsets the same relative to the VM save area. However,
the save area for SEV-ES has changed within the hardware causing the
relation between the SEV-ES save area to change relative to the GHCB save
area.

This is the second step in defining the multiple save areas to keep them
separate and ensuring proper operation amongst the different types of
guests. Create a GHCB save area that matches the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/svm.h | 48 +++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 3ce2e575a2de..5ff1fa364a31 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -354,11 +354,51 @@ struct sev_es_save_area {
 	u64 x87_state_gpa;
 } __packed;
 
+struct ghcb_save_area {
+	u8 reserved_1[203];
+	u8 cpl;
+	u8 reserved_2[116];
+	u64 xss;
+	u8 reserved_3[24];
+	u64 dr7;
+	u8 reserved_4[16];
+	u64 rip;
+	u8 reserved_5[88];
+	u64 rsp;
+	u8 reserved_6[24];
+	u64 rax;
+	u8 reserved_7[264];
+	u64 rcx;
+	u64 rdx;
+	u64 rbx;
+	u8 reserved_8[8];
+	u64 rbp;
+	u64 rsi;
+	u64 rdi;
+	u64 r8;
+	u64 r9;
+	u64 r10;
+	u64 r11;
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+	u8 reserved_9[16];
+	u64 sw_exit_code;
+	u64 sw_exit_info_1;
+	u64 sw_exit_info_2;
+	u64 sw_scratch;
+	u8 reserved_10[56];
+	u64 xcr0;
+	u8 valid_bitmap[16];
+	u64 x87_state_gpa;
+} __packed;
+
 #define GHCB_SHARED_BUF_SIZE	2032
 
 struct ghcb {
-	struct sev_es_save_area save;
-	u8 reserved_save[2048 - sizeof(struct sev_es_save_area)];
+	struct ghcb_save_area save;
+	u8 reserved_save[2048 - sizeof(struct ghcb_save_area)];
 
 	u8 shared_buffer[GHCB_SHARED_BUF_SIZE];
 
@@ -369,6 +409,7 @@ struct ghcb {
 
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		740
+#define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
 #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1032
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
@@ -376,6 +417,7 @@ struct ghcb {
 static inline void __unused_size_checks(void)
 {
 	BUILD_BUG_ON(sizeof(struct vmcb_save_area)	!= EXPECTED_VMCB_SAVE_AREA_SIZE);
+	BUILD_BUG_ON(sizeof(struct ghcb_save_area)	!= EXPECTED_GHCB_SAVE_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct sev_es_save_area)	!= EXPECTED_SEV_ES_SAVE_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct vmcb_control_area)	!= EXPECTED_VMCB_CONTROL_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct ghcb)		!= EXPECTED_GHCB_SIZE);
@@ -446,7 +488,7 @@ struct vmcb {
 /* GHCB Accessor functions */
 
 #define GHCB_BITMAP_IDX(field)							\
-	(offsetof(struct sev_es_save_area, field) / sizeof(u64))
+	(offsetof(struct ghcb_save_area, field) / sizeof(u64))
 
 #define DEFINE_GHCB_ACCESSORS(field)						\
 	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)	\
-- 
2.25.1

