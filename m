Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E437655AD
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjG0OPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 10:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbjG0OPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 10:15:14 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CD42684;
        Thu, 27 Jul 2023 07:15:12 -0700 (PDT)
Received: from lhrpeml100004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RBXlF1CtFz6J6jp;
        Thu, 27 Jul 2023 22:12:09 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml100004.china.huawei.com (7.191.162.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 15:15:08 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Thu, 27 Jul 2023 15:15:08 +0100
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
Thread-Index: Adm55YYLPryt1tEKR0alBn01xBiFBwEoRICAAAIxYpD///sBAP//riNwgACokYD//9aHsA==
Date:   Thu, 27 Jul 2023 14:15:08 +0000
Message-ID: <e5f41f6afdce4e3db21547770cf0e020@huawei.com>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
        <2fa14ef5-b2f7-459d-8b84-114d36ba3cf7@loongson.cn>
        <d13c4cb44a2b4b42a8b534c38c402a1d@huawei.com>
        <5cb437f8-2e33-55b2-d5e4-2c5757af8b44@loongson.cn>
        <12959471e1424974979eef4e32812d60@huawei.com>
 <935e68ed-2ada-03ac-c6e0-40b7972515c1@loongson.cn>
In-Reply-To: <935e68ed-2ada-03ac-c6e0-40b7972515c1@loongson.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.173.64]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQmlibywNCg0KPiBGcm9tOiBiaWJvIG1hbyA8bWFvYmlib0Bsb29uZ3Nvbi5jbj4NCj4gU2Vu
dDogVHVlc2RheSwgSnVseSAyNSwgMjAyMyA3OjI0IEFNDQo+IFRvOiBTYWxpbCBNZWh0YSA8c2Fs
aWwubWVodGFAaHVhd2VpLmNvbT4NCg0KWy4uLl0NCg0KPiDlnKggMjAyMy83LzI1IDEzOjQ1LCBT
YWxpbCBNZWh0YSDlhpnpgZM6DQo+ID4gSGVsbG8sDQo+ID4NCj4gPj4gRnJvbTogYmlibyBtYW8g
PG1hb2JpYm9AbG9vbmdzb24uY24+DQo+ID4+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjUsIDIwMjMg
MjoxNCBBTQ0KPiA+PiBUbzogU2FsaWwgTWVodGEgPHNhbGlsLm1laHRhQGh1YXdlaS5jb20+DQoN
ClsuLi5dDQoNCj4gPj4g5ZyoIDIwMjMvNy8yNSAwODo1NiwgU2FsaWwgTWVodGEg5YaZ6YGTOg0K
PiA+Pj4NCj4gPj4+PiBGcm9tOiBiaWJvIG1hbyA8bWFvYmlib0Bsb29uZ3Nvbi5jbj4NCj4gPj4+
PiBTZW50OiBUdWVzZGF5LCBKdWx5IDI1LCAyMDIzIDE6MjkgQU0NCj4gPj4+PiBUbzogU2FsaWwg
TWVodGEgPHNhbGlsLm1laHRhQGh1YXdlaS5jb20+DQo+ID4+Pj4gQ2M6IENhdGFsaW4gTWFyaW5h
cyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+OyBKb25hdGhhbiBDYW1lcm9uDQo+ID4+Pj4gPGpv
bmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+
OyBXaWxsIERlYWNvbg0KPiA+Pj4+IDx3aWxsQGtlcm5lbC5vcmc+OyBjaHJpc3RvZmZlci5kYWxs
QGFybS5jb207IG9saXZlci51cHRvbkBsaW51eC5kZXY7DQo+ID4+Pj4gbWFyay5ydXRsYW5kQGFy
bS5jb207IHBib256aW5pQHJlZGhhdC5jb207IFNhbGlsIE1laHRhDQo+ID4+Pj4gPHNhbGlsLm1l
aHRhQG9wbnNyYy5uZXQ+OyBhbmRyZXcuam9uZXNAbGludXguZGV2OyB5dXplbmdodWkNCj4gPj4+
PiA8eXV6ZW5naHVpQGh1YXdlaS5jb20+OyBrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1OyBs
aW51eC1hcm0tDQo+ID4+Pj4ga2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4+Pj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgcWVtdS1kZXZl
bEBub25nbnUub3JnOyBqYW1lcy5tb3JzZUBhcm0uY29tOw0KPiA+Pj4+IHN0ZXZlbi5wcmljZUBh
cm0uY29tOyBTdXp1a2kgSyBQb3Vsb3NlIDxzdXp1a2kucG91bG9zZUBhcm0uY29tPjsgSmVhbi0N
Cj4gPj4+PiBQaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+OyBrdm1h
cm1AbGlzdHMubGludXguZGV2OyBsaW51eC1jb2NvQGxpc3RzLmxpbnV4LmRldg0KPiA+Pj4+IFN1
YmplY3Q6IFJlOiBbUXVlc3Rpb24gLSBBUk0gQ0NBXSB2Q1BVIEhvdHBsdWcgU3VwcG9ydCBpbiBB
Uk0gUmVhbG0gd29ybGQgbWlnaHQgcmVxdWlyZSBBUk0gc3BlYyBjaGFuZ2U/DQo+ID4+Pj4NCj4g
Pj4+PiBJcyB2Y3B1IGhvdHBsdWcgc3VwcG9ydGVkIGluIGFybSB2aXJ0LW1hY2hpbmUgbm93Pw0K
PiA+Pj4NCj4gPj4+IE5vdCB5ZXQuIFdlIGFyZSB3b3JraW5nIG9uIGl0LiBQbGVhc2UgY2hlY2sg
dGhlIFJGQ3MgYmVpbmcgdGVzdGVkLg0KPiA+Pj4NCj4gPj4+DQo+ID4+PiBbMV0gUHJlLVJGQyBW
MiBDaGFuZ2VzOiBTdXBwb3J0IG9mIFZpcnR1YWwgQ1BVIEhvdHBsdWcgZm9yIEFSTXY4IEFyY2gg
KFdJUCkNCj4gPj4+ICAgICBodHRwczovL2dpdGh1Yi5jb20vc2FsaWwtbWVodGEvcWVtdS5naXQg
dmlydC1jcHVocC1hcm12OC9yZmMtdjEtcG9ydDExMDUyMDIzLmRldi0xDQo+ID4+PiBbMl0gW1JG
QyBQQVRDSCAwMC8zMl0gQUNQSS9hcm02NDogYWRkIHN1cHBvcnQgZm9yIHZpcnR1YWwgY3B1aG90
cGx1Zw0KPiA+Pj4gICAgIGh0dHBzOi8vZ2l0LmdpdGxhYi5hcm0uY29tL2xpbnV4LWFybS9saW51
eC1qbS5naXQgdmlydHVhbF9jcHVfaG90cGx1Zy9yZmMvdjINCj4gPj4+DQo+ID4+Pg0KPiA+Pj4+
IFRoZXJlIGlzIGFybTY0IHZjcHUgaG90cGx1ZyBwYXRjaCBpbiBxZW11IG1haWxpbmcgbGlzdCwg
aG93ZXZlciBpdCBpcyBub3QgbWVyZ2VkLg0KPiA+Pj4+IEkgZG8gbm90IGtub3cgd2h5IGl0IGlz
IG5vdCBtZXJnZWQuDQo+ID4+Pg0KPiA+Pj4NCj4gPj4+IEkgdGhpbmsgeW91IGFyZSByZWZlcnJp
bmcgdG8gcGF0Y2hlcyBbM10sIFs0XT8gUGxlYXNlIGZvbGxvdyB0aGUgZGlzY3Vzc2lvbg0KPiA+
Pj4gZm9yIGRldGFpbHMuDQo+ID4+DQo+ID4+IHllYXAsIHdlIHJlZmVyZW5jZSB0aGUgcGF0Y2gg
WzNdLCBbNF0gYW5kIGJlbmVmaXQgZnJvbSB0aGVtIGdyZWF0bHkgLTopDQo+ID4NCj4gPg0KPiA+
IEkgYW0gZ2xhZCB0aGF0IG91ciBjdXJyZW50IHdvcmsgaXMgdXNlZnVsIHRvIG1vcmUgdGhhbiBv
bmUgYXJjaGl0ZWN0dXJlIGFuZCBpdA0KPiA+IHdhcyBvbmUgb2YgdGhlIGFpbSBvZiBvdXIgd29y
ayBhcyB3ZWxsIGJ1dC4uLg0KPiA+DQo+ID4+IFRoZSBwYXRjaCBmb3IgTG9vbmdBcmNoIHZjcHUg
aG90cGx1ZyBsaW5rIGlzOg0KPiA+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9xZW11LWRldmVs
L2NvdmVyLjE2ODk4MzcwOTMuZ2l0LmxpeGlhbmdsYWlAbG9vbmdzb24uY24vVC8jdA0KPiA+DQo+
ID4NCj4gPiBJIHF1aWNrbHkgd2VudCB0aHJvdWdoIGFib3ZlIHBhdGNoZXMgYW5kIGl0IGxvb2tz
IGxpa2UgdGhpcyBwYXRjaC1zZXQgaXMgbW9zdGx5DQo+ID4gYmFzZWQgb24gb3VyIGxhdGVzdCBw
YXRjaGVzIHdoaWNoIGFyZSBhdCBbMV0sIFsyXSBhbmQgbm90IGp1c3QgYXQgWzNdLCBbNF0uIEFz
IEkNCj4gPiBjb3VsZCBzZWUgbW9zdCBvZiB0aGUgZnVuY3Rpb25zIHdoaWNoIHlvdSBoYXZlIHBv
cnRlZCB0byB5b3VyIGFyY2hpdGVjdHVyZSBhcmUgDQo+ID4gcGFydCBvZiBvdXIgUWVtdSByZXBv
c2l0b3JpZXMgWzJdIHdoaWNoIHdlIGhhdmUgeWV0IHRvIHB1c2ggdG8gY29tbXVuaXR5LiBBcyBJ
DQo+ID4gYW0gd29ya2luZyB0b3dhcmRzIFJGQyBWMiBwYXRjaGVzIGFuZCB3aGljaCBzaGFsbCBi
ZSBmbG9hdGVkIHNvb24uIEl0IGRvZXMgbm90DQo+ID4gbWFrZXMgc2Vuc2UgZm9yIHlvdSB0byBk
dXBsaWNhdGUgdGhlIEdFRC9BQ1BJIGNoYW5nZXMgd2hpY2ggYXJlIGNvbW1vbiBhY3Jvc3MNCj4g
PiBhcmNoaXRlY3R1cmVzIGFuZCB3aGljaCBoYXZlIGJlZW4gZGVyaXZlZCBmcm9tIHRoZSBBUk02
NCB2Q1BVIEhvdHBsdWcgc3VwcG9ydA0KPiA+IG9yaWdpbmFsIHBhdGNoZXMuDQo+ID4NCj4gPiBU
aGlzIHdpbGwgY3JlYXRlIG1lcmdlIGNvbmZsaWN0cywgd2lsbCBicmVhayBsYXJnZSBwYXJ0IG9m
IG91ciBvcmlnaW5hbCBwYXRjaC1zZXQuDQo+ID4NCj4gPiBIZW5jZSwgSSB3b3VsZCByZXF1ZXN0
IHlvdSB0byBkcm9wIHBhdGNoZXMgMS00IGZyb20geW91ciBwYXRjaC1zZXQgb3IgcmViYXNlDQo+
ID4gaXQgb3ZlciBBUk02NCBvcmlnaW5hbCBwYXRjaGVzIGluIGEgd2VlayBvciAyIHdlZWsgb2Yg
dGltZS4gVGhpcyBpcyB0byBhdm9pZA0KPiA+IHNwb2lsaW5nIG91ciBwcmV2aW91cyB5ZWFycyBv
ZiBoYXJkIHdvcmsgZm9yIHRoZSB0b3BpYyB3ZSBoYXZlIGJlZW4gcGVyc2lzdGVudGx5DQo+ID4g
bWFraW5nIGVmZm9ydHMgYXMgeW91IGNhbiBzZWUgdGhyb3VnaCB0aGUgY29kZSBhbmQgb3VyIGRl
dGFpbGVkIHByZXNlbnRhdGlvbnMuDQo+DQo+IERvIHlvdSBoYXZlIGEgcGxhbiB0byBwb3N0IG5l
dyB2Y3B1IGhvdHBsdWcgcGF0Y2ggc29vbiA/IElmIHRoZXJlIGlzLCB3ZSBjYW4NCj4gcG9zdHBv
bmUgIG91ciBwYXRjaCBmb3IgcmV2aWV3aW5nIGFuZCB3YWl0IGZvciB5b3VyIGFybTY0IHZjcHUg
SG90cGx1ZyBwYXRjaCwNCj4gYW5kIGhvcGUgdGhhdCB5b3VyIHBhdGNoIGNhbiBtZXJnZSBpbnRv
IHFlbXUgYXNhcC4NCg0KDQpZZXMsIHdlIGFyZSB3b3JraW5nIG9uIGl0IGFuZCBwbGFuIHRvIHBv
c3QgaXQgc29vbiBpbiAyIHdlZWtzIG9mIHRpbWUuDQoNCj4gDQo+IFdlIGFsd2F5cyByZWJhc2Ug
b24gdGhlIG1haW5saW5lIHFlbXUgdmVyc2lvbiwgcmF0aGVyIHRoYW4gcGVyc29uYWwgcHJpdmF0
ZSB0cmVlIC06KQ0KDQoNCk9rLiBJIHRob3VnaHQgaWYgeW91IGNvdWxkIHRha2UgY29kZSBmcm9t
IHByaXZhdGUgYnJhbmNoIHRoZW4gdGVjaG5pY2FsbHkgeW91DQpjb3VsZCByZWJhc2UgZnJvbSBp
dCBhcyB3ZWxsIDopDQoNCkFueXdheXMsIEkgd2lsbCBiZSBzb29uIHBvc3RpbmcgdGhlIGNoYW5n
ZXMgYW5kIGl0IHdpbGwgaGF2ZSB0aG9zZSBBQ1BJL0dFRA0KY2hhbmdlcyBhcyB3ZWxsIHdoaWNo
IHdlIGNhbiB0cnkgdG8gZ2V0IGFjY2VwdGVkIHF1aWNrbHkuIE1hbnkgdGhhbmtzIQ0KDQoNCkJl
c3Qgd2lzaGVzLA0KU2FsaWwNCg0KDQo+IFJlZ2FyZHMNCj4gQmlibyBNYW8NCj4gPg0KPiA+IEhv
cGUgeW91IHdpbGwgYWdyZWUgd2UgYWxsIG5lZWQgdG8gcmVzcGVjdCBvdGhlcnMgZWZmb3J0cyBh
bmQgdGltZSBpbiB0aGlzDQo+ID4gbW9kZSBvZiBvcGVuLXNvdXJjZSBjb2xsYWJvcmF0aW9uLg0K
PiA+DQo+ID4gUmVzdCBhc3N1cmVkIEkgd2lsbCBoZWxwIHlvdSBpbiByZXZpZXcgb2YgeW91ciBh
cmNoaXRlY3R1cmUgc3BlY2lmaWMgcGF0Y2gtc2V0DQo+ID4gYXMgaXQgaXMgYSB3b3JrIG9mIG11
dHVhbCBpbnRlcmVzdC4NCj4gPg0KPiA+IFRoYW5rcyBmb3IgdW5kZXJzdGFuZGluZyENCj4gPg0K
PiA+DQo+ID4gQmVzdCBXaXNoZXMsDQo+ID4gU2FsaWwuDQo+ID4NCj4gPj4gUmVnYXJkcw0KPiA+
PiBCaWJvIE1hbw0KPiA+Pg0KPiA+Pj4NCj4gPj4+DQo+ID4+PiBbM10gW1BBVENIIFJGQyAwMC8y
Ml0gU3VwcG9ydCBvZiBWaXJ0dWFsIENQVSBIb3RwbHVnIGZvciBBUk12OCBBcmNoDQo+ID4+PiAg
ICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjAwNjEzMjEzNjI5LjIxOTg0LTEtc2Fs
aWwubWVodGFAaHVhd2VpLmNvbS8NCj4gPj4+IFs0XSBbUEFUQ0ggUkZDIDAvNF0gQ2hhbmdlcyB0
byBTdXBwb3J0ICpWaXJ0dWFsKiBDUFUgSG90cGx1ZyBmb3IgQVJNNjQNCj4gPj4+ICAgICBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMDA2MjUxMzM3NTcuMjIzMzItMS1zYWxpbC5tZWh0
YUBodWF3ZWkuY29tLyNyDQo+ID4+Pg0KPiA+Pj4NCj4gPj4+IEluIHN1bW1hcnksIHRoZXJlIHdl
cmUgc29tZSBBUk02NCBBcmNoaXRlY3R1cmUgY29uc3RyYWludHMgd2hpY2ggd2VyZSBiZWluZw0K
PiA+Pj4gdmlvbGF0ZWQgaW4gdGhlIGVhcmxpZXIgcGF0Y2hlcyBvZiB0aGUga2VybmVsIFs0XSBz
byB3ZSBoYWQgdG8gcmUtdGhpbmsgb2YgdGhlDQo+ID4+PiBrZXJuZWwgY2hhbmdlcy4gVGhlIFFl
bXUgcGFydCBtb3N0bHkgcmVtYWlucyBzYW1lIHdpdGggc29tZSBuZXcgaW50cm9kdWN0aW9ucw0K
PiA+Pj4gb2YgR3Vlc3QgSFZDL1NNQyBoeXBlciBjYWxsIGV4aXQgaGFuZGxpbmcgaW4gdXNlciBz
cGFjZSBldGMuIGZvciBwb2xpY3kgY2hlY2tzDQo+ID4+PiBpbiBWTU0vUWVtdS4NCj4gPj4+DQo+
ID4+Pg0KPiA+Pj4gWW91IGNhbiBmb2xsb3cgdGhlIEtWTUZvcnVtIGNvbmZlcmVuY2UgcHJlc2Vu
dGF0aW9ucyBbNV0sIFs2XSBkZWxpdmVyZWQgaW4gdGhlDQo+ID4+PiB5ZWFyIDIwMjAgYW5kIDIw
MjMgdG8gZ2V0IGhvbGQgb2YgbW9yZSBkZXRhaWxzIHJlbGF0ZWQgdG8gdGhpcy4NCj4gPj4+DQo+
ID4+Pg0KPiA+Pj4gWzVdIEtWTUZvcnVtIDIwMjM6IENoYWxsZW5nZXMgUmV2aXNpdGVkIGluIFN1
cHBvcnRpbmcgVmlydCBDUFUgSG90cGx1ZyBvbiBhcmNoaXRlY3R1cmVzIHRoYXQgZG9uJ3QgU3Vw
cG9ydCBDUFUgSG90cGx1ZyAobGlrZSBBUk02NCkNCj4gPj4+ICAgICBodHRwczovL2t2bS1mb3J1
bS5xZW11Lm9yZy8yMDIzL3RhbGsvOVNNUERRLw0KPiA+Pj4gWzZdIEtWTUZvcnVtIDIwMjA6IENo
YWxsZW5nZXMgaW4gU3VwcG9ydGluZyBWaXJ0dWFsIENQVSBIb3RwbHVnIG9uIFNvQyBCYXNlZCBT
eXN0ZW1zIChsaWtlIEFSTTY0KQ0KPiA+Pj4gICAgIGh0dHBzOi8va3ZtZm9ydW0yMDIwLnNjaGVk
LmNvbS9ldmVudC9lRTRtDQo+ID4+Pg0KPiA+Pj4NCj4gPj4+PiBJIGFzayB0aGlzIHF1ZXN0aW9u
IGJlY2F1c2Ugd2UgcHJvcG9zZQ0KPiA+Pj4+IHNpbWlsYXIgcGF0Y2ggYWJvdXQgTG9vbmdBcmNo
IHN5c3RlbSBpbiBxZW11IG1haWxpbmcgbGlzdCwgYW5kIGtlcm5lbCBuZWVkIG5vdCBiZQ0KPiA+
Pj4+IG1vZGlmaWVkIGZvciB2Y3B1IGhvdHBsdWcuDQo+ID4+Pg0KPiA+Pj4NCj4gPj4+IENvdWxk
IHlvdSBwbGVhc2Ugc2hhcmUgdGhlIGxpbmsgb2YgeW91ciBwYXRjaGVzIHNvIHRoYXQgd2UgY2Fu
IGhhdmUgYSBsb29rIGFuZA0KPiA+Pj4gZHJhdyBhIGNvbXBhcmlzb24/DQo+ID4+Pg0KPiA+Pj4N
Cj4gPj4+IFRoYW5rcw0KPiA+Pj4gU2FsaWwuDQo+ID4+Pg0KPiA+Pj4+DQo+ID4+Pj4gUmVnYXJk
cw0KPiA+Pj4+IEJpYm8sIG1hbw0KPiA+Pj4+DQo+ID4+Pj4g5ZyoIDIwMjMvNy8xOSAxMDozNSwg
U2FsaWwgTWVodGEg5YaZ6YGTOg0KPiA+Pj4+PiBbUmVwb3N0aW5nIGl0IGhlcmUgZnJvbSBMaW5h
cm8gT3BlbiBEaXNjdXNzaW9uIExpc3QgZm9yIG1vcmUgZXllcyB0byBsb29rIGF0XQ0KPiA+Pj4+
Pg0KPiA+Pj4+PiBIZWxsbywNCj4gPj4+Pj4gSSBoYXZlIHJlY2VudGx5IHN0YXJ0ZWQgdG8gZGFi
YmxlIHdpdGggQVJNIENDQSBzdHVmZiBhbmQgY2hlY2sgaWYgb3VyDQo+ID4+Pj4+IHJlY2VudCBj
aGFuZ2VzIHRvIHN1cHBvcnQgdkNQVSBIb3RwbHVnIGluIEFSTTY0IGNhbiB3b3JrIGluIHRoZSBy
ZWFsbQ0KPiA+Pj4+PiB3b3JsZC4gSSBoYXZlIHJlYWxpemVkIHRoYXQgaW4gdGhlIFJNTSBzcGVj
aWZpY2F0aW9uWzFdIFBTQ0lfQ1BVX09ODQo+ID4+Pj4+IGNvbW1hbmQoQjUuMy4zKSBkb2VzIG5v
dCBoYW5kbGVzIHRoZSBQU0NJX0RFTklFRCByZXR1cm4gY29kZShCNS40LjIpLA0KPiA+Pj4+PiBm
cm9tIHRoZSBob3N0LiBUaGlzIG1pZ2h0IGJlIHJlcXVpcmVkIHRvIHN1cHBvcnQgdkNQVSBIb3Rw
bHVnIGZlYXR1cmUNCj4gPj4+Pj4gaW4gdGhlIHJlYWxtIHdvcmxkIGluIGZ1dHVyZS4gdkNQVSBI
b3RwbHVnIGlzIGFuIGltcG9ydGFudCBmZWF0dXJlIHRvDQo+ID4+Pj4+IHN1cHBvcnQga2F0YS1j
b250YWluZXJzIGluIHJlYWxtIHdvcmxkIGFzIGl0IHJlZHVjZXMgdGhlIFZNIGJvb3QgdGltZQ0K
PiA+Pj4+PiBhbmQgZmFjaWxpdGF0ZXMgZHluYW1pYyBhZGp1c3RtZW50IG9mIHZDUFVzICh3aGlj
aCBJIHRoaW5rIHNob3VsZCBiZQ0KPiA+Pj4+PiB0cnVlIGV2ZW4gd2l0aCBSZWFsbSB3b3JsZCBh
cyBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9ubHkgbWFrZXMgdXNlDQo+ID4+Pj4+IG9mIHRoZSBQ
U0NJX09OL09GRiB0byByZWFsaXplIHRoZSBIb3RwbHVnIGxvb2stbGlrZSBlZmZlY3Q/KQ0KPiA+
Pj4+Pg0KPiA+Pj4+Pg0KPiA+Pj4+PiBBcyBwZXIgb3VyIHJlY2VudCBjaGFuZ2VzIFsyXSwgWzNd
IHJlbGF0ZWQgdG8gc3VwcG9ydCB2Q1BVIEhvdHBsdWcgb24NCj4gPj4+Pj4gQVJNNjQsIHdlIGhh
bmRsZSB0aGUgZ3Vlc3QgZXhpdHMgZHVlIHRvIFNNQy9IVkMgSHlwZXJjYWxsIGluIHRoZQ0KPiA+
Pj4+PiB1c2VyLXNwYWNlIGkuZS4gVk1NL1FlbXUuIEluIHJlYWxtIHdvcmxkLCBSRUMgRXhpdHMg
dG8gaG9zdCBkdWUgdG8NCj4gPj4+Pj4gUFNDSV9DUFVfT04gc2hvdWxkIHVuZGVyZ28gc2ltaWxh
ciBwb2xpY3kgY2hlY2tzIGFuZCBJIHRoaW5rLA0KPiA+Pj4+Pg0KPiA+Pj4+PiAxLiBIb3N0IHNo
b3VsZCAqZGVueSogdG8gb25saW5lIHRoZSB0YXJnZXQgdkNQVXMgd2hpY2ggYXJlIE5PVCBwbHVn
Z2VkDQo+ID4+Pj4+IDIuIFRoaXMgbWVhbnMgdGFyZ2V0IFJFQyBzaG91bGQgYmUgZGVuaWVkIGJ5
IGhvc3QuIENhbiBob3N0IGNhbGwNCj4gPj4+Pj4gICAgUk1JX1BTQ0lfQ09NUEVURSBpbiBzdWNo
IHMgY2FzZT8NCj4gPj4+Pj4gMy4gVGhlICpyZXR1cm4qIHZhbHVlIChCNS4zLjMuMS4zIE91dHB1
dCB2YWx1ZXMpIHNob3VsZCBiZSBQU0NJX0RFTklFRA0KPiA+Pj4+PiA0LiBGYWlsdXJlIGNvbmRp
dGlvbiAoQjUuMy4zLjIpIHNob3VsZCBiZSBhbWVuZGVkIHdpdGgNCj4gPj4+Pj4gICAgcnVubmFi
bGUgcHJlOiB0YXJnZXRfcmVjLmZsYWdzLnJ1bm5hYmxlID09IE5PVF9SVU5OQUJMRSAoPykNCj4g
Pj4+Pj4gICAgICAgICAgICAgcG9zdDogcmVzdWx0ID09IFBTQ0lfREVOSUVEICg/KQ0KPiA+Pj4+
PiA1LiBDaGFuZ2Ugd291bGQgYWxzbyBiZSByZXF1aXJlZCBpbiB0aGUgZmxvdyAoRDEuNCBQU0NJ
IGZsb3dzKSBkZXBpY3RpbmcNCj4gPj4+Pj4gICAgUFNDSV9DUFVfT04gZmxvdyAoRDEuNC4xKQ0K
PiA+Pj4+Pg0KPiA+Pj4+Pg0KPiA+Pj4+PiBJIGRvIHVuZGVyc3RhbmQgdGhhdCBBUk0gQ0NBIHN1
cHBvcnQgaXMgaW4gaXRzIGluZmFuY3kgc3RhZ2UgYW5kDQo+ID4+Pj4+IGRpc2N1c3NpbmcgYWJv
dXQgdkNQVSBIb3RwbHVnIGluIHJlYWxtIHdvcmxkIHNlZW0gdG8gYmUgYSBmYXItZmV0Y2hlZA0K
PiA+Pj4+PiBpZGVhIHJpZ2h0IG5vdy4gQnV0IHNwZWNpZmljYXRpb24gY2hhbmdlcyByZXF1aXJl
IGxvdCBvZiB0aW1lIGFuZCBpZg0KPiA+Pj4+PiB0aGlzIGNoYW5nZSBpcyByZWFsbHkgcmVxdWly
ZWQgdGhlbiBpdCBzaG91bGQgYmUgZnVydGhlciBkaXNjdXNzZWQNCj4gPj4+Pj4gd2l0aGluIEFS
TS4NCj4gPj4+Pj4NCj4gPj4+Pj4gTWFueSB0aGFua3MhDQo+ID4+Pj4+DQo+ID4+Pj4+DQo+ID4+
Pj4+IEJlcyByZWdhcmRzDQo+ID4+Pj4+IFNhbGlsDQo+ID4+Pj4+DQo+ID4+Pj4+DQo+ID4+Pj4+
IFJlZmVyZW5jZXM6DQo+ID4+Pj4+DQo+ID4+Pj4+IFsxXSBodHRwczovL2RldmVsb3Blci5hcm0u
Y29tL2RvY3VtZW50YXRpb24vZGVuMDEzNy9sYXRlc3QvDQo+ID4+Pj4+IFsyXSBodHRwczovL2dp
dGh1Yi5jb20vc2FsaWwtbWVodGEvcWVtdS5naXQgdmlydC1jcHVocC1hcm12OC9yZmMtdjEtcG9y
dDExMDUyMDIzLmRldi0xDQo+ID4+Pj4+IFszXSBodHRwczovL2dpdC5naXRsYWIuYXJtLmNvbS9s
aW51eC1hcm0vbGludXgtam0uZ2l0IHZpcnR1YWxfY3B1X2hvdHBsdWcvcmZjL3YyDQoNCg0KDQoN
Cg==
