Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5608E4841DC
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 13:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiADMvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 07:51:20 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:54636 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiADMvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 07:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641300680; x=1672836680;
  h=from:to:subject:date:message-id:mime-version;
  bh=KGdRo1nxxB3Xcm0nfpWcrndiAkRjh3bMpwwsNjOb3Y8=;
  b=f0DdugeWSGTw0js6fz+iSxTxfaJ7ERAPqjRmqmAPClXPvl3NW7xfWIoT
   qE7UIrNcMoP7IwNQoaXAOhec2/YKFCm0zyiJ+ZvSsOCXGVDdZPxw+TJjo
   FVttjKNqFq/t/9It2mDEG0yZeA2ieQtT4t3Xm7ixrW2J+7YKyOzsgbB0r
   g=;
X-Amazon-filename: 0001-x86-hyperv-Use-correct-macro-in-checking-SynIC-timer.patch
X-IronPort-AV: E=Sophos;i="5.88,261,1635206400"; 
   d="scan'208,223";a="52520904"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 04 Jan 2022 12:51:05 +0000
Received: from EX13D43EUB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com (Postfix) with ESMTPS id 3CBDE814F2
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 12:51:03 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB002.ant.amazon.com (10.43.166.8) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 12:51:02 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.026;
 Tue, 4 Jan 2022 12:51:02 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 1/2] x86/hyperv: Use correct macro in checking
 SynIC timer support
Thread-Topic: [kvm-unit-tests PATCH 1/2] x86/hyperv: Use correct macro in
 checking SynIC timer support
Thread-Index: AQHYAWmYsf0GtlQB8kGnOIhwRQoS4w==
Date:   Tue, 4 Jan 2022 12:51:02 +0000
Message-ID: <1641300662336.87966@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.246]
Content-Type: multipart/mixed; boundary="_002_164130066233687966amazoncom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164130066233687966amazoncom_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhpcyBjb21taXQgZml4ZXMgNjlkNGJmNzUxNjQxNTIwZjViMmQ4ZTNmMTYwYzYzYzg5NjZmY2Q4
Yi4gc3RpbWVyX3N1cHBvcnRlZCgpIHNob3VsZCB1c2UgSFZfWDY0X01TUl9TWU5USU1FUl9BVkFJ
TEFCTEUgaW5zdGVhZCBvZiBIVl9YNjRfTVNSX1NZTklDX0FWQUlMQUJMRS7igIs=

--_002_164130066233687966amazoncom_
Content-Type: text/x-patch;
	name="0001-x86-hyperv-Use-correct-macro-in-checking-SynIC-timer.patch"
Content-Description: 0001-x86-hyperv-Use-correct-macro-in-checking-SynIC-timer.patch
Content-Disposition: attachment;
	filename="0001-x86-hyperv-Use-correct-macro-in-checking-SynIC-timer.patch";
	size=969; creation-date="Tue, 04 Jan 2022 12:50:57 GMT";
	modification-date="Tue, 04 Jan 2022 12:50:57 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzZTMxZjdkMmI3YmZjOTJmZjcxMGUzMDYxYjMyMzAxZjk2ODYyYjhiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBXZWQsIDIyIERlYyAyMDIxIDE4OjIyOjI4ICswMDAwClN1YmplY3Q6IFtrdm0tdW5pdC10ZXN0
cyBQQVRDSCAxLzJdIHg4Ni9oeXBlcnY6IFVzZSBjb3JyZWN0IG1hY3JvIGluIGNoZWNraW5nCiBT
eW5JQyB0aW1lciBzdXBwb3J0CgpUaGlzIGNvbW1pdCBmaXhlcyA2OWQ0YmY3NTE2NDE1MjBmNWIy
ZDhlM2YxNjBjNjNjODk2NmZjZDhiLgpzdGltZXJfc3VwcG9ydGVkKCkgc2hvdWxkIHVzZSBIVl9Y
NjRfTVNSX1NZTlRJTUVSX0FWQUlMQUJMRSBpbnN0ZWFkIG9mCkhWX1g2NF9NU1JfU1lOSUNfQVZB
SUxBQkxFLgoKU2lnbmVkLW9mZi1ieTogTWV0aW4gS2F5YSA8bWV0aWtheWFAYW1hem9uLmNvbT4K
LS0tCiB4ODYvaHlwZXJ2LmggfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS94ODYvaHlwZXJ2LmggYi94ODYvaHlwZXJ2LmgK
aW5kZXggZTEzNTIyMS4uZjJiYjdiNCAxMDA2NDQKLS0tIGEveDg2L2h5cGVydi5oCisrKyBiL3g4
Ni9oeXBlcnYuaApAQCAtMTkwLDcgKzE5MCw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBzeW5pY19z
dXBwb3J0ZWQodm9pZCkKIAogc3RhdGljIGlubGluZSBib29sIHN0aW1lcl9zdXBwb3J0ZWQodm9p
ZCkKIHsKLSAgICByZXR1cm4gY3B1aWQoSFlQRVJWX0NQVUlEX0ZFQVRVUkVTKS5hICYgSFZfWDY0
X01TUl9TWU5JQ19BVkFJTEFCTEU7CisgICAgcmV0dXJuIGNwdWlkKEhZUEVSVl9DUFVJRF9GRUFU
VVJFUykuYSAmIEhWX1g2NF9NU1JfU1lOVElNRVJfQVZBSUxBQkxFOwogfQogCiBzdGF0aWMgaW5s
aW5lIGJvb2wgaHZfdGltZV9yZWZfY291bnRlcl9zdXBwb3J0ZWQodm9pZCkKLS0gCjIuMzIuMAoK

--_002_164130066233687966amazoncom_--
