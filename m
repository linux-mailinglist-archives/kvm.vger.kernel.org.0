Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5418049847D
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 17:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbiAXQSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 11:18:09 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:24883 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbiAXQSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 11:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1643041089; x=1674577089;
  h=from:to:subject:date:message-id:mime-version;
  bh=r2Z3Zsfdj8DEGOlDs58cu2p/z0dCzZmX+2+3RizQnPk=;
  b=YRbmMrQqZfIX8JJIarz3AmYziil5ELl+1063jVJEKjO75Yiytv2MgW8s
   ac3b2J4pQbNrAIzc+ad4F4WSAvUUdgw9pemnebrwq+C1RS692DLiTOlhk
   DR+TRtcwl3kFAZ85THUWK4hy1BXnPebtIU5VYvzpmzGSAqLAJPwghMt/1
   0=;
X-Amazon-filename: 0002-x86-hyperv_clock-print-sequence-field-of-reference-T.patch
X-IronPort-AV: E=Sophos;i="5.88,311,1635206400"; 
   d="scan'208,223";a="172690911"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-d149296b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 24 Jan 2022 16:17:56 +0000
Received: from EX13D43EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-d149296b.us-west-2.amazon.com (Postfix) with ESMTPS id 4F7204165C
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 16:17:55 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB004.ant.amazon.com (10.43.166.21) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 24 Jan 2022 16:17:54 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.028;
 Mon, 24 Jan 2022 16:17:53 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 2/3] x86/hyperv_clock: print sequence field of
 reference TSC page
Thread-Topic: [kvm-unit-tests PATCH 2/3] x86/hyperv_clock: print sequence
 field of reference TSC page
Thread-Index: AQHYET3wTrnwFW962E6pXZZ9fFLWnA==
Date:   Mon, 24 Jan 2022 16:17:53 +0000
Message-ID: <1643041073871.99850@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.114]
Content-Type: multipart/mixed; boundary="_002_164304107387199850amazoncom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164304107387199850amazoncom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Having TscSequence in the log message for completeness.=0A=

--_002_164304107387199850amazoncom_
Content-Type: text/x-patch;
	name="0002-x86-hyperv_clock-print-sequence-field-of-reference-T.patch"
Content-Description: 0002-x86-hyperv_clock-print-sequence-field-of-reference-T.patch
Content-Disposition: attachment;
	filename="0002-x86-hyperv_clock-print-sequence-field-of-reference-T.patch";
	size=956; creation-date="Mon, 24 Jan 2022 16:17:50 GMT";
	modification-date="Mon, 24 Jan 2022 16:17:50 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjOWY4NWQ2OTcxNmRkNDVjOWY3NjYyZGI0NTk5ZjljYWIyNjIzZmEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBNb24sIDI0IEphbiAyMDIyIDEwOjI2OjU4ICswMDAwClN1YmplY3Q6IFtQQVRDSCAyLzNdIHg4
Ni9oeXBlcnZfY2xvY2s6IHByaW50IHNlcXVlbmNlIGZpZWxkIG9mIHJlZmVyZW5jZSBUU0MKIHBh
Z2UKCkhhdmluZyBUc2NTZXF1ZW5jZSBpbiB0aGUgbG9nIG1lc3NhZ2UgZm9yIGNvbXBsZXRlbmVz
cy4KClNpZ25lZC1vZmYtYnk6IE1ldGluIEtheWEgPG1ldGlrYXlhQGFtYXpvbi5jb20+Ci0tLQog
eDg2L2h5cGVydl9jbG9jay5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS94ODYvaHlwZXJ2X2Nsb2NrLmMgYi94ODYv
aHlwZXJ2X2Nsb2NrLmMKaW5kZXggZGNmMTAxYS4uOWMzMGZiZSAxMDA2NDQKLS0tIGEveDg2L2h5
cGVydl9jbG9jay5jCisrKyBiL3g4Ni9oeXBlcnZfY2xvY2suYwpAQCAtMTgxLDcgKzE4MSw4IEBA
IGludCBtYWluKGludCBhYywgY2hhciAqKmF2KQogCQlleGl0KDEpOwogCX0KIAotCXByaW50Zigi
c2NhbGU6ICUiIFBSSXg2NCIgb2Zmc2V0OiAlIiBQUklkNjQiXG4iLCBzaGFkb3cudHNjX3NjYWxl
LCBzaGFkb3cudHNjX29mZnNldCk7CisJcHJpbnRmKCJzZXF1ZW5jZTogJXUuIHNjYWxlOiAlIiBQ
Ukl4NjQiIG9mZnNldDogJSIgUFJJZDY0IlxuIiwKKwkgICAgICAgc2hhZG93LnRzY19zZXF1ZW5j
ZSwgc2hhZG93LnRzY19zY2FsZSwgc2hhZG93LnRzY19vZmZzZXQpOwogCXJlZjEgPSByZG1zcihI
Vl9YNjRfTVNSX1RJTUVfUkVGX0NPVU5UKTsKIAl0c2MxID0gcmR0c2MoKTsKIAl0MSA9IGh2Y2xv
Y2tfdHNjX3RvX3RpY2tzKCZzaGFkb3csIHRzYzEpOwotLSAKMi4zMi4wCgo=

--_002_164304107387199850amazoncom_--
