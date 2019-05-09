Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6406F18F5C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 19:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfEIRjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 13:39:09 -0400
Received: from mail-eopbgr700041.outbound.protection.outlook.com ([40.107.70.41]:60162
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfEIRjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 13:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xgt3Eo6om+aRkbGrjNNACgVS3HMUFsIYY1qHRdQZ4jY=;
 b=RbR/FmZYwRDq7m+WXbZcABMWFlFof/D6qGxVCaWtfZoWU4XtGGsrxmhEspREAhCZI2M1LGTUI/Yz7AbL/ua6c2N4AxfVGFU1SlE3sHBYgy7ewgGKevpTx07OaWR8S/ye6wUh16TG5jvH5yFbLqw6r+1x4TKubL3TabwSqyZ43sI=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB2649.namprd12.prod.outlook.com (20.176.116.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.15; Thu, 9 May 2019 17:39:06 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6%2]) with mapi id 15.20.1856.012; Thu, 9 May 2019
 17:39:06 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "Graf, Alexander" <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH] svm/avic: Allow avic_vcpu_load logic to support host APIC
 ID 255
Thread-Topic: [PATCH] svm/avic: Allow avic_vcpu_load logic to support host
 APIC ID 255
Thread-Index: AQHVAbVYshI13bVJeUaA1Du2DOEuS6Zfu3aAgANdToA=
Date:   Thu, 9 May 2019 17:39:06 +0000
Message-ID: <da74be11-1278-3b0f-db19-459f2f50e2ad@amd.com>
References: <1556890631-9561-1-git-send-email-suravee.suthikulpanit@amd.com>
 <49a27e83-a83e-5d2d-9b11-bb09c15776d2@amazon.com>
In-Reply-To: <49a27e83-a83e-5d2d-9b11-bb09c15776d2@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
x-originating-ip: [165.204.77.11]
x-clientproxiedby: SN6PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:805:3e::27) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e696d50-d3d3-401c-46f9-08d6d4a53bf8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2649;
x-ms-traffictypediagnostic: DM6PR12MB2649:
x-microsoft-antispam-prvs: <DM6PR12MB2649C13F25331A86F474A47DF3330@DM6PR12MB2649.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(346002)(136003)(376002)(189003)(199004)(2616005)(64126003)(53546011)(229853002)(6506007)(53936002)(6486002)(7736002)(305945005)(316002)(6436002)(5660300002)(65806001)(65956001)(11346002)(76176011)(476003)(386003)(99286004)(2906002)(66066001)(26005)(65826007)(14444005)(256004)(486006)(186003)(66946007)(102836004)(66446008)(73956011)(66476007)(6512007)(66556008)(64756008)(2201001)(25786009)(52116002)(4326008)(86362001)(81156014)(81166006)(8676002)(54906003)(58126008)(110136005)(8936002)(446003)(31696002)(6116002)(14454004)(478600001)(2501003)(71200400001)(71190400001)(72206003)(36756003)(68736007)(31686004)(3846002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2649;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t5Py5kj0hAtg21WA3UKDAiRgX9A8HmQrwF2QVHi9baVRAEaw+HDulr50wWPGS+9l1aUwliCJF3/rz9PbNP0BjSeJXiNP37H9/vnhLX6QscEAKmhmdSeTJ5VGHXGbdm0UMV6QNREG61HAlqYAde/BlZGTw4RJEBFaDHeP936OroPti+8CXM3JhRuSPL1iN8ZAEyb2RCWSMj5IMiFbiXhbM8hsz58fXcT5PTtiOWZBrhAfHnVxoC/R0BDrKXPoH4I/eJpOOaKg7VlSZZ87ZMyNOzTi7UDyNComs3Adlwr+/LHkvqWrjcpzYVL2vWwVKaPEcTmBY4YeJCKgyfzonZqpWSscWRw340Y4DWqTJEmXw3NhKO/9++PoPL2A7ILYnjfwaiVppy9MuW7kpguMmlbIfrRPPQc8jSEueCUkegHlLCQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACBC78EBDC856D41923BEE77CE679440@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e696d50-d3d3-401c-46f9-08d6d4a53bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 17:39:06.3525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2649
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gNS83LzE5IDk6MTYgQU0sIEdyYWYsIEFsZXhhbmRlciB3cm90ZToNCj4gW0NB
VVRJT046IEV4dGVybmFsIEVtYWlsXQ0KPiANCj4gT24gMDMuMDUuMTkgMTU6MzcsIFN1dGhpa3Vs
cGFuaXQsIFN1cmF2ZWUgd3JvdGU6DQo+PiBDdXJyZW50IGxvZ2ljIGRvZXMgbm90IGFsbG93IFZD
UFUgdG8gYmUgbG9hZGVkIG9udG8gQ1BVIHdpdGgNCj4+IEFQSUMgSUQgMjU1LiBUaGlzIHNob3Vs
ZCBiZSBhbGxvd2VkIHNpbmNlIHRoZSBob3N0IHBoeXNpY2FsIEFQSUMgSUQNCj4+IGZpZWxkIGlu
IHRoZSBBVklDIFBoeXNpY2FsIEFQSUMgdGFibGUgZW50cnkgaXMgYW4gOC1iaXQgdmFsdWUsDQo+
PiBhbmQgQVBJQyBJRCAyNTUgaXMgdmFsaWQgaW4gc3lzdGVtIHdpdGggeDJBUElDIGVuYWJsZWQu
DQo+Pg0KPj4gSW5zdGVhZCwgZG8gbm90IGFsbG93IFZDUFUgbG9hZCBpZiB0aGUgaG9zdCBBUElD
IElEIGNhbm5vdCBiZQ0KPj4gcmVwcmVzZW50ZWQgYnkgYW4gOC1iaXQgdmFsdWUuDQo+Pg0KPj4g
U2lnbmVkLW9mZi1ieTogU3VyYXZlZSBTdXRoaWt1bHBhbml0IDxzdXJhdmVlLnN1dGhpa3VscGFu
aXRAYW1kLmNvbT4NCj4gDQo+IFlvdXIgY29tbWVudCBmb3IgQVZJQ19NQVhfUEhZU0lDQUxfSURf
Q09VTlQgc2F5cyB0aGF0IDB4ZmYgKDI1NSkgaXMNCj4gYnJvYWRjYXN0IGhlbmNlIHlvdSBkaXNh
bGxvdyB0aGF0IHZhbHVlLiBJbiBmYWN0LCBldmVuIHRoZSBjb21tZW50IGEgZmV3DQo+IGxpbmVz
IGFib3ZlIHRoZSBwYXRjaCBodW5rIGRvZXMgc2F5IHRoYXQuIFdoeSB0aGUgY2hhbmdlIG9mIG1p
bmQ/DQoNCkFjdHVhbGx5LCBJIHdvdWxkIG5lZWQgdG8gbWFrZSBjaGFuZ2UgdG8gdGhhdCBjb21t
ZW50IHRvIHJlbW92ZSB0aGUgbWVudGlvbmluZw0Kb2YgMjU1IGFzIGJyb2FkY2FzdC4gSSB3aWxs
IHNlbmQgb3V0IFYyIHdpdGggcHJvcGVyIGNvbW1lbnQgZml4Lg0KDQpUaGUgcmVhc29uIGlzIGJl
Y2F1c2Ugb24gc3lzdGVtIHcvIHgyQVBJQywgdGhlIEFQSUMgSUQgMjU1IGlzIGFjdHVhbGx5DQpu
b24tYnJvYWRjYXN0LCBhbmQgdGhpcyBzaG91bGQgYmUgYWxsb3dlZC4gVGhlIGNvZGUgaGVyZSBz
aG91bGQgbm90IG5lZWQNCnRvIGNoZWNrIGZvciBicm9hZGNhc3QuDQoNClRoYW5rcywNClN1cmF2
ZWUNCg0KPiBBbGV4DQo+IA0KPj4gLS0tDQo+PiDCoCBhcmNoL3g4Ni9rdm0vc3ZtLmMgfCA2ICsr
KysrLQ0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0v
c3ZtLmMNCj4+IGluZGV4IDI5NDQ0OGUuLjEyMjc4OGYgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4
Ni9rdm0vc3ZtLmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4gQEAgLTIwNzEsNyAr
MjA3MSwxMSBAQCBzdGF0aWMgdm9pZCBhdmljX3ZjcHVfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIGludCBjcHUpDQo+PiDCoMKgwqDCoMKgIGlmICgha3ZtX3ZjcHVfYXBpY3ZfYWN0aXZlKHZj
cHUpKQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOw0KPj4NCj4+IC3CoMKg
wqDCoCBpZiAoV0FSTl9PTihoX3BoeXNpY2FsX2lkID49IEFWSUNfTUFYX1BIWVNJQ0FMX0lEX0NP
VU5UKSkNCj4+ICvCoMKgwqDCoCAvKg0KPj4gK8KgwqDCoMKgwqAgKiBTaW5jZSB0aGUgaG9zdCBw
aHlzaWNhbCBBUElDIGlkIGlzIDggYml0cywNCj4+ICvCoMKgwqDCoMKgICogd2UgY2FuIHN1cHBv
cnQgaG9zdCBBUElDIElEIHVwdG8gMjU1Lg0KPj4gK8KgwqDCoMKgwqAgKi8NCj4+ICvCoMKgwqDC
oCBpZiAoV0FSTl9PTihoX3BoeXNpY2FsX2lkID4gQVZJQ19NQVhfUEhZU0lDQUxfSURfQ09VTlQp
KQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOw0KPj4NCj4+IMKgwqDCoMKg
wqAgZW50cnkgPSBSRUFEX09OQ0UoKihzdm0tPmF2aWNfcGh5c2ljYWxfaWRfY2FjaGUpKTsNCj4+
DQo+IA0K
