Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3B84F30CB
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 14:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbiDEIj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241064AbiDEIcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 04:32:46 -0400
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B221DB82EF
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 01:26:26 -0700 (PDT)
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id C5B1ECA8CD027E1F773A;
        Tue,  5 Apr 2022 16:26:17 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 5 Apr 2022 16:26:17 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Tue, 5 Apr 2022 16:26:17 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gS1ZNOiBWTVg6IG9wdGltaXplIHBp?=
 =?utf-8?B?X3dha2V1cF9oYW5kbGVy?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogVk1YOiBvcHRpbWl6ZSBwaV93YWtldXBf?=
 =?utf-8?Q?handler?=
Thread-Index: AQHYRmmqp/FH1eZDIUue+xcJmL0TgKzcSb8ggAMQ4YCAAaPHsA==
Date:   Tue, 5 Apr 2022 08:26:17 +0000
Message-ID: <2db1a3ec1633432081d1e0fe90b18775@baidu.com>
References: <1648872113-24329-1-git-send-email-lirongqing@baidu.com>
 <e7896b4e-0b29-b735-88b8-34dd3b266d3d@redhat.com>
 <d63acc4d9ac24a48b49415a45238e907@baidu.com> <YksLgfrKuX78e0ja@google.com>
In-Reply-To: <YksLgfrKuX78e0ja@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.146.47]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBUaGVyZSdzIG5vIG5lZWQgdG8gcHJvdGVjdCByZWFkaW5nIHRoZSBwZXItY3B1IHZhcmlhYmxl
IHdpdGggdGhlIHNwaW5sb2NrLCBvbmx5DQo+IHdhbGtpbmcgdGhlIGxpc3QgbmVlZHMgdG8gYmUg
cHJvdGVjdGVkLiAgRS5nLiB0aGUgY29kZSBjYW4gYmUgY29tcGFjdGVkIHRvOg0KDQpUaGFua3MN
Cg0KPiA+ID4NCj4gPiA+IFdoYXQncyB0aGUgZGlmZmVyZW5jZSBpbiB0aGUgZ2VuZXJhdGVkIGNv
ZGU/DQo+ID4gPg0KPiA+DQo+ID4gVGhpcyByZWR1Y2VzIG9uZSBmaWZ0aCBhc20gY29kZXMNCj4g
DQo+IC4uLg0KPiANCj4gPiB0aGVzZSBpcyBhIHNpbWlsYXIgcGF0Y2ggMDMxZTNiZDg5ODZmZmZl
MzFlMWRkYmY1MjY0Y2NjZmUzMGM5YWJkNw0KPiANCj4gSXMgdGhlcmUgYSBtZWFzdXJhYmxlIHBl
cmZvcm1hbmNlIGltcHJvdmVtZW50IHRob3VnaD8gIEkgZG9uJ3QgZGlzbGlrZSB0aGUNCj4gcGF0
Y2gsIGJ1dCBpdCBwcm9iYWJseSBmYWxscyBpbnRvIHRoZSAidGVjaG5pY2FsbHkgYW4gb3B0aW1p
emF0aW9uIGJ1dCBubyBvbmUgd2lsbA0KPiBldmVyIG5vdGljZSIgY2F0ZWdvcnkuDQoNClRoZXJl
IGlzIHNtYWxsIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50IHdoZW4gInBlcmYgYmVuY2ggc2NoZWQg
cGlwZSIgaXMgdGVzdGVkIG9uIElQSSB2aXJ0dWFsaXphdGlvbiBzdXBwb3J0ZWQgY3B1IGFuZCBo
YWx0L213YWl0IGRvbm90IHBhc3N0aHJvdWdoIHRvIHZtDQooaHR0cHM6Ly9wYXRjaHdvcmsua2Vy
bmVsLm9yZy9wcm9qZWN0L2t2bS9wYXRjaC8yMDIyMDMwNDA4MDcyNS4xODEzNS05LWd1YW5nLnpl
bmdAaW50ZWwuY29tLyBhcmUgaW5jbHVkZWQpDQoNCg0KVGhhbmtzDQoNCi1MaQ0K
