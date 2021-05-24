Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F74E38F4DF
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhEXVae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:30:34 -0400
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:51520
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhEXVae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 17:30:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZ6jffoLn4qTl8T6FJGfvqSaXyXlfCjxaGmEBymuoNSw8Zp2F2FbCiZkDtKUXxG+DqMSp6FFMXD7p/5lE9FQq1YMmSSWJLTAgX47PXNDvXh+sC+k2FUnLX9tBZkrYZouzI66zIYPCn0ihKHp02Q08Rk857Oe6WXGtSYnD6JJuBSUitMiFCCPCsijtP4L+tNg5I6N8bIOo/SPT3zh8UjsjQ2iCI24rB8Mp+CIxnT8ajzVW0ladbpY6BXPA+nVbJQVvufzz16h+NAq8vwtp7ffBF5V2FmK/gf429ZpghTi+59FlRGvtCosHlZpWjAzrImVoZhuovyFk5ro2mvO6a+gfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x79vNKfuasE/+tZRVaeyPL3lA6JfgECTkHzCuL9k4/c=;
 b=JmetXrmba9PYm4mgycpq2yzgtQgMFf5fbv3kv38myEFKMY16Bb8dUUmtgLsHEk3rVYOjNXGJZWmCumVsw1RgpKjLlOaXgqBWb2JS1qPwzLJE+ChFHdTOnn48K2kxiI3pIIEOiz106dTSBfGlB5jasEKeZWP704uAMJaF3DnWeRnEbEEC95dlOJ+rg91pPG1d0yI6wEgSdDi1xzsK2rLi3P7hnq2+PftbPdaDKXIi+3dKMgP7tiryOEUrMdI7g+rzN8qPZXlcDRu8BjI7jz0RbrkurBj6MLFpKxl4WY0OHe/Ok/SOSUECyS5LkRGRvjn0AGFGWIRB4vQHPzc+ObfQpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x79vNKfuasE/+tZRVaeyPL3lA6JfgECTkHzCuL9k4/c=;
 b=oFrllGcVfjuuhkPfynczG8sHMv0rB4f4n8Kz+K4hNQmRwpL4tfI16cAy+cdyJQkctoRwjHF5g3Ylfi8cs/b5ZwxDBbBwoZa+M0hBpXgl4Tq8PxOdmh1fur3K+9x/P8Q8b97QIYFOG0vNkp+4iFIqj3FAgdhYmd3do1l0XS2b0rM=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2544.namprd12.prod.outlook.com (2603:10b6:802:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Mon, 24 May
 2021 21:29:02 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4129.033; Mon, 24 May 2021
 21:29:02 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Tobin Feldman-Fitzthum <tobin@linux.ibm.com>,
        "natet@google.com" <natet@google.com>
CC:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: RE: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Thread-Topic: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Thread-Index: AQHXCot5SNFL8RrPlkCutU8OGpQ4JKp/Ae+AgAAQa4CAdHeyEA==
Date:   Mon, 24 May 2021 21:29:02 +0000
Message-ID: <SN6PR12MB276780007C17ADD273EB70FC8E269@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <20210224085915.28751-1-natet@google.com>
 <7829472d-741c-1057-c61f-321fcfb5bdcd@linux.ibm.com>
 <35dde628-f1a8-c3bf-9c7d-7789166b0ee1@redhat.com>
In-Reply-To: <35dde628-f1a8-c3bf-9c7d-7789166b0ee1@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-24T21:28:59Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=c0e1fa55-cc39-48d4-80c0-6013c0b193d0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [183.83.213.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7dfdb6e4-a947-471f-c5c5-08d91efaf3ba
x-ms-traffictypediagnostic: SN1PR12MB2544:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN1PR12MB25441F3DABA701873B5653CE8E269@SN1PR12MB2544.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0i+VB+HjffT1g0OF1lavynVzKHVNJY3AZDP5ok20c8jMSP6BQrCqTLueVLAQ0LZKsKSaswjI7uEgyLs6tYTSUOOsAe62IQXUdqWHmWGDMy1LAxyeaaotGx1JCNzXT/M8OYk/MSLNHTF5ze5YkN1OU/LUhxA6hQoqq2tYA0QHQoZaw9ytJWUkq8eaxUztJVcVUSWvDO92vbuclZndeRaSY6BA5wXY/kIvgKe0IF1zqMkyswWucoJpW6myquQ+jtoDf90PWscdHelYXBDP9ldd2AgtpTjhidnG0b5Y+vxb/aUck5gJOAnUlchuWffDxwPqieOTmn/QZpq+XYpg7wsGojgEMihw9+8Yuvo370rqvKy9VIeDrfFVFE5tDhoI5BaZNlY4+jK7O49mC7JJQ2oUp4w1+aslLbDdNG0Z0W4Ejw50RxiHmBZRBMzv3rY/VCfPTeHyYICxHmLm8FS7RiX9vk0g1t5XlGasyIzBRQfmSA4tYaRj4soQ6PemB/kQqJ8W3BnFNlqUhWUbj5Q8kqCuANyDg2nyIycOiexstcLcgRzv3yTOBuoh8zwOJ5YaHqIKWUmBkfO7lhrNXl7XQ0RCKETcJtdvRacZkigDes4D5Dc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(76116006)(66946007)(86362001)(186003)(54906003)(64756008)(66556008)(55016002)(110136005)(5660300002)(2906002)(66446008)(122000001)(38100700002)(66476007)(7696005)(33656002)(83380400001)(8676002)(53546011)(71200400001)(6506007)(52536014)(316002)(7416002)(26005)(9686003)(478600001)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RDY4bjhBd2N1NWZGMWZacWhhMkJkSG1ZbWc3dXAyaUc2dUxYK2lJb2NkaU5y?=
 =?utf-8?B?OSs2cE5Ga25uZjRVYUFTYTgrNzJ5UXBENFA5Ykd2SHMrdW9Sc0pGUEJEVDhE?=
 =?utf-8?B?bStsUUd5SVMwUVhzeUFMYkRkbFVoeEF3L3BEdngwWWRJNCtFTVFvOHZIeThl?=
 =?utf-8?B?T1crY0N4U0EyYlBIZUdMUEZNa3NkN3VSbVNVK0YzWVFXVVc1Zm5YTFRIbHRO?=
 =?utf-8?B?emxiOFdncDU3NXA3NkRvWU5tVlR2TVNmbGRQejRSUHFadFpROUZMMno0NGdy?=
 =?utf-8?B?M0tLcjNIb2xsZlZyb2IwSUxZZ2h3M2dvMUdET0xHTmdGaUUyb0FndzExVWly?=
 =?utf-8?B?VFlSTzBHV3hSYkdaalhBenRQWnI1eURINEZ3SnNLQ28wL2xWN2FuNlBIMGg5?=
 =?utf-8?B?NEJFTVRBNUs3dnV0MTFQakZqSkhIQ0M1cFZEb2RrUFBMVmdhMWRTaVQ3czhR?=
 =?utf-8?B?ZzY2amo1b21nRWF4K3F1aW9sb1ZEU29hWDhqQjJMQ3BYOGx6bmM0QUhUd0JZ?=
 =?utf-8?B?RUgrcnZCelNnVk5iMWVFU2FiT2FWVEpLVVNKaTVoQXlZbjNaYU9mbVZINlc3?=
 =?utf-8?B?RndTaDBKT1UrVTJ5SEFNdC83QTdWdVdCRVFBd01zV1ZLaVBZV3h0Mm1tZFdM?=
 =?utf-8?B?akZhNzRHNVp6TUh4NlBDOFlHT1pNSkZWbFNOSFBpcEZjUWExV3hhZWhUb0lR?=
 =?utf-8?B?TlBEbEh6Sys1S3hEMi8vYmE3cytpbUJNemo4VkJBaFdJL25YNjJEeTVPdlhC?=
 =?utf-8?B?MWpVVWtmY2xCTkxCb08yazl3Nkd4TVRjZGFXYkRsWHAyR1lXbk53UldDWWFJ?=
 =?utf-8?B?TFRKUzkyMmNnWFJJZXkwUm05MHZYZ2lUYTRjVU1QWlVwTHpHcXYrOW9CMktG?=
 =?utf-8?B?YXZOYjVNVVhuNExnTURlTmlMQlowRnlhN1pJRkxxbDRiT01CSjJmKzl4SzJ5?=
 =?utf-8?B?STB0WS9oNllMejJoeGVCQzJRMjdITHZnbWo0Z0pNWFdBYzdyUCtva3Q1Wk9v?=
 =?utf-8?B?YkpnQVcrTXlIOHBjME5nSmZNYnloaG16RHVyY2xRdnZUblJxVVZ0aXg0djU5?=
 =?utf-8?B?WDJURmZJUGtzU25oZVJNZlhHZWtNUWpuWW9pZFMzaFZjcjZtOFg0aWcvaUdN?=
 =?utf-8?B?bXZDREp0Z1FoYytSTWNISmIyYVFDbTVKTGdLQkJYMlZSQTNueTFwRlJYdlR6?=
 =?utf-8?B?NytwY0hkcGIvNGpmQ3FkR2h6Rk1uZkNibUVYaXlzRXBqZzZxMW5LOWpWYVph?=
 =?utf-8?B?Yno2OEJzaExZTk1MNW1wRWxPYmFPbTZqcHpBWUZGT3ZjRVF6YnV4M2lkaUxK?=
 =?utf-8?B?OVFhbmtXb0doSzlyak9nT3FmcklYSkl4TnhqaU5CSWVhVWt1c01JNXN2d0pt?=
 =?utf-8?B?T09oZFF2akQ1RmR2TlpOVk5CTzJRUW1FMU16UVRidHNLTUtiZmdnbUpuc3dS?=
 =?utf-8?B?QmV6bTZ2SjR6RTIwUnFkcXlpRUl4WExVZEVQSUZudElmSTV4YUZ5Nmx2Z2hn?=
 =?utf-8?B?R3hQL1F1VFVlV1R1UDRmUm83bXRBUjh0b05VTFUyT1c5V3hsMHZLV2YvWEs2?=
 =?utf-8?B?SFdyUXpMcGw2RmVMbmlrbklvalRhLy9XdTZtS1RpQ0dyMzl5VW9KMk5HNGc5?=
 =?utf-8?B?Q2pLREhkbFdheEVnZ3BKaEZRdHBNMmNmekxKeDF0YXB5c3R4N1YxbXMxb29h?=
 =?utf-8?B?cHZtVHlFL3pORk81alljTWVNb3JtNXg4M21YbGVxNnp0OVJlV0RxZVlLQWdv?=
 =?utf-8?Q?EDerovym2NZrzn+YjlN3awtmJypnJvwg0WKNA8v?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dfdb6e4-a947-471f-c5c5-08d91efaf3ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 21:29:02.8047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3JV7ZBzBwKMRvQw8KrlybvRCsHyCTYY+/s0FkdMcY5vwDKbDNoST9oDB46NcHjt4tES2ULH25wfb24K+qH7JtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2544
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBQdWJsaWMgVXNlXQ0KDQpIZWxsbyBQYW9sbywNCg0KSSBhbSB3b3JraW5nIG9uIHByb3Rv
dHlwZSBjb2RlIGluIHFlbXUgdG8gc3RhcnQgYSBtaXJyb3IgVk0gcnVubmluZyBpbiBwYXJhbGxl
bCB0byB0aGUgcHJpbWFyeSBWTS4gSW5pdGlhbGx5IEkgaGFkIGFuIGlkZWEgb2YgYSBydW5uaW5n
IGEgY29tcGxldGVseSBwYXJhbGxlbCBWTSBsaWtlIHVzaW5nIHRoZSANCnFlbXXigJlzIG1pY3Jv
dm0gbWFjaGluZS9wbGF0Zm9ybSwgYnV0IHRoZSBtYWluIGlzc3VlIHdpdGggdGhpcyBpZGVhIGlz
IHRoZSBkaWZmaWN1bHR5IGluIHNoYXJpbmcgdGhlIG1lbW9yeSBvZiBwcmltYXJ5IFZNIHdpdGgg
aXQuDQoNCkhlbmNlLCBJIHN0YXJ0ZWQgZXhwbG9yaW5nIHJ1bm5pbmcgYW4gaW50ZXJuYWwgdGhy
ZWFkIGxpa2UgdGhlIGN1cnJlbnQgcGVyLXZDUFUgdGhyZWFkKHMpIGluIHFlbXUuIFRoZSBtYWlu
IGlzc3VlIGlzIHRoYXQgcWVtdSBoYXMgYSBsb3Qgb2YgZ2xvYmFsIHN0YXRlLCBlc3BlY2lhbGx5
IHRoZSBLVk1TdGF0ZSANCnN0cnVjdHVyZSB3aGljaCBpcyBwZXItVk0sIGFuZCBhbGwgdGhlIEtW
TSB2Q1BVcyBhcmUgdmVyeSB0aWdodGx5IHRpZWQgaW50byBpdC4gSXQgZG9lcyBub3QgbWFrZSBz
ZW5zZSB0byBhZGQgYSBjb21wbGV0ZWx5IG5ldyBLVk1TdGF0ZSBzdHJ1Y3R1cmUgaW5zdGFuY2Ug
Zm9yIHRoZSBtaXJyb3IgVk0NCmFzIHRoZW4gdGhlIG1pcnJvciBWTSBkb2VzIG5vdCByZW1haW4g
bGlnaHR3ZWlnaHQgYXQgYWxsLiANCg0KSGVuY2UsIHRoZSBtaXJyb3IgVk0gaSBhbSBhZGRpbmcs
IGhhcyB0byBpbnRlZ3JhdGUgd2l0aCB0aGUgY3VycmVudCBLVk1TdGF0ZSBzdHJ1Y3R1cmUgYW5k
IHRoZSDigJxnbG9iYWzigJ0gS1ZNIHN0YXRlIGluIHFlbXUsIHRoaXMgcmVxdWlyZWQgYWRkaW5n
IHNvbWUgcGFyYWxsZWwgS1ZNIGNvZGUgaW4NCnFlbXUsIGZvciBleGFtcGxlIHRvIGRvIGlvY3Rs
J3Mgb24gdGhlIG1pcnJvciBWTSwgc2ltaWxhciB0byB0aGUgcHJpbWFyeSBWTS4gRGV0YWlscyBi
ZWxvdyA6DQoNClRoZSBtaXJyb3Jfdm1fZmQgaXMgYWRkZWQgdG8gdGhlIEtWTVN0YXRlIHN0cnVj
dHVyZSBpdHNlbGYuIA0KDQpUaGUgcGFyYWxsZWwgY29kZSBJIG1lbnRpb25lZCBpcyBsaWtlIHRo
ZSBmb2xsb3dpbmcgOg0KDQojZGVmaW5lIGt2bV9taXJyb3Jfdm1fZW5hYmxlX2NhcChzLCBjYXBh
YmlsaXR5LCBjYXBfZmxhZ3MsIC4uLikgICAgICBcDQogICAgKHsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgIHN0
cnVjdCBrdm1fZW5hYmxlX2NhcCBjYXAgPSB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQogICAgICAgICAgICAuY2FwID0gY2FwYWJpbGl0eSwgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBcDQogICAgICAgICAgICAuZmxhZ3MgPSBjYXBfZmxhZ3MsICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgIH07ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAg
IHVpbnQ2NF90IGFyZ3NfdG1wW10gPSB7IF9fVkFfQVJHU19fIH07ICAgICAgICAgICAgICAgICAg
ICAgICBcDQogICAgICAgIHNpemVfdCBuID0gTUlOKEFSUkFZX1NJWkUoYXJnc190bXApLCBBUlJB
WV9TSVpFKGNhcC5hcmdzKSk7ICBcDQogICAgICAgIG1lbWNweShjYXAuYXJncywgYXJnc190bXAs
IG4gKiBzaXplb2YoY2FwLmFyZ3NbMF0pKTsgICAgICAgICBcDQogICAgICAgIGt2bV9taXJyb3Jf
dm1faW9jdGwocywgS1ZNX0VOQUJMRV9DQVAsICZjYXApOyAgICAgICAgICAgICAgICBcDQogICAg
fSkNCg0KDQoraW50IGt2bV9taXJyb3Jfdm1faW9jdGwoS1ZNU3RhdGUgKnMsIGludCB0eXBlLCAu
Li4pDQorew0KKyAgICBpbnQgcmV0Ow0KKyAgICB2b2lkICphcmc7DQorICAgIHZhX2xpc3QgYXA7
DQorDQorICAgIHZhX3N0YXJ0KGFwLCB0eXBlKTsNCisgICAgYXJnID0gdmFfYXJnKGFwLCB2b2lk
ICopOw0KKyAgICB2YV9lbmQoYXApOw0KKw0KKyAgICB0cmFjZV9rdm1fdm1faW9jdGwodHlwZSwg
YXJnKTsNCisgICAgcmV0ID0gaW9jdGwocy0+bWlycm9yX3ZtX2ZkLCB0eXBlLCBhcmcpOw0KKyAg
ICBpZiAocmV0ID09IC0xKSB7DQorICAgICAgICByZXQgPSAtZXJybm87DQorICAgIH0NCisgICAg
cmV0dXJuIHJldDsNCit9DQorDQoNClRoZSB2Y3B1IGlvY3RsIGNvZGUgd29ya3MgYXMgaXQgaXMu
IA0KDQpUaGUga3ZtX2FyY2hfcHV0X3JlZ2lzdGVycygpIGFsc28gbmVlZGVkIGEgbWlycm9yIFZN
IHZhcmlhbnQga3ZtX2FyY2hfbWlycm9yX3B1dF9yZWdpc3RlcnMoKSwgZm9yIHJlYXNvbnMgc3Vj
aCBhcyBzYXZpbmcgTVNScyBvbiB0aGUgbWlycm9yIFZNIHJlcXVpcmVkIGVuYWJsaW5nDQp0aGUg
aW4ta2VybmVsIGlycWNoaXAgc3VwcG9ydCBvbiB0aGUgbWlycm9yIFZNLCBvdGhlcndpc2UsIGt2
bV9wdXRfbXNycygpIGZhaWxzLiBIZW5jZSwga3ZtX2FyY2hfbWlycm9yX3B1dF9yZWdpc3RlcnMo
KSBtYWtlcyB0aGUgbWlycm9yIFZNIHNpbXBsZXIgYnkgbm90IHNhdmluZw0KYW55IE1TUnMgYW5k
IG5vdCBuZWVkaW5nIHRoZSBpbi1rZXJuZWwgaXJxY2hpcCBzdXBwb3J0Lg0KDQpJIGhhZCBsb3Qg
b2YgaXNzdWVzIGluIGR5bmFtaWNhbGx5IGFkZGluZyBhIG5ldyB2Q1BVLCBpLmUuLCB0aGUgQ1BV
U3RhdGUgc3RydWN0dXJlIGR1ZSB0byBxZW11J3Mgb2JqZWN0IG1vZGVsIChRT00pIHdoaWNoIHJl
cXVpcmVzIHRoYXQgZXZlcnkgcWVtdQ0Kc3RydWN0dXJlL29iamVjdCBoYXMgdG8gY29udGFpbiB0
aGUgcGFyZW50L2Jhc2UgY2xhc3Mvb2JqZWN0IGFuZCB0aGVuIGFsbCB0aGUgZGVyaXZlZCBjbGFz
c2VzIGFmdGVyIHRoYXQuIEl0IHdhcyBkaWZmaWN1bHQgdG8gYWRkIGEgbmV3IENQVSBvYmplY3Qg
ZHluYW1pY2FsbHksIGhlbmNlIEkgaGF2ZSB0byByZXVzZQ0Kb25lIG9mIHRoZSDigJwtc21w4oCd
ICBjcHVzIHBhc3NlZCBvbiBxZW11IGNvbW1hbmQgbGluZSBhcyB0aGUgbWlycm9yIHZDUFUuIFRo
aXMgYWxzbyBhc3Npc3RzIGluIGhhdmluZyB0aGUgWDg2Q1BVICJiYWNraW5nIiBzdHJ1Y3R1cmUg
Zm9yIHRoZSBtaXJyb3IgdkNQVeKAmXMgQ1BVIG9iamVjdCwgDQp3aGljaCBhbGxvd3MgdXNpbmcg
bW9zdCBvZiB0aGUgS1ZNIGNvZGUgaW4gcWVtdSBmb3IgdGhlIG1pcnJvciB2Q1BVLiBBbHNvIHRo
ZSBtaXJyb3IgdkNQVSBDUFUgb2JqZWN0IHdpbGwgaGF2ZSB0aGUgQ1BVWDg2U3RhdGUgc3RydWN0
dXJlIGVtYmVkZGVkIHdoaWNoIGNvbnRhaW5zIHRoZSANCmNwdSByZWdpc3RlciBzdGF0ZSBmb3Ig
dGhlIG1pcnJvciB2Q1BVLiANCg0KVGhlIG1pcnJvciB2Q1BVIGlzIG5vdyBydW5uaW5nIGEgc2lt
cGxlciBLVk0gcnVuIGxvb3AsIGl0IGRvZXMgbm90IGhhdmUgYW55IGluLWtlcm5lbCBpcnFjaGlw
IChpbnRlcnJ1cHQgY29udHJvbGxlcikgb3IgYW55IG90aGVyIGt2bWFwaWMgaW50ZXJydXB0IGNv
bnRyb2xsZXIgc3VwcG9ydGVkDQphbmQgZW5hYmxlZCBmb3IgaXQuIEFzIG9mIG5vdyBpdCBpcyBz
dGlsbCBkb2luZyBib3RoIEkvTyBhbmQgTU1JTyBoYW5kbGluZy4NCg0KTG9va2luZyBmd2QuIHRv
IGNvbW1lbnRzLCBmZWVkYmFjaywgdGhvdWdodHMgb24gdGhlIGFib3ZlIGFwcHJvYWNoLg0KDQpU
aGFua3MsDQpBc2hpc2gNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBhb2xv
IEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+IA0KU2VudDogVGh1cnNkYXksIE1hcmNoIDEx
LCAyMDIxIDEwOjMwIEFNDQpUbzogVG9iaW4gRmVsZG1hbi1GaXR6dGh1bSA8dG9iaW5AbGludXgu
aWJtLmNvbT47IG5hdGV0QGdvb2dsZS5jb20NCkNjOiBEb3YgTXVyaWsgPGRvdm11cmlrQGxpbnV4
LnZuZXQuaWJtLmNvbT47IExlbmRhY2t5LCBUaG9tYXMgPFRob21hcy5MZW5kYWNreUBhbWQuY29t
PjsgeDg2QGtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IHNydXRoZXJmb3JkQGdvb2dsZS5jb207IHNlYW5qY0Bnb29nbGUuY29tOyBy
aWVudGplc0Bnb29nbGUuY29tOyBTaW5naCwgQnJpamVzaCA8YnJpamVzaC5zaW5naEBhbWQuY29t
PjsgS2FscmEsIEFzaGlzaCA8QXNoaXNoLkthbHJhQGFtZC5jb20+OyBMYXN6bG8gRXJzZWsgPGxl
cnNla0ByZWRoYXQuY29tPjsgSmFtZXMgQm90dG9tbGV5IDxqZWpiQGxpbnV4LmlibS5jb20+OyBI
dWJlcnR1cyBGcmFua2UgPGZyYW5rZWhAdXMuaWJtLmNvbT4NClN1YmplY3Q6IFJlOiBbUkZDXSBL
Vk06IHg4NjogU3VwcG9ydCBLVk0gVk1zIHNoYXJpbmcgU0VWIGNvbnRleHQNCg0KT24gMTEvMDMv
MjEgMTY6MzAsIFRvYmluIEZlbGRtYW4tRml0enRodW0gd3JvdGU6DQo+IEkgYW0gbm90IHN1cmUg
aG93IHRoZSBtaXJyb3IgVk0gd2lsbCBiZSBzdXBwb3J0ZWQgaW4gUUVNVS4gVXN1YWxseSANCj4g
dGhlcmUgaXMgb25lIFFFTVUgcHJvY2VzcyBwZXItdm0uIE5vdyB3ZSB3b3VsZCBuZWVkIHRvIHJ1
biBhIHNlY29uZCBWTSANCj4gYW5kIGNvbW11bmljYXRlIHdpdGggaXQgZHVyaW5nIG1pZ3JhdGlv
bi4gSXMgdGhlcmUgYSB3YXkgdG8gZG8gdGhpcyANCj4gd2l0aG91dCBhZGRpbmcgc2lnbmlmaWNh
bnQgY29tcGxleGl0eT8NCg0KSSBjYW4gYW5zd2VyIHRoaXMgcGFydC4gIEkgdGhpbmsgdGhpcyB3
aWxsIGFjdHVhbGx5IGJlIHNpbXBsZXIgdGhhbiB3aXRoIGF1eGlsaWFyeSB2Q1BVcy4gIFRoZXJl
IHdpbGwgYmUgYSBzZXBhcmF0ZSBwYWlyIG9mIFZNK3ZDUFUgZmlsZSBkZXNjcmlwdG9ycyB3aXRo
aW4gdGhlIHNhbWUgUUVNVSBwcm9jZXNzLCBhbmQgc29tZSBjb2RlIHRvIHNldCB1cCB0aGUgbWVt
b3J5IG1hcCB1c2luZyBLVk1fU0VUX1VTRVJfTUVNT1JZX1JFR0lPTi4NCg0KSG93ZXZlciwgdGhl
IGNvZGUgdG8gcnVuIHRoaXMgVk0gd2lsbCBiZSB2ZXJ5IHNtYWxsIGFzIHRoZSBWTSBkb2VzIG5v
dCBoYXZlIHRvIGRvIE1NSU8sIGludGVycnVwdHMsIGxpdmUgbWlncmF0aW9uIChvZiBpdHNlbGYp
LCBldGMuICBJdCBqdXN0IHN0YXJ0cyB1cCBhbmQgY29tbXVuaWNhdGVzIHdpdGggUUVNVSB1c2lu
ZyBhIG1haWxib3ggYXQgYSBwcmVkZXRlcm1pbmVkIGFkZHJlc3MuDQoNCkkgYWxzbyB0aGluayAo
YnV0IEknbSBub3QgMTAwJSBzdXJlKSB0aGF0IHRoZSBhdXhpbGlhcnkgVk0gZG9lcyBub3QgaGF2
ZSB0byB3YXRjaCBjaGFuZ2VzIGluIHRoZSBwcmltYXJ5IFZNJ3MgbWVtb3J5IG1hcCAoZS5nLiBt
YXBwaW5nIGFuZCB1bm1hcHBpbmcgb2YgQkFScykuICBJbiBRRU1VIHRlcm1zLCB0aGUgYXV4aWxp
YXJ5IFZNJ3MgbWVtb3J5IG1hcCB0cmFja3MgUkFNQmxvY2tzLCBub3QgTWVtb3J5UmVnaW9ucywg
d2hpY2ggbWFrZXMgdGhpbmdzIG11Y2ggc2ltcGxlci4NCg0KVGhlcmUgYXJlIGFscmVhZHkgbWFu
eSBleGFtcGxlcyBvZiBtaW5pIFZNTXMgcnVubmluZyBzcGVjaWFsIHB1cnBvc2UgVk1zIGluIHRo
ZSBrZXJuZWwncyB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0gZGlyZWN0b3J5LCBhbmQgSSBk
b24ndCB0aGluayB0aGUgUUVNVSBjb2RlIHdvdWxkIGJlIGFueSBtb3JlIGNvbXBsZXggdGhhbiB0
aGF0Lg0KDQpQYW9sbw0K
