Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5276B8F08D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731345AbfHOQZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:17 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731275AbfHOQZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEULB1QBDIenHHjoLKMao3PyGtSH7R4S5Mtn/ySunD+btw/zO/ugg00y1BatYIbW4u5nNd2cH6pwuteq0HDQuBuPASDqu+cTHwpCySldEiibSfB8LIyX10aw0j5+LSlMr4ApyRx9H5KvKp73WY/Ko1yRiN5ngoq9Il0EGEP7QKym1V3BzaJClIu2VUA3RZxxUd2++p1olVukER+9rh+Rn11mT9nQXNhw2plx23cdJMW1R5yMyxzPufzHEDGotx3NB2eE5wNWOKVccJBIDJ1i4GxhX64Jd+Jqx2rM33HyBkza6ObvCrxq346qcKy8uW22LXhxYbq3/JYJZfPOzMJTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nq63MQKB8rJU5046fOo/0gbQ/uFjLkMsHf7JixMV4D8=;
 b=PsDcGVvxKQNT1qOTirIlhIFrv7JMgfAbw6vb2DlZ67mD/nJlVoA72IUymOlFl8AwOeFqD5no/MVJ0Xo/CELwXj87IArd6PSIQK4uEHyRZQDGZwH2meEIMS79uab+GcxiBEs5JLWJUe7aC9MEI7X6VORQA10JrCSLMKf7sKeyYKZeDg7b2VMaFmm55AnKVCL60n/Z0lsEdoNcGWDZwYy1U/kzkTpj5lVl01hzKEZcTtBBW8f+QNmwk/g2aESEuxmqF1w53aQkQfdBxBdq8sKjZ6AGgMQeIB4XvRaH/JkA1v9csLjOuZeqyv+Q7ZTc8HKa5UDfsNLgbXP92BS5M/fnmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nq63MQKB8rJU5046fOo/0gbQ/uFjLkMsHf7JixMV4D8=;
 b=cLqvQlj445wk9Pi9nyYdYNWuiaDPmjlTM8HDd8QeIrxeewjQxxqkBcMFSM+PZXu0p3M2RmSE4ZApJdzA/qNpa7ummp9lVQ3dl388HC28ZguLl77Uh2I8EDmR4VzuagVAIyvVm+UyXdlAO3GlGUrUssiFvAKXzSCfev8bJO+Al3E=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:10 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:10 +0000
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
Subject: [PATCH v2 06/15] kvm: x86: Add support for activate/de-activate APICv
 at runtime
Thread-Topic: [PATCH v2 06/15] kvm: x86: Add support for activate/de-activate
 APICv at runtime
Thread-Index: AQHVU4YCIHrsDQYeM0Sl/PKyot4njQ==
Date:   Thu, 15 Aug 2019 16:25:10 +0000
Message-ID: <1565886293-115836-7-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: f5a5257a-0588-4dbe-251c-08d7219d2467
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB389720ABE84BBF52C575075CF3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ArbY3XLT/ldCtLb5+S00jWda61tR2pOEBNpAtX8lbttRKZJ1rw98U/F3WyqOFSt9N3JlUPH8yT64EfHRy1celeTrhZawwZQ3dDvqmTTZ3GtIeULiVHW3SmD3A2D1IDu+XoW9AZEQN6aVo/TCQkDzppdwIjli/4VhwMfUj/PcVdd/ZIzzZ0xHsnbVjlU22L36FE6PBIph3lmx8hFnGaWVb2wPRf0dcLcwkdJaP44QX0fOxq4ytbPFmO1AYpPBj2IWapn2D8h0wKwyV//jjZvtCQ8kM0gEdKqgbGaQ53Q9qQjTPe/gyaDbh0vH/h2Qn84GRO0cb/AWQdbEeFyaaNa8nZoRAwAglCx8OldiGZb+BiiM9IJD6Ki0S+J0ySMivh2cw3EmyY+EGmMp8S9vYNeAHQfJkYMWEkCmZvnG3B4qG5I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a5257a-0588-4dbe-251c-08d7219d2467
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:10.4154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmfOWQ40Yfsixc9m/eLTdGbHd5r10YPsTb5mBG3DHsjn3hRoz9uWhXFlmLs66mHixfabhPheOFHCUt6pamexaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain runtime conditions require APICv to be temporary deactivated.
However, current implementation only support permanently deactivate
APICv at runtime (mainly used when running Hyper-V guest).

In addtion, for AMD, when activate / deactivate APICv during runtime,
all vcpus in the VM has to be operating in the same APICv mode, which
requires the requesting (main) vcpu to notify others.

So, introduce interfaces to request all vcpus to activate/deactivate
APICv.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  9 +++++
 arch/x86/kvm/x86.c              | 76 +++++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 85 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 04d7066..dfb7c3d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -76,6 +76,10 @@
 #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
 #define KVM_REQ_LOAD_EOI_EXITMAP	KVM_ARCH_REQ(23)
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
+#define KVM_REQ_APICV_ACTIVATE		\
+	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_APICV_DEACTIVATE	\
+	KVM_ARCH_REQ_FLAGS(26, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
=20
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1089,6 +1093,7 @@ struct kvm_x86_ops {
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
 	bool (*get_enable_apicv)(struct kvm *kvm);
+	void (*pre_update_apicv_exec_ctrl)(struct kvm_vcpu *vcpu, bool activate);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
@@ -1552,6 +1557,10 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long i=
pi_bitmap_low,
=20
 void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
+void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
+void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu);
+void kvm_make_apicv_activate_request(struct kvm_vcpu *vcpu);
+void kvm_make_apicv_deactivate_request(struct kvm_vcpu *vcpu, bool disable=
);
=20
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9c3f63..40a20bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -26,6 +26,7 @@
 #include "cpuid.h"
 #include "pmu.h"
 #include "hyperv.h"
+#include "lapic.h"
=20
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -7163,6 +7164,22 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsi=
gned long flags, int apicid)
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
=20
+void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu)) {
+		WARN_ON_ONCE(!vcpu->arch.apicv_active);
+		return;
+	}
+	if (vcpu->arch.apicv_active)
+		return;
+
+	vcpu->arch.apicv_active =3D true;
+	kvm_apic_update_apicv(vcpu);
+
+	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_activate_apicv);
+
 void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
 {
 	if (!lapic_in_kernel(vcpu)) {
@@ -7173,8 +7190,11 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu=
)
 		return;
=20
 	vcpu->arch.apicv_active =3D false;
+	kvm_apic_update_apicv(vcpu);
+
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_deactivate_apicv);
=20
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
@@ -7668,6 +7688,58 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
=20
+void kvm_make_apicv_activate_request(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_vcpu *v;
+	struct kvm *kvm =3D vcpu->kvm;
+
+	mutex_lock(&kvm->arch.apicv_lock);
+	if (kvm->arch.apicv_state !=3D APICV_DEACTIVATED) {
+		mutex_unlock(&kvm->arch.apicv_lock);
+		return;
+	}
+
+	kvm_for_each_vcpu(i, v, kvm)
+		kvm_clear_request(KVM_REQ_APICV_DEACTIVATE, v);
+
+	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
+		kvm_x86_ops->pre_update_apicv_exec_ctrl(vcpu, true);
+
+	kvm->arch.apicv_state =3D APICV_ACTIVATED;
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_ACTIVATE);
+
+	mutex_unlock(&kvm->arch.apicv_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_make_apicv_activate_request);
+
+void kvm_make_apicv_deactivate_request(struct kvm_vcpu *vcpu, bool disable=
)
+{
+	int i;
+	struct kvm_vcpu *v;
+	struct kvm *kvm =3D vcpu->kvm;
+
+	mutex_lock(&kvm->arch.apicv_lock);
+	if (kvm->arch.apicv_state =3D=3D APICV_DEACTIVATED) {
+		mutex_unlock(&kvm->arch.apicv_lock);
+		return;
+	}
+
+	kvm_for_each_vcpu(i, v, kvm)
+		kvm_clear_request(KVM_REQ_APICV_ACTIVATE, v);
+
+	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
+		kvm_x86_ops->pre_update_apicv_exec_ctrl(vcpu, false);
+
+	kvm->arch.apicv_state =3D disable ? APICV_DISABLED : APICV_DEACTIVATED;
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_DEACTIVATE);
+
+	mutex_unlock(&kvm->arch.apicv_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_make_apicv_deactivate_request);
+
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_apic_present(vcpu))
@@ -7854,6 +7926,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
 			kvm_hv_process_stimers(vcpu);
+		if (kvm_check_request(KVM_REQ_APICV_ACTIVATE, vcpu))
+			kvm_vcpu_activate_apicv(vcpu);
+		if (kvm_check_request(KVM_REQ_APICV_DEACTIVATE, vcpu))
+			kvm_vcpu_deactivate_apicv(vcpu);
 	}
=20
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
--=20
1.8.3.1

