Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2E047224E
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 09:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhLMIXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 03:23:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:42123 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231509AbhLMIXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 03:23:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639383801; x=1670919801;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BSS0BFttADobPAR2S7yKTcoOykNXel4/sP5xwcCf0xw=;
  b=NShEPo0nKjC/1TNoB+plcMVgc5vkRT243nt7uwK1EjLeZPHVJOn1gI44
   VV5IMusPoJPZ7C7Z+O+YQzDxTe13142B3qyefze6NtBzoXJAwuliEwLcc
   +o3BePmZZU77bBMz9PudstRaiD1XmoJm6nTYP4csTndrBhGdyFRx/7h9N
   OLIie2rUrH7lrXCXDJex8Ulm0+9P2PjTrDyBeAPIFG9kTXiF2zwAZ31lE
   KhwwCjLc0t/JuSWoCC8WPocxLr1k4UU95Sh9disxpls7IjpXcc5nVjg2K
   cxJ8qwkeauyfcs2RtPPBVPHtXXc+NvuEbScty3QZm/HPwTrFH0VYy8Bci
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238909050"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238909050"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 00:23:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="613750000"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 13 Dec 2021 00:23:21 -0800
Received: from shsmsx605.ccr.corp.intel.com (10.109.6.215) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 00:23:19 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX605.ccr.corp.intel.com (10.109.6.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 16:23:16 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Mon, 13 Dec 2021 16:23:16 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Topic: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Index: AQHX63yobhR7xaimuUSU4jknnLqQN6wraUsAgABf8YCABEZs0A==
Date:   Mon, 13 Dec 2021 08:23:16 +0000
Message-ID: <86d3c3a5d61649079800a2038370365b@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
In-Reply-To: <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0dXJkYXksIERlY2VtYmVyIDExLCAyMDIxIDY6MTMgQU0sIFBhb2xvIEJvbnppbmkgd3Jv
dGU6DQo+IA0KPiBCeSB0aGUgd2F5LCBJIHRoaW5rIEtWTV9TRVRfWFNBVkUyIGlzIG5vdCBuZWVk
ZWQuICBJbnN0ZWFkOg0KPiANCj4gLSBLVk1fQ0hFQ0tfRVhURU5TSU9OKEtWTV9DQVBfWFNBVkUy
KSBzaG91bGQgcmV0dXJuIHRoZSBzaXplIG9mIHRoZQ0KPiBidWZmZXIgdGhhdCBpcyBwYXNzZWQg
dG8gS1ZNX0dFVF9YU0FWRTINCj4gDQo+IC0gS1ZNX0dFVF9YU0FWRTIgc2hvdWxkIGZpbGwgaW4g
dGhlIGJ1ZmZlciBleHBlY3RpbmcgdGhhdCBpdHMgc2l6ZSBpcw0KPiB3aGF0ZXZlciBLVk1fQ0hF
Q0tfRVhURU5TSU9OKEtWTV9DQVBfWFNBVkUyKSBwYXNzZXMNCj4gDQo+IC0gS1ZNX1NFVF9YU0FW
RSBjYW4ganVzdCBleHBlY3QgYSBidWZmZXIgdGhhdCBpcyBiaWdnZXIgdGhhbiA0ayBpZiB0aGUN
Cj4gc2F2ZSBzdGF0ZXMgcmVjb3JkZWQgaW4gdGhlIGhlYWRlciBwb2ludCB0byBvZmZzZXRzIGxh
cmdlciB0aGFuIDRrLg0KDQpJIHRoaW5rIG9uZSBpc3N1ZSBpcyB0aGF0IEtWTV9TRVRfWFNBVkUg
d29ya3Mgd2l0aCAic3RydWN0IGt2bV94c2F2ZSIgKGhhcmRjb2RlZCA0S0IgYnVmZmVyKSwNCmlu
Y2x1ZGluZyBrdm1fdmNwdV9pb2N0bF94ODZfc2V0X3hzYXZlLiBUaGUgc3RhdGVzIG9idGFpbmVk
IHZpYSBLVk1fR0VUX1hTQVZFMiB3aWxsIGJlIG1hZGUNCnVzaW5nICJzdHJ1Y3Qga3ZtX3hzYXZl
MiIuDQoNCkRpZCB5b3UgbWVhbiB0aGF0IHdlIGNvdWxkIGFkZCBhIG5ldyBjb2RlIHBhdGggdW5k
ZXIgS1ZNX1NFVF9YU0FWRSB0byBtYWtlIGl0IHdvcmsgd2l0aA0KdGhlIG5ldyAic3RydWN0IGt2
bV94c2F2ZTIiPw0KZS5nLjoNCg0KKHhzYXZlMl9lbmFibGVkIGJlbG93IGlzIHNldCB3aGVuIHVz
ZXJzcGFjZSBjYWxscyB0byBnZXQgS1ZNX0NBUF9YU0FWRTIpDQppZiAoa3ZtLT54c2F2ZTJfZW5h
YmxlZCkgew0KCW5ldyBpbXBsZW1lbnRhdGlvbiB1c2luZyAic3RydWN0IGt2bV94c2F2ZTIiDQp9
IGVsc2Ugew0KCWN1cnJlbnQgaW1wbGVtZW50YXRpb24gdXNpbmcgInN0cnVjdCBrdm1feHNhdmUi
DQp9DQoodGhpcyBzZWVtcyBsaWtlIGEgbmV3IGltcGxlbWVudGF0aW9uIHdoaWNoIG1pZ2h0IGRl
c2VydmUgYSBuZXcgaW9jdGwpDQoNClRoYW5rcywNCldlaQ0KDQo=
