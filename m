Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CA26EEA66
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 00:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbjDYWs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 18:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjDYWsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 18:48:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59376A77
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 15:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682462904; x=1713998904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iaXQxxgAh7UUIF2MNfHM9FG96P4qVe+ZZuIjcmaAEHA=;
  b=MqxrLk0heTARRzH3W4BRILBz7+E3z2EWlnr58P1EMzsIBDbCdWNQetI+
   F90BEv8PgjQKDNjHk6tejNuHvGk02K6RnsViwI71xxur3rwaJW3EYm9Cp
   E5mHKN4FFm5oRoqB2LDN7llksDnyNWWyH6NQ94UdGxZqYG4e1JB+fYV3B
   tfq5n3L8RYYOn35VCaqKzDVZMTBUbVVLBo7SDnpjc8+Ee6ZiReN6SaJwp
   t8crH4MFcRgNxQqVBv3itX54X8AUw7hvr9/UVEKO0dhd6I2aFm4VhDkL+
   +PJsTvF13pbPQ9pXl0P3biUcrxLz/wqxooY7EkW/H1F+oarhbARlqECee
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="326526538"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="326526538"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 15:48:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="758345992"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="758345992"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 25 Apr 2023 15:48:24 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 15:48:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 15:48:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 15:48:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUvUxLZM01KqyYODcJEbmwQRoLfrNXllSe588It2uHojj4uVxdZiPkzEEVx8Qo1MKd/AuodY9dN63B+/Zj1GhKdASrL2dEuwN4Wrxvg3yFV6ctRglOF+Bh6HOBpUMqLTCsMpgDo/DzyHZmPTCPOO9NTMVCYDStE5dxvsMqDVs2JcD4ynP6nH5sqBpcmL51e7ZZjudHwgsHG1clQTqGMX0wsO1HtUo84xpkSLq9fH107Hk+XBDkSP5sYkU+Uc+cgxi86Nes4aCyw1dm3A+bixRVAvmY8yaZwdYLBc6a2KxHRqRokAsgPpA+rtAUCCYdmo48AB/32nHTLpAOyN/6rNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaXQxxgAh7UUIF2MNfHM9FG96P4qVe+ZZuIjcmaAEHA=;
 b=LFGZBVbsMzJhNyoQOY9h2f51yBwOEtVDtHxHNAqzUWxX3iG5SkK4N9qC3P6ZZXGL6Hu1vzTNH5pnHLlQcXyfBXwxQfRJhV8K44CvGKR+7krIY8mzWGty1wO7SV61c1bKJqXF9A0dKkYMJddJA4P9igkVo7YbKjx/KxKuoxxELI6GXbi8icDhhYnlR2jmqHsCMzy80XhXPW2/8UmEZMN0kJEsjU3enxV/qZDpGFwoQT6AfHE4IlOGH/87OrfnNQQlRA/i00k3Y3Ja5dnMnEQsrh09Rj6gY99ZLpYR7i6R++oLYsdidC61v/mYE5LiTxI0eHWPaJI3CedJTn6tlokT6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8240.namprd11.prod.outlook.com (2603:10b6:610:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Tue, 25 Apr
 2023 22:48:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6319.034; Tue, 25 Apr 2023
 22:48:21 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWCADGbRAIAAVjKAgAEJCwCABfnwAA==
Date:   Tue, 25 Apr 2023 22:48:21 +0000
Message-ID: <14e019dff4537cfcffe522750a10778b4e0f1690.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
         <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
         <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
         <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
         <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
         <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
         <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
In-Reply-To: <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8240:EE_
x-ms-office365-filtering-correlation-id: 5d59f255-7baa-49e6-c024-08db45df2b87
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b+KEq/jUQPqtLJnQGW/hFq2nTrgZayrIodvp58MPYyr/L8oR5lHA+eg0VD1sMyS9NTSBn53HGiqBM/OC6wUC39EEhunSqdSLcMwmUaaMrsAQhJzVnu4UHLqbW9Aw8w/2AIChgtLWmoxGDBykz3zvx7LSgiPwhYYVp2SBt51U4Mg74AFLrO+BhKihAHZ0EkQy5er2QeSa4spPJCOl06gMt3WWugX2Tm6jyagoFgRX3+v1uP0b7N8kpYtvKFHkNOsetvgoO62OovBghCaVBVfrX9/sat+Um6ELfgkwYoZ4u4fzHSh4mdf4ytNaSJQYqMKJee2Y9qXsz1fS7qh6687qMU1Xf6evbF1XkQH0hcXcNO2eL1RiXuNe/4wIb7GvHNdhXZKGztqlpJGjrpxXW+ZhkmxNMtcXskGjnGjpeY8v7n23HyoXjWMpMhw9so2n1DiSrICcK2yJAGA85IqNhT3YqV9kXEzlDJoii/V8MAFd7QdLkJTtFi6Jx6d4SVf7GoFlPI0+lPFmMwGjVECu3tygFkTU4MzNFJSZ/F30W/ppIBjhpK1Smtt1BJz8/IphGxKaWGxA0Y0uPEP8c2xWgag8OP8C+N8X6w0aGqQGyxxEao5LRGRZBzqE7KM1Nr53RB35
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(396003)(376002)(366004)(451199021)(2906002)(6486002)(71200400001)(83380400001)(36756003)(86362001)(2616005)(66476007)(76116006)(8676002)(66446008)(66556008)(41300700001)(478600001)(316002)(66946007)(4326008)(6512007)(6506007)(91956017)(64756008)(26005)(186003)(38070700005)(38100700002)(122000001)(82960400001)(8936002)(110136005)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2ovRStZNGU4WWtycnZoNUpZVnhCakdZNFZTZG5ReUdHRHlhNlNqcmU5TDVk?=
 =?utf-8?B?Wm5LNTMvQ3RHVWxNZTRUeCsrb1EyOURQZkZ2T0M2S1pyYkx6bWpzNGhsMHI5?=
 =?utf-8?B?UEVvK1hZbmdMd0tnMno2WWw2NkYwK2pUNjAyWkRzVnVTaEpXcE9JQW1xZDl6?=
 =?utf-8?B?MHYzaHZXSEFkd0RhcUNtR3gyNFNtZS9ZNm1mUWYzbm1aY084dmRTaGMzam1S?=
 =?utf-8?B?eW5EQ0ozbFg2c215SWVFRjNUWnZsSnN3Z0l2VXVHWDQrRWQ4M1hXU29temt3?=
 =?utf-8?B?WDFiNjhCUUk5R0xOcWtmZ2hxRWxLaFJqQWwvQnkzZXN0Tm5SdUJ2a3lBSHNk?=
 =?utf-8?B?bTlPZU9IWWEybWNHVjdGYWdQdkxoWElWdkRZbER0S3gwMkpzeTlMZ2hVYlpm?=
 =?utf-8?B?cDI1azdQdDQrU0Y2QVYwbGdKbUxXSG5ob2ZLVXQxcTMyQll1eEJ3U0ZJcUpx?=
 =?utf-8?B?Sit5TkxyT3RwQ1hWdW5PejhmTHB1bWI4WmliUktSWXpNdTZSbXFsR0RydHpB?=
 =?utf-8?B?QzJ1T3MxUUxuekxvUHZmOVUxeitlcWNLbkVTVFZCZzJUQXZTQ3RCME9OUnl5?=
 =?utf-8?B?anZpM0dNdTRYdE9qU0xVNHE1Q1dZaFdLVlpEaVFPK2tGWDVYRU11YUtzTFpu?=
 =?utf-8?B?Q2IvZmovY3VyYW1qU25KaG5FZk1nS1BIdU05cUROY3hFd2hEaERXWE50WEZi?=
 =?utf-8?B?dlhaa2xSbG5jVTRiUWp1UXlDQjdFb0ZJMjBPVkdzR2hSeXFtaWhoc3dNMEFw?=
 =?utf-8?B?SWwvRU1QRDZJU1V3MFNiTnlJaHovc1FmM3ZBNmJLSFY0SGx3MnNRN0ZYU2pt?=
 =?utf-8?B?dGZRUFVvNlViTS9UcFBwcHg4ZnhQMVRMSUVNUkZlTS96S2hxc3ZWSk9lSkRH?=
 =?utf-8?B?aXJIdWtwUUFQTnFCMXRFeWFpZWs4ejJmMGFvWG9kZWFhWU9wVm0wNnY0SFFa?=
 =?utf-8?B?VlRCMkx5KzhLc2kyTmNrY3dXVm9sLzNMNm5MOVg0Q2dDYUhudUFWR0hudXZp?=
 =?utf-8?B?UXkrT3Z2RVNjek9hQng5Nk1mWW9pNU12aVkydEpLaGp0WW9jZnpJbmVrOUt3?=
 =?utf-8?B?bDFuL1ZaS1NNYXUyc0hEQmlaYzhqRjNocUVYSENBTGxlUFpmQnVYY0xQcjF5?=
 =?utf-8?B?TlBiTm1oeHhxTnhydjJDUW5HNG81TlNuejJTVmIxVWw5NUV3Zjc3SlVXVVBF?=
 =?utf-8?B?endQbjRMeXpHSDl4Y1dmd1IvTnM3bW52REZtODBON1QzdUszVGtKZ2lpMDRy?=
 =?utf-8?B?TkxnSGZUcWcwQWZZb3J5WERJekNaWW5MUWkvN1k5ajQxSitaM2pxTk9senpk?=
 =?utf-8?B?SDdHMnhRUDRiSjFDSXVibUxlelpCTEllR0FhV3BsQlVVdkpvZkw3VUpwcHBQ?=
 =?utf-8?B?bEZTME5GMS9nRG5XSm4yNlBRb2k4V0tqaFBUZHp6ZlFUNTRWMUtYSXdNU3NC?=
 =?utf-8?B?Mkc5Tm5GOXMwMjBaRnFCYnNvd1h5Q1M3dmhGaGJVSjdsVWgxemUrOTFZeUQ0?=
 =?utf-8?B?YmxEVzJwMVcxRUwzR3ArKytsbTVsdGJmenJ2L2VBdHFQRWU5bXVHZ2taUGQ4?=
 =?utf-8?B?VjRWVElBamVqWUhCQlVCOWhuSGVTaG8wNW9CN2MvYWlNZ0h3UTB5a21TMVdX?=
 =?utf-8?B?enZmeTJoak9VQUJRZzBGek1IaVZoS1RBdUNDOFZ2K1l1VzhpMUI3Vm5iMm1S?=
 =?utf-8?B?T1VZN1ZSU3RLVGJZNVJ6eGxicEZaNzl3aWNyNFE1UkVzVHZIdWx4TWJ3dCtU?=
 =?utf-8?B?cFpqQmxyMDA4WVV4dEJSQXJnQkREOFFLN2UvRkxFeGVWbXdYbjBEZzJxZGxo?=
 =?utf-8?B?b2RIZEtxL0I2N05LMW5tRDZWQUhKdUpzTzBGV3djek03TEVpeHpyeEtENys3?=
 =?utf-8?B?cVRZRWpJTnlteW1tQkxJQW1QcmtqN1FvNExHcHlhaXBDdlY2VVVlaEVoN3A2?=
 =?utf-8?B?ZVJtMDBYOThRNDc5dkFUTmN4N0xQcDYzR2REUVphN2EwSU9FM2swQ0RSVGZ5?=
 =?utf-8?B?NkJxY3hJSkhmcGY2UGlWSC82MEZOL29DSGNoUHVXeHgzb1Y2K1NrQkJSVGRF?=
 =?utf-8?B?QXJGaHFMTzNwZ2czL3djVnJicTBDU2JsZjdzaGNxdnpGNGE4cCtpMUhoaHN4?=
 =?utf-8?Q?EovRnYjR4lTgx0R4ifDYQbJci?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD1789987930614A98709FA94948ABC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d59f255-7baa-49e6-c024-08db45df2b87
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 22:48:21.2889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WqZ5HG339RE3r6J3411qrOOX6nD2f62Xrv74DuuJuK8+xbuk77qxnNAaBOeFQaik9lnmjimezX9nLm7eprSQVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8240
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIzLTA0LTIyIGF0IDExOjMyICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEth
aSwNCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBpbnB1dHMuDQo+IA0KPiBJIHJlcGhyYXNlZCB0aGUg
Y2hhbmdlbG9nIGFzIGZvbGxvd2luZzoNCg0KVG8gbWUgaXQgc2VlbXMgdGhlcmUgYXJlIHRvbyBt
YW55IGRldGFpbHMgYW5kIHNob3VsZCBiZSB0cmltbWVkIGRvd24uICBCdXQNCnB1dHRpbmcgY2hh
bmdlbG9nIGFzaWRlLCAuLi4NCg0KPiANCj4gDQo+IExBTSB1c2VzIENSMy5MQU1fVTQ4IChiaXQg
NjIpIGFuZCBDUjMuTEFNX1U1NyAoYml0IDYxKSB0byBjb25maWd1cmUgTEFNDQo+IG1hc2tpbmcg
Zm9yIHVzZXIgbW9kZSBwb2ludGVycy4NCj4gDQo+IFRvIHN1cHBvcnQgTEFNIGluIEtWTSwgQ1Iz
IHZhbGlkaXR5IGNoZWNrcyBhbmQgc2hhZG93IHBhZ2luZyBoYW5kbGluZyANCj4gbmVlZCB0byBi
ZQ0KPiBtb2RpZmllZCBhY2NvcmRpbmdseS4NCj4gDQo+ID09IENSMyB2YWxpZGl0eSBDaGVjayA9
PQ0KPiBXaGVuIExBTSBpcyBzdXBwb3J0ZWQsIENSMyBMQU0gYml0cyBhcmUgYWxsb3dlZCB0byBi
ZSBzZXQgYW5kIHRoZSBjaGVjayANCj4gb2YgQ1IzDQo+IG5lZWRzIHRvIGJlIG1vZGlmaWVkLg0K
PiBBZGQgYSBoZWxwZXIga3ZtX3ZjcHVfaXNfbGVnYWxfY3IzKCkgYW5kIHVzZSBpdCBpbnN0ZWFk
IG9mIA0KPiBrdm1fdmNwdV9pc19sZWdhbF9ncGEoKQ0KPiB0byBkbyB0aGUgbmV3IENSMyBjaGVj
a3MgaW4gYWxsIGV4aXN0aW5nIENSMyBjaGVja3MgYXMgZm9sbG93aW5nOg0KPiBXaGVuIHVzZXJz
cGFjZSBzZXRzIHNyZWdzLCBDUjMgaXMgY2hlY2tlZCBpbiBrdm1faXNfdmFsaWRfc3JlZ3MoKS4N
Cj4gTm9uLW5lc3RlZCBjYXNlDQo+IC0gV2hlbiBFUFQgb24sIENSMyBpcyBmdWxseSB1bmRlciBj
b250cm9sIG9mIGd1ZXN0Lg0KPiAtIFdoZW4gRVBUIG9mZiwgQ1IzIGlzIGludGVyY2VwdGVkIGFu
ZCBDUjMgaXMgY2hlY2tlZCBpbiBrdm1fc2V0X2NyMygpIA0KPiBkdXJpbmcNCj4gIMKgIENSMyBW
TUV4aXQgaGFuZGxpbmcuDQoNCi4uLiB3aGVuIEVQVCBpcyBvbiwgYXMgeW91IG1lbnRpb25lZCBn
dWVzdCBjYW4gdXBkYXRlIENSMyB3L28gY2F1c2luZyBWTUVYSVQgdG8NCktWTS4NCg0KSXMgdGhl
cmUgYW55IGdsb2JhbCBlbmFibGluZyBiaXQgaW4gYW55IG9mIENSIHRvIHR1cm4gb24vb2ZmIExB
TSBnbG9iYWxseT8gIEl0DQpzZWVtcyB0aGVyZSBpc24ndCBiZWNhdXNlIEFGQUlDVCB0aGUgYml0
cyBpbiBDUjQgYXJlIHVzZWQgdG8gY29udHJvbCBzdXBlciBtb2RlDQpsaW5lYXIgYWRkcmVzcyBi
dXQgbm90IExBTSBpbiBnbG9iYWw/DQoNClNvIGlmIGl0IGlzIHRydWUsIHRoZW4gaXQgYXBwZWFy
cyBoYXJkd2FyZSBkZXBlbmRzIG9uIENQVUlEIHB1cmVseSB0byBkZWNpZGUNCndoZXRoZXIgdG8g
cGVyZm9ybSBMQU0gb3Igbm90Lg0KDQpXaGljaCBtZWFucywgSUlSQywgd2hlbiBFUFQgaXMgb24s
IGlmIHdlIGRvbid0IGV4cG9zZSBMQU0gdG8gdGhlIGd1ZXN0IG9uIHRoZQ0KaGFyZHdhcmUgdGhh
dCBzdXBwb3J0cyBMQU0sIEkgdGhpbmsgZ3Vlc3QgY2FuIHN0aWxsIGVuYWJsZSBMQU0gaW4gQ1Iz
IHcvbw0KY2F1c2luZyBhbnkgdHJvdWJsZSAoYmVjYXVzZSB0aGUgaGFyZHdhcmUgYWN0dWFsbHkg
c3VwcG9ydHMgdGhpcyBmZWF0dXJlKT8NCg0KSWYgaXQncyB0cnVlLCBpdCBzZWVtcyB3ZSBzaG91
bGQgdHJhcCBDUjMgKGF0IGxlYXN0IGxvYWRpbmcpIHdoZW4gaGFyZHdhcmUNCnN1cHBvcnRzIExB
TSBidXQgaXQncyBub3QgZXhwb3NlZCB0byB0aGUgZ3Vlc3QsIHNvIHRoYXQgS1ZNIGNhbiBjb3Jy
ZWN0bHkgcmVqZWN0DQphbnkgTEFNIGNvbnRyb2wgYml0cyB3aGVuIGd1ZXN0IGlsbGVnYWxseSBk
b2VzIHNvPw0KDQo=
