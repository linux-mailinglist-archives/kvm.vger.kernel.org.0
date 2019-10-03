Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD37CA5C2
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 18:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404395AbfJCQg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 12:36:26 -0400
Received: from mail-eopbgr30112.outbound.protection.outlook.com ([40.107.3.112]:23427
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392204AbfJCQgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eO/aigaA5UofP6PE3kwPxvXDl9AgcvFOvQyTJxG5lvF8ee8KjFyi0G6Oeuo+w7hjve3JCXtK7/4mMAm9AOYr3desxhUOKpDr5Qtkn/9gM4MRAmw6aVOZaFPHGh1g2K8Zyrkj7vTez7Qxl65k9ynXYWsVNXXN713jE6VIixaqcOVpxOq0ky98YTID/iM1uhN5lroU0OKdMzqFbj9Deg/8AK4VkGyN2fkHES2sBHdRiGVs9zZFiEMX+OZUfK/xPwchYdIrw4v2Wf3zP0+1DnpngAnPh2rqMO2POmzWCNj4ztJF2bAbok5zzy52QP9dWd6Ij+9dYPppVzzX3kEdS5qGcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6zeDulSh4NAlkTfpbrry7v0xeODngF/Lv8EN5radYM=;
 b=UiPpq4nJXj8ePMf1aA7T0PgJKT8uQpaPy1+XawejEQwm62OVtg7sCoSuYPfpNxvNggH6q3M2iHa1EfaidkY0/E6Olu6gbYBeACcyP3QSJf1RCgwwJtiMT7EP+yydbls95ygO1D/3eEs1DtA/if0eH9eBU78yLyJAUkSyor8AELnSyQTO5l+7xnUUc62e+rL3vZLrrk45RVyv8ik9U26IJhK+pXclWfI4cN1TCWY4vaN86G9GlEyG+QRyyILltQY8mxdDcXldnaWyX2fxOlZKDqj6mR2FUckOSovHZtK2x+90uE9gYjZn8jlPATkGIQwzM9GMCYY2NfqUNTU93vLNBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bitdefender.com; dmarc=pass action=none
 header.from=bitdefender.com; dkim=pass header.d=bitdefender.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bitdefender.onmicrosoft.com; s=selector2-bitdefender-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6zeDulSh4NAlkTfpbrry7v0xeODngF/Lv8EN5radYM=;
 b=GVuNy0VsqeslbkN0N5Jis4e9gvNsg3wmzdiXBMMqXzqhTb1lVLdR66auzDWmTvqzdd/AqVynD0UIhRA0BGTN5cSHUkKIFhGf1Axss14wS7ib/MpYC6a5SPO4lpddFM3v6ZJwXDT9hfzdbnoet+WAAUYv7ViNpp6z53CFEunhSbs=
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com (20.177.121.157) by
 DB7PR02MB4585.eurprd02.prod.outlook.com (20.178.40.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 16:36:22 +0000
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7]) by DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 16:36:21 +0000
From:   Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>
CC:     =?utf-8?B?QWRhbGJlcnQgTGF6xINy?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?utf-8?B?U2FtdWVsIExhdXLDqW4=?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?utf-8?B?TWloYWkgRG9uyJt1?= <mdontu@bitdefender.com>
Subject: RE: DANGER WILL ROBINSON, DANGER
Thread-Topic: DANGER WILL ROBINSON, DANGER
Thread-Index: AQHVTs8soTQpQXiOD0KEAgMKguVJzKb471OAgAOvxoCAAA/uAIAMAODggBTcuICABjXSgIAA6j0wgCNkfQD//6DNAIAACCgAgAAiMwCAAAz2gIAAM+oAgAFV0tA=
Date:   Thu, 3 Oct 2019 16:36:21 +0000
Message-ID: <DB7PR02MB39790CDAB115CA5E91878A0EBB9F0@DB7PR02MB3979.eurprd02.prod.outlook.com>
References: <20190815191929.GA9253@redhat.com>
 <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
 <20191002170429.GA8189@redhat.com>
 <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
In-Reply-To: <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mcirjaliu@bitdefender.com; 
x-originating-ip: [78.96.218.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01cbf1d5-9fca-4025-3e8a-08d7481fd31f
x-ms-traffictypediagnostic: DB7PR02MB4585:|DB7PR02MB4585:|DB7PR02MB4585:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR02MB4585343BC8065A3851701770BB9F0@DB7PR02MB4585.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(66946007)(110136005)(54906003)(4326008)(107886003)(6246003)(7736002)(476003)(64756008)(66446008)(66556008)(66476007)(99286004)(9686003)(305945005)(66066001)(4744005)(55016002)(6436002)(52536014)(229853002)(7416002)(5660300002)(25786009)(71190400001)(71200400001)(8676002)(26005)(256004)(102836004)(3846002)(486006)(86362001)(2906002)(33656002)(11346002)(7696005)(316002)(76176011)(6116002)(6506007)(478600001)(14454004)(76116006)(8936002)(74316002)(81156014)(81166006)(186003)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB7PR02MB4585;H:DB7PR02MB3979.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bitdefender.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DW5NSt/UCiODea+4tQIKj4GOByJle5TVwT4J9mCqIvN082f1fJC7dlOUvngnVtW42pscUyPm084jeByLywj3YU/UpfyaQXcyHubzpVoKQYwwdFRuieovA3OVWykLr5qYXiC+kcnVk0aIrbicxR2JQQ+1l/DMhy6Kps+ic+OKQseqihUI0o2dHO64pfd0xE4fuMlHPg2kkXFC10f3JQm5u0yp5TJ3yd2QtL1CGwr9LtDNHZvOU7u3zOmBoPyhf/ZG7/O6KWlhvchhnNiq1pUNWBv+FAU5yzFxn3tdrNglK4+QxfncDnFgbe1r90M1/nN9Sf+XiUb662FeKkW/F76MA1GUqqUfV3j2FUW/ApXupDhujSCwaUihrznk/RiqJWUKrYp9OZREi42Lg2FeYG2WI8lEP+FRQgsv7Esrt5EK9gc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bitdefender.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01cbf1d5-9fca-4025-3e8a-08d7481fd31f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 16:36:21.8961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 487baf29-f1da-469a-9221-243f830c36f3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pglZ4EVrSll7DipaSx24dMo4o7wsH8vY9UUPmaJMAa1mPOWJ/BCMEpPtUipNFpCM1i7d5YDRDO+SzuluwezrzjDKyFBkiSUvGS7kal4KcYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR02MB4585
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBUaGUgS1ZNIE1NVSBub3RpZmllciBleGlzdHMgc28gdGhhdCBub3RoaW5nIChpbmNsdWRpbmcg
bWlycm9yaW5nKSBuZWVkcyB0bw0KPiBrbm93IHRoYXQgdGhlcmUgaXMgS1ZNIG9uIHRoZSBvdGhl
ciBzaWRlLiAgQW55IGludGVyYWN0aW9uIGJldHdlZW4gS1ZNDQo+IHBhZ2UgdGFibGVzIGFuZCBW
TUFzIG11c3QgYmUgbWVkaWF0ZWQgYnkgTU1VIG5vdGlmaWVycywgYW55dGhpbmcgZWxzZSBpcw0K
PiB1bmFjY2VwdGFibGUuDQo+IA0KPiBJZiBpdCBpcyBwb3NzaWJsZSB0byBpbnZva2UgdGhlIE1N
VSBub3RpZmllcnMgYXJvdW5kIHRoZSBjYWxscyB0byBpbnNlcnRfcGZuLA0KPiB0aGF0IG9mIGNv
dXJzZSB3b3VsZCBiZSBwZXJmZWN0Lg0KDQpMb29rcyB0byBtZSBsaWtlIGEgd29yay1hcm91bmQu
DQpBbnkgcmVhc29uIHdoeSBpbnNlcnRfcGZuKCkgY2FuJ3QgZG8gc2V0X3B0ZV9hdF9ub3RpZnko
KSBzbyBpdCB0cmlnZ2VycyB0aGUgS1ZNIE1NVSBub3RpZmllciBpbnN0ZWFkPw0K
