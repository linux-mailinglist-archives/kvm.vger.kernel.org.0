Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F1F73AD2E
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjFVX22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjFVX21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:28:27 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36D61BF6;
        Thu, 22 Jun 2023 16:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687476506; x=1719012506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oC6IEQI0lj2oD0/ueS/PW0YMtWP8UjxcWnSDJn0yvu8=;
  b=POGgVhZajx4l7SSdrdkKiWJeQN2Gh03yHnSxSK2wOFkkdMIa+mw21zdg
   HqWQ4uGktg6GzN3KuGrUzarbI25JPyZ0QjykTjqGifam69wJvz5qiX6gR
   Ahnr/B6fXxNSCwEZZRpMZi8udUqFzeh2Cc5K2GGec2z4suBSnFNu6xO07
   pAJfgghfK/Af4AMEMaznhL7N1j7PvEdKVF6ccsv8zkwZ9aU3T6UBKStJY
   EI/zG9NL36IaC4fCeaHz6NCEdzRgoefqEUxMdnXek+weZ1IOHZ2CBlpk+
   rsK045oNwJ+wL1mb9e+vJICEa609Npp1RRIIa61ZnZAxpB6t6fru4E+mC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358131657"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358131657"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:28:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718288478"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718288478"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jun 2023 16:28:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 16:28:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 22 Jun 2023 16:28:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 22 Jun 2023 16:28:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALZLCGeUf4n/MZ/LgeFAfXlMH2C0DQemBAqrskOS+X3c+FS6Obrmmqdvln69M5F9PDOMGCqoCC8UngSxYloNC68MhR7WlloI9QsdvCjkq4qg1bRdUf0qM+l7s28PnNh/7RUlnCHfByiXtVUYTxTM9qhQaqjpb4yyVfHQloj/QdmRB85mf+8JGkKVBqHBzVxs9a4O31R5k9cTzW+ibDM3U6ympT2ud9ZA/1kuv3CRgwMKIRTmqZRf2ZeMTIvgtt3oKvp5aHoZZt6n7XRvPN+WaoT3RViVtsy9gLcRKQnRnfd7HeJna6kVhFsSXxdQwCoR6VLrbxkqTTcPT/RSQZbj4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oC6IEQI0lj2oD0/ueS/PW0YMtWP8UjxcWnSDJn0yvu8=;
 b=n88HVNctDc55XBW+NkgDg1oAlXwkNY+aMGZ/x4L3k5TRV274H47U7i+dxjervHUelJ/UiK23Zzjy2waJF2B5zbxSWkJC1vW7IkZ0CwuJnOuA17UMDgNO8yMdQ4WIyoMZAywfPI3cq4nN8L5iZSxs/VDeH9gy5iJMJHgGpV1FVRMeVWGetREbSulYqcbpCSbIhKhobB9zdUZk6reP1ezyTSAYTiBFZ9X7llWxugpw7vmtvZpHGvUuqvL9Yl21kSt8TnjTwqmfi8PCQRHrr79e/k+pQUn1eGXQvfdh0yZfxyRCs8TC5SBaU1iOQqV2XqrxYLDBMVr796S4WslFgXLIfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6396.namprd11.prod.outlook.com (2603:10b6:208:3ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 23:28:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 22 Jun 2023
 23:28:22 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "michael.roth@amd.com" <michael.roth@amd.com>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "ackerleytng@google.com" <ackerleytng@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>
Subject: Re: [RFC PATCH v2 3/6] KVM: x86/mmu: Pass round full 64-bit error
 code for the KVM page fault
Thread-Topic: [RFC PATCH v2 3/6] KVM: x86/mmu: Pass round full 64-bit error
 code for the KVM page fault
Thread-Index: AQHZpV+yhpnTip1UUUaNzYvoReaLo6+Xd7YA
Date:   Thu, 22 Jun 2023 23:28:22 +0000
Message-ID: <37b868c53c9f35e8ec051573562a4598df38d72d.camel@intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
         <b659f86ac7128965e05a7a660c38734667530fc0.1687474039.git.isaku.yamahata@intel.com>
In-Reply-To: <b659f86ac7128965e05a7a660c38734667530fc0.1687474039.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6396:EE_
x-ms-office365-filtering-correlation-id: 448d8d1b-1210-4061-e0f8-08db73785ebc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yxi5AZuu2k7RaXlSPQtKXkDeqZcTQx0waZGkulnyaZuXXYNmzYsFnzNugIjvhRAk8lwd8w5zvr97oBQqVdAWjgctYm6HlBGKENXqkykSFdLGb6OFTs7kEP6dKUMrHo97waRorKpOYQnZDahpFlZcqNIFaBqJgoJN9JTtkIZram258LFc9L9fNkv1boNz8Do2qVh23ByiD6afFWXYy0T2qyvVwpvLG372gyPs6ojowUITJPKeKbKyygYZMT/W9IHPVSB9oQaQ/O/Mq3pU52ZfG2FLd/rgZ+jj9CGtMIHXGMadIJqKFgw24MLAvXOKFqCP5GdXmKZKjZBN7cmHq6W9bbbOWjnkBvc33KrxcoMC+Bm+7Nw8ekQr/086EUiEoyQVCePU+drhZ5VwM6KSdsW5oRrJRf3fqoDSwmngwZ3QL23k1P3GXAIxNLAQTcGWSQS+PEh+RpYoHdJdnbhuJmMZ8fpVul2FnrGfXrfl+xvcRZdsNBguRt0uzfa2e6LrgE/U0J61dz83gRu/H6H4vAE6FY8h+hMzdERuaG8kl4p8vl10EbfKox1B9juqbRTSJm9+MbxqA1p2/BVts5cLxaSpMCDsxOer1CCgbM9pD2ZafktuR4lb7ybfwdT3zsHrrAsf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199021)(186003)(26005)(6506007)(6512007)(2616005)(82960400001)(54906003)(7416002)(6486002)(2906002)(71200400001)(478600001)(36756003)(4744005)(122000001)(38070700005)(38100700002)(110136005)(64756008)(91956017)(66446008)(66556008)(4326008)(316002)(8676002)(76116006)(66946007)(6636002)(41300700001)(5660300002)(66476007)(86362001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkMxRHowYzdkU1lDTnpvKzh1aGNBbWFqMW5xTC94MXV6d0lQSTJJemZHSXRP?=
 =?utf-8?B?WStwQ1AvRitnajBuVE10TWJNRDduUW1nNllLb29rc3k2RnZnSzdwVkpoblRt?=
 =?utf-8?B?aXdqT0R5NXV4M2pRVWxzMk11aDJ2UnlYVndoQzV6ZjQwWStsWU1ENGVNbTNy?=
 =?utf-8?B?N1NRd3kxNExHcXB0ekh4azc0Rk5Bd0FpTWJJVlBSaHhwdytjNk1QdlFUam9h?=
 =?utf-8?B?Mmxvb3QrWVNiZ2JublZVN2w4YXRyc2tUWGYzdkdLaWZtQVhUQTNydHJqTWYy?=
 =?utf-8?B?NkhrOFhnL3F0NzhhTFkxOS9ZQ2t5ZTZGSnlYVlhGYVNndHZ4R2xldTFEbUMy?=
 =?utf-8?B?VzdoTzF3VEZNdjVURDc1S3lhUHBSdE1WVmQ5K2RRcmhOZ0xyRVl2K2NtdmZY?=
 =?utf-8?B?RUNtejVoS0VPWjdTQ2hjMTBwbTNJdVJyVkNrVVZLbzRaTWl0RXR1SVBkZWtK?=
 =?utf-8?B?dHg0azdxYjlhR0h3d3h5SGFkWkpueEI4OTRib2R5TGlvRXlCUVVpSTFFRnpO?=
 =?utf-8?B?Nkc5VXJjSTBnc0xDdU5jdzhGODdJd2RMakJuejJUVTUyeDNyTENSNTBPNGkw?=
 =?utf-8?B?ZStsUXptcW1kSHYybyt6SXdIOTk4MTJLSkFDbSs4anoxcDN6cG9tN2lxUm5i?=
 =?utf-8?B?dXRGOUtaMXBBR2NtNHlkSVJyVTF0WmQ3cGlmYmgreHRaeU9aK3pncTJOTG5O?=
 =?utf-8?B?MVJ3aWIwemFIY1kyZlJCWDJBcHhrUUpxdzRqOWNhTm9LNmcxSHFGbFJNNHJh?=
 =?utf-8?B?NkxDaDVSOGVvdHZONW52Mkgva1lFMVJuZ0ppazZvR3hjNXl5UGU2d3JzRzJV?=
 =?utf-8?B?REpLbkhQNTEzUDkrS3ozdHI2Qzd3ZktSbjB4Q2F0Nlk4dTJqdlkyRXpqYndq?=
 =?utf-8?B?SHE4TURrOGxkcHliNzFGY2hRRWJIWW1xbmpFSkZxNWxSOUMyUnVydGtpMlFX?=
 =?utf-8?B?dDdKelc2bDNGMkV4eE8xcGRSemxZaExJUVZtOEFUZ21raW5PZTROZjJpNmEv?=
 =?utf-8?B?ZHBBSlJBdkh3bnZ3NW9Gb2h4b0FZL2V6V0hDY1lOd1RYWVpTcXdsL3lLMTFn?=
 =?utf-8?B?dnhiRHpRTVJDOEY5SEx2ek1IcUYyM3BhbDZVdGdzZ256WGJCb3VhU1RVRkVx?=
 =?utf-8?B?SmZFQ1hWMmdMUFhhYUd5cnlrbjluVm5CdEdtNUwvTUhUb3ZWNk1waGZqbGJW?=
 =?utf-8?B?TkFCek1uTmY1Wi8vSC9YVEM0OFJjRFh1YWJQajk2S1BKNzlyTWRkOVcvWGtY?=
 =?utf-8?B?dlE0SlNOam1WZy9xZW1Eb0JnSDI5RDFrYldRWHBBdGNOMk93NjF6aStJcnBU?=
 =?utf-8?B?UHVIYWJ5cWw0V0tiSWJzRnY5azV3akdwMmYyZ28zZnREbjBzQVhFblBqUDN4?=
 =?utf-8?B?NDdvOVp1S3dkUUU1TDNYdUpWdWZnU2NDM05QTHNROStmSnoxN3I3R1dnWW5y?=
 =?utf-8?B?aG9jQ05POUNWTUg2UXd5YkM1Q1lBUWtsY2dOS0NmMThXTEQ1ak4yMUh4NzA5?=
 =?utf-8?B?SGNoUmx6NCtHV2drcmpzTnE0d2Q3UHhBUmJTeFg1ckZ3NGY4TXJ3ZHJBdDQz?=
 =?utf-8?B?Vk9MUnAwNnBQWEVNRU1SYVVRbmd4VEFoUXMzOERUSkIzc3lsR2dBMDdKUUxH?=
 =?utf-8?B?TDViZFFkQXA5ay9ZVGZmZ0F6NGdJR1I3cmhxaGpCZFFKUzhNVzN4Vkt0ejIv?=
 =?utf-8?B?emVGRlpVWWhlczRuU001OTBldHdXU0xidWEvUUZKb29BNzVVSll5QnlqUUNJ?=
 =?utf-8?B?aEZ1aU1mNFc2ZWZQckVYVFRBQnBscFFHUEZWM0c3c1l0ditPSWV4bzFESDRY?=
 =?utf-8?B?N04rbExnTENxOUt3SXphamJwNzNnS0h1TGZjTS9VOVpVZ05XSEM3QW5nS3lm?=
 =?utf-8?B?ZnpSUFoxNzJ0djIwQ3d6cC9lOGY3cFB4ZW5CV3EvYUN0aUtTNlFXRDNHT0x6?=
 =?utf-8?B?LzI0ZVFMbVhIODdlbTdKRCt6dVk3OWg0bkRSZncxYnM4eWFOaUlJVVREYy80?=
 =?utf-8?B?cXVpV0tQSkg0UGgzb2FVZThmVU9YOFdLRHNqRE42Z1ptblFIaEc5dTZmZkNN?=
 =?utf-8?B?VERVRjNmd3c3ZW1XZUhiNUpyYTRURDh0cXNuandyOWJFdFZjOEpnU3ZkOEx6?=
 =?utf-8?B?enVJNUZUcDVXZ3l1bGZZMGVEWFo2b0VDcVF6REZGTUVpY2luckJSRFRFeEFR?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5216A021D6A1944FBF97CEE7B2D53B65@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 448d8d1b-1210-4061-e0f8-08db73785ebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2023 23:28:22.5487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JvjUBxrBKNbk4DfFDEfVyyKKHR1CNcXNLlJmjBfELHHg4nnlN8SP4Zhr+4vx6/rLRmOm9stuGKykNrMs3z8WNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6396
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

T24gVGh1LCAyMDIzLTA2LTIyIGF0IDE2OjE2IC0wNzAwLCBZYW1haGF0YSwgSXNha3Ugd3JvdGU6
DQo+IFRoZSB1cHBlciAzMiBiaXRzIG9mIGVycm9yIGNvZGUgYXJlIGRpc2NhcmRlZCBhdCBrdm1f
bW11X3BhZ2VfZmF1bHQoKQ0KPiBieSBsb3dlcl8zMl9iaXRzKCkuwqAgTm93IGl0J3MgcGFzc2Vk
IGRvd24gYXMgZnVsbCA2NCBiaXRzLg0KPiBCZWNhdXNlIG9ubHkgRk5BTUUocGFnZV9mYXVsdCkg
ZGVwZW5kcyBvbiBpdCwgbW92ZSBsb3dlcl8zMl9iaXRzKCkgaW50bw0KPiBGTkFNRShwYWdlX2Zh
dWx0KS4NCg0KSSBoYXZlbid0IGxvb2tlZCBpbnRvIHRoZSBjb2RlIHlldCwgYnV0IHRoZSBsYXN0
IHNlbnRlbmNlIGFyb3VuZA0KRk5BTUUocGFnZV9mYXVsdCkgZG9lc24ndCBtYWtlIGEgbG90IHNl
bnNlIElJVUM/DQoNCkZvciBpbnN0YW5jZSwgd2UgY2FuIGhhdmUgYSBzaGFkb3cgRVBUIHRhYmxl
IHdoZW4gRVBUIGlzIGVuYWJsZWQgaW4gTDAgYW5kDQpleHBvc2VkIHRvIEwxLiAgSWYgd2Ugd2Fu
dCB0byBwYXNzIDY0LWJpdCBlcnJvciBjb2RlIHRvIHRoZSBoYW5kbGVyLCBob3cgY2FuDQpGUkFN
RShwYWdlX2ZhdWx0KSgpIGRlcGVuZCBvbiB0aGUgbG93ZXIgMzItYml0IHZhbHVlPyANCg==
