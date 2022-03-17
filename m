Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648194DD0BC
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 23:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiCQWcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 18:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiCQWcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 18:32:00 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50903174B88
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 15:30:43 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-132-qT9HbU2LNaSWJ_D4BTbhHQ-1; Thu, 17 Mar 2022 22:30:40 +0000
X-MC-Unique: qT9HbU2LNaSWJ_D4BTbhHQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 17 Mar 2022 22:30:40 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 17 Mar 2022 22:30:39 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Maxim Levitsky' <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "seanjc@google.com" <seanjc@google.com>
Subject: RE: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Thread-Topic: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Thread-Index: AQHYOiZ8J6iVxlFZSEKme+GWeigJ56zEJ+GQ
Date:   Thu, 17 Mar 2022 22:30:39 +0000
Message-ID: <a63028d4ece24040b382ab2bba50bcad@AcuMS.aculab.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
         <20220217180831.288210-7-pbonzini@redhat.com>
 <3bbe3f8717cdf122f909a48e117dab6c09d8e0c8.camel@redhat.com>
In-Reply-To: <3bbe3f8717cdf122f909a48e117dab6c09d8e0c8.camel@redhat.com>
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBJIGd1ZXNzIHNvbWV0aGluZyB3aXRoIHJldHVybmluZyB1NjQgbWFkZSAzMiBjb21waWxlciB1
bmhhcHB5Lg0KPiANCj4gSSBzdXNwZWN0IHRoYXQgX19zdGF0aWNfY2FsbF9yZXR1cm4wIHJldHVy
bnMgbG9uZywgd2hpY2ggbWVhbnMgaXQgcmV0dXJucw0KPiAzMiBiaXQgdmFsdWUgb24gMzIgYml0
IHN5c3RlbS4NCj4gDQo+IE1heWJlIHdlIGNhbiBtYWtlIGl0IHJldHVybiB1NjQuIEkgZG9uJ3Qg
a25vdyBpZiB0aGF0IHdpbGwgYnJlYWsgc29tZXRoaW5nIGVsc2UgdGhvdWdoLg0KDQozMiBiaXQg
c3lzdGVtIHdpbGwgcmV0dXJuIGEgNjRiaXQgdmFsdWUgaW4gJWVkeDolZWF4Lg0KU2luY2UgJXJk
eCBpcyBhIHNjcmF0Y2ggcmVnaXN0ZXIgKGNhbGxlciBzYXZlZCkgaXQgaXMgZmluZS4NCg0KSXMg
X19zdGF0Y19jYWxsX3JldHVybjAoKSBldmVyIHVzZWQgdG8gcmV0dXJuIGEgTlVMTCBwb2ludGVy
Pw0KSVNUUiBzb21lIEFCSSAobWF5YmUgbTY4ayBvbmVzKSB0aGF0IHJldHVybmVkIHBvaW50ZXJz
IGFuZA0KaW50ZWdlcnMgaW4gZGlmZmVyZW50IHJlZ2lzdGVycy4NClBsYXVzaWJseSB0aGF0IHdh
cyBvbmx5IDM1IHllYXJzIGFnby4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

