Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63CD19EE1E
	for <lists+kvm@lfdr.de>; Sun,  5 Apr 2020 22:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgDEUq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Apr 2020 16:46:29 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:52210 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbgDEUq3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Apr 2020 16:46:29 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Apr 2020 16:46:28 EDT
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 035KiF4i021589;
        Sun, 5 Apr 2020 13:46:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=pWQLmLUv/9TlL3EJseNUR9UlOYb5mG9bHDDNAuDN+lM=;
 b=cw6WZ/K/mJhMzmnEOGbORYpmL72X2jtXr1CaOmUuOZVfSYTeq0jKVsFzjiFh3jfbl7H9
 ZEblTbrepbCpfz+76EbSe5vM8lWKFcRuChqAsvee/3nJr3LwG1raIe+Fqqdg/DVp6gNq
 E/cTetASBMhpYcpMzIY3F/+3jZQVQK96hi+jmjhi/2H/LFTnyVAtr7t/nJ2vvkLugRsC
 DLhRfOrwgX6HLencTTFWc1JdX+Z1qRHtAwsIRyhoZr+FALPcI7p8j1D/3WxsinEBD22T
 NPHwWz/fBvYwfgWsKOMe24CII90cZ4rhhadoeFnHc7ZjGM9SDkHxKrdsd3wSOjNcdEz3 Og== 
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by mx0a-002c1b01.pphosted.com with ESMTP id 306ssysx90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Apr 2020 13:46:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cA5gifHxwLXhSEdtfCi4KhTG/+JonFKu1vosFvf4VPnV27vLWOGEyA9HPSK77r8oZ3fgmCZ87Z49alD1/thQkl+DKTeadCxGqLKx4xIcf40bSiSe+LpI7tjbJsplTXOU2Yp2R3StBhbu2zu/Hd3HfZSRRh8aTf/FcF7VaE1UJWSvNvX3mAJD5VWmQ6lZO9YRzfyvpAlnumB3Xf5d10RwEqvW3bBDmyNyGOTtYL37qa9RXnNyiCY+MMGLfMKMiaECCvy6xxbn9Nnwv/x/dF3GV+XTH2JlJKzLGHgFRnm0vq+Dv/zmO9vbPZPNO+7BAbts0MvVIaUM9O4J1xCf4YwGtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWQLmLUv/9TlL3EJseNUR9UlOYb5mG9bHDDNAuDN+lM=;
 b=Wapc+XTsLPcDkf7nT/RILAUCw8RW5UvLHDuN/59w3qneMPk8oKsvkkeqLKzTGXicDLzEGnj87djCJv8v4kexIwl5ZEoXJSLeYUc29k9x4fWz/51qftcW19MM/yJrdTg+h5qUVjowA/77iRXZE9bNjqZNkQmWwzxcPmevmVh0qM8YG3Aw/HJauKEog2XXzvs5ToXSy/pdJ/6cBaQ4vN1lHRqhXLQ8cV+2SFskJdOm9qRimJDW1uHq8etY43QPtgqGa3MyqV/iMmPBesDCVLx8yOj/BazHbsbD/dqiGaoXrIqSonWVgxe2LU64nEhyRzAdD8y6n17/DONuUB3/Oz0ZaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BYAPR02MB4293.namprd02.prod.outlook.com (2603:10b6:a03:56::10)
 by BYAPR02MB5223.namprd02.prod.outlook.com (2603:10b6:a03:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Sun, 5 Apr
 2020 20:46:23 +0000
Received: from BYAPR02MB4293.namprd02.prod.outlook.com
 ([fe80::9128:c9f2:ce5d:ffb1]) by BYAPR02MB4293.namprd02.prod.outlook.com
 ([fe80::9128:c9f2:ce5d:ffb1%6]) with mapi id 15.20.2878.021; Sun, 5 Apr 2020
 20:46:23 +0000
From:   Suresh Gumpula <suresh.gumpula@nutanix.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: ata driver loading hang on qemu/kvm
Thread-Topic: ata driver loading hang on qemu/kvm
Thread-Index: AQHWCtlGurR6xE9A6EGj9PYxqWOCq6hqd2mAgAAB7ACAAA8HgIAAAX2AgAABpIA=
Date:   Sun, 5 Apr 2020 20:46:23 +0000
Message-ID: <34B5C17E-3022-419A-BCB2-5B938FF5E44D@nutanix.com>
References: <D02A294C-2823-4137-BD1B-9A0F76270D2B@nutanix.com>
 <3752A519-BE1A-478F-920F-75F101807694@nutanix.com>
 <CFD00AFB-8B52-475E-8CB6-FCB7967E0316@nutanix.com>
 <1A6AC1FC-AED9-476C-9178-BE293E981E56@nutanix.com>
 <FF9D9722-4FA8-4630-AB3A-1D077D7D0991@nutanix.com>
In-Reply-To: <FF9D9722-4FA8-4630-AB3A-1D077D7D0991@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:647:4502:bdd0:4cdf:f7d4:9ceb:8e83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe8cf141-95a9-40cd-f8d1-08d7d9a2671c
x-ms-traffictypediagnostic: BYAPR02MB5223:
x-microsoft-antispam-prvs: <BYAPR02MB522385BC288E604C8164EA0E97C50@BYAPR02MB5223.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03648EFF89
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4293.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(366004)(396003)(136003)(376002)(346002)(316002)(66946007)(66446008)(33656002)(110136005)(2906002)(6506007)(71200400001)(53546011)(66556008)(478600001)(6486002)(86362001)(64756008)(186003)(5660300002)(66476007)(81156014)(81166006)(6512007)(8936002)(44832011)(2616005)(76116006)(8676002)(966005)(36756003);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: nutanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a8MrxvNCQezx5XaQImVxMEww5k/IezzSEqHH4QjVCLvDVcN6IDrVvccykA+pLTs+IQYO5DqtfxdmjuzMoAuJMcM3oD1QtH1oMe7KhIbQDqs8bVailiCo8OtKl0QsOrnMnbgHrr+qnOzksa3ulF2L4DlkvYEsauYZ+p7SeqFi+3sdkeSZbU6K6KXc/nr9e4f+2c0mfX2UV+smmrZt4JVHCQXa/7nXRZTbeN5iAxyzRO/g0GvlHRm/3cS+KorKDPgu+t+kLvvax8FmW3WuRbBaLNbfE+/xhVvLFO7al0c5zZMNuReTcQUebdOX46VyS3bY0nMobQMhgXpFKxkOUZpZVkDnOjOPeCtXcmh26VuFXn5UVdtb8mTejBKQ57oiTEeWdMigvuzUik5Tr+2pPMhP4TXycJxJflZ43XPRa/UKPcDB/dN8d1+jf4nUQtzldRA+MnQwqFAs+2iyxKzDjWljE/wZhzY2upBLB1+Akbidm5j+V75iJp06WPflP/f3AIlyhUOY9Rg5Kyo4A+A6AZAXjg==
x-ms-exchange-antispam-messagedata: JTniuLV0RugECRuMRjGAQ3q3rIZGNCfKAGrPk2jQUSDUJakRo0Wzv7H4adclb9PKRxhnhr9pHaR2rkHv2o7x4Sh+Plg9YsX8OVp6PxDVnNs1tJOtiGglL12Ax3mvhIpa1/P7INqVtoe88GVFf89mmcRrPR6whzi7Kn6frSjJ7X0vD5tU85+YO36bO0yhC02yfoPuLRQ04jjPm91cy+dYJQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B33204EEB3BD674E888769D75EAAD198@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8cf141-95a9-40cd-f8d1-08d7d9a2671c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2020 20:46:23.2666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gQFrqQIQR+8vD9t18AZM17XCnQe7rrYuVrZ0YoFCM7SyzfnRis3PtEQw3sj2Px+O/cColkvWE5tP1pNmCHJMI1vEuVkpbL6ghqNuYlTecjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5223
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-05_10:2020-04-03,2020-04-05 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U29ycnkgLCBtYWlsIGdvdCBib3VuY2VkLiBTZW5kaW5nIGFnYWluDQoNCg0KRnJvbTogU3VyZXNo
IEd1bXB1bGEgPHN1cmVzaC5ndW1wdWxhQG51dGFuaXguY29tPg0KRGF0ZTogU3VuZGF5LCBBcHJp
bCA1LCAyMDIwIGF0IDE6NDAgUE0NClRvOiAia3ZtQHZnZXIua2VybmVsLm9yZyIgPGt2bUB2Z2Vy
Lmtlcm5lbC5vcmc+LCAicGJvbnppbmlAcmVkaGF0LmNvbSIgPHBib256aW5pQHJlZGhhdC5jb20+
DQpTdWJqZWN0OiBSZTogYXRhIGRyaXZlciBsb2FkaW5nIGhhbmcgb24gcWVtdS9rdm0NCg0KVGhl
IGd1ZXN0IGtlcm5lbChub3QgYSBuZXN0ZWQgZ3Vlc3QpIGJvb3QgaXNvIGlzIGhhbmdpbmcgd2l0
aCBmb2xsb3dpbmcgZXJyb3JzLg0KW8KgIMKgIDEuNDE0MDM1XSBXcml0ZSBwcm90ZWN0aW5nIHRo
ZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDYxNDRrDQpbwqAgwqAgMS40MTgwMDZdIEZyZWVpbmcg
dW51c2VkIGtlcm5lbCBtZW1vcnk6IDEwODBLDQpbwqAgwqAgMS40MjMwMzNdIEZyZWVpbmcgdW51
c2VkIGtlcm5lbCBtZW1vcnk6IDEwMDRLDQpbwqAgwqAgMS40NjY3ODNdIHNjc2kgaG9zdDA6IGF0
YV9waWl4DQpbwqAgwqAgMS40Njk1MzldIHNjc2kgaG9zdDE6IGF0YV9waWl4DQpbwqAgwqAgMS40
NzIwMzldIGF0YTE6IFBBVEEgbWF4IE1XRE1BMiBjbWQgMHgxZjAgY3RsIDB4M2Y2IGJtZG1hIDB4
YzMwMCBpcnEgMTQNClvCoCDCoCAxLjQ3NTc0MF0gYXRhMjogUEFUQSBtYXggTVdETUEyIGNtZCAw
eDE3MCBjdGwgMHgzNzYgYm1kbWEgMHhjMzA4IGlycSAxNQ0KwqANCsKgDQpXZSBoYXZlIGVuYWJs
ZWQgbmVzdGVkIGhvc3QsIGJ1dCBub3QgcnVubmluZyBhbnkgbmVzdGVkIGd1ZXN0cy7CoCBTbyBp
dOKAmXMgYSByZWd1bGFyIGd1ZXN0IFZNIG9uIGEgaG9zdC4NCkNhbiBzb21lb25lIHBsZWFzZSBn
dWlkZSBtZSB3aGF0IGNvdWxkIGJlIHdyb25nIGhlcmUuwqAgSXMgaXQgYSBrbm93biBpc3N1ZSBp
biB0aGUga3ZtIG1vZHVsZSBvciBxZW11IGVtdWxhdGlvbiBvZiBJREUvQ0RST00gY29udHJvbGxl
cj8NCsKgDQrCoA0KVGhhbmtzLA0KU3VyZXNoDQrCoA0KwqANCkZyb206IFN1cmVzaCBHdW1wdWxh
IDxzdXJlc2guZ3VtcHVsYUBudXRhbml4LmNvbT4NCkRhdGU6IFN1bmRheSwgQXByaWwgNSwgMjAy
MCBhdCAxOjM1IFBNDQpUbzogImt2bUB2Z2VyLmtlcm5lbC5vcmciIDxrdm1Admdlci5rZXJuZWwu
b3JnPiwgInBib256aW5pQHJlZGhhdC5jb20iIDxwYm9uemluaUByZWRoYXQuY29tPg0KU3ViamVj
dDogYXRhIGRyaXZlciBsb2FkaW5nIGhhbmcgb24gcWVtdS9rdm0NCsKgDQpIaSwNCsKgDQpIb3Bl
IHlvdSBhcmUgZG9pbmcgZ3JlYXQuwqAgSSBhbSBzZWVpbmcgdGhpcyBvbGQgcHJvYmxlbSB3aXRo
IHFlbXUgMi4xMi9rZXJuZWwgNC4xOS44NChpbnRlbCBrdm0gd2l0aCBuZXN0aW5nIGVuYWJsZWQp
IGFuZCBndWVzdCBrZXJuZWwgNC4xMA0KwqANCmh0dHBzOi8vYnVnemlsbGEucmVkaGF0LmNvbS9z
aG93X2J1Zy5jZ2k/aWQ9MTM0NTk2NA0KwqANCkNvdWxkIHlvdSBwbGVhc2UgYWR2aXNlIG1lIG9u
IHRoaXM/wqAgSSBhbSBzZWVpbmcgdGhlIGV4YWN0IHNhbWUgcHJvYmxlbSB3aGVyZSB0aGUgYXRh
IGRyaXZlciBsb2FkIHdhcyBzdHVjay4NClJlYWxseSBhcHByZWNpYXRlIGlmIHlvdSBjb3VsZCBn
aXZlIHNvbWUgcG9pbnRlcnM/DQrCoA0KVGhhbmtzLA0KU3VyZXNoDQrCoA0KwqANCg0K
