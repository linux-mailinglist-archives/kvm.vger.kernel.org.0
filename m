Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D358B7CD4AA
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 08:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344470AbjJRGvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 02:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjJRGvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 02:51:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C7AB6;
        Tue, 17 Oct 2023 23:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697611907; x=1729147907;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9NbUDGYnWp1nEmuRZVJ5DOZIgC4AVs460N47crSV5wE=;
  b=j9eWrQuEin7OmZjjchlZoaFnLKpxjmKdtKb521fgQlupjpps0h0kAozR
   +zBVHApZPIS5qqt5+y8vcueH7XVMfh2Pm/iPPvZn45kIVXvBDwvapY/XU
   PSBZk0xeE996e6xXg6r7mGCI/3DU9+7zEOdB4e9pd4fBOfggZVyD0ttc7
   1Gi6oUbOwJcfcG8Niyyy4nCrJ5bNLNZEN/rn6+E1M3E4+S51LE1VENKJy
   7oK2cMv+e3umY9ID5v3Pm3BVK+KKcMQJ6bTunkKtlNU1USWJJgscPg94r
   9T7johLHb1Fcb7Y1ouAz0BVWppqWjt1/g44l0D6DrsK0pAEJKcHFOR5BZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="472175244"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="472175244"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 23:51:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="826754268"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="826754268"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Oct 2023 23:51:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 17 Oct 2023 23:51:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 17 Oct 2023 23:51:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 17 Oct 2023 23:51:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chrNZ8h4hAI4p1o37t7L5VTXSA6yfe+oOkE+kLcmesjLhgULM4kh3FCrymtghC5H1/vdXHYlG5Gp5/VQaU0vVPUlR+gz/8JmUP1msIICgEChx4YwxRgciJ3SOzPx3Vm0odqiiBFutDJ4N3uMQdpTObsTOLCflRTZ0zwbA2f0rTUJ8FfK7O6cqKKQikC2ZYqU3T2Gpj1cdVxyXNGPiq8hm5xBGz4Ee8RU0kpt+0dGpzFTZR/gU2Qtd3pyWVPQPK5638kuxRVpP6TBue0Q1AjpQXmXVjB1opUCYeZOeffzokG1zVV4bTSazN8oI1cWIjR5if+jP5E9WyZqSwPxrYQpCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NbUDGYnWp1nEmuRZVJ5DOZIgC4AVs460N47crSV5wE=;
 b=flyvJLyJu31BWA+GkhPfbBkRemsULkZ8UsgaaUkBQpnRF/h11enddl/qWEqxlvL2S6LWh9i0RFV0mFHyS2Sj6YUtNPbAo9wL4a7CXZq68PLbNxSvZ4FnMpbAmWGWQBOZS+HFAAU92tHFx4YC5y1QHs1HmvEX5y+K1BlqxeVwWZwsgRfc1y23ge5VeOYfL2PCOCb0/h/tXkoIJKDvrm2kLaBl3udm23CBaPOJa10wCg1g9IM+V4dxnL/ENXfz1rQL9+fm9BkOjSW+H6pmioxV64F4U37U5blK3zap+57m5S38UD1hhFkml2LV2YB1GUoZ+FyxbLBUQLpLHUZtJJijjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by MW4PR11MB5869.namprd11.prod.outlook.com (2603:10b6:303:168::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 06:51:38 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::bf64:748c:62e9:852e]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::bf64:748c:62e9:852e%7]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 06:51:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHaAN//ldkr1S527EC3GXo/nVXwQ7BOCYaAgAETy4A=
Date:   Wed, 18 Oct 2023 06:51:38 +0000
Message-ID: <b0a49bcff0def4588a4d2a822261b34bf601ede0.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
         <c3622d89-28d8-4917-9385-67b4cabaccd0@linux.intel.com>
In-Reply-To: <c3622d89-28d8-4917-9385-67b4cabaccd0@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|MW4PR11MB5869:EE_
x-ms-office365-filtering-correlation-id: 1bc0c549-0f4a-4764-a2e7-08dbcfa6ad37
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IOz6w1Qt119ye9CBIRJSZMCMdAtZZyCdEgid87FdHabuBwStCO6s8KnPRdl0MautAxDgyDEyJK3AWETkx22bGRPON5cbKZTdnxit70WHMGCBms/ngOZrsPPY7D+YzLRLTSrvzeERcWMpYzrzrK/7DQfdTQw94eVphoH66OK+K1dC/aSDbx5v8kxVEMBvpsfaK5bW2aU7769Hk8Db2vX1l/tMGuuwWDrm666rEUjWJ7LDGZdV2MOUOxv0aHSjzoaAjmxgU+znKY5mzxkhOtQ7Zel+pirhYxhwtIPggLGdUD78rUxKCNVuE8mIJAlpChbJOnusjz7djy590oKfJbYs1xHtIQUfVuIVEO6IQHq0Aq7Ts4RHfpSPCUMRFh1qv9Y/Ps3ceRy9Z708XkrKV4DEOvGv+rrneiYYTbW3KCb3A162d0EkOD1Dth8JAaIjA4iGZ2KVS5PfiVgv5N1L7iRWatBWLdgGdsqQmLflSNuygqHtiMpyTnP9Pqlm3RL12xOrIgayotBTRKWHownXkWgXd0f1Yq2X2wucmREIfQR42nKGB8dry+D8HdBO86dXLln9XqEpz/XULBfHdHRaeajpaCq1sP1OmLH/0g8J6F5tB8Dj15BUC2RawzDOgnA4MI3E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(366004)(376002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(8676002)(110136005)(5660300002)(4326008)(7416002)(8936002)(41300700001)(2906002)(86362001)(36756003)(26005)(38100700002)(6506007)(38070700005)(82960400001)(2616005)(122000001)(478600001)(83380400001)(6512007)(71200400001)(91956017)(66946007)(54906003)(66556008)(6486002)(66476007)(76116006)(64756008)(316002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlYydGlydFBXTWd3MnNxMElKTDI1OE9WV1EvTHlvRWFmWjluK3NOTVd0TXFs?=
 =?utf-8?B?bFY5QnJpUTF3NWZOTDk1aVB6NlVITWhkOC9scE02VTMyN3lDRXM4Skcxd1ha?=
 =?utf-8?B?KzRIeThzdlhiUlk2UU0zWjlsWXdJb2RnaWwxT0pPVFFURDlNSWxwNXJ0MlY0?=
 =?utf-8?B?Q0pkVmt5cCtZbkVRZzA5b0d0M08yNmpuVVlkWUJkcUZiTVBRREtSMkxXNzcy?=
 =?utf-8?B?Qk1LbVNhcUk2UU1sTHVhZDJZcVpWMFhkUU5tdlVsMkwxVURmNWROVitHWjdR?=
 =?utf-8?B?ZEU3TWwxQlZpQVdzL3lGMEg4Q01VblVRNmg4SzVaRUMrUG1CYUFmVnRxZU9F?=
 =?utf-8?B?TS9kbVJRaFJXZm1aOCszTlJJbURJV0pJeWJMbEZxUjJKODJ0MUFYOFBsSHAw?=
 =?utf-8?B?bUs3OTNxYjZvayt2Qk5iRTA5VnQ5czFjWjNUNTEweEN6bVA1ckJqbGp5VHk0?=
 =?utf-8?B?YzRFTlZxbzNKeUFyYktTUExHK1J1Z3J0a09lcm1Sd0FRNHhZUmc3MlZlT3pY?=
 =?utf-8?B?aHJ2YWFRTEdjeCtJSGhyZ0Z0ZW50MHJmNVY1MkppTGMvNjNTZWd3VmNxbnNv?=
 =?utf-8?B?WjFRV0QxN3NpWS9uaGVYNUpQazJ3b0FhZUpZWWRFTy9IUE8vV2ZJcUhXbVJY?=
 =?utf-8?B?YllLUHl4aGY1UVJYK1lod3RVQTR6dHhMc3RlL1hiSTNiQUNrN09zVWZlTzc2?=
 =?utf-8?B?WjFQYWJMUUdyMGVpQUF6OXhRWk5JRU04M1VpVmJTTVBIWEwxUUplQXlubDZK?=
 =?utf-8?B?d25RL21JRytnQ2RMN20zZmlYR1hlREpSNHFiMkxYSEhacGVzTWl6T0Exd2F3?=
 =?utf-8?B?Ulgwa2ZoMENLN2xwYXJCUm1pSW5MS3BYOXVuV1NBZzZvL0wydUYrR1lBVFlQ?=
 =?utf-8?B?K0ZBb0RTL3Q4ZEFGZU85MnpON3ptQUtaYmprL2ovRWhpMlVXb3dXK2hiTTNk?=
 =?utf-8?B?TmpHS2t5dVFQVlRqa3Z3T1BVSFhSeUhYUW1rd1RQVEEzZTViOEJKem5nOXpl?=
 =?utf-8?B?ZmhQUDNjbU1MR2o1YmdzditjZWRhYzV1TUVQeU9YOGN3Z0dJbEJYbjQ4T1FE?=
 =?utf-8?B?eTY5SXRtZkdFaU9NOGZ6QmRDNmtTVXhyckVqdDF6SE4zL2FhRjVxVlJEbEdy?=
 =?utf-8?B?V3VkaEd0clduYy9RUnVlaUpEN0picjcxaW5rTFJsak9iazRoK1JUWUtFY1Z3?=
 =?utf-8?B?c1c2dGNhYmovREN3ZGY1YzM3NkVHa1FUODBhRGRyQ2lUSW5xSXF2YTVQV0V2?=
 =?utf-8?B?NEJLdXdwQUpROEJNL0Q0d05HWUc2RjBSSUhERW1oOTBvaGRzYlljdWNiRW9w?=
 =?utf-8?B?USt5RmVhWnR3QVV1NnUzWkE5RTdWeGdqK0VYc0taUGlGK2xxRkI2RGttMXAr?=
 =?utf-8?B?Ri9ZOHE0UGRWdGVuQzMwVjhVdVE4MGF6SndXRTZjaWtlT1ZGMTFGejk1UU9W?=
 =?utf-8?B?d1lWbDhKRnJqeHNKcmhKd0FIR3E1ZlNNWFNuVFN1b3pLWVdmMFdHc0JCMnJo?=
 =?utf-8?B?QWhMRjdJMUUxVXgyaHRSd1U5K3R3a1FXMmVxMkplMTdMY25SY3l1Nkg4ajg3?=
 =?utf-8?B?UUpqOUZzNW0vVjUxNXdFUExrbHdZYlcxcEFranRJMWFjTHFZa3ZUS0VTNENt?=
 =?utf-8?B?SG1lUFpFQ011U3hBejBKT1NFZ3hNRy9uNFFpQlFZVzRtMExFTHVYSkhGSFd4?=
 =?utf-8?B?cG9ROVRWQVp3cHBkT3NvLzcwdlJTR05vbW9DMHlYU2RiTU5RL3hqRUNOZU5Q?=
 =?utf-8?B?WlVDNW9qMWp6RDF2cjBDQytmMHdUdmpla3NMeFBvY1UxSFhsN1J2bVNaTUJ5?=
 =?utf-8?B?aGlNVkE5WVMyZVRoZVJBdXVIeTdwN09xTDl5aTVGaVAxODBkbHI2RG5Ca3BW?=
 =?utf-8?B?Wkl3VHJ4RUFidHQybGZQRlRZemI2YkpBeCt3ZWh0UkxkZUFtKythcHdnT2kw?=
 =?utf-8?B?cHdraERiTDZaY0xxc0Y3M25TV2V6czJ0eTZqTE9iVTNDODA4U0tuVXl0aTNs?=
 =?utf-8?B?Q0x5dU5mWTFHbmh1L0Y3M2doR0Z5UGVOdGhhenFGVzNLWEQ3TExTaEJ5emtZ?=
 =?utf-8?B?Z1hhcmJ5dm9nNFoxeStCQXZtTllsMEpyNTFhdGkyNCt1N0VyTHVMSVpBVElJ?=
 =?utf-8?B?NjQrUFJCSzJwZ1lud2s0UnBZck05SHZCVXdrbHhBdlcwSld1cjdoUGFHRzU3?=
 =?utf-8?B?ZXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79DD4C87479AA043B85E369905EFE9AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc0c549-0f4a-4764-a2e7-08dbcfa6ad37
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 06:51:38.0357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9XZieDO+xlBg2idGWL9R7EBhU4R/Au/vCrqJcGXiXndKmdB8pZRJQDxxfS+K1kpIpOWvMStrbx0Dn/bTJUvuKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gKy8qDQo+ID4gKyAqIERvIHRoZSBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIG9u
Y2UgYW5kIHJldHVybiBpdHMgcmVzdWx0Lg0KPiA+ICsgKiBJdCBjYW4gYmUgZG9uZSBvbiBhbnkg
Y3B1LiAgSXQncyBhbHdheXMgY2FsbGVkIHdpdGggaW50ZXJydXB0cw0KPiA+ICsgKiBkaXNhYmxl
ZC4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBpbnQgdHJ5X2luaXRfbW9kdWxlX2dsb2JhbCh2b2lk
KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7fTsNCj4gPiAr
CXN0YXRpYyBERUZJTkVfUkFXX1NQSU5MT0NLKHN5c2luaXRfbG9jayk7DQo+ID4gKwlzdGF0aWMg
Ym9vbCBzeXNpbml0X2RvbmU7DQo+ID4gKwlzdGF0aWMgaW50IHN5c2luaXRfcmV0Ow0KPiA+ICsN
Cj4gPiArCWxvY2tkZXBfYXNzZXJ0X2lycXNfZGlzYWJsZWQoKTsNCj4gPiArDQo+ID4gKwlyYXdf
c3Bpbl9sb2NrKCZzeXNpbml0X2xvY2spOw0KPiA+ICsNCj4gPiArCWlmIChzeXNpbml0X2RvbmUp
DQo+ID4gKwkJZ290byBvdXQ7DQo+ID4gKw0KPiA+ICsJLyogUkNYIGlzIG1vZHVsZSBhdHRyaWJ1
dGVzIGFuZCBhbGwgYml0cyBhcmUgcmVzZXJ2ZWQgKi8NCj4gPiArCWFyZ3MucmN4ID0gMDsNCj4g
DQo+IElzbid0IGFyZ3MucmN4IGFscmVhZHkgaW5pdGlhbGl6ZWQgdG8gMCwgd2h5IGV4cGxpeGl0
bHkgc2V0IGl0Pw0KDQpUaGUgcHVycG9zZSB3YXMgdG8gaW5kaWNhdGUgU1lTLklOSVQgdGFrZXMg
UkNYIGFzIGlucHV0LCBidXQgT0sgSSBhZ3JlZSBpdCdzDQp1bm5lY2Vzc2FyeS4NCg0KSSBmb3Vu
ZCB0aGUgZXhpc3RpbmcgdXBzdHJlYW0gVERYIGNvZGUgdXNlcyB0aGlzIHBhdHRlcm4gKHBsZWFz
ZSBzZWUNCnRkeF9wYXJzZV9pbmZvKCksIGh2X3RkeF9oeXBlcmNhbGwoKSBhbmQgdHJ5X2FjY2Vw
dF9vbmUoKSk6DQoNCglzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7fTsNCg0KCWFyZ3Mu
eHggPSB4eDsNCglhcmdzLnl5ID0geXk7DQoJLi4uDQoNClNvIEkgZm9sbG93ZWQgaW4gdGhpcyBz
ZXJpZXMuIMKgDQoNCkJ1dCBJIHRoaW5rIGV4cGxpY2l0IHplcm9pbmcgdGhlIHN0cnVjdHVyZSBp
c24ndCBuZWVkZWQsIHNvIEkgdGhpbmsgSSdsbCBqdXN0DQpyZW1vdmUgdGhlIGV4cGxpY2l0IGlu
aXRpYWxpemF0aW9uIGluIHRoZSBAYXJncyBkZWNsYXJhdGlvbiBpbiBhbGwgU0VBTUNBTExzDQp3
aGljaCB1c2UgdGhpcyBwYXR0ZXJuIGluIHRoaXMgc2VyaWVzOg0KDQoJc3RydWN0IHRkeF9tb2R1
bGVfYXJncyBhcmdzOw0KDQoJLyogUkNYIGlzIG1vZHVsZSBhdHRyaWJ1dGVzIGFuZCBhbGwgYml0
cyBhcmUgcmVzZXJ2ZWQgKi8NCglhcmdzLnJjeCA9IDA7DQoNCk9yIGp1c3QgZXhwbGljaXRseSBp
bml0IFJDWCBpbiB0aGUgZGVjbGFyYXRpb246DQoNCglzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFy
Z3MgPSB7DQoJCS5yY3ggPSAwOwkvKiBNb2R1bGUgYXR0cmlidXRlcy4gQWxsIGJpdHMgcmVzZXJ2
ZWQuICovDQoJfTsNCgkvLyBvdGhlciB2YXJpYWJsZSBkZWNsYXJhdGlvbnMNCg0KQnV0IGl0IHNl
ZW1zIG1hbnkgcGVvcGxlIGRvbid0IGxpa2UgdGFpbCBjb21tZW50Lg0KDQpIaSBLaXJpbGwvRGF2
ZSwNCg0KRG8geW91IGhhdmUgYW55IHByZWZlcmVuY2U/DQo+IA0K
