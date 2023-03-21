Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35E16C2BE9
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 09:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCUIG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 04:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjCUIGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 04:06:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC80FAD0F;
        Tue, 21 Mar 2023 01:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679385981; x=1710921981;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SG74NabLj7F9ngQcEECxrGcQOCmoBvn0ICklqB2yFLc=;
  b=TSTG+XW0m40wM1OqBpvzEbhQG7ho9sispMkXo8hhAb6X+OrTPOQMweZN
   yRmTKvMdLOMoQnZbfspq7OtAiv6kWW7JsbKlnjRiGj/4ygYnZnM1MNWba
   Lu/GXd3zksPNXX8x/IH92/Lra5/ChohYmInVLVKD6bF1G83qQASokcc2i
   85luw12Pj+cAecZUNZokSzmfJ6WGzz5lGXqKu9HfRcBidEzTXHTN/uiiE
   PEZyhsUE6TMMigkttXy64vamWsecliN/QjKiV5v+JVtg/CKHait4PC9Fj
   mcGTdwdYKV95OLhjON46T8UuiRr2n3A2Ti+el+DKzfNVSH30BMICEuaJ7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="340421919"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="340421919"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 01:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="713891331"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="713891331"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 21 Mar 2023 01:06:03 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 01:05:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 01:05:58 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 01:05:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpnbRYxmRwOGF4oKEzkX8yezN+RUnOLROaGpYB4u203bs9tuL+Pk66oPuAiBMs5x+snbxmlldFnEB9bwrrYQkKt0Z0MGTtKM0wBuAjSMSbkHPi9hnICXmz82c6Fo4M0KfjA/fE2iVijciPTsdbCX8r6TKhMmxHBVOh9W7eFtQwCq0TuG8Z/XnLog44rIYITSO5CsUS+Yerh+ReQiud0qgd8+aCkiExXcH0sMFQZFQ9EUTInAVWKJv3jbg3Gi+4H9MV302erC7PN/Ix+1sjmSZ5qJrPqbP+77cuv1//cXizFNzHUtFj4KHk5HDSSsq2z03tqwfiXEb3lMrXkT7MyDJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SG74NabLj7F9ngQcEECxrGcQOCmoBvn0ICklqB2yFLc=;
 b=aBu70e7P4f6qYf4YE8JuBYFNReRTGwcPliTc4ekDZQI1fBK3LrZ8PVb6b6nF0m+FHP86mAjsZ2qYeXpbkU6F4y+qE6oWSotrDzzecsNRDsbnXB27deVUTNMMzdIaE8D7Wtaqcn75B2oVizX9iFmfFwijesI4XqOzgoVj80EEKXBtc1akDH6Tt6QihTCTGT6ZfIHn68gic7NqYwidk2l8xn2qqlu1T7SqQM4jTsAfU0eL/Bw3aWuPcvmLwPtHouw16pd8f7aDCfC2D5/ayw+MaaNkCEkMiATtiQr0CApXIlKgPpgUKBqATmqRPza3EJn21b81/HSZmwS/K6uyswqVjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6944.namprd11.prod.outlook.com (2603:10b6:806:2bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 08:05:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 08:05:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v10 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZUDU/dDGyCqnt3kWU+OxOVAYGTK8E8ZWAgAAF5YA=
Date:   Tue, 21 Mar 2023 08:05:52 +0000
Message-ID: <ce375c4a84bb0aafae73df8ddbcd1dc7024cee79.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <5192c24339960c11dcedd42fecb5d49128bbe072.1678111292.git.kai.huang@intel.com>
         <BL0PR11MB30427B24E47E9612FD2DD27A8A819@BL0PR11MB3042.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB30427B24E47E9612FD2DD27A8A819@BL0PR11MB3042.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6944:EE_
x-ms-office365-filtering-correlation-id: c814d630-79bc-4ded-78a4-08db29e3173b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wfFEc7UzgCbboJLHvaSWCw3Am2hzT6kN4I/YtXM8G/9T3vGLnlbMxzjLu+J1HKm8aLJTe6X48Dcs0Cwph2z31Zc3e0h4ZIjobJrEbtuz+twp5h088MQjL0hvSS+mtB42Ork9ztXJz86C/XUn/JymF8rspowz1ZC5FtEWkfPgUWkiSJoCs2i6r5jYGL9KtAY7WZO1/xEPBqjZMSntsvJ0PVIxl2gy7PerzHOR+6o5g3zY0e6/Z+unfj1lUfANdS5Lq3wUBGHUquEz7onoh480YSX+OE0SfC6qUKm7iKWQ4xCYouJYOV6ABlBTxvP9wzFxSiYhhnrI9EDAJepVldlCQFwmrE1zJiWRWYolm3N3kINH6KFaiwCgXF1tab+DFdKj/gkHbG4VLiTSntDVRJIeHy6GgNdvV5oZGhgBtrBPwS6+EWFKcUny4HXU2AOphnKxc3wBle7AuvfmmYN43VSa98HCi392G+InJ9dsEXSQ4RQo3v+kYKLHhX/YevityDo2db+kEKgFwX9MYoBDF9dzeJxqgp7JrfFzbUTO3R1/rFuJtdEygZu3T18/51U1gdandkPp1nfLxPx13IQEyQsGm2jVfiycDzWJa8jBFowUGaY7wQMVTnUnSp++p1aSRP6T6znqQUgN68JBLoOjhn2oXFGIOSTu6r4i1oKJIngmHv8shwHe+hIZ+cCCAk99BcDmZ2w8WQ5k/gr6P0lr3eK4uauW/qxLk5o5puVrzV7bTzF4CLoKUYh6k975u8nlfvnsBtDCdTgxFfk/ovk18ss3fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199018)(41300700001)(478600001)(26005)(6506007)(6512007)(316002)(54906003)(110136005)(38070700005)(186003)(71200400001)(86362001)(6486002)(66446008)(66946007)(76116006)(64756008)(66556008)(66476007)(4326008)(36756003)(8676002)(91956017)(2616005)(38100700002)(2906002)(4744005)(122000001)(82960400001)(8936002)(5660300002)(7416002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmg4ak5jZkFkR29MeTVPNk9oMGkxSFUwVFIzZjNrTFZJV2wxOWhjQkRzQ2Ez?=
 =?utf-8?B?RzJ2TkYvdlJLMktqN2tOaDVCQXJDQnFnL0dudG1JQ2lJRzlPUUhocE9CM29x?=
 =?utf-8?B?aHpPaVVJQUVENUwyV0w2ZjJXd1hvM1BtWHRURzZSSFdqdGo2L0NNcGhYRHVS?=
 =?utf-8?B?b2F5eVJHQnlKN0lPeFVCUUIvM2g5TjVuWnBqY3hWaVg1VVQ4cGxwUDR2Rkg0?=
 =?utf-8?B?a3h0Rmg4ajBqZURVeUx5M2lVTUVBYzZldmFPTlFEbk5XV2NLT2NFc3o1MDJ4?=
 =?utf-8?B?ZW12WU9zWit5UUtiQm01L3EybE5Qa3BzcHVBZS9SdDhNOXZQTjdwNGNZcGd5?=
 =?utf-8?B?ODZxcFhIcFpYWGc0TUs3TGZadG9Ucjg0dUxkNmtlYnVXUkV0S0lzWVJjTlVJ?=
 =?utf-8?B?NC9ZcThraEhVVFJ6Q3J2VndGU0QrdVpLVG5tdDRZQjU1Vms1aHZ2OG9JWU93?=
 =?utf-8?B?ZkFlazhjUGRLQThQeXc2SmQ2RkMzU3NYL09IVzFySmoycFdSRk1ObVk3bnpS?=
 =?utf-8?B?aytycERMWDBoTHV5YnBRMStHZGs0UkxlSk9OY2hHMzZIQWtlVlFNWWg2OHlt?=
 =?utf-8?B?eENubHVOT3pkby8xc0ZYQW9YUW5EamU0bTdBUFdDVkxBMFU1UnVEYWdlZVo5?=
 =?utf-8?B?a3o2bldkRStKUXdBT3hZTS9IdHdPTXI0RXM3U3FmTHBqSStYTWpMZkxhY0JE?=
 =?utf-8?B?ZDh6TzdFQXc5OEhCdE1VaVJ6MXhmT2JIcEhoUG4vMWg2aExWT285Y1JzeXNE?=
 =?utf-8?B?bVZ5RHU1VURVeURuVmVaMWpTQUxpcmVQY1REeWFvZnRnbUVURktBbGFFcHdr?=
 =?utf-8?B?L28yd0pLZCtJSzhWMXFuejR6eW5iYlIvNmVIcEp4TnNBOEtaWm56NnZmRkRi?=
 =?utf-8?B?VHBSRWpQT1VsM29PUnoxNGNlZm93NXhzaTcrU3NRc2hSTHZkcjNoNlUveWRP?=
 =?utf-8?B?ZFJTMkZyNmJocXhaMlZSWHJOMytHWEFtSGJQcUlJSk5JNWZ5Z3h5V1hJU1Fp?=
 =?utf-8?B?UmloSTFUank4eEl1OE50blNDelBkTzVTemRvbEYvYkI5NnRTK3BTUXovSlEr?=
 =?utf-8?B?aGdyT1oydm1aTnRNRnBPUkMrMWplRVdzWVdoRHFKZm5wSGFGUVFhTDYxcldG?=
 =?utf-8?B?ZmhDanhtZmoxNkRsYjNMc3F2VGZyWDU1R1dnQjZwRjAyUndVWm9jdUlVdkhX?=
 =?utf-8?B?NGRXcHN2bHNXdkQ5TTNBNHQrTGxrUTA3eDVWMlRHMWY4b1UyNjMvVkFhMlFv?=
 =?utf-8?B?YmxMVEFOL0JsRmFSWlJ4Si9HejFTS0YyWDVjV2tNSHE2TGlleHQwR1FvbXFX?=
 =?utf-8?B?UXlEVEJWUHpMVjVTek05WGdjbEQvZFh2MzlnR0VSSGxrVjFhelZVNy80RHRp?=
 =?utf-8?B?clZQc1k2OGVkWEFrTVVNTitUeEJ6VWpkNWJPOUhHL0VTRHVPZWphMGhEYXRW?=
 =?utf-8?B?ZjQ2a1hId1NldTBweHBsaGRmczczRFBZZnlzSGtxQVdzaEgwVEdXR0E3bGxC?=
 =?utf-8?B?S1hNL0RyVDZaTVNxdVdpcGpXQkljVGJjVER5Ri94QVo4Z3NjQ0JYR1NsUGI1?=
 =?utf-8?B?aW9KaVp5aDBGbjQvZzJrRndaZWtvZ1IwQWwvSW9IeUhtVktKa0p2TlNmTFFU?=
 =?utf-8?B?QkFNZ0ozZ0NlektRZHBVNzBRN1dyM3pSQm9lRkxhQ3hlbFViczVOa2Z6NEV0?=
 =?utf-8?B?UlhvZFBXamlnbE1FSTRYL05QZ2k0WTFZaUhUR0dMazMwMlJlcGJ1VWxrWGNy?=
 =?utf-8?B?Tys3cWp1YUZzWHNUK3NTdHV0Q0dKNStyV3Yxa3AvNHNoSjhrSGpxYnNUbUNi?=
 =?utf-8?B?S3lneTNaNFp5Rmtsb2x5eUFZV0I1aStnbHphSGRrRUhWTE5qOUFxU3J1cFVK?=
 =?utf-8?B?Y01jVyt0Vy9FVkVKZmhpZUkrL0tlRzV2SW1sQ1JhWWtwY0tSanl1ZFh5WkNB?=
 =?utf-8?B?Rm1zZ2RmeTFyZFBKLzFIamx1VDV4WGNMT3hyVVpxSzhaY0xUaXR1d09Sb3lS?=
 =?utf-8?B?cHA5dVkxOVp5ZVFuampNU3d4MHVyM1JMZnoxUzNWeUszU21EYzRxR2UvQjZX?=
 =?utf-8?B?Z1o1c1Iwb3l3RWpudms3UUFGL2g0eTNaUUtxMEdXUXdpWmFndUwzSzVCT0Qw?=
 =?utf-8?B?NDlFQ1Y2QVpKbDNZUWp3d2lRd1N6TktYZXpXNGk3VHFUMzhJQVFySnJ0V2Rt?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3791798DA88AF44EAE0AF113F90FEF3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c814d630-79bc-4ded-78a4-08db29e3173b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 08:05:52.6989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CJrDxT8ZQ2T5V724Dauv+xNVculzt/2cLBa1ZpIklWFGI+RPNZvGhnRmOUZ7UYEPDZ4rFAsdz+da57TRK/RMUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTIxIGF0IDA3OjQ0ICswMDAwLCBEb25nLCBFZGRpZSB3cm90ZToNCj4g
PiANCj4gPiArLyoNCj4gPiArICogQ2FsY3VsYXRlIFBBTVQgc2l6ZSBnaXZlbiBhIFRETVIgYW5k
IGEgcGFnZSBzaXplLiAgVGhlIHJldHVybmVkDQo+ID4gKyAqIFBBTVQgc2l6ZSBpcyBhbHdheXMg
YWxpZ25lZCB1cCB0byA0SyBwYWdlIGJvdW5kYXJ5Lg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIHVu
c2lnbmVkIGxvbmcgdGRtcl9nZXRfcGFtdF9zeihzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLCBpbnQg
cGdzeiwNCj4gPiArCQkJCSAgICAgIHUxNiBwYW10X2VudHJ5X3NpemUpDQo+ID4gK3sNCj4gPiAr
CXVuc2lnbmVkIGxvbmcgcGFtdF9zeiwgbnJfcGFtdF9lbnRyaWVzOw0KPiA+ICsNCj4gPiArCXN3
aXRjaCAocGdzeikgew0KPiA+ICsJY2FzZSBURFhfUFNfNEs6DQo+ID4gKwkJbnJfcGFtdF9lbnRy
aWVzID0gdGRtci0+c2l6ZSA+PiBQQUdFX1NISUZUOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJY2Fz
ZSBURFhfUFNfMk06DQo+ID4gKwkJbnJfcGFtdF9lbnRyaWVzID0gdGRtci0+c2l6ZSA+PiBQTURf
U0hJRlQ7DQo+ID4gKwkJYnJlYWs7DQo+ID4gKwljYXNlIFREWF9QU18xRzoNCj4gPiArCQlucl9w
YW10X2VudHJpZXMgPSB0ZG1yLT5zaXplID4+IFBVRF9TSElGVDsNCj4gPiArCQlicmVhazsNCj4g
PiArCWRlZmF1bHQ6DQo+ID4gKwkJV0FSTl9PTl9PTkNFKDEpOw0KPiA+ICsJCXJldHVybiAwOw0K
PiA+ICsJfQ0KPiA+ICsNCj4gPiArCXBhbXRfc3ogPSBucl9wYW10X2VudHJpZXMgKiBwYW10X2Vu
dHJ5X3NpemU7DQo+ID4gKwkvKiBURFggcmVxdWlyZXMgUEFNVCBzaXplIG11c3QgYmUgNEsgYWxp
Z25lZCAqLw0KPiA+ICsJcGFtdF9zeiA9IEFMSUdOKHBhbXRfc3osIFBBR0VfU0laRSk7DQo+IA0K
PiBTaG91bGQgd2UgQUxJR05fVVAgZm9yIHNhZmUgPw0KDQpIaSBFZGRpZSwNCg0KQUxJR04oKSBh
bHJlYWR5IGRvZXMgYWxpZ24gdXAuDQoNCj4gDQo+ID4gKw0KPiA+ICsJcmV0dXJuIHBhbXRfc3o7
DQo+ID4gK30NCj4gPiArDQoNCg==
