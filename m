Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4F4A417
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 16:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfFROer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 10:34:47 -0400
Received: from mail-eopbgr760049.outbound.protection.outlook.com ([40.107.76.49]:51919
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729078AbfFROeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 10:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oswDUruvvq1JYnLIZg0WhwkiSrV1N/gfPxD0uked6M4=;
 b=pplzPhSr5bHzMzZ2EQxQWW6NKdur3Jp3wuvK3wWeR516DF+8VzELEQhOxXqNJrDArFEOSI0QlnmE+EKAg7KfONBrtnz68HS0/3o6LHaDQxdNpyo68HrBqlMhhy4qVUxnq8l6ULSBZF2sYdXngSuLNxmMGJE3LcMkvjKjL7kYWUs=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3738.namprd12.prod.outlook.com (10.255.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Tue, 18 Jun 2019 14:34:42 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::9b0:ee82:ca4b:a4e7]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::9b0:ee82:ca4b:a4e7%6]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 14:34:42 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jsteckli@amazon.de" <jsteckli@amazon.de>,
        "sironi@amazon.de" <sironi@amazon.de>,
        "wawei@amazon.de" <wawei@amazon.de>
Subject: Re: [RFC PATCH 8/8] svm: Allow AVIC with in-kernel irqchip mode
Thread-Topic: [RFC PATCH 8/8] svm: Allow AVIC with in-kernel irqchip mode
Thread-Index: AQHUvJfczoXgq9UCxES9CxFgBN3rJ6XRiY0AgAEZS4CAyvFEAIAEuJ4A
Date:   Tue, 18 Jun 2019 14:34:42 +0000
Message-ID: <200952f3-d09d-222f-7d07-99335f18b9da@amd.com>
References: <20190204144128.9489-1-suravee.suthikulpanit@amd.com>
 <20190204144128.9489-9-suravee.suthikulpanit@amd.com>
 <20190205113404.5c5382e6@w520.home>
 <d57a0843-061a-231a-9d50-d7e4d4d05d73@amd.com>
 <1d80a586342dfee0479db96a4457f7023b0260a9.camel@redhat.com>
In-Reply-To: <1d80a586342dfee0479db96a4457f7023b0260a9.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-originating-ip: [165.204.77.11]
x-clientproxiedby: DM6PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:5:60::36) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b20757d-7c65-402e-03af-08d6f3fa19e5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3738;
x-ms-traffictypediagnostic: DM6PR12MB3738:
x-microsoft-antispam-prvs: <DM6PR12MB37388A779D4F586A2062BB69F3EA0@DM6PR12MB3738.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(376002)(136003)(346002)(199004)(189003)(446003)(68736007)(186003)(478600001)(14444005)(31696002)(71190400001)(81156014)(11346002)(81166006)(71200400001)(305945005)(14454004)(7736002)(5660300002)(229853002)(66446008)(64756008)(2616005)(65826007)(6506007)(256004)(66556008)(66476007)(73956011)(86362001)(31686004)(6246003)(476003)(25786009)(6436002)(6512007)(6486002)(66946007)(72206003)(4326008)(7416002)(54906003)(102836004)(316002)(58126008)(53936002)(486006)(65806001)(26005)(76176011)(99286004)(386003)(53546011)(8676002)(52116002)(36756003)(6116002)(3846002)(66066001)(65956001)(110136005)(2906002)(8936002)(64126003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3738;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nhWyW5NapoyaLMQskiP+BUqeY3NpY6iGt+ricd3HgWfms6Lb/cVpkYLS41hmQOaX2Iy0sEPiBSroTwM2yxnoBA4EGlDiQKH6pnhmqtH6m5ZfAUOnfKWTD6NHHY0gvOCVSLm2fYnUzB1pTSO4FWmUWeTsjs1s6OqxwbqmXxC8WUjGl6qBhZhBVrgBHuQShw7cr3hfAK3iohOjlldKIYCJQH15/t9UQC9/m1UJ1oZ87MU7LrRx2g6JBVdhQeQ43luwGS15mVLc6R4pWbDf+QfibvAgTuKK6NraCmpg3LfXnC0ftb2XDdUDJ3Znon4QkO/5+XjVEQiUTQWxdSj8SFL30U0DjhhUF8ZSBkDK2z8bpGCN7kb8qAIpL1a+A4zwcc5ROnQ8CfRpllmXk7bJz4Va3fPdavV/K4z8fAaHTnN0PNg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92116DF47B673844B3DA53C40D5D1E9A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b20757d-7c65-402e-03af-08d6f3fa19e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 14:34:42.3825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssuthiku@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3738
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksDQoNCk9uIDYvMTUvMTkgOToyOCBBTSwgTWF4aW0gTGV2aXRza3kgd3JvdGU6DQo+IE9uIFdl
ZCwgMjAxOS0wMi0wNiBhdCAxMToyMCArMDAwMCwgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90
ZToNCj4+IEFsZXgsDQo+Pg0KPj4gT24gMi82LzE5IDE6MzQgQU0sIEFsZXggV2lsbGlhbXNvbiB3
cm90ZToNCj4+PiBPbiBNb24sIDQgRmViIDIwMTkgMTQ6NDI6MzIgKzAwMDANCj4+PiAiU3V0aGlr
dWxwYW5pdCwgU3VyYXZlZSI8U3VyYXZlZS5TdXRoaWt1bHBhbml0QGFtZC5jb20+ICB3cm90ZToN
Cj4+Pg0KPj4+PiBPbmNlIHRoZSBJUlEgYWNrIG5vdGlmaWVyIGZvciBpbi1rZXJuZWwgUElUIGlz
IG5vIGxvbmdlciByZXF1aXJlZA0KPj4+PiBhbmQgcnVuLXRpbWUgQVZJQyBhY3RpdmF0ZS9kZWFj
dGl2YXRlIGlzIHN1cHBvcnRlZCwgd2UgY2FuIHJlbW92ZQ0KPj4+PiB0aGUga2VybmVsIGlycWNo
aXAgc3BsaXQgbW9kZSByZXF1aXJlbWVudCBmb3IgQVZJQy4NCj4+Pj4NCj4+Pj4gSGVuY2UsIHJl
bW92ZSB0aGUgY2hlY2sgZm9yIGlycWNoaXAgc3BsaXQgbW9kZSB3aGVuIGVuYWJsaW5nIEFWSUMu
DQo+Pj4NCj4+PiBZYXkhICBDb3VsZCB3ZSBhbHNvIGF0IHRoaXMgcG9pbnQgbWFrZSBhdmljIGVu
YWJsZWQgYnkgZGVmYXVsdCBvciBhcmUNCj4+PiB0aGVyZSByZW1haW5pbmcgaW5jb21wYXRpYmls
aXRpZXM/ICBUaGFua3MsDQo+Pg0KPj4gSSdtIGxvb2tpbmcgaW50byB0aGF0IG5leHQuIEkgd291
bGQgbmVlZCB0byBlbnN1cmUgdGhhdCBlbmFibGluZw0KPj4gQVZJQyB3b3VsZCBub3QgY2F1c2Ug
aXNzdWVzIHdpdGggb3RoZXIgZmVhdHVyZXMuDQo+Pg0KPj4gU3VyYXZlZQ0KPiANCj4gSGkhDQo+
IA0KPiBEbyB5b3UgaGF2ZSBhbnkgdXBkYXRlIG9uIHRoZSBzdGF0ZSBvZiB0aGlzIHBhdGNoPw0K
PiBJIGtpbmQgb2Ygc3R1bWJsZWQgb24gaXQgYWNjaWRlbnRseSwgd2hpbGUNCj4gdHJ5aW5nIHRv
IHVuZGVyc3RhbmQgd2h5IEFWSUMgaXMgb25seSBlbmFibGVkIGluIHRoZSBzcGxpdCBpcnFjaGlw
IG1vZGUuDQoNCkknbSBzdGlsbCB3b3JraW5nIG9uIHRoaXMgYW5kIHRlc3RpbmcgdGhlIHNlcmll
cy4NCkknbGwgcG9zdCB0aGlzIHNvb24uDQoNClRoYW5rcywNClN1cmF2ZWUNCg0KPiBCZXN0IHJl
Z2FyZHMsDQo+IAlNYXhpbSBMZXZpdHNreQ0KPiANCg0K
