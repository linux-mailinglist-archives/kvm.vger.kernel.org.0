Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0212751B85
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbjGMIaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjGMIaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:30:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A0783E5;
        Thu, 13 Jul 2023 01:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689236480; x=1720772480;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/dylVLGT9YLlRK/jrRlNqzw63hQuo1X+oHIThCT5ndM=;
  b=ekGoH/+Z49YkQ7P9wYRkAyHSO1mlSo8C4+oQavsJ+q92ytb2tyCTpEA1
   w1SAfFAn4wvcrEB5tg6eqoC0sMQocP3RAFUXlTz0JhANfvC6/LuBfVYQ5
   fgKOYXU1FURq2D+pcG2lMxWO2ZvmX5vjc35AQ3xzkzP6+HYB6T23o0tf9
   oB2FrFoLXmltzp73SPh7lvT9IuzevW2BX3TRJe3mxRyOCxGIIffYspQiR
   b+BMwqqw8caXD61rEstv9PjoAiCVj8pdl1iJKYuLlyKQoQaU20DDGezJb
   9lq5y6bIQE8FB691DsfHoURv1gqoBTAUDAhQI8DiuPCIyu7LYNToHlukW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="368659129"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="368659129"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 01:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="699172743"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="699172743"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 13 Jul 2023 01:18:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 01:18:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 01:18:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 01:18:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KotXPgfrlhZJpGtxsKOZTM/KM0FEH+ouFHBWedn5pa3mC9nR0m2SxRQSt39yhmFDiwJTNncotp2HS2EtD26hNnVrrG7irqbw8HQUtVxtW5zxfE8vAAglRMBurZKhSRiAj0RHPs58zCTEGq0rOb1lOgrsRneCmLjrXDw6uVM97A5WYdUfaLjVt0yzCUGcOm122S/uTkBeucAQeawQehWuixxcG0diwil5oAg+iw9pS8LF2raQ8DR0pmjNpJ54gYH45rME/t/MYVFfuzlBrgc6PeHKzxbqCZno+3ncNl5DyDiJkkNNLXlhM4wZ+vIocj482rfhmhKTW1oNuNtoPXMWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dylVLGT9YLlRK/jrRlNqzw63hQuo1X+oHIThCT5ndM=;
 b=Q1NxirnMaRCaxL1sFZXULdzCrNTzz/aWz52njRSSQEPAewe3ghitpr5ubiJEg0Pv1RASet8V4NKkgGoJbCb+ed0X6nWSVIlc96bmQQLhQdMfjdqsERakEBgwXqDeca0CVL18LN0Ud52t4bSNElIghzJC87dLuHmwDBD/nh+vswUCC/zVSavys66iYdVnsFSsYQY50V5yzVGMWzl8Cmyo8196J3CxOpV6tzO2FHo77vZ9LJ403/N5PnzrGvSytdPmTl07GcEfT42MM7/7z1ln+mUm02V+HZStv85K2BmR4X2HDyC6cdgvWqqbPqrzz1jAdPEykjs4oKgavVxMhPx+xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6187.namprd11.prod.outlook.com (2603:10b6:930:25::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 08:18:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 08:18:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Topic: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Index: AQHZtJ11LVNzaBLM3EiCxikVoFiXz6+2s2kAgABcqoCAAEG6AIAAChOA
Date:   Thu, 13 Jul 2023 08:18:09 +0000
Message-ID: <d4887818532e1716b5dd8a08819c656ab4e4c5bf.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
         <20230712221510.GG3894444@ls.amr.corp.intel.com>
         <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
         <20230713074204.GA3139243@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713074204.GA3139243@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6187:EE_
x-ms-office365-filtering-correlation-id: 358cc33b-5d8c-48bd-b0b2-08db8379b161
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3FjUvAI6WSv/1b2c99L+Be/mR1ubgHMpgOh6wxx224AmEtBZ6erXrs0EapKr/6NhNF7NHrrzGymkPojpckN/ksmeA2Y1xhAgRjsUqCHlRaWQN0Mfb3dpvizivG1JvBp6/NnifTjEL/kfmT+Y3I95ZaZ9OTlfc8lq+EVaOA3vGWIiGPWIKVv96U4mAnrC7oXvixTL138AhH8Z2TQAVmjr6fNuwSF72+Z1JAHkLTQZ5SwSAUbZs/BSYJb/yFqpfF16Niy0BONZPB3iWmD5y0cctIhrX4MRocls8Mbk/Xqh57s6Valx94bubb0MHnLGdwANy4OAa2Wk3HKk5fZQHI7rPQuNR5W81i7qwooVCIH+Qn8uYVX4ialtOb4AOju8I/8fbPs3+LrgOhUFKMVEZlbn+r0DJs43V9XBIfeGpFVmz3vPmdD409ccTo5zKw9+EeWUAkusZvBDoNtfm6OkCrhw/DKLmb1A6s7tKknHXYf3dyzH7dOXkvLB+IWcu2NLx5ivuCw2523bs8ct6j3ZWsilVyENzzSV7IzuKeiZxhCrsbT1GfitJ3wAQyd4YapO67QaebZS76vJ1MB6leqLnD89G+ihFr7Eowu8VUtPTu3B9voYKIR4cLyKjfw1ownq9df2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199021)(186003)(26005)(41300700001)(6506007)(478600001)(54906003)(4326008)(316002)(6916009)(76116006)(71200400001)(64756008)(66446008)(66476007)(66556008)(66946007)(91956017)(8936002)(5660300002)(8676002)(7416002)(6512007)(6486002)(2616005)(2906002)(83380400001)(122000001)(38100700002)(82960400001)(38070700005)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2hBaHdKUHFUSGxJWTRJMUN6R01hdHJVSURSUTBKbGMxSVpTZERFTUhpVk5D?=
 =?utf-8?B?a0pXcFRSUDlFbndVUmdWOXdYOFJOSi9haDd3dmdidkp6ektYOGlNZjB4RnpH?=
 =?utf-8?B?SWloQkhjVHNmZ1NmY0grSXJtTEhhQlA1Yk1Hc3AxeTBnVCtNR0tnZzJyWGx1?=
 =?utf-8?B?RXBVZm5LVUs0OWdHZnNwdStkR3EwaFM3ZFI2VjFSc1dnbHJlaEdmSXFPVU5u?=
 =?utf-8?B?TVA5em1rbWtJTVZrVnM2KzVud3dPZENGYXlSWE0wVklQcjcwYWQ3dk02dGQ0?=
 =?utf-8?B?YUdwTTNHL0p5dUlqdlpYNlVCSFdKVlU2aUt3aS9jUUdKYW9aazM5VC9LdStq?=
 =?utf-8?B?eUloT0RmZTZBa29SQWNkZTN0VVRiVlp2aDJ2UFdJdUpEZWJ3WXAwWStxNEZO?=
 =?utf-8?B?Sko3Y2c0bk4wcGZYNUs4dUhVR2lNSElxdTkzUXRnRnRJdmpYenZJS1plZ3FJ?=
 =?utf-8?B?dGNBbVY5ajcrQlhYQzZsSG5QSGJOWGl4ZTdzWkY2MU9CUFNUUU9IQmo1eEdz?=
 =?utf-8?B?eVlCZ0FmbEJEVHA2WEh5TXFDK3UxM2JucEcyZjVLRTZNZUhWczg5ekxKbGJF?=
 =?utf-8?B?MUd1N0JocWVIbVo1c2pUMkNLUnJ4RXEwbWZPRmVjekZIdmpITVBDN0tBbENM?=
 =?utf-8?B?YWNjREZyNVdMM1NZdHIvdkQ0NW02Qlhyd3hpTEZRak9Cb1AzSWVLVU9UMGIz?=
 =?utf-8?B?QThOVmJTMG1IL0lza2puOUMrVnM2VWJodld0L1d2cWlMMEhvNENCcmhoeTVX?=
 =?utf-8?B?ckoxUi9Hd2N2eGZDR25Ea2RoM2graENCelgvcExkNmRWSDZRSzRIVitPNDhK?=
 =?utf-8?B?bEtVVExpNmlVWENCL1dxUkM4aVBGc1BuWlVCbFF2bGk0ODRudGdFaFcwd2hZ?=
 =?utf-8?B?N2dxYWN1MzJSZkNpZzRINHFXVnhJVTlONlFjdENETlV4RW9LVHhvOG1JQU4x?=
 =?utf-8?B?QkRyNE03WW1JTXVXWDVBZHRnelBhWm9HeGFuRlBwVEVUWFJFSVh6SVZDK0h4?=
 =?utf-8?B?Ris3Q3BGWE0zRWVnTklubTJVZEs0SVpuRHg2M3NxWk1lckxvNkIwSEY0TGN4?=
 =?utf-8?B?TjVMYmhTbG5nbk5ST3VJMURVYTFxUWR1TG56d0hkaVNmbGs3bkU1YlNReSti?=
 =?utf-8?B?Ni9MQXRZaExHMjJWelVWaUdWbTBYbGVENFBKL3hZblBCOUdvK0h0RzVMYVF6?=
 =?utf-8?B?cDhiNXVJZVQwZVZuaGtiVFZqczE2aTRBTk9nS29iVk9mb2d5NWdNcDhaaWhX?=
 =?utf-8?B?R2FZL0xoakRxVEh6cCtkU28ydzZES3J1aFRlYTRoOVJvaXpZY2NnV0d2Um1r?=
 =?utf-8?B?VFhpZDJpTWdnZ1pjWGxHOWFGWDRZVkc2b3l2OTdnc09YVU9zSUR5bmxBRmJX?=
 =?utf-8?B?ckNIbFhuTmZQZHRObFhQSXlnd3lHNnFIcWdZeGhGMWExQjFGdXNGZWpya0l5?=
 =?utf-8?B?SG5oZG5qWDNzbFlxOW5DWFljemNkSFU3bm9MTEM3ZUdJQXRkNis5eHpvWWVL?=
 =?utf-8?B?QTgzL1lkWDM5VlpDYWZyRXVZMndFZjNuT1M1TmpmUERlS296TnIwb0NpNDZQ?=
 =?utf-8?B?YXdqSUxzalpiSCtGbEQ3YWpiVzU2QVdrNWtTeG91aXl1azZ5dXNoWVM0a1dz?=
 =?utf-8?B?L0VtaUhBVDVra0JOekxsMzNKQ21odk11OFdQeDJwZS9nN2FWL0NyK2lOVTdp?=
 =?utf-8?B?VWMrQUxibVVtdktlYlVzVWI4U3U2Sm12ZC9pMER0eS9sbmxDSTlteHNhRVNR?=
 =?utf-8?B?ejk2VDlKYkphQ0NiNS96bTg2eVdXcm02blEwOEhZSVpxajBLUTkxVnNsQTll?=
 =?utf-8?B?bXUyTE9ldjluY0lCbS92M3pJV1REZzROQ1o1ajR1TE9GUm1aNVJXYXlmeHcy?=
 =?utf-8?B?N2RJc0tDTTg0R2JPT2tTZGNRelc3SGpMa2xKbWNDcVFQeDJCVGVCQ2piTk9L?=
 =?utf-8?B?WXZWZzJkQTlVd3dWcUxIZGh2cmpvZG5hVk1QdENiQ2p1R2hKU2tLU0ptZTU1?=
 =?utf-8?B?TEFmNGpsdVg3WHFtYjI4SVNpZ0hDM3dOQ3htdTc1bW8zT0owdi9ZVGhPUDl3?=
 =?utf-8?B?ZnFWYTJlMmw4aFZ1V1d0V0p6cWovR1hGd2MreHRERXY4TTFSWkFaakFUN0Fn?=
 =?utf-8?B?S205VHlsa1Vzb1ZhK2M2RlRIS0s3ay81dnZ4VHVTZ3V4eUNneFdrcExDNkg5?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F98DC99164F5F547BF97698BA893E1C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 358cc33b-5d8c-48bd-b0b2-08db8379b161
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 08:18:09.0552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sCwc6Vrh8vGTP7EsOocWVhsE99bLFJiHyk5kEgd6HJgV5+7Mi0bfQ4a35gvCOWc8mC8gD7BAt2PomsnvxZnJVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6187
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

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDA5OjQyICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDM6NDY6NTJBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBXZWQsIDIwMjMtMDctMTIgYXQgMTU6MTUgLTA3MDAsIElzYWt1IFlhbWFo
YXRhIHdyb3RlOg0KPiA+ID4gPiBUaGUgU0VBTUNBTEwgQUJJIGlzIHZlcnkgc2ltaWxhciB0byB0
aGUgVERDQUxMIEFCSSBhbmQgbGV2ZXJhZ2VzIG11Y2gNCj4gPiA+ID4gVERDQUxMIGluZnJhc3Ry
dWN0dXJlLsKgIFdpcmUgdXAgYmFzaWMgZnVuY3Rpb25zIHRvIG1ha2UgU0VBTUNBTExzIGZvcg0K
PiA+ID4gPiB0aGUgYmFzaWMgVERYIHN1cHBvcnQ6IF9fc2VhbWNhbGwoKSwgX19zZWFtY2FsbF9y
ZXQoKSBhbmQNCj4gPiA+ID4gX19zZWFtY2FsbF9zYXZlZF9yZXQoKSB3aGljaCBpcyBmb3IgVERI
LlZQLkVOVEVSIGxlYWYgZnVuY3Rpb24uDQo+ID4gPiANCj4gPiA+IEhpLsKgIF9fc2VhbWNhbGxf
c2F2ZWRfcmV0KCkgdXNlcyBzdHJ1Y3QgdGR4X21vZHVsZV9hcmcgYXMgaW5wdXQgYW5kIG91dHB1
dC7CoCBGb3INCj4gPiA+IEtWTSBUREguVlAuRU5URVIgY2FzZSwgdGhvc2UgYXJndW1lbnRzIGFy
ZSBhbHJlYWR5IGluIHVuc2lnbmVkIGxvbmcNCj4gPiA+IGt2bV92Y3B1X2FyY2g6OnJlZ3NbXS7C
oCBJdCdzIHNpbGx5IHRvIG1vdmUgdGhvc2UgdmFsdWVzIHR3aWNlLsKgIEZyb20NCj4gPiA+IGt2
bV92Y3B1X2FyY2g6OnJlZ3MgdG8gdGR4X21vZHVsZV9hcmdzLsKgIEZyb20gdGR4X21vZHVsZV9h
cmdzIHRvIHJlYWwgcmVnaXN0ZXJzLg0KPiA+ID4gDQo+ID4gPiBJZiBUREguVlAuRU5URVIgaXMg
dGhlIG9ubHkgdXNlciBvZiBfX3NlYW1jYWxsX3NhdmVkX3JldCgpLCBjYW4gd2UgbWFrZSBpdCB0
bw0KPiA+ID4gdGFrZSB1bnNpZ25lZCBsb25nIGt2bV92Y3B1X2FyZ2g6OnJlZ3NbTlJfVkNQVV9S
RUdTXT/CoCBNYXliZSBJIGNhbiBtYWtlIHRoZQ0KPiA+ID4gY2hhbmdlIHdpdGggVERYIEtWTSBw
YXRjaCBzZXJpZXMuDQo+ID4gDQo+ID4gVGhlIGFzc2VtYmx5IGNvZGUgYXNzdW1lcyB0aGUgc2Vj
b25kIGFyZ3VtZW50IGlzIGEgcG9pbnRlciB0byAnc3RydWN0DQo+ID4gdGR4X21vZHVsZV9hcmdz
Jy4gIEkgZG9uJ3Qga25vdyBob3cgY2FuIHdlIGNoYW5nZSBfX3NlYW1jYWxsX3NhdmVkX3JldCgp
IHRvDQo+ID4gYWNoaWV2ZSB3aGF0IHlvdSBzYWlkLiAgV2UgbWlnaHQgY2hhbmdlIHRoZSBrdm1f
dmNwdV9hcmdoOjpyZWdzW05SX1ZDUFVfUkVHU10gdG8NCj4gPiBtYXRjaCAnc3RydWN0IHRkeF9t
b2R1bGVfYXJncycncyBsYXlvdXQgYW5kIG1hbnVhbGx5IGNvbnZlcnQgcGFydCBvZiAicmVncyIg
dG8NCj4gPiB0aGUgc3RydWN0dXJlIGFuZCBwYXNzIHRvIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCks
IGJ1dCBpdCdzIHRvbyBoYWNreSBJIHN1cHBvc2UuDQo+IA0KPiBJIHN1c3BlY3QgdGhlIGt2bV92
Y3B1X2FyY2g6OnJlZ3MgbGF5b3V0IGlzIGdpdmVuIGJ5IGhhcmR3YXJlOyBzbyB0aGUNCj4gb25s
eSBvcHRpb24gd291bGQgYmUgdG8gbWFrZSB0ZHhfbW9kdWxlX2FyZ3MgbWF0Y2ggdGhhdC4gSXQn
cyBhIHNsaWdodGx5DQo+IHVuZm9ydHVuYXRlIGxheW91dCwgYnV0IG1laC4NCj4gDQo+IFRoZW4g
eW91IGNhbiBzaW1wbHkgZG86DQo+IA0KPiAJX19zZWFtY2FsbF9zYXZlZF9yZXQobGVhZiwgKHN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKil2Y3B1LT5hcmNoLT5yZWdzKTsNCj4gDQo+IA0KDQpJIGRv
bid0IHRoaW5rIHRoZSBsYXlvdXQgbWF0Y2hlcyBoYXJkd2FyZSwgZXNwZWNpYWxseSBJIHRoaW5r
IHRoZXJlJ3Mgbm8NCiJoYXJkd2FyZSBsYXlvdXQiIGZvciBHUFJzIHRoYXQgYXJlIGNvbmNlcm5l
ZCBoZXJlLiAgVGhleSBhcmUganVzdCBmb3IgS1ZNDQppdHNlbGYgdG8gc2F2ZSBndWVzdCdzIHJl
Z2lzdGVycyB3aGVuIHRoZSBndWVzdCBleGl0cyB0byBLVk0sIHNvIHRoYXQgS1ZNIGNhbg0KcmVz
dG9yZSB0aGVtIHdoZW4gcmV0dXJuaW5nIGJhY2sgdG8gdGhlIGd1ZXN0Lg0K
