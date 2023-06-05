Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69704721D62
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 07:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbjFEFMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 01:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjFEFMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 01:12:12 -0400
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 04 Jun 2023 22:12:11 PDT
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D196B1;
        Sun,  4 Jun 2023 22:12:10 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Subject: RE: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
Thread-Topic: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
Thread-Index: AQHZlO1wB1sqFs11bEiKQhMd1hjPbK97nftQ
Date:   Mon, 5 Jun 2023 04:26:30 +0000
Message-ID: <40ee5857d5d04ce1bece3bbb4d74a9de@baidu.com>
References: <20230602005859.784190-1-seanjc@google.com>
In-Reply-To: <20230602005859.784190-1-seanjc@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.10]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex15_2023-06-05 12:26:30:407
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSnVuZSAyLCAyMDIzIDg6
NTkgQU0NCj4gVG86IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPjsgUGFv
bG8gQm9uemluaQ0KPiA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gQ2M6IGt2bUB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IExpLFJvbmdxaW5nDQo+IDxsaXJv
bmdxaW5nQGJhaWR1LmNvbT47IFlvbmcgSGUgPHpodWFuZ2VsNTcwQGdtYWlsLmNvbT47IFJvYmVy
dCBIb28NCj4gPHJvYmVydC5ob28ubGludXhAZ21haWwuY29tPjsgS2FpIEh1YW5nIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIEtWTTogeDg2L21tdTogQWRkICJuZXZl
ciIgb3B0aW9uIHRvIGFsbG93IHN0aWNreSBkaXNhYmxpbmcgb2YNCj4gbnhfaHVnZV9wYWdlcw0K
PiANCj4gQWRkIGEgIm5ldmVyIiBvcHRpb24gdG8gdGhlIG54X2h1Z2VfcGFnZXMgbW9kdWxlIHBh
cmFtIHRvIGFsbG93IHVzZXJzcGFjZQ0KPiB0byBkbyBhIG9uZS13YXkgaGFyZCBkaXNhYmxpbmcg
b2YgdGhlIG1pdGlnYXRpb24sIGFuZCBkb24ndCBjcmVhdGUgdGhlIHBlci1WTQ0KPiByZWNvdmVy
eSB0aHJlYWRzIHdoZW4gdGhlIG1pdGlnYXRpb24gaXMgaGFyZCBkaXNhYmxlZC4gIExldHRpbmcg
dXNlcnNwYWNlIHBpbmt5DQo+IHN3ZWFyIHRoYXQgdXNlcnNwYWNlIGRvZXNuJ3Qgd2FudCB0byBl
bmFibGUgTlggbWl0aWdhdGlvbiAod2l0aG91dCByZWxvYWRpbmcNCj4gS1ZNKSBhbGxvd3MgY2Vy
dGFpbiB1c2UgY2FzZXMgdG8gYXZvaWQgdGhlIGxhdGVuY3kgcHJvYmxlbXMgYXNzb2NpYXRlZCB3
aXRoDQo+IHNwYXduaW5nIGEga3RocmVhZCBmb3IgZWFjaCBWTS4NCj4gDQo+IEUuZy4gaW4gRmFh
UyB1c2UgY2FzZXMsIHRoZSBndWVzdCBrZXJuZWwgaXMgdHJ1c3RlZCBhbmQgdGhlIGhvc3QgbWF5
IGNyZWF0ZSAxMDArDQo+IFZNcyBwZXIgbG9naWNhbCBDUFUsIHdoaWNoIGNhbiByZXN1bHQgaW4g
MTAwbXMrIGxhdGVuY2llcyB3aGVuIGEgYnVyc3Qgb2YgVk1zDQo+IGlzIGNyZWF0ZWQuDQo+IA0K
DQoNClJldmlld2VkLWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQoNCkFu
ZCBJIGhvcGUgbnhfaHVnZV9wYWdlcyBpcyBuZXZlciBieSBkZWZhdWx0IGlmIENQVSByZXBvcnRz
IHRoYXQgaXQgZG9lc24ndCBoYXZlIHN1Y2ggYnVnDQoNClRoYW5rcw0KDQotTGkgUm9uZ1FpbmcN
Cg0KDQoNCg==
