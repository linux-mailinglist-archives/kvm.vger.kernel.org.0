Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5ABE50B296
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445440AbiDVIFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 04:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445436AbiDVIFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 04:05:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A871527D6;
        Fri, 22 Apr 2022 01:02:21 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M7CGLC020150;
        Fri, 22 Apr 2022 08:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k8IqdTJREoNElLpuXIY1bxU0Qimegc2GWe9c0tCwUlY=;
 b=Ceoc6EwH+O+a99xtFFIJkJR1xXG8m1XQNzm37X93sb+sdafRVWKogzQ3PMeYD0/ve5zv
 GPCSY0v1od54ZWqdRzAUi84c9QDzt38a9/m3OEOAIlDmAD85VElHRIvoaU8KhaiV78dd
 KhzgIjDY+8jY61Kj2CiN5QkAwLenQu+B6lqQeOHJ0U6Mw+u3Fz3+chfSWa0XXTKZI/vE
 KBlUgoCwDlRvuoBv6gvKCEx4tTCJltSbqsFzbj/wDBf+NaXcpF/A9sxzqqzfvYv44tlh
 cO6wpnYibyEivdypOJjOjlMQAI2gxsPYXlsafZ3f8mLFFfEOOc8Ka09kr75lpSXbc1Th 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fk1yeu654-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 08:02:20 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23M7Pfmi008771;
        Fri, 22 Apr 2022 08:02:20 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fk1yeu61d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 08:02:20 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23M7xTCE027466;
        Fri, 22 Apr 2022 08:02:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3ffn2hy536-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 08:02:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23M820U337945784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 08:02:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BCCCAE04D;
        Fri, 22 Apr 2022 08:02:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31E3AAE045;
        Fri, 22 Apr 2022 08:02:00 +0000 (GMT)
Received: from [9.145.85.218] (unknown [9.145.85.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 08:01:59 +0000 (GMT)
Message-ID: <35766f5c-cf7a-ecd8-6183-ea683eb9ff49@linux.ibm.com>
Date:   Fri, 22 Apr 2022 10:01:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v3 1/4] lib: s390x: add support for SCLP
 console read
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220420134557.1307305-1-nrb@linux.ibm.com>
 <20220420134557.1307305-2-nrb@linux.ibm.com>
 <d8e6d465-3a8a-db75-1244-ed574efd9f59@linux.ibm.com>
 <b7044e507dc7828f4c75d737b190a33800645666.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <b7044e507dc7828f4c75d737b190a33800645666.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o_POifjnSehYHFrQcR4CNrxOnO0GN592
X-Proofpoint-GUID: kSBgBwWc2Os_6o59cVdSOAuauqA_k5gJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220036
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNC8yMi8yMiAwOTo1MCwgTmljbyBCb2VociB3cm90ZToNCj4gT24gVGh1LCAyMDIyLTA0
LTIxIGF0IDE2OjI5ICswMjAwLCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4NCj4gWy4uLl0N
Cj4+PiBkaWZmIC0tZ2l0IGEvbGliL3MzOTB4L3NjbHAtY29uc29sZS5jIGIvbGliL3MzOTB4
L3NjbHAtY29uc29sZS5jDQo+Pj4gaW5kZXggZmEzNmE2YTQyMzgxLi44YzRiZjY4Y2JiYWIg
MTAwNjQ0DQo+Pj4gLS0tIGEvbGliL3MzOTB4L3NjbHAtY29uc29sZS5jDQo+Pj4gKysrIGIv
bGliL3MzOTB4L3NjbHAtY29uc29sZS5jDQo+IFsuLi5dDQo+Pj4gK8KgwqDCoMKgwqDCoMKg
cmVhZF9idWZfZW5kID0gc2NjYi0+ZWJoLmxlbmd0aCAtDQo+Pj4gZXZlbnRfYnVmZmVyX2Fz
Y2lpX3JlY3ZfaGVhZGVyX2xlbjsNCj4+DQo+PiBJc24ndCB0aGlzIG1vcmUgbGlrZSBhIGxl
bmd0aCBvZiB0aGUgY3VycmVudCByZWFkIGJ1ZmZlciBjb250ZW50cz8NCj4gDQo+IFJpZ2h0
LCB0aGFua3MsIGxlbmd0aCBpcyBhIG11Y2ggYmV0dGVyIG5hbWUuDQo+IA0KPiBbLi4uXQ0K
Pj4+IGRpZmYgLS1naXQgYS9saWIvczM5MHgvc2NscC5oIGIvbGliL3MzOTB4L3NjbHAuaA0K
Pj4+IGluZGV4IGZlYWQwMDdhNjAzNy4uZTQ4YTVhM2RmMjBiIDEwMDY0NA0KPj4+IC0tLSBh
L2xpYi9zMzkweC9zY2xwLmgNCj4+PiArKysgYi9saWIvczM5MHgvc2NscC5oDQo+Pj4gQEAg
LTMxMyw2ICszMTMsMTQgQEAgdHlwZWRlZiBzdHJ1Y3QgUmVhZEV2ZW50RGF0YSB7DQo+Pj4g
IMKgwqDCoMKgwqDCoMKgwqB1aW50MzJfdCBtYXNrOw0KPj4+ICDCoCB9IF9fYXR0cmlidXRl
X18oKHBhY2tlZCkpIFJlYWRFdmVudERhdGE7DQo+Pj4gICAgDQo+Pj4gKyNkZWZpbmUgU0NM
UF9FVkVOVF9BU0NJSV9UWVBFX0RBVEFfU1RSRUFNX0ZPTExPV1MgMA0KPj4NCj4+IEhybSwg
SSdtIG5vdCBjb21wbGV0ZWx5IGhhcHB5IHdpdGggdGhlIG5hbWluZyBoZXJlIHNpbmNlIEkg
Y29uZnVzZWQNCj4+IGl0DQo+PiB0byB0aGUgZWJoLT50eXBlIHdoZW4gbG9va2luZyB1cCB0
aGUgY29uc3RhbnRzLiBCdXQgbm93IEkgdW5kZXJzdGFuZA0KPj4gd2h5DQo+PiB5b3UgY2hv
c2UgaXQuDQo+IA0KPiBZZWFoLCBpdCBzdXJlIGlzIGNvbmZ1c2luZy4NCj4gDQo+IE1heWJl
IGl0IGlzIGJldHRlciBpZiB3ZSBsZWF2ZSBvdXQgdGhlICJ0eXBlIiBlbnRpcmVseSwgYnV0
IHRoaXMgbWlnaHQNCj4gbWFrZSBpdCBoYXJkZXIgdG8gdW5kZXJzdGFuZCB3aGVyZSBpdCdz
IGNvbWluZyBmcm9tOg0KPiBTQ0xQX0FTQ0lJX1JFQ0VJVkVfREFUQV9TVFJFQU1fRk9MTE9X
Uw0KPiANCj4gQW5vdGhlciBhbHRlcm5hdGl2ZSBJIHRob3VnaHQgYWJvdXQgaXMgdXNpbmcg
ZW51bXMsIGl0IHdvbid0IGZpeCB0aGUNCj4gbmFtaW5nLCBidXQgYXQgbGVhc3QgaXQgbWln
aHQgYmUgY2xlYXJlciB0byB3aGljaCB0eXBlIGl0IGJlbG9uZ3MuDQo+IA0KPiBMZXQgbWUg
a25vdyB3aGF0IHlvdSB0aGluay4NCg0KSXQgc2hvdWxkIGJlIGZpbmUgYXMgaXMuIEkgZG9u
J3QgZXhwZWN0IHRoYXQgd2UgaGF2ZSB0byB0b3VjaCB0aGlzIGZpbGUgDQp2ZXJ5IG9mdGVu
Lg0K
