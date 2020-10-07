Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0B5285FFA
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 15:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgJGNVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 09:21:21 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:15222 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728403AbgJGNVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 09:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602076880; x=1633612880;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dsn5CLd+0Vw0aorcskd+/snC4XU/cyn7ovNa72goMkY=;
  b=uHXoRENpDUePBY5N9KGmnqUyfkqGt9QWdxsYUJqQ3X+AHG2MGPpI6RgN
   YWE1Ww3IYERN4rTjw5J4I3HRsflhTUIGkol7tmBNEhYC9dU5dgAXMc2qD
   qoK3UdaXlKQivamfpx3WHl1fn3ZYGhVjFTgBMjVxw+HSgu/x2ljEZ7yYH
   4=;
X-IronPort-AV: E=Sophos;i="5.77,346,1596499200"; 
   d="scan'208";a="60011857"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 07 Oct 2020 13:21:07 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id DB1A2141662;
        Wed,  7 Oct 2020 13:21:04 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 13:21:04 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.146) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 13:21:02 +0000
Subject: Re: [PATCH 4/4] selftests: kvm: Test MSR exiting to userspace
To:     Aaron Lewis <aaronlewis@google.com>
CC:     <pshier@google.com>, <jmattson@google.com>, <kvm@vger.kernel.org>
References: <20201006210444.1342641-1-aaronlewis@google.com>
 <20201006210444.1342641-5-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <8e887492-1512-87bf-6406-22b6aabfb703@amazon.com>
Date:   Wed, 7 Oct 2020 15:21:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006210444.1342641-5-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.146]
X-ClientProxiedBy: EX13D07UWB003.ant.amazon.com (10.43.161.66) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNi4xMC4yMCAyMzowNCwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gQWRkIGEgc2VsZnRl
c3QgdG8gdGVzdCB0aGF0IHdoZW4gdGhlIGlvY3RsIEtWTV9YODZfU0VUX01TUl9GSUxURVIgaXMK
PiBjYWxsZWQgd2l0aCBhbiBNU1IgbGlzdCwgdGhvc2UgTVNScyBleGl0IHRvIHVzZXJzcGFjZS4K
PiAKPiBUaGlzIHRlc3QgdXNlcyAzIE1TUnMgdG8gdGVzdCB0aGlzOgo+ICAgIDEuIE1TUl9JQTMy
X1hTUywgYW4gTVNSIHRoZSBrZXJuZWwga25vd3MgYWJvdXQuCj4gICAgMi4gTVNSX0lBMzJfRkxV
U0hfQ01ELCBhbiBNU1IgdGhlIGtlcm5lbCBkb2VzIG5vdCBrbm93IGFib3V0Lgo+ICAgIDMuIE1T
Ul9OT05fRVhJU1RFTlQsIGFuIE1TUiBpbnZlbnRlZCBpbiB0aGlzIHRlc3QgZm9yIHRoZSBwdXJw
b3NlcyBvZgo+ICAgICAgIHBhc3NpbmcgYSBmYWtlIE1TUiBmcm9tIHRoZSBndWVzdCB0byB1c2Vy
c3BhY2UuICBLVk0ganVzdCBhY3RzIGFzIGEKPiAgICAgICBwYXNzIHRocm91Z2guCj4gCj4gVXNl
cnNwYWNlIGlzIGFsc28gYWJsZSB0byBpbmplY3QgYSAjR1AuICBUaGlzIGlzIGRlbW9uc3RyYXRl
ZCB3aGVuCj4gTVNSX0lBMzJfWFNTIGFuZCBNU1JfSUEzMl9GTFVTSF9DTUQgYXJlIG1pc3VzZWQg
aW4gdGhlIHRlc3QuICBXaGVuIHRoaXMKPiBoYXBwZW5zIGEgI0dQIGlzIGluaXRpYXRlZCBpbiB1
c2Vyc3BhY2UgdG8gYmUgdGhyb3duIGluIHRoZSBndWVzdCB3aGljaCBpcwo+IGhhbmRsZWQgZ3Jh
Y2VmdWxseSBieSB0aGUgZXhwZWN0aW9uIGhhbmRsaW5nIGZyYW1ld29yayBpbnRyb2R1Y2VkIGVh
cmxpZXIKCmV4Y2VwdGlvbj8KCj4gaW4gdGhpcyBzZXJpZXMuCj4gCj4gVGVzdHMgZm9yIHRoZSBn
ZW5lcmljIGluc3RydWN0aW9uIGVtdWxhdG9yIHdlcmUgYWxzbyBhZGRlZC4gIEZvciB0aGlzIHRv
Cj4gd29yayB0aGUgbW9kdWxlIHBhcmFtZXRlciBrdm0uZm9yY2VfZW11bGF0aW9uX3ByZWZpeD0x
IGhhcyB0byBiZSBlbmFibGVkLgo+IElmIGl0IGlzbid0IGVuYWJsZWQgdGhlIHRlc3RzIHdpbGwg
YmUgc2tpcHBlZC4KPiAKPiBBIHRlc3Qgd2FzIGFsc28gYWRkZWQgdG8gZW5zdXJlIHRoZSBNU1Ig
cGVybWlzc2lvbiBiaXRtYXAgaXMgYmVpbmcgc2V0Cj4gY29ycmVjdGx5IGJ5IGV4ZWN1dGluZyBy
ZWFkcyBhbmQgd3JpdGVzIG9mIE1TUl9GU19CQVNFIGFuZCBNU1JfR1NfQkFTRQo+IGluIHRoZSBn
dWVzdCB3aGlsZSBhbHRlcm5hdGluZyB3aGljaCBNU1IgdXNlcnNwYWNlIHNob3VsZCBpbnRlcmNl
cHQuICBJZgo+IHRoZSBwZXJtaXNzaW9uIGJpdG1hcCBpcyBiZWluZyBzZXQgY29ycmVjdGx5IG9u
bHkgb25lIG9mIHRoZSBNU1JzIHNob3VsZAo+IGJlIGNvbWluZyB0aHJvdWdoIGF0IGEgdGltZSwg
YW5kIHRoZSBndWVzdCBzaG91bGQgYmUgYWJsZSB0byByZWFkIGFuZAo+IHdyaXRlIHRoZSBvdGhl
ciBvbmUgZGlyZWN0bHkuCj4gCj4gU2lnbmVkLW9mZi1ieTogQWFyb24gTGV3aXMgPGFhcm9ubGV3
aXNAZ29vZ2xlLmNvbT4KClJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24u
Y29tPgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3Jh
dXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNj
aGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAy
MzcgODc5CgoK

