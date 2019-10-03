Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B998CB0EB
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732482AbfJCVRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:17:50 -0400
Received: from mail-eopbgr730068.outbound.protection.outlook.com ([40.107.73.68]:39664
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732268AbfJCVRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:17:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQg9lwBe/xKYIiGEhIiCXVeioC3cpy0x3IBysavQL52/WwVIgFsAU30d9u4vV5d8emGC2ywAmHp/Ty8RKz+qb8V//8n3eTuQMbqOKxBZHjL6SYbAFe0JGr359XpgnPq3CvoVFOTceRavTWmBCBHtnRAX6CDddmWOghnz6Zi9mj729AJ94VW2BmVXpSNg3TMUquYUES2LDmtoXtTedV/qS5YzW+AAXHjU3rRwCtGPOAeK71yv7CJq/F7Mh3uA/6hKZtcKPFns1iVpguLuFe4aI7/GZMgAUaGA6+ieFu+VCui08rIrpXLbdp9G+KLYWrvL/OllQE/0sIwBwp250hnYPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9I/0UGRVSRvqVS5xtsrQPtBrvSh7D5tXVguO/J5IjA=;
 b=ILfjExiwjO/l4XJD/xCr2gM3HGe3fuMrBrvF5d4A+sJBfwEKPHdTUQBpy06EHDKyj5mWIxMffflUZixPYUN2RuX5lUITk8/kqPc1N953RErdcm+6TEE3QBcKbyrkEOBFDfTxhbfsH2m0FaM4lF9ilMNBeZZ2R1PVJ/yYYebicjS34i0GfWKJNyxPLoMY2S3Vst13HUiG0jIFvF1vTsKSam6yL5GgQGaxIskEWG0Gi6Z9uUNyTflG30i8ovi/fbfQ4y7jTaxvtdsK3VmUDRVfBFHAIWYdtppr+mFUWcJjv/TID0jzgu3m0CRQ+1IpDaadMicFDN/pdPOxJMWfaqSKAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9I/0UGRVSRvqVS5xtsrQPtBrvSh7D5tXVguO/J5IjA=;
 b=QU5KFunvo9Qlxhv1ryA6sgvX74JqDlyf875pRw5+rbTX18Ox2iIb2b//juCu2MKAQ1vzER9GMiQjRdjQK8KHX+8aQqgfEvp6JNaPNAOtbEqYYVd+019lYOZeYJE8CZeio0WnyhOrKGyj40uF23LnsRRc69OYYd5VgeAIcjvLzuI=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3211.namprd12.prod.outlook.com (20.179.105.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 21:17:46 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 21:17:46 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/5] KVM: SVM: Remove unneeded WBINVD and DF_FLUSH when
 starting SEV guests
Thread-Topic: [PATCH 3/5] KVM: SVM: Remove unneeded WBINVD and DF_FLUSH when
 starting SEV guests
Thread-Index: AQHVejAArS5Tdu6ehkeZcenTy/XMgg==
Date:   Thu, 3 Oct 2019 21:17:46 +0000
Message-ID: <6108561e392460ade67f7f70d9bfa9f56a925d0a.1570137447.git.thomas.lendacky@amd.com>
References: <cover.1570137447.git.thomas.lendacky@amd.com>
In-Reply-To: <cover.1570137447.git.thomas.lendacky@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN6PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:805:de::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec4c001e-0bbc-46e7-676f-08d7484722d6
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3211:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32118619FA16E946B3B6F93DEC9F0@DM6PR12MB3211.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(199004)(189003)(256004)(26005)(14444005)(386003)(6506007)(316002)(36756003)(66446008)(71200400001)(71190400001)(5660300002)(66476007)(66556008)(64756008)(66946007)(118296001)(66066001)(8936002)(2501003)(50226002)(7416002)(6512007)(102836004)(81156014)(8676002)(2906002)(14454004)(81166006)(7736002)(4326008)(6436002)(305945005)(478600001)(25786009)(86362001)(476003)(446003)(2616005)(11346002)(186003)(6486002)(54906003)(99286004)(110136005)(486006)(76176011)(52116002)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3211;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sKkXl+lQqeGY10P0d8mVNPMqcg5xkZeChtFJpyHeeFnuZvCyZaMwxjavVZ/MraeeqVql5UxvcPjf5WrufzZD1ZpzUBsBciXGhvbNMGrChwej55uAdcq2MLkNI1EIwaVcTn4p6S2Ln4XiMLHa7y4p7WzcwYQjn2IiEnRj9WobQKChtKd+K1iz5cJM9Lge7mP32kuD4vSChvZHcMwIkftR8gavKHw2ughYVKw4xinSqHPU3Djo+zsZZOUIo9exSQ2JBOyxJ2R7ymJ+UuGyGJ+46YaaQxMFbZAh1zVCAGjTITKy6viNb8/dx86n7vWn7ciYbaxMmR4/+Uk66HftZe2jUIRk8bSiJ1J7I5SyOWPeOXn952rj13ba1tpcorEJhqziZAoJ97Wb7dQ2zT3IIyhGuV3uBHKd1UYS/OCe/+Rpgrs=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <E0FA8D53FBDFB549AA9564AE66FEBA65@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4c001e-0bbc-46e7-676f-08d7484722d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 21:17:46.2607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EwHs1jsil+VRuPes6vaJcX7ev2QWKYm2X6yrzvy6t5AZV9LzSI/209PcR9Hz3rMNV++P97yAMiJMv//TBlMo4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3211
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Performing a WBINVD and DF_FLUSH are expensive operations. The SEV support
currently performs this WBINVD/DF_FLUSH combination when an SEV guest is
terminated, so there is no need for it to be done before LAUNCH.

However, when the SEV firmware transitions the platform from UNINIT state
to INIT state, all ASIDs will be marked invalid across all threads.
Therefore, as part of transitioning the platform to INIT state, perform a
WBINVD/DF_FLUSH after a successful INIT in the PSP/SEV device driver.
Since the PSP/SEV device driver is x86 only, it can reference and use the
WBINVD related functions directly.

Cc: Gary Hook <gary.hook@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c           | 15 ---------------
 drivers/crypto/ccp/psp-dev.c |  9 +++++++++
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1d217680cf83..389dfd7594eb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6329,21 +6329,6 @@ static int sev_bind_asid(struct kvm *kvm, unsigned i=
nt handle, int *error)
 	int asid =3D sev_get_asid(kvm);
 	int ret;
=20
-	/*
-	 * Guard against a DEACTIVATE command before the DF_FLUSH command
-	 * has completed.
-	 */
-	mutex_lock(&sev_deactivate_lock);
-
-	wbinvd_on_all_cpus();
-
-	ret =3D sev_guest_df_flush(error);
-
-	mutex_unlock(&sev_deactivate_lock);
-
-	if (ret)
-		return ret;
-
 	data =3D kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
 	if (!data)
 		return -ENOMEM;
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 6b17d179ef8a..39fdd0641637 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -21,6 +21,8 @@
 #include <linux/ccp.h>
 #include <linux/firmware.h>
=20
+#include <asm/smp.h>
+
 #include "sp-dev.h"
 #include "psp-dev.h"
=20
@@ -235,6 +237,13 @@ static int __sev_platform_init_locked(int *error)
 		return rc;
=20
 	psp->sev_state =3D SEV_STATE_INIT;
+
+	/* Prepare for first SEV guest launch after INIT */
+	wbinvd_on_all_cpus();
+	rc =3D __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
+	if (rc)
+		return rc;
+
 	dev_dbg(psp->dev, "SEV firmware initialized\n");
=20
 	return rc;
--=20
2.17.1

