Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6C7CD657
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbjJRI0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjJRI0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:26:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADCFEA;
        Wed, 18 Oct 2023 01:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697617579; x=1729153579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hnzx179xYIF7xG+i1kuNK9JNjMa97f5ctTo5uLbnwQc=;
  b=WjcgBxWk/8TSszFmLngjn6jM489Fs1KKS9Wpu3/Fb5wC3JZ0FZywoBsd
   XLF+YpUuUxLhsPAvhjfs5v8s6OGOcn9ICNo3LFqokxFC14kSxLJuuGHai
   BHE8G68dZh9MFfSIxm9po9KvQBKwXLqJkfNI24eRj6YRu3+5E6/e6mbEc
   4/of5pRIOlYes+TDKWbSqlEiqRc85Y4o1xsXThD00eyjfLpiXX8e5p3cS
   3+Ok+rvJoFaqL4kcHeVoZ1/5zwLTHmwuI9TLkV6GNX3kLKnW+bnw5vYZk
   FnyqSWNtZAUA52zjRili/ZylJwFkaqTqOsUQU6W11H61PEYx6NNqatzYG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="371030294"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="371030294"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 01:26:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="760136535"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="760136535"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 01:26:18 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 01:26:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 01:26:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 01:26:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+CPUuKN8dDPeydIgV9OCMlxi7uG98IAnvg+j472lf/I+pd9oJGI2qPM49CXwjPLvWI0GzSF7IpQRoX9Fhx8j6WolPs2Ul+NBaEsTApWtyVO7V3U6ov1qFi5nBj52r9S+LzKg4xHZs1CItqR2UXMVa3YaxYtS7UpzsPX2cRTbDOOqO2DwHR4JehVFhDhpgTDiKNajDoQ/t/wGo+CXoDV/DholyoyFDQgXYtcmofQ418AeuwdCNBSOIWKgI4o4vyNoXx+dFxErcveFGvQmXcfRJb0T2mg2xzUC2i9Hm30+eKC1BbQkhGNvDxY/dsMonefUzB9B2WiJv394Vv3Gl+d2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hnzx179xYIF7xG+i1kuNK9JNjMa97f5ctTo5uLbnwQc=;
 b=EnQdai8nsZ6BF7OzG0u6Q/aje7JtM8tmTnI+MGSLImn/odtrMw3s+EqMDQ5y07gwy4jDKo9eQGs3ateXjt1wfugM3btqsaBdJQk/ciS0qHM74DAF0HZroYjTMjQvbOc2JUkvIh+sWKF48ZFXwhwB7Ki1PZLIqTxiyWIjI8FggSxKVFIDLZQCm2DUnpxliBQqSdLgbKJb0xl8WaLULnNp8nyJHouRuVNdtl5qv/a2qFrjxDAgsGBuLSIN/UuYAuW7Y6C3qOrgYgecpHO/WDy0dwvSDnLvIJGr5yyyUKHwUbN0NBcj8GW9KsrjUqlMKisIzRbzkStSS2NN/SrrJu/6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN6PR11MB8194.namprd11.prod.outlook.com (2603:10b6:208:477::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 08:26:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 08:26:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v14 06/23] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Topic: [PATCH v14 06/23] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Index: AQHaAN//+iiEoA3qq06EP8adX/VyubBPKuQAgAAM3QA=
Date:   Wed, 18 Oct 2023 08:26:15 +0000
Message-ID: <167ef30ff7020f8a3d02976508d004845744094d.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
         <7ed3e212-caf0-4148-9d5e-27c14facaa05@suse.com>
In-Reply-To: <7ed3e212-caf0-4148-9d5e-27c14facaa05@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN6PR11MB8194:EE_
x-ms-office365-filtering-correlation-id: fc49283d-e1c2-4a8d-c08c-08dbcfb3e505
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eqE2hc7vzUNeoYi/i+Xf+JaoYierLezdoYM9vovCLK/1O7LS/11eYMF7Gz1PMRBzsBrJvmbKsgedslTuhfpIbLmyqsHkrkBIfkcd/qBP8FhBEZ6w+lpHz4+1PXNtq2Otej3orMjFuKllkwrdX5X5jvCPvg1U7yivgHSedg+23xFxtk6jHWIBmrrVnavY9ahmoTY180GIe+o8TjiJ0L8zGwZhIqan6Ryp7k5+4aLEmWtBJgUyQixiauSBs0aZXmE4Y5SZXGP3Bm7SwtVDow+RcmBpzayjcEOprliSERp4Pd45pDSa8p3lVvISu2hLZhBeJKvEfH8Om6s+2svAfdPDYFDzvjr38SEz3sgiRNzYJqrc4N2l31orROvXw5jQcId27K25OGsCP3buirqaL9o3i7wJpJA8oOgTnl45Kk+cYzycGbo6b118TIWENtbfZNhpyEv3pK3MBj0Ia9bGY1WqMNDiNr4f2OQC9f6n/QyupNo87oOCKsmBn3c6ADBc99pGzMMiK/gtRUaNgVLADvMYL4PKupSBsDgvs8o1mP8TEeqnbWa1YyLWuYaXgVqdjRXV2ew/86zK1KZlkL4xMI5n8iAao5pwNqGIqzlPOzOI+Ha3iAURJnQ39GSlWKRdxH3d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(366004)(396003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(71200400001)(122000001)(26005)(6506007)(2616005)(91956017)(6512007)(110136005)(7416002)(2906002)(41300700001)(8936002)(8676002)(4326008)(478600001)(316002)(66446008)(66556008)(6486002)(5660300002)(66946007)(54906003)(64756008)(66476007)(76116006)(38100700002)(82960400001)(36756003)(558084003)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak9oQlJNbzdRUlA1SldCc2RXRllGb0ZtY0pVb0VRdDlBZGZQYk00dVJJWXFI?=
 =?utf-8?B?c1k4WmUyRWQ1ZlFEZnQyQU5rd3ZjekNXSm8xVE1yMXNmZlhXS0UwQTV6MER3?=
 =?utf-8?B?dEt5MTdEOFVTemt6VWFROHdweTlIWitsSUlOeE5UWDIwcU03cERvSG5ES0Mz?=
 =?utf-8?B?SVV3N3JyVkhDRXI4ZWJaZEh3OGJ4VnJ0eWNEZ2x6SVVtK2JjSUlva3ZpNlNu?=
 =?utf-8?B?S3lGZ1JUbG5MVjRKdjMvVFI3Y2NuZUVnL0dPdlhoTUhYbG9OVnVkMm5lM0xM?=
 =?utf-8?B?a1ZSY0FHWm5aOXhGYjBPZnN1bzhsY3ZGdElQQjJNZTBpOUVZb2ZzL21pWkcx?=
 =?utf-8?B?WG5Cb1l2bHJiSkYzZUowZ3V4bk5JaHNmTFJlN01tcUhCQ1I3YXNPOFFtNkNG?=
 =?utf-8?B?OFM1UWJicG1XRUtQY29pYk1MWjY4QkhoV3VCaGx1L2FFK3Z5aXZKUTlhZG1w?=
 =?utf-8?B?QTFpWHl3L3o0Q3pzaVFIei9vdEFEU25OaVRpM21abDF2V09xanE4V2F1N1BT?=
 =?utf-8?B?Qk5kKzQwenE3eklGUnUxRkhUTGdDRFVRcXBMQTcxK3N0Q1ozaTNGY0J5bUho?=
 =?utf-8?B?b24wc0thcGpRVGRSN295cys3T2VaM3lPclhrMVg3aWp4WHJRRlJ1MnNmL2Vo?=
 =?utf-8?B?dXpObW4ySmJFbFlYeC9ybFc0ems3a2VJNkNTK2dHeUdJMDltWitMaUJZWk9L?=
 =?utf-8?B?TnBseTcxL0o4N3VHVWFJNUJqZVRkU3NXc084bk1UNHZkNTlkOGJ0ZURkaURm?=
 =?utf-8?B?L2ZaU0FrYlZnQ3hqVThiMzViUWwyU0RHeEVhMHhOdFpBSG9EN3dhWWk3OVhv?=
 =?utf-8?B?b2w5UTd5YUtrekIxMU5POVBCendMUzgveDFnNjNRR0tCS3k2TzR4YWRQRnU0?=
 =?utf-8?B?WlhLclFqRStjdGFoblE3T0d1bXI4YTJ0K0EzQjJpMUpvOWptWWRsWmZsRDB3?=
 =?utf-8?B?UG9oeFlPUmlDak4vcTR1NkJXTjJ2NXNKdGx0ZGsrb2lYNk9kaG1ZNFlNZmZ3?=
 =?utf-8?B?RXVoNW9TZzRjN3R0c0ZFZUNuWGpSK2wwc2dEMUtzS3BKM0plYmxxb3ZnZlNL?=
 =?utf-8?B?Lzh3elF3dkc0c1piZE5rdzNYV0pFbGVmNnBDS0lRMFVHL3JDS2ltRm55aWdD?=
 =?utf-8?B?NDhKei9TOXN2bWZLNkJKZzRVcmsvWWRITjM4b3N1MTZvb1o0eHg5YlNUYmdE?=
 =?utf-8?B?cng5c0VQdnZ6dzlIVHVGRTVYUDRJck13MkdoOTdEMVRkMUdNdlRKOUZaWVdp?=
 =?utf-8?B?UHRrSVFhWWpzYWNPRmRtVlAwN2ppdm1meVFLSkNsUERhQ3pZeXZxdDUxUWV5?=
 =?utf-8?B?TDJwTGlCbTdXYk92ekhZS3RjMVAwVXNlaURNTll0d2NNdm94aHZ3UVpoRW5j?=
 =?utf-8?B?U1BGakdNUDh5c1FwT21BNUxFbUhCRUlDU1d6OStXR1lRK2R1KzNseURiQll1?=
 =?utf-8?B?SlVDTWJnTUFzb2x2TWFKbytGRXVETHdzZW9GUWJURDhjS3VRS0VTb1ZFL3J0?=
 =?utf-8?B?YzNRNVFyMGROUXowQVRIckVvQTQrUTVtM21lVWpBMTdQZlVudERRM0tTYzFF?=
 =?utf-8?B?NEF2TGg2aXVWQ1pyd3BUeHVySmtNMEk2NDE0UEQwTVk3eVp4cENjUEFla2Yv?=
 =?utf-8?B?dTQzUWRzMExaSVd6Q1lVNm5UZy9UTkhQZG9IcG4vR2dhU0E0NHU5NEhEQStP?=
 =?utf-8?B?bEFmVVdMeFRLT0NLYUw5ZnJwOXdFN21RSVVxVEZYVUR4MFNmV2tMTko2RlQz?=
 =?utf-8?B?RkhuVDFaclNLSDIwYm5ZcmxNZUxCbUNodHNkRHZITkhWVVRvWDVJbHZpY0t3?=
 =?utf-8?B?dFUwWUQ1dlJFMGVvUUg0QzBPSFI2eElvOHZnQ0lyd242VUlFblNrV2Vsb2NJ?=
 =?utf-8?B?L0JZZmMvWWloV3V0WlM2dGIrMjRpdUVTaXY3Q2IrUm82bVRoN3hZT2VYU0c3?=
 =?utf-8?B?eEZYUnQrQUVRWjVzWlRVNlBPdzZwQzZjNzIzQjQ4RWRhcDliRWpBTll0SFV6?=
 =?utf-8?B?SnpkUWRsRkJWSlk2Z2JXT2IxRVpMQkt3eWJNMDFqdGVSSjFiZndJWUJLWEk3?=
 =?utf-8?B?a3BMWVhORmRyaTU5ZWZINDloNFBHdDBEWi9KUDhQVm1pTmtOMTFGRVZNQWdx?=
 =?utf-8?B?SVVVdlBkdXBxVkY3QXVOYjdOYmlrZHR0VjZ2aU0vMjl3K3ZSeUU3TC9PYlNn?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DA25C7242B1804EA410A78BF83680BC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc49283d-e1c2-4a8d-c08c-08dbcfb3e505
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 08:26:15.1169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ItmyXloQOz6xqNoqRccP25+26cHh/GunlsqOICEMHCwGrkYZZxsHBEc0hlNh9PK5UHLoqk2ecFA9LE7CccqolQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5lIHZvaWQgc2VhbWNhbGxfZXJyX3NhdmVkX3JldCh1
NjQgZm4sIHU2NCBlcnIsDQo+ID4gKwkJCQkJICBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdz
KQ0KPiANCj4gVGhpcyBmdW5jdGlvbiByZW1haW5zIHVudXNlZCB0aHJvdWdob3V0IHRoZSB3aG9s
ZSBzZXJpZXMsIHJlbW92ZSBpdCBhbmQgDQo+IGFkZCBpdCBsYXRlciB3aGVuIGl0J3MgYWN0dWFs
bHkgZ29pbmcgdG8gYmUgdXNlZnVsLg0KPiANCj4gPHNuaXA+DQoNCk9LIGZpbmUgdG8gbWUuICBU
aGFua3MuDQo=
