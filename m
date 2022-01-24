Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B184349847C
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 17:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243643AbiAXQRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 11:17:14 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:42976 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243624AbiAXQRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 11:17:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1643041033; x=1674577033;
  h=from:to:subject:date:message-id:mime-version;
  bh=GaZ4tC4h5G3LyAj9DlNfA4oBUbBzDrgxHLSV3n20KY8=;
  b=jU1LkEOBNd9U34uXcrsICzqc75flU0Q22mlcjycmO7Ybs0XmBso0L76b
   JhbK4S1gBjpieuYuDSg0mjh0zWWusPotk1CZPtZq6L+en+ubpKmv3zadr
   Ohde6VpaVrrCnD9WXaBIKD3rJieelZcvmXWaxQT7WicT86VkdkwGaxA/Y
   Y=;
X-Amazon-filename: 0001-x86-hyperv_clock-handle-non-consecutive-APIC-IDs.patch
X-IronPort-AV: E=Sophos;i="5.88,311,1635206400"; 
   d="scan'208,223";a="168103797"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-0085f2c8.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 24 Jan 2022 16:17:02 +0000
Received: from EX13D43EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-0085f2c8.us-west-2.amazon.com (Postfix) with ESMTPS id E1219419D5
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 16:17:00 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB004.ant.amazon.com (10.43.166.21) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 24 Jan 2022 16:16:59 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.028;
 Mon, 24 Jan 2022 16:16:59 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 1/3] x86/hyperv_clock: handle non-consecutive
 APIC IDs
Thread-Topic: [kvm-unit-tests PATCH 1/3] x86/hyperv_clock: handle
 non-consecutive APIC IDs
Thread-Index: AQHYET2wp1uGiM84LUyICW0MV+XmLw==
Date:   Mon, 24 Jan 2022 16:16:59 +0000
Message-ID: <1643041019466.87388@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.114]
Content-Type: multipart/mixed; boundary="_002_164304101946687388amazoncom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164304101946687388amazoncom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

smp_id() should not be used if APIC IDs are not allocated consecutively.=0A=
Fix it by using on_cpu_async() with CPU ID parameter.=0A=
=0A=
Fixes: 907ce0f78c94 ("KVM: x86: add hyperv clock test case")=

--_002_164304101946687388amazoncom_
Content-Type: text/x-patch;
	name="0001-x86-hyperv_clock-handle-non-consecutive-APIC-IDs.patch"
Content-Description: 0001-x86-hyperv_clock-handle-non-consecutive-APIC-IDs.patch
Content-Disposition: attachment;
	filename="0001-x86-hyperv_clock-handle-non-consecutive-APIC-IDs.patch";
	size=2884; creation-date="Mon, 24 Jan 2022 16:16:27 GMT";
	modification-date="Mon, 24 Jan 2022 16:16:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxNzYxNTJhYmQ1NmIyYTIyN2MxNDI5MGIzZTFkNTdmMWMzN2QzY2Q4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBNb24sIDI0IEphbiAyMDIyIDEwOjIyOjMyICswMDAwClN1YmplY3Q6IFtQQVRDSCAxLzNdIHg4
Ni9oeXBlcnZfY2xvY2s6IGhhbmRsZSBub24tY29uc2VjdXRpdmUgQVBJQyBJRHMKCnNtcF9pZCgp
IHNob3VsZCBub3QgYmUgdXNlZCBpZiBBUElDIElEcyBhcmUgbm90IGFsbG9jYXRlZCBjb25zZWN1
dGl2ZWx5LgpGaXggaXQgYnkgdXNpbmcgb25fY3B1X2FzeW5jKCkgd2l0aCBDUFUgSUQgcGFyYW1l
dGVyLgoKRml4ZXM6IDkwN2NlMGY3OGM5NCAoIktWTTogeDg2OiBhZGQgaHlwZXJ2IGNsb2NrIHRl
c3QgY2FzZSIpClNpZ25lZC1vZmYtYnk6IE1ldGluIEtheWEgPG1ldGlrYXlhQGFtYXpvbi5jb20+
Ci0tLQogeDg2L2h5cGVydl9jbG9jay5jIHwgMjMgKysrKysrKysrKysrKysrKy0tLS0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL3g4Ni9oeXBlcnZfY2xvY2suYyBiL3g4Ni9oeXBlcnZfY2xvY2suYwppbmRleCBmMWU3MjA0
Li5kY2YxMDFhIDEwMDY0NAotLS0gYS94ODYvaHlwZXJ2X2Nsb2NrLmMKKysrIGIveDg2L2h5cGVy
dl9jbG9jay5jCkBAIC02Myw3ICs2Myw3IEBAIHVpbnQ2NF90IGxvb3BzW01BWF9DUFVdOwogCiBz
dGF0aWMgdm9pZCBodl9jbG9ja190ZXN0KHZvaWQgKmRhdGEpCiB7Ci0JaW50IGkgPSBzbXBfaWQo
KTsKKwlpbnQgaSA9IChsb25nKWRhdGE7CiAJdWludDY0X3QgdCA9IHJkbXNyKEhWX1g2NF9NU1Jf
VElNRV9SRUZfQ09VTlQpOwogCXVpbnQ2NF90IGVuZCA9IHQgKyAzICogVElDS1NfUEVSX1NFQzsK
IAl1aW50NjRfdCBtc3Jfc2FtcGxlID0gdCArIFRJQ0tTX1BFUl9TRUM7CkBAIC04MCw3ICs4MCw3
IEBAIHN0YXRpYyB2b2lkIGh2X2Nsb2NrX3Rlc3Qodm9pZCAqZGF0YSkKIAkJaWYgKHQgPCBtc3Jf
c2FtcGxlKSB7CiAJCQltYXhfZGVsdGEgPSBkZWx0YSA+IG1heF9kZWx0YSA/IGRlbHRhOiBtYXhf
ZGVsdGE7CiAJCX0gZWxzZSBpZiAoZGVsdGEgPCAwIHx8IGRlbHRhID4gbWF4X2RlbHRhICogMyAv
IDIpIHsKLQkJCXByaW50Zigic3VzcGVjdGluZyBkcmlmdCBvbiBDUFUgJWQ/IGRlbHRhID0gJWQs
IGFjY2VwdGFibGUgWzAsICVkKVxuIiwgc21wX2lkKCksCisJCQlwcmludGYoInN1c3BlY3Rpbmcg
ZHJpZnQgb24gQ1BVICVkPyBkZWx0YSA9ICVkLCBhY2NlcHRhYmxlIFswLCAlZClcbiIsIGksCiAJ
CQkgICAgICAgZGVsdGEsIG1heF9kZWx0YSk7CiAJCQlva1tpXSA9IGZhbHNlOwogCQkJZ290X2Ry
aWZ0ID0gdHJ1ZTsKQEAgLTg4LDcgKzg4LDcgQEAgc3RhdGljIHZvaWQgaHZfY2xvY2tfdGVzdCh2
b2lkICpkYXRhKQogCQl9CiAKIAkJaWYgKG5vdyA8IHQgJiYgIWdvdF93YXJwKSB7Ci0JCQlwcmlu
dGYoIndhcnAgb24gQ1BVICVkIVxuIiwgc21wX2lkKCkpOworCQkJcHJpbnRmKCJ3YXJwIG9uIENQ
VSAlZCFcbiIsIGkpOwogCQkJb2tbaV0gPSBmYWxzZTsKIAkJCWdvdF93YXJwID0gdHJ1ZTsKIAkJ
CWJyZWFrOwpAQCAtOTcsNyArOTcsNyBAQCBzdGF0aWMgdm9pZCBodl9jbG9ja190ZXN0KHZvaWQg
KmRhdGEpCiAJfSB3aGlsZSh0IDwgZW5kKTsKIAogCWlmICghZ290X2RyaWZ0KQotCQlwcmludGYo
ImRlbHRhIG9uIENQVSAlZCB3YXMgJWQuLi4lZFxuIiwgc21wX2lkKCksIG1pbl9kZWx0YSwgbWF4
X2RlbHRhKTsKKwkJcHJpbnRmKCJkZWx0YSBvbiBDUFUgJWQgd2FzICVkLi4uJWRcbiIsIGksIG1p
bl9kZWx0YSwgbWF4X2RlbHRhKTsKIAliYXJyaWVyKCk7CiB9CiAKQEAgLTEwNiw3ICsxMDYsMTEg
QEAgc3RhdGljIHZvaWQgY2hlY2tfdGVzdChpbnQgbmNwdXMpCiAJaW50IGk7CiAJYm9vbCBwYXNz
OwogCi0Jb25fY3B1cyhodl9jbG9ja190ZXN0LCBOVUxMKTsKKwlmb3IgKGkgPSBuY3B1cyAtIDE7
IGkgPj0gMDsgaS0tKQorCQlvbl9jcHVfYXN5bmMoaSwgaHZfY2xvY2tfdGVzdCwgKHZvaWQgKiko
bG9uZylpKTsKKworCXdoaWxlIChjcHVzX2FjdGl2ZSgpID4gMSkKKwkJcGF1c2UoKTsKIAogCXBh
c3MgPSB0cnVlOwogCWZvciAoaSA9IG5jcHVzIC0gMTsgaSA+PSAwOyBpLS0pCkBAIC0xMTcsNiAr
MTIxLDcgQEAgc3RhdGljIHZvaWQgY2hlY2tfdGVzdChpbnQgbmNwdXMpCiAKIHN0YXRpYyB2b2lk
IGh2X3BlcmZfdGVzdCh2b2lkICpkYXRhKQogeworCWludCBpID0gKGxvbmcpZGF0YTsKIAl1aW50
NjRfdCB0ID0gaHZfY2xvY2tfcmVhZCgpOwogCXVpbnQ2NF90IGVuZCA9IHQgKyAxMDAwMDAwMDAw
IC8gMTAwOwogCXVpbnQ2NF90IGxvY2FsX2xvb3BzID0gMDsKQEAgLTEyNiw3ICsxMzEsNyBAQCBz
dGF0aWMgdm9pZCBodl9wZXJmX3Rlc3Qodm9pZCAqZGF0YSkKIAkJbG9jYWxfbG9vcHMrKzsKIAl9
IHdoaWxlKHQgPCBlbmQpOwogCi0JbG9vcHNbc21wX2lkKCldID0gbG9jYWxfbG9vcHM7CisJbG9v
cHNbaV0gPSBsb2NhbF9sb29wczsKIH0KIAogc3RhdGljIHZvaWQgcGVyZl90ZXN0KGludCBuY3B1
cykKQEAgLTEzNCw3ICsxMzksMTEgQEAgc3RhdGljIHZvaWQgcGVyZl90ZXN0KGludCBuY3B1cykK
IAlpbnQgaTsKIAl1aW50NjRfdCB0b3RhbF9sb29wczsKIAotCW9uX2NwdXMoaHZfcGVyZl90ZXN0
LCBOVUxMKTsKKwlmb3IgKGkgPSBuY3B1cyAtIDE7IGkgPj0gMDsgaS0tKQorCQlvbl9jcHVfYXN5
bmMoaSwgaHZfcGVyZl90ZXN0LCAodm9pZCAqKShsb25nKWkpOworCisJd2hpbGUgKGNwdXNfYWN0
aXZlKCkgPiAxKQorCQlwYXVzZSgpOwogCiAJdG90YWxfbG9vcHMgPSAwOwogCWZvciAoaSA9IG5j
cHVzIC0gMTsgaSA+PSAwOyBpLS0pCi0tIAoyLjMyLjAKCg==

--_002_164304101946687388amazoncom_--
