Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668A656541B
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiGDLsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 07:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiGDLrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 07:47:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EE81180F
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 04:47:46 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264BLC5K021621;
        Mon, 4 Jul 2022 11:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jfis7FoOBqcQxm1MDfPoAzQpsnIH3GpUcIK2JrRAMM8=;
 b=aidWlIhMT3Ojscx1znjYzTXerrD82ffAr8fT5WnnpMZrx66WexsCjlp3/q0GMhtXc8Is
 R+OmjUQm9PSBRP6IMdgb9xelfFdIJarYW+3YZU6IcDg9PyQwBrgPREOORe/PntZxKXp4
 ahpKnv9kR1ar3413ixSwkfNmFlro25GKpmy5hK3+4CCMEdpI60HlpeZZA+pMtEoq3+Zf
 3rTEcsx5RUbaWdzrxk1znsjw0xwK2juFH8aAhPFZQqRiE96nU8rGl/zZQ3X65CmqEsdJ
 lJRKpCo8y8es9Ul1TfRwmyij0UghsInVRaBWqMiyMt8f1FEgAk4lTip+feVXr4t7SGwY qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3y8prfp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 11:47:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264BN7uM028842;
        Mon, 4 Jul 2022 11:47:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3y8prfnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 11:47:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264BfRAN024748;
        Mon, 4 Jul 2022 11:47:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3h2dn8tmqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 11:47:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264BlYvE24904178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 11:47:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 594464203F;
        Mon,  4 Jul 2022 11:47:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C7EA42041;
        Mon,  4 Jul 2022 11:47:33 +0000 (GMT)
Received: from [9.145.190.147] (unknown [9.145.190.147])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jul 2022 11:47:33 +0000 (GMT)
Message-ID: <3e97dd7d-0a3f-c1ae-75d5-bef05c639038@linux.ibm.com>
Date:   Mon, 4 Jul 2022 13:47:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
 <35c562e1-cdcd-41ce-1957-bd35c72a78ca@linux.ibm.com>
 <72aba814-2901-7d06-131d-8c1f660e3830@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <72aba814-2901-7d06-131d-8c1f660e3830@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qm-M8QaWjKd9GfyGXfCWQrkupYhVxTtC
X-Proofpoint-GUID: N8DROzqSRULkMnzy0nsTtezAX6GtrFJT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNi8yOS8yMiAxNzoyNSwgUGllcnJlIE1vcmVsIHdyb3RlOg0KPiANCj4gDQo+IE9uIDYv
MjcvMjIgMTU6MzEsIEphbm9zY2ggRnJhbmsgd3JvdGU6DQo+PiBPbiA2LzIwLzIyIDE2OjAz
LCBQaWVycmUgTW9yZWwgd3JvdGU6DQo+Pj4gV2UgdXNlIG5ldyBvYmplY3RzIHRvIGhhdmUg
YSBkeW5hbWljIGFkbWluaXN0cmF0aW9uIG9mIHRoZSBDUFUgdG9wb2xvZ3kuDQo+Pj4gVGhl
IGhpZ2hlc3QgbGV2ZWwgb2JqZWN0IGluIHRoaXMgaW1wbGVtZW50YXRpb24gaXMgdGhlIHMz
OTAgYm9vayBhbmQNCj4+PiBpbiB0aGlzIGZpcnN0IGltcGxlbWVudGF0aW9uIG9mIENQVSB0
b3BvbG9neSBmb3IgUzM5MCB3ZSBoYXZlIGEgc2luZ2xlDQo+Pj4gYm9vay4NCj4+PiBUaGUg
Ym9vayBpcyBidWlsdCBhcyBhIFNZU0JVUyBicmlkZ2UgZHVyaW5nIHRoZSBDUFUgaW5pdGlh
bGl6YXRpb24uDQo+Pj4gT3RoZXIgb2JqZWN0cywgc29ja2V0cyBhbmQgY29yZSB3aWxsIGJl
IGJ1aWx0IGFmdGVyIHRoZSBwYXJzaW5nDQo+Pj4gb2YgdGhlIFFFTVUgLXNtcCBhcmd1bWVu
dC4NCj4+Pg0KPj4+IEV2ZXJ5IG9iamVjdCB1bmRlciB0aGlzIHNpbmdsZSBib29rIHdpbGwg
YmUgYnVpbGQgZHluYW1pY2FsbHkNCj4+PiBpbW1lZGlhdGVseSBhZnRlciBhIENQVSBoYXMg
YmUgcmVhbGl6ZWQgaWYgaXQgaXMgbmVlZGVkLg0KPj4+IFRoZSBDUFUgd2lsbCBmaWxsIHRo
ZSBzb2NrZXRzIG9uY2UgYWZ0ZXIgdGhlIG90aGVyLCBhY2NvcmRpbmcgdG8gdGhlDQo+Pj4g
bnVtYmVyIG9mIGNvcmUgcGVyIHNvY2tldCBkZWZpbmVkIGR1cmluZyB0aGUgc21wIHBhcnNp
bmcuDQo+Pj4NCj4+PiBFYWNoIENQVSBpbnNpZGUgYSBzb2NrZXQgd2lsbCBiZSByZXByZXNl
bnRlZCBieSBhIGJpdCBpbiBhIDY0Yml0DQo+Pj4gdW5zaWduZWQgbG9uZy4gU2V0IG9uIHBs
dWcgYW5kIGNsZWFyIG9uIHVucGx1ZyBvZiBhIENQVS4NCj4+Pg0KPj4+IEZvciB0aGUgUzM5
MCBDUFUgdG9wb2xvZ3ksIHRocmVhZCBhbmQgY29yZXMgYXJlIG1lcmdlZCBpbnRvDQo+Pj4g
dG9wb2xvZ3kgY29yZXMgYW5kIHRoZSBudW1iZXIgb2YgdG9wb2xvZ3kgY29yZXMgaXMgdGhl
IG11bHRpcGxpY2F0aW9uDQo+Pj4gb2YgY29yZXMgYnkgdGhlIG51bWJlcnMgb2YgdGhyZWFk
cy4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IFBpZXJyZSBNb3JlbCA8cG1vcmVsQGxpbnV4
LmlibS5jb20+DQo+Pg0KPj4gWy4uLl0NCj4+DQo+Pj4gZGlmZiAtLWdpdCBhL3RhcmdldC9z
MzkweC9jcHUuaCBiL3RhcmdldC9zMzkweC9jcHUuaA0KPj4+IGluZGV4IDdkNmQwMTMyNWIu
LjIxNmFkZmRlMjYgMTAwNjQ0DQo+Pj4gLS0tIGEvdGFyZ2V0L3MzOTB4L2NwdS5oDQo+Pj4g
KysrIGIvdGFyZ2V0L3MzOTB4L2NwdS5oDQo+Pj4gQEAgLTU2NSw2ICs1NjUsNTMgQEAgdHlw
ZWRlZiB1bmlvbiBTeXNJQiB7DQo+Pj4gIMKgIH0gU3lzSUI7DQo+Pj4gIMKgIFFFTVVfQlVJ
TERfQlVHX09OKHNpemVvZihTeXNJQikgIT0gNDA5Nik7DQo+Pj4gKy8qIENQVSB0eXBlIFRv
cG9sb2d5IExpc3QgRW50cnkgKi8NCj4+PiArdHlwZWRlZiBzdHJ1Y3QgU3lzSUJUbF9jcHUg
ew0KPj4+ICvCoMKgwqDCoMKgwqDCoCB1aW50OF90IG5sOw0KPj4+ICvCoMKgwqDCoMKgwqDC
oCB1aW50OF90IHJlc2VydmVkMFszXTsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDhfdCBy
ZXNlcnZlZDE6NTsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDhfdCBkZWRpY2F0ZWQ6MTsN
Cj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDhfdCBwb2xhcml0eToyOw0KPj4+ICvCoMKgwqDC
oMKgwqDCoCB1aW50OF90IHR5cGU7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIHVpbnQxNl90IG9y
aWdpbjsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDY0X3QgbWFzazsNCj4+PiArfSBTeXNJ
QlRsX2NwdTsNCj4+PiArUUVNVV9CVUlMRF9CVUdfT04oc2l6ZW9mKFN5c0lCVGxfY3B1KSAh
PSAxNik7DQo+Pj4gKw0KPj4+ICsvKiBDb250YWluZXIgdHlwZSBUb3BvbG9neSBMaXN0IEVu
dHJ5ICovDQo+Pj4gK3R5cGVkZWYgc3RydWN0IFN5c0lCVGxfY29udGFpbmVyIHsNCj4+PiAr
wqDCoMKgwqDCoMKgwqAgdWludDhfdCBubDsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDhf
dCByZXNlcnZlZFs2XTsNCj4+PiArwqDCoMKgwqDCoMKgwqAgdWludDhfdCBpZDsNCj4+PiAr
fSBRRU1VX1BBQ0tFRCBTeXNJQlRsX2NvbnRhaW5lcjsNCj4+PiArUUVNVV9CVUlMRF9CVUdf
T04oc2l6ZW9mKFN5c0lCVGxfY29udGFpbmVyKSAhPSA4KTsNCj4+PiArDQo+Pj4gKy8qIEdl
bmVyaWMgVG9wb2xvZ3kgTGlzdCBFbnRyeSAqLw0KPj4+ICt0eXBlZGVmIHVuaW9uIFN5c0lC
VGxfZW50cnkgew0KPj4+ICvCoMKgwqDCoMKgwqDCoCB1aW50OF90IG5sOw0KPj4NCj4+IFRo
aXMgdW5pb24gbWVtYmVyIGlzIHVudXNlZCwgaXNuJ3QgaXQ/DQo+Pg0KPj4+ICvCoMKgwqDC
oMKgwqDCoCBTeXNJQlRsX2NvbnRhaW5lciBjb250YWluZXI7DQo+Pj4gK8KgwqDCoMKgwqDC
oMKgIFN5c0lCVGxfY3B1IGNwdTsNCj4+PiArfSBTeXNJQlRsX2VudHJ5Ow0KPj4+ICsNCj4+
PiArI2RlZmluZSBUT1BPTE9HWV9OUl9NQUfCoCA2DQo+Pg0KPj4gVE9QT0xPR1lfVE9UQUxf
TlJfTUFHUyA/DQo+Pg0KPj4+ICsjZGVmaW5lIFRPUE9MT0dZX05SX01BRzYgMA0KPj4NCj4+
IFRPUE9MT0dZX05SX1RMRVNfTUFHNiA/DQo+Pg0KPj4gSSdtIG9wZW4gdG8gb3RoZXIgc3Vn
Z2VzdGlvbnMgYnV0IHdlIG5lZWQgdG8gZGlmZmVyZW50aWF0ZSBiZXR3ZWVuIHRoZQ0KPj4g
bnVtYmVyIG9mIG1hZyBhcnJheSBlbnRyaWVzIGFuZCB0aGUgbnVtYmVyIG9mIFRMRXMgaW4g
dGhlIE1BR3MuDQo+IA0KPiANCj4gdHlwZWRlZiBlbnVtIHsNCj4gICAgICAgICAgIFRPUE9M
T0dZX01BRzYgPSAwLA0KPiAgICAgICAgICAgVE9QT0xPR1lfTUFHNSA9IDEsDQo+ICAgICAg
ICAgICBUT1BPTE9HWV9NQUc0ID0gMiwNCj4gICAgICAgICAgIFRPUE9MT0dZX01BRzMgPSAz
LA0KPiAgICAgICAgICAgVE9QT0xPR1lfTUFHMiA9IDQsDQo+ICAgICAgICAgICBUT1BPTE9H
WV9NQUcxID0gNSwNCj4gICAgICAgICAgIFRPUE9MT0dZX1RPVEFMX01BR1MgPSA2LA0KPiB9
Ow0KPiANCj4gDQo+IG9kZXIgZW51bSB3aXRoIFRPUE9MT0dZX05SX1RMRVNfTUFHeCA/DQoN
CkknZCBzdGljayB3aXRoIHRoZSBzaG9ydGVyIGZpcnN0IHZhcmlhbnQuDQoNCj4gDQo+Pg0K
Pj4+ICsjZGVmaW5lIFRPUE9MT0dZX05SX01BRzUgMQ0KPj4+ICsjZGVmaW5lIFRPUE9MT0dZ
X05SX01BRzQgMg0KPj4+ICsjZGVmaW5lIFRPUE9MT0dZX05SX01BRzMgMw0KPj4+ICsjZGVm
aW5lIFRPUE9MT0dZX05SX01BRzIgNA0KPj4+ICsjZGVmaW5lIFRPUE9MT0dZX05SX01BRzEg
NQ0KPj4NCj4+IEknZCBhcHByZWNpYXRlIGEgXG4gaGVyZS4NCj4gDQo+IE9LDQo+IA0KPj4N
Cj4+PiArLyogQ29uZmlndXJhdGlvbiB0b3BvbG9neSAqLw0KPj4+ICt0eXBlZGVmIHN0cnVj
dCBTeXNJQl8xNTF4IHsNCj4+PiArwqDCoMKgIHVpbnQ4X3TCoCByZXMwWzJdOw0KPj4NCj4+
IFlvdSdyZSB1c2luZyAicmVzZXJ2ZWQiIGV2ZXJ5d2hlcmUgYnV0IG5vdyBpdCdzICJyZXYi
Pw0KPiANCj4gT0sgSSB3aWxsIGtlZXAgcmVzZXJ2ZWQNCj4gDQo+Pg0KPj4+ICvCoMKgwqAg
dWludDE2X3QgbGVuZ3RoOw0KPj4+ICvCoMKgwqAgdWludDhfdMKgIG1hZ1tUT1BPTE9HWV9O
Ul9NQUddOw0KPj4+ICvCoMKgwqAgdWludDhfdMKgIHJlczE7DQo+Pj4gK8KgwqDCoCB1aW50
OF90wqAgbW5lc3Q7DQo+Pj4gK8KgwqDCoCB1aW50MzJfdCByZXMyOw0KPj4+ICvCoMKgwqAg
U3lzSUJUbF9lbnRyeSB0bGVbMF07DQo+Pj4gK30gU3lzSUJfMTUxeDsNCj4+PiArUUVNVV9C
VUlMRF9CVUdfT04oc2l6ZW9mKFN5c0lCXzE1MXgpICE9IDE2KTsNCj4+PiArDQo+Pj4gIMKg
IC8qIE1NVSBkZWZpbmVzICovDQo+Pj4gIMKgICNkZWZpbmUgQVNDRV9PUklHSU7CoMKgwqDC
oMKgwqDCoMKgwqDCoCAofjB4ZmZmVUxMKSAvKiBzZWdtZW50IHRhYmxlDQo+Pj4gb3JpZ2lu
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovDQo+Pj4gIMKgICNkZWZpbmUgQVNDRV9TVUJT
UEFDRcKgwqDCoMKgwqDCoMKgwqAgMHgyMDDCoMKgwqDCoMKgwqAgLyogc3Vic3BhY2UgZ3Jv
dXANCj4+PiBjb250cm9swqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4+DQo+Pg0KPiANCg0K

