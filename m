Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55B57D07F6
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 07:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345309AbjJTF4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 01:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbjJTF4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 01:56:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34864CA
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 22:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697781391; x=1729317391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n0DSid8NPDAdoapda6Th8NhREqnf+6DVGiaYAoUX9EY=;
  b=YiYJ1S+xzO3YR6U8mrKBYG4NuBYGViS0o4W3ZAM+ZHjRmFRp6bi7g8OY
   5lkFelizST7cH2MYkgwEQikCQgtqgx/pJA77mKmk9u9v3lMw/e6j6yV/T
   cWH30EEBq4qM3KZsZQ6s2Keuen6S9E62LdBlVITLYb6F4fzjk2bJh0PVI
   Bn/6DTZg1dQhjLlO2Rn8/POxAjEuyzXmvDHZYeRJimdRk6l4XwJAK7TYB
   nPHV1QjQqqpvG4gOKQ6ntHQZ8HtdhXtzs/cdCyEcZfRIDLoMUTJqqtdm5
   9rf1B0FdbS1Bt73TSp1lRlRJnNlxfctNKdbKlXeBrJtKdcLLkjkkvRgdp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="390317962"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="390317962"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 22:56:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="5007852"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 22:55:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 22:56:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 22:56:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 22:56:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EltmaUpGPoptBFfGiw1vxTxa8PQNKGqFzyevtacoo2kKVFICvOdBbI2/Jo18yev9WUNmYVSPkf5KHjZn6JMuIbUsO6jClB5/fh8DJs4uaWNskt2yAZqIzDM65yYaCXpOlF8THCHvAv7LWcPhf3HU6bbIPP/BrlmKH/tHMzUYn79kbQ1akAxNp9FAGQyX79bshTC8abx/la72/ti4SnLUiqWzN06IsewroIjPTxBVB6fJO3nQCEPCrekPGCBT7ygB/M5GmwU7qg3EQiG20zDqDzUVn+bFHtvvyXg+MZcqJl0gzaEa7atBRcly6T0xWG6GvpQrDJd2X1wAsgPFbjjd8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0DSid8NPDAdoapda6Th8NhREqnf+6DVGiaYAoUX9EY=;
 b=I2zq0Qu6Ehig9MhikSKYUh2ky+g+QC/eRio10XQzzVAAcKCBjoQ5lQl5flrtcB9xT3zAA6xiMVTZyKlwGoaBP8A9IBu2pLRNERTGh5r7Rxp/Vq7noZwhtFvW03XImYUh/GKJZCH4V+4IFl5y+MRK/hZD4K4PKlFRfSr52eKdXkdhth9+IoBX1J8Pqa1d0x6lfMqQubmelV0RSat0kYQHU3QRVnDl0V2hFxaKeMZPctCWfKPlh6SSfMnaOmLWbyTwYse752KqjtIhWbGqFExJVMvmI5AC6kR0ObEV2Hgfg1i55MQEJvXy+fWKddf8PFyD4Xn9oPjl7vMnX3tRgvWkqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7405.namprd11.prod.outlook.com (2603:10b6:8:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 05:55:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 05:55:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v4 05/18] iommufd: Add a flag to enforce dirty tracking on
 attach
Thread-Topic: [PATCH v4 05/18] iommufd: Add a flag to enforce dirty tracking
 on attach
Thread-Index: AQHaAgGbZCPMSPm1m0OnJdd2lyxyobBQI6CAgAAQwgCAAfubsA==
Date:   Fri, 20 Oct 2023 05:55:57 +0000
Message-ID: <BN9PR11MB5276A233B04820929DEC16318CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-6-joao.m.martins@oracle.com>
 <20231018223831.GA747062@nvidia.com>
 <0949e1b4-422c-4bcd-bcc5-96039690c050@oracle.com>
In-Reply-To: <0949e1b4-422c-4bcd-bcc5-96039690c050@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7405:EE_
x-ms-office365-filtering-correlation-id: df165f08-f52e-4a1f-0996-08dbd1313afb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yvdHcfrK1AoTN/FhnidF/S0gaCTdUTWJM/xHaa5r6KpXeJ8I1Uivfy95g3E0CJlT4wKyvIv9qTM82z8mDJwu6vMZmgNMpafdF25Zg0ctfIO9o5k8f7TFQlirORIfLGTCt9jTvzN9pPwpmApf6HVzdxTIzQ6c+ipCNOiyrvCULRAsy4tVNwvrw1mb9P0XoS4/TBwMq14O9IuOVOKI9FRYWB1q0GBS9AguE1TCyNd3rVgGgvz3D0qQZfQPAnq53hPw9WQnGz1mw+NVOTaW6FMzOSvF9IcxT+gzwbDfN334UxGNyGiKDoas9gKAtplwSIVdM3ZOUyjbR0oe+kQjY7UG4A/tEiZvP7jeGKkrJTrcwzY7lbJ8jEiiWjP9AWRnoZ8g6sanVqCJ8zFuBn6WYW9NTpalwZWpFJ94i4+Yx0nMCAiYgpo/PaYSdMKrCis7FywVizxN6BdBrrRbCNUDrgXPPB43YBHSwTsBopfEWugJap4JOp8OtKMiRsNWRLix/8HK3EmuDdtdLoSo5zh9KPDwwMbIduacNWn7CE8YBdftF61O9hdGqrCJLhi6aLOBHuAirxAZUzYB1gqxv4i5BmyNEWTnMqCFEA+fMIsfU6NLUJCNNG9JzmRhDxS9o7wxgL6EAvaYOKGq2rNozojMIsuAuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(55016003)(110136005)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(316002)(122000001)(82960400001)(478600001)(86362001)(33656002)(5660300002)(52536014)(8676002)(8936002)(7416002)(4744005)(4326008)(41300700001)(38100700002)(53546011)(9686003)(7696005)(6506007)(2906002)(71200400001)(26005)(38070700009)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejVxRC9yZGw4RFJXQnlPTHFFdFVpSWV6Skt5c3lIbHhyWjl3UG1rN0RveWVy?=
 =?utf-8?B?dXZzL2ltdzZkZ2V4MkhlUEpFUFgzRDRoZlR5TitrZnhsL21OdUZ6bk0reWt2?=
 =?utf-8?B?eDJsNHRzTnVOQW9BUVJqUlJxc0FUeEFIZFg4dzVGd0tJbE1EVE9pR0s5VkdI?=
 =?utf-8?B?ZTRXUElXYkwxTjNObjVLeU51ZW9FQTVHOVFjZ2JKZnVEd05iejdSZW1LTDdO?=
 =?utf-8?B?ci90UWQzOSsrM21XZEdUUmxScWNTenVyMTRrZUhnZFlRczE4QWsydGluaEI2?=
 =?utf-8?B?Rml4OWFRSjJnSmt6ZVJ5c2Q0dEM2VUZoYmJqdCtIdDM3eDV5NlNMMVB3d1Jq?=
 =?utf-8?B?a1U3dE1zQ1RsNVVxMHArN01sNXV1MHRWcERkbnBoTk13VVJVRWlVUHhodGtH?=
 =?utf-8?B?TjNqcndJem9acVBDYWFPWjRKL1BZMFNNU2RiR01WUDFvNDFsSHZESUVtWHNl?=
 =?utf-8?B?K3Fra29PTnJjY2R3bm9KQ0NUVnRwTUtUTEt6TU1ucGhFNWxCT3ViUUJTZ04w?=
 =?utf-8?B?cmthQUFZNGtzYXZ0S0hXdkhMY0NGbSsxbEhqQjN5bmNvQWZ4d3NvQnFkakZq?=
 =?utf-8?B?SkU2ZTZjNENHRHRyd1Y5K1J2aVd4cVArb3ZiblpqYTF1SlBqcko4MkpVVG5j?=
 =?utf-8?B?N2luT091K2U1dElSeElyZUdmK2M0a0ZBOFJSUGNKWkJOdW9RS3o2ZVFtbDNa?=
 =?utf-8?B?WDM5MjNCdUV0Y0FwSGtXemh2Wk1UZGlWN2prS2V0cTVsQXlKNWlCSkEvT1pL?=
 =?utf-8?B?M0oxTnFLNU9qZ3pDREIzTUtmdi9jSEVvVFhSV2wrT1gxSWFKZlB1UFFsK2Jw?=
 =?utf-8?B?cThUc1JUYVVBbXFLRGlsY1dBNGlDSWFUdXRxTVNLYjVGZ1B2Nlp5WWRSOWh5?=
 =?utf-8?B?OEZQajBqUkJqTW5mVkQxckZJNkQ0TXNjTXdPcldEMmtqYUR5RmhUelNHV0hp?=
 =?utf-8?B?ankxYmR6WHVaODkzemQvcGozR3hkT3o1Uld4Z1dKQmJzOGtGRXNJTVhzb3E2?=
 =?utf-8?B?aElIcmhNWFpHaEt0dnBtTWh6M3pmaFJ1RzcwNnlaWElKdHJmdzNUdnFXQ0tB?=
 =?utf-8?B?N3B1ckcxNFp5bmFYanZyd1dyMFVEMU9oUDZWNXAyTCthY0hublhQWWlQSEdq?=
 =?utf-8?B?SEVGNEJaZUNDVmc0VnlxTUk4TGE4dDZocnlPNGF0aXljd0F3OFBZMUFqbytP?=
 =?utf-8?B?WEd5N1UyOS9lZkpJU1dOZ0YxM2tCS0ZOZE1ramUwamdNcFp0Q2kza1V3ODJC?=
 =?utf-8?B?K2Q2azljYUkwK0RQM1U3Q1FucmVhdTBYMC9FaklaUzNSSkQyRVQ3ak9Za1Nk?=
 =?utf-8?B?NXFmY3VGeFlmQm1UOVNyeURHMkVGYmYzdVpha1FpS0lVQ3lFQnV1RVBwUit6?=
 =?utf-8?B?aDNIWkxQdGpZT1Q3MmNhRjk2S2dEazEzWGdsMmZhYnY5SStFQ3FwYkxieUtK?=
 =?utf-8?B?MEpiOTUxajVscmFBRjg2a2RPK3lKWURYYXNtaXVkdTY5ZUhHdno2UnJrV2d0?=
 =?utf-8?B?QnUxWStFSVFqczFOMjU2SkMyOW5mby9iTWgvR0RYbGNVZDdNdkQ4Y0U0b2M2?=
 =?utf-8?B?UUZMaFpaRExZQmFNTUQ1U2RJY1RWVUxYTHJHMmNUd3J1V1hIWnY2bE1ZZ0VM?=
 =?utf-8?B?eXMvSGZFRW1vWUVhR2tTOVk2U21ReG90dS9LRmJ6L3luVTROWlBFZmgzVnBh?=
 =?utf-8?B?dnZkTmJsVnk1bk1QOG1rVWtza0tyd092OTlYc204emsvOWE1VjFRZ0VENVFn?=
 =?utf-8?B?T1V5czFQMVlGSkx2VkpidHBQV05TbkZyalpyRjN6azN3cUVpVjZMNnA3R1U4?=
 =?utf-8?B?UUxIK3ZTSnA4OTZjbG5PNWgreFI4MzV3aTZqZFoyTlpnaWRGMm82Smtaek1T?=
 =?utf-8?B?V3U3MWRDeW52SllBR2FVYzlEUUhsNGdsVXFPNGtBWE1vN3JSQ0RjU2FXWlJ3?=
 =?utf-8?B?YmdHUHp5N1dodGt1bVA1VTZHN1p0VkkyNGF2cXFhelNrc01VZzVIelZOaHhI?=
 =?utf-8?B?NitwQzVzNEk3T0tEcWlkT0lqMm5Yc1BNMGptRkNhVVcrL1JzN0FIMG4xK1pT?=
 =?utf-8?B?eXVEajVzY3NSTUpaYk4wTEdpQWtNOVFqelhCMWlEdnFNRUpRVWNZYkxodUlZ?=
 =?utf-8?Q?pqhyLaNC7qXvuDNccpf6Fjrou?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df165f08-f52e-4a1f-0996-08dbd1313afb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 05:55:57.5751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A58+UT5bAAMFj8FESzND9Rw+VGGTC48upG/ApWhRHo5sK5V7ZvUAHY+ovilRGrGkIeSyMagvIqYm1Z94V3NiVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7405
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKb2FvIE1hcnRpbnMgPGpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb20+DQo+IFNlbnQ6
IFRodXJzZGF5LCBPY3RvYmVyIDE5LCAyMDIzIDc6MzkgQU0NCj4gDQo+IE9uIDE4LzEwLzIwMjMg
MjM6MzgsIEphc29uIEd1bnRob3JwZSB3cm90ZToNCj4gPiBPbiBXZWQsIE9jdCAxOCwgMjAyMyBh
dCAwOToyNzowMlBNICswMTAwLCBKb2FvIE1hcnRpbnMgd3JvdGU6DQo+ID4+IFRocm91Z2hvdXQg
SU9NTVUgZG9tYWluIGxpZmV0aW1lIHRoYXQgd2FudHMgdG8gdXNlIGRpcnR5IHRyYWNraW5nLA0K
PiBzb21lDQo+ID4+IGd1YXJhbnRlZXMgYXJlIG5lZWRlZCBzdWNoIHRoYXQgYW55IGRldmljZSBh
dHRhY2hlZCB0byB0aGUNCj4gaW9tbXVfZG9tYWluDQo+ID4+IHN1cHBvcnRzIGRpcnR5IHRyYWNr
aW5nLg0KPiA+Pg0KPiA+PiBUaGUgaWRlYSBpcyB0byBoYW5kbGUgYSBjYXNlIHdoZXJlIElPTU1V
IGluIHRoZSBzeXN0ZW0gYXJlIGFzc3ltZXRyaWMNCj4gPj4gZmVhdHVyZS13aXNlIGFuZCB0aHVz
IHRoZSBjYXBhYmlsaXR5IG1heSBub3QgYmUgc3VwcG9ydGVkIGZvciBhbGwgZGV2aWNlcy4NCj4g
Pj4gVGhlIGVuZm9yY2VtZW50IGlzIGRvbmUgYnkgYWRkaW5nIGEgZmxhZyBpbnRvIEhXUFRfQUxM
T0MgbmFtZWx5Og0KPiA+Pg0KPiA+PiAJSU9NTVVGRF9IV1BUX0FMTE9DX0VORk9SQ0VfRElSVFkN
Cj4gPg0KPiA+IEFjdHVhbGx5LCBjYW4gd2UgY2hhbmdlIHRoaXMgbmFtZT8NCj4gPg0KPiA+IElP
TU1VRkRfSFdQVF9BTExPQ19ESVJUWV9UUkFDS0lORw0KPiA+DQo+ID4gPw0KPiA+DQo+IFllYXAu
DQo+IA0KDQpBZ3JlZS4gUGxlYXNlIGFsc28gYWRqdXN0IHRoZSByZWxhdGVkIHRleHRzIGluIGNv
bW1pdCBtc2cgYW5kIGNvZGUNCmNvbW1lbnRzLg0KDQpSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8
a2V2aW4udGlhbkBpbnRlbC5jb20+DQo=
