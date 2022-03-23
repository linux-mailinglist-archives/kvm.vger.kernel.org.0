Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24A04E4EC9
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242991AbiCWI71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242969AbiCWI7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:59:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F6E74600;
        Wed, 23 Mar 2022 01:57:55 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N8qJvf026437;
        Wed, 23 Mar 2022 08:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aeT7xsJR6muNKXBWyMwDV7ud5K0+eF11xZebHVkiTt0=;
 b=JPhlmtubt3UDNhQzbNGFTEoWVzRqX790LoGFu1IqhBlZL1miWaCa/TQisA8Pwwqa8RmD
 a98Qtm4ocECgir2VAP7hpSfCu9Tl1Y2/ckny/dPfwwjZGnxIo3B67MyxuzkutN8zxGUw
 nhrmAPo6jR2xcqH6y317SsMpQOFpAsM4uGABwSsGIsYjSwCvBzZNcuMLrMXNCsXHpnnh
 t+tuajgDTlcqFoukUJh8Nwa8eOLuEZacE+hvTjVSccIHEJ40sdqO7HqgCvhrw2ahmUuc
 KfTuU7UOaLgJ37ndkukirt6t6wCwmMfovleh/P1LG/By9tBHsmbIcI+/f5P9MFYJD55k 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyvx041ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:57:55 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N7Ds2J021272;
        Wed, 23 Mar 2022 08:57:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyvx041rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:57:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N8lCsA006964;
        Wed, 23 Mar 2022 08:57:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej05jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:57:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N8vnmZ34210192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 08:57:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E26611C05B;
        Wed, 23 Mar 2022 08:57:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07AD911C052;
        Wed, 23 Mar 2022 08:57:49 +0000 (GMT)
Received: from [9.145.94.199] (unknown [9.145.94.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 08:57:48 +0000 (GMT)
Message-ID: <7bcd8720-1c92-4e14-0c93-51d604f017a4@linux.ibm.com>
Date:   Wed, 23 Mar 2022 09:57:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: s390: Fix lockdep issue in vm memop
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220322153204.2637400-1-scgl@linux.ibm.com>
 <44618f05-9aee-5aa5-b036-dd838285b26f@linux.ibm.com>
 <95c28949-8732-8812-c255-79467dafb5c8@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <95c28949-8732-8812-c255-79467dafb5c8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BldfdmoDUIJDmFOoC-1n_xBn6GIF3mxJ
X-Proofpoint-GUID: Cz3J2sxA47VBeTSvtO2e06qyqgu7VGVK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_08,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMy8yMy8yMiAwOTo1MiwgSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIHdyb3RlOg0KPiBP
biAzLzIzLzIyIDA4OjU4LCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4gT24gMy8yMi8yMiAx
NjozMiwgSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIHdyb3RlOg0KPj4+IElzc3VpbmcgYSBt
ZW1vcCBvbiBhIHByb3RlY3RlZCB2bSBkb2VzIG5vdCBtYWtlIHNlbnNlLA0KPj4NCj4+IElz
c3VpbmcgYSB2bSBtZW1vcCBvbiBhIHByb3RlY3RlZCB2bS4uLg0KPj4NCj4+IFRoZSBjcHUg
bWVtb3Agc3RpbGwgbWFrZXMgc2Vuc2UsIG5vPw0KPiANCj4gVGhlIHZjcHUgbWVtb3AgZG9l
cyBob2xkIHRoZSB2Y3B1LT5sb2NrLCBzbyBubyBsb2NrZGVwIGlzc3VlLg0KPiBJZiB5b3Ug
aXNzdWUgYSB2Y3B1IG1lbW9wIHdoaWxlIGVuYWJsaW5nIHByb3RlY3RlZCB2aXJ0dWFsaXph
dGlvbiwNCj4gdGhlIG1lbW9wIG1pZ2h0IGZpbmQgdGhhdCB0aGUgdmNwdSBpcyBub3QgcHJv
dGVjdGVkLCB3aGlsZSBvdGhlciB2Y3B1cw0KPiBtaWdodCBhbHJlYWR5IGJlLCBidXQgSSBk
b24ndCB0aGluayB0aGVyZSdzIGEgd2F5IHRvIGNyZWF0ZSBzZWN1cmUgbWVtb3J5DQo+IGNv
bmN1cnJlbnQgd2l0aCB0aGUgbWVtb3AuDQoNCkkganVzdCB3YW50ZWQgeW91IHRvIG1ha2Ug
dGhpcyBhIGJpdCBtb3JlIHNwZWNpZmljIHNpbmNlIHdlIG5vdyBoYXZlIHZtIA0KYW5kIHZj
cHUgbWVtb3BzLiB2bSBtZW1vcHMgZG9uJ3QgbWFrZSBzZW5zZSBmb3IgcHYgZ3Vlc3RzIGJ1
dCB2Y3B1IG9uZXMgDQphcmUgbmVlZGVkIHRvIGFjY2VzcyB0aGUgc2lkYS4NCg0KPj4NCj4+
PiBuZWl0aGVyIGlzIHRoZSBtZW1vcnkgcmVhZGFibGUvd3JpdGFibGUsIG5vciBkb2VzIGl0
IG1ha2Ugc2Vuc2UgdG8gY2hlY2sNCj4+PiBzdG9yYWdlIGtleXMuIFRoaXMgaXMgd2h5IHRo
ZSBpb2N0bCB3aWxsIHJldHVybiAtRUlOVkFMIHdoZW4gaXQgZGV0ZWN0cw0KPj4+IHRoZSB2
bSB0byBiZSBwcm90ZWN0ZWQuIEhvd2V2ZXIsIGluIG9yZGVyIHRvIGVuc3VyZSB0aGF0IHRo
ZSB2bSBjYW5ub3QNCj4+PiBiZWNvbWUgcHJvdGVjdGVkIGR1cmluZyB0aGUgbWVtb3AsIHRo
ZSBrdm0tPmxvY2sgd291bGQgbmVlZCB0byBiZSB0YWtlbg0KPj4+IGZvciB0aGUgZHVyYXRp
b24gb2YgdGhlIGlvY3RsLiBUaGlzIGlzIGFsc28gcmVxdWlyZWQgYmVjYXVzZQ0KPj4+IGt2
bV9zMzkwX3B2X2lzX3Byb3RlY3RlZCBhc3NlcnRzIHRoYXQgdGhlIGxvY2sgbXVzdCBiZSBo
ZWxkLg0KPj4+IEluc3RlYWQsIGRvbid0IHRyeSB0byBwcmV2ZW50IHRoaXMuIElmIHVzZXIg
c3BhY2UgZW5hYmxlcyBzZWN1cmUNCj4+PiBleGVjdXRpb24gY29uY3VycmVudGx5IHdpdGgg
YSBtZW1vcCBpdCBtdXN0IGFjY2VjcHQgdGhlIHBvc3NpYmlsaXR5IG9mDQo+Pj4gdGhlIG1l
bW9wIGZhaWxpbmcuDQo+Pj4gU3RpbGwgY2hlY2sgaWYgdGhlIHZtIGlzIGN1cnJlbnRseSBw
cm90ZWN0ZWQsIGJ1dCB3aXRob3V0IGxvY2tpbmcgYW5kDQo+Pj4gY29uc2lkZXIgaXQgYSBo
ZXVyaXN0aWMuDQo+Pj4NCj4+PiBGaXhlczogZWYxMWM5NDYzYWUwICgiS1ZNOiBzMzkwOiBB
ZGQgdm0gSU9DVEwgZm9yIGtleSBjaGVja2VkIGd1ZXN0IGFic29sdXRlIG1lbW9yeSBhY2Nl
c3MiKQ0KPj4+IFNpZ25lZC1vZmYtYnk6IEphbmlzIFNjaG9ldHRlcmwtR2xhdXNjaCA8c2Nn
bEBsaW51eC5pYm0uY29tPg0KPj4NCj4+IE1ha2VzIHNlbnNlIHRvIG1lLg0KPj4NCj4+IFJl
dmlld2VkLWJ5OiBKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+DQo+Pg0K
Pj4+IC0tLQ0KPj4+ICDCoCBhcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMgfCAxMSArKysrKysr
KysrLQ0KPj4+ICDCoCAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAu
YyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+IGluZGV4IGNhOTZmODRkYjJjYy4u
NTNhZGJlODZhNjhmIDEwMDY0NA0KPj4+IC0tLSBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAu
Yw0KPj4+ICsrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+IEBAIC0yMzg1LDcg
KzIzODUsMTYgQEAgc3RhdGljIGludCBrdm1fczM5MF92bV9tZW1fb3Aoc3RydWN0IGt2bSAq
a3ZtLCBzdHJ1Y3Qga3ZtX3MzOTBfbWVtX29wICptb3ApDQo+Pj4gIMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLUVJTlZBTDsNCj4+PiAgwqDCoMKgwqDCoCBpZiAobW9wLT5zaXplID4g
TUVNX09QX01BWF9TSVpFKQ0KPj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FMkJJ
RzsNCj4+PiAtwqDCoMKgIGlmIChrdm1fczM5MF9wdl9pc19wcm90ZWN0ZWQoa3ZtKSkNCj4+
PiArwqDCoMKgIC8qDQo+Pj4gK8KgwqDCoMKgICogVGhpcyBpcyB0ZWNobmljYWxseSBhIGhl
dXJpc3RpYyBvbmx5LCBpZiB0aGUga3ZtLT5sb2NrIGlzIG5vdA0KPj4+ICvCoMKgwqDCoCAq
IHRha2VuLCBpdCBpcyBub3QgZ3VhcmFudGVlZCB0aGF0IHRoZSB2bSBpcy9yZW1haW5zIG5v
bi1wcm90ZWN0ZWQuDQo+Pj4gK8KgwqDCoMKgICogVGhpcyBpcyBvayBmcm9tIGEga2VybmVs
IHBlcnNwZWN0aXZlLCB3cm9uZ2RvaW5nIGlzIGRldGVjdGVkDQo+Pj4gK8KgwqDCoMKgICog
b24gdGhlIGFjY2VzcywgLUVGQVVMVCBpcyByZXR1cm5lZCBhbmQgdGhlIHZtIG1heSBjcmFz
aCB0aGUNCj4+PiArwqDCoMKgwqAgKiBuZXh0IHRpbWUgaXQgYWNjZXNzZXMgdGhlIG1lbW9y
eSBpbiBxdWVzdGlvbi4NCj4+PiArwqDCoMKgwqAgKiBUaGVyZSBpcyBubyBzYW5lIHVzZWNh
c2UgdG8gZG8gc3dpdGNoaW5nIGFuZCBhIG1lbW9wIG9uIHR3bw0KPj4+ICvCoMKgwqDCoCAq
IGRpZmZlcmVudCBDUFVzIGF0IHRoZSBzYW1lIHRpbWUuDQo+Pj4gK8KgwqDCoMKgICovDQo+
Pj4gK8KgwqDCoCBpZiAoa3ZtX3MzOTBfcHZfZ2V0X2hhbmRsZShrdm0pKQ0KPj4+ICDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7DQo+Pj4gIMKgwqDCoMKgwqAgaWYgKG1v
cC0+ZmxhZ3MgJiBLVk1fUzM5MF9NRU1PUF9GX1NLRVlfUFJPVEVDVElPTikgew0KPj4+ICDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKGFjY2Vzc19rZXlfaW52YWxpZChtb3AtPmtleSkpDQo+
Pj4NCj4+PiBiYXNlLWNvbW1pdDogYzliOGZlY2RkYjViYjRiNjdlMzUxYmJhZWFhNjQ4YTZm
NzQ1NjkxMg0KPj4NCj4gDQoNCg==
