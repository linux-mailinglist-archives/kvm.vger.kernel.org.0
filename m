Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF44D2DCD
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 12:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiCILSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 06:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiCILSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 06:18:44 -0500
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9497913DFE
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 03:17:44 -0800 (PST)
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id 3C75CFCE2A57F3A0A3FE;
        Wed,  9 Mar 2022 19:17:42 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 9 Mar 2022 19:17:41 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Wed, 9 Mar 2022 19:17:41 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
CC:     Peter Zijlstra <peterz@infradead.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YzXSBLVk06IHg4NjogU3VwcG9ydCB0aGUgdkNQ?=
 =?utf-8?B?VSBwcmVlbXB0aW9uIGNoZWNrIHdpdGggbm9wdnNwaW4gYW5kIHJlYWx0aW1l?=
 =?utf-8?Q?_hint?=
Thread-Topic: [PATCH][v3] KVM: x86: Support the vCPU preemption check with
 nopvspin and realtime hint
Thread-Index: AQHYM5I5mrxWJfv1YU6NVnR2zxvzbKy2QxKAgACNlPA=
Date:   Wed, 9 Mar 2022 11:17:41 +0000
Message-ID: <172ca8e11130473c90c5533ce51dfa49@baidu.com>
References: <1646815610-43315-1-git-send-email-lirongqing@baidu.com>
 <7746aad0-3968-ffba-1b7e-97e52b1afd6a@redhat.com>
In-Reply-To: <7746aad0-3968-ffba-1b7e-97e52b1afd6a@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.33]
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

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFBhb2xvIEJvbnppbmkg
PHBib256aW5pQHJlZGhhdC5jb20+DQo+IOWPkemAgeaXtumXtDogMjAyMuW5tDPmnIg55pelIDE3
OjI5DQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPjsgc2Vh
bmpjQGdvb2dsZS5jb207DQo+IHZrdXpuZXRzQHJlZGhhdC5jb207IGptYXR0c29uQGdvb2dsZS5j
b207IHg4NkBrZXJuZWwub3JnOw0KPiBrdm1Admdlci5rZXJuZWwub3JnOyB3YW5wZW5nbGlAdGVu
Y2VudC5jb20NCj4g5Li76aKYOiBSZTogW1BBVENIXVt2M10gS1ZNOiB4ODY6IFN1cHBvcnQgdGhl
IHZDUFUgcHJlZW1wdGlvbiBjaGVjayB3aXRoDQo+IG5vcHZzcGluIGFuZCByZWFsdGltZSBoaW50
DQo+IA0KPiBPbiAzLzkvMjIgMDk6NDYsIExpIFJvbmdRaW5nIHdyb3RlOg0KPiA+IElmIGd1ZXN0
IGtlcm5lbCBpcyBjb25maWd1cmVkIHdpdGggbm9wdnNwaW4sIG9yDQo+ID4gQ09ORklHX1BBUkFW
SVJUX1NQSU5MT0NLIGlzIGRpc2FibGVkLCBvciBndWVzdCBmaW5kIGl0cyBoYXMgZGVkaWNhdGVk
DQo+ID4gcENQVXMgZnJvbSByZWFsdGltZSBoaW50IGZlYXR1cmUsIHRoZSBwdnNwaW5sb2NrIHdp
bGwgYmUgZGlzYWJsZWQsIGFuZA0KPiA+IHZDUFUgcHJlZW1wdGlvbiBjaGVjayBpcyBkaXNhYmxl
ZCB0b28uDQo+ID4NCj4gPiBidXQgS1ZNIHN0aWxsIGNhbiBlbXVsYXRpbmcgSExUIGZvciB2Q1BV
IGZvciBib3RoIGNhc2VzLCBhbmQgY2hlY2sgaWYNCj4gPiB2Q1BVIGlzIHByZWVtcHRlZCBvciBu
b3QsIGFuZCBjYW4gYm9vc3QgcGVyZm9ybWFuY2UNCj4gPg0KPiA+IHNvIG1vdmUgdGhlIHNldHRp
bmcgb2YgcHZfb3BzLmxvY2sudmNwdV9pc19wcmVlbXB0ZWQgdG8NCj4gPiBrdm1fZ3Vlc3RfaW5p
dCwgbWFrZSBpdCBub3QgZGVwZW5kIG9uIHB2c3BpbmxvY2sNCj4gPg0KPiA+IExpa2UgdW5peGJl
bmNoLCBzaW5nbGUgY29weSwgdmNwdSB3aXRoIGRlZGljYXRlZCBwQ1BVIGFuZCBndWVzdCBrZXJu
ZWwNCj4gPiB3aXRoIG5vcHZzcGluLCBidXQgZW11bGF0aW5nIEhMVCBmb3IgdkNQVWA6DQo+ID4N
Cj4gPiBUZXN0Y2FzZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBCYXNlICAgIHdp
dGggcGF0Y2gNCj4gPiBTeXN0ZW0gQmVuY2htYXJrcyBJbmRleCBWYWx1ZXMgICAgICAgICAgICBJ
TkRFWCAgICAgSU5ERVgNCj4gPiBEaHJ5c3RvbmUgMiB1c2luZyByZWdpc3RlciB2YXJpYWJsZXMg
ICAgIDMyNzguNCAgICAzMjc3LjcNCj4gPiBEb3VibGUtUHJlY2lzaW9uIFdoZXRzdG9uZSAgICAg
ICAgICAgICAgICA4MjIuOCAgICAgODI1LjgNCj4gPiBFeGVjbCBUaHJvdWdocHV0ICAgICAgICAg
ICAgICAgICAgICAgICAgIDEyOTYuNSAgICAgOTQxLjENCj4gPiBGaWxlIENvcHkgMTAyNCBidWZz
aXplIDIwMDAgbWF4YmxvY2tzICAgIDIxMjQuMiAgICAyMTQyLjcNCj4gPiBGaWxlIENvcHkgMjU2
IGJ1ZnNpemUgNTAwIG1heGJsb2NrcyAgICAgIDEzMzUuOSAgICAxMzUzLjYNCj4gPiBGaWxlIENv
cHkgNDA5NiBidWZzaXplIDgwMDAgbWF4YmxvY2tzICAgIDQyNTYuMyAgICA0NzYwLjMNCj4gPiBQ
aXBlIFRocm91Z2hwdXQgICAgICAgICAgICAgICAgICAgICAgICAgIDEwNTAuMSAgICAxMDU0LjAN
Cj4gPiBQaXBlLWJhc2VkIENvbnRleHQgU3dpdGNoaW5nICAgICAgICAgICAgICAyNDMuMyAgICAg
MzUyLjANCj4gPiBQcm9jZXNzIENyZWF0aW9uICAgICAgICAgICAgICAgICAgICAgICAgICA4MjAu
MSAgICAgODE0LjQNCj4gPiBTaGVsbCBTY3JpcHRzICgxIGNvbmN1cnJlbnQpICAgICAgICAgICAg
IDIxNjkuMCAgICAyMDg2LjANCj4gPiBTaGVsbCBTY3JpcHRzICg4IGNvbmN1cnJlbnQpICAgICAg
ICAgICAgIDc3MTAuMyAgICA3NTc2LjMNCj4gPiBTeXN0ZW0gQ2FsbCBPdmVyaGVhZCAgICAgICAg
ICAgICAgICAgICAgICA2NzIuNCAgICAgNjczLjkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICA9PT09PT09PSAgICA9PT09PT09DQo+ID4gU3lzdGVtIEJlbmNobWFy
a3MgSW5kZXggU2NvcmUgICAgICAgICAgICAgMTQ2Ny4yICAgMTQ4My4wDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ID4gLS0tDQo+
ID4gZGlmZiB2MzogZml4IGJ1aWxkaW5nIGZhaWx1cmUgd2hlbiBDT05GSUdfUEFSQVZJUlRfU1BJ
TkxPQ0sgaXMgZGlzYWJsZQ0KPiA+ICAgICAgICAgICBhbmQgc2V0dGluZyBwcmVlbXB0aW9uIGNo
ZWNrIG9ubHkgd2hlbiB1bmhhbHQgZGlmZiB2MjogbW92ZQ0KPiA+IHNldHRpbmcgcHJlZW1wdGlv
biBjaGVjayB0byBrdm1fZ3Vlc3RfaW5pdA0KPiA+DQo+ID4gICBhcmNoL3g4Ni9rZXJuZWwva3Zt
LmMgfCA3NA0KPiArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCAzNyBkZWxldGlv
bnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMgYi9hcmNo
L3g4Ni9rZXJuZWwva3ZtLmMgaW5kZXgNCj4gPiBkNzc0ODFlYy4uOTU5ZjkxOSAxMDA2NDQNCj4g
PiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwv
a3ZtLmMNCj4gPiBAQCAtNzUyLDYgKzc1MiwzOSBAQCBzdGF0aWMgdm9pZCBrdm1fY3Jhc2hfc2h1
dGRvd24oc3RydWN0IHB0X3JlZ3MNCj4gKnJlZ3MpDQo+ID4gICB9DQo+ID4gICAjZW5kaWYNCj4g
Pg0KPiA+ICsjaWZkZWYgQ09ORklHX1g4Nl8zMg0KPiA+ICtfX3Zpc2libGUgYm9vbCBfX2t2bV92
Y3B1X2lzX3ByZWVtcHRlZChsb25nIGNwdSkgew0KPiA+ICsJc3RydWN0IGt2bV9zdGVhbF90aW1l
ICpzcmMgPSAmcGVyX2NwdShzdGVhbF90aW1lLCBjcHUpOw0KPiA+ICsNCj4gPiArCXJldHVybiAh
IShzcmMtPnByZWVtcHRlZCAmIEtWTV9WQ1BVX1BSRUVNUFRFRCk7IH0NCj4gPiArUFZfQ0FMTEVF
X1NBVkVfUkVHU19USFVOSyhfX2t2bV92Y3B1X2lzX3ByZWVtcHRlZCk7DQo+ID4gKw0KPiA+ICsj
ZWxzZQ0KPiA+ICsNCj4gPiArI2luY2x1ZGUgPGFzbS9hc20tb2Zmc2V0cy5oPg0KPiA+ICsNCj4g
PiArZXh0ZXJuIGJvb2wgX19yYXdfY2FsbGVlX3NhdmVfX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQo
bG9uZyk7DQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBIYW5kLW9wdGltaXplIHZlcnNpb24gZm9y
IHg4Ni02NCB0byBhdm9pZCA4IDY0LWJpdCByZWdpc3RlciBzYXZpbmcNCj4gPiArYW5kDQo+ID4g
KyAqIHJlc3RvcmluZyB0by9mcm9tIHRoZSBzdGFjay4NCj4gPiArICovDQo+ID4gK2FzbSgNCj4g
PiArIi5wdXNoc2VjdGlvbiAudGV4dDsiDQo+ID4gKyIuZ2xvYmFsIF9fcmF3X2NhbGxlZV9zYXZl
X19fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkOyINCj4gPiArIi50eXBlIF9fcmF3X2NhbGxlZV9zYXZl
X19fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkLCBAZnVuY3Rpb247Ig0KPiA+ICsiX19yYXdfY2FsbGVl
X3NhdmVfX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQ6Ig0KPiA+ICsibW92cQlfX3Blcl9jcHVfb2Zm
c2V0KCwlcmRpLDgpLCAlcmF4OyINCj4gPiArImNtcGIJJDAsICIgX19zdHJpbmdpZnkoS1ZNX1NU
RUFMX1RJTUVfcHJlZW1wdGVkKSAiK3N0ZWFsX3RpbWUoJXJheCk7Ig0KPiA+ICsic2V0bmUJJWFs
OyINCj4gPiArInJldDsiDQo+ID4gKyIuc2l6ZQ0KPiBfX3Jhd19jYWxsZWVfc2F2ZV9fX2t2bV92
Y3B1X2lzX3ByZWVtcHRlZCwgLi1fX3Jhd19jYWxsZWVfc2F2ZV9fX2t2bV92DQo+IGNwdV9pc19w
cmVlbXB0ZWQ7Ig0KPiA+ICsiLnBvcHNlY3Rpb24iKTsNCj4gPiArDQo+ID4gKyNlbmRpZg0KPiA+
ICsNCj4gPiAgIHN0YXRpYyB2b2lkIF9faW5pdCBrdm1fZ3Vlc3RfaW5pdCh2b2lkKQ0KPiA+ICAg
ew0KPiA+ICAgCWludCBpOw0KPiA+IEBAIC03NjQsNiArNzk3LDEwIEBAIHN0YXRpYyB2b2lkIF9f
aW5pdCBrdm1fZ3Vlc3RfaW5pdCh2b2lkKQ0KPiA+ICAgCWlmIChrdm1fcGFyYV9oYXNfZmVhdHVy
ZShLVk1fRkVBVFVSRV9TVEVBTF9USU1FKSkgew0KPiA+ICAgCQloYXNfc3RlYWxfY2xvY2sgPSAx
Ow0KPiA+ICAgCQlzdGF0aWNfY2FsbF91cGRhdGUocHZfc3RlYWxfY2xvY2ssIGt2bV9zdGVhbF9j
bG9jayk7DQo+ID4gKw0KPiA+ICsJCWlmIChrdm1fcGFyYV9oYXNfZmVhdHVyZShLVk1fRkVBVFVS
RV9QVl9VTkhBTFQpKQ0KPiA+ICsJCQlwdl9vcHMubG9jay52Y3B1X2lzX3ByZWVtcHRlZCA9DQo+
ID4gKwkJCQlQVl9DQUxMRUVfU0FWRShfX2t2bV92Y3B1X2lzX3ByZWVtcHRlZCk7DQo+ID4gICAJ
fQ0KPiANCj4gSXMgaXQgbmVjZXNzYXJ5IHRvIGNoZWNrIFBWX1VOSEFMVD8gIFRoZSBiaXQgaXMg
cHJlc2VudCBhbnl3YXkgaW4gdGhlIHN0ZWFsDQo+IHRpbWUgc3RydWN0LCB1bmxlc3MgaXQncyBh
IHZlcnkgb2xkIGtlcm5lbC4gIEFuZCBpdCdzIHNhZmUgdG8gYWx3YXlzIHJldHVybiB6ZXJvIGlm
DQo+IHRoZSBiaXQgaXMgbm90IHByZXNlbnQuDQo+IA0KDQpJIHRoaW5rIGNhbGxpbmcgX2t2bV92
Y3B1X2lzX3ByZWVtcHRlZCBzaG91bGQgYmUgYXZvaWQgaW4gc29tZSB1bm5lY2Vzc2FyeSBjb25k
aXRpb24sIGxpa2Ugbm8gdW5oYWx0LCB3aGljaCBtZWFucyB0aGF0IHZjcHUgZG8gbm90IGV4aXQg
Zm9yIGhsdCBhbmQgdmNwdSBpcyBub3QgcHJlZW1wdGVkPw0KDQotTGkgDQo=
