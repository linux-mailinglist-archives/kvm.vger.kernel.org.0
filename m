Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6788E4229B6
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhJEOAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:00:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234103AbhJEN6p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:58:45 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195DVftk022947;
        Tue, 5 Oct 2021 09:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VTtlgsNmQNfVbCribX7K82dr36qHKdQGSjUKZQ6a30w=;
 b=SPM6nSC/1nBPZxkpPveEKuCAt6PG5ntXdQCfgPHu68YsWTGe7VyxJDBDyh3Vy9NnEvR+
 mzlXBIThiSmQpnSv7okDr/GWTUEmLSKmx3qdNTlyG9RO1Y/WuSljk1yYg8fNDprhyqHC
 t4u/yu1wAIuTAoPSyUDUVmJqb7esUMywiphsi44apNILZkOl3SqnB33WNvUWE1HLylaL
 hf656eaFEuSDDQ0ZdmhSc1B8SEnFsLpCaEZremV5dFRiCqijNEkXglTR25qziWNioDKw
 08pE+gnUB2sB2dAmVsm11jnOm5jBQuPb762YiduCJ1mj414ILUfD8hTkwL1pvtJyPSiU xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgqnxrt3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:56:53 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195DWVLu027089;
        Tue, 5 Oct 2021 09:56:53 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgqnxrt24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:56:53 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195Dm5h1002783;
        Tue, 5 Oct 2021 13:56:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3bef29s0wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:56:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195Dukpc40567100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:56:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9800FA4060;
        Tue,  5 Oct 2021 13:56:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33108A4066;
        Tue,  5 Oct 2021 13:56:46 +0000 (GMT)
Received: from [9.145.45.132] (unknown [9.145.45.132])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 13:56:46 +0000 (GMT)
Message-ID: <9962f5a8-2fe9-fe61-73e3-f9bdbed102f4@linux.ibm.com>
Date:   Tue, 5 Oct 2021 15:56:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: Remove assert from
 arch_def.h
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-2-scgl@linux.ibm.com>
 <0ab2acc7-47da-59fc-c959-1d61417ca181@linux.ibm.com>
 <dd2b1cd2-6d97-0d3a-8db2-f33dcc35f226@linux.vnet.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <dd2b1cd2-6d97-0d3a-8db2-f33dcc35f226@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9LVQq6fz4stGlL8iXhwY2VJxpx6rOnaV
X-Proofpoint-ORIG-GUID: 5NklmgYOOCaa73evt7QkVxlhbJe3MJcX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTAvNS8yMSAxNTo1MSwgSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIHdyb3RlOg0KPiBP
biAxMC81LzIxIDI6NTEgUE0sIEphbm9zY2ggRnJhbmsgd3JvdGU6DQo+PiBPbiAxMC81LzIx
IDExOjExLCBKYW5pcyBTY2hvZXR0ZXJsLUdsYXVzY2ggd3JvdGU6DQo+Pj4gRG8gbm90IHVz
ZSBhc3NlcnRzIGluIGFyY2hfZGVmLmggc28gaXQgY2FuIGJlIGluY2x1ZGVkIGJ5IHNuaXBw
ZXRzLg0KPj4+IFRoZSBjYWxsZXIgaW4gc3RzaS5jIGRvZXMgbm90IG5lZWQgdG8gYmUgYWRq
dXN0ZWQsIHJldHVybmluZyAtMSBjYXVzZXMNCj4+PiB0aGUgdGVzdCB0byBmYWlsLg0KPj4+
DQo+Pj4gU2lnbmVkLW9mZi1ieTogSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIDxzY2dsQGxp
bnV4LmlibS5jb20+DQo+Pg0KPj4gQSBmZXcgZGF5cyBhZ28gSSBoYWQgYSBtaW51dGUgdG8g
aW52ZXN0aWdhdGUgd2hhdCBuZWVkZWQgdG8gYmUgYWRkZWQgdG8gYmUgYWJsZSB0byBsaW5r
IHRoZSBsaWJjZmxhdC4gRm9ydHVuYXRlbHkgaXQgd2Fzbid0IGEgbG90IGFuZCBJJ2xsIHRy
eSB0byBwb3N0IGl0IHRoaXMgd2VlayBzbyB0aGlzIHBhdGNoIGNhbiBob3BlZnVsbHkgYmUg
ZHJvcHBlZC4NCj4gDQo+IE9uZSBjb3VsZCBhcmd1ZSB0aGF0IGNjIGJlaW5nICE9IDAgaXMg
cGFydCBvZiB0aGUgdGVzdCBhbmQgc28gc2hvdWxkIGdvIHRocm91Z2ggcmVwb3J0KCkgYW5k
IG5vdCBhc3NlcnQoKS4NCj4gV2hpY2ggaGFwcGVucyBuYXR1cmFsbHksIHNpbmNlIHRoZSBj
YWxsZXIgd2lsbCBsaWtlbHkgY29tcGFyZSBpdCB0byBzb21lIHBvc2l0aXZlIGV4cGVjdGVk
IHZhbHVlLg0KDQpZZXMsIEkgY2FuIGFsc28gbGl2ZSB3aXRoIHRoYXQgaWYgeW91IGNoYW5n
ZSB0aGUgY29tbWl0IG1lc3NhZ2UgdGhlbiA6KQ0KDQo+Pg0KPj4+IC0tLQ0KPj4+ICDCoCBs
aWIvczM5MHgvYXNtL2FyY2hfZGVmLmggfCA1ICsrKy0tDQo+Pj4gIMKgIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0t
Z2l0IGEvbGliL3MzOTB4L2FzbS9hcmNoX2RlZi5oIGIvbGliL3MzOTB4L2FzbS9hcmNoX2Rl
Zi5oDQo+Pj4gaW5kZXggMzAyZWYxZi4uNDE2N2UyYiAxMDA2NDQNCj4+PiAtLS0gYS9saWIv
czM5MHgvYXNtL2FyY2hfZGVmLmgNCj4+PiArKysgYi9saWIvczM5MHgvYXNtL2FyY2hfZGVm
LmgNCj4+PiBAQCAtMzM0LDcgKzMzNCw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IHN0c2kodm9p
ZCAqYWRkciwgaW50IGZjLCBpbnQgc2VsMSwgaW50IHNlbDIpDQo+Pj4gIMKgwqDCoMKgwqAg
cmV0dXJuIGNjOw0KPj4+ICDCoCB9DQo+Pj4gIMKgIC1zdGF0aWMgaW5saW5lIHVuc2lnbmVk
IGxvbmcgc3RzaV9nZXRfZmModm9pZCkNCj4+PiArc3RhdGljIGlubGluZSBpbnQgc3RzaV9n
ZXRfZmModm9pZCkNCj4+PiAgwqAgew0KPj4+ICDCoMKgwqDCoMKgIHJlZ2lzdGVyIHVuc2ln
bmVkIGxvbmcgcjAgYXNtKCIwIikgPSAwOw0KPj4+ICDCoMKgwqDCoMKgIHJlZ2lzdGVyIHVu
c2lnbmVkIGxvbmcgcjEgYXNtKCIxIikgPSAwOw0KPj4+IEBAIC0zNDYsNyArMzQ2LDggQEAg
c3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIHN0c2lfZ2V0X2ZjKHZvaWQpDQo+Pj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgOiAiK2QiIChyMCksIFtjY10gIj1kIiAoY2Mp
DQo+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgOiAiZCIgKHIxKQ0KPj4+ICDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDogImNjIiwgIm1lbW9yeSIpOw0KPj4+IC3C
oMKgwqAgYXNzZXJ0KCFjYyk7DQo+Pj4gK8KgwqDCoCBpZiAoY2MgIT0gMCkNCj4+PiArwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIC0xOw0KPj4+ICDCoMKgwqDCoMKgIHJldHVybiByMCA+PiAy
ODsNCj4+PiAgwqAgfQ0KPj4+ICAgDQo+Pg0KPiANCg0K
