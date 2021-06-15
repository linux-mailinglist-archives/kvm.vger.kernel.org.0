Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36163A7943
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 10:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFOIql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 04:46:41 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:63812 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbhFOIqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 04:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623746677; x=1655282677;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CRwcKW462aqnup9Wgun7j7A4f1r96joB5tUbtlSR6ys=;
  b=q0IW98KqqsUUUk882KM/QD3mqhWOeUBJ9AswMB0nSRzaOpXRZAlHaLz/
   JeLcB4vbdEDjSyiXR5IaKo7JHigIGMvyUYvCZ0WN0CXFodD18MZXnceO/
   EZjs0qjUP0fwS3tTgipzrXvsmZFiB24v86ucXdweovZEOtcE4/lw09hlM
   o=;
X-IronPort-AV: E=Sophos;i="5.83,275,1616457600"; 
   d="scan'208";a="140175126"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Jun 2021 08:44:29 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 57EF6A1F61;
        Tue, 15 Jun 2021 08:44:25 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 15 Jun 2021 08:44:18 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 15 Jun 2021 08:44:18 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Tue, 15 Jun 2021 08:44:17 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v4 00/11] KVM: Implement nested TSC scaling
Thread-Topic: [PATCH v4 00/11] KVM: Implement nested TSC scaling
Thread-Index: AQHXUl9IK3DwWR2B+EmNcn/om5/gnKsU4FUA
Date:   Tue, 15 Jun 2021 08:44:17 +0000
Message-ID: <cbb1272d6fc5713b5d53972ae55c1220f903595f.camel@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.21]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3000B4B3338C8041B593659E7D3B4FD4@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTA1LTI2IGF0IDE5OjQ0ICswMTAwLCBJbGlhcyBTdGFtYXRpcyB3cm90ZToN
Cj4gS1ZNIGN1cnJlbnRseSBzdXBwb3J0cyBoYXJkd2FyZS1hc3Npc3RlZCBUU0Mgc2NhbGluZyBi
dXQgb25seSBmb3IgTDE7DQo+IHRoZSBmZWF0dXJlIGlzIG5vdCBleHBvc2VkIHRvIG5lc3RlZCBn
dWVzdHMuIFRoaXMgcGF0Y2ggc2VyaWVzIGFkZHMNCj4gc3VwcG9ydCBmb3IgbmVzdGVkIFRTQyBz
Y2FsaW5nIGFuZCBhbGxvd3MgYm90aCBMMSBhbmQgTDIgdG8gYmUgc2NhbGVkDQo+IHdpdGggZGlm
ZmVyZW50IHNjYWxpbmcgZmFjdG9ycy4gVGhhdCBpcyBhY2hpZXZlZCBieSAibWVyZ2luZyIgdGhl
IDAxIGFuZA0KPiAwMiB2YWx1ZXMgdG9nZXRoZXIuDQo+IA0KPiBNb3N0IG9mIHRoZSBsb2dpYyBp
biB0aGlzIHNlcmllcyBpcyBpbXBsZW1lbnRlZCBpbiBjb21tb24gY29kZSAoYnkgZG9pbmcNCj4g
dGhlIG5lY2Vzc2FyeSByZXN0cnVjdHVyaW5ncyksIGhvd2V2ZXIgdGhlIHBhdGNoZXMgYWRkIHN1
cHBvcnQgZm9yIFZNWA0KPiBvbmx5LiBBZGRpbmcgc3VwcG9ydCBmb3IgU1ZNIHNob3VsZCBiZSBl
YXN5IGF0IHRoaXMgcG9pbnQgYW5kIE1heGltDQo+IExldml0c2t5IGhhcyB2b2x1bnRlZXJlZCB0
byBkbyB0aGlzICh0aGFua3MhKS4NCj4gDQo+IENoYW5nZWxvZzoNCj4gDQo+IE9ubHkgcGF0Y2gg
OSBuZWVkcyByZXZpZXdpbmcgYXQgdGhpcyBwb2ludCwgYnV0IEkgYW0gcmUtc2VuZGluZyB0aGUN
Cj4gd2hvbGUgc2VyaWVzIGFzIEkgYWxzbyBhcHBsaWVkIG5pdHBpY2tzIHN1Z2dlc3RlZCB0byBz
b21lIG9mIHRoZSBvdGhlcg0KPiBwYXRoY2VzLg0KPiANCj4gdjQ6DQo+ICAgLSBBZGRlZCB2ZW5k
b3IgY2FsbGJhY2tzIGZvciB3cml0aW5nIHRoZSBUU0MgbXVsdGlwbGllcg0KPiAgIC0gTW92ZWQg
dGhlIFZNQ1MgbXVsdGlwbGllciB3cml0ZXMgZnJvbSB0aGUgVk1DUyBsb2FkIHBhdGggdG8gY29t
bW9uDQo+ICAgICBjb2RlIHRoYXQgb25seSBnZXRzIGNhbGxlZCBvbiBUU0MgcmF0aW8gY2hhbmdl
cw0KPiAgIC0gTWVyZ2VkIHRvZ2V0aGVyIHBhdGNoZXMgMTAgYW5kIDExIG9mIHYzDQo+ICAgLSBB
cHBsaWVkIGFsbCBuaXRwaWNrLWZlZWRiYWNrIG9mIHRoZSBwcmV2aW91cyB2ZXJzaW9ucw0KPiAN
Cj4gdjM6DQo+ICAgLSBBcHBsaWVkIFNlYW4ncyBmZWVkYmFjaw0KPiAgIC0gUmVmYWN0b3JlZCBw
YXRjaGVzIDcgdG8gMTANCj4gDQo+IHYyOg0KPiAgIC0gQXBwbGllZCBhbGwgb2YgTWF4aW0ncyBm
ZWVkYmFjaw0KPiAgIC0gQWRkZWQgYSBtdWxfczY0X3U2NF9zaHIgZnVuY3Rpb24gaW4gbWF0aDY0
LmgNCj4gICAtIEFkZGVkIGEgc2VwYXJhdGUga3ZtX3NjYWxlX3RzY19sMSBmdW5jdGlvbiBpbnN0
ZWFkIG9mIHBhc3NpbmcgYW4NCj4gICAgIGFyZ3VtZW50IHRvIGt2bV9zY2FsZV90c2MNCj4gICAt
IEltcGxlbWVudGVkIHRoZSAwMiBmaWVsZHMgY2FsY3VsYXRpb25zIGluIGNvbW1vbiBjb2RlDQo+
ICAgLSBNb3ZlZCBhbGwgb2Ygd3JpdGVfbDFfdHNjX29mZnNldCdzIGxvZ2ljIHRvIGNvbW1vbiBj
b2RlDQo+ICAgLSBBZGRlZCBhIGNoZWNrIGZvciB3aGV0aGVyIHRoZSBUU0MgaXMgc3RhYmxlIGlu
IHBhdGNoIDEwDQo+ICAgLSBVc2VkIGEgcmFuZG9tIEwxIGZhY3RvciBhbmQgYSBuZWdhdGl2ZSBv
ZmZzZXQgaW4gcGF0Y2ggMTANCj4gDQo+IElsaWFzIFN0YW1hdGlzICgxMSk6DQo+ICAgbWF0aDY0
Lmg6IEFkZCBtdWxfczY0X3U2NF9zaHIoKQ0KPiAgIEtWTTogWDg2OiBTdG9yZSBMMSdzIFRTQyBz
Y2FsaW5nIHJhdGlvIGluICdzdHJ1Y3Qga3ZtX3ZjcHVfYXJjaCcNCj4gICBLVk06IFg4NjogUmVu
YW1lIGt2bV9jb21wdXRlX3RzY19vZmZzZXQoKSB0bw0KPiAgICAga3ZtX2NvbXB1dGVfbDFfdHNj
X29mZnNldCgpDQo+ICAgS1ZNOiBYODY6IEFkZCBhIHJhdGlvIHBhcmFtZXRlciB0byBrdm1fc2Nh
bGVfdHNjKCkNCj4gICBLVk06IG5WTVg6IEFkZCBhIFRTQyBtdWx0aXBsaWVyIGZpZWxkIGluIFZN
Q1MxMg0KPiAgIEtWTTogWDg2OiBBZGQgZnVuY3Rpb25zIGZvciByZXRyaWV2aW5nIEwyIFRTQyBm
aWVsZHMgZnJvbSBjb21tb24gY29kZQ0KPiAgIEtWTTogWDg2OiBBZGQgZnVuY3Rpb25zIHRoYXQg
Y2FsY3VsYXRlIHRoZSBuZXN0ZWQgVFNDIGZpZWxkcw0KPiAgIEtWTTogWDg2OiBNb3ZlIHdyaXRl
X2wxX3RzY19vZmZzZXQoKSBsb2dpYyB0byBjb21tb24gY29kZSBhbmQgcmVuYW1lDQo+ICAgICBp
dA0KPiAgIEtWTTogWDg2OiBBZGQgdmVuZG9yIGNhbGxiYWNrcyBmb3Igd3JpdGluZyB0aGUgVFND
IG11bHRpcGxpZXINCj4gICBLVk06IG5WTVg6IEVuYWJsZSBuZXN0ZWQgVFNDIHNjYWxpbmcNCj4g
ICBLVk06IHNlbGZ0ZXN0czogeDg2OiBBZGQgdm14X25lc3RlZF90c2Nfc2NhbGluZ190ZXN0DQo+
IA0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtLXg4Ni1vcHMuaCAgICAgICAgICAgIHwgICA1
ICstDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAgICAgICAgICAgICAgfCAg
MTUgKy0NCj4gIGFyY2gveDg2L2t2bS9zdm0vc3ZtLmMgICAgICAgICAgICAgICAgICAgICAgICB8
ICAzNSArKy0NCj4gIGFyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMgICAgICAgICAgICAgICAgICAg
ICB8ICAzMyArKy0NCj4gIGFyY2gveDg2L2t2bS92bXgvdm1jczEyLmMgICAgICAgICAgICAgICAg
ICAgICB8ICAgMSArDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3ZtY3MxMi5oICAgICAgICAgICAgICAg
ICAgICAgfCAgIDQgKy0NCj4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAgICAgICAgICAgICAg
ICAgICAgICB8ICA1NSArKy0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5oICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMTEgKy0NCj4gIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8IDExNCArKysrKysrLS0NCj4gIGluY2x1ZGUvbGludXgvbWF0aDY0Lmgg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAxOSArKw0KPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMva3ZtLy5naXRpZ25vcmUgICAgICAgIHwgICAxICsNCj4gIHRvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2t2bS9NYWtlZmlsZSAgICAgICAgICB8ICAgMSArDQo+ICAuLi4va3ZtL3g4Nl82NC92bXhf
bmVzdGVkX3RzY19zY2FsaW5nX3Rlc3QuYyAgfCAyNDIgKysrKysrKysrKysrKysrKysrDQo+ICAx
MyBmaWxlcyBjaGFuZ2VkLCA0NTEgaW5zZXJ0aW9ucygrKSwgODUgZGVsZXRpb25zKC0pDQo+ICBj
cmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL3g4Nl82NC92bXhf
bmVzdGVkX3RzY19zY2FsaW5nX3Rlc3QuYw0KPiANCg0KSGVsbG8sDQoNCldoYXQgaXMgdGhlIHN0
YXR1cyBvZiB0aGVzZT8gSSB0aGluayBhbGwgcGF0Y2hlcyBoYXZlIGJlZW4gcmV2aWV3ZWQgYW5k
DQphcHByb3ZlZCBhdCB0aGlzIHBvaW50Lg0KDQooVGhlcmUncyBhIG5ldyByZXZpc2lvbiB2NiBv
ZiBwYXRjaCA5IHRoYXQgaGFzIGJlZW4gcmV2aWV3ZWQgdG9vKQ0KDQpUaGFua3MsDQpJbGlhcw0K
