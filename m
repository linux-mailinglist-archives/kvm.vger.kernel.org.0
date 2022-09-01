Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82E5A9533
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiIAK6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 06:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiIAK6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 06:58:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF66625A;
        Thu,  1 Sep 2022 03:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662029888; x=1693565888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R7CVUFZhotieug1pagbmSvJ3+IS3sAu4KPbxk1sNb5A=;
  b=I+P3UIiThzieLhwGFO3skKawH9UuD5qbJdGBmJTo9lIJ60OXzRGtQ7QQ
   V/wRza83QkW6fEaTh7/zBg7bBzywNJG5RYxutS0Rky6fy642XCTG5+pdv
   UoV3ZDPl6IFLuoCCjSS790VrIMx0r8W89i7zi/1NZhbj9SLTaaXFmyp0D
   KOMJzpuFXWCXclR6+Am9gOEoNNvpAZnV/0psY6ZkNjclu/EH51w7oFsav
   SWe/ClPuFW22ZJAa22WpgxTtrncxZg/+dLBxapiyTwu/lg5uSIetSsmkO
   4pLY0QuiVSF2qm034GmEkJhFjr3heXUeK1Ghau46OgYSDo/16ZMxVYgLX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="296966659"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="296966659"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:58:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="615298277"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 01 Sep 2022 03:58:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 03:58:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 03:58:07 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 03:58:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsreJPFdh/jv9GMlnbHDQigKVFtdGDOQjTXITy6MffDSrZPCUzbOLJhl0qgvmd4R942WbT03D/ruN5/3aN8Vfyq0pDExGGcm+s3JTryY6a3m0AT172G9SeaE58Xd5NwpYPPkBNP72i9lG6OKn4TBs2tNKka7yKQZwlFYZD1+tJYxmoAfGmuX4SK19icmRyWZQPhwpznIjNZiXvMLhSv80mY1firL5CiIkCuvaArUZcefS/9wb17066tVgAl7BIHOuHKD8nEIuMOjX+3FsTza6ryIvUhuRUbcs1Y3ziMv2H10k+6Dliqp1ykcqFrx1Kvlw2MzHyEQXm+0fH+zw5ihDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7CVUFZhotieug1pagbmSvJ3+IS3sAu4KPbxk1sNb5A=;
 b=RinkbLF5Rb5mWnmlWKDhcfJie2iGufuSMjwGJn4Rqj37FZMp3DL1DCSccY4wfpZKa4gXOvtMAKabOhNszVQg4SX/Nve2c+jUDexiiiv+2rHCVBAeq/YDhxI6+JjgxHyE1xr8gUhGHLi01i5jHyq2N2Vft1yLsbi1/xCXzCTHn8tjdTQ2bqYD5uix+cPgVlJU7CNAk/U+jsDj1xMqYFAJOgXLR84bJ2pod3CJB8tXWeXXOY/oBtltU2DKKbiajUeCzjqb9Y5QkQ+FPokWCkrDBjqC19g7eAmkoDxDaP3LnWR9t40Da/st9toatEiQDSueFZWPrzU9DWqh9X1EdGtKfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MWHPR11MB0014.namprd11.prod.outlook.com (2603:10b6:301:64::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Thu, 1 Sep
 2022 10:58:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%8]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 10:58:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 05/19] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Thread-Topic: [PATCH v2 05/19] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Thread-Index: AQHYvGhTeepRWiEV1UiUjOzgaPZBxa3KHGWAgABONIA=
Date:   Thu, 1 Sep 2022 10:58:04 +0000
Message-ID: <933858c97f69bcf6fb00ea5dcb2ec9fa368eced3.camel@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
         <d2c8815a56be1712e189ddcbea16c8b6cbc53e4a.1661860550.git.isaku.yamahata@intel.com>
         <YxBOoWckyP1wvzMZ@gao-cwp>
In-Reply-To: <YxBOoWckyP1wvzMZ@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44d335db-fc1f-47e3-e2b7-08da8c08d8be
x-ms-traffictypediagnostic: MWHPR11MB0014:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +VirdgfGf9n4IftXnUUm2T28Bajb5rKj3NNu7MnMK3kGX5MEQ/0h2UPWPko/721bMqzojkeR3okAOLEk64sSOI50774qAciHsHwrpokTkFVaMQQf3rLipmPqgKqanTGJwRdJEio0XpX1pvDjbLCiWBFyVPLhlZZJhnVucjRoOO6Gn5PDsr2hAEG1A1yR4rVdg5+Edw2Oi6xSr6gkbFWFY77p2Gf9u1BjPq4g/Y/S7+stNSWAJOPIvSwRnh6pUyKy4iK08gKW92frzQunP08UuPPMx/OpRJCVEKtXrKt1/U1WrcGe1xyEx+PzLP0lI6iDKzZ9XFvOpxVfJI7+fRaQYCICNh1q98TYDzVzxXAY7XdlwGhw3/LHRnGUdhdISjhNGFzupoqmpEcRyGzwv2CV+heWsr+IoR8dNcgdcMiIfMUS+8Z96fd1JDUgQ5BSMpVOQFYtzR+zJO9pYSF+4qKDC+anSVOUYByM9CmIzbLWOGjunItR15k7pq46Qr+PllPQ3uw4x2drRHIrJPElw04Z8DZUcZ2+EcUSuYYho6jiXubGGAw/bTZPger1dl7S6p8R2F04g6CJL7McTyQ3fUpz1lvVWjNA9M4d2CSUWD9k+Gt9sH0fw/LisqrvyadmgdeLuRAp2codbIO31LC38mUVpRUTAWExQZ0UOphJ0J6PKboD5dcCMw0NTcpUKK1+8jc/8b/HAuCyyTWzaXv9J3yC9Nl17ReMveUl87w3DmICBKKhefrnUB6KsLljIz0xVuO3uLUenHBrx9UniG3vUymKo8sVO6AzozqMPxJDdHGmn5ahFGKfCmXAmsaD70kyvsmy2x+NIGnTnwMgROatSlMnrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(39860400002)(366004)(346002)(66946007)(66556008)(6506007)(186003)(2616005)(38100700002)(36756003)(2906002)(83380400001)(71200400001)(122000001)(316002)(82960400001)(26005)(5660300002)(6636002)(6486002)(478600001)(54906003)(8936002)(91956017)(6512007)(110136005)(86362001)(38070700005)(41300700001)(66446008)(66476007)(76116006)(4326008)(8676002)(966005)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dk1OSElBWGRSNzJqWURmaG1wa0ljK2lxYUdrQzJFZ1FwNFJjZElxS2hRLzZ3?=
 =?utf-8?B?TFFicGVEaWFlZzYxSlRHVHpiNktCN09lWUxOUzBwYlk4YzdQMFBMRjBLczhs?=
 =?utf-8?B?NVFZTENQM0dqTzZZQklwTFdaTU11WTdKY3RVYU1pNTFjUEVLQUZuMjVDblBK?=
 =?utf-8?B?b09oYlQva2pkWWhnWEVsenFxd2ZBQWg0VWwrbGhPYmhRcE5BQ2pPckpxZVRi?=
 =?utf-8?B?VzMvSlRSTi9iQlM3MFgwZ2ZUckpSYVRsTDdHaEFDMlZSbEhOd1dheThCekRw?=
 =?utf-8?B?SlNQcW9zR2l2UDd5R2dwRUpYcDdFeWhTeFVFV0ZEOXVUM3lBRUFBckxoUlFh?=
 =?utf-8?B?em1yNU9EOCs1ZFBoMzVOUVJJRmMvK3pVYmtQYnBDUHNWWkpzcG9GS2xNaTAv?=
 =?utf-8?B?ZkdvdmxrZzN1QWt4ZW9LYUtacnJpWWRyZmFLSWFtWUw5QjNZa3BhM0s3Rkdr?=
 =?utf-8?B?WUY1TEJHY05nU1hhekVPamF1MFZ5QzJIclhQSW5OVlZuci8wdFFIOXhnajJ6?=
 =?utf-8?B?UDhTRVN3dnlUeHdHZ1hzNjZJSVFqMVlZc282VTg4bWZUbG94eEQ5WWVzTlJo?=
 =?utf-8?B?OStDRmRFeW9iWFE0cVlUTkZScFV5UHY3NHRGaEhDLzRXMjhBeGV0Q1V1a05N?=
 =?utf-8?B?YWJ5ektIbDU3WktXRjhJK082S1M4ZHpRL1hPc09PZDl6cjVIZUZOcFg3bU45?=
 =?utf-8?B?TXloeTd3ODJJM2haYy9uSS9CZlFCdkRRenlsY0RMRE9jNTB6a0pxcXN5NHpk?=
 =?utf-8?B?UzNoNjY4RTZGTiszSnJMS2Q4blp1VTVzVGljUzR6L3lZbXN1M3VDTzVvVWZs?=
 =?utf-8?B?R05xSDk5TjQvV1FTREdQRGhnOUdNLzFhb2h6MlY5WFBWbjdKS3JhTmZ6dVdX?=
 =?utf-8?B?NUFNWUZQdzBmWDVRdmJBRlJnaXpGWFVjSTljNjlhMFRjMTJiMVNwVGVvZXFu?=
 =?utf-8?B?d0piUWY1YS9yQ1Q2SVRVVWNxN1AyVVAvNmwxTUt2cnhWT1lJMTk5Q0RwOXNM?=
 =?utf-8?B?UVJBSFZyQzlPemE3QmhBVkxIZzNENWJFT0dYS1dOZXBXdHduMnl4anQ0TDFt?=
 =?utf-8?B?WElYanpNWFBKVDdzMUxDcnVmL2VaUmdyTjBKbDdyS3J3TU9FK2RGakJQZ2lK?=
 =?utf-8?B?S1I2cnRYY2JUeml3RU5PYmwvTWxWcGdHS2ZtYVdNekRRRUpGejFobmlGUGJX?=
 =?utf-8?B?TzQ4TEdSNW54QUUvWnZWbEtTVU9GbUw4RlpzYkYrUVdOalp0S04wVXBVWGQ3?=
 =?utf-8?B?bngwQWY0RFROVTh3TmFVQWI3L2hIVmxXQldzMHdPZUk3Qm90bWdHWUkra3cv?=
 =?utf-8?B?ZUhWMHhTN0JJNTRGNzJKRFVacmN4WlhmT0RnY1Q0ZmhYendLMlJTSkdnR29k?=
 =?utf-8?B?bzJ5Yk96K21xMWl0U0k1MGFCU1g1ajBZUFhVQ3lYM1NDKzZibHpwZ01JUGNO?=
 =?utf-8?B?dmh2TlVGb2psQkxtTFVTaDVTRzFhbWhMR1lqZ2VVV00yZmxVODRaQTFjTkxB?=
 =?utf-8?B?dFE3VDFDcTRmRmlWczZhbmQ3aE9PQ2JIeGh2QTYrdDhRMS9uQ3dLblVKOUNR?=
 =?utf-8?B?MHA4ZzVjek5LQjlRLzVKdWdsanNSbzVtSmg0WXJucWFpTy9xRzN4b2h0SkJo?=
 =?utf-8?B?dkYzc2dXL2gxYSs0SXJiM3NSRCtUTzhmVmE1OFlRcUpkT3lSWitkZTY0bGhx?=
 =?utf-8?B?c2tmRVZjVXRXY3p2WlBtUU1zdVdYZ0drWkRDNVRCQlk3YzR2bFlBaHRZKzho?=
 =?utf-8?B?ZFgzcWlscHpObDJPTmIzWFZXZHJJWnY2WkFrSTd6SEtOZmNYN2IrNU1peW83?=
 =?utf-8?B?QkFJZEVQMDJPQVgyWWNYRzEvTzdrcVIxakNncEdtUnVvOFB1dTJ6NDVBMjNa?=
 =?utf-8?B?TG4ybmhWSHdEMkJsaldDUHdibUJHYitZSExPN2FmbjJPMFlkd3NBVlRsckQ0?=
 =?utf-8?B?cUxFUGZlcGl3MXpRem9Hd21ZQ1JNbWwrclNHTU83d3JjTTV5WEsyMWdqZ2Y2?=
 =?utf-8?B?NHRwdEVuNkFFbWFMeHpRVjB5QWtIRmttc1lGMEk0SW0vNFZ1Q0R0N01oSXh1?=
 =?utf-8?B?N3k3NVI4TmxWYytMUXJVMDRKY2djVGNWWVJVSUc5cGtGK0g1Y3dETTFuYWtY?=
 =?utf-8?B?MFVGWm1DL2oxWFhaMmV4M0ljK1hGMHg5cTdyWHVRZTBMWFRYaHpmZnMwUUM1?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E3FD5B6EDEB134CBAE02A2F5A0D4004@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d335db-fc1f-47e3-e2b7-08da8c08d8be
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 10:58:05.0049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j9u1W9P5kkXm8iOj6zqSxDTPpAtzkqbBD0dTIkPTUuWk/UmArF/bfD1SIuPF7EQL+CWG3w5KZ7wqAR7g9PTgBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0014
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

T24gVGh1LCAyMDIyLTA5LTAxIGF0IDE0OjE4ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IE9u
IFR1ZSwgQXVnIDMwLCAyMDIyIGF0IDA1OjAxOjIwQU0gLTA3MDAsIGlzYWt1LnlhbWFoYXRhQGlu
dGVsLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0K
PiA+IA0KPiA+IFRoZSBDUFUgU1RBUlRJTkcgc2VjdGlvbiBkb2Vzbid0IGFsbG93IGNhbGxiYWNr
cyB0byBmYWlsLiBNb3ZlIEtWTSdzDQo+ID4gaG90cGx1ZyBjYWxsYmFjayB0byBPTkxJTkUgc2Vj
dGlvbiBzbyB0aGF0IGl0IGNhbiBhYm9ydCBvbmxpbmluZyBhIENQVSBpbg0KPiA+IGNlcnRhaW4g
Y2FzZXMgdG8gYXZvaWQgcG90ZW50aWFsbHkgYnJlYWtpbmcgVk1zIHJ1bm5pbmcgb24gZXhpc3Rp
bmcgQ1BVcy4NCj4gPiBGb3IgZXhhbXBsZSwgd2hlbiBrdm0gZmFpbHMgdG8gZW5hYmxlIGhhcmR3
YXJlIHZpcnR1YWxpemF0aW9uIG9uIHRoZQ0KPiA+IGhvdHBsdWdnZWQgQ1BVLg0KPiA+IA0KPiA+
IFBsYWNlIEtWTSdzIGhvdHBsdWcgc3RhdGUgYmVmb3JlIENQVUhQX0FQX1NDSEVEX1dBSVRfRU1Q
VFkgYXMgaXQgZW5zdXJlcw0KPiA+IHdoZW4gb2ZmbGluaW5nIGEgQ1BVLCBhbGwgdXNlciB0YXNr
cyBhbmQgbm9uLXBpbm5lZCBrZXJuZWwgdGFza3MgaGF2ZSBsZWZ0DQo+ID4gdGhlIENQVSwgaS5l
LiB0aGVyZSBjYW5ub3QgYmUgYSB2Q1BVIHRhc2sgYXJvdW5kLiBTbywgaXQgaXMgc2FmZSBmb3Ig
S1ZNJ3MNCj4gPiBDUFUgb2ZmbGluZSBjYWxsYmFjayB0byBkaXNhYmxlIGhhcmR3YXJlIHZpcnR1
YWxpemF0aW9uIGF0IHRoYXQgcG9pbnQuDQo+ID4gTGlrZXdpc2UsIEtWTSdzIG9ubGluZSBjYWxs
YmFjayBjYW4gZW5hYmxlIGhhcmR3YXJlIHZpcnR1YWxpemF0aW9uIGJlZm9yZQ0KPiA+IGFueSB2
Q1BVIHRhc2sgZ2V0cyBhIGNoYW5jZSB0byBydW4gb24gaG90cGx1Z2dlZCBDUFVzLg0KPiA+IA0K
PiA+IEtWTSdzIENQVSBob3RwbHVnIGNhbGxiYWNrcyBhcmUgcmVuYW1lZCBhcyB3ZWxsLg0KPiA+
IA0KPiA+IFN1Z2dlc3RlZC1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+
DQo+ID4gU2lnbmVkLW9mZi1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gDQo+
IElzYWt1LCB5b3VyIHNpZ25lZC1vZmYtYnkgaXMgbWlzc2luZy4NCj4gDQo+ID4gTGluazogaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIyMDIxNjAzMTUyOC45MjU1OC02LWNoYW8uZ2FvQGlu
dGVsLmNvbQ0KPiA+IC0tLQ0KPiA+IGluY2x1ZGUvbGludXgvY3B1aG90cGx1Zy5oIHwgIDIgKy0N
Cj4gPiB2aXJ0L2t2bS9rdm1fbWFpbi5jICAgICAgICB8IDMwICsrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLQ0KPiA+IDIgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgOSBkZWxl
dGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jcHVob3RwbHVn
LmggYi9pbmNsdWRlL2xpbnV4L2NwdWhvdHBsdWcuaA0KPiA+IGluZGV4IGY2MTQ0NzkxM2RiOS4u
Nzk3MmJkNjNlMGNiIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvY3B1aG90cGx1Zy5o
DQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9jcHVob3RwbHVnLmgNCj4gPiBAQCAtMTg1LDcgKzE4
NSw2IEBAIGVudW0gY3B1aHBfc3RhdGUgew0KPiA+IAlDUFVIUF9BUF9DU0tZX1RJTUVSX1NUQVJU
SU5HLA0KPiA+IAlDUFVIUF9BUF9USV9HUF9USU1FUl9TVEFSVElORywNCj4gPiAJQ1BVSFBfQVBf
SFlQRVJWX1RJTUVSX1NUQVJUSU5HLA0KPiA+IC0JQ1BVSFBfQVBfS1ZNX1NUQVJUSU5HLA0KPiA+
IAlDUFVIUF9BUF9LVk1fQVJNX1ZHSUNfSU5JVF9TVEFSVElORywNCj4gPiAJQ1BVSFBfQVBfS1ZN
X0FSTV9WR0lDX1NUQVJUSU5HLA0KPiA+IAlDUFVIUF9BUF9LVk1fQVJNX1RJTUVSX1NUQVJUSU5H
LA0KPiANCj4gVGhlIG1vdmVtZW50IG9mIENQVUhQX0FQX0tWTV9TVEFSVElORyBjaGFuZ2VzIHRo
ZSBvcmRlcmluZyBiZXR3ZWVuDQo+IENQVUhQX0FQX0tWTV9TVEFSVElORyBhbmQgQ1BVSFBfQVBf
S1ZNX0FSTV8qIGFib3ZlIFsxXS4gV2UgbmVlZA0KPiB0aGUgcGF0Y2ggWzJdIGZyb20gTWFyYyB0
byBhdm9pZCBicmVha2luZyBBUk0uDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGttbC84N3Nmc3E0eHk4LndsLW1hekBrZXJuZWwub3JnLw0KPiBbMl0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGttbC8yMDIyMDIxNjAzMTUyOC45MjU1OC01LWNoYW8uZ2FvQGludGVsLmNvbS8N
Cg0KSG93IGFib3V0IElzYWt1IGp1c3QgdG8gdGFrZSB5b3VyIHNlcmllcyBkaXJlY3RseSAoK2hp
cyBTb0IpIGFuZCBhZGQgYWRkaXRpb25hbA0KcGF0Y2hlcz8NCg0KLS0gDQpUaGFua3MsDQotS2Fp
DQoNCg0K
