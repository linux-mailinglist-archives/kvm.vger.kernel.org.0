Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E383FECB89
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfKAWlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:51 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728206AbfKAWlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7dURyvwTpk6A9yowlH5mizgs/oJ37shB25I0pD0iJx/K2gwJBbhKXwzEe8wJ04DBkGaPfbeiTWM0Ai0Arn1pr2dtu3dghD/HfwyKSseZQ57mKpQ6vSYDunITlNDESvcCm4QVUXGrHpCICBmyerjnfJJ6Z3GxT6FU3ujBtsLrOZW2AryILrj7LnUnmyaQsy8d20UH/91wMzdDh8DW0r2fTqiztsVeUwhpYblJckxC3oAs9/PEYpuyxkHiS+2Qmu7C5xOCRvRXeleCR+45kDP4ql879Jpg40apbnPdANTr6/0sFp01wh12vA2zxlUHbf1Kw4/kuU+nxkxM6V04MdF3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WItHlX2xhz/0kTfpT8F/2/emW56oZMiKbdc+KwU9cS0=;
 b=BWBR5+Og+i19XGn+EqsQJ4XvEb1jgJXHOg+i1R8RQ9Lw0HOPmzJNdeL49qdBzOd/qShLBK+I6tN+ppuWM/2r5MezQT+CcNR+kRdUjLmxJKDIrQmvn+cGfWtUejVc9Nd4k4CoMMi0UX3/4Uhf7bJYMyXigExevDqo2E2dS+4SbhZ2F7tEPXy/ccnF1naiBIHDpuEn0WOdMTsehtEpi27GAevBfONUW4vNRuEhRz8m/Av26zNhczAZ0/XTs6JIj0SH0gHIuLsS0Y6T/CtSFDdOIPrGIFKbTeYib9z/ubP+FvRkYuZW+LwN3gbxoxUHjqTV+hSVcSonI5RkpSLQLrqBhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WItHlX2xhz/0kTfpT8F/2/emW56oZMiKbdc+KwU9cS0=;
 b=g412diC8mWomw8y+BE6k2sggKiEpvIShnLl9LlroQyxrwCpSq7wDkiYONzv0vbxh2rajmFFclB5DRSLtBOs6mwgDG/wIIvKseEkR5LeWDgR8YNIs4oUPwwLiLQUJFBYM6dkPJs6AxZvh1sbDiYcvC+ymKJomMWo3EEq2h0YwPIM=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:39 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:39 +0000
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
Subject: [PATCH v4 14/17] kvm: lapic: Clean up APIC predefined macros
Thread-Topic: [PATCH v4 14/17] kvm: lapic: Clean up APIC predefined macros
Thread-Index: AQHVkQWG3RtYl59N/kCcrpOQl+z4tw==
Date:   Fri, 1 Nov 2019 22:41:39 +0000
Message-ID: <1572648072-84536-15-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: c9ce428c-fb0f-414b-c147-08d75f1ca8ac
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32433792C8B1057C354634B3F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uKBuN8oi2Uh+Q21js0UUTAFsBW6K0kRVa5mJ54F2Qggx0BWi6zMVBg/WfDO95tVHwgRyetxCzsYkgp6RT4VTdFOAKTQecatkCHCBWOFPfYOorTQPFR6MW96fIkbEc7MWMNbpWICXc5pqG3c0yJFZ1suZt3WYMJPAFqwpGiCZr/DR9NQmv+MM1Mh7sxnhNXFiTz+LKT77MisjKz2H7kITH4IsVJJ7LsxDBI+6PKTU63wGFlICGG+gMawsrTcetvJN0UfVv/szZYG2B5VLMPI0jJYWyjxbJ2asfVQik9Iz95VLIjfUwHcNR7cDwFPnOsYaYyOhT9SzU9cgqKrdg4aCjIQrSK4V01oPJvoVBs9OobzGFOGRab1ug/3Lm2A/O5RTvD1gGLXD4NLAG6Mc0vpbdD99Nve0a4V3zNi3KM7h/VQB8DT625q1r0E2ll8eygoT
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ce428c-fb0f-414b-c147-08d75f1ca8ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:39.1380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CKf0yLFuFUXXmwofBZFM8pL7tabe4+ffgdH2+hIfiIW/2CClA9JiCTjhajzXkFwWiS76uZ4Hq/Q0YU5xRxyJOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
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
index 4654230..07e154e 100644
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
@@ -575,9 +572,9 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_=
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
@@ -1206,10 +1203,10 @@ static void apic_send_ipi(struct kvm_lapic *apic)
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

