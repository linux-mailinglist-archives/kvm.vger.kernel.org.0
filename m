Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73B531D1B1
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 21:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhBPUng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 15:43:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:11390 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBPUnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 15:43:31 -0500
IronPort-SDR: JTjaroCEtpuvwIwjdTcC11SZ+n3SodUUqk/UFUorGt3g529ILzp1q1cSpILGZEGNDIJ9mdVd50
 YZ0xbxFHNerQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="162146875"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="162146875"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 12:42:50 -0800
IronPort-SDR: 3HBMzKGjShe1tZIA15MqeB7QR82+5UfrBdUYK1PGe+XXVnCy9MPYu5/r6w221GkBbHOKv2TEjb
 IEAK3yfOSZPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="493442384"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2021 12:42:50 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 12:42:49 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 12:42:49 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 12:42:49 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>
Subject: RE: [RFC PATCH v5 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Thread-Topic: [RFC PATCH v5 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Thread-Index: AQHXAgqLyQlO6VDl10euDf/K0SnZy6pbqFMA//+cHQA=
Date:   Tue, 16 Feb 2021 20:42:49 +0000
Message-ID: <f8a683e354224d94bcbd74aff68a0d88@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <82c304d6f4e8ebfa9b35d1be74360a5004179c5f.1613221549.git.kai.huang@intel.com>
 <51a7138e-e025-b55b-e4c6-fb58bf2fe460@intel.com>
In-Reply-To: <51a7138e-e025-b55b-e4c6-fb58bf2fe460@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gT24gMi8xMy8yMSA1OjI5IEFNLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gRnJvbTogU2Vh
biBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4NCj4gPg0K
PiA+IFRoZSBrZXJuZWwgd2lsbCBjdXJyZW50bHkgZGlzYWJsZSBhbGwgU0dYIHN1cHBvcnQgaWYg
dGhlIGhhcmR3YXJlIGRvZXMNCj4gPiBub3Qgc3VwcG9ydCBsYXVuY2ggY29udHJvbC4gIE1ha2Ug
aXQgbW9yZSBwZXJtaXNzaXZlIHRvIGFsbG93IFNHWA0KPiA+IHZpcnR1YWxpemF0aW9uIG9uIHN5
c3RlbXMgd2l0aG91dCBMYXVuY2ggQ29udHJvbCBzdXBwb3J0LiAgVGhpcyB3aWxsDQo+ID4gYWxs
b3cgS1ZNIHRvIGV4cG9zZSBTR1ggdG8gZ3Vlc3RzIHRoYXQgaGF2ZSBsZXNzLXN0cmljdCByZXF1
aXJlbWVudHMNCj4gPiBvbiB0aGUgYXZhaWxhYmlsaXR5IG9mIGZsZXhpYmxlIGxhdW5jaCBjb250
cm9sLg0KPiAuLi4NCj4gDQo+IEFja2VkLWJ5OiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AaW50
ZWwuY29tPg0KDQpUaGFua3MhDQo=
