Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC827479B2
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 23:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjGDVud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 17:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjGDVub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 17:50:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EDA10CF;
        Tue,  4 Jul 2023 14:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688507428; x=1720043428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JGyG1Iv2kafHdx6F+vAxq1frY+rST7/Iaw5IMRVnMQY=;
  b=ccp5CBjOnyyDEoXDPJRcgPB8aqiE+o+i7jFxY+RZ9a1gYnPpih8ajVzl
   E8U0A8znkFGJbFF7KY3v8vH5cJ26Zagm8M5YIStF2iibOdXRjqtEJl/Sz
   g+DwtMo8iPuCSTeXIXXGTuYlHKT2jsa0e3gtpve8bbxihp/pGGNBNPZ7Z
   cnytCiu1bfMCInHx0YeYy7l2XrUoUbzKOihmLO1UGhDyWgreFLrKSUK9a
   DLNetM4ud1QJ8G8aaLbfpOW/Tb7ULuTVhcx+DqC+ZxYUwZGG5jmu+nvh1
   lOUUe5gGmIV09gCG1KTEBbgNnp/BFwLwmS1QoKYQya9WHZ8tjMphS12TX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="426879086"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="426879086"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 14:50:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="784315304"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="784315304"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jul 2023 14:50:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 4 Jul 2023 14:50:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 4 Jul 2023 14:50:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 4 Jul 2023 14:50:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0iOhunaogm9ORmwZtNcDUd076Wb+Bcr5vkQ26GzRXFqLTXeY+IOCbx3uaSWdpOdfyxIE6R8bYY0ZjjhjEGLamYV4X3GGBAaMxz3emzMWTTE6fr9OYtk4MagjAt60CbMDvxxohMmNSW7wXVF00vzo73YxkkJFQ+wP1KxBumXwVwlGbXLjwERtYO/rDQvEHkAK3qkE1BobUd0k9PoJS0BxxXe/zziNn251ukukZbv/gPQro0nuIlfjMP5SXxEiurjh9OSbjFgLI/j8Q6I0Km14uL9mHO9LqrLj3RNYq87/qTRzjRG4xTYaOWCfVFPbPu0DHXrildDpg5ZvTxAPUvJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGyG1Iv2kafHdx6F+vAxq1frY+rST7/Iaw5IMRVnMQY=;
 b=HqKjF9V0/8JPJyIl/oD59nIdO74Nd8+U2R5Zc2aCdRLivgTtXzvTrrgIO+g4dbQPFEiLArA67PXAJvPKvPQa4JnZuzWpaMIzECgIHhXIeDeplojXO8PJZqee8dCkBV78bdwgVfSiouD1wsrq8iEVw6vuRjBaoEOq2YWJ6zKNy1uckIWnEY5JUlQ/jOi45rHZ5vfVTvF5ZveOhYg7+XdBqpuqgA/IfdGJg6b0A8ffCppiSLgN0uZ/pX2yk6Pw3orNntC1EjCQHvZr5Ga43p8p5i/N3N/1qSCuqcVw59X5f3CXMYQpxlzXwQax05BD7SW41z/r4i6lVtJPWgeb385zsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5218.namprd11.prod.outlook.com (2603:10b6:610:e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Tue, 4 Jul
 2023 21:50:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6565.016; Tue, 4 Jul 2023
 21:50:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+gNU2AgAC2WwCAAi3CgIAACCuAgACP2QCAAAnAAIAAJwgAgAX+6gCAAFGCAA==
Date:   Tue, 4 Jul 2023 21:50:22 +0000
Message-ID: <0bd5a2f95a0f309ff35d511ce832c5f11abf6013.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
         <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
         <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
         <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
         <20230630183020.GA4253@hirez.programming.kicks-ass.net>
         <20230630190514.GH3436214@ls.amr.corp.intel.com>
         <ZJ9IKALhz1Q6ogu1@google.com>
         <20230704165836.GB462772@hirez.programming.kicks-ass.net>
In-Reply-To: <20230704165836.GB462772@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5218:EE_
x-ms-office365-filtering-correlation-id: f536af21-301f-4af6-7c07-08db7cd8ab26
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /RIxXm1pnOg50Fe4d83IusSCai8JqkygjZ9GH8qSrz8O3UFLG8G2lsUs6uvuj2YqiDt4Q+umN1KKRrYw1spRqnSBTVgl+CTbmfKoUuh0vF8di33ujG7P/Xh7O1kE6S5MnjeYUq6xQ+/HfZyCrlDAwra9xvHJ4xVjHjx05GwabQXFbtusA5iILJVwJ8tVVvCnEhiGe786fFTVayfE/35xF19Eh737Ee3BpL/mUPDfu/xLDYbM498pG1AVgQzPmmh55ltwB+IYl1weaD3YxEJkcBJwrVtXTo5pzMa3fQDooqEoIb22DDxUKCzZregKMD9KSX23DDZoks25/NvPPUaOTAwqKlMRALoWqMClJ1tkEAdsFJa8dOasJX0VgSI7+4YmCCpjQDI6ow0Fjl+DOKU2pat/I5oSZDtwf8aL6TTEb4eZBaAeCOykRip2q6b7opTUOc1WpEwkHx3FSRkqDSR9GtpX7jxpQLBlZETX/EwZZO8ViALKTlBMtwYZU/hIleRIYAViL5yKVluj5343i93nFNCMMVpYz4nvxo9OUnlKs94aAzSqu5ePj682e/jn29hhVOFURousvw7+qyk5gNoJuj4kxyc2UYj5nF5t520VPeUPCj2B/+4qeO2p0WrJvfzI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(38070700005)(2906002)(41300700001)(7416002)(5660300002)(8936002)(8676002)(36756003)(86362001)(186003)(2616005)(478600001)(26005)(6512007)(6506007)(71200400001)(82960400001)(6486002)(76116006)(91956017)(122000001)(316002)(66446008)(4326008)(64756008)(66476007)(66556008)(66946007)(54906003)(38100700002)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWlIUmk1a0pxL2RXS2tBeW5PTTJUVnRSY3JRZnpkWnQrV0JRY29LOERrOEVn?=
 =?utf-8?B?Zi9NN0ZvZGx5enRwZWdKNXQ3bXduZXFodm1VYnVpc3BFRkVUUnRVbFM1QnIz?=
 =?utf-8?B?MUJ6ZlgxZXgwTWRLZ3djeFJDTlROaXBSekduZ0dGSjgrZXhQWUNXL3Z5L2Zl?=
 =?utf-8?B?VlpyNTd2ZEZ3dU91Yk1CWTUyend3ZUZHelBjOVdMWkRhUmxUWExvR3BMRlNO?=
 =?utf-8?B?ZFB1Qzl1WlE3VitrSFpISjJRaVRkOXdaYnVxbU5HZXd0RlFqbU5kZ1JMMDg3?=
 =?utf-8?B?Z3krWFRQd25NbmEvMTdBRWdMVHNCWkNseGMwdElwby9XZEkyODc5OUFHYll4?=
 =?utf-8?B?ZzlYL1dDbk4yOFdPSVJIODdubEI0SWNnd1lvd2NGdDgwcmxLdVJqNmRuV3Zi?=
 =?utf-8?B?NmVtaGxRM2JhbEdFYXJqVW9MS0syaEZ5dnN3RENkcHpBNUxVR1EycjNoMDY5?=
 =?utf-8?B?NjVxZ1ZWcVFyRk53M0pESWI1cFc0OEhXWGpmTmV6NjJubW9jZmZwOWVsRGo1?=
 =?utf-8?B?bDhuaUhTYW9aYVd1bVZZeFBtdVQvMWc0K0RoOUtHZk1XR2VkOXQ1ZEJURjRW?=
 =?utf-8?B?VzExcUdaY2lKaEdHRjZORE1ySGpTM1lBQVh6UXZLVmVlRS9nR1IwU3N6Z0VK?=
 =?utf-8?B?VFhsYmRHNjdXQjZ6cGlsaWFXelZ4TDVQRmVJVnI2ek5La085dDFjU2dldjlx?=
 =?utf-8?B?Mmx5RlF1eFh2TTVNRm45ckFzOXU5UWV4alM4aFBZek9HMitpRVpZTmdieWRT?=
 =?utf-8?B?d2ZNTnRqeHZqOEdJUytncEFSdkpNVWRFeVMrTWxhQVdFRHlSQWg3R2N4ckw1?=
 =?utf-8?B?dmttM29DNG1PYkF4L0UrUFFsT1cvRjdyZUJZNFlSRC9kVWRWYUE1SjlKdEor?=
 =?utf-8?B?WFBlNVBvRytTeEhJNnYwczNkalZITThDM0tSOWpFRWRyY3U1cndKbE5iZ1lG?=
 =?utf-8?B?Tk85NlRUOTBlVFg1TDB1Yk5LaG11L1o4NkxyVTF6OFl3azNBcmNRQXcrVVhm?=
 =?utf-8?B?TUpYRE5KMzB6QmMzajQ5cG1tY1djK1oxenNHWCtJaDdaWHdwSnJCNUVKSHNB?=
 =?utf-8?B?ajBzaGVjWEdubHJNYTRjTUtVOStFbXFTaTVHb2lWVlJTMVBpMGw3emNTdDhu?=
 =?utf-8?B?OUhsemtDU0VFOWNaYmt6R2hSN1lySDFaa3A2eGJEMzkzL2l0c1lkcWF1SVpy?=
 =?utf-8?B?NEJKdjJWNU5JSjcrWVlQWDBKSmFIaUtKekJtc0hFaUM5Qk42YWNzTEZEYkxQ?=
 =?utf-8?B?WGllbnd5RDRmOXo5UzVKM1h0RTd2LzR3bkRTNUEySEV0cHNuVEZabEFZa3dZ?=
 =?utf-8?B?Uk5EejBUSjQ1QzBpOWJDMExSUmNvNVRVR09VYmVsTU1RN0ZlZmFZeXJlY2tn?=
 =?utf-8?B?YnpjcjNqRDNrZWpidzdWTFY3Q1RrRlFLc0VGVmFZblp2SWRIN0xEVzA5WmxR?=
 =?utf-8?B?cVlCT3NCWTB6T0Fha3FKV2k5VWlkMkxNNVNoR3F0L0FuTnYwQXpUT3BXYXF3?=
 =?utf-8?B?MFJXN2YwUXFOU2xUOHkrRmFuWExic2xRMlNNUmpoTGQ4NjV1L0g0QmJpT3pw?=
 =?utf-8?B?S3VrSTRoQ0F1b1pBT1J3Q25OR3FZWXI3U2ppbHM3dSt5NFlWcWNRclNSK0xZ?=
 =?utf-8?B?MlF0YUZieEZXZ3FWbUhWVGlPVUZzOGhNa3FObDdaV0oyMTFHSlVpbXVndDdO?=
 =?utf-8?B?aGdkaEtJTUc5SkVTWUxDRjFxM3pteFpHNnhjc1FjcmdIaEMvMjFoYnk0VDRz?=
 =?utf-8?B?bE1xSGRsTzR0TitHTitSNEVNYzM2RnRUOUxlckJKdlg2WFRuL2twSzg5c092?=
 =?utf-8?B?b204OHRQT2tZT2pwRGdqd2ErRUJhWTJkMFIrYnU3c2s5dkdaODhLUnNDT2FM?=
 =?utf-8?B?N2kyZ2k0Nk45RHU0UHJjWmpTZXE3UzBZS29FMGxnTHlFdnlwNG9BZWN0KzJT?=
 =?utf-8?B?VjdWejk4SFU1cTd4TkFBSmNQWXZtOTAvekZPRGN1QWRXbytud3RyMHhMV3dI?=
 =?utf-8?B?WjNTZ0pHUVNvVEpoRkYyRXhRbzhuRzFsWjdzVWJZeHhoVXRHOWpmQnJ4dmNv?=
 =?utf-8?B?dU5HZ0FnUFBCU0dtNXRxLzgrUkVUaUN6SnZZNmdZRUxzQ0w3QTgyWGxyY0Qr?=
 =?utf-8?Q?09jPjRrYJpiXexPkm9LZGmIqH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9818359C7EA1548B1D48A5008BB4ED3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f536af21-301f-4af6-7c07-08db7cd8ab26
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2023 21:50:22.9055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ER1qDa+U/62efvY6ykdzj3i3fOroQaNcenZa+caj0m/eCSwtHpKBpdKS3zFrRn+ts5+e8GFqkL45OSg1rpFTZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5218
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA3LTA0IGF0IDE4OjU4ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gRnJpLCBKdW4gMzAsIDIwMjMgYXQgMDI6MjQ6NTZQTSAtMDcwMCwgU2VhbiBDaHJpc3Rv
cGhlcnNvbiB3cm90ZToNCj4gDQo+ID4gV2FpdGluZyB1bnRpbCB1c2Vyc3BhY2UgYXR0ZW1wdHMg
dG8gY3JlYXRlIHRoZSBmaXJzdCBURFggZ3Vlc3QgYWRkcyBjb21wbGV4aXR5DQo+ID4gYW5kIGxp
bWl0cyB3aGF0IEtWTSBjYW4gZG8gdG8gaGFyZGVuIGl0c2VsZi4gIEN1cnJlbnRseSwgYWxsIGZl
YXR1cmUgc3VwcG9ydCBpbg0KPiA+IEtWTSBpcyBlZmZlY3RpdmVseSBmcm96ZW4gYXQgbW9kdWxl
IGxvYWQuICBFLmcuIG1vc3Qgb2YgdGhlIHNldHVwIGNvZGUgaXMNCj4gPiBjb250YWluZWQgaW4g
X19pbml0IGZ1bmN0aW9ucywgbWFueSBtb2R1bGUtc2NvcGVkIHZhcmlhYmxlcyBhcmUgZWZmZWN0
aXZlbHkgDQo+ID4gUk8gYWZ0ZXIgaW5pdCAodGhvdWdoIHRoZXkgY2FuJ3QgYmUgbWFya2VkIGFz
IHN1Y2ggdW50aWwgd2Ugc211c2gga3ZtLWludGVsLmtvDQo+ID4gYW5kIGt2bS1hbWQua28gaW50
byBrdm0ua28sIHdoaWNoIGlzIHRlbnRhdGl2ZWx5IHRoZSBsb25nLXRlcm0gcGxhbikuICBBbGwg
b2YNCj4gPiB0aG9zZSBwYXR0ZXJucyB3b3VsZCBnZXQgdG9zc2VkIGFzaWRlIGlmIEtWTSB3YWl0
cyB1bnRpbCB1c2Vyc3BhY2UgYXR0ZW1wdHMgdG8NCj4gPiBjcmVhdGUgdGhlIGZpcnN0IGd1ZXN0
Lg0KPiANCj4gLi4uLg0KPiANCj4gUGVvcGxlIGdvdCBwb2tlZCBhbmQgdGhlIGZvbGxvd2luZyB3
YXMgc3VnZ2VzdGVkOg0KPiANCj4gT24gYm9vdCBkbzoNCj4gDQo+ICBUREguU1lTLklOSVQNCj4g
IFRESC5TWVMuTFAuSU5JVA0KPiAgVERILlNZUy5DT05GSUcNCj4gIFRESC5TWVMuS0VZLkNPTkZJ
Rw0KPiANCj4gVGhpcyBzaG91bGQgZ2V0IFREWCBtb3N0bHkgc29ydGVkLCBidXQgZG9lc24ndCBj
b25zdW1lIG11Y2ggcmVzb3VyY2VzLg0KPiBUaGVuIGxhdGVyLCB3aGVuIHN0YXJ0aW5nIHRoZSBm
aXJzdCBURFggZ3Vlc3QsIGRvIHRoZSB3aG9sZQ0KPiANCj4gIFRESC5URE1SLklOSVQNCj4gDQo+
IGRhbmNlIHRvIHNldCB1cCB0aGUgUEFNVCBhcnJheSAtLSB3aGljaCBpcyB3aGF0IGdvYmJsZXMg
dXAgbWVtb3J5LiBGcm9tDQo+IHdoYXQgSSB1bmRlcnN0YW5kIHRoZSBUREguVERNUi5JTklUIHRo
aW5nIGlzIG5vdCBvbmUgb2YgdGhvc2UNCj4gZXhjZXNzaXZlbHkgbG9uZyBjYWxscy4NCg0KVGhl
IFRESC5URE1SLklOSVQgaXRzZWxmIGhhcyBpdCdzIG93biBsYXRlbmN5IHJlcXVpcmVtZW50IGlt
cGxlbWVudGVkIGluIHRoZSBURFgNCm1vZHVsZSwgdGh1cyBpdCBvbmx5IGluaXRpYWxpemVzIGEg
c21hbGwgY2h1bmsgICgxTSBJIGd1ZXNzKSBpbiBlYWNoIGNhbGwuIA0KVGhlcmVmb3JlIHdlIG5l
ZWQgYSBsb29wIHRvIGRvIGJ1bmNoIG9mIFRESC5URE1SLklOSVQgaW4gb3JkZXIgdG8gaW5pdGlh
bGl6ZSBhbGwNClBBTVQgZW50cmllcyBmb3IgYWxsIFREWC11c2FibGUgbWVtb3J5LCB3aGljaCBj
YW4gYmUgdGltZS1jb25zdW1pbmcuDQoNCkN1cnJlbnRseSBmb3Igc2ltcGxpY2l0eSB3ZSBqdXN0
IGRvIHRoaXMgaW5zaWRlIHRoZSBtb2R1bGUgaW5pdGlhbGl6YXRpb24sIGJ1dA0KY2FuIGJlIG9w
dGltaXplZCBsYXRlciB3aGVuIHdlIGhhdmUgYW4gYWdyZWVkIHNvbHV0aW9uIG9mIGhvdyB0byBv
cHRpbWl6ZS4NCg0KPiANCj4gSWYgd2UgaGF2ZSBjb25jZXJucyBhYm91dCBhbGxvY2F0aW5nIHRo
ZSBQQU1UIGFycmF5LCBjYW4ndCB3ZSB1c2UgQ01BDQo+IGZvciB0aGlzPyBBbGxvY2F0ZSB0aGUg
d2hvbGUgdGhpbmcgYXQgYm9vdCBhcyBDTUEgc3VjaCB0aGF0IHdoZW4gbm90DQo+IHVzZWQgZm9y
IFREWCBpdCBjYW4gYmUgdXNlZCBmb3IgcmVndWxhciB0aGluZ3MgbGlrZSB1c2Vyc3BhY2UgYW5k
DQo+IGZpbGVjYWNoZSBwYWdlcz8NCg0KVGhlIFBBTVQgYWxsb2NhdGlvbiBpdHNlbGYgaXNuJ3Qg
YSBjb25jZXJuIEkgdGhpbmsuICBUaGUgY29uY2VybiBpcyB0aGUNClRESC5URE1SLklOSVQgdG8g
aW5pdGlhbGl6ZSB0aGVtLg0KDQpBbHNvLCBvbmUgcHJhY3RpY2FsIHByb2JsZW0gdG8gcHJldmVu
dCB1cyBmcm9tIHByZS1hbGxvY2F0aW5nIFBBTVQgaXMgdGhlIFBBTVQNCnNpemUgdG8gYmUgYWxs
b2NhdGVkIGNhbiBvbmx5IGJlIGRldGVybWluZWQgYWZ0ZXIgdGhlIFRESC5TWVMuSU5GTyBTRUFN
Q0FMTCwNCndoaWNoIHJlcG9ydHMgdGhlICJQQU1UIGVudHJ5IHNpemUiIGluIHRoZSBURFNZU0lO
Rk9fU1RSVUNULg0KDQo+IA0KPiBUaG9zZSBUREguU1lTIGNhbGxzIHNob3VsZCBiZSBlbm91Z2gg
dG8gZW5zdXJlIFREWCBpcyBhY3R1YWxseSB3b3JraW5nLA0KPiBubz8NCg0K
