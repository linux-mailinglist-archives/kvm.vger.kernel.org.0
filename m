Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5241AA02
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 09:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbhI1HpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 03:45:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:21597 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239099AbhI1HpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 03:45:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288300734"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="288300734"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 00:43:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="561930976"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 00:43:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 00:43:39 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 00:43:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 00:43:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 00:43:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kV051LYkpxXyNafLjOy3QzCggFzHFKsHBtpCSUuVFH1QaPfgrP9lpKiY2c5GcQb9dESdXlE4TAxk35oMozHBRzVTQFR/8eHEnIYJ2s+KWUec5Y018osdsITHXvMycnkccgRvyeviT9PysWSqZGQTdSx/+OtOwh1EC8K+WZygb3Bnyt/Bq9QkV1kVZIy1CvLqxlNi5NsoStNdLIZbLELARPsjzJx1tbUSDUESIwoh0i3jwPUX6jARHepZqiuYZ5eqefT9D+47z3PHMd/OHmWbPfV7KRTlV35rF8dDiPt2tRigfa1dugtae2OC45sMTQlzaHFqCevqg0+zNIxjo6hYUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=L9z8XkhVB+mB0K7NmsBqMrSd+YAT3ynsIRu5QprvpD8=;
 b=Nhv+xAH2Yi/BZYgtaz4G779PbGEYYttgm/SwnXZKP+XRdly5OfPVItLFInmNnDRH3kLASbhse+3nbadgAScfMyRoraWKiIzj6zXHLRJdbNsAR/DOmhfcY+Zjdlrq09rcEhBhIjQhLnuQkhMBh/K1qN5hjgnrb4HCpsR3hMVvVoY0vqLE7oLvwR1OekfyCa35k1TNlBa+2Ym0N6s+fv654TSbjzSW6ISA6JUS1aNri2mcUZEVP0RncySWNe6PJzMCDBJzjci6SyT7lnwjTnGloX7MWEOBkxKoeoQ+gzokIBMqdRX25KHsIG3A4QXLZ6RraeeTL/0b0e6KtdKL2N2YAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9z8XkhVB+mB0K7NmsBqMrSd+YAT3ynsIRu5QprvpD8=;
 b=tQks+1JGa6mFwb6dgKqVWZ3ODtlTEjpSMG+6XtZuaffpdNBc2PQDbnUxe8pmhxp/BU6VNdw0nyrMez38nGQJyzowmQ2Q3tW+rEVg3w0CU6HojMl/e2LwU2UXwKtr+WW3mekQJLyreCq/J0dIRO2bMqpTgR1nM0Gx+k6bXPQdOZk=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5354.namprd11.prod.outlook.com (2603:10b6:408:11b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 07:43:36 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 07:43:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgABthQCAABACQIAABTKAgAAAdqCAAGb7gIAAzXUQ
Date:   Tue, 28 Sep 2021 07:43:36 +0000
Message-ID: <BN9PR11MB54332256C5AAB9AECC88A7E38CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-7-yi.l.liu@intel.com>
        <20210921170943.GS327412@nvidia.com>
        <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922123931.GI327412@nvidia.com>
        <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210927115342.GW964074@nvidia.com>
        <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210927130935.GZ964074@nvidia.com>
        <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927131949.052d8481.alex.williamson@redhat.com>
In-Reply-To: <20210927131949.052d8481.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63a0af7f-aa10-4021-eb5b-08d98253ae41
x-ms-traffictypediagnostic: BN9PR11MB5354:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB535415DA81CE95EC120B26D68CA89@BN9PR11MB5354.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Su+fqBQoaqPms2kY4j0ZCTfFLXogjNbqm1sRPtsY8oPKZ3aKtjfdrsVQR84s/FgLUm5ucb0GJE10+gIl4N69WLu3UJDsdmL3qtWrtbrTQVcxq0eATO2aEvmzHKI+5A9I7ssUdhJ1IW+6am06ZnOd3lPmJEc52lPQZR9eKXNmiGDXDq29KUMqjSf+ou/DejF++NZxX2sG47+KJg9R4HDscOjksOnXkJr5UTwR3B1AyVGx8B2Yurl5iD0mlHX3bxDumzHgkSzjE6eihrvxD2s9ssWyLQ8JGXrwBQKX0c9kPB1P/+VOHR0VvCRLjvDKb/3AOc/njXOVMSyLC/ynyDjX/cd+zPAOA+FSDgYfjeXeiu+bP2vjjUVyIXByuyyzAmJpXsxmJ/bbAUzzqBzJBdsIZeeJMiy+sxA50eF6+QyZl9UiFBd2cAA4T8Mp2fRd1+cC7dfFjBEioKnwnQzLwmoDncAeNTm6r4t9uUcMHYIsiR7eqKU01iKeEeuQVE0KVPi7ICxaN2lbrKLBkH8ZQGQ3VUMEaqb8HLHPHVW2YGP4lCydb0ZnkZyolhxPh71mWkROFi4sXgXnDpabhNbsu3HSh+asxkgrDAYtDO971Un4Asoujph8JVAjgwMQ+9YEFEK1e2VZO18jttXDAVdTlaI+PQ5EHfiSRfqkTFuIVavleVKuWEVEs8d0SA2IBSJCGHk3mGo9v9PEw+VeXc1L4tIlgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(71200400001)(7696005)(26005)(86362001)(186003)(83380400001)(8936002)(508600001)(6506007)(4326008)(6916009)(76116006)(66476007)(2906002)(66446008)(64756008)(66556008)(38100700002)(52536014)(8676002)(38070700005)(316002)(54906003)(9686003)(122000001)(55016002)(7416002)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R09Yd3oyVlVrbm1lMmFYTEpUaXUwazR4aGJNMnQ0Vnd0aHVsakdFeUZkVkhS?=
 =?utf-8?B?OFZPOHBlTUlIVmx1dmRKdTZyTkhBUDJGMXdudU9Ec21DY0ZGWGhPMC9wL0hr?=
 =?utf-8?B?R0x1eHIxMDhXOEFhdUUrT0lqeGdYRzNhMXNnWFNCbnBZQnZMOW0xRjhFbjhU?=
 =?utf-8?B?bjNtclhzSGVpZWRIeldqdU9pcFlNd01YSkRHdXpXRGhJMStLd2lQNE94OExE?=
 =?utf-8?B?QXI3TENsbnRsR2RpQlh1WFJOWGdKaUdpTWNVWXA0aTY4WUZ4NFBmUWR1Z0J6?=
 =?utf-8?B?dWxYWTlkYTl4U095NG83YVNtSG1WbEZXZTJSanFqdUlzVnRGRXhrVU1laXc1?=
 =?utf-8?B?WnN0WTVUUklvSUVlTWduMmVxek1oYU5HdnQwVDhIRWxiWDN3aURPNTcyTnBj?=
 =?utf-8?B?anFyZHJjL3RjdjI5c2FITjJQSHFtUkRLMzl0OUswMUdQRGlsOHFObDBUQzYx?=
 =?utf-8?B?aUVmbHBDOER4RGw0cjJ6Zlo1ZHl2OHlWM1lLK0Z5eC8vSThMUFVBbVVvU0lm?=
 =?utf-8?B?VzdpVCtSOEduM2hPS3hPL1dJeEtoejk5OGppbytxbG9PNUMzNFBYT2lzYlpF?=
 =?utf-8?B?MW8rdG82bmVBMTZ1VlFocEM4MWZoS2ZuTG5aT1ozdlZzbkRhSWs1ajNyb0Vv?=
 =?utf-8?B?R1RiYmx2WjFoTlBWMmQ0UEQ3anRodmYwTVNEeG5IT0tRN3FRL0xLcE5wczE0?=
 =?utf-8?B?b0NLVjNjWlJpcW9QVVVYdmpmaC9WVEdKRU9XTTdVMXJNVGYxaFZiYzRMTVla?=
 =?utf-8?B?dnZwbnVWNW54MlA2Z3hZcnhQRlFWY1ZMUU40OVNCc0tLSXhueWtsOEtLR0g1?=
 =?utf-8?B?a3ZsTHRqTk1tM29WOVVnYTV1cS84ZHN6RGxNU3hLZnpmcktIS09OWGlNbFk3?=
 =?utf-8?B?cGhPeVZabDh1ODJ3bWhBaGREM09WWkJ1UjBjRmZzQWlCV3UraXNEcEczaVJN?=
 =?utf-8?B?d0NJYy9UbkdlQzkyOXpBN1pHTU9GRFRPNmswQVcxQnNlQ2I5Z3A5U2N1eURz?=
 =?utf-8?B?QndVRWE4Y3J0N0haTExncUQ4V3Bxd1cvTE9iV1NaUWFYQlpxZDVYc0VzdVlv?=
 =?utf-8?B?dUowem1aZzRGZ3laSGVVRDhTVTZIbk9RRU90NW5CdjJIWHNhMGpTZk1PNWtE?=
 =?utf-8?B?SEZxa1FqeWN1Y0hMK05VK082NGtWeHZZbGpZK2IvUWcxbzhTN2dWdWxwWjVY?=
 =?utf-8?B?YjZWUGZzL2hKSWNZUDhhaCtUdWtabXI3S0U2SlpGU3I2QmMramFDZFZtNjgx?=
 =?utf-8?B?ZXJ5d25pTFBlaGYycVBkVjI0MHJzSDFVOCtyQThQU0JZU1dTNWJBM3NDTUNB?=
 =?utf-8?B?SlNFWkE0WHdsSnUrYTE2V1N0RVpUa1A1L1RqN0w0OE9xbkZoMUMyZm8zV28r?=
 =?utf-8?B?WjltRkNQUGo2VkRJOFBFYzZjM0VmVzhiU0VraHhWa21IQVMycEN5NEJNKzM1?=
 =?utf-8?B?U3J3OWlRUFlXcmpHaDhpWDFkdW9sdXpJdG43Lzd6YTkrL1FKV2ZSK09kUHpa?=
 =?utf-8?B?Sld6QWwzdTEyT1JXeCt5QjJUTTMvY1FBODBleEZmMUc3K25CM0lOQ2RxV2lk?=
 =?utf-8?B?V0YxQjVGWlBmQkN3ZzBUMlZneVN0ekVrTnFJM3hoOXRzME85VjNzVnZwWEp3?=
 =?utf-8?B?OXFVYTM4TUxBdHhyVEsrb3EzWWFCNjlFWkRzSTdORFlza2c2cEUvVC9ITG05?=
 =?utf-8?B?YkR1V1A1VGtoRTRSZkdtbXk2VGg1L3NUMGVvK3ZTSjdYVnBpMjJmN28rbVc4?=
 =?utf-8?Q?kJrOELQAlecER2nheCGspt7wYUnJkblq/ws3Gcj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a0af7f-aa10-4021-eb5b-08d98253ae41
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 07:43:36.5524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0RpNo0B4W3L/UMFUqFlOrIuKQEr6l0W59o1QGhe4fNj0giopvD7URwO8Tx6DmMkUyyPhUXgozV2npOe0iu38ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5354
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIgMjgsIDIwMjEgMzoyMCBBTQ0KPiANCj4gT24gTW9uLCAy
NyBTZXAgMjAyMSAxMzozMjozNCArMDAwMA0KPiAiVGlhbiwgS2V2aW4iIDxrZXZpbi50aWFuQGlu
dGVsLmNvbT4gd3JvdGU6DQo+IA0KPiA+ID4gRnJvbTogSmFzb24gR3VudGhvcnBlDQo+ID4gPiBT
ZW50OiBNb25kYXksIFNlcHRlbWJlciAyNywgMjAyMSA5OjEwIFBNDQo+ID4gPg0KPiA+ID4gT24g
TW9uLCBTZXAgMjcsIDIwMjEgYXQgMDE6MDA6MDhQTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6
DQo+ID4gPg0KPiA+ID4gPiA+IEkgdGhpbmsgZm9yIHN1Y2ggYSBuYXJyb3cgdXNhZ2UgeW91IHNo
b3VsZCBub3QgY2hhbmdlIHRoZSBzdHJ1Y3QNCj4gPiA+ID4gPiBkZXZpY2VfZHJpdmVyLiBKdXN0
IGhhdmUgcGNpX3N0dWIgY2FsbCBhIGZ1bmN0aW9uIHRvIGZsaXAgYmFjayB0byB1c2VyDQo+ID4g
PiA+ID4gbW9kZS4NCj4gPiA+ID4NCj4gPiA+ID4gSGVyZSB3ZSB3YW50IHRvIGVuc3VyZSB0aGF0
IGtlcm5lbCBkbWEgc2hvdWxkIGJlIGJsb2NrZWQNCj4gPiA+ID4gaWYgdGhlIGdyb3VwIGlzIGFs
cmVhZHkgbWFya2VkIGZvciB1c2VyLWRtYS4gSWYgd2UganVzdCBibGluZGx5DQo+ID4gPiA+IGRv
IGl0IGZvciBhbnkgZHJpdmVyIGF0IHRoaXMgcG9pbnQgKGFzIHlvdSBjb21tZW50ZWQgZWFybGll
cik6DQo+ID4gPiA+DQo+ID4gPiA+ICsgICAgICAgcmV0ID0gaW9tbXVfc2V0X2tlcm5lbF9vd25l
cnNoaXAoZGV2KTsNCj4gPiA+ID4gKyAgICAgICBpZiAocmV0KQ0KPiA+ID4gPiArICAgICAgICAg
ICAgICAgcmV0dXJuIHJldDsNCj4gPiA+ID4NCj4gPiA+ID4gaG93IHdvdWxkIHBjaS1zdHViIHJl
YWNoIGl0cyBmdW5jdGlvbiB0byBpbmRpY2F0ZSB0aGF0IGl0IGRvZXNuJ3QNCj4gPiA+ID4gZG8g
ZG1hIGFuZCBmbGlwIGJhY2s/DQo+ID4gPg0KPiA+ID4gPiBEbyB5b3UgZW52aXNpb24gYSBzaW1w
bGVyIHBvbGljeSB0aGF0IG5vIGRyaXZlciBjYW4gYmUgYm91bmQNCj4gPiA+ID4gdG8gdGhlIGdy
b3VwIGlmIGl0J3MgYWxyZWFkeSBzZXQgZm9yIHVzZXItZG1hPyB3aGF0IGFib3V0IHZmaW8tcGNp
DQo+ID4gPiA+IGl0c2VsZj8NCj4gPiA+DQo+ID4gPiBZZXMuLiBJJ20gbm90IHN1cmUgdGhlcmUg
aXMgYSBnb29kIHVzZSBjYXNlIHRvIGFsbG93IHRoZSBzdHViIGRyaXZlcnMNCj4gPiA+IHRvIGxv
YWQvdW5sb2FkIHdoaWxlIGEgVkZJTyBpcyBydW5uaW5nLiBBdCBsZWFzdCwgbm90IGEgc3Ryb25n
IGVub3VnaA0KPiA+ID4gb25lIHRvIGp1c3RpZnkgYSBnbG9iYWwgY2hhbmdlIHRvIHRoZSBkcml2
ZXIgY29yZS4uDQo+ID4NCj4gPiBJJ20gZmluZSB3aXRoIG5vdCBsb2FkaW5nIHBjaS1zdHViLiBG
cm9tIHRoZSB2ZXJ5IDFzdCBjb21taXQgbXNnDQo+ID4gbG9va3MgcGNpLXN0dWIgd2FzIGludHJv
ZHVjZWQgYmVmb3JlIHZmaW8gdG8gcHJldmVudCBob3N0IGRyaXZlcg0KPiA+IGxvYWRpbmcgd2hl
biBkb2luZyBkZXZpY2UgYXNzaWdubWVudCB3aXRoIEtWTS4gSSdtIG5vdCBzdXJlDQo+ID4gd2hl
dGhlciBvdGhlciB1c2FnZXMgYXJlIGJ1aWx0IG9uIHBjaS1zdHViIGxhdGVyLCBidXQgaW4gZ2Vu
ZXJhbCBpdCdzDQo+ID4gbm90IGdvb2QgdG8gcG9zaXRpb24gZGV2aWNlcyBpbiBhIHNhbWUgZ3Jv
dXAgaW50byBkaWZmZXJlbnQgdXNhZ2VzLg0KPiANCj4gSUlSQywgcGNpLXN0dWIgd2FzIGludmVu
dGVkIGZvciBsZWdhY3kgS1ZNIGRldmljZSBhc3NpZ25tZW50IGJlY2F1c2UNCj4gS1ZNIHdhcyBu
ZXZlciBhbiBhY3R1YWwgZGV2aWNlIGRyaXZlciwgaXQganVzdCBsYXRjaGVkIG9udG8gYW5kIHN0
YXJ0ZWQNCj4gdXNpbmcgdGhlIGRldmljZS4gIElmIHRoZXJlIHdhcyBhbiBleGlzdGluZyBkcml2
ZXIgZm9yIHRoZSBkZXZpY2UgdGhlbg0KPiBLVk0gd291bGQgZmFpbCB0byBnZXQgZGV2aWNlIHJl
c291cmNlcy4gIFRoZXJlZm9yZSB0aGUgZGV2aWNlIG5lZWRlZCB0bw0KPiBiZSB1bmJvdW5kIGZy
b20gaXRzIHN0YW5kYXJkIGhvc3QgZHJpdmVyLCBidXQgdGhhdCBsZWZ0IGl0IHN1c2NlcHRpYmxl
DQo+IHRvIGRyaXZlciBsb2FkcyB1c3VycGluZyB0aGUgZGV2aWNlLiAgVGhlcmVmb3JlIHBjaS1z
dHViIGNhbWUgYWxvbmcgdG8NCj4gZXNzZW50aWFsbHkgY2xhaW0gdGhlIGRldmljZSBvbiBiZWhh
bGYgb2YgS1ZNLg0KPiANCj4gV2l0aCB2ZmlvLCB0aGVyZSBhcmUgYSBjb3VwbGUgdXNlIGNhc2Vz
IG9mIHBjaS1zdHViIHRoYXQgY2FuIGJlDQo+IGludGVyZXN0aW5nLiAgVGhlIGZpcnN0IGlzIHRo
YXQgcGNpLXN0dWIgaXMgZ2VuZXJhbGx5IGJ1aWx0IGludG8gdGhlDQo+IGtlcm5lbCwgbm90IGFz
IGEgbW9kdWxlLCB3aGljaCBwcm92aWRlcyB1c2VycyB0aGUgYWJpbGl0eSB0byBzcGVjaWZ5IGEN
Cj4gbGlzdCBvZiBpZHMgZm9yIHBjaS1zdHViIHRvIGNsYWltIG9uIHRoZSBrZXJuZWwgY29tbWFu
ZCBsaW5lIHdpdGgNCj4gaGlnaGVyIHByaW9yaXR5IHRoYW4gbG9hZGFibGUgbW9kdWxlcy4gIFRo
aXMgY2FuIHByZXZlbnQgZGVmYXVsdCBkcml2ZXINCj4gYmluZGluZ3MgdG8gZGV2aWNlcyB1bnRp
bCB0b29scyBsaWtlIGRyaXZlcmN0bCBvciBib290IHRpbWUgc2NyaXB0aW5nDQo+IGdldHMgYSBz
aG90IHRvIGxvYWQgdGhlIHVzZXIgZGVzaWduYXRlZCBkcml2ZXIgZm9yIGEgZGV2aWNlLg0KPiAN
Cj4gVGhlIG90aGVyIHVzZSBjYXNlLCBpcyB0aGF0IGlmIGEgZ3JvdXAgaXMgY29tcG9zZWQgb2Yg
bXVsdGlwbGUgZGV2aWNlcw0KPiBhbmQgYWxsIHRob3NlIGRldmljZXMgYXJlIGJvdW5kIHRvIHZm
aW8gZHJpdmVycywgdGhlbiB0aGUgdXNlciBjYW4gZ2Fpbg0KPiBkaXJlY3QgYWNjZXNzIHRvIGVh
Y2ggb2YgdGhvc2UgZGV2aWNlcy4gIElmIHdlIHdhbnRlZCB0byBpbnNlcnQgYQ0KPiBiYXJyaWVy
IHRvIHJlc3RyaWN0IHVzZXIgYWNjZXNzIHRvIGNlcnRhaW4gZGV2aWNlcyB3aXRoaW4gYSBncm91
cCwgd2UnZA0KPiBzdWdnZXN0IGJpbmRpbmcgdGhvc2UgZGV2aWNlcyB0byBwY2ktc3R1Yi4gIE9i
dmlvdXNseSB3aXRoaW4gYSBncm91cCwgaXQNCj4gbWF5IHN0aWxsIGJlIHBvc3NpYmxlIHRvIG1h
bmlwdWxhdGUgdGhlIGRldmljZSB2aWEgcDJwIERNQSwgYnV0IHRoZQ0KPiBiYXJyaWVyIGlzIG11
Y2ggaGlnaGVyIGFuZCBkZXZpY2UsIGlmIG5vdCBwbGF0Zm9ybSwgc3BlY2lmaWMgdG8NCj4gbWFu
aXB1bGF0ZSBzdWNoIGRldmljZXMuICBBbiBleGFtcGxlIHVzZSBjYXNlIG1pZ2h0IGJlIGEgY2hp
cHNldA0KPiBFdGhlcm5ldCBjb250cm9sbGVyIGdyb3VwZWQgYW1vbmcgc3lzdGVtIG1hbmFnZW1l
bnQgZnVuY3Rpb24gaW4gYQ0KPiBtdWx0aS1mdW5jdGlvbiByb290IGNvbXBsZXggaW50ZWdyYXRl
ZCBlbmRwb2ludC4NCg0KVGhhbmtzIGZvciB0aGUgYmFja2dyb3VuZC4gSXQgcGVyZmVjdGx5IHJl
ZmxlY3RzIGhvdyBtYW55IHRyaWNreSB0aGluZ3MNCnRoYXQgdmZpbyBoYXMgZXZvbHZlZCB0byBk
ZWFsIHdpdGggYW5kIHdlJ2xsIGRpZyB0aGVtIG91dCBhZ2FpbiBpbiB0aGlzDQpyZWZhY3Rvcmlu
ZyBwcm9jZXNzIHdpdGggeW91ciBoZWxwLiDwn5iKDQoNCmp1c3QgYSBuaXQgb24gdGhlIGxhc3Qg
ZXhhbXBsZS4gSWYgYSBzeXN0ZW0gbWFuYWdlbWVudCBmdW5jdGlvbiBpcyANCmluIHN1Y2ggZ3Jv
dXAsIGlzbid0IHRoZSByaWdodCBwb2xpY3kgaXMgdG8gZGlzYWxsb3cgYXNzaWduaW5nIGFueSBk
ZXZpY2UNCmluIHRoaXMgZ3JvdXA/IEV2ZW4gdGhlIGJhcnJpZXIgaXMgaGlnaCwgYW55IGNoYW5j
ZSBvZiBhbGxvd2luZyB0aGUgZ3Vlc3QNCnRvIGNvbnRyb2wgYSBzeXN0ZW0gbWFuYWdlbWVudCBm
dW5jdGlvbiBpcyBkYW5nZXJvdXMuLi4NCg0KPiANCj4gPiBidXQgSSdtIGxpdHRsZSB3b3JyaWVk
IHRoYXQgZXZlbiB2ZmlvLXBjaSBpdHNlbGYgY2Fubm90IGJlIGJvdW5kIG5vdywNCj4gPiB3aGlj
aCBpbXBsaWVzIHRoYXQgYWxsIGRldmljZXMgaW4gYSBncm91cCB3aGljaCBhcmUgaW50ZW5kZWQg
dG8gYmUNCj4gPiB1c2VkIGJ5IHRoZSB1c2VyIG11c3QgYmUgYm91bmQgdG8gdmZpby1wY2kgaW4g
YSBicmVhdGggYmVmb3JlIHRoZQ0KPiA+IHVzZXIgYXR0ZW1wdHMgdG8gb3BlbiBhbnkgb2YgdGhl
bSwgaS5lLiBsYXRlLWJpbmRpbmcgYW5kIGRldmljZS0NCj4gPiBob3RwbHVnIGlzIGRpc2FsbG93
ZWQgYWZ0ZXIgdGhlIGluaXRpYWwgb3Blbi4gSSdtIG5vdCBzdXJlIGhvdw0KPiA+IGltcG9ydGFu
dCBzdWNoIGFuIHVzYWdlIHdvdWxkIGJlLCBidXQgaXQgZG9lcyBjYXVzZSB1c2VyLXRhbmdpYmxl
DQo+ID4gc2VtYW50aWNzIGNoYW5nZS4NCj4gDQo+IFllcCwgYSBoaWdoIHBvdGVudGlhbCB0byBi
cmVhayB1c2Vyc3BhY2UsIGVzcGVjaWFsbHkgYXMgcGNpLXN0dWIgaGFzDQo+IGJlZW4gcmVjb21t
ZW5kZWQgZm9yIHRoZSBjYXNlcyBub3RlZCBhYm92ZS4gIEkgZG9uJ3QgZXhwZWN0IHRoYXQgdG9v
bHMNCj4gbGlrZSBsaWJ2aXJ0IG1hbmFnZSB1bmFzc2lnbmVkIGRldmljZXMgd2l0aGluIGEgZ3Jv
dXAsIGJ1dCB0aGF0DQo+IHByb2JhYmx5IG1lYW5zIHRoYXQgdGhlcmUgYXJlIGFsbCBzb3J0cyBv
ZiBhZC1ob2MgdXNlciBtZWNoYW5pc21zDQo+IGJleW9uZCBzaW1wbHkgYXNzaWduaW5nIGFsbCB0
aGUgZGV2aWNlcy4gIFRoYW5rcywNCj4gDQoNClRoYW5rcw0KS2V2aW4NCg==
