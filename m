Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0F62217BE
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 00:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgGOW1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 18:27:34 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:53249
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726356AbgGOW1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 18:27:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpa0RbPpM/NPr+YvlZIizSbo6icSFfgb/G8YbgJ5+EaZ8bUJawFC5b3EtZz7jI3dbEXPTihtAAE7BdKsqkWHkS4lTTsAJyK0PjAmm5jmoa/c51eemINJR+kT+lxLsJXhHyLKNwCTs4Y3PhircCiJVeMxQujSGQV+43AG9SJ8U/slfEz7Qqs075zpC+LQ1VprdJAP4YxAwbcI+w5HP3Qjhr/cbhJStWL+0N9K/QpcatL0jicUy2DqV3m+18phlADPzEGEjeGYmuaXZeUHhEldLCgZpGh1yKvTG7LzOKw+x3BRsIc6RJvDVeOy24onSJ6GAIJgujPDd6Dt1hBgtnnDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PKYgQvCKP9qM/OQDohNZpnfBsNPhfeO+7cgTkAw6ww=;
 b=I7YOu6txpxKvYAEMXbA9w2NRkuSyWMxK050cbDvu1cBow/8Rv076P1qIc+jbELI1UnsJDWnqnjiKkPHZ18m7/8wIsQKPJ+RGPCPKVGc36g0aYVbRmFTaEl7SDsWnJWu1oopSDZEVJ5I28Bi1NK7obmWZ9/+frGNpMBpF+QmYS7mac+EdMAjpB0j5cUpsWXDwz+RH6MbDq4aKdMlb7LsU4YRZyOzOcJ+eEFTVevV62a0umqyeG1URHur/luY6hLgCcdgdjb0lnkgMfKX2SJWQTlabI53m3wsB9E46fSAQs7RMM+Xxezmr5xR4f1amP+Uo1oSoBJ8nZjCT1iNYsQkPTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PKYgQvCKP9qM/OQDohNZpnfBsNPhfeO+7cgTkAw6ww=;
 b=Z3KvJgZn1LAR0eQzlFznXIafPNlFn9DStRHIC79AbTn9tJNFhj3OWrsIZWRmSmMdjt2qU88gZDhNXTjYZR1zZ66UXuT68eQmsHNzHEj062scXGjM+woeUSlb50jogG7HvK+a5JRw0L4sb7tBVU2O+BhjoyGVUjjG3E06vDSFYbA=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB4584.namprd05.prod.outlook.com (2603:10b6:a02:f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9; Wed, 15 Jul
 2020 22:27:31 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3195.017; Wed, 15 Jul 2020
 22:27:31 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Topic: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Index: AQHWWM/s9eQwCvJDT0a4UjvbTfvUQ6kGIrqAgAABgoCAAAGtgIAAA5kAgAMRZoCAAAG4AA==
Date:   Wed, 15 Jul 2020 22:27:30 +0000
Message-ID: <9DC37B0B-597A-4B31-8397-B6E4764EEA37@vmware.com>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
 <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
In-Reply-To: <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:d804:e155:7b4c:bf3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4db6d13e-0521-4141-d7c6-08d8290e4366
x-ms-traffictypediagnostic: BYAPR05MB4584:
x-microsoft-antispam-prvs: <BYAPR05MB4584FFDCD1CED49E214D395BD07E0@BYAPR05MB4584.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B3xEgpo5tgXV2zYB70MnXylrJkjc8B0vIlt6ZjeDsEnEpRnyrgDcCxqah9+Q/crDVkIdrhEjBZ5i95j/JCXei74Q2Oo774uMT1c29vRKYPjXMKfGQbRBpfDRmPGUcmYNd6EAQYfBcoCbP1ffJjzOewyCHNbfZD2ENVzBOZJoqG2MaCa7DpQnmhZM7D5jchtd2Dfv/4/25G4o1RIHSSdUWG5ubSwCXHsiAky96CDu0feVnkUxaWRL8eDvqR4/NQVtpYqNZE+dwLR4trLuQbOi7seEvJkvckyY/WhsZxEPhJQdzPKBx0rVIKvYPpKErdnKNVhjusU+kebePK2mRvI/xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(2616005)(6506007)(36756003)(71200400001)(53546011)(186003)(86362001)(8936002)(2906002)(6916009)(316002)(8676002)(33656002)(54906003)(6486002)(4326008)(66446008)(76116006)(64756008)(66556008)(66476007)(66946007)(6512007)(5660300002)(83380400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rFkd/POmdrQEQ6bu74KXIu4qC+spPxpeqVHowpZr9dfqT9I7us71KPh9vx/aFTk/dd06PPlaLKduGIDoyQCXrQDC44pc/upm0R1VdUjWslUXlBxHnKnyz3Gxh6FRIueqcRCiC2hzilaZfXx/xWGVSmvwzOdChMPg/bdUbwH26qJ33xLFKZclXQvoyino3kfQtOJvhKhROC04m23f5V7hXGjNdl2tF8NSu06y3WfQcKB1jvcw3veJWjzPCSKu+2kWkaSy2p3cIVdx2hpU+K836p4wQibaPm3a3R/ZTx6jEbMIcNIVPDVPKjiq5R3n/lngGlhEhsbdkaM+uKYnNIhd1Ta0ekE2G7SaCE6bzlAGiL0OIh5ofGOD65m1+evgUXkUro8ioguMvoe8Sak9+hA1ORygQ+2pYYGnGIWab5saFcoNo5unM5Sct4zIHlwjpbqJV4skM6HIqITdNn8sdW9MCiqeDKmZuITbKZSpPVhaqoQSRb6qwte/4Lq3lGFw4tIxGdD7gcvjuj8/VYiczhqAg++3AwTwnrryekPKqEnNboI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB1E6E1CDB96154BB1614EDC752E9FF1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db6d13e-0521-4141-d7c6-08d8290e4366
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 22:27:30.8980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: edeTu0JaHAo0IIWy/wYG+gh2gqD0QDHzXg3PylvWZvhiJtj/T0bFTB+oKcaJhFAT2DvXWercsFZ3msv9kxJ/Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4584
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMTUsIDIwMjAsIGF0IDM6MjEgUE0sIEtyaXNoIFNhZGh1a2hhbiA8a3Jpc2guc2Fk
aHVraGFuQG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IE9uIDcvMTMvMjAgNDozMCBQTSwg
TmFkYXYgQW1pdCB3cm90ZToNCj4+PiBPbiBKdWwgMTMsIDIwMjAsIGF0IDQ6MTcgUE0sIEtyaXNo
IFNhZGh1a2hhbiA8a3Jpc2guc2FkaHVraGFuQG9yYWNsZS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+
IA0KDQpbc25pcF0NCg0KPj4+IEkgYW0ganVzdCBzYXlpbmcgdGhhdCB0aGUgQVBNIGxhbmd1YWdl
ICJzaG91bGQgYmUgY2xlYXJlZCB0byAwIiBpcyBtaXNsZWFkaW5nIGlmIHRoZSBwcm9jZXNzb3Ig
ZG9lc24ndCBlbmZvcmNlIGl0Lg0KPj4gSnVzdCB0byBlbnN1cmUgSSBhbSBjbGVhciAtIEkgYW0g
bm90IGJsYW1pbmcgeW91IGluIGFueSB3YXkuIEkgYWxzbyBmb3VuZA0KPj4gdGhlIHBocmFzaW5n
IGNvbmZ1c2luZy4NCj4+IA0KPj4gSGF2aW5nIHNhaWQgdGhhdCwgaWYgeW91IChvciBhbnlvbmUg
ZWxzZSkgcmVpbnRyb2R1Y2VzIOKAnHBvc2l0aXZl4oCdIHRlc3RzLCBpbg0KPj4gd2hpY2ggdGhl
IFZNIENSMyBpcyBtb2RpZmllZCB0byBlbnN1cmUgVk0tZW50cnkgc3VjY2VlZHMgd2hlbiB0aGUg
cmVzZXJ2ZWQNCj4+IG5vbi1NQlogYml0cyBhcmUgc2V0LCBwbGVhc2UgZW5zdXJlIHRoZSB0ZXN0
cyBmYWlscyBncmFjZWZ1bGx5LiBUaGUNCj4+IG5vbi1sb25nLW1vZGUgQ1IzIHRlc3RzIGNyYXNo
ZWQgc2luY2UgdGhlIFZNIHBhZ2UtdGFibGVzIHdlcmUgaW5jb21wYXRpYmxlDQo+PiB3aXRoIHRo
ZSBwYWdpbmcgbW9kZS4NCj4+IA0KPj4gSW4gb3RoZXIgd29yZHMsIGluc3RlYWQgb2Ygc2V0dGlu
ZyBhIFZNTUNBTEwgaW5zdHJ1Y3Rpb24gaW4gdGhlIFZNIHRvIHRyYXANCj4+IGltbWVkaWF0ZWx5
IGFmdGVyIGVudHJ5LCBjb25zaWRlciBjbGVhcmluZyB0aGUgcHJlc2VudC1iaXRzIGluIHRoZSBo
aWdoDQo+PiBsZXZlbHMgb2YgdGhlIE5QVDsgb3IgaW5qZWN0aW5nIHNvbWUgZXhjZXB0aW9uIHRo
YXQgd291bGQgdHJpZ2dlciBleGl0DQo+PiBkdXJpbmcgdmVjdG9yaW5nIG9yIHNvbWV0aGluZyBs
aWtlIHRoYXQuDQo+PiANCj4+IFAuUy46IElmIGl0IHdhc27igJl0IGNsZWFyLCBJIGFtIG5vdCBn
b2luZyB0byBmaXggS1ZNIGl0c2VsZiBmb3Igc29tZSBvYnZpb3VzDQo+PiByZWFzb25zLg0KPiBJ
IHRoaW5rIHNpbmNlIHRoZSBBUE0gaXMgbm90IGNsZWFyLCByZS1hZGRpbmcgYW55IHRlc3QgdGhh
dCB0ZXN0cyB0aG9zZSBiaXRzLCBpcyBsaWtlIGFkZGluZyBhIHRlc3Qgd2l0aCAidW5kZWZpbmVk
IGJlaGF2aW9yIiB0byBtZS4NCj4gDQo+IA0KPiBQYW9sbywgU2hvdWxkIEkgc2VuZCBhIEtWTSBw
YXRjaCB0byByZW1vdmUgY2hlY2tzIGZvciB0aG9zZSBub24tTUJaIHJlc2VydmVkIGJpdHMgPw0K
DQpXaGljaCBub24tTUJaIHJlc2VydmVkIGJpdHMgKG90aGVyIHRoYW4gdGhvc2UgdGhhdCBJIGFk
ZHJlc3NlZCkgZG8geW91IHJlZmVyDQp0bz8NCg0K
