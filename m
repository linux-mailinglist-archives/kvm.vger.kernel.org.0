Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C367076434F
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 03:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjG0BRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 21:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjG0BRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 21:17:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF28270E;
        Wed, 26 Jul 2023 18:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690420652; x=1721956652;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=wBqUmyfMA66lzMGNfkrfwomH/R0kxnPhWkdhrSdMppM=;
  b=CLzsHN9ozJV/NmQVCPN1sXsoANX0l4iCvZn74wJNDAX/Mg0+tX0Igr8N
   r8WYyLnKiSve8b3n34fcjFuF8am7yOmT10bfAZp2KmZn4HV0uFLu2iEfc
   2ZpUoDqGuR7NpLhDO5e6zx01Q5usyLNOR3ptmhIfxaqK1LhnE79ZC2tgh
   /ibJkqP0bM320oKYMjzqNAn01Xn0djl5b5732t98EyD4BnhxTB3Rs3hYn
   lIUZdZED60Fb8D1no1isA8ZGWXFZzoEfTMtOz9g3HX0oZYvokMAkoweRm
   XXwryIFeUg8lXXfaSSGZb+5mInBqCKVBToqypww92HKThDyQXvMFBZuWQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="347782145"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="347782145"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 18:17:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="796775122"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="796775122"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jul 2023 18:17:30 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 18:17:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 18:17:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 18:17:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LX9+cQhHeGL4y6mZd4U5pNqaiEgiMhHftTBXYz6MgAK0vt7FD85cKct2TZWU5y7mNdBDJFMgJ+/k5iR1L5U0eYEhXfuuud4CMXWDBcB2iXMRYuvuOjvA0lkExp5h+8QdzmkoQiv+YDaDMK72U+3az7NTb4BMppd0JJiIGTZEoOhb+2ij0sPjLLiaBDEk8hEhsj8/rEuyB9X93xWd7XdKqLLaMoFe8/SsmJlBHCD2X8JSCgMSmZNaccZxVtbFBzj3WVJcz6XXY0iD5QDz6HxqyFoxCCwQElhcT88641Hv6IduKr5Rpq2svkI/+okZQ22dEwiD54/En89ATrWGY9ZkXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBqUmyfMA66lzMGNfkrfwomH/R0kxnPhWkdhrSdMppM=;
 b=ayr6SikqfqhNQ0kEYdrBTJsoax9s7dRws/+wk+dIb7Vw5LRB6Zn3eSzT/d98Kdl9v8E9fMieP4KQJULd71/Mnt3wzfTDw1DMdTT2dlHFTk7K9YCx9MCuDLBz+hVOMkIqdQzzkNb1KkeJMODn8HLLPQwgzon/ZlAI2xl2rI6oa97Pk2Sv4gIACvGjlGyERWI8X2+wK4QFTQBCmx4dj8FUOBWAB8IWy8tsbEHdEkbkr2+jWJ1xWo3+cKIdMVZYTGzWMrt7RhgXAug9AhnXOC4QxHxIc+T2579MnolhKmCxjVYmvd18pnqVjrEdaUxHe6X2QYNtaql1XL9KasVN62TwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by MW4PR11MB7150.namprd11.prod.outlook.com (2603:10b6:303:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Thu, 27 Jul
 2023 01:17:23 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4a3e:51f9:8a29:afe5]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4a3e:51f9:8a29:afe5%4]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 01:17:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5ABFkrqAABzyefAAEd18AAAWEYvQAQF+OGAN6kDQQA==
Date:   Thu, 27 Jul 2023 01:17:22 +0000
Message-ID: <BL1PR11MB5271A60035EF591A5BE8AC878C01A@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230510112449.4d766f6f.alex.williamson@redhat.com>
        <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230511094512.11b5bb7e.alex.williamson@redhat.com>  
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|MW4PR11MB7150:EE_
x-ms-office365-filtering-correlation-id: 5e5eba3f-3a60-42d7-233c-08db8e3f3b0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: REIWNaUxbnGpEPagjmwjoZhrzEXvvTofwx2rTJQXpKChsGVabin0DWmex2v2yj0l/kbT/zXK2k4IHbrIf4btkGyXwufjUUitwvh9bsKEEr3fIwMGR3uqhKnwteM/9LJoytx300h70CO+i5hiOUEIHWEAVJqLyQVh/8cMRX9NTPv/RuTPS2pa+8g6MHjCYToOYhqZjUmycUF89JdULj+0oIvC8SUIGJCXldpyXIfwjtJi1RWGF39CPezr1n2/5AraGF+UpvHpmjMPxXa5446i1/l8Nv40Meh2Ao/p2qHRMSZd3Z0eq9nOQz6tq9jKVw7obm544Jet4fEx+ZGOI7sFfiJVr/zgUtVueSr0dAwNJEYKXPfJ+qbrUsXfMmEANt3doKiPILMx2mdA1kKAtI0+TNQCfEdI887vBUQvUw6d/Nl5HBGvBRb2Ac0beStkwhxNqk6v2sGh4wGDrqbQ/2UzPqrAkWi6TxDh0S38TEJXHCgsjTGcjZ+4iIOvPva+7FPwEE0lyZIwjUIQQ9VJHCTCI4ndTBNuLn81J41EDZw3om+02m/eIoX5ivv5MiRBWIlbeGXopjbFvQO4AKh4PO3w8+P6prDy62+tRoTc64NIxAQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(66556008)(5660300002)(45080400002)(66446008)(107886003)(26005)(6506007)(186003)(38070700005)(66946007)(76116006)(4326008)(41300700001)(316002)(6916009)(66476007)(3480700007)(71200400001)(9686003)(966005)(64756008)(7696005)(2906002)(54906003)(8676002)(478600001)(8936002)(52536014)(83380400001)(82960400001)(86362001)(38100700002)(33656002)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2Jac2I2S01mY08rZ1hpMkVhaXZXeXV2R2JuUVF1bWxZdDRNajlBeGtRMnQz?=
 =?utf-8?B?YmpOcmtvMFROS2g0QnpPYjUrbnhHZGxBQTJlaS9hYXExK3dsQnpQL2NGU1NG?=
 =?utf-8?B?UjlGTisxQmFxY3FUc081UlFqdWN6bHp6Qy9nbTVkeVJJbmtxdHJ2QjdRKzVw?=
 =?utf-8?B?UHBLb1JEbUlQWlo0NDlYVlppSDRvZS81bmFXV3VWZjV2Vy9ETit4c3Znb2hw?=
 =?utf-8?B?MGRQWWNHRER3QS9vK0JCZ29kK3VFRFluRWsyZlVsM3B4QlM5amNWSENPQ2ZP?=
 =?utf-8?B?UlNkNFQ2STAwc0NXdFNYaFZnb1lqbHNXdnEzTUFzVEQybEg1N1NMd0tKZUJV?=
 =?utf-8?B?SFdoYW9JQmRhU0E3K1pudzF5RHVVZFAzRm8xOHNyK3p6QTlGY3Fsa3FpRjdi?=
 =?utf-8?B?UCtsNzVMbE01SGlqVWY0NFNvdlRlWUJpRE9FTnlCYmRsWjFJTGNFR1I3VVpU?=
 =?utf-8?B?M3pFTDRmZHVQQVR1T2dmb1I3R2ZGWlB4ZUhrb2ZXOGtjbjdDVzQwbHA4VVYz?=
 =?utf-8?B?NDBqa2ZycksxUjVhUHVjdnF4QXpsMjhWajJlTzNndDV3dTMyKzYvcFBtZnlo?=
 =?utf-8?B?Q3NIczFRb284OXZzTm5Qa2NIZjJUVThmdFE2dGR4WWVKYWUxaDdiN1NON0hn?=
 =?utf-8?B?L055YlVXMlFDcUloWGxmNFlwbWdIdVJ3MGRxU2tKenJsZzV3ZUpNczBycFhq?=
 =?utf-8?B?bVhLUkZMVFVCbXMrV0JrVmNPN2JySFpsOSs2cnUrdkNSZTNVUkJBNGZkZk9i?=
 =?utf-8?B?Sy80NWNScS9jVVFFZzFQZFlVMWpEaWE3c3REUjNkdThZZnFIZGZjWkZJN3Fa?=
 =?utf-8?B?UlZZUHJTRW9EWUVIRUZnWmpUS0MrWUFtZ0FMOVlMM1hKUDdSUmFlM3FtbGRa?=
 =?utf-8?B?YUVKV3ZWWU1kcTBzVDZidlhyVWErR2cwTFl2YUZOK0dlaGExTllheFhmMnMz?=
 =?utf-8?B?OFQ0T3RLSy9xTjQ3bm5lTFVQbHAvTGx5RkluMitZQ3ZLeWIzaVhKaWdiM0gz?=
 =?utf-8?B?Y3hnMjQycVdTQVBWcDlOWTFOaGxBTHptTkNYQzRmaU5raGZkVng4czk4cnNW?=
 =?utf-8?B?T3pUMnRzN1NES3pUY3RFMHVsd2ZIMzkwc1BTanh4N2Z6Y2dJWUNoTHp5YTU4?=
 =?utf-8?B?NnUvZ0I1c2RwdnkrTW5oZnFxaDFQTlFhR2V0WDFnKzhFcFVkdGI5YVJCTXZr?=
 =?utf-8?B?OTh4N3VtTGF0M01WTDA4Q3hFTHdoTTFKR1IxL1A2enljNDJsbHB2WGtjZytH?=
 =?utf-8?B?ZEl6TlYvYkd1cG1tc2o2cVhPdEtRRDV0U3dFY2hGbVZmdXNvL2Vha1VPL3Jn?=
 =?utf-8?B?N3l6WlVOcFdTaUMwTzlXeFJaZDZNSE9MeWVrdjZZUmFQUE5FU3cxS0xWbXho?=
 =?utf-8?B?c1dvcFRlMHAyR1RYRStpTTJpV21SRUNYS24yYjVFWnRRMzU1cmVrTzYyVWhk?=
 =?utf-8?B?dVhjM1pFSzJSb1BNSmtHTU5jNHBPRjBqQnZEa2pnU21SSGRDM00rbldrcThs?=
 =?utf-8?B?NnJ4Y0IwUndCRVBqQVdxeUs3MkZuNW04NWRnMHYwaERva1BHMGVPODlyYzln?=
 =?utf-8?B?NzdiaXBYb3d2RjhJRUhETzJLTTd0OHZVRmRieFlJckJNMUFndzdER1NVRmMv?=
 =?utf-8?B?QlhVTk9laWpKN1V5R3VqRDJXMm1FRTZQSEVHZHMzV1hnVlNFSHlJeUc3VTlY?=
 =?utf-8?B?d2Fma0J3cmhqOER3Z1NpMG9hS1hqWjV2aVh1cFAyMzdnL0xSMWpWdEV5eGI4?=
 =?utf-8?B?OUhOMW9QY2ppaUZvWnFnSTZ6Smo5MHpkRXVRS2FMSW1TM0g4WGFYbU9EMiti?=
 =?utf-8?B?Zlh1VjdwVWM5dHhkeWo2NWoyOE9OZENkSFd6dGNVUVR0dFFQcGdWRHpyWjNN?=
 =?utf-8?B?MDJDK2N4Uys5NzBKK1VmNlhJNlowaWpVRFNma2lXSU12NkpqeWdXOG1SM1Ji?=
 =?utf-8?B?N2N4VGh4UjdGbzdvcVlBQ3dQOERmam1XQ2dqaCtQNGJZMFh1MHppTWFoSWdW?=
 =?utf-8?B?RDU1ZnNteXZKeWVwT1FjemwxVW9DWU9aYU1kemtYU1dhb2Iwb0JVaFJTczds?=
 =?utf-8?B?S0VuclQvWE9pU0pyMGhNRTN5VUpsK2lDcExvT1pyM29kaU9qRHBhVnpPTHh1?=
 =?utf-8?Q?/gdgs+WjomzA4s/4sb/ARVPKA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e5eba3f-3a60-42d7-233c-08db8e3f3b0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2023 01:17:22.7572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0bfwn3dK8Kg4IgZPA6V6MrmFLA4//W42QLm7wrEWZdPcQxYyb70pD94Tnv8B59iBY/vwTpFEonQAXk18pu1WhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7150
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

R2VudGxlIHBpbmcgaW4gY2FzZSBpdCdzIGJ1cmllZCBpbiB5b3VyIG1haWxib3guIPCfmIoNCg0K
d2UnZCBsaWtlIHRvIHNldHRsZSBpdCBkb3duIHNvb24gYXMgdGhlIGNvbmNsdXNpb24gbWF5IGV2
ZW4gYWZmZWN0IFBGIChlLmcuIGlmIGFsbA0KYWdyZWUgdGhhdCBkZXZpY2UgZmVhdHVyZSBpcyB0
aGUgcmlnaHQgaW50ZXJmYWNlIHRvIGdvKS4NCg0KPiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50
OiBXZWRuZXNkYXksIE1heSAxNywgMjAyMyAxOjIyIFBNDQo+IA0KPiA+IEZyb206IFRpYW4sIEtl
dmluDQo+ID4gU2VudDogRnJpZGF5LCBNYXkgMTIsIDIwMjMgMTA6NTMgQU0NCj4gPg0KPiA+ID4g
RnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiA+
IFNlbnQ6IFRodXJzZGF5LCBNYXkgMTEsIDIwMjMgMTE6NDUgUE0NCj4gPiA+DQo+ID4gPiBPbiBU
aHUsIDExIE1heSAyMDIzIDA3OjI3OjI3ICswMDAwDQo+ID4gPiAiVGlhbiwgS2V2aW4iIDxrZXZp
bi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gPiA+IEZyb206IEFsZXggV2ls
bGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gPiA+ID4gU2VudDogVGh1
cnNkYXksIE1heSAxMSwgMjAyMyAxOjI1IEFNDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBUdWUs
IDkgTWF5IDIwMjMgMDg6MzQ6NTMgKzAwMDANCj4gPiA+ID4gPiAiVGlhbiwgS2V2aW4iIDxrZXZp
bi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEFjY29yZGlu
ZyB0byBQQ0llIHNwZWMgKDcuOC45IFBBU0lEIEV4dGVuZGVkIENhcGFiaWxpdHkgU3RydWN0dXJl
KToNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiAgIFRoZSBQQVNJRCBjb25maWd1cmF0aW9uIG9m
IHRoZSBzaW5nbGUgbm9uLVZGIEZ1bmN0aW9uIHJlcHJlc2VudGluZw0KPiA+ID4gPiA+ID4gICB0
aGUgZGV2aWNlIGlzIGFsc28gdXNlZCBieSBhbGwgVkZzIGluIHRoZSBkZXZpY2UuIEEgUEYgaXMg
cGVybWl0dGVkDQo+ID4gPiA+ID4gPiAgIHRvIGltcGxlbWVudCB0aGUgUEFTSUQgY2FwYWJpbGl0
eSwgYnV0IFZGcyBtdXN0IG5vdCBpbXBsZW1lbnQgaXQuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gVG8gZW5hYmxlIFBBU0lEIG9uIFZGIHRoZW4gb25lIG9wZW4gaXMgd2hlcmUgdG8gbG9jYXRl
IHRoZSBQQVNJRA0KPiA+ID4gPiA+ID4gY2FwYWJpbGl0eSBpbiBWRidzIHZjb25maWcgc3BhY2Uu
IHZmaW8tcGNpIGRvZXNuJ3Qga25vdyB3aGljaCBvZmZzZXQNCj4gPiA+ID4gPiA+IG1heSBjb250
YWluIFZGIHNwZWNpZmljIGNvbmZpZyByZWdpc3RlcnMuIEZpbmRpbmcgc3VjaCBvZmZzZXQgbXVz
dA0KPiA+ID4gPiA+ID4gY29tZSBmcm9tIGEgZGV2aWNlIHNwZWNpZmljIGtub3dsZWRnZS4NCj4g
PiA+ID4gPg0KPiA+ID4gPiA+IEJhY2t1cCBmb3IgYSBtb21lbnQsIFZGcyBhcmUgZ292ZXJuZWQg
YnkgdGhlIFBBU0lEIGNhcGFiaWxpdHkgb24NCj4gdGhlDQo+ID4gPiA+ID4gUEYuICBUaGUgUEFT
SUQgY2FwYWJpbGl0eSBleHBvc2VzIGNvbnRyb2wgcmVnaXN0ZXJzIHRoYXQgaW1wbHkgdGhlDQo+
ID4gPiA+ID4gYWJpbGl0eSB0byBtYW5hZ2UgdmFyaW91cyBmZWF0dXJlIGVuYWJsZSBiaXRzLiAg
VGhlIFZGIG93bmVyIGRvZXMgbm90DQo+ID4gPiA+ID4gaGF2ZSBwcml2aWxlZ2VzIHRvIG1hbmlw
dWxhdGUgdGhvc2UgYml0cy4gIEZvciBleGFtcGxlLCB0aGUgUEFTSUQNCj4gPiBFbmFibGUNCj4g
PiA+ID4gPiBiaXQgc2hvdWxkIHJlc3RyaWN0IHRoZSBlbmRwb2ludCBmcm9tIHNlbmRpbmcgVExQ
cyB3aXRoIGEgUEFTSUQgcHJlZml4LA0KPiA+ID4gPiA+IGJ1dCB0aGlzIGNhbiBvbmx5IGJlIGNo
YW5nZWQgYXQgdGhlIFBGIGxldmVsIGZvciBhbGwgYXNzb2NpYXRlZCBWRnMuDQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiBUaGUgcHJvdG9jb2wgc3BlY2lmaWVkIGluIDcuOC45LjMgZGVmaW5lcyB0aGlz
IGVuYWJsZSBiaXQgYXMgUlcuICBIb3cNCj4gZG8NCj4gPiA+ID4gPiB3ZSB2aXJ0dWFsaXplIHRo
YXQ/ICBFaXRoZXIgaXQncyB2aXJ0dWFsaXplZCB0byBiZSByZWFkLW9ubHkgYW5kIHdlDQo+ID4g
PiA+ID4gdmlvbGF0ZSB0aGUgc3BlYyBvciB3ZSBhbGxvdyBpdCB0byBiZSByZWFkLXdyaXRlIGFu
ZCBpdCBoYXMgbm8gZWZmZWN0LA0KPiA+ID4gPiA+IHdoaWNoIHZpb2xhdGVzIHRoZSBzcGVjLg0K
PiA+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+IEN1cnJlbnRseSB0aGUgUEFTSUQgY2FwIGlzIGVu
YWJsZWQgYnkgZGVmYXVsdCB3aGVuIGEgZGV2aWNlIGlzIHByb2JlZA0KPiA+ID4gPiBieSBpb21t
dSBkcml2ZXIuIExlYXZpbmcgaXQgZW5hYmxlZCBpbiBQRiB3aGlsZSBndWVzdCB3YW50cyBpdCBk
aXNhYmxlZA0KPiA+ID4gPiBpbiBWRiBpcyBoYXJtbGVzcy4gVy9vIHByb3BlciBzZXR1cCBpbiBp
b21tdSBzaWRlIHRoZSBWRiBjYW5ub3QNCj4gPiA+ID4gZG8gcmVhbCB3b3JrIHdpdGggUEFTSUQu
DQo+ID4gPiA+DQo+ID4gPiA+IEZyb20gdGhpcyBhbmdsZSBmdWxseSB2aXJ0dWFsaXppbmcgaXQg
aW4gc29mdHdhcmUgbG9va3MgZ29vZCB0byBtZS4NCj4gPiA+DQo+ID4gPiBTbyB5b3UncmUgc3Vn
Z2VzdGluZyB0aGF0IHRoZSBJT01NVSBzZXR1cCBmb3IgdGhlIFZGIHRvIG1ha2UgdXNlIG9mDQo+
ID4gPiBQQVNJRCB3b3VsZCBub3Qgb2NjdXIgdW50aWwgb3IgdW5sZXNzIFBBU0lEIEVuYWJsZSBp
cyBzZXQgaW4gdGhlDQo+ID4gPiB2aXJ0dWFsaXplZCBWRiBQQVNJRCBjYXBhYmlsaXR5IGFuZCB0
aGF0IHN1cHBvcnQgd291bGQgYmUgdG9ybiBkb3duDQo+ID4gPiB3aGVuIFBBU0lEIEVuYWJsZSBp
cyBjbGVhcmVkPw0KPiA+DQo+ID4gTm8gdGhhdCBpcyBub3QgdGhlIGNhc2UuIFRoZSBJT01NVSBz
ZXR1cCBpcyBpbml0aWF0ZWQgYnkgdklPTU1VDQo+ID4gYW5kIG9ydGhvZ29uYWwgdG8gdGhlIFBB
U0lEIGNhcCB2aXJ0dWFsaXphdGlvbi4NCj4gPg0KPiA+IEZvbGxvd2luZyB0aGUgY3VycmVudCBJ
T01NVSBiZWhhdmlvciBhcyBCYW9sdSBkZXNjcmliZWQgdGhlIGd1ZXN0DQo+ID4gd2lsbCBhbHdh
eXMgZW5hYmxlIHZQQVNJRCBpbiB0aGUgdklPTU1VIGRyaXZlci4NCj4gPg0KPiA+IEV2ZW4gaWYg
dGhlIGd1ZXN0IGltcGxlbWVudHMgYW4gZHJpdmVyLW9wdCBtb2RlbCBmb3IgdlBBU0lEIGVuYWJs
aW5nLA0KPiA+IGluIHR5cGljYWwgY2FzZSB0aGUgZ3Vlc3QgZHJpdmVyIHdpbGwgbm90IHJlcXVl
c3QgdklPTU1VIHNldHVwIGZvciBWRg0KPiA+IFBBU0lEcyBpZiBpdCBkb2Vzbid0IGludGVuZCB0
byBlbmFibGUgdlBBU0lEIGNhcC4gSW4gdGhpcyBjYXNlIHRoZQ0KPiA+IHBoeXNpY2FsIElPTU1V
IGlzIGxlZnQgYmxvY2tpbmcgVkYgUEFTSURzIGhlbmNlIGxlYXZpbmcgUEYgUEFTSUQgZW5hYmxl
ZA0KPiA+IGRvZXNuJ3QgaHVydC4NCj4gPg0KPiA+IElmIGFuIGluc2FuZSBndWVzdCBkcml2ZXIg
ZG9lcyB0cnkgdG8gZW5hYmxlIHZJT01NVSBQQVNJRCAoc28gVkYgUEFTSURzDQo+ID4gYXJlIGFs
bG93ZWQgaW4gcGh5c2ljYWwgSU9NTVUpIHdoaWxlIGxlYXZpbmcgdlBBU0lEIGRpc2FibGVkIGlu
IFZGLA0KPiA+IEknbSBub3Qgc3VyZSB3aGF0IHdvdWxkIGJlIHRoZSBhY3R1YWwgcHJvYmxlbSBs
ZWF2aW5nIFBGIFBBU0lEIGVuYWJsZWQuDQo+ID4gVGhlIGd1ZXN0IGRyaXZlciBraW5kIG9mIHdh
bnRzIHRvIGZvb2wgaXRzZWxmIGJ5IGFscmVhZHkgc2V0dGluZyB1cCB0aGUNCj4gPiBmYWJyaWMg
dG8gYWxsb3cgVkYgUEFTSUQgYnV0IHRoZW4gYmxvY2sgUEFTSUQgaW4gVkYgaXRzZWxmPw0KPiA+
DQo+ID4gPg0KPiA+ID4gVGhpcyBpcyBzdGlsbCBub3Qgc3RyaWN0bHkgaW4gYWRoZXJlbmNlIHdp
dGggdGhlIGRlZmluaXRpb24gb2YgdGhlDQo+ID4gPiBQQVNJRCBFbmFibGUgYml0IHdoaWNoIHNw
ZWNpZmllcyB0aGF0IHRoaXMgYml0IGNvbnRyb2xzIHdoZXRoZXIgdGhlDQo+ID4gPiBlbmRwb2lu
dCBpcyBhYmxlIHRvIHNlbmQgb3IgcmVjZWl2ZSBUTFBzIHdpdGggdGhlIFBBU0lEIHByZWZpeCwg
d2hpY2gNCj4gPiA+IGNsZWFybHkgdmlydHVhbGl6YXRpb24gaW50ZXJhY3Rpbmcgd2l0aCB0aGUg
SU9NTVUgdG8gYmxvY2sgb3IgYWxsb3cNCj4gPiA+IFBBU0lEcyBmcm9tIHRoZSBWRiBSSUQgY2Fu
bm90IGNoYW5nZS4gIElzIGl0IHN1ZmZpY2llbnQ/DQo+ID4gPg0KPiA+ID4gRm9yIGV4YW1wbGUg
d2UgY2FuJ3QgdXNlIHRoZSB2UEFTSUQgY2FwYWJpbGl0eSB0byBtYWtlIGFueSBndWFyYW50ZWVz
DQo+ID4gPiBhYm91dCBpbi1mbGlnaHQgUEFTSUQgVExQcyB3aGVuIHNlcXVlbmNpbmcgSU9NTVUg
b3BlcmF0aW9ucyBzaW5jZSB3ZQ0KPiA+ID4gY2FuJ3QgYWN0dWFsbHkgcHJldmVudCBWRnMgdXNp
bmcgUEFTSUQgc28gbG9uZyBhcyBQQVNJRCBFbmFibGUgaXMgc2V0DQo+ID4gPiBvbiB0aGUgUEYu
DQo+ID4NCj4gPiBJT01NVSBjYXJlcyBhYm91dCBpbi1mbGlnaHQgUEFTSUQgVExQcyBvbmx5IHdo
ZW4gaXQncyB1bmJsb2NrZWQuDQo+ID4NCj4gPiBJZiBpdCdzIGFscmVhZHkgYmxvY2tlZCB0aGVu
IGl0IGRvZXNuJ3QgbWF0dGVyIHdoZXRoZXIgVkYgaXMgc2VuZGluZyBQQVNJRA0KPiA+IFRMUCBv
ciBub3QuDQo+ID4NCj4gPiBidHcgdGhpbmsgYWJvdXQgdGhlIGN1cnJlbnQgc2l0dWF0aW9uLiBF
dmVuIGlmIHZmaW8tcGNpIGRvZXNuJ3QgZXhwb3NlDQo+ID4gUEFTSUQgY2FwIHRvZGF5LCBpdCdz
IHBoeXNpY2FsbHkgZW5hYmxlZCBieSBpb21tdSBkcml2ZXIgYWxyZWFkeS4gVGhlbg0KPiA+IHRo
ZSBndWVzdCBpcyBhbHJlYWR5IGFibGUgdG8gcHJvZ3JhbSB0aGUgZGV2aWNlIHRvIHNlbmQgUEFT
SUQgVExQJ3MuDQo+ID4NCj4gPiBmdWxseSB2aXJ0dWFsaXppbmcgdlBBU0lEIGNhcCBqdXN0IGFs
aWducyB3aXRoIHRoaXMgZmFjdC4g8J+Yig0KPiA+DQo+IA0KPiBIaSwgQWxleCwNCj4gDQo+IElm
IHlvdSBhcmUgT0sgd2l0aCBhYm92ZSBleHBsYW5hdGlvbiB3ZSBjYW4gY29udGludWUgZGlzY3Vz
c2luZyBob3cNCj4gdG8gZXhwb3NlIHRoZSBQQVNJRCBjYXAgZm9yIFZGLg0KPiANCj4gQXQgdGhl
IHN0YXJ0IEkgbGlzdGVkIHNldmVyYWwgb3B0aW9ucyB0byBxdWlyayB0aGUgb2Zmc2V0IGluIHRo
ZSBrZXJuZWwuDQo+IA0KPiBKYXNvbiBzdWdnZXN0ZWQgdGhhdCB0aGUga2VybmVsIHNob3VsZCBu
b3QgZXhwb3NlIHRoZSBjYXAgdW5jb25kaXRpb25hbGx5Lg0KPiANCj4gVGhlbiBJIHByb3Bvc2Vk
IGl0IGNvdWxkIGJlIGRvbmUgdmlhIGEgZGV2aWNlIGZlYXR1cmUgYW5kIGxlYXZlIHRoZQ0KPiBv
ZmZzZXQgdG8gYmUgcXVpcmtlZCBpbiBWTU0uIFsxXSBJcyBpdCBhIHJlYXNvbmFibGUgd2F5IHRv
IGdvPw0KPiANCj4gVGhhbmtzDQo+IEtldmluDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGttbC9CTjlQUjExTUI1Mjc2QUU0MzE4M0EzQUE2QUI4MDZBMzk4Qzc0DQo+IDlA
Qk45UFIxMU1CNTI3Ni5uYW1wcmQxMS5wcm9kLm91dGxvb2suY29tLw0K
