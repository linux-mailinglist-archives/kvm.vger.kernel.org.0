Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409FC60ECC0
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiJZXwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiJZXwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:52:00 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB95EE0AF;
        Wed, 26 Oct 2022 16:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666828319; x=1698364319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XNxI0SMMAAsjT7qvLlAMklet1zLiCmn9/n7KLQtItxk=;
  b=HbQ+GYf41Ql0leJo+wmU3FRbo7ipE+oGRoFsPwAt1q0bVA5snTI6DZGx
   27tYp5zYXdPwGQrHeclHSWw1YlHdaefwrs0h71xMM9h6FCboDpui8WJ2Y
   Ge7sB+eHjses9jIWsxMG6mC9U3jPr0LQOOLvKWDs0MeCdYlXBVlgKQ3nw
   oBpS1GJXGEtZut5GYdVrY5FhUiO7OOhuNvUcNbjlR5AaOYncYJ3lYbOcR
   w8k/GsFOHM9e5qEiIIprMvskExPumqMJTVvfNZ5XdDYGbbLgmhPWH0Fzd
   RvQeiODOJzeY3tRZc8EmvIKZRpM0yFVCnoGs8M6Fb+50/A0LuFQ/bCh1A
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="288485200"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="288485200"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:51:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="807248091"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="807248091"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 26 Oct 2022 16:51:58 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 16:51:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 26 Oct 2022 16:51:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 26 Oct 2022 16:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Muaus0aipe4WROs86XtW9DmkQ7PR+6Gm5T5HQXul2e3Oshc27e9Sy9zU8W18SOj9OhLdInWj/Da4mhwzwt2kz79R2P52zCqlnrIOizszUog8BSshZNeYxehZqQetH2Y5hZYpZob+gA578IT9X/iHAgIG2+gU1ADAatzoNvdC80eof0PEVWPgzTlIuKUUv/wAN4Y5V8qwW0UOkOGCoDXulN9v1JH+n/CW7cBh5kmR9IBStMd9AP0SY5ReVqiER2g/VmqQ3B+Ntm1RlrqhnY5Lmi3TzvyH+bt81ROJ7x3z+QQY2SkrAQwoS69myP2ZDJUFcxYnUaWV/YBcK8PV0lOdzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNxI0SMMAAsjT7qvLlAMklet1zLiCmn9/n7KLQtItxk=;
 b=GuckifNDQfLKWev7uYgunKRJMGFlF80zUHgYV8Sqctl1yrt1fIEsSn5KHGpUcaaw5DSpaYpIlrIkF1f9sfVnrbrbnki/546ms9WXs5bnDgk6DPyQYbnF5+AkEmqyXHAAlBmYeUS5uPqJ7UkNlrpr2SUNrMA/K1B68cco8HfECvnyU6j+4Q20H2ByBesNSxEJHj1ziKT6oT7Y5lSF1QRBriC00YtwSkDCIorSSx5pJKgoNZYEL50HdN8CKEhoISbpDR1gTZHJuPOECOQL0OZUtLLITc530OCHxJ2EQvHiys69+XsepLnIkmiUDIJaPxXdXd4OpltlvBP4KtdVF+RRZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7138.namprd11.prod.outlook.com (2603:10b6:806:2a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 26 Oct
 2022 23:51:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Wed, 26 Oct 2022
 23:51:53 +0000
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
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 00/21] TDX host kernel support
Thread-Topic: [PATCH v6 00/21] TDX host kernel support
Thread-Index: AQHY6Y2bTREFjnLhrkmd1Pu5PGAu7q4hUYkAgAAHMwA=
Date:   Wed, 26 Oct 2022 23:51:53 +0000
Message-ID: <81713166f9a6163feea8323c1cccf0b3602f3732.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <fb2d1c23-df8b-4f7f-ce3f-25ba9076e5fb@intel.com>
In-Reply-To: <fb2d1c23-df8b-4f7f-ce3f-25ba9076e5fb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7138:EE_
x-ms-office365-filtering-correlation-id: 8496c195-ec9c-492e-d55e-08dab7ad0f0b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KY0jzs71QRJWnfP6mz3a1dQQEicS+FeBW4lRNWqAqzWP/W2Hipr4np/m4+ftsoZUIsvoJrrwr/YZZTAi/xGDug8gYPdbdXZfYOVrOUtcQB+OgaFvbqhrIMFVHgyYCmuseAcqSk3jEPaTQCFCTvyG9npmQpDGKFL1TrjfxMwfHi0SyH0RZgDYCN/v5du5v8BvwVUJpqXp3sx7jhDchRtkpcphFZjDIUSmU/zz8e/L0ocDLx8Rc0P0+jcJZYhNZb5V0jbrFkqEe8Z62U+ZaWdqJHFwh1prasUVsUPpKOykt4OOAUbLJMQHMDWJ3UYJKdfjc+K+sjD7LARL030ybY68uZiu+C+x5aQqz/3WQRh4GFNiDIZMI3iPyVv6JTRPVRDUFP0mC5J9rRjbnto1ztTmoc9Rm5ER61RTdQh2mT/LEhPmB76GaFCLlAot5qKm0WtixEwnJn8ASYjwSsmeltdAC8GeQWNzIxeScVYRX2RmoI9bhUvigHEHVBW9fwbkllpu+GT2PI7o2WJyy0Vel+B5M0qHDoRc1q3HGxjUUIKIy7DBbwI25AwX7le4+Bxbg5bPKYB6azlyLcGBq7+Wf06zWrYAykjxe+UilKAAI8hyR5fWtDL1t/zzD+mSI5RTKXB1m4XbDC7ZzEkx+KyX2H1vXOHr2H1eFNm0dlvV52o7mKBknI2MxXsqJ7dmxErQO/PBvesGwYuUAt/XAtC7TEVXpI0/abWnf0jwdpsjVHS62XG9Gm22r+vJ5gF2LAkGEQrVKyYyzQCw3J/SeDvqI81fmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199015)(71200400001)(478600001)(316002)(86362001)(36756003)(6486002)(5660300002)(6512007)(6506007)(66946007)(8936002)(2616005)(53546011)(76116006)(110136005)(54906003)(26005)(122000001)(38100700002)(8676002)(4326008)(41300700001)(2906002)(66446008)(64756008)(91956017)(66556008)(82960400001)(4001150100001)(38070700005)(66476007)(186003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUZVMHNlWVFESXBnRXkvTkFWZ01LNXEzNk0rZytTOXAwVVJPbDJNM09TZ0Vk?=
 =?utf-8?B?WEdaM1B5eU9OMUg1TENBNjNRNVgxWGV6YnU0Vng5cTduZWx5ZUJIa1hxODE4?=
 =?utf-8?B?R3VKajVyc2FLeTJDcUZ4ZkpTck15T2lGekY3OCtHenQ0Mzg5aWdhMDVCTC94?=
 =?utf-8?B?Z3J6OGZRSHhrMDBIN1p6d0d0TzBpc3B2Wng2SDAwWkFycnV6TE0zNUx6WXVx?=
 =?utf-8?B?ek5tcmM1M3JXblp0SnI0RkI4VEpzZGdibmk3TXhDMFNycnhUTTJCOFhYRWRh?=
 =?utf-8?B?RzA0MW5vdGt2a3RkZ1RuTnFjTlJNbTlhVEY5Z1JKekYwaVhxN2ZzR0JZMWhH?=
 =?utf-8?B?Y3h1Ni96TVRSeVdVQlFHVHFsYS81cHYxZDhDbjFCWlVwcUpsbitpazk5YWhR?=
 =?utf-8?B?WTRTYkJpVHBQK2JhQ1FJS3J2U0VIMkREVjlWVjY2RkdZRTNRTitlZHVFdXBH?=
 =?utf-8?B?YndjeDFvSTFsRGVobkJMZkxlZUJzZ2ZSKzg3Yzg1L2FmM0hnVXVxWlNTR3hY?=
 =?utf-8?B?UUI0K1p5MUxxY3FoUDN6dm9KMFYvU1cvdGdVa3YzSU5uSmg5QTJQdE51WVM0?=
 =?utf-8?B?S1E2L0JnaEkzZUp4Wmc4Wmp0OGxOWDkzTkZyaEtPeHdWUHVQbERwU1J1WE5t?=
 =?utf-8?B?V25xOWZZSlRpSnZaOUwvT240NnZtWjFnQVhabUVUNWNaLzA0Q3BsTG9zQ3p0?=
 =?utf-8?B?RUtxcGUvNjFzemxXemZ4QkpHbEZsam1la2luTTJiTm1EN1R3bzN4VWtacGNk?=
 =?utf-8?B?Nm13Y09rV2toODNsVUo3V0djRFBPUFJiN2htcVhxN3MxZ2xTT0RYQStQNXlO?=
 =?utf-8?B?MlZuRGRrUHVNY05VTnZ1S1U3QzJRenorclJMV1dKNDVhTXBTNWoySTNHbW9N?=
 =?utf-8?B?cEJ2UXkwVFcrSy9ndTFIL2E4ZTBCL0hBRWFBdGtEZVMxbnJvdUdNZk9HUGRl?=
 =?utf-8?B?eGRrU21pS0VIcWh2NThNdzlzRnFDVk42Z2hDek1QWVNFOGdNbFJRbUhJdkJB?=
 =?utf-8?B?Q2RUU2h2MUd0SUp6RzRNZFMvdW9qWjhxNEJIT0ZRSWdCYkRkTDBQbkhzVGVR?=
 =?utf-8?B?dmxiQkNrbk1PelhxOGpPeG9FRTZJc1ZNdzJJNG1xWGxoYzNPbThUSTVRWDkv?=
 =?utf-8?B?V1o3OVVFbUNoMERlMGlVTzBCMUdreHlHalNTL3NrVTFqZXlhdHpMcGdPa3F6?=
 =?utf-8?B?aUdkV0c1S2hWd3UzRU9OeHlON3BNb1RUZHpIZytrZFVLVWI4elFLc0Y1OVRD?=
 =?utf-8?B?NElmekx6N2xoeUhDVjE2aGlBREdsdk9UVE90dkVmZ3lFNXJaZUxMSHgzUDlD?=
 =?utf-8?B?NlBLWlJXM1E3YndOK3JuUDNZVW9EN0hZUXF6UFNIWUxtK243U2ZmT08yc2ZD?=
 =?utf-8?B?ODMwMjZzQWdtTEswNitnN0cvVGR3S2F1S0xRY002QXdOUUIyOUxNcHFBZUR4?=
 =?utf-8?B?Y2lxRWJObmNFdUFza0xTektZWi9vRGZLUW9mL3I1cDBqUHEwQUpwaDBRRjI5?=
 =?utf-8?B?NVdUQjc1dXNFYlV1M3Y0b1RiWk9qL0ZLM3BXOHk4MUJaWW4xaHRUZzZWdDk1?=
 =?utf-8?B?VHljNk9tZkltdGRIL0hPUGhqU0ZKalNpRHc1a1YvNmZ2Z3F4Y1pDYVN3Smt0?=
 =?utf-8?B?T096bjFDOVRFMUdwQ0tNZmpYUzR3OG94OHE2RVU4cWF2VlhSN3VGRW5zU2ty?=
 =?utf-8?B?dktNY2xiUW9qWnROMjJHM0lQT0F5cytMTHVMVk84OTA2YWVlT1Y5OGQvdmZQ?=
 =?utf-8?B?TkN4b3RHNFdlR0FwdmY4UExhRFJNK1VlU0ZSVWFNa096cno5d0crTzhTdGNh?=
 =?utf-8?B?MWxVZktnUGxoaVVOTFBHenZGUGw1TUM3T2xZbjdPMXljSFF4VExoZVd2RG1z?=
 =?utf-8?B?Y1piRElWUExKR1hKZlNGVzRKOGg2UzhuZVVZMzBoYkxJU3Q5ZU1MNlB5ekpq?=
 =?utf-8?B?SjRsVW5mTjVHQkNHN3o3c3ZmTU9rcVpWVXBhYzFLalJYRkUxa3NqV2JVTnRR?=
 =?utf-8?B?WCt6R3NlejZROGVWZFNiUEFKNTNWSFJPcHhJd2dzR0JRSUJianRISUpCdW1t?=
 =?utf-8?B?MjNjOTVRWHgwcE14T2xHc2M1M1FObWpCMklSL0ZoOWxsVUxXVjlWS0N1SGVY?=
 =?utf-8?B?eEhNUTduelkvaDkrL0wyaHhSWE5vSDEySkVIMk42M3VnemdTZnhLMUtqUTFm?=
 =?utf-8?B?U2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7351702E07B80A4F9D3B396EB1DAD108@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8496c195-ec9c-492e-d55e-08dab7ad0f0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 23:51:53.5536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MOszS501/cz6XTux0Wfat7mguI0IYbS5QstiOlXdep7EHw+697kbNmNvsVw4t/J/bNs9IDl5DBupS8goXBpxGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7138
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTEwLTI2IGF0IDE2OjI2IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMjYvMjIgMTY6MTUsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBUbyBrZWVwIHRoaW5ncyBz
aW1wbGUsIHRoaXMgc2VyaWVzIGRvZXNuJ3QgaGFuZGxlIG1lbW9yeSBob3RwbHVnIGF0IGFsbCwN
Cj4gPiBidXQgZGVwZW5kcyBvbiB0aGUgbWFjaGluZSBvd25lciB0byBub3QgZG8gYW55IG1lbW9y
eSBob3RwbHVnIG9wZXJhdGlvbi4NCj4gPiBGb3IgZXhtYXBsZSwgdGhlIG1hY2hpbmUgb3duZXIg
c2hvdWxkIG5vdCBwbHVnIGFueSBOVkRJTU0gYW5kIENYTCBtZW1vcnkNCj4gPiBpbnRvIHRoZSBt
YWNoaW5lLCBvciB1c2Uga21lbSBkcml2ZXIgdG8gcGx1ZyBOVkRJTU0gb3IgQ1hMIG1lbW9yeSB0
byB0aGUNCj4gPiBjb3JlLW1tLg0KPiA+IA0KPiA+IFRoaXMgd2lsbCBiZSBlbmhhbmNlZCBpbiB0
aGUgZnV0dXJlIGFmdGVyIGZpcnN0IHN1Ym1pc3Npb24uICBXZSBhcmUgYWxzbw0KPiA+IGxvb2tp
bmcgaW50byBvcHRpb25zIG9uIGhvdyB0byBoYW5kbGU6DQo+IA0KPiBUaGlzIGlzIGFsc28ga25v
d24gYXMgdGhlICJob3BlcyBhbmQgcHJheWVycyIgYXBwcm9hY2ggdG8gc29mdHdhcmUNCj4gZW5h
YmxpbmcuICAiTGV0J3MganVzdCBob3BlIGFuZCBwcmF5IHRoYXQgbm9ib2R5IGRvZXMgdGhlc2Ug
dGhpbmdzIHdoaWNoDQo+IHdlIGtub3cgYXJlIGJyb2tlbi4iDQo+IA0KPiBJbiB0aGUgc3Bpcml0
IG9mIG1vdmluZyB0aGlzIHN1Ym1pc3Npb24gZm9yd2FyZCwgSSdtIHdpbGxpbmcgdG8gY29udGlu
dWUNCj4gdG8gX3Jldmlld18gdGhpcyBzZXJpZXMuIMKgDQo+IA0KDQpUaGFuayB5b3UgRGF2ZSEN
Cg0KPiBCdXQsIEkgZG9uJ3QgdGhpbmsgaXQgY2FuIGdvIHVwc3RyZWFtIHVudGlsIGl0DQo+IGNv
bnRhaW5zIGF0IGxlYXN0IF9zb21lXyB3YXkgdG8gaGFuZGxlIG1lbW9yeSBob3RwbHVnLg0KPiAN
Cj4gDQoNClllcyBJIGFncmVlLg0KDQpPbmUgaW50ZW50aW9uIG9mIHNlbmRpbmcgb3V0IHRoaXMg
c2VyaWVzIGlzIGFjdHVhbGx5IHRvIGhlYXIgZmVlZGJhY2tzIG9uIGhvdyB0bw0KaGFuZGxlLiAg
QXMgbWVudGlvbmVkIGluIHRoZSBjb3ZlciBsZXR0ZXIsIEFGQUlDVCB3ZSBoYXZlIHR3byBvcHRp
b25zOg0KDQoxKSB0byBlbmZvcmNlIHRoZSBrZXJuZWwgdG8gYWx3YXlzIGd1YXJhbnRlZSBhbGwg
cGFnZXMgaW4gdGhlIHBhZ2UgYWxsb2NhdG9yIGFyZQ0KVERYIG1lbW9yeSAoaS5lLiB2aWEgcmVq
ZWN0aW5nIG5vbi1URFggbWVtb3J5IGluIG1lbW9yeSBob3RwbHVnKS4gIE5vbi1URFgNCm1lbW9y
eSBjYW4gYmUgdXNlZCB2aWEgZGV2ZGF4Lg0KMinCoHRvIG1hbmFnZSBURFggYW5kIG5vbi1URFgg
bWVtb3J5IGluIGRpZmZlcmVudCBOVU1BIG5vZGVzLCBhbmQgdXNlIHBlci1ub2RlDQpURFggbWVt
b3J5IGNhcGFiaWxpdHkgZmxhZyB0byBzaG93IHdoaWNoIG5vZGVzIGFyZSBURFgtY2FwYWJsZS4g
IFVzZXJzcGFjZSBuZWVkcw0KdG8gZXhwbGljaXRseSBiaW5kIFREWCBndWVzdHMgdG8gdGhvc2Ug
VERYLWNhcGFibGUgTlVNQSBub2Rlcy4NCg0KSSB0aGluayB0aGUgaW1wb3J0YW50IHRoaW5nIGlz
IHdlIG5lZWQgdG8gZ2V0IGNvbnNlbnN1cyBvbiB3aGljaCBkaXJlY3Rpb24gdG8gZ28NCmFzIHRo
aXMgaXMga2luZGEgcmVsYXRlZCB0byB1c2Vyc3BhY2UgQUJJIEFGQUlDVC4NCg0KS2lyaWxsIGhh
cyBzb21lIHRob3VnaHRzIG9uIHRoZSBzZWNvbmQgb3B0aW9uLCBzdWNoIGFzIHdlIG1heSBuZWVk
IHNvbWUNCmFkZGl0aW9uYWwgd29yayB0byBzcGxpdCBOVU1BIG5vZGUgd2hpY2ggY29udGFpbnMg
Ym90aCBURFggYW5kIG5vbi1URFggbWVtb3J5Lg0KDQpJIGFtIG5vdCBlbnRpcmVseSBjbGVhciBo
b3cgaGFyZCB0aGlzIHdvcmsgd2lsbCBiZSwgYnV0IG15IHRoaW5raW5nIGlzLCB0aGUNCmFib3Zl
IHR3byBhcmUgbm90IG5lY2Vzc2FyaWx5IGNvbmZsaWN0aW5nLiAgRm9yIGV4YW1wbGUsIGZyb20g
dXNlcnNwYWNlIEFCSSdzDQpwZXJzcGVjdGl2ZSB3ZSBjYW4gZ28gb3B0aW9uIDIsIGJ1dCBhdCB0
aGUgbWVhbnRpbWUsIHdlIHN0aWxsIHJlamVjdCBob3RwbHVnIG9mDQpub24tVERYIG1lbW9yeS4g
IFRoaXMgZWZmZWN0aXZlbHkgZXF1YWxzIHRvIHJlcG9ydGluZyBhbGwgbm9kZXMgYXMgVERYLWNh
cGFibGUuDQoNClNwbGl0dGluZyBOVU1BIG5vZGVzIHdoaWNoIGNvbnRhaW5zIGJvdGggVERYIGFu
ZCBub24tVERYIG1lbW9yeSBjYW4gYmUgZW5oYW5jZWQNCmluIHRoZSBmdXR1cmUgYXMgaXQgZG9l
c24ndCBicmVhayB1c2Vyc3BhY2UgQUJJIC0tICB1c2Vyc3BhY2UgbmVlZHMgdG8NCmV4cGxpY2l0
bHkgYmluZCBURFggZ3Vlc3RzIHRvIFREWC1jYXBhYmxlIG5vZGVzIGFueXdheS4NCg==
