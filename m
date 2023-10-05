Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CAB7BA133
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 16:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbjJEOnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 10:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237150AbjJEOik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 10:38:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E600547851;
        Thu,  5 Oct 2023 07:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696514576; x=1728050576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l+KUCngkyx4Xn47J8ZIAf9ufOUPZQFuBvCf7z3BgsUw=;
  b=jdjGDiUavp+nNZWRqsE4/B19B7E94kiwgiPIVd7y9Lbn8zV4GHVKFtUr
   7UnoReSNVlPDxBboGfglHFeTf+y1uyH7MWP74HzFWtkNNl5O3TpohlbW0
   XA7qkLajCNKHRskltZxOzKt3aIsDgjrqeYZgftZORp3vs1qAq0rNFOHWB
   V+AyczKWDGg9DjoVZLF+OQAgC6PUGqI0E6cykzIe/cOW6n+TvcoM3JR7a
   ZPVeKAm63SxivuFYl0wBxOsVHXZsQqKbE0EO/A7shhP/I+m9yZdFffHYb
   b3Jhikkt47kFoLlHtr80DIQov4/q7GzsntzgMPFB9nyXEAhAfnyY9ToD9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="4989434"
X-IronPort-AV: E=Sophos;i="6.03,202,1694761200"; 
   d="scan'208";a="4989434"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 00:21:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="701541751"
X-IronPort-AV: E=Sophos;i="6.03,202,1694761200"; 
   d="scan'208";a="701541751"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Oct 2023 00:21:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 5 Oct 2023 00:21:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 5 Oct 2023 00:21:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 5 Oct 2023 00:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEr2COyaTpLFS/pIFmGFo1/e2oIIkIcV+3xSAIEz0KD9DmRz93cbY0tsy/kNzBex5BX/fepvw5T4va3w64Pio1S62XWbRMeJTTqtIhIJHCTEBIWv8faSGPBLuRjiQYn7zQAj5RfnWTWZ9aLD37xIv6B56hCHHkcTNXOurhCGCIVW7HaMbCGZLIf/8PUhbaQ0pqPZ4MxKdLRI8zocHlzvDt+nfHsByeoQJ2w7MfrCbUDzH33LgW4lETop3u5wDOdUKrXhJJsXASHeUEdclFyg3XNENV3pSkbkkgccQwXXJxIKXCQKVipANt8ztLPLvS6vriy9HQUcs+SgzKHx8Psg9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+KUCngkyx4Xn47J8ZIAf9ufOUPZQFuBvCf7z3BgsUw=;
 b=FmU6hv9P/mrGhhcOkKgPAcmL5uCm7qqC7ZN5Hjz5Pt57GVyW7lTeBJDIyRxOCDG1W7wJUENxh+mB8vkleCugppfdnx0psXg0/oRy/hAnRpFY8RPEHU7iH2sMR/SEAce/mCT8hbEkxgj/7LY3DLpY9Cl84N2qnyhXj102LUNGPjMK99vEzsqE8B8MK8FF0RJxEG/tV1/9m30Tn9rjRqwLtNo3Xjy8Ib0FwfTHATA5QqBMqLeRGEwIU/bFzOwYLPq3qQ0blNs2mR1UDLEDeCODrcB5F22H5zW3rRO+WMa/ONEdUWWq5Kpw5SJkdo7ry/fbpfnDBy4o4ZGN3XOc+Un2YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DS7PR11MB6151.namprd11.prod.outlook.com (2603:10b6:8:9c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.29; Thu, 5 Oct
 2023 07:21:29 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%6]) with mapi id 15.20.6813.017; Thu, 5 Oct 2023
 07:21:29 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v12 00/37] x86: enable FRED for x86-64
Thread-Topic: [PATCH v12 00/37] x86: enable FRED for x86-64
Thread-Index: AQHZ9caENagGnRugfUWOoRzs4wEdL7A6vBYAgAAMCNA=
Date:   Thu, 5 Oct 2023 07:21:29 +0000
Message-ID: <SA1PR11MB67345B6C16EEA16FEED714D2A8CAA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <9b5ddb4e-12f1-4058-bcce-119d6ac4817c@suse.com>
In-Reply-To: <9b5ddb4e-12f1-4058-bcce-119d6ac4817c@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DS7PR11MB6151:EE_
x-ms-office365-filtering-correlation-id: a8cfe870-ff54-42a5-c796-08dbc573b18e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wnAjEeoibdnhFB0qD2X2MCZl8OJKdkKnXQTF+7evRGFnlf5gNiWssSRPy/hUg4gt6pt16EhETDBIkjuGqCq+b4a+1SO9Qtn5hbh2dMRvtmf+vFRUBJA4M2NRKCOTqsMnq7Ko1jpCdKLVwTzAUtPy3UN3H4iwnJvWK25v+Guei4W4s9cLoZTKHhsinIBg2+Du/SyEj7nbqxG3EApsQV3BH49tOd6VOu8XVXQnvFD2bWs+l+BanFDWrMoJs61ip+c63+ty1P2HK5OWEzAvlzCd7n7DrTSI/moNNdfzyn+lq8Pm9Pgq7Zt8SLUwKKu0VNgS1Za5EIqc5XjCx/yRAg1X0YCrRJSh7jsIPXNB2yj9lzojASC5l52rI9ImXvjVufyo/tBAFxLq8ph4S6brJbVSA9b/eYQIv1u3CAr31QZZ2nTceEtsKICIRfrxWjYcfn4mZoaH9PQ7+E/pPb7g3UYenFhkmTG2Ubq1uAxpaN9KWCuN0osQc2od26+72ZA9LrFOMpUHkcsiOm1l3g75UYpttTr0/ypromhRIHYnbopFsnE8FxRGcBJFOQD6yi5e47wF5G5dUAuLTHjbWbNCjDbeKSEK3RkbmESGlnjtkZof4lt3Vgo+ndTK5JlnTxoTMgXH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(39860400002)(366004)(376002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(38100700002)(55016003)(26005)(82960400001)(38070700005)(122000001)(33656002)(86362001)(83380400001)(8936002)(316002)(4326008)(64756008)(54906003)(8676002)(66446008)(5660300002)(41300700001)(66476007)(66556008)(52536014)(110136005)(4744005)(66946007)(2906002)(76116006)(7416002)(478600001)(71200400001)(9686003)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnlSRVpWbFlEUDY2aWNaUnlvUWxZMEpCb2F4MXg5aHAyYzJLQkRtYmpYZTUx?=
 =?utf-8?B?dWhFOFE3MndrS2RnNG1BVDcyNGcvbU5XRG9YWWVGeUthYjFLaWFwdHlyenFE?=
 =?utf-8?B?aE81RmpqNTN3NzY0cEwrM04xR3RLelVDZjc3OFdZTS96dENwQjBuaFhzZ1JH?=
 =?utf-8?B?RFlKN1VqNFNid0lOQU9KRlRVVDRNc3dzZmdBTGdXcjUybFE3cG1NRHZJZENt?=
 =?utf-8?B?YVlvQmxabnlIdkhCeXFqWVllY0lURmovQ3Z2ODF3RVI4ckF1c20vZFMrQXZZ?=
 =?utf-8?B?cE1vb2lYbEgyOU5EenRWZUtJSFdUTEpvNlB1MitiMVRxVU03VFFoU2tCRmtm?=
 =?utf-8?B?T25hTkZQNXU5TDFaRUJaRFNnczF1amFOYURZNmVsUmJTTlFsWG9Gdk4rMlBR?=
 =?utf-8?B?SG9DZExGWkpQcWRiOUtGdE9NM0RtanhPTExuczNEYjRqOFlhUlhYSGpVdjg0?=
 =?utf-8?B?TnRnYjE0bnpPM3Avb1dpVWFYekJCbDBkMkVOQm93R29WR0F5SFVSVzl4UUpi?=
 =?utf-8?B?blpRWUdPbW53anBJcTc3cUE4RlNCZkEzeUJoZ2FXMkdETEFnYWhpQ2RDR0xy?=
 =?utf-8?B?ZFVvenozZ0dFbnBGd3RCZk8xdVQwTXpJWmt2bnBDelhpVWVhVmNlWGJkUkl6?=
 =?utf-8?B?WkMzV3V5UlJVemFGREVIaWwvZmJ6R3lBeUdmRXExeDR3OTJjVlF0b3JvVnF2?=
 =?utf-8?B?bUtieVdDUWN2WDNZSEZ1d0l5VjJLRlVtRWRZN2ExbmpxUE5LaUJxV29nZTF1?=
 =?utf-8?B?T2V0TThqeXBXL1ZLd3FxMmV4Z1lkL3Y0Y0NPdjBwdjhGTThHYzZYRFhnSys1?=
 =?utf-8?B?VkJJaC9IOEQ1cENHb2NwbVFhQlQwTDdlZjdLVXorWlpSWnlCYk1qLytpNE9k?=
 =?utf-8?B?QVdZUkExOXNjbWh2V1ZhVkdWQUt2TVhqaE1xaElYeUkyWVRkNHkvcU9JOW0z?=
 =?utf-8?B?SmFGTEFaRlRVK2JyZmtXRFB1M2VkVVJrWnNEZjltbTVodWIxUnFZZ01NVHNq?=
 =?utf-8?B?VVJtTU14K2kxSVFFZzgvY05rZjBVcUpSbDdxamQ1VEYrQkJTT1Rtekw1YVpB?=
 =?utf-8?B?ejNUcGNUQ2lvaFdVbTVoTHZLL3FWY3o1cEFPUkpycTI1WFQrOGJSQWR0bXhr?=
 =?utf-8?B?Yld3NGFpUUczM1c3SDRXWWdTVXovOFIyZ1ZvcTk1S0VEMUg5b3RGb2RCcTZs?=
 =?utf-8?B?VStsS0xBem5DQ2JMUXBrN0lBNFRKdEVlTnJkaUJFRDJ1VDFZVHVrbitYVnFJ?=
 =?utf-8?B?cUFkVVNlQk1xQ0xyUG05TkliSjUyUFozQmNmMHliWmh4dWxrOXZ6TXRMbk1X?=
 =?utf-8?B?TlZJZXRDTHR3aEY5eVJIaEVxRGNROWNkdW1hcUVMMGxGWDdwT1pVZlFhYjJS?=
 =?utf-8?B?Y2J3cExKK0tFUzJjNU9pTEVkZlMzTE5iTmRzdG1QU0ZZdUkxMEZYaFQ3c1d3?=
 =?utf-8?B?cG1KMTVOUkZpenNNQks5Njg4dzllaWhheWJ0cUZQWS8xbTQxSHFxTXhQS0RS?=
 =?utf-8?B?VWpvblhyV0VROGRyVGxvRG91dWpyeWZGbzN1bWdDR1hxV0N3dW40emVJaytL?=
 =?utf-8?B?Ty9idVViVUVxbTBZRXdzcllYZ3Q2WWhUd3c4V0VkdE54Z3ZQcDhXQVZRNmtv?=
 =?utf-8?B?cm1pOGxpbGZycFJmdWlBTHpXOHlPdHVxVWdkS3V5MUh3MzlOWlprZjFmQVEy?=
 =?utf-8?B?enJ1V3AvaW4wbUUzWWNDU2QwaTIwdlo0SnpkclE0bDZSOVBTbXM5TlpUcmJF?=
 =?utf-8?B?b05BTldva0k2YnVuclhHYklhaTlHQ1BIdXBGNnVUYmlDa0cwUjk0OHN2YmdF?=
 =?utf-8?B?aGNnK3Btb0xtTlJ4V3BHeGUrQXNqRW9DSW1FTzhhZTJPeXEzNHcxcFJ5dzFs?=
 =?utf-8?B?VDZ4ZzV0OUcyVVA4REV2d3JiMTRmNGduRWo0dHJQUnBjZGpKeHVzN0hVMnlv?=
 =?utf-8?B?dXdnb3dlWXhSNkFGWDZOM3plbG0vV1JDTnNsN0FiK0JXT2NCRndpMHBmZC9U?=
 =?utf-8?B?YURJN0srK2hvK0ZKVnBGcmVqcUNYWWV4LzgrNkZnTDc5cEkrcE9sRGgzYTZq?=
 =?utf-8?B?Z3c1bFUyVlR1MElDNzRWallKbWxoTEZZR3NHWlZIMWJSU256ODNrSHZzQ00y?=
 =?utf-8?Q?RsJE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8cfe870-ff54-42a5-c796-08dbc573b18e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2023 07:21:29.3301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y4yGboRDoJVw6HShIVcUIcawr+dMFUTXIsQsaxkZHnLIKZG+zkhFcXrwn4ABkUVLTS8xYyC58qBUJSDRze9mmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6151
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IFRoaXMgcGF0Y2ggc2V0IGVuYWJsZXMgdGhlIEludGVsIGZsZXhpYmxlIHJldHVybiBhbmQg
ZXZlbnQgZGVsaXZlcnkNCj4gPiAoRlJFRCkgYXJjaGl0ZWN0dXJlIGZvciB4ODYtNjQuDQo+ID4N
Cj4gDQo+IA0KPiBXaGljaCB0cmVlIGlzIHRoaXMgYmFzZWQgb24gbm93Pw0KPg0KDQpJdCB3YXMg
YmFzZWQgb24gdGhlIHRpcCBtYXN0ZXIgb24gdGhlIGRheSBJIHNlbnQgdGhlIHYxMiBwYXRjaCBz
ZXQsIGkuZS4sDQpNb25kYXkgbmlnaHQgaW4gdGhlIFVTIHdlc3QgY29hc3QuDQoNCj4gSSB0cmll
ZCBydW5uaW5nICdiNCBkaWZmJyBidXQgaXQgY29tcGxhaW5zIGl0IGNhbid0DQo+IGZpbmQgc29t
ZSBjb250ZXh0IGFyb3VuZCBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jIC4NCj4NCg0KV2hh
dCBkb2VzIGl0IGNvbXBsYWluPw0KDQo+IEkgaGF2ZSB0aGUgdGlwIHRyZWUgdXBkYXRlZC4NCg0K
SSBqdXN0IGRpZCBhIHJlYmFzZSBvbiB0aGUgbGF0ZXN0IHRpcCBtYXN0ZXIsIGFuZCBkaWQgZmlu
ZCBhIGJ1aWxkIGJ1Zw0KY2F1c2VkIGJ5Og0KDQpbUEFUQ0ggdjEyIDMzLzM3XSB4ODYvZW50cnk6
IEFkZCBmcmVkX2VudHJ5X2Zyb21fa3ZtKCkgZm9yIFZNWCB0byBoYW5kbGUgSVJRL05NSQ0KDQph
cyA8YXNtL2V4cG9ydC5oPiBpcyBkZXByZWNhdGVkIGJ5IDxsaW51eC9leHBvcnQuaD4geWVzdGVy
ZGF5Lg0KDQpBZnRlciBJIHJlcGxhY2VkIGl0LCBpdCBjb21waWxlcyBhbmQgYm9vdHMuICBXaGF0
IHNob3VsZCBJIGRvIG5vdz8NCg0KVGhhbmtzIQ0KICAgIFhpbg0K
