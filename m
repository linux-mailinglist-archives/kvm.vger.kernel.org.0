Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5237CEE840
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 20:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfKDTWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 14:22:47 -0500
Received: from mail-eopbgr820087.outbound.protection.outlook.com ([40.107.82.87]:53408
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728761AbfKDTWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 14:22:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUs5WSr6gV28imt1YuKUtuRniP/xg3tZ7Z01se2uW6Xv8AuLVSjCr7LYT2X8+mN38R4D91dUqzM9ij7Ih6rnGBerPjM55gaeiTGSx6Kb5LZzQ66EXpr3gqidQsMfeuap0ChTjFjaHiRSQ6RZKbD319n5iNEkTV9a9n1Fe9+1Xp6VV4EQ2MlI7+CRsMYXlw4phz196KkVfGVXyrIc3oqPwd05Fdi+JZ5jcYAlxbMOSZ2KQF6x4lHc1sLWp539ps5DVmJTohfkp+KEmDoulC5SQG7uadAL/jM8DqndUBIVVI1/YFnsQtQXGulsT3qzqMwwySdc5U8JcCELNOrQlZc3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkEJLUr6eETY8oSz5eP/66yJTSEuDSFMDhnsUF35kjc=;
 b=OW3S8nUE7fp3BaLhMw7Kn+zZG7ZZWYu6/Ir/S8iAw6VmtalKvBTPXPYevfbGuIi5tckuHO5ahWzbKnKfBmfBC1ro2boQwEVonMUDUX5C3pGQxolBrHb4M4q6UmWs/QD3iybzIQSht1SByzoybVVJ0KNVyW/Du3vXNCfhmm92EIt2Vzoga3gb3K0Al+l5d67c0qkrqxmQwswwEtmgfbwwy2HKwcOcTziplAmCRDhb0XdX6YLrD17BioE+oUqRcK7eH/ugnX3blHd8tBzM9Bv1q2ZxsKzwjNQyN6dQwjRuWIAZWoFPPZpKDMkRibYOXVIGeWNcaL/eCrCQx+gMH3dTNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkEJLUr6eETY8oSz5eP/66yJTSEuDSFMDhnsUF35kjc=;
 b=wjMvY796V15eq2kMdqMhGPEX6pPPiEFegoCmlD4KQ/o3en+meP3E4PU5OawvsEmmltzLvtNHoUMPTjHfgjwaT5BxCC0zPa65c73LDPr4KB3QcLRBl7L8neBPeo836kvawU0UI/ChHx1oR4MoioauDTa5e8krX7D4W3G+UmnTtYg=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3274.namprd12.prod.outlook.com (20.179.106.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 19:22:44 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 19:22:44 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v4 04/17] kvm: x86: Add support for activate/de-activate
 APICv at runtime
Thread-Topic: [PATCH v4 04/17] kvm: x86: Add support for activate/de-activate
 APICv at runtime
Thread-Index: AQHVkQV/8CsVLszkbEWXIyta1bn49Kd3pGIAgAPEBQA=
Date:   Mon, 4 Nov 2019 19:22:43 +0000
Message-ID: <32d5c485-7ee8-fffd-a461-4c01101a2396@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-5-git-send-email-suravee.suthikulpanit@amd.com>
 <c83eb23c-2d4f-fd22-ed9f-d4eeffa8bcd6@redhat.com>
In-Reply-To: <c83eb23c-2d4f-fd22-ed9f-d4eeffa8bcd6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
x-originating-ip: [165.204.25.250]
x-clientproxiedby: BN6PR22CA0051.namprd22.prod.outlook.com
 (2603:10b6:404:ca::13) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ffe8cf3-5e49-40e6-7e92-08d7615c5dee
x-ms-traffictypediagnostic: DM6PR12MB3274:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3274538B791FB5DED8B4B841F37F0@DM6PR12MB3274.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(305945005)(4744005)(31696002)(99286004)(7416002)(110136005)(54906003)(316002)(6512007)(66066001)(65806001)(65956001)(58126008)(229853002)(6436002)(71190400001)(71200400001)(66946007)(2201001)(5660300002)(6246003)(3846002)(6116002)(2906002)(4326008)(14444005)(256004)(31686004)(26005)(53546011)(14454004)(386003)(102836004)(6506007)(8936002)(8676002)(81156014)(81166006)(6486002)(64756008)(66556008)(66446008)(66476007)(86362001)(478600001)(2501003)(476003)(36756003)(11346002)(446003)(2616005)(186003)(486006)(52116002)(76176011)(25786009)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3274;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q1BUFwtucBab17Bpst9JvuQNuVyQCgUed+7aNIXMuoeBUsqP+DvrfDuepjhgy7p49k6m3XGXKxWs07zr75R4tesDy27s+9VPnWZVwl48QFweddCfypCw4QfgJih9WR9iFt2sdLQjNOwiC52wh+l1zR2QKs7UhmBoV+InFW1sBhgxw2f7k7PqZU8DByidRLHlXp1VxKxr8xL5psG2FKb7KRd3VlbwQyIgwF+zqFb0IONSKn1Y9TBAvy+zV6sb/MrjYLCO4C3B3V1lUPSUm7Exm4fAO+5T/pFBouCp2Kq39C+SPp9ki/zbLep2nrmhtmZ8WlAthBlqod3thhGlg2zjwW0xPB8UC07E6PK2+ba2XeBLPLOnSNkoMdU67HE5nrqyQK9lGvVGx/VNW6iVPx9hivuk/F2M+EvG81WZl4okomfnoacJbCJksw7ab8Ze27Jd
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6EC74D100AA0B4E96B6B27190E5EFAB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ffe8cf3-5e49-40e6-7e92-08d7615c5dee
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 19:22:43.9849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jchNoby3v07VlqhslL9UTkuigJXR4exoKWA8h30xqGRcwIyiKP+TX5JMNHybHVHQlgMriWDzeVu7yK9HdstuoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3274
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGFvbG8sDQoNCk9uIDExLzIvMTkgNDo1MiBBTSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gT24g
MDEvMTEvMTkgMjM6NDEsIFN1dGhpa3VscGFuaXQsIFN1cmF2ZWUgd3JvdGU6DQo+PiArdm9pZCBr
dm1fcmVxdWVzdF9hcGljdl91cGRhdGUoc3RydWN0IGt2bSAqa3ZtLCBib29sIGFjdGl2YXRlLCB1
bG9uZyBiaXQpDQo+PiArew0KPj4gKwlpZiAoYWN0aXZhdGUpIHsNCj4+ICsJCWlmICghdGVzdF9h
bmRfY2xlYXJfYml0KGJpdCwgJmt2bS0+YXJjaC5hcGljdl9kZWFjdF9tc2spIHx8DQo+PiArCQkg
ICAgIWt2bV9hcGljdl9hY3RpdmF0ZWQoa3ZtKSkNCj4+ICsJCQlyZXR1cm47DQo+PiArCX0gZWxz
ZSB7DQo+PiArCQlpZiAodGVzdF9hbmRfc2V0X2JpdChiaXQsICZrdm0tPmFyY2guYXBpY3ZfZGVh
Y3RfbXNrKSB8fA0KPj4gKwkJICAgIGt2bV9hcGljdl9hY3RpdmF0ZWQoa3ZtKSkNCj4+ICsJCQly
ZXR1cm47DQo+PiArCX0NCj4+ICsNCj4+ICsJa3ZtX21ha2VfYWxsX2NwdXNfcmVxdWVzdChrdm0s
IEtWTV9SRVFfQVBJQ1ZfVVBEQVRFKTsNCj4+ICt9DQo+PiArRVhQT1JUX1NZTUJPTF9HUEwoa3Zt
X3JlcXVlc3RfYXBpY3ZfdXBkYXRlKTsNCj4+ICsNCj4gDQo+IEl0J3Mgd29ydGggZG9jdW1lbnRp
bmcgdGhlIGxvY2tpbmcgcmVxdWlyZW1lbnRzIG9mDQo+IGt2bV9yZXF1ZXN0X2FwaWN2X3VwZGF0
ZSAoaXQgY2FuIGFsc28gYmUgbmVnYXRpdmUgcmVxdWlyZW1lbnRzLCBzdWNoIGFzDQo+ICJkb24n
dCBob2xkIGFueSBsb2NrIiksIGJlY2F1c2Uga3ZtX21ha2VfYWxsX2NwdXNfcmVxdWVzdCBpcyBh
IHNvbWV3aGF0DQo+IGRlYWRsb2NrLXByb25lIEFQSS4NCg0KQ3VycmVudGx5LCBJIGhhdmUgYSBj
b21tZW50IGluIHRoZSBzdm1fcmVxdWVzdF91cGRhdGVfYXZpYygpLCB3aGVyZSBpdCANCmNhbGxz
IGt2bV9yZXF1ZXN0X2FwaWN2X3VwZGF0ZS4gSSdsbCBtb3ZlIGl0IGhlcmUgaW5zdGVhZCBhbmQg
ZW5oYW5jZSANCnRoZSBjb21tZW50Lg0KDQpUaGFua3MsDQpTdXJhdmVlDQo=
