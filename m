Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AB748EA76
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbiANNSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:18:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231278AbiANNSe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:18:34 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECRhaS026755;
        Fri, 14 Jan 2022 13:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mbFHVn5ksZy1x2d50dSEvsASOH2L4aeda8m7q9mtqgI=;
 b=IoijLfT6g0L52NlrvaVx8dMVav9AEHqM119K06jzBP/vEyqOQcW2yndtAOY8oP9k9wG7
 x+kKk01vlsAn2ieDXSvLoGUFZxoJ/Vf3HOBiWFF1A1wDY1BT/aqtFq7LOg0SU57PlxRa
 hdxmsaaj3HI+jQnnzwXA2BCa3sX+pkRx6H8cpPhzfWg0Ftia7E7l5/twvQvEA3LTtWKs
 eF5v+hMWLe7cPwMT27k+4Nlm9YWXsQM09xeN6z0b9d7YaKO9vUGHfBlDlDWiatp0FKtv
 1itDuo+QqSemyOnBqizjIWsqXn2ujISxviHbTmmHo0iU5OcXixGWfRP2pL5x4hlz0gAA cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk96y0vb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:18:33 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EDGp84004128;
        Fri, 14 Jan 2022 13:18:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk96y0va9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:18:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EDD6sC025097;
        Fri, 14 Jan 2022 13:18:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3df28aefxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:18:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EDIPk318088230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:18:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D50BB52059;
        Fri, 14 Jan 2022 13:18:25 +0000 (GMT)
Received: from [9.145.160.142] (unknown [9.145.160.142])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 88D8C5204E;
        Fri, 14 Jan 2022 13:18:25 +0000 (GMT)
Message-ID: <0ecc9ae9-4def-df01-6cef-cd0ee3856aa0@linux.ibm.com>
Date:   Fri, 14 Jan 2022 14:18:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31
 space
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114100245.8643-5-frankja@linux.ibm.com>
 <f840f66aa615ce167187754842268662cd466b92.camel@linux.ibm.com>
 <20220114140123.10bf0406@p-imbrenda>
 <1106299d-e183-b4dc-5c71-d2b30a656c08@linux.ibm.com>
 <20220114141625.31587a85@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220114141625.31587a85@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d65iTBkZ1lqzxxYh9jm-g2koBDfLjlBk
X-Proofpoint-ORIG-GUID: CtmUOAyUrT-sIRZBKHrLVPCiA5lLvjad
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8xNC8yMiAxNDoxNiwgQ2xhdWRpbyBJbWJyZW5kYSB3cm90ZToNCj4gT24gRnJpLCAx
NCBKYW4gMjAyMiAxNDoxMzowMSArMDEwMA0KPiBKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxp
bnV4LmlibS5jb20+IHdyb3RlOg0KPiANCj4+IE9uIDEvMTQvMjIgMTQ6MDEsIENsYXVkaW8g
SW1icmVuZGEgd3JvdGU6DQo+Pj4gT24gRnJpLCAxNCBKYW4gMjAyMiAxMzo1MDo1MiArMDEw
MA0KPj4+IE5pY28gQm9laHIgPG5yYkBsaW51eC5pYm0uY29tPiB3cm90ZToNCj4+PiAgICAN
Cj4+Pj4gT24gRnJpLCAyMDIyLTAxLTE0IGF0IDEwOjAyICswMDAwLCBKYW5vc2NoIEZyYW5r
IHdyb3RlOg0KPj4+Pj4gVGhlIHN0b3JlIHN0YXR1cyBhdCBhZGRyZXNzIG9yZGVyIHdvcmtz
IHdpdGggMzEgYml0IGFkZHJlc3NlcyBzbw0KPj4+Pj4gbGV0J3MNCj4+Pj4+IHVzZSB0aGVt
Lg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEphbm9zY2ggRnJhbmsgPGZyYW5ramFA
bGludXguaWJtLmNvbT4NCj4+Pj4+IC0tLQ0KPj4+Pj4gICDCoHMzOTB4L3NtcC5jIHwgNCAr
Ky0tDQo+Pj4+PiAgIMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkNCj4+Pj4+DQo+Pj4+PiBkaWZmIC0tZ2l0IGEvczM5MHgvc21wLmMgYi9zMzkw
eC9zbXAuYw0KPj4+Pj4gaW5kZXggMzJmMTI4YjMuLmM5MWYxNzBiIDEwMDY0NA0KPj4+Pj4g
LS0tIGEvczM5MHgvc21wLmMNCj4+Pj4+ICsrKyBiL3MzOTB4L3NtcC5jDQo+Pj4+DQo+Pj4+
IFsuLi5dDQo+Pj4+ICAgDQo+Pj4+PiBAQCAtMjQ0LDcgKzI0NCw3IEBAIHN0YXRpYyB2b2lk
IHRlc3RfZnVuY19pbml0aWFsKHZvaWQpDQo+Pj4+PiAgICANCj4+Pj4+ICAgwqBzdGF0aWMg
dm9pZCB0ZXN0X3Jlc2V0X2luaXRpYWwodm9pZCkNCj4+Pj4+ICAgwqB7DQo+Pj4+PiAtwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgY3B1X3N0YXR1cyAqc3RhdHVzID0gYWxsb2NfcGFnZXMoMCk7
DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgY3B1X3N0YXR1cyAqc3RhdHVzID0gYWxs
b2NfcGFnZXNfZmxhZ3MoMSwgQVJFQV9ETUEzMSk7DQo+Pj4+DQo+Pj4+IFdoeSBkbyB3ZSBu
ZWVkIHR3byBwYWdlcyBub3c/DQo+Pj4NCj4+PiBhY3R1YWxseSwgd2FpdC4uLi4uDQo+Pj4N
Cj4+PiAgICAgICAgICAgc3RydWN0IGNwdV9zdGF0dXMgKnN0YXR1cyA9IGFsbG9jX3BhZ2Vz
X2ZsYWdzKDEsIEFSRUFfRE1BMzEpOw0KPj4+ICAgICAgICAgICB1aW50MzJfdCByOw0KPj4+
DQo+Pj4gICAgICAgICAgIHJlcG9ydF9wcmVmaXhfcHVzaCgic3RvcmUgc3RhdHVzIGF0IGFk
ZHJlc3MiKTsNCj4+PiAgICAgICAgICAgbWVtc2V0KHN0YXR1cywgMCwgUEFHRV9TSVpFICog
Mik7DQo+Pj4NCj4+PiB3ZSB3ZXJlIGFsbG9jYXRpbmcgb25lIHBhZ2UsIGFuZCB1c2luZyAy
IQ0KPj4+DQo+Pj4gQEphbm9zY2ggZG8gd2UgbmVlZCAxIG9yIDIgcGFnZXM/DQo+Pj4gICAg
DQo+Pg0KPj4gSGF2ZSBhIGxvb2sgYXQgdGhlIG1lbWNtcCgpIGJlbG93IHRob3NlIGxpbmVz
Lg0KPj4NCj4+IEkgdGVzdCBpZiB0aGUgc3RhdHVzIHBhZ2UgaGFzIGNoYW5nZWQgYnkgZG9p
bmcgYSBtZW1jbXAgYWdhaW5zdCB0aGUNCj4+IHNlY29uZCBwYWdlLg0KPiANCj4gc28gd2Ug
ZG8gbmVlZCAyIHBhZ2VzLCBhbmQgdXNpbmcgMSB3YXMgYSBidWcNCj4gDQoNCldlIG5lZWQg
dHdvIGZvciB0aGUgc3RvcmUgc3RhdHVzIGF0IGFkZHJlc3MgdGVzdHMgYnV0IG9ubHkgb25l
IGZvciB0aGUgDQppbml0aWFsIHJlc2V0IHRlc3QgTmljbyBpcyBwb2ludGluZyBvdXQgaGVy
ZS4NCg==
