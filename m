Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A81148EACA
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbiANNf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:35:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236727AbiANNf2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:35:28 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECrTaG030363;
        Fri, 14 Jan 2022 13:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QrAsnfqckw0ljnJBypVeB5tjWh4pgBd/ZN9KVR51zsk=;
 b=foxYfdu3Uzh2ssTcn/fYkxiK9d1XTpcRAW5QmkxvJNl4LZP4UpgpovK1EFPnIenKl6Tj
 BTqZPMx07rmodmmkP/LvPJ7844vDBd42GYLhHiZnOrQCNqINXLJdCK7MI4nJmHIcgK7V
 dSUQAotF1IEYH4zi96Cy3133eLuXtK0ea+XMfxYXv06OrDqVQhINGkqVuC4RlJ22xH69
 /0/fEo06BB+7s3mryERzgstjdGNWMKqo0FNrMX5LeVXCgZZsHzsoKoMxGA9J8JC8yJ38
 rd5L8NbennRlOmPVmhHnGkaeXJjMGJUcpQl9dsUQyOcc5tesLc1viwl7MiG6/x+tktl3 Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk9k1gs00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:35:27 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EDVJuC023412;
        Fri, 14 Jan 2022 13:35:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk9k1grya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:35:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EDWxEf018350;
        Fri, 14 Jan 2022 13:35:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3df28aek7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:35:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EDZLLD44761470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:35:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D849252052;
        Fri, 14 Jan 2022 13:35:21 +0000 (GMT)
Received: from [9.145.160.142] (unknown [9.145.160.142])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8769B5204F;
        Fri, 14 Jan 2022 13:35:21 +0000 (GMT)
Message-ID: <d09a7170-6538-fc52-15f1-42d7fc4e7c9b@linux.ibm.com>
Date:   Fri, 14 Jan 2022 14:35:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: vm: Add kvm and lpar vm
 queries
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114100245.8643-2-frankja@linux.ibm.com>
 <b468354deac3f9902f42aa2c46e762ddf208efdd.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <b468354deac3f9902f42aa2c46e762ddf208efdd.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s39YsTJYrk5AFCNLv2guzJg7R3GY_uUj
X-Proofpoint-GUID: az-V2U9i7XVmuCPkbaJxzv8rJ8NY_Xod
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_05,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8xNC8yMiAxNDoyNywgTmljbyBCb2VociB3cm90ZToNCj4gT24gRnJpLCAyMDIyLTAx
LTE0IGF0IDEwOjAyICswMDAwLCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4gVGhpcyBwYXRj
aCB3aWxsIGxpa2VseSAoaW4gcGFydHMpIGJlIHJlcGxhY2VkIGJ5IFBpZXJyZSdzIHBhdGNo
IGZyb20NCj4+IGhpcyB0b3BvbG9neSB0ZXN0IHNlcmllcy4NCj4+DQo+PiBTaWduZWQtb2Zm
LWJ5OiBKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+DQo+PiAtLS0NCj4+
ICDCoGxpYi9zMzkweC92bS5jIHwgMzkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQo+PiAgwqBsaWIvczM5MHgvdm0uaCB8IDIzICsrKysrKysrKysrKysrKysr
KysrKysrDQo+PiAgwqBzMzkweC9zdHNpLmPCoMKgIHwgMjEgKy0tLS0tLS0tLS0tLS0tLS0t
LS0tDQo+PiAgwqAzIGZpbGVzIGNoYW5nZWQsIDYzIGluc2VydGlvbnMoKyksIDIwIGRlbGV0
aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9saWIvczM5MHgvdm0uYyBiL2xpYi9zMzkw
eC92bS5jDQo+PiBpbmRleCBhNWI5Mjg2My4uMjY2YTgxYzEgMTAwNjQ0DQo+PiAtLS0gYS9s
aWIvczM5MHgvdm0uYw0KPj4gKysrIGIvbGliL3MzOTB4L3ZtLmMNCj4+IEBAIC0yNiw2ICsy
NiwxMSBAQCBib29sIHZtX2lzX3RjZyh2b2lkKQ0KPj4gIMKgwqDCoMKgwqDCoMKgwqBpZiAo
aW5pdGlhbGl6ZWQpDQo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gaXNfdGNnOw0KPj4gICANCj4+ICvCoMKgwqDCoMKgwqDCoGlmIChzdHNpX2dldF9mYygp
IDwgMykgew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGluaXRpYWxpemVk
ID0gdHJ1ZTsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZmFs
c2U7DQo+IA0KPiBNaW5vciBuaXQ6IEJ5IHNldHRpbmcgaW5pdGlhbGl6ZWQgdG8gdHJ1ZSwg
eW91IHJlbHkgb24gdGhlIHByZXZpb3VzDQo+IGluaXRpYWxpemF0aW9uIG9mIGlzX3RjZyB0
byBmYWxzZSBmb3Igc3Vic2VxdWVudCBjYWxscy4NCj4gDQo+IFlvdSBjb3VsZCBtYWtlIHRo
aXMgbW9yZSBvYnZpb3VzIGJ5IHNheWluZzoNCj4gDQo+IHJldHVybiBpc190Y2c7DQo+IA0K
DQpIYXZlIGEgbG9vayBhdCBQaWVycmUncyBwYXRjaCB3aGljaCBJIHdpbGwgYmUgcmVseWlu
ZyBvbiB3aGVuIGl0J3MgZG9uZS4gDQpBcyBJIHNhaWQgaW4gdGhlIGNvbW1pdCBtZXNzYWdl
LCB0aGlzIGlzIG9ubHkgYSBwbGFjZWhvbGRlciBmb3IgaGlzIHBhdGNoLg0K
