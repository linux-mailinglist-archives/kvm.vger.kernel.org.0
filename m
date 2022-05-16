Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A99527F8A
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 10:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbiEPIWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 04:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241686AbiEPIWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 04:22:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A345936E3C;
        Mon, 16 May 2022 01:22:18 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G7k1ad027312;
        Mon, 16 May 2022 08:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=MwGKUeNNrm8L0MYccWYKUJE3X56wFn7QIRn5QECgQss=;
 b=pZQMeW/fthP6+ExD/pR9zHkM/ccWomVPpO7+yFVhRnua+LIIIpO79YEaIRv1wPVQ6fuq
 N8jKj9Vs4mdcUmnLMBjGv98W19LKCaNbjudPaiLU2YR0CJeOaPC3YC5ufIlOi/RrJ/c6
 UABiv2wbNjSrEgFWidTw2S6T8w1EmjMNBQ8sXwSDfAnzkAnhB0GzyiJ4dJheHs6zqYHb
 pX9Unr7KAT56dL4jsKGiByzwgu5YHFVYyXH2vSXioMeRVzdruqhK1NQXudbKvzDvEAxr
 Bi0g9+x+rCqDGDNUK7azTaQloS3NF5CgXkVwaCDRGSVZfk/fvZeN7eIhsU/nSBUfQgAl Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jgtrmk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:22:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G8J5X4019819;
        Mon, 16 May 2022 08:22:17 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jgtrmcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:22:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G8I9EM025000;
        Mon, 16 May 2022 08:21:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429a9mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:21:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G8Lms433948002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 08:21:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97CEB11C04C;
        Mon, 16 May 2022 08:21:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41A6D11C04A;
        Mon, 16 May 2022 08:21:48 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.122])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 08:21:48 +0000 (GMT)
Message-ID: <c762eb07d227fd161c3dec0d5e1d3b302ed28007.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: uv-host: Add access checks
 for donated memory
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Date:   Mon, 16 May 2022 10:21:48 +0200
In-Reply-To: <20220513095017.16301-2-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
         <20220513095017.16301-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dUnYvca3CODZMwL3XtaE1xBoLSoBeYVF
X-Proofpoint-ORIG-GUID: 4V-hWlNIM7Vjjx_y1yNvCmZDcT5g5K5y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=907 malwarescore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTA1LTEzIGF0IDA5OjUwICswMDAwLCBKYW5vc2NoIEZyYW5rIHdyb3RlOgo+
IExldCdzIGNoZWNrIGlmIHRoZSBVViByZWFsbHkgcHJvdGVjdGVkIGFsbCB0aGUgbWVtb3J5IHdl
IGRvbmF0ZWQuCj4gCj4gU2lnbmVkLW9mZi1ieTogSmFub3NjaCBGcmFuayA8ZnJhbmtqYUBsaW51
eC5pYm0uY29tPgoKUmV2aWV3ZWQtYnk6IE5pY28gQm9laHIgPG5yYkBsaW51eC5pYm0uY29tPgoK
T25lIHN1Z2dlc3Rpb24gYmVsb3cgZm9yIHlvdSB0byBjb25zaWRlci4KCj4gLS0tCj4gwqBzMzkw
eC91di1ob3N0LmMgfCA0MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA0MCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+
IAo+IGRpZmYgLS1naXQgYS9zMzkweC91di1ob3N0LmMgYi9zMzkweC91di1ob3N0LmMKPiBpbmRl
eCBhMWE2ZDEyMC4uMGYwYjE4YTEgMTAwNjQ0Cj4gLS0tIGEvczM5MHgvdXYtaG9zdC5jCj4gKysr
IGIvczM5MHgvdXYtaG9zdC5jCj4gQEAgLTE0Miw3ICsxNDIsOCBAQCBzdGF0aWMgdm9pZCB0ZXN0
X2NwdV9kZXN0cm95KHZvaWQpCj4gwqBzdGF0aWMgdm9pZCB0ZXN0X2NwdV9jcmVhdGUodm9pZCkK
PiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJjOwo+IC3CoMKgwqDCoMKgwqDCoHVuc2lnbmVk
IGxvbmcgdG1wOwo+ICvCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGxvbmcgdG1wLCBpOwo+ICvCoMKg
wqDCoMKgwqDCoHVpbnQ4X3QgKmFjY2Vzc19wdHI7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgcmVw
b3J0X3ByZWZpeF9wdXNoKCJjc2MiKTsKPiDCoMKgwqDCoMKgwqDCoMKgdXZjYl9jc2MuaGVhZGVy
LmxlbiA9IHNpemVvZih1dmNiX2NzYyk7Cj4gQEAgLTE5NCw2ICsxOTUsMTggQEAgc3RhdGljIHZv
aWQgdGVzdF9jcHVfY3JlYXRlKHZvaWQpCj4gwqDCoMKgwqDCoMKgwqDCoHJlcG9ydChyYyA9PSAw
ICYmIHV2Y2JfY3NjLmhlYWRlci5yYyA9PSBVVkNfUkNfRVhFQ1VURUQgJiYKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHV2Y2JfY3NjLmNwdV9oYW5kbGUsICJzdWNjZXNzIik7Cj4gwqAK
PiArwqDCoMKgwqDCoMKgwqByYyA9IDE7Cj4gK8KgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8
IHV2Y2JfcXVpLmNwdV9zdG9yX2xlbiAvIFBBR0VfU0laRTsgaSsrKSB7Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGV4cGVjdF9wZ21faW50KCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGFjY2Vzc19wdHIgPSAodm9pZCAqKXV2Y2JfY3NjLnN0b3Jfb3JpZ2luICsg
UEFHRV9TSVpFCj4gKiBpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqYWNjZXNz
X3B0ciA9IDQyOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoY2xlYXJfcGdt
X2ludCgpICE9Cj4gUEdNX0lOVF9DT0RFX1NFQ1VSRV9TVE9SX0FDQ0VTUykgewo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSAwOwo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnJlYWs7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqB9Cj4gK8KgwqDCoMKgwqDC
oMKgcmVwb3J0KHJjLCAiU3RvcmFnZSBwcm90ZWN0aW9uIik7CgpBbGwgb2YgdGhlc2UgZm9yIGxv
b3BzIGxvb2sgcHJldHR5IHNpbWlsYXIsIHdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gbW92ZQp0aGVt
IHRvIHRoZWlyIG93biBmdW5jdGlvbsKgbGlrZToKCmFzc2VydF9yYW5nZV93cml0ZV9wcm90ZWN0
ZWQodm9pZCAqc3RhcnQsIHNpemVfdCBsZW4sIGludApwZ21faW50X2NvZGUpPwo=

