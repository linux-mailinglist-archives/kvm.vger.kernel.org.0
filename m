Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B299D64E4AA
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 00:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLOX2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 18:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLOX2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 18:28:03 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFD150D45;
        Thu, 15 Dec 2022 15:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671146882; x=1702682882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RhZ+Yg5YcW+KLExZbSBR+yQCliTyyfVsPdfIaAw4mE0=;
  b=MMnaSoDALgEdfLJpms8JVak43a7jIKq2IrzGWcoh9TU/TlJz6o/FMyEN
   cuoDkdUx1bnp+lag3DjXM8YiNbQQ10PGFnWwkpFi+dVmpRq3OwgqBWpzr
   Ec/0Hjvd66OHX+/xZrBsVY0F+7R7Au0z7rrsPxzwhn0XYss+YoyeyntDd
   hKUVzGaAQib6kEEGcXIClgsxYgsf4Y9LHlh4XRnPqdMFdG+FSxT3EAkfa
   iqBKiAOcanxF9wGfVay8bUwa4WmV1FHoTxrxR0scdsceMZegHw2lfTDsK
   a0TwrhADFJkEdtv4+S3KGvfVMaN9frHlPA5S1UNY4DYRDNFDJ2T0bt4w2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="320003091"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="320003091"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 15:28:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="895006201"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="895006201"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 15 Dec 2022 15:28:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 15:28:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 15:28:01 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 15:28:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLmPDi7/YIedoTUGawGKGK89/34b9giTXep/+XYJBN1OneQYyslfl3CMsAcmPOFgFvO7RQUIcd7ehk+v23vDHS+JNG6trIVDPbWZrNIjZ506dbAL7V8eeRq7x2hV8ayKNaqhb29ewm5/o6+m1xGM5lG15Fl+vtjRNSjVAQddqaUYclddBXAj2wy4mIzLDroGpnEAeQRmtLasEA+qNzmixlsighGePjbp+pHxywsEQl+L8hbjMVPAskCpv8OIYnr3M7+CR+yO24NxOA9wZebgJVYLsY+16ILUNtUz2fTcO+oQhSIW1An8YO0HDADi6rfnVPnOVcxYWwntUHazAxWUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhZ+Yg5YcW+KLExZbSBR+yQCliTyyfVsPdfIaAw4mE0=;
 b=nYHU7BhYMdxOwoHWCFlnsDZQz8ZLUv7b/yOnJMEVcO1KoPj3uN8MSZ1osqJxyjg1JZO+TI4fwh55lefMYUGXJpFUu7xVjji2QTmed1D+o/pGnbuecKx1K6fnL91xIH3ES5KEqIF9gpzy9GybAhKcuggMVLII0IAqaecBp6lpJw/SH1kdFWQ+9RfFxdT1/xFxJBiW6+SLal1AdIJBrFkrQEhg2kzWRnMuKjQKUL4z6/+6nSNBMqNieM8WqN800AV9tWGeLbEmf/IeGmPkJJYzp5rVBrc4Dp4sUMjSBWqMbopDOMYyndk9GkRW6y9hxZ0wW1r5EqsypAk2JoAwBhroDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6821.namprd11.prod.outlook.com (2603:10b6:806:29d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 23:27:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 23:27:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHY7CiGPKQ26x0OSk+nInOi8x3lUK5tgv+AgAJSvwCAAAuqgA==
Date:   Thu, 15 Dec 2022 23:27:58 +0000
Message-ID: <656755672fbbfa9c0085827a6eeeb36ab27c67a5.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <9e8346b692eb377576363a028c3688c66f3c0bfe.1667110240.git.isaku.yamahata@intel.com>
         <f3cb9b24c24122c590dd4ba27434b5c069f00372.camel@intel.com>
         <20221215224612.GI3632095@ls.amr.corp.intel.com>
In-Reply-To: <20221215224612.GI3632095@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6821:EE_
x-ms-office365-filtering-correlation-id: 28d74400-f23f-4188-22bf-08dadef4009c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p8ZzOcY3vJItqJ0jesYYcY6volPFOBey2uiPWzeFGcv7meuQ05k1baYwnzqWIwH1F7rZXHujw002otnuGguMN8LB+56ngtwzI2TSY3C1D3wsx02TDVwxTCsuKQrOUD0J5yE6N9eVcAbIZp/o5TkW0Elqoyauoc4ajWe3hwPhJAvI6bY9ElDPpmraamwlP5pOV+vlythR9ucCdBD04FhCl1khow3u7EXOyUFwc+4vFfdIP4y6ZMSeKc35ljQRxRqJfnaWp8+AvO1quYT7jg/EjE7EcBhWsgoiLkRega4ymrmiBE+qEqIzR7Ar2oMmy9Msmq5EeoADhnq3lombhA2y+fJm+FLL80gK3M/W1lE/uabMbFCfdJS966VSLoqz3yifUcWadPPvK2Kj9TudgIprtZxENsYMopz97KMjppjkNi+sxowZ7ODD0mo1HXGHs4wOoFgwuaKutM66f95u6Ch0LhvylpOdw+xkC9zU/nQXcglhuNzLtej0j2pV55MznLo7i20AZQ9COI+HYnmPstOAb/1JYUtG2msCYNeu8gbI4mTDpvglXnVYanMiPOTs7LYy2khQDBJi+JEsoQVO91A3YkItrPkm0hvI/9pTom7EqlXzK6vkmR7xzhEF11BiSvMZ82psmveOZrcQEvYLhkDSbakC3NbT13hsUV4khV24MHeABbnnaLWLyf9bxOc1EWuo2KlnVH/anv8puh2nkeYzlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(82960400001)(54906003)(86362001)(122000001)(76116006)(38070700005)(91956017)(316002)(66556008)(8676002)(38100700002)(4326008)(66946007)(6916009)(71200400001)(4001150100001)(478600001)(8936002)(2906002)(41300700001)(66446008)(64756008)(66476007)(2616005)(5660300002)(6506007)(6486002)(26005)(6512007)(186003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnUwWTMxZUNrTTV5Zk8vTmt2N0t1bC9BYll1Q2lwKytjekM4WndVb2sva3Bn?=
 =?utf-8?B?b3pEdHVwcERkM21Gbm4xL3VVQzROemNNeDBLWHZzdUZHRHZibjJRTlZ3L2E0?=
 =?utf-8?B?b1BSVzVBRWJ6bGtMbXd0eTZXUjFvUGRXVGtYQ2ZKdUxGcktXc1gzTXg1TFY5?=
 =?utf-8?B?eGlZeHZybHRMeGlqc093WFJGWTlIcktUcHFZR2JXTmdQTXhMbkV1SzRwU2ZI?=
 =?utf-8?B?U1piMk1ZR1g5RWlPVmZPUjV2ZHBnQm9CenFkUXZLdWlCWnVUbStDRDdIL08r?=
 =?utf-8?B?aDRBM3U5bmd5dUxzTDFYT2paS0lJOTZVeEs5Z1dhanBtbjdURXZsaGNaYXNj?=
 =?utf-8?B?M2NoRVRzbitRZVpzUmVHcnR2ajhicEl5RkdWMnBOUm8zODh5VE5WYkdMQnlU?=
 =?utf-8?B?YWs4cGZueXNYQVlXKzVMNm5nbjRiTzJWRXpCMUFhZnlqZ1JuUkVlNG9WRUEr?=
 =?utf-8?B?R2pER1k3VGdUNS9sUFovVTdjL2lwbDFZbDRqYml1OHNOWG82Ky81eGI3dXRP?=
 =?utf-8?B?cll0c1o2Qk1Xem5vVWZGbFcwRENZalhPc3ZFRnp3WjNDRVhOUHJkcFNqZGpN?=
 =?utf-8?B?bUZVODl3Wmkvb1hTcERDZks2ZGF6aDM3MTA2UFhLODZRVkxuaXJPNzBrd1kz?=
 =?utf-8?B?RVR5WkUyQ2h4U3hoTStheHJManhmVGNkQ2lueGhSbVpqY1J2OEN0Q3c2RFZn?=
 =?utf-8?B?RXNVRUxkclkyOTlMTEJuSDZUQjg4djhqT0I2d3R1YlV4ZnFjMmJjL1V4WGRY?=
 =?utf-8?B?WE5FZXc4b1NxWFN3ekp1NDB6OTErMkVZN3VnaVJ1SWhtZnhqUVlYNWd3Smtt?=
 =?utf-8?B?OG5LWVJXR0k3TTMrRHZqZVc4Nlh6c3JZMGhpWGpPekhjdzJ3akVERkc2d1cx?=
 =?utf-8?B?UHdWU1Fqei9CL0l1M0xOR3JKQlBRYjRtQmhreWN4RUhQYmR4KzVWZHV0Wm5m?=
 =?utf-8?B?TXcxUWFqY3d3RnZnRlBDeUtUaWM4ZXNuc2NkSzRueUtFWlVtckJpV3VPS0dk?=
 =?utf-8?B?SnF1VUxTbG12Snk2MllnNkRjRFZLcXZQRFlqdzdmSEMzVXE5ZHVzSkxEUnZ2?=
 =?utf-8?B?d0NNMDMxVjRLemptamVVM0xNKzZUMEl0UjdtL3hBTVNYaHo2TkI1a2N3azFW?=
 =?utf-8?B?L1hEQWdHWmVGMGVsZTErWDVSYXNJNzZ3dWMyNHdWOE5weFhjekV5S1c0THEr?=
 =?utf-8?B?a2V0UDVVT05Qc1JBQndCdmIwZXlTMXRRZzFRUjBRdWdJUGpROXJNc0RsL0J6?=
 =?utf-8?B?cTUwZUh0eFhRcjUwaCtId0hyU2dFYlhhbG5mZlovSFRtUTN1eFBWbURwSWNi?=
 =?utf-8?B?QzlQRGVaL1RJZFBTR3ZpQnBmS3M4UXh2V3VYUjljQldKU3NvbW5wekwwU0R0?=
 =?utf-8?B?ZjRIVzBiekcveG1CSi82bTZHT0VXQ05TbWRtWERhT3diS2drZ0pBamFQZnZ4?=
 =?utf-8?B?K2grS1Y4TFN0MEdncWdMbHlGUUhTUWltd1g0VkMyOGVNendnMTRibDZaajJm?=
 =?utf-8?B?a0Z2bVFWR3BkTnd2NGpseE41TlhXNlpvVy81dC9FUXR5ZjlZdnhHTUxBSWxO?=
 =?utf-8?B?OGxDeHJnZFAvcFlmdFNKdzBWbzdhdnMyNzNPdWFxMVBNTDFnMzRvM21FblRp?=
 =?utf-8?B?K3VyU1JLcWh3ditlL3B4VC82V01qaEQxaG1KZ0tUa1hFb0cyV29YdkNkdHQx?=
 =?utf-8?B?c3ZWRzI4WFRtcmdRRHZVenNGS1NiOWY4TFdiVlJ3YmdHTVNqcGE3VlhXMG8v?=
 =?utf-8?B?RitnNVp2SXdRWmtaa2ZRRzRJYjNkcWUwU2pkbFM2eEZnYnVmekNHbWxkbGJQ?=
 =?utf-8?B?YWEvY1BvZ0VSdGR1SzVvVjZZT2RFNkllNVNGV0QzVWhZdnZ5cFQ3OG5EVkZO?=
 =?utf-8?B?SlZ3dEs4UFlsR2FCMXdmNHQ0UlpqMEY4RkY5c0JuSXc2czE0TStIOGFBRTJo?=
 =?utf-8?B?aDdCazFZb0R4VVhWbHI4OWx3S09OUm1KWUJoZkZDMmNpTnRPS2dsWHhJVzFi?=
 =?utf-8?B?Tm8zQWkzY3hpUE43OXFhN2tUWEd1a0FmTFE3eHFDL0hTVnBINEg3ZzBVMDRa?=
 =?utf-8?B?UHMxN29vcUw3b0ZqdlBFK3U1MERQU29zTWp5a00ydHBXb2FKUjJnaFBKeWZ3?=
 =?utf-8?B?K1o3Q2lBdVJkZ01wK1VDUEJtYVNRc1dLcXZwREx5Q2xTNG1Jemx1SGVZeDNn?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BF45BBAE2957B4685F6DCAD5F1BD5CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d74400-f23f-4188-22bf-08dadef4009c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 23:27:58.9719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZpeKfCPgpRx855+u7W18jT1qpDZX95G+ibfqrpy2FRDPPplN4KkmqCvpYv2OSN/x176MOjitfWMgyh+h8SMkpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6821
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

T24gVGh1LCAyMDIyLTEyLTE1IGF0IDE0OjQ2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBTb3JyeSB3aHkgInByaXZhdGUtc2hhcmVkIGNvbnZlcnNpb24gaXMgZG9uZSB2aWEgS1ZN
X01FTU9SWV9FTkNSWVBUX1JFRyINCj4gPiByZXN1bHRzDQo+ID4gaW4gIndlIGNhbiBpZ25vcmUg
dGhlIHJlcXVyZXMgZnJvbSByZXN0cmljdGVkbWVtIj8NCj4gPiANCj4gPiBJZiB3ZSBwdW5jaCBh
IGhvbGUsIHRoZSBwYWdlcyBhcmUgZGUtYWxsb2NhdGVkLCBjb3JyZWN0Pw0KPiANCj4gV2l0aCB2
MTAgVVBNLCB3ZSBjYW4gaGF2ZSB6YXBfcHJpdmF0ZSA9IHRydWUgYWx3YXlzLg0KPiANCj4gV2l0
aCB2OSBVUE0sIHRoZSBjYWxsYmFjayBpcyB0cmlnZ2VyZWQgYm90aCBmb3IgYWxsb2NhdGlvbiBh
bmQgcHVuY2gtaG9sZQ0KPiB3aXRob3V0DQo+IGFueSBmdXJ0aGVyIGFyZ3VtZW50LsKgIFdpdGgg
djEwIFVQTSwgdGhlIGNhbGxiYWNrIGlzIHRyaWdnZXJlZCBvbmx5IGZvcg0KPiBwdW5jaGluZw0K
PiBob2xlLsKgIA0KDQpJIGhvbmVzdGx5IGRvbid0IHF1aXRlIHVuZGVyc3RhbmQgIndoeSB2OSBV
UE0gdGhlIGNhbGxiYWNrIGlzIHRyaWdnZXJlZCBmb3INCmFsbG9jYXRpb24iIChhc3N1bWluZyB0
aGUgImNhbGxiYWNrIiBoZXJlIHlvdSBtZWFuIHRoZSBpbnZhaWRhdGUgbm90aWZpZXIpLiANClJl
bW92aW5nIGl0IHNlZW1zIHRvIGJlIHJpZ2h0Lg0KDQpCdXQsIHRoaXMgaXMgbm90IHRoZSBwb2lu
dC4gIFRoZSBwb2ludCBpcyB5b3UgbmVlZCB0byBiZSBjbGVhciBhYm91dCBob3cgdG8gdXNlDQoi
cHVuY2ggaG9sZSIgYW5kL29yIHNldF9tZW1vcnlfYXR0cmlidXRlcygpLg0KDQpOb3cgbXkgYXNz
dW1wdGlvbiBpcyAicHVuY2ggaG9sZSIgY2FuIGJlIGRvbmUgYWxvbmUgdy9vIHNldF9tZW1vcnlf
YXR0cmlidXRlcygpLg0KRm9yIGluc3RhbmNlLCBwZXJoYXBzIGEgKEkgZ3Vlc3MgdmFsaWQpIGNh
c2UgaXMgaG90LXJlbW92YWwgb2YgbWVtb3J5IGZyb20gVERYDQpndWVzdCwgd2hlcmUgeW91IGRv
bid0IG5lZWQgdG8gc2V0X21lbW9yeV9hdHRyaWJ1dGVzKCkuDQoNCkhvd2V2ZXIgaXQgZG9lcyBz
ZWVtIHRoYXQgc2V0X21lbW9yeV9hdHRyaWJ1dGVzKHNoYXJlZCkgc2hvdWxkIChvciBtdXN0KSBi
ZSBkb25lDQphZnRlciAicHVuY2ggaG9sZSIuICBBbmQgd2UgbmVlZCB0byBkb2N1bWVudCB0aGF0
IGNsZWFybHkuDQoNClNvIGl0IHNlZW1zIGEgbW9yZSByZWFzb25hYmxlIHdheSBpczoNCg0KMSkg
aW4gInB1bmNoIGhvbGUiLCB5b3UgemFwIGV2ZXJ5dGhpbmcuDQoyKSBpbiBzZXRfbWVtb3J5X2F0
dHJpYnV0ZSgpIGZyb20gcHJpdmF0ZSAtPiBzaGFyZWQsIHlvdSB0cnkgdG8gemFwIGFsbCBwcml2
YXRlDQpwYWdlcyBhbnl3YXkgKGl0IHNob3VsZCBiZSB2ZXJ5IHF1aWNrIGlmICJwdW5jaCBob2xl
IiBoYXMgYmVlbiBkb25lKSwgYW5kIHlvdQ0KY2FuIHByX3dhcm5fb25jZSgpIChvciBXQVJOKCkp
IGlmIHlvdSBmb3VuZCBhbnkgcHJpdmF0ZSBwYWdlIHN0aWxsIGV4aXN0cy4NCg0KRGlkIEkgbWlz
cyBhbnl0aGluZz8NCg0KQnV0IEkgYW0gbm90IHN1cmUgYWJvdXQgc2V0X21lbW9yeV9hdHRyaWJ1
dGUoKSBmcm9tIHNoYXJlZCAtPiBwcml2YXRlLiAgU2hvdWxkDQp3ZSBkbyBmYWxsb2NhdGUoKSBi
ZWZvcmUgdGhhdD8NCg0KDQo=
