Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E594663DC0
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 11:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbjAJKQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 05:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbjAJKPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 05:15:45 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C1D544F7;
        Tue, 10 Jan 2023 02:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673345744; x=1704881744;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9LTf5rb/NYl4HrDrTysjK9KXBuwoFYfmJo9T/R4EgDg=;
  b=TU4bFnFsGkvhtKz5CO+9yvlJzas7R2UoxX/2KH11X77Pjh2N0qAuvrs+
   59lRf53YDuojs5mFloXIglEN4+hc68jqixM8u4MvSwWwWPpFPU7yUXVBR
   mKzGCzbKq235d7RZhbi/75+cK2aHOOTge5J0hJazxxcgx/nb09nfPgeRB
   Ns7e2fIXzAAFOA2vKwwVPIqPeaktvBhrK4iwAfagSrpQCTfOwNxSyCZGg
   3mn0IG34RmSVHk8A8bpA9McAXBZ75qilbzreRQDB1+MaUnNYcvupbQ6qH
   lMk2FF4acIP4LyYz7GCIiA/RYRRLyQ5wX7s+8V+eThkJo8hQwS5Vr7tJx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="409355288"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="409355288"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 02:15:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="658935864"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="658935864"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jan 2023 02:15:43 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 02:15:43 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 02:15:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 02:15:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNQskZZDri2XUC1Ph58odhkthgGPMvvH5GIC9waXZ9XdjtK90EJ7bfVxx9KLLK7thVvw/DShYw3xxstfyI2Hb7Cf9mvgCwEH6piRNbg7/cm2X8m2sCzv4qRzBqbUmIHMzTWIdgPp/qjAhYET+boa+W+bObqhhCNK6kgI9QuaNF3UWOhrS+orc8Tb+hqpQsaIOdKtP5OwoUXKfRbs8KGxBE3QKcnUiA3PHRKXwbAjugpE5g0FnoGKI4XOdWYQv5XccVvsA7QVhMI5Q+4+cwAko2+sRsGhYJlffel3XywgBNgUrsDEHWfhED4ax4n012R4MtgSW3fLyKyLuV/VvAcoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LTf5rb/NYl4HrDrTysjK9KXBuwoFYfmJo9T/R4EgDg=;
 b=elxV7NzgQ/iOSAw0DIORAhebrVbvJg+IuYIyG4+KOYqWpiArNgO+aRre9/v0OwvDz1AeC8PTX/uF+Cl2sGW3UB0LHRKk4a8ssgqqckvjoX/OWf2RAaJWil9LGCFHDf++muYYiCXR9krh6TtBBXluIweMyx7eobxBOvCr0KwYOqW+JhGIkVkMUpRyUXQh2IB5Mb0oZzPAta7M+rDP9Xds5hcM0W2tJVbQ00BBOB98bc9QxCXcrrQt0VHl55MrZHydX8YnC9IuNmzffgUDKDlGyDKMWXKEG2GXhiwr1t0FfTJcsCG5jnv8M1NMwb8wGZcJfYxcSJEJt+JXQRBqPJBCag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6944.namprd11.prod.outlook.com (2603:10b6:806:2bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 10:15:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 10:15:40 +0000
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 13/16] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v8 13/16] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHZC5gTAr18MF1uBkCdPkCajcg97a6SKw2AgAV2uwA=
Date:   Tue, 10 Jan 2023 10:15:39 +0000
Message-ID: <d5134f59dcffdf5842a811c89dc336486885ea0b.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <383a2fb52a36d1e772bc547c289c5aeb8ea5d9cb.1670566861.git.kai.huang@intel.com>
         <9dca3a1d-eace-07ed-4cd2-09621912314a@intel.com>
In-Reply-To: <9dca3a1d-eace-07ed-4cd2-09621912314a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6944:EE_
x-ms-office365-filtering-correlation-id: 78bbbe3a-bd82-4db3-e1c4-08daf2f39feb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lq3tjZINIzdtB7LHLrbJWBFCsEWVQqug5SIhYqVQcEpMyALAGJl2jMlhA5MfvjB7gSTkMFS/LdC2OyykxsV8PYTz/ha6S1rvhHYXLlehP3pK5wAdyBq1KiNE8Lz/RbRvORAUq1PIqJuMoFe0xw97ZDAIY6npuvTviWrxr7KzcotMMtSF20O86mA0Ku3X/FtCPzpnl+kOILUBrRxIngBQSez+uVXhOg5JpYiMDbE+UVmcsKHAdXQ0T9dMhO1PZY47ghEIGMqdQj/y2FQSMlZmnqu/jccoR6gkRGa0nnsGtgqIqCGlA1wlMAzw0zU9Rz19VvFA/sceji1B6QSYnUjWKOjHRQck/FKWKAqYBSF6bGXn9AZ8XkAu40vichO08gDLwaXMI9DBeSXsc4umUjbA18Y6QuEZ9Nzi/VZL2A+ReiKznWt3Nn43MthzTgi0Bz3Lde38kvRj2aZ56lpI1u5kMfXouTp9rNo71NnjCQZQ8rhF8MmtdKOZIeETeo/sGfsJ3BeDGXc2nngtEG4klKS4A+66pBQRVqdlUsx1dE1yzByK3edpp6KuEkbJYYx8M1nEoJiNLhHIM9OgeSymJYsbcBXFC1Mhm49D+qAaGa2QYQPDhPAS55z5aZNeoXG84UZDfIDlspunlvw7Pqo78dv/fT3UF4HKGAuz5rhKuYnN4oE5HYxuzbK8Fot0sQilcbM7cBj8woxsRZ7qQI8X7KQoM3QVL0w0uSW6jcL9iCb8EJrlwU0G47pPEvQs9NwsitmPD5RyDBTFRKMBJg5Bkgmr2l7/gCFCOuRDTAHpJF2mLvTUdlO3UFRXJK0FfvOxWK0h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(66946007)(41300700001)(2906002)(8936002)(36756003)(5660300002)(7416002)(91956017)(8676002)(66476007)(66446008)(6512007)(76116006)(66556008)(64756008)(316002)(110136005)(71200400001)(54906003)(6486002)(53546011)(478600001)(966005)(6506007)(186003)(4326008)(26005)(2616005)(83380400001)(86362001)(38100700002)(82960400001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnUzNHh0aXZDdjcrNTIwdWJmZGtLLzdoRFp3NDRnSEJ4NEhzOHQ5aU5CNjRG?=
 =?utf-8?B?QVVsdnZrQ0NPbE56cUZpU1pOMHJScEFBM1VrTWdsOXI3dEttNUwxeU9pR0ZT?=
 =?utf-8?B?anZrRWRQVmozdUpiaXEzd25FV0JUNWJnRlNWTmplNnM1SlJJWG1iek9YTnlI?=
 =?utf-8?B?cTQxNGF0NzI3QnRJdXlzcEt3UGRmdmhFT0tJalBqOS9JTmx0eHBIbW5rSEFV?=
 =?utf-8?B?eE9HM3BvTk5iQUdVOG83alJCakNiOW1YeUFFZ09VdFg5YVZ0SmFBSFVqOUlU?=
 =?utf-8?B?S3ZhUlJyZ1BBeURhVXg0WXNBQ2w0emZFbzJqQ3ljQVVpRE11d3VremxDMmZl?=
 =?utf-8?B?bzBrTzY2NnRwOVp1dDZJM3JEVmdhblVBQkIxQmdaQmtKQXdaYUk5TVAvUkxu?=
 =?utf-8?B?SU9VNXBVYURPQURIWkZ4SHU4SERMWE40QVJMUW1rZjdZdkpHdUhiSldYK2FV?=
 =?utf-8?B?RC9QZzRYYWJBRHJ3WFRJQTlOV08yVzUrSmloclBlOURNMTlNWjBSNkxDZFJx?=
 =?utf-8?B?SENZdG9QU1VGZUZLRzIrclZFaUhJdFFpNXA0ZUFwazYyN0FIMEpobXUrSEVN?=
 =?utf-8?B?MUxWdFNiMHB5SzhVazAyTklsb2lHZTFLUWRHNEF1UndRc1YwY0ZuTWs0SDB2?=
 =?utf-8?B?enhiYkZ0SFRPUW5pMWZHQTc0cW5USkVPZzdtemZENU8vY3ptQkk5UGRVNlJE?=
 =?utf-8?B?YVgyRnpUbHZISks3b3hSOUxFNk9GZ1hpdDBNM0Q2SFB5NWFodE5ha3R3TDR5?=
 =?utf-8?B?a2hORjRSV2VLeVNnaDlrUWVxNkZhUGI3SEM1a1pJMU8zVG16NGladjNUUFlk?=
 =?utf-8?B?b0crdWhKbEQrZUVtOGIvMEwyZGdMb20zUFB1VDc3b0s5bFpKbWhUamdDQXdU?=
 =?utf-8?B?Z09tOERGMXJKZ2JFcXBzcUp6bXl6Mng1WU9JZlB1ck93NndSZStzZzZGY2ZG?=
 =?utf-8?B?MXVxTVBFc1hCektjcFAzdm5kR2h4MDhnV3FjcXFEYmFzcWtGU1lHUlB5SDI1?=
 =?utf-8?B?NUE2TzA1RVhrRHpOMnpJNFh4TWhRelcwTWszcHpvRm9tRTZoUkRNZWUzOUQ0?=
 =?utf-8?B?RXg0aXZKc3dKMHpQNVAzZ2N1RVZCTmhVM2NxMjZEUlJVZUdLZEE1S1JMdEh4?=
 =?utf-8?B?K2dPb3BBS2RJRDVwSHZoV25BQ0gxQ3I1QXJWcCszUUFVbGhxVlZaUVlYVDVW?=
 =?utf-8?B?RlJrbnFuRHdQUTVvY3pqT1JTUEEza0swRjJySGFEbU1tTVFpMWcxcnFXblc2?=
 =?utf-8?B?MHU4aXJnaXlNMTBBN1JHVU9QdHNiUlQxb2huODZOWEpRNlpwaS9CUXNpNHoz?=
 =?utf-8?B?Y1E4a0NhMkVUSVcrRElSVHI1K2l6S0dXalZFcVE0RXF5YjZDR2Z2ZENaaXVM?=
 =?utf-8?B?K0ltbjVIUWpXQ1FnRkp0L3dCbHE3b0piVU9EVHFIcTNJbG9nRTJnVmRWc1VN?=
 =?utf-8?B?STFnMjhkUzFJbU9ZYW1IdnFxLzlBam8zc1FWZmR5TUc5ZFBOR01uUFdRVnVT?=
 =?utf-8?B?YWE5a0V1aFZ4TDZWYVlhS3lyMGdtUDRlZ3k5NGxZbzVRRVA2VkJRbzFiZUxG?=
 =?utf-8?B?UXk2dmxTVzVNdyszdE8wM0RDU2FFZFliYk1lRTM5R3pDL09YL3R3am1WVW5T?=
 =?utf-8?B?aktRRkhBSGZUYzhpVk1BSkxzOGhmWUtlMEFzMXpoV1Zqb2hGY3lQRWFlTmx5?=
 =?utf-8?B?MnFINStHMlZjd2FiMDJ1ZjMyaEdVM2I0c3RYWmJ6Sm1La0ZSSDFkM1ZLQVFk?=
 =?utf-8?B?RGp4UzlmU24vRCtxQ2Mvck92WWFSZ2IxMUVWRURFMlRHdWZSb0pkSzVkVzRF?=
 =?utf-8?B?T3FNaTVsK0R6YmcxMVRqTS9kelU1UzlFdHBkUnQ1V25VMzBSdEZ4eXBMcmhH?=
 =?utf-8?B?ZjRLTzZ3ZDh5dWJSczRJZVN5V0NxQStWRno5RnBHVmdXS3ZFeEp3MUllMEc2?=
 =?utf-8?B?TFBtWG11ODE0Sm11eUZyL3ZnMjFtWWlzcURoS3R2VDd4YzFWQXp5Q1kzUFJ1?=
 =?utf-8?B?WTU0R09YUHl1ZS8vOVhpZGRQWFJWZUF5dHN6OWxkdjhiMEd4TzhqbmU1c1Rv?=
 =?utf-8?B?YVBObGVOcHBuWFJCMW1wTkQwQmY4d2poN2ZvSFJScmV5S0tXKzlWcjVqTVkz?=
 =?utf-8?B?ZitCTlFEaEt3QjY0QnBDU3JjcVArRmVhUnBQeGIzT0NEZ3lwNUNEQk15bkhM?=
 =?utf-8?B?dEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0653C1BCF939774D89BFA42D55DB2F43@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bbbe3a-bd82-4db3-e1c4-08daf2f39feb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 10:15:40.0045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n4S68lz/VJWJmUQNyYJHm9zlc1p1IMPrXuYY2qBhydy1bknyhCWbbJ6ryGQeJSEAJNWCYn5ISxxvNN+zQNzAow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDE0OjQ5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEFmdGVyIHRoZSBsaXN0IG9m
IFRETVJzIGFuZCB0aGUgZ2xvYmFsIEtleUlEIGFyZSBjb25maWd1cmVkIHRvIHRoZSBURFgNCj4g
PiBtb2R1bGUsIHRoZSBrZXJuZWwgbmVlZHMgdG8gY29uZmlndXJlIHRoZSBrZXkgb2YgdGhlIGds
b2JhbCBLZXlJRCBvbiBhbGwNCj4gPiBwYWNrYWdlcyB1c2luZyBUREguU1lTLktFWS5DT05GSUcu
DQo+ID4gDQo+ID4gVERILlNZUy5LRVkuQ09ORklHIG5lZWRzIHRvIGJlIGRvbmUgb24gb25lIChh
bnkpIGNwdSBmb3IgZWFjaCBwYWNrYWdlLg0KPiA+IEFsc28sIGl0IGNhbm5vdCBydW4gY29uY3Vy
cmVudGx5IG9uIGRpZmZlcmVudCBjcHVzLCBzbyBqdXN0IHVzZQ0KPiA+IHNtcF9jYWxsX2Z1bmN0
aW9uX3NpbmdsZSgpIHRvIGRvIGl0IG9uZSBieSBvbmUuDQo+ID4gDQo+ID4gTm90ZSB0byBrZWVw
IHRoaW5ncyBzaW1wbGUsIG5laXRoZXIgdGhlIGZ1bmN0aW9uIHRvIGNvbmZpZ3VyZSB0aGUgZ2xv
YmFsDQo+ID4gS2V5SUQgb24gYWxsIHBhY2thZ2VzIG5vciB0aGUgdGR4X2VuYWJsZSgpIGNoZWNr
cyB3aGV0aGVyIHRoZXJlJ3MgYXQNCj4gPiBsZWFzdCBvbmUgb25saW5lIGNwdSBmb3IgZWFjaCBw
YWNrYWdlLiAgQWxzbywgbmVpdGhlciBvZiB0aGVtIGV4cGxpY2l0bHkNCj4gPiBwcmV2ZW50cyBh
bnkgY3B1IGZyb20gZ29pbmcgb2ZmbGluZS4gIEl0IGlzIGNhbGxlcidzIHJlc3BvbnNpYmlsaXR5
IHRvDQo+ID4gZ3VhcmFudGVlIHRoaXMuDQo+IA0KPiBPSywgYnV0IGRvZXMgc29tZW9uZSAqYWN0
dWFsbHkqIGRvIHRoaXM/DQoNClBsZWFzZSBzZWUgYmVsb3cgcmVwbHkgYXJvdW5kIHRoZSBjb2Rl
Lg0KDQo+IA0KPiA+IEludGVsIGhhcmR3YXJlIGRvZXNuJ3QgZ3VhcmFudGVlIGNhY2hlIGNvaGVy
ZW5jeSBhY3Jvc3MgZGlmZmVyZW50DQo+ID4gS2V5SURzLiAgVGhlIGtlcm5lbCBuZWVkcyB0byBm
bHVzaCBQQU1UJ3MgZGlydHkgY2FjaGVsaW5lcyAoYXNzb2NpYXRlZA0KPiA+IHdpdGggS2V5SUQg
MCkgYmVmb3JlIHRoZSBURFggbW9kdWxlIHVzZXMgdGhlIGdsb2JhbCBLZXlJRCB0byBhY2Nlc3Mg
dGhlDQo+ID4gUEFNVC4gIE90aGVyd2lzZSwgdGhvc2UgZGlydHkgY2FjaGVsaW5lcyBjYW4gc2ls
ZW50bHkgY29ycnVwdCB0aGUgVERYDQo+ID4gbW9kdWxlJ3MgbWV0YWRhdGEuICBOb3RlIHRoaXMg
YnJlYWtzIFREWCBmcm9tIGZ1bmN0aW9uYWxpdHkgcG9pbnQgb2YNCj4gPiB2aWV3IGJ1dCBURFgn
cyBzZWN1cml0eSByZW1haW5zIGludGFjdC4NCj4gDQo+IAlJbnRlbCBoYXJkd2FyZSBkb2Vzbid0
IGd1YXJhbnRlZSBjYWNoZSBjb2hlcmVuY3kgYWNyb3NzDQo+IAlkaWZmZXJlbnQgS2V5SURzLiAg
VGhlIFBBTVRzIGFyZSB0cmFuc2l0aW9uaW5nIGZyb20gYmVpbmcgdXNlZA0KPiAJYnkgdGhlIGtl
cm5lbCBtYXBwaW5nIChLZXlJZCAwKSB0byB0aGUgVERYIG1vZHVsZSdzICJnbG9iYWwNCj4gCUtl
eUlEIiBtYXBwaW5nLg0KPiANCj4gCVRoaXMgbWVhbnMgdGhhdCB0aGUga2VybmVsIG11c3QgZmx1
c2ggYW55IGRpcnR5IEtleUlELTAgUEFNVA0KPiAJY2FjaGVsaW5lcyBiZWZvcmUgdGhlIFREWCBt
b2R1bGUgdXNlcyB0aGUgZ2xvYmFsIEtleUlEIHRvIGFjY2Vzcw0KPiAJdGhlIFBBTVQuICBPdGhl
cndpc2UsIGlmIHRob3NlIGRpcnR5IGNhY2hlbGluZXMgd2VyZSB3cml0dGVuDQo+IAliYWNrLCB0
aGV5IHdvdWxkIGNvcnJ1cHQgdGhlIFREWCBtb2R1bGUncyBtZXRhZGF0YS4gIEFzaWRlOiBUaGlz
DQo+IAljb3JydXB0aW9uIHdvdWxkIGJlIGRldGVjdGVkIGJ5IHRoZSBtZW1vcnkgaW50ZWdyaXR5
IGhhcmR3YXJlIG9uDQo+IAl0aGUgbmV4dCByZWFkIG9mIHRoZSBtZW1vcnkgd2l0aCB0aGUgZ2xv
YmFsIEtleUlELiAgVGhlIHJlc3VsdA0KPiAJd291bGQgbGlrZWx5IGJlIGZhdGFsIHRvIHRoZSBz
eXN0ZW0gYnV0IHdvdWxkIG5vdCBpbXBhY3QgVERYDQo+IAlzZWN1cml0eS4NCg0KVGhhbmtzIQ0K
DQo+IA0KPiA+IEZvbGxvd2luZyB0aGUgVERYIG1vZHVsZSBzcGVjaWZpY2F0aW9uLCBmbHVzaCBj
YWNoZSBiZWZvcmUgY29uZmlndXJpbmcNCj4gPiB0aGUgZ2xvYmFsIEtleUlEIG9uIGFsbCBwYWNr
YWdlcy4gIEdpdmVuIHRoZSBQQU1UIHNpemUgY2FuIGJlIGxhcmdlDQo+ID4gKH4xLzI1NnRoIG9m
IHN5c3RlbSBSQU0pLCBqdXN0IHVzZSBXQklOVkQgb24gYWxsIENQVXMgdG8gZmx1c2guDQo+ID4g
DQo+ID4gTm90ZSBpZiBhbnkgVERILlNZUy5LRVkuQ09ORklHIGZhaWxzLCB0aGUgVERYIG1vZHVs
ZSBtYXkgYWxyZWFkeSBoYXZlDQo+ID4gdXNlZCB0aGUgZ2xvYmFsIEtleUlEIHRvIHdyaXRlIGFu
eSBQQU1ULiAgVGhlcmVmb3JlLCBuZWVkIHRvIHVzZSBXQklOVkQNCj4gPiB0byBmbHVzaCBjYWNo
ZSBiZWZvcmUgZnJlZWluZyB0aGUgUEFNVHMgYmFjayB0byB0aGUga2VybmVsLg0KPiANCj4gCQkJ
CQkJcy9uZWVkIHRvLy8gXg0KDQpXaWxsIGRvLiAgVGhhbmtzLg0KDQo+IA0KPiANCj4gPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5jDQo+ID4gaW5kZXggYWI5NjE0NDNmZWQ1Li40Yzc3OWU4NDEyZjEgMTAwNjQ0DQo+
ID4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQo+ID4gQEAgLTk0Niw2ICs5NDYsNjYgQEAgc3RhdGljIGludCBj
b25maWdfdGR4X21vZHVsZShzdHJ1Y3QgdGRtcl9pbmZvX2xpc3QgKnRkbXJfbGlzdCwgdTY0IGds
b2JhbF9rZXlpZCkNCj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPiAgDQo+ID4gK3N0YXRp
YyB2b2lkIGRvX2dsb2JhbF9rZXlfY29uZmlnKHZvaWQgKmRhdGEpDQo+ID4gK3sNCj4gPiArCWlu
dCByZXQ7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFRESC5TWVMuS0VZLkNPTkZJRyBtYXkg
ZmFpbCB3aXRoIGVudHJvcHkgZXJyb3IgKHdoaWNoIGlzIGENCj4gPiArCSAqIHJlY292ZXJhYmxl
IGVycm9yKS4gIEFzc3VtZSB0aGlzIGlzIGV4Y2VlZGluZ2x5IHJhcmUgYW5kDQo+ID4gKwkgKiBq
dXN0IHJldHVybiBlcnJvciBpZiBlbmNvdW50ZXJlZCBpbnN0ZWFkIG9mIHJldHJ5aW5nLg0KPiA+
ICsJICovDQo+ID4gKwlyZXQgPSBzZWFtY2FsbChUREhfU1lTX0tFWV9DT05GSUcsIDAsIDAsIDAs
IDAsIE5VTEwsIE5VTEwpOw0KPiA+ICsNCj4gPiArCSooaW50ICopZGF0YSA9IHJldDsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiArLyoNCj4gPiArICogQ29uZmlndXJlIHRoZSBnbG9iYWwgS2V5SUQgb24g
YWxsIHBhY2thZ2VzIGJ5IGRvaW5nIFRESC5TWVMuS0VZLkNPTkZJRw0KPiA+ICsgKiBvbiBvbmUg
b25saW5lIGNwdSBmb3IgZWFjaCBwYWNrYWdlLiAgSWYgYW55IHBhY2thZ2UgZG9lc24ndCBoYXZl
IGFueQ0KPiA+ICsgKiBvbmxpbmUNCj4gDQo+IFRoaXMgbG9va3MgbGlrZSBpdCBzdG9wcGVkIG1p
ZC1zZW50ZW5jZS4NCg0KT29wcyBJIGZvcmdvdCB0byBkZWxldGUgdGhlIGJyb2tlbiBzZW50ZW5j
ZS4NCg0KPiANCj4gPiArICogTm90ZToNCj4gPiArICoNCj4gPiArICogVGhpcyBmdW5jdGlvbiBu
ZWl0aGVyIGNoZWNrcyB3aGV0aGVyIHRoZXJlJ3MgYXQgbGVhc3Qgb25lIG9ubGluZSBjcHUNCj4g
PiArICogZm9yIGVhY2ggcGFja2FnZSwgbm9yIGV4cGxpY2l0bHkgcHJldmVudHMgYW55IGNwdSBm
cm9tIGdvaW5nIG9mZmxpbmUuDQo+ID4gKyAqIElmIGFueSBwYWNrYWdlIGRvZXNuJ3QgaGF2ZSBh
bnkgb25saW5lIGNwdSB0aGVuIHRoZSBTRUFNQ0FMTCB3b24ndCBiZQ0KPiA+ICsgKiBkb25lIG9u
IHRoYXQgcGFja2FnZSBhbmQgdGhlIGxhdGVyIHN0ZXAgb2YgVERYIG1vZHVsZSBpbml0aWFsaXph
dGlvbg0KPiA+ICsgKiB3aWxsIGZhaWwuICBUaGUgY2FsbGVyIG5lZWRzIHRvIGd1YXJhbnRlZSB0
aGlzLg0KPiA+ICsgKi8NCj4gDQo+ICpEb2VzKiB0aGUgY2FsbGVyIGd1YXJhbnRlZSBpdD8NCj4g
DQo+IFlvdSdyZSBiYXNpY2FsbHkgc2F5aW5nLCAidGhpcyBjb2RlIG5lZWRzICRGT08gdG8gd29y
ayIsIGJ1dCB5b3UncmUgbm90DQo+IHNheWluZyB3aG8gKnByb3ZpZGVzKiAkRk9PLg0KDQpJbiBz
aG9ydCwgS1ZNIGNhbiBkbyBzb21ldGhpbmcgdG8gZ3VhcmFudGVlIGJ1dCB3b24ndCAxMDAlIGd1
YXJhbnRlZSB0aGlzLg0KDQpTcGVjaWZpY2FsbHksIEtWTSB3b24ndCBhY3RpdmVseSB0cnkgdG8g
YnJpbmcgdXAgY3B1IHRvIGd1YXJhbnRlZSB0aGlzIGlmDQp0aGVyZSdzIGFueSBwYWNrYWdlIGhh
cyBubyBvbmxpbmUgY3B1IGF0IGFsbCAoc2VlIHRoZSBmaXJzdCBsb3JlIGxpbmsgYmVsb3cpLiAN
CkJ1dCBLVk0gY2FuIF9jaGVja18gd2hldGhlciB0aGlzIGNvbmRpdGlvbiBoYXMgYmVlbiBtZXQg
YmVmb3JlIGNhbGxpbmcNCnRkeF9pbml0KCkgYW5kIHNwZWFrIG91dCBpZiBub3QuICBBdCB0aGUg
bWVhbnRpbWUsIGlmIHRoZSBjb25kaXRpb24gaXMgbWV0LA0KcmVmdXNlIHRvIG9mZmxpbmUgdGhl
IGxhc3QgY3B1IGZvciBlYWNoIHBhY2thZ2UgKG9yIGFueSBjcHUpIGR1cmluZyBtb2R1bGUNCmlu
aXRpYWxpemF0aW9uLg0KDQpBbmQgS1ZNIG5lZWRzIHNpbWlsYXIgaGFuZGxpbmcgYW55d2F5LiAg
VGhlIHJlYXNvbiBpcyBub3Qgb25seSBjb25maWd1cmluZyB0aGUNCmdsb2JhbCBLZXlJRCBoYXMg
c3VjaCByZXF1aXJlbWVudCwgY3JlYXRpbmcvZGVzdHJveWluZyBURCAod2hpY2ggaW52b2x2ZXMN
CnByb2dyYW1taW5nL3JlY2xhaW1pbmcgb25lIFREWCBLZXlJRCkgYWxzbyByZXF1aXJlIGF0IGxl
YXN0IG9uZSBvbmxpbmUgY3B1IGZvcg0KZWFjaCBwYWNrYWdlLiDCoA0KDQpUaGVyZSB3ZXJlIGRp
c2N1c3Npb25zIGFyb3VuZCB0aGlzIG9uIEtWTSBob3cgdG8gaGFuZGxlLiAgSUlVQyB0aGUgc29s
dXRpb24gaXMNCktWTSB3aWxsOg0KMSkgZmFpbCB0byBjcmVhdGUgVEQgaWYgYW55IHBhY2thZ2Ug
aGFzIG5vIG9ubGluZSBjcHUuDQoyKSByZWZ1c2UgdG8gb2ZmbGluZSB0aGUgbGFzdCBjcHUgZm9y
IGVhY2ggcGFja2FnZSB3aGVuIHRoZXJlJ3MgYW55IF9hY3RpdmVfIFREWA0KZ3Vlc3QgcnVubmlu
Zy4NCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIyMTEwMjIzMTkxMS4zMTA3NDM4
LTEtc2VhbmpjQGdvb2dsZS5jb20vVC8jbTFmZjMzODY4NmNmY2I3YmE2OTFjZDk2OWFjYzE3YjMy
ZmYxOTQwNzMNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvZGU2YjY5NzgxYTZiYTFmZTY1
NTM1ZjQ4ZGIyNjc3ZWVmM2VjNmE4My4xNjY3MTEwMjQwLmdpdC5pc2FrdS55YW1haGF0YUBpbnRl
bC5jb20vDQoNClRodXMgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiBpbiBLVk0gY2FuIGJlIGhh
bmRsZWQgaW4gc2ltaWxhciB3YXkuDQoNCkJ0dywgaW4gdjcgKHdoaWNoIGhhcyBwZXItbHAgaW5p
dCByZXF1aXJlbWVudCBvbiBhbGwgY3B1cyksIHRkeF9pbml0KCkgZG9lcw0KZWFybHkgY2hlY2sg
b24gd2hldGhlciBhbGwgbWFjaGluZSBib290LXRpbWUgcHJlc2VudCBjcHUgYXJlIG9ubGluZSBh
bmQgc2ltcGx5IA0KcmV0dXJucyBlcnJvciBpZiBjb25kaXRpb24gaXMgbm90IG1ldC4gIEhlcmUg
dGhlIGRpZmZlcmVuY2UgaXMgd2UgZG9uJ3QgaGF2ZSBhbnkNCmNoZWNrIGJ1dCBkZXBlbmQgb24g
U0VBTUNBTEwgdG8gZmFpbC4gIFRvIG1lIHRoZXJlJ3Mgbm8gZnVuZGFtZW50YWwgZGlmZmVyZW5j
ZS4NCg0KW3NuaXBdDQoNCj4gDQo+ID4gIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQp
DQo+ID4gIHsNCj4gPiAgCS8qDQo+ID4gQEAgLTk5OCwxOSArMTA1OCw0NiBAQCBzdGF0aWMgaW50
IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiA+ICAJaWYgKHJldCkNCj4gPiAgCQlnb3RvIG91dF9m
cmVlX3BhbXRzOw0KPiA+ICANCj4gPiArCS8qDQo+ID4gKwkgKiBIYXJkd2FyZSBkb2Vzbid0IGd1
YXJhbnRlZSBjYWNoZSBjb2hlcmVuY3kgYWNyb3NzIGRpZmZlcmVudA0KPiA+ICsJICogS2V5SURz
LiAgVGhlIGtlcm5lbCBuZWVkcyB0byBmbHVzaCBQQU1UJ3MgZGlydHkgY2FjaGVsaW5lcw0KPiA+
ICsJICogKGFzc29jaWF0ZWQgd2l0aCBLZXlJRCAwKSBiZWZvcmUgdGhlIFREWCBtb2R1bGUgY2Fu
IHVzZSB0aGUNCj4gPiArCSAqIGdsb2JhbCBLZXlJRCB0byBhY2Nlc3MgdGhlIFBBTVQuICBHaXZl
biBQQU1UcyBhcmUgcG90ZW50aWFsbHkNCj4gPiArCSAqIGxhcmdlICh+MS8yNTZ0aCBvZiBzeXN0
ZW0gUkFNKSwganVzdCB1c2UgV0JJTlZEIG9uIGFsbCBjcHVzDQo+ID4gKwkgKiB0byBmbHVzaCB0
aGUgY2FjaGUuDQo+ID4gKwkgKg0KPiA+ICsJICogRm9sbG93IHRoZSBURFggc3BlYyB0byBmbHVz
aCBjYWNoZSBiZWZvcmUgY29uZmlndXJpbmcgdGhlDQo+ID4gKwkgKiBnbG9iYWwgS2V5SUQgb24g
YWxsIHBhY2thZ2VzLg0KPiA+ICsJICovDQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoaXMgc2Vjb25k
IHBhcmFncmFwaCBhZGRzIHZlcnkgbXVjaCBjbGFyaXR5Lg0KPiANCj4gDQoNCk9LIHdpbGwgcmVt
b3ZlLg0KDQo=
