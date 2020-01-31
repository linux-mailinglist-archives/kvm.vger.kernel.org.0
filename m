Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4922214E6C5
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 02:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgAaBCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 20:02:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:38952 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgAaBCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 20:02:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 17:02:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="428560074"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jan 2020 17:01:59 -0800
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 30 Jan 2020 17:01:59 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 30 Jan 2020 17:01:59 -0800
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.202]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.97]) with mapi id 14.03.0439.000;
 Fri, 31 Jan 2020 09:01:57 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Xu, Like" <like.xu@intel.com>,
        "jannh@google.com" <jannh@google.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: RE: [PATCH v8 00/14] Guest LBR Enabling
Thread-Topic: [PATCH v8 00/14] Guest LBR Enabling
Thread-Index: AQHV16ndL88cBSX1I02vHdwwHuYoV6gD80yQ
Date:   Fri, 31 Jan 2020 01:01:56 +0000
Message-ID: <286AC319A985734F985F78AFA26841F73E3F9B0D@shsmsx102.ccr.corp.intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
 <20200130201411.GF25446@habkost.net>
In-Reply-To: <20200130201411.GF25446@habkost.net>
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

T24gRnJpZGF5LCBKYW51YXJ5IDMxLCAyMDIwIDQ6MTQgQU0sIEVkdWFyZG8gSGFia29zdCB3cm90
ZToNCj4gT24gVHVlLCBBdWcgMDYsIDIwMTkgYXQgMDM6MTY6MDBQTSArMDgwMCwgV2VpIFdhbmcg
d3JvdGU6DQo+ID4gTGFzdCBCcmFuY2ggUmVjb3JkaW5nIChMQlIpIGlzIGEgcGVyZm9ybWFuY2Ug
bW9uaXRvciB1bml0IChQTVUpDQo+ID4gZmVhdHVyZSBvbiBJbnRlbCBDUFVzIHRoYXQgY2FwdHVy
ZXMgYnJhbmNoIHJlbGF0ZWQgaW5mby4gVGhpcyBwYXRjaA0KPiA+IHNlcmllcyBlbmFibGVzIHRo
aXMgZmVhdHVyZSB0byBLVk0gZ3Vlc3RzLg0KPiA+DQo+ID4gRWFjaCBndWVzdCBjYW4gYmUgY29u
ZmlndXJlZCB0byBleHBvc2UgdGhpcyBMQlIgZmVhdHVyZSB0byB0aGUgZ3Vlc3QNCj4gPiB2aWEg
dXNlcnNwYWNlIHNldHRpbmcgdGhlIGVuYWJsaW5nIHBhcmFtIGluIEtWTV9DQVBfWDg2X0dVRVNU
X0xCUg0KPiAocGF0Y2ggMykuDQo+IA0KPiBBcmUgUUVNVSBwYXRjaGVzIGZvciBlbmFibGluZyBL
Vk1fQ0FQX1g4Nl9HVUVTVF9MQlIgYmVpbmcgcGxhbm5lZD8NCj4gDQpZZXMsIHdlIGhhdmUgYSBj
b3VwbGUgb2YgcWVtdSBwYXRjaGVzLiBUaGF0J3MgcGxhbm5lZCB0byBiZSByZXZpZXdlZCBhZnRl
ciB0aGUga2VybmVsIHBhcnQgZ2V0cyBmaW5hbGl6ZWQg8J+Yig0KDQpCZXN0LA0KV2VpDQo=
