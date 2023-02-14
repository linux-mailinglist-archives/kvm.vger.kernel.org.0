Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D416970E9
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 23:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjBNWxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 17:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjBNWxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 17:53:36 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69F28D31;
        Tue, 14 Feb 2023 14:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676415214; x=1707951214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=169UoWuXKJHSFopwoIdybG9TOO8wkIrx8dv5fHDQXaw=;
  b=BdJnIYgBA+L52AZR/BbGfS1ttG+bHrM69thuCSt3HFMWJHuYBtHPYboM
   7z4EgeB2PH9n5O7JAXjKqZ1QsGQTJ9S3tQunhUJNPOh1XyaaZleUafwz7
   Mo8cGngCFWlz6pO2+J+G/HlXv67PU2nqy40wHGOGYUfEtCmnPLU0ky+dx
   ESj8Q/YTsU1Gbin+w55FCnQa3dekjYbhYn5s8YlkWKDy59iMC4w4gsNb2
   aYuofxjTN6oa815JeRw96MZYbORoDXktZTUTWanjpRmjHisjnSmskEKg5
   yTHgOIL0DJIASsDogaMNW9+x5W7Lpu1BQHaDnDgwBMe8sEs2oOtUzxCBI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329919548"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="329919548"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 14:53:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699725446"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699725446"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 14:53:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 14:53:30 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 14:53:30 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 14:53:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaolP9lg3wf/0K5jJokzUSYzHzl5ffJtMHyVvBA5dKa8rV+6pbQ7nRnQbieG1GM6Zk3Vl8bPelRzuziZjg44xqoQ/7qkGnJw0KufX09aWPr76MUJkRVaLfkydeGQmK7PXELVhslfzRjjlorqehGwarIVQcwufyYdg/WP4aBEqUizTQa7OCamrjw1qpKwJ4FDPfbSnSMSihmSmqAmhr11cFjn8bwCnCi4BFKsa++siK0xHFlDQSflwzS7sYR9I/CaAP/K26gf4fGruE4Bf1e8urfJ2u2xQpnaP1iV9wmtWdNf7TO/pyyB8ntMsFrhY7LGDb8bK1wJUJH9GxvKTv0mFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=169UoWuXKJHSFopwoIdybG9TOO8wkIrx8dv5fHDQXaw=;
 b=eRQ4tCxOvLB+tZGag0msJf370QaVyNroZi76L+aGxi5HRoDP22WbrpWJNEJULE0eApVv4oQtX205+PWxfvDHBxCFSNuEfTbOmZIUoumxz5QLOcWuOFpe6mLKpSVfSEdQULkm5+COrWPGJuy6gbvRvhNxKrmUJ9yKDGt3rxGn1GhmCx4Zx3hTHV9CqFXr7+avJOKO8jlu/rbLhiBVOtJeviQg6A5ov5ktWeeaaZ9jKJy/bgCq+LvKf6S/hccOC9+0w+9s+OshQbBgoi4xzcp5FFDITiV1IdQMk0CTVDGFYVqL0LWSNmV60Ew6pkCWQV59/sVRuGYFa8sGbDz8za+jfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6055.namprd11.prod.outlook.com (2603:10b6:510:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 22:53:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 22:53:26 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NKpCAgAA2qfCAABiqAIAAFhiAgADtdoCAAJGdgA==
Date:   Tue, 14 Feb 2023 22:53:26 +0000
Message-ID: <0795f69fd0ff8ccdd40cc7a3d6cc32da47e6d929.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
         <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
         <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
         <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
         <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
         <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
In-Reply-To: <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6055:EE_
x-ms-office365-filtering-correlation-id: 8ab643ae-48af-43d4-8296-08db0ede485b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J7/wDwtLXAOIlJVOEmawfEZLR2AxVohYLxXJrytrGslVeMDU6a9PCsZPcwzOsuQxiu5hvMBAk41BdnT/wVGFbm4zObfA1Z3FLYkH8AGV9McbCiGL1ngRQxmJaCk4F1Fi2JqFYNH5ag+riNUuutE7a0rVNOJ93JiD9A6X325shKv4wmmsSYkEU4KCCr8Nyf6HmJ9ZZMX3V5nOtpLdtyuI1islYjCFLA1ZlUOh1/xVebTqRfYyOozIoVvLbW6y396Fo3Gh/S3on/5QUzCUZYS/cJoe9lMHzoe57tKjnr7Omf/5M/yADgi4+4/woTfN1uWdvGhCBYySOwYc+XqM7miie1m5U52Cis4a9aLCWtF/+9IBJJgwywq7emvfxw96VP27jUtoYQ8u3p0iHiGyTspcUoCP7/MsB4PEbiAJv4k5ilFQod3UjhWnS/BzqQX48Ris0K9ZSit7nPaYXfcqh7rXRCyzA9+JzB6sVGCL7HEHR8FDUjqCGpVRkABgjfIr4tW/6akzTH/wg2MbceZlZGGR4embhdCUHEiQWg9YrvZujYjcSI9V+QUnzytHOc4ZMEECH0vqWLRXjqHQFJhKD5/EsZEle6uwS/EwZHvmkDblPxZFrQgcLdWZoDYE9f2xFCQsPnLojYNnIGDezs6Jv5OFXeCV+cAS67AJn3t0ffMkKhfOAYuQG1HtoIRW/1KO99WN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199018)(82960400001)(38070700005)(38100700002)(122000001)(36756003)(86362001)(316002)(478600001)(66476007)(6486002)(41300700001)(66446008)(8676002)(6916009)(76116006)(91956017)(64756008)(4326008)(66556008)(966005)(54906003)(6512007)(186003)(66899018)(66946007)(2906002)(2616005)(26005)(71200400001)(6506007)(8936002)(83380400001)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVUzSDZ1ODBJc3A4c1pyWVRiell0eldZQ2JzaHV3ajQ1K3VSc2QwdzdyOTFk?=
 =?utf-8?B?c1VGZThhenFRTGZBSWczclJQK0NncGtpSTdEUUV3T3JOSWRjcjFwSGhJVHIr?=
 =?utf-8?B?QmNLREFPWERpZjdiemZsVDhpRFdDZGlsdGtCNUl0SlNTemdOUG1adnRCUzlF?=
 =?utf-8?B?WDBLTnRXS2JYNm5XU0RZU0Y5N2ozUVpTS2xXMXlkaWhkTTJnaW11aC85eVRX?=
 =?utf-8?B?NjJwK0JXQVVJNE14WGgyT3lhenFvZFJBVVQxbnRCdDFqT05VL042bWxySVV2?=
 =?utf-8?B?ZmlFdVV2TlEyeXpxRHNsam9hR3lEQk11cjFHVXh0azk2TXZJeEtpbmlKd3pR?=
 =?utf-8?B?Y1ZZSXZvdHVaSk0yL3l1eTYxMWNhT0hNbTFmdktSUlZ6RTVtTkwzNlRUYlN2?=
 =?utf-8?B?TDZHTitRanJXR08rS2JhZDVQTDhkeVJEV1ZadThZRHE1RVdraWNWN2NCWFBj?=
 =?utf-8?B?emlqNXZHNHhaSU1MSGV6TmdiRUdWUUxzN2ViN3lMOE9HRzF1RFV1Y0lOTjZs?=
 =?utf-8?B?aDhXTHhRTVFEc29UU2tPbGZLeXNZekFlcEh6K1FPcjlTZTFtM05URTA0WGts?=
 =?utf-8?B?WWZNL01BWXk4enpGUllDbnlXeDE1R3llQUJVRjFHemN0cFd2MEVRODYvU0xW?=
 =?utf-8?B?ZS9yK3FSdHhIUWMrS0Q5NllRVTcwYkFTbEdOaS9DeDJ0bW11L2R5RjY2UWFQ?=
 =?utf-8?B?aW9SZ1Q5OXVrSDJQQ25RSVBZQWFsb3hSdmVFYitDL29qUVdIcHU2cnd0QitJ?=
 =?utf-8?B?R3hSeEczRjE2cTVwZUlMZ3ZlcE5jc2g4NEZjTkVOMjBIY1hLRGIzSDRHRTdF?=
 =?utf-8?B?QlNVenZFdW1SVTZhYnBEOVovb2Y0NVRNSGxDb1ROd0xDRFhOK0JrTXFKMkp2?=
 =?utf-8?B?UmgyaEhHTmVOWFczdmpUZ3lGT2lnK3R6S0x0TitmOENVM3RtOGJacEdDc0kz?=
 =?utf-8?B?MlpLSVJIZnk1NTVqTXZ6T05WMXdsTlJLS1pJblJzWmI5MXpWenBKRkNiRWtR?=
 =?utf-8?B?ZnZwMHhGYzFSTE5PajBUQ09SUzRsSUVYQkorOTJpVG1MQlUwSEpSdy9wTG5j?=
 =?utf-8?B?MDlCWjMzNUhPZk1EdmJaSEY5UmRHLzlTQlJ2L1orZlRhTnhhci80dVBZbnY0?=
 =?utf-8?B?aEM2M0R3Kzdrc0lXaUlyNDNISEFyQThsTEZLRmd1NnBNU1JxL3orSUUyRkdD?=
 =?utf-8?B?YTZGTXVhQVZXTjhUanJUNDQvbFI5WU92eHNTeDBpYVN6NjI1TnJCVUY5d0dE?=
 =?utf-8?B?enBtK0ZWT0xZMk9ORG1rZklHWm5Ka0crRDNhdlVJNDdHNjJ5aUJMeFMrcVF6?=
 =?utf-8?B?b21yUFVzUVFWYXcxelVQeXZHdEM0dHdQZDAyemJER2hNMGFzeVdKUW5jd3Np?=
 =?utf-8?B?MzVBcm1sb1VIODRQVXk4b1pBT2JOOVphV2JudDBYdG9Xa2ZwREx2eDZ0Y1FC?=
 =?utf-8?B?Vkp5K21HMXNEWllpV0Q4RGxub1QzbGpIT0psVmRkQ0pVQndoTW5IUjhja0Vr?=
 =?utf-8?B?SU96ckxKMnVteUY4cDdKYzlzM3o3T0FpTXV4RVJOTC9leEtGTnlxRGpKdkdM?=
 =?utf-8?B?blNnaFd6MGd6YjVMYytRUGZxcldVb1h6OEY3eXhaaWdQZWRTTit5YTM3MnNY?=
 =?utf-8?B?dmxWUGNBY1JiS3pyQ2t2MkdUcjhtRkhtQUE5ZDJXU3NlN1hHSkZqMjhCanZ0?=
 =?utf-8?B?SW1hL25UWnRyOFJCbnBaWjBGdE1MaTFTL0pGbEttQkd6Qjc3OTRwZVU1SW5B?=
 =?utf-8?B?dUhDcnRTZ0xONE14aTVzL20zZFVoVXZya2JKUHBiUFU0aFJXRTJZcEVlVUJr?=
 =?utf-8?B?VS9OSUpkeWhSdExZZTZXUlQxeFcrRzY1a1JSclFXbnNuK0doSHR4RkhzK0xV?=
 =?utf-8?B?VkljTms1RkhQWUhERGxpQ25TN1dMdjY1NmN6QlZERGtQcGhDcEx0VFJBUXJ1?=
 =?utf-8?B?NDgyd0t4U1l2TkRCMEhvR05PK3dwMFFXOUdHYStOdE1PV3J3TVZRL0VmYUpC?=
 =?utf-8?B?MkFJR0VwVGs5RElORkQyQ2YrSi8vOXVUdzk4SVdWREFJVHhvQjZxSVdEdHdq?=
 =?utf-8?B?VzVYSFlPbGkyQTYzV1BFMXBHVzAwQlA5TUxzNmczMjY4QTBSUFNoVUltOTVQ?=
 =?utf-8?B?aGNobUpORGpPeHIvWVA5WFdPdGErVTdiSFQrUHVWK1o1dTJxZDhQUWVzTUJD?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EEBCDC0B71CDF42B79087CEA92B9FF9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab643ae-48af-43d4-8296-08db0ede485b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 22:53:26.2073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HrwMF9JHK+chAesbDPNOy7DtwpRbAPLYEKItlhhYIAg1wRBn5JSSTmiqfr/8ZE4qVWzcb5dzCSsH7xAFzeGTaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6055
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gDQo+ID4gQnV0IGp1c3QgY2hlY2tpbmc6DQo+ID4gDQo+ID4gTFAuSU5JVCBjYW4gYWN0
dWFsbHkgYmUgY2FsbGVkIGluIHBhcmFsbGVsIG9uIGRpZmZlcmVudCBjcHVzIChkb2Vzbid0IGhh
dmUgdG8sDQo+ID4gb2YgY291cnNlKSwgc28gd2UgY2FuIGFjdHVhbGx5IGp1c3QgdXNlIG9uX2Vh
Y2hfY3B1X2NvbmQoKSBmb3IgTFAuSU5JVDoNCj4gPiANCj4gPiAJb25fZWFjaF9jcHVfY29uZChz
aG91bGRfc2tpcF9jcHUsIHNtcF9mdW5jX21vZHVsZV9scF9pbml0LCBOVUxMLCB0cnVlKTsNCj4g
PiANCj4gPiBCdXQgSUlVQyBQZXRlciBkb2Vzbid0IGxpa2UgdXNpbmcgSVBJIGFuZCBwcmVmZXJz
IHVzaW5nIHZpYSB3b3JrOg0KPiA+IA0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwv
WTMwZHVqdVhDOHdsTHdvUUBoaXJlei5wcm9ncmFtbWluZy5raWNrcy1hc3MubmV0Lw0KPiA+IA0K
PiA+IFNvIEkgdXNlZCBzbXBfY2FsbF9vbl9jcHUoKSBoZXJlLCB3aGljaCBvbmx5IGNhbGxzIEBm
dW5jIG9uIG9uZSBjcHUsIGJ1dCBub3QgYQ0KPiA+IGNwdW1hc2suICBGb3IgTFAuSU5JVCBpZGVh
bGx5IHdlIGNhbiBoYXZlIHNvbWV0aGluZyBsaWtlOg0KPiA+IA0KPiA+IAlzY2hlZHVsZV9vbl9j
cHUoc3RydWN0IGNwdW1hc2sgKmNwdXMsIHdvcmtfZnVuY190IGZ1bmMpOw0KPiA+IA0KPiA+IHRv
IGNhbGwgQGZ1bmMgb24gYSBjcHUgc2V0LCBidXQgdGhhdCBkb2Vzbid0IGV4aXN0IG5vdywgYW5k
IEkgZG9uJ3QgdGhpbmsgaXQncw0KPiA+IHdvcnRoIHRvIGludHJvZHVjZSBpdD8NCj4gDQo+IHNj
aGVkdWxlX29uX2VhY2hfY3B1KCkgZXhpc3RzIGFuZCBjYW4gZWFzaWx5IGJlIGV4dGVuZGVkIHRv
IHRha2UgYSBjb25kDQo+IGZ1bmN0aW9uIGlmIHlvdSBzbyBwbGVhc2UuDQo+IA0KDQpTdXJlLiAg
SSBqdXN0IHRyaWVkIHRvIGRvLiAgVGhlcmUgYXJlIHR3byBtaW5vciB0aGluZ3M6DQoNCjEpIHNo
b3VsZCBJIGp1c3QgdXNlIHNtcF9jb25kX2Z1bmNfdCBkaXJlY3RseSBhcyB0aGUgY29uZCBmdW5j
dGlvbj8NCjIpIHNjaGVkdWxlX29uX2VhY2hfY3B1KCkgdGFrZXMgY3B1c19yZWFkX2xvY2soKSBp
bnRlcm5hbGx5LiAgSG93ZXZlciBpbiBteQ0KY2FzZSwgdGR4X2VuYWJsZSgpIGFscmVhZHkgdGFr
ZXMgdGhhdCBzbyBJIG5lZWQgYSBfbG9ja2VkXyB2ZXJzaW9uLg0KDQpIb3cgZG9lcyBiZWxvdyBs
b29rIGxpa2U/IChOb3QgdGVzdGVkKQ0KDQorLyoqDQorICogc2NoZWR1bGVfb25fZWFjaF9jcHVf
Y29uZF9sb2NrZWQgLSBleGVjdXRlIGEgZnVuY3Rpb24gc3luY2hyb25vdXNseQ0KKyAqICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBvbiBlYWNoIG9ubGluZSBDUFUgZm9yIHdoaWNo
IHRoZQ0KKyAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25kaXRpb24gZnVu
Y3Rpb24gcmV0dXJucyBwb3NpdGl2ZQ0KKyAqIEBmdW5jOiAgICAgIHRoZSBmdW5jdGlvbiB0byBj
YWxsDQorICogQGNvbmRfZnVuYzogIHRoZSBjb25kaXRpb24gZnVuY3Rpb24gdG8gY2FsbA0KKyAq
IEBjb25kX2RhdGE6IHRoZSBkYXRhIHBhc3NlZCB0byB0aGUgY29uZGl0aW9uIGZ1bmN0aW9uDQor
ICoNCisgKiBzY2hlZHVsZV9vbl9lYWNoX2NwdV9jb25kX2xvY2tlZCgpIGV4ZWN1dGVzIEBmdW5j
IG9uIGVhY2ggb25saW5lIENQVQ0KKyAqIHdoZW4gQGNvbmRfZnVuYyByZXR1cm5zIHBvc2l0aXZl
IGZvciB0aGF0IGNwdSwgdXNpbmcgdGhlIHN5c3RlbQ0KKyAqIHdvcmtxdWV1ZSBhbmQgYmxvY2tz
IHVudGlsIGFsbCBDUFVzIGhhdmUgY29tcGxldGVkLg0KKyAqDQorICogc2NoZWR1bGVfb25fZWFj
aF9jcHVfY29uZF9sb2NrZWQoKSBkb2Vzbid0IGhvbGQgcmVhZCBsb2NrIG9mIENQVQ0KKyAqIGhv
dHBsdWcgbG9jayBidXQgZGVwZW5kIG9uIHRoZSBjYWxsZXIgdG8gZG8uDQorICoNCisgKiBzY2hl
ZHVsZV9vbl9lYWNoX2NwdV9jb25kX2xvY2tlZCgpIGlzIHZlcnkgc2xvdy4NCisgKg0KKyAqIFJl
dHVybjoNCisgKiAwIG9uIHN1Y2Nlc3MsIC1lcnJubyBvbiBmYWlsdXJlLg0KKyAqLw0KK2ludCBz
Y2hlZHVsZV9vbl9lYWNoX2NwdV9jb25kX2xvY2tlZCh3b3JrX2Z1bmNfdCBmdW5jLA0KKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNtcF9jb25kX2Z1bmNfdCBjb25kX2Z1bmMs
DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm9pZCAqY29uZF9kYXRhKQ0K
K3sNCisgICAgICAgaW50IGNwdTsNCisgICAgICAgc3RydWN0IHdvcmtfc3RydWN0IF9fcGVyY3B1
ICp3b3JrczsNCisNCisgICAgICAgd29ya3MgPSBhbGxvY19wZXJjcHUoc3RydWN0IHdvcmtfc3Ry
dWN0KTsNCisgICAgICAgaWYgKCF3b3JrcykNCisgICAgICAgICAgICAgICByZXR1cm4gLUVOT01F
TTsNCisNCisgICAgICAgZm9yX2VhY2hfb25saW5lX2NwdShjcHUpIHsNCisgICAgICAgICAgICAg
ICBzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsgPSBwZXJfY3B1X3B0cih3b3JrcywgY3B1KTsNCisN
CisgICAgICAgICAgICAgICBpZiAoY29uZF9mdW5jICYmICFjb25kX2Z1bmMoY3B1LCBjb25kX2Rh
dGEpKQ0KKyAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQorDQorICAgICAgICAgICAg
ICAgSU5JVF9XT1JLKHdvcmssIGZ1bmMpOw0KKyAgICAgICAgICAgICAgIHNjaGVkdWxlX3dvcmtf
b24oY3B1LCB3b3JrKTsNCisgICAgICAgfQ0KKw0KKyAgICAgICBmb3JfZWFjaF9vbmxpbmVfY3B1
KGNwdSkNCisgICAgICAgICAgICAgICBmbHVzaF93b3JrKHBlcl9jcHVfcHRyKHdvcmtzLCBjcHUp
KTsNCisNCisgICAgICAgZnJlZV9wZXJjcHUod29ya3MpOw0KKyAgICAgICByZXR1cm4gMDsNCit9
DQorDQorLyoqDQorICogc2NoZWR1bGVfb25fZWFjaF9jcHVfY29uZCAtIGV4ZWN1dGUgYSBmdW5j
dGlvbiBzeW5jaHJvbm91c2x5IG9uIGVhY2gNCisgKiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBvbmxpbmUgQ1BVIGZvciB3aGljaCB0aGUgY29uZGl0aW9uDQorICogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgZnVuY3Rpb24gcmV0dXJucyBwb3NpdGl2ZQ0KKyAqIEBmdW5jOiAgICAgIHRo
ZSBmdW5jdGlvbiB0byBjYWxsDQorICogQGNvbmRfZnVuYzogIHRoZSBjb25kaXRpb24gZnVuY3Rp
b24gdG8gY2FsbA0KKyAqIEBjb25kX2RhdGE6IHRoZSBkYXRhIHBhc3NlZCB0byB0aGUgY29uZGl0
aW9uIGZ1bmN0aW9uDQorICoNCisgKiBzY2hlZHVsZV9vbl9lYWNoX2NwdV9jb25kKCkgZXhlY3V0
ZXMgQGZ1bmMgb24gZWFjaCBvbmxpbmUgQ1BVDQorICogd2hlbiBAY29uZF9mdW5jIHJldHVybnMg
cG9zaXRpdmUgZm9yIHRoYXQgY3B1LCB1c2luZyB0aGUgc3lzdGVtDQorICogd29ya3F1ZXVlIGFu
ZCBibG9ja3MgdW50aWwgYWxsIENQVXMgaGF2ZSBjb21wbGV0ZWQuDQorICoNCisgKiBzY2hlZHVs
ZV9vbl9lYWNoX2NwdV9jb25kKCkgaXMgdmVyeSBzbG93Lg0KKyAqDQorICogUmV0dXJuOg0KKyAq
IDAgb24gc3VjY2VzcywgLWVycm5vIG9uIGZhaWx1cmUuDQorICovDQoraW50IHNjaGVkdWxlX29u
X2VhY2hfY3B1X2NvbmQod29ya19mdW5jX3QgZnVuYywNCisgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHNtcF9jb25kX2Z1bmNfdCBjb25kX2Z1bmMsDQorICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB2b2lkICpjb25kX2RhdGEpDQorew0KKyAgICAgICBpbnQgcmV0Ow0KKw0KKyAgICAg
ICBjcHVzX3JlYWRfbG9jaygpOw0KKw0KKyAgICAgICByZXQgPSBzY2hlZHVsZV9vbl9lYWNoX2Nw
dV9jb25kX2xvY2tlZChmdW5jLCBjb25kX2Z1bmMsIGNvbmRfZGF0YSk7DQorDQorICAgICAgIGNw
dXNfcmVhZF91bmxvY2soKTsNCisNCisgICAgICAgcmV0dXJuIHJldDsNCit9DQoNCg==
