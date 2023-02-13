Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5DC6954B2
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 00:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjBMXWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 18:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjBMXWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 18:22:46 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2EF20057;
        Mon, 13 Feb 2023 15:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676330564; x=1707866564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=13zh9EQ0Q0xPVFp+N4MtjEmWlJVQqgll7OeU09dEso8=;
  b=KL5M12UfQ+c8VsVSThEnb/ytdD4upryUg3kAf3T5S1r41opc+n86+/xb
   dn8s1z9Ka2/aXtsPszxH51OHh3mjLv7zkRaEBfDzo0kmm8A7B9LMcFFNr
   2bj+m3j2Gu7IVgxl5Luy1CdEV0Ar4k9oXG0a8OcuQmtm6RlaN2LLTbwuz
   jp/JfaP3Fqm/nTZtRCkdV2bk+Pq+b/TDfQ3I4BwvyPL1qMz4kdqbUb0qv
   iHuPc34iw0ixotRKIzQa7+d/KR7y9yGe24peo0H3yFF64DqH4gVgjnGPJ
   qpC1cLmXDuIMZaLncHQZPmnN7Z7g24vu3i84y2GeBzRDkUwccxKfnqPJy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="329653118"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="329653118"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 15:22:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="732665029"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="732665029"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 13 Feb 2023 15:22:43 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 15:22:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 15:22:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 15:22:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUHjkhQguyXZRTdHiohj7H5kfXkaLwffRjYnRveVMdEnbayQ9seeRSwnKRlepikz7fFkXp8OWhMdymRC2sjOeAMoZBbO+o/2olqELJCr2oJUL2OKRA2gw15n61pvWzIlBndxX/8SI83mult5QYZdlDvp8jzkQA3lroGlE5lYYKcdFnwM5D5wVdTYnVAhjpKuJeW8QwwBnFyrHbxb2Z4MQeetu6pW+bIEmNm4hRiAZXDY43Y2CSi90V4XHKp6NeWq30QrkJ4ieqIfVw6xHraQy7SD0uwZB06IFiWadtV/0G1PEfVnLZFWIO+4qZW+T9mmeqxmKLkCzPjAQ/t1ge/pcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13zh9EQ0Q0xPVFp+N4MtjEmWlJVQqgll7OeU09dEso8=;
 b=i10b7/sa0SDdusSb+ZZI47b1Lg4X7k/BvmN+TgsLrzFg2ddA5m1myEUyYfcSPEXGTEypQ8TppW5LW+s6Kt2HEn2FK0kNMKvpE8p6bImYr8P63Gw09bUdKqzVbj08aqqK5MOjnD4ealK5jjK4/PXaXkUm9Xq1V5tRmPJblE74+DeB+qV4vHs1e7DoTIWbCbYAEDjzE1CvV4X5FfwjFpXA17sV6k7Na6EQ2s9rpKqK0OMAH2QQeaTqx0ls1IXlCpDZH/6ztP5c+bZuRQQxGqa4FjWWTAuYiVHqW0TFhYtNpvSNcMVnIgadjT+Y6qZQk/41zThTNHpbRV6a6NV0D2W0JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by IA1PR11MB8198.namprd11.prod.outlook.com (2603:10b6:208:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 23:22:37 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::25e9:aacd:36bc:b5e6]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::25e9:aacd:36bc:b5e6%4]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 23:22:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
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
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZP5usrWInYEMBIEu01+xNPQ5Ox67NeMUAgAAMHIA=
Date:   Mon, 13 Feb 2023 23:22:36 +0000
Message-ID: <f834ed91cba9fb7b14810fcc8ba0ae68b9b0e2d0.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
         <37d5736e-93b1-aed1-c21c-07fe1044f2d0@intel.com>
In-Reply-To: <37d5736e-93b1-aed1-c21c-07fe1044f2d0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|IA1PR11MB8198:EE_
x-ms-office365-filtering-correlation-id: dce5eae8-baa1-43ce-f15c-08db0e193158
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o4IeFS0kQezBLmcVfGpTrZ8ve9pcngz+UljD65EcjfHe8vhjPOlMBYF82ngadl/R4mw4ZyMVEuneKFVcg3anmL4Trz/yfuHg+rvztVK8luZhDP3b5YsbF9d4LqSoV5tcZdfr6JFYYNYaLZW/e+D2Ihc1bLnwBYXtv7JrChzYFB2nTG+qxnXG0QMYf98ffrrFYo2LUVNj+wwXxB45zPGu1QSSPC0VJhh5vYoeZ9YT1l1TZj5tlpq0QikFw/GoPYxJ2aqnXdIs8ESylnP6rxQ35VkbB1BZO7ouGi259mm4Ek9++9o8a0vZv1ygfq6/qkhcWSRXibLV9+d02XSEqvtwgzTd8PDCm7QIcuIXO8xQQH48pUpnwPFPovPcF3jTsFF9S2imSZliy175EuOs1q83hDLHAhdYu/VVZHH/eEepJt7ry+BW5MV83hsvMeGL5omDO2bfLUHiyCaOKFF/ZB1iyQ8MECdvvk1K1CLte7WqmzAfkMAO4J36GwDlcuHl8MAZRNjB69j4elDxkeBQX1nKorclgYib8THSTYQ/uI45/wdi4HCcYEslJqLk87ZU6BMY7riDRRNLWQlPT3JF/N2dRCKie021FwX1+BH3wv/By6Wo1MX9ztoXng640SYRdKW/NbL68Q42AFYoj2J3f9q2pUxKk6RF3q1CQpAqbD1wY4GzWsCKvCQXoHPesJNMRRp29hwJEaw9RcZHdCnoFjSRh+4J2D9GjYr6wk6rVo6cuRA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199018)(38070700005)(966005)(6512007)(2616005)(54906003)(316002)(41300700001)(110136005)(6486002)(53546011)(6506007)(2906002)(478600001)(5660300002)(186003)(86362001)(26005)(7416002)(71200400001)(8936002)(66946007)(76116006)(66476007)(66446008)(64756008)(91956017)(66556008)(36756003)(38100700002)(82960400001)(4326008)(8676002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnhrckNFdnNWc1N3cUIvWkVLcGdYeVdyVGFhdDRoVnRhbmYxNFR2WXUwTE9X?=
 =?utf-8?B?V2o1QU03SjJTTFIwSkRtSDVoM3JyUTZ1WVBZS3M0ZS9TdFhkUWtOU3pZc0Yx?=
 =?utf-8?B?YnRZZHJsR201bjZrZ3NMN0FENGRBbmxsdlZGRjBLVXhZYW5SVkNoc2lkYUdT?=
 =?utf-8?B?R0ZHcHBURmRQL0MwU1BOY3pGWFVBTzNudHdWclhZNlNGME03NWlEZFhXR1BE?=
 =?utf-8?B?SzVDS3ZkemxoKzZ5T1YyMSt1T0RhaFM5bmordWVwMEdWL3AvclRyQWxBaStq?=
 =?utf-8?B?Vlppb0dTbTdKWFNESzJRK2k3WW1NTUxVWWgzTFhMMEQ5MXBEKzRNUWZHM05y?=
 =?utf-8?B?SjBadStkQ0NoYlpHemNaQUVVOFNBZGJMNDdoMEV1endNcUswb3hKNTBRcER3?=
 =?utf-8?B?cnRHSHd2aktZNnpxcDVjYll5MzV6VnFSZVEwLzdaY25pbFo2QzJXcm5pUzlt?=
 =?utf-8?B?QTZINFlzenpmOE9lY2llQWJIT3hhaEJiaGZXUXRHTW5CdkVrckZDRGRYWlgv?=
 =?utf-8?B?b0xWRmgyd2pWQyswa2JwQXpvOEJ5NlVXUVhzcHBPMnJLalpxaDZCMXQ0QXRl?=
 =?utf-8?B?eldoMzhzSXUxd3hSemI3dXl2Wk9xdWtsREY3TlpSNVlDL3ZiV0dERlB4Tzhs?=
 =?utf-8?B?Vyt3ZGxRUkVWcUFqVnpXU2NJRVNrN3A4b2g3ckJBZGVodURuK0hxczZtMWlZ?=
 =?utf-8?B?WlZCbWNLZVM4RnE3T2Q0RThVeGlTRC80OE5TWkpIVjFCUjF6eXdTUlZEVlMy?=
 =?utf-8?B?Z3pVVlZSaFV0QThSbTRqZE16VGpkU0xEZHZrRmJEMHFVbHRpZWVsM2d5MXJi?=
 =?utf-8?B?Sjl1Q1diMVhSbkFWNFk1MGsxRml3L285aXZDWjAwTFMyU3hMekxKSit5bmFZ?=
 =?utf-8?B?Tk4yT2tBWm56elNsMWZnZnR1bXdKaVNYV1FpQndLamVsenZyYmdtTkJ2UjBv?=
 =?utf-8?B?MTBjcWtBTm53NWlmZUJRWCtTRVdvdVQwOXlCaDVsUWVzZ21ERFplSkZ3d3Fw?=
 =?utf-8?B?TTFaS0Ixc0gyTzJEbW53RWhHeUp6blhZM3FwVWFsbXlDSmNoellNbHNUQVV0?=
 =?utf-8?B?ckh3Uzl3RDBoR25WYkhUaEZUN2QzanUrZndxWHY2cm15R3RHdFBiWDZBYU10?=
 =?utf-8?B?Y3F4TkNmc1FiMi9adlppTy9COTdTQi9OOHBWVFJCMVNsTkJKQTgxRUs5bjFp?=
 =?utf-8?B?eldiTzBqWEtlOERkNW83Q0VzWmpSMldpYUtmS0N4TXlwQ1Z6SSsyWDhjN0tC?=
 =?utf-8?B?Q2pZMkg4SjZkbXF6Wmk0c1JOVm1RbC9CZlVWc01kZWw3RzVuOTVreUNxQUpo?=
 =?utf-8?B?QXg3dTgxeXAvckljSS8zMHU4SzdEcHhNUnM5aXJVd0lFek1oQmZ6TVowRmJv?=
 =?utf-8?B?QU9BczNPYTMxMkNqRWJ2cm1SbnUwZnpucHJYaXg5NVB1dDdoZklHZkdtUjR4?=
 =?utf-8?B?RkFyV2FaRExhRmxkSGlDRVZDQzhhaSsvblJNK0ZrVHFSVEhvWDRNdlVLRXNS?=
 =?utf-8?B?VGd0eDlVWGVyWU1RKzZ5THcvSTkyMVoyY29pRWplY1kvdTlhTU9NSDhZVEVU?=
 =?utf-8?B?MFdnVFNFcmlra3FQN1YxUXdLcTdFYjM2VWxBcVBCbUxYVGNDUlNucHI1d0NU?=
 =?utf-8?B?QUNKNXU3T0ZaVVJubjRBY0o5ZlM5Vm9ramxEVlNsdWw5THpBVDJYZU1wYTFh?=
 =?utf-8?B?MmpzbkVXOUVCK0MxZVlTR1g2S29XMDZsS2dadTNPRkUwMEVwUUx6TWRCd3Zi?=
 =?utf-8?B?SmpxanRQQ1hHTW41ZEpoY0R3NFNYUzdjdTk2SFNlRUtsT0tnTHlTVHRwSFEv?=
 =?utf-8?B?SXF3bnVnK0ZDN3pYWXJwa0hJSmpUQUd1OW9ScnkvY3QzL0VXK1FzZEloUGhR?=
 =?utf-8?B?YWxsTWlnYURaemJTQnJFd3AzQXNGTE1vMlFnVHNKVm9WQzdWbUhYRFFjSTJV?=
 =?utf-8?B?R0JsbnVnQVFRdVAzd1lHV2V1a250akxxZnBFUkJRd3NOT3hpVkxObm5YOFBH?=
 =?utf-8?B?MklpMDJUelVnanNsOGQycjJxV010KzkxNk9waGdYaXRnVHpYVUc5bDRwbFFL?=
 =?utf-8?B?K2oyTkVDNlpzK2dJdDVDVnBseTZPY1BHM3oyNGN6VVdVVDUxVklJMTlYeXV4?=
 =?utf-8?B?OTNybUR4RVBUSytaVDlvaVNkekN4VVdFbEhmNmQ1Z1RwbDJMZDh0RHZzNFZG?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <245AEB06A4A6944393A0089233CA9F46@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce5eae8-baa1-43ce-f15c-08db0e193158
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 23:22:36.7629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2uhNJ6SZoYMBaMOmZBdammPr/3v9ut3yACgbPfDD2dfbRFC70GpQT+EaqVAo1ITn1Zb0gnSobOmDBnFSR9EG9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8198
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAyLTEzIGF0IDE0OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xMy8yMyAwMzo1OSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFNFQU1DQUxMIGluc3RydWN0
aW9uIGNhdXNlcyAjR1Agd2hlbiBURFggaXNuJ3QgQklPUyBlbmFibGVkLCBhbmQgI1VEDQo+ID4g
d2hlbiBDUFUgaXMgbm90IGluIFZNWCBvcGVyYXRpb24uICBUaGUgY3VycmVudCBURFhfTU9EVUxF
X0NBTEwgbWFjcm8NCj4gPiBkb2Vzbid0IGhhbmRsZSBhbnkgb2YgdGhlbS4gIFRoZXJlJ3Mgbm8g
d2F5IHRvIGNoZWNrIHdoZXRoZXIgdGhlIENQVSBpcw0KPiA+IGluIFZNWCBvcGVyYXRpb24gb3Ig
bm90Lg0KPiANCj4gUmVhbGx5PyAgLi4uICpSRUFMTFkqPw0KPiANCj4gTGlrZSwgdGhlcmUncyBu
byBwb3NzaWJsZSB3YXkgZm9yIHRoZSBrZXJuZWwgdG8gcmVjb3JkIHdoZXRoZXIgaXQgaGFzDQo+
IGV4ZWN1dGVkIFZNWE9OIG9yIG5vdD8NCj4gDQo+IEkgdGhpbmsgd2hhdCB5b3UncmUgc2F5aW5n
IGhlcmUgaXMgdGhhdCB0aGVyZSdzIG5vIGFyY2hpdGVjdHVyYWxseQ0KPiB2aXNpYmxlIGZsYWcg
dGhhdCB0ZWxscyB5b3Ugd2hldGhlciBpbiBzcG90ICMxIG9yICMyIGluIHRoZSBmb2xsb3dpbmcg
Y29kZToNCj4gDQo+IHN0YXRpYyBpbnQga3ZtX2NwdV92bXhvbih1NjQgdm14b25fcG9pbnRlcikN
Cj4gew0KPiAgICAgICAgIHU2NCBtc3I7DQo+IA0KPiAgICAgICAgIGNyNF9zZXRfYml0cyhYODZf
Q1I0X1ZNWEUpOw0KPiAvLyBzcG90ICMxDQo+ICAgICAgICAgYXNtX3ZvbGF0aWxlX2dvdG8oIjE6
IHZteG9uICVbdm14b25fcG9pbnRlcl1cblx0Ig0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
IF9BU01fRVhUQUJMRSgxYiwgJWxbZmF1bHRdKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
IDogOiBbdm14b25fcG9pbnRlcl0gIm0iKHZteG9uX3BvaW50ZXIpDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgOiA6IGZhdWx0KTsNCj4gLy8gc3BvdCAjMg0KPiANCg0KWWVzIEkgd2FzIHRh
bGtpbmcgYWJvdXQgYXJjaGl0ZWN0dXJhbCBmbGFnIHJhdGhlciB0aGFuIGtlcm5lbCBkZWZpbmVk
IHNvZnR3YXJlDQp0cmFja2luZyBtZWNoYW5pc20uDQoNCj4gVGhhdCdzIF9tYXliZV8gdGVjaG5p
Y2FsbHkgY29ycmVjdCAoSSBkb24ndCBrbm93IGVub3VnaCBhYm91dCBWTVgNCj4gZW5hYmxpbmcg
dG8gdGVsbCB5b3UpLiAgQnV0LCB3aGF0IEkgKkRPKiBrbm93IGlzIHRoYXQgaXQncyBub25zZW5z
ZSB0bw0KPiBzYXkgdGhhdCBpdCdzIGltcG9zc2libGUgaW4gdGhlICprZXJuZWwqIHRvIHRlbGwg
d2hldGhlciB3ZSdyZSBvbiBhIENQVQ0KPiB0aGF0J3Mgc3VjY2Vzc2Z1bGx5IGV4ZWN1dGVkIFZN
WE9OIG9yIG5vdC4NCj4gDQo+IGt2bV9jcHVfdm14b24oKSBoYXMgdHdvIHBhdGhzIHRocm91Z2gg
aXQ6DQo+IA0KPiAgIDEuIFN1Y2Nlc3NmdWxseSBleGVjdXRlcyBWTVhPTiBhbmQgbGVhdmVzIHdp
dGggWDg2X0NSNF9WTVhFPTENCj4gICAyLiBGYWlscyBWTVhPTiBhbmQgbGVhdmVzIHdpdGggWDg2
X0NSNF9WTVhFPTANCj4gDQo+IEd1ZXNzIHdoYXQ/ICBDUjQgaXMgcmF0aGVyIGFyY2hpdGVjdHVy
YWxseSB2aXNpYmxlLiAgRnJvbSB3aGF0IEkgY2FuDQo+IHRlbGwsIGl0J3MgKkVOVElSRUxZKiBw
bGF1c2libGUgdG8gYXNzdW1lIHRoYXQgWDg2X0NSNF9WTVhFPT0xIG1lYW5zDQo+IHRoYXQgVk1Y
T04gaGFzIGJlZW4gZG9uZS4gwqANCj4gDQoNClllcyBDUjQuVk1YRSBiaXQgY2FuIGJlIHVzZWQg
dG8gY2hlY2suICBUaGlzIGlzIHdoYXQgS1ZNIGRvZXMuDQoNCkFyY2hpdGVjdHVyYWxseSBDUjQu
Vk1YRSBiaXQgb25seSBjaGVja3Mgd2hldGhlciBWTVggaXMgZW5hYmxlZCwgYnV0IG5vdCAgVk1Y
T04NCmhhcyBiZWVuIGRvbmUsIGJ1dCBpbiBjdXJyZW50IGtlcm5lbCBpbXBsZW1lbnQgdGhleSBh
cmUgYWx3YXlzIGRvbmUgdG9nZXRoZXIuwqANCg0KU28gY2hlY2tpbmcgQ1I0IGlzIGZpbmUuDQoN
Cj4gRXZlbiBpZiB0aGF0J3Mgd3JvbmcsIGl0J3Mgb25seSBhIGNwdW1hc2sgYW5kDQo+IGEgY3B1
bWFza19zZXQoKSBhd2F5IGZyb20gYmVjb21pbmcgcGxhdXNpYmxlLiAgTGlrZSBzbzoNCj4gDQo+
IHN0YXRpYyBpbnQga3ZtX2NwdV92bXhvbih1NjQgdm14b25fcG9pbnRlcikNCj4gew0KPiAgICAg
ICAgIHU2NCBtc3I7DQo+IA0KPiAgICAgICAgIGNyNF9zZXRfYml0cyhYODZfQ1I0X1ZNWEUpOw0K
PiANCj4gICAgICAgICBhc21fdm9sYXRpbGVfZ290bygiMTogdm14b24gJVt2bXhvbl9wb2ludGVy
XVxuXHQiDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgX0FTTV9FWFRBQkxFKDFiLCAlbFtm
YXVsdF0pDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgOiA6IFt2bXhvbl9wb2ludGVyXSAi
bSIodm14b25fcG9pbnRlcikNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICA6IDogZmF1bHQp
Ow0KPiAJLy8gc2V0IGNwdW1hc2sgYml0IGhlcmUNCj4gICAgICAgICByZXR1cm4gMDsNCj4gDQo+
IGZhdWx0Og0KPiAJLy8gY2xlYXIgY3B1IGJpdCBoZXJlDQo+ICAgICAgICAgY3I0X2NsZWFyX2Jp
dHMoWDg2X0NSNF9WTVhFKTsNCj4gDQo+ICAgICAgICAgcmV0dXJuIC1FRkFVTFQ7DQo+IH0NCj4g
DQo+IEhvdyBtYW55IGRlc2lnbiBkZWNpc2lvbnMgZG93biB0aGUgbGluZSBpbiB0aGlzIHNlcmll
cyB3ZXJlIHByZWRpY2F0ZWQNCj4gb24gdGhlIGlkZWEgdGhhdDoNCj4gDQo+IAlUaGVyZSdzIG5v
IHdheSB0byBjaGVjayB3aGV0aGVyIHRoZSBDUFUgaXMNCj4gCWluIFZNWCBvcGVyYXRpb24gb3Ig
bm90Lg0KPiANCj4gPw0KDQpPbmx5IHRoZSBhc3NlbWJseSBjb2RlIHRvIGhhbmRsZSBURFhfU0VB
TUNBTExfVUQgaW4gdGhpcyBwYXRjaCBpcy7CoMKgDQoNCldoZXRoZXIgd2UgaGF2ZSBkZWZpbml0
aXZlIHdheSB0byBfY2hlY2tfIHdoZXRoZXIgVk1YT04gaGFzIGJlZW4gZG9uZSBkb2Vzbid0DQpt
YXR0ZXIuICBXaGF0IGltcGFjdHMgdGhlIGRlc2lnbiBkZWNpc2lvbnMgaXMgKG5vbi1LVk0pIGtl
cm5lbCBkb2Vzbid0IHN1cHBvcnQNCmRvaW5nIFZNWE9OIGFuZCB3ZSBkZXBlbmQgb24gS1ZNIHRv
IGRvIHRoYXQgKHdoaWNoIGlzIGFsc28gYSBkZXNpZ24gZGVjaXNpb24pLg0KDQpXZSBjYW4gcmVt
b3ZlIHRoZSBhc3NlbWJseSBjb2RlIHdoaWNoIHJldHVybnMgVERYX1NFQU1DQUxMX3tVRHxHUH0g
YW5kIHJlcGxhY2UNCml0IHdpdGggYSBiZWxvdyBjaGVjayBpbiBzZWFtY2FsbCgpOg0KDQoJc3Rh
dGljIGludCBzZWFtY2FsbCguLi4pDQoJew0KCQljcHUgPSBnZXRfY3B1KCk7DQoNCgkJaWYgKGNy
NF9yZWFkX3NoYWRvdygpICYgWDg2X0NSNF9WTVhFKSB7DQoJCQlXQVJOX09OQ0UoIlZNWE9OIGlz
bid0IGRvbmUgZm9yIGNwdSAuLi5cbiIpOw0KCQkJcmV0ID0gLUVJTlZBTDsNCgkJfQ0KCQ0KCQku
Li4NCg0KCW91dDoNCgkJcHV0X2NwdSgpOw0KCQlyZXR1cm4gcmV0Ow0KCX0NCg0KQnV0IHRoaXMg
d2FzIGFjdHVhbGx5IGRpc2N1c3NlZCBpbiB0aGUgdjUsIGluIHdoaWNoIElJVUMgeW91IHByZWZl
ciB0byBoYXZpbmcNCnRoZSBhc3NlbWJseSBjb2RlIHRvIHJldHVybiBhZGRpdGlvbmFsIFREWF9T
RUFNQ0FMTF9VRCByYXRoZXIgdGhhbiBoYXZpbmcgYWJvdmUNCkNSNCBjaGVjazoNCg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzc3YzkwMDc1LTc5ZDQtN2NjNy1mMjY2LTFiNjdlNTg2NTEz
YkBpbnRlbC5jb20vDQoNCg0K
