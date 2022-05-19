Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1548C52D087
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbiESK1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiESK1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5705AA7E19;
        Thu, 19 May 2022 03:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chqYlPlkJ3JIb2FgvtKjldA3Fvo8Au4Vrpcmrg6N6MFocb4UscAzqQn7OjxalUk9mcPTiz5EYyEbhxNgEvpMMBQ1mSjgkQMSvkY/kx8zrkwgNeLyObGIYO4qhaDlzOKMcC/PoPtRJDRHXkfcow0neq4HZT1kIjOZI2mtFtFXkTkFtfm/1J4MuJcKUZDxWC2RBLIT61Y/9QKT6B3rinNhzQVot9arm4NKH+R5/mGgjmKZ8ZxXnnZ6S66ftD91v9r9JTJTWe5GRXoYo1IHFVboFzA5WBVI75wxt83eZpw/4AdGTanNjCjWQ2ldzB6L6O/hn0TvopHEKGOcj2MRDdJlyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mDW86IJiGH34cAr0v8eFBvuoANA/E9jIPQE627h34BM=;
 b=L4GZvD5zJlJfMCYkiI98X3V8I7eX1mBhm6dojrt3C69U2ZBP4qz4r7jBr3MIhrj8LP8BTaWbQBZJRh4//jEAvYcMNNY59yv3c03fvPUqSfB79r5VpyX3RXitYvKf+0OVf8KMBE8sBuXJmNE4TZeqldgljPtAlzPAq2Lc2evvEIJAlZJAyXRJXnO/d/GYCtufS2K32kWZCaHldLXLmOPU6tKOrL1OsnCtU3WVIQdVLutziCvtMmIKJ/uNF028GBZ+Oi0CIcFAF7hgIFt0Y3bf4ieP6+/1CQ/Ltmbm3YGgAsA6xAzDDGJso08Z05bJi1cIdMUhrNF2gvTvm+tIThIepQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDW86IJiGH34cAr0v8eFBvuoANA/E9jIPQE627h34BM=;
 b=iA8+JK9pQOhEDG3I+7xb+oUiyNn3Zh+htgR0+uOAzmHU0su72pr7h67vpd9zx8b/PiMjTUsDqqDT9G/yqmMB3eq7HqU6SX6W68s2jQ51FKJD24W9ZL2/EcVFfb8rpTtIijLN86z+V8RaB88Qs0uu903m9D1JFqCKj2pa6XeKkNg=
Received: from DS7PR05CA0038.namprd05.prod.outlook.com (2603:10b6:8:2f::23) by
 IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 10:27:33 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::ee) by DS7PR05CA0038.outlook.office365.com
 (2603:10b6:8:2f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7 via Frontend
 Transport; Thu, 19 May 2022 10:27:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:32 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:31 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 08/17] KVM: x86: Deactivate APICv on vCPU with APIC disabled
Date:   Thu, 19 May 2022 05:27:00 -0500
Message-ID: <20220519102709.24125-9-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: f7b88594-d063-4b0e-a4ca-08da39822f72
X-MS-TrafficTypeDiagnostic: IA1PR12MB6435:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB643520848BC4AD0D653FFDCFF3D09@IA1PR12MB6435.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5l4p86j5bJm3kea7zl16WBltj6lNWplwcR6lMxPPnpNseocTONZfpcEu+1+ssLfZVOTTxHmmH4UWkaCvGUaXtm0F3cCoYoZFU+OzJ8eEPL270I73sPZLKVAhcxiZfXAeoENmEl2Rtg17uqTmhGbzruXvPkeq+rJrnCYmWQJsyZoPvxfaZrUxyD0bJUcB5b59tMjJ3I51lgkJpTPKCilcFY6yQqLee+Nj6WbwXudQSP7z5PTO4YaxhiarG9/t2CRmEFgR+xgitdvTgcBjB1mSo37zkJEcnWpFcbClkACA2zG+WGtuhvLWMx7VTYa6Hd8LF2vKRroMw1G5kh7GUVjoSBR0M/iI3rRA04EpANtpn/2dpm6i07SzPtQ60K4K40eYiF/eD2zwrcJfPyHdWjeczO/f0O20Hb+AS3Kn2T10NcQSp2dpv9mqkdlcPQMlQIKrY+5ePCBOvGBFCDHNqPuuBnj1tV75smx8oWgI2A8wWwJt5n1TzqAmRJonUaEXYduos+aClOd2MiFWK43IBbuihpqqQeNa+S6f4dxefGSiArwbvFn9hX+MK4ez3SjuzUzMvQKVVQxEGFaijHADAuCAmu7A61qRIx2bQ3Z28Rxgqp6onf30N9mw95sb8v6DT/Ml6Oxpgm+6Y2MSAfhnrx8dceyhefMYHR+hNJ194xbk9nMbvQXJ2E87kEres+RPZNfHPJ8j+YbgABAI1lTTttCveg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(4326008)(16526019)(8676002)(81166007)(6666004)(54906003)(356005)(2906002)(26005)(7696005)(86362001)(47076005)(36756003)(110136005)(5660300002)(70206006)(426003)(336012)(186003)(316002)(82310400005)(1076003)(8936002)(83380400001)(40460700003)(2616005)(508600001)(70586007)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:32.9826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b88594-d063-4b0e-a4ca-08da39822f72
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6435
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APICv should be deactivated on vCPU that has APIC disabled.
Therefore, call kvm_vcpu_update_apicv() when changing
APIC mode, and add additional check for APIC disable mode
when determine APICV activation,

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 arch/x86/kvm/x86.c   | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8b8c4a905976..680824d7aa0d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2346,8 +2346,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
-	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
+	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
+		kvm_vcpu_update_apicv(vcpu);
 		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
+	}
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ee8c91fa762..77e49892dea1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9836,7 +9836,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
-	activate = kvm_vcpu_apicv_activated(vcpu);
+	/* Do not activate APICV when APIC is disabled */
+	activate = kvm_vcpu_apicv_activated(vcpu) &&
+		   (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED);
 
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
-- 
2.25.1

