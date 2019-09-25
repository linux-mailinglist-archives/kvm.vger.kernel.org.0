Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FFBBD9F0
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442769AbfIYIf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:35:27 -0400
Received: from mail-eopbgr1300104.outbound.protection.outlook.com ([40.107.130.104]:56039
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437424AbfIYIf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:35:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfw/q4rzK5CKgLiOv73dUfLcNWZR+XYhpfzpPA2kM5qX5ovP/LRxTrDnNazALou3QwZurPVfyFcGIZu5v/vouu8jfYL/ninkpaket4P9Yo/DKQH1rfCMPKGkY8Az+sFW7inL+al/di0YPHZ0ZHYp8s1JKChFddXiF4Xb6hGyiVAs+etBX6BCZT/xhvhQDgS9QL5Ha+kBFB7LRRh7b/onYaFLWHrR/zw/qualvEhzB+Dx0eLecaOJqmSWAlarMetOasN01/oY73ODz42F0xSvHcVHVwRugDV+DCXDhtKUqK8Q5VaH0VwE8SKYAUfgagZzew9FTvOw7bF/S73VJkytgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qy1iK7KMmqoFDaTmZqcAfMmMPKiWAHgn8aZiKN+Q1hM=;
 b=KHQcVqMvf5V4O4D6dSbqP6vOhek7kUgrSBafZKrddIVsb+7Q3Dd6scMv7TJdXnoOMSvMSpBtsNzxXMTOqF+C+Jo9EiycVLgxmsUn2GqQU3CV4ePwvDNdEJ7KvBELj60AJEktnG94/aIA24eirxpcEbeE99Gq3CF4C415m0XtJjUZBV/xOKgLjmk4ajtsu4xGl6Y+icPV6Kiv0Zrg+wvAh1XqkZgIDFRm/RP+iPdA5XWprCkiSwITSTazcDTXn/cdVFJyw+Pk45WWqM+XCvdAH4iGWnaJOBIM4djH5+0yk7Vbt+b6xGXF0SwXri7xwjp+FxgjayKU5HxS5M6g/+wzuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qy1iK7KMmqoFDaTmZqcAfMmMPKiWAHgn8aZiKN+Q1hM=;
 b=isj3hjOW7qVPwelrBY/41WmlInACf+Z1/eCYaCiBhaPdThz+E7n/Nz51Yd+isHON3B9l7tiwW0oZLTfv5xnsXxT92K4Zz3rGQO9xAetV7dWhGQk4cPSOGzMBNrHR8wWU3edhS7ZvDxvybqykTzGhOqM3GPZpvVeAV5JQeUgEjJk=
Received: from KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM (52.132.240.14) by
 KL1P15301MB0037.APCP153.PROD.OUTLOOK.COM (10.170.167.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.5; Wed, 25 Sep 2019 08:35:21 +0000
Received: from KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM
 ([fe80::d4ef:dc1e:e10:7318]) by KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM
 ([fe80::d4ef:dc1e:e10:7318%6]) with mapi id 15.20.2327.004; Wed, 25 Sep 2019
 08:35:21 +0000
From:   Tianyu Lan <Tianyu.Lan@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "kbuild-all@01.org" <kbuild-all@01.org>,
        kbuild test robot <lkp@intel.com>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [kvm:queue 4/47] arch/x86/kvm/vmx/vmx.c:503:10: warning: cast
 from pointer to integer of different size
Thread-Topic: [kvm:queue 4/47] arch/x86/kvm/vmx/vmx.c:503:10: warning: cast
 from pointer to integer of different size
Thread-Index: AQHVcwpQT+vrAv2PL0C4ucnPA4OeOKc8EPyAgAAANEA=
Date:   Wed, 25 Sep 2019 08:35:21 +0000
Message-ID: <KL1P15301MB0261174BE76F9F00BCEF68EB92870@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
References: <201909250244.efVzzpnN%lkp@intel.com>
 <874l1093ra.fsf@vitty.brq.redhat.com>
In-Reply-To: <874l1093ra.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=tiala@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-25T08:35:18.7674592Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=166855dd-4d3e-45e3-b0f3-cd12c40f1bf1;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tianyu.Lan@microsoft.com; 
x-originating-ip: [167.220.255.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85987bc7-d39c-438f-f344-08d741934dbf
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: KL1P15301MB0037:|KL1P15301MB0037:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <KL1P15301MB00371083A395CC32E4113E3C92870@KL1P15301MB0037.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(13464003)(199004)(189003)(6246003)(11346002)(446003)(71200400001)(71190400001)(476003)(81166006)(478600001)(7736002)(305945005)(486006)(8676002)(25786009)(74316002)(81156014)(10090500001)(256004)(6436002)(55016002)(76176011)(9686003)(99286004)(5660300002)(229853002)(53546011)(102836004)(10290500003)(14454004)(7696005)(6506007)(26005)(186003)(8990500004)(54906003)(2501003)(76116006)(110136005)(66446008)(64756008)(66476007)(66556008)(66946007)(8936002)(6116002)(33656002)(4326008)(22452003)(3846002)(14444005)(2906002)(86362001)(52536014)(316002)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:KL1P15301MB0037;H:KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1XZV0hHgTgsRst0AyzivS7OoeFPPiLaNXZA28Kt0a4smu/mC3IAHZaaqHV26DJKs+xU4xs4/2Pd8ZjpzSxNxgea738W9m6m8nDOwjrWhPbNrFuGoCqAQoLveTIK7MkDJQANnekH+plIUWpj1vksdEyUBE3dKJEBhjE1NLb+SAs8LCWb+Zm5SwyDABuRMX3/E6kX+s1pTr43edbuYZuInXRf+NDW6j5zyLtPbFVkN4FIvHFB7svUefrp8UmFzAcy9ZOdKUV+wYGhEhKvz/wh4qtxFZuMlCn4HERuoDR+c1PjELhoG/w7IaaVNuKKMDeVEVJwYTzTrcADq7kEgcyutBR0yqkl47V33i5p9p2xr+hSpb4K5JVklqDqd51RDljt3GbeuhLKArMxPDCk32806YDfL480noVlZ2yrx1FhtjFc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85987bc7-d39c-438f-f344-08d741934dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 08:35:21.2390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eSuBAAqhIf/R0wocMWBw4lqS8FFhejkM1SR9ZX5Fq8NXSPVACV7s/bYiUY6ulpPKgNHBDkZMXnvOuBYssxj8uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgVml0YWx5Og0KCUkganVzdCB3b3JrZWQgb3V0IGEgcGF0Y2ggdG8gZml4IHRoZSBpc3N1ZSBh
bmQgaGFzbid0IHNlbmQgb3V0IHlldC4gIEl0J3MgdXAgdG8geW91IHRvIHJlbW92ZSBvciBmaXgg
8J+Yig0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2
bS92bXgvdm14LmMNCmluZGV4IGVkODA1NjA0OTA3MC4uZDBjNDVjOWY1ZmM1IDEwMDY0NA0KLS0t
IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0K
QEAgLTQ5OSwxOSArNDk5LDE4IEBAIHN0YXRpYyBpbnQgaHZfZW5hYmxlX2RpcmVjdF90bGJmbHVz
aChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQogICAgICAgICAgICAgICAgKnBfaHZfcGFfcGcgPSBr
emFsbG9jKFBBR0VfU0laRSwgR0ZQX0tFUk5FTCk7DQogICAgICAgICAgICAgICAgaWYgKCEqcF9o
dl9wYV9wZykNCiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KLSAgICAg
ICAgICAgICAgIHByX2RlYnVnKCJLVk06IEh5cGVyLVY6IGFsbG9jYXRlZCBQQV9QRyBmb3IgJWxs
eFxuIiwNCi0gICAgICAgICAgICAgICAgICAgICAgKHU2NCkmdmNwdS0+a3ZtKTsNCisgICAgICAg
ICAgICAgICBwcl9kZWJ1ZygiS1ZNOiBIeXBlci1WOiBhbGxvY2F0ZWQgUEFfUEcgZm9yICVseFxu
IiwNCisgICAgICAgICAgICAgICAgICAgICAgICAodW5zaWduZWQgbG9uZykmdmNwdS0+a3ZtKTsN
CiAgICAgICAgfQ0KDQogICAgICAgIGV2bWNzID0gKHN0cnVjdCBodl9lbmxpZ2h0ZW5lZF92bWNz
ICopdG9fdm14KHZjcHUpLT5sb2FkZWRfdm1jcy0+dm1jczsNCi0NCiAgICAgICAgZXZtY3MtPnBh
cnRpdGlvbl9hc3Npc3RfcGFnZSA9DQogICAgICAgICAgICAgICAgX19wYSgqcF9odl9wYV9wZyk7
DQotICAgICAgIGV2bWNzLT5odl92bV9pZCA9ICh1NjQpdmNwdS0+a3ZtOw0KKyAgICAgICBldm1j
cy0+aHZfdm1faWQgPSAodW5zaWduZWQgbG9uZyl2Y3B1LT5rdm07DQogICAgICAgIGV2bWNzLT5o
dl9lbmxpZ2h0ZW5tZW50c19jb250cm9sLm5lc3RlZF9mbHVzaF9oeXBlcmNhbGwgPSAxOw0KDQot
ICAgICAgIHByX2RlYnVnKCJLVk06IEh5cGVyLVY6IGVuYWJsZWQgRElSRUNUIGZsdXNoIGZvciAl
bGx4XG4iLA0KLSAgICAgICAgICAgICAgICAodTY0KXZjcHUtPmt2bSk7DQorICAgICAgIHByX2Rl
YnVnKCJLVk06IEh5cGVyLVY6IGVuYWJsZWQgRElSRUNUIGZsdXNoIGZvciAlbHhcbiIsDQorICAg
ICAgICAgICAgICAgICh1bnNpZ25lZCBsb25nKSZ2Y3B1LT5rdm0pOw0KICAgICAgICByZXR1cm4g
MDsNCiB9DQoNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFZpdGFseSBLdXpu
ZXRzb3YgPHZrdXpuZXRzQHJlZGhhdC5jb20+IA0KU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIg
MjUsIDIwMTkgNDozMSBQTQ0KVG86IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBrYnVpbGQtYWxs
QDAxLm9yZzsga2J1aWxkIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+OyBSb2JlcnQgSHUgPHJv
YmVydC5odUBpbnRlbC5jb20+OyBGYXJyYWggQ2hlbiA8ZmFycmFoLmNoZW5AaW50ZWwuY29tPjsg
RGFubWVpIFdlaSA8ZGFubWVpLndlaUBpbnRlbC5jb20+OyBQYW9sbyBCb256aW5pIDxwYm9uemlu
aUByZWRoYXQuY29tPjsgVGlhbnl1IExhbiA8VGlhbnl1LkxhbkBtaWNyb3NvZnQuY29tPg0KU3Vi
amVjdDogUmU6IFtrdm06cXVldWUgNC80N10gYXJjaC94ODYva3ZtL3ZteC92bXguYzo1MDM6MTA6
IHdhcm5pbmc6IGNhc3QgZnJvbSBwb2ludGVyIHRvIGludGVnZXIgb2YgZGlmZmVyZW50IHNpemUN
Cg0Ka2J1aWxkIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+IHdyaXRlczoNCg0KPiAgPiA1MDIJ
CQlwcl9kZWJ1ZygiS1ZNOiBIeXBlci1WOiBhbGxvY2F0ZWQgUEFfUEcgZm9yICVsbHhcbiIsDQo+
ICA+IDUwMwkJCSAgICAgICAodTY0KSZ2Y3B1LT5rdm0pOw0KDQooYXMgYSBtYXR0ZXIgb2YgZmFj
dCwgdGhpcyB3YXNuJ3QgaW4gbXkgb3JpZ2luYWwgcGF0Y2ggOi0pDQoNCkknbSBub3QgcXVpdGUg
c3VyZSB3aGF0IHRoaXMgaW5mbyBpcyB1c2VmdWwgZm9yLCBsZXQncyBqdXN0IHJlbW92ZSBpdC4g
SSdsbCBzZW5kIGEgcGF0Y2guDQoNCi0tDQpWaXRhbHkNCg==
