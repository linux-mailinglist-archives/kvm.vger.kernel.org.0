Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C19042D495
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 10:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhJNIP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 04:15:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:32190 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229985AbhJNIPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 04:15:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="226398259"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="226398259"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 01:13:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="524974066"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 14 Oct 2021 01:13:20 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 01:13:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 01:13:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 01:13:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNfuApIS1NOndPWjYhLbH30nqEIQX7Fcme9Z/uxE6m31PhEbG1Z9EIuTI1PNkSXeeaO/vIdZfTurxwGgidTn+3ld5dQwMORpGEy191N7DSVMj6rDvDd5sVHyBqP+mHwXi3/5bkqR6Y/EoS4XlyND2tbSeaAOmIqFMZ7+1tmxnX6FgZm3rY2JN1zBzqQw6UH329jcKZ0ymV8tUBn+iLbJqSW8ACpaS2HhWegQXn+3qW+j5WTAnGJTkOFVbxpYvAchqBtQ0DnxsF62B45TkvZzf0Z7GvismOcrm2piSIjsPOxtKioTd0ggkxG47LMyaqVQ3z+Lxq9vt9/bHRgbZhHylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDl0lTMWaBPS9HiuLCeUT4VPKKfqDYLMLwMWo/xuJTg=;
 b=TOQebx16tALRI78MRSk2AADW7b2pU2laR8zS9Ittucb55oEw9KnpJRwMR3toHymB8+ep+MOH2+w6J2snsQFZ3FZ1ydzjY8VRPWcC6vjjfm9ekYUnKRE4I74BvlKhctRjnJbFexx0dC9gyGNkuQSXfrnPmoQJzLLR8ciYJzYYPCCVaN6mqBwNPz7lu3FVLagcWNgQAKCjuawC9CPm7uMrDxMeDerKWjJMsfEXHRtSJXNv29q7o0YfNpEc5zP59GMcFYS+vvhGd22OdvyMsSSlCq71SKzkXPwemW7BVR/BPrbT6sulFDl2iRbOc+GnCI/lMYiW5gZgGZcyLO/taSPpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDl0lTMWaBPS9HiuLCeUT4VPKKfqDYLMLwMWo/xuJTg=;
 b=NNiVgrRP41jMGwEXRS69/fT4tVSqvt15ZPDEL4vP8Tm295zg/AiJhdHLEQ7RS3ilOpsFIGexam67+pzcmLOutqQ+JpBJBVVASdn96SjuGx4oXOXECVhqDRbkEMX5r8p9F6hluF87BKVjsn/Oxq0FdvSSpHAv/fjdNaDPUbevmQ4=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1458.namprd11.prod.outlook.com (2603:10b6:405:d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Thu, 14 Oct
 2021 08:13:04 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 08:13:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "hch@lst.de" <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAgyUAgAAUFACAAAdkgIAAB/8AgAkqbYCAAEeFAIABQYSQgAAuX4CAAME3AIAAWmMAgBS7FgA=
Date:   Thu, 14 Oct 2021 08:13:03 +0000
Message-ID: <BN9PR11MB5433075C677D7E33C20431418CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929123630.GS964074@nvidia.com>
 <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVWSaU4CHFHnwEA5@myrica> <20210930220446.GF964074@nvidia.com>
 <20211001032816.GC16450@lst.de>
In-Reply-To: <20211001032816.GC16450@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48c44bba-b6bb-49ef-c128-08d98eea7243
x-ms-traffictypediagnostic: BN6PR11MB1458:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1458DCAD327809381747C7338CB89@BN6PR11MB1458.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F0sq9wVD08+77nGIGvW9FRJU2kb6uQPKogvnkpzlze0CLO45xaSxYhfMNDRreriIa2kFVjhHsbZnzb2FDbsVHAZ4o3UDoVPwg4xgv7YcaOwZ+l+Vz5g2ekaIeYC4SpwdRgxOWDIDATcvYlmP9IINrye1rh4QRf13vSdDRzq1wmIq45Ss3zLD0D2sZCa8FGvBwRFBRDQOCmegVBzETsOqPK1arFf8x6YTsxHj5EmZoVPWtdzXCo/z3vrBxamoOpLx5l0BNsnO/6bv/UpuMcPMk/BnO/hhJUqqVN8/t0RSuEupXQQJb9X3snxywiBRUwBpvHiwPvxsnPYVe7irc+KnVCmccYmJrDOHmJ4l5V9yxR7/XMDdHqOs95/2HChpRLXAq0BeSFeDy0vjXpf5t833C6N36l0rI6acLNqWS816g8zUufGWxdqLny/SvQgRY5YZv5AJlm1BHjnlBL6wOFy0rz5vi3cxdFzD1/nKfIuxQb81yxszkWt1DxtJq3rAq3fYdjI069FQNLMzPVacQCuAk2kKLqvjLQtXiq2jtBVmah6oV06bgIFzb33I+R2B7bi+Gc/CD2Z4B4d4ypa18agR7R3FMGWqDf/H5Mzr1VGrlpwn7bVBvt8fuzaUCVZ2W0AKBeknynqBAcvOOyPsYJrOsQlGlhYWEk6eG8y27ejR/fSfOInzQoDPGxHD6ODIGo3brSbmdjztQuS1Nni2XSVkmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(33656002)(86362001)(5660300002)(8936002)(38100700002)(26005)(82960400001)(38070700005)(55016002)(122000001)(54906003)(6506007)(52536014)(8676002)(64756008)(316002)(66446008)(508600001)(66476007)(66946007)(66556008)(76116006)(4326008)(71200400001)(7416002)(2906002)(110136005)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnB6YXBoaWR4WlNacmdHUW9HNGt5Zk5nYTgrNS80K2ZtTVI5TG5UTUswRVdK?=
 =?utf-8?B?eGpiU0NmSzRaWGNFakVZWTFHZmRWNmQ4K3BMQXRDZXJtc2phV3pFcWhRMWJu?=
 =?utf-8?B?N3BpcGRSUVFkWXhyV1pCbGYvSklTd1JyRjNaZWRnT0UzbE5GNEFTaFRibFAr?=
 =?utf-8?B?OUVJbG9TelRCaUVic0FIeVdLdi8xZjJITjNFRWNDR3pmaDhPT2lOTHJsMkhV?=
 =?utf-8?B?R3cxWDNITS93M1ZNR0NPNVVZS0ZuaU5CR2lrcDNQWlp2UnZtMWhmVW5tWE1M?=
 =?utf-8?B?UGNacjRIRGg3WkJtWUtQbEtXUWZlc0FlZzI0eDg3L2xWU3lhS0VmQUlRcW5F?=
 =?utf-8?B?b29sUS9QVWtDcVhGdytVQjVYOEJkMFg4NFd1bGMyUXNubjJ4L0k1Wi9ibGdU?=
 =?utf-8?B?TkxUUUFVRUFxRTFZTi90TFBCcUFoZjNJUnhOcmRuL2NyV2FoRmhNbkN6Vkp0?=
 =?utf-8?B?UllXMHFWOVpKN3pzMHJOaU5xZTR2MHg2b2xzWHVwWUg5QUpLbjJQU1JxYjdH?=
 =?utf-8?B?eENCL1BZaDg3MVNZdlpzYmJhbjFLbkJVWjJka2lFR3M4MW1GWXpVbkNxZXRa?=
 =?utf-8?B?cGJJeUs3WXhML1VlNWZUUUgreVVKcDhLSjYyamtwRmhsTCtRL0M2NW9oekl4?=
 =?utf-8?B?UXRlcmQ5UnFmdjNIdUZFVXVTTDZrd2t3b3VxNmU5L3hYR1FOem1XZ3NMaFUy?=
 =?utf-8?B?SWtIMFJ1QlorK29uelFBa0dvQ1U3ZkhVTnVUQXBPeXdFZnBtcWE3MldDVkhh?=
 =?utf-8?B?eFRrMCtZeE8rTHhHZGt4ZnQrVjJlcGhTSllwOCsxNlZwZUFGV05tQjh1UlNh?=
 =?utf-8?B?UjRSYUNHaXM2blV0bjJDNjdkZDdqV0pJWTZwdi9UeVFWLzVIakhqZkZnVW50?=
 =?utf-8?B?NS81S0tOM2hqNlhhTE4xK3ZXYUU5NTZhWkhRMWlpVTJUS3VxUFJ0Vk1KRmE2?=
 =?utf-8?B?OWhlMWRnUGw5M21FdlVjckR5NWxqdzRDLzBST0NiVkkwM24vcmp0Mmk1Wmo2?=
 =?utf-8?B?dlRuL1EyTlVVZTR0OEdORGlMQVRpOW9NQTJFMGpnZHpIZWV4V0FqY3VHY3h5?=
 =?utf-8?B?aGt4RFJSQVVsdlFiYi9LWXYzeXQrZUR0QTM2R1ZJd0ZvK0NkRHI1eko1d1l4?=
 =?utf-8?B?MitSb2huNEVGc0dQQVp6c1RyOVN1S2MwaEY1aFBjVExiK3l4eFZ6VGU0L2J0?=
 =?utf-8?B?UWRDWHBrZ0gxaThLV3NBVCtuUVlKK3pKQzlxV2k0NjNRaFc2TURMdXYzUEJw?=
 =?utf-8?B?NmtrOEFxY256Y3diMFBudTNxcEhkQW5lNkJJV2ppRlBiTHhuYWhMN3NoVDRM?=
 =?utf-8?B?c0Jtc1IzN1IzLzl2ekFHMHQrTmdOS3pkRVRJK2xjTlVrNFNYL1REcWhjbHhq?=
 =?utf-8?B?eFZWd0NHQ2gxNXZLL3pIZUREenpXZzRiL25OZ0RxY3EybXpFUjNkRmlQVi96?=
 =?utf-8?B?UTVuTkxsUjZVbkMyVGprdGtwa0QyK3Y2RlZRNkdHNGdxVkt6cnFQZE4wRklR?=
 =?utf-8?B?anBpWTZIUzlXeWZocnhwcjhoWkxGcVMybm5udUVwU2VvT3pPMHo0cjlIOG1H?=
 =?utf-8?B?UDlBTHVJcldZbXNGd3g0ZVVGMGpYdk9MRGNOT1dxODNoSUdKNDFmeFNkYmox?=
 =?utf-8?B?OFlqVFY3M2JYNm9KRGhyUURXa0lLRnhVMnRuTEZWUk9XOGlJS2lRanEzQW4w?=
 =?utf-8?B?MW1Gb2REVi8ycEtHdjgxNEhJRGl4dWt3SDNPOFpCQy9KRVF3SjdFWEF2QXJt?=
 =?utf-8?Q?sRhdpZH8YZDXA71eeoIA8jL1gaUK3okEzZl2pq9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c44bba-b6bb-49ef-c128-08d98eea7243
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 08:13:03.9045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sheS8Bo1SousmRW1ky7SLAsf6aui+M31WcRcB6l9w4IDXUWfXOuxsNv7PoE8th+/tlHUJaY6Oxnxptzu4iFLfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1458
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBoY2hAbHN0LmRlIDxoY2hAbHN0LmRlPg0KPiBTZW50OiBGcmlkYXksIE9jdG9iZXIg
MSwgMjAyMSAxMToyOCBBTQ0KPiANCj4gT24gVGh1LCBTZXAgMzAsIDIwMjEgYXQgMDc6MDQ6NDZQ
TSAtMDMwMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+ID4gT24gQXJtIGNhY2hlIGNvaGVy
ZW5jeSBpcyBjb25maWd1cmVkIHRocm91Z2ggUFRFIGF0dHJpYnV0ZXMuIEkgZG9uJ3QNCj4gdGhp
bmsNCj4gPiA+IFBDSSBOb19zbm9vcCBzaG91bGQgYmUgdXNlZCBiZWNhdXNlIGl0J3Mgbm90IG5l
Y2Vzc2FyaWx5IHN1cHBvcnRlZA0KPiA+ID4gdGhyb3VnaG91dCB0aGUgc3lzdGVtIGFuZCwgYXMg
ZmFyIGFzIEkgdW5kZXJzdGFuZCwgc29mdHdhcmUgY2FuJ3QNCj4gZGlzY292ZXINCj4gPiA+IHdo
ZXRoZXIgaXQgaXMuDQo+ID4NCj4gPiBUaGUgdXNhZ2Ugb2Ygbm8tc25vb3AgaXMgYSBiZWhhdmlv
ciBvZiBhIGRldmljZS4gQSBnZW5lcmljIFBDSSBkcml2ZXINCj4gPiBzaG91bGQgYmUgYWJsZSB0
byBwcm9ncmFtIHRoZSBkZXZpY2UgdG8gZ2VuZXJhdGUgbm8tc25vb3AgVExQcyBhbmQNCj4gPiBp
ZGVhbGx5IHJlbHkgb24gYW4gYXJjaCBzcGVjaWZpYyBBUEkgaW4gdGhlIE9TIHRvIHRyaWdnZXIg
dGhlIHJlcXVpcmVkDQo+ID4gY2FjaGUgbWFpbnRlbmFuY2UuDQo+IA0KPiBXZWxsLCBpdCBpcyBh
IGNvbWJpbmF0aW9uIG9mIHRoZSBkZXZpY2UsIHRoZSByb290IHBvcnQgYW5kIHRoZSBkcml2ZXIN
Cj4gd2hpY2ggYWxsIG5lZWQgdG8gYmUgaW4gbGluZSB0byB1c2UgdGhpcy4NCj4gDQo+ID4gSXQg
ZG9lc24ndCBtYWtlIG11Y2ggc2Vuc2UgZm9yIGEgcG9ydGFibGUgZHJpdmVyIHRvIHJlbHkgb24g
YQ0KPiA+IG5vbi1wb3J0YWJsZSBJTyBQVEUgZmxhZyB0byBjb250cm9sIGNvaGVyZW5jeSwgc2lu
Y2UgdGhhdCBpcyBub3QgYQ0KPiA+IHN0YW5kYXJkcyBiYXNlZCBhcHByb2FjaC4NCj4gPg0KPiA+
IFRoYXQgc2FpZCwgTGludXggZG9lc24ndCBoYXZlIGEgZ2VuZXJpYyBETUEgQVBJIHRvIHN1cHBv
cnQNCj4gPiBuby1zbm9vcC4gVGhlIGZldyBHUFVzIGRyaXZlcnMgdGhhdCB1c2UgdGhpcyBzdHVm
ZiBqdXN0IGhhcmR3aXJlZA0KPiA+IHdic3luYyBvbiBJbnRlbC4uDQo+IA0KPiBZZXMsIGFzIHVz
dWFsIHRoZSBHUFUgZm9sa3MgY29tZSB1cCB3aXRoIG5hc3R5IGhhY2tzIGluc3RlYWQgb2YNCj4g
cHJvdmlkaW5nIGdlbmVyaWMgaGVscGVyLiAgQmFzaWNhbGx5IGFsbCB3ZSdkIG5lZWQgdG8gc3Vw
cG9ydCBpdA0KPiBpbiBhIGdlbmVyaWMgd2F5IGlzOg0KPiANCj4gIC0gYSBETUFfQVRUUl9OT19T
Tk9PUCAob3IgRE1BX0FUVFJfRk9SQ0VfTk9OQ09IRVJFTlQgdG8gZml0IHRoZQ0KPiBMaW51eA0K
PiAgICB0ZXJtaW5vbG9neSkgd2hpY2ggdHJlYXRzIHRoZSBjdXJyZW50IGRtYV9tYXAvdW5tYXAv
c3luYyBjYWxscyBhcw0KPiAgICBpZiBkZXZfaXNfZG1hX2NvaGVyZW50IHdhcyBmYWxzZQ0KPiAg
LSBhIHdheSBmb3IgdGhlIGRyaXZlciB0byBkaXNjb3ZlciB0aGF0IGEgZ2l2ZW4gYXJjaGl0ZWN0
dXJlIC8gcnVubmluZw0KPiAgICBzeXN0ZW0gYWN0dWFsbHkgc3VwcG9ydHMgdGhpcw0KDQpCYXNl
ZCBvbiBhYm92ZSBpbmZvcm1hdGlvbiBteSBpbnRlcnByZXRhdGlvbiBpcyB0aGF0IGV4aXN0aW5n
IA0KRE1BIEFQSSBtYW5hZ2VzIGNvaGVyZW5jeSBwZXIgZGV2aWNlIGFuZCBJdCdzIG5vdCBkZXNp
Z25lZCBmb3INCmRldmljZXMgd2hpY2ggYXJlIGNvaGVyZW50IGluIG5hdHVyZSBidXQgYWxzbyBz
ZXQgUENJIG5vLXNub29wDQpmb3Igc2VsZWN0aXZlIHRyYWZmaWMuIFRoZW4gdGhlIG5ldyBETUFf
QVRUUl9OT19TTk9PUCwgb25jZQ0Kc2V0IGluIGRtYV9tYXAsIGFsbG93cyB0aGUgZHJpdmVyIHRv
IGZvbGxvdyBub24tY29oZXJlbnQNCnNlbWFudGljcyBldmVuIHdoZW4gdGhlIGRldmljZSBpdHNl
bGYgaXMgY29uc2lkZXJlZCBjb2hlcmVudC4NCg0KRG9lcyBpdCBjYXB0dXJlIHRoZSB3aG9sZSBz
dG9yeSBjb3JyZWN0PyANCg0KPiANCj4gPiBXaGF0IEkgZG9uJ3QgcmVhbGx5IHVuZGVyc3RhbmQg
aXMgd2h5IEFSTSwgd2l0aCBhbiBJT01NVSB0aGF0IHN1cHBvcnRzDQo+ID4gUFRFIFdCLCBoYXMg
ZGV2aWNlcyB3aGVyZSBkZXZfaXNfZG1hX2NvaGVyZW50KCkgPT0gZmFsc2UgPw0KPiANCj4gQmVj
YXVzZSBubyBJT01NVSBpbiB0aGUgd29ybGQgY2FuIGhlbHAgdGhhdCBmYWN0IHRoYXQgYSBwZXJp
cGhhbCBvbiB0aGUNCj4gU09DIGlzIG5vdCBwYXJ0IG9mIHRoZSBjYWNoZSBjb2hlcmVuY3kgcHJv
dG9jb2wuDQoNCmJ1dCBzaW5jZSBETUEgZ29lcyB0aHJvdWdoIElPTU1VIHRoZW4gaXNuJ3QgSU9N
TVUgdGhlIG9uZSB3aG8NCnNob3VsZCBkZWNpZGUgdGhlIGZpbmFsIGNhY2hlIGNvaGVyZW5jeT8g
V2hhdCB3b3VsZCBiZSB0aGUgY2FzZQ0KaWYgdGhlIElPTU1VIHNldHMgV0Igd2hpbGUgdGhlIHBl
cmlwaGVyYWwgZG9lc24ndCB3YW50IGl0Pw0KDQpUaGFua3MNCktldmluDQo=
