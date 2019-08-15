Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD1D8F074
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbfHOQZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:21 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731357AbfHOQZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3ZlN5KtFvcx8MqI24zyxsbQ177zkxUO9JigP0s/Oul6ag/1p+6g65ochqEGomsYJtvTk3nBmwHZWvWaJCU+opIMeXlew3kn/ehj52Rw1REs9Uf9DB0Myha/rmGq+NxLkj0FuRgqjYCx1M5xT6SczE8066aRQ9UwmGeS6bDRF7DZUNHaWidbPSKGEdRZOav8rpRzjHWI5cFI2BzjIHq2ttUmnxufiUzSvIOhMd8aNVG20TNdoJeXc1/jayOdLmGZrKTNIUOKN0tuOKAXT9BQ+tw7K3n4WWPEH4xcT439yRCswkkGKC08W2sAtn7qsAg5v6Vw8W6afv7mRTJdgSfWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ca9jyXgQMD4K/iwGykKRmQT0pTvu+Eh8BGLjcseeNa0=;
 b=LZrd9LEYmlk2kkx7vXxOzvJ/XSMjetZPnZB0g4N6P89J0mD/Anf35SWmqYAuDwtdU+6RGww915x+xqCe5L93Jll8gA8ax85wdV3Jw3MJUuUZU+IhWamuEGB+sipjHowSf7C0yVMLVs5o7fwkXKt0D50d2Bowrn0UpwRTZld2pI21KjVU+LdCeod4bvrXMP45KoA8kkpazhTOQQi0IwXGEy+ygcJtn6RBUwwPS+AY9rlhdECzL6xo2tvFFR0gc73zS/OkspTEXXk2y/3w1q0ixCHJ7Rrdyb1U/EfAFgxRAk/bpHPU7KVys8kPE1T0W/2rj1bq73SiMfpB1rhVNbRLtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ca9jyXgQMD4K/iwGykKRmQT0pTvu+Eh8BGLjcseeNa0=;
 b=30k3M855ECLsyhwbnbZs6T9VgUyjQaGbnPsKkjeLxMY4xchHQfSokIiz/mocmtmNf+sQ/396M33KOr36if3khwl8UXLizGI+UjtrbyU1KV7hJG7+sRjtoJhH6ZE3W4Dp6xkQ8OujF0oZV++P8aRd66mQa7RGJSmR4dV6HUGbOlY=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:12 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:12 +0000
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
Subject: [PATCH v2 08/15] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Topic: [PATCH v2 08/15] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Index: AQHVU4YDWF82b235sEatrd+nfFcRLg==
Date:   Thu, 15 Aug 2019 16:25:12 +0000
Message-ID: <1565886293-115836-9-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 1cd7f15e-d8ca-4ea8-ce80-08d7219d25d8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB389766F2D08FD51BA19C5EADF3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J+a4uuNWoajI6LKZrHo4fJN4C92Q5xwwH+gCq8EUMZ9MSxvyJf/CZUHQ8UE87Uri5/wzfO66O3dZkcMSquJ3UbYZCLUv1HvAln/uu4Z53BZpfmH1tu7UCJiPy8TRtKLURvwlcxwkx6mfMbMADx2CLWsWNpmpRREjv/NszHNjT/LR/3QOmlGfqknfIDlJa0068D6UQTGK/NpiH4yebz3hAyhcmU50zDMtbUYTwmDQHwcFUJRdXIH4LQsLXcF4EnmxoIApesz1B/ik51yj56016lB/OmotxtumQawLPTNIpT2kZ75lQxfd49Jobol5efNWvSjnIAMoEiPsmIwn23iMyQtyLFM/2ki9Q1QmgGeanlme0VK3k9cuN8pw5jIPS+P+un5okagJ9GYIXK/ShP+NH2IjTLPFnRBm73vmrDeHtZ0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd7f15e-d8ca-4ea8-ce80-08d7219d25d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:12.7200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ER4iKxLbYmFJiFbD8fMFm36N+7+v7coSNTWXXRbE5k5gctwX53VYDo9kE1R/N9zL2HJvvVo2p/DuDZiVCE9SeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Activate/deactivate AVIC requires setting/unsetting the memory region used
for virtual APIC backing page (APIC_ACCESS_PAGE_PRIVATE_MEMSLOT).
So, re-factor avic_init_access_page() to avic_setup_access_page()
and add srcu_read_lock/unlock, which are needed to allow this function
to be called during run-time.

Also, introduce avic_destroy_access_page() to unset the page when
deactivate AVIC.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b674cd0..47f2439 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1468,7 +1468,9 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *v=
cpu, u64 offset)
 static void avic_init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb =3D svm->vmcb;
-	struct kvm_svm *kvm_svm =3D to_kvm_svm(svm->vcpu.kvm);
+	struct kvm *kvm =3D svm->vcpu.kvm;
+	struct kvm_svm *kvm_svm =3D to_kvm_svm(kvm);
+
 	phys_addr_t bpa =3D __sme_set(page_to_phys(svm->avic_backing_page));
 	phys_addr_t lpa =3D __sme_set(page_to_phys(kvm_svm->avic_logical_id_table=
_page));
 	phys_addr_t ppa =3D __sme_set(page_to_phys(kvm_svm->avic_physical_id_tabl=
e_page));
@@ -1477,7 +1479,13 @@ static void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_logical_id =3D lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id =3D ppa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id |=3D AVIC_MAX_PHYSICAL_ID_COUNT;
-	vmcb->control.int_ctl |=3D AVIC_ENABLE_MASK;
+
+	mutex_lock(&kvm->arch.apicv_lock);
+	if (kvm->arch.apicv_state =3D=3D APICV_ACTIVATED)
+		vmcb->control.int_ctl |=3D AVIC_ENABLE_MASK;
+	else
+		vmcb->control.int_ctl &=3D ~AVIC_ENABLE_MASK;
+	mutex_unlock(&kvm->arch.apicv_lock);
 }
=20
 static void init_vmcb(struct vcpu_svm *svm)
@@ -1660,19 +1668,24 @@ static u64 *avic_get_physical_id_entry(struct kvm_v=
cpu *vcpu,
  * field of the VMCB. Therefore, we set up the
  * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
  */
-static int avic_init_access_page(struct kvm_vcpu *vcpu)
+static int avic_setup_access_page(struct kvm_vcpu *vcpu, bool init)
 {
 	struct kvm *kvm =3D vcpu->kvm;
 	int ret =3D 0;
=20
 	mutex_lock(&kvm->slots_lock);
+
 	if (kvm->arch.apic_access_page_done)
 		goto out;
=20
+	if (!init)
+		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 	ret =3D __x86_set_memory_region(kvm,
 				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE,
 				      PAGE_SIZE);
+	if (!init)
+		vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
 	if (ret)
 		goto out;
=20
@@ -1682,14 +1695,39 @@ static int avic_init_access_page(struct kvm_vcpu *v=
cpu)
 	return ret;
 }
=20
+static void avic_destroy_access_page(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm =3D vcpu->kvm;
+
+	mutex_lock(&kvm->slots_lock);
+
+	if (!kvm->arch.apic_access_page_done)
+		goto out;
+
+	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+	__x86_set_memory_region(kvm,
+				APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
+				APIC_DEFAULT_PHYS_BASE,
+				0);
+	vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
+	kvm->arch.apic_access_page_done =3D false;
+out:
+	mutex_unlock(&kvm->slots_lock);
+}
+
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 {
-	int ret;
+	int ret =3D 0;
 	u64 *entry, new_entry;
 	int id =3D vcpu->vcpu_id;
+	struct kvm *kvm =3D vcpu->kvm;
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-	ret =3D avic_init_access_page(vcpu);
+	mutex_lock(&kvm->arch.apicv_lock);
+	if (kvm->arch.apicv_state =3D=3D APICV_ACTIVATED)
+		ret =3D avic_setup_access_page(vcpu, true);
+	mutex_unlock(&kvm->arch.apicv_lock);
+
 	if (ret)
 		return ret;
=20
--=20
1.8.3.1

