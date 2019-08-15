Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44A38E4ED
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 08:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbfHOGgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 02:36:51 -0400
Received: from mail-eopbgr10122.outbound.protection.outlook.com ([40.107.1.122]:31029
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfHOGgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 02:36:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6Wn9lTQ32wrvHkUVE2ezkt0wSxk+kTgm42IhndIQ8p8gxBFRUK/58NyqMDcf0j99XpNEimsLFuZuiakn9dikdcQkcGJxRcOumTGiecWmGXUF+2B64Owt723nat9QzbVJpBm0YQPWnGwUqfpL6wKOFEK7akUnROy56TPfa48hJkA+5zJ68xcKZpvAwUMtb7tHMx+GY3jjH7xRQjvnYLgl8cxVZfHjb1nJ0eLmY0d/rNl5EedjzRIidjZRV+lpyozpsY5SrgZaAXYfcFtoocEYeicfq6/LmGs1vjoLlHPi4GpG5kL6ShtasoLfH1wTuIZymbl12Jg36VK0MCAHrcYzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx8QVkD/qi9QX4eCCnho7dDHBQ5qPQVXHoWyhmdYRJo=;
 b=dMX+4ZtfrUOtcr3ajG6f1QcDBn4ULOTTBUXI7xnkfuf+Corn2jJWhZflXVCzyJ0DihPCkrk6PceqNW3v5OxgiAXoAj29UfvVrSxuWDRt7NqcNzh2+s+7ZuMJ+SiKbLzlblWwHKSpdxrTWpY5jukcBLTehA9Aixq5anafE9X6BW0pV005C20Y0k/bplFv6MhNxWJbcsWY8H6IgbouQMg/H0yyIQOenW8q+udiwHb7kNrzOJJ4wI0dgoMgyFRKxcf2h0rNjm7ER+euX4ADHI0w7IKjs3KOUWhBGtXDgh2walXf32AWkxxcQCkINnKtO9H5oWOaT/jVmP/daYOBPdnSGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bitdefender.com; dmarc=pass action=none
 header.from=bitdefender.com; dkim=pass header.d=bitdefender.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bitdefender.onmicrosoft.com; s=selector2-bitdefender-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx8QVkD/qi9QX4eCCnho7dDHBQ5qPQVXHoWyhmdYRJo=;
 b=BHwv5Ww1Fas0As2eRy/DfetioOGXYLogA84rcHEz1xK+X5mrVWihd8Y4m/eracPpzCFps3mLNSkqKb1lhfR+Y/DuEsl14KE01ZbWbgxzylB52+ekbDltU+0EFH4edH6HSunO0zcSIKdCKr2+XnXyoJUzqExWVzX/jUmOj/hXDZ4=
Received: from HE1PR0201MB2060.eurprd02.prod.outlook.com (10.168.30.152) by
 HE1PR0201MB2124.eurprd02.prod.outlook.com (10.168.33.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 15 Aug 2019 06:36:45 +0000
Received: from HE1PR0201MB2060.eurprd02.prod.outlook.com
 ([fe80::c022:dbbc:4d4d:a558]) by HE1PR0201MB2060.eurprd02.prod.outlook.com
 ([fe80::c022:dbbc:4d4d:a558%3]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 06:36:45 +0000
From:   Nicusor CITU <ncitu@bitdefender.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?QWRhbGJlcnQgTGF6xINy?= <alazar@bitdefender.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?utf-8?B?U2FtdWVsIExhdXLDqW4=?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "Zhang@vger.kernel.org" <Zhang@vger.kernel.org>,
        Yu C <yu.c.zhang@intel.com>,
        =?utf-8?B?TWloYWkgRG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR and
 KVMI_EVENT_MSR
Thread-Topic: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR
 and KVMI_EVENT_MSR
Thread-Index: AQHVTs3TkKC1NudCY0uglRHlOs1VpKb4BZqAgAPEYIA=
Date:   Thu, 15 Aug 2019 06:36:44 +0000
Message-ID: <f9e94e9649f072911cc20129c2b633747d5c1df5.camel@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
         <20190809160047.8319-56-alazar@bitdefender.com>
         <20190812210501.GD1437@linux.intel.com>
In-Reply-To: <20190812210501.GD1437@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0172.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::16) To HE1PR0201MB2060.eurprd02.prod.outlook.com
 (2603:10a6:3:20::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ncitu@bitdefender.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-originating-ip: [91.199.104.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c04c88a1-b6fe-424d-4fd9-08d7214af053
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:HE1PR0201MB2124;
x-ms-traffictypediagnostic: HE1PR0201MB2124:|HE1PR0201MB2124:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0201MB212489B6037337D9D95D9C30B0AC0@HE1PR0201MB2124.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(366004)(346002)(136003)(199004)(189003)(186003)(3846002)(316002)(118296001)(66066001)(110136005)(50226002)(6116002)(2906002)(71190400001)(71200400001)(26005)(7736002)(305945005)(8676002)(5660300002)(54906003)(81156014)(7416002)(66946007)(386003)(6506007)(6246003)(478600001)(102836004)(36756003)(6636002)(2616005)(4326008)(14454004)(81166006)(14444005)(256004)(25786009)(11346002)(8936002)(76176011)(6486002)(107886003)(446003)(64756008)(66556008)(66476007)(86362001)(66446008)(6436002)(99286004)(53936002)(6512007)(476003)(486006)(52116002)(229853002)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0201MB2124;H:HE1PR0201MB2060.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bitdefender.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EnYgUxX6im+reQZd2aqIpkcrcjXPeS7ID1fU9UfUQBMyMAVapPix7Gnv+lGpI2UNCYUQvdjR0oT0Ar5jRasMimv+yL+4aJZOLksFr+Dt5f4DW2p96OIW1EYf65wGE07RfYtvSxAbTlXKx5l7vHpBW8Kowkua0mQgnWB8w9Nkj0tkyxpOVv6Z7BrXB6UPP3c2UEUOjf7RQi7vhT1nyx4aNmx09KDy7K4P+1Wg6EFZVA9pFs+xJs+Nxy9j5T12LE1OTuZZQzOg7Q/3yu+lWYu6QMNhbXHUAe/Kl4Qz0FTDTz6OhoijLQcQjlYON29HqXNiH1ya7Uco4wrEE6x3qsiWLJ2P2No/Nu9pq/jTo+n7TINx89YzCjMI+GL9FKVRrMXSaaLJ25idrN9qm5xHougdcQUBWK5oLrGwLmOZXV4zJYQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <384E0263AC0C0D4CAC1D930739969FF0@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bitdefender.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c04c88a1-b6fe-424d-4fd9-08d7214af053
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 06:36:45.0757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 487baf29-f1da-469a-9221-243f830c36f3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yYICgNa5QNoG5Jgovxnh67dpAG9Wm3xSNa9bsgjjwn2H4Iy40vYaBzU8CjU+tQZySGWXf/T72qcggelYNAUrlNcCEt9BE2IUuM117XvT2zE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0201MB2124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICsJdm9pZCAoKm1zcl9pbnRlcmNlcHQpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWdu
ZWQgaW50IG1zciwNCj4gPiArCQkJCWJvb2wgZW5hYmxlKTsNCj4gDQo+IFRoaXMgc2hvdWxkIGJl
IHRvZ2dsZV93cm1zcl9pbnRlcmNlcHQoKSwgb3IgdG9nZ2xlX21zcl9pbnRlcmNlcHQoKQ0KPiB3
aXRoIGEgcGFyYW10ZXIgdG8gY29udHJvbCBSRE1TUiB2cy4gV1JNU1IuDQoNCk9rLCBJIGNhbiBk
byB0aGF0Lg0KDQoNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2Fy
Y2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiBpbmRleCA2NDUwYzhjNDQ3NzEuLjAzMDZjN2VmMzE1
OCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gKysrIGIvYXJj
aC94ODYva3ZtL3ZteC92bXguYw0KPiA+IEBAIC03Nzg0LDYgKzc3ODQsMTUgQEAgc3RhdGljIF9f
ZXhpdCB2b2lkIGhhcmR3YXJlX3Vuc2V0dXAodm9pZCkNCj4gPiAgCWZyZWVfa3ZtX2FyZWEoKTsN
Cj4gPiAgfQ0KPiA+ICANCj4gPiArc3RhdGljIHZvaWQgdm14X21zcl9pbnRlcmNlcHQoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBpbnQNCj4gPiBtc3IsDQo+ID4gKwkJCSAgICAgIGJv
b2wgZW5hYmxlKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmNwdV92bXggKnZteCA9IHRvX3ZteCh2
Y3B1KTsNCj4gPiArCXVuc2lnbmVkIGxvbmcgKm1zcl9iaXRtYXAgPSB2bXgtPnZtY3MwMS5tc3Jf
Yml0bWFwOw0KPiA+ICsNCj4gPiArCXZteF9zZXRfaW50ZXJjZXB0X2Zvcl9tc3IobXNyX2JpdG1h
cCwgbXNyLCBNU1JfVFlQRV9XLCBlbmFibGUpOw0KPiA+ICt9DQo+IA0KPiBVbmxlc3MgSSBvdmVy
bG9va2VkIGEgY2hlY2ssIHRoaXMgd2lsbCBhbGxvdyB1c2Vyc3BhY2UgdG8gZGlzYWJsZQ0KPiBX
Uk1TUiBpbnRlcmNlcHRpb24gZm9yIGFueSBNU1IgaW4gdGhlIGFib3ZlIHJhbmdlLCBpLmUuIHVz
ZXJzcGFjZSBjYW4NCj4gdXNlIEtWTSB0byBnYWluIGZ1bGwgd3JpdGUgYWNjZXNzIHRvIHByZXR0
eSBtdWNoIGFsbCB0aGUgaW50ZXJlc3RpbmcNCj4gTVNScy4gVGhpcyBuZWVkcyB0byBvbmx5IGRp
c2FibGUgaW50ZXJjZXB0aW9uIGlmIEtWTSBoYWQgaW50ZXJjZXB0aW9uDQo+IGRpc2FibGVkIGJl
Zm9yZSBpbnRyb3NwZWN0aW9uIHN0YXJ0ZWQgbW9kaWZ5aW5nIHN0YXRlLg0KDQpXZSBvbmx5IG5l
ZWQgdG8gZW5hYmxlIHRoZSBNU1IgaW50ZXJjZXB0aW9uLiBXZSBuZXZlciBkaXNhYmxlIGl0IC0N
CnBsZWFzZSBzZWUga3ZtaV9hcmNoX2NtZF9jb250cm9sX21zcigpLg0KDQo=
