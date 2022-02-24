Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B274D4C3990
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 00:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiBXXPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 18:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiBXXPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 18:15:38 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B745275797
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 15:15:05 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-281-foIGsKlaMWyYIUBl_oNJDQ-1; Thu, 24 Feb 2022 23:15:02 +0000
X-MC-Unique: foIGsKlaMWyYIUBl_oNJDQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 24 Feb 2022 23:15:01 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 24 Feb 2022 23:15:01 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Shevchenko' <andy.shevchenko@gmail.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
CC:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: RE: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Thread-Topic: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Thread-Index: AQHYKbf4PreGRJIIQ0mXQjRI10uskKyjVBFg
Date:   Thu, 24 Feb 2022 23:15:01 +0000
Message-ID: <2a9391a3546d487ca937c4e523690ea9@AcuMS.aculab.com>
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
 <20220224123620.57fd6c8b@p-imbrenda>
 <CAHp75Vfm-zmzoO0AZTv-3eBjXf0FzHh7tbHRn3DoO7EjukFVig@mail.gmail.com>
In-Reply-To: <CAHp75Vfm-zmzoO0AZTv-3eBjXf0FzHh7tbHRn3DoO7EjukFVig@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogQW5keSBTaGV2Y2hlbmtvDQo+IFNlbnQ6IDI0IEZlYnJ1YXJ5IDIwMjIgMTk6NTENCj4g
DQo+IE9uIFRodSwgRmViIDI0LCAyMDIyIGF0IDI6NTEgUE0gQ2xhdWRpbyBJbWJyZW5kYSA8aW1i
cmVuZGFAbGludXguaWJtLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBXZWQsIDIzIEZlYiAyMDIy
IDE4OjQ0OjIwICswMjAwDQo+ID4gQW5keSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0Bs
aW51eC5pbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiBXaGlsZSBpbiB0aGlzIHBhcnRpY3Vs
YXIgY2FzZSBpdCB3b3VsZCBub3QgYmUgYSAoY3JpdGljYWwpIGlzc3VlLA0KPiA+ID4gdGhlIHBh
dHRlcm4gaXRzZWxmIGlzIGJhZCBhbmQgZXJyb3IgcHJvbmUgaW4gY2FzZSBzb21lYm9keSBibGlu
ZGx5DQo+ID4gPiBjb3BpZXMgdG8gdGhlaXIgY29kZS4NCj4gPiA+DQo+ID4gPiBEb24ndCBjYXN0
IHBhcmFtZXRlciB0byB1bnNpZ25lZCBsb25nIHBvaW50ZXIgaW4gdGhlIGJpdCBvcGVyYXRpb25z
Lg0KPiA+ID4gSW5zdGVhZCBjb3B5IHRvIGEgbG9jYWwgdmFyaWFibGUgb24gc3RhY2sgb2YgYSBw
cm9wZXIgdHlwZSBhbmQgdXNlLg0KPiANCj4gLi4uDQo+IA0KPiA+ID4gKyAgICAgICAgICAgICBz
dHJ1Y3QgeyAvKiBhcyBhIDI1Ni1iaXQgYml0bWFwICovDQo+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgREVDTEFSRV9CSVRNQVAoYiwgMjU2KTsNCj4gPiA+ICsgICAgICAgICAgICAgfSBiaXRt
YXA7DQo+ID4gPiArICAgICAgICAgICAgIHN0cnVjdCB7IC8qIGFzIGEgc2V0IG9mIDY0LWJpdCB3
b3JkcyAqLw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIHU2NCB3b3JkWzRdOw0KPiA+ID4g
ICAgICAgICAgICAgICB9IHU2NDsNCj4gDQo+ID4gPiAtICAgICBzZXRfYml0X2ludihJUE1fQklU
X09GRlNFVCArIGdpc2MsICh1bnNpZ25lZCBsb25nICopIGdpc2EpOw0KPiA+ID4gKyAgICAgc2V0
X2JpdF9pbnYoSVBNX0JJVF9PRkZTRVQgKyBnaXNjLCBnaXNhLT5iaXRtYXAuYik7DQo+ID4NCj4g
PiB3b3VsZG4ndCBpdCBiZSBlbm91Z2ggdG8gcGFzcyBnaXNhLT51NjQud29yZCBoZXJlPw0KPiA+
IHRoZW4gbm8gY2FzdCB3b3VsZCBiZSBuZWNlc3NhcnkNCj4gDQo+IE5vLCBpdCB3aWxsIGhhdmUg
dGhlIHNhbWUgaGlkZGVuIGJ1Z3MuIEFzIEkgc3RhdGVkIGluIHRoZSBjb21taXQNCj4gbWVzc2Fn
ZSwgdGhlIHBhdHRlcm4gaXMgcXVpdGUgYmFkIGV2ZW4gaWYgaW4gcGFydGljdWxhciBjb2RlIGl0
IHdvdWxkDQo+IHdvcmsuDQo+IA0KPiBUaGFua3MsIE1pY2hhZWwsIGZvciBwb2ludGluZyBvdXQg
b3RoZXIgcGxhY2VzLiBUaGV5IGFsbCBuZWVkIHRvIGJlIGZpeGVkLg0KDQpJdCBtYXkgZXZlbiBi
ZSB3b3J0aCB3cml0aW5nIHNvbWUgYWx0ZXJuYXRlIGJpdG1hcCBmdW5jdGlvbnMNCnRoYXQgdXNl
IHU2NFtdIGFuZCB1bmxvY2tlZCBvcGVyYXRpb25zPw0KDQpBbHRob3VnaCBJIHRoaW5rIEknZCBz
dGlsbCB3YW50IHRvIGVuY2Fwc3VsYXRlIHRoZSBhY3R1YWwgYXJyYXkNCihzb21laG93KSBzbyB0
aGF0IHdoYXQgaXMgZGVmaW5lZCBoYXMgdG8gYmUgdGhlIGJpdG1hcCB0eXBlLg0KDQoJRGF2aWQN
Cg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYg
KFdhbGVzKQ0K

