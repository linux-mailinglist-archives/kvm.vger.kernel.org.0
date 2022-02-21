Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315DE4BD822
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiBUILF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:11:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiBUILC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:11:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40AE1115A;
        Mon, 21 Feb 2022 00:10:39 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L6HJRb030833;
        Mon, 21 Feb 2022 08:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=e9FFJ0KwyjxAG2E12quQan+xn2YJPzNdsd1aNQsCpP8=;
 b=pZ8PLoBx/IohErESqmAHI/R59znzdnGzwVbuzV7JKGsUL4+6mXdU6aQVOP2cEScmvO8E
 5WKBAZQzZnCOxj0MDRfqhiJtOc6zxuyRK0LZyZlw1hevoZrlZk6PX89UAualAi4sWCxw
 t7gKkYhsYbUCoJweuQW08Z9dz68MO7ZwF1/yOzdhHlUc0NAERJOooy4eapzhg4u92axN
 V+FN8UG+zhUUZf5F9Y/DOcRm5lOKxvMT3QmfK2K9lRyi2KRq9yD6mEhN9ijYzE/CZnOg
 Xz1PEl9lwqFmfeRRglcNqtimmdzrbF53WLZMG2vUPG4kb66MlkYFkopy+nKuCVK/SZcS 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ec5bb20wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 08:10:38 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21L7j9sj013405;
        Mon, 21 Feb 2022 08:10:38 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ec5bb20w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 08:10:37 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21L88g3b012668;
        Mon, 21 Feb 2022 08:10:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3ear68qw3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 08:10:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21L8AUfq49611082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 08:10:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89E154203F;
        Mon, 21 Feb 2022 08:10:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0831A42047;
        Mon, 21 Feb 2022 08:10:30 +0000 (GMT)
Received: from [9.145.32.243] (unknown [9.145.32.243])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 08:10:29 +0000 (GMT)
Message-ID: <74568777-c09b-b6a5-e6fa-b8a3a2462e92@linux.ibm.com>
Date:   Mon, 21 Feb 2022 09:10:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v7 1/1] s390x: KVM: guest support for topology function
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
 <b9828696-f5d4-dd72-9b0e-a27b1480b799@linux.ibm.com>
 <aecc2b93-3e07-be78-81a2-594d2bc6b64a@linux.ibm.com>
 <580e5da7-f731-417f-0cc2-baf2313ac6d6@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <580e5da7-f731-417f-0cc2-baf2313ac6d6@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: l3nWA0ZTOL_mPc6wasjlni4_8uQniTlH
X-Proofpoint-GUID: QvJaGwjijveFRzthwNt_ahGRKQETnbPD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_03,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210049
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMi8xOC8yMiAxOToyNCwgUGllcnJlIE1vcmVsIHdyb3RlOg0KPiANCj4gDQo+IE9uIDIv
MTgvMjIgMTg6MjcsIFBpZXJyZSBNb3JlbCB3cm90ZToNCj4+DQo+Pg0KPj4gT24gMi8xOC8y
MiAxNToyOCwgSmFub3NjaCBGcmFuayB3cm90ZToNCj4+PiBPbiAyLzE4LzIyIDE0OjEzLCBQ
aWVycmUgTW9yZWwgd3JvdGU6DQo+Pj4+DQo+Pj4+DQo+Pj4+IE9uIDIvMTcvMjIgMTg6MTcs
IE5pY28gQm9laHIgd3JvdGU6DQo+Pj4+PiBPbiBUaHUsIDIwMjItMDItMTcgYXQgMTA6NTkg
KzAxMDAsIFBpZXJyZSBNb3JlbCB3cm90ZToNCj4+Pj4+IFsuLi5dDQo+Pj4+Pj4gZGlmZiAt
LWdpdCBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYyBiL2FyY2gvczM5MC9rdm0va3ZtLXMz
OTAuYw0KPj4+Pj4+IGluZGV4IDIyOTZiMWZmMWUwMi4uYWY3ZWE4NDg4ZmEyIDEwMDY0NA0K
Pj4+Pj4+IC0tLSBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+Pj4+ICsrKyBiL2Fy
Y2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+Pj4gWy4uLl0NCj4+Pg0KPj4+IFdoeSBpcyB0
aGVyZSBubyBpbnRlcmZhY2UgdG8gY2xlYXIgdGhlIFNDQV9VVElMSVRZX01UQ1Igb24gYSBz
dWJzeXN0ZW0NCj4+PiByZXNldD8NCj4+DQo+PiBSaWdodCwgSSBoYWQgb25lIGluIG15IGZp
cnN0IHZlcnNpb24gYmFzZWQgb24gaW50ZXJjZXB0aW9uIGJ1dCBJIGZvcmdvdA0KPj4gdG8g
aW1wbGVtZW50IGFuIGVxdWl2YWxlbnQgZm9yIEtWTSBhcyBJIG1vZGlmaWVkIHRoZSBpbXBs
ZW1lbnRhdGlvbiBmb3INCj4+IGludGVycHJldGF0aW9uLg0KPj4gSSB3aWxsIGFkZCB0aGlz
Lg0KPj4NCj4+Pg0KPj4+DQo+Pj4+Pj4gLXZvaWQga3ZtX2FyY2hfdmNwdV9sb2FkKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgaW50IGNwdSkNCj4+Pj4+PiArLyoqDQo+Pj4+Pj4gKyAqIGt2
bV9zMzkwX3ZjcHVfc2V0X210Y3INCj4+Pj4+PiArICogQHZjcDogdGhlIHZpcnR1YWwgQ1BV
DQo+Pj4+Pj4gKyAqDQo+Pj4+Pj4gKyAqIElzIG9ubHkgcmVsZXZhbnQgaWYgdGhlIHRvcG9s
b2d5IGZhY2lsaXR5IGlzIHByZXNlbnQuDQo+Pj4+Pj4gKyAqDQo+Pj4+Pj4gKyAqIFVwZGF0
ZXMgdGhlIE11bHRpcHJvY2Vzc29yIFRvcG9sb2d5LUNoYW5nZS1SZXBvcnQgdG8gc2lnbmFs
DQo+Pj4+Pj4gKyAqIHRoZSBndWVzdCB3aXRoIGEgdG9wb2xvZ3kgY2hhbmdlLg0KPj4+Pj4+
ICsgKi8NCj4+Pj4+PiArc3RhdGljIHZvaWQga3ZtX3MzOTBfdmNwdV9zZXRfbXRjcihzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+Pj4+Pj4gIMKgIMKgew0KPj4+Pj4+ICvCoMKgwqDCoMKg
wqDCoHN0cnVjdCBlc2NhX2Jsb2NrICplc2NhID0gdmNwdS0+a3ZtLT5hcmNoLnNjYTsNCj4+
Pj4+DQo+Pj4+PiB1dGlsaXR5IGlzIGF0IHRoZSBzYW1lIG9mZnNldCBmb3IgdGhlIGJzY2Eg
YW5kIHRoZSBlc2NhLCBzdGlsbA0KPj4+Pj4gd29uZGVyaW5nIHdoZXRoZXIgaXQgaXMgYSBn
b29kIGlkZWEgdG8gYXNzdW1lIGVzY2EgaGVyZS4uLg0KPj4+Pg0KPj4+PiBXZSBjYW4gdGFr
ZSBic2NhIHRvIGJlIGNvaGVyZW50IHdpdGggdGhlIGluY2x1ZGUgZmlsZSB3aGVyZSB3ZSBk
ZWZpbmUNCj4+Pj4gRVNDQV9VVElMSVRZX01UQ1IgaW5zaWRlIHRoZSBic2NhLg0KPj4+PiBB
bmQgd2UgY2FuIHJlbmFtZSB0aGUgZGVmaW5lIHRvIFNDQV9VVElMSVRZX01UQ1IgYXMgaXQg
aXMgY29tbW9uIGZvcg0KPj4+PiBib3RoIEJTQ0EgYW5kIEVTQ0EgdGhlIChFKSBpcyB0b28g
bXVjaC4NCj4+Pg0KPj4+IFllcyBhbmQgbWF5YmUgYWRkIGEgY29tbWVudCB0aGF0IGl0J3Mg
YXQgdGhlIHNhbWUgb2Zmc2V0IGZvciBlc2NhIHNvDQo+Pj4gdGhlcmUgd29uJ3QgY29tZSB1
cCBmdXJ0aGVyIHF1ZXN0aW9ucyBpbiB0aGUgZnV0dXJlLg0KPj4NCj4+IE9LDQo+Pg0KPj4+
DQo+Pj4+DQo+Pj4+Pg0KPj4+Pj4gWy4uLl0NCj4+Pj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9z
MzkwL2t2bS9rdm0tczM5MC5oIGIvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5oDQo+Pj4+Pj4g
aW5kZXggMDk4ODMxZTgxNWU2Li5hZjA0ZmZiZmQ1ODcgMTAwNjQ0DQo+Pj4+Pj4gLS0tIGEv
YXJjaC9zMzkwL2t2bS9rdm0tczM5MC5oDQo+Pj4+Pj4gKysrIGIvYXJjaC9zMzkwL2t2bS9r
dm0tczM5MC5oDQo+Pj4+Pj4gQEAgLTUwMyw0ICs1MDMsMjkgQEAgdm9pZCBrdm1fczM5MF92
Y3B1X2NyeXB0b19yZXNldF9hbGwoc3RydWN0IGt2bQ0KPj4+Pj4+ICprdm0pOw0KPj4+Pj4+
ICDCoCDCoCAqLw0KPj4+Pj4+ICDCoCDCoGV4dGVybiB1bnNpZ25lZCBpbnQgZGlhZzljX2Zv
cndhcmRpbmdfaHo7DQo+Pj4+Pj4gKyNkZWZpbmUgUzM5MF9LVk1fVE9QT0xPR1lfTkVXX0NQ
VSAtMQ0KPj4+Pj4+ICsvKioNCj4+Pj4+PiArICoga3ZtX3MzOTBfdG9wb2xvZ3lfY2hhbmdl
ZA0KPj4+Pj4+ICsgKiBAdmNwdTogdGhlIHZpcnR1YWwgQ1BVDQo+Pj4+Pj4gKyAqDQo+Pj4+
Pj4gKyAqIElmIHRoZSB0b3BvbG9neSBmYWNpbGl0eSBpcyBwcmVzZW50LCBjaGVja3MgaWYg
dGhlIENQVSB0b3Bsb2d5DQo+Pj4+Pj4gKyAqIHZpZXdlZCBieSB0aGUgZ3Vlc3QgY2hhbmdl
ZCBkdWUgdG8gbG9hZCBiYWxhbmNpbmcgb3IgQ1BVIGhvdHBsdWcuDQo+Pj4+Pj4gKyAqLw0K
Pj4+Pj4+ICtzdGF0aWMgaW5saW5lIGJvb2wga3ZtX3MzOTBfdG9wb2xvZ3lfY2hhbmdlZChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+Pj4+Pj4gK3sNCj4+Pj4+PiArwqDCoMKgwqDCoMKg
wqBpZiAoIXRlc3Rfa3ZtX2ZhY2lsaXR5KHZjcHUtPmt2bSwgMTEpKQ0KPj4+Pj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZmFsc2U7DQo+Pj4+Pj4gKw0KPj4+
Pj4+ICvCoMKgwqDCoMKgwqDCoC8qIEEgbmV3IHZDUFUgaGFzIGJlZW4gaG90cGx1Z2dlZCAq
Lw0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoGlmICh2Y3B1LT5hcmNoLnByZXZfY3B1ID09IFMz
OTBfS1ZNX1RPUE9MT0dZX05FV19DUFUpDQo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiB0cnVlOw0KPj4+Pj4+ICsNCj4+Pj4+PiArwqDCoMKgwqDCoMKg
wqAvKiBUaGUgcmVhbCBDUFUgYmFja2luZyB1cCB0aGUgdkNQVSBtb3ZlZCB0byBhbm90aGVy
IHNvY2tldA0KPj4+Pj4+ICovDQo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgaWYgKHRvcG9sb2d5
X3BoeXNpY2FsX3BhY2thZ2VfaWQodmNwdS0+Y3B1KSAhPQ0KPj4+Pj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoCB0b3BvbG9neV9waHlzaWNhbF9wYWNrYWdlX2lkKHZjcHUtPmFyY2gucHJl
dl9jcHUpKQ0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
dHJ1ZTsNCj4+Pj4+DQo+Pj4+PiBXaHkgaXMgaXQgT0sgdG8gbG9vayBqdXN0IGF0IHRoZSBw
aHlzaWNhbCBwYWNrYWdlIElEIGhlcmU/IFdoYXQgaWYgdGhlDQo+Pj4+PiB2Y3B1IGZvciBl
eGFtcGxlIG1vdmVzIHRvIGEgZGlmZmVyZW50IGJvb2ssIHdoaWNoIGhhcyBhIGNvcmUgd2l0
aCB0aGUNCj4+Pj4+IHNhbWUgcGh5c2ljYWwgcGFja2FnZSBJRD8NCj4+Pg0KPj4+IEknbGwg
bmVlZCB0byBsb29rIHVwIHN0c2kgMTUqIG91dHB1dCB0byB1bmRlcnN0YW5kIHRoaXMuDQo+
Pj4gQnV0IHRoZSBhcmNoaXRlY3R1cmUgc3RhdGVzIHRoYXQgYW55IGNoYW5nZSB0byB0aGUg
c3RzaSAxNSBvdXRwdXQgc2V0cw0KPj4+IHRoZSBjaGFuZ2UgYml0IHNvIEknZCBndWVzcyBO
aWNvIGlzIGNvcnJlY3QuDQo+Pj4NCj4+DQo+PiBZZXMsIE5pY28gaXMgY29ycmVjdCwgYXMg
SSBhbHJlYWR5IGFuc3dlcmVkLCBob3dldmVyIGl0IGlzIG5vdCBhbnkNCj4+IGNoYW5nZSBv
ZiBzdHNpKDE1KSBidXQgYSBjaGFuZ2Ugb2Ygc3RzaSgxNS4xLjIpIG91dHB1dCB3aGljaCBz
ZXRzIHRoZQ0KPj4gY2hhbmdlIGJpdC4NCj4gDQo+IGh1bSwgdGhhdCBpcyB3aGF0IHRoZSBQ
T1Agc2F5cyBidXQgaW4gZmFjdCB5b3UgYXJlIHJpZ2h0IGEgY2hhbmdlIG9mDQo+IHRvcG9s
b2d5IHRoYXQgY2hhbmdlcyB0aGUgb3V0cHV0IG9mIGFueSBTVFNJKDE1KSBzZXRzIHRoZSB0
b3BvbG9neQ0KPiBjaGFuZ2UgcmVwb3J0IGJpdCBhcyB0aGUgb3V0cHV0IG9mIFNUU0koMTUu
MS4yKSB3b3VsZCBiZSBjaGFuZ2VkIHRvbw0KPiBvYnZpb3VzbHkuDQoNCkluIHRoaXMgY2Fz
ZSBJIHdhcyBqdXN0IGJlaW5nIHRvbyBsYXp5IHRvIGxvb2sgdXAgdGhlIGNvcnJlY3QgcXVl
cnkgY29kZSANCmJ1dCBJIGtuZXcgaXQgc3RhcnRlZCB3aXRoIGZjIDE1LiBJdCB3YXMgRnJp
ZGF5IGFmdGVyIGFsbCA6LSkNCg0KPiANCj4gUmVnYXJkcywNCj4gUGllcnJlDQo+IA0KDQo=

