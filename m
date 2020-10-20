Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A4F2940DE
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 18:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394971AbgJTQyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 12:54:40 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:16471 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394963AbgJTQyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 12:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1603212879; x=1634748879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=+bj8U8RezaG268JdXw29LicrkbrnImce7j6a9Ka41Fw=;
  b=ZPRFjJRUS0ey1SJkwjcnoBSqFUpFZH5TLbUExrBdQ3smj1wVb+4FjoMm
   tUPyTGaNoYpVk3gqj8zF2WWD26kDAVUi36tdF2thV8etn3Rzkun3cs0bM
   r4CkE/0De86W2KZto9Fm/Xt2yWdN/PLoKbfIFXvafPI6FQreIOuTe6wH8
   A=;
X-IronPort-AV: E=Sophos;i="5.77,397,1596499200"; 
   d="scan'208";a="60147548"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 20 Oct 2020 16:54:33 +0000
Received: from EX13D07EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 1185CA18F0;
        Tue, 20 Oct 2020 16:54:25 +0000 (UTC)
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13D07EUB001.ant.amazon.com (10.43.166.214) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 16:54:24 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.006;
 Tue, 20 Oct 2020 16:54:24 +0000
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
To:     "Graf (AWS), Alexander" <graf@amazon.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>
CC:     Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        "Eric Biggers" <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Qemu Developers" <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        "Michal Hocko" <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Pavel Machek" <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "Mathiske, Bernd" <mathiske@amazon.com>,
        "Hohensee, Paul" <hohensee@amazon.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Thread-Topic: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Thread-Index: AQHWpLCgyRz7zwEeX0C0PpiPp4JTxamg7DuA
Date:   Tue, 20 Oct 2020 16:54:24 +0000
Message-ID: <9CB99FC7-3EDF-488E-B52C-DE0368A4BC81@amazon.com>
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu>
 <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
 <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
 <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu>
 <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
 <aacdff7a-2af1-4f46-6ab2-2a9d5b865d35@amazon.de>
In-Reply-To: <aacdff7a-2af1-4f46-6ab2-2a9d5b865d35@amazon.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D222EABD850A32409B803CF44A854938@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgYWxsLA0KDQrvu79PbiAxNy8xMC8yMDIwLCAyMTowOSwgIkdyYWYgKEFXUyksIEFsZXhhbmRl
ciIgPGdyYWZAYW1hem9uLmRlPiB3cm90ZToNCiAgICANCiAgICBPbiAxNy4xMC4yMCAxNToyNCwg
SmFzb24gQS4gRG9uZW5mZWxkIHdyb3RlOg0KICAgID4gDQogICAgPiBBZnRlciBkaXNjdXNzaW5n
IHRoaXMgb2ZmbGluZSB3aXRoIEphbm4gYSBiaXQsIEkgaGF2ZSBhIGZldyBnZW5lcmFsDQogICAg
PiBjb21tZW50cyBvbiB0aGUgZGVzaWduIG9mIHRoaXMuDQogICAgPiANCiAgICA+IEZpcnN0LCB0
aGUgVVVJRCBjb21tdW5pY2F0ZWQgYnkgdGhlIGh5cGVydmlzb3Igc2hvdWxkIGJlIGNvbnN1bWVk
IGJ5DQogICAgPiB0aGUga2VybmVsIC0tIGFkZGVkIGFzIGFub3RoZXIgaW5wdXQgdG8gdGhlIHJu
ZyAtLSBhbmQgdGhlbiB1c2Vyc3BhY2UNCiAgICANCiAgICBXZSBkZWZpbml0ZWx5IHdhbnQgYSBr
ZXJuZWwgaW50ZXJuYWwgbm90aWZpZXIgYXMgd2VsbCwgeWVzIDopLg0KDQpXaGF0IHdvdWxkIGJl
IGEgZ2VuZXJpYyBldmVudCB0cmlnZ2VyIG1lY2hhbmlzbSB3ZSBjb3VsZCB1c2UgZnJvbSBhIGtl
cm5lbA0KbW9kdWxlL2RyaXZlciBmb3IgdHJpZ2dlcmluZyBybmcgcmVzZWVkIChwb3NzaWJseSBh
ZGRpbmcgdGhlIHV1aWQgdG8gdGhlIG1peA0KYXMgd2VsbCk/DQoNCiAgDQoNCgoKCkFtYXpvbiBE
ZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdB
IFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAw
NDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBK
MjIvMjYyMS8yMDA1Lgo=

