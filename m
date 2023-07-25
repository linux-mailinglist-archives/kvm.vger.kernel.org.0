Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040DD760470
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 02:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjGYA42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 20:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjGYA41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 20:56:27 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD5C10F7;
        Mon, 24 Jul 2023 17:56:24 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R8z5z6yYFz67L8m;
        Tue, 25 Jul 2023 08:52:55 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 01:56:21 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Tue, 25 Jul 2023 01:56:21 +0100
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
Thread-Index: Adm55YYLPryt1tEKR0alBn01xBiFBwEoRICAAAIxYpA=
Date:   Tue, 25 Jul 2023 00:56:21 +0000
Message-ID: <d13c4cb44a2b4b42a8b534c38c402a1d@huawei.com>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
 <2fa14ef5-b2f7-459d-8b84-114d36ba3cf7@loongson.cn>
In-Reply-To: <2fa14ef5-b2f7-459d-8b84-114d36ba3cf7@loongson.cn>
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

SGkgQmlibywNCg0KPiBGcm9tOiBiaWJvIG1hbyA8bWFvYmlib0Bsb29uZ3Nvbi5jbj4NCj4gU2Vu
dDogVHVlc2RheSwgSnVseSAyNSwgMjAyMyAxOjI5IEFNDQo+IFRvOiBTYWxpbCBNZWh0YSA8c2Fs
aWwubWVodGFAaHVhd2VpLmNvbT4NCj4gQ2M6IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJp
bmFzQGFybS5jb20+OyBKb25hdGhhbiBDYW1lcm9uDQo+IDxqb25hdGhhbi5jYW1lcm9uQGh1YXdl
aS5jb20+OyBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPjsgV2lsbCBEZWFjb24NCj4gPHdp
bGxAa2VybmVsLm9yZz47IGNocmlzdG9mZmVyLmRhbGxAYXJtLmNvbTsgb2xpdmVyLnVwdG9uQGxp
bnV4LmRldjsNCj4gbWFyay5ydXRsYW5kQGFybS5jb207IHBib256aW5pQHJlZGhhdC5jb207IFNh
bGlsIE1laHRhDQo+IDxzYWxpbC5tZWh0YUBvcG5zcmMubmV0PjsgYW5kcmV3LmpvbmVzQGxpbnV4
LmRldjsgeXV6ZW5naHVpDQo+IDx5dXplbmdodWlAaHVhd2VpLmNvbT47IGt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHU7IGxpbnV4LWFybS0NCj4ga2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHFl
bXUtZGV2ZWxAbm9uZ251Lm9yZzsgamFtZXMubW9yc2VAYXJtLmNvbTsNCj4gc3RldmVuLnByaWNl
QGFybS5jb207IFN1enVraSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+OyBKZWFu
LQ0KPiBQaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+OyBrdm1hcm1A
bGlzdHMubGludXguZGV2OyBsaW51eC0NCj4gY29jb0BsaXN0cy5saW51eC5kZXYNCj4gU3ViamVj
dDogUmU6IFtRdWVzdGlvbiAtIEFSTSBDQ0FdIHZDUFUgSG90cGx1ZyBTdXBwb3J0IGluIEFSTSBS
ZWFsbSB3b3JsZA0KPiBtaWdodCByZXF1aXJlIEFSTSBzcGVjIGNoYW5nZT8NCj4gDQo+IElzIHZj
cHUgaG90cGx1ZyBzdXBwb3J0ZWQgaW4gYXJtIHZpcnQtbWFjaGluZSBub3c/DQoNCk5vdCB5ZXQu
IFdlIGFyZSB3b3JraW5nIG9uIGl0LiBQbGVhc2UgY2hlY2sgdGhlIFJGQ3MgYmVpbmcgdGVzdGVk
Lg0KDQoNClsxXSBQcmUtUkZDIFYyIENoYW5nZXM6IFN1cHBvcnQgb2YgVmlydHVhbCBDUFUgSG90
cGx1ZyBmb3IgQVJNdjggQXJjaCAgKFdJUCkNCiAgICBodHRwczovL2dpdGh1Yi5jb20vc2FsaWwt
bWVodGEvcWVtdS5naXQgdmlydC1jcHVocC1hcm12OC9yZmMtdjEtcG9ydDExMDUyMDIzLmRldi0x
DQpbMl0gW1JGQyBQQVRDSCAwMC8zMl0gQUNQSS9hcm02NDogYWRkIHN1cHBvcnQgZm9yIHZpcnR1
YWwgY3B1aG90cGx1ZyAgDQogICAgaHR0cHM6Ly9naXQuZ2l0bGFiLmFybS5jb20vbGludXgtYXJt
L2xpbnV4LWptLmdpdCB2aXJ0dWFsX2NwdV9ob3RwbHVnL3JmYy92Mg0KICAgIA0KICAgIA0KPiBU
aGVyZSBpcyBhcm02NCB2Y3B1IGhvdHBsdWcgcGF0Y2ggaW4gcWVtdSBtYWlsaW5nIGxpc3QsIGhv
d2V2ZXIgaXQgaXMgbm90IG1lcmdlZC4NCj4gSSBkbyBub3Qga25vdyB3aHkgaXQgaXMgbm90IG1l
cmdlZC4NCg0KDQpJIHRoaW5rIHlvdSBhcmUgcmVmZXJyaW5nIHRvIHBhdGNoZXMgWzNdLCBbNF0/
IFBsZWFzZSBmb2xsb3cgdGhlIGRpc2N1c3Npb24NCmZvciBkZXRhaWxzLiANCg0KDQpbM10gW1BB
VENIIFJGQyAwMC8yMl0gU3VwcG9ydCBvZiBWaXJ0dWFsIENQVSBIb3RwbHVnIGZvciBBUk12OCBB
cmNoDQogICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjAwNjEzMjEzNjI5LjIxOTg0
LTEtc2FsaWwubWVodGFAaHVhd2VpLmNvbS8NCls0XSBbUEFUQ0ggUkZDIDAvNF0gQ2hhbmdlcyB0
byBTdXBwb3J0ICpWaXJ0dWFsKiBDUFUgSG90cGx1ZyBmb3IgQVJNNjQNCiAgICBodHRwczovL2xv
cmUua2VybmVsLm9yZy9hbGwvMjAyMDA2MjUxMzM3NTcuMjIzMzItMS1zYWxpbC5tZWh0YUBodWF3
ZWkuY29tLyNyDQoNCg0KSW4gc3VtbWFyeSwgdGhlcmUgd2VyZSBzb21lIEFSTTY0IEFyY2hpdGVj
dHVyZSBjb25zdHJhaW50cyB3aGljaCB3ZXJlIGJlaW5nDQp2aW9sYXRlZCBpbiB0aGUgZWFybGll
ciBwYXRjaGVzIG9mIHRoZSBrZXJuZWwgWzRdIHNvIHdlIGhhZCB0byByZS10aGluayBvZiB0aGUN
Cmtlcm5lbCBjaGFuZ2VzLiBUaGUgUWVtdSBwYXJ0IG1vc3RseSByZW1haW5zIHNhbWUgd2l0aCBz
b21lIG5ldyBpbnRyb2R1Y3Rpb25zDQpvZiBHdWVzdCBIVkMvU01DIGh5cGVyIGNhbGwgZXhpdCBo
YW5kbGluZyBpbiB1c2VyIHNwYWNlIGV0Yy4gZm9yIHBvbGljeSBjaGVja3MNCmluIFZNTS9RZW11
LiANCg0KDQpZb3UgY2FuIGZvbGxvdyB0aGUgS1ZNRm9ydW0gY29uZmVyZW5jZSBwcmVzZW50YXRp
b25zIFs1XSwgWzZdIGRlbGl2ZXJlZCBpbiB0aGUNCnllYXIgMjAyMCBhbmQgMjAyMyB0byBnZXQg
aG9sZCBvZiBtb3JlIGRldGFpbHMgcmVsYXRlZCB0byB0aGlzLg0KDQoNCls1XSBLVk1Gb3J1bSAy
MDIzOiBDaGFsbGVuZ2VzIFJldmlzaXRlZCBpbiBTdXBwb3J0aW5nIFZpcnQgQ1BVIEhvdHBsdWcg
b24gYXJjaGl0ZWN0dXJlcyB0aGF0IGRvbid0IFN1cHBvcnQgQ1BVIEhvdHBsdWcgKGxpa2UgQVJN
NjQpDQogICAgaHR0cHM6Ly9rdm0tZm9ydW0ucWVtdS5vcmcvMjAyMy90YWxrLzlTTVBEUS8NCls2
XSBLVk1Gb3J1bSAyMDIwOiBDaGFsbGVuZ2VzIGluIFN1cHBvcnRpbmcgVmlydHVhbCBDUFUgSG90
cGx1ZyBvbiBTb0MgQmFzZWQgU3lzdGVtcyAobGlrZSBBUk02NCkNCiAgICBodHRwczovL2t2bWZv
cnVtMjAyMC5zY2hlZC5jb20vZXZlbnQvZUU0bQ0KDQoNCg0KPiBJIGFzayB0aGlzIHF1ZXN0aW9u
IGJlY2F1c2Ugd2UgcHJvcG9zZQ0KPiBzaW1pbGFyIHBhdGNoIGFib3V0IExvb25nQXJjaCBzeXN0
ZW0gaW4gcWVtdSBtYWlsaW5nIGxpc3QsIGFuZCBrZXJuZWwgbmVlZCBub3QgYmUNCj4gbW9kaWZp
ZWQgZm9yIHZjcHUgaG90cGx1Zy4NCg0KDQpDb3VsZCB5b3UgcGxlYXNlIHNoYXJlIHRoZSBsaW5r
IG9mIHlvdXIgcGF0Y2hlcyBzbyB0aGF0IHdlIGNhbiBoYXZlIGEgbG9vayBhbmQNCmRyYXcgYSBj
b21wYXJpc29uPw0KDQoNClRoYW5rcw0KU2FsaWwuDQoNCj4gDQo+IFJlZ2FyZHMNCj4gQmlibywg
bWFvDQo+IA0KPiDlnKggMjAyMy83LzE5IDEwOjM1LCBTYWxpbCBNZWh0YSDlhpnpgZM6DQo+ID4g
W1JlcG9zdGluZyBpdCBoZXJlIGZyb20gTGluYXJvIE9wZW4gRGlzY3Vzc2lvbiBMaXN0IGZvciBt
b3JlIGV5ZXMgdG8gbG9vaw0KPiBhdF0NCj4gPg0KPiA+IEhlbGxvLA0KPiA+IEkgaGF2ZSByZWNl
bnRseSBzdGFydGVkIHRvIGRhYmJsZSB3aXRoIEFSTSBDQ0Egc3R1ZmYgYW5kIGNoZWNrIGlmIG91
cg0KPiA+IHJlY2VudCBjaGFuZ2VzIHRvIHN1cHBvcnQgdkNQVSBIb3RwbHVnIGluIEFSTTY0IGNh
biB3b3JrIGluIHRoZSByZWFsbQ0KPiA+IHdvcmxkLiBJIGhhdmUgcmVhbGl6ZWQgdGhhdCBpbiB0
aGUgUk1NIHNwZWNpZmljYXRpb25bMV0gUFNDSV9DUFVfT04NCj4gPiBjb21tYW5kKEI1LjMuMykg
ZG9lcyBub3QgaGFuZGxlcyB0aGUgUFNDSV9ERU5JRUQgcmV0dXJuIGNvZGUoQjUuNC4yKSwNCj4g
PiBmcm9tIHRoZSBob3N0LiBUaGlzIG1pZ2h0IGJlIHJlcXVpcmVkIHRvIHN1cHBvcnQgdkNQVSBI
b3RwbHVnIGZlYXR1cmUNCj4gPiBpbiB0aGUgcmVhbG0gd29ybGQgaW4gZnV0dXJlLiB2Q1BVIEhv
dHBsdWcgaXMgYW4gaW1wb3J0YW50IGZlYXR1cmUgdG8NCj4gPiBzdXBwb3J0IGthdGEtY29udGFp
bmVycyBpbiByZWFsbSB3b3JsZCBhcyBpdCByZWR1Y2VzIHRoZSBWTSBib290IHRpbWUNCj4gPiBh
bmQgZmFjaWxpdGF0ZXMgZHluYW1pYyBhZGp1c3RtZW50IG9mIHZDUFVzICh3aGljaCBJIHRoaW5r
IHNob3VsZCBiZQ0KPiA+IHRydWUgZXZlbiB3aXRoIFJlYWxtIHdvcmxkIGFzIGN1cnJlbnQgaW1w
bGVtZW50YXRpb24gb25seSBtYWtlcyB1c2UNCj4gPiBvZiB0aGUgUFNDSV9PTi9PRkYgdG8gcmVh
bGl6ZSB0aGUgSG90cGx1ZyBsb29rLWxpa2UgZWZmZWN0PykNCj4gPg0KPiA+DQo+ID4gQXMgcGVy
IG91ciByZWNlbnQgY2hhbmdlcyBbMl0sIFszXSByZWxhdGVkIHRvIHN1cHBvcnQgdkNQVSBIb3Rw
bHVnIG9uDQo+ID4gQVJNNjQsIHdlIGhhbmRsZSB0aGUgZ3Vlc3QgZXhpdHMgZHVlIHRvIFNNQy9I
VkMgSHlwZXJjYWxsIGluIHRoZQ0KPiA+IHVzZXItc3BhY2UgaS5lLiBWTU0vUWVtdS4gSW4gcmVh
bG0gd29ybGQsIFJFQyBFeGl0cyB0byBob3N0IGR1ZSB0bw0KPiA+IFBTQ0lfQ1BVX09OIHNob3Vs
ZCB1bmRlcmdvIHNpbWlsYXIgcG9saWN5IGNoZWNrcyBhbmQgSSB0aGluaywNCj4gPg0KPiA+IDEu
IEhvc3Qgc2hvdWxkICpkZW55KiB0byBvbmxpbmUgdGhlIHRhcmdldCB2Q1BVcyB3aGljaCBhcmUg
Tk9UIHBsdWdnZWQNCj4gPiAyLiBUaGlzIG1lYW5zIHRhcmdldCBSRUMgc2hvdWxkIGJlIGRlbmll
ZCBieSBob3N0LiBDYW4gaG9zdCBjYWxsDQo+ID4gICAgUk1JX1BTQ0lfQ09NUEVURSBpbiBzdWNo
IHMgY2FzZT8NCj4gPiAzLiBUaGUgKnJldHVybiogdmFsdWUgKEI1LjMuMy4xLjMgT3V0cHV0IHZh
bHVlcykgc2hvdWxkIGJlIFBTQ0lfREVOSUVEDQo+ID4gNC4gRmFpbHVyZSBjb25kaXRpb24gKEI1
LjMuMy4yKSBzaG91bGQgYmUgYW1lbmRlZCB3aXRoDQo+ID4gICAgcnVubmFibGUgcHJlOiB0YXJn
ZXRfcmVjLmZsYWdzLnJ1bm5hYmxlID09IE5PVF9SVU5OQUJMRSAoPykNCj4gPiAgICAgICAgICAg
ICBwb3N0OiByZXN1bHQgPT0gUFNDSV9ERU5JRUQgKD8pDQo+ID4gNS4gQ2hhbmdlIHdvdWxkIGFs
c28gYmUgcmVxdWlyZWQgaW4gdGhlIGZsb3cgKEQxLjQgUFNDSSBmbG93cykgZGVwaWN0aW5nDQo+
ID4gICAgUFNDSV9DUFVfT04gZmxvdyAoRDEuNC4xKQ0KPiA+DQo+ID4NCj4gPiBJIGRvIHVuZGVy
c3RhbmQgdGhhdCBBUk0gQ0NBIHN1cHBvcnQgaXMgaW4gaXRzIGluZmFuY3kgc3RhZ2UgYW5kDQo+
ID4gZGlzY3Vzc2luZyBhYm91dCB2Q1BVIEhvdHBsdWcgaW4gcmVhbG0gd29ybGQgc2VlbSB0byBi
ZSBhIGZhci1mZXRjaGVkDQo+ID4gaWRlYSByaWdodCBub3cuIEJ1dCBzcGVjaWZpY2F0aW9uIGNo
YW5nZXMgcmVxdWlyZSBsb3Qgb2YgdGltZSBhbmQgaWYNCj4gPiB0aGlzIGNoYW5nZSBpcyByZWFs
bHkgcmVxdWlyZWQgdGhlbiBpdCBzaG91bGQgYmUgZnVydGhlciBkaXNjdXNzZWQNCj4gPiB3aXRo
aW4gQVJNLg0KPiA+DQo+ID4gTWFueSB0aGFua3MhDQo+ID4NCj4gPg0KPiA+IEJlcyByZWdhcmRz
DQo+ID4gU2FsaWwNCj4gPg0KPiA+DQo+ID4gUmVmZXJlbmNlczoNCj4gPg0KPiA+IFsxXSBodHRw
czovL2RldmVsb3Blci5hcm0uY29tL2RvY3VtZW50YXRpb24vZGVuMDEzNy9sYXRlc3QvDQo+ID4g
WzJdIGh0dHBzOi8vZ2l0aHViLmNvbS9zYWxpbC1tZWh0YS9xZW11LmdpdCB2aXJ0LWNwdWhwLWFy
bXY4L3JmYy12MS1wb3J0MTEwNTIwMjMuZGV2LTENCj4gPiBbM10gaHR0cHM6Ly9naXQuZ2l0bGFi
LmFybS5jb20vbGludXgtYXJtL2xpbnV4LWptLmdpdCB2aXJ0dWFsX2NwdV9ob3RwbHVnL3JmYy92
Mg0K
