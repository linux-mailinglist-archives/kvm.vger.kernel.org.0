Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB8ECB94
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfKAWmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:42:40 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727966AbfKAWlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5XfUqcpog+Vs1fXU9fZQebAvJZgAWuVbnt9xVD4YlcDuT2PJX7D3/s8mRoWsJj8ceFyRea5/NdZ+KL1qLm1z+XcqCBXwdQ+gHaWHYQH0b/7Z4W1IC5cN/YEsgFykhB0HYOPnN0hkPVUDS8M4/96fTQVSgaw2EhHMtizh7YEYOkFphElpALo2hWHyWtfglw7z+sbKgvS9qlXpzLVjF0jolFfj+fsG/HctO0jKF64fUdcYTS4d1Rxm/C1pZDMpr6z6sqRBZ0Hrg5Oq8+feVxrpWEvEpLdCHakgtApcIDW5ubRd7MkABDtcm9iyNzWhO3AEj5Sc8VTrqmq5HQTouE+Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwS/WZKtINYTbvX/9tiI5JXrLGHhgyNFLkS7G3nh3oU=;
 b=Z4pe4HqtQn8L42g/ti/nx0WBfEu6UEGJdLO+uT0QZNBvYBIuSyZRKdCPRy8LGQK7tK0+e5+tGa35i7u1Nt2WuhB9e6vahBJxbsL0HoH0X0/SMyWvLAtK5gGf4iQoLYVsVKWEpc91QyuU1yiSuaM9vRQwxwZ/vPumezyGzAlKOu9BAYHngZUhoV21T1iABiWZt3qImWqjVsuyf/ZrTCHVWpuNWoGq+7EJlREe3j4jR3XW7tP8wyQsEMcIerb/LDqHAU0hLV7d9gdrLiLg7sF8bAMPbhqCUjT6G4Y0bkBKPJwB+3m9Mk/6vLUtRW5fm5vuugMKc/dA6cYsTKiLj0LFrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwS/WZKtINYTbvX/9tiI5JXrLGHhgyNFLkS7G3nh3oU=;
 b=EkHEiSm0f1RI31nAyKlZ7pf6VH4oi7c6rLUxKF4VfGPIaHWm66zEpcz0DhuWd196nCndjdD8/EWsAPjmQkb/9bMsTenqpBOb49WRyYx/nbA8Vv2yVJpL15isS4dPEUAKlp2OHCMYbKhZT00mQ8omQDehjQI3rYfTxoJwRiNGtFs=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:29 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:29 +0000
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
Subject: [PATCH v4 06/17] kvm: x86: svm: Add support to activate/deactivate
 posted interrupts
Thread-Topic: [PATCH v4 06/17] kvm: x86: svm: Add support to
 activate/deactivate posted interrupts
Thread-Index: AQHVkQWAEkVvwB6g90KyB7kCRl8C3g==
Date:   Fri, 1 Nov 2019 22:41:29 +0000
Message-ID: <1572648072-84536-7-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: e8d37cf2-184a-48c7-ffb0-08d75f1ca2d8
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243F2AA71EFCF1694466424F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:303;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kthw6fg54+WW+gKmaDVZ0FzzVAQTZbVhIWFqL+K8+Xqpw4famLi2Q95mw7SNCZS4FLYwVfoVBoMd6jROPXzNXm1STsamjqU55LRwEQ9FO7IGFZ09QAQmwpR6kJ3YcR7xUn3BWBsqMW9E74JO6LgDS6LEBTj54HZQORofh3DGu/UicWZp4h/nQNbwsqGM+HySDh5RVi1VwdlaMHPW4uch2zKxlQ4Q41sdiYMvbvQEM7oZKWfc8IswNZF9FhjON7XY4UEcLTghP0+RhcPGfNcF1uHjyXY5PmLvjaYcPEthauTG7EN3dlluoND+WIpaU4JLClN94BrTIF1cYxCE6bBzERG3Xg1COa1B8ZLM9ZQJOiX2XeDOnq2fzx1phSOz4I7Ue00QO6OBkXaGwMoq6wtXJg20KJCw2xz+/kDn3p10p2rWFISSK+/dxqsZx+TZbUgp
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d37cf2-184a-48c7-ffb0-08d75f1ca2d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:29.4196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r6Y+UUv/CcpNWIvfDwUQ/LNJHUHlisMBiaZGUVHWJDM5vxbUkbjVhOLm2g7fxDA3NDV+EkZkt4d+7y8fHc3Y6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce interface for activate/deactivate posted interrupts, and
implement SVM hooks to toggle AMD IOMMU guest virtual APIC mode.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a0caf66..b7d0adc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5159,17 +5159,52 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *=
vcpu, int max_isr)
 {
 }
=20
+static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+{
+	int ret =3D 0;
+	unsigned long flags;
+	struct amd_svm_iommu_ir *ir;
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+
+	if (!kvm_arch_has_assigned_device(vcpu->kvm))
+		return 0;
+
+	/*
+	 * Here, we go through the per-vcpu ir_list to update all existing
+	 * interrupt remapping table entry targeting this vcpu.
+	 */
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	if (list_empty(&svm->ir_list))
+		goto out;
+
+	list_for_each_entry(ir, &svm->ir_list, node) {
+		if (activate)
+			ret =3D amd_iommu_activate_guest_mode(ir->data);
+		else
+			ret =3D amd_iommu_deactivate_guest_mode(ir->data);
+		if (ret)
+			break;
+	}
+out:
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	return ret;
+}
+
 /* Note: Currently only used by Hyper-V. */
 static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
 	struct vmcb *vmcb =3D svm->vmcb;
+	bool activated =3D kvm_vcpu_apicv_active(vcpu);
=20
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (activated)
 		vmcb->control.int_ctl |=3D AVIC_ENABLE_MASK;
 	else
 		vmcb->control.int_ctl &=3D ~AVIC_ENABLE_MASK;
 	mark_dirty(vmcb, VMCB_AVIC);
+
+	svm_set_pi_irte_mode(vcpu, activated);
 }
=20
 static void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitm=
ap)
--=20
1.8.3.1

