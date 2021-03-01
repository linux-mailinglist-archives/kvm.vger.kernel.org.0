Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D861A327EAD
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 13:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbhCAM40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 07:56:26 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:37869 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbhCAM4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 07:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1614603385; x=1646139385;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=wK8ye9wSCEUGAmX244Av5oW0fUbFzEYhZofRNgtpZiw=;
  b=mMHud9pcYVDu2ELyJ9eKh0sT4maPpVnTFL3+pyohKG7b/UtaF8y9fMqs
   U+lAPmKBffu62aj4lUjkZSRukKtGMF5V/KArk9Av6pScet2JVVsBf9YYg
   eYLzmXrmtQAeiBebYiw7ljHtoui1AQOpHrrgemSrBygGwBazmjoxKHLpN
   k=;
X-IronPort-AV: E=Sophos;i="5.81,215,1610409600"; 
   d="scan'208";a="89524518"
Subject: Re: [PATCH v2] KVM: x86: allow compiling out the Xen hypercall interface
Thread-Topic: [PATCH v2] KVM: x86: allow compiling out the Xen hypercall interface
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 01 Mar 2021 12:55:48 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 34548C036B;
        Mon,  1 Mar 2021 12:55:47 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 12:55:46 +0000
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 12:55:46 +0000
Received: from EX13D08UEE001.ant.amazon.com ([10.43.62.126]) by
 EX13D08UEE001.ant.amazon.com ([10.43.62.126]) with mapi id 15.00.1497.010;
 Mon, 1 Mar 2021 12:55:46 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "hch@lst.de" <hch@lst.de>
Thread-Index: AQHXDDaztgP1a9Ed90euQ0LGk1p4HapvG/WA
Date:   Mon, 1 Mar 2021 12:55:46 +0000
Message-ID: <49138fc5ae02d6009af3adcdb49f5cce05c3bfd9.camel@amazon.co.uk>
References: <20210226115744.170536-1-pbonzini@redhat.com>
In-Reply-To: <20210226115744.170536-1-pbonzini@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.104]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8E879A9FC923D48B4B33D6D0ABB3468@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTI2IGF0IDA2OjU3IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiArICAgICAgIGRlcGVuZHMgb24gS1ZNICYmIElBMzJfRkVBVF9DVEwNCg0KSG0sIHdoeSBJQTMy
X0ZFQVRfQ1RMPw0KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRyZSAoTG9uZG9uKSBMdGQuIFJl
Z2lzdGVyZWQgaW4gRW5nbGFuZCBhbmQgV2FsZXMgd2l0aCByZWdpc3RyYXRpb24gbnVtYmVyIDA0
NTQzMjMyIHdpdGggaXRzIHJlZ2lzdGVyZWQgb2ZmaWNlIGF0IDEgUHJpbmNpcGFsIFBsYWNlLCBX
b3JzaGlwIFN0cmVldCwgTG9uZG9uIEVDMkEgMkZBLCBVbml0ZWQgS2luZ2RvbS4KCgo=

