Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5370C4194CD
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 15:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhI0NKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 09:10:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:27001 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234520AbhI0NKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 09:10:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10119"; a="222578985"
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="222578985"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 06:08:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="518586569"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 27 Sep 2021 06:08:38 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 06:08:37 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 06:08:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 27 Sep 2021 06:08:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 27 Sep 2021 06:08:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLvix16nIpzLowJGEFWIJc6PssAM7Pzy5r/EdrCnIf0NirhkCMB5OzGVwf8/EyKLGinIvSpTE4SDM6YmeNiQTYk7uK3tKPvhLRU6dGFd3BsF0WGRYPojHmD7kjC+Fy3Mb+seI3oFj8krI+Ppb/K79RFC2kvzfayh9ZHwxLzJfyD+3qZ1wekZh3h8V2eCBiRredaOU/1J7KQ9V/OLPjXTCop1Lo7TD/nhxzpGn2nSRzOXKK4WiFN5fWjrBDIi9RrJrN7Y/Bz+mX1QPLvZAeSW+N4Dnr7vmRBDGATrIpp7VSBonRqRX4Xild5dcagjEZngNVNAv/ci7lLhZFxQ5mdxeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+N4+yJyK9YZXBpbT7hrrDR3tJo+ZXRFz8eHw3BYlUs4=;
 b=apH+w//Ul/jWo5DJPJoSekVriWOhLr/oaeLrckxpDfL2UOpIfjj7YdWvN8tc7EsiMzqd8YHN1fuYiDQsftg6690JS+X1rPMwsoi47Itsq1Q/FeZNWBdbZZQjd+dA0L7CB79pDlpYEopc9A3F8VKMUX5VycSE9g0Bwx9rE1/CV+jY/V62r/YGFRC6NHFNR2C1U9NqkfaPAk3+yJbv4ku9VvyXCxglfiTZlPEtCppN9fz1Ay9elCYxy6q2EUD1zVEpxKLTD5PingJ2FLLKxM9WvD+VUMSuefrUe0W7kjkhj7TjeiQrd4tdaF8F4e4Kc/645ArFS/6SrDVzp6hgpXgMYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+N4+yJyK9YZXBpbT7hrrDR3tJo+ZXRFz8eHw3BYlUs4=;
 b=Il/CfoMD6BYxx9abdrwl+uMoDoT96CcFQC84QnF4glMrF9tLkpRQziXaQpq0mKDcKVN8Fp4VD6Ni/pS607eGKo+zQT6276Bc/zl1CuWZgi67qvsM1uklmtLCyCEA3LWqHmywA0G247cei29lgiq9ZKRVp8AzrlnZaayIUsf7p8k=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5530.namprd11.prod.outlook.com (2603:10b6:408:103::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 13:08:35 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 13:08:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgABoDQCAABnt8A==
Date:   Mon, 27 Sep 2021 13:08:35 +0000
Message-ID: <BN9PR11MB543382131F4D3E9489766C698CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <4625393e-6203-2319-9c9f-9f35beb1c04a@linux.intel.com>
In-Reply-To: <4625393e-6203-2319-9c9f-9f35beb1c04a@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e587e461-1465-40fc-1a93-08d981b7e9d2
x-ms-traffictypediagnostic: BN9PR11MB5530:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB5530FD6ED3EDCDDD623FB2FD8CA79@BN9PR11MB5530.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ir3o8frgFc2AELXQ8VMU7qw671bmsKiZgdu8NtrdiIrNGv0f3axQz0K8bGQW5JD6FxST08vMbPVli4JQtrEWnWh7V8XJ97oo4aAYvGJueVexxhVQcoCHkVy2fHB7uvNukKUg+RKsRKb9kB5lQL1XaEN/YNjfI7YDCXJQn0xZR1UbhOo1sYO1WIqs/RFuCCV7mR2hv2Es3Up5CarNEd4EYXxB8xWh5DHbNeKRjFGgr0cmAuBhXsFSJLGQ7jJokcNwvyn0BakwxivGBRruHbddYVs6Vv7btY0f4IYl7CVi94IMNVkIymxOoh90BkHKVof6h05kX4wYo2jr8yBoevPFGXn4sPU5cphUAMrEPoDbZAKgntKXYx8vEMhSBJ65OynNAwcBplQT88c8Kj3XYMP7NIkr422s6McuIuFZCb6K8aVaYP0ha2rev2SkeMnVP7BI9YeBNvxYWxqGHF44lWZp1Kgm21CiRK5DxjvLIiiXpZmJWMEoDvLyovjs2v3/8wwU0nVuUzRfOFw66zBzNVyKg6bvuswAIBGZufr91fLqI0BhI/5HzGdGuNr05bLG3qhB0uvXsW0woGYZBMAkqqIhJAGkMdWj/xT0TCmAQzb6mHfVIPukTfsJeOvzwCmAs2fJ329R86dLD53C07gMNpwCNNR3fU9MWAsdV0RHMITatMvPk2o0BpheGbXOLtx2BqVqa5I7Kpb/Z+xpZOgAo6zWtA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(54906003)(8936002)(110136005)(7416002)(55016002)(8676002)(4744005)(508600001)(9686003)(316002)(38100700002)(122000001)(64756008)(186003)(5660300002)(71200400001)(86362001)(66446008)(66556008)(7696005)(66946007)(38070700005)(4326008)(52536014)(26005)(83380400001)(33656002)(66476007)(6506007)(53546011)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emNDYWZFY0paeWZRQmZHZktIZkczRUduSWl4T3JQaDU1MkE1dHR2VzZoVjZW?=
 =?utf-8?B?RnkzZkMwVkpvT2FXcW14S25mQVRWbmxhaTlqOU1rVWs1TU5WWGhSMkE0M3Vz?=
 =?utf-8?B?bG1QQjBPOWxTVUNzM1RBWFVORWsxeEpQaFRtclU5RFpLTjZMQy9DOGRESTNI?=
 =?utf-8?B?RmVwcnVxRXp5YlVjeGtONUMyeFVoVG1uSVlPc1FRSXhuVWVJOWphN3RJSG1i?=
 =?utf-8?B?ZGR3ZnNzc01JOWpEUWxEU21TdmJMRVh3WE9RdjBXQ0dRT2pBN0ErRDVqZm5w?=
 =?utf-8?B?WWlyTTBZbk1WL2FvSnJ0alJHUzd0K05hQmRBWFUvSUdrQUVIQStWamhiNFN5?=
 =?utf-8?B?b25FYlF2Uzh0WVJkSlVIRFc5MjBYamVzL2dTRlZsRHhXOStwbUFza1lwdkRj?=
 =?utf-8?B?SHY3YzlpQzRuUEF4azZqUnloQUx2K1N3N3RnQnNaVDlHQ3BlOW1kNXBRNGFi?=
 =?utf-8?B?aFk0RXQ3aHpJVW90T0t2T1JkU0pPdUlMTHo1MEZIUkYrTjVMaFZ6N0JDYllJ?=
 =?utf-8?B?dDI0MjhZWS8wbzM3MlhmQVdLeUlETXhIL2lkQTUxSkdGS0ZNVjl5TytOU1Rq?=
 =?utf-8?B?OUp4WHgyQ09WbVBqcU9QTFRaT1MwS1NkNzZRcmdyRjlKUGRDZkFRMnFMTnRs?=
 =?utf-8?B?dU9VQnNkcmxYaVdGVDlqYmJrcEJLRGZ6NEtST0FqdHM0NFpEMzdQRVpUWmNn?=
 =?utf-8?B?YTRValBlOEJjZ2IwUDRjZHNzczczZnAwdkxlNlNOSE1WeGd5cHMvOXFFVkhq?=
 =?utf-8?B?SmFkMGdMNkhTcnRsZ2FKL1l5YXo0L1dYYjlvR3RMbXFGRGtTYXRsY2oxR1Ey?=
 =?utf-8?B?aHErRDUrL0NzN3BZU1BYWGFjNXppQnE3cDZIcmFjdWQrZkZudE1MVFJPZy9p?=
 =?utf-8?B?VWxINElHeW5ONnZpUUVpbzE3NWxiM2JXMEFNbmhQTHVjVTgzMkYxWlBVT0cz?=
 =?utf-8?B?OFZKMWdBd1hhR1BNakZPVlF3NklvWWFldGJvTXBLRUNlakpuOFEybEVoUTJH?=
 =?utf-8?B?QkZVVU54bUY2TlVoZzB3QmE2RWF4dUcyOW9leXBoR3RLd2NrVGRCbjAxZ211?=
 =?utf-8?B?aUVnNitLM2VQcnh0b0pWTTJqM3RGa1kzNU9hdVgybmVvbVM2cVdxdUE3U0h4?=
 =?utf-8?B?N215cExSdzMxV01UVnFWLzJHS2pwNW1sR29sTmEyRGpPSWFjdnBzSHR4MDV2?=
 =?utf-8?B?VnJWZndrMGdURWRCUndYZTllcldCOC9TbDZPRTc2YXNKL3NTMXpnSHF6dmVu?=
 =?utf-8?B?UkRCVmNYZVZ1YzB5NnNzVk16TE9mcDB6RURaL2VUWU1GV0gvZXlXeCtXQk8w?=
 =?utf-8?B?dzJvVHp6YXdtdUFpR0dFYU1Ic1QyaU9GRXBtM1J6R1JVZDJySzlNUGxXMDVt?=
 =?utf-8?B?RVdYQ2xnUkhzaktPcW91WDFraDE2Z0M0NFpzdmg1STBMRndkWEY3UkhTSFMv?=
 =?utf-8?B?SXR0eSt0aTl6cG8ybFdQN1h6NzJaQW55c2FjekppY3BJVU9yc2VXNTdFTzZz?=
 =?utf-8?B?UzF3WHBuYWdIRk51VEJiQUVpR0c4S0FNcm1jOVIrcHYvMzBFSUdFdmcvYUp5?=
 =?utf-8?B?a1FtZHZPMHU5TG9kRHUzSGhrOVU3VHlzODZMNzZtRGlMTDhVTEFvbi9mZGJB?=
 =?utf-8?B?QXZNbS94aHVNU2wrUzhOWlcwZFRqL0FZSndkVCtNUVpjb1R6UDE4VU9YQm1k?=
 =?utf-8?B?cno1LzNQSTYybUNJQWRIZDB0Q0p6RjV1UGdQMGZVVGF3N3pBVE1HSmZTdyt5?=
 =?utf-8?Q?AcPg5uq5e24TpxlLHu2r/1H45R3ApLct3A9ooSj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e587e461-1465-40fc-1a93-08d981b7e9d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 13:08:35.1076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nH0+F2si/nsRp+MjBXopLxm9gSTuZbuf8VAyKUPFFv4A26Giqr9iAFfVy5XsbSw0dfD23MnPbXJ+kkFUH7JB/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5530
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIFNlcHRlbWJlciAyNywgMjAyMSA3OjM0IFBNDQo+IA0KPiBPbiAyMDIxLzkvMjcgMTc6NDIs
IFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ICtpbnQgaW9tbXVfZGV2aWNlX3NldF9kbWFfaGludChz
dHJ1Y3QgZGV2aWNlICpkZXYsIGVudW0gZG1hX2hpbnQgaGludCkNCj4gPiArew0KPiA+ICsJc3Ry
dWN0IGlvbW11X2dyb3VwICpncm91cDsNCj4gPiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJZ3Jv
dXAgPSBpb21tdV9ncm91cF9nZXQoZGV2KTsNCj4gPiArCS8qIG5vdCBhbiBpb21tdS1wcm9iZWQg
ZGV2aWNlICovDQo+ID4gKwlpZiAoIWdyb3VwKQ0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4g
PiArCW11dGV4X2xvY2soJmdyb3VwLT5tdXRleCk7DQo+ID4gKwlyZXQgPSBfX2lvbW11X2dyb3Vw
X3ZpYWJsZShncm91cCwgaGludCk7DQo+ID4gKwltdXRleF91bmxvY2soJmdyb3VwLT5tdXRleCk7
DQo+ID4gKw0KPiA+ICsJaW9tbXVfZ3JvdXBfcHV0KGdyb3VwKTsNCj4gPiArCXJldHVybiByZXQ7
DQo+ID4gK30NCj4gDQo+IENvbmNlcHR1YWxseSwgd2UgY291bGQgYWxzbyBtb3ZlIGlvbW11X2Rl
ZmVycmVkX2F0dGFjaCgpIGZyb20NCj4gaW9tbXVfZG1hX29wcyBoZXJlIHRvIHNhdmUgdW5uZWNl
c3NhcnkgY2hlY2tzIGluIHRoZSBob3QgRE1BIEFQSQ0KPiBwYXRocz8NCj4gDQoNClllcywgaXQn
cyBwb3NzaWJsZS4gQnV0IGp1c3QgYmUgY3VyaW91cywgd2h5IGRvZXNuJ3QgaW9tbXUgY29yZSAN
Cm1hbmFnZSBkZWZlcnJlZF9hdHRhY2ggd2hlbiByZWNlaXZpbmcgQk9VTkRfRFJJVkVSIGV2ZW50
Pw0KSXMgdGhlcmUgb3RoZXIgaW1wbGljYXRpb24gdGhhdCBkZWZlcnJlZCBhdHRhY2ggY2Fubm90
IGJlIGRvbmUNCmF0IGRyaXZlciBiaW5kaW5nIHRpbWU/DQoNClRoYW5rcw0KS2V2aW4NCg==
