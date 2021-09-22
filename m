Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF3C414022
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 05:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhIVDnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 23:43:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:35149 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 23:43:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="245945351"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="245945351"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 20:41:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="557201862"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga002.fm.intel.com with ESMTP; 21 Sep 2021 20:41:53 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:41:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 20:41:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 20:41:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIrhWungrSu9J3AdNsgE2Cr07ZIjB0DrNlMfkodxSasm0M4QXxUsi8Ic36b7Glx0QBsk8te/EiUlk6FCMWLpwJgLdcS6YMEpyqY1GLXHsJRC7q9ay6SIhAjZ6OPJE8S1MQG+oYcr2FlPghNAkYyzKO+8Mynk0kpuehgf/OB1QaGXjZAfOHu4xuiEbEMUKtF8HKtMpcSdtaYglUiDghp5crapjOkHbATXbRj3WqMAC/4+arOqaw1QF+xLrZOh2/+SQh4uNz0SOgfEKLYekkyubnI6QEfblVRXizEtmFfncmdnosCpr7/habd6hIYCFM23eSR7vGWrJ3FtUfQebzJF/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nMxi9dQOOQm2Cxwuqa9O1X3cnUiYFGIwglBVpWA/x7Y=;
 b=j1YThmyK+OzDK/qPF0YCn06a3mdD369ZpovVJZOHS+wK9ZhkPiXxgyPIE8nkXlhE8utPoJor2mbcPqhvcbqb5UIOsYp2oJASRk6A3DoCfYiQeQgyjhqma0sL1mCncwUMwYKmDTAoZChY/BsC5/nlCwndAF4uC2DLBw+Pd1wIHFoFCS7rs9MIt6hhN91UVd07YKX6A9aUwr4tn3x0sM2oZzVJEjnLhC3AbTHXqP1UTmve9roV8yFoU/wMK2fHDqzFOpdZo3kiqIn46bmMAAmxZvrP04b9hVvPIlzcDW9KyWNTngSOtIaugnG6n0J7BgN1+JA22NfTpEZO3qYwgVrPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMxi9dQOOQm2Cxwuqa9O1X3cnUiYFGIwglBVpWA/x7Y=;
 b=hdwXpF2d+kliLe+e66N+ezjw33VF9P2eIhzMFB9PwWbBJs01Tb+S49Eug0qORWl9azqJ/SthGA97h8KgL6tQWyDkukZeExQEbKY1pkx1hz8ovE57coHDiugNc3RcZ6MyDmhA9tgClvRdlDiGnjqewwhSnvThFHfZhZ+Cov8pYoE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2756.namprd11.prod.outlook.com (2603:10b6:406:b4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 03:41:50 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:41:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 12/20] iommu/iommufd: Add IOMMU_CHECK_EXTENSION
Thread-Topic: [RFC 12/20] iommu/iommufd: Add IOMMU_CHECK_EXTENSION
Thread-Index: AQHXrSGTBKS/Pyh9FkOu0zPObIcIUquuxyWAgAClzVA=
Date:   Wed, 22 Sep 2021 03:41:50 +0000
Message-ID: <BN9PR11MB54334A552C3E606F4394EF298CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-13-yi.l.liu@intel.com>
 <20210921174711.GX327412@nvidia.com>
In-Reply-To: <20210921174711.GX327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b43a5f0-42f4-490a-d3d1-08d97d7ae97f
x-ms-traffictypediagnostic: BN7PR11MB2756:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB27569BFF6DA62506005762778CA29@BN7PR11MB2756.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2/XHAegkFBDUZkX6M16L1P7up+zyjTgVLPvV5QgWcELUy30sooM1VY92MEMeJP8HWNKPAEHznBAwbPUgchwgO3PRbJRBSR6XgXnt/kqBCm6oJNFXGLMgdVhE0xdROVP60hXLohR/ecQzRKMKYMkAutKt0hZRMipaNmYZPeWa5ShynUbNfLlT58f5SoLvNh6VrSyBqZ7cUYzelaficerVEVRiZMH8pJP240G1eKEu37sC8CXTvX7QKLEVqCDUeRN//p8bLc2dA9E23ZeEC3M3eL6Haz5iGN4ZAALZdxp1kbQtsVdDN1rae+E8+Rr2+G5fQvJo9tSvvFBREaQ80rSpDfYTHTZ6FW6T3pFfFso+ke5E6hkySYCbGa33cNpT4E44qk96s9zYVLRix2jyooHR/zq4mRqvCEGd2LRS4ZaBo/Eh8G8BQjd8fsXELzUmGio303GqyP/ibIUqqidLK8WADCT2WFm2TS3d8nXPcCL4tcIS1vBHZLWyDEy0eqRH3HD91GgcWZ2j6/UCX/LPUJfywxs1rS5fxYv2ceEXRsqwnwzhHtRRw7Vdi6oi9OGjiaVb6T7i98ShXFT9en/8J7+/qv2SvRwtAny+5d0bY36HaQF5q12J6EEavaHuVuePTOVUED978q8V2WUi6ZJEp8t7XgqY12KBCSR8k4vA2UmTcGPCnC29GE6h+u/bUVLI9anlZU9+Nyst+U78VP/abjf05Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(8936002)(5660300002)(6506007)(122000001)(26005)(7416002)(8676002)(186003)(38100700002)(316002)(110136005)(2906002)(64756008)(66476007)(66556008)(66446008)(7696005)(66946007)(76116006)(38070700005)(71200400001)(4326008)(6636002)(508600001)(54906003)(86362001)(33656002)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDl0Unlmbi84dVFmbmNCazF5dkZjR1pMRmZFNGlmekZSS3g3bHUwRjJ6Z0x3?=
 =?utf-8?B?SjQ1MTBGWVhYQzRRZG5WaXpwMVpPS1V4WFM2RzJjb3ZIZGRSNnNvbWxqdGhs?=
 =?utf-8?B?eFRNZ0FIWVZBektxbTZDUUNmRktXZSs5VWVRRFk1ZHBWMXAxdWxtQ0FSclFK?=
 =?utf-8?B?b3JhTUJjd3JndmVmZ2xnNERhci9XMnVFUkN0dUdRRzZlMS9LUm02MWFoLzVZ?=
 =?utf-8?B?QkdCVmtON1hIVFBvT2I5Wm5DWTVTbTRvdTBBL0pMR1FBU0RPa1YxRGFjVGs5?=
 =?utf-8?B?NnJpWGxCZWhrcGFaTzFmTEtZWGg5OHpBbkt6UXNrMTFQZExNZEt5Mms2N2xT?=
 =?utf-8?B?NlVQL1V5TC80Z29RWVdPclRMNjYxeGZZOGpTYkRGUXUrTUdwMmMzaGpIeFRl?=
 =?utf-8?B?dXpid1M0YXUxeE83NnJHWlNtMGZDV0tHV01IV3B6YmtESFB5YXJ4eUhHaFdH?=
 =?utf-8?B?RllhUEtDeEdsQXhiUVFFc01nbTlmSjdoSFhlSEpKaVpyUHVjaUNhSDBOQ2hw?=
 =?utf-8?B?UE9aYmVDVFFvZXR4NjVtVmhyNWtaejJTU3RxOTk3TU42QW9WdWgveVhWUWNC?=
 =?utf-8?B?ZGQycVFpL3Qxc1FFT1p0K3FTaFdXTzRUN3FMS2ZFNENTeTVzcGJWUU1hMFEw?=
 =?utf-8?B?M1ZPeW1neTNiQ0RiTjlIbEIyeXMxOTlOZlNBTTFEQlFHYjdBeHA2T0QzWmN6?=
 =?utf-8?B?bUtMdW1XVVdhMThqZ2ptVXZWOVdhalFPcXZpS1IvanRrOGdDY1lWcWtORjZB?=
 =?utf-8?B?QWFSQnJFSTVBUWJ1N2NyTkt5VW1Femh6dVZCZkx4NFZscjhKNHlrZG5yOFVM?=
 =?utf-8?B?czNVeUVzemM0S09sUjl0N2NSVllodnZEU3ZhTm04bkxnYkwvTDdlMXcvbGVr?=
 =?utf-8?B?dGJzM1owbUcvWUhsNnFvbFdyQ0V2OFV6V0dQUE9oTTd4NXg1aDZyZDVFeU04?=
 =?utf-8?B?MXpON2UwWk41VDhmTHhvUEdkdzRMNU1HaHNLelhmRmorQ3pPU09waDNWS3k5?=
 =?utf-8?B?eFAxSjN2aVR5N1h5TXB5QnlsNXNNTGl0MzNreGFWM2pmS0xFRDBOQTB1T1Zv?=
 =?utf-8?B?SERiN1krRTFwMW82M0lBMFcwWis4Ui9uaTRBelJCa1EwREJIY1dQQWFGdFNT?=
 =?utf-8?B?YVRCc2ZEOUdFMTFyd0NhWCs5RlRCSk01T2pBTTg0c3YybW5QYlNYa3BXYWJk?=
 =?utf-8?B?UzhDc3d0VGYyb2liZWxCYlkwT2VXSXR5S0VxZGtrdnNIM21tNDU1dzVLOVpT?=
 =?utf-8?B?QzlBNFFzVE9zK0ZQVFlHR0d0Y3lTYTgwZytqL3VmWWVJUHF0Z0F1UUx1dzF5?=
 =?utf-8?B?T1ptVkdhVHdBMit0YjVwUmc3QXdQVFQ1OGZaUEllZVVJTktSM3U3YnR0MDhE?=
 =?utf-8?B?b1AvK1ZnVnpOL2tIMGcxRWhDRHpjNmJDYTJFRkVPSFpXSk1sMUU5eEc5SFQr?=
 =?utf-8?B?ZUpRby9jaGFGYzFTTFNsd1FUZU1sOFNWay9HVldOQlowZ2xqU1RqdHp4Rm92?=
 =?utf-8?B?eHk0OXZjWEc5TkFscU1OQ0FBN1R3UDZxVUxZcWRFenlHaUxpbUtjbkd4aE01?=
 =?utf-8?B?TkV0aTU1SXFYOUtud2hySDM1aUd1QVREUDJoQVBUbjBRTDBlbzYxZjB4YjJS?=
 =?utf-8?B?R3BZQjhxOXJZbmorWmpMRzdvdFQ4T2VXMy9FYllRUGdaQW5tNE1UNkdtRUNR?=
 =?utf-8?B?MFYvNnpNT3JPNnJyMWFRZ1QwZlA0UlBYdjR2RWViZDhGbTAyRDcvcnR1TTNj?=
 =?utf-8?Q?9fbf754M22mv8o4FXz4m+FDFvN4Z036WRko0qGc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b43a5f0-42f4-490a-d3d1-08d97d7ae97f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 03:41:50.4431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ntEYe7k0nxXSv2L/CbOBjlwN9GS4C4s9qzQbmRue9uinzkdgQvmdS/WNfsmw7W/tMFes6ukuk1xfoBsqMwLmHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2756
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIFNlcHRlbWJlciAyMiwgMjAyMSAxOjQ3IEFNDQo+IA0KPiBPbiBTdW4sIFNlcCAxOSwgMjAy
MSBhdCAwMjozODo0MFBNICswODAwLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBBcyBhZm9yZW1lbnRp
b25lZCwgdXNlcnNwYWNlIHNob3VsZCBjaGVjayBleHRlbnNpb24gZm9yIHdoYXQgZm9ybWF0cw0K
PiA+IGNhbiBiZSBzcGVjaWZpZWQgd2hlbiBhbGxvY2F0aW5nIGFuIElPQVNJRC4gVGhpcyBwYXRj
aCBhZGRzIHN1Y2gNCj4gPiBpbnRlcmZhY2UgZm9yIHVzZXJzcGFjZS4gSW4gdGhpcyBSRkMsIGlv
bW11ZmQgcmVwb3J0cyBFWFRfTUFQX1RZUEUxVjINCj4gPiBzdXBwb3J0IGFuZCBubyBuby1zbm9v
cCBzdXBwb3J0IHlldC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxp
dUBpbnRlbC5jb20+DQo+ID4gIGRyaXZlcnMvaW9tbXUvaW9tbXVmZC9pb21tdWZkLmMgfCAgNyAr
KysrKysrDQo+ID4gIGluY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oICAgICAgfCAyNyArKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAzNCBpbnNlcnRpb25z
KCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pb21tdWZkL2lvbW11ZmQu
Yw0KPiBiL2RyaXZlcnMvaW9tbXUvaW9tbXVmZC9pb21tdWZkLmMNCj4gPiBpbmRleCA0ODM5ZjEy
OGIyNGEuLmU0NWQ3NjM1OWUzNCAxMDA2NDQNCj4gPiArKysgYi9kcml2ZXJzL2lvbW11L2lvbW11
ZmQvaW9tbXVmZC5jDQo+ID4gQEAgLTMwNiw2ICszMDYsMTMgQEAgc3RhdGljIGxvbmcgaW9tbXVm
ZF9mb3BzX3VubF9pb2N0bChzdHJ1Y3QgZmlsZQ0KPiAqZmlsZXAsDQo+ID4gIAkJcmV0dXJuIHJl
dDsNCj4gPg0KPiA+ICAJc3dpdGNoIChjbWQpIHsNCj4gPiArCWNhc2UgSU9NTVVfQ0hFQ0tfRVhU
RU5TSU9OOg0KPiA+ICsJCXN3aXRjaCAoYXJnKSB7DQo+ID4gKwkJY2FzZSBFWFRfTUFQX1RZUEUx
VjI6DQo+ID4gKwkJCXJldHVybiAxOw0KPiA+ICsJCWRlZmF1bHQ6DQo+ID4gKwkJCXJldHVybiAw
Ow0KPiA+ICsJCX0NCj4gPiAgCWNhc2UgSU9NTVVfREVWSUNFX0dFVF9JTkZPOg0KPiA+ICAJCXJl
dCA9IGlvbW11ZmRfZ2V0X2RldmljZV9pbmZvKGljdHgsIGFyZyk7DQo+ID4gIAkJYnJlYWs7DQo+
ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2lvbW11LmgNCj4gPiBpbmRleCA1Y2JkMzAwZWIwZWUuLjQ5NzMxYmU3MTIxMyAxMDA2
NDQNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvaW9tbXUuaA0KPiA+IEBAIC0xNCw2ICsx
NCwzMyBAQA0KPiA+ICAjZGVmaW5lIElPTU1VX1RZUEUJKCc7JykNCj4gPiAgI2RlZmluZSBJT01N
VV9CQVNFCTEwMA0KPiA+DQo+ID4gKy8qDQo+ID4gKyAqIElPTU1VX0NIRUNLX0VYVEVOU0lPTiAt
IF9JTyhJT01NVV9UWVBFLCBJT01NVV9CQVNFICsgMCkNCj4gPiArICoNCj4gPiArICogQ2hlY2sg
d2hldGhlciBhbiB1QVBJIGV4dGVuc2lvbiBpcyBzdXBwb3J0ZWQuDQo+ID4gKyAqDQo+ID4gKyAq
IEl0J3MgdW5saWtlbHkgdGhhdCBhbGwgcGxhbm5lZCBjYXBhYmlsaXRpZXMgaW4gSU9NTVUgZmQg
d2lsbCBiZSByZWFkeQ0KPiA+ICsgKiBpbiBvbmUgYnJlYXRoLiBVc2VyIHNob3VsZCBjaGVjayB3
aGljaCB1QVBJIGV4dGVuc2lvbiBpcyBzdXBwb3J0ZWQNCj4gPiArICogYWNjb3JkaW5nIHRvIGl0
cyBpbnRlbmRlZCB1c2FnZS4NCj4gPiArICoNCj4gPiArICogQSByb3VnaCBsaXN0IG9mIHBvc3Np
YmxlIGV4dGVuc2lvbnMgbWF5IGluY2x1ZGU6DQo+ID4gKyAqDQo+ID4gKyAqCS0gRVhUX01BUF9U
WVBFMVYyIGZvciB2ZmlvIHR5cGUxdjIgbWFwIHNlbWFudGljczsNCj4gPiArICoJLSBFWFRfRE1B
X05PX1NOT09QIGZvciBuby1zbm9vcCBETUEgc3VwcG9ydDsNCj4gPiArICoJLSBFWFRfTUFQX05F
V1RZUEUgZm9yIGFuIGVuaGFuY2VkIG1hcCBzZW1hbnRpY3M7DQo+ID4gKyAqCS0gRVhUX01VTFRJ
REVWX0dST1VQIGZvciAxOk4gaW9tbXUgZ3JvdXA7DQo+ID4gKyAqCS0gRVhUX0lPQVNJRF9ORVNU
SU5HIGZvciB3aGF0IHRoZSBuYW1lIHN0YW5kczsNCj4gPiArICoJLSBFWFRfVVNFUl9QQUdFX1RB
QkxFIGZvciB1c2VyIG1hbmFnZWQgcGFnZSB0YWJsZTsNCj4gPiArICoJLSBFWFRfVVNFUl9QQVNJ
RF9UQUJMRSBmb3IgdXNlciBtYW5hZ2VkIFBBU0lEIHRhYmxlOw0KPiA+ICsgKgktIEVYVF9ESVJU
WV9UUkFDS0lORyBmb3IgdHJhY2tpbmcgcGFnZXMgZGlydGllZCBieSBETUE7DQo+ID4gKyAqCS0g
Li4uDQo+ID4gKyAqDQo+ID4gKyAqIFJldHVybjogMCBpZiBub3Qgc3VwcG9ydGVkLCAxIGlmIHN1
cHBvcnRlZC4NCj4gPiArICovDQo+ID4gKyNkZWZpbmUgRVhUX01BUF9UWVBFMVYyCQkxDQo+ID4g
KyNkZWZpbmUgRVhUX0RNQV9OT19TTk9PUAkyDQo+ID4gKyNkZWZpbmUgSU9NTVVfQ0hFQ0tfRVhU
RU5TSU9OCV9JTyhJT01NVV9UWVBFLA0KPiBJT01NVV9CQVNFICsgMCkNCj4gDQo+IEkgZ2VuZXJh
bGx5IGFkdm9jYXRlIGZvciBhICd0cnkgYW5kIGZhaWwnIGFwcHJvYWNoIHRvIGRpc2NvdmVyaW5n
DQo+IGNvbXBhdGliaWxpdHkuDQo+IA0KPiBJZiB0aGF0IGRvZXNuJ3Qgd29yayBmb3IgdGhlIHVz
ZXJzcGFjZSB0aGVuIGEgcXVlcnkgdG8gcmV0dXJuIGENCj4gZ2VuZXJpYyBjYXBhYmlsaXR5IGZs
YWcgaXMgdGhlIG5leHQgYmVzdCBpZGVhLiBFYWNoIGZsYWcgc2hvdWxkDQo+IGNsZWFybHkgZGVm
aW5lIHdoYXQgJ3RyeSBhbmQgZmFpbCcgaXQgaXMgdGFsa2luZyBhYm91dA0KDQpXZSBkb24ndCBo
YXZlIHN0cm9uZyBwcmVmZXJlbmNlIGhlcmUuIEp1c3QgZm9sbG93IHdoYXQgdmZpbyBkb2VzDQp0
b2RheS4gU28gQWxleCdzIG9waW5pb24gaXMgYXBwcmVjaWF0ZWQgaGVyZS4g8J+Yig0KDQo+IA0K
PiBFZyBkbWFfbm9fc25vb3AgaXMgYWJvdXQgY3JlYXRpbmcgYW4gSU9TIHdpdGggZmxhZyBOTyBT
Tk9PUCBzZXQNCj4gDQo+IFRZUEUxVjIgc2VlbXMgbGlrZSBub25zZW5zZQ0KDQpqdXN0IGluIGNh
c2Ugb3RoZXIgbWFwcGluZyBwcm90b2NvbHMgYXJlIGludHJvZHVjZWQgaW4gdGhlIGZ1dHVyZQ0K
DQo+IA0KPiBOb3Qgc3VyZSBhYm91dCB0aGUgb3RoZXJzLg0KPiANCj4gSU9XLCB0aGlzIHNob3Vs
ZCByZWNhc3QgdG8gYSBnZW5lcmljICdxdWVyeSBjYXBhYmlsaXRpZXMnIElPQ1RMDQo+IA0KPiBK
YXNvbg0K
