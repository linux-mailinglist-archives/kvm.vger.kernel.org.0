Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C737823C2
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 08:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjHUGdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 02:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjHUGdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 02:33:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDCFA2;
        Sun, 20 Aug 2023 23:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692599615; x=1724135615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mnWqPL1jpRD3zTID5R2ZBg6dycXzEgZZ6O2Q87oFURs=;
  b=M4tOSofKgPz8/vyrsjrdwliiXYxRv6+vQETfv3RdQq2nMcTneJ0dnYAw
   +LgncE272vVjeIiLlR3YTA2J2uwPo7gA4W0bICAQZArTAXJBsSrO4Q+pt
   2eJsfBvIC/PmgzK/ohvi7KHQ+sz0UMWQAKAcPQ9ZVvrstgqf+EK6G4pMm
   xfqQXWglO49x5+QmMvvRiwaSLBIQITamkoTaTBk3jOPAWoRlL9XU1dWto
   T6OfVTVHbv05OzpwGTEa9r3riFFWsjMoq11TRyxUAhBcm8fIF9djOQ/C1
   h7cp0m0RfbQ5/03Rh5zDMDGAsl5IuUI53YF8wUycuUl+8+W6BAo5CZZVo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="437431873"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="437431873"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2023 23:33:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="738788851"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="738788851"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 20 Aug 2023 23:33:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 20 Aug 2023 23:33:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 20 Aug 2023 23:33:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 20 Aug 2023 23:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilkTMXQTD3YRD/1EouFvrMHqLlnC1S3xeXh5mCmXje+bPhhbf90Y28Sss75ygq+0R+9E1hWvhzupYk2+h4oVy42bn2csyQ6qwIZUrz+SiQQ2omQQ8ODbryus2seSOtSNhgkzycGO46kYSG/L+96P1O0DGDVuvs/VUxahE4WYlgcl/UPe1In0SyK+fyjuUX9zmo89h+NHjEoz8kobxrMdhH6kAt3gAZkXNeJ+LtonzHYpSlsY6RIeBQLuE9wJMml91WrCw+HUmgEqURYX0xEQV2KyPQFK4gSQ4Swux09ddIq8QZmEpRR7SctUF647p+UnWXTw3RmQxW8UjXImYAT9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnWqPL1jpRD3zTID5R2ZBg6dycXzEgZZ6O2Q87oFURs=;
 b=gxPrLVqg1EUG9xltC+OqwrpYvnXhAVYLyOVp8JItYrZYrM73hAt4qU/GhSYiBYiHunPA83NCIO27USW1WbRrAVu1j0gYWcwXxUpm/kxss6FK9punPVdsAvmi3NTqpnPHJGe007w4IIVBztIa7K+xxAIm76X6gM+kp3XveaM9vLHk+YEE9nI+rUpsJlmnevrz2JYVnkeChxGz/ag9MMHDDpE9qzHSCKWaneiVm1tDNDQHpxLcdZ7kzAka7fvjstwus6vgwoccHuwsRk3PCgE5AoTSJ93/trp/nkLoFHoWrIAALImGyBOB1O0MAXBTVkCk3T2dQD5P8+3PFri/hS6/fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6305.namprd11.prod.outlook.com (2603:10b6:930:23::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 06:33:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 06:33:27 +0000
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
Subject: RE: [PATCH v2 1/3] iommu: Make single-device group for PASID explicit
Thread-Topic: [PATCH v2 1/3] iommu: Make single-device group for PASID
 explicit
Thread-Index: AQHZzk2NHVN7+Xla/Uen90/PQyM06K/vcbqggATWyoCAAA098A==
Date:   Mon, 21 Aug 2023 06:33:27 +0000
Message-ID: <BN9PR11MB5276EBE5788713FBA99332F88C1EA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
 <20230814011759.102089-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E3C3D99C2DFA963805C98C1BA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <51dfc143-aafd-fea2-26fe-e2e9025fcd21@linux.intel.com>
In-Reply-To: <51dfc143-aafd-fea2-26fe-e2e9025fcd21@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6305:EE_
x-ms-office365-filtering-correlation-id: 13a30299-da54-4452-d1c6-08dba2108764
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ro8OXzMUddqYPv+ibEcLYZsg/7K2D5L4UuZgZ+6ovIPtBa6SavIsjCjP7rgMWzZLyIKb273FfV8poxXFAG3YEFrdFaIQ+xh+V8M8p8/mjTBApmMoiCXEUtYIj/G6yF1EFmWYBmCVyGmUH4Njf2BqRCT9rg8EXywhX2jrzX9IDlm86BvACQ0NCZ8Zq7LLY56VgYZHsjjkNgqlKXcvn//BvPBVL4wGzeLrb8QSupnr5dp0+a9IK8srEDaCnZk2hcgI/whTXey2NOHicWjZZZuUDERnezYE9aSyWwLsXk66xppEnDs/GIFEaA0kPUIB0cDXiSxd1GRYyf2rM7Ko5/M9Aw9/3cxW2O6D94aD5brGsXdnyND5ikmwnhquULWh8/1XDZMyYVq3Q081x8hsASpovFxsd5zMsJEpGL1feINtRbNx4mIkhXdzrAy7E3gnbLHzlDBS2bXUIwqfR8NrvR8U4EiYOX9UBDdfEN2jpp/Yg3KnDkHr2oy8P+DNppa32Lczb1CFVPyOQfPeX2WNe+81Rbfl3ZtyT5tILkpmXFzxFTOLD6mUKLIYWueuUwRBoJG6xJKLbBIYHKh68TJ8I2X0Jpxe1DXJvDwn+tKZUCL2mTzRZhiqjqjsaXOQBh7G+1m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(346002)(366004)(39860400002)(186009)(1800799009)(451199024)(66446008)(64756008)(54906003)(66476007)(76116006)(66556008)(66946007)(316002)(9686003)(82960400001)(110136005)(8676002)(8936002)(4326008)(41300700001)(122000001)(478600001)(71200400001)(55016003)(38070700005)(7696005)(38100700002)(53546011)(6506007)(2906002)(83380400001)(7416002)(86362001)(5660300002)(33656002)(26005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NU96OEExcmpBN2FjOVgwcDFleXJkL1MxZk5WU0FqYllrNFBLbmdTL0Nia3lu?=
 =?utf-8?B?TDlncGZkd0N5SEEzYjdLZTVTUFJDWFdqRVpGaXJBQ2hWUnB0L0ZEaHg4REdQ?=
 =?utf-8?B?UFhseVhnRTJBdzN5QzRuVWRLakpQajhJa1Q1dFoySmJVbTZlbVBENVg2UEFT?=
 =?utf-8?B?TnhobmpKSElUQ0xzcTAwc2RnSy9XVDAyZjU3Y29UWGxzTkJYRHJoTFNaWmhz?=
 =?utf-8?B?NHFoYVVpa21OZGdnb3Y4R2tBUFZUWFVKN2crcm5kenVpdk11Y0ZjUHBTMk4z?=
 =?utf-8?B?V0NTb2svbVh2Qy9kb1RjcGw0NFpyRXMyTkE0czVKMlJRNGpNRVpRTTZvT1RL?=
 =?utf-8?B?ZWVKNldUUUxGMHhBMHM3dTNGaGR1ZURLL1dXUnBMVTB5ck9Od2xNOWM1UXZN?=
 =?utf-8?B?cjBRVEViV1NzV0dEZ0QxcUJ2RDBJWk5seEtFSmIvUEpabVh1YW9EV1pCYlJj?=
 =?utf-8?B?VXphNitDR1dvODZRWVRkWDEzY3N1YlcrVHh6dWFmVGVqbzNrbTQ0bEpUYU9a?=
 =?utf-8?B?eVdtS0xIZUxNOC9XZ21ockkyMVF1Y01aZ0U0cHovQkJ2bmlnUUFWSnd0czdM?=
 =?utf-8?B?NFJ4a2dSTVhrSksxanZTZllsTHd5cDN3VExkVG5HQktnRHZkSk5ENnRTNmll?=
 =?utf-8?B?c2E1SEc1VlVsbTBRb2kzanlxWDNLdldndXZLckh6YTZSVlo4UTgwaStBSGhw?=
 =?utf-8?B?MTFVU29odkNqa1JPWXU0VkN1ZURsdFNGRXVVR0l5U0o1K3REb1ZabGtOdFlJ?=
 =?utf-8?B?Yi8xOEliK0tKWGlQUHlreG9yc0owdFJkcSs2Z3h1Z25SejRGZmV1RVZGcGpG?=
 =?utf-8?B?eWN3UmM4YjJiN0NEOXVJMmRIVGVadU1VWGJ6Q3FEWS85RDJZTUZ6UFhNRVlK?=
 =?utf-8?B?TEN4cVU1bVNjQm5QeWQ0dGZOc25PUmQ4V29sMWg5UzV2eEprbHFhV3l3VVdk?=
 =?utf-8?B?SW1RWVpYTkt0S0V1UDJNY3E0dmZua3hRTXI1RjI5YUkreXhsRUZCRzhiWmFk?=
 =?utf-8?B?M1pTVlk2WVdzMDdabGlxYmZDcHRZK1dSUmlLUk91SUlyeDEzTWdRc2wrR0RI?=
 =?utf-8?B?Z0JwU1NMVFd3QnZWWW1FQ3QwQnVWeEI3MERXbWhldDBOWVBTWm4vWElGMDA3?=
 =?utf-8?B?ajBQZjV2NGN0eFZhY2tjWXRhakdGT1psd0pmSUh2Q240ZVFmaUJXREloZW0x?=
 =?utf-8?B?MWFlL1Z2WllscXhPV0lBUzBWeHJLOFRnWDZaaEw3TERjUit1NUliV2NIVWha?=
 =?utf-8?B?dHVXY3NMRE9mUmhlZVliL3djNnJtTk1YUUs0MWFDUmo0OWVQQ2swelU3SHFw?=
 =?utf-8?B?OG84QW85N0dOSTc5Q1NYcVB5WUdYcHBSWXBab252MTg0Qml4WkkrR2FYaWFU?=
 =?utf-8?B?TlE5VzVyV3dzVHBINUhsTkVUZkpGQmt2YkFvN050NjlUOWNEZkgrTXRnYkdy?=
 =?utf-8?B?ak1VVUFncW1wRm1OdGUxZWkyMXlUTkVwd2h1OG5ySXhYNWd4YnNvTGVpNFhG?=
 =?utf-8?B?LzlXZjdmejNKZjhpdHo1UlBrVHpya1pINEZKclErRzJaVjg4UlFSbVlrVFpN?=
 =?utf-8?B?VlYrbzdraDdNOVMzWE1Ici9XWGJWdWlBRlRRY3EvUGcrQ0QyR2NPdjBwM1Nn?=
 =?utf-8?B?ajlQazlaNUh0MjlKblNFV3M4ZnFUVHVIR1Q0bnRnTnowMFVSRDR4b1Bhc2hu?=
 =?utf-8?B?RTRacFp6S3NpRVFXdGJrU0h2VVpmVStxSHpZeU8rdFNVaXEvdWdMeXNhbEJl?=
 =?utf-8?B?YTJrUHNNcFdSd0s0YlhHejhsZFZLVkFYZi9BSTlYek5DN3JRd0dXN1RwenBx?=
 =?utf-8?B?aWpXUUJPTHBhVy91K3JDSStMbG91OC9xNHFwZnYrQkhTQW1BaGwwenVrcThO?=
 =?utf-8?B?TWlnUFA2ME8wQmJwUlpWOWRzYzJVb05CQzhmNGt0MFNmQnZ6MTZNSnRWdVB2?=
 =?utf-8?B?aDBzUWtqWHM4TzIrcFRrT01aOGM4UktNS3ZDYitqalV2ZEhFSEFGYVYrVUpj?=
 =?utf-8?B?MlZOZytLWU1tZzhWd0QxK0FTT2xwelFBVEl1SEVPS2pWQjJDajdLN0J6aytw?=
 =?utf-8?B?UWhUNE9vL01pekVxT01VQy9oRU5ZN25aeGNMV2dXeHRhOXMweUhLbXRPZDhB?=
 =?utf-8?Q?ecSbmLw+ZKp2WI4GSxv6Q16oY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a30299-da54-4452-d1c6-08dba2108764
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2023 06:33:27.7194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Hd73r3jl6Qcrck7nJSv3xo7FXXcy0rkmxz6uwYZW/QavfR4xR7p3yZV+8qHC/3iFfNhlTJIMwfvRYhtlHWR2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6305
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

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIEF1Z3VzdCAyMSwgMjAyMyAxOjQ1IFBNDQo+IA0KPiBPbiAyMDIzLzgvMTggMTE6NTYsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50
ZWwuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEF1Z3VzdCAxNCwgMjAyMyA5OjE4IEFNDQo+ID4+
DQo+ID4+IFRoZSBQQVNJRCBpbnRlcmZhY2VzIGhhdmUgYWx3YXlzIHN1cHBvcnRlZCBvbmx5IHNp
bmdsZS1kZXZpY2UgZ3JvdXBzLg0KPiA+PiBUaGlzIHdhcyBmaXJzdCBpbnRyb2R1Y2VkIGluIGNv
bW1pdCAyNmIyNWEyYjk4ZTQ1ICgiaW9tbXU6IEJpbmQNCj4gcHJvY2Vzcw0KPiA+PiBhZGRyZXNz
IHNwYWNlcyB0byBkZXZpY2VzIiksIGFuZCBoYXMgYmVlbiBrZXB0IGNvbnNpc3RlbnQgaW4gc3Vi
c2VxdWVudA0KPiA+PiBjb21taXRzLg0KPiA+Pg0KPiA+PiBIb3dldmVyLCB0aGUgY29yZSBjb2Rl
IGRvZXNuJ3QgZXhwbGljaXRseSBjaGVjayBmb3IgdGhpcyByZXF1aXJlbWVudA0KPiA+PiBhZnRl
ciBjb21taXQgMjAxMDA3ZWY3MDdhOCAoIlBDSTogRW5hYmxlIFBBU0lEIG9ubHkgd2hlbiBBQ1Mg
UlIgJiBVRg0KPiA+PiBlbmFibGVkIG9uIHVwc3RyZWFtIHBhdGgiKSwgd2hpY2ggbWFkZSB0aGlz
IHJlcXVpcmVtZW50IGltcGxpY2l0Lg0KPiA+Pg0KPiA+PiBSZXN0b3JlIHRoZSBjaGVjayB0byBt
YWtlIGl0IGV4cGxpY2l0IHRoYXQgdGhlIFBBU0lEIGludGVyZmFjZXMgb25seQ0KPiA+PiBzdXBw
b3J0IGRldmljZXMgYmVsb25naW5nIHRvIHNpbmdsZS1kZXZpY2UgZ3JvdXBzLg0KPiA+Pg0KPiA+
PiBTaWduZWQtb2ZmLWJ5OiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+
PiAtLS0NCj4gPj4gICBkcml2ZXJzL2lvbW11L2lvbW11LmMgfCA1ICsrKysrDQo+ID4+ICAgMSBm
aWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9pb21tdS9pb21tdS5jIGIvZHJpdmVycy9pb21tdS9pb21tdS5jDQo+ID4+IGluZGV4IDcx
YjljNDFmMmE5ZS4uZjFlYmE2MGU1NzNmIDEwMDY0NA0KPiA+PiAtLS0gYS9kcml2ZXJzL2lvbW11
L2lvbW11LmMNCj4gPj4gKysrIGIvZHJpdmVycy9pb21tdS9pb21tdS5jDQo+ID4+IEBAIC0zNDA4
LDYgKzM0MDgsMTEgQEAgaW50IGlvbW11X2F0dGFjaF9kZXZpY2VfcGFzaWQoc3RydWN0DQo+ID4+
IGlvbW11X2RvbWFpbiAqZG9tYWluLA0KPiA+PiAgIAkJcmV0dXJuIC1FTk9ERVY7DQo+ID4+DQo+
ID4+ICAgCW11dGV4X2xvY2soJmdyb3VwLT5tdXRleCk7DQo+ID4+ICsJaWYgKGxpc3RfY291bnRf
bm9kZXMoJmdyb3VwLT5kZXZpY2VzKSAhPSAxKSB7DQo+ID4+ICsJCXJldCA9IC1FSU5WQUw7DQo+
ID4+ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gPj4gKwl9DQo+ID4+ICsNCj4gPg0KPiA+IEkgd29u
ZGVyIHdoZXRoZXIgd2Ugc2hvdWxkIGFsc28gYmxvY2sgYWRkaW5nIG5ldyBkZXZpY2UgdG8gdGhp
cw0KPiA+IGdyb3VwIG9uY2UgdGhlIHNpbmdsZS1kZXZpY2UgaGFzIHBhc2lkIGVuYWJsZWQuIE90
aGVyd2lzZSB0aGUNCj4gDQo+IFRoaXMgaGFzIGJlZW4gZ3VhcmFudGVlZCBieSBwY2lfZW5hYmxl
X3Bhc2lkKCk6DQo+IA0KPiAgICAgICAgICBpZiAoIXBjaV9hY3NfcGF0aF9lbmFibGVkKHBkZXYs
IE5VTEwsIFBDSV9BQ1NfUlIgfCBQQ0lfQUNTX1VGKSkNCj4gICAgICAgICAgICAgICAgICByZXR1
cm4gLUVJTlZBTDsNCj4gDQoNCndlbGwgc2luY2UgeW91IGFyZSBhZGRpbmcgZ2VuZXJpYyBjb3Jl
IGNoZWNrIHRoZW4gaXQncyBub3QgZ29vZCB0bw0KcmVseSBvbiB0aGUgZmFjdCBvZiBhIHNwZWNp
ZmljIGJ1cy4uLg0K
