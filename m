Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F4AB25A0
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbfIMTBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:40 -0400
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:54616
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389363AbfIMTBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCF4HIg3ZkEeOW77IlWGYZjvqMXRJ5kdGZK/7PW5PeOaZxTdd4HTAyXP6nnqd9dgLx8OCghdZXJXWxfxvXJVueSeCKYBXue8zcBFpMYkR79vSDxMAdQTP0cLo1uu6o4zg+Krm/MK4D6bvkMrKub+GocBhLIuqCgbo17WvIgGJk5Sn+tW8Vyc7KlSb+gCaAW1xrx6q0Pc1UbIYjFm6CYFJ1j6AxuBqRYWA+JYPpwSr0m8ARYrDeJlC3Z0OrW60VhUJwiaqBpj0L/V9o5yUGnVILdL/8sCQkikfEClmAqOfwgK8TWssSThCiLnRoK0N2U7dO+1lw0jVnMl+PRdp+EZvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb3KMPr6qWz+I9Ez/Ru2kbDDhxsu52HQ1ZRSbN8ca3k=;
 b=gWorEh4PagJfPbGE9ozya9gkkngB5h0J4DA9ENX9GiapyDVj6kEexQEZAm7jCEq5njkPugMLuWsBk7knoGpbh/RLKj70PSz83s+Zr2+jNsDRSARul/7jlJQAhl6OYk3V+VMXfibiltCFnCArDsDxOn4pjdVrWAW4uFXTAtrMGxvKm1019DgF+MY0zeZVbGrOIjZoQBKecvE/20dw+I8ZnYVel94t2fhaGgs16eT75NXV4IH+ujIaej3DI8PChoM06CYM9g93rgZqQ4jyIOeKFmC1ZQSgzYJQXLGLXZETdWgSgJjvhgJe0i/JOZxBYD9HUYUxG09sQwBKTy7hsLuVPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb3KMPr6qWz+I9Ez/Ru2kbDDhxsu52HQ1ZRSbN8ca3k=;
 b=cRQThq1HJB5DM4320Z65C02gk+1XDks6BNau1lnkvDKxIpa6eEa8lErSvDVcUZgsMIQ2cip4DSZRHxgbD2hw4zcagEZal/4PRyK28Q2FAxdlfcyY06VTKyaof8i9FucZRqT2TimoBS6ixR4OI3M+SmcCKdsnwOP8DNAaomECpZY=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:01:00 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:00 +0000
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
Subject: [PATCH v3 09/16] kvm: x86: hyperv: Use APICv deactivate request
 interface
Thread-Topic: [PATCH v3 09/16] kvm: x86: hyperv: Use APICv deactivate request
 interface
Thread-Index: AQHVamWV0w32d528XUiZH8DFeQLFEw==
Date:   Fri, 13 Sep 2019 19:01:00 +0000
Message-ID: <1568401242-260374-10-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 0a1352b0-97ba-4633-fd19-08d7387cb786
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38041756DD299C9CAE62CD87F3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qiLzBCM0kkL5qNj3DovJOA1Vtb7yNNT6L9TxLncKorhkNysFOBmSTht5TCrcHDSR1Mj0ae4hX3wBBVtKOp7OJdyIr0msC3kZX1D9/zr4y+35ehcGP4ItghsV820hHJlnOvLFx2HdDkKxQ03yBHbu6lb58lSHA2RV6La+Ae/voqIkIUOEtE51B1rgh+YrtOkBVrdPHAqYMOOxoYV8giN1fAVdWFEkF1U/5PpRsOelM0Pgxju/XILZc38pz98v1pmtjI284zbcutenOyurfXWf3WGE1TTGHIk8+NMCWLxBW4OTfZZqQ75jjylCcfvLXofrpBIQ1aWtcw//kJldgwHH6ZPLXNazf7n6R8oEqFWmi2m80mrgKWspYZE5DHB4gaALmSdgCbMfr4jdHCfxmq4YNHNM4waOxDLisvaBSezyhug=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1352b0-97ba-4633-fd19-08d7387cb786
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:00.5210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ayKe11hJ+/SsD6ytpbsPbipBbR9iijWcwNuzO5TjGzIj7ut2uxy50GS7KrAF6LximRrPOsm+aYvUs8wptJr2KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since disabling APICv has to be done for all vcpus on AMD-based system,
adopt the newly introduced kvm_make_apicv_deactivate_request() interface.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/hyperv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c10a8b1..1d011b4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -772,9 +772,17 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool =
dont_zero_synic_pages)
=20
 	/*
 	 * Hyper-V SynIC auto EOI SINT's are
-	 * not compatible with APICV, so deactivate APICV
+	 * not compatible with APICV, so request
+	 * to deactivate APICV permanently.
+	 *
+	 * Since this requires updating
+	 * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
+	 * also take srcu lock.
 	 */
-	kvm_vcpu_deactivate_apicv(vcpu);
+	vcpu->srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_make_apicv_deactivate_request(vcpu, true);
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+
 	synic->active =3D true;
 	synic->dont_zero_synic_pages =3D dont_zero_synic_pages;
 	return 0;
--=20
1.8.3.1

