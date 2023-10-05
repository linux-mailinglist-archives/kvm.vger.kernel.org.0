Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF1E7BA831
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 19:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjJERiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 13:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjJERhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 13:37:54 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2162733
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 10:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1696526698; x=1728062698;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=wIYpd7258bAD4M3BlXas68JEECuoBBzFbP0lKdRfWV0=;
  b=H+2JXGt3KZqrCQyd1+GLjI0KnkJFWiD7ffj0U8zQZvhMjTk3JWxWI+tQ
   ykH14x37NYgluNa8lFQTB50jtszP++ib4Wxc6cP7gwQwTERDXoAG+vVl8
   fthrzZH28gf0CPjAXsClfWfu+s9JHHwkwdL+bVUAV1uWh1+i1QdFbpDPb
   s=;
X-IronPort-AV: E=Sophos;i="6.03,203,1694736000"; 
   d="scan'208";a="355164639"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 17:24:55 +0000
Received: from EX19D012EUA003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 56D46340010;
        Thu,  5 Oct 2023 17:24:53 +0000 (UTC)
Received: from EX19D032EUB003.ant.amazon.com (10.252.61.37) by
 EX19D012EUA003.ant.amazon.com (10.252.50.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Thu, 5 Oct 2023 17:24:52 +0000
Received: from EX19D047EUB002.ant.amazon.com (10.252.61.57) by
 EX19D032EUB003.ant.amazon.com (10.252.61.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Thu, 5 Oct 2023 17:24:52 +0000
Received: from EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7]) by
 EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7%3]) with mapi id
 15.02.1118.037; Thu, 5 Oct 2023 17:24:52 +0000
From:   "Mancini, Riccardo" <mancio@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Teragni, Matias" <mteragni@amazon.com>,
        "Batalov, Eugene" <bataloe@amazon.com>
Subject: RE: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
Thread-Topic: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
Thread-Index: Adn3sNboZ3tGzH5GSXezpqAV5T2/pw==
Date:   Thu, 5 Oct 2023 17:24:51 +0000
Message-ID: <1a68941c7abc4968a1e98627743256f3@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.50.216]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhhbmtzLCBWaXRhbHksIFBhb2xvIGZvciB5b3VyIHJlcGxpZXMhDQpJJ2xsIHJlcGx5IGp1c3Qg
dG8gdGhpcyBtZXNzYWdlIHRvIGF2b2lkIGJyYW5jaGluZyB0aGUgY29udmVyc2F0aW9uIHRvbyBt
dWNoLg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBhb2xvIEJvbnpp
bmkgPHBib256aW5pQHJlZGhhdC5jb20+DQo+IFNlbnQ6IDA1IE9jdG9iZXIgMjAyMyAxNzoxNQ0K
PiBUbzogTWFuY2luaSwgUmljY2FyZG8gPG1hbmNpb0BhbWF6b24uY29tPjsgdmt1em5ldHNAcmVk
aGF0LmNvbQ0KPiBDYzoga3ZtQHZnZXIua2VybmVsLm9yZzsgR3JhZiAoQVdTKSwgQWxleGFuZGVy
IDxncmFmQGFtYXpvbi5kZT47IFRlcmFnbmksDQo+IE1hdGlhcyA8bXRlcmFnbmlAYW1hem9uLmNv
bT47IEJhdGFsb3YsIEV1Z2VuZSA8YmF0YWxvZUBhbWF6b24uY29tPg0KPiBTdWJqZWN0OiBSRTog
W0VYVEVSTkFMXSBCdWc/IEluY29tcGF0aWJsZSBBUEYgZm9yIDQuMTQgZ3Vlc3Qgb24gNS4xMCBh
bmQNCj4gbGF0ZXIgaG9zdA0KPiANCj4gDQo+IA0KPiBPbiAxMC81LzIzIDE3OjA4LCBNYW5jaW5p
LCBSaWNjYXJkbyB3cm90ZToNCj4gPiBIaSwNCj4gPg0KPiA+IHdoZW4gYSA0LjE0IGd1ZXN0IHJ1
bnMgb24gYSA1LjEwIGhvc3QgKGFuZCBsYXRlciksIGl0IGNhbm5vdCB1c2UgQVBGDQo+ID4gKGRl
c3BpdGUgQ1BVSUQgYWR2ZXJ0aXNpbmcgS1ZNX0ZFQVRVUkVfQVNZTkNfUEYpIGR1ZSB0byB0aGUg
bmV3DQo+ID4gaW50ZXJydXB0LWJhc2VkIG1lY2hhbmlzbSAyNjM1YjVjNGEwIChLVk06IHg4Njog
aW50ZXJydXB0IGJhc2VkIEFQRg0KPiAncGFnZSByZWFkeScgZXZlbnQgZGVsaXZlcnkpLg0KPiA+
IEtlcm5lbHMgYWZ0ZXIgNS45IHdvbid0IHNhdGlzZnkgdGhlIGd1ZXN0IHJlcXVlc3QgdG8gZW5h
YmxlIEFQRg0KPiA+IHRocm91Z2ggS1ZNX0FTWU5DX1BGX0VOQUJMRUQsIHJlcXVpcmluZyBhbHNv
DQo+IEtWTV9BU1lOQ19QRl9ERUxJVkVSWV9BU19JTlQgdG8gYmUgc2V0Lg0KPiA+IEZ1cnRoZXJt
b3JlLCB0aGUgcGF0Y2ggc2V0IHNlZW1zIHRvIGJlIGRyb3BwaW5nIHBhcnRzIG9mIHRoZSBsZWdh
Y3kNCj4gPiAjUEYgaGFuZGxpbmcgYXMgd2VsbC4NCj4gPiBJIGNvbnNpZGVyIHRoaXMgYXMgYSBi
dWcgYXMgaXQgYnJlYWtzIEFQRiBjb21wYXRpYmlsaXR5IGZvciBvbGRlcg0KPiA+IGd1ZXN0cyBy
dW5uaW5nIG9uIG5ld2VyIGtlcm5lbHMsIGJ5IGJyZWFraW5nIHRoZSB1bmRlcmx5aW5nIEFCSS4N
Cj4gPiBXaGF0IGRvIHlvdSB0aGluaz8gV2FzIHRoaXMgYSBkZWxpYmVyYXRlIGRlY2lzaW9uPw0K
PiANCj4gWWVzLCB0aGlzIGlzIGludGVudGlvbmFsLiAgSXQgaXMgbm90IGEgYnJlYWthZ2UgYmVj
YXVzZSB0aGUgQVBGIGludGVyZmFjZQ0KPiBvbmx5IHRlbGxzIGhvdyBhc3luY2hyb25vdXMgcGFn
ZSBmYXVsdHMgYXJlIGRlbGl2ZXJlZDsgaXQgZG9lc24ndCBwcm9taXNlDQo+IHRoYXQgdGhleSBh
cmUgYWN0dWFsbHkgZGVsaXZlcmVkLiAgSG93ZXZlciwgSSBhZG1pdCB0aGF0IHRoZSBjaGFuZ2Ug
d2FzDQo+IHVuZm9ydHVuYXRlLg0KDQo6KA0KDQpNYWtlcyBzZW5zZSwgdGhhbmtzIGZvciB0aGUg
ZXhwbGFuYXRpb24uDQoNCj4gDQo+IEFwYXJ0IGZyb20gdGhlIGNvbmNlcm5zIGFib3V0IHJlZW50
cmFuY3ksIHRoZXJlIHdlcmUgdHdvIG1vcmUgaXNzdWVzIHdpdGgNCj4gdGhlIG9sZCBBUEk6DQo+
IA0KPiAtIHRoZSBwYWdlLXJlYWR5IG5vdGlmaWNhdGlvbiBsYWNrZWQgYW4gYWNrbm93bGVkZ2Ug
bWVjaGFuaXNtIGlmIG1hbnkNCj4gcGFnZXMgYmVjYW1lIHJlYWR5IGF0IHRoZSBzYW1lIHRpbWUg
KHNlZSBjb21taXQgNTU3YTk2MWFiYmUwLCAiS1ZNOiB4ODY6DQo+IGFja25vd2xlZGdtZW50IG1l
Y2hhbmlzbSBmb3IgYXN5bmMgcGYgcGFnZSByZWFkeSBub3RpZmljYXRpb25zIikuICBUaGlzDQo+
IGRlbGF5ZWQgdGhlIG5vdGlmaWNhdGlvbnMgb2YgcGFnZXMgYWZ0ZXIgdGhlIGZpcnN0LiAgVGhl
IG5ldyBBUEkgdXNlcw0KPiBNU1JfS1ZNX0FTWU5DX1BGX0FDSyB0byBmaXggdGhlIHByb2JsZW0u
DQo+IA0KPiAtIHRoZSBvbGQgQVBJIGNvbmZ1c2VkIHN5bmNocm9ub3VzIGV2ZW50cyAoZXhjZXB0
aW9ucykgd2l0aCBhc3luY2hyb25vdXMNCj4gZXZlbnRzIChpbnRlcnJ1cHRzKTsgdGhpcyBjcmVh
dGVkIGEgdW5pcXVlIGNhc2Ugd2hlcmUgYSBwYWdlIGZhdWx0IHdhcw0KPiBnZW5lcmF0ZWQgb24g
YSBwYWdlIHRoYXQgaXMgbm90IGFjY2Vzc2VkIGJ5IHRoZSBpbnN0cnVjdGlvbi4gIChUaGUgbmV3
IEFQSQ0KPiBvbmx5IGZpeGVzIGhhbGYgb2YgdGhpcywgYmVjYXVzZSBpdCBhbHNvIGhhcyBhIGJv
Z3VzIENSMiwgYnV0IGl0J3MgYSBiaXQNCj4gYmV0dGVyKS4gIEl0IGFsc28gbWVhbnQgdGhhdCBw
YWdlLXJlYWR5IGV2ZW50cyB3ZXJlIHN1cHByZXNzZWQgYnkgZGlzYWJsZWQNCj4gaW50ZXJydXB0
cy0tLWJ1dCB0aGV5IHdlcmUgbm90IG5lY2Vzc2FyaWx5IGluamVjdGVkIHdoZW4gSUYgYmVjYW1l
IDEsDQo+IGJlY2F1c2UgS1ZNIGRpZCBub3QgZW5hYmxlIHRoZSBpbnRlcnJ1cHQgd2luZG93LiAg
VGhpcyBpcyBzb2x2ZWQNCj4gYXV0b21hdGljYWxseSBieSBqdXN0IGluamVjdGluZyBhbiBpbnRl
cnJ1cHQuICBPbiB0aGUgdGhlb3JldGljYWwgc2lkZSwNCj4gaXQncyBhbHNvIGp1c3QgdWdseSB0
aGF0IHBhZ2UtcmVhZHkgZXZlbnRzIGNvdWxkIG9ubHkgYmUgZW5hYmxlZC9kaXNhYmxlZA0KPiB3
aXRoIENMSS9TVEkgYW5kIG5vdCBBUElDIChUUFIpLg0KPiANCj4gPiBXYXMgdGhpcyBhbHJlYWR5
IHJlcG9ydGVkIGluIHRoZSBwYXN0IChJIGNvdWxkbid0IGZpbmQgYW55dGhpbmcgaW4gdGhlDQo+
ID4gbWFpbGluZyBsaXN0IGJ1dCBJIG1pZ2h0IGhhdmUgbWlzc2VkIGl0ISk/DQo+ID4gV291bGQg
aXQgYmUgbXVjaCBlZmZvcnQgdG8gc3VwcG9ydCB0aGUgbGVnYWN5ICNQRiBiYXNlZCBtZWNoYW5p
c20gZm9yDQo+ID4gb2xkZXIgZ3Vlc3RzIHRoYXQgY2hvb3NlIHRvIG9ubHkgc2V0IEtWTV9BU1lO
Q19QRl9FTkFCTEVEPw0KPiANCj4gSXQgaXMgbm90IGhhcmQuICBIb3dldmVyLCBJIGRvbid0IHRo
aW5rIHdlIHNob3VsZCBhY2NlcHQgc3VjaCBhIHBhdGNoDQo+IHVwc3RyZWFtLg0KDQpSZWdhcmRp
bmcgYWxzbyBWaXRhbHkgY29tbWVudCBhYm91dCBiYWNrcG9ydGluZyB0aGUgY2hhbmdlcyB0byA0
LjE0LCBJIHRoaW5rDQpzdXBwb3J0aW5nIGJvdGggbW9kZXMgaW4gNS4xMCAoYXQgbGVhc3QpIG1p
Z2h0IGJlIHRoZSBsZWFzdCBlZmZvcnQgcGF0aA0KKGZld2VyIGNoYW5nZXMpLCBhdCBsZWFzdCB0
byBteSBuYWl2ZSB1bnRyYWluZWQgZXllLg0KSSB0cmllZCB0byBwbGF5aW5nIGFyb3VuZCBieSBw
YXJ0aWFsbHkgcmV2ZXJ0aW5nIHNvbWUgb2YgdGhlIGNoYW5nZXMgdG8gaGFuZGxlDQpib3RoIGNh
c2VzIGJ1dCBvbmx5IGdvdCBrZXJuZWwgcGFuaWNzIGluIHRoZSBndWVzdCBzbyBmYXIsIHNvIEkg
bWlnaHQgYmUNCm1pc3Npbmcgc29tZXRoaW5nLiANCkhvd2V2ZXIsIEkgaGF2ZSBhYnNvbHV0ZWx5
IG5vIGV4cGVyaWVuY2Ugd2l0aCBLVk0gY29kZSwgc28gSSB3YXNuJ3QgZXhwZWN0aW5nDQp0byBn
ZXQgZmFyIGluIGFueSBjYXNlLg0KDQo+IEkgZG8gaGF2ZSBhIHF1ZXN0aW9uIGZvciB5b3UuICBD
YW4geW91IGRlc2NyaWJlIHRoZSBjb250ZXh0IGluIHdoaWNoIHlvdQ0KPiBhcmUgdXNpbmcgQVBG
LCBhbmQgd291bGQgeW91IGJlIGludGVyZXN0ZWQgaW4gQVJNIHN1cHBvcnQ/ICBXZSAoUmVkIEhh
dCwNCj4gbm90IG1lIHRoZSBtYWludGFpbmVyIDopKSBoYXZlIGJlZW4gdHJ5aW5nIHRvIHVuZGVy
c3RhbmQgZm9yIGEgbG9uZyB0aW1lDQo+IGlmIGNsb3VkIHByb3ZpZGVycyB1c2Ugb3IgbmVlZCBB
UEYuDQoNCktlZXBpbmcgaXQgc2hvcnQsIHdlIHJlc3VtZSAicmVtb3RlIiBWTSBzbmFwc2hvdHMg
c28gcGFnZSBmYXVsdHMgbWlnaHQNCmJlIHZlcnkgZXhwZW5zaXZlIG9uIGxvY2FsIGNhY2hlIG1p
c3Nlcy4gV2UgaGF2ZSBhIGZldyBvcHRpbWl6YXRpb25zIHRvIHdvcmsNCmFyb3VuZCBzb21lIG9m
IHRoZSBpc3N1ZXMsIGJ1dCBldmVuIG9uIGxvY2FsIGhpdHMgdGhlcmUgYXJlIHN0aWxsIGEgbG90
DQpvZiBleHBlbnNpdmUgcGFnZSBmYXVsdHMgY29tcGFyZWQgdG8gYSBub3JtYWwgVk0gdXNlLWNh
c2UsIEkgYmVsaWV2ZS4NClRvIGJlIGZhaXIsIEkgZGlkbid0IGV2ZW4gcmVhbGlzZSB0aGUgYmVu
ZWZpdHMgd2Ugd2VyZSBnZXR0aW5nIGZyb20gQVBGIA0KdW50aWwgaXQgYWN0dWFsbHkgYnJva2Ug
OikgDQpJdCBpbmRlZWQgcGxheXMgYSBiaWcgcm9sZSBpbiBrZWVwaW5nIHRoZSByZXN1bXB0aW9u
IHF1aWNrIGFuZCBlZmZpY2llbnQNCmluIG91ciB1c2UtY2FzZS4NCkkgZGlkbid0IGtub3cgdGhh
dCBpdCB3YXNuJ3QgYXZhaWxhYmxlIGZvciBBUk0sIGFzIHdlIGRvbid0IHVzZSBpdCBhdA0KdGhl
IG1vbWVudCwgYnV0IHRoYXQgd291bGQgYmUgaW50ZXJlc3RpbmcgZm9yIHRoZSBmdXR1cmUuDQoN
ClRoYW5rcywNClJpY2NhcmRvDQoNCj4gDQo+IFBhb2xvDQo+IA0KPiA+IFRoZSByZWFzb24gdGhp
cyBpcyBhbiBpc3N1ZSBmb3IgdXMgbm93IGlzIHRoYXQgbm90IGhhdmluZyBBUEYgZm9yDQo+ID4g
b2xkZXIgZ3Vlc3RzIGludHJvZHVjZXMgYSBzaWduaWZpY2FudCBwZXJmb3JtYW5jZSByZWdyZXNz
aW9uIG9uIDQuMTQNCj4gPiBndWVzdHMgd2hlbiBwYWlyZWQgdG8gdWZmZCBoYW5kbGluZyBvZiAi
cmVtb3RlIiBwYWdlLWZhdWx0cyAoc2ltaWxhcg0KPiA+IHRvIGEgbGl2ZSBtaWdyYXRpb24gc2Nl
bmFyaW8pIHdoZW4gd2UgdXBkYXRlIGZyb20gYSA0LjE0IGhvc3Qga2VybmVsIHRvDQo+IGEgNS4x
MCBob3N0IGtlcm5lbC4NCg0K
