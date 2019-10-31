Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACF1EB226
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJaOID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 10:08:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:4969 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfJaOID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 10:08:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 07:08:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="199023177"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga008.fm.intel.com with ESMTP; 31 Oct 2019 07:08:02 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 31 Oct 2019 07:08:02 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 31 Oct 2019 07:08:02 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.200]) with mapi id 14.03.0439.000;
 Thu, 31 Oct 2019 22:08:00 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: RE: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VM
Thread-Topic: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VM
Thread-Index: AQHVimsks8KvEm+7BkaEbflXH8cdg6dql/6AgAAGfwCACQ8uAIABJaCQ
Date:   Thu, 31 Oct 2019 14:07:59 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EACA6@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <367adad0-eb05-c950-21d7-755fffacbed6@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D0619@SHSMSX104.ccr.corp.intel.com>
 <fa994379-a847-0ffe-5043-40a2aefecf43@redhat.com>
In-Reply-To: <fa994379-a847-0ffe-5043-40a2aefecf43@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjk5ZjI4YTMtY2JkZS00NGFkLWI2M2ItYjdiZmNkMjE3NGE1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVDNTak9ZT1RwSlwvXC9NTFZZbm9RdHdhKzMwQkxOVFZyZnQrNlk5SnpLa3lZc3RMeTJ5XC9aVUJ2VUNQc1ZJQWxadCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDog
VGh1cnNkYXksIE9jdG9iZXIgMzEsIDIwMTkgNTozMyBBTQ0KPiBTdWJqZWN0OiBSZTogW1JGQyB2
MiAwMC8yMl0gaW50ZWxfaW9tbXU6IGV4cG9zZSBTaGFyZWQgVmlydHVhbCBBZGRyZXNzaW5nIHRv
IFZNDQo+IA0KPiANCj4gT24gMjAxOS8xMC8yNSDkuIvljYg2OjEyLCBUaWFuLCBLZXZpbiB3cm90
ZToNCj4gPj4gRnJvbTogSmFzb24gV2FuZyBbbWFpbHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+
ID4+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAyNSwgMjAxOSA1OjQ5IFBNDQo+ID4+DQo+ID4+DQo+
ID4+IE9uIDIwMTkvMTAvMjQg5LiL5Y2IODozNCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4+PiBTaGFy
ZWQgdmlydHVhbCBhZGRyZXNzIChTVkEpLCBhLmsuYSwgU2hhcmVkIHZpcnR1YWwgbWVtb3J5IChT
Vk0pIG9uDQo+ID4+PiBJbnRlbCBwbGF0Zm9ybXMgYWxsb3cgYWRkcmVzcyBzcGFjZSBzaGFyaW5n
IGJldHdlZW4gZGV2aWNlIERNQSBhbmQNCj4gPj4gYXBwbGljYXRpb25zLg0KPiA+Pg0KPiA+Pg0K
PiA+PiBJbnRlcmVzdGluZywgc28gdGhlIGJlbG93IGZpZ3VyZSBkZW1vbnN0cmF0ZXMgdGhlIGNh
c2Ugb2YgVk0uIEkNCj4gPj4gd29uZGVyIGhvdyBtdWNoIGRpZmZlcmVuY2VzIGlmIHdlIGNvbXBh
cmUgaXQgd2l0aCBkb2luZyBTVk0gYmV0d2Vlbg0KPiA+PiBkZXZpY2UgYW5kIGFuIG9yZGluYXJ5
IHByb2Nlc3MgKGUuZyBkcGRrKT8NCj4gPj4NCj4gPj4gVGhhbmtzDQo+ID4gT25lIGRpZmZlcmVu
Y2UgaXMgdGhhdCBvcmRpbmFyeSBwcm9jZXNzIHJlcXVpcmVzIG9ubHkgc3RhZ2UtMQ0KPiA+IHRy
YW5zbGF0aW9uLCB3aGlsZSBWTSByZXF1aXJlcyBuZXN0ZWQgdHJhbnNsYXRpb24uDQo+IA0KPiAN
Cj4gQSBzaWxseSBxdWVzdGlvbiwgdGhlbiBJIGJlbGlldmUgdGhlcmUncyBubyBuZWVkIGZvciBW
RklPIERNQSBBUEkgaW4gdGhpcyBjYXNlIGNvbnNpZGVyDQo+IHRoZSBwYWdlIHRhYmxlIGlzIHNo
YXJlZCBiZXR3ZWVuIE1NVSBhbmQgSU9NTVU/DQoNCkVjaG8gS2V2aW4ncyByZXBseS4gV2UgdXNl
IG5lc3RlZCB0cmFuc2xhdGlvbiBoZXJlLiBGb3Igc3RhZ2UtMSwgeWVzLCBubyBuZWVkIHRvIHVz
ZQ0KVkZJTyBETUEgQVBJLiBGb3Igc3RhZ2UtMiwgd2Ugc3RpbGwgdXNlIFZGSU8gRE1BIEFQSSB0
byBwcm9ncmFtIHRoZSBHUEEtPkhQQQ0KbWFwcGluZyB0byBob3N0LiA6LSkNCg0KUmVnYXJkcywN
CllpIExpdQ0KPiANCj4gVGhhbmtzDQo+IA0KPiA+DQoNCg==
