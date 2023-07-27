Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEC67655DB
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 16:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjG0OYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 10:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjG0OYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 10:24:10 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F72A273C;
        Thu, 27 Jul 2023 07:24:09 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RBXxZ6j4Qz67lWw;
        Thu, 27 Jul 2023 22:21:06 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 15:24:06 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Thu, 27 Jul 2023 15:24:06 +0100
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
Thread-Index: Adm55YYLPryt1tEKR0alBn01xBiFBwANXi2AAQoU7gAAA+aEUAAjqFEAAGzOg6A=
Date:   Thu, 27 Jul 2023 14:24:06 +0000
Message-ID: <ef506b02d6774a7d87f6b2d941427333@huawei.com>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
        <7da93c6e-1cbf-8840-282e-f115197b80c4@arm.com>
        <0d268afa-c04b-7a4e-be5e-2362d3dfa64d@arm.com>
        <93c9c8356e444fb287393a935a8c7899@huawei.com>
 <8a828ef2-b09b-4322-26fa-eae6cc88753f@arm.com>
In-Reply-To: <8a828ef2-b09b-4322-26fa-eae6cc88753f@arm.com>
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

SGkgU3V6dWtpLA0KDQo+IEZyb206IFN1enVraSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFy
bS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjUsIDIwMjMgMTI6MjAgUE0NCj4gDQo+IEhp
IFNhbGlsDQo+IA0KPiBPbiAyNS8wNy8yMDIzIDAxOjA1LCBTYWxpbCBNZWh0YSB3cm90ZToNCj4g
PiBIaSBTdXp1a2ksDQo+ID4gU29ycnkgZm9yIHJlcGx5aW5nIGxhdGUgYXMgSSB3YXMgb24vb2Zm
IGxhc3Qgd2VlayB0byB1bmRlcmdvIHNvbWUgbWVkaWNhbCB0ZXN0Lg0KPiA+DQo+ID4+IEZyb206
IFN1enVraSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+DQo+ID4+IFNlbnQ6IE1v
bmRheSwgSnVseSAyNCwgMjAyMyA1OjI3IFBNDQo+ID4+DQo+ID4+IEhpIFNhbGlsDQo+ID4+DQo+
ID4+IE9uIDE5LzA3LzIwMjMgMTA6MjgsIFN1enVraSBLIFBvdWxvc2Ugd3JvdGU6DQo+ID4+PiBI
aSBTYWxpbA0KPiA+Pj4NCj4gPj4+IFRoYW5rcyBmb3IgcmFpc2luZyB0aGlzLg0KPiA+Pj4NCj4g
Pj4+IE9uIDE5LzA3LzIwMjMgMDM6MzUsIFNhbGlsIE1laHRhIHdyb3RlOg0KPiA+Pj4+IFtSZXBv
c3RpbmcgaXQgaGVyZSBmcm9tIExpbmFybyBPcGVuIERpc2N1c3Npb24gTGlzdCBmb3IgbW9yZSBl
eWVzIHRvIGxvb2sgYXRdDQo+ID4+Pj4NCj4gPj4+PiBIZWxsbywNCj4gPj4+PiBJIGhhdmUgcmVj
ZW50bHkgc3RhcnRlZCB0byBkYWJibGUgd2l0aCBBUk0gQ0NBIHN0dWZmIGFuZCBjaGVjayBpZiBv
dXINCj4gPj4+PiByZWNlbnQgY2hhbmdlcyB0byBzdXBwb3J0IHZDUFUgSG90cGx1ZyBpbiBBUk02
NCBjYW4gd29yayBpbiB0aGUgcmVhbG0NCj4gPj4+PiB3b3JsZC4gSSBoYXZlIHJlYWxpemVkIHRo
YXQgaW4gdGhlIFJNTSBzcGVjaWZpY2F0aW9uWzFdIFBTQ0lfQ1BVX09ODQo+ID4+Pj4gY29tbWFu
ZChCNS4zLjMpIGRvZXMgbm90IGhhbmRsZXMgdGhlIFBTQ0lfREVOSUVEIHJldHVybiBjb2RlKEI1
LjQuMiksDQo+ID4+Pj4gZnJvbSB0aGUgaG9zdC4gVGhpcyBtaWdodCBiZSByZXF1aXJlZCB0byBz
dXBwb3J0IHZDUFUgSG90cGx1ZyBmZWF0dXJlDQo+ID4+Pj4gaW4gdGhlIHJlYWxtIHdvcmxkIGlu
IGZ1dHVyZS4gdkNQVSBIb3RwbHVnIGlzIGFuIGltcG9ydGFudCBmZWF0dXJlIHRvDQo+ID4+Pj4g
c3VwcG9ydCBrYXRhLWNvbnRhaW5lcnMgaW4gcmVhbG0gd29ybGQgYXMgaXQgcmVkdWNlcyB0aGUg
Vk0gYm9vdCB0aW1lDQo+ID4+Pj4gYW5kIGZhY2lsaXRhdGVzIGR5bmFtaWMgYWRqdXN0bWVudCBv
ZiB2Q1BVcyAod2hpY2ggSSB0aGluayBzaG91bGQgYmUNCj4gPj4+PiB0cnVlIGV2ZW4gd2l0aCBS
ZWFsbSB3b3JsZCBhcyBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9ubHkgbWFrZXMgdXNlDQo+ID4+
Pj4gb2YgdGhlIFBTQ0lfT04vT0ZGIHRvIHJlYWxpemUgdGhlIEhvdHBsdWcgbG9vay1saWtlIGVm
ZmVjdD8pDQo+ID4+Pj4NCj4gPj4+Pg0KPiA+Pj4+IEFzIHBlciBvdXIgcmVjZW50IGNoYW5nZXMg
WzJdLCBbM10gcmVsYXRlZCB0byBzdXBwb3J0IHZDUFUgSG90cGx1ZyBvbg0KPiA+Pj4+IEFSTTY0
LCB3ZSBoYW5kbGUgdGhlIGd1ZXN0IGV4aXRzIGR1ZSB0byBTTUMvSFZDIEh5cGVyY2FsbCBpbiB0
aGUNCj4gPj4+PiB1c2VyLXNwYWNlIGkuZS4gVk1NL1FlbXUuIEluIHJlYWxtIHdvcmxkLCBSRUMg
RXhpdHMgdG8gaG9zdCBkdWUgdG8NCj4gPj4+PiBQU0NJX0NQVV9PTiBzaG91bGQgdW5kZXJnbyBz
aW1pbGFyIHBvbGljeSBjaGVja3MgYW5kIEkgdGhpbmssDQo+ID4+Pj4NCj4gPj4+PiAxLiBIb3N0
IHNob3VsZCAqZGVueSogdG8gb25saW5lIHRoZSB0YXJnZXQgdkNQVXMgd2hpY2ggYXJlIE5PVCBw
bHVnZ2VkDQo+ID4+Pj4gMi4gVGhpcyBtZWFucyB0YXJnZXQgUkVDIHNob3VsZCBiZSBkZW5pZWQg
YnkgaG9zdC4gQ2FuIGhvc3QgY2FsbA0KPiA+Pj4+ICDCoMKgwqAgUk1JX1BTQ0lfQ09NUEVURSBp
biBzdWNoIHMgY2FzZT8NCj4gPj4+PiAzLiBUaGUgKnJldHVybiogdmFsdWUgKEI1LjMuMy4xLjMg
T3V0cHV0IHZhbHVlcykgc2hvdWxkIGJlIFBTQ0lfREVOSUVEDQo+ID4+Pg0KPiA+Pj4gVGhlIFJl
YWxtIGV4aXQgd2l0aCBFWElUX1BTQ0kgYWxyZWFkeSBwcm92aWRlcyB0aGUgcGFyYW1ldGVycyBw
YXNzZWQNCj4gPj4+IG9udG8gdGhlIFBTQ0kgcmVxdWVzdC4gVGhpcyBoYXBwZW5zIGZvciBhbGwg
UFNDSSBjYWxscyBleGNlcHQNCj4gPj4+IChQU0NJX1ZFUlNJT04gYW5kIFBTQ0lfRkVBVVRSRVMp
LiBUaGUgaHlwIGNvdWxkIGZvcndhcmQgdGhlc2UgZXhpdHMgdG8NCj4gPj4+IHRoZSBWTU0gYW5k
IGNvdWxkIGludm9rZSB0aGUgUk1JX1BTQ0lfQ09NUExFVEUgb25seSB3aGVuIHRoZSBWTU0gYmxl
c3Nlcw0KPiA+Pj4gdGhlIHJlcXVlc3QgKHdoZXJldmVyIGFwcGxpY2FibGUpLg0KPiA+Pj4NCj4g
Pj4+IEhvd2V2ZXIsIHRoZSBSTU0gc3BlYyBjdXJyZW50bHkgZG9lc24ndCBhbGxvdyBkZW55aW5n
IHRoZSByZXF1ZXN0Lg0KPiA+Pj4gaS5lLiwgd2l0aG91dCBSTUlfUFNDSV9DT01QTEVURSwgdGhl
IFJFQyBjYW5ub3QgYmUgc2NoZWR1bGVkIGJhY2sgaW4uDQo+ID4+PiBXZSB3aWxsIGFkZHJlc3Mg
dGhpcyBpbiB0aGUgUk1NIHNwZWMgYW5kIGdldCBiYWNrIHRvIHlvdS4NCj4gPj4NCj4gPj4gVGhp
cyBpcyBub3cgcmVzb2x2ZWQgaW4gUk1NdjEuMC1lYWMzIHNwZWMsIGF2YWlsYWJsZSBoZXJlIFsw
XS4NCj4gPj4NCj4gPj4gVGhpcyBhbGxvd3MgdGhlIGhvc3QgdG8gREVOWSBhIFBTQ0lfQ1BVX09O
IHJlcXVlc3QuIFRoZSBSTU0gZW5zdXJlcyB0aGF0DQo+ID4+IHRoZSByZXNwb25zZSBkb2Vzbid0
IHZpb2xhdGUgdGhlIHNlY3VyaXR5IGd1YXJhbnRlZXMgYnkgY2hlY2tpbmcgdGhlDQo+ID4+IHN0
YXRlIG9mIHRoZSB0YXJnZXQgUkVDLg0KPiA+Pg0KPiA+PiBbMF0gaHR0cHM6Ly9kZXZlbG9wZXIu
YXJtLmNvbS9kb2N1bWVudGF0aW9uL2RlbjAxMzcvbGF0ZXN0Lw0KPiA+DQo+ID4NCj4gPiBNYW55
IHRoYW5rcyBmb3IgdGFraW5nIHRoaXMgdXAgcHJvYWN0aXZlbHkgYW5kIGdldHRpbmcgaXQgZG9u
ZSBhcyB3ZWxsDQo+ID4gdmVyeSBlZmZpY2llbnRseS4gUmVhbGx5IGFwcHJlY2lhdGUgdGhpcyEN
Cj4gPg0KPiA+IEkgYWNrbm93bGVkZ2UgYmVsb3cgbmV3IGNoYW5nZXMgcGFydCBvZiB0aGUgbmV3
bHkgcmVsZWFzZWQgUk1NDQo+ID4gU3BlY2lmaWNhdGlvbiBbM10gKFBhZ2UtMikgKFJlbGVhc2Ug
SW5mb3JtYXRpb24gMS4wLWVhYzMgMjAtMDctMjAyMyk6DQo+ID4NCj4gPiAxLiBBZGRpdGlvbiBv
ZiBCMi4xOSBQc2NpUmV0dXJuQ29kZVBlcm1pdHRlZCBmdW5jdGlvbiBbM10gKFBhZ2UtMTI2KQ0K
PiA+IDIuIEFkZGl0aW9uIG9mICdzdGF0dXMnIGluIEIzLjMuNy4yIEZhaWx1cmUgY29uZGl0aW9u
cyBvZiB0aGUNCj4gPiAgICAgQjMuMy43IFJNSV9QU0NJX0NPTVBMRVRFIGNvbW1hbmQgWzNdIChQ
YWdlLTE2MCkNCj4gPg0KPiA+DQo+ID4gU29tZSBGdXJ0aGVyIFN1Z2dlc3Rpb25zOg0KPiA+IDEu
IEl0IHdvdWxkIGJlIHJlYWxseSBoZWxwZnVsIGlmIFBTQ0lfREVOSUVEIGNhbiBiZSBhY2NvbW1v
ZGF0ZWQgc29tZXdoZXJlDQo+ID4gICAgIGluIHRoZSBmbG93IGRpYWdyYW0gKEQxLjQuMSBQU0NJ
X0NQVV9PTiBmbG93KSBbM10gKFBhZ2UtMjk3KSBhcyB3ZWxsLg0KPiANCj4gR29vZCBwb2ludCwg
eWVzLCB3aWxsIGdldCB0aGF0IGFkZGVkLg0KDQoNCkdyZWF0LiBUaGFua3MhDQoNCg0KPiA+IDIu
IFlvdSB3b3VsZCBuZWVkIGNoYW5nZXMgdG8gaGFuZGxlIHRoZSByZXR1cm4gdmFsdWUgb2YgdGhl
IFBTQ0lfREVOSUVEDQo+ID4gICAgIGluIHRoaXMgYmVsb3cgcGF0Y2ggWzJdIGFzIHdlbGwgZnJv
bSBBUk0gQ0NBIHNlcmllcyBbMV0NCj4gPg0KPiANCj4gT2YgY291cnNlLiBQbGVhc2Ugbm90ZSB0
aGF0IHRoZSBzZXJpZXMgWzFdIGlzIGJhc2VkIG9uIFJNTXYxLjAtYmV0YTAgYW5kDQo+IHdlIGFy
ZSBpbiB0aGUgcHJvY2VzcyBvZiByZWJhc2luZyBvdXIgY2hhbmdlcyB0byB2MS4wLWVhYzMsIHdo
aWNoDQo+IGluY2x1ZGVzIGEgbG90IG9mIG90aGVyIGNoYW5nZXMuIFRoZSB1cGRhdGVkIHNlcmll
cyB3aWxsIGhhdmUgYWxsIHRoZQ0KPiByZXF1aXJlZCBjaGFuZ2VzLg0KDQoNCk9rLiBXaGVuIGFy
ZSB5b3UgcGxhbm5pbmcgdG8gcG9zdCB0aGlzIG5ldyBzZXJpZXMgd2l0aCB2MS4wLWVhYzMgY2hh
bmdlcz8NCg0KDQpUaGFua3MNClNhbGlsLg0KDQo+IEtpbmQgcmVnYXJkcw0KPiBTdXp1a2kNCj4g
DQo+ID4gQEphbWVzLCBBbnkgZnVydGhlciB0aG91Z2h0cyBvbiB0aGlzPw0KPiA+DQo+ID4NCj4g
PiBSZWZlcmVuY2VzOg0KPiA+IFsxXSBbUkZDIFBBVENIIDAwLzI4XSBhcm02NDogU3VwcG9ydCBm
b3IgQXJtIENDQSBpbiBLVk0NCj4gPiBbMl0gW1JGQyBQQVRDSCAxOS8yOF0gS1ZNOiBhcm02NDog
VmFsaWRhdGUgcmVnaXN0ZXIgYWNjZXNzIGZvciBhIFJlYWxtIFZNDQo+ID4gICAgICAgaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIzMDEyNzExMjI0OC4xMzY4MTAtMS1zdXp1a2kucG91
bG9zZUBhcm0uY29tL1QvI202YzEwYjlhMjdjNGE3MjQ5NjdjMTgwMGZhY2FjYWE5NDQzYjM4YjRj
DQo+ID4gWzNdIEFSTSBSZWFsbSBNYW5hZ2VtZW50IE1vbml0b3Igc3BlY2lmaWNhdGlvbihERU4w
MTM3IDEuMC1lYWMzKQ0KPiA+ICAgICAgaHR0cHM6Ly9kZXZlbG9wZXIuYXJtLmNvbS9kb2N1bWVu
dGF0aW9uL2RlbjAxMzcvbGF0ZXN0Lw0KPiA+DQo+ID4NCj4gPiBUaGFua3MNCj4gPiBTYWxpbC4N
Cj4gPg0KPiA+DQo+ID4+Pj4gNC4gRmFpbHVyZSBjb25kaXRpb24gKEI1LjMuMy4yKSBzaG91bGQg
YmUgYW1lbmRlZCB3aXRoDQo+ID4+Pj4gIMKgwqDCoCBydW5uYWJsZSBwcmU6IHRhcmdldF9yZWMu
ZmxhZ3MucnVubmFibGUgPT0gTk9UX1JVTk5BQkxFICg/KQ0KPiA+Pj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcG9zdDogcmVzdWx0ID09IFBTQ0lfREVOSUVEICg/KQ0KPiA+Pj4+IDUuIENo
YW5nZSB3b3VsZCBhbHNvIGJlIHJlcXVpcmVkIGluIHRoZSBmbG93IChEMS40IFBTQ0kgZmxvd3Mp
IGRlcGljdGluZw0KPiA+Pj4+ICDCoMKgwqAgUFNDSV9DUFVfT04gZmxvdyAoRDEuNC4xKQ0KPiA+
Pj4+DQo+ID4+Pj4gSSBkbyB1bmRlcnN0YW5kIHRoYXQgQVJNIENDQSBzdXBwb3J0IGlzIGluIGl0
cyBpbmZhbmN5IHN0YWdlIGFuZA0KPiA+Pj4+IGRpc2N1c3NpbmcgYWJvdXQgdkNQVSBIb3RwbHVn
IGluIHJlYWxtIHdvcmxkIHNlZW0gdG8gYmUgYSBmYXItZmV0Y2hlZA0KPiA+Pj4+IGlkZWEgcmln
aHQgbm93LiBCdXQgc3BlY2lmaWNhdGlvbiBjaGFuZ2VzIHJlcXVpcmUgbG90IG9mIHRpbWUgYW5k
IGlmDQo+ID4+Pj4gdGhpcyBjaGFuZ2UgaXMgcmVhbGx5IHJlcXVpcmVkIHRoZW4gaXQgc2hvdWxk
IGJlIGZ1cnRoZXIgZGlzY3Vzc2VkDQo+ID4+Pj4gd2l0aGluIEFSTS4NCj4gPj4+Pg0KPiA+Pj4+
IE1hbnkgdGhhbmtzIQ0KPiA+Pj4+DQo+ID4+Pj4NCj4gPj4+PiBCZXMgcmVnYXJkcw0KPiA+Pj4+
IFNhbGlsDQo+ID4+Pj4NCj4gPj4+PiBSZWZlcmVuY2VzOg0KPiA+Pj4+DQo+ID4+Pj4gWzFdIGh0
dHBzOi8vZGV2ZWxvcGVyLmFybS5jb20vZG9jdW1lbnRhdGlvbi9kZW4wMTM3L2xhdGVzdC8NCj4g
Pj4+PiBbMl0gaHR0cHM6Ly9naXRodWIuY29tL3NhbGlsLW1laHRhL3FlbXUuZ2l0IHZpcnQtY3B1
aHAtYXJtdjgvcmZjLXYxLXBvcnQxMTA1MjAyMy5kZXYtMQ0KPiA+Pj4+IFszXSBodHRwczovL2dp
dC5naXRsYWIuYXJtLmNvbS9saW51eC1hcm0vbGludXgtam0uZ2l0ICB2aXJ0dWFsX2NwdV9ob3Rw
bHVnL3JmYy92Mg0KDQoNCiANCg0K
