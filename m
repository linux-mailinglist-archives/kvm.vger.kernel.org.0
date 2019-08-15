Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC68F08F
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbfHOQ0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:26:18 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731387AbfHOQZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXPn2B247+ON19xgzRMR9jetK/Lb9tr/FZlx3tlLhms4fGlMKcAGrlOeDIq9hDKDHDc0WJytA/wsdBtjZxuT91t3PCNEs7DpQ8lRnw2ObWX8Oubg4HbbTLZR/ZSwpJylXe49dK2bP8RqpPo9NIaArh6mq8SuSei1/vRixKNJFpzUMSUs4J2MI1QAh4334TsX7QLIQ8Cz/vPiWSMyupodiYrCTLOi1b18NM0y2SHokbayjFTcQRN66iIGLkoQ/q25vSWOtOIVNco1NTLfzP4OFfFBIlhpHnbCjgTqolPSX8Li0v7rSNiU+8eHuHR3+R+ryziYFIcVvZEQBJKRG71v3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=claQfddXoySPATi0viSt2FRSYorKoUcPPVZ2ZRqdkwY=;
 b=lsvOBRspRcFjYZSc4yzOATUy1iVniYPsIxknXOMNgn6C+omT03g3T6xecXNUH7l18mWJxtBdQ7Be/PG6WTZavU/JBIikrlLrTNVPreBbDqTKhwCTlDUM+rRmQ0ZcOI5uvckPiN585NBFT02xLifC5T22qHaIHZEHSNtbA8CP9C3rzyWkECnjhQN0u3FRL7w2UzYv9mXeN46DCrQspR+sTkMQrSCC/swYvqYEG69Rz5jyTV3DfFcwKUxE1x1J9O1iZRkyR5naDuaINbsXbaHn/1voa7L8PknCVyTmhpkEPAESqklLNvMpMy+7cwygbjbpcWdP23E1Ca+0HYeGB82I3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=claQfddXoySPATi0viSt2FRSYorKoUcPPVZ2ZRqdkwY=;
 b=Fz0A+g7joZRS+kkNIfERCOVC9wNc/PoLVhfptZ0sErlse+fZnkL6ukpZuWsdnQDWBZMFZcs9AdM1YG1D2Dpb5ydDkZ9KqmeE9daX+KS8BJ+Qgzg9nUS8FyKT2tZjW0dpJrC5d4/4odeleGYr/cH2zu6AON2+cZb8iUm1n4Y5gjQ=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:14 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:14 +0000
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
Subject: [PATCH v2 09/15] svm: Add support for activate/deactivate AVIC at
 runtime
Thread-Topic: [PATCH v2 09/15] svm: Add support for activate/deactivate AVIC
 at runtime
Thread-Index: AQHVU4YElSYfJMJmYUqw3vLmchIw3w==
Date:   Thu, 15 Aug 2019 16:25:13 +0000
Message-ID: <1565886293-115836-10-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: b2d0ad4c-41e5-4bd0-433c-08d7219d2699
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB389781A929772D0415B93C15F3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:390;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3wVnezxRdf8CTeDbdcTPEolfOs6Dxx29bNp7JhKEn4xbRcAJ2pPIjC4auPT1zjAX9M1b3WeKXWttnRl3Q164JZ6TPbU/3ilRAFBDgilK4/swWHHXCnCZfTvCNyk67+mGgU/sD0NIUF1i6iN60MOQktP6qbbx4PY4mQXOMJ/STwcYuyg35djRbkvIhFZBZetIYrJXFqYJopsXLj4R4Ej97xJt5b196pixpYqQKrgsCJEvmokKFRrFAnuncLw2vYFYQ4XE3u782V4fj5UbWLDfc5KLeJAtqopivw9HR++qr7uZ25bK8tEBfbeJLdXKZuWQuNWg9ab6UpZCqzVH76HwyJG5NEdoM/4ALEZ7d0A1Zt3esAO538L9Jm7/OyKRNkWQ+uGHh6gqfBYnypoGVEHRUFgDftvPBokY4SXGGWD6bbE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d0ad4c-41e5-4bd0-433c-08d7219d2699
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:13.9323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVW5MXkxHCH5Vw3AYLu3ba8EW5WOBuGzPjHUFYnMR2/K92kOy1TtV9ytcBzlf2WpPHtOxIPZaOKWKT9o0gnS8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add necessary logics for supporting activate/deactivate AVIC at runtime.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 47f2439..cfa4b13 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -385,6 +385,7 @@ struct amd_svm_iommu_ir {
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
 static bool svm_get_enable_apicv(struct kvm *kvm);
+static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
=20
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
 static int nested_svm_intercept(struct vcpu_svm *svm);
@@ -2343,6 +2344,10 @@ static void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
=20
 static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
+	if (kvm_check_request(KVM_REQ_APICV_ACTIVATE, vcpu))
+		kvm_vcpu_activate_apicv(vcpu);
+	if (kvm_check_request(KVM_REQ_APICV_DEACTIVATE, vcpu))
+		kvm_vcpu_deactivate_apicv(vcpu);
 	avic_set_running(vcpu, true);
 }
=20
@@ -5182,10 +5187,19 @@ static void svm_refresh_apicv_exec_ctrl(struct kvm_=
vcpu *vcpu)
 	struct vcpu_svm *svm =3D to_svm(vcpu);
 	struct vmcb *vmcb =3D svm->vmcb;
=20
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (kvm_vcpu_apicv_active(vcpu)) {
+		/**
+		 * During AVIC temporary deactivation, guest could update
+		 * APIC ID, DFR and LDR registers, which would not be trapped
+		 * by avic_unaccelerated_ccess_interception(). In this case,
+		 * we need to check and update the AVIC logical APIC ID table
+		 * accordingly before re-activating.
+		 */
+		avic_post_state_restore(vcpu);
 		vmcb->control.int_ctl |=3D AVIC_ENABLE_MASK;
-	else
+	} else {
 		vmcb->control.int_ctl &=3D ~AVIC_ENABLE_MASK;
+	}
 	mark_dirty(vmcb, VMCB_AVIC);
 }
=20
@@ -7229,6 +7243,14 @@ static bool svm_need_emulation_on_page_fault(struct =
kvm_vcpu *vcpu)
 	return false;
 }
=20
+static void svm_pre_update_apicv_exec_ctrl(struct kvm_vcpu *vcpu, bool act=
ivate)
+{
+	if (activate)
+		avic_setup_access_page(vcpu, false);
+	else
+		avic_destroy_access_page(vcpu);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init =3D {
 	.cpu_has_kvm_support =3D has_svm,
 	.disabled_by_bios =3D is_disabled,
@@ -7306,6 +7328,7 @@ static bool svm_need_emulation_on_page_fault(struct k=
vm_vcpu *vcpu)
 	.set_virtual_apic_mode =3D svm_set_virtual_apic_mode,
 	.get_enable_apicv =3D svm_get_enable_apicv,
 	.refresh_apicv_exec_ctrl =3D svm_refresh_apicv_exec_ctrl,
+	.pre_update_apicv_exec_ctrl =3D svm_pre_update_apicv_exec_ctrl,
 	.load_eoi_exitmap =3D svm_load_eoi_exitmap,
 	.hwapic_irr_update =3D svm_hwapic_irr_update,
 	.hwapic_isr_update =3D svm_hwapic_isr_update,
--=20
1.8.3.1

