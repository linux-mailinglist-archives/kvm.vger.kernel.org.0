Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FD26F6228
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjECXlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjECXlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:41:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088DE9001;
        Wed,  3 May 2023 16:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683157280; x=1714693280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=datB56QWKsAFY4U/iYAZ4VsfDIFuwm/UHqXYygXl2Oo=;
  b=CeVvAXzqAAqvpUaZx1z109bgk2WyxU0P4vSOzZP5oEccHaXmDeQKVS99
   b7ARUF+6GmZq8kINgKnkzBodrjcKgGFS4gJ6UW0gmCo2jkI27fPgoQlky
   GimWvWGwxESwPX4FE69PP25nxWkqQ+do+bb3ER06yTl7jCmI0zvLrYUdu
   GzRSY4aUSooFNbJdT2/bxRuP3AD8lgWJRDc27v76c/4+ZWxB0q/sgFNGh
   nZBjqPfrHhvvBtBBY8sCxjg1yZNOGLcTVyHCKAmuLAXR1E6OCCFXhCYpb
   j7IpIS4yKBf3wHLmouct3aFksO8sH9jzbVR+NayOh17lIFHaecwNZOrhC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="346264229"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="346264229"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:41:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="674294128"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="674294128"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 03 May 2023 16:41:19 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:41:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 16:41:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 16:41:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhNikO9fOtSSH9aaNxIlawqQ0JE8n2JJhF0FUgJvWQTwnTl41kbmA9twZ/B+pE+hluIl7JKrdfEjvmEerdaaaOQbc7gNCzruL0Gczuhai6/ACxdWi/vdHKNcSKmfBrkQxvD985QuE+YZLZiSQvRob1T1ESRX+cADdf072xGkQwEXoZOtJr+CIp3MrSSASZXdhKPaD6jRPEztqbyutTyStCWvNVlRlWfCd8PfKEaVQDZxTQm0uRYK0VYmYDwMMp6bWpQA7AedIepZWUxpWAN+w8420lg5anJDwEPKv6sllLTXlCAvIOS+HbgzxerHBLwn8cWvoAqZLtIRHKChGqEyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=datB56QWKsAFY4U/iYAZ4VsfDIFuwm/UHqXYygXl2Oo=;
 b=Pwy1fOWqX0yHZ1CtaHJLX2pJ5J3KFpM4vePIWsRzFboKw7kgHmtt5+iJa9lUK0TpWvfcY5c4v+YLviM36BuoNyc65RsgvzAuP6dqFWuOO6Gs51Fws04kWTbuXHaFU9jqDvElF6onJ+Mhu+UkkgdUBinvctODYybiuSozbNg8s0yWlRxb50V8lTkSyiTmceH2JFvPWbiWMpspS47t3yofsVPSHEAu3QdMoUGuNjDH6jTGcvPemMnpqtbQWe43Awk0g6fj/sb4NQoQB67lpjTf5MNV1TUeOiwxrAEZVr91OP7IBLN+iQESZbW88ZXP1NfFV2zYtuiZqD/Pq/zdyYoOWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 23:41:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 23:41:16 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH 1/5] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR
 handler
Thread-Topic: [PATCH 1/5] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR
 handler
Thread-Index: AQHZfe1i/BSGT7aWUky/gNTnUH3uoa9JKlgAgAAG/ACAAAROgA==
Date:   Wed, 3 May 2023 23:41:15 +0000
Message-ID: <34f44b2748ad1365907c7927a3cbee794b986243.camel@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
         <20230503182852.3431281-2-seanjc@google.com>
         <56fa0da83203b20c9945e7c82a0eed11f3d31ea5.camel@intel.com>
         <ZFLtfFjAvuL0JSQj@google.com>
In-Reply-To: <ZFLtfFjAvuL0JSQj@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5580:EE_
x-ms-office365-filtering-correlation-id: 894eb388-51cd-46cb-1df3-08db4c2fe30f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dWHrlZELIGbWOb5u9ePOlS89S7N6Xvgr8+n/V+jjUG5q+NfULSHbe/e9Ke5EQjJQzV13L8MavktYtgRgDDywRbidnB3kRqq2eKUfUXGqBPpyRFBk2j3wscd4yEQMe7rfgEjDj9dK9B7YtAjWDNyKSSv5o8yFIMWApg3pAyvpGT2uXIOAziPqi3yQ0ZATOfx+5hsOsD230eDGdOje6OtO8SuEHm8dr0K0iIwwMfe2iaDD5eLcVIqbE/KSFFEy5cKram6kSuz6pYTH+dFTQT1qWcKQIpb2ekMY2LfMWohRvqlrU4uF/bHTm3q+ArOgTY9WYGt/Ovw/XJVaDXy/9iqaY5UD+VAJm9N6xapxwTzbJ0sbUaNMT2c3uip/ph7cmNdmAk/EF0InZ5RjYB9z6J6hIjg2djseqpU3H4I7YlFEzE55LzmCvhMmvwAPo5YfWAXWoX/ri2Hf4SW9vtN+ZM/vx1v5vA6Qyqgt0wtvdM9kRj9A2WLf58N5AlQYOvEKuozxdTvJEwLYMZ1UbvYX9ZAIZhg39w4L2VwsM4PxdhurGv5ylqZsZRvlSB46x5bmqbrogb2OvWISWn5whHJwhbB/J2hdIk7hXe323L5cf2ckbJMa2E//38QmDQGvPds7DiFk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199021)(83380400001)(54906003)(2616005)(6512007)(6506007)(38100700002)(2906002)(26005)(186003)(122000001)(66946007)(64756008)(66446008)(66476007)(66556008)(76116006)(82960400001)(478600001)(5660300002)(91956017)(8936002)(8676002)(6486002)(41300700001)(38070700005)(71200400001)(36756003)(86362001)(316002)(6916009)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0hTVlRWbUp4UE16MkFDUk1URUhmQi95b05iNDBWVFBlVXl0N29vK0NBN0dJ?=
 =?utf-8?B?VHRKYXF4Zjk0VHBVS2IyVFFPMTJkcWpyeVNLOWRQYXJGLytUTkEzeUU5d2pF?=
 =?utf-8?B?OFliVk9MMnRmN1RuQXJTcmxhczdKMFFYUzZqL05DRGxBcTdrUXpDMmtFcmMw?=
 =?utf-8?B?ZFdQRytyV1FoQ1MwTjg3NlU5cTB2TXd6cWs0bi9QV2h1b1NVczhNbzV4bnIw?=
 =?utf-8?B?TWw5WU5OeXNRS2JYR3ladnVIL00wNWk0QjRNLzFFNkpBQ0FqZ0VGYlcxY04v?=
 =?utf-8?B?bi9wQ3RibHJackVJL1VKNEhZS3lNSHgwYVVaTnB6ekNPN3R6NitNYWdNY2E5?=
 =?utf-8?B?bWEvdzhqd2VDYUJhS2Q1U0FmZUFOV25sMHl1bDNleWZaM2hRYUh0V2VwNi9z?=
 =?utf-8?B?NjcxQWl5WnlJVTl3UGM1VlZRK2pUM3JaMGwwK0VyT2gxdnQ0OTZsTFJiSjBt?=
 =?utf-8?B?S0NjMm9WWGVEbHdxbkhDV2wvOFJVaFQvMHQwNEppUEJEMTZPTHN5NVltZTRt?=
 =?utf-8?B?Y2JsL01MV3NlMTU2aWtBYWh3N3JYa3hHakY1NkR1WVJTOUlPWWwrZzJ4Y1RN?=
 =?utf-8?B?d1ZpU3lMQW5nbEp4UDMraXY1ZmozTjltS3RlT1ZCUzVMdS9teVMzNkt3aWNi?=
 =?utf-8?B?OHpXdmFxamJpTS9FbTdwR1dBb2hYTU54aGlXZ25XcHQyZ2RPN0FJdzdEakhS?=
 =?utf-8?B?SXB3bk5qSjdXOUU2cjZpOS9vWk4yaHdqS0UydWFwb0g1MzcwVGEvRnhFeGZl?=
 =?utf-8?B?b1lEUm1RWmcrdUhqeHJYRWZZVCtPU3VFV0h5cTB0RStBazFWQUcwcExnZ2RT?=
 =?utf-8?B?ZkhWUElRNm9CMkgxdWU0R1VmS0QrU2d3SE1iTXlhVjNTVm1sR1NaQnIvdFZx?=
 =?utf-8?B?NW5iZFdoRUhYK0JJRUxQdXJML1RUZkU0cXpSQjIrMDh0OXRLcUkvVGg4S0gw?=
 =?utf-8?B?SWxTQ2o1dGhuMUhXejNWSjlJeWE5VWtiU0xMdjRZSnpsUzByWXdOMkRVSllJ?=
 =?utf-8?B?ZWFkKzVxTzNGbjVsS1FBSGZIcURUMEJIYXdHZlhWR1lhcjQ3QzRuQ2NxNUlW?=
 =?utf-8?B?VThac3pKaDRkWW1tZHlybHdXa2FCN01ZbHh0VW16Zld1bEFhWG4yUytEQjJR?=
 =?utf-8?B?dVpxeDM3a3lEeDVBRUxldmc1RldMWXV6T3ZGenpWTWdyR3BETmwzUGgwczNN?=
 =?utf-8?B?T2dpQm5NNmpPOGxFNVhkQlFBelFHN29IcEdteEN0TnFmNzRnRXFOdnNoc2xu?=
 =?utf-8?B?TGoreW9oYWY4S1A1WTF4bGJoNm9kSjBDTGxKL092U240S0ZMdnFFeisydm1H?=
 =?utf-8?B?N3FTbEozaWtPOFJwRm5zcjluMzBmWUMxdWhBR2hWRkNvcGRMNDhNdXdyUmlw?=
 =?utf-8?B?cTc1LzdQRGt2N2FJNk92TktTSGtyait1bnhkZ051M2kwZVhZVnBlNFErY0sr?=
 =?utf-8?B?TDdINzhIOThQVTBTcVRiY2E3eWQ1bHMvZEk1MWF1L0wrZVZXUHVxT1RZZkQ5?=
 =?utf-8?B?M3BHSzNGVWFDdGtZQkpLTElHa2NNVkxGVXNtRFhnTzduMThYSGx4bHl1T1Bz?=
 =?utf-8?B?dUJ3SXdycFMzeVFtRnRvMGo0Ymx3YVhkRWRZcVZUYy92M0Z6MkJnalh3cnA2?=
 =?utf-8?B?YmdsK2FtNmF2cEduaUViV0tsOGtmRk4rZlk3TVQ0TWIvSE00OXVjdXdZVGJ5?=
 =?utf-8?B?c0tNcjNybSsybXBUdlA3T1FrRUNtQjZZRWN0bGFyeTRRcXoxeEd0NkJYQUVP?=
 =?utf-8?B?UEp6cGdZVTltTDZSOE1MN1BmQmlURjNERVNuZ05hV0dQd0svTjBaMTFXeUMv?=
 =?utf-8?B?d2NDSCtQekZ0N3dHekpLay8wWmhWOXd5Z1NQUURjZlFrWTRrcXVOSU1VS013?=
 =?utf-8?B?VElJNURENENwT09pZkVwQ3V6YU40NkdSclcxc3l0ZzBDS2VKaXo3M0tZcW0y?=
 =?utf-8?B?YngyTVpVeVNnOC9GY0MzTWtGL3NpQkF2dU9rQUthSGRiQVlpUHdQd1RYMTNa?=
 =?utf-8?B?eWxIK2VkQUdQYVBTRlY0ZG9uYitpMkoyQmRqQ2pHSEN0bG1JbEc0VHRuaVVz?=
 =?utf-8?B?OCt2cGdFYmF3WWpPTmJOV1J6N1g0dnJ4SlhBRS9QNVgwek9WSmVMNStlaWs5?=
 =?utf-8?Q?vE99XJ7DXoVj6Is4/XWuuvIJN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD7454BA5235AE4BA83D6A2CD7DC8719@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894eb388-51cd-46cb-1df3-08db4c2fe30f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 23:41:15.9203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RzIA8O0aODgYkWfX915NpgHFOF86nd4R6rgXExHfDWD3DnRJ19vBhc18hdrsBXZ/w9Ffnnmqp54ntxYBVW9CGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5580
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTAzIGF0IDE2OjI1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAwMywgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyMy0wNS0wMyBhdCAxMToyOCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEZyb206IFdlbnlhbyBIYWkgPGhhaXdlbnlhb0B1bmlvbnRlY2guY29tPg0KPiA+ID4g
DQo+ID4gPiBPcGVuIGNvZGUgc2V0dGluZyAidmNwdS0+YXJjaC5wYXQiIGluIHZteF9zZXRfbXNy
KCkgaW5zdGVhZCBvZiBib3VuY2luZw0KPiA+ID4gdGhyb3VnaCBrdm1fc2V0X21zcl9jb21tb24o
KSB0byBnZXQgdG8gdGhlIHNhbWUgY29kZSBpbiBrdm1fbXRycl9zZXRfbXNyKCkuDQo+ID4gDQo+
ID4gV2hhdCdzIHRoZSB2YWx1ZSBvZiBkb2luZyBzbywgYmVzaWRlcyBzYXZpbmcgYSBmdW5jdGlv
biBvZiBrdm1fc2V0X21zcl9jb21tb24oKT8NCj4gDQo+IFRvIGF2b2lkIGNvbXBsaWNhdGluZyBh
IHZlcnkgc2ltcGxlIG9wZXJhdGlvbiAod3JpdGluZyB2Y3B1LT5hcmNoLnBhdCksIGFuZCB0bw0K
PiBhbGlnbiB3aXRoIFNWTS4NCj4gDQo+ID4gUEFUIGNoYW5nZSBzaG91bGRuJ3QgYmUgc29tZXRo
aW5nIGZyZXF1ZW50IHNvIHNob3VsZG4ndCBpbiBhIHBlcmZvcm1hbmNlDQo+ID4gY3JpdGljYWwg
cGF0aC4gIEdpdmVuIHRoZSBQQVQgbG9naWMgb24gSW50ZWwgYW5kIEFNRCBhcmUgYmFzaWNhbGx5
IHRoZSBzYW1lICwNCj4gPiBpc24ndCBpdCBiZXR0ZXIgdG8gZG8gaW4ga3ZtX3NldF9tc3JfY29t
bW9uKCk/DQo+IA0KPiBJIGNvdWxkIGdvIGVpdGhlciB3YXkgb24gY2FsbGluZyBpbnRvIGt2bV9z
ZXRfbXNyX2NvbW1vbigpLiAgSSBhZ3JlZSB0aGF0DQo+IHBlcmZvcm1hbmNlIGlzbid0IGEgY29u
Y2Vybi4gIEhtbSwgYW5kIGt2bV9zZXRfbXNyX2NvbW1vbigpIHN0aWxsIGhhcyBhIGNhc2UNCj4g
c3RhdGVtZW50IGZvciBNU1JfSUEzMl9DUl9QQVQsIHNvIGhhbmRsaW5nIHRoZSB3cml0ZSBmdWxs
eSBpbiB2ZW5kb3IgY29kZSB3b24ndA0KPiBpbXBhY3QgdGhlIGNvZGUgZ2VuZXJhdGlvbiBmb3Ig
b3RoZXIgTVNScy4NCj4gDQo+IFRob3VnaCBJIGFtIGxlYW5pbmcgdG93YXJkcyBzYXlpbmcgd2Ug
c2hvdWxkIGVpdGhlciBoYW5kbGUgbG9hZHMgYW5kIHN0b3JlcyB0bw0KPiB2Y3B1LT5hcmNoLnBh
dCBpbiBjb21tb24gY29kZSBfb3JfIHZlbmRvciBjb2RlLCBpLmUuIGVpdGhlciB0ZWFjaCBWTVgg
YW5kIFNWTSB0bw0KPiBoYW5kbGUgcmVhZHMgb2YgUEFULCBvciBoYXZlIHRoZWlyIHdyaXRlIHBh
dGhzIGNhbGwga3ZtX3NldF9tc3JfY29tbW9uKCkuICBBIG1peA0KPiBvZiBib3RoIGlzIGRlZmlu
aXRlbHkgb2RkLg0KDQpBZ3JlZWQuICBBbHRlcm5hdGl2ZWx5IHdlIGNhbiBtb3ZlIFNWTSdzIHNl
dHRpbmcgdmNwdS0+YXJjaC5wYXQgdG8gY29tbW9uIGNvZGUuDQoNCj4gDQo+IEkgZG9uJ3QgaGF2
ZSBzdHJvbmcgcHJlZmVyZW5jZSBvbiB3aGljaCBvZiB0aG9zZSB0d28gd2UgY2hvb3NlLiAgSSBk
aXNsaWtlIGR1cGxpY2F0aW5nDQo+IGxvZ2ljIGFjcm9zcyBWTVggYW5kIFNWTSwgYnV0IG9uIHRo
ZSBvdGhlciBoYW5kcyBpdCdzIHNvIGxpdHRsZSBjb2RlLiAgSSB0aGluaw0KPiBJJ2Qgdm90ZSBm
b3IgaGFuZGxpbmcgZXZlcnl0aGluZyBpbiB2ZW5kb3IgY29kZSwgbW9zdGx5IGJlY2F1c2UgdGhp
cyBnaXZlcyB0aGUNCj4gYXBwZWFyYW5jZSB0aGF0IHRoZSB3cml0ZSBjYW4gZmFpbCwgd2hpY2gg
aXMgc2lsbHkgYW5kIG1pc2xlYWRpbmcuDQo+IA0KPiAJCXJldCA9IGt2bV9zZXRfbXNyX2NvbW1v
bih2Y3B1LCBtc3JfaW5mbyk7DQoNCk5vIG9waW5pb24gZWl0aGVyLiAgRmlyc3QgZ2xhbmNlIGlz
IGhhdmluZyANCg0KCWNhc2UgTVNSX0lBMzJfQ1JfUEFUOg0KCQl2Y3B1LT5hcmNoLnBhdCA9IGRh
dGE7DQoNCmluIGt2bV9zZXRfbXNyX2NvbW1vbigpIGlzIGNsZWFyZXIgYmVjYXVzZSBpdCBpcyBz
eW1tZXRyaWNhbCB0byB0aGUgcmVhZCBwYXRoLg0KDQpBbnl3YXkgeW91ciBkZWNpc2lvbiA6KQ0K
DQo+IA0KPiA+IEZvciBpbnN0YW5jZSwgZ2l2ZW4gbXRyciBjb2RlIGlzIGFsc28gaW4gY29tbW9u
IHg4NiwgaWYgd2UgZXZlciB3YW50IHRvIGFkZCBzb21lDQo+ID4gYWRkaXRpb25hbCBsb2dpYyB0
bywgaS5lLiBjYWxjdWxhdGUgZWZmZWN0aXZlIG1lbXR5cGUsIGlzbid0IGJldHRlciB0byBkbyBo
YW5kbGUNCj4gPiBwYXQgaW4gY29tbW9uIGNvZGUgdG9vPw0KPiANCj4gRldJVywgSSBoaWdobHkg
ZG91YnQgd2UnbGwgZXZlciBoYXZlIGNvZGUgbGlrZSB0aGF0LiAgVGhlIHRydWx5IGVmZmVjdGl2
ZSBtZW10eXBlDQo+IGNhbGN1bGF0aW9ucyBhcmUgdG9vIGRpZmZlcmVudCBiZXR3ZWVuIEludGVs
IGFuZCBBTUQsIGFuZCBkb2luZyBhbnl0aGluZyB1c2VmdWwNCj4gd2l0aCB0aGUgZ3Vlc3QncyBl
ZmZlY3RpdmUgbWVtdHlwZSBpcyBsaWtlbHkgYSBmb29sJ3MgZXJyYW5kLg0KDQpJIHRob3VnaHQg
dGhlIGxvZ2ljIG9mIGdldHRpbmcgZWZmZWN0aXZlIG1lbXR5cGUgc2hvdWxkIGJlIGp1c3QgdGhl
IHNhbWUgYmV0d2Vlbg0KSW50ZWwgYW5kIEFNRCBidXQgaXQgc2VlbXMgdGhlcmUncyBzbGlnaHQg
ZGlmZmVyZW5jZS4gIEkgYWdyZWUgd2l0aCB5b3UgaXQncw0KdW5saWtlbHkgdG8gaGF2ZSBzdWNo
IGNvZGUgaW4gY29tbW9uLg0KDQpCdXQgbG9va3Mgc2V0dGluZyB2Y3B1LT5hcmNoLnBhdCBpbiBj
b21tb24gY29kZSBpcyBtb3JlIGZsZXhpYmxlLiAgQW55d2F5IG5vDQpvcGluaW9uIGhlcmUuDQoN
Cj4gDQo+ID4gPiBOb3RlLCBNU1JfSUEzMl9DUl9QQVQgaXMgMHgyNzcsIGFuZCBpcyB2ZXJ5IHN1
YnRseSBoYW5kbGVkIGJ5DQo+ID4gPiANCj4gPiA+IAljYXNlIDB4MjAwIC4uLiBNU1JfSUEzMl9N
QzBfQ1RMMiAtIDE6DQo+ID4gPiANCj4gPiA+IGluIGt2bV9zZXRfbXNyX2NvbW1vbigpLg0KPiA+
ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBXZW55YW8gSGFpIDxoYWl3ZW55YW9AdW5pb250ZWNo
LmNvbT4NCj4gPiA+IFtzZWFuOiBtYXNzYWdlIGNoYW5nZWxvZ10NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+ID4gLS0tDQo+
ID4gPiAgYXJjaC94ODYva3ZtL3ZteC92bXguYyB8IDggKysrLS0tLS0NCj4gPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14
LmMNCj4gPiA+IGluZGV4IDQ0ZmI2MTk4MDNiOC4uNTNlMjQ5MTA5NDgzIDEwMDY0NA0KPiA+ID4g
LS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gKysrIGIvYXJjaC94ODYva3ZtL3Zt
eC92bXguYw0KPiA+ID4gQEAgLTIyOTQsMTIgKzIyOTQsMTAgQEAgc3RhdGljIGludCB2bXhfc2V0
X21zcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBtc3JfZGF0YSAqbXNyX2luZm8pDQo+
ID4gPiAgCQkgICAgZ2V0X3ZtY3MxMih2Y3B1KS0+dm1fZXhpdF9jb250cm9scyAmIFZNX0VYSVRf
U0FWRV9JQTMyX1BBVCkNCj4gPiA+ICAJCQlnZXRfdm1jczEyKHZjcHUpLT5ndWVzdF9pYTMyX3Bh
dCA9IGRhdGE7DQo+ID4gPiAgDQo+ID4gPiAtCQlpZiAodm1jc19jb25maWcudm1lbnRyeV9jdHJs
ICYgVk1fRU5UUllfTE9BRF9JQTMyX1BBVCkgew0KPiA+ID4gKwkJaWYgKHZtY3NfY29uZmlnLnZt
ZW50cnlfY3RybCAmIFZNX0VOVFJZX0xPQURfSUEzMl9QQVQpDQo+ID4gPiAgCQkJdm1jc193cml0
ZTY0KEdVRVNUX0lBMzJfUEFULCBkYXRhKTsNCj4gPiA+IC0JCQl2Y3B1LT5hcmNoLnBhdCA9IGRh
dGE7DQo+ID4gPiAtCQkJYnJlYWs7DQo+ID4gPiAtCQl9DQo+ID4gPiAtCQlyZXQgPSBrdm1fc2V0
X21zcl9jb21tb24odmNwdSwgbXNyX2luZm8pOw0KPiA+ID4gKw0KPiA+ID4gKwkJdmNwdS0+YXJj
aC5wYXQgPSBkYXRhOw0KPiA+ID4gIAkJYnJlYWs7DQo+ID4gPiAgCWNhc2UgTVNSX0lBMzJfTUNH
X0VYVF9DVEw6DQo+ID4gPiAgCQlpZiAoKCFtc3JfaW5mby0+aG9zdF9pbml0aWF0ZWQgJiYNCg0K
