Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48E02FE6DF
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbhAUJ5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:57:07 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52573 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbhAUJ4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 04:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1611222964; x=1642758964;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=tikY/ymWGHG7OvzSMWQNvUsnxukhLkfx1pylHsOnXHM=;
  b=oH7NzyUYqX8s/yOzRqT08+gUGL+RdiMqEjXO+0aAZ6RwzaT2LpcLxv1T
   TPtGII3IUIpy0fapAjbu0dD2q1UYal6lZx3KhFOOobAB02tSUV2LU+im9
   YcJ/fhXOxv4mDAsWHW8WVWfxoLUdjZXwdBXu1uj1xELdYOPNpD5+fIMyW
   o=;
X-IronPort-AV: E=Sophos;i="5.79,363,1602547200"; 
   d="scan'208";a="112521061"
Subject: Re: [PATCH v4 1/2] drivers/misc: sysgenid: add system generation id driver
Thread-Topic: [PATCH v4 1/2] drivers/misc: sysgenid: add system generation id driver
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Jan 2021 09:55:14 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id CA814A25BB;
        Thu, 21 Jan 2021 09:55:03 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 Jan 2021 09:54:28 +0000
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 Jan 2021 09:54:27 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.010;
 Thu, 21 Jan 2021 09:54:27 +0000
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
Thread-Index: AQHW6NzJ6Ner/CpAZ0GLGgCheKaWxKoj9j+AgA4QXAA=
Date:   Thu, 21 Jan 2021 09:54:27 +0000
Message-ID: <0EFE3365-1698-4BFB-B2F2-BEF1A2634E45@amazon.com>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <1610453760-13812-2-git-send-email-acatan@amazon.com>
 <X/2fP9LNWXvp7up9@kroah.com>
In-Reply-To: <X/2fP9LNWXvp7up9@kroah.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.195]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC44F688DB044F439484826026445BBE@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTIvMDEvMjAyMSwgMTU6MDcsICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5v
cmc+IHdyb3RlOg0KDQogICAgT24gVHVlLCBKYW4gMTIsIDIwMjEgYXQgMDI6MTU6NTlQTSArMDIw
MCwgQWRyaWFuIENhdGFuZ2l1IHdyb3RlOg0KICAgID4gKyAgUGFydGlhbCByZWFkcyBhcmUgbm90
IGFsbG93ZWQgLSByZWFkIGJ1ZmZlciBuZWVkcyB0byBiZSBhdCBsZWFzdA0KICAgID4gKyAgYGBz
aXplb2YodW5zaWduZWQpYGAgaW4gc2l6ZS4NCg0KICAgICJzaXplb2YodW5zaWduZWQpIj8gIEhv
dyBhYm91dCBiZWluZyBzcGVjaWZpYyBhbmQgbWFraW5nIHRoaXMgYSByZWFsICJYDQogICAgYml0
cyBiaWciIHZhbHVlIHBsZWFzZS4NCg0KICAgICJ1bnNpZ25lZCIgZG9lcyBub3Qgd29yayB3ZWxs
IGFjcm9zcyB1c2VyL2tlcm5lbCBib3VuZHJpZXMuICBPaywgdGhhdCdzDQogICAgb24gdW5kZXJz
dGF0ZW1lbnQsIHRoZSBjb3JyZWN0IHRoaW5nIGlzICJkb2VzIG5vdCB3b3JrIGF0IGFsbCIuDQoN
CiAgICBQbGVhc2UgYmUgc3BlY2lmaWMgaW4geW91ciBhcGlzLg0KDQogICAgVGhpcyBpcyBsaXN0
ZWQgZWxzZXdoZXJlIGFsc28uDQoNClJpZ2h0LCB3aWxsIGRvIQ0KDQogICAgPiArICAtIFNZU0dF
TklEX0dFVF9PVVREQVRFRF9XQVRDSEVSUzogaW1tZWRpYXRlbHkgcmV0dXJucyB0aGUgbnVtYmVy
IG9mDQogICAgPiArICAgICpvdXRkYXRlZCogd2F0Y2hlcnMgLSBudW1iZXIgb2YgZmlsZSBkZXNj
cmlwdG9ycyB0aGF0IHdlcmUgb3Blbg0KICAgID4gKyAgICBkdXJpbmcgYSBzeXN0ZW0gZ2VuZXJh
dGlvbiBjaGFuZ2UsIGFuZCB3aGljaCBoYXZlIG5vdCB5ZXQgY29uZmlybWVkDQogICAgPiArICAg
IHRoZSBuZXcgZ2VuZXJhdGlvbiBjb3VudGVyLg0KDQogICAgQnV0IHRoaXMgbnVtYmVyIGNhbiBp
bnN0YW50bHkgY2hhbmdlIGFmdGVyIGl0IGlzIHJlYWQsIHdoYXQgZ29vZCBpcyBpdD8NCiAgICBJ
dCBzaG91bGQgbmV2ZXIgYmUgcmVsaWVkIG9uLCBzbyB3aHkgaXMgdGhpcyBuZWVkZWQgYXQgYWxs
Pw0KDQogICAgV2hhdCBjYW4gdXNlcnNwYWNlIGRvIHdpdGggdGhpcyBpbmZvcm1hdGlvbj8NCg0K
VGhhdCBpcyB0cnVlLCBhIHVzZXJzcGFjZSBwcm9jZXNzIGVpdGhlciBoYXMgdG8gd2FpdCBmb3Ig
YWxsIHRvIGFkanVzdCB0byB0aGUgbmV3IGdlbmVyYXRpb24NCm9yIG5vdCBjYXJlIGFib3V0IG90
aGVyIHByb2Nlc3Nlcy4gSW50ZXJtZWRpYXRlIHByb2JpbmcgZG9lc24ndCBicmluZyByZWFsIHZh
bHVlLiBXaWxsIHJlbW92ZS4NCg0KICAgIHRoYW5rcywNCg0KICAgIGdyZWcgay1oDQoNClRoYW5r
cyBmb3IgdGhlIGZlZWRiYWNrIQ0KQWRyaWFuLg0KDQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2Vu
dGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3Ry
ZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBS
ZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

