Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D89B73F698
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjF0IP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjF0IP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:15:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133F8C7;
        Tue, 27 Jun 2023 01:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687853726; x=1719389726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=95AhkpaDjOgfA+Zu92tkBwBdlvvbzvYFBmRzv6ln470=;
  b=Vj+UxWags5riXndxvJZXEUdW5Jl5v+e7XtT8fxbBmCKGuuFkirsa6ass
   1WkKYH2K9+U5CMOyiV5B9UBdCINis29+7q8ovindoDN6q31zWCSF0QKdf
   idxpI6H5Qcam0SXAezaBLQGTrHI3MtsHOrw2hJv+qT9rhNRSNRG9Q333d
   0oTrBtPQAis3Wi/pXZtOWRaK59Z7tmAcCh3PIuhw+UlTcC3q5awgYlISm
   tACDdNbQ2e+Lpq7V+6MfDBDH+7zojiOPOKhWU5BefdCZwHFnmprUN7qMV
   5zIV0rnx5nxjlPIBeS9E87nemv9G8cs/4PAWPRgrrKaDEFk+1q5CH08Tx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="392003338"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="392003338"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 01:15:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="861021167"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="861021167"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jun 2023 01:15:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 01:15:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 01:15:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 01:15:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjuV9ZEXpOkxSLypGgN4C9S/mNM05/O3NMcHJY9EbZf8KpdVEV4EJWfTUicG2dKgEVb/MWeca/F0lXdjNrXOH+kAAmNVRqWgk5HRfB2phh1I7zYNBA3/bGn8R8JVJXnUEIus2SeLDhrizkA2VoJn7o67OkhJ/ApYe4mgvWgQinkCalBIQ8b6okBgBH9OBuH5eHSlhxP0x1s42vWl2s4f+EUArzrwfamaLEjSBqBFpoCpPDKHif6eHEj7gsoBx6AfpOthk42GKxdty9Ssfg+N9GispkJOPmjgmJ8I8sr15EarDWtEdJ1Piv9Ry8uD5db3PvGPH2QYedAAiVoMYP9/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95AhkpaDjOgfA+Zu92tkBwBdlvvbzvYFBmRzv6ln470=;
 b=T9XfrdcezOCmE0a7XJDY3UJkLLwpQCH0S4s8LrLukfZOXNYKSFyCaoQIMBxM76p0UkwJ7/05RvMcfJQVVVOfLRVbDrbEhaTJ0WJx7CROX4d4ElPeFm0PXB+syoE8F0OOZ43KuHsd2g8ErkyCxZT6i+Yujipm61iz+/LPsU7pQmaIb/ttOr6lYNpPMgaFQamTqmLBlbCWcjTSNtP8aMyqQiA+qWzsOXsvGbFdphJMEI/wg/RJ79cKLX4KM5Rd4xBgC1veSElrcI/1hViaFy5oLfPttGfWWIgx4np5eg6e5I2iMuRaR5ywTNB5racgy5uW0UCgOAWt6/D7hgTvc1Ociw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5894.namprd11.prod.outlook.com (2603:10b6:a03:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Tue, 27 Jun
 2023 08:15:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 08:15:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Topic: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Index: AQHZmPOfW21nPHSVEEOmSVh5Edp4ra+G3diAgAE6lgCAFk5D8IAAAm6AgAADRGA=
Date:   Tue, 27 Jun 2023 08:15:09 +0000
Message-ID: <BN9PR11MB527613D6C657A4AE0DE169758C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <8cc1d69e-f86d-fd04-7737-914d967dc0f5@intel.com>
 <69f50ced-e806-717a-0c74-a4cfa58600fa@linux.intel.com>
 <BN9PR11MB52768ACA721898D5C43CBE9B8C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f1b2e7fa-7be3-9e4b-1eba-5dba01b88c19@linux.intel.com>
In-Reply-To: <f1b2e7fa-7be3-9e4b-1eba-5dba01b88c19@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5894:EE_
x-ms-office365-filtering-correlation-id: 528bf595-aff4-4181-a68e-08db76e69fad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BuP3rK0WV00ZjtrnFzpqRCwIs2SEdrdgedQIjiIeeAf1Kp/3Tf90lmcXoycAlSWs9am1cvhxL1AgwV+9TkbUcjMECqzCzrrXH7MTiQbSsESg+0hDCUbdT8yLT0v/HUGj7OLwXhFqS5hCCIlLKlQoSA18GxM/sUD+9iUvF8UOjG6TsHKsaymsQko+CJIiQ+evZ0cUUSjzdhVkvqM7uWqiJcgkI+FgcElOuqn+mYT7Ybb4JZPC3kJCp3sf+hYrN3ZZap6NxwvWqS7zM4VHdrHoPTrNBilqTTPDtsDFhI2seoGlZDjKFPAppU5veC+uqSpYR0gJMRSgOOSn+kIZkvVcM2RFUEehdNeyiFOPRp5grQwU4mvdWgfomGvLlO9/ngZMbXbQ4Doo+vdvU+CfqtjnUU+nWd66SkMSTxXT8zUo9ePkrTHxGrOZCC/SgV976KRf4bZR++KtWUn1Vn6FY+Ndq6AMMVUBBrUszQ01GGAEfaIfx9OaIM5qHtnlPoCUDnx5jeagyiYFdJ0QSvSSvfoVvdtA6YcCizVLBZii/HCPumfb2QHVlWLXRsMOLXGwkemNa2I1RjTO+gtvuZv9i+fsv5reiUSXBHKBrLudFTFNmLTQ1QBe8xLv4kiGr1ZdA+S9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199021)(33656002)(122000001)(52536014)(7416002)(86362001)(41300700001)(66446008)(66556008)(38070700005)(64756008)(8936002)(4326008)(66946007)(76116006)(316002)(66476007)(8676002)(82960400001)(55016003)(38100700002)(5660300002)(6506007)(2906002)(53546011)(26005)(186003)(9686003)(71200400001)(54906003)(110136005)(7696005)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFkwR01pTUJDaVYxVkxmS3NKbUpsY2xhWjBKTk5nK1Jkalh4TG9RaEFwQkZm?=
 =?utf-8?B?WFNWQ1MrUytRRmo1MUE5MjJ4cE9SZ3NQWThaalYySXhHbThUOUJyd2ZZQXVm?=
 =?utf-8?B?a0lqNHBxaDJSK2ZkVTFxdzJpM2trR3I2cVFBRmJ6Z21paTJiL2poTnNZR253?=
 =?utf-8?B?ZkJNdkNFWXdqQkpmZ25XYkZobDMya1B3M08yRFhnb0EyYXBkK0RBdWh0eFg0?=
 =?utf-8?B?RnZCZms4VUZqT2lpd1p6aDcyaUlGTXpnTmwwcVlsclJVbzVpUmRKaXlvMVA2?=
 =?utf-8?B?UlJTWFZUSzNFekRXb2MyMk1sUzFWVlU0ZnJEbDc1ZFYvMUJ1R3dJRlhxdTRQ?=
 =?utf-8?B?QXpUUnY5R3JNOUVPOEt4R3VFakJJLzJ4akw2cnNhMVVld3Jid29UZmthRENH?=
 =?utf-8?B?S3N2dllSaXR4RWVlNjJvSG1HU21kbDArU1pHVkxwQ3RpbzJ1aW1jaXlINzYy?=
 =?utf-8?B?eXgzTVdNUmhSc3JJZWdENnBMTk13My85MnpoTThHeE1DVm5RZmcxYXA0azRU?=
 =?utf-8?B?bERxKzhTSmVtZWVrdkU0MWVLdDNoMk9DRnlTVlRPNjhTTVo3WlFjeXRMQVE2?=
 =?utf-8?B?a0ZuOU94OGtQclVhQVFRb201eVhwZnNoV0RaWWFZSG15N2pxS2xaVEZqTnZ3?=
 =?utf-8?B?KzJ0OVMyeDFkZll3SzVyT0NkKzd2dE1MZEVJTHBwKzEvV2FGYk1tY0Y2S0R4?=
 =?utf-8?B?VEtuVU8zTnUzZjFkSFpRVnBWUnVyV3dzQUhhUUNrZUVNWHNYVW5waVA0Q3NP?=
 =?utf-8?B?aHNoVG8yb3l4Zm1iNGRtaTUxamtXUEIrWCtHaW52UDdXUGdwN2RyT1Z5cDlK?=
 =?utf-8?B?a3Jnamd3alVtUEZUajZGSmhxYi8xb1hseVhWTWlCL0twT2hkRG5nMTFtUjVm?=
 =?utf-8?B?Zk5lT1FRRCtnSlFzZTJRUlRabzdKMmdXRmV1SFMxQTFtOVVYVHFFYmNkMzhY?=
 =?utf-8?B?OFVVWURBTWVISm9zbGVVUllhYTFkSVd5MEV1c0R2M2lEbGJ1YndJV0dpczN5?=
 =?utf-8?B?bEZPK0N3M0xKeXFTWXlpeVFsSUhXMlhXWXBGejg0MTEvdkhIQmwwZGlFcVhW?=
 =?utf-8?B?QmVFU1UyNWdRRnVZTTBjR3hMdzVoVE1ndCtGc2srTXB3RTdaQThZYUxBdjVw?=
 =?utf-8?B?bFhNQ1RDYmU3Q0dkZTdmQUVISVZxc1p0Uy9pN25COWFkTTZCclJlbzAwalR3?=
 =?utf-8?B?Tmk3aWUwcmlZaVpNMnVPOGZ0L21FbVlXUUIzWk5neFFvU3U4UDI1Y1RlMndV?=
 =?utf-8?B?cDduNWMwQm5vZVhEcFVyZnQwV3pabGw1VjVhOEs0Zis0bjA2OTR4YlRHbmZK?=
 =?utf-8?B?dm04TXFSTFRzYzJ0ckYvZTcrT0tDbUpkRWV0c2JGdkhscGZESVhETmhrREhp?=
 =?utf-8?B?S2FEUy9BR1dKMHpjbTZNL2hURzdNMmp0NFR3S3daYXMxQ1RCdGNrbk8vNStO?=
 =?utf-8?B?NGlwRFFvWFJJQmpOdzg2VTNtTFpGSjR1ZmlwZDVub0dQeTdNY3FlbHIzdjdO?=
 =?utf-8?B?K2poc1FHSEpsR0dJV0dkZktkM1ZpVGhXVWRCSkc0ZUp0cjk4Z1MwVGQxcURB?=
 =?utf-8?B?b2hCWXJzaHlDeURXVXoybjNvaUtyMTYvMENxdVlHTG5ybUt1ZlJIMnR4V2Jr?=
 =?utf-8?B?WnZKVjBkUklqS3piRXNJUzhyYUVUM3JqV09GbnUySDJOTUtFY25QTnpkQklO?=
 =?utf-8?B?ckJudnlPUzI5RExkVEVGOVNDYkxhakpSUmk3NHRGUk1qUEhMNEVoRkJHYzBV?=
 =?utf-8?B?bmZUbDQ3RHlWSVJOVEprdnZVWk9JdHI2cGpHbGJyaUwxdlg2MGNRc1NGS2l2?=
 =?utf-8?B?S0xrYnFLQ1dCRkVNRzVhKytncHBvZjdCVVM2TWU2NU5EVW1iYzZFS2JlQTNQ?=
 =?utf-8?B?ZEpTMWtxMnljcm1veXRIYWNCaUJqbHR2NlV6blhpMDl4RnBaRkNOanZ1ZlBo?=
 =?utf-8?B?K3JTQnc2Mk16c2VocVovMGsxUVVJNUdqdmhEelN3Wkd2eEN3K2FUU29zaWtl?=
 =?utf-8?B?ZFVsSTU2OUpjaUJLYUlhM1drYUpIZGx0WXpvbGoyeEdVOTBYVExPWWVkdG9T?=
 =?utf-8?B?a2phelg0dkhEVnFVZ0dBdXVUQzAwV2daaVgyME5jVFRJSS8wZlZyWmx3T2Vk?=
 =?utf-8?Q?+xaP2BqNru21kzqJSac1fAIs/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528bf595-aff4-4181-a68e-08db76e69fad
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 08:15:09.6246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvEDl7a6l9UMI+yb9uBMotjYnNQXmuhd1petbyrxM40Nwbw4Kihz5obybD76MaAW45cteURl5TmBYxLQri3gxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5894
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKdW5lIDI3LCAyMDIzIDQ6MDEgUE0NCj4gDQo+IE9uIDIwMjMvNi8yNyAxNTo1NCwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEJhb2x1IEx1IDxiYW9sdS5sdUBsaW51eC5pbnRl
bC5jb20+DQo+ID4+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMTMsIDIwMjMgMTE6MTUgQU0NCj4gPj4N
Cj4gPj4gT24gNi8xMi8yMyA0OjI4IFBNLCBMaXUsIEppbmdxaSB3cm90ZToNCj4gPj4+IE9uIDYv
Ny8yMDIzIDExOjUxIEFNLCBMdSBCYW9sdSB3cm90ZToNCj4gPj4+PiAtDQo+ID4+Pj4gLcKgwqDC
oCBCVUdfT04oIWRvbWFpbi0+cGdzaXplX2JpdG1hcCk7DQo+ID4+Pj4gLQ0KPiA+Pj4+IC3CoMKg
wqAgcGdfc2l6ZSA9IDFVTCA8PCBfX2Zmcyhkb21haW4tPnBnc2l6ZV9iaXRtYXApOw0KPiA+Pj4+
ICvCoMKgwqAgcGdfc2l6ZSA9IGRvbWFpbi0+cGdzaXplX2JpdG1hcCA/IDFVTCA8PA0KPiA+Pj4+
IF9fZmZzKGRvbWFpbi0+cGdzaXplX2JpdG1hcCkgOiAwOw0KPiA+Pj4gV291bGQgaXQgYmUgYmV0
dGVyIHRvIGFkZCB0aGUgZm9sbG93aW5nIGNoZWNrIGhlcmU/DQo+ID4+PiAgIMKgwqDCoMKgaWYg
KFdBUk5fT04oIXBnX3NpemUpKQ0KPiA+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biAtRUlOVkFMOw0KPiA+Pj4NCj4gPj4+IEluc3RlYWQgb2YgY2hlY2tpbmcgbGF0dGVyIGluIHRo
ZSBsb29wIGFzIGZvbGxvd3MuDQo+ID4+PiAgIMKgwqDCoCBpZiAoV0FSTl9PTl9PTkNFKCFwZ19z
aXplKSkgew0KPiA+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IC1FSU5WQUw7DQo+
ID4+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7DQo+ID4+PiAgIMKgwqDCoMKg
fQ0KPiA+Pg0KPiA+PiBJIGFtIGFmcmFpZCBuby4gT25seSB0aGUgcGFnaW5nIGRvbWFpbnMgbmVl
ZCBhIHZhbGlkIHBnX3NpemUuIFRoYXQncyB0aGUNCj4gPj4gcmVhc29uIHdoeSBJIHB1dCBpdCBh
ZnRlciB0aGUgaW9tbXVfaXNfZG1hX2RvbWFpbigpIGNoZWNrLiBUaGUNCj4gcHJldmlvdXMNCj4g
Pj4gY29kZSBoYXMgdGhlIHNhbWUgYmVoYXZpb3IgdG9vLg0KPiA+Pg0KPiA+DQo+ID4gWW91IGNv
dWxkIGFsc28gYWRkIHRoZSBkbWEgZG9tYWluIGNoZWNrIGhlcmUuIHBnX3NpemUgaXMgc3RhdGlj
DQo+ID4gdGhlbiBpdCBtYWtlcyBtb3JlIHNlbnNlIHRvIHZlcmlmeSBpdCBvbmNlIGluc3RlYWQg
b2YgaW4gYSBsb29wLg0KPiANCj4gQWdyZWVkLiBEb2VzIGJlbG93IGFkZGl0aW9uYWwgY2hhbmdl
IG1ha2Ugc2Vuc2U/DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pb21tdS5jIGIv
ZHJpdmVycy9pb21tdS9pb21tdS5jDQo+IGluZGV4IGU1OWRlNzg1MjA2Ny4uM2JlODhiNWYzNmJi
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2lvbW11L2lvbW11LmMNCj4gKysrIGIvZHJpdmVycy9p
b21tdS9pb21tdS5jDQo+IEBAIC05NjIsNiArOTYyLDkgQEAgc3RhdGljIGludA0KPiBpb21tdV9j
cmVhdGVfZGV2aWNlX2RpcmVjdF9tYXBwaW5ncyhzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4s
DQo+ICAgICAgICAgIHBnX3NpemUgPSBkb21haW4tPnBnc2l6ZV9iaXRtYXAgPyAxVUwgPDwNCj4g
X19mZnMoZG9tYWluLT5wZ3NpemVfYml0bWFwKSA6IDA7DQo+ICAgICAgICAgIElOSVRfTElTVF9I
RUFEKCZtYXBwaW5ncyk7DQo+IA0KPiArICAgICAgIGlmIChXQVJOX09OX09OQ0UoKGRvbWFpbi0+
dHlwZSAmIF9fSU9NTVVfRE9NQUlOX1BBR0lORykNCj4gJiYNCj4gIXBnX3NpemUpKQ0KPiArICAg
ICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQoNCndoYXQncyB0aGUgcmVhc29uIG9mIG5vdCB1
c2luZyBpb21tdV9pc19kbWFfZG9tYWluKCk/IHRoaXMgaXMgY2FsbGVkDQppbiB0aGUgcHJvYmUg
cGF0aCBvbmx5IGZvciB0aGUgZGVmYXVsdCBkb21haW4uIE90aGVyd2lzZSBpZiB5b3UgY2hhbmdl
DQpsaWtlIHRoaXMgdGhlbiB5b3UgYWxzbyB3YW50IHRvIGNoYW5nZSB0aGUgY2hlY2sgaW4gdGhl
IGxvb3AgbGF0ZXIgdG8gYmUNCmNvbnNpc3RlbnQuDQoNCj4gKw0KPiAgICAgICAgICBpb21tdV9n
ZXRfcmVzdl9yZWdpb25zKGRldiwgJm1hcHBpbmdzKTsNCj4gDQo+ICAgICAgICAgIC8qIFdlIG5l
ZWQgdG8gY29uc2lkZXIgb3ZlcmxhcHBpbmcgcmVnaW9ucyBmb3IgZGlmZmVyZW50IGRldmljZXMg
Ki8NCj4gQEAgLTk3NywxMSArOTgwLDYgQEAgc3RhdGljIGludA0KPiBpb21tdV9jcmVhdGVfZGV2
aWNlX2RpcmVjdF9tYXBwaW5ncyhzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQo+ICAgICAg
ICAgICAgICAgICAgICAgICFpb21tdV9pc19kbWFfZG9tYWluKGRvbWFpbikpDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gDQo+IC0gICAgICAgICAgICAgICBpZiAoV0FS
Tl9PTl9PTkNFKCFwZ19zaXplKSkgew0KPiAtICAgICAgICAgICAgICAgICAgICAgICByZXQgPSAt
RUlOVkFMOw0KPiAtICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gLSAgICAgICAg
ICAgICAgIH0NCj4gLQ0KPiAgICAgICAgICAgICAgICAgIHN0YXJ0ID0gQUxJR04oZW50cnktPnN0
YXJ0LCBwZ19zaXplKTsNCj4gICAgICAgICAgICAgICAgICBlbmQgICA9IEFMSUdOKGVudHJ5LT5z
dGFydCArIGVudHJ5LT5sZW5ndGgsIHBnX3NpemUpOw0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBi
YW9sdQ0K
