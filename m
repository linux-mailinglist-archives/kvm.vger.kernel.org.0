Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB5546651
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 14:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345195AbiFJMKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbiFJMKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 08:10:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11E155B3;
        Fri, 10 Jun 2022 05:10:32 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AC4sEt034824;
        Fri, 10 Jun 2022 12:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DgGwYuMjS1UAIUrT+ikDwSe5cL2gkvOo1r8d56WOIaI=;
 b=QKcsPyn5WRYzkPI9URpw8AMhjZ1rK/x54Cp7Lvnvw29Wq1RJAsiCB1/zZV6CMiHMeAer
 wZdEyPbeIOgy3gO+AkXOfK1tLRZ6tlzGxoCq2XiSM8oDrqmO177fn0x23IGDq1veoNfA
 h/1lARGyybYtcWzJmN5vowVE8RIGPFQIx/phICWWCmFaTZRzRzEGiuHuQh94snCWyFiQ
 2PY41g031GYT6ThpjRlQpJ31j1q/65Oc6YlloqGB03qcLpcnp/oA2OZjl0W0armJjTgD
 npEt+/VcGWn1P9BqCxi7zyt7DJyn82ITDCsWM0jQ/a/SnGhwQ8deqySjt1cG9LkoMvqu aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm5dqr80q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 12:10:31 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25AC5txg036957;
        Fri, 10 Jun 2022 12:10:31 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm5dqr807-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 12:10:31 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25AC6uKK004231;
        Fri, 10 Jun 2022 12:10:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3gfy18xfsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 12:10:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25ACA5Gg23265760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 12:10:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 192935204F;
        Fri, 10 Jun 2022 12:10:26 +0000 (GMT)
Received: from [9.145.63.156] (unknown [9.145.63.156])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B34B152051;
        Fri, 10 Jun 2022 12:10:25 +0000 (GMT)
Message-ID: <1c233f7b-2a21-bbf2-92ef-fb1091423cbd@linux.ibm.com>
Date:   Fri, 10 Jun 2022 14:10:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220608133303.1532166-1-scgl@linux.ibm.com>
 <20220608133303.1532166-4-scgl@linux.ibm.com>
 <1b4f731f-866c-5357-b0e0-b8bc375976cd@linux.ibm.com>
 <fadd5a33-89ef-b2b3-5890-340b93013a34@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Rework TEID decoding and
 usage
In-Reply-To: <fadd5a33-89ef-b2b3-5890-340b93013a34@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7GdRafCXhUVZ_50nMon6OOIQPW9hSThk
X-Proofpoint-ORIG-GUID: SgFvNlg14xyJEew1h7QoRJD2MDNd7AS_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_05,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206100048
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNi8xMC8yMiAxMjozNywgSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIHdyb3RlOg0KPiBP
biA2LzEwLzIyIDExOjMxLCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4gT24gNi84LzIyIDE1
OjMzLCBKYW5pcyBTY2hvZXR0ZXJsLUdsYXVzY2ggd3JvdGU6DQo+Pj4gVGhlIHRyYW5zbGF0
aW9uLWV4Y2VwdGlvbiBpZGVudGlmaWNhdGlvbiAoVEVJRCkgY29udGFpbnMgaW5mb3JtYXRp
b24gdG8NCj4+PiBpZGVudGlmeSB0aGUgY2F1c2Ugb2YgY2VydGFpbiBwcm9ncmFtIGV4Y2Vw
dGlvbnMsIGluY2x1ZGluZyB0cmFuc2xhdGlvbg0KPj4+IGV4Y2VwdGlvbnMgb2NjdXJyaW5n
IGR1cmluZyBkeW5hbWljIGFkZHJlc3MgdHJhbnNsYXRpb24sIGFzIHdlbGwgYXMNCj4+PiBw
cm90ZWN0aW9uIGV4Y2VwdGlvbnMuDQo+Pj4gVGhlIG1lYW5pbmcgb2YgZmllbGRzIGluIHRo
ZSBURUlEIGlzIGNvbXBsZXgsIGRlcGVuZGluZyBvbiB0aGUgZXhjZXB0aW9uDQo+Pj4gb2Nj
dXJyaW5nIGFuZCB2YXJpb3VzIHBvdGVudGlhbGx5IGluc3RhbGxlZCBmYWNpbGl0aWVzLg0K
Pj4+DQo+Pj4gUmV3b3JrIHRoZSB0eXBlIGRlc2NyaWJpbmcgdGhlIFRFSUQsIGluIG9yZGVy
IHRvIGVhc2UgZGVjb2RpbmcuDQo+Pj4gQ2hhbmdlIHRoZSBleGlzdGluZyBjb2RlIGludGVy
cHJldGluZyB0aGUgVEVJRCBhbmQgZXh0ZW5kIGl0IHRvIHRha2UgdGhlDQo+Pj4gaW5zdGFs
bGVkIHN1cHByZXNzaW9uLW9uLXByb3RlY3Rpb24gZmFjaWxpdHkgaW50byBhY2NvdW50Lg0K
Pj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIDxzY2ds
QGxpbnV4LmlibS5jb20+DQo+Pj4gLS0tDQo+Pj4gIMKgIGxpYi9zMzkweC9hc20vaW50ZXJy
dXB0LmggfCA2MSArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0NCj4+PiAg
wqAgbGliL3MzOTB4L2ZhdWx0LmjCoMKgwqDCoMKgwqDCoMKgIHwgMzAgKysrKystLS0tLS0t
LS0tLS0tDQo+Pj4gIMKgIGxpYi9zMzkweC9mYXVsdC5jwqDCoMKgwqDCoMKgwqDCoCB8IDY1
ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KPj4+ICDCoCBsaWIv
czM5MHgvaW50ZXJydXB0LmPCoMKgwqDCoCB8wqAgMiArLQ0KPj4+ICDCoCBzMzkweC9lZGF0
LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDI2ICsrKysrKysrKystLS0tLS0NCj4+
PiAgwqAgNSBmaWxlcyBjaGFuZ2VkLCAxMTUgaW5zZXJ0aW9ucygrKSwgNjkgZGVsZXRpb25z
KC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvbGliL3MzOTB4L2FzbS9pbnRlcnJ1cHQuaCBi
L2xpYi9zMzkweC9hc20vaW50ZXJydXB0LmgNCj4+PiBpbmRleCBkOWFiMGJkNy4uM2NhNmJm
NzYgMTAwNjQ0DQo+Pj4gLS0tIGEvbGliL3MzOTB4L2FzbS9pbnRlcnJ1cHQuaA0KPj4+ICsr
KyBiL2xpYi9zMzkweC9hc20vaW50ZXJydXB0LmgNCj4+PiBAQCAtMjAsMjMgKzIwLDU2IEBA
DQo+Pj4gIMKgIMKgIHVuaW9uIHRlaWQgew0KPj4+ICDCoMKgwqDCoMKgIHVuc2lnbmVkIGxv
bmcgdmFsOw0KPj4+IC3CoMKgwqAgc3RydWN0IHsNCj4+PiAtwqDCoMKgwqDCoMKgwqAgdW5z
aWduZWQgbG9uZyBhZGRyOjUyOw0KPj4+IC3CoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25n
IGZldGNoOjE7DQo+Pj4gLcKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgc3RvcmU6MTsN
Cj4+PiAtwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyByZXNlcnZlZDo2Ow0KPj4+IC3C
oMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIGFjY19saXN0X3Byb3Q6MTsNCj4+PiAtwqDC
oMKgwqDCoMKgwqAgLyoNCj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAqIGRlcGVuZGluZyBvbiB0
aGUgZXhjZXB0aW9uIGFuZCB0aGUgaW5zdGFsbGVkIGZhY2lsaXRpZXMsDQo+Pj4gLcKgwqDC
oMKgwqDCoMKgwqAgKiB0aGUgbSBmaWVsZCBjYW4gaW5kaWNhdGUgc2V2ZXJhbCBkaWZmZXJl
bnQgdGhpbmdzLA0KPj4+IC3CoMKgwqDCoMKgwqDCoMKgICogaW5jbHVkaW5nIHdoZXRoZXIg
dGhlIGV4Y2VwdGlvbiB3YXMgdHJpZ2dlcmVkIGJ5IGEgTVZQRw0KPj4+IC3CoMKgwqDCoMKg
wqDCoMKgICogaW5zdHJ1Y3Rpb24sIG9yIHdoZXRoZXIgdGhlIGFkZHIgZmllbGQgaXMgbWVh
bmluZ2Z1bA0KPj4+IC3CoMKgwqDCoMKgwqDCoMKgICovDQo+Pj4gLcKgwqDCoMKgwqDCoMKg
IHVuc2lnbmVkIGxvbmcgbToxOw0KPj4+IC3CoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25n
IGFzY2VfaWQ6MjsNCj4+PiArwqDCoMKgIHVuaW9uIHsNCj4+PiArwqDCoMKgwqDCoMKgwqAg
LyogY29tbW9uIGZpZWxkcyBEQVQgZXhjICYgcHJvdGVjdGlvbiBleGMgKi8NCj4+PiArwqDC
oMKgwqDCoMKgwqAgc3RydWN0IHsNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1aW50
NjRfdCBhZGRywqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA6IDUyIC3CoCAwOw0KPj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHVpbnQ2NF90IGFjY19leGNfZl9zwqDCoMKgwqDCoMKgwqAg
OiA1NCAtIDUyOw0KDQpJJ2QgZWl0aGVyIG5hbWUgaXQgYWNjX2V4Y19mcyBvciBzcGVsbCBp
dCBvdXQgcHJvcGVybHkuDQoNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1aW50NjRf
dCBzaWRlX2VmZmVjdF9hY2PCoMKgwqAgOiA1NSAtIDU0Ow0KPj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHVpbnQ2NF90IC8qIHJlc2VydmVkICovwqDCoMKgwqDCoMKgwqAgOiA2MiAt
IDU1Ow0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVpbnQ2NF90IGFzY2VfaWTCoMKg
wqDCoMKgwqDCoCA6IDY0IC0gNjI7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIH07DQo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIC8qIERBVCBleGMgKi8NCj4+PiArwqDCoMKgwqDCoMKgwqAgc3RydWN0
IHsNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1aW50NjRfdCAvKiBwYWQgKi/CoMKg
wqDCoMKgwqDCoCA6IDYxIC3CoCAwOw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVp
bnQ2NF90IGRhdF9tb3ZlX3BhZ2XCoMKgwqDCoMKgwqDCoCA6IDYyIC0gNjE7DQo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIH07DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIHN1cHByZXNzaW9uIG9u
IHByb3RlY3Rpb24gKi8NCj4+PiArwqDCoMKgwqDCoMKgwqAgc3RydWN0IHsNCj4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB1aW50NjRfdCAvKiBwYWQgKi/CoMKgwqDCoMKgwqDCoCA6
IDYwIC3CoCAwOw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVpbnQ2NF90IHNvcF9h
Y2NfbGlzdMKgwqDCoMKgwqDCoMKgIDogNjEgLSA2MDsNCj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB1aW50NjRfdCBzb3BfdGVpZF9wcmVkaWN0YWJsZcKgwqDCoCA6IDYyIC0gNjE7
DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIH07DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIGVuaGFu
Y2VkIHN1cHByZXNzaW9uIG9uIHByb3RlY3Rpb24gMiAqLw0KPj4+ICvCoMKgwqDCoMKgwqDC
oCBzdHJ1Y3Qgew0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVpbnQ2NF90IC8qIHBh
ZCAqL8KgwqDCoMKgwqDCoMKgIDogNTYgLcKgIDA7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdWludDY0X3QgZXNvcDJfcHJvdF9jb2RlXzDCoMKgwqAgOiA1NyAtIDU2Ow0KPj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVpbnQ2NF90IC8qIHBhZCAqL8KgwqDCoMKgwqDC
oMKgIDogNjAgLSA1NzsNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1aW50NjRfdCBl
c29wMl9wcm90X2NvZGVfMcKgwqDCoCA6IDYxIC0gNjA7DQo+Pj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgdWludDY0X3QgZXNvcDJfcHJvdF9jb2RlXzLCoMKgwqAgOiA2MiAtIDYxOw0K
Pj4+ICvCoMKgwqDCoMKgwqDCoCB9Ow0KPj4NCj4+IFF1aXRlIG1lc3N5LCB3b3VsZCBpdCBi
ZSBtb3JlIHJlYWRhYmxlIHRvIHVuaW9uaXplIHRoZSBmaWVsZHMgdGhhdCBvdmVybGFwPw0K
PiANCj4gTm90IHN1cmUsIEkgcHJlZmVyIHRoaXMgYmVjYXVzZSBpdCByZWZsZWN0cyB0aGUg
c3RydWN0dXJlIG9mIHRoZSBQb1AsDQo+IHdoZXJlIHRoZXJlIGlzIGEgc2VjdGlvbiBmb3Ig
REFUIGV4Y2VwdGlvbnMsIFNPUCwgRVNPUDEsIEVTT1AyLg0KPiBJdCdzIG5vdCBleGFjdGx5
IGxpa2UgdGhpcyBpbiB0aGUgY29kZSBiZWNhdXNlIEkgZmFjdG9yZWQgb3V0IGNvbW1vbiBm
aWVsZHMsDQo+IGFuZCBJIHJlbW92ZWQgdGhlIHN0cnVjdCBmb3IgRVNPUDEgYmVjYXVzZSBp
dCB3YXMgbW9zdGx5IHJlZHVuZGFudCB3aXRoIFNPUC4NCg0KV2VsbCwgdGhlIHJlc3Qgb2Yg
dGhlIGNvZGUgaXMgcmVhZGFibGUgYW5kIEkgY2FuIGNvbXBhcmUgdGhlIHN0cnVjdCB0byAN
CnRoZSBQT1Agc28gSSdtIG9raXNoIHdpdGggdGhpcy4NCg0KPj4NCj4+PiAgwqDCoMKgwqDC
oCB9Ow0KPj4+ICDCoCB9Ow0KPj4+ICDCoCArZW51bSBwcm90X2NvZGUgew0KPj4+ICvCoMKg
wqAgUFJPVF9LRVlfTEFQLA0KPj4NCj4+IFRoYXQncyBrZXkgT1IgTEFQLCByaWdodD8NCj4g
DQo+IFllcywgZG8geW91IHdhbnQgbWUgdG8gbWFrZSB0aGF0IGV4cGxpY2l0Pw0KDQpZZXMN
Cg0KPj4NCj4+PiArwqDCoMKgIFBST1RfREFULA0KPj4+ICvCoMKgwqAgUFJPVF9LRVksDQo+
Pj4gK8KgwqDCoCBQUk9UX0FDQ19MSVNULA0KPj4+ICvCoMKgwqAgUFJPVF9MQVAsDQo+Pj4g
K8KgwqDCoCBQUk9UX0lFUCwNCj4+PiArfTsNCj4+PiArDQo+Pg0KPj4gWWVzLCBJIGxpa2Ug
dGhhdCBtb3JlIHRoYW4gbXkgcXVpY2sgZml4ZXMgOi0pDQo+Pg0KPj4+ICtzdGF0aWMgdm9p
ZCBwcmludF9kZWNvZGVfcGdtX3Byb3QodW5pb24gdGVpZCB0ZWlkLCBib29sIGRhdCkNCj4+
PiArew0KPj4+ICvCoMKgwqAgc3dpdGNoIChnZXRfc3VwcF9vbl9wcm90X2ZhY2lsaXR5KCkp
IHsNCj4+PiArwqDCoMKgIGNhc2UgU09QX05PTkU6DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIHBy
aW50ZigiVHlwZTogP1xuIik7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+ICvC
oMKgwqAgY2FzZSBTT1BfQkFTSUM6DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICh0ZWlkLnNv
cF90ZWlkX3ByZWRpY3RhYmxlICYmIGRhdCAmJiB0ZWlkLnNvcF9hY2NfbGlzdCkNCj4+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcmludGYoIlR5cGU6IEFDQ1xuIik7DQo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIGVsc2UNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcmludGYo
IlR5cGU6ID9cbiIpOw0KPj4+ICvCoMKgwqDCoMKgwqDCoCBicmVhazsNCj4+DQo+PiBJJ20g
d29uZGVyaW5nIGlmIHdlIHNob3VsZCBjdXQgb2ZmIHRoZSB0d28gcG9zc2liaWxpdGllcyBh
Ym92ZSB0byBtYWtlIGl0IGEgYml0IG1vcmUgc2FuZS4gVGhlIFNPUCBmYWNpbGl0eSBpcyBh
Ym91dCBteSBhZ2Ugbm93IGFuZCBFU09QMSBoYXMgYmVlbiBpbnRyb2R1Y2VkIHdpdGggejEw
IGlmIEknbSBub3QgbWlzdGFrZW4gc28gaXQncyBub3QgeW91bmcgZWl0aGVyLg0KPiANCj4g
U28NCj4gDQo+IGNhc2UgU09QX05PTkU6DQo+IGNhc2UgU09QX0JBU0lDOg0KPiAJYXNzZXJ0
KGZhbHNlKTsNCj4gDQo+ID8NCg0KSSdkIGNoZWNrIChlKXNvcCBvbiBpbml0aWFsaXphdGlv
biBhbmQgYWJvcnQgZWFybHkgc28gd2UgbmV2ZXIgbmVlZCB0byANCndvcnJ5IGFib3V0IGl0
IGluIG90aGVyIGZpbGVzLg0KDQo+IAkNCj4+DQo+PiBEbyB3ZSBoYXZlIHRlc3RzIHRoYXQg
cmVxdWlyZSBTT1Avbm8tU09QPw0KPiANCj4gTm8sIGp1c3QgZ29pbmcgZm9yIGNvcnJlY3Ru
ZXNzLg0KPiANCg0K
