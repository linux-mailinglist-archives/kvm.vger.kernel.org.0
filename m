Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7064D5280C7
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbiEPJXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239549AbiEPJXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:23:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CBADFD0;
        Mon, 16 May 2022 02:23:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G7jQSL019090;
        Mon, 16 May 2022 09:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uN0fLTrUPxsKWmiScCpE1OOmTzBB+2Don5+gpCS8NNw=;
 b=Oz9sjDRmRhMiB9BMKMt8s6irCqDFdLs8LEwOq8Vwy4kgDCXM/JV/oauVt+m/qgaNNXRK
 yKmQLygk9/By1ghskURFO723jEJ4tyLwRw1xxw4kVmTC2A9ZfZGPcWNNLKB5YGRQ44dk
 Edc+5P2pgvJLVbWk6t6SgJQBtopQbrEX7JrAqzuMoPAMS3vAaNA6bnRqNFqyasUiIj84
 +Rh9RzZFfROXUoZcokXoCtQko7rNpcIq/YDyAAtk1wNHwN8lpf/4NyQ2Mc9Qtgu/Sjx4
 EHJsZv1lTDz7idlTsWZ1e0/L7ZWMVD3GEZLe+s0/xp/POE6hsOGCDciQlouj6zuNWwrU ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jgm1st1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:23:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G9LcFT006303;
        Mon, 16 May 2022 09:23:03 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jgm1ssq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:23:03 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G9IVYe003777;
        Mon, 16 May 2022 09:23:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428stvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:23:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G9Mw0n46793112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:22:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4E8D4C04A;
        Mon, 16 May 2022 09:22:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D5B74C040;
        Mon, 16 May 2022 09:22:58 +0000 (GMT)
Received: from [9.145.154.60] (unknown [9.145.154.60])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:22:58 +0000 (GMT)
Message-ID: <342c9b37-2c1a-ce47-f095-304c056ed814@linux.ibm.com>
Date:   Mon, 16 May 2022 11:22:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: uv-host: Add access checks for
 donated memory
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-2-frankja@linux.ibm.com>
 <c762eb07d227fd161c3dec0d5e1d3b302ed28007.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <c762eb07d227fd161c3dec0d5e1d3b302ed28007.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LLOgs-vXa_9G9tfLND7iOFsr3gAWCeN4
X-Proofpoint-ORIG-GUID: j8OMysUHoWim_PRZqWTUug6L-0dDxKK1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_05,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxscore=0 spamscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160049
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNS8xNi8yMiAxMDoyMSwgTmljbyBCb2VociB3cm90ZToNCj4gT24gRnJpLCAyMDIyLTA1
LTEzIGF0IDA5OjUwICswMDAwLCBKYW5vc2NoIEZyYW5rIHdyb3RlOg0KPj4gTGV0J3MgY2hl
Y2sgaWYgdGhlIFVWIHJlYWxseSBwcm90ZWN0ZWQgYWxsIHRoZSBtZW1vcnkgd2UgZG9uYXRl
ZC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxpbnV4
LmlibS5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogTmljbyBCb2VociA8bnJiQGxpbnV4Lmli
bS5jb20+DQoNClRoYW5rcw0KDQo+IA0KPiBPbmUgc3VnZ2VzdGlvbiBiZWxvdyBmb3IgeW91
IHRvIGNvbnNpZGVyLg0KDQpTdXJlLCBJJ2xsIHJld29yayB0aGUgbG9vcHMNCg0KPiANCj4+
IC0tLQ0KPj4gIMKgczM5MHgvdXYtaG9zdC5jIHwgNDIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tDQo+PiAgwqAxIGZpbGUgY2hhbmdlZCwgNDAgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvczM5MHgvdXYt
aG9zdC5jIGIvczM5MHgvdXYtaG9zdC5jDQo+PiBpbmRleCBhMWE2ZDEyMC4uMGYwYjE4YTEg
MTAwNjQ0DQo+PiAtLS0gYS9zMzkweC91di1ob3N0LmMNCj4+ICsrKyBiL3MzOTB4L3V2LWhv
c3QuYw0KPj4gQEAgLTE0Miw3ICsxNDIsOCBAQCBzdGF0aWMgdm9pZCB0ZXN0X2NwdV9kZXN0
cm95KHZvaWQpDQo+PiAgwqBzdGF0aWMgdm9pZCB0ZXN0X2NwdV9jcmVhdGUodm9pZCkNCj4+
ICDCoHsNCj4+ICDCoMKgwqDCoMKgwqDCoMKgaW50IHJjOw0KPj4gLcKgwqDCoMKgwqDCoMKg
dW5zaWduZWQgbG9uZyB0bXA7DQo+PiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nIHRt
cCwgaTsNCj4+ICvCoMKgwqDCoMKgwqDCoHVpbnQ4X3QgKmFjY2Vzc19wdHI7DQo+PiAgIA0K
Pj4gIMKgwqDCoMKgwqDCoMKgwqByZXBvcnRfcHJlZml4X3B1c2goImNzYyIpOw0KPj4gIMKg
wqDCoMKgwqDCoMKgwqB1dmNiX2NzYy5oZWFkZXIubGVuID0gc2l6ZW9mKHV2Y2JfY3NjKTsN
Cj4+IEBAIC0xOTQsNiArMTk1LDE4IEBAIHN0YXRpYyB2b2lkIHRlc3RfY3B1X2NyZWF0ZSh2
b2lkKQ0KPj4gIMKgwqDCoMKgwqDCoMKgwqByZXBvcnQocmMgPT0gMCAmJiB1dmNiX2NzYy5o
ZWFkZXIucmMgPT0gVVZDX1JDX0VYRUNVVEVEICYmDQo+PiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB1dmNiX2NzYy5jcHVfaGFuZGxlLCAic3VjY2VzcyIpOw0KPj4gICANCj4+
ICvCoMKgwqDCoMKgwqDCoHJjID0gMTsNCj4+ICvCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDA7
IGkgPCB1dmNiX3F1aS5jcHVfc3Rvcl9sZW4gLyBQQUdFX1NJWkU7IGkrKykgew0KPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGV4cGVjdF9wZ21faW50KCk7DQo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYWNjZXNzX3B0ciA9ICh2b2lkICopdXZjYl9j
c2Muc3Rvcl9vcmlnaW4gKyBQQUdFX1NJWkUNCj4+ICogaTsNCj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAqYWNjZXNzX3B0ciA9IDQyOw0KPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlmIChjbGVhcl9wZ21faW50KCkgIT0NCj4+IFBHTV9JTlRfQ09E
RV9TRUNVUkVfU1RPUl9BQ0NFU1MpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSAwOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsNCj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB9DQo+PiArwqDCoMKgwqDCoMKgwqB9DQo+PiArwqDCoMKgwqDCoMKg
wqByZXBvcnQocmMsICJTdG9yYWdlIHByb3RlY3Rpb24iKTsNCj4gDQo+IEFsbCBvZiB0aGVz
ZSBmb3IgbG9vcHMgbG9vayBwcmV0dHkgc2ltaWxhciwgd291bGQgaXQgbWFrZSBzZW5zZSB0
byBtb3ZlDQo+IHRoZW0gdG8gdGhlaXIgb3duIGZ1bmN0aW9uwqBsaWtlOg0KPiANCj4gYXNz
ZXJ0X3JhbmdlX3dyaXRlX3Byb3RlY3RlZCh2b2lkICpzdGFydCwgc2l6ZV90IGxlbiwgaW50
DQo+IHBnbV9pbnRfY29kZSk/DQoNCg==
