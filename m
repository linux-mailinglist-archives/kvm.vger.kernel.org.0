Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B6A79329A
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 01:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbjIEXbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 19:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjIEXbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 19:31:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49A7F4;
        Tue,  5 Sep 2023 16:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693956687; x=1725492687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LeO73EgVwJMqWfpZ15oynusww8VYID9Rc59G1FJVnvw=;
  b=QtEtRtPKwv/7hk9XLzEFBfpF6bNZwMoy4qX8enRVTqqVV5wxaKoKMAxf
   Lm/7ZYzvO46LtTmYXu2ZIfFxsHv2rLqncTOgyHD0ur9nYI/OJi/FUCniG
   oZCfQwY4KW97Sx4VmepeScSdZwlpw6DwYqfPYXqmfIOm3tRIMIHLf/ymV
   RJLAz7MDaETxVml4GV6Lsk3/5NfNzGPGgrOVLHgcrdEwJfdnulVQbeiYB
   I7Qy12PvH/gljjiO6SVEGwdwgoLX4e81VZ94Xqn/A+P+mAZQ6MOlyhOye
   U9vU6cMeMr4ilK2LPOEWXkkGWrR8TgUb3yYYtRgQ9NeKELeDwCxYLv2lP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="375826064"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="375826064"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 16:31:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="776364518"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="776364518"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2023 16:31:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 16:31:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 5 Sep 2023 16:31:23 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 5 Sep 2023 16:31:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Synl2v4c3mPuE4Ipw30GBHBAf5g5BdIwjdbpUAVYRITzNtPPOWkQv1GaAGVbhuXj0QxR6+fCwLyghO935XPMBWR8vPaHPDkm26OmKOft3DndboPo73zSs2Mw0hl/bJbKfjGvV7nMoUBQiTusmJgkKWoan/+g5X8AsBOLqEYQStePK2HqQMIhQ6TZkzQbl6pbj5c3emio4BGHYZPqefAXUFVAk/xUM2VBDD8r+JDcBfWTE9Y80RlHUBQWTW2uflbuNQGWYj7ZPhtLpjx7GGhjP5o5d3vc9qWGMtugYKV1GJY9Qk4iGaecnvug3Ux79tnesnxHx4GYZGFmeGoqN3yxbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeO73EgVwJMqWfpZ15oynusww8VYID9Rc59G1FJVnvw=;
 b=RzloH/MqxGbLOZpb5IiZDTA9gKI1l7kfV7NRexeOHo2ioFCyLsM3J/8kcneocLBiW7SHB8ZNmS4s9NAtZYj61XezeyNvBlJ8HxZVSVUkrPJickzSUgL6AxnI5AC8Pe84dOOFsNmM7bR9/rFB+MlLJL+YVM7t3BAFMDM7t7mOAsl1qS3FZbtFxuUypjin8XhTX2QC9qBBpF4GTSB4GicT98KmxfDw32cCQiDyoUkTBKtJEiDjn73xD3XHxXrcGNQSUqt9Ex+2UeVcF5ffz1OuXSW28JkUV5qQf9qMmoB7OUe7cAv4jXqPejrNQaI5IdPiFOJv9y9bKO97sKJa45Prkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7919.namprd11.prod.outlook.com (2603:10b6:208:3fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.21; Tue, 5 Sep
 2023 23:31:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:31:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "zeming@nfschina.com" <zeming@nfschina.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?UmU6IFtQQVRDSF0geDg2L2t2bS9tbXU6IFJlbW92ZSB1bm5lY2Vzc2FyeSA=?=
 =?utf-8?B?4oCYTlVMTOKAmSB2YWx1ZXMgZnJvbSBzcHRlcA==?=
Thread-Topic: =?utf-8?B?W1BBVENIXSB4ODYva3ZtL21tdTogUmVtb3ZlIHVubmVjZXNzYXJ5IOKAmE5V?=
 =?utf-8?B?TEzigJkgdmFsdWVzIGZyb20gc3B0ZXA=?=
Thread-Index: AQHZ3HNMJp3CnKHkCkaR6HqaH2qDArAGL0qAgARP8QCAAkJtAIAAJ5UA
Date:   Tue, 5 Sep 2023 23:31:20 +0000
Message-ID: <f542fbdf53280f009f435af99c2c57b7e203db21.camel@intel.com>
References: <20230902175431.2925-1-zeming@nfschina.com>
         <ZPIVzccIAiQnG4IA@google.com>
         <99cf9b5929418e8876e95a169d20ee26e126c51c.camel@intel.com>
         <ZPeZEpn391RGLob6@google.com>
In-Reply-To: <ZPeZEpn391RGLob6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7919:EE_
x-ms-office365-filtering-correlation-id: ad1fc1a3-f543-4b4b-ec33-08dbae6835f9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KEu30jDoPaJlJRsXSVQZRYbK24LVAxIMCpv2Heq18gwWAa63SIG93u0ZS4tCirLnMTlpzNgPoo3qpgO82FXd0W4umLarJIXCCxLSVtZxRYCbwKeeGfQlKbZFmwZF5JLEIZywBPtKp0C+i+q88kU7lC80guhwsuChYPYdXlPJZR/DflwdGNp7tINDIXKzTZ31F4IMQdNbgTcMP3ZhXH+jZGjxvTYBtnGiIcD1zWB50cAV0xBhZh/D4QoQF+V/PKfOq1Mksm8EHVzrch0x39JkVl6Styf6IjnaO2BLYlPun2+WX2n95Dqhh9EEeoMcsG6IdJckDidFw/kCltKqLobBZZQOYlVHCy3LTkZpWfEJtLJ4lr1ot+hyD12ceczskVKcvV8VucPeY2ASabVL1O3vp8t/a0kR593CeUlegPtk1D4Dw2vSZfjJT7xIAOIm0ecya+lSvK4dtkAUsZ84HWIhqbN683zkM8jkqRl3tVa0PQ3W2XodePQqnzMpe2z3pZFaYItR9QOcOCtU/exVPefAsBUi4019ziPdFvgrv8LOmjKgbnjjqniiWCBn/iS+XR7gAysuwVa4d8MumlMB3e15gxiYih7g9t76MNNbvzYE3g0qIx3LE0LKqdNVee2859VA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(366004)(39860400002)(1800799009)(186009)(451199024)(71200400001)(82960400001)(66946007)(66556008)(91956017)(66476007)(66446008)(64756008)(316002)(54906003)(76116006)(6916009)(38100700002)(38070700005)(478600001)(122000001)(7416002)(2906002)(36756003)(86362001)(41300700001)(5660300002)(8936002)(4326008)(2616005)(26005)(6486002)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UytVbHdMZ2NlVzEzZ0xJREpQSE1wVlBERXp6MkZhaUlQelFIbVF4NzFSTzRI?=
 =?utf-8?B?cVFlVVVCRVZaY1RtamMvN3cxQlVnN1VnMktwVThnUnU0aFZmQXpzTGQ5cEFy?=
 =?utf-8?B?VU9tR0pDMy8zRWROdEc5YnVNMzU1Z1JLcUdKMGNzbkJxaStlTmdJVmJRSEpu?=
 =?utf-8?B?YzkzSDNrS2M1SlhhOGpJcXRnM25iVlZtNWdyVmFmQktVNUxNOEdPZTJiN0M1?=
 =?utf-8?B?cHFYSlFQTXVxZCtqNEZUWS9tT1lTZHl6S1lsYTAxZXoxaGlxcjNWdU1mR3Fh?=
 =?utf-8?B?Q3ZmYm9BRHpiblllMTAvQkM5L3JGOVhncTNIR2tLQjloZVhXNStBeThZODhL?=
 =?utf-8?B?WUZtQnVwV01UcmV6ZzJUTUYzK09GMEUralFlUGlSREl3Mmo1U1Robkc3Q0xm?=
 =?utf-8?B?dC9manZrY25BTTBrOGdJTmZNNDE3bmZlUWJhT29EN09jYVZsRzB3Y2ZWR2hv?=
 =?utf-8?B?YzB3ZlovOWppeWZBUC94eFc3UEFQY2toMkVVU1ZuWnZjMjAzUUgzSWRiUTJH?=
 =?utf-8?B?dFFWRis5Zzc4L1RuVXV6WkJtUXdBMm9EbVZmSkhlZ2Era0w1VzdwVU95Ukx6?=
 =?utf-8?B?bDZjcEE2a0REVG84cnRzbDByTnY1VU5waWVKYlVQRlZteDE1UWgvbHkrSTNk?=
 =?utf-8?B?SFlhUFRUQ0ZIUWFReHdVYWlMUUZZODdjUnlQVmVSV1JtZ1M5bGszempWMVNh?=
 =?utf-8?B?dEJYbFhrOUJSVU9xWlZQQkh3WTM1QWxiTmRFaG5vVWRYaEE3cWh4RkhDMFc1?=
 =?utf-8?B?cDhwSTJNbTFVUWF2SlhodmdVKzBpbTBaaC8yeEErNmRBVHJzd3VhQ1FwbW9Q?=
 =?utf-8?B?QUJONWcxRmQ2Y2hYQXlYZG53UUxQSzB3V2RVKzZDeVQ2QTlXV21TckswMGla?=
 =?utf-8?B?ZUFaRytPSWo2Y2lkMFVpVTI2MHM2Y1dlM0JQTjN2blA3TmFmRkRHMk5yRHRW?=
 =?utf-8?B?c0wwTkVjNHR4OE9hUnVYbGtFREhHSlBoMUdlZWU0eGZkKytNcWNYbC80OU0w?=
 =?utf-8?B?QUp2dHpnT2VQZnpYT0liNmxxUDFRQWU4WUgyOWMwTVBFbDFVRktSeVNYcVVO?=
 =?utf-8?B?MU1pZ08zcWtBQkVPcjZXRVpSVHhSK3ZSZVU4Y3A3ZUlyQ0NOamxORHdxOUpU?=
 =?utf-8?B?VlJEZlBrc2VYU0RsN3J1OWlOdkJhYms2M1JzekJKQlhGNFlrc2VCQnlONGFr?=
 =?utf-8?B?NU1raDZabloxL09DK0JPOUdZWnVDU1FrK2w1UGVlOGJGTVRZKzJLbUlZVHp5?=
 =?utf-8?B?Sklrd0lZZ2gwR2VXcklqUk95K3ZMY25CUTdReVd2VlBSV0R3dnlicURTTWdP?=
 =?utf-8?B?SUFFKzRTR3VQOVZwcXovdkgwYkZDclU1c21vNE1sZEV3VFlZNnkvNGN2b2Fh?=
 =?utf-8?B?VHlpSDNCSUZycmgxbkJMTC9Ta0orZU5nVEZhK05mTVM2R1BYS1ZRYksxbUhj?=
 =?utf-8?B?cFRIRWhwd0VBMFY2NHJmV0huKzlocFVMeTlMSWZFbThKaUp6V3JCdktjQzU5?=
 =?utf-8?B?L2dlWE1VT2Zid1I4T2JmYmo0R0RjV21hV2FoakN5TXF2ZkhLTVVKTVhWMlVT?=
 =?utf-8?B?MGpWRjdXWWc5anlHWW9TSi9lMlF5OGh6ODZqT0xuMjFiT09nNzdZTm5FYUtS?=
 =?utf-8?B?L3VyU0ZDbVQ4MjU5YUdDVENNUVZmWjZtU0xrUHVWamd2bzdXRUZVMDRsbjJ3?=
 =?utf-8?B?cisrTVVjaWNXc0IwcWVtdStoYlNpbkxzK0JDZHA1NWhCTW5qNjhmQjd4M2JY?=
 =?utf-8?B?NEJGZjBhQXVyMnljRjd1Q01aSGM2UnBFeHQ5OXAxVVV6eW9qK05mUGREY0pr?=
 =?utf-8?B?QmdSaTAwY1JTSFM0U3FLYjZxUmhEeEp1RHVrSFpVak9WNlVlNkxTZ2hFeEc5?=
 =?utf-8?B?elV1RC80cStPMlp5OG0yK2VLZUdVUXJ0NnBmMFIzV09oVW5LTzEyZUxMUElp?=
 =?utf-8?B?Z2NzNjVLQ1dwelgyOFE3bkNzUjI3a0RVbWo4dG5HazllNlpsVXZkdGVvbk5L?=
 =?utf-8?B?S2xyQjh3UEhWd2I2NDlrdkJ3SnEvcE5TUmk1UGxHdTVKSnhjbm9wNlhySmpY?=
 =?utf-8?B?THhjUVFhSXhnU2RmUng4M0x3ZnpTTFYwWEZ4L2l5YTZkRUdDTml0TkU0Wmtl?=
 =?utf-8?Q?MKgt6pevs5+65xwrYDZIgKf7Z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D11389FA8BEF3A42ABA99E1928D64FDB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1fc1a3-f543-4b4b-ec33-08dbae6835f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2023 23:31:20.8091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8NJNqOJNQw487qnRywl8VPZalN4AyFh1RZkfUFUGQ1MDiBYLRoS1nx0WEXPjnDFZNPiXukTM4lhAWMAkCHk/hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7919
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA5LTA1IGF0IDE0OjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIFNlcCAwNCwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyMy0wOS0wMSBhdCAwOTo0OCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEBAIC0zNDQ3LDYgKzM0NDcsMTQgQEAgc3RhdGljIGludCBmYXN0X3BhZ2VfZmF1bHQo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQgKmZhdWx0KQ0KPiA+
ID4gICAgICAgICAgICAgICAgIGVsc2UNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIHNw
dGVwID0gZmFzdF9wZl9nZXRfbGFzdF9zcHRlcCh2Y3B1LCBmYXVsdC0+YWRkciwgJnNwdGUpOw0K
PiA+ID4gIA0KPiA+ID4gKyAgICAgICAgICAgICAgIC8qDQo+ID4gPiArICAgICAgICAgICAgICAg
ICogSXQncyBlbnRpcmVseSBwb3NzaWJsZSBmb3IgdGhlIG1hcHBpbmcgdG8gaGF2ZSBiZWVuIHph
cHBlZA0KPiA+ID4gKyAgICAgICAgICAgICAgICAqIGJ5IGEgZGlmZmVyZW50IHRhc2ssIGJ1dCB0
aGUgcm9vdCBwYWdlIGlzIHNob3VsZCBhbHdheXMgYmUNCj4gPiA+ICsgICAgICAgICAgICAgICAg
KiBhdmFpbGFibGUgYXMgdGhlIHZDUFUgaG9sZHMgYSByZWZlcmVuY2UgdG8gaXRzIHJvb3Qocyku
DQo+ID4gPiArICAgICAgICAgICAgICAgICovDQo+ID4gPiArICAgICAgICAgICAgICAgaWYgKFdB
Uk5fT05fT05DRSghc3B0ZXApKQ0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc3B0ZSA9
IFJFTU9WRURfU1BURTsNCj4gPiANCj4gPiBJZiBJIHJlY2FsbCBjb3JyZWN0bHksIFJFTU9WRURf
U1BURSBpcyBvbmx5IHVzZWQgYnkgVERQIE1NVSBjb2RlLiAgU2hvdWxkIHdlIHVzZQ0KPiA+IDAg
KG9yIGluaXRpYWwgU1BURSB2YWx1ZSBmb3IgY2FzZSBsaWtlIFREWCkgaW5zdGVhZCBvZiBSRU1P
VkVEX1NQVEU/DQo+IA0KPiBJIGRlbGliZXJhdGVseSBzdWdnZXN0ZWQgUkVNT1ZFRF9TUFRFIGlu
IHBhcnQgYmVjYXVzZSBvZiBURFggaW50cm9kdWNpbmcgImluaXRpYWwNCj4gU1BURSI7IGZpbmRp
bmcvcmVtZW1iZXJpbmcgJzAnIGluaXRpYWxpemF0aW9uIG9mIFNQVEVzIGlzIGhhcmQuICBUaG91
Z2ggRldJVywgJzAnDQo+IHdvdWxkIGJlIHRvdGFsbHkgZmluZSBmb3IgVERYIGJlY2F1c2UgdGhl
IHZhbHVlIGlzIG5ldmVyIGV4cG9zZWQgdG8gaGFyZHdhcmUuDQo+IA0KPiBJIHRoaW5rIGl0J3Mg
dG90YWxseSBmaW5lIHRvIHVzZSBSRU1PVkVEX1NQVEUgbGlrZSB0aGlzIGluIGNvbW1vbiBjb2Rl
LCBJIHdvdWxkDQo+IGJlIHF1aXRlIHN1cnByaXNlZCBpZiBpdCBjYXVzZXMgY29uZnVzaW9uLiAg
RXZlbiB0aG91Z2ggUkVNT1ZFRF9TUFRFIHdhcyBpbnRyb2R1Y2VkDQo+IGJ5IHRoZSBURFAgTU1V
LCBpdHMgdmFsdWUvc2VtYW50aWNzIGFyZSBnZW5lcmljLg0KDQpZZWFoIGNlcnRhaW5seSBubyBo
YXJtIGhlcmUuIDotKQ0KDQpNeSB0aGlua2luZyB3YXMgUkVNT1ZFRF9TUFRFIGlzIHN1cHBvc2Vk
IHRvIGJlIGFuIGludGVybWVkaWF0ZSBzdGF0ZSBmb3Igb25lDQpTUFRFLCB3aGljaCBpcyBhY3R1
YWxseSAiaW4gdGhlIHBhZ2UgdGFibGUiLCB3aGlsZSBtdWx0aXBsZSB0aHJlYWRzIGNhbiBvcGVy
YXRlDQpvbiB0aGUgcGFnZSB0YWJsZSBlbnRyeSBjb25jdXJyZW50bHkuICBTbGlnaHRseSBtaXNt
YXRjaCB0aGUgY2FzZSBoZXJlIElJVUMuIA0KQnV0IEkgZ3Vlc3MgaXQgYWxzbyBkZXBlbmRzIG9u
IGhvdyB3ZSB2aWV3IHRoaXMgY2FzZSBoZXJlLg0KDQoNCg==
