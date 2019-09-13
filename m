Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEA1B259E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbfIMTBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:47 -0400
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:54616
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389568AbfIMTBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/yKZeA6kM+gU0EyxLPmjzbENxbEn2kXZPgtNtD+gfKYNIchq0PEujuI4uc2tdrcb3D07gDD8wda5o/1JyYXIuprBizHgP2HyQaNmo/T6Q87U0m7XiwjP5DwOX49fN6JOQGlfqESsFEJlHkGSMaHokV8zh6MFki8dJ9j5Vi1ywIob+v3RYJcZ5QTg+cNTOrb+ax1zDakaEgJ6Rcaq7GfjVXhdEFxQ6plcggYzSES8ag44LKrepVGhSEhjcRNQmmVmdEDWBFSNnqYrsfRKBaoSDmndZrDvhzACNHNvAOvBvp6lDFSPIzRnxWIpPjoqPmismMLsliO6dd7uz4JSzXoYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2mbJ8x2zpGjkWmTiXtQHE+COIaLNR5JeVCrdcZmiT8=;
 b=GPJpSZ5U64bBQO2HFmPudCsG/GQ7t/xq95O3DBEFAwYKeXeuN64CFwejXpzy4H49YPtlR9KckHVGtCkWsP0AXH30irftE5/HJx5cXwOFjMsKRtOZ9d99WNKpDk3qWLTCgfHJlEpws7Wc5UA0UoFjM4BdzkOf4CJj4hLeUAfIsUoQo/S58wuCAq+Sm7z760cARW6HRjjw6coQpSn8FTv8VKUWndOuTLkWMPISOEQFa7iWqjFKQTeUIqr4JZuf+p2WoS2SYCn+ozFn5U/X4iDYxh/WNqr4GXv90/oXsyVPlSBjiMLO06JwjJ+nOFPPQh+uAiAArgPjRcCBq1ptqFwzTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2mbJ8x2zpGjkWmTiXtQHE+COIaLNR5JeVCrdcZmiT8=;
 b=vBoyHDmdcbYNWqGZQ+YFvk5SyFCUpMHa/M74enoovMj+7qtTWWSEz7a/FIMlLYH4jB2i1H1gX/SatnoX0+VhwRZD+2altMStVyiT2AiT3SM3R9cDoHR2MV6qt5ooft8Ymaqhtu7Mc9v/fG04p3gts5sCre/BV/R1ef04ULsKf6I=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:01:04 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:04 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v3 11/16] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Topic: [PATCH v3 11/16] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Index: AQHVamWXlhnpjmvtL0StlhGcs+dG7A==
Date:   Fri, 13 Sep 2019 19:01:03 +0000
Message-ID: <1568401242-260374-12-git-send-email-suravee.suthikulpanit@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 430e7e77-ec1a-4e55-43cd-08d7387cb96a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3804A6F54C8005D9FC4EB52FF3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qpQCSLpW92F+T2cm1MS4fkg46UYbwdNKC2Oe21ls86Ud3O6gl/lyrxEWTmW9/+Q3GjwSUOdzDHwZwvl7gcsuKkUr/UsWFJYXxCmKnBfWvN036Hbwu22EZtfD+zD63gdF+LojC/CMicukG0T+s7vOEgWqmIU9VXWvdlyZcEPVyfrIl0RNwIzG+ieF+f2wO2GIFDSmof5ouTFrSvTYvzkTXsRZvMLVOXiXSy5KIJ3st+IhbjHNFaCujNk3GvuNnryKJGAdoBREUnbJPfLsQ09AjUYtMeISlNKZADIt36P5ZUmYlDyLzFDCw59E5zw2umPw8kd/TMhcBLPUei0qHiWL8Pn4kHPG36My76joJaDPIvxG88t2g/dkNG9cmsRC6xu4QubrcXAZNjdJw3zIVvXFVuu9xic49oJ5RkhwrWSDkGQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430e7e77-ec1a-4e55-43cd-08d7387cb96a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:03.9290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hG40IN01hUIXoWbRoHKx75S1Rb9Jsmf8CHzAxBuxosEJe/fODftV+whG+lUGCc5vlACb9qOR4S2N0uTCt02OHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD AVIC does not support ExtINT. Therefore, AVIC must be temporary
deactivated and fall back to using legacy interrupt injection via vINTR
and interrupt window.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e02ee1a..f04a17e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -388,6 +388,8 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static void svm_request_activate_avic(struct kvm_vcpu *vcpu);
+static bool svm_get_enable_apicv(struct kvm *kvm);
 static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
=20
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
@@ -4516,6 +4518,15 @@ static int interrupt_window_interception(struct vcpu=
_svm *svm)
 {
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	svm_clear_vintr(svm);
+
+	/*
+	 * For AVIC, the only reason to end up here is ExtINTs.
+	 * In this case AVIC was temporarily disabled for
+	 * requesting the IRQ window and we have to re-enable it.
+	 */
+	if (svm_get_enable_apicv(svm->vcpu.kvm))
+		svm_request_activate_avic(&svm->vcpu);
+
 	svm->vmcb->control.int_ctl &=3D ~V_IRQ_MASK;
 	mark_dirty(svm->vmcb, VMCB_INTR);
 	++svm->vcpu.stat.irq_window_exits;
@@ -5203,7 +5214,33 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *v=
cpu, int max_isr)
 {
 }
=20
-/* Note: Currently only used by Hyper-V. */
+static bool is_avic_active(struct vcpu_svm *svm)
+{
+	return (svm_get_enable_apicv(svm->vcpu.kvm) &&
+		svm->vmcb->control.int_ctl & AVIC_ENABLE_MASK);
+}
+
+static void svm_request_activate_avic(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+
+	if (!lapic_in_kernel(vcpu) || is_avic_active(svm))
+		return;
+
+	kvm_make_apicv_activate_request(vcpu);
+}
+
+static void svm_request_deactivate_avic(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+
+	if (!lapic_in_kernel(vcpu) || !is_avic_active(svm))
+		return;
+
+	/* Request temporary deactivate apicv */
+	kvm_make_apicv_deactivate_request(vcpu, false);
+}
+
 static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -5549,9 +5586,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-	if (kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * In case GIF=3D0 we can't rely on the CPU to tell us when GIF becomes
 	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
@@ -5561,6 +5595,14 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	 * window under the assumption that the hardware will set the GIF.
 	 */
 	if ((vgif_enabled(svm) || gif_set(svm)) && nested_svm_intr(svm)) {
+		/*
+		 * IRQ window is not needed when AVIC is enabled,
+		 * unless we have pending ExtINT since it cannot be injected
+		 * via AVIC. In such case, we need to temporarily disable AVIC,
+		 * and fallback to injecting IRQ via V_IRQ.
+		 */
+		if (kvm_vcpu_apicv_active(vcpu))
+			svm_request_deactivate_avic(&svm->vcpu);
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}
--=20
1.8.3.1

