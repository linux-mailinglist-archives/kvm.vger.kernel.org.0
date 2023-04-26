Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1F6EF066
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239966AbjDZIpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239552AbjDZIpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:45:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91399BF
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 01:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682498701; x=1714034701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=flAKdLLQiV5d7Qg5sW1WPH0wgAAkChWWoiJTnmxiTxs=;
  b=DNilCkgvb+sUlofQA69ZReTALPAOHywcCiuzvwk82rViyBkzXL7VpYbD
   d0d3fUw+zOIkplgHmED3b3uqBS/y7C1ENGijgWlcWq4LVRlC8zPH/ukOh
   asUhGliCYtaDMhQ1Ro0B3VscElLar9/j6UIDN2nW+Z+mDntmqZfEtvzT0
   y0JKjDZF8Xvgq2QEIXVuguiRRacLxVQI/t2x6OBcMZIdrRtJIG9W7urOJ
   Z2QK+NGsUwCqZRHaJlDO0mtG+BzUFRqHtHYoLgcN4gaq64t/kPiDUSfkO
   OvTG4iiR/kc2y1TP3JBd84M0ygweWIaKZfuYBFcdGJZdv9vTv1SHzyNCp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="410022246"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="410022246"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 01:45:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="818034818"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="818034818"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 26 Apr 2023 01:45:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 01:45:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 01:45:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 01:45:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHmsSfyc27E5m/LBtYKVT5j6Qtt+0TzdanPDQJY5VP+nCdi70dmbNqJIlAg69shaSTI/UfU4cVV4ri3UduujzsldNlc398odhPDuMcidUOxTd8mzSe7NZ4qEcatrY99HihXX5xhfT5PhTI05K5HD76HJattRf4LuClEHQYNB/aRMsgjoCG8o4fgnbri2eqQ+m/L3DWqEYvTkjFD0f1aGXLQD50lAVhajVz6XGzzPLz0zU/1BaBvdscWIRDn6YEPy7IyMI/Hi4JOM9LcLK9hxsim7qV5tRijQAvz9Yvj76SlZdMppibeinTd0GRzlfhnO5DIPuEXmqyS8rZLVb8vuzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flAKdLLQiV5d7Qg5sW1WPH0wgAAkChWWoiJTnmxiTxs=;
 b=dsglCFdFTtNJxUvp0u2YeAb1uwdpRKQky4yvkdpigM6mJloEbOHVQ5jLAuX8qE9+ySSweGVDmEL7T1zavXLW6IFctdyHUHhkaotmc3WIDT21+V6JM0CY4kNyTcFfxmJqChzIDqKmjioE1ZojD+Wmpn5tcKGpiEYYO3W3eaex+FGrsSGiX8OY8A1cue2h0c5QrmSXw4C8AFvFFBxIrpYkkq2UroAJveNt3PHzlJZbdCa+GBAlvQW1JzkD22PBXPAAa74A6Ah0df5pqP+HciUi07Y/hn1AHNsa+4y+/0PjO1BA6pTo9GHh3BGvempRICSGtbHm4SEK2XYGj7InM1q1Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6565.namprd11.prod.outlook.com (2603:10b6:806:250::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 08:44:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 08:44:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWCADGbRAIAAVjKAgAEJCwCABfnwAIAAR8SAgAAj5ICAADsLAA==
Date:   Wed, 26 Apr 2023 08:44:58 +0000
Message-ID: <aee97e18098f069c34f40c4ead0f548bed28bda2.camel@intel.com>
References: <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
         <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
         <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
         <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
         <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
         <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
         <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
         <14e019dff4537cfcffe522750a10778b4e0f1690.camel@intel.com>
         <ZEiU5Rln4uztr1bz@chao-email>
         <27c77030-58f4-61be-81b0-f3cc7c084b9f@linux.intel.com>
In-Reply-To: <27c77030-58f4-61be-81b0-f3cc7c084b9f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6565:EE_
x-ms-office365-filtering-correlation-id: 6dce6531-db0b-4732-97f4-08db4632844b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /GLp6kp4DauTDoec0d2CzZa0IcZhea+3cCk7hlT62Knn+LynwDevlnMZSeH2xyJt0bCwh6HJdBdluCuLWZjkURuWJhlDtvunaOE/SIkUBK8KbbLxxIhJqtifsbuAN7ZxqWs2k6vLKaQRt1AulurebGj13K9Jsx/w2OUCeca8XkDfYYxT7erq2BePoiqpdW5v8WO6PQzl7whssuynAEqLIls6nRqXX1aw4c9odlzQwdE2flVOhMnXYBIZ15MYzhKKUAdtB+AGBdPne22+WMWWyHxMdxFtGoBEHpuXGhdtxjEUU+BEE7fmIINui2JrsYs8VKRW2V7PrJ5q6qMnB2UGbjQJLE71dBjX7+2gFszDwRvCtM4/ZxQSrgZMy8wmN35xEtOq1rRikR9IOmalQ3rdR/m42QVCiI6hxD02eCfFSZoHd6fCyq1w+gBnSl58jcHaPoEDM+pEu2rk2irkcFDfyLhwT5kDjHIbo/Clyt71dLXupsFJgjvGCtSWg8pvNREc0m/XuVgrL5A7wCZGehDszXcakXRWIxwYqHrSfACh31dHNMN44f71wQ3X644nOMKoqaRLl5zhQf/Y/BzPRopsJrzqdtVp3qKjo8OdMdZRgXDMk2UrBCASRC1KZGd950EQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(76116006)(91956017)(83380400001)(66946007)(4326008)(2906002)(6506007)(6512007)(26005)(82960400001)(316002)(66556008)(64756008)(66446008)(66476007)(71200400001)(2616005)(122000001)(8676002)(38100700002)(41300700001)(5660300002)(8936002)(38070700005)(110136005)(6636002)(54906003)(86362001)(478600001)(36756003)(186003)(6486002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3Q2OEdsaVJzOG9tdlJNQVl0aGlPVGwvMmx5Znh6dVVremNnT2pncnc2ZEJ4?=
 =?utf-8?B?SWdYdWR0MXB5cENJTzUybUwrcC9EN0ZuajZuSnEvVjhvNXl4djQ3QThpUXJk?=
 =?utf-8?B?bzlpdWJPNlVORjlmZGR4aVJJWVVoY1d4Tm9mcWxOcXV5UTczQzNjcy9welhu?=
 =?utf-8?B?RGpBQmhURUM1VXdyVjFOeHdlenhEK3c5V242em9HUEJpYjVEeUJvL3pwNlNJ?=
 =?utf-8?B?Y2crS2JWcnZjVHJ1MGpPbVJBbTJIQTkxUjdIQWlxQmV1Nk13Q29tTTBlM1Vp?=
 =?utf-8?B?TThUT01qVllQeDljVjZmVHliUjc1U2IwMnpKMkFrckluUG5ERjhaWDVudTAv?=
 =?utf-8?B?QUEvVzArTE9wbjRqdUZvMWFkSHBMR2ZPY1RIZnRHckhyN1ZDc05iTGYrUGRs?=
 =?utf-8?B?QlVwUlFrdUZ4K1BjQmM1M2FiRWtYWmNGV1hwRzlMRzZsM2ZPMDVtSWxCMG1Y?=
 =?utf-8?B?THNSZmhZNGVHRDZFdTA3WHVwenBCc2ZTTmFBYXpvcndWOEFVU2YyZE5XTlMr?=
 =?utf-8?B?NDVHbE91cFc5eFlLRXV5RFN5dGsyTktUNVhhVE1MY1VkelRJdk9ibTd3NmdT?=
 =?utf-8?B?bjY2Mi9YdG9BL0UrVXQybGJuNGdjbyt4K24rUDdLM05CZlBQZEhkQlZkbGQ4?=
 =?utf-8?B?QTloWG9YcEl1SHY2SnhyV3gzQ0t4dnQ2SW0zR3dLeklHOGdQemt0QXRjY2hn?=
 =?utf-8?B?d1B0MTFDRWNDeE83Y01PMXYzZ1B1elg0SzRYdWY0NElJNnlzYjFqeXlSZlk1?=
 =?utf-8?B?dW9KVC8yaitjSk5weitDZnhJVVE0V3FyeVNTQ2ZJU1QvVnMvb2hIWHR6OWZB?=
 =?utf-8?B?S1ZUbWppdjlRUFlCS2FHRVViOHBYbUhaMFlWSXcwRGdSMCsxRWZvS0tpb0xX?=
 =?utf-8?B?TDZTL0tsN2MxTnJYa0Q4MzNkN0QzUkVmOFYxeGFZN083eEprZXk3L2ZRY0xp?=
 =?utf-8?B?czFkSHo0VGtYNE5mT1JmWkhsTnRxT0Ryb2RoMldPd0hHMGYwSCt5QXFQUTdN?=
 =?utf-8?B?T24ydzMxak9SK2ZtYm5kRUhmNDJoWjQ1N0liUFBYVzliQTNoOTJRbkEwL0cr?=
 =?utf-8?B?clZTdkhRRTV2YmVidVZQK1hqMkw3MVZyZ1ppcE5PdlVXa01qTXlxb0NCNm9u?=
 =?utf-8?B?NmF4cWgrNS80ZDJ2cFNtM3FLdmZENzZhYXY2UWM1eHprODBrY0I5QS9veTZz?=
 =?utf-8?B?MERSL1grMDcyZW1YRmpLUUY1YTg5Y0tzaHJsVEtRK2VuVmFHczVZdTIwT0M2?=
 =?utf-8?B?Z2pjY0o5dFQxUTRoRkdFaHFwaGQvZmVXdXhUMGl6ZjVaeCthdmxFaG55T2RD?=
 =?utf-8?B?bkVUTjhrUmpMMUNSallMV2hTV2VER3F3YVBiS1I5NkhiT1dzU25Dd01zVWR0?=
 =?utf-8?B?MnpodVpuY1VKakFsekFLQ2NaNlFqVSswK2dwSjBxWFB5a0ZoUmZoQlpjb0VQ?=
 =?utf-8?B?RFphMGIzMzN6djBCdnlWRFcramRaWmIrVitaelVjU2haS2Z6VHFTQm1wQVp6?=
 =?utf-8?B?ZVUvczlNN2FSWVZFQ0h0L2c0VnhIb1o3T3NjcU1XcGxtOVpSN1VFQ3l3TW9s?=
 =?utf-8?B?YkM0OTNiaFhWTkdmanpBYVdnd1hDMEhIZUk0K3c2UG9Od3R6Z2s3NVF5ZmtS?=
 =?utf-8?B?Z0I1RG5iMGllWE5zb2FNK1ZWR2l6MXNSbXVRd2ZqeU0ycnFtZVl4dDBoTmsv?=
 =?utf-8?B?K0lCWnlJR0JIWnhmclhxb2dqQktISjgzZGxFeERjcEJFLzVGaGsySHlsbWJz?=
 =?utf-8?B?a1B1V2FvLys1bWIyaGNxTlJ3ZDlxZVU4c3FGZEhFOU02N2NsdFdxK29EQ3Bs?=
 =?utf-8?B?SGNFSUhTS1pSaDFsMElUL094ajM3cDB3MFh1RXd2Vy9UY3JJN0NZSWFoM1Z3?=
 =?utf-8?B?bzltd1k0UTh5Q2JjVWFJY1hpUzgycWhjZDBDa1c1eW5TcDFNeGZGcHRkRzJU?=
 =?utf-8?B?QUdaNmRNN2lzRzFKbHpHVkdDQ2RPcWJyUUNocDYrUktPc3FFU05nU21KdG1N?=
 =?utf-8?B?REVhSXBsdE5GbTMrbXhPa2ZVRERHbTdROE9EeFhMdEpOZUxwSUF6cVhndVJx?=
 =?utf-8?B?MEVHSXR6RmM4N3dLOVBjQldiYkZhcHIybTdzMnA3a2x0bXh6VmQrWFhKN051?=
 =?utf-8?Q?yqc7anb0fI5MyTJpXrjYtbGQH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C79558023997024CBBF7C1604AB7E3F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dce6531-db0b-4732-97f4-08db4632844b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 08:44:58.4437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aVaZ+tm8xrZZdTteMVsSnAdENXbhZCG4BSjtkNQ9daho1MpAiVb5ciZC10FZsCjNAYBssayVjy2V4rFp8eCkOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6565
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTI2IGF0IDEzOjEzICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiA0LzI2LzIwMjMgMTE6MDUgQU0sIENoYW8gR2FvIHdyb3RlOg0KPiA+IE9uIFdlZCwgQXBy
IDI2LCAyMDIzIGF0IDA2OjQ4OjIxQU0gKzA4MDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiAu
Li4gd2hlbiBFUFQgaXMgb24sIGFzIHlvdSBtZW50aW9uZWQgZ3Vlc3QgY2FuIHVwZGF0ZSBDUjMg
dy9vIGNhdXNpbmcgVk1FWElUIHRvDQo+ID4gPiBLVk0uDQo+ID4gPiANCj4gPiA+IElzIHRoZXJl
IGFueSBnbG9iYWwgZW5hYmxpbmcgYml0IGluIGFueSBvZiBDUiB0byB0dXJuIG9uL29mZiBMQU0g
Z2xvYmFsbHk/ICBJdA0KPiA+ID4gc2VlbXMgdGhlcmUgaXNuJ3QgYmVjYXVzZSBBRkFJQ1QgdGhl
IGJpdHMgaW4gQ1I0IGFyZSB1c2VkIHRvIGNvbnRyb2wgc3VwZXIgbW9kZQ0KPiA+ID4gbGluZWFy
IGFkZHJlc3MgYnV0IG5vdCBMQU0gaW4gZ2xvYmFsPw0KPiA+IFJpZ2h0Lg0KPiA+IA0KPiA+ID4g
U28gaWYgaXQgaXMgdHJ1ZSwgdGhlbiBpdCBhcHBlYXJzIGhhcmR3YXJlIGRlcGVuZHMgb24gQ1BV
SUQgcHVyZWx5IHRvIGRlY2lkZQ0KPiA+ID4gd2hldGhlciB0byBwZXJmb3JtIExBTSBvciBub3Qu
DQo+ID4gPiANCj4gPiA+IFdoaWNoIG1lYW5zLCBJSVJDLCB3aGVuIEVQVCBpcyBvbiwgaWYgd2Ug
ZG9uJ3QgZXhwb3NlIExBTSB0byB0aGUgZ3Vlc3Qgb24gdGhlDQo+ID4gPiBoYXJkd2FyZSB0aGF0
IHN1cHBvcnRzIExBTSwgSSB0aGluayBndWVzdCBjYW4gc3RpbGwgZW5hYmxlIExBTSBpbiBDUjMg
dy9vDQo+ID4gPiBjYXVzaW5nIGFueSB0cm91YmxlIChiZWNhdXNlIHRoZSBoYXJkd2FyZSBhY3R1
YWxseSBzdXBwb3J0cyB0aGlzIGZlYXR1cmUpPw0KPiA+IFllcy4gQnV0IEkgdGhpbmsgaXQgaXMg
YSBub24taXNzdWUgLi4uDQo+ID4gDQo+ID4gPiBJZiBpdCdzIHRydWUsIGl0IHNlZW1zIHdlIHNo
b3VsZCB0cmFwIENSMyAoYXQgbGVhc3QgbG9hZGluZykgd2hlbiBoYXJkd2FyZQ0KPiA+ID4gc3Vw
cG9ydHMgTEFNIGJ1dCBpdCdzIG5vdCBleHBvc2VkIHRvIHRoZSBndWVzdCwgc28gdGhhdCBLVk0g
Y2FuIGNvcnJlY3RseSByZWplY3QNCj4gPiA+IGFueSBMQU0gY29udHJvbCBiaXRzIHdoZW4gZ3Vl
c3QgaWxsZWdhbGx5IGRvZXMgc28/DQo+ID4gPiANCj4gPiBPdGhlciBmZWF0dXJlcyB3aGljaCBu
ZWVkIG5vIGV4cGxpY2l0IGVuYWJsZW1lbnQgKGxpa2UgQVZYIGFuZCBvdGhlcg0KPiA+IG5ldyBp
bnN0cnVjdGlvbnMpIGhhdmUgdGhlIHNhbWUgcHJvYmxlbS4NCj4gPiANCj4gPiBUaGUgaW1wYWN0
IGlzIHNvbWUgZ3Vlc3RzIGNhbiB1c2UgZmVhdHVyZXMgd2hpY2ggdGhleSBhcmUgbm90IHN1cHBv
c2VkDQo+ID4gdG8gdXNlLiBUaGVuIHRoZXkgbWlnaHQgYmUgYnJva2VuIGFmdGVyIG1pZ3JhdGlv
biBvciBrdm0ncyBpbnN0cnVjdGlvbg0KPiA+IGVtdWxhdGlvbi4gQnV0IHRoZXkgcHV0IHRoZW1z
ZWx2ZXMgYXQgc3Rha2UsIEtWTSBzaG91bGRuJ3QgYmUgYmxhbWVkLg0KPiBBZ3JlZS4NCj4gDQo+
ID4gDQo+ID4gVGhlIGRvd25zaWRlIG9mIGludGVyY2VwdGluZyBDUjMgaXMgdGhlIHBlcmZvcm1h
bmNlIGltcGFjdCBvbiBleGlzdGluZw0KPiA+IFZNcyAoYWxsIHdpdGggb2xkIENQVSBtb2RlbHMg
YW5kIHRodXMgYWxsIGhhdmUgbm8gTEFNKS4gSWYgdGhleSBhcmUNCj4gPiBtaWdyYXRlZCB0byBM
QU0tY2FwYWJsZSBwYXJ0cyBpbiB0aGUgZnV0dXJlLCB0aGV5IHdpbGwgc3VmZmVyDQo+ID4gcGVy
Zm9ybWFuY2UgZHJvcCBldmVuIHRob3VnaCB0aGV5IGFyZSBnb29kIHRlbmVudHMgKGkuZS4sIHdv
bid0IHRyeSB0bw0KPiA+IHVzZSBMQU0pLg0KPiA+IA0KPiA+IElNTywgdGhlIHZhbHVlIG9mIHBy
ZXZlbnRpbmcgc29tZSBndWVzdHMgZnJvbSBzZXR0aW5nIExBTV9VNDgvVTU3IGluIENSMw0KPiA+
IHdoZW4gRVBUPW9uIGNhbm5vdCBvdXR3ZWlnaCB0aGUgcGVyZm9ybWFuY2UgaW1wYWN0LiBTbywg
SSB2b3RlIHRvDQo+ID4gZG9jdW1lbnQgaW4gY2hhbmdlbG9nIG9yIGNvbW1lbnRzIHRoYXQ6DQo+
ID4gQSBndWVzdCBjYW4gZW5hYmxlIExBTSBmb3IgdXNlcnNwYWNlIHBvaW50ZXJzIHdoZW4gRVBU
PW9uIGV2ZW4gaWYgTEFNDQo+ID4gaXNuJ3QgZXhwb3NlZCB0byBpdC4gS1ZNIGRvZW5zJ3QgcHJl
dmVudCB0aGlzIG91dCBvZiBwZXJmb3JtYW5jZQ0KPiA+IGNvbnNpZGVyYXRpb24NCj4gDQo+IEhv
dyBhYm91dCBhZGQgdGhlIGNvbW1lbnRzIG9uIHRoZSBjb2RlOg0KPiANCj4gK8KgwqDCoMKgwqDC
oCAvKg0KPiArwqDCoMKgwqDCoMKgwqAgKiBBIGd1ZXN0IGNhbiBlbmFibGUgTEFNIGZvciB1c2Vy
c3BhY2UgcG9pbnRlcnMgd2hlbiBFUFQ9b24gb24gYQ0KPiArwqDCoMKgwqDCoMKgwqAgKiBwcm9j
ZXNzb3Igc3VwcG9ydGluZyBMQU0gZXZlbiBpZiBMQU0gaXNuJ3QgZXhwb3NlZCB0byBpdC4NCj4g
K8KgwqDCoMKgwqDCoMKgICogS1ZNIGRvZXNuJ3QgcHJldmVudCB0aGlzIG91dCBvZiBwZXJmb3Jt
YW5jZSBjb25zaWRlcmF0aW9ucy4NCj4gK8KgwqDCoMKgwqDCoMKgICovDQo+ICDCoMKgwqDCoMKg
wqDCoCBpZiAoZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX0xBTSkpDQo+ICDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmNwdS0+YXJjaC5jcjNfY3RybF9iaXRzIHw9IFg4
Nl9DUjNfTEFNX1U0OCB8IA0KPiBYODZfQ1IzX0xBTV9VNTc7DQo+IA0KPiANCg0KSSB3b3VsZCBz
YXkgd2Ugc2hvdWxkIGF0IGxlYXN0IGNhbGwgb3V0IGluIHRoZSBjaGFuZ2Vsb2csIGJ1dCBJIGRv
bid0IGhhdmUNCm9waW5pb24gb24gd2hldGhlciB0byBoYXZlIHRoaXMgY29tbWVudCBhcm91bmQg
dGhpcyBjb2RlIG9yIG5vdC4NCg==
