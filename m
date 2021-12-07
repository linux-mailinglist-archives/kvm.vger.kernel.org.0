Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3206C46B6E2
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhLGJV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:21:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233794AbhLGJV7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 04:21:59 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B77GdYF021812;
        Tue, 7 Dec 2021 09:18:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wJwR0qPRphkBEbKGeEnRyEEXwyY66K6vr8D3jkbrj/U=;
 b=T1tj3LX7EocfckPOxrOpeOASuNNk2Y/T2DAaL/uiHZG4vZjA4uqpBf96E77O9k+3zRWc
 deibsbV6Gg50YnMzf6ZlVgC7yqzNoLEzJ3MDiGs/eRoj1/4b/0MwMEXQnEC/CZ+0XNyg
 IHo74qPNyEwxYPj5+G2gObHG36guHZH1AhasAWNeWQdM76ypH8+eUDu0/mB6NQ+nJnBC
 hhUAk6bzCYGBeZnFnYyOnjflCI4UgxTf4+mP2q+2roMqItDLHmEUZvR2fsUkAmV3uatv
 xRIyOJMp+bNbpVYg/iHkg5DnUikjG51d4rrlb7quvvMc4bOeqcNh/aRv4Ce7yGXdvJXk qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct334tben-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:18:24 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B794Rkq027632;
        Tue, 7 Dec 2021 09:18:23 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct334tbe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:18:23 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B798PW5025617;
        Tue, 7 Dec 2021 09:18:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3cqyy9bk9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:18:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B79IImk29360520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 09:18:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 414B7A4062;
        Tue,  7 Dec 2021 09:18:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7BD0A405B;
        Tue,  7 Dec 2021 09:18:17 +0000 (GMT)
Received: from [9.145.93.53] (unknown [9.145.93.53])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 09:18:17 +0000 (GMT)
Message-ID: <4b839336-2dcb-6506-5d2d-149a8a31a765@linux.ibm.com>
Date:   Tue, 7 Dec 2021 10:18:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] KVM: s390: Fix names of skey constants in api
 documentation
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211118102522.569660-1-scgl@linux.ibm.com>
 <6b781b76-28a9-c375-30cb-ee6764ecd7c8@linux.ibm.com>
 <fd0aa191-4b43-76a1-cb0c-7ed4298ffecb@linux.vnet.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <fd0aa191-4b43-76a1-cb0c-7ed4298ffecb@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OxLtbJV70BlPfgR4QLkqMKLHDZWQb_0-
X-Proofpoint-ORIG-GUID: PZ17YJ8c9e13h2nwFIiZ_h3mxQI4ONAf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTIvMi8yMSAxMTozMSwgSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIHdyb3RlOg0KPiBP
biAxMi8xLzIxIDA5OjQ1LCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4gT24gMTEvMTgvMjEg
MTE6MjUsIEphbmlzIFNjaG9ldHRlcmwtR2xhdXNjaCB3cm90ZToNCj4+PiBUaGUgYXJlIGRl
ZmluZWQgaW4gaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGFzDQo+Pg0KPj4gcy9UaGUvVGhl
eS8NCj4+DQo+PiBJIGNhbiBmaXggdGhhdCB1cCB3aGVuIHBpY2tpbmcgaWYgeW91IHdhbnQu
DQo+IA0KPiBUaGFua3MsIHBsZWFzZSBkby4NCj4+DQo+Pj4gS1ZNX1MzOTBfR0VUX1NLRVlT
X05PTkUgYW5kIEtWTV9TMzkwX1NLRVlTX01BWCwgYnV0IHRoZQ0KPj4+IGFwaSBkb2N1bWV0
YXRpb24gdGFsa3Mgb2YgS1ZNX1MzOTBfR0VUX0tFWVNfTk9ORSBhbmQNCj4+PiBLVk1fUzM5
MF9TS0VZU19BTExPQ19NQVggcmVzcGVjdGl2ZWx5Lg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1i
eTogSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIDxzY2dsQGxpbnV4LmlibS5jb20+DQo+Pg0K
Pj4gVGhhbmtzIGZvciBmaXhpbmcgdGhpcyB1cC4NCg0KVGhhbmtzLCBwaWNrZWQNCg0KPj4N
Cj4+IFJldmlld2VkLWJ5OiBKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+
DQo+Pg0KPj4+IC0tLQ0KPj4+ICDCoCBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3Qg
fCA2ICsrKy0tLQ0KPj4+ICDCoCAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmly
dC9rdm0vYXBpLnJzdCBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdA0KPj4+IGlu
ZGV4IGFlZWIwNzFjNzY4OC4uYjg2YzdlZGFlODg4IDEwMDY0NA0KPj4+IC0tLSBhL0RvY3Vt
ZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdA0KPj4+ICsrKyBiL0RvY3VtZW50YXRpb24vdmly
dC9rdm0vYXBpLnJzdA0KPj4+IEBAIC0zNzAxLDcgKzM3MDEsNyBAQCBLVk0gd2l0aCB0aGUg
Y3VycmVudGx5IGRlZmluZWQgc2V0IG9mIGZsYWdzLg0KPj4+ICDCoCA6QXJjaGl0ZWN0dXJl
czogczM5MA0KPj4+ICDCoCA6VHlwZTogdm0gaW9jdGwNCj4+PiAgwqAgOlBhcmFtZXRlcnM6
IHN0cnVjdCBrdm1fczM5MF9za2V5cw0KPj4+IC06UmV0dXJuczogMCBvbiBzdWNjZXNzLCBL
Vk1fUzM5MF9HRVRfS0VZU19OT05FIGlmIGd1ZXN0IGlzIG5vdCB1c2luZyBzdG9yYWdlDQo+
Pj4gKzpSZXR1cm5zOiAwIG9uIHN1Y2Nlc3MsIEtWTV9TMzkwX0dFVF9TS0VZU19OT05FIGlm
IGd1ZXN0IGlzIG5vdCB1c2luZyBzdG9yYWdlDQo+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAga2V5cywgbmVnYXRpdmUgdmFsdWUgb24gZXJyb3INCj4+PiAgwqAgwqAgVGhpcyBpb2N0
bCBpcyB1c2VkIHRvIGdldCBndWVzdCBzdG9yYWdlIGtleSB2YWx1ZXMgb24gdGhlIHMzOTAN
Cj4+PiBAQCAtMzcyMCw3ICszNzIwLDcgQEAgeW91IHdhbnQgdG8gZ2V0Lg0KPj4+ICDCoCDC
oCBUaGUgY291bnQgZmllbGQgaXMgdGhlIG51bWJlciBvZiBjb25zZWN1dGl2ZSBmcmFtZXMg
KHN0YXJ0aW5nIGZyb20gc3RhcnRfZ2ZuKQ0KPj4+ICDCoCB3aG9zZSBzdG9yYWdlIGtleXMg
dG8gZ2V0LiBUaGUgY291bnQgZmllbGQgbXVzdCBiZSBhdCBsZWFzdCAxIGFuZCB0aGUgbWF4
aW11bQ0KPj4+IC1hbGxvd2VkIHZhbHVlIGlzIGRlZmluZWQgYXMgS1ZNX1MzOTBfU0tFWVNf
QUxMT0NfTUFYLiBWYWx1ZXMgb3V0c2lkZSB0aGlzIHJhbmdlDQo+Pj4gK2FsbG93ZWQgdmFs
dWUgaXMgZGVmaW5lZCBhcyBLVk1fUzM5MF9TS0VZU19NQVguIFZhbHVlcyBvdXRzaWRlIHRo
aXMgcmFuZ2UNCj4+PiAgwqAgd2lsbCBjYXVzZSB0aGUgaW9jdGwgdG8gcmV0dXJuIC1FSU5W
QUwuDQo+Pj4gIMKgIMKgIFRoZSBza2V5ZGF0YV9hZGRyIGZpZWxkIGlzIHRoZSBhZGRyZXNz
IHRvIGEgYnVmZmVyIGxhcmdlIGVub3VnaCB0byBob2xkIGNvdW50DQo+Pj4gQEAgLTM3NDQs
NyArMzc0NCw3IEBAIHlvdSB3YW50IHRvIHNldC4NCj4+PiAgwqAgwqAgVGhlIGNvdW50IGZp
ZWxkIGlzIHRoZSBudW1iZXIgb2YgY29uc2VjdXRpdmUgZnJhbWVzIChzdGFydGluZyBmcm9t
IHN0YXJ0X2dmbikNCj4+PiAgwqAgd2hvc2Ugc3RvcmFnZSBrZXlzIHRvIGdldC4gVGhlIGNv
dW50IGZpZWxkIG11c3QgYmUgYXQgbGVhc3QgMSBhbmQgdGhlIG1heGltdW0NCj4+PiAtYWxs
b3dlZCB2YWx1ZSBpcyBkZWZpbmVkIGFzIEtWTV9TMzkwX1NLRVlTX0FMTE9DX01BWC4gVmFs
dWVzIG91dHNpZGUgdGhpcyByYW5nZQ0KPj4+ICthbGxvd2VkIHZhbHVlIGlzIGRlZmluZWQg
YXMgS1ZNX1MzOTBfU0tFWVNfTUFYLiBWYWx1ZXMgb3V0c2lkZSB0aGlzIHJhbmdlDQo+Pj4g
IMKgIHdpbGwgY2F1c2UgdGhlIGlvY3RsIHRvIHJldHVybiAtRUlOVkFMLg0KPj4+ICDCoCDC
oCBUaGUgc2tleWRhdGFfYWRkciBmaWVsZCBpcyB0aGUgYWRkcmVzcyB0byBhIGJ1ZmZlciBj
b250YWluaW5nIGNvdW50IGJ5dGVzIG9mDQo+Pj4NCj4+DQo+IA0KDQo=
