Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A550F5FF0E7
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 17:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJNPM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 11:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJNPM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 11:12:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8E1D20F3;
        Fri, 14 Oct 2022 08:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665760345; x=1697296345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wIgkzDcxMApiitRClzqeNFxb5pcHdUGeIGTQZ+gTGGo=;
  b=FblL97pGXOA0erswCZvYnpD0/GZcuDhrHIVTfzSU6jjWf0DjUEkFu53G
   5eTgyYCHUVtYecyZYtWPLsXvo+CTLxL1JvKTBSuJgzN5wyj7KvghIdR4K
   lpzpET0UU+R++Hz24wBhgRKOm/PTYrwNfsyy4Vz9h9dr9dIcF9JDkjFM+
   WwhAVod7dWe4Qo3kqZVXi/pGmUeUXuE7J26/U22UKq1pHASagLlJ9z/N2
   CEah2R1Ocx3zX/kZKj8DHZBFRRpijhVTPy8zDoS1cBeFvaEc7dkJL3HAu
   JfzRkFaZ4PlksyDC4g5OKykDa/eVtoJLT9xMD167ghYIpii0BFwPYN85d
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="305386836"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="305386836"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 08:12:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="660759000"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="660759000"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 14 Oct 2022 08:12:24 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 08:12:24 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 08:12:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 14 Oct 2022 08:12:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 14 Oct 2022 08:12:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oG00l5Cc+7aNa60++jh3/+mhuXj8SnD16G+VaFI47HCNy2KvMpQE8ctCTRpPmLHIXH7am9HYZ5hzRpBQKhsUbdCdEnjoUDibyPiE80eF29gO3mMng47hoFAdxC+C3/nCtGRj9PRnLrdfaBj/Rxd8hMWDB6HjDtN1f1T1q37ttTvZHejRyBq1bo0fVnGE3XPtTodzP2/+ubKp7+JMZrwZafmq7PkJLnpCfRZlwk2cpIfcPR9hxM3I3I1ZYNljVJHOfb/OJPBfjnoOZnSwWPjbf5aaHznUGb6o7lJncExm+KViVHRoiGJXfr1xOioaFcHkSQSkLFpP3feGWAdIQjL3Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIgkzDcxMApiitRClzqeNFxb5pcHdUGeIGTQZ+gTGGo=;
 b=jEzdQw+8DDSVTZO9XkJxM9Nze3sCDGRbrisPIoliapet0poeLEEdv+ImmJhiHiK2MHa2MKgSYBkU9Qzv4wTkk8mVW456eMPHQ3kSyUq69SdHrHVOUY/JhPv/WvNR0SBsy7Bfwq5rciCdPmsCyMB5rCN+almJWpJ98ODozyKw7KyIYlJkxmUgyBCrMZeF9PH7TlzExEV0/NWZjTUwnlIEa3ehPKecUnvNw9NSp0CKHcnKhI6bc9aD17h7hocLxYduIniYhXY+iRbVY1kF4vkyihhZC1kXd6BcgiQT0SA9BMfjD2aOHw3YocrdFZpbUp24NsBHsvPwbf/vM0WYhzYTIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA1PR11MB7110.namprd11.prod.outlook.com (2603:10b6:806:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 15:12:21 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%5]) with mapi id 15.20.5676.041; Fri, 14 Oct 2022
 15:12:20 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Vipin Sharma <vipinsh@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
Thread-Topic: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
Thread-Index: AQHY3PSo5mk7BJgdskG84RjiFjmwJa4N+zRA
Date:   Fri, 14 Oct 2022 15:12:20 +0000
Message-ID: <DS0PR11MB63735576A8FBF80738FF9B76DC249@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221010220538.1154054-1-vipinsh@google.com>
In-Reply-To: <20221010220538.1154054-1-vipinsh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA1PR11MB7110:EE_
x-ms-office365-filtering-correlation-id: 91493ec6-f388-4bc9-0883-08daadf67d9d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dGaX9BIzqa8O4uZL/vvDlr0rB35j063Q+hx6udMkW07rTiKdLPcz4VZlOZgduZVgcjrss2CAVdaSd+ATAtVE046ba4xvGtNw2ENN39PeX27FsNXDEI7sc+978Pt7z6MBlq3BTijxQsXd+6utrW3wf5uWO2CtSWoydhlDgVPU6jG8eBmsenJBTWKA/ndoz/w7QNe2Zpar029qH13IbooKZFTz+zwPNWdYX8L0aK3tHuqL82hApesMbz1PBRqOkeWhv2nTfP6CbM5oPeBdlf0qXSVPg2nStij7oOn4eOzcxFoxfcGOJKWAykyNRM2lkiUXbHU6j3vleSmE4purkann9GEDBEa2bgC2mieRpufixE8iVketeyuPNMHSJrruL1vnVxzNAvOGL4KZvsyPTvXf4NPzwjC9oLDHIYWr8S+3MkHxQBQLXN2Cr6JIBAFZwwGRHgaCUFhqzymXBLri2PEFAY+BvzWPeY5CP6iVsT2AGGv9sschXKYbTqXUIid95BNiY4VIhw+rX04gs/G/HkyB7DeFfOittMW1k+ydWb9cJVZUESWt/r6LluWRODULlMiwQ1WaiMuIl1Zv7gwDSBSPg24Y5eAheKtuyFMHVSHRltu7NCwFprraQb9ddmsUSxHOPP2XmSbjBsiVNF5KYaBQn6b1JatVg6P95pH3987cwhcstSRPMQleTWURKa13IS+pF6OrxEZrAah5LOE2TptLWZZKgM16fXx95FPPrFFXy3/janMb8Gw6Yv1dhRUzlkKzWAwIkUcRUVhtjSMPhUkk9cxW/NkAxqzRkVp/cdYkfuU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199015)(5660300002)(41300700001)(55016003)(2906002)(86362001)(478600001)(33656002)(110136005)(316002)(76116006)(7696005)(6506007)(66446008)(8676002)(66556008)(52536014)(8936002)(53546011)(186003)(4326008)(64756008)(66946007)(38070700005)(122000001)(9686003)(82960400001)(66476007)(54906003)(26005)(38100700002)(71200400001)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODQ3TXJKQXhsNVdPNzRCK3FoWXl4YTlyUVdTQ2MrNTAxdzlyRlNaUVpFajdQ?=
 =?utf-8?B?dlFHL2lUSmg2WHhNOTJ5YUhIcGVPckR4ajRMSVJTbWh4VjVFOThzOVo1U1ds?=
 =?utf-8?B?RVJQS3J1Nkdkc2ZYOG5ZUUlaUDJDZmIzZFVnSHQyNDJIcE9icHlhQjNHdHYw?=
 =?utf-8?B?Zmt2MDBuRkFoLytQUVFYNTY0OGZ6QitTK1BJdWlTS2RoY3duVXFoUDd4elZI?=
 =?utf-8?B?Q2MrR05wdFZqOTFUekZNNGk4SEVyYnllb1dvV2xBb1hFcFVydHBxMGdWSDA3?=
 =?utf-8?B?eXplblA0WUY4eThZeGhua0cxTDFQbjNZTUZFaVdRWHpWektmdEJVRVlHNzgv?=
 =?utf-8?B?L3prOVVlNm5Sa1BKaGFKV0dNRWJoSFl2ZSt1K0R6TjVCRmoyRFoyUUJ1Z05h?=
 =?utf-8?B?Y1pxcXpYQ3MxUU82TzVpQXdoYW1IMUJwSDh6TndrWmtnbTZ2T2ZrME80OWpp?=
 =?utf-8?B?RkRBOHg4YWt6REFzTlg5Z0pSbHFlNm16SGVoRW9yY0RpL3VZbklYTmZUMitu?=
 =?utf-8?B?S0RDYWlNY3FwUVNNMnhycGdpUmNPdWtRT01VQkFYbklmS2VnMC82QktpMHFp?=
 =?utf-8?B?b2dpVFZtRnUwb1Z5U0lCQ0MrRVJ2RnNhQU80YkVDbHBuSXF6eVR0aDZzeG9u?=
 =?utf-8?B?VkZhTWlLNHh2YkZiVXVwVmNiNER6QSt1WnlWbEwwcFliUCttdjNPUmovKy9s?=
 =?utf-8?B?cmFPRnU0bSt3b2FOc093VmFnYTUwZ3o5aDdlenRydENKSytqQzc5YlFyTUVk?=
 =?utf-8?B?TDJUdXFGbzNMemJpNjNhcDEyNVlnWXZndGlvNTJTaW94YzFiUW5pdUQxN1ZO?=
 =?utf-8?B?eGpONEhyTktPN3FVYnplT2x4eHpDYWo4MXlJaU04YmpzWlQrcXFFRXR2cmpz?=
 =?utf-8?B?anBPYm9odDJPVy9WZ0lkblVNZHI5R0xqTStsZFNMcG0yVE5LMWM5dFRSZE00?=
 =?utf-8?B?L0NQUkRDT2MzZWIzSDd6T1lWNGJwci94QjF3bERrR2lzdTNwdFFlVVIxbys5?=
 =?utf-8?B?dW5tdXRzNDVPMVRIT2VCam9mOG1VSGt5cjBHNTg1cVp1TDlzMGkyOE9NejUy?=
 =?utf-8?B?dkdpa2JtekFPM0REbVlUUkVxK1BMNTNaN21hdElBek1CMnFEMURyWkFWSiti?=
 =?utf-8?B?ajNZL3MwbmVwRGRZeHJ1VVFwY0paWVE0VHdHcU1JM1lnOWJVL0pxeGFTZkFx?=
 =?utf-8?B?V0lWY2oxS1RHQXhiRE96RUtkeGlPSjlMSUVsTU9TRFZ2R1p6Z08waVFZUVlX?=
 =?utf-8?B?ckZDL3llaWVWeHBPNHBmNGpvN25GSHhNblEzd0IzOGdESnFZNzIzVlBrVTNa?=
 =?utf-8?B?dXkvU2E2c0l3MFRsZUQ0N0Jwc3VTbm16a2pBQ0hLTUhyUjVPbEVGdk5sM0lo?=
 =?utf-8?B?N3ZRRTVUa0ZBTzkyM0UxYTEralROamZmd25ya3lJUFRSUSthc2wrazBodVJa?=
 =?utf-8?B?Zm5rUUpiM2lQODU4ckVZVmpGelFQdGE0TC90Z3hpekhQaGs0K2UweXg2aHE0?=
 =?utf-8?B?Vzd5OXE4NUtFRkVPNUZ2dDRJOE5SaFJCMjY5Vm1aY3FmelBBTFN4Q044S3Bj?=
 =?utf-8?B?eTNkUEVLNEF4U2ZuZE1melc5emliL0dSbWVVcXg2WEsrS0VnSFE2d3prdlRa?=
 =?utf-8?B?VFNUcGxxVnlUWk5ZQlhHcDZPV3o1bkI4UkpwUTNJdzh6Q1I4WVlwbkNCbXJz?=
 =?utf-8?B?RUtrYnhXd1JOQzdxY3J2aWNKbDFySzFGWWgzNmhUUU1Id1Vrd2s2VW54WmdC?=
 =?utf-8?B?SWpWWDFKQXE4YWtIM3VwRnhXMWc3R2xBcWpTeUpMYmwzeWVvenlqWXJWOHRE?=
 =?utf-8?B?bnZvdHdHSERacmJIeFVpMlptMVJYdWM4SkVDcTM3R0lFZ1JQNUszQnFmbzEw?=
 =?utf-8?B?RkdKSE1qNmlOVGJNeTByRmoyZjdkVGFmWUZNVUhkbUMvQmc0c2VYeG4rREdm?=
 =?utf-8?B?Qy85MCtBcmFXYTRTeEVHVENQNUNlWFFYQjJsdGxMdG14YWg0R0ZiVFRGY2JW?=
 =?utf-8?B?MkJIUVhJWFo2bnNwTVB6L21GY3Q3QWt2SnQ1RFEyMS9NTjhsU2JnM3VsbEx1?=
 =?utf-8?B?UmhsV1kyMGtiSU10VU4xdi9ndVZ2S21pUEJYY2tCSnZrNVlGT0ZDbzI3czZF?=
 =?utf-8?Q?V3paZq6m5sPPUcYTsdnopU3Iz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91493ec6-f388-4bc9-0883-08daadf67d9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 15:12:20.7039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: acKh6KAMuXThvtlWxS0X13rPIaVRlk7jjk7aUqBhpxLQH5jqnfhjhtkjtPOl/ZPAI+YJtj9krfWt472jz7Qk2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7110
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlc2RheSwgT2N0b2JlciAxMSwgMjAyMiA2OjA2IEFNLCBWaXBpbiBTaGFybWEgd3JvdGU6
IA0KPiBQaW4gdkNQVXMgdG8gYSBob3N0IHBoeXNpY2FsIENQVXMgKHBDUFVzKSBpbiBkaXJ0eV9s
b2dfcGVyZl90ZXN0IGFuZCBvcHRpb25hbGx5DQo+IHBpbiB0aGUgbWFpbiBhcHBsaWNhdGlvbiB0
aHJlYWQgdG8gYSBwaHlzaWNhbCBjcHUgaWYgcHJvdmlkZWQuIEFsbCB0ZXN0cyBiYXNlZCBvbg0K
PiBwZXJmX3Rlc3RfdXRpbCBmcmFtZXdvcmsgY2FuIHRha2UgYWR2YW50YWdlIG9mIGl0IGlmIG5l
ZWRlZC4NCj4gDQo+IFdoaWxlIGF0IGl0LCBJIGNoYW5nZWQgYXRvaSgpIHRvIGF0b2lfcGFyYW5v
aWQoKSwgYXRvaV9wb3NpdGl2ZSwNCj4gYXRvaV9ub25fbmVnYXRpdmUoKSBpbiBvdGhlciB0ZXN0
cywgc29ydGVkIGNvbW1hbmQgbGluZSBvcHRpb25zIGFscGhhYmV0aWNhbGx5DQo+IGluIGRpcnR5
X2xvZ19wZXJmX3Rlc3QsIGFuZCBhZGRlZCBicmVhayBiZXR3ZWVuIC1lIGFuZCAtZyB3aGljaCB3
YXMgbWlzc2VkIGluDQo+IG9yaWdpbmFsIGNvbW1pdCB3aGVuIC1lIHdhcyBpbnRyb2R1Y2VkLg0K
DQpKdXN0IGN1cmlvdXMgd2h5IG5vdCByZS11c2luZyB0aGUgZXhpc3RpbmcgdG9vbHMgKGUuZy4g
dGFza3NldCkgdG8gZG8gdGhlIHBpbm5pbmc/DQoNCkZvciBleGFtcGxlLCB3aXRoIGJlbG93IGNo
YW5nZXM6DQpkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi9wZXJm
X3Rlc3RfdXRpbC5jIGIvdG9vbHMvdGVzdGluZy9zZSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwu
Yw0KaW5kZXggOTYxOGIzN2M2NmY3Li5hYWM1OGQxYWNiM2MgMTAwNjQ0DQotLS0gYS90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbGliL3BlcmZfdGVzdF91dGlsLmMNCisrKyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYw0KQEAgLTI2NCw2ICsyNjQs
NyBAQCB2b2lkIHBlcmZfdGVzdF9zdGFydF92Y3B1X3RocmVhZHMoaW50IG5yX3ZjcHVzLA0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZvaWQgKCp2Y3B1X2ZuKShzdHJ1Y3QgcGVy
Zl90ZXN0X3ZjcHVfYXJncyAqKSkNCiB7DQogICAgICAgIGludCBpOw0KKyAgICAgICBjaGFyIHZj
cHVfbmFtZVs1XTsNCg0KICAgICAgICB2Y3B1X3RocmVhZF9mbiA9IHZjcHVfZm47DQogICAgICAg
IFdSSVRFX09OQ0UoYWxsX3ZjcHVfdGhyZWFkc19ydW5uaW5nLCBmYWxzZSk7DQpAQCAtMjc1LDYg
KzI3Niw4IEBAIHZvaWQgcGVyZl90ZXN0X3N0YXJ0X3ZjcHVfdGhyZWFkcyhpbnQgbnJfdmNwdXMs
DQogICAgICAgICAgICAgICAgV1JJVEVfT05DRSh2Y3B1LT5ydW5uaW5nLCBmYWxzZSk7DQoNCiAg
ICAgICAgICAgICAgICBwdGhyZWFkX2NyZWF0ZSgmdmNwdS0+dGhyZWFkLCBOVUxMLCB2Y3B1X3Ro
cmVhZF9tYWluLCB2Y3B1KTsNCisgICAgICAgICAgICAgICBzcHJpbnRmKHZjcHVfbmFtZSwgIiVz
JWQiLCAidmNwdSIsIGkpOw0KKyAgICAgICAgICAgICAgIHB0aHJlYWRfc2V0bmFtZV9ucCh2Y3B1
LT50aHJlYWQsIHZjcHVfbmFtZSk7DQogICAgICAgIH0NCg0KYW5kIHdpdGggdG9wIHdlIGNhbiBn
ZXQNCiAgICBQSUQgVVNFUiAgICAgIFBSICBOSSAgICBWSVJUICAgIFJFUyAgICBTSFIgUyAgJUNQ
VSAgJU1FTSAgICAgVElNRSsgQ09NTUFORA0KICAgNDQ2NCByb290ICAgICAgMjAgICAwIDQyNDg2
ODQgICA0LjBnICAgMTYyOCBSICA5OS45ICAyNi4yICAgMDo1MC45NyBkaXJ0eV9sb2dfcGVyZl8N
CiAgIDQ0Njcgcm9vdCAgICAgIDIwICAgMCA0MjQ4Njg0ICAgNC4wZyAgIDE2MjggUiAgOTkuOSAg
MjYuMiAgIDA6NTAuOTMgdmNwdTANCiAgIDQ0Njkgcm9vdCAgICAgIDIwICAgMCA0MjQ4Njg0ICAg
NC4wZyAgIDE2MjggUiAgOTkuOSAgMjYuMiAgIDA6NTAuOTMgdmNwdTINCiAgIDQ0NzAgcm9vdCAg
ICAgIDIwICAgMCA0MjQ4Njg0ICAgNC4wZyAgIDE2MjggUiAgOTkuOSAgMjYuMiAgIDA6NTAuOTQg
dmNwdTMNCiAgIDQ0Njggcm9vdCAgICAgIDIwICAgMCA0MjQ4Njg0ICAgNC4wZyAgIDE2MjggUiAg
OTkuNyAgMjYuMiAgIDA6NTAuOTMgdmNwdTENCg==
