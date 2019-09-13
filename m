Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48E4B258F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbfIMTBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:09 -0400
Received: from mail-eopbgr710062.outbound.protection.outlook.com ([40.107.71.62]:6592
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388220AbfIMTBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E073ClBml9HQO6LwfxuPMLb6V/fKloi/TqV5plqG0z3ma8j+RraSaG2eE964fB93rX6bAsnyxe6lX0tDg/S7tozpx24fJBvFlkBGpV5yKR+eClb1EPWAbvMKUfGXrUpg77UH76BceKUte2EFxFS/6nZgmVtffk14FZrQ9/65XUpJvg0LidrDqHnAoP60d4lUCXTx3R4FcSx0wCjAo5FLld32V1jLKK2c/MC78plSPeoqhaJoyQf6YY+qD0+KSUguDRHvjnrbGBBlK6q1nODFaatpXYIROLR1eYgdrOhGQ14oasHE6pBWkdZIZfHh1Poag3b41xOfshcWWQvJgYWvXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6sgdBiQS3BiFWN4XzUCEAEBdRYxks6q2Hol8ow0ckY=;
 b=CAnlxHvXH4/dQe+979YVahGm0b14JJZ8ctjjTfEi8J3koZfB9iJ+mIDzK+s+byqezx3iRv+lQHbYoVmtSmD8gf7Hvc9RFBS8BVUpHyYcw1xAYpzcPXvweUoYWzSJ+D2jPr8jLxaJBdDI//X0SBbz/VoT8BiCO3xBHkVWiKZxsjA+tXX2udl/Za1OJuXn8obqAK6Svqk7/v8vi0ci1sv2VL4tnInob703d7ydX3tUcUvoCVLF3T68iexnS3wh24qdEd5+xLYlpX09wQIdOyKlR+IPC6icwSQ9nyAxFUELt0o3GSJCwYgNIOEBIUP622v/k6DeYxRNFltvPqh2iRkzQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6sgdBiQS3BiFWN4XzUCEAEBdRYxks6q2Hol8ow0ckY=;
 b=DzoECLStByPNhAI2qB91mvw37eW/AmowyfkYmJSspQkMMcOZsUQWA7SNkOHOWibvUsrmW8Y3gzyHj/5JZLk5iUnmK+f+mzUrkEr5SQPFTLiflSDoCKFKVgNAb1aug7M87mH5IwNqHxdWQpUnI4W1W5cciWcU2ktmco4ixbvASss=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3596.namprd12.prod.outlook.com (20.178.199.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 13 Sep 2019 19:01:06 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:05 +0000
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
Subject: [PATCH v3 12/16] kvm: x86: Introduce struct
 kvm_x86_ops.apicv_eoi_accelerate
Thread-Topic: [PATCH v3 12/16] kvm: x86: Introduce struct
 kvm_x86_ops.apicv_eoi_accelerate
Thread-Index: AQHVamWYM5VvTyQPHE27kuPQ+2CvWg==
Date:   Fri, 13 Sep 2019 19:01:05 +0000
Message-ID: <1568401242-260374-13-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 51ece17c-5193-4cb3-7de5-08d7387cba4d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3596;
x-ms-traffictypediagnostic: DM6PR12MB3596:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3596E709BCC75497C30CCB40F3B30@DM6PR12MB3596.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(66066001)(7416002)(3846002)(6116002)(81156014)(186003)(8676002)(81166006)(54906003)(6436002)(52116002)(110136005)(316002)(76176011)(53936002)(5660300002)(71200400001)(71190400001)(6506007)(386003)(102836004)(6512007)(486006)(26005)(66946007)(8936002)(66476007)(66556008)(64756008)(66446008)(4720700003)(2906002)(99286004)(50226002)(6486002)(446003)(256004)(14444005)(25786009)(305945005)(478600001)(11346002)(36756003)(476003)(7736002)(14454004)(4326008)(2616005)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3596;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rN5SS90dNaVu/hMVsT8YerUM+6XVtTvXLQA8zxALptXV6HEW3ejmtMzcn/jTOLn+zzL+KtRvGMEn5bB/4NHMSgVdKMqVKmAblPw7IFLHIxb/QofKVKMW6Rg13scmUKCrrNzO0dfRcV76decgdlmVkZgUdYxjgf79RRgikUE8hnQpSBmiC43knrU1jvG+BFfhiDTPur5igaYq4tPPQlx3bG38VCFlcbJNXIp+CAypmJgxYpA/LqpA4iz7dyww4DbzwxFLjPAFN82mEArJgNxjU5j30u+pHxw/9TlnN5GvfOCvTHItxkdcL0YCa1z2fyAxOD+EtWQ2/qQZfoYDjn+SKB81k7/vy4uNDbMycSHLsga7lCMGnoSl3G/WQacvUNWz7vHAID4GS5ish/2oFkf+uxcsdj/lry5yYVmCFpVaHvE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ece17c-5193-4cb3-7de5-08d7387cba4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:05.3342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 05HOVf1BX7XP5U8lnYCBtr56MBTzNABNC1xA5K4tUiFeFvnSZX1GL37Zi+Ips9LZYRYy5GbqYGFiCubJ8UAOeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3596
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SVM AVIC accelerates write access to APIC EOI register for edge-trigger
interrupts, and does not trap. This breaks in-kernel irqchip, which expects
the EOI trap to send notifier for acked irq.

Introduce struct kvm_x86_ops.apicv_eoi_accelerate to allow check
for such behavior.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              | 10 ++++++++++
 arch/x86/kvm/x86.c              | 15 +++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 624e883..0bc8b29 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1105,6 +1105,7 @@ struct kvm_x86_ops {
 	void (*pre_update_apicv_exec_ctrl)(struct kvm_vcpu *vcpu,
 					   bool activate);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
+	bool (*apicv_eoi_accelerate)(bool edge_trig);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
@@ -1438,6 +1439,7 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu=
, gva_t gva,
 void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu);
 void kvm_make_apicv_activate_request(struct kvm_vcpu *vcpu);
 void kvm_make_apicv_deactivate_request(struct kvm_vcpu *vcpu, bool disable=
);
+bool kvm_apicv_eoi_accelerate(struct kvm *kvm, bool edge_trig);
=20
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f04a17e..457ffe1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7357,6 +7357,15 @@ static void svm_pre_update_apicv_exec_ctrl(struct kv=
m_vcpu *vcpu, bool activate)
 		avic_destroy_access_page(vcpu);
 }
=20
+static bool svm_apicv_eoi_accelerate(bool edge_trig)
+{
+	/*
+	 * AVIC accelerates write access to APIC EOI register for
+	 * edge-trigger interrupts.
+	 */
+	return edge_trig;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init =3D {
 	.cpu_has_kvm_support =3D has_svm,
 	.disabled_by_bios =3D is_disabled,
@@ -7435,6 +7444,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm=
_vcpu *vcpu, bool activate)
 	.get_enable_apicv =3D svm_get_enable_apicv,
 	.refresh_apicv_exec_ctrl =3D svm_refresh_apicv_exec_ctrl,
 	.pre_update_apicv_exec_ctrl =3D svm_pre_update_apicv_exec_ctrl,
+	.apicv_eoi_accelerate =3D svm_apicv_eoi_accelerate,
 	.load_eoi_exitmap =3D svm_load_eoi_exitmap,
 	.hwapic_irr_update =3D svm_hwapic_irr_update,
 	.hwapic_isr_update =3D svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1540629..fa55960 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7221,6 +7221,21 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu=
)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deactivate_apicv);
=20
+bool kvm_apicv_eoi_accelerate(struct kvm *kvm, bool edge_trig)
+{
+	bool ret =3D false;
+
+	if (!kvm_x86_ops->apicv_eoi_accelerate)
+		return ret;
+
+	mutex_lock(&kvm->arch.apicv_lock);
+	if (kvm->arch.apicv_state =3D=3D APICV_ACTIVATED)
+		ret =3D kvm_x86_ops->apicv_eoi_accelerate(edge_trig);
+	mutex_unlock(&kvm->arch.apicv_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_apicv_eoi_accelerate);
+
 static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 {
 	struct kvm_vcpu *target =3D NULL;
--=20
1.8.3.1

