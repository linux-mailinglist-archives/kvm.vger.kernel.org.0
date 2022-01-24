Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E519249847F
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 17:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243628AbiAXQTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 11:19:21 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:43732 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiAXQTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 11:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1643041161; x=1674577161;
  h=from:to:subject:date:message-id:mime-version;
  bh=tCXNax2HsvkXxfOWL7gzKVoo2AmTKJK5r6MSB0mhvOM=;
  b=tAY2qQiPNRnoqMJ+Sec/+WeLYPVkpSg7gLDOoG9twxEpUz5hmiTLMeFl
   hYRh+9m8wVgaU8Xn94qtHgEkOiXVQ/kAFq9VCrksFRM5hw3Qm/BVNGf+V
   nA1jWrbuDXzCOZ7kGboRhvnJ8qdOVUJe19Cvkduoi01gIylX7i2TS407X
   A=;
X-Amazon-filename: 0003-x86-ioapic-use-APIC-ID-map-instead-of-hard-coded-CPU.patch
X-IronPort-AV: E=Sophos;i="5.88,311,1635206400"; 
   d="scan'208,223";a="171817958"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 24 Jan 2022 16:19:06 +0000
Received: from EX13D43EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com (Postfix) with ESMTPS id E255E812B8
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 16:19:04 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB001.ant.amazon.com (10.43.166.73) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 24 Jan 2022 16:19:03 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.028;
 Mon, 24 Jan 2022 16:19:03 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 3/3] x86/ioapic: use APIC ID map instead of
 hard-coded CPU index
Thread-Topic: [kvm-unit-tests PATCH 3/3] x86/ioapic: use APIC ID map instead
 of hard-coded CPU index
Thread-Index: AQHYET4WgSfc5k573EGpVyuZt9r9pQ==
Date:   Mon, 24 Jan 2022 16:19:03 +0000
Message-ID: <1643041143544.37758@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.114]
Content-Type: multipart/mixed; boundary="_002_164304114354437758amazoncom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164304114354437758amazoncom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

If APIC IDs are not sequential (e.g., 0, 1, 2, 3), then hard-coding the=0A=
CPU indexes will break sending IRQs to correct CPUs.=0A=
=0A=
Fixes: b2a1ee7ea179 ("x86: ioapic: Test physical and logical destination mo=
de")=

--_002_164304114354437758amazoncom_
Content-Type: text/x-patch;
	name="0003-x86-ioapic-use-APIC-ID-map-instead-of-hard-coded-CPU.patch"
Content-Description: 0003-x86-ioapic-use-APIC-ID-map-instead-of-hard-coded-CPU.patch
Content-Disposition: attachment;
	filename="0003-x86-ioapic-use-APIC-ID-map-instead-of-hard-coded-CPU.patch";
	size=1396; creation-date="Mon, 24 Jan 2022 16:19:00 GMT";
	modification-date="Mon, 24 Jan 2022 16:19:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjNWMyM2M4NzYxZGI5OTBmYTI1ZjVhZGI0YzEzYTZjNzYwZTRjMGY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBNb24sIDI0IEphbiAyMDIyIDExOjM4OjM4ICswMDAwClN1YmplY3Q6IFtQQVRDSCAzLzNdIHg4
Ni9pb2FwaWM6IHVzZSBBUElDIElEIG1hcCBpbnN0ZWFkIG9mIGhhcmQtY29kZWQgQ1BVCiBpbmRl
eAoKSWYgQVBJQyBJRHMgYXJlIG5vdCBzZXF1ZW50aWFsIChlLmcuLCAwLCAxLCAyLCAzKSwgdGhl
biBoYXJkLWNvZGluZyB0aGUKQ1BVIGluZGV4ZXMgd2lsbCBicmVhayBzZW5kaW5nIElSUXMgdG8g
Y29ycmVjdCBDUFVzLgoKRml4ZXM6IGIyYTFlZTdlYTE3OSAoIng4NjogaW9hcGljOiBUZXN0IHBo
eXNpY2FsIGFuZCBsb2dpY2FsIGRlc3RpbmF0aW9uIG1vZGUiKQpTaWduZWQtb2ZmLWJ5OiBNZXRp
biBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgotLS0KIHg4Ni9pb2FwaWMuYyB8IDcgKysrKyst
LQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS94ODYvaW9hcGljLmMgYi94ODYvaW9hcGljLmMKaW5kZXggMGFkZjMyMy4uMGQzN2Iz
NyAxMDA2NDQKLS0tIGEveDg2L2lvYXBpYy5jCisrKyBiL3g4Ni9pb2FwaWMuYwpAQCAtNDIzLDcg
KzQyMyw3IEBAIHN0YXRpYyB2b2lkIHRlc3RfaW9hcGljX3BoeXNpY2FsX2Rlc3RpbmF0aW9uX21v
ZGUodm9pZCkKIAkJLnZlY3RvciA9IDB4ODUsCiAJCS5kZWxpdmVyeV9tb2RlID0gMCwKIAkJLmRl
c3RfbW9kZSA9IDAsCi0JCS5kZXN0X2lkID0gMHgxLAorCQkuZGVzdF9pZCA9IGlkX21hcFsxXSwK
IAkJLnRyaWdfbW9kZSA9IFRSSUdHRVJfTEVWRUwsCiAJfTsKIAloYW5kbGVfaXJxKDB4ODUsIGlv
YXBpY19pc3JfODUpOwpAQCAtNDUxLDExICs0NTEsMTQgQEAgc3RhdGljIHZvaWQgdGVzdF9pb2Fw
aWNfbG9naWNhbF9kZXN0aW5hdGlvbl9tb2RlKHZvaWQpCiB7CiAJLyogTnVtYmVyIG9mIHZjcHVz
IHdoaWNoIGFyZSBjb25maWd1cmVkL3NldCBpbiBkZXN0X2lkICovCiAJaW50IG5yX3ZjcHVzID0g
MzsKKwl1aW50OF90IGRlc3RfaWQgPSAoMVUgPDwgaWRfbWFwWzBdKSB8CisJCQkJCSAgKDFVIDw8
IGlkX21hcFsyXSkgfAorCQkJCQkgICgxVSA8PCBpZF9tYXBbM10pOwogCWlvYXBpY19yZWRpcl9l
bnRyeV90IGUgPSB7CiAJCS52ZWN0b3IgPSAweDg2LAogCQkuZGVsaXZlcnlfbW9kZSA9IDAsCiAJ
CS5kZXN0X21vZGUgPSAxLAotCQkuZGVzdF9pZCA9IDB4ZCwKKwkJLmRlc3RfaWQgPSBkZXN0X2lk
LAogCQkudHJpZ19tb2RlID0gVFJJR0dFUl9MRVZFTCwKIAl9OwogCWhhbmRsZV9pcnEoMHg4Niwg
aW9hcGljX2lzcl84Nik7Ci0tIAoyLjMyLjAKCg==

--_002_164304114354437758amazoncom_--
