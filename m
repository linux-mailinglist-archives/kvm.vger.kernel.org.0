Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A88D41EF36
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 16:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354257AbhJAOQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 10:16:53 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:27411 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354269AbhJAOQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 10:16:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1633097707; x=1664633707;
  h=from:to:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=IZOkIWDMA/WI9bRwQbj7STdxhS6/1XHnVw4USlz+hXc=;
  b=On9r2EUmBz/JS9FOgqOGKGRJjO5iYGcvHKOkE3vxdQm834bps+si9ciV
   lsM5x0XaT5UuNpm0mw6fn3NlziZ5e4SIQetThtidvAD6DrsA9SRLdmIiU
   qS6VIwsRqDhZFVKbiCRt0UzY0UqnncfaLJ2qso1BtUyaE7LmI5U+3j4YD
   g=;
X-IronPort-AV: E=Sophos;i="5.85,339,1624320000"; 
   d="scan'208";a="144746708"
Subject: Re: [kvm-unit-tests PATCH v2 3/3] x86/msr.c generalize to any input msr
Thread-Topic: [kvm-unit-tests PATCH v2 3/3] x86/msr.c generalize to any input msr
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 01 Oct 2021 14:14:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id 907A581872;
        Fri,  1 Oct 2021 14:14:58 +0000 (UTC)
Received: from EX13D20UWA002.ant.amazon.com (10.43.160.176) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 1 Oct 2021 14:14:57 +0000
Received: from EX13D24EUA001.ant.amazon.com (10.43.165.233) by
 EX13D20UWA002.ant.amazon.com (10.43.160.176) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 1 Oct 2021 14:14:57 +0000
Received: from EX13D24EUA001.ant.amazon.com ([10.43.165.233]) by
 EX13D24EUA001.ant.amazon.com ([10.43.165.233]) with mapi id 15.00.1497.023;
 Fri, 1 Oct 2021 14:14:56 +0000
From:   "Ahmed, Daniele" <ahmeddan@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nikos.nikoleris@arm.com" <nikos.nikoleris@arm.com>,
        "drjones@redhat.com" <drjones@redhat.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>
Thread-Index: AQHXs7ULIWMlxFPQiUyabePPTol626u5layAgATB24A=
Date:   Fri, 1 Oct 2021 14:14:56 +0000
Message-ID: <F2E739E8-0507-4970-B9BA-D6DC0AFEB1B7@amazon.com>
References: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
 <20210927153028.27680-1-ahmeddan@amazon.com>
 <20210927153028.27680-3-ahmeddan@amazon.com>
 <a7ab8a21-f0a4-e15f-a34b-1eaea419638a@redhat.com>
In-Reply-To: <a7ab8a21-f0a4-e15f-a34b-1eaea419638a@redhat.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.203]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA17E453E12AB54DB66FF89867914C57@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGFvbG8sDQpUaGlzIHdvdWxkIGJlIHRvIHRlc3QgdGhlIGhhbmRsaW5nIG9mIHNwZWNpZmlj
IE1TUidzLCBib3RoIHRoZSBwdXJwb3NlcyB5b3UgbWVudGlvbi4NCkl0IG1heSBub3QgY292ZXIg
YWxsIHBvc3NpYmxlIGNhc2VzLiBJJ20gZXh0ZW5kaW5nIHRoZSBrdm0gdW5pdCB0ZXN0cyBmb3Ig
b3RoZXJzIHdobyBtaWdodCBoYXZlIHNpbWlsYXIgbmVlZHMuDQpJIGxvb2tlZCB1cCBCSVRTIGFu
ZCBpdCBzZWVtcyBsaWtlIGl0J3MgYmVlbiB1bm1haW50YWluZWQgZm9yIG1hbnkgeWVhcnMgbm93
IChhbHRob3VnaCBpdCBjb3VsZCBzdGlsbCBiZSB1c2VmdWwpLg0KTGV0IG1lIGtub3cgaWYgeW91
IGRvbid0IHRoaW5rIHRoaXMgaXMgdGhlIHJpZ2h0IHBsYWNlIGZvciB0aGlzIGNoYW5nZS4gSSd2
ZSBzZWVuIG90aGVyIHRlc3RzIHRoYXQgdGFrZSBjdXN0b20NCnZhbHVlcyB0byBiZSB1c2VkIGlu
c2lkZSB0aGUgdGVzdHMuDQpUaGFuayB5b3UNCg0K77u/T24gMjgvMDkvMjAyMSwgMTc6MzcsICJQ
YW9sbyBCb256aW5pIiA8cGJvbnppbmlAcmVkaGF0LmNvbT4gd3JvdGU6DQoNCiAgICBDQVVUSU9O
OiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24u
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNv
bmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAg
IE9uIDI3LzA5LzIxIDE3OjMwLCBhaG1lZGRhbkBhbWF6b24uY29tIHdyb3RlOg0KICAgID4gRnJv
bTogRGFuaWVsZSBBaG1lZCA8YWhtZWRkYW5AYW1hem9uLmNvbT4NCiAgICA+DQogICAgPiBJZiBh
biBNU1IgZGVzY3JpcHRpb24gaXMgcHJvdmlkZWQgYXMgaW5wdXQgYnkgdGhlIHVzZXIsDQogICAg
PiBydW4gdGhlIHRlc3QgYWdhaW5zdCB0aGF0IE1TUi4gVGhpcyBhbGxvd3MgdGhlIHVzZXIgdG8N
CiAgICA+IHJ1biB0ZXN0cyBvbiBjdXN0b20gTVNSJ3MuDQogICAgPg0KICAgID4gT3RoZXJ3aXNl
IHJ1biBhbGwgZGVmYXVsdCB0ZXN0cy4NCiAgICA+DQogICAgPiBUaGlzIGlzIHRvIHZhbGlkYXRl
IGN1c3RvbSBNU1IgaGFuZGxpbmcgaW4gdXNlciBzcGFjZQ0KICAgID4gd2l0aCBhbiBlYXN5LXRv
LXVzZSB0b29sLiBUaGlzIGt2bS11bml0LXRlc3Qgc3VibW9kdWxlDQogICAgPiBpcyBhIHBlcmZl
Y3QgZml0LiBJJ20gZXh0ZW5kaW5nIGl0IHdpdGggYSBtb2RlIHRoYXQNCiAgICA+IHRha2VzIGFu
IE1TUiBpbmRleCBhbmQgYSB2YWx1ZSB0byB0ZXN0IGFyYml0cmFyeSBNU1IgYWNjZXNzZXMuDQog
ICAgPg0KICAgID4gU2lnbmVkLW9mZi1ieTogRGFuaWVsZSBBaG1lZCA8YWhtZWRkYW5AYW1hem9u
LmNvbT4NCg0KICAgIEkgZG9uJ3QgdW5kZXJzdGFuZDsgaXMgdGhpcyBhIGRlYnVnZ2luZyB0b29s
LCBvciBpcyBpdCBtZWFudCB0byBiZQ0KICAgIGRyaXZlbiBieSBhbm90aGVyIHRlc3Qgc3VpdGU/
DQoNCiAgICBJJ20gbm90IHN1cmUgdGhpcyBmaXRzIHRoZSBwdXJwb3NlIG9mIGt2bS11bml0LXRl
c3RzIHZlcnkgd2VsbCwgdGhvdWdoLg0KICAgICAgQW4gYWx0ZXJuYXRpdmUgaXMgQklUUyAoaHR0
cHM6Ly9naXRodWIuY29tL2Jpb3NiaXRzL2JpdHMvKSwgd2hpY2ggaXMNCiAgICByZWxhdGl2ZWx5
IGVhc3kgdG8gdXNlIGFuZCBjb21lcyB3aXRoIFB5dGhvbiBiaW5kaW5ncyB0byBSRE1TUi9XUk1T
Ui4NCg0KICAgIFBhb2xvDQoNCg0KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55
IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hy
aXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmlj
aHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6
IERFIDI4OSAyMzcgODc5CgoK

