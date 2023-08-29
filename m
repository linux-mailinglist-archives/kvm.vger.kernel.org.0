Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E8F78CEB9
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbjH2VYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 17:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbjH2VYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 17:24:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1290A3
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 14:24:10 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-192-LVQDV-3JNaGDcSmcgaB3Sg-1; Tue, 29 Aug 2023 22:10:05 +0100
X-MC-Unique: LVQDV-3JNaGDcSmcgaB3Sg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 29 Aug
 2023 22:10:06 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Tue, 29 Aug 2023 22:10:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stefan Hajnoczi' <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: RE: [PATCH v2 0/3] vfio: use __aligned_u64 for ioctl structs
Thread-Topic: [PATCH v2 0/3] vfio: use __aligned_u64 for ioctl structs
Thread-Index: AQHZ2qaF1qG+4kBOEE2IVTLh2JS7F7ABw8lg
Date:   Tue, 29 Aug 2023 21:10:06 +0000
Message-ID: <3e8b6e0503a84c93b6dd44c0d311abfe@AcuMS.aculab.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
In-Reply-To: <20230829182720.331083-1-stefanha@redhat.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogU3RlZmFuIEhham5vY3ppDQo+IFNlbnQ6IDI5IEF1Z3VzdCAyMDIzIDE5OjI3DQo+IA0K
PiB2MjoNCj4gLSBSZWJhc2VkIG9udG8gaHR0cHM6Ly9naXRodWIuY29tL2F3aWxsaWFtL2xpbnV4
LXZmaW8uZ2l0IG5leHQgdG8gZ2V0IHRoZQ0KPiAgIHZmaW9faW9tbXVfdHlwZTFfaW5mbyBwYWQg
ZmllbGQgW0tldmluXQ0KPiAtIEZpeGVkIG1pbihtaW5zeiwgc2l6ZW9mKGRtYWJ1ZikpIC0+IG1p
bihkbWFidWYuYXJnc3osIHNpemVvZihkbWFidWYpKSBbSmFzb24sIEtldmluXQ0KDQpZb3UgbWFu
YWdlZCB0byB1c2UgbWluX3QoKSBpbnN0ZWFkIG9mIGZpeGluZyB0aGUgdHlwZXMgdG8gbWF0Y2gu
DQoNCj4gLSBTcXVhc2hlZCBQYXRjaCAzICh2ZmlvX2lvbW11X3R5cGUxX2luZm8pIGludG8gUGF0
Y2ggMSBzaW5jZSBpdCBpcyB0cml2aWFsIG5vdw0KPiAgIHRoYXQgdGhlIHBhZGRpbmcgZmllbGQg
aXMgYWxyZWFkeSB0aGVyZS4NCj4gDQo+IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+
IHBvaW50ZWQgb3V0IHRoYXQgdTY0IFZGSU8gaW9jdGwgc3RydWN0IGZpZWxkcw0KPiBoYXZlIGFy
Y2hpdGVjdHVyZS1kZXBlbmRlbnQgYWxpZ25tZW50LiBpb21tdWZkIGFscmVhZHkgdXNlcyBfX2Fs
aWduZWRfdTY0IHRvDQo+IGF2b2lkIHRoaXMgcHJvYmxlbS4NCj4gDQo+IFNlZSB0aGUgX19hbGln
bmVkX3U2NCB0eXBlZGVmIGluIDx1YXBpL2xpbnV4L3R5cGVzLmg+IGZvciBkZXRhaWxzIG9uIHdo
eSBpdCBpcw0KPiBhIGdvb2QgaWRlYSBmb3Iga2VybmVsPC0+dXNlciBpbnRlcmZhY2VzLg0KPiAN
Cj4gVGhpcyBzZXJpZXMgbW9kaWZpZXMgdGhlIFZGSU8gaW9jdGwgc3RydWN0cyB0byB1c2UgX19h
bGlnbmVkX3U2NC4gU29tZSBvZiB0aGUNCj4gY2hhbmdlcyBwcmVzZXJ2ZSB0aGUgZXhpc3Rpbmcg
bWVtb3J5IGxheW91dCBvbiBhbGwgYXJjaGl0ZWN0dXJlcywgc28gSSBwdXQgdGhlbQ0KPiB0b2dl
dGhlciBpbnRvIHRoZSBmaXJzdCBwYXRjaC4gVGhlIHJlbWFpbmluZyBwYXRjaGVzIGFyZSBmb3Ig
c3RydWN0cyB3aGVyZQ0KPiBleHBsYW5hdGlvbiBpcyBuZWNlc3NhcnkgYWJvdXQgd2h5IGNoYW5n
aW5nIHRoZSBtZW1vcnkgbGF5b3V0IGRvZXMgbm90IGJyZWFrDQo+IHRoZSB1YXBpLg0KDQpCdXQg
eW91IGFyZSBleHRlbmRpbmcgYSBmaWVsZCBpbiB0aGUgbWlkZGxlIG9mIHRoZSB1YXBpIHN0cnVj
dHVyZS4NClRoaXMgY29tcGxldGVseSBicmVha3MgYW55IGFwcGxpY2F0aW9ucy4NCg0KWW91IGNv
dWxkIGFkZCBjb2RlIHRvIGRldGVjdCB0aGUgbGVuZ3RoIG9mIHRoZSB1c2VyLXByb3ZpZGVkDQpz
dHJ1Y3R1cmUgYW5kIHVzZSB0aGUgY29ycmVjdCBrZXJuZWwgc3RydWN0dXJlIHRoYXQgbWF0Y2hl
cw0KdGhlIGxlbmd0aCBvZiB0aGUgdXNlci1wcm92aWRlZCBvbmUuDQpUaGF0IG5lZWRzIHRoZSBv
cHBvc2l0ZSBvZiBfX2FsaWduZWRfdTY0IC0gYSA2NGJpdCBpbnRlZ2VyIHdpdGgNCjMyYml0IGFs
aWdubWVudCBvbiB4NjQtNjQuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

