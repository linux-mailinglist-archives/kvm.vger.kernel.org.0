Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B33552985
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 04:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344601AbiFUCtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 22:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiFUCtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 22:49:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4121DA68
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 19:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655779789; x=1687315789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2yFYMVurS0vDaT1yN8uK1v11RdrN9cbpV1HnxGCMxzI=;
  b=K70F/hF4gv74Oj/JMvVnfoIOkjxmZi41woovpunej7ghp9Ho2jhYy+8T
   lTjCUP/b8poCbmI8h9vae67n7UH/pMReiZS43mFQ0/THWRFIxqVSqkxeb
   HYL+wCfCGQ47BhiSqEHKr9MB6Wb9qzx9Rg0ccK90h0l7WV5PSNpQuirKR
   ZSWtOikUIssed7KcJjT5lSHVH4lyzaLueHuD2raTDqIhTYynGuu3vVSGW
   2cjXCaWZLx5Zzvdyqr2nt1sYxO9GlDuKFyFciYNUehp40c/aNn+/Rcv5D
   yrg4ebFk1P0zQHbPH3SYc8AB8jeImB2aeAstwmcDmA7vwDNjr5Ls+tJzu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="341695455"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="341695455"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 19:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="714810715"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 20 Jun 2022 19:49:48 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 19:49:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 19:49:48 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 19:49:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FC8a0MzUxTbYBClZIAgKZ+pUx2yd9isurtjHwMPyFot3hzvgKewzNKwvX2vEKssyOZdI4qiWMnHzBWQ5J9iqm1kELyniGfoCHJtJmcopPRzx57dc0s/542GarKjTBoyQfB3sNl78fEoi7vfujaYgSTM47M6Xvc3MD7cxRRzMVH/UWtZe3PeUM2ElVtBi0b78Ufj8uV+MxG8bXjG0wGBDHKPBy/cSB80b1mdHYqikT8MT8aTseyuwCUpmN4nSjqxpDLkfJY4XJiW2oar5ULbV1p54mS5L9w4fEYmcuyts5XOYhIq5ieSeD9MvrnyzXullEcj523WQQ7mZLwDT5xNTzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yFYMVurS0vDaT1yN8uK1v11RdrN9cbpV1HnxGCMxzI=;
 b=cnZ3ADMhIMGNmMiZhqr+2t+dO6zoZo+eUfi93kSId5JzwObc4xvudyE8cmJAP8kovfXXYp6iGvx6zo0kYTyPRLsF87DoYX78yk8WnBCIM0+O/FuR/gEKyc+sYuxHBkFh3V7Ih8cl6TtRBf/H69OtHmFfSjL/LlQJCeeIpryK5KbQNjCFECSEW2x6dzKScgphmjIVm1yhVJsPiiMuCsM1dCW2cy4OMfiuGkbeVb+ptKIbu8SpUifWYF6MUPifZANSWqw10hV/5mqwyAS31+2J53DtD05dsvxcPkxuIE8Dp4JiQ6zucHo051D8fn780U4HbwuvmxqKmwep2P+U+vjv7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 02:49:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 02:49:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: RE: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Thread-Topic: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Thread-Index: AQHYhIOAV8ljw0oTzEiBb5r9QaTmKq1Yu02AgABZBICAABT3oA==
Date:   Tue, 21 Jun 2022 02:49:46 +0000
Message-ID: <BN9PR11MB52767FD0F8287BE29E0C660D8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
 <98a0b35a-ff5d-419b-1eba-af6c565de244@linux.ibm.com>
 <39235b19-53e3-315a-b651-c4de4a31c508@intel.com>
In-Reply-To: <39235b19-53e3-315a-b651-c4de4a31c508@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8de0e9e7-ee55-442c-ecae-08da5330b38a
x-ms-traffictypediagnostic: BN6PR11MB3988:EE_
x-microsoft-antispam-prvs: <BN6PR11MB3988EB69DAFA2D11E7A0AAC28CB39@BN6PR11MB3988.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nZV8f4LcgVdwMuKdOEjOgYN/y7qE2S2c160Z5a7hZTREo+iUb3b2Vyr7g8eMKv/vFSoYZ6LJbine5Ym0fzfeFNC6/Y1SGt6Mll8Og7Bujjo5hZUdUFqHrDIMH9DfdWzc2AJFGdob4n2VPsn9Frz6ZXXQWPbkXSyxlIoPx4yiBN9ufUYbrJaVkE5/yX6niOYKKot8m+iwHwLtckzHrz9SKTNbwTeCx0isDuMP0QrjPBnTSmgzaCxWvtL43igupVcEncbFVQheEm5fVG0MFJbUvGDG2AJ1gpiv/A8f6hZycwZo5Cp0r9DNFdH/rUsFNzmPHDHoOgJYHNfkdqUN5NAc/SFk/JK6o/BsIYTJgXU9F3fV7w7embOT6Zfgy7cVFLMI1XyBrEj8rZm3RFLrOtAAMbRUoyA15llZZSu3Zx7wngodgzwWBvIvNtfdyP6Z1p59+fmVnOsTh1OA79WOn6mDAK9VEiR/2HtLnzGdrgcqIyNoB6s2uYaYf0kPrbz/cATZcfm+y4m/MUQbkn+3IM1WpcvhaFAAyGx4OUXxKs4HaLV8OAB+1aluI2BhOYRYc7elVgvydue6BBGRsMpCgvGIu1kGF9OJZFIujhopDnv/aruTm/K8v6rI0UwI5Ji4lp7nt15hyezonPvx39VPnUXAJwXaxSWjWmBZ5A3Q8IODdOMH1uuzDyRnNAME9DcSDohiW9w+lL1pingPmYWTWKE8Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(366004)(376002)(396003)(9686003)(55016003)(122000001)(8676002)(38100700002)(8936002)(33656002)(6506007)(41300700001)(53546011)(54906003)(110136005)(316002)(478600001)(26005)(71200400001)(7696005)(82960400001)(186003)(66446008)(66946007)(83380400001)(76116006)(64756008)(66476007)(86362001)(2906002)(4326008)(66556008)(52536014)(38070700005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWlUK3paM2JTVkY4MnF0Wlc1MTBpaWFMRmJBQzBTaDFDRVZuRFF5NHk0SWt5?=
 =?utf-8?B?c1FKTWVieTZlUW1rUXNRZG9kMExha2F5dEluTElXMjFxZmVxMmYwMHh6UVQ4?=
 =?utf-8?B?bzlBZTNwbmNicHgxL1F2aFFna1VmUlNlb3FVajFXTjV3TUIzd3Z6WTRNUE1N?=
 =?utf-8?B?dWljRWZVUkVuZkRPK1pHWm03MUZYN0h1MXR2eGZ4RnRJYlBaaFhXL3NSUlpZ?=
 =?utf-8?B?Zm9Jd082WDNKdkcraUtWVTE1THpENzluTnFMRFVweEYxNjdYR3VMajMvZk1x?=
 =?utf-8?B?dVV1Vkt6NEZPUHZnU2U1S0JiU3lDU3ZONTk4Y2U4MURDblZKOHBacWZKWHU2?=
 =?utf-8?B?L0pSWWg2TzdSaE1nZDN6Uk9nSFVkK1NIUW9KOHlXSStJUHc1dzJRdjBxZW01?=
 =?utf-8?B?dWR6Z1dzRVpFMDNvZlNuNE5WSE16U3prZmo1VnVPaGwxWHpXRnM5cmxTbkhU?=
 =?utf-8?B?a2tXbjNZWDluN1B5NHdsNVNYWERGMW42M3Z1b2JZZzlXczFxSHZDSDBubVhK?=
 =?utf-8?B?U0VCUnVScVFxdkw1VmpKcjYyUlllZ3Q0VmhNa1NtU2hDKzVVenFtMGtieFdy?=
 =?utf-8?B?MkVGSHM2T2dWOXVRallIbm92R0liNnM4c2ljOGkrWjFCY3dVR3hEdEJoZGln?=
 =?utf-8?B?V3BqWjRwSnllT3ZteE1SazZQQXNFZTRJTzd5eU5RdXpRUDJIYTUwWm9NbG16?=
 =?utf-8?B?elg4eVJRVXc5d3poTnNPbTEyQkxObFlDdklOV2pQQ3RLSHBYck9oVzdtdDJG?=
 =?utf-8?B?ZVFuOXBpQ3FXNm5aTTN1Zi9DMnlmZy9YVUQyZ2lYUnoxdU4rK09ybXk2NFdK?=
 =?utf-8?B?S0pHREFKTW04OUhHV1hSRWgrMmhCRTRGTFlzS29wbDdpSVdsR1ZRbkgxRlZm?=
 =?utf-8?B?bWtyakkxSmJ2OGRMUUxEMUdSWmloRnNPWkxkcUZoaXR1UmZTLzZZdkV2RWk4?=
 =?utf-8?B?Y1VLMzNveTBqNmxoYmNPaWNmKzZ0ZFRHSm41QU9DMjI4dmhvd0JjYkJMTk02?=
 =?utf-8?B?VVRsV21CNTM1andPZm9iYXh1MjF5NWZDWHY5b1ErSG5MLzBqMW5xS1BOdWNa?=
 =?utf-8?B?UFY2dFFWOEUwVExTaDA1RmRtZmVJd0ZUdEF2Z0dGbHMycTl0cUV5TTJEOWdi?=
 =?utf-8?B?cTJGYURtbVdQTVJqVGZ2L2VXSmdLa1Q4SjVFNzZOTWkyMXc4R0xDVFhIMDVz?=
 =?utf-8?B?d2xGMEpnUkFzMWYrSXRQbnNYaVF2akRBWi9hWHkxdDU0MEpsU29oYkNDS0RL?=
 =?utf-8?B?Z1JPaDM5SHFhOTFIVURkZjdsaW1hNjBjaFFsWUNUWEFkRHQvODBQK0RsbFpj?=
 =?utf-8?B?UUtlS01YTWxmZUVpQWtQYmJZbGM4VFkxSE0ySmFtVzR1YWVmS0xkL3UrQVNk?=
 =?utf-8?B?QzM0VkNJTC9heGFnTkt5WXNGTS9ML0ttNlFISUp2LzQ1OHo1SFZkZmZmQXFP?=
 =?utf-8?B?M1RycEJYeGgrWWZ2WGE1Z3hsL1l4N0dSZ2xyMGhxQUY3QzBhaVZXVHpHZHd0?=
 =?utf-8?B?cmdLTzFSbUJOM0VrdnRzamJ0KzBKMGFKUmw2VDZDU24xSmNTTVNoLzEwbktn?=
 =?utf-8?B?cTllU1NLcmRrQjFGVzFQelpiWWpYVzlkb0xsTlJ6UGZGY3I2UWNERUFscHVQ?=
 =?utf-8?B?Y0lxOGtUSmpibTNzbmtlVHFTVHhsZFdLV3BzcHZ2U3lVMHFEalpEeERLVGdo?=
 =?utf-8?B?aU1TdFpWTmxZMXBITml4ZnFrZ3VTdTk3OXZGanpyVlhpUVpVSDdTMHhlbEgw?=
 =?utf-8?B?aEJKWWdLd00xQW1sdndJdXQrOS92MU9sTzJRN1pFRVBSYVpmdnhGbEFoQVc1?=
 =?utf-8?B?RGpqbE4zdE5VSUpUSnJ3MDhrN1dIVG1mekZzMzg3MlRvMXBRNUNuV1ViejE2?=
 =?utf-8?B?NnhXdTMrajROUFpLcTk3Qnlra05QTU05QU5zMDFyejcrMEtQK1M4SDBQMEF2?=
 =?utf-8?B?R3N0b2NxdTRoYTdNNzBvVHVHZmdNcmhWa0o5RjAvOHB5VlB1U3RVaWI1b2du?=
 =?utf-8?B?TFJHbmhScmdibFZ6SXo1ZDhkSmJnZS9WSk1jdHMrSE9Nb1FRU28ya0N1OTBy?=
 =?utf-8?B?WXdBZU91cDB2MzdaMU8zcUl5MEFNNnRhZi9LaXpwZlR6R09rUFhqYWdTdGZB?=
 =?utf-8?B?a0RXRFNYMUVLRzFmWllFT1JrNjVMWHdHUWd4d3NzbDR2U3RXQzZ1cnY1Wjdo?=
 =?utf-8?B?UWhab0hXYWJ2MFN1TFVoT24ydkVmdzh0MVA3NC9Vb1YzeGtJYXB4cVM2SEJj?=
 =?utf-8?B?TVRwSG1EMDZLY2NWcFdZMzJGYURYTFoxbzhDUG9ZQVNxclJzZWhEcXNBcEJJ?=
 =?utf-8?B?UXpoRGtFanMzQmRLYUR4dHZ4ZTdHOXZnc010OE5YNmdGdEcrZkNIQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de0e9e7-ee55-442c-ecae-08da5330b38a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 02:49:46.1483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eLrEF7jGGdq4qc1xof0moqVyUU2eGMPPM//5qVW9N+YxSJCV7OLWj7WEV/mpt50kapNwjkqG0XAMUTLrUP4A2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3988
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
SnVuZSAyMSwgMjAyMiA5OjMyIEFNDQo+IA0KPiBPbiAyMDIyLzYvMjEgMDQ6MTMsIE1hdHRoZXcg
Um9zYXRvIHdyb3RlOg0KPiA+IE9uIDYvMjAvMjIgNDo1NCBBTSwgWWkgTGl1IHdyb3RlOg0KPiA+
PiBObyBuZWVkIHRvIHByb3RlY3Qgb3Blbl9jb3VudCB3aXRoIGdyb3VwX3J3c2VtDQo+ID4+DQo+
ID4+IEZpeGVzOiA0MjFjZmU2NTk2ZjYgKCJ2ZmlvOiByZW1vdmUgVkZJT19HUk9VUF9OT1RJRllf
U0VUX0tWTSIpDQo+ID4+DQo+ID4+IGNjOiBNYXR0aGV3IFJvc2F0byA8bWpyb3NhdG9AbGludXgu
aWJtLmNvbT4NCj4gPj4gY2M6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4+
IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+DQo+ID4gU2Vl
bXMgcHJldHR5IGhhcm1sZXNzIGFzLWlzLCBidXQgeW91IGFyZSBjb3JyZWN0IGdyb3VwX3J3c2Vt
IGNhbiBiZQ0KPiBkcm9wcGVkDQo+ID4gZWFybGllcjsgd2UgZG8gbm90IHByb3RlY3QgdGhlIGNv
dW50IHdpdGggZ3JvdXBfcndzZW0gZWxzZXdoZXJlIChzZWUNCj4gPiB2ZmlvX2RldmljZV9mb3Bz
X3JlbGVhc2UgYXMgYSBjb21wYXJpc29uLCB3aGVyZSB3ZSBhbHJlYWR5IGRyb3ANCj4gZ3JvdXBf
cndzZW0NCj4gPiBiZWZvcmUgb3Blbl9jb3VudC0tKQ0KPiANCj4geWVzLiB0aGlzIGlzIGV4YWN0
bHkgaG93IEkgZm91bmQgaXQuIE5vcm1hbGx5LCBJIGNvbXBhcmUgdGhlIGVyciBoYW5kbGluZw0K
PiBwYXRoIHdpdGggdGhlIHJlbGVhc2UgZnVuY3Rpb24gdG8gc2VlIGlmIHRoZXkgYXJlIGFsaWdu
ZWQuIDotKQ0KDQpJbiB0aGlzIGNhc2Ugd2UgZG9uJ3QgbmVlZCBhIEZJWCB0YWcuIEl0J3Mga2lu
ZCBvZiBvcHRpbWl6YXRpb24uDQoNCj4gDQo+ID4gRldJVywgdGhpcyBjaGFuZ2Ugbm93IGFsc28g
ZHJvcHMgZ3JvdXBfcnN3ZW0gYmVmb3JlIHNldHRpbmcgZGV2aWNlLQ0KPiA+a3ZtID0NCj4gPiBO
VUxMLCBidXQgdGhhdCdzIGFsc28gT0sgKGFnYWluLCBqdXN0IGxpa2UgdmZpb19kZXZpY2VfZm9w
c19yZWxlYXNlKSAtLQ0KPiA+IFdoaWxlIHRoZSBzZXR0aW5nIG9mIGRldmljZS0+a3ZtIGJlZm9y
ZSBvcGVuX2RldmljZSBpcyB0ZWNobmljYWxseSBkb25lDQo+ID4gd2hpbGUgaG9sZGluZyB0aGUg
Z3JvdXBfcndzZW0sIHRoaXMgaXMgZG9uZSB0byBwcm90ZWN0IHRoZSBncm91cCBrdm0NCj4gdmFs
dWUNCj4gPiB3ZSBhcmUgY29weWluZyBmcm9tLCBhbmQgd2Ugc2hvdWxkIG5vdCBiZSByZWx5aW5n
IG9uIHRoYXQgdG8gcHJvdGVjdCB0aGUNCj4gPiBjb250ZW50cyBvZiBkZXZpY2UtPmt2bTsgaW5z
dGVhZCB3ZSBhc3N1bWUgdGhpcyB2YWx1ZSB3aWxsIG5vdCBjaGFuZ2UgdW50aWwNCj4gPiBhZnRl
ciB0aGUgZGV2aWNlIGlzIGNsb3NlZCBhbmQgd2hpbGUgdW5kZXIgdGhlIGRldl9zZXQtPmxvY2su
DQo+IA0KPiB5ZXMuIHNldCBkZXZpY2UtPmt2bSB0byBiZSBOVUxMIGhhcyBubyBuZWVkIHRvIGhv
bGQgZ3JvdXBfcndzZW0uIEJUVy4gSQ0KPiBhbHNvIGRvdWJ0IHdoZXRoZXIgdGhlIGRldmljZS0+
b3BzLT5vcGVuX2RldmljZShkZXZpY2UpIGFuZA0KPiBkZXZpY2UtPm9wcy0+Y2xvc2VfZGV2aWNl
KGRldmljZSkgc2hvdWxkIGJlIHByb3RlY3RlZCBieSBncm91cF9yd3NlbSBvcg0KPiBub3QuIHNl
ZW1zIG5vdCwgcmlnaHQ/IGdyb3VwX3J3c2VtIHByb3RlY3RzIHRoZSBmaWVsZHMgdW5kZXIgdmZp
b19ncm91cC4NCj4gRm9yIHRoZSBvcGVuX2RldmljZS9jbG9zZV9kZXZpY2UoKSBkZXZpY2UtPmRl
dl9zZXQtPmxvY2sgaXMgZW5vdWdoLiBNYXliZQ0KPiBhbm90aGVyIG5pdCBmaXguDQo+IA0KDQpn
cm91cC0+cndzZW0gaXMgdG8gcHJvdGVjdCBkZXZpY2UtPmdyb3VwLT5rdm0gZnJvbSBiZWluZyBj
aGFuZ2VkDQpieSB2ZmlvX2ZpbGVfc2V0X2t2bSgpIGJlZm9yZSBpdCBpcyBjb3BpZWQgdG8gZGV2
aWNlLT5rdm0uDQo=
