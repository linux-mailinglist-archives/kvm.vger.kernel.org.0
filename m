Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A8A594ECC
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbiHPCnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239779AbiHPCnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:43:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D08785B2;
        Mon, 15 Aug 2022 16:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660604818; x=1692140818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dRY6ayCx6ULVfcJ6bmtWvEgjJ6T2B0XjykI24nbGyvU=;
  b=Gs+fQ+ZhbGNvpZJVQezUFAPvKcOHN0fImq9WSjrkP4wngaLEMQQG7pgb
   qbtjMOSxR4F5AIn18LZlfJ/Nszy/madmUIDVkO25y99mv7BIgo76UuIgy
   deuHCBIm35ZDzIg9eBswQK1P/jGxXOd491K/SjCiqCfG/41zCQH2QGjyt
   9QcXqjaGbb7zMRcaA6ZehMG8ysVjiSnMK26tblsqkzIqzzBvfXt+S95N6
   HQ9rLb/MZtpZ7VqMPYeq9g0DrTpCJQS6kRLgKdGczPLnCOReYThogKyt2
   0qOvgIDiaU9XXN5xgMFRjWR0rIHwbkDM8J6ZbSbWJbQIC3uNBCuUmFD/L
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="275130526"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="275130526"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 16:06:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="852438988"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 15 Aug 2022 16:06:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 16:06:57 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 16:06:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 15 Aug 2022 16:06:56 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 15 Aug 2022 16:06:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdwJtECCcQSPhYG44NiMbMyJ3ikfnnHv6tBxSpmOBeh/yu5Z4s79zCFQvijN84nUoqxhKMnSM2Sh/lWXt9UMMHRohaXAduN4mGvQPJY34LdBJE2nZOEAJBV/43MCGItEwcusV12ari8RRCoWbefAbf9VCjljHKXIY0nO8KHz1O6hZ1mdEaFIWBA9JhoFTX1KZFtt7IppUo4SifWw2Wls332K3vzpb4x/ARu6vZbTOK9HG4c/aVvvsylh37oiOrjoD0zxNee5RFTSj0wb9W0Hja62r7vIYtbjFA1ZE3jwSrNUrWZ7Si44tDmA5WlyFq/2gYvRzHSVJU1E1I9raTssmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRY6ayCx6ULVfcJ6bmtWvEgjJ6T2B0XjykI24nbGyvU=;
 b=ZppOjNmF1h9iOS6czpNC3igjqZWuukS1u54M8L/PHj6anATX3vsgqP3qXkQLOddHQT7LaTCipXlQQ25YiNIiRX3Mh4Lc5f+d4H8M21uWSWbPYtjRL2+R3INMdQ1LpszURw2ECbosm75/InA1KoyZX+rTB9f/J4nQIxaWgAr5rzwvyDcPMJUIQnhkwzE2157FXqVG27/Q7hdOTMe+ZEnL3ye8+HYOMcqifCHcZ030arrYIBjUVt3kFfuH4W06aaMHJ0T5AH12EASYaLHXXyOjINxD93Vgar+aByRmvazHQ9BeESRM0kSbx2tSiWZE+7RmzFzKy8jF6d7kixngSXn+Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BYAPR11MB3159.namprd11.prod.outlook.com (2603:10b6:a03:78::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 23:06:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Mon, 15 Aug 2022
 23:06:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on
 module initialization
Thread-Topic: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on
 module initialization
Thread-Index: AQHYqqlwfDjYAxxVB02BDeW+TIJM8q2pkiaAgABrQYCAASyDAIAFb0qAgAAI4gA=
Date:   Mon, 15 Aug 2022 23:06:53 +0000
Message-ID: <636a0ddb3d6c56fd14357cb2d5392d429ab604b4.camel@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
         <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
         <d36802ee3d96d0fdac00d2c11be341f94a362ef9.camel@intel.com>
         <YvU+6fdkHaqQiKxp@google.com>
         <283c3155f6f27229d507e6e0efc5179594a36855.camel@intel.com>
         <YvrKGUSud3F/9Qnm@google.com>
In-Reply-To: <YvrKGUSud3F/9Qnm@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c54b9570-c015-46bb-0c3d-08da7f12d7b2
x-ms-traffictypediagnostic: BYAPR11MB3159:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E0J/CC7m2Hkim1VA6clk2pWgDXPhF7CuTcEFaujaWaIlJAfVH9WnbzA/20pgbtwwqzB2my7gddndKLxXFlqMSDmdoj1WEZ+4Wdd8+Xd7h5l15eoPWlCSTZ8YHp+gEyg19upIh/toc2iVxosqS1+unm0EPIrmp6a5A9RU6hRvzxawP3ztHL2rxJvA+ZxPUrWh8OgVnYK7DvosUkYw+MYuVD8TqHh9HpiF7648DwZqMaQJ/5bInuVB3GPEOBc+K6mtBFTuJhuUcgdzeDh4S8KpBClh3NPk8fjjakt+YfKXLmVfCwMeEBqj0481b6xM0/yAlQzcLVB2N/uG6UNtu1sLNC6HqwZhIS9ewzl98pIe7Hnb6Vacvh1txw1ij1IuG804ofAykOedgFTQHYEt5SLmQ+5mWa21odHGiy7Do28QRhmThOD+wbCCLBaP0AGTdhmA9DYPLOIJhpKv9OViinuh4pEUWoZUNSZnet8dmQG9iGBRBO9XTGx3rRvZtwmuK+66oizsxKSN36bEHrOyTb/2+lDJtj+IyBqAiCRlKLAHgykaZQMjtJjfUs9iyi0hw++OC/jkgP9dvLn0FoMgcIiV+jfR4ETRy4HRfo2BsnpoQ8m2FXNrAwBFzly5gq5E4aa9MYu/rzn3hSSi2uh+rm8CvwU77DeIDPM8IJvo4Ccsx81bCMBXODDIgW3HRuBAzTgx/rfYkwStTQt5H4/7xuoWjpGv8Aqhmrd4n0X7SDatBP/8+6Iyrxz2a+A04T6o3YBTbCquPwfBqBw8kTexf9ZXcAH8CPQ4UIx3zLx8Yck89j+8TJvjVGM2dwf9eFp9CO/Lz0KFitXRBez9VATGhiZMepun5mIH8IcdPt+fXZo00bHFA0xSxCYgKXeMQ6mwAOgf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(376002)(136003)(346002)(38070700005)(54906003)(6916009)(83380400001)(316002)(82960400001)(36756003)(41300700001)(6512007)(6486002)(478600001)(186003)(2616005)(6506007)(5660300002)(26005)(966005)(8676002)(76116006)(66946007)(66446008)(64756008)(2906002)(66476007)(122000001)(86362001)(66556008)(8936002)(4326008)(38100700002)(71200400001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWcrQnUxZXorYTFteVNCeDJpcU05SVpINWZCcXlXdUpjQTlPU0NYMDVLb1lu?=
 =?utf-8?B?VEJpMVJHSUlkR0k4ckFYOGlJaGVtM3lBOVQ5Rzl3Q2ZTck1pbGQ4Z1AwQVFn?=
 =?utf-8?B?QmtYZHFBSlJBNzdFZ3NzVnFQOXJDNTBqWjI3K2JmYTVmcTlhcGtHZXFQams3?=
 =?utf-8?B?VDRKR2FhdmhRR1JBeVB5eWdCQ2c3ZkZkb2lsWnZhdzZWVWVlSVJOMzFtaCtG?=
 =?utf-8?B?M3NtcWV3UThVSTFuNnBBcytFcXpCUDVwMStzczJSRVhEK0FnN01IQ1llT3FX?=
 =?utf-8?B?R01UZXJpVTB4N0Q3SFVTdklteUR3OTExUzhIL1dTdERUUFVqL0JNQW01dEti?=
 =?utf-8?B?VDN4UkdRekVBQU13cEhIbUVpbXY5VVRUQXEzQVNSYVQ3UFVtNGF2SXdYbHdu?=
 =?utf-8?B?NVlMMXVoanBkYXVoZkVOaFY1aVNJWk5FUVduR1BxT0wxMHRaWS9qMzFLWEFz?=
 =?utf-8?B?QkdpZ2ZEaTFGRTBLR3VXWkswY0doWnkvZCtwZ1RxQ3hONGdySy9kOWlQU25w?=
 =?utf-8?B?UmFnUmVBZkNyYWlBYTFHN0hqWUEyM3dSdjVLKytUeUY2a2V5NDJRNFFxNkg0?=
 =?utf-8?B?WDJVaGc1M0xpOFlFc2t5NVVFUnk0ZTdnWU5Zb3hSMlJpVVJXSWFYVk9wTnhV?=
 =?utf-8?B?NEpOaUQ5ZTZSMCtiNElXNzVEb2poeUNuSXU3U3F0V2N0LzhzbUlFcXZkRnor?=
 =?utf-8?B?OGtIWlhsZ1FNUkkxSDJ2WWhvMVp1ZHJGS09FVm9qcVI5Yk9Mb0NQWTVSaXBT?=
 =?utf-8?B?UWNYcHBXT3pudE1BQlpUVTIvQ0ZaaU4yQ20wVk1pYkd6cE9NQmJCRGxRK0FR?=
 =?utf-8?B?MmpJRlZEZDdMSmQ2UGxYNmhxWVNBQUJraXlUSFBIVkxwOU4wUTlOdE9oUTRt?=
 =?utf-8?B?QTlnMjE3SHBZTDJmZVR5aFQ0a0ZqNlFaZHRzOG5HdFk0SUlibUFyTkl1SVI5?=
 =?utf-8?B?ZmhhZWR5TW1CdEpiYjc4ZEtId213V1FjcTZtcVRWbml0Tm5EREloS2JOZTlF?=
 =?utf-8?B?MDZFSDVEa3lqRDNyaUFPU0ZhWFF1YTJnZ0lIUzFSc2VmL2lrTmFueGdYQXh4?=
 =?utf-8?B?TGtsdm0xM29Db2VSOGFsb0JDZXFueG5yM0xKVTFxYlBsalFWSkdRVmlEdEVF?=
 =?utf-8?B?alFFMDlNN0Y1cGw2a1dCckNjMjhPZmRFQkdJSWxORjU3Y2I5Yll3SFFxUklB?=
 =?utf-8?B?Q3UrbXI3TlUvVUxVTEZXS1VadS95dGNSWStCWGhadlVSSVUva3FjUWdZVFlm?=
 =?utf-8?B?cFpiTzFQcHZ0cGU4N2h0TWgxSDFFeWpqbWZZdjBzeGV0QmNmd0lGdXVPZkp1?=
 =?utf-8?B?aDEwSnUyUkx5dXk3NzIwSnRiczJjSWhzZXlrSWJMMk14Z3oxa09vemMzTHNB?=
 =?utf-8?B?cWdYOVJKaEJmV1daTXlTbXl2RlJpc1MrN1NZZlFvaHhNUDBhNDNLTDZyNWNn?=
 =?utf-8?B?NmJNK01NWHRPQ3FLMWpaMHlycDhPaCtJMkovNG5tSitSUkU3bDk2TGtxeDZN?=
 =?utf-8?B?T2txVmc5cE0yTTR4a3llYVNQRkRUT2doZTVyOWhDSWU4c0IrNlpLeko0enY5?=
 =?utf-8?B?QThSQjBSOW9XMDhLU2xBMUowTnM3ZURUV21LVk5ZaDZJcWhSMWpLbnNkNjFQ?=
 =?utf-8?B?MUpkOVBnaUlzOWxpc3BVRzgyZ2VWNUI3b1FuTnZscVlqVzQ2Y1gxbnBCM0xM?=
 =?utf-8?B?eGY0YW5RanNHWWFSWU4rY09YNTkwanEyTm54SHlKY3NhS2FCVzk3OThzVVM1?=
 =?utf-8?B?T05EaGY1OERIdU12M1R1SW1LZG43ekY0REtENFlsbWZDTUsyRDhId2o1cHhj?=
 =?utf-8?B?UmdadVJPRWluaDhYV2txRXV4UXovaUVCaG5FTnloR05tK08yd1d1dTFIdWZS?=
 =?utf-8?B?VFRSeWxRNkNPb2REQTlXUWxDa2kyTitTejZmZjVVeWRrV0VJQUg1QWVQTkt2?=
 =?utf-8?B?YmVqN2NwYk81dG9LRlNjNjVqR0JTbnBxdDZvSmVRTGEwTXNoN1dHRTUwck9Q?=
 =?utf-8?B?RVJxNFR4S2h1ZTZSd212WFFwbHBPVlVrWk1JelpXMkFYZHE0cDBndkYwbUFG?=
 =?utf-8?B?MlROY2NXV01ibVNjejlOQmR6dzZWU1JrZVFGUFgxNDZWUTFpTEZYUU1JdmJq?=
 =?utf-8?B?cCtUN2pTdXA2KytuRm9WSkVtMDhqOVJtQ0gyOTBWQWp5YWkya2prbXhjRXJs?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC9500C47BCB204AA445A10DA90CBBB6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c54b9570-c015-46bb-0c3d-08da7f12d7b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 23:06:53.1099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9yjr0dHgT10oZgiOzKaFcRMUelb5x+LcISl8TDio6rwEdVAwGxErOejC15r6QnAG19F5FMKBWgQYCAFs4RgBPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3159
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTA4LTE1IGF0IDIyOjM1ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEF1ZyAxMiwgMjAyMiwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjItMDgtMTEgYXQgMTc6MzkgKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBJJ3ZlIGJlZW4gcG9raW5nIGF0IHRoZSAiaGFyZHdhcmUgZW5hYmxlIiBjb2RlIHRo
aXMgd2VlayBmb3Igb3RoZXIgcmVhc29ucywgYW5kDQo+ID4gPiBoYXZlIGNvbWUgdG8gdGhlIGNv
bmNsdXNpb24gdGhhdCB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBpcyBhIG1lc3MuDQo+ID4g
DQo+ID4gVGhhbmtzIGZvciB0aGUgbGVuZ3RoeSByZXBseSA6KQ0KPiA+IA0KPiA+IEZpcnN0IG9m
IGFsbCwgdG8gY2xhcmlmeSwgSSBndWVzcyBieSAiY3VycmVudCBpbXBsZW1lbnRhdGlvbiIgeW91
IG1lYW4gdGhlDQo+ID4gY3VycmVudCB1cHN0cmVhbSBLVk0gY29kZSwgYnV0IG5vdCB0aGlzIHBh
cnRpY3VsYXIgcGF0Y2g/IDopDQo+IA0KPiBZZWFoLCB1cHN0cmVhbSBjb2RlLg0KPiANCj4gPiA+
IE9mIGNvdXJzZSwgdGhhdCBwYXRoIGlzIGJyb2tlbiBmb3Igb3RoZXIgcmVhc29ucyB0b28sIGUu
Zy4gbmVlZHMgdG8gcHJldmVudCBDUFVzDQo+ID4gPiBmcm9tIGdvaW5nIG9uL29mZi1saW5lIHdo
ZW4gS1ZNIGlzIGVuYWJsaW5nIGhhcmR3YXJlLg0KPiA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYWxsLzIwMjIwMjE2MDMxNTI4LjkyNTU4LTctY2hhby5nYW9AaW50ZWwuY29tDQo+ID4gDQo+
ID4gSWYgSSByZWFkIGNvcnJlY3RseSwgdGhlIHByb2JsZW0gZGVzY3JpYmVkIGluIGFib3ZlIGxp
bmsgc2VlbXMgb25seSB0byBiZSB0cnVlDQo+ID4gYWZ0ZXIgd2UgbW92ZSBDUFVIUF9BUF9LVk1f
U1RBUlRJTkcgZnJvbSBTVEFSVElORyBzZWN0aW9uIHRvIE9OTElORSBzZWN0aW9uLCBidXQNCj4g
PiB0aGlzIGhhc24ndCBiZWVuIGRvbmUgeWV0IGluIHRoZSBjdXJyZW50IHVwc3RyZWFtIEtWTS4g
IEN1cnJlbnRseSwNCj4gPiBDUFVIUF9BUF9LVk1fU1RBUlRJTkcgaXMgc3RpbGwgaW4gU1RBUlRJ
Tkcgc2VjdGlvbiBzbyBpdCBpcyBndWFyYW50ZWVkIGl0IGhhcw0KPiA+IGJlZW4gZXhlY3V0ZWQg
YmVmb3JlIHN0YXJ0X3NlY29uZGFyeSBzZXRzIGl0c2VsZiB0byBvbmxpbmUgY3B1IG1hc2suIA0K
PiANCj4gVGhlIGx1cmtpbmcgaXNzdWUgaXMgdGhhdCBmb3JfZWFjaF9vbmxpbmVfY3B1KCkgY2Fu
IGFnYWluc3QgaG90cGx1ZywgaS5lLiBldmVyeQ0KPiBpbnN0YW5jZSBvZiBmb3JfZWFjaF9vbmxp
bmVfY3B1KCkgaW4gS1ZNIGlzIGJ1Z2d5IChhdCBsZWFzdCBvbiB0aGUgeDg2IHNpZGUsIEkNCj4g
Y2FuJ3QgdGVsbCBhdCBhIGdsYW5jZSB3aGV0aGVyIG9yIG5vdCBhcm0gcEtWTSdzIHVzYWdlIGlz
IHNhZmUpLg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzg3YmwyMGFhNzIuZmZz
QHRnbHgNCg0KWWVzIGFncmVlZC4gZm9yX2VhY2hfb25saW5lX2NwdSgpIGNhbiByYWNlIHdpdGgg
Q1BVIGhvdHBsdWcuDQoNCkJ1dCB0aGUgZmFjdCBpcyBsb29rcyB0aGVyZSBhcmUgbWFueSBwbGFj
ZXMgdXNpbmcgZm9yX2VhY2hfb25saW5lX2NwdXMoKSB3L28NCmhvbGRpbmcgY3B1c19yZWFkX2xv
Y2soKS4gIDopDQoNCj4gDQo+ID4gQnR3IEkgc2F3IHY0IG9mIENoYW8ncyBwYXRjaHNldCB3YXMg
c2VudCBGZWIgdGhpcyB5ZWFyLiAgSXQgc2VlbXMgdGhhdCBzZXJpZXMNCj4gPiBpbmRlZWQgaW1w
cm92ZWQgQ1BVIGNvbXBhdGliaWxpdHkgY2hlY2sgYW5kIGhvdHBsdWcgaGFuZGxpbmcuICBBbnkg
cmVhc29uIHRoYXQNCj4gPiBzZXJpZXMgd2Fzbid0IG1lcmdlZD8NCj4gDQo+IEFGQUlLIGl0IHdh
cyBqdXN0IGEgbGFjayBvZiByZXZpZXdzL2Fja3MgZm9yIHRoZSBub24tS1ZNIHBhdGNoZXMuDQo+
IA0KPiA+IEFsc28gYWdyZWVkIHRoYXQga3ZtX2xvY2sgc2hvdWxkIGJlIHVzZWQuICBCdXQgSSBh
bSBub3Qgc3VyZSB3aGV0aGVyDQo+ID4gY3B1c19yZWFkX2xvY2soKSBpcyBuZWVkZWQgKHdoZXRo
ZXIgQ1BVIGhvdHBsdWcgc2hvdWxkIGJlIHByZXZlbnRlZCkuICBJbg0KPiA+IGN1cnJlbnQgS1ZN
LCB3ZSBkb24ndCBkbyBDUFUgY29tcGF0aWJpbGl0eSBjaGVjayBmb3IgaG90cGx1ZyBDUFUgYW55
d2F5LCBzbyB3aGVuDQo+ID4gS1ZNIGRvZXMgQ1BVIGNvbXBhdGliaWxpdHkgY2hlY2sgdXNpbmcg
Zm9yX2VhY2hfb25saW5lX2NwdSgpLCBpZiBDUFUgaG90cGx1Zw0KPiA+IChob3QtcmVtb3ZhbCkg
aGFwcGVucywgdGhlIHdvcnN0IGNhc2UgaXMgd2UgbG9zZSBjb21wYXRpYmlsaXR5IGNoZWNrIG9u
IHRoYXQNCj4gPiBDUFUuDQo+ID4gDQo+ID4gT3IgcGVyaGFwcyBJIGFtIG1pc3Npbmcgc29tZXRo
aW5nPw0KPiANCj4gT24gYSBob3QtYWRkIG9mIGFuIGluY29tcGF0aWJsZSBDUFUsIEtWTSB3b3Vs
ZCBwb3RlbnRpYWxseSBza2lwIHRoZSBjb21wYXRpYmlsaXR5DQo+IGNoZWNrIGFuZCB0cnkgdG8g
ZW5hYmxlIGhhcmR3YXJlIG9uIGFuIGluY29tcGF0aWJsZS9icm9rZW4gQ1BVLg0KDQpUbyByZXNv
bHZlIHRoaXMsIHdlIG5lZWQgdG8gZG8gY29tcGF0aWJpbGl0eSBjaGVjayBiZWZvcmUgYWN0dWFs
bHkgZW5hYmxpbmcNCmhhcmR3YXJlIG9uIGVhY2ggY3B1LCBhcyBDaGFvJ3Mgc2VyaWVzIGRpZC4g
IEkgZG9uJ3Qgc2VlIHVzaW5nIGNwdXNfcmVhZF9sb2NrKCkNCmFsb25lIGNhbiBhY3R1YWxseSBm
aXggYW55dGhpbmcuDQoNCj4gDQo+IEFub3RoZXIgcG9zc2libGUgYnVnIGlzIHRoZSBjaGVja2lu
ZyBvZiBodl9nZXRfdnBfYXNzaXN0X3BhZ2UoKTsgaG90LWFkZGluZyBhDQo+IENQVSB0aGF0IGZh
aWxlZCB0byBhbGxvY2F0ZSB0aGUgVlAgYXNzaXN0IHBhZ2Ugd2hpbGUgdm14X2luaXQoKSBpcyBj
aGVja2luZyBvbmxpbmUNCj4gQ1BVcyBjb3VsZCByZXN1bHQgaW4gYSBOVUxMIHBvaW50ZXIgZGVy
ZWYgZHVlIHRvIEtWTSBub3QgcmVqZWN0aW5nIHRoZSBDUFUgYXMgaXQNCj4gc2hvdWxkLg0KPiAN
Cg0KU28gd2UgbmVlZCBDaGFvJ3Mgc2VyaWVzIHRvIGZpeCB0aG9zZSBwcm9ibGVtczogMSkgRG8g
Y29tcGF0aWJpbGl0eSBjaGVjayBiZWZvcmUNCmFjdHVhbGx5IGVuYWJsZSB0aGUgaGFyZHdhcmUg
Zm9yIGVhY2ggY3B1OyAyKSBhbGxvdyBDUFUgaG90cGx1ZyB0byBmYWlsOyAzKSBIb2xkDQpjcHVz
X3JlYWRfbG9jaygpIHdoZW4gbmVlZGVkLg0KDQoNCi0tIA0KVGhhbmtzLA0KLUthaQ0KDQoNCg==
