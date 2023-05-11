Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7924D6FEF83
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 11:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbjEKJ6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 05:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbjEKJ6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 05:58:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2006D3A82
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 02:58:37 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-206-kf-dF4izNSWC3RfE6u4f6Q-1; Thu, 11 May 2023 10:58:35 +0100
X-MC-Unique: kf-dF4izNSWC3RfE6u4f6Q-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 11 May
 2023 10:58:34 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 11 May 2023 10:58:34 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Binbin Wu' <binbin.wu@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: RE: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
Thread-Topic: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
Thread-Index: AQHZg6rCF6NoS/QM10ar2Egelucw1K9U1o5g
Date:   Thu, 11 May 2023 09:58:34 +0000
Message-ID: <ccf245b17d7140099ad89628635a04ef@AcuMS.aculab.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-2-binbin.wu@linux.intel.com>
 <ZFtK/NS8rzCx9Mus@chao-email>
 <68a5df32-82de-1f07-5ea2-52ecf1c17e63@linux.intel.com>
In-Reply-To: <68a5df32-82de-1f07-5ea2-52ecf1c17e63@linux.intel.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogQmluYmluIFd1DQo+IFNlbnQ6IDExIE1heSAyMDIzIDAyOjI2DQouLi4NCj4gPj4gCXVu
c2lnbmVkIG1heF9zaXplOw0KPiA+PiAtCXJldHVybiBfX2xpbmVhcml6ZShjdHh0LCBhZGRyLCAm
bWF4X3NpemUsIHNpemUsIHdyaXRlLCBmYWxzZSwNCj4gPj4gKwl1MzIgZmxhZ3MgPSAwOw0KPiA+
PiArDQo+ID4+ICsJaWYgKHdyaXRlKQ0KPiA+PiArCQlmbGFncyB8PSBYODZFTVVMX0ZfV1JJVEU7
DQo+ID4gdGhpcyBjYW4gYmUgbW9yZSBkZW5zZToNCj4gPg0KPiA+IAl1MzIgZmxhZ3MgPSB3cml0
ZSA/IFg4NkVNVUxfRl9XUklURSA6IDA7DQo+IFRoYW5rcywgd2lsbCB1cGRhdGUgaXQuDQoNCllv
dSBjYW4gYWxzbyBkaXNwZW5zZSB3aXRoIHRoZSBleHRyYSBsb2NhbCB2YXJpYWJsZSBhbmQNCnB1
dCB0aGUgPzogaW50byB0aGUgcGFyYW1ldGVyIGxpc3QuDQoNCkV2ZW4gbW9yZSBzbyB3aXRoIHRo
ZSBvdGhlciBjYWxscyBzaXRlcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

