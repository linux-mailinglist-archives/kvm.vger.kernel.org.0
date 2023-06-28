Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249D6741C7E
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 01:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjF1Xbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 19:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjF1Xbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 19:31:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17D619BA;
        Wed, 28 Jun 2023 16:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687995103; x=1719531103;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RWjNXLEhhtK75vu5j6mzh0drrE9LsE6B1oRfKfQ4Qpg=;
  b=GJc87B9KfCTyc0uzpPFhGOfdzj5bMBUXb7m7Q7u18DxoNtuxy1fjipNA
   96M/39TrLmO1I4yiPLRy6TBkESNPwZKh+QY81fYutjSSfWXicLCEZrOUG
   v8rqQ0jrxxJ9PaBLQ5Z6uGc8PATY4pVFqlMGXfTC06R+OEtGqc4Q1iZnZ
   q3w3HdXj7QBZfcQHK45lYldgLKVU3SG3ULln9t2JI7PuJ3d9TpCLH0iwF
   j9cKmrKheGSgsHsZ1GYlln0vbGkBV4uBvinZGiNPtdBUXwg6XXSHnVDcJ
   7Q8ctsTonDaiH+yBZlp1Q+QwiSy9MlPysZV0o9HuxIQ/DnnsyKfKFxZEE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="448369878"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="448369878"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 16:31:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="720374713"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="720374713"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2023 16:31:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 16:31:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 16:31:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 16:31:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMkBIzQ3IHgokgfEmhFxcysinfulIbz93gDj1CgsfdOzeDAdkK1a14ipMIx5KnYuCV59itRknw/lqUQJwkksY+gR+X4g9gH7duk2XBv1t1MLMqywn/Qtnu6uacIKT1qRYmZ45kJnIsipONeJAVfvemk44Ukxz3CL7o2ZhK+XIIBOVZzvUa84u1fbwgNdXAReBpescoKtqcRh7YzOItY32sqG4XwMabZCC2JVbCrOa1Aj69tdY4vSWe7W5Je8iIFhiMc1kKBnqjsFqWc6ho6ggubhi7+B7Ra8TgDYFR/V8lBxW1r4SD405QcDyJ5IgZQNr3xildbEvm0IvHIGIGopsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWjNXLEhhtK75vu5j6mzh0drrE9LsE6B1oRfKfQ4Qpg=;
 b=GdCrdlguSTAbWJrlIJkW2c8dZ6PnSOo5ekVOkPRe4PMTjwHcC3XJwIr4xw2dd8vM/w0NzI6a1OkIXkgMsYMeo6D6T52j+N3ISrOk9WwFCxaoWmTOxxKzbbfpa+Pxf29g/mscC+dj8hairIEGD/BWFfc1EFi+/2c9/rXd5aI4cb808D03oyb3CGF+D4V+cOUMNMoc8KfmEOVnDSpjPX63JWmzCYwF457irdTR/YLAvawBVVCx1q3Dfc/YYee4sIRXOtOfRadgRHQnTWSs8OkS2THSEyK0Y6Xf+8meqqDd0WNDuwsB8mDiXGtCjCXbg8fFP2aCQlc8FdeDVM76ZRnzQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6785.namprd11.prod.outlook.com (2603:10b6:303:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Wed, 28 Jun
 2023 23:31:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 23:31:30 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZqDWtRkTpkzZfa0qfwqSEOzdd8q+fi4yAgAAGzYCAAIqrAIAAw+MA
Date:   Wed, 28 Jun 2023 23:31:30 +0000
Message-ID: <8bce4a6c56b94acc96a08b3e63467788e5250a3a.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
         <ZJukd/bnkffgsQzT@chao-email>
         <7c4b54cbbb887a3b7e468819a2cf11f7434674cc.camel@intel.com>
         <20230628115022.2plia6tonmxxaj5x@box.shutemov.name>
In-Reply-To: <20230628115022.2plia6tonmxxaj5x@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6785:EE_
x-ms-office365-filtering-correlation-id: 2743766b-b791-4f7a-f6e3-08db782fcd54
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VOyXlaOdF0/OLgcLmkVj9y0GuLrF0vWLXDyXapUL0c7vysPe0LWzD6w56eavhN6idu6FAJOV9k0yust/e2u2N0cVSAC9buIsQYsD6YXBXU+9igFJvZ8irbH/+fAGqUrTleYPuYcV3JcgDDmU4vyS5YvZ3qII6rxVpcWQhg3e0UOUopOgJEog+9sVRgPhxZelC92Npxc6c9d/+wIqNnBF3akIQmp0+o/Oflo0ndTcRock3jvMC+neMlGy1BQpHDbvhuZdkNv59cK9FWvvLTDsrgbefBjnsN0dxk8HJjqCIRi/mknLG1NAYrVs3Kesu6cEoL4/ZGzidF7AxrhPLfbyJc8chvDftHR7viInKkLCvA+FpWvs9xh7dXjp4MHxP/CQacivtqqPuP6lHpfQCnoEiI2XmSmY34eFp/uERevJkE6OleSeU5bCTLNTYDJ3f+eGoEShid5XE7wUMN/Vcpa6jtoL4Lrq8HjcsSXNZiyYKSeKI88fzE9nihmjWq4NlK1+NNLfyAITZgQRmbOlz4ZqDXzcgM8ZpZeA0f3Y3xFeobj46BkpfjE0Lpv5Wahf3q09E0Ei2FVTMriPHwXxQWSgceC9gbSyPTZp18wFZ2GV+wcOhw1aX/B1Yc8FlsYXOweF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199021)(86362001)(2616005)(83380400001)(2906002)(36756003)(38070700005)(122000001)(54906003)(8936002)(38100700002)(82960400001)(41300700001)(316002)(6486002)(5660300002)(8676002)(478600001)(71200400001)(76116006)(6916009)(66946007)(4326008)(66476007)(64756008)(66446008)(66556008)(6512007)(186003)(7416002)(91956017)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUhBb0xnQmJvZUpkK2NIblJ4UkJIbjU2R1RVYk51eVpJOUg2WjVBUFFUNzVJ?=
 =?utf-8?B?N0VVYTE3ZmxJbWorUHAySlBPc0lZazBKWHBpUlJXUzFKU3l0Yi9vQ3cyZzEz?=
 =?utf-8?B?SlVnQi9KNCtFU1VscStLRmM0VXlhK1hqdlBXZi90Q09QYk9jV0xRQVZ0YWY1?=
 =?utf-8?B?SzJjYmlCUnZLbUltVldyRFQ3YXZmUE1Gc3dZVnRVL1J5RWVTcS84RWFSVnlY?=
 =?utf-8?B?K3hmQWdLaEp3Qm5GRmdyaE44QjlMVFdMeXhUUFJjSTdnL053alRCcWRaZWJv?=
 =?utf-8?B?OStBR0dpNGFlVGRwbjBRc1lySkVPd002R0QrZ2FwQ0djcnJINkdpSzZRVXpU?=
 =?utf-8?B?bUcyRkdUNGVsK0liekRqb2o4NFhqeFFkcnRyU3Y2Lyt1alNJVDlxYUo4Z0Vw?=
 =?utf-8?B?dEIra3BJYk1HVjdMVGRqMlovR2ZHaDdJdU9IMWpqYUR1NEZOSHdnRzE4akhV?=
 =?utf-8?B?WG5jZjFsL3BJZmlzN1Q4Q01ZTHFWL0FnSGxVWis0NG5ldUZSZ2Rud29Nd0FM?=
 =?utf-8?B?RHMwZURCcnR2SE8wdHNGZEZhd1JXZ3VrTkpQdDRPRWhRTHVQSXJmWm5CL24z?=
 =?utf-8?B?Rmc5RW5xMGpJQ1BoQy9jb0hyK0FlanZlOXc5S0ZreEU0MHh3TnRMbWFxRlVt?=
 =?utf-8?B?ZXJMM05lNjk0dmdYeWRncWhob3ZJazQyb3ZCbUpyTDZHZFkxVU9yKzZPdU9j?=
 =?utf-8?B?b2lGRnNRNW9SWThXQ1Q0SUxQWW9xS0RjK2ZIY2c5VnZEakM0aVFhLzRyS0tF?=
 =?utf-8?B?V0FQYzRmMWJ2V0hoS2dlMEhqdmYwVHQ1bkhjN1hPUVB5MUkwSW8xNWY4VUJs?=
 =?utf-8?B?cWNtaTZWeVc0R2J2TnBkNFZ6VXVMUUhlREFydGRQZVV0bjg1YlVYemkwak9Y?=
 =?utf-8?B?b2JSVHFIOG40YlUyeW1YblNIK3B3NmY5SjZYVFlUbzF3TkdveXJCRFVPNEpY?=
 =?utf-8?B?VWRVKzF0MnVpbnZRNExQczJveWFCNnNIQWpwRGo0bGlyV1BSWWNMV3JXSzl3?=
 =?utf-8?B?cUU2N2p6TTNCRERONkFOY3kyTTdTN0prNWxwK1NBRUNtZHpPdWswczk0OCtW?=
 =?utf-8?B?cnROUXVBVDU4bitrMW8vUmVDVXFlVHByNWJndUxCNDZVdmpPRjVWQnN0b1VZ?=
 =?utf-8?B?VFk1Z3VwYW5DRWhTUTRqOUZ0eWk2bE5DZjRJRm4vTENaT1lKMWlxcTExZFpJ?=
 =?utf-8?B?RVQ2RmFwdUcycHhKMThkLzhTTUpJZjkrN0lYMUpCTHJRamZzSVNnc1RFV3c4?=
 =?utf-8?B?N3ZlZ0wrQmRpVHFmM2FmMU15WGRFUGZOdXFpREEyekxvdkRxbUVwdUNta3dr?=
 =?utf-8?B?VFZmRm9SSW1kY3I3TWJndDEyck84M2tWbnU5djJEUjBSMDJDUGNHVUhPaUdD?=
 =?utf-8?B?MC9ldEtrNklXSElKblBKNmUxMVZDTWlUVzdtT2tmdENYRi9oK0VEK05iMTVw?=
 =?utf-8?B?NFZzelhOWUIwancwOGI5VC9McFNUSmZ1MnpncS92U3FBb3FGYWhSb01COVRq?=
 =?utf-8?B?NUlOek14OVIzOTE0RWxsUWszUEdIWVBxWXZlWC9KUXoxTUU0OC9OOGZuM0VY?=
 =?utf-8?B?TjFER1doWDJ6RWZIMVpsUGdNZTlxQ0hJTFk2b0lNbHVId3pkWEJ1WEUra21n?=
 =?utf-8?B?VGQ5VTIzMXNKd3pwN1cvb3ZNblNheGcyU1NqcWJJaHgrT2VwdldxTFZuRnJB?=
 =?utf-8?B?Qmlmd053QUJyNk1ZVS94NkZSMWhKazYvd2dTbmpPazAwV2NVa0Y1WVZFK3NS?=
 =?utf-8?B?SUVaOTJiNWNVYUpETXQ1Q3R0dEZLQjlpWEJpNlpyOTFybFZ3eUZmS3pKRWVu?=
 =?utf-8?B?RnJuQktBZTVWc210OWVBTTdiVTQ4T2NKcVZCL3I0dUV4Vmd6UGhHY2pWL2Vh?=
 =?utf-8?B?RjRSM05IUWJXVnZPOFFMbXg2OEtlc0c5dk1Xa1Irbyt2WmpZcGNNNFJ6STM3?=
 =?utf-8?B?YXVXL1M4dXpvRnZnZVFJMkQwSFNJYmVIMk9RRFhpUXhaZEVHTGw5ZE14RVhZ?=
 =?utf-8?B?VDlRT2FUeHMvajN4STExWndWRFo3RlA2cThIdjRERmpwL0FaaVNidld0QUN4?=
 =?utf-8?B?dllkMHAwRVNLNndBMEdjUzJLK1Nhdm14cWRVK3FJRnhHVVM3ZzdVOVg4dzJM?=
 =?utf-8?B?VENrZVdWOTBYL1V5N0xiQm1veGg1S2V4ejFuTVFNdFRzSGpySFZlMGhseitq?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2C1ACB7069AF140BB35EF26B9EAEC06@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2743766b-b791-4f7a-f6e3-08db782fcd54
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 23:31:30.6468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SUsNHtwlkbD4DkMOGfSXsx54jVrvFbLmxEfCfsllp1uyVJAqqLGm50NWMcmszdVvIWFqExZ5mlddU3jQw92gUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6785
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE0OjUwICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBXZWQsIEp1biAyOCwgMjAyMyBhdCAwMzozNDowNUFNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyMy0wNi0yOCBhdCAxMTowOSAr
MDgwMCwgQ2hhbyBHYW8gd3JvdGU6DQo+ID4gPiA+ICsvKg0KPiA+ID4gPiArICogV3JhcHBlciBv
ZiBfX3NlYW1jYWxsKCkgdG8gY29udmVydCBTRUFNQ0FMTCBsZWFmIGZ1bmN0aW9uIGVycm9yIGNv
ZGUNCj4gPiA+ID4gKyAqIHRvIGtlcm5lbCBlcnJvciBjb2RlLiAgQHNlYW1jYWxsX3JldCBhbmQg
QG91dCBjb250YWluIHRoZSBTRUFNQ0FMTA0KPiA+ID4gPiArICogbGVhZiBmdW5jdGlvbiByZXR1
cm4gY29kZSBhbmQgdGhlIGFkZGl0aW9uYWwgb3V0cHV0IHJlc3BlY3RpdmVseSBpZg0KPiA+ID4g
PiArICogbm90IE5VTEwuDQo+ID4gPiA+ICsgKi8NCj4gPiA+ID4gK3N0YXRpYyBpbnQgX19hbHdh
eXNfdW51c2VkIHNlYW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwgdTY0IHI4LCB1NjQN
Cj4gPiA+ID4gcjksDQo+ID4gPiA+ICsJCQkJICAgIHU2NCAqc2VhbWNhbGxfcmV0LA0KPiA+ID4g
PiArCQkJCSAgICBzdHJ1Y3QgdGR4X21vZHVsZV9vdXRwdXQgKm91dCkNCj4gPiA+ID4gK3sNCj4g
PiA+ID4gKwl1NjQgc3JldDsNCj4gPiA+ID4gKwlpbnQgY3B1Ow0KPiA+ID4gPiArDQo+ID4gPiA+
ICsJLyogTmVlZCBhIHN0YWJsZSBDUFUgaWQgZm9yIHByaW50aW5nIGVycm9yIG1lc3NhZ2UgKi8N
Cj4gPiA+ID4gKwljcHUgPSBnZXRfY3B1KCk7DQo+ID4gPiA+ICsJc3JldCA9IF9fc2VhbWNhbGwo
Zm4sIHJjeCwgcmR4LCByOCwgcjksIG91dCk7DQo+ID4gPiA+ICsJcHV0X2NwdSgpOw0KPiA+ID4g
PiArDQo+ID4gPiA+ICsJLyogU2F2ZSBTRUFNQ0FMTCByZXR1cm4gY29kZSBpZiB0aGUgY2FsbGVy
IHdhbnRzIGl0ICovDQo+ID4gPiA+ICsJaWYgKHNlYW1jYWxsX3JldCkNCj4gPiA+ID4gKwkJKnNl
YW1jYWxsX3JldCA9IHNyZXQ7DQo+ID4gPiANCj4gPiA+IEhpIEthaSwNCj4gPiA+IA0KPiA+ID4g
QWxsIGNhbGxlcnMgaW4gdGhpcyBzZXJpZXMgcGFzcyBOVUxMIGZvciBzZWFtY2FsbF9yZXQuIEkg
YW0gbm8gc3VyZSBpZg0KPiA+ID4geW91IGtlZXAgaXQgaW50ZW50aW9uYWxseS4NCj4gPiANCj4g
PiBJbiB0aGlzIHNlcmllcyBhbGwgdGhlIGNhbGxlcnMgZG9lc24ndCBuZWVkIHNlYW1jYWxsX3Jl
dC4NCj4gDQo+IEknbSBmaW5lIGtlZXBpbmcgaXQgaWYgaXQgaXMgbmVlZGVkIGJ5IEtWTSBURFgg
ZW5hYmxpbmcuIE90aGVyd2lzZSwganVzdA0KPiBkcm9wIGl0Lg0KDQpObyBwcm9ibGVtIEknbGwg
ZHJvcCBpdC4gIEtWTSBpcyB1c2luZyBfX3NlYW1jYWxsKCkgYW55d2F5Lg0K
