Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD171D34F0
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgENPVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:21:48 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:21716 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgENPVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 11:21:48 -0400
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EFHqdI007697;
        Thu, 14 May 2020 08:21:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=/SIyav4b4i+PBVCyb5xORlCbeIFaGjmshUIMMlS2NxU=;
 b=eSAn7nCHnGuHmmAzvVbd85Ow3Zb5tXR+z4e+dugr2DXMrLgIQsZdUeASEyl273z3aA9O
 cfBhyanWlsU8XC6mUxEs92kYWz/rIZJSz3R4Bzh4Z9ZSxDBqc1QQrGQuuu4fl22YFHvE
 mmFCFPeZl+nOkp2W9NKkMVm4XRlVfzIjF1OAb9qN7/N0ydMTKe7rjUgbjQS3F+Vnl9i+
 w5O0RCPERz+pM4/0dArVj8MX4q/t2sAy1O4GWqUkKAsELtBA9XzROjEzTo3urNdY6Sjk
 owZEIjpAKLKBKej0UKYtNzVMS4+aXx+fyXNOrUheeCXSCkR6grxaHTJwBgdv7EcAk2zO FA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2055.outbound.protection.outlook.com [104.47.36.55])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3100y84ugv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 08:21:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jw4MdgHBjPLtsoKBNtLQ0jpIxyyPZliacEApPsZrO2M/0na6olpROyRsnBhvF6Xmh+YS8sgGJYZq6WXxLeVcxDNonGdqCwydg1ibSakYPJDUHu9NZz+vP8AC5ASvYjdr4xZjZI0pv+FEXCtdEAeQhbdrjbnl9AOF6AKR8IQaZm0efpJkHM95ejMlci6RBIW/7VUMocqMMFm0zG6KZdL58HdsKFRjuBisgZyhNBoS/sxNGW23oPQNFlOXjdZ9JGZ0885s9J6oxZANrvPNc+FCysxCG30zZ/o7XEK6hChgB/mFvBsX0sAIAKecJf1EXDnWA7d6SundrNRSTvLpJF0rSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SIyav4b4i+PBVCyb5xORlCbeIFaGjmshUIMMlS2NxU=;
 b=bfP/Ofb1ujoqO/4xKQub5S5aXtvYghPHI+Z1YrgR2gmUzquYMffP4l/6jnirCmjEePySxMHzc/t7Lk3UrzEE7AONnwWXcMP2/sAUCTpfBcEDpUh8toVO/6X+TtEMQ8f/7+cONiC2bvFRsoBiFlSCSKcc930omOiMc9xeLAIVCxqQDtDGt304BdL9awAqIlbYEOM+Z1/9MqoSRkT7NZyLpmkcc/+Jn3TVI9DLuoHN8QpszhKRfAQxdTqLlTErPBVAS3j2Fkc8RzyVsmK1BMs8wG1cnSi4C35AK2YV+UO4x3eSWJr8Wz6H34G8PjEdj2T8/WSy2wWLGrXq7AZd6g4HVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BYAPR02MB5735.namprd02.prod.outlook.com (2603:10b6:a03:128::30)
 by BYAPR02MB5558.namprd02.prod.outlook.com (2603:10b6:a03:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Thu, 14 May
 2020 15:21:44 +0000
Received: from BYAPR02MB5735.namprd02.prod.outlook.com
 ([fe80::b1a7:d1d2:ec70:66e]) by BYAPR02MB5735.namprd02.prod.outlook.com
 ([fe80::b1a7:d1d2:ec70:66e%5]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 15:21:44 +0000
From:   Suresh Gumpula <suresh.gumpula@nutanix.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Virtual LAPIC page corruption
Thread-Topic: Virtual LAPIC page corruption
Thread-Index: AQHWKN3voVV18REUfU2qO8eUl1dg+KinP6qA
Date:   Thu, 14 May 2020 15:21:44 +0000
Message-ID: <5D9BEB18-3073-40CD-AE1E-12A1EBCC7D2A@nutanix.com>
References: <67D1E884-FE2C-44C3-8214-75958A9D445A@nutanix.com>
In-Reply-To: <67D1E884-FE2C-44C3-8214-75958A9D445A@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nutanix.com;
x-originating-ip: [192.146.154.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 414e6392-ca09-4c4b-e0c4-08d7f81a82bc
x-ms-traffictypediagnostic: BYAPR02MB5558:
x-microsoft-antispam-prvs: <BYAPR02MB555899E054443D0200575F4E97BC0@BYAPR02MB5558.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kIpgXr4Cnx1TniWOHvop1fsBBA9Ebm8BV4/LmpGFvRA/k/FoXSs6FWqoruLNznR25q2DGWeTS9TTsZME4PoR9BtUjMJJqfdp9Ww4dUqX7OyHo1YYOjpsCx1DiJF7atjJ5U58Y4r3IoAVMI5R7Gvqnykhzo8im8UMFey0UoRzk5UsacUOJsDez6OOyb5hObfv68qoTejnjSJmwkNfvlD//TKDY3pkebTUF6pSLuSBU8DsqqBc9iAO3Px/0qjeSM9g1XmU11hFBwB/zaz8vC4VnjGRgb2LRaEEHp6n5y1YwwZwKh2vLR9Yca6/AGpwL/Yho/rF5Pq0Xp6qoilmH2Vh4WzcHh6Q46TLDPJ9qqXm64kW2lhk5TcMo3q+bjFN4l4lsuST143HNynvHd1lzLBQ7W4ofMu23aC0Z9Tn4L2g3Kq7cawj1jEfyOKZ1gkEP03agI6RXM1miQIqF4xYBQ4f3wRrCxNUL1EwXxPWF/SU1ESO+CjkmcKUUgqtXkomgwU603sxS0855Eq3QvdMtPJ+yw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5735.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(110136005)(6506007)(8676002)(66946007)(66476007)(8936002)(66556008)(3480700007)(66446008)(71200400001)(186003)(6512007)(76116006)(316002)(64756008)(450100002)(6486002)(26005)(33656002)(86362001)(5660300002)(2616005)(36756003)(2906002)(966005)(478600001)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RrSbww/YTVSRpZBSkR9wOpOzYKPpHqTaFrAnafz7ta8Yc0mp9eOhkEs5yDyyh1Ubzuz4x3IT5Au8QR8Cr9ancGFtJym3AwFl2yDSgbVrFw+u9pv1eMj99uvILPF1ksMobCvVb7Me0358psHL/Pf6jsesOWk7VCePK9IZ1wc96iDrNmqUT6RQl/7kq7huXYUwtrCpWsUmgZXuLl9i1FLOXpawZgoVsS01akuGobeqlN3V3z9Sz+TSKBgIoJXof4QHFXWyKWqTyGBaP+71v/oa+37n/xR14hh38BcGRgJh47dlNkElK+XHuFI2XKcFSzD3OfVuuo9gP6ln/+BFXqPppiWB3uStCo8GLOXO4y31r2eFmbCPgeABwzxvToh22TvsXFyr/9sxlZfFJy6GP4mKIOOSLiL1Pkjdc0Qb2uSBG1lO3kQLX+YNBdkLCDNT5+aDpQTPfzA7Vb63MwNH5jmomtZAiQQbgpmiLDKlcPAv6JY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F091006D4703B4492EE03385626B1B6@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 414e6392-ca09-4c4b-e0c4-08d7f81a82bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 15:21:44.1229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iIMFHhE3o9dSl2rh48st7ErHKiT9GOplNTjKQkaH+aZaw4XTHwWSABL8QP/cxKzah4nYtwocv+21u/D66e6Sv4WVdzYD5E1/vETeq37IsIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5558
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QXBwZWFycyB0aGlzIGFsc28gY2FuIGJlIHJlcHJvZHVjZWQgd2l0aCA1LjQga2VybmVsIHRvby4N
CkFuZCBmcm9tIHdpbmRvd3MgZGVidWdnZXIgZHVtcCwgYXJnMyB0aGUgTFZUVCAweDMyMCAgc2Vl
bXMgY29ycnVwdGVkIA0KYW5kIHRoZSBwYXRjaGd1YXJkIGNvbXBsYWluaW5nLiBCdXQgYWxzbyBm
cm9tIHRoZSBkdW1wIGZ1bGwgbGFwaWMgNGsgcGFnZSBpcyAwLCBub3QganVzdCAweDMyMCBvZmZz
ZXQuDQoNClRoYW5rcywNClN1cmVzaA0KDQrvu79PbiA1LzEyLzIwLCA5OjIxIFBNLCAia3ZtLW93
bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2YgU3VyZXNoIEd1bXB1bGEiIDxrdm0tb3du
ZXJAdmdlci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBzdXJlc2guZ3VtcHVsYUBudXRhbml4LmNv
bT4gd3JvdGU6DQoNCiAgICBIaSwNCg0KICAgIFdlIGFyZSBhIHNlZWluZyBhIHByb2JsZW0gd2l0
aCB3aW5kb3dzIGd1ZXN0cygyMDE2LzIwMTJSMikgd2hlcmUgZ3Vlc3QgY3Jhc2hlcyB3aXRoIA0K
ICAgIFZpcnR1YWwgQVBJQyBwYWdlIGNvcnJ1cHRpb24gc2ltaWxhciB0byB0aGUgZm9sbG93aW5n
IHJlZGhhdCB0aWNrZXQuDQogICAgaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3Yy
L3VybD91PWh0dHBzLTNBX19idWd6aWxsYS5yZWRoYXQuY29tX3Nob3ctNUZidWcuY2dpLTNGaWQt
M0QxNzUxMDE3JmQ9RHdJR2FRJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPW53ZGEzbEFQN2hw
NTdIRkNfUkpnbGo2Y2l3ejk4ZC1VNGdyU3pvaTc5bXMmbT1KbUYtQkFHd01CZ0ZwMlM5SFd2YlNz
cU1qOHJKU09fZHlZU3pJbW5nT1ljJnM9bTlOemxYV0lXdGFLc3R2SVpMWkRFU1BoZnZlX3hHWVdq
U0ZfQVdmOUNRUSZlPSANCg0KICAgID4gQXJnNDogMDAwMDAwMDAwMDAwMDAxNywgVHlwZSBvZiBj
b3JydXB0ZWQgcmVnaW9uLCBjYW4gYmUNCiAgICAJMTYgIDogQ3JpdGljYWwgZmxvYXRpbmcgcG9p
bnQgY29udHJvbCByZWdpc3RlciBtb2RpZmljYXRpb24NCiAgICAJMTcgIDogTG9jYWwgQVBJQyBt
b2RpZmljYXRpb24NCg0KICAgIEhlcmUsIHdlIGFyZSBzZWVpbmcgdGhlIGNvcnJ1cHRpb24gTEFQ
SUMgcGFnZSBhbmQgZ3Vlc3QgaXMgQlNPRCdpbmcuDQogICAgTG9va2luZyBhdCB0aGUgZ3Vlc3Qg
d2luZG93cyBkdW1wLCB3ZSBzZWUgdGhlIGZ1bGwgcGFnZSBpcyB6ZXJvZWQuIEFuZCBpdCBzZWVt
cyB0aGUgDQogICAgR3Vlc3Qgd2luZG93cyBrZXJuZWwgcGF0Y2hndWFyZCBpcyBkZXRlY3Rpbmcg
dGhpcyBjYXNlIGFuZCByZXNldHRpbmcgdGhlIFZNLg0KDQogICAgSXMgaXQgcG9zc2libGUgdGhh
dCBLVk0sIHNvbWVob3cgY29ycnVwdGVkIHRoZSB2aXJ0dWFsIExBUElDIHBhZ2U/ICBXaGlsZSB0
aGUgZ3Vlc3QgaXMgcnVubmluZw0KICAgIHRoZSBLVk0gaXMgbm90IHN1cHBvc2VkIHRvIHRvdWNo
IHRoYXQgdmNwdSBsYXBpYyBwYWdlPw0KDQogICAgQ291bGQgeW91IHBsZWFzZSBnaXZlIHVzIHNv
bWUgcG9pbnRlcnMgb24gd2hhdCBjb3VsZCB3cm9uZyBoZXJlLiBJcyBpdCBhIGtub3duIGlzc3Vl
IGluIHRoZSBrdm0/DQogICAgV2UgYXJlIHVzaW5nIHRoZSBob3N0IGtlcm5lbCA0LjE5IGFuZCBx
ZW11IDIuMTIgYW5kIHdpbmRvd3MgZ3Vlc3RzKDIwMTYvMjAxMikNCg0KDQogICAgVGhhbmtzLA0K
ICAgIFN1cmVzaA0KDQoNCg0KDQo=
