Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06320484660
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbiADREr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:04:47 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:9128 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiADREp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:04:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641315886; x=1672851886;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=hkAIrqOtrUdttAMTDQcQwQ4gvCZZPd4LTC5QQt619qc=;
  b=gRwAroUGD3RU55n+1QyLD7kLnQlHKQOjxcorVaNBWdWtt74J97HNkJUj
   k5SUrIdQBKAc/iNDiZkzhyJwjxO3KWFZ+v5f4+RUtE3hYCEVmb/z0OteI
   yCfx8JTcbqDxZnZLjFtpDGYf4jyjMYVXuKi+I4krJxNP4kMBRc31jIHw9
   w=;
X-IronPort-AV: E=Sophos;i="5.88,261,1635206400"; 
   d="scan'208";a="163082770"
Subject: Re: [kvm-unit-tests PATCH 1/2] x86/hyperv: Use correct macro in checking
 SynIC timer support
Thread-Topic: [kvm-unit-tests PATCH 1/2] x86/hyperv: Use correct macro in checking SynIC
 timer support
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 04 Jan 2022 17:04:33 +0000
Received: from EX13D43EUB004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com (Postfix) with ESMTPS id B8FFA85DD6;
        Tue,  4 Jan 2022 17:04:32 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB004.ant.amazon.com (10.43.166.21) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 17:04:31 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.026;
 Tue, 4 Jan 2022 17:04:31 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Thread-Index: AQHYAWmYsf0GtlQB8kGnOIhwRQoS46xTDqKAgAAIsiI=
Date:   Tue, 4 Jan 2022 17:04:31 +0000
Message-ID: <1641315871381.71027@amazon.com>
References: <1641300662336.87966@amazon.com>,<87wnjfpikm.fsf@redhat.com>
In-Reply-To: <87wnjfpikm.fsf@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.203]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhhbmtzLCBWaXRhbHkuIFdpbGwgc2VuZCBhbm90aGVyIHBhdGNoIGZvciBpdC4gCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KRnJvbTogVml0YWx5IEt1em5ldHNvdiA8
dmt1em5ldHNAcmVkaGF0LmNvbT4KU2VudDogMDQgSmFudWFyeSAyMDIyIDE2OjMyClRvOiBLYXlh
LCBNZXRpbgpDYzoga3ZtQHZnZXIua2VybmVsLm9yZwpTdWJqZWN0OiBSRTogW0VYVEVSTkFMXSBb
a3ZtLXVuaXQtdGVzdHMgUEFUQ0ggMS8yXSB4ODYvaHlwZXJ2OiBVc2UgY29ycmVjdCBtYWNybyBp
biBjaGVja2luZyBTeW5JQyB0aW1lciBzdXBwb3J0CgpDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdp
bmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5r
cyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBh
bmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLgoKCgoiS2F5YSwgTWV0aW4iIDxtZXRpa2F5YUBh
bWF6b24uY29tPiB3cml0ZXM6Cgo+IFRoaXMgY29tbWl0IGZpeGVzIDY5ZDRiZjc1MTY0MTUyMGY1
YjJkOGUzZjE2MGM2M2M4OTY2ZmNkOGIuIHN0aW1lcl9zdXBwb3J0ZWQoKSBzaG91bGQgdXNlIEhW
X1g2NF9NU1JfU1lOVElNRVJfQVZBSUxBQkxFIGluc3RlYWQgb2YgSFZfWDY0X01TUl9TWU5JQ19B
VkFJTEFCTEUu4oCLCj4gRnJvbSAzZTMxZjdkMmI3YmZjOTJmZjcxMGUzMDYxYjMyMzAxZjk2ODYy
YjhiIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQo+IEZyb206IE1ldGluIEtheWEgPG1ldGlrYXlh
QGFtYXpvbi5jb20+Cj4gRGF0ZTogV2VkLCAyMiBEZWMgMjAyMSAxODoyMjoyOCArMDAwMAo+IFN1
YmplY3Q6IFtrdm0tdW5pdC10ZXN0cyBQQVRDSCAxLzJdIHg4Ni9oeXBlcnY6IFVzZSBjb3JyZWN0
IG1hY3JvIGluIGNoZWNraW5nCj4gIFN5bklDIHRpbWVyIHN1cHBvcnQKPgo+IFRoaXMgY29tbWl0
IGZpeGVzIDY5ZDRiZjc1MTY0MTUyMGY1YjJkOGUzZjE2MGM2M2M4OTY2ZmNkOGIuCj4gc3RpbWVy
X3N1cHBvcnRlZCgpIHNob3VsZCB1c2UgSFZfWDY0X01TUl9TWU5USU1FUl9BVkFJTEFCTEUgaW5z
dGVhZCBvZgo+IEhWX1g2NF9NU1JfU1lOSUNfQVZBSUxBQkxFLgo+CgpGaXhlczogNjlkNGJmNyAo
Ing4NjogSHlwZXItViBTeW5JQyB0aW1lcnMgdGVzdCIpCj4gU2lnbmVkLW9mZi1ieTogTWV0aW4g
S2F5YSA8bWV0aWtheWFAYW1hem9uLmNvbT4KPiAtLS0KPiAgeDg2L2h5cGVydi5oIHwgMiArLQo+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYg
LS1naXQgYS94ODYvaHlwZXJ2LmggYi94ODYvaHlwZXJ2LmgKPiBpbmRleCBlMTM1MjIxLi5mMmJi
N2I0IDEwMDY0NAo+IC0tLSBhL3g4Ni9oeXBlcnYuaAo+ICsrKyBiL3g4Ni9oeXBlcnYuaAo+IEBA
IC0xOTAsNyArMTkwLDcgQEAgc3RhdGljIGlubGluZSBib29sIHN5bmljX3N1cHBvcnRlZCh2b2lk
KQo+Cj4gIHN0YXRpYyBpbmxpbmUgYm9vbCBzdGltZXJfc3VwcG9ydGVkKHZvaWQpCj4gIHsKPiAt
ICAgIHJldHVybiBjcHVpZChIWVBFUlZfQ1BVSURfRkVBVFVSRVMpLmEgJiBIVl9YNjRfTVNSX1NZ
TklDX0FWQUlMQUJMRTsKPiArICAgIHJldHVybiBjcHVpZChIWVBFUlZfQ1BVSURfRkVBVFVSRVMp
LmEgJiBIVl9YNjRfTVNSX1NZTlRJTUVSX0FWQUlMQUJMRTsKPiAgfQoKVW5yZWxhdGVkIHRvIHRo
ZSBjaGFuZ2UgYnV0IEknZCBzdWdnZXN0IHJlbmFtaW5nIHN0aW1lcl9zdXBwb3J0ZWQoKSB0bwpo
dl9zdGltZXJfc3VwcG9ydGVkKCkgYW5kIHN5bmljX3N1cHBvcnRlZCgpIHRvIGh2X3N5bmljX3N1
cHBvcnRlZCgpLgoKPgo+ICBzdGF0aWMgaW5saW5lIGJvb2wgaHZfdGltZV9yZWZfY291bnRlcl9z
dXBwb3J0ZWQodm9pZCkKClJldmlld2VkLWJ5OiBWaXRhbHkgS3V6bmV0c292IDx2a3V6bmV0c0By
ZWRoYXQuY29tPgoKLS0KVml0YWx5Cgo=
