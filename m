Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32EC4E8FD0
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 10:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbiC1IMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 04:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbiC1IMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 04:12:33 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CC353704;
        Mon, 28 Mar 2022 01:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648455051; x=1679991051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9shgSJWAPbqLFAwuz4vMQxh1ZFkCTpAiH7fNrkzldvs=;
  b=lRZEh/zibPm2XfxOTTR/fbzUrb4xUkbPnAzo4vO7ApKHYFIn2k9knZU2
   4XAbvgHAuveMWKHwX91FQbs2gHqm4JbUhuuTbIDQ4PZaHcaFm85o2IWGM
   DK2nIPZWi/Xk/R9HTy/R/D6udUCtF/20xVF6ly7QRlnG5C9XXHWjm/5x4
   R1L0JvspcYp15GjMUkVsabkTq0tKnIGxtc60doDJEtD3LoWN1BUiwBXal
   gckJHLonYz5591pI2hZusNv0dBoK/Iv4AJCPDHkYOnT2pxr493v8UB/Nb
   ttrihXYYFMJrZ7jqiWrEj7VIqYGntEd4OrLi++8KRFge3OtBAeyMFl+d4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="241094463"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="241094463"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 01:10:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="502428629"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 28 Mar 2022 01:10:50 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 01:10:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 01:10:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 01:10:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZKV3gONGMGuleFBWqbGYCElCCSrQTvnWc1fbEv+rg1dpVGcJip2ELlHvXj8I14yPX3kII8jLHhw/YImwn/qszR7wIpP70xa2oPBz4+PzHtGTd3ND+tf7xfDwB438YAUp77/iny1JlHCAXzhRQwL01GP0D0otyndkhObVjb3mJe3Q6sbsfrUeTm3G7yCHZsGcS4T3jRv49y3ydLshQjVmzbTB2bFHdwyV64SUJD0oqMo+UK5dDGxuUrGBMYi/yDIlGTKCN8RqWzIgte3o7ozeve0jl77+oFdFWz7JQ6vPPrzKBNe9rRWujSS98oVJFiBjaB/kOWBiOW8b6Os5n4OVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9shgSJWAPbqLFAwuz4vMQxh1ZFkCTpAiH7fNrkzldvs=;
 b=bbSoqLXFQUpj/v1bZkHNXhw+z6GtvO+/Ml5pWD1+068TFXbiCPNIMurgW+pUklFTeqqapZcOhfTWvsi7FGD+TvQacjfFW7eN1HG3FHdIwQIqQu46kPaNY77y+tjXIhObCNnJzb6zwTqblhAYjtT3MuKWJqUHHwnxrMZB9mzv934aqYIXlO35CFDs7x1SBdqyNOympI495+m+64XKFGXNePkrx1oxqnveLnsH0+njRuKINnDU+6aozqZgdLqIxgu5yhdHL3VZlbr3fhEVjOLen8W59XX3o1vOLi/z8DDngW4+wObDhC30bfuy0dwP4rwnNej6vPEXELH3EjyfnzoiyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB2055.namprd11.prod.outlook.com (2603:10b6:903:23::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 08:10:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 08:10:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: RE: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
Thread-Topic: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
Thread-Index: AQHYNsguZd+eTSAGi0uYcpCMOLG73KzMW1/QgAfmQ4CAAETrsA==
Date:   Mon, 28 Mar 2022 08:10:47 +0000
Message-ID: <BN9PR11MB52765EE37C00F0FFA01447968C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <a258224c26b6a08400d9a8678f5d88f749afe51e.1647167475.git.kai.huang@intel.com>
         <BN9PR11MB527657C2AA8B9ACD94C9D5468C189@BN9PR11MB5276.namprd11.prod.outlook.com>
 <51982ec477e43c686c5c64731715fee528750d85.camel@intel.com>
In-Reply-To: <51982ec477e43c686c5c64731715fee528750d85.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48bcf784-7c75-4795-4784-08da1092770b
x-ms-traffictypediagnostic: CY4PR11MB2055:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <CY4PR11MB20554ABC9EB1C974037420D58C1D9@CY4PR11MB2055.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: psZifdPPvldqHxQTeEZ2paaSU9esysM64nA9yIAI0UN+BwyKA5exVPFLOughKq7ncjdxun35W63lXY6kswcAfKj82b2mVYkvCBhon5nuVBpab4pVOpbayik0xsktaIuocJZBXQyTC0QadAyDXMvIityCzzUbsdX/K9KC9+O3J0XyjWirEw5KU5fAFxYGQowI4qCbAc0OGkWK4nylxKxtsTHeSVkgVcvlhcmcysS6d+mCD5fnF6Rpy/bdgoKCZin7XwGBb21Z/V3Xnequhgx2NLcAPEIatUaYH4gFbc8Mepn1Hs7GhiBvDY7nObGQmavm7oOO7FaYfyZcw7u8Eh8trhplOkY5vKIlTFmAi0d9NFDN44I13U/NU5fkn0zKednUe3fow+faEo60nKwvCpPCf7yW2/NsdNKbH/wFHtwVpXhMHlIWzUHcWrnZZk2x0XfGZ3ehEmAvxks6cJ7Ky95VzRT9C1GFEa1P1Mz959rY+0pS2PzGES43w9UHWnaIsMiga0Vc3Q+Ra4Co2ainTi5KaKvqg1yNyKpKV3Fl8+4iSI/0e+S2Rs3MFojE66jfD/w5YIafaDorSHJQ8/TkgayIQogOjiG7mtEFuMon7gtqR+a7Olyt4pblzuRJmcFJHpgBVuED9fWSVDuKUFylDX+98B3nbNBdNf+oRnqC6Jll7Jgzijyivn6NjaQZWx15hqHpzhA7EaQY6vzrUeAUkzH4wQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(82960400001)(38070700005)(76116006)(55016003)(122000001)(86362001)(6506007)(7696005)(9686003)(316002)(66446008)(66476007)(64756008)(66556008)(66946007)(33656002)(508600001)(54906003)(110136005)(71200400001)(8676002)(2906002)(26005)(186003)(83380400001)(5660300002)(52536014)(4326008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXRuV1VVNlJadkVhRFFLYnVRTDNVUnRGQWRiZUNQSW9VL09NYkRhUU9QcGpY?=
 =?utf-8?B?T2NsYzhteDI2eU94VHArVTdyUThhdEYrQWxPSFl4Yk41cVppZGpRM0QzR2Zz?=
 =?utf-8?B?TDJpMWZvaFp6aDRreDdlUHNMdHQrcDZHSjVoVzRLaWFMR0ZEUVZCVVBHY09k?=
 =?utf-8?B?NE9aZzhTTlQvTk5YL1Nqci9GSVVWakx5cTRoQTIrb1VpRTlvbWZpRnZHZUZL?=
 =?utf-8?B?Y1Q1VC8wSVRvRlVzeE5MUDdkcDUwQlRRS0JSQWxCSG9Xam9YR093UDhFQUlt?=
 =?utf-8?B?MU4xaTR6SUNMQmtyNktvc3JPejcweXVvVjkwQ29ZZVRGRDdrSlVaK2MyQmRq?=
 =?utf-8?B?NFhIcUxOb1Z3VFFkbVgvMW16d0lRSFQ5NndmQzlhdTl4bUU1MC9oa283UEFC?=
 =?utf-8?B?UzNiWDF3bExZRytQdjZGMjdkSVZ4bVZpTU1XZXlEZjhub3JxOC8xaHR2OHBJ?=
 =?utf-8?B?YTVqL29kbTEzV0JHU0JDTW9aUmlKbUZoUlBQT093UVlONXF2c2FNdWM5eDF1?=
 =?utf-8?B?RitKU1NHSVI2Y0xzME1GY3BqbmN5V1ZFNGVJd251R0dQMTBsQ1I0UktkWlV1?=
 =?utf-8?B?dnIzYmc1eEFhSmRKSW5hSzN6WG9EZytvaXUvTzF0aW9BWmRhdHRaaTJaYnZV?=
 =?utf-8?B?WCthQ0FPc1JLS1Zvc1QzSDUrdEd6MFpQY1VadzRVU3ZzUVNPa3l2dmtLajVS?=
 =?utf-8?B?VFlXY1JsRzNZQ3FXamdTOUltK1hwUUtGNTR6TUlaR0M0eWZvYkZxaWhoY3U4?=
 =?utf-8?B?NUt3NUNKR2RNZXdDNlhxZGU4anVxYTVneXFmdFUva1hDMU1sSzhoSjlLODFs?=
 =?utf-8?B?a0IwL1c5NjN1aVJYclhZU0RERHlEMkowSTJhTXRMOUdvbjBpeEg3bURRRVRR?=
 =?utf-8?B?RHg2c0lLbFJwUEdtOE9DbHFuOGxTeUhQMzVUeVMwQXBtbGR6Z3lwbUo4TWhJ?=
 =?utf-8?B?Yms4OTliV2wxMnVwdlhUcXVUcFZZbm1HQUZOT2t0YmtPeDgwc29vdGtIa3hB?=
 =?utf-8?B?N0dJN3NqYkxQWjExR1lNdEd1TTJlSGNwdFEwanFHK0RJeitiOFdaWmhRSzhh?=
 =?utf-8?B?d3NiUE0yQTRmUmltb2FBNzRnMUdBdjR3MGdvYVFUeG5Ra3VtZjU3TUNvSzlO?=
 =?utf-8?B?VWw0QW42LzcwSXFNd2Jkb1NYKy91V1NON0lNMEduZm5qYkM0YTczci8zb2RC?=
 =?utf-8?B?M0tkTVJCeTJjcnZmV2thenl4M0NKc2JWNFdHMXd0UW5Ha2t6SDR0Z1VuN1Vq?=
 =?utf-8?B?NWpSd0VWaTR4UzFCLytrWUc1YWVvQ2xIa1VYYkdJam05UmFsTWtVMHFJOHo5?=
 =?utf-8?B?alBReTlwYW5OdVZYSE1tdnFrQTFmVnNCa2JSb3RaZnQ0TStQUVVDRnBxbklY?=
 =?utf-8?B?L3hBRUI0VFJEbVl2ajNnTTdLNWJuUGI5ZGpOejdpV2lYOU56bU5keWZpTU5r?=
 =?utf-8?B?WHFTc0toM2NPUVhYNWN2SlkyOUQzYjVoZzh5QVVRSit3ZDduckFLVi9jcUR4?=
 =?utf-8?B?V2RsNklDMm8vZG9xak1UejFmeEhQSVV5Rmg0cStvSDd2UXM3NHJPN0hxK3NQ?=
 =?utf-8?B?eWZOSG9VQlVPdTYrcU1iSHEwSGl6RHYrbTFrZEtCNE91U2tYcnNhSWh4amww?=
 =?utf-8?B?cWswNUxhdVRoT1RwNkJQZlBacjFEWTBJa2JYUDVJOVV3WG5YVndaOHhEZmI4?=
 =?utf-8?B?VDNON1ZZOHJpQjcwcUIyVnV0Um52Tm1DVjQ1SlRKWUxBYzFOS3JnSUNiaTBK?=
 =?utf-8?B?ZUE3OWtGNGtLNE1TN0lZelRFTCtyTndOZjFNOTdLZVBibisrdE05R0Y4SnVv?=
 =?utf-8?B?Z2owYWkvcnBtSUY3YUlxRHlqTGNJVzJubjZBVGx1QS9jSFpRSm9PNHYrYi80?=
 =?utf-8?B?SllycFpoNjBjdGlkaTZFRFpjUzRjbUpVVHppbDkvN0tIV1ZDSFAzSnhDdGNt?=
 =?utf-8?B?b055cnVtL1FLSVNsbFdUb0k4MFdjSzRpTWNMK0E2SkoySzBiSndab0JsSDln?=
 =?utf-8?B?Qm1UUk54cG1Oc2ZVWWdmMk9xL0dKdE9qYlJ0ZnlvSkRMVGRpYmlrT2RvODZE?=
 =?utf-8?B?YVo0SU9ONHE1VmNGV2lFM0dXS1Nzc1dJbDdRdkZnd2JQNG92OFdlQ2ljdGlT?=
 =?utf-8?B?NDU2eTI4V3FROXJsZGo2dGJnLzhSdld0R3UrZzRucVAwcFNoSzBTQkc0Z0E0?=
 =?utf-8?B?UFhRNEtqNk1DTWNMK25XT0l6STNKOTAzaXRIV1R6ZEd3UGtBZ3RweGRrR1Nu?=
 =?utf-8?B?U29pdis1emRLZTNZMTF6dFBWdlBqTjIrYVVjMnhGSzJQTy9rek56dVFYRERn?=
 =?utf-8?B?d2ZpbVJvdGZCaGo3emFpd3pqQTR5ZzFQUC9BV2RGcjRrZUd0RnZWdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48bcf784-7c75-4795-4784-08da1092770b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 08:10:47.2813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oKjJJji6Fnw9D44Mqq92MKHVyWClZwpn1+G+V4NuXezzYmGAmnGoypqmZLtuTTgRw5pMzTayE70+9zt4/pixKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB2055
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXks
IE1hcmNoIDI4LCAyMDIyIDExOjU1IEFNDQo+IA0KPiBPbiBXZWQsIDIwMjItMDMtMjMgYXQgMTY6
MjEgKzEzMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogS2FpIEh1YW5nIDxrYWku
aHVhbmdAaW50ZWwuY29tPg0KPiA+ID4gU2VudDogU3VuZGF5LCBNYXJjaCAxMywgMjAyMiA2OjUw
IFBNDQo+ID4gPg0KPiA+ID4gQEAgLTcxNSw2ICs3MTYsOCBAQCBzdGF0aWMgdm9pZCBpbml0X2lu
dGVsKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykNCj4gPiA+IMKgwqDCoMKgwqDCoGlmIChjcHVfaGFz
KGMsIFg4Nl9GRUFUVVJFX1RNRSkpDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ZGV0ZWN0X3RtZShjKTsNCj4gPiA+DQo+ID4gPiArICAgICB0ZHhfZGV0ZWN0X2NwdShjKTsNCj4g
PiA+ICsNCj4gPg0KPiA+IFREWCBpcyBub3QgcmVwb3J0ZWQgYXMgYSB4ODYgZmVhdHVyZS4gYW5k
IHRoZSBtYWpvcml0eSBvZiBkZXRlY3Rpb24NCj4gPiBhbmQgaW5pdGlhbGl6YXRpb24gaGF2ZSBi
ZWVuIGNvbmR1Y3RlZCBvbiBkZW1hbmQgaW4gdGhpcyBzZXJpZXMNCj4gPiAoYXMgZXhwbGFpbmVk
IGluIHBhdGNoMDQpLiBXaHkgaXMgU0VBTSAoYW5kIGxhdHRlciBrZXlpZCkgc28gZGlmZmVyZW50
DQo+ID4gdG8gYmUgZGV0ZWN0ZWQgYXQgZWFybHkgYm9vdCBwaGFzZT8NCj4gPg0KPiA+IFRoYW5r
cw0KPiA+IEtldmluDQo+IA0KPiBIaSBLZXZpbiwNCj4gDQo+IFNvcnJ5IGZvciBsYXRlIHJlcGx5
LiAgSSB3YXMgb3V0IGxhc3Qgd2Vlay4NCj4gDQo+IFNFQU1SUiBhbmQgVERYIEtleUlEcyBhcmUg
Y29uZmlndXJlZCBieSBCSU9TIGFuZCB0aGV5IGFyZSBzdGF0aWMgZHVyaW5nDQo+IG1hY2hpbmUn
cyBydW50aW1lLiAgT24gdGhlIG90aGVyIGhhbmQsIFREWCBtb2R1bGUgY2FuIGJlIHVwZGF0ZWQg
YW5kDQo+IHJlaW5pdGlhbGl6ZWQgYXQgcnVudGltZSAobm90IHN1cHBvcnRlZCBpbiB0aGlzIHNl
cmllcyBidXQgd2lsbCBiZSBzdXBwb3J0ZWQgaW4NCj4gdGhlIGZ1dHVyZSkuICBUaGVvcmV0aWNh
bGx5LCBldmVuIFAtU0VBTUxEUiBjYW4gYmUgdXBkYXRlZCBhdCBydW50aW1lDQo+IChhbHRob3Vn
aA0KPiBJIHRoaW5rIHVubGlrZWx5IHRvIGJlIHN1cHBvcnRlZCBpbiBMaW51eCkuICBUaGVyZWZv
cmUgSSB0aGluayBkZXRlY3RpbmcNCj4gU0VBTVJSDQo+IGFuZCBURFggS2V5SURzIGF0IGJvb3Qg
Zml0cyBiZXR0ZXIuDQoNCklmIHRob3NlIGluZm8gYXJlIHN0YXRpYyBpdCdzIHBlcmZlY3RseSBm
aW5lIHRvIGRldGVjdCB0aGVtIHVudGlsIHRoZXkgYXJlDQpyZXF1aXJlZC4uLiBhbmQgZm9sbG93
aW5nIGFyZSBub3Qgc29saWQgY2FzZXMgKGUuZy4ganVzdCBleHBvc2luZyBTRUFNDQphbG9uZSBk
b2Vzbid0IHRlbGwgdGhlIGF2YWlsYWJpbGl0eSBvZiBURFgpIGJ1dCBsZXQncyBhbHNvIGhlYXIg
dGhlIG9waW5pb25zDQpmcm9tIG90aGVycy4NCg0KPiANCj4gSXQgaXMgYWxzbyBtb3JlIGZsZXhp
YmxlIGZyb20gc29tZSBvdGhlciBwZXJzcGVjdGl2ZXMgSSB0aGluazogMSkgVGhlcmUgd2FzIGEN
Cj4gcmVxdWVzdCB0byBhZGQgWDg2X0ZFQVRVUkVfU0VBTSBiaXQgYW5kIGV4cG9zZSBpdCB0byAv
cHJvYy9jcHVpbmZvLiBJDQo+IGRpZG4ndCBhZGQNCj4gaXQgYmVjYXVzZSBJIGRpZG4ndCB0aGlu
ayB0aGUgdXNlIGNhc2Ugd2FzIHNvbGlkLiAgQnV0IGluIGNhc2Ugc29tZW9uZSBoYXMNCj4gc29t
ZQ0KPiB1c2UgY2FzZSBpbiB0aGUgZnV0dXJlIHdlIGNhbiBhZGQgaXQsIGFuZCBkZXRlY3Rpbmcg
U0VBTVJSIGR1cmluZyBib290IGZpdHMNCj4gdGhpcw0KPiBtb3JlLiAyKSBUaGVyZSB3YXMgYSBy
ZXF1ZXN0IHRvIGV4cG9zZSBURFggS2V5SUQgaW5mbyB2aWEgc3lzZnMgc28gdXNlcnNwYWNlDQo+
IGNhbg0KPiBrbm93IGhvdyBtYW55IFREcyBjYW4gYmUgY3JlYXRlZC4gIEl0J3Mgbm90IGRvbmUg
aW4gdGhpcyBzZXJpZXMgYnV0IGl0IHdpbGwgYmUNCj4gZG9uZSBhdCBzb21lIHRpbWUgaW4gdGhl
IGZ1dHVyZS4gRGV0ZWN0aW5nIEtleUlEcyBhdCBib290IGFsbG93cyB0aGlzIGluZm8NCj4gYmVp
bmcNCj4gYWJsZSB0byBiZSBleHBvc2VkIHZpYSBzeXNmcyBhdCBlYXJseSBzdGFnZSwgcHJvdmlk
aW5nIG1vcmUgZmxleGliaWxpdHkgdG8NCj4gdXNlcnNwYWNlLg0KPiANCj4gQXQgbGFzdCwgY3Vy
cmVudGx5IGluIHRoaXMgc2VyaWVzIHRoZSBwYXRjaCB0byBoYW5kbGUga2V4ZWMgY2hlY2tzIHdo
ZXRoZXINCj4gU0VBTVJSIGFuZCBURFggS2V5SURzIGFyZSBlbmFibGVkIGFuZCB0aGVuIGZsdXNo
IGNhY2hlIChvZiBjb3Vyc2UgdGhpcyBpcw0KPiBvcGVuDQo+IHRvIGRpc2N1c3Npb24pLiAgRGV0
ZWN0aW5nIHRoZW0gYXQgYm9vdCBmaXRzIGJldHRlciBJIHRoaW5rLg0KPiANCj4gLS0NCj4gVGhh
bmtzLA0KPiAtS2FpDQo+IA0KDQo=
