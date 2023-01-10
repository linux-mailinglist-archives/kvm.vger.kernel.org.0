Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E0866365C
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 01:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbjAJAko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 19:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjAJAkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 19:40:42 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B131015;
        Mon,  9 Jan 2023 16:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673311241; x=1704847241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pb8eWlDp8iGJU0b4JgXtah6Mb6nsyicc1RCnIwsO4to=;
  b=DhqU1xe04TteOkpKiPMj5xcsL3bkDX/C4o9Oi3HBXG/ucVS0M5wEMOBV
   b8/LY7kR8TeEzysEeQsLUPfChza0yKIcqeRXcvsLPu4Kfu6s4KEdLws+K
   H8Z8VsOecyyTpCO0iZmOOs8u/XD+0Nroeia6z/gPlmGYLTXtRwRPap262
   xoeY5t5t0XjzKTUZGxDLJH5go790uusSJGecskmtfl0+UHRfb2+GGX7ZS
   LI6az9tg6KUKs9WFxgBvYDkYUDVMRr0ibaO92G66L4pymhSOXgU9iLzBe
   tFTfNvJgRmZ/FixWsJH4pdbksGJuPLYEFTwbbPjyLKMaHT2W/UlaiR5wR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="303385162"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="303385162"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 16:40:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="650176808"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="650176808"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 09 Jan 2023 16:40:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 16:40:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 16:40:40 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 16:40:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+5O0LRL/GKtBnSTxJ3/BVoIQzGlhJn/3Ten48sygaqwVuNvaN5rjyjRoFYC89obj3FdtnOgZVJARocfOXqmHDIpCcsvo/8TRm9dGQ6ZswQckdPh4edKWagyfhoym9Hcl1Jt8mEkWN9IXKLgiMlDaZSFko2TIDod5xxaQWxUY00u7QzMfCEDFAhUu2agc8t4G+FDCU1+MllUi3+j6SBx1WO91woy6SKl6MpGtJ1dsNAs1qjw5aMS8VWyJPfQe2CEcGuNhSlnKmjuSyNk4DOmJD3FR+hwBKp4DfkfhVQpM4g2j8yvL6CjrB1Tmv/1RAd4ZRvgu1QTHU9codY4bRGU6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pb8eWlDp8iGJU0b4JgXtah6Mb6nsyicc1RCnIwsO4to=;
 b=M0JlPzTzvuuxYGpTrurNCmwrwxO0OXmLeGFYw6K5TWSo8xyYSvjKYQhzk4vXoobNxKwUG4Ft6XnMTNSoHMc+dFyMxhOTtLxwr0ydPxiufOj8g9fGhbWCF6pZ4TBkLmOPkzgqhiokeb6nmgjsRO7N9Q08osJbzkNmPny7STzCPcI8sVawwXA6qjLG7/UhmmOEuDMUuNc3otAQ7Lq5uLnH5ez+kyYXXeuBkpcdDHXPg7SYOf3XyeEWcEJcglsAFOyABOh8iXNbgymG7kMA2h+dhqPnN4C7On0nDlx/qPNFr0WSmr/kvQh8h56PwrffZIjG2MP5tz/K0jkDHsJ1a7TtXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4674.namprd11.prod.outlook.com (2603:10b6:5:2a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 00:40:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 00:40:36 +0000
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
Subject: Re: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHZC5gPYUqEVXDsYU2zS2Qoxtth0K6R8eiAgAUPNAA=
Date:   Tue, 10 Jan 2023 00:40:35 +0000
Message-ID: <81b814f096513e69e3099ab2b54034deadf8d7fd.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
         <c70c30fb-073f-4355-c6a6-052d013a99da@intel.com>
In-Reply-To: <c70c30fb-073f-4355-c6a6-052d013a99da@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4674:EE_
x-ms-office365-filtering-correlation-id: d6e90c79-f61c-4210-139e-08daf2a349e3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bpd8ujZrLPGtUDYWOx1ZNLJDeOa/R8d3kDx7jmwq/MjePMCjgLDsb7DjDC35ChJUKQUpDxvAMqCa3fwhfizXfzB5bNMmCveykU6SsQRv0Iap2DuOhvsj+Zjdh3dsHEoR6Biowa5DYEGxQYcZYp9AQhojzpJzHX2HswgpCx9WfvInpoLG5GA2xLECSFK7gG7uQVoq1xvjIiftlAiEhl4h2TZmCephoFtXGPZJyLbtElYyAOA7HeTEEH31DMZxLQ2NyrkglV3SzZJA46+AajPZimwVsL6NrY1UYTW7uVeLsGON7R4Ze9A+RHyKj1pndUtvDIPUt5PDiFdmPFMZGooLrcXGCaU6xTm0JbdgwSqcAQWoOysqxUbfSmXltpjVA/dC4PzIAbVRcidoKs4KVl1Jwwqo668zhn4pVLqhTf2r5X4YtRDhjOk3eyZbCdA1WpYMhBGsrGhErGcvGG6AyitPni7QNeFqsFIPAFjxObV68HnTR3mhGKMPrjGY6nba+bXqGrQ95qb++cJfJE/VITGW4CQffMuWN5b4X2vMC6cTTwlC8QBi8qiEegGcTj3TNuiSsf+hhqEVVGUYcLx18BE0KWcjAQXB2NkWAihs6tVDorckq69rK/qT+qFKpiDAqWUDGP5c+EVG+BaT3IWSqcebk8FoBVNCFGVC1RPiAMfN6A+UQhEJMAnlNoPPRFFqehZvo7rJ2cV183oqBe2bmgrz5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199015)(66556008)(4326008)(91956017)(8676002)(64756008)(66946007)(66476007)(76116006)(66446008)(316002)(110136005)(38070700005)(54906003)(7416002)(2906002)(8936002)(5660300002)(71200400001)(41300700001)(36756003)(83380400001)(6506007)(6486002)(478600001)(82960400001)(2616005)(186003)(38100700002)(26005)(6512007)(86362001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHk5WS95eWp3OFJMN3FiM1R6OFBGamRHNHVVMElxeDBPODNXU3kxNVBOVU5K?=
 =?utf-8?B?Q0loU1ZyNjVDdHloNS9hb0p3WHRFaU9VVzg5RnlURFJkUGRxRXlGOUxVeDZq?=
 =?utf-8?B?TXpCQ2tSMTA4TGJWNlFNcGR2TnJZcEpiYlcwcFRBZjlRcmtjVnBZdjdVSjFw?=
 =?utf-8?B?VlhiWWc5cktUQ1p6N0RKUm5YRVpzekdPUE9ycjNOSEdHQVZRZWRZWm8xUDM5?=
 =?utf-8?B?bTcyMzRWbm8zcmRldDg2NlVaTjV0dUcwUFRjYnNqRFYwTlFnSGJCYzdwdjl5?=
 =?utf-8?B?VEdBUEFmL3NXek9RZU9SWDFqZUJZQ0wzVVFtcUYxRHlmeVJyNS9OSEx4SHUw?=
 =?utf-8?B?Q0Jhc29CNG9VUktldkE1MkhBc1Q0clhEdVd6VDMwVjdtbWlneWVzdCtSNUVt?=
 =?utf-8?B?QVhpWkJVMERDazVoNlpqczd6SlVpRkNEMHVSRnVkZzl2ZUEydG5URSthQy85?=
 =?utf-8?B?bzhUUGFXaUxuTzRlZEREMlNmVUxQZ0l1L2wxeXpaLzg1VC9uUWJiQTdzS3RF?=
 =?utf-8?B?Q0VZYm81ZXllaFdqYTlhaVVHWk1rMkx3Z2R3ZjB4eXdYUEtXeXVKeVQ2UjU0?=
 =?utf-8?B?TUxBTDhseUMrUStScDRhZjY1YmJmZnpwc2doMHBxK21kQ2t5VlUrNGVhODJS?=
 =?utf-8?B?eElTcFZpNjEzZkRaeVBrRTF2WENteWdFaUtKNlgrRHVCVDNkQmhDLzREWDBI?=
 =?utf-8?B?NE5xaTM4VFZWam96WjlNb0ZHWVZvRElsZWRTYWhHWUVWeDNtTENUWXErUmhS?=
 =?utf-8?B?dmdYOXVOa2RRV2FJdVlLYlR1WTM5b29yUjBUam41UHZxWEYrbFNoL3EvOVhj?=
 =?utf-8?B?MTNodHZoVnB3d1oxRUF3Tlh5eGwyZGZFYzBCekNUc0VtU3hVb0NEbFlweWx4?=
 =?utf-8?B?bXNOd2cyRENoYVNoTXpKT1NYZ3FPQmhjK05OZEV4TWNWZGpxK043Qm1GZjNT?=
 =?utf-8?B?d3FRUFYrTVlkcWo4bUhWdWxFc3doQlo5ZFhUMVJKbW9iVCtzMWlqazNzait4?=
 =?utf-8?B?VitubVEyMGE2NERjOTRNL0M2QlJtTWNML0hSVFBqVjMrWVpuWEptc2M4U0c0?=
 =?utf-8?B?Z2wreHYvczRzZVBwTU5iSDlidm81anRmNVVmWGszY3M5M2lzWlR1ZXQ4anNm?=
 =?utf-8?B?SmFCQlFjRlF2VktkcTdiS2FCZTFOSFM1aTFad1lpeXFxbjVxSHg4UC9YUnpp?=
 =?utf-8?B?RVJLVThqZXFpbVdqK2Y4RlJkamJkZERkQk1sUkF2REZtS1Y4eGZxUnNxUllt?=
 =?utf-8?B?ZXUreWVHdzBVWTJSdW1CUkJySEt4ZTY1R0Y2S2VCeDRZUkZ1SThUcVNDUllG?=
 =?utf-8?B?UUxZZ0YvMUQzWHdkTytjMFFWUTNrM3pRZythQXkzS2FRaGRvR0NzR3p6UE95?=
 =?utf-8?B?Lzcwd3hFb1FIYnVVM2RCR0pKaTRHV3NydFVVUGx0Nlp5cC8zWGl6Qms3bElJ?=
 =?utf-8?B?aDdjL3hMQnROcWxQcWFnVFFFdm1nUFZtTGVGM3FSK3BVSWxMZXZXOVh0TkFm?=
 =?utf-8?B?enRoUzBUSkNnUHhYTmNjSlBTck5LYjRYUC9lYUdTTUNxWmRyL3JpZFNzcmRx?=
 =?utf-8?B?aVk0U1YvWkdhSytoSENkTmFndElIVXZHV2dZakFacnkxOE16SElkY01jZzFF?=
 =?utf-8?B?cTNFZDJGSEJkekxqVVFnV3NrdEl5RlZRL0JXNFkyZWRiTENVTlcybVdyRUdr?=
 =?utf-8?B?ZGlGMUZBUkNGa21vdFgzbXB1dUY5bzJrQWtmOFozNFE0ZDI5MjdoSEszQXNy?=
 =?utf-8?B?UE1ZM0hYU0NpQ3IveGVQMk00cHB0WHNwaTdyelh0bGJaVFFvbDlPaTRGSEtI?=
 =?utf-8?B?VFErMU11RlV4SDlzZU8wMnJ6K0pvN21Bd2pWbURpQUFTY3FPbFlLMTFxZHY4?=
 =?utf-8?B?MHJPSm5TekFpa3RiN2JPMG9SRWY3NW94S0lwdGliQ0Z4QXZZOGRmTXVrU2lZ?=
 =?utf-8?B?bFM5Y0dPSUJXSlR0THBhM2xrcElab3BlRDhMQ1NIOUQwbUFZayttMW56SlVo?=
 =?utf-8?B?NjFmL1ZpOUhuaVA1Yzc1QzVTK3QxWTlvbTBtaUdIMDFHNW9IR2JQR1pISjJl?=
 =?utf-8?B?T2swWkxmK0tsWWl2T25IZVRCYURxdzdQamdjdWJ5d0FBZFY1Q0o3MHdvSTNU?=
 =?utf-8?B?Q0VRMTY5emhwVVZhZ1Z3WjBOOXVsVXZMTnRBdWhQWGJsUExiUFl3ZUxTM0pT?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABEF8EDC60C78F49BEEE50F1C28FE850@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e90c79-f61c-4210-139e-08daf2a349e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 00:40:35.8930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2MAIHAmWAzrX5f3TA6sZplozgy99j7/MtBLdravoQ0LNCz8l6MFHDlIntWKkyrDUCp/g2WPbndL38Vx1vzMHQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4674
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDExOjI0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiArc3RydWN0IHRkbXJfaW5mb19saXN0IHsNCj4gPiArCXN0cnVjdCB0ZG1yX2luZm8gKmZpcnN0
X3RkbXI7DQo+IA0KPiBUaGlzIGlzIG5hbWVkIGJhZGx5LiAgVGhpcyBpcyByZWFsbHkgYSBwb2lu
dGVyIHRvIGFuIGFycmF5LiAgV2hpbGUgaXQNCj4gX2RvZXNfIG9mIGNvdXJzZSBwb2ludCB0byB0
aGUgZmlyc3QgbWVtYmVyIG9mIHRoZSBhcnJheSwgdGhlIG5hbWluZw0KPiBzaG91bGQgbWFrZSBp
dCBjbGVhciB0aGF0IHRoZXJlIGFyZSBtdWx0aXBsZSB0ZG1yX2luZm9zIGhlcmUuDQoNCldpbGwg
Y2hhbmdlIHRvICd0ZG1ycycgYXMgaW4geW91ciBjb2RlLg0KDQo+IA0KPiA+ICsJaW50IHRkbXJf
c3o7DQo+ID4gKwlpbnQgbWF4X3RkbXJzOw0KPiA+ICsJaW50IG5yX3RkbXJzOwkvKiBBY3R1YWwg
bnVtYmVyIG9mIFRETVJzICovDQo+ID4gK307DQo+IA0KPiBUaGlzICd0ZG1yX2luZm9fbGlzdCdz
IGlzIGRlY2xhcmVkIGluIGFuIHVuZm9ydHVuYXRlIHBsYWNlLiAgSSB0aG91Z2h0DQo+IHRoZSB0
ZG1yX3NpemVfc2luZ2xlKCkgZnVuY3Rpb24gYmVsb3cgd2FzIHJlbGF0ZWQgdG8gaXQuDQoNCkkg
dGhpbmsgSSBjYW4gbW92ZSBpdCAidGR4LmgiLCB3aGljaCBpcyBjbGFpbWVkIHRvIGhhdmUgYm90
aCBURFgtYXJjaCBkYXRhDQpzdHJ1Y3R1cmVzIGFuZCBsaW51eC1kZWZpbmVkIHN0cnVjdHVyZXMg
YW55d2F5Lg0KDQpJIHRoaW5rIEkgY2FuIGFsc28gbW92ZSAnZW51bSB0ZHhfbW9kdWxlX3N0YXR1
c190JyBhbmQgJ3N0cnVjdCB0ZHhfbWVtYmxvY2snDQpkZWNsYXJhdGlvbnMgdG8gInRkeC5oIiB0
b28gc28gdGhhdCBhbGwgZGVjbGFyYXRpb25zIGFyZSBpbiAidGR4LmgiLg0KDQo+IA0KPiBBbHNv
LCB0ZG1yX3N6IGFuZCBtYXhfdGRtcnMgY2FuIGJvdGggYmUgZGVyaXZlZCBmcm9tICdzeXNpbmZv
Jy4gIERvIHRoZXkNCj4gcmVhbGx5IG5lZWQgdG8gYmUgc3RvcmVkIGhlcmU/IMKgDQoNCkl0J3Mg
bm90IG1hbmRhdG9yeSB0byBrZWVwIHRoZW0gaGVyZS4gIEkgZGlkIGl0IG1haW5seSBiZWNhdXNl
IEkgd2FudCB0byBhdm9pZA0KcGFzc2luZyAnc3lzaW5mbycgYXMgYXJndW1lbnQgZm9yIGFsbW9z
dCBhbGwgZnVuY3Rpb25zIHJlbGF0ZWQgdG8gY29uc3RydWN0aW5nDQpURE1Scy4NCg0KRm9yIGlu
c3RhbmNlLCAndGRtcl9zeicgaXMgdXNlZCB0byBjYWxjdWxhdGUgdGhlIHBvc2l0aW9uIG9mIGVh
Y2ggaW5kaXZpZHVhbA0KVERNUiBhdCBhIGdpdmVuIGluZGV4LiAgSW5zdGVhZCBvZiBwYXNzaW5n
IGFkZGl0aW9uYWwgJ3N5c2luZm8nIChvciBzeXNpbmZvLQ0KPm1heF9yZXNlcnZlZF9wZXJfdGRt
cik6DQoNCglzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yX2VudHJ5KHN0cnVjdCB0ZG1yX2luZm9fbGlz
dCAqdGRtcl9saXN0LCAgaW50DQppZHgsDQoJCQkJICAgICBzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVj
dCAqc3lzaW5mbykgeyAuLi4gfQ0KDQpJIHBlcmZlcjoNCg0KCXN0cnVjdCB0ZG1yX2luZm8gKnRk
bXJfZW50cnkoc3RydWN0IHRkbXJfaW5mb19saXN0ICp0ZG1yX2xpc3QsIGludCBpZHgpDQoJey4u
Ln0NCg0KdGRtcl9lbnRyeSgpIGlzIGJhc2ljYWxseSBjYWxsZWQgaW4gYWxsIDMgc3RlcHMgKGZp
bGwgb3V0IFRETVJzLCBhbGxvY2F0ZSBQQU1UcywNCmFuZCBkZXNpZ25hdGUgcmVzZXJ2ZWQgYXJl
YXMpLiAgSGF2aW5nICdzeXNpbmZvJyBpbiBpdCB3aWxsIHJlcXVpcmUgYWxtb3N0IGFsbA0KZnVu
Y3Rpb25zIHJlbGF0ZWQgdG8gY29uc3RydWN0aW5nIFRETVJzIHRvIGhhdmUgJ3N5c2luZm8nIGFz
IGFyZ3VtZW50LCB3aGljaA0Kb25seSBtYWtlcyB0aGUgY29kZSBtb3JlIGNvbXBsaWNhdGVkIGFu
ZCBodXJ0cyB0aGUgcmVhZGFiaWxpdHkgSU1ITy4NCg0KPiBJZiBzbywgSSB0aGluayBJJ2QgcHJv
YmFibHkgZG8gc29tZXRoaW5nDQo+IGxpa2UgdGhpcyB3aXRoIHRoZSBzdHJ1Y3R1cmU6DQo+IA0K
PiBzdHJ1Y3QgdGRtcl9pbmZvX2xpc3Qgew0KPiAJc3RydWN0IHRkbXJfaW5mbyAqdGRtcnM7DQo+
IAlpbnQgbnJfY29uc3VtZWRfdGRtcnM7IC8vIEhvdyBtYW55IEB0ZG1ycyBhcmUgaW4gdXNlDQo+
IA0KPiAJLyogTWV0YWRhdGEgZm9yIGZyZWVpbmcgdGhpcyBzdHJ1Y3R1cmU6ICovDQo+IAlpbnQg
dGRtcl9zejsgICAvLyBTaXplIG9mIG9uZSAndGRtcl9pbmZvJyAoaGFzIGEgZmxleCBhcnJheSkN
Cj4gCWludCBtYXhfdGRtcnM7IC8vIEhvdyBtYW55IEB0ZG1ycyBhcmUgYWxsb2NhdGVkDQo+IH07
DQo+IA0KPiBNb2R1bG8gd2hhdGF2ZXIgZm9sa3MgYXJlIGRvaW5nIGZvciBjb21tZW50cyB0aGVz
ZSBkYXlzLg0KDQpMb29rcyBuaWNlIHRvIG1lLiAgV2lsbCB1c2UuICBBIHNsaWdodCB0aGluZyBp
cyAndGRtcl9zeicgaXMgYWxzbyB1c2VkIHRvIGdldA0KdGhlIFRETVIgYXQgYSBnaXZlbiBpbmRl
eCwgYnV0IG5vdCBqdXN0IGZyZWVpbmcgdGhlIHN0cnVjdHVyZS4NCg0KQnR3LCBpcyBDKysgc3R5
bGUgY29tbWVudCAiLy8iIE9LIGluIGtlcm5lbCBjb2RlPw0KPiANCj4gPiArLyogQ2FsY3VsYXRl
IHRoZSBhY3R1YWwgVERNUiBzaXplICovDQo+ID4gK3N0YXRpYyBpbnQgdGRtcl9zaXplX3Npbmds
ZSh1MTYgbWF4X3Jlc2VydmVkX3Blcl90ZG1yKQ0KPiA+ICt7DQo+ID4gKwlpbnQgdGRtcl9zejsN
Cj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogVGhlIGFjdHVhbCBzaXplIG9mIFRETVIgZGVwZW5k
cyBvbiB0aGUgbWF4aW11bQ0KPiA+ICsJICogbnVtYmVyIG9mIHJlc2VydmVkIGFyZWFzLg0KPiA+
ICsJICovDQo+ID4gKwl0ZG1yX3N6ID0gc2l6ZW9mKHN0cnVjdCB0ZG1yX2luZm8pOw0KPiA+ICsJ
dGRtcl9zeiArPSBzaXplb2Yoc3RydWN0IHRkbXJfcmVzZXJ2ZWRfYXJlYSkgKg0KPiA+IG1heF9y
ZXNlcnZlZF9wZXJfdGRtcjsNCj4gPiArDQo+ID4gKwlyZXR1cm4gQUxJR04odGRtcl9zeiwgVERN
Ul9JTkZPX0FMSUdOTUVOVCk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgYWxsb2Nf
dGRtcl9saXN0KHN0cnVjdCB0ZG1yX2luZm9fbGlzdCAqdGRtcl9saXN0LA0KPiA+ICsJCQkgICBz
dHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCAqc3lzaW5mbykNCj4gPiArew0KPiA+ICsJc2l6ZV90IHRk
bXJfc3osIHRkbXJfYXJyYXlfc3o7DQo+ID4gKwl2b2lkICp0ZG1yX2FycmF5Ow0KPiA+ICsNCj4g
PiArCXRkbXJfc3ogPSB0ZG1yX3NpemVfc2luZ2xlKHN5c2luZm8tPm1heF9yZXNlcnZlZF9wZXJf
dGRtcik7DQo+ID4gKwl0ZG1yX2FycmF5X3N6ID0gdGRtcl9zeiAqIHN5c2luZm8tPm1heF90ZG1y
czsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogVG8ga2VlcCB0aGluZ3Mgc2ltcGxlLCBhbGxv
Y2F0ZSBhbGwgVERNUnMgdG9nZXRoZXIuDQo+ID4gKwkgKiBUaGUgYnVmZmVyIG5lZWRzIHRvIGJl
IHBoeXNpY2FsbHkgY29udGlndW91cyB0byBtYWtlDQo+ID4gKwkgKiBzdXJlIGVhY2ggVERNUiBp
cyBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMuDQo+ID4gKwkgKi8NCj4gPiArCXRkbXJfYXJyYXkgPSBh
bGxvY19wYWdlc19leGFjdCh0ZG1yX2FycmF5X3N6LA0KPiA+ICsJCQlHRlBfS0VSTkVMIHwgX19H
RlBfWkVSTyk7DQo+ID4gKwlpZiAoIXRkbXJfYXJyYXkpDQo+ID4gKwkJcmV0dXJuIC1FTk9NRU07
DQo+ID4gKw0KPiA+ICsJdGRtcl9saXN0LT5maXJzdF90ZG1yID0gdGRtcl9hcnJheTsNCj4gPiAr
CS8qDQo+IA0KPiAJXiBwcm9iYWJseSBtaXNzaW5nIHdoaXRlcHNhY2UgYmVmb3JlIHRoZSBjb21t
ZW50DQo+IA0KDQpXaWxsIGFkZCwgYXNzdW1pbmcgeW91IG1lYW4gYSBuZXcgZW1wdHkgbGluZS4g
IFRoYW5rcyBmb3IgdGhlIHRpcC4NCg0KDQo+ID4gKwkgKiBLZWVwIHRoZSBzaXplIG9mIFRETVIg
dG8gZmluZCB0aGUgdGFyZ2V0IFRETVINCj4gPiArCSAqIGF0IGEgZ2l2ZW4gaW5kZXggaW4gdGhl
IFRETVIgbGlzdC4NCj4gPiArCSAqLw0KPiA+ICsJdGRtcl9saXN0LT50ZG1yX3N6ID0gdGRtcl9z
ejsNCj4gPiArCXRkbXJfbGlzdC0+bWF4X3RkbXJzID0gc3lzaW5mby0+bWF4X3RkbXJzOw0KPiA+
ICsJdGRtcl9saXN0LT5ucl90ZG1ycyA9IDA7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4g
K30NCj4gPiArDQoNCltzbmlwXQ0K
