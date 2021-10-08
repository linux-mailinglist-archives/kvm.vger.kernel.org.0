Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B627C4265A5
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 10:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhJHIPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 04:15:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbhJHIPs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 04:15:48 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1986aRcb007255;
        Fri, 8 Oct 2021 04:13:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1XOYP7hCnRLRIGpJNhBAs0aiYIgrCBR8BOskunaRyV8=;
 b=sUoqOGBwsDk3FFXTC6YFlyRgh+BhnwfyaDIQay7tbIAqSJABhwCPuBM7G/OPmEbRHdcd
 sYaOdXTcRNfOWiLk0xfsqExzxOi+aT56LlPHo/2B0G3lcDgMyuTg87Sie3tKREJ0dMwH
 skEglbWvrBCHLpqyVacHcLt3FvKZAJqxfsbFkF7tcEA7qVKNLcNx8HEeF5lZdoPNI9m/
 u2zdEVn+FLYJPst9h9w0LYhGAH3OK0FuocfrCg+DcpZqzFrr0XzGnXsDnGghYEvX4hmF
 VR4+CNK5CZ9Dm48PF+0NffA96utOsV7iFVOJhNt+odpB2LJvItTfi31s7hoL7hM8ETV6 hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjeknvtde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 04:13:53 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1987MSKT028934;
        Fri, 8 Oct 2021 04:13:53 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjeknvtcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 04:13:53 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198881kq001907;
        Fri, 8 Oct 2021 08:13:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3bef2am60j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 08:13:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1988Dg7P46662096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 08:13:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F3DD42081;
        Fri,  8 Oct 2021 08:13:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B845342064;
        Fri,  8 Oct 2021 08:13:40 +0000 (GMT)
Received: from [9.145.188.236] (unknown [9.145.188.236])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  8 Oct 2021 08:13:40 +0000 (GMT)
Message-ID: <8d3a91e8-657a-0912-4380-36ba00a1b112@linux.ibm.com>
Date:   Fri, 8 Oct 2021 10:13:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 9/9] s390x: snippets: Define all things
 that are needed to link the lib
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-10-frankja@linux.ibm.com>
 <c3bed287-5c4c-a54b-4276-391c6cdb37f4@redhat.com>
 <8c1cac56-3f4b-5f00-4e62-d14aebbb537d@linux.ibm.com>
 <bf94d76c-ee23-465e-1c2a-8c4ee1b006f7@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <bf94d76c-ee23-465e-1c2a-8c4ee1b006f7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wJZCzmQySka3vbePZyx0vJ_Mi5X5GmOE
X-Proofpoint-GUID: KSwL8dqjDjSlu_1ArO9nJ4peYY6CPR0i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_02,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTAvOC8yMSAwOToyMCwgVGhvbWFzIEh1dGggd3JvdGU6DQo+IE9uIDA3LzEwLzIwMjEg
MTIuNDQsIEphbm9zY2ggRnJhbmsgd3JvdGU6DQo+PiBPbiAxMC83LzIxIDExOjQ0LCBUaG9t
YXMgSHV0aCB3cm90ZToNCj4+PiBPbiAwNy8xMC8yMDIxIDEwLjUwLCBKYW5vc2NoIEZyYW5r
IHdyb3RlOg0KPj4+PiBMZXQncyBqdXN0IGRlZmluZSBhbGwgb2YgdGhlIG5lZWRlZCB0aGlu
Z3Mgc28gd2UgY2FuIGxpbmsgbGliY2ZsYXQuDQo+Pj4+DQo+Pj4+IEEgc2lnbmlmaWNhbnQg
cG9ydGlvbiBvZiB0aGUgbGliIHdvbid0IHdvcmssIGxpa2UgcHJpbnRpbmcgYW5kDQo+Pj4+
IGFsbG9jYXRpb24gYnV0IHdlIGNhbiBzdGlsbCB1c2UgdGhpbmdzIGxpa2UgbWVtc2V0KCkg
d2hpY2ggYWxyZWFkeQ0KPj4+PiBpbXByb3ZlcyBvdXIgbGl2ZXMgc2lnbmlmaWNhbnRseS4N
Cj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogSmFub3NjaCBGcmFuayA8ZnJhbmtqYUBsaW51
eC5pYm0uY29tPg0KPj4+PiAtLS0NCj4+Pj4gIMKgwqAgczM5MHgvc25pcHBldHMvYy9jc3Rh
cnQuUyB8IDE0ICsrKysrKysrKysrKysrDQo+Pj4+ICDCoMKgIDEgZmlsZSBjaGFuZ2VkLCAx
NCBpbnNlcnRpb25zKCspDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9zMzkweC9zbmlwcGV0
cy9jL2NzdGFydC5TIGIvczM5MHgvc25pcHBldHMvYy9jc3RhcnQuUw0KPj4+PiBpbmRleCAw
MzFhNmI4My4uMmQzOTc2NjkgMTAwNjQ0DQo+Pj4+IC0tLSBhL3MzOTB4L3NuaXBwZXRzL2Mv
Y3N0YXJ0LlMNCj4+Pj4gKysrIGIvczM5MHgvc25pcHBldHMvYy9jc3RhcnQuUw0KPj4+PiBA
QCAtMjAsNiArMjAsMjAgQEAgc3RhcnQ6DQo+Pj4+ICDCoMKgwqDCoMKgwqAgbGdoacKgwqDC
oCAlcjE1LCBzdGFja3B0cg0KPj4+PiAgwqDCoMKgwqDCoMKgIHNhbTY0DQo+Pj4+ICDCoMKg
wqDCoMKgwqAgYnJhc2zCoMKgwqAgJXIxNCwgbWFpbg0KPj4+PiArLyoNCj4+Pj4gKyAqIERl
ZmluaW5nIHRoaW5ncyB0aGF0IHRoZSBsaW5rZXIgbmVlZHMgdG8gbGluayBpbiBsaWJjZmxh
dCBhbmQgbWFrZQ0KPj4+PiArICogdGhlbSByZXN1bHQgaW4gc2lncCBzdG9wIGlmIGNhbGxl
ZC4NCj4+Pj4gKyAqLw0KPj4+PiArLmdsb2JsIHNpZV9leGl0DQo+Pj4+ICsuZ2xvYmwgc2ll
X2VudHJ5DQo+Pj4+ICsuZ2xvYmwgc21wX2NwdV9zZXR1cF9zdGF0ZQ0KPj4+PiArLmdsb2Js
IGlwbF9hcmdzDQo+Pj4+ICsuZ2xvYmwgYXV4aW5mbw0KPj4+PiArc2llX2V4aXQ6DQo+Pj4+
ICtzaWVfZW50cnk6DQo+Pj4+ICtzbXBfY3B1X3NldHVwX3N0YXRlOg0KPj4+PiAraXBsX2Fy
Z3M6DQo+Pj4+ICthdXhpbmZvOg0KPj4+DQo+Pj4gSSB0aGluayB0aGlzIGxpa2VseSBjb3Vs
ZCBiZSBkb25lIGluIGEgc29tZXdoYXQgbmljZXIgd2F5LCBlLmcuIGJ5IG1vdmluZw0KPj4N
Cj4+IERlZmluaXRlbHksIGFzIEkgc2FpZCwgaXQncyBhIHNpbXBsZSBmaXgNCj4gDQo+IEFs
dGVybmF0aXZlbHksIHNvbWV0aGluZyBsaWtlIHRoaXMgbWlnaHQgd29yaywgdG9vOg0KDQpT
ZWVtcyBsaWtlIGl0IHdvcmtzIGZvciB0aGUgdHdvIHRlc3RzIHRoYXQgSSBjaGVja2VkLg0K
V291bGQgeW91IG1pbmQgc2VuZGluZyBhIHByb3BlciBwYXRjaD8NCg0KSSdkIGxpa2UgdG8g
c2VuZCBvdXQgYSBwdWxsIHRvZGF5IG9yIG9uIE1vbmRheS4NCg0KPiANCj4gZGlmZiAtLWdp
dCBhL3MzOTB4L01ha2VmaWxlIGIvczM5MHgvTWFrZWZpbGUNCj4gLS0tIGEvczM5MHgvTWFr
ZWZpbGUNCj4gKysrIGIvczM5MHgvTWFrZWZpbGUNCj4gQEAgLTgwLDcgKzgwLDcgQEAgYXNt
bGliID0gJChURVNUX0RJUikvY3N0YXJ0NjQubyAkKFRFU1RfRElSKS9jcHUubw0KPiAgICBG
TEFUTElCUyA9ICQobGliY2ZsYXQpDQo+ICAgIA0KPiAgICBTTklQUEVUX0RJUiA9ICQoVEVT
VF9ESVIpL3NuaXBwZXRzDQo+IC1zbmlwcGV0X2FzbWxpYiA9ICQoU05JUFBFVF9ESVIpL2Mv
Y3N0YXJ0Lm8NCj4gK3NuaXBwZXRfYXNtbGliID0gJChTTklQUEVUX0RJUikvYy9jc3RhcnQu
byBsaWIvYXV4aW5mby5vDQo+ICAgIA0KPiAgICAjIHBlcnF1aXNpdGVzICg9Z3Vlc3RzKSBm
b3IgdGhlIHNuaXBwZXQgaG9zdHMuDQo+ICAgICMgJChURVNUX0RJUikvPHNuaXBwZXQtaG9z
dD4uZWxmOiBzbmlwcGV0cyA9ICQoU05JUFBFVF9ESVIpLzxjL2FzbT4vPHNuaXBwZXQ+Lmdi
aW4NCj4gZGlmZiAtLWdpdCBhL3MzOTB4L3NuaXBwZXRzL2MvY3N0YXJ0LlMgYi9zMzkweC9z
bmlwcGV0cy9jL2NzdGFydC5TDQo+IC0tLSBhL3MzOTB4L3NuaXBwZXRzL2MvY3N0YXJ0LlMN
Cj4gKysrIGIvczM5MHgvc25pcHBldHMvYy9jc3RhcnQuUw0KPiBAQCAtMjEsNSArMjEsOSBA
QCBzdGFydDoNCj4gICAgICAgICAgIHNhbTY0DQo+ICAgICAgICAgICBicmFzbCAgICVyMTQs
IG1haW4NCj4gICAgICAgICAgIC8qIEZvciBub3cgbGV0J3Mgb25seSB1c2UgY3B1IDAgaW4g
c25pcHBldHMgc28gdGhpcyB3aWxsIGFsd2F5cyB3b3JrLiAqLw0KPiArLmdsb2JhbCBwdXRz
DQo+ICsuZ2xvYmFsIGV4aXQNCj4gK3B1dHM6DQo+ICtleGl0Og0KPiAgICAgICAgICAgeGdy
ICAgICAlcjAsICVyMA0KPiAgICAgICAgICAgc2lncCAgICAlcjIsICVyMCwgU0lHUF9TVE9Q
DQo+IA0KPiBJIHRoaW5rIHRoYXQncyBtb3JlIGNsZWFyIHRoaXMgd2F5LCBzaW5jZSB3ZSdy
ZSBmZW5jaW5nIHRoZQ0KPiBmdW5jdGlvbnMgdGhhdCBjYXVzZWQgdGhlIGRlcGVuZGVuY2ll
cyB0byB0aGUgb3RoZXIgZnVuY3Rpb25zDQo+IGZyb20geW91ciBwYXRjaC4gV2hhdCBkbyB5
b3UgdGhpbms/DQo+IA0KPiAgICBUaG9tYXMNCj4gDQoNCg==
