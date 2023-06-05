Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C045E721C90
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 05:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbjFEDcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 23:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjFEDcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 23:32:04 -0400
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D5ADA
        for <kvm@vger.kernel.org>; Sun,  4 Jun 2023 20:32:01 -0700 (PDT)
From:   "Gao,Shiyuan" <gaoshiyuan@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "likexu@tencent.com" <likexu@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL
 bit35
Thread-Topic: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL
 bit35
Thread-Index: AQHZlSA236Yp8ieRpkixDzR0VME6kq93U/yAgAAJJgCAAAPSAIAAJp0AgAAN2wCAAAP3gIAD+L6A
Date:   Mon, 5 Jun 2023 03:31:19 +0000
Message-ID: <60D403B7-71FF-4DC9-8318-C789D53271B5@baidu.com>
References: <20230602070224.92861-1-gaoshiyuan@baidu.com>
 <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com>
 <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
 <ZHpjrOcT4r+Wj+2D@google.com>
 <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
 <ZHpyn7GqM0O0QkwO@google.com>
In-Reply-To: <ZHpyn7GqM0O0QkwO@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.192.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <617C484BAA4FA7468EACC6FA5C85FCF8@internal.baidu.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.22
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

T24gRnJpLCBKdW4gMywgMjAyMyBhdCA2OjUyIEFNIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tIDxtYWlsdG86c2VhbmpjQGdvb2dsZS5jb20+PiB3cm90ZToNCg0KPiBPbiBG
cmksIEp1biAwMiwgMjAyMywgSmltIE1hdHRzb24gd3JvdGU6DQo+ID4gT24gRnJpLCBKdW4gMiwg
MjAyMyBhdCAyOjQ4IFBNIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tIDxt
YWlsdG86c2VhbmpjQGdvb2dsZS5jb20+PiB3cm90ZToNCj4gPiA+DQo+ID4gPiBPbiBGcmksIEp1
biAwMiwgMjAyMywgSmltIE1hdHRzb24gd3JvdGU6DQo+ID4gPiA+IE9uIEZyaSwgSnVuIDIsIDIw
MjMgYXQgMTI6MTYgUE0gU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20gPG1h
aWx0bzpzZWFuamNAZ29vZ2xlLmNvbT4+IHdyb3RlOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT24g
RnJpLCBKdW4gMDIsIDIwMjMsIEppbSBNYXR0c29uIHdyb3RlOg0KPiA+ID4gPiA+ID4gT24gRnJp
LCBKdW4gMiwgMjAyMyBhdCAxMjoxOCBBTSBHYW8gU2hpeXVhbiA8Z2Fvc2hpeXVhbkBiYWlkdS5j
b20gPG1haWx0bzpnYW9zaGl5dWFuQGJhaWR1LmNvbT4+IHdyb3RlOg0KPiA+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gPiBGcm9tOiBTaGl5dWFuIEdhbyA8Z2Fvc2hpeXVhbkBiYWlkdS5jb20gPG1h
aWx0bzpnYW9zaGl5dWFuQGJhaWR1LmNvbT4+DQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+
IFdoZW4gbGl2ZS1taWdyYXRlIFZNIG9uIGljZWxha2UgbWljcm9hcmNoaXRlY3R1cmUsIGlmIHRo
ZSBzb3VyY2UNCj4gPiA+ID4gPiA+ID4gaG9zdCBrZXJuZWwgYmVmb3JlIGNvbW1pdCAyZThjZDdh
M2I4MjggKCJrdm06IHg4NjogbGltaXQgdGhlIG1heGltdW0NCj4gPiA+ID4gPiA+ID4gbnVtYmVy
IG9mIHZQTVUgZml4ZWQgY291bnRlcnMgdG8gMyIpIGFuZCB0aGUgZGVzdCBob3N0IGtlcm5lbCBh
ZnRlciB0aGlzDQo+ID4gPiA+ID4gPiA+IGNvbW1pdCwgdGhlIG1pZ3JhdGlvbiB3aWxsIGZhaWwu
DQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IFRoZSBzb3VyY2UgVk0ncyBDUFVJRC4weEEu
ZWR4WzAuLjRdPTQgdGhhdCBpcyByZXBvcnRlZCBieSBLVk0gYW5kDQo+ID4gPiA+ID4gPiA+IHRo
ZSBJQTMyX1BFUkZfR0xPQkFMX0NUUkwgTVNSIGlzIDB4ZjAwMDAwMGZmLiBIb3dldmVyIHRoZSBk
ZXN0IFZNJ3MNCj4gPiA+ID4gPiA+ID4gQ1BVSUQuMHhBLmVkeFswLi40XT0zIGFuZCB0aGUgSUEz
Ml9QRVJGX0dMT0JBTF9DVFJMIE1TUiBpcyAweDcwMDAwMDBmZi4NCj4gPiA+ID4gPiA+ID4gVGhp
cyBpbmNvbnNpc3RlbmN5IGxlYWRzIHRvIG1pZ3JhdGlvbiBmYWlsdXJlLg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gSU1PLCB0aGlzIGlzIGEgdXNlcnNwYWNlIGJ1Zy4gS1ZNIHByb3ZpZGVkIHVzZXJz
cGFjZSBhbGwgdGhlIGluZm9ybWF0aW9uIGl0IG5lZWRlZA0KPiA+ID4gPiA+IHRvIGtub3cgdGhh
dCB0aGUgdGFyZ2V0IGlzIGluY29tcGF0aWJsZSAoMyBjb3VudGVycyBpbnN0ZWFkIG9mIDQpLCBp
dCdzIHVzZXJzcGFjZSdzDQo+ID4gPiA+ID4gZmF1bHQgZm9yIG5vdCBzYW5pdHkgY2hlY2tpbmcg
dGhhdCB0aGUgdGFyZ2V0IGlzIGNvbXBhdGlibGUuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJIGFn
cmVlIHRoYXQgS1ZNIGlzbid0IGJsYW1lIGZyZWUsIGJ1dCBoYWNraW5nIEtWTSB0byBjb3ZlciB1
cCB1c2Vyc3BhY2UgbWlzdGFrZXMNCj4gPiA+ID4gPiBldmVyeXRpbWUgYSBmZWF0dXJlIGFwcGVh
cnMgb3IgZGlzYXBwZWFycyBhY3Jvc3Mga2VybmVsIHZlcnNpb25zIG9yIGNvbmZpZ3MgaXNuJ3QN
Cj4gPiA+ID4gPiBtYWludGFpbmFibGUuDQo+ID4gPiA+DQp5ZWFoLCB0aGlzIGlzIHVzZXJzcGFj
ZSdzIGZhdWx0LCBJIGFsc28gc3VibW1pdCBhIHBhdGNoIHRvIFFFTVU6DQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vMjAyMzA2MDIwNzM4NTcuOTY3OTAtMS1nYW9zaGl5dWFuQGJhaWR1LmNv
bS9ULyN1DQoNCj4gPiA+ID4NCj4gPiA+ID4gIllvdSBtYXkgbmV2ZXIgbWlncmF0ZSB0aGlzIFZN
IHRvIGEgbmV3ZXIga2VybmVsLiBTdWNrcyB0byBiZSB5b3UuIg0KPiA+ID4NCj4gPiA+IFVzZXJz
cGFjZSBjYW4gZnVkZ2UvZml4dXAgc3RhdGUgdG8gbWlncmF0ZSB0aGUgVk0uDQo+ID4NCj4gPiBV
bSwgeWVhaC4gVXNlcnNwYWNlIGNhbiBjbGVhciBiaXQgMzUgZnJvbSB0aGUgc2F2ZWQNCj4gPiBJ
QTMyX1BFUkZfR0xPQkFMX0NUUkwgTVNSIHNvIHRoYXQgdGhlIG1pZ3JhdGlvbiB3aWxsIGNvbXBs
ZXRlLiBCdXQNCj4gPiB3aGF0IGhhcHBlbnMgdGhlIG5leHQgdGltZSB0aGUgZ3Vlc3QgdHJpZXMg
dG8gc2V0IGJpdCAzNSBpbg0KPiA+IElBMzJfUEVSRl9HTE9CQUxfQ1RSTCwgd2hpY2ggaXQgd2ls
bCBwcm9iYWJseSBkbywgc2luY2UgaXQgY2FjaGVkDQo+ID4gQ1BVSUQuMEFIIGF0IGJvb3Q/DQo+
DQo+DQo+IEFoLCByaWdodC4gWWVhaCwgZ3Vlc3QgaXMgaG9zZWQuDQo+DQo+DQo+IEknbSBzdGls
bCBub3QgY29udmluY2VkIHRoaXMgaXMgS1ZNJ3MgcHJvYmxlbSB0byBmaXguDQo+DQpJIHRyaWVk
IHRvIGNsZWFyIGJpdCAzNSBpbiB1c2Vyc3BhY2UgZHVyaW5nIHRoZSBtaWdyYXRpb24gcHJvY2Vz
cywgdGhlIG1pZ3JhdGlvbiBpcyBzdWNjZXNzZnVsLg0KSG93ZXZlciwgdGhlIHBlcmYgY2Fubid0
IGJlIHVzZWQgaW4gdGhlIGRlc3QgVk0uDQoNCkkgYWRtaXQgdGhhdCBmaXhlZCB0aGlzIHByb2Js
ZW0gaW4gS1ZNIGlzIHVuc3VpdGFibGUuIEkgY2FuJ3QgZmluZCBhbnkgYmV0dGVyIHdheS4NCg0K
