Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352FC10CE91
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK1Sas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:30:48 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11723 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1Sas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:30:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1574965848; x=1606501848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=YmvDKDae6K6GLbl+oWNmnzof6XHtLau20RExutHZUN0=;
  b=s4cQiunx54h8ja0Cub25UQNnh7q1yGnjfFX8OhPN6Hqm5wFMwN78+tlq
   YlJLw/ES/wQ2NiNT+xUwPClxrbYTCxR2WpaszfiSLW9NWahGc9d8BAudx
   9H/tROPgHrOWIZEBwf1hmrfMIy7q/fZ1xLZ4gVKA08MY3pQ2P/wqehwGu
   Y=;
IronPort-SDR: 3wzWyfK1I+PdPFfr1PuKgOFC9g15z/SeIIaxhknZaXOZ1f/8xBc3m/LAhzSVcX+GG7jScWhYSo
 cZ73fthAIMPQ==
X-IronPort-AV: E=Sophos;i="5.69,254,1571702400"; 
   d="scan'208";a="2054927"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Nov 2019 18:30:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id AB2B222639F;
        Thu, 28 Nov 2019 18:30:36 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 18:30:27 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 18:30:27 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Thu, 28 Nov 2019 18:30:27 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     "drjones@redhat.com" <drjones@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: PL031: Fix check_rtc_irq
Thread-Topic: [PATCH kvm-unit-tests] arm/arm64: PL031: Fix check_rtc_irq
Thread-Index: AQHVpgRfU2CAtVWY9kOuYtk+vjuC16eg2hIA
Date:   Thu, 28 Nov 2019 18:30:27 +0000
Message-ID: <94CC1391-FCAF-4889-A234-911C66D6D334@amazon.de>
References: <20191128155515.19013-1-drjones@redhat.com>
In-Reply-To: <20191128155515.19013-1-drjones@redhat.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAC2895EC2160A46972AFA411FF05A7F@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gQW0gMjguMTEuMjAxOSB1bSAxNzo1NiBzY2hyaWViICJkcmpvbmVzQHJlZGhhdC5jb20i
IDxkcmpvbmVzQHJlZGhhdC5jb20+Og0KPiANCj4g77u/U2luY2UgUUVNVSBjb21taXQgODNhZDk1
OTU3YzdlICgicGwwMzE6IEV4cG9zZSBSVENJQ1IgYXMgcHJvcGVyIFdDDQo+IHJlZ2lzdGVyIikg
dGhlIFBMMDMxIHRlc3QgZ2V0cyBpbnRvIGFuIGluZmluaXRlIGxvb3AuIE5vdyB3ZSBtdXN0DQo+
IHdyaXRlIGJpdCB6ZXJvIG9mIFJUQ0lDUiB0byBjbGVhciB0aGUgSVJRIHN0YXR1cy4gQmVmb3Jl
LCB3cml0aW5nDQo+IGFueXRoaW5nIHRvIFJUQ0lDUiB3b3VsZCB3b3JrLiBBcyAnMScgaXMgYSBt
ZW1iZXIgb2YgJ2FueXRoaW5nJw0KPiB3cml0aW5nIGl0IHNob3VsZCB3b3JrIGZvciBvbGQgUUVN
VSBhcyB3ZWxsLg0KPiANCj4gQ2M6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPg0KDQpSZXZp
ZXdlZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4NCg0KU29ycnkgZm9yIGlu
dHJvZHVjaW5nIGEgdGVzdCBjYXNlIG9uIGNvZGUgdGhhdCBJIHRoZW4gbW9kaWZ5LCB3aXRob3V0
IHVwZGF0aW5nIHRoZSB0ZXN0IGNhc2UgYXMgd2VsbCA6KQ0KDQpBbGV4DQoNCg0KPiAtLS0NCj4g
YXJtL3BsMDMxLmMgfCA0ICsrLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcm0vcGwwMzEuYyBiL2FybS9wbDAz
MS5jDQo+IGluZGV4IDFmNjNlZjEzOTk0Zi4uM2I3NWZkNjUzZTk2IDEwMDY0NA0KPiAtLS0gYS9h
cm0vcGwwMzEuYw0KPiArKysgYi9hcm0vcGwwMzEuYw0KPiBAQCAtMTQzLDggKzE0Myw4IEBAIHN0
YXRpYyB2b2lkIGlycV9oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0KPiAgICAgICAgcmVw
b3J0KHJlYWRsKCZwbDAzMS0+cmlzKSA9PSAxLCAiICBSVEMgUklTID09IDEiKTsNCj4gICAgICAg
IHJlcG9ydChyZWFkbCgmcGwwMzEtPm1pcykgPT0gMSwgIiAgUlRDIE1JUyA9PSAxIik7DQo+IA0K
PiAtICAgICAgICAvKiBXcml0aW5nIGFueSB2YWx1ZSBzaG91bGQgY2xlYXIgSVJRIHN0YXR1cyAq
Lw0KPiAtICAgICAgICB3cml0ZWwoMHg4MDAwMDAwMFVMTCwgJnBsMDMxLT5pY3IpOw0KPiArICAg
ICAgICAvKiBXcml0aW5nIG9uZSB0byBiaXQgemVybyBzaG91bGQgY2xlYXIgSVJRIHN0YXR1cyAq
Lw0KPiArICAgICAgICB3cml0ZWwoMSwgJnBsMDMxLT5pY3IpOw0KPiANCj4gICAgICAgIHJlcG9y
dChyZWFkbCgmcGwwMzEtPnJpcykgPT0gMCwgIiAgUlRDIFJJUyA9PSAwIik7DQo+ICAgICAgICBy
ZXBvcnQocmVhZGwoJnBsMDMxLT5taXMpID09IDAsICIgIFJUQyBNSVMgPT0gMCIpOw0KPiAtLSAN
Cj4gMi4yMS4wDQo+IA0KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
S3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFu
IFNjaGxhZWdlciwgUmFsZiBIZXJicmljaApFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFy
bG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5
IDIzNyA4NzkKCgo=

