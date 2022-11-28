Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA82363B4C4
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiK1WYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiK1WYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:24:52 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B20F15A0C;
        Mon, 28 Nov 2022 14:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669674291; x=1701210291;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4Xh0gIWdKGamKOlWXUg1AIy0c3WOwW2Wg/yw8K/Nus4=;
  b=LOf48FHeyBXc5VJUZL/VL6/y0Bp/4yDdEpfeD4WQ5ySQ6witwnFb6hi8
   bIxJj8ImjguyOAphvj0pfYaVs18V7vnihDsGGwaxI/NshIHk1XBuMGhuH
   KFG0zoNBerUy1BXSkhhcqxOW2woEHXer/1CZ0cS/Mb7uMpWxqIc907kGn
   EORppkpzYP0TgXePPqK5TnvB2lP2KBjfLPG6LltdrmMGhqaENPq0zVcMn
   GBJl1aqa7/Dr0F/b6XdgV5/Np83Ozjhwu5dMhwuIck4jjmJVIiU7Q+QI0
   a9TuIxSRcfUYtZgW6Q0LJNLCJqaID0jkneHPzRA/Hf95hM6nTMNulvEo7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="298311981"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="298311981"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:24:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="645664123"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="645664123"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 28 Nov 2022 14:24:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:24:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:24:48 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:24:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFN4tDRhdKpbbuunLTxR+ojOL5eqyD7PIHPAuxXjSMeju2AxKhnOP91vytbN08rG0GuhJ3Dr+ondvVjQ/8L50X/LNBoFL2zKuIPWErkT+rulYYSi7+3jFxQdB+MT9/TmZSDb9xFNrwjWtmj9b/Wq+YjxsuxGfoV677RHIpjSde1xxZgtiF4q0llBkY9zDcwmwRNs6KXDpY0fRxLa/ZzlQSvDG7sIUOIhLTXZRtay8P+ClJ5fCyfg71JWXxT99LjxEp38iQVmqlg8ODg9foq5X/wFuErfqcChNFayICkTIE6Pe0Ta/xEL/Vqevf9FOyjxC0eVonyB+nXIg8022IriPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Xh0gIWdKGamKOlWXUg1AIy0c3WOwW2Wg/yw8K/Nus4=;
 b=KmNEPI4wuEElCFXBTs36ZJ0lhNkBjFszaNYsoJyeVnHAUMsXGKdxMhxADPke5KIlbxqhDb41laCLQkpH+uixu2pYwdycxa89uUC0jz84w1UdU1GmJDKWJcRYykrMNtpL6bqPrSbd9Byh5W4SIUQSzG6vK+aZII/XUUa3xmZFzA3AvTMKVNVxmji2pzKN0hC/x5VkIh28Zx+oFC9m3YRCs1B8QqmxK21mYq01wglikpL4bXsLxDm809AoMumIq+aiKvKDD52h/LNf1zyUxNc6zpgJV3BjRqDw4eOhkuo56DOppUgNqaHL4gT+FjLZG/JkABpO7Apa/N0hrhkwGcVfug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4954.namprd11.prod.outlook.com (2603:10b6:806:11b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 22:24:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 22:24:42 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Thread-Topic: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Thread-Index: AQHY/T3PFb2p/zo5A0CRtiPfoDprYK5NLyGAgAbp/4CAAEQfAIAAmLCA
Date:   Mon, 28 Nov 2022 22:24:42 +0000
Message-ID: <2b3568f3ff472a83c0539aa351cb0c1fec834728.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <5a5644e691134dc72c5e3fb0fc22fa40d4aa0b34.1668988357.git.kai.huang@intel.com>
         <5526fedd-fa54-0ad2-f356-94b167e6e290@intel.com>
         <0ebf26d1ee540b4e082b65c51cabe3327f6d51ac.camel@intel.com>
         <c752d17e-23fd-4452-e1d8-6c82748b6c8a@intel.com>
In-Reply-To: <c752d17e-23fd-4452-e1d8-6c82748b6c8a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4954:EE_
x-ms-office365-filtering-correlation-id: 3f49acee-f9b2-499c-119e-08dad18f58b7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /RKSm+FqZcSfli4JVro50bngSfJ1Kdsog3GmObG5GGXwkYQ17covO0mXgZ8IvTslCgr0oXDtdq0dK8egAs6C7zlEqDuvDmiuytRXvcLGZY0FSxNVHn9bLoHIQzamqNFLO1eyCF7mO8u+LwHI7/566f/teim1vL0iesAICNT4VChHFgxbu3ddz87G4FGqALS+H31yfAE2AByML1Z/WHJAntXUGm5qM02HRVZfuAqDptox+x8+0TjE+VBEj0xwNEuqPeedkFfKSwBsWkC6yS/8LOzePNqzluDvABV0ErBZMY3SuzbkzPW/Ca9nlBLph+OjMb7MC3f5JTrC+ThIpaYQWVYHBXKJNVijUv3DkeFPINn1nFDumyRPzamFwNQCgaL/iN9F8zWm2xkGrj3kC8HsD97RhxxBbsx3pZ4LMG89Rrjn/XMZ646vIrAvLvGqqgZKM2+TuUMiPGd/Nx4Nvg5HFdm92ba1imCfmCGDfSUIYuEs77YfRh2egtoNiov4MmVJD/1Ikho2O5TabQjKOyXUssJYSWTq0wDSPIV8pDyVuiS8WkeX0gkhOUhmPNzB+duLq3ttWbG7qk0BQ4I/mdJxvfFGt7r5XBdgxAmRBcXCsYo91hSk2TNkxJmSnnTmPQvzTW3RZNDNIF3iUXXJCy/J/AQ76t4fkKhnf+VqR1cjHzCoGmGPkFtU2VV80i4P7crjvyATmsHUo3VJcExGj02VAx90soXXx62GRctqY6FNKuM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(36756003)(66556008)(186003)(8676002)(41300700001)(8936002)(66446008)(76116006)(6512007)(53546011)(66946007)(64756008)(91956017)(2616005)(316002)(6486002)(478600001)(66476007)(71200400001)(4326008)(38070700005)(6506007)(86362001)(4001150100001)(5660300002)(2906002)(7416002)(26005)(54906003)(110136005)(122000001)(4744005)(82960400001)(38100700002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDdGZTk1QmtReHJjaEpnZFE5MjJnTnd1OU1DQkxmOEVwRlU4anliY2o4cVRS?=
 =?utf-8?B?OHNyUnovRUY4TWRyZ25vSE9TeFpYMFBNV0JSOHBFYjFnQ0RCRVJxdGgvQjkz?=
 =?utf-8?B?ajFab0NwQ2lBWWVWQnRwK3pDTU1TYS8wU0tXVUkzZnZ2ZGFEY1Y5amdhZSto?=
 =?utf-8?B?ZlhIcTErMHpLMlBvR0VidVJBOTFrQldFdVhSb2pmRFVUMFF1SElSMGFvcFlY?=
 =?utf-8?B?UWdWM0daWXM5dGJoZ1VTTW1UK0ZhQ3JNTU01NllINWJoSGx1eTAvbCs5Nldj?=
 =?utf-8?B?Sm1nbDBzKytaV0Q4dzhHVURZOGV0UWxUQitxWFBEeWQ4ZXE3czFXQlRiYkdX?=
 =?utf-8?B?ckMvWGR4bGFxZENmTS9FcDRPMHNFSndKNnYwN29WNVZlV3Y2ekx2c1VKaHFL?=
 =?utf-8?B?b3M3NXYwenl0SWFNeGtreVE0NWJKUldvUGhSM1NEN1hpQ2doWVZDYkpvL2Yv?=
 =?utf-8?B?S1BwYUpUQ0dpQnVzRVg4SFBJcGVWTUloZHM0emRqY1N4Rlh3K3dFOCszNzhM?=
 =?utf-8?B?N2hNTGx5bkFvQ2FSMVBMVzd5YlNCZGtQNjhsZXY4NEdJYWR2cEpoeTBrUjkz?=
 =?utf-8?B?M2NnY2Q5cllLWndRdTZWQ0VXbUhhMEpFR0pWVG5ialdMeDU4RzdrTlpSRkFI?=
 =?utf-8?B?YmtUbW01MSsrWStMekhCZEM2Y2JSQjFlV0ZtTUxlTGUzbktjY2NEYjhKeWhB?=
 =?utf-8?B?M0xDaS9abmlJeXBJSDVVZGxuaDNxdkJhY2I4VHJYVFU3dks5TVRMK0NsWDZK?=
 =?utf-8?B?bmh0ODFYRHUxK2dSZTUzWEpDZi91emQ5TDZYRzhTRlFXZCtweDhaOFlmTkhy?=
 =?utf-8?B?dVFLWFV5ZEcvbVlCNHZjdGhVd3RZZTVJQnA2ZjdvWlJ5SEV2TjRyVjg3Wlhh?=
 =?utf-8?B?SWx6S1RFNHpGZUdVUEVKT2xwTGxhczVwekh6NzFSNDZNbE5ld2p2MmNOMnNz?=
 =?utf-8?B?bDI4WUVWNkNkc1NWSldFUVE0UStuKzZGTDZuVkhlTm1na3ppOW8reko4blM5?=
 =?utf-8?B?NStvMVJIOE1SOTZQakN5TXVYbmVwa2ltVFNrMWFSczhIZy83Q0VwSWFWYjFE?=
 =?utf-8?B?ZVRWdktiUGFYNGJJbWtlaERBV0F0c0RxRENVR3p0TTJWTWl0TzBvWTRzV0RV?=
 =?utf-8?B?UkR5Q0puTVJTa3VoYnZKekZReG51L0JIKzc0cWtEdHhDRkQ3Ty8xUCtZNmY2?=
 =?utf-8?B?d1k0d2FNU3Q0QlBVbkF5aDZVN1JBQkhUVWZaSTZLR3hLNmlxaVBSVW9EVHNr?=
 =?utf-8?B?QnFueEJvR1FMN2FObHFYSUVVbTFNRVptNEMybjcyb0JsOUxaempnc1RiNnh3?=
 =?utf-8?B?LzloSGVjd1FOMUFHbHhuRTVGQ0xFNkJGdGE4VWswY3BwTFZGdFdnNzJCOVVQ?=
 =?utf-8?B?UE5CZHFsb1puZzN6ZnRQWWZ2Y21qdWdPcC8vTjRLZkVvejBBa0E4SFNEZW8v?=
 =?utf-8?B?NnRRejMwNkdsU3oxSlI4NGhQaXhxa1RKUkRCQi8zbCtTK0tGeFBnQ3JWN3JY?=
 =?utf-8?B?M01VRUZqbmppekRBbTNLVldpUlE2WHB1c0FCUmZMVWZiV04wcXJJZERNTGly?=
 =?utf-8?B?QWkwYmdCdlBNVll0QjR5dHQycm5WeExTNHhsdFZWR1ZjNFNoMXlHYi9yTUJR?=
 =?utf-8?B?cldGYVlaVGwxNFlacmY3di8xdE9kUFRpdURwQ2ViK3FxT2NVSUxpdUhBNkZk?=
 =?utf-8?B?VVlUeVJRdGVOd0lncjdLWXNQa096MWhqS0ZEUjNQcFVKdjRMazZUQlhOa0JY?=
 =?utf-8?B?cFlRVzFuV2pka2ovaFdlc0NKdmZud0tYc1pOdHZnWXo0b0V5RThiUkQ1Q3JS?=
 =?utf-8?B?NmI1Sll5S3FKamE5cGxzY3JjYm1lZXJYTXBBRytvY0hkUnpOVWJJeXVhZGVG?=
 =?utf-8?B?ekRiNkVsVnAvdGV6am9Hakg5YnJTU2g3aUtKb1lQdW8wMTNEVHVrUTg2TkxM?=
 =?utf-8?B?SDh3c0s3OUgwM0tDYzFIYkJtQy9kT0tHa00wOGxSMDUwNHZEbGFJaWh1K3J2?=
 =?utf-8?B?cnV3aUpqWnJ0S252YzZlVGk0M3RGTCtRYzJFSDBmVTdLcDIrWEF4aER1U2pY?=
 =?utf-8?B?QlBPMWlwc3UyWG4zNlEyQzRtRnZRTEs4MGFKbThjbVZCTlJUd0xZcVlvNHhU?=
 =?utf-8?B?bCtQSCsweExxZVNicS9UTERHaitzdnNxLzJFaFZ2SGw0S2ZaNWl4MnRiM3ZU?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40F0B41EDC977B4D9A1EF2E9B007A5DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f49acee-f9b2-499c-119e-08dad18f58b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 22:24:42.4955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jxIRCuABIpGwYfQcl/dRnk4AwjqP03lxlyMwRw8NLdItxbD47J9Xd85wwo3dh5VAMq+uzndo/lxToGkDQEcWPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4954
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDA1OjE4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjgvMjIgMDE6MTQsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gV2VkLCAyMDIyLTEx
LTIzIGF0IDE1OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gLi4uDQo+ID4gPiAvKg0K
PiA+ID4gwqAqIEdvIHRocm91Z2ggdGR4X21lbWxpc3QgdG8gZmluZCBob2xlcyBiZXR3ZWVuIG1l
bW9yeSBhcmVhcy7CoCBJZiBhbnkgb2YNCj4gPiA+IMKgKiB0aG9zZSBob2xlcyBmYWxsIHdpdGhp
biBAdGRtciwgc2V0IHVwIGEgVERNUiByZXNlcnZlZCBhcmVhIHRvIGNvdmVyDQo+ID4gPiDCoCog
dGhlIGhvbGUuDQo+ID4gPiDCoCovDQo+ID4gPiBzdGF0aWMgaW50IHRkbXJfcG9wdWxhdGVfcnN2
ZF9ob2xlcyhzdHJ1Y3QgbGlzdF9oZWFkICp0ZHhfbWVtbGlzdCwNCj4gPiA+IMKgCQkJCcKgwqDC
oCBzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLA0KPiA+ID4gwqAJCQkJwqDCoMKgIGludCAqcnN2ZF9p
ZHgpDQo+ID4gDQo+ID4gVGhhbmtzIQ0KPiA+IA0KPiA+IFNob3VsZCBJIGFsc28gY2hhbmdlIGJl
bG93IGZ1bmN0aW9uICd0ZG1yX3NldF91cF9wYW10X3JzdmRfYXJlYXMoKScgdG8sIGkuZS4NCj4g
PiB0ZG1yX3BvcHVsYXRlX3JzdmRfcGFtdHMoKT8NCj4gPiANCj4gPiBBY3R1YWxseSwgdGhlcmUg
YXJlIHR3byBtb3JlIGZ1bmN0aW9ucyBpbiB0aGlzIHBhdGNoOiB0ZG1yX3NldF91cF9yc3ZkX2Fy
ZWFzKCkNCj4gPiBhbmQgdGRtcnNfc2V0X3VwX3JzdmRfYXJlYXNfYWxsKCkuwqAgU2hvdWxkIEkg
YWxzbyBjaGFuZ2UgdGhlbSB0bw0KPiA+IHRkbXJfcG9wdWxhdGVfcnN2ZF9hcmVhcygpIGFuZCB0
ZG1yc19wb3B1bGF0ZV9yc3ZkX2FyZWFzX2FsbCgpPyANCj4gDQo+IEkgZG9uJ3Qga25vdy7CoCBJ
J2xsIGxvb2sgYXQgdGhlIG5hbWluZyBhZ2FpbiBvbmNlIEkgc2VlIGl0IGFsbCB0b2dldGhlci4N
Cg0KU3VyZS4gSSdsbCBvbmx5IGNoYW5nZSB0aGUgb25lIHlvdSBtZW50aW9uZWQgYWJvdmUgYW5k
IGtlZXAgdGhlIG90aGVycyBmb3IgdGhlDQpuZXh0IHZlcnNpb24uDQo=
