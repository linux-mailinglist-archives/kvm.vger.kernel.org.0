Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470CD414B84
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhIVOPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:15:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:14025 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhIVOPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:15:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="210680292"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="210680292"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 07:13:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="435447265"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga006.jf.intel.com with ESMTP; 22 Sep 2021 07:13:05 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 07:13:04 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 07:13:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 07:13:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 07:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkFJ52zRUQ4FZUmd0gg8mruQeKPKNpFH4k02MNRVLxDMHPRpzoLTl9x1p1mIHQp8Sx5HG5NLfRSg/Zg7XMQkU2mO8BkkiXpWjh/0MrINYHUD8pgk+Ol/5My+03XBNxv2XNMRBZA29KnvLdJz1rSuWTI2gf1zm2vJJlSUs2+mos0yLO/MP/T3LN06/XoFpOmRgyUK2pZPfXtU8599N6mGCDmKCcmhfvRfz2KmrYIFuruMBkGRpVorKDDqe1SHwyhpZpJeiG4n6K5bVlXzeV2mp7GbJNmgALrw3V9GuI+THzz4wziKOYOVZVaqg3G5jitzm8FPsnHOWOEcH4PrGU003w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NwjA6dZvIJSKzbe9BUXqocZrDnsfGu8wf1aVdbSJF4Q=;
 b=H5zGAl0yRYluKdE99ivz4RpgiXZn6Y0jDy0Y/AozYSdjM5oLuR9jWZkb8liH3t2nRo1HeBF8icGM7iTACQb4j8u0UBMuYKibLJkBC1uyvhuwKUXPWcObycrjUPdfpKSy4sZnTJdBDdg02uLK6etdGUzjW7SGy6NNC/1BbCqOhUrMepeJitXHcRwdzLK3yEC4hYHYVz0GsHNIcZy2cRB9RxEDVP9+fKVSsinX7VqwC6sd4gtovTwi2GW/Ye3tfFvYqKwWawhm3SiIFALsJKnyGjBUvi0PzzQ8701V02OMmSH0PZlYYz5KEmKF2EvHPM2bO4MiAgjVBpEllDv9nun3XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwjA6dZvIJSKzbe9BUXqocZrDnsfGu8wf1aVdbSJF4Q=;
 b=b10jk8k3vspaX5yJP87QlO2euOXcq5HAFdyFnMYsnWF66zqBZiM1AIlQ8q2gwQ7kL0boOJVRRKgMPVI3irhjpH4+Q4vRKAD70eFwmf5511D/zpBnHM+P4ixh5/KMYM9gRGYGjt4s9CRmKYxI28pyFD/xKx0rMomH223ycZtjW30=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2339.namprd11.prod.outlook.com (2603:10b6:404:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 14:13:01 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 14:13:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 12/20] iommu/iommufd: Add IOMMU_CHECK_EXTENSION
Thread-Topic: [RFC 12/20] iommu/iommufd: Add IOMMU_CHECK_EXTENSION
Thread-Index: AQHXrSGTBKS/Pyh9FkOu0zPObIcIUquuxyWAgAClzVCAAJsDgIAAFQsw
Date:   Wed, 22 Sep 2021 14:13:01 +0000
Message-ID: <BN9PR11MB54333A6D9F4B466998857C588CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-13-yi.l.liu@intel.com>
 <20210921174711.GX327412@nvidia.com>
 <BN9PR11MB54334A552C3E606F4394EF298CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922125525.GM327412@nvidia.com>
In-Reply-To: <20210922125525.GM327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 886cd616-b680-4bc7-9064-08d97dd3161d
x-ms-traffictypediagnostic: BN6PR1101MB2339:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2339CFD24C7491D503AE39888CA29@BN6PR1101MB2339.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3agCjDb+fwn7s63XHZXLAkWxVRDYi6J5ixVXGt7hsw9mtOGIEI0aOKU/007RUT9T0EEuG2OO3w+kEbLACFkqt0eJC2fxA5w3HTcEJZDdtRmdVcrhrPtT3CaDFMAPfvUB7Iv6ujuhDVjPJ+n2jL1C6Hkuxu/+W2k/xJ6dArJBhBw5nt2jQ7qdB8Ug5DJJswJx3xQdr32/gW4UX26eAWb4YJIhLMe1w9LrFw5WAxhYlEJ/anw/dzG6WecsYWdwLvJt2FQtOPbVrk6qOpsTt+BWrNcY/t+QsGaaj61nLZd2Egf1l6SubweblcQtpNO3BkQNZrjz9M4pgPvuofMrUafpbw+6bnlwV2km6x4LUq2kHW6gR/R2pnAbQDn8HV5eHrBOQ830YmZf0vyVnw2wHlotzCjKH6y9zFB+B75PPoBO90MiEEpmLMWWit++vtiXvtWZcI+y5vgwoxNlMjt4PsuffDkHvTFRy0H0zOuEZgqOFFN2f86JrpG4XGocV4QiE1wzygbqGVXCE17jovndJWSQcBNIvCKADONKPLrlal9IjdxzOuPwJmxAz4+ED1DbNcdZiYMnN64Iz9q267rIiIocAbonyz1GF+4Ap0VeeJii7mdBPAPhYPQUl5PlgxgrPvfr7TBXLyC8IPihUwIT2QPdL8tTqRj7NVgZiMZRZyXJNSi9m8y95hBBDH1kTQ6a+Hx0+b8Ubit4YFUYRmDOOiwN7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(66556008)(6506007)(66476007)(86362001)(38100700002)(52536014)(5660300002)(9686003)(4326008)(66946007)(54906003)(2906002)(38070700005)(33656002)(8676002)(55016002)(64756008)(316002)(71200400001)(7696005)(7416002)(76116006)(6916009)(186003)(122000001)(26005)(8936002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkhmOUFJTG9jYmNMRlBibDMySlVxTUJnNEg1VDdvaGdmTFdHMk1paU9xYmJP?=
 =?utf-8?B?VnpKU0FISVByUjNscStDRjFnaCtVVmY2ZDZFUmE3aU1ZYzV5eGN4cG1IY09r?=
 =?utf-8?B?NU55R1J3QU5FZURKNTluV1pIYmxhOXVqVUc3bGRwcjEyWXM4UnI2NDA5Z05y?=
 =?utf-8?B?Ky92UTZoTGhWWXZkdHB2WDExRXlJajBNMXlHaitibFZrMytDRW0xUklpbmNR?=
 =?utf-8?B?MCt5cGlrUGRIbWt1MURGczVVWVhIak9SQWkwczdlVVJIRDlZaHJxNEpmejhJ?=
 =?utf-8?B?S2lxY0dzekVNSVhLMnlvbDZRM000a3lyNU9TNFdvSmxvUExFT1lKMU4rUUpS?=
 =?utf-8?B?dFZsVGUzUzJ0TGF5ZmJuMWtvMGd1bURvbGtsL3BHSkYxcUtrTDlYeFFpU1Rj?=
 =?utf-8?B?em5EaksxVlhOMGhnM3FQa0tqVnRaZVdoNTlvVXdFZit6RzhhRGxrK2dKMjZJ?=
 =?utf-8?B?SS9mYzN0aFU5eUt3Y1dneGc1aTBGNlk3NkVnZms3RnBUMGlMbUZFRE1DMFVV?=
 =?utf-8?B?Q3NhY01kNHJwdlJxMzdnNXUvWFUxNWJ0Tkw1Ykw5Y0lhSklKeFNWR2FuVkVX?=
 =?utf-8?B?ZFNZUjFVaG96VEp6VWkxbEJKVitIUnlNaENMVk1wMVJobStvc2UrTFBvM3Er?=
 =?utf-8?B?eG1LN3A4STVuNDl5ek90STJZSkdkTmRWY3UxelBoUC9kcHpxbkJXWlh2SXRV?=
 =?utf-8?B?bWEwM2RkWGVBQmplZWRrb3NEZDZidUNhRnkwQjNQVlZyd3hFd3d6WGVJS0lQ?=
 =?utf-8?B?a3owMDg4UDcxYnQ4M1p5elJJQ3pVaWZYSnV4UWpkSG9NdGZKVUxWd3p0cGxD?=
 =?utf-8?B?N3hUeFdZWlNLMmdrMExuMmNsaWphQit1bld5VXRzU0pLRG1rdkplN0VTMlR4?=
 =?utf-8?B?UkFLNTFwYVNhbmJNTHRKejNYd0tVTkpOWDZhNy9sN01FRkNWckFXbjk5WSto?=
 =?utf-8?B?alZEQ1dNODFId2h2QjB4RW9VcjhFWDM2MThONE5Jc1JERUdQb0VqMkhrZjBj?=
 =?utf-8?B?N2xzeVdldkRvSXlmaHV1cTJraEFCT1k2enJKdkNPcld6aEdiVHpTUHFDbVVz?=
 =?utf-8?B?bjh6eUNSNVhpTXFteVVRdURBR1krSlM5ei9Qa2xjUmxZVHpSSGF6UzJ6eTJt?=
 =?utf-8?B?RENjcDg3VUtkU1diRE5SSVNCNjJsVnJYd3ZoN0lmV2t2aUhCSW5lSDNPcUZh?=
 =?utf-8?B?cnlFT0orbEEvY2dRbHFzbytsbmhOaVF1WnFraHNERDJTOGFiMkpic2xub3d2?=
 =?utf-8?B?Q3gxN2g2Tm11Y1cyYk5wN0NGakw4MnhSb25uRnZpcnFaNjA1bGl0M1Q2dUxn?=
 =?utf-8?B?Y2V0Z2s2NzNaYXp1aFJtQXlPYXlYa2d6bHhhK1FhNTBTTHU0NWptNDBJUUNV?=
 =?utf-8?B?VGVrdkh3Z3l0NnRUdGFMc043Wm1ndU4wYURLWGR2RE53US91dW8yWHNwTmxE?=
 =?utf-8?B?R0VHZEtweFhvSVpEZWpTTGZENzc1L0c5QmlkeEpsYU9zOFdHblhMd3l3ZHdp?=
 =?utf-8?B?L0NOOXduTENTTnR1MUxheG9xQUhYNGxMSHdKaFU4bWw1TXFRdFV1U09MZlV2?=
 =?utf-8?B?VHFoRWxRcTlYUG5jYkpPNlJhQmxROEFjQzFlZUhPVTFMMi9jMU1lUXloTFQx?=
 =?utf-8?B?empMTkFqbU4zL05GTm1DRURNU1pSbDZuSVVHVjA3aVovNktUT0phUDVia3NU?=
 =?utf-8?B?a0hrNGVjL0NNdEYyc0IwM05aODNzaHpRT3hTYXZlUDBMMUhRRDIrR1ZGdmVW?=
 =?utf-8?Q?1WQ1W+jofX7OjrN+BAwboJMU+KK360VWAmd1umj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886cd616-b680-4bc7-9064-08d97dd3161d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 14:13:01.1367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cbslez+sPiZvcrA+9FilaK4n0hT8yYtymlhX1FFoG+GSuaXDPfuTo0MM8AwaQFLpf4qbN0gj1NHLpJ6/Af7MuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2339
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUNCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMjIs
IDIwMjEgODo1NSBQTQ0KPiANCj4gT24gV2VkLCBTZXAgMjIsIDIwMjEgYXQgMDM6NDE6NTBBTSAr
MDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpn
Z0BudmlkaWEuY29tPg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMjIsIDIwMjEg
MTo0NyBBTQ0KPiA+ID4NCj4gPiA+IE9uIFN1biwgU2VwIDE5LCAyMDIxIGF0IDAyOjM4OjQwUE0g
KzA4MDAsIExpdSBZaSBMIHdyb3RlOg0KPiA+ID4gPiBBcyBhZm9yZW1lbnRpb25lZCwgdXNlcnNw
YWNlIHNob3VsZCBjaGVjayBleHRlbnNpb24gZm9yIHdoYXQgZm9ybWF0cw0KPiA+ID4gPiBjYW4g
YmUgc3BlY2lmaWVkIHdoZW4gYWxsb2NhdGluZyBhbiBJT0FTSUQuIFRoaXMgcGF0Y2ggYWRkcyBz
dWNoDQo+ID4gPiA+IGludGVyZmFjZSBmb3IgdXNlcnNwYWNlLiBJbiB0aGlzIFJGQywgaW9tbXVm
ZCByZXBvcnRzDQo+IEVYVF9NQVBfVFlQRTFWMg0KPiA+ID4gPiBzdXBwb3J0IGFuZCBubyBuby1z
bm9vcCBzdXBwb3J0IHlldC4NCj4gPiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlp
IEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+ID4gIGRyaXZlcnMvaW9tbXUvaW9tbXVmZC9p
b21tdWZkLmMgfCAgNyArKysrKysrDQo+ID4gPiA+ICBpbmNsdWRlL3VhcGkvbGludXgvaW9tbXUu
aCAgICAgIHwgMjcgKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gPiA+ICAyIGZpbGVz
IGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKykNCj4gPiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvaW9tbXUvaW9tbXVmZC9pb21tdWZkLmMNCj4gPiA+IGIvZHJpdmVycy9pb21tdS9p
b21tdWZkL2lvbW11ZmQuYw0KPiA+ID4gPiBpbmRleCA0ODM5ZjEyOGIyNGEuLmU0NWQ3NjM1OWUz
NCAxMDA2NDQNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9pb21tdS9pb21tdWZkL2lvbW11ZmQuYw0K
PiA+ID4gPiBAQCAtMzA2LDYgKzMwNiwxMyBAQCBzdGF0aWMgbG9uZyBpb21tdWZkX2ZvcHNfdW5s
X2lvY3RsKHN0cnVjdCBmaWxlDQo+ID4gPiAqZmlsZXAsDQo+ID4gPiA+ICAJCXJldHVybiByZXQ7
DQo+ID4gPiA+DQo+ID4gPiA+ICAJc3dpdGNoIChjbWQpIHsNCj4gPiA+ID4gKwljYXNlIElPTU1V
X0NIRUNLX0VYVEVOU0lPTjoNCj4gPiA+ID4gKwkJc3dpdGNoIChhcmcpIHsNCj4gPiA+ID4gKwkJ
Y2FzZSBFWFRfTUFQX1RZUEUxVjI6DQo+ID4gPiA+ICsJCQlyZXR1cm4gMTsNCj4gPiA+ID4gKwkJ
ZGVmYXVsdDoNCj4gPiA+ID4gKwkJCXJldHVybiAwOw0KPiA+ID4gPiArCQl9DQo+ID4gPiA+ICAJ
Y2FzZSBJT01NVV9ERVZJQ0VfR0VUX0lORk86DQo+ID4gPiA+ICAJCXJldCA9IGlvbW11ZmRfZ2V0
X2RldmljZV9pbmZvKGljdHgsIGFyZyk7DQo+ID4gPiA+ICAJCWJyZWFrOw0KPiA+ID4gPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2lvbW11LmggYi9pbmNsdWRlL3VhcGkvbGludXgv
aW9tbXUuaA0KPiA+ID4gPiBpbmRleCA1Y2JkMzAwZWIwZWUuLjQ5NzMxYmU3MTIxMyAxMDA2NDQN
Cj4gPiA+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lvbW11LmgNCj4gPiA+ID4gQEAgLTE0
LDYgKzE0LDMzIEBADQo+ID4gPiA+ICAjZGVmaW5lIElPTU1VX1RZUEUJKCc7JykNCj4gPiA+ID4g
ICNkZWZpbmUgSU9NTVVfQkFTRQkxMDANCj4gPiA+ID4NCj4gPiA+ID4gKy8qDQo+ID4gPiA+ICsg
KiBJT01NVV9DSEVDS19FWFRFTlNJT04gLSBfSU8oSU9NTVVfVFlQRSwgSU9NTVVfQkFTRSArIDAp
DQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICogQ2hlY2sgd2hldGhlciBhbiB1QVBJIGV4dGVuc2lv
biBpcyBzdXBwb3J0ZWQuDQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICogSXQncyB1bmxpa2VseSB0
aGF0IGFsbCBwbGFubmVkIGNhcGFiaWxpdGllcyBpbiBJT01NVSBmZCB3aWxsIGJlIHJlYWR5DQo+
ID4gPiA+ICsgKiBpbiBvbmUgYnJlYXRoLiBVc2VyIHNob3VsZCBjaGVjayB3aGljaCB1QVBJIGV4
dGVuc2lvbiBpcyBzdXBwb3J0ZWQNCj4gPiA+ID4gKyAqIGFjY29yZGluZyB0byBpdHMgaW50ZW5k
ZWQgdXNhZ2UuDQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICogQSByb3VnaCBsaXN0IG9mIHBvc3Np
YmxlIGV4dGVuc2lvbnMgbWF5IGluY2x1ZGU6DQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICoJLSBF
WFRfTUFQX1RZUEUxVjIgZm9yIHZmaW8gdHlwZTF2MiBtYXAgc2VtYW50aWNzOw0KPiA+ID4gPiAr
ICoJLSBFWFRfRE1BX05PX1NOT09QIGZvciBuby1zbm9vcCBETUEgc3VwcG9ydDsNCj4gPiA+ID4g
KyAqCS0gRVhUX01BUF9ORVdUWVBFIGZvciBhbiBlbmhhbmNlZCBtYXAgc2VtYW50aWNzOw0KPiA+
ID4gPiArICoJLSBFWFRfTVVMVElERVZfR1JPVVAgZm9yIDE6TiBpb21tdSBncm91cDsNCj4gPiA+
ID4gKyAqCS0gRVhUX0lPQVNJRF9ORVNUSU5HIGZvciB3aGF0IHRoZSBuYW1lIHN0YW5kczsNCj4g
PiA+ID4gKyAqCS0gRVhUX1VTRVJfUEFHRV9UQUJMRSBmb3IgdXNlciBtYW5hZ2VkIHBhZ2UgdGFi
bGU7DQo+ID4gPiA+ICsgKgktIEVYVF9VU0VSX1BBU0lEX1RBQkxFIGZvciB1c2VyIG1hbmFnZWQg
UEFTSUQgdGFibGU7DQo+ID4gPiA+ICsgKgktIEVYVF9ESVJUWV9UUkFDS0lORyBmb3IgdHJhY2tp
bmcgcGFnZXMgZGlydGllZCBieSBETUE7DQo+ID4gPiA+ICsgKgktIC4uLg0KPiA+ID4gPiArICoN
Cj4gPiA+ID4gKyAqIFJldHVybjogMCBpZiBub3Qgc3VwcG9ydGVkLCAxIGlmIHN1cHBvcnRlZC4N
Cj4gPiA+ID4gKyAqLw0KPiA+ID4gPiArI2RlZmluZSBFWFRfTUFQX1RZUEUxVjIJCTENCj4gPiA+
ID4gKyNkZWZpbmUgRVhUX0RNQV9OT19TTk9PUAkyDQo+ID4gPiA+ICsjZGVmaW5lIElPTU1VX0NI
RUNLX0VYVEVOU0lPTglfSU8oSU9NTVVfVFlQRSwNCj4gPiA+IElPTU1VX0JBU0UgKyAwKQ0KPiA+
ID4NCj4gPiA+IEkgZ2VuZXJhbGx5IGFkdm9jYXRlIGZvciBhICd0cnkgYW5kIGZhaWwnIGFwcHJv
YWNoIHRvIGRpc2NvdmVyaW5nDQo+ID4gPiBjb21wYXRpYmlsaXR5Lg0KPiA+ID4NCj4gPiA+IElm
IHRoYXQgZG9lc24ndCB3b3JrIGZvciB0aGUgdXNlcnNwYWNlIHRoZW4gYSBxdWVyeSB0byByZXR1
cm4gYQ0KPiA+ID4gZ2VuZXJpYyBjYXBhYmlsaXR5IGZsYWcgaXMgdGhlIG5leHQgYmVzdCBpZGVh
LiBFYWNoIGZsYWcgc2hvdWxkDQo+ID4gPiBjbGVhcmx5IGRlZmluZSB3aGF0ICd0cnkgYW5kIGZh
aWwnIGl0IGlzIHRhbGtpbmcgYWJvdXQNCj4gPg0KPiA+IFdlIGRvbid0IGhhdmUgc3Ryb25nIHBy
ZWZlcmVuY2UgaGVyZS4gSnVzdCBmb2xsb3cgd2hhdCB2ZmlvIGRvZXMNCj4gPiB0b2RheS4gU28g
QWxleCdzIG9waW5pb24gaXMgYXBwcmVjaWF0ZWQgaGVyZS4g8J+Yig0KPiANCj4gVGhpcyBpcyBh
IHVBUEkgZGVzaWduLCBpdCBzaG91bGQgZm9sbG93IHRoZSBjdXJyZW50IG1haW5zdHJlYW0NCj4g
dGhpbmtpbmcgb24gaG93IHRvIGJ1aWxkIHRoZXNlIHRoaW5ncy4gVGhlcmUgaXMgYSBsb3Qgb2Yg
b2xkIHN0dWZmIGluDQo+IHZmaW8gdGhhdCBkb2Vzbid0IG1hdGNoIHRoZSBtb2Rlcm4gdGhpbmtp
bmcuIElNSE8uDQo+IA0KPiA+ID4gVFlQRTFWMiBzZWVtcyBsaWtlIG5vbnNlbnNlDQo+ID4NCj4g
PiBqdXN0IGluIGNhc2Ugb3RoZXIgbWFwcGluZyBwcm90b2NvbHMgYXJlIGludHJvZHVjZWQgaW4g
dGhlIGZ1dHVyZQ0KPiANCj4gV2VsbCwgd2Ugc2hvdWxkIG5ldmVyLCBldmVyIGRvIHRoYXQuIEFs
bG93aW5nIFBQQyBhbmQgZXZyeXRoaW5nIGVsc2UNCj4gdG8gc3BsaXQgaW4gVkZJTyBoYXMgY3Jl
YXRlZCBhIGNvbXBlbHRlIGRpc2FzdGVyIGluIHVzZXJzcGFjZS4gSFcNCj4gc3BlY2lmaWMgZXh0
ZW5zaW9ucyBzaG91bGQgYmUgbW9kZWxlZCBhcyBleHRlbnNpb25zIG5vdCBhIHdob2xlc2FsZQ0K
PiByZXBsYWNlbWVudCBvZiBldmVyeXRoaW5nLg0KPiANCj4gSSdkIHNheSB0aGlzIGlzIHBhcnQg
b2YgdGhlIG1vZGVybiB0aGlua2luZyBvbiB1QVBJIGRlc2lnbi4NCj4gDQo+IFdoYXQgSSB3YW50
IHRvIHN0cml2ZSBmb3IgaXMgdGhlIGJhc2ljIEFQSSBpcyB1c2FibGUgd2l0aCBhbGwgSFcgLSBh
bmQNCj4gaXMgd2hhdCBzb21ldGhpbmcgbGlrZSBEUERLIGNhbiBleGNsdXNpdmVseSB1c2UuDQo+
IA0KPiBBbiBleHRlbmRlZCBBUEkgd2l0aCBIVyBzcGVjaWZpYyBmYWNldHMgZXhpc3RzIGZvciBx
ZW11IHRvIHVzZSB0bw0KPiBidWlsZCBhIEhXIGJhY2tlZCBhY2NlbGVyZWF0ZWQgYW5kIGZlYXR1
cmVmdWwgdklPTU1VIGVtdWxhdGlvbi4NCj4gDQo+IFRoZSBuZWVkcyBvZiBxbWV1IHNob3VsZCBu
b3QgdHJ1bXAgdGhlIHJlcXVpcmVtZW50IGZvciBhIHVuaXZlcnNhbA0KPiBiYXNpYyBBUEkuDQo+
IA0KPiBFZyBpZiB3ZSBjYW4ndCBmaWd1cmUgb3V0IGEgYmFzaWMgQVBJIHZlcnNpb24gb2YgdGhl
IFBQQyByYW5nZSBpc3N1ZQ0KPiB0aGVuIHRoYXQgc2hvdWxkIGJlIHB1bnRlZCB0byBhIFBQQyBz
cGVjaWZpYyBBUEkuDQo+IA0KDQpzb3VuZHMgZ29vZC4gSSBtYXkga2VlcCBhbiB3cm9uZyBtZW1v
cnkgb24gdGhlIG11bHRpcGxlIG1hcHBpbmcNCnByb3RvY29scyB0aGluZy4g8J+Yig0K
