Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FD44BBA97
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 15:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236029AbiBRO2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 09:28:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiBRO2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 09:28:43 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4625424F31;
        Fri, 18 Feb 2022 06:28:26 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IE9omQ007940;
        Fri, 18 Feb 2022 14:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Z8dNbVExJb8zpq6cyPgkrsfOTk73ZVL7Je36KLvKvdM=;
 b=aJ7Gy9vLGnti+iJnRS6S1QoHHIclkNXfRKBwQ0dif08LWZaxifdJh27wLIJ+dbE77DCH
 866UOssIfNFhSebD09c/cR7rGjqK17acJpyvc0EmvjBLCXNBlU+SLwqT9kBxY2taSKcd
 vuj7QDosqB8Nko5RWMlgvYiSd+oSDnB937Qy0XrVlm1wHlljBHq7Z0efF3XQqYmhry9t
 LfQ4o+3U8F3n1PFm60C6J0uON4D4CbDfnlM6dODhE/oSR3kiY6z1rbfT57Gqp6sK6Onf
 Aaz4q/3DTS8ppiNalWl6QvKk4roJGHsZfLAVQPJmIouhG89HodEzXoIN45CUWe82Pu6p qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaat8bgcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 14:28:25 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21IEC02J013616;
        Fri, 18 Feb 2022 14:28:25 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaat8bgc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 14:28:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21IESL8t028197;
        Fri, 18 Feb 2022 14:28:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3e64har2m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 14:28:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21IESJp844958048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 14:28:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6011411C050;
        Fri, 18 Feb 2022 14:28:19 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B739E11C04A;
        Fri, 18 Feb 2022 14:28:18 +0000 (GMT)
Received: from [9.145.173.190] (unknown [9.145.173.190])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Feb 2022 14:28:18 +0000 (GMT)
Message-ID: <b9828696-f5d4-dd72-9b0e-a27b1480b799@linux.ibm.com>
Date:   Fri, 18 Feb 2022 15:28:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com
References: <20220217095923.114489-1-pmorel@linux.ibm.com>
 <20220217095923.114489-2-pmorel@linux.ibm.com>
 <f0bf737abf480d6d16af6e5335bb195061f3d076.camel@linux.ibm.com>
 <97af6268-ff7a-cfb6-5ea4-217b5162cfe7@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v7 1/1] s390x: KVM: guest support for topology function
In-Reply-To: <97af6268-ff7a-cfb6-5ea4-217b5162cfe7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Zipx9pmGXkX7wC_a8e5MLzjGY-3jwv2q
X-Proofpoint-GUID: uZxLUop_QTzjpMZYElXB8rDdjt5nz8zi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_05,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMi8xOC8yMiAxNDoxMywgUGllcnJlIE1vcmVsIHdyb3RlOg0KPiANCj4gDQo+IE9uIDIv
MTcvMjIgMTg6MTcsIE5pY28gQm9laHIgd3JvdGU6DQo+PiBPbiBUaHUsIDIwMjItMDItMTcg
YXQgMTA6NTkgKzAxMDAsIFBpZXJyZSBNb3JlbCB3cm90ZToNCj4+IFsuLi5dDQo+Pj4gZGlm
ZiAtLWdpdCBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYyBiL2FyY2gvczM5MC9rdm0va3Zt
LXMzOTAuYw0KPj4+IGluZGV4IDIyOTZiMWZmMWUwMi4uYWY3ZWE4NDg4ZmEyIDEwMDY0NA0K
Pj4+IC0tLSBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+ICsrKyBiL2FyY2gvczM5
MC9rdm0va3ZtLXMzOTAuYw0KPj4gWy4uLl0NCg0KV2h5IGlzIHRoZXJlIG5vIGludGVyZmFj
ZSB0byBjbGVhciB0aGUgU0NBX1VUSUxJVFlfTVRDUiBvbiBhIHN1YnN5c3RlbSANCnJlc2V0
Pw0KDQoNCj4+PiAgICANCj4+PiAtdm9pZCBrdm1fYXJjaF92Y3B1X2xvYWQoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBpbnQgY3B1KQ0KPj4+ICsvKioNCj4+PiArICoga3ZtX3MzOTBfdmNw
dV9zZXRfbXRjcg0KPj4+ICsgKiBAdmNwOiB0aGUgdmlydHVhbCBDUFUNCj4+PiArICoNCj4+
PiArICogSXMgb25seSByZWxldmFudCBpZiB0aGUgdG9wb2xvZ3kgZmFjaWxpdHkgaXMgcHJl
c2VudC4NCj4+PiArICoNCj4+PiArICogVXBkYXRlcyB0aGUgTXVsdGlwcm9jZXNzb3IgVG9w
b2xvZ3ktQ2hhbmdlLVJlcG9ydCB0byBzaWduYWwNCj4+PiArICogdGhlIGd1ZXN0IHdpdGgg
YSB0b3BvbG9neSBjaGFuZ2UuDQo+Pj4gKyAqLw0KPj4+ICtzdGF0aWMgdm9pZCBrdm1fczM5
MF92Y3B1X3NldF9tdGNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4+PiAgIMKgew0KPj4+
ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBlc2NhX2Jsb2NrICplc2NhID0gdmNwdS0+a3ZtLT5h
cmNoLnNjYTsNCj4+DQo+PiB1dGlsaXR5IGlzIGF0IHRoZSBzYW1lIG9mZnNldCBmb3IgdGhl
IGJzY2EgYW5kIHRoZSBlc2NhLCBzdGlsbA0KPj4gd29uZGVyaW5nIHdoZXRoZXIgaXQgaXMg
YSBnb29kIGlkZWEgdG8gYXNzdW1lIGVzY2EgaGVyZS4uLg0KPiANCj4gV2UgY2FuIHRha2Ug
YnNjYSB0byBiZSBjb2hlcmVudCB3aXRoIHRoZSBpbmNsdWRlIGZpbGUgd2hlcmUgd2UgZGVm
aW5lDQo+IEVTQ0FfVVRJTElUWV9NVENSIGluc2lkZSB0aGUgYnNjYS4NCj4gQW5kIHdlIGNh
biByZW5hbWUgdGhlIGRlZmluZSB0byBTQ0FfVVRJTElUWV9NVENSIGFzIGl0IGlzIGNvbW1v
biBmb3INCj4gYm90aCBCU0NBIGFuZCBFU0NBIHRoZSAoRSkgaXMgdG9vIG11Y2guDQoNClll
cyBhbmQgbWF5YmUgYWRkIGEgY29tbWVudCB0aGF0IGl0J3MgYXQgdGhlIHNhbWUgb2Zmc2V0
IGZvciBlc2NhIHNvIA0KdGhlcmUgd29uJ3QgY29tZSB1cCBmdXJ0aGVyIHF1ZXN0aW9ucyBp
biB0aGUgZnV0dXJlLg0KDQo+IA0KPj4NCj4+IFsuLi5dDQo+Pj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvczM5MC9rdm0va3ZtLXMzOTAuaCBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuaA0KPj4+
IGluZGV4IDA5ODgzMWU4MTVlNi4uYWYwNGZmYmZkNTg3IDEwMDY0NA0KPj4+IC0tLSBhL2Fy
Y2gvczM5MC9rdm0va3ZtLXMzOTAuaA0KPj4+ICsrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMz
OTAuaA0KPj4+IEBAIC01MDMsNCArNTAzLDI5IEBAIHZvaWQga3ZtX3MzOTBfdmNwdV9jcnlw
dG9fcmVzZXRfYWxsKHN0cnVjdCBrdm0NCj4+PiAqa3ZtKTsNCj4+PiAgIMKgICovDQo+Pj4g
ICDCoGV4dGVybiB1bnNpZ25lZCBpbnQgZGlhZzljX2ZvcndhcmRpbmdfaHo7DQo+Pj4gICAg
DQo+Pj4gKyNkZWZpbmUgUzM5MF9LVk1fVE9QT0xPR1lfTkVXX0NQVSAtMQ0KPj4+ICsvKioN
Cj4+PiArICoga3ZtX3MzOTBfdG9wb2xvZ3lfY2hhbmdlZA0KPj4+ICsgKiBAdmNwdTogdGhl
IHZpcnR1YWwgQ1BVDQo+Pj4gKyAqDQo+Pj4gKyAqIElmIHRoZSB0b3BvbG9neSBmYWNpbGl0
eSBpcyBwcmVzZW50LCBjaGVja3MgaWYgdGhlIENQVSB0b3Bsb2d5DQo+Pj4gKyAqIHZpZXdl
ZCBieSB0aGUgZ3Vlc3QgY2hhbmdlZCBkdWUgdG8gbG9hZCBiYWxhbmNpbmcgb3IgQ1BVIGhv
dHBsdWcuDQo+Pj4gKyAqLw0KPj4+ICtzdGF0aWMgaW5saW5lIGJvb2wga3ZtX3MzOTBfdG9w
b2xvZ3lfY2hhbmdlZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+Pj4gK3sNCj4+PiArwqDC
oMKgwqDCoMKgwqBpZiAoIXRlc3Rfa3ZtX2ZhY2lsaXR5KHZjcHUtPmt2bSwgMTEpKQ0KPj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZmFsc2U7DQo+Pj4gKw0K
Pj4+ICvCoMKgwqDCoMKgwqDCoC8qIEEgbmV3IHZDUFUgaGFzIGJlZW4gaG90cGx1Z2dlZCAq
Lw0KPj4+ICvCoMKgwqDCoMKgwqDCoGlmICh2Y3B1LT5hcmNoLnByZXZfY3B1ID09IFMzOTBf
S1ZNX1RPUE9MT0dZX05FV19DUFUpDQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiB0cnVlOw0KPj4+ICsNCj4+PiArwqDCoMKgwqDCoMKgwqAvKiBUaGUgcmVh
bCBDUFUgYmFja2luZyB1cCB0aGUgdkNQVSBtb3ZlZCB0byBhbm90aGVyIHNvY2tldA0KPj4+
ICovDQo+Pj4gK8KgwqDCoMKgwqDCoMKgaWYgKHRvcG9sb2d5X3BoeXNpY2FsX3BhY2thZ2Vf
aWQodmNwdS0+Y3B1KSAhPQ0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCB0b3BvbG9neV9w
aHlzaWNhbF9wYWNrYWdlX2lkKHZjcHUtPmFyY2gucHJldl9jcHUpKQ0KPj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gdHJ1ZTsNCj4+DQo+PiBXaHkgaXMgaXQg
T0sgdG8gbG9vayBqdXN0IGF0IHRoZSBwaHlzaWNhbCBwYWNrYWdlIElEIGhlcmU/IFdoYXQg
aWYgdGhlDQo+PiB2Y3B1IGZvciBleGFtcGxlIG1vdmVzIHRvIGEgZGlmZmVyZW50IGJvb2ss
IHdoaWNoIGhhcyBhIGNvcmUgd2l0aCB0aGUNCj4+IHNhbWUgcGh5c2ljYWwgcGFja2FnZSBJ
RD8NCg0KSSdsbCBuZWVkIHRvIGxvb2sgdXAgc3RzaSAxNSogb3V0cHV0IHRvIHVuZGVyc3Rh
bmQgdGhpcy4NCkJ1dCB0aGUgYXJjaGl0ZWN0dXJlIHN0YXRlcyB0aGF0IGFueSBjaGFuZ2Ug
dG8gdGhlIHN0c2kgMTUgb3V0cHV0IHNldHMgDQp0aGUgY2hhbmdlIGJpdCBzbyBJJ2QgZ3Vl
c3MgTmljbyBpcyBjb3JyZWN0Lg0KDQo+Pg0KPiANCj4gWW91IGFyZSByaWdodCwgd2Ugc2hv
dWxkIGxvb2sgYXQgdGhlIGRyYXdlciBhbmQgYm9vayBpZCB0b28uDQo+IFNvbWV0aGluZyBs
aWtlIHRoYXQgSSB0aGluazoNCj4gDQo+ICAgICAgICAgICBpZiAoKHRvcG9sb2d5X3BoeXNp
Y2FsX3BhY2thZ2VfaWQodmNwdS0+Y3B1KSAhPQ0KPiAgICAgICAgICAgICAgICB0b3BvbG9n
eV9waHlzaWNhbF9wYWNrYWdlX2lkKHZjcHUtPmFyY2gucHJldl9jcHUpKSB8fA0KPiAgICAg
ICAgICAgICAgICh0b3BvbG9neV9ib29rX2lkKHZjcHUtPmNwdSkgIT0NCj4gICAgICAgICAg
ICAgICAgdG9wb2xvZ3lfYm9va19pZCh2Y3B1LT5hcmNoLnByZXZfY3B1KSkgfHwNCj4gICAg
ICAgICAgICAgICAodG9wb2xvZ3lfZHJhd2VyX2lkKHZjcHUtPmNwdSkgIT0NCj4gICAgICAg
ICAgICAgICAgdG9wb2xvZ3lfZHJhd2VyX2lkKHZjcHUtPmFyY2gucHJldl9jcHUpKSkNCj4g
ICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQo+IA0KPiANCj4gVGhhbmtzLA0KPiBy
ZWdhcmRzLA0KPiBQaWVycmUNCg0K
