Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272017609A2
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 07:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjGYFpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 01:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjGYFpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 01:45:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E61D1BD9;
        Mon, 24 Jul 2023 22:45:18 -0700 (PDT)
Received: from lhrpeml100005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R95Ws3P6pz6J6nV;
        Tue, 25 Jul 2023 13:42:17 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 06:45:09 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Tue, 25 Jul 2023 06:45:09 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     bibo mao <maobibo@loongson.cn>
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
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "steven.price@arm.com" <steven.price@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: RE: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
Thread-Topic: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
Thread-Index: Adm55YYLPryt1tEKR0alBn01xBiFBwEoRICAAAIxYpD///sBAP//riNw
Date:   Tue, 25 Jul 2023 05:45:09 +0000
Message-ID: <12959471e1424974979eef4e32812d60@huawei.com>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
        <2fa14ef5-b2f7-459d-8b84-114d36ba3cf7@loongson.cn>
        <d13c4cb44a2b4b42a8b534c38c402a1d@huawei.com>
 <5cb437f8-2e33-55b2-d5e4-2c5757af8b44@loongson.cn>
In-Reply-To: <5cb437f8-2e33-55b2-d5e4-2c5757af8b44@loongson.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.174.51]
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

SGVsbG8sDQoNCj4gRnJvbTogYmlibyBtYW8gPG1hb2JpYm9AbG9vbmdzb24uY24+DQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bHkgMjUsIDIwMjMgMjoxNCBBTQ0KPiBUbzogU2FsaWwgTWVodGEgPHNhbGls
Lm1laHRhQGh1YXdlaS5jb20+DQoNCg0KWy4uLl0NCg0KDQo+IOWcqCAyMDIzLzcvMjUgMDg6NTYs
IFNhbGlsIE1laHRhIOWGmemBkzoNCj4gPiBIaSBCaWJvLA0KPiA+DQo+ID4+IEZyb206IGJpYm8g
bWFvIDxtYW9iaWJvQGxvb25nc29uLmNuPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBKdWx5IDI1LCAy
MDIzIDE6MjkgQU0NCj4gPj4gVG86IFNhbGlsIE1laHRhIDxzYWxpbC5tZWh0YUBodWF3ZWkuY29t
Pg0KPiA+PiBDYzogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT47IEpv
bmF0aGFuIENhbWVyb24NCj4gPj4gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IE1hcmMg
WnluZ2llciA8bWF6QGtlcm5lbC5vcmc+OyBXaWxsIERlYWNvbg0KPiA+PiA8d2lsbEBrZXJuZWwu
b3JnPjsgY2hyaXN0b2ZmZXIuZGFsbEBhcm0uY29tOyBvbGl2ZXIudXB0b25AbGludXguZGV2Ow0K
PiA+PiBtYXJrLnJ1dGxhbmRAYXJtLmNvbTsgcGJvbnppbmlAcmVkaGF0LmNvbTsgU2FsaWwgTWVo
dGENCj4gPj4gPHNhbGlsLm1laHRhQG9wbnNyYy5uZXQ+OyBhbmRyZXcuam9uZXNAbGludXguZGV2
OyB5dXplbmdodWkNCj4gPj4gPHl1emVuZ2h1aUBodWF3ZWkuY29tPjsga3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdTsgbGludXgtYXJtLQ0KPiA+PiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9y
ZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gPj4ga3ZtQHZnZXIua2VybmVsLm9y
ZzsgcWVtdS1kZXZlbEBub25nbnUub3JnOyBqYW1lcy5tb3JzZUBhcm0uY29tOw0KPiA+PiBzdGV2
ZW4ucHJpY2VAYXJtLmNvbTsgU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNv
bT47IEplYW4tDQo+ID4+IFBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9y
Zz47IGt2bWFybUBsaXN0cy5saW51eC5kZXY7IGxpbnV4LWNvY29AbGlzdHMubGludXguZGV2DQo+
ID4+IFN1YmplY3Q6IFJlOiBbUXVlc3Rpb24gLSBBUk0gQ0NBXSB2Q1BVIEhvdHBsdWcgU3VwcG9y
dCBpbiBBUk0gUmVhbG0gd29ybGQgbWlnaHQgcmVxdWlyZSBBUk0gc3BlYyBjaGFuZ2U/DQo+ID4+
DQo+ID4+IElzIHZjcHUgaG90cGx1ZyBzdXBwb3J0ZWQgaW4gYXJtIHZpcnQtbWFjaGluZSBub3c/
DQo+ID4NCj4gPiBOb3QgeWV0LiBXZSBhcmUgd29ya2luZyBvbiBpdC4gUGxlYXNlIGNoZWNrIHRo
ZSBSRkNzIGJlaW5nIHRlc3RlZC4NCj4gPg0KPiA+DQo+ID4gWzFdIFByZS1SRkMgVjIgQ2hhbmdl
czogU3VwcG9ydCBvZiBWaXJ0dWFsIENQVSBIb3RwbHVnIGZvciBBUk12OCBBcmNoIChXSVApDQo+
ID4gICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9zYWxpbC1tZWh0YS9xZW11LmdpdCB2aXJ0LWNwdWhw
LWFybXY4L3JmYy12MS1wb3J0MTEwNTIwMjMuZGV2LTENCj4gPiBbMl0gW1JGQyBQQVRDSCAwMC8z
Ml0gQUNQSS9hcm02NDogYWRkIHN1cHBvcnQgZm9yIHZpcnR1YWwgY3B1aG90cGx1Zw0KPiA+ICAg
ICBodHRwczovL2dpdC5naXRsYWIuYXJtLmNvbS9saW51eC1hcm0vbGludXgtam0uZ2l0IHZpcnR1
YWxfY3B1X2hvdHBsdWcvcmZjL3YyDQo+ID4NCj4gPg0KPiA+PiBUaGVyZSBpcyBhcm02NCB2Y3B1
IGhvdHBsdWcgcGF0Y2ggaW4gcWVtdSBtYWlsaW5nIGxpc3QsIGhvd2V2ZXIgaXQgaXMgbm90IG1l
cmdlZC4NCj4gPj4gSSBkbyBub3Qga25vdyB3aHkgaXQgaXMgbm90IG1lcmdlZC4NCj4gPg0KPiA+
DQo+ID4gSSB0aGluayB5b3UgYXJlIHJlZmVycmluZyB0byBwYXRjaGVzIFszXSwgWzRdPyBQbGVh
c2UgZm9sbG93IHRoZSBkaXNjdXNzaW9uDQo+ID4gZm9yIGRldGFpbHMuDQo+DQo+IHllYXAsIHdl
IHJlZmVyZW5jZSB0aGUgcGF0Y2ggWzNdLCBbNF0gYW5kIGJlbmVmaXQgZnJvbSB0aGVtIGdyZWF0
bHkgLTopDQoNCg0KSSBhbSBnbGFkIHRoYXQgb3VyIGN1cnJlbnQgd29yayBpcyB1c2VmdWwgdG8g
bW9yZSB0aGFuIG9uZSBhcmNoaXRlY3R1cmUgYW5kIGl0DQp3YXMgb25lIG9mIHRoZSBhaW0gb2Yg
b3VyIHdvcmsgYXMgd2VsbCBidXQuLi4NCg0KPiBUaGUgcGF0Y2ggZm9yIExvb25nQXJjaCB2Y3B1
IGhvdHBsdWcgbGluayBpczoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC9j
b3Zlci4xNjg5ODM3MDkzLmdpdC5saXhpYW5nbGFpQGxvb25nc29uLmNuL1QvI3QNCg0KDQpJIHF1
aWNrbHkgd2VudCB0aHJvdWdoIGFib3ZlIHBhdGNoZXMgYW5kIGl0IGxvb2tzIGxpa2UgdGhpcyBw
YXRjaC1zZXQgaXMgbW9zdGx5DQpiYXNlZCBvbiBvdXIgbGF0ZXN0IHBhdGNoZXMgd2hpY2ggYXJl
IGF0IFsxXSwgWzJdIGFuZCBub3QganVzdCBhdCBbM10sIFs0XS4gQXMgSQ0KY291bGQgc2VlIG1v
c3Qgb2YgdGhlIGZ1bmN0aW9ucyB3aGljaCB5b3UgaGF2ZSBwb3J0ZWQgdG8geW91ciBhcmNoaXRl
Y3R1cmUgYXJlDQpwYXJ0IG9mIG91ciBRZW11IHJlcG9zaXRvcmllcyBbMl0gd2hpY2ggd2UgaGF2
ZSB5ZXQgdG8gcHVzaCB0byBjb21tdW5pdHkuIEFzIEkNCmFtIHdvcmtpbmcgdG93YXJkcyBSRkMg
VjIgcGF0Y2hlcyBhbmQgd2hpY2ggc2hhbGwgYmUgZmxvYXRlZCBzb29uLiBJdCBkb2VzIG5vdA0K
bWFrZXMgc2Vuc2UgZm9yIHlvdSB0byBkdXBsaWNhdGUgdGhlIEdFRC9BQ1BJIGNoYW5nZXMgd2hp
Y2ggYXJlIGNvbW1vbiBhY3Jvc3MNCmFyY2hpdGVjdHVyZXMgYW5kIHdoaWNoIGhhdmUgYmVlbiBk
ZXJpdmVkIGZyb20gdGhlIEFSTTY0IHZDUFUgSG90cGx1ZyBzdXBwb3J0DQpvcmlnaW5hbCBwYXRj
aGVzLiANCg0KVGhpcyB3aWxsIGNyZWF0ZSBtZXJnZSBjb25mbGljdHMsIHdpbGwgYnJlYWsgbGFy
Z2UgcGFydCBvZiBvdXIgb3JpZ2luYWwgcGF0Y2gtc2V0Lg0KDQpIZW5jZSwgSSB3b3VsZCByZXF1
ZXN0IHlvdSB0byBkcm9wIHBhdGNoZXMgMS00IGZyb20geW91ciBwYXRjaC1zZXQgb3IgcmViYXNl
DQppdCBvdmVyIEFSTTY0IG9yaWdpbmFsIHBhdGNoZXMgaW4gYSB3ZWVrIG9yIDIgd2VlayBvZiB0
aW1lLiBUaGlzIGlzIHRvIGF2b2lkDQpzcG9pbGluZyBvdXIgcHJldmlvdXMgeWVhcnMgb2YgaGFy
ZCB3b3JrIGZvciB0aGUgdG9waWMgd2UgaGF2ZSBiZWVuIHBlcnNpc3RlbnRseQ0KbWFraW5nIGVm
Zm9ydHMgYXMgeW91IGNhbiBzZWUgdGhyb3VnaCB0aGUgY29kZSBhbmQgb3VyIGRldGFpbGVkIHBy
ZXNlbnRhdGlvbnMuDQoNCkhvcGUgeW91IHdpbGwgYWdyZWUgd2UgYWxsIG5lZWQgdG8gcmVzcGVj
dCBvdGhlcnMgZWZmb3J0cyBhbmQgdGltZSBpbiB0aGlzDQptb2RlIG9mIG9wZW4tc291cmNlIGNv
bGxhYm9yYXRpb24uIA0KDQpSZXN0IGFzc3VyZWQgSSB3aWxsIGhlbHAgeW91IGluIHJldmlldyBv
ZiB5b3VyIGFyY2hpdGVjdHVyZSBzcGVjaWZpYyBwYXRjaC1zZXQNCmFzIGl0IGlzIGEgd29yayBv
ZiBtdXR1YWwgaW50ZXJlc3QuDQoNClRoYW5rcyBmb3IgdW5kZXJzdGFuZGluZyENCg0KDQpCZXN0
IFdpc2hlcywNClNhbGlsLg0KDQoNCg0KPiBSZWdhcmRzDQo+IEJpYm8gTWFvDQo+IA0KPiA+DQo+
ID4NCj4gPiBbM10gW1BBVENIIFJGQyAwMC8yMl0gU3VwcG9ydCBvZiBWaXJ0dWFsIENQVSBIb3Rw
bHVnIGZvciBBUk12OCBBcmNoDQo+ID4gICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8y
MDIwMDYxMzIxMzYyOS4yMTk4NC0xLXNhbGlsLm1laHRhQGh1YXdlaS5jb20vDQo+ID4gWzRdIFtQ
QVRDSCBSRkMgMC80XSBDaGFuZ2VzIHRvIFN1cHBvcnQgKlZpcnR1YWwqIENQVSBIb3RwbHVnIGZv
ciBBUk02NA0KPiA+ICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMDA2MjUxMzM3
NTcuMjIzMzItMS1zYWxpbC5tZWh0YUBodWF3ZWkuY29tLyNyDQo+ID4NCj4gPg0KPiA+IEluIHN1
bW1hcnksIHRoZXJlIHdlcmUgc29tZSBBUk02NCBBcmNoaXRlY3R1cmUgY29uc3RyYWludHMgd2hp
Y2ggd2VyZSBiZWluZw0KPiA+IHZpb2xhdGVkIGluIHRoZSBlYXJsaWVyIHBhdGNoZXMgb2YgdGhl
IGtlcm5lbCBbNF0gc28gd2UgaGFkIHRvIHJlLXRoaW5rIG9mIHRoZQ0KPiA+IGtlcm5lbCBjaGFu
Z2VzLiBUaGUgUWVtdSBwYXJ0IG1vc3RseSByZW1haW5zIHNhbWUgd2l0aCBzb21lIG5ldyBpbnRy
b2R1Y3Rpb25zDQo+ID4gb2YgR3Vlc3QgSFZDL1NNQyBoeXBlciBjYWxsIGV4aXQgaGFuZGxpbmcg
aW4gdXNlciBzcGFjZSBldGMuIGZvciBwb2xpY3kgY2hlY2tzDQo+ID4gaW4gVk1NL1FlbXUuDQo+
ID4NCj4gPg0KPiA+IFlvdSBjYW4gZm9sbG93IHRoZSBLVk1Gb3J1bSBjb25mZXJlbmNlIHByZXNl
bnRhdGlvbnMgWzVdLCBbNl0gZGVsaXZlcmVkIGluIHRoZQ0KPiA+IHllYXIgMjAyMCBhbmQgMjAy
MyB0byBnZXQgaG9sZCBvZiBtb3JlIGRldGFpbHMgcmVsYXRlZCB0byB0aGlzLg0KPiA+DQo+ID4N
Cj4gPiBbNV0gS1ZNRm9ydW0gMjAyMzogQ2hhbGxlbmdlcyBSZXZpc2l0ZWQgaW4gU3VwcG9ydGlu
ZyBWaXJ0IENQVSBIb3RwbHVnIG9uIGFyY2hpdGVjdHVyZXMgdGhhdCBkb24ndCBTdXBwb3J0IENQ
VSBIb3RwbHVnIChsaWtlIEFSTTY0KQ0KPiA+ICAgICBodHRwczovL2t2bS1mb3J1bS5xZW11Lm9y
Zy8yMDIzL3RhbGsvOVNNUERRLw0KPiA+IFs2XSBLVk1Gb3J1bSAyMDIwOiBDaGFsbGVuZ2VzIGlu
IFN1cHBvcnRpbmcgVmlydHVhbCBDUFUgSG90cGx1ZyBvbiBTb0MgQmFzZWQgU3lzdGVtcyAobGlr
ZSBBUk02NCkNCj4gPiAgICAgaHR0cHM6Ly9rdm1mb3J1bTIwMjAuc2NoZWQuY29tL2V2ZW50L2VF
NG0NCj4gPg0KPiA+DQo+ID4NCj4gPj4gSSBhc2sgdGhpcyBxdWVzdGlvbiBiZWNhdXNlIHdlIHBy
b3Bvc2UNCj4gPj4gc2ltaWxhciBwYXRjaCBhYm91dCBMb29uZ0FyY2ggc3lzdGVtIGluIHFlbXUg
bWFpbGluZyBsaXN0LCBhbmQga2VybmVsIG5lZWQgbm90IGJlDQo+ID4+IG1vZGlmaWVkIGZvciB2
Y3B1IGhvdHBsdWcuDQo+ID4NCj4gPg0KPiA+IENvdWxkIHlvdSBwbGVhc2Ugc2hhcmUgdGhlIGxp
bmsgb2YgeW91ciBwYXRjaGVzIHNvIHRoYXQgd2UgY2FuIGhhdmUgYSBsb29rIGFuZA0KPiA+IGRy
YXcgYSBjb21wYXJpc29uPw0KPiA+DQo+ID4NCj4gPiBUaGFua3MNCj4gPiBTYWxpbC4NCj4gPg0K
PiA+Pg0KPiA+PiBSZWdhcmRzDQo+ID4+IEJpYm8sIG1hbw0KPiA+Pg0KPiA+PiDlnKggMjAyMy83
LzE5IDEwOjM1LCBTYWxpbCBNZWh0YSDlhpnpgZM6DQo+ID4+PiBbUmVwb3N0aW5nIGl0IGhlcmUg
ZnJvbSBMaW5hcm8gT3BlbiBEaXNjdXNzaW9uIExpc3QgZm9yIG1vcmUgZXllcyB0byBsb29rIGF0
XQ0KPiA+Pj4NCj4gPj4+IEhlbGxvLA0KPiA+Pj4gSSBoYXZlIHJlY2VudGx5IHN0YXJ0ZWQgdG8g
ZGFiYmxlIHdpdGggQVJNIENDQSBzdHVmZiBhbmQgY2hlY2sgaWYgb3VyDQo+ID4+PiByZWNlbnQg
Y2hhbmdlcyB0byBzdXBwb3J0IHZDUFUgSG90cGx1ZyBpbiBBUk02NCBjYW4gd29yayBpbiB0aGUg
cmVhbG0NCj4gPj4+IHdvcmxkLiBJIGhhdmUgcmVhbGl6ZWQgdGhhdCBpbiB0aGUgUk1NIHNwZWNp
ZmljYXRpb25bMV0gUFNDSV9DUFVfT04NCj4gPj4+IGNvbW1hbmQoQjUuMy4zKSBkb2VzIG5vdCBo
YW5kbGVzIHRoZSBQU0NJX0RFTklFRCByZXR1cm4gY29kZShCNS40LjIpLA0KPiA+Pj4gZnJvbSB0
aGUgaG9zdC4gVGhpcyBtaWdodCBiZSByZXF1aXJlZCB0byBzdXBwb3J0IHZDUFUgSG90cGx1ZyBm
ZWF0dXJlDQo+ID4+PiBpbiB0aGUgcmVhbG0gd29ybGQgaW4gZnV0dXJlLiB2Q1BVIEhvdHBsdWcg
aXMgYW4gaW1wb3J0YW50IGZlYXR1cmUgdG8NCj4gPj4+IHN1cHBvcnQga2F0YS1jb250YWluZXJz
IGluIHJlYWxtIHdvcmxkIGFzIGl0IHJlZHVjZXMgdGhlIFZNIGJvb3QgdGltZQ0KPiA+Pj4gYW5k
IGZhY2lsaXRhdGVzIGR5bmFtaWMgYWRqdXN0bWVudCBvZiB2Q1BVcyAod2hpY2ggSSB0aGluayBz
aG91bGQgYmUNCj4gPj4+IHRydWUgZXZlbiB3aXRoIFJlYWxtIHdvcmxkIGFzIGN1cnJlbnQgaW1w
bGVtZW50YXRpb24gb25seSBtYWtlcyB1c2UNCj4gPj4+IG9mIHRoZSBQU0NJX09OL09GRiB0byBy
ZWFsaXplIHRoZSBIb3RwbHVnIGxvb2stbGlrZSBlZmZlY3Q/KQ0KPiA+Pj4NCj4gPj4+DQo+ID4+
PiBBcyBwZXIgb3VyIHJlY2VudCBjaGFuZ2VzIFsyXSwgWzNdIHJlbGF0ZWQgdG8gc3VwcG9ydCB2
Q1BVIEhvdHBsdWcgb24NCj4gPj4+IEFSTTY0LCB3ZSBoYW5kbGUgdGhlIGd1ZXN0IGV4aXRzIGR1
ZSB0byBTTUMvSFZDIEh5cGVyY2FsbCBpbiB0aGUNCj4gPj4+IHVzZXItc3BhY2UgaS5lLiBWTU0v
UWVtdS4gSW4gcmVhbG0gd29ybGQsIFJFQyBFeGl0cyB0byBob3N0IGR1ZSB0bw0KPiA+Pj4gUFND
SV9DUFVfT04gc2hvdWxkIHVuZGVyZ28gc2ltaWxhciBwb2xpY3kgY2hlY2tzIGFuZCBJIHRoaW5r
LA0KPiA+Pj4NCj4gPj4+IDEuIEhvc3Qgc2hvdWxkICpkZW55KiB0byBvbmxpbmUgdGhlIHRhcmdl
dCB2Q1BVcyB3aGljaCBhcmUgTk9UIHBsdWdnZWQNCj4gPj4+IDIuIFRoaXMgbWVhbnMgdGFyZ2V0
IFJFQyBzaG91bGQgYmUgZGVuaWVkIGJ5IGhvc3QuIENhbiBob3N0IGNhbGwNCj4gPj4+ICAgIFJN
SV9QU0NJX0NPTVBFVEUgaW4gc3VjaCBzIGNhc2U/DQo+ID4+PiAzLiBUaGUgKnJldHVybiogdmFs
dWUgKEI1LjMuMy4xLjMgT3V0cHV0IHZhbHVlcykgc2hvdWxkIGJlIFBTQ0lfREVOSUVEDQo+ID4+
PiA0LiBGYWlsdXJlIGNvbmRpdGlvbiAoQjUuMy4zLjIpIHNob3VsZCBiZSBhbWVuZGVkIHdpdGgN
Cj4gPj4+ICAgIHJ1bm5hYmxlIHByZTogdGFyZ2V0X3JlYy5mbGFncy5ydW5uYWJsZSA9PSBOT1Rf
UlVOTkFCTEUgKD8pDQo+ID4+PiAgICAgICAgICAgICBwb3N0OiByZXN1bHQgPT0gUFNDSV9ERU5J
RUQgKD8pDQo+ID4+PiA1LiBDaGFuZ2Ugd291bGQgYWxzbyBiZSByZXF1aXJlZCBpbiB0aGUgZmxv
dyAoRDEuNCBQU0NJIGZsb3dzKSBkZXBpY3RpbmcNCj4gPj4+ICAgIFBTQ0lfQ1BVX09OIGZsb3cg
KEQxLjQuMSkNCj4gPj4+DQo+ID4+Pg0KPiA+Pj4gSSBkbyB1bmRlcnN0YW5kIHRoYXQgQVJNIEND
QSBzdXBwb3J0IGlzIGluIGl0cyBpbmZhbmN5IHN0YWdlIGFuZA0KPiA+Pj4gZGlzY3Vzc2luZyBh
Ym91dCB2Q1BVIEhvdHBsdWcgaW4gcmVhbG0gd29ybGQgc2VlbSB0byBiZSBhIGZhci1mZXRjaGVk
DQo+ID4+PiBpZGVhIHJpZ2h0IG5vdy4gQnV0IHNwZWNpZmljYXRpb24gY2hhbmdlcyByZXF1aXJl
IGxvdCBvZiB0aW1lIGFuZCBpZg0KPiA+Pj4gdGhpcyBjaGFuZ2UgaXMgcmVhbGx5IHJlcXVpcmVk
IHRoZW4gaXQgc2hvdWxkIGJlIGZ1cnRoZXIgZGlzY3Vzc2VkDQo+ID4+PiB3aXRoaW4gQVJNLg0K
PiA+Pj4NCj4gPj4+IE1hbnkgdGhhbmtzIQ0KPiA+Pj4NCj4gPj4+DQo+ID4+PiBCZXMgcmVnYXJk
cw0KPiA+Pj4gU2FsaWwNCj4gPj4+DQo+ID4+Pg0KPiA+Pj4gUmVmZXJlbmNlczoNCj4gPj4+DQo+
ID4+PiBbMV0gaHR0cHM6Ly9kZXZlbG9wZXIuYXJtLmNvbS9kb2N1bWVudGF0aW9uL2RlbjAxMzcv
bGF0ZXN0Lw0KPiA+Pj4gWzJdIGh0dHBzOi8vZ2l0aHViLmNvbS9zYWxpbC1tZWh0YS9xZW11Lmdp
dCB2aXJ0LWNwdWhwLWFybXY4L3JmYy12MS1wb3J0MTEwNTIwMjMuZGV2LTENCj4gPj4+IFszXSBo
dHRwczovL2dpdC5naXRsYWIuYXJtLmNvbS9saW51eC1hcm0vbGludXgtam0uZ2l0IHZpcnR1YWxf
Y3B1X2hvdHBsdWcvcmZjL3YyDQoNCg0K
