Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2607E78D91E
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbjH3ScW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242238AbjH3HeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 03:34:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99303CC9;
        Wed, 30 Aug 2023 00:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693380839; x=1724916839;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J23J4n4uRLb/xDqPc9Zm6HlVWhRrui0EvsLP1P54lrU=;
  b=J6udDDE9+IY59F+0S6IudpR0176TPBS4qBUzjN2l9/gxmssJD8X4v3Zs
   llLhAt1uiWs/lZWfqcGLSfCTDzObm3dHmFUVmy1zd+UTpX4APSg4H7/Ge
   lpKPsxklSpPjaAybta8lfgpa3karE+4VGa76OQKzrplkeC92r7qmpypVz
   3FaV9DnMWO5m7BZhkq7KWNIlNoBSv91ZDolcXky/41QwEhzI9SM3NGky+
   Yy1Ds2rwvpZNJ9VsTmb7UvYXRj20iVsNsFSPRqPowUCEzft3gW56sCoLj
   3jx3TOtYedyiMRMgazOHY5XYIT/fm0btMS26IlHTFJ4nsedUWYfXQUfQW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="374478245"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="374478245"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 00:33:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="809023938"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="809023938"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2023 00:33:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 00:33:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 30 Aug 2023 00:33:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 30 Aug 2023 00:33:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjeL1eVUbo0BtUGu/owwNgc16S4goLixWbgixJ04m1RYEAZ/Z/my320usos5rIe5k8Jm4U9YhqMtiX8bBzDlmOBXCcZCdzkrfY1iSWtK7kgZmBheKyZMSUziv5QhvlUShWpVlCshngZwP3nojXbMAVSvuL/SzzoJVRpcYuSSwmIy6cXUXcNaAcyUoxZCm8ZfYb7KDXNeAuctAahvvjqkjoCuAv9gEgIs8s1r3XiGApUv936shVwAMuikX/OmjBkONIpQRddDv7ktlIVedvHEHadXGiEh8Rmuyd5FcjZ7V5G5fZOygOspr88Q4eUiaxSDeNEUDYtZlM93vB8XYyWdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J23J4n4uRLb/xDqPc9Zm6HlVWhRrui0EvsLP1P54lrU=;
 b=myCVwAFBiVp28gfhRStKJVGT/hzu85M8psESdGaVkpuENq+60DtTCxqhUXL/jmm8T2HJFpQIyP0wsCgP6BAA9rIsvFaeyg4QpJEKkI0LpyYK0/Wjj6YmhnzG+fhz4T5/PReUteTSklgOOPMt1VilKU9bl1uWeQNELHeQuB32FMM46+y42gG2O9y6DovP7YmxVvriGzekf83D0YcJ8vI++UmsWN7rT6wdukBAhZCD4JKc0he+3iqrPAhXJoJkH03pmnjkSYfsN9qRJDNGAH672CgBnMj1mAAiIbHOLp684534SooCiGBxBEut8p4HTwCPMBeed5DDgML7Wa4Sh6B8Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB8268.namprd11.prod.outlook.com (2603:10b6:303:1ef::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Wed, 30 Aug
 2023 07:33:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 07:33:52 +0000
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
Subject: RE: [PATCH v4 07/10] iommu: Merge iommu_fault_event and iopf_fault
Thread-Topic: [PATCH v4 07/10] iommu: Merge iommu_fault_event and iopf_fault
Thread-Index: AQHZ1vywN5WR0Q7gIEmdloJ1HEFD3a/6prsAgAGB1ICABlGeYA==
Date:   Wed, 30 Aug 2023 07:33:52 +0000
Message-ID: <BN9PR11MB52762CD142ECBC60C1DC1F958CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-8-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E342E0E774CABA484B258CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7985c942-0cdb-7637-6610-fa5a8963f2ae@linux.intel.com>
In-Reply-To: <7985c942-0cdb-7637-6610-fa5a8963f2ae@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB8268:EE_
x-ms-office365-filtering-correlation-id: 35d3f530-3e11-41c9-4d01-08dba92b7578
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rlkBEB/wKitYZmjEf1pBasb65db1tyvbH0Hv5+RjAZ690mBkFWdJwyHBdSzt+zgT6irm8NzedetpkeH+4ZZChnwmC9alAa+b3IH77I9HD3J8OLYe+RwDK/bRdtf6FW40m4dci0cXN0VnEU0Az9PSTl9rgqDDML/zc4XzvCNp8VfRzPr/FhlMECjvlbxLl5tlSFs16JTzaX09TXTI25tJRDNQVtYJLBJ2i1mF0rhzO5ey9Euo9cxJiHlQu3FedB+jejJ8j6rEEYuLaifbpOdGpanpK1yzAlhzh3lin470lbgsTk6g+rBxdEYQFXbJj8Z669tbJRfg4Ci1CRdwA8ofJvCgN2g/rRJI+2tTgF2EykcETNlfCyHtOgBKNaB6B8YtHgZ6u/c/lYQR/YYbjLvvgxGiccbapHWS/973G1DpuHWkcsfjy59e50MsvgxUV6V9SK/FmpLcrsrTiRav/thF5L7ILnyg73gETD30sKv4/X9X/vGq/K9cIDuZBxmoWtBpBlvF8r8KbBBl4hsTBDVSZ9pRM6/IS72NGR0IpBsWSYnXTXweNklsXhIDd/xpA0nDyIYUEqmmcDAGYKVUIF/eP81hc76YZcpc9SbRiUMhkM6xKwerPVnp7/kwIEfJ1y91
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199024)(1800799009)(186009)(66899024)(71200400001)(6506007)(7696005)(66476007)(9686003)(33656002)(86362001)(38070700005)(82960400001)(38100700002)(55016003)(122000001)(478600001)(26005)(2906002)(76116006)(53546011)(83380400001)(5660300002)(66556008)(4326008)(7416002)(110136005)(8936002)(8676002)(52536014)(66946007)(66446008)(64756008)(41300700001)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0N2M0ltbzFNTnJoRUt0aDZyN2p0N3N5OGlWczFCWTlmU29rb09yNHdLNElo?=
 =?utf-8?B?UEdVSHlLMTExSlVKa3ZSb1dLWjM2endxRkhCejZwYXk1dkJJOWV1SFR2aXM5?=
 =?utf-8?B?cTZLdlc3ODhSeTZlOFpZcmpwakYwSXg3Sk4vVVFBVHpXN0dsbS9uTlNNVWx6?=
 =?utf-8?B?Um80c1BReGExMm1iODJZWGxmTE5sSW1zYk11WGo2YTZEdldBUTVGbUk5WnZD?=
 =?utf-8?B?ZXJGMlR0S0JlVncrUnhqeVQzZUVxaXRVVXUzSktDdWFVOFVCSWlKRzdLNHpN?=
 =?utf-8?B?TGN5ZDA1a3NuOGlHbGJSOE1lbkNuZUJ5SVJPbVBKRkxJTXdyeG5HSG52WGZK?=
 =?utf-8?B?MU5Hd0lBQVJ6ZnRNNlhubi8wVTJMYm5xdHZyelVvSkdlM09nSTVHSUlqMTNM?=
 =?utf-8?B?RDFQc05DUzVZMlQ4VUtOR0VFRDVUbTAvYWljbWxYeFplaXFOTWdieitITWE5?=
 =?utf-8?B?TGlIL3RlNVkvcVdSUVdzWDRidjB6a01hczREdFZzeDYxTFJaaDlFSDh5dHNp?=
 =?utf-8?B?b3djZFdiNE82QXRCWlpqUXRIaGliRGJrWUN1V1cxN3VBbEI2UVc3NzhIdkMx?=
 =?utf-8?B?OTk4VE1VV2VHbnlhL1dSckozWEtCcmd5YUgvdnpUVDhMcUIxdzNzZkQwcExq?=
 =?utf-8?B?UmlTekxtUVR2SHFLOWt5enh3dExhUlp4Z0lQTmFGL3VFYTBMbmdYVHI3Uzd0?=
 =?utf-8?B?NkxldCtoSC9LVnF0WXZMMjcrdEd0bHM1SUJZbWRDSGkxdEhxQTVYSzN4Mlhh?=
 =?utf-8?B?djBnNkF0TzNQSk83UnJHZ1RCNWswcTZYdHVUVE1KVkdWSHNoWk1JKzFxTUd1?=
 =?utf-8?B?NTc2d3RadWJQM1dDUTRtWUo0ZEs5b1ZjbXltcGZXZjJQa3gxRXdIOWRwZ0Y1?=
 =?utf-8?B?dWcxNkw2S2I2ZHppMUJMT1gzb2hQaXcrbStxTytLOHBIbEh5S1BuVjRCTDFh?=
 =?utf-8?B?SGpybFUrQkZPUUQ1RjM1eGFtdHNMY0N3VVNQenFKTzFMUmx6Mlcrdi9vcW5K?=
 =?utf-8?B?WVJsOFhnQW1LRU1KT3hsTHVGZUg3R0ZKcmltckNUMEpVVFpqT0tFS2xnVFlH?=
 =?utf-8?B?K3NCbDNva0NSa0hqdk1XbTEwZUVQaFkvNHVnQkJkK1BRS0xYbXJzT05ZajJU?=
 =?utf-8?B?RVpqZTRYenlHNko2RUx0ajBPUkhkQnhBWUd5T3NsTXhVT0pUaDZmRWVNeGJY?=
 =?utf-8?B?c25FNnJpY0F2SCs2dGxBdFhMVjMvYTM1K2s2dU54Z2piUlQ1cEpBSDhwT1dx?=
 =?utf-8?B?NHhPaEp0elNpeXgxTzczTlVXUjd2djUyTW9zWnhyd2wrTWc3V1JseUN1d3Qy?=
 =?utf-8?B?OFl5QlRsUU9oanRNRVdUS2JIOXpMRVJtTm5qRGdPTzhZOVhxUFpTejVTSVEx?=
 =?utf-8?B?RVF4RSsxdHJCZ0I3azJGaVdIZWlHL09xT1V2WWJnMCtMZlRqY2NJV2RNTk1V?=
 =?utf-8?B?bDNzTU1IZVk3VUg3TFA2QUttbWt5OUpSV09CWm80T3NGSjd2L1FwMzl2RWdG?=
 =?utf-8?B?azNIYWpsZ0pOeWhoQnIvRGNEQmJKNkQ0QTJwd0pKK01FcWZkM0RqM3pFOVA5?=
 =?utf-8?B?S2RERlJBZWpMbFNOOFJqQmgwWnQzemZtYUE0MDVYbWtHeFdrZnkxQ1Jzamho?=
 =?utf-8?B?RmJCY2xmck5vQVJWeS9LMFptYm13QXpQTlBPL1U3Z09tMHFHbGthMnFVa2ht?=
 =?utf-8?B?ZHNjWXVydmRveGRMWmUrSkErdnNDWHpJSXZYTXRHN2Ztbmh2dWdQaVM4S2xJ?=
 =?utf-8?B?ejE2a2VzbFd5TkVhWTU1TUE2eUkwZHlHdzdPeHMwWkFMYlVXdFVLeHYyelVJ?=
 =?utf-8?B?YU5HcFhBVlZSNmJtNnl2dUZLdjVReERmZVo5UmFUamhxVmRiRk1VN2hJTnR3?=
 =?utf-8?B?UWp5UStNN1d5eU5XNVdpNGxGcVhmQ3E2TUs3RGVzMkl5OTdSbGtLbjIyanZz?=
 =?utf-8?B?ZFBNMTFKbFMraDRvRFdINjZGbFZaVzZIcUJHWWtCS2tORkEwa2tzMFk0Qm9O?=
 =?utf-8?B?cGpsZDRaS292VGdTVHpIWlBBNm1WbHZVaUFzcmdTWDRNa2N2RTFJT3dkZUE1?=
 =?utf-8?B?LzZQazdhUGV4OURkOU9BbXVZYzVjR3Jua2lPVkc4dWF4TDhwcGJBR2dCTFVx?=
 =?utf-8?Q?dE01O+9w3r1e2r114hdA+TBE0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d3f530-3e11-41c9-4d01-08dba92b7578
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2023 07:33:52.2552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3zYOB7wt1UscYMQnzz5LaPh6P5UYdglLFylRma0TDq/3su7G6vC5hgSkN4m9xT9vFN0o1FPcjrYMa71qlDL8YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8268
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgQXVndXN0IDI2LCAyMDIzIDM6MDIgUE0NCj4gDQo+IE9uIDgvMjUvMjMgNDowMyBQTSwg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+DQo+ID4+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDI1LCAyMDIzIDEwOjMwIEFNDQo+
ID4+DQo+ID4+IC0vKioNCj4gPj4gLSAqIHN0cnVjdCBpb21tdV9mYXVsdF9ldmVudCAtIEdlbmVy
aWMgZmF1bHQgZXZlbnQNCj4gPj4gLSAqDQo+ID4+IC0gKiBDYW4gcmVwcmVzZW50IHJlY292ZXJh
YmxlIGZhdWx0cyBzdWNoIGFzIGEgcGFnZSByZXF1ZXN0cyBvcg0KPiA+PiAtICogdW5yZWNvdmVy
YWJsZSBmYXVsdHMgc3VjaCBhcyBETUEgb3IgSVJRIHJlbWFwcGluZyBmYXVsdHMuDQo+ID4+IC0g
Kg0KPiA+PiAtICogQGZhdWx0OiBmYXVsdCBkZXNjcmlwdG9yDQo+ID4+IC0gKiBAbGlzdDogcGVu
ZGluZyBmYXVsdCBldmVudCBsaXN0LCB1c2VkIGZvciB0cmFja2luZyByZXNwb25zZXMNCj4gPj4g
LSAqLw0KPiA+PiAtc3RydWN0IGlvbW11X2ZhdWx0X2V2ZW50IHsNCj4gPj4gLQlzdHJ1Y3QgaW9t
bXVfZmF1bHQgZmF1bHQ7DQo+ID4+IC0Jc3RydWN0IGxpc3RfaGVhZCBsaXN0Ow0KPiA+PiAtfTsN
Cj4gPj4gLQ0KPiA+DQo+ID4gaW9tbXVfZmF1bHRfZXZlbnQgaXMgbW9yZSBmb3J3YXJkLWxvb2tp
bmcgaWYgdW5yZWNvdmVyYWJsZSBmYXVsdA0KPiA+IHdpbGwgYmUgc3VwcG9ydGVkIGluIGZ1dHVy
ZS4gRnJvbSB0aGlzIGFuZ2xlIGl0IG1pZ2h0IG1ha2UgbW9yZQ0KPiA+IHNlbnNlIHRvIGtlZXAg
aXQgdG8gcmVwbGFjZSBpb3BmX2ZhdWx0Lg0KPiANCj4gQ3VycmVudGx5IElPTU1VIGRyaXZlcnMg
dXNlDQo+IA0KPiBpbnQgcmVwb3J0X2lvbW11X2ZhdWx0KHN0cnVjdCBpb21tdV9kb21haW4gKmRv
bWFpbiwgc3RydWN0IGRldmljZSAqZGV2LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICB1bnNp
Z25lZCBsb25nIGlvdmEsIGludCBmbGFncykNCj4gDQo+IHRvIHJlcG9ydCB1bnJlY292ZXJhYmxl
IGZhdWx0cy4gVGhlcmUgaXMgbm8gbmVlZCBmb3IgYSBnZW5lcmljIGZhdWx0DQo+IGV2ZW50IHN0
cnVjdHVyZS4NCj4gDQo+IFNvIGFsdGVybmF0aXZlbHksIHdlIGNhbiB1c2UgaW9wZl9mYXVsdCBm
b3Igbm93IGFuZCBjb25zb2xpZGF0ZSBhDQo+IGdlbmVyaWMgZmF1bHQgZGF0YSBzdHJ1Y3R1cmUg
d2hlbiB0aGVyZSBpcyBhIHJlYWwgbmVlZC4NCj4gDQoNCkplYW4gc3VnZ2VzdGVkIHRvIGRlcHJl
Y2F0ZSByZXBvcnRfaW9tbXVfZmF1bHQoKSBhbmQgaW5zdGVhZCB1c2UNCmlvbW11X3JlcG9ydF9k
ZXZpY2VfZmF1bHQoKSBmb3IgdW5yZWNvdmVyYWJsZSBmYXVsdHMuDQoNCmJ1dCBub3QgYmlnIGRl
YWwgaWYgeW91IHByZWZlciB0byBpb3BmX2ZhdWx0IGZvciBub3cuDQo=
