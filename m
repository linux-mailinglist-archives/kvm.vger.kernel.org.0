Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB0E484478
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 16:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiADPYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 10:24:40 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:58015 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiADPYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 10:24:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641309881; x=1672845881;
  h=from:to:subject:date:message-id:references:in-reply-to:
   mime-version;
  bh=wwrHuyhi5BtCTrj0XjTeseNfqG4RV8hKMHcYhgRJ1aA=;
  b=bonihS7VHBvGFo1NlmYAZQyYsZv7w/MMaN4xTsVoD+43QXLQ93nHa6eK
   PE5Kc/Jt3ae8tT7yL1FIvX0S75wJi0FNuzSRSs1Yzbuoq+emHna1ZmeMr
   PLkEkCkgQbBxkhrokgObri5wyEoH04QmA0AF2apC/kckCuxUoce35DAy+
   4=;
X-Amazon-filename: 0002-x86-smptest-Fix-whitespacing-issues.patch
X-IronPort-AV: E=Sophos;i="5.88,261,1635206400"; 
   d="scan'208,223";a="163056030"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 04 Jan 2022 15:24:30 +0000
Received: from EX13D43EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com (Postfix) with ESMTPS id 615CA81457
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 15:24:29 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB001.ant.amazon.com (10.43.166.73) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 15:24:27 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.026;
 Tue, 4 Jan 2022 15:24:28 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86/smptest: Fix whitespacing issues
Thread-Topic: [kvm-unit-tests PATCH 2/2] x86/smptest: Fix whitespacing issues
Thread-Index: AQHYAWnDzTqhT1IJ+0GqXxlVGcs/8qxS+2TF
Date:   Tue, 4 Jan 2022 15:24:28 +0000
Message-ID: <1641309867821.97427@amazon.com>
References: <1641300703862.58592@amazon.com>
In-Reply-To: <1641300703862.58592@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.97]
Content-Type: multipart/mixed; boundary="_002_164130986782197427amazoncom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164130986782197427amazoncom_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhpcyBpcyB1cC10by1kYXRlIHZlcnNpb24gb2YgdGhlIHNhbWUgcGF0Y2guCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkZyb206IEtheWEsIE1ldGluClNlbnQ6IDA0
IEphbnVhcnkgMjAyMiAxMjo1MQpUbzoga3ZtQHZnZXIua2VybmVsLm9yZwpTdWJqZWN0OiBba3Zt
LXVuaXQtdGVzdHMgUEFUQ0ggMi8yXSB4ODYvc21wdGVzdDogRml4IHdoaXRlc3BhY2luZyBpc3N1
ZXMKCuKAi+KAi+KAi+KAi1RoZSBjb252ZW50aW9uIGlzIHVzaW5nIHNwYWNlcyBpbiB4ODYvc21w
dGVzdC5jLiBIb3dldmVyLCB0YWIgd2FzIHVzZWQgIGluIDIgcGxhY2VzLiBSZXBsYWNlZCB0aGVt
IHdpdGggc3BhY2VzLuKAiwo=

--_002_164130986782197427amazoncom_
Content-Type: text/x-patch;
	name="0002-x86-smptest-Fix-whitespacing-issues.patch"
Content-Description: 0002-x86-smptest-Fix-whitespacing-issues.patch
Content-Disposition: attachment;
	filename="0002-x86-smptest-Fix-whitespacing-issues.patch"; size=1130;
	creation-date="Tue, 04 Jan 2022 15:24:24 GMT";
	modification-date="Tue, 04 Jan 2022 15:24:24 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5NDMxZDEzOWNlZDZlMTRlZmM3YTExZDY0NGI1OWQ0MjU3ZTBlZDZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBXZWQsIDIyIERlYyAyMDIxIDE4OjI1OjIwICswMDAwClN1YmplY3Q6IFtrdm0tdW5pdC10ZXN0
cyBQQVRDSCAyLzJdIHg4Ni9zbXB0ZXN0OiBGaXggd2hpdGVzcGFjaW5nIGlzc3VlcwoKVGhlIGNv
bnZlbnRpb24gaXMgdXNpbmcgc3BhY2VzIGluIHg4Ni9zbXB0ZXN0LmMuIEhvd2V2ZXIsIHRhYiB3
YXMgdXNlZAppbiAyIHBsYWNlcy4gUmVwbGFjZWQgdGhlbSB3aXRoIHNwYWNlcy4KClNpZ25lZC1v
ZmYtYnk6IE1ldGluIEtheWEgPG1ldGlrYXlhQGFtYXpvbi5jb20+Ci0tLQogeDg2L3NtcHRlc3Qu
YyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS94ODYvc21wdGVzdC5jIGIveDg2L3NtcHRlc3QuYwppbmRleCBjYmI0
ZTYwLi43NWNjMzliIDEwMDY0NAotLS0gYS94ODYvc21wdGVzdC5jCisrKyBiL3g4Ni9zbXB0ZXN0
LmMKQEAgLTEwLDcgKzEwLDcgQEAgc3RhdGljIHZvaWQgaXBpX3Rlc3Qodm9pZCAqZGF0YSkKIAog
ICAgIHByaW50ZigiaXBpIGNhbGxlZCwgY3B1ICVkXG4iLCBuKTsKICAgICBpZiAoaWRfbWFwW25d
ICE9IHNtcF9pZCgpKQotCXByaW50ZigiYnV0IHdyb25nIGNwdSAlZFxuIiwgc21wX2lkKCkpOwor
ICAgICAgICBwcmludGYoImJ1dCB3cm9uZyBjcHUgJWRcbiIsIHNtcF9pZCgpKTsKICAgICBlbHNl
CiAgICAgICAgIG5pcGlzKys7CiB9CkBAIC0yMyw3ICsyMyw3IEBAIGludCBtYWluKHZvaWQpCiAg
ICAgbmNwdXMgPSBjcHVfY291bnQoKTsKICAgICBwcmludGYoImZvdW5kICVkIGNwdXNcbiIsIG5j
cHVzKTsKICAgICBmb3IgKGkgPSAwOyBpIDwgbmNwdXM7ICsraSkKLQlvbl9jcHUoaSwgaXBpX3Rl
c3QsICh2b2lkICopKGxvbmcpaSk7CisgICAgICAgIG9uX2NwdShpLCBpcGlfdGVzdCwgKHZvaWQg
KikobG9uZylpKTsKIAogICAgIHJlcG9ydChuaXBpcyA9PSBuY3B1cywgIklQSSB0byBlYWNoIENQ
VSIpOwogICAgIHJldHVybiByZXBvcnRfc3VtbWFyeSgpOwotLSAKMi4zMi4wCgo=

--_002_164130986782197427amazoncom_--
