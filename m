Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D35ECB78
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfKAWl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:29 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727029AbfKAWl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbVvEhhjrezlI6sSz3db6FVyFEbBHT5My9nCJxZQzkNwS2fJ/I2AzxjhuR+6sWx/2ztISINlzumhZM7KP0V0oeqOkGD5gZDEutnY+hu2ZEv/E51+7+ZQHV0SlYlJOEVJbrDi92E3VsLcKTe043bGD43xfpqPTZM4ioAxFfEUH80B4junN66MpcrHyMZnOCWYef/lUXWB0HE6gWowOR2R6DYtwgr+KHxPT7wi1PdQiQ6N2aHJJp+fwEBLsFJlAmmMAZ+mpZZGe91jzoZcGm2xDjfqUGX+ifgQqPNywdLQyU87WvvJlUaI7sNpTayfpFyJ5HqKufv4AsaiBCKnU5O5JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6N0JskZtNUJMa6TuW0hyyf3+VOA2N6fT5GUN4+kOBE=;
 b=K+oqbqQlYP+VjgcLN+U1FfxhT2v2hihij3jwvpvofYOrRzpN2jFRKqRNLdgBBDtZljdckHLA+6AAI+J5gIW/UBDWOCK49TlDmugZmioFnE63CHSJm32wSg06lVstkqDGtgqiH5Woh1GtOCeduMypEXQS1n12G0Nqxn27wboXMoImYvl+n/dUlAPLvnjJETfQ65cVnE/X1HFnRO1CqhuUxF6VJWVGFO7F9T0HKsI8k/dChEyvo0a/DfdkJb5QEPZ5gX/J60i1yntLCt8RGuPboy+yEcZo3cUF8ChUBgYyg/eW2Ow2/5BQGOS5LHwIN8i6xnLvKjdO6cpDTUcwkexRQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6N0JskZtNUJMa6TuW0hyyf3+VOA2N6fT5GUN4+kOBE=;
 b=I74xxNIEEOly4inkGdVEGTza0X7bsXc5Ejd1e0Za83434pS8npifkvGb9UVSqFj6mTYxbpe4EdxIDKEH0z+ooCNfg+1jOIcrxpjss2A5wdd7aYD/wQtN7J17AYHbe69QqgDaaJOd2agvvgcwUNlJIPAPbu1sa81pvV+2toLvhR8=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:23 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:23 +0000
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
Subject: [PATCH v4 01/17] kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to
 use struct kvm parameter
Thread-Topic: [PATCH v4 01/17] kvm: x86: Modify kvm_x86_ops.get_enable_apicv()
 to use struct kvm parameter
Thread-Index: AQHVkQV8uR2S90+F3EeDF1s2iEmZGA==
Date:   Fri, 1 Nov 2019 22:41:23 +0000
Message-ID: <1572648072-84536-2-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 44c4422f-ae47-49aa-62a9-08d75f1c9f4e
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243DC4193D8808F55071D17F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zAip+o0CvfvK/NJiEU2qWbCh2QXoJHyC3ukEZdiNGBz+3DWxSrC7Bz6aOAcJFiXEtbJk3U+llt0HNvB97V6srKaoTrzSMSD8TnPJMh8jYznKWUyiDMVQ8YKb7AmGfodqh6gkok8gKWbLtoPrIwbBRDa6M84HAowJ2jKGQbSzTBH++QvAprsISacs6X3DL3V4+Po31s1M+PgBBeRHkIv6TJr9QVDO22iWlrScvfdSxRILw6CxObk424mWT+WD+b2lxpC3xBNVUFAGi/wUGngM/fyhhI8P7zn2bpIqTUAZk2pFEEPfDl+V+TJpU0nHAio15cUEsfEYZyijZCQHNN5JDqIi9ZwfanOSb8ox0KF1UMHgpLGVFL2cMt65EtNzjTuw44FlpWpGPPeVlzbTB62i0l5yhBAz0gM5y3xSC4pSp54cAZ/99Nn9DlLACMDWovTz
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c4422f-ae47-49aa-62a9-08d75f1c9f4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:23.4251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6VH6GvSJXHxtOGfYZkZbktVyl5x31W4Dg5ILqXht9AG6BsMWlz/VvBea52oUh/u6dZLTjOlXBVBi9UA98isG4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generally, APICv for all vcpus in the VM are enable/disable in the same
manner. So, get_enable_apicv() should represent APICv status of the VM
instead of each VCPU.

Modify kvm_x86_ops.get_enable_apicv() to take struct kvm as parameter
instead of struct kvm_vcpu.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm.c              | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index bdc16b0..843799b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1088,7 +1088,7 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*get_enable_apicv)(struct kvm_vcpu *vcpu);
+	bool (*get_enable_apicv)(struct kvm *kvm);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e036807..7090306 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5143,9 +5143,9 @@ static void svm_set_virtual_apic_mode(struct kvm_vcpu=
 *vcpu)
 	return;
 }
=20
-static bool svm_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool svm_get_enable_apicv(struct kvm *kvm)
 {
-	return avic && irqchip_split(vcpu->kvm);
+	return avic && irqchip_split(kvm);
 }
=20
 static void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c030c96..e4faa00 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3644,7 +3644,7 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx=
)
 	}
 }
=20
-static bool vmx_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool vmx_get_enable_apicv(struct kvm *kvm)
 {
 	return enable_apicv;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91602d3..2341f48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9217,7 +9217,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_pio_data;
=20
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu);
+		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu->kvm);
 		r =3D kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
--=20
1.8.3.1

