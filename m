Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E86F5A8B50
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 04:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiIACR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 22:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiIACRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 22:17:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE28ED009
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 19:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661998640; x=1693534640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QtOR5TXzqe56yY9Lm8gGn5AJxn5NWlbiawt0yAtA+mo=;
  b=SjRtABXc7LVeNINzpW1qHZgcS1OE9GHSy20ICMbA2i430MepueV2hmKu
   18dHdAi4YKwKB8hPm443TQTdDDD1QchUsGglIN6SMUDPf0VUv+Jj9Wdwc
   ghNhSK5AkJAvrNTpLeqMriQRJwLfQaM5Hs9kSQWv2YFF3JZYCS3HNvTnl
   BYlpeWLhfUMvXoDzxluCmC2shrFL3/MR65a1Tvuw3oCy19OClWbJOSbMz
   H2JflQ1V/VXCHMPflap/XnOMWufcVPGwb+NGUZELK40tW/VF95Ss0v1IG
   gfz/UXUhPDvEzDm04lw7/VEaxltuFH8jgotUkWdFnVc/Ihljp/7/r2HHG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="294337268"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="294337268"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 19:17:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="673629754"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 31 Aug 2022 19:17:20 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 19:17:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 19:17:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 19:17:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibFghLX/EmAdCRNJHnaviWQupzIn1MfX6LuoyIdsvarQd0hLDx2mKvku0NpQ0Pxebn+Q5RIrffgWdjGXxCSDe/Wi4rpumEsJxTowPnPG8vUXNLMhra2cc6mF+BD2SYrEWl0mS/71XbIz7rLdOkKoq94s8M41mY6hj9hg0j/tSx7dXGWrMCVzOltp5mmIMCtMmahMwvT8aOpDtsAgqXztkjs1Co9qW1IYjduRhNECMbc5ap5CXvNRKU20a+k8MSiHiFYGyiXSEZ2OACUtEh+x2rDQ4zAGRU2l9pY5chyWL+tCarR0jhVI19OGUY+aNkIl9HBMaa1QBay7jl3iZIb+dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtOR5TXzqe56yY9Lm8gGn5AJxn5NWlbiawt0yAtA+mo=;
 b=Dg2YzlrbBY7qRf64cUYssn/D5cqsNNspcghQMWddCHRoYKuCpxMXHcVkQBznVM7Z9PI4AX9dWSSEUF/R13Dc0weZY0nnXDm20PpyV3+tYj6Os4lPP9FRHUQMAxVisCcl9ZiRbN4U9LLhdxVJTKygjcc+rPpbslzvRMj+9EeRjCG9DeidU7QA4z3lhXC6B/8O1rWfAPSXsdpU752DokINV7yY+qvFb+4QPydOwTJYXEPtgSgGzU3RdQfOvqHm1cQ6t4LI573Avc+OWnVS2z/izRC1F4r8XwAhNR3SEDLsX3T1m46/RUtIN0whqGr9cxTY2SDQXkzcpG94ThS3xQDWew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2968.namprd11.prod.outlook.com (2603:10b6:a03:90::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 02:17:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 02:17:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Thread-Topic: [PATCH 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Thread-Index: AQHYvNVT+rknUb6o5km5WYKV48pee63IsCpAgAB06wCAACjtgIAABjEAgACDjrA=
Date:   Thu, 1 Sep 2022 02:17:13 +0000
Message-ID: <BN9PR11MB527693CD2358F4B3CE880C7A8C7B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <1-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52764F22F96E12177D50C8068C789@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yw9/4h3mlN4LuBz8@nvidia.com>
 <20220831120231.320081f0.alex.williamson@redhat.com>
 <Yw+naMPLU9gD0oTR@nvidia.com>
In-Reply-To: <Yw+naMPLU9gD0oTR@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41e28947-8876-4a83-c7b6-08da8bc01523
x-ms-traffictypediagnostic: BYAPR11MB2968:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1o7LL5RLaP000ie5rVdeWN2XCHfXuvtg1aO1BuPNVbqrD6R41NkRzcJ1w0eY0L7oa75MtjkxtdwCUyi1ll5x4ADGbTXsSUx900vMn4hMJkSDTkhNerZk2+NrrjmMeF2IrQTjPDLrsdZPT9B7Vl3U5JH8fXKeGd8sDYyHYJXgkSAm/1v80WDrthYhfNn0B0HwOUOL6leJBKJotrjeAIVS053SNiASLQ1dTGViilBF6aoM2pax4fsNS4X0Y6dhVhYbvAiF4pkkRIvZmCT4fkL5EmCWhiYEw0Plq/CyMq9bOo2qQjR0h/N5QkPDgFX4mqWip2nSkM5CrBAF2iAx0aQNeFwP7TXrqxOYm8k5WK737IDtuZTBCmeDrDFHqjFJz36dgfn0NCuacqHq/Zqj/Xy0X0yJ67Pob4dBLhIBOhFV6Ms4zw/KpPV/skcg/j8k7dtyVFNAAWjfbuvtxptTqoMxkSplCYw5q6zTDZupzRlUfOiTdYFNlhj7MZrzNWiyndqVcIsFJ956dxr+8rAtsqPYmf9mi1WzhNFCcpuNQ6bsNMFYc8nMjHt9wxYOzM8JKbVhs4APTDZpjgM2qewx+o0v9850tS0jA5vgLZRUhpALqGwgWPm4ipPX/uG1z1BhnOVwcgKBVFgBf/yn/r8kQuoCbsLxEMCFHT2e50SI3QI9DQERc6vNCXNtoh2N+ENEbYtXXeEE62JI0XtKkUxcp1cmgqR4RWUnjCTd+aEJb4aueYXvAazIm7YP92QyZ5dBqVfsGKnBGMoSRTz3n+KPdKfCRJZNdolmR7sjPK23xXFyoaQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(366004)(376002)(346002)(396003)(7696005)(26005)(86362001)(83380400001)(9686003)(2906002)(33656002)(186003)(6506007)(38070700005)(82960400001)(478600001)(316002)(966005)(38100700002)(122000001)(66446008)(66556008)(8676002)(66476007)(64756008)(76116006)(52536014)(55016003)(5660300002)(66946007)(4326008)(41300700001)(54906003)(110136005)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aElqaHBJaHM2YXFlT1JjamQwOFRPbWVpWHAvdU1RamZOcWJrc2ViU0IrZlZx?=
 =?utf-8?B?cjBhUG04Y2RHam9vR3hvcDFrZzZnMjMwcXVPVWlrWndHY29OcGdwNUdhSHp6?=
 =?utf-8?B?WlF0MVRVR2lqKzNybE84NGd2TVg5cXJyS25lMjRmY2N4VlFxalpKa3IrcDVl?=
 =?utf-8?B?STEwVk9zUXdDR000Sk5BUloyZTRaanZjNmFSUlN4d1RUamRpaXNia3lMaG1h?=
 =?utf-8?B?bHNtaWNNSHJzYmU0eDFpR0I1YXlyQ2lxdjhyeTdkMmpySjFjaDJmYytaalZS?=
 =?utf-8?B?ZEMxOGFYbWUrMk9QaHdzejVvVnQya2RGSkV3aXhTUzRwOTR1ZHIwcjBtUGY3?=
 =?utf-8?B?c21FVXIrMDFlTDlESzRDQ3hnNHVQTlNhVm1GZHNiRnJlSUZOWFlJVTZLbDBD?=
 =?utf-8?B?bG1lV0ZZR0VPVzU0bTA3K2trYnZKYTBQOGJ0UElnTzA1RUpQRS90d2w3WmpO?=
 =?utf-8?B?bDcwc1ZLT3ZQMEdCeWM1RHo5M1Y3V20vTUl5Yy9NNExqbGNSVW5LZ1l6NGcz?=
 =?utf-8?B?VFBUOTFIcGxtbldvYVB4dDgzR2M4c1djVGlDRjFpK1VYTURhQUkxZ2FWOEx3?=
 =?utf-8?B?S0tVVUg4S2NCck9tbXkvbyt2dUNRdCtDd0VvL3drQUdwNklDQUZzWXRjWENJ?=
 =?utf-8?B?RnBnWWJmNE12eWtpRnZNSlREME0rSjJuamdzODZsZWsyWi9zaHFIOHp6bkM1?=
 =?utf-8?B?VlpnazVTRDkydkFLWE56YjlxdGRlQXArUHpGM3gvbVlrdWorWGhrbjh5YXFY?=
 =?utf-8?B?MVZqeFE2VWdkSjZlTHRubEJuUWhyU01OdlBCdVVidDl1YzJnamlaSVI1aHM2?=
 =?utf-8?B?dHpra0YrNXNUcklLbnF5L2NJOEM5ZXl1bXhtTVMvSllDVW5LQkpVWkpZa3Ju?=
 =?utf-8?B?OGszN0hRZUR6TlQyVW5nRGQ0Qm43bGNqRE5nbWVMQnNtN2FnejVZcXlZdDNt?=
 =?utf-8?B?YWhZNFNDRzBVU2NrcEx1TDZnMU9ad01STjBUSnV0c2pKNVlzaWxPbHJTRWla?=
 =?utf-8?B?bXdMNUN4OW45a2lJVVQwNG9LdDNaSGdHZ1B1ZFpPREN0T0FYSVNQQnhPR2h3?=
 =?utf-8?B?L1EyVDl4RUtMazVzaHI1Z2puaFl1TGVsU1F4VnZQMzRXYzJtejRTdndhdEVN?=
 =?utf-8?B?MElZRlptL0lHcTRwY3plb1NmMmJFM3p4WnhGOVl1eS8yT3RxUXdJS0xDbVBH?=
 =?utf-8?B?VG0xajNUcFgraDl0NUQ2OTFJejhoczhTSFVLWDdqSVEweXNMYzVQZyswWHBS?=
 =?utf-8?B?SG1aK0h2aCtacjZtSFM1SFJwblc4UXZxMHBtNnFJR21sQ2lTcXNueThFaUZm?=
 =?utf-8?B?YkdGZVdlaERRQVFhanpBYm13cVpMUWhNbTlOZHJlWWNSdzE3R1VTdmh6ZUVB?=
 =?utf-8?B?M1ZwUmNUL2VmV3pwZEMxUnJJU0o3Y1NiUEU3NWIvaWRtSUtQVXloQ05kS0Fh?=
 =?utf-8?B?UHNXak1BN05WaFp3ZVNUZzduRzRhVnBPaitERzRPcW01MVgwd01KZkhUMDlo?=
 =?utf-8?B?cjlJTDZITXIvaGFmbzkrSXdTQVRNcEgzUWVJTUFvN0ttY2grajhiNnF3Nytj?=
 =?utf-8?B?aHk0dHFWTHBSVVJqTWZpU3RDbk5FMktKa2xYWTdFRnVjRHZXdmYzVVU1L0th?=
 =?utf-8?B?TVYrNC9ENy93cGUvWXBVMnFHV1l1WEdZdzllVHBBMjhROHRLeFQ5SFU1NVE4?=
 =?utf-8?B?SEJJeXVnNmZKbVRwbmw1N0xYdW1HUUk1U0xoOVowMWdnRDNHSmYxMkdNSDFa?=
 =?utf-8?B?OWg1R1NRaFE1UGQ4bmE5dEdpTzUyRWdlZlg3dzVDakJqa2IxbFRRUmFPakJo?=
 =?utf-8?B?UzRKNjlGQTRZNVgwaXJMcStsaXlUckNPc3k0dEZQVWRwekF6SlJuQTRCdndj?=
 =?utf-8?B?Zkg4ZUViWXdybHl3U1ZDNjdCQ3IxbWxyNldsakNoQkYzamFDdmF5Ymd5VFFj?=
 =?utf-8?B?Vy9rQUlCU1hTNHVSZWpwOHBzNklqVDR2ekNrNjV2OFoxUmkzZ1U5WUF0Y2pt?=
 =?utf-8?B?WGxhWGlmQm9aSnpYYjZvaWtWbVMzTE1wUmJoaVpCOU82SHU1Zk03clhUVzdl?=
 =?utf-8?B?VGd6cmZ2cm04Z1p1TmdoTFh4NGhkcTlKMGQreU8rNm05c0FjSFlZUjRkczRY?=
 =?utf-8?Q?1r6I/YJbRmfbGGzLQxzxvmI+z?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e28947-8876-4a83-c7b6-08da8bc01523
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 02:17:13.0525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rItqc7iwoz9mIhxfgQ2bJ91ZrxXhxTG2fndPCz6xos/h6XqHKqsxF06w1gUDaliFMax3T9T3phA//MVntSa6ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2968
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

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgU2VwdGVtYmVyIDEsIDIwMjIgMjoyNSBBTQ0KPiANCj4gT24gV2VkLCBBdWcgMzEsIDIwMjIg
YXQgMTI6MDI6MzFQTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiANCj4gPiA+IFRo
ZSBjcml0ZXJpYSBJIGxpa2UgdG8gdXNlIGlzIGlmIHRoZSBoZWFkZXIgaXMgYWJsZSB0byBjb21w
aWxlDQo+ID4gPiBzdGFuZC1hbG9uZS4NCj4gPg0KPiA+IElzIHRoaXMgc3RyZWFtIG9mIGNvbnNj
aW91c25lc3Mgb3IgaXMgdGhlcmUgc29tZSB0b29saW5nIGZvciB0aGlzPyA7KQ0KPiANCj4gSW4g
bXkgY2FzZSBJJ20gdXNpbmcgY2xhbmdkIGh0dHBzOi8vY2xhbmdkLmxsdm0ub3JnLyBpbiB0aGUg
ZWRpdG9yLA0KPiB3aGljaCBjaGVja3MgaGVhZGVyIGZpbGVzIGZvciBzZWxmLWNvbnNpc3RlbmN5
Lg0KPiANCj4gQnV0IHRoZXJlIGlzIGFsc28gaHR0cHM6Ly9pbmNsdWRlLXdoYXQteW91LXVzZS5v
cmcvICh0aG91Z2ggSSBoYXZlDQo+IG5ldmVyIHRyaWVkIGl0KQ0KPiANCj4gQnV0IHRoZSBhYm92
ZSB3YWNrIG9mIHRleHQgaXMganVzdCB0aGUgbm9ybWFsIGNvbXBpbGVyIGludm9jYXRpb24gb2YN
Cj4gdmZpb19tYWluLmMgd2l0aCBtYWluLmMgcmVwbGFjZWQgYnkgdGhlIGhlYWRlci4NCg0KVGhh
bmtzLiBUaGlzIGlzIGEgZ29vZCBsZWFybmluZy4NCg0KPiANCj4gPiA+ID4gYnR3IHdoaWxlIHRo
ZXkgYXJlIG1vdmVkIGhlcmUgdGhlIGluY2x1c2lvbnMgaW4gdmZpb19tYWluLmMgYXJlDQo+ID4g
PiA+IG5vdCByZW1vdmVkIGluIHBhdGNoOC4NCj4gPiA+DQo+ID4gPiA/ICBJJ20gbm90IHN1cmUg
SSB1bmRlcnN0YW5kIHRoaXMNCj4gPg0KPiA+IEkgdGhpbmsgS2V2aW4gaXMgYXNraW5nIHdoeSB0
aGVzZSBpbmNsdWRlcyB3ZXJlIG5vdCBhbHNvIHJlbW92ZWQgZnJvbQ0KPiA+IHZmaW9fbWFpbi5j
IHdoZW4gYWRkaW5nIHRoZW0gdG8gdmZpby5oLiAgVGhhbmtzLA0KDQp5ZXMNCg0KPiANCj4gT2gs
IEkgYW0gYWN0dWFsbHkgdW5jbGVhciB3aGF0IGlzIHBvbGljeS9wcmVmZXJlbmNlL2NvbnNlbnN1
cyBpbiB0aGF0DQo+IGFyZWEuDQoNCm1lIGVpdGhlci4gVGhhdCBpcyB3aHkgSSByYWlzZWQgdGhp
cyBvcGVuIGluIGNhc2UgdGhlcmUgaXMgYWxyZWFkeQ0KYSBjb25zZW5zdXMgaW4gcGxhY2UuIPCf
mIoNCg0KPiANCj4gSSBrbm93IGEgc3Ryb25nIGNhbXAgaXMgdG8gYXZvaWQgaW1wbGljaXQgaW5j
bHVkZXMsIHNvIHRoZSBkdXBsaWNhdGVkDQo+IGluY2x1ZGVzIGFyZSB3ZWxjb21lZC4gaW5jbHVk
ZS13aGF0LXlvdS11c2UgZm9yIGluc3RhbmNlIGlzIHRoYXQNCj4gcGhpbG9zb3BoeS4NCj4gDQo+
IERvIHlvdSBoYXZlIGEgcHJlZmVyZW5jZT8NCj4gDQo+IEphc29uDQo=
