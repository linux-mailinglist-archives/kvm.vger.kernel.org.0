Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38857516E1
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 05:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbjGMDrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 23:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjGMDq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 23:46:57 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9275B1986;
        Wed, 12 Jul 2023 20:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689220015; x=1720756015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7fsrZLZUyFY1fsS3ZuztrRjgoJOA5KGBAbJRuqqZhVU=;
  b=Aap8Vzs28EMrJa2yXQ9AXPSUFBVCPnmbcHEmbTFFJVwORwb+ZUrcArxa
   1kyl1fcEEYvZ6hK02gHYR0fawkIV0GykMNEkrxycXVDxyTLwK/ImW55sR
   jRlXCePGQWBIkLEuxtob3471j/HXyaq6QOCsJ04gaQL8HW+UOA5vyqTKc
   Z16ptlIaR4JXvOcRV+ncCsmQs1WX6xwDSXu6MCGTAJAFMBQ169e4fglFX
   vCAaCgsaat30gLvJq8FSCoH9jUpvvfmVgsHhCAUFSqL9EEIKhivh7J1l9
   dchHKJoOWINde9dqmvnxWUIE1mF8htXCKsvFDwVYbZc5UxqA5HJjdSiRF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="354993965"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="354993965"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 20:46:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="699099608"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="699099608"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 12 Jul 2023 20:46:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 20:46:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 12 Jul 2023 20:46:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 12 Jul 2023 20:46:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAqnmnK06GGr5nXjLMXAmkjXrjyjAOJEs6frGvpac/1G9ssBQAKopMxw7SvHTXmVwK5TFvu4ARQO6K2KcTIhnheLYbItI0RseV8zj4wCGvpnqk/P1N9k3AnnXQ27edy1T80yGRlEYc+ZlZv+xO1FWgg0RsehWXPGyzxGG/zEpow40WBZ1HqHvwfGAAUR5Em7R9RpitHxCdC5KNK5EvZ/qfwwnr78l788Iu9Nc/Zfxc7CibJJlqxfScw+qZRtr/e1N6/qnogzwF7IC2HuG241M9qy+g8kLsK81Nen8t81iKXFzavek9YFyeI1BMkGMpB1lzCONi6anJc1t30pgP2y7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fsrZLZUyFY1fsS3ZuztrRjgoJOA5KGBAbJRuqqZhVU=;
 b=euGTKVU0+L5YQzgCligtD/9gzm49JQQQsdD82Bp9BwnkiA0+8GUJHLMDiN14pHLJD6P7BV6HkPNcqg2z8M+1AzrC+YJzm3VA4PdSj2v4j1MSpLdSRboFCP+KWVe2XNy14a8+ceqGAMZzW7FxuyG/lnKwYRFSo4KXNOZxe9fBjj3T43I6FRnKdrYyJK/09NBq38Nm1t4o6EBQOvgc4MD+HNSPl6cqW+BLBq59VFTdJtlzXxw5BQZKDXtQywnLFyPFAK7IKTSukDhu36n+paB+2eOh5x3g2L+l2qdJHJP/W2JmIqo74RhE7ZTlB56oSwzk9kIrhAzDnnbi3jjfdIOltA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5917.namprd11.prod.outlook.com (2603:10b6:a03:42b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Thu, 13 Jul
 2023 03:46:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 03:46:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
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
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Topic: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Index: AQHZtJ11LVNzaBLM3EiCxikVoFiXz6+2s2kAgABcqoA=
Date:   Thu, 13 Jul 2023 03:46:52 +0000
Message-ID: <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
         <20230712221510.GG3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230712221510.GG3894444@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5917:EE_
x-ms-office365-filtering-correlation-id: 396f4579-5cf6-45a9-0d2f-08db8353cb6f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +NQfYN3CyRLWuCCAbLQ+SvL7tmxBmdQg3mEzj3PN198BogDIB314CJiNMFtVLlSnMqf/dY6tLjs/tqKaw1NVmvce5M304tt78t8WO5Mkg0bzH/821yjsgWnId6YBPU3JGnqwz8EwuQ2EMrti+yloZqzNVxroknLZzx2lnS6q+kXt5uGUXixtzS4/Kz49riDsj9HpDDA9l1PCKJLqs5RNu23pnofcxsQRtI+pp5UxFo4Sj6EETFtWxkRevkxwxLmm9VMAKSIgwaq2UX767+KwZ6jGO+HCsTG7zR/M77ubrkaM8Xtyfj58xl2wSb9u93FIyYBwqYw5G8GkufjXGfmmDGB8s1byZA/WIrfnVQTG2SB4OFAfEwr7HC/9f+G5xoX8UU+HUZtAi8gm1hJC4v+/xTtOxHp3ul8H8Feac9s7BOV5xaP4Zs0aKw94fc5VkFH/vQNLc7zEvbwNOtCAuLeoklh+q4ZtCMs54HcR8+st75H5EyakarI15Q69KvJmyZq3DBpeh5PM2TUD2M1X6QEFz/oHc6a6wNj3aYQvdXk4LGOgCnIK4dgACFPkEezuiDlKtwXCSLXI8gOBy0/Poy/lZB7x9jwhDSR4WETQIN+0nVM96jBrgKA1HSrx50D5XQLl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199021)(6486002)(6512007)(71200400001)(186003)(83380400001)(6506007)(36756003)(2616005)(86362001)(38070700005)(38100700002)(26005)(82960400001)(122000001)(76116006)(4326008)(66946007)(6916009)(66446008)(64756008)(66476007)(66556008)(2906002)(316002)(91956017)(7416002)(5660300002)(8936002)(41300700001)(54906003)(8676002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mk9rUHdNelRaUzZVVE1sZzlBdHc5VklRZlRTL3FyS3ZVdXRoZjBudlVHaDVz?=
 =?utf-8?B?bVFlNng1WkJjL2pGcGtnRUZvUEJtVDRLOHRvQisyYlVHRVVma1pudHJIMFJE?=
 =?utf-8?B?UnhNT2p4UGdLdVQvSFduS0lnWFV2ZVZmOFd5N3AxanZUdFlaNXRHUGYrNkNj?=
 =?utf-8?B?N0NXZWxNTUF1dktyb0lHRUpObUFMNkdIVlJ4NkRPV1g0L2g1MGh2OUMrdzZx?=
 =?utf-8?B?QzEvR21jaWk5M1ZCVEEvZE5XN2JvNWFvYlJlbEM4UEJVZkk1UGljbUpxTkha?=
 =?utf-8?B?Y3BlZ2lCdTdiL2F0TU85cjgzNmUzTnhGMmNMRHptZEFldmI5TmJqRk5JVUpv?=
 =?utf-8?B?Wi9BS2E1N2NqUnJraUhuejhRTkpkdW1IZFZvd05aOGZQeUs2VmZ5VGhRNTVz?=
 =?utf-8?B?S2hVRS9jQis2Um1DcXZYTDg3dDB3Y055cXg1Vjcwc3JUTHk4NTRSRDVVWm0w?=
 =?utf-8?B?OHE4WWpicVYzVDFpeVZzZkR0My9qZnFPRGVNQWh1c0h3dlRqYlZ0ZGRJNW1Y?=
 =?utf-8?B?TVA3QUF5Tk1KOFZKSElZeTcvR3BjMCt6WkhOS2FEWWpST2QyelU0Y3B1K2tJ?=
 =?utf-8?B?eVd6RnJUQzNiUGkwMHg3cGlJcTliamQrenRwMWZiOEdNbVdZNmQ0VFpGRnlG?=
 =?utf-8?B?MWNBb0tsQ24rTC9BRkluUHFjWTcvU1ZhWmhCK2tkdlZZL1ZNMWJreDV2NmE4?=
 =?utf-8?B?TE5XYkNEWklDaHVIbys0MGRCNnQ1MUpvd1JrY2JzeHhNQXM4WTRGWGpTWFdD?=
 =?utf-8?B?bGtxNVM2bkdCUHM4RnFJOHlUa3Z3MUhFb2J0TEwwRHptWjhiUzVtKytySWlP?=
 =?utf-8?B?OTkwZlBvVVExQWY2OUVCbWhtald6M0tmVlE4ZDg3dlRxQVhreU9yVmxmQzJ6?=
 =?utf-8?B?YjNCaVFhTVZBNDZia0N6K0RaWkZlYU9GVWJaaGtOakQ4bFdGUHRkTnVQbnJY?=
 =?utf-8?B?cFlYVjIvVStHSitpTWlFbHR3SVhtOUFVVFRwNytrcXE4d0ExbElFK1QzZVFJ?=
 =?utf-8?B?V2FJZ2FUZ1NjeXN0MEszVmswRnhoVHlrZWFhQVNhMEdiQncrMW1XNWREczc2?=
 =?utf-8?B?LzIxVmt3QnZQd1JETitic3FXMVpEc3JmZW9mSTlJRkhSSmhyczVEaG9jQkk5?=
 =?utf-8?B?QmdnbzYrRXY4dmtodkt3eU1sRnZtYURHRjdpUXFQOFB5U0VqSmFRWVdNOVZw?=
 =?utf-8?B?RkJ1cFRYQjd1VUtkaDE0TmY2SHc4bUdpTVFUNHM0Y1Z1Z2Jrd3FuczJvQTRs?=
 =?utf-8?B?NEFMalZFa09uZGRSTU50SlFIbkVmWGVwY0cwek5qclFtdTJYbUZqQlp5K3VI?=
 =?utf-8?B?Tm9tOVp1QjBONHIybG5qUFN2SzVMSE9ST2t6QkVVbENqaVVPbXp0eVpjZzFs?=
 =?utf-8?B?S05JRWZlYkZDUko0emVDMTB0SFp0MXpEVy9NS1VrVGNURjl6bERtN0IvUUg1?=
 =?utf-8?B?c0J2d1pGWEJGd3N3ZVNvdEhWZHY4QTc2NTJQZUVTZHJZTG8zQXNNZVVUZG5D?=
 =?utf-8?B?MWVSSmIxUlpjcEtjbXJMSGpYeXhiQmRRRDUxcEl3YXNsdU4yR2s4N2JSNEJ6?=
 =?utf-8?B?TEVqbnJza2J2SW9IcFNSNFZhY3UyQ2R3b2pCaU8vZW96Y1dXMlo5c0dnKzl2?=
 =?utf-8?B?VlJkMERCT21lTVNNdWovUDVKSzRXQXV0Qkg3bkgvSXpvdXU3SEUrUFJzTGda?=
 =?utf-8?B?RmEzK3ZVazlvcXFON2R4UUtwVGZtMlpQRGQ0YkV4ajBnUUhSaHZ2ZWtFVDNk?=
 =?utf-8?B?SVNoTGJHcyttV1JQcFR3QjJuVG5EVlhNc3gvWm9FazhDOG02d3dteDRUK29K?=
 =?utf-8?B?TDJ6WHhydVpuRUk0cVo1aFRmSUV3ZUg1eDhDYm1VQklmR0h6YTdUazV0UTdB?=
 =?utf-8?B?a0pXb2VTQTBSeDFxR2JMekZZSUEvSjlIaE1laWtWeUtkWlFxT01kZldjTjdX?=
 =?utf-8?B?ZFBtN0RqMUVoU2gwNU9saTd1OEgrblFuUERnTmVVYUQ0cm5jcjhTYWs1bmNT?=
 =?utf-8?B?QU1UMnFNOGFLSTRBMlVyWGtGeGRVRkd2QVBxNk1jUk5WQzFuTk5qYmp5YjFj?=
 =?utf-8?B?WGtsWTArWU5YZHFBeDdMczZ5SjJkOUpZTnlBSjdBVUx4T0hncVo1cnRldnBF?=
 =?utf-8?Q?fi5X8cnnJJcWPSSydogkrMH6s?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <361C2443CA738945870EC9455B9BEB46@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 396f4579-5cf6-45a9-0d2f-08db8353cb6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 03:46:52.1178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvGfn30mi3E3SCOU65nwqIV0gkbsJxfmfx/Klj77nkdRgFI/LYSbID/cWYMy2ArNi2KMVs2IZGqA3+Ceuin89g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5917
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTEyIGF0IDE1OjE1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBUaGUgU0VBTUNBTEwgQUJJIGlzIHZlcnkgc2ltaWxhciB0byB0aGUgVERDQUxMIEFCSSBh
bmQgbGV2ZXJhZ2VzIG11Y2gNCj4gPiBURENBTEwgaW5mcmFzdHJ1Y3R1cmUuwqAgV2lyZSB1cCBi
YXNpYyBmdW5jdGlvbnMgdG8gbWFrZSBTRUFNQ0FMTHMgZm9yDQo+ID4gdGhlIGJhc2ljIFREWCBz
dXBwb3J0OiBfX3NlYW1jYWxsKCksIF9fc2VhbWNhbGxfcmV0KCkgYW5kDQo+ID4gX19zZWFtY2Fs
bF9zYXZlZF9yZXQoKSB3aGljaCBpcyBmb3IgVERILlZQLkVOVEVSIGxlYWYgZnVuY3Rpb24uDQo+
IA0KPiBIaS7CoCBfX3NlYW1jYWxsX3NhdmVkX3JldCgpIHVzZXMgc3RydWN0IHRkeF9tb2R1bGVf
YXJnIGFzIGlucHV0IGFuZCBvdXRwdXQuwqAgRm9yDQo+IEtWTSBUREguVlAuRU5URVIgY2FzZSwg
dGhvc2UgYXJndW1lbnRzIGFyZSBhbHJlYWR5IGluIHVuc2lnbmVkIGxvbmcNCj4ga3ZtX3ZjcHVf
YXJjaDo6cmVnc1tdLsKgIEl0J3Mgc2lsbHkgdG8gbW92ZSB0aG9zZSB2YWx1ZXMgdHdpY2UuwqAg
RnJvbQ0KPiBrdm1fdmNwdV9hcmNoOjpyZWdzIHRvIHRkeF9tb2R1bGVfYXJncy7CoCBGcm9tIHRk
eF9tb2R1bGVfYXJncyB0byByZWFsIHJlZ2lzdGVycy4NCj4gDQo+IElmIFRESC5WUC5FTlRFUiBp
cyB0aGUgb25seSB1c2VyIG9mIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCksIGNhbiB3ZSBtYWtlIGl0
IHRvDQo+IHRha2UgdW5zaWduZWQgbG9uZyBrdm1fdmNwdV9hcmdoOjpyZWdzW05SX1ZDUFVfUkVH
U10/wqAgTWF5YmUgSSBjYW4gbWFrZSB0aGUNCj4gY2hhbmdlIHdpdGggVERYIEtWTSBwYXRjaCBz
ZXJpZXMuDQoNClRoZSBhc3NlbWJseSBjb2RlIGFzc3VtZXMgdGhlIHNlY29uZCBhcmd1bWVudCBp
cyBhIHBvaW50ZXIgdG8gJ3N0cnVjdA0KdGR4X21vZHVsZV9hcmdzJy4gIEkgZG9uJ3Qga25vdyBo
b3cgY2FuIHdlIGNoYW5nZSBfX3NlYW1jYWxsX3NhdmVkX3JldCgpIHRvDQphY2hpZXZlIHdoYXQg
eW91IHNhaWQuICBXZSBtaWdodCBjaGFuZ2UgdGhlIGt2bV92Y3B1X2FyZ2g6OnJlZ3NbTlJfVkNQ
VV9SRUdTXSB0bw0KbWF0Y2ggJ3N0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MnJ3MgbGF5b3V0IGFuZCBt
YW51YWxseSBjb252ZXJ0IHBhcnQgb2YgInJlZ3MiIHRvDQp0aGUgc3RydWN0dXJlIGFuZCBwYXNz
IHRvIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCksIGJ1dCBpdCdzIHRvbyBoYWNreSBJIHN1cHBvc2Uu
DQoNClRoaXMgd2FzIG9uZSBjb25jZXJuIHRoYXQgSSBtZW50aW9uZWQgVlAuRU5URVIgY2FuIGJl
IGltcGxlbWVudGVkIGJ5IEtWTSBpbiBpdHMNCm93biBhc3NlbWJseSBpbiB0aGUgVERYIGhvc3Qg
djEyIGRpc2N1c3Npb24uICBJIGtpbmRhIGFncmVlIHdlIHNob3VsZCBsZXZlcmFnZQ0KS1ZNJ3Mg
ZXhpc3Rpbmcga3ZtX3ZjcHVfYXJjaDo6cmVnc1tOUl9DUFVfUkVHU10gaW5mcmFzdHJ1Y3R1cmUg
dG8gbWluaW1pemUgdGhlDQpjb2RlIGNoYW5nZSB0byB0aGUgS1ZNJ3MgY29tbW9uIGluZnJhc3Ry
dWN0dXJlLiAgSWYgc28sIEkgZ3Vlc3Mgd2UgaGF2ZSB0byBjYXJyeQ0KdGhpcyBtZW1vcnkgY29w
eSBidXJkZW4gYmV0d2VlbiB0d28gc3RydWN0dXJlcy4NCg0KQnR3LCBJIGRvIGZpbmQgS1ZNJ3Mg
VlAuRU5URVIgY29kZSBpcyBhIGxpdHRsZSBiaXQgcmVkdW5kYW50IHRvIHRoZSBjb21tb24NClNF
QU1DQUxMIGFzc2VtYmx5LCB3aGljaCBpcyBhIGdvb2QgcmVhc29uIGZvciBLVk0gdG8gdXNlIF9f
c2VhbWNhbGwoKSB2YXJpYW50cw0KZm9yIFRESC5WUC5FTlRFUi4NCg0KU28gaXQncyBhIHRyYWRl
b2ZmIEkgdGhpbmsuDQoNCk9uIHRoZSBvdGhlciBoYW5kLCBnaXZlbiBDb0NvIFZNcyBub3JtYWxs
eSBkb24ndCBleHBvc2UgYWxsIEdQUnMgdG8gVk1NLCBpdCdzDQphbHNvIGRlYmF0YWJsZSB3aGV0
aGVyIHdlIHNob3VsZCBpbnZlbnQgYW5vdGhlciBpbmZyYXN0cnVjdHVyZSB0byB0aGUgS1ZNIGNv
ZGUNCnRvIGhhbmRsZSByZWdpc3RlciBhY2Nlc3Mgb2YgQ29DbyBWTXMgdG9vLCBlLmcuLCB3ZSBj
YW4gY2F0Y2ggYnVncyBlYXNpbHkgd2hlbg0KS1ZNIHRyaWVzIHRvIGFjY2VzcyB0aGUgcmVnaXN0
ZXJzIHRoYXQgaXQgc2hvdWxkbid0IGFjY2Vzcy4NCg0KSXQncyBiZXR0ZXIgS1ZNIG1haW50YWlu
ZXIgY2FuIHByb3ZpZGUgc29tZSBpbnB1dCBoZXJlLiA6KQ0K
