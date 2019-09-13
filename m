Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7F6B2599
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389402AbfIMTBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:39 -0400
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:54616
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729758AbfIMTBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9f2nqxDnPPBnBDGBOXEZ2WTLVtZSBC2LqIclH/CZe6Bn+X6hoIM/3q71P758L9rT3aFquMUUroCNQGPGtdi68lVOexknixx2DVOec+N4S1+Yxlv+QkbHoaQU8TkAX3iOTxJrKogRsWOlO55mJNv28yzXVXP3SDMSLyTtTePWRALbpsBq10pRPPVFeUW/k/xSTLnzlL+P/vwd5aG+29RdiBe8fFQwiwMdmhKmqKcKaZNqem2ug1ND11D7og4/UE/1CxAAsWc7NsReNRzZe/KxhQwr6c7iWZ667y3H9TPP7rovKHHlUsDPmuQ1VhldVN4+mtIqcT4ycWPXQjnF6zy2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWlYKLNygsfU3qv31NL8wFRSzi1NW9Jqf/HR7JUefwI=;
 b=WjjhzrrkTHgTwjGzkKxxO9E0mgyexpJ/F+1WEmy7EN3SkpePlcj9pEnE/x78kkk7Zf5H6Ehqr5jcqEv/WvA5xIX1cWkSpVI4IUEAEB5P09i7Pce9vvsXh/29an7lbMMTEKklG72FISwMIVKd1Sc7acGuJV66GeZL/LEDDmc4/TA3+zkS43qfZP0l2P85gHGJsUD04z7D8tA/FSpVOS/51QxCZTnS94ufaXU9I9urPCEnZ5sI/sVYU8xjyUUa9ql9qY0hKtKD41flJKsJjKDMKShquC09FKd28Pm0BubdvI5JSWr+Qg+z0DYcp6+bJqPzdSNnwpjRNUiKBGbV/qLKmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWlYKLNygsfU3qv31NL8wFRSzi1NW9Jqf/HR7JUefwI=;
 b=m0XJBlsaolVjbk7WWbA25nZKT7fkYAHAxu2ovx4Zuo63c20cSiPAO47DNKx/4zia1kfSY04Bbaeyk5YRtQgKDkCedl5kxCpgI/st4bT2Uq75gvtg0FLuKkfyO+39USQJmLgfM1DDxxKWePUsPlbJk8sWEy+VcSn6uBDNyE1FWwk=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:58 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:58 +0000
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
Subject: [PATCH v3 07/16] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Topic: [PATCH v3 07/16] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Index: AQHVamWTTWKSr9AuCkyCwqbevC70zA==
Date:   Fri, 13 Sep 2019 19:00:57 +0000
Message-ID: <1568401242-260374-8-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 8dfdd22f-7063-4546-c0cf-08d7387cb607
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3804D3C0BECCDCAE8EB9A4BEF3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BZHRrDfW5YYzXNw68OXxNUyRhicyjxGNQblO285EsVlM2KBSurrXjl67aXb9Pz9JEY+AMEgFEtsnm1NntWsz2TxtdlZx6cO/y5TENF1LmJVOefOG8UcbvASNt8Ql127Exy3Pav16eotLNrvL/zF5cQs1IUqZkaxJtEOryA3qWVuNp82L/WuJOj8Qmpp+X5oO7jvCPP9bSilYZ98gEPGHvE6Tcjlh9slLHFYPAovc9uD9vLLdxi3QY9cOtagspp5pmkcxxRF34BVNpzOhI52+vzGJeCOxJNotDwdLMiqxxXajDqEejs+ZF+UVbgHqSGPfx1AAf8Z5wZ2dBkniwM+nxJFrEyZnNNQYXOLToMId0vvXqDoAO0euYL2lIKE9ntuaIpqYwB0UA1X0CLNdtez0LlRYN2uunIXUEonwidCUF0g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfdd22f-7063-4546-c0cf-08d7387cb607
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:57.9954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kCzuU2xKfI2aXENMD6QaqJr6K907Srsy0TuA31gOn98ZpLvXKBMP6DTwcwqPaljxEbqIkNyepZcmT4XNCFIx/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
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
 arch/x86/kvm/svm.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++---=
---
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8673617..2e06ee2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1476,7 +1476,9 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *v=
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
@@ -1485,7 +1487,13 @@ static void avic_init_vmcb(struct vcpu_svm *svm)
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
@@ -1668,19 +1676,24 @@ static u64 *avic_get_physical_id_entry(struct kvm_v=
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
@@ -1690,14 +1703,39 @@ static int avic_init_access_page(struct kvm_vcpu *v=
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
@@ -2187,7 +2225,10 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *=
kvm, unsigned int id)
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
 	 */
-	svm->avic_is_running =3D true;
+	mutex_lock(&kvm->arch.apicv_lock);
+	if (irqchip_in_kernel(kvm) && kvm->arch.apicv_state =3D=3D APICV_ACTIVATE=
D)
+		svm->avic_is_running =3D true;
+	mutex_unlock(&kvm->arch.apicv_lock);
=20
 	svm->nested.hsave =3D page_address(hsave_page);
=20
--=20
1.8.3.1

