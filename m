Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC8C48EA5C
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiANNHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:07:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231283AbiANNHN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:07:13 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EBNx5m013382;
        Fri, 14 Jan 2022 13:07:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yHDvSZZ2+cnBhHUPru3bAJ6lkG/WZViVLgxOo9z7t30=;
 b=FuGFLCk3Ls9mCBQd3cTw8m0r3ESKkEUwJ3JaIGDfKPgtgmsR+aXlnHpo8+U6RN0LmIgk
 5WTzCSR0xWMWONMEaPDNzXdMHu6zdXW4MHL/URq8RfNtMh55/Ke79hAlFKyVb6IeXsVq
 Y19nh2pO7acFoUC7+tATOyLNiYhR9EL6c5t0el12b7nR+l6zxqf7Ggl7axxMR0npeg2z
 W5bkOHwbeAJozYTX2vVxyhgxPzhIYx3eLxR9ibiRkfS93dyJyj3uMkHhjiXzBTN2dMtS
 wh+/0ZauVW2wGvpLaiwjy193uGNd4FWumGwlHeqC72mY8VacIgBCCGWy20fqzZnaP/YZ MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk8911qwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:07:13 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ED0DZ7006843;
        Fri, 14 Jan 2022 13:07:12 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk8911qw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:07:12 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ECwMUl026470;
        Fri, 14 Jan 2022 13:07:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3df1vkbnx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:07:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ED77vx32375054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:07:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91FCC5204F;
        Fri, 14 Jan 2022 13:07:07 +0000 (GMT)
Received: from [9.145.160.142] (unknown [9.145.160.142])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3970F52050;
        Fri, 14 Jan 2022 13:07:07 +0000 (GMT)
Message-ID: <95395aff-a7ba-217c-2e44-f9bcc14a2823@linux.ibm.com>
Date:   Fri, 14 Jan 2022 14:07:06 +0100
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
 <20220114135712.6473723a@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220114135712.6473723a@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qY6Yg1cKft7UF-b2MGHdYWmdSvCbxBaq
X-Proofpoint-GUID: BOxSrM0tAeTaxLPFExxabvtFAjYmMkrT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8xNC8yMiAxMzo1NywgQ2xhdWRpbyBJbWJyZW5kYSB3cm90ZToNCj4gT24gRnJpLCAx
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
PiBXaHkgZG8gd2UgbmVlZCB0d28gcGFnZXMgbm93Pw0KPiANCj4gb2gsIGdvb2QgY2F0Y2gN
Cg0KSW5kZWVkDQoNCj4gDQo+IHRoZSBuZXh0IHBhdGNoIGhhcyB0aGUgc2FtZSBpc3N1ZQ0K
PiANCj4gSSBjYW4gZml4IHRoZW0gdXAgd2hlbiBJIHF1ZXVlIHRoZW0NCj4gDQoNClByb2Jh
Ymx5IGJlY2F1c2UgSSBjb3BpZWQgdGhhdCBsaW5lIGZyb20gc29tZXdoZXJlIDotKQ0KWWVh
aCwgeW91IGNhbiBmaXggdGhhdCB1cCBpZiB5b3Ugd2FudC4NCg==
