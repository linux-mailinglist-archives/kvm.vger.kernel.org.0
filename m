Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5183F66366A
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 01:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjAJAtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 19:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbjAJAt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 19:49:28 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9A018B0C;
        Mon,  9 Jan 2023 16:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673311768; x=1704847768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zh8iwb4Sncz3SBb9D8jMSeAgnl1usf+yKRKp0FbkSzU=;
  b=gJj26xv1F794N2pasEWTFFWMtYWdI9Tci+Y39OJdEvr44HryAoGnfkOD
   eE6owFmqstbzxAbEt2QzKzJxrn/3LlhcNyMnw79Cp4NgU+jpPa2McZkSn
   6l5COzX13VeyGttxG04INIIxOpkRNKL9LHQTkpwfA4syjuTwZRyuoD+9K
   tiILpW5tt+lYBNmu3BNDJ2k/Jys2uO6Hl147gK+pMppjWo3F6xa/lY1Fn
   YliS2N7kDUVH/Z5AXo3/xqts3KOsAXQJvNyH/H3jIxCv3urIjsZr58c0a
   S12j6VKM2iCSuz15I7eydJrn8tPvkTo5qrcHK0hvj6C40hrywMaj4TLpi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="302722066"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="302722066"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 16:49:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="902189456"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="902189456"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jan 2023 16:49:25 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 16:49:25 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 16:49:25 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 16:49:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhSjjI83QL3jyU2II26qOVFL0/iDlsANzzAnEgAvWE7fKjkra3Jipij2lG3ihyOQ5qb6+RZvJkaeZpiv41R9h34VR6bHssuUCIkDNKuZKN2XP+35oslB6gs0550jP7aODo00LN7zkElvd0p1ShbVz0s+1soHBdahBGWYxvJdpXYfHj1OqQ+dqDcrt9WMpw4JRbNVioKrlZIUIH9ks0XACSNXnU5fXLqJp3pXYEzGkANeTC0+QhcaEUqyEIr1i31kmD7Gr7buaBHr4ooHYgCfvyFPGsnR68dMNkz1ZBr9jz+NDQibC2t3DuvLHluZ5iPHRk02qYt820Cv8Dx6EPHEwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zh8iwb4Sncz3SBb9D8jMSeAgnl1usf+yKRKp0FbkSzU=;
 b=Vf/VUNJsYAnAi/aKRtc6OWBR5ZVjbSe9daIlFvIUhYY/HuEnVbI+jJfC1S+6DHWsTZrX2Zbrl6iAY+dK4J645iYMLQPemuMusuBEo3Pz7mjfXHSodFHGxYGBG8LczJLakqKTDRL6rcyqb3hIT6Gk3oWO5Drg9DOxlAD/HdFUO56+6U8w5AGsJ1C4jjEXgdDCOCz8pc01ZW2su+VQdDj1+fXRUU2jfyDBwEjvDSJXsWV3tsh8RmyVtRCwBeZ1yf1GLnQ1LFSkewINR3Bsa37xHNhreE/a4mZx4tS7Z18WdhDk6Z6EyK2fDKEll9oC4W8l5oRnsEMVjkxus5yWDEDw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5034.namprd11.prod.outlook.com (2603:10b6:806:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 00:49:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 00:49:21 +0000
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
Subject: Re: [PATCH v8 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v8 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZC5gV8r8yaJynIESTR6K7FpCOGa6SG3wAgAToEwA=
Date:   Tue, 10 Jan 2023 00:49:21 +0000
Message-ID: <3eefbf7831239e76c93be30e536d34578fa2909f.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <76a17c574da18c10ad7a4f96e010697aaa5f7c04.1670566861.git.kai.huang@intel.com>
         <50ad132f-463f-3b61-6aab-b96a57b6f3a1@intel.com>
In-Reply-To: <50ad132f-463f-3b61-6aab-b96a57b6f3a1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5034:EE_
x-ms-office365-filtering-correlation-id: abb3c5b6-282d-4fc1-27be-08daf2a48301
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YuOF2J7X1jn/z2VcLS/L+sr22uPUsbecwV2MGN69T+LMMjzTbE7HCp8e72vQwhaDTZt9mvz8y41lZvqqM0Xrcyi2EYrOC+s5L21yA0JWk6H2rnlT+kIef4TGoD/uMqAYc5bSwvDNPHjfzvdYVMW1fIAgumJAGP1ZwZhCNNKxgi0ZmR2RxrNnNYznK8GRsK3dpq4WXivqphGMVckKdAZ1OU8fxQ9ZJK8IJEtE4MsgRv3wsNYcqxvAlBGU3VOgfVxiioPig6ntLssiL/GKaSvCWElCzEofZVUQQ4dI+3pFZsogafXVrdMV8nUuMtrwk4hlmwxwZFJy3gI3B0uphcE9oZcmwDYD1X3BaPdOxUHA1Eb1hRVSXKd0tyibSWkdIklE3jrv6pyv2swY7Rh8YPSreJ7HDWHaIAT0f851a76kdgMoCjHNqmtdHHeZqkDAJzCL+18otHtmzbd69h2jNJ+rkJBiNyZChSAVidH8zK0rQgViRXSpOMmUOm7lOL1w3kaG28ciRLVMdDj0HCO2WBX64+OLlY7m1FfJH+0zxvWZyVuVj5ZTP/ZiEQcAZERAO4TbNH96HidYy0ojVJRYZs5Ved8uZgI7KoUEXr9hoK3iuY9Qb5ah89x8gKx0n80sKI17V4snMl4Yb4iPTeZnDrBJX0rG9OC2PMPVfOSqruNVRViBjdU0dyl4rdWR1S/pwIGEfjuSpAvs+qV8rtZkJX9B88pcD+igMkSiZZw420T3kyA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(8676002)(7416002)(71200400001)(316002)(5660300002)(26005)(6512007)(6486002)(478600001)(186003)(2616005)(41300700001)(66946007)(76116006)(4326008)(110136005)(66476007)(91956017)(64756008)(66556008)(54906003)(66446008)(8936002)(36756003)(38070700005)(86362001)(6506007)(122000001)(82960400001)(38100700002)(2906002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzFrR0JsdXVlSmFsekJVVUlUTWMyNXRhdTNTY1ZUODBTOGNFMjVEMFFXalhx?=
 =?utf-8?B?MTJqeWowbWpDZHMrNnYxQmJwL3RoUWNtUnREZ2t1c2RSYzNVRHNSZnlOMWxy?=
 =?utf-8?B?aEJLMzkyY1FVQXIzcDloQXU5VzE5ZkFKQ1N0MzZjTGlETVFIWm8zWExzbDU1?=
 =?utf-8?B?TXBQZm1hZk1sb1VOTjNTZGJqMWNxYTRHdUgwN2dSMXIyVlVYT3FCeVJETlhz?=
 =?utf-8?B?VFE2Qzdlb2tjOXZOaUI4a1h1bDE2bTQxNVFNZ0dtV2dpNFh0UDErMU1EMENn?=
 =?utf-8?B?RkNOZTRNbGJCUzdwU3k1UXl0bms5ZjRFaHIrT2VXdFN2Z1VyWmlGb0FhYSt3?=
 =?utf-8?B?c3ZQNGhWeWc1WnBwMDVkbjRWNytSeURRSkdSNk42K1lTRFhYTWVBOE56RXZH?=
 =?utf-8?B?QXBESnZ3SjAxUlNPTHY1WjJvNExySjRxZFdsb2ZUaUpSRDl4OXFiSjRMNkNH?=
 =?utf-8?B?YU5RQXFuMDk3RC9sLzYwRTNsU0RTQ0tMVkRZTjhCdUpSVGVzR0ZVLzFQTS9i?=
 =?utf-8?B?ZjlObW04cWRvMzFBb3pNaFNrcEl5S1NjaDJUN1JkSjlZWDkxcnk1am5uNWJP?=
 =?utf-8?B?R1VHVzJrRCswOFVZc3NPbnduUitoMm41WG5qaFEyOXlaRzlyQm1jL1BoL2lF?=
 =?utf-8?B?dDdiWTIvdXlxUllhdkFkZHNrdGpqVkJBTzk0YXpaVFA5Nk5OVDQzaWMyb0ls?=
 =?utf-8?B?cjg1OU5UNzEyYUlDbmNKeC85MHJGOXFWcnFwcUYyc3Z0bVBNeUNla2lBeVp0?=
 =?utf-8?B?OU9CVTA0bHlTeUZtT0crdC93TWE5M1dLd29SWFdlUGxwVHVaUnhvUU80N3JW?=
 =?utf-8?B?Rm9kVmxUTHBQdkk1V3hOK082NkNTOHB4aFk2R3lXY0RMeHJLTmljTjhmSXBs?=
 =?utf-8?B?UnAvdGUxQzlGL25RdFBGNnlaQmNQWVhIRFo0TXlocGpibWYyY1o2REJVbzE0?=
 =?utf-8?B?Uk56NDU1M2RjRTRocjR6MEk2N1hFR1RPNkFIekRDQno5ckY1c3ppR0JvTlBV?=
 =?utf-8?B?dWxCUTRzaFR5VVF1QWphNVpKN1NhbDkzT1dianJlb1lmK0NBR01HNS93WUpW?=
 =?utf-8?B?RlZGSHgzN1JRZERTSnJobWdDbnZDVXhIVGpUeFRtU1RreHpJbnArMGNqVmRs?=
 =?utf-8?B?emtTeGFvYmcwcGpOd013YXdoc0kvRnVkbVMraGRSU0lDbEFRUEJqV1FFMnhk?=
 =?utf-8?B?UFdYNHdicWkzZC83ZnZCcCtaUkZZNm5nTzJ0eGVQOWRmQmxtcHNQN29FY0pP?=
 =?utf-8?B?SHJ0bUdCUDZDVU9zamc0bWtjUHUzSTJNR0dVOE1JMEJWY09pckFNVUU5NStO?=
 =?utf-8?B?SnUrVUhwaHVGYU1LU1BxS3psVHdOTHhWY0lCbEhKQXRQZGtmTGNBcVR3ckVQ?=
 =?utf-8?B?bEZkOGJ3RHVWQWpQU0FlSVlMdUMrcEFRK3hHcm4xL2RzUjllTzhWV2lxcjNM?=
 =?utf-8?B?V3hrY0cxWVBWQUQ3MmlYMWVSOWg2NXhnclZxVVJYR3NBTC9KYjJGVGRHaTdZ?=
 =?utf-8?B?K1ZoVnlYU2xVc3F4Zkt1ZTlZMGt1LzhUWGhCUUEzeFhVRWJQL1hTbis4Ly9D?=
 =?utf-8?B?Z3Z6YnZvRHRwT2dDemZ0MjZ6ZG9xU2NMWERxa29OM0EycDR4b1h3N3hMVXpl?=
 =?utf-8?B?aTRVblhQSXdOeE5ybUxsRjc2NjJWV1dqR2dNVThmdzZSY3VValdVY3V1OTZk?=
 =?utf-8?B?Q21RZUdYWmlRKysxekJzSUZDZVdwMFB2UFpTVWh6TTgrQXZvbVBCUUUxc1pt?=
 =?utf-8?B?RmdIb3ZPOWpjODdVeG5MZWpPVEJxZEo5ekNpTFVqc3V2RXJBZlQwUTlxWU5H?=
 =?utf-8?B?N0JyTzVPUGIrMUQ3V004cmk2RGszY3N0SHBCcjRBLzI1ZVI0UzNuMzJJeVFy?=
 =?utf-8?B?akVQSUJwSEpaWUxKWHFreU9velg1R0ZVTVNqZjN3UmRYSVBpM1AwdTV4d3ZN?=
 =?utf-8?B?K2daTWc1UkxlT2JSMTRmSlY2OWhSZVlOVHdKbW5xQTNIYU9ra0Nuakl6VHBa?=
 =?utf-8?B?NnFpWThPVUxMTnRpQ0xwNFk3R21kcWU5WGN0Zmw5cFVDWUZneHRRQkdmdks1?=
 =?utf-8?B?c0d5WEkySGFaYVphdWtva1Z3MHp5dnpTNGtoT3c2d3NCd2FtcTJtT2o2VFRD?=
 =?utf-8?B?Vko2SEtsOTZCZi81dk5tbVdseWVjWHFXeVRTVFMyZGx4VjhZS1dNWUtJVURC?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3747EDEB5F7A349824046FCF48445DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb3c5b6-282d-4fc1-27be-08daf2a48301
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 00:49:21.2483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d5uhYWavOPrcq7OJRKfGcWoBYw/5J8GPPahiIq0bwruezmspyki3ps/Y0GTSLP4fi607kcxc6Mw0kNtOJ5Pf3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5034
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDEzOjUzIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
TG9va3MgZ29vZCBzbyBmYXIuDQo+IA0KPiA+ICsvKg0KPiA+ICsgKiBBbGxvY2F0ZSBQQU1UcyBm
cm9tIHRoZSBsb2NhbCBOVU1BIG5vZGUgb2Ygc29tZSBtZW1vcnkgaW4gQHRtYl9saXN0DQo+ID4g
KyAqIHdpdGhpbiBAdGRtciwgYW5kIHNldCB1cCBQQU1UcyBmb3IgQHRkbXIuDQo+ID4gKyAqLw0K
PiA+ICtzdGF0aWMgaW50IHRkbXJfc2V0X3VwX3BhbXQoc3RydWN0IHRkbXJfaW5mbyAqdGRtciwN
Cj4gPiArCQkJICAgIHN0cnVjdCBsaXN0X2hlYWQgKnRtYl9saXN0LA0KPiA+ICsJCQkgICAgdTE2
IHBhbXRfZW50cnlfc2l6ZSkNCj4gPiArew0KPiA+ICsJdW5zaWduZWQgbG9uZyBwYW10X2Jhc2Vb
VERYX1BTXzFHICsgMV07DQo+ID4gKwl1bnNpZ25lZCBsb25nIHBhbXRfc2l6ZVtURFhfUFNfMUcg
KyAxXTsNCj4gDQo+IE5pdDogcGxlYXNlIGRlZmluZSBhIFREWF9QU19OUiByYXRoZXIgdGhhbiBv
cGVuLWNvZGluZyB0aGlzLg0KDQpXaWxsIGRvLg0KDQo+IA0KPiA+ICsJdW5zaWduZWQgbG9uZyB0
ZG1yX3BhbXRfYmFzZTsNCj4gPiArCXVuc2lnbmVkIGxvbmcgdGRtcl9wYW10X3NpemU7DQo+ID4g
KwlzdHJ1Y3QgcGFnZSAqcGFtdDsNCj4gPiArCWludCBwZ3N6LCBuaWQ7DQo+ID4gKw0KPiA+ICsJ
bmlkID0gdGRtcl9nZXRfbmlkKHRkbXIsIHRtYl9saXN0KTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+
ICsJICogQ2FsY3VsYXRlIHRoZSBQQU1UIHNpemUgZm9yIGVhY2ggVERYIHN1cHBvcnRlZCBwYWdl
IHNpemUNCj4gPiArCSAqIGFuZCB0aGUgdG90YWwgUEFNVCBzaXplLg0KPiA+ICsJICovDQo+ID4g
Kwl0ZG1yX3BhbXRfc2l6ZSA9IDA7DQo+ID4gKwlmb3IgKHBnc3ogPSBURFhfUFNfNEs7IHBnc3og
PD0gVERYX1BTXzFHIDsgcGdzeisrKSB7DQo+ID4gKwkJcGFtdF9zaXplW3Bnc3pdID0gdGRtcl9n
ZXRfcGFtdF9zeih0ZG1yLCBwZ3N6LA0KPiA+ICsJCQkJcGFtdF9lbnRyeV9zaXplKTsNCj4gDQo+
IFRoaXMgYWxpZ25tZW50IGlzIHdvbmt5LiAgU2hvdWxkIGJlIHdheSBvdmVyIGhlcmU6DQo+IA0K
PiA+ICsJCQkJCQkgICBwYW10X2VudHJ5X3NpemUpOw0KDQpXaWxsIGRvLg0KDQo+IA0KPiA+ICsJ
CXRkbXJfcGFtdF9zaXplICs9IHBhbXRfc2l6ZVtwZ3N6XTsNCj4gPiArCX0NCj4gPiArDQo+ID4g
DQoNCltzbmlwXQ0KDQo+IA0KPiBPdGhlciB0aGFuIHRoZSB0d28gbml0czoNCj4gDQo+IFJldmll
d2VkLWJ5OiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPg0KPiANCg0K
VGhhbmtzLg0KDQo=
