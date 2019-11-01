Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA39FECB80
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfKAWlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:42 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728156AbfKAWlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i654rVownEuxqIHvfUhrG3SqwWjcZiBWUzs4oLgdSbOMXHL1pjnY4JJIRAzLakQhPZvVWgvBP1mKkjE8wJ/AIfKFaHawS5dDhDdhIuHHG2A0SWTFzeu7cwmzrhopEel3HUOUqO363Jx9t4iKylRs6RV9KC3nFOGXakoIMzTGCq2k067fXCszMbMVT812zDiBuGQrKt5H+WZqny9baakGsiZrrsLSOx5//3CXA/VleywWfKusRFyqTCg2/C/SRUfuM5qBqaCaLcZeLI4M/IKi+FADYvis4HRzcl7y/JCQQuHO8lOAqjJZbPc51AQPEh7cMRCSkWT/fS3Wey7Lk0yRhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+N+HPmzEaRM223EXIBc0EtFV5YptWKRhCQ5m0nZrAQ=;
 b=lvAdtdcvY9bH8PTB81+qvOjI1a7m18InnztdNbh5K4JIb7QtZ2jwRuRFmASvef4KpbUw2b8Lrj/R56ZbhMvo9sXlIoZwlsAS8HZqoM9tvngfvso9IjTz9LIlcKJI3ifA9vZ7N6G3PZ2OCxWHEf/yNnP0qua371sDVOzPD8Z+Syxw/YYvkKw//Vl7qktbvTrrAeXk+IFMOq1+mfr0HVCQDcnyR7MSdDsP7ifvdVANpNbV/WuLO69pWuGEcV68s73lgnr0C9VUB2v4PcoxlmBHam/q00hpA/PS9HQYmg0r15CW7RJV45Nuh6WicOsrhdCdiTk5dTW0NnHfsBIExH1MpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+N+HPmzEaRM223EXIBc0EtFV5YptWKRhCQ5m0nZrAQ=;
 b=VAwWIThYIDFRiTzFJKElQh6BKZ2J6gffYhrsV7l23dwHG5Prdw4e1/5CpFPCeWR7WJd99Gk8ATt4dOAvT6kR70NFhl3E1JmG2yYO00MkfjlsAWCeYgxz10cI8LQzFAsJIFwCKZVotPPnSLBVKMy8yKiZNMVE36DAEeQiq68EpTk=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:34 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:34 +0000
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
Subject: [PATCH v4 10/17] kvm: x86: hyperv: Use APICv update request interface
Thread-Topic: [PATCH v4 10/17] kvm: x86: hyperv: Use APICv update request
 interface
Thread-Index: AQHVkQWDZA/wZ47yIkGHcdV7ZXu7CA==
Date:   Fri, 1 Nov 2019 22:41:34 +0000
Message-ID: <1572648072-84536-11-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: f7d1b6dc-16f0-48b4-cfcf-08d75f1ca5b8
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243EB5FB26DCAAC250184ACF3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYwfqqCObG8C9ICRRkzGmQMahmdwizJIIU+KPmS3kYb8kIku741y5IC0bo73DTrHv76sdZbODucn0cmc925Uw1lfhZIhPz8Ml3GEfW2cqr767wEeF135feYjMkXEwTSPJatjOxv2V/LUWWsUbiSyZdPNlGLkJ66F6dmSJT+aM41n8x7n7xBwNO84O0KM4ok4WyYd091MTCxlXwgHB0r3oHXpv6/31iQVSZYn6l5+lLGwWl67RGbsLUfSQuYzVgEoTyqU5PC06UuW/IAyWKBwVtD+c4oLjQF1k9cZuNitvadFxcaS43lY5TodffZfKb+Roud0wefXslMfdrQcfWjSTZ/DSgyGPB9Dtu58835rsNVmevNpMajsdXdCEh8n+FKxcutP0QiILIaym64PiW2FNFiKdK71+jaxERa3QEbR3Q9M2qiWMc6D5T18ndkek6Mp
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d1b6dc-16f0-48b4-cfcf-08d75f1ca5b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:34.2009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BABPmcnQfNk87Hvs39Ia0tzjAsv30JE5/TT5UBCO2+5+88Zj2GTL05RkpALojHPGB7uN7xQbY2sXv5qSZp9yOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since disabling APICv has to be done for all vcpus on AMD-based
system, adopt the newly introduced kvm_request_apicv_update()
interface, and introduce a new APICv deactivate bit for Hyper-V.

Also, remove the kvm_vcpu_deactivate_apicv() since no longer used.

Cc: Roman Kagan <rkagan@virtuozzo.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/hyperv.c           |  5 +++--
 arch/x86/kvm/x86.c              | 13 -------------
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index f93d347..a6475fd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -855,6 +855,7 @@ enum kvm_irqchip_mode {
 };
=20
 #define APICV_DEACT_BIT_DISABLE    0
+#define APICV_DEACT_BIT_HYPERV     1
=20
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
@@ -1421,7 +1422,6 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu,=
 gva_t gva,
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception);
=20
-void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
 bool kvm_apicv_activated(struct kvm *kvm);
 void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index fff790a..aa93b46 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -772,9 +772,10 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool =
dont_zero_synic_pages)
=20
 	/*
 	 * Hyper-V SynIC auto EOI SINT's are
-	 * not compatible with APICV, so deactivate APICV
+	 * not compatible with APICV, so request
+	 * to deactivate APICV permanently.
 	 */
-	kvm_vcpu_deactivate_apicv(vcpu);
+	kvm_request_apicv_update(vcpu->kvm, false, APICV_DEACT_BIT_HYPERV);
 	synic->active =3D true;
 	synic->dont_zero_synic_pages =3D dont_zero_synic_pages;
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c09ff78..0aa2833 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7189,19 +7189,6 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsi=
gned long flags, int apicid)
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
=20
-void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
-{
-	if (!lapic_in_kernel(vcpu)) {
-		WARN_ON_ONCE(vcpu->arch.apicv_active);
-		return;
-	}
-	if (!vcpu->arch.apicv_active)
-		return;
-
-	vcpu->arch.apicv_active =3D false;
-	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
-}
-
 bool kvm_apicv_activated(struct kvm *kvm)
 {
 	return (READ_ONCE(kvm->arch.apicv_deact_msk) =3D=3D 0);
--=20
1.8.3.1

