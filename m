Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C32C9D63E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 21:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbfHZTGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 15:06:06 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:17366
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727815AbfHZTGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 15:06:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlvSXeL5Wlhz9ls0pcYughd6kxAXOb2HNEVmywfe3fmroTYHVNf/pCVGPoh78cxbjzkih0GWKGCFZMoTWSseoE05L4MrQ6fa2sCyTeoPmfR6/Twe/NGTFA/+IcfYqV6rGZd4O6bCTm+wX28PDXrfQ1ueYXy3joTkVyWBTnBzEFHGam1sZhkcCjXtiVGcZOe/ohShcXcB6ZgIiFhOd9M3jLBjdF7jpqhmRUZBE2eyVm3Ban8DnuknwgezYBVs8KEmt8Nedo6kLk408fBJ6ckCrgKDB+CUhGpY9Lclmy/VWrfyNv1QwRtc80I4a62WicQzlElL99kwGREJazs/RrZsWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVClBIwqAYvj0MO4lAXiZTu/1t5y7ehYiDccZma+5kM=;
 b=VtZuZTxF4nMGFWtS8ag4JIxBf1wSiECrOgVSwc6Y6njKgeXyJZ1g4vXXGipGpquaia0MU18UWtQIkfGsuH/eQh9w6O/aEupwWjVAjc1Q9LE3X766VrgMCgoBJYdMxlYBe9cj+LpqlbfLptVdn1WpU/JRivUJ11cAAXiwC7pGAhMQ0/gnRT9fcR2cXWs3dzWirEhf4DI1/StEG1E6qSnazS4G+nI4z+NBS90iWJBBf7/JFl1snu4O53XgHClp8vskogUEsBMqDWTVTBiStVuC6IvFBYSWxSJeYoOsdpCCLRZu/8ZfSYNzxyQ99EBDs7J6ctGNqI9KzAblMF03POVLOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVClBIwqAYvj0MO4lAXiZTu/1t5y7ehYiDccZma+5kM=;
 b=Kh/EPSeoTv+SdR1KjMiqBgAeISs3ufZ9OfA6pCzsW6WSvKPzOUwRZWrWmd/siv4S6fJEFvK2uL0ma4GKLLS+P+xzUXfj34LaYmLx6clrUSvCDqtliwgXJ4iR5rUL1Qj3SO7knX9dhNxLbQ3EUbXOjsTeDBVNYiHfZTfT9ArVdtk=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3002.namprd12.prod.outlook.com (20.178.29.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 19:06:01 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2178.023; Mon, 26 Aug 2019
 19:06:01 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Alexander Graf <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v2 02/15] kvm: x86: Introduce KVM APICv state
Thread-Topic: [PATCH v2 02/15] kvm: x86: Introduce KVM APICv state
Thread-Index: AQHVU4X+5ose5W5zl0+8RrY/mJxbz6cCP6cAgAub4oA=
Date:   Mon, 26 Aug 2019 19:06:01 +0000
Message-ID: <869df1a2-eb09-c68d-e1eb-053b3d60787e@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-3-git-send-email-suravee.suthikulpanit@amd.com>
 <7c71379b-d94c-dc8e-f684-331183f8a594@amazon.com>
In-Reply-To: <7c71379b-d94c-dc8e-f684-331183f8a594@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [165.204.77.1]
x-clientproxiedby: SN6PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:805:3e::33) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16627c5a-49be-4a9a-39c8-08d72a586f72
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3002;
x-ms-traffictypediagnostic: DM6PR12MB3002:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB300262AB355A1197B1F92581F3A10@DM6PR12MB3002.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(53936002)(8936002)(65806001)(65956001)(66066001)(110136005)(58126008)(54906003)(316002)(36756003)(86362001)(6436002)(2201001)(305945005)(8676002)(81156014)(81166006)(7736002)(5660300002)(31696002)(486006)(446003)(2906002)(11346002)(476003)(2616005)(386003)(6506007)(53546011)(2501003)(6116002)(478600001)(14454004)(3846002)(186003)(14444005)(26005)(66556008)(66946007)(64756008)(66446008)(76176011)(256004)(229853002)(102836004)(52116002)(66476007)(25786009)(6512007)(6486002)(6246003)(31686004)(99286004)(71190400001)(71200400001)(4326008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3002;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9PJHWZp/rS8SDl0rThW9F2d5gIGDE1EKsK0sUSGiUYC0DhA9A8iM3zqkUWXXcEVzGqVX+BGnQNsJJQA3nRCnw0/sZH7InR+Ijqc7qXQd/Uae3nAsGUM7Azmzr5bG5QF/ZqwSQPY1RQPeUHl/LXgUZRl3KAUOaBKcYdLbVx2Bt+QzbpcCmqR503rc8y1h5BUHQV2Uue25GkMuG1EGLALiHKunNzwM7ZCiffGTBvfLSGpCIxB2vb8PHlB+9oofioW2jRxlDCnxGMh4n/vBeueXsJx+a0WlGX2mFgto4jc/8ppLxBgPjueMpJ1NpLcsjgjHiaCajh1r1+c80gCEZe03a7Gg5z0shtBDvWemf4dJhBWX6WjHBUcRgQf7udEgX+ZSYluyFI3cuAqe8YlmoaIh7eflq7MlFHhwwF4N778rrG0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B450046B0341A84A9B2D781BE8629CEF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16627c5a-49be-4a9a-39c8-08d72a586f72
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 19:06:01.3788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xKXa17JbYEtUADv7oyAWiQuvDSnWNY186y/t1zfIgdww0UQYF1WplrXJzTHyUyyYCkLkd/YzLXYHDfduj7Goaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8xOS8yMDE5IDQ6NDkgQU0sIEFsZXhhbmRlciBHcmFmIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDE1LjA4LjE5IDE4OjI1LCBTdXRoaWt1bHBhbml0LCBTdXJhdmVlIHdyb3RlOg0K
Pj4gQ3VycmVudGx5LCBhZnRlciBhIFZNIGJvb3RzIHdpdGggQVBJQ3YgZW5hYmxlZCwgaXQgY291
bGQgZ28gaW50bw0KPj4gdGhlIGZvbGxvd2luZyBzdGF0ZXM6DQo+PiDCoMKgICogYWN0aXZhdGVk
wqDCoCA9IFZNIGlzIHJ1bm5pbmcgdy8gQVBJQ3YNCj4+IMKgwqAgKiBkZWFjdGl2YXRlZCA9IFZN
IGRlYWN0aXZhdGUgQVBJQ3YgKHRlbXBvcmFyeSkNCj4+IMKgwqAgKiBkaXNhYmxlZMKgwqDCoCA9
IFZNIGRlYWN0aXZhdGUgQVBJQ3YgKHBlcm1hbmVudCkNCj4+DQo+PiBJbnRyb2R1Y2UgS1ZNIEFQ
SUN2IHN0YXRlIGVudW0gdG8gaGVscCBrZWVwIHRyYWNrIG9mIHRoZSBBUElDdiBzdGF0ZXMNCj4+
IGFsb25nIHdpdGggYSBuZXcgdmFyaWFibGUgc3RydWN0IGt2bV9hcmNoLmFwaWN2X3N0YXRlIHRv
IHN0b3JlDQo+PiB0aGUgY3VycmVudCBzdGF0ZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTdXJh
dmVlIFN1dGhpa3VscGFuaXQgPHN1cmF2ZWUuc3V0aGlrdWxwYW5pdEBhbWQuY29tPg0KPj4gLS0t
DQo+PiDCoCBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgMTEgKysrKysrKysrKysN
Cj4+IMKgIGFyY2gveDg2L2t2bS94ODYuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTQg
KysrKysrKysrKysrKy0NCj4+IMKgIDIgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9r
dm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPj4gaW5kZXggNTZi
YzcwMi4uMDRkNzA2NiAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmgNCj4+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4+IEBAIC04
NDUsNiArODQ1LDE1IEBAIGVudW0ga3ZtX2lycWNoaXBfbW9kZSB7DQo+PiDCoMKgwqDCoMKgIEtW
TV9JUlFDSElQX1NQTElULMKgwqDCoMKgwqDCoMKgIC8qIGNyZWF0ZWQgd2l0aCBLVk1fQ0FQX1NQ
TElUX0lSUUNISVAgKi8NCj4+IMKgIH07DQo+PiArLyoNCj4+ICsgKiBLVk0gYXNzdW1lcyBhbGwg
dmNwdXMgaW4gYSBWTSBvcGVyYXRlIGluIHRoZSBzYW1lIG1vZGUuDQo+PiArICovDQo+PiArZW51
bSBrdm1fYXBpY3Zfc3RhdGUgew0KPj4gK8KgwqDCoCBBUElDVl9ESVNBQkxFRCzCoMKgwqDCoMKg
wqDCoCAvKiBEaXNhYmxlZCAoc3VjaCBhcyBmb3IgSHlwZXItViBjYXNlKSAqLw0KPj4gK8KgwqDC
oCBBUElDVl9ERUFDVElWQVRFRCzCoMKgwqAgLyogRGVhY3RpdmF0ZWQgdGVtcG9lcmFyeSAqLw0K
PiANCj4gdHlwbw0KPiANCj4gSSdtIGFsc28gbm90IHN1cmUgdGhlIG5hbWUgaXMgMTAwJSBvYnZp
b3VzLiBIb3cgYWJvdXQgc29tZXRoaW5nIGxpa2UgInN1c3BlbmRlZCIgb3IgInBhdXNlZCI/DQoN
Ck9rLCBJJ2xsIGNoYW5nZSBpdCB0byBBUElDVl9TVVNQRU5ERUQuDQoNCj4+IC4uLg0KPj4gQEAg
LTkxNTAsMTMgKzkxNTQsMTggQEAgaW50IGt2bV9hcmNoX3ZjcHVfaW5pdChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBmYWlsX2ZyZWVfcGlvX2RhdGE7
DQo+PiDCoMKgwqDCoMKgIGlmIChpcnFjaGlwX2luX2tlcm5lbCh2Y3B1LT5rdm0pKSB7DQo+PiAt
wqDCoMKgwqDCoMKgwqAgdmNwdS0+YXJjaC5hcGljdl9hY3RpdmUgPSBrdm1feDg2X29wcy0+Z2V0
X2VuYWJsZV9hcGljdih2Y3B1LT5rdm0pOw0KPiANCj4gV2h5IGFyZSB5b3UgbW92aW5nIHRoaXMg
aW50byBhIGxvY2tlZCBzZWN0aW9uPw0KDQpTaW5jZSB3ZSBpbnRyb2R1Y2VkIHRoZSBhcGljdl9z
dGF0ZSB0byB0cmFjayB0aGUgVk0gQVBJQ3Ygc3RhdGUsIHdoaWNoIGlzIGFjY2Vzc2libGUNCmJ5
IGVhY2ggdmNwdSBpbml0aWFsaXphdGlvbiBjb2RlLCB3ZSBuZWVkIHRvIGxvY2sgYW5kIGNoZWNr
IHRoZSBzdGF0ZSBiZWZvcmUgc2V0dGluZw0KdGhlIHBlci12Y3B1IGFwaWN2X2FjdGl2ZS4NCg0K
PiANCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByID0ga3ZtX2NyZWF0ZV9sYXBpYyh2Y3B1LCBsYXBp
Y190aW1lcl9hZHZhbmNlX25zKTsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAociA8IDApDQo+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGZhaWxfbW11X2Rlc3Ryb3k7DQo+PiDC
oMKgwqDCoMKgIH0gZWxzZQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHN0YXRpY19rZXlfc2xvd19p
bmMoJmt2bV9ub19hcGljX3ZjcHUpOw0KPj4gK8KgwqDCoCBtdXRleF9sb2NrKCZ2Y3B1LT5rdm0t
PmFyY2guYXBpY3ZfbG9jayk7DQo+PiArwqDCoMKgIGlmIChpcnFjaGlwX2luX2tlcm5lbCh2Y3B1
LT5rdm0pICYmDQo+PiArwqDCoMKgwqDCoMKgwqAgdmNwdS0+a3ZtLT5hcmNoLmFwaWN2X3N0YXRl
ID09IEFQSUNWX0FDVElWQVRFRCkNCj4+ICvCoMKgwqDCoMKgwqDCoCB2Y3B1LT5hcmNoLmFwaWN2
X2FjdGl2ZSA9IGt2bV94ODZfb3BzLT5nZXRfZW5hYmxlX2FwaWN2KHZjcHUtPmt2bSk7DQo+PiAr
wqDCoMKgIG11dGV4X3VubG9jaygmdmNwdS0+a3ZtLT5hcmNoLmFwaWN2X2xvY2spOw0KPj4gKw0K
Pj4gwqDCoMKgwqDCoCB2Y3B1LT5hcmNoLm1jZV9iYW5rcyA9IGt6YWxsb2MoS1ZNX01BWF9NQ0Vf
QkFOS1MgKiBzaXplb2YodTY0KSAqIDQsDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4+IMKgwqDCoMKgwqAg
aWYgKCF2Y3B1LT5hcmNoLm1jZV9iYW5rcykgew0KPj4gQEAgLTkyNTUsNiArOTI2NCw5IEBAIGlu
dCBrdm1fYXJjaF9pbml0X3ZtKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQgbG9uZyB0eXBlKQ0K
Pj4gwqDCoMKgwqDCoCBrdm1fcGFnZV90cmFja19pbml0KGt2bSk7DQo+PiDCoMKgwqDCoMKgIGt2
bV9tbXVfaW5pdF92bShrdm0pOw0KPj4gK8KgwqDCoCAvKiBBUElDViBpbml0aWFsaXphdGlvbiAq
Lw0KPj4gK8KgwqDCoCBtdXRleF9pbml0KCZrdm0tPmFyY2guYXBpY3ZfbG9jayk7DQo+IA0KPiBJ
biBmYWN0LCB0aGUgd2hvbGUgbG9jayBzdG9yeSBpcyBub3QgcGFydCBvZiB0aGUgcGF0Y2ggZGVz
Y3JpcHRpb24gOikuXFwNCg0KT2ssIEknbGwgdXBkYXRlIHRoZSBjb21taXQgbG9nIHRvIGRlc2Ny
aWJlIHRoZSBsb2NrIC4NCg0KU3VyYXZlZQ0K
