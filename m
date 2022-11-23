Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43161634CD7
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiKWBPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiKWBPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:15:05 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4803E2BE9;
        Tue, 22 Nov 2022 17:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669166058; x=1700702058;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f1Mwv+oW3wndve+Q+VnRmnIMMkL6qCfRa352gk7xkEg=;
  b=ftQHZu8Z8UA4QFG493iLx8NnmUhv1PgKGkzxWBM0bmzg19mwGCN/l8oz
   7r6kQ8iC9be2HR3mH+UYty68/pjymKIctTLGZi3j4EZhzeOJhC5b5Y4zk
   K5c784nRwE8haNcBPFWZBR9gkkZ1bScFcOWtZMN+I9X5gUfmJN/AfuDf8
   pNxRVsc+6tqx5ebGGTYp38xN63Jgtc/CFlo8buCoKdMP1MK/3Mvv9VgYt
   VGuJekrFcUW7p/RhPL49z1F1qHy41FxziTwo1hDVg9BTJ+NiGEw3QNExF
   TS4zabiTF9gXrBSxuc0uyrinGcqTyONDwu67rMgxfm9t3M87FaNawhpvc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="301510122"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="301510122"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 17:14:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784040939"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="784040939"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 22 Nov 2022 17:14:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:14:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 17:14:15 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 17:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xa6g9vnIhUtJDhjHRBz3Yf9pQ/OHHfkOHL18exTauyPVaPjClQqArfQBtZOIyiXRfhx3xWymfebmKfsgkJobGk3/TaNkPU4G0w12QH0LKN8N0jZ9kyuPdCLzTSJl4t1t98vIHrOil6BEIu3KDElgOKU6gXSrIMrY3UY66Y2O78249+FWH3pJjRwFFw3J14iv9JZJJmcOBh95VZHwH5wzNM96miMYA4xlSVIBlEFaZ05cLVHPSksmgBWMqZCkE5dKhn9wwRzvAH5xSxzHw5f6Vayc4qqTUa2wQuF7/YzXR7kj7ZgLmIjVPo5XAMrxJ5l0/aVggYGa/3oEsYqKdH1ITA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1Mwv+oW3wndve+Q+VnRmnIMMkL6qCfRa352gk7xkEg=;
 b=jubKbZ2umHvHxLZeGaYjUG2vIZ+2J4eW/60k6QN66SYK4apdX8dQYkKLb56tz+6lTi9rsb8sHmU5V8DSYZV1SSwz2/ojSsMhOUE1OXoJVexCbDQANk9dwW8V/2NbgaAxOILHuDy1v93TsgXWuw3NMgs5Wj9fgNSRaQ5/ZoPNyRxNKdiovTt1euA7Aq0ez7u3VOnlpoodhEnkSDVnFlX8TD2Hfha0NzgRKRJvqfIs72/V6jvZrWELeVmaF/1sb4ANIc9VwncPFQG4qiKb7wCcieGbCvutHepawzHafGDLkRZhoKxRTHT5VchsLxAgq5kKyxBg3kPiyuWC9O8mkQV/iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6399.namprd11.prod.outlook.com (2603:10b6:8:c8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Wed, 23 Nov 2022 01:14:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 01:14:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Topic: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Index: AQHY/T2+AlEdwutNGkW7IAmyyjQDW65KqvAAgABkvgCAAELPgIAAAzIAgAACXgCAAF9AgA==
Date:   Wed, 23 Nov 2022 01:14:12 +0000
Message-ID: <a323672afe46bd3878a60f276d2f3b697d64332e.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
         <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
         <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
         <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
         <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
         <Y30j/EJ9Y1/gWcXo@hirez.programming.kicks-ass.net>
In-Reply-To: <Y30j/EJ9Y1/gWcXo@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB6399:EE_
x-ms-office365-filtering-correlation-id: 29dfad86-53ee-4d05-ace5-08daccf00810
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wmVJkdfo2Y4QbKwiedcWdYoF4W4qSJCp4OPJ4duy4s+Om7FJ5ga2cdFpg4/RSqr25SWZowg1nP9EzzDCSJTQItSJNxM10H5CPCeK3XL5SXxFc8ZjAwVt+AyshAgnLke9tBWYFvgh+tPU7xBTIXVuo7I6J5BUKs9f+8dYxx2SlqbpM2TaX90ahLdrQrdAeysDuWAzdXfVu3IsPjVuSb5Pom1qaplyxSsOrCNcDIg1jmIkJYWN9lTC6Jxq4cZW76YXMuH9PxpuxcbNUUKNn/9hKs5w4X8Bk9Dro0ENTRZG+EdDlNpAyxgqCgx6bpYrvzt2Nj3DZr67M/Dp3CgKYHk7hh7WrI479lUIqsxk15tzJ4x7rF5MmlL9TNVSjgXMtylLYR8XHESOx+YE41JF7yCAeJj7DFp0d0+g4OC2mHgMIDZuUxA4mpQ2KDtW4QgeEJjZhw021/hYc4KZWI/gFMERVkFdyn7owKu08y0mBCiejA1/b/fsuq/tw2aPGmw1oLPF2q2iVaIUYswgcIEzzGngkFsxygrICCFU++yelPFG9DB5vTPY1VWxKO8HLH7SFnXFCEk4MZAXDbZ14LwtTdfo2/3nDRTdqBdV98C75wYnLnccuo1hTIzHhitAaNyDxjJIpLNuTcajiOcpHPh/zyCU1oTPiZpFnfs1L/vUU3KYkrzzDlNDePLpefCBnUSeHuX60yVheI6e++0s2g1yY8VsjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(2616005)(2906002)(38070700005)(186003)(4326008)(478600001)(76116006)(66556008)(26005)(66946007)(6506007)(6512007)(6636002)(66476007)(316002)(5660300002)(38100700002)(64756008)(8676002)(66446008)(36756003)(91956017)(8936002)(7416002)(83380400001)(6486002)(122000001)(41300700001)(86362001)(82960400001)(110136005)(54906003)(4001150100001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1lUM096eGZaUVZPSWU3N0tQcTJoOUhKeUxGUEp1a0cvaktrVUlyOFpob0Iv?=
 =?utf-8?B?UTVEN0tub3pmL3NJV2RrZkM2emI4bllrdUVLb1p3VjBOR3REb1JKd2FQZFBp?=
 =?utf-8?B?Z0h1R29haFZXM1BOY1NkbVVSc2llbmdNbldsNzF1c25xT2JvaHQvblo5dSt4?=
 =?utf-8?B?TFltanQyN25zRDRlcHVuenNNTmg4SFNIR0JWNkxCa2wxeFUvYUs0aE5ISGli?=
 =?utf-8?B?RDJodW1Fa1h5aFpSdTVMSGo0T0U2MlZhY3Z2aCthazhzT29jQmxEQlUyS0xI?=
 =?utf-8?B?OGlsMlVFV1krUkI2R0FzWGl6QWhBTE9HVUpEQWJtbUVUdW4vRENqS3B3c1hJ?=
 =?utf-8?B?M1BWY3U4cTBkWVJ5VjkzZGdKZFliVTArMFRpV3ZFbnFVSVBnbTJoZll3M1Ny?=
 =?utf-8?B?WFM3c0o1ZjE4REVkdUs3NkloNjdzSi9US2Z6UGJmd21HQ1N2M3pwTDBTTjRx?=
 =?utf-8?B?WEloR1R4NkZ0MXZKaDh5U1IyV3JMK0ZWVGhwc2FCS0xnbzlRQjVyQnFmR2V0?=
 =?utf-8?B?THJ1NTgzNXhObUF2UXloRVh0LzhFK01jVm1aTm80WE9HUm5DRGYzNzBZWGZQ?=
 =?utf-8?B?R0c2dHpQajQzbXcyZ0s3L0RuZ2Y1UVVMZm5mQVM3VEIrL3hhQy85Ky9tUm5z?=
 =?utf-8?B?dlk5K0tudjhXRlA1cHRxcVFiNjdmMDZzRkNGVkxjVjE0L25ONXB0MXVpblJT?=
 =?utf-8?B?cm1wUkpaenB6eXVKZ3Z2UC83UXYxTmgzV1JTelZ3V0NKMjRRanBwTy95a1g3?=
 =?utf-8?B?UDVvOUR3SXpwL2w2OWk5UGRSSFNwT1ZLYno3UnJSMFdUemNzSmxaSklDN2Vt?=
 =?utf-8?B?YWxXTmUwNHVrSHpFWnRJVGFWWnFTdDNOQ1lyMnZtMTZ4bVk4MlNmVG5hRGVr?=
 =?utf-8?B?WW9KVXlyM1djTWx2OU1kL244L3crb1pzSHg3R2tvL1NBVTd4TXVRUW1zNExa?=
 =?utf-8?B?YkNTd2NSdkY5ak9Kc3gwZ2piUWVTK1VWNmJJSGF1ZmQ3TUs3UHcxbTBHaHRm?=
 =?utf-8?B?MkMrVVpRTFVVZDNWYjN1cTUwakFDL25QcWozR3BWeEcxWnZULzM1Tk9Rb0RM?=
 =?utf-8?B?b0U4UE84M25UcFB3U2tBZm9QKzY2L1QyT0F3NEJQMTU5US9aekRUdFNvWVVQ?=
 =?utf-8?B?c1ZpUjVrTitha2Q2VHFnSFdCQWhDek95MS95MU9ZT3lJR0N0cFZvZ2J1SEtk?=
 =?utf-8?B?SVFScUUzOW1mQ1R3dnRoSG9zeGhGZGVjM2Y4M0VGZ0grRnlwRlgyS0psUGpY?=
 =?utf-8?B?d2VNczY0K2FxRFNGMzlhRFpuUVVtcWFGYlNLclRpcE1aeCtDeXBJWTBQZHIy?=
 =?utf-8?B?b1RxS09LcWFINnppN3NnR0laQjZmQll1SFJ0bVl0Q0owOW1odEFtZjI0dmdJ?=
 =?utf-8?B?QzllRGU2SlJ6RmVhMlhFR3k5OVB2VFY2ZnRRaUhEZ0w4QkVqb1U1aHVjUDJz?=
 =?utf-8?B?eWxWUStqTEpxS3BCRmVZcVVhdlBBNXI4aW4rdXJ0K3FlbUZOSlRkMS9JNk9W?=
 =?utf-8?B?RFpJRXZJcjZ4NFRDWjZtblN6YklBM3ViaFNyYTBoRndYNWYrRXdIamtjNTdD?=
 =?utf-8?B?YzRscVVRbG9kVWh2SUpDaDdCbm5aS2N5SVk2U2h5RFVQaDgwRnp0aFdmdFhG?=
 =?utf-8?B?dE95TkVlSWlxLzRqQnZ3dTYzVmp6TDkrQ1FPZEcweDdHTnFnUzBIVEh6ekRV?=
 =?utf-8?B?M0tQODhZWUkyT090ditiRkNzU0U3MkNBQkJGV05hMHoyUTU3dXg1QXBNd2Jh?=
 =?utf-8?B?UEFIUnA0a3pRSW9uYlBrMW1aQWNIbkVZRHRPbTduNjhQdWpHdUdoZ0NxMDds?=
 =?utf-8?B?NXZEeTg1bndkNkNTOTVyZStDcjErc0hpaGtmMlRnbE9iZWVXeEtUelNBZmk1?=
 =?utf-8?B?VDNZN0tNOE9KZ2lUWk9PRGpmOTVDNUQ3ZUwwR25PU2RoSlJHdUJ1NUVDVGVJ?=
 =?utf-8?B?eDJuRFpObnVVNms1OVRZdWh1RVlabk84ZTIvWVRCM2d6Sm9uZzJQditJbE5X?=
 =?utf-8?B?U3NVMWN3K1FLVzB6YzdJUzdISFZVcjk5ZkJXOS9qOTdOUTZtbndOeUgyY1V1?=
 =?utf-8?B?b1E3VlBOVHNvU2lnUXVTS0VwMktYK1VWS3FPWGhjL2lFT3B3N29xaFltT0NV?=
 =?utf-8?B?d3E2dkRsT3ZxejhyMDNGUWdRVEFDMDNnRkRJM3Z1b3RYVmhDckxyOWlrL1d6?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50AB6AA870ACA94EB354F6BB3FDA41BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29dfad86-53ee-4d05-ace5-08daccf00810
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 01:14:12.5561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hyPAB0TVbSKPJuBIAUjiR3D2q75gp6Hx0XwUthjU/4E5lWAb3nIVCD/B5+QX8cRAlE4wlDv932fu7Dfndo9p6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6399
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDIwOjMzICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBOb3YgMjIsIDIwMjIgYXQgMTE6MjQ6NDhBTSAtMDgwMCwgRGF2ZSBIYW5zZW4g
d3JvdGU6DQo+IA0KPiA+ID4gTm90IGludGlhbGl6ZSBURFggb24gYnVzeSBOT0haX0ZVTEwgY3B1
cyBhbmQgaGFyZC1saW1pdCB0aGUgY3B1bWFzayBvZg0KPiA+ID4gYWxsIFREWCB1c2luZyB0YXNr
cy4NCj4gPiANCj4gPiBJIGRvbid0IHRoaW5rIHRoYXQgd29ya3MuICBBcyBJIG1lbnRpb25lZCB0
byBUaG9tYXMgZWxzZXdoZXJlLCB5b3UgZG9uJ3QNCj4gPiBqdXN0IG5lZWQgdG8gaW5pdGlhbGl6
ZSBURFggb24gdGhlIENQVXMgd2hlcmUgaXQgaXMgdXNlZC4gIEJlZm9yZSB0aGUNCj4gPiBtb2R1
bGUgd2lsbCBzdGFydCB3b3JraW5nIHlvdSBuZWVkIHRvIGluaXRpYWxpemUgaXQgb24gKmFsbCog
dGhlIENQVXMgaXQNCj4gPiBrbm93cyBhYm91dC4gIFRoZSBtb2R1bGUgaXRzZWxmIGhhcyBhIGxp
dHRsZSBjb3VudGVyIHdoZXJlIGl0IHRyYWNrcw0KPiA+IHRoaXMgYW5kIHdpbGwgcmVmdXNlIHRv
IHN0YXJ0IGJlaW5nIHVzZWZ1bCB1bnRpbCBpdCBnZXRzIGNhbGxlZA0KPiA+IHRob3JvdWdobHkg
ZW5vdWdoLg0KPiANCj4gVGhhdCdzIGJsb29keSB0ZXJyaWJsZSwgdGhhdCBpcy4gSG93IGFyZSB3
ZSBnb2luZyB0byBtYWtlIHRoYXQgd29yayB3aXRoDQo+IHRoZSBTTVQgbWl0aWdhdGlvbiBjcnVk
IHRoYXQgZm9yY2VzIHRoZSBTTVQgc2liaWxuZyBvZmZsaW5lPw0KPiANCj4gVGhlbiB0aGUgY291
bnRlcnMgZG9uJ3QgbWF0Y2ggYW5kIFREWCB3b24ndCB3b3JrLg0KPiANCj4gQ2FuIHdlIGdldCB0
aGlzIGxpbWl0aWF0aW9uIHJlbW92ZWQgYW5kIHNpbXBseSBsZXQgdGhlIG1vZHVsZSB0aHJvdyBh
DQo+IHdvYmJseSAoZXJyb3IpIHdoZW4gc29tZW9uZSB0cmllcyBhbmQgdXNlIFREWCB3aXRob3V0
IHRoYXQgbG9naWNhbCBDUFUNCj4gaGF2aW5nIGJlZW4gcHJvcGVybHkgaW5pdGlhbGl6ZWQ/DQoN
CkRhdmUga2luZGx5IGhlbHBlZCB0byByYWlzZSB0aGlzIGlzc3VlIGFuZCBJJ2xsIGZvbGxvdyB1
cCB3aXRoIFREWCBtb2R1bGUgZ3V5cw0KdG8gc2VlIHdoZXRoZXIgd2UgY2FuIHJlbW92ZS9lYXNl
IHN1Y2ggbGltaXRhdGlvbi4NCg0KVGhhbmtzIQ0K
