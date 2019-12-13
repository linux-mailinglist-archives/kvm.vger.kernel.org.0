Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349B011E490
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 14:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfLMN2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 08:28:32 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:28751 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfLMN2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 08:28:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1576243711; x=1607779711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=coJqal6mOMw8DkKrznC66iIkrprgAV0OHP70UFVq8Pw=;
  b=SQEK6IH6HujGUZtBO5xaft6DzAY6sl53sska1OvbklN9iU/QF5KlAAGl
   v4hDcvftDVPi6ULZ3bT94+FW+WTkushkSZAxtWGzlQQD6aO+18w8wKfjS
   1Jja0C3FjpB2RMHoqQ/rLjEwMyW9kTaUBzGWuWLD1wg2gHaCxYGcFxOFs
   k=;
IronPort-SDR: ctoadH9cS6UHy8JxlW76ZMIS7yq4lMny506SUMtie2Tb4ouyhZvbvjAfcBuN0fJCAOqWX+mWMA
 sjocSkspeMRA==
X-IronPort-AV: E=Sophos;i="5.69,309,1571702400"; 
   d="scan'208";a="7498710"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 13 Dec 2019 13:28:30 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 70073A1F89;
        Fri, 13 Dec 2019 13:28:29 +0000 (UTC)
Received: from EX13D27EUB004.ant.amazon.com (10.43.166.152) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 13 Dec 2019 13:28:28 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D27EUB004.ant.amazon.com (10.43.166.152) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 13 Dec 2019 13:28:27 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Fri, 13 Dec 2019 13:28:25 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     "Pandurov, Milan" <milanpa@amazon.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>
Subject: Re: [PATCH v5] kvm: Refactor handling of VM debugfs files
Thread-Topic: [PATCH v5] kvm: Refactor handling of VM debugfs files
Thread-Index: AQHVsbZKzoJR28kSxEmKOK4zZncRCqe4DvkM
Date:   Fri, 13 Dec 2019 13:28:25 +0000
Message-ID: <B319D8F1-3E42-4ADA-9EA5-05C6A535D7CA@amazon.de>
References: <20191213130721.7942-1-milanpa@amazon.de>
In-Reply-To: <20191213130721.7942-1-milanpa@amazon.de>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gQW0gMTMuMTIuMjAxOSB1bSAxNDowNyBzY2hyaWViIFBhbmR1cm92LCBNaWxhbiA8bWls
YW5wYUBhbWF6b24uZGU+Og0KPiANCj4g77u/V2UgY2FuIHN0b3JlIHJlZmVyZW5jZSB0byBrdm1f
c3RhdHNfZGVidWdmc19pdGVtIGluc3RlYWQgb2YgY29weWluZw0KPiBpdHMgdmFsdWVzIHRvIGt2
bV9zdGF0X2RhdGEuDQo+IFRoaXMgYWxsb3dzIHVzIHRvIHJlbW92ZSBkdXBsaWNhdGVkIGNvZGUg
YW5kIHVzYWdlIG9mIHRlbXBvcmFyeQ0KPiBrdm1fc3RhdF9kYXRhIGluc2lkZSB2bV9zdGF0X2dl
dCBldCBhbC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pbGFuIFBhbmR1cm92IDxtaWxhbnBhQGFt
YXpvbi5kZT4NCj4gUmV2aWV3ZWQtYnk6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFuYXpvbi5jb20+
DQoNCklmIHRoZXJlIGFyZSBubyBmdXJ0aGVyIGNvbW1lbnRzIGNvdWxkIHdob2V2ZXIgYXBwbGll
cyB0aGlzIHBsZWFzZSBmaXggbXkgdHlwbz8gOikNCg0KDQpUaGFua3MsDQoNCkFsZXgNCg0KCgoK
QW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAx
MTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgUmFsZiBI
ZXJicmljaApFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBI
UkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

