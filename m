Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE1C4841DD
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 13:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiADMvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 07:51:46 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:62869 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiADMvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 07:51:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641300706; x=1672836706;
  h=from:to:subject:date:message-id:mime-version;
  bh=wL78eG539woR7BG/OxEenuB8/4O5vrLP/pM7+Mv6AvE=;
  b=Ce5isTqow1ig+oH9rb9W4YRZmr6+CmvjKfN8aQMP8cx5jIhYgEPasTcC
   S36pJZUTeXQK4fAn94aBlgip7+M1YNtwLeM9pH2+BFnY1s5/LbIHwzyeM
   QhTLJs/ZHVV4rbo7CxDII6tUSvmwSd6+C4JLdZOiPg3a/oyCge3+kKJ7b
   0=;
X-Amazon-filename: 0002-x86-smptest-Fix-whitespacing-issues.patch
X-IronPort-AV: E=Sophos;i="5.88,261,1635206400"; 
   d="scan'208,223";a="166184654"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 04 Jan 2022 12:51:46 +0000
Received: from EX13D43EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com (Postfix) with ESMTPS id 3B457810F3
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 12:51:44 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB001.ant.amazon.com (10.43.166.73) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 12:51:43 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.026;
 Tue, 4 Jan 2022 12:51:44 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 2/2] x86/smptest: Fix whitespacing issues
Thread-Topic: [kvm-unit-tests PATCH 2/2] x86/smptest: Fix whitespacing issues
Thread-Index: AQHYAWnDzTqhT1IJ+0GqXxlVGcs/8g==
Date:   Tue, 4 Jan 2022 12:51:44 +0000
Message-ID: <1641300703862.58592@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.87]
Content-Type: multipart/mixed; boundary="_002_164130070386258592amazoncom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164130070386258592amazoncom_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

4oCL4oCL4oCL4oCLVGhlIGNvbnZlbnRpb24gaXMgdXNpbmcgc3BhY2VzIGluIHg4Ni9zbXB0ZXN0
LmMuIEhvd2V2ZXIsIHRhYiB3YXMgdXNlZCAgaW4gMiBwbGFjZXMuIFJlcGxhY2VkIHRoZW0gd2l0
aCBzcGFjZXMu4oCL

--_002_164130070386258592amazoncom_
Content-Type: text/x-patch;
	name="0002-x86-smptest-Fix-whitespacing-issues.patch"
Content-Description: 0002-x86-smptest-Fix-whitespacing-issues.patch
Content-Disposition: attachment;
	filename="0002-x86-smptest-Fix-whitespacing-issues.patch"; size=1120;
	creation-date="Tue, 04 Jan 2022 12:51:40 GMT";
	modification-date="Tue, 04 Jan 2022 12:51:40 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhYTM1Y2Y0MDNlZjIyOTZhZmIyMGNiZTk2Y2Y3NzE0OTVlZWJjZDk5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBXZWQsIDIyIERlYyAyMDIxIDE4OjI1OjIwICswMDAwClN1YmplY3Q6IFtrdm0tdW5pdC10ZXN0
cyBQQVRDSCAyLzJdIHg4Ni9zbXB0ZXN0OiBGaXggd2hpdGVzcGFjaW5nIGlzc3VlcwoKVGhlIGNv
bnZlbnRpb24gaXMgdXNpbmcgc3BhY2VzIGluIHg4Ni9zbXB0ZXN0LmMuIEhvd2V2ZXIsIHRhYiB3
YXMgdXNlZAppbiAyIHBsYWNlcy4gUmVwbGFjZWQgdGhlbSB3aXRoIHNwYWNlcy4KClNpZ25lZC1v
ZmYtYnk6IE1ldGluIEtheWEgPG1ldGlrYXlhQGFtYXpvbi5jb20+Ci0tLQogeDg2L3NtcHRlc3Qu
YyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS94ODYvc21wdGVzdC5jIGIveDg2L3NtcHRlc3QuYwppbmRleCAyOTg5
YWEwLi42MzkxNzU5IDEwMDY0NAotLS0gYS94ODYvc21wdGVzdC5jCisrKyBiL3g4Ni9zbXB0ZXN0
LmMKQEAgLTksNyArOSw3IEBAIHN0YXRpYyB2b2lkIGlwaV90ZXN0KHZvaWQgKmRhdGEpCiAKICAg
ICBwcmludGYoImlwaSBjYWxsZWQsIGNwdSAlZFxuIiwgbik7CiAgICAgaWYgKG4gIT0gc21wX2lk
KCkpCi0JcHJpbnRmKCJidXQgd3JvbmcgY3B1ICVkXG4iLCBzbXBfaWQoKSk7CisgICAgICAgIHBy
aW50ZigiYnV0IHdyb25nIGNwdSAlZFxuIiwgc21wX2lkKCkpOwogICAgIGVsc2UKICAgICAgICAg
bmlwaXMrKzsKIH0KQEAgLTIyLDcgKzIyLDcgQEAgaW50IG1haW4odm9pZCkKICAgICBuY3B1cyA9
IGNwdV9jb3VudCgpOwogICAgIHByaW50ZigiZm91bmQgJWQgY3B1c1xuIiwgbmNwdXMpOwogICAg
IGZvciAoaSA9IDA7IGkgPCBuY3B1czsgKytpKQotCW9uX2NwdShpLCBpcGlfdGVzdCwgKHZvaWQg
KikobG9uZylpKTsKKyAgICAgICAgb25fY3B1KGksIGlwaV90ZXN0LCAodm9pZCAqKShsb25nKWkp
OwogCiAgICAgcmVwb3J0KG5pcGlzID09IG5jcHVzLCAiSVBJIHRvIGVhY2ggQ1BVIik7CiAgICAg
cmV0dXJuIHJlcG9ydF9zdW1tYXJ5KCk7Ci0tIAoyLjMyLjAKCg==

--_002_164130070386258592amazoncom_--
