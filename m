Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17027447FC4
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhKHMvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:51:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236033AbhKHMvT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:51:19 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8BCeqB023167;
        Mon, 8 Nov 2021 12:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BvQHyQ+4NxbwuzlVf/NGd2GAOHhAWAXolb/HFm1xssI=;
 b=CoGdrv3pVle/ALRPAOvV9DHyviCrGyjm+JEJvCvDHgLe48vj+bGCAcaJfuoXpDO/nwI0
 26Dvaf4LUHGHC3wWIBTDWcQUwQ0nZBOQ9YjTBNd0q8/nDHos3n8VHERp+M60j4iB5m7E
 sdU6uXFy36S+s3IsWHW5V4In0Tp+1FftWLBMA/euVr4ciHZZYZ9aPjNY89FA5Q3qFJE+
 kxcBHrdMm7FVi/D0VNbgpRwpMefzq2kAkZZmz2mkbYMep5e67q7K4CiachF0JcvqTuj4
 BtZLztEjzliMwAfhSnyVxP2FDgZKJiN3Dkg0uQ+WifRWAcCxTqB1DO6V4ktmvhNIHd9l 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6qeygrma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:48:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8CU6UD025572;
        Mon, 8 Nov 2021 12:48:34 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6qeygrkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:48:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CbnTn023609;
        Mon, 8 Nov 2021 12:48:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3c5hb9x21x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:48:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CfpIp65077608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:41:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C30852059;
        Mon,  8 Nov 2021 12:48:28 +0000 (GMT)
Received: from [9.145.83.128] (unknown [9.145.83.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E9CFA5205A;
        Mon,  8 Nov 2021 12:48:27 +0000 (GMT)
Message-ID: <7e785ecc-1ddb-9357-e961-4498d1bf59fd@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:48:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     david@redhat.com, imbrenda@linux.ibm.com
References: <20211027025451.290124-1-walling@linux.ibm.com>
 <4488b572-11bf-72ff-86c0-395dfc7b3f71@linux.ibm.com>
 <28d90d6f-b481-3588-cd33-39624710b7bd@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
In-Reply-To: <28d90d6f-b481-3588-cd33-39624710b7bd@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6aoC9tvGgBVpHIecjwrkEaJ64bW29rv2
X-Proofpoint-ORIG-GUID: lSPzCiz1L1Esf9Tc_-ntxDgrVIG9cXLL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_04,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvOC8yMSAxMzowNCwgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOg0KPiANCj4g
DQo+IEFtIDA4LjExLjIxIHVtIDEyOjEyIHNjaHJpZWIgSmFub3NjaCBGcmFuazoNCj4+IE9u
IDEwLzI3LzIxIDA0OjU0LCBDb2xsaW4gV2FsbGluZyB3cm90ZToNCj4+PiBUaGUgZGlhZyAz
MTggZGF0YSBjb250YWlucyB2YWx1ZXMgdGhhdCBkZW5vdGUgaW5mb3JtYXRpb24gcmVnYXJk
aW5nIHRoZQ0KPj4+IGd1ZXN0J3MgZW52aXJvbm1lbnQuIEN1cnJlbnRseSwgaXQgaXMgdW5l
Y2Vzc2FyaWx5IGRpZmZpY3VsdCB0byBvYnNlcnZlDQo+Pj4gdGhpcyB2YWx1ZSAoZWl0aGVy
IG1hbnVhbGx5LWluc2VydGVkIGRlYnVnIHN0YXRlbWVudHMsIGdkYiBzdGVwcGluZywgbWVt
DQo+Pj4gZHVtcGluZyBldGMpLiBJdCdzIHVzZWZ1bCB0byBvYnNlcnZlIHRoaXMgaW5mb3Jt
YXRpb24gdG8gb2J0YWluIGFuDQo+Pj4gYXQtYS1nbGFuY2UgdmlldyBvZiB0aGUgZ3Vlc3Qn
cyBlbnZpcm9ubWVudCwgc28gbGV0cyBhZGQgYSBzaW1wbGUgVkNQVQ0KPj4+IGV2ZW50IHRo
YXQgcHJpbnRzIHRoZSBDUE5DIHRvIHRoZSBzMzkwZGJmIGxvZ3MuDQo+Pj4NCj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBDb2xsaW4gV2FsbGluZyA8d2FsbGluZ0BsaW51eC5pYm0uY29tPg0KPj4+
IC0tLQ0KPj4+ICDCoCBhcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMgfCAxICsNCj4+PiAgwqAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEv
YXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jIGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jDQo+
Pj4gaW5kZXggNmE2ZGQ1ZTFkYWY2Li5kYTNmZjI0ZWFiZDAgMTAwNjQ0DQo+Pj4gLS0tIGEv
YXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jDQo+Pj4gKysrIGIvYXJjaC9zMzkwL2t2bS9rdm0t
czM5MC5jDQo+Pj4gQEAgLTQyNTQsNiArNDI1NCw3IEBAIHN0YXRpYyB2b2lkIHN5bmNfcmVn
c19mbXQyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4+PiAgwqDCoMKgwqDCoCBpZiAoa3Zt
X3J1bi0+a3ZtX2RpcnR5X3JlZ3MgJiBLVk1fU1lOQ19ESUFHMzE4KSB7DQo+Pj4gIMKgwqDC
oMKgwqDCoMKgwqDCoCB2Y3B1LT5hcmNoLmRpYWczMThfaW5mby52YWwgPSBrdm1fcnVuLT5z
LnJlZ3MuZGlhZzMxODsNCj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgIHZjcHUtPmFyY2guc2ll
X2Jsb2NrLT5jcG5jID0gdmNwdS0+YXJjaC5kaWFnMzE4X2luZm8uY3BuYzsNCj4+PiArwqDC
oMKgwqDCoMKgwqAgVkNQVV9FVkVOVCh2Y3B1LCAyLCAic2V0dGluZyBjcG5jIHRvICVkIiwg
dmNwdS0+YXJjaC5kaWFnMzE4X2luZm8uY3BuYyk7DQo+Pj4gIMKgwqDCoMKgwqAgfQ0KPj4+
ICDCoMKgwqDCoMKgIC8qDQo+Pj4gIMKgwqDCoMKgwqDCoCAqIElmIHVzZXJzcGFjZSBzZXRz
IHRoZSByaWNjYiAoZS5nLiBhZnRlciBtaWdyYXRpb24pIHRvIGEgdmFsaWQgc3RhdGUsDQo+
Pj4NCj4+DQo+PiBXb24ndCB0aGF0IHR1cm4gdXAgZm9yIGV2ZXJ5IHZjcHUgYW5kIHNwYW0g
dGhlIGxvZz8NCj4gDQo+IG9ubHkgaWYgdGhlIHVzZXJzcGFjZSBhbHdheXMgc2V0cyB0aGUg
ZGlydHkgYml0ICh3aGljaCBpdCBzaG91bGQgbm90KS4NCj4gDQoNCkJ1dCB0aGF0J3MgZXhh
Y3RseSB3aGF0IGl0IGRvZXMsIG5vPw0KV2UgZG8gYSBsb29wIG92ZXIgYWxsIHZjcHVzIGFu
ZCBjYWxsIGt2bV9zMzkwX3NldF9kaWFnMzE4KCkgd2hpY2ggc2V0cyANCnRoZSBpbmZvIGlu
IGt2bV9ydW4gYW5kIHNldHMgdGhlIGRpYWczMTggYml0IGluIHRoZSBrdm1fZGlydHlfcmVn
cy4NCg0KQENvbGxpbjogQ291bGQgeW91IGNoZWNrIHRoYXQgcGxlYXNlPw0K
