Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF562752B
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 05:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbiKNEKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 23:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235667AbiKNEKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 23:10:17 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D76DFC1;
        Sun, 13 Nov 2022 20:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668399015; x=1699935015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Rvo1jDEeI+OVM7mMtXfECJV5Rqo19cNgkAeC4n2XK4=;
  b=W+855rVZDMERIyPk1yPCrMo0Q2+xGLIDYzNua89oROo9DMUlN/49Hrdt
   T9o60qoblUD2he+/YxuJT8de4bKqGz+K3TYCLooFIkHWFWyvX8RKIj2vi
   9kDcsEWWKmkad38kqYnVAwd/btf+zFC/+DHkV/JJX3KnAn8GdpucsN/lW
   /DcIv3o4hZer3FWRKEWwTL+gsaxLRDWImzpStplPz9Hr9ajxhs/RggmjY
   mdb+RSu97APsbH6+Z/ns+KORJS8vEBxQaxOAaRoGBG68oWqZFi+2PAEUE
   ZVCqn8uHTRiurp/neDHC623tWIrPOtkega4cu/1HIoZy/J1ejZJJlMLOj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="309504556"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="309504556"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 20:10:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="883384739"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="883384739"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 13 Nov 2022 20:10:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 13 Nov 2022 20:10:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 13 Nov 2022 20:10:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 13 Nov 2022 20:10:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUvQQWo8IQJo4Hs6488W3HKxQbx7QqzeoA2Qw8EdmrhtdvqqhVPO4y+ZFzGi7n8wmdTvdQUAeenwcHGzWf0kboVKI0K9sPXnwotMXQePB1wN3gunKwkp+fJIu5nyEpqnEm308LQfgYFTW9CfkFKAWMLAKf9Sfwju7jTGMg3fpr12DzQu+ANiVZyTKFBmmTYBGXvx/FHTi0YHGo02tM6G38YoneBAo5unAHYVmi3lBDEZx8Nz0i2UVEmQlDWFTrpWVyrfERABQCn+CVSzPNhcAL/fRvYdjKgoT6mlRXDwRJAtC8UxfUjCAFzvqdp7E5C4KVLYLtvsdjwe1arsf4FOpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Rvo1jDEeI+OVM7mMtXfECJV5Rqo19cNgkAeC4n2XK4=;
 b=mxhsPf64a/J1qtNevpiPxcJuxpnTVWzxVpRcuWnb9H3w4L+iUOOnVPi7w09fn2LAB6XO893DaV2N22CLFSWVisRYzKTvWEENj1PRGnUvXSCK1MA2ZNLMk35hmUWhCFCpuyiOSo+oVHuJ32LYUK3LzriSnQTIOjG0VVJTbhQ0CLMxPCNsnckErtCcP0I+Ts0u63wjt1PF8QYzhbGkOmfWL7qIcaQNL3tmoakepIXYxR788TSiZ8RVRp1BEystWK894ebpFfsLUja/GRhPYHX1NQj6jpSyYmPPZL0fsdVQXt+W9oIBrRRkcaKO5S3cxIalwu0c678LTQgWCnH6g33DRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by MW3PR11MB4730.namprd11.prod.outlook.com
 (2603:10b6:303:58::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 04:10:11 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.017; Mon, 14 Nov
 2022 04:10:11 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Thread-Topic: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Thread-Index: AQHY9MwiNyyftQUqnECEfv3VPyPgfK44UVAAgAAslsCAACVigIAA0H+AgAAC2YCAABVSgIAAFCQAgAQXXlA=
Date:   Mon, 14 Nov 2022 04:10:11 +0000
Message-ID: <BN6PR1101MB2161EF9C6D0820B84990F666A8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com> <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21ktSq1QlWZxs6n@google.com>
 <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
 <3A1B7743-9448-405A-8BE4-E1BDAB4D62F8@zytor.com>
 <Y24n4bHoFBuHVid5@hirez.programming.kicks-ass.net>
 <ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com>
In-Reply-To: <ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|MW3PR11MB4730:EE_
x-ms-office365-filtering-correlation-id: 3093bb67-f5b9-41c3-987d-08dac5f61ff3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sToYPN3u4HI+j3/KEpK86ScwOcBvyIl4qi1aQAxj0D14Z8zluhPC29zB7V9bWS7BkRkZqGf5+wBYkeZCwYu99RZMCBbpAal7qbQkMpMsLQQ4gAIwjworRxJ3vc/MH+d025+KyxgIo2PD5pHyeO6SZZOH/9JHqN5MgatBrpoh79d2j9oWvJbEuyUS/EH5MKAl/1PsNpvFY7Q92THuqPDRRYkCuAr4VLSwt1aFmcxyp8r+vNmecRTABSo1cwZVkXdklhi2FubBKtDS4PEbYzzeN+Fft3QXjb9bu6JJUYeyfJBgPKTLiy/h7C/0W5Gx19BVlorXfKpRvStzKGfmBS337ioIPkspf4fM/+p+nxWsMdV7J1KPMJY7JAabwvCw6MhuXQvvHCBJ8JPHTLOgh067CM6WpOOeic2463Pg/ezMg+4utsJlWQSFjnRt82WN1r8RcOhvFQVaVVvcKHtgpJv9Bqg4m+ys5qWscoQDiRpX+WLCddF9+wN5nFhIe/zhwkI6AgcWDxshpd+F1Hugp0UCNooJc1c2kEOyl6E8lnHyN6VTJpchOcYObWDYR2kEW/2QRv/Om/BBvgJDEWguHBik6hBpldp7td/K8k5gVNiqptX+PwMU1XXpGJP+98Z5UNE5XRAI1LhjsjlrTAKhkFGm3mMTx4S6KZfKfun4MzyXD8SoUnVMWIMd4RNYwuPVKlnsgJ6Y/HB3Ap4dKs/riXrSG5BBWzzvhLEifs9sfOf8D9m90hZm0Ed9ePIpJ3J+2aeQz8bbgw22bkKEYwKBQMBTfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(2906002)(64756008)(9686003)(8676002)(66946007)(66446008)(66476007)(76116006)(4326008)(66556008)(26005)(7696005)(316002)(53546011)(7416002)(5660300002)(186003)(6506007)(41300700001)(8936002)(52536014)(82960400001)(86362001)(38100700002)(55016003)(122000001)(38070700005)(83380400001)(33656002)(71200400001)(478600001)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2hmZGQrbXFtQ3QxTXc0ZGhzU3pTSjRuQ1B4ank4ZS9FT0dZWVhEbHlyUFdk?=
 =?utf-8?B?aFBjOGUxSkxqdmxSUFNzQ0wzcjc0KzJXSDZkajY4dFlGNWtLNjZFaEoxdHZ3?=
 =?utf-8?B?UDdlU1F2Y1dKSnNaWFF0L21zeUJDWDZ5RGlVRlFxaDZTOXdLWmNUdDUwUW5p?=
 =?utf-8?B?b1hMaVNoanZrUks3d1M0cC9hZnVsTEgybDloeHpnVUhKb2JzTzI1U2VvSmhB?=
 =?utf-8?B?M1pTK1NJMWp2OXVub2pvbXRHOGRqNk10Z2VhRXpudysvZUZZeWQyQlBsc0Vx?=
 =?utf-8?B?Wk44ZnFsbUpZdlA1OHFzSUVVV0ZiLyszbzh3ZnlSTStkNGQyQzhzL0NPcG9i?=
 =?utf-8?B?Z3JCcldvVURYaHplR1VEMjdYKzBzQXgwK0UzY0JMamR4RkxnRk8xZ3EweG04?=
 =?utf-8?B?UGFjZS9xUk56QWZ5T1JMZDJNUnVKL2lSN0JKZUloWGVtSSszakRtZlljbUhN?=
 =?utf-8?B?eEtYaytjVDdFenNHRVdqNVhxOUFsVGswMGtRN09MSjdHYktCT1RoTGV5QTVu?=
 =?utf-8?B?bFhyV05YWkJWUXY1ek5YVTc4Z1RpNGwySHFLS1ZlS3kxdzlWVHAzYk82bGpX?=
 =?utf-8?B?ZTRZZlR5dk5LVHhWTDZYaG9UTGZnUWdxTE9yVHdSQVRsbjFDeXBaQy9JTnFv?=
 =?utf-8?B?Z0UxSjRPLzJiaHNRSHRRcGJkU2t1YnBKV0ZBd2tTOUtzVTlvK01BM1lxeWxG?=
 =?utf-8?B?dXp3UTliZFZWWm9jZnhMRllyRzdPWGhPL29ISlNFakFUNldRdGdURzUxMmN5?=
 =?utf-8?B?S2FDSlNIb2tSQ2p4SUltZ0FHWE16Vy9DMjlZMmtzR1dqS2E2QjNMcGdpNU44?=
 =?utf-8?B?dGxkK3ByRXpwSExKVHJHNVlIY1JXanY4TFpucVE0ekdBcDc4eGpaM2NsT1RP?=
 =?utf-8?B?Q1hKd2t5YkNyNGw5Qng2M28xWW4ya0hITnZ0QUpLczFpVzNJSTdNY29XZ0Rk?=
 =?utf-8?B?NjdXZVdWSWNUMDFIWmVldHNoRTJlTVZKYXJMNmlMclZEeWlJZUgyOFRzTW5C?=
 =?utf-8?B?OXQ3emxLRmVGTnZmbUU0THphdTdPRjZSbmc0dytaWjBIRTZWcUhmeEdTRjI3?=
 =?utf-8?B?L2V5MFdJOWRsRE1MaEV0UXozUFptRFZGTk5ReDBOakM1VU05aVgza3N6bWlW?=
 =?utf-8?B?WGtseDl6MzBZWU5zN0ROUE1qeHdONkVRL0F2UzJHakNlb2U0bG9pN3VnQWZ2?=
 =?utf-8?B?ZzQwQmN3dG1rTWxQaHZMdEp0M3JBRU0zdkRVZ09Tdyt5UlBZQlRtK0V3c3Jk?=
 =?utf-8?B?ZzVmeFJlOTJ6Y0Z2MFkxRmNJanV4WEdodW1DZWJnUlNkYkhrRndvS1RsY2ls?=
 =?utf-8?B?eXVmd1BvUW9TY1RGblZ3QnB4UUVyUDlIdlAycG5PRFZ5b05FOUFwN0JsVkNh?=
 =?utf-8?B?cGJtSjlkSHdBSW5QQjZUNGoxY3ZjOHhnbGM0SjZmUnYxaDd5RHRMZlIybFhy?=
 =?utf-8?B?eVl1QnJZd3d5aWtOeitrVWtCaU1wTCtUbFlMUGFWS2pqUXdYU3FNUkNRWlBJ?=
 =?utf-8?B?bnN4QnB4ek1NemY2R2NtTlhyYUMvK1dHNSs1RVlVbWF6U2RpQlBpSFBZUUtx?=
 =?utf-8?B?TkYxOUg4aWcwTjVsb2l1a0c5VTdRcTRpWG5zU003anJHRDVmc3ZlN0JlUzdu?=
 =?utf-8?B?ak81MHI3VWdWaGV6d2pySHdWdThoS2FWMzE3YkJKZzgxTFVScjY3RFh2cU5X?=
 =?utf-8?B?SDE0a2RmS09LQUY0ZTNhcTZ6QkRmVG43ZGFaYlAvaGtUOEt3MVVRZ2JzRmZK?=
 =?utf-8?B?S0haOXRqSVgrQzhVa1dJZ1RRc2dOWHhOdXB2RjAxSnp6NDVlQkVmT2Q2Rm9I?=
 =?utf-8?B?ZzNRdWZ0SmxxSHMvYWlKUTdkQjJ6Q0ovNmdkRFpxVjBBMG8xSmVtbzZ0b1Nv?=
 =?utf-8?B?SXVxNjZ3cjBXcktydnl5bDA0d3VQRXFrYUVMdC9TM3pQTHF6aktwbHF2ZElW?=
 =?utf-8?B?L2k0bmZuUzdoT3N0RTlPUXlScGlaT042Smh4Y0xWZG5EU3lIZ2xmd1RUZGlR?=
 =?utf-8?B?ZlhtbWpDKytOWUNLaGFPcU9UMzE4QkthbnBndG1wUWJ3d0czaDE3QlJHYlNp?=
 =?utf-8?B?UTZlOUIrR0pWK1Ztdi9taFNTMlVtbWxVTGlNenNrNjBJUGlVOUFWS2pnK05F?=
 =?utf-8?Q?4HP4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3093bb67-f5b9-41c3-987d-08dac5f61ff3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 04:10:11.4874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s5v1GTYugWu0ZOFtm7OorutWYNvuXQO17JwNl6gvGhSCMMgzilXjQv0zlfN1Pp7igjytKfHdX9HyxwCONYNSMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4730
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQm9uemluaSA8
cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogRnJpZGF5LCBOb3ZlbWJlciAxMSwgMjAyMiAz
OjU4IEFNDQo+IFRvOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+OyBILiBQ
ZXRlciBBbnZpbiA8aHBhQHp5dG9yLmNvbT4NCj4gQ2M6IENocmlzdG9waGVyc29uLCwgU2VhbiA8
c2VhbmpjQGdvb2dsZS5jb20+OyBMaSwgWGluMyA8eGluMy5saUBpbnRlbC5jb20+Ow0KPiBsaW51
eC1rZXJuZWxAdmdlci5rZXJubmVsLm9yZzsgeDg2QGtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5l
bC5vcmc7DQo+IHRnbHhAbGludXRyb25peC5kZTsgbWluZ29AcmVkaGF0LmNvbTsgYnBAYWxpZW44
LmRlOw0KPiBkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb207IFRpYW4sIEtldmluIDxrZXZpbi50
aWFuQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCA1LzZdIEtWTTogeDg2L1ZNWDog
YWRkIGt2bV92bXhfcmVpbmplY3Rfbm1pX2lycSgpIGZvcg0KPiBOTUkvSVJRIHJlaW5qZWN0aW9u
DQo+IA0KPiBPbiAxMS8xMS8yMiAxMTo0NSwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4+IFdo
YXQgaXMgImNvcnJlY3QiIGluIHRoaXMgY29udGV4dD8NCj4gPg0KPiA+IEkgZG9uJ3Qga25vdyBz
aW5jZSBJIGRvbid0IHJlYWxseSBzcGVhayB2aXJ0LCBidXQgSSBjb3VsZCBpbWFnZSB0aGUNCj4g
PiByZWdzZXQgdGhhdCB3b3VsZCBtYXRjaCB0aGUgdm1ydW4gKG9yIHdoYXRldmVyIGludGVsIGRl
Y2lkZWQgdG8gY2FsbA0KPiA+IHRoYXQgYWdhaW4pIGluc3RydWN0aW9uLg0KPiANCj4gUmlnaHQg
bm93IGl0IGlzIG5vdCBleGFjdGx5IHRoYXQgYnV0IGNsb3NlLiAgVGhlIFJJUCBpcyBzb21ld2hl
cmUgaW4NCj4gdm14X2RvX2ludGVycnVwdF9ubWlfaXJxb2ZmOyBDUy9TUyBhcmUgY29ycmVjdCAo
aS5lLiBpdCdzIG5vdCBsaWtlIHRoZXkgcG9pbnQgdG8NCj4gZ3Vlc3QgdmFsdWVzISkgYW5kIG90
aGVyIHJlZ2lzdGVycyBpbmNsdWRpbmcgUlNQIGFuZCBSRkxBR1MgYXJlIGNvbnNpc3RlbnQgd2l0
aA0KPiB0aGUgUklQLg0KPiANCj4gPj4gQ3VycmVudGx5IEtWTSBiYXNpY2FsbHkgc3R1ZmYgcmFu
ZG9tIGRhdGEgaW50byBwdF9yZWdzOyB0aGlzIGF0IGxlYXN0DQo+ID4+IG1ha2VzIGl0IGV4cGxp
Y2l0bHkgemVyby4NCj4gPg0KPiA+IPCfmYEgQm90aCBpcyBicm9rZW4uIE9uY2UgYWdhaW4gcHJv
dmluZyB0byBtZSB0aGF0IHZpcnQgaXMgYSBidW5jaCBvZg0KPiA+IGR1Y2stdGFwZSBhdCBiZXN0
Lg0KPiANCj4gRXhjZXB0IGN1cnJlbnRseSBpdCBpcyBub3QgcmFuZG9tLiAgQXQgbGVhc3QgSSdt
IG5vdCBhbG9uZSBpbiBzb21ldGltZXMgdGhpbmtpbmcgSQ0KPiB1bmRlcnN0YW5kIHN0dWZmIHdo
ZW4gSSBhY3R1YWxseSBkb24ndC4NCj4gDQo+IFplcm8gaXMganVzdCB3cm9uZywgSSBhZ3JlZS4g
IFhpbiwgaWYgeW91IGRvbid0IHdhbnQgdG8gcG9rZSBhdCB0aGUgSURUIHlvdSBuZWVkDQo+IHRv
IGJ1aWxkIHRoZSBwdF9yZWdzIGFuZCBwYXNzIHRoZW0gdG8gdGhlIGZ1bmN0aW9uIHlvdSBhZGQg
aW4gcGF0Y2ggNS4gIEluIG9yZGVyDQo+IHRvIG1ha2UgaXQgbGlrZSBQZXRlciB3YW50cyBpdCwg
dGhlbjoNCj4gDQo+IDEpIGZvciB0aGUgZmxhZ3MganVzdCB1c2UgWDg2X0VGTEFHU19GSVhFRA0K
PiANCj4gMikgZm9yIENTL1NTIHNlZ21lbnQgc2VsZWN0b3JzIHVzZSBfX0tFUk5FTF9DUyBhbmQg
X19LRVJORUxfRFMNCj4gDQo+IDMpIHRoZSBSSVAvUlNQIGNhbiBiZSBmb3VuZCByZXNwZWN0aXZl
bHkgaW4gKHVuc2lnbmVkIGxvbmcpdm14X3ZtZXhpdA0KPiB2bXgtPmxvYWRlZF92bWNzLT5ob3N0
X3N0YXRlLnJzcA0KPiANCj4gNCkgdGhlIG90aGVyIHJlZ2lzdGVycyBjYW4gYmUgdGFrZW4gZnJv
bSB2Y3B1LT5hcmNoLnJlZ3MNCj4gDQo+IEJ1dCBJIGFtIG5vdCBzdXJlIGl0J3MgYW4gaW1wcm92
ZW1lbnQuICBJdCBtYXkgYmUgb2theSB0byB6ZXJvIHRoZSByZWdpc3RlcnMsIGJ1dA0KPiBzZXR0
aW5nIENTL1JJUC9TUy9SU1AvUkZMQUdTIHRvIHRoZSBhY3R1YWwgcHJvY2Vzc29yIHZhbHVlcyBp
bg0KPiB2bXhfZG9faW50ZXJydXB0X25taV9pcnFvZmYgaXMgc2FmZXIuDQo+IA0KPiBJJ20gbm90
IHN1cmUgd2hvIHdvdWxkIHNldCBvcmlnX3JheCwgYnV0IEkgaGF2ZW4ndCBsb29rZWQgdG9vIGNs
b3NlbHkuDQo+IFBlcmhhcHMgdGhhdCdzIG5vdCBhIHByb2JsZW0sIGJ1dCBpZiBzbyBpdCBoYXMg
dG8gYmUgZG9jdW1lbnRlZCBpbiB0aGUgY29tbWl0DQo+IG1lc3NhZ2UuDQoNCk5vIElSUSBoYW5k
bGVyIHVzZXMgYSBwdF9yZWdzIHN0cnVjdHVyZSBhcyBhbiBhcmd1bWVudCwgd2hpbGUgTk1JIGhh
bmRsZXJzIGRvLg0KDQpGb3IgTk1JIGJhc2VkIHByb2ZpbGluZywgd2hhdCBpdCB3YW50cyBtYXli
ZSBpcyBtb3JlIG9mIHRoZSBndWVzdCBSSVA/DQpJIG1pZ2h0IG1ha2UgaXQgb3ZlciBjb21wbGlj
YXRlZCBieSBtaXhpbmcgaG9zdC9ndWVzdCBwcm9maWxpbmcuDQoNCj4gUGFvbG8NCg==
