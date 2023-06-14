Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19963730B5D
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 01:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbjFNXSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 19:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjFNXSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 19:18:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E1EB;
        Wed, 14 Jun 2023 16:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686784678; x=1718320678;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qZApbJ/bKFYPtQOy1A9l663GgtA91+SUIfEl9HbTS6g=;
  b=QpZQJm9de27i2KGdWS1dhTg2aLXr+ZU+ncpeYzfK9+Yd0TUT7o0ucHUw
   WJAyzVuomTDuR3TEIGIuBMZHkcQkQvC22gOv+fxtoRLQ1rq4rHFJWCb4P
   Vr6Vehg66UlAIqwRZtC/UdGeQyirGt6PS1Tsmm2noT0d2qRug00HMAxJn
   zjiXVBu5LO9BJ2bzVLmQZJp6nQhnqo/Rj+8RZ02vNBjmnYKShKUK6HAZX
   o1QhYsEIuWJqUMppMWWUAZ2aoc3iVN5JS2CRFeuX66jNqZtRF5skMuemy
   ITjSOPv0jwK4ik9pQ1scDp+eaGF3AVJMgFY4DRKLTahemasTAUI3aQygH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="424647905"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="424647905"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 16:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="856692391"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="856692391"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jun 2023 16:14:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 16:14:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 16:14:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 16:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4bnN6BC0IAxaWBn6empkO4JGU+e/i69H0MG4UGTnrjumWyy1KpkZng4LNT+hYA9o9E4FbdAf1zYVupnY1danmh037WgiQTQUQNuhb+OqTkNEtYHJ8VS41S/vozDB2YqOMjPMuuzJvPATF1McPbYtCc1GQKXGAIOa8658Hn8OYmROYrBljsb23hwlAVGEloUEVY1zWbD53TrbC/14JsiaF1QkmewJLmXZxypSGv6iiWUOl/sWhxD+brcGfaRdCCAb4UWvAPR9gCql461YUz9xsvNnnte9yORA44O3UuVnRgT5F+BP2gvUZUjv0U6JHcqs/1CFM8rqp1VzaEPZlg90g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZApbJ/bKFYPtQOy1A9l663GgtA91+SUIfEl9HbTS6g=;
 b=L3SIMqfi3+cr/N8q5HWmkjX8Yv+vu5Bs05hV4Vi1qs7Z+z82af/k1RyDXC6NDZCB4UiCHps9iBLXst86pLjoZBQWaI/KnI1YkaGK7pTzpws6Hr1EPNfcu7JGJXyDTAtbMi3sn6WGifRFSK/gDVnnyxQbsbK9eX5MJL13rRobVDsy+vLE+EyGSCoWpFxfUBHNS58phkYzZ6p6T6Wu+EuptIpgRz6d9nNU2lWMwEWbiOevK3ym/nRYnX8csREmIwEefv63BoElckOo3Lhve+cm8JKSbhpt3PKjcINIfB3fI5Xqy2z6A+Qtk/2AllDcVuHbE6uRlrYgaViFw8IwdK+dXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7188.namprd11.prod.outlook.com (2603:10b6:208:440::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Wed, 14 Jun
 2023 23:14:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 23:14:04 +0000
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
Thread-Index: AQHZkeT0wH2MEOTseU2fipMRPmQQrK99OF2AgAJ5WgCACD0lAIABKTIAgAENEYCAAGsQgIAAd9cA
Date:   Wed, 14 Jun 2023 23:14:04 +0000
Message-ID: <f1523fd905f25c811dc9ba9ae47190ca4e21cf3b.camel@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
         <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
         <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
         <20230607180616.GF2244082@ls.amr.corp.intel.com>
         <6b60200b23fa3eac689a140abb92506410b14531.camel@intel.com>
         <20230613173854.GP2244082@ls.amr.corp.intel.com>
         <831f6e968e4794775c3e2adba1d550be70b01c33.camel@intel.com>
         <20230614160507.GR2244082@ls.amr.corp.intel.com>
In-Reply-To: <20230614160507.GR2244082@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7188:EE_
x-ms-office365-filtering-correlation-id: 459c0882-3517-47a4-8e10-08db6d2d0c17
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2hSE6vJf/iyJGATt268Vn6MkaLuGlLvbluYNSIGPzyTvwXNDvISpU36bqtXVsWtflL5BswmHYargd4wl+CkelpK6CLxTm5kLNGyfTxX9hHuzHgkx3YAbUIT2d+ypA9AdvwHBC9gK6EjcTRHRcOyxkxgfYSd1oISHXyvzHbMaf8lQ8IXoZax/sP95G/pSeWjeEVLaGWWVN7QWFVkW/Oq+DF9mnculZEaS54A2t1eCw8ryHjK+MkWPfMRlSeQzAhuSX/t4oz/9xj/tphtQU6bAo6vX1xhxqTNZ7cl8scr7Je3f1O+8oClXDN3hqJatGu/7Fx4ebGZRUe3mMM91tGCPNzuNtv+PWhZxhnS6gI8VKjHK3CvloWoCcJPT18nGFtZ0f3mrd/oklgN0rLv4NNRdSBmjvq1fq4yjXOJTi3k51Y5LxpeGosLgLfzGfgEQaPRwst5ifvttJXD8ZJT0vwOw7BsBfcQwzVfcG2pv9EIryinIcuyV3zP0G0K0uEmhu7gj7/eEygklarn35QkM21liDZTaPoi2funvCUPRDvqPkChMJbO9VjTVDwAMJ++98XYfm+mc2bFK7A8orivJA869M1YTXP8N0t9/nMHTh2IljOg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199021)(4326008)(91956017)(66446008)(6916009)(8936002)(316002)(66476007)(64756008)(478600001)(41300700001)(76116006)(186003)(2906002)(54906003)(66946007)(8676002)(66556008)(5660300002)(71200400001)(966005)(6486002)(122000001)(6506007)(6512007)(26005)(36756003)(83380400001)(86362001)(82960400001)(38070700005)(2616005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TERsM1lRNURkbEJPL2JqTTNhYzNrb2cyMzZWQW9nSldxMEMzSE16dkhMRFZD?=
 =?utf-8?B?OWpHY1VHQlY0MEdDSll6MWkydWlkUlpEQzcrM0d6dnArT09iaXM0UDNGVXBZ?=
 =?utf-8?B?MStJOWlxc1JDZ3U5ZXExMFdTL05GeEVjV1pSVVhJVXMrMGVydXdodk9lQmZK?=
 =?utf-8?B?bzJNQko0ZlBnMzJaZmpmOXcwWEg0ekxmSUloT0JURHZrVi9uUHJNZjdVK3Jz?=
 =?utf-8?B?cTB4ancvT2JGZFdYemV0Rkt2SnNVMkpTSlB6UlhOcGp6dEppNlZvSHUyQ1dm?=
 =?utf-8?B?R3FFNXBkQjJtSmFZMXdEWkxlSGh5M0tOaTVld2NYbWJibUszRUF6cHJOblNC?=
 =?utf-8?B?dDl0R2VvY0l1MEtwTWs3R3BZSFIwNnpYOFZaTDk5QkttNVUySmFiVG5qanRC?=
 =?utf-8?B?a3RPcnFhRkYzdFRXclhhOTUvUmpSSmtWdTRhc2VHdGs1WHp4MzZocjZydGRB?=
 =?utf-8?B?QWlGSU5UZDkvM3NGU1p6NjNLbEJpeUh0RUwwelJBNW5VT05XaEN1cVNuc3pM?=
 =?utf-8?B?am55dU1xaFNxZE43WWVWZGY1eTRNdGdSaGw0b2FlQnhVQ2lQSlpNaGJwYzlK?=
 =?utf-8?B?NVd3Yi9SU0gzTnhPLzdJQ0d2WTBDSSt3bE5oOVhvSmcrMHRVQ1B5cmRaekJu?=
 =?utf-8?B?ZmNTc1ZZblBVTTJ6SDFJdCtCVlN4OSsvTC9RQTBsZWR4VGU0clJhNDVaYm9t?=
 =?utf-8?B?Z1BlTVhzK3J0Tko2aFFhRE5iRlFLYWZMOWJEOW1Ya2xrUjBZTEdvaVR6TVBt?=
 =?utf-8?B?NGtmWFN4OElQeHNreWpINE9kS1J0TGRvRnpicFRsRWttQnN0dnpneE5jTi9E?=
 =?utf-8?B?OFBDdEhzcnZSeWYyMWE3cHRkU2VLNlVvOEcwaStkbEYwRTF3TWUwVDluVEs4?=
 =?utf-8?B?K01US0VsNDdUdi9hcUpTYkFXZWJ1T2xldC9PaTNxZE9nZysyOFhQNk1zbkI1?=
 =?utf-8?B?UmNROFF3UXdtR2hQMWlvNzZQbTVvYWlRR0dCZUp4cTNSbFRlNi96aUxmaytS?=
 =?utf-8?B?YW5oV09YQ3NYS0doQlBvbU1pMklZOTl0T2RKS1hTWVBlTm1DM1BwcFRYenM1?=
 =?utf-8?B?R1QyTjR3MWRYbGltM1AxN1pMUXZWU0c0UFpyYzhDRm1YZ3pRd00wZUt0MFNB?=
 =?utf-8?B?TkJsK0o3RG1Uelk4ZHhkWCthYnN5eVhGNzdjNk1PVEkvZFdrbkYwaEo3TDVB?=
 =?utf-8?B?OFZubDhsdFpaekIyZEp2eXdYMkhnRCt4YnhCUzFDYmZ1KzNLK1d6dUUyeU9Q?=
 =?utf-8?B?TlFBWEtJdzBoNXYwOVJpSGIrUlR5eDF3Z3VGVHBrWWM5cG9YcVZySXVpNUY0?=
 =?utf-8?B?SzgybGIrbXZQcitqaXFHWDdNYTBjekMyTy9Zdk53dlphWTYzY1NzdUlsOUM4?=
 =?utf-8?B?TGVTbmJ3dDRnNmhsOGVNUkQ2RFhFdVlSenBkSk1BT0pyN09xallReGcxbElY?=
 =?utf-8?B?WEY1cTRBYmduakhYYk51cE00eWo4d1Zyb3VSQUhXOE16QzQ5NzFlcm5aSTZT?=
 =?utf-8?B?SzE3K1FaVWJlU1g0ZllvNGdNVG5SVTZCY1VBSUh4SGxmalVKYU1GWE1YVHFB?=
 =?utf-8?B?QXFIRFZLS2JSd0Y2a0E5Ukx6N0tSNDFnNnZXdnN6NThudFJwVFNlR2NYV3JQ?=
 =?utf-8?B?aXdJazlrMGQ5R1kyTXh3Rkw0RGhnazkvNm5lVDh4Q1BmY1hoNTFwZ0FZb2ZT?=
 =?utf-8?B?UXhKMFB0aFJiQXJ1bG1EYkc1a3ArUU0vMmFCdEEvTCt5azdJZFllZ3ozc1V1?=
 =?utf-8?B?ZmxTeGVFK0FHV2JpRjlxQVBvUFVLakcrZXorYzIzajdQOWdTdEpDK3lTUTdm?=
 =?utf-8?B?RjNZTUNqQ0NVZVBKNzY0Nkk1ZEcxamcrbGtKOGwySmt6Y3JKblpzWmpoajdj?=
 =?utf-8?B?bFNwcE9NQmRjVG9IWVF3SWpPR0dyYXV1Zmx1NWNtbGtEeFJldmtEZmZrM0dH?=
 =?utf-8?B?bDNjZklaaTNTN29VVHVZbzNPZXJkc25YN3MxQUdVK1lBTzBGa2FoYTQ4SVZP?=
 =?utf-8?B?Y1FvcnZBWTA2bkEwditmOTVRVE11Z2gxcEJwcVJhbWI4Rmgxbk9aNkt3ZkRE?=
 =?utf-8?B?eXZzZWswQ0xFbjJoUncwL2JBMFMxUEk3T3crcURkVDFpMDBjRmxiTUd0dndU?=
 =?utf-8?Q?Serg8HT/LMdJFmMSDyZNY/BuB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC6F8557E4432A4BBC7C34E048692CDD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459c0882-3517-47a4-8e10-08db6d2d0c17
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 23:14:04.6637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AN5jBjtmACISjUaqnaVKHWe6v0HMLkwtxyQYpVkqecy4hthLrlzhIEcd3+9Az3V6n9vyCixoieRaiiJ0LUXMmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7188
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTE0IGF0IDA5OjA1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgMDk6NDE6NThBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gVHVlLCAyMDIzLTA2
LTEzIGF0IDEwOjM4IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+IE9uIE1vbiwg
SnVuIDEyLCAyMDIzIGF0IDExOjU1OjE0UE0gKzAwMDAsDQo+ID4gPiAiSHVhbmcsIEthaSIgPGth
aS5odWFuZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiA+IE9uIFdlZCwgMjAyMy0w
Ni0wNyBhdCAxMTowNiAtMDcwMCwgSXNha3UgWWFtYWhhdGEgd3JvdGU6DQo+ID4gPiA+ID4gVGhh
bmtzIGZvciBwb2ludGluZyBpdCBvdXQuIFRoZSBmb2xsb3dpbmcgaXMgdGhlIGZpeC4NCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2Fy
Y2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiA+ID4gPiBpbmRleCA4YTFkMDc1NWQyNzUuLmIwZDNm
NjQ2YWZiMSAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+
ID4gPiA+ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+ID4gPiA+IEBAIC00NDk5
LDI2ICs0NDk5LDM5IEBAIHU2NCB0ZHhfbm9uX2FyY2hfZmllbGRfc3dpdGNoKHU2NCBmaWVsZCkN
Cj4gPiA+ID4gPiDCoAl9DQo+ID4gPiA+ID4gwqB9DQo+ID4gPiA+ID4gwqANCj4gPiA+ID4gPiAt
c3RhdGljIHZvaWQgX19pbml0IHZteF90ZHhfb24odm9pZCAqaW5mbykNCj4gPiA+ID4gPiArc3Ry
dWN0IHZteF90ZHhfZW5hYmxlZCB7DQo+ID4gPiA+ID4gKwljcHVtYXNrX3Zhcl90IHZteF9lbmFi
bGVkOw0KPiA+ID4gPiA+ICsJYXRvbWljX3QgKmVycjsNCj4gPiA+ID4gPiArfTsNCj4gPiA+ID4g
PiArDQo+ID4gPiA+IA0KPiA+ID4gPiBTb3JyeSBmb3IgbGF0ZSByZXBseS4NCj4gPiA+ID4gDQo+
ID4gPiA+IEkgdGhpbmsgeW91IGp1c3QgbmVlZCB0byBtaW1pYyBoYXJkd2FyZV9lbmFibGVfYWxs
KCkgLS0gdXNpbmcgYSBwZXItY3B1DQo+ID4gPiA+IHZhcmlhYmxlLiAgSW4gdGhpcyB3YXkgeW91
IGNhbiBnZXQgcmlkIG9mIHRoaXMgc3RydWN0dXJlLg0KPiA+ID4gPiANCj4gPiA+ID4gQnV0IGFn
YWluLCB3ZSBoYXZlIGxpc3RlZCBhIGNvdXBsZSBvZiBvcHRpb25zIGluIHRoZSB2MTMgZGlzY3Vz
c2lvbiBbMV06DQo+ID4gPiA+IA0KPiA+ID4gPiAxKSBDYWxsIGt2bV9vcHNfdXBkYXRlKCkgdHdp
Y2UgYmVmb3JlIGFuZCBhZnRlciBoYXJkd2FyZV9zZXR1cCgpIGluIG9yZGVyIHRvIHVzZQ0KPiA+
ID4gPiBoYXJkd2FyZV9lbmFibGVfYWxsKCkgZGlyZWN0bHkuDQo+ID4gPiA+IA0KPiA+ID4gPiAy
KSBFeHBvc2Uga3ZtX3g4Nl9vcHMgYXMgc3ltYm9sIHNvIFZNWCBjYW4gc2V0IGhhcmR3YXJlX3tl
bmFibGV8ZGlzYWJsZX0oKQ0KPiA+ID4gPiBjYWxsYmFjayBiZWZvcmUgaGFyZHdhcmVfc2V0dXAo
KSBpbiBvcmRlciB0byB1c2UgaGFyZHdhcmVfZW5hYmxlX2FsbCgpLg0KPiA+ID4gPiANCj4gPiA+
ID4gMykgSW1wbGVtZW50IFZNWCdzIG93biBoYXJkd2FyZV9lbmFibGVfYWxsKCkgbG9naWMgYXMg
c2hvd24gaW4gdGhpcyBwYXRjaC4NCj4gPiA+ID4gDQo+ID4gPiA+IDQpID8/Pw0KPiA+ID4gPiAN
Cj4gPiA+ID4gSSB0aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIgaWYgU2VhbiBjYW4gcHJvdmlkZSBz
b21lIGNvbW1lbnRzIGhlcmUsIGJ1dCB1bnRpbCBoZQ0KPiA+ID4gPiBkb2VzLCB3ZSBjYW4ga2Vl
cCB1c2luZyBvcHRpb24gMykgKHRoaXMgcGF0Y2gpLg0KPiA+ID4gPiANCj4gPiA+ID4gWzFdDQo+
ID4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvNWRjODRhMjYwMWE0N2NjYzI5ZWY0
MzIwMGNmM2VjMGQxYjQ4NWQyMy5jYW1lbEBpbnRlbC5jb20vDQo+ID4gPiANCj4gPiA+IE9rLCBt
YWtlcyBzZW5zZS4gSGVyZSBpcyB0aGUgdXBkYXRlZCB2ZXJzaW9uIHdpdGggdGhlIGZpeCBmb3Ig
dGhlIGVycm9yIHlvdQ0KPiA+ID4gcG9pbnRlZCBvdXQuICBJbnRyb2R1Y2UgY3B1IGJpdG1hcCB0
byB0cmFjayB3aGljaCBjcHUgZW5hYmxlIFZNWChWTVhPTikNCj4gPiA+IHN1Y2Nlc3NmdWxseS4g
IERpc2FibGUgVk1YIG9mZiBvbmx5IGZvciBjcHUgd2l0aCBiaXQgc2V0Lg0KPiA+ID4gDQo+ID4g
PiANCj4gPiBbLi4uXQ0KPiA+IA0KPiA+ID4gK3N0cnVjdCB2bXhfdGR4X2VuYWJsZWQgew0KPiA+
ID4gKwljcHVtYXNrX3Zhcl90IHZteF9lbmFibGVkOw0KPiA+ID4gKwlhdG9taWNfdCBlcnI7DQo+
ID4gPiArfTsNCj4gPiA+ICsNCj4gPiANCj4gPiBBZ2FpbiAoYW5kIGFnYWluKSwgd2h5IG5vdCBq
dXN0IG1pbWljIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSB0byB1c2UgYSBwZXItY3B1DQo+ID4gdmFy
aWFibGUgaW5zdGVhZCBvZiBhIGNwdW1hc2ssIHNvIHRoYXQgeW91IGNhbiBnZXQgcmlkIG9mIHRo
aXMgc3RydWN0dXJlPw0KPiANCj4gRG8geW91IG1lYW4gX19oYXJkd2FyZV9lbmFibGVfbm9sb2Nr
KCkgdXNlcyBwZXItY3B1IHZhcmlhYmxlPw0KDQpZZXMuDQoNCj4gQmVjYXVzZSBoYXJkd2FyZSBz
ZXR1cCBpcyBvbmUgc2hvdCBvbiB0aGUgaW5pdGlhbGl6YXRpb24sIHdlIGRvbid0IHdhbnQgdG8N
Cj4gYWxsb2NhdGUgdGhlIHZhcmlhYmxlIHN0YXRpY2FsbHkuIEFueXdheSB0aGUgZm9sbG93aW5n
IGlzIGEgcGF0Y2ggdG8gdXNlDQo+IHBlci1jcHUgdmFyaWFibGUgd2l0aCBkeW5hbWljIGFsbG9j
YXRpb24uICBXaGljaCB2ZXJzaW9uIGRvIHlvdSBwcmVmZXI/DQoNClRoaXMgbG9va3Mgb3Zlci1j
b21wbGljYXRlZC4gIE15IHByZWZlcmVuY2UgaXMgdG8gbWltaWMNCl9faGFyZHdhcmVfZW5hYmxl
X25vbG9jaygpIHRvIGF2b2lkIHRoZSAnc3RydWN0IHZteF90ZHhfZW5hYmxlZCcuIMKgQnV0IGlm
IHlvdQ0KY2FyZSBhYm91dCB0aGUgdmFyaWFibGUgYmVpbmcgc3RhdGljYWxseSwgdGhlbiBsb29r
cyB5b3VyIGN1cnJlbnQgY3B1bWFza192YXJfdA0KbG9va3MgY2xlYW5lciB0byBtZQ0KDQpBbnl3
YXksIHNpbmNlIHlvdSBoYXZlIG1lbnRpb25lZCB0aGUgcmVhc29uLCBhbmQgSSB1bmRlcnN0YW5k
IHlvdXIgY29uY2VybiBub3csDQpJIHdpbGwgbGVhdmUgdGhpcyB0byB5b3UuDQoNCg==
