Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B1F6D8AF0
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjDEXKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDEXKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:10:18 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066306A7A;
        Wed,  5 Apr 2023 16:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680736216; x=1712272216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V9feS8fl4WTKnP8zy1KgVsR39NPEFn5xfWyI9M/ac84=;
  b=OtLGOhV48J4JzrUZS4Ap+gHaSXbLCPBSC2QyR603J2TstKJkKki28KcN
   NjrX6GbSXSKLKYfUwLvoiJSaCsm+JIBC4+dSlbVVO3TxGNy6+BM/dYjSF
   yxGYQgl1J0aEVeg7Ke6TXmsIZ/K9T82bo5VrjxNTz/TcyXzd0edg3afTo
   bW6Ygso+MClSCE5vjwaYZzkcvReYCLOL6BdF9AOCJctqfIsNEkVh/1Gh9
   4+SxJkw/UoPMy+POTFf+mUGixnsCATXMJt8kg7c5JhmRRZZDw91DvzvUp
   1pSXIJDwZzrnseoJALZC7PwtyAu8m44r7IbbW6xPpbjrpszYVMQtVdkri
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="407682210"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="407682210"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 16:10:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="1016655703"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="1016655703"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 05 Apr 2023 16:10:15 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 16:10:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 16:10:15 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 16:10:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1TA810Z57WD086mFVL1S3tWWKTygP4gkxmWD7JDSwlWpMwTQVknkKfwnPtMuGfEWu+jFf+XIbtVYJ5umc3YybRN/UUAU2XVlg+1XlzI0A6a/yGbdyV/gxqlCDknBmvOkmbeLZy7CBm06rpI5ORVtwpnvmE3LV59TvpMPm6swGSYVVP+HoALarYAqFsamkPqjuoIiislT0MMTAOlPGMm+s6husREwzrwt1zOthakjbjsI7rQDqomUxZUqD6wiEZjeKSXSoumaDy1MatND/BcuDNk3Q386pkDwivJwryVTVr7VEcBSdyFcz2NJ2IWRr6YtGKkM9Xt+TirdLrpDAqGFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9feS8fl4WTKnP8zy1KgVsR39NPEFn5xfWyI9M/ac84=;
 b=kydRxuJGFx8DGvwrK021k7MvUPM+ZS0EQwquRJdWMjkHbqkV628NDWWAW+dC2G2mjH2EDx9i/3ILm2UrJWshdhqHyUo3on4lLz/zyQzJx9fo6nEIob44934tf6hAM2BDCFqLl6gKA5NOKmG3McSAobi4AP9CSa+zujMgrU5xQFykSMSunc599vWwKUk1l/V6pRHjLAcd+hzm42bGo9YALlymNzLKplqrUXJDAnQzxlrbSE9c+l2B1DPTW2NCcoTTuKAgvOKSoyxLu6BBUh++Nf+MNse91pGZkjmaC6J8QrgNLrBzmrxgqKa2EpSVXzzUtWQbncUSIldsD8NFGaa1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6498.namprd11.prod.outlook.com (2603:10b6:510:1f1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 23:10:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 23:10:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZVQwsPOGReWj5Uka2uRq42SaKMa75keeAgAHjHYCAACbFgIAA9iwAgA0+bwCAByfygIAAFPmAgAFbIoCAABa5gIAAHfAAgAqtUYCAADMFgA==
Date:   Wed, 5 Apr 2023 23:10:11 +0000
Message-ID: <5dc84a2601a47ccc29ef43200cf3ec0d1b485d23.camel@intel.com>
References: <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
         <20230315072711.GF3922605@ls.amr.corp.intel.com>
         <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
         <20230316002702.GA197448@ls.amr.corp.intel.com>
         <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
         <20230328235839.GA1069687@ls.amr.corp.intel.com>
         <5896fb851d20de4aab55307a73e2b4a4243ca155.camel@intel.com>
         <20230329215609.GB1069687@ls.amr.corp.intel.com>
         <f02637a56848cff1a39a2c7e2350c11b180a87ea.camel@intel.com>
         <20230330010438.GC1112017@ls.amr.corp.intel.com>
         <20230405200733.GJ1112017@ls.amr.corp.intel.com>
In-Reply-To: <20230405200733.GJ1112017@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6498:EE_
x-ms-office365-filtering-correlation-id: 90b3b7f9-df62-438f-f1a1-08db362ae863
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Yute3MPTq8ISIERHffvv6XgwIjmX4B9/xf0egCVwfLhrTCIAF6y9KXi6QcoXm3RvgZzDB4M2z8V2PplLy2pI0RoDzk5qKuqpKIA3f5MkA4mk36MWRWingNvYme8CnwCLDgnRTJsqXv0GDFsxMn5tAa9gaQl+4LpFCDnQ/cDB3jw1e3XlANJ6tbEbR5HGfll0KDFYTo5p3GcuiwqFR/cyx3HzSiCGZskiG2up6rTZx3P2q/0pTlYB5StrKisOLfW5Id471SmZRXV/ZqE2njgWU2Ez9h0flISRwl2ltJk3qc/+DSfeCgqwPqC4bC6n1O/A9DYxJNbMz6RWdOaM9DjW1W9S4TH2HLsZ+iuIaZWjQIJogQ9zZ5iVKpaDu7qFd305pgkO8HF8pNtZxNqj/DtaBH9xSa9CnLfO2MeiPmCmXX3vXqx5ckxbk/B98zI8aOy3a0nd21ZFzMXJkWbMd8KoD8NLRCTQDG/3d5zl7cQ5HvwWyCjrabGJVCKZgsisMNpgukjUPgPsmnEKehgXz98weJ8DnBg8UXw6RT9ZhbzmHfxxJDC8SqJIhp1mYyT4zt6+HK/9Ne44AmutVw9iyWeX1iPR8QbJyHWno5mitstsHwgb/GQuRPdbS1DeVIb6hm3bFRRPg4kM05Q96+N0imo9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(2616005)(86362001)(2906002)(36756003)(38070700005)(107886003)(71200400001)(6486002)(83380400001)(186003)(6512007)(26005)(6506007)(478600001)(64756008)(66476007)(66556008)(66446008)(4326008)(8676002)(76116006)(54906003)(6916009)(66946007)(41300700001)(5660300002)(38100700002)(91956017)(82960400001)(122000001)(316002)(8936002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGlNUUc4bXRtdWM0eUNWTFQ2VkFrVGRCYXlnd1pQcWMzZXRSLzY3cmluWFFL?=
 =?utf-8?B?eWpqREp5MXE0a1BiQlR2QVROa05Qd0JnSWIzeXVGTVZxWDZaVlJXS2tBMTZ1?=
 =?utf-8?B?czN6YmdPRmlNa3V6NWFpbzAyODlRaFhKOUNyVStMZU5PRE9XcGVDZkpMdXkz?=
 =?utf-8?B?UzZkK05jL0VWdFJ0a0Q2OGhMdjZWNjRENk5FUWdRQ3kyTUtaam9ESFFJM0tZ?=
 =?utf-8?B?RllRLzUrUWNENTE5OVpZQkltU3ZKaUVSOTJQRDBNUnA5NDVZYkw3VEx1U1Zu?=
 =?utf-8?B?elV5WlFHWEZVSkkyT2hOaUlRc2lvZUVzL0ptVUtFdVppa1pJb205SUpBR2x4?=
 =?utf-8?B?UWVDTnNjd2VYaHlJakpzbi9sVVRRRHlCaDI0V1lZcVozaGhnbTRlcmlGU1hJ?=
 =?utf-8?B?SGoxVmtPS3VFRTEzM0dEKzdjK2xJaEpJZGdmNUhKY0JHbnk1RFB2UmdrQWhv?=
 =?utf-8?B?T1pkV0tXSHBHNTRIbFdKZTRVc0ZNRFl2clZQbUJWTXI2SDZodWU4bWFJcWoz?=
 =?utf-8?B?Sis0N3o2cGF0bnRGMjcwT3pFMnp3TXlGRnN6SmQ1NnA4ZkRKTWszMVVtWmVD?=
 =?utf-8?B?QmIzODdJTTAzU1NhVnA2Z2xTUlVVcjBtd3FjcUp5cjF3bDRMZzBHKzN3dzNC?=
 =?utf-8?B?dG5lMnFDTGVOOEowRDVWMU5mbncvTmVzY2ozeG10TTZpbzRXUXpiRG5wS2FV?=
 =?utf-8?B?d0kxRTZZdFVnbW53S1piTU1QZlQwZWpaTUZJbTFXSWN2Wk1oaUVhQVBjNTVn?=
 =?utf-8?B?Q21zR3pmYkpxcnUyd3pYT0JJWGEwRVU4cXVSc0p3cGpIK3ZKWGt0bXhVNjNx?=
 =?utf-8?B?eGVtaFhsZXBXU2x5Q1BpTUFOMDlYdWFqa29SazVra3RYVGlmd3JUYmlYaGlJ?=
 =?utf-8?B?R1RGcmpqdDU2RVJoUjZBRExKbUh0UmpIS2VZSVkyMlRYU0dHaERoZFhCc3VF?=
 =?utf-8?B?TVc0R2NCWkFsL3lzU25ITmVjZXNKMGpPTXZsOFQzc2dBbmNoYmpKaGR3VXU3?=
 =?utf-8?B?Q0VpWWw0dHI1VXh5ZER0ZUhNNGo0Wi8vNXJ3Tk5uWGVuUDc2M0JMeWpLK3FN?=
 =?utf-8?B?RFVwbi9ZdGIvMmFFRlVRY2owMnRFMFRYblVYeVdyVk9KblU4YnEvYWMxeSt3?=
 =?utf-8?B?V2NieHpIMGZVYWlDSmNEOGkyOEQycG1ud1ZZL2tuY09mSHptNHhuM28rVHVP?=
 =?utf-8?B?RGticmhHOVFnYmNJWUhjUDlSWVlMbFVhc3JrUlNVY0tSak9CbmdrdXd3SXAy?=
 =?utf-8?B?Zng2MHBaZU5kcVBYVkJvSU1EN2p1NTRsRkdOM1k0bElNYkthVDJuQ1RMTFdB?=
 =?utf-8?B?ZUFma1dRMzVDcHJMS0R4NU81TmhxZ1NycGxjMk1UQVVPMjhTQVFUUXpjbTl1?=
 =?utf-8?B?WllzNThoYVBST2IwYWljeUlvUVQrNUFrU0grTHA4dlVpaTBOOE1mTXo0bUJ0?=
 =?utf-8?B?aCtIWEwvckV5SUl5cTcxWVVKUWkxR0tIN1lrbkFqZmM0bXRvVUhiSDRhZHVv?=
 =?utf-8?B?bm12Q1luQ0VseTBtbDJvR1hWYnlNRFZGTVVyaU9WZCtheFg5SGsvOVZDa0pF?=
 =?utf-8?B?eGIxU3ZDOWtqZnVoeUptSnN4NU5UME5oTVNOR0lDOW0wN1g2RFpreW5GdVRx?=
 =?utf-8?B?aDZoRTNzNGt2Sll5QWRsZ2FOTHF2YStsLzJHTFBKcDhDSFRXYW12Q2xPSjBY?=
 =?utf-8?B?YmkxUk1iT1NhK1ZsaWdBd0NWSjRCZTZsWms3Uk1scnNDQVo2UTNjOUhPRlNi?=
 =?utf-8?B?T0V3RjdEVEF2bjE5MTZrTVg3ak5RNi8xRVR3RTZ0SzZicSthS2FrRVNGd0Zt?=
 =?utf-8?B?dmRiaWk3aVNodHpSMkZiQjFKRWNMTTRYWHV2eDVWNkpRQlYrQXVaSndUMkVv?=
 =?utf-8?B?RkkydG5OVzJlcExWQnJWemEwS3Nab3hVTlNiWGdPL2FzWE9JMGUxbXduY3pL?=
 =?utf-8?B?dU1BMUN0dmJmTnBFdng4WjlUV3BnZW1ENjVHVHZCVUNOYTBlSGFwc1RZNUZO?=
 =?utf-8?B?TlZRTE0zUGVTc1d5REE0QTdxRDhzeFJ0VUVqYjhxd1JmZ0J1M2lPRm5OQU5r?=
 =?utf-8?B?UXJaaU1LN3V2bmpQbFRoRDhVZm9FSFhxcnlTcDRGais5TDl6NVNUM3pRRG0w?=
 =?utf-8?Q?WzfN1LP41swebKMMyvYaGOxBd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18164376CE200F4A82E0D4E1C8A3872C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b3b7f9-df62-438f-f1a1-08db362ae863
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 23:10:11.8139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLv0gENwRATr3zkZnqfxIAnOElENLPOM7eRcPM9DoGXPmxigQM8onCTmm9bBlNd9zhiN6VbX6B2e4/rGyBXFzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6498
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTA1IGF0IDEzOjA3IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gV2VkLCBNYXIgMjksIDIwMjMgYXQgMDY6MDQ6MzhQTSAtMDcwMCwNCj4gSXNha3UgWWFt
YWhhdGEgPGlzYWt1LnlhbWFoYXRhQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiA+IE9uIFdlZCwg
TWFyIDI5LCAyMDIzIGF0IDExOjE3OjMxUE0gKzAwMDAsDQo+ID4gIkh1YW5nLCBLYWkiIDxrYWku
aHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiANCj4gPiA+IE9uIFdlZCwgMjAyMy0wMy0yOSBh
dCAxNDo1NiAtMDcwMCwgSXNha3UgWWFtYWhhdGEgd3JvdGU6DQo+ID4gPiA+IE9uIFdlZCwgTWFy
IDI5LCAyMDIzIGF0IDAxOjEzOjQ1QU0gKzAwMDAsDQo+ID4gPiA+ICJIdWFuZywgS2FpIiA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiA+ID4gIA0KPiA+ID4gPiA+ID4gPiA+ICsJLyoNCj4gPiA+ID4gPiA+ID4gPiArCSAqIFRE
WCByZXF1aXJlcyB0aG9zZSBtZXRob2RzIHRvIGVuYWJsZSBWTVhPTiBieQ0KPiA+ID4gPiA+ID4g
PiA+ICsJICoga3ZtX2hhcmR3YXJlX2VuYWJsZS9kaXNhYmxlX2FsbCgpDQo+ID4gPiA+ID4gPiA+
ID4gKwkgKi8NCj4gPiA+ID4gPiA+ID4gPiArCXN0YXRpY19jYWxsX3VwZGF0ZShrdm1feDg2X2No
ZWNrX3Byb2Nlc3Nvcl9jb21wYXRpYmlsaXR5LA0KPiA+ID4gPiA+ID4gPiA+ICsJCQkgICBvcHMt
PnJ1bnRpbWVfb3BzLT5jaGVja19wcm9jZXNzb3JfY29tcGF0aWJpbGl0eSk7DQo+ID4gPiA+ID4g
PiA+ID4gKwlzdGF0aWNfY2FsbF91cGRhdGUoa3ZtX3g4Nl9oYXJkd2FyZV9lbmFibGUsDQo+ID4g
PiA+ID4gPiA+ID4gKwkJCSAgIG9wcy0+cnVudGltZV9vcHMtPmhhcmR3YXJlX2VuYWJsZSk7DQo+
ID4gPiA+ID4gPiA+ID4gKwlzdGF0aWNfY2FsbF91cGRhdGUoa3ZtX3g4Nl9oYXJkd2FyZV9kaXNh
YmxlLA0KPiA+ID4gPiA+ID4gPiA+ICsJCQkgICBvcHMtPnJ1bnRpbWVfb3BzLT5oYXJkd2FyZV9k
aXNhYmxlKTsNCj4gPiA+ID4gPiA+ID4gPiAgCXIgPSBvcHMtPmhhcmR3YXJlX3NldHVwKCk7DQo+
ID4gPiA+ID4gPiA+ID4gIAlpZiAociAhPSAwKQ0KPiA+ID4gPiA+ID4gPiA+ICAJCWdvdG8gb3V0
X21tdV9leGl0Ow0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gSG1tLi4gSSB0aGluayB0
aGlzIGlzIHVnbHkuICBQZXJoYXBzIHdlIHNob3VsZCBuZXZlciBkbyBhbnkNCj4gPiA+ID4gPiA+
ID4gc3RhdGljX2NhbGwoa3ZtX3g4Nl94eHgpKCkgaW4gaGFyZHdhcmVfc2V0dXAoKSwgYmVjYXVz
ZSBoYXJkd2FyZV9zZXR1cCgpIGlzDQo+ID4gPiA+ID4gPiA+IGNhbGxlZCBiZWZvcmUga3ZtX29w
c191cGRhdGUoKSBhbmQgbWF5IHVwZGF0ZSB2ZW5kb3IncyBrdm1feDg2X29wcy4NCj4gPiA+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gPiA+IFNvIHByb2JhYmx5IHVzZSBoYXJkd2FyZV9lbmFibGVfYWxs
KCkgaW4gaGFyZHdhcmVfc2V0dXAoKSBpcyBhIGJhZCBpZGVhLg0KPiA+ID4gPiA+ID4gPiANCj4g
PiA+ID4gPiA+ID4gSSB0aGluayB3ZSBoYXZlIGJlbG93IG9wdGlvbnMgb24gaG93IHRvIGhhbmRs
ZToNCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IDEpIFVzZSBWTVgncyBrdm1feDg2X29w
cyBkaXJlY3RseSBpbiB0ZHhfaGFyZHdhcmVfc2V0dXAoKS4gIEZvciBpbnN0YW5jZSwNCj4gPiA+
ID4gPiA+ID4gc29tZXRoaW5nIGxpa2UgYmVsb3c6DQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+
ID4gPiBpbnQgX19pbml0IHRkeF9oYXJkd2FyZV9zZXR1cChzdHJ1Y3Qga3ZtX3g4Nl9vcHMgKng4
Nl9vcHMpDQo+ID4gPiA+ID4gPiA+IHsNCj4gPiA+ID4gPiA+ID4gCS4uLg0KPiA+ID4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+ID4gCWNwdXNfcmVhZF9sb2NrKCk7DQo+ID4gPiA+ID4gPiA+IAlyID0g
b25fZWFjaF9jcHUodnRfeDg2X29wcy5oYXJkd2FyZV9lbmFibGUsIC4uLik7DQo+ID4gPiA+ID4g
PiA+IAlpZiAoIXIpDQo+ID4gPiA+ID4gPiA+IAkJciA9IHRkeF9tb2R1bGVfc2V0dXAoKTsNCj4g
PiA+ID4gPiA+ID4gCW9uX2VhY2hfY3B1KHZ0X3g4Nl9vcHMuaGFyZHdhcmVfZGlzYWJsZSwgLi4u
KTsNCj4gPiA+ID4gPiA+ID4gCWNwdXNfcmVhZF91bmxvY2soKTsNCj4gPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiA+IAkuLi4NCj4gPiA+ID4gPiA+ID4gfQ0KPiA+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+ID4gQnV0IHRoaXMgZG9lc24ndCBjbGVhbiB1cCBuaWNlbHkgd2hlbiB0aGVyZSdzIHNv
bWUgcGFydGljdWxhciBjcHVzIGZhaWwgdG8gZG8NCj4gPiA+ID4gPiA+ID4gaGFyZHdhcmVfZW5h
YmxlKCkuICBUbyBjbGVhbiB1cCBuaWNlbHksIHdlIGRvIG5lZWQgYWRkaXRpb25hbCB0aGluZ3Mg
c2ltaWxhciB0bw0KPiA+ID4gPiA+ID4gPiB0aGUgaGFyZHdhcmVfZW5hYmxlX2FsbCgpIGNvZGUg
cGF0aDogYSBwZXItY3B1IHZhcmlhYmxlIG9yIGEgY3B1bWFza190ICsgYQ0KPiA+ID4gPiA+ID4g
PiB3cmFwcGVyIG9mIHZ0X3g4Nl9vcHMtPmhhcmR3YXJlX2VuYWJsZSgpIHRvIHRyYWNrIHdoaWNo
IGNwdXMgaGF2ZSBkb25lDQo+ID4gPiA+ID4gPiA+IGhhcmR3YXJlX2VuYWJsZSgpIHN1Y2Nlc3Nm
dWxseS4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IDIpIE1vdmUgdGhvc2Ugc3RhdGlj
X2NhbGxfdXBkYXRlKCkgaW50byB0ZHhfaGFyZHdhcmVfc2V0dXAoKSBzbyB0aGV5IGFyZSBURFgN
Cj4gPiA+ID4gPiA+ID4gY29kZSBzZWxmLWNvbnRhaW5lZC4gIEJ1dCB0aGlzIHdvdWxkIHJlcXVp
cmUgZXhwb3Npbmcga3ZtX3g4Nl9vcHMgYXMgc3ltYm9sLA0KPiA+ID4gPiA+ID4gPiB3aGljaCBp
c24ndCBuaWNlIGVpdGhlci4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IDMpIEludHJv
ZHVjZSBhbm90aGVyIGt2bV94ODZfaW5pdF9vcHMtPmhhcmR3YXJlX3Bvc3Rfc2V0dXAoKSwgd2hp
Y2ggaXMgY2FsbGVkDQo+ID4gPiA+ID4gPiA+IGFmdGVyIGt2bV9vcHNfdXBkYXRlKCkuDQo+ID4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBQZXJzb25hbGx5LCBJIHRoaW5rIDMpIHBlcmhhcHMg
aXMgdGhlIG1vc3QgZWxlZ2FudCBvbmUsIGJ1dCBub3Qgc3VyZSB3aGV0aGVyDQo+ID4gPiA+ID4g
PiA+IFNlYW4vUGFvbG8gaGFzIGFueSBvcGluaW9uLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBJIHRoaW5rIHdlIGNhbiBzaW1wbHkgdXBkYXRlIHRoZSBvcHMgYmVmb3JlIGNhbGxpbmcgaGFy
ZHdhcmVfZW5hYmxlKCkgYW5kDQo+ID4gPiA+ID4gPiBjbGVhbiB1cCBvcHMgb24gZmFpbHVyZS4N
Cj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhpcyBk
b2Vzbid0IHdvcmsgYmVjYXVzZSBoYXJkd2FyZV9zZXR1cCgpIG1heSB1cGRhdGUgdmVuZG9yJ3Mg
a3ZtX3g4Nl9vcHMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSWYgeW91IGRvIGt2bV9vcHNfdXBk
YXRlKCkgYmVmb3JlIGhhcmR3YXJlX3NldHVwKCksIHlvdSBuZWVkIHRvIG1hbnVhbGx5IHVwZGF0
ZQ0KPiA+ID4gPiA+IHRob3NlIHVwZGF0ZWQgKGluIGhhcmR3YXJlX3NldHVwKCkpIGNhbGxiYWNr
cyBhZ2FpbiBhZnRlci4gDQo+ID4gPiA+IA0KPiA+ID4gPiBXZSBjYW4gY2FsbCBrdm1fb3BzX3Vw
ZGF0ZSgpIHR3aWNlIGJlZm9yZSBhbmQgYWZ0ZXIgaGFyZHdhcmVfc2V0dXAoKS4NCj4gPiA+ID4g
DQo+ID4gPiANCj4gPiA+IFBlcnNvbmFsbHkgSSB0aGluayBpdCdzIHRvbyB1Z2x5LiAgDQo+ID4g
DQo+ID4gU28geW91IHByZWZlciB0aGUgb3B0aW9uIDMgdG8gY2FsbGluZyBrdm1fb3BzX3VwZGF0
ZSgpIHR3aWNlLiBPa2F5LCBJJ2xsIHVwZGF0ZQ0KPiA+IHRoZSBwYXRjaC4NCj4gDQo+IEFmdGVy
IHBsYXlpbmcgd2l0aCBoYXJkd2FyZV9wb3N0X3NldHVwKCksIGl0J3MgaW5ldml0YWJsZSB0byBj
YWxsDQo+IGt2bV9vcHNfdXBkYXRlKCkgdHdpY2UuDQo+IFdoZW4gVk1YIGluaXRpYWxpemF0aW9u
IHN1Y2NlZWRlZCB3aXRoIGhhcmR3YXJlX3NldHVwKCksIGJ1dCBURFggaW5pdGlhbGl6YXRpb24N
Cj4gd2l0aCBoYXJkd2FyZV9wb3N0X3NldHVwKCkgZmFpbGVkLCB3ZSdkIGxpa2UgdG8gc3VwcG9y
dCBvbmx5IFZNWCB3aXRoIHdhcm5pbmcNCj4gbWVzc2FnZS4gIEluIHN1Y2ggY2FzZSwgd2UgbmVl
ZCB0byByZXZlcnQgeDg2X29wcyB0byBWTVggb25seS4NCj4gSXQgZG9lc24ndCBtYWtlIHNlbnNl
IHRvIGludHJvZHVjZSBoYXJkd2FyZV9wb3N0X3NldHVwKCkgdG8gYXZvaWQgY2FsbGluZw0KPiBr
dm1fdXBkYXRlX29wcyB0d2ljZS4NCj4gDQoNCk9LLiAgVGhlbiBob3cgYWJvdXQgb3B0aW9uIDEp
ID8NCg0KV2UganVzdCBuZWVkIGFub3RoZXIgd3JhcHBlciBhcm91bmQgIHZ0X3g4Nl9vcHMuaGFy
ZHdhcmVfe2VuYWJsZXxkaXNhYmxlfSgpIGFuZA0KdXNlIGEgVlQncyBvd24gcGVyLWNwdSB2YXJp
YWJsZSB0byB0cmFjayB3aGljaCBoYXMgY3B1IGhhcyBkb25lIHRoZQ0Kdm14X2hhcmR3YXJlX2Vu
YWJsZSgpLg0KDQpXZSBjYW4gZXZlbiBwdXQgdGhlIHBlci1jcHUgdmFyaWFibGUgaW5zaWRlIHRo
ZSB2dF9oYXJkd2FyZV9lbmFibGUoKSBpdHNlbGYgdy9vDQppbnRyb2R1Y2luZyB0aGUgd3JhcHBl
ci4NCg0KQnV0IGFnYWluIGl0J3MgYmV0dGVyIGlmIFNlYW4gY2FuIGlucHV0IGhlcmUuDQoNCg==
