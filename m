Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127886D4369
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjDCLZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 07:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjDCLYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 07:24:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0312D4A
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 04:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680521094; x=1712057094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gBqglNk+z4IuQfoMw0NdJbQ8qJJmH9IQI3f17fi1n3o=;
  b=ar4LXTTNZXbD/Ff2Xd1xjABTAqrpcEkT9Zb9rDtKRjxUww7dZmhc+PLk
   +dSsOGKguqMGNIqoSum8wGzAwx0rllfWhYNinsysWjKZUHB/KAkATgfiU
   lWNB1t8mOL4kRUXEn8JQVlnUGqVWg32CENcwF4cIJH1GktVBmwkaVuaEq
   Fc/7DYqIccpkbTk593pvnaJBjAxNCKlscMqdNsiBk8nPVz67YcwKHh0OH
   R4rJBXjPC2tTElS0Q155l2dvtQ4IsGJQboDpnPgYbwLHAM+BGQrgKQzab
   8A/aC/sxe9vwsi7koSVa707sX8/uaMVasC2G3pJAB2RpvPeLeL6vdLoM/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="322266163"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="322266163"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 04:24:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="718517905"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="718517905"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 03 Apr 2023 04:24:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 04:24:53 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 04:24:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 04:24:53 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 04:24:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JoO0eI2BJfEjqw6wPsfCr54kop/agxWzKfCp2imhLTIQwR7/gAE47nu8DoT+Eb6ZihTV07akGDCSMwJmZV6JPJMkr0bEpAV1Uz5IbAeN43V6rjGN4qUPby7h7cLtXFX3MitytGd/tuWgDahWapxRq4IM21iX2NVpA9hXhWBSQT2rlYC7SctivpScKcxJp7bqudhMeh2yVsSeuGMmkXWMFc3+9MCemC5TuDcH/A9HYAtrTvW/sbb9fcR85zJSBI20r0rCSwp7VURDbLldGcEe+iynVO3vOvproxsokJitynwZPwqNcBU3/zr/MGg1r79fTybm5TKwuE6FtdOrbYKkvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBqglNk+z4IuQfoMw0NdJbQ8qJJmH9IQI3f17fi1n3o=;
 b=lpUxuUeXOWO+/tjRg85a8dnWXn+UlPqwvF5mLc3zndqDeDHwa1a4UDbKikV4fi61jHzcjBUEP0tc0IVfZhonA+jPh+eFS8Fbht1icO26WL9EwdK9xhTHygfPZSoW1b1kY2R7PVEWaEcxsY3UJfSardceg5xOd7nJrM7loAaJDEX+6JhkcnMrJ2Flq0e0CJKXE1max69ysP/bE27vl65y/abags3TPNhfFhdtdXy5smDRNXGpnc8dEtICpyp97jrDVQRtsD2T6oEm9G8xZLGWcpKqsccBqhkti4xBtMNg14PFy6aG+yk7Zmamt4DNOpKjpaNSl44/nT0M/mkdiRQw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5210.namprd11.prod.outlook.com (2603:10b6:806:fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 11:24:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 11:24:51 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8DnNOAgAIo0ACACyFUgIAAH6+AgAAKWgCAAAFNgIABArSAgABXIQCABpqMAIAAgp4A
Date:   Mon, 3 Apr 2023 11:24:51 +0000
Message-ID: <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
         <20230319084927.29607-3-binbin.wu@linux.intel.com>
         <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
         <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
         <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
         <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
         <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
         <ZCR2PBx/4lj9X0vD@google.com>
         <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
         <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
In-Reply-To: <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5210:EE_
x-ms-office365-filtering-correlation-id: d1a42f6e-b54c-40f7-a06b-08db34360a7a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ok8yztUq5gbtKFuzjA0Cdnz62jdYWZs0vx6lWIxH79BDhqHy3BsSvwG5VY6KzBJD00rvOQ+TVaJ22Al4YbYMJsPE0LoAFAYdGxRX3SO9GQE1kDTHZ5D7S+at/Ua+qIAz4/7I1Nmb2dBLbjMZXerLeLy3llyyQmUHqBIOYPgkJpDGho8qCPjZ7XSibIswaPkRi0P8EEqd8+p8f7j/qvC7ffJQ0gUjQ9Z+yYokXwJQvf5IL+boyLinkI02bzIVGriRL2BES4Syc6hlYm9xL6zgB4iwQi+tjwwgj4VrILCX4DcY63bEom3YIlGA0OHld2bPv6cSdjcNc5RNaol2WapUq8XbFk2bvrZ5qtZ/H+LYe7XnqcFEba/kl7096eqg49JAL4x3UWJlOC2sRDrPRbPSOd8rJa5h4b107QRDKyzSG0WeTdvqU/FvmO+d4mkbjzoiCgFKq/ARwLiLRzGKuN51bB+YxSdk8N8yRuBdcBs4rWqb0qgKdZKDQiOdFBQaAkQi6dMI8/DU7UT8Tw5z2xdUt/1CT2Oae8yVyj/u/H4eScxCcTj7dk9a16kJVxUIoGcrqjXvo415pyY8Ez3UYwGKyJh71csEkOyToCO2lWXWiA+ffYvFTrV8Y/7V3CnG0X1s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199021)(86362001)(38070700005)(36756003)(2906002)(2616005)(6486002)(71200400001)(186003)(6512007)(6506007)(26005)(4326008)(91956017)(478600001)(76116006)(8676002)(66946007)(66476007)(66446008)(66556008)(64756008)(41300700001)(122000001)(82960400001)(5660300002)(38100700002)(110136005)(316002)(54906003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkszSWhuVFZMeG9vZmE0cE1jdXAwMTRDT0ZFN1pucGE4MWRPaEdIOVExZk5p?=
 =?utf-8?B?T2FpaW9MOXRUbHR4NXBnK2xidUQ3RWhFbTNkNmU4Y1JVWXZaZnlaSTlXZVVu?=
 =?utf-8?B?SnZCRnVGK1dRWWdQRG1tYXJxQ0p3VERsMCt2Z3hTYkR5SkNaMTR3SitVd3cx?=
 =?utf-8?B?Yno3dUVjQ0QvM0ZObFVjQmtpRDU2TUVNNTNaMnlrQkN6V2RobDg2NGIxMzZJ?=
 =?utf-8?B?OEhXY2R3V3Z5WEFPUjdXa0d2SGZYSEZUOXVaelVvRlh1MlJSa3Q2TENoQjBW?=
 =?utf-8?B?OVlEY29VTVUyVjBWNGNCeU5BbFoxd3lib0ZlMFYybmNYSHZ1T2prWEwyQU9I?=
 =?utf-8?B?WGsycFVYa1BJMDkySVNVYWt6V3ZpU3VHT1N6MDNDYlBnbDVOMVkwSXJkR3pU?=
 =?utf-8?B?Skc0RTdjaTZVdVlWdGZ5YVJkMk9Ec3NHM1R0ZUNYbjF5NWFkcVMyZkp0eTUw?=
 =?utf-8?B?dVdDZ3o4clM0QTE3dG0zR0FOMkxiZ1hQS2gyRVZoa0ZxamlGRnZidFl3L3Rs?=
 =?utf-8?B?UlMrSFAwRitOT3l5ZHIyN3NVcm9CQlJ5RUpTcTRpTWt5eDh4R2NETjhzdHVo?=
 =?utf-8?B?VWZyR2F5NHB6d0VkdFB4TE4vNnVrUkdNa0x0WHdueU1WVEdUeGdJaWdNaDg2?=
 =?utf-8?B?a2tNajRDRm9iYkh2QXJPekNONkI5eWQ3Q1BMUGxGb1dEVWI4UzRTNXh4RWJr?=
 =?utf-8?B?RG1nNkEveVh2dWpnV3MxNmo0MS83c28zZlN5Z21sUERjUUpuWEJwZlhRODBq?=
 =?utf-8?B?MUhMRWVDTzd2WTN6MUlQNEo1WERzNWp4MTNkMWlPQzVXeG5Gd0VnWGVhOTJI?=
 =?utf-8?B?eENUYnlBUXQyM3RzTkZEWURXcDhlSkF2bmZKUTdHWmdjVFo1MUpUd2hlbkM2?=
 =?utf-8?B?N3FhOFNQL2x1WCthRllpbUt6RXZpVXlnSFFlNG5POUVjaFgvcitkeFZva3hk?=
 =?utf-8?B?aFVkYUt5d0xEWWNqSmRpUkZiZHpibXcxYXllVm9lMjRaMGQzWjZxMzkva3lS?=
 =?utf-8?B?ckk4MXUzRjdqNlNjcFoyUFMwUkowaXcvZWoyMEtzZzc4dEJibjZoUUk4N00v?=
 =?utf-8?B?OUVnMkFSNis5bnlWYlJyRWJFYmFwMGxiblFsM1dzODM2NkVOdzRmRnhnc0Jx?=
 =?utf-8?B?RmEzckgydjU2MzFCWmJiL1pTRC9vS2hxRmdsSVpQR0poQXZEYzhUZDJhRm5X?=
 =?utf-8?B?eTcvRDh3RkM5UEdicGIxQndaOENYS3doeWJlQ21zT0M3WjNhNFp2REVBNDBK?=
 =?utf-8?B?TDJiUXl0T2JyVTBWeVlaakRsL1NBTHdMVzNxNmUzN3BKVHdkM3dMUFBudTZK?=
 =?utf-8?B?bTdyWUN3dkt0elJTbXI0MllyQUNaZGRmR1g5SHpYL0M2UFZxcnlOcHAzbkxJ?=
 =?utf-8?B?bjJOSXRscEE5MGFlRXFwQmpibGJ1Z1VJSkFlRmVPUmMvQ0RlRkpwV01FMWNY?=
 =?utf-8?B?MDhkZ1RjbGNuclJJZUFiRHgwYkNWcjRKcndyaW1HZmQ2bHN3UjVKNjFjT0h6?=
 =?utf-8?B?d0ZkQlJDWW9mdnhJRjUySXhiUXpUQWxhbjNLcnFYa3c2Z002NzBBNjFFYXhC?=
 =?utf-8?B?RXNzSlN5SFRYcVcrYk1ZWHJlaVhkcmVCMmVlcHFFT3lzZk9oU1JHc3JXbmtR?=
 =?utf-8?B?QXhoelFQcklxaGp1UkhmTW13QWFEeTVZNXhPbVhRRkt2ODdVWGhQYkN2UDVI?=
 =?utf-8?B?eFJ0N1VocjQ0N25KZWJrUStFMkpxbFI2c21EYTlPUzRQYmJQNE1ERG9McVVw?=
 =?utf-8?B?N0pseWVvdmlDMlZTaUg3UmMrUmJPZGVQM1dmL2VtMDdKWVI0blJQWlRNbkM3?=
 =?utf-8?B?VlljMkwzekIwZkJ4Vm1WSkZORDJUYmc1UFZGMmJmSGNFYU5UY0t3SmxEaDdu?=
 =?utf-8?B?a0M2Ri9VWitld0NXV0grNGVFdzRwRnRQV3pLQVY5TEdTUEJ5QUFWOGFCSi81?=
 =?utf-8?B?REpHZkxwOExHQkF0QlZLMm5yMmFuR0FsQ0tZQ1A2eUE4Snc0NTVGdXVqanNJ?=
 =?utf-8?B?RytqZmpwOWpyUmpCUXptazdmOGJ1bEFaYmlENlIvMzgrakY1OTNkckcrbXYw?=
 =?utf-8?B?R3N5amxzVTc3NGVFb2xOTzVoRWlQV2UxOHNMT0dyNUsxWXNHQkJ5OGNSNTBk?=
 =?utf-8?Q?UFDb5nROLrkMjfk48icdWUi0r?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90255E212BC41F47A633C033BC58C477@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a42f6e-b54c-40f7-a06b-08db34360a7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 11:24:51.1698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DgSCWIbDKo3HM42cNA07EE1JSPhAAZlKEMTyxBtVjqgdHRbvKYHJOuGF54xAeczgtPW7o8NtRC3opXcllJoL+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5210
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IA0KPiBJIGNoZWNrZWQgdGhlIGNvZGUgYWdhaW4gYW5kIGZpbmQgdGhlIGNvbW1lbnQgb2Yg
DQo+IG5lc3RlZF92bXhfY2hlY2tfcGVybWlzc2lvbigpLg0KPiANCj4gIi8qDQo+ICDCoCogSW50
ZWwncyBWTVggSW5zdHJ1Y3Rpb24gUmVmZXJlbmNlIHNwZWNpZmllcyBhIGNvbW1vbiBzZXQgb2Yg
DQo+IHByZXJlcXVpc2l0ZXMNCj4gIMKgKiBmb3IgcnVubmluZyBWTVggaW5zdHJ1Y3Rpb25zIChl
eGNlcHQgVk1YT04sIHdob3NlIHByZXJlcXVpc2l0ZXMgYXJlDQo+ICDCoCogc2xpZ2h0bHkgZGlm
ZmVyZW50KS4gSXQgYWxzbyBzcGVjaWZpZXMgd2hhdCBleGNlcHRpb24gdG8gaW5qZWN0IA0KPiBv
dGhlcndpc2UuDQo+ICDCoCogTm90ZSB0aGF0IG1hbnkgb2YgdGhlc2UgZXhjZXB0aW9ucyBoYXZl
IHByaW9yaXR5IG92ZXIgVk0gZXhpdHMsIHNvIHRoZXkNCj4gIMKgKiBkb24ndCBoYXZlIHRvIGJl
IGNoZWNrZWQgYWdhaW4gaGVyZS4NCj4gIMKgKi8iDQo+IA0KPiBJIHRoaW5rIHRoZSBOb3RlIHBh
cnQgaW4gdGhlIGNvbW1lbnQgaGFzIHRyaWVkIHRvIGNhbGxvdXQgd2h5IHRoZSBjaGVjayANCj4g
Zm9yIGNvbXBhdGliaWxpdHkgbW9kZSBpcyB1bm5lY2Vzc2FyeS4NCj4gDQo+IEJ1dCBJIGhhdmUg
YSBxdWVzdGlvbiBoZXJlLCBuZXN0ZWRfdm14X2NoZWNrX3Blcm1pc3Npb24oKSBjaGVja3MgdGhh
dCANCj4gdGhlIHZjcHUgaXMgdm14b24sDQo+IG90aGVyd2lzZSBpdCB3aWxsIGluamVjdCBhICNV
RC4gV2h5IHRoaXMgI1VEIGlzIGhhbmRsZWQgaW4gdGhlIFZNRXhpdCANCj4gaGFuZGxlciBzcGVj
aWZpY2FsbHk/DQo+IE5vdCBhbGwgI1VEcyBoYXZlIGhpZ2hlciBwcmlvcml0eSB0aGFuIFZNIGV4
aXRzPw0KPiANCj4gQWNjb3JkaW5nIHRvIFNETSBTZWN0aW9uICJSZWxhdGl2ZSBQcmlvcml0eSBv
ZiBGYXVsdHMgYW5kIFZNIEV4aXRzIjoNCj4gIkNlcnRhaW4gZXhjZXB0aW9ucyBoYXZlIHByaW9y
aXR5IG92ZXIgVk0gZXhpdHMuIFRoZXNlIGluY2x1ZGUgDQo+IGludmFsaWQtb3Bjb2RlIGV4Y2Vw
dGlvbnMsIC4uLiINCj4gU2VlbXMgbm90IGZ1cnRoZXIgY2xhc3NpZmljYXRpb25zIG9mICNVRHMu
DQoNClRoaXMgaXMgY2xhcmlmaWVkIGluIHRoZSBwc2V1ZG8gY29kZSBvZiBWTVggaW5zdHJ1Y3Rp
b25zIGluIHRoZSBTRE0uICBJZiB5b3UNCmxvb2sgYXQgdGhlIHBzZXVkbyBjb2RlLCBhbGwgVk1Y
IGluc3RydWN0aW9ucyBleGNlcHQgVk1YT04gKG9idmlvdXNseSkgaGF2ZQ0Kc29tZXRoaW5nIGxp
a2UgYmVsb3c6DQoNCglJRiAobm90IGluIFZNWCBvcGVyYXRpb24pIC4uLg0KCQlUSEVOICNVRDsN
CglFTFNJRiBpbiBWTVggbm9uLXJvb3Qgb3BlcmF0aW9uDQoJCVRIRU4gVk1leGl0Ow0KDQpTbyB0
byBtZSAidGhpcyBwYXJ0aWN1bGFyIiAjVUQgaGFzIGhpZ2hlciBwcmlvcml0eSBvdmVyIFZNIGV4
aXRzICh3aGlsZSBvdGhlcg0KI1VEcyBtYXkgbm90KS4NCg0KQnV0IElJVUMgYWJvdmUgI1VEIHdv
bid0IGhhcHBlbiB3aGVuIHJ1bm5pbmcgVk1YIGluc3RydWN0aW9uIGluIHRoZSBndWVzdCwNCmJl
Y2F1c2UgaWYgdGhlcmUncyBhbnkgbGl2ZSBndWVzdCwgdGhlIENQVSBtdXN0IGFscmVhZHkgaGF2
ZSBiZWVuIGluIFZNWA0Kb3BlcmF0aW9uLiAgU28gYmVsb3cgY2hlY2sgaW4gbmVzdGVkX3ZteF9j
aGVja19wZXJtaXNzaW9uKCk6DQoNCglpZiAoIXRvX3ZteCh2Y3B1KS0+bmVzdGVkLnZteG9uKSB7
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAg
ICAgICBrdm1fcXVldWVfZXhjZXB0aW9uKHZjcHUsIFVEX1ZFQ1RPUik7ICAgICAgICAgICAgICAg
ICAgICAgICAgICANCiAgICAgICAgICAgICAgICByZXR1cm4gMDsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgfQ0KDQppcyBuZWVk
ZWQgdG8gZW11bGF0ZSB0aGUgY2FzZSB0aGF0IGd1ZXN0IHJ1bnMgYW55IG90aGVyIFZNWCBpbnN0
cnVjdGlvbnMgYmVmb3JlDQpWTVhPTi4NCg0KPiANCj4gQW55d2F5LCBJIHdpbGwgc2VwZXJhdGUg
dGhpcyBwYXRjaCBmcm9tIHRoZSBMQU0gS1ZNIGVuYWJsaW5nIHBhdGNoLiBBbmQgDQo+IHNlbmQg
YSBwYXRjaCBzZXBlcmF0ZWx5IGlmDQo+IG5lZWRlZCBsYXRlci4NCj4gDQoNCkkgdGhpbmsgeW91
ciBjaGFuZ2UgZm9yIFNHWCBpcyBzdGlsbCBuZWVkZWQgYmFzZWQgb24gdGhlIHBzZXVkbyBjb2Rl
IG9mIEVOQ0xTLg0KDQo=
