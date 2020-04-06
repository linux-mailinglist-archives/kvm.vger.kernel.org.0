Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6223119F8DF
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgDFPam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 11:30:42 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:37222 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728853AbgDFPam (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 11:30:42 -0400
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 036FT0WX023130;
        Mon, 6 Apr 2020 08:30:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=UlQYHzgJZDMcw2Pooj/ubI/CghqfujXuzuKqHh+ezQM=;
 b=hCsD2RRHH6Nc/Llo9JZjs6x/mOTRR5bz54pk/sv6uooJaKwNtAlnklV80gA+F619g1ec
 mPX2eHBmEUlYcg+AuFrYfkWJK3IVtD6RvccMxgPdiroOT+YoWPNcRmv2gK87cUoPWvGd
 hUMXwha6eM/C0GTJMzhifb4VJ7MKchhejlv8b4MnAmBAueXi98BUGmjgP2PkAeLjmC8u
 XHcskLrXo6E+jNl+Bn58rd2QjHZSKEu25B7zg0/QYC0rQBI2d8GI/Xh+r6d7N2bQqFTb
 r8y791v6GwI1jVMwrBFRSA+eYS7yk0fkXaFnSH0wuADsVhiBE6BJfuw9hjdFo7Q/8nBa XA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-002c1b01.pphosted.com with ESMTP id 306p5abysk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 08:30:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDzbu5hCLoDGEeIiMRyTK5HBtenig6pW/WHHcZ1TTI+egjQLp/eHhVz6NQXPosl8Q4E5WLKTLE2OUVXP6DFz/NnWnwB96mwx0kVYE0JXo339GJYGpcI2DsYy5Lwz8t4mnpJREcCdq+QNfsXktGCPS51NEqPXQQkm/vE/crz3xVlcchkGjfgb/4bZB6+cIc9IE5PokSZLcylQgNuwBUsoKBtsTf8D4904E2KfgIqV7HJhf1xIsEK51vb8cUboogYqZJxR1XgjCfEXyu6iYfws8wmJdP/euTDERANDViiQrgIEyBlDGm7f/ymlb2dvpNryDmpqkEF1V9GnZXxK7zaVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlQYHzgJZDMcw2Pooj/ubI/CghqfujXuzuKqHh+ezQM=;
 b=QCnVuZQEDNXs+UTAuOWD9IYvtj92nuzfmOd12nHwfRqnKNAu1VIU5uxBAHEfBNspqB7jTjsgxjLr+grrVuROz6s3mnicszCZ+GfOpLz/NNjWnJVMgbdmypvWtM1cj5twc7chaAahFU2D7cYQRUkyJuV31Na3UptTUavJfJcupLzDLB83+xb+7u1NM0jOXdWbdrAiHIEwUO0llIcwuZr2kpdBAnA6vEey46baB/+i6ni44aPV6I/h0/TD15QYdliiyPbKaJdCctWLY9Dw7TgK619BPXfRvs3MP6C8ai7DcgkmFblCUopHCpXbhQEydHhot0Dzh8wQQWODY9ZU5SlJzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BYAPR02MB4293.namprd02.prod.outlook.com (2603:10b6:a03:56::10)
 by BYAPR02MB5158.namprd02.prod.outlook.com (2603:10b6:a03:6c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.21; Mon, 6 Apr
 2020 15:30:37 +0000
Received: from BYAPR02MB4293.namprd02.prod.outlook.com
 ([fe80::9128:c9f2:ce5d:ffb1]) by BYAPR02MB4293.namprd02.prod.outlook.com
 ([fe80::9128:c9f2:ce5d:ffb1%6]) with mapi id 15.20.2878.021; Mon, 6 Apr 2020
 15:30:36 +0000
From:   Suresh Gumpula <suresh.gumpula@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ata driver loading hang on qemu/kvm intel
Thread-Topic: ata driver loading hang on qemu/kvm intel
Thread-Index: AQHWCtnRdUw08txLJ0GRwS5YdMwr1KhrwK+AgAAE5wA=
Date:   Mon, 6 Apr 2020 15:30:36 +0000
Message-ID: <D7D964C2-DD4B-4F17-BA3D-C45C992A4B15@nutanix.com>
References: <7C92AFF4-D479-4F80-8BED-6E9B226DFB72@nutanix.com>
 <56486177-b629-081e-2785-b6e2ca626e88@redhat.com>
In-Reply-To: <56486177-b629-081e-2785-b6e2ca626e88@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:647:4502:bdd0:4cdf:f7d4:9ceb:8e83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5755a698-af48-4204-a21d-08d7da3f747c
x-ms-traffictypediagnostic: BYAPR02MB5158:
x-microsoft-antispam-prvs: <BYAPR02MB51581FAABE60B7EBB9300EDB97C20@BYAPR02MB5158.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4293.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(396003)(39860400002)(366004)(136003)(376002)(36756003)(81156014)(6512007)(316002)(81166006)(6486002)(8936002)(8676002)(2616005)(186003)(5660300002)(53546011)(76116006)(6506007)(33656002)(86362001)(966005)(66556008)(64756008)(110136005)(66476007)(66446008)(478600001)(2906002)(44832011)(66946007)(71200400001);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: nutanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fFrnAjqw6yEShR1/NAhOpfK0mi5r+flvw155kSYPmSpweOhRYKIB6khO+BclZyyf1v7czalvt3qfurQvKX9n3hhy8s9qyJwK9gD9KU1H08monvoJCW+yWZnmwBfGV+so9S4rhFAx/9cmGzPZhEyZVBJ6Ibe5f6U4t73wuzUrhXIMJW+GUhlwOkxthm7GafsHh+2nQDnvS0acNsVjC5N94mVMQ9ug5i7Wo2gLnrpRp748ksLFje6bGrg9PWMpTexp2q6IA38IHzkPcYOrudwhMrDbwhGojJQhpkRmBwexH1PnwM9f+S1vtvkUaP1vqjqh9r9GDtUlQOci93mqRgh6RyuC9OQ4GtJo+u7jdpXXptmEeGY2HhLjgp9fUbNYgDQlvIytBSFDxAf078DjYMNcwvzK6sMtceFsCN2Kt2YdIPhvrEpxcWWc2iWf0ugiUxs1XQH0XecGI1fnGnkOpfUa8gdcFrodZroEk+so6ZduBagWfvOlUUQcra7/kchDzeFfRbxJIjpZ3qRQScD3P5SIPw==
x-ms-exchange-antispam-messagedata: C2dXXLGH6LO9RRMtGn98SMQZTJdkhmFCV89nRYsIGlyyQlko4TFDzN3RkwWeGYVnOpq4Jv49109gjivaPoDCHiYANuB1DaLYBbeTAI1Wu4pi8Duk1O5Acn8DbGV/WFcRDQZa7YCetejuHOHcKqkUdwyYNDtezcHETeawtqW/DHEe2DTuzsoQZIUiRJFeFmErVbNgOSoKJQ3bs0Go627jZg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACD5483A9FAEB345BB235293D97F8400@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5755a698-af48-4204-a21d-08d7da3f747c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2020 15:30:36.7474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BMUlSnxs/d6XXYhtU3jEf/reE2QcToe2DK8wqPl/mprCUGVd3BGxYeH0YcXuWTpexKI3CPxPPbCq1kNIoeglrOuPWxvOwdMjfM0Ms5xP6aQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5158
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-06_08:2020-04-06,2020-04-06 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGFvbG8sDQoNClRoYW5rcyBtdWNoIGZvciB0aGUgcXVpY2sgcmVzcG9uc2UuDQpXZSBhcmUg
bm90IHJ1bm5pbmcgbmVzdGVkIGd1ZXN0IGhlcmUgLCBqdXN0IGVuYWJsZWQgaW4gdGhlIGhvc3Qs
IHNvIHRoZSBob3N0IGlzIGNhcGFibGUgb2YgcnVubmluZyBuZXN0ZWQsIGJ1dCB3ZSBhcmUgbm90
IHJ1bm5pbmcgbmVzdGVkIGd1ZXN0cy4NCg0KVGhlIGd1ZXN0IGtlcm5lbChub3QgYSBuZXN0ZWQg
Z3Vlc3QpIGJvb3QgaXNvLiBpLmUgaXRzIHJlZ3VsYXIgVk0gb24gYSBob3N0IGlzIGhhbmdpbmcg
d2l0aCBmb2xsb3dpbmcgZXJyb3JzLg0KSXRzIGNvbnNpc3RlbnRseSByZXByb2R1Y2libGUgd2l0
aCBzb21lIGxvYWQgb24gdGhlIGhvc3QuDQoNCkd1ZXN0IHNlcmlhbCBsb2c6DQpbICAgIDEuNDE0
MDM1XSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDYxNDRrDQpb
ICAgIDEuNDE4MDA2XSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiAxMDgwSw0KWyAgICAx
LjQyMzAzM10gRnJlZWluZyB1bnVzZWQga2VybmVsIG1lbW9yeTogMTAwNEsNClsgICAgMS40NjY3
ODNdIHNjc2kgaG9zdDA6IGF0YV9waWl4DQpbICAgIDEuNDY5NTM5XSBzY3NpIGhvc3QxOiBhdGFf
cGlpeA0KWyAgICAxLjQ3MjAzOV0gYXRhMTogUEFUQSBtYXggTVdETUEyIGNtZCAweDFmMCBjdGwg
MHgzZjYgYm1kbWEgMHhjMzAwIGlycSAxNA0KWyAgICAxLjQ3NTc0MF0gYXRhMjogUEFUQSBtYXgg
TVdETUEyIGNtZCAweDE3MCBjdGwgMHgzNzYgYm1kbWEgMHhjMzA4IGlycSAxNQ0KIA0KR3Vlc3Qg
dmNwdSByZWdpc3RlcnM6DQpbcm9vdEBOVE5YLU1BRE1BWDAxLUEgfl0jIHZpcnNoIHFlbXUtbW9u
aXRvci1jb21tYW5kIC0tZG9tYWluIDMwMTQgLS1obXAgLS1jbWQgaW5mbyByZWdpc3RlcnMgLWEg
fGVncmVwIC1pIOKAmGVpcHxyaXDigJkNClJJUD1mZmZmZmZmZjg0MmY5ODg3IFJGTD0wMDAwMDI0
NiBbLS0tWi1QLV0gQ1BMPTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9MQ0KRUlQPTAwMGZkMGY1IEVG
TD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9MQ0KRUlQPTAw
MGZkMGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9
MQ0KRUlQPTAwMGZkMGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9MCBBMjA9MSBT
TU09MCBITFQ9MQ0KRUlQPTAwMGZkMGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9
MCBBMjA9MSBTTU09MCBITFQ9MQ0KRUlQPTAwMGZkMGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0g
Q1BMPTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9MQ0KRUlQPTAwMGZkMGY1IEVGTD0wMDAwMDAxMiBb
LS0tLUEtLV0gQ1BMPTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9MQ0KRUlQPTAwMGZkMGY1IEVGTD0w
MDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9MQ0KRUlQPTAwMGZk
MGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9MQ0K
RUlQPTAwMGZkMGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9MCBBMjA9MSBTTU09
MCBITFQ9MQ0KRUlQPTAwMGZkMGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BMPTAgSUk9MCBB
MjA9MSBTTU09MCBITFQ9MQ0KRUlQPTAwMGZkMGY1IEVGTD0wMDAwMDAxMiBbLS0tLUEtLV0gQ1BM
PTAgSUk9MCBBMjA9MSBTTU09MCBITFQ9MQ0KICANCg0KUWVtdSB0cmFjZSBsb2dzOg0KY2RfcmVh
ZF9zZWN0b3IgMC44NjYgcGlkPTY4ODUzIGxiYT0weDYwZg0KY2RfcmVhZF9zZWN0b3JfY2IgODku
NzMwIHBpZD02ODg1MyBsYmE9MHg2MGYgcmV0PTB4MA0KaWRlX2F0YXBpX2NtZF9yZXBseV9lbmQg
MS4wODQgcGlkPTY4ODUzIHM9MHg1NWRkOTBjZGUwYTggdHhfc2l6ZT0weDgwMCBlbGVtX3R4X3Np
emU9MHgwIGluZGV4PTB4MA0KaWRlX2F0YXBpX2NtZF9yZXBseV9lbmRfYmNsIDAuMzQyIHBpZD02
ODg1MyBzPTB4NTVkZDkwY2RlMGE4IGJjbD0weDgwMA0KaWRlX2F0YXBpX2NtZF9yZXBseV9lbmRf
bmV3IDAuNDg1IHBpZD02ODg1MyBzPTB4NTVkZDkwY2RlMGE4IHN0YXR1cz0weDU4DQppZGVfYXRh
cGlfY21kX3JlcGx5X2VuZCAyOTguMjAzIHBpZD02ODg1MyBzPTB4NTVkZDkwY2RlMGE4IHR4X3Np
emU9MHgwIGVsZW1fdHhfc2l6ZT0weDAgaW5kZXg9MHg4MDANCmlkZV9hdGFwaV9jbWRfcmVwbHlf
ZW5kX2VvdCAwLjU1NCBwaWQ9Njg4NTMgcz0weDU1ZGQ5MGNkZTBhOCBzdGF0dXM9MHg1MA0KYm1k
bWFfcmVhZCAxNTUwMDg5LjE2MCBwaWQ9Njg4NTMgYWRkcj0weDIgdmFsPTB4MA0KYm1kbWFfcmVh
ZCA5LjAwMyBwaWQ9Njg4NTMgYWRkcj0weDIgdmFsPTB4MA0KYm1kbWFfcmVhZCA1MTIuMTg2IHBp
ZD02ODg1MyBhZGRyPTB4MiB2YWw9MHgwDQpibWRtYV93cml0ZSA3Ljc3NiBwaWQ9Njg4NTMgYWRk
cj0weDIgdmFsPTB4MA0KYm1kbWFfcmVhZCAyNi4yNzcgcGlkPTY4ODUzIGFkZHI9MHgyIHZhbD0w
eDANCmJtZG1hX3dyaXRlIDcuMjk0IHBpZD02ODg1MyBhZGRyPTB4MiB2YWw9MHgwDQpibWRtYV9y
ZWFkIDEzOTE3LjkwNCBwaWQ9Njg4NTMgYWRkcj0weDIgdmFsPTB4MA0KYm1kbWFfd3JpdGUgNy44
NDMgcGlkPTY4ODUzIGFkZHI9MHgyIHZhbD0weDANCmJtZG1hX3JlYWQgMzgyLjg0OSBwaWQ9Njg4
NTMgYWRkcj0weDIgdmFsPTB4MA0KYm1kbWFfd3JpdGUgNy4yODAgcGlkPTY4ODUzIGFkZHI9MHgy
IHZhbD0weDANCiANCg0KQWxsIHRoZSBndWVzdCB2Y3B1cyBhcmUgaW4gaGFsdCBzdGF0ZShobHQ9
MSkgYW5kIG9ubHkgb25lIHZjcHUgaXMgaW4gNjQgYml0IGFuZCByZXN0IGFsbCBpbiAzMi4NCkkg
YW0gdGhpbmtpbmcgcHJvYmFibHkgZ3Vlc3QgbWlzc2VkIGFuIGludGVycnVwdCBhbmQgd2FpdGlu
ZyBmb3IgZXZlci4NCk5vdCBzdXJlIGlmIHRoaXMgaXMgaWRlIGVtdWxhdGlvbiBpc3N1ZSBpbiB0
aGUgcWVtdSBvciBhIGJ1ZyBpbiB0aGUga3ZtIG1vZHVsZS4NCg0KDQpUaGFua3MsDQpTdXJlc2gN
Cg0KDQoNCu+7v09uIDQvNi8yMCwgMToxMyBBTSwgIlBhb2xvIEJvbnppbmkiIDxwYm9uemluaUBy
ZWRoYXQuY29tPiB3cm90ZToNCg0KICAgIE9uIDA1LzA0LzIwIDAxOjM2LCBTdXJlc2ggR3VtcHVs
YSB3cm90ZToNCiAgICA+IEhpLA0KICAgID4gDQogICAgPiBJIGFtIHNlZWluZyB0aGlzIG9sZCBw
cm9ibGVtIHdpdGggcWVtdSAyLjEyL2tlcm5lbCA0LjE5Ljg0KGludGVsIGt2bQ0KICAgID4gd2l0
aCBuZXN0aW5nIGVuYWJsZWQpIGFuZCBndWVzdCBrZXJuZWwgNC4xMA0KICAgID4gDQogICAgPiBo
dHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2J1Z3pp
bGxhLnJlZGhhdC5jb21fc2hvdy01RmJ1Zy5jZ2ktM0ZpZC0zRDEzNDU5NjQmZD1Ed0lGYVEmYz1z
ODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9Ri15Z1E5OTNOT2p6ZUVuekU0bTFZUU0yZGtrb0YwdXFP
ZEMwY3VTSlNRYyZtPTM3cHo2cHFadUFvT18yTkhZZk9EbFhveFhwUUJjZ0JyaDZheGRhaDZhcWMm
cz1UOVpjSTlSei1QU0c2TTB0RE9mMTFEbktrX09US1hJQW94V1BzS3V6UlZFJmU9IA0KICAgID4g
DQogICAgPiBDb3VsZCB5b3UgcGxlYXNlIGFkdmlzZSBtZSBvbiB0aGlzPyAgSSBhbSBzZWVpbmcg
dGhlIGV4YWN0IHNhbWUgcHJvYmxlbQ0KICAgID4gd2hlcmUgdGhlIGF0YSBkcml2ZXIgbG9hZCB3
YXMgc3R1Y2suDQogICAgPiANCiAgICA+IFJlYWxseSBhcHByZWNpYXRlIGlmIHlvdSBjb3VsZCBn
aXZlIHNvbWUgcG9pbnRlcnM/DQogICAgPiANCiAgICA+IElzIGl0IGEga25vd24gaXNzdWUgd2l0
aCBuZXN0aW5nPyBPciBpcyB0aGlzIGJ1ZyBmaXhlZCBpbiBsYXRlc3Qga3ZtIG1vZHVsZT8NCiAg
ICANCiAgICBIaSwgdGhhdCBidWcgd2FzIHNwZWNpZmljIHRvIHJ1bm5pbmcgdW5kZXIgUmF2ZWxs
bywgbm90IG9uIGJhcmUgbWV0YWwuDQogICAgSSBoYXZlIG5vdCByZWNlaXZlZCBhbnkgb3RoZXIg
cmVwb3J0cy4NCiAgICANCiAgICBUbyBjbGFyaWZ5IHlvdSBoYXZlOg0KICAgIA0KICAgIC0gUUVN
VSAyLjEyIGFuZCBrZXJuZWwgNC4xOS54IG9uIHRoZSBob3N0DQogICAgDQogICAgLSBrZXJuZWwg
NC4xMC54IG9uIHRoZSBndWVzdA0KICAgIA0KICAgIFdoYXQgUUVNVSB2ZXJzaW9uIGlzIHJ1bm5p
bmcgaW4gdGhlIGd1ZXN0IGFuZCB3aGF0IGtlcm5lbCB2ZXJzaW9uIGluIHRoZQ0KICAgIG5lc3Rl
ZCBndWVzdD8NCiAgICANCiAgICBQYW9sbw0KICAgIA0KICAgIA0KDQo=
