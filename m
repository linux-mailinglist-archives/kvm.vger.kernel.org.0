Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F082751E13
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjGMKCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbjGMKCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:02:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35682D76;
        Thu, 13 Jul 2023 03:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689242494; x=1720778494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wng37czkUrDafJyXmGKjSmeBxTAzgOZ4NRVN0iP5NEE=;
  b=DSg4wHUKZRQn5J9tt+o0n1gu9STJG77TYtSoQ4UD0nI9X7mWjF937XvS
   SPRcRCIPCkAEEYKKTabODV5ddw4vPJzAuAV+7PyXWbbs5n7Qk2UdSlSF4
   xC4qyHcn9HMfo+UknlmSkREkaRFgNeXzbWE3tqmrRkM5AiN25W4TjWBb0
   1hiWf9irgFszStDI5PZXRdU+kd5e5fbDX1lCK2xEXzPdd612Z1n6+U1DA
   2w50GJgEucRyyzMEOjfFrt6WbgtlAiET5tN1eFYBK8SnkJeGcKjjUnmxA
   KlusJAiHRxjmqfHSn8dTAw5iJTG7ID5maeeI92RIkjdgRZBi021mcjYGQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="344737370"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="344737370"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 03:01:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="811924006"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="811924006"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2023 03:01:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:01:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 03:01:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 03:01:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czHhPF40zLyUJeb6ASA4G9DFOgV/rbgxNziU0ldV3lAsn7WIpmDZxBXuVAln3+eGZIfN/4vn8D9HnQSX8gnAHZO5EdgpXMSmpbIv6qCLU7UhRePpFfl0aV174uiSGJxuXOdBrHNRbZeWmSAIyfw+0VCaM/GjG++xOacy4nk6o2QWTWxqHTaUVK5dBFkaU8+mRs+RJf93+R7ntNDiqd2AYBMHTfefXfxEwRdVFY5abttNHLlqc7rq7Mn34zwuHHYImFZ1TwhHalYktqez4vrreqaBol9cvYO6hLB1zOZ91qRRsb0Aqj5Bp39oVqJawjK87UJGNDJMBnqoDsMxSP3AmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wng37czkUrDafJyXmGKjSmeBxTAzgOZ4NRVN0iP5NEE=;
 b=G/93S6ssA+iVruZEISxfV3Pt3MWwAZ15IfrJeiiO+tiVQwqvYZyAX9jLHb67kD4vPTY9Sgul5rkZ3IEF1UJYiCMtt4xFAeQ1DFYB3+iKxDBXnhI/FBQZnJ9PO4Obl5X1ZRSza+tnjEBADQDbfH0uyUBT7y9ZKdF+qUTIZqjsB+4IA9E9uQ7UiakN9nJQjnAYH8/HFZa1VcL+8NnFzJiTIDEYFmVFzK+6dTHTvOBLAZFOai/auyVzFvukERve7QLG6iu5g/s+pxpNU8KnTkgFYphXmMLAW+0EofU/AMjoPMJNUQSIWaqNJLIGiRSW+/oqO/Kr0Hbv/LG6UyDO5PiW6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5448.namprd11.prod.outlook.com (2603:10b6:208:319::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.26; Thu, 13 Jul
 2023 10:01:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 10:01:30 +0000
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
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2XpWAgAD65ICAAA5uAIAABBWAgAACqQCAAAoagA==
Date:   Thu, 13 Jul 2023 10:01:30 +0000
Message-ID: <188f5d1d17079abb25c8264c03641fad0d2590e4.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712171133.GB3115257@hirez.programming.kicks-ass.net>
         <a36d1f0068154a9acd3fdbed2586dc5b2476e140.camel@intel.com>
         <20230713090110.GC3138667@hirez.programming.kicks-ass.net>
         <4e542a29ba6083981c13c43d0c5e69d24f42f812.camel@intel.com>
         <20230713092518.GF3138667@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713092518.GF3138667@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5448:EE_
x-ms-office365-filtering-correlation-id: 3a7eebc4-5265-4ea5-48b1-08db8388216c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q91nFY0tno7ugIjS1il6IDMk3lQFY+tzB7U5IB6oVkr1hWSgouQ5d+waXSmj54HrO/GJu/ciNyYQ5J5wmLn54plcza+y5W5+VE9lZU9C2GpwFSjyH2J8tgc1NhU2ONhw4gtwvrbzfnuRmtf7raHrpI+XF6rpzvoXzBKE5rEQmQ0LbM1UCzfGcEgQ0LkvsxL/JNlzcRpoGe40FeKbHCdiwWuwKKDj3D9JptMf4o6fQD1nwb5nSucc9fCV+9b9owslr4ND9eIMx6IZYJQSEcX+h0RC7NEut+gi85lCZiCKsxo9nTOCtsbWCgJI7lQb/P3gTcXBFIjXbWckXQJ8isRYQs/lI3wcCU7V8oArP9S091bvtEFIxA6ywRcRLYcn98iyAeM8bUb9jfkMZh/oGkCekcxD6ZMflfVzHaK9omFl5agfA2F4yYIXs2DH3h8m5xD7q83W2+s2yeDD1t/nnIjMmvdOOvpIRmGGxSzAYTeO/h7roD8g9ZBvx97jpV+0bJrGnU5a06yFyxsi8QQbcfFLjs5Z+xjblI2OwVce3uNeVExIlSlqw+oJX8W2RJ1uh0ChEXKyrTYsNMdikUhK6wopUBRrPF48u/hcZr3cRHR+A3czvVlRrqLzpzWgfHd7d4kE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199021)(6512007)(6486002)(71200400001)(83380400001)(186003)(2616005)(36756003)(122000001)(38100700002)(38070700005)(86362001)(82960400001)(26005)(6506007)(66476007)(66446008)(64756008)(7416002)(76116006)(66946007)(66556008)(6916009)(4326008)(91956017)(54906003)(41300700001)(5660300002)(316002)(8936002)(8676002)(2906002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWp1OWxqL2xDSzdIdnY2cUd5VXd2ZzZabmlPcTJxb1FjcFllWGF0QjNRSHVv?=
 =?utf-8?B?L1BVN3UyWjBkTjk2Ri9GNXMxYy9FYzlDU094Y2NKclVCNjZSU2ZPZnFLck9k?=
 =?utf-8?B?VkNZekxkczVrdVBFaGNPM2pmZmVNYVJ0U0ZTMWZtTkJ4Q2E2T2NRZnRtZTVV?=
 =?utf-8?B?bjg1N3dTWnEvUngwR202VmdJb25BQmVhdno2cVVveEU2UEFCcVhtN0o2WElr?=
 =?utf-8?B?ZWxZc05UTU1wWFNjMlkyVzdaU1ZMMTBzemhqaVcxVDFTYkFlemZhcnVzbDNk?=
 =?utf-8?B?a2xzYXppN3pkcTFXMlZKQnF6SnIxTEYvL0JtWHBacGhDY1F2SXU5WTR2SEV5?=
 =?utf-8?B?NGd4ckFKU2pNVjBVZGIySUt0UmVFVDhibjZSUTEwdFFqYnk1c2VzdC9jSkw4?=
 =?utf-8?B?a1NOL3RRNkg4SC8vU05laXZSMVZ2ZE9HL3BNVkMycE5wTFZ0djNxVGVZYUR1?=
 =?utf-8?B?SStha1MwOXRjcmVjcnlCSlhlYUsveWUzNDkyRGxSZmxrSFphMk9pNzRTOG1C?=
 =?utf-8?B?UDRiTmMwMEl4TWhremdIVjZabTcrMDZnS2lOT1JGRTJxS2hGSUZiRThNaGxa?=
 =?utf-8?B?Tk1XTmNxSUp1ek56THNPcWtPRUZSR1gxS0RWT203VksvUS9zQnNsVDVKMWVX?=
 =?utf-8?B?YmN2blBiTTZidE0rVUdubCtLUGNNaXlnZWVGaW45UWgwSlJXakVLaGxGY0xM?=
 =?utf-8?B?S3E2bXB6bU4xQVFPc2QyWnhBMzh2bFBCNTczU1puNnpOdGdIWW12cVp1N0lM?=
 =?utf-8?B?YW9aWFpjeE8xSUV3azBZNk1hNFdRa3Z6YWpiTWFoQ1RudGFiT0E2NlA2eCtx?=
 =?utf-8?B?cXRBTmhwL1l3c3l1KzRJTGhzUGU1MGZQK2xWQ1BERGtIZlhnZmpsdFlheE1q?=
 =?utf-8?B?RGZRMWVaUWVPSmtOT0NCVDRyNVdCMnNpYmNQajAzc3NjaWR0V1RjTFo0RDZC?=
 =?utf-8?B?cG9iTTQyTnhLMEYvMUQ0WVMrWWdXaWRzVzBEckhaMkNLdXVDWGV0RXE3cDNY?=
 =?utf-8?B?YU1SN1JMdDBtV1ZiTWxqek9YdFlBMG00M0R4dkFUTTEzTGNJSmVMR3I1UEZG?=
 =?utf-8?B?SUFKZnFkT09yRnpHTFowcXlyekxoMUQvVURmR1NHV0NjckhmODVta1podmJy?=
 =?utf-8?B?bjhGYk5yNlcvTHNtemJrOU1Wdmpxb2pGWXN2dWRyNXJXbmhOMXpxYUNCSHpE?=
 =?utf-8?B?a2hvNmZLR0pocnFtS0FUb0xTYVBFL1NUbXY4cTJ4RmdYamdHYklBL0k4VEhy?=
 =?utf-8?B?cStid2pwK0V3U2RLUHZmQnZlTzdYS3VDTHlWSnQzODJQNU5vdk1iamRSOTl4?=
 =?utf-8?B?NHFNdldZMDR1VnNtbWtBUWlpbm9zYlFYVDBBYnZLS2RSdDJRZmI2RThxekEy?=
 =?utf-8?B?N1NObEV2MFBWNVdhYjFpQ1g2SGd5RFN2ZmVaMmI2eXlVMGl0dENBeXNQN1ZR?=
 =?utf-8?B?T2ZYS0p2N2I4cTM4OVB3MURBQWplenRjU09VRzhCalRVSVdWeG1xOTgvZENC?=
 =?utf-8?B?VUJwRHphakNpM1VXbkIyZWRiL3FpNVRQYkdodW5YbDZQdTNhVERGd0xZUExs?=
 =?utf-8?B?UTVrZ0hKcHJ2OHVWUjMyam1hMlNlQ2ppMDEzMGEvM3ZNN3FuTnVMbm1uWTlH?=
 =?utf-8?B?UlBlUExxUHF3RTJzeWtjN2VyWG5OZFMzZTkvVk56YkRZYWFlbTR1QXUwLzhm?=
 =?utf-8?B?K0Q2SGk2T0RUL3lVSGxuV0RLYmpRVThNUEtFczRUOWR4QzJhWEpBM3RSS283?=
 =?utf-8?B?ZGw1b2RNNDVOK1VDVFMzdnE2eGNPc25ER3JvdUUwaUcrenNPazJORHg0Z2p1?=
 =?utf-8?B?dWV5VTdMY25OWm1HMDh5N2g0UXZENVV1MU9rWnVkY0hjbFVleVNYTVJaZGVH?=
 =?utf-8?B?VERNWmRWTmUwR0RjZ2V6MW5JYTdNYWdmUEVRWURFSldHc1M3TjI4YXlvbyt5?=
 =?utf-8?B?dFN5MXFXSldYMWJId3lzSU1tYWF3WmtCMU5FNjAxL0dkeklWbXpmZ0lxaHNV?=
 =?utf-8?B?dmwrcVozbzd2UWp2Q0pJQ3phbng5aVllL0dUL2M4RDIvTTAwYW00ZFcxUHg2?=
 =?utf-8?B?SXdINDM1aUdJV2lxNE1KRXdQQW5hZmFuNXV0dGFnR3hPR3BBUGl3R2ViekI3?=
 =?utf-8?B?SXA0U3Z2NWozZEgxSVRldTVxb0x1VW9jZGNXL0V2SXlMS0IvamZCSDd0azhl?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DAE08E2110F424D909228F15696EF68@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7eebc4-5265-4ea5-48b1-08db8388216c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 10:01:30.2479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3FFVI4SxLSzqs2HGaDVVnMLx1zh8ABJcTpaobWJVSYQKpCQbr9HmZ30DjfuFaoGEqBkgRIUQ01TvfQxajaXOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5448
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

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDExOjI1ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDk6MTU6NDlBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBUaHUsIDIwMjMtMDctMTMgYXQgMTE6MDEgKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDg6MDk6MzNBTSArMDAw
MCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gT24gV2VkLCAyMDIzLTA3LTEyIGF0IDE5OjEx
ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gPiA+ID4gPiBPbiBXZWQsIEp1bCAxMiwg
MjAyMyBhdCAwODo1NToyMVBNICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+ID4gPiBA
QCAtNjUsNiArMTA0LDM3IEBADQo+ID4gPiA+ID4gPiAgCS5lbmRpZg0KPiA+ID4gPiA+ID4gIA0K
PiA+ID4gPiA+ID4gIAkuaWYgXHJldA0KPiA+ID4gPiA+ID4gKwkuaWYgXHNhdmVkDQo+ID4gPiA+
ID4gPiArCS8qDQo+ID4gPiA+ID4gPiArCSAqIFJlc3RvcmUgdGhlIHN0cnVjdHVyZSBmcm9tIHN0
YWNrIHRvIHNhdmVkIHRoZSBvdXRwdXQgcmVnaXN0ZXJzDQo+ID4gPiA+ID4gPiArCSAqDQo+ID4g
PiA+ID4gPiArCSAqIEluIGNhc2Ugb2YgVlAuRU5URVIgcmV0dXJucyBkdWUgdG8gVERWTUNBTEws
IGFsbCByZWdpc3RlcnMgYXJlDQo+ID4gPiA+ID4gPiArCSAqIHZhbGlkIHRodXMgbm8gcmVnaXN0
ZXIgY2FuIGJlIHVzZWQgYXMgc3BhcmUgdG8gcmVzdG9yZSB0aGUNCj4gPiA+ID4gPiA+ICsJICog
c3RydWN0dXJlIGZyb20gdGhlIHN0YWNrIChzZWUgIlRESC5WUC5FTlRFUiBPdXRwdXQgT3BlcmFu
ZHMNCj4gPiA+ID4gPiA+ICsJICogRGVmaW5pdGlvbiBvbiBURENBTEwoVERHLlZQLlZNQ0FMTCkg
Rm9sbG93aW5nIGEgVEQgRW50cnkiKS4NCj4gPiA+ID4gPiA+ICsJICogRm9yIHRoaXMgY2FzZSwg
bmVlZCB0byBtYWtlIG9uZSByZWdpc3RlciBhcyBzcGFyZSBieSBzYXZpbmcgaXQNCj4gPiA+ID4g
PiA+ICsJICogdG8gdGhlIHN0YWNrIGFuZCB0aGVuIG1hbnVhbGx5IGxvYWQgdGhlIHN0cnVjdHVy
ZSBwb2ludGVyIHRvDQo+ID4gPiA+ID4gPiArCSAqIHRoZSBzcGFyZSByZWdpc3Rlci4NCj4gPiA+
ID4gPiA+ICsJICoNCj4gPiA+ID4gPiA+ICsJICogTm90ZSBmb3Igb3RoZXIgVERDQUxMcy9TRUFN
Q0FMTHMgdGhlcmUgYXJlIHNwYXJlIHJlZ2lzdGVycw0KPiA+ID4gPiA+ID4gKwkgKiB0aHVzIG5v
IG5lZWQgZm9yIHN1Y2ggaGFjayBidXQganVzdCB1c2UgdGhpcyBmb3IgYWxsIGZvciBub3cuDQo+
ID4gPiA+ID4gPiArCSAqLw0KPiA+ID4gPiA+ID4gKwlwdXNocQklcmF4CQkvKiBzYXZlIHRoZSBU
RENBTEwvU0VBTUNBTEwgcmV0dXJuIGNvZGUgKi8NCj4gPiA+ID4gPiA+ICsJbW92cQk4KCVyc3Ap
LCAlcmF4CS8qIHJlc3RvcmUgdGhlIHN0cnVjdHVyZSBwb2ludGVyICovDQo+ID4gPiA+ID4gPiAr
CW1vdnEJJXJzaSwgVERYX01PRFVMRV9yc2koJXJheCkJLyogc2F2ZSAlcnNpICovDQo+ID4gPiA+
ID4gPiArCW1vdnEJJXJheCwgJXJzaQkvKiB1c2UgJXJzaSBhcyBzdHJ1Y3R1cmUgcG9pbnRlciAq
Lw0KPiA+ID4gPiA+ID4gKwlwb3BxCSVyYXgJCS8qIHJlc3RvcmUgdGhlIHJldHVybiBjb2RlICov
DQo+ID4gPiA+ID4gPiArCXBvcHEJJXJzaQkJLyogcG9wIHRoZSBzdHJ1Y3R1cmUgcG9pbnRlciAq
Lw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFVyZ2doaC4uLiBBdCBsZWFzdCBmb3IgdGhlIFxob3N0
IGNhc2UgeW91IGNhbiBzaW1wbHkgcG9wICVyc2ksIG5vPw0KPiA+ID4gPiA+IFZQLkVOVEVSIHJl
dHVybnMgd2l0aCAwIHRoZXJlIElJUkMuDQo+ID4gPiA+IA0KPiA+ID4gPiBObyBWUC5FTlRFUiBk
b2Vzbid0IHJldHVybiAwIGZvciBSQVguICBGaXJzdGx5LCBWUC5FTlRFUiBjYW4gcmV0dXJuIGZv
ciBtYW55DQo+ID4gPiANCj4gPiA+IE5vLCBidXQgaXQgKmRvZXMqIHJldHVybiAwIGZvcjogUkJY
LFJTSSxSREksUjEwLVIxNS4NCj4gPiA+IA0KPiA+ID4gU28gZm9yIFxob3N0IHlvdSBjYW4gc2lt
cGx5IGRvOg0KPiA+ID4gDQo+ID4gPiAJcG9wCSVyc2kNCj4gPiA+IAltb3YJJDAsIFREWF9NT0RV
TEVfcnNpKCVyc2kpDQo+ID4gPiANCj4gPiA+IGFuZCBjYWxsIGl0IGEgZGF5Lg0KPiA+IA0KPiA+
IFRoaXMgaXNuJ3QgdHJ1ZSBmb3IgdGhlIGNhc2UgdGhhdCBWUC5FTlRFUiByZXR1cm5zIGR1ZSB0
byBhIFREVk1DQUxMLiAgSW4gdGhhdA0KPiA+IGNhc2UgUkNYIGNvbnRhaW5zIHRoZSBiaXRtYXAg
b2Ygc2hhcmVkIHJlZ2lzdGVycywgYW5kIFJCWC9SRFgvUkRJL1JTSS9SOC1SMTUNCj4gPiBjb250
YWlucyBndWVzdCB2YWx1ZSBpZiB0aGUgY29ycmVzcG9uZGluZyBiaXQgaXMgc2V0IGluIFJDWCAo
UkJQIHdpbGwgYmUNCj4gPiBleGNsdWRlZCBieSB1cGRhdGluZyB0aGUgc3BlYyBJIGFzc3VtZSku
DQo+ID4gDQo+ID4gT3IgYXJlIHlvdSBzdWdnZXN0aW5nIHdlIG5lZWQgdG8gZGVjb2RlIFJBWCB0
byBkZWNpZGUgd2hldGhlciB0aGUgVlAuRU5URVINCj4gPiByZXR1cm4gaXMgZHVlIHRvIFREVk1D
QUxMIHZzIG90aGVyIHJlYXNvbnMsIGFuZCBhY3QgZGlmZmVyZW50bHk/DQo+IA0KPiBVcmdoLCBu
byBJIGhhZCBtaXNzZWQgdGhlcmUgYXJlICpUV08qIHRhYmxlcyBmb3Igb3V0cHV0IDovIFdobyBk
b2VzDQo+IHNvbWV0aGluZyBsaWtlIHRoYXQgOi0oDQo+IA0KPiBTbyB5ZWFoLCBzdWNrcy4NCg0K
WWVhaC4gIEkgdGhpbmsgZm9yIGNvZGUgc2ltcGxpY2l0eSB3ZSBzaG91bGQganVzdCBkbyB0aGUg
d2F5IHRoZSBjdXJyZW50IHBhdGNoDQpoYXMgaW1wbGVtZW50ZWQgOi0pDQo=
