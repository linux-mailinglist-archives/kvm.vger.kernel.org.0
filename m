Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE978D910
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbjH3ScN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242489AbjH3Ium (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 04:50:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AA9CCB;
        Wed, 30 Aug 2023 01:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693385438; x=1724921438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KjZ6Cfl2oBI95wh8p6ocUhUgWoI1wky/0WBQSw4Wq04=;
  b=U1uvueDAOvL8l/AaQUzaqmJa71YZ1wZDxGnC417fkQg5LAgk/ot4DgW7
   EOas6ReDCpel0dz/vafVW3mR30vS7QXU0ALSvhHe72UWks1VQkNMSTnJO
   aCC7QgDeaYo2TWnHnUTirN6LrckiWE+fujNEhu9N1Tbf/l6bqldL07cdV
   be+KAGFJnAbi+Ot8o6cvUO3Xcsig3nUkgfInpyalvQsPEqmeYc1fc3SLL
   KJIlOT8kyRI4m+tFHIEL6gVOeH9erowXDMLhoDRWVY2yVTBWr8xXv2uro
   0HVnfb1Zbw0kNpr7mqvXx24NvybSQjlAfF+evXOPYTwo7q+Gnk+h7qxMs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="372991646"
X-IronPort-AV: E=Sophos;i="6.02,213,1688454000"; 
   d="scan'208";a="372991646"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 01:50:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="829160823"
X-IronPort-AV: E=Sophos;i="6.02,213,1688454000"; 
   d="scan'208";a="829160823"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Aug 2023 01:50:28 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 01:50:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 30 Aug 2023 01:50:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 30 Aug 2023 01:50:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hi2qJrTuw3qk/AT5VQlU0IJHKExbzBGI9ShxmeE0DXFjyZA9vCJBXXmHucobtWxK0UmBMdGSXbs+VYcbOV41pGwfCforRc3Ck9s/9e+HMmgRkiM9xB2FfV91mDmdzgEasyEe3TtenKh7rkO3NyH7UwqG80t+kciPPcoGnncm73S2RXLXIjYMyJvTIydUa/zGw/BKXb7EtlKVe7LCTQIVtqL3gIi0FrgmYvd547TzC6PnKNhc0vYDzf57Xe5MGfIXu7hQWHqLyOyYI7eSkK37UBWq9HXt8XPd+o8uMYIx38NAPqv8qfbCDWHS7lva1YAF2Crg1gdoKkKbxrL1JlgRfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjZ6Cfl2oBI95wh8p6ocUhUgWoI1wky/0WBQSw4Wq04=;
 b=c5bzSAv7xlLuwQSEwUalciArUFXVTXSeP6YjE/S3JnPZYJtUo0X4BQLfeuzIC2Tz2Oib9/A33yMXkkkK+56eMqqr08eYFlslrZSXPLAyR47WeqUKzO+Uq22kryD90MLIfAVeEklGNpeg7j9FJ69IdMLkyJcNHZcaPVscBqu9MPtnYUpG6H8qnOW3AXIxc0V6HpZeqYKyQWwl4JYa5YUAzIr4hzNTk4snSpA5XbsQf/99W7g7xNsIvUYJ7bvZGADWo4jDOzuuR05roTzSG2dK8kpBhdIsCDz1FKR54U9Mc8+kgCWk5Ny2WlR9MNfUiOeTWWmJk9LAElgGElv0uEqVdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5418.namprd11.prod.outlook.com (2603:10b6:408:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Wed, 30 Aug
 2023 08:50:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 08:50:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGRCACABkHzwIAADfCQ
Date:   Wed, 30 Aug 2023 08:50:23 +0000
Message-ID: <BN9PR11MB5276E7D9BCD0A7C1D38D624D8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB527624F1CC4A545FBAE3C9C98CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527624F1CC4A545FBAE3C9C98CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5418:EE_
x-ms-office365-filtering-correlation-id: 8938f0c8-d9fb-4e32-0fa8-08dba9362632
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vj6I9NjYfh7L6aE2PcrWBw2q0T3jp2XmQzOAE2AV8Xg79zd77Soeaq5coL+Cx0BAZJIa6M4y0UWAXPrR03YRquxDhAKkAeuyFopQQRpMbYWOH9y2Dc1qtor+qzXj1/RIrXz8FGfKykxyWlbw6OkSR61r9A20HgvtJ5xlL9yL5rTVBSheaPqqV1jkAu1t1yJh2BNcablhaN1BI65Od29Q0gyCkaJNVpaA2C5GZT52jnjD6PYR/E3hfeq3dk3ECetUSBP7RATPHLPiPpq50bIXm8zeUyoiElPak8cjjJYD7VLqCDvr/l0bnKNkDs2Gsv85/L4KV65PB6Dt9fTLrarC4H6apCczXCivCuGyhjeE5b8kdTocuSKaNNrTubBcFTQBbyzk2FhGXF9AJ1zgB6s+LpSgKxrGLjUYnKA3j15tJ3rBAXi35H0DMWGrcWCA5pqaojiTR448HrWwPsSnwFb1HwA+qrqt4SbHjZirZNHz+0nfytIJj3YMudCPqH4P5VfFNZ/2505FkPCa4G5ptDo0GjMaGw5Z1nPC/m4PFBXpzFZjY88RcQJAqsYJ9vH7hWXS0xqtq4rrDjUUK8y7EbHoCMT9cRk4CNOF0rzcM+jpPSDv6SQ6gjlxgh6ZXpfO0ChOzUIbk3wjzmBCAA2vTk/0uQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(396003)(39860400002)(1800799009)(186009)(451199024)(8936002)(110136005)(53546011)(478600001)(76116006)(122000001)(7696005)(66556008)(6506007)(66946007)(71200400001)(66476007)(64756008)(54906003)(66446008)(38070700005)(316002)(38100700002)(41300700001)(82960400001)(9686003)(2940100002)(26005)(5660300002)(8676002)(83380400001)(2906002)(55016003)(86362001)(52536014)(7416002)(33656002)(4326008)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzQweTU0RGtsOS92WEtpcnlTU3FubjBRZCtrSGtVRUtiOUJmSXcyQnFHa0Fy?=
 =?utf-8?B?SWlyaEFDb0ZiQXNlZ2tlUDZFN1o1eUVjWGpTanJ1TWU0V2dUT3VRcldhQ3JU?=
 =?utf-8?B?ZGV6VjNwN1pMMFhJWVhaME5BNDhwNzRIbm9UQnhZbXp3NmJsZUh2OE4wZEsy?=
 =?utf-8?B?TGRPRmV6a3RLclVWeGMyQzVIVmxRQW5hbFZsWjUzaFlZWmNtZ0pNRVdYdk4x?=
 =?utf-8?B?Qm1Fc1VGajNMRnIvRTNNTzlOY2M3ZUFzWDFIam90ZGxEVlNxc1V0cjNnSVBO?=
 =?utf-8?B?WGRoeEloZTRCT1F2cllmWGRwdXRTc05WSkNLd05xR3gzU3ljZ2g3SFBxYjJM?=
 =?utf-8?B?eDBSdjhDTVZUR2hQN2FPY2Q1Vk9ndURtRmIvSXNoMHlFUnVQdUlsZUUrdDBr?=
 =?utf-8?B?OWFDWk5aWUVMcU5sQzA0aDdiYkN0aEVTQ0RFWXZ5NmV1SC85cVNWRklPWElq?=
 =?utf-8?B?WlFzU0dFL0FvdUJJM0tkVUFYaks2aW5iOGpYWjRIejQ2SkY0UTcwanhNcGVE?=
 =?utf-8?B?b2VncXhYQVpzWGdEc2JXWWdCbVdYb2NIdTVDc1h4QmFyNW9qajlBTjB3VExu?=
 =?utf-8?B?bDJXVVVZRTIxajFWYjdwYkp2NjI3NmJGWnJ1R2dRMlE1eEYzZ0hkbjQzMExr?=
 =?utf-8?B?MTUwcFhSdlRweUR1d0NYSnBpMWtXWGlnNnJuYU5HbUxxd245aWNSbkdSZGo0?=
 =?utf-8?B?cTM1V09XVUV4eWUwKzNVd3pTWDJuMXRweS9lUW4zY3hPRndYZnNaYTREdy93?=
 =?utf-8?B?R1lvNWlWby9MUnE4MjMvZkR6STJObFY5dmZaSFRlWFZJT0NXKzFIanB5VldI?=
 =?utf-8?B?QVFyNVFtVVNDcGswaFZlOXRGcHJoOWVwYnBkUm9ydXh0SG1pSGRRaXlrTUt0?=
 =?utf-8?B?MUdYVE9wUUtYTjU1UUpVOG1Sam5rblM2U1V1Z0V4YU15SUlXSS9zZklVNWVG?=
 =?utf-8?B?dXZlamZVcEdsZ1hJOGFWQTkzMHJyNDVpZjhkZmdzaWk1UThwelljOEpoUS91?=
 =?utf-8?B?VEdFZ2pDYjlZS2xMaDVPSjNOZGV5S3J0YSszWFNKZGNoQTRpRnNMTDZNYUtk?=
 =?utf-8?B?RDR2c1R0eWY5ZjVUSTZmOW9FVE9xQ0RwdERPMzZLOEVOeS9oMms5ajdlcitM?=
 =?utf-8?B?cE4wSGN3RmIwY3gxU3VIYTg1dXFNYy9KeXUwL1RjM1FwM29VU1JWakVtRFBk?=
 =?utf-8?B?ci9XS0lVV0R3NmZydE9teStnZzZnT3NVSU1PQytnUFZkTGxyTHNscWpicnlW?=
 =?utf-8?B?dFNzQTNCQkZpRnJpZEV3eTZ1TG9ta2tWb21FM1ZFM0RWeVNFNm9PVDVHcHVE?=
 =?utf-8?B?ZU9scURuTFRudldxb1FjdUM3OVlXWDlObkxxOVQ2L0w2V0wrOFRJYnVzZ042?=
 =?utf-8?B?dGFSNW4zZWwvcVpsVGxJUmhPbFh3WVR3RjA1bitaVno1YXkzMi9pQ2lyRXVn?=
 =?utf-8?B?UEMxQUFiU0tLNVR6MlIzR1ZZcVJSZVNxWitRaFVmd1JmbE9ESWtRZ1JJQWpZ?=
 =?utf-8?B?SVVuSmZTRGFxUmR4aXZWK0Y1Zks3U0lQRmI1MjVHbWxBbGZJbW1STEFObkZV?=
 =?utf-8?B?QWNWK0czbjNCV25lN3pOWktqUUdnM0FwS2RrcEZoSlBFWVBmbXMvWkNQWjBQ?=
 =?utf-8?B?MEJ4VFFuM2FST0p3SjQ1VFluR0lBZWM4T3drRy9ySzNnZDNsUFpKK0VjQ0RU?=
 =?utf-8?B?bTB0dldpNGVxd1Rpc2MrWTZMYXl0UXhHTHVlMElGdmFIdkNyRmk4Nk9UMkhC?=
 =?utf-8?B?bnlMMm9vV1EvSm92VXZvWkgxbjlmbkRjWFNEclZybEVDT092THdrd2pKZ2xo?=
 =?utf-8?B?T3U5aTBEaXgyQUg1MDdpU0ZETHMxMGJjQUI1OUZvYlQ3S1RXb2RIdEZ3ZGY4?=
 =?utf-8?B?TUorL01XVXJRclpvN1JmRm5UeC9saFF1empzdTVESGd0R3oveU05Uk9KS2Zs?=
 =?utf-8?B?aHRMc3FDeXEwRVFFQTVBT0dQQjBjWThNaktHeUtxMVM3WFYwZDJoRW9LTWll?=
 =?utf-8?B?ZjdyNjlTd2cvWlVGTXZWakVLUnhJOEZESjFiMWJuM2h3akhWV3c2YW9Qbmlo?=
 =?utf-8?B?Tyt1alFRZFhMUlhUUlpxditDM1U2RTMxRGdUcFc4dXdsTWR1Uy9wOTB6WENJ?=
 =?utf-8?Q?W6OZBavgjc95/bDtuJu6z+jnv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8938f0c8-d9fb-4e32-0fa8-08dba9362632
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2023 08:50:23.6926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C/YQMBWzBW8u0aZrbMJ2QQKfqQ3XHXlC2hbuMgFXs/h2OM25YYBnVY6sIEQqJ85a50h5aMpB/BPeYTXL24VqmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5418
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCAzMCwgMjAyMyAz
OjQ0IFBNDQo+IA0KPiA+IEZyb206IEJhb2x1IEx1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+
DQo+ID4gU2VudDogU2F0dXJkYXksIEF1Z3VzdCAyNiwgMjAyMyA0OjAxIFBNDQo+ID4NCj4gPiBP
biA4LzI1LzIzIDQ6MTcgUE0sIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4+ICsNCj4gPiA+PiAg
IC8qKg0KPiA+ID4+ICAgICogaW9wZl9xdWV1ZV9mbHVzaF9kZXYgLSBFbnN1cmUgdGhhdCBhbGwg
cXVldWVkIGZhdWx0cyBoYXZlIGJlZW4NCj4gPiA+PiBwcm9jZXNzZWQNCj4gPiA+PiAgICAqIEBk
ZXY6IHRoZSBlbmRwb2ludCB3aG9zZSBmYXVsdHMgbmVlZCB0byBiZSBmbHVzaGVkLg0KPiA+ID4g
UHJlc3VtYWJseSB3ZSBhbHNvIG5lZWQgYSBmbHVzaCBjYWxsYmFjayBwZXIgZG9tYWluIGdpdmVu
IG5vdw0KPiA+ID4gdGhlIHVzZSBvZiB3b3JrcXVldWUgaXMgb3B0aW9uYWwgdGhlbiBmbHVzaF93
b3JrcXVldWUoKSBtaWdodA0KPiA+ID4gbm90IGJlIHN1ZmZpY2llbnQuDQo+ID4gPg0KPiA+DQo+
ID4gVGhlIGlvcGZfcXVldWVfZmx1c2hfZGV2KCkgZnVuY3Rpb24gZmx1c2hlcyBhbGwgcGVuZGlu
ZyBmYXVsdHMgZnJvbSB0aGUNCj4gPiBJT01NVSBxdWV1ZSBmb3IgYSBzcGVjaWZpYyBkZXZpY2Uu
IEl0IGhhcyBubyBtZWFucyB0byBmbHVzaCBmYXVsdCBxdWV1ZXMNCj4gPiBvdXQgb2YgaW9tbXUg
Y29yZS4NCj4gPg0KPiA+IFRoZSBpb3BmX3F1ZXVlX2ZsdXNoX2RldigpIGZ1bmN0aW9uIGlzIHR5
cGljYWxseSBjYWxsZWQgd2hlbiBhIGRvbWFpbiBpcw0KPiA+IGRldGFjaGluZyBmcm9tIGEgUEFT
SUQuIEhlbmNlIGl0J3MgbmVjZXNzYXJ5IHRvIGZsdXNoIHRoZSBwZW5kaW5nIGZhdWx0cw0KPiA+
IGZyb20gdG9wIHRvIGJvdHRvbS4gRm9yIGV4YW1wbGUsIGlvbW11ZmQgc2hvdWxkIGZsdXNoIHBl
bmRpbmcgZmF1bHRzIGluDQo+ID4gaXRzIGZhdWx0IHF1ZXVlcyBhZnRlciBkZXRhY2hpbmcgdGhl
IGRvbWFpbiBmcm9tIHRoZSBwYXNpZC4NCj4gPg0KPiANCj4gSXMgdGhlcmUgYW4gb3JkZXJpbmcg
cHJvYmxlbT8gVGhlIGxhc3Qgc3RlcCBvZiBpbnRlbF9zdm1fZHJhaW5fcHJxKCkNCj4gaW4gdGhl
IGRldGFjaGluZyBwYXRoIGlzc3VlcyBhIHNldCBvZiBkZXNjcmlwdG9ycyB0byBkcmFpbiBwYWdl
IHJlcXVlc3RzDQo+IGFuZCByZXNwb25zZXMgaW4gaGFyZHdhcmUuIEl0IGNhbm5vdCBjb21wbGV0
ZSBpZiBub3QgYWxsIHNvZnR3YXJlIHF1ZXVlcw0KPiBhcmUgZHJhaW5lZCBhbmQgaXQncyBjb3Vu
dGVyLWludHVpdGl2ZSB0byBkcmFpbiBhIHNvZnR3YXJlIHF1ZXVlIGFmdGVyDQo+IHRoZSBoYXJk
d2FyZSBkcmFpbmluZyBoYXMgYWxyZWFkeSBiZWVuIGNvbXBsZXRlZC4NCg0KdG8gYmUgY2xlYXIg
aXQncyBjb3JyZWN0IHRvIGRyYWluIHJlcXVlc3QgcXVldWVzIGZyb20gYm90dG9tIHRvIHRvcCBh
cyB0aGUNCmxvd2VyIGxldmVsIHF1ZXVlIGlzIHRoZSBpbnB1dCB0byB0aGUgaGlnaGVyIGxldmVs
IHF1ZXVlLiBCdXQgZm9yIHJlc3BvbnNlDQp0aGUgbG93ZXN0IGRyYWluaW5nIG5lZWRzIHRvIHdh
aXQgZm9yIHJlc3BvbnNlIGZyb20gaGlnaGVyIGxldmVscy4gSXQncw0KaW50ZXJlc3RpbmcgdGhh
dCBpbnRlbC1pb21tdSBkcml2ZXIgY29tYmluZXMgZHJhaW5pbmcgaHcgcGFnZSByZXF1ZXN0cw0K
YW5kIHJlc3BvbnNlcyBpbiBvbmUgc3RlcCBpbiBpbnRlbF9zdm1fZHJhaW5fcHJxKCkuIHRoaXMg
YWxzbyBuZWVkcyBzb21lDQpjb25zaWRlcmF0aW9uIHJlZ2FyZGluZyB0byBpb21tdWZkLi4uDQoN
Cj4gDQo+IGJ0dyBqdXN0IGZsdXNoaW5nIHJlcXVlc3RzIGlzIHByb2JhYmx5IGluc3VmZmljaWVu
dCBpbiBpb21tdWZkIGNhc2Ugc2luY2UNCj4gdGhlIHJlc3BvbnNlcyBhcmUgcmVjZWl2ZWQgYXN5
bmNocm9ub3VzbHkuIEl0IHJlcXVpcmVzIGFuIGludGVyZmFjZSB0bw0KPiBkcmFpbiBib3RoIHJl
cXVlc3RzIGFuZCByZXNwb25zZXMgKHByZXN1bWFibHkgd2l0aCB0aW1lb3V0cyBpbiBjYXNlDQo+
IG9mIGEgbWFsaWNpb3VzIGd1ZXN0IHdoaWNoIG5ldmVyIHJlc3BvbmRzKSBpbiB0aGUgZGV0YWNo
IHBhdGguDQo+IA0KPiBpdCdzIG5vdCBhIHByb2JsZW0gZm9yIHN2YSBhcyByZXNwb25zZXMgYXJl
IHN5bmNocm91bnNseSBkZWxpdmVyZWQgYWZ0ZXINCj4gaGFuZGxpbmcgbW0gZmF1bHQuIFNvIGZp
bmUgdG8gbm90IHRvdWNoIGl0IGluIHRoaXMgc2VyaWVzIGJ1dCBjZXJ0YWlubHkNCj4gdGhpcyBh
cmVhIG5lZWRzIG1vcmUgd29yayB3aGVuIG1vdmluZyB0byBzdXBwb3J0IGlvbW11ZmQuIPCfmIoN
Cj4gDQo+IGJ0dyB3aHkgaXMgaW9wZl9xdWV1ZV9mbHVzaF9kZXYoKSBjYWxsZWQgb25seSBpbiBp
bnRlbC1pb21tdSBkcml2ZXI/DQo+IElzbid0IGl0IGEgY29tbW9uIHJlcXVpcmVtZW50IGZvciBh
bGwgc3ZhLWNhcGFibGUgZHJpdmVycz8NCg==
