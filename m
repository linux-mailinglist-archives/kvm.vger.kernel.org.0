Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8973FA68
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 12:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjF0Kpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 06:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjF0Kpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 06:45:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88A610D2;
        Tue, 27 Jun 2023 03:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687862738; x=1719398738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I6/htfi+wHuUeHu5qfHTC+D3oPUxxcqYM7xHregFha0=;
  b=B+48Q51Zr8u01I5OAqpzWkIG52SDGUnKJ3rs8BhD7BaD0tqj5izagsYn
   /mR65hWf/DrnThq15xYsYAlY6ltLplpp/lqugZrP0BiG9z1CJAKBhjPXd
   a4qbBC8sZeCmXkMPaaI8V4XEDTGFwLJi8nqHE2Wkf4NzMT+RBqTbPNKoM
   +7mASn5V6hwYOcrKIkeCzJGrrK99DeMYtNfdSnykz92VMIVGOvnFMnYtK
   +Fm08jm8TZ0GVAVvwwspRs2/gYHVnBelepNxZYWaNPSrfRkQBflmDoeTN
   0fW/O/zWlYBzLbPyz3YJVkbIBM32S+q0jSaJ02aJXrfH7elAn3jgR585/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="359036299"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="359036299"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 03:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="840655136"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="840655136"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 27 Jun 2023 03:45:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 03:45:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 03:45:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 03:45:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggzE5QpM27/7+f4H9GuuglwlxJzHFB2dkgCdD976ICopxIQeQoXDoQY8AVGO3Zio3OPzlhOeLu6O3O5MHAR5/wKU9GKwnuRhW1sTIUad69MbNwzqQwnc/R9ooYOoc2Rghnb5RxqK/zXPphzaT3Pn0qfltyi0bgDO694q7x21dE2WTJJFnK89R9sLD4QLegFkeq0TzItToQ84q8MCkokAI96jUrxB5/X2mCl6UPh8TRlwkE4aHKW+omMOOhgj2eYE4kH+aI2N8EHN1KO99PVf2XM2cqa0PAvKsyqo+zX2esoNoX+y/O8K92mpqNnim5+vuk04rdxxb33BfhaZFuYoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6/htfi+wHuUeHu5qfHTC+D3oPUxxcqYM7xHregFha0=;
 b=Js2+XoUjG0Rway31QPgKshn7oUvi291T1c2uYshJN5uyk5hAQy066rvkQVNEwodEHZp//izFDcnlUiqTMsriA3DdCYT6Qiw6e8MSRObkA9heL4n073JCsu4uFp5sFY1TvcWL6AECm6tf8sWghEwjId5GRAU0s/c6/xuFDRP9U7xWsKBsTujqpaPaYgemRikgZXcptTBpXgBP+KaFTlvrNqgil6FOuFOrzcc7AAT56o4FEiyKGYPN6sOLINvD4XiE5Jw7SzLm6ug4JaRjstPt6xZ14xN64bbaQDEhPoe39Us3bpJ06AU2JJs3MmMm6VrJC5Nm5J/sdVdXRJhH7RRSQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6476.namprd11.prod.outlook.com (2603:10b6:510:1f0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 10:45:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 10:45:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZqDWtVIac1znuLUmerNJjHJZ1la+eaXIAgAAPH4A=
Date:   Tue, 27 Jun 2023 10:45:33 +0000
Message-ID: <49f197f7756ac05b99717a9f63d56cfb860ab88b.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
         <20230627095124.nhiypr6ivi4kdfrw@box.shutemov.name>
In-Reply-To: <20230627095124.nhiypr6ivi4kdfrw@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6476:EE_
x-ms-office365-filtering-correlation-id: f384f870-16da-4fea-113c-08db76fba294
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fVK+oDZNe/B4F+hbLmn/EIypbggsLVoNFVC7Vrqs0oyTbuBan6Z8MJ4YiHjXgdRNgUWs6RGluQF8hguaIUiVd/xaHFxxWJkrcOqT4UEVnfYk2sB/qur2nADOsAvUCpuDP/9F8JDVcjmEqIUJ+BJ4POPgnefGrxa2CgyQFwMTH0yD+toeRJzw/GX/Trn4UG9akpQK1RjejW8QZycGrg6XeFBVdKJAiPNRQVnzgyWV54mhW0koxbdpXIh0ZuHcCnsPwYt37lMWGhgWf07NwkL3tY1Z0IUWzHA4Ircb9Eu3VcqGjRJbnWIUVMPuGNGeH9h7eYIXHEUQ+WLQf8t08LMgnwpcZjpemum6Z7RGhSlrF+3U47rc1vlOMFFnTdpuOxm40517wBCgKcMQm9e0DxyPH+1ruXyCFXMXAckY8i8kZMCdvVN3XDiakahO8AyGxoRFCjkTNez13prt5BiH193WeTZ+xeCN0lIsV/39PbQZRySci6S3MpuzyBUG+SXDL6ZXtvdrVnywBqrbv5p/fVxpDjp450SaxAvOOcg/67k9/zQohstyWxqLtflmGQqAYwrC523dky1TFD+BNFo88XRf0qIcB6rhYw2bb0igscfjKNwrvviWnN8E51rYempAjpn3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199021)(66446008)(54906003)(6486002)(83380400001)(71200400001)(26005)(2906002)(6512007)(2616005)(6506007)(478600001)(186003)(5660300002)(36756003)(7416002)(122000001)(316002)(82960400001)(38100700002)(66946007)(38070700005)(76116006)(4326008)(66476007)(41300700001)(8936002)(8676002)(66556008)(91956017)(64756008)(86362001)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0RycW1idE14cEkxbHQwTXdnTGRIYmtwaGE4dVNiVkVaRWp2NlhEd2hzVURM?=
 =?utf-8?B?K211ekxWd2lCa1hjVjNLZkJJanVIc0EvV2p0MkJlNFF3VS9zbHhRdWNaRHVF?=
 =?utf-8?B?UDNGR0JwZ0o3ZjBEVzFHUTBhYnlveC9BSGdvVm9CUVlVL0l6WGVpbXFyNVlx?=
 =?utf-8?B?SXdzYnhqaGwvdm9nUWxaOTV2aUV1aXJEQWpkQXFqMm02eEh2VEFhbkgxTkRk?=
 =?utf-8?B?Uk40ZVVGdkpRMkxvNjlRZ0ltL3hnZFNPcjRBdWs2KzNnd2FBZmdzZ2Y4NUJr?=
 =?utf-8?B?bVh5MUFGTm4rWkxCajhYWWp0T3Rlbmp0bUJrd0l4R3h1YmFsdHhUY3FjRk9Q?=
 =?utf-8?B?Y1c0em45TDJacGtNZFFzNGVVVDJpQ3p5Zkp1MWsyaEVCdFVoVXhPRGZJaWIv?=
 =?utf-8?B?c2xJMGFOcnYzUHN6MXA2TlFMWE5Bb0FYdDRQckp4NHZlUGRqWEI1ekJHVytL?=
 =?utf-8?B?bEppUUoxeDY5TlJDQmxxanhWOFBVbWY1YnVpMUYrTjlTZXowdDBvM3k3MXJH?=
 =?utf-8?B?aVFzV29iZUp6QUw2Lzc4R1N1a2ZuL1JaaTl0blpkSDVUdWlTODI3MTBjOVc3?=
 =?utf-8?B?Rk43Ni8yVUpiVm1odDFoSjU5a0wxdXNvU05oakdmL3dhU1k5MW5TSHlxZ2FM?=
 =?utf-8?B?d0RWN3lyM29EeDVOTEFGeWpvMFZ3ZmNjT3JxMGdWbkJvejMwYVhmbnpaMDNq?=
 =?utf-8?B?RUFoS0FUTHlzNVhPSUFCY0xLLytvUEE4L2tCK0RuZXZJS1QzS3hMU01tdzE3?=
 =?utf-8?B?dFFiMGtrbmlYRERVdW5TVlplME5NaUJyQ2U0bzJGMzNLTEFkSlFKaGJhUmw5?=
 =?utf-8?B?LzNvclRBSTcvazVpSDREOWl0Sm52QUtKYnJScmxBZEhnb3FFZWh3QktlY2NC?=
 =?utf-8?B?ZjN6T200Y2lRc1NDelIrSmhtbUFtVXI3d3RGZkVsbXF3NXd2aXNPMngvRWFp?=
 =?utf-8?B?Zm8wbkRYeG5aWXdMejJwTzV6OEUzZDMyUGdlUjAzUFdyWWp0TXFaRHVWTXZ1?=
 =?utf-8?B?eUFocVJOYTd5aS80SXV6a25WbnVibHZkQWp6SHNSMlVzcCtxTVBrN1UvQjVB?=
 =?utf-8?B?MnVwV2Z5b1c4YytMeE9udU10WUJQYlVxby9Dbk13SGZhd0dnQ2tkdzVIZDNS?=
 =?utf-8?B?N3JYcFBNa0VGYTN1ZWEyMEdLckxJMjNvOVF3b2pRTVBpSlo3WTRNNzl1MUl2?=
 =?utf-8?B?UytZWnV6T3hWWFpYSk9CSnFzekQyVU9LUUExODJaMnhaZCtiQWR6ZHJCVU5F?=
 =?utf-8?B?WmJUUGxhRFdCcCtPN3RPV1dYaUNQVkozQUpGSXJpWkJkQ3U2Tnl6Uy9mL1Fr?=
 =?utf-8?B?bUFhWWxxWmh3N2Y5bjhXM0t5RG0xV1N4aVJZZU92Z1k2NU5oYlpxK3JtK2Nx?=
 =?utf-8?B?TldvUEtVZDl0TWtqR1B6ZHN4L1p0NTFuajFlMXcxc3M1N0FGbnhaRmpkbUJD?=
 =?utf-8?B?amVITk5vZTNheXhnbWNOOXdyU0Z1dm5hVDZkT3BOdU0xYjNEeFNtdzRTbHRM?=
 =?utf-8?B?UzBRWGkwejNFcXdmUHlBZ3RIYTlkU0NJdUc2VkJoSzFZQS9yK3lVWUZDTEsz?=
 =?utf-8?B?TWhJdCs0d0VKQ3lXdUJyT3BDTkZENnNkTlR5ZnlBdFoxQndJSmZvbElmaXZ0?=
 =?utf-8?B?ZUJmTjBMMWdPMUJlS21kYmowRFBUUkF3VGJtU0hROXE3SGNXeTZRR0NQT2lm?=
 =?utf-8?B?eTkyU3I3Z2NTbjFWMXA0TVlFVHo2c1BTQ2JHVVZkUTdMSlFoZWtEbnhhQjFC?=
 =?utf-8?B?ek0vSldQbGdNR2FvSHNleWxyMGVCd0g3NkpxOC9SRVFvWVZXdXhoUW5SdzNn?=
 =?utf-8?B?VWlOSndEWGo0aGx5NjV1Q2VlVVZCRnVxWnFBdEVSNmpmYk52TWpMTGF3blpY?=
 =?utf-8?B?L0oza2N3eDE5K3VkL200WFlNUkpJM29lRzFBdlJZQkRsTkdFREM1UWNhOWhO?=
 =?utf-8?B?TnBTUEZ1aDdERkhBdHBkdnUzdVJaVkpHVzlFdkRzZk55a0FPSHEvd2xOenQv?=
 =?utf-8?B?eWkzZXkvejNueC8rMTloUG1YK1ZERS91NzFMTDVNSXRDY0RHZmdoYitDVXNn?=
 =?utf-8?B?bW9aSFRoYXFiYWZSaHVPVHllbHFJZ1FWaUs0QlpJaUZmZWUvTUllWjhHWnBB?=
 =?utf-8?Q?eSB3o9EFwjk+SliCKjeH182hb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1168A2D313DB464288614E8396FB7CAA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f384f870-16da-4fea-113c-08db76fba294
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 10:45:33.9363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JOFp/T2T0OHHQuqDFMwWtrzI692tZbjNM9l7UTYqFBASyd70mg/qOkPlz3/q2/w2ElQeBtXr4LZVzCnvtpJvFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6476
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

T24gVHVlLCAyMDIzLTA2LTI3IGF0IDEyOjUxICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAyNywgMjAyMyBhdCAwMjoxMjozOEFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZv
aWQpDQo+ID4gIHsNCj4gPiArCXN0cnVjdCB0ZHN5c2luZm9fc3RydWN0ICpzeXNpbmZvOw0KPiA+
ICsJc3RydWN0IGNtcl9pbmZvICpjbXJfYXJyYXk7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4g
PiArCS8qDQo+ID4gKwkgKiBHZXQgdGhlIFREU1lTSU5GT19TVFJVQ1QgYW5kIENNUnMgZnJvbSB0
aGUgVERYIG1vZHVsZS4NCj4gPiArCSAqDQo+ID4gKwkgKiBUaGUgYnVmZmVycyBvZiB0aGUgVERT
WVNJTkZPX1NUUlVDVCBhbmQgdGhlIENNUiBhcnJheSBwYXNzZWQNCj4gPiArCSAqIHRvIHRoZSBU
RFggbW9kdWxlIG11c3QgYmUgMTAyNC1ieXRlcyBhbmQgNTEyLWJ5dGVzIGFsaWduZWQNCj4gPiAr
CSAqIHJlc3BlY3RpdmVseS4gIEFsbG9jYXRlIG9uZSBwYWdlIHRvIGFjY29tbW9kYXRlIHRoZW0g
Ym90aCBhbmQNCj4gPiArCSAqIGFsc28gbWVldCB0aG9zZSBhbGlnbm1lbnQgcmVxdWlyZW1lbnRz
Lg0KPiA+ICsJICovDQo+ID4gKwlzeXNpbmZvID0gKHN0cnVjdCB0ZHN5c2luZm9fc3RydWN0ICop
X19nZXRfZnJlZV9wYWdlKEdGUF9LRVJORUwpOw0KPiA+ICsJaWYgKCFzeXNpbmZvKQ0KPiA+ICsJ
CXJldHVybiAtRU5PTUVNOw0KPiA+ICsJY21yX2FycmF5ID0gKHN0cnVjdCBjbXJfaW5mbyAqKSgo
dW5zaWduZWQgbG9uZylzeXNpbmZvICsgUEFHRV9TSVpFIC8gMik7DQo+ID4gKw0KPiA+ICsJQlVJ
TERfQlVHX09OKFBBR0VfU0laRSAvIDIgPCBURFNZU0lORk9fU1RSVUNUX1NJWkUpOw0KPiA+ICsJ
QlVJTERfQlVHX09OKFBBR0VfU0laRSAvIDIgPCBzaXplb2Yoc3RydWN0IGNtcl9pbmZvKSAqIE1B
WF9DTVJTKTsNCj4gDQo+IFRoaXMgd29ya3MsIGJ1dCB3aHkgbm90IGp1c3QgdXNlIHNsYWIgZm9y
IHRoaXM/IGttYWxsb2MgaGFzIDUxMiBhbmQgMTAyNA0KPiBwb29scyBhbHJlYWR5IGFuZCB5b3Ug
d29uJ3Qgd2FzdGUgbWVtb3J5IGZvciByb3VuZGluZyB1cC4NCj4gDQo+IFNvbWV0aGluZyBsaWtl
IHRoaXM6DQo+IA0KPiAgICAgICAgIHN5c2luZm8gPSBrbWFsbG9jKFREU1lTSU5GT19TVFJVQ1Rf
U0laRSwgR0ZQX0tFUk5FTCk7DQo+ICAgICAgICAgaWYgKCFzeXNpbmZvKQ0KPiAgICAgICAgICAg
ICAgICAgcmV0dXJuIC1FTk9NRU07DQo+IA0KPiAgICAgICAgIGNtcl9hcnJheV9zaXplID0gc2l6
ZW9mKHN0cnVjdCBjbXJfaW5mbykgKiBNQVhfQ01SUzsNCj4gDQo+ICAgICAgICAgLyogQ01SIGFy
cmF5IGhhcyB0byBiZSA1MTItYWxpZ25lZCAqLw0KPiAgICAgICAgIGNtcl9hcnJheV9zaXplID0g
cm91bmRfdXAoY21yX2FycmF5X3NpemUsIDUxMik7DQoNClNob3VsZCB3ZSBkZWZpbmUgYSBtYWNy
byBmb3IgNTEyDQoNCgkrI2RlZmluZSBDTVJfSU5GT19BUlJBWV9BTElHTk1FTlQJNTEyDQoNCkFu
ZCBnZXQgcmlkIG9mIHRoaXMgY29tbWVudD8gIEFGQUlDVCBEYXZlIGRpZG4ndCBsaWtlIHN1Y2gg
Y29tbWVudCBtZW50aW9uaW5nDQo1MTItYnl0ZXMgYWxpZ25lZCBpZiB3ZSBoYXZlIGEgbWFjcm8g
Zm9yIHRoYXQuDQoNCj4gDQo+ICAgICAgICAgY21yX2FycmF5ID0ga21hbGxvYyhjbXJfYXJyYXlf
c2l6ZSwgR0ZQX0tFUk5FTCk7DQo+ICAgICAgICAgaWYgKCFjbXJfYXJyYXkpIHsNCj4gICAgICAg
ICAgICAgICAgIGtmcmVlKHN5c2luZm8pOw0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9N
RU07DQo+ICAgICAgICAgfQ0KPiANCj4gPw0KPiANCg0KSSBjb25mZXNzIHRoZSByZWFzb24gSSB1
c2VkIF9fZ2V0X2ZyZWVfcGFnZSgpIHdhcyB0byBhdm9pZCBoYXZpbmcgdG8gYWxsb2NhdGUNCnR3
aWNlLCBhbmQgaW4gY2FzZSBvZiBmYWlsdXJlLCBJIG5lZWQgdG8gaGFuZGxlIGFkZGl0aW9uYWwg
bWVtb3J5IGZyZWUuICBCdXQgSQ0KY2FuIGRvIGlmIHlvdSB0aGluayBpdCdzIGNsZWFyZXI/DQoN
Ckkgd291bGRuJ3Qgd29ycnkgYWJvdXQgd2FzdGluZyBtZW1vcnkuICBUaGUgYnVmZmVyIGlzIGZy
ZWVkIGFueXdheSBmb3Igbm93LiANCkxvbmctdGVybWx5IGl0J3MganVzdCA0Sy4NCg==
