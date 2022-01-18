Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1C3492146
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344437AbiARIf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:35:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343864AbiARIf4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:35:56 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I7SQMp028153;
        Tue, 18 Jan 2022 08:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EBSBoJ74KoFpyn9FoQ2/aVHt3qBVoFly50dw73gYMSY=;
 b=ODftAL7YwKYYWNEAGrewtKC0q604UHfdGqUz63PcW3xMiJs/tRFA53TOI0Wi7Rq/QjEi
 /ikiSKm8C3KH1G0Rq7jNWkFReIhXeMBN4B3zve3U06mxpOIuPnjR/LTXKEpL2AbQsMgP
 r8xbse+q45V2cHCkvBqUTUR0y51hlG3koI5M4+Rws0pd5UT6MwemoCHu/3i4KfhRVggg
 jkgHzY+FPhJYnRxrydi6P0eX58QnB3IwZONedyALOeipPZbKkeT3JT8sq4nilzEiAf+W
 sNksyHh0NxcUcycfJ2WbhYKNlpVfRjQyVgAE1JaN9x/l/un1hwhn6BrnU0cAskPSUSXn ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dns6n9d8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:35:55 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I8Du3a030293;
        Tue, 18 Jan 2022 08:35:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dns6n9d8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:35:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I8RcXl009330;
        Tue, 18 Jan 2022 08:35:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dknw922hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:35:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I8ZnTe39977368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 08:35:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72CE9AE058;
        Tue, 18 Jan 2022 08:35:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B149AE045;
        Tue, 18 Jan 2022 08:35:49 +0000 (GMT)
Received: from [9.145.64.253] (unknown [9.145.64.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 08:35:49 +0000 (GMT)
Message-ID: <08238127-2887-3da3-6fe4-8440e8275d46@linux.ibm.com>
Date:   Tue, 18 Jan 2022 09:35:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v3 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-3-pmorel@linux.ibm.com>
 <75d4a897-55dd-5140-ac8b-638fa18d2e17@linux.ibm.com>
 <e9a00d5f-98db-c68b-6cea-ecddb945d49b@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <e9a00d5f-98db-c68b-6cea-ecddb945d49b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J14olz_Bu15fmVhleYZdGnbYcZCbWSGg
X-Proofpoint-ORIG-GUID: IQHkFge69YR-uDsrTMZCoHFqz6mqz7w6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201180053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8xNy8yMiAxNTo1NywgUGllcnJlIE1vcmVsIHdyb3RlOg0KPiANCj4gDQo+IE9uIDEv
MTEvMjIgMTM6MjcsIEphbm9zY2ggRnJhbmsgd3JvdGU6DQo+PiBPbiAxLzEwLzIyIDE0OjM3
LCBQaWVycmUgTW9yZWwgd3JvdGU6DQo+Pj4gV2UgbmVlZCBpbiBzZXZlcmFsIHRlc3RzIHRv
IGNoZWNrIGlmIHRoZSBWTSB3ZSBhcmUgcnVubmluZyBpbg0KPj4+IGlzIEtWTS4NCj4+PiBM
ZXQncyBhZGQgdGhlIHRlc3QuDQo+Pj4NCj4+PiBUbyBjaGVjayB0aGUgVk0gdHlwZSB3ZSB1
c2UgdGhlIFNUU0kgMy4yLjIgaW5zdHJ1Y3Rpb24sIGxldCdzDQo+Pj4gZGVmaW5lIGl0J3Mg
cmVzcG9uc2Ugc3RydWN0dXJlIGluIGEgY2VudHJhbCBoZWFkZXIuDQo+Pj4NCj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBQaWVycmUgTW9yZWwgPHBtb3JlbEBsaW51eC5pYm0uY29tPg0KPj4+IC0t
LQ0KPj4+ICDCoCBsaWIvczM5MHgvc3RzaS5oIHwgMzIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4+PiAgwqAgbGliL3MzOTB4L3ZtLmPCoMKgIHwgMzkgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+Pj4gIMKgIGxpYi9zMzkweC92bS5o
wqDCoCB8wqAgMSArDQo+Pj4gIMKgIHMzOTB4L3N0c2kuY8KgwqDCoMKgIHwgMjMgKystLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4+PiAgwqAgNCBmaWxlcyBjaGFuZ2VkLCA3NCBpbnNlcnRp
b25zKCspLCAyMSBkZWxldGlvbnMoLSkNCj4+PiAgwqAgY3JlYXRlIG1vZGUgMTAwNjQ0IGxp
Yi9zMzkweC9zdHNpLmgNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9saWIvczM5MHgvc3RzaS5o
IGIvbGliL3MzOTB4L3N0c2kuaA0KPj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+Pj4gaW5k
ZXggMDAwMDAwMDAuLjAyY2M5NGE2DQo+Pj4gLS0tIC9kZXYvbnVsbA0KPj4+ICsrKyBiL2xp
Yi9zMzkweC9zdHNpLmgNCj4+PiBAQCAtMCwwICsxLDMyIEBADQo+Pj4gKy8qIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9yLWxhdGVyICovDQo+Pj4gKy8qDQo+Pj4gKyAq
IFN0cnVjdHVyZXMgdXNlZCB0byBTdG9yZSBTeXN0ZW0gSW5mb3JtYXRpb24NCj4+PiArICoN
Cj4+PiArICogQ29weXJpZ2h0IChjKSAyMDIxIElCTSBJbmMNCj4+PiArICovDQo+Pj4gKw0K
Pj4+ICsjaWZuZGVmIF9TMzkwWF9TVFNJX0hfDQo+Pj4gKyNkZWZpbmUgX1MzOTBYX1NUU0lf
SF8NCj4+PiArDQo+Pj4gK3N0cnVjdCBzeXNpbmZvXzNfMl8yIHsNCj4+PiArwqDCoMKgIHVp
bnQ4X3QgcmVzZXJ2ZWRbMzFdOw0KPj4+ICvCoMKgwqAgdWludDhfdCBjb3VudDsNCj4+PiAr
wqDCoMKgIHN0cnVjdCB7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIHVpbnQ4X3QgcmVzZXJ2ZWQy
WzRdOw0KPj4+ICvCoMKgwqDCoMKgwqDCoCB1aW50MTZfdCB0b3RhbF9jcHVzOw0KPj4+ICvC
oMKgwqDCoMKgwqDCoCB1aW50MTZfdCBjb25mX2NwdXM7DQo+Pj4gK8KgwqDCoMKgwqDCoMKg
IHVpbnQxNl90IHN0YW5kYnlfY3B1czsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDE2X3Qg
cmVzZXJ2ZWRfY3B1czsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDhfdCBuYW1lWzhdOw0K
Pj4+ICvCoMKgwqDCoMKgwqDCoCB1aW50MzJfdCBjYWY7DQo+Pj4gK8KgwqDCoMKgwqDCoMKg
IHVpbnQ4X3QgY3BpWzE2XTsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDhfdCByZXNlcnZl
ZDVbM107DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIHVpbnQ4X3QgZXh0X25hbWVfZW5jb2Rpbmc7
DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIHVpbnQzMl90IHJlc2VydmVkMzsNCj4+PiArwqDCoMKg
wqDCoMKgwqAgdWludDhfdCB1dWlkWzE2XTsNCj4+PiArwqDCoMKgIH0gdm1bOF07DQo+Pj4g
K8KgwqDCoCB1aW50OF90IHJlc2VydmVkNFsxNTA0XTsNCj4+PiArwqDCoMKgIHVpbnQ4X3Qg
ZXh0X25hbWVzWzhdWzI1Nl07DQo+Pj4gK307DQo+Pj4gKw0KPj4+ICsjZW5kaWbCoCAvKiBf
UzM5MFhfU1RTSV9IXyAqLw0KPj4+IGRpZmYgLS1naXQgYS9saWIvczM5MHgvdm0uYyBiL2xp
Yi9zMzkweC92bS5jDQo+Pj4gaW5kZXggYTViOTI4NjMuLjNlMTE0MDFlIDEwMDY0NA0KPj4+
IC0tLSBhL2xpYi9zMzkweC92bS5jDQo+Pj4gKysrIGIvbGliL3MzOTB4L3ZtLmMNCj4+PiBA
QCAtMTIsNiArMTIsNyBAQA0KPj4+ICDCoCAjaW5jbHVkZSA8YWxsb2NfcGFnZS5oPg0KPj4+
ICDCoCAjaW5jbHVkZSA8YXNtL2FyY2hfZGVmLmg+DQo+Pj4gIMKgICNpbmNsdWRlICJ2bS5o
Ig0KPj4+ICsjaW5jbHVkZSAic3RzaS5oIg0KPj4+ICDCoCAvKioNCj4+PiAgwqDCoCAqIERl
dGVjdCB3aGV0aGVyIHdlIGFyZSBydW5uaW5nIHdpdGggVENHIChpbnN0ZWFkIG9mIEtWTSkN
Cj4+DQo+PiBXZSBjb3VsZCBhZGQgYSBmYyA8IDMgY2hlY2sgdG8gdGhlIHZtX2lzX3RjZygp
IGZ1bmN0aW9uIGFuZCBhZGQgYQ0KPiANCj4gT0sNCj4gDQo+PiB2bV9pc19scGFyKCkgd2hp
Y2ggZG9lcyBhIHNpbXBsZSBmYyA9PTEgY2hlY2suDQo+IA0KPiBodW0sIHRoZSBkb2Mgc2F5
cyAxIGlzIGJhc2ljLCAyIGlzIGxwYXIsIDMgaXMgdm0sIHNob3VsZG4ndCB3ZQ0KPiBkbyBh
IGNoZWNrIG9uIGZjID09IDIgb3IgaGF2ZSBhIHZtX2lzX3ZtIGNoZWNraW5nIGZjIDwgMyA/
DQo+IA0KDQpSaWdodA0KSSdsbCBkbyBzb21lIHRlc3RzIG9uIHRoZSBscGFyIHN0c2kgb3V0
cHV0IGFuZCBoYXZlIGEgbG9vayB3aGF0IHdlIGdldCBiYWNrLg0KDQo+IERvIHlvdSBoYXZl
IGFuIGV4cGVyaW1lbnRhbCByZXR1cm4gb24gdGhpcz8NCg0KRU5PUEFSU0UNCg0KPiANCj4+
DQo+Pj4gQEAgLTQzLDMgKzQ0LDQxIEBAIG91dDoNCj4+PiAgwqDCoMKgwqDCoCBmcmVlX3Bh
Z2UoYnVmKTsNCj4+PiAgwqDCoMKgwqDCoCByZXR1cm4gaXNfdGNnOw0KPj4+ICDCoCB9DQo+
Pj4gKw0KPj4+ICsvKioNCj4+PiArICogRGV0ZWN0IHdoZXRoZXIgd2UgYXJlIHJ1bm5pbmcg
d2l0aCBLVk0NCj4+PiArICovDQo+Pj4gKw0KPj4+ICtib29sIHZtX2lzX2t2bSh2b2lkKQ0K
Pj4+ICt7DQo+Pj4gK8KgwqDCoCAvKiBFQkNESUMgZm9yICJLVk0vIiAqLw0KPj4+ICvCoMKg
wqAgY29uc3QgdWludDhfdCBrdm1fZWJjZGljW10gPSB7IDB4ZDIsIDB4ZTUsIDB4ZDQsIDB4
NjEgfTsNCj4+PiArwqDCoMKgIHN0YXRpYyBib29sIGluaXRpYWxpemVkOw0KPj4+ICvCoMKg
wqAgc3RhdGljIGJvb2wgaXNfa3ZtOw0KPj4+ICvCoMKgwqAgc3RydWN0IHN5c2luZm9fM18y
XzIgKnN0c2lfMzIyOw0KPj4+ICsNCj4+PiArwqDCoMKgIGlmIChpbml0aWFsaXplZCkNCj4+
PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGlzX2t2bTsNCj4+PiArDQo+Pj4gK8KgwqDCoCBp
ZiAoc3RzaV9nZXRfZmMoKSA8IDMpIHsNCj4+PiArwqDCoMKgwqDCoMKgwqAgaW5pdGlhbGl6
ZWQgPSB0cnVlOw0KPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gaXNfa3ZtOw0KPj4+ICvC
oMKgwqAgfQ0KPj4+ICsNCj4+PiArwqDCoMKgIHN0c2lfMzIyID0gYWxsb2NfcGFnZSgpOw0K
Pj4+ICvCoMKgwqAgaWYgKCFzdHNpXzMyMikNCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJu
IGZhbHNlOw0KPj4+ICsNCj4+PiArwqDCoMKgIGlmIChzdHNpKHN0c2lfMzIyLCAzLCAyLCAy
KSkNCj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7DQo+Pj4gKw0KPj4+ICvCoMKgwqAg
LyoNCj4+PiArwqDCoMKgwqAgKiBJZiB0aGUgbWFudWZhY3R1cmVyIHN0cmluZyBpcyAiS1ZN
LyIgaW4gRUJDRElDLCB0aGVuIHdlDQo+Pj4gK8KgwqDCoMKgICogYXJlIG9uIEtWTSAob3Ro
ZXJ3aXNlIHRoZSBzdHJpbmcgaXMgIklCTSIgaW4gRUJDRElDKQ0KPj4+ICvCoMKgwqDCoCAq
Lw0KPj4+ICvCoMKgwqAgaXNfa3ZtID0gIW1lbWNtcCgmc3RzaV8zMjItPnZtWzBdLmNwaSwg
a3ZtX2ViY2RpYywNCj4+PiBzaXplb2Yoa3ZtX2ViY2RpYykpOw0KPj4NCj4+IFNvIEkgaGFk
IGEgbG9vayBhdCB0aGlzIGJlZm9yZSBDaHJpc3RtYXMgYW5kIEkgdGhpbmsgaXQncyB3cm9u
Zy4NCj4+DQo+PiBRRU1VIHdpbGwgc3RpbGwgc2V0IHRoZSBjcGkgdG8gS1ZNL0xJTlVYIGlm
IHdlIGFyZSB1bmRlciB0Y2cuDQo+PiBTbyB3ZSBuZWVkIHRvIGRvIGFkZCBhICF0Y2cgY2hl
Y2sgaGVyZSBhbmQgZml4IHRoaXMgY29tbWVudC4NCj4+DQo+PiBJLmUuIHdlIGFsd2F5cyBo
YXZlIHRoZSBLVk0vTElOVVggY3BpIGJ1dCBpZiB3ZSdyZSB1bmRlciBUQ0cgdGhlDQo+PiBt
YW51ZmFjdHVyZXIgaW4gZmMgPT0gMSBpcyBRRU1VLiBJJ20gbm90IHN1cmUgaWYgdGhpcyBp
cyBpbnRlbnRpb25hbCBhbmQNCj4+IGlmIHdlIHdhbnQgdG8gZml4IHRoaXMgYXQgc29tZSBw
b2ludCBvciBub3QuDQo+IA0KPiBpbmRlZWQgSSBkaWQgbm90IGNoZWNrIHRoaXMhIQ0KPiAN
Cj4+DQo+Pj4gK8KgwqDCoCBpbml0aWFsaXplZCA9IHRydWU7DQo+Pj4gK291dDoNCj4+PiAr
wqDCoMKgIGZyZWVfcGFnZShzdHNpXzMyMik7DQo+Pj4gK8KgwqDCoCByZXR1cm4gaXNfa3Zt
Ow0KPj4+ICt9DQo+IA0KPiAuLi5zbmlwLi4uDQo+IA0KPiBUaGFua3MgZm9yIHRoZSByZXZp
ZXcsIEkgbWFrZSB0aGUgY2hhbmdlcy4NCj4gUGllcnJlDQo+IA0KDQo=
