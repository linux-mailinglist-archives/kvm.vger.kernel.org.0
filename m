Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E6ECB7D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfKAWlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:37 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728017AbfKAWlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWUg3nySTTlS/yYWBkpdnwEPLrN5ylsvd0KNO06n0iqABPUW/bmCS11x916j1qfMMGmtU4TP3768ceG/CB0+qIAuR6zmlfDJPuQMa000RFq9iw92ndkX0Ce0L6UYN6/d+hJQ/xE8kszR0VpVRyU7/QxPaDiIePEfVicTdDYkGIxhNwwE44Q6gAzBtOivF4ndBEMwqc4E6aVByz0opVdCBgWvYauC5idV3VoVWYIqnpNVaMZ2KSYKQvzE9jgppqgvHGRH0t4Pf7nawd3C7S+ECkIgQ5jp5qCPLO9c7IdhXk3j7MxMh13RKCvKWcaMp4TC496kUeNUNUZ9ZGDBbIXOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ1LTp64Oaxbe58aMYNPEpEjslGNwZBKlPI2QoMXaQI=;
 b=B5RSwVIEkZE6Lb/CR01iSopb97CZKvluZSU3axDzltL3z6+y/PHxGw4Rh78hgE0zo3gGWBeEnX23onsLB4+TFNsQOSk9cOmysn3CV52oS3XxXt2kaLpPejQHCF6Cf7tREFheTrI307+b9DHnfvhHq9fCsCJPeQiW068sJx0kv3dYoqd5UPd128V2eHQ+SMQo8scBjmGnabLPZfk+gnNlt5ouI6UlD3A2WD4QHGLQEZiHFyG65gcIu4a89TQqJp3m7eZkiZBSIBSLSeHiYhDo82q37ecUnmiGoxxvZo4T2nkixpR815vV+9d4cSWNFQhQpVXO+T6E2oViHsEQDO8BAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ1LTp64Oaxbe58aMYNPEpEjslGNwZBKlPI2QoMXaQI=;
 b=hvqXVRvhPf6T0DPDWjUHr1Js9bLxy/iafnvx8CDDRwaeBhChOf2Fau+RsDwDXcNjVOGwWa44z9yl6Yi2+CVMZ42RMMk+nfMImnBxn4RHWBeKAGI4EJRTCwCU/+EwUVFb6VaUgi2Cis1aQv/JD45l7P1rWBkej18aAS6cjn4Anp4=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:28 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:27 +0000
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
Subject: [PATCH v4 04/17] kvm: x86: Add support for activate/de-activate APICv
 at runtime
Thread-Topic: [PATCH v4 04/17] kvm: x86: Add support for activate/de-activate
 APICv at runtime
Thread-Index: AQHVkQV/8CsVLszkbEWXIyta1bn49A==
Date:   Fri, 1 Nov 2019 22:41:27 +0000
Message-ID: <1572648072-84536-5-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 128825d7-37a7-461d-4bbd-08d75f1ca186
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB324378A7679F48A40FCC97C0F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RM8ozn/O6UuWsB4NL38J98MZrfgVwaybSXwztKCYB3lgXpwb8hry6j6oYS46Gx0SqlkOWlVZbamHs8kR3Otk7wOSkQ1RO6UEOVfiY09dx/0bD14Ki+UxY5A7YHA3Wz5/NFjww4ou3eW+JySZGnZyZ9RsDINiBiOhvtq4Fi1kpvwMldNxMvErcJubIv5zlSQc3yxezizc8IHp/4+KYyngkoXXimROToR7WpeoZEG5ID+LLC4Z1U6qbdXcnPxuKUimnTSZZzOnXixu67iCMRdhJdlWAe69/xLJNXr54Yk4GfB0zhyma0wL9qraPnHjwo0DerzfYC9ROaWK32jPKhswfe2eSoMGxkSLL9FYBfWBqmBiOKyGnvjpXDJ/nVORMRTR5f3VSdO28bilJ+0j8oHQBXdUKAxLqwV6httk6nR0SdK4uu2unSJB7JHJPQxD2B+d
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128825d7-37a7-461d-4bbd-08d75f1ca186
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:27.1749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hUE3CYyz1qWiA3NuXBmnsA7tjceiNqxuwSpj+3uVC0i0ArmtiOk7e7Ig6wwllGERUphf1TdJSwEIBxpq8vmm9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain runtime conditions require APICv to be temporary deactivated.
However, current implementation only support permanently deactivate
APICv at runtime (mainly used when running Hyper-V synic).

In addition, for AMD, when activate / deactivate APICv during runtime,
all vcpus in the VM has to be operating in the same APICv mode, which
requires the requesting (main) vcpu to notify others.

So, introduce the following:
 * A new KVM_REQ_APICV_UPDATE request bit
 * Interfaces to request all vcpus to update (activate/deactivate) APICv
 * Interface to update APICV-related parameters for each vcpu

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/x86.c              | 30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 1c05363..3b94f42 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -78,6 +78,8 @@
 #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
 #define KVM_REQ_LOAD_EOI_EXITMAP	KVM_ARCH_REQ(23)
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
+#define KVM_REQ_APICV_UPDATE \
+	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
=20
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1421,6 +1423,9 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu=
, gva_t gva,
 void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
 bool kvm_apicv_activated(struct kvm *kvm);
 void kvm_apicv_init(struct kvm *kvm, bool enable);
+void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
+void kvm_request_apicv_update(struct kvm *kvm, bool activate,
+			      unsigned long bit);
=20
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70a70a1..394695a 100644
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
@@ -7730,6 +7731,33 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
=20
+void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	vcpu->arch.apicv_active =3D kvm_apicv_activated(vcpu->kvm);
+	kvm_apic_update_apicv(vcpu);
+	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
+
+void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
+{
+	if (activate) {
+		if (!test_and_clear_bit(bit, &kvm->arch.apicv_deact_msk) ||
+		    !kvm_apicv_activated(kvm))
+			return;
+	} else {
+		if (test_and_set_bit(bit, &kvm->arch.apicv_deact_msk) ||
+		    kvm_apicv_activated(kvm))
+			return;
+	}
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+}
+EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
+
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_apic_present(vcpu))
@@ -7916,6 +7944,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
 			kvm_hv_process_stimers(vcpu);
+		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+			kvm_vcpu_update_apicv(vcpu);
 	}
=20
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
--=20
1.8.3.1

