Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B57DB9C7
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438308AbfJQWfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 18:35:14 -0400
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:11598
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732705AbfJQWfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 18:35:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nf261NBMIa7E9oKVYM2TsR/796qIn1LrC/UuGs0nnPcllxjx3w9W6RaUg/EhNLzQ75Hu1avRMJ3ZyN8Jl38WhPyJA5WiZeF5O/6mCP+qDTaF+yr5awLef2OwGnPNNJrL87n3nFxQBHGbh11VHK033p+znbXy3dAoWWCAS1EPbv9Y112hekOXJZgk062uFJnzirxo9P0gphKwhxfk4q7J51H7Gpp3JCBdLiqt5Qk3WECIeHc2QF1hvtwoO8Mu649CA1uv/Rwzdp8rQKbvk5mvphsn1Q2h9xQsH/z2m2hVrPM5IpEDHg4hfoH5FyrrSS+IaFqzazkSp3AY0hwaYnXFZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lceMN9I1E4Upy+a0YsUY7jbAUM/eE5edwQW28O+Oh/8=;
 b=GxiM/cy9ao5ZQJr6WDY52aygm3VhaEOJQWBF9r8DwkGfjEUf7NF3O93336GzrhA0IGep/W4BA53nfHeM2mcGeJyep0LX3kWF/rPi3dLOAIyUay94ID077GO61dx5YTC0Qe82aKDbIOSeo0+rdlEjDaIcTMNB9C84FxUtg51wS9XZ/LpVkuq6G+0kBUk1w4NoEl93Sj457W3P4lXP6qDS9d6he+ugpvnxOmYqQw35Qj1XB8jjD6ooNMTaPDXa0FXqiRJFVpG7drh+hFoHCl5Qzc/1bia/xA2FX64QbhJ+GFNewYGJ8k1IRkOug6VH+/of4Op1ZM2JnlJSr6iKDwhu1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lceMN9I1E4Upy+a0YsUY7jbAUM/eE5edwQW28O+Oh/8=;
 b=C3mvvFnGuL+LII95Szv4TMdlLy/4R3my8JCJNcAI0TbEcyCGYiot2SRE0N/90mVGndnY3BNY7EtqWGDO18XG4VDUfftS/oJW4copWNC/rhtVblcXAb61o0l3pfwyTi7pStzFBga6G+W1Xs60FtUWCZDBBZ3SNJbGDwksTa7GZfg=
Received: from DM6PR12MB3610.namprd12.prod.outlook.com (20.178.199.84) by
 DM6PR12MB3979.namprd12.prod.outlook.com (10.255.175.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Thu, 17 Oct 2019 22:35:11 +0000
Received: from DM6PR12MB3610.namprd12.prod.outlook.com
 ([fe80::718a:a9ab:540c:7df4]) by DM6PR12MB3610.namprd12.prod.outlook.com
 ([fe80::718a:a9ab:540c:7df4%2]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 22:35:11 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "info@metux.net" <info@metux.net>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH] crypto: ccp - Retry SEV INIT command in case of integrity
 check failure.
Thread-Topic: [PATCH] crypto: ccp - Retry SEV INIT command in case of
 integrity check failure.
Thread-Index: AQHVhTsiVAXVZvJHqE+F84WTgpVS9A==
Date:   Thu, 17 Oct 2019 22:35:11 +0000
Message-ID: <20191017223459.64281-1-Ashish.Kalra@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0601CA0017.namprd06.prod.outlook.com
 (2603:10b6:803:2f::27) To DM6PR12MB3610.namprd12.prod.outlook.com
 (2603:10b6:5:3d::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d35d8056-9403-4806-670b-08d753524526
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3979:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3979AB7CAEFE4E6FAFC3FE978E6D0@DM6PR12MB3979.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(189003)(199004)(102836004)(64756008)(1076003)(1250700005)(2201001)(478600001)(26005)(2906002)(6116002)(6506007)(5660300002)(6436002)(386003)(52116002)(305945005)(6486002)(186003)(66476007)(7736002)(66446008)(36756003)(3846002)(25786009)(14454004)(66066001)(71190400001)(71200400001)(2616005)(486006)(81166006)(66556008)(2501003)(66946007)(8936002)(99286004)(110136005)(6512007)(86362001)(81156014)(50226002)(8676002)(316002)(14444005)(7416002)(256004)(476003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3979;H:DM6PR12MB3610.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZiRIJ38AU4dTC04A0RdD8tB01/sEJQQGmByVXEBkOxYPU0JBSHgkpd4rEshN3YHCz4ARFlSOyQ4tgdkHSVdBARghrwZe6dQ6PpQa0VEu2pzb5F6Sn7LbA7oH6vchtX8tVa4R3hWy/+BdXpW2UPB5sAr/HacMlE5WpXGgNFpXpiKKR66dEJSBe/q6O3BFZ4sUuH1lQIkOrxeawcKQI+nh3s+OmS6BCaoF/YedvCuhpOg1o4mP8TGOXbtN8ciHd7f9b5V0j7ooStBJD4cAuuYbBID05Kdb3sxsxX+KeJPKO5MCfg2bQi60PVOBmtnBYsNL40R9euqAyq1MyXCe8o5jFuFhhgT6hF8xadjk3jlhrEbU0Ry/dUG5a10ZIw+6Awh08dVY6OU5lpJ22hgU2ZAnvsVFEXEN7L8El25fUD4OBHA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35d8056-9403-4806-670b-08d753524526
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 22:35:11.1771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 434S2xwEyfwlTTR/6jymePq2fPNjijLM0XAv4zpu5/YQBGulqeur3e2yzMUAbdzyFBET3nfqs+R39gEKmPewsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3979
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

SEV INIT command loads the SEV related persistent data from NVS
and initializes the platform context. The firmware validates the
persistent state. If validation fails, the firmware will reset
the persisent state and return an integrity check failure status.

At this point, a subsequent INIT command should succeed, so retry
the command. The INIT command retry is only done during driver
initialization.

Additional enums along with SEV_RET_SECURE_DATA_INVALID are added
to sev_ret_code to maintain continuity and relevance of enum values.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 12 ++++++++++++
 include/uapi/linux/psp-sev.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 6b17d179ef8a..f9318d4482f2 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -1064,6 +1064,18 @@ void psp_pci_init(void)
=20
 	/* Initialize the platform */
 	rc =3D sev_platform_init(&error);
+	if (rc && (error =3D=3D SEV_RET_SECURE_DATA_INVALID)) {
+		/*
+		 * INIT command returned an integrity check failure
+		 * status code, meaning that firmware load and
+		 * validation of SEV related persistent data has
+		 * failed and persistent state has been erased.
+		 * Retrying INIT command here should succeed.
+		 */
+		dev_dbg(sp->dev, "SEV: retrying INIT command");
+		rc =3D sev_platform_init(&error);
+	}
+
 	if (rc) {
 		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
 		return;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 8654b2442f6a..a8537f4e5e08 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -58,6 +58,9 @@ typedef enum {
 	SEV_RET_HWSEV_RET_PLATFORM,
 	SEV_RET_HWSEV_RET_UNSAFE,
 	SEV_RET_UNSUPPORTED,
+	SEV_RET_INVALID_PARAM,
+	SEV_RET_RESOURCE_LIMIT,
+	SEV_RET_SECURE_DATA_INVALID,
 	SEV_RET_MAX,
 } sev_ret_code;
=20
--=20
2.17.1

