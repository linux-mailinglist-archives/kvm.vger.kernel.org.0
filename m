Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE3658E72E
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiHJGOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiHJGOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:14:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A5561B2C;
        Tue,  9 Aug 2022 23:14:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKjjC0w1ydT0ct8US3a79WQUfa4KTLM590/KKMJZT7drR/1MMXffjRjpNLfaw+Ex8nbzoLJOWsdNfYoKe1323xchfQQM+jlltltLEkhDejSPNWWN2uQkBWS21aBDKgNGyJYF8gMZuc9Z0Qt01mKffMHYLfvLlrDPspz1L5VTR8WaadPrQMeglppO/NOEGV5fx06J5ieBLls69Q3S+C5Y/2ctIhcLGGxHtxzqdSYfI6fHfSJMpese2w/iiJziE6EpoumMjJ7kdjg77SGwPtoelvgEUugHGDzG3cAbIP8Qn++4HtbyBvbUA97NCfofGoq/hFF/9ml4cVyZASJbojENMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBwOqhxIGGrJHDbjGcvPIsSk4XPM0bC7oeQv0qWEYMk=;
 b=e9e1J4/Kk2Qme5lL8tDk2GPUnfiDlq/wsKF9Zr5XLSebWfDOYiaAEoaEReJWhz6D/IXvnsXcaU0GxSyZ5/WsCsH2jMwPsJ5pHkQJvoW3fZsNwakjnQXUWR1c16IkotLtxVkTh1tjjSfS41y6L9QCBmZgIhLFj4OUdLnp+4k7Vr7LrZJpHPsLsaD4mFQpRQv1M9ZaSO0Qrp8ZERLLjUnS7VQDXQojXy9+xJtzZxfFxdW/XitN1LWSh6+iPwQhtiBqeRiE6Kn0H2pbauSC7yyWkl8A5pzO+aiksWGHudSvIroply+eyqn9HMbG3qxNk3RGrwSxTR4yto2M8mwHc0HMgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBwOqhxIGGrJHDbjGcvPIsSk4XPM0bC7oeQv0qWEYMk=;
 b=0qqLHHue0VlBY8ycV7Ms7+Kj1hPd4f6Qf0TJwND7x0cPZ1T57bRzjJGpZXsMf7PQikEPcLNpzEaDlhtd6OZ/yosyEMQ9N8XHvwwZ05V4+X2Gxs/73V6Lb0+r/Wn2T8KPANyvL/pVWymqEiZzwPJS8eD6JeGuT7lkmLxKAwWldoo=
Received: from MW4PR04CA0284.namprd04.prod.outlook.com (2603:10b6:303:89::19)
 by DM6PR12MB3579.namprd12.prod.outlook.com (2603:10b6:5:11f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 06:14:41 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::eb) by MW4PR04CA0284.outlook.office365.com
 (2603:10b6:303:89::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Wed, 10 Aug 2022 06:14:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:14:41 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:14:06 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 3/8] KVM: SVM: Add VNMI support in get/set_nmi_mask
Date:   Wed, 10 Aug 2022 11:42:21 +0530
Message-ID: <20220810061226.1286-4-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810061226.1286-1-santosh.shukla@amd.com>
References: <20220810061226.1286-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c02be749-98c8-4c3e-c3e5-08da7a979ca5
X-MS-TrafficTypeDiagnostic: DM6PR12MB3579:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jf1PEFY9I5ZVYUIpMswwV+RYXDqpIk1/CTa8riRnoLo0FX3QoAGQdS9PIeQwbqhUbDd0mSEQ3/cBr5AdQfnU4YIi2wCZHDiQM9ShghS6OGXIP7RWobxLN0A/fTmSTr+WA6NDI/0FxohKDLzfFSEJTEh9B0yX1YQZwU7Wf/f8mVS4OUNdymKxrJ9PaB7FgsKehG2hhE+sjk9n2oWzpwqIfJEarCehXZxVNZraj7/dDtmjvQ/cCbQdeYh7QRNtN8TrIj/vxHB61tINIe/j0P288qANY0eiMqsGoZB0p6NiiiwSkik4JsgNmVUZzPLzNjAKmJ4rwaaC2LEL1aNsPz47b3jLgiQta+GX/5Sy2edI6rcDAv//pR1cBvxopUesZfG1ZnT2KNsBBFpM64Q32S9/fq7QRTteFXrwNzEgoZ0SGP+7W2r/4Xtg3XS+dquNWwPl6vHxO3zPPhDLvpPVL9xVzqEC8qH/cXdR90IVbxeGCzaAK1tIOkDxoq+HQRGhWY0zChDQJrql9jntaS+5wlovaP9f8pCO1cB8TQeqGbqLWa99K1I5HbD5P27cdKIaW+FdSZf013NTgDXqGWGtooZNSArcYU+Ue/HVdh+uywchh9tj6ulS1EIKPh8cST45dDW8NHdM0MIrSaGuufuPbTi2g04xFErB0q7pv0NCS2qdbpFlqw0IirIjGwPbHu+YZos7hfIy1GcFcMChcpuvDKNzEnBxE1erDiq9lTaPa5d3TF8kdLb082uzgTp/HHEmaU2msBWIuuLzJr+Bw6oI8jQ3bN6Kv1bT1ojWYhzM9CaPeSHCPpNSEcTUT2g2qBMeopXBVoVM7K8ZiSyx2/dSEkp3nQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(36840700001)(40470700004)(46966006)(54906003)(6916009)(8676002)(41300700001)(26005)(5660300002)(336012)(2616005)(426003)(47076005)(478600001)(186003)(86362001)(1076003)(16526019)(36756003)(4326008)(7696005)(6666004)(44832011)(8936002)(316002)(70586007)(70206006)(40460700003)(36860700001)(82310400005)(2906002)(83380400001)(82740400003)(40480700001)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:14:41.1075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c02be749-98c8-4c3e-c3e5-08da7a979ca5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK
as read-only in the hypervisor except for the SMM case where hypervisor
before entring and after leaving SMM mode requires to set and unset
V_NMI_MASK.

Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
L2, and also API(clear/set_vnmi_mask) to clear and set mask.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3:
* Handle SMM case
* Added set/clear_vnmi_mask() API.

v2:
- Added get_vnmi_vmcb API to return vmcb for l1 and l2.
- Use get_vnmi_vmcb to get correct vmcb in func -
  is_vnmi_enabled/_mask_set()
- removed vnmi check from is_vnmi_enabled() func.

 arch/x86/kvm/svm/svm.c | 17 +++++++++++++-
 arch/x86/kvm/svm/svm.h | 52 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0259b909ed16..f0ac197fd965 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3621,13 +3621,28 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
-	return !!(vcpu->arch.hflags & HF_NMI_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm))
+		return is_vnmi_mask_set(svm);
+	else
+		return !!(vcpu->arch.hflags & HF_NMI_MASK);
 }
 
 static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm)) {
+		if (is_smm(vcpu)) {
+			if (masked)
+				set_vnmi_mask(svm);
+			else
+				clear_vnmi_mask(svm);
+		}
+		return;
+	}
+
 	if (masked) {
 		vcpu->arch.hflags |= HF_NMI_MASK;
 		if (!sev_es_guest(vcpu->kvm))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..cc98ec7bd119 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
+extern bool vnmi;
 
 enum avic_modes {
 	AVIC_MODE_NONE = 0,
@@ -532,6 +533,57 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
 	       (msr < (APIC_BASE_MSR + 0x100));
 }
 
+static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
+{
+	if (!vnmi)
+		return NULL;
+
+	if (is_guest_mode(&svm->vcpu))
+		return svm->nested.vmcb02.ptr;
+	else
+		return svm->vmcb01.ptr;
+}
+
+static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
+	else
+		return false;
+}
+
+static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_MASK);
+	else
+		return false;
+}
+
+static inline void set_vnmi_mask(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl |= V_NMI_MASK;
+	else
+		svm->vcpu.arch.hflags |= HF_GIF_MASK;
+}
+
+static inline void clear_vnmi_mask(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl &= ~V_NMI_MASK;
+	else
+		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.25.1

