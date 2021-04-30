Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225BB36FF05
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhD3Q6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 12:58:07 -0400
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:15105
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231150AbhD3Q6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 12:58:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOA+8/nlabkJYcpqvVOQtPf9pvyCMxF116RvjznFFKTCjD+SyM3PgK5GzvPQdS0q+iZeuehQPtMvPGK0NDNuWLHjCNUe8FTyDiym0SgOJlz026nxuEWV0bn4NK6QuJ6Bp+NjxLL0bGuQuuxsjERoQe6fKo19r8QcoVdWM40ohwCe9X2W9GCc0JZFQbuYPy59xZX/+aterlTItSWKJA3+sLhs44412kLbP/A7apnUBkaoi3U36yurR1XPTgzHgEblcOBKeUXwV97+zOdsNmT5RufM/3dV7lzZxuTxuRZEstGXoMZqcT5EJQeX7lmzvEkPnbAn7QffS0T0Fn5hV7cHJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LmHYU6FkWkp8toE42R0rfaeJdu1DBhUI5yupQdCEAg=;
 b=iK5fnpQtepK7N84sMoSDA/PmE4PJ4BPpadbX2t6tSdeJEsseLU50qYJqIC9GhpCrXB30deRxr1zXbk5Tm21wXZLnIyXNKAgxgW7bMvWc75QQqX9pz8i4raf+AfPplF2IVq3T2OYI2o+xQZalKJKMCUMlnEROgNi8oIeMxGe7jCCcS6nCPB0O0uIn0XHHIwhW7UBVTbV+f6njoHdiUUznTs2nVTlC9H+xOAIM42Oxz3jcQxiODPzUZ03b5zOw3vB/+KZGz2p5Lwi/ghm+RxtYBijcA0fwPeZTAj3AIGov0KPKemRaZ+bpB6428uiWktU3PVPbL5OICkBCoUB0TENung==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LmHYU6FkWkp8toE42R0rfaeJdu1DBhUI5yupQdCEAg=;
 b=fs/wL9abwmnqAUZ6ubJ/sUGOEsNzFcNUXevVTO1mey1QI2eI530+Sc1AHJTFriNk75BEKSzrf8y3gep5xwRYQOY2lsfzmF/HOsaN1ocpf9gEdN6csd4krTqQx3geFeFKpV6mPen+EnI1sPTHoFYJRlGNksurB5AkmYWZe3g2UBaMj8Y0s9Q7ECUIswBQytcGTVU5/zqXgPvrgB7l6+2ng4khLS86EbYk6UfNuU15RmlxcvuExxXWakM3+TniEeypsLnsrGuJKWke+berfnQxDwPkAZn0lVe/SbOI0NFAMo5BkfleGjySMQXmuUuSgiizBwW87xS+6BvhQovQZZWfVQ==
Received: from BL0PR12MB2532.namprd12.prod.outlook.com (2603:10b6:207:4a::20)
 by MN2PR12MB4437.namprd12.prod.outlook.com (2603:10b6:208:26f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.28; Fri, 30 Apr
 2021 16:57:15 +0000
Received: from BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f]) by BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f%5]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 16:57:14 +0000
From:   Vikram Sethi <vsethi@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>,
        Shanker Donthineni <sdonthineni@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: RE: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Topic: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Index: AQHXPRTigOHff2apwEeawQns3nBPOqrL0MoAgAAM5gCAAAj7gIABBh4AgAAGT4CAADU7AIAACSoAgAABt+A=
Date:   Fri, 30 Apr 2021 16:57:14 +0000
Message-ID: <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
        <20210429162906.32742-2-sdonthineni@nvidia.com>
        <20210429122840.4f98f78e@redhat.com>
        <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
        <20210429134659.321a5c3c@redhat.com>
        <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
        <87czucngdc.wl-maz@kernel.org>
        <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
In-Reply-To: <878s4zokll.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [2603:8080:1102:19fe:94b2:89d7:739a:1f5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92a149e8-de83-4e50-46e5-08d90bf90180
x-ms-traffictypediagnostic: MN2PR12MB4437:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB44373935D6A2F17425BE6166BD5E9@MN2PR12MB4437.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8KuEnvWfgb3K/do0wutREEJBSiNfMheDQ9Ejdw31jSs/5jsirvwDrCJRwBe5fWFqthvz2BDvaCzKf+ZZbNgNN8GaCs1kLnMoVHMTWC5sfxDlDKkLVPkwJfUH0o3qt0guFOHWralRUua/2DivL/5QYutp60jpayTwYAYi8r5zqiEQ4Mma6mvWRXWz9Kl9Jtlh9C38u5649KY/mJkz80QaricQGDksEhAnTewVZ0ngoI/E31R/O3qW0NaPhTNQd7v4td/E7F6uDsUI3CdbP6aaqykA2pKY0wDERVvk5Oy3zEW5eeQhVPR0Et3xAVgRAh/diR+se9GwfjuhUiRO0BehcpGHpw/EbxEZaTvz3CC9cdpoEO4QayGs6MY6R5jcwURxdGkdeVSGh+rpwfEP6DUZfvwqjoznzjFWKBq5Cxo3b9mA+XxX/lvbtvOl57tlZQMlsEnulnqTRSbI3l1XN09KBh1NPGqrKx+/XBg1dMzFHf+LJ6WYjg9Rvg2TFqQfGHwLTvfHDU4rlP/b9iip2jEEJJWiLxjd/2bCAqaUmyg+yGWNBcU4Oh3FHUcwCMPd+EbPU/CgcDVX6Uk7bkEtq+Jn9SFQTa0nEuZvWqvwqXWfALg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2532.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(346002)(136003)(376002)(4326008)(71200400001)(6506007)(66476007)(8676002)(66946007)(66556008)(76116006)(186003)(66446008)(110136005)(64756008)(478600001)(2906002)(52536014)(8936002)(316002)(54906003)(5660300002)(7696005)(55016002)(6636002)(86362001)(9686003)(38100700002)(107886003)(83380400001)(33656002)(53546011)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S203emdTUmdUSWZNdFVhQ3lUSzlmQ3RBOXh6ckp3ek9nMzBnL05uK0JsNnA3?=
 =?utf-8?B?T2NMT2ZqZHExeE5aQ3N5dnM0ajd0SHZuZ3gvbno3emFtMEtvNUFER0RobGFF?=
 =?utf-8?B?S2hoc09vUDFwYS82VkhSNTdlZHlNdmVFOFdEeHNCcFJSa2V0aVh4ZFYwUnVy?=
 =?utf-8?B?VStPWTFHYTk5OE55dWoycFhaZWxHbm1rQ1JhbG5tT2pnWFUwOUljZWJqV1RF?=
 =?utf-8?B?RFJVNFY2cVVnLytySDdTQSt0V2ZERHIwL3ZUWkl3U0xJQmFoWG1YckQ4SFFV?=
 =?utf-8?B?RFVxanM2ck9TVCt1WHB2U2szVnFVKzNPdnlBbUlnNVhiOGVuWkFjZHBUZ0c1?=
 =?utf-8?B?T0pYaDEvckExV2ZjU3VyS29XVGJ3QjNSVG01TllSZDh3LzV0RWl3NHZNcE9K?=
 =?utf-8?B?eElzajZRTUVwWnNlUlZIOFhLZVRWWERrTXRMbDRmU1BXT0dlbVlEcmNnY096?=
 =?utf-8?B?aDZBRTBLUmFTMVJsaUNSRURhelJIS3lTMGFqamMycUI0TGptYXo0SS9CNGJU?=
 =?utf-8?B?amlXbVlBeGZWdnY0ZTU0Ni84U1FLVzJoUTR2REN6eEFFZERFd2hKSFB5S01D?=
 =?utf-8?B?R2ZzVHloM1A0V1o1cG5PZ21ZbzdTaTUwV3JIbU8yODRHMnp4OWpveGRpYzZS?=
 =?utf-8?B?TGxBSXRDQ0d6U1NZMnYwbHVFemZ5cVJmRVMyRklwWXQ3eHJLamZNVGx6N3Fj?=
 =?utf-8?B?bFJvandtRnBPeHFNeExSdHRHeFV1anFiUlk2UXcrakN5dVNYNkFlUE9UMVB5?=
 =?utf-8?B?RWw0L2F1NWJHUnM3WThwWDJ0STlVN0J0M1lwRjNFSzNaRXpiY0dUTDVGV1B6?=
 =?utf-8?B?VjN4WS8vdXlKTU93aUtabW55NG5HQ3Z4R1pEVFZQOG5vVm9OekdGRXBGNER6?=
 =?utf-8?B?c0N3eWNiYUhnNnJPaWc2L1I5N0IyYjZyaWtjRkpic2JCSE84ems3ZnpoNENy?=
 =?utf-8?B?SkVKUDBBQ2VZL2pIS2paekhMUGNhN3EwaHlBeGthS29CKy80anFpVDBmOFNk?=
 =?utf-8?B?dkMvdUd2SndMM3d6bjUya09ZWTgrTndWMk5PeVJzUzhidkRiYnlyZm1HMTlQ?=
 =?utf-8?B?bFhpSWZQR0kxT09NUkxheS9VS2dyc3JlUyt5V240bC92RTJHcDdzbG1JTklz?=
 =?utf-8?B?bll6cGJPN0Njd1E4WWZtRXYxMS8rbEYzNnN2QmNoRFhKZFhsZmY1OE5la0xm?=
 =?utf-8?B?TXJIdGsvY0JFTnBzUkdFeWNBVDBxUDFEcFl3SUw2K25kZHQ5L2lIU1JYTm9C?=
 =?utf-8?B?MzhObm5sY3hrWHNCcFl3R3RKKzFnczNLYlNLTkhBWDloZVRlSWNJdlAybGdz?=
 =?utf-8?B?N2tzS1hIKzdTOFRCczRvN0pYRnF3c1pLUVgwbjhDelRqV2R6Y2pNenVPaEgw?=
 =?utf-8?B?bVNGNlBqVXRVMVdsdTRPbW4yK2x4QU9KWURSdmpQeU16N3I3bVBnc2hhSUQx?=
 =?utf-8?B?NXBpQ25IaytiM0dZd1p2K0lIYlUwcVVJV0pXOVo5K0ZpVTV5MEFsSDRHamJy?=
 =?utf-8?B?YXpyWDJYQWNYZDBjOUFKTEZsV0djTnhvaFBPQjNaZmFCOTljb3RSdU9FdFor?=
 =?utf-8?B?dm1OWTZWcmgwTU51SkNJYnhIRU5rSWFib3daaUZmL0xNY0UvUzZtYnludlFu?=
 =?utf-8?B?Z1hnblNEMkpJdUw4VmlvSGdKbTA5ZHJ6enl0Vnp5cjR6S3QzNWxHbVJtNGZ0?=
 =?utf-8?B?TkozczJIUjBnOWg5SzFoYXRWbCtkOGYraWtwMjVIRHc5b0tndnpDNjNaRUlE?=
 =?utf-8?B?VFpGYytGMVAzN3NhbVltV1daamRQNDNZMTlWMWFaMmNmQ0xKNDE0R1phZXpE?=
 =?utf-8?B?eitlZ0Q2cmY1UGxwNlFlTk80L1VPOTJORHlDMFRPMmtUQTA1aTBRbWx6bllu?=
 =?utf-8?Q?FoebENl/VtpI+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2532.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a149e8-de83-4e50-46e5-08d90bf90180
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2021 16:57:14.8002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y+7K7peyyg+blhho6sUXNh91921DkLnj1YnGjyHMqN4VgCEU3VA0S63GHJ3ZwzwrKaCwP2LUA3G2SaH7gH1mAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4437
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywgDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFyYyBa
eW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBBcHJpbCAzMCwgMjAyMSAx
MDozMSBBTQ0KPiBPbiBGcmksIDMwIEFwciAyMDIxIDE1OjU4OjE0ICswMTAwLA0KPiBTaGFua2Vy
IFIgRG9udGhpbmVuaSA8c2RvbnRoaW5lbmlAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBI
aSBNYXJjLA0KPiA+DQo+ID4gT24gNC8zMC8yMSA2OjQ3IEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6
DQo+ID4gPg0KPiA+ID4+Pj4gV2UndmUgdHdvIGNvbmNlcm5zIGhlcmU6DQo+ID4gPj4+PiAgICAt
IFBlcmZvcm1hbmNlIGltcGFjdHMgZm9yIHBhc3MtdGhyb3VnaCBkZXZpY2VzLg0KPiA+ID4+Pj4g
ICAgLSBUaGUgZGVmaW5pdGlvbiBvZiBpb3JlbWFwX3djKCkgZnVuY3Rpb24gZG9lc24ndCBtYXRj
aCB0aGUNCj4gPiA+Pj4+IGhvc3Qga2VybmVsIG9uIEFSTTY0DQo+ID4gPj4+IFBlcmZvcm1hbmNl
IEkgY2FuIHVuZGVyc3RhbmQsIGJ1dCBJIHRoaW5rIHlvdSdyZSBhbHNvIHVzaW5nIGl0IHRvDQo+
ID4gPj4+IG1hc2sgYSBkcml2ZXIgYnVnIHdoaWNoIHNob3VsZCBiZSByZXNvbHZlZCBmaXJzdC4g
IFRoYW5rDQo+ID4gPj4gV2XigJl2ZSBhbHJlYWR5IGluc3RydW1lbnRlZCB0aGUgZHJpdmVyIGNv
ZGUgYW5kIGZvdW5kIHRoZSBjb2RlIHBhdGgNCj4gPiA+PiBmb3IgdGhlIHVuYWxpZ25lZCBhY2Nl
c3Nlcy4gV2XigJlsbCBmaXggdGhpcyBpc3N1ZSBpZiBpdOKAmXMgbm90DQo+ID4gPj4gZm9sbG93
aW5nIFdDIHNlbWFudGljcy4NCj4gPiA+Pg0KPiA+ID4+IEZpeGluZyB0aGUgcGVyZm9ybWFuY2Ug
Y29uY2VybiB3aWxsIGJlIHVuZGVyIEtWTSBzdGFnZS0yIHBhZ2UtdGFibGUNCj4gPiA+PiBjb250
cm9sLiBXZSdyZSBsb29raW5nIGZvciBhIGd1aWRhbmNlL3NvbHV0aW9uIGZvciB1cGRhdGluZyBz
dGFnZS0yDQo+ID4gPj4gUFRFIGJhc2VkIG9uIFBDSS1CQVIgYXR0cmlidXRlLg0KPiA+ID4gQmVm
b3JlIHdlIHN0YXJ0IGRpc2N1c3NpbmcgdGhlICpob3cqLCBJJ2QgbGlrZSB0byBjbGVhcmx5IHVu
ZGVyc3RhbmQNCj4gPiA+IHdoYXQgKmFybTY0KiBtZW1vcnkgYXR0cmlidXRlcyB5b3UgYXJlIHJl
bHlpbmcgb24uIFdlIGFscmVhZHkgaGF2ZQ0KPiA+ID4gZXN0YWJsaXNoZWQgdGhhdCB0aGUgdW5h
bGlnbmVkIGFjY2VzcyB3YXMgYSBidWcsIHdoaWNoIHdhcyB0aGUNCj4gPiA+IGJpZ2dlc3QgYXJn
dW1lbnQgaW4gZmF2b3VyIG9mIE5PUk1BTF9OQy4gV2hhdCBhcmUgdGhlIG90aGVyDQo+IHJlcXVp
cmVtZW50cz8NCj4gPiBTb3JyeSwgbXkgZWFybGllciByZXNwb25zZSB3YXMgbm90IGNvbXBsZXRl
Li4uDQo+ID4NCj4gPiBBUk12OCBhcmNoaXRlY3R1cmUgaGFzIHR3byBmZWF0dXJlcyBHYXRoZXJp
bmcgYW5kIFJlb3JkZXINCj4gPiB0cmFuc2FjdGlvbnMsIHZlcnkgaW1wb3J0YW50IGZyb20gYSBw
ZXJmb3JtYW5jZSBwb2ludCBvZiB2aWV3LiBTbWFsbA0KPiA+IGlubGluZSBwYWNrZXRzIGZvciBO
SUMgY2FyZHMgYW5kIGFjY2Vzc2VzIHRvIEdQVSdzIGZyYW1lIGJ1ZmZlciBhcmUNCj4gPiBDUFUt
Ym91bmQgb3BlcmF0aW9ucy4gV2Ugd2FudCB0byB0YWtlIGFkdmFudGFnZXMgb2YgR1JFIGZlYXR1
cmVzIHRvDQo+ID4gYWNoaWV2ZSBoaWdoZXIgcGVyZm9ybWFuY2UuDQo+ID4NCj4gPiBCb3RoIHRo
ZXNlIGZlYXR1cmVzIGFyZSBkaXNhYmxlZCBmb3IgcHJlZmV0Y2hhYmxlIEJBUnMgaW4gVk0gYmVj
YXVzZQ0KPiA+IG1lbW9yeS10eXBlIE1UX0RFVklDRV9uR25SRSBlbmZvcmNlZCBpbiBzdGFnZS0y
Lg0KPiANCj4gUmlnaHQsIHNvIE5vcm1hbF9OQyBpcyBhIHJlZCBoZXJyaW5nLCBhbmQgaXQgaXMg
RGV2aWNlX0dSRSB0aGF0IHlvdSByZWFsbHkgYXJlDQo+IGFmdGVyLCByaWdodD8NCj4gDQpJIHRo
aW5rIERldmljZSBHUkUgaGFzIHNvbWUgcHJhY3RpY2FsIHByb2JsZW1zLiANCjEuIEEgbG90IG9m
IHVzZXJzcGFjZSBjb2RlIHdoaWNoIGlzIHVzZWQgdG8gZ2V0dGluZyB3cml0ZSBjb21iaW5lZCBt
YXBwaW5ncw0KdG8gR1BVIG1lbW9yeSBmcm9tIGtlcm5lbCBkcml2ZXJzIGRvZXMgbWVtY3B5L21l
bXNldCBvbiBpdCB3aGljaCANCmNhbiBpbnNlcnQgbGRwL3N0cCB3aGljaCBjYW4gY3Jhc2ggb24g
RGV2aWNlIE1lbW9yeSBUeXBlLiBGcm9tIGEgcXVpY2sgc2VhcmNoDQpJIGRpZG4ndCBmaW5kIGEg
bWVtY3B5X2lvIG9yIG1lbXNldF9pbyBpbiBnbGliYy4gUGVyaGFwcyB0aGVyZSBhcmUgc29tZSAN
Cm90aGVyIGZ1bmN0aW9ucyBhdmFpbGFibGUsIGJ1dCBhIGxvdCBvZiB1c2Vyc3BhY2UgYXBwbGlj
YXRpb25zIHRoYXQgd29yayBvbiB4ODYgYW5kDQpBUk0gYmFyZW1ldGFsIHdvbid0IHdvcmsgb24g
QVJNIFZNcyB3aXRob3V0IHN1Y2ggY2hhbmdlcy4gQ2hhbmdlcyB0byBhbGwgb2YgDQp1c2Vyc3Bh
Y2UgbWF5IG5vdCBhbHdheXMgYmUgcHJhY3RpY2FsLCBzcGVjaWFsbHkgaWYgbGlua2luZyB0byBi
aW5hcmllcw0KDQoyLiBTb21ldGltZXMgZXZlbiBpZiBhcHBsaWNhdGlvbiBpcyBub3QgdXNpbmcg
bWVtc2V0L21lbWNweSBkaXJlY3RseSwgDQpnY2MgbWF5IGluc2VydCBhIGJ1aWx0aW4gbWVtY3B5
L21lbXNldC4gDQoNCjMuIFJlY29tcGlsaW5nIGFsbCBhcHBsaWNhdGlvbnMgd2l0aCBnY2MgLW0g
c3RyaWN0LWFsaWduIGhhcyBwZXJmb3JtYW5jZSBpc3N1ZXMuIA0KSW4gb3VyIGV4cGVyaW1lbnRz
IHRoYXQgcmVzdWx0ZWQgaW4gYW4gaW5jcmVhc2UgaW4gY29kZSBzaXplLCBhbmQgYWxzbyAzLTUl
IA0KcGVyZm9ybWFuY2UgZGVjcmVhc2UgcmVsaWFibHkuDQpBbHNvLCBpdCBpcyBub3QgYWx3YXlz
IHByYWN0aWNhbCB0byByZWNvbXBpbGUgYWxsIG9mIHVzZXJzcGFjZSwgZGVwZW5kaW5nIG9uDQp3
aG8gb3ducyB0aGUgY29kZS9saW5rZWQgYmluYXJpZXMgZXRjLg0KDQpGcm9tIEtWTS1BUk0gcG9p
bnQgb2Ygdmlldywgd2hhdCBpcyBpdCBhYm91dCBOb3JtYWwgTkMgYXQgc3RhZ2UgMiBmb3INClBy
ZWZldGNoYWJsZSBCQVIgKGhvd2V2ZXIgS1ZNIGdldHMgdGhlIGhpbnQsIHdoZXRoZXIgZnJvbSB1
c2Vyc3BhY2Ugb3IgVk1BKQ0KdGhhdCBpcyB1bmRlc2lyYWJsZSB2cyBEZXZpY2UgR1JFPyBJIGNv
dWxkbid0IHRoaW5rIG9mIGEgZGlmZmVyZW5jZSB0byBkZXZpY2VzDQp3aGV0aGVyIHRoZSBjb21i
aW5pbmcgb3IgcHJlZmV0Y2hpbmcgb3IgcmVvcmRlcmluZyBoYXBwZW5lZCBiZWNhdXNlIG9mIG9u
ZSBvcg0KdGhlIG90aGVyLiANCg0KPiBOb3csIEknbSBub3QgY29udmluY2VkIHRoYXQgd2UgY2Fu
IGRvIHRoYXQgZGlyZWN0bHkgZnJvbSB2ZmlvIGluIGEgZGV2aWNlLQ0KPiBhZ25vc3RpYyBtYW5u
ZXIuIEl0IGlzIHVzZXJzcGFjZSB0aGF0IHBsYWNlcyB0aGUgZGV2aWNlIGluIHRoZSBndWVzdCdz
DQo+IG1lbW9yeSwgYW5kIEkgaGF2ZSB0aGUgdWdseSBmZWVsaW5nIHRoYXQgdXNlcnNwYWNlIG5l
ZWRzIHRvIGJlIGluIGNvbnRyb2wgb2YNCj4gbWVtb3J5IGF0dHJpYnV0ZXMuDQo+IA0KPiBPdGhl
cndpc2UsIHdlIGNoYW5nZSB0aGUgYmVoYXZpb3VyIGZvciBhbGwgZXhpc3RpbmcgZGV2aWNlcyB0
aGF0IGhhdmUNCj4gcHJlZmV0Y2hhYmxlIEJBUnMsIGFuZCBJIGRvbid0IHRoaW5rIHRoYXQncyBh
biBhY2NlcHRhYmxlIG1vdmUgKHVzZXJzcGFjZQ0KPiBBQkkgY2hhbmdlKS4NCj4gDQo+ICAgICAg
ICAgTS4NCj4gDQo+IC0tDQo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dy
ZXNzIGlzIG5vdCBwb3NzaWJsZS4NCg==
