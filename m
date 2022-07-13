Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01195731EF
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 11:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiGMJCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 05:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbiGMJCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 05:02:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9916FF2E1D;
        Wed, 13 Jul 2022 02:01:44 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D8paQT019865;
        Wed, 13 Jul 2022 09:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BLKBVkWEru6V4WEFaksNPeWnPKZk0hKmbPuo+7ppVYk=;
 b=aZslUTFlfL82jmaI98cYn95/MwpeQbJF16KDUmKL+iChFx0LVW4qufXNQ7XVD3vTrwC0
 PLf6nYLjeNzJqzVoa/3/zaFH6ooMfQsBjddIz7ZbEu6/qvU2lAto5XqmmsX0H8Ixud1f
 p3rpU7JGDiuFACL5ND5RGrM1NdwImtUeYlnannaulcVYU/VaoO78PnEVaKBzxrNgllBP
 xWpW2IZAfRfE8dtHTNlxbtWG2rfMOYyqdX50RIcOc5f98toGMGw+HOzXrgAAsFpabaRW
 92L3UH4BYF2xntMTVxR79/NHsTtmAG3ORry7s4wKLfvIQPZUaiXSgOaETycF7K4lXMAS Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9twmr801-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 09:01:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26D8qUrs025239;
        Wed, 13 Jul 2022 09:01:43 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9twmr7xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 09:01:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26D8rbKS017568;
        Wed, 13 Jul 2022 09:01:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3h8ncngsu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 09:01:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26D91bNB13435360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 09:01:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D5654204C;
        Wed, 13 Jul 2022 09:01:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5827042041;
        Wed, 13 Jul 2022 09:01:36 +0000 (GMT)
Received: from [9.145.184.105] (unknown [9.145.184.105])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 09:01:36 +0000 (GMT)
Message-ID: <7cd9cf5b-d91e-f676-48e9-abbea94d62e0@linux.ibm.com>
Date:   Wed, 13 Jul 2022 11:01:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
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
 <20220711084148.25017-4-pmorel@linux.ibm.com>
 <58016efc-9053-b743-05d6-4ace4dcdc2a8@linux.ibm.com>
 <a268d8b7-bbd8-089d-896c-e4e3e4167e46@linux.ibm.com>
 <87c5514b-4971-b283-912c-573ab1b4d636@linux.ibm.com>
 <0c73fc23-2cfe-86c6-b91d-77a73bc435b4@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v12 3/3] KVM: s390: resetting the Topology-Change-Report
In-Reply-To: <0c73fc23-2cfe-86c6-b91d-77a73bc435b4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0UBrVbUFkT4NAxLSfsnR92IqEQxZ-9Qp
X-Proofpoint-ORIG-GUID: uFXz20BPwkZR8DSIEup2CVKFhabn0Qz4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNy8xMi8yMiAxMzoxNywgUGllcnJlIE1vcmVsIHdyb3RlOg0KPiANCj4gDQo+IE9uIDcv
MTIvMjIgMTA6NDcsIEphbmlzIFNjaG9ldHRlcmwtR2xhdXNjaCB3cm90ZToNCj4+IE9uIDcv
MTIvMjIgMDk6MjQsIFBpZXJyZSBNb3JlbCB3cm90ZToNCj4+Pg0KPj4+DQo+Pj4gT24gNy8x
MS8yMiAxNToyMiwgSmFuaXMgU2Nob2V0dGVybC1HbGF1c2NoIHdyb3RlOg0KPj4+PiBPbiA3
LzExLzIyIDEwOjQxLCBQaWVycmUgTW9yZWwgd3JvdGU6DQo+Pj4+PiBEdXJpbmcgYSBzdWJz
eXN0ZW0gcmVzZXQgdGhlIFRvcG9sb2d5LUNoYW5nZS1SZXBvcnQgaXMgY2xlYXJlZC4NCj4+
Pj4+DQo+Pj4+PiBMZXQncyBnaXZlIHVzZXJsYW5kIHRoZSBwb3NzaWJpbGl0eSB0byBjbGVh
ciB0aGUgTVRDUiBpbiB0aGUgY2FzZQ0KPj4+Pj4gb2YgYSBzdWJzeXN0ZW0gcmVzZXQuDQo+
Pj4+Pg0KPj4+Pj4gVG8gbWlncmF0ZSB0aGUgTVRDUiwgd2UgZ2l2ZSB1c2VybGFuZCB0aGUg
cG9zc2liaWxpdHkgdG8NCj4+Pj4+IHF1ZXJ5IHRoZSBNVENSIHN0YXRlLg0KPj4+Pj4NCj4+
Pj4+IFdlIGluZGljYXRlIEtWTSBzdXBwb3J0IGZvciB0aGUgQ1BVIHRvcG9sb2d5IGZhY2ls
aXR5IHdpdGggYSBuZXcNCj4+Pj4+IEtWTSBjYXBhYmlsaXR5OiBLVk1fQ0FQX1MzOTBfQ1BV
X1RPUE9MT0dZLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFBpZXJyZSBNb3JlbCA8
cG1vcmVsQGxpbnV4LmlibS5jb20+DQo+Pj4+DQo+Pj4+IFJldmlld2VkLWJ5OiBKYW5pcyBT
Y2hvZXR0ZXJsLUdsYXVzY2ggPHNjZ2xAbGludXguaWJtLmNvbT4NCj4+Pj4NCj4+Pg0KPj4+
IFRoYW5rcyENCj4+Pg0KPj4+PiBTZWUgbml0cy9jb21tZW50cyBiZWxvdy4NCj4+Pj4NCj4+
Pj4+IC0tLQ0KPj4+Pj4gICDCoCBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3TCoMKg
IHwgMjUgKysrKysrKysrKysrKysNCj4+Pj4+ICAgwqAgYXJjaC9zMzkwL2luY2x1ZGUvdWFw
aS9hc20va3ZtLmggfMKgIDEgKw0KPj4+Pj4gICDCoCBhcmNoL3MzOTAva3ZtL2t2bS1zMzkw
LmPCoMKgwqDCoMKgwqDCoMKgIHwgNTYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4+Pj4+ICAgwqAgaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5owqDCoMKgwqDCoMKgwqDC
oCB8wqAgMSArDQo+Pj4+PiAgIMKgIDQgZmlsZXMgY2hhbmdlZCwgODMgaW5zZXJ0aW9ucygr
KQ0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2Fw
aS5yc3QgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCj4+Pj4+IGluZGV4IDEx
ZTAwYTQ2YzYxMC4uNWUwODYxMjVkOGFkIDEwMDY0NA0KPj4+Pj4gLS0tIGEvRG9jdW1lbnRh
dGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+Pj4+PiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQv
a3ZtL2FwaS5yc3QNCj4+Pj4+IEBAIC03OTU2LDYgKzc5NTYsMzEgQEAgc2hvdWxkIGFkanVz
dCBDUFVJRCBsZWFmIDB4QSB0byByZWZsZWN0IHRoYXQgdGhlIFBNVSBpcyBkaXNhYmxlZC4N
Cj4+Pj4+ICAgwqAgV2hlbiBlbmFibGVkLCBLVk0gd2lsbCBleGl0IHRvIHVzZXJzcGFjZSB3
aXRoIEtWTV9FWElUX1NZU1RFTV9FVkVOVCBvZg0KPj4+Pj4gICDCoCB0eXBlIEtWTV9TWVNU
RU1fRVZFTlRfU1VTUEVORCB0byBwcm9jZXNzIHRoZSBndWVzdCBzdXNwZW5kIHJlcXVlc3Qu
DQo+Pj4+PiAgIMKgICs4LjM3IEtWTV9DQVBfUzM5MF9DUFVfVE9QT0xPR1kNCj4+Pj4+ICst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+Pj4+ICsNCj4+Pj4+ICs6Q2FwYWJp
bGl0eTogS1ZNX0NBUF9TMzkwX0NQVV9UT1BPTE9HWQ0KPj4+Pj4gKzpBcmNoaXRlY3R1cmVz
OiBzMzkwDQo+Pj4+PiArOlR5cGU6IHZtDQo+Pj4+PiArDQo+Pj4+PiArVGhpcyBjYXBhYmls
aXR5IGluZGljYXRlcyB0aGF0IEtWTSB3aWxsIHByb3ZpZGUgdGhlIFMzOTAgQ1BVIFRvcG9s
b2d5DQo+Pj4+PiArZmFjaWxpdHkgd2hpY2ggY29uc2lzdCBvZiB0aGUgaW50ZXJwcmV0YXRp
b24gb2YgdGhlIFBURiBpbnN0cnVjdGlvbiBmb3INCj4+Pj4+ICt0aGUgZnVuY3Rpb24gY29k
ZSAyIGFsb25nIHdpdGggaW50ZXJjZXB0aW9uIGFuZCBmb3J3YXJkaW5nIG9mIGJvdGggdGhl
DQo+Pj4+PiArUFRGIGluc3RydWN0aW9uIHdpdGggZnVuY3Rpb24gY29kZXMgMCBvciAxIGFu
ZCB0aGUgU1RTSSgxNSwxLHgpDQo+Pj4+DQo+Pj4+IElzIHRoZSBhcmNoaXRlY3R1cmUgYWxs
b3dlZCB0byBleHRlbmQgU1RTSSB3aXRob3V0IGEgZmFjaWxpdHk/DQo+Pj4+IElmIHNvLCBp
ZiB3ZSBzYXkgaGVyZSB0aGF0IFNUU0kgMTUuMS54IGlzIHBhc3NlZCB0byB1c2VyIHNwYWNl
LCB0aGVuDQo+Pj4+IEkgdGhpbmsgd2Ugc2hvdWxkIGhhdmUgYQ0KPj4+Pg0KPj4+PiBpZiAo
c2VsMSAhPSAxKQ0KPj4+PiAgIMKgwqDCoMKgZ290byBvdXRfbm9fZGF0YTsNCj4+Pj4NCj4+
Pj4gb3IgbWF5YmUgZXZlbg0KPj4+Pg0KPj4+PiBpZiAoc2VsMSAhPSAxIHx8IHNlbDIgPCAy
IHx8IHNlbDIgPiA2KQ0KPj4+PiAgIMKgwqDCoMKgZ290byBvdXRfbm9fZGF0YTsNCj4+Pj4N
Cj4+Pj4gaW4gcHJpdi5jDQo+Pj4NCj4+PiBJIGFtIG5vdCBhIGJpZyBmYW4gb2YgZG9pbmcg
ZXZlcnl0aGluZyBpbiB0aGUga2VybmVsLg0KPj4+IEhlcmUgd2UgaGF2ZSBubyBwZXJmb3Jt
YW5jZSBpc3N1ZSBzaW5jZSBpdCBpcyBhbiBlcnJvciBvZiB0aGUgZ3Vlc3QgaWYgaXQgc2Vu
ZHMgYSB3cm9uZyBzZWxlY3Rvci4NCj4+Pg0KPj4gSSBhZ3JlZSwgYnV0IEkgZGlkbid0IHN1
Z2dlc3QgaXQgZm9yIHBlcmZvcm1hbmNlIHJlYXNvbnMuDQo+IA0KPiBZZXMsIGFuZCB0aGF0
IGlzIHdoeSBJIGRvIG5vdCBhZ3JlZSA7KQ0KPiANCj4+IEkgd2FzIHRoaW5raW5nIGFib3V0
IGZ1dHVyZSBwcm9vZmluZywgdGhhdCBpcyBpZiB0aGUgYXJjaGl0ZWN0dXJlIGlzIGV4dGVu
ZGVkLg0KPj4gV2UgZG9uJ3Qga25vdyBpZiBmdXR1cmUgZXh0ZW5zaW9ucyBhcmUgYmVzdCBo
YW5kbGVkIGluIHRoZSBrZXJuZWwgb3IgdXNlciBzcGFjZSwNCj4+IHNvIGlmIHdlIHByZXZl
bnQgaXQgZnJvbSBnb2luZyB0byB1c2VyIHNwYWNlLCB3ZSBjYW4gZGVmZXIgdGhlIGRlY2lz
aW9uIHRvIHdoZW4gd2Uga25vdyBtb3JlLg0KPiANCj4gSWYgZnV0dXJlIGV4dGVuc2lvbnMg
YXJlIGJldHRlciBoYW5kbGUgaW4ga2VybmVsIHdlIHdpbGwgaGFuZGxlIHRoZW0gaW4NCj4g
a2VybmVsLCBvYnZpb3VzbHksIGluIHRoaXMgY2FzZSB3ZSB3aWxsIG5lZWQgYSBwYXRjaC4N
Cj4gDQo+IElmIGl0IGlzIG5vdCBiZXR0ZXIgaGFuZGxlIGluIGtlcm5lbCB3ZSB3aWxsIGhh
bmRsZSB0aGUgZXh0ZW5zaW9ucyBpbg0KPiB1c2VybGFuZCBhbmQgd2Ugd2lsbCBub3QgbmVl
ZCBhIGtlcm5lbCBwYXRjaCBtYWtpbmcgdGhlIHVwZGF0ZSBvZiB0aGUNCj4gdmlydHVhbCBh
cmNoaXRlY3R1cmUgZWFzaWVyIGFuZCBmYXN0ZXIuDQo+IA0KPiBJZiB3ZSBwcm9oaWJpdCB0
aGUgZXh0ZW5zaW9ucyBpbiBrZXJuZWwgd2Ugd2lsbCBuZWVkIGEga2VybmVsIHBhdGNoIGlu
DQo+IGJvdGggY2FzZXMgYW5kIGEgdXNlcmxhbmQgcGF0Y2ggaWYgaXQgaXMgbm90IGNvbXBs
ZXRlbHkgaGFuZGxlZCBpbiBrZXJuZWwuDQo+IA0KPiBJbiB1c2VybGFuZCB3ZSBjaGVjayBh
bnkgd3Jvbmcgc2VsZWN0b3IgYmVmb3JlIHRoZSBpbnN0cnVjdGlvbiBnb2VzIGJhY2sNCj4g
dG8gdGhlIGd1ZXN0Lg0KDQpJIG9wdCBmb3IgcGFzc2luZyB0aGUgbG93ZXIgc2VsZWN0b3Jz
IGRvd24gZm9yIFFFTVUgdG8gaGFuZGxlLg0KDQo+IA0KPj4gQnV0IHRoYXQncyBvbmx5IHJl
bGV2YW50IGlmIFNUU0kgY2FuIGJlIGV4dGVuZGVkIHdpdGhvdXQgYSBjYXBhYmlsaXR5LCB3
aGljaCBpcyB3aHkgSSBhc2tlZCBhYm91dCB0aGF0Lg0KPiANCj4gTG9naWNhbHkgYW55IGNo
YW5nZSwgZXh0ZW5zaW9uLCBpbiB0aGUgYXJjaGl0ZWN0dXJlIHNob3VsZCBiZSBzaWduYWxl
ZA0KPiBieSBhIGZhY2lsaXR5IGJpdCBvciBzb21ldGhpbmcuDQo+IA0KPj4NCj4+PiBFdmVu
IHRlc3RpbmcgdGhlIGZhY2lsaXR5IG9yIFBWIGluIHRoZSBrZXJuZWwgaXMgZm9yIG15IG9w
aW5pb24gYXJndWFibGUgaW4gdGhlIGNhc2Ugd2UgZG8gbm90IGRvIGFueSB0cmVhdG1lbnQg
aW4gdGhlIGtlcm5lbC4NCg0KVGhhdCdzIGFjdHVhbGx5IGEgZ29vZCBwb2ludC4NCg0KTmV3
IGluc3RydWN0aW9uIGludGVyY2VwdGlvbnMgZm9yIFBWIHdpbGwgbmVlZCB0byBiZSBlbmFi
bGVkIGJ5IEtWTSB2aWEgDQphIHN3aXRjaCBzb21ld2hlcmUgc2luY2UgdGhlIFVWIGNhbid0
IHJlbHkgb24gdGhlIGZhY3QgdGhhdCBLVk0gd2lsbCANCmNvcnJlY3RseSBoYW5kbGUgaXQg
d2l0aG91dCBhbiBlbmFibGVtZW50Lg0KDQoNClNvIHBsZWFzZSByZW1vdmUgdGhlIHB2IGNo
ZWNrDQoNCj4+Pg0KPj4+IEkgZG8gbm90IHNlZSB3aGF0IGl0IGJyaW5ncyB0byB1cywgaXQg
aW5jcmVhc2UgdGhlIExPQ3MgYW5kIG1ha2VzIHRoZSBpbXBsZW1lbnRhdGlvbiBsZXNzIGVh
c3kgdG8gZXZvbHZlLg0KPj4+DQo+Pj4NCj4+Pj4NCj4+Pj4+ICtpbnN0cnVjdGlvbiB0byB0
aGUgdXNlcmxhbmQgaHlwZXJ2aXNvci4NCj4+Pj4+ICsNCj4+Pj4+ICtUaGUgc3RmbGUgZmFj
aWxpdHkgMTEsIENQVSBUb3BvbG9neSBmYWNpbGl0eSwgc2hvdWxkIG5vdCBiZSBpbmRpY2F0
ZWQNCj4+Pj4+ICt0byB0aGUgZ3Vlc3Qgd2l0aG91dCB0aGlzIGNhcGFiaWxpdHkuDQo+Pj4+
PiArDQo+Pj4+PiArV2hlbiB0aGlzIGNhcGFiaWxpdHkgaXMgcHJlc2VudCwgS1ZNIHByb3Zp
ZGVzIGEgbmV3IGF0dHJpYnV0ZSBncm91cA0KPj4+Pj4gK29uIHZtIGZkLCBLVk1fUzM5MF9W
TV9DUFVfVE9QT0xPR1kuDQo+Pj4+PiArVGhpcyBuZXcgYXR0cmlidXRlIGFsbG93cyB0byBn
ZXQsIHNldCBvciBjbGVhciB0aGUgTW9kaWZpZWQgQ2hhbmdlDQo+Pj4+DQo+Pj4+IGdldCBv
ciBzZXQsIG5vdyB0aGF0IHRoZXJlIGlzIG5vIGV4cGxpY2l0IGNsZWFyIGFueW1vcmUuDQo+
Pj4NCj4+PiBZZXMgbm93IGl0IGlzIGEgc2V0IHRvIDAgYnV0IHRoZSBhY3Rpb24gb2YgY2xl
YXJpbmcgcmVtYWlucy4NCg0KWWVzDQoNCj4+Pg0KPj4+Pg0KPj4+Pj4gK1RvcG9sb2d5IFJl
cG9ydCAoTVRDUikgYml0IG9mIHRoZSBTQ0EgdGhyb3VnaCB0aGUga3ZtX2RldmljZV9hdHRy
DQo+Pj4+PiArc3RydWN0dXJlLj4gKw0KPj4+Pj4gK1doZW4gZ2V0dGluZyB0aGUgTW9kaWZp
ZWQgQ2hhbmdlIFRvcG9sb2d5IFJlcG9ydCB2YWx1ZSwgdGhlIGF0dHItPmFkZHINCj4+Pj4N
Cj4+Pj4gV2hlbiBnZXR0aW5nL3NldHRpbmcgdGhlLi4uDQo+Pj4+DQo+Pj4+PiArbXVzdCBw
b2ludCB0byBhIGJ5dGUgd2hlcmUgdGhlIHZhbHVlIHdpbGwgYmUgc3RvcmVkLg0KPj4+Pg0K
Pj4+PiAuLi4gd2lsbCBiZSBzdG9yZWQvcmV0cmlldmVkIGZyb20uDQo+Pj4NCj4+PiBPSw0K
Pj4NCj4+IFdhaXQgbm8sIEkgZGlkbid0IGdldCBob3cgdGhhdCB3b3Jrcy4gWW91J3JlIHBh
c3NpbmcgdGhlIHZhbHVlIHZpYSBhdHRyLT5hdHRyLCBub3QgcmVhZGluZyBpdCBmcm9tIGFk
ZHIuDQo+IA0KPiA6KSBPSw0KPiANCj4+Pg0KPj4+DQo+Pj4+PiArDQo+Pj4+PiAgIMKgIDku
IEtub3duIEtWTSBBUEkgcHJvYmxlbXMNCj4+Pj4+ICAgwqAgPT09PT09PT09PT09PT09PT09
PT09PT09PQ0KPj4+Pj4gICDCoCBkaWZmIC0tZ2l0IGEvYXJjaC9zMzkwL2luY2x1ZGUvdWFw
aS9hc20va3ZtLmggYi9hcmNoL3MzOTAvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPj4+Pj4g
aW5kZXggN2E2YjE0ODc0ZDY1Li5hNzNjZjAxYTE2MDYgMTAwNjQ0DQo+Pj4+PiAtLS0gYS9h
cmNoL3MzOTAvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPj4+Pj4gKysrIGIvYXJjaC9zMzkw
L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4+Pj4+IEBAIC03NCw2ICs3NCw3IEBAIHN0cnVj
dCBrdm1fczM5MF9pb19hZGFwdGVyX3JlcSB7DQo+Pj4+PiAgIMKgICNkZWZpbmUgS1ZNX1Mz
OTBfVk1fQ1JZUFRPwqDCoMKgwqDCoMKgwqAgMg0KPj4+Pj4gICDCoCAjZGVmaW5lIEtWTV9T
MzkwX1ZNX0NQVV9NT0RFTMKgwqDCoMKgwqDCoMKgIDMNCj4+Pj4+ICAgwqAgI2RlZmluZSBL
Vk1fUzM5MF9WTV9NSUdSQVRJT07CoMKgwqDCoMKgwqDCoCA0DQo+Pj4+PiArI2RlZmluZSBL
Vk1fUzM5MF9WTV9DUFVfVE9QT0xPR1nCoMKgwqAgNQ0KPj4+Pj4gICDCoCDCoCAvKiBrdm0g
YXR0cmlidXRlcyBmb3IgbWVtX2N0cmwgKi8NCj4+Pj4+ICAgwqAgI2RlZmluZSBLVk1fUzM5
MF9WTV9NRU1fRU5BQkxFX0NNTUHCoMKgwqAgMA0KPj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gv
czM5MC9rdm0va3ZtLXMzOTAuYyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPj4+Pj4g
aW5kZXggNzA0MzZiZmZmNTNhLi5iMThlMGI5NDBiMjYgMTAwNjQ0DQo+Pj4+PiAtLS0gYS9h
cmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMNCj4+Pj4+ICsrKyBiL2FyY2gvczM5MC9rdm0va3Zt
LXMzOTAuYw0KPj4+Pj4gQEAgLTYwNiw2ICs2MDYsOSBAQCBpbnQga3ZtX3ZtX2lvY3RsX2No
ZWNrX2V4dGVuc2lvbihzdHJ1Y3Qga3ZtICprdm0sIGxvbmcgZXh0KQ0KPj4+Pj4gICDCoMKg
wqDCoMKgIGNhc2UgS1ZNX0NBUF9TMzkwX1BST1RFQ1RFRDoNCj4+Pj4+ICAgwqDCoMKgwqDC
oMKgwqDCoMKgIHIgPSBpc19wcm90X3ZpcnRfaG9zdCgpOw0KPj4+Pj4gICDCoMKgwqDCoMKg
wqDCoMKgwqAgYnJlYWs7DQo+Pj4+PiArwqDCoMKgIGNhc2UgS1ZNX0NBUF9TMzkwX0NQVV9U
T1BPTE9HWToNCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCByID0gdGVzdF9mYWNpbGl0eSgxMSk7
DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+Pj4+PiAgIMKgwqDCoMKgwqAgZGVm
YXVsdDoNCj4+Pj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgIHIgPSAwOw0KPj4+Pj4gICDCoMKg
wqDCoMKgIH0NCj4+Pj4+IEBAIC04MTcsNiArODIwLDIwIEBAIGludCBrdm1fdm1faW9jdGxf
ZW5hYmxlX2NhcChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fZW5hYmxlX2NhcCAqY2Fw
KQ0KPj4+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqAgaWNwdF9vcGVyZXhjX29uX2FsbF92Y3B1
cyhrdm0pOw0KPj4+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqAgciA9IDA7DQo+Pj4+PiAgIMKg
wqDCoMKgwqDCoMKgwqDCoCBicmVhazsNCj4+Pj4+ICvCoMKgwqAgY2FzZSBLVk1fQ0FQX1Mz
OTBfQ1BVX1RPUE9MT0dZOg0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHIgPSAtRUlOVkFMOw0K
Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIG11dGV4X2xvY2soJmt2bS0+bG9jayk7DQo+Pj4+PiAr
wqDCoMKgwqDCoMKgwqAgaWYgKGt2bS0+Y3JlYXRlZF92Y3B1cykgew0KPj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgciA9IC1FQlVTWTsNCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCB9
IGVsc2UgaWYgKHRlc3RfZmFjaWxpdHkoMTEpKSB7DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBzZXRfa3ZtX2ZhY2lsaXR5KGt2bS0+YXJjaC5tb2RlbC5mYWNfbWFzaywgMTEp
Ow0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0X2t2bV9mYWNpbGl0eShrdm0t
PmFyY2gubW9kZWwuZmFjX2xpc3QsIDExKTsNCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHIgPSAwOw0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIH0NCj4+Pj4+ICvCoMKgwqDCoMKg
wqDCoCBtdXRleF91bmxvY2soJmt2bS0+bG9jayk7DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAg
Vk1fRVZFTlQoa3ZtLCAzLCAiRU5BQkxFOiBDQVBfUzM5MF9DUFVfVE9QT0xPR1kgJXMiLA0K
Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByID8gIihub3QgYXZhaWxhYmxlKSIg
OiAiKHN1Y2Nlc3MpIik7DQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+Pj4+PiAg
IMKgwqDCoMKgwqAgZGVmYXVsdDoNCj4+Pj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgIHIgPSAt
RUlOVkFMOw0KPj4+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+Pj4+PiBAQCAt
MTcxNyw2ICsxNzM0LDM2IEBAIHN0YXRpYyB2b2lkIGt2bV9zMzkwX3VwZGF0ZV90b3BvbG9n
eV9jaGFuZ2VfcmVwb3J0KHN0cnVjdCBrdm0gKmt2bSwgYm9vbCB2YWwpDQo+Pj4+PiAgIMKg
wqDCoMKgwqAgcmVhZF91bmxvY2soJmt2bS0+YXJjaC5zY2FfbG9jayk7DQo+Pj4+PiAgIMKg
IH0NCj4+Pj4+ICAgwqAgK3N0YXRpYyBpbnQga3ZtX3MzOTBfc2V0X3RvcG9sb2d5KHN0cnVj
dCBrdm0gKmt2bSwgc3RydWN0IGt2bV9kZXZpY2VfYXR0ciAqYXR0cikNCj4+Pj4NCj4+Pj4g
a3ZtX3MzOTBfc2V0X3RvcG9sb2d5X2NoYW5nZWQgbWF5YmU/DQo+Pj4+IGt2bV9zMzkwX2dl
dF90b3BvbG9neV9jaGFuZ2VkIGJlbG93IHRoZW4uDQoNCmt2bV9zMzkwX3NldF90b3BvbG9n
eV9jaGFuZ2VfaW5kaWNhdGlvbg0KDQpJdCdzIGxvbmcgYnV0IGl0J3MgcmFyZWx5IHVzZWQu
DQpNYXliZSBzaG9ydGVuIHRvcG9sb2d5IHRvICJ0b3BvIg0KDQpbLi5dDQo+Pj4+IEkgZG9u
J3QgdGhpbmsgeW91IG5lZWQgdGhlIFJFQURfT05DRSBhbnltb3JlLCBub3cgdGhhdCB0aGVy
ZSBpcyBhIGxvY2sgaXQgc2hvdWxkIGFjdCBhcyBhIGNvbXBpbGUgYmFycmllci4NCj4+Pg0K
Pj4+IEkgdGhpbmsgeW91IGFyZSByaWdodC4NCj4+Pg0KPj4+Pj4gK8KgwqDCoCByZWFkX3Vu
bG9jaygma3ZtLT5hcmNoLnNjYV9sb2NrKTsNCj4+Pj4+ICvCoMKgwqAgdG9wbyA9IHV0aWxp
dHkubXRjcjsNCj4+Pj4+ICsNCj4+Pj4+ICvCoMKgwqAgaWYgKGNvcHlfdG9fdXNlcigodm9p
ZCBfX3VzZXIgKilhdHRyLT5hZGRyLCAmdG9wbywgc2l6ZW9mKHRvcG8pKSkNCj4+Pj4NCj4+
Pj4gV2h5IHZvaWQgbm90IHU4Pw0KPj4+DQo+Pj4gSSBsaWtlIHRvIHNheSB3ZSB3cml0ZSBv
biAidG9wbyIgd2l0aCB0aGUgc2l6ZSBvZiAidG9wbyIuDQo+Pj4gU28gd2UgZG8gbm90IG5l
ZWQgdG8gdmVyaWZ5IHRoZSBlZmZlY3RpdmUgc2l6ZSBvZiB0b3BvLg0KPj4+IEJ1dCBJIHVu
ZGVyc3RhbmQsIGl0IGlzIGEgVUFQSSwgc2V0dGluZyB1OCBpbiB0aGUgY29weV90b191c2Vy
IG1ha2VzIHNlbnNlIHRvby4NCj4+PiBGb3IgbXkgcGVyc29uYWwgb3BpbmlvbiwgSSB3b3Vs
ZCBoYXZlIHByZWZlciB0aGF0IHVzZXJsYW5kIHRlbGwgdXMgdGhlIHNpemUgaXQgYXdhaXRz
IGV2ZW4gaGVyZSwgZm9yIHRoaXMgc3BlY2lhbCBjYXNlLCBzaW5jZSB3ZSB1c2UgYSBieXRl
LCB3ZSBjYW4gbm90IGRvIHJlYWxseSB3cm9uZy4NCj4+IFlvdSdyZSByaWdodCwgaXQgZG9l
c24ndCBtYWtlIGEgZGlmZmVyZW5jZS4NCj4+IFdoYXQgYWJvdXQgZG9pbmcgcHV0X3VzZXIo
dG9wbywgKHU4ICopYXR0ci0+YWRkcikpLCBzZWVtcyBtb3JlIHN0cmFpZ2h0IGZvcndhcmQu
DQo+IA0KPiBPSw0KDQoodTggX191c2VyICopDQoNCkFsd2F5cyBnbyB0aGUgZXhwbGljaXQg
cm91dGUgaWYgcG9zc2libGUNCg0KPiANCj4+Pg0KPj4+Pg0KPj4+Pj4gK8KgwqDCoMKgwqDC
oMKgIHJldHVybiAtRUZBVUxUOw0KPj4+Pj4gKw0KPj4+Pj4gK8KgwqDCoCByZXR1cm4gMDsN
Cj4+Pj4+ICt9DQo+Pj4+PiArDQo+Pj4+IFsuLi5dDQo+Pj4+DQo+Pj4NCj4+DQo+IA0KDQo=

