Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576BF182D9C
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 11:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCLK2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 06:28:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:28498 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgCLK2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 06:28:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 03:28:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,544,1574150400"; 
   d="scan'208";a="354099036"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga001.fm.intel.com with ESMTP; 12 Mar 2020 03:28:51 -0700
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Mar 2020 03:28:50 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Mar 2020 03:28:50 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.201]) with mapi id 14.03.0439.000;
 Thu, 12 Mar 2020 18:28:47 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Thread-Topic: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Thread-Index: AQHV8tS2uZDJ2Dgk6EqR/a2HW+9LbKg7EWeAgAAN1ICABGlOgIAANIUAgAAfgACAAEmBgIAEoPfg
Date:   Thu, 12 Mar 2020 10:28:47 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738A1898@SHSMSX104.ccr.corp.intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
 <20200309150526.GI12561@hirez.programming.kicks-ass.net>
 <45a1a575-9363-f778-b5f5-bcdf28d3e34b@linux.intel.com>
In-Reply-To: <45a1a575-9363-f778-b5f5-bcdf28d3e34b@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
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

PiA+PiBJbiB0aGUgbmV3IHByb3Bvc2FsLCBLVk0gdXNlciBpcyB0cmVhdGVkIHRoZSBzYW1lIGFz
IG90aGVyIGhvc3QNCj4gPj4gZXZlbnRzIHdpdGggZXZlbnQgY29uc3RyYWludC4gVGhlIHNjaGVk
dWxlciBpcyBmcmVlIHRvIGNob29zZSB3aGV0aGVyDQo+ID4+IG9yIG5vdCB0byBhc3NpZ24gYSBj
b3VudGVyIGZvciBpdC4NCj4gPiBUaGF0J3Mgd2hhdCBpdCBkb2VzLCBJIHVuZGVyc3RhbmQgdGhh
dC4gSSdtIHNheWluZyB0aGF0IHRoYXQgaXMNCj4gPiBjcmVhdGluZyBhcnRpZmljaWFsIGNvbnRl
bnRpb24uDQo+ID4NCj4gPg0KPiA+IFdoeSBpcyB0aGlzIG5lZWRlZCBhbnl3YXk/IENhbid0IHdl
IGZvcmNlIHRoZSBndWVzdCB0byBmbHVzaCBhbmQgdGhlbg0KPiA+IG1vdmUgaXQgb3ZlciB0byBh
IG5ldyBjb3VudGVyPw0KPiANCj4gS1ZNIG9ubHkgdHJhcHMgdGhlIE1TUiBhY2Nlc3MuIFRoZXJl
IGlzIG5vIE1TUiBhY2Nlc3MgZHVyaW5nIHRoZSBzY2hlZHVsaW5nDQo+IGluIGd1ZXN0Lg0KPiBL
Vk0vaG9zdCBvbmx5IGtub3dzIHRoZSByZXF1ZXN0IGNvdW50ZXIsIHdoZW4gZ3Vlc3QgdHJpZXMg
dG8gZW5hYmxlIHRoZQ0KPiBjb3VudGVyLiBJdCdzIHRvbyBsYXRlIGZvciBndWVzdCB0byBzdGFy
dCBvdmVyLg0KPiANCj4gUmVnYXJkaW5nIHRvIHRoZSBhcnRpZmljaWFsIGNvbnRlbnRpb24sIGFz
IG15IHVuZGVyc3RhbmRpbmcsIGl0IHNob3VsZCByYXJlbHkNCj4gaGFwcGVuIGluIHByYWN0aWNh
bC4NCj4gQ2xvdWQgdmVuZG9ycyBoYXZlIHRvIGV4cGxpY2l0bHkgc2V0IHBlYnMgb3B0aW9uIGlu
IHFlbXUgdG8gZW5hYmxlIFBFQlMNCj4gc3VwcG9ydCBmb3IgZ3Vlc3QuIFRoZXkga25vd3MgdGhl
IGVudmlyb25tZW50IHdlbGwuIFRoZXkgY2FuIGF2b2lkIHRoZQ0KPiBjb250ZW50aW9uLiAoV2Ug
bWF5IGltcGxlbWVudCBzb21lIHBhdGNoZXMgZm9yIHFlbXUvS1ZNIGxhdGVyIHRvDQo+IHRlbXBv
cmFyaWx5IGRpc2FibGUgUEVCUyBpbiBydW50aW1lIGlmIHRoZXkgcmVxdWlyZS4pDQo+IA0KPiBG
b3Igbm93LCBJIHRoaW5rIHdlIG1heSBwcmludCBhIHdhcm5pbmcgd2hlbiBib3RoIGhvc3QgYW5k
IGd1ZXN0IHJlcXVpcmUgdGhlDQo+IHNhbWUgY291bnRlci4gSG9zdCBjYW4gZ2V0IGEgY2x1ZSBm
cm9tIHRoZSB3YXJuaW5nLg0KDQpIaSBQZXRlciwNCiAgICBXaGF0IGlzIHlvdXIgb3Bpbmlvbj8g
V2UgY2FuIHRyZWF0IHRoZSBndWVzdCBQRUJTIGV2ZW50IGFzIGFuIGV2ZW50IGZyb20gdGhlIHVz
ZXIuIEEgbGl0dGxlIGRpZmZlcmVudCBmcm9tIG90aGVyIGV2ZW50cyBpcyB0aGUgbmVlZCBvZiBw
aW4gdG8gdGhlIHNwZWNpZmljIGNvdW50ZXIgYmVjYXVzZSB0aGUgY291bnRlciBpbmRleCB3aWxs
IGJlIGluY2x1ZGVkIGluIHRoZSBHdWVzdCBQRUJTIHJlY29yZC4gVGhlIGd1ZXN0IGNvdW50ZXIg
Y2FuJ3QgYmUgZm9yY2VkIGRpc2FibGVkL3JlbGVhc2VkIGFzIHdlbGwsIG90aGVyd2lzZSwgdGhl
IGVuZC11c2VyIHdpbGwgY29tcGxhaW4uIENhbiB3ZSBhZGQgYSB3YXJuaW5nIHdoZW4gdGhlIGNv
bnRlbnRpb24gaXMgZGV0ZWN0ZWQgb3IgYWRkIHNvbWUgZGVzY3JpcHRpb24gaW4gdGhlIGRvY3Vt
ZW50IG9yLi4uPw0KDQpUaGFua3MsDQpMdXdlaSBLYW5nDQo=
