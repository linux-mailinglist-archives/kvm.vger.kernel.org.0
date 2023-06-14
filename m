Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A764672F94F
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 11:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbjFNJe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 05:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjFNJeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 05:34:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FED193;
        Wed, 14 Jun 2023 02:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686735263; x=1718271263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0P8nd1c8q8KaDWGWvTJfk8d/ojOjXdqa8Z39h/Bqt1s=;
  b=isutyiq+1O97ZQOt2C5PZauZaU9PGYiFlRtjFC4N8WxsOuuwIT/fFF8O
   OY67SEQHXAwC6eyXXKJ/cCjQ6apqxsbvPTNd6BVrbyI+wGX82eky4JWaM
   dwV66OxOJUQE4uwqiWpNlr8uiEUtFvL0XZNuTO7DKD7wUaj5U330YwD6z
   GYqj1/qoy1W8VPXZCbCnIS02+kKsV2FLgzkx5gYWn1uA/1qxUO9oGxM26
   xwIO8iKzxvVPYh9iXYMTn5da4OpXyBkZydTfFLrgf6q3HZ9uWoE9d9ZFh
   UOgdvUM0RgKyrJoAI7l11G5t3+JL6zbQPjfsXD9KfqOnp+gdSQJIc30oD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357447221"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="357447221"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:34:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706156685"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="706156685"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2023 02:33:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 02:33:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 02:33:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 02:33:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCsMqjqUwrctGc7fVVZKMZUTkyj+lGkS1Hgq56dBtRylrV6OTLRegWrtwb/QcAgDGEbQmNd8LFuqeVwPcnqJeFOYx3unv/96B84ALhMeKmsx0A3Ya5ZlM3lIYHMTHRLv7MPDHlNGcL9O+ILfTt5aHGaXWiE0yoyq6A/AtZhiorcdrU7Yt9KmyMfPeViHeEom8ATFJzsnZs42NYDfy/YZzIju6eys2xLJXoMUEug0sZNkvtFoVyUHTjYFTGgltRKpsGE35pZJiDNwBfjjyUg0Ey0kG3BWKVR5jpIQY+xWgrm+vpJnK6nsEG3ZsxAMEumK69aAjLT7E+2PpIaq4BbX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0P8nd1c8q8KaDWGWvTJfk8d/ojOjXdqa8Z39h/Bqt1s=;
 b=Jlo+8I57zVHxm5bnVLYs5iDajeeCbcKCofvduO3NsfE+Y+w1RytyPNLpzZLyAY3chumUw4WJXdvI+aowV20t6owAdOKeKZcp2B0VP2RcmPc+f6a3Knh9QAIxxKR/YCtjWGVBwgXVQbSP1cvxYcGoHXewgcm6MlfGgBVqBdVqDz9NpG24OH22Y9AK4D1UaLjzUQtQiyjdD6i3V6laVvSsOaS0BFSgCxTXivgAJw2vE+oGcrru+TBeTwAA2ZC8XAayGPa1+Ab9DCDlqhxLyK5NkN8TT8+XmSJAM/KpP5iw78t6NX8nm6Zva47E8Tk/7mJUqau0o6OwbrXzZVsp4qlhkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 09:33:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Wed, 14 Jun 2023
 09:33:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+KGL6A
Date:   Wed, 14 Jun 2023 09:33:45 +0000
Message-ID: <d3df3a9fa3075066558dd3bc84ef76ab3747185b.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
In-Reply-To: <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5911:EE_
x-ms-office365-filtering-correlation-id: a8135f46-e67a-4b2e-f470-08db6cba7347
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+YN1aizOSw7w/l9XjON5Tq/T32cfshT5MHih8vnm8v14vqem6Qb/Cacvrf1rl7XdGS4hfIemwANzFC0ia46PLLjCBZRGreJ3ef52lqnpNyHbm71ETpY8J/BNx14F8umtva3BhB5GkzxAQl6iRQxjua5Z3vuSAh+H3m9S4ywUEil7AVNnjKf2niaZq5m1n80AR8GEiuskKZd0+ACPJMjuDUYcxqOEHNIETYFF0ozfhzD0n7m7KNUfrsAd/+Ppu9Us7hMBgLSLnjtnb9P+wrRtU2y2KJX15Jq90ofvSbBDkCK49Ax9zPMyGTYcnnjFCcPTIOZZAnOfHfdXXbEz92uGUf++XkRv3RGNkyFPELhFD24TDaxAvqXIFuzkFBhqykLiz6ek37FFBTE3yKfs1zIibY+/V/1SPc0alCtWMp9szfIHIMSgcLFCZ4bbcedFew65LcpQhF9+/uRKUwHdu0Npy+YnOluw5+zcpAhJ2XZTG6EQQvMflcupUBbYDl5hKtr2OJykpQoOqclzE3o/k2CM6ktaf/DoR76R6e9EFaaJPnhNF2lMPlL3qFbUfymh/AxsIPLr/rBnbkx9FcJQUjxHEjE3pyhJngiEue/ICf+6ICCY0KGGIgrZjzEocEJuKeF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(5660300002)(186003)(6506007)(2906002)(4744005)(2616005)(7416002)(41300700001)(6512007)(8936002)(26005)(8676002)(6486002)(316002)(38070700005)(110136005)(54906003)(122000001)(82960400001)(36756003)(478600001)(38100700002)(4326008)(76116006)(86362001)(66556008)(64756008)(66446008)(66946007)(66476007)(91956017)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkRRRmVkV0NiNU5HemZNRW9LREdZcXFWVU5hb3kxZ2hENjlYMnRMT3kxaERQ?=
 =?utf-8?B?a3h1dHNTVUNqdGQ1TWtHSDFZUjd0WUE5SVlpKzhwcUVkWkVDMHBINUE0bjJu?=
 =?utf-8?B?d3JjbVdrTjRYcjR4cTFkYXp5UXNnSWkxajVBalB4L3JOZnl0ZjRPSWVHVCtE?=
 =?utf-8?B?ek91bWZsU2drRUl4MnBsQmpsY3ZYVjBpZWk2eXdlYXNwR2VESmQrVTVTRy9n?=
 =?utf-8?B?cjRZZzdxTUF6THdLMWdka2Y3WHNrMGd0by9NcEVYaEsrUjE0blFJTjNNamxM?=
 =?utf-8?B?eitldUVwb0g3K2E1WXFFZVJQYUlQSVZKSTd4dWk3ZG9zNnJXOGw0Ui9LNlNN?=
 =?utf-8?B?TjhUU1NQcWZycTlkWis5VHNLMW8vaVBEcmptSkU4czdZc3NKRUNqenc3NGUw?=
 =?utf-8?B?S2Jab25NNTByYjhWcWFWL3NiRW5OSGw4NytxQko2R3dJQVRDNGhCS3FhMUlH?=
 =?utf-8?B?c2k1eTYvUithZldKcGZvT1NSd1NOUGdjUGRGZThQRUJyTjRSa0x6VEZGeUdv?=
 =?utf-8?B?NEk1RjR2N1dacFQrNUwxT1BKQU1lWmVjWnM1a2RJUEpYWGlJMElKR09JK3BI?=
 =?utf-8?B?TXVoMmRrSzlmc3VUL1ZIYnZoQjdXYzhOakxicnpLK1Z5UkIrZkZHQXdmSWFH?=
 =?utf-8?B?RFVZYm02SVJwazRNMmg4RmpSbGhmeDVVbEt3VE5xeU91VHRxQUhzUWZjdENE?=
 =?utf-8?B?c1hZYUFoRzFnanhBdkgraHlGT1Z3Y1JiOG94VjJ6by9BVGlTTzJNZEN3dWN5?=
 =?utf-8?B?NEJYUVFPOSs4TDg4N0Rxd2Iyb0dNS0Z1ZDNmNGR3a0x4VFJkZjRrVzQyWTdn?=
 =?utf-8?B?d25oODlzWTdsVmVMR0ZoQU5HZWtCWi9UL3RPZElubWNTeDZLK3R6Q3hNOEoz?=
 =?utf-8?B?ZG1pR1JaMFlFR204aFdRQnR3V285UG5YcVpLSkVJNWFMeU14VDNwOGJtaFhW?=
 =?utf-8?B?MEhGeWRPdmFsMG1tU1NuR2FxcDZHeVQzRkVkdHJXRFArU082WlphemZpR1ht?=
 =?utf-8?B?Rm1vSzB2NjFWOFJqVzU4NTh0c3AzZnJRREVTS2h4RWFCdXNCNVd1ZHU2K1JL?=
 =?utf-8?B?aFViYnpCOWlPb1VSNHE3T3ZQbTJtNDZVYXRRelpjdzZOczA3WisvZWc2OWJW?=
 =?utf-8?B?YzZQL29FRTVpcCtPWTNJeXJmdGZVdlBLYlhBTU91d1g4V3ZUYVRTWkxwRjRZ?=
 =?utf-8?B?VmNzTHQrbmpvaER3NDRZTDFKdHRBc253Mkl3SG0yRHlLMGdHSUdhQW5qelln?=
 =?utf-8?B?NGhTSFQ1MzBJODZCN0tRdEZiQS9rdFhzU3JnY2dLanR5KzNjNXIxYVc2Tlkz?=
 =?utf-8?B?RmcwdEQ1NGx3OG1adnJWTUxQVDFZTFZJdURjeklBYWtHVzlFMHJKNzRqdWRG?=
 =?utf-8?B?Skl0aXF4cGNpQmNnOEM1eEJxUE00emhTNUpWc2Nhd2lhWllYUGVHYVF2bVRK?=
 =?utf-8?B?b1J0dCsvUU82S2xDNGM1VkRuTWJjOGs4UEFER2RnVHB4T3ZuQS85S2NQWjN4?=
 =?utf-8?B?c2JPSmhuMjNwelZ3cER1ZWRQc0xkcmRFelpuNk9pRXB6NndMWmVBWUx0K3hD?=
 =?utf-8?B?bVpYdHhNMlNQM1B1ZVlzemxUMmJIYkQ5dllVVUJVeW90cEhEYXo3QVcwdzRT?=
 =?utf-8?B?WncvOG4rbXRpUnBWNmRvTHhXL3ZKNjZZZHc4a1RjU3orQmxzK2tjMFJWY1lM?=
 =?utf-8?B?aThkMG5jT2MyMFBSd1lQTDNQRVpJU012THo3WFhiQk1nVUxBZFRMK0kvNUhm?=
 =?utf-8?B?SGFFYVV4elZzYi9TZnJia3JPNFRZakdsZktVcTVJM1l6QVRZYUljOGN0a1VX?=
 =?utf-8?B?UkczN1JqLzBrVEdjdUZLeVhSR29SWkhDK1cvUVJTT282KzVtVGQ3QmlTRmNi?=
 =?utf-8?B?NktvRGhmTEhNbU56OXV0UjBoREVRWE1JNFpQZVMvNkRZSWJ2dDFvNEVUNXBK?=
 =?utf-8?B?aUtQQTlSeXpocjA1ejU2SlMveHArbjFqY1ZEUnYrRkU3ZE8zN2F2MHh2UzMr?=
 =?utf-8?B?cE9mVURTS1ZJWUdHQXdIbVRFSUowd1liRitiNk96T2YwTFA3aVpDVS9MNlRS?=
 =?utf-8?B?b0pneVA4Y0FiTHE5T1ZORHJJdUlZeG1DLytXOFl2U25PbHhHOWxwWTBzRWZP?=
 =?utf-8?Q?mtke6ur/QmDKW19JPcYRIoHS/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DC9613AED04C04A950C7C1167B05195@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8135f46-e67a-4b2e-f470-08db6cba7347
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 09:33:45.6449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tQsYDuAaYMScvsl/HHBCFnjWfXxIHvSPl9QQl9WHiwVA6z5u4RU5U/7Coh6vfmndEo49rkDqaT7YpHd6TS7UhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
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

T24gTW9uLCAyMDIzLTA2LTA1IGF0IDAyOjI3ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IC0t
LSBhL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvcmVi
b290LmMNCj4gQEAgLTcyMCw2ICs3MjAsNyBAQCB2b2lkIG5hdGl2ZV9tYWNoaW5lX3NodXRkb3du
KHZvaWQpDQo+IMKgDQo+IMKgI2lmZGVmIENPTkZJR19YODZfNjQNCj4gwqAJeDg2X3BsYXRmb3Jt
LmlvbW11X3NodXRkb3duKCk7DQo+ICsJeDg2X3BsYXRmb3JtLm1lbW9yeV9zaHV0ZG93bigpOw0K
PiDCoCNlbmRpZg0KPiDCoH0NCg0KSGkgS2lyaWxsL0RhdmUsDQoNCkkgbWlzc2VkIHRoYXQgdGhp
cyBzb2x1dGlvbiBkb2Vzbid0IHJlc2V0IFREWCBwcml2YXRlIGZvciBlbWVyZ2VuY3kgcmVzdGFy
dCBvcg0Kd2hlbiByZWJvb3RfZm9yY2UgaXMgc2V0LCBiZWNhdXNlIG1hY2hpbmVfc2h1dGRvd24o
KSBpc24ndCBjYWxsZWQgZm9yIHRoZW0uDQoNCklzIGl0IGFjY2VwdGFibGU/ICBPciBzaG91bGQg
d2UgaGFuZGxlIHRoZW0gdG9vPw0K
