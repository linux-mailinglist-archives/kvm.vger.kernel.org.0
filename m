Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4466473305
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 18:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbhLMRes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 12:34:48 -0500
Received: from mail-dm3nam07on2087.outbound.protection.outlook.com ([40.107.95.87]:65346
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241382AbhLMRem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 12:34:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWGmM2eWYF+VETi5iZgaxVcJKpbdG+5YZ8Hp9DX+pmNhTqIxhv07Wh9OAldtsAWyzQnkOPk+99kww1+5OHmZmyD7+0j8Kuzt6RDkc+M53f8m5NO5ahloGiblRJgCyzFjCagjyeQt7FM6gXZJygsH6wRXEDHmj6hFmZ1LvSNyw6BNCZgob1bu6TOn75qELoJlQQRn+XNi/bKjTln+N3HogJ1AANJnI6cMrkf5+CCq8E7xSKyJL0A32oD9kgH9ifhuHKRO9/ByQBINSRAsDxHV9+el04IRzq4GJED1mYuxlrJ9mLQpWPIMdJX7bHktLPb0B3ukuXErYT4aMLpnErMC+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJXErsaXiq4AnBOKz0oGHD19aEPeb9FSLcZ4oZfBSQU=;
 b=WhQQ3Emm7rY4uLF+FA8hQQ/zxEDuhMZlgTPeJDAXs7UBBYcR8eHLT+YvGAAtlBDkgO+up0AudgqnMTQEYFKRGzbKweQC4pTLhcvfxThlEwNOL6WbqPyIfp0GysZWeQjc+EmVUqFWeTGLM3fJTQ1Kf1kpsq64/4sOcW31lVaGWyiKtbwhQy+fv9JoFXe1ah1VjG7KIuo0mwsUmNR37Vh678QEo2vE6srgGq2oUGcA/4vHwwyQ3o7vObYGQcWOIT2JY8g3onvdrEIxaQ8EEuVUokWn5nDsepzq2kp5SOhB6rR8nRKBiHaRGqB9/fc+7oSzU0+A3MQxoHI3APjpqWz1/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJXErsaXiq4AnBOKz0oGHD19aEPeb9FSLcZ4oZfBSQU=;
 b=G0qtNVuDaB2VFoABOXz8qXGZGOoAGbVJ3Co7Qo9x7vIPjPEsIkrN6sNAGkFg2cXsKLTBdZw5VaYzTU6SzgOWKjX82l+202XqIh1bw2KAvlw4kIo7ZYkRHJdn+OlnmFIJk9NOoiVxjrAzo51qAcaiA+++GZMfNISHokB7le6/78o=
Received: from BN6PR17CA0033.namprd17.prod.outlook.com (2603:10b6:405:75::22)
 by BYAPR12MB2710.namprd12.prod.outlook.com (2603:10b6:a03:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Mon, 13 Dec
 2021 17:34:34 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::46) by BN6PR17CA0033.outlook.office365.com
 (2603:10b6:405:75::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11 via Frontend
 Transport; Mon, 13 Dec 2021 17:34:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 17:34:33 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 13 Dec
 2021 11:34:24 -0600
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
Subject: [PATCH 1/4] KVM: SVM: Define sev_features and vmpl field in the VMSA
Date:   Mon, 13 Dec 2021 11:33:53 -0600
Message-ID: <20211213173356.138726-2-brijesh.singh@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 928da4e3-23db-4b20-87df-08d9be5ed3d6
X-MS-TrafficTypeDiagnostic: BYAPR12MB2710:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2710235D1BF4E2BFFE970D5EE5749@BYAPR12MB2710.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWeWm58TB0pwviRZOVgwIukW1vxVnjHuJZAzanxcCZ61m6W3xwLDuiE5sLW/cfGHlHbFystn0ZDwXVl13qsDZaBchiQ4kQ9sV1qLBeuBVIdoW/cAWDRnZzahiEJr76SNZUBiSfv8fVnBEqPwH5ahBWzIL1qOHBaFlh82m88loVXBPJdZ7h/Hy8sJaAuWcwuO5OKgBhhXkesGLrKkO7KrHbIapeLVI44DTFmq7/Mum6MeJlyQdRawzVoJI7B5u5k4fbxTcZEbjivK/iQ03CGGkriv4Cs56B8NjFgrYGtO6mpENPk46EIikl6Ci/33HNckY1M7pTPWYyuLzQszGazdalcRkJx1WkZT73WemDMGU3qKE3Dled71+U1YnSJLHamqjfCHSXxuSttpWeNDAoyub7wP9xfptU6kqHeebDfZnn2EFS1LDGBmoutLfYxcqZlw0ikRMfLcvjv6qDaIFzm/soy+qUtx+v4t3dO7hnx7A5aBN9xSYAuDB04RN6HiPEkDbEg8qRvoWnHxE8tJRDRJCaSCWScz4UAEK5fziFOosS0gINqJ8nUf9Ww1PC/BpyZzO58EzAV/fdycDYT9G9XW9JOdRJOSh+PjK7VSXd5ThE8IpN5lWuEtft65dYfgNwiigyC+43RfZ/cW/v0uMyDlitvP6pBdAJeVxerHnkIWIBMTceioO8Azv7IMAkpJM7ebXZrySEMQiZM7+QdVLviFPKWzRU8Bj+WbXxKjZJOWRcMKEDiy+0l1efwjswDsFO4Rn+30jxM4OpCZ++FklgxGqiBd7HcfqgQ6KKWGvChCocg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(26005)(36756003)(356005)(2616005)(336012)(186003)(5660300002)(316002)(16526019)(2906002)(44832011)(426003)(4326008)(7416002)(54906003)(70586007)(6666004)(40460700001)(36860700001)(508600001)(1076003)(8936002)(8676002)(47076005)(6916009)(82310400004)(7696005)(86362001)(81166007)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 17:34:33.9451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 928da4e3-23db-4b20-87df-08d9be5ed3d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2710
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor uses the sev_features field (offset 3B0h) in the Save State
Area to control the SEV-SNP guest features such as SNPActive, vTOM,
ReflectVC etc. An SEV-SNP guest can read the SEV_FEATURES fields through
the SEV_STATUS MSR.

While at it, update the dump_vmcb() to log the VMPL level.

See APM2 Table 15-34 and B-4 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/svm.h | 6 ++++--
 arch/x86/kvm/svm/svm.c     | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index b00dbc5fac2b..7c9cf4f3c164 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -238,7 +238,8 @@ struct vmcb_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u8 reserved_1[43];
+	u8 reserved_1[42];
+	u8 vmpl;
 	u8 cpl;
 	u8 reserved_2[4];
 	u64 efer;
@@ -303,7 +304,8 @@ struct vmcb_save_area {
 	u64 sw_exit_info_1;
 	u64 sw_exit_info_2;
 	u64 sw_scratch;
-	u8 reserved_11[56];
+	u64 sev_features;
+	u8 reserved_11[48];
 	u64 xcr0;
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e57e6857e063..d785a69c083d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3066,8 +3066,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "tr:",
 	       save01->tr.selector, save01->tr.attrib,
 	       save01->tr.limit, save01->tr.base);
-	pr_err("cpl:            %d                efer:         %016llx\n",
-		save->cpl, save->efer);
+	pr_err("vmpl: %d   cpl:  %d               efer:          %016llx\n",
+	       save->vmpl, save->cpl, save->efer);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "cr0:", save->cr0, "cr2:", save->cr2);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.25.1

