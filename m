Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F0ECB7B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfKAWld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:33 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727966AbfKAWlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnOSGNUdhc44sKgLFl9ivZeqryMTlhAOxhVGjc2hbuKKlyRN49Hbv4UOVBdLz8BQJRlENU5mX3BNy6Z1YZ5AiC/YDd2Uz2KWF6D7kXBLCskbOZO3cgIGKp5rfKGn2p9eeaUY87Plz8LkKRbhW/dq94mkL0Nr/mInbam0e61ZwiXX6zJ28p66D7j6s/XDW1eBaDC3wAvNvxyDYpXkRVLdwluLwN46ai5naRaIHxJS0esE5UyPIUHwILZ4TmeuEqP8fVN0ap/JqxQcHUyUAIVTt4MbGYxM8q81YqNiTFQWm/5iCYUcRlYhjIzdacgpAFC09s3cruTTGL3VN8YymCHrIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sIsXBkFTqni+J8VxBSuWB6ZnhevRPuPLWoCXS0gU/c=;
 b=g8MDjLyAvwUntyBmSEz91A0ESJjSWFsvkwtmsQi78r7xkNQjkJ82+CTTbWMeaZepd6GM2TGqnyv6glkrUp6ilFivS7BBXJEcZ4nHVOMo9Gx9PAx0ieMlFYNX7wis4B8HlfyQ44H/8y+ZaJZ5O5pimdnZ2ALQ7cFwfntjjWiFHxefqhcT+dDSisj3SFeH+DQsp08YS1HrEHqwsFi4wI+YF5s8Tui+HBtLmhWw+LAj/KLVL7xxPdeJQj9aFE8fi5FngztOdhKueU/AnhldhN9GY3maj3qe6Z036X44lALsmAOBsUq0vAWl83w7/waYE+StzU3aB5QHMPK08elWkcej/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sIsXBkFTqni+J8VxBSuWB6ZnhevRPuPLWoCXS0gU/c=;
 b=ZkIx2p+wzzA2/6TCA1jiqx7ba05Xpdal+9i5VbaQcNsJBw+WJs3pFHBEkj2uMx20QHXzmYSszYeG7/cdf1w7f6bs4EoYz7RDcH6SdT1GPsszgu42HGLI+1S/wsno4QiwY+MDktUn9qw0V8aLkRyhCe824Yt26D5PRwBcsg4GSc4=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:26 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:26 +0000
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
Subject: [PATCH v4 03/17] kvm: x86: Introduce APICv deactivate bits
Thread-Topic: [PATCH v4 03/17] kvm: x86: Introduce APICv deactivate bits
Thread-Index: AQHVkQV+oJPFNeBvOUWAjjOq3TMHTQ==
Date:   Fri, 1 Nov 2019 22:41:25 +0000
Message-ID: <1572648072-84536-4-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 147bdb80-94bb-4701-ce45-08d75f1ca0c9
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32431E5D38DF698F8BCC905CF3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2l4eydIh5RZaPNflziZNFv2UUUBWdYwX4PeCRHrN7W+dKZSE2bSJ0eX+NQgyO716rVnU8evyu1IPeySLCpGr3Vrq+rs+L3SsY90OW9DdnO8NQZ/uNi+gP3j0WFcE37itdJL4W2zpnqDHE73VimHRZoNwpbfcWEWR6q+GEQlh6MeuSQAywN2i2x5fTRDRE/y6J+BJakE96JSuYoMraX43J1YvtD3izi4bzQ+tjwlsltaaWfuOlrKAHpOAdE330za/g+UinSgjLh7JoJp2Hk2GNvVRUxg2laFmgDnGZ08YOUqSoyeFlX2Ukeg41l3W85tlQAH03N48bAziBjux39TdvzAA+CPKG47ExM+MBMY6+nOOuuUhGB+vPWcmtdPxGloBo35bLvJpQmTCu6JOchtdQ1SBqYy+Fvk7OhS1v9Tb00J4RwfjIBtoKSKvd8empZmk
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147bdb80-94bb-4701-ce45-08d75f1ca0c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:25.9686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 87/uepTm5XVscmhB5wfnIrIhG6dT/9RTj3H4ZkDly0DRgfG+xKYpWvXEQfh4n6ANoVoHeUvdiCYSOXwMUG5NcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, after a VM boots with APICv enabled, it could be deactivated
due to various reasons (e.g. Hyper-v synic).

Introduce KVM APICv deactivate bits along with a new variable
struct kvm_arch.apicv_deact_msk to help keep track of why APICv is
deactivated for each VM.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/svm.c              |  3 +++
 arch/x86/kvm/vmx/vmx.c          |  4 ++++
 arch/x86/kvm/x86.c              | 22 +++++++++++++++++++++-
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 843799b..1c05363 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -852,6 +852,8 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
=20
+#define APICV_DEACT_BIT_DISABLE    0
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
@@ -881,6 +883,7 @@ struct kvm_arch {
 	struct kvm_apic_map *apic_map;
=20
 	bool apic_access_page_done;
+	unsigned long apicv_deact_msk;
=20
 	gpa_t wall_clock;
=20
@@ -1416,6 +1419,8 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu=
, gva_t gva,
 				struct x86_exception *exception);
=20
 void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
+bool kvm_apicv_activated(struct kvm *kvm);
+void kvm_apicv_init(struct kvm *kvm, bool enable);
=20
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7090306..a0caf66 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1985,6 +1985,9 @@ static int avic_vm_init(struct kvm *kvm)
 	hash_add(svm_vm_data_hash, &kvm_svm->hnode, kvm_svm->avic_vm_id);
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
=20
+	/* Enable KVM APICv support */
+	kvm_apicv_init(kvm, true);
+
 	return 0;
=20
 free_avic:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e4faa00..28b97fb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6775,6 +6775,10 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
+
+	/* Enable KVM APICv support */
+	kvm_apicv_init(kvm, vmx_get_enable_apicv(kvm));
+
 	return 0;
 }
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2341f48..70a70a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7201,6 +7201,21 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu=
)
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
=20
+bool kvm_apicv_activated(struct kvm *kvm)
+{
+	return (READ_ONCE(kvm->arch.apicv_deact_msk) =3D=3D 0);
+}
+EXPORT_SYMBOL_GPL(kvm_apicv_activated);
+
+void kvm_apicv_init(struct kvm *kvm, bool enable)
+{
+	if (enable)
+		clear_bit(APICV_DEACT_BIT_DISABLE, &kvm->arch.apicv_deact_msk);
+	else
+		set_bit(APICV_DEACT_BIT_DISABLE, &kvm->arch.apicv_deact_msk);
+}
+EXPORT_SYMBOL_GPL(kvm_apicv_init);
+
 static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 {
 	struct kvm_vcpu *target =3D NULL;
@@ -9217,13 +9232,15 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_pio_data;
=20
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu->kvm);
 		r =3D kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
 	} else
 		static_key_slow_inc(&kvm_no_apic_vcpu);
=20
+	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
+		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu->kvm);
+
 	vcpu->arch.mce_banks =3D kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
 				       GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks) {
@@ -9322,6 +9339,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long t=
ype)
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
=20
+	/* Default to APICv disable */
+	kvm_apicv_init(kvm, false);
+
 	if (kvm_x86_ops->vm_init)
 		return kvm_x86_ops->vm_init(kvm);
=20
--=20
1.8.3.1

