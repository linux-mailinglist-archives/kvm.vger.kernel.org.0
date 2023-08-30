Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D181E78D997
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbjH3Sd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242446AbjH3IcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 04:32:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24211A6
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 01:32:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-180-yiGGdh7OPvy0IRObXaug9g-1; Wed, 30 Aug 2023 09:32:01 +0100
X-MC-Unique: yiGGdh7OPvy0IRObXaug9g-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 30 Aug
 2023 09:32:00 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 30 Aug 2023 09:32:00 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Stefan Hajnoczi' <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: RE: [PATCH v2 0/3] vfio: use __aligned_u64 for ioctl structs
Thread-Topic: [PATCH v2 0/3] vfio: use __aligned_u64 for ioctl structs
Thread-Index: AQHZ2qaF1qG+4kBOEE2IVTLh2JS7F7ABw8lggAC+u/A=
Date:   Wed, 30 Aug 2023 08:32:00 +0000
Message-ID: <6d0a1d479db3477e9bf6937b5a9b71af@AcuMS.aculab.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
 <3e8b6e0503a84c93b6dd44c0d311abfe@AcuMS.aculab.com>
In-Reply-To: <3e8b6e0503a84c93b6dd44c0d311abfe@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgTGFpZ2h0IDxE
YXZpZC5MYWlnaHRAQUNVTEFCLkNPTT4NCj4gU2VudDogMjkgQXVndXN0IDIwMjMgMjI6MTANCj4g
VG86ICdTdGVmYW4gSGFqbm9jemknIDxzdGVmYW5oYUByZWRoYXQuY29tPjsga3ZtQHZnZXIua2Vy
bmVsLm9yZw0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgVGlhbiwgS2V2aW4g
PGtldmluLnRpYW5AaW50ZWwuY29tPjsgQWxleCBXaWxsaWFtc29uDQo+IDxhbGV4LndpbGxpYW1z
b25AcmVkaGF0LmNvbT47IEphc29uIEd1bnRob3JwZSA8amdnQHppZXBlLmNhPg0KPiBTdWJqZWN0
OiBSRTogW1BBVENIIHYyIDAvM10gdmZpbzogdXNlIF9fYWxpZ25lZF91NjQgZm9yIGlvY3RsIHN0
cnVjdHMNCj4gDQo+IEZyb206IFN0ZWZhbiBIYWpub2N6aQ0KPiA+IFNlbnQ6IDI5IEF1Z3VzdCAy
MDIzIDE5OjI3DQo+ID4NCj4gPiB2MjoNCj4gPiAtIFJlYmFzZWQgb250byBodHRwczovL2dpdGh1
Yi5jb20vYXdpbGxpYW0vbGludXgtdmZpby5naXQgbmV4dCB0byBnZXQgdGhlDQo+ID4gICB2Zmlv
X2lvbW11X3R5cGUxX2luZm8gcGFkIGZpZWxkIFtLZXZpbl0NCj4gPiAtIEZpeGVkIG1pbihtaW5z
eiwgc2l6ZW9mKGRtYWJ1ZikpIC0+IG1pbihkbWFidWYuYXJnc3osIHNpemVvZihkbWFidWYpKSBb
SmFzb24sIEtldmluXQ0KPiANCj4gWW91IG1hbmFnZWQgdG8gdXNlIG1pbl90KCkgaW5zdGVhZCBv
ZiBmaXhpbmcgdGhlIHR5cGVzIHRvIG1hdGNoLg0KPiANCj4gPiAtIFNxdWFzaGVkIFBhdGNoIDMg
KHZmaW9faW9tbXVfdHlwZTFfaW5mbykgaW50byBQYXRjaCAxIHNpbmNlIGl0IGlzIHRyaXZpYWwg
bm93DQo+ID4gICB0aGF0IHRoZSBwYWRkaW5nIGZpZWxkIGlzIGFscmVhZHkgdGhlcmUuDQo+ID4N
Cj4gPiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPiBwb2ludGVkIG91dCB0aGF0IHU2
NCBWRklPIGlvY3RsIHN0cnVjdCBmaWVsZHMNCj4gPiBoYXZlIGFyY2hpdGVjdHVyZS1kZXBlbmRl
bnQgYWxpZ25tZW50LiBpb21tdWZkIGFscmVhZHkgdXNlcyBfX2FsaWduZWRfdTY0IHRvDQo+ID4g
YXZvaWQgdGhpcyBwcm9ibGVtLg0KPiA+DQo+ID4gU2VlIHRoZSBfX2FsaWduZWRfdTY0IHR5cGVk
ZWYgaW4gPHVhcGkvbGludXgvdHlwZXMuaD4gZm9yIGRldGFpbHMgb24gd2h5IGl0IGlzDQo+ID4g
YSBnb29kIGlkZWEgZm9yIGtlcm5lbDwtPnVzZXIgaW50ZXJmYWNlcy4NCj4gPg0KPiA+IFRoaXMg
c2VyaWVzIG1vZGlmaWVzIHRoZSBWRklPIGlvY3RsIHN0cnVjdHMgdG8gdXNlIF9fYWxpZ25lZF91
NjQuIFNvbWUgb2YgdGhlDQo+ID4gY2hhbmdlcyBwcmVzZXJ2ZSB0aGUgZXhpc3RpbmcgbWVtb3J5
IGxheW91dCBvbiBhbGwgYXJjaGl0ZWN0dXJlcywgc28gSSBwdXQgdGhlbQ0KPiA+IHRvZ2V0aGVy
IGludG8gdGhlIGZpcnN0IHBhdGNoLiBUaGUgcmVtYWluaW5nIHBhdGNoZXMgYXJlIGZvciBzdHJ1
Y3RzIHdoZXJlDQo+ID4gZXhwbGFuYXRpb24gaXMgbmVjZXNzYXJ5IGFib3V0IHdoeSBjaGFuZ2lu
ZyB0aGUgbWVtb3J5IGxheW91dCBkb2VzIG5vdCBicmVhaw0KPiA+IHRoZSB1YXBpLg0KPiANCj4g
QnV0IHlvdSBhcmUgZXh0ZW5kaW5nIGEgZmllbGQgaW4gdGhlIG1pZGRsZSBvZiB0aGUgdWFwaSBz
dHJ1Y3R1cmUuDQo+IFRoaXMgY29tcGxldGVseSBicmVha3MgYW55IGFwcGxpY2F0aW9ucy4NCg0K
SSd2ZSBoYWQgYSBjbG9zZXIgbG9vayB0aGlzIG1vcm5pbmcuDQpZb3VyIGV4cGxhbmF0aW9ucyBh
cmVuJ3QgdmVyeSBnb29kLg0KVGhlIHN0cnVjdHVyZXMgYWxsIGhhdmUgdGhlIDY0Yml0IGZpZWxk
cyBvbiB0aGVpciBuYXR1cmFsIGJvdW5kYXJ5DQpzbyB0aGUgbWVtb3J5IGxheW91dCBpc24ndCBy
ZWFsbHkgY2hhbmdlZCAtIGp1c3QgZXh0cmEgcGFkZGluZw0KYXQgdGhlIGVuZC4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

