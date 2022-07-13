Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD13573132
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 10:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbiGMIej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 04:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbiGMIe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 04:34:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127799C246;
        Wed, 13 Jul 2022 01:34:27 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D7DlBq003605;
        Wed, 13 Jul 2022 08:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=d1V82yQlwjqpMUJ5k4dTMJp3PzuooeX+wrvhExobG0U=;
 b=ImAA7f+l7+Msp2P93jOy7JuK6nh+DWEF0anaUi47G9iXOzeOf3onXJ82buYzs5V/XHnZ
 XmlWZWeq5oWN+d0OBnv2V/XpuYWYY11QrvkqeXp05inGsCCvary5Ic91HOAhZ756NhzI
 oF//a1dyt6EYnMA6WZduo4IKZrp8uxz4rZRPAb+9FowfJpuRIAkQur8PMpS0X6bx60Qt
 droPes76qpxfLCpnSJpMgnk6f+Ryz4klOENbq7eVq2+o341jzGafPScoIbLpEV5h+9VN
 2mGoP3KfmkjotKX8lB84iBi4wEJNJYcu6vIL5JCFR+PX+Tr32+xlm7fzCgjAF3TSNmNa tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h99r0sfu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 08:34:26 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26D8PKM3025192;
        Wed, 13 Jul 2022 08:34:25 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h99r0sfn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 08:34:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26D8KpFO001616;
        Wed, 13 Jul 2022 08:34:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3h71a8vmng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 08:34:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26D8YI0v22348200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 08:34:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0599C42042;
        Wed, 13 Jul 2022 08:34:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 518AB4203F;
        Wed, 13 Jul 2022 08:34:17 +0000 (GMT)
Received: from [9.145.184.105] (unknown [9.145.184.105])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 08:34:17 +0000 (GMT)
Message-ID: <899e5148-8e65-8260-6f3c-546b4f5a650f@linux.ibm.com>
Date:   Wed, 13 Jul 2022 10:34:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v12 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
 <20220711084148.25017-3-pmorel@linux.ibm.com>
 <92c6d13c-4494-de56-83f4-9d7384444008@linux.ibm.com>
 <1884bc26-b91b-83a7-7f8b-96b6090a0bac@linux.ibm.com>
 <6124248a-24be-b43a-f827-b6bebf9e7f3d@linux.ibm.com>
 <5c3d9637-7739-1323-8630-433ff8cb4dc4@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <5c3d9637-7739-1323-8630-433ff8cb4dc4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HR-EGR8ZxR55fs0wCDbhaHqk_WsAgFmr
X-Proofpoint-ORIG-GUID: UlRAFTx--TVwF_GpxPj6oyCVWkjppV2Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207130035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wy4uLl0NCj4+Pj4+ICAgwqAgKy8qKg0KPj4+Pj4gKyAqIGt2bV9zMzkwX3VwZGF0ZV90b3Bv
bG9neV9jaGFuZ2VfcmVwb3J0IC0gdXBkYXRlIENQVSB0b3BvbG9neSBjaGFuZ2UgcmVwb3J0
DQo+Pj4+PiArICogQGt2bTogZ3Vlc3QgS1ZNIGRlc2NyaXB0aW9uDQo+Pj4+PiArICogQHZh
bDogc2V0IG9yIGNsZWFyIHRoZSBNVENSIGJpdA0KPj4+Pj4gKyAqDQo+Pj4+PiArICogVXBk
YXRlcyB0aGUgTXVsdGlwcm9jZXNzb3IgVG9wb2xvZ3ktQ2hhbmdlLVJlcG9ydCBiaXQgdG8g
c2lnbmFsDQo+Pj4+PiArICogdGhlIGd1ZXN0IHdpdGggYSB0b3BvbG9neSBjaGFuZ2UuDQo+
Pj4+PiArICogVGhpcyBpcyBvbmx5IHJlbGV2YW50IGlmIHRoZSB0b3BvbG9neSBmYWNpbGl0
eSBpcyBwcmVzZW50Lg0KPj4+Pj4gKyAqDQo+Pj4+PiArICogVGhlIFNDQSB2ZXJzaW9uLCBi
c2NhIG9yIGVzY2EsIGRvZXNuJ3QgbWF0dGVyIGFzIG9mZnNldCBpcyB0aGUgc2FtZS4NCj4+
Pj4+ICsgKi8NCj4+Pj4+ICtzdGF0aWMgdm9pZCBrdm1fczM5MF91cGRhdGVfdG9wb2xvZ3lf
Y2hhbmdlX3JlcG9ydChzdHJ1Y3Qga3ZtICprdm0sIGJvb2wgdmFsKQ0KPj4+Pj4gK3sNCj4+
Pj4+ICvCoMKgwqAgdW5pb24gc2NhX3V0aWxpdHkgbmV3LCBvbGQ7DQo+Pj4+PiArwqDCoMKg
IHN0cnVjdCBic2NhX2Jsb2NrICpzY2E7DQo+Pj4+PiArDQo+Pj4+PiArwqDCoMKgIHJlYWRf
bG9jaygma3ZtLT5hcmNoLnNjYV9sb2NrKTsNCj4+Pj4+ICvCoMKgwqAgZG8gew0KPj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIHNjYSA9IGt2bS0+YXJjaC5zY2E7DQo+Pj4+DQo+Pj4+IEkgZmlu
ZCB0aGlzIGFzc2lnbm1lbnQgYmVpbmcgaW4gdGhlIGxvb3AgdW5pbnR1aXRpdmUsIGJ1dCBp
dCBzaG91bGQgbm90IG1ha2UgYSBkaWZmZXJlbmNlLg0KPj4+DQo+Pj4gVGhlIHByaWNlIHdv
dWxkIGJlIGFuIHVnbHkgY2FzdC4NCj4+DQo+PiBJIGRvbid0IGdldCB3aGF0IHlvdSBtZWFu
LiBOb3RoaW5nIGFib3V0IHRoZSB0eXBlcyBjaGFuZ2VzIGlmIHlvdSBtb3ZlIGl0IGJlZm9y
ZSB0aGUgbG9vcC4NCj4gDQo+IFllcyByaWdodCwgZGlkIHdyb25nIHVuZGVyc3RhbmQuDQo+
IEl0IGlzIGJldHRlciBiZWZvcmUuDQpXaXRoIHRoZSBhc3NpZ25tZW50IG1vdmVkIG9uZSBs
aW5lIHVwOg0KUmV2aWV3ZWQtYnk6IEphbm9zY2ggRnJhbmsgPGZyYW5ramFAbGludXguaWJt
LmNvbT4NCg0KPiANCj4+Pg0KPj4+DQo+Pj4+DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgb2xk
ID0gUkVBRF9PTkNFKHNjYS0+dXRpbGl0eSk7DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgbmV3
ID0gb2xkOw0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIG5ldy5tdGNyID0gdmFsOw0KPj4+Pj4g
K8KgwqDCoCB9IHdoaWxlIChjbXB4Y2hnKCZzY2EtPnV0aWxpdHkudmFsLCBvbGQudmFsLCBu
ZXcudmFsKSAhPSBvbGQudmFsKTsNCj4+Pj4+ICvCoMKgwqAgcmVhZF91bmxvY2soJmt2bS0+
YXJjaC5zY2FfbG9jayk7DQo+Pj4+PiArfQ0KPj4+Pj4gKw0KPj4+PiBbLi4uXQ0KPj4+Pg0K
Pj4+DQo+Pj4NCj4+DQo+IA0KDQo=
