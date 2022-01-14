Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A7D48EA69
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbiANNNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:13:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231283AbiANNNI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:13:08 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EBRcQu007230;
        Fri, 14 Jan 2022 13:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uFyTfLotHXbGgVKKnVCRGwTgY5BGfjEXt0rCGw/KkmU=;
 b=UYVUcjTDl38ELngfhi1Y9JLJodutM0sSyDCvO6mjB9b/f16m6rmjYz1KHG7Iyz15vQlc
 Wh+uNYsqS+coNa3gKKgnEOe6yggkuMzUKEca0Vd/Nut4zEJxYahKt/tupwcPUHD8d4Pj
 eBkXjqCstYOq9V5jUDKx+KhTz7Akedrjr3g/JvgnPOwnketl5Ry+AMabOD14n7DuZ3Jm
 7RhHafvseo1cfqHXX8n16I2vtTyvh9SWmrn+AUDn3U3boFQyXGKR7UZurmkbnFigPDGD
 5EEjiVg+e0Z/Zjk+molOhQ8rKfPQgdXfQUEB9YnyBFrTTwbpNz1RHBsi42IxzQGcRHlO /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8at1tv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:13:07 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ECrqoL015869;
        Fri, 14 Jan 2022 13:13:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8at1tuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:13:07 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ED7U2n017949;
        Fri, 14 Jan 2022 13:13:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a3kus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:13:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EDD1h120447684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:13:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3E2552051;
        Fri, 14 Jan 2022 13:13:01 +0000 (GMT)
Received: from [9.145.160.142] (unknown [9.145.160.142])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6FB8A52052;
        Fri, 14 Jan 2022 13:13:01 +0000 (GMT)
Message-ID: <1106299d-e183-b4dc-5c71-d2b30a656c08@linux.ibm.com>
Date:   Fri, 14 Jan 2022 14:13:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31
 space
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114100245.8643-5-frankja@linux.ibm.com>
 <f840f66aa615ce167187754842268662cd466b92.camel@linux.ibm.com>
 <20220114140123.10bf0406@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220114140123.10bf0406@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QOHpawKKLGPdkT4urP5uGq_mKfhCADzq
X-Proofpoint-ORIG-GUID: gGW5Dx_zFBLWKBaB8yJUtTv-LX0D6jqO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8xNC8yMiAxNDowMSwgQ2xhdWRpbyBJbWJyZW5kYSB3cm90ZToNCj4gT24gRnJpLCAx
NCBKYW4gMjAyMiAxMzo1MDo1MiArMDEwMA0KPiBOaWNvIEJvZWhyIDxucmJAbGludXguaWJt
LmNvbT4gd3JvdGU6DQo+IA0KPj4gT24gRnJpLCAyMDIyLTAxLTE0IGF0IDEwOjAyICswMDAw
LCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4+IFRoZSBzdG9yZSBzdGF0dXMgYXQgYWRkcmVz
cyBvcmRlciB3b3JrcyB3aXRoIDMxIGJpdCBhZGRyZXNzZXMgc28NCj4+PiBsZXQncw0KPj4+
IHVzZSB0aGVtLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogSmFub3NjaCBGcmFuayA8ZnJh
bmtqYUBsaW51eC5pYm0uY29tPg0KPj4+IC0tLQ0KPj4+ICDCoHMzOTB4L3NtcC5jIHwgNCAr
Ky0tDQo+Pj4gIMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9zMzkweC9zbXAuYyBiL3MzOTB4L3NtcC5j
DQo+Pj4gaW5kZXggMzJmMTI4YjMuLmM5MWYxNzBiIDEwMDY0NA0KPj4+IC0tLSBhL3MzOTB4
L3NtcC5jDQo+Pj4gKysrIGIvczM5MHgvc21wLmMNCj4+DQo+PiBbLi4uXQ0KPj4NCj4+PiBA
QCAtMjQ0LDcgKzI0NCw3IEBAIHN0YXRpYyB2b2lkIHRlc3RfZnVuY19pbml0aWFsKHZvaWQp
DQo+Pj4gICANCj4+PiAgwqBzdGF0aWMgdm9pZCB0ZXN0X3Jlc2V0X2luaXRpYWwodm9pZCkN
Cj4+PiAgwqB7DQo+Pj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IGNwdV9zdGF0dXMgKnN0YXR1
cyA9IGFsbG9jX3BhZ2VzKDApOw0KPj4+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBjcHVfc3Rh
dHVzICpzdGF0dXMgPSBhbGxvY19wYWdlc19mbGFncygxLCBBUkVBX0RNQTMxKTsNCj4+DQo+
PiBXaHkgZG8gd2UgbmVlZCB0d28gcGFnZXMgbm93Pw0KPiANCj4gYWN0dWFsbHksIHdhaXQu
Li4uLg0KPiANCj4gICAgICAgICAgc3RydWN0IGNwdV9zdGF0dXMgKnN0YXR1cyA9IGFsbG9j
X3BhZ2VzX2ZsYWdzKDEsIEFSRUFfRE1BMzEpOw0KPiAgICAgICAgICB1aW50MzJfdCByOw0K
PiANCj4gICAgICAgICAgcmVwb3J0X3ByZWZpeF9wdXNoKCJzdG9yZSBzdGF0dXMgYXQgYWRk
cmVzcyIpOw0KPiAgICAgICAgICBtZW1zZXQoc3RhdHVzLCAwLCBQQUdFX1NJWkUgKiAyKTsN
Cj4gDQo+IHdlIHdlcmUgYWxsb2NhdGluZyBvbmUgcGFnZSwgYW5kIHVzaW5nIDIhDQo+IA0K
PiBASmFub3NjaCBkbyB3ZSBuZWVkIDEgb3IgMiBwYWdlcz8NCj4gDQoNCkhhdmUgYSBsb29r
IGF0IHRoZSBtZW1jbXAoKSBiZWxvdyB0aG9zZSBsaW5lcy4NCg0KSSB0ZXN0IGlmIHRoZSBz
dGF0dXMgcGFnZSBoYXMgY2hhbmdlZCBieSBkb2luZyBhIG1lbWNtcCBhZ2FpbnN0IHRoZSAN
CnNlY29uZCBwYWdlLg0K
