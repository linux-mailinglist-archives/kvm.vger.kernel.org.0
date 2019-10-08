Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816A8D00CA
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 20:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfJHSok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 14:44:40 -0400
Received: from mail-eopbgr810089.outbound.protection.outlook.com ([40.107.81.89]:38430
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbfJHSok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 14:44:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9YLMVNwQ8J/4CC6Q6xg3j8OuuSaE/nGO6r3NQvCxcw+lL8oHxwh60pb5x94DPYOeTrejz6UOAwC2rl7WPicccfoLX8cXA7Yo1eODVE9s1v9HTc/bEwgFwIJgCAGCUP7j+gkA0DV+u2k7YyRliWer26AeJFJO9QyGBqM1CvtPciFBbo7+b/3AlalNvrrYZbmi+slXq+F0k/Dr6yBInOWJED1MtAHGbBtp5Bh7L3aPclzCGJvpAkJ3OS9Cp4bVIx1lubyVodZOGcYzSgvkArRdw3vaBqmAUid1guqzqWa5XzLph11ji9UtNTWvo050n+8cmV7Ff6ucDIZhGmJ9sO5+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFqvbFurP4B9n38LYfle/JvDr3BQLv9Mq1x0T9IMaUE=;
 b=ZHcUC2cVTC0x/P1tQkSQb59eBY9vMuJ0Loc1WxhIWLOurqxEx79NHzz7BhE1BS3OrT6IMjvKWf7cLoT52TN1k2mzryD5LZqVUlOW01m4GmzHwSQT/GE0fVJf+Lcunq6fSH0srnZPZvPag3bZyKRmxaihaYhaOm4499WX0U4Ro3RQ/+ezVLiWa8IcQ8hNMzswlhP78y3fyew+YjbpTx9uUYfzksfj0Yt5tqyS5s/OWfBIVIkn/DOVGPm0dcjONGeH1xYYcHPqNY/ARjCAEXyeA09RoiHpiYgptsGZRnb98StJ7ejrqXt29M4Xi7r//um12Cwq/0YMVFUO5H/okA4FFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFqvbFurP4B9n38LYfle/JvDr3BQLv9Mq1x0T9IMaUE=;
 b=lhjANjDDpltdYevGYNVsj5Rr1DkzQggXyLaOXQETVZfdKWtMNTdIxegbmMTrUclM839TaB6icsbzRz7IACtrbeiMYxyjUStmEaLE30K0UPbXdlhj37ecQ+RXQv/mTHX+0Kgbd/7mDHTagWNJ1lqNb4iqz3TUpltRGQ+O7IxjMAc=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3580.namprd12.prod.outlook.com (20.178.199.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.25; Tue, 8 Oct 2019 18:44:36 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::39e2:cd71:d9a8:b6bf]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::39e2:cd71:d9a8:b6bf%6]) with mapi id 15.20.2327.026; Tue, 8 Oct 2019
 18:44:36 +0000
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
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v3 00/16] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
Thread-Topic: [PATCH v3 00/16] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
Thread-Index: AQHVamWNwMSOXdHv0kO89gBM6mvXd6dRPA8A
Date:   Tue, 8 Oct 2019 18:44:36 +0000
Message-ID: <ea9dd7d9-f02c-6b05-88b5-d766bb837ed3@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-originating-ip: [165.204.77.11]
x-clientproxiedby: SN4PR0401CA0034.namprd04.prod.outlook.com
 (2603:10b6:803:2a::20) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 217c7af5-585b-4755-ba40-08d74c1f915e
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3580:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3580916F1580DB470931F333F39A0@DM6PR12MB3580.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(189003)(199004)(53754006)(4326008)(6116002)(6306002)(66446008)(64756008)(66476007)(36756003)(14444005)(66946007)(66556008)(71190400001)(6486002)(256004)(229853002)(71200400001)(2501003)(31686004)(65956001)(6436002)(7416002)(3846002)(65806001)(14454004)(66066001)(6512007)(2906002)(6246003)(31696002)(86362001)(5660300002)(8676002)(81156014)(7736002)(8936002)(25786009)(478600001)(186003)(81166006)(305945005)(53546011)(476003)(58126008)(76176011)(52116002)(26005)(102836004)(316002)(54906003)(110136005)(2616005)(99286004)(6506007)(386003)(11346002)(486006)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3580;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3MrOKlI93gJlHbfpLgaskCFtjjR2aVGJyHQzMVunNvlgm8dNSi9ujhMRkB3EUKL/Qo0Nvm5ig++QMygmXERBfEUykIDwgF9CfQ348LrV07oPIRc8aRAUUIwpGynZNesWj1t0j3a6w7dOWPXCe4ZPMXjAlBPeTpCb65w5j0AOg2slWj3W9yAwE8iotC/oTQbskzCuvWAsAw0Z+RVwNKkJxwL+e6X1pg/42AJGa7ZP3m5w5miKLHyOEeFE3UqXlLekG+rhMrgt+fPIKEGZg/QCdPiOOx7iJqSKzVreFwOtOgliqdrYVgRbzHqBXzZM4SgmpnIR6CxAr4HLS8fM18xZXMdhKfwqtlzfno2v0TsiOEY65LUluexlX5GL5ld8mxuFKOrfnzJYQgle8XYbjutStMhaVOxTgq+JyJ/UY8ixKiJTlN7yJwB5/NzUhz5XSbET3AAOvqFx2hykf0JfU65AQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <05D7F7C48E6A5B4B91A78F4098F5E412@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217c7af5-585b-4755-ba40-08d74c1f915e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 18:44:36.7603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /xincGrRkzvlhEqD9H4F2ev3GLJMD6pcexhGLFalW+NApLQIo/Cum2qjV17GlNepM0m+++1rhOO5osddA5us7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3580
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGluZzoNCg0KSGkgQWxsLA0KDQpBcmUgdGhlcmUgb3RoZXIgY29uY2VybnMgb3Igc3VnZ2VzdGlv
bnMgZm9yIHRoaXMgc2VyaWVzPw0KDQpUaGFua3MsDQpTdXJhdmVlDQoNCk9uIDkvMTMvMTkgMjow
MCBQTSwgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90ZToNCj4gVGhlICdjb21taXQgNjcwMzRi
YjlkZDVlICgiS1ZNOiBTVk06IEFkZCBpcnFjaGlwX3NwbGl0KCkgY2hlY2tzIGJlZm9yZQ0KPiBl
bmFibGluZyBBVklDIiknIHdhcyBpbnRyb2R1Y2VkIHRvIGZpeCBtaXNjZWxsYW5lb3VzIGJvb3Qt
aGFuZyBpc3N1ZXMNCj4gd2hlbiBlbmFibGUgQVZJQy4gVGhpcyBpcyBtYWlubHkgZHVlIHRvIEFW
SUMgaGFyZHdhcmUgZG9lc3Qgbm90ICN2bWV4aXQNCj4gb24gd3JpdGUgdG8gTEFQSUMgRU9JIHJl
Z2lzdGVyIHJlc3VsdGluZyBpbi1rZXJuZWwgUElDIGFuZCBJT0FQSUMgdG8NCj4gd2FpdCBhbmQg
ZG8gbm90IGluamVjdCBuZXcgaW50ZXJydXB0cyAoZS5nLiBQSVQsIFJUQykuDQo+IA0KPiBUaGlz
IGxpbWl0cyBBVklDIHRvIG9ubHkgd29yayB3aXRoIGtlcm5lbF9pcnFjaGlwPXNwbGl0IG1vZGUs
IHdoaWNoIGlzDQo+IG5vdCBjdXJyZW50bHkgZW5hYmxlZCBieSBkZWZhdWx0LCBhbmQgYWxzbyBy
ZXF1aXJlZCB1c2VyLXNwYWNlIHRvDQo+IHN1cHBvcnQgc3BsaXQgaXJxY2hpcCBtb2RlbCwgd2hp
Y2ggbWlnaHQgbm90IGJlIHRoZSBjYXNlLg0KPiANCj4gVGhlIGdvYWwgb2YgdGhpcyBzZXJpZXMg
aXMgdG8gZW5hYmxlIEFWSUMgdG8gd29yayBpbiBib3RoIGlycWNoaXAgbW9kZXMsDQo+IGJ5IGFs
bG93aW5nIEFWSUMgdG8gYmUgZGVhY3RpdmF0ZWQgdGVtcG9yYXJpbHkgZHVyaW5nIHJ1bnRpbWUs
IGFuZCBmYWxsYmFjaw0KPiB0byBsZWdhY3kgaW50ZXJydXB0IGluamVjdGlvbiBtb2RlICh3LyB2
SU5UUiBhbmQgaW50ZXJydXB0IHdpbmRvd3MpDQo+IHdoZW4gbmVlZGVkLCBhbmQgdGhlbiByZS1l
bmFibGVkIHN1YnNlcXVlbnRseS4NCj4gDQo+IFNpbWlsYXIgYXBwcm9hY2ggaXMgYWxzbyB1c2Vk
IHRvIGhhbmRsZSBIeXBlci1WIFN5bklDIGluIHRoZQ0KPiAnY29tbWl0IDVjOTE5NDEyZmU2MSAo
Imt2bS94ODY6IEh5cGVyLVYgc3ludGhldGljIGludGVycnVwdCBjb250cm9sbGVyIiknLA0KPiB3
aGVyZSBBUElDdiBpcyBwZXJtYW5lbnRseSBkaXNhYmxlZCBhdCBydW50aW1lIChjdXJyZW50bHkg
YnJva2VuIGZvcg0KPiBBVklDLCBhbmQgZml4ZWQgYnkgdGhpcyBzZXJpZXMpLg0KPiANCj4gVGhp
cyBzZXJpZXMgY29udGFpbnMgdGhyZWUgcGFydHM6DQo+ICAgICogUGFydCAxOiBwYXRjaCAxLTIN
Cj4gICAgICBJbnRyb2R1Y2UgQVBJQ3Ygc3RhdGUgZW51bSBhbmQgbG9naWMgZm9yIGtlZXBpbmcg
dHJhY2sgb2YgdGhlIHN0YXRlDQo+ICAgICAgZm9yIGVhY2ggdm0uDQo+ICAgDQo+ICAgICogUGFy
dCAyOiBwYXRjaCAzLTExDQo+ICAgICAgQWRkIHN1cHBvcnQgZm9yIGFjdGl2YXRlL2RlYWN0aXZh
dGUgQVBJQ3YgYXQgcnVudGltZQ0KPiANCj4gICAgKiBQYXJ0IDM6IHBhdGNoIDEyLTE2Og0KPiAg
ICAgIFByb3ZpZGUgd29ya2Fyb3VuZCBmb3IgQVZJQyBFT0kgYW5kIGFsbG93IGVuYWJsZSBBVklD
IHcvDQo+ICAgICAga2VybmVsX2lycWNoaXA9b24NCj4gDQo+IFByZS1yZXF1aXNpdGUgUGF0Y2g6
DQo+ICAgICogY29tbWl0IGI5YzZmZjk0ZTQzYSAoImlvbW11L2FtZDogUmUtZmFjdG9yIGd1ZXN0
IHZpcnR1YWwgQVBJQw0KPiAgICAgIChkZS0pYWN0aXZhdGlvbiBjb2RlIikNCj4gICAgICAoaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvam9yby9pb21tdS5n
aXQvY29tbWl0Lw0KPiAgICAgICA/aD1uZXh0JmlkPWI5YzZmZjk0ZTQzYTBlZTA1M2UwYzFkOTgz
ZmJhMWFjNDk1M2I3NjIpDQo+IA0KPiBUaGlzIHNlcmllcyBoYXMgYmVlbiB0ZXN0ZWQgYWdhaW5z
dCB2NS4zLXJjNSBhcyBmb2xsb3dpbmc6DQo+ICAgICogQm9vdGluZyBMaW51eCBhbmQgV2luZG93
cyBTZXJ2ZXIgMjAxOSBWTXMgdXB0byAyNDAgdmNwdXMNCj4gICAgICBhbmQgRnJlZUJTRCB1cHRv
IDEyOCB2Y3B1cyB3LyBxZW11IG9wdGlvbiAia2VybmVsLWlycWNoaXA9b24iDQo+ICAgICAgYW5k
ICItbm8taHBldCIuDQo+ICAgICogUGFzcy10aHJvdWdoIEludGVsIDEwR2JFIE5JQyBhbmQgcnVu
IG5ldHBlcmYgaW4gdGhlIFZNLg0KPiANCj4gQ2hhbmdlcyBmcm9tIFYyOiAoaHR0cHM6Ly9sa21s
Lm9yZy9sa21sLzIwMTkvOC8xNS82NzIpDQo+ICAgICogUmViYXNlIHRvIHY1LjMtcmM1DQo+ICAg
ICogTWlzYyBjaGFuZ2VzIHJlY29tbWVuZGVkIGJ5IEFsZXggYW5kIFZpdGFseS4NCj4gICAgKiBS
ZW5hbWUgQVBJQ1ZfREVBQ1RJVkFURUQgdG8gQVBJQ1ZfU1VTUEVOREVEDQo+ICAgICogRGlzYWJs
ZSBBVklDIHdoZW4gZ3Vlc3QgYm9vdGluZyB3LyBTVk0gc3VwcG9ydCBzaW5jZSBBVklDDQo+ICAg
ICAgZG9lcyBub3QgY3VycmVudGx5IHN1cHBvcnQgZ3Vlc3Qgdy8gbmVzdGVkIHZpcnQuDQo+ICAg
ICogQWRkIHRyYWNlcG9pbnQgZm9yIEFQSUNWIGFjdGl2YXRlL2RlYWN0aXZhdGUgcmVxdWVzdC4g
KHBlciBBbGV4KQ0KPiAgICAqIENvbnNvbGlkYXRlIGNoYW5nZXMgZm9yIGhhbmRsaW5nIEVPSSBm
b3Iga3ZtIFBJVCBlbXVsYXRpb24gYW5kDQo+ICAgICAgSU9BUElDIFJUQyBoYW5kbGluZyBpbiBW
MiBpbnRvIGlvYXBpY19sYXp5X3VwZGF0ZV9lb2koKSBpbg0KPiAgICAgIHBhdGNoIDE3LzE4IG9m
IHYzIHNlcmllLg0KPiAgICAqIFJlbW92ZSBwYXRjaGVzIGZvciBwcm92aWRpbmcgcGVyLXZtIGFw
aWN2X3N0YXRlIGRlYnVnIGluZm9ybWF0aW9uLg0KPiANCj4gQ2hhbmdlcyBmcm9tIFYxOiAoaHR0
cHM6Ly9sa21sLm9yZy9sa21sLzIwMTkvMy8yMi8xMDQyKQ0KPiAgICAqIEludHJvZHVjZSBBUElD
diBzdGF0ZSBlbnVtZXJhdGlvbg0KPiAgICAqIEludHJvZHVjZSBLVk0gZGVidWdmcyBmb3IgQVBJ
Q3Ygc3RhdGUNCj4gICAgKiBBZGQgc3luY2hyb25pemF0aW9uIGxvZ2ljIGZvciBBUElDdiBzdGF0
ZSB0byBwcmV2ZW50IHBvdGVudGlhbA0KPiAgICAgIHJhY2UgY29uZGl0aW9uIChwZXIgSmFuJ3Mg
c3VnZ2VzdGlvbikNCj4gICAgKiBBZGQgc3VwcG9ydCBmb3IgYWN0aXZhdGUvZGVhY3RpdmF0ZSBw
b3N0ZWQgaW50ZXJydXB0DQo+ICAgICAgKHBlciBKYW4ncyBzdWdnZXN0aW9uKQ0KPiAgICAqIFJl
bW92ZSBjYWxsYmFjayBmdW5jdGlvbnMgZm9yIGhhbmRsaW5nIEFQSUMgSUQsIERGUiBhbmQgTERS
IHVwZGF0ZQ0KPiAgICAgIChwZXIgUGFvbG8ncyBzdWdnZXN0aW9uKQ0KPiAgICAqIEFkZCB3b3Jr
YXJvdW5kIGZvciBoYW5kbGluZyBFT0kgZm9yIGluLWtlcm5lbCBQSVQgYW5kIElPQVBJQy4NCj4g
DQo+IFN1cmF2ZWUgU3V0aGlrdWxwYW5pdCAoMTYpOg0KPiAgICBrdm06IHg4NjogTW9kaWZ5IGt2
bV94ODZfb3BzLmdldF9lbmFibGVfYXBpY3YoKSB0byB1c2Ugc3RydWN0IGt2bQ0KPiAgICAgIHBh
cmFtZXRlcg0KPiAgICBrdm06IHg4NjogSW50cm9kdWNlIEtWTSBBUElDdiBzdGF0ZQ0KPiAgICBr
dm06IGxhcGljOiBJbnRyb2R1Y2UgQVBJQ3YgdXBkYXRlIGhlbHBlciBmdW5jdGlvbg0KPiAgICBr
dm06IHg4NjogQWRkIHN1cHBvcnQgZm9yIGFjdGl2YXRlL2RlLWFjdGl2YXRlIEFQSUN2IGF0IHJ1
bnRpbWUNCj4gICAga3ZtOiB4ODY6IEFkZCBBUElDdiBhY3RpdmF0ZS9kZWFjdGl2YXRlIHJlcXVl
c3QgdHJhY2UgcG9pbnRzDQo+ICAgIGt2bTogeDg2OiBzdm06IEFkZCBzdXBwb3J0IHRvIGFjdGl2
YXRlL2RlYWN0aXZhdGUgcG9zdGVkIGludGVycnVwdHMNCj4gICAgc3ZtOiBBZGQgc3VwcG9ydCBm
b3Igc2V0dXAvZGVzdHJveSB2aXJ1dGFsIEFQSUMgYmFja2luZyBwYWdlIGZvciBBVklDDQo+ICAg
IHN2bTogQWRkIHN1cHBvcnQgZm9yIGFjdGl2YXRlL2RlYWN0aXZhdGUgQVZJQyBhdCBydW50aW1l
DQo+ICAgIGt2bTogeDg2OiBoeXBlcnY6IFVzZSBBUElDdiBkZWFjdGl2YXRlIHJlcXVlc3QgaW50
ZXJmYWNlDQo+ICAgIHN2bTogRGlzYWJsZSBBVklDIHdoZW4gbGF1bmNoaW5nIGd1ZXN0IHdpdGgg
U1ZNIHN1cHBvcnQNCj4gICAgc3ZtOiBUZW1wb3JhcnkgZGVhY3RpdmF0ZSBBVklDIGR1cmluZyBF
eHRJTlQgaGFuZGxpbmcNCj4gICAga3ZtOiB4ODY6IEludHJvZHVjZSBzdHJ1Y3Qga3ZtX3g4Nl9v
cHMuYXBpY3ZfZW9pX2FjY2VsZXJhdGUNCj4gICAga3ZtOiBsYXBpYzogQ2xlYW4gdXAgQVBJQyBw
cmVkZWZpbmVkIG1hY3Jvcw0KPiAgICBrdm06IGlvYXBpYzogUmVmYWN0b3Iga3ZtX2lvYXBpY191
cGRhdGVfZW9pKCkNCj4gICAga3ZtOiB4ODY6IGlvYXBpYzogTGF6eSB1cGRhdGUgSU9BUElDIEVP
SQ0KPiAgICBzdm06IEFsbG93IEFWSUMgd2l0aCBpbi1rZXJuZWwgaXJxY2hpcCBtb2RlDQo+IA0K
PiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAgMjggKysrKystDQo+ICAgYXJj
aC94ODYva3ZtL2h5cGVydi5jICAgICAgICAgICB8ICAxMiArKy0NCj4gICBhcmNoL3g4Ni9rdm0v
aW9hcGljLmMgICAgICAgICAgIHwgMTQ5ICsrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0K
PiAgIGFyY2gveDg2L2t2bS9sYXBpYy5jICAgICAgICAgICAgfCAgMzUgKysrKy0tLQ0KPiAgIGFy
Y2gveDg2L2t2bS9sYXBpYy5oICAgICAgICAgICAgfCAgIDIgKw0KPiAgIGFyY2gveDg2L2t2bS9z
dm0uYyAgICAgICAgICAgICAgfCAxOTggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLQ0KPiAgIGFyY2gveDg2L2t2bS90cmFjZS5oICAgICAgICAgICAgfCAgMzAgKysrKysr
DQo+ICAgYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgICB8ICAgMiArLQ0KPiAgIGFyY2gv
eDg2L2t2bS94ODYuYyAgICAgICAgICAgICAgfCAxMzYgKysrKysrKysrKysrKysrKysrKysrKysr
KystDQo+ICAgOSBmaWxlcyBjaGFuZ2VkLCA1MDYgaW5zZXJ0aW9ucygrKSwgODYgZGVsZXRpb25z
KC0pDQo+IA0K
