Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9156C72DC
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjCWWQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCWWQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:16:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D37A1E1DA;
        Thu, 23 Mar 2023 15:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679609768; x=1711145768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KBHfnrAZGg4aIbT7O+CB+D626jHQGvohHslxIsTSVM0=;
  b=fVZRVeslDEc7y9xLpvqdh6wm49f5SlWoS68Tc5ybHP90WHsRg1i0l5/h
   LHJLDzxR+hlHqI9rvwsuErNOqcbrOApqALytIZri+zqj1iVxktSfyYIyB
   I4OKdnohzQW4GqxruBHwvwPNZ36sRFB7YvdVXZ6JRUphjx72B6E4N18wk
   tohNbfItxh7mSW7LR/UvphN5eHEZ/Tfma4pMS4ZyEplZnBms3WH42wldN
   iSeTeMhzcHr8fRPlA13c2Pqhuqu3sHazi2cRqks9qOEsBhhxdr/Z1CcFf
   5nF5pga4BCsbOZ59I8WJHbUCV62ROSXUqPb8y0sMySMyS56uE53ovlvbn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="323502532"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="323502532"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 15:15:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="826002822"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="826002822"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 23 Mar 2023 15:15:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 15:15:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 15:15:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 15:15:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuIiH/lf0yx5MPK/Yi38aPbfqXJ444d0AaLcbs5BNIKwHIgUYbXDuVdCTa49lz1eO4T5TlhozBls2IkuHDhkrIdJZwDdWMf01Bz0xZX66p+YLf8u2tK4gh8itfKYwP8c+dxZqmbjHNLfRk1VVk1SKTvd5bnTKz32usQnjG6377pEY2sZni4Ju4z7bkJdwF802ve0PnYMv6B+paTwmEuDc8kO6cS8+/gMgxaCJYLjpurXkPY2G2gH1ELPN+siM6koLdjhyPhj9X6yn2dbAPDAuxkLWgVXhQ0UOorg2kf90ZeNqX9uQ4hDvUxxPQpmsG6RvWU8XY1EoYfD2hMbgOFiTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBHfnrAZGg4aIbT7O+CB+D626jHQGvohHslxIsTSVM0=;
 b=fRKPBVL8sWpggQqWz8jBHN394fsrdqu2N8g4cZcR3PNSyOwhVTAyrkJbydCA0doHl08kaAmKRjI5JolbWswgff3gwsasdYfAKsAWVCK58JiXRt49WDPOd3S15RnF6gs4QmMTsTT0CInAUqJ/kH42Ta79NjpcD0ccMICPypX2JgsXt+QClZ53DiwcFUvQzuz3AcgP5s3DmJbUrV18JuKqUMBcu+ctLg8PfKUAnYDa96XH+nxDaqCl3mWYuU7/NCzB0KkmJOGmrtGx6MFztUO2fqZJRXVz3eYjHKKskuuJIGE4sLWp94vg5YsXz02LzU+71EZueEXNOdAqvgXfvgct8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6060.namprd11.prod.outlook.com (2603:10b6:208:378::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 22:15:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 22:15:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 02/16] x86/virt/tdx: Detect TDX during kernel boot
Thread-Topic: [PATCH v10 02/16] x86/virt/tdx: Detect TDX during kernel boot
Thread-Index: AQHZUDU3AVff1Ip5tka5ejPHlOydGq79auoAgACkdgCACqLVAIAAV1uA
Date:   Thu, 23 Mar 2023 22:15:37 +0000
Message-ID: <2152f69f2127267fdcc5e5c7e7937177da699ab9.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <35a2421ca97d9e8dd938dcd744674602f4faa617.1678111292.git.kai.huang@intel.com>
         <90f6a15c-0dec-4a19-7a21-b18b73932a21@redhat.com>
         <e8cc32a3f374e494bc6b93dad31367d8b093f9c8.camel@intel.com>
         <3dd0e43d-36f7-3325-7680-33779e9b0a55@redhat.com>
In-Reply-To: <3dd0e43d-36f7-3325-7680-33779e9b0a55@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6060:EE_
x-ms-office365-filtering-correlation-id: e52c442c-8995-48b6-81ce-08db2bec2180
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: brsrXbAlTxB9dIcUtfnVincWZXWjXf47TF8zu4hqbGbaJ9sf+1rZh8TyxdrzLLGKziyl88yfKTloQfvMeSyjgrEC9DtDJxQpAfexoVZvLoNU5saa/a44RHa9nQZKj+jdBj5HeMtpNRJeKBUGeRLunJ8KMtkProwTIAOUiasUi4sGcIkH92ewA2dC7jOds7Gjzb02yyPlKtt2+HFYkVaq8cDibAQz8H0o+knx81X7qN+1waypXPDP6t+eAORO9Vk5BU+rou/FHWe8db7oxOhuBQdqwJtnE8QOT9GM7e9BnHPvAv+us9ttdSKCLbtMuH5vczzhgsim+PudFDyDEL6rl1RYverGNlFpgYhqMeyLOu0lTG3oLXzNjngA9D2j3k5rHBSHg0oBVl1o1Ou2c6mQ1SxEM8HEkAmPV3QBgS5k2q37R+y/i8XH+nKO7sIiwxO186XrK1b54BLZGrtGWwBzAdM7pzkCKG5qvXVGymKuxY7H3q90rNJyC7BnEgCBKhhGGUltfZl/kgon0tJouih83vJXMoSUYiG6WPntVnfM1HZpBSzVnGJWWiS0FiwI5xOQtjNTTyJNwPBVLpkK91Ad3So9fAwP3Kp7M8SUNGXdn6gzQv1qVW+m5otOb0av9Czt69zgEwh/hToFbF6klMmm2YJguIi4z1Zlke1mtnteyoY4FqgJgAHoNXRhZIwloT4UokQT4TZlDaEnEkFeAH4UnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199018)(86362001)(64756008)(38070700005)(36756003)(82960400001)(66476007)(122000001)(38100700002)(41300700001)(66446008)(7416002)(4326008)(2906002)(5660300002)(8676002)(71200400001)(66556008)(8936002)(2616005)(6512007)(66946007)(186003)(53546011)(6506007)(54906003)(26005)(110136005)(316002)(6486002)(91956017)(76116006)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cW10UVdBakpXNHBnVlZYdE1pMTFDNkpadkFvSDZDelFiaUQ1U1h4ZEVRc2gr?=
 =?utf-8?B?WEJYdDRvQVVzWjM0bklIM0paZjVDNkdQL1F5VFRoSEFBeUJsL1JTM2tvRWFa?=
 =?utf-8?B?TGoyL0VrR0hwUElJajdZQ1VIVWtxWnJIc3ZHN1oxVjFPWGkwODhqck9vTTU0?=
 =?utf-8?B?MTNpeHZmb0xjQ0dEaW5uSkx3NG52ejNZb0U3TnRtdXdCbEN5Q0xuYUFXSUd5?=
 =?utf-8?B?aFJWQUF2enFxUEdzMy91d3dEZ2pPVzB3aEJzSVBOY1UveGgrYy9SNEJFWCt5?=
 =?utf-8?B?UzAwRGJ3Q3VkSU9QKzN6TUErT0ZLSWI0TCtlRnlQZ0Q3Y2pwRW44eDIwd1FM?=
 =?utf-8?B?Ym0wNXNxMjhzWVJrZUNXMEpadUtMa2x6c3VmTkhhQ3NmZ0FEQWZSSzVwY1do?=
 =?utf-8?B?Nys0dlNRZ3JFcXZpWFRxTmgyREF5YXJBUWhHTzFlMGRpMkloVHdsem5PZlIr?=
 =?utf-8?B?eUc3b2dBM2RFS1pwaEUrZEFja05NUFV4OU5ZTlNKRGxvRDZOT2cyVjF0Ynkx?=
 =?utf-8?B?QmNYb2lOM2pZc0FJRkdoQ0luR29kOHlmd05YbUVwcXFmN211N3pWVUxBQ3M3?=
 =?utf-8?B?bWtQVWN2dlhOenNTWjhxaStSRVFOTnpKMzBzTjhLL25weDcvT0xNZ1p2YUQx?=
 =?utf-8?B?d0NaZ0tSSi9mUkFmYkdJOVVDcXhlemdwVmk5VnU0Q2lJUjE3NWg3UzMzUjlm?=
 =?utf-8?B?NGpIazVsdmpHRWFlTURmRm5hdlcwYjNOWllmUXdRTVlRdjROWmxDVUpSTEx6?=
 =?utf-8?B?UCtia00rWmxRSXZvb2FQZG9PSHlNc0NDRk9nU0VtRUZTQWc3T1R5N0JFbWlt?=
 =?utf-8?B?emRrZ1daTE1sbHAvKzhXSkxyTWoxOExFZWU2NmViTUdhWlIvTmVxNlFwSVJY?=
 =?utf-8?B?TGEyeDJ5N1ZiQVZYSklXbnpodHd2UWdXT1ErTzZlOTlsb0xibW5NKzY4Q3ov?=
 =?utf-8?B?OTcyeWVDQ3ZTV08vc3JlSDJuTmN5MHJWeEtVaytlK3dOQXlYQjBOaU81dEJl?=
 =?utf-8?B?MFZIVEp5ajdTaVlFb1JBU2RIbVZyTldjaGlsNkZrdWRhZS9ieFFIZjNSUUti?=
 =?utf-8?B?V1p3QldiNHZKRGJubitnNHBJdXRiWm9uQkZyUUg3Z050dlNFQ1p1NjRxS0Fi?=
 =?utf-8?B?RVo5VHJWSms5ekt3cDVtVlByZEVxK3Z3bExmQXNXUE1SdUNlRDk1ZDhXd21N?=
 =?utf-8?B?MTZIazJ4c3EreFJkWHVsa1BmRXU0aE9jb2FadlVvbHd4a3ZzaEZsSnJadCtI?=
 =?utf-8?B?ZEYzT2RDd05lM2Rwa3d4MHRUOE5iNEtoU2hGTmNvQWFrQmtVcWdFL1c3dDZs?=
 =?utf-8?B?bU81cllxeFpocDdtVGxiRWtIS2hLK1VHMFFFT1hYd1NaYU4va0g1R2lyWXhZ?=
 =?utf-8?B?VW83MVhtUHJoWXNWQ2VFbUtIQ3NmcGplSG1aNDJlNDlpU0RFaURHREJZVkpU?=
 =?utf-8?B?QlA3SHExekV5NTByK1lITXhnM0swSXJ3bEt0SjZpbFB0czlzWEcrZ3owLzJY?=
 =?utf-8?B?RjcyclAyZC9ucnhpY1ZOdlFEelpxRnhKWnVXNEl0TzZvazlva1dMejIrT05s?=
 =?utf-8?B?K1hMTVJaZGg3OUY1cEpIUkhzcmVyc0hRWGxkdHdSK3lqWDk3SldUbjFPcGh3?=
 =?utf-8?B?QzZUcG1WTWdXQ3BoMnFXbzBSUXdHY1BDSVlUbkhxdlZyMWcrVEpITVJDQ3dw?=
 =?utf-8?B?UFp3V2I3cU1vOHdsMVRCWG5rWDhFSVZSY2xkZC9MZ01Pemx2TW1mQVVJQnBl?=
 =?utf-8?B?YmoyVmdpekhmYVYzSVZicWpHTjd2S3dlOEQ0Z01QVVp0TkhobUdLSm8xUGpC?=
 =?utf-8?B?bDM0NlhMMHpEWUp1Y0N3Z0JhYUdLRktYaEZzKytvZXpHcnF6Y1JSYWVHSnMy?=
 =?utf-8?B?RkdvU3Q2dTVGUkdLL2RyanR1UTJaMmZJNVRrM0tvTTZXQmZIeHd2cW14T09y?=
 =?utf-8?B?Z25NOFZjUzRBU3NLZmFSOFdha0x2SHZ1eU9lSVVFcUlRTUlnWFFvV2JaNUQ4?=
 =?utf-8?B?cTRjZkt5ZURoRVpwRnpQeFlKay9XUEpDem4wMnRvRzFpWEd5Qm1Fd3MxbW8v?=
 =?utf-8?B?S0Y5bnN6SjkvVFlKNzdTNXh5bEdSN2U1NmhPMnpJMHY1ZjFaSTZOd3ZnMGRy?=
 =?utf-8?B?cTlGRFp5cmVzOEFnMUhjc2RYMVM3ZHovRm90V2Z2d0Y0UEFZMGtEdy9jcVVB?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <912791C63571014C81D55FE693688F16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52c442c-8995-48b6-81ce-08db2bec2180
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 22:15:37.7247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jLwTFe+JeGJTSkadRYMRstxI/ASzKOZ5wKbQfnQbs259Jj+3wRagKj6B9Q1M4wj3lijcy4NigtJsLlS3fVniCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6060
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTIzIGF0IDE4OjAyICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMTYuMDMuMjMgMjM6MzcsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gVGh1LCAy
MDIzLTAzLTE2IGF0IDEzOjQ4ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90ZToNCj4gPiA+
IE9uIDA2LjAzLjIzIDE1OjEzLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IEludGVsIFRydXN0
IERvbWFpbiBFeHRlbnNpb25zIChURFgpIHByb3RlY3RzIGd1ZXN0IFZNcyBmcm9tIG1hbGljaW91
cw0KPiA+ID4gPiBob3N0IGFuZCBjZXJ0YWluIHBoeXNpY2FsIGF0dGFja3MuICBBIENQVS1hdHRl
c3RlZCBzb2Z0d2FyZSBtb2R1bGUNCj4gPiA+ID4gY2FsbGVkICd0aGUgVERYIG1vZHVsZScgcnVu
cyBpbnNpZGUgYSBuZXcgaXNvbGF0ZWQgbWVtb3J5IHJhbmdlIGFzIGENCj4gPiA+ID4gdHJ1c3Rl
ZCBoeXBlcnZpc29yIHRvIG1hbmFnZSBhbmQgcnVuIHByb3RlY3RlZCBWTXMuDQo+ID4gPiA+IA0K
PiA+ID4gPiBQcmUtVERYIEludGVsIGhhcmR3YXJlIGhhcyBzdXBwb3J0IGZvciBhIG1lbW9yeSBl
bmNyeXB0aW9uIGFyY2hpdGVjdHVyZQ0KPiA+ID4gPiBjYWxsZWQgTUtUTUUuICBUaGUgbWVtb3J5
IGVuY3J5cHRpb24gaGFyZHdhcmUgdW5kZXJwaW5uaW5nIE1LVE1FIGlzIGFsc28NCj4gPiA+ID4g
dXNlZCBmb3IgSW50ZWwgVERYLiAgVERYIGVuZHMgdXAgInN0ZWFsaW5nIiBzb21lIG9mIHRoZSBw
aHlzaWNhbCBhZGRyZXNzDQo+ID4gPiA+IHNwYWNlIGZyb20gdGhlIE1LVE1FIGFyY2hpdGVjdHVy
ZSBmb3IgY3J5cHRvLXByb3RlY3Rpb24gdG8gVk1zLiAgVGhlDQo+ID4gPiA+IEJJT1MgaXMgcmVz
cG9uc2libGUgZm9yIHBhcnRpdGlvbmluZyB0aGUgIktleUlEIiBzcGFjZSBiZXR3ZWVuIGxlZ2Fj
eQ0KPiA+ID4gPiBNS1RNRSBhbmQgVERYLiAgVGhlIEtleUlEcyByZXNlcnZlZCBmb3IgVERYIGFy
ZSBjYWxsZWQgJ1REWCBwcml2YXRlDQo+ID4gPiA+IEtleUlEcycgb3IgJ1REWCBLZXlJRHMnIGZv
ciBzaG9ydC4NCj4gPiA+ID4gDQo+ID4gPiA+IFREWCBkb2Vzbid0IHRydXN0IHRoZSBCSU9TLiAg
RHVyaW5nIG1hY2hpbmUgYm9vdCwgVERYIHZlcmlmaWVzIHRoZSBURFgNCj4gPiA+ID4gcHJpdmF0
ZSBLZXlJRHMgYXJlIGNvbnNpc3RlbnRseSBhbmQgY29ycmVjdGx5IHByb2dyYW1tZWQgYnkgdGhl
IEJJT1MNCj4gPiA+ID4gYWNyb3NzIGFsbCBDUFUgcGFja2FnZXMgYmVmb3JlIGl0IGVuYWJsZXMg
VERYIG9uIGFueSBDUFUgY29yZS4gIEEgdmFsaWQNCj4gPiA+ID4gVERYIHByaXZhdGUgS2V5SUQg
cmFuZ2Ugb24gQlNQIGluZGljYXRlcyBURFggaGFzIGJlZW4gZW5hYmxlZCBieSB0aGUNCj4gPiA+
ID4gQklPUywgb3RoZXJ3aXNlIHRoZSBCSU9TIGlzIGJ1Z2d5Lg0KPiA+ID4gDQo+IA0KPiBTb3Jy
eSBmb3IgdGhlIGxhdGUgcmVwbHkhDQoNCk5vdCBsYXRlIGZvciBtZSA6KSAgVGhhbmtzIQ0KDQpb
Li4uXQ0KDQoNCj4gPiA+ID4gICAgDQo+ID4gPiA+ICtjb25maWcgSU5URUxfVERYX0hPU1QNCj4g
PiA+ID4gKwlib29sICJJbnRlbCBUcnVzdCBEb21haW4gRXh0ZW5zaW9ucyAoVERYKSBob3N0IHN1
cHBvcnQiDQo+ID4gPiA+ICsJZGVwZW5kcyBvbiBDUFVfU1VQX0lOVEVMDQo+ID4gPiA+ICsJZGVw
ZW5kcyBvbiBYODZfNjQNCj4gPiA+ID4gKwlkZXBlbmRzIG9uIEtWTV9JTlRFTA0KPiA+ID4gPiAr
CWhlbHANCj4gPiA+ID4gKwkgIEludGVsIFRydXN0IERvbWFpbiBFeHRlbnNpb25zIChURFgpIHBy
b3RlY3RzIGd1ZXN0IFZNcyBmcm9tIG1hbGljaW91cw0KPiA+ID4gPiArCSAgaG9zdCBhbmQgY2Vy
dGFpbiBwaHlzaWNhbCBhdHRhY2tzLiAgVGhpcyBvcHRpb24gZW5hYmxlcyBuZWNlc3NhcnkgVERY
DQo+ID4gPiA+ICsJICBzdXBwb3J0IGluIGhvc3Qga2VybmVsIHRvIHJ1biBwcm90ZWN0ZWQgVk1z
Lg0KPiA+ID4gDQo+ID4gPiBzL2luIGhvc3QvaW4gdGhlIGhvc3QvID8NCj4gPiANCj4gPiBTdXJl
Lg0KPiA+IA0KPiA+ID4gDQo+ID4gPiBBbHNvLCBpcyAicHJvdGVjdGVkIFZNcyIgdGhlIHJpZ2h0
IHRlcm0gdG8gdXNlIGhlcmU/ICJFbmNyeXB0ZWQgVk1zIiwNCj4gPiA+ICJDb25maWRlbnRpYWwg
Vk1zIiAuLi4gPw0KPiA+IA0KPiA+ICJFbmNyeXB0ZWQgVk0iIHBlcmhhcHMgaXMgbm90IGEgZ29v
ZCBjaG9pY2UsIGJlY2F1c2UgdGhlcmUgYXJlIG1vcmUgdGhpbmdzIHRoYW4NCj4gPiBlbmNyeXB0
aW9uLiAgSSBhbSBhbHNvIE9LIHdpdGggIkNvbmZpZGVudGlhbCBWTXMiLCBidXQgInByb3RlY3Rl
ZCBWTXMiIGlzIGFsc28NCj4gPiB1c2VkIGluIHRoZSBLVk0gc2VyaWVzIChub3QgdXBzdHJlYW1l
ZCB5ZXQpLCBhbmQgYWxzbyB1c2VkIGJ5IHMzOTAgYnkgbG9va2luZyBhdA0KPiA+IHRoZSBnaXQg
bG9nLg0KPiA+IA0KPiA+IFNvIGJvdGggInByb3RlY3RlZCBWTSIgYW5kICJjb25maWRlbnRpYWwg
Vk0iIHdvcmsgZm9yIG1lLg0KPiA+IA0KPiA+IE5vdCBzdXJlIGFueW9uZSBlbHNlIHdhbnRzIHRv
IGNvbW1lbnQ/DQo+IA0KPiBJJ20gZmluZSBhcyBsb25nIGFzIGl0J3MgdXNlZCBjb25zaXN0ZW50
bHkuICJQcm90ZWN0ZWQgVk0iIHdvdWxkIGhhdmUgDQo+IGJlZW4gdGhlIG9uZSBvdXQgb2YgdGhl
IDMgYWx0ZXJuYXRpdmVzIHRoYXQgSSBoYXZlIGhlYXJkIGxlYXN0IGZyZXF1ZW50bHkuDQo+ID4g
DQoNClllcyBJJ2xsIG1ha2Ugc3VyZSBpdCBpcyB1c2VkIGNvbnNpc3RlbnRseS4gIFRoYW5rcyEN
Cg0KSSBhbSBhbHNvIGdsYWQgdG8gY2hhbmdlIHRvICJDb25maWRlbnRpYWwgVk1zIiBpZiBhbnlv
bmUgZWxzZSBiZWxpZXZlcyBpdCBpcw0KYmV0dGVyLg0K
