Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64D969EFA
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 00:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbfGOWfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 18:35:04 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:41244
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730473AbfGOWfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 18:35:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGUbTBoiKKDfS2uBD6zCsD5JbftwAPe9bsDpjWpqPw0vOAWqFXHJ5MKQiKAe/FUDSDYDFyCmb8f6NKC4W9Ty/+muSIVbGYbmcddI8pFOfAT5HXRi4cxXAP3Iam1rc+YC4OZUYhOX0TlfCHc1FgDE9jzunf4zLO7JZKOch7xcrTpjGgP9vvF0pbbbka97T9Hl0e3bCtJiXeVamUqanQDA6nt3eVXoKsdww6ENvfI+PMrEyaABwSCPOtQW5AIHwdBLEnOBK7u1uvNNWvKd8bL3BnQRaUv6wsvKtas/R5tS2WJAGGTcbM52X0dPaNHw3XLQG4C9AOVd3B+Yru/G5My+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJL2a9qd/YS+c398W9Lb4mbNR8+ELEBBXZuPL0I3ltI=;
 b=OBIuFR7+FslSTwyi+FLWloS4jtNMnZLA7Tb+MjDO5buOqdslWW3IzhcZQXYs5og+zu4hVhYjx2rjWrF9mI22aPH6Bs9NTPo3mL/GS+4bPGvVI3uTIOQZq5kdr0AL27Rahbov/8d5hiyKPsV4uoIDuiKeQ3ws07kph1SCUwSpANRqW8jXNTfKe1Ha3vJVcZkeohcPKkcQeZ/PtZV6/dYMqzb9lbAPOaMU6afD91n/wU9Ck9eBZfCzZAroIk9kPvtmMkDoVBJZVcLMKP9PpOH9T8T8z42+nBjeWUsGRx4mRzIm94ePFx4CABiUYpV7v0QbEyIU1LBTo/e9rRQxqkqMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJL2a9qd/YS+c398W9Lb4mbNR8+ELEBBXZuPL0I3ltI=;
 b=LPpueaIP0JaEhYPcbURBcD590lKO5jWCK8dZibW/13p+hVUTCSpz0pzl8U5j0cxxFm8MznP3AW6JIjAMZ+gVuUp9PpRDZ8KAB0F0vVSYzXmtpK1nwJx7PQVB32iq2IRsx9MVrQ9rQqi7x1R+pb9gZOLxa1kBUAyUrZXPPrPKc1w=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3786.namprd12.prod.outlook.com (10.255.173.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 22:35:01 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::a91d:8752:288:ed5f]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::a91d:8752:288:ed5f%6]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 22:35:01 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     =?utf-8?B?SmFuIEguIFNjaMO2bmhlcnI=?= <jschoenh@amazon.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: [PATCH 4/6] kvm: lapic: Add apicv activate/deactivate helper
 function
Thread-Topic: [PATCH 4/6] kvm: lapic: Add apicv activate/deactivate helper
 function
Thread-Index: AQHU4KZvukQXllsT80ClQydRuIOOIqZiGR+AgGrgpAA=
Date:   Mon, 15 Jul 2019 22:35:00 +0000
Message-ID: <499a4947-bb65-a0ea-cf16-088a3a4b1ebd@amd.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-5-suravee.suthikulpanit@amd.com>
 <813c8c15-af74-6d77-4a30-2e0ee4b05006@amazon.de>
In-Reply-To: <813c8c15-af74-6d77-4a30-2e0ee4b05006@amazon.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [165.204.77.11]
x-clientproxiedby: SN4PR0501CA0043.namprd05.prod.outlook.com
 (2603:10b6:803:41::20) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecb5ef48-776b-42e2-ead4-08d70974ac47
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3786;
x-ms-traffictypediagnostic: DM6PR12MB3786:
x-microsoft-antispam-prvs: <DM6PR12MB37866ED8C8CBF3A1BC395B7BF3CF0@DM6PR12MB3786.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(54094003)(199004)(189003)(6116002)(86362001)(66476007)(66446008)(26005)(68736007)(3846002)(66946007)(31696002)(64756008)(486006)(256004)(14444005)(36756003)(186003)(66066001)(65806001)(446003)(65956001)(2616005)(54906003)(11346002)(66556008)(14454004)(58126008)(110136005)(476003)(6436002)(316002)(64126003)(229853002)(305945005)(6512007)(7736002)(31686004)(53546011)(6506007)(81156014)(8936002)(6486002)(2501003)(5660300002)(6246003)(81166006)(386003)(2201001)(8676002)(102836004)(99286004)(2906002)(65826007)(53936002)(52116002)(71190400001)(25786009)(66574012)(71200400001)(76176011)(4326008)(478600001)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3786;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YuYd26yeoWMQbsaKmw6I1rwZqhD3fXY/HOPF0WIsgTzHhipEk1EZyhlVKNyQiDVghDS1wAUTKHpG6N/dzbrOHODHZZyG0NHXJBVwERAAY+2mzor2KNgt1OyJn/zOpQc/qC1VliRKMVUoxxiY4BLhUW7SL6fViIL18cT5bR9nDkEvd+yvJw3Q0bWt6SKOEnijgXBNXWRey9nvjQcx271zLVatNwWZvmMEzN/WfQVEeHfSqk99kMgvjvjkekD4uYFDPsCnWF40SgufSsv3INHcrr+jwKXponrfh48/PHMyiA1ImuOhyXE2JWgaBEEz3y6BZcCKvTy2dyaP2DYSkSlf0WhVTzwBBemW3XshbfxDlL1Gi5GLlNYchDrob2+Zk54eEDnu/tC0Olrcf1KtIP/8q3TNf4AjyVhDH9ViPyoX000=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60B55220210ACF44B70ED401B71FABE6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb5ef48-776b-42e2-ead4-08d70974ac47
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 22:35:01.0090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssuthiku@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3786
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SmFuLA0KDQpPbiA1LzgvMjAxOSA1OjI3IFBNLCBKYW4gSC4gU2Now7ZuaGVyciB3cm90ZToNCj4g
T24gMjIvMDMvMjAxOSAxMi41NywgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90ZToNCj4+IElu
dHJvZHVjZSBhIGhlbHBlciBmdW5jdGlvbiBmb3Igc2V0dGluZyBsYXBpYyBwYXJhbWV0ZXJzIHdo
ZW4NCj4+IGFjdGl2YXRlL2RlYWN0aXZhdGUgYXBpY3YuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTog
U3VyYXZlZSBTdXRoaWt1bHBhbml0PHN1cmF2ZWUuc3V0aGlrdWxwYW5pdEBhbWQuY29tPg0KPj4g
LS0tDQo+PiAgIGFyY2gveDg2L2t2bS9sYXBpYy5jIHwgMjMgKysrKysrKysrKysrKysrKysrLS0t
LS0NCj4+ICAgYXJjaC94ODYva3ZtL2xhcGljLmggfCAgMSArDQo+PiAgIDIgZmlsZXMgY2hhbmdl
ZCwgMTkgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL2xhcGljLmMgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPj4gaW5kZXggOTUy
OTVjZjgxMjgzLi45YzVjZDFhOTg5MjggMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vbGFw
aWMuYw0KPj4gKysrIGIvYXJjaC94ODYva3ZtL2xhcGljLmMNCj4+IEBAIC0yMTI2LDYgKzIxMjYs
MjIgQEAgdm9pZCBrdm1fbGFwaWNfc2V0X2Jhc2Uoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQg
dmFsdWUpDQo+Pg0KPj4gICB9DQo+Pg0KPj4gK3ZvaWQga3ZtX2FwaWNfdXBkYXRlX2FwaWN2KHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4+ICt7DQo+PiArICAgICBzdHJ1Y3Qga3ZtX2xhcGljICph
cGljID0gdmNwdS0+YXJjaC5hcGljOw0KPj4gKyAgICAgYm9vbCBhY3RpdmUgPSB2Y3B1LT5hcmNo
LmFwaWN2X2FjdGl2ZTsNCj4+ICsNCj4+ICsgICAgIGlmIChhY3RpdmUpIHsNCj4+ICsgICAgICAg
ICAgICAgLyogaXJyX3BlbmRpbmcgaXMgYWx3YXlzIHRydWUgd2hlbiBhcGljdiBpcyBhY3RpdmF0
ZWQuICovDQo+PiArICAgICAgICAgICAgIGFwaWMtPmlycl9wZW5kaW5nID0gdHJ1ZTsNCj4+ICsg
ICAgICAgICAgICAgYXBpYy0+aXNyX2NvdW50ID0gMTsNCj4+ICsgICAgIH0gZWxzZSB7DQo+PiAr
ICAgICAgICAgICAgIGFwaWMtPmlycl9wZW5kaW5nID0gISFjb3VudF92ZWN0b3JzKGFwaWMtPnJl
Z3MgKyBBUElDX0lSUik7DQo+IFdoYXQgYWJvdXQ6DQo+ICAgICAgICAgICAgICAgICAgYXBpYy0+
aXJyX3BlbmRpbmcgPSBhcGljX3NlYXJjaF9pcnIoYXBpYykgIT0gLTE7DQo+IGluc3RlYWQ/ICht
b3JlIGluIGxpbmUgd2l0aCB0aGUgbG9naWMgaW4gYXBpY19jbGVhcl9pcnIoKSkNCg0KU3VyZSwg
dGhhdCB3b3JrcyBhbHNvLg0KDQo+IFJlbGF0ZWQgdG8gdGhpcywgSSB3b25kZXIgaWYgd2UgbmVl
ZCB0byBlbnN1cmUgdG8gZXhlY3V0ZQ0KPiBrdm1feDg2X29wcy0+c3luY19waXJfdG9faXJyKCkg
anVzdCBiZWZvcmUgYXBpY3ZfYWN0aXZlIHRyYW5zaXRpb25zDQo+IGZyb20gdHJ1ZSB0byBmYWxz
ZSwgc28gdGhhdCB3ZSBkb24ndCBtaXNzIGFuIGludGVycnVwdCBhbmQgaXJyX3BlbmRpbmcNCj4g
aXMgc2V0IGNvcnJlY3RseSBpbiB0aGlzIGZ1bmN0aW9uIChvbiBJbnRlbCBhdCBsZWFzdCkuDQoN
CkknbSBub3Qgc3VyZSBhYm91dCB0aGUgUElSIG9uIEludGVsLCBidXQgQU1EIHNpbmNlIEFNRCBJ
T01NVSBoYXJkd2FyZQ0KZGlyZWN0bHkgdXBkYXRlcyB0aGUgdkFQSUMgYmFja2luZyBwYWdlLCB0
aGUgZHJpdmVyIHNob3VsZCBub3QgbmVlZA0KdG8gd29ycnkuDQoNCj4gSG1tLi4uIHRoZXJlIHNl
ZW1zIHRvIGJlIG90aGVyIHN0dWZmIGFzIHdlbGwsIHRoYXQgZGVwZW5kcyBvbg0KPiB2Y3B1LT5h
cmNoLmFwaWN2X2FjdGl2ZSwgd2hpY2ggaXMgbm90IHVwZGF0ZWQgb24gYSB0cmFuc2l0aW9uLiBG
b3INCj4gZXhhbXBsZTogcG9zdGVkIGludGVycnVwdHMsIA0KDQpZb3UgYXJlIHJpZ2h0LiBXZSBu
ZWVkIHRvIGFsc28gaGFuZGxlIHRoZSBwb3N0ZWQtaW50ZXJydXB0DQphY3RpdmF0ZS9kZWFjdGl2
YXRlLiBJIGFtIGFsc28gZG9pbmcgdGhpcyBpbiBWMi4NCg0KPiBDUjggaW50ZXJjZXB0LCANCg0K
V2hlbiBBUElDdiBpcyBkZWFjdGl2YXRlZCwgdGhlIHVwZGF0ZV9jcjhfaW50ZXJjZXB0KCkgc2hv
dWxkIGhhbmRsZQ0KdXBkYXRpbmcgb2YgQ1I4IGludGVyY2VwdGlvbi4NCg0KPiBhbmQgYSBwb3Rl
bnRpYWwgYXN5bW1ldHJ5IHZpYSBhdmljX3ZjcHVfbG9hZCgpL2F2aWNfdmNwdV9wdXQoKQ0KPiBi
ZWNhdXNlIHRoZSBib3R0b20gaGFsZiBvZiBqdXN0IG9uZSBvZiB0aGUgdHdvIGZ1bmN0aW9ucyBt
YXkgYmUNCj4gc2tpcHBlZA0KTm90IHN1cmUgaWYgSSB1bmRlcnN0YW5kIHRoZSBjb25jZXJuIHRo
YXQgeW91IG1lbnRpb25lZCBoZXJlLg0KSG93ZXZlciwgb25jZSB3ZSBhZGQgdGhlIElPTU1VIGFj
dGl2YXRpb24vZGVhY3RpdmF0aW9uIGNvZGUgZm9yDQpwb3N0ZWQtaW50ZXJydXB0LCB3ZSBzaG91
bGQgbm90IG5lZWQgdG8gd29ycnkgYWJvdXQgY2FsbGluZw0KYXZpY191cGRhdGVfaW9tbXVfdmNw
dV9hZmZpbml0eSgpIGF0IHRoZSBlbmQgb2YgdGhlIGZ1bmN0aW9ucw0KaGVyZS4NCg0KVGhhbmtz
LA0KU3VyYXZlZQ0KPiBSZWdhcmRzDQo+IEphbg0KPiANCg==
