Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C8A72F997
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 11:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244057AbjFNJp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 05:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244189AbjFNJo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 05:44:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F22B294E;
        Wed, 14 Jun 2023 02:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686735762; x=1718271762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LrpR0wHIYg+Mgp0+3lxecZpXSzKUrTYU6tO7qPC1d4Y=;
  b=kYN6a0KFCcsXro/BrjB/WitL2GWa5BHLE78O40BdY55mFOOpCQna2g7O
   KXeISKa0D4lbmJvg1kCasjRgQpSdtgKXgiD4bABK4KSkTERXg1FNLQ+ku
   Cp3ae5/NvvUM8IvfLFDBYLjsi3Wjl2IK8RQSHpRvVcciwshAEZe2azYKa
   0xkRLe4NQ/lfPk/HZKnobjB4qwvcOTGi9IS/3idzvU1illXMacx6K5ytt
   Y4pq+fNjJkK14UkKEEMHaSPWH4meuvgupRyg0x9OSZBUAw0i4APrKxLDY
   78NaB02yctMNfyORwKBaEMrK52F09FdaBHtp2ezHlJlKwe7IagzXnOqNx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="444939817"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="444939817"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:42:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="745016283"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="745016283"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 14 Jun 2023 02:42:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 02:42:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 02:42:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 02:42:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENJfM5q4tEp2JAckWpn36mSFjET3Oym35zx6jaTaYHPIlMX2HGicKDvB0hSp/S/116iwNrCu3mmonJCkll304xoAjFY7l198CMElXTAiaLTbkx2FPgq5g1xx0oaN9I92v1JEbX+jGMns6aklFtexLS4u1L1rEBXMaiW9dZoG1Rbm1X/pYgpXqR34cDLwboh5qKaSwtvt5NyzMPyXoDhkPRUwVOzrZmPdp4SciIAtq3R96kZr8DQJSY2xzZQdNQIzd5eyBdwp3pTj+y6sCWyAphT1AWxEgMcrtQFJV+CQg3GSiJpsrHp9tld2Fb0C+vF+F77xCw5pGrX6LT3n6/gRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrpR0wHIYg+Mgp0+3lxecZpXSzKUrTYU6tO7qPC1d4Y=;
 b=ZOp0F0yYVomuZ5Gut/utQ1eAtuZNgzPPrpec5fDgUrlbQLeOkhvBQAIdBJkjH6jrZh4pWu4YoXHitftZyZaCVUrAf2Ng6aA9JmY44YCtVch/6n9KbxXSeO4RCNsZmAKo7fkt/AlwE9K4a6c7zXtriI+YfgMSOw9WMM3FSJDETU6VjbtLC6bKHuqZhcVlwdOBfwgQ5FMoiOTxPKVIjvBACZB6xFRiyWrKjfEp4cjzwIub9+NRRLPdoYoSGi25ouf2uLfNCqmoOBdm5Pie5aSUfIjGhJeFhlGyyfdpjq9UItW+0hpTv9VcCdK9rxqeS3/XW8YWmML/qbgvOi6tQoqHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7216.namprd11.prod.outlook.com (2603:10b6:8:11c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 09:41:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Wed, 14 Jun 2023
 09:41:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZkeT0wH2MEOTseU2fipMRPmQQrK99OF2AgAJ5WgCACD0lAIABKTIAgAENEYA=
Date:   Wed, 14 Jun 2023 09:41:58 +0000
Message-ID: <831f6e968e4794775c3e2adba1d550be70b01c33.camel@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
         <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
         <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
         <20230607180616.GF2244082@ls.amr.corp.intel.com>
         <6b60200b23fa3eac689a140abb92506410b14531.camel@intel.com>
         <20230613173854.GP2244082@ls.amr.corp.intel.com>
In-Reply-To: <20230613173854.GP2244082@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7216:EE_
x-ms-office365-filtering-correlation-id: b7fd4173-e574-4f47-1ba6-08db6cbb98d8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H3E5Oi1/QGuiHGvHGP0k7ylNdkDFowEx/N0WJ2a1n9BZnRdhQhkOlvkeOuU70anagt/R/E571gaXeK8EfdBh30WScchRC0WDwxNsHurUPxsMg9T1bI1hIstmRdfDsNDkwbFviFj6ZTDIap5LBTNfMKy3Hz5WfSpcJtnV6rlzzU18anvTY4n41Yfv+3zunfojJZXtBXbc3SBBMdQKSq/sRYQeLMPUZfYr/WxNeZajMMdcb8eM3eDQMknbdYQbishmRIS4oWAL2yKeABBJDtdAAyqNt0XRGhHgNDvCQga9XT2Od/HXYUDYvb+U5ACZAmZsL8o2eNgHBKw7OGEpMheESZ2iIAjOEXDX+cVuG9YfxuJHCO3JsGc0p+nVk8l4gNZpE+/bCWFK7DtpD4cD6r2Xen0QSd1AoOVIsrr9QaTgxy++FEARfYWcKEzKacMNIEr8TeJbgTJDAW2Xze2nHTTrwmlPu9ad1VKYeukhmzva6A6TQx4gwq17ezTOTbOqbB+zeGL2uYU8J7zpyBfQkVdxwZ4TgLh9nrTmtKMGq+Cb8Xkpzvw0iXNkqMdouH8Vl7SwyteTzf5dLuw8kFnWBUBz9rj+GEQjUTXTMcd8pcVqMHY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(346002)(366004)(136003)(451199021)(41300700001)(8936002)(8676002)(122000001)(478600001)(38100700002)(71200400001)(82960400001)(2616005)(83380400001)(6512007)(26005)(186003)(6506007)(966005)(6486002)(54906003)(38070700005)(86362001)(36756003)(316002)(4326008)(91956017)(64756008)(66446008)(66556008)(6916009)(76116006)(66946007)(66476007)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWs5SmZOdHpQaEZSbHVXbWNkekg5UTc0UlFCVHEwWEpMSHp0QW5SNzZyUUJ3?=
 =?utf-8?B?bnZsS0NGdEhhaGx0UEEvVEZ3K09Fb0t2QmMrZnFudlhDYkRJTjhNT0FNTTdK?=
 =?utf-8?B?SFo1b0JWamhKOW5zMGgxaFdadGJzTk1XelVXRnV4T2F3Vy9FWFFBSklyMjV3?=
 =?utf-8?B?TlJFeGpMT3dTU0UyOTVQcllLWTJQWG9hL0ZtbHpnNTc1dVpoMkMrRWY0R0Vm?=
 =?utf-8?B?RWJGcys0R0JLUThjNmZkODdyOTVsa0VYZG1BUlBadWh3SnpTdmQzVDhUMjhw?=
 =?utf-8?B?WVFwdUtUV2RueVNDM1ZoSjB2S0twT29IYlBBT1k0dlVnVENNbkFHTzlmVVBT?=
 =?utf-8?B?V1NITVhBd2RET2lrVHNkOWlDWS84a0pBbWo4QmVoRmNkVjJLNU05UHliNEo2?=
 =?utf-8?B?K05TQ2RVTXE0QnY5UGNKOGF2bDA3OXp3OG93RnlPd08rNHVPaXVVL3BsbWE0?=
 =?utf-8?B?Vnp0NTNldElnSzBQK0FnM0lNNEZqYWROM2xIeUNKTDEvSUxxVDZOdmpTYXpi?=
 =?utf-8?B?TFZiMUIyNGJqTWtna3lJSEJCVytqUjc3OTlEbGJkdkRWays4UDVFSzh2ZExT?=
 =?utf-8?B?aUkzOUdpMTdtcGRSYWoxVUdXaU0vMTNyWFBjZWJrZ0lnQTJPdjBpRm43NmNM?=
 =?utf-8?B?YXdrZ09ZTjNCYmNSWkV6WjlKYUhFNG0yOEF1VU9SVDJxQkk1dURXaElUNFlv?=
 =?utf-8?B?TFBlcG0vN1owclJJVVVMN2lYQ01PS0dMbkVwL1J5TFBJMDQxcEpsS0NQMXFi?=
 =?utf-8?B?OTNNQ0EwY1hFMGRIdEhsaGIxWjFEZ0xqQkZtS3Y5amZ1cytod2YvQ1grd3FB?=
 =?utf-8?B?MHgrSzV2ZE54dkVZeGZoTUZCTm82aXRQRXdFVUdhTHdaYWlvZFBOVDhKSk83?=
 =?utf-8?B?c3hwTUhvSklqdWlYZ0Nia1pITnEzNXhYVE5wV3VtR1NuUExGOCtUb3VwTVBj?=
 =?utf-8?B?SHhodE5tTS9CR2ttaUlEcXRZQ2E4c2xkT05BY0NNYTNUbE9LbDNGQXNPbStC?=
 =?utf-8?B?WE55R3haenZFQ0VrN2pnSXU0a1kwdEFZVldmMmJSbFZzczRlWHBOVEZJaXNo?=
 =?utf-8?B?b09hOGQ3VTJWTFh6bERlZUpodnd0K2F6SVJpQ1ZwUDl2L3JWMlg3bmg5eXU1?=
 =?utf-8?B?SjF1ZFdRQXMxV2lMYWZSdG4yMkJOeDcyR2c0OE4wMmQwNHdvNStqN0wzejUv?=
 =?utf-8?B?WU9WQmdEaklIS2FHNkUwZmRicmYyK2xpWDkxK1pjOXdGZ21iT1o5MkJWekRO?=
 =?utf-8?B?aVpIVnZQYWorZ3o2MTc4SG5mdVNJTk14VGlyc2t5Znk1V3A1eXVjRS82cEpC?=
 =?utf-8?B?UlBnVnZQcmMwYzZ2L3JiMEx5UWtoY0N2Yk9tcklPQlhaMVJRZVpjNGtUaER4?=
 =?utf-8?B?MGhUbGNNazV6eEVsV3Q4T2xYR3NXTXIvd1N4V2oyN1l6V2NoY21vNWwxc3ZF?=
 =?utf-8?B?cU5FRE44NWY3cEtJcTUzRVhnQmdneDFNWTgyUmxpWVh0bllYOFI5Q0lONXY5?=
 =?utf-8?B?SzBQNVFhaFJwWFdSdUltV1UrZFc1UENpUWNISWhpZ1ZJdGMra252Y0xSZVhW?=
 =?utf-8?B?S2xRL2owMnd2cXJmRFhZdU93clZDejRjYXVxbHVzSUlsZGdMTjRtNk5jVGZM?=
 =?utf-8?B?Z3FxZ3RJbW9DelFJTllIMmFBaG5nMGsvRmp2T0E2c2xwWWs0K0JoQTlPaEtS?=
 =?utf-8?B?aFUxS1pwTU0wSmJ1NTd6aWxKY0h0YkVXZWJzbzVxWmhHcDZ3VlU4bDRWdURC?=
 =?utf-8?B?VlpnUXVMeTZLT0tOeE5XdGpnRlpFNUhJY0tGL2tOM3daVWZqUjF5R1lmOWZs?=
 =?utf-8?B?c0RUTzN0V2hkVHVlSmMxZ1NkM3cxdmtaOHVIRDladHFSeFU1ZDY0MnNaWXNt?=
 =?utf-8?B?ajNwK1BENTZIWWwwTitWRDJkb2g0YjlDWXY3MzFMRXhNU2U4emVta2hwK2dj?=
 =?utf-8?B?MTcyYVc2Z2J3bmF3SXBITlVvaGRtSWVuRXVNMnRUZ3dReUROSmM1NXNWc3dp?=
 =?utf-8?B?Q0o4d3hYL0VPS3NsM05EajhkbzdaYkdKTFgzQlIwSllGcmdsTGg1UXExcVNr?=
 =?utf-8?B?VURiU2pFTnhFc3NhWGxqajV0ay81SzhMQzNEaWhxZVlQRGgyWWFBbExDZDZs?=
 =?utf-8?Q?vDxKkXowBLXQ3c6SKH+d2mzn1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CD27D1C8FCC4543A7B62F1F2B74A6A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7fd4173-e574-4f47-1ba6-08db6cbb98d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 09:41:58.1847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 00x8WFfqYCb/8QstKtSRko0OqkMemShTH1LiQmsJVvVkCHTC+Xb8v6wVh2hfFXLJDRcEVw5sgjCFvRsH/VaAIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTEzIGF0IDEwOjM4IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBKdW4gMTIsIDIwMjMgYXQgMTE6NTU6MTRQTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gV2VkLCAyMDIzLTA2
LTA3IGF0IDExOjA2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+IFRoYW5rcyBm
b3IgcG9pbnRpbmcgaXQgb3V0LiBUaGUgZm9sbG93aW5nIGlzIHRoZSBmaXguDQo+ID4gPiANCj4g
PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3Zt
eC90ZHguYw0KPiA+ID4gaW5kZXggOGExZDA3NTVkMjc1Li5iMGQzZjY0NmFmYjEgMTAwNjQ0DQo+
ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9r
dm0vdm14L3RkeC5jDQo+ID4gPiBAQCAtNDQ5OSwyNiArNDQ5OSwzOSBAQCB1NjQgdGR4X25vbl9h
cmNoX2ZpZWxkX3N3aXRjaCh1NjQgZmllbGQpDQo+ID4gPiDCoAl9DQo+ID4gPiDCoH0NCj4gPiA+
IMKgDQo+ID4gPiAtc3RhdGljIHZvaWQgX19pbml0IHZteF90ZHhfb24odm9pZCAqaW5mbykNCj4g
PiA+ICtzdHJ1Y3Qgdm14X3RkeF9lbmFibGVkIHsNCj4gPiA+ICsJY3B1bWFza192YXJfdCB2bXhf
ZW5hYmxlZDsNCj4gPiA+ICsJYXRvbWljX3QgKmVycjsNCj4gPiA+ICt9Ow0KPiA+ID4gKw0KPiA+
IA0KPiA+IFNvcnJ5IGZvciBsYXRlIHJlcGx5Lg0KPiA+IA0KPiA+IEkgdGhpbmsgeW91IGp1c3Qg
bmVlZCB0byBtaW1pYyBoYXJkd2FyZV9lbmFibGVfYWxsKCkgLS0gdXNpbmcgYSBwZXItY3B1DQo+
ID4gdmFyaWFibGUuICBJbiB0aGlzIHdheSB5b3UgY2FuIGdldCByaWQgb2YgdGhpcyBzdHJ1Y3R1
cmUuDQo+ID4gDQo+ID4gQnV0IGFnYWluLCB3ZSBoYXZlIGxpc3RlZCBhIGNvdXBsZSBvZiBvcHRp
b25zIGluIHRoZSB2MTMgZGlzY3Vzc2lvbiBbMV06DQo+ID4gDQo+ID4gMSkgQ2FsbCBrdm1fb3Bz
X3VwZGF0ZSgpIHR3aWNlIGJlZm9yZSBhbmQgYWZ0ZXIgaGFyZHdhcmVfc2V0dXAoKSBpbiBvcmRl
ciB0byB1c2UNCj4gPiBoYXJkd2FyZV9lbmFibGVfYWxsKCkgZGlyZWN0bHkuDQo+ID4gDQo+ID4g
MikgRXhwb3NlIGt2bV94ODZfb3BzIGFzIHN5bWJvbCBzbyBWTVggY2FuIHNldCBoYXJkd2FyZV97
ZW5hYmxlfGRpc2FibGV9KCkNCj4gPiBjYWxsYmFjayBiZWZvcmUgaGFyZHdhcmVfc2V0dXAoKSBp
biBvcmRlciB0byB1c2UgaGFyZHdhcmVfZW5hYmxlX2FsbCgpLg0KPiA+IA0KPiA+IDMpIEltcGxl
bWVudCBWTVgncyBvd24gaGFyZHdhcmVfZW5hYmxlX2FsbCgpIGxvZ2ljIGFzIHNob3duIGluIHRo
aXMgcGF0Y2guDQo+ID4gDQo+ID4gNCkgPz8/DQo+ID4gDQo+ID4gSSB0aGluayBpdCB3b3VsZCBi
ZSBiZXR0ZXIgaWYgU2VhbiBjYW4gcHJvdmlkZSBzb21lIGNvbW1lbnRzIGhlcmUsIGJ1dCB1bnRp
bCBoZQ0KPiA+IGRvZXMsIHdlIGNhbiBrZWVwIHVzaW5nIG9wdGlvbiAzKSAodGhpcyBwYXRjaCku
DQo+ID4gDQo+ID4gWzFdDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC81ZGM4NGEy
NjAxYTQ3Y2NjMjllZjQzMjAwY2YzZWMwZDFiNDg1ZDIzLmNhbWVsQGludGVsLmNvbS8NCj4gDQo+
IE9rLCBtYWtlcyBzZW5zZS4gSGVyZSBpcyB0aGUgdXBkYXRlZCB2ZXJzaW9uIHdpdGggdGhlIGZp
eCBmb3IgdGhlIGVycm9yIHlvdQ0KPiBwb2ludGVkIG91dC4gIEludHJvZHVjZSBjcHUgYml0bWFw
IHRvIHRyYWNrIHdoaWNoIGNwdSBlbmFibGUgVk1YKFZNWE9OKQ0KPiBzdWNjZXNzZnVsbHkuICBE
aXNhYmxlIFZNWCBvZmYgb25seSBmb3IgY3B1IHdpdGggYml0IHNldC4NCj4gDQo+IA0KWy4uLl0N
Cg0KPiArc3RydWN0IHZteF90ZHhfZW5hYmxlZCB7DQo+ICsJY3B1bWFza192YXJfdCB2bXhfZW5h
YmxlZDsNCj4gKwlhdG9taWNfdCBlcnI7DQo+ICt9Ow0KPiArDQoNCkFnYWluIChhbmQgYWdhaW4p
LCB3aHkgbm90IGp1c3QgbWltaWMgaGFyZHdhcmVfZW5hYmxlX2FsbCgpIHRvIHVzZSBhIHBlci1j
cHUNCnZhcmlhYmxlIGluc3RlYWQgb2YgYSBjcHVtYXNrLCBzbyB0aGF0IHlvdSBjYW4gZ2V0IHJp
ZCBvZiB0aGlzIHN0cnVjdHVyZT8NCg==
