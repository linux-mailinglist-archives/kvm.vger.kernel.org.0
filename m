Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA94B259D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389610AbfIMTBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:43 -0400
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:54616
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389455AbfIMTBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FI4aGtHGDdM+1vGUgSYMJqrroOct6sR/9+tePRUX+KDVmiM8Laxpl2mdrv4WzhOGkQE0dvjbGqtpMM0Kqjjdh7BNPDZ/z7udpGEVz1xu9YIMI+wXI1gh4xIEgIQ8XQaYIa+qE26TyEt99EOYeIAm9JlLBzFdy0UX0X8fcdL0BmpQsDCMqOFRf5119CrLbtk74GwjSc7ZRFSd4Nr1UlFBkkYDu6dNWUamZX2zHe7pFMCwur66lnzP8Un3tYUvlyFh6A9l5rfkt+JHwZdxEcLlLpAFba/Luq24haihROUspuwCM7YWchHDZBiUILhbY6Sr4aRQF7PGpsxkRIcooZPD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7IAhgJtkJRrLvCzuL10dk3wiC5fMAXIaBTMs47Gc5A=;
 b=HRD62DHqKR3Pq5L0HzHNbvPfg+oxIyG0VHu3WnYyOBzniuY7nFPn6KYOC0OKkxB/B9C26/9m9mFJYfGXpNc2QlECIn0vNNJRoTaFWFnYfsnFHkRcqk+1zwOyS9PPR+Ydst/VQ9zFW/orllEdle7JDBTD1vyGUptuBQgvbye9XRvsrtNZQapDxxSLq82ZzzYGQ8HetrmRU5YqCDOcXw+sYkEyde74HZBCD3tY4rPwM5uw+4uem0HMggpBotkcNon/+jxSjVNabwvZjLfbMzX/eOz2hdpt/xfHI2OW3fAYpTFWE+mi6K1t0ToIgGV1hzcRLhzG70/SNaZkAoyek+KoVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7IAhgJtkJRrLvCzuL10dk3wiC5fMAXIaBTMs47Gc5A=;
 b=nqFuPujMLvvnx/lqWWI4eReLJA7eIzQXANE99omwjDybiwET+FwULeieQEbyxAHfuhss72/ag4Tixsli4lTKfly2lGEK8I47BPB8GJp8g6sZMmxTOTdscF2RFIgA55FHak506Jn9yKL5LyYJtbOxQSvzRq9WiGS4+fFMfT/FHr4=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:01:02 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:02 +0000
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
Subject: [PATCH v3 10/16] svm: Disable AVIC when launching guest with SVM
 support
Thread-Topic: [PATCH v3 10/16] svm: Disable AVIC when launching guest with SVM
 support
Thread-Index: AQHVamWWoPH9o5PhQE6xSKQxumGTSw==
Date:   Fri, 13 Sep 2019 19:01:02 +0000
Message-ID: <1568401242-260374-11-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 3cb3a673-37b6-40f3-89b8-08d7387cb868
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38046253654FD2C17051F4D1F3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z+9ZctDeIg1Pxm+IJfy82UxGFsvqmxVserxFb03mlJbTntoK91jqkfu9gkyDzWuiITVIPnsF0RljQIRTCPQJCLvuLHxozTsEy7xAO3chkOMvwlhZP9F9dt7tyPK9n30k4tSFCOOL9L9rubDKy8RojwaYgFqOzXCJ3x0kX9O6CNgKofMeNAyKlFQgSYEICwfRLQ86PZfPRu6Fl/+odNYCD5tqX3OpuPffg2fcA0wF2fXVIme/DyOpSTzYTQRWLp1ZypdG3v7Apg23Ee6Ez+Soz6oM+nmvKx4pHt/GI7S0oX+IxleOmbP+GF+Re/yovlEo4YV7AFwqJdQ947qAJM7Uzt4LteIgWLkyITY4mw6GLR2wWKr1lOm+lLHO2pQdM3vua0kOlWWoLAqB3KTCW8Oncqj9HSQ1QT5Z3Qr7JgReTDU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb3a673-37b6-40f3-89b8-08d7387cb868
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:02.1450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4rzfDQxp9pq6H04KR00IkTFXIjtG48n0O8R2ANn3w1xIiSp4w53LDw8//yvJovZEWoi8f3XMKWFGSOQpMmJBmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since AVIC does not currently work w/ nested virtualization, disable AVIC
for the guest if setting CPUID Fn80000001_ECX[SVM] (i.e. indicate support
for SVM, which is needed for nested virtualization).

Suggested-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a01bc6a..e02ee1a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6029,6 +6029,16 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 		return;
=20
 	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
+
+	/*
+	 * Currently, AVIC does not work with nested virtualization.
+	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
+	 */
+	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM)) {
+		vcpu->srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_make_apicv_deactivate_request(vcpu, true);
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	}
 }
=20
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *ent=
ry)
--=20
1.8.3.1

