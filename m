Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E96EAA68
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 06:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfJaFkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 01:40:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:55624 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfJaFkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 01:40:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 22:40:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="230728280"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga002.fm.intel.com with ESMTP; 30 Oct 2019 22:40:13 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 30 Oct 2019 22:40:03 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 30 Oct 2019 22:40:02 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.215]) with mapi id 14.03.0439.000;
 Thu, 31 Oct 2019 13:39:59 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Thread-Index: AQHVimskKWib+KQlOUaXXMOVBk8bu6dql/6AgACL3iCACInPAIAAmD6A
Date:   Thu, 31 Oct 2019 05:39:59 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D5E049B@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <367adad0-eb05-c950-21d7-755fffacbed6@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D0619@SHSMSX104.ccr.corp.intel.com>
 <fa994379-a847-0ffe-5043-40a2aefecf43@redhat.com>
In-Reply-To: <fa994379-a847-0ffe-5043-40a2aefecf43@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODZlMDkzZGMtMDRjNS00Nzk2LWJjNDktMTAyZTVlM2I1MTRlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRG01dzFJSnhDMXdhQmUrNkE2Q1F1NFFQQUxvUGpSOFZmRzFYQ3FXSWdtNm1weTBCdTFRWWh5ZlZwWmdmN2dnUSJ9
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDog
VGh1cnNkYXksIE9jdG9iZXIgMzEsIDIwMTkgMTI6MzMgUE0NCj4gDQo+IA0KPiBPbiAyMDE5LzEw
LzI1IOS4i+WNiDY6MTIsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBKYXNvbiBXYW5n
IFttYWlsdG86amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gPj4gU2VudDogRnJpZGF5LCBPY3RvYmVy
IDI1LCAyMDE5IDU6NDkgUE0NCj4gPj4NCj4gPj4NCj4gPj4gT24gMjAxOS8xMC8yNCDkuIvljYg4
OjM0LCBMaXUgWWkgTCB3cm90ZToNCj4gPj4+IFNoYXJlZCB2aXJ0dWFsIGFkZHJlc3MgKFNWQSks
IGEuay5hLCBTaGFyZWQgdmlydHVhbCBtZW1vcnkgKFNWTSkgb24NCj4gSW50ZWwNCj4gPj4+IHBs
YXRmb3JtcyBhbGxvdyBhZGRyZXNzIHNwYWNlIHNoYXJpbmcgYmV0d2VlbiBkZXZpY2UgRE1BIGFu
ZA0KPiA+PiBhcHBsaWNhdGlvbnMuDQo+ID4+DQo+ID4+DQo+ID4+IEludGVyZXN0aW5nLCBzbyB0
aGUgYmVsb3cgZmlndXJlIGRlbW9uc3RyYXRlcyB0aGUgY2FzZSBvZiBWTS4gSSB3b25kZXINCj4g
Pj4gaG93IG11Y2ggZGlmZmVyZW5jZXMgaWYgd2UgY29tcGFyZSBpdCB3aXRoIGRvaW5nIFNWTSBi
ZXR3ZWVuIGRldmljZQ0KPiA+PiBhbmQNCj4gPj4gYW4gb3JkaW5hcnkgcHJvY2VzcyAoZS5nIGRw
ZGspPw0KPiA+Pg0KPiA+PiBUaGFua3MNCj4gPiBPbmUgZGlmZmVyZW5jZSBpcyB0aGF0IG9yZGlu
YXJ5IHByb2Nlc3MgcmVxdWlyZXMgb25seSBzdGFnZS0xIHRyYW5zbGF0aW9uLA0KPiA+IHdoaWxl
IFZNIHJlcXVpcmVzIG5lc3RlZCB0cmFuc2xhdGlvbi4NCj4gDQo+IA0KPiBBIHNpbGx5IHF1ZXN0
aW9uLCB0aGVuIEkgYmVsaWV2ZSB0aGVyZSdzIG5vIG5lZWQgZm9yIFZGSU8gRE1BIEFQSSBpbg0K
PiB0aGlzIGNhc2UgY29uc2lkZXIgdGhlIHBhZ2UgdGFibGUgaXMgc2hhcmVkIGJldHdlZW4gTU1V
IGFuZCBJT01NVT8NCj4gDQoNCnllcywgb25seSBuZWVkIHRvIGludGVyY2VwdCBndWVzdCBpb3Rs
YiBpbnZhbGlkYXRpb24gcmVxdWVzdCBvbiBzdGFnZS0xIA0KdHJhbnNsYXRpb24gYW5kIHRoZW4g
Zm9yd2FyZCB0byBJT01NVSB0aHJvdWdoIG5ldyBWRklPIEFQSS4gRXhpc3RpbmcNClZGSU8gRE1B
IEFQSSBhcHBsaWVzIHRvIG9ubHkgdGhlIHN0YWdlLTIgdHJhbnNsYXRpb24gKEdQQS0+SFBBKSBo
ZXJlLg0KDQpUaGFua3MNCktldmluDQo=
