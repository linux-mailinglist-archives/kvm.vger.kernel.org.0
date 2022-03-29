Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF9C4EAC7A
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 13:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiC2LlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 07:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiC2LlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 07:41:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A624A201B5;
        Tue, 29 Mar 2022 04:39:38 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22TAfT4I017954;
        Tue, 29 Mar 2022 11:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xzXNIkmQMH1RNaB8qRsmWczgfceBKd6rW1aL5zPqyw8=;
 b=Jj3SKpsAKfL41C23gHv39u0Lcu1mnBHQHCYnz/z1f5NsUWEqLUvqkznEPoPMJBmSqbDZ
 LY9V9HnyCGqq1+k3RX8OiZsL3NsWSjnO8nfPZS4P2wYeYEMTHsN7qch4nQ6yQw2bkrFm
 lLAAsTe8MffRJLQ08uJE0FqptqNC6diI1F5EbL9mBXlmINh6PSe/oACtzOGucNRqBmNz
 IcaSi3LZetvhlFXZ6UufMkG5iKKyWt2mZJ4IC7cXDYWXjCbm666ouZV2Z/pf9pwfoKRC
 oa69Kn2KtRzU5OppyPsUaTKaSx5ABleLEgIkhF9pDNmxklp75Q+e8THU6EgveKXZEWrE Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3y90ttka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 11:39:37 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22TB169R021850;
        Tue, 29 Mar 2022 11:39:37 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3y90ttjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 11:39:37 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22TBViP9015247;
        Tue, 29 Mar 2022 11:39:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3hw68w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 11:39:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22TBdWsg55640332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 11:39:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0242552051;
        Tue, 29 Mar 2022 11:39:32 +0000 (GMT)
Received: from [9.145.75.22] (unknown [9.145.75.22])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A9C7D5204F;
        Tue, 29 Mar 2022 11:39:31 +0000 (GMT)
Message-ID: <7cca996a-454d-7287-1d91-c7f5908b0f15@linux.ibm.com>
Date:   Tue, 29 Mar 2022 13:39:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
References: <20220328093048.869830-1-nrb@linux.ibm.com>
 <20220328093048.869830-3-nrb@linux.ibm.com>
 <2fafa98b-e342-047a-3a94-cf4111bc7198@linux.ibm.com>
 <c1b585cbd42cff9920488a74ee5a40ed0d5b13f8.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390x: add test for SIGP STORE_ADTL_STATUS order
In-Reply-To: <c1b585cbd42cff9920488a74ee5a40ed0d5b13f8.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QrUMnCyCurLAu91t0ZLOsFmR0PLW27BP
X-Proofpoint-GUID: yVQqtpLLoTFocC2BSoK5ziSTnVM2FI7_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_04,2022-03-29_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 bulkscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMy8yOC8yMiAxNzoxMiwgTmljbyBCb2VociB3cm90ZToNCj4gT24gTW9uLCAyMDIyLTAz
LTI4IGF0IDEzOjU0ICswMjAwLCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4+IGRpZmYgLS1n
aXQgYS9zMzkweC9hZHRsX3N0YXR1cy5jIGIvczM5MHgvYWR0bF9zdGF0dXMuYw0KPj4+IG5l
dyBmaWxlIG1vZGUgMTAwNjQ0DQo+Pj4gaW5kZXggMDAwMDAwMDAwMDAwLi43YTJiZDJiMDc4
MDQNCj4+PiAtLS0gL2Rldi9udWxsDQo+Pj4gKysrIGIvczM5MHgvYWR0bF9zdGF0dXMuYw0K
PiBbLi4uXQ0KPj4+ICtzdHJ1Y3QgbWNlc2FfbGMxMiB7DQo+Pj4gK8KgwqDCoMKgwqDCoMKg
dWludDhfdCB2ZWN0b3JfcmVnWzB4MjAwXTvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIDB4
MDAwICovDQo+Pg0KPj4gSHJtIHdlIGNvdWxkIGRvOg0KPj4gX191aW50MTI4X3QgdnJlZ3Nb
MzJdOw0KPj4NCj4+IG9yOg0KPj4gdWludDY0X3QgdnJlZ3NbMTZdWzJdOw0KPj4NCj4+IG9y
IGxlYXZlIGl0IGFzIGl0IGlzLg0KPiANCj4gTm8gc3Ryb25nIHByZWZlcmVuY2UgYWJvdXQg
dGhlIHR5cGUuIHVpbnQ4X3QgbWFrZXMgaXQgZWFzeSB0byBjaGVjayB0aGUNCj4gb2Zmc2V0
cy4NCj4gDQo+Pg0KPj4+ICvCoMKgwqDCoMKgwqDCoHVpbnQ4X3QgcmVzZXJ2ZWQyMDBbMHg0
MDAgLSAweDIwMF07wqDCoCAvKiAweDIwMCAqLw0KPj4+ICvCoMKgwqDCoMKgwqDCoHN0cnVj
dCBnc19jYiBnc19jYjvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyog
MHg0MDAgKi8NCj4+PiArwqDCoMKgwqDCoMKgwqB1aW50OF90IHJlc2VydmVkNDIwWzB4ODAw
IC0gMHg0MjBdO8KgwqAgLyogMHg0MjAgKi8NCj4+PiArwqDCoMKgwqDCoMKgwqB1aW50OF90
IHJlc2VydmVkODAwWzB4MTAwMCAtIDB4ODAwXTvCoCAvKiAweDgwMCAqLw0KPj4+ICt9Ow0K
Pj4NCj4+IERvIHdlIGhhdmUgcGxhbnMgdG8gdXNlIHRoaXMgc3RydWN0IGluIHRoZSBmdXR1
cmUgZm9yIG90aGVyIHRlc3RzPw0KPiANCj4gTWF5YmUgYXQgc29tZSBwb2ludCBpZiB3ZSBh
ZGQgY2hlY2tzIGZvciBtYWNoaW5lIGNoZWNrIGhhbmRsaW5nLCBidXQNCj4gcmlnaHQgbm93
IHdlIGRvbid0IGhhdmUgdGhlIGluZnJhc3RydWN0dXJlIGluIGt2bS11bml0LXRlc3RzIHRv
IGRvIHRoYXQNCj4gSSB0aGluay4NCg0KQWxyaWdodCwgdGhlbiBsZXQncyBsZWF2ZSB0aGUg
c3RydWN0IGluIGhlcmUgZm9yIG5vdy4NCg0KWy4uLl0NCg0KPj4+ICtzdGF0aWMgdm9pZCBy
ZXN0YXJ0X3dyaXRlX3ZlY3Rvcih2b2lkKQ0KPj4+ICt7DQo+Pj4gK8KgwqDCoMKgwqDCoMKg
dWludDhfdCAqdmVjX3JlZzsNCj4+PiArwqDCoMKgwqDCoMKgwqAvKiB2bG0gaGFuZGxlcyBh
dCBtb3N0IDE2IHJlZ2lzdGVycyBhdCBhIHRpbWUgKi8NCj4+PiArwqDCoMKgwqDCoMKgwqB1
aW50OF90ICp2ZWNfcmVnXzE2XzMxID0gJmV4cGVjdGVkX3ZlY19jb250ZW50c1sxNl1bMF07
DQo+Pj4gK8KgwqDCoMKgwqDCoMKgaW50IGk7DQo+Pj4gKw0KPj4+ICvCoMKgwqDCoMKgwqDC
oGZvciAoaSA9IDA7IGkgPCBOVU1fVkVDX1JFR0lTVEVSUzsgaSsrKSB7DQo+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZlY19yZWcgPSAmZXhwZWN0ZWRfdmVjX2NvbnRl
bnRzW2ldWzBdOw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBpKzEg
dG8gYXZvaWQgemVybyBjb250ZW50ICovDQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoG1lbXNldCh2ZWNfcmVnLCBpICsgMSwgVkVDX1JFR0lTVEVSX1NJWkUpOw0KPj4+
ICvCoMKgwqDCoMKgwqDCoH0NCj4+PiArDQo+Pj4gK8KgwqDCoMKgwqDCoMKgY3RsX3NldF9i
aXQoMCwgQ1RMMF9WRUNUT1IpOw0KPj4+ICsNCj4+PiArwqDCoMKgwqDCoMKgwqBhc20gdm9s
YXRpbGUgKA0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAiwqDCoMKgwqDC
oMKgwqAubWFjaGluZSB6MTNcbiINCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIsKgwqDCoMKgwqDCoMKgdmxtIDAsMTUsICVbdmVjX3JlZ18wXzE1XVxuIg0KPj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAiwqDCoMKgwqDCoMKgwqB2bG0gMTYsMzEs
ICVbdmVjX3JlZ18xNl8zMV1cbiINCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgOg0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA6IFt2ZWNfcmVnXzBf
MTVdICJRIihleHBlY3RlZF92ZWNfY29udGVudHMpLA0KPj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBbdmVjX3JlZ18xNl8zMV0gIlEiKCp2ZWNfcmVnXzE2XzMxKQ0K
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA6ICJ2MCIsICJ2MSIsICJ2MiIs
ICJ2MyIsICJ2NCIsICJ2NSIsICJ2NiIsICJ2NyIsDQo+Pj4gInY4IiwgInY5IiwNCj4+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgInYxMCIsICJ2MTEiLCAidjEyIiwg
InYxMyIsICJ2MTQiLCAidjE1IiwgInYxNiIsDQo+Pj4gInYxNyIsICJ2MTgiLA0KPj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAidjE5IiwgInYyMCIsICJ2MjEiLCAi
djIyIiwgInYyMyIsICJ2MjQiLCAidjI1IiwNCj4+PiAidjI2IiwgInYyNyIsDQo+Pj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJ2MjgiLCAidjI5IiwgInYzMCIsICJ2
MzEiLCAibWVtb3J5Ig0KPj4NCj4+IFdlIGNoYW5nZSBtZW1vcnkgb24gYSBsb2FkPw0KPiAN
Cj4gVG8gbXkgdW5kZXJzdGFuZGluZywgdGhpcyBtaWdodCBiZSBuZWNjZXNhcnkgaWYgZXhw
ZWN0ZWRfdmVjX2NvbnRlbnRzDQo+IGVuZHMgdXAgaW4gYSByZWdpc3RlciwgYnV0IHRoYXQg
d29uJ3QgaGFwcGVuLCBzbyBJIGNhbiByZW1vdmUgaXQuDQo+IA0KPj4NCj4+PiArwqDCoMKg
wqDCoMKgwqApOw0KPj4NCj4+IFdlIGNvdWxkIGFsc28gbW92ZSB2bG0gYXMgYSBmdW5jdGlv
biB0byB2ZWN0b3IuaCBhbmQgZG8gdHdvIGNhbGxzLg0KPiANCj4gSSB0aGluayB0aGF0IHdv
bid0IHdvcmsgYmVjYXVzZSB0aGF0IGZ1bmN0aW9uIG1pZ2h0IGNsZWFuIGl0cyBmbG9hdA0K
PiByZWdpc3RlcnMgaW4gdGhlIGVwaWxvZ3VlIGFuZCBoZW5jZSBkZXN0cm95IHRoZSBjb250
ZW50cy4gRXhjZXB0IGlmIHlvdQ0KPiBoYXZlIGFuIGlkZWEgb24gaG93IHRvIGF2b2lkIHRo
YXQ/DQoNCkFib3V0IHRoYXQ6DQoNCldlbGwsIHdobyBndWFyYW50ZWVzIHlvdSB0aGF0IHRo
ZSBjb21waWxlciB3b24ndCBjaGFuZ2UgYSBmcHIgKGFuZCANCnRoZXJlYnkgdGhlIG92ZXJs
YXBwZWQgdnJzKSBiZXR3ZWVuIHRoZSB2bG1zIGhlcmUgYW5kIHlvdXIgaW5maW5pdGUgbG9v
cCANCmF0IHRoZSBlbmQgb2YgdGhlIGZ1bmN0aW9uPyA6LSkgZ2NjIHVzZXMgZnBycyBhbmQg
YWNycyBpbiB0aGUgbW9zdCANCmludGVyZXN0aW5nIHBsYWNlcyBhbmQgSSd2ZSBqdXN0IGJl
ZW4gaGl0IGJ5IHRoYXQgYWdhaW4gYSBmZXcgaG91cnMgYWdvLg0KDQpJLmUuIHRvIGJlIHNh
ZmUgd2UnbGwgbmVlZCB0byBpbXBsZW1lbnQgdGhlIG5leHQgZmV3IGxpbmVzIGluIGFzc2Vt
Ymx5IA0KYXMgd2VsbCwgbm8/DQo=
