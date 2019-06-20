Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF364DA16
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 21:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfFTTSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 15:18:13 -0400
Received: from mail-eopbgr820047.outbound.protection.outlook.com ([40.107.82.47]:11675
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbfFTTSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 15:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suR3vIpR2MAng/ZLvAGVHPBJ5O757B+AoQWyeHlSQps=;
 b=R1zKgPjXNb9dhJdXaUufUGM/ntfqQTn1IqS4Vkt9qQpD15C5nn0/3wEwDIEFFc93of7fd3m8p6U28VFsYTXs/JYnmGmgQi1tCJGmXdv7CgmrHhGUKrA+QQ+W79Zr1O9z6qVFYOFFrrEg/dyLly9avX8t1NeJsKndoWCaiuWQf+U=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2746.namprd12.prod.outlook.com (20.176.118.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Thu, 20 Jun 2019 19:18:10 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 19:18:10 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Eric Blake <eblake@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC PATCH v1 08/12] target.json: add
 migrate-set-sev-info command
Thread-Topic: [Qemu-devel] [RFC PATCH v1 08/12] target.json: add
 migrate-set-sev-info command
Thread-Index: AQHVJ5JxxSpSr3fdPkCv1Ymp5YKU2qak6W2AgAABNwA=
Date:   Thu, 20 Jun 2019 19:18:10 +0000
Message-ID: <8d743a07-9561-4b8f-89e0-3322356f630e@amd.com>
References: <20190620180247.8825-1-brijesh.singh@amd.com>
 <20190620180247.8825-9-brijesh.singh@amd.com>
 <7bade677-369a-74a5-206d-700626354028@redhat.com>
In-Reply-To: <7bade677-369a-74a5-206d-700626354028@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR22CA0010.namprd22.prod.outlook.com
 (2603:10b6:3:101::20) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 327b7c1a-0786-414a-cd40-08d6f5b4086b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2746;
x-ms-traffictypediagnostic: DM6PR12MB2746:
x-microsoft-antispam-prvs: <DM6PR12MB27469A0E7EDAB20CD413A0DAE5E40@DM6PR12MB2746.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(486006)(229853002)(81156014)(81166006)(6486002)(478600001)(11346002)(446003)(31686004)(54906003)(8936002)(2501003)(110136005)(4326008)(53936002)(186003)(66066001)(8676002)(6246003)(14454004)(25786009)(7736002)(6512007)(6436002)(316002)(305945005)(99286004)(66446008)(64756008)(66476007)(36756003)(66556008)(66946007)(102836004)(71190400001)(52116002)(73956011)(53546011)(71200400001)(6506007)(76176011)(386003)(476003)(14444005)(256004)(31696002)(68736007)(2906002)(26005)(2616005)(3846002)(86362001)(6116002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2746;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fYOWHfnu3a68XBw51M9+m/+NmBsxYBusIIjkOOPHQlshbkEOdPP7Xnjf3csoNst28n70KNu/aGH3sL14vjQoeVq8BZcDjnrRYPOm9YmML15YofdEtKo688Fb/V80lsAwcXOP6QT6NQPM0vQuynAWO9iKxBIYGq4xidPz8p3Nicq1rpnK2c++FFGXz7FrtlYeCHFENgeg367kAkO5aPjbBRXQ9mYGArrAlnkQ9uAPOfgut1ptLWdQklWHIDl14XOQxVgCcbt7IpZtoWxGIwURhJwdENAwWo0irPNIxArGnqsTluTm8LXE8AIg362AT2IF50mMo7hs8tAZAEDEE+E5lQTKiJZ5P7xapfkX4TiWaZ+p1IfdMdHkukh/Jtu9WXTatMbTCnU3zf3bnLqPrBkcYEpaxG26/Jv76SaRKbbrlck=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E52CE6588423D0428541204F416FF1D0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327b7c1a-0786-414a-cd40-08d6f5b4086b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 19:18:10.6053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2746
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDYvMjAvMTkgMjoxMyBQTSwgRXJpYyBCbGFrZSB3cm90ZToNCj4gT24gNi8yMC8xOSAx
OjAzIFBNLCBTaW5naCwgQnJpamVzaCB3cm90ZToNCj4+IFRoZSBjb21tYW5kIGNhbiBiZSB1c2Vk
IGJ5IHRoZSBoeXBlcnZpc29yIHRvIHNwZWNpZnkgdGhlIHRhcmdldCBQbGF0Zm9ybQ0KPj4gRGlm
ZmllLUhlbGxtYW4ga2V5IChQREgpIGFuZCBjZXJ0aWZpY2F0ZSBjaGFpbiBiZWZvcmUgc3RhcnRp
bmcgdGhlIFNFVg0KPj4gZ3Vlc3QgbWlncmF0aW9uLiBUaGUgdmFsdWVzIHBhc3NlZCB0aHJvdWdo
IHRoZSBjb21tYW5kIHdpbGwgYmUgdXNlZCB3aGlsZQ0KPj4gY3JlYXRpbmcgdGhlIG91dGdvaW5n
IGVuY3J5cHRpb24gY29udGV4dC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBCcmlqZXNoIFNpbmdo
IDxicmlqZXNoLnNpbmdoQGFtZC5jb20+DQo+PiAtLS0NCj4+ICAgcWFwaS90YXJnZXQuanNvbiAg
ICAgICB8IDE4ICsrKysrKysrKysrKysrKysrKw0KPj4gICB0YXJnZXQvaTM4Ni9tb25pdG9yLmMg
IHwgMTAgKysrKysrKysrKw0KPj4gICB0YXJnZXQvaTM4Ni9zZXYtc3R1Yi5jIHwgIDUgKysrKysN
Cj4+ICAgdGFyZ2V0L2kzODYvc2V2LmMgICAgICB8IDExICsrKysrKysrKysrDQo+PiAgIHRhcmdl
dC9pMzg2L3Nldl9pMzg2LmggfCAgOSArKysrKysrKy0NCj4+ICAgNSBmaWxlcyBjaGFuZ2VkLCA1
MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPiANCj4+ICsrKyBiL3FhcGkvdGFy
Z2V0Lmpzb24NCj4+IEBAIC01MTIsMyArNTEyLDIxIEBADQo+PiAgICMjDQo+PiAgIHsgJ2NvbW1h
bmQnOiAncXVlcnktY3B1LWRlZmluaXRpb25zJywgJ3JldHVybnMnOiBbJ0NwdURlZmluaXRpb25J
bmZvJ10sDQo+PiAgICAgJ2lmJzogJ2RlZmluZWQoVEFSR0VUX1BQQykgfHwgZGVmaW5lZChUQVJH
RVRfQVJNKSB8fCBkZWZpbmVkKFRBUkdFVF9JMzg2KSB8fCBkZWZpbmVkKFRBUkdFVF9TMzkwWCkg
fHwgZGVmaW5lZChUQVJHRVRfTUlQUyknIH0NCj4+ICsNCj4+ICsjIw0KPj4gKyMgQG1pZ3JhdGUt
c2V0LXNldi1pbmZvOg0KPj4gKyMNCj4+ICsjIFRoZSBjb21tYW5kIGlzIHVzZWQgdG8gcHJvdmlk
ZSB0aGUgdGFyZ2V0IGhvc3QgaW5mb3JtYXRpb24gdXNlZCBkdXJpbmcgdGhlDQo+PiArIyBTRVYg
Z3Vlc3QuDQo+PiArIw0KPj4gKyMgQHBkaCB0aGUgdGFyZ2V0IGhvc3QgcGxhdGZvcm0gZGlmZmll
LWhlbGxtYW4ga2V5IGVuY29kZWQgaW4gYmFzZTY0DQo+PiArIw0KPj4gKyMgQHBsYXQtY2VydCB0
aGUgdGFyZ2V0IGhvc3QgcGxhdGZvcm0gY2VydGlmaWNhdGUgY2hhaW4gZW5jb2RlZCBpbiBiYXNl
NjQNCj4+ICsjDQo+PiArIyBAYW1kLWNlcnQgQU1EIGNlcnRpZmljYXRlIGNoYWluIHdoaWNoIGlu
Y2x1ZGUgQVNLIGFuZCBPQ0EgZW5jb2RlZCBpbiBiYXNlNjQNCj4+ICsjDQo+PiArIyBTaW5jZSA0
LjMNCj4gDQo+IFRoZSBuZXh0IHJlbGVhc2UgaXMgNC4xLCB0aGVuIGxpa2VseSA0LjIgbmVhciB0
aGUgZW5kIG9mIHRoZSBjYWxlbmRhcg0KPiB5ZWFyLCB0aGVuIDUuMCBpbiAyMDIwLiBUaGVyZSBp
cyBubyBwbGFubmVkIDQuMyByZWxlYXNlLiAgQXJlIHlvdSB0cnlpbmcNCj4gdG8gZ2V0IHRoaXMg
aW4gNC4xPw0KDQoNCkFoLCBJIHdhcyBtZWFuaW5nIHRvIHR5cGUgNC4yIGFuZCBub3QgNC4zLiBU
aGUgc2VyaWVzIGhhcyBkZXBlbmRlbmN5IG9uDQprZXJuZWwgcGF0Y2hlcywgbXkgYmVzdCBlZmZv
cnQgaXQgdG8gZ2V0IGl0IHJlYWR5IGZvciA0LjIgbWVyZ2UNCndpbmRvdy4NCg==
