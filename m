Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EF1ECB81
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfKAWlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:42 -0400
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:60224
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728154AbfKAWlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UX28UAa/x6e3SQ5etNiuD4nAd/nV6iqcKvBTEVGiSTUh6KJC9Nb7CsL5Id7fl/zWz7zb/RkoCOKWSQngpoJvNzibZSLUX2sBY7u7iZZRSxvT0VtAd40j9oxqYkchIKDZGt1o9myw/UOKcaNkFCVTrQMnTnJ6d6If9CuD+Im2pdE/KYBrGhhUN0tt9KyUBcgO0wwpj291/SoZlrZ/U/+OiR9jh4huOWGeHWt3UrzuJE1cuU4kXhe65inqMal17qvK7O1Q2l/pe/8areskU9Fi4esmbKVJFEsDuZk8b36x2O9rtNiQy7xT709nTvyZ958uNKhAOZ4XrQ3PbmNhrI0TMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALxIwlyiTfsO8l7Nb8N0EctsF5F3m8cZQ5pUy5LNTV4=;
 b=ZsrrVQy06tzF7/hnyVlGd1LeSxm0s2j/2HKyWNxCjiyrDfEpqIGWF5HNgDcckVQ0DtqA44IUqVuplygcLsoLAAHI61wSy1cOuDr7RyxHLwCnP2cwNcrDaWn+JvVJfttRkzaWcqbmRH4f3tuSRSWDa4j0QUp1If5mdR9jM0oQmeaDXvuQTcF45+yk/gxyIpCUEvvyl3/lsy+PdlQN0JmDmJ4qobBQ2JV/36CoqjAudRqiP7vFwvNte/Ywq33G0JI6loKdLMYSByuuVnHQa02pI37YlQC7zrV6ScBj5kGve0A0udcRKczaJFZLprxJTnq8Ep015eOF+U7WmB9U2nqd+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALxIwlyiTfsO8l7Nb8N0EctsF5F3m8cZQ5pUy5LNTV4=;
 b=TRQByVsUBHlpnxZuyFpE0b7jI9/QX7kWq1/nm9owQ4ufJlLfVPcadpdwVF09xQ8nFmcw9lL5lT1v74Hi2UZsHDrUc/3AgFPhwe9z9rOzBQcY7S9J/y27zQT5EvOXbY6pfGZcMGqPPlUuEMIvnxQ3pdFnSKGxjy75fb2xa9+XXrk=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:33 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:33 +0000
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
Subject: [PATCH v4 09/17] svm: Add support for activate/deactivate AVIC at
 runtime
Thread-Topic: [PATCH v4 09/17] svm: Add support for activate/deactivate AVIC
 at runtime
Thread-Index: AQHVkQWC0JrNHs37ykiq/KcQAHfp2w==
Date:   Fri, 1 Nov 2019 22:41:32 +0000
Message-ID: <1572648072-84536-10-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 0b12c9ee-6346-4c57-b1b4-08d75f1ca4fd
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243C988D6464C8778850BD3F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wV4FHGCq7Gq1SFuR1KI0voOmyemdr80B1b0/4kq5KLhxgQla5FmsdCSUMurOuj3WOH8WOBUyohEArmT9FI+aQr+HQII+GpwWs2VyGuBy0nhwHG+HfkgBEhV4SFevQTg6ugZc1q32OOJ8cCt6aET7YRbO6gL1yGclkG+xuyqreKnMNJisvpROLWjgjSDivwxiercIN6rjQ1svRIzeSvXjXqjPy4oPkg8LDSHpKyFemTWOG4/wi/pQvA9beQwj0czxw0931lVhVdT57Lg7hgEa61DjUd3kbuo8QEiARVIpksSSHVLj3n64rIklLbVBpmgZJkj90dMSBJ5VH4tJlvQ/Ua5AixCZN9RCpPxlTcTy6euc7HF+8d6L8FJheYVwJAvC0XxfvQaOeHWqGRJsop0En7gMNR2b25Yw+/kMgD1UqUFNaAAaBfi9Rexr6ONlh1fT
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b12c9ee-6346-4c57-b1b4-08d75f1ca4fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:32.9915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iv+axw7PE4ubyv9e/2rIABm2KsMz1srNOdsdAyPpmFW4u919ocb6Sg68/2xlO7igfCtdulvfbYa1ZgHLY+ijxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add necessary logics for supporting activate/deactivate AVIC at runtime.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 21203a6..5b90458 100644
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
@@ -1485,7 +1486,10 @@ static void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_logical_id =3D lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id =3D ppa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id |=3D AVIC_MAX_PHYSICAL_ID_COUNT;
-	vmcb->control.int_ctl |=3D AVIC_ENABLE_MASK;
+	if (kvm_apicv_activated(svm->vcpu.kvm))
+		vmcb->control.int_ctl |=3D AVIC_ENABLE_MASK;
+	else
+		vmcb->control.int_ctl &=3D ~AVIC_ENABLE_MASK;
 }
=20
 static void init_vmcb(struct vcpu_svm *svm)
@@ -1696,7 +1700,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vc=
pu)
 	int id =3D vcpu->vcpu_id;
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-	ret =3D avic_update_access_page(vcpu->kvm, true);
+	if (kvm_apicv_activated(vcpu->kvm))
+		ret =3D avic_update_access_page(vcpu->kvm, true);
 	if (ret)
 		return ret;
=20
@@ -2188,7 +2193,8 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *k=
vm, unsigned int id)
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
 	 */
-	svm->avic_is_running =3D true;
+	if (irqchip_in_kernel(kvm) && kvm_apicv_activated(kvm))
+		svm->avic_is_running =3D true;
=20
 	svm->nested.hsave =3D page_address(hsave_page);
=20
@@ -2325,6 +2331,8 @@ static void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
=20
 static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
+	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+		kvm_vcpu_update_apicv(vcpu);
 	avic_set_running(vcpu, true);
 }
=20
@@ -5190,17 +5198,25 @@ static int svm_set_pi_irte_mode(struct kvm_vcpu *vc=
pu, bool activate)
 	return ret;
 }
=20
-/* Note: Currently only used by Hyper-V. */
 static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
 	struct vmcb *vmcb =3D svm->vmcb;
 	bool activated =3D kvm_vcpu_apicv_active(vcpu);
=20
-	if (activated)
+	if (activated) {
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
=20
 	svm_set_pi_irte_mode(vcpu, activated);
--=20
1.8.3.1

