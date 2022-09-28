Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0310B5EE32F
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 19:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiI1Rbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 13:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiI1Rbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 13:31:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C95725E;
        Wed, 28 Sep 2022 10:31:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhxQ3LnJ9Irnoc67zsDnxdd5PqKpOVCUbDfxUAOFQ+EMBAuwCgHpIRwX2Fr08ZXO13IP3gr+MrzOPOF/ia1P1WMb2NOx8YSOrRIZ2e+4rxafD1WyAxVJN9co60Y+nxW0X9sFWDTLk1QTCwIPfNjYvJQ3q2j29vXsRpceHfnLoPIdbRnIudFcWJxXVit02SRSUE4N3s1yVGikNlLx0P6cUFpGVrbXnIr3mxx7dOM8alFbpoBCQhWFB7+x64mGUZPybk0hOxsq566FVRkDR2+WwcD4pVTe/Nz72T1e+wazveMTYX2z1nwKDjpglQ39SX+z7nbrenFmrYQEc4nKzbThNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+AAUhTEJS9+0uqL4pLU1Jj7/9anhujllFzYXTHlRpM=;
 b=DadLdKuJXN60ODL22s54oZbZj/QbINKS1Egs+rBVTToqwDCx36dweW1CGVRkw/1Yhe5m5NC8JZJbbeIdDnJKT20OJzLfsRkqB2YgDDg75ZqWmSwKpOpb96nEUmKheuZafGNOXmJA2hWlpgWM2I8N7HkSjYNIn8sED+H77PhNXVtnyELDJirj14gcCSZD+85pZRTdT2xWF3PHeB+RzM48T8YiHTtlAiIXozLN8w5J3sA4Vmvf0y4hfTnpW6fFc2P2aUwo3Q8hWdRJA2EUru+CyXzxiKHNdlmigIwZiC7awk2xPU6HFDtPPdDSOLfls0FT/Q7bRuOrX9PY2DYUVh4Jqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+AAUhTEJS9+0uqL4pLU1Jj7/9anhujllFzYXTHlRpM=;
 b=3zUvJwQPhfkbhlIvJfEUzFksr5v8a0zGaNNsFUq7X+/E4r2ySXLxldz5M1EMf5D9QyVRaewRr6h61P/UXyednSuvlkyDG4WVxJGmgz8T1Oz04BNzS0WC67u8ofDAqR01fOvZgh9WdxSteiCFMRlVxJWSGswwkMcmOm0lm0mS//A=
Received: from DS7PR03CA0231.namprd03.prod.outlook.com (2603:10b6:5:3ba::26)
 by DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 17:31:43 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::4c) by DS7PR03CA0231.outlook.office365.com
 (2603:10b6:5:3ba::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Wed, 28 Sep 2022 17:31:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 17:31:43 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 28 Sep
 2022 12:31:43 -0500
Received: from ethanolx1adehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 28 Sep 2022 12:31:42 -0500
From:   Carlos Bilbao <carlos.bilbao@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <bilbao@vt.edu>
CC:     Carlos Bilbao <carlos.bilbao@amd.com>
Subject: [PATCH] KVM: SEV: Fix a few small typos
Date:   Wed, 28 Sep 2022 17:31:42 +0000
Message-ID: <20220928173142.2935674-1-carlos.bilbao@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT041:EE_|DM6PR12MB4354:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bfe8a46-c07c-43d2-8b6e-08daa1774f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ew5o00R0RzotH3uBYNlIfcjg2qGR/g8xZF7dRKzn1sGDL1JydKTPl1N2Mvs16UJdc9CdtRDgDwQ9JcQVod5lwaSapQ0cGaFC4jvkimx3tZymPnY7/Nl2YSCFKxfV91484i9U/ksNPNCusOh0Yfu1UPMKPOi4y4RXtJvNYgLJ+J/K8Vjh8s4jHl3zus3m2ZAeuP9Fha7fazNDWdR5GmIJo/k+61E3wAkgznaFQcTjRD+zdhy0PAt0L89my17+wek5G8uURvPTK/5l7XlXF8G5Sm3YRabTN3oM6J47JRpt+XaynvFDO4SEvn9lQMR23OcS5FtsgNHUpKi9TBqIatqobjqBVVJyxWwpmb/aElnY8ki+LPQguXr6QhKe0aEOVlQ5kmuZSIqnVPW6qo+gDbb5KXgUNFXhlAbURwx+dkt32IImV1vv7VFdwLwfU7vKbdWdM7I5kuqpmojwd9vCZY5cVgH49yIAQ5UBwbkcz2djEkNasocG9I+MJT5jS6DzBj7+pMK5lzxH1CF8wZU1dlhpEuYu4ZEYlRpnHXBu2aQPShxUYNtHf0XhfwpzSfZGEbvrBWBjBBW7MXbHbFvxgqU1y8AiNqqlvPaPz1LjkY/FqC6oOziyAyfHKvyVp9DYLF5o9U6aokfEVSmW1L6Wqb+xWoosCrLk/drVwP9AqSQGJ1dvzBSrOa/ENdh97RehFqDnhtQbLGKczvZoGyk78C85c4YUixU1c6sJC62J4Uk8gtDtr9oHmVv0iULVvUkJhUe8L/Xfl7E9KVvw0/Q0DYiTNpp6Iz/a9sXn8Ql21w93PO6J/rAsQ4GLwmn20y+7Hot+
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(7696005)(70586007)(44832011)(2906002)(40460700003)(336012)(316002)(478600001)(110136005)(186003)(1076003)(41300700001)(82740400003)(36756003)(26005)(81166007)(2616005)(5660300002)(40480700001)(86362001)(36860700001)(426003)(70206006)(356005)(82310400005)(47076005)(8676002)(8936002)(83380400001)(4326008)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 17:31:43.3593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfe8a46-c07c-43d2-8b6e-08daa1774f92
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4354
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix some typos in file arch/x86/kvm/svm/sev.c.

Signed-off-by: Carlos Bilbao <carlos.bilbao@amd.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f7fe0008bfd1..107fa0f442b2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -668,7 +668,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	 */
 	memcpy(save, &svm->vmcb->save, sizeof(svm->vmcb->save));
 
-	/* Sync registgers */
+	/* Sync registers */
 	save->rax = svm->vcpu.arch.regs[VCPU_REGS_RAX];
 	save->rbx = svm->vcpu.arch.regs[VCPU_REGS_RBX];
 	save->rcx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
@@ -2585,7 +2585,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	/*
 	 * If its an SNP guest, then VMSA was added in the RMP entry as
-	 * a guest owned page. Transition the page to hyperivosr state
+	 * a guest owned page. Transition the page to hypervisor state
 	 * before releasing it back to the system.
 	 */
 	if (sev_snp_guest(vcpu->kvm) &&
@@ -3150,7 +3150,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 				return PSC_UNDEF_ERR;
 
 			/*
-			 * Mark the userspace range unmerable before adding the pages
+			 * Mark the userspace range unmergable before adding the pages
 			 * in the RMP table.
 			 */
 			mmap_write_lock(kvm->mm);
@@ -3510,7 +3510,7 @@ bool sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 
 	ret = __sev_snp_update_protected_guest_state(vcpu);
 	if (ret)
-		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+		vcpu_unimpl(vcpu, "SNP: AP state update on init failed\n");
 
 unlock:
 	mutex_unlock(&svm->snp_vmsa_mutex);
@@ -4170,7 +4170,7 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
 	/* PKRU is restored on VMEXIT, save the current host value */
 	hostsa->pkru = read_pkru();
 
-	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
+	/* MSR_IA32_XSS is restored on VMEXIT, save the current host value */
 	hostsa->xss = host_xss;
 }
 
@@ -4223,7 +4223,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 	 * Allocate an SNP safe page to workaround the SNP erratum where
 	 * the CPU will incorrectly signal an RMP violation  #PF if a
 	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
-	 * or AVIC backing page. The recommeded workaround is to not use the
+	 * or AVIC backing page. The recommended workaround is to not use the
 	 * hugepage.
 	 *
 	 * Allocate one extra page, use a page which is not 2mb aligned
-- 
2.34.1

