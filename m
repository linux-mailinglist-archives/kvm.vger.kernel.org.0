Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF3D755A36
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 05:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjGQDwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 23:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGQDwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 23:52:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DB9BA;
        Sun, 16 Jul 2023 20:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689565942; x=1721101942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ucZNrv93s5fUa6TU/nON4YlBS2CciwXlMO+744COWK0=;
  b=VLiC1lAuG3xvXnf93FEeXCnRhsOJKDM/nzEgL1BX/gaHtDPwTi3jUqT0
   Cr5mobl+OqUfkPXXBcj/cL1UgnXrboqsM4NrAYEo0UnaR1nWB4m8b/AQa
   iZ3QQFY246Bd967Cl8LKkxijoyrtTbrEpOkRrG0miMX4KxqSJQi8Y7eb4
   dAyQYLmbXFToYC/vh3W1rmgro9cDsAsicLwkqfFSyDIjINMo0tgpG/dkC
   zDRnpK7/uSHUmOPFlg9GodMGIpoSETRImqPGg1/LThOYKqshvPoY5mvew
   Dmqsw/ixl2GTqjoou+HuhhX6PscT/C6Sk9gcSLngd5mVLJvvwDk+B3O/D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="346144364"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="346144364"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2023 20:52:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="1053748095"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="1053748095"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jul 2023 20:52:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 16 Jul 2023 20:52:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 16 Jul 2023 20:52:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 16 Jul 2023 20:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaFsoOq6G9qx6LCYnbUjMlbLUBQ5kmZU5a+pYe4ucIMmrWUlOTg/PvhlSfLrYeHaY0o14gcWagItf82Nf/hnlVkBemVxGBNUFq3WK1+tJVKZ9aR5R2jzWo7NA+cKBwgO4F98ac8TY3VMMfk9oj5xn80Chl5gymwF0ym3xq1pzSikwb5E19Q2a4aiVEG/wOVRB5vGYcHhahbhpMmMSTdYmgEiX6UtQv9GN2vbfbRo65locpksSLatrsuEnf+MhH+7Ql1pZK4dfqxIzgRkIe0UQGsntTcIoAV16s6921URKlSG1ccbGpbA/DoPdpZxK+Bw0S1ySHesLVTr2/wrTf7kBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucZNrv93s5fUa6TU/nON4YlBS2CciwXlMO+744COWK0=;
 b=V37SiJuPt1IghBh1Qd+a47QE1EVlTnFDy4Tz942tkXkT48pdA7838yZHQs1ViguJtKayEc9SCxOvJB6Q2M+y437KxYW1PS5MENvOtm9rbZrGmwB8BUyYyVN8bqVhxs2shoWrxLUa1P4+aDX9LDa7SLV/hLpfZZcjtIXNzCWBxgTnQ1Nk3hmogVPi5uByIvreAjygXxTL9BOJWNJC5PByJm/Ubzvq2fX85jHGXAaYowCMGWMOJlInBFUAz9FZq3em591aFAyyeCrgnzbxs1/DWWj09GJe2wOXU4tEKurTVeoIc9qpg5ejx9N5QMrQxDWdXWcT/NEU+B17iGxSgpINVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8341.namprd11.prod.outlook.com (2603:10b6:610:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 03:52:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 03:52:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Topic: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Index: AQHZtJ11LVNzaBLM3EiCxikVoFiXz6+2s2kAgABcqoCAAEG6AIAAChOAgABt6QCABZEdgA==
Date:   Mon, 17 Jul 2023 03:52:15 +0000
Message-ID: <cd612a6a626ea1e8966f16b2c66cb4d4f70e73bf.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
         <20230712221510.GG3894444@ls.amr.corp.intel.com>
         <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
         <20230713074204.GA3139243@hirez.programming.kicks-ass.net>
         <d4887818532e1716b5dd8a08819c656ab4e4c5bf.camel@intel.com>
         <ZLAPck1XKN7ko7vM@google.com>
In-Reply-To: <ZLAPck1XKN7ko7vM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8341:EE_
x-ms-office365-filtering-correlation-id: f4bd64c2-02a5-4909-7e49-08db86793602
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3oJTIWx8CwVKrSeSbulaKrhkGsp9ER7ZZVDMmB/lqyG1H9BdqRiD7yX5nlmotyHp6tXT46HhQQ004i1ecx8ndnWvfxv5g54bwQvtWw82bKZ3BFZngnxqUl1EuY8GNamKXB1qylxHYzJ2kWdjHbEZyAyc3FYRQAWLxLddWeeiFK58FjHmu8SdVqTT0geX+c7cHvf692IeQSeyOrn8ne22/AQzgRtTgKglhQ5VhA//NWheMinyZx2YQ2v6025WQK1CBAOZd7Zty+nDzZuvm2c72H6FhKLsrV26eU28tOUrKyamaZiaqFaA/3tMXobzDVYIr3vrd6QSeoWSgLsbUPldHPh8NV+woeTppCQJVVGuRmHHyt7RSspaHKlgxeA+jMuMN3UqPGtl59tYkHUEZelozVS7ZuywHLBoV49FgPRtGZwVI1GqsEyLYcpiHKhkQmwiIErx2ydkSRYGSYpa+kgf3MMOWC2PRqjyUPhSIRD8C1ELTwWdlPBgxRXT6rOh8yHtnhHGTCUBw3QZvPmLySZgZbtyHHRh1CXs6H7RmLiagpljLLFgaBf3AJZEdg6LsPMLyUs+FiRh83VUqrbDJO9/1amkoutfcMzwgOLLCDN1abiVuKLZJ4c6f6ThoNo6g4A3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199021)(6512007)(6506007)(26005)(91956017)(54906003)(122000001)(66556008)(66946007)(36756003)(76116006)(38100700002)(66476007)(38070700005)(7416002)(66446008)(64756008)(2906002)(5660300002)(316002)(8936002)(6916009)(41300700001)(8676002)(4326008)(86362001)(6486002)(71200400001)(478600001)(82960400001)(2616005)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUZSODVNSVNkRCs4a0FFWDU5azdZbVhQaWtQUG8rMSs0SmZndU5mSFlFdGJy?=
 =?utf-8?B?WnBWU080dDdlR0M5MitsS3BHakxndG1VbFdublpkbS9lRkl2MkEwc2NSYnhh?=
 =?utf-8?B?eUN0dGxoR3JDckp1Sk5mVktiOHN1Rm9udDdwbGd4R09wc2pETlJGbWs3OGdr?=
 =?utf-8?B?OUhpL1Rma1hCdEc2ckh3RTVCVXBSV25wM0FlYkNvUmloNVNGMmN5QzZySnBM?=
 =?utf-8?B?NzlMeUtJQUFjeVg0Skd4ZEpUcnpWbVNUQUhHbHpFYXd3dmZIVXptVDZwTnM3?=
 =?utf-8?B?ZTYreXdEYjZzeitReStuUEVHazNYYjhlUjU3Z3UraFV0Qy9DanZ3WFZyT05i?=
 =?utf-8?B?cUNMRUpLMnRxSTV4S2VncDBFSWduVmx0cENkeTMvSWMzRkdJMFFENm4rdUda?=
 =?utf-8?B?RGhxUmh1KzRsOExFazI2azVjNTNLQnRaRzdIaTQ2Ylk3dVdzOTI3Y2puaTBO?=
 =?utf-8?B?UjF6ZlVHS0hWd3J1c1NYbUh0alB3V2QyQ0lTVzU2OTZPRE9qWnlVeGk3NDVv?=
 =?utf-8?B?MTJ4Yks4b3lHWWE4cXlDSFhsb2FvLys0R1lyZnpXRFVpWjUrUUswNE5TTnpR?=
 =?utf-8?B?cE8xcjY4YU9SNVNOVUl1NmlSZldmTDlFTUk4TjBac0JnQ1ozeElsODJRcURh?=
 =?utf-8?B?R2lTT1EyQ0k2cktkYXZPYXdDK1pPajhHU0hEZ3RlWUVTOHByZHp3aHAyYkdm?=
 =?utf-8?B?K3Vjd056MjBQOWQwaGVVYVdDYVJpQXhXQ3BpUG5iWVlseXpTK01LN3h5QVZD?=
 =?utf-8?B?Yk5OQkFuMnJQSHFlSmJOY243QStqa0ZJaDhYS3l3YWVReFdPUnErTHZCSkRX?=
 =?utf-8?B?UFBZOWlhS3RVYUU0Rmp0NFJrTmNtaDZZUFJLR3IzZlo4VVRCQWVic1gyVUtv?=
 =?utf-8?B?MkNxMUJHbFBsZXhlTHJCTUhUbXZTT0x5RnZ4cmJQeUNPVVRtVkNLbmlaZlVX?=
 =?utf-8?B?b1U5bnMwYjBDUXg4YVZBQ3ZQZTdDbFgvREJCTGlCNTJubjduN3JPbEk1Q3lI?=
 =?utf-8?B?VzIyeTBCMTlySkJVL29GdVpaNDc2VjE1eHZ5SE9JT3MrVHd0WkVLc2Q2L0xw?=
 =?utf-8?B?K1ZMRlovSzhQQUdIU0RGTGZPSlVHVnp6SXExa0YwQmhJSW1yb3dGaVorNFBP?=
 =?utf-8?B?NjlRbDQ5V00rTmRIMFdvV0tRSWhNTjNUVm1hcUxOUEp0bWZ3U2NsTENWUEhV?=
 =?utf-8?B?OWNEd1c5YnZwemhya2YyR1NYSjBzNjg3Z0xMc2pZNWVNeThnbzNnbjV3MTJD?=
 =?utf-8?B?THRueHV0UXBCZURhTWxDbGcvd3RIVWlpaUFWdGU0bWFrMlQ3alhiSmFtamIv?=
 =?utf-8?B?TVFRYzZ2M1NZOWkvb3kvL1IrVm5MZDZJZmhJYjdBSjJhbHZWTEV3aEZuVXlw?=
 =?utf-8?B?cWp3Y3gyakxEZlBiallXMUZ4eUtxWWQwNitvSkxjZjhrTitFK1p1RzMzenlt?=
 =?utf-8?B?aXpVY2drT2xhaStXR1lBYS9CQzJxQW1FTmJodTBBSGNIc0VRa0xPcnJ0eVYr?=
 =?utf-8?B?T21zblFDZDAreTN3QW9SMUE4M1pyTC9kK3FHeTR6SGVYRjhwRUdNSkNzTG1V?=
 =?utf-8?B?NzNiN1ZPU0JDa0dMQUY2R09qOVJFbUhBUTVZYnNxS2lscXpOQkdabXpGVEQ5?=
 =?utf-8?B?RThScVpVL1RWU21hTExWRHlYeFJIUmxJdDNBWGJOWGd5OXpVS3o3Q0ZVdUdH?=
 =?utf-8?B?bXZEbGRWRGlKS29NM29XNCtIT2tKTU1GOEdITU5wTmlYLzZ0UzFiWXZXR1ho?=
 =?utf-8?B?VURJbXg2ZHBCYzdWbmszQ2xleUNSZ1ZWWlIxdFdrbTh0SFZpZFJZUDQ1N25p?=
 =?utf-8?B?MzAyYXFEbWtlSzFLSGM1YXgxRWNhSWpkNkZqUTNvMVpzUWVQWE56dFdpVWZZ?=
 =?utf-8?B?c3Nid3JtclpjbURiSmFRUXZ2WkNjVVJsb3FCRG9FSnRyeVNZNWFRSzM0VHhv?=
 =?utf-8?B?aGxsWjNROTBZRFJxZ1lOOHN0bFNMWDlPaGswLzVSalo3SXd4YnB6cnZZVmVN?=
 =?utf-8?B?Y2QwNmRSVktkUkFyY1dmMXBYQ2xMU0NLWDJjT29veDVacFFwNGNGclFkdUl5?=
 =?utf-8?B?MG04UVdyTlBRYUg5VzF4TnM1Y05zeDdPVjIxbHJjVmc2NG1tWWkrREdHWGZy?=
 =?utf-8?Q?6wnLSnOHHj5LKnm2PI1IQe5WN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3079CB30D413D243A4FFE0D7FC1D1337@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4bd64c2-02a5-4909-7e49-08db86793602
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 03:52:15.8196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /4LXQpSpo5S1H2ENiIzLv7DxSptoqUoTwVO93f6SRd3sNoCDGjszUueSikOA31alLnBwUoz96p0vWgMdCl3ijQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8341
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

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDA3OjUxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEp1bCAxMywgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyMy0wNy0xMyBhdCAwOTo0MiArMDIwMCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4g
PiBPbiBUaHUsIEp1bCAxMywgMjAyMyBhdCAwMzo0Njo1MkFNICswMDAwLCBIdWFuZywgS2FpIHdy
b3RlOg0KPiA+ID4gPiBPbiBXZWQsIDIwMjMtMDctMTIgYXQgMTU6MTUgLTA3MDAsIElzYWt1IFlh
bWFoYXRhIHdyb3RlOg0KPiA+ID4gPiA+ID4gVGhlIFNFQU1DQUxMIEFCSSBpcyB2ZXJ5IHNpbWls
YXIgdG8gdGhlIFREQ0FMTCBBQkkgYW5kIGxldmVyYWdlcyBtdWNoDQo+ID4gPiA+ID4gPiBURENB
TEwgaW5mcmFzdHJ1Y3R1cmUuw6/Cv8K9IFdpcmUgdXAgYmFzaWMgZnVuY3Rpb25zIHRvIG1ha2Ug
U0VBTUNBTExzIGZvcg0KPiA+ID4gPiA+ID4gdGhlIGJhc2ljIFREWCBzdXBwb3J0OiBfX3NlYW1j
YWxsKCksIF9fc2VhbWNhbGxfcmV0KCkgYW5kDQo+ID4gPiA+ID4gPiBfX3NlYW1jYWxsX3NhdmVk
X3JldCgpIHdoaWNoIGlzIGZvciBUREguVlAuRU5URVIgbGVhZiBmdW5jdGlvbi4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBIaS7Dr8K/wr0gX19zZWFtY2FsbF9zYXZlZF9yZXQoKSB1c2VzIHN0cnVj
dCB0ZHhfbW9kdWxlX2FyZyBhcyBpbnB1dCBhbmQgb3V0cHV0LsOvwr/CvSBGb3INCj4gPiA+ID4g
PiBLVk0gVERILlZQLkVOVEVSIGNhc2UsIHRob3NlIGFyZ3VtZW50cyBhcmUgYWxyZWFkeSBpbiB1
bnNpZ25lZCBsb25nDQo+ID4gPiA+ID4ga3ZtX3ZjcHVfYXJjaDo6cmVnc1tdLsOvwr/CvSBJdCdz
IHNpbGx5IHRvIG1vdmUgdGhvc2UgdmFsdWVzIHR3aWNlLsOvwr/CvSBGcm9tDQo+ID4gPiA+ID4g
a3ZtX3ZjcHVfYXJjaDo6cmVncyB0byB0ZHhfbW9kdWxlX2FyZ3Muw6/Cv8K9IEZyb20gdGR4X21v
ZHVsZV9hcmdzIHRvIHJlYWwgcmVnaXN0ZXJzLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IElmIFRE
SC5WUC5FTlRFUiBpcyB0aGUgb25seSB1c2VyIG9mIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCksIGNh
biB3ZSBtYWtlIGl0IHRvDQo+ID4gPiA+ID4gdGFrZSB1bnNpZ25lZCBsb25nIGt2bV92Y3B1X2Fy
Z2g6OnJlZ3NbTlJfVkNQVV9SRUdTXT/Dr8K/wr0gTWF5YmUgSSBjYW4gbWFrZSB0aGUNCj4gPiA+
ID4gPiBjaGFuZ2Ugd2l0aCBURFggS1ZNIHBhdGNoIHNlcmllcy4NCj4gPiA+ID4gDQo+ID4gPiA+
IFRoZSBhc3NlbWJseSBjb2RlIGFzc3VtZXMgdGhlIHNlY29uZCBhcmd1bWVudCBpcyBhIHBvaW50
ZXIgdG8gJ3N0cnVjdA0KPiA+ID4gPiB0ZHhfbW9kdWxlX2FyZ3MnLiAgSSBkb24ndCBrbm93IGhv
dyBjYW4gd2UgY2hhbmdlIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCkgdG8NCj4gPiA+ID4gYWNoaWV2
ZSB3aGF0IHlvdSBzYWlkLiAgV2UgbWlnaHQgY2hhbmdlIHRoZSBrdm1fdmNwdV9hcmdoOjpyZWdz
W05SX1ZDUFVfUkVHU10gdG8NCj4gPiA+ID4gbWF0Y2ggJ3N0cnVjdCB0ZHhfbW9kdWxlX2FyZ3Mn
J3MgbGF5b3V0IGFuZCBtYW51YWxseSBjb252ZXJ0IHBhcnQgb2YgInJlZ3MiIHRvDQo+ID4gPiA+
IHRoZSBzdHJ1Y3R1cmUgYW5kIHBhc3MgdG8gX19zZWFtY2FsbF9zYXZlZF9yZXQoKSwgYnV0IGl0
J3MgdG9vIGhhY2t5IEkgc3VwcG9zZS4NCj4gPiA+IA0KPiA+ID4gSSBzdXNwZWN0IHRoZSBrdm1f
dmNwdV9hcmNoOjpyZWdzIGxheW91dCBpcyBnaXZlbiBieSBoYXJkd2FyZTsgc28gdGhlDQo+ID4g
PiBvbmx5IG9wdGlvbiB3b3VsZCBiZSB0byBtYWtlIHRkeF9tb2R1bGVfYXJncyBtYXRjaCB0aGF0
LiBJdCdzIGEgc2xpZ2h0bHkNCj4gPiA+IHVuZm9ydHVuYXRlIGxheW91dCwgYnV0IG1laC4NCj4g
PiA+IA0KPiA+ID4gVGhlbiB5b3UgY2FuIHNpbXBseSBkbzoNCj4gPiA+IA0KPiA+ID4gCV9fc2Vh
bWNhbGxfc2F2ZWRfcmV0KGxlYWYsIChzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICopdmNwdS0+YXJj
aC0+cmVncyk7DQo+ID4gPiANCj4gPiA+IA0KPiA+IA0KPiA+IEkgZG9uJ3QgdGhpbmsgdGhlIGxh
eW91dCBtYXRjaGVzIGhhcmR3YXJlLCBlc3BlY2lhbGx5IEkgdGhpbmsgdGhlcmUncyBubw0KPiA+
ICJoYXJkd2FyZSBsYXlvdXQiIGZvciBHUFJzIHRoYXQgYXJlIGNvbmNlcm5lZCBoZXJlLiAgVGhl
eSBhcmUganVzdCBmb3IgS1ZNDQo+ID4gaXRzZWxmIHRvIHNhdmUgZ3Vlc3QncyByZWdpc3RlcnMg
d2hlbiB0aGUgZ3Vlc3QgZXhpdHMgdG8gS1ZNLCBzbyB0aGF0IEtWTSBjYW4NCj4gPiByZXN0b3Jl
IHRoZW0gd2hlbiByZXR1cm5pbmcgYmFjayB0byB0aGUgZ3Vlc3QuDQo+IA0KPiBrdm1fdmNwdV9h
cmNoOjpyZWdzIGRvZXMgZm9sbG93IHRoZSBoYXJkd2FyZS1kZWZpbmVkIGluZGljZXMsIGFuZCB0
aGF0J3MgcmVxdWlyZWQNCj4gZm9yIG15cmlhZCBlbXVsYXRpb24gZmxvd3MsIGUuZy4gc2F2aW5n
IEdQUnMgaW50byBTTVJBTSwgYW55d2hlcmUgS1ZNIGdldHMgYSBHUFINCj4gaW5kZXggZnJvbSBh
biBpbnN0cnVjdGlvbiBvcGNvZGUgb3Igdm1jcy5WTVhfSU5TVFJVQ1RJT05fSU5GTywgZXRjLg0K
DQpZZXMuICBTb3JyeSBJIG1pc3NlZCB0aGlzLiAgSSBmb3Jnb3QgeDg2IHVzZXMgImluZGV4IHJl
Z2lzdGVyIiBhbmQgZG9lcyBoYXZlIGENCiJoYXJkd2FyZSBsYXlvdXQiLg0KDQoJSW5kZXhSZWc6
DQoJMCA9IFJBWA0KCTEgPSBSQ1gNCgkyID0gUkRYDQoJMyA9IFJCWA0KCTQgPSBSU1ANCgk1ID0g
UkJQDQoJNiA9IFJTSQ0KCTcgPSBSREkNCgk44oCTMTUgcmVwcmVzZW50IFI44oCTUjE1LCByZXNw
ZWN0aXZlbHkuLi4NCg==
