Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE09640586
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiLBLL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBLLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:11:47 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BCCCFE77;
        Fri,  2 Dec 2022 03:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669979506; x=1701515506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jFna1NQPX5Br1ReRFClbb5zJo77L8odB5Mls7oeiOKk=;
  b=YWtSp89L5pmSUVaNTmNYmJhJnRvXiz2DDxf+HcEJj9X2KjxW1MGj3Gun
   MvhpcPtSvl9hqfWSA39QNoIhMPux5WAyrjYWGgb33DnUywn/qtBApfuv6
   W5tkGNNMfNStgID8LzMKxO676dhhc3qTZwJg9UUxObTsoqamgl3J9P8mJ
   +vS3J3sXZcr+5icn9L1PepeI79DJNidHD6P1bl/h4ooKqWSNfACmfdmxL
   p0LBgmsH8kon0CpGD7AZvu/LaGWdNQ1+fhP212j1yQQPycSUpIiJIpcj8
   qFYMLyR1f6FVkCtje5/IU/OeN5RgMbXGXDokKZo9ZLgjStk0PvZn9ZJuR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402211880"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="402211880"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 03:11:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="595419358"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="595419358"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 02 Dec 2022 03:11:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:11:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 03:11:45 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 03:11:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTzjqKlOOEP0DIc6MU9ZckUTMB89/ZoEM5a1fdhHEip9AKZjCza0ersak3kUP7kJzQRaLJFVEcOXUrCrXwLkExbpvbvbg+WQ+Ui1bFLmfvjmFeQBtj9LCn3t0IpYsuLkQ4FHAPh8FgatqGFr0ubybWUg+4KBvPfbyweyEP6EyllMk0LUsZngf693MPaAAcsaM1VxJhQhAnZoIvKeW6piP0MNsjl99uPtQSGpDb1uje4CiNZZ87xHwmbMouiqL/O9yk8L3HAUAWFm/8VXdFqOVScR5BzuUqF+2wYedf9TKXeS7IuF6ep6DKo7QmlG0Usa2bAfkzFpRlJdoP1m+MZA1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFna1NQPX5Br1ReRFClbb5zJo77L8odB5Mls7oeiOKk=;
 b=OGOHoMWBQf1o73qPqhb7u1b+Iwkb6w+Gkd2A7nj2La/TYufw6TOmmUhHYHQaEaXQLqM0vwXLMf5qeCTbXUl65YWfX6jP/YKghqDthEkO1IDl8zn8Yd1ZTCfNE2MeIM2BKeALouWPWHy2t3FNqXTRzugd0xEwpTV3ZhlG1IgAEPgGihtGMZp2SzzmEJek0QR62sNqJPISeqvJ7VvnmesjkfA7pG0LErzZcI2YcjFd22B/JCGY4yEHaDA/zJlASiW1dHeRZ+uw/DQWBtHEG5CUOp9v/03nsO8xUToAzLEfZtSkEKnQR0SRExV49hot4JjqsFTNhk2tNpDOI9py9KyRZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5797.namprd11.prod.outlook.com (2603:10b6:303:184::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 11:11:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 11:11:40 +0000
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
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHY/T3BkERrb6yHxUStNPJD5vkcxK5LnNIAgA7mZAA=
Date:   Fri, 2 Dec 2022 11:11:40 +0000
Message-ID: <8f3b1492aefc37f6bdcd8a10051af57c7deb4430.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
         <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
In-Reply-To: <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5797:EE_
x-ms-office365-filtering-correlation-id: 48e7a729-8dbb-4d8a-62f3-08dad455fd01
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QqrCWFiePDOxkj8+dtopNtS77VJneiyVqkDVnHIciOcYnXbVORcAr2y7Z6yDBCvjxN8TdU9sc58Z71zZaQwILroMDJ04OM9xMK+90EZa1crh46tRbMIr5kp2UtEoMzjhUukGFFxNTxsXENwACyzChP1xoWLQ0bIdVtDAQfJT04xTu23l+p5XBrgEgKd3rIWH+RMQZhYFQubX3GZhixrrXziMkyNWGew1T8yDbp9RCXmjHuIsRMs5GTbr31yQM8Qhk2sKDztlFtJDIzOLMN8TKVyVw4cC7xHBLAQkxkEpG5J8THm0gWnn3KWZ00/tT7lC4OaeLpOPvhU54kGyuMcoBY+QL9RfKQBt2MbGPj6PaAMhCO9TmKGeAOsks8oMjq8VZihU1IMbl3qql9aczJU1fJSlQwtLg9Qw9dOhfETLsiNQe8L82t/Zp5t+8cLb/BorM+4wXZGLn1utbub2guJRwfgm/MRsUnWRMCO1MllrlwzwSHR53u6o7M/IJicdfsBQNLC0VQhzIcmeH0yTrNQr+zu98dXaJN/yvfDhleEs9AvzV9QZJmJPG+qCHHSTyeVtlsdDT21sb8tBHFbCVj6LNF8ezFGgYfcb2kOLcCvwDm9DPy4J0hyAq28EFC3wAH6kAyNJ9DY3h5tuAvWMYvKb1Lw9DxcPn0hgaxnNvQhWnsP5VbV0/Z4yqd+30lSQE0nZ7a+2bSHTXLwQDF0Qu1htxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(2906002)(4001150100001)(5660300002)(7416002)(41300700001)(8936002)(66476007)(76116006)(8676002)(4326008)(54906003)(36756003)(66946007)(110136005)(64756008)(66556008)(66446008)(91956017)(316002)(71200400001)(26005)(478600001)(86362001)(6512007)(2616005)(186003)(82960400001)(6486002)(122000001)(6506007)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KytJeHVSd2EyRzNrZzFrSVo2TFNRZ3kvQW1aRlBrNUE0UktrVVNhWVZwVGFC?=
 =?utf-8?B?bGFObnlDOTlSYTgwUTdOVmZjL3ozbDRaV21HbmlrU3IxblQ2M3F5Nmhjdk9T?=
 =?utf-8?B?Z2RneHRGQTU4d1hZZVk4ZDFRanNQQmNwdzZOandIdm80aGx3eGdRaXBwWkZF?=
 =?utf-8?B?ckJhUndiK2Y5eGhhdzREb3dsZ0FmMDU2MUxUTkkxS2dQbnl5R2NNYzlRc2JL?=
 =?utf-8?B?WnMvSEV1TmNnSFBjMG1rOVJmRkNOb05uNTJ2QjFQSHFLQm0zNEhCSytYMkha?=
 =?utf-8?B?NHR6OHUzNWwzbEQwbWQ3Z1l6V05ZVjRmZFpWdWttV2lETFdwcmxvSjdJZFRS?=
 =?utf-8?B?bC8xRWwxbE02T3RYQmVyN1NDeFp3YjRjUHpkdDZuUUcwdU8yOE4vL0FraWJL?=
 =?utf-8?B?RS83TnY4Q3M1dThhV2FZVXErc3IzbldUNXYrYThiQU1HdDVOTHpOaXUyZ01U?=
 =?utf-8?B?bGVGMXhhUTRBbWZXeWN1WXZ0R3Vnd0g2M1dDSE8rZnFieTRsc1RuK01nZVZ3?=
 =?utf-8?B?REtNM3NkN01DSTlNRUdnNXBrTEJoVTMvK0VDK1REUy9QWEdFcTJXdWErWFdH?=
 =?utf-8?B?Q0lFYXJzV3JTTlkxbTlHM2ZWdkdUdkNheDg0Sk1LSGNiN3NsSWVnakcvSXlk?=
 =?utf-8?B?VldZcXVYaEZBajAyTERsS3kxajE5RXhUWFdqdEo3NmlSNlc1YlloRGZ3Qk85?=
 =?utf-8?B?M1JWZGo0VTNZQTRuanN0cXhOOVNleHZMTDh2Y2RJV2VVeVVwdHd6M0xlVEVM?=
 =?utf-8?B?UFh2RHBvWGxVUEMwOXJ3cVpvazEvcjJvU01nYlVNNlVON05xeGNWVHZMc1N6?=
 =?utf-8?B?S2ZqNWsxZmRFVWhYQVJKMk0zVTU0WHhSRE03WExJVDYxSVJJcjlpQzFDYzhl?=
 =?utf-8?B?SVliUjNveWEydG53Y1FUMnA4RWFiYnlXbmh6UG56ajB4UlhPdUpCM3l5Ynpn?=
 =?utf-8?B?ZEVQME5IZXVyV01BVmZldG9GU1lrWHJsMEJDWDZ0N21WOFVuT2syOFRMU004?=
 =?utf-8?B?VXk3ZXlIcTZzR0NKOGt3ZytGYS9jMm9OYkNxZDUxSC9GZlZyK2VTMlhIMGtX?=
 =?utf-8?B?YUhDd1lKQ0ZHRTNhaXJBaERrVXBuaHN0Z0xlclMreENLUCtpNUZHZzJ6Q2xX?=
 =?utf-8?B?czJEa3lHamtKY3J0cjdjVjR0ZVhzT1YvZ3N3cDBxRGF3Q0k0SHBKamkxQTFh?=
 =?utf-8?B?bEY2T0pTWTUwVE9sVWJYQUsyQTMyOU0vd1pKanA0V09qTWxsdVNWMXZIVzNq?=
 =?utf-8?B?OUlLNk8vRU1hcUdkdFZlall2dnhtKzhXV1dwZldsNFdnTzFicFNhSi9xZk9l?=
 =?utf-8?B?R3JPdG9CL2JScXFRR053Sm54a3Z1dGhQR3ZLNGFoR3R6K2dmWW4wdWRCc1Bx?=
 =?utf-8?B?KzVWQ05WTUxoQmhrTVl3WXQzNmxjTWwzOG9EaW5yRVdjUkttcTZXZ3NuVHIx?=
 =?utf-8?B?eGpXYXlzSEd1RUo5Rmo0R0NmS0V5WHNNZ2tyT3FOL21pVWtweTY3YnFHNHJl?=
 =?utf-8?B?MWhtK2dFdVowdVNvTEhaenJtSWpuMS85b1JKeVBDVWlWZ3ZpMlhrYTBmWktG?=
 =?utf-8?B?WVFoRzQzbElGNnlpYzN0SHZRZFVweDN5ZStiM0QvU2lQdHl6N0twVVl1aC9i?=
 =?utf-8?B?Q0NJR003akFKK2ZtUWh6YytWRVVKYjM5MFdCWWhNa2U2WGh6K3NvM0orempv?=
 =?utf-8?B?aS91dS9kN3JtNmtCZDRsRGhtMFVKT2d5L1E2T2VqV2xwUnhEbHoxalpwR0xs?=
 =?utf-8?B?Zy9hcVEza2lPQ0JUZWVKRHdCeHdiTjg2ZVY0YVVGVlZsTitNbmY2dDQ4cEtz?=
 =?utf-8?B?ajhVcjlSNFR3dER5RW8vUmp5cGNBM1BjcUoxSXJsVnN0b0NYZUw3dWdmemU1?=
 =?utf-8?B?WnptMm9vSVdySlJPd0ptLzVWbGJFQkNaMDJPZk5mU0Y0eW42VUxWc0ZBclYv?=
 =?utf-8?B?Y2pCWDV1SEpFNE9VbFZhT1VJV1lnRjNyQUtIWFBDR1hkK01hSXlsWTRKVnpF?=
 =?utf-8?B?cGl2TlBhR2owR0Q4UFhiT1RtRmZBb05XUzhCa2hSdTcrWGdENFd4amRXZmlN?=
 =?utf-8?B?dS96VC9zak9RSVJpcVZWa0RDNkpMS0JvMjFUNFB5cHZ5ODF1RWdUd1dxNlln?=
 =?utf-8?B?TkM1cVBod29sWDJDTkl0QnhvNlJuZC9lemtTRHZPa2J3VEpsOUZlY2FTU1dy?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2BA649B97762744811EDBF2248958F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e7a729-8dbb-4d8a-62f3-08dad455fd01
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 11:11:40.7913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mYb2utJp7LskjXnLKlLoXlUgMtf5sYQM2tXwsmsOVD2P8aEawUQTkV8ahYnbwh5pVv9yZt5fSc5ovL6afg8lPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5797
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDE1OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiArI2RlZmluZSBURFNZU0lORk9fU1RSVUNUX1NJWkUJCTEwMjQNCj4gPiArI2RlZmluZSBURFNZ
U0lORk9fU1RSVUNUX0FMSUdOTUVOVAkxMDI0DQo+ID4gKw0KPiA+ICtzdHJ1Y3QgdGRzeXNpbmZv
X3N0cnVjdCB7DQo+ID4gKwkvKiBURFgtU0VBTSBNb2R1bGUgSW5mbyAqLw0KPiA+ICsJdTMyCWF0
dHJpYnV0ZXM7DQo+ID4gKwl1MzIJdmVuZG9yX2lkOw0KPiA+ICsJdTMyCWJ1aWxkX2RhdGU7DQo+
ID4gKwl1MTYJYnVpbGRfbnVtOw0KPiA+ICsJdTE2CW1pbm9yX3ZlcnNpb247DQo+ID4gKwl1MTYJ
bWFqb3JfdmVyc2lvbjsNCj4gPiArCXU4CXJlc2VydmVkMFsxNF07DQo+ID4gKwkvKiBNZW1vcnkg
SW5mbyAqLw0KPiA+ICsJdTE2CW1heF90ZG1yczsNCj4gPiArCXUxNgltYXhfcmVzZXJ2ZWRfcGVy
X3RkbXI7DQo+ID4gKwl1MTYJcGFtdF9lbnRyeV9zaXplOw0KPiA+ICsJdTgJcmVzZXJ2ZWQxWzEw
XTsNCj4gPiArCS8qIENvbnRyb2wgU3RydWN0IEluZm8gKi8NCj4gPiArCXUxNgl0ZGNzX2Jhc2Vf
c2l6ZTsNCj4gPiArCXU4CXJlc2VydmVkMlsyXTsNCj4gPiArCXUxNgl0ZHZwc19iYXNlX3NpemU7
DQo+ID4gKwl1OAl0ZHZwc194ZmFtX2RlcGVuZGVudF9zaXplOw0KPiA+ICsJdTgJcmVzZXJ2ZWQz
WzldOw0KPiA+ICsJLyogVEQgQ2FwYWJpbGl0aWVzICovDQo+ID4gKwl1NjQJYXR0cmlidXRlc19m
aXhlZDA7DQo+ID4gKwl1NjQJYXR0cmlidXRlc19maXhlZDE7DQo+ID4gKwl1NjQJeGZhbV9maXhl
ZDA7DQo+ID4gKwl1NjQJeGZhbV9maXhlZDE7DQo+ID4gKwl1OAlyZXNlcnZlZDRbMzJdOw0KPiA+
ICsJdTMyCW51bV9jcHVpZF9jb25maWc7DQo+ID4gKwkvKg0KPiA+ICsJICogVGhlIGFjdHVhbCBu
dW1iZXIgb2YgQ1BVSURfQ09ORklHIGRlcGVuZHMgb24gYWJvdmUNCj4gPiArCSAqICdudW1fY3B1
aWRfY29uZmlnJy7CoCBUaGUgc2l6ZSBvZiAnc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QnDQo+ID4g
KwkgKiBpcyAxMDI0QiBkZWZpbmVkIGJ5IFREWCBhcmNoaXRlY3R1cmUuwqAgVXNlIGEgdW5pb24g
d2l0aA0KPiA+ICsJICogc3BlY2lmaWMgcGFkZGluZyB0byBtYWtlICdzaXplb2Yoc3RydWN0IHRk
c3lzaW5mb19zdHJ1Y3QpJw0KPiA+ICsJICogZXF1YWwgdG8gMTAyNC4NCj4gPiArCSAqLw0KPiA+
ICsJdW5pb24gew0KPiA+ICsJCXN0cnVjdCBjcHVpZF9jb25maWcJY3B1aWRfY29uZmlnc1swXTsN
Cj4gPiArCQl1OAkJCXJlc2VydmVkNVs4OTJdOw0KPiA+ICsJfTsNCj4gDQo+IENhbiB5b3UgZG91
YmxlIGNoZWNrIHdoYXQgdGhlICJyaWdodCIgd2F5IHRvIGRvIHZhcmlhYmxlIGFycmF5cyBpcyB0
aGVzZQ0KPiBkYXlzP8KgIEkgdGhvdWdodCB0aGUgWzBdIG1ldGhvZCB3YXMgZGlzY291cmFnZWQu
DQo+IA0KPiBBbHNvLCBpdCBpc24ndCAqcmVhbGx5KiA4OTIgYnl0ZXMgb2YgcmVzZXJ2ZWQgc3Bh
Y2UsIHJpZ2h0P8KgIEFueXRoaW5nDQo+IHRoYXQncyBub3QgY3B1aWRfY29uZmlnc1tdIGlzIHJl
c2VydmVkLCBJIHByZXN1bWUuwqAgQ291bGQgeW91IHRyeSB0byBiZQ0KPiBtb3JlIHByZWNpc2Ug
dGhlcmU/DQoNCkhpIERhdmUsDQoNCkkgZGlkIHNvbWUgc2VhcmNoLCBhbmQgSSB0aGluayB3ZSBz
aG91bGQgdXNlIERFQ0xBUkVfRkxFWF9BUlJBWSgpIG1hY3JvPw0KDQpBbmQgYWxzbyB0byBhZGRy
ZXNzIHlvdSBjb25jZXJuIHRoYXQgbm90IGFsbCA4OTIgYnl0ZXMgYXJlIHJlc2VydmVkLCBob3cg
YWJvdXQNCmJlbG93Og0KDQogICAgICAgIHVuaW9uIHsNCi0gICAgICAgICAgICAgICBzdHJ1Y3Qg
Y3B1aWRfY29uZmlnICAgICBjcHVpZF9jb25maWdzWzBdOw0KLSAgICAgICAgICAgICAgIHU4ICAg
ICAgICAgICAgICAgICAgICAgIHJlc2VydmVkNVs4OTJdOw0KKyAgICAgICAgICAgICAgIERFQ0xB
UkVfRkxFWF9BUlJBWShzdHJ1Y3QgY3B1aWRfY29uZmlnLCBjcHVpZF9jb25maWdzKTsNCisgICAg
ICAgICAgICAgICB1OCBwYWRkaW5nWzg5Ml07DQogICAgICAgIH07DQogfSBfX3BhY2tlZCBfX2Fs
aWduZWQoVERTWVNJTkZPX1NUUlVDVF9BTElHTk1FTlQpOw0KDQpUaGUgZ29hbCBpcyB0byBtYWtl
IHRoZSBzaXplIG9mICdzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCcgdG8gYmUgMTAyNEIgc28gd2Ug
Y2FuDQp1c2UgYSBzdGF0aWMgdmFyaWFibGUgZm9yIGl0LCBhbmQgYXQgdGhlIG1lYW50aW1lLCBp
dCBjYW4gc3RpbGwgaGF2ZSAxMDI0Qg0KKGVub3VnaCBzcGFjZSkgZm9yIHRoZSBUREguU1lTLklO
Rk8gdG8gd3JpdGUgdG8uDQo=
