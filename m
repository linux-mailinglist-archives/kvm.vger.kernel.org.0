Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CCE33F8DA
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 20:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhCQTNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 15:13:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:8490 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233087AbhCQTNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 15:13:32 -0400
IronPort-SDR: WLmWe9rpunjXhr5K2QOQUonIfEmASXOcQYWbKWQuHUx2xiLEVYHtNAuugnb4UyX29MypROsT18
 i5VXjXDvA+/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="168807926"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="168807926"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 12:13:32 -0700
IronPort-SDR: 0zyacZbowhjkGUsJbAZXH3YgWttC4kcpt3JzOEKd/q9ckHb9R7a34MG21v2lD45kDMR+0V18GI
 U0UHBJbYMxvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="374274660"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 17 Mar 2021 12:13:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Mar 2021 12:13:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Mar 2021 12:13:31 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2106.013;
 Wed, 17 Mar 2021 12:13:31 -0700
From:   "Derrick, Jonathan" <jonathan.derrick@intel.com>
To:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Instantiate mdev device in host?
Thread-Topic: Instantiate mdev device in host?
Thread-Index: AQHXG2Ge96qOSw1kSUOuIHrwTXcXUg==
Date:   Wed, 17 Mar 2021 19:13:30 +0000
Message-ID: <abb1183682ccc1bc8bb2239bf581a0b635c21804.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C993C240F859184D813D5391E2CAFAE2@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgS2lydGksIEFsZXgsDQoNCkkndmUgd3JpdHRlbiBhIGhvc3QgbWRldiBkcml2ZXIgZm9yIGEg
cGNpZSBpbnN0cnVtZW50IHRoYXQgZGl2aWRlcyBpdHMNCnJlc291cmNlcyB0byBhIGd1ZXN0IGRy
aXZlciBhbmQgbWFuYWdlcyBwZXItaW5zdGFuY2UgaW50ZXJmYWNpbmcuDQoNCldlIGhhdmUgYSB1
c2UgY2FzZSB3aGVyZSB3ZSBtaWdodCB3YW50IHRvIGRyaXZlIHRoZSBpbnN0cnVtZW50IGRpcmVj
dGx5DQpmcm9tIHRoZSBob3N0IGluIHRoZSBzYW1lIGFwcGxpY2F0aW9uIHRoYXQgdGhlIG1kZXYg
Z3Vlc3Qgd291bGQgdXNlLg0KDQpJcyB0aGVyZSBhIHdheSB0byBpbnN0YW50aWF0ZSB0aGUgZW11
bGF0ZWQgcGNpIGRldmljZSBpbiB0aGUgaG9zdD8NCk9yIGEgcmVjb21tZW5kZWQgd2F5IHRvIGlu
dGVyZmFjZSBhbiBleGlzdGluZyBwY2kgKGd1ZXN0KSBkcml2ZXIgdG8gdGhlDQp2ZmlvLW1kZXYg
ZGV2aWNlPw0KDQpCZXN0LA0KSm9uDQo=
