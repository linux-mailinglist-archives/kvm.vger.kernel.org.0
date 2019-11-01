Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B397ECB7F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfKAWlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:39 -0400
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:60224
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727880AbfKAWli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZDxtHAqER7vivzdtP3OrF8BtFotcRti8/XVlS5F9nzZiQeOhsB72e+oKi361LdqMN3HfAPhpjs6dhkhhpywFzTGLRRxROloTWt+tpuMN8tQ8ZiIPyO4djdxWQOGLlPpr1viyOYPXMNwC3W3sgLeN7DGBXmQ58rh/OG3JZ8fKI0teMHgurvfRMM7kvLH9TBnak+eUsUvBqegbXPnuuejvkPyD0uKSGGbaI9U9dkhnaWOYF5A07ZiuzzcYZy16iD+Orac9uShylCzm3grZ9LLphnIkvI8tYLDOb24anhMIi2nPv8JUReV/1GuSNJLq2ITtrjtnGWwpnov1XXBggcO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrDf7tn9uPt/T0eXtzsB6nB9ZGVGL7O4e+bGOp7bsk8=;
 b=Oo6hi2r6jRQCEjIW3WKcXTMUQsO86l1BevYh2G5OpF7W39NqLT3n8RjCKQ0amahaYhaYpg9837X8Wdk3Fz04rAHC1/0NpFEaW2s7zFJvt3VbDqNyAgp9qZW4hyANNfWNICWLoTvMTbWIRrXcGXzai1K3sbuVok7DduFzSlZGKwMsaBjdFLDqZAVwCnHS2IvNa8K4ewdnSkQCz9Nlu+3OBvHARKwFx54oCIlY+09AyliNaqynl5zTYdSB0EGaEpSUO/GC7FS0GyRJMAlfp0numICX7QI14Z3PeVMFpBH6ZwX237fBjsMAtA5YLRfEAw5WjbSvzJRz83AEr57a+WBP3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrDf7tn9uPt/T0eXtzsB6nB9ZGVGL7O4e+bGOp7bsk8=;
 b=4GrhOw3RXTRxl5Ed8MoGTuio74Lbuz1yBil6yeTt+Y26o+UKflzb6Op4hPHkyCS+/geZlj7L7W2EME0tqXYKj+cPB7M/+8tO1+0I69GT0Q+21sS9MW5BcSFoWujeHnRVIsOWBLeYdtEFHoDSUHMblrc+a5nkyV2SIP+/WtwYU9Q=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:30 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:30 +0000
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
Subject: [PATCH v4 07/17] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Topic: [PATCH v4 07/17] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Index: AQHVkQWBl/IUX6i/Q0Kz+Q9Ftrs4dA==
Date:   Fri, 1 Nov 2019 22:41:30 +0000
Message-ID: <1572648072-84536-8-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: cc02925e-da20-44d2-342f-08d75f1ca38a
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB324362AAD3D4AADB40EB9818F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b4qTz2VIsyfNHwNAdTKklVvUhHNRt06/lZMWmoxrwd/aU/lRHKId1QneMz6yd5XVqIYqz84je4BiBd7yGj8EpbYciml+8S2mByy9oqlijFSIlKJH6SY/xjP3WMgpqInlpTtC8DIirEg/FdIsjD9OzE9fQOUUFTvFnYU5ZglquWmnXjMXcWe3pQ55kdk+ZLnaI/pnTettOm1du6X3Wk9wTpbxC0Iu5EuLq+gUZ9krqCWBb4liUn0ezGqszezNoOSOmoWUsnfRhA7mtWRwZEguC9AWCnAD26HiOisgsiyBam47WdQe3pw7MPBprYvwroGGvv2Y6IK67SvEPwDipWXl/Mrp5xHlg28E41QKNxf0a28CqInjG6hexLZ8BFr1U2YsaGHg5cenaRyslWJZ6AAhTPi6fp9y4MTNeAPtgzwpndtr7kEmu1maFK8QTxVB6IKM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc02925e-da20-44d2-342f-08d75f1ca38a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:30.5939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Dx9sxsEm01BweWnImg9PlUzDy4v0ceHvPURvzUwxqH1YzbWos/tzI8ubwABRjFerXfGbSSb6QbTP55WbOg8wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-factor avic_init_access_page() to avic_update_access_page() since
activate/deactivate AVIC requires setting/unsetting the memory region used
for virtual APIC backing page (APIC_ACCESS_PAGE_PRIVATE_MEMSLOT).

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b7d0adc..46842a2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1668,23 +1668,22 @@ static u64 *avic_get_physical_id_entry(struct kvm_v=
cpu *vcpu,
  * field of the VMCB. Therefore, we set up the
  * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
  */
-static int avic_init_access_page(struct kvm_vcpu *vcpu)
+static int avic_update_access_page(struct kvm *kvm, bool activate)
 {
-	struct kvm *kvm =3D vcpu->kvm;
 	int ret =3D 0;
=20
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_page_done)
+	if (kvm->arch.apic_access_page_done =3D=3D activate)
 		goto out;
=20
 	ret =3D __x86_set_memory_region(kvm,
 				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE,
-				      PAGE_SIZE);
+				      activate ? PAGE_SIZE : 0);
 	if (ret)
 		goto out;
=20
-	kvm->arch.apic_access_page_done =3D true;
+	kvm->arch.apic_access_page_done =3D activate;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
@@ -1697,7 +1696,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vc=
pu)
 	int id =3D vcpu->vcpu_id;
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-	ret =3D avic_init_access_page(vcpu);
+	ret =3D avic_update_access_page(vcpu->kvm, true);
 	if (ret)
 		return ret;
=20
--=20
1.8.3.1

