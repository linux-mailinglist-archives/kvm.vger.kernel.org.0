Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3693E0B54
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 02:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbhHEAhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 20:37:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:43619 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236345AbhHEAhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 20:37:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="201226073"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="201226073"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 17:36:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="668524399"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 04 Aug 2021 17:36:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 17:36:39 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 17:36:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 4 Aug 2021 17:36:38 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 4 Aug 2021 17:36:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnMLB1GsdNPGZs5OjZezIGGMTiRJBAAlz2QqsvnDQtvA1SuNOQs70xGI+7FrEoupxvUJQoCdpurhdUnSHWB09yf118bDsOyW/juXUFzz8GCd5LJClFESLT507Ghy/lQaDiNO38mEg7wgWA1AcU9CSCbuEJULduXrNED7Kf34nwxGPKKbWDV470HXrTgSNBEVWPKbM9mkysA0DpNltnxkxYnfETY+Z+6GR8e/nXqg9QY8veulL4hjaITa2dN9x1fAxEENggRvtNMflYlOFKlzKvWzIUWLYfc9DfCYq7MkyDF78bCAOTHzg+mDvlso+/6DI6vDG0xvZEiVSdEfAzcCsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tqv34iTwzse7AYCVgD5ayZvqk+eLcaqEzlyGXC7lCN0=;
 b=JDEZSmv35Gozfks2t640Hhkz5z4o+3/IOCu5LS5SaTNav537OKRkWHG/C7YG72J5eXGsilkAuPy9lLZkD9UuGaCkQIP92hW4OuGi3ttX9d981PIwBEZgyImbsGlxgr1tKyroGBwQ45S2EJZt23K1RSw6YNL1fUvZSqOOl5+jatq5vJ+ZaSclqf3mUHdtE+eG+uDMkvmMhwOFVElXE/AFzdogYoAM9qdVyexNcgBw1EDID9E9NzhA5c89Fas8rD94I0SWkPW357P3Yz90sZXZRUvUaeL35GdsQwjxJ54/4nW19C0zzFInr767p8II1BaUbS8XkB0KqPyLjoaoYC6Aqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tqv34iTwzse7AYCVgD5ayZvqk+eLcaqEzlyGXC7lCN0=;
 b=HCQeZsqXtbG5h1bVyxf3S5Ly0xe4R1dJ/m1u297QP3p/0yoJzkPhSxpibA/RUPWMm2wUycCZnC/3ZwU8lXdBsAh/yzcagHDhVaCpXjkEzS5ca+eiPyflbreY75Uumuhoau6h1JTK0+VuIxfcvoyyZcwrv5cAPjXqznITUVI+fBI=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB0052.namprd11.prod.outlook.com (2603:10b6:405:69::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 5 Aug
 2021 00:36:31 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%8]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 00:36:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQUsvqiAAA+DMpA=
Date:   Thu, 5 Aug 2021 00:36:31 +0000
Message-ID: <BN9PR11MB5433453DED3546F5011C3BDD8CF29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <b83a25de-7c32-42c4-d99d-f7242cc9e2da@redhat.com>
In-Reply-To: <b83a25de-7c32-42c4-d99d-f7242cc9e2da@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99b9db05-5617-493c-05ce-08d957a91263
x-ms-traffictypediagnostic: BN6PR11MB0052:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB005220D5E9EA93195214FA158CF29@BN6PR11MB0052.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sC+vaMd7e6/E9lvQuwRf4fGrwf9fUhV7quPOIDd7slkEkpHMJfQYjLVRJ4norL8E91L0eOaAI7NmDXIsSTA3y9AHo5bSB8zOaeXHsgvnkG5FATJNkK7Ao1C8AjTpPxoUImhmdzEMwxk13UZSHj87bn9Jpw36GhCY7gOo2rlmXPYGUFCIoWiClac9a8SbuEZcULeoYN08+duBugY+2bKY+5QREwD9GXuYgPVVI69TDE50YbK1rhNoKhx8aheU68rcAfknzMBJJOTcoLl1xI7yfY9HXlI8nJjwNdWNvK776bcM5vjnz6cVlOOpiFQuNZEYnZh7n8VNP5taltglKi6NOvGocd3RyO3mP7lp2tM/eSFTxkX6Cm/Qi3DVLFFvf0y+76Wy7wvlSVzmYPgBgTnjv0O3oXh5cgmWpiaJPDCF9KA5V8pOjU7cmNnjebBQYfb5NJ0zv4gQO2C7+r057MNU/0I79GBis/kQrY8kLNcSgAOiPOM6XCEKGu4w1Q5DhhgOBL2N2X3I6MPZFqoNTcuY+scENyQvl6myctmQhCxXR0ITWmCqbR2PtLb9RN+0fUic5dI0X2cMyQpvY+qYmt5kVc8U9vtLcR5WgOCZgMGkUJsGUsOFXRy0Dbc2L+AZMl7QBrPLz3bpLKcSDuQA0zqXmc1HWa3oAotoKpMtgJwgijp8ad9pSuu9FE+OaHaaGz2I7kKgqNCWXCousavGcMwlrdvwxA2dyN/Vh5dMSA7kXMM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(186003)(54906003)(55016002)(921005)(33656002)(9686003)(8676002)(38100700002)(5660300002)(4326008)(71200400001)(122000001)(26005)(478600001)(83380400001)(110136005)(66446008)(76116006)(66476007)(66946007)(7696005)(64756008)(316002)(52536014)(7416002)(86362001)(2906002)(8936002)(6506007)(38070700005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEtFbkVWazdpZkV4TWttS1c0UjR5WWp4S1E2anZmUHd1NzVUTlJQL0lndmhL?=
 =?utf-8?B?RlZMaXZqVzMrekpMQXVTK3dHc1pKbXhnUzV5MEVIRlJ4enBES2ZkWEZ5aFZx?=
 =?utf-8?B?WEVjeFBuc21kWEtiWmV6YXZVZWJZcEFrQjFtbnZmSnp3WkQvQkV5Ymp2ZWlt?=
 =?utf-8?B?MW4zV2ZJWFBzWmZ5ZG02ME43V2hqRGxQR1BBRUFqUkh4RHJWVTVkTUFveXRr?=
 =?utf-8?B?WkZRK3l6WkRmdW1EeDlaWTRWOWlGekVpbktFZXc2ZFc4N00rczQ2RGw2MldX?=
 =?utf-8?B?SjBqeHJOdk5veVEwdUcyVXFtby9YdUw5S0tTZnAybHROdnhJbVMvZ25aMWk0?=
 =?utf-8?B?eTBlVkVSbHhPUWVEZWZ2U2V3TEcydGRXaVdMdjc0WklVeHdhMW5xckEwanR2?=
 =?utf-8?B?OUNjQ2JvMXYrZDFDKytBS0RKYzc0dGFxNUdWeU5PS09IbWlMczU2dTFULzBs?=
 =?utf-8?B?LzVOOHdjbTVFTE5zdlVKNXNOOHBPekw3MlBMWFY4OU5CYnJTN1l5RU9xQnFu?=
 =?utf-8?B?QjBnS2hqM3VlcDNyOVBGV1dMbE9meEpla2F6Mmdrdi9JRjVKZUU2VU1DYnF1?=
 =?utf-8?B?MjdRM0FRYjNuMnY3UUJXdTA2YTU1RTlVbzZkSHZqWnJtTEs2WUZaT0kzaEw0?=
 =?utf-8?B?RHhsdzZkM0xpS3dEamZQRFZkWXlWOUN2MEJ5SGxtQWYybHd6N3dqd21TeVhZ?=
 =?utf-8?B?WGRuK0E1WlNNSnlwL3lhSmdxSjJGV1NoZmw1WG8raW1KSzJmTzBzRVhXb2ZY?=
 =?utf-8?B?WTZ2KzJrSWhmUFIxZHQwN1BzWHlUOFhtcVpjY0N3R01BQkpjWXNBQVk3UG1s?=
 =?utf-8?B?eUNpMTFDNnZGMnp3Vi9CVVBwUzFRRUNmYjlWN3E2QmhNYlQyTTFtN29qeFY2?=
 =?utf-8?B?elFZdFE3LzFCOG5LWkh0MW1IdFRMWlpHQ01OVm1iUWZzczdKQW9PamJwa2Zk?=
 =?utf-8?B?aGVqYU9oOHJ6SDdQV3RRblhkL1RjY0pSOGVKMTRKdlVuK3VBNSs5S0ExMnJs?=
 =?utf-8?B?UTU4MXVBNWdwZ0F4MGFOYm9mK3RLakovZXFpSHpPSFQzY00zUlVSVFlsc2FI?=
 =?utf-8?B?NHJSL2xOYXpqbnlqYlpjWEVKakdHUDFYWFVLMUZzLys0dXlnVkdGckdHUUpZ?=
 =?utf-8?B?UThLcjI5ZWhMWml0eHZWNGN2cE5obVIyS3YrRDRnbVFHa0FLRVdCL2hGL1Yx?=
 =?utf-8?B?QnIvcXFiUUxFUWIzQ2hNcHN0QXhYY3ZCSlF5UkNrOXNjYzFTQ3ZDVFloajVI?=
 =?utf-8?B?Y3hWNmxUTTVjWklSdFFYaUE5ZVkxbmg0MXVKRWt5Q1NDSHZ1M1FHOFJVRWVy?=
 =?utf-8?B?d3hNc3pRci9KRFFWU0h5R0RDNFJPVVFzK0VZcTN0NnBMVk56UHlmOWl0RXho?=
 =?utf-8?B?MmNYT0dNcU15L0Q1Sy9NY0tibm5PdUJJVExlTDJNRG5LMzdoYkhCelhHTXZS?=
 =?utf-8?B?R3htc3Jrc1FLT0RhcldobldlZGY3MjRKZG56d2VGWEFTMDBGY3pHUzc5ODYz?=
 =?utf-8?B?SStCOHRldnFGczhUNHREZVYrVVNFeTFzcmFkTDZsNU82YXZUR0RicDQvVmxR?=
 =?utf-8?B?OG14TzJITTF5VElQSjVxVjNOSFNwa2Q0Wll1VkVYc2lScno0amJoeVRLRi9m?=
 =?utf-8?B?d2ZSUHNpNzJ5TC8vOFlXbzZmemV4R25KU0J1TSs4ejE0cDVIc2hYSDloRHgw?=
 =?utf-8?B?bWxUVXpVaDJmWVNKb0lMVm92TFRRUEpmVXlXTUNJYzJoeVIrcWN3V1E4Wktv?=
 =?utf-8?Q?tewOi+f/RDrsOQeTfdnyMOracCg2pvSeuq9Xqpj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b9db05-5617-493c-05ce-08d957a91263
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 00:36:31.7741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hP9+T6Guj3C4O6WtBDCLviPFBPMiZB/gGeKRA9INiOXsf4AItm9y5WBwHtMshclnhYyxbxpSGRbOwXZknctQdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0052
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgQXVndXN0IDQsIDIwMjEgMTE6NTkgUE0NCj4NClsuLi5dIA0KPiA+IDEuMi4gQXR0YWNo
IERldmljZSB0byBJL08gYWRkcmVzcyBzcGFjZQ0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiA+DQo+ID4gRGV2aWNlIGF0dGFjaC9iaW5kIGlzIGluaXRpYXRl
ZCB0aHJvdWdoIHBhc3N0aHJvdWdoIGZyYW1ld29yayB1QVBJLg0KPiA+DQo+ID4gRGV2aWNlIGF0
dGFjaGluZyBpcyBhbGxvd2VkIG9ubHkgYWZ0ZXIgYSBkZXZpY2UgaXMgc3VjY2Vzc2Z1bGx5IGJv
dW5kIHRvDQo+ID4gdGhlIElPTU1VIGZkLiBVc2VyIHNob3VsZCBwcm92aWRlIGEgZGV2aWNlIGNv
b2tpZSB3aGVuIGJpbmRpbmcgdGhlDQo+ID4gZGV2aWNlIHRocm91Z2ggVkZJTyB1QVBJLiBUaGlz
IGNvb2tpZSBpcyB1c2VkIHdoZW4gdGhlIHVzZXIgcXVlcmllcw0KPiA+IGRldmljZSBjYXBhYmls
aXR5L2Zvcm1hdCwgaXNzdWVzIHBlci1kZXZpY2UgaW90bGIgaW52YWxpZGF0aW9uIGFuZA0KPiA+
IHJlY2VpdmVzIHBlci1kZXZpY2UgSS9PIHBhZ2UgZmF1bHQgZGF0YSB2aWEgSU9NTVUgZmQuDQo+
ID4NCj4gPiBTdWNjZXNzZnVsIGJpbmRpbmcgcHV0cyB0aGUgZGV2aWNlIGludG8gYSBzZWN1cml0
eSBjb250ZXh0IHdoaWNoIGlzb2xhdGVzDQo+ID4gaXRzIERNQSBmcm9tIHRoZSByZXN0IHN5c3Rl
bS4gVkZJTyBzaG91bGQgbm90IGFsbG93IHVzZXIgdG8gYWNjZXNzIHRoZQ0KPiBzL2Zyb20gdGhl
IHJlc3Qgc3lzdGVtL2Zyb20gdGhlIHJlc3Qgb2YgdGhlIHN5c3RlbQ0KPiA+IGRldmljZSBiZWZv
cmUgYmluZGluZyBpcyBjb21wbGV0ZWQuIFNpbWlsYXJseSwgVkZJTyBzaG91bGQgcHJldmVudCB0
aGUNCj4gPiB1c2VyIGZyb20gdW5iaW5kaW5nIHRoZSBkZXZpY2UgYmVmb3JlIHVzZXIgYWNjZXNz
IGlzIHdpdGhkcmF3bi4NCj4gV2l0aCBJbnRlbCBzY2FsYWJsZSBJT1YsIEkgdW5kZXJzdGFuZCB5
b3UgY291bGQgYXNzaWduIGFuIFJJRC9QQVNJRCB0bw0KPiBvbmUgVk0gYW5kIGFub3RoZXIgb25l
IHRvIGFub3RoZXIgVk0gKHdoaWNoIGlzIG5vdCB0aGUgY2FzZSBmb3IgQVJNKS4gSXMNCj4gaXQg
YSB0YXJnZXR0ZWQgdXNlIGNhc2U/SG93IHdvdWxkIGl0IGJlIGhhbmRsZWQ/IElzIGl0IHJlbGF0
ZWQgdG8gdGhlDQo+IHN1Yi1ncm91cHMgZXZva2VkIGhlcmVhZnRlcj8NCg0KTm90IHJlbGF0ZWQg
dG8gc3ViLWdyb3VwLiBFYWNoIG1kZXYgaXMgYm91bmQgdG8gdGhlIElPTU1VIGZkIHJlc3BlY3Rp
dmVseQ0Kd2l0aCB0aGUgZGVmUEFTSUQgd2hpY2ggcmVwcmVzZW50cyB0aGUgbWRldi4NCg0KPiAN
Cj4gQWN0dWFsbHkgYWxsIGRldmljZXMgYm91bmQgdG8gYW4gSU9NTVUgZmQgc2hvdWxkIGhhdmUg
dGhlIHNhbWUgcGFyZW50DQo+IEkvTyBhZGRyZXNzIHNwYWNlIG9yIHJvb3QgYWRkcmVzcyBzcGFj
ZSwgYW0gSSBjb3JyZWN0PyBJZiBzbywgbWF5YmUgYWRkDQo+IHRoaXMgY29tbWVudCBleHBsaWNp
dGx5Pw0KDQppbiBtb3N0IGNhc2VzIHllcyBidXQgaXQncyBub3QgbWFuZGF0b3J5LiBtdWx0aXBs
ZSByb290cyBhcmUgYWxsb3dlZA0KKGUuZy4gd2l0aCB2SU9NTVUgYnV0IG5vIG5lc3RpbmcpLg0K
DQpbLi4uXQ0KPiA+IFRoZSBkZXZpY2UgaW4gdGhlIC9kZXYvaW9tbXUgY29udGV4dCBhbHdheXMg
cmVmZXJzIHRvIGEgcGh5c2ljYWwgb25lDQo+ID4gKHBkZXYpIHdoaWNoIGlzIGlkZW50aWZpYWJs
ZSB2aWEgUklELiBQaHlzaWNhbGx5IGVhY2ggcGRldiBjYW4gc3VwcG9ydA0KPiA+IG9uZSBkZWZh
dWx0IEkvTyBhZGRyZXNzIHNwYWNlIChyb3V0ZWQgdmlhIFJJRCkgYW5kIG9wdGlvbmFsbHkgbXVs
dGlwbGUNCj4gPiBub24tZGVmYXVsdCBJL08gYWRkcmVzcyBzcGFjZXMgKHZpYSBSSUQrUEFTSUQp
Lg0KPiA+DQo+ID4gVGhlIGRldmljZSBpbiBWRklPIGNvbnRleHQgaXMgYSBsb2dpYyBjb25jZXB0
LCBiZWluZyBlaXRoZXIgYSBwaHlzaWNhbA0KPiA+IGRldmljZSAocGRldikgb3IgbWVkaWF0ZWQg
ZGV2aWNlIChtZGV2IG9yIHN1YmRldikuIEVhY2ggdmZpbyBkZXZpY2UNCj4gPiBpcyByZXByZXNl
bnRlZCBieSBSSUQrY29va2llIGluIElPTU1VIGZkLiBVc2VyIGlzIGFsbG93ZWQgdG8gY3JlYXRl
DQo+ID4gb25lIGRlZmF1bHQgSS9PIGFkZHJlc3Mgc3BhY2UgKHJvdXRlZCBieSB2UklEIGZyb20g
dXNlciBwLm8udikgcGVyDQo+ID4gZWFjaCB2ZmlvX2RldmljZS4NCj4gVGhlIGNvbmNlcHQgb2Yg
ZGVmYXVsdCBhZGRyZXNzIHNwYWNlIGlzIG5vdCBmdWxseSBjbGVhciBmb3IgbWUuIEkNCj4gY3Vy
cmVudGx5IHVuZGVyc3RhbmQgdGhpcyBpcyBhDQo+IHJvb3QgYWRkcmVzcyBzcGFjZSAobm90IG5l
c3RpbmcpLiBJcyB0aGF0IGNvb3JlY3QuVGhpcyBtYXkgbmVlZA0KPiBjbGFyaWZpY2F0aW9uLg0K
DQp3L28gUEFTSUQgdGhlcmUgaXMgb25seSBvbmUgYWRkcmVzcyBzcGFjZSAoZWl0aGVyIEdQQSBv
ciBHSU9WQSkNCnBlciBkZXZpY2UuIFRoaXMgb25lIGlzIGNhbGxlZCBkZWZhdWx0LiB3aGV0aGVy
IGl0J3Mgcm9vdCBpcyBvcnRob2dvbmFsDQooZS5nLiBHSU9WQSBjb3VsZCBiZSBhbHNvIG5lc3Rl
ZCkgdG8gdGhlIGRldmljZSB2aWV3IG9mIHRoaXMgc3BhY2UuDQoNCncvIFBBU0lEIGFkZGl0aW9u
YWwgYWRkcmVzcyBzcGFjZXMgY2FuIGJlIHRhcmdldGVkIGJ5IHRoZSBkZXZpY2UuDQp0aG9zZSBh
cmUgY2FsbGVkIG5vbi1kZWZhdWx0Lg0KDQpJIGNvdWxkIGFsc28gcmVuYW1lIGRlZmF1bHQgdG8g
UklEIGFkZHJlc3Mgc3BhY2UgYW5kIG5vbi1kZWZhdWx0IHRvIA0KUklEK1BBU0lEIGFkZHJlc3Mg
c3BhY2UgaWYgZG9pbmcgc28gbWFrZXMgaXQgY2xlYXJlci4NCg0KPiA+IFZGSU8gZGVjaWRlcyB0
aGUgcm91dGluZyBpbmZvcm1hdGlvbiBmb3IgdGhpcyBkZWZhdWx0DQo+ID4gc3BhY2UgYmFzZWQg
b24gZGV2aWNlIHR5cGU6DQo+ID4NCj4gPiAxKSAgcGRldiwgcm91dGVkIHZpYSBSSUQ7DQo+ID4N
Cj4gPiAyKSAgbWRldi9zdWJkZXYgd2l0aCBJT01NVS1lbmZvcmNlZCBETUEgaXNvbGF0aW9uLCBy
b3V0ZWQgdmlhDQo+ID4gICAgIHRoZSBwYXJlbnQncyBSSUQgcGx1cyB0aGUgUEFTSUQgbWFya2lu
ZyB0aGlzIG1kZXY7DQo+ID4NCj4gPiAzKSAgYSBwdXJlbHkgc3ctbWVkaWF0ZWQgZGV2aWNlIChz
dyBtZGV2KSwgbm8gcm91dGluZyByZXF1aXJlZCBpLmUuIG5vDQo+ID4gICAgIG5lZWQgdG8gaW5z
dGFsbCB0aGUgSS9PIHBhZ2UgdGFibGUgaW4gdGhlIElPTU1VLiBzdyBtZGV2IGp1c3QgdXNlcw0K
PiA+ICAgICB0aGUgbWV0YWRhdGEgdG8gYXNzaXN0IGl0cyBpbnRlcm5hbCBETUEgaXNvbGF0aW9u
IGxvZ2ljIG9uIHRvcCBvZg0KPiA+ICAgICB0aGUgcGFyZW50J3MgSU9NTVUgcGFnZSB0YWJsZTsN
Cj4gTWF5YmUgeW91IHNob3VsZCBpbnRyb2R1Y2UgdGhpcyBjb25jZXB0IG9mIFNXIG1lZGlhdGVk
IGRldmljZSBlYXJsaWVyDQo+IGJlY2F1c2UgaXQgc2VlbXMgdG8gc3BlY2lhbCBjYXNlIHRoZSB3
YXkgdGhlIGF0dGFjaCBiZWhhdmVzLiBJIGFtDQo+IGVzcGVjaWFsbHkgcmVmZXJpbmcgdG8NCj4g
DQo+ICJTdWNjZXNzZnVsIGF0dGFjaGluZyBhY3RpdmF0ZXMgYW4gSS9PIGFkZHJlc3Mgc3BhY2Ug
aW4gdGhlIElPTU1VLCBpZiB0aGUNCj4gZGV2aWNlIGlzIG5vdCBwdXJlbHkgc29mdHdhcmUgbWVk
aWF0ZWQiDQoNCm1ha2VzIHNlbnNlLg0KDQo+IA0KPiA+DQo+ID4gSW4gYWRkaXRpb24sIFZGSU8g
bWF5IGFsbG93IHVzZXIgdG8gY3JlYXRlIGFkZGl0aW9uYWwgSS9PIGFkZHJlc3Mgc3BhY2VzDQo+
ID4gb24gYSB2ZmlvX2RldmljZSBiYXNlZCBvbiB0aGUgaGFyZHdhcmUgY2FwYWJpbGl0eS4gSW4g
c3VjaCBjYXNlIHRoZSB1c2VyDQo+ID4gaGFzIGl0cyBvd24gdmlldyBvZiB0aGUgdmlydHVhbCBy
b3V0aW5nIGluZm9ybWF0aW9uICh2UEFTSUQpIHdoZW4gbWFya2luZw0KPiA+IHRoZXNlIG5vbi1k
ZWZhdWx0IGFkZHJlc3Mgc3BhY2VzLg0KPiBJIGRvIG5vdCBjYXRjaCB3aGF0IGRvZXMgbWVhbiAi
bWFya2luZyB0aGVzZSBub24gZGVmYXVsdCBhZGRyZXNzIHNwYWNlIi4NCg0KYXMgZXhwbGFpbmVk
IGFib3ZlLCB0aG9zZSBub24tZGVmYXVsdCBhZGRyZXNzIHNwYWNlcyBhcmUgaWRlbnRpZmllZC9y
b3V0ZWQNCnZpYSBQQVNJRC4gDQoNCj4gPg0KPiA+IDEuMy4gR3JvdXAgaXNvbGF0aW9uDQo+ID4g
KysrKysrKysrKysrKysrKysrKysNClsuLi5dDQo+ID4NCj4gPiAxKSAgQSBzdWNjZXNzZnVsIGJp
bmRpbmcgY2FsbCBmb3IgdGhlIGZpcnN0IGRldmljZSBpbiB0aGUgZ3JvdXAgY3JlYXRlcw0KPiA+
ICAgICB0aGUgc2VjdXJpdHkgY29udGV4dCBmb3IgdGhlIGVudGlyZSBncm91cCwgYnk6DQo+ID4N
Cj4gPiAgICAgKiBWZXJpZnlpbmcgZ3JvdXAgdmlhYmlsaXR5IGluIGEgc2ltaWxhciB3YXkgYXMg
VkZJTyBkb2VzOw0KPiA+DQo+ID4gICAgICogQ2FsbGluZyBJT01NVS1BUEkgdG8gbW92ZSB0aGUg
Z3JvdXAgaW50byBhIGJsb2NrLWRtYSBzdGF0ZSwNCj4gPiAgICAgICB3aGljaCBtYWtlcyBhbGwg
ZGV2aWNlcyBpbiB0aGUgZ3JvdXAgYXR0YWNoZWQgdG8gYW4gYmxvY2stZG1hDQo+ID4gICAgICAg
ZG9tYWluIHdpdGggYW4gZW1wdHkgSS9PIHBhZ2UgdGFibGU7DQo+IHRoaXMgYmxvY2stZG1hIHN0
YXRlL2RvbWFpbiB3b3VsZCBkZXNlcnZlIHRvIGJlIGJldHRlciBkZWZpbmVkIChJIGtub3cNCj4g
eW91IGFscmVhZHkgZXZva2VkIGl0IGluIDEuMSB3aXRoIHRoZSBkbWEgbWFwcGluZyBwcm90b2Nv
bCB0aG91Z2gpDQo+IGFjdGl2YXRlcyBhbiBlbXB0eSBJL08gcGFnZSB0YWJsZSBpbiB0aGUgSU9N
TVUgKGlmIHRoZSBkZXZpY2UgaXMgbm90DQo+IHB1cmVseSBTVyBtZWRpYXRlZCk/DQoNCnN1cmUu
IHNvbWUgZXhwbGFuYXRpb25zIGFyZSBzY2F0dGVyZWQgaW4gZm9sbG93aW5nIHBhcmFncmFwaCwg
YnV0IEkNCmNhbiBjb25zaWRlciB0byBmdXJ0aGVyIGNsYXJpZnkgaXQuDQoNCj4gSG93IGRvZXMg
dGhhdCByZWxhdGUgdG8gdGhlIGRlZmF1bHQgYWRkcmVzcyBzcGFjZT8gSXMgaXQgdGhlIHNhbWU/
DQoNCmRpZmZlcmVudC4gdGhpcyBibG9jay1kbWEgZG9tYWluIGRvZXNuJ3QgaG9sZCBhbnkgdmFs
aWQgbWFwcGluZy4gVGhlDQpkZWZhdWx0IGFkZHJlc3Mgc3BhY2UgaXMgcmVwcmVzZW50ZWQgYnkg
YSBub3JtYWwgdW5tYW5hZ2VkIGRvbWFpbi4NCnRoZSBpb2FzaWQgYXR0YWNoaW5nIG9wZXJhdGlv
biB3aWxsIGRldGFjaCB0aGUgZGV2aWNlIGZyb20gdGhlIGJsb2NrLWRtYQ0KZG9tYWluIGFuZCB0
aGVuIGF0dGFjaCBpdCB0byB0aGUgdGFyZ2V0IGlvYXNpZC4NCg0KPiA+DQo+ID4gMi4gdUFQSSBQ
cm9wb3NhbA0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NClsuLi5dDQo+ID4gLyoNCj4gPiAg
ICogQWxsb2NhdGUgYW4gSU9BU0lELg0KPiA+ICAgKg0KPiA+ICAgKiBJT0FTSUQgaXMgdGhlIEZE
LWxvY2FsIHNvZnR3YXJlIGhhbmRsZSByZXByZXNlbnRpbmcgYW4gSS9PIGFkZHJlc3MNCj4gPiAg
ICogc3BhY2UuIEVhY2ggSU9BU0lEIGlzIGFzc29jaWF0ZWQgd2l0aCBhIHNpbmdsZSBJL08gcGFn
ZSB0YWJsZS4gVXNlcg0KPiA+ICAgKiBtdXN0IGNhbGwgdGhpcyBpb2N0bCB0byBnZXQgYW4gSU9B
U0lEIGZvciBldmVyeSBJL08gYWRkcmVzcyBzcGFjZSB0aGF0IGlzDQo+ID4gICAqIGludGVuZGVk
IHRvIGJlIHRyYWNrZWQgYnkgdGhlIGtlcm5lbC4NCj4gPiAgICoNCj4gPiAgICogVXNlciBuZWVk
cyB0byBzcGVjaWZ5IHRoZSBhdHRyaWJ1dGVzIG9mIHRoZSBJT0FTSUQgYW5kIGFzc29jaWF0ZWQN
Cj4gPiAgICogSS9PIHBhZ2UgdGFibGUgZm9ybWF0IGluZm9ybWF0aW9uIGFjY29yZGluZyB0byBv
bmUgb3IgbXVsdGlwbGUgZGV2aWNlcw0KPiA+ICAgKiB3aGljaCB3aWxsIGJlIGF0dGFjaGVkIHRv
IHRoaXMgSU9BU0lEIHJpZ2h0IGFmdGVyLiBUaGUgSS9PIHBhZ2UgdGFibGUNCj4gPiAgICogaXMg
YWN0aXZhdGVkIGluIHRoZSBJT01NVSB3aGVuIGl0J3MgYXR0YWNoZWQgYnkgYSBkZXZpY2UuIElu
Y29tcGF0aWJsZQ0KPiANCj4gLi4gaWYgbm90IFNXIG1lZGlhdGVkDQo+ID4gICAqIGZvcm1hdCBi
ZXR3ZWVuIGRldmljZSBhbmQgSU9BU0lEIHdpbGwgbGVhZCB0byBhdHRhY2hpbmcgZmFpbHVyZS4N
Cj4gPiAgICoNCj4gPiAgICogVGhlIHJvb3QgSU9BU0lEIHNob3VsZCBhbHdheXMgaGF2ZSBhIGtl
cm5lbC1tYW5hZ2VkIEkvTyBwYWdlDQo+ID4gICAqIHRhYmxlIGZvciBzYWZldHkuIExvY2tlZCBw
YWdlIGFjY291bnRpbmcgaXMgYWxzbyBjb25kdWN0ZWQgb24gdGhlIHJvb3QuDQo+IFRoZSBkZWZp
bml0aW9uIG9mIHJvb3QgSU9BU0lEIGlzIG5vdCBlYXNpbHkgZm91bmQgaW4gdGhpcyBzcGVjLiBN
YXliZQ0KPiB0aGlzIHdvdWxkIGRlc2VydmUgc29tZSBjbGFyaWZpY2F0aW9uLg0KDQptYWtlIHNl
bnNlLg0KDQphbmQgdGhhbmtzIGZvciBvdGhlciB0eXBvLXJlbGF0ZWQgY29tbWVudHMuDQoNClRo
YW5rcw0KS2V2aW4NCg==
