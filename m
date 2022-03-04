Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6960E4CD296
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbiCDKlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiCDKlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:41:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2311AA07A;
        Fri,  4 Mar 2022 02:40:29 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2249JgRG023520;
        Fri, 4 Mar 2022 10:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2ureneyGL/RxCUi5c/GReTp/E1qUMt1GFUmVsqghXxM=;
 b=II8+pLFs7p1AoeJLBibfz+0GqDpUpd9G/c2QW2Qw79dHLcnKfEqlli61Y/OzLaZFrakP
 eSEvpU7BFlB+IfYr9gwfJGDJ8reCtu1ZxipX8TNi9KLeR5fGQqzplGTTyFUJUjArAZpj
 aZq/n7ZfcZvEwSQAH3YC1mfgolKNoNUA7gfNoxrUeYdwD4ucK87FeMYpvs25nkMJU8mM
 HvGqhYU0+LB/a6DM6z4vpscS1OzNc22iopqXYzEEC+a3fGMrqKJs/yXSSgryXpRvQEvB
 DUMEmsCgHr8/WvJwaLbDVpGdMyIg6O1WwzIH2C6YdIcm9AfCFPHLwIKsco/kyZI7lzPV KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekg1thaj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:40:28 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224ANI0B025320;
        Fri, 4 Mar 2022 10:40:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekg1thahf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:40:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224AVvs1023672;
        Fri, 4 Mar 2022 10:40:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ek4kg9fsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:40:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224AeNwv44695972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 10:40:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E9D342042;
        Fri,  4 Mar 2022 10:40:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB2DC4204B;
        Fri,  4 Mar 2022 10:40:22 +0000 (GMT)
Received: from [9.145.58.173] (unknown [9.145.58.173])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 10:40:22 +0000 (GMT)
Message-ID: <fcacf11f-6469-8c70-9db5-0bb55e77fcdf@linux.ibm.com>
Date:   Fri, 4 Mar 2022 11:40:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220303210425.1693486-1-farman@linux.ibm.com>
 <20220303210425.1693486-4-farman@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 3/6] s390x: smp: Fix checks for SIGP
 STOP STORE STATUS
In-Reply-To: <20220303210425.1693486-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6L237NOQ29xfPm8LXbMXBCG0C18aOzL4
X-Proofpoint-GUID: 81zQTtj3WCICXwr9IAbxbgqYFoTlipH5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_02,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMy8zLzIyIDIyOjA0LCBFcmljIEZhcm1hbiB3cm90ZToNCj4gSW4gdGhlIHJvdXRpbmUg
dGVzdF9zdG9wX3N0b3JlX3N0YXR1cygpLCB0aGUgInJ1bm5pbmciIHBhcnQgb2YNCj4gdGhl
IHRlc3QgY2hlY2tzIGEgZmV3IG9mIHRoZSBmaWVsZHMgaW4gbG93Y29yZSAodG8gdmVyaWZ5
IHRoZQ0KPiAiU1RPUkUgU1RBVFVTIiBwYXJ0IG9mIHRoZSBTSUdQIG9yZGVyKSwgYW5kIHRo
ZW4gZW5zdXJlcyB0aGF0DQo+IHRoZSBDUFUgaGFzIHN0b3BwZWQuIEJ1dCB0aGlzIGlzIGJh
Y2t3YXJkcywgYW5kIGxlYWRzIHRvIGZhbHNlDQo+IGVycm9ycy4NCj4gDQo+IEFjY29yZGlu
ZyB0byB0aGUgUHJpbmNpcGxlcyBvZiBPcGVyYXRpb246DQo+ICAgIFRoZSBhZGRyZXNzZWQg
Q1BVIHBlcmZvcm1zIHRoZSBzdG9wIGZ1bmN0aW9uLCBmb2wtDQo+ICAgIGxvd2VkIGJ5IHRo
ZSBzdG9yZS1zdGF0dXMgb3BlcmF0aW9uIChzZWUg4oCcU3RvcmUgU3RhLQ0KPiAgICB0dXPi
gJ0gb24gcGFnZSA0LTgyKS4NCj4gDQo+IEJ5IGNoZWNraW5nIHRoZSByZXN1bHRzIGhvdyB0
aGV5IGFyZSB0b2RheSwgdGhlIGNvbnRlbnRzIG9mDQo+IHRoZSBsb3djb3JlIGZpZWxkcyBh
cmUgdW5yZWxpYWJsZSB1bnRpbCB0aGUgQ1BVIGlzIHN0b3BwZWQuDQo+IFRodXMsIGNoZWNr
IHRoYXQgdGhlIENQVSBpcyBzdG9wcGVkIGZpcnN0LCBiZWZvcmUgZW5zdXJpbmcNCj4gdGhh
dCB0aGUgU1RPUkUgU1RBVFVTIHdhcyBwZXJmb3JtZWQgY29ycmVjdGx5Lg0KDQpUaGUgcmVz
dWx0cyBhcmUgdW5kZWZpbmVkIHVudGlsIHRoZSBjcHUgaXMgbm90IGJ1c3kgdmlhIFNJR1Ag
c2Vuc2UsIG5vPw0KWW91IGNvdmVyIHRoYXQgdmlhIGRvaW5nIHRoZSBzbXBfY3B1X3N0b3Bw
ZWQoKSBjaGVjayBzaW5jZSB0aGF0IGRvZXMgYSANCnNpZ3Agc2Vuc2UuDQoNCldoZXJlIHRo
ZSBzdG9wIGNoZWNrIGlzIGxvY2F0ZWQgZG9lc24ndCByZWFsbHkgbWF0dGVyIHNpbmNlIHRo
ZSBsaWJyYXJ5IA0Kd2FpdHMgdW50aWwgdGhlIGNwdSBpcyBzdG9wcGVkIGFuZCBpdCBkb2Vz
IHRoYXQgdmlhIHNtcF9jcHVfc3RvcHBlZCgpDQoNCg0KU286DQpBcmUgd2UgcmVhbGx5IGZp
eGluZyBzb21ldGhpbmcgaGVyZT8NCg0KUGxlYXNlIGltcHJvdmUgdGhlIGNvbW1pdCBkZXNj
cmlwdGlvbi4NCkZvciBtZSB0aGlzIGxvb2tzIG1vcmUgbGlrZSBtYWtpbmcgY2hlY2tzIG1v
cmUgZXhwbGljaXQgYW5kIHN5bW1ldHJpY2FsIA0Kd2hpY2ggSSdtIGdlbmVyYWxseSBvayB3
aXRoLiBXZSBqdXN0IG5lZWQgdG8gc3BlY2lmeSBjb3JyZWN0bHkgd2h5IHdlJ3JlIA0KZG9p
bmcgdGhhdC4NCg0KPiANCj4gV2hpbGUgaGVyZSwgYWRkIHRoZSBzYW1lIGNoZWNrIHRvIHRo
ZSBzZWNvbmQgcGFydCBvZiB0aGUgdGVzdCwNCj4gZXZlbiB0aG91Z2ggdGhlIENQVSBpcyBl
eHBsaWNpdGx5IHN0b3BwZWQgcHJpb3IgdG8gdGhlIFNJR1AuDQo+IA0KPiBGaXhlczogZmM2
N2IwN2E0ICgiczM5MHg6IHNtcDogVGVzdCBzdG9wIGFuZCBzdG9yZSBzdGF0dXMgb24gYSBy
dW5uaW5nIGFuZCBzdG9wcGVkIGNwdSIpDQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgRmFybWFu
IDxmYXJtYW5AbGludXguaWJtLmNvbT4NCj4gLS0tDQo+ICAgczM5MHgvc21wLmMgfCAzICsr
LQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9zMzkweC9zbXAuYyBiL3MzOTB4L3NtcC5jDQo+IGluZGV4
IDJmNGFmODIwLi41MDgxMWJkMCAxMDA2NDQNCj4gLS0tIGEvczM5MHgvc21wLmMNCj4gKysr
IGIvczM5MHgvc21wLmMNCj4gQEAgLTk4LDkgKzk4LDkgQEAgc3RhdGljIHZvaWQgdGVzdF9z
dG9wX3N0b3JlX3N0YXR1cyh2b2lkKQ0KPiAgIAlsYy0+Z3JzX3NhWzE1XSA9IDA7DQo+ICAg
CXNtcF9jcHVfc3RvcF9zdG9yZV9zdGF0dXMoMSk7DQo+ICAgCW1iKCk7DQo+ICsJcmVwb3J0
KHNtcF9jcHVfc3RvcHBlZCgxKSwgImNwdSBzdG9wcGVkIik7DQo+ICAgCXJlcG9ydChsYy0+
cHJlZml4X3NhID09ICh1aW50MzJfdCkodWludHB0cl90KWNwdS0+bG93Y29yZSwgInByZWZp
eCIpOw0KPiAgIAlyZXBvcnQobGMtPmdyc19zYVsxNV0sICJzdGFjayIpOw0KPiAtCXJlcG9y
dChzbXBfY3B1X3N0b3BwZWQoMSksICJjcHUgc3RvcHBlZCIpOw0KPiAgIAlyZXBvcnRfcHJl
Zml4X3BvcCgpOw0KPiAgIA0KPiAgIAlyZXBvcnRfcHJlZml4X3B1c2goInN0b3BwZWQiKTsN
Cj4gQEAgLTEwOCw2ICsxMDgsNyBAQCBzdGF0aWMgdm9pZCB0ZXN0X3N0b3Bfc3RvcmVfc3Rh
dHVzKHZvaWQpDQo+ICAgCWxjLT5ncnNfc2FbMTVdID0gMDsNCj4gICAJc21wX2NwdV9zdG9w
X3N0b3JlX3N0YXR1cygxKTsNCj4gICAJbWIoKTsNCj4gKwlyZXBvcnQoc21wX2NwdV9zdG9w
cGVkKDEpLCAiY3B1IHN0b3BwZWQiKTsNCj4gICAJcmVwb3J0KGxjLT5wcmVmaXhfc2EgPT0g
KHVpbnQzMl90KSh1aW50cHRyX3QpY3B1LT5sb3djb3JlLCAicHJlZml4Iik7DQo+ICAgCXJl
cG9ydChsYy0+Z3JzX3NhWzE1XSwgInN0YWNrIik7DQo+ICAgCXJlcG9ydF9wcmVmaXhfcG9w
KCk7DQoNCg==
