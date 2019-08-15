Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049CB8F07C
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfHOQZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:23 -0400
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:65343
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731275AbfHOQZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+PFcivGyulqgPX/HObU56eQTjh1uFWhF4XDLQeiZEPXJF6ZanW8vhdOon+KlNjkcvwvQEdpZ6vc2ysqdjpXVBDfBBW8trycxXn9+f5mk456jdSS8mH10Vwfps9oRELjYlc7s4KVqr9BPEW9nASWckOa+WFd73P32u1x0e4D3wnCcj6LMjh5w5RGi8aKW55DNB3c5Q8KurgKj6xM2uQbC2i5d/W6z6sMhSwT+Ypu15RiTMSSH2PuDnZ6DKH+hxpgYxwGD5SehOUGBkdWaXP7hMR6+enldiopxounLRysbz+0vd8BUJe2/zRLtwrvj8C7wRHGY7LT1P+hil9Kh/xaOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAoBMNpO/feLboHG6j2u5el+TEEvHt9SBhV5SQzyaaI=;
 b=gRPFANd1kMK7OdoLYpoqjWtM1YnVmHxka1kMPLDDwC72e+LIB7FLNGh2H5UUoFC39N4/FuKu/fQeFh4iZdVjF3dvn60a8YAocYY+EZxgHLLJEKJyU0edi2KBzrqg7brj9/EShusSYsxYP+/oEh6FZCUJEQ28Y7HCMgYUavNK/26iQAWV2TY5o+VuxpPgaUFOvuS1HcHanCFSMCWGepnxWtkyQ7xZzplnE81qi5pmEIvk/A3aEmOw3Q2HEqu1Zc068547y+Z/pzjivS2mSdkMvLvpjGlnRjbVb3P6ApTPLpPPQYKxdU6d0Rp4cox8fC3Ok/8m8DCGrzXgyJ8pc2zPYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAoBMNpO/feLboHG6j2u5el+TEEvHt9SBhV5SQzyaaI=;
 b=s9tbteoubtIavkqH0q2gUvHUwitdk5SnBDTqi+LOlpExVtBGYOgCeIc/VNuFQRh0zCajAd0f89YYDLXOEAyEwXsdlIKE6iriJrRZYyvBoJe6Ydz8sfeKPsgan8S1SAaGhd+A3I4vhXC5TDmRfxkeNBjz7opfTeQ+5E82vbks3QM=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB2603.namprd12.prod.outlook.com (20.176.116.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Thu, 15 Aug 2019 16:25:19 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:19 +0000
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
Subject: [PATCH v2 13/15] kvm: lapic: Clean up APIC predefined macros
Thread-Topic: [PATCH v2 13/15] kvm: lapic: Clean up APIC predefined macros
Thread-Index: AQHVU4YHUL0hUxLzwE+xDgwP4yKbCA==
Date:   Thu, 15 Aug 2019 16:25:18 +0000
Message-ID: <1565886293-115836-14-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: dfaef99a-9c08-46a5-b80e-08d7219d2987
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2603;
x-ms-traffictypediagnostic: DM6PR12MB2603:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB2603FFE81F69008C2C0DE0BFF3AC0@DM6PR12MB2603.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(199004)(189003)(14454004)(256004)(6436002)(81166006)(81156014)(478600001)(4326008)(99286004)(14444005)(5660300002)(25786009)(50226002)(8936002)(305945005)(66066001)(476003)(26005)(6512007)(6116002)(186003)(102836004)(7736002)(446003)(71190400001)(53936002)(2501003)(11346002)(6506007)(2616005)(2906002)(6486002)(8676002)(386003)(36756003)(3846002)(110136005)(4720700003)(316002)(486006)(86362001)(66476007)(66946007)(66556008)(64756008)(76176011)(66446008)(54906003)(52116002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2603;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /4MH8nlodkPOC5IKw+scmVnTVcepK94kJT18lOfaAO40jhBVI/JVNqms2SZFQf+c0ts3FCe3ehaswlz5cbgoE8VRwIOIaLdY6R5UmHRV5D5JV717GDPHPHXOHqJBRoQkr0eC1a/cP/BWFhJLmRZO3mUQM4hIOiVfBbA1puRk5jLM10agauSwYM+MxlXmClLAuU4lwlXViPDRlAraq3n/H13B+E08A+iWa2XQddme7rSfFRykPfsXPrDsLZCtgfxG7CvOVwv3g1FqwvhwwK+hJ4IUFi/9PMwtrplrtOPUxCZnvjZZtWhAZHm65g/IjFc/lzfOE0LtJqn4W2ZCVElM+QgLvZmTNkSrFi402kIEVzISRea58pHIthwdENsILuY08KS25Mr+oj4FCTspW7pGypiHaV61L/M4f0PF478C70k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfaef99a-9c08-46a5-b80e-08d7219d2987
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:19.0404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /xH30Ax15AKKi+mU5dRN22aL7VsSD9FoIVWtzZ5jUbCoEZwZ+0Nbn/OwEmePayii+KRO9mtzyUFB8oC3zH5Elg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2603
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
index 90f79ca..3f0674b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -59,9 +59,6 @@
 #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 /* followed define is not in apicdef.h */
-#define APIC_SHORT_MASK			0xc0000
-#define APIC_DEST_NOSHORT		0x0
-#define APIC_DEST_MASK			0x800
 #define MAX_APIC_VECTOR			256
 #define APIC_VECTORS_PER_REG		32
=20
@@ -566,9 +563,9 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_=
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
@@ -808,7 +805,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct =
kvm_lapic *source,
=20
 	ASSERT(target);
 	switch (short_hand) {
-	case APIC_DEST_NOSHORT:
+	case KVM_APIC_DEST_NOSHORT:
 		if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
 			return kvm_apic_match_physical_addr(target, mda);
 		else
@@ -1211,10 +1208,10 @@ static void apic_send_ipi(struct kvm_lapic *apic)
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
index 3892d50..fb02e3f 100644
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

