Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E818655281E
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347579AbiFTXSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347376AbiFTXR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:17:27 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3EA22BCB;
        Mon, 20 Jun 2022 16:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZJ3VM90YUU/YS/LXxddEX5LSo/+Au+2GiaXxn9F9QbO4NF9b2KIJ+HZI3I/rkz2YXrTHncyvh3kuSqqBT0NdZ4c8ToQTtvg6EqM6dExB8Og2l5zD8Lb7fh/sUMF5iD2yyWSm+smCJmZx2bBKwWLzO49YhtBrco6fTJlj4E6xirD+/wepaZoMWsQEAvdMHAd7hM1jfYpdV/m/lG8jXibYBQ/nS1u23uMsEgpQslUTUl6HYU+1uY9wD017hGDkZXcYikM3iWkvPwAi97WSELmVbC26Si515wbwH8FhzOZUtYzdLwZW6bKMM4dlWRtv70JHLMSp7e8RbpkpebisAg1uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOwqeQJBWbTq3D+SGHMabA30j8KbbnLE7BMSvMkl0RM=;
 b=d7ApQewoRqb5B50O+ickrrD7VGbI9cRsQyzJ/ZNmIgyzt1JKD+8bn4KB8/gXs70I6S+mQLSUe/6l6o5pI5ab4pkzGBvCKlgpG2Y+mefbgTycl8EzKeFZrMt8UhtBBs30dob57LYXG24OOh8ZWZ/iQWqHuMDT0/Sj5pC7eLJGKfJjBfjmlxj8ZuEJfWRoDumCe1X4APyceG/K5+atiXfM0ND1wcHx3eE+7U730Q7Ipr2FNQavujdJRp1WSGs5Rn2PIdZhn5k1xiLC6i0A7d4/fci8l7oPoNK1IecgiFNQfNsQ4HvV9XB49J8M50K+FtAqzmRgyQDevKAh83mw6cE/QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOwqeQJBWbTq3D+SGHMabA30j8KbbnLE7BMSvMkl0RM=;
 b=jBKmI2yf5Wsopas1E4dyjFuDv12H5485i7Upuovqyc2s9grpXWIlXOVEnmXPMkMWqMmbLkHfgmmUAJ84g4NlPs9x3zZP7YLRKO3j24aXWco74MlFg061u00t9ZCJy8FD5qNeoR9PvHXJxqntUdZCegBioTQ9nezZgx4AEdSSRUc=
Received: from SJ0PR05CA0043.namprd05.prod.outlook.com (2603:10b6:a03:33f::18)
 by SN1PR12MB2496.namprd12.prod.outlook.com (2603:10b6:802:2f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:14:09 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33f:cafe::6e) by SJ0PR05CA0043.outlook.office365.com
 (2603:10b6:a03:33f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.10 via Frontend
 Transport; Mon, 20 Jun 2022 23:14:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:14:08 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:14:06 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 43/49] KVM: SVM: Use a VMSA physical address variable for populating VMCB
Date:   Mon, 20 Jun 2022 23:13:57 +0000
Message-ID: <9e736fb6dc69bffe6c2414706323b88223fc0c5b.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d243474-27a0-428c-cfea-08da53129427
X-MS-TrafficTypeDiagnostic: SN1PR12MB2496:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2496FE3D864618CDB5CCD98D8EB09@SN1PR12MB2496.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KboMwrglr3/LyjRqycTrYlp1aflOq+ANhoTIjJzSSjiAP4AeyX3U+V2YSyEmyI7lc1lbibcSON/Pxby0cHtzTHfz0VsFPM8NXjb/HyBZ77b6xNWN+x8wlyMCJy1iZ4bRyetvqbN27SeGN6j3lUTGteKBPhLVf/yNs7SBjCZnPq24wKd7OoMekLCD+zIEJ1muWLg+HRB9IrSnFfY0A4dqeytZ1VWN4Y54bluqxCIXpMdqkWVD8prEl2qoTKaYyqr9IbNAu/R5aiMm7OKa3UEOrFmJRbC1zva0D5d36rRwhtEddYvOHVPe7AdXoYuA0A/sDf2CPAKWS7SeOEE0ugSTjDd9mQreBdwi6zDPA2PYirirWgIe3rj5fEpzOZs77d9QNISnXMnt9XlylQIcfHlW5mfYRNMLaXRWmzq2fAda9Lh4akOKyCOP2dshWsm47uk1e/2onoEb6/qCbWEYQ1D0LHYoh0uh1lPlJ17myloD+CiG1nk6fdPR0soCoci5ugsOvTVwxS259nUl8fLCIGJA6FVeSHF18+GQBidkd3FJ4tqO0d6TgYuPRslwbTWzfXR+E8/Bwl3+hPq9sFYcQonyxvhVz0cdkLygtvacab1kV9sBgky81beA6I7gV7FFJMlkZkxrIBfmxeA4DTJubDPKBC+B9MCsc1Eq7N0LHH2KPYSm0wQQCR1qPZQoOjO6lqsG4/SaqKZoU/v4w1LkphnvhofI9P9+TfS8Xj4i14k7eZkQZetNZ5svwGM7l8DXoQa3R0SZLP4HJUsSyjegx56s3w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(136003)(346002)(36840700001)(46966006)(40470700004)(70586007)(70206006)(336012)(8676002)(4326008)(36756003)(47076005)(83380400001)(2906002)(426003)(316002)(16526019)(186003)(40480700001)(54906003)(110136005)(478600001)(8936002)(7416002)(41300700001)(7406005)(2616005)(40460700003)(36860700001)(82310400005)(26005)(82740400003)(86362001)(6666004)(7696005)(81166007)(356005)(5660300002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:14:08.5562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d243474-27a0-428c-cfea-08da53129427
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2496
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++---
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 089af21a4efe..d5584551f3dd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3980,10 +3980,9 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
-	 * VMCB page. Do not include the encryption mask on the VMSA physical
-	 * address since hardware will access it using the guest key.
+	 * VMCB page.
 	 */
-	svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7742bc986afc..f7155abe7567 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1296,9 +1296,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->sev_es.vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->sev_es.vmsa_pa = __pa(svm->sev_es.vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3be24da1a743..46790bab07a8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -197,6 +197,7 @@ struct svm_nested_state {
 struct vcpu_sev_es_state {
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
+	hpa_t vmsa_pa;
 	bool ghcb_in_use;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
-- 
2.25.1

