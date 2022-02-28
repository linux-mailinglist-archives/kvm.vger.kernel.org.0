Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F1F4C60A1
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 02:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiB1B2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 20:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiB1B2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 20:28:16 -0500
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6194D1111
        for <kvm@vger.kernel.org>; Sun, 27 Feb 2022 17:27:38 -0800 (PST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (unknown [10.127.64.38])
        by Forcepoint Email with ESMTPS id 7621CE2A695805E1AAC8;
        Mon, 28 Feb 2022 09:27:32 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 28 Feb 2022 09:27:32 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Mon, 28 Feb 2022 09:27:32 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     kvm <kvm@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Jlc2VuZF0gS1ZNOiB4ODY6IFlpZWxkIHRvIElQ?=
 =?utf-8?Q?I_target_vCPU_only_if_it_is_busy?=
Thread-Topic: [PATCH][resend] KVM: x86: Yield to IPI target vCPU only if it is
 busy
Thread-Index: AQHYKfn719VbqnxhZE+nHtDYJgNTTqykbtuAgAO+8GA=
Date:   Mon, 28 Feb 2022 01:27:32 +0000
Message-ID: <5b07dc0d6b164016af09704546aa07b5@baidu.com>
References: <1645760664-26028-1-git-send-email-lirongqing@baidu.com>
 <CANRm+Czf8Ge4cMKrccq5yEbR=_bsCr-OxXpy0RVV4uk5vxR5yA@mail.gmail.com>
In-Reply-To: <CANRm+Czf8Ge4cMKrccq5yEbR=_bsCr-OxXpy0RVV4uk5vxR5yA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.69.43]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex15_2022-02-28 09:27:32:387
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

PiBPbiBGcmksIDI1IEZlYiAyMDIyIGF0IDIzOjA0LCBMaSBSb25nUWluZyA8bGlyb25ncWluZ0Bi
YWlkdS5jb20+IHdyb3RlOg0KPiA+DQo+ID4gV2hlbiBzZW5kaW5nIGEgY2FsbC1mdW5jdGlvbiBJ
UEktbWFueSB0byB2Q1BVcywgeWllbGQgdG8gdGhlIElQSQ0KPiA+IHRhcmdldCB2Q1BVIHdoaWNo
IGlzIG1hcmtlZCBhcyBwcmVlbXB0ZWQuDQo+ID4NCj4gPiBidXQgd2hlbiBlbXVsYXRpbmcgSExU
LCBhbiBpZGxpbmcgdkNQVSB3aWxsIGJlIHZvbHVudGFyaWx5IHNjaGVkdWxlZA0KPiA+IG91dCBh
bmQgbWFyayBhcyBwcmVlbXB0ZWQgZnJvbSB0aGUgZ3Vlc3Qga2VybmVsIHBlcnNwZWN0aXZlLiB5
aWVsZGluZw0KPiA+IHRvIGlkbGUgdkNQVSBpcyBwb2ludGxlc3MgYW5kIGluY3JlYXNlIHVubmVj
ZXNzYXJ5IHZtZXhpdCwgbWF5YmUgbWlzcw0KPiA+IHRoZSB0cnVlIHByZWVtcHRlZCB2Q1BVDQo+
ID4NCj4gPiBzbyB5aWVsZCB0byBJUEkgdGFyZ2V0IHZDUFUgb25seSBpZiB2Q1BVIGlzIGJ1c3kg
YW5kIHByZWVtcHRlZA0KPiANCj4gVGhpcyBpcyBub3QgY29ycmVjdCwgdGhlcmUgaXMgYW4gaW50
ZW50aW9uIHRvIGJvb3N0IHRoZSByZWFjdGl2YXRpb24gb2YgaWRsZSB2Q1BVLA0KPiBQViBzY2hl
ZCB5aWVsZCBpcyB1c2VkIGluIG92ZXItc3Vic2NyaWJlIHNjZW5hcmlvIGFuZCB0aGUgcENQVSB3
aGljaCBpZGxlIHZDUFUgaXMNCj4gcmVzaWRlbnQgbWF5YmUgYnVzeSwgYW5kIHRoZSB2Q1BVIHdp
bGwgd2FpdCBpbiB0aGUgaG9zdCBzY2hlZHVsZXIgcnVuIHF1ZXVlLg0KPiBUaGVyZSBpcyBhIHJl
c2VhcmNoIHBhcGVyIFsxXSBmb2N1c2luZyBvbiB0aGlzIGJvb3N0IGFuZCBzaG93aW5nIGJldHRl
cg0KPiBwZXJmb3JtYW5jZSBudW1iZXJzLCB0aG91Z2ggdGhlaXIgYm9vc3QgaXMgbW9yZSB1bmZh
aXIuDQo+IA0KPiBbMV0uIGh0dHBzOi8vaWVlZXhwbG9yZS5pZWVlLm9yZy9kb2N1bWVudC84NTI2
OTAwDQo+ICJBY2NlbGVyYXRpbmcgSWRsZSB2Q1BVIFJlYWN0aXZhdGlvbiINCj4gDQo+ICAgICBX
YW5wZW5nDQoNCg0KSSB1bmRlcnN0YW5kIHRoYXQgb3Zlci1zdWJzY3JpYmUgc3lzdGVtIGlzIG5v
dCBhbHdheXMgb3Zlci0gc3Vic2NyaWJlLCBpdCBzaG91bGQgc29tZXRpbWUgdHJ1ZSwgc29tZXRp
bWUgbm90Lg0KV2l0aG91dCB0aGlzIHBhdGNoLCBpdCB3aWxsIGhhcmQgdGhlIHBlcmZvcm1hbmNl
IHdoZW4gY3B1IGlzIG5vdCBvdmVyLXN1YnNjcmliZS4NCg0KQW5kIHlpZWxkaW5nIHRvIGEgbm90
IHJlYWR5IHZjcHUgaXMgdW5uZWNlc3NhcnkgYXMga3ZtX3NjaGVkX3lpZWxkDQoNCnN0YXRpYyB2
b2lkIGt2bV9zY2hlZF95aWVsZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcg
ZGVzdF9pZCkNCnsNCiANCiAgICAgaWYgKCF0YXJnZXQgfHwgIVJFQURfT05DRSh0YXJnZXQtPnJl
YWR5KSkNCiAgICAgICAgICBnb3RvIG5vX3lpZWxkOw0KfQ0KDQotTGkNCg0KDQoNCg==
