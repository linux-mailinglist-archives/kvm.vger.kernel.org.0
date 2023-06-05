Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5C1723384
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 01:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjFEXFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 19:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbjFEXFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 19:05:39 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5533BDC;
        Mon,  5 Jun 2023 16:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686006338; x=1717542338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T7Q/f7sqN3nLSkIcyyn1sD7YWYw+3rH9Xv43Rte5fXY=;
  b=gg0bEYE18aK8pKzddOjfDU/HLtlGLr7SEdpmA9sHHJp/SS7q4D3aXcsy
   juyCGynsCNos/GuUn+u9OtzzVdk1gB3AZ/RkSkt36grUb3vjPv/fKfrmm
   DCSjI2jd/ljsMnpFlYpP1FuwMW5aTc5+nv71yU71c9VQGwK5eVDyupiV3
   6RGUczYBUqHyAIqTeJwlD04sG34pE86Ddk03a8A5VryW4geRIj2LsCcb6
   8AMpXTxG3xiTiyXDPl1FLGU4M9aEg78sgNvzunlWebubXj2Cf3tFjoEX5
   6WAYG+Dc8k7KLBfyuWL+DMoAbNJwadcWgtVDy4CLHit7oSOACRJsib18w
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359820733"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="359820733"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 16:05:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="711974172"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="711974172"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jun 2023 16:05:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 16:05:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 16:05:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 16:05:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1jgx+7RLRFHrydKnLGjMLe7jfstZAQhisoXVl2fgyJQ5r1EEIAHpbfITzJsalrlMU3/cpvL4xZHXQDtf78NJbGH/jPvb9ualBMEmOGuwMF5qUjV8wnS/O5NeNysKfrhjL280dkrppFtAFsaaYKuc1qQn28yfzKZb2tCDFqCoNh3VM8b8P4orZSz+s7U+VQA13XLNQllCHfVEn37yfSOyLKQ+ET9GF5cVnTfWa0rsrODyv55ASvXY9ZUOhxRCiEimUexzt/382aoxTHzmG2IPfW9sC2EiKW5H3cth5MepwWzCRF6KTkwsYzAUcE1Exdh3oxfI0lmZ7YyV5zuPYGeCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7Q/f7sqN3nLSkIcyyn1sD7YWYw+3rH9Xv43Rte5fXY=;
 b=CqAZXrwj7rz+XvpyOfVLLdKpz9lhJzEu3bPCflZBf+msR/309eGK9gFXfo7jO6q447g9ehWFvKcIgheCJx2P9JAdkeWf8qotJvyx20EM6CSWTNk9yau6n3VAkLC4bbxC00RNNXyplHaWKmUzfIOBcSlF3Uqrvo/dzwbAMcQciKTxlX8SqTsE1Fvi00RZp/qDomv/a1+tcuok3SIJ1rsSWmQX0MJJGx/7Bx1D0/NtGyrYBZuh2Qk5ulJnhXr64ZJ5J0SWXu3j8Ck8sR36XdOR9ZRYYm69QMM9EUQS7KKVYzedy0Qp5XVYHiTUOh/TjeJznJI8t2+ZLU07jjEnQo3VVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DS0PR11MB7441.namprd11.prod.outlook.com (2603:10b6:8:141::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 23:05:34 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 23:05:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHZlu+6CL+cHWwyoE2KpZjKTZv14K97eLyAgAFd2IA=
Date:   Mon, 5 Jun 2023 23:05:34 +0000
Message-ID: <a87b5d2f3e9a4219f739da9bb8677c2eaa8b33c2.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
         <55e7b947-ca2f-c6a3-bb38-af4cd0ebc183@intel.com>
In-Reply-To: <55e7b947-ca2f-c6a3-bb38-af4cd0ebc183@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DS0PR11MB7441:EE_
x-ms-office365-filtering-correlation-id: 0894e10e-cbcd-437b-cdcf-08db66195e29
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ie4KMWJ8XQaHKPixNQ9SYLxc/vMSDlKKYh64/7pbGWcvLXobmfqw/P7c4lR9tw36Xb3ySQr25Ec1yrq6d8RBiSS7KW1WeLTpGOCBHsWVsE0YNoKzD4sfdjkoF5CVQzwpsYCoLfIAxkZdZLQ20SkBUr3EjJxSVGO4NKzQ0bw4NBCnsfAvk7xoBmDdB1XdhQAkQMjsoCwfW1lA99K8o6BtMOPUCTOVf3T8WyVizwoN9GfYvNAD5cNIR4Yzc4JXuy6yARM1ij2ySx4HnlfPsYPBeJDcxavTOuhCd/nyjZGbjAZ9qnfQbWPoLjO16PJEToYiH0ozs2/nrRY6aSKvRnsmkecDXdo+8aiDoR5D6cM9p9peoT6bAMaWFnQbjbtcm0YXVtcageIZ1kbPBcVzWix/nYy8Ul8FmrMi/EgejFHWEdtskkYKHXXpVOMmWymjRZJzSwvjJrYvLrLqpClJeTTpggmdgANhrHA+iOnVNyosOQS5Mrb+cQonDDE2/zC1RTNmTz/y8CySIxJt+P6AmEev5DkKYv1lZwpAkA90zdQ4mZ6Od2CyD+nQryr8yN577/Bmhn4sQW98MtewV61uP6GI4t1XpXAxGDID7D7CdxaL6JAslJjHt7DbLezVMigj1L2W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199021)(478600001)(4744005)(2906002)(36756003)(6486002)(71200400001)(2616005)(38070700005)(6512007)(6506007)(26005)(53546011)(86362001)(122000001)(82960400001)(38100700002)(316002)(7416002)(186003)(8676002)(8936002)(66946007)(76116006)(4326008)(66556008)(66476007)(66446008)(64756008)(5660300002)(110136005)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlFuRnhpTjkwQTVGSFA1blQwUlVaYTJVNHNUc1loSXlSYnRlblRuazEyS0Zp?=
 =?utf-8?B?UEI0eGNURGdiWTBIWUhZNTY2Ykdsc1lwSnA5eE9rZmZxa29DL0RYcE9qcmhQ?=
 =?utf-8?B?b1hIYjFVaGZqcWN4M2k4NmVIME44QVpMcWhuQk1OamdmdTZuUy9BbElhOTVy?=
 =?utf-8?B?dzBqVDI2bG5kRHluMjR5eHNrL1dYa2llYWcrQmVuRTdiOG01ZUNkQUpEdGNR?=
 =?utf-8?B?SGM1cXJNY2lMVEZjSkwxUmNaelZ6WEZCRGltSEV1aC8rWFc1blNXTUgweGhW?=
 =?utf-8?B?ZHlwajk3NENoejBaWnpZdlZaLzV4Q1NIak5pUVpBQ2FLYkczbnh0NDdramRP?=
 =?utf-8?B?dU1jdjE1WHJmMHN4TVhsVXoyeXJJa2JwallHbExHYkEvSW0zWUhXRWRnZ284?=
 =?utf-8?B?aHpsekg1d3MxbmNhZ0xWUGdVNFVHeXArU0RCcWpaZE9sdW1ZcWxPeGlUb29R?=
 =?utf-8?B?d2Uxb0YyVGV5enlXaHFGb2dFeml3RzBlcUFabVZveEZkWWF2QThjS3VzTnNV?=
 =?utf-8?B?aTB0K2pPVUp5Zlc3dGVwc0QzYmx5cW9xUm4wTTB5bnd3eC83TEI3ZjlxalI3?=
 =?utf-8?B?VTJHLzVPZUJOcDRRSXNvaTZ4dGxFQXNjam44VDJPQnk2bU4wU0ZNcU0xd2RZ?=
 =?utf-8?B?VDBxVkpiMEtUenlZeGZpSzhzanB0QWwvL1RPNS9vU0xRS3huL240MnVVUHlr?=
 =?utf-8?B?cXVSUk9BWWVQRzlpZ0wrck5YeDZzU2FYeDBnN2F1dDVrWFRNTXdPRGRBVjhT?=
 =?utf-8?B?T1NVbUR1ZnJzMW9Zc0NuZGhYUHBPZU9KVkQvZ3RYc1NYdkN6RzA3QXRwTFAv?=
 =?utf-8?B?Qk80dXNwcldsT1JKY0FnbGRkQlJpTVdKcTdzV0lHcUpVZktiT3lVaUdHT3Zs?=
 =?utf-8?B?V25weWxRK2kxakVESEx6YXRlRmZuR3JSNEJTTWxVLysxSlJvK0JTa0Q0V0Fk?=
 =?utf-8?B?SVBBMS9YZkkreU54cHZQcGQ3a1owckg1czU2Y0lCQTQ0Z2poR3d6cVBPdmVE?=
 =?utf-8?B?ZWkzNkRhNHNCSk1paWtQcy9PYnBvdGdDR0hBeTdsby9YeEc2SW02SmhMeEMz?=
 =?utf-8?B?Z0s5dEc4VEwzWVlubEhJZENuNzcrRUdaQWlXbmplUGthUXA4d1JmNk1ndDVr?=
 =?utf-8?B?S0Y0NS90aXpRSGFEUU9MZ3pNZFp0Z1VaMGxxMVVoQzFCNjlrSHdVc3BraTFv?=
 =?utf-8?B?UEUzelg4aTNhVTNSV0s3bE1tOEVlSzhXek53ZEQ3VlRnTlV6TkNoSlZUMW9k?=
 =?utf-8?B?MDFqb3NGNU5CdUl1ZjQ5RmRreTMrYlFYaDIxc1Q0dWVFYVNuaVkxekpoNUZL?=
 =?utf-8?B?TTNQZjIrWXdGTitDRWdVSW1SWGtVR1g1K1QvbzRzV3FuZ2N4aDJuSmNycG5I?=
 =?utf-8?B?ZXFDNzZ2dG13d3F5bzdNUENGWUg2MGs5TVF5N28vSHg2cnhtVldtVUxoR1hL?=
 =?utf-8?B?QkpPVUhPSXZkb0xVd2Y3SHFzeWxTVHpzUGVpbTVQWFQxWld2bndhZXpjNkZy?=
 =?utf-8?B?SC9ER3pGNHJ5UXNRcnRQTGR4MUVuckdhMy9TUGp3dkZaUzRlMS9UTko0RTFV?=
 =?utf-8?B?NklOOVFPMGYwWmJnZ3ZFM0xRY080R1U3T3hEcWROaWsxOHovVzVFamhnMmsw?=
 =?utf-8?B?SjVQRks0bm5yKzJ5dlVkcXROZVBCcFJmR2VMVXRkSzVuY2d2N282RzdFL1du?=
 =?utf-8?B?RUI5WjBIV1dUYXVQOXJEYkZscE9Va0pNRlRKMmlQdTVWVU5sZU5JQStLSTBk?=
 =?utf-8?B?QndlNWNZN2xDNFRUYjhCVS9NTDROTko3YktRZVY2N25lWW94NFhYMCtaSmpE?=
 =?utf-8?B?U3pBU3BtcTNWWjg1cytTem5sVjduUjNyYmxxendOSTAxTnNHY0EvR2JKK25C?=
 =?utf-8?B?VFBLTTQ1VzRna0wxRXJudE01MDBCSVpWMHgrU0pYVXNoaDZaZW9oVTBvZzZl?=
 =?utf-8?B?dEZOREhjU2x2aXRmMHVzejBjUEZNemZwM3JFZ1UwZUYxVFRSeHIvNEE2ZlZ0?=
 =?utf-8?B?UkZzWnFUSm9EMFBVU09mNXZMQmVhVHF5bzJUMG55SHdOL2p6YVZmbDJJSitQ?=
 =?utf-8?B?TzR1d1owREpvZkpuTmUvWXVFTHFqYTY4c2VRZDRWeFR1a0ZVczl6QzJhb0Rj?=
 =?utf-8?Q?3lyQb+mZKI013BVM8X+RG/lY9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <315C9D98256FF24BA9A1DDB657ABF112@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0894e10e-cbcd-437b-cdcf-08db66195e29
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 23:05:34.2975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V60k+rreBJ7RulS3v0Un2OUFw8AwGSKMm6Mb4sjxipbpJcBwwz6BrQ6xqMiKYeOA3VYRmg0HeoU8F8kfcQaUyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7441
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTA1IGF0IDEwOjEzICswODAwLCBMaSwgWGlhb3lhbyB3cm90ZToNCj4g
T24gNi80LzIwMjMgMTA6MjcgUE0sIEthaSBIdWFuZyB3cm90ZToNCj4gPiA9PSBQcm9ibGVtID09
DQo+ID4gDQo+ID4gQSBwYXJ0aWFsIHdyaXRlIHRvIGEgVERYIHByaXZhdGUgbWVtb3J5IGNhY2hl
bGluZSB3aWxsIHNpbGVudGx5ICJwb2lzb24iDQo+ID4gdGhlIGxpbmUuICBTdWJzZXF1ZW50IHJl
YWRzIHdpbGwgY29uc3VtZSB0aGUgcG9pc29uIGFuZCBnZW5lcmF0ZSBhDQo+ID4gbWFjaGluZSBj
aGVjay4gIEFjY29yZGluZyB0byB0aGUgVERYIGhhcmR3YXJlIHNwZWMsIG5laXRoZXIgb2YgdGhl
c2UNCj4gPiB0aGluZ3Mgc2hvdWxkIGhhdmUgaGFwcGVuZWQuDQo+IA0KPiBUaGUgZXhwZWN0YXRp
b24gaXMgdGhhdCB3cml0ZSB0byBURFggcHJpdmF0ZSBtZW1vcnkgd2l0aCBIS0lEIDAgZG9lc24n
dCANCj4gcG9pc29uIHRoZSBjYWNoZSBsaW5lLiBIb3dldmVyLCBhIHBhcnRpYWwgd3JpdGUgd2l0
aCBIS0lEIDAgZG9lcyBwb2lzb24gDQo+IHRoZSBjYWNoZSBsaW5lLiBUaGlzIGlzIHRoZSBlcnJh
dHVtLCByaWdodD8NCj4gDQoNClllcy4NCg==
