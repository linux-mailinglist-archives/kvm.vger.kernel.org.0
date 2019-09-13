Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2831EB2589
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388536AbfIMTBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:00 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:58712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388433AbfIMTA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:00:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdoPaFML8Z9QHnguIKC40GThHFq7rmb778InnYnZ7k6pcmsTTiHjxLJbtBFyiwI2+9Mvo5X7WVL90Jmrqtpqo+Vm6T/vJo9nu4tsImsA8ZXxSUKbeTbxvuHRmJG01NK3nJYoshssQifH5AZe40UiShP/pvkaJsapeWHl/PiFKV8SQ89VC1cfrbZKrOh3iMkktZoZo606D9MpIG0Oq9lv2iwQCUPJFDD/2jDeEs/xlDPcAM7VLYPrzpUueSfBDW8CAMwaSKskHJGwetsbV7HKr4XGGfDM6Hf6lFXo0eOBkp4zJZWZI+p+pD2z0WhHBosIdE2ra/JgxMS+U504O8f/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhFoR3JR4LkRjSXZz2BK0fOCXzBUH/ZNUBXd1fiv67g=;
 b=KQcMq5AwyBbEY4ByiaiCdsNFhycy75jOqliMlxlk0Flp6ckOtyWsbtuu/Wxhp3Tb1D7LBck0gRkOjzovXz78sui5gHifPBAC4bmn38l1rH6E776wnYP6QU01pM2SsSORqDsSr2rg2dNx5IfuN2OedBeCYfwQNMkw8KeLab+fPksMdS7djaBI58p7qsjsKlQNGIu8gsW6A4iwM6S6pw/8ag8qwKnmkIkHdP1PnZqAkO8xp5BjPCnSY0MISAMyIwz/qpFMdIYkZBTyeJVZkYa/3Ch4++OszQPw2jIXKTW7QhpUmS1EEq5c8F2aSuURPmPWRF0CjQoqQfWIZPxgZGwmgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhFoR3JR4LkRjSXZz2BK0fOCXzBUH/ZNUBXd1fiv67g=;
 b=sfeb9Y+6NwWQD1bH8QdLNm8cXeVYxki3zMM7PfYK3xEsJO7QqC36IuxZ2QVlvvO8yxgEnVayzVVoxGNDrMvlBgQ4nwyU6F4FAMLKb0S/RFm8OVYAP8hl4TH1ePbwESV2uyOV86mkNRVgrFbEk2IDXF0WAsoAUcH5hf/YFc9CcxU=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:53 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:53 +0000
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
Subject: [PATCH v3 04/16] kvm: x86: Add support for activate/de-activate APICv
 at runtime
Thread-Topic: [PATCH v3 04/16] kvm: x86: Add support for activate/de-activate
 APICv at runtime
Thread-Index: AQHVamWRksfayE4Ir06mG5Gxp2AffQ==
Date:   Fri, 13 Sep 2019 19:00:53 +0000
Message-ID: <1568401242-260374-5-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 6118ca2f-cb1c-4ee2-8e3e-08d7387cb37e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3804CC67D77B3EF9B6CE4701F3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lUTu/pbSg7sjaU66ID87iCDvc+nOxtq01g3/0JU9GiA1Hu6q2n7De9TJB4hEuBnbVblAhVGz3z9gx4bqRN8jRpiW+B7C/JLwGbPDi7yHvZTosk5jZo48GgJndTGlj/lANh+uyqoHZi/mBND2VySfDQQLsWTiyr5AKzHKYB9TidI3OaQOtpm4VPh12GEZi3XGI31NFZWQP89NLnB2qWz8C8Kw/0/25zBsWTNDuYCy+shoNNEpT+WZzV/Xs1ahNFrlgp45O06lK1eyh4SwqEf/C2ad+ZNFhRq6KCa5N2ZQ1TK1Bb2cAiBjiWRjfZlLntHGLxZw7iJ+daDJu9oHR7weh+b1SeJKkKvo1WPSdbcM9a142WJAFfHOvuBVrsC6Bf0WnCgAr56gF8yoSpYtqlbgZOaTwIDhBW445iWdMQVfyT0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6118ca2f-cb1c-4ee2-8e3e-08d7387cb37e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:53.6679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nmqXPJ8Vht5PGrEPRvweOwwuMBqbuencD6fs9Dr1XFYIYfs4zz4V0/zvplF4Tk1CsRWWMF7al0feh1Z+irVjxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain runtime conditions require APICv to be temporary deactivated.
However, current implementation only support permanently deactivate
APICv at runtime (mainly used when running Hyper-V guest).

In addition, for AMD, when activate / deactivate APICv during runtime,
all vcpus in the VM has to be operating in the same APICv mode, which
requires the requesting (main) vcpu to notify others.

So, introduce interfaces to request all vcpus to activate/deactivate
APICv.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ++++
 arch/x86/kvm/x86.c              | 95 +++++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 104 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 562bfbd..a50fca1b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -78,6 +78,10 @@
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
@@ -1098,6 +1102,8 @@ struct kvm_x86_ops {
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
 	bool (*get_enable_apicv)(struct kvm *kvm);
+	void (*pre_update_apicv_exec_ctrl)(struct kvm_vcpu *vcpu,
+					   bool activate);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
@@ -1425,6 +1431,9 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu=
, gva_t gva,
 				struct x86_exception *exception);
=20
 void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
+void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu);
+void kvm_make_apicv_activate_request(struct kvm_vcpu *vcpu);
+void kvm_make_apicv_deactivate_request(struct kvm_vcpu *vcpu, bool disable=
);
=20
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64d275e..446df2b 100644
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
@@ -7184,6 +7185,22 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsi=
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
@@ -7194,8 +7211,10 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu=
)
 		return;
=20
 	vcpu->arch.apicv_active =3D false;
+	kvm_apic_update_apicv(vcpu);
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_deactivate_apicv);
=20
 static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 {
@@ -7711,6 +7730,78 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
=20
+/*
+ * NOTE:
+ * With kvm_make_apicv_[activate|deactivate]_request(), we could run into
+ * a situation where a vcpu tries to send a new request to a target vcpu b=
efore
+ * it can handle the prior request.
+ *
+ * For example:
+ *
+ *     vcpu0                                vcpu1
+ *
+ *     kvm_make_apicv_activate_request()    ...
+ *     Handle KVM_REQ_APICV_ACTIVATE        KVM_REQ_APICV_ACTIVATE=3D=3D1
+ *     vcpu_run()                           ...
+ *     ...
+ *     ...
+ *     kvm_make_apicv_deactivate_request()  ...
+ *
+ * Here, vcpu0 would have to clear stale apicv activate/deactivate
+ * request before handling new one.
+ */
+void kvm_make_apicv_activate_request(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_vcpu *v;
+	struct kvm *kvm =3D vcpu->kvm;
+
+	mutex_lock(&kvm->arch.apicv_lock);
+	if (kvm->arch.apicv_state !=3D APICV_SUSPENDED) {
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
+	if (kvm->arch.apicv_state !=3D APICV_ACTIVATED) {
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
+	kvm->arch.apicv_state =3D disable ? APICV_DISABLED : APICV_SUSPENDED;
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
@@ -7897,6 +7988,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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

