Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB38F093
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbfHOQZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:06 -0400
Received: from mail-eopbgr710058.outbound.protection.outlook.com ([40.107.71.58]:6245
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730957AbfHOQZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V78oHdYxQ7VDWnLwegSyKLDqfcqLeF9iMYG3fG0FCeMdT9H/CQwv9yp7YsKloWP+V1cnEFJp19MzEUeFFjs4fnOx4aWgTYs+gETpr/IHX7t/P574xqe9+yM8mAB2h7G5mQqnjACu4RqSFLQOHM29aJ1nHK16+nU3HJ5Vvl+vURTv6V07BbX8elAmKWRYuHrTmIl9lsSF8yeWyoDfuwtOxsVVdXjiePpd+2fMtFTE/1FzAQs6RjsHV2xd8n8Ct8bOm57CJeB+DsuUAdGyYHMU/gV6jKv5J2LTz8D1+yy8JOHwTxroXRNX5IXWv4PbwELf0Qc9mZ21aaS4TIkDSvn1cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZ9NMC6L13qAyAVPTcveCnPbTT/jtUuZPwTWF32svxk=;
 b=Z/5obspDXsLZhNC6QZaKTWf+GAvYE5dCvczzDU9ZPGO85Tmj94GKkcgWXDG/9RKaKwH3jIEPPDm8DhFXBY5yuxgLErTILdoTgoi82242xZqwq7Ut4r5zQeLtr0XYHFIaHuynuzXTHhv5v7e9HDLJE0TvqHEsH31W2X1sqpdaWbBsfkHjgo7njlkdYzkCs5DeFQnx42URDzoAwDSZzVDa5LBOMTHxKp0rkgDgYKR7MxCpzyTg9o0JkYlGz3LZkMuDc7HwX9Qn3MaMm3g+VFQBzY0Zcd84dAB639Dy2gtgHg3mCCLo56ttBKZw+l3HQJN5krK7PKPw0+Zx1+fZ5RLJfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZ9NMC6L13qAyAVPTcveCnPbTT/jtUuZPwTWF32svxk=;
 b=z9s+MimaA/8gCyj+ZtImtx1bBOrAzOxMy+HvMqYkdBbAD5CYnwZ/jrY0pIyLMG7DL+25g/1L8XLGbl4FW1e/r0IjB906zKqPY9oBusHWBvLDN2ZWzQhlLu5r9MlrInmDJwpg4jOWlr3GtrTddRxHkQaDeqw8VVVu6nLkUHt4Djg=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:02 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:02 +0000
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
Subject: [PATCH v2 01/15] kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to
 use struct kvm parameter
Thread-Topic: [PATCH v2 01/15] kvm: x86: Modify kvm_x86_ops.get_enable_apicv()
 to use struct kvm parameter
Thread-Index: AQHVU4X979h9sz28mUWWvZbn+U2MiQ==
Date:   Thu, 15 Aug 2019 16:25:02 +0000
Message-ID: <1565886293-115836-2-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 9ff32e6e-f604-406f-022f-08d7219d1f52
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB389733B0CEE5957FB394DDA5F3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 90M/Pey8TGDDaBAczwGiFcxUbHxJ8J8/DGbLYV89rwDMamgK/loSxmi4gpbRgXNfM+g2XSWEW2FqhFiJdBhGIUD9asT8qyOlA7IaswSEIWvqt8SJKD0eK2yuPx1JqHflF4miO2BGIgga8y+sx1wZ/pA8HTdDBIQ9ylBbGnkrfrOWX7IzuNrNxvC5uiPp9d++LzFuSONMj1ZDw00szDVAcEOfFlG6JzUPSFbVOcp9X+UihB6WwHDtAowJ7k+azPkkA/O1sDjHWEw9s5z5BMv5k6kd9kyp0jAhPncoOJG5TF83hMISNhheZO0P5/lhyXlA8W8x6EoroacM9jV8NmPDRuo+3h2FCOz0C0DtEP9PE62POj7qXTZrHPZ/BMvAW4/SVQ/8AlQy5IZuCJ6/0HPvuV/94gfLdgppOzwbb/kgQo4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff32e6e-f604-406f-022f-08d7219d1f52
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:02.2940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2d5zA4GUl8hmqEmzVSU8mzE3hlNKwsOJob7tP/2jrkuej/w6af5bczudPAZ5XgMlirwcDCAjrdSHSeWpC1qPDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generally, APICv for all vcpus in the VM are enable/disable in the same
manner. So, get_enable_apicv() should represent APICv status of the VM
instead of each VCPU.

Modify kvm_x86_ops.get_enable_apicv() to take struct kvm as parameter
instead of struct kvm_vcpu.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm.c              | 5 +++--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 26d1eb8..56bc702 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1077,7 +1077,7 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*get_enable_apicv)(struct kvm_vcpu *vcpu);
+	bool (*get_enable_apicv)(struct kvm *kvm);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ccd5aa6..6851bce 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -384,6 +384,7 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static bool svm_get_enable_apicv(struct kvm *kvm);
=20
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
 static int nested_svm_intercept(struct vcpu_svm *svm);
@@ -5124,9 +5125,9 @@ static void svm_set_virtual_apic_mode(struct kvm_vcpu=
 *vcpu)
 	return;
 }
=20
-static bool svm_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool svm_get_enable_apicv(struct kvm *kvm)
 {
-	return avic && irqchip_split(vcpu->kvm);
+	return avic && irqchip_split(kvm);
 }
=20
 static void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d98eac3..18a4b94 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3610,7 +3610,7 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx=
)
 	}
 }
=20
-static bool vmx_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool vmx_get_enable_apicv(struct kvm *kvm)
 {
 	return enable_apicv;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fafd81d..7daf0dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9150,7 +9150,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_pio_data;
=20
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu);
+		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu->kvm);
 		r =3D kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
--=20
1.8.3.1

