Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C728B8F090
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbfHOQ0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:26:37 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731131AbfHOQZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QorkaMX6dWJSfxTaHbGaQai0iSzTjtfV37UZheD35ixoYAQlSxmtT5iEnFH4fYWnw4Wvv2GCqu8rWw/P42tXFzV7QsyO0yCzeqowSnmMHhZCYq4bLeRnOCsqUaYnbTq2WhzHn2ZDqq9kgaxzrOhLBsovKs3iCSgybz0XOC3SFYyxIV2nRe/OnQsQ1K5VlpE7meCVLaDLTT3VqPoSLD5aeCO4iyNx5d7FafehDNNSluC6CfZtuocafh4ddofswohR7ShXV5kS/JdAg3DVLXIBRYMElxjAf6Ref3u8nUUnAZwv/xDqgOSPIz3G3XOPU+ZVEi9rBDC/Pjez4ifYxXl7tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DguW8bkDOSvjKvQTovoaIX/vr05tPsSVIbXi1wiu5UY=;
 b=UNzeps7vakF54AX7tCABML5XR9fzu+e1RVfJN1VqWf5JH/A1XlG6RupH3lL1kq1nUiQq3LrPyU+MU6rbkaIkBPNNm89xGrcpnHFxvxq8wL6lhDcCY1ZSjlbM7ge2A182EaF3FHD9DLy/8J55r6vIJGoFzYSuinqTHcAdpbk9yoJvKZDGO8Qyouu4l7qV8+69yievXMc/s9ZoJlDVGqJ/C2HE1ZRCakwgRudmWdzT6w3d4XaxL764zVvMV6viYBT923id2VaUTAXKhLDT6ta+oGhYR+Y3BQFYml57UmfBunIpGZHt6IGDwoYdUGvfdXpgAM9MitjPlziRo890lugcWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DguW8bkDOSvjKvQTovoaIX/vr05tPsSVIbXi1wiu5UY=;
 b=E/60BJ++HbBREIhbvvNJ5yT0s7odcWQO33Glnn93SYOE2mHRwVQ47jtyjEkSoX7b2V4qCspDKy6xGRHQCBKs/uJqjP0lSovNtDq/BIf8osGhwkGn95Ph4+E+XlXRdSyVeDAfNNqHbt8u8l4fGHexkBu0yfde8J81Xks1IbygCJ8=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:05 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:04 +0000
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
Subject: [PATCH v2 02/15] kvm: x86: Introduce KVM APICv state
Thread-Topic: [PATCH v2 02/15] kvm: x86: Introduce KVM APICv state
Thread-Index: AQHVU4X+5ose5W5zl0+8RrY/mJxbzw==
Date:   Thu, 15 Aug 2019 16:25:04 +0000
Message-ID: <1565886293-115836-3-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 87ebf688-cfe3-408e-98f5-08d7219d2097
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3897CA62F4ADB1ACE62F03D9F3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UXipobQFjuXmxQOgeHeQ84z0xlUBfua3xQq+CFjQUeg1OnMcIUoFZOg8KyU0NPCajltYqcsDF8zXaNuMhMMvT2t5D4iWFrZznrMwcZ1c4dnLIxD01aWo7on5EEsMqxLWWYoMxN+mb7OufsAbg1s4nVUNweLmWKIyUnW/CT5I8UeGdNLpVST+a0IcXXZfbHLyEmPxZABe5YwMksHOxlI3DA2tSDk8EBsbk8TL4xBzPpQFcXdSgZ7wDeIk3/zEz8hkF7T2OvcncdSxZqIafuoNUPKCXarF+242vWYFhRUGtXlDDehhYDur1jXd98hNSxbnVT/k9gfIW4Dh3g2Nzetx1AsadISBucSLBHAmuTP8uAe2diMN7FhCpMBhuI6J/nh9MsxWPz09L1R4D0aAKNj8cM103NxHGYnxnb9cIbspcZA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ebf688-cfe3-408e-98f5-08d7219d2097
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:04.2809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNm2tdfNDe+13rb33KYEEK2GpHJwhML/iVOR85sIcT+qv/oP6ggn2BpSBfPuejZwXDSJq4RWdszgWPi/IdrQ0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, after a VM boots with APICv enabled, it could go into
the following states:
  * activated   =3D VM is running w/ APICv
  * deactivated =3D VM deactivate APICv (temporary)
  * disabled    =3D VM deactivate APICv (permanent)

Introduce KVM APICv state enum to help keep track of the APICv states
along with a new variable struct kvm_arch.apicv_state to store
the current state.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++++++++++
 arch/x86/kvm/x86.c              | 14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 56bc702..04d7066 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -845,6 +845,15 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
=20
+/*
+ * KVM assumes all vcpus in a VM operate in the same mode.
+ */
+enum kvm_apicv_state {
+	APICV_DISABLED,		/* Disabled (such as for Hyper-V case) */
+	APICV_DEACTIVATED,	/* Deactivated tempoerary */
+	APICV_ACTIVATED,	/* Default status when APICV is enabled */
+};
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
@@ -873,6 +882,8 @@ struct kvm_arch {
 	struct kvm_apic_map *apic_map;
=20
 	bool apic_access_page_done;
+	struct mutex apicv_lock;
+	enum kvm_apicv_state apicv_state;
=20
 	gpa_t wall_clock;
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7daf0dd..f9c3f63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4584,6 +4584,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.irqchip_mode =3D KVM_IRQCHIP_SPLIT;
 		kvm->arch.nr_reserved_ioapic_pins =3D cap->args[0];
 		r =3D 0;
+		if (kvm_x86_ops->get_enable_apicv(kvm))
+			kvm->arch.apicv_state =3D APICV_ACTIVATED;
 split_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
@@ -4701,6 +4703,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
 		smp_wmb();
 		kvm->arch.irqchip_mode =3D KVM_IRQCHIP_KERNEL;
+		if (kvm_x86_ops->get_enable_apicv(kvm))
+			kvm->arch.apicv_state =3D APICV_ACTIVATED;
 	create_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
@@ -9150,13 +9154,18 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
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
+	mutex_lock(&vcpu->kvm->arch.apicv_lock);
+	if (irqchip_in_kernel(vcpu->kvm) &&
+	    vcpu->kvm->arch.apicv_state =3D=3D APICV_ACTIVATED)
+		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu->kvm);
+	mutex_unlock(&vcpu->kvm->arch.apicv_lock);
+
 	vcpu->arch.mce_banks =3D kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
 				       GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks) {
@@ -9255,6 +9264,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long t=
ype)
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
=20
+	/* APICV initialization */
+	mutex_init(&kvm->arch.apicv_lock);
+
 	if (kvm_x86_ops->vm_init)
 		return kvm_x86_ops->vm_init(kvm);
=20
--=20
1.8.3.1

