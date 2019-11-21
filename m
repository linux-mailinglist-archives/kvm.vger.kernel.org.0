Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF44105B49
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 21:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfKUUn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 15:43:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUUn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 15:43:26 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALKf7Ng030552;
        Thu, 21 Nov 2019 12:43:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yYyfy7UfbCszm56xV+5yxCJXZw3PnJTLLeckLrQRDmg=;
 b=AbzwxoBXWSgkn2/FbeMFh+O7OdtavAh78NI08WfaTpp6svte9p5etSIxkZYyw3Ma3C79
 fMLAv4SzhApEBw7l+drDNawOXHxli70WvCWt3bxOuokQbjgSmaFRE+bgyvRAJydJ8cvr
 FyiYpUKZwODXoGD/ICLDEIPHkVpNOQPqUNo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wdjunyvv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Nov 2019 12:43:05 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 12:43:03 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 12:43:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMRL8dvgdDWG+SEFlws099zooA+UC8T2UySjAYKNUrX7SUyVhhEmYfsWKH6Imdzmxdlo8edzzIMRc48p/W+Q1fyHFZ7PN5vY0yVVFId12X57a7Cjbsdwc2+5cd00s9N6E+VGZ8Qf7fuPKUkViDg2r7G6obgvm1L9Ujk1aXwj2qwDV6L0xdpLtQgf+d7qhB7T4z4momtbSVsLyh8fLMoXcqg5RlQhEw86y+/bP3E5n7M9bf/J3QUZNDgHiTHRkoKdjyD8UnPiwfTicEZqiiwmKxnnfI3S1qP3f1QrW1etMCVx9Qn4+T8dNf8BITes915uHc457jwUbzkzSl6us+oy4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYyfy7UfbCszm56xV+5yxCJXZw3PnJTLLeckLrQRDmg=;
 b=PpH4OHBUmnNTGFa6BBPgT9TwuF/6+7iBdNWetnDmjQJkaoSZ9NbZ8QhJue8L4EKh+/Xw/a9B5mF/fIA3GB2WhNza/o/XQsVtCHn+UaoZNV9D1DUhSZqKJjKcwIV2hAYzJh/bbda+EV+qDGISbuBeoUzWaLixzNWo+kR5vGSrPQlTPiJqKubci6b8f6mIehWfQFx87JfBr7vmYOE2Eh6WMI+8hTqWZDqaEDKxOV3yv63SbrnM1jr4X2hhX80csxwdY08FkPnVldGV/8cMizxT7L+qP31aYRHu06Z0OSPyiN0rvfJwUdqXt53hKaRLialWlXXS73dT2S3lSX5tQJE5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYyfy7UfbCszm56xV+5yxCJXZw3PnJTLLeckLrQRDmg=;
 b=FqWl+Mlkmn4AJwe1czosQsb2fnIBDGJb+U7f+DUWe4qVpjEWzGLZR5oGo1PWNLlun3+mjQ04ZGMnzPiugUlg+UFanYjHBxpr9a+8NhnjTKiX0ORaNyy/oGAOR3+txWqpxdh8iQPlWXlvj/xxhSyFlRWzIqBPiD1CM/nJ6qJPtpE=
Received: from BYAPR15MB3479.namprd15.prod.outlook.com (20.179.57.24) by
 BYAPR15MB3304.namprd15.prod.outlook.com (20.179.58.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 21 Nov 2019 20:43:02 +0000
Received: from BYAPR15MB3479.namprd15.prod.outlook.com
 ([fe80::50e1:50f7:2d1c:d556]) by BYAPR15MB3479.namprd15.prod.outlook.com
 ([fe80::50e1:50f7:2d1c:d556%5]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 20:43:01 +0000
From:   Rik van Riel <riel@fb.com>
To:     Roman Gushchin <guro@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "shakeelb@google.com" <shakeelb@google.com>,
        "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: WARNING bisected (was Re: [PATCH v7 08/10] mm: rework non-root
 kmem_cache lifecycle management)
Thread-Topic: WARNING bisected (was Re: [PATCH v7 08/10] mm: rework non-root
 kmem_cache lifecycle management)
Thread-Index: AQHVoF1pVt08FQpSn0mTl/Eav2YKR6eV2PuAgAAAewCAAB1+AIAAINIA
Date:   Thu, 21 Nov 2019 20:43:01 +0000
Message-ID: <30a2e4babdcb22974a0a5ae8c5e764d951eef7dc.camel@fb.com>
References: <20190611231813.3148843-9-guro@fb.com>
         <20191121111739.3054-1-borntraeger@de.ibm.com>
         <20191121165807.GA201621@localhost.localdomain>
         <c6a2696b-6e35-de7c-8387-b21285b6776f@de.ibm.com>
         <20191121184524.GA4758@localhost.localdomain>
In-Reply-To: <20191121184524.GA4758@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR17CA0043.namprd17.prod.outlook.com
 (2603:10b6:405:75::32) To BYAPR15MB3479.namprd15.prod.outlook.com
 (2603:10b6:a03:106::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:480::a26a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f101499-f109-46db-7b67-08d76ec3669a
x-ms-traffictypediagnostic: BYAPR15MB3304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33041C732BB35F7A76181E12A34E0@BYAPR15MB3304.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(346002)(396003)(136003)(199004)(189003)(118296001)(66446008)(66946007)(66476007)(66556008)(64756008)(8936002)(11346002)(446003)(2616005)(6246003)(14454004)(6116002)(25786009)(4001150100001)(7416002)(81156014)(81166006)(6486002)(6436002)(8676002)(6512007)(229853002)(110136005)(4744005)(305945005)(7736002)(54906003)(478600001)(6506007)(256004)(52116002)(2906002)(76176011)(4326008)(316002)(386003)(99286004)(36756003)(102836004)(71190400001)(71200400001)(86362001)(46003)(186003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3304;H:BYAPR15MB3479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mfQ4hyYx6OTUR/Dh9m4aPp5IYVySMTOoDwndjjEre3GN/1FGVBeVp2Qy7siVzbTbm+LhDRasBhtvTmRW9pBSMpxrAPlCUr9cDQ2xVLBUwJBAq7Cupgkjy2Bo21g7E6cdW+fSVLa1WaFwELGCSdLqcJQsISVik+1i372n9N64BTIB5oF71ho9roECVLBXBxJHuc9kMMQYo703lKt8N3Zosj0G8Ebx2GA/k6Y2Gbdax3jo4j8x2ds/DxiGQ5DfkXFXnERe2WkBdzFcdexw4JFrQggWnzB+17SnEziAJykW++gGgrDZ50KzCGXZ0TbYH3tfNA6C01Od5AbL9e2gWxZiQGhlgWtIucijSAtXsJAWTZuwGisfGxGXNx0hBZaiomEFM75JD9Lk3Z+0qxUQmEa3/tVLKefa3ANENcclgOuknp7WmDIKbV+FpLSdezCH7EFX
Content-Type: text/plain; charset="utf-8"
Content-ID: <20E83B82BFF3D4409CB703A480B74BCA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f101499-f109-46db-7b67-08d76ec3669a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 20:43:01.8191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sljGzrdD6UfepClnBFPmIIIfcwrqxVIgrCBeDWClTqEnDzG1K1Id0AElkjd9YKIZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3304
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_05:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 mlxscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210172
X-FB-Internal: deliver
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDE5LTExLTIxIGF0IDEzOjQ1IC0wNTAwLCBSb21hbiBHdXNoY2hpbiB3cm90ZToN
Cj4gT24gVGh1LCBOb3YgMjEsIDIwMTkgYXQgMDU6NTk6NTRQTSArMDEwMCwgQ2hyaXN0aWFuIEJv
cm50cmFlZ2VyDQo+IHdyb3RlOg0KPiA+IA0KPiA+IA0KPiA+IFllcywgcm1tb2QgaGFzIHRvIGJl
IGNhbGxlZCBkaXJlY3RseSBhZnRlciB0aGUgZ3Vlc3Qgc2h1dGRvd24gdG8NCj4gPiBzZWUgdGhl
IGlzc3VlLg0KPiA+IFNlZSBteSAybmQgbWFpbC4NCj4gDQo+IEkgc2VlLiBEbyB5b3Uga25vdywg
d2hpY2gga21lbV9jYWNoZSBpdCBpcz8gSWYgbm90LCBjYW4geW91LCBwbGVhc2UsDQo+IGZpZ3Vy
ZSBpdCBvdXQ/DQo+IA0KPiBJIHRyaWVkIHRvIHJlcHJvZHVjZSB0aGUgaXNzdWUsIGJ1dCB3YXNu
J3Qgc3VjY2Vzc2Z1bCBzbyBmYXIuIFNvIEkNCj4gd29uZGVyDQo+IHdoYXQgY2FuIG1ha2UgeW91
ciBjYXNlIHNwZWNpYWwuDQoNCkkgZG8gbm90IGtub3cgZWl0aGVyLCBidXQgaGF2ZSBhIGd1ZXNz
Lg0KDQpNeSBndWVzcyB3b3VsZCBiZSB0aGF0IGVpdGhlciB0aGUgc2xhYiBvYmplY3Qgb3IgdGhl
DQpzbGFiIHBhZ2UgaXMgUkNVIGZyZWVkLCBhbmQgdGhlIGttZW1fY2FjaGUgZGVzdHJ1Y3Rpb24N
CmlzIGNhbGxlZCBiZWZvcmUgdGhhdCBSQ1UgY2FsbGJhY2sgaGFzIGNvbXBsZXRlZC4NCg0K
