Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28837CE844
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjJRTzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjJRTzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:55:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCAAB8;
        Wed, 18 Oct 2023 12:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697658914; x=1729194914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9bw5UWjgFrbZF1FG9VKEnsUHoQfzgN5an0jbtPPEftI=;
  b=i5Qi2hh0YwnzaqeVvaDauEd4fnYPXSKPl8TV+I1TxUKu1kmrJjpHnEHT
   vjmE0KsEezt4YzYDpXxnrpnlnhTmz2pApbXVjs42Y5q/mudzkjK3qj0ni
   qQTs5FA09msVam+mlaRK9P3x87ef111t0ulY/VaV7y7WOjyebdfKd8BU5
   veMYjYq7J9wx+DwQi/tashtq2hNldV/o5JqeNo6ZKKkcrSBRrdbIK/KSy
   F1ubQgaQcY0N/4gIv8hJ0i5SVuirKdJ65rulcFYFlb0idr5J0LiJ0YC6r
   MDYgUPAkLLcZ7qae0210mMoD60oR5e/+N1srlLBidz4/ZQC6eMQwb4uz7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="376473305"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="376473305"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 12:55:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="733293703"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="733293703"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 12:55:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 12:55:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 12:55:13 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 12:55:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cE56QQfe0zG7+F/tQfbzjjgpZyuaP7KugmYbIXkMD7k7b124xK1Tfp+PmKyj3IaeN1gHHiSkj2zcEW95xBrTjUCJTk64YAK4vzqZwBmmtOPFn1VaFofwyVujV2/gTAr9WOSQtNlRYXiQV2+0o3uo6HwgzejL1ZGw8XD3nRixseXLttmj7zHL0X7dQDp2ePIpS1abK2zMuvp4kRJ4NklIzENpgsmObESP5NtJPv+w2HzIswzhn1QSNkNCui4cLRuWtLM2aE058Q8uhYWIXsGbgw9a6o14ZkXspYjvvtr5chnOdth3Wm8I8FkjFFJIgpgunI/q6D+uMurixqvppTFvog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bw5UWjgFrbZF1FG9VKEnsUHoQfzgN5an0jbtPPEftI=;
 b=GjO1J/didkHvfweZGhgb0PUQPp5617Rij0dbsmw7v/BmrwENSVQcxB/YTbcU1iEJtFbrdJIi+7u1ra9ZTpmTbuanetwrXU96ePlGVi9tvlmz3cKEVSKqvXJIX5x09xyVwDQi8Dvfbcc134Kd3iV1IHh5TZI3lJgvuNJmI1PxZ+PDYukmxZijqHrZ+j/RcncnvM7Iy4vr3RrO0TKp2PxCzvusZLKfmuLS356Wj1Sayu9B3nylQYkyJOatuR5ssM7MyjmkvT/6gqItKGqrhwp/rW/9JktnSGgpa9gKPR33u4AN7zybw5qySt/LFICZRiNVPWckiHWFAnr/bVwM5ekoqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4763.namprd11.prod.outlook.com (2603:10b6:303:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Wed, 18 Oct
 2023 19:55:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 19:55:07 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHaAN//ldkr1S527EC3GXo/nVXwQ7BOCYaAgAETy4CAAHbbgIAAZAmA
Date:   Wed, 18 Oct 2023 19:55:07 +0000
Message-ID: <bfe7bd08f6bb11d45335938ba06e81f86d88bffa.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
         <c3622d89-28d8-4917-9385-67b4cabaccd0@linux.intel.com>
         <b0a49bcff0def4588a4d2a822261b34bf601ede0.camel@intel.com>
         <f834dd3c-b60d-4f9b-89a6-b24e2febf383@intel.com>
In-Reply-To: <f834dd3c-b60d-4f9b-89a6-b24e2febf383@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4763:EE_
x-ms-office365-filtering-correlation-id: d89eadd5-830f-4093-a77a-08dbd01420f3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hnQDcyIiWmoOQfrvtGy5pXH9jM/lUd5E0PHtez9GinAZBsJgqvN7Om0tY6aUokdCzFrI8RGWXv4iW+kdbmTXjNmyRTN6VHeUCEgmEC0Y8QHNhBJq5NlqTPjAMNx9tLr7hvOqbOMGnmdXpbO4guUfo4LVyAEULgnEgTqJYYdrVDYcnipFtLWqOtIM812dtqcZWANVAEsDpZ/HUbTUGy3o9htufr5YyMdf9XAP1Q+BamJqox4U7Ns+3KBVmFi5wAl9OMmlhkoRR6CMDujAxAj4PepGk1/sAHFwND95MfziUzQrHHSE69KPmOgv0u9DwvJEE96A3AouwmrsIHfrzZ9JUS50BZZeq94U4fNFiQdFBSKPDLLqrwcae5JiswDxl0nazXoPEZABnikxn2RmdZ0s4iXElgMN2b4C/R6PeEgyvHbi1N9i2VyvhMzlw0AwUcSG8EQwm5NJn8Uem8hdCwDvVhgPvCCVS9Yr2B5oquWc30MQAB/R9AHSHyhsEQGwbHFiGotfFOBHpuYKk8Y4mgHOYYtCWjqHLFIEaV+JFc0i48EBvfGnRa4CFO+YsKbkiYCiE9B39zLxFgVOpVqwQcXo3gAEn1f6Uk4u1MuVf81FzBejIZxCcJFRnd5GuKTiq+Eo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(396003)(366004)(39860400002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(38100700002)(66946007)(5660300002)(76116006)(478600001)(6486002)(66556008)(91956017)(110136005)(83380400001)(4326008)(6506007)(8676002)(8936002)(316002)(7416002)(71200400001)(4744005)(86362001)(41300700001)(38070700005)(53546011)(54906003)(64756008)(66446008)(66476007)(2906002)(4001150100001)(6512007)(122000001)(26005)(2616005)(36756003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDNvOURPb1Y1ZU9saU9TUkdFWDlHQXptQ2tjVlE2VSthUjNONWYwY3Nheks0?=
 =?utf-8?B?QUErdC9wQ0RhQmxDWGtrUU9yaVZQTWwrS1Qzcll3U1pqUDB0OTE4TkcyNVdP?=
 =?utf-8?B?NnpNaGZIZkxZTHBWc2t4Q1VuKzVhaUdIVllMZXhQelgzbSsvcW1uV08rUStH?=
 =?utf-8?B?WTJlUXBRVk9Fb2RuWU5uKzVDaVhsUC8xdXIrRGhLekJyUlRBQ21vTDVHZlpG?=
 =?utf-8?B?aWVJMVJkL2EyUmtRZTVhQ1lxM3hrVnBRSm9zdTJibzQvdzRzeE5aYW5uQmJO?=
 =?utf-8?B?VDArWWFMUGc0QnV1OHR0NGVHbG01VFA3RnJwa3l3WXZIaGw0Q01WcUxsWEUx?=
 =?utf-8?B?dWgzb0lPY2dySHB4emlnTmNKQTBIK1BsdGdzVmFKTWtIYWxhOWJKZ0JwNjFQ?=
 =?utf-8?B?bG03MjNsZTVKd2grMFYvTExhQTRJUkw1WUpOWlRCNGN0T0w1SGJPbFkvTnMx?=
 =?utf-8?B?QVpCcW1xR05KQkNhQVh3MXM2MGluUjE2V2NvMWdycG4wS2xsSnAwTXROa1d5?=
 =?utf-8?B?OWc1dUdBYmY2U1UvNFd4bnd2M0xQV3hSQk9KN0UyYzVPS3B2S01wMWtzdkxu?=
 =?utf-8?B?c1lLTkZ6dWJGUUczYUkyZmVtUytzQ1V6ZjNXamVqTURqYVJJak1VTGNqall0?=
 =?utf-8?B?UlN4aXF1VWhrQ1FXSDVCbWcxZGRxT3k5SlZlbmhzdURuNVNFWURMSUJ4VEZN?=
 =?utf-8?B?QjVRTWYzRUlDU3pYaThVTTdKTUgwWGVZSTJpcWhzcmNvVXBybWpnTDMvZFZr?=
 =?utf-8?B?Z2dRejUxNUNoQ2oyYU1qYXA1MFp3ckl0ZEYrVHZYMjdFMm12Nnk3V0lWNXdM?=
 =?utf-8?B?QzNRWkFJTGJqdG4wcnZDRmJOZzQ3NHJQQTdSVTBITTBtRXQrQWUremhjVTVK?=
 =?utf-8?B?TURLdlllcXRXMUNXWE4vZ3l3eVNCT1FTVHFoc3pBUW5RU0wzTG1yOHRZWDRk?=
 =?utf-8?B?L2dQOFB4clJlVndOU3hVSUNkOXhJUSt4dmFaVUU2SHF4L0ZkMkRwQjhUSlBo?=
 =?utf-8?B?QjFnZW1sdk5Bd2N2STJRUVE5dUp1b0ZWQ3hITElqakJzTnIyc2ozbUtycVI2?=
 =?utf-8?B?cnpSWThtKzBEVFNSVm9TTFBkNi9aelYvMVNPVFRTM1JXTUJZc3hSeUk3aFBz?=
 =?utf-8?B?bzh2M2RDSFI5ZDBBNGxVSHM4Znp2NmlMV01hSks0RGFkVHI3RXNubVBrQitr?=
 =?utf-8?B?alBwSllFK0ZaSnhNQ05IS0UvSTBUZkZxajZNZXZRcWNhUnN2SC9odVlzbnAv?=
 =?utf-8?B?YkNvRGZtME50elZiZGZlUGk5Z0pUNUxvU2lBa3VyNytwSEZ4eStxTlV5WThP?=
 =?utf-8?B?MmRueTRQTm02SHFxcXFTbHhaYmdXdC82YW1LRk1KSDdrV210SjlRVFY3UU5Z?=
 =?utf-8?B?eGUzUUVXZzVibzVmNi8zMzBnL2lTZ2hVS2ZCLzZvZnpqRktZV3N3K25aMWR0?=
 =?utf-8?B?eHV0bWMrNGhkRDg3akFjZUI1b1dLcUV2TkhaN2d5dTl5TzJXNTFtSlJzb09Z?=
 =?utf-8?B?WGNMcjBvN01ERVlLNDhQV1lCYzBLRHF0OEVMRS95WkNwdmk4d0lRelFzc0tv?=
 =?utf-8?B?dHR1blZYSGpLRnppdFEySnIyeVNMR3FvZzZkMEd0bEJyQVVxYmJTZTJpNVJZ?=
 =?utf-8?B?RklNaEtSUm91ZnNrM1VUWmI4N0JjMmdYMGU2VFU3Qi9hb1ZNZEoyYllPZ2JU?=
 =?utf-8?B?VnRkTVJBeExoNVRhcml6amtNWXMyUEdYOTVHQTIxUjZWcE01MmZzRjMzR3ZK?=
 =?utf-8?B?aUhkTVFYTlNQVGNEZnVkVDdLMGtoT2xIYnQyRnZTWmdnWk9DaTFjaHpjZ2RQ?=
 =?utf-8?B?eG9SdE1xWlNhV3BQem1XUU1EVVptdnI5emVxZFVuaCs3TS9YVnp3SmtXTVB5?=
 =?utf-8?B?RnJpUHBBQ0xLdGpkNHVsRDJyUnQxMFpKdTh6U2wvMDAyc0taZThsd3NrYnR1?=
 =?utf-8?B?S0ZGamhESVR4RXhaMzNpanc3ZnpqV2NTQ241WjQ1TWxxWDkxYXJERmtneENR?=
 =?utf-8?B?L2Y3cGpJRmxCQjBaV3hIZitLcUlIRlNKbEFldC82eTFkSzBOTEZDbHNBVkp4?=
 =?utf-8?B?NHlHNEpmTk1hSm1scFdYRTJDNzRDR0NkRHpTNlZsTHh6Wmd2Z1R4T01LbWRn?=
 =?utf-8?B?WjFFaWFRbXBVK1RjQUpxaWRkZWYrdkZoMjhjRHgvRXgzRFd0ZXlVQnl1Tjlp?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CBAC26B9F7C874FA21AA064B62AB6EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89eadd5-830f-4093-a77a-08dbd01420f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 19:55:07.3249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DCQMtBu0GCz6kLwT95aBxsLJonKsNdHLKg1PX7cot0wEvbFhF7D5x3/hNYufx2zan331ukf3lEFXxJRvHW7KQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4763
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

T24gV2VkLCAyMDIzLTEwLTE4IGF0IDA2OjU2IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMTcvMjMgMjM6NTEsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gSGkgS2lyaWxsL0RhdmUs
IERvIHlvdSBoYXZlIGFueSBwcmVmZXJlbmNlPw0KPiANCj4gSSdtIGZpbmUgd2l0aCB0aGUgZXhw
bGljaXQgaW5pdGlhbGl6YXRpb24uICBUaGUgY29tcGlsZXIgbWlnaHQgZXZlbiB6YXANCj4gaXQg
Zm9yIHlvdSBzbyBpdCBiYXNpY2FsbHkgYmVjb21lcyBkb2N1bWVudGF0aW9uLg0KDQpTbyBJIHRo
aW5rIEknbGwga2VlcCB0aGUgY3VycmVudCBjb2RlIGluIHRoaXMgcGF0Y2guICBUaGFua3MgRGF2
ZSENCg==
