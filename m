Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56AFB2586
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388418AbfIMTA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:00:57 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:58712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388289AbfIMTA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:00:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPUVcIwstpeV71MaCWwFW3D01xly5RGERB0uZvCULirIaU7awc2/Sgp3eIGo72tEWZmkwoOVmuup7i9EHmd50O8FM4PVNkmUt9OdCmdP8Jid4yZPOTR+/tJyaOc18zEafJ54o4Wan6v/5b5DO02OQ44Oo1i4Zh1GdxPTMDSsrwBV+lIVb+HKhWa0barncyTKSt2WELuDtQgqOOihyBq0FN/eUeQIFn4JSatnDEyZtpX1WETi0lYEmOACiws9/8bz59CwgIl+/kgrY6vcgBZbWJPfrD08QaXWm75PYSqGHlo9Kp/fzIHz1qmOYmdwXTFl4wB30YmZP1HFKsoW+X5ilQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4HI10uYli0ODSEV19j94XZ3zMM9EbiWkUm/W6xjNSU=;
 b=dn4EKDZPiI2TCaz2fs/3Wy+Qk89LFnmCqbcMZ58OZZRyk7rbqf2lyqETB+cFMdaKmJEHR+NzylhWy5IHnCdjZXdu/ZR6eD17cf9t+smSMlgV0BXCHShU74AZi89S0/a/WBE6Bw5GMhw4Vv5pAs5ni1Z+ckDzR+hRp2h0glX97TlY6xswi6d8ghY9bbEgQLVE81mg7DRIwCMKVbg3wvmmH2uAAc7kFjFUnXRefXwT9BCow8VqfJmuNTuHA2KHkKgDbea9lHxmtZBPwMkvOdaCv22M2Emtv2vXKZanpMJExQTMEccR4rD7lbTzi8elQhxV/G096rSZIi0ci725a145Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4HI10uYli0ODSEV19j94XZ3zMM9EbiWkUm/W6xjNSU=;
 b=vRKELnnRkw1gnJKtFXMokyuuapbRtaDb6zawSDaqpCzXFEqEifGBdSSicLK5PKJU6pI2Tqrt5nbWbAioBtU/XK5I+5I6QCU9XRvqp/1nUpuBPgT1SSO8XthAH4E7FgQUyu+Bw9f2hoEEiDBDknrJAEyZAnuXGb1pv6KoXcIYMug=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:51 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:51 +0000
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
Subject: [PATCH v3 02/16] kvm: x86: Introduce KVM APICv state
Thread-Topic: [PATCH v3 02/16] kvm: x86: Introduce KVM APICv state
Thread-Index: AQHVamWP0oJFhAvw6kCPb+ErEOc/Vg==
Date:   Fri, 13 Sep 2019 19:00:50 +0000
Message-ID: <1568401242-260374-3-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: ca35b002-667e-4f34-e7ab-08d7387cb1df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38043DA45A80FEBD517973FDF3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qpdhMQNsPKEho/E6tA9PmWjCl0oj1ip/trGdNbXonvUjHQCbpxp6pEzc/h+nxGAz+z+G6N9Sld9x0lPKcJ6LCc2vgab3Hd44OUiVBv2XWPQBgt2eprEp2ORopFjyq6A0xin+lCs3dcsKSt2F7YSYdatYmCviLgVVcKTmsSa5zfwYX6Bul2TCvKbTkXOuQwQ8qy6KTRYczG7bKXFRND8VNOpk3iCvh8w+DRCrIAJc6ogkJgTx6HxcPjxsPI3ZDoWoo7RCHE/1JaaVGnxHGrvc/aWdkvTKbzxwqd6sX/UcCgRE6u3DVDK2oO5daQpW+Wb552vuu3j+lLTdkydCq7L4zEF0P3qCKnX4xUJmWNt5X/URVKGgnowGFMOq6wyVR97sfwc5juahvH9AQuat6PlSteWsqrB1BBUQEJ+Rv0P1ewE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca35b002-667e-4f34-e7ab-08d7387cb1df
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:51.0194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 92yOKw1U1bda4M2RNCfMcZrpIMUF1wSJ1k/XLxwjah0tU8nZIRDmXNGKh0/YLZTtMPu/27wk6nzXV4fW4vlE2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, after a VM boots with APICv enabled, it could go into
the following states:

  * activated =3D VM is running w/ APICv
  * suspended =3D VM deactivate APICv temporarily
  * disabled  =3D VM deactivate APICv permanently

Introduce KVM APICv state enum to help keep track of the APICv states
along with a new variable struct kvm_arch.apicv_state to store
the current state of each VM, and kvm_arch.apicv_lock to synchronize
access of apicv_state since it can be accessed by each vcpu.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++++++++++
 arch/x86/kvm/x86.c              | 14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 277f06f..562bfbd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -851,6 +851,15 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
=20
+/*
+ * KVM assumes all vcpus in a VM operate in the same mode.
+ */
+enum kvm_apicv_state {
+	APICV_DISABLED,		/* Disabled (such as for Hyper-V case) */
+	APICV_SUSPENDED,	/* Deactivated temporary */
+	APICV_ACTIVATED,	/* Default status when APICV is enabled */
+};
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
@@ -879,6 +888,8 @@ struct kvm_arch {
 	struct kvm_apic_map *apic_map;
=20
 	bool apic_access_page_done;
+	struct mutex apicv_lock;
+	enum kvm_apicv_state apicv_state;
=20
 	gpa_t wall_clock;
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01f5a56..64d275e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4630,6 +4630,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.irqchip_mode =3D KVM_IRQCHIP_SPLIT;
 		kvm->arch.nr_reserved_ioapic_pins =3D cap->args[0];
 		r =3D 0;
+		if (kvm_x86_ops->get_enable_apicv(kvm))
+			kvm->arch.apicv_state =3D APICV_ACTIVATED;
 split_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
@@ -4749,6 +4751,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
 		smp_wmb();
 		kvm->arch.irqchip_mode =3D KVM_IRQCHIP_KERNEL;
+		if (kvm_x86_ops->get_enable_apicv(kvm))
+			kvm->arch.apicv_state =3D APICV_ACTIVATED;
 	create_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
@@ -9209,13 +9213,18 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
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
@@ -9314,6 +9323,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long t=
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

