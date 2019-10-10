Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66978D1D86
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 02:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfJJAm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 20:42:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:8073 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731834AbfJJAm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 20:42:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 17:42:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,278,1566889200"; 
   d="scan'208";a="277599342"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga001.jf.intel.com with ESMTP; 09 Oct 2019 17:42:25 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 9 Oct 2019 17:42:24 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 9 Oct 2019 17:42:24 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX152.ccr.corp.intel.com ([10.239.6.52]) with mapi id 14.03.0439.000;
 Thu, 10 Oct 2019 08:42:22 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>
Subject: RE: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
Thread-Topic: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
Thread-Index: AQHVfjpj4nSHkdRV8Emp7gZltXMOiKdRXE2AgADyVICAAAM/AIAABNCAgAAOO4CAAKFJ4A==
Date:   Thu, 10 Oct 2019 00:42:22 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E173828A91@SHSMSX104.ccr.corp.intel.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com>
 <56cf7ca1-d488-fc6e-1c20-b477dd855d84@redhat.com>
 <CALMp9eRNdLdb7zR=wwx2tTc8n-ewCKuhrw9pxXGVQVUBjNpRow@mail.gmail.com>
 <9335c3c7-e2dd-cb2d-454a-c41143c94b63@redhat.com>
 <CALMp9eTW56TDny5MehuW-wS8dHWwfVEdzEvZQkOfVumEwcMWAA@mail.gmail.com>
 <85d601ec-9f69-6c71-0839-b9291f540efb@redhat.com>
In-Reply-To: <85d601ec-9f69-6c71-0839-b9291f540efb@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTYxNTE4NjEtMTllYy00Y2E3LTliZDgtNTRkNjBhODk5ODA0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMVVQK2o0ZEpFUFFmT2hBRkltMEhveFFuMHhlYkp2YkZZcU8zazlPZUFJM09JQlVNek1NUmlDOXhZTFlGQldaSyJ9
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

PiA+IEkgd2FzIGp1c3QgY29uZnVzZWQgYnkgeW91ciB3b3JkaW5nOw0KPiA+IGl0IHNvdW5kZWQg
bGlrZSB5b3Ugd2VyZSBzYXlpbmcgdGhhdCBLVk0gc3VwcG9ydGVkIGJpdCA4Lg0KPiA+DQo+ID4g
SG93IGFib3V0Og0KPiA+DQo+ID4gLyoNCj4gPiAgKiBXZSBkbyBzdXBwb3J0IFBUIGlmIGt2bV94
ODZfb3BzLT5wdF9zdXBwb3J0ZWQoKSwgYnV0IHdlIGRvIG5vdA0KPiA+ICAqIHN1cHBvcnQgSUEz
Ml9YU1NbYml0IDhdLiBHdWVzdHMgd2lsbCBoYXZlIHRvIHVzZSBXUk1TUiByYXRoZXIgdGhhbg0K
PiA+ICAqIFhTQVZFUy9YUlNUT1JTIHRvIHNhdmUvcmVzdG9yZSBQVCBNU1JzLg0KPiA+ICAqLw0K
PiANCj4gR29vZCENCg0KTG9va3MgZ29vZCB0byBtZS4NCg0KVGhhbmtzLA0KTHV3ZWkgS2FuZw0K
DQo+IA0KPiBQYW9sbw0KDQo=
