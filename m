Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50D04D8E5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfFTS2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:28:54 -0400
Received: from mail-eopbgr720085.outbound.protection.outlook.com ([40.107.72.85]:31712
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbfFTSDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFBgIPZhYsTZooAEUYeONx19dFTSbtzFpx1y0wedwm8=;
 b=rHPU1HsU9RRIKSsRHWIHB0O3aE+G0Ud098qHCrkhUxCEu95FdbQ8XcKLIAFXzfA+0ibrlAthlSagUnJI5IeE4j/aSyyPHPncE7OJwnHu5rhqDg1MbJv4mTQ1vVy3wsDfXEZh3NU9EGZcc92/XUhq/PXB4miIEQZY51wEiXOcJDs=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3260.namprd12.prod.outlook.com (20.179.105.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Thu, 20 Jun 2019 18:03:18 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 18:03:18 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 05/12] doc: update AMD SEV API spec web link
Thread-Topic: [RFC PATCH v1 05/12] doc: update AMD SEV API spec web link
Thread-Index: AQHVJ5JvU0OsENCWAEGUOXPkpBOerw==
Date:   Thu, 20 Jun 2019 18:03:17 +0000
Message-ID: <20190620180247.8825-6-brijesh.singh@amd.com>
References: <20190620180247.8825-1-brijesh.singh@amd.com>
In-Reply-To: <20190620180247.8825-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:4:15::11) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a19b7eab-84f8-4d4e-4f4b-08d6f5a9919b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3260;
x-ms-traffictypediagnostic: DM6PR12MB3260:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <DM6PR12MB32604795D3645ADFC8F9B0A1E5E40@DM6PR12MB3260.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(2351001)(53936002)(486006)(2616005)(11346002)(81156014)(8676002)(14444005)(6436002)(446003)(5640700003)(50226002)(6512007)(476003)(102836004)(966005)(6916009)(99286004)(2501003)(6486002)(76176011)(8936002)(52116002)(81166006)(6306002)(316002)(186003)(6506007)(26005)(478600001)(256004)(3846002)(2906002)(386003)(66066001)(14454004)(54906003)(6116002)(305945005)(25786009)(1076003)(66946007)(66556008)(73956011)(64756008)(66446008)(71190400001)(71200400001)(4744005)(68736007)(36756003)(66476007)(5660300002)(7736002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3260;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eH+34AVPU6ViCM+Jb74xH/H6aADamJeZuszNYOcqzdrthECVsGSdfI3RWUMoQH7zOjkz/zxJgw6xEfzfFlkuE5/F1h4N6QceOgmOFkZhiCAXtPekdY7H5trMgM+46VlY1biQ92DBfbgiCogLaXgp6YtZbfXhwl6SUDlgg4OKnwtCGf8TAMdF0eZPaCyvwfB5z6A4T/+EvCKPolOLmr2C6SSzhu/DGrDSYcXBgG+lV6+yFMvhz96sb274xT43S3HtBjTSDFWOA8JkhviUBl3cxbRWis8NhvRJ7veBJZAxCA5F3TU2r0Xhndxjq5E3xKFClNN7UJapSsGuqDPStxiy63fvGzHcbwO+879V0LRV9SyNlCfeC/VsmsTut+YX/pfB4zJjHpdSUICMpu8Mvo4xcrLDnQhnq+m3CCSfJB9GXYY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19b7eab-84f8-4d4e-4f4b-08d6f5a9919b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 18:03:17.5358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3260
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U2lnbmVkLW9mZi1ieTogQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0KLS0t
DQogZG9jcy9hbWQtbWVtb3J5LWVuY3J5cHRpb24udHh0IHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZG9jcy9hbWQt
bWVtb3J5LWVuY3J5cHRpb24udHh0IGIvZG9jcy9hbWQtbWVtb3J5LWVuY3J5cHRpb24udHh0DQpp
bmRleCA0M2JmM2VlNmE1Li5hYmI5YTk3NmY1IDEwMDY0NA0KLS0tIGEvZG9jcy9hbWQtbWVtb3J5
LWVuY3J5cHRpb24udHh0DQorKysgYi9kb2NzL2FtZC1tZW1vcnktZW5jcnlwdGlvbi50eHQNCkBA
IC05OCw3ICs5OCw3IEBAIEFNRCBNZW1vcnkgRW5jcnlwdGlvbiB3aGl0ZXBhcGVyOg0KIGh0dHA6
Ly9hbWQtZGV2LndwZW5naW5lLm5ldGRuYS1jZG4uY29tL3dvcmRwcmVzcy9tZWRpYS8yMDEzLzEy
L0FNRF9NZW1vcnlfRW5jcnlwdGlvbl9XaGl0ZXBhcGVyX3Y3LVB1YmxpYy5wZGYNCiANCiBTZWN1
cmUgRW5jcnlwdGVkIFZpcnR1YWxpemF0aW9uIEtleSBNYW5hZ2VtZW50Og0KLVsxXSBodHRwOi8v
c3VwcG9ydC5hbWQuY29tL1RlY2hEb2NzLzU1NzY2X1NFVi1LTSBBUElfU3BlY2lmaWNhdGlvbi5w
ZGYNCitbMV0gaHR0cHM6Ly9kZXZlbG9wZXIuYW1kLmNvbS9zZXYvIChTZWN1cmUgRW5jcnlwdGVk
IFZpcnR1YWxpemF0aW9uIEFQSSkNCiANCiBLVk0gRm9ydW0gc2xpZGVzOg0KIGh0dHA6Ly93d3cu
bGludXgta3ZtLm9yZy9pbWFnZXMvNy83NC8wMngwOEEtVGhvbWFzX0xlbmRhY2t5LUFNRHNfVmly
dHVhbGl6YXRvaW5fTWVtb3J5X0VuY3J5cHRpb25fVGVjaG5vbG9neS5wZGYNCi0tIA0KMi4xNy4x
DQoNCg==
