Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC156408F6
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 16:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiLBPIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 10:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiLBPIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 10:08:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D5D7F8B1;
        Fri,  2 Dec 2022 07:08:48 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2DiCIu019893;
        Fri, 2 Dec 2022 15:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3e6aYKGGL+FHtwgc3PZ/CnRXsFjWL005O04+K5BOZu0=;
 b=YZDGZpS53F/CHfguKBUntoLN0FxxYYC9crvqL1Slvr2AjtSKP7vIWTD4kJz9j5JQ0kmg
 m+BcsuDTTqedlPcBuPAwbANWFkxI20PIO5vSr67KGHT86tXfI5vp8woAnfFDQc+rBe1p
 ryjuU0bnh97cVFpeAdAzJo5LkGkzi/YUUeVvSCygeGvGGgEqPzLBklgUHRWpmSYE39Cm
 XEcEqsh3niIspE7AR8uZ9FHPA11dh8c+kimB2jmQPDdjq4He8vaJ2J/+/h0ikJvG0ePp
 huQp5/+Ll9kj/WeaPHTlCk7XKzGC1nG2xTWIKg8TVKXgcsObmeZHuUp75AbiiRa3ihD1 MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7jgm240v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 15:08:35 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2EnPbZ029209;
        Fri, 2 Dec 2022 15:08:34 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7jgm240f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 15:08:34 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2F5O8f012555;
        Fri, 2 Dec 2022 15:08:33 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma04wdc.us.ibm.com with ESMTP id 3m3aeaacr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 15:08:33 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2F8VBr918164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 15:08:32 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D4B258060;
        Fri,  2 Dec 2022 15:08:31 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C56A058056;
        Fri,  2 Dec 2022 15:08:30 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.60.89.68])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  2 Dec 2022 15:08:30 +0000 (GMT)
Message-ID: <5774398d6f69f0708e1fc040be4b7dd398a884c8.camel@linux.ibm.com>
Subject: Re: [PATCH] vfio/mdev: fix possible memory leak in module init funcs
From:   Eric Farman <farman@linux.ibm.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>
Date:   Fri, 02 Dec 2022 10:08:30 -0500
In-Reply-To: <BN9PR11MB52763DC62CE7FEB3A70356BD8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221118032827.3725190-1-ruanjinjie@huawei.com>
         <20221130160622.0cf3e47d.alex.williamson@redhat.com>
         <BN9PR11MB5276BC0B7E656465950E3A558C149@BN9PR11MB5276.namprd11.prod.outlook.com>
         <20221201141013.68d2b0cf.alex.williamson@redhat.com>
         <BN9PR11MB52763DC62CE7FEB3A70356BD8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4trMDeUXVA5cngtJEPL_n6_Zw5X3ylsf
X-Proofpoint-ORIG-GUID: jZ4HsZ7nsM91IVN5me0FF0kovmS5Pjpp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_06,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDA1OjI4ICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToKPiA+
IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+Cj4gPiBT
ZW50OiBGcmlkYXksIERlY2VtYmVyIDIsIDIwMjIgNToxMCBBTQo+ID4gCj4gPiA+IE90aGVyd2lz
ZSB3aGF0IHRoaXMgcGF0Y2ggZG9lcyBsb29rcyBiZXR0ZXIgSU1ITzoKPiA+ID4gCj4gPiA+IMKg
wqDCoMKgwqDCoMKgwqByZXQgPSBkZXZpY2VfcmVnaXN0ZXIoJmRldik7Cj4gPiA+IMKgwqDCoMKg
wqDCoMKgwqBpZiAocmV0KSB7Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cHV0X2RldmljZSgmZGV2KTsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBn
b3RvIGVycjE7Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiA+IAo+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgLi4uCj4gPiA+IAo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gPiA+IAo+
ID4gPiBlcnIyOgo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgZGV2aWNlX3VucmVnaXN0ZXIoJmRldik7
Cj4gPiA+IGVycjE6Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBlYXJsaWVyX3Vud2luZCgpOwo+ID4g
PiAKPiA+IAo+ID4gVGhpcyBpcyBlc3NlbnRpYWxseSB3aGF0IHdhcyBvcmlnaW5hbGx5IHByb3Bv
c2VkLsKgIEl0IGNvdWxkIGFsc28gYmUKPiA+IGNhbGxlZCBhICJtaXhlZCBtb2RlbCIsIGltcGxl
bWVudGluZyBwYXJ0IG9mIHRoZSB1bndpbmQgaW4gdGhlCj4gPiBlcnJvcgo+ID4gYnJhbmNoIGJl
Zm9yZSBqdW1waW5nIHRvIHRoZSBjb21tb24gdW53aW5kLsKgIEFzIGRlbW9uc3RyYXRlZCBiZWxv
dywKPiA+IGV2ZXJ5IGN1cnJlbnQgdmZpbyBkcml2ZXIgY2FsbGluZyBkZXZpY2VfcmVnaXN0ZXIo
KSBmb2xsb3dzIGEKPiA+IHNpbWlsYXIKPiA+IGdvdG8gdW53aW5kIHN0YWNrIGFzIGZvdW5kIGlu
IHRoZSBzYW1wbGUgZHJpdmVycywgd2hpY2ggbWFrZXMgaXQKPiA+IHRyaXZpYWxseSBlYXN5IHRv
IHNwbGl0IHRoZSBkZXZpY2VfdW5yZWdpc3RlcigpIGNhbGwgYW5kIGFkZCBhIGdvdG8KPiA+IHRh
cmdldCBpbiBiZXR3ZWVuLgo+IAo+IE9LLiBBY3R1YWxseSBsb29raW5nIGludG8gb3RoZXIgdXNl
cnMgb2YgZGV2aWNlX3JlZ2lzdGVyKCkgSSBjYW4KPiBzZWUgYm90aCBzY2hlbWVzIGFyZSB1c2Vk
LCBzby4uLgo+IAo+ID4gCj4gPiBFaXRoZXIgd2F5LCB0aGV5J3JlIGVxdWl2YWxlbnQgYW5kIEkn
bGwgdGFrZSB3aGljaGV2ZXIgdmVyc2lvbgo+ID4gYWRkcmVzc2VzIGFsbCB0aGUgdmZpbyByZWxh
dGVkIHVzZSBjYXNlcyBhbmQgZ2V0cyBhY2tzIGZyb20gdGhlaXIKPiA+IG1haW50YWluZXJzLsKg
IFRoYW5rcywKPiAKPiAuLi4gYWdyZWUgZWl0aGVyIHdheSBpcyBmaW5lLiBTaW5jZSB5b3VyIHZl
cnNpb24gZml4ZXMgYWxsIHZmaW8KPiBjYXNlcywKPiBmZWVsIGZyZWUgdG8gaW5jbHVkZToKPiAK
PiBSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+Cj4gCj4gPiAK
PiA+IEFsZXgKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvczM5MC9jaW8vdmZpb19jY3df
ZHJ2LmMKPiA+IGIvZHJpdmVycy9zMzkwL2Npby92ZmlvX2Njd19kcnYuYwo+ID4gaW5kZXggYzJh
NjU4MDg2MDVhLi41NGFiYTdjY2ViMzMgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL3MzOTAvY2lv
L3ZmaW9fY2N3X2Rydi5jCj4gPiArKysgYi9kcml2ZXJzL3MzOTAvY2lvL3ZmaW9fY2N3X2Rydi5j
Cj4gPiBAQCAtMTk5LDggKzE5OSw5IEBAIHN0YXRpYyBpbnQgdmZpb19jY3dfc2NoX3Byb2JlKHN0
cnVjdCBzdWJjaGFubmVsCj4gPiAqc2NoKQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+
ID4gCj4gPiDCoG91dF91bnJlZzoKPiA+IC3CoMKgwqDCoMKgwqDCoGRldmljZV91bnJlZ2lzdGVy
KCZwYXJlbnQtPmRldik7Cj4gPiArwqDCoMKgwqDCoMKgwqBkZXZpY2VfZGVsKCZwYXJlbnQtPmRl
dik7Cj4gPiDCoG91dF9mcmVlOgo+ID4gK8KgwqDCoMKgwqDCoMKgcHV0X2RldmljZSgmcGFyZW50
LT5kZXYpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGRldl9zZXRfZHJ2ZGF0YSgmc2NoLT5kZXYsIE5V
TEwpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXQ7Cj4gPiDCoH0KClVnaCwgc29ycnku
IEkgaGFkIHRoaXMgcGFydGlhbGx5IHJpZ2h0IGF0IG9uZSBwb2ludCBidXQgbWlzc2VkIHRoaXMK
c2NlbmFyaW8gd2hlbiBmaXhpbmcgdGhlIHBhcnRzIEkgaGFkIHdyb25nLgoKVGhpcyBpcyBmaW5l
IGJ5IG1lLCB0aGFua3MgZm9yIHRoZSBmaXh1cDoKClJldmlld2VkLWJ5OiBFcmljIEZhcm1hbiA8
ZmFybWFuQGxpbnV4LmlibS5jb20+Cgo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvczM5MC9jcnlw
dG8vdmZpb19hcF9kcnYuYwo+ID4gYi9kcml2ZXJzL3MzOTAvY3J5cHRvL3ZmaW9fYXBfZHJ2LmMK
PiA+IGluZGV4IGY0M2NmZWFiZDJjYy4uOTk3YjUyNGJkZDJiIDEwMDY0NAo+ID4gLS0tIGEvZHJp
dmVycy9zMzkwL2NyeXB0by92ZmlvX2FwX2Rydi5jCj4gPiArKysgYi9kcml2ZXJzL3MzOTAvY3J5
cHRvL3ZmaW9fYXBfZHJ2LmMKPiA+IEBAIC0xMjIsNyArMTIyLDcgQEAgc3RhdGljIGludCB2Zmlv
X2FwX21hdHJpeF9kZXZfY3JlYXRlKHZvaWQpCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7
Cj4gPiAKPiA+IMKgbWF0cml4X2Rydl9lcnI6Cj4gPiAtwqDCoMKgwqDCoMKgwqBkZXZpY2VfdW5y
ZWdpc3RlcigmbWF0cml4X2Rldi0+ZGV2aWNlKTsKPiA+ICvCoMKgwqDCoMKgwqDCoGRldmljZV9k
ZWwoJm1hdHJpeF9kZXYtPmRldmljZSk7Cj4gPiDCoG1hdHJpeF9yZWdfZXJyOgo+ID4gwqDCoMKg
wqDCoMKgwqDCoHB1dF9kZXZpY2UoJm1hdHJpeF9kZXYtPmRldmljZSk7Cj4gPiDCoG1hdHJpeF9h
bGxvY19lcnI6Cj4gPiBkaWZmIC0tZ2l0IGEvc2FtcGxlcy92ZmlvLW1kZXYvbWJvY2hzLmMgYi9z
YW1wbGVzL3ZmaW8tCj4gPiBtZGV2L21ib2Nocy5jCj4gPiBpbmRleCA4YjVhM2E3NzhhMjUuLmU1
NGViNzUyZTFiYSAxMDA2NDQKPiA+IC0tLSBhL3NhbXBsZXMvdmZpby1tZGV2L21ib2Nocy5jCj4g
PiArKysgYi9zYW1wbGVzL3ZmaW8tbWRldi9tYm9jaHMuYwo+ID4gQEAgLTE0MzAsNyArMTQzMCw3
IEBAIHN0YXRpYyBpbnQgX19pbml0IG1ib2Noc19kZXZfaW5pdCh2b2lkKQo+ID4gCj4gPiDCoMKg
wqDCoMKgwqDCoMKgcmV0ID0gZGV2aWNlX3JlZ2lzdGVyKCZtYm9jaHNfZGV2KTsKPiA+IMKgwqDC
oMKgwqDCoMKgwqBpZiAocmV0KQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdv
dG8gZXJyX2NsYXNzOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gZXJy
X3B1dDsKPiA+IAo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldCA9IG1kZXZfcmVnaXN0ZXJfcGFyZW50
KCZtYm9jaHNfcGFyZW50LCAmbWJvY2hzX2RldiwKPiA+ICZtYm9jaHNfZHJpdmVyLAo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgbWJvY2hzX21kZXZfdHlwZXMsCj4gPiBAQCAtMTQ0MSw4ICsxNDQxLDkgQEAgc3Rh
dGljIGludCBfX2luaXQgbWJvY2hzX2Rldl9pbml0KHZvaWQpCj4gPiDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuIDA7Cj4gPiAKPiA+IMKgZXJyX2RldmljZToKPiA+IC3CoMKgwqDCoMKgwqDCoGRldmlj
ZV91bnJlZ2lzdGVyKCZtYm9jaHNfZGV2KTsKPiA+IC1lcnJfY2xhc3M6Cj4gPiArwqDCoMKgwqDC
oMKgwqBkZXZpY2VfZGVsKCZtYm9jaHNfZGV2KTsKPiA+ICtlcnJfcHV0Ogo+ID4gK8KgwqDCoMKg
wqDCoMKgcHV0X2RldmljZSgmbWJvY2hzX2Rldik7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgY2xhc3Nf
ZGVzdHJveShtYm9jaHNfY2xhc3MpOwo+ID4gwqBlcnJfZHJpdmVyOgo+ID4gwqDCoMKgwqDCoMKg
wqDCoG1kZXZfdW5yZWdpc3Rlcl9kcml2ZXIoJm1ib2Noc19kcml2ZXIpOwo+ID4gZGlmZiAtLWdp
dCBhL3NhbXBsZXMvdmZpby1tZGV2L21kcHkuYyBiL3NhbXBsZXMvdmZpby1tZGV2L21kcHkuYwo+
ID4gaW5kZXggNzIxZmIwNmM2NDEzLi5lODQwMGZkYWI3MWQgMTAwNjQ0Cj4gPiAtLS0gYS9zYW1w
bGVzL3ZmaW8tbWRldi9tZHB5LmMKPiA+ICsrKyBiL3NhbXBsZXMvdmZpby1tZGV2L21kcHkuYwo+
ID4gQEAgLTcxNyw3ICs3MTcsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBtZHB5X2Rldl9pbml0KHZv
aWQpCj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqByZXQgPSBkZXZpY2VfcmVnaXN0ZXIoJm1kcHlf
ZGV2KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAocmV0KQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGdvdG8gZXJyX2NsYXNzOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGdvdG8gZXJyX3B1dDsKPiA+IAo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldCA9IG1kZXZf
cmVnaXN0ZXJfcGFyZW50KCZtZHB5X3BhcmVudCwgJm1kcHlfZGV2LAo+ID4gJm1kcHlfZHJpdmVy
LAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgbWRweV9tZGV2X3R5cGVzLAo+ID4gQEAgLTcyOCw4ICs3MjgsOSBA
QCBzdGF0aWMgaW50IF9faW5pdCBtZHB5X2Rldl9pbml0KHZvaWQpCj4gPiDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIDA7Cj4gPiAKPiA+IMKgZXJyX2RldmljZToKPiA+IC3CoMKgwqDCoMKgwqDCoGRl
dmljZV91bnJlZ2lzdGVyKCZtZHB5X2Rldik7Cj4gPiAtZXJyX2NsYXNzOgo+ID4gK8KgwqDCoMKg
wqDCoMKgZGV2aWNlX2RlbCgmbWRweV9kZXYpOwo+ID4gK2Vycl9wdXQ6Cj4gPiArwqDCoMKgwqDC
oMKgwqBwdXRfZGV2aWNlKCZtZHB5X2Rldik7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgY2xhc3NfZGVz
dHJveShtZHB5X2NsYXNzKTsKPiA+IMKgZXJyX2RyaXZlcjoKPiA+IMKgwqDCoMKgwqDCoMKgwqBt
ZGV2X3VucmVnaXN0ZXJfZHJpdmVyKCZtZHB5X2RyaXZlcik7Cj4gPiBkaWZmIC0tZ2l0IGEvc2Ft
cGxlcy92ZmlvLW1kZXYvbXR0eS5jIGIvc2FtcGxlcy92ZmlvLW1kZXYvbXR0eS5jCj4gPiBpbmRl
eCAzYzJhNDIxYjliNjkuLmU4ODdkZTY3MmM1MiAxMDA2NDQKPiA+IC0tLSBhL3NhbXBsZXMvdmZp
by1tZGV2L210dHkuYwo+ID4gKysrIGIvc2FtcGxlcy92ZmlvLW1kZXYvbXR0eS5jCj4gPiBAQCAt
MTMzMCw3ICsxMzMwLDcgQEAgc3RhdGljIGludCBfX2luaXQgbXR0eV9kZXZfaW5pdCh2b2lkKQo+
ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gZGV2aWNlX3JlZ2lzdGVyKCZtdHR5X2Rldi5k
ZXYpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChyZXQpCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZ290byBlcnJfY2xhc3M7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZ290byBlcnJfcHV0Owo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gbWRldl9y
ZWdpc3Rlcl9wYXJlbnQoJm10dHlfZGV2LnBhcmVudCwgJm10dHlfZGV2LmRldiwKPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICZtdHR5X2RyaXZlciwgbXR0eV9tZGV2X3R5cGVzLAo+ID4gQEAgLTEzNDAsOCArMTM0
MCw5IEBAIHN0YXRpYyBpbnQgX19pbml0IG10dHlfZGV2X2luaXQodm9pZCkKPiA+IMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gMDsKPiA+IAo+ID4gwqBlcnJfZGV2aWNlOgo+ID4gLcKgwqDCoMKgwqDC
oMKgZGV2aWNlX3VucmVnaXN0ZXIoJm10dHlfZGV2LmRldik7Cj4gPiAtZXJyX2NsYXNzOgo+ID4g
K8KgwqDCoMKgwqDCoMKgZGV2aWNlX2RlbCgmbXR0eV9kZXYuZGV2KTsKPiA+ICtlcnJfcHV0Ogo+
ID4gK8KgwqDCoMKgwqDCoMKgcHV0X2RldmljZSgmbXR0eV9kZXYuZGV2KTsKPiA+IMKgwqDCoMKg
wqDCoMKgwqBjbGFzc19kZXN0cm95KG10dHlfZGV2LnZkX2NsYXNzKTsKPiA+IMKgZXJyX2RyaXZl
cjoKPiA+IMKgwqDCoMKgwqDCoMKgwqBtZGV2X3VucmVnaXN0ZXJfZHJpdmVyKCZtdHR5X2RyaXZl
cik7Cj4gCgo=

