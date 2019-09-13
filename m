Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF26B2591
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfIMTBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:14 -0400
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:62364
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388899AbfIMTBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvH2tTrfhIozFnmuMCUsQ34RGfoPJDS4j+eYO4Upv9riQU7jlRPUpWbcLyR8lYHXKKigXcn7uFzRivnT+jMynxe2DnAcm4HfzuhHJzugJ+41Wm/FKZRyzTxsrqw8Zud8GWbFyMTmCaFCrYY8tsmlf/qHnyVzCk/ZSW8BfIWjqxBdKsyU6hyrR4aOuOF6Lb+g4kZOK2BU2Fx4rywV2uWKTDUQiszmms1DL8EXMeorZk6Of8DCQeFyPEPD18j/pUMH5oZZkVvsSywMm8rDQrwikfgNr/31X7Gh6/zjrYJqlVTu/K3GWydsr99IKUf0RpaLT0aAgHLwgbPJkBByQiw0DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVqRx2eJKZYY0qvkOo3QsPxcTwvW9OZrBfv1/q23aig=;
 b=Z5fxWbmGWA9NN+ReTjaRz3Hy+zkr74jy7+tM6QcO3+sic0pztbG/LLRVk2hchJjU/5zXh+HiBS704vvMKAjvCE4kQ9VBYn4F0FFxwqY28ZsbJlgua8NngT8xKSl/ZQK5dTf7y8a++uGaiIXyRclmTCWy088rP9zzPvRIUH2ITVIy7Zvew7Kq5xZN/az4CzN/DCEtZgo5pI8Ucey4cu47k0cV9pMrL+VZbTkvYsWtnpbWJTCxwM/4MWGm0N9+jT8isWwN7hrg3YaP9t+yTu0PBiZQWG3ve/7ucluHjXr+6JvQ2rk2sR8cAqYtmoIiDnuEeKskLlnwb3H+z95bjla9Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVqRx2eJKZYY0qvkOo3QsPxcTwvW9OZrBfv1/q23aig=;
 b=TitwHuLO5OjjU57uol36T73WZzRw8+O8jMw1RzRA1FRryUlNsYwscqoDMAcI9YXkVYDJskNpA487g0146K/El/tvh3T+L+tjdlXQAGE18EBB6CVWkSc/Z33MWZ2E8uoewwUlMJnzoUp49pvxieWkmoRkHWsZIrOamf0PDlVcifI=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3596.namprd12.prod.outlook.com (20.178.199.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 13 Sep 2019 19:01:07 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:07 +0000
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
Subject: [PATCH v3 13/16] kvm: lapic: Clean up APIC predefined macros
Thread-Topic: [PATCH v3 13/16] kvm: lapic: Clean up APIC predefined macros
Thread-Index: AQHVamWZ+Ds3rNAWoU2hmN8A3MjObw==
Date:   Fri, 13 Sep 2019 19:01:07 +0000
Message-ID: <1568401242-260374-14-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 1a35eba4-cec2-4c5c-b6c9-08d7387cbb7f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3596;
x-ms-traffictypediagnostic: DM6PR12MB3596:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB359695871D8780A02E352B7FF3B30@DM6PR12MB3596.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(66066001)(7416002)(3846002)(6116002)(81156014)(186003)(8676002)(81166006)(54906003)(6436002)(52116002)(110136005)(316002)(76176011)(53936002)(5660300002)(71200400001)(71190400001)(6506007)(386003)(102836004)(6512007)(486006)(26005)(66946007)(8936002)(66476007)(66556008)(64756008)(66446008)(4720700003)(2906002)(99286004)(50226002)(6486002)(446003)(256004)(14444005)(25786009)(305945005)(478600001)(11346002)(36756003)(476003)(7736002)(14454004)(4326008)(2616005)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3596;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +flAJ3MtQSRLrQqE7FVqT0Z2J2XtEDlhkzgdb60asItyuOTA+a2ApInVyeezF70ptDKMQ9OjKcGqMnEMr8H2akV+Zp/FxvrJ5WluArqNLXw/uu1lyrVuBFvy/JFgi+MV7MCrSUQ/AIYobMEWWE4M1OGKtz5JnUirEiaeFVHap3hRsXyYitAfBpRGMhaO3WOKPcMJr0+c0b8ku/Xe3FNCHriCnnvfZzOc+oQNa0jdqwVVaWe23btM9rEC7uF5mg/VrGU2tq2uF2lGBGkw8U6DRRKFUMTtVYPwVTUfmu7XnU5NZ1eb4mpi4vW2LnMfVcah4vc0F0AcrJfctzitLEVOaavzNr62eaFLsbSOZLMdu5JwW5v2Qbaj0CFszVgpdR916iZ5gNxpb5CyHUf1APc5eSJZ/apyifKiOjpt7aiaudY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a35eba4-cec2-4c5c-b6c9-08d7387cbb7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:07.2362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hs5C8wA6OIbIKvHNMMSzM7A4+ryW8rZYI81maFs6ti9H8KryqpiLC7lC+zB7u8w7tuz7BxFyTYYuQTKSPU5f1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3596
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move these duplicated predefined macros to the header file so that
it can be re-used in other places.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 13 +++++--------
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6453273..32967dc7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -56,9 +56,6 @@
 #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 /* followed define is not in apicdef.h */
-#define APIC_SHORT_MASK			0xc0000
-#define APIC_DEST_NOSHORT		0x0
-#define APIC_DEST_MASK			0x800
 #define MAX_APIC_VECTOR			256
 #define APIC_VECTORS_PER_REG		32
=20
@@ -570,9 +567,9 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_=
bitmap_low,
 	irq.level =3D (icr & APIC_INT_ASSERT) !=3D 0;
 	irq.trig_mode =3D icr & APIC_INT_LEVELTRIG;
=20
-	if (icr & APIC_DEST_MASK)
+	if (icr & KVM_APIC_DEST_MASK)
 		return -KVM_EINVAL;
-	if (icr & APIC_SHORT_MASK)
+	if (icr & KVM_APIC_SHORT_MASK)
 		return -KVM_EINVAL;
=20
 	rcu_read_lock();
@@ -803,7 +800,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct =
kvm_lapic *source,
=20
 	ASSERT(target);
 	switch (short_hand) {
-	case APIC_DEST_NOSHORT:
+	case KVM_APIC_DEST_NOSHORT:
 		if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
 			return kvm_apic_match_physical_addr(target, mda);
 		else
@@ -1201,10 +1198,10 @@ static void apic_send_ipi(struct kvm_lapic *apic)
=20
 	irq.vector =3D icr_low & APIC_VECTOR_MASK;
 	irq.delivery_mode =3D icr_low & APIC_MODE_MASK;
-	irq.dest_mode =3D icr_low & APIC_DEST_MASK;
+	irq.dest_mode =3D icr_low & KVM_APIC_DEST_MASK;
 	irq.level =3D (icr_low & APIC_INT_ASSERT) !=3D 0;
 	irq.trig_mode =3D icr_low & APIC_INT_LEVELTRIG;
-	irq.shorthand =3D icr_low & APIC_SHORT_MASK;
+	irq.shorthand =3D icr_low & KVM_APIC_SHORT_MASK;
 	irq.msi_redir_hint =3D false;
 	if (apic_x2apic_mode(apic))
 		irq.dest_id =3D icr_high;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 36a5271..ba13c98e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -10,6 +10,7 @@
 #define KVM_APIC_SIPI		1
 #define KVM_APIC_LVT_NUM	6
=20
+#define KVM_APIC_DEST_NOSHORT	0x0
 #define KVM_APIC_SHORT_MASK	0xc0000
 #define KVM_APIC_DEST_MASK	0x800
=20
--=20
1.8.3.1

