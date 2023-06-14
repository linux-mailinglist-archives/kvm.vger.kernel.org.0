Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D2072FED6
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243967AbjFNMhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbjFNMhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:37:13 -0400
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1466418E
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 05:37:11 -0700 (PDT)
From:   "Gao,Shiyuan" <gaoshiyuan@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jim Mattson <jmattson@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "likexu@tencent.com" <likexu@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL
 bit35
Thread-Topic: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL
 bit35
Thread-Index: AQHZlSA236Yp8ieRpkixDzR0VME6kq93U/yAgAAJJgCAAAPSAIAAJp0AgAAN2wCAAAP3gIAABL8AgAP6RoCADStpAIABi5GA
Date:   Wed, 14 Jun 2023 12:36:20 +0000
Message-ID: <6BA15AF0-55E8-4167-83F6-83A84F58F137@baidu.com>
References: <20230602070224.92861-1-gaoshiyuan@baidu.com>
 <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com>
 <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
 <ZHpjrOcT4r+Wj+2D@google.com>
 <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
 <ZHpyn7GqM0O0QkwO@google.com>
 <CALMp9eQq8a=53WfoTUYdaPCZ_CO5KDUodzgw=0J2Y8erUirvag@mail.gmail.com>
 <4C71D912-E6D2-4391-9DCB-FB13AE1D74D3@baidu.com>
 <ZIjY0vmsejATbbIG@google.com>
In-Reply-To: <ZIjY0vmsejATbbIG@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.192.93]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFCE6DDCE5FA574C9722C7B1FF8DE18B@internal.baidu.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.16
X-FE-Last-Public-Client-IP: 100.100.100.60
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjAyMy82LzE0IGF0IDU6MDAgQU3vvIxTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbSA8bWFpbHRvOnNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCg0KPiBPbiBNb24sIEp1
biAwNSwgMjAyMywgR2FvLFNoaXl1YW4gd3JvdGU6DQo+DQo+ID4gT24gRnJpLCBKdW4gMywgMjAy
MywgSmltIE1hdHRzb24gd3JvdGU6DQo+ID4NCj4gPiA+IE9uIEZyaSwgSnVuIDIsIDIwMjMgYXQg
Mzo1MiBQTSBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbSA8bWFpbHRvOnNl
YW5qY0Bnb29nbGUuY29tPiA8bWFpbHRvOnNlYW5qY0Bnb29nbGUuY29tIDxtYWlsdG86c2Vhbmpj
QGdvb2dsZS5jb20+Pj4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IE9uIEZyaSwgSnVuIDAyLCAy
MDIzLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4gPiA+ID4gPiBPbiBGcmksIEp1biAyLCAyMDIzIGF0
IDI6NDggUE0gU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20gPG1haWx0bzpz
ZWFuamNAZ29vZ2xlLmNvbT4gPG1haWx0bzpzZWFuamNAZ29vZ2xlLmNvbSA8bWFpbHRvOnNlYW5q
Y0Bnb29nbGUuY29tPj4+IHdyb3RlOg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IE9uIEZyaSwg
SnVuIDAyLCAyMDIzLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4gPiA+ID4gPiBVbSwgeWVhaC4gVXNl
cnNwYWNlIGNhbiBjbGVhciBiaXQgMzUgZnJvbSB0aGUgc2F2ZWQNCj4gPiA+ID4gPiBJQTMyX1BF
UkZfR0xPQkFMX0NUUkwgTVNSIHNvIHRoYXQgdGhlIG1pZ3JhdGlvbiB3aWxsIGNvbXBsZXRlLiBC
dXQNCj4gPiA+ID4gPiB3aGF0IGhhcHBlbnMgdGhlIG5leHQgdGltZSB0aGUgZ3Vlc3QgdHJpZXMg
dG8gc2V0IGJpdCAzNSBpbg0KPiA+ID4gPiA+IElBMzJfUEVSRl9HTE9CQUxfQ1RSTCwgd2hpY2gg
aXQgd2lsbCBwcm9iYWJseSBkbywgc2luY2UgaXQgY2FjaGVkDQo+ID4gPiA+ID4gQ1BVSUQuMEFI
IGF0IGJvb3Q/DQo+ID4gPiA+DQo+ID4gPiA+IEFoLCByaWdodC4gWWVhaCwgZ3Vlc3QgaXMgaG9z
ZWQuDQo+ID4gPiA+DQo+ID4gPiA+IEknbSBzdGlsbCBub3QgY29udmluY2VkIHRoaXMgaXMgS1ZN
J3MgcHJvYmxlbSB0byBmaXguDQo+ID4gPg0KPiA+ID4gT25lIGNvdWxkIGFyZ3VlIHRoYXQgdXNl
cnNwYWNlIHNob3VsZCBoYXZlIGtub3duIGJldHRlciB0aGFuIHRvDQo+ID4gPiBiZWxpZXZlIEtW
TV9HRVRfU1VQUE9SVEVEX0NQVUlEIGluIHRoZSBmaXJzdCBwbGFjZS4gT3IgdGhhdCBpdCBzaG91
bGQNCj4gPiA+IGhhdmUga25vd24gYmV0dGVyIHRoYW4gdG8gYmxpbmRseSBwYXNzIHRoYXQgdGhy
b3VnaCB0byBLVk1fU0VUX0NQVUlEMi4NCj4gPiA+IEkgbWVhbiwgKm9idmlvdXNseSogS1ZNIGRp
ZG4ndCByZWFsbHkgc3VwcG9ydCBUT1BET1dOLlNMT1RTLiBSaWdodD8NCj4gPiA+DQo+ID4gPg0K
PiA+ID4gQnV0IGlmIHVzZXJzcGFjZSBjYW4ndCB0cnVzdCBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJ
RCB0byB0ZWxsIGl0IGFib3V0DQo+ID4gPiB3aGljaCBmaXhlZCBjb3VudGVycyBhcmUgc3VwcG9y
dGVkLCBob3cgaXMgaXQgc3VwcG9zZWQgdG8gZmluZCBvdXQ/DQo+ID4gPg0KPiA+ID4NCj4gPiA+
IEFub3RoZXIgd2F5IG9mIHNvbHZpbmcgdGhpcywgd2hpY2ggc2hvdWxkIG1ha2UgZXZlcnlvbmUg
aGFwcHksIGlzIHRvDQo+ID4gPiBhZGQgS1ZNIHN1cHBvcnQgZm9yIFRPUERPV04uU0xPVFMuDQo+
ID4gPg0KPiA+IFllYWgsIHRoaXMgd2F5IG1heSBtYWtlIGV2ZXJ5b25lIGhhcHBseSwgYnV0IHdl
IG5lZWQgZ3VhcmFudGVlIHRoZSBWTSB0aGF0DQo+ID4gbm90IHN1cHBvcnQgVE9QRE9XTi5TTE9U
UyBtaWdyYXRlIHN1Y2Nlc3MuIEkgdGhpbmsgdGhpcyBhbHNvIG5lZWQgYmUgYWRkcmVzc2VkDQo+
ID4gd2l0aCBhIHF1aXJrIGxpa2UgdGhpcyBzdWJtbWl0Lg0KPiA+DQo+ID4gSSBjYW4ndCBmaW5k
IGFuIGVsZWdhbnQgc29sdXRpb24uLi4NCj4NCj4NCj4gSSBjYW4ndCB0aGluayBvZiBhbiBlbGVn
YW50IHNvbHV0aW9uIGVpdGhlci4gVGhhdCBzYWlkLCBJIHN0aWxsIGRvbid0IHRoaW5rIHdlDQo+
IHNob3VsZCBhZGQgYSBxdWlyayB0byB1cHN0cmVhbSBLVk0uIFRoaXMgaXMgbm90IGEgbG9uZ3N0
YW5kaW5nIEtWTSBnb29mIHRoYXQNCj4gdXNlcnNwYWNlIGhhcyBjb21lIHRvIHJlbHkgb24sIGl0
J3MgYSBjb21iaW5hdGlvbiBvZiBidWdzIGluIEtWTSwgUUVNVSwgYW5kIHRoZQ0KPiBkZXBsb3lt
ZW50IChmb3IgcHJlc3VtYWJseSBub3QgdmFsaWRhdGluZyBiZWZvcmUgcHVzaGluZyB0byBwcm9k
dWN0aW9uKS4gQW5kIHRoZQ0KPiBpc3N1ZSBhZmZlY3RzIGEgb25seSByZWxhdGl2ZWx5IG5ldyBD
UFVzLiBTaWxlbnRseSBzdXBwcmVzc2luZyBhIGtub3duIGJhZCBjb25maWcNCj4gYWxzbyBtYWtl
cyBtZSB1bmNvbWZvcnRhYmxlLCBldmVuIHRob3VnaCBpdCdzIHVubGlrZWx5IHRoYXQgYW55IGRl
cGx5b21lbnQgd291bGQNCj4gcmF0aGVyIHRlcm1pbmF0ZSBWTXMgdGhhbiBydW4gd2l0aCBhIG1l
c3NlZCB1cCB2UE1VLg0KPg0KPg0KPiBJJ20gbm90IGRlYWQgc2V0IGFnYWluc3QgYSBxdWlyaywg
YnV0IHVubGVzcyB0aGUgaXNzdWUgYWZmZWN0cyBhIGJyb2FkIHNldCBvZg0KPiB1c2VycywgSSB3
b3VsZCBwcmVmZXIgdG8gbm90IGNhcnJ5IGFueXRoaW5nIGluIHVwc3RyZWFtLCBhbmQgaW5zdGVh
ZCBoYXZlICh0aGUNCj4gKGhvcGVmdWxseSBzbWFsbCBzZXQgb2YpIHVzZXJzIGNhcnJ5IGFuIG91
dC1vZi10cmVlIGhhY2stYS1maXggdW50aWwgYWxsIHRoZWlyDQo+IGFmZmVjdGVkIFZNcyBhcmUg
cmVib290ZWQgb24gYSBmaXhlZCBLVk0gYW5kL29yIFFFTVUuDQo+DQoNCkFzIGxvbmcgYXMgbGlt
aXQgdGhlIG1heGltdW0gbnVtYmVyIG9mIHZQTVUgZml4ZWQgY291bnRlcnMgdG8gMyBpbiBrdm0s
IEkgdGhpbmsgdGhlDQpjaGVjayBvZiBJQTMyX1BFUkZfR0xPQkFMX0NUUkwgYml0MzUtNjMgaXMg
dW5uZWNlc3NhcnkuDQoNCk1heWJlIGRlZmluZSBhIG1hY3JvIHN1Y2ggYXMgSUEzMl9QRVJGX0dM
T0JBTF9DVFJMX1JFU0VSVkVEIHVuZGVyIE1BWF9GSVhFRF9DT1VOVEVSUywNCmFuZCBpZ25vcmUg
dGhlIGNoZWNrIGZyb20gSUEzMl9QRVJGX0dMT0JBTF9DVFJMX1JFU0VSVkVEIHRvIGJpdDYzLg0K
DQogI2RlZmluZSBNQVhfRklYRURfQ09VTlRFUlMgICAgIDMNCisjZGVmaW5lIElBMzJfUEVSRl9H
TE9CQUxfQ1RSTF9SRVNFUlZFRCAzNQ0KDQogc3RhdGljIGlubGluZSBib29sIGt2bV92YWxpZF9w
ZXJmX2dsb2JhbF9jdHJsKHN0cnVjdCBrdm1fcG11ICpwbXUsDQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTY0IGRhdGEpDQogew0KLSAgICAgICByZXR1
cm4gIShwbXUtPmdsb2JhbF9jdHJsX21hc2sgJiBkYXRhKTsNCisgICAgICAgcmV0dXJuICEocG11
LT5nbG9iYWxfY3RybF9tYXNrICYgKGRhdGEgJiAoMVVMTCA8PCBJQTMyX1BFUkZfR0xPQkFMX0NU
UkxfUkVTRVJWRUQpIC0gMSkpOw0KIH0NCg0KDQo=
