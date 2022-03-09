Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D874D2ACA
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 09:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiCIIov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 03:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiCIIou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 03:44:50 -0500
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BC45E6D91
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 00:43:51 -0800 (PST)
Received: from BC-Mail-Ex27.internal.baidu.com (unknown [172.31.51.21])
        by Forcepoint Email with ESMTPS id 3D4742131F5E18BC6FA1;
        Wed,  9 Mar 2022 16:43:15 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex27.internal.baidu.com (172.31.51.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 9 Mar 2022 16:43:14 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Wed, 9 Mar 2022 16:43:14 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        "Danmei Wei" <danmei.wei@intel.com>,
        "Wang,Guangju" <wangguangju@baidu.com>,
        "kernel test robot" <lkp@intel.com>
Subject: =?utf-8?B?562U5aSNOiBba3ZtOnF1ZXVlIDE4Mi8yMDNdIGFyY2gveDg2L2tlcm5lbC9r?=
 =?utf-8?B?dm0uYzo3Njk6NDogZXJyb3I6IHVzZSBvZiB1bmRlY2xhcmVkIGlkZW50aWZp?=
 =?utf-8?B?ZXIgJ19fcmF3X2NhbGxlZV9zYXZlX19fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVk?=
 =?utf-8?Q?'?=
Thread-Topic: [kvm:queue 182/203] arch/x86/kernel/kvm.c:769:4: error: use of
 undeclared identifier '__raw_callee_save___kvm_vcpu_is_preempted'
Thread-Index: AQHYMzqgVqIAavoTJEer1af12oFID6y2E+SAgACoi4A=
Date:   Wed, 9 Mar 2022 08:43:14 +0000
Message-ID: <39cfd287d85e4884b1d5b8df3593abaf@baidu.com>
References: <202203090613.qYNxBFkZ-lkp@intel.com>
 <c6455ba9-8c34-7f10-ca5a-60f2f01cc9ce@gmail.com>
In-Reply-To: <c6455ba9-8c34-7f10-ca5a-60f2f01cc9ce@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.33]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IExpa2UgWHUgPGxpa2Uu
eHUubGludXhAZ21haWwuY29tPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjLlubQz5pyIOeaXpSAxNDoz
OA0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT47IFBhb2xv
IEJvbnppbmkNCj4gPHBib256aW5pQHJlZGhhdC5jb20+DQo+IOaKhOmAgTogbGx2bUBsaXN0cy5s
aW51eC5kZXY7IGtidWlsZC1hbGxAbGlzdHMuMDEub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOw0K
PiBSb2JlcnQgSHUgPHJvYmVydC5odUBpbnRlbC5jb20+OyBGYXJyYWggQ2hlbiA8ZmFycmFoLmNo
ZW5AaW50ZWwuY29tPjsNCj4gRGFubWVpIFdlaSA8ZGFubWVpLndlaUBpbnRlbC5jb20+OyBXYW5n
LEd1YW5nanUNCj4gPHdhbmdndWFuZ2p1QGJhaWR1LmNvbT47IGtlcm5lbCB0ZXN0IHJvYm90IDxs
a3BAaW50ZWwuY29tPg0KPiDkuLvpopg6IFJlOiBba3ZtOnF1ZXVlIDE4Mi8yMDNdIGFyY2gveDg2
L2tlcm5lbC9rdm0uYzo3Njk6NDogZXJyb3I6IHVzZSBvZg0KPiB1bmRlY2xhcmVkIGlkZW50aWZp
ZXIgJ19fcmF3X2NhbGxlZV9zYXZlX19fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkJw0KPiANCj4gT24g
OS8zLzIwMjIgNjoxOCBhbSwga2VybmVsIHRlc3Qgcm9ib3Qgd3JvdGU6DQo+ID4gdHJlZTogICBo
dHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vdmlydC9rdm0va3ZtLmdpdCBxdWV1ZQ0KPiA+
IGhlYWQ6ICAgMDBhMmJkMzQ2NDI4MGNhMWYwOGUyY2JmYWIyMmI4ODRmZmI3MzFkOA0KPiA+IGNv
bW1pdDogZGM4ODlhODk3NDA4N2FiYTNlYjFjYzZkYjIwNjZmYmJkYjU4OTIyYSBbMTgyLzIwM10g
S1ZNOg0KPiB4ODY6DQo+ID4gU3VwcG9ydCB0aGUgdkNQVSBwcmVlbXB0aW9uIGNoZWNrIHdpdGgg
bm9wdnNwaW4gYW5kIHJlYWx0aW1lIGhpbnQNCj4gPiBjb25maWc6IHg4Nl82NC1yYW5kY29uZmln
LWEwMDENCj4gPiAoaHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9hcmNoaXZlLzIwMjIw
MzA5LzIwMjIwMzA5MDYxMy5xWU54QkZrDQo+ID4gWi1sa3BAaW50ZWwuY29tL2NvbmZpZykNCj4g
PiBjb21waWxlcjogY2xhbmcgdmVyc2lvbiAxNS4wLjAgKGh0dHBzOi8vZ2l0aHViLmNvbS9sbHZt
L2xsdm0tcHJvamVjdA0KPiA+IDBkYzY2Yjc2ZmU0YzMzODQzNzU1YWRlMzkxYjg1ZmZkYTA3NDJh
ZWIpDQo+ID4gcmVwcm9kdWNlICh0aGlzIGlzIGEgVz0xIGJ1aWxkKToNCj4gPiAgICAgICAgICB3
Z2V0DQo+IGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9pbnRlbC9sa3AtdGVzdHMv
bWFzdGVyL3NiaW4vbWFrZS5jcm9zcyAtTw0KPiB+L2Jpbi9tYWtlLmNyb3NzDQo+ID4gICAgICAg
ICAgY2htb2QgK3ggfi9iaW4vbWFrZS5jcm9zcw0KPiA+ICAgICAgICAgICMNCj4gaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL3ZpcnQva3ZtL2t2bS5naXQvY29tbWl0Lz9pZD1kYzg4OWE4
OTc0MDg3YQ0KPiBiYTNlYjFjYzZkYjIwNjZmYmJkYjU4OTIyYQ0KPiA+ICAgICAgICAgIGdpdCBy
ZW1vdGUgYWRkIGt2bQ0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vdmlydC9rdm0v
a3ZtLmdpdA0KPiA+ICAgICAgICAgIGdpdCBmZXRjaCAtLW5vLXRhZ3Mga3ZtIHF1ZXVlDQo+ID4g
ICAgICAgICAgZ2l0IGNoZWNrb3V0IGRjODg5YTg5NzQwODdhYmEzZWIxY2M2ZGIyMDY2ZmJiZGI1
ODkyMmENCj4gPiAgICAgICAgICAjIHNhdmUgdGhlIGNvbmZpZyBmaWxlIHRvIGxpbnV4IGJ1aWxk
IHRyZWUNCj4gPiAgICAgICAgICBta2RpciBidWlsZF9kaXINCj4gPiAgICAgICAgICBDT01QSUxF
Ul9JTlNUQUxMX1BBVEg9JEhPTUUvMGRheSBDT01QSUxFUj1jbGFuZw0KPiBtYWtlLmNyb3NzDQo+
ID4gVz0xIE89YnVpbGRfZGlyIEFSQ0g9eDg2XzY0IFNIRUxMPS9iaW4vYmFzaA0KPiA+DQo+ID4g
SWYgeW91IGZpeCB0aGUgaXNzdWUsIGtpbmRseSBhZGQgZm9sbG93aW5nIHRhZyBhcyBhcHByb3By
aWF0ZQ0KPiA+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4N
Cj4gPg0KPiA+IEFsbCBlcnJvcnMgKG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KToNCj4gPg0KPiA+
Pj4gYXJjaC94ODYva2VybmVsL2t2bS5jOjc2OTo0OiBlcnJvcjogdXNlIG9mIHVuZGVjbGFyZWQg
aWRlbnRpZmllcg0KPiAnX19yYXdfY2FsbGVlX3NhdmVfX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQn
DQo+ID4NCj4gUFZfQ0FMTEVFX1NBVkUoX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQpOw0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBeDQo+ID4gICAgIGFyY2gveDg2L2luY2x1ZGUvYXNt
L3BhcmF2aXJ0Lmg6NjgzOjM1OiBub3RlOiBleHBhbmRlZCBmcm9tIG1hY3JvDQo+ICdQVl9DQUxM
RUVfU0FWRScNCj4gPiAgICAgICAgICAgICAoKHN0cnVjdCBwYXJhdmlydF9jYWxsZWVfc2F2ZSkg
eyBfX3Jhd19jYWxsZWVfc2F2ZV8jI2Z1bmMgfSkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBeDQo+ID4gICAgIDxzY3JhdGNoIHNwYWNlPjo1MjoxOiBu
b3RlOiBleHBhbmRlZCBmcm9tIGhlcmUNCj4gPiAgICAgX19yYXdfY2FsbGVlX3NhdmVfX19rdm1f
dmNwdV9pc19wcmVlbXB0ZWQNCj4gPiAgICAgXg0KPiA+ICAgICAxIGVycm9yIGdlbmVyYXRlZC4N
Cj4gDQoNCg0KDQpTb3JyeSwgaXQgaW50cm9kdWNlZCBieSBteSBwYXRjaCwgd2Ugc2hvdWxkIG1v
dmUgdGhpcyBmdW5jdGlvbiBvdXQgb2YgQ09ORklHX1BBUkFWSVJUX1NQSU5MT0NLDQoNCkkgd2ls
bCBzZW5kIGEgbmV3IHBhdGNoDQoNClRoYW5rcw0KDQotTGkNCg0KPiBIb3cgYWJvdXQgdGhpcyBm
aXg6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmgNCj4gaW5kZXggMGQ3NjUwMmNjNmY1Li5k
NjU2ZTQxMTdlMDEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0
LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaA0KPiBAQCAtNjE3LDYg
KzYxNyw3IEBAIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgYm9vbCBwdl92Y3B1X2lzX3ByZWVtcHRl
ZChsb25nDQo+IGNwdSkNCj4gDQo+ICAgdm9pZCBfX3Jhd19jYWxsZWVfc2F2ZV9fX25hdGl2ZV9x
dWV1ZWRfc3Bpbl91bmxvY2soc3RydWN0IHFzcGlubG9jaw0KPiAqbG9jayk7DQo+ICAgYm9vbCBf
X3Jhd19jYWxsZWVfc2F2ZV9fX25hdGl2ZV92Y3B1X2lzX3ByZWVtcHRlZChsb25nIGNwdSk7DQo+
ICtib29sIF9fcmF3X2NhbGxlZV9zYXZlX19fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkKGxvbmcgY3B1
KTsNCj4gDQo+ICAgI2VuZGlmIC8qIFNNUCAmJiBQQVJBVklSVF9TUElOTE9DS1MgKi8NCj4gDQo+
ID4NCj4gPg0KPiA+IHZpbSArL19fcmF3X2NhbGxlZV9zYXZlX19fa3ZtX3ZjcHVfaXNfcHJlZW1w
dGVkICs3NjkNCj4gPiBhcmNoL3g4Ni9rZXJuZWwva3ZtLmMNCj4gPg0KPiA+ICAgICA3NTQNCj4g
PiAgICAgNzU1CXN0YXRpYyB2b2lkIF9faW5pdCBrdm1fZ3Vlc3RfaW5pdCh2b2lkKQ0KPiA+ICAg
ICA3NTYJew0KPiA+ICAgICA3NTcJCWludCBpOw0KPiA+ICAgICA3NTgNCj4gPiAgICAgNzU5CQlw
YXJhdmlydF9vcHNfc2V0dXAoKTsNCj4gPiAgICAgNzYwCQlyZWdpc3Rlcl9yZWJvb3Rfbm90aWZp
ZXIoJmt2bV9wdl9yZWJvb3RfbmIpOw0KPiA+ICAgICA3NjEJCWZvciAoaSA9IDA7IGkgPCBLVk1f
VEFTS19TTEVFUF9IQVNIU0laRTsgaSsrKQ0KPiA+ICAgICA3NjIJCQlyYXdfc3Bpbl9sb2NrX2lu
aXQoJmFzeW5jX3BmX3NsZWVwZXJzW2ldLmxvY2spOw0KPiA+ICAgICA3NjMNCj4gPiAgICAgNzY0
CQlpZiAoa3ZtX3BhcmFfaGFzX2ZlYXR1cmUoS1ZNX0ZFQVRVUkVfU1RFQUxfVElNRSkpIHsNCj4g
PiAgICAgNzY1CQkJaGFzX3N0ZWFsX2Nsb2NrID0gMTsNCj4gPiAgICAgNzY2CQkJc3RhdGljX2Nh
bGxfdXBkYXRlKHB2X3N0ZWFsX2Nsb2NrLCBrdm1fc3RlYWxfY2xvY2spOw0KPiA+ICAgICA3NjcN
Cj4gPiAgICAgNzY4CQkJcHZfb3BzLmxvY2sudmNwdV9pc19wcmVlbXB0ZWQgPQ0KPiA+ICAgPiA3
NjkJCQkJUFZfQ0FMTEVFX1NBVkUoX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQpOw0KPiA+ICAgICA3
NzAJCX0NCj4gPiAgICAgNzcxDQo+ID4gICAgIDc3MgkJaWYgKGt2bV9wYXJhX2hhc19mZWF0dXJl
KEtWTV9GRUFUVVJFX1BWX0VPSSkpDQo+ID4gICAgIDc3MwkJCWFwaWNfc2V0X2VvaV93cml0ZShr
dm1fZ3Vlc3RfYXBpY19lb2lfd3JpdGUpOw0KPiA+ICAgICA3NzQNCj4gPiAgICAgNzc1CQlpZiAo
a3ZtX3BhcmFfaGFzX2ZlYXR1cmUoS1ZNX0ZFQVRVUkVfQVNZTkNfUEZfSU5UKQ0KPiAmJiBrdm1h
cGYpIHsNCj4gPiAgICAgNzc2CQkJc3RhdGljX2JyYW5jaF9lbmFibGUoJmt2bV9hc3luY19wZl9l
bmFibGVkKTsNCj4gPiAgICAgNzc3CQkJYWxsb2NfaW50cl9nYXRlKEhZUEVSVklTT1JfQ0FMTEJB
Q0tfVkVDVE9SLA0KPiBhc21fc3lzdmVjX2t2bV9hc3luY3BmX2ludGVycnVwdCk7DQo+ID4gICAg
IDc3OAkJfQ0KPiA+ICAgICA3NzkNCj4gPg0KPiA+IC0tLQ0KPiA+IDAtREFZIENJIEtlcm5lbCBU
ZXN0IFNlcnZpY2UsIEludGVsIENvcnBvcmF0aW9uDQo+ID4gaHR0cHM6Ly9saXN0cy4wMS5vcmcv
aHlwZXJraXR0eS9saXN0L2tidWlsZC1hbGxAbGlzdHMuMDEub3JnDQo+ID4NCg==
