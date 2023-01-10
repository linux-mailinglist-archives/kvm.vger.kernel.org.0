Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72363663E18
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 11:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjAJKZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 05:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbjAJKYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 05:24:22 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A933B35933;
        Tue, 10 Jan 2023 02:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673346251; x=1704882251;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OZ52j4xzHxX7LyzVCHDD0p/toae7yhd6Y/XrS9t40Zo=;
  b=ap7Kf1Tjpzj2Hd5rXjjcEDFJPPqsUXEE6o0pPA4cSV4+jRJw3B1Xq2nx
   YXHmePtj04l5k7xaugRrUAVB4jtBa+OTENxxnngfgYxSb9W6rsykNkf0u
   AFXPc0bRGoozMhtWR3+w4IDvxqirgShkuoaH52Ck0+qqP5VTlonZbmUkh
   p192w48bz+vHUXevc1bxsjQEZFU2iyszripUko4X4GugtNqUhdm6j9gxU
   38obI8gUjPeVlawJbHRr2tMTaveH99WM2LXc/okuHrxVqNBJTp44bzItY
   CX8LTadaBnEMzQ0/Bwa4fXha39AInRACSFbD4STIy8dvNQWWURLip1xsn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="302811799"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="302811799"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 02:24:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="689369834"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="689369834"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 10 Jan 2023 02:24:06 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 02:24:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 02:24:05 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 02:24:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwE8+Umew5NxkbbXXKcivrvJsXgmrujcxZ+qKyL2kj3PVw63z78QLCLkvQHhvaHbGZcdgk8sXS0q52pTOHxzPrVtd367ktrvT5+vOWhtfhrwrnZg8usPTRZFK3wJ57RjWN6RRcm87GIOECD8J8p6MVqZzDh/oIrUkE4EMjY8m7ivOQkFdrEDJ3YqcqIoWGlEPIr/Mq70jIgvDmPV3KOJTJm5h/IcEKaM8sPPz01+zIzZZlSr+IAo+VfUqpnlD/gjI0KabxlpSGBS8cF5et99aXNqhnpAdWo+OHWjJuRRY81WXV36sHiJtlJ7j0B8tBBVp5T55wmhXl602Pm3eXqjjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZ52j4xzHxX7LyzVCHDD0p/toae7yhd6Y/XrS9t40Zo=;
 b=ldgprK+evqRTiezBXBAYhG88cMzDyir/diuhyIrp3GGjmH8tjYRi3RDAODoqZqtZr89h0mcEnr7DKDZIt9DopDVW9lb81unnyl6lwEnEPzG3pawVAYLnL7GrKk+EssPQezz+sQtdcz92e52lBV1F30+4+nROommdarOGiZa5iM1plath/v6PWchfF5SFtLMdd/Nll5kxdlYqqNBI9mwc5cKFuud81L76Dndvxv60FY4yb6EJCPnrafiUxkqWPp6fAHUyUneE6/dA5eMntSnOptH2jQOBIxRgbwYHwjblQ+gbNCqllHacgwEougX9NUct+eMH+TSzKZOv6h7JZlgm2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7869.namprd11.prod.outlook.com (2603:10b6:208:3f6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 10:23:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 10:23:59 +0000
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
Subject: Re: [PATCH v8 14/16] x86/virt/tdx: Initialize all TDMRs
Thread-Topic: [PATCH v8 14/16] x86/virt/tdx: Initialize all TDMRs
Thread-Index: AQHZC5gJUgUI7AggTkOjnL4MIbo5q66SQ64AgAVgbgA=
Date:   Tue, 10 Jan 2023 10:23:59 +0000
Message-ID: <36b4e36b1504e24629bce1631c452dc0bb2d7610.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <16d47f9611d53c0f07a4af2b5739ed83e41b6e48.1670566861.git.kai.huang@intel.com>
         <8e46f932-8ec9-0621-4423-e6233747b231@intel.com>
In-Reply-To: <8e46f932-8ec9-0621-4423-e6233747b231@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7869:EE_
x-ms-office365-filtering-correlation-id: 4147c3e9-1284-4d10-c0b3-08daf2f4c9b2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QcavH17hYofy5I3AnB7CmD7ZFWgGgVJDSOBKa0bswoHU6cCOkz+gveX6oCqVpTbjITSOGd5gy2deSnr/hDfN7pVnEGSJuJUCSY4RBU3fQdJluYcta8QW6Uypp8oItndLHAVzqes7vzBKqE4WDYxTtJCkYcJHJjjdPJ7WHPvehjrpBkAZ2GSOo8IDSvGBEeN3Ay1I/iaJOpF/8lUbKpA6RDydtnYRtJAd4Jom++rjvtZvD++W9eQGr7dEPA7NH/yetCWPQXLQHWzQLc9or7GFyIYrtqNJwUm+mDKMmDV5ouEdZGwaXrZAKQSYix6lYccDcFQg+mMj1GZ1jQVuZ1K92fr7s090Zbxrd6JXzysZwLVBjlmRs22McJEA4o9GfysZTKNp+Q22QiOVdrGt6iG4aZQ9sW4gbcp25IgoqHmq6pDY92n6qJtknM4146v53EO5Z41RnPAncUd1dWl7r/1+Vm87Zmulc/DSgNcgKWRshlUjs3IP/9J+0iMUV8bTXIJNJEhN0QO/L99+Gh9G5sJGVRhIVq0FJFdpDPJodfO+zaOpP8mIktl51I+rlpks0YK8E0Tp7vDy8CiLCcvdl576pQHnZwZdSm9LTyuBWLL3zU5ojTZ9Ctz05WC/tUhf+DVw88+qzNmxrsI51wDCAfJ3b9eNK5nAo3SmQtyFlqwCJJ1stnDLjs9jfb3fek6WQeaKC/8cacfWiKcFaHAZd46GmlKUk+6Aean30H3qiglO2Z4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199015)(7416002)(5660300002)(316002)(71200400001)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(41300700001)(91956017)(66946007)(76116006)(54906003)(110136005)(4326008)(66446008)(66556008)(66476007)(8676002)(64756008)(8936002)(38070700005)(86362001)(36756003)(53546011)(6506007)(122000001)(38100700002)(82960400001)(2906002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEZCSElWb2E4MHBsNnh6QlR1RFZSU0hTS2JLdU1Za1dmUWpURmcwbWg4VXRt?=
 =?utf-8?B?LzZ1MXJyVWFMTGRhMjJrVHRKRXBnK05QMlN6Y0x6Sm5pNERncjBBL3EzRXor?=
 =?utf-8?B?TEdsaDk0QTB1UFZPVUdaNDJZL3pkSzJtSHVzZURReG1mSFdJRlZ4TnFKYXVp?=
 =?utf-8?B?NndBR2hhaWNjZXMwZ3N1WG4yNS9yYVhIWlNzbTUxeEhzWmZtcnY4VHdRMHFs?=
 =?utf-8?B?QTYzRTdjOHdKL2t2b1hSVWdSRmFrM0JVcU9FUzVRdE11eWl6T2wvSndpaWlG?=
 =?utf-8?B?R1RoVkwzUm5RTzI5RnkySTdUdW1Bc1UxbkVpTDVab1J4bzBXbWtka2kwTU1K?=
 =?utf-8?B?bytDb0xGaldoT1BHV3ZJYVdCakx0cnZ0QTR5YUdyOWJGS2NsYzJhajBvU3dv?=
 =?utf-8?B?ZWVRMWZIa2Y5SUlsMWpLY21KcGpiMUVKemVLUkJiNG9uME9yZTRCc2hRTUZl?=
 =?utf-8?B?ODNBL3dEMG9VK0ZxdVVsa09iM3J6aE5penIyUHVzbTFxL2xNTElhaFZOVyt1?=
 =?utf-8?B?YkZob2RCU0JvTFI1UUo5SmJVNEh1QnZvdWViREoxZS9GTWE4aFdTUktPWXZO?=
 =?utf-8?B?bjB0Z0cxZ0pOT01uVnRONEF5UEhteEkzV0dOdXNFZ09LRUIwditFTG0zRmti?=
 =?utf-8?B?NFY5T0piQzdhUFpoMEJsc1kwMGxSUEJqWWxVNmNpcFY2LzJQUDRQMmhrTHJO?=
 =?utf-8?B?dktieXQvZVNCVTJGMnI4bmdzSy9Ub0FYRjNueTdPZTFHUGxXT0tkQ0FORml5?=
 =?utf-8?B?Uzl1bFJCVnBJc3gyMHgxTnIxUHV2clFiL2NlTU4xaVNEMXVVcTJiQVptM0ZB?=
 =?utf-8?B?OG12QXZJWVltK09nWlhqVkJEcWNRL3lpNlc2b2l0K01VRFNWVVRnby9vcjlB?=
 =?utf-8?B?MkNYU0k0ZDRJcFZrd2EzTUYxSmduaFBoUUNpemI0QTY0YXNETkhhb0N5SFhp?=
 =?utf-8?B?U2FxM1JLeGg1blNPbUZqRy9kZ3FSc0JYZ1RhVkN3aCtweVlIcmRrTVhjanpT?=
 =?utf-8?B?MURGRDhVM3UrQ1hUc3NKZEVzQVdLeCtySStvOHBQaGVZNGlHVHgyTDQyVGRx?=
 =?utf-8?B?Q3lWcUZWbkt3NWJoUVlHeGNYUExLVFlwc052ZzFxQm5oN0R3QWpIS0JDa2M3?=
 =?utf-8?B?Z3BiUzF5c3ljVnVtOWFCbnIrcGhTOGR0RkVGTEtUa0dzejBXV25zV1FTclQ4?=
 =?utf-8?B?bkNwMmhiRlVid29PNEV2M0tOYVZaUklkOFlHTjI2ZmIzTUVOZ2x5R1AzcThP?=
 =?utf-8?B?RFV5OWhuenRRYVQ4eUk5VlExanRZMHdhTEJzd2dzSnF0dFIxT1ZITTZ6Qnlp?=
 =?utf-8?B?TmZkYU1CTGo3N2F1M2QrTzJQeE1Fd3I4TjNYd2s0TzJqdmN6Y2ZlVXZQdTNw?=
 =?utf-8?B?eVRsQ2JJY3llMTZUZlhlV2FxVGlORkxUUnl4WXhkZ0N3QXJXMVRubHovUXAx?=
 =?utf-8?B?LzNzS21UelFsajQzTm5kTWVKOWlINHVQWklGV2JSTUY5MzdVNndnRmY0WUxR?=
 =?utf-8?B?MHpqTi8vVzgzQTJVS25yTTRHTVhNRHgrUjdlcTVjQVdDQVhRN1prVFZjUXNl?=
 =?utf-8?B?UjI0TjR3ZkFUellIbDJtYzAyY2plcjhXSkdMTGNCelFTWURZNXVMNllPRmdT?=
 =?utf-8?B?dS9IdHBacUcrdHdGMVM2VDN3NlQyNDFuNTIzY3grTTEwY2FkL3B0ZWhYZmRY?=
 =?utf-8?B?azRQTGZERngxOU1FTW1zemZ1QXR1TE9zSEpmSEhxVTZJSURkL1RqQVFFU2ph?=
 =?utf-8?B?dU5IaVlyTFd6V25HZXZoYzgvZ2VUdnhRWUNmb3dHaU5iNGNiOVNIV2JPL0xO?=
 =?utf-8?B?eUdXTzFGNmZTczZCb1FaOGd2RjVSVUV5NGJEQnRrdU52ZURYNW1jNkhKclYy?=
 =?utf-8?B?bWw0VTN4T3hrY05vN0J0dFR0UGxpdTUrZSsyNHlhdkFBMVIwRUZpLzF2RVBp?=
 =?utf-8?B?OUs3aGRYZzVzMUFReUlSeWJ0ckNwYVBvekpER3JZeVcwYm9UMjRkSHZJZEZU?=
 =?utf-8?B?SmVXNFhOTXIyeElrZ1NSazM3KzFxS3BSdFdNSzV5Ri9ZNlZ6VkpWdmRORFht?=
 =?utf-8?B?L0VlODhieFcwYVU4ZGVKTGVuU21ucHRoeEdzdDlPeHYrSnlWL3RBTDJDUWF2?=
 =?utf-8?B?RDNuaklLOGgwTWU4NTlONXVtejUyaDVTVVJ3SS9DQm1reDZBdWRmNTBUN3hF?=
 =?utf-8?B?L2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31E7ADD368B73E4B8C02EEBA52F01804@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4147c3e9-1284-4d10-c0b3-08daf2f4c9b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 10:23:59.5755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XnwMNXzmvdFF6B0g8ePFFG6qNslBtd/RNJekxeOJXlk4m/wSJV09ExW+5QWi2/HJTaVA3CvG18NEiNohKddy/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDE2OjE3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEFmdGVyIHRoZSBnbG9iYWwg
S2V5SUQgaGFzIGJlZW4gY29uZmlndXJlZCBvbiBhbGwgcGFja2FnZXMsIGluaXRpYWxpemUNCj4g
PiBhbGwgVERNUnMgdG8gbWFrZSBhbGwgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucyB0aGF0IGFy
ZSBwYXNzZWQgdG8gdGhlDQo+ID4gVERYIG1vZHVsZSBiZWNvbWUgdXNhYmxlLg0KPiA+IA0KPiA+
IFRoaXMgaXMgdGhlIGxhc3Qgc3RlcCBvZiBpbml0aWFsaXppbmcgdGhlIFREWCBtb2R1bGUuDQo+
ID4gDQo+ID4gSW5pdGlhbGl6aW5nIGRpZmZlcmVudCBURE1ScyBjYW4gYmUgcGFyYWxsZWxpemVk
LiAgRm9yIG5vdyB0byBrZWVwIGl0DQo+ID4gc2ltcGxlLCBqdXN0IGluaXRpYWxpemUgYWxsIFRE
TVJzIG9uZSBieSBvbmUuICBJdCBjYW4gYmUgZW5oYW5jZWQgaW4gdGhlDQo+ID4gZnV0dXJlLg0K
PiANCj4gVGhlIGNoYW5nZWxvZyBwcm9iYWJseSBhbHNvIG5lZWRzIGEgbm90ZSBhYm91dCB0aGlz
IGJlaW5nIGEgbG9uZyBwcm9jZXNzDQo+IGFuZCBhbHNvIGF0IGxlYXN0IHRvdWNoaW5nIG9uICp3
aHkqIGl0IHRha2VzIHNvIGxvbmcuDQoNCldpbGwgYWRkLiAgSG93IGFib3V0Og0KDQoJSW5pdGlh
bGl6aW5nIFRETVJzIGNhbiBiZSB0aW1lIGNvbnN1bWluZyBvbiBsYXJnZSBtZW1vcnkgc3lzdGVt
cyBhcyBpdMKgDQoJaW52b2x2ZXMgaW5pdGlhbGl6aW5nIGFsbCBtZXRhZGF0YSBlbnRyaWVzIGZv
ciBhbGwgcGFnZXMgdGhhdCBjYW4gYmXCoA0KCXVzZWQgYnkgVERYIGd1ZXN0cy4NCg0KQW5kIHB1
dCBpdCBiZWZvcmUgIkluaXRpYWxpemluZyBkaWZmZXJlbnQgVERNUnMgY2FuIGJlIHBhcmFsbGVs
aXplZCAuLi4iPw0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBpbmRleCA0Yzc3OWU4NDEy
ZjEuLjhiNzMxNGYxOWRmMiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBAQCAtMTAw
Niw2ICsxMDA2LDU1IEBAIHN0YXRpYyBpbnQgY29uZmlnX2dsb2JhbF9rZXlpZCh2b2lkKQ0KPiA+
ICAJcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+ICANCj4gPiArc3RhdGljIGludCBpbml0X3RkbXIo
c3RydWN0IHRkbXJfaW5mbyAqdGRtcikNCj4gPiArew0KPiA+ICsJdTY0IG5leHQ7DQo+ID4gKw0K
PiA+ICsJLyoNCj4gPiArCSAqIEluaXRpYWxpemluZyBhIFRETVIgY2FuIGJlIHRpbWUgY29uc3Vt
aW5nLiAgVG8gYXZvaWQgbG9uZw0KPiA+ICsJICogU0VBTUNBTExzLCB0aGUgVERYIG1vZHVsZSBt
YXkgb25seSBpbml0aWFsaXplIGEgcGFydCBvZiB0aGUNCj4gPiArCSAqIFRETVIgaW4gZWFjaCBj
YWxsLg0KPiA+ICsJICovDQo+ID4gKwlkbyB7DQo+ID4gKwkJc3RydWN0IHRkeF9tb2R1bGVfb3V0
cHV0IG91dDsNCj4gPiArCQlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCQkvKiBBbGwgMCdzIGFyZSB1
bnVzZWQgcGFyYW1ldGVycywgdGhleSBtZWFuIG5vdGhpbmcuICovDQo+ID4gKwkJcmV0ID0gc2Vh
bWNhbGwoVERIX1NZU19URE1SX0lOSVQsIHRkbXItPmJhc2UsIDAsIDAsIDAsIE5VTEwsDQo+ID4g
KwkJCQkmb3V0KTsNCj4gPiArCQlpZiAocmV0KQ0KPiA+ICsJCQlyZXR1cm4gcmV0Ow0KPiA+ICsJ
CS8qDQo+ID4gKwkJICogUkRYIGNvbnRhaW5zICduZXh0LXRvLWluaXRpYWxpemUnIGFkZHJlc3Mg
aWYNCj4gPiArCQkgKiBUREguU1lTLlRETVIuSU5UIHN1Y2NlZWRlZC4NCj4gDQo+IFRoaXMgcmVh
ZHMgc3RyYW5nZWx5LiAgIlN1Y2Nlc3MiIHRvIG1lIHJlYWxseSBpcyBkaWZmZXJlbnQgZnJvbSAi
cGFydGlhbA0KPiBzdWNjZXNzIi4gIFN1cmUsIHBhcnRpYWwgc3VjY2VzcyBpcyBhbHNvIG5vdCBh
biBlcnJvciwgKmJ1dCogdGhpcyBjYW4gYmUNCj4gZXhwbGFpbmVkIGJldHRlci4gIEhvdyBhYm91
dDoNCj4gDQo+IAkJICogUkRYIGNvbnRhaW5zICduZXh0LXRvLWluaXRpYWxpemUnIGFkZHJlc3Mg
aWYNCj4gCQkgKiBUREguU1lTLlRETVIuSU5UIGRpZCBub3QgZnVsbHkgY29tcGxldGUgYW5kIHNo
b3VsZA0KPiAJCSAqIGJlIHJldHJpZWQuDQo+IA0KDQpXaWxsIGRvLg0KDQpbc25pcF0NCg0K
