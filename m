Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2BB635BEA
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiKWLkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiKWLk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:40:29 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878AD109583;
        Wed, 23 Nov 2022 03:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669203627; x=1700739627;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0NJkhGdVYmnkEtRaGk8e57j/TEwVCWNA5ZFGNhZY6xc=;
  b=N57tLssxtoBmwfm4Pf/CDXEW0B7sY+TaogG+RDG3EtZpKnI/EqDdeiUB
   C9aBarrY5Tq4romVTovFvZ96JF+/ckOi3EwamSJJXk1qEdTQUIJ9fFDHj
   zQcFnprzdDLz19v83Wg03PstzlE79DFg+7pS1Hc05lF6gkX7LzwWswL+g
   IxinIdGB6645hDVvUTgiRa3d9rXF1QgBO6pLY/aG0j8u7m162aGqSZZCF
   VxjLVzoK9lUxpBpY8rziSdoZnszlVDmiWrAbYfeufuv5Up4m3O/8qJoMT
   ibJzCERhtKM18UFqldv9JBtcFxq1h2vz0/jK3VdkyRPaRAoSnlRo5H048
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="311676835"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="311676835"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 03:40:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="644089771"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="644089771"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2022 03:40:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 03:40:26 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 03:40:26 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 03:40:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBfayblywGu3tzpX0N/koJp6oYOeibq6PFCf+IP25G412CJSQmAIq+KUVCKrfqyLuTnTMfJw+vSPJ2qV7DGcyERrqR+zG+jZEUYM56Q42AkUkPpGMtIHN4KJZ2HavVcNclprjkUguNYwmI3oP5plrBr98lbxtThttG3zYc/l0TdnrOgWIBxVN4RI/rRLHwT65FmYGCCbXKeiNHHmnlpEDsjKtJMH6ON2KL3NspoEQZp749V/K4qYR3zf2GFPeFivnpjbjwvKQN2XwbKnmhea1owI5qDNuLqSwO6/Yjrsoi0EzdOelB9yuyV+0+M5QNUrTeJR9prz11jm3BWn3Wt/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NJkhGdVYmnkEtRaGk8e57j/TEwVCWNA5ZFGNhZY6xc=;
 b=d6smsDMleEEdkWGY4seDE3HRlLdIF2j4SiHy2mJUUuVe+xi3wL1ROMDRXBl16rfrpLcz1Q28p0XmFFn+KV/zEUshqiKm0J7nv8V1Pc6P9StCjgqB/U3dTVPCe/cGtWhsVKOZ+PA623KbcVIccqg7VtA7Fp9DflPvgmuwJ5uVdGRXRk5xp9q9ufFarK6O7qnF3nZWRhNLpeqvDEKQxfuxlUEsAfGLs1i8RP9UfVYwA2Qcs7HI61Nt6vL/opDstyx6wcyRRVlYaK+eUqEaln7ZSfmcAk1qK07womUnVd2KVw0TnNAX7wAl1Mog/5+yRE1wC6/Ih5gsUSW8+hVHVwXROA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7371.namprd11.prod.outlook.com (2603:10b6:610:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 11:40:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 11:40:23 +0000
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
Thread-Index: AQHY/T3BkERrb6yHxUStNPJD5vkcxK5LnNIAgADJbQA=
Date:   Wed, 23 Nov 2022 11:40:23 +0000
Message-ID: <57af0b96f8a827828b1d64031774962972bfb060.camel@intel.com>
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
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7371:EE_
x-ms-office365-filtering-correlation-id: 9e82acad-ebbd-49e0-9916-08dacd4781d7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NuVb4nu2JZPS2DYENYEkR2reyzbrXCGB0tXDo1vbACnYktCw11RNH0cc9WoKvTrBwKvSSUoBMGRVqA7tRawRBFF+MHpUzK2ZulvMfLQFrBJrFAYfjrkr08oTpQAVXQ0zRmZ1PbYX+awH1/OyrqN4iBgXLcIi0sjVdoX+1B92/MUJp4RGEk9LYl8y/TVUec5Co6+1ZhR1OnlM7AB7Gel2acB1+zvkSWIfcp9JjA6jisiVL98+8NHZqVz7xb80AG+5IiMpcP4iSSntAgR9d/eWxGf5+/caeaOxCdlOJGZMTSvaABfeQqrIinK6turAryv8bG4Zl2QX495dgUfZqLhIAifGLgf8CIhSAkOOJHuQSHwquTvF3g9rjZjEirt31RBsP456kfltSlpOScS3JXMwOqdUsxV2bCNCPvlj6br9mLy4bN4L8+uWTF77Ks0sNJf8OVm+e9xuZ4gz1/0wuRWAArXIVt7emQvk2xdrs1OSlmHpLYQOwF0OPlWjBYYR8+oksmF3A/DTqkpXdypEjyOB/66SfvRAmTypP4R0BZZNUnWANi5cFPNFWpzbBzrAzJadl2FijN2QYVEB5mhbvMa/b52Ib0HNOuYmTqY5VArLn+5dn1upYH/yWXPdRgT+LiAFQKM96yyNN1b8kYO6zINioXkka0OGa/Vpjvk8Ihqchdx1N6S0UQHnGTULAkHcmbEI6HYO8dYCLtYO4/MDegxnfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(82960400001)(122000001)(38100700002)(86362001)(6506007)(38070700005)(53546011)(5660300002)(76116006)(26005)(71200400001)(186003)(66946007)(6512007)(316002)(66446008)(64756008)(91956017)(2616005)(478600001)(66476007)(54906003)(6486002)(4326008)(110136005)(8676002)(66556008)(8936002)(83380400001)(2906002)(7416002)(41300700001)(4001150100001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2QvUURxQWVHSm9HNlJ1Y0x6REtnbmpKRExvUXdHL25rcEZWT1ZHalJJOHZt?=
 =?utf-8?B?d0lZdS9Ub2w2OVhMRGNDd28ySjVxcS9hTnkyd1A2bDMxSngxd2xkWlM1QW83?=
 =?utf-8?B?dmxrcVU5MFl0R21mZk43dmpqUC82TTY5dVlDRWNIeGIwQjAxSlRpVVZHN2VP?=
 =?utf-8?B?MHRhNlV4UTZpVmtaT0FUZG95T1NqeXMxKzZXbVJjWHg3Y1U0eFdGeDJSU2RZ?=
 =?utf-8?B?bEpYRzQzSVRsTUlYS2c4T1hpVjlCVmkrTzhFTUROak1vTitVc0ZTdWVlY1ZC?=
 =?utf-8?B?SGZhODU3Ky9MejJ3QzZlaVpyTkxqZHNzNkFQa0VKaEZVdVR6N285Z1VsTFRn?=
 =?utf-8?B?V3lZM0E4TTJYMlhsdVJqZFdHYU1DR01VcXVWLzNNZHVrNHk3UldCeFlLdXVC?=
 =?utf-8?B?OFpNNnBFRVNwQTVXdGhWOVBYTS95UHZyUHFEVS9TK1N4NC9SbEhoait1N2Zv?=
 =?utf-8?B?RjlybTZabkRtOFM4eXFKdVVRZzM0THNNUXVaNjJ5aDVJeVNjcCtsU0F3ZGM2?=
 =?utf-8?B?Ukk5SVFDMHN1b05iZ3M5ZDNCdEMrY3M0SGV1TU9hZm5lSnI5Y2YxblV1MlZj?=
 =?utf-8?B?R0JFZzV0c0NRYnRlTFFHQ1VNYXlKZmN5d1hBajBVaFRBTllrK0FHbCt0NERJ?=
 =?utf-8?B?WFc3allPRUllTDlFVHMvdExVb2FBWUVuMUVJbUMxWlQ0bm1ybG9hM0xJUFRy?=
 =?utf-8?B?ZHM2OGxTM3dZNFJwU0xlK1c3Z29DKzdiTXQ3cExGclhtdTBOU01NQmZreW1F?=
 =?utf-8?B?VlVJZjdrNXpTK3YyZkNlNGMrNnpwaFUwQkY2dzlyZXpocStxb0dSMnVCKzlM?=
 =?utf-8?B?SGI0UWRHUHRUZVJtQU5tVURZbDJqL2xON0cvRUhWeHN4dW41R1psd1g4anhq?=
 =?utf-8?B?K1hjdzRFR3R1WWtmZXNIeXFrdVBFM3FNcXJyVHBYTUIxMVAyc0pEekRPWHJN?=
 =?utf-8?B?aGFpTXBUcXNtVHB4cktMU0tEWFVNNmVzQ21hK3IxTnorZUhGSkdJQXUxTDBr?=
 =?utf-8?B?MmNFV1dRV0xRV3dyYTVEWSs0TjdVc2ExWnRIV2phWjJLNUgreHZ0R0p4K0Vm?=
 =?utf-8?B?Vm5MUUJMRThoM0NOSHEyOTJ3Q2hGcklIeG9qVktiSkxXNFZsaFpIM3FFQ3Fz?=
 =?utf-8?B?TWFzUlRoN1lIeEhkeEo3eEp1VjdkK1BTVXFPeFI3dXBNRlR3OXJzVzVvMkwx?=
 =?utf-8?B?N3gwamJDQ3FuUk9uL3NERmFUem55VGdkdklvRnpCTzY4YmxIN0VwYnJwWWJ1?=
 =?utf-8?B?a2VaYjdYNEJyWDFLNHNSVjVDMVJ5QVI1a3V3QmYxZjFjNEdDMjQ0cjg2WDVl?=
 =?utf-8?B?NElIV3RtaERFaHQzWFNuamIzbVcxZGFaOXF3dzlpSjBtNHM3RVp0SXc1MWJr?=
 =?utf-8?B?MjV0OHRyc0ZmK28zTnByczhvb1cyaEIzRHMrNXhCMHpQVjRyZS84SFl5SW9C?=
 =?utf-8?B?MXpqZENOM1VVT0p2NytnUXdCdTdTUFZrWDZoMjJobU1DK2pCS2VpUTcweGRi?=
 =?utf-8?B?Zi96cDdGdmgwY0VqSXRCbFhwVGwrUUFPVlBFNW4vYThvcVk3aEplVTZWa2pw?=
 =?utf-8?B?S0dodjROQjl2UGpvSHNKcW1wb2hoUXh0S0ZWRTBRT1NURXQzK016LzZ3emRw?=
 =?utf-8?B?dWw2ZU5uYU15dFNJSC9NQUVld2w0eGduVmtHVFVreTZqYnA4SUNVTG14QVMy?=
 =?utf-8?B?c3RkTzlHb2YxK0lodXBKTHprOFhPRkpqWUhvL21ObWFlT3oxc09Td0dNUDZ2?=
 =?utf-8?B?bGkySnhtRnI4WDF5OWVsUE40UWJHSTE4R1IyYjhIM1RGZlJpRVYwZ1d6U3Jj?=
 =?utf-8?B?cEVmTE5KUHRoZUxaOWMzRjkxdDE0T01jUER2eGR1TmdJU3V4TXppdCtzTW9I?=
 =?utf-8?B?L0lqb2x4MkExMXdWR1hDcTZibWQvNFdEcHQveGo2M1ZIQ2wvVHFlODlqbEdL?=
 =?utf-8?B?TU15VGcxTkxnUlZuc0huWmJGOERIVTNoMnBjZU1LVVhsOTdvU2Y0bFExY1Nq?=
 =?utf-8?B?d2c4VmZzQ2hDRnQ1dlpwU0JTbUJXckNoanBVL2IwSmhuTitkeDZlcGxwQktJ?=
 =?utf-8?B?L3BWNjRGZWdaRzRVSjUzSW5qWGYycXdVTVZldVBaM001Zm5sVVRTL3RiMUVZ?=
 =?utf-8?B?Qm03ZGV5TTdtQ2ltRHYreXJHTTJzUjhDMnB4N2VSNE9ENVR4QUc2eFhMVmsz?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E48014BBA109147B048B0DF6C7897FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e82acad-ebbd-49e0-9916-08dacd4781d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 11:40:23.0952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nWxXabyL0+nEcpBOMESnr7AAUUcBkxaecMEelffOYYEJ+IAczPv3OmCPA6M6gyJEHlQ3nXyIp/KT/ioSQhbURw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7371
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDE1OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggcHJvdmlkZXMgaW5j
cmVhc2VkIGxldmVscyBvZiBtZW1vcnkgY29uZmlkZW50aWFsaXR5IGFuZCBpbnRlZ3JpdHkuDQo+
ID4gVGhpcyByZXF1aXJlcyBzcGVjaWFsIGhhcmR3YXJlIHN1cHBvcnQgZm9yIGZlYXR1cmVzIGxp
a2UgbWVtb3J5DQo+ID4gZW5jcnlwdGlvbiBhbmQgc3RvcmFnZSBvZiBtZW1vcnkgaW50ZWdyaXR5
IGNoZWNrc3Vtcy4gIE5vdCBhbGwgbWVtb3J5DQo+ID4gc2F0aXNmaWVzIHRoZXNlIHJlcXVpcmVt
ZW50cy4NCj4gPiANCj4gPiBBcyBhIHJlc3VsdCwgVERYIGludHJvZHVjZWQgdGhlIGNvbmNlcHQg
b2YgYSAiQ29udmVydGlibGUgTWVtb3J5IFJlZ2lvbiINCj4gPiAoQ01SKS4gIER1cmluZyBib290
LCB0aGUgZmlybXdhcmUgYnVpbGRzIGEgbGlzdCBvZiBhbGwgb2YgdGhlIG1lbW9yeQ0KPiA+IHJh
bmdlcyB3aGljaCBjYW4gcHJvdmlkZSB0aGUgVERYIHNlY3VyaXR5IGd1YXJhbnRlZXMuICBUaGUg
bGlzdCBvZiB0aGVzZQ0KPiA+IHJhbmdlcywgYWxvbmcgd2l0aCBURFggbW9kdWxlIGluZm9ybWF0
aW9uLCBpcyBhdmFpbGFibGUgdG8gdGhlIGtlcm5lbCBieQ0KPiA+IHF1ZXJ5aW5nIHRoZSBURFgg
bW9kdWxlIHZpYSBUREguU1lTLklORk8gU0VBTUNBTEwuDQo+IA0KPiBJIHRoaW5rIHRoZSBsYXN0
IHNlbnRlbmNlIGdvZXMgdG9vIGZhci4gIFdoYXQgZG9lcyBpdCBtYXR0ZXIgd2hhdCB0aGUNCj4g
bmFtZSBvZiB0aGUgU0VBTUNBTEwgaXM/ICBXaG8gY2FyZXMgYXQgdGhpcyBwb2ludD8gIEl0J3Mg
aW4gdGhlIHBhdGNoLg0KPiBTY3JvbGwgZG93biB0d28gcGFnZXMgaWYgeW91IHJlYWxseSBjYXJl
Lg0KDQpJJ2xsIHJlbW92ZSAidmlhIFRESC5TWVMuSU5GTyBTRUFNQ0FMTCIuDQoNCj4gDQo+ID4g
VGhlIGhvc3Qga2VybmVsIGNhbiBjaG9vc2Ugd2hldGhlciBvciBub3QgdG8gdXNlIGFsbCBjb252
ZXJ0aWJsZSBtZW1vcnkNCj4gPiByZWdpb25zIGFzIFREWC11c2FibGUgbWVtb3J5LiAgQmVmb3Jl
IHRoZSBURFggbW9kdWxlIGlzIHJlYWR5IHRvIGNyZWF0ZQ0KPiA+IGFueSBURFggZ3Vlc3RzLCB0
aGUga2VybmVsIG5lZWRzIHRvIGNvbmZpZ3VyZSB0aGUgVERYLXVzYWJsZSBtZW1vcnkNCj4gPiBy
ZWdpb25zIGJ5IHBhc3NpbmcgYW4gYXJyYXkgb2YgIlREIE1lbW9yeSBSZWdpb25zIiAoVERNUnMp
IHRvIHRoZSBURFgNCj4gPiBtb2R1bGUuICBDb25zdHJ1Y3RpbmcgdGhlIFRETVIgYXJyYXkgcmVx
dWlyZXMgaW5mb3JtYXRpb24gb2YgYm90aCB0aGUNCj4gPiBURFggbW9kdWxlIChURFNZU0lORk9f
U1RSVUNUKSBhbmQgdGhlIENvbnZlcnRpYmxlIE1lbW9yeSBSZWdpb25zLiAgQ2FsbA0KPiA+IFRE
SC5TWVMuSU5GTyB0byBnZXQgdGhpcyBpbmZvcm1hdGlvbiBhcyBhIHByZXBhcmF0aW9uLg0KPiAN
Cj4gVGhhdCBsYXN0IHNlbnRlY2UgaXMga2luZGEgZ29vZnkuICBJIHRoaW5rIHRoZXJlJ3MgYSB3
YXkgdG8gZGlzdGlsbCB0aGlzDQo+IHdob2xlIHRoaW5nIGRvd24gbW9yZSBlZmZlY2l2ZWx5Lg0K
PiANCj4gCUNNUnMgdGVsbCB0aGUga2VybmVsIHdoaWNoIG1lbW9yeSBpcyBURFggY29tcGF0aWJs
ZS4gIFRoZSBrZXJuZWwNCj4gCXRha2VzIENNUnMgYW5kIGNvbnN0cnVjdHMgICJURCBNZW1vcnkg
UmVnaW9ucyIgKFRETVJzKS4gIFRETVJzDQo+IAlsZXQgdGhlIGtlcm5lbCBncmFudGUgVERYIHBy
b3RlY3Rpb25zIHRvIHNvbWUgb3IgYWxsIG9mIHRoZSBDTVINCj4gCWFyZWFzLg0KDQpXaWxsIGRv
Lg0KDQpCdXQgaXQgc2VlbXMgd2Ugc2hvdWxkIHN0aWxsIG1lbnRpb24gIkNvbnN0cnVjdGluZyBU
RE1ScyByZXF1aXJlcyBpbmZvcm1hdGlvbiBvZg0KYm90aCB0aGUgVERYIG1vZHVsZSAoVERTWVNJ
TkZPX1NUUlVDVCkgYW5kIHRoZSBDTVJzIj8gIFRoZSByZWFzb24gaXMgdG8ganVzdGlmeQ0KInVz
ZSBzdGF0aWMgdG8gYXZvaWQgaGF2aW5nIHRvIHBhc3MgdGhlbSBhcyBmdW5jdGlvbiBhcmd1bWVu
dHMgd2hlbiBjb25zdHJ1Y3RpbmcNClRETVJzIiBiZWxvdy4NCg0KPiAJDQo+ID4gVXNlIHN0YXRp
YyB2YXJpYWJsZXMgZm9yIGJvdGggVERTWVNJTkZPX1NUUlVDVCBhbmQgQ01SIGFycmF5IHRvIGF2
b2lkDQo+IA0KPiBJIGZpbmQgaXQgdmVyeSB1c2VmdWwgdG8gYmUgcHJlY2lzZSB3aGVuIHJlZmVy
cmluZyB0byBjb2RlLiAgWW91ciBjb2RlDQo+IHNheXMgJ3Rkc3lzaW5mb19zdHJ1Y3QnLCB5ZXQg
dGhpcyBzYXlzICdURFNZU0lORk9fU1RSVUNUJy4gIFdoeSB0aGUNCj4gZGlmZmVyZW5jZT8NCg0K
SGVyZSBJIGFjdHVhbGx5IGRpZG4ndCBpbnRlbmQgdG8gcmVmZXIgdG8gYW55IGNvZGUuICBJbiB0
aGUgYWJvdmUgcGFyYWdyYXBoDQoodGhhdCBpcyBnb2luZyB0byBiZSByZXBsYWNlZCB3aXRoIHlv
dXJzKSwgSSBtZW50aW9uZWQgIlREU1lTSU5GT19TVFJVQ1QiIHRvDQpleHBsYWluIHdoYXQgZG9l
cyAiaW5mb3JtYXRpb24gb2YgdGhlIFREWCBtb2R1bGUiIGFjdHVhbGx5IHJlZmVyIHRvLCBzaW5j
ZQ0KVERTWVNJTkZPX1NUUlVDVCBpcyB1c2VkIGluIHRoZSBzcGVjLiANCg0KV2hhdCdzIHlvdXIg
cHJlZmVyZW5jZT8NCg0KPiANCj4gPiBoYXZpbmcgdG8gcGFzcyB0aGVtIGFzIGZ1bmN0aW9uIGFy
Z3VtZW50cyB3aGVuIGNvbnN0cnVjdGluZyB0aGUgVERNUg0KPiA+IGFycmF5LiAgQW5kIHRoZXkg
YXJlIHRvbyBiaWcgdG8gYmUgcHV0IHRvIHRoZSBzdGFjayBhbnl3YXkuICBBbHNvLCBLVk0NCj4g
PiBuZWVkcyB0byB1c2UgdGhlIFREU1lTSU5GT19TVFJVQ1QgdG8gY3JlYXRlIFREWCBndWVzdHMu
DQo+IA0KPiBUaGlzIGlzIGFsc28gYSBncmVhdCBwbGFjZSB0byBtZW50aW9uIHRoYXQgdGhlIHRk
c3lzaW5mb19zdHJ1Y3QgY29udGFpbnMNCj4gYSAqbG90KiBvZiBndW5rIHdoaWNoIHdpbGwgbm90
IGJlIHVzZWQgZm9yIGEgYml0IG9yIHRoYXQgbWF5IG5ldmVyIGdldA0KPiB1c2VkLg0KDQpQZXJo
YXBzIGJlbG93Pw0KDQoiTm90ZSBtYW55IG1lbWJlcnMgaW4gdGRzeXNpbmZvX3N0cnVjdCcgYXJl
IG5vdCB1c2VkIGJ5IHRoZSBrZXJuZWwiLg0KDQpCdHcsIG1heSBJIGFzayB3aHkgZG9lcyBpdCBt
YXR0ZXI/DQoNClsuLi5dDQoNCg0KPiA+ICsNCj4gPiArLyogQ2hlY2sgQ01ScyByZXBvcnRlZCBi
eSBUREguU1lTLklORk8sIGFuZCB0cmltIHRhaWwgZW1wdHkgQ01Scy4gKi8NCj4gPiArc3RhdGlj
IGludCB0cmltX2VtcHR5X2NtcnMoc3RydWN0IGNtcl9pbmZvICpjbXJfYXJyYXksIGludCAqYWN0
dWFsX2Ntcl9udW0pDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBjbXJfaW5mbyAqY21yOw0KPiA+ICsJ
aW50IGksIGNtcl9udW07DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIEludGVsIFREWCBtb2R1
bGUgc3BlYywgMjAuNy4zIENNUl9JTkZPOg0KPiA+ICsJICoNCj4gPiArCSAqICAgVERILlNZUy5J
TkZPIGxlYWYgZnVuY3Rpb24gcmV0dXJucyBhIE1BWF9DTVJTICgzMikgZW50cnkNCj4gPiArCSAq
ICAgYXJyYXkgb2YgQ01SX0lORk8gZW50cmllcy4gVGhlIENNUnMgYXJlIHNvcnRlZCBmcm9tIHRo
ZQ0KPiA+ICsJICogICBsb3dlc3QgYmFzZSBhZGRyZXNzIHRvIHRoZSBoaWdoZXN0IGJhc2UgYWRk
cmVzcywgYW5kIHRoZXkNCj4gPiArCSAqICAgYXJlIG5vbi1vdmVybGFwcGluZy4NCj4gPiArCSAq
DQo+ID4gKwkgKiBUaGlzIGltcGxpZXMgdGhhdCBCSU9TIG1heSBnZW5lcmF0ZSBpbnZhbGlkIGVt
cHR5IGVudHJpZXMNCj4gPiArCSAqIGlmIHRvdGFsIENNUnMgYXJlIGxlc3MgdGhhbiAzMi4gIE5l
ZWQgdG8gc2tpcCB0aGVtIG1hbnVhbGx5Lg0KPiA+ICsJICoNCj4gPiArCSAqIENNUiBhbHNvIG11
c3QgYmUgNEsgYWxpZ25lZC4gIFREWCBkb2Vzbid0IHRydXN0IEJJT1MuICBURFgNCj4gPiArCSAq
IGFjdHVhbGx5IHZlcmlmaWVzIENNUnMgYmVmb3JlIGl0IGdldHMgZW5hYmxlZCwgc28gYW55dGhp
bmcNCj4gPiArCSAqIGRvZXNuJ3QgbWVldCBhYm92ZSBtZWFucyBrZXJuZWwgYnVnIChvciBURFgg
aXMgYnJva2VuKS4NCj4gPiArCSAqLw0KPiANCj4gSSBkaXNsaWtlIGNvbW1lbnRzIGxpa2UgdGhp
cyB0aGF0IGRlc2NyaWJlIGFsbCB0aGUgY29kZSBiZWxvdy4gIENhbid0DQo+IHlvdSBzaW1wbHkg
cHV0IHRoZSBjb21tZW50IG5lYXIgdGhlIGNvZGUgdGhhdCBpbXBsZW1lbnRzIGl0Pw0KDQpXaWxs
IGRvLg0KDQo+IA0KPiA+ICsJY21yID0gJmNtcl9hcnJheVswXTsNCj4gPiArCS8qIFRoZXJlIG11
c3QgYmUgYXQgbGVhc3Qgb25lIHZhbGlkIENNUiAqLw0KPiA+ICsJaWYgKFdBUk5fT05fT05DRShp
c19jbXJfZW1wdHkoY21yKSB8fCAhaXNfY21yX29rKGNtcikpKQ0KPiA+ICsJCWdvdG8gZXJyOw0K
PiA+ICsNCj4gPiArCWNtcl9udW0gPSAqYWN0dWFsX2Ntcl9udW07DQo+ID4gKwlmb3IgKGkgPSAx
OyBpIDwgY21yX251bTsgaSsrKSB7DQo+ID4gKwkJc3RydWN0IGNtcl9pbmZvICpjbXIgPSAmY21y
X2FycmF5W2ldOw0KPiA+ICsJCXN0cnVjdCBjbXJfaW5mbyAqcHJldl9jbXIgPSBOVUxMOw0KPiA+
ICsNCj4gPiArCQkvKiBTa2lwIGZ1cnRoZXIgZW1wdHkgQ01ScyAqLw0KPiA+ICsJCWlmIChpc19j
bXJfZW1wdHkoY21yKSkNCj4gPiArCQkJYnJlYWs7DQo+ID4gKw0KPiA+ICsJCS8qDQo+ID4gKwkJ
ICogRG8gc2FuaXR5IGNoZWNrIGFueXdheSB0byBtYWtlIHN1cmUgQ01SczoNCj4gPiArCQkgKiAg
LSBhcmUgNEsgYWxpZ25lZA0KPiA+ICsJCSAqICAtIGRvbid0IG92ZXJsYXANCj4gPiArCQkgKiAg
LSBhcmUgaW4gYWRkcmVzcyBhc2NlbmRpbmcgb3JkZXIuDQo+ID4gKwkJICovDQo+ID4gKwkJaWYg
KFdBUk5fT05fT05DRSghaXNfY21yX29rKGNtcikpKQ0KPiA+ICsJCQlnb3RvIGVycjsNCj4gDQo+
IFdoeSBkb2VzIGNtcl9hcnJheVswXSBnZXQgYSBwYXNzIG9uIHRoZSBlbXB0eSBhbmQgc2FuaXR5
IGNoZWNrcz8NCg0KVERYIE1DSEVDSyB2ZXJpZmllcyBDTVJzIGJlZm9yZSBlbmFibGluZyBURFgs
IHNvIHRoZXJlIG11c3QgYmUgYXQgbGVhc3Qgb25lDQp2YWxpZCBDTVIuDQoNCkFuZCBjbXJfYXJy
YXlbMF0gaXMgY2hlY2tlZCBiZWZvcmUgdGhpcyBsb29wLg0KDQo+IA0KPiA+ICsJCXByZXZfY21y
ID0gJmNtcl9hcnJheVtpIC0gMV07DQo+ID4gKwkJaWYgKFdBUk5fT05fT05DRSgocHJldl9jbXIt
PmJhc2UgKyBwcmV2X2Ntci0+c2l6ZSkgPg0KPiA+ICsJCQkJCWNtci0+YmFzZSkpDQo+ID4gKwkJ
CWdvdG8gZXJyOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qIFVwZGF0ZSB0aGUgYWN0dWFsIG51
bWJlciBvZiBDTVJzICovDQo+ID4gKwkqYWN0dWFsX2Ntcl9udW0gPSBpOw0KPiANCj4gVGhhdCBj
b21tZW50IGlzIG5vdCBoZWxwZnVsLiAgWWVzLCB0aGlzIGlzIGxpdGVyYWxseSB1cGRhdGluZyB0
aGUgbnVtYmVyDQo+IG9mIENNUnMuICBMaXRlcmFsbHkuICBUaGF0J3MgdGhlICJ3aGF0Ii4gIEJ1
dCwgdGhlICJ3aHkiIGlzIGltcG9ydGFudC4NCj4gV2h5IGlzIGl0IGRvaW5nIHRoaXM/DQoNCldo
ZW4gYnVpbGRpbmcgdGhlIGxpc3Qgb2YgIlREWC11c2FibGUiIG1lbW9yeSByZWdpb25zLCB0aGUg
a2VybmVsIHZlcmlmaWVzIHRob3NlDQpyZWdpb25zIGFnYWluc3QgQ01ScyB0byBzZWUgd2hldGhl
ciB0aGV5IGFyZSB0cnVseSBjb252ZXJ0aWJsZSBtZW1vcnkuDQoNCkhvdyBhYm91dCBhZGRpbmcg
YSBjb21tZW50IGxpa2UgYmVsb3c6DQoNCgkvKg0KCSAqIFdoZW4gdGhlIGtlcm5lbCBidWlsZHMg
dGhlIFREWC11c2FibGUgbWVtb3J5IHJlZ2lvbnMsIGl0IHZlcmlmaWVzDQoJICogdGhleSBhcmUg
dHJ1bHkgY29udmVydGlibGUgbWVtb3J5IGJ5IGNoZWNraW5nIHRoZW0gYWdhaW5zdCBDTVJzLg0K
CSAqIFVwZGF0ZSB0aGUgYWN0dWFsIG51bWJlciBvZiBDTVJzIHRvIHNraXAgdGhvc2UgZW1wdHkg
Q01Scy4NCgkgKi8NCg0KQWxzbywgSSB0aGluayBwcmludGluZyBDTVJzIGluIHRoZSBkbWVzZyBp
cyBoZWxwZnVsLiAgUHJpbnRpbmcgZW1wdHkgKHplcm8pIENNUnMNCndpbGwgcHV0IG1lYW5pbmds
ZXNzIGxvZyB0byB0aGUgZG1lc2cuDQogDQo+IA0KPiA+ICsJLyogUHJpbnQga2VybmVsIGNoZWNr
ZWQgQ01ScyAqLw0KPiA+ICsJcHJpbnRfY21ycyhjbXJfYXJyYXksICphY3R1YWxfY21yX251bSwg
Iktlcm5lbC1jaGVja2VkLUNNUiIpOw0KPiANCj4gVGhpcyBpcyB0aGUgcG9pbnQgd2hlcmUgSSBz
dGFydCB0byBsb3NlIHBhdGllbmNlIHdpdGggdGhlc2UgY29tbWVudHMuDQo+IFRoZXNlIGFyZSBq
dXN0IGEgd2FzdGUgb2Ygc3BhY2UuDQoNClNvcnJ5IHdpbGwgcmVtb3ZlLg0KDQo+IA0KPiBBbHNv
LCBJIHNhdyB0aGUgbG9vcCBhYm92ZSBjaGVjayAnY21yX251bScgQ01ScyBmb3IgaXNfY21yX29r
KCkuICBOb3csDQo+IGl0J2xsIHByaW50IGFuICdhY3R1YWxfY21yX251bT0xJyBudW1iZXIgb2Yg
Q01ScyBhcyBiZWluZw0KPiAia2VybmVsLWNoZWNrZWQiLiAgV2h5PyAgVGhhdCBtYWtlcyB6ZXJv
IHNlbnNlLg0KDQpUaGUgbG9vcCBxdWl0cyB3aGVuIGl0IHNlZXMgYW4gZW1wdHkgQ01SLiAgSSB0
aGluayB0aGVyZSdzIG5vIG5lZWQgdG8gY2hlY2sNCmZ1cnRoZXIgQ01ScyBhcyB0aGV5IG11c3Qg
YmUgZW1wdHkgKFREWCBNQ0hFQ0sgdmVyaWZpZXMgQ01ScykuDQoNCj4gDQo+ID4gKwlyZXR1cm4g
MDsNCj4gPiArZXJyOg0KPiA+ICsJcHJfaW5mbygiW1REWCBicm9rZW4gP106IEludmFsaWQgQ01S
cyBkZXRlY3RlZFxuIik7DQo+ID4gKwlwcmludF9jbXJzKGNtcl9hcnJheSwgY21yX251bSwgIkJJ
T1MtQ01SIik7DQo+ID4gKwlyZXR1cm4gLUVJTlZBTDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3Rh
dGljIGludCB0ZHhfZ2V0X3N5c2luZm8odm9pZCkNCj4gPiArew0KPiA+ICsJc3RydWN0IHRkeF9t
b2R1bGVfb3V0cHV0IG91dDsNCj4gPiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJQlVJTERfQlVH
X09OKHNpemVvZihzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCkgIT0gVERTWVNJTkZPX1NUUlVDVF9T
SVpFKTsNCj4gPiArDQo+ID4gKwlyZXQgPSBzZWFtY2FsbChUREhfU1lTX0lORk8sIF9fcGEoJnRk
eF9zeXNpbmZvKSwgVERTWVNJTkZPX1NUUlVDVF9TSVpFLA0KPiA+ICsJCQlfX3BhKHRkeF9jbXJf
YXJyYXkpLCBNQVhfQ01SUywgTlVMTCwgJm91dCk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJl
dHVybiByZXQ7DQo+ID4gKw0KPiA+ICsJLyogUjkgY29udGFpbnMgdGhlIGFjdHVhbCBlbnRyaWVz
IHdyaXR0ZW4gdGhlIENNUiBhcnJheS4gKi8NCj4gPiArCXRkeF9jbXJfbnVtID0gb3V0LnI5Ow0K
PiA+ICsNCj4gPiArCXByX2luZm8oIlREWCBtb2R1bGU6IGF0cmlidXRlcyAweCV4LCB2ZW5kb3Jf
aWQgMHgleCwgbWFqb3JfdmVyc2lvbiAldSwgbWlub3JfdmVyc2lvbiAldSwgYnVpbGRfZGF0ZSAl
dSwgYnVpbGRfbnVtICV1IiwNCj4gPiArCQl0ZHhfc3lzaW5mby5hdHRyaWJ1dGVzLCB0ZHhfc3lz
aW5mby52ZW5kb3JfaWQsDQo+ID4gKwkJdGR4X3N5c2luZm8ubWFqb3JfdmVyc2lvbiwgdGR4X3N5
c2luZm8ubWlub3JfdmVyc2lvbiwNCj4gPiArCQl0ZHhfc3lzaW5mby5idWlsZF9kYXRlLCB0ZHhf
c3lzaW5mby5idWlsZF9udW0pOw0KPiANCj4gVGhpcyBpcyBhIGNhc2Ugd2hlcmUgYSBsaXR0bGUg
Yml0IG9mIHZlcnRpY2FsIGFsaWdubWVudCB3aWxsIGdvIGEgbG9uZyB3YXk6DQo+IA0KPiA+ICsJ
CXRkeF9zeXNpbmZvLmF0dHJpYnV0ZXMsICAgIHRkeF9zeXNpbmZvLnZlbmRvcl9pZCwNCj4gPiAr
CQl0ZHhfc3lzaW5mby5tYWpvcl92ZXJzaW9uLCB0ZHhfc3lzaW5mby5taW5vcl92ZXJzaW9uLA0K
PiA+ICsJCXRkeF9zeXNpbmZvLmJ1aWxkX2RhdGUsICAgIHRkeF9zeXNpbmZvLmJ1aWxkX251bSk7
DQoNClRoYW5rcyB3aWxsIGRvLg0KDQo+IA0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiB0cmlt
X2VtcHR5X2NtcnMoKSB1cGRhdGVzIHRoZSBhY3R1YWwgbnVtYmVyIG9mIENNUnMgYnkNCj4gPiAr
CSAqIGRyb3BwaW5nIGFsbCB0YWlsIGVtcHR5IENNUnMuDQo+ID4gKwkgKi8NCj4gPiArCXJldHVy
biB0cmltX2VtcHR5X2NtcnModGR4X2Ntcl9hcnJheSwgJnRkeF9jbXJfbnVtKTsNCj4gPiArfQ0K
PiANCj4gV2h5IGRvZXMgdGhpcyBib3RoIG5lZWQgdG8gcmVzcGVjdCB0aGUgInRkeF9jbXJfbnVt
ID0gb3V0LnI5IiB2YWx1ZQ0KPiAqYW5kKiB0cmltIHRoZSBlbXB0eSBvbmVzPyAgQ291bGRuJ3Qg
aXQganVzdCBpZ25vcmUgdGhlICJ0ZHhfY21yX251bSA9DQo+IG91dC5yOSIgdmFsdWUgYW5kIGp1
c3QgdHJpbSB0aGUgZW1wdHkgb25lcyBlaXRoZXIgd2F5PyAgSXQncyBub3QgbGlrZQ0KPiB0aGVy
ZSBpcyBhIGJpbGxpb24gb2YgdGhlbS4gIEl0IHdvdWxkIHNpbXBsaWZ5IHRoZSBjb2RlIGZvciBz
dXJlLg0KDQpPSy4gIFNpbmNlIHNwZWMgc2F5cyBNQVhfQ01ScyBpcyAzMiwgc28gSSBjYW4gdXNl
IDMyIGluc3RlYWQgb2YgcmVhZGluZyBvdXQgZnJvbQ0KUjkuDQoNClsuLi5dDQoNCj4gPiArc3Ry
dWN0IGNwdWlkX2NvbmZpZyB7DQo+ID4gKwl1MzIJbGVhZjsNCj4gPiArCXUzMglzdWJfbGVhZjsN
Cj4gPiArCXUzMgllYXg7DQo+ID4gKwl1MzIJZWJ4Ow0KPiA+ICsJdTMyCWVjeDsNCj4gPiArCXUz
MgllZHg7DQo+ID4gK30gX19wYWNrZWQ7DQo+ID4gKw0KPiA+ICsjZGVmaW5lIFREU1lTSU5GT19T
VFJVQ1RfU0laRQkJMTAyNA0KPiA+ICsjZGVmaW5lIFREU1lTSU5GT19TVFJVQ1RfQUxJR05NRU5U
CTEwMjQNCj4gPiArDQo+ID4gK3N0cnVjdCB0ZHN5c2luZm9fc3RydWN0IHsNCj4gPiArCS8qIFRE
WC1TRUFNIE1vZHVsZSBJbmZvICovDQo+ID4gKwl1MzIJYXR0cmlidXRlczsNCj4gPiArCXUzMgl2
ZW5kb3JfaWQ7DQo+ID4gKwl1MzIJYnVpbGRfZGF0ZTsNCj4gPiArCXUxNglidWlsZF9udW07DQo+
ID4gKwl1MTYJbWlub3JfdmVyc2lvbjsNCj4gPiArCXUxNgltYWpvcl92ZXJzaW9uOw0KPiA+ICsJ
dTgJcmVzZXJ2ZWQwWzE0XTsNCj4gPiArCS8qIE1lbW9yeSBJbmZvICovDQo+ID4gKwl1MTYJbWF4
X3RkbXJzOw0KPiA+ICsJdTE2CW1heF9yZXNlcnZlZF9wZXJfdGRtcjsNCj4gPiArCXUxNglwYW10
X2VudHJ5X3NpemU7DQo+ID4gKwl1OAlyZXNlcnZlZDFbMTBdOw0KPiA+ICsJLyogQ29udHJvbCBT
dHJ1Y3QgSW5mbyAqLw0KPiA+ICsJdTE2CXRkY3NfYmFzZV9zaXplOw0KPiA+ICsJdTgJcmVzZXJ2
ZWQyWzJdOw0KPiA+ICsJdTE2CXRkdnBzX2Jhc2Vfc2l6ZTsNCj4gPiArCXU4CXRkdnBzX3hmYW1f
ZGVwZW5kZW50X3NpemU7DQo+ID4gKwl1OAlyZXNlcnZlZDNbOV07DQo+ID4gKwkvKiBURCBDYXBh
YmlsaXRpZXMgKi8NCj4gPiArCXU2NAlhdHRyaWJ1dGVzX2ZpeGVkMDsNCj4gPiArCXU2NAlhdHRy
aWJ1dGVzX2ZpeGVkMTsNCj4gPiArCXU2NAl4ZmFtX2ZpeGVkMDsNCj4gPiArCXU2NAl4ZmFtX2Zp
eGVkMTsNCj4gPiArCXU4CXJlc2VydmVkNFszMl07DQo+ID4gKwl1MzIJbnVtX2NwdWlkX2NvbmZp
ZzsNCj4gPiArCS8qDQo+ID4gKwkgKiBUaGUgYWN0dWFsIG51bWJlciBvZiBDUFVJRF9DT05GSUcg
ZGVwZW5kcyBvbiBhYm92ZQ0KPiA+ICsJICogJ251bV9jcHVpZF9jb25maWcnLiAgVGhlIHNpemUg
b2YgJ3N0cnVjdCB0ZHN5c2luZm9fc3RydWN0Jw0KPiA+ICsJICogaXMgMTAyNEIgZGVmaW5lZCBi
eSBURFggYXJjaGl0ZWN0dXJlLiAgVXNlIGEgdW5pb24gd2l0aA0KPiA+ICsJICogc3BlY2lmaWMg
cGFkZGluZyB0byBtYWtlICdzaXplb2Yoc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QpJw0KPiA+ICsJ
ICogZXF1YWwgdG8gMTAyNC4NCj4gPiArCSAqLw0KPiA+ICsJdW5pb24gew0KPiA+ICsJCXN0cnVj
dCBjcHVpZF9jb25maWcJY3B1aWRfY29uZmlnc1swXTsNCj4gPiArCQl1OAkJCXJlc2VydmVkNVs4
OTJdOw0KPiA+ICsJfTsNCj4gDQo+IENhbiB5b3UgZG91YmxlIGNoZWNrIHdoYXQgdGhlICJyaWdo
dCIgd2F5IHRvIGRvIHZhcmlhYmxlIGFycmF5cyBpcyB0aGVzZQ0KPiBkYXlzPyAgSSB0aG91Z2h0
IHRoZSBbMF0gbWV0aG9kIHdhcyBkaXNjb3VyYWdlZC4NCj4gDQo+IEFsc28sIGl0IGlzbid0ICpy
ZWFsbHkqIDg5MiBieXRlcyBvZiByZXNlcnZlZCBzcGFjZSwgcmlnaHQ/ICBBbnl0aGluZw0KPiB0
aGF0J3Mgbm90IGNwdWlkX2NvbmZpZ3NbXSBpcyByZXNlcnZlZCwgSSBwcmVzdW1lLiAgQ291bGQg
eW91IHRyeSB0byBiZQ0KPiBtb3JlIHByZWNpc2UgdGhlcmU/DQoNCkknbGwgZG8gc29tZSBzdHVk
eSBmaXJzdCBoZXJlIGFuZCBnZXQgYmFjayB0byB5b3UuICBUaGFua3MuDQoNClRoZSBpbnRlbnRp
b24gaXMgdG8gbWFrZSBzdXJlIHRoZSBzdHJ1Y3R1cmUgc2l6ZSBpcyAxMDI0Qiwgc28gdGhhdCB0
aGUgc3RhdGljDQp2YXJpYWJsZSB3aWxsIGhhdmUgZW5vdWdoIHNwYWNlIGZvciB0aGUgVERYIG1v
ZHVsZSB0byB3cml0ZS4NCg==
