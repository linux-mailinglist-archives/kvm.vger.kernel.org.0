Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3392F1CCA87
	for <lists+kvm@lfdr.de>; Sun, 10 May 2020 13:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgEJLCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 May 2020 07:02:23 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:7454 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgEJLCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 May 2020 07:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589108542; x=1620644542;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=kRA32J9VjPd5GhXxmUjtK9WR+tdYKtXlyIKqjRjvds4=;
  b=kwOM9dPoNKU0tdkaz3jMuVkZYLl72dECF7EWw9463waGE+M7ua2Ugl64
   GlwvCShwz4GvqEuDOBiveed8l+b8/eKHumirFXbr5r+zCFJMWMgmf6S0z
   TSX7m9TbdH+GXve/TfVXUuOLwrrfRAWpt5BAmkyzAZJV/qS8wEdGkX99t
   Q=;
IronPort-SDR: MwGxtAgcSS4nmDlykRZalRVijBBroxmPd+GcNzGvuCZ1UIY6VFnz0hwuRBflNbKCYLzpl6rJ6b
 rbHganDI9qRg==
X-IronPort-AV: E=Sophos;i="5.73,375,1583193600"; 
   d="scan'208";a="42326554"
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
Thread-Topic: [PATCH v1 00/15] Add support for Nitro Enclaves
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 May 2020 11:02:20 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 2BE10A1E8B;
        Sun, 10 May 2020 11:02:18 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 10 May 2020 11:02:18 +0000
Received: from EX13D21UWA003.ant.amazon.com (10.43.160.184) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 10 May 2020 11:02:18 +0000
Received: from EX13D21UWA003.ant.amazon.com ([10.43.160.184]) by
 EX13D21UWA003.ant.amazon.com ([10.43.160.184]) with mapi id 15.00.1497.006;
 Sun, 10 May 2020 11:02:18 +0000
From:   "Herrenschmidt, Benjamin" <benh@amazon.com>
To:     "pavel@ucw.cz" <pavel@ucw.cz>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "van der Linden, Frank" <fllinden@amazon.com>,
        "Smith, Stewart" <trawets@amazon.com>,
        "Pohlack, Martin" <mpohlack@amazon.de>,
        "Wilson, Matt" <msw@amazon.com>, "Dannowski, Uwe" <uwed@amazon.de>,
        "Doebel, Bjoern" <doebel@amazon.de>
Thread-Index: AQHWJQZmwcsXbLPvp0aDqkxP7IsAE6igJAKAgAEG3wA=
Date:   Sun, 10 May 2020 11:02:18 +0000
Message-ID: <1b00857202884c2a27d0e381d6de312201d17868.camel@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
         <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
         <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
         <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
         <20200507174438.GB1216@bug>
         <620bf5ae-eade-37da-670d-a8704d9b4397@amazon.com>
         <20200509192125.GA1597@bug>
In-Reply-To: <20200509192125.GA1597@bug>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.200]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CEE01186C01554B923E06BDA18EFCCA@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIwLTA1LTA5IGF0IDIxOjIxICswMjAwLCBQYXZlbCBNYWNoZWsgd3JvdGU6DQo+
IA0KPiBPbiBGcmkgMjAyMC0wNS0wOCAxMDowMDoyNywgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3
cm90ZToNCj4gPiANCj4gPiANCj4gPiBPbiAwNy8wNS8yMDIwIDIwOjQ0LCBQYXZlbCBNYWNoZWsg
d3JvdGU6DQo+ID4gPiANCj4gPiA+IEhpIQ0KPiA+ID4gDQo+ID4gPiA+ID4gaXQgdXNlcyBpdHMg
b3duIG1lbW9yeSBhbmQgQ1BVcyArIGl0cyB2aXJ0aW8tdnNvY2sgZW11bGF0ZWQgZGV2aWNlIGZv
cg0KPiA+ID4gPiA+IGNvbW11bmljYXRpb24gd2l0aCB0aGUgcHJpbWFyeSBWTS4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBUaGUgbWVtb3J5IGFuZCBDUFVzIGFyZSBjYXJ2ZWQgb3V0IG9mIHRoZSBw
cmltYXJ5IFZNLCB0aGV5IGFyZSBkZWRpY2F0ZWQNCj4gPiA+ID4gPiBmb3IgdGhlIGVuY2xhdmUu
IFRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3QgZW5zdXJlcyBtZW1vcnkN
Cj4gPiA+ID4gPiBhbmQgQ1BVIGlzb2xhdGlvbiBiZXR3ZWVuIHRoZSBwcmltYXJ5IFZNIGFuZCB0
aGUgZW5jbGF2ZSBWTS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBUaGVzZSB0d28gY29tcG9uZW50
cyBuZWVkIHRvIHJlZmxlY3QgdGhlIHNhbWUgc3RhdGUgZS5nLiB3aGVuIHRoZQ0KPiA+ID4gPiA+
IGVuY2xhdmUgYWJzdHJhY3Rpb24gcHJvY2VzcyAoMSkgaXMgdGVybWluYXRlZCwgdGhlIGVuY2xh
dmUgVk0gKDIpIGlzDQo+ID4gPiA+ID4gdGVybWluYXRlZCBhcyB3ZWxsLg0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IFdpdGggcmVnYXJkIHRvIHRoZSBjb21tdW5pY2F0aW9uIGNoYW5uZWwsIHRoZSBw
cmltYXJ5IFZNIGhhcyBpdHMgb3duDQo+ID4gPiA+ID4gZW11bGF0ZWQgdmlydGlvLXZzb2NrIFBD
SSBkZXZpY2UuIFRoZSBlbmNsYXZlIFZNIGhhcyBpdHMgb3duIGVtdWxhdGVkDQo+ID4gPiA+ID4g
dmlydGlvLXZzb2NrIGRldmljZSBhcyB3ZWxsLiBUaGlzIGNoYW5uZWwgaXMgdXNlZCwgZm9yIGV4
YW1wbGUsIHRvIGZldGNoDQo+ID4gPiA+ID4gZGF0YSBpbiB0aGUgZW5jbGF2ZSBhbmQgdGhlbiBw
cm9jZXNzIGl0LiBBbiBhcHBsaWNhdGlvbiB0aGF0IHNldHMgdXAgdGhlDQo+ID4gPiA+ID4gdnNv
Y2sgc29ja2V0IGFuZCBjb25uZWN0cyBvciBsaXN0ZW5zLCBkZXBlbmRpbmcgb24gdGhlIHVzZSBj
YXNlLCBpcyB0aGVuDQo+ID4gPiA+ID4gZGV2ZWxvcGVkIHRvIHVzZSB0aGlzIGNoYW5uZWw7IHRo
aXMgaGFwcGVucyBvbiBib3RoIGVuZHMgLSBwcmltYXJ5IFZNDQo+ID4gPiA+ID4gYW5kIGVuY2xh
dmUgVk0uDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gTGV0IG1lIGtub3cgaWYgZnVydGhlciBjbGFy
aWZpY2F0aW9ucyBhcmUgbmVlZGVkLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhhbmtzLCB0aGlzIGlz
IGFsbCB1c2VmdWwuICBIb3dldmVyIGNhbiB5b3UgcGxlYXNlIGNsYXJpZnkgdGhlDQo+ID4gPiA+
IGxvdy1sZXZlbCBkZXRhaWxzIGhlcmU/DQo+ID4gPiANCj4gPiA+IElzIHRoZSB2aXJ0dWFsIG1h
Y2hpbmUgbWFuYWdlciBvcGVuLXNvdXJjZT8gSWYgc28sIEkgZ3Vlc3MgcG9pbnRlciBmb3Igc291
cmNlcw0KPiA+ID4gd291bGQgYmUgdXNlZnVsLg0KPiA+IA0KPiA+IEhpIFBhdmVsLA0KPiA+IA0K
PiA+IFRoYW5rcyBmb3IgcmVhY2hpbmcgb3V0Lg0KPiA+IA0KPiA+IFRoZSBWTU0gdGhhdCBpcyB1
c2VkIGZvciB0aGUgcHJpbWFyeSAvIHBhcmVudCBWTSBpcyBub3Qgb3BlbiBzb3VyY2UuDQo+IA0K
PiBEbyB3ZSB3YW50IHRvIG1lcmdlIGNvZGUgdGhhdCBvcGVuc291cmNlIGNvbW11bml0eSBjYW4g
bm90IHRlc3Q/DQoNCkhlaGUuLiB0aGlzIGlzbid0IHF1aXRlIHRoZSBzdG9yeSBQYXZlbCA6KQ0K
DQpXZSBtZXJnZSBzdXBwb3J0IGZvciBwcm9wcmlldGFyeSBoeXBlcnZpc29ycywgdGhpcyBpcyBu
byBkaWZmZXJlbnQuIFlvdQ0KY2FuIHRlc3QgaXQsIHdlbGwgYXQgbGVhc3QgeW91J2xsIGJlIGFi
bGUgdG8gLi4uIHdoZW4gQVdTIGRlcGxveXMgdGhlDQpmdW5jdGlvbmFsaXR5LiBZb3UgZG9uJ3Qg
bmVlZCB0aGUgaHlwZXJ2aXNvciBpdHNlbGYgdG8gYmUgb3BlbiBzb3VyY2UuDQoNCkluIGZhY3Qs
IGluIHRoaXMgY2FzZSwgaXQncyBub3QgZXZlbiBsb3cgbGV2ZWwgaW52YXNpdmUgYXJjaCBjb2Rl
IGxpa2UNCnNvbWUgb2YgdGhlIGFib3ZlIGNhbiBiZS4gSXQncyBhIGRyaXZlciBmb3IgYSBQQ0kg
ZGV2aWNlIDotKSBHcmFudGVkIGENCnZpcnR1YWwgb25lLiBXZSBtZXJnZSBkcml2ZXJzIGZvciBQ
Q0kgZGV2aWNlcyByb3V0aW5lbHkgd2l0aG91dCB0aGUgUlRMDQpvciBmaXJtd2FyZSBvZiB0aG9z
ZSBkZXZpY2VzIGJlaW5nIG9wZW4gc291cmNlLg0KDQpTbyB5ZXMsIHdlIHByb2JhYmx5IHdhbnQg
dGhpcyBpZiBpdCdzIGdvaW5nIHRvIGJlIGEgdXNlZnVsIGZlYXR1cmVzIHRvDQp1c2VycyB3aGVu
IHJ1bm5pbmcgb24gQVdTIEVDMi4gKERpc2NsYWltZXI6IEkgd29yayBmb3IgQVdTIHRoZXNlIGRh
eXMpLg0KDQpDaGVlcnMsDQpCZW4uDQoNCg==
