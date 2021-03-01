Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07BC327E66
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 13:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhCAMbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 07:31:22 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:9418 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhCAMbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 07:31:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1614601864; x=1646137864;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=qp6DArGWKsm1NURtjYXJnQGBCDrsfhv6QB8U3ry0N6o=;
  b=brEum7e8pXlv11C5RMvcqdODKZiR+gDgOKIjv/nXkKfFJpCYkFT8M3vU
   SJIluHEW39YPs+rDs7Mrc4L4giyzT2S3ZgpnZZ0zkmUe9K/+YVnKm4vpC
   8QBUrsdeNb0uMexcYwQyj322rhqX03CBCRJkT1kHW8lr1xsXaVrqDS/77
   w=;
X-IronPort-AV: E=Sophos;i="5.81,215,1610409600"; 
   d="scan'208";a="89509071"
Subject: Re: [PATCH v2] KVM: x86: allow compiling out the Xen hypercall interface
Thread-Topic: [PATCH v2] KVM: x86: allow compiling out the Xen hypercall interface
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 01 Mar 2021 12:24:58 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id D11C6A10A7;
        Mon,  1 Mar 2021 12:24:56 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 12:24:55 +0000
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 12:24:55 +0000
Received: from EX13D08UEE001.ant.amazon.com ([10.43.62.126]) by
 EX13D08UEE001.ant.amazon.com ([10.43.62.126]) with mapi id 15.00.1497.010;
 Mon, 1 Mar 2021 12:24:55 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "hch@lst.de" <hch@lst.de>
Thread-Index: AQHXDDaztgP1a9Ed90euQ0LGk1p4HapvE1cA
Date:   Mon, 1 Mar 2021 12:24:55 +0000
Message-ID: <366796245ce0bcf6bf23f26f3692d5f76ca7f169.camel@amazon.co.uk>
References: <20210226115744.170536-1-pbonzini@redhat.com>
In-Reply-To: <20210226115744.170536-1-pbonzini@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0FD4EF1CCC7B24783190BC0E9A8C6D2@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTI2IGF0IDA2OjU3IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBUaGUgWGVuIGh5cGVyY2FsbCBpbnRlcmZhY2UgYWRkcyB0byB0aGUgYXR0YWNrIHN1cmZhY2Ug
b2YgdGhlIGh5cGVydmlzb3INCj4gYW5kIHdpbGwgYmUgdXNlZCBxdWl0ZSByYXJlbHkuICBBbGxv
dyBjb21waWxpbmcgaXQgb3V0Lg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBDaHJpc3RvcGggSGVsbHdp
ZyA8aGNoQGxzdC5kZT4NCj4gQ2M6IERhdmlkIFdvb2Rob3VzZSA8ZHdtd0BhbWF6b24uY28udWs+
DQo+IFNpZ25lZC1vZmYtYnk6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQoN
ClJldmlld2VkLWJ5OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNvLnVrPg0KDQpUaGFu
a3MuDQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudHJlIChMb25kb24pIEx0ZC4gUmVnaXN0ZXJl
ZCBpbiBFbmdsYW5kIGFuZCBXYWxlcyB3aXRoIHJlZ2lzdHJhdGlvbiBudW1iZXIgMDQ1NDMyMzIg
d2l0aCBpdHMgcmVnaXN0ZXJlZCBvZmZpY2UgYXQgMSBQcmluY2lwYWwgUGxhY2UsIFdvcnNoaXAg
U3RyZWV0LCBMb25kb24gRUMyQSAyRkEsIFVuaXRlZCBLaW5nZG9tLgoKCg==

