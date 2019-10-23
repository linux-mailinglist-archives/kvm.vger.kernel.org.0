Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB5E0FBA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 03:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733232AbfJWBg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 21:36:58 -0400
Received: from mail-eopbgr740042.outbound.protection.outlook.com ([40.107.74.42]:59852
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730047AbfJWBg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 21:36:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmrEnIyJs810ZC2tPtdrNkZbEBd+vGm1TKfqgda1kDwVevbpHAzmmO6cU91JdkoVfkGbZlD1Rxalfl7pgUHr+OZiCRZJ3J3AfeDlagEC6Jt1oGV/VfxxmMJKukxZxmNjfqNH6mJlNNHwZo3aaMs+Twn0HKABN2by4ufQJAxXVfSntmZrvpAiArJkFAkRd3qXHZa/e8elHXQWVHfBuny5x/lq6OrAsO7key6Z8QTX9cOVER+E7bLZTfqoRDH5J411YFDSdfjEFTKo//9xp8Q2gf1HPYSy3QPcLTS7Uhm8AyU+aCCgQ72Lfq5jrK+k8M3KAiOdpCqXMbVm+QhCJ7RlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KrBQaOjc54qGjLl/SWFQzGe9wt3JyZff0O0hl60C6A=;
 b=H5Z7nzV72S6eHHsWeDWHcgM8bPBBEGtw1cURwvDyVVLleenylHczbqcIMn8m8dTJgjGzthFkvnQ5XlHJ53Kn9lN2lUtsYmvdmaog0Dyo9vtyTcGyqux6aoILK7r5mjG3kRGD0HqY5GviytXmi0DlJDoXhNDHwv5RcTfu3xA24R9jNKqHTNCibYvyXH37jkPCy6CnM8P+Epx4qduD90fIJBe/BF29OrATfomVOl+PLR0jIa21im8ZnKli8p31i/8U2x/VlmHY1dy5xZ0RmwLA+d0RyV4R5AyEtLwIbeIQqaELs3V9sRmE3dBWbpMmUIagYQxpFLpNOfHeaOFx2JClpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KrBQaOjc54qGjLl/SWFQzGe9wt3JyZff0O0hl60C6A=;
 b=VUzy3f++eFXBbw6E65d/Z+mHQZOz/NFCcc1QEzGu1e2mfG6ZsMvMsq2FHRVw+vn1XBG9lxepOSP0rJ5Rqno4COKLYQZB2nkjxiQGWZRjRVAU7U0J8GlvFTEHbF2UGdK71Wu2QB8Vo0cMqnkPsUa4gVdWlVaDJoLUDhz6jGRj9nU=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3387.namprd12.prod.outlook.com (20.178.198.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 23 Oct 2019 01:36:55 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::80:cb81:4a0e:a36]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::80:cb81:4a0e:a36%3]) with mapi id 15.20.2367.022; Wed, 23 Oct 2019
 01:36:55 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "info@metux.net" <info@metux.net>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH] crypto: ccp - Retry SEV INIT command in case of integrity
 check failure.
Thread-Topic: [PATCH] crypto: ccp - Retry SEV INIT command in case of
 integrity check failure.
Thread-Index: AQHVhTsiVAXVZvJHqE+F84WTgpVS9KdnezQA
Date:   Wed, 23 Oct 2019 01:36:55 +0000
Message-ID: <14a4cb7c-5909-189a-c5ba-56df4e4fb65a@amd.com>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com>
In-Reply-To: <20191017223459.64281-1-Ashish.Kalra@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0069.namprd02.prod.outlook.com
 (2603:10b6:803:20::31) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [70.112.153.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e1ed6df2-5d95-481f-eb6e-08d757597cad
x-ms-traffictypediagnostic: DM6PR12MB3387:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB33873951F798C7F9E5F1725DE56B0@DM6PR12MB3387.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(199004)(189003)(8676002)(4326008)(316002)(6246003)(110136005)(2501003)(8936002)(36756003)(229853002)(478600001)(81156014)(81166006)(1250700005)(305945005)(2201001)(6436002)(6486002)(2616005)(256004)(11346002)(76176011)(99286004)(5660300002)(66066001)(52116002)(26005)(102836004)(31686004)(25786009)(7736002)(4744005)(476003)(186003)(31696002)(71200400001)(71190400001)(6512007)(66476007)(3846002)(86362001)(64756008)(66946007)(66446008)(66556008)(2906002)(7416002)(486006)(6116002)(14444005)(14454004)(53546011)(6506007)(386003)(446003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3387;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a+CVSCfScJzn9V5PiJGAD48cUuGT01MH0sI9xzG9zSsJj7VkqtoHdsQbbCNxPqckziDXknmIXI5K6F29UnJgrgbHsAEJt1f+nPVmf9zaPWG2zuke1nO0PPgQnmDJYoKD6ctX5iswaBNIgX8qrsDAAAcki6NVE25bl3342alc5o2MLtqY9U1QHvsqrem6rwJS0xrIZqlRwGtvzRAHbq0vbK3ov7s9wKqRKgR35zmoZZVo4g3cawzoR+8zULkxYTs4tsZ+B93z0LRilhtrzzIgI4IeIqB2b1hBcurSoXS78+yqhHuWn56yKOkJ3VL3kFI3nG55xyd7fHph4LUi4dfnQHaJkHuZ272G1jGIly/9D2BIKt+C2ZTMqwLs2XZ9qySt5/u9p/zkLvgDNZsrweifrsTJS694bzdD9HOH98eTviEhuSCWUFEYhjuiMeGb5QXR
Content-Type: text/plain; charset="utf-8"
Content-ID: <6762AD8AC12D40478F6CD182032E0368@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ed6df2-5d95-481f-eb6e-08d757597cad
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 01:36:55.3791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zPB+p3cGL3DIppZK98hE9y1xb+2SNDPZHfFm68H76DOfpwHE3VogIxb3NbboCrxkpeEwV4AKfxUCNwhH+vm8Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3387
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpPbiAxMC8xNy8xOSAzOjM1IFBNLCBLYWxyYSwgQXNoaXNoIHdyb3RlOg0KPiBGcm9tOiBBc2hp
c2ggS2FscmEgPGFzaGlzaC5rYWxyYUBhbWQuY29tPg0KPg0KPiBTRVYgSU5JVCBjb21tYW5kIGxv
YWRzIHRoZSBTRVYgcmVsYXRlZCBwZXJzaXN0ZW50IGRhdGEgZnJvbSBOVlMNCj4gYW5kIGluaXRp
YWxpemVzIHRoZSBwbGF0Zm9ybSBjb250ZXh0LiBUaGUgZmlybXdhcmUgdmFsaWRhdGVzIHRoZQ0K
PiBwZXJzaXN0ZW50IHN0YXRlLiBJZiB2YWxpZGF0aW9uIGZhaWxzLCB0aGUgZmlybXdhcmUgd2ls
bCByZXNldA0KPiB0aGUgcGVyc2lzZW50IHN0YXRlIGFuZCByZXR1cm4gYW4gaW50ZWdyaXR5IGNo
ZWNrIGZhaWx1cmUgc3RhdHVzLg0KPg0KPiBBdCB0aGlzIHBvaW50LCBhIHN1YnNlcXVlbnQgSU5J
VCBjb21tYW5kIHNob3VsZCBzdWNjZWVkLCBzbyByZXRyeQ0KPiB0aGUgY29tbWFuZC4gVGhlIElO
SVQgY29tbWFuZCByZXRyeSBpcyBvbmx5IGRvbmUgZHVyaW5nIGRyaXZlcg0KPiBpbml0aWFsaXph
dGlvbi4NCj4NCj4gQWRkaXRpb25hbCBlbnVtcyBhbG9uZyB3aXRoIFNFVl9SRVRfU0VDVVJFX0RB
VEFfSU5WQUxJRCBhcmUgYWRkZWQNCj4gdG8gc2V2X3JldF9jb2RlIHRvIG1haW50YWluIGNvbnRp
bnVpdHkgYW5kIHJlbGV2YW5jZSBvZiBlbnVtIHZhbHVlcy4NCj4NCj4gU2lnbmVkLW9mZi1ieTog
QXNoaXNoIEthbHJhIDxhc2hpc2gua2FscmFAYW1kLmNvbT4NCg0KDQpSZXZpZXdlZC1ieTogQnJp
amVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0KDQp0aGFua3MNCg0K
