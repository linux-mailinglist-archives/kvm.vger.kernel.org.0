Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E8D4D8C76
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiCNTdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiCNTdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:33:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5E03B54A;
        Mon, 14 Mar 2022 12:32:28 -0700 (PDT)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KHRVk2vyPz67tWy;
        Tue, 15 Mar 2022 03:31:42 +0800 (CST)
Received: from lhreml717-chm.china.huawei.com (10.201.108.68) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 14 Mar 2022 20:32:25 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 19:32:24 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Mon, 14 Mar 2022 19:32:24 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: RE: [PATCH v2] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Thread-Topic: [PATCH v2] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Thread-Index: AQHYN9fUy7fxUOZsykSafATTP7QdGKy/Q+lA
Date:   Mon, 14 Mar 2022 19:32:24 +0000
Message-ID: <07c58f14b98647f1833f1aac1220bc44@huawei.com>
References: <164728518026.40450.7442813673746870904.stgit@omen>
In-Reply-To: <164728518026.40450.7442813673746870904.stgit@omen>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.89.194]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleCBXaWxsaWFtc29u
IFttYWlsdG86YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb21dDQo+IFNlbnQ6IDE0IE1hcmNoIDIw
MjIgMTk6MTUNCj4gVG86IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOyBrdm1Admdlci5rZXJu
ZWwub3JnDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBqZ2dAbnZpZGlhLmNv
bTsgU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaQ0KPiA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPjsga2V2aW4udGlhbkBpbnRlbC5jb207DQo+IHlpc2hhaWhAbnZpZGlhLmNv
bTsgbGludXgtZG9jQHZnZXIua2VybmVsLm9yZzsgY29yYmV0QGx3bi5uZXQNCj4gU3ViamVjdDog
W1BBVENIIHYyXSB2ZmlvLXBjaTogUHJvdmlkZSByZXZpZXdlcnMgYW5kIGFjY2VwdGFuY2UgY3Jp
dGVyaWEgZm9yDQo+IHZlbmRvciBkcml2ZXJzDQo+IA0KPiBWZW5kb3Igb3IgZGV2aWNlIHNwZWNp
ZmljIGV4dGVuc2lvbnMgZm9yIGRldmljZXMgZXhwb3NlZCB0byB1c2Vyc3BhY2UNCj4gdGhyb3Vn
aCB0aGUgdmZpby1wY2ktY29yZSBsaWJyYXJ5IG9wZW4gYm90aCBuZXcgZnVuY3Rpb25hbGl0eSBh
bmQgbmV3DQo+IHJpc2tzLiAgSGVyZSB3ZSBhdHRlbXB0IHRvIHByb3ZpZGVkIGZvcm1hbGl6ZWQg
cmVxdWlyZW1lbnRzIGFuZA0KPiBleHBlY3RhdGlvbnMgdG8gZW5zdXJlIHRoYXQgZnV0dXJlIGRy
aXZlcnMgYm90aCBjb2xsYWJvcmF0ZSBpbiB0aGVpcg0KPiBpbnRlcmFjdGlvbiB3aXRoIGV4aXN0
aW5nIGhvc3QgZHJpdmVycywgYXMgd2VsbCBhcyByZWNlaXZlIGFkZGl0aW9uYWwNCj4gcmV2aWV3
cyBmcm9tIGNvbW11bml0eSBtZW1iZXJzIHdpdGggZXhwZXJpZW5jZSBpbiB0aGlzIGFyZWEuDQo+
IA0KPiBDYzogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gQ2M6IFlpc2hhaSBI
YWRhcyA8eWlzaGFpaEBudmlkaWEuY29tPg0KPiBDYzogU2hhbWVlciBLb2xvdGh1bSA8c2hhbWVl
cmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4u
dGlhbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53
aWxsaWFtc29uQHJlZGhhdC5jb20+DQoNCkFja2VkLWJ5OiBTaGFtZWVyIEtvbG90aHVtIDxzaGFt
ZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+DQoNClRoYW5rcywNClNoYW1lZXINCg0K
PiAtLS0NCj4gDQo+IHYyOg0KPiANCj4gQWRkZWQgWWlzaGFpDQo+IA0KPiB2MToNCj4gDQo+IFBl
ciB0aGUgcHJvcG9zYWwgaGVyZVsxXSwgSSd2ZSBjb2xsZWN0ZWQgdGhvc2UgdGhhdCB2b2x1bnRl
ZXJlZCBhbmQNCj4gdGhvc2UgdGhhdCBJIGludGVycHJldGVkIGFzIHNob3dpbmcgaW50ZXJlc3Qg
KGFscGhhIGJ5IGxhc3QgbmFtZSkuICBGb3INCj4gdGhvc2Ugb24gdGhlIHJldmlld2VycyBsaXN0
IGJlbG93LCBwbGVhc2UgUi1iL0EtYiB0byBrZWVwIHlvdXIgbmFtZSBhcyBhDQo+IHJldmlld2Vy
LiAgTW9yZSB2b2x1bnRlZXJzIGFyZSBzdGlsbCB3ZWxjb21lLCBwbGVhc2UgbGV0IG1lIGtub3cN
Cj4gZXhwbGljaXRseTsgUi1iL0EtYiB3aWxsIG5vdCBiZSB1c2VkIHRvIGF1dG9tYXRpY2FsbHkg
YWRkIHJldmlld2VycyBidXQNCj4gYXJlIG9mIGNvdXJzZSB3ZWxjb21lLiAgVGhhbmtzLA0KPiAN
Cj4gQWxleA0KPiANCj4gWzFdaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIwMzEwMTM0
OTU0LjBkZjRiYjEyLmFsZXgud2lsbGlhbXNvbkByZWQNCj4gaGF0LmNvbS8NCj4gIC4uLi92Zmlv
L3ZmaW8tcGNpLXZlbmRvci1kcml2ZXItYWNjZXB0YW5jZS5yc3QgICAgIHwgICAzNQ0KPiArKysr
KysrKysrKysrKysrKysrKw0KPiAgTUFJTlRBSU5FUlMgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgIDEwICsrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA0NSBpbnNl
cnRpb25zKCspDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gRG9jdW1lbnRhdGlvbi92ZmlvL3Zm
aW8tcGNpLXZlbmRvci1kcml2ZXItYWNjZXB0YW5jZS5yc3QNCj4gDQo+IGRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL3ZmaW8vdmZpby1wY2ktdmVuZG9yLWRyaXZlci1hY2NlcHRhbmNlLnJzdA0K
PiBiL0RvY3VtZW50YXRpb24vdmZpby92ZmlvLXBjaS12ZW5kb3ItZHJpdmVyLWFjY2VwdGFuY2Uu
cnN0DQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uM2ExMDhk
NzQ4NjgxDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi92ZmlvL3ZmaW8t
cGNpLXZlbmRvci1kcml2ZXItYWNjZXB0YW5jZS5yc3QNCj4gQEAgLTAsMCArMSwzNSBAQA0KPiAr
Li4gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gKw0KPiArQWNjZXB0YW5jZSBj
cml0ZXJpYSBmb3IgdmZpby1wY2kgZGV2aWNlIHNwZWNpZmljIGRyaXZlciB2YXJpYW50cw0KPiAr
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQ0KPiArDQo+ICtPdmVydmlldw0KPiArLS0tLS0tLS0NCj4gK1RoZSB2ZmlvLXBjaSBk
cml2ZXIgZXhpc3RzIGFzIGEgZGV2aWNlIGFnbm9zdGljIGRyaXZlciB1c2luZyB0aGUNCj4gK3N5
c3RlbSBJT01NVSBhbmQgcmVseWluZyBvbiB0aGUgcm9idXN0bmVzcyBvZiBwbGF0Zm9ybSBmYXVs
dA0KPiAraGFuZGxpbmcgdG8gcHJvdmlkZSBpc29sYXRlZCBkZXZpY2UgYWNjZXNzIHRvIHVzZXJz
cGFjZS4gIFdoaWxlIHRoZQ0KPiArdmZpby1wY2kgZHJpdmVyIGRvZXMgaW5jbHVkZSBzb21lIGRl
dmljZSBzcGVjaWZpYyBzdXBwb3J0LCBmdXJ0aGVyDQo+ICtleHRlbnNpb25zIGZvciB5ZXQgbW9y
ZSBhZHZhbmNlZCBkZXZpY2Ugc3BlY2lmaWMgZmVhdHVyZXMgYXJlIG5vdA0KPiArc3VzdGFpbmFi
bGUuICBUaGUgdmZpby1wY2kgZHJpdmVyIGhhcyB0aGVyZWZvcmUgc3BsaXQgb3V0DQo+ICt2Zmlv
LXBjaS1jb3JlIGFzIGEgbGlicmFyeSB0aGF0IG1heSBiZSByZXVzZWQgdG8gaW1wbGVtZW50IGZl
YXR1cmVzDQo+ICtyZXF1aXJpbmcgZGV2aWNlIHNwZWNpZmljIGtub3dsZWRnZSwgZXguIHNhdmlu
ZyBhbmQgbG9hZGluZyBkZXZpY2UNCj4gK3N0YXRlIGZvciB0aGUgcHVycG9zZXMgb2Ygc3VwcG9y
dGluZyBtaWdyYXRpb24uDQo+ICsNCj4gK0luIHN1cHBvcnQgb2Ygc3VjaCBmZWF0dXJlcywgaXQn
cyBleHBlY3RlZCB0aGF0IHNvbWUgZGV2aWNlIHNwZWNpZmljDQo+ICt2YXJpYW50cyBtYXkgaW50
ZXJhY3Qgd2l0aCBwYXJlbnQgZGV2aWNlcyAoZXguIFNSLUlPViBQRiBpbiBzdXBwb3J0IG9mDQo+
ICthIHVzZXIgYXNzaWduZWQgVkYpIG9yIG90aGVyIGV4dGVuc2lvbnMgdGhhdCBtYXkgbm90IGJl
IG90aGVyd2lzZQ0KPiArYWNjZXNzaWJsZSB2aWEgdGhlIHZmaW8tcGNpIGJhc2UgZHJpdmVyLiAg
QXV0aG9ycyBvZiBzdWNoIGRyaXZlcnMNCj4gK3Nob3VsZCBiZSBkaWxpZ2VudCBub3QgdG8gY3Jl
YXRlIGV4cGxvaXRhYmxlIGludGVyZmFjZXMgdmlhIHN1Y2gNCj4gK2ludGVyYWN0aW9ucyBvciBh
bGxvdyB1bmNoZWNrZWQgdXNlcnNwYWNlIGRhdGEgdG8gaGF2ZSBhbiBlZmZlY3QNCj4gK2JleW9u
ZCB0aGUgc2NvcGUgb2YgdGhlIGFzc2lnbmVkIGRldmljZS4NCj4gKw0KPiArTmV3IGRyaXZlciBz
dWJtaXNzaW9ucyBhcmUgdGhlcmVmb3JlIHJlcXVlc3RlZCB0byBoYXZlIGFwcHJvdmFsIHZpYQ0K
PiArU2lnbi1vZmYvQWNrZWQtYnkvZXRjIGZvciBhbnkgaW50ZXJhY3Rpb25zIHdpdGggcGFyZW50
IGRyaXZlcnMuDQo+ICtBZGRpdGlvbmFsbHksIGRyaXZlcnMgc2hvdWxkIG1ha2UgYW4gYXR0ZW1w
dCB0byBwcm92aWRlIHN1ZmZpY2llbnQNCj4gK2RvY3VtZW50YXRpb24gZm9yIHJldmlld2VycyB0
byB1bmRlcnN0YW5kIHRoZSBkZXZpY2Ugc3BlY2lmaWMNCj4gK2V4dGVuc2lvbnMsIGZvciBleGFt
cGxlIGluIHRoZSBjYXNlIG9mIG1pZ3JhdGlvbiBkYXRhLCBob3cgaXMgdGhlDQo+ICtkZXZpY2Ug
c3RhdGUgY29tcG9zZWQgYW5kIGNvbnN1bWVkLCB3aGljaCBwb3J0aW9ucyBhcmUgbm90IG90aGVy
d2lzZQ0KPiArYXZhaWxhYmxlIHRvIHRoZSB1c2VyIHZpYSB2ZmlvLXBjaSwgd2hhdCBzYWZlZ3Vh
cmRzIGV4aXN0IHRvIHZhbGlkYXRlDQo+ICt0aGUgZGF0YSwgZXRjLiAgVG8gdGhhdCBleHRlbnQs
IGF1dGhvcnMgc2hvdWxkIGFkZGl0aW9uYWxseSBleHBlY3QgdG8NCj4gK3JlcXVpcmUgcmV2aWV3
cyBmcm9tIGF0IGxlYXN0IG9uZSBvZiB0aGUgbGlzdGVkIHJldmlld2VycywgaW4gYWRkaXRpb24N
Cj4gK3RvIHRoZSBvdmVyYWxsIHZmaW8gbWFpbnRhaW5lci4NCj4gZGlmZiAtLWdpdCBhL01BSU5U
QUlORVJTIGIvTUFJTlRBSU5FUlMNCj4gaW5kZXggNDMyMmI1MzIxODkxLi43ZjZiMTQwMTM0MTIg
MTAwNjQ0DQo+IC0tLSBhL01BSU5UQUlORVJTDQo+ICsrKyBiL01BSU5UQUlORVJTDQo+IEBAIC0y
MDMxNCw2ICsyMDMxNCwxNiBAQCBGOglkcml2ZXJzL3ZmaW8vbWRldi8NCj4gIEY6CWluY2x1ZGUv
bGludXgvbWRldi5oDQo+ICBGOglzYW1wbGVzL3ZmaW8tbWRldi8NCj4gDQo+ICtWRklPIFBDSSBW
RU5ET1IgRFJJVkVSUw0KPiArUjoJSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4g
K1I6CVlpc2hhaSBIYWRhcyA8eWlzaGFpaEBudmlkaWEuY29tPg0KPiArUjoJU2hhbWVlciBLb2xv
dGh1bSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiArUjoJS2V2aW4g
VGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ICtMOglrdm1Admdlci5rZXJuZWwub3JnDQo+
ICtTOglNYWludGFpbmVkDQo+ICtQOglEb2N1bWVudGF0aW9uL3ZmaW8vdmZpby1wY2ktdmVuZG9y
LWRyaXZlci1hY2NlcHRhbmNlLnJzdA0KPiArRjoJZHJpdmVycy92ZmlvL3BjaS8qLw0KPiArDQo+
ICBWRklPIFBMQVRGT1JNIERSSVZFUg0KPiAgTToJRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRo
YXQuY29tPg0KPiAgTDoJa3ZtQHZnZXIua2VybmVsLm9yZw0KPiANCj4gDQoNCg==
