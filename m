Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA928F076
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfHOQZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:27 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731484AbfHOQZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0GDCLmQkdUKHLx94Yw6BTwfnosjcWgpH9NejN8Y5ZfqqW+U8PVGk2eJS2WO3ASr/Su99mFTOTr1toxB4mF5NQkQTJ71IkfCPSd5UGrJ3EOl8wRt/T+9ZnCmlA4P81xdcQcQBn2vE+6BPIJDylkD0e3h3Ow8Sx1fqFwuUDacAooksgieDzu2CeCDPPqQh1E+32h5+BNc5EJNM1RwIloxtXjRRhv3T3Mj81KkKTjIYxD/l7n89Nds1GWqgEz+/ZdlcdibjQgySFFxRZIuPwu4yTtimwBFqfvbo4+etN3HhiQ4Pn4Rm/h9YFiAYfTkqWbts6sYw8PcRNd38dsIodsCzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0fviA2TEb+saXmSxWA71E9Wd9271qzdp8cvATOYY0Y=;
 b=I9RVTKnaw6+hEkx96waucxMqr1Q7O/Oz3sUe9ZG6hWi23Vuwz3woaIF0lOP53xXvssnGWpH/c06u+5GQ85Ot3eVABlzOU/7ywqncDm8efZFo40CaC1822gkUuTdsSfbciTVDu+nOMFM5ahBME++5INRnqsuGT36lNylWeSyukabPfHphQDDwszjr06zz9C2U4xG/Tu6uE5+FwQadPm868xT8h8DmhjddBxYVRhqrCKcGOnTMh2Sq6NAU1RNCa5GO/FfLfa42PNZfBkqr9HWx6TyA26V8l1/oUl2P5QPcV5d66OvNhIc3Jze8krfBmu1FG2obpuWrmYHmhchpTmSzAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0fviA2TEb+saXmSxWA71E9Wd9271qzdp8cvATOYY0Y=;
 b=oqSfqp1TsSARM3A/ycnxjOEIiu/agskGJD6irlI9HeW2G4JH0esSRgE5B1KzGqQE9K+5J6S4dypbYZrqjK4QlugNmK7z7eaPn7e8gR0QGo4hr3d4ZGLbQyXPha8pEVV6dxwzEC2rBG6ywQeZa/3QWlLSaAOCKDCYfwRHkoWM2bs=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:16 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:16 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Topic: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Index: AQHVU4YFgD8+7+7+rEC5OVevDFYqvg==
Date:   Thu, 15 Aug 2019 16:25:16 +0000
Message-ID: <1565886293-115836-12-git-send-email-suravee.suthikulpanit@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:805:f2::25) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74bfb17e-ee19-4cc4-0a1b-08d7219d2818
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB389740EE4B8629A27C59C0F4F3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: co4HjhFJCQOYkyomfrgdU6cDYhWWxeTtQtk+mzUvc+VizHAHEEckCX0oilDtjiE9lMCLjtbHu7zZwZ4VWF8+cbwY4SllceOUXoOdvwtIbgc02r+ljuuMjFV9F/uwx2OpnqwX4I1gFunKE1Lh3LYB6W7XqHT7m40Yen+wQjdT0yXmUFbWrYGE8RmgHWHEdTRjUmna/z9ArIR5Mj3NX251O5ZLsiaC/O9Y3OwI15wp/aRI5VHcm0GlhZvW3L9ziwyexAhd4g/v1+vKYJGF4o4EJ+r9gzR99zOcI/PzCDU0MlqJ0JK0NltnTwDuDaVh8cOjlKac9q9s5Yj9dtR1mV0/uOMDsD+TQHy7t2UaD6xI8t2XXjqVYlY9D+DeVnPDo1L/Md9paOuiKpgb/O8xQHEZkej4ZahlDXxI2omh8yUGtFc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bfb17e-ee19-4cc4-0a1b-08d7219d2818
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:16.5548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3XBxMaAoFVhFN/sXzx5tWxpvP0Uzj2FFB/EcAEb3PzD7iHttu56XpT34Q9+FF+oWFm1rI8wWPpR5yU4FBwAmpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD AVIC does not support ExtINT. Therefore, AVIC must be temporary
deactivated and fall back to using legacy interrupt injection via vINTR
and interrupt window.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 49 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cfa4b13..4690351 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -384,6 +384,7 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static void svm_request_activate_avic(struct kvm_vcpu *vcpu);
 static bool svm_get_enable_apicv(struct kvm *kvm);
 static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
=20
@@ -4494,6 +4495,15 @@ static int interrupt_window_interception(struct vcpu=
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
@@ -5181,7 +5191,33 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *v=
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
@@ -5522,9 +5558,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-	if (kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * In case GIF=3D0 we can't rely on the CPU to tell us when GIF becomes
 	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
@@ -5534,6 +5567,14 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
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

