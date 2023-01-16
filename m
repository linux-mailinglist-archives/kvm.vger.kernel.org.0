Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F4C66B691
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 05:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjAPEUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 23:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjAPET7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 23:19:59 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337D77283;
        Sun, 15 Jan 2023 20:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673842796; x=1705378796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bvG3cOWSVsjRgIBVkXhCnwLZRrAntv7CuYrFvHHX4SI=;
  b=AJg13KLkSiSRJj0Cw+GNkD0cFqdq7ZOlKou8Jjj1cOaNg75KtNA2uGA9
   6jmMB18riLMF64jVfXYVHkCLdvAl0p868qT2A6JdqNLEAFAhhxGWMVPe7
   T/e5Nm+UZqpQORPeX4CAk6MMREJGWcBbER/d07RfjHgoWemzUiaIFs3Np
   tjyy4bZ593jJtuk9J0d8jMnvY1zEQlHhoQlPdnt7mGro22m9pNYTxjveK
   EJjVNHUFIlIGbylbLMBK7VVnmPUMIOulzgyFhNVYQVsBNN7DHK5cKmgcY
   Mj6jDFFPKHN5+BRiYrbRL0uFYOSAonOp4sO6kqoIbAG58Dat4zjhXzhjo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="324438406"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="324438406"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2023 20:19:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="722163874"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="722163874"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2023 20:19:55 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 15 Jan 2023 20:19:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 15 Jan 2023 20:19:55 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 15 Jan 2023 20:19:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWp2kP7eUxiEpQREh5qtnlVfjf+c6t1q7CEu+p1zKWa89Ua9dewgBdkBS7BbmqedlVCbk2aoCGcmyig/HMURu6Aer/ka7vTj/3zPL8yC0wVe0+Ly82ktL83MusaFaLDdShknh3C8Kux2U7vEds34Pt/mS0mignPb/fy5lmjN3rUFg7LMmorGPvS1GIcYEDiYTGBiORoSYNzPFUki6d3cN7xywFCkzepf3ngHPeJj5Qmta5SHV1RQjmTgn2ZRgK1z0CbrbLGQi/8l/r09KLOnrGtj1wyrPruxZ/JWOPCJ+MmG90xyDEvmpy3PpLx64RAEI8hSUmsObwia0O8uYf2g4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvG3cOWSVsjRgIBVkXhCnwLZRrAntv7CuYrFvHHX4SI=;
 b=UT5tj9sV1b1tchP62mi6GLxecuSwQkbRwpVDQgEB2MmsgZreEhZhD2ZzNG5PsPg/YlQOdSdEe0H1DMNfSf1h4O77E4k/3eKggjb2Odyk9BmGeH7oj/5TWaGoU2RF1M3OoqrbxNpoTUYwdq6tMIwa+xyQCOQoCQt7ZUA5M3FxXo89TOV8r1lHWtmjpfJtAyCG7vWxkFRt7vWt2OmKk33gqmvV6JkZIt06xysAeVwNDZhCq8UoPl5Be5nouXJeJEJyy7AEj8LBP2AYS4ydKh15/UB9hfNwn5cUCs00WKHFvOtSrHA389wo792oSgdXj5A6Tm6Nv8o9o8Dk9pe/0APV9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5479.namprd11.prod.outlook.com (2603:10b6:208:317::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 04:19:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 04:19:47 +0000
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
Subject: Re: [PATCH v11 014/113] x86/virt/tdx: Add a helper function to return
 system wide info about TDX module
Thread-Topic: [PATCH v11 014/113] x86/virt/tdx: Add a helper function to
 return system wide info about TDX module
Thread-Index: AQHZJqTvtDSznMMe2E2LiDuqXtiyaq6gdjsA
Date:   Mon, 16 Jan 2023 04:19:47 +0000
Message-ID: <4db01adf3023ae14084495d15949a70b39d80e58.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <3c7b93a184e36729aeaad2df2b5f450fb564ee92.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <3c7b93a184e36729aeaad2df2b5f450fb564ee92.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5479:EE_
x-ms-office365-filtering-correlation-id: 1b4a6552-9b9c-4b2b-4296-08daf778e715
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KFIXt/RbBW1+9KZ/l0rUynaKTnjSN7ZLQO5zRNgHKo+Rt0gHa44l/I37aDiHqIUnhXFN2EqjGl5+Tt7jxicbvSLDMmpE4E7p57vmsG55qAK8qYphsiYElHU52/v5FVSn1N/NX/nbCiUsQ4o/gHGFQRLNxaA8JvZ51IFMFi9cUe69Y49juSSOzN4wsK/AWHVN559/Oa2jkduX8J8A9KsXohRv9/qLhgIadIkHFrRmPocoyIWlYnOp61iHCsElhsE+PZSm0HozwNrJ9P6MWVx0mZUy8QweuHchktC4QKaL9wXY+ReAJ4t0mXpC4FqShyrqIsP3byV06616yVOaH9xgheXPwh0X/imGfFlVn9bWi3SAhdH35Hy+57t/N/n81iJVbhdyFjlWtbmg8xIJQiuJNHgqOi+DKAAP1RTej2FXYmaO2chMhEBNho3ic0XReoUi1xuOpcHTk+JaZwK+uV/pM1TNuR6+gM4R+qNp8HLd6j3En9LwhBa/kYbRFzQcbwQ5Cs0/h57kAraGL/o0HoPvjTAPgQhN501e/kUKXGMZ9v3oC8LyheBHxAs6U8FSAVLq+0hrV0Z8fNDmyA6PJPar7TcGc8PoAT6/eSReBhH0/xJs1nNTuD7ar07wyuzYx901ri++oqHs/jT397geQbyElNKDS6yx6y8PfJdBTGMBYc+/K7fY+OSFywG1gZMXqpLl+EIAH0u+Nsx6RM8AlScL5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199015)(2906002)(6636002)(54906003)(110136005)(2616005)(66476007)(6512007)(186003)(71200400001)(26005)(82960400001)(6486002)(38100700002)(122000001)(316002)(8676002)(478600001)(36756003)(38070700005)(66556008)(66446008)(91956017)(64756008)(4326008)(76116006)(5660300002)(83380400001)(41300700001)(86362001)(66946007)(8936002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXRma2E0WVVCS0sxdlUzQW9KWTcwV3RXYWl4QVppbmRKcmZIOWlYdlk4WXN5?=
 =?utf-8?B?SzQ0Z3NaRVZpUTlIcklGc0ZYTVN2NkNtYndCcG04VnRGbTZzTEhzdm05Smp3?=
 =?utf-8?B?TVhpdldlVWhqV2kwSHUwdjJRNVhHd3pJV0tYSE9sazM1amthQ0J3STlCamIx?=
 =?utf-8?B?U0pUdlVvazUxRG5LZEg3WmtaSFY3UVoybHZScHJiTEw0aHlxdDk0eTVWaFBa?=
 =?utf-8?B?aURwclkzazczVnRqV0N0bFJUWlhrbTNxRnlteHBGbnlrczVLd29KWnVFNVd4?=
 =?utf-8?B?TFh4UnBxbnl1blZ3eENQMTllSkZFWi9sUTE2OW12Ull6T1lNRzFLME1TRTdM?=
 =?utf-8?B?cUxPNFYvS2xEeEhZaXVLSDZ2Z2o4eHFzL3RYT0pKazhzRTh4c0xqWmx2eGRP?=
 =?utf-8?B?dmMyY3dvUmpweGFiUkN0N1NlOUk3eEM1bWRjYlVlY1psSEhyQ01tSE9EUzZP?=
 =?utf-8?B?VGRhdFNsTG40cXowczR5QkZEdjhhMUFQK1o2WS9iVU5NclBXQ2NLUzErVmZa?=
 =?utf-8?B?Q3h4cUVLVzA3SnIvNXU2WC9GZGJaOFl2bkJ3eWNZZ0dUNlpPTjcxVHV3WnJX?=
 =?utf-8?B?ejVaeEpxVzlSUWJoSWNGYUROdkpiMjRKSTNOaVVnSnJlajNjdmhPckhPSlhl?=
 =?utf-8?B?bFJFRjlvRVBOUGYvb1BGQ1I0bEwrTzFHNWhCbW9zUUo3dHlDaXBJdVFXeCtu?=
 =?utf-8?B?THdmUXJKMzhEejlGY08xVkhrcDk0MVNkamI5cFZ6RkZYRFBGS1NOTnBxL3ha?=
 =?utf-8?B?aldlQTZCcTVIY0VqS2pSaXE5MmI0UXh0N3o3ZkVjRC9UTkxQbUtXRHZMZ041?=
 =?utf-8?B?aGQxWG1hNFZxakFia3Nlc1NiZnF1dmxlVDI3aWpyaWR5TFJOOXJzZ1dTSGNV?=
 =?utf-8?B?NG1Rc1dqR2lhVDVWSUNmdEw5MjZjN044N0M3RHpTdFJxVzJINUtxdk1sbHYy?=
 =?utf-8?B?WVdGNmZpeXROT0NBZncvN1puY1Ntcm9IV25oeU9NOVE2bFZuUWJURk5YS2hy?=
 =?utf-8?B?MG95T3BIenpodjhsL1NkbHczNGdTUUE1TFVWQ2xyUGU4eEZhODA5NHRPbTJB?=
 =?utf-8?B?Zm1NZ1hnZ2ZBZ3FqMlhPcXNqRXZLUHp4eW13MTJ1Tjk3VmZzeENnKzBKbEdr?=
 =?utf-8?B?VjFJRVVEWFRIRjFHWFB4cjJXdnZ1b3VuOEFpTElYRHlIZGkrT3lZTXZyNHVQ?=
 =?utf-8?B?dVIvdE9ReGlYNnpNVDlrU0RnV2s3OGRvOGFTeW9jMUV4ai84R0dlSW5WSTlu?=
 =?utf-8?B?bXZVM1ZkOTN0c21FNzhqYWNZMXByeHNhbWhnenAyTFBFeGcyOVpzRkUyS3FH?=
 =?utf-8?B?WjNIWkVMeEVFYzgvMnRjZzNGNStJRW4vTkhXRGh3Zmtpa01kQWxBOUtBWVov?=
 =?utf-8?B?V0lERE1pL0UzbldrQ05jYm9nNmNNN3NPdkhSZUIxd0JpOU5MTWdvcG9Jb255?=
 =?utf-8?B?ZDVPSENVdDBXQWdkK1V4blNyN1c2dU1rRTYwUjJLcU9wdlFxdTlkZG5KMlJp?=
 =?utf-8?B?clNxTzlnOS9Qd1J5TDFibG9tcXR0SjEzS2p2bVdGTE8yNUxwTFF0VzZKc01y?=
 =?utf-8?B?dkd0cHJqOG5Pd240TmI2L2dzd2VLVDQ5SUh3VDJpUFhXeWRiOHZiUi9TVzZv?=
 =?utf-8?B?L2krZHFFOXphMWVrV0w0VnRMSk9MVGdyNTlNNU1aL01jdVJaQ2k1RWtRV1VQ?=
 =?utf-8?B?dmNpT0FHZ3M0RkRLQ25BYkp1UjhQRlVjRGdhcWI2R3o1M2RBZGJrUDZkM0VP?=
 =?utf-8?B?cWsyRjlpMEFkTU95NjRZOGVnQ3l1ckxtRUFwanBPM0x5cmViUzNzaGhZVHRZ?=
 =?utf-8?B?VDNKSENHMDB0UFVwYmF5bzJiMTVzeFhWeXJKd2dJMDNadFh6eE5uSjh0TDBY?=
 =?utf-8?B?VVgzdHEzeGVFZVd1WUJoYk5qd3VOeWlTRG55UEpnRWd4OUk3TTBGWWFFeXg2?=
 =?utf-8?B?dnRUVytXZUhLUUFHcFloc282NnBDNE5yUEhDWFFxbkM1UjJuOVZyM2lXNEZC?=
 =?utf-8?B?Yy9pTWxhOG9YSUt0Y2gzdjJRa3Vic0VhckZIcnl5cy9DcDQwcnp6NElXekln?=
 =?utf-8?B?VWhvekN1bk1CSm1SVEVYakZRaUk5MU1VaFF3bk5mMStHRVhrMFdOYmJ1SFAw?=
 =?utf-8?B?MkhXM3F0TlZnZHM5YytFSnIrMFFYdDNHYnJMVDZML2VWcnA1a3V4WFh2NnM5?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99104610163A0642B92A73B9078313A1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4a6552-9b9c-4b2b-4296-08daf778e715
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 04:19:47.1100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AD1GY3NpNuyDXE5m5q7Z6IVD8MLbfz3FT9NQ8RZ10BIParv1O9RrpfqoTFkydhKUdyLBG6jYCzJan2aF5JcEyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5479
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggS1ZNIG5lZWRzIHN5c3RlbS13aWRlIGluZm9ybWF0aW9uIGFib3V0IHRo
ZSBURFggbW9kdWxlLCBzdHJ1Y3QNCj4gdGRzeXNpbmZvX3N0cnVjdC4gIEFkZCBhIGhlbHBlciBm
dW5jdGlvbiB0ZHhfZ2V0X3N5c2luZm8oKSB0byByZXR1cm4gaXQNCj4gaW5zdGVhZCBvZiBLVk0g
Z2V0dGluZyBpdCB3aXRoIHZhcmlvdXMgZXJyb3IgY2hlY2tzLiAgTWFrZSBLVk0gY2FsbCB0aGUN
Cj4gZnVuY3Rpb24gYW5kIHN0YXNoIHRoZSBpbmZvLiAgTW92ZSBvdXQgdGhlIHN0cnVjdCBkZWZp
bml0aW9uIGFib3V0IGl0IHRvDQo+IGNvbW1vbiBwbGFjZSBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90
ZHguaC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0
YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggIHwgNTQg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgYXJjaC94ODYva3ZtL3Zt
eC90ZHguYyAgICAgIHwgNDkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ICBh
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCAyMSArKysrKysrKysrKystLS0NCj4gIGFyY2gv
eDg2L3ZpcnQvdm14L3RkeC90ZHguaCB8IDUxIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDExOSBpbnNlcnRpb25zKCspLCA1NiBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+IGluZGV4IGVkOWNmNjFmZjhiNC4uMmNhNmU4Y2Ux
ZTQzIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiArKysgYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBAQCAtMTA1LDYgKzEwNSw1OCBAQCBzdGF0aWMg
aW5saW5lIGxvbmcgdGR4X2t2bV9oeXBlcmNhbGwodW5zaWduZWQgaW50IG5yLCB1bnNpZ25lZCBs
b25nIHAxLA0KPiAgI2VuZGlmIC8qIENPTkZJR19JTlRFTF9URFhfR1VFU1QgJiYgQ09ORklHX0tW
TV9HVUVTVCAqLw0KPiAgDQo+ICAjaWZkZWYgQ09ORklHX0lOVEVMX1REWF9IT1NUDQo+ICtzdHJ1
Y3QgdGR4X2NwdWlkX2NvbmZpZyB7DQo+ICsJdTMyCWxlYWY7DQo+ICsJdTMyCXN1Yl9sZWFmOw0K
PiArCXUzMgllYXg7DQo+ICsJdTMyCWVieDsNCj4gKwl1MzIJZWN4Ow0KPiArCXUzMgllZHg7DQo+
ICt9IF9fcGFja2VkOw0KPiArDQo+ICsjZGVmaW5lIFREU1lTSU5GT19TVFJVQ1RfU0laRQkJMTAy
NA0KPiArI2RlZmluZSBURFNZU0lORk9fU1RSVUNUX0FMSUdOTUVOVAkxMDI0DQo+ICsNCj4gKy8q
DQo+ICsgKiBUaGUgc2l6ZSBvZiB0aGlzIHN0cnVjdHVyZSBpdHNlbGYgaXMgZmxleGlibGUuICBU
aGUgYWN0dWFsIHN0cnVjdHVyZQ0KPiArICogcGFzc2VkIHRvIFRESC5TWVMuSU5GTyBtdXN0IGJl
IHBhZGRlZCB0byBURFNZU0lORk9fU1RSVUNUX1NJWkUgYW5kIGJlDQo+ICsgKiBhbGlnbmVkIHRv
IFREU1lTSU5GT19TVFJVQ1RfQUxJR05NRU5UIHVzaW5nIERFQ0xBUkVfUEFEREVEX1NUUlVDVCgp
Lg0KPiArICovDQo+ICtzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCB7DQo+ICsJLyogVERYLVNFQU0g
TW9kdWxlIEluZm8gKi8NCj4gKwl1MzIJYXR0cmlidXRlczsNCj4gKwl1MzIJdmVuZG9yX2lkOw0K
PiArCXUzMglidWlsZF9kYXRlOw0KPiArCXUxNglidWlsZF9udW07DQo+ICsJdTE2CW1pbm9yX3Zl
cnNpb247DQo+ICsJdTE2CW1ham9yX3ZlcnNpb247DQo+ICsJdTgJcmVzZXJ2ZWQwWzE0XTsNCj4g
KwkvKiBNZW1vcnkgSW5mbyAqLw0KPiArCXUxNgltYXhfdGRtcnM7DQo+ICsJdTE2CW1heF9yZXNl
cnZlZF9wZXJfdGRtcjsNCj4gKwl1MTYJcGFtdF9lbnRyeV9zaXplOw0KPiArCXU4CXJlc2VydmVk
MVsxMF07DQo+ICsJLyogQ29udHJvbCBTdHJ1Y3QgSW5mbyAqLw0KPiArCXUxNgl0ZGNzX2Jhc2Vf
c2l6ZTsNCj4gKwl1OAlyZXNlcnZlZDJbMl07DQo+ICsJdTE2CXRkdnBzX2Jhc2Vfc2l6ZTsNCj4g
Kwl1OAl0ZHZwc194ZmFtX2RlcGVuZGVudF9zaXplOw0KPiArCXU4CXJlc2VydmVkM1s5XTsNCj4g
KwkvKiBURCBDYXBhYmlsaXRpZXMgKi8NCj4gKwl1NjQJYXR0cmlidXRlc19maXhlZDA7DQo+ICsJ
dTY0CWF0dHJpYnV0ZXNfZml4ZWQxOw0KPiArCXU2NAl4ZmFtX2ZpeGVkMDsNCj4gKwl1NjQJeGZh
bV9maXhlZDE7DQo+ICsJdTgJcmVzZXJ2ZWQ0WzMyXTsNCj4gKwl1MzIJbnVtX2NwdWlkX2NvbmZp
ZzsNCj4gKwkvKg0KPiArCSAqIFRoZSBhY3R1YWwgbnVtYmVyIG9mIENQVUlEX0NPTkZJRyBkZXBl
bmRzIG9uIGFib3ZlDQo+ICsJICogJ251bV9jcHVpZF9jb25maWcnLg0KPiArCSAqLw0KPiArCURF
Q0xBUkVfRkxFWF9BUlJBWShzdHJ1Y3QgdGR4X2NwdWlkX2NvbmZpZywgY3B1aWRfY29uZmlncyk7
DQo+ICt9IF9fcGFja2VkOw0KPiArDQo+ICtjb25zdCBzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCAq
dGR4X2dldF9zeXNpbmZvKHZvaWQpOw0KPiAgYm9vbCBwbGF0Zm9ybV90ZHhfZW5hYmxlZCh2b2lk
KTsNCj4gIGludCB0ZHhfZW5hYmxlKHZvaWQpOw0KPiAgLyoNCj4gQEAgLTEyMCw2ICsxNzIsOCBA
QCB2b2lkIHRkeF9rZXlpZF9mcmVlKGludCBrZXlpZCk7DQo+ICB1NjQgX19zZWFtY2FsbCh1NjQg
b3AsIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0IHI5LA0KPiAgCSAgICAgICBzdHJ1Y3Qg
dGR4X21vZHVsZV9vdXRwdXQgKm91dCk7DQo+ICAjZWxzZQkvKiAhQ09ORklHX0lOVEVMX1REWF9I
T1NUICovDQo+ICtzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdDsNCj4gK3N0YXRpYyBpbmxpbmUgY29u
c3Qgc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QgKnRkeF9nZXRfc3lzaW5mbyh2b2lkKSB7IHJldHVy
biBOVUxMOyB9DQo+ICBzdGF0aWMgaW5saW5lIGJvb2wgcGxhdGZvcm1fdGR4X2VuYWJsZWQodm9p
ZCkgeyByZXR1cm4gZmFsc2U7IH0NCj4gIHN0YXRpYyBpbmxpbmUgaW50IHRkeF9lbmFibGUodm9p
ZCkgIHsgcmV0dXJuIC1FSU5WQUw7IH0NCj4gIHN0YXRpYyBpbmxpbmUgaW50IHRkeF9rZXlpZF9h
bGxvYyh2b2lkKSB7IHJldHVybiAtRU9QTk9UU1VQUDsgfQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggNmM3ZDll
YzUzMDQ2Li4yYWRmNTU1MWFiMjYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4
LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBAQCAtMTEsOSArMTEsMzQgQEAN
Cj4gICN1bmRlZiBwcl9mbXQNCj4gICNkZWZpbmUgcHJfZm10KGZtdCkgS0JVSUxEX01PRE5BTUUg
IjogIiBmbXQNCj4gIA0KPiArI2RlZmluZSBURFhfTUFYX05SX0NQVUlEX0NPTkZJR1MJCQkJCVwN
Cj4gKwkoKFREU1lTSU5GT19TVFJVQ1RfU0laRSAtCQkJCQlcDQo+ICsJCW9mZnNldG9mKHN0cnVj
dCB0ZHN5c2luZm9fc3RydWN0LCBjcHVpZF9jb25maWdzKSkJXA0KPiArCQkvIHNpemVvZihzdHJ1
Y3QgdGR4X2NwdWlkX2NvbmZpZykpDQo+ICsNCj4gK3N0cnVjdCB0ZHhfY2FwYWJpbGl0aWVzIHsN
Cj4gKwl1OCB0ZGNzX25yX3BhZ2VzOw0KPiArCXU4IHRkdnB4X25yX3BhZ2VzOw0KPiArDQo+ICsJ
dTY0IGF0dHJzX2ZpeGVkMDsNCj4gKwl1NjQgYXR0cnNfZml4ZWQxOw0KPiArCXU2NCB4ZmFtX2Zp
eGVkMDsNCj4gKwl1NjQgeGZhbV9maXhlZDE7DQo+ICsNCj4gKwl1MzIgbnJfY3B1aWRfY29uZmln
czsNCj4gKwlzdHJ1Y3QgdGR4X2NwdWlkX2NvbmZpZyBjcHVpZF9jb25maWdzW1REWF9NQVhfTlJf
Q1BVSURfQ09ORklHU107DQo+ICt9Ow0KPiArDQo+ICsvKiBDYXBhYmlsaXRpZXMgb2YgS1ZNICsg
dGhlIFREWCBtb2R1bGUuICovDQo+ICtzdGF0aWMgc3RydWN0IHRkeF9jYXBhYmlsaXRpZXMgdGR4
X2NhcHM7DQo+ICsNCj4gIHN0YXRpYyBpbnQgX19pbml0IHRkeF9tb2R1bGVfc2V0dXAodm9pZCkN
Cj4gIHsNCj4gLQlpbnQgcmV0Ow0KPiArCWNvbnN0IHN0cnVjdCB0ZHN5c2luZm9fc3RydWN0ICp0
ZHN5c2luZm87DQo+ICsJaW50IHJldCA9IDA7DQo+ICsNCj4gKwlCVUlMRF9CVUdfT04oc2l6ZW9m
KCp0ZHN5c2luZm8pID4gVERTWVNJTkZPX1NUUlVDVF9TSVpFKTsNCj4gKwlCVUlMRF9CVUdfT04o
VERYX01BWF9OUl9DUFVJRF9DT05GSUdTICE9IDM3KTsNCj4gIA0KPiAgCXJldCA9IHRkeF9lbmFi
bGUoKTsNCj4gIAlpZiAocmV0KSB7DQo+IEBAIC0yMSw2ICs0NiwyOCBAQCBzdGF0aWMgaW50IF9f
aW5pdCB0ZHhfbW9kdWxlX3NldHVwKHZvaWQpDQo+ICAJCXJldHVybiByZXQ7DQo+ICAJfQ0KPiAg
DQo+ICsJdGRzeXNpbmZvID0gdGR4X2dldF9zeXNpbmZvKCk7DQo+ICsJaWYgKHRkc3lzaW5mby0+
bnVtX2NwdWlkX2NvbmZpZyA+IFREWF9NQVhfTlJfQ1BVSURfQ09ORklHUykNCj4gKwkJcmV0dXJu
IC1FSU87DQoNClRoaXMgY2hlY2sgYmFzaWNhbGx5IG1lYW5zIFREWCBtb2R1bGUgaXMgYnVnZ3kg
KG9yIGtlcm5lbCBoYXMgYnVnKS4gIERvIHdlDQpyZWFsbHkgbmVlZCB0aGlzIGNoZWNrPyAgSXMg
VERYIG1vZHVsZSB0aGF0IGJ1Z2d5Pw0KDQpJTUhPIHlvdSBkb24ndCBuZWVkIHRoaXMgb25lLCBv
ciB1c2UgV0FSTigpIGlmIHlvdSB3YW50IHRvIGNhdGNoIGtlcm5lbCBidWc/DQoNCj4gKw0KPiAr
CXRkeF9jYXBzID0gKHN0cnVjdCB0ZHhfY2FwYWJpbGl0aWVzKSB7DQo+ICsJCS50ZGNzX25yX3Bh
Z2VzID0gdGRzeXNpbmZvLT50ZGNzX2Jhc2Vfc2l6ZSAvIFBBR0VfU0laRSwNCj4gKwkJLyoNCj4g
KwkJICogVERWUFMgPSBURFZQUig0SyBwYWdlKSArIFREVlBYKG11bHRpcGxlIDRLIHBhZ2VzKS4N
Cj4gKwkJICogLTEgZm9yIFREVlBSLg0KPiArCQkgKi8NCj4gKwkJLnRkdnB4X25yX3BhZ2VzID0g
dGRzeXNpbmZvLT50ZHZwc19iYXNlX3NpemUgLyBQQUdFX1NJWkUgLSAxLA0KPiArCQkuYXR0cnNf
Zml4ZWQwID0gdGRzeXNpbmZvLT5hdHRyaWJ1dGVzX2ZpeGVkMCwNCj4gKwkJLmF0dHJzX2ZpeGVk
MSA9IHRkc3lzaW5mby0+YXR0cmlidXRlc19maXhlZDEsDQo+ICsJCS54ZmFtX2ZpeGVkMCA9CXRk
c3lzaW5mby0+eGZhbV9maXhlZDAsDQo+ICsJCS54ZmFtX2ZpeGVkMSA9IHRkc3lzaW5mby0+eGZh
bV9maXhlZDEsDQo+ICsJCS5ucl9jcHVpZF9jb25maWdzID0gdGRzeXNpbmZvLT5udW1fY3B1aWRf
Y29uZmlnLA0KPiArCX07DQo+ICsJaWYgKCFtZW1jcHkodGR4X2NhcHMuY3B1aWRfY29uZmlncywg
dGRzeXNpbmZvLT5jcHVpZF9jb25maWdzLA0KPiArCQkJdGRzeXNpbmZvLT5udW1fY3B1aWRfY29u
ZmlnICoNCj4gKwkJCXNpemVvZihzdHJ1Y3QgdGR4X2NwdWlkX2NvbmZpZykpKQ0KPiArCQlyZXR1
cm4gLUVJTzsNCg0KV2h5IGludHJvZHVjaW5nICdzdHJ1Y3QgdGR4X2NhcGFiaWxpdGllcycgYW5k
IGFib3ZlIGNvZGUgaGVyZSBpbiB0aGlzIHBhdGNoPw0KDQpJdCdzIGVudGlyZWx5IG5vdCBjbGVh
ciB3aHkgdGhlIG5ldyBzdHJ1Y3R1cmUgaXMgbmVlZGVkIC0tIG5vdGhpbmcgbWVudGlvbmVkIGlu
DQpjaGFuZ2Vsb2csIG5vciB0aGVyZSdzIGFueSBjb21tZW50LiAgUGxlYXNlIGV4cGxhaW4gaW4g
dGhlIGNoYW5nZWxvZyBvciBtb3ZlDQp0aGlzIGNodW5rIHRvIHdoZXJlIGl0IGlzIG5lZWRlZC4N
Cg0KVGVjaG5pY2FsIHNpZGUsIGlzICdzdHJ1Y3QgdGR4X2NhcGFiaWxpdGllcycgcmVhbGx5IG5l
ZWRlZD8gT3IgaXMgaXQganVzdCBmb3INCmNvbnZlbmllbmNlPw0KDQpbc25pcF0NCg0K
