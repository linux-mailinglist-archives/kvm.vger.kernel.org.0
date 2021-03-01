Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457F1327E63
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 13:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhCAMaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 07:30:13 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5758 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbhCAM3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 07:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1614601790; x=1646137790;
  h=from:to:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=rEa/pDXo+8mpEbvHzoVz6xO9FkgrIBFfQHTrHE4Tjwg=;
  b=j1le9SSaGnMYGP4r/NGLttzBzpOPo9E2aCQr70zs6V7SmdcwdGiRCzXG
   psC4L+11n2POE6Z+NvquFCmrk+apR7i2W97t+6gnuYrXo6tzhbeXpE9++
   6aiK/WuOAZE6nRCecYZIuJkc6A1Kd4x7A0TSdNfzx4wn4y0X5MwqSNZ2t
   o=;
X-IronPort-AV: E=Sophos;i="5.81,215,1610409600"; 
   d="scan'208";a="93746295"
Subject: Re: [PATCH] KVM: flush deferred static key before checking it
Thread-Topic: [PATCH] KVM: flush deferred static key before checking it
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 01 Mar 2021 12:24:06 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id DB546A2519;
        Mon,  1 Mar 2021 12:24:05 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 12:24:05 +0000
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 12:24:05 +0000
Received: from EX13D08UEE001.ant.amazon.com ([10.43.62.126]) by
 EX13D08UEE001.ant.amazon.com ([10.43.62.126]) with mapi id 15.00.1497.010;
 Mon, 1 Mar 2021 12:24:05 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Thread-Index: AQHXDCduWouMiZ/pzka0NsdTm6Cki6pvEziA
Date:   Mon, 1 Mar 2021 12:24:05 +0000
Message-ID: <ce7eae86728814fb495e57643d8aeb3adb5de950.camel@amazon.co.uk>
References: <20210226100853.75344-1-pbonzini@redhat.com>
In-Reply-To: <20210226100853.75344-1-pbonzini@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.228]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCC0F535BE7A3347878C95767CFCE425@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTI2IGF0IDA1OjA4IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBBIG1pc3NpbmcgZmx1c2ggd291bGQgY2F1c2UgdGhlIHN0YXRpYyBicmFuY2ggdG8gdHJpZ2dl
ciBpbmNvcnJlY3RseS4NCj4gDQo+IENjOiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNv
LnVrPg0KPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29t
Pg0KDQoNClJldmlld2VkLWJ5OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNvLnVrPg0K
DQpUaGFua3MuDQoNCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50cmUgKExvbmRvbikgTHRkLiBS
ZWdpc3RlcmVkIGluIEVuZ2xhbmQgYW5kIFdhbGVzIHdpdGggcmVnaXN0cmF0aW9uIG51bWJlciAw
NDU0MzIzMiB3aXRoIGl0cyByZWdpc3RlcmVkIG9mZmljZSBhdCAxIFByaW5jaXBhbCBQbGFjZSwg
V29yc2hpcCBTdHJlZXQsIExvbmRvbiBFQzJBIDJGQSwgVW5pdGVkIEtpbmdkb20uCgoK

