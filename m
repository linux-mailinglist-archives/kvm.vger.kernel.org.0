Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7501035DE
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 09:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfKTIPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 03:15:39 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63204 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbfKTIPi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 03:15:38 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAK85svL009739;
        Wed, 20 Nov 2019 00:15:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=NXccrDU4jUg8Cth88saDCvqjzfq1z2Cdv4jy/cqZRCk=;
 b=pcVJVbJHR00NIO1/qMoawgWEZMAQ3hHmN2t0QeweNEgfimFQkV5WLNmOcZcvfFUZ+8mq
 Krdlt13aCnDYuowkfvVUvtIJrtPNR01aZWJfUaZ7UKgS1kV2vVKGang0Nm8q636LMwFF
 73vrGeihIe0K2WefCLkUpJ/NUt4QVrwg0H7lAu60mIupe86qE7rKJ7YsLU5sdEOfS4IY
 gD2PVZxw7jReb446dMHB/zBVTBb1OKAaQ10p5Yvm9CMt6ZO8FFVJzum/17+vv5tK7w0J
 C4qZTv8adRwxuJX2KSUSppNA7rz2Ds1o3G5Cn8/e9w9Rm6V+6WQRplrLLw1qfTXtP0LN Wg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc8426q8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 00:15:23 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 20 Nov
 2019 00:15:21 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 20 Nov 2019 00:15:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGT3MWsudxRjOGISj/k9T7o7gkcRQgFEYg2L5A63yNi+buNFI9JoQLzQOLL56c/jUu4WpKV72vsHARHPL7Mod5wmhPVx0tBtNfBM5yOHqaXUgBUqRfrH1szU3tbAVfA7aGUjeZkyXRZtnzTj20sSB1JEkgxylYvhvGaOG9x7vrpm+Kk9YD4gJV3JKOAzNeRmEGy/pTSyTtAIVJk1G5PxrUYstwxePZlQ+7n9ozKwexDGSUeASBhywA/ZlkR09KvzmYEJIAn14FRXJsJefBXaV+03XXOvLM2VTHa+GEANYhOHwZ6H5cNgTwjir8T8loUTdQnek/X4uo2j36W1iTDgrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXccrDU4jUg8Cth88saDCvqjzfq1z2Cdv4jy/cqZRCk=;
 b=Wk4ABorT4iqmrYARRa73BhfiRu8T0Aj4G7hQLIHumvJJv70x9SGQZEYrmOdrgBzAIfifrvbTRjVhweqzqTn7SIQ5ZrXLSt3KEalkD3XBQW0efA6CH4QFRdb5n6AB2uiLfB94LcFyLQkFqqMyefTjh485/41WA/1sJ+vCs10VJPRlA+BDojgOONIl5sQ2bx+ZqvOIZQPk+93N+cLOaZbDSnQIXKKH65F06uSyvFdj6+/i7q6hwlCfzpC7eSBriB8JcNWNc/e/XlVaaRm+Im7C636HLQtCFxiiXw2Cx35CHDes6dOLzsrT3/A44fqk4QgxvJHoXZ1CUoDrAgtcC+UqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXccrDU4jUg8Cth88saDCvqjzfq1z2Cdv4jy/cqZRCk=;
 b=ktXezgO83w4oXl9++xzm1DPIDu8m/qr0eWO6oDgXp4t0jfWQCIOXIKWhwGSvOiKqT4j+bQDh2NljIa8oUZfpW8cChjvvUTl7F6U5BARyTkqiBBKxyOCI/SOBZey8nPZe2Rn8c5VJMVxNYJemoVFA7FZlJ0dCCTd+Ovi9eSapyI4=
Received: from DM6PR18MB2969.namprd18.prod.outlook.com (20.179.52.17) by
 DM6PR18MB2730.namprd18.prod.outlook.com (20.179.52.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Wed, 20 Nov 2019 08:15:18 +0000
Received: from DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::f5f0:40c:87ca:4b84]) by DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::f5f0:40c:87ca:4b84%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 08:15:18 +0000
From:   Tomasz Nowicki <tnowicki@marvell.com>
To:     Eric Auger <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "tina.zhang@intel.com" <tina.zhang@intel.com>
Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
Thread-Topic: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
Thread-Index: AQHVn3qlKxoei5IlH0+Ji9e5qHWChQ==
Date:   Wed, 20 Nov 2019 08:15:18 +0000
Message-ID: <a35234a6-e386-fc8e-fcc4-5db4601b00d2@marvell.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
In-Reply-To: <20190711135625.20684-1-eric.auger@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To DM6PR18MB2969.namprd18.prod.outlook.com
 (2603:10b6:5:170::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [31.172.191.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 511b3813-700b-4929-8dd0-08d76d91c78a
x-ms-traffictypediagnostic: DM6PR18MB2730:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <DM6PR18MB27304A6E59439019CB8BE753D24F0@DM6PR18MB2730.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(189003)(199004)(2171002)(81166006)(81156014)(2616005)(5660300002)(478600001)(7736002)(31696002)(966005)(86362001)(229853002)(476003)(14444005)(8936002)(256004)(25786009)(99286004)(446003)(31686004)(11346002)(6512007)(2201001)(8676002)(6306002)(66066001)(71200400001)(71190400001)(66946007)(66476007)(66556008)(64756008)(66446008)(6486002)(26005)(36756003)(186003)(6436002)(2906002)(2501003)(7416002)(54906003)(316002)(110136005)(4326008)(6506007)(6246003)(305945005)(386003)(53546011)(52116002)(486006)(14454004)(3846002)(6116002)(76176011)(102836004)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2730;H:DM6PR18MB2969.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5XU6CdYtVWDSLeSFMlnH3VfJ5byiDBsDVDvIxv/Bl5Zh/RBdTUTx9owzLNIm3VBcBpaIim3wcYPjWdlEA/x8K0Ckro4a34b8oaalE2cy1W9H2WQidCpc1JwNYbTpSFG5hnfPRLzWNHfrVzVRUnDqWg4pSKMOjr3tm69EZHgn9FIgNI5NxQXStMjCOXKZl4tIqEJr9uiCW9wMzNgyHHYEkNLDxqxwFvqghtTJ4T9t6Q3xC1O0aVXDhbIaKVyVXlluLAOvy9ikPW6jD70je+C1bFKI7ZR1aJ+XbCPOaIxGHooAmkvwMwxrNRJBRSlY/irwbKddg8ThNzd9bAIgjxOAucxoT032QTbk/LQDnZ3d0gP2PqHRQXWDny5IukUbuFx463Ig0FDXD03T4gtGFyjzcMbbFLaXbWLpG/47yKfDwSPW2q+Sd12e4iVTIKhIvyYQ73av4juht5SyAqcJCBxgcTqONa7nxzUth97b/wWVno=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B66C25518CA4B489527FA76BDF3EB82@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 511b3813-700b-4929-8dd0-08d76d91c78a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 08:15:18.5304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ziiaiol5YSefcNdInRscD0CJCZxVGCSEHe8U1BkQrQMi7BUfCGIiMBMjbphR1ZIiRnJS+QB9eRpDyjbU3yJm7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2730
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_01:2019-11-15,2019-11-20 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KT24gMTEuMDcuMjAxOSAxNTo1NiwgRXJpYyBBdWdlciB3cm90ZToNCj4gVGhp
cyBzZXJpZXMgYnJpbmdzIHRoZSBWRklPIHBhcnQgb2YgSFcgbmVzdGVkIHBhZ2luZyBzdXBwb3J0
DQo+IGluIHRoZSBTTU1VdjMuDQo+IA0KPiBUaGUgc2VyaWVzIGRlcGVuZHMgb246DQo+IFtQQVRD
SCB2OSAwMC8xNF0gU01NVXYzIE5lc3RlZCBTdGFnZSBTZXR1cCAoSU9NTVUgcGFydCkNCj4gKGh0
dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2tlcm5lbC9tc2czMTg3NzE0Lmh0bWwpDQo+IA0K
PiAzIG5ldyBJT0NUTHMgYXJlIGludHJvZHVjZWQgdGhhdCBhbGxvdyB0aGUgdXNlcnNwYWNlIHRv
DQo+IDEpIHBhc3MgdGhlIGd1ZXN0IHN0YWdlIDEgY29uZmlndXJhdGlvbg0KPiAyKSBwYXNzIHN0
YWdlIDEgTVNJIGJpbmRpbmdzDQo+IDMpIGludmFsaWRhdGUgc3RhZ2UgMSByZWxhdGVkIGNhY2hl
cw0KPiANCj4gVGhleSBtYXAgb250byB0aGUgcmVsYXRlZCBuZXcgSU9NTVUgQVBJIGZ1bmN0aW9u
cy4NCj4gDQo+IFdlIGludHJvZHVjZSB0aGUgY2FwYWJpbGl0eSB0byByZWdpc3RlciBzcGVjaWZp
YyBpbnRlcnJ1cHQNCj4gaW5kZXhlcyAoc2VlIFsxXSkuIEEgbmV3IERNQV9GQVVMVCBpbnRlcnJ1
cHQgaW5kZXggYWxsb3dzIHRvIHJlZ2lzdGVyDQo+IGFuIGV2ZW50ZmQgdG8gYmUgc2lnbmFsZWQg
d2hlbmV2ZXIgYSBzdGFnZSAxIHJlbGF0ZWQgZmF1bHQNCj4gaXMgZGV0ZWN0ZWQgYXQgcGh5c2lj
YWwgbGV2ZWwuIEFsc28gYSBzcGVjaWZpYyByZWdpb24gYWxsb3dzDQo+IHRvIGV4cG9zZSB0aGUg
ZmF1bHQgcmVjb3JkcyB0byB0aGUgdXNlciBzcGFjZS4NCj4gDQo+IEJlc3QgUmVnYXJkcw0KPiAN
Cj4gRXJpYw0KPiANCj4gVGhpcyBzZXJpZXMgY2FuIGJlIGZvdW5kIGF0Og0KPiBodHRwczovL2dp
dGh1Yi5jb20vZWF1Z2VyL2xpbnV4L3RyZWUvdjUuMy4wLXJjMC0yc3RhZ2UtdjkNCg0KSSB0aGlu
ayB5b3UgaGF2ZSBhbHJlYWR5IHRlc3RlZCBvbiBUaHVuZGVyWDIsIGJ1dCBhcyBhIGZvcm1hbGl0
eSwgZm9yIA0KdGhlIHdob2xlIHNlcmllczoNCg0KVGVzdGVkLWJ5OiBUb21hc3ogTm93aWNraSA8
dG5vd2lja2lAbWFydmVsbC5jb20+DQpxZW11OiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL3Fl
bXUvdHJlZS92NC4xLjAtcmMwLTJzdGFnZS1yZmN2NQ0Ka2VybmVsOiBodHRwczovL2dpdGh1Yi5j
b20vZWF1Z2VyL2xpbnV4L3RyZWUvdjUuMy4wLXJjMC0yc3RhZ2UtdjkgKyANClNoYW1lZXIncyBm
aXggcGF0Y2gNCg0KSW4gbXkgdGVzdCBJIGFzc2lnbmVkIEludGVsIDgyNTc0TCBOSUMgYW5kIHBl
cmZvcm0gaXBlcmYgdGVzdHMuDQoNCk90aGVyIGZvbGtzIGZyb20gTWFydmVsbCBjbGFpbWVkIHRo
aXMgdG8gYmUgaW1wb3J0YW50IGZlYXR1cmUgc28gSSBhc2tlZCANCnRoZW0gdG8gcmV2aWV3IGFu
ZCBzcGVhayB1cCBvbiBtYWlsaW5nIGxpc3QuDQoNClRoYW5rcywNClRvbWFzeg0K
