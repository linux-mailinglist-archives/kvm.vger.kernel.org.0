Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDF3ECB90
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfKAWmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:42:17 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727880AbfKAWlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSKALG7bzqEl1oyNtbyDa+ARfbd0LAcIHDred0K57EKUbHC/BjQGpL6BN2LHTi+jw+vxL8oz9bdQi45KbQnFBqNG2fofwzry+YwY+2VAKThWWoENRQKvabTK3lF1CIREHoDYh0gQcf9XB2TRyXtbrMe0Ncc6mCw6e6503y0NOQT0vKhN1EjKbD5ev3EuIXc0mwEgRckQxgMDQPDwqMxhw6VLSssKE+ZLn7dypdzmv1LmmnMw1hL/B8gylTVj2jPM2rGyi24160TodPz/f0M4cbd44aF+lvDkm6IC+wGfn0RoLWmEAi6/lU85WI2qBEvJ71m3TkU46GD9+JORB/k2Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qWbP1kTK2xxGh7lUWAsWt2JK2ILERTxcOIL3K937EA=;
 b=c9UFdYH2F6nAjzUYol5G4VMPN34S+Ga34MqXuta3ry60g2o6Mwsd0mPirEc5YiL6DBfkGVvEBhtLGjuH1IsI3DPboVKKtKqO5UU9EjI4k5YadT5ydhY1VeGID9V2HgxjZRHWfaPNFO62OHIIZl2WMuJ/7LloNVclitfd7mN7x543RL9lYW73NKhMNFu73UuKDr/rAXQpoVJNHvzWQo/zkrG4JQuwP3lRtGt+z6WZoRAPq3csyUiVVqzYKcIX1cuMf95dF84a/sNSKiTmZpEgb/QRzqruXDvfS50Zlj6pekXcz6OGiU0RtMrMznjOtKH6KA554hU5C/rDHFkiDH9QIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qWbP1kTK2xxGh7lUWAsWt2JK2ILERTxcOIL3K937EA=;
 b=MRD+5IsQ7eSe5Bj/UqBxbT37QeivRNIHC+3Pod8gkV5Tl2wr2EK3EROExtzoqOBcJH6zEEEvbkSHxu1vfcPd1Q1XAVYVFEzXr/Zl0550Tohj3dtg7FiBYK+S/D4Rt1VVyjocDqxhchuAKfQK6c06H8S0VXtx70TYbPKD0YPT9gk=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:35 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:35 +0000
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
Subject: [PATCH v4 11/17] svm: Deactivate AVIC when launching guest with
 nested SVM support
Thread-Topic: [PATCH v4 11/17] svm: Deactivate AVIC when launching guest with
 nested SVM support
Thread-Index: AQHVkQWE5V+cC6Hpf0OQw3ASVtcOMQ==
Date:   Fri, 1 Nov 2019 22:41:35 +0000
Message-ID: <1572648072-84536-12-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 838a0d0f-b918-4842-3ac0-08d75f1ca686
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243B4B883785E1CBDA03838F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nu61KVXnSZON0PGwsykZz/mg9bc3/c93gmUyKDUnGFZ8OCDcfKkw0DeGhI2HoKkvQCUGfV82wfEjJLuHeo0o2G+AylIgvuy2XoDrqT72Y+1UycLQv00xBzYkGTQ7UWdYc9z45FZJ5VsP9zerm8LTbQxRgB7ZOWenv047Zd5HruBOo3Lc2Vx8Zw4YBmVItT6nI9gUE7RbgV7E0bLQHBVLx23znewklrIMul1kD3o76Dtx8gnLYbZ02Kx3JTDipc9AHgbOlgwlFigFYR7Qx3D0jVGDsL8PuYPs0eo5vWoJIUP+X7W3c4PBNPs8wQ2y4c/JoP7oa8vxK/84174XeAkuuMuA3R4pZQJVq1dW9Xl73NYxlFn/3Es5mKUd/7cK/VKSYOeOAgv9FxUUQTe9bH7w2j1kBH9oDKvaCem/r9PeK9B390RL6xANP/cM0k8un6St
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838a0d0f-b918-4842-3ac0-08d75f1ca686
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:35.6790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Pt4Sb+x0zb9zaI8kC4+DEmd9Sm6PM/6kmAf4iyNLD/fT3AsS1dBu5F4P3REE92hi64x4cxbL4dSKim6g9xptw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since AVIC does not currently work w/ nested virtualization,
deactivate AVIC for the guest if setting CPUID Fn80000001_ECX[SVM]
(i.e. indicate support for SVM, which is needed for nested virtualization).

Suggested-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index a6475fd..55d6476 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -856,6 +856,7 @@ enum kvm_irqchip_mode {
=20
 #define APICV_DEACT_BIT_DISABLE    0
 #define APICV_DEACT_BIT_HYPERV     1
+#define APICV_DEACT_BIT_NESTED     2
=20
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5b90458..7f59b1a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5984,6 +5984,14 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 		return;
=20
 	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
+
+	/*
+	 * Currently, AVIC does not work with nested virtualization.
+	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
+	 */
+	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_DEACT_BIT_NESTED);
 }
=20
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *ent=
ry)
--=20
1.8.3.1

