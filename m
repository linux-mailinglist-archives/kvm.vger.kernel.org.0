Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227428F08A
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfHOQZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:23 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730559AbfHOQZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SI1YwvgztjxTUxeP+WIiytCXeB2EzfRZfai0JK6VAJIph9ZTT9+A8x2cOgwMJZ5VW6lDowTypL2Ez52/Xoo/J1Jtdocnv/UBD9wsZP6tyBuCtAxNZZcdLi1pvY4WjOFUqilJ0unp6Erz+IifZczszD2WEWRmG2K6rnBzfZ3VYNUG0SQyMYvCDiCLBpcfdj8JdDGU8eiSOLDupe6FFS8z0EnUbvCE4oFa6eOY9jvNghJrz1HAEFDjAMRqmtswQZcdtavAdzhuYAy9zkwM8OMavyTJioboM8Y/eC9NbO8wojO7UVaEcK0RczGzI7cjP888l1wgF8pYLQAEIf1utkEw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgquWQD1h23IOCFAcUF/vVUR070Fxtg3fOCGdptoR08=;
 b=oTYn70opB/6YKI3zpm7eAcSzGBNfX0u5EJ2heNQf+U3yBi39BVwK0DqIeoQmD3xCgQp6Cp8mdDDXKUpYBGI2FlmJiLsxtbNWameUnKL4atenAQjuV5DQuU085Z9VA1drO5Q4saE0JuS7fBybjdlS7XsJYSRJYQKh8NG1G8pA116ARdjrAPQ5YJtxmWGG5TWb4qj/1fR2MVyHpMkGSn9okpPy4ErSPF2hknU5zJpWnuOExHM0dJWP2H3SqulTg0bteFx+85N9dq403/RF/bNyVPssyTjkbMAvUOmRaCT2MvJJGtKkaRRmTvXEeWEBMXr/hL1CFUOLPHdgN7BPJSvVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgquWQD1h23IOCFAcUF/vVUR070Fxtg3fOCGdptoR08=;
 b=Ws63aQAn2gi9RTh0xtwifEp5Udl2R9K1hDU0Y3zE9tu56E8fCW+A036ezahIVZtD7wzLXu94QtzU3BmSBpAa7hAgwl75Ls5y1ClLDYNnxVpxD2L1AODe4+2FGmJSXrsNDgphtAvJ3YLSAa7QwWR/18z8OoCFu9r9fLZnGGCtLZA=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:11 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:11 +0000
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
Subject: [PATCH v2 07/15] kvm: x86: svm: Add support to activate/deactivate
 posted interrupts
Thread-Topic: [PATCH v2 07/15] kvm: x86: svm: Add support to
 activate/deactivate posted interrupts
Thread-Index: AQHVU4YCq8MA7E6GfEyia46qTzdwWA==
Date:   Thu, 15 Aug 2019 16:25:11 +0000
Message-ID: <1565886293-115836-8-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 967724da-82f3-4994-355f-08d7219d2531
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB389730BD9679C7198207450AF3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LSrGPH2vrXg6pgYnbPxxQp3IhPlWIfznewFrZwBWyDIscw9qsQ61IKyQMmzJ2pAAD4en5eIGVFpYdApWdASw8oiRg20W+J/JyZHemINsxlI/OpdValoXBOJWSIa6h8kQwLmuhrcEg6W9nfMo7/16NvECRJgo6C0CYzeVAH0SGd9962unnfcuSsKDLvJmJbybpf96JbwPok8VYOat28audcopxPsOPeVgXImYcGOcKpEe6Vdq8ZZXHnnMYP78m8k3Tyxm7lOAtFvLNneR6uDgIP2Uj6+W3mr8EPmJvcAbqZnfTZ+5386kedf7vb3rcMWQV9Wq+7xmrfa/nPoD0KmtOi/IgleNSbFlALkGHQwjiu30u7nqByMPFMhI2lX6iwLWlW1tqjqnlt0gmzR/VLxfldOVYnrPybgve+b76kYSdms=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967724da-82f3-4994-355f-08d7219d2531
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:11.5937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q9b+YKTndgz28RxMG+4P8wq7BB4p7g0OQUG/Woa5edcS/NUIe4GJXkMpdHSBWpY+RckBDD48EA1T6wXvZoNn6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce interface for activate/deactivate posted interrupts, and
implement SVM hooks to toggle AMD IOMMU guest virtual APIC mode.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/svm.c              | 44 +++++++++++++++++++++++++++++++++++++=
++++
 arch/x86/kvm/x86.c              |  6 ++++++
 3 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index dfb7c3d..0d8544b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1183,6 +1183,10 @@ struct kvm_x86_ops {
=20
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
+
+	int (*activate_pi_irte)(struct kvm_vcpu *vcpu);
+	int (*deactivate_pi_irte)(struct kvm_vcpu *vcpu);
+
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
=20
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6851bce..b674cd0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5374,6 +5374,48 @@ static int svm_update_pi_irte(struct kvm *kvm, unsig=
ned int host_irq,
 	return ret;
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
+static int svm_activate_pi_irte(struct kvm_vcpu *vcpu)
+{
+	return svm_set_pi_irte_mode(vcpu, true);
+}
+
+static int svm_deactivate_pi_irte(struct kvm_vcpu *vcpu)
+{
+	return svm_set_pi_irte_mode(vcpu, false);
+}
+
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -7269,6 +7311,8 @@ static bool svm_need_emulation_on_page_fault(struct k=
vm_vcpu *vcpu)
 	.pmu_ops =3D &amd_pmu_ops,
 	.deliver_posted_interrupt =3D svm_deliver_avic_intr,
 	.update_pi_irte =3D svm_update_pi_irte,
+	.activate_pi_irte =3D svm_activate_pi_irte,
+	.deactivate_pi_irte =3D svm_deactivate_pi_irte,
 	.setup_mce =3D svm_setup_mce,
=20
 	.smi_allowed =3D svm_smi_allowed,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 40a20bf..5ab1643 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7177,6 +7177,9 @@ void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu)
 	kvm_apic_update_apicv(vcpu);
=20
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
+
+	if (kvm_x86_ops->activate_pi_irte)
+		kvm_x86_ops->activate_pi_irte(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_activate_apicv);
=20
@@ -7192,6 +7195,9 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
 	vcpu->arch.apicv_active =3D false;
 	kvm_apic_update_apicv(vcpu);
=20
+	if (kvm_x86_ops->deactivate_pi_irte)
+		kvm_x86_ops->deactivate_pi_irte(vcpu);
+
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deactivate_apicv);
--=20
1.8.3.1

