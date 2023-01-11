Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A61766660A
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 23:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbjAKWLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 17:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbjAKWLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 17:11:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C87F68;
        Wed, 11 Jan 2023 14:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673475066; x=1705011066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EfwahbZQX91Op6/nqeceqlEgaAn7W7dlbcEOmAJhFHM=;
  b=kN22hU8TKxsKaTRX72LNutBirW0/eavYpCrWxTKihIrIbma5M4n9SBCy
   G9Gk+AyM+p9PSSGg3131OO3FSBBauzh6X8rV9Q621SlRHkzTAD/ifRHV4
   iB//cxL9oHCT+qdyg4UhWOxJRlms8qZYN/5a569SGZp5/QLUn01QHhRmr
   UoEHwu08pf6nD2Kn06hNv/XSb941kY02Ptkwu8fA10eyokEqjtt3FR9aO
   VnIbehfeCEJTAU8+imDngN9srCyvUSJmilw16cAY3xMLVx6i9r2aT8gJC
   hrQ5xFJO7AW+TiZ2tFgApekHQFwE8c59XmjBJ8gOTYgNCCGq1v3AfAG0i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="409788008"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="409788008"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:11:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="689912365"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="689912365"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 11 Jan 2023 14:11:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 14:11:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 14:11:01 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 14:11:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTe2ENRmNgn9Cee+kBPJFN0DbMGJhZoJDI2apF0dmOrLYRv+9j+IdoBAijYw+bgp4m+KSPy52ZSj6ufhBhqvJWqsjATmLgCZ7hWDqAhcVc4TjAAwkwwGk1dowSIv2EU/aAwJrXm4PfYxCjt2ri/qWBq6oC3zo+NqsQ6GNv44yI0MTBD8pgeGldqgi2Sj5hjcr5jiSohvZemm45Fn823AbJGABh7eEGGcGH3361esiIiSYFpiLjbUMF/y/4l7ZXfOAPbAtf7o5Ivp7fj/+SyhIJcCq2993Ev8xBA3zsVfFgwMv/ZINu5iwH0uQ1Z8qB4IM1CWlUEUcbN1Mq4LLrkrxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfwahbZQX91Op6/nqeceqlEgaAn7W7dlbcEOmAJhFHM=;
 b=Imy9lEHzth/4nb/oVKbwkb80rHXE77Ms5yRclC+ovhmIvi+ej1X6VzrbaevlQqBZWLlap0TK3FTtZBSBc4zZlLvzrX0amqV5AUosqsDjHKVHEueRTqvUbueTLCt7X5ioz7zv3ojoA8w/YhzDKxX8zxRzQEC7EGIkV4GB2r/N1ncSO34wasja3SKefOZGibyiWBqK97lAaM8z/9bLQW+iDxRSaaXVvN08s4LtpYBOA1wvNSeIL7nqLa9G0RVhuyWhYIVvn04W2OGUrheDw158ddhb8rcYMg7dzhAVRICho7tmmM6PQUO3tYhFnQD/ZxcjzeOuE93DVbj/OFTHFRGMMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CO1PR11MB5074.namprd11.prod.outlook.com (2603:10b6:303:97::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 22:10:56 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076%9]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 22:10:56 +0000
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Topic: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Index: AQHZC5gQ3FCTeDpWDE6DayveLyjo/66SH22AgATsd4CAAADVAIAAoeWAgABIIwCAAUktAIAAWQkAgABi/gA=
Date:   Wed, 11 Jan 2023 22:10:56 +0000
Message-ID: <7dba73c8900a47890452b53509d7088779415265.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
         <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
         <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
         <778a6c80-a955-620d-a82a-c2ca82f26363@intel.com>
         <24ea02aa4db7d470adeb7a64b7692d8bd5a428ca.camel@intel.com>
         <3bfe283e-6a90-54cb-1ba2-45ce6d022206@intel.com>
         <a7f8c807df3bbe1923f21e30817b23e785776260.camel@intel.com>
         <0293d72e-e03f-03d7-5982-29b4f11006a9@intel.com>
In-Reply-To: <0293d72e-e03f-03d7-5982-29b4f11006a9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|CO1PR11MB5074:EE_
x-ms-office365-filtering-correlation-id: e5026f69-5842-4190-ca58-08daf420b64f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GkA68JXMcRZ/Bbh8rR/pG84k3sVFhZsAqiZhOyPrDnj5p1yc3QYEC1VT2/OOmpxgEsLgQt6g16Yl22rsH5nIfQtEHUeCUCMBz7zZenOKvcTZD4qZVXwAF6sd0qeSQ0QIHNr6XGs7S1Uv9aEMVNtBv8HSnIM7GrRsj3EBFffq/YaxwoT6lkHHpMRvb3fAML8MbUGlnPep7YJX1eYlGUc3d+s9f/hPBsSSa6btI4HEBw7R96/62S7gnb3UiUMUmuw/ledA9QlwPf5IMftHTLsWLu3RPe8ZYr3hKIWKrYEO8yADlOxNjjmMa9h3eABlpIgsNKOhfL0MT6e3BCqu5eQK/ahYoIrJvmJKBNVW47KuCcYtJtsIo//VK1MHcX/e2iEfyYh4AXR4U3PdrwGBhFAVuc5ahPdobhoEbqVYQT34XwDXFbzmKsFs5GFRsLCf0DTKfZLcBqifqRGFItdoRUNxqCLWr1wUtuuUWOo67fXkQ3qsnJLzv0Sgw91atbHrM+hdI6yCmSvEj5ri/Jz+bzI6C0Qo6+Nf59fBg7rP14sj1v7EDKFbSDfZ9bI+xFz9MJMI7KLj0RPT/saZ1Yz87SD2NMDQq0JOK3dukI3foqBnJefuCs1K/8lyvtNDA+8RBUVGzQLf3QoZCifgekUngoxw1IZ1DbrEt4g+a4Y6Dtibnrsu0y+yjMZL/p4Q04W+k49eJ2k2Jxp4weIzk8O6tGasWFUkhCJmUO3eKV9INhkxLsk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199015)(36756003)(26005)(186003)(8936002)(53546011)(122000001)(6512007)(6486002)(6506007)(2616005)(66446008)(66556008)(66946007)(5660300002)(7416002)(66476007)(64756008)(316002)(71200400001)(4326008)(38070700005)(76116006)(41300700001)(38100700002)(478600001)(82960400001)(110136005)(8676002)(86362001)(54906003)(83380400001)(2906002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW9nTitOYStseUF5bTdoL00vRjZBeDc0SEV0SWxBQmhHaHVFbGx5ckhqWGJI?=
 =?utf-8?B?VlEwR3JTRjliUXAzOTRqMU8yVy9GTzR2RVl2ZHAzNHRPRDV3aWZQa3JuK1lN?=
 =?utf-8?B?ZHpUVFR2TmY3UE5vbSs1eG9zOVFzWWtobEZwNGdhMnovcEk4M0lUOEcwY05J?=
 =?utf-8?B?M0ZRN1BReVpSVDFNbWppM29FM1kxNXRmVlhyU0hhZDArR1BMTTVDNktkRDQ5?=
 =?utf-8?B?WmQ2aUZIQWMvaDVRUWNYNklBMlBoL3g5UVpXaGlXbTZjcDBrZUdsaTltUWFM?=
 =?utf-8?B?QkNTTWZQQXJwOUhFcW12MjlWeElKbCtCU1AzUXZzaHp3UnJMazNYNUJaL1pY?=
 =?utf-8?B?dXQvdHdzSi9xTnJIZzZWMHQzM1lwOW1TTUZ3VllNeVZHMVEyVlZxbm5UblhB?=
 =?utf-8?B?V3B0RDE5U2xUdm9CaGI1VWRXek0vUU1RWGVtTStVc0lVeFFDR3dvME5EclZZ?=
 =?utf-8?B?ZDlxaThpOFMvbGVPK0x1dWNmOFRtWkxNSjNBbi83OC8wQmFrWXZqc3ZNbTJX?=
 =?utf-8?B?YUpLVWRwWVNPalBZekE3emFQUm82eWxkWU14bFNMcmlRU3plcTdoL3NPM0py?=
 =?utf-8?B?V3NybzRVK3B0aHErWTJkNlRUQVZJVk85dnIwc0ZmY1pycXdGQlNjdTV0bmdz?=
 =?utf-8?B?VG9ueEVubUJheExoM1gwTmNnNFg1WDlMOEtldGp4ZEdFWWt1NEEybzNVZlRy?=
 =?utf-8?B?SEQ5aFBxOVBkTnh2T25ucWNRWEFWOXpaSm1talhIREhIRHhTdEROWVpzN2FH?=
 =?utf-8?B?ZVRkUWVqNW9hVHNFcWlHYWxCZlhTS0NEYVhDVk1hdUlzcmtKaFY4UE1MaUoy?=
 =?utf-8?B?Vldwa0JJcDUzdTgxeHROd00vczhYWjNWVzZnWnkvWWVnRkRXNG1YVU9wQ3F4?=
 =?utf-8?B?dVAwM0dzY251RWVOc041a3ZiVkpKdnZaSHhCODJ1RnIwb1l4RkxRQlZPREl3?=
 =?utf-8?B?Wm8zeE9iWkRCbElaKzNCcENoQnhiR3RIYWR1TkkrZG1BY0ZEWFBPMjdZSjFG?=
 =?utf-8?B?ZmhEUnl2MnRFaEsrd0l2dGxyUHhkNWxvOTdvMk9xM3ZqcTNwZzF0WVdHMmpP?=
 =?utf-8?B?Rmhkb0hpVUN1UjUya21LbitVd3JPQkNhU2VMNHFNaFVtT3VHWUtCZWp5UnZO?=
 =?utf-8?B?ZTNhNCt3RTFxajlvcVJHcUg2VTU0eVZtUkhYV2NyVUN4bmJqd3hRMkZlY3FQ?=
 =?utf-8?B?cXlHa2JIV2pFa25uVUtIN1BpMkdzV3EzQVR2K3NUUmxRUjNnbjk2cDZCQnM2?=
 =?utf-8?B?Y0dicHZKb2RNV2RSbUxIUFdEd2lod2dvWElFM3BxaXg3Zk9oZXFEZlMvdG84?=
 =?utf-8?B?K3drNXArSE9EU0FWcHpySkd6UEZjVlJqYjJFbVE1VFMzbTFhbUp0aEhUSUxK?=
 =?utf-8?B?dDJIWFlPbWdRZmM0VUhNaDFFSHNVN0VDanFvZjUrblh6czBsc0lQamFEZ1M0?=
 =?utf-8?B?bTk4RVYxa3l6WVF3RWFndDBmd1VaUG1ORTV1OEg5bEx3T0s3SUNJVXpxamht?=
 =?utf-8?B?R0NlT3pCZWVMUThYcEk3bEw2dTk2d0I5Z0lVUm5CczI2eGxNSjNHUTNyUmpq?=
 =?utf-8?B?bi9YaXdaWG5MeU1nNnAzTWl0MjcyWTI2QjdFTGUwVmg4d2N6L2pTUXRnZndP?=
 =?utf-8?B?VDROSGN1VTN5OGFhekM1NC9jMWhiMlh0R20rTTBneVdYSHorT0RSeEVFNTBF?=
 =?utf-8?B?SU5LYi96WEthQm1vN2NXNXh4Z04vOFhMZzhuREZpQytmNUdZaHFwZ3I0SERh?=
 =?utf-8?B?UHdzcUlNTW15RktEOWM2NGpPQU9EU1JHWTdvdzFIKzdkUDlSVk55dGNuYnJN?=
 =?utf-8?B?S0p5c0liT0dpUHk3SFdyR0lGOHpXeHdwZE5IeUFWVXRESGpyVUxldFpURDV4?=
 =?utf-8?B?V1BIeW5KNXVrS1ozS1lIUGd2TWtxY1VQMk5hVFdhTUFrZE5tL0o4Qy9nQmdD?=
 =?utf-8?B?RkZJclhCZm9lSk10QTlJSFY2SHhNamNpRTBMNngzUE9qSjYxY2kzUWRnZ3Qr?=
 =?utf-8?B?RjNmVmFxYUxKSnduZit0bDR1anRpc2hkc0xQdlVsdzFGN2JQY01URk52SnFM?=
 =?utf-8?B?YkpYZlpMVUxtbWpWak1teGEzeUs0L082c1F2YXZURDh5V0NVN0QzckE4STVI?=
 =?utf-8?B?SW9nWVFHeDdpMWtxd1dJMEROcUp6T0dNYUU0QU1zVTdCVksya0VYSlpXa3NY?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20FC4204E7892E419B49F4106D6A3A1B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5026f69-5842-4190-ca58-08daf420b64f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 22:10:56.1003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eCnvmYGeMW41Iw6MUUL7KomsuSZnhCQ7OywmTFKykN0k+iV/Q9W/XpD6XFN1W9ZyDfV/L6UpS7ZBjrYJX6jf3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5074
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAxLTExIGF0IDA4OjE2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS8xMS8yMyAwMjo1NywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjMtMDEt
MTAgYXQgMDc6MTkgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gT24gMS8xMC8yMyAw
MzowMSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCAyMDIzLTAxLTA5IGF0IDE3
OjIyIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+ID4gPiBPbiAxLzkvMjMgMTc6MTks
IEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+ID4gPiA+IEl0J3MgcHJvYmFibHkgYWxzbyB3b3J0
aCBub3RpbmcgKnNvbWV3aGVyZSogdGhhdCB0aGVyZSdzIGEgYmFsYW5jZSB0byBiZQ0KPiA+ID4g
PiA+ID4gPiBoYWQgYmV0d2VlbiBURE1ScyBhbmQgcmVzZXJ2ZWQgYXJlYXMuICBBIHN5c3RlbSB0
aGF0IGlzIHJ1bm5pbmcgb3V0IG9mDQo+ID4gPiA+ID4gPiA+IHJlc2VydmVkIGFyZWFzIGluIGEg
VERNUiBjb3VsZCBzcGxpdCBhIFRETVIgdG8gZ2V0IG1vcmUgcmVzZXJ2ZWQgYXJlYXMuDQo+ID4g
PiA+ID4gPiA+IEEgc3lzdGVtIHRoYXQgaGFzIHJ1biBvdXQgb2YgVERNUnMgY291bGQgcmVsYXRp
dmVseSBlYXNpbHkgY29hbGVzY2UgdHdvDQo+ID4gPiA+ID4gPiA+IGFkamFjZW50IFRETVJzIChi
ZWZvcmUgdGhlIFBBTVRzIGFyZSBhbGxvY2F0ZWQpIGFuZCB1c2UgYSByZXNlcnZlZCBhcmVhDQo+
ID4gPiA+ID4gPiA+IGlmIHRoZXJlIHdhcyBhIGdhcCBiZXR3ZWVuIHRoZW0uDQo+ID4gPiA+ID4g
PiBXZSBjYW4gYWRkIGFib3ZlIHRvIHRoZSBjaGFuZ2Vsb2cgb2YgdGhpcyBwYXRjaCwgb3IgdGhl
IHBhdGNoIDA5ICgieDg2L3ZpcnQvdGR4Og0KPiA+ID4gPiA+ID4gRmlsbCBvdXQgVERNUnMgdG8g
Y292ZXIgYWxsIFREWCBtZW1vcnkgcmVnaW9ucyIpLiAgVGhlIGxhdHRlciBwZXJoYXBzIGlzIGJl
dHRlcg0KPiA+ID4gPiA+ID4gc2luY2UgdGhhdCBwYXRjaCBpcyB0aGUgZmlyc3QgcGxhY2Ugd2hl
cmUgdGhlIGJhbGFuY2Ugb2YgVERNUnMgYW5kIHJlc2VydmVkDQo+ID4gPiA+ID4gPiBhcmVhcyBp
cyByZWxhdGVkLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBXaGF0IGlzIHlvdXIgc3VnZ2Vz
dGlvbj8NCj4gPiA+ID4gPiBKdXN0IHB1dCBpdCBjbG9zZSB0byB0aGUgY29kZSB0aGF0IGFjdHVh
bGx5IGhpdHMgdGhlIHByb2JsZW0gc28gdGhlDQo+ID4gPiA+ID4gcG90ZW50aWFsIHNvbHV0aW9u
IGlzIGNsb3NlIGF0IGhhbmQgdG8gd2hvZXZlciBoaXRzIHRoZSBwcm9ibGVtLg0KPiA+ID4gPiA+
IA0KPiA+ID4gPiBTb3JyeSB0byBkb3VibGUgY2hlY2s6IHRoZSBjb2RlIHdoaWNoIGhpdHMgdGhl
IHByb2JsZW0gaXMgdGhlICdpZiAoaWR4ID49DQo+ID4gPiA+IG1heF9yZXNlcnZlZF9wZXJfdGRt
ciknIGNoZWNrIGluIHRkbXJfYWRkX3JzdmRfYXJlYSgpLCBzbyBJIHRoaW5rIEkgY2FuIGFkZA0K
PiA+ID4gPiByaWdodCBiZWZvcmUgdGhpcyBjaGVjaz8NCj4gPiA+IA0KPiA+ID4gUGxlYXNlIGp1
c3QgaGFjayB0b2dldGhlciBob3cgeW91IHRoaW5rIGl0IHNob3VsZCBsb29rIGFuZCBlaXRoZXIg
cmVwbHkNCj4gPiA+IHdpdGggYW4gdXBkYXRlZCBwYXRjaCwgb3IgcGFzdGUgdGhlIHJlbGV2YW50
IGNvZGUgc25pcHBldCBpbiB5b3VyIHJlcGx5Lg0KPiA+ID4gIFRoYXQnbGwga2VlcCBtZSBmcm9t
IGhhdmluZyB0byBnbyBjaGFzZSB0aGlzIGNvZGUgYmFjayBkb3duLg0KPiA+ID4gDQo+ID4gDQo+
ID4gVGhhbmtzIGZvciB0aGUgdGlwLiAgSG93IGFib3V0IGJlbG93Pw0KPiA+IA0KPiA+IHN0YXRp
YyBpbnQgdGRtcl9hZGRfcnN2ZF9hcmVhKHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIsIGludCAqcF9p
ZHgsIHU2NCBhZGRyLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHU2NCBzaXpl
LCB1MTYgbWF4X3Jlc2VydmVkX3Blcl90ZG1yKQ0KPiA+IHsNCj4gPiAgICAgICAgIHN0cnVjdCB0
ZG1yX3Jlc2VydmVkX2FyZWEgKnJzdmRfYXJlYXMgPSB0ZG1yLT5yZXNlcnZlZF9hcmVhczsNCj4g
PiAgICAgICAgIGludCBpZHggPSAqcF9pZHg7DQo+ID4gDQo+ID4gICAgICAgICAvKiBSZXNlcnZl
ZCBhcmVhIG11c3QgYmUgNEsgYWxpZ25lZCBpbiBvZmZzZXQgYW5kIHNpemUgKi8NCj4gPiAgICAg
ICAgIGlmIChXQVJOX09OKGFkZHIgJiB+UEFHRV9NQVNLIHx8IHNpemUgJiB+UEFHRV9NQVNLKSkN
Cj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+ID4gDQo+ID4gICAgICAgICAv
Kg0KPiA+ICAgICAgICAgICogVGhlIFREWCBtb2R1bGUgc3VwcG9ydHMgb25seSBsaW1pdGVkIG51
bWJlciBvZiBURE1ScyBhbmQNCj4gPiAgICAgICAgICAqIGxpbWl0ZWQgbnVtYmVyIG9mIHJlc2Vy
dmVkIGFyZWFzIGZvciBlYWNoIFRETVIuICBUaGVyZSdzIGENCj4gPiAgICAgICAgICAqIGJhbGFu
Y2UgdG8gYmUgaGFkIGJldHdlZW4gVERNUnMgYTJuZCByZXNlcnZlZCBhcmVhcy4gIEEgc3lzdGVt
DQo+ID4gICAgICAgICAgKiB0aGF0IGlzIHJ1bm5pbmcgb3V0IG9mIHJlc2VydmVkIGFyZWFzIGlu
IGEgVERNUiBjb3VsZCBzcGxpdCBhDQo+ID4gICAgICAgICAgKiBURE1SIHRvIGdldCBtb3JlIHJl
c2VydmVkIGFyZWFzLiAgQSBzeXN0ZW0gdGhhdCBoYXMgcnVuIG91dA0KPiA+ICAgICAgICAgICog
b2YgVERNUnMgY291bGQgcmVsYXRpdmVseSBlYXNpbHkgY29hbGVzY2UgdHdvIGFkamFjZW50IFRE
TVJzDQo+ID4gICAgICAgICAgKiAoYmVmb3JlIHRoZSBQQU1UcyBhcmUgYWxsb2NhdGVkKSBhbmQg
dXNlIGEgcmVzZXJ2ZWQgYXJlYSBpZg0KPiA+ICAgICAgICAgICogdGhlcmUgd2FzIGEgZ2FwIGJl
dHdlZW4gdGhlbS4NCj4gPiAgICAgICAgICAqLw0KPiA+ICAgICAgICAgaWYgKGlkeCA+PSBtYXhf
cmVzZXJ2ZWRfcGVyX3RkbXIpIHsNCj4gPiAgICAgICAgICAgICAgICAgcHJfd2FybigidG9vIG1h
bnkgcmVzZXJ2ZWQgYXJlYXMgZm9yIFRETVIgWzB4JWxseCwgMHglbGx4KVxuIiwNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRkbXItPmJhc2UsIHRkbXJfZW5kKHRkbXIpKTsN
Cj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9TUEM7DQo+ID4gICAgICAgICB9DQo+IA0K
PiBUaGlzIGlzbid0IHJlYWxseSBjb252ZXJnaW5nIG9uIGEgc29sdXRpb24uICBBdCB0aGlzIHBv
aW50LCBJIGp1c3Qgc2VlDQo+IG15IHZlcmJhdGltIHRleHQgYmVpbmcgY29waWVkIGFuZCBwYXN0
ZWQgaW50byB0aGVzZSBmdW5jdGlvbnMgd2l0aG91dA0KPiByZWFsbHkgYW55dGhpbmcgYWRkaXRp
b25hbC4NCj4gDQo+IFRoaXMgY29tbWVudCwgZm9yIGluc3RhbmNlLCBqdXN0IGJsYXRoZXJzIGFi
b3V0IHdoYXQgY291bGQgYmUgZG9uZSBidXQNCj4gZG9lc24ndCBhY3R1YWxseSBleHBsYWluIHdo
YXQgaXQgaXMgZG9pbmcgaGVyZS4NCj4gDQo+IEJ1dCwgYWdhaW4sIHRoaXMgaXNuJ3QgY29udmVy
Z2luZy4gIEl0J3MganVzdCB0aHJhc2hpbmcgYW5kIG5vdCBnZXR0aW5nDQo+IGFueSBiZXR0ZXIu
ICBJIGd1ZXNzIEknbGwganVzdCBmaXggaXQgdXAgYmVzdCBJIGNhbiB3aGVuIEkgYXBwbHkgaXQu
DQoNCkFwcHJlY2lhdGUgeW91ciBoZWxwIQ0K
