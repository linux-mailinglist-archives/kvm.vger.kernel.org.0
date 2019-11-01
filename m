Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041DAECB87
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbfKAWlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:50 -0400
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:60224
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728111AbfKAWlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2IFKz7enuPS1832uyyFyjImNHKa5QaS2iXBFwhKCzkE5mzc03uQy5EXRhduPcGu2Lt51ZfMO8jpr+NFUrn8U+og/jdkMA1h4pw1RI/IUA1DtInqNIJLZfA0R9Yo2QC89+kh4yyNRHuHitwdfx/3PnkuOeUGuyBykjOgUcp8es0PWS0rjRq3l+WnFSWPsHi5111zgE3tk6OK4sd+GZCaU7EIJEOR7qRjTkscsMYv9gj7fu+jybxWzgQMAje1QDCXiB3esomobSLs7aKtfCViaR133Bzi+My8Lh3EVvlTAJeol5V5/5K69LpUKQeA4gRy3zrCh8REyQb5wmtBoO0cBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnVBJ6mTvj+eS9z8oa/32ps1HMRlVkTCji/P04Ym34A=;
 b=b5NYHc6g0f361SpYPPfoO1Ep5o900KySuwOxlCs0fbyjtBGpkOi7F3lXPntWQMJ1NJAJl910E1dbhzYmfzVzCylFag7YctKtBhqgOofzO+BR4bNsVlqgqc5U18w+HdR+VI6lREhfrDe5LWC4fao50AvtTYZ7t7kPecqPQyIrDR2JWyNtM55c/qMoVEyGVUt2H9aYXPowAkGM5r2pnt7D8iLShH8cp/IGhPROfE4mn6kIB6eMGdh31/qPstk75W1dXSw1O0sUL0XAjgXIrT3rDcJcJb7FImHbJQxA54M4bwuehuKkiCPyBl4ZvGNX/gzYO4V4+7aZ5Y6JeKzibhoyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnVBJ6mTvj+eS9z8oa/32ps1HMRlVkTCji/P04Ym34A=;
 b=YQkmHX+66hQHuL3ya/YLOLhCmGaMWyRQM/aqLoBqNTcdXgqkyeLsBwpy7rSRYhwtJ5TuBOxW0FGVXxqxbuUjt4yo7asMhwb0wf8M4BzLkwydPDjiHcJohi3rbOJygGT2vJUBMvwryhB8jJOmDY6PLZoFr8rd+tihZ0UqXQhKOnA=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:36 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:36 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 12/17] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Topic: [PATCH v4 12/17] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Index: AQHVkQWEgZt6FvN2HkO+qT7S8/jO9g==
Date:   Fri, 1 Nov 2019 22:41:36 +0000
Message-ID: <1572648072-84536-13-git-send-email-suravee.suthikulpanit@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN1PR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:802:20::18) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e51b9ab-1daa-4f18-ab6d-08d75f1ca73f
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB324341A8C85BD2FE5BB985D8F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kcar/xFh0CvCtY6V+keASgrt633f/XVNiodfDiSrr7LUTLChSpYsKjtzxJH2nTmU+fqRsLm+zJhMseGYgO2uIEgfhYa1G4eJv4L4J7bID2AHttNxq3OB0wKi4U9nCXkgF/rQ598F2cecgjJHN7cImNB2WvCflDEFzMEgFQYvRq4U+o222bx4hfWL28MwFcKlUHaHaLAWo0yZFh7sDETVEqWq4FjFUt5+Lvg8j1rSM+6g4GFRsrWqcmzmpUVFFiOaQLjLtdCProOi9J6MsgdQKapQMoKyMRh6NPBNQk2dwos4/5Q0DHrsyFpAUKp/5s778nzHNR+adKgiSkBniQNbrf96GXAl2//pnbz9kGTiY2ssmDUy0Za/5GIHw8+J70+KFW/Z77EqRFTbm8byLLV8vHaJjaBWQ7AYbPZSASwsi4MkCxddrRPXldBJt9a3uV48
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e51b9ab-1daa-4f18-ab6d-08d75f1ca73f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:36.7584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wblYuEeNiXVE0jPBumSpyjHsWT4df6z2+7UqrAh4BtCUqqwv86itnatfzQM4w8I1ZX+iH6yY7ULTfE511TY7Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD AVIC does not support ExtINT. Therefore, AVIC must be temporary
deactivated and fall back to using legacy interrupt injection via vINTR
and interrupt window.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 55d6476..fe61269 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -857,6 +857,7 @@ enum kvm_irqchip_mode {
 #define APICV_DEACT_BIT_DISABLE    0
 #define APICV_DEACT_BIT_HYPERV     1
 #define APICV_DEACT_BIT_NESTED     2
+#define APICV_DEACT_BIT_IRQWIN     3
=20
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7f59b1a..0e7ff04 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -388,6 +388,8 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static void svm_request_update_avic(struct kvm_vcpu *vcpu, bool activate);
+static bool svm_get_enable_apicv(struct kvm *kvm);
 static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
=20
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
@@ -4479,6 +4481,15 @@ static int interrupt_window_interception(struct vcpu=
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
+		svm_request_update_avic(&svm->vcpu, true);
+
 	svm->vmcb->control.int_ctl &=3D ~V_IRQ_MASK;
 	mark_dirty(svm->vmcb, VMCB_INTR);
 	++svm->vcpu.stat.irq_window_exits;
@@ -5166,6 +5177,21 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *v=
cpu, int max_isr)
 {
 }
=20
+static void svm_request_update_avic(struct kvm_vcpu *vcpu, bool activate)
+{
+	if (!lapic_in_kernel(vcpu))
+		return;
+	/*
+	 * kvm_request_apicv_update() expects a prior read unlock
+	 * on the the kvm->srcu since it subsequently calls read lock
+	 * and re-unlock in __x86_set_memory_region()
+	 * when updating APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.
+	 */
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_request_apicv_update(vcpu->kvm, activate, APICV_DEACT_BIT_IRQWIN);
+	vcpu->srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+}
+
 static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret =3D 0;
@@ -5504,9 +5530,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-	if (kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * In case GIF=3D0 we can't rely on the CPU to tell us when GIF becomes
 	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
@@ -5516,6 +5539,14 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
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
+			svm_request_update_avic(vcpu, false);
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}
--=20
1.8.3.1

