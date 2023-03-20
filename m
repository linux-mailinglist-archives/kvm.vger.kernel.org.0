Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D256C11C0
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjCTMVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjCTMVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:21:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728B5E07B;
        Mon, 20 Mar 2023 05:21:39 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KAkAlg014684;
        Mon, 20 Mar 2023 12:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g4nmPy+/ZCDuwv9Tse6ut1IQ1MRmVxjqNkMOItt3Ahs=;
 b=bvzIxU7y055X3YZDuDPXVOxuNn8isc6K3XuAUEvT9XUBYM9AVNJrgwnjRxbzwJqlSWsf
 OkTQPurgDruuydKaanTQ8D++pSycqS9YvX9aj/IDgIwBhBGmO5VamI7imectAgwJyVmj
 4p59kno+/KI4OUGmYSYxkHvcesHsHmCsoVrHE3BWywYiuNPw26Hl9c/mz2Xo3NZpceWl
 wdXw4wr+E3AlSwYeCqVp4jW7ZmPM9URxXuW8hIx9E2F+zeOVsO1bNYMT708sWch7Ff01
 TzOwIStituS9s5o15bnfbIwLikfi+3MZBTXZmaazTPApfZ8JMDdVjOpvrhTJoziLLCM3 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdqcafxh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:21:38 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32KAg98C024309;
        Mon, 20 Mar 2023 12:21:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdqcafxg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:21:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32K41Wia015024;
        Mon, 20 Mar 2023 12:21:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pd4jfb7v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:21:35 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32KCLW5G22545124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 12:21:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38A1C20043;
        Mon, 20 Mar 2023 12:21:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4ACC20040;
        Mon, 20 Mar 2023 12:21:31 +0000 (GMT)
Received: from [9.179.5.33] (unknown [9.179.5.33])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Mar 2023 12:21:31 +0000 (GMT)
Message-ID: <36e0a286-d3ee-7bbc-5b8c-e484fa75e672@linux.ibm.com>
Date:   Mon, 20 Mar 2023 13:21:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230315155445.1688249-1-nsg@linux.ibm.com>
 <20230315155445.1688249-4-nsg@linux.ibm.com>
 <86aa2246-07ff-8fb9-ad97-3b68e8b8f109@redhat.com>
 <8deaddfe-dc69-ec3c-4c8c-a76ee17e6513@redhat.com>
 <20230317163654.211830c0@p-imbrenda>
 <d9d18828-596f-cd92-887d-aa3c7cbb6e6f@redhat.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x/spec_ex: Add test of EXECUTE
 with odd target address
In-Reply-To: <d9d18828-596f-cd92-887d-aa3c7cbb6e6f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MY_Qqkg6nbvvotCBMImcsjXzr3lNY0AU
X-Proofpoint-ORIG-GUID: IfEIjTrq_opFNCCDbPS_jKtKXnighyx7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_08,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMy8xNy8yMyAxNzozNywgVGhvbWFzIEh1dGggd3JvdGU6DQo+IE9uIDE3LzAzLzIwMjMg
MTYuMzYsIENsYXVkaW8gSW1icmVuZGEgd3JvdGU6DQo+PiBPbiBGcmksIDE3IE1hciAyMDIz
IDE1OjExOjM1ICswMTAwDQo+PiBUaG9tYXMgSHV0aCA8dGh1dGhAcmVkaGF0LmNvbT4gd3Jv
dGU6DQo+Pg0KPj4+IE9uIDE3LzAzLzIwMjMgMTUuMDksIFRob21hcyBIdXRoIHdyb3RlOg0K
Pj4+PiBPbiAxNS8wMy8yMDIzIDE2LjU0LCBOaW5hIFNjaG9ldHRlcmwtR2xhdXNjaCB3cm90
ZToNCj4+Pj4+IFRoZSBFWEVDVVRFIGluc3RydWN0aW9uIGV4ZWN1dGVzIHRoZSBpbnN0cnVj
dGlvbiBhdCB0aGUgZ2l2ZW4gdGFyZ2V0DQo+Pj4+PiBhZGRyZXNzLiBUaGlzIGFkZHJlc3Mg
bXVzdCBiZSBoYWxmd29yZCBhbGlnbmVkLCBvdGhlcndpc2UgYQ0KPj4+Pj4gc3BlY2lmaWNh
dGlvbiBleGNlcHRpb24gb2NjdXJzLg0KPj4+Pj4gQWRkIGEgdGVzdCBmb3IgdGhpcy4NCj4+
Pj4+DQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBOaW5hIFNjaG9ldHRlcmwtR2xhdXNjaCA8bnNn
QGxpbnV4LmlibS5jb20+DQo+Pj4+PiAtLS0NCj4+Pj4+ICAgwqAgczM5MHgvc3BlY19leC5j
IHwgMjUgKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4+Pj4gICDCoCAxIGZpbGUgY2hh
bmdlZCwgMjUgaW5zZXJ0aW9ucygrKQ0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS9zMzkw
eC9zcGVjX2V4LmMgYi9zMzkweC9zcGVjX2V4LmMNCj4+Pj4+IGluZGV4IDgzYjhjNThlLi41
ZmEwNWRiYSAxMDA2NDQNCj4+Pj4+IC0tLSBhL3MzOTB4L3NwZWNfZXguYw0KPj4+Pj4gKysr
IGIvczM5MHgvc3BlY19leC5jDQo+Pj4+PiBAQCAtMTc3LDYgKzE3NywzMCBAQCBzdGF0aWMg
aW50IHNob3J0X3Bzd19iaXRfMTJfaXNfMCh2b2lkKQ0KPj4+Pj4gICDCoMKgwqDCoMKgIHJl
dHVybiAwOw0KPj4+Pj4gICDCoCB9DQo+Pj4+PiArc3RhdGljIGludCBvZGRfZXhfdGFyZ2V0
KHZvaWQpDQo+Pj4+PiArew0KPj4+Pj4gK8KgwqDCoCB1aW50NjRfdCBwcmVfdGFyZ2V0X2Fk
ZHI7DQo+Pj4+PiArwqDCoMKgIGludCB0byA9IDAsIGZyb20gPSAweDBkZDsNCj4+Pj4+ICsN
Cj4+Pj4+ICvCoMKgwqAgYXNtIHZvbGF0aWxlICggIi5wdXNoc2VjdGlvbiAudGV4dC5leF9v
ZGRcbiINCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCAiwqDCoMKgIC5iYWxpZ27CoMKgwqAgMlxu
Ig0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgICJwcmVfb2RkX2V4X3RhcmdldDpcbiINCj4+Pj4+
ICvCoMKgwqDCoMKgwqDCoCAiwqDCoMKgIC4gPSAuICsgMVxuIg0KPj4+Pj4gK8KgwqDCoMKg
wqDCoMKgICLCoMKgwqAgbHLCoMKgwqAgJVt0b10sJVtmcm9tXVxuIg0KPj4+Pj4gK8KgwqDC
oMKgwqDCoMKgICLCoMKgwqAgLnBvcHNlY3Rpb25cbiINCj4+Pj4+ICsNCj4+Pj4+ICvCoMKg
wqDCoMKgwqDCoCAiwqDCoMKgIGxhcmzCoMKgwqAgJVtwcmVfdGFyZ2V0X2FkZHJdLHByZV9v
ZGRfZXhfdGFyZ2V0XG4iDQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgIsKgwqDCoCBleMKgwqDC
oCAwLDEoJVtwcmVfdGFyZ2V0X2FkZHJdKVxuIg0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIDog
W3ByZV90YXJnZXRfYWRkcl0gIj0mYSIgKHByZV90YXJnZXRfYWRkciksDQo+Pj4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgIFt0b10gIitkIiAodG8pDQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAg
OiBbZnJvbV0gImQiIChmcm9tKQ0KPj4+Pj4gK8KgwqDCoCApOw0KPj4+Pj4gKw0KPj4+Pj4g
K8KgwqDCoCBhc3NlcnQoKHByZV90YXJnZXRfYWRkciArIDEpICYgMSk7DQo+Pj4+PiArwqDC
oMKgIHJlcG9ydCh0byAhPSBmcm9tLCAiZGlkIG5vdCBwZXJmb3JtIGV4IHdpdGggb2RkIHRh
cmdldCIpOw0KPj4+Pj4gK8KgwqDCoCByZXR1cm4gMDsNCj4+Pj4+ICt9DQo+Pj4+DQo+Pj4+
IENhbiB0aGlzIGJlIHRyaWdnZXJlZCB3aXRoIEtWTSwgb3IgaXMgdGhpcyBqdXN0IGEgdGVz
dCBmb3IgVENHPw0KPj4+DQo+Pj4gV2l0aCAidHJpZ2dlcmVkIiBJIG1lYW46IENhbiB0aGlz
IGNhdXNlIGFuIGludGVyY2VwdGlvbiBpbiBLVk0/DQo+Pg0KPj4gQUZBSUsgbm8sIGJ1dCBL
Vk0gYW5kIFRDRyBhcmUgbm90IHRoZSBvbmx5IHRoaW5ncyB3ZSBtaWdodCB3YW50IHRvIHRl
c3QuDQo+IA0KPiBPaywgZmFpciwgS1ZNIHVuaXQgdGVzdHMgYXJlIG5vdCBmb3IgS1ZNIG9u
bHkgYW55bW9yZSBzaW5jZSBxdWl0ZSBhIHdoaWxlLA0KPiBzbyBpZiB0aGlzIGlzIGhlbHBm
dWwgZWxzZXdoZXJlLCBJJ20gZmluZSB3aXRoIHRoaXMuDQo+IA0KPiBBY2tlZC1ieTogVGhv
bWFzIEh1dGggPHRodXRoQHJlZGhhdC5jb20+DQoNClllcywgd2UgbWlnaHQgYmUgZHVlIGZv
ciBhIHJlbmFtZSBvbiBzMzkweC4gT24gbXVsdGlwbGUgb2NjYXNpb25zIEkgaGFkIA0KdG8g
dGVsbCBwZW9wbGUgdGhhdCBldmVuIGlmIHRoZSBuYW1lIHN0YXJ0cyB3aXRoIEtWTSB3ZSdy
ZSBmdWxseSBjYXBhYmxlIA0Kb2YgdGVzdGluZyBMUEFSIGFuZCB6Vk0gOi0pDQoNCkkgYWxz
byB3YW50IHRoaXMgaW4gZm9yIGNvbXBsZXRlbmVzcywgdGhlIGxpbmUgY291bnQgaXMgY2Vy
dGFpbmx5IG9mIG5vIA0KY29uY2VybiBoZXJlLg0K
