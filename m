Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE81364FB
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 02:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgAJBoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 20:44:46 -0500
Received: from mail-shaon0151.outbound.protection.partner.outlook.cn ([42.159.164.151]:33086
        "EHLO cn01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730604AbgAJBoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 20:44:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=panyiai.partner.onmschina.cn; s=selector1-panyiai-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MK9nj8OgzFBy8K6hZX6R9FPWWsWfvMTLBgGxJtl4XEg=;
 b=nttlpryIXt5Zxor3R8oyertgAK+rOJI3+R3qRcq0Owt7gSO8kisVsIaaTHFe0DbgeQWT8t4iC5jPi/+GygCN+FiEwUNboCkOHqd4lftceXdNJ28Wx+aP0YbqMJgKYqcDfDeuaivgSuIf4DkwXXUqA2HDGQQR6PzqacbJtW4EERI=
Received: from BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn (10.43.32.81) by
 BJXPR01MB0295.CHNPR01.prod.partner.outlook.cn (10.41.52.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Fri, 10 Jan 2020 01:44:40 +0000
Received: from BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn ([10.43.32.81])
 by BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn ([10.43.32.81]) with mapi id
 15.20.2623.013; Fri, 10 Jan 2020 01:44:39 +0000
From:   Renjun Wang <rwang@panyi.ai>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?utf-8?B?5Zue5aSNOiBWRklPIFBST0JMRU06IHBjaV9hbGxvY19pcnFfdmVjdG9ycyBm?=
 =?utf-8?B?dW5jdGlvbiByZXF1ZXN0IDMyIE1TSSBpbnRlcnJ1cHRzIHZlY3RvcnMsIGJ1?=
 =?utf-8?Q?t_return_1_in_KVM_virtual_machine.?=
Thread-Topic: VFIO PROBLEM: pci_alloc_irq_vectors function request 32 MSI
 interrupts vectors, but return 1 in KVM virtual machine.
Thread-Index: AdW9InlyzaDL52etQ6qMDqb0chxtmQHv+HOAAJ0KxtA=
Date:   Fri, 10 Jan 2020 01:44:39 +0000
Message-ID: <BJXPR01MB05348789AE5E2CFBA51BD905DE380@BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn>
References: <BJXPR01MB0534C845ED8D3942E95E7BC7DE250@BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn>
 <20200106154055.294322d0@w520.home>
In-Reply-To: <20200106154055.294322d0@w520.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=rwang@panyi.ai; 
x-originating-ip: [182.150.24.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba2eb95b-4a18-4a50-ef9a-08d7956ea84f
x-ms-traffictypediagnostic: BJXPR01MB0295:
x-microsoft-antispam-prvs: <BJXPR01MB0295EBA7726E2B9C955637F7DE380@BJXPR01MB0295.CHNPR01.prod.partner.outlook.cn>
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(346002)(396003)(366004)(376002)(199004)(189003)(53754006)(328002)(329002)(5660300002)(2906002)(64756008)(66446008)(66556008)(66476007)(76116006)(66946007)(86362001)(95416001)(316002)(6116002)(3846002)(66066001)(8936002)(14454004)(305945005)(6916009)(26005)(7736002)(4326008)(7696005)(966005)(11346002)(486006)(446003)(63696004)(224303003)(33656002)(102836004)(76176011)(81156014)(6306002)(9686003)(71200400001)(71190400001)(478600001)(186003)(59450400001)(55016002)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BJXPR01MB0295;H:BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:3;MX:3;
received-spf: None (protection.outlook.com: panyi.ai does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IHfxCaDl4t4KZEUdL4LH4JfxAnvjAAk4WLr5L0mhDO6i6CnL8wu/zp8/LUeRwnrt+ajUtbS4VTzASJ7Zsqigy6nQxZ/M6vy9hSw0K0zvF6lOKe5wCbnfLN89fmbbTAnLGbrVVugzfdvvK/auNXEkK7ffD9LCZtXPhcvH4B9LDG9g91qH0prTVcHmZqqQWTSB0oXAsZLfMyFkrnFGI4gFj4fRxF4eVHiwYoT8r/TNxqAPLRKgsLV0j8U1vxZuB7tTvTBjyoy1NlNdtRAMfGSUQkdc+k3SoF6sVa+45XD8XD/2dL4/jyrBwt+5OOXYkHeKdMNn8TaME9RW0mLQTx+BcJBTkHeCYD/uTs1uWTT5ujifEp3BbdAUnuGoBMCmycQpol1bkBf6j7Yd0fcYaRx65QbMuTSzrcd4NwAk3Lp3RKx/oQjMiJ+0AtD8XEOfSKU55Os9vZWcgc/BmTY19CeEuvWSgdUoUaOEQaibKFgteuK+HBkS8y93b9ExYtMgVSEREhMZOPgwuA5NaQSjmpRIKsuym0MYDjqY6MjUKCC71GM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: panyi.ai
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2eb95b-4a18-4a50-ef9a-08d7956ea84f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 01:44:39.6707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ce39a546-bdfb-4992-b21b-9a56b068e472
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cACnfCO2NBsCAJNMBWxCcOc/qrOLzup8WLQf1hKsHCaqIL8ezLXHY7HvzluST3sR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0295
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujoga3ZtLW93bmVyQHZnZXIua2Vy
bmVsLm9yZyA8a3ZtLW93bmVyQHZnZXIua2VybmVsLm9yZz4g5Luj6KGoIEFsZXggV2lsbGlhbXNv
bg0K5Y+R6YCB5pe26Ze0OiAyMDIw5bm0MeaciDfml6UgNjo0MQ0K5pS25Lu25Lq6OiBSZW5qdW4g
V2FuZyA8cndhbmdAcGFueWkuYWk+DQrmioTpgIE6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCuS4u+mi
mDogUmU6IFZGSU8gUFJPQkxFTTogcGNpX2FsbG9jX2lycV92ZWN0b3JzIGZ1bmN0aW9uIHJlcXVl
c3QgMzIgTVNJIGludGVycnVwdHMgdmVjdG9ycywgYnV0IHJldHVybiAxIGluIEtWTSB2aXJ0dWFs
IG1hY2hpbmUuDQoNCk9uIFNhdCwgMjggRGVjIDIwMTkgMDE6NTk6NDMgKzAwMDANClJlbmp1biBX
YW5nIDxyd2FuZ0BwYW55aS5haT4gd3JvdGU6DQoNCj4gSGkgYWxsOg0KPiBJIGhhdmUgYSBxdWVz
dGlvbiBhYm91dCBQQ0kgd2hpY2ggdHJvdWJsZWQgbWUgZm9yIGEgZmV3IHdlZWtzLg0KPiBJIGhh
dmUgYSB2aXJ0dWFsIG1hY2hpbmUgd2l0aCB1YnVudHUgMTYuNC4wMyBvbiBLVk0gcGxhdGZvcm0u
IFRoZXJlIGlzIA0KPiBhIFBDSWUgZGV2aWNlKFhpbGlueCBQQ0llIElQKSBwbHVnZ2VkIGluIHRo
ZSBob3N0IG1hY2hpbmUsIGFuZCANCj4gcGFzc3Rocm91Z2ggdG8gZ3Vlc3QgdmlhIFZGSU8gZmVh
dHVyZS4gT24gdGhlIHVidW50dSBvcGVyYXRpb24gc3lzdGVtLCANCj4gSSBhbSBkZXZlbG9waW5n
IHRoZSBwY2llIGRyaXZlci4gV2hlbiBJIHVzZQ0KPiBwY2lfYWxsb2NfaXJxX3ZlY3RvcnMoKSBm
dW5jdGlvbiB0byBhbGxvY2F0ZSAzMiBtc2kgdmVjdG9ycywgYnV0IA0KPiByZXR1cm4gMS4gVGhl
IGNvbW1hbmTCoCBgbHNwY2kgLXZ2dmAgb3V0cHV0IHNob3dzIE1TSTogRW5hYmxlKw0KPiBDb3Vu
dD0xLzMyIE1hc2thYmxlKyA2NGJpdCsNCj4gDQo+IHRoZXJlIGlzIGEgc2ltaWxhciBjYXNlDQo+
IGh0dHBzOi8vc3RhY2tvdmVyZmxvdy5jb20vcXVlc3Rpb25zLzQ5ODIxNTk5L211bHRpcGxlLW1z
aS12ZWN0b3JzLWxpbnV4LXBjaS1hbGxvYy1pcnEtdmVjdG9ycy1yZXR1cm4tb25lLXdoaWxlLXRo
ZS1kZXZpLg0KPiBCdXQgbm90IHdvcmtpbmcgZm9yIEtWTSB2aXJ0dWFsIG1hY2hpbmUuDQo+IA0K
PiBJIGRvIG5vdCBrbm93biB3aHkgdGhlIGZ1bmN0aW9uwqAgcGNpX2FsbG9jX2lycV92ZWN0b3Jz
KCkgcmV0dXJucyBvbmUgPw0KDQpXaGVuIHlvdSBzYXkgaXQncyBub3Qgd29ya2luZyBpbiB0aGUg
dmlydHVhbCBtYWNoaW5lIHdpdGggdGhhdCBzdGFja292ZXJmbG93IHRpcCwgZG9lcyB0aGF0IG1l
YW4geW91ciBWTSBpcyBydW5uaW5nIGEgUTM1IG1hY2hpbmUgdHlwZSB3aXRoIHRoZSBpbnRlbC1p
b21tdSBkZXZpY2UgZW5hYmxlZCBpbiBib3RoIFFFTVUgYW5kIG9uIHRoZSBndWVzdCBjb21tYW5k
IGxpbmU/ICBZb3Ugc2hvdWxkIHNlZSAiSVItUENJLU1TSSIgaW4gL3Byb2MvaW50ZXJydXB0cyBv
biBob3N0IGFuZCBndWVzdCBmb3IgdGhlIGludGVycnVwdCB0eXBlIGlmIHRoZSBpbnRlcnJ1cHQg
cmVtYXBwaW5nIGlzIGVuYWJsZWQuDQpMaW51eCBkb2Vzbid0IHN1cHBvcnQgbXVsdGlwbGUgTVNJ
IHZlY3RvcnMgd2l0aG91dCBzb21lIGtpbmQgb2YgaW50ZXJydXB0IHJlbWFwcGVyIHN1cHBvcnQu
ICBZb3UgcHJvYmFibHkgaGF2ZSB0aGF0IG9uIHRoZSBob3N0LCBidXQgeW91J2xsIG5lZWQgaXQg
aW4gdGhlIGd1ZXN0IGFzIHdlbGwgb3IgZWxzZSB0aGUgZ3Vlc3Qga2VybmVsIHdpbGwgbGltaXQg
eW91IHRvIGEgc2luZ2xlIHZlY3Rvci4NCg0KQlRXLCBpZiB5b3UgaGF2ZSBhbnkgaW5mbHVlbmNl
IG92ZXIgdGhlIGRldmljZSwgeW91IHJlYWxseSwgcmVhbGx5IHdhbnQgdG8gdXNlIE1TSS1YIGZv
ciBzdXBwb3J0aW5nIG11bHRpcGxlIHZlY3RvcnMuICBUaGFua3MsDQoNCkFsZXgNCg0KDQpIaSwg
QWxleA0KVGhhbmtzIHZlcnkgbXVjaCBmb3IgeW91ciByZXNwb25zZS4gSXQgaXMgaW5kZWVkIHZJ
T01NVSBub3QgZW5hYmxlZCBpbiBndWVzdCBtYWNoaW5lLiBBY2NvcmRpbmcgdGhlIHBhZ2UgYXMg
YmxldywgSSByZWNvbmZpZ3VyZSB0aGUgcWVtdSB2aXJ0dWFsIG1hY2hpbmUgc2V0dGluZywgYWhh
IGl0IGlzIHdvcmtpbmcuIFRoYW5rcyBhZ2Fpbi4NCmh0dHBzOi8vd2lraS5xZW11Lm9yZy9GZWF0
dXJlcy9WVC1kDQoNCg==
