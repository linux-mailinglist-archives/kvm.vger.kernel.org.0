Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0281E72D430
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 00:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbjFLWLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 18:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbjFLWLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 18:11:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F5AE1;
        Mon, 12 Jun 2023 15:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686607865; x=1718143865;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=psxlA3cr/8J3JlnqxxoW2I+CAjoNHAGAHiJPhMEszlU=;
  b=d5WAlcPuZV4i2mJxRjBa995/ecYZrRgFXLBxgTh+gRZp6I5dhW5wUduF
   GEMj6OKTuKCOI1Qwzj0NhcyT0cJUzSQsBpuDUO+Lw9DGmsgp6suWE9vyw
   iAS1FRqFORuSzWDtyy22/ydlht0cyaN5murMsE/WV0keffTyYaDY44IxP
   PYTQfYkyJF+cFemdRjpyc00nRTKZttqJa/8Oac3uB46YLw+rurW0puub+
   0imhMbINfTSfdggM/ANRt0jt3zpAT0lFzuj8Vv8gjwU5mZQXHSAYOG5HY
   omnpVapijAQ6hjh1pA4gkXHSXWU6Vh0UfWTXogIcqYDvXEWKbLnGCSigm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="444551364"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="444551364"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 15:11:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="958184320"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="958184320"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2023 15:10:53 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 15:10:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 15:10:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 15:10:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE9KoLaUT6HkjWnEyXm6HPdpnx2e3B0A4HAvx2tt24kr7F8Ba+L2DJ8lRH2XcP7dMGVpfRIh0BnUJZffuPfDudfNxpaovc9V4Kw010f6+/6mqfbQoRZZKJwuQ0t8Y66TwQbAd0CXxo0oAgyHfiVWsp3ds0L4FI+zoppgBQL0SsgQEWK/7duExLWSpAc/OoLEjhJWbOOHPhMA2Ewh/PuQW8D09Lt1kg1NqUdSd1u3A+xaky9DT17TPxEM0oVeSKh8Ux17QyHzYRKsZln+B8ZrWnEC9z686Oj4QiVEeNAPyN3GbhZOycrY4ABUT3uYE+9tZg+ETp3ANlxV2/sq8gun1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psxlA3cr/8J3JlnqxxoW2I+CAjoNHAGAHiJPhMEszlU=;
 b=VhH45qiJspgxj9fEotZFFywnjQaZY9ftvEMtiFvRikkeoiJ1jQviCDupTcXtUtjyAuqeooTB4VbcSSpCm6It0bhZFF5EC9HL3vb1ly/38k6bd+rPxGeKNlHrX6jCrxP7pzLQwnBQgs0ML9kN+HKfZP5hvpl9SpJZIJ9Xe3Hy/Cb6hYclrELBIBnkIdt5lC3iumYyQTgqMxmVh7GTZJ8RE5blKYANEBSZAHNBZrHA5OYaZ3CuBPJAllYLa6YWRVWCKpqvu83ObaijskXV/ZRWPbLN1TP2fvwFtyGE3NhMdNfSHkssZnogBVYGkbC2NLvOAZdEcsyQSk86BxjkMN2vuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7391.namprd11.prod.outlook.com (2603:10b6:610:151::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 22:10:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 22:10:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZlu+2r84uqtF1H0SFKn93tuC1FK9/hdAAgAE59ICAACfHgIAFl0EAgADJKYCAAH+agA==
Date:   Mon, 12 Jun 2023 22:10:39 +0000
Message-ID: <3e188621d97af794f03072e5261dcc9f589900aa.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
         <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
         <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
         <201af662-f700-9145-c113-563e378074ad@intel.com>
         <89c99e7360dc2acfe5fb56c2bbb40e074e1f94d5.camel@intel.com>
         <20230612143355.sur7zc7byu7omxal@box.shutemov.name>
In-Reply-To: <20230612143355.sur7zc7byu7omxal@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7391:EE_
x-ms-office365-filtering-correlation-id: 02b46c21-b5c4-4b90-1d5d-08db6b91db61
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MZUtHlTlA8qzOlb3iCDY5baYfgijga7qMbdgvacBYQdhz2EAN/sD+JaX9yB+zc2BQ0rriUADoRd71f1cAimhIMWOc+NHWX9EZz0xMH3CBV12IVEdcKPm3b0gYD/aJG5oelXeDMrm/f5ZulxOIcLh2sxWW1UM9Ah1sP95MXUveZirfAP4twWcY65QWlmINO8LMRH3Q+MsFofctx/bmX/LN3/PRvdSQPoAFSKdZxoJE3kogg0OmqNMI6hrIuwppNkbWvL6PITpcpWU2a/4PnLTXsmOyL9GY+mVwGyFM5MT0vjgQWqI50T3qWXPbamv7txLuBa4phP1xMyQ3oQZB6OR8GqD52K0fQMrM4twK8Ruf4Iu9NyCxgDTsNlnrRwEDN+yAf2Cj6Ykcq9PxhQk4Vif0nAyuj7MykeF+WBFOL1h/sKwnLQga2rxGyAiS2X2JdK8sgVXT3j08V7mqe/iUZU7ph+QBkMcaX/9d8tXFNbwmzn1We/3BIsdadJQZTWHDnrBl2LG9JEXXbBGOhedHFAiEcZKZ0Z29Nbv1sDnXhgrnu/qxxxUXy1TH7v7VVgGsEx10XoDFoezVT+VSLTlOyQLTsrfez8aNB+xT2i3hmf0iMkmyJ182QVIQhe5gQg+dTs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199021)(6506007)(6512007)(38100700002)(2616005)(41300700001)(6486002)(26005)(83380400001)(186003)(66899021)(71200400001)(478600001)(82960400001)(54906003)(6916009)(66476007)(66556008)(76116006)(66446008)(64756008)(91956017)(316002)(5660300002)(8936002)(4326008)(7416002)(8676002)(66946007)(86362001)(2906002)(122000001)(36756003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkQrNFRIeEp6NVk0dGE5bHdwNWVuM0k2KzRWc0ZkaUxsVmU3T1VleTZGV3Ft?=
 =?utf-8?B?VGlaU2xLNkxnNjJ4eGZManphMzN5SmFOaXJtcU4xUnhkR2thMW1kRDdCdFdG?=
 =?utf-8?B?Yi9leU9zcmlsRkNxOG5CNFNKSkczbUxXSG5ZT1RPbEpHdlRGT3p5cWRlNXhG?=
 =?utf-8?B?bkhualByMHNzSGl3emxHUlV6UktHZ2h2SGk0RFNBd00vcjFYZjZjeUptQVdv?=
 =?utf-8?B?aTlYaVpZd3Rxd1E4eXFsUEo4V3VLSmh0Q2Q2T2ZPKzZlRC9oeEZOTUpuTHZx?=
 =?utf-8?B?Y2dIOTJqb1pGNXZXNUFmQ0VWNGJPOGQyNDJES1hCbDk0WkM2d1ZXaGx0OWp6?=
 =?utf-8?B?aEp0UHI5TUJYVnV4MDJxSkVTbmcvNENDZWhqaTY4UU5teVR3b2EvQWlaQldL?=
 =?utf-8?B?c2lhdVp6cUFOS21KR0JkelhOT3Fna0s0enNMaVU5NVZiZ0JUL0FQaklrZmRC?=
 =?utf-8?B?Z0ZYOWFXUGtJMHYwdXg1aThTUHF1dzArcThic1lKaE9zbDBaMUsxaWV5RUxz?=
 =?utf-8?B?MzlGWlo2T3hIcTlXMnZLMVBEaVZFMlVUNU8zOFpCN0xVR0oyYnNuZlZqczB3?=
 =?utf-8?B?RXExYzdCck9nbmdseHcvcXp2d0ZDZFp5RG1XU3ZST05XaXRhWjBZMko3Vzc5?=
 =?utf-8?B?eUtwMmdGVVIyTFZVUGNWSWhlaDhodGZGV0pvQi95K2FOQVJ6dEcvamYvYTRN?=
 =?utf-8?B?VUpaOHJramk0RUZWVnBxbWNyc05RemlzdlpxbzlZV3djYmcwWmdQU2tQR1da?=
 =?utf-8?B?aUVUaVNBVGpFQU9scE1ncGVNU2U2cUxLN3ZaOEtJaUQwRVpDQ2piekJ5LzRn?=
 =?utf-8?B?ckR1K2dDdDA3TjAxRVlndTY1NGdHVnk4SDQ4OFBzVWRGQ1c3UUFWL2JSQkxJ?=
 =?utf-8?B?VnJZOE4xNzRLcnM3b0JMZTBObDFYcmllbkVEWUw0M2tQY3hXTTVnSjhUMGh2?=
 =?utf-8?B?MnFJc0hPVHVFRE15OWxuR3NUZnMrZU1saTdRSDYxa2h4b2EzYzB0Y1U3RSt5?=
 =?utf-8?B?ck5uQmxWSXUyK0ZXVUhVS0dKOHNtd0VlM0xOYnAwd0FIYUZNQlNIRWY3NW92?=
 =?utf-8?B?a3dWSHV2YS9KTUplalVGVWYyZzZIVlFpVmpnOU05TlE1Vkh1QnZKbXBXNUpE?=
 =?utf-8?B?SURZUDJjaktnVCtwRjJ6OXZ0eWNyM09hN2loc2JvVnhlVlg1R043azFLcTN3?=
 =?utf-8?B?cUhWb3E5QWJvNGVyQTJGeHBIL0VEMmtvc041Ui9LeElXMktWQU1EY05wNE5H?=
 =?utf-8?B?VnRZSkk4Q0htQ1hubFBaU0FIYW56eHl0L1FoeUY0VmZLMm5sV2txdmhIYkd2?=
 =?utf-8?B?dWM5KytCTkFSOWFGM0pPb1RrdXJ2TXM4MFdGUFczK1ZvcHdaK0NBZk44eE9x?=
 =?utf-8?B?Wm9KcjRTM0RVSFEybzhIaDk2VTY4OStadURPN0c1am5UR0p4WFBmWXh2VDdj?=
 =?utf-8?B?ZnQzVlNpcFliTHRKdUJxYitpQXlYV29NSXc5S3pBbmFzRmorSUd6aVhWUHlq?=
 =?utf-8?B?L1l3YVJaMHBRM2NTOGRFZTY3NDVsQ2t4VjhRb1hKTmJSQUtsaUgxRXdEZ2VF?=
 =?utf-8?B?dHhmcHorL2dveVRzalV6N0d5dVJnaDhrZTZZVlhXZlh1SElVTCt0YTZERHNZ?=
 =?utf-8?B?WnViRmlEeTFkVzIvSWJaMm5aVjdnVER3TWJHOW4ranArTm9tS3k3dW9uVmxj?=
 =?utf-8?B?bklhZzdRTGxjcjRLd3cyQ1FZWk1Lc0k2RUV6Tms2cDNJL3JpM1pqajZUY045?=
 =?utf-8?B?UGR0aEU0TmZ6Z1ExaVBWNUdpWG94TGZDWXVsbThpeERKUmZMeGh0QXV0RGtZ?=
 =?utf-8?B?Z0g0YmdFalZiZXFjaWF1Q0toMHhJanowYi9qMmRBbUhPaGVMZ1pZdUxyRFFz?=
 =?utf-8?B?ZnRNSmF2c2hWRzZxbEthTXllZ0VGQm1DOEtoN00wbk5Wc2xYTWNrbVRRUUk2?=
 =?utf-8?B?cUVKbzVFU2ZvVExQV2tKczdzMU50L3cvU0k1ejhDNlZSa3hGV2FITkJJZU1V?=
 =?utf-8?B?dVo1N2JGdXN5OHlrOVhVUjExM0tnSXd3eXQwcUppM1FsbGk5aERLVlY2cTBh?=
 =?utf-8?B?blNCZHB1K3craVNFTmRWVWRqWkhSMTNDYlplSCt0VldHYWpBMStlU0UwalBJ?=
 =?utf-8?B?YVB2d1dtMWdIeURJVjl1L0ZISm5mSElveS92UVAzb3IyeHYyTFNwVDdZZVFh?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <347F33815A199C45880EE132FF3392E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b46c21-b5c4-4b90-1d5d-08db6b91db61
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 22:10:39.7864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f1dHaqv0Wot0S+SevDIQXooOzEDn/hMDdnZKybavEsU0RS1bacg0Y/W+M07LRGhvAEqdzv4IXedPEZuXmHB0zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7391
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

T24gTW9uLCAyMDIzLTA2LTEyIGF0IDE3OjMzICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAxMiwgMjAyMyBhdCAwMjozMzo1OEFNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IA0KPiA+ID4gDQo+ID4gPiBNYXliZSBub3QgZXZl
biBhIHByX3dhcm4oKSwgYnV0IHNvbWV0aGluZyB0aGF0J3MgYSBiaXQgb21pbm91cyBhbmQgaGFz
IGENCj4gPiA+IGNoYW5jZSBvZiBnZXR0aW5nIHVzZXJzIHRvIGFjdC4NCj4gPiANCj4gPiBTb3Jy
eSBJIGFtIG5vdCBzdXJlIGhvdyB0byBkby4gIENvdWxkIHlvdSBnaXZlIHNvbWUgc3VnZ2VzdGlv
bj8NCj4gDQo+IE1heWJlIHNvbWV0aGluZyBsaWtlIHRoaXMgd291bGQgZG8/DQo+IA0KPiBJJ20g
c3RydWdnbGUgd2l0aCB0aGUgd2FybmluZyBtZXNzYWdlLiBBbnkgc3VnZ2VzdGlvbiBpcyB3ZWxj
b21lLg0KDQpJIGd1ZXNzIGl0IHdvdWxkIGJlIGhlbHBmdWwgdG8gcHJpbnQgb3V0IHRoZSBhY3R1
YWwgY29uc3VtZWQgVERNUnM/DQoNCglwcl93YXJuKCJjb25zdW1lZCBURE1ScyByZWFjaGluZyBs
aW1pdDogJWQgdXNlZCAob3V0IG9mICVkKVxuIiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB0ZG1yX2lkeCwgdGRtcl9saXN0LT5tYXhfdGRtcnMpOw0KDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQo+IGluZGV4IDljZDRmNmI1OGQ0YS4uY2MxNDEwMjViMjQ5IDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gKysrIGIvYXJjaC94
ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+IEBAIC02MjcsNiArNjI3LDE1IEBAIHN0YXRpYyBpbnQg
ZmlsbF9vdXRfdGRtcnMoc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QsDQo+ICAJLyogQHRkbXJf
aWR4IGlzIGFsd2F5cyB0aGUgaW5kZXggb2YgbGFzdCB2YWxpZCBURE1SLiAqLw0KPiAgCXRkbXJf
bGlzdC0+bnJfY29uc3VtZWRfdGRtcnMgPSB0ZG1yX2lkeCArIDE7DQo+ICANCj4gKwkvKg0KPiAr
CSAqIFdhcm4gZWFybHkgdGhhdCBrZXJuZWwgaXMgYWJvdXQgdG8gcnVuIG91dCBvZiBURE1Scy4N
Cj4gKwkgKg0KPiArCSAqIFRoaXMgaXMgaW5kaWNhdGlvbiB0aGF0IFRETVIgYWxsb2NhdGlvbiBo
YXMgdG8gYmUgcmV3b3JrZWQgdG8gYmUNCj4gKwkgKiBzbWFydGVyIHRvIG5vdCBydW4gaW50byBh
biBpc3N1ZS4NCj4gKwkgKi8NCj4gKwlpZiAodGRtcl9saXN0LT5tYXhfdGRtcnMgLSB0ZG1yX2xp
c3QtPm5yX2NvbnN1bWVkX3RkbXJzIDwgVERNUl9OUl9XQVJOKQ0KPiArCQlwcl93YXJuKCJMb3cg
bnVtYmVyIG9mIHNwYXJlIFRETVJzXG4iKTsNCj4gKw0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAg
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggYi9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmgNCj4gaW5kZXggMzIzY2U3NDRiODUzLi4xN2VmZTMzODQ3YWUgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiArKysgYi9hcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gQEAgLTk4LDYgKzk4LDkgQEAgc3RydWN0IHRkeF9tZW1i
bG9jayB7DQo+ICAJaW50IG5pZDsNCj4gIH07DQo+ICANCj4gKy8qIFdhcm4gaWYga2VybmVsIGhh
cyBsZXNzIHRoYW4gVERNUl9OUl9XQVJOIFRETVJzIGFmdGVyIGFsbG9jYXRpb24gKi8NCj4gKyNk
ZWZpbmUgVERNUl9OUl9XQVJOIDQNCj4gKw0KPiAgc3RydWN0IHRkbXJfaW5mb19saXN0IHsNCj4g
IAl2b2lkICp0ZG1yczsJLyogRmxleGlibGUgYXJyYXkgdG8gaG9sZCAndGRtcl9pbmZvJ3MgKi8N
Cj4gIAlpbnQgbnJfY29uc3VtZWRfdGRtcnM7CS8qIEhvdyBtYW55ICd0ZG1yX2luZm8ncyBhcmUg
aW4gdXNlICovDQoNCg==
