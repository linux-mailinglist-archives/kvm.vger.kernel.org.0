Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFD4751A46
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 09:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjGMHs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 03:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjGMHsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 03:48:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495FA268B;
        Thu, 13 Jul 2023 00:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689234528; x=1720770528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L2jkkaZikBu2ErlJ4n4I0oOKM3IpBpsw26nW9e6l7X4=;
  b=ORFugwx0WK97549VAWeskMRRI++sJPk2x5+mId7xdzgsQHfi14s3aNOO
   +R9MMj/q7KI3zMdurrb9AO3GG0JVROh1sVjLsWkHUt4dYcErtL55PPCL0
   VUcnLcc1k3ofPMI1MCKFct1g6UOUS8XAHGGmczKiu8XROH4FfVJS32A9Z
   cQYxZETB7RRq+XvhgzhojgfoYPbmmCcZ9Rk3/sA4ExDUkB2eLf3+L6nZw
   u5kWKSE5AvwwxSrWa8XX2e4LiOLN7DY9j5hcd83rMVHIZqm8EQTNpF5hY
   qJ8zzzZndbN1EO3SOojhyDB66szXc+Arsi0rKxkCz+xJ6tf6GzGhXg3a3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="362583255"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="362583255"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 00:48:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="715862830"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="715862830"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 13 Jul 2023 00:48:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 00:48:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 00:48:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 00:48:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeMAStMu+baHSHuR1lkqOkqLeT0xTj9X8tycuYlrCvzrzzySSOv3IpxFOkuik4+usBxLjqLE9fTKbzQ98fSv+CSC3o1jgAqizG8974OK0eXUwgxGT5+/kv+6ShwY4Rvd2ekcrqHuWHrUHwYXyQolzqKVv4FI0C4ITZ8BousoXMs0vpoYzlEKpXCvQPP7wsfJq2LDc5y1GGIjcmH9QfhPmJa2Zw8deutzqWgp5oBTu9lSmA4UwW7+QmCl+8P/N6q6USDvVvHnn5NeQBS5YFu3xchDohWiMHZS/Eas4ISbp6awr0jUT8Zwelf9NZJEZhg18gVGAPgcl4U5Z5RN4UAiDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2jkkaZikBu2ErlJ4n4I0oOKM3IpBpsw26nW9e6l7X4=;
 b=NoLrzA39sM3kf7vSzRfA3TAAuq5JcRY7SvgKSz6DCTDBAM5aJs5V/sjhicpbDOsxDLLQW36PXgOzzhA8wKRTYkGY1Rrsm02ZZk/JHzz2+VPQm+Tt74R/yfarLNo5cPQIwOvg222q/LI+piJ1F0UsE12/A5R7B3wC0Lae8/qVeCC+1a+Zyp71eJxcLLXWcqgD4wLvMtsRpsEfzFnwbpqzUE5D3pHmpA/aWHKRaHuJZ3vIjV0TAgsqaG0wWXT7RWCmZ23VQwvbwM2t2nzZg4P7GtkOtEDiZufsJrsY6NYKti2U5h3+M6jny1qctgAf0Q+HbaTctqA2SC9Ykjwcs4vYYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6380.namprd11.prod.outlook.com (2603:10b6:510:1f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 07:48:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 07:48:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Topic: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2WZEAgAD5+gA=
Date:   Thu, 13 Jul 2023 07:48:20 +0000
Message-ID: <6489a835da0d21c7637d071b7ef40ae1cda87237.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
In-Reply-To: <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6380:EE_
x-ms-office365-filtering-correlation-id: 59a5f14d-44ec-4fe2-4b07-08db83758769
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MXY/CoivWGPPYN9Cjt8ooLyMd3F6mLLcMrGyCOKNCG6YiZClp/57nf2kda1q9+GXkkvRzUA+q4jAND15sZEk6u9JEHe+A9Ukk9jjoX9zeSHrwPb57pyCIPLmbI8C3f+cI/2ribCgvSB2y+Vdo7vJ3UvsGvADCNziDqNQXWZNDiY9YMruXaSEkhnEqqVTZvWO7cq0GNXnIK78RLSUqlfkBT5avlIWozn31kLnJjYxWHBCxWOP0KuzJzUCV7i8FtKThPApBhM6LfZC9xrWgsAtyBgmN8ghasptQ68D7946TpWJcI/hzSJKPNU94RcHlub3ApdE+SdikPvgY+wg19n3ZNc1xWmN0k1AQlGnr5Z1TlZyoZd6xkNglLg+ix1zql6xqieu9YFEIKRDEt6OrQDoCdeEXSpXLZutonkUiUfp05lkH8b/Oj715tQxmuD5OnPUF0XcvSNHJbY4kFffHRdjHGx0coO8Abd5sQbHSiP9NTfCqPCh/v0gNQncjlarym5zvWX9hYvxDnaIYDX6l2PIieyZW1QFFXQvvmi2TQv3o90j7tsURGHRNo+iz+eBcssvXW80OiCu1oAVeGVEgT0BRtubr9N5RvtT12iZLr8LrtLx6VAdgfIY3pagWp8V/yoP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199021)(38100700002)(76116006)(478600001)(6486002)(54906003)(91956017)(71200400001)(26005)(2616005)(83380400001)(86362001)(36756003)(38070700005)(2906002)(66946007)(6506007)(186003)(6512007)(122000001)(82960400001)(8936002)(5660300002)(7416002)(41300700001)(316002)(66556008)(6916009)(66446008)(4326008)(64756008)(8676002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azB0dkxOanVFWCt1aFRIWlA1WTBxdkpyRSsxSmtsUXdtVlFudTcwcmQ2Zm5r?=
 =?utf-8?B?cHVQdHJ5RnJnV0R1dkNPK3g2a3RCMFl6OUNGb2RrYUk5Y0k1Z2tjL1Q1VkF3?=
 =?utf-8?B?WnIwczhyelFHcTd2Q1B0RFdlUkkwQVcyZDVpYkhyV0Jya2l4RFZFdFhyUWh1?=
 =?utf-8?B?U2hNdFVoT2tyTVg0MkFxRWFrVzE2NWRLWFVLNW9KYm9wQThSK1Q5Q0doWERB?=
 =?utf-8?B?WEdKZWErZnljL3g4aXpDOS9lUnpsbWVUQzdUck82MXhIWEFLTlZMQ09RUklw?=
 =?utf-8?B?OHFSZGlkVk0zSldiTDhtWGNjeFg4MWhaNmQ1WGttSXErcGtCak5JVG83d1BW?=
 =?utf-8?B?eEFwQVh5c1F4UTNHT3R2UG9qeUVwbzh2YlY5aTRQUU5DQlVLRVd6dEx0bWE0?=
 =?utf-8?B?K1BzaUNQTi9QOHY4emQ0MVRVd05NTXE1TUc5S3N3bUtpTzdQdmxqQXZ1WjFM?=
 =?utf-8?B?Tzd2dEhWdHpHRkRTdExYSndHT1NiZHNzcnhHT1FqVzZLMS9JeWp3bm1SSWw0?=
 =?utf-8?B?aUlSbjdVUWJuT29GbDJlOXJWUE1jUXg1aWE2ekViK1dHdWk2VTFEMWFDOTd5?=
 =?utf-8?B?TnZDY2lYZEpXc3c3RW4zMWxmbHFnMko4a210dnhaY1lPY2tuU3dtYkxkb3R3?=
 =?utf-8?B?amFlenE0cDg0Tm8yamVEMDRCK05vZ2ZkL1ZmY3BtbU85bGROZjlGY2k5dWRo?=
 =?utf-8?B?UkNHVnVsbkltY3FrWElGcVZFbWNjM3A4K0NGZ2hOQWY2NlNrRWtWTWltZDV0?=
 =?utf-8?B?NjY2M0l2REJ2K1Y3NHJ2aU9XZTVlNjNqcEl2NnZHNkh4TGNkK2p4dTF6S0hj?=
 =?utf-8?B?MmRxZU0rM3h5T2xjeFI4d0FUSTZ0UVpXWnRockNDbkFqZEE0ZERFTmlpSFp2?=
 =?utf-8?B?RHU3K3lZUndBeWpmMlFRN2JvbjlHYUFQQnR3eE1UN0VxazB2RHJESlR3WmNa?=
 =?utf-8?B?R2o3NnY1V1RoQlp3bGttZDNjSlI1aE53MTZaUWtZcXBLYm9ZS0JCZU9BbE1m?=
 =?utf-8?B?dVhNUnNxRmdrZDhUUTVuelZIYzZBUk1PUHFrUTU0WmxiN3IvQm4rbHRaeFho?=
 =?utf-8?B?N2pzbEo3dHVyUGVkQjJqWE9kOXRlMGx0ZGp2aFRLQktBcG4xdDJuU21lbTRq?=
 =?utf-8?B?bk1lcFB1V2pnRHAxMXFYSUhwV0hwb2g3bVdWZUZvNmZnYzM4SnFkZm8rRmh0?=
 =?utf-8?B?T2MvSisrSTM2SWE0N210Vld3UXByOUZmRThGdkgrVU5FcVJ0ZmIvSmprZ2JT?=
 =?utf-8?B?Y0lybkQ2WUdOMWdhbGNHSGc2Mzc1SzB1QnduNWlBdTkwL0MwQ0hxa1p2WGF4?=
 =?utf-8?B?ZnNiVDZyYUtGVjYvc25scHUraThDcUpLQ01TeGwvWWt2R0xKdnliWWUwWTVi?=
 =?utf-8?B?R1VsbWFUejdsUHZrZkd5NVk4K3haWElMZ09jODA0bzNuN21YNUpEWkRsbzFF?=
 =?utf-8?B?SjUxUktiNkV4Sm1IQ2lGaUlYRWV4aENPa1JRV3EzQlNMTnNSMm1mWXgvRHRk?=
 =?utf-8?B?RHQ4UE15V25zQklwYjFld1dBTHVWb09mT2VsNjhNZ2laSSsvOThkNGF2UW5V?=
 =?utf-8?B?TGo4SENsRFFxQ28xa2t5bDZrRldwTjBzdnlCK1JESGtWL0xPRjZtakdJdHZ3?=
 =?utf-8?B?Zm94MzVYNTRBeFpsa1orYjhEekxnejFRa3h4d3hJSXBDOUxUQVhHbGp5cE5J?=
 =?utf-8?B?TzUzWGNQQUd6OUN3eUNiTzNkaE80SVZOa0V6SWJHZkl2cytiQ0dOaWZ1c2VF?=
 =?utf-8?B?SVBkeG92cnc4NnEzTmRIWG8zZmgzdjFZZysyQklZd1pSdVRJellTeXFWbU5u?=
 =?utf-8?B?Z0RNNjlzeXduZTRYUHY1eUFUREorODNpNjBMaUNES21NQVFtcXBaUTE1clNC?=
 =?utf-8?B?SjNubUhXYk5CMi9xaEFjcUlIaVkrN2txMGJESCtGRUdzeEtpbE9xQThCYjE2?=
 =?utf-8?B?NHM4YVJPTHFkZm1OKytEWU1VR1BFSFM3YXkzZ01peVJEamMxR1RzUlVHT0tI?=
 =?utf-8?B?NXlmZDJyQ2Rrd2V3cjQyQStzK09PQmthN01Cb3V3OWE4Rjl1WjVyblY3UVFK?=
 =?utf-8?B?UTllVmNmQTh1cThsc3lxcmF3TzJ4dzRCZVpEVDFYbmpudlZtTEFtaHFHcmFH?=
 =?utf-8?Q?1aDoUkJ9qj6CBeV9KlRYP9si2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC2585509FCB6E49A563D6FA2C0BC5EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a5f14d-44ec-4fe2-4b07-08db83758769
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 07:48:20.9081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fO2xssL1NZx6vl7dEU+wTIc4l8gM3ok9VTELVzE/hgFfxT4Ky+UBRkBq+LQIuiZDAVTtwOq9kR/NYC9/38yDsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6380
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTEyIGF0IDE4OjUzICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdWwgMTIsIDIwMjMgYXQgMDg6NTU6MjFQTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiANCj4gDQo+ID4gQEAgLTcyLDcgKzE0Miw0NiBAQA0KPiA+ICAJbW92cSAlcjksICBU
RFhfTU9EVUxFX3I5KCVyc2kpDQo+ID4gIAltb3ZxICVyMTAsIFREWF9NT0RVTEVfcjEwKCVyc2kp
DQo+ID4gIAltb3ZxICVyMTEsIFREWF9NT0RVTEVfcjExKCVyc2kpDQo+ID4gLQkuZW5kaWYNCj4g
PiArCS5lbmRpZgkvKiBccmV0ICovDQo+ID4gKw0KPiA+ICsJLmlmIFxzYXZlZA0KPiA+ICsJLmlm
IFxyZXQgJiYgXGhvc3QNCj4gPiArCS8qDQo+ID4gKwkgKiBDbGVhciByZWdpc3RlcnMgc2hhcmVk
IGJ5IGd1ZXN0IGZvciBWUC5FTlRFUiB0byBwcmV2ZW50DQo+ID4gKwkgKiBzcGVjdWxhdGl2ZSB1
c2Ugb2YgZ3Vlc3QncyB2YWx1ZXMsIGluY2x1ZGluZyB0aG9zZSBhcmUNCj4gPiArCSAqIHJlc3Rv
cmVkIGZyb20gdGhlIHN0YWNrLg0KPiA+ICsJICoNCj4gPiArCSAqIFNlZSBhcmNoL3g4Ni9rdm0v
dm14L3ZtZW50ZXIuUzoNCj4gPiArCSAqDQo+ID4gKwkgKiBJbiB0aGVvcnksIGEgTDEgY2FjaGUg
bWlzcyB3aGVuIHJlc3RvcmluZyByZWdpc3RlciBmcm9tIHN0YWNrDQo+ID4gKwkgKiBjb3VsZCBs
ZWFkIHRvIHNwZWN1bGF0aXZlIGV4ZWN1dGlvbiB3aXRoIGd1ZXN0J3MgdmFsdWVzLg0KPiA+ICsJ
ICoNCj4gPiArCSAqIE5vdGU6IFJCUC9SU1AgYXJlIG5vdCB1c2VkIGFzIHNoYXJlZCByZWdpc3Rl
ci4gIFJTSSBoYXMgYmVlbg0KPiA+ICsJICogcmVzdG9yZWQgYWxyZWFkeS4NCj4gPiArCSAqDQo+
ID4gKwkgKiBYT1IgaXMgY2hlYXAsIHRodXMgdW5jb25kaXRpb25hbGx5IGRvIGZvciBhbGwgbGVh
ZnMuDQo+ID4gKwkgKi8NCj4gPiArCXhvcnEgJXJjeCwgJXJjeA0KPiA+ICsJeG9ycSAlcmR4LCAl
cmR4DQo+ID4gKwl4b3JxICVyOCwgICVyOA0KPiA+ICsJeG9ycSAlcjksICAlcjkNCj4gPiArCXhv
cnEgJXIxMCwgJXIxMA0KPiA+ICsJeG9ycSAlcjExLCAlcjExDQo+IA0KPiA+ICsJeG9ycSAlcjEy
LCAlcjEyDQo+ID4gKwl4b3JxICVyMTMsICVyMTMNCj4gPiArCXhvcnEgJXIxNCwgJXIxNA0KPiA+
ICsJeG9ycSAlcjE1LCAlcjE1DQo+ID4gKwl4b3JxICVyYngsICVyYngNCj4gDQo+IF4gdGhvc2Ug
YXJlIGFuIGluc3RhbnQgcG9wIGJlbG93LCBzZWVtcyBkYWZ0IHRvIGNsZWFyIHRoZW0uDQo+ID4g
DQoNCkkgZm91bmQgYmVsb3cgY29tbWVudCBpbiBLVk0gY29kZToNCg0KPiArCSAqIFNlZSBhcmNo
L3g4Ni9rdm0vdm14L3ZtZW50ZXIuUzoNCj4gKwkgKg0KPiArCSAqIEluIHRoZW9yeSwgYSBMMSBj
YWNoZSBtaXNzIHdoZW4gcmVzdG9yaW5nIHJlZ2lzdGVyIGZyb20gc3RhY2sNCj4gKwkgKiBjb3Vs
ZCBsZWFkIHRvIHNwZWN1bGF0aXZlIGV4ZWN1dGlvbiB3aXRoIGd1ZXN0J3MgdmFsdWVzLg0KDQpB
bmQgS1ZNIGV4cGxpY2l0bHkgZG9lcyBYT1IgZm9yIHRoZSByZWdpc3RlcnMgdGhhdCBnZXRzICJw
b3AiZWQgYWxtb3N0DQppbnN0YW50bHksIHNvIEkgZm9sbG93ZWQuDQoNCkJ1dCB0byBiZSBob25l
c3QgSSBkb24ndCBxdWl0ZSB1bmRlcnN0YW5kIHRoaXMuICA6LSkNCg==
