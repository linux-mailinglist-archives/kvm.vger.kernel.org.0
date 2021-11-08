Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B5D448006
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 14:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbhKHNHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 08:07:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230303AbhKHNHF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 08:07:05 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CPN9N030905;
        Mon, 8 Nov 2021 13:04:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hu+ICPyBLxkbxk8Tolcb6Qhnpy/0ub7sUQIUYdELyrU=;
 b=BH9b11y6rApvTPpfEMWhXzesYGqRkkiYcXnoBvFL8dKtOyMMcABt/Fxt1dkTpuI/8D6N
 dse/ErypIqDxj39DXvk/SHqegBh8aJm2b8EKNL3CrIlqmFMNRL36RAkF+Hm3jBFACzRQ
 TaiWk7vdzbwXB3o9szvVElwsHAmpU3HqHa901B7+fQvuCG34m14BDxDr/MFT+UogOP8M
 ce6r83LYs2vvGAn0r9K1ROVogJFgdwLO4yDO4dyopBHRfMOb3mvGdtXMPS/WioLADc3w
 Z1WExo5RTvpzT1+GuaGV59uz0v53yFeJY4Y2kQL9xH0wdprt1lBPoaD/Cgtn/Y6FSuw8 mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6a94cnyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:04:20 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8Ag0hU004710;
        Mon, 8 Nov 2021 13:04:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6a94cnxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:04:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8D3j8F011939;
        Mon, 8 Nov 2021 13:04:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3c5hb9x81g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:04:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CvahE56361292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:57:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE94752063;
        Mon,  8 Nov 2021 13:04:13 +0000 (GMT)
Received: from [9.145.83.128] (unknown [9.145.83.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 16DF45205F;
        Mon,  8 Nov 2021 13:04:13 +0000 (GMT)
Message-ID: <446e3ace-16e6-0cc4-874f-7a5caa46d3c1@linux.ibm.com>
Date:   Mon, 8 Nov 2021 14:04:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     david@redhat.com, imbrenda@linux.ibm.com
References: <20211027025451.290124-1-walling@linux.ibm.com>
 <4488b572-11bf-72ff-86c0-395dfc7b3f71@linux.ibm.com>
 <28d90d6f-b481-3588-cd33-39624710b7bd@de.ibm.com>
 <7e785ecc-1ddb-9357-e961-4498d1bf59fd@linux.ibm.com>
 <6c88b81b-85d5-b997-9b69-02f7d05a54c3@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <6c88b81b-85d5-b997-9b69-02f7d05a54c3@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: l2oVTfnGHMtXom1PFrAZho_7SSYv0Esm
X-Proofpoint-GUID: pps4uNWiL80d0zkj7A10jEmjF1jq6KYb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_04,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvOC8yMSAxMzo1MCwgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOg0KPiANCj4g
DQo+IEFtIDA4LjExLjIxIHVtIDEzOjQ4IHNjaHJpZWIgSmFub3NjaCBGcmFuazoNCj4+IE9u
IDExLzgvMjEgMTM6MDQsIENocmlzdGlhbiBCb3JudHJhZWdlciB3cm90ZToNCj4+Pg0KPj4+
DQo+Pj4gQW0gMDguMTEuMjEgdW0gMTI6MTIgc2NocmllYiBKYW5vc2NoIEZyYW5rOg0KPj4+
PiBPbiAxMC8yNy8yMSAwNDo1NCwgQ29sbGluIFdhbGxpbmcgd3JvdGU6DQo+Pj4+PiBUaGUg
ZGlhZyAzMTggZGF0YSBjb250YWlucyB2YWx1ZXMgdGhhdCBkZW5vdGUgaW5mb3JtYXRpb24g
cmVnYXJkaW5nIHRoZQ0KPj4+Pj4gZ3Vlc3QncyBlbnZpcm9ubWVudC4gQ3VycmVudGx5LCBp
dCBpcyB1bmVjZXNzYXJpbHkgZGlmZmljdWx0IHRvIG9ic2VydmUNCj4+Pj4+IHRoaXMgdmFs
dWUgKGVpdGhlciBtYW51YWxseS1pbnNlcnRlZCBkZWJ1ZyBzdGF0ZW1lbnRzLCBnZGIgc3Rl
cHBpbmcsIG1lbQ0KPj4+Pj4gZHVtcGluZyBldGMpLiBJdCdzIHVzZWZ1bCB0byBvYnNlcnZl
IHRoaXMgaW5mb3JtYXRpb24gdG8gb2J0YWluIGFuDQo+Pj4+PiBhdC1hLWdsYW5jZSB2aWV3
IG9mIHRoZSBndWVzdCdzIGVudmlyb25tZW50LCBzbyBsZXRzIGFkZCBhIHNpbXBsZSBWQ1BV
DQo+Pj4+PiBldmVudCB0aGF0IHByaW50cyB0aGUgQ1BOQyB0byB0aGUgczM5MGRiZiBsb2dz
Lg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IENvbGxpbiBXYWxsaW5nIDx3YWxsaW5n
QGxpbnV4LmlibS5jb20+DQo+Pj4+PiAtLS0NCj4+Pj4+ICDCoMKgIGFyY2gvczM5MC9rdm0v
a3ZtLXMzOTAuYyB8IDEgKw0KPj4+Pj4gIMKgwqAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspDQo+Pj4+Pg0KPj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvczM5MC9rdm0va3ZtLXMz
OTAuYyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+Pj4gaW5kZXggNmE2ZGQ1ZTFk
YWY2Li5kYTNmZjI0ZWFiZDAgMTAwNjQ0DQo+Pj4+PiAtLS0gYS9hcmNoL3MzOTAva3ZtL2t2
bS1zMzkwLmMNCj4+Pj4+ICsrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+Pj4g
QEAgLTQyNTQsNiArNDI1NCw3IEBAIHN0YXRpYyB2b2lkIHN5bmNfcmVnc19mbXQyKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkNCj4+Pj4+ICDCoMKgwqDCoMKgwqAgaWYgKGt2bV9ydW4tPmt2
bV9kaXJ0eV9yZWdzICYgS1ZNX1NZTkNfRElBRzMxOCkgew0KPj4+Pj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHZjcHUtPmFyY2guZGlhZzMxOF9pbmZvLnZhbCA9IGt2bV9ydW4tPnMucmVn
cy5kaWFnMzE4Ow0KPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZjcHUtPmFyY2guc2ll
X2Jsb2NrLT5jcG5jID0gdmNwdS0+YXJjaC5kaWFnMzE4X2luZm8uY3BuYzsNCj4+Pj4+ICvC
oMKgwqDCoMKgwqDCoCBWQ1BVX0VWRU5UKHZjcHUsIDIsICJzZXR0aW5nIGNwbmMgdG8gJWQi
LCB2Y3B1LT5hcmNoLmRpYWczMThfaW5mby5jcG5jKTsNCj4+Pj4+ICDCoMKgwqDCoMKgwqAg
fQ0KPj4+Pj4gIMKgwqDCoMKgwqDCoCAvKg0KPj4+Pj4gIMKgwqDCoMKgwqDCoMKgICogSWYg
dXNlcnNwYWNlIHNldHMgdGhlIHJpY2NiIChlLmcuIGFmdGVyIG1pZ3JhdGlvbikgdG8gYSB2
YWxpZCBzdGF0ZSwNCj4+Pj4+DQo+Pj4+DQo+Pj4+IFdvbid0IHRoYXQgdHVybiB1cCBmb3Ig
ZXZlcnkgdmNwdSBhbmQgc3BhbSB0aGUgbG9nPw0KPj4+DQo+Pj4gb25seSBpZiB0aGUgdXNl
cnNwYWNlIGFsd2F5cyBzZXRzIHRoZSBkaXJ0eSBiaXQgKHdoaWNoIGl0IHNob3VsZCBub3Qp
Lg0KPj4+DQo+Pg0KPj4gQnV0IHRoYXQncyBleGFjdGx5IHdoYXQgaXQgZG9lcywgbm8/DQo+
PiBXZSBkbyBhIGxvb3Agb3ZlciBhbGwgdmNwdXMgYW5kIGNhbGwga3ZtX3MzOTBfc2V0X2Rp
YWczMTgoKSB3aGljaCBzZXRzIHRoZSBpbmZvIGluIGt2bV9ydW4gYW5kIHNldHMgdGhlIGRp
YWczMTggYml0IGluIHRoZSBrdm1fZGlydHlfcmVncy4NCj4gDQo+IFllcywgT05DRSBwZXIg
Q1BVLiBBbmQgdGhpcyBpcyBleGFjdGx5IHdoYXQgSSB3YW50IHRvIHNlZS4gKGFuZCBpdCBk
aWQgc2hvdyBhIGJ1ZyBpbiBxZW11IHRoYXQgd2Ugb25seSBzZXQgaXQgZm9yIG9uZSBjcHUg
dG8gdGhlIGNvcnJlY3QgdmFsdWUpLg0KDQpPay4NCkkgZGlkbid0IHJlYWxseSB3YW50IHRv
IGhhdmUgbiBlbnRyaWVzIGluIHRoZSBsb2cgaGVuY2UgSSBhc2tlZC4NCg0KMzE4IGlzIGEg
Yml0IHdlaXJkIGFzIGl0J3MgYSBwZXIgVk0gdmFsdWUgd2UgbmVlZCB0byBwdXQgaW50byBh
bGwgc2llIA0KYmxvY2tzLg0KDQo+IA0KPj4NCj4+IEBDb2xsaW46IENvdWxkIHlvdSBjaGVj
ayB0aGF0IHBsZWFzZT8NCg0K
