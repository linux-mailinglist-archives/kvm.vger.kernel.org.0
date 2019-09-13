Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D2B258D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388800AbfIMTBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:03 -0400
Received: from mail-eopbgr820045.outbound.protection.outlook.com ([40.107.82.45]:25312
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388636AbfIMTBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ev9BqenTYztXSHRjdB5N+hTYiAEFCXXN9ENe8tfarBEEp/TIJH0i8HrZY3srAWOx3EjLEwsUkHdPngvGlhs6xxbdduoPOV8Y7YJc+2VxsS9vqPm7URJm6ifT/mc7cZjyBEUtlqVMes/3hNj6NJiBvIiLkxRC+BUa5ciIDg9OF7j8meo+kIT3LIF7arPLGhbflKJ4EhEwJHbp3aQxN0bA4K/WT6WYc6xLUgfhSUil3QtptLwB7VIPJvU0Py4hIQsjiyOoMwqOdxCaMNseEbkWHWqd7SjNnizqvSS906QmLlPaRy5TpkrXtQPBlo5gh49Ib6tYU3isFeSyYLsGkOXtLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoQXcQXpfgbLmYOLvCTmJFS9j5Wuq0dWRvD3x5Baq4k=;
 b=CQ4Z+jv3cI+v5QQbCeGpzlc7uR1ovoaWyvSM38iCUL876bPbxukoKKJHajWM1vVLahEMoIwJvCcDq6EBW2cvqaOPOZO1BmqIQW/LDav6z3mabv+HGJz5EM3w6tRCWvyBFsvsgsB1AlPpFgbRUEsGeQJyHZpukllUVkPt23HLRcbZLxUPESH4icO5+Ydh8/InxZkmSJACQsNt0+SaUIRZHWhDZFZ3bNGTC4jCeDUPThg6n1Dr+U0xeJaSpTuuPNnZ01OLkR1qnJAqaB9UrYUCQgnGJBwzy/KPh0MVXtf+IzZ9G16npKW2T//De9vJRAscwJNUXmOI3OPaxkxJVmDeOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoQXcQXpfgbLmYOLvCTmJFS9j5Wuq0dWRvD3x5Baq4k=;
 b=jgOz/Y5MWorZpFUr8NRz2HM7Wf/R377dKeLvSHY6YDuLoEen95diMJU2qzNgB/oPLZVtaM9JXcf7MUtQ5S3kWAsMS4ZhjsGy9za0HUHKGr3/NfmrEdeDe+jOSV3K1XjcANvFDHUrKeSt1s2Ze5gny7UEOQgU0gJy0jCcExH1l9c=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3596.namprd12.prod.outlook.com (20.178.199.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 13 Sep 2019 19:00:59 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:59 +0000
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
Subject: [PATCH v3 08/16] svm: Add support for activate/deactivate AVIC at
 runtime
Thread-Topic: [PATCH v3 08/16] svm: Add support for activate/deactivate AVIC
 at runtime
Thread-Index: AQHVamWUl/QPE3RtYk6dp3s3XPyzAQ==
Date:   Fri, 13 Sep 2019 19:00:59 +0000
Message-ID: <1568401242-260374-9-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: eb4ab6ee-f40b-49f9-c3cd-08d7387cb6d7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3596;
x-ms-traffictypediagnostic: DM6PR12MB3596:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB35961D933CD8054F6A8CF357F3B30@DM6PR12MB3596.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:390;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(66066001)(7416002)(3846002)(6116002)(81156014)(186003)(8676002)(81166006)(54906003)(6436002)(52116002)(110136005)(316002)(76176011)(53936002)(5660300002)(71200400001)(71190400001)(6506007)(386003)(102836004)(6512007)(486006)(26005)(66946007)(8936002)(66476007)(66556008)(64756008)(66446008)(4720700003)(2906002)(99286004)(50226002)(6486002)(446003)(256004)(14444005)(25786009)(305945005)(478600001)(11346002)(36756003)(476003)(7736002)(14454004)(4326008)(2616005)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3596;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oEebhmfpgwy600YWFHI3oI+SWEIXQZOSkz5ZAsIJSjHQ4m0DWvPwI8l70vza9b5nxPlYnaVfXpeclFj1mTuDcoD6Z+o3az95jjqsykte/p14N3pBGaN0k1rOEa+Jw0YySQMDdWtG3Wn9ywLt+gDUZ/nl6TygYDRE3fxZdu1oQfaoDLf8iR5iPoXDaVMeo9tXDLzLk7S9B1vFO/kapv3nw3ZaGpNGuaWeSf/Ge2V/bdqgidUO1i4oI54Lq7QWqYkdiB4lzqSOMDgHE9a4IZnFDpyXG+iiS+e0r5Zq3B5KlbS+sopbH5Tg8waCglCUhwMN12PGDNmofOaTIKcuBe6DkmNkvRvtiKU08G8Vn9LJFbymeto8USP2uQu9PsC3DVA8eNULEIGl1FBoCw2rK5BZeedUDmzozz9c32R1HdVlV6s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4ab6ee-f40b-49f9-c3cd-08d7387cb6d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:59.2867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BawgXZYdCR+6fCcQko6SoqrZotSby7N4YSegq13S/ofpnJmGrhR3OPEkkKSyM4txJn7hITvKj8bkG08QEWINKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3596
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
index 2e06ee2..a01bc6a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -388,6 +388,7 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
=20
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
 static int nested_svm_intercept(struct vcpu_svm *svm);
@@ -2365,6 +2366,10 @@ static void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
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
@@ -5204,10 +5209,19 @@ static void svm_refresh_apicv_exec_ctrl(struct kvm_=
vcpu *vcpu)
 	struct vcpu_svm *svm =3D to_svm(vcpu);
 	struct vmcb *vmcb =3D svm->vmcb;
=20
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (kvm_vcpu_apicv_active(vcpu)) {
+		/**
+		 * During AVIC temporary deactivation, guest could update
+		 * APIC ID, DFR and LDR registers, which would not be trapped
+		 * by avic_unaccelerated_access_interception(). In this case,
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
@@ -7283,6 +7297,14 @@ static bool svm_need_emulation_on_page_fault(struct =
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
@@ -7360,6 +7382,7 @@ static bool svm_need_emulation_on_page_fault(struct k=
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

