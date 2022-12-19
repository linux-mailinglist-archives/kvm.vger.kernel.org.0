Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC686513DE
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 21:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiLSU1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 15:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiLSU1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 15:27:35 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3357E6599;
        Mon, 19 Dec 2022 12:27:34 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJKD299026727;
        Mon, 19 Dec 2022 20:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=00uFHxbcIKfbVZLTXm7e3I8xLq/VXWuSB6hwbiGvTC0=;
 b=XaL/+l8fmM17KQcEes4dhJ4inRWh8+T8KB5jVBK4h/g1cSW575yTIObEYoVcdux4xcSS
 FT234wp3GAyZbqB8TT/9u30d4eEwswXyT+Yr3uyJcvbw0QDZ+WTl+QcKsg25H9xEKYnZ
 yzug8ZmcLSyRnRwEysPwHkpxCtKZ5kPnsApECw9GFghgvN0IlSG0HKvfXykZ0P6p/TwK
 aPpKFmRUonob39wBKaUdJuAvcoWeoktI9jAK/ZxZ0IIl2LxA0sTEEsciEMZTjua20Qy5
 nVwPJP9iat7yJc/y3PKjjQaLOoMfplvAr4jsEgz51OJR8ZFOESTKjOCqG9JkRFuLz1WP dg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjxsyrbve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:27:33 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJK0Z5N026678;
        Mon, 19 Dec 2022 20:27:32 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3mh6yvkeng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:27:32 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJKRUWm58786078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 20:27:30 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B393B58055;
        Mon, 19 Dec 2022 20:27:30 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80AC95804B;
        Mon, 19 Dec 2022 20:27:29 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.60.89.68])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 20:27:29 +0000 (GMT)
Message-ID: <55ca0521f7c0b88116e79f0e988dfabb9cba1b52.camel@linux.ibm.com>
Subject: Re: [PATCH v1 11/16] vfio/ccw: discard second fmt-1 IDAW
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 19 Dec 2022 15:27:29 -0500
In-Reply-To: <7512483a-ac05-3125-fa1b-3934d9436ef2@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
         <20221121214056.1187700-12-farman@linux.ibm.com>
         <7512483a-ac05-3125-fa1b-3934d9436ef2@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Pul42W-thMOOEAx7veYQ10SkTShHYQjB
X-Proofpoint-GUID: Pul42W-thMOOEAx7veYQ10SkTShHYQjB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190178
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTEyLTE5IGF0IDE0OjI3IC0wNTAwLCBNYXR0aGV3IFJvc2F0byB3cm90ZToK
PiBPbiAxMS8yMS8yMiA0OjQwIFBNLCBFcmljIEZhcm1hbiB3cm90ZToKPiA+IFRoZSBpbnRlbnRp
b24gaXMgdG8gcmVhZCB0aGUgZmlyc3QgSURBVyB0byBkZXRlcm1pbmUgdGhlIHN0YXJ0aW5nCj4g
PiBsb2NhdGlvbiBvZiBhbiBJL08gb3BlcmF0aW9uLCBrbm93aW5nIHRoYXQgdGhlIHNlY29uZCBh
bmQgYW55L2FsbAo+ID4gc3Vic2VxdWVudCBJREFXcyB3aWxsIGJlIGFsaWduZWQgcGVyIGFyY2hp
dGVjdHVyZS4gQnV0LCB0aGlzIHJlYWQKPiA+IHJlY2VpdmVzIDY0LWJpdHMgb2YgZGF0YSwgd2hp
Y2ggaXMgdGhlIHNpemUgb2YgYSBmb3JtYXQtMiBJREFXLgo+ID4gCj4gPiBJbiB0aGUgZXZlbnQg
dGhhdCBGb3JtYXQtMSBJREFXcyBhcmUgcHJlc2VudGVkLCBkaXNjYXJkIHRoZSBsb3dlcgo+ID4g
MzIgYml0cyBhcyB0aGV5IGNvbnRhaW4gdGhlIHNlY29uZCBJREFXIGluIHN1Y2ggYSBsaXN0Lgo+
ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBFcmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5jb20+
Cj4gPiAtLS0KPiA+IMKgZHJpdmVycy9zMzkwL2Npby92ZmlvX2Njd19jcC5jIHwgOCArKysrKyst
LQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+
ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zMzkwL2Npby92ZmlvX2Njd19jcC5jCj4gPiBi
L2RyaXZlcnMvczM5MC9jaW8vdmZpb19jY3dfY3AuYwo+ID4gaW5kZXggMzRhMTMzZDk2MmQxLi41
MzI0NmY0Zjk1ZjcgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL3MzOTAvY2lvL3ZmaW9fY2N3X2Nw
LmMKPiA+ICsrKyBiL2RyaXZlcnMvczM5MC9jaW8vdmZpb19jY3dfY3AuYwo+ID4gQEAgLTUxNiwx
MSArNTE2LDE1IEBAIHN0YXRpYyBpbnQgY2N3X2NvdW50X2lkYXdzKHN0cnVjdCBjY3cxICpjY3cs
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ5dGVzID0gY2N3LT5jb3VudDsK
PiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGNjd19pc19pZGFsKGNjdykpIHsKPiA+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBSZWFkIGZpcnN0IElEQVcgdG8gc2VlIGlm
IGl0J3MgNEstYWxpZ25lZCBvcgo+ID4gbm90LiAqLwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoC8qIEFsbCBzdWJzZXF1ZW50IElEQXdzIHdpbGwgYmUgNEstYWxpZ25lZC4gKi8K
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBSZWFkIGZpcnN0IElEQVcgdG8g
Y2hlY2sgaXRzIHN0YXJ0aW5nIGFkZHJlc3MuCj4gPiAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoC8qIEFsbCBzdWJzZXF1ZW50IElEQVdzIHdpbGwgYmUgMkstIG9yIDRLLWFs
aWduZWQuCj4gPiAqLwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXQgPSB2
ZmlvX2RtYV9ydyh2ZGV2LCBjY3ctPmNkYSwgJmlvdmEsCj4gPiBzaXplb2YoaW92YSksIGZhbHNl
KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHJldCkKPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXQ7Cj4g
PiArCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogRm9ybWF0LTEgSURBV3Mg
b25seSBvY2N1cHkgdGhlIGZpcnN0IGludCAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGlmICghY3AtPm9yYi5jbWQuYzY0KQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpb3ZhID0gaW92YSA+PiAzMjsKPiAKPiBSYXRoZXIgdGhh
biByZWFkIDhCIGFuZCBkaXNjYXJkaW5nIDRCLCBjYW4ndCB3ZSBjaGVjayB0aGlzIGZvcm1hdAo+
IHZhbHVlIGZpcnN0IGFuZCBvbmx5IHJlYWQgNEIgZm9yIGZvcm1hdC0xPwoKRXJwLCB5ZWFoLiBJ
IHRoaW5rIEkgaGFkIHRoYXQgaW4gb25lIHBvaW50OyBJJ2xsIHdvcmsgc29tZXRoaW5nIGluCmhl
cmUuIFRoYW5rcyBmb3IgdGhlIHRvcC4KCj4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlIHsK
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW92YSA9IGNjdy0+Y2RhOwo+ID4g
wqDCoMKgwqDCoMKgwqDCoH0KPiAKCg==

