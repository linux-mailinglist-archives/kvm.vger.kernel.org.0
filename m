Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A4B13DA55
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 13:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPMqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 07:46:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:32140 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgAPMqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 07:46:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 04:46:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="425523609"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jan 2020 04:46:06 -0800
Received: from fmsmsx114.amr.corp.intel.com (10.18.116.8) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:46:06 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX114.amr.corp.intel.com (10.18.116.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:46:06 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.89]) with mapi id 14.03.0439.000;
 Thu, 16 Jan 2020 20:46:04 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
Subject: RE: [PATCH v4 02/12] vfio_pci: move
 vfio_pci_is_vga/vfio_vga_disabled to header file
Thread-Topic: [PATCH v4 02/12] vfio_pci: move
 vfio_pci_is_vga/vfio_vga_disabled to header file
Thread-Index: AQHVxVTzJZb0H1kknEai/t4XhlnqkqfrEHAAgAI5+xA=
Date:   Thu, 16 Jan 2020 12:46:04 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A183F44@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-3-git-send-email-yi.l.liu@intel.com>
 <20200115114322.31644ede.cohuck@redhat.com>
In-Reply-To: <20200115114322.31644ede.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTBiNGM4ZTYtMTgxNC00YjViLThjMjUtMDY4NTYzMzU0NGJjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZlwvcVwvRWptRWFweWFTbk13MEEwU0t5cSt0cVVHWjE3UEJsem1WWWYyTXBObUFpTFNQV2JSbHRHWlRXTFVpTEpGIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDb3JuZWxpYSBIdWNrIFttYWlsdG86Y29odWNrQHJlZGhhdC5jb21dDQo+IFNlbnQ6
IFdlZG5lc2RheSwgSmFudWFyeSAxNSwgMjAyMCA2OjQzIFBNDQo+IFRvOiBMaXUsIFlpIEwgPHlp
LmwubGl1QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCAwMi8xMl0gdmZpb19w
Y2k6IG1vdmUgdmZpb19wY2lfaXNfdmdhL3ZmaW9fdmdhX2Rpc2FibGVkIHRvDQo+IGhlYWRlciBm
aWxlDQo+IA0KPiBPbiBUdWUsICA3IEphbiAyMDIwIDIwOjAxOjM5ICswODAwDQo+IExpdSBZaSBM
IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBUaGlzIHBhdGNoIG1vdmVzIHR3
byBpbmxpbmUgZnVuY3Rpb25zIHRvIHZmaW9fcGNpX3ByaXZhdGUuaCBmb3INCj4gPiBmdXJ0aGVy
IHNoYXJpbmcgYWNyb3NzIHNvdXJjZSBmaWxlcy4gQWxzbyBhdm9pZHMgYmVsb3cgY29tcGlsaW5n
IGVycm9yDQo+ID4gaW4gZnVydGhlciBjb2RlIHNwbGl0Lg0KPiA+DQo+ID4gImVycm9yOiBpbmxp
bmluZyBmYWlsZWQgaW4gY2FsbCB0byBhbHdheXNfaW5saW5lIOKAmHZmaW9fcGNpX2lzX3ZnYeKA
mToNCj4gPiBmdW5jdGlvbiBib2R5IG5vdCBhdmFpbGFibGUiLg0KPiANCj4gIldlIHdhbnQgdG8g
dXNlIHRoZXNlIGZ1bmN0aW9ucyBmcm9tIG90aGVyIGZpbGVzLCBzbyBtb3ZlIHRoZW0gdG8gYSBo
ZWFkZXIiIHNlZW1zDQo+IHRvIGJlIGp1c3RpZmljYXRpb24gZW5vdWdoOyB3aHkgbWVudGlvbiB0
aGUgY29tcGlsYXRpb24gZXJyb3I/DQoNCkV4YWN0bHkuIFdoYXQgYSBzdHVwaWQgY29tbWl0IG1l
c3NhZ2UgSSBtYWRlLiBUaGFua3MgdmVyeSBtdWNoLiBJDQplbmNvdW50ZXJlZCBzdWNoIGNvbXBp
bGF0aW9uIGVycm9yIGR1cmluZyBvbmUgc3RlcCBpbiBteSBkZXZlbG9wbWVudCwNCnNvIGFkZGVk
IGl0IGluIHRoZSBjb21taXQgbWVzc2FnZS4gSSBhZ3JlZSBpdCBpcyBub3QgbmVjZXNzYXJ5Lg0K
DQpUaGFua3MsDQpZaSBMaXUNCg0KPiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5A
aW50ZWwuY29tPg0KPiA+IENjOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvdmZpby9wY2kvdmZpb19wY2kuYyAgICAgICAgIHwgMTQgLS0tLS0tLS0t
LS0tLS0NCj4gPiAgZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9wcml2YXRlLmggfCAxNCArKysr
KysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDE0IGRl
bGV0aW9ucygtKQ0KDQo=
