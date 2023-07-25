Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE67D76038D
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 02:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjGYAFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 20:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGYAFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 20:05:51 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1811729;
        Mon, 24 Jul 2023 17:05:45 -0700 (PDT)
Received: from lhrpeml500006.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R8xzY3f0Wz67yc8;
        Tue, 25 Jul 2023 08:02:17 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 01:05:43 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Tue, 25 Jul 2023 01:05:43 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        "steven.price@arm.com" <steven.price@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Salil Mehta" <salil.mehta@opnsrc.net>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        yuzenghui <yuzenghui@huawei.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gareth Stockwell <Gareth.Stockwell@arm.com>
Subject: RE: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
Thread-Topic: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
Thread-Index: Adm55YYLPryt1tEKR0alBn01xBiFBwANXi2AAQoU7gAAA+aEUA==
Date:   Tue, 25 Jul 2023 00:05:43 +0000
Message-ID: <93c9c8356e444fb287393a935a8c7899@huawei.com>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
        <7da93c6e-1cbf-8840-282e-f115197b80c4@arm.com>
 <0d268afa-c04b-7a4e-be5e-2362d3dfa64d@arm.com>
In-Reply-To: <0d268afa-c04b-7a4e-be5e-2362d3dfa64d@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.173.65]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgU3V6dWtpLA0KU29ycnkgZm9yIHJlcGx5aW5nIGxhdGUgYXMgSSB3YXMgb24vb2ZmIGxhc3Qg
d2VlayB0byB1bmRlcmdvIHNvbWUgbWVkaWNhbCB0ZXN0Lg0KDQoNCj4gRnJvbTogU3V6dWtpIEsg
UG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKdWx5IDI0
LCAyMDIzIDU6MjcgUE0NCj4gDQo+IEhpIFNhbGlsDQo+IA0KPiBPbiAxOS8wNy8yMDIzIDEwOjI4
LCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOg0KPiA+IEhpIFNhbGlsDQo+ID4NCj4gPiBUaGFua3Mg
Zm9yIHJhaXNpbmcgdGhpcy4NCj4gPg0KPiA+IE9uIDE5LzA3LzIwMjMgMDM6MzUsIFNhbGlsIE1l
aHRhIHdyb3RlOg0KPiA+PiBbUmVwb3N0aW5nIGl0IGhlcmUgZnJvbSBMaW5hcm8gT3BlbiBEaXNj
dXNzaW9uIExpc3QgZm9yIG1vcmUgZXllcyB0bw0KPiA+PiBsb29rIGF0XQ0KPiA+Pg0KPiA+PiBI
ZWxsbywNCj4gPj4gSSBoYXZlIHJlY2VudGx5IHN0YXJ0ZWQgdG8gZGFiYmxlIHdpdGggQVJNIEND
QSBzdHVmZiBhbmQgY2hlY2sgaWYgb3VyDQo+ID4+IHJlY2VudCBjaGFuZ2VzIHRvIHN1cHBvcnQg
dkNQVSBIb3RwbHVnIGluIEFSTTY0IGNhbiB3b3JrIGluIHRoZSByZWFsbQ0KPiA+PiB3b3JsZC4g
SSBoYXZlIHJlYWxpemVkIHRoYXQgaW4gdGhlIFJNTSBzcGVjaWZpY2F0aW9uWzFdIFBTQ0lfQ1BV
X09ODQo+ID4+IGNvbW1hbmQoQjUuMy4zKSBkb2VzIG5vdCBoYW5kbGVzIHRoZSBQU0NJX0RFTklF
RCByZXR1cm4gY29kZShCNS40LjIpLA0KPiA+PiBmcm9tIHRoZSBob3N0LiBUaGlzIG1pZ2h0IGJl
IHJlcXVpcmVkIHRvIHN1cHBvcnQgdkNQVSBIb3RwbHVnIGZlYXR1cmUNCj4gPj4gaW4gdGhlIHJl
YWxtIHdvcmxkIGluIGZ1dHVyZS4gdkNQVSBIb3RwbHVnIGlzIGFuIGltcG9ydGFudCBmZWF0dXJl
IHRvDQo+ID4+IHN1cHBvcnQga2F0YS1jb250YWluZXJzIGluIHJlYWxtIHdvcmxkIGFzIGl0IHJl
ZHVjZXMgdGhlIFZNIGJvb3QgdGltZQ0KPiA+PiBhbmQgZmFjaWxpdGF0ZXMgZHluYW1pYyBhZGp1
c3RtZW50IG9mIHZDUFVzICh3aGljaCBJIHRoaW5rIHNob3VsZCBiZQ0KPiA+PiB0cnVlIGV2ZW4g
d2l0aCBSZWFsbSB3b3JsZCBhcyBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9ubHkgbWFrZXMgdXNl
DQo+ID4+IG9mIHRoZSBQU0NJX09OL09GRiB0byByZWFsaXplIHRoZSBIb3RwbHVnIGxvb2stbGlr
ZSBlZmZlY3Q/KQ0KPiA+Pg0KPiA+Pg0KPiA+PiBBcyBwZXIgb3VyIHJlY2VudCBjaGFuZ2VzIFsy
XSwgWzNdIHJlbGF0ZWQgdG8gc3VwcG9ydCB2Q1BVIEhvdHBsdWcgb24NCj4gPj4gQVJNNjQsIHdl
IGhhbmRsZSB0aGUgZ3Vlc3QgZXhpdHMgZHVlIHRvIFNNQy9IVkMgSHlwZXJjYWxsIGluIHRoZQ0K
PiA+PiB1c2VyLXNwYWNlIGkuZS4gVk1NL1FlbXUuIEluIHJlYWxtIHdvcmxkLCBSRUMgRXhpdHMg
dG8gaG9zdCBkdWUgdG8NCj4gPj4gUFNDSV9DUFVfT04gc2hvdWxkIHVuZGVyZ28gc2ltaWxhciBw
b2xpY3kgY2hlY2tzIGFuZCBJIHRoaW5rLA0KPiA+Pg0KPiA+PiAxLiBIb3N0IHNob3VsZCAqZGVu
eSogdG8gb25saW5lIHRoZSB0YXJnZXQgdkNQVXMgd2hpY2ggYXJlIE5PVCBwbHVnZ2VkDQo+ID4+
IDIuIFRoaXMgbWVhbnMgdGFyZ2V0IFJFQyBzaG91bGQgYmUgZGVuaWVkIGJ5IGhvc3QuIENhbiBo
b3N0IGNhbGwNCj4gPj4gwqDCoMKgIFJNSV9QU0NJX0NPTVBFVEUgaW4gc3VjaCBzIGNhc2U/DQo+
ID4+IDMuIFRoZSAqcmV0dXJuKiB2YWx1ZSAoQjUuMy4zLjEuMyBPdXRwdXQgdmFsdWVzKSBzaG91
bGQgYmUgUFNDSV9ERU5JRUQNCj4gPg0KPiA+IFRoZSBSZWFsbSBleGl0IHdpdGggRVhJVF9QU0NJ
IGFscmVhZHkgcHJvdmlkZXMgdGhlIHBhcmFtZXRlcnMgcGFzc2VkDQo+ID4gb250byB0aGUgUFND
SSByZXF1ZXN0LiBUaGlzIGhhcHBlbnMgZm9yIGFsbCBQU0NJIGNhbGxzIGV4Y2VwdA0KPiA+IChQ
U0NJX1ZFUlNJT04gYW5kIFBTQ0lfRkVBVVRSRVMpLiBUaGUgaHlwIGNvdWxkIGZvcndhcmQgdGhl
c2UgZXhpdHMgdG8NCj4gPiB0aGUgVk1NIGFuZCBjb3VsZCBpbnZva2UgdGhlIFJNSV9QU0NJX0NP
TVBMRVRFIG9ubHkgd2hlbiB0aGUgVk1NIGJsZXNzZXMNCj4gPiB0aGUgcmVxdWVzdCAod2hlcmV2
ZXIgYXBwbGljYWJsZSkuDQo+ID4NCj4gPiBIb3dldmVyLCB0aGUgUk1NIHNwZWMgY3VycmVudGx5
IGRvZXNuJ3QgYWxsb3cgZGVueWluZyB0aGUgcmVxdWVzdC4NCj4gPiBpLmUuLCB3aXRob3V0IFJN
SV9QU0NJX0NPTVBMRVRFLCB0aGUgUkVDIGNhbm5vdCBiZSBzY2hlZHVsZWQgYmFjayBpbi4NCj4g
PiBXZSB3aWxsIGFkZHJlc3MgdGhpcyBpbiB0aGUgUk1NIHNwZWMgYW5kIGdldCBiYWNrIHRvIHlv
dS4NCj4gDQo+IFRoaXMgaXMgbm93IHJlc29sdmVkIGluIFJNTXYxLjAtZWFjMyBzcGVjLCBhdmFp
bGFibGUgaGVyZSBbMF0uDQo+IA0KPiBUaGlzIGFsbG93cyB0aGUgaG9zdCB0byBERU5ZIGEgUFND
SV9DUFVfT04gcmVxdWVzdC4gVGhlIFJNTSBlbnN1cmVzIHRoYXQNCj4gdGhlIHJlc3BvbnNlIGRv
ZXNuJ3QgdmlvbGF0ZSB0aGUgc2VjdXJpdHkgZ3VhcmFudGVlcyBieSBjaGVja2luZyB0aGUNCj4g
c3RhdGUgb2YgdGhlIHRhcmdldCBSRUMuDQo+IA0KPiBbMF0gaHR0cHM6Ly9kZXZlbG9wZXIuYXJt
LmNvbS9kb2N1bWVudGF0aW9uL2RlbjAxMzcvbGF0ZXN0Lw0KDQoNCk1hbnkgdGhhbmtzIGZvciB0
YWtpbmcgdGhpcyB1cCBwcm9hY3RpdmVseSBhbmQgZ2V0dGluZyBpdCBkb25lIGFzIHdlbGwNCnZl
cnkgZWZmaWNpZW50bHkuIFJlYWxseSBhcHByZWNpYXRlIHRoaXMhDQoNCkkgYWNrbm93bGVkZ2Ug
YmVsb3cgbmV3IGNoYW5nZXMgcGFydCBvZiB0aGUgbmV3bHkgcmVsZWFzZWQgUk1NDQpTcGVjaWZp
Y2F0aW9uIFszXSAoUGFnZS0yKSAoUmVsZWFzZSBJbmZvcm1hdGlvbiAxLjAtZWFjMyAyMC0wNy0y
MDIzKToNCg0KMS4gQWRkaXRpb24gb2YgQjIuMTkgUHNjaVJldHVybkNvZGVQZXJtaXR0ZWQgZnVu
Y3Rpb24gWzNdIChQYWdlLTEyNikNCjIuIEFkZGl0aW9uIG9mICdzdGF0dXMnIGluIEIzLjMuNy4y
IEZhaWx1cmUgY29uZGl0aW9ucyBvZiB0aGUNCiAgIEIzLjMuNyBSTUlfUFNDSV9DT01QTEVURSBj
b21tYW5kIFszXSAoUGFnZS0xNjApDQoNCg0KU29tZSBGdXJ0aGVyIFN1Z2dlc3Rpb25zOg0KMS4g
SXQgd291bGQgYmUgcmVhbGx5IGhlbHBmdWwgaWYgUFNDSV9ERU5JRUQgY2FuIGJlIGFjY29tbW9k
YXRlZCBzb21ld2hlcmUNCiAgIGluIHRoZSBmbG93IGRpYWdyYW0gKEQxLjQuMSBQU0NJX0NQVV9P
TiBmbG93KSBbM10gKFBhZ2UtMjk3KSBhcyB3ZWxsLg0KMi4gWW91IHdvdWxkIG5lZWQgY2hhbmdl
cyB0byBoYW5kbGUgdGhlIHJldHVybiB2YWx1ZSBvZiB0aGUgUFNDSV9ERU5JRUQNCiAgIGluIHRo
aXMgYmVsb3cgcGF0Y2ggWzJdIGFzIHdlbGwgZnJvbSBBUk0gQ0NBIHNlcmllcyBbMV0gDQoNCg0K
QEphbWVzLCBBbnkgZnVydGhlciB0aG91Z2h0cyBvbiB0aGlzPw0KDQoNClJlZmVyZW5jZXM6DQpb
MV0gW1JGQyBQQVRDSCAwMC8yOF0gYXJtNjQ6IFN1cHBvcnQgZm9yIEFybSBDQ0EgaW4gS1ZNDQpb
Ml0gW1JGQyBQQVRDSCAxOS8yOF0gS1ZNOiBhcm02NDogVmFsaWRhdGUgcmVnaXN0ZXIgYWNjZXNz
IGZvciBhIFJlYWxtIFZNDQogICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMzAx
MjcxMTIyNDguMTM2ODEwLTEtc3V6dWtpLnBvdWxvc2VAYXJtLmNvbS9ULyNtNmMxMGI5YTI3YzRh
NzI0OTY3YzE4MDBmYWNhY2FhOTQ0M2IzOGI0Yw0KWzNdIEFSTSBSZWFsbSBNYW5hZ2VtZW50IE1v
bml0b3Igc3BlY2lmaWNhdGlvbihERU4wMTM3IDEuMC1lYWMzKQ0KICAgIGh0dHBzOi8vZGV2ZWxv
cGVyLmFybS5jb20vZG9jdW1lbnRhdGlvbi9kZW4wMTM3L2xhdGVzdC8NCiANCg0KVGhhbmtzDQpT
YWxpbC4NCg0KDQo+ID4+IDQuIEZhaWx1cmUgY29uZGl0aW9uIChCNS4zLjMuMikgc2hvdWxkIGJl
IGFtZW5kZWQgd2l0aA0KPiA+PiDCoMKgwqAgcnVubmFibGUgcHJlOiB0YXJnZXRfcmVjLmZsYWdz
LnJ1bm5hYmxlID09IE5PVF9SVU5OQUJMRSAoPykNCj4gPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHBvc3Q6IHJlc3VsdCA9PSBQU0NJX0RFTklFRCAoPykNCj4gPj4gNS4gQ2hhbmdlIHdvdWxk
IGFsc28gYmUgcmVxdWlyZWQgaW4gdGhlIGZsb3cgKEQxLjQgUFNDSSBmbG93cykgZGVwaWN0aW5n
DQo+ID4+IMKgwqDCoCBQU0NJX0NQVV9PTiBmbG93IChEMS40LjEpDQo+ID4+DQo+ID4+IEkgZG8g
dW5kZXJzdGFuZCB0aGF0IEFSTSBDQ0Egc3VwcG9ydCBpcyBpbiBpdHMgaW5mYW5jeSBzdGFnZSBh
bmQNCj4gPj4gZGlzY3Vzc2luZyBhYm91dCB2Q1BVIEhvdHBsdWcgaW4gcmVhbG0gd29ybGQgc2Vl
bSB0byBiZSBhIGZhci1mZXRjaGVkDQo+ID4+IGlkZWEgcmlnaHQgbm93LiBCdXQgc3BlY2lmaWNh
dGlvbiBjaGFuZ2VzIHJlcXVpcmUgbG90IG9mIHRpbWUgYW5kIGlmDQo+ID4+IHRoaXMgY2hhbmdl
IGlzIHJlYWxseSByZXF1aXJlZCB0aGVuIGl0IHNob3VsZCBiZSBmdXJ0aGVyIGRpc2N1c3NlZA0K
PiA+PiB3aXRoaW4gQVJNLg0KPiA+Pg0KPiA+PiBNYW55IHRoYW5rcyENCj4gPj4NCj4gPj4NCj4g
Pj4gQmVzIHJlZ2FyZHMNCj4gPj4gU2FsaWwNCj4gPj4NCj4gPj4NCj4gPj4gUmVmZXJlbmNlczoN
Cj4gPj4NCj4gPj4gWzFdIGh0dHBzOi8vZGV2ZWxvcGVyLmFybS5jb20vZG9jdW1lbnRhdGlvbi9k
ZW4wMTM3L2xhdGVzdC8NCj4gPj4gWzJdIGh0dHBzOi8vZ2l0aHViLmNvbS9zYWxpbC1tZWh0YS9x
ZW11LmdpdCB2aXJ0LWNwdWhwLWFybXY4L3JmYy12MS1wb3J0MTEwNTIwMjMuZGV2LTENCj4gPj4g
WzNdIGh0dHBzOi8vZ2l0LmdpdGxhYi5hcm0uY29tL2xpbnV4LWFybS9saW51eC1qbS5naXQgdmly
dHVhbF9jcHVfaG90cGx1Zy9yZmMvdjINCg0K
