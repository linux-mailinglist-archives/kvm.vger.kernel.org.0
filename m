Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247EC7D93AB
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345541AbjJ0J3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjJ0J3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:29:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A80EAF;
        Fri, 27 Oct 2023 02:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698398977; x=1729934977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KxvloUNHNyG4kIqfN33nA3VSRGb7iixRcCJtgosCevw=;
  b=MqHLlLRNWDP75MwfFErFpG/QIiGb4lDp6NsrHgyASnGVrQY18jOzOUsJ
   p0/NaeJFa0PFXJsm6oqy4wNdP2rawqCqHBAKxVn63gyUxbCrBnxlDE5vU
   EvzEG8SObFCk3i5I60EvmkCIhUn3uFxvQfNQTKdTilCTdYj/BrV3s41EI
   fUPVEb6J6zgQOa81psR6fg1L2Yuazb+SJRZBee5vdc96MgVSByZWbzEdG
   fEEjZz/kX5oBTQBcMx1hcshG0NsCXLXkIkTyp10D3VgYRu/3W9Mv34Thu
   4Am57IxSHJud6inL8TSY6Hkudwas7CqHPA34CLUwNA6B3DxMk5c58UsEK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="378107861"
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="378107861"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 02:29:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="763147612"
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="763147612"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Oct 2023 02:29:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 27 Oct 2023 02:29:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 27 Oct 2023 02:29:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 27 Oct 2023 02:29:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX095CqpVVdRxukNsuSuzT6RmaB07XLzYnhuDGfgFLfhKbpL3f6L/xV8pEnEmmu4nUTnO0EPpY6CMiDQVEgHTWvKm/wY7LDkuJn0UNKqS9HmCDk173S6MN7jezF+6k5Uo9P6pNua7RloFM8ATVw67M2U9TE/i55m6XhFpieu1pNSEGiosimxdHbPEJ/eL0tYYaBUzEQpFyqsx5ShOKqpfuY3CEatUYi+pe+2rsFc1EXhY0H+ilQN95D7oKUprn1/ltI5tqnblMiVt6ZJQzNPR/5DoEZdwfa8hv/4LbPSQeKSHiqi+ArKGtXrEyouecttZBY1fgfdUbrJGLsCpkq0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxvloUNHNyG4kIqfN33nA3VSRGb7iixRcCJtgosCevw=;
 b=Tca31AOJcrzpo6QmPU/ADk15NJyIy2tYykHbetdKGcJqduuZfzIRfVAQG8DxFdsX5IYrfvECei97Cqcy5sATWnRGkP0ohDutnGyLcm0rDdN3Lr+7p50RxRqvxvPCPZulIFrhgMQDlEEszrrPiv026z9//n5K+rnoGSfov2SDVMJPIe44bLJKuNmSJ8r6jjlDgs4U7q7KNS0KEb92Vl0sjOIlyvbgDDMcsebSqMMi8egLE5WS7zU1gRaYN8sGE+igRWCYLktDDZe2B8oRbLYdZ/nZtVgXSpBhd6tNH//h16UG91jbOVd8/hpci1SEs8XSYaIF+zxDNAfZ0N8xIAjxxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6398.namprd11.prod.outlook.com (2603:10b6:8:c9::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.33; Fri, 27 Oct 2023 09:29:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::9704:bf7c:b79f:9981]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::9704:bf7c:b79f:9981%6]) with mapi id 15.20.6933.022; Fri, 27 Oct 2023
 09:29:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xin@zytor.com" <xin@zytor.com>
CC:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v2 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaCDGt7gtGIbqS8UeH/Bi4AVHQGbBdX8kA
Date:   Fri, 27 Oct 2023 09:29:32 +0000
Message-ID: <4aff0cdcd6ae3b5998ac963df1eee31166caef1c.camel@intel.com>
References: <20231026172530.208867-1-xin@zytor.com>
In-Reply-To: <20231026172530.208867-1-xin@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB6398:EE_
x-ms-office365-filtering-correlation-id: e1f46531-c10d-4b18-f469-08dbd6cf3a43
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fUp6I4pZ6hVu3AMcq25Lq4Y1DwOIIjOI8n1YZHkEHby9RgJjdc72s/RMcczubqGExxk1Rude6rJjyP9ZBtrIYPo7/b4PGzXNwHNYowh2lKyC84PQiSCc+yZjfkIb0VOVu5q/9rk1ILGA1KBzlwKV+u6SbjFlEIE1YNNVAX6gDKMvuPrRswmF4PIDSRYC3hWD6BAo55XFezx1QZUPmkWtfnPpllxhhruimYx7zfSW3mg21c2dYhUqxI+eqSrNxgi7b1tswlYU0+0woleYw7HSjc/3P6hq2FKCxmh3Rlpks4aAJFXxyt50fnmAesBZ+uULF/mWqSUxPAXZWtiLDy9Yci/kkLjOPQ9HXlGo8CSq+MMZVqJRM5U/KAUUL/TmxG2yzOoFL1vptcF1f203My8ElWpoKPWxfURAl5DC+ulB5fg53429SXFOGL9xfoItbgsUD7AVgb8Q57yJVT4Zp5PbwUoenhIZuKBNiS5H+jp1YE+6DiYxrkCi1EmJIrAb2NeGi7RQ9uYPC3zz4Mv+56BQneyeHb6Nz+M7VJrTO14mQumzOeIRMnc7BlDQCWrfci+eAUDneK3uUlg++7j5wMqpLubRhyOw4tuZT73rrUoFsdg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(346002)(396003)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38070700009)(38100700002)(41300700001)(110136005)(2906002)(26005)(86362001)(7416002)(4326008)(36756003)(8936002)(122000001)(8676002)(6506007)(316002)(91956017)(71200400001)(66446008)(82960400001)(2616005)(66556008)(64756008)(76116006)(54906003)(478600001)(966005)(66476007)(83380400001)(5660300002)(6512007)(6486002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1BFNWRQVVJza25iek4wRmxWeTNtU2Nsd3UrbVM0bjJSNXBnaXhtQ2k5eE9I?=
 =?utf-8?B?b2c3YTJJZlAralhkblZLbFRJQmRrM3dJemJwMndLRlIweHFvSlVFeUFrWDg5?=
 =?utf-8?B?SGJONFBmdnA3YlExNUFCd3BmN1pQY3A3M2NkU2lzaVgrUmEwbWpxcnN1Rkdj?=
 =?utf-8?B?ZzlWQmVpTEVkKys1WWtScFBLR1ZuYVNWcjVYY1lEeWdFUTliRS9PNFpOazlt?=
 =?utf-8?B?VEdXek9iZGl4K3NhbE9VRFhHcGxUWFRkRzhNMURsa1dFM2RwZDliMzlYbkZK?=
 =?utf-8?B?MHpYNkZrZjNVaWF5djBCS0lGUFdPUEduS0xoQlhBZFVnSVRpNm8vUDJLdnp1?=
 =?utf-8?B?dU1IRkp3Tm0zdEViNzRMTFV0MTZFK0czK1RoU3dFNktETmJMd3JKczNjcnRv?=
 =?utf-8?B?K2s3bVBqbklHMGo0MTJ6WVNFME1Nc09kWkdUMUtYelQ2dXRJbVpuRlFoM2ZN?=
 =?utf-8?B?ampSWUJMSU5oT09rSDhsQ0FzWThSV0g1WGg0dXUyQnVQTEpweG4wNGhtUHBP?=
 =?utf-8?B?K2FBcFp1S2U0OUFnbXBKa240WW5zVVc1RG1Ld0NuRCt6KzZjL3c1U0xlRUQ1?=
 =?utf-8?B?RHRvcSthMjh5R1RRR2c4OXVYN05oRVlEdnQ0Y1RpV1NIdlpLMEszRUp4Q24r?=
 =?utf-8?B?eXpFQ0JneFQ3OHZzd2pVTTBsdUxYKzZDbU1XYVpQNndFTEp5TDRCWmErNzY4?=
 =?utf-8?B?TnFzZmNQeTgxSUpRRGlYV0ExZGN2V1poR0d3azltM3lQUjIxTi82emlEYTkv?=
 =?utf-8?B?S3U4aFIvSkhRMEs5bkFmSjJHVzJJcmRJZUtJdE14R3AzZHM2VHZZUjU1NHVi?=
 =?utf-8?B?bmlNeXhmM0w0aHZKRzZ3VDZsWXR5aExRaFNYY1dLUXo2aml4c1lic2MwL01O?=
 =?utf-8?B?VXhuYzdqL21VdEhZQ0xQTytRa1p3Ykk1V1FDeHcyYXE1YWVEQ0tabEZid3FF?=
 =?utf-8?B?eHJjYTN2QnE3aGJ6OHlpSVMwS3EvZGFOcEc3dDlVTGNUZUhLTEpTbzdvU04w?=
 =?utf-8?B?S3B5UmdRcHhoazJmdlZ5UEtYM0JaS3NuTnB2WDZjWk8wUUJUR1hObzE0Y2JU?=
 =?utf-8?B?ZURYZGZmSnF0dEo1ek9TNzM5N1dNYm9oTnduc2JOUjB1eUV3Q2M1ekFVcVkz?=
 =?utf-8?B?MzVvamM1d2VkMGNSaFV1QWhvWW9mdGdIeC8vMmxjazh6UkdsS1FOVFdDZ0lD?=
 =?utf-8?B?bXBVSW82NDhaMmZjMHlUYjlpb1NpNHJxOUtOR1BzcnBmM0tEU3NXekdwczlK?=
 =?utf-8?B?V0VtZk0xQlQyVlpwajg5RzFKdmNuNWZBbjY5ZmVGYmRCQlpkWHJRbVJvNDdv?=
 =?utf-8?B?K3QwOHI4MVVyU21hNUNEVTFpcUNQR0JQVHhHWmFabXFqQ3FDSWo4clJlRFVE?=
 =?utf-8?B?YTNBLzRycUF4RDV1cjIwL1g3WUFxSzY3ZDdFR2tVdzZXSGZ4T0JXZWJrT0ty?=
 =?utf-8?B?L21WVVhpZ25SUnVNRS9GNXhycGpTbDk1dlR6eWlTbnBRUGU5blJMamdsT3gx?=
 =?utf-8?B?akYwNU1Qb0paZVhGaG1JSTc2dW1yVzZPU1V3SkVMaG1EaFJiSVF6Z0d2WVhw?=
 =?utf-8?B?N2g4WnlGOUs4alA5bURRcE8wUytPM0NuWVpRQ3dITVVLM2xuN0VYTENvSks1?=
 =?utf-8?B?RGFCcUVBeFJPQ1o5bE9YTVE3cUJUc1JFVmFvbytVQkpCVHFLWlRLMG95c3ZI?=
 =?utf-8?B?WWsxQWdUbGtVTEJsOGh6cHU3VTAyNHF1TmcxMG0vV3grVWFlYXNXbWRQNGtK?=
 =?utf-8?B?eHFQaUt6cVdhTkthOVpmWUxTSlJZcER6aTdvS0F0RjRVckZYOE1hdlBNdjgv?=
 =?utf-8?B?ZXVUVjdTTmtLWW0yOVcxa3BJbmVjZ2tmZWZFempDclU1dGp0enp2aU13aXdD?=
 =?utf-8?B?UWdaWTg4SWY2TUpIbFB6L1hhZytMazZhZTNTaFVKdW1zMyswaHRGNVlmbkRU?=
 =?utf-8?B?ZnF6NnBVa0lCUVFmSTdycGNyK2pEenowVUpRZlgzRUhkS29TMTgxME5lWlhR?=
 =?utf-8?B?c3pqeEUxclcrMEM3SjhXdVA4L1NQZ0pPMVRsU2ppRkV5NytoT2xsLzZ0eUFx?=
 =?utf-8?B?UGIyS20vc0ZHSFRqV1kzT1lPNHdwM2tTMWF3QTNtZjJNWXUxalVHdnNOWlly?=
 =?utf-8?B?MzVWZ0tGbVJWMTNMZmVITkZleGwvQlQ5TlB6L1lZZ2QxQ3VYNTlkMDB0a3Fx?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A686701DF22ED4C986190ACED3E0159@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f46531-c10d-4b18-f469-08dbd6cf3a43
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2023 09:29:32.6584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X3d6C16RrnZ4C/mg+1CZXTc1Ct+OQrWlGug0SSZj8NWdJSOIwe+JR2Gr8aFW3UhYl8nOVVYho5HNVRg4DAropg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6398
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ICANCj4gKy8qIFZNWF9CQVNJQyBiaXRzIGFuZCBiaXRtYXNrcyAqLw0KPiArI2RlZmluZSBW
TVhfQkFTSUNfMzJCSVRfUEhZU19BRERSX09OTFkJCUJJVF9VTEwoNDgpDQo+ICsjZGVmaW5lIFZN
WF9CQVNJQ19NRU1fVFlQRV9XQgkJCTZMTFUNCg0KU3RyaWN0bHkgc3BlYWtpbmcsIFZNWF9CQVNJ
Q19NRU1fVFlQRV9NQiBpc24ndCBhbnkgYml0IGRlZmluaXRpb24gb3IgYml0bWFza3Mgb2YNClZN
WF9CQVNJQyBNU1IuICBTbyBwZXJoYXBzIGJldHRlciB0byBwdXQgaXQgc29tZXdoZXJlIHVuZGVy
IHNlcGFyYXRlbHkuDQogDQo+ICsjZGVmaW5lIFZNWF9CQVNJQ19JTk9VVAkJCQlCSVRfVUxMKDU0
KQ0KPiArDQo+ICsvKiBWTVhfTUlTQyBiaXRzIGFuZCBiaXRtYXNrcyAqLw0KDQpZb3VyIG5leHQg
cGF0Y2ggaXMgdG8gIkNsZWFudXAgVk1YIG1pc2MgaW5mb3JtYXRpb24gZGVmaW5lcyBhbmQgdXNh
Z2VzIiwgc28gSQ0KZ3Vlc3MgaXQncyBiZXR0ZXIgdG8gbW92ZSBhbnkgVk1YX01JU0MgcmVsYXRl
ZCBjaGFuZ2UgdG8gdGhhdCBwYXRjaC4NCg0KPiAgI2RlZmluZSBWTVhfTUlTQ19QUkVFTVBUSU9O
X1RJTUVSX1JBVEVfTUFTSwkweDAwMDAwMDFmDQo+ICAjZGVmaW5lIFZNWF9NSVNDX1NBVkVfRUZF
Ul9MTUEJCQkweDAwMDAwMDIwDQo+ICAjZGVmaW5lIFZNWF9NSVNDX0FDVElWSVRZX0hMVAkJCTB4
MDAwMDAwNDANCj4gQEAgLTE0Myw2ICsxNDksMTYgQEAgc3RhdGljIGlubGluZSB1MzIgdm14X2Jh
c2ljX3ZtY3Nfc2l6ZSh1NjQgdm14X2Jhc2ljKQ0KPiAgCXJldHVybiAodm14X2Jhc2ljICYgR0VO
TUFTS19VTEwoNDQsIDMyKSkgPj4gMzI7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbmxpbmUgdTMy
IHZteF9iYXNpY192bWNzX2Jhc2ljX2NhcCh1NjQgdm14X2Jhc2ljKQ0KPiArew0KPiArCXJldHVy
biAodm14X2Jhc2ljICYgR0VOTUFTS19VTEwoNjMsIDQ1KSkgPj4gMzI7DQo+ICt9DQo+ICsNCj4g
K3N0YXRpYyBpbmxpbmUgdTMyIHZteF9iYXNpY192bWNzX21lbV90eXBlKHU2NCB2bXhfYmFzaWMp
DQo+ICt7DQo+ICsJcmV0dXJuICh2bXhfYmFzaWMgJiBHRU5NQVNLX1VMTCg1MywgNTApKSA+PiA1
MDsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGlubGluZSBpbnQgdm14X21pc2NfcHJlZW1wdGlvbl90
aW1lcl9yYXRlKHU2NCB2bXhfbWlzYykNCj4gIHsNCj4gIAlyZXR1cm4gdm14X21pc2MgJiBWTVhf
TUlTQ19QUkVFTVBUSU9OX1RJTUVSX1JBVEVfTUFTSzsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS92bXgvbmVzdGVkLmMgYi9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+IGluZGV4IDRi
YTQ2ZTFiMjlkMi4uMjc0ZDQ4MGQ5MDcxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14
L25lc3RlZC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMNCj4gQEAgLTEyMDEs
MjMgKzEyMDEsMzQgQEAgc3RhdGljIGJvb2wgaXNfYml0d2lzZV9zdWJzZXQodTY0IHN1cGVyc2V0
LCB1NjQgc3Vic2V0LCB1NjQgbWFzaykNCj4gIAlyZXR1cm4gKHN1cGVyc2V0IHwgc3Vic2V0KSA9
PSBzdXBlcnNldDsNCj4gIH0NCj4gIA0KPiArI2RlZmluZSBWTVhfQkFTSUNfVk1DU19TSVpFX1NI
SUZUCQkzMg0KPiArI2RlZmluZSBWTVhfQkFTSUNfRFVBTF9NT05JVE9SX1RSRUFUTUVOVAlCSVRf
VUxMKDQ5KQ0KPiArI2RlZmluZSBWTVhfQkFTSUNfTUVNX1RZUEVfU0hJRlQJCTUwDQo+ICsjZGVm
aW5lIFZNWF9CQVNJQ19UUlVFX0NUTFMJCQlCSVRfVUxMKDU1KQ0KDQpJZiBJIGFtIHJlYWRpbmcg
Y29ycmVjdGx5LCB0aGUgdHdvICIqX1NISUZUIiBhYm92ZSBhcmUgbm90IHVzZWQ/ICBUaGUgYWJv
dmUNCnZteF9iYXNpY192bWNzX21lbV90eXBlKCkgYW5kIHZteF9iYXNpY192bWNzX2Jhc2ljX2Nh
cCgpIHVzZSBoYXJkLWNvZGVkIHZhbHVlcw0KZGlyZWN0bHkuDQoNCkFuZCBIb3cgYWJvdXQgbW92
aW5nIGFsbCB0aGVzZSBiaXQvbWFzayBkZWZpbml0aW9ucyB0byA8YXNtL3ZteC5oPiBhYm92ZT8N
Cg0KSXQncyBiZXR0ZXIgdGhleSBzdGF5IHRvZ2V0aGVyIGZvciBiZXR0ZXIgcmVhZGFiaWxpdHku
DQoNCj4gKw0KPiArI2RlZmluZSBWTVhfQkFTSUNfRkVBVFVSRVNfTUFTSwkJCVwNCj4gKwkoVk1Y
X0JBU0lDX0RVQUxfTU9OSVRPUl9UUkVBVE1FTlQgfAlcDQo+ICsJIFZNWF9CQVNJQ19JTk9VVCB8
CQkJXA0KPiArCSBWTVhfQkFTSUNfVFJVRV9DVExTKQ0KPiArDQo+ICsjZGVmaW5lIFZNWF9CQVNJ
Q19SRVNFUlZFRF9CSVRTCQkJXA0KPiArCShHRU5NQVNLX1VMTCg2MywgNTYpIHwgR0VOTUFTS19V
TEwoNDcsIDQ1KSB8IEJJVF9VTEwoMzEpKQ0KPiArDQoNCkFsc28gbW92ZSB0aGVzZSB0byA8YXNt
L3ZteC5oPj8NCg0KPiAgc3RhdGljIGludCB2bXhfcmVzdG9yZV92bXhfYmFzaWMoc3RydWN0IHZj
cHVfdm14ICp2bXgsIHU2NCBkYXRhKQ0KPiAgew0KPiAtCWNvbnN0IHU2NCBmZWF0dXJlX2FuZF9y
ZXNlcnZlZCA9DQo+IC0JCS8qIGZlYXR1cmUgKGV4Y2VwdCBiaXQgNDg7IHNlZSBiZWxvdykgKi8N
Cj4gLQkJQklUX1VMTCg0OSkgfCBCSVRfVUxMKDU0KSB8IEJJVF9VTEwoNTUpIHwNCj4gLQkJLyog
cmVzZXJ2ZWQgKi8NCj4gLQkJQklUX1VMTCgzMSkgfCBHRU5NQVNLX1VMTCg0NywgNDUpIHwgR0VO
TUFTS19VTEwoNjMsIDU2KTsNCj4gIAl1NjQgdm14X2Jhc2ljID0gdm1jc19jb25maWcubmVzdGVk
LmJhc2ljOw0KPiAgDQo+IC0JaWYgKCFpc19iaXR3aXNlX3N1YnNldCh2bXhfYmFzaWMsIGRhdGEs
IGZlYXR1cmVfYW5kX3Jlc2VydmVkKSkNCj4gKwlzdGF0aWNfYXNzZXJ0KCEoVk1YX0JBU0lDX0ZF
QVRVUkVTX01BU0sgJiBWTVhfQkFTSUNfUkVTRVJWRURfQklUUykpOw0KPiArDQo+ICsJaWYgKCFp
c19iaXR3aXNlX3N1YnNldCh2bXhfYmFzaWMsIGRhdGEsDQo+ICsJCQkgICAgICAgVk1YX0JBU0lD
X0ZFQVRVUkVTX01BU0sgfCBWTVhfQkFTSUNfUkVTRVJWRURfQklUUykpDQo+ICAJCXJldHVybiAt
RUlOVkFMOw0KPiAgDQo+ICAJLyoNCj4gIAkgKiBLVk0gZG9lcyBub3QgZW11bGF0ZSBhIHZlcnNp
b24gb2YgVk1YIHRoYXQgY29uc3RyYWlucyBwaHlzaWNhbA0KPiAgCSAqIGFkZHJlc3NlcyBvZiBW
TVggc3RydWN0dXJlcyAoZS5nLiBWTUNTKSB0byAzMi1iaXRzLg0KPiAgCSAqLw0KPiAtCWlmIChk
YXRhICYgQklUX1VMTCg0OCkpDQo+ICsJaWYgKGRhdGEgJiBWTVhfQkFTSUNfMzJCSVRfUEhZU19B
RERSX09OTFkpDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+ICAJaWYgKHZteF9iYXNpY192
bWNzX3JldmlzaW9uX2lkKHZteF9iYXNpYykgIT0NCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2
bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IGluZGV4IDRjM2E3MGYyNmI0
Mi4uYjY4ZDU0ZjZlOWY4IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+
ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gQEAgLTI1NjgsMTQgKzI1NjgsMTMgQEAg
c3RhdGljIHU2NCBhZGp1c3Rfdm14X2NvbnRyb2xzNjQodTY0IGN0bF9vcHQsIHUzMiBtc3IpDQo+
ICBzdGF0aWMgaW50IHNldHVwX3ZtY3NfY29uZmlnKHN0cnVjdCB2bWNzX2NvbmZpZyAqdm1jc19j
b25mLA0KPiAgCQkJICAgICBzdHJ1Y3Qgdm14X2NhcGFiaWxpdHkgKnZteF9jYXApDQo+ICB7DQo+
IC0JdTMyIHZteF9tc3JfbG93LCB2bXhfbXNyX2hpZ2g7DQo+ICAJdTMyIF9waW5fYmFzZWRfZXhl
Y19jb250cm9sID0gMDsNCj4gIAl1MzIgX2NwdV9iYXNlZF9leGVjX2NvbnRyb2wgPSAwOw0KPiAg
CXUzMiBfY3B1X2Jhc2VkXzJuZF9leGVjX2NvbnRyb2wgPSAwOw0KPiAgCXU2NCBfY3B1X2Jhc2Vk
XzNyZF9leGVjX2NvbnRyb2wgPSAwOw0KPiAgCXUzMiBfdm1leGl0X2NvbnRyb2wgPSAwOw0KPiAg
CXUzMiBfdm1lbnRyeV9jb250cm9sID0gMDsNCj4gLQl1NjQgbWlzY19tc3I7DQo+ICsJdTY0IHZt
eF9iYXNpYzsNCj4gIAlpbnQgaTsNCj4gIA0KPiAgCS8qDQo+IEBAIC0yNjkzLDI4ICsyNjkyLDI2
IEBAIHN0YXRpYyBpbnQgc2V0dXBfdm1jc19jb25maWcoc3RydWN0IHZtY3NfY29uZmlnICp2bWNz
X2NvbmYsDQo+ICAJCV92bWV4aXRfY29udHJvbCAmPSB+eF9jdHJsOw0KPiAgCX0NCj4gIA0KPiAt
CXJkbXNyKE1TUl9JQTMyX1ZNWF9CQVNJQywgdm14X21zcl9sb3csIHZteF9tc3JfaGlnaCk7DQo+
ICsJcmRtc3JsKE1TUl9JQTMyX1ZNWF9CQVNJQywgdm14X2Jhc2ljKTsNCj4gIA0KPiAgCS8qIElB
LTMyIFNETSBWb2wgM0I6IFZNQ1Mgc2l6ZSBpcyBuZXZlciBncmVhdGVyIHRoYW4gNGtCLiAqLw0K
PiAtCWlmICgodm14X21zcl9oaWdoICYgMHgxZmZmKSA+IFBBR0VfU0laRSkNCj4gKwlpZiAoKHZt
eF9iYXNpY192bWNzX3NpemUodm14X2Jhc2ljKSA+IFBBR0VfU0laRSkpDQo+ICAJCXJldHVybiAt
RUlPOw0KPiAgDQo+ICAjaWZkZWYgQ09ORklHX1g4Nl82NA0KPiAgCS8qIElBLTMyIFNETSBWb2wg
M0I6IDY0LWJpdCBDUFVzIGFsd2F5cyBoYXZlIFZNWF9CQVNJQ19NU1JbNDhdPT0wLiAqLw0KPiAt
CWlmICh2bXhfbXNyX2hpZ2ggJiAoMXU8PDE2KSkNCj4gKwlpZiAodm14X2Jhc2ljICYgVk1YX0JB
U0lDXzMyQklUX1BIWVNfQUREUl9PTkxZKQ0KPiAgCQlyZXR1cm4gLUVJTzsNCj4gICNlbmRpZg0K
PiAgDQo+ICAJLyogUmVxdWlyZSBXcml0ZS1CYWNrIChXQikgbWVtb3J5IHR5cGUgZm9yIFZNQ1Mg
YWNjZXNzZXMuICovDQo+IC0JaWYgKCgodm14X21zcl9oaWdoID4+IDE4KSAmIDE1KSAhPSA2KQ0K
PiArCWlmICh2bXhfYmFzaWNfdm1jc19tZW1fdHlwZSh2bXhfYmFzaWMpICE9IFZNWF9CQVNJQ19N
RU1fVFlQRV9XQikNCj4gIAkJcmV0dXJuIC1FSU87DQo+ICANCj4gLQlyZG1zcmwoTVNSX0lBMzJf
Vk1YX01JU0MsIG1pc2NfbXNyKTsNCj4gLQ0KPiAtCXZtY3NfY29uZi0+c2l6ZSA9IHZteF9tc3Jf
aGlnaCAmIDB4MWZmZjsNCj4gLQl2bWNzX2NvbmYtPmJhc2ljX2NhcCA9IHZteF9tc3JfaGlnaCAm
IH4weDFmZmY7DQo+ICsJdm1jc19jb25mLT5zaXplID0gdm14X2Jhc2ljX3ZtY3Nfc2l6ZSh2bXhf
YmFzaWMpOw0KPiArCXZtY3NfY29uZi0+YmFzaWNfY2FwID0gdm14X2Jhc2ljX3ZtY3NfYmFzaWNf
Y2FwKHZteF9iYXNpYyk7DQo+ICANCj4gLQl2bWNzX2NvbmYtPnJldmlzaW9uX2lkID0gdm14X21z
cl9sb3c7DQo+ICsJdm1jc19jb25mLT5yZXZpc2lvbl9pZCA9IHZteF9iYXNpY192bWNzX3Jldmlz
aW9uX2lkKHZteF9iYXNpYyk7DQoNCkkgYWN0dWFsbHkgdHJpZWQgdG8gZG8gc2ltaWxhciB0aGlu
ZyBiZWZvcmUsIGFuZCBTZWFuIGdhdmUgbWUgYmVsb3cgYWR2aWNlOg0KDQoJUmF0aGVyIHRoYW4g
ZG8gYWxsIG9mIHRoZXNlIHdlaXJkIGRhbmNlcywgd2hhdCBhYm91dCBzYXZpbmcgdGhlDQpmdWxs
L3Jhdw0KCU1TUiBpbiB0aGUgY29uZmlnLCBhbmQgdGhlbiB1c2luZyB0aGUgaGVscGVycyB0byBl
eHRyYWN0IGluZm8gYXMNCm5lZWRlZD8gDQoNCmh0dHBzOi8vbGttbC5rZXJuZWwub3JnL2t2bS8y
MDIzMDMzMDA5MjE0OS4xMDEwNDctMS1rYWkuaHVhbmdAaW50ZWwuY29tL1QvI200ODc5YTNjN2U2
NmVkZTdiZmE1NjhhMjVhZWE0ZjZlMzc3OGU2ZTM0DQoNCkkgYWdyZWVkLCBidXQgSSBoYXMgYmVl
biB0b28gbGF6eSB0byBkbyB0aGlzLCBzb3JyeSA6LSkNCg0KU28gbWF5YmUgd2Ugc2hvdWxkIHN0
aWxsIGdvIHdpdGggdGhpcyBhcHByb2FjaD8NCg0KPiAgDQo+ICAJdm1jc19jb25mLT5waW5fYmFz
ZWRfZXhlY19jdHJsID0gX3Bpbl9iYXNlZF9leGVjX2NvbnRyb2w7DQo+ICAJdm1jc19jb25mLT5j
cHVfYmFzZWRfZXhlY19jdHJsID0gX2NwdV9iYXNlZF9leGVjX2NvbnRyb2w7DQo+IEBAIC0yNzIy
LDcgKzI3MTksOCBAQCBzdGF0aWMgaW50IHNldHVwX3ZtY3NfY29uZmlnKHN0cnVjdCB2bWNzX2Nv
bmZpZyAqdm1jc19jb25mLA0KPiAgCXZtY3NfY29uZi0+Y3B1X2Jhc2VkXzNyZF9leGVjX2N0cmwg
PSBfY3B1X2Jhc2VkXzNyZF9leGVjX2NvbnRyb2w7DQo+ICAJdm1jc19jb25mLT52bWV4aXRfY3Ry
bCAgICAgICAgID0gX3ZtZXhpdF9jb250cm9sOw0KPiAgCXZtY3NfY29uZi0+dm1lbnRyeV9jdHJs
ICAgICAgICA9IF92bWVudHJ5X2NvbnRyb2w7DQo+IC0Jdm1jc19jb25mLT5taXNjCT0gbWlzY19t
c3I7DQo+ICsNCj4gKwlyZG1zcmwoTVNSX0lBMzJfVk1YX01JU0MsIHZtY3NfY29uZi0+bWlzYyk7
DQoNCkJldHRlciB0byBtb3ZlIFZNWF9NSVNDIGNvZGUgdG8gbmV4dCBwYXRjaCBJIHN1cHBvc2Uu
DQo=
