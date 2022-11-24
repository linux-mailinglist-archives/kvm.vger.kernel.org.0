Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2451637591
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiKXJv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKXJvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:51:54 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A7DF608B;
        Thu, 24 Nov 2022 01:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669283512; x=1700819512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oNpW4dRR7FfWdyWpe5TfHaLkuxx36LqX1EPX7jZnHDQ=;
  b=AOX7CCnKX5pRTnZjdrOoIftUzFi6xSRuqPTniWDI+3qv6SuAWBSLkbpz
   1dNJtf40mUFUnKO0S/N/gdjCZAUUlrBLhsnilvY6j6nuksy1DVFIScVWo
   OxfIbO56tlmSToFOCgpwMxtuo7c8x/EHFmXZTf0CIIituRjpLBhKURuFM
   FU6OUEdxZg2vGE7ysxqo6/BcZD01JrGq7AwzgdW0KyHqg/Ad9bWjri4QI
   k+m1fP1kSnFww34faa4nF52Wbe2vWDF1jnWjEEBF1QvLOXw50GccEdhh6
   Un7jpAbsvoVc+Drzzf0NmJfiE8inW0VFjwR0U+a2+gW1ZfNsrueQW1YJy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293969661"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="293969661"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 01:51:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642269701"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642269701"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 01:51:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:51:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 01:51:51 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 01:51:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzNLETP5P3uly5Lj/sF+IjTx/Uh/V+u21OBL56g9mOkOz11cShNN1RkfBKkDJBvtBGHQF2zz1/SSMBLp8mQWylqcW8zpkOV4fs1l43dSj0AKsVa9EDRSY9DTsC+UHfDAcUa92VgRrSWveSyA398MSVDkGzYMVHG7eyKklANBfk90+sbdULEUlrEe/LlacNOd5GpYc54TxOdFo1Pdh1yhL4ukYb3UsoBxIBQVbKdy2neGi7cBYxrhyKGWMcFajH24u33p1jkuvXfaQ8RzxsymtQGww4p9gI8xSZrJbsrhx5rK5Ug3xewcyhLdvV2wXdndaJdazD6Sg7AQ3n62eOG+Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNpW4dRR7FfWdyWpe5TfHaLkuxx36LqX1EPX7jZnHDQ=;
 b=cavHQczgjy49AJHQJktA6m/IxvwAzTRmufuiXJbEVlyTYYd+5xfUIJZWbc1jTaAqUIDvUD6rqAHAxrUF3vUAk+uD3vL95clNJj8Sc9lkAjdu2zFIncNV+d6mMXr81vj2ElmTQpdxOBJ+hQigcwHqpLdEl9QX7cqzpWgdfD6y+y8awQMJv7QzQygON+ajFrJgLZ5rGH9ZX23l+v6ZSyBRH6/iYvvSs/tk17pQzY0HAuObEfqNqaC6zfIY6b8T+uL3g5R+La59cwwDGoOLjywU4CA2sfkXIU8Tt3Gzt5mJwxIVE034mhtyG3QqZFuvhQSMEIiQ//FPldwnX/eR0SOCbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6747.namprd11.prod.outlook.com (2603:10b6:510:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Thu, 24 Nov
 2022 09:51:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 09:51:47 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY/T3ORWilVlKW4kyc0A5kdGk0eq5NGDiAgADCBYA=
Date:   Thu, 24 Nov 2022 09:51:47 +0000
Message-ID: <1d821bc32ea87f6a54b88775e7827598f6cb1a1a.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
         <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
In-Reply-To: <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6747:EE_
x-ms-office365-filtering-correlation-id: 2e0696fa-717c-4292-732d-08dace01807c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3qa1TBl6Rw7YyCtWfmlawVoEwbj5cM2MlCaS9W5FVi5a4+ajakitqp4jUc9nToA5AOy1EXqV3yuVFddo+8mmYukvZFWG4bqSxbH6YD7k9BOi1SVIUrG/pSF+oFi1dcSe7W8gLI6O8iRu0GepBTFqsHoW6Jkhi+1NAqPmu/aLsXYudUkty9BHKw/0HF1E9KyxHhRNd/qlkTnz5L6uzax3VoPo78OmXyzhOagzTinN2A+HvqWWuc2JrcCRAbqjE/nLZEQLh819fr09RKeA1aQrwhHogbPPspw0nunh6eI/K9bGqiFTS+0IdkAmdE8zqfLRs0/+pclkrFar38QPqvsjYcq2CwT8wtP69nV0YZp2V0LZVMHfFhzkSp1dha5DoRZE9juV1jduNjqxLdw7ewiiEXZsVH3D9uORTjVtcCShBfNyo3IW66z/ZYqXoH3ndcDIRgp3jR1lVCgF5u1DdxfS8oNHFNumb4FGHzjP1QfaiG5BdqXI0t8+00fYV1gDVJ2usXc4XT7YeXEC9m4pyS52QsDfpeuvaj1LpOWagvdV8VIZYm3ZDS28kYE1jf32aNB8y46+Dt07j2HdPLe2Ua0WyJNiDyaCarIq0vbx26gYtSgrrxcEtPmSZyO0raWfpPyu1hsomhhvHsgBdtBA0YwfgmOyaWZTb7ICcY8VIEdW+4i1/M4uzj7gntqpDjYeYQNGCYo3ihHmUwb41HjyzIO1jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(82960400001)(53546011)(36756003)(86362001)(38070700005)(110136005)(6486002)(71200400001)(6506007)(54906003)(5660300002)(2906002)(91956017)(7416002)(478600001)(26005)(4001150100001)(8936002)(316002)(64756008)(66446008)(66556008)(66946007)(8676002)(4326008)(66476007)(41300700001)(76116006)(6512007)(38100700002)(122000001)(186003)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEcrZFZINkpwTlRIczVvV3V4cFBxSFAxOHlERDlkSTRrWjd1Zm55TmovMmFL?=
 =?utf-8?B?RThPNXZXY0lkbkYxdVNJNnduaSt1Z2VmVWV3eXN4M21SWWJlc3BiaERJc2U0?=
 =?utf-8?B?Y1Q5RVNkVjRCcHZZOSsyeEdNLzluOVR5NFd2NW4vb25CM0E5ZzI5UnMwdmVa?=
 =?utf-8?B?ZU44cXA2STVFa0VnWDkyREFLWDBLTGNqTVE2SndCbHJRNXVWT1VrRDNrU2Rl?=
 =?utf-8?B?UE1ReHVVRVFwaWNsYThoamVUTE13N2YrQW1JMnNwUGJHRm5aNGNmemJKVi9q?=
 =?utf-8?B?ZmNxci9rWXdsc3VyN1UzeUYrSytsYlk0VWlCOVZEWjJIVG1aTnppUVZ4ays2?=
 =?utf-8?B?WlQzQVZES3NIOXpNU1VUT1ZpRkU3SHluekw5OUNld3ZzR2w4NFZvcHZicGN0?=
 =?utf-8?B?QVpvamx5Y3lhcnM2ZTE1S1ZHZTJaZzVScno3cFM5ajNzemhSRFFQcHhUeEIr?=
 =?utf-8?B?UkJmZmZNbVRhVGhZd3MrQnRtTFlLVU9rU1VTeXl1NWtnT0w0YUEzYXFEd1NK?=
 =?utf-8?B?TThaZnc3ZEFyNHNjSy9qc2xoOFJYWk9DM1cvL1ZKZ28yaUt3R3FHREZNTDhE?=
 =?utf-8?B?M24yK2V6bEN6aGp3K0pEUGg4dmZMNFBtQnBqWmFUNTBoWWxLa1piQVBJbDlQ?=
 =?utf-8?B?NXAzeXQ1UDA5TDhnTzNiSjhMMEtZMmtETHFNTXk2T09FZzFsdGdLWkkrcmU4?=
 =?utf-8?B?bWkxODBZd0ZCcmdDczNWdWd3MC9aZ1lDanFiSkZ3RU5xU0hhdGdXWnRRZnJV?=
 =?utf-8?B?M2JvdjJNeVBOanE3U0xxMk5ubG1MMmFUQS9TSlJLU05OZUR4UWF0MkhYQXFR?=
 =?utf-8?B?bU1HZVMva2t3SmpkK3pRUjlrcjBKbFlOeVNkYnUyeXZtVmU0NE43TDNidnpW?=
 =?utf-8?B?OTh3cjBGNnVtRi8rUVpqbUR0ai80RnVOR3AwcFhCT3NQZVNtRGYwQ2FVMVli?=
 =?utf-8?B?ZlJ4TGVJZjhuTnZhS2F6T1RpZFZyd1lOalM2VFZRckx5SzRBV284OCtLMzF3?=
 =?utf-8?B?R2FNMGZpYkZEdnVFWWNIejh4UEUweEhLWHNDWmU2QWJBT3FjVzB1ZFYrK3ps?=
 =?utf-8?B?TWhVeWM5VkJBRGZ2Yno2OGhtTUo2eFZRYnFRSCtSMENtSysrQUpGdDZyZHlR?=
 =?utf-8?B?di90MlJkVzlHdStvOUJPa3VZYnlqbnlES01pc0xzNkZQUnRydjlBOUdqemRV?=
 =?utf-8?B?RTdDeXE4bXFWNk56OTVuNUZIZ2JFbC9KdVR0ODd6TkhhaFdqMFRyQnF3NVl6?=
 =?utf-8?B?eDZlWFFTY3hCVUVucjVocXlFLy9ma0xNSWl4Q3JqMi95R0haeC9hQjgrK1pp?=
 =?utf-8?B?QkJwSVJmMWJ2RjArMTZPVURKYXpXSzJzVUoyL2IzZ3hKQnBSUmZaRFRrUVNL?=
 =?utf-8?B?WUc3SE05STYwcmxycXdFSkVMT1A5eVpKNnhhSzB3SkhkVVgrSjh4bEtPYlZV?=
 =?utf-8?B?RGdPZVZ6U0R3R1FyVEF2TEE3V2duYzI2ZVJpNzNsMUQ4MnM2a2FVTDN0SGVN?=
 =?utf-8?B?QU95UW9xVkZKazBQUUhGTUdLQTQzOWNmaVNpWlNpZmZmeXZhMmJRN2lnVHFz?=
 =?utf-8?B?QktZbGFqdExIalR3TWFmZXFnSDRhSDZpUFB0aGN0WjlnMEFYRHlEVFNzQ0RG?=
 =?utf-8?B?YTdsakQrVFVQWmJzNWtONE1Oc2pKN0ZHWUFmQzIvRVp3Z1psZ2lVM09HNGg2?=
 =?utf-8?B?cHpMOUY5QUZGOGJlVzh2elJPdFhEZEgzRm9vWGZZdEJGc0s5WEY1amJLOG1B?=
 =?utf-8?B?MlI0TFl5TGwwMU9ubXp4eGNpdFl4U1ZpWW9LSmJxTnQxV3RaRW9ibEF6dUNs?=
 =?utf-8?B?bGJNR3dVU3V3eld3SWtodlBHTnJ1YmJ4TG5ELzFyeEc2ZHBuWU1QRytCbHIr?=
 =?utf-8?B?cWJweU96cmFQeFU1c3B1MVQwSEFFNGgydDJocUo1OTdtbEw5SGdRR3dOS2xx?=
 =?utf-8?B?aHBkTUY0S3lLNk9sNGwxK1pvN0lPNFovV0puUEpkTVhpMm1aU2Z5Z1BFWnpn?=
 =?utf-8?B?TUJiL0RIMjk2UG00ODJEUURoUkFtOXVKYUNtaFIrcWgycTZOcjdXQmN4bHVh?=
 =?utf-8?B?QUNsUHFGOXlPUWRiUzJjRHA5bDJiRG01UitieVZxa29KRUt1OCtPRG10Szk3?=
 =?utf-8?B?UW9JWjdXQWVueVMxL1Avci9vMXNjcU83NmVqcmtpVjNSTUsrZU5rZUFLNUIw?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BD3153475D9FA43A61E447E559600B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0696fa-717c-4292-732d-08dace01807c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 09:51:47.1650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v0LzCWgYNtltWtiLSo+NbyRVteLEgA2lmMK1/fgeD9KBrdAk+i550xeYiXlPV42gGALPHjqC2fPmmGwkX9p8Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6747
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE0OjE3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggcHJvdmlkZXMgaW5j
cmVhc2VkIGxldmVscyBvZiBtZW1vcnkgY29uZmlkZW50aWFsaXR5IGFuZCBpbnRlZ3JpdHkuDQo+
ID4gVGhpcyByZXF1aXJlcyBzcGVjaWFsIGhhcmR3YXJlIHN1cHBvcnQgZm9yIGZlYXR1cmVzIGxp
a2UgbWVtb3J5DQo+ID4gZW5jcnlwdGlvbiBhbmQgc3RvcmFnZSBvZiBtZW1vcnkgaW50ZWdyaXR5
IGNoZWNrc3Vtcy4gIE5vdCBhbGwgbWVtb3J5DQo+ID4gc2F0aXNmaWVzIHRoZXNlIHJlcXVpcmVt
ZW50cy4NCj4gPiANCj4gPiBBcyBhIHJlc3VsdCwgdGhlIFREWCBpbnRyb2R1Y2VkIHRoZSBjb25j
ZXB0IG9mIGEgIkNvbnZlcnRpYmxlIE1lbW9yeQ0KPiANCj4gcy90aGUgVERYIGludHJvZHVjZWQv
VERYIGludHJvZHVjZXMvDQo+IA0KPiA+IFJlZ2lvbiIgKENNUikuICBEdXJpbmcgYm9vdCwgdGhl
IGZpcm13YXJlIGJ1aWxkcyBhIGxpc3Qgb2YgYWxsIG9mIHRoZQ0KPiA+IG1lbW9yeSByYW5nZXMg
d2hpY2ggY2FuIHByb3ZpZGUgdGhlIFREWCBzZWN1cml0eSBndWFyYW50ZWVzLiAgVGhlIGxpc3QN
Cj4gPiBvZiB0aGVzZSByYW5nZXMgaXMgYXZhaWxhYmxlIHRvIHRoZSBrZXJuZWwgYnkgcXVlcnlp
bmcgdGhlIFREWCBtb2R1bGUuDQo+ID4gDQo+ID4gVGhlIFREWCBhcmNoaXRlY3R1cmUgbmVlZHMg
YWRkaXRpb25hbCBtZXRhZGF0YSB0byByZWNvcmQgdGhpbmdzIGxpa2UNCj4gPiB3aGljaCBURCBn
dWVzdCAib3ducyIgYSBnaXZlbiBwYWdlIG9mIG1lbW9yeS4gIFRoaXMgbWV0YWRhdGEgZXNzZW50
aWFsbHkNCj4gPiBzZXJ2ZXMgYXMgdGhlICdzdHJ1Y3QgcGFnZScgZm9yIHRoZSBURFggbW9kdWxl
LiAgVGhlIHNwYWNlIGZvciB0aGlzDQo+ID4gbWV0YWRhdGEgaXMgbm90IHJlc2VydmVkIGJ5IHRo
ZSBoYXJkd2FyZSB1cCBmcm9udCBhbmQgbXVzdCBiZSBhbGxvY2F0ZWQNCj4gPiBieSB0aGUga2Vy
bmVsIGFuZCBnaXZlbiB0byB0aGUgVERYIG1vZHVsZS4NCj4gPiANCj4gPiBTaW5jZSB0aGlzIG1l
dGFkYXRhIGNvbnN1bWVzIHNwYWNlLCB0aGUgVk1NIGNhbiBjaG9vc2Ugd2hldGhlciBvciBub3Qg
dG8NCj4gPiBhbGxvY2F0ZSBpdCBmb3IgYSBnaXZlbiBhcmVhIG9mIGNvbnZlcnRpYmxlIG1lbW9y
eS4gIElmIGl0IGNob29zZXMgbm90DQo+ID4gdG8sIHRoZSBtZW1vcnkgY2Fubm90IHJlY2VpdmUg
VERYIHByb3RlY3Rpb25zIGFuZCBjYW4gbm90IGJlIHVzZWQgYnkgVERYDQo+ID4gZ3Vlc3RzIGFz
IHByaXZhdGUgbWVtb3J5Lg0KPiA+IA0KPiA+IEZvciBldmVyeSBtZW1vcnkgcmVnaW9uIHRoYXQg
dGhlIFZNTSB3YW50cyB0byB1c2UgYXMgVERYIG1lbW9yeSwgaXQgc2V0cw0KPiA+IHVwIGEgIlRE
IE1lbW9yeSBSZWdpb24iIChURE1SKS4gIEVhY2ggVERNUiByZXByZXNlbnRzIGEgcGh5c2ljYWxs
eQ0KPiA+IGNvbnRpZ3VvdXMgY29udmVydGlibGUgcmFuZ2UgYW5kIG11c3QgYWxzbyBoYXZlIGl0
cyBvd24gcGh5c2ljYWxseQ0KPiA+IGNvbnRpZ3VvdXMgbWV0YWRhdGEgdGFibGUsIHJlZmVycmVk
IHRvIGFzIGEgUGh5c2ljYWwgQWRkcmVzcyBNZXRhZGF0YQ0KPiA+IFRhYmxlIChQQU1UKSwgdG8g
dHJhY2sgc3RhdHVzIGZvciBlYWNoIHBhZ2UgaW4gdGhlIFRETVIgcmFuZ2UuDQo+ID4gDQo+ID4g
VW5saWtlIGEgQ01SLCBlYWNoIFRETVIgcmVxdWlyZXMgMUcgZ3JhbnVsYXJpdHkgYW5kIGFsaWdu
bWVudC4gIFRvDQo+ID4gc3VwcG9ydCBwaHlzaWNhbCBSQU0gYXJlYXMgdGhhdCBkb24ndCBtZWV0
IHRob3NlIHN0cmljdCByZXF1aXJlbWVudHMsDQo+ID4gZWFjaCBURE1SIHBlcm1pdHMgYSBudW1i
ZXIgb2YgaW50ZXJuYWwgInJlc2VydmVkIGFyZWFzIiB3aGljaCBjYW4gYmUNCj4gPiBwbGFjZWQg
b3ZlciBtZW1vcnkgaG9sZXMuICBJZiBQQU1UIG1ldGFkYXRhIGlzIHBsYWNlZCB3aXRoaW4gYSBU
RE1SIGl0DQo+ID4gbXVzdCBiZSBjb3ZlcmVkIGJ5IG9uZSBvZiB0aGVzZSByZXNlcnZlZCBhcmVh
cy4NCj4gPiANCj4gPiBMZXQncyBzdW1tYXJpemUgdGhlIGNvbmNlcHRzOg0KPiA+IA0KPiA+ICBD
TVIgLSBGaXJtd2FyZS1lbnVtZXJhdGVkIHBoeXNpY2FsIHJhbmdlcyB0aGF0IHN1cHBvcnQgVERY
LiAgQ01ScyBhcmUNCj4gPiAgICAgICAgNEsgYWxpZ25lZC4NCj4gPiBURE1SIC0gUGh5c2ljYWwg
YWRkcmVzcyByYW5nZSB3aGljaCBpcyBjaG9zZW4gYnkgdGhlIGtlcm5lbCB0byBzdXBwb3J0DQo+
ID4gICAgICAgIFREWC4gIDFHIGdyYW51bGFyaXR5IGFuZCBhbGlnbm1lbnQgcmVxdWlyZWQuICBF
YWNoIFRETVIgaGFzDQo+ID4gICAgICAgIHJlc2VydmVkIGFyZWFzIHdoZXJlIFREWCBtZW1vcnkg
aG9sZXMgYW5kIG92ZXJsYXBwaW5nIFBBTVRzIGNhbg0KPiA+ICAgICAgICBiZSBwdXQgaW50by4N
Cj4gDQo+IHMvcHV0IGludG8vcmVwcmVzZW50ZWQvDQo+IA0KPiA+IFBBTVQgLSBQaHlzaWNhbGx5
IGNvbnRpZ3VvdXMgVERYIG1ldGFkYXRhLiAgT25lIHRhYmxlIGZvciBlYWNoIHBhZ2Ugc2l6ZQ0K
PiA+ICAgICAgICBwZXIgVERNUi4gIFJvdWdobHkgMS8yNTZ0aCBvZiBURE1SIGluIHNpemUuICAy
NTZHIFRETVIgPSB+MUcNCj4gPiAgICAgICAgUEFNVC4NCj4gPiANCj4gPiBBcyBvbmUgc3RlcCBv
ZiBpbml0aWFsaXppbmcgdGhlIFREWCBtb2R1bGUsIHRoZSBrZXJuZWwgY29uZmlndXJlcw0KPiA+
IFREWC11c2FibGUgbWVtb3J5IHJlZ2lvbnMgYnkgcGFzc2luZyBhbiBhcnJheSBvZiBURE1ScyB0
byB0aGUgVERYIG1vZHVsZS4NCj4gPiANCj4gPiBDb25zdHJ1Y3RpbmcgdGhlIGFycmF5IG9mIFRE
TVJzIGNvbnNpc3RzIGJlbG93IHN0ZXBzOg0KPiA+IA0KPiA+IDEpIENyZWF0ZSBURE1ScyB0byBj
b3ZlciBhbGwgbWVtb3J5IHJlZ2lvbnMgdGhhdCB0aGUgVERYIG1vZHVsZSBjYW4gdXNlOw0KPiAN
Cj4gU2xpZ2h0IHR3ZWFrOg0KPiANCj4gMSkgQ3JlYXRlIFRETVJzIHRvIGNvdmVyIGFsbCBtZW1v
cnkgcmVnaW9ucyB0aGF0IHRoZSBURFggbW9kdWxlIHdpbGwgdXNlDQo+ICAgIGZvciBURCBtZW1v
cnkNCj4gDQo+IFRoZSBURFggbW9kdWxlICJ1c2VzIiBtb3JlIG1lbW9yeSB0aGFuIHN0cmljdGx5
IHRoZSBUTURSJ3MuDQo+IA0KPiA+IDIpIEFsbG9jYXRlIGFuZCBzZXQgdXAgUEFNVCBmb3IgZWFj
aCBURE1SOw0KPiA+IDMpIFNldCB1cCByZXNlcnZlZCBhcmVhcyBmb3IgZWFjaCBURE1SLg0KPiAN
Cj4gcy9TZXQgdXAvRGVzaWduYXRlLw0KDQpUaGFua3MuIEFsbCBhYm92ZSB3aWxsIGJlIGFkZHJl
c3NlZC4NCg0KPiANCj4gPiBBZGQgYSBwbGFjZWhvbGRlciB0byBjb25zdHJ1Y3QgVERNUnMgdG8g
ZG8gdGhlIGFib3ZlIHN0ZXBzIGFmdGVyIGFsbA0KPiA+IFREWCBtZW1vcnkgcmVnaW9ucyBhcmUg
dmVyaWZpZWQgdG8gYmUgdHJ1bHkgY29udmVydGlibGUuICBBbHdheXMgZnJlZQ0KPiA+IFRETVJz
IGF0IHRoZSBlbmQgb2YgdGhlIGluaXRpYWxpemF0aW9uIChubyBtYXR0ZXIgc3VjY2Vzc2Z1bCBv
ciBub3QpDQo+ID4gYXMgVERNUnMgYXJlIG9ubHkgdXNlZCBkdXJpbmcgdGhlIGluaXRpYWxpemF0
aW9uLg0KPiANCj4gVGhlIGNoYW5nZWxvZyBoZXJlIGFjdHVhbGx5IGxvb2tzIHJlYWxseSBnb29k
IHRvIG1lIHNvIGZhci4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IDMyYWY4NmUz
MWM0Ny4uMjYwNDhjNmIwMTcwIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IEBAIC00
NDUsNiArNDQ1LDYzIEBAIHN0YXRpYyBpbnQgYnVpbGRfdGR4X21lbW9yeSh2b2lkKQ0KPiA+ICAJ
cmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+ICANCj4gPiArLyogQ2FsY3VsYXRlIHRoZSBhY3R1YWwg
VERNUl9JTkZPIHNpemUgKi8NCj4gPiArc3RhdGljIGlubGluZSBpbnQgY2FsX3RkbXJfc2l6ZSh2
b2lkKQ0KPiANCj4gSSB0aGluayB3ZSBjYW4gc3BhcmUgdGhlIGJ5dGVzIHRvIGFkZCAiY3VsYXRl
IiBpbiB0aGUgZnVuY3Rpb24gbmFtZSBzbw0KPiB3ZSBkb24ndCB0aGluayB0aGVzZSBhcmUgQ2Fs
aWZvcm5pYSBURE1Scy4NCg0KU3VyZSB3aWxsIGRvLg0KDQo+IA0KPiA+ICt7DQo+ID4gKwlpbnQg
dGRtcl9zejsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogVGhlIGFjdHVhbCBzaXplIG9mIFRE
TVJfSU5GTyBkZXBlbmRzIG9uIHRoZSBtYXhpbXVtIG51bWJlcg0KPiA+ICsJICogb2YgcmVzZXJ2
ZWQgYXJlYXMuDQo+ID4gKwkgKg0KPiA+ICsJICogTm90ZTogZm9yIFREWDEuMCB0aGUgbWF4X3Jl
c2VydmVkX3Blcl90ZG1yIGlzIDE2LCBhbmQNCj4gPiArCSAqIFRETVJfSU5GTyBzaXplIGlzIGFs
aWduZWQgdXAgdG8gNTEyLWJ5dGUuICBFdmVuIGl0IGlzDQo+ID4gKwkgKiBleHRlbmRlZCBpbiB0
aGUgZnV0dXJlLCBpdCB3b3VsZCBiZSBpbnNhbmUgaWYgVERNUl9JTkZPDQo+ID4gKwkgKiBiZWNv
bWVzIGxhcmdlciB0aGFuIDRLLiAgVGhlIHRkbXJfc3ogaGVyZSBzaG91bGQgbmV2ZXINCj4gPiAr
CSAqIG92ZXJmbG93Lg0KPiA+ICsJICovDQo+ID4gKwl0ZG1yX3N6ID0gc2l6ZW9mKHN0cnVjdCB0
ZG1yX2luZm8pOw0KPiA+ICsJdGRtcl9zeiArPSBzaXplb2Yoc3RydWN0IHRkbXJfcmVzZXJ2ZWRf
YXJlYSkgKg0KPiA+ICsJCSAgIHRkeF9zeXNpbmZvLm1heF9yZXNlcnZlZF9wZXJfdGRtcjsNCj4g
DQo+IEZpcnN0LCBJIHRoaW5rICd0ZHhfc3lzaW5mbycgc2hvdWxkIHByb2JhYmx5IGJlIGEgbG9j
YWwgdmFyaWFibGUgaW4NCj4gaW5pdF90ZHhfbW9kdWxlKCkgYW5kIGhhdmUgaXRzIGFkZHJlc3Mg
cGFzc2VkIGluIGhlcmUuICBIYXZpbmcgZ2xvYmFsDQo+IHZhcmlhYmxlcyBhbHdheXMgbWFrZXMg
aXQgbW9yZSBvcGFxdWUgYWJvdXQgd2hvIGlzIGluaXRpYWxpemluZyBpdC4NCj4gDQo+IFNlY29u
ZCwgaWYgdGhpcyBjb2RlIGlzIG1ha2luZyBhc3N1bXB0aW9ucyBhYm91dA0KPiAnbWF4X3Jlc2Vy
dmVkX3Blcl90ZG1yJywgdGhlbiBsZXQncyBhY3R1YWxseSBhZGQgYXNzZXJ0aW9ucyBvciBzYW5p
dHkNCj4gY2hlY2tzLiAgRm9yIGluc3RhbmNlOg0KPiANCj4gCWlmICh0ZHhfc3lzaW5mby5tYXhf
cmVzZXJ2ZWRfcGVyX3RkbXIgPiBNQVhfVERNUlMpDQo+IAkJcmV0dXJuIC0xOw0KPiANCj4gb3Ig
ZXZlbjoNCj4gDQo+IAlpZiAodGRtcl9zeiA+IFBBR0VfU0laRSkNCj4gCQlyZXR1cm4gLTE7DQoN
CkkgY2FuIGFkZCB0aGlzLg0KDQo+IA0KPiBJdCBkb2VzIGFsbW9zdCBubyBnb29kIHRvIGp1c3Qg
YXNzZXJ0IHdoYXQgdGhlIGxpbWl0cyBhcmUgaW4gYSBjb21tZW50Lg0KPiANCj4gPiArCS8qDQo+
ID4gKwkgKiBURFggcmVxdWlyZXMgZWFjaCBURE1SX0lORk8gdG8gYmUgNTEyLWJ5dGUgYWxpZ25l
ZC4gIEFsd2F5cw0KPiA+ICsJICogcm91bmQgdXAgVERNUl9JTkZPIHNpemUgdG8gdGhlIDUxMi1i
eXRlIGJvdW5kYXJ5Lg0KPiA+ICsJICovDQo+IA0KPiA8c2lnaD4gTW9yZSBzaWxseSBjb21tZW50
cy4NCj4gDQo+IFRoZSBwbGFjZSB0byBkb2N1bWVudCB0aGlzIGlzIFRETVJfSU5GT19BTElHTk1F
TlQuICBJZiBhbnlvbmUgd2FudHMgdG8NCj4ga25vdyB3aGF0IHRoZSBhbGlnbm1lbnQgaXMsIGV4
YWN0bHksIHRoZXkgY2FuIGxvb2sgYXQgdGhlIGRlZmluaXRpb24uDQo+IFRoZXkgZG9uJ3QgbmVl
ZCB0byBiZSB0b2xkICpUV0lDRSogd2hhdCBURE1SX0lORk9fQUxJR05NRU5UICNkZWZpbmVzIHRv
DQo+IGluIG9uZSBjb21tZW50Lg0KDQpJIHNlZS4gIFRoZW4gSSB0aGluayB3ZSBkb24ndCBldmVu
IG5lZWQgdGhpcyBjb21tZW50IHNpbmNlIHRoZSBuYW1lIG9mDQpURE1SX0lORk9fQUxJR05NRU5U
IGFscmVhZHkgaW1wbGllcz8NCg0KPiANCj4gPiArCXJldHVybiBBTElHTih0ZG1yX3N6LCBURE1S
X0lORk9fQUxJR05NRU5UKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIHN0cnVjdCB0ZG1y
X2luZm8gKmFsbG9jX3RkbXJfYXJyYXkoaW50ICphcnJheV9zeikNCj4gPiArew0KPiA+ICsJLyoN
Cj4gPiArCSAqIFREWCByZXF1aXJlcyBlYWNoIFRETVJfSU5GTyB0byBiZSA1MTItYnl0ZSBhbGln
bmVkLg0KPiA+ICsJICogVXNlIGFsbG9jX3BhZ2VzX2V4YWN0KCkgdG8gYWxsb2NhdGUgYWxsIFRE
TVJzIGF0IG9uY2UuDQo+ID4gKwkgKiBFYWNoIFRETVJfSU5GTyB3aWxsIHN0aWxsIGJlIDUxMi1i
eXRlIGFsaWduZWQgc2luY2UNCj4gPiArCSAqIGNhbF90ZG1yX3NpemUoKSBhbHdheXMgcmV0dXJu
cyA1MTItYnl0ZSBhbGlnbmVkIHNpemUuDQo+ID4gKwkgKi8NCj4gDQo+IE9LLCBJIHRoaW5rIHlv
dSdyZSBqdXN0IHRyb2xsaW5nIG1lIG5vdy4gIFR3byAqTU9SRSogbWVudGlvbnMgb2YgdGhlDQo+
IDUxMi1ieXRlIGFsaWdubWVudD8NCg0KSSdsbCByZW1vdmUuDQoNCj4gDQo+ID4gKwkqYXJyYXlf
c3ogPSBjYWxfdGRtcl9zaXplKCkgKiB0ZHhfc3lzaW5mby5tYXhfdGRtcnM7DQo+ID4gKw0KPiA+
ICsJLyoNCj4gPiArCSAqIFplcm8gdGhlIGJ1ZmZlciBzbyAnc3RydWN0IHRkbXJfaW5mbzo6c2l6
ZScgY2FuIGJlDQo+ID4gKwkgKiB1c2VkIHRvIGRldGVybWluZSB3aGV0aGVyIGEgVERNUiBpcyB2
YWxpZC4NCj4gPiArCSAqDQo+ID4gKwkgKiBOb3RlOiBmb3IgVERYMS4wIHRoZSBtYXhfdGRtcnMg
aXMgNjQgYW5kIFRETVJfSU5GTyBzaXplDQo+ID4gKwkgKiBpcyA1MTItYnl0ZS4gIEV2ZW4gdGhl
eSBhcmUgZXh0ZW5kZWQgaW4gdGhlIGZ1dHVyZSwgaXQNCj4gPiArCSAqIHdvdWxkIGJlIGluc2Fu
ZSBpZiB0aGUgdG90YWwgc2l6ZSBleGNlZWRzIDRNQi4NCj4gPiArCSAqLw0KPiA+ICsJcmV0dXJu
IGFsbG9jX3BhZ2VzX2V4YWN0KCphcnJheV9zeiwgR0ZQX0tFUk5FTCB8IF9fR0ZQX1pFUk8pOw0K
PiA+ICt9DQo+IA0KPiBUaGlzIGxvb2tzIG1hc3NpdmVseSBvdmVyIGNvbXBsaWNhdGVkLg0KPiAN
Cj4gR2V0IHJpZCBvZiB0aGlzIGZ1bmN0aW9uIGVudGlyZWx5LiAgVGhlbiBjcmVhdGU6DQo+IA0K
PiBzdGF0aWMgaW50IHRkbXJfYXJyYXlfc2l6ZSh2b2lkKQ0KPiB7DQo+IAlyZXR1cm4gdGRtcl9z
aXplX3NpbmdsZSgpICogdGR4X3N5c2luZm8ubWF4X3RkbXJzOw0KPiB9DQo+IA0KPiBUaGUgKmNh
bGxlciogY2FuIGRvOg0KPiANCj4gCXRkbXJfYXJyYXkgPSBhbGxvY19wYWdlc19leGFjdCh0ZG1y
X2FycmF5X3NpemUoKSwNCj4gCQkJCSAgICAgICBHRlBfS0VSTkVMIHwgX19HRlBfWkVSTyk7DQo+
IAlpZiAoIXRkbXJfYXJyYXkpIHsNCj4gCQkuLi4NCj4gDQo+IFRoZW4gdGhlIGVycm9yIHBhdGgg
aXM6DQo+IA0KPiAJZnJlZV9wYWdlc19leGFjdCh0ZG1yX2FycmF5LCB0ZG1yX2FycmF5X3NpemUo
KSk7DQo+IA0KPiBUaGVuLCB0aGVyZSBhcmUgbm8gc2l6ZSBwb2ludGVycyBnb2luZyBiYWNrIGFu
ZCBmb3J0aC4gIEVhc3kgcGVhc3kuICBJJ20NCj4gT0sgd2l0aCBhIGxpdHRsZSBhcml0aG1ldGlj
IGJlaW5nIHJlcGVhdGVkLg0KDQpZZXMuICBXaWxsIGRvLg0KDQo+IA0KPiA+ICsvKg0KPiA+ICsg
KiBDb25zdHJ1Y3QgYW4gYXJyYXkgb2YgVERNUnMgdG8gY292ZXIgYWxsIFREWCBtZW1vcnkgcmFu
Z2VzLg0KPiA+ICsgKiBUaGUgYWN0dWFsIG51bWJlciBvZiBURE1ScyBpcyBrZXB0IHRvIEB0ZG1y
X251bS4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBpbnQgY29uc3RydWN0X3RkbXJzKHN0cnVjdCB0
ZG1yX2luZm8gKnRkbXJfYXJyYXksIGludCAqdGRtcl9udW0pDQo+ID4gK3sNCj4gPiArCS8qIFJl
dHVybiAtRUlOVkFMIHVudGlsIGNvbnN0cnVjdGluZyBURE1ScyBpcyBkb25lICovDQo+ID4gKwly
ZXR1cm4gLUVJTlZBTDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgLyoNCj4gPiAgICogRGV0ZWN0IGFu
ZCBpbml0aWFsaXplIHRoZSBURFggbW9kdWxlLg0KPiA+ICAgKg0KPiA+IEBAIC00NTQsNiArNTEx
LDkgQEAgc3RhdGljIGludCBidWlsZF90ZHhfbWVtb3J5KHZvaWQpDQo+ID4gICAqLw0KPiA+ICBz
dGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiA+ICB7DQo+ID4gKwlzdHJ1Y3QgdGRt
cl9pbmZvICp0ZG1yX2FycmF5Ow0KPiA+ICsJaW50IHRkbXJfYXJyYXlfc3o7DQo+ID4gKwlpbnQg
dGRtcl9udW07DQo+IA0KPiBJIHRlbmQgdG8gd3JpdGUgdGhlc2UgbGlrZToNCj4gDQo+ICJ0ZG1y
X251bSIgaXMgdGhlIG51bWJlciBvZiAqYSogVERNUi4NCj4gDQo+ICJucl90ZG1ycyIgaXMgdGhl
IG51bWJlciBvZiBURE1Scy4NCg0KSW5kZWVkLiAgV2lsbCBkby4NCg0K
