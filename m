Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91B6CAA47
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 19:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405084AbfJCRCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 13:02:50 -0400
Received: from mail-eopbgr130092.outbound.protection.outlook.com ([40.107.13.92]:8462
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392639AbfJCQmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFzSPorRAvvOlvGxiFIiWCx2fBtaHNlP3GwPFDQcPfqwBboG3TW8HrA4kF7XumjfU0e2lBnWHqYv/9IkEh2cgRQ3uJsYxM2IO/gz25bU0IoQQuBFt85RhULQmBX9OIZk1ywy9D8V0sjzVnfp54CkE8zU57+cjjUxsrY8fXYkEGqwkv6rTnJXUKD34Jbs2wh182Op+N+zZio+G2FEjgD09CWID8O/aBiB1PzgFssIAZiUmA5A0shdQj5/D9h+8afkZJRO8sInyhRu9NQ0ofaB1BOwSH/yyFYhpz6JO8EO3vw1X0WWvzct59vymK4603ZOhJ56VjpVPQTAphjrG6Hkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNKMtF5y1qEruoDewNhbwhIw6yjbZUzml52GDFtgBhs=;
 b=hdeMMkvxb9cZovkJHybUvy/FuGAscPk5spkqcQLtLK6IhT38f1pZQtknh+sx2wnqV4fdaOUX+DMUG0QHO7UUXNnv0mHRYpiAOJHa0+Jn4573F1rmJXykmH4VYbc+nmJZSKSO5NBRB4oZcuCcmEH4wZAZRXwcOVVgoWuebOj3R4kl7lHyHwBXmhbhYNdE6ZDuZwvTQMlkWhuqzZMu7+x2ulUA5cwvs8kiheWBsHRioDwTCA0/eXVh3d3lDoadfuvYIY3ViMUgAy6A45yQ0wqToGUnMo4vVJsCqTD1lkY/mZE3H7vooyZ4MaIQYE5EWFfG1oAtwaV1AVwGdd3DgH5U8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bitdefender.com; dmarc=pass action=none
 header.from=bitdefender.com; dkim=pass header.d=bitdefender.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bitdefender.onmicrosoft.com; s=selector2-bitdefender-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNKMtF5y1qEruoDewNhbwhIw6yjbZUzml52GDFtgBhs=;
 b=P1aXmOGCm3PkBIRShdOQRQpvexya6KX1zhwTF/h7CBpRAq+7HVTrxzPqG08Dt9unRxJo9hYRQzpBcLLW/HGMFZ55T8U1OwTxDqQJ1KWujmzaol3W4hEv3REFdh4ycJTkD5yCZ6o/mmx5kcEtGuaxf5tLAkeiyJDZFnD66GIfJ/k=
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com (20.177.121.157) by
 DB7PR02MB4855.eurprd02.prod.outlook.com (20.177.123.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 3 Oct 2019 16:42:21 +0000
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7]) by DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 16:42:20 +0000
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
Thread-Index: AQHVTs8soTQpQXiOD0KEAgMKguVJzKb471OAgAOvxoCAAA/uAIAMAODggBTcuICABjXSgIAA6j0wgCNkfQD//6DNAIAACCgAgAAiMwCAAAz2gIAAM+oAgAFHhoCAAAJQgIAADPFw
Date:   Thu, 3 Oct 2019 16:42:20 +0000
Message-ID: <DB7PR02MB39796440DC81A5B53E86F029BB9F0@DB7PR02MB3979.eurprd02.prod.outlook.com>
References: <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
 <20191002170429.GA8189@redhat.com>
 <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
 <20191003154233.GA4421@redhat.com>
 <d62a6720-e069-4e03-6a3a-798c020786f7@redhat.com>
In-Reply-To: <d62a6720-e069-4e03-6a3a-798c020786f7@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mcirjaliu@bitdefender.com; 
x-originating-ip: [78.96.218.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c56ed2c9-aa40-41bb-17c9-08d74820a91c
x-ms-traffictypediagnostic: DB7PR02MB4855:|DB7PR02MB4855:|DB7PR02MB4855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR02MB4855C4EF49C897EB1AD2D0D5BB9F0@DB7PR02MB4855.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(346002)(366004)(136003)(199004)(189003)(305945005)(478600001)(99286004)(9686003)(55016002)(81156014)(4326008)(8676002)(6116002)(81166006)(110136005)(6436002)(476003)(25786009)(66946007)(316002)(64756008)(66476007)(3846002)(229853002)(66556008)(107886003)(26005)(76116006)(54906003)(7416002)(7736002)(486006)(74316002)(11346002)(66446008)(446003)(6246003)(6506007)(52536014)(2906002)(7696005)(66066001)(102836004)(33656002)(14454004)(8936002)(256004)(186003)(5660300002)(76176011)(4744005)(71190400001)(53546011)(71200400001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DB7PR02MB4855;H:DB7PR02MB3979.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bitdefender.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4JXsJOjWe9djBUfwv/Qw7as0GElN16lgvwdrpdUoSySI/b7Ngwbfvihu85j4ALP0vGRC6ffY7NjoErsqaK41wI4ONaGBuib/vmlO2jdJglq5phl+GaJ3sMTgt7agSb2ZaxmA57rM7eYLI9kyiLRhybk6OpZyNFJ1P1RBjYhZNxfcDtZZkFQrW9YpmpFSKVw30G7nNDU1RGGN/L0dSHX+CJWt+4WhWLmDgA5No8Bay185hBO3gdIuTwjExTutO9XWd4JVlEFpqqDDT7KI7q6V1JZIwg0dIwsruUnOjuEIXQq73pvm4Waf49hDQz9m/rnyTdaAGDc2xlH4qAeCe9hkjxG2Iof1umDRdFGtzZsKt4lcOzAmZrg11e2cnT1JDVySg/S6AWqcuEnNdLJ5SOP10BDqm1rQw7jytzplA6d4I58=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bitdefender.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c56ed2c9-aa40-41bb-17c9-08d74820a91c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 16:42:20.9178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 487baf29-f1da-469a-9221-243f830c36f3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5AW25gtZ5IhDby2KbfB/04alyblDfGhLdN0ExasfkWR5S2lcyg9WDjvT48ZT2mR7yLrLQ0/N34LQh90CCImuS7TYQmucwbuQcsL8etknEcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR02MB4855
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAwMy8xMC8xOSAxNzo0MiwgSmVyb21lIEdsaXNzZSB3cm90ZToNCj4gPiBBbGwgdGhhdCBp
cyBuZWVkZWQgaXMgdG8gbWFrZSBzdXJlIHRoYXQgdm1fbm9ybWFsX3BhZ2UoKSB3aWxsIHNlZQ0K
PiA+IHRob3NlIHB0ZSAoaW5zaWRlIHRoZSBwcm9jZXNzIHRoYXQgaXMgbWlycm9yaW5nIHRoZSBv
dGhlciBwcm9jZXNzKSBhcw0KPiA+IHNwZWNpYWwgd2hpY2ggaXMgdGhlIGNhc2UgZWl0aGVyIGJl
Y2F1c2UgaW5zZXJ0X3BmbigpIG1hcmsgdGhlIHB0ZSBhcw0KPiA+IHNwZWNpYWwgb3IgdGhlIGt2
bSBkZXZpY2UgZHJpdmVyIHdoaWNoIGNvbnRyb2wgdGhlIHZtX29wZXJhdGlvbiBzdHJ1Y3QNCj4g
PiBzZXQgYQ0KPiA+IGZpbmRfc3BlY2lhbF9wYWdlKCkgY2FsbGJhY2sgdGhhdCBhbHdheXMgcmV0
dXJuIE5VTEwsIG9yIHRoZSB2bWEgaGFzDQo+ID4gZWl0aGVyIFZNX1BGTk1BUCBvciBWTV9NSVhF
RE1BUCBzZXQgKHdoaWNoIGlzIHRoZSBjYXNlIHdpdGgNCj4gaW5zZXJ0X3BmbikuDQo+ID4NCj4g
PiBTbyB5b3UgY2FuIGtlZXAgdGhlIGV4aXN0aW5nIGt2bSBjb2RlIHVubW9kaWZpZWQuDQo+IA0K
PiBHcmVhdCwgdGhhbmtzLiAgQW5kIEtWTSBpcyBhbHJlYWR5IGFibGUgdG8gaGFuZGxlDQo+IFZN
X1BGTk1BUC9WTV9NSVhFRE1BUCwgc28gdGhhdCBzaG91bGQgd29yay4NCg0KVGhpcyBtZWFucyBz
ZXR0aW5nIFZNX1BGTk1BUC9WTV9NSVhFRE1BUCBvbiB0aGUgYW5vbiBWTUEgdGhhdCBhY3RzIGFz
IHRoZSBWTSdzIHN5c3RlbSBSQU0uDQpXaWxsIGl0IGhhdmUgYW55IHNpZGUgZWZmZWN0cz8NCg==
