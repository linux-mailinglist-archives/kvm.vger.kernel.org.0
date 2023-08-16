Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D5D77ED5B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 00:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347006AbjHPWqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 18:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347046AbjHPWqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 18:46:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FDA2136;
        Wed, 16 Aug 2023 15:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692225973; x=1723761973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IaF3mJEUsXYIGO9bC9IH5fukN7Gl/nR8bjbtwLYoEI4=;
  b=WIeCp5lhzJ805schxjY2t5BpFIB6fW9ytoARqRbG3ZrxYrnmXCeUwhCJ
   0z9dhuIVXexBmdAAKb+YTSO4KBY80CXHBYhWS0Cet4HP5qpRt/DbsHYW6
   WLt5wZu8SM6Y+uxRGexb2p8R0TOLJw3kwuuUZ7mGaqIJ3Ilv3PEadjHxw
   K02PRb4sfwjlQEUc8UE8+wNFlLBA1vmU+lySgTRdxVXl1csEF2g07NAud
   YxThfQflPXFDkk6IpYmfFtzebJRBtDa8MduG7wCXDjRHY/GHYbiR0f5bD
   c5fZXom/G8Ztrs3xmXeMKO0Kwi8uRWq3d44lighC0kRzP8d6EhiObAvy9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="436558140"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="436558140"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 15:46:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="804400447"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="804400447"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 16 Aug 2023 15:46:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 15:46:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 15:46:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 15:46:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eksih2TgT9lGkjmjSCVjP61/UD6ggIdi3vlgu9/MQKZQM5wQXkHgv1p864sidA/kguis4a/DfOSvTCsRDm4bkkxZ0Twa6HVO1T1ggGVo9Hv799wGNTq5D4hFGtba+8V1yBpVQ29KMZZdJqwiZuaS9GzzLMq4YmZpOpnTZEbgqpd7GDZQl+kD2IojlWNy7+GpAGXsUygl6REA90BBYJoHBRnRF3yc7oQ/0binslURUY4yTiwXnnBWurSAau0VNGXTl6MPjgEVjsu2UZJqZ64oCKlBgQcYHTAxOnOJmKnlmdWhHCpvlXKZpQlYDoiB3tYR/B8k/rCa8Pm9kjhVbdTkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaF3mJEUsXYIGO9bC9IH5fukN7Gl/nR8bjbtwLYoEI4=;
 b=lE/oRYjhmMXSR2yVK9z9wQq/rQV8UyxzQyHS90L1OSzaSLYkzN0WMM9O10g5mQiJwYFCGSiKUCUKvxwgzifjTftygis+L//BIh0sk5uKJQGxbaZFDxrqdAipwikfELv+8ZB49KNaPUNQ9w3HzZ6wK35AHkUwieztGZxlB5oebqjkwsqkVRo6DgIFORzUxkmuLJesbmYqmy/nQLMHyF3nTxRvPIoIazu42LJ+Ui1erszcdBtCQ9hcuCOi0u6C3Y2VMaOHqKHv0FA7Et3bZIXNl39mpMgxqBSTCF228D+Ok+2xvWYs5PdvzM2Bfeixe0+9IV+MO2rZihgXxxK6ukSY2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5255.namprd11.prod.outlook.com (2603:10b6:208:31a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Wed, 16 Aug
 2023 22:46:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 22:46:08 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Yao, Yuan" <yuan.yao@intel.com>
Subject: Re: [PATCH v3 01/15] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
Thread-Topic: [PATCH v3 01/15] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
Thread-Index: AQHZz7iCXeBxUR9Es0ebrzzHuGyWkq/sJJYAgADVj4CAAI1KgA==
Date:   Wed, 16 Aug 2023 22:46:08 +0000
Message-ID: <2a49926ccd07b14251e8f004089e3185eb6b4de6.camel@intel.com>
References: <20230815203653.519297-1-seanjc@google.com>
         <20230815203653.519297-2-seanjc@google.com>
         <6370c12ff6ec2c22ed5e1f1f37c1cf38a820a342.camel@intel.com>
         <ZNzbJ9Y+8Uon327c@google.com>
In-Reply-To: <ZNzbJ9Y+8Uon327c@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5255:EE_
x-ms-office365-filtering-correlation-id: ecfe6248-2192-4411-0e3f-08db9eaa94d9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9faXC++uCX7phJE6vI5n3SYZ7vrWxJHCSBTN1QPPVQHeHiEn2fveQtEb7FOKgfYCChd7alaH6xFWjjhqiDDkD5In7vMUeNJPCB3HTT/9gj8oBTpZRyQESgm22V1d7mZYmI8BAnME807k7ZOI1KoL3pK3IfpkqYlmz945USx0UNbH/JxTf2elSCq1H/tkJL9kLSbRjUUDgLg9mKtWJ4+g/u6/SVnrcI4rqSUJfjB8Rod73n9WRk5oLXs9P4b0MY+qVKiti+/mADRrJrY/adqExVZiJCqr9kHpBz+z2d7MXZo0PO5+FJTKjVfz24qdlBZau1y1xiGlQLXLm/xhEOua3e68xDuLbf1gNbkRLxAdPzUV/6pkySu1omMrIiI+9lStmV0F8z1rKWmLERx2dFiukUUhHpODLClsIcIxsDNpS+9r07aW7vtievWMVOgC9Q8JgeiVPxTIVL7mbhJG/SA5YsVmdQbY/b198f1uhK+3cQyFbHDu/+T5LzEbL/+yZuA9goKdos5GihIbP+mj9YYnv2aDMaSWTRJ594SjWTUno4NWLY3Zzyz6BYdE6Znp8VydyEzdRWVWi9Fxsh9wp1QU7Mc+ffdJ5CrxECurCve7nGa9FD2wDu3h845mfeDeLj6c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(396003)(39860400002)(1800799009)(451199024)(186009)(2906002)(26005)(86362001)(478600001)(36756003)(6506007)(107886003)(6486002)(2616005)(71200400001)(6512007)(5660300002)(41300700001)(66446008)(122000001)(54906003)(316002)(66946007)(91956017)(66556008)(66476007)(64756008)(76116006)(6916009)(8676002)(4326008)(8936002)(82960400001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZS9JcEgrQ3h4enFJZUd0bHRVcEpzNnRxUytSNUV2NXlJa2ViMDhzcGY0eUUy?=
 =?utf-8?B?ZUx6d2RobGVURjFMdWMrRHF1Wm95ckRtSW5pUGhHL2MrVyt4Mk40V2xZaDk4?=
 =?utf-8?B?dERWWDFNMTFPK3BBSHhhTForTVU2bmRwTk5pQjlBVWtGKzRwZ3BRMGdHZENG?=
 =?utf-8?B?V2NhUU1rR0lyMG9ZZTUxME5uLyt4SFdaMlY4a2Nsc2tvakxwVmp6eUJ3WHZm?=
 =?utf-8?B?RDJrcFNzMUNjQ2gvTjhBcDBDUHlhQ0phbmJiZkFEQ0hEclN0dDcvV3hpeUlR?=
 =?utf-8?B?bDJVT0ZlYjIrUFo2R2RGTzRhVHVGRGxQZGh5RzEzdzhleDFlL0EzbFMyMk1x?=
 =?utf-8?B?T2pxeDAwdzZkZ1RwTlBMMjJZVG1pQ3crd1UzZkRQWW1ud1YxUzVqMS84RWY4?=
 =?utf-8?B?dWxxMllYUWwzbmNRTVkxbXY5V0Z3d0FpUVBKek9ZVis5MCt0RXBwcGljalVr?=
 =?utf-8?B?UHRqVDdMdGJGTVNYN25nNGJGUHZBQ3dVSitsbExia3oxN0RrRXhYL0FwaFE0?=
 =?utf-8?B?U3JWK1I2VnVJVWhZOEo2cmhIQnNEbGpLQ0V5Q0IvU2JOYnhpWnpEZHc4N1VN?=
 =?utf-8?B?VWx2MUVRTGUvemtISWxpYk5TbDJobmVqZ0llaHJnU0FDeDE4cmFmdjlaNmlj?=
 =?utf-8?B?Y21SRlVXVFBjNE9lM1VEdHh2REhvNlFsUTNTd2IvUmEvQXQ2cU8rbmxQdzJ1?=
 =?utf-8?B?bXZiN3RLalVoT0cyeDlUUVo5cmJIZTFZalBsWS9UTS9zY1RNeWVzMkd0NEkv?=
 =?utf-8?B?WXo3U1VES1hKbTJ3bkVtZk1xRlA5ZS9WZkhFMUc1RllkUnBZV1pRclY5cEtu?=
 =?utf-8?B?bEdlUW1lbHZFOVRjWlA5ek5jbUNKd1RGOWdzZHMrNTNyV2t1UVY2MTc1cEti?=
 =?utf-8?B?bG1IRHpNQ240Z05wZk0yckZsZWlxZTFtZzVRUXA5c21vY0dYd3M4dXdWRUtz?=
 =?utf-8?B?a1Fmc1JQaWhSeDNTVW44dnVMaE9FaVhJUjFhVk9acjZvRmd3VlMrckw2Mktv?=
 =?utf-8?B?UUc0SEFXWHNLS0hlUFJrUEd6azB4Vzdteis1VzliRUYwS05tMXlHSEo3VDkw?=
 =?utf-8?B?dEFTZk1rdXJOZjlMTXlzOUMzRnZtd2tZM1B6bjZzaUhId1d4bUJ4emR3d0Iy?=
 =?utf-8?B?NlBiSTBWYVpDTTZQS2c4cndaQ2d2a1REdXNMcThWaWtmRlhwMCs5RUlwOVVI?=
 =?utf-8?B?dXV2TmNwSHVGVnFkQTMwN1JBZ1phRjFUSm1TcEYxdnJGcDJlU2xqZ3VSRE5Y?=
 =?utf-8?B?ZWZnUlpzeWt0VWV2MGZ5NTRtclNlMGpCWE0vcHhRbUgwb3Iydk93NXQxUTMr?=
 =?utf-8?B?eHNMekkzdU8wQ05qdXFYcktFTEJrRzdldDNSMUtMSklXdCtEdW1PTU5uaUNK?=
 =?utf-8?B?bTMzRytHYWF3NEcwNXlXYlB2K0xWL1VtU3p5STBQK3k3eGVoT3pzRUpKcC9k?=
 =?utf-8?B?SjZGaGtHeTI3ajdKSlpseWRKZldOVVhESWN3UlNGdm9MUWtzeU1ybjRXRjA1?=
 =?utf-8?B?Q2hydHpRczdVR3pQeVFmdWl1ZUlieVpSSy8zNzg4b2k4SjU0UTAva1pGNkhW?=
 =?utf-8?B?RUpyRnRWMUVDZ1hDOW1mWjc4bENHd0gvc3ZvM0JZYTJUTkZrNEhpTjhpa1Jv?=
 =?utf-8?B?a1VLOHRvQzBLYUxrMUdVMjh0V1k0M3NieEVhM2dYOEhLUlNOVHQ4OWNpamlU?=
 =?utf-8?B?bmhlTCtrK2F4REdlUjFEemNUeVFRcnZkWDR1OXdITmJvSkJFRFVhVEUwR2h0?=
 =?utf-8?B?Nyt2WUZpQzBzRVN4NGxTY1BEL1owNlk4UFQvS0NWL240Q2xuQnYvSXh0Q1pz?=
 =?utf-8?B?Z2szdVl3WDhQNHlGZkNIR1R1akxuWDdCZkdCb1JoaWZoTTMzQU1PZVBTbURv?=
 =?utf-8?B?cnl3aERqcmEwV3FScnpzRHV3YlpQY09lM0tCZjdkN1ZUSVdMMG1TQXhSa0I2?=
 =?utf-8?B?Tk0zN3drNmh2R3VRaiszMzFlOUU0WVpldFc4TjFjRTJTczM2a3AwNDVZWnBs?=
 =?utf-8?B?YmFIY2dyNUg2UWtIM1JUbGxqdE5TRjkvWkNvY2pxSjRiZml5Qy9mQU9Nb2NK?=
 =?utf-8?B?TjVrTktuQTFDdXZnYk1rWkRqTVliNGJwQVNTaVhlYW83WDhlbVc2dTRQOUNw?=
 =?utf-8?Q?pL59/32GwVx++csJWNRw7SJeF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4D3BB081C865244A2F440FA716FC449@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfe6248-2192-4411-0e3f-08db9eaa94d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 22:46:08.1545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jPfxsQ64oPKVnSXnELv4eyUlGyzabpEClWlLRRqXCcH3dr/C8EFNIpJwU3Lol2DurtNEDviH1VlCSgaWgo29pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5255
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA4LTE2IGF0IDA3OjIwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEF1ZyAxNiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9nb3Zlcm5lZF9mZWF0dXJlcy5oIGIvYXJjaC94ODYva3Zt
L2dvdmVybmVkX2ZlYXR1cmVzLmgNCj4gPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gPiBp
bmRleCAwMDAwMDAwMDAwMDAuLjQwY2U4ZTY2MDhjZA0KPiA+ID4gLS0tIC9kZXYvbnVsbA0KPiA+
ID4gKysrIGIvYXJjaC94ODYva3ZtL2dvdmVybmVkX2ZlYXR1cmVzLmgNCj4gPiA+IEBAIC0wLDAg
KzEsOSBAQA0KPiA+ID4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICovDQo+
ID4gPiArI2lmICFkZWZpbmVkKEtWTV9HT1ZFUk5FRF9GRUFUVVJFKSB8fCBkZWZpbmVkKEtWTV9H
T1ZFUk5FRF9YODZfRkVBVFVSRSkNCj4gPiA+ICtCVUlMRF9CVUcoKQ0KPiA+ID4gKyNlbmRpZg0K
PiA+ID4gKw0KPiA+ID4gKyNkZWZpbmUgS1ZNX0dPVkVSTkVEX1g4Nl9GRUFUVVJFKHgpIEtWTV9H
T1ZFUk5FRF9GRUFUVVJFKFg4Nl9GRUFUVVJFXyMjeCkNCj4gPiA+ICsNCj4gPiA+ICsjdW5kZWYg
S1ZNX0dPVkVSTkVEX1g4Nl9GRUFUVVJFDQo+ID4gPiArI3VuZGVmIEtWTV9HT1ZFUk5FRF9GRUFU
VVJFDQo+ID4gDQo+ID4gTml0Og0KPiA+IA0KPiA+IERvIHlvdSB3YW50IHRvIG1vdmUgdGhlIHZl
cnkgbGFzdA0KPiA+IA0KPiA+IAkjdW5kZWYgS1ZNX0dPVkVSTkVEX0ZFQVRVUkUNCj4gPiANCj4g
PiBvdXQgb2YgImdvdmVybmVkX2ZlYXR1cmVzLmgiLCBidXQgdG8gdGhlIHBsYWNlKHMpIHdoZXJl
IHRoZSBtYWNybyBpcyBkZWZpbmVkPw0KPiA+IA0KPiA+IFllcyB0aGVyZSB3aWxsIGJlIG11bHRp
cGxlOg0KPiA+IA0KPiA+IAkjZGVmaW5lIEtWTV9HT1ZFUk5FRF9GRUFUVVJFKHgpCS4uLg0KPiA+
IAkjaW5jbHVkZSAiZ292ZXJuZWRfZmVhdHVyZXMuaCINCj4gPiAJI3VuZGVmIEtWTV9HT1ZFUk5F
RF9GRUFUVVJFDQo+ID4gDQo+ID4gQnV0IHRoaXMgbG9va3MgY2xlYXJlciB0byBtZS4NCj4gDQo+
IEkgYWdyZWUgdGhlIHN5bW1ldHJ5IGxvb2tzIGJldHRlciwgYnV0IGRvaW5nIHRoZSAjdW5kZWYg
aW4gZ292ZXJuZWRfZmVhdHVyZXMuaA0KPiBpcyBtdWNoIG1vcmUgcm9idXN0LiAgRS5nLiBoYXZp
bmcgdGhlICN1bmRlZiBpbiB0aGUgaGVhZGVyIG1ha2VzIGl0IGFsbCBidXQgaW1wb3NzaWJsZQ0K
PiB0byBoYXZlIGEgYnVnIHdoZXJlIHdlIGZvcmdldCB0byAjdW5kZWYgS1ZNX0dPVkVSTkVEX0ZF
QVRVUkUuICBPciB3b3JzZSwgaGF2ZSB0d28NCj4gYnVncyB3aGVyZSB3ZSBmb3JnZXQgdG8gI3Vu
ZGVmIGFuZCB0aGVuIGFsc28gZm9yZ2V0IHRvICNkZWZpbmUgaW4gYSBsYXRlciBpbmNsdWRlDQo+
IGFuZCBjb25zdW1lIHRoZSBzdGFsZSAjZGVmaW5lLg0KDQpGYWlyIGVub3VnaC4NCg0KPiANCj4g
QW5kIEkgYWxzbyB3YW50IHRvIGZvbGxvdyB0aGUgcGF0dGVybiB1c2VkIGJ5IGt2bS14ODYtb3Bz
LmguDQoNClJpZ2h0LiAgSSBmb3Jnb3QgdG8gY2hlY2sgdGhpcy4NCg0KUmV2aWV3ZWQtYnk6IEth
aSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
