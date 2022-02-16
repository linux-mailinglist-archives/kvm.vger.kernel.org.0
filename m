Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD184B8845
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 13:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiBPMzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 07:55:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiBPMzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 07:55:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79AF2A64EC
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 04:55:31 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GCcbG8025806
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 12:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=40BWUhBvP2KQqOK2G6OEm+1HVlFwI6Iy10Na4nfKXTM=;
 b=sKZKulhRnm+b3JMBLk1rwWCLSNVCz+yJYLb+rjE+tIqRiZyAr+qLiXss0nSoerX3gsu2
 xX6CDFMhkxMFdY511G25W+ApIGQUMfhMhErJ2xWu+ADbKdVZwJdoM+AVHzeaW4NhxHZk
 +EEEBfxlIdIMacoB5LYwLgghsPFxTB6joc9AjTu/Xl43AqGEbLICXmgKY5aCxxXaGndR
 YM7jWgcf6YN/K+VVlwYvVk1QEjDsS4r/4mlmqn+RuvvOfzD09Wyv+aNdb9e3cN0gI/3J
 mRTyl6aSI6HTQ9MTZWJ5D3+rK8ZnowSyq0dsUd86iHcrvcJXVZeWkPxYgNcrRX2TQQxc lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8vrjy4ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 12:55:31 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GCddQ8031147
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 12:55:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8vrjy4qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:55:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GCqtWO017379;
        Wed, 16 Feb 2022 12:55:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64ha8nf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:55:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GCtNTi45416722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 12:55:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E65C452054;
        Wed, 16 Feb 2022 12:55:23 +0000 (GMT)
Received: from [9.145.84.167] (unknown [9.145.84.167])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 85AEC52057;
        Wed, 16 Feb 2022 12:55:23 +0000 (GMT)
Message-ID: <a889bd74-0e4a-8ca7-4f45-34fb4e306d7f@linux.ibm.com>
Date:   Wed, 16 Feb 2022 13:55:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, david@redhat.com, nrb@linux.ibm.com
References: <20220215104632.47796-1-pmorel@linux.ibm.com>
 <20220215104632.47796-2-pmorel@linux.ibm.com>
 <20220215130606.2d4f2ebb@p-imbrenda>
 <f7d7423b-c0fb-4184-6d3a-fa1d855e0f19@linux.ibm.com>
 <20220215162154.6ebd2567@p-imbrenda>
 <211983e2-5e03-70d6-c5e2-db702ebfb0a4@linux.ibm.com>
 <73febafb-969b-c5b9-4ad3-292a8cab869f@linux.ibm.com>
 <f5ff2f8a-1cba-d429-ad2b-32ce4ce47465@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <f5ff2f8a-1cba-d429-ad2b-32ce4ce47465@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: atM7DhtyqtSQpP3Iyyvoggjq2BnRzBW3
X-Proofpoint-ORIG-GUID: 9CzFt8jeRwb9csNNwDTgz67eu83OALMJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_05,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMi8xNi8yMiAxMzoyNiwgUGllcnJlIE1vcmVsIHdyb3RlOg0KPiANCj4gDQo+IE9uIDIv
MTYvMjIgMDk6MTMsIEphbm9zY2ggRnJhbmsgd3JvdGU6DQo+PiBPbiAyLzE1LzIyIDE4OjMw
LCBQaWVycmUgTW9yZWwgd3JvdGU6DQo+Pj4NCj4+Pg0KPj4+IE9uIDIvMTUvMjIgMTY6MjEs
IENsYXVkaW8gSW1icmVuZGEgd3JvdGU6DQo+Pj4+IE9uIFR1ZSwgMTUgRmViIDIwMjIgMTY6
MDg6MTYgKzAxMDANCj4+Pj4gSmFub3NjaCBGcmFuayA8ZnJhbmtqYUBsaW51eC5pYm0uY29t
PiB3cm90ZToNCj4+Pj4NCj4+Pj4+IE9uIDIvMTUvMjIgMTM6MDYsIENsYXVkaW8gSW1icmVu
ZGEgd3JvdGU6DQo+Pj4+Pj4gT24gVHVlLCAxNSBGZWIgMjAyMiAxMTo0NjozMiArMDEwMA0K
Pj4+Pj4+IFBpZXJyZSBNb3JlbCA8cG1vcmVsQGxpbnV4LmlibS5jb20+IHdyb3RlOg0KPj4+
Pj4+PiBTZXZlcmFsIHRlc3RzIGFyZSBpbiBuZWVkIG9mIGEgd2F5IHRvIGNoZWNrIG9uIHdo
aWNoIGh5cGVydmlzb3INCj4+Pj4+Pj4gYW5kIHZpcnR1YWxpemF0aW9uIGxldmVsIHRoZXkg
YXJlIHJ1bm5pbmcgb24gdG8gYmUgYWJsZSB0byBmZW5jZQ0KPj4+Pj4+PiBjZXJ0YWluIHRl
c3RzLiBUaGlzIHBhdGNoIGFkZHMgZnVuY3Rpb25zIHRoYXQgcmV0dXJuIHRydWUgaWYgYQ0K
Pj4+Pj4+PiB2bSBpcyBydW5uaW5nIHVuZGVyIEtWTSwgTFBBUiBvciBnZW5lcmFsbHkgYXMg
YSBsZXZlbCAyIGd1ZXN0Lg0KPj4+Pj4+Pg0KPj4+Pj4+PiBUbyBjaGVjayBpZiB3ZSdyZSBy
dW5uaW5nIHVuZGVyIEtWTSB3ZSB1c2UgdGhlIFNUU0kgMy4yLjINCj4+Pj4+Pj4gaW5zdHJ1
Y3Rpb24sIGxldCdzIGRlZmluZSBpdCdzIHJlc3BvbnNlIHN0cnVjdHVyZSBpbiBhIGNlbnRy
YWwNCj4+Pj4+Pj4gaGVhZGVyLg0KPj4+Pj4+DQo+Pj4+Pj4gc29ycnksIEkgaGFkIHJlcGxp
ZWQgdG8gdGhlIG9sZCBzZXJpZXMsIGxldCBtZSByZXBseSBoZXJlIHRvbw0KPj4+Pj4+DQo+
Pj4+Pj4NCj4+Pj4+PiBJIHRoaW5rIGl0IHdvdWxkIGxvb2sgY2xlYW5lciBpZiB0aGVyZSB3
YXMgb25seSBvbmUNCj4+Pj4+PiAiZGV0ZWN0X2Vudmlyb25tZW50IiBmdW5jdGlvbiwgdGhh
dCB3b3VsZCBjYWxsIHN0c2kgb25jZSBhbmQgZGV0ZWN0DQo+Pj4+Pj4gdGhlDQo+Pj4+Pj4g
ZW52aXJvbm1lbnQsIHRoZW4gdGhlIHZhcmlvdXMgdm1faXNfKiB3b3VsZCBiZWNvbWUgc29t
ZXRoaW5nIGxpa2UNCj4+Pj4+Pg0KPj4+Pj4+IGJvb2wgdm1faXNfKih2b2lkKQ0KPj4+Pj4+
IHsNCj4+Pj4+PiAgwqDCoMKgwqByZXR1cm4gZGV0ZWN0X2Vudmlyb25tZW50KCkgPT0gVk1f
SVNfKjsNCj4+Pj4+PiB9DQo+Pj4+Pj4NCj4+Pj4+PiBvZiBjb3Vyc2UgZGV0ZWN0X2Vudmly
b25tZW50IHdvdWxkIGFsc28gY2FjaGUgdGhlIHJlc3VsdCB3aXRoIHN0YXRpYw0KPj4+Pj4+
IHZhcmlhYmxlcy4NCj4+Pj4+Pg0KPj4+Pj4+IGJvbnVzLCB3ZSBjb3VsZCBtYWtlIHRoYXQg
ZnVuY3Rpb24gcHVibGljLCBzbyBhIHRlc3RjYXNlIGNvdWxkIGp1c3QNCj4+Pj4+PiBzd2l0
Y2ggb3ZlciB0aGUgdHlwZSBvZiBoeXBlcnZpc29yIGl0J3MgYmVpbmcgcnVuIG9uLCBpbnN0
ZWFkIG9mDQo+Pj4+Pj4gaGF2aW5nDQo+Pj4+Pj4gdG8gdXNlIGEgc2VyaWVzIG9mIGlmcy4N
Cj4+Pj4+Pg0KPj4+Pj4+IGFuZCB0aGVuIG1heWJlIHRoZSB2YXJpb3VzIHZtX2lzXyogY291
bGQgYmVjb21lIHN0YXRpYyBpbmxpbmVzIHRvDQo+Pj4+Pj4gYmUgcHV0DQo+Pj4+Pj4gaW4g
dGhlIGhlYWRlci4NCj4+Pj4+Pg0KPj4+Pj4+IHBsZWFzZSBub3RlIHRoYXQgImRldGVjdF9l
bnZpcm9ubWVudCIgaXMganVzdCB0aGUgZmlyc3QgdGhpbmcgdGhhdA0KPj4+Pj4+IGNhbWUN
Cj4+Pj4+PiB0byBteSBtaW5kLCBJIGhhdmUgbm8gcHJlZmVyZW5jZSByZWdhcmRpbmcgdGhl
IG5hbWUuDQo+Pj4+Pg0KPj4+Pj4gSSdkIGxpa2UgdG8ga2VlcCB0aGlzIHBhdGNoIGFzIHNp
bXBsZSBhcyBwb3NzaWJsZSBiZWNhdXNlIHRoZXJlIGFyZQ0KPj4+Pj4gbXVsdGlwbGUgcGF0
Y2ggc2V0cyB3aGljaCBhcmUgZ2F0ZWQgYnkgaXQuDQo+Pj4+Pg0KPj4+Pj4gVGhlIHZtLmgg
Y29kZSBhbmQgdGhlIHNrZXkuYyB6L1ZNIDYgY2hlY2sgaXMgYSB0aG9ybiBpbiBteSBzaWRl
IGFueXdheQ0KPj4+Pj4gYW5kIEknZCByYXRoZXIgaGF2ZSBpdCBmaXhlZCBwcm9wZXJseSB3
aGljaCB3aWxsIGxpa2VseSByZXN1bHQgaW4gYSBsb3QNCj4+Pj4+IG9mIG9waW5pb25zIGJl
aW5nIHZvaWNlZC4NCj4+Pj4+DQo+Pj4+PiBTbyBJJ2QgcHJvcG9zZSB0byByZW5hbWUgdm1f
aXNfdm0oKSB0byB2bV9pc19ndWVzdDIoKSBhbmQgcGljayB0aGlzDQo+Pj4+PiBwYXRjaC4N
Cj4+Pj4NCj4+Pj4gb2sgZm9yIG1lDQo+Pj4+DQo+Pj4+IEknbGwgcmVuYW1lIHRoZSBmdW5j
dGlvbiBhbmQgcXVldWUgdGhlIHBhdGNoDQo+Pj4+DQo+Pj4NCj4+PiBOb3QgT0sgZm9yIG1l
LCBpbiB0aGUgUE9QIFBURiBkbyBub3QgZG8gYW55IGRpZmZlcmVuY2UgYmV0d2VlbiBndWVz
dCAyDQo+Pj4gYW5kIGd1ZXN0IDMuDQo+Pg0KPj4gSWYgd2UncmUgcnVubmluZyB3aXRoIEhX
IHZpcnR1YWxpemF0aW9uIHRoZW4gZXZlcnkgZ3Vlc3QgPj0gMiBpcyBhIGd1ZXN0DQo+PiAy
IGF0IHRoZSBlbmQuIEFuZCBtb3N0IG9mIHRoZSB0aW1lIHdlIGRvbid0IHdhbnQgdG8ga25v
dyB0aGUgSFcgbGV2ZWwNCj4+IGFueXdheSwgd2Ugd2FudCB0byBrbm93IHdobyBvdXIgaHlw
ZXJ2aXNvciBpcyBhbmQgdm1faXNfdm0oKSBkb2Vzbid0DQo+PiB0ZWxsIHlvdSBvbmUgYml0
IGFib3V0IHRoYXQuDQo+IA0KPiBJdCB0ZWxscyB1cyB0aGF0IHdlIGFyZSBydW5uaW5nIHVu
ZGVyIGEgVk0sIHRoZSBQT1AgZGVmaW5lcyAxIGFzIHRoZQ0KPiBiYXNpYyBtYWNoaW5lLCAy
IGFzIHRoZSBMUEFSIGFuZCAzIGFzIHRoZSBWaXJ0dWFsIE1hY2hpbmUNCj4gDQo+IEkgZmlu
ZCB0aGlzIGRlZmluaXRpb24gY2xlYXIsIG11Y2ggbW9yZSBjbGVhciB0aGFuIGd1ZXN0IDIg
dGhhdCBpcyB3aHkgSQ0KPiB1c2VkIGl0Lg0KPiANCj4+DQo+PiBBdCB0aGlzIHBvaW50IEkg
d291bGQgYmUgaGFwcGllciBpZiB3ZSByZW1vdmUgdGhlIGZ1bmN0aW9uIGFuZCB1c2UNCj4+
IHN0c2lfZ2V0X2ZjKCkgPT0gMyBkaXJlY3RseS4gVGhlcmUncyBubyBhcmd1aW5nIGFib3V0
IHdoYXQgd2UncmUNCj4+IGNoZWNraW5nIHdoZW4gdXNpbmcgdGhhdC4NCj4gDQo+IFNwZWFr
aW5nIG9mIGZ1bmN0aW9uIG5hbWUsIEkgZG8gbm90IHVuZGVyc3RhbmQgdGhlIG5hbWUgb2Yg
dGhpcyBmdW5jdGlvbg0KPiBzdHNpX2dldF9mYygpIDogcmV0dXJuaW5nIHRoZSBmdW5jdGlv
biBjb2RlID8NCg0KSSBndWVzcyBpdCBzaG91bGQgYmUgc3RzaV9nZXRfY3VycmVudF9sZXZl
bCgpIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuDQpMZXQgbWUgYWRkIHRoYXQgdG8gdGhlIGxp
c3Qgb2Ygdm0uaCByZXdvcmsgaXRlbXMuDQoNCj4gDQo+Pg0KPj4gV2UncmUgY3VycmVudGx5
IGFyZ3VpbmcgYWJvdXQgYSBmdW5jdGlvbiB0aGF0J3Mgb25seSB1c2VkIGluIHRoaXMgcGF0
Y2gsDQo+PiBubz8NCj4gDQo+IEl0IGlzIGFic29sdXRlbHkgdW5pbXBvcnRhbnQgZm9yIG1l
LCBpZiB5b3UgcHJlZmVyIHRoaXMgd2UgZG8gdGhpcy4NCj4gSSBzZW5kIHRoZSBjaGFuZ2Vz
Lg0K
