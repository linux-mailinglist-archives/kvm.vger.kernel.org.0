Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB6415D1B
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 13:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbhIWL4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 07:56:09 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:48701 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240619AbhIWL4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 07:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1632398077; x=1663934077;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=S5mL2dn1mYpzVq17QlZx6znS4ZymsgCKaw1LB9D2m5o=;
  b=s4csp8S+wnIm5SHQNkgIijF+RlorO2qsg8sulhe9pYQfDyBe6RcavpVW
   WT3KE9ljJp1vp7drdSSIX1x440gXgFZIlcnY4JmGSvcFQ8oFLNeE0O5vG
   h93TqDuKz1skEqbOK+g9UOQc8yJ7S5Pk3GHfq9nk5WXY/PTyNpu91mvwU
   E=;
X-IronPort-AV: E=Sophos;i="5.85,316,1624320000"; 
   d="scan'208";a="144027674"
Subject: Re: [PATCH v2] scripts: Add get_maintainer.pl
Thread-Topic: [PATCH v2] scripts: Add get_maintainer.pl
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-8ac79c09.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 23 Sep 2021 11:54:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-8ac79c09.us-east-1.amazon.com (Postfix) with ESMTPS id 2AFE9852EF;
        Thu, 23 Sep 2021 11:54:27 +0000 (UTC)
Received: from EX13D20UWC003.ant.amazon.com (10.43.162.18) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 23 Sep 2021 11:54:27 +0000
Received: from EX13D24EUA001.ant.amazon.com (10.43.165.233) by
 EX13D20UWC003.ant.amazon.com (10.43.162.18) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 23 Sep 2021 11:54:26 +0000
Received: from EX13D24EUA001.ant.amazon.com ([10.43.165.233]) by
 EX13D24EUA001.ant.amazon.com ([10.43.165.233]) with mapi id 15.00.1497.023;
 Thu, 23 Sep 2021 11:54:26 +0000
From:   "Ahmed, Daniele" <ahmeddan@amazon.co.uk>
To:     Andrew Jones <drjones@redhat.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Thread-Index: AQHXsG5PO40Ybe2bwkeDoHgLRtlWK6uxfhkAgAAmE4A=
Date:   Thu, 23 Sep 2021 11:54:26 +0000
Message-ID: <285640D4-E80B-4EBB-8D24-9ACEB4FAFBE2@amazon.com>
References: <20210923112933.20476-1-graf@amazon.com>
 <20210923113808.wtegvmts7xvsid7r@gator.home>
In-Reply-To: <20210923113808.wtegvmts7xvsid7r@gator.home>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.211]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E387B5E705A8B4E898EE8D3A02D7D7A@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGVzdGVkLWJ5OiBEYW5pZWxlIEFobWVkIDxhaG1lZGRhbkBhbWF6b24uY29tPg0KDQrvu79PbiAy
My8wOS8yMDIxLCAxMzozOSwgIkFuZHJldyBKb25lcyIgPGRyam9uZXNAcmVkaGF0LmNvbT4gd3Jv
dGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9m
IHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBp
cyBzYWZlLg0KDQoNCg0KICAgIE9uIFRodSwgU2VwIDIzLCAyMDIxIGF0IDAxOjI5OjMzUE0gKzAy
MDAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOg0KICAgID4gV2hpbGUgd2UgYWRvcHRlZCB0aGUgTUFJ
TlRBSU5FUlMgZmlsZSBpbiBrdm0tdW5pdC10ZXN0cywgdGhlIHRvb2wgdG8NCiAgICA+IGRldGVy
bWluZSB3aG8gdG8gQ0Mgb24gcGF0Y2ggc3VibWlzc2lvbnMgaXMgc3RpbGwgbWlzc2luZy4NCiAg
ICA+DQogICAgPiBDb3B5IExpbnV4J3MgdmVyc2lvbiBvdmVyIGFuZCBhZGp1c3QgaXQgdG8gd29y
ayB3aXRoIGFuZCBjYWxsIG91dCB0aGUNCiAgICA+IGt2bS11bml0LXRlc3RzIHRyZWUuDQogICAg
Pg0KICAgID4gU2lnbmVkLW9mZi1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4N
CiAgICA+DQogICAgPiAtLS0NCiAgICA+DQogICAgPiB2MSAtPiB2MjoNCiAgICA+DQogICAgPiAg
IC0gUmVtb3ZlIFBlbmdpdW4gQ2hpZWYgbG9naWMNCiAgICA+IC0tLQ0KICAgID4gIHNjcmlwdHMv
Z2V0X21haW50YWluZXIucGwgfCAyNTQzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCiAgICA+ICAxIGZpbGUgY2hhbmdlZCwgMjU0MyBpbnNlcnRpb25zKCspDQogICAgPiAg
Y3JlYXRlIG1vZGUgMTAwNzU1IHNjcmlwdHMvZ2V0X21haW50YWluZXIucGwNCg0KICAgIFlvdSBr
bm93IGEgcHJvamVjdCBpcyBnZXR0aW5nIHNlcmlvdXMgd2hlbiBpdCBjb250YWlucyAyNTAwIGxp
bmVzIG9mIHBlcmwuDQoNCiAgICBBY2tlZC1ieTogQW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhh
dC5jb20+DQoNCg0KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3Jh
dXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNj
aGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAy
MzcgODc5CgoK

