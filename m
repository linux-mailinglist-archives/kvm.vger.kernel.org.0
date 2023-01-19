Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF30672D9D
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 01:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjASApd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 19:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjASApb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 19:45:31 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB07577C6;
        Wed, 18 Jan 2023 16:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674089129; x=1705625129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zP+noFssxdZZDahhEW4Z7Ttlq5RZ7DNnCnbP5+WH2rc=;
  b=XsnyBYQhlFuZM6W2rEJOyDirWZPGzmH4HO/tvszWOPXT8eeYOSDG/AXA
   TUOFGUkH4mvPb+nEVMzMfSiD6ZCTwkDDmJIWXzrW3wP3p5GRYcsVV6xV5
   STy0rXxaYeTfSHuk6RiwgmM+ol8BoXOnbkkUjDgELyVVRDzXfEcC9maV0
   1U2HN7mZ5xULBPDetwTVL7UsqTMOlzEQKB+doXizU0N2i4FoREXNIpYtr
   5kNAVQA6BGtxfmN1UsB156IIO81/qwKeRCx2KvUMuYsLUW6FAxtXs0yT7
   CSp4hnDZe0FYmT7CzQ+XHG2mZfeBnRYRpUdkPjmrPhKCe5YqcLjsN7IIG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="308710623"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="308710623"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 16:45:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="723300808"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="723300808"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jan 2023 16:45:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 16:45:14 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 16:45:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 16:45:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wziq47YHUss8vrytXuTwi2TuuXCZSZU8DCb0ALTR45/e1WoUJm8UNvsMITWZXTQx3C7urwrH+qrrsS44ng6sWpvTpJRrIV216/OA9bWLhXVQoI0U7aYfLIpytn9IaQ0IknCSkT58yvGiArrJmLR1uguna/Q+P49TqasA3OJLfhMiJ7ts6vkRAFgMpkwU6Y5Ayi8qdZOm+oVrcju90WHcxQ+gEexFhpzJzUUpvtSy0I3Q01o9MNFXk3Cwa+GFYhim9zH1G4uUil7IgYr/J8hdpUknM5GdtJVu1W2CvlmU4Srw9aet+r5o5mvl3+UlivobnlQneHAPBOgRhAfHOL1uzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zP+noFssxdZZDahhEW4Z7Ttlq5RZ7DNnCnbP5+WH2rc=;
 b=D0h66ddToZFkb2x9TnjBUgJgACWadIS6vUbRQd1Q2nhzmezIXwS43ZEkHhaSaXg0pW2MjXSvB/N7H4SFAnhT/mw1BWTzVwbSYe3qiHy4b0bQF6LH7a4StepeNbtpyUsd4OURAU+hA93kNtE1BStjKiQ3ambqhH5WO50CSVIcXCYqTQyqPJsGY5WatfHqGjSRQ4Kb7yFQ546BgKRtD/bmXXgJF49bl8GyWENY0WuuM2czSp9CeOnwWu8EQqfqtnvrXqifQclK4Lmcp2lpHYId+kGp/1Uuv1W43HsVc9CU5fN2CttYpzz+tW2S6lTHc4AGuo0JbjtnlZIKnSHXGFrmSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7385.namprd11.prod.outlook.com (2603:10b6:208:423::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 00:45:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 00:45:09 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Topic: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Index: AQHZJqT+Gmb2zZevo06P/V36G5cIjK6k8UOA
Date:   Thu, 19 Jan 2023 00:45:09 +0000
Message-ID: <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7385:EE_
x-ms-office365-filtering-correlation-id: ec4a23be-f486-4d2a-162e-08daf9b66ace
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I/uFfyWQ/Sn6ZqJrunniLxUhteRz/yjs9SKsPpM+S9eYtjHQl3kf/7pRQYJz6+X5kPxOfpoAUWsTtkysIt9kX1hnT+6iWI3KzUyfoU/3zFEq0SUACVCnf9OYI4NuTVIj/2X165Zs1B9LC6loRnj9kEzRs64OY3/2QK4wnhiulsWWSGFkKduAtv1FaIdgpHxAI6gbY4TcVzIz/JnvEFbayyYDZFKUmSJ9VBmvPRQyFLJ0bIru0LePLxczt7g18+oDukIbeH1QLe4KQi9TG7vD+LCQ2CpdOiYBv1Gas0aZW0rtDcC2AQKcQiBPnwohmw/qzkjk7OSvj/Lk2XUHffcCp9sbsfX1Q+2S6+a8WOOrq4rmEz/6r5AZQFiViJ+m8ZDyJlmfDy6WhDlP+pZv3JD9OHudBkw5x8u+p8ZtCWHA0r8md/2sfc59ORvCrnbmxvRaxpI9kCy2SQ7OKqdaZc68ogi+amvTiMWA7phGLssqV8p+9vfrUPYtMk0HA72JTahnY2SFxBdNb0HnrMROFQpxpOpLXJcttmR6if6T3y+Loa7Lbc9FYje5xgN9JDOgMhYLqLs6AOlwdj3JWQJy710t14t64QBVqDXjBiLzL2Y7kZPIElA0h8xHjwbb3lEDw1zaPGKIuXPI5dFgRdC6kbguAUjHuGEOHWv5idJ5Sv66J6u26EnzSDecMoXPtJL7ZBUwwUkJ9/9Vr4uFhvYoif5aqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199015)(66946007)(64756008)(6512007)(2616005)(66476007)(76116006)(26005)(41300700001)(4326008)(66446008)(8676002)(186003)(86362001)(91956017)(36756003)(66556008)(82960400001)(5660300002)(8936002)(54906003)(316002)(6636002)(6506007)(83380400001)(478600001)(38070700005)(2906002)(38100700002)(71200400001)(122000001)(110136005)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXBqdjcxbkJHSHNiNmNPenpGMVI1cjlaUzVTY1pBeWtYaXNOa0VJRWpxTWJn?=
 =?utf-8?B?UTljR2VZUHpZdEcvak53ZGZtZHRZWHBESVdiT3RLa0FEd0UrVUMzZUorMGl4?=
 =?utf-8?B?MXUyaUt6V01PNkpqV3pxR3VUT1hYMGRNdUdiR2FUY3ljZlE5aHBqYXJ1d28x?=
 =?utf-8?B?NHdjV1ZFdUZDL0w1UmpPdVFXNXlpN29RNmNCa0FqZzA4Z1Q3VDJPMGhCL1N5?=
 =?utf-8?B?VnU0ZXlML1YwTjZXWDZlZ2ZaR3ZsdmVkYXhNeEV0akVaeFd2WWdubHdGRkZq?=
 =?utf-8?B?V1FzTWV5Z2NsZzRhcE9FUGM2VlBkOXM1VUphNHd2cjJ1Vmd6WW9MekNxaHc1?=
 =?utf-8?B?MGkvYWw0UnNjdkl6U3liKzl0eFN6QzZVQi9iWHp1ZHBaQzhuN3VYSTVrdi9w?=
 =?utf-8?B?VzgzTUZqd1ArMWRFeXZ2K2JZa3RFOGNXSWdkdXFkaC93VytCam54UW9VQXhY?=
 =?utf-8?B?Z2FUM0hFY0IzWjBhaSs4YjZhKy9scktTRVdJczBSeWJPeDI3QVpYYkVsbDI3?=
 =?utf-8?B?SmNhR3VFNVJQRFp2TUNITldqL2xlY0dXb2JmM2VmVW8xcjI1MTcyMkRhYmpp?=
 =?utf-8?B?WklhZHAwVWUzWmw3Tld1QWlyb1UvMzhtNU52OU42bDRIS3I2N3JWTy92d2lu?=
 =?utf-8?B?a1BYWWVFWnJCQUNxcDJWOG4xdzVRZlkzTzNGQ3NYOHJJSkRGcHIwenlWSjY0?=
 =?utf-8?B?dFllN2tuVSs0VWhMdGovRDFkWjdMY1d3aVYrUWJWR0J1KzcxcFptWStBRDFE?=
 =?utf-8?B?R0FQZDJoYXNsZ05DbVZVbWJOUlJRNnZoWmlJa0tQZlJrK1V3V01wbGw5SGtk?=
 =?utf-8?B?SU92cmdXZVdUNUZPSWVxMkxDU1pRZjhXSmpxSWZ2WFNwTWJrZFVZQ05PeExT?=
 =?utf-8?B?aXR1aWk2T2dURVZPbDJnMDdKM1B6NWl1SlhFZGlUQlFodU11TnR2aU9vL0hU?=
 =?utf-8?B?ZEpsamdnalFZdXQxd1hmWXdaVkkrc01GYTE1dzEzQzhybWJaYzFFaE5LbENP?=
 =?utf-8?B?U0hqOTNreG9rclZtbVVtZ3FobHM5bUlsZjRHSjdxNndFaElnYkNpem9jRjA1?=
 =?utf-8?B?TzJKSzFJZitkbnAxMHptUUtiVzEwMHhma1dyVG1IdW1FYjVPUUJ4V0FPSHMx?=
 =?utf-8?B?TFBxZHR2VW5aZGZCMUgwYUQ2UHlsNFdXVkEzL3lyR1JlOTREYjhSQk84TUdW?=
 =?utf-8?B?OGR2a0Nac3pZci8rRHpQZFg5amlQWVc3WEd0TWdHejJSV3dRTTFvS0VhYWk0?=
 =?utf-8?B?UEp6UzdkSUE5MVpDMlhTYWtCOGlXR1lpakhjM0dEM2diUTRqVFhQNXNwbHdx?=
 =?utf-8?B?eDRCVkwwQTRGYmsxWDcvNE1tRGwyNDFjQUlWaGVLYVI3eVZyWjI2NUVJWDFN?=
 =?utf-8?B?MllBK0IrZU1rZlBhUVZ3ZGQyTW1nN2dnMVFMVE1QN202S3FzSVV1OHR1bzJB?=
 =?utf-8?B?aWhjZmR1bStqNHFRMjBwNG9uMVhkRENQeVFUY0RZWFliM1daZmNzZWxaUER0?=
 =?utf-8?B?a2J5aTFlanlnSm1IZUFNM1FNN3hycVRNbXE1bk1aQWhaVEVYbnp5U1NMMGhj?=
 =?utf-8?B?MXZHUjVnTzRhVEtFWG5ZcmwvdkNHb1gvMmlrRXNzcHhYcEppRk10MHg4bkgv?=
 =?utf-8?B?U04xUXdkTXpjOElEYS8xWFhVSFVVZnc2dWVBTDVsT1FiNDFndUM3Tnc5THpj?=
 =?utf-8?B?OWhwSXpjalVsOUxXcXZiNXhNcDJRK29pblBIaUxwcjhrRVhWOUpVNVZlbmxw?=
 =?utf-8?B?MVR6bVB3c09YVHpGd2xGOGlYdTY4cWxnSjJxVkh0NE1uaVNCOFNDRWhzcFB0?=
 =?utf-8?B?Zmh4czREc3lTUTNiV3NaS1E3c0EraS9kLzRFWHU0SFgxQ2hhNFUzUkN3NVRB?=
 =?utf-8?B?ZWFVVzhnTzRzai9mckZjZE5hZnNBMmZFc09CZWlsWklFNmpZSnQxVENrZVRV?=
 =?utf-8?B?SFRuR25TNVJvSmpXaDVydUZUWnZ6RFpiQ3ZnaVkvN3Q0SnRsTTY1MnkvWTl2?=
 =?utf-8?B?eGk2UDU5bkFpODBnSFQ2Qk9BRzcxZm1ybnNFVmk1YmQ1aGpDdnBHcGxiU0Vu?=
 =?utf-8?B?VHBORisrcCtVeUo3NnY4bndML0Nqa1cyMlRReTVIQXlCSUMwdVhDc0xZYlpY?=
 =?utf-8?B?bkNwVktIT21LY0tKeXFWRHRCOW9CSFhKc3JMbElpSDBFMmtZbkJralI5VXZD?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10BF9D15B6141F4DA596D5E73DB84BE2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4a23be-f486-4d2a-162e-08daf9b66ace
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 00:45:09.7118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DD6bcnfto+cXLhmwSwYOm/MOFiWSLOXH0s36JUOwAupS/ZHw+cTq5ZnQXZhhfqG72P3VrJjny8XAYIpXXQeBXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7385
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBUaGUgbmV4dCBzdGVwIG9mIFREWCBndWVzdCBjcmVhdGlvbiBpcyB0byBjcmVh
dGUgdmNwdS4gIEFsbG9jYXRlIFREWCB2Y3B1DQo+IHN0cnVjdHVyZXMsIHBhcnRpYWxseSBpbml0
aWFsaXplIGl0LiDCoA0KPiANCg0KV2h5IHBhcnRpYWxseSBpbml0aWFsaXplIGl0PyAgU2hvdWxk
bid0IGEgYmV0dGVyIHdheSBiZSBlaXRoZXI6IDEpIG5vdA0KaW5pdGlhbGl6ZSBhdCBhbGwsIG9y
OyAyKSBmdWxseSBpbml0aWFsaXplP8KgDQoNCkNhbiB5b3UgcHV0IG1vcmUgX3doeV8gaGVyZT8N
Cg0KDQo+IEFsbG9jYXRlIHBhZ2VzIG9mIFREWCB2Y3B1IGZvciB0aGUNCj4gVERYIG1vZHVsZS4g
IEFjdHVhbCBkb25hdGlvbiBURFggdmNwdSBwYWdlcyB0byB0aGUgVERYIG1vZHVsZSBpcyBub3Qg
ZG9uZQ0KPiB5ZXQuDQoNCkFsc28sIGNhbiB5b3UgZXhwbGFpbiBfd2h5XyBpdCBpcyBub3QgZG9u
ZSBoZXJlPw0KDQo+IA0KPiBJbiB0aGUgY2FzZSBvZiB0aGUgY29udmVudGlvbmFsIGNhc2UsIGNw
dWlkIGlzIGVtcHR5IGF0IHRoZSBpbml0aWFsaXphdGlvbi4NCj4gYW5kIGNwdWlkIGlzIGNvbmZp
Z3VyZWQgYWZ0ZXIgdGhlIHZjcHUgaW5pdGlhbGl6YXRpb24uICBCZWNhdXNlIFREWA0KPiBzdXBw
b3J0cyBvbmx5IFgyQVBJQyBtb2RlLCBjcHVpZCBpcyBmb3JjaWJseSBpbml0aWFsaXplZCB0byBz
dXBwb3J0IFgyQVBJQw0KPiBvbiB0aGUgdmNwdSBpbml0aWFsaXphdGlvbi4NCg0KRG9uJ3QgcXVp
dGUgdW5kZXJzdGFuZCBoZXJlLiAgQXMgeW91IHNhaWQgQ1BVSUQgZW50cmllcyBhcmUgY29uZmln
dXJlZCBsYXRlciBpbg0KS1ZNX1NFVF9DUFVJRDIsIHNvIHdoYXQncyB0aGUgcG9pbnQgb2YgaW5p
dGlhbGl6aW5nIENQVUlEIHRvIHN1cHBvcnQgeDJhcGljDQpoZXJlPw0KDQpBcmUgeW91IHN1Z2dl
c3RpbmcgS1ZNX1NFVF9DUFVJRDIgd2lsbCBiZSBzb21laG93IHJlamVjdGVkIGZvciBURFggZ3Vl
c3QsIG9yDQp0aGVyZSB3aWxsIGJlIHNwZWNpYWwgaGFuZGxpbmcgdG8gbWFrZSBzdXJlIHRoZSBD
UFVJRCBpbml0aWFsaXplZCBoZXJlIHdvbid0IGJlDQpvdmVyd3JpdHRlbiBsYXRlcj8NCg0KUGxl
YXNlIGV4cGxhaW4gY2xlYXJseSBoZXJlLg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZ
YW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4gQ2hhbmdlcyB2MTAg
LT4gdjExOg0KPiAtIE5VTEwgY2hlY2sgb2Yga3ZtYWxsb2NfYXJyYXkoKSBpbiB0ZHhfdmNwdV9y
ZXNldC4gTW92ZSBpdCB0bw0KPiAgIHRkeF92Y3B1X2NyZWF0ZSgpDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4g
IGFyY2gveDg2L2t2bS92bXgvbWFpbi5jICAgIHwgNDAgKysrKysrKysrKysrKysrKysrLS0NCj4g
IGFyY2gveDg2L2t2bS92bXgvdGR4LmMgICAgIHwgNzUgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gIGFyY2gveDg2L2t2bS92bXgveDg2X29wcy5oIHwgMTAgKysrKysN
Cj4gIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgIHwgIDIgKw0KPiAgNCBmaWxlcyBjaGFuZ2Vk
LCAxMjMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0vdm14L21haW4uYyBiL2FyY2gveDg2L2t2bS92bXgvbWFpbi5jDQo+IGluZGV4
IGRkZjA3NDJmMWY2Ny4uNTk4MTNjYTA1ZjM2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
dm14L21haW4uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiBAQCAtNjMsNiAr
NjMsMzggQEAgc3RhdGljIHZvaWQgdnRfdm1fZnJlZShzdHJ1Y3Qga3ZtICprdm0pDQo+ICAJCXRk
eF92bV9mcmVlKGt2bSk7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQgdnRfdmNwdV9wcmVjcmVh
dGUoc3RydWN0IGt2bSAqa3ZtKQ0KPiArew0KPiArCWlmIChpc190ZChrdm0pKQ0KPiArCQlyZXR1
cm4gMDsNCj4gKw0KPiArCXJldHVybiB2bXhfdmNwdV9wcmVjcmVhdGUoa3ZtKTsNCj4gK30NCj4g
Kw0KPiArc3RhdGljIGludCB2dF92Y3B1X2NyZWF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+
ICt7DQo+ICsJaWYgKGlzX3RkX3ZjcHUodmNwdSkpDQo+ICsJCXJldHVybiB0ZHhfdmNwdV9jcmVh
dGUodmNwdSk7DQo+ICsNCj4gKwlyZXR1cm4gdm14X3ZjcHVfY3JlYXRlKHZjcHUpOw0KPiArfQ0K
PiArDQo+ICtzdGF0aWMgdm9pZCB2dF92Y3B1X2ZyZWUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0K
PiArew0KPiArCWlmIChpc190ZF92Y3B1KHZjcHUpKQ0KPiArCQlyZXR1cm4gdGR4X3ZjcHVfZnJl
ZSh2Y3B1KTsNCj4gKw0KPiArCXJldHVybiB2bXhfdmNwdV9mcmVlKHZjcHUpOw0KPiArfQ0KPiAr
DQo+ICtzdGF0aWMgdm9pZCB2dF92Y3B1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9v
bCBpbml0X2V2ZW50KQ0KPiArew0KPiArCWlmIChpc190ZF92Y3B1KHZjcHUpKQ0KPiArCQlyZXR1
cm4gdGR4X3ZjcHVfcmVzZXQodmNwdSwgaW5pdF9ldmVudCk7DQo+ICsNCj4gKwlyZXR1cm4gdm14
X3ZjcHVfcmVzZXQodmNwdSwgaW5pdF9ldmVudCk7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbnQg
dnRfbWVtX2VuY19pb2N0bChzdHJ1Y3Qga3ZtICprdm0sIHZvaWQgX191c2VyICphcmdwKQ0KPiAg
ew0KPiAgCWlmICghaXNfdGQoa3ZtKSkNCj4gQEAgLTkwLDEwICsxMjIsMTAgQEAgc3RydWN0IGt2
bV94ODZfb3BzIHZ0X3g4Nl9vcHMgX19pbml0ZGF0YSA9IHsNCj4gIAkudm1fZGVzdHJveSA9IHZ0
X3ZtX2Rlc3Ryb3ksDQo+ICAJLnZtX2ZyZWUgPSB2dF92bV9mcmVlLA0KPiAgDQo+IC0JLnZjcHVf
cHJlY3JlYXRlID0gdm14X3ZjcHVfcHJlY3JlYXRlLA0KPiAtCS52Y3B1X2NyZWF0ZSA9IHZteF92
Y3B1X2NyZWF0ZSwNCj4gLQkudmNwdV9mcmVlID0gdm14X3ZjcHVfZnJlZSwNCj4gLQkudmNwdV9y
ZXNldCA9IHZteF92Y3B1X3Jlc2V0LA0KPiArCS52Y3B1X3ByZWNyZWF0ZSA9IHZ0X3ZjcHVfcHJl
Y3JlYXRlLA0KPiArCS52Y3B1X2NyZWF0ZSA9IHZ0X3ZjcHVfY3JlYXRlLA0KPiArCS52Y3B1X2Zy
ZWUgPSB2dF92Y3B1X2ZyZWUsDQo+ICsJLnZjcHVfcmVzZXQgPSB2dF92Y3B1X3Jlc2V0LA0KPiAg
DQo+ICAJLnByZXBhcmVfc3dpdGNoX3RvX2d1ZXN0ID0gdm14X3ByZXBhcmVfc3dpdGNoX3RvX2d1
ZXN0LA0KPiAgCS52Y3B1X2xvYWQgPSB2bXhfdmNwdV9sb2FkLA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggNTU3
YTYwOWM1MTQ3Li4wOTlmMDczN2E1YWEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgv
dGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBAQCAtMjgxLDYgKzI4MSw4
MSBAQCBpbnQgdGR4X3ZtX2luaXQoc3RydWN0IGt2bSAqa3ZtKQ0KPiAgCXJldHVybiAwOw0KPiAg
fQ0KPiAgDQo+ICtpbnQgdGR4X3ZjcHVfY3JlYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4g
K3sNCj4gKwlzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAqZTsNCj4gKw0KPiArCS8qDQo+ICsJICog
T24gY3B1IGNyZWF0aW9uLCBjcHVpZCBlbnRyeSBpcyBibGFuay4gIEZvcmNpYmx5IGVuYWJsZQ0K
PiArCSAqIFgyQVBJQyBmZWF0dXJlIHRvIGFsbG93IFgyQVBJQy4NCj4gKwkgKiBCZWNhdXNlIHZj
cHVfcmVzZXQoKSBjYW4ndCByZXR1cm4gZXJyb3IsIGFsbG9jYXRpb24gaXMgZG9uZSBoZXJlLg0K
PiArCSAqLw0KPiArCVdBUk5fT05fT05DRSh2Y3B1LT5hcmNoLmNwdWlkX2VudHJpZXMpOw0KPiAr
CVdBUk5fT05fT05DRSh2Y3B1LT5hcmNoLmNwdWlkX25lbnQpOw0KPiArCWUgPSBrdm1hbGxvY19h
cnJheSgxLCBzaXplb2YoKmUpLCBHRlBfS0VSTkVMX0FDQ09VTlQpOw0KDQpZb3UgZG9uJ3QgbmVl
ZCB0byB1c2Uga3ZtYWxsb2NfYXJyYXkoKSB3aGVuIG9ubHkgYWxsb2NhdGluZyBvbmUgZW50cnku
DQoNCj4gKwlpZiAoIWUpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArCSplICA9IChzdHJ1Y3Qg
a3ZtX2NwdWlkX2VudHJ5Mikgew0KPiArCQkuZnVuY3Rpb24gPSAxLAkvKiBGZWF0dXJlcyBmb3Ig
WDJBUElDICovDQo+ICsJCS5pbmRleCA9IDAsDQo+ICsJCS5lYXggPSAwLA0KPiArCQkuZWJ4ID0g
MCwNCj4gKwkJLmVjeCA9IDFVTEwgPDwgMjEsCS8qIFgyQVBJQyAqLw0KPiArCQkuZWR4ID0gMCwN
Cj4gKwl9Ow0KPiArCXZjcHUtPmFyY2guY3B1aWRfZW50cmllcyA9IGU7DQo+ICsJdmNwdS0+YXJj
aC5jcHVpZF9uZW50ID0gMTsNCg0KQXMgbWVudGlvbmVkIGFib3ZlLCB3aHkgZG9pbmcgaXQgaGVy
ZT8gV29uJ3QgYmUgdGhpcyBiZSBvdmVyd3JpdHRlbiBsYXRlciBpbg0KS1ZNX1NFVF9DUFVJRDI/
DQoNCj4gKw0KPiArCS8qIFREWCBvbmx5IHN1cHBvcnRzIHgyQVBJQywgd2hpY2ggcmVxdWlyZXMg
YW4gaW4ta2VybmVsIGxvY2FsIEFQSUMuICovDQo+ICsJaWYgKCF2Y3B1LT5hcmNoLmFwaWMpDQo+
ICsJCXJldHVybiAtRUlOVkFMOw0KDQpJZiB0aGlzIGlzIGhpdCwgd2hhdCBoYXBwZW5zIHRvIHRo
ZSBDUFVJRCBlbnRyeSBhbGxvY2F0ZWQgYWJvdmU/ICBJdCdzDQphYnNvbHV0ZWx5IG5vdCBjbGVh
ciBoZXJlIGluIHRoaXMgcGF0Y2guDQoNCj4gKw0KPiArCWZwc3RhdGVfc2V0X2NvbmZpZGVudGlh
bCgmdmNwdS0+YXJjaC5ndWVzdF9mcHUpOw0KPiArDQo+ICsJdmNwdS0+YXJjaC5lZmVyID0gRUZF
Ul9TQ0UgfCBFRkVSX0xNRSB8IEVGRVJfTE1BIHwgRUZFUl9OWDsNCj4gKw0KPiArCXZjcHUtPmFy
Y2guY3IwX2d1ZXN0X293bmVkX2JpdHMgPSAtMXVsOw0KPiArCXZjcHUtPmFyY2guY3I0X2d1ZXN0
X293bmVkX2JpdHMgPSAtMXVsOw0KPiArDQo+ICsJdmNwdS0+YXJjaC50c2Nfb2Zmc2V0ID0gdG9f
a3ZtX3RkeCh2Y3B1LT5rdm0pLT50c2Nfb2Zmc2V0Ow0KPiArCXZjcHUtPmFyY2gubDFfdHNjX29m
ZnNldCA9IHZjcHUtPmFyY2gudHNjX29mZnNldDsNCj4gKwl2Y3B1LT5hcmNoLmd1ZXN0X3N0YXRl
X3Byb3RlY3RlZCA9DQo+ICsJCSEodG9fa3ZtX3RkeCh2Y3B1LT5rdm0pLT5hdHRyaWJ1dGVzICYg
VERYX1REX0FUVFJJQlVURV9ERUJVRyk7DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0K
PiArdm9pZCB0ZHhfdmNwdV9mcmVlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gK3sNCj4gKwkv
KiBUaGlzIGlzIHN0dWIgZm9yIG5vdy4gIE1vcmUgbG9naWMgd2lsbCBjb21lLiAqLw0KPiArfQ0K
PiArDQo+ICt2b2lkIHRkeF92Y3B1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBp
bml0X2V2ZW50KQ0KPiArew0KPiArCXN0cnVjdCBtc3JfZGF0YSBhcGljX2Jhc2VfbXNyOw0KPiAr
DQo+ICsJLyogVERYIGRvZXNuJ3Qgc3VwcG9ydCBJTklUIGV2ZW50LiAqLw0KPiArCWlmIChXQVJO
X09OX09OQ0UoaW5pdF9ldmVudCkpDQo+ICsJCWdvdG8gdGRfYnVnZ2VkOw0KDQpTaG91bGQgd2Ug
dXNlIEtWTV9CVUdfT04oKT8NCg0KQWdhaW4sIGl0IGFwcGVhcnMgdGhpcyBkZXBlbmRzIG9uIGhv
dyBLVk0gaGFuZGxlcyBJTklULCB3aGljaCBpcyBkb25lIGluIGEgbGF0ZXINCnBhdGNoIGZhciB3
YXk6DQoNCltQQVRDSCB2MTEgMTAyLzExM10gS1ZNOiBURFg6IFNpbGVudGx5IGlnbm9yZSBJTklU
L1NJUEkNCg0KQW5kIHRoZXJlJ3Mgbm8gbWF0ZXJpYWwgZXhwbGFpbmluZyBob3cgaXQgaXMgaGFu
ZGxlZCBpbiBlaXRoZXIgY2hhbmdlbG9nIG9yDQpjb21tZW50LCBzbyB0byBtZSBpdCdzIG5vdCBy
ZXZpZXdhYmxlLg0KDQo+ICsNCj4gKwkvKiBURFggcnF1aXJlcyBYMkFQSUMuICovDQo+ICsJYXBp
Y19iYXNlX21zci5kYXRhID0gQVBJQ19ERUZBVUxUX1BIWVNfQkFTRSB8IExBUElDX01PREVfWDJB
UElDOw0KPiArCWlmIChrdm1fdmNwdV9pc19yZXNldF9ic3AodmNwdSkpDQo+ICsJCWFwaWNfYmFz
ZV9tc3IuZGF0YSB8PSBNU1JfSUEzMl9BUElDQkFTRV9CU1A7DQo+ICsJYXBpY19iYXNlX21zci5o
b3N0X2luaXRpYXRlZCA9IHRydWU7DQo+ICsJaWYgKFdBUk5fT05fT05DRShrdm1fc2V0X2FwaWNf
YmFzZSh2Y3B1LCAmYXBpY19iYXNlX21zcikpKQ0KPiArCQlnb3RvIHRkX2J1Z2dlZDsNCg0KSSB0
aGluayB3ZSBoYXZlIEtWTV9CVUdfT04oKT8NCg0KVERYIHJlcXVpcmVzIGEgbG90IG1vcmUgc3Rh
ZmYgdGhlbiBqdXN0IHgyYXBpYywgd2h5IG9ubHkgeDJhcGljIGlzIGRvbmUgaGVyZSwNCnBhcnRp
Y3VsYXJseSBpbiBfdGhpc18gcGF0Y2g/DQoNCj4gKw0KPiArCS8qDQo+ICsJICogRG9uJ3QgdXBk
YXRlIG1wX3N0YXRlIHRvIHJ1bm5hYmxlIGJlY2F1c2UgbW9yZSBpbml0aWFsaXphdGlvbg0KPiAr
CSAqIGlzIG5lZWRlZCBieSBURFhfVkNQVV9JTklULg0KPiArCSAqLw0KPiArCXJldHVybjsNCj4g
Kw0KPiArdGRfYnVnZ2VkOg0KPiArCXZjcHUtPmt2bS0+dm1fYnVnZ2VkID0gdHJ1ZTsNCj4gK30N
Cj4gKw0KPiANCg0KW3NuaXBdDQo=
