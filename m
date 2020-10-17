Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBF3291369
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438760AbgJQSGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 14:06:38 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:28577 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438752AbgJQSGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 14:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602957995; x=1634493995;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=zWCcIWQD6xGx9ejw97Me0zftznbDXo04u09ZpNKNrPk=;
  b=InP3gyRLqsJ1ubaST6V21UJDZlP6xXe+SCaXOKb6NsksYXyb6JMvF0Ex
   2hEkIdkFFi+qlypbIr/sZXCwgQN+JGXa7dVi0eCa4m5y2c0+mdeqQi15p
   u55+Zswkk9QTIcR1U0P8+146+Tqh3Mxb0h/nskbqhmiKUAJlA6mmS8o7F
   o=;
X-IronPort-AV: E=Sophos;i="5.77,387,1596499200"; 
   d="scan'208";a="85548146"
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Thread-Topic: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 17 Oct 2020 18:06:28 +0000
Received: from EX13D07EUB003.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id 0EFFDC2A21;
        Sat, 17 Oct 2020 18:06:26 +0000 (UTC)
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13D07EUB003.ant.amazon.com (10.43.166.173) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 17 Oct 2020 18:06:25 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.006;
 Sat, 17 Oct 2020 18:06:25 +0000
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Thread-Index: AQHWo8lIfZnFKGe8nkGmhTCXwq5R36mbBVEAgAAgZgCAAAdoAIAACOIAgAAHlICAAAn4AIAABFwAgAAOgACAAAMJAIAAbJEAgACBKAA=
Date:   Sat, 17 Oct 2020 18:06:25 +0000
Message-ID: <76FF304F-C828-46CB-B82B-0948D4E927F5@amazon.com>
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
In-Reply-To: <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.242]
Content-Type: text/plain; charset="utf-8"
Content-ID: <54388C129E88694AB95901884CDE5626@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ICAgIEFmdGVyIGRpc2N1c3NpbmcgdGhpcyBvZmZsaW5lIHdpdGggSmFubiBhIGJpdCwgSSBoYXZl
IGEgZmV3IGdlbmVyYWwNCiAgICBjb21tZW50cyBvbiB0aGUgZGVzaWduIG9mIHRoaXMuIA0KICAg
IEZpcnN0LCB0aGUgVVVJRCBjb21tdW5pY2F0ZWQgYnkgdGhlIGh5cGVydmlzb3Igc2hvdWxkIGJl
IGNvbnN1bWVkIGJ5DQogICAgdGhlIGtlcm5lbCAtLSBhZGRlZCBhcyBhbm90aGVyIGlucHV0IHRv
IHRoZSBybmcgLS0gYW5kIHRoZW4gdXNlcnNwYWNlDQogICAgc2hvdWxkIGJlIG5vdGlmaWVkIHRo
YXQgaXQgc2hvdWxkIHJlc2VlZCBhbnkgdXNlcnNwYWNlIFJOR3MgdGhhdCBpdA0KICAgIG1heSBo
YXZlLCB3aXRob3V0IGFjdHVhbGx5IGNvbW11bmljYXRpbmcgdGhhdCBVVUlEIHRvIHVzZXJzcGFj
ZS4gSU9XLA0KICAgIEkgYWdyZWUgd2l0aCBKYW5uIHRoZXJlLiBUaGVuLCBpdCdzIHRoZSBmdW5j
dGlvbmluZyBvZiB0aGlzDQogICAgbm90aWZpY2F0aW9uIG1lY2hhbmlzbSB0byB1c2Vyc3BhY2Ug
dGhhdCBpcyBpbnRlcmVzdGluZyB0byBtZS4NCg0KQWdyZWVkISBUaGUgVVVJRC92bWdlbmlkIGlz
IHRoZSBnbHVlIHRvIHRoZSBoeXBlcnZpc29yIHRvIGJlIGFibGUgdG8gZmluZCANCm91dCBhYm91
dCBWTSBzbmFwc2hvdHMvZm9ya3MuIFRoZSByZWFsbHkgaW50ZXJlc3RpbmcgKGFuZCBpbXBvcnRh
bnQpIHRvcGljDQpoZXJlIGlzIGZpbmRpbmcgdGhlIHJpZ2h0IG5vdGlmaWNhdGlvbiBtZWNoYW5p
c20gdG8gdXNlcnNwYWNlLg0KDQouLi5JbiByZXRyb3NwZWN0LCBJIHNob3VsZCBoYXZlIHBvc3Rl
ZCB0aGlzIGFzIFJGQyBpbnN0ZWFkIG9mIFBBVENILg0KICAgIA0KICAgIFNvLCBhbnl3YXksIGhl
cmUgYXJlIGEgZmV3IG9wdGlvbnMgd2l0aCBzb21lIHByb3MgYW5kIGNvbnMgZm9yIHRoZQ0KICAg
IGtlcm5lbCBub3RpZnlpbmcgdXNlcnNwYWNlIHRoYXQgaXRzIFJORyBzaG91bGQgcmVzZWVkLg0K
ICAgIDEuIFNJR1JORCAtIGEgbmV3IHNpZ25hbC4gTG9sLg0KICAgIDIuIFVzZXJzcGFjZSBvcGVu
cyBhIGZpbGUgZGVzY3JpcHRvciB0aGF0IGl0IGNhbiBlcG9sbCBvbi4gUHJvcyBhcmUNCiAgICB0
aGF0IG1hbnkgbm90aWZpY2F0aW9uIG1lY2hhbmlzbXMgYWxyZWFkeSB1c2UgdGhpcy4gQ29ucyBp
cyB0aGF0IHRoaXMNCiAgICByZXF1aXJlcyBzeXNjYWxsIGFuZCBtaWdodCBiZSBtb3JlIHJhY3kg
dGhhbiB3ZSB3YW50LiBBbm90aGVyIGNvbiBpcw0KICAgIHRoYXQgdGhpcyBhIG5ldyB0aGluZyBm
b3IgdXNlcnNwYWNlIHByb2dyYW1zIHRvIGRvLg0KICAgIDMuIFdlIHN0aWNrIGFuIGF0b21pYyBj
b3VudGVyIGluIHRoZSB2RFNPLCBKYW5uJ3Mgc3VnZ2VzdGlvbi4gUHJvcyBhcmUNCiAgICB0aGF0
IHRoaXMgaXMgZXh0cmVtZWx5IGZhc3QsIGFuZCBhbHNvIHNpbXBsZSB0byB1c2UgYW5kIGltcGxl
bWVudC4NCiAgICBUaGVyZSBhcmUgZW5vdWdoIHNlcXVlbmNlIHBvaW50cyBpbiB0eXBpY2FsIGNy
eXB0byBwcm9ncmFtcyB0aGF0DQogICAgY2hlY2tpbmcgdG8gc2VlIHdoZXRoZXIgdGhpcyBjb3Vu
dGVyIGhhcyBjaGFuZ2VkIGJlZm9yZSBkb2luZyB3aGF0ZXZlcg0KICAgIG9wZXJhdGlvbiBzZWVt
cyBlYXN5IGVub3VnaC4gQ29ucyBhcmUgdGhhdCB0eXBpY2FsbHkgd2UndmUgYmVlbg0KICAgIGNv
bnNlcnZhdGl2ZSBhYm91dCBhZGRpbmcgdGhpbmdzIHRvIHRoZSB2RFNPLCBhbmQgdGhpcyBpcyBh
bHNvIGEgbmV3DQogICAgdGhpbmcgZm9yIHVzZXJzcGFjZSBwcm9ncmFtcyB0byBkby4NCg0KRm9y
IGVhY2ggMSwgMiwgYW5kIDMgb3B0aW9ucywgdXNlcnNwYWNlIHByb2dyYW1zIF9oYXZlIHRvIGRv
IHNtdGggbmV3Xw0KYW55d2F5LCBzbyBJIHdvdWxkbid0IHdlaWdoIHRoYXQgYXMgYSBjb24uDQoN
CkFuIGF0b21pYyBjb3VudGVyIGluIHRoZSB2RFNPIGxvb2tzIGxpa2UgdGhlIG1vc3QgYmFuZyBm
b3IgdGhlIGJ1Y2sgdG8gbWUuDQpJJ20gcmVhbGx5IGN1cmlvdXMgdG8gaGVhciBtb3JlIG9waW5p
b25zIG9uIHdoeSB3ZSBzaG91bGRuJ3QgZG8gaXQuDQogICAgDQogICAgNC4gV2UgYWxyZWFkeSBo
YXZlIGEgbWVjaGFuaXNtIGZvciB0aGlzIGtpbmQgb2YgdGhpbmcsIGJlY2F1c2UgdGhlDQogICAg
c2FtZSBpc3N1ZSBjb21lcyB1cCB3aGVuIGZvcmsoKWluZy4gVGhlIHNvbHV0aW9uIHdhcyBNQURW
X1dJUEVPTkZPUkssDQogICAgd2hlcmUgdXNlcnNwYWNlIG1hcmtzIGEgcGFnZSB0byBiZSB6ZXJv
ZWQgd2hlbiBmb3JraW5nLCBmb3IgdGhlDQogICAgcHVycG9zZXMgb2YgdGhlIFJORyBiZWluZyBu
b3RpZmllZCB3aGVuIGl0cyB3b3JsZCBnZXRzIHNwbGl0IGluIHR3by4NCiAgICBUaGlzIGlzIGJh
c2ljYWxseSB0aGUgc2FtZSB0aGluZyBhcyB3ZSdyZSBkaXNjdXNzaW5nIGhlcmUgd2l0aCBndWVz
dA0KICAgIHNuYXBzaG90cywgZXhjZXB0IGl0J3Mgb24gdGhlIHN5c3RlbSBsZXZlbCByYXRoZXIg
dGhhbiB0aGUgcHJvY2Vzcw0KICAgIGxldmVsLCBhbmQgYSBzeXN0ZW0gaGFzIG1hbnkgcHJvY2Vz
c2VzLiBCdXQgdGhlIHByb2JsZW0gc3BhY2UgaXMgc3RpbGwNCiAgICBhbG1vc3QgdGhlIHNhbWUs
IGFuZCB3ZSBjb3VsZCBzaW1wbHkgcmV1c2UgdGhhdCBzYW1lIG1lY2hhbmlzbS4gVGhlcmUNCiAg
ICBhcmUgYSBmZXcgaW1wbGVtZW50YXRpb24gc3RyYXRlZ2llcyBmb3IgdGhhdDoNCg0KSSBkb24n
dCB0aGluayB3ZSBjYW4gcGlnZ3kgYmFjayBvbiBNQURWX1dJUEVPTkZPUksuIFRoYXQgbWFkdmlz
ZSBmbGFnDQpoYXMgYSBjbGVhciBjb250cmFjdCBvZiBvbmx5IHdpcGluZyBfb24gZm9ya18uIE92
ZXJsb2FkaW5nIGl0IHdpdGggd2lwaW5nDQpvbiBWTS1mb3JrIC0gd2hpbGUgcHJvY2VzcyBkb2Vz
bid0IGZvcmsgLSBtaWdodCBicmVhayBzb21lIG9mIGl0cyB1c2Vycy4NCiAgICANCiAgICA0YS4g
V2UgbWVzcyB3aXRoIHRoZSBQVEVzIG9mIGFsbCBwcm9jZXNzZXMnIHBhZ2VzIHRoYXQgYXJlDQog
ICAgTUFEVl9XSVBFT05GT1JLLCBsaWtlIGZvcmsgZG9lcyBub3csIHdoZW4gdGhlIGh5cGVydmlz
b3Igbm90aWZpZXMgdXMNCiAgICB0byBkbyBzby4gVGhlbiB3ZSB3aW5kIHVwIHJldXNpbmcgdGhl
IGFscmVhZHkgZXhpc3RpbmcgbG9naWMgZm9yDQogICAgdXNlcnNwYWNlIFJOR3MuIENvbnMgbWln
aHQgYmUgdGhhdCB0aGlzIHVzdWFsbHkgcmVxdWlyZXMgc2VtYXBob3JlcywNCiAgICBhbmQgd2Un
cmUgaW4gaXJxIGNvbnRleHQsIHNvIHdlJ2QgaGF2ZSB0byBob2lzdCB0byBhIHdvcmtxdWV1ZSwg
d2hpY2gNCiAgICBtZWFucyBlaXRoZXIgbW9yZSB3YWtlIHVwIGxhdGVuY3ksIG9yIGEgbGFyZ2Vy
IHJhY2Ugd2luZG93Lg0KICAgIDRiLiBXZSBqdXN0IG1lbXplcm8gYWxsIHByb2Nlc3NlcycgcGFn
ZXMgdGhhdCBhcmUgTUFEVl9XSVBFT05GT1JLLA0KICAgIHdoZW4gdGhlIGh5cGVydmlzb3Igbm90
aWZpZXMgdXMgdG8gZG8gc28uIFRoZW4gd2Ugd2luZCB1cCByZXVzaW5nIHRoZQ0KICAgIGFscmVh
ZHkgZXhpc3RpbmcgbG9naWMgZm9yIHVzZXJzcGFjZSBSTkdzLg0KICAgIDRjLiBUaGUgZ3Vlc3Qg
a2VybmVsIG1haW50YWlucyBhbiBhcnJheSBvZiBwaHlzaWNhbCBhZGRyZXNzZXMgdGhhdCBhcmUN
CiAgICBNQURWX1dJUEVPTkZPUksuIFRoZSBoeXBlcnZpc29yIGtub3dzIGFib3V0IHRoaXMgYXJy
YXkgYW5kIGl0cw0KICAgIGxvY2F0aW9uIHRocm91Z2ggd2hhdGV2ZXIgcHJvdG9jb2wsIGFuZCBi
ZWZvcmUgcmVzdW1pbmcgYQ0KICAgIG1vdmVkL3NuYXBzaG90dGVkL2R1cGxpY2F0ZWQgVk0sIGl0
IHRha2VzIHRoZSByZXNwb25zaWJpbGl0eSBmb3INCiAgICBtZW16ZXJvaW5nIHRoaXMgbWVtb3J5
LiBUaGUgaHVnZSBwcm8gaGVyZSB3b3VsZCBiZSB0aGF0IHRoaXMNCiAgICBlbGltaW5hdGVzIGFs
bCByYWNlcywgYW5kIHJlZHVjZXMgY29tcGxleGl0eSBxdWl0ZSBhIGJpdCwgYmVjYXVzZSB0aGUN
CiAgICBoeXBlcnZpc29yIGNhbiBwZXJmZWN0bHkgc3luY2hyb25pemUgaXRzIGJyaW5ndXAgKGFu
ZCBTTVAgYnJpbmd1cCkNCiAgICB3aXRoIHRoaXMsIGFuZCBpdCBjYW4gZXZlbiBvcHRpbWl6ZSB0
aGluZ3MgbGlrZSBvbi1kaXNrIG1lbW9yeQ0KICAgIHNuYXBzaG90cyB0byBzaW1wbHkgbm90IHdy
aXRlIG91dCB0aG9zZSBwYWdlcyB0byBkaXNrLg0KDQpJJ3ZlIHByZXZpb3VzbHkgcHJvcG9zZWQg
YSBwYXRoIHNpbWlsYXIgKGluIGNvbmNlcHQgYXQgbGVhc3QpIHdpdGggYSBjb21iaW5hdGlvbg0K
b2YgNCBhLGIgYW5kIGMgLSBodHRwczovL2x3bi5uZXQvbWwvbGludXgtbW0vQjc3OTNCN0EtMzY2
MC00NzY5LTlCOUEtRkZDRjI1MDcyOEJCQGFtYXpvbi5jb20vDQp3aXRob3V0IHJldXNpbmcgTUFE
Vl9XSVBFT05GT1JLLCBidXQgYnkgYWRkaW5nIGEgZGVkaWNhdGVkDQpNQURWX1dJUEVPTlNVU1BF
TkQuDQoNClRoYXQgcHJvcG9zYWwgd2FzIGNsdW5reSBob3dldmVyIHdpdGggbWFueSBwZW9wbGUg
cmFpc2luZyBjb25jZXJucyBhcm91bmQNCmhvdyB0aGUgaW50ZXJmYWNlIGlzIHRvbyBzdWJ0bGUg
YW5kIGhhcmQgdG8gd29yayB3aXRoLg0KDQpBIHZtZ2VuaWQgZHJpdmVyIG9mZmVyaW5nIGEgY2xl
YW4gRlMgaW50ZXJmYWNlIHNlZW1lZCBjbGVhbmVyLCBhbHRob3VnaCwgbGlrZQ0Kc29tZSBvZiB5
b3Ugb2JzZXJ2ZWQsIGl0IHN0aWxsIGFsbG93cyBhIHdpbmRvdyBvZiB0aW1lIGJldHdlZW4gYWN0
dWFsIFZNIGZvcmsNCmFuZCB1c2Vyc3BhY2UgaGFuZGxpbmcgb2YgdGhlIGV2ZW50Lg0KDQpPbmUg
b3RoZXIgZGlyZWN0aW9uIHRoYXQgSSB3b3VsZCBsaWtlIHRvIGV4cGxvcmUgYW5kIEkgZmVlbCBp
dOKAmXMgc2ltaWxhciB0byB5b3VyIDRjDQpwcm9wb3NhbCBpcyB0byBkbyBzbXRoIGxpa2U6DQoi
bW06IGV4dGVuZCBtZW1mZCB3aXRoIGFiaWxpdHkgdG8gY3JlYXRlICdzZWNyZXQnIG1lbW9yeSIN
Cmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC1tbS9wYXRjaC8yMDIw
MDEzMDE2MjM0MC5HQTE0MjMyQHJhcG9wb3J0LWxueC8NCg0KTWF5YmUgd2UgY2FuIGNvbWJpbmUg
aWRlYXMgZnJvbSB0aGUgdHdvIHBhdGNoZXMgaW4gc210aCBsaWtlOiBpbnN0ZWFkIG9mIGxpYnMN
CnVzaW5nIGFub24gbWVtIHdpdGggTUFEVl9XSVBFT05TVVNQRU5ELCB0aGV5IGNhbiB1c2UgYSBz
ZWNyZXRfbWVtX2ZkDQp3aXRoIGEgKHNlY3JldG1lbSBzcGVjaWZpYykgV0lQRU9OU1VTUEVORCBm
bGFnOyB0aGVuIGluc3RlYWQgb2YgY3Jhd2xpbmcNClBURXMgaW4gdGhlIGNvcmUgUE0gY29kZSBs
b29raW5nIGZvciBNQURWX1dJUEVPTlNVU1BFTkQgbWFwcGluZ3MsDQp3ZSBjYW4gcmVnaXN0ZXIg
dGhpcyBzZWNyZXRtZW0gZGV2aWNlIHRvIHdpcGUgaXRzIG93biBzZWNyZXRzIGR1cmluZyBhIHBt
IGNhbGxiYWNrLg0KDQpGcm9tIGEgY3J5cHRvIHNhZmV0eSBwb3YsIHRoZSBpZGVhbCBzb2x1dGlv
biB3b3VsZCBiZSBvbmUgd2hlcmUgd2lwaW5nIGhhcHBlbnMNCmJlZm9yZSBvciBkdXJpbmcgVk0g
Zm9ya3MsIG5vdCBhZnRlci4NCkhhdmluZyBzYWlkIHRoYXQsIEkgdGhpbmsgYSB2RFNPICh1cGRh
dGVkIGJ5IHRoZSBndWVzdCBrZXJuZWwgX2FmdGVyXyBWTSBmb3JrKSBzdGlsbA0KY2xvc2VzIHRo
YXQgZ2FwIGVub3VnaCB0byBiZSBwcmFjdGljYWxseSBzYWZlLg0KDQpUaGFua3MsDQpBZHJpYW4u
DQoNCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3Rl
cmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElh
c2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0
cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

