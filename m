Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7761654C9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 03:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBTCEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 21:04:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:46307 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727280AbgBTCEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 21:04:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 18:04:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="269405683"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga002.fm.intel.com with ESMTP; 19 Feb 2020 18:04:44 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 18:04:44 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Feb 2020 18:04:40 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 19 Feb 2020 18:04:40 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.97]) with mapi id 14.03.0439.000;
 Thu, 20 Feb 2020 10:04:38 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Chia-I Wu <olvaffe@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        "kvm list" <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "ML dri-devel" <dri-devel@lists.freedesktop.org>
Subject: RE: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Topic: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Index: AQHV4rTrI5AbOd4/PkCv4vZnvR6EuagZISQAgAAKbYCAAMs9AIAAnj+AgAAgCACAAAK0AIAAAeyAgAXrxoCAAaZGgIAAIIsAgADkwxA=
Date:   Thu, 20 Feb 2020 02:04:38 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D78EE65@SHSMSX104.ccr.corp.intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <20200214195229.GF20690@linux.intel.com>
 <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
 <CALMp9eRwTxdqxAcobZ7sYbD=F8Kga=jR3kaz-OEYdA9fV0AoKQ@mail.gmail.com>
 <20200214220341.GJ20690@linux.intel.com>
 <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RyTbuTPf0Tp=0DAD80G-RySLrON8OQsHJzhAYDh7zHuA@mail.gmail.com>
In-Reply-To: <CAPaKu7RyTbuTPf0Tp=0DAD80G-RySLrON8OQsHJzhAYDh7zHuA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGI4Yzk2N2ItZDY1OS00Mjk1LThmNmItZmE0NzY3YzE4ZjdjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiT2huajlkdHd6eUd4UmFzbm5BTmZiQVwvNjBBR0VkY1dpQW1WNmpaNGlwQ2h4aFVUYzRibjBQRGhGS0ZYNEJvcEcifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaGlhLUkgV3UgPG9sdmFmZmVAZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwg
RmVicnVhcnkgMjAsIDIwMjAgMzozNyBBTQ0KPiANCj4gT24gV2VkLCBGZWIgMTksIDIwMjAgYXQg
MTo1MiBBTSBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+
ID4gPiBGcm9tOiBQYW9sbyBCb256aW5pDQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5
IDE5LCAyMDIwIDEyOjI5IEFNDQo+ID4gPg0KPiA+ID4gT24gMTQvMDIvMjAgMjM6MDMsIFNlYW4g
Q2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+PiBPbiBGcmksIEZlYiAxNCwgMjAyMCBhdCAx
OjQ3IFBNIENoaWEtSSBXdSA8b2x2YWZmZUBnbWFpbC5jb20+IHdyb3RlOg0KPiA+ID4gPj4+IEFG
QUlDVCwgaXQgaXMgY3VycmVudGx5IGFsbG93ZWQgb24gQVJNICh2ZXJpZmllZCkgYW5kIEFNRCAo
bm90DQo+ID4gPiA+Pj4gdmVyaWZpZWQsIGJ1dCBzdm1fZ2V0X210X21hc2sgcmV0dXJucyAwIHdo
aWNoIHN1cHBvc2VkbHkgbWVhbnMNCj4gdGhlDQo+ID4gPiBOUFQNCj4gPiA+ID4+PiBkb2VzIG5v
dCByZXN0cmljdCB3aGF0IHRoZSBndWVzdCBQQVQgY2FuIGRvKS4gIFRoaXMgZGlmZiB3b3VsZCBk
byB0aGUNCj4gPiA+ID4+PiB0cmljayBmb3IgSW50ZWwgd2l0aG91dCBuZWVkaW5nIGFueSB1YXBp
IGNoYW5nZToNCj4gPiA+ID4+IEkgd291bGQgYmUgY29uY2VybmVkIGFib3V0IEludGVsIENQVSBl
cnJhdGEgc3VjaCBhcyBTS1g0MCBhbmQgU0tYNTkuDQo+ID4gPiA+IFRoZSBwYXJ0IEtWTSBjYXJl
cyBhYm91dCwgI01DLCBpcyBhbHJlYWR5IGFkZHJlc3NlZCBieSBmb3JjaW5nIFVDIGZvcg0KPiA+
ID4gTU1JTy4NCj4gPiA+ID4gVGhlIGRhdGEgY29ycnVwdGlvbiBpc3N1ZSBpcyBvbiB0aGUgZ3Vl
c3Qga2VybmVsIHRvIGNvcnJlY3RseSB1c2UgV0MNCj4gPiA+ID4gYW5kL29yIG5vbi10ZW1wb3Jh
bCB3cml0ZXMuDQo+ID4gPg0KPiA+ID4gV2hhdCBhYm91dCBjb2hlcmVuY3kgYWNyb3NzIGxpdmUg
bWlncmF0aW9uPyAgVGhlIHVzZXJzcGFjZSBwcm9jZXNzDQo+IHdvdWxkDQo+ID4gPiB1c2UgY2Fj
aGVkIGFjY2Vzc2VzLCBhbmQgYWxzbyBhIFdCSU5WRCBjb3VsZCBwb3RlbnRpYWxseSBjb3JydXB0
IGd1ZXN0DQo+ID4gPiBtZW1vcnkuDQo+ID4gPg0KPiA+DQo+ID4gSW4gc3VjaCBjYXNlIHRoZSB1
c2Vyc3BhY2UgcHJvY2VzcyBwb3NzaWJseSBzaG91bGQgY29uc2VydmF0aXZlbHkgdXNlDQo+ID4g
VUMgbWFwcGluZywgYXMgaWYgZm9yIE1NSU8gcmVnaW9ucyBvbiBhIHBhc3N0aHJvdWdoIGRldmlj
ZS4gSG93ZXZlcg0KPiA+IHRoZXJlIHJlbWFpbnMgYSBwcm9ibGVtLiB0aGUgZGVmaW5pdGlvbiBv
ZiBLVk1fTUVNX0RNQSBpbXBsaWVzDQo+ID4gZmF2b3JpbmcgZ3Vlc3Qgc2V0dGluZywgd2hpY2gg
Y291bGQgYmUgd2hhdGV2ZXIgdHlwZSBpbiBjb25jZXB0LiBUaGVuDQo+ID4gYXNzdW1pbmcgVUMg
aXMgYWxzbyBwcm9ibGVtYXRpYy4gSSdtIG5vdCBzdXJlIHdoZXRoZXIgaW52ZW50aW5nIGFub3Ro
ZXINCj4gPiBpbnRlcmZhY2UgdG8gcXVlcnkgZWZmZWN0aXZlIG1lbW9yeSB0eXBlIGZyb20gS1ZN
IGlzIGEgZ29vZCBpZGVhLiBUaGVyZQ0KPiA+IGlzIG5vIGd1YXJhbnRlZSB0aGF0IHRoZSBndWVz
dCB3aWxsIHVzZSBzYW1lIHR5cGUgZm9yIGV2ZXJ5IHBhZ2UgaW4gdGhlDQo+ID4gc2FtZSBzbG90
LCB0aGVuIHN1Y2ggaW50ZXJmYWNlIG1pZ2h0IGJlIG1lc3N5LiBBbHRlcm5hdGl2ZWx5LCBtYXli
ZQ0KPiA+IHdlIGNvdWxkIGp1c3QgaGF2ZSBhbiBpbnRlcmZhY2UgZm9yIEtWTSB1c2Vyc3BhY2Ug
dG8gZm9yY2UgbWVtb3J5IHR5cGUNCj4gPiBmb3IgYSBnaXZlbiBzbG90LCBpZiBpdCBpcyBtYWlu
bHkgdXNlZCBpbiBwYXJhLXZpcnR1YWxpemVkIHNjZW5hcmlvcyAoZS5nLg0KPiA+IHZpcnRpby1n
cHUpIHdoZXJlIHRoZSBndWVzdCBpcyBlbmxpZ2h0ZW5lZCB0byB1c2UgYSBmb3JjZWQgdHlwZSAo
ZS5nLiBXQyk/DQo+IEtWTSBmb3JjaW5nIHRoZSBtZW1vcnkgdHlwZSBmb3IgYSBnaXZlbiBzbG90
IHNob3VsZCB3b3JrIHRvby4gIEJ1dCB0aGUNCj4gaWdub3JlLWd1ZXN0LXBhdCBiaXQgc2VlbXMg
dG8gYmUgSW50ZWwtc3BlY2lmaWMuICBXZSB3aWxsIG5lZWQgdG8NCj4gZGVmaW5lIGhvdyB0aGUg
c2Vjb25kLWxldmVsIHBhZ2UgYXR0cmlidXRlcyBjb21iaW5lIHdpdGggdGhlIGd1ZXN0DQo+IHBh
Z2UgYXR0cmlidXRlcyBzb21laG93Lg0KDQpvaCwgSSdtIG5vdCBhd2FyZSBvZiB0aGF0IGRpZmZl
cmVuY2UuIHdpdGhvdXQgYW4gaXBhdC1lcXVpdmFsZW50DQpjYXBhYmlsaXR5LCBJJ20gbm90IHN1
cmUgaG93IHRvIGZvcmNpbmcgcmFuZG9tIHR5cGUgaGVyZS4gSWYgeW91IGxvb2sgYXQgDQp0YWJs
ZSAxMS03IGluIEludGVsIFNETSwgbm9uZSBvZiBNVFJSIChFUFQpIG1lbW9yeSB0eXBlIGNhbiBs
ZWFkIHRvDQpjb25zaXN0ZW50IGVmZmVjdGl2ZSB0eXBlIHdoZW4gY29tYmluaW5nIHdpdGggcmFu
ZG9tIFBBVCB2YWx1ZS4gU28NCiBpdCBpcyBkZWZpbml0ZWx5IGEgZGVhZCBlbmQuDQoNCj4gDQo+
IEtWTSBzaG91bGQgaW4gdGhlb3J5IGJlIGFibGUgdG8gdGVsbCB0aGF0IHRoZSB1c2Vyc3BhY2Ug
cmVnaW9uIGlzDQo+IG1hcHBlZCB3aXRoIGEgY2VydGFpbiBtZW1vcnkgdHlwZSBhbmQgY2FuIGZv
cmNlIHRoZSBzYW1lIG1lbW9yeSB0eXBlDQo+IG9udG8gdGhlIGd1ZXN0LiAgVGhlIHVzZXJzcGFj
ZSBkb2VzIG5vdCBuZWVkIHRvIGJlIGludm9sdmVkLiAgQnV0IHRoYXQNCj4gc291bmRzIHZlcnkg
c2xvdz8gIFRoaXMgbWF5IGJlIGEgZHVtYiBxdWVzdGlvbiwgYnV0IHdvdWxkIGl0IGhlbHAgdG8N
Cj4gYWRkIEtWTV9TRVRfRE1BX0JVRiBhbmQgbGV0IEtWTSBuZWdvdGlhdGUgdGhlIG1lbW9yeSB0
eXBlIHdpdGggdGhlDQo+IGluLWtlcm5lbCBHUFUgZHJpdmVycz8NCj4gDQo+IA0KDQpLVk1fU0VU
X0RNQV9CVUYgbG9va3MgbW9yZSByZWFzb25hYmxlLiBCdXQgSSBndWVzcyB3ZSBkb24ndCBuZWVk
DQpLVk0gdG8gYmUgYXdhcmUgb2Ygc3VjaCBuZWdvdGlhdGlvbi4gV2UgY2FuIGNvbnRpbnVlIHlv
dXIgb3JpZ2luYWwNCnByb3Bvc2FsIHRvIGhhdmUgS1ZNIHNpbXBseSBmYXZvciBndWVzdCBtZW1v
cnkgdHlwZSAobWF5YmUgc3RpbGwgY2FsbA0KS1ZNX01FTV9ETUEpLiBPbiB0aGUgb3RoZXIgaGFu
ZCwgUWVtdSBzaG91bGQganVzdCBtbWFwIG9uIHRoZSANCmZkIGhhbmRsZSBvZiB0aGUgZG1hYnVm
IHBhc3NlZCBmcm9tIHRoZSB2aXJ0aW8tZ3B1IGRldmljZSBiYWNrZW5kLCAgZS5nLg0KdG8gY29u
ZHVjdCBtaWdyYXRpb24uIFRoYXQgd2F5IHRoZSBtbWFwIHJlcXVlc3QgaXMgZmluYWxseSBzZXJ2
ZWQgYnkgDQpEUk0gYW5kIHVuZGVybHlpbmcgR1BVIGRyaXZlcnMsIHdpdGggcHJvcGVyIHR5cGUg
ZW5mb3JjZWQgYXV0b21hdGljYWxseS4NCg0KVGhhbmtzDQpLZXZpbg0K
