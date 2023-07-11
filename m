Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C8374ED3A
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjGKLts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 07:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjGKLtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 07:49:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4918210E;
        Tue, 11 Jul 2023 04:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689076184; x=1720612184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6HVyhJBMfXX4koWQki0Ix8P/RD79hA8q4xMA1Jt4AwY=;
  b=U6alI2kaayqAqB7VJH2sLibdPfTWUXXpEOaVBWkDNuvogOroa0mtKH75
   qzXvZqEVO65GQuVBEx186xkYMXbSuwm70Lu3OMH5ljt4gJRCyG28ZjhrH
   LzmQZgdfct5MY+cVYMOOYVeXL+aOKOvHVAGjHlxNNAKwFBOrdYu5jKxZN
   KP9MQnxalQmuniha9GAuaiIIrfemsev0ekjTd1leyeZhRyQUXw6VID4dU
   dpPE0Zp1J0/tMUv+fHMM/Q3W9bcoinCsHlQ6JpT/X3aJP8QEG8xEyH5gv
   wvy46UI/N+0ZOc8XuJH71hpQQCCRouNSHzuYyt1KacMgYv5mMBAkIkwY0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="362060488"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="362060488"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 04:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="721070796"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="721070796"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 11 Jul 2023 04:49:43 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 11 Jul 2023 04:49:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 11 Jul 2023 04:49:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 11 Jul 2023 04:49:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXeVOKz0yd7SGZQsyYsEyX5DG44TyUvrGg/TGY6IOj+Qez77KCtOvT2vgil7kv9hpI+Cnp5Rf8wUEkKxB/hfO+06Q7F6PN9jGHIMDmPFmrsekLVzBFsKiFputLWdilriPq2Yv35DhPay8DmUbEhoZFqMTJKuNyYYZqod7iN73sRedyQUGshzK30wd2Ez1XT3i1T4PbnDVOcSqhBUvBQxp2/3CUY3sPSXcgGbxGHHcmQH4OmfW3TcrrU1HIwz8QwbVyhflsbQwHb5H7/7c+V23Pn4NIzI8GRPU2hlOII0uJLWV3H51IwEqWKpg85sxivH9mRaPsAhFTaRyNlPgE+Sqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HVyhJBMfXX4koWQki0Ix8P/RD79hA8q4xMA1Jt4AwY=;
 b=XvGL9oHwl6tAGQ1l1Vt+YmrdFxrCZnJIIdyknjTOZFxwPRTFKWGrbQZcA4bBtVwywGxhW9fGDxttY6uEbDfmI7eesHsU+yOXM4ILKQr/y2lWXGkufSXxB0yR9CY3ggEPiBzHiqVXQupjKrWLBY/nM10zUlQ/8F5jhSGyVv0mW74poO3akGWg6JB2q/n+ePTFtkqJ5BlcCA3QloqZXwwLYEOC6/fU6QmtUqWC096yJD+dwnRn/Er221QrYlXnnfufkQKfxHpUYPiRW+tpbYCsiTtk4GRB1taKzBrmoLDkRSaIhYemwMti+0wemUIuFWm+CF4J2rxHqlQIZnYL5BRuDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8497.namprd11.prod.outlook.com (2603:10b6:a03:57b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Tue, 11 Jul
 2023 11:49:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 11:49:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 12/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v12 12/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZqDW2SDcq1vhkU069JfN30XLipa+0iQgAgAACE4A=
Date:   Tue, 11 Jul 2023 11:49:38 +0000
Message-ID: <4fe54e141ec5040300d0e2552ea31b83aa947ec2.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <85ea233226ec7a05e8c5627a499e97ea4cbd6950.1687784645.git.kai.huang@intel.com>
         <68a8cba5-55b6-4c8a-f4e6-d528fc839285@redhat.com>
In-Reply-To: <68a8cba5-55b6-4c8a-f4e6-d528fc839285@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8497:EE_
x-ms-office365-filtering-correlation-id: f98684d1-557b-4d86-a405-08db8204e7df
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jf93nEAAIBhFjacMj2T9Vn1tCTHtIHrnQNH2RY74uvGUGT5ge3BIkYOgTv4QqvCZFflhKMWu7f7C+LSNqOwlRMxfz82kzqG+eNtmPjjq1uQdW1tCs9uBm4LOHsK0YfZfpPM0PW2zBPMZZb7YPCUa2PjZx49rTzh2UR3sonXBFK/XV3JlsgTou84dnv6L3Iy9StHBKdtsE1gE82H44VUL3ozxJeBhfj094xDg3FJhjHi+2P1pOQjFq+RonUl+9D+DDav/4kN1boCJ/vyQpr8WPUl6KeMeiOD89HjU9Ju0tHNc1mnd5tt6/JxtBS2Atw9zg83bTfN0X1S6fS1UTngEAyKEU35rCPKFjD6XECeshKVvC17eUeYWeakRnhQye4eWFzJcFvVCP9wUXdKpKSuFY70d3nMXkxCYsTlKjxmuTG65gPl5Fq2Eh3aWupbPF1bTHy+eBeU6ZLvfa183VA7E0XTkJOUVlQ66pvXfJJR+lp39oVwmSnRpT7GjqrFCQ4nDjB9dIsdQ/CGjr6GJsscRZXrpnuSECibu8GUMy4z/DnpEhEVWmwhq+d041R5NRaF1gwi0eL86Ty/bzEFJU/6jjcDgPar/ek19xHEa4KY5nwI6O9U4LNtbEGCrQQTuODGL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(38100700002)(86362001)(82960400001)(38070700005)(36756003)(76116006)(110136005)(6486002)(54906003)(71200400001)(91956017)(122000001)(26005)(6506007)(186003)(6512007)(966005)(2616005)(478600001)(7416002)(316002)(66556008)(5660300002)(2906002)(66946007)(66476007)(8936002)(8676002)(64756008)(66446008)(83380400001)(4326008)(4744005)(41300700001)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djZZZlNQVjJyaHBWbkp6RVJjbjR0Kzl0L280S0JXbGFQZ2dIbkY2cGwwc01Z?=
 =?utf-8?B?ejZzSC83WndDbmtybFBYMmxCZU1VS2l6Rm45cVIwY0tGem1GUUYyZGUyOUd3?=
 =?utf-8?B?YkRwRkRmWWxFTHI5Qi9QY2EvWlRtb0dNeitSbmZtYnhJMmtmdW9EZnpGWHNJ?=
 =?utf-8?B?SDBpRlJhZHN2d2dBL0QxTllMb2tkaCt5YVcvK3YzN0xGUy91bVA2Q1ViUzJX?=
 =?utf-8?B?VmFTTkpsR1VTSmxMdjcrdmNRNkFRbW5QV09sN1pla1lMM0Q3TTdWZ3JIWlZm?=
 =?utf-8?B?T2t2R29JaEtPRmp6UTF1OVdoeSthNXRwdGdnV0wrUklraFlsREN2bjF0T2RQ?=
 =?utf-8?B?VW4zSzByY1ZEUDZRZ2d4b2tIa2hnRHB3WDVDa2h1WVJIVm5GcnYrZzhJenhp?=
 =?utf-8?B?MTF5UytjdUZKditDYy8yWEd6M1RDRFJGNHNKcWtBQ1Rrby9QWEErNDNPVnhn?=
 =?utf-8?B?cmVCVXNEdnFLcURMMjd5VWxpcjVqVVcxTC9ZamRRWGZ5UkZ5TjIxaTlnNE8w?=
 =?utf-8?B?VEExaC9nMmIxdjVaYTljNXNGUjhhRHJkL2NlQ0JuU1BiYVhkVlNJbVpYOUpK?=
 =?utf-8?B?SmtYSjVOQjVmMTNPQjJ6cWQ3bVFrVXNlWmZEWWRXdTBHUDFoQSsrK0xxUlM1?=
 =?utf-8?B?ZGt4dkVjaExVZ3QzdlNIeVQvd0xJNjg5cWNuSFA1R2IwMlc0eFA2MFo3QWVC?=
 =?utf-8?B?clFQRjNnTEJiM3lnOGEvc1FhMyttY3krdE5ESHBQSTVCazc1YmtoQThvRmJE?=
 =?utf-8?B?bGJGbDJWdW1laHdiR0tWSXZkSkJCN1F4SDRLMlQ4eld0eW1TUXkzTmNGM051?=
 =?utf-8?B?MFBSSjBSQjhtVWJoZTB6UHBTZlR3ZTMwRUdsQlFnSVFBSERmWS9tNGVpM0Qy?=
 =?utf-8?B?WWtBU2dQYlJrZXNHL2ZWTXRCN3E0dUhVQTdJTzJndFB2Yng0UTNrSm9Tazlo?=
 =?utf-8?B?QmpjT1FSN0Qvc2tuUk5SQzM2a1pJemNXSVE0elg5U0JsSWtmdnRnM2JXM3B5?=
 =?utf-8?B?RnRwRzdHNVBiVXVYT3RrdTI2eWdLaU84cGd3blQ1YW1GNExaVVdISitOYld0?=
 =?utf-8?B?RnZETTdWL0NTeGFRb1BqMU90eCtYVXJIWkI1RE04SUZNMkNpUFowbHlZUmJN?=
 =?utf-8?B?NDE0WFU0UElHZXpwaFhRZVF1SHdVMHJpMUkzMm9ORG1jZGk0b20vZ1Z1UVhG?=
 =?utf-8?B?alNsT1dnbkd6RUpvRFRpZnB5OVNWTTVWR3gxTVJ2cE5wYnJtbE1BQlUzZ2xU?=
 =?utf-8?B?TTI2WmdOV0swK3czejQweU54a1V1bzhUWEJlMU1uVXdZNnMrcE9FNDIxVmlp?=
 =?utf-8?B?a1oyd0gvUkpkZGRUem00VGlwcHA5Z1J5T3VZeC9wUkZ1NkM2Z3RPVm5FTVVj?=
 =?utf-8?B?RFpXTUN2L1JnS2hPVkZLZHFTc0lCYkkveFZyRi9XTkVFZEZTdmdMUTk4UUls?=
 =?utf-8?B?bEVkcEY3NEFlYUZnb2FMSk0rSlc4S2FmQks0TjZNbkgydW03dWVzM1pEWEJV?=
 =?utf-8?B?Qkh6aFVDditoeGRlZlduMDZ4Q0FKS1ErQUZjSzlLSHA0RXZ6ZVVWejJIckE5?=
 =?utf-8?B?UE9ZM1RUTmYyc1RCMHR3QTNVcmNxeVFML1QzUUtobHBPMVEzNHVXZ0trSENy?=
 =?utf-8?B?bmIrMlRVRWRhRDVUOTA3TWN1dzlGc2hvNTJMVFdZWDNjWGFaRFdjdGxrbmpB?=
 =?utf-8?B?eS82Mm8xeVhEMTZEOWV6QlB5dE5zUjhneWxieE56ZlV4dS90TWZnYTlxQWVW?=
 =?utf-8?B?NlZzTkp1WFNRUEFabmFBZ1laNDBZYmc1RVJvbldwSm9ST1JvWEJsMG4vSi9T?=
 =?utf-8?B?WlVYOW9hUVpvVG1iNTZsNzRhVjM4VzZrS1Nmb2Z4L05pWGdmbG0xVWVlQ2dp?=
 =?utf-8?B?bGZIc2pBVCt5M1ozNUNVemZUM1JRZm9lUEp5UDRkcUhIdmtWSVdLbVo2cUJh?=
 =?utf-8?B?VzRkZGhWMkFlUUdqSlV2ajI5WVNsOWFqRWxIVHdYakF6T3Y0MWdwaGR5Y3E5?=
 =?utf-8?B?MUtRQ0tSUTk2bldGY0QwdGRmY3ZSekVIdFp3Uy9ZWXJOZ1JieVp2cHJyc3Ez?=
 =?utf-8?B?YUUweFlFUEhNRnNTMGRGL0VvWEI3NHZadmtUWHE0T0c1ayttYklvT05QNUZw?=
 =?utf-8?Q?O4SSiYuImKuhbW/t5UxLfpxaV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A08481314DA3D4D919F30F7C85096ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f98684d1-557b-4d86-a405-08db8204e7df
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2023 11:49:38.4161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v3A7yAcoHuRGZ4yVWa7wl7uHep8Y9DRHa3rGHKEiCh53yTpMqVXeiHf5p4PSBJYmcgSrwixxWVbFyhwCQEiPow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8497
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA3LTExIGF0IDEzOjQyICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gPiAtCQlyZXQgPSBhZGRfdGR4X21lbWJsb2NrKHRtYl9saXN0LCBzdGFydF9wZm4sIGVu
ZF9wZm4pOw0KPiA+ICsJCXJldCA9IGFkZF90ZHhfbWVtYmxvY2sodG1iX2xpc3QsIHN0YXJ0X3Bm
biwgZW5kX3BmbiwgbmlkKTsNCj4gPiDCoMKgwqAJCWlmIChyZXQpDQo+ID4gwqDCoMKgCQkJZ290
byBlcnI7DQo+IA0KPiBXaHkgZGlkIHlvdSBkZWNpZGUgdG8gZGVmZXIgcmVtZW1iZXJpbmcgdGhl
IG5pZCBhcyB3ZWxsPyBJJ2QganVzdCBtb3ZlIA0KPiB0aGF0IHBhcnQgdG8gdGhlIHBhdGNoIHRo
YXQgYWRkcyBhZGRfdGR4X21lbWJsb2NrKCkuDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0K
VGhlIEBuaWQgaXMgdXNlZCB0byB0cnkgdG8gYWxsb2NhdGUgdGhlIFBBTVQgZnJvbSBsb2NhbCBu
b2RlLiAgSXQgb25seSBnZXRzIHVzZWQNCmluIHRoaXMgcGF0Y2guICBPcmlnaW5hbGx5IChpbiB2
NykgSSBoYWQgaXQgaW4gcGF0Y2ggMDkgYnV0IERhdmUgc3VnZ2VzdGVkIHRvDQptb3ZlIHRvIHRo
aXMgcGF0Y2ggKHNlZSB0aGUgZmlyc3QgY29tbWVudCBpbiBiZWxvdyBsaW5rKToNCg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC84ZTY4MDNmNS1iZWM2LTg0M2QtZjNjNC03NTAwNmZmZDBk
MmZAaW50ZWwuY29tLw0K
