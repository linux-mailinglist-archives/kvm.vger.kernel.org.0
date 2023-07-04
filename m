Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0819746E11
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 11:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjGDJ6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 05:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjGDJ6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 05:58:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A040E5
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 02:58:18 -0700 (PDT)
Received: from lhrpeml500003.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QwJ8v27qlz6J7Tr;
        Tue,  4 Jul 2023 17:56:31 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 4 Jul 2023 10:58:16 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Tue, 4 Jul 2023 10:58:16 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Shaoqin Huang <shahuang@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>
CC:     "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Salil Mehta <salil.mehta@opnsrc.net>
Subject: RE: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
Thread-Topic: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
Thread-Index: AQHZp/pp444fl0T5A0KjPRKELV/ZGK+dFe3AgADJLYCAC4aZ8A==
Date:   Tue, 4 Jul 2023 09:58:15 +0000
Message-ID: <539e6a25b89a45839de37fe92b27d0d3@huawei.com>
References: <20230626064910.1787255-1-shahuang@redhat.com>
 <9df973ede74e4757b510f26cd5786036@huawei.com>
 <fb5e8d4d-2388-3ab0-aaac-a1dd91e74b08@redhat.com>
In-Reply-To: <fb5e8d4d-2388-3ab0-aaac-a1dd91e74b08@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.147.121]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgU2hhb3FpbiwNCkp1c3Qgc2F3IHRoaXMuIEFwb2xvZ2llcy4gSSBtaXNzZWQgdG8gcmVwbHkg
dGhpcyBlYXJsaWVyIGFzIEkgd2FzIGJpdA0KZGlzY29ubmVjdGVkIGZvciBsYXN0IGZldyBkYXlz
Lg0KDQoNCj4gRnJvbTogU2hhb3FpbiBIdWFuZyA8c2hhaHVhbmdAcmVkaGF0LmNvbT4NCj4gU2Vu
dDogVHVlc2RheSwgSnVuZSAyNywgMjAyMyAzOjM1IEFNDQoNCj4gSGkgU2FsaWwsDQo+IA0KPiBP
biA2LzI2LzIzIDIxOjQyLCBTYWxpbCBNZWh0YSB3cm90ZToNCj4gPj4gRnJvbTogU2hhb3FpbiBI
dWFuZyA8c2hhaHVhbmdAcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogTW9uZGF5LCBKdW5lIDI2LCAy
MDIzIDc6NDkgQU0NCj4gPj4gVG86IHFlbXUtZGV2ZWxAbm9uZ251Lm9yZzsgcWVtdS1hcm1Abm9u
Z251Lm9yZw0KPiA+PiBDYzogb2xpdmVyLnVwdG9uQGxpbnV4LmRldjsgU2FsaWwgTWVodGEgPHNh
bGlsLm1laHRhQGh1YXdlaS5jb20+Ow0KPiA+PiBqYW1lcy5tb3JzZUBhcm0uY29tOyBnc2hhbkBy
ZWRoYXQuY29tOyBTaGFvcWluIEh1YW5nIDxzaGFodWFuZ0ByZWRoYXQuY29tPjsNCj4gPj4gQ29y
bmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+OyBrdm1Admdlci5rZXJuZWwub3JnOyBNaWNo
YWVsIFMuIFRzaXJraW4NCj4gPj4gPG1zdEByZWRoYXQuY29tPjsgUGFvbG8gQm9uemluaSA8cGJv
bnppbmlAcmVkaGF0LmNvbT47IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9y
Zz4NCj4gPj4gU3ViamVjdDogW1BBVENIIHYxIDAvNV0gdGFyZ2V0L2FybTogSGFuZGxlIHBzY2kg
Y2FsbHMgaW4gdXNlcnNwYWNlDQo+ID4+DQo+ID4+IFRoZSB1c2Vyc3BhY2UgU01DQ0MgY2FsbCBm
aWx0ZXJpbmdbMV0gcHJvdmlkZXMgdGhlIGFiaWxpdHkgdG8gZm9yd2FyZCB0aGUgU01DQ0MNCj4g
Pj4gY2FsbHMgdG8gdGhlIHVzZXJzcGFjZS4gVGhlIHZDUFUgaG90cGx1Z1syXSB3b3VsZCBiZSB0
aGUgZmlyc3QgbGVnaXRpbWF0ZSB1c2UNCj4gPj4gY2FzZSB0byBoYW5kbGUgdGhlIHBzY2kgY2Fs
bHMgaW4gdXNlcnNwYWNlLCB0aHVzIHRoZSB2Q1BVIGhvdHBsdWcgY2FuIGRlbnkgdGhlDQo+ID4+
IFBTQ0lfT04gY2FsbCBpZiB0aGUgdkNQVSBpcyBub3QgcHJlc2VudCBub3cuDQo+ID4+DQo+ID4+
IFRoaXMgc2VyaWVzIHRyeSB0byBlbmFibGUgdGhlIHVzZXJzcGFjZSBTTUNDQyBjYWxsIGZpbHRl
cmluZywgdGh1cyBjYW4gaGFuZGxlDQo+ID4+IHRoZSBTTUNDQyBjYWxsIGluIHVzZXJzcGFjZS4g
VGhlIGZpcnN0IGVuYWJsZWQgU01DQ0MgY2FsbCBpcyBwc2NpIGNhbGwsIGJ5IHVzaW5nDQo+ID4+
IHRoZSBuZXcgYWRkZWQgb3B0aW9uICd1c2VyLXNtY2NjJywgd2UgY2FuIGVuYWJsZSBoYW5kbGUg
cHNjaSBjYWxscyBpbiB1c2Vyc3BhY2UuDQo+ID4+DQo+ID4+IHFlbXUtc3lzdGVtLWFhcmNoNjQg
LW1hY2hpbmUgdmlydCx1c2VyLXNtY2NjPW9uDQo+ID4+DQo+ID4+IFRoaXMgc2VyaWVzIHJldXNl
IHRoZSBxZW11IGltcGxlbWVudGF0aW9uIG9mIHRoZSBwc2NpIGhhbmRsaW5nLCB0aHVzIHRoZQ0K
PiA+PiBoYW5kbGluZyBwcm9jZXNzIGlzIHZlcnkgc2ltcGxlLiBCdXQgd2hlbiBoYW5kbGluZyBw
c2NpIGluIHVzZXJzcGFjZSB3aGVuIHVzaW5nDQo+ID4+IGt2bSwgdGhlIHJlc2V0IHZjcHUgcHJv
Y2VzcyBuZWVkIHRvIGJlIHRha2luZyBjYXJlLCB0aGUgZGV0YWlsIGlzIGluY2x1ZGVkIGluDQo+
ID4+IHRoZSBwYXRjaDA1Lg0KPiA+DQo+ID4gVGhpcyBjaGFuZ2UgaXMgaW50ZW5kZWQgZm9yIFZD
UFUgSG90cGx1ZyBhbmQgYXJlIGR1cGxpY2F0aW5nIHRoZSBjb2RlDQo+ID4gd2UgYXJlIHdvcmtp
bmcgb24uIFVubGVzcyB0aGlzIGNoYW5nZSBpcyBhbHNvIGludGVuZGVkIGZvciBhbnkgb3RoZXIN
Cj4gPiBmZWF0dXJlIEkgd291bGQgcmVxdWVzdCB5b3UgdG8gZGVmZXIgdGhpcy4NCj4gDQo+IFRo
YW5rcyBmb3Igc2hhcmluZyBtZSB0aGUgaW5mb3JtYXRpb24uIEknbSBub3QgaW50ZW5kZWQgZm9y
IG1lcmdpbmcgdGhpcw0KPiBzZXJpZXMsIGJ1dCBkaXNjdXNzIHNvbWV0aGluZyBhYm91dCB0aGUg
VkNQVSBIb3RwbHVnLCBzaW5jZSBJJ20gYWxzbw0KPiBmb2xsb3dpbmcgdGhlIHdvcmsgb2YgdkNQ
VSBIb3RwbHVnLg0KDQpTdXJlLiBJIGFtIG5vdCBhZ2FpbnN0IHRoaXMgd29yayBpbiBhbnkgd2F5
IGJ1dCB0aGVyZSB3YXMgYml0IG9mIGFuIG92ZXJsYXAgYW5kIHdhcw0KdHJ5aW5nIHRvIGF2b2lk
IHRoYXQuIA0KDQo+IA0KPiBKdXN0IGN1cmlvdXMsIHdoYXQgaXMgeW91ciBwbGFuIHRvIHVwZGF0
ZSBhIG5ldyB2ZXJzaW9uIG9mIFZDUFUgSG90cGx1Zw0KPiB3aGljaCBpcyBiYXNlZCBvbiB0aGUg
dXNlcnNwYWNlIFNNQ0NDIGZpbHRlcmluZz8NCg0KV2UgaGF2ZSBhbHJlYWR5IGluY29ycG9yYXRl
ZCB0aGlzLiBXZSBoYXZlIG5vdCB0ZXN0ZWQgaXQgcHJvcGVybHkgdGhvdWdoIGFuZA0KdGhlcmUg
YXJlIHNvbWUgaXNzdWVzIHJlbGF0ZWQgdG8gdGhlIG1pZ3JhdGlvbiB3ZSBhcmUgZml4aW5nLg0K
DQpJIGRpZCBtZW50aW9uIGFib3V0IHRoaXMgaW4gdGhlIEtWTUZvcnVtMjAyMyBwcmVzZW50YXRp
b24gYXMgd2VsbC4NCg0KTGF0ZXN0IFFlbXUgUHJvdG90eXBlIChQcmUgUkZDIFYyKSAoTm90IGlu
IHRoZSBmaW5hbCBzaGFwZSBvZiB0aGUgcGF0Y2hlcykNCmh0dHBzOi8vZ2l0aHViLmNvbS9zYWxp
bC1tZWh0YS9xZW11LmdpdMKgIMKgdmlydC1jcHVocC1hcm12OC9yZmMtdjEtcG9ydDExMDUyMDIz
LmRldi0xDQoNCg0Kc2hvdWxkIHdvcmsgYWdhaW5zdCBiZWxvdyBrZXJuZWwgY2hhbmdlcyBhcyBj
b25maXJtZWQgYnkgSmFtZXMsDQoNCkxhdGVzdCBLZXJuZWwgUHJvdG90eXBlIChQcmUgUkZDIFYy
ID0gUkZDIFYxICsgRml4ZXMpwqANCmh0dHBzOi8vZ2l0LmdpdGxhYi5hcm0uY29tL2xpbnV4LWFy
bS9saW51eC1qbS5naXTCoCAgdmlydHVhbF9jcHVfaG90cGx1Zy9yZmMvdjIgIA0KDQoNCldlIGhh
dmUgbm90IGFkZGVkIHRoZSBzdXBwb3J0IG9mIHVzZXItY29uZmlndXJhYmlsaXR5IHdoaWNoIHlv
dXIgcGF0Y2gtc2V0IGRvZXMuDQoNCg0KTWFueSB0aGFua3MNClNhbGlsLg0KDQoNCg0KDQoNCg0K
DQoNCg0KDQoNCg==
