Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36D0721CFE
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 06:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjFEEL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 00:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbjFEELE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 00:11:04 -0400
X-Greylist: delayed 907 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 04 Jun 2023 21:09:25 PDT
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40190E53
        for <kvm@vger.kernel.org>; Sun,  4 Jun 2023 21:09:25 -0700 (PDT)
From:   "Gao,Shiyuan" <gaoshiyuan@baidu.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "likexu@tencent.com" <likexu@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL
 bit35
Thread-Topic: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL
 bit35
Thread-Index: AQHZlSA236Yp8ieRpkixDzR0VME6kq93U/yAgAAJJgCAAAPSAIAAJp0AgAAN2wCAAAP3gIAABL8AgAP6RoA=
Date:   Mon, 5 Jun 2023 03:53:47 +0000
Message-ID: <4C71D912-E6D2-4391-9DCB-FB13AE1D74D3@baidu.com>
References: <20230602070224.92861-1-gaoshiyuan@baidu.com>
 <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com>
 <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
 <ZHpjrOcT4r+Wj+2D@google.com>
 <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
 <ZHpyn7GqM0O0QkwO@google.com>
 <CALMp9eQq8a=53WfoTUYdaPCZ_CO5KDUodzgw=0J2Y8erUirvag@mail.gmail.com>
In-Reply-To: <CALMp9eQq8a=53WfoTUYdaPCZ_CO5KDUodzgw=0J2Y8erUirvag@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.192.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <60D0F5C2F1A45849AB544ECB1E73B177@internal.baidu.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 10.127.64.32
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

T24gRnJpLCBKdW4gMywgMjAyMywgSmltIE1hdHRzb24gd3JvdGU6DQoNCj4gT24gRnJpLCBKdW4g
MiwgMjAyMyBhdCAzOjUyIFBNIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29t
IDxtYWlsdG86c2VhbmpjQGdvb2dsZS5jb20+PiB3cm90ZToNCj4gPg0KPiA+IE9uIEZyaSwgSnVu
IDAyLCAyMDIzLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4gPiA+IE9uIEZyaSwgSnVuIDIsIDIwMjMg
YXQgMjo0OCBQTSBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbSA8bWFpbHRv
OnNlYW5qY0Bnb29nbGUuY29tPj4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IE9uIEZyaSwgSnVu
IDAyLCAyMDIzLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4gPiA+ID4gPiBPbiBGcmksIEp1biAyLCAy
MDIzIGF0IDEyOjE2IFBNIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tIDxt
YWlsdG86c2VhbmpjQGdvb2dsZS5jb20+PiB3cm90ZToNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4g
PiBPbiBGcmksIEp1biAwMiwgMjAyMywgSmltIE1hdHRzb24gd3JvdGU6DQo+ID4gPiA+ID4gPiA+
IE9uIEZyaSwgSnVuIDIsIDIwMjMgYXQgMTI6MTggQU0gR2FvIFNoaXl1YW4gPGdhb3NoaXl1YW5A
YmFpZHUuY29tIDxtYWlsdG86Z2Fvc2hpeXVhbkBiYWlkdS5jb20+PiB3cm90ZToNCj4gPiA+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+IEZyb206IFNoaXl1YW4gR2FvIDxnYW9zaGl5dWFuQGJh
aWR1LmNvbSA8bWFpbHRvOmdhb3NoaXl1YW5AYmFpZHUuY29tPj4NCj4gPiA+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gPiA+IFdoZW4gbGl2ZS1taWdyYXRlIFZNIG9uIGljZWxha2UgbWljcm9hcmNo
aXRlY3R1cmUsIGlmIHRoZSBzb3VyY2UNCj4gPiA+ID4gPiA+ID4gPiBob3N0IGtlcm5lbCBiZWZv
cmUgY29tbWl0IDJlOGNkN2EzYjgyOCAoImt2bTogeDg2OiBsaW1pdCB0aGUgbWF4aW11bQ0KPiA+
ID4gPiA+ID4gPiA+IG51bWJlciBvZiB2UE1VIGZpeGVkIGNvdW50ZXJzIHRvIDMiKSBhbmQgdGhl
IGRlc3QgaG9zdCBrZXJuZWwgYWZ0ZXIgdGhpcw0KPiA+ID4gPiA+ID4gPiA+IGNvbW1pdCwgdGhl
IG1pZ3JhdGlvbiB3aWxsIGZhaWwuDQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiBU
aGUgc291cmNlIFZNJ3MgQ1BVSUQuMHhBLmVkeFswLi40XT00IHRoYXQgaXMgcmVwb3J0ZWQgYnkg
S1ZNIGFuZA0KPiA+ID4gPiA+ID4gPiA+IHRoZSBJQTMyX1BFUkZfR0xPQkFMX0NUUkwgTVNSIGlz
IDB4ZjAwMDAwMGZmLiBIb3dldmVyIHRoZSBkZXN0IFZNJ3MNCj4gPiA+ID4gPiA+ID4gPiBDUFVJ
RC4weEEuZWR4WzAuLjRdPTMgYW5kIHRoZSBJQTMyX1BFUkZfR0xPQkFMX0NUUkwgTVNSIGlzIDB4
NzAwMDAwMGZmLg0KPiA+ID4gPiA+ID4gPiA+IFRoaXMgaW5jb25zaXN0ZW5jeSBsZWFkcyB0byBt
aWdyYXRpb24gZmFpbHVyZS4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBJTU8sIHRoaXMgaXMg
YSB1c2Vyc3BhY2UgYnVnLiBLVk0gcHJvdmlkZWQgdXNlcnNwYWNlIGFsbCB0aGUgaW5mb3JtYXRp
b24gaXQgbmVlZGVkDQo+ID4gPiA+ID4gPiB0byBrbm93IHRoYXQgdGhlIHRhcmdldCBpcyBpbmNv
bXBhdGlibGUgKDMgY291bnRlcnMgaW5zdGVhZCBvZiA0KSwgaXQncyB1c2Vyc3BhY2Uncw0KPiA+
ID4gPiA+ID4gZmF1bHQgZm9yIG5vdCBzYW5pdHkgY2hlY2tpbmcgdGhhdCB0aGUgdGFyZ2V0IGlz
IGNvbXBhdGlibGUuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSSBhZ3JlZSB0aGF0IEtWTSBp
c24ndCBibGFtZSBmcmVlLCBidXQgaGFja2luZyBLVk0gdG8gY292ZXIgdXAgdXNlcnNwYWNlIG1p
c3Rha2VzDQo+ID4gPiA+ID4gPiBldmVyeXRpbWUgYSBmZWF0dXJlIGFwcGVhcnMgb3IgZGlzYXBw
ZWFycyBhY3Jvc3Mga2VybmVsIHZlcnNpb25zIG9yIGNvbmZpZ3MgaXNuJ3QNCj4gPiA+ID4gPiA+
IG1haW50YWluYWJsZS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFVtLi4uDQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiAiWW91IG1heSBuZXZlciBtaWdyYXRlIHRoaXMgVk0gdG8gYSBuZXdlciBrZXJuZWwu
IFN1Y2tzIHRvIGJlIHlvdS4iDQo+ID4gPiA+DQo+ID4gPiA+IFVzZXJzcGFjZSBjYW4gZnVkZ2Uv
Zml4dXAgc3RhdGUgdG8gbWlncmF0ZSB0aGUgVk0uDQo+ID4gPg0KPiA+ID4gVW0sIHllYWguIFVz
ZXJzcGFjZSBjYW4gY2xlYXIgYml0IDM1IGZyb20gdGhlIHNhdmVkDQo+ID4gPiBJQTMyX1BFUkZf
R0xPQkFMX0NUUkwgTVNSIHNvIHRoYXQgdGhlIG1pZ3JhdGlvbiB3aWxsIGNvbXBsZXRlLiBCdXQN
Cj4gPiA+IHdoYXQgaGFwcGVucyB0aGUgbmV4dCB0aW1lIHRoZSBndWVzdCB0cmllcyB0byBzZXQg
Yml0IDM1IGluDQo+ID4gPiBJQTMyX1BFUkZfR0xPQkFMX0NUUkwsIHdoaWNoIGl0IHdpbGwgcHJv
YmFibHkgZG8sIHNpbmNlIGl0IGNhY2hlZA0KPiA+ID4gQ1BVSUQuMEFIIGF0IGJvb3Q/DQo+ID4N
Cj4gPiBBaCwgcmlnaHQuIFllYWgsIGd1ZXN0IGlzIGhvc2VkLg0KPiA+DQo+ID4gSSdtIHN0aWxs
IG5vdCBjb252aW5jZWQgdGhpcyBpcyBLVk0ncyBwcm9ibGVtIHRvIGZpeC4NCj4NCj4NCj4gT25l
IGNvdWxkIGFyZ3VlIHRoYXQgdXNlcnNwYWNlIHNob3VsZCBoYXZlIGtub3duIGJldHRlciB0aGFu
IHRvDQo+IGJlbGlldmUgS1ZNX0dFVF9TVVBQT1JURURfQ1BVSUQgaW4gdGhlIGZpcnN0IHBsYWNl
LiBPciB0aGF0IGl0IHNob3VsZA0KPiBoYXZlIGtub3duIGJldHRlciB0aGFuIHRvIGJsaW5kbHkg
cGFzcyB0aGF0IHRocm91Z2ggdG8gS1ZNX1NFVF9DUFVJRDIuDQo+IEkgbWVhbiwgKm9idmlvdXNs
eSogS1ZNIGRpZG4ndCByZWFsbHkgc3VwcG9ydCBUT1BET1dOLlNMT1RTLiBSaWdodD8NCj4NCj4N
Cj4gQnV0IGlmIHVzZXJzcGFjZSBjYW4ndCB0cnVzdCBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRCB0
byB0ZWxsIGl0IGFib3V0DQo+IHdoaWNoIGZpeGVkIGNvdW50ZXJzIGFyZSBzdXBwb3J0ZWQsIGhv
dyBpcyBpdCBzdXBwb3NlZCB0byBmaW5kIG91dD8NCj4NCj4NCj4gQW5vdGhlciB3YXkgb2Ygc29s
dmluZyB0aGlzLCB3aGljaCBzaG91bGQgbWFrZSBldmVyeW9uZSBoYXBweSwgaXMgdG8NCj4gYWRk
IEtWTSBzdXBwb3J0IGZvciBUT1BET1dOLlNMT1RTLg0KPg0KWWVhaCwgdGhpcyB3YXkgbWF5IG1h
a2UgZXZlcnlvbmUgaGFwcGx5LCBidXQgd2UgbmVlZCBndWFyYW50ZWUgdGhlIFZNIHRoYXQNCm5v
dCBzdXBwb3J0IFRPUERPV04uU0xPVFMgbWlncmF0ZSBzdWNjZXNzLiBJIHRoaW5rIHRoaXMgYWxz
byBuZWVkIGJlIGFkZHJlc3NlZA0Kd2l0aCBhIHF1aXJrIGxpa2UgdGhpcyBzdWJtbWl0Lg0KDQpJ
IGNhbid0IGZpbmQgYW4gZWxlZ2FudCBzb2x1dGlvbi4uLg0KDQo=
