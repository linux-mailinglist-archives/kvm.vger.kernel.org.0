Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4757445F1
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 03:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjGAByT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjGAByS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 21:54:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABB23C01;
        Fri, 30 Jun 2023 18:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688176457; x=1719712457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gntnGLJZfcfLPOtRF3tbu0O10uyDGIkIjzeN1xT7zSo=;
  b=K0FuX8pUUJooPYWLCS7DMqSO3q3wEsdHIjg1s5QaJR/DCE6T1VbulhtF
   lR6YahGNwQ2anQvrrdBNgB0ReaI+ERS4FGSh5sCW065gqzpC61ei98ouc
   KY5xijE7QwWTnGqL+xdxxron2hpp+YsoGLnUQYlWrbPYqzbPlWcNTaIGN
   y1dgoK2wGZNlwIeVLoNzDjiBOun2ItotoX76YWUH901mpA0VFeiHQvOLU
   f8vLSfrEJxf4hkTTcqkjdz7iGWM1Ne0D4o0JZBhN/THH2YAgiqxAbtEih
   tAXdplHlqTwgtWueoaRprQBjgZr1M1V3IVu79O6DIkKeZjOFM1LgIUqKf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365110233"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="365110233"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 18:54:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="718006830"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="718006830"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 30 Jun 2023 18:54:16 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 18:54:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 18:54:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 18:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3y5o//GZtWyvPSZrhw52Js9PROzQrJBfm12vlgFIUWZruLt1bZN6KrHt26qGcNVShWoNOxW7QDOebFR9NI5k5L4bCKBfBfLZB6MywCk/Ez6wiyHHPS4GmlsjFO+yUmyAXz9CjRCXBpI3LGzhrPpPkmQUlWU5GpS7U4a1Z6Hzveyk9UvsFO7GrnGXUX9lsmU9V2DZyccTSLi9h/q1wU/gYgIUhfmTj76d+STChzxYR2QcwasMOWReoZy0mf9sXaKwwSeTIMBDTM94xAhWqAw5vfj/i2GJtBk94wvNpifxu7RN5H5Boa4g7CT0k5o+GRWdatb1nQ105V0JcyTgfd23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THAUjOQsAni6i7aucp1MIfH2mNxBdtFHbfPywbx/StI=;
 b=eteMeQZBBQ/+gr7CBY2gZr2TSgUaanxH3CtsZ7+bRx6tCeKlpp3w/J4F65+MvhDnEAKrrWdAmn0LEVWdQMh9Zd2OS6I99cP+RJDNyzUmDYNrPeGQ64aYsWf0V587Em/AfF1c1yKhmyT8OJSYsrLmAFGuIoCADipCxDhno6qpi9fsdvXy0yZ05JZuChpwSvXfEmb0BIJv7v3xkVD2d2wiasFdMiphNlweQpV3EWAFjFtq7HQehIO8h31+hB/rYC/ZhuM5PLiuCPM4qiwCt0aRaTmx8kiqc2MOQnvqCCsv1RkrXikBqcViuFdQfIdD7i7/sh3cT5Or18+1pgUVjdvzNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Sat, 1 Jul
 2023 01:54:12 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.024; Sat, 1 Jul 2023
 01:54:11 +0000
Message-ID: <23527062-e7cd-ce06-ba96-f3f3a81518b2@intel.com>
Date:   Sat, 1 Jul 2023 09:54:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
To:     "Neiger, Gil" <gil.neiger@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
 <ZJ6uKZToMPfwoXW6@chao-email>
 <8dec8b09-2568-a664-e51d-e6ff9f49e7de@intel.com>
 <CO1PR11MB5107FBC68DBA6877E390A633912AA@CO1PR11MB5107.namprd11.prod.outlook.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <CO1PR11MB5107FBC68DBA6877E390A633912AA@CO1PR11MB5107.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 6350282a-cd74-412a-cf92-08db79d6105e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qd/vNHpNjghj7r6Ih/CW8ThWOeM7pIDmW2HhpiiJkx5Wb8/5XpM5HVFDKc+ZqCNXKCQAMI2RrrEyLMeYMiro5gmFGwpid1lBj7kJTdwWa7UM51SW9zDDWM9mhZgW0YB9LoDS+mmcgBtAxd9my7/NUhYY7+fMj34vSPugi67rldYFjbiBA2rTPM6D9twTBTy9FAmGqGaOoIilj9Cfmnj6hfBJHjRGC784371IsdkaAi/O06nc5UcOQEZnc9W4+dLaVml3Uv04+EV5cVR2+jy47sK2xiTadPaL/T5AEJ6DzdZrzyiBC65zHtsrcatgaK8ZrfSbSUIpXyQOc8oi6gVYbXaqwq6lIraRTUeXF9SvtSOUVMRoLReRcw+pmdaEKtl6W4v7Lr9ljLhElCbRfbSyrN4n9cyqxxJZidS5y4uCm2TTODEAxR1LZQSa58pXU2n6FlOe1Jlai5MKaiBBt6gBqY+NLesBIQifGfZ/nLqqUyyzbOAeGLLluGq568jsePpZ9Bwr7K68RyNC5vnXAKf8KSRzx+9VAKSwONBKIvCthJ73EUpp3RL5z9wWg0xB51NZSK71jW1B37dMTu3pNwsrLorYQP8W/nhdNutA0nzHBjfnuIdQ3vXZgupO9v7alnwOnuaZlftLAeL0aVx/TAIW7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(53546011)(6666004)(6486002)(54906003)(110136005)(83380400001)(6506007)(2906002)(6512007)(2616005)(26005)(186003)(478600001)(5660300002)(36756003)(316002)(4326008)(31696002)(6636002)(82960400001)(66946007)(38100700002)(8936002)(41300700001)(66556008)(86362001)(66476007)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0xkbkxvbjQ3SkI2VmRPMS91SExucll4RkNBcHByV2FENXB5SDJ6S3FUUWU5?=
 =?utf-8?B?cnRib2N3ekRJenZYM0FJa2VURjFOVE1kVUxuRlEwc0lWOW9IS0VBU1FmR0U3?=
 =?utf-8?B?S0toemRHdU8vdlhXZWI0WDdMV2krYU9mUkNuLy9ONUVUVjkzVVFhK2w3cFNK?=
 =?utf-8?B?SEZqRExENkVrWEtGQjcrUkxrOGd4RkVIMXBkVS9XdGswNGdJUFRRMEh3OGxU?=
 =?utf-8?B?b29xeGJjVEV4OWhORE9pY2tMQmphckpLZVUvWFFnbEIxSWJOZzY2bktIMnFy?=
 =?utf-8?B?Wk05K0JETUpLYTI1bGVPMW5TVHBDRGpDWlhKYmJ2dWlXNC9xRzR4OEUxVjh1?=
 =?utf-8?B?Y0tuanVpbG04Q1VXZGoxbEcwSUpnZ0Z4VmJXMXBsOEFySVdpVlp6R0JiN0xN?=
 =?utf-8?B?TmwwcjB6dTNWY293L0dlY3cwSU9QYzgrbG9zRmtOSlJOV0lycEl2WVJDZWdk?=
 =?utf-8?B?MVRQSlJ0V0tDeFI2U3F1ZVJvMkFHNW50MHordmlWc2EyeDRDdnpxNjZHZmJZ?=
 =?utf-8?B?WG9yRm55aHNCcXVndGo4Ty9FcytSOHZyNHRnN3cwQkxFUUlUVHVJSVNCdHJV?=
 =?utf-8?B?R0g2V20ycVlETWIxbmZlOTFiWFIzRit6cmVRYTJXMlQrWDZMaVVKS05DSnYw?=
 =?utf-8?B?VG1jT1ZNeWp5MVpTQkNtVzBnOVFCWkRZanFzYTg0QUNhTENhVUV5dyt3YWkx?=
 =?utf-8?B?UWo3WDlWbVlwNklSNHU2QTVRUUFqeXVSaXo2aUtIVHlBVEV4akVjL2sxVVpx?=
 =?utf-8?B?VXFsY3hSNnpZRitGVzdrT0lHZzlmTDlXa0lMUmorUHVqbFNjeG5hazIwdFIy?=
 =?utf-8?B?T2UwQjZ1YUs1VGcvejREaXBUTWZoODQrRUY5WnFiV0tzY0ZZcEpSNWlNdEox?=
 =?utf-8?B?MUVEZjkxNEMxNm1ZUklJczJzdTFqeFB3ejZvTW0rY2h3cFBCQ204ZUJGZ0xk?=
 =?utf-8?B?OS9KVXlnZFRZS3MvOWx1UVlhYkNCVXN1UkRUb1ErNnVLSWpBcStQMThNWkRO?=
 =?utf-8?B?ZzBqa3dCODhhelUvMFJXWTR6OTdHYVprMVdhaVZ2WU14b2RzSHFVeWc4bXg0?=
 =?utf-8?B?L3NETTNaeW1Sa21kOGowcFlSY3RKUFpJSTYwYmowbDBybys0eTY3WHRqcmZa?=
 =?utf-8?B?eTNkeWFhdXdML0k4Ny9BbTlyREpIR1hEUk1FNC9ZdytqQ0tWNDIvcVVWVlNS?=
 =?utf-8?B?YUdGZjlvRURTWlNVZEg3R0hsWHI1blY3aXJxeW42S25sV2dFUTU4bVQzTkhO?=
 =?utf-8?B?ellNOVhjTmU0RU80anRBalBUOG81NThQbUtIc1ZwUHhSZjF0eERtbmpKR3R5?=
 =?utf-8?B?clA3Zzl5TVhQVFd5Rk5IeFNKaVpEcmtzdnFVTEp1VXY3bkpqeWFlVktZVHNK?=
 =?utf-8?B?eHJ3OWRGZEhFUzlZZmJVM01aWU5OTEh3NjRLUWs4SEhSR291b3VtcUFWVlhB?=
 =?utf-8?B?WFc4OWdNZFI5WGt2NnYrTytWYXpZS3ZNdk1BUmFYaDlCLytFQWpEMFNoYWlp?=
 =?utf-8?B?UG95RFdtMTJBb1pUdFV0K1B6Ymt5RnhWRllRQXoveEw3dkpId3lMKzNPU2g3?=
 =?utf-8?B?cDh3S0EzNlhaZFVtWHpiSGNnY3pDMmlWTkRsQkFHYjFZT3lrZWsyVW5LT1dM?=
 =?utf-8?B?dFJwcWdCSDJuQ1lSRTNja1Ezd0cwUFNwWHFGVDJyZ1BpWEFZQStCc21lamp0?=
 =?utf-8?B?dituR0VGTXJtUWt3cU44OGhkeVNPL3V6eUgxcWVzT0x5NE1FcDg0Nm5PNVBL?=
 =?utf-8?B?WXcxbHJQRUlJUDZET1pYdlFzbHd2QzlkTWtBTWxBZEpOdnhmRC83Y0tVODFS?=
 =?utf-8?B?UXRCOVNhRmR3K2xtRmw5eDRlWTdOVHhzTUNmc0krVldVY0kxcitUWURiNXdO?=
 =?utf-8?B?Y09RVWtJZmRqYUVDbVljZDRZdkNlMERkTGxPendaOGhndVcweGt6Tm5WWEs5?=
 =?utf-8?B?bWM3VUU0NFkyQmk4a2xYK2lPTm4xVDcyYm8zU0M3ZlIzdHZFdVlhS3FFY3hi?=
 =?utf-8?B?alplMWdMTkhUVklEemdrYUlzaVdhRlRSM1pVbWs2NVViMy9pR0VEVnNhYk5M?=
 =?utf-8?B?d3hYTG5RbzJ3cmhHSjl4YTFhdmdXcjBNblQ1NTNSbTRGeDZUZFl2K0dRdnR1?=
 =?utf-8?B?LzFyeHBPOUtoTnd0SmFOY0JZdGV0SS9BL3hnQmxSQUtjY2dpWGdBSEVXODRG?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6350282a-cd74-412a-cf92-08db79d6105e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2023 01:54:11.2130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBuYPPdfBQGU3orPwMPL9m6dM6CZT6qQ9hrCzTYFs/a8o5/l8ViwpeXW1wfrQtlt/eA2gMlDcBw95vI70QjDIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/30/2023 11:05 PM, Neiger, Gil wrote:
> Intel will not produce any CPU with CET that does not enumerate IA32_VMX_BASIC[56] as 1.
>
> One can check that bit before injecting a #CP with error code, but it should not be necessary if CET is enumerated.
>
> Of course, if the KVM may run as a guest of another VMM/hypervisor, it may be that the virtual CPU in which KVM operates may enumerate CET but clear the bit in IA32_VMX_BASIC.
>
> 				- Gil
Thanks Gil for clarity!
>
> -----Original Message-----
> From: Yang, Weijiang <weijiang.yang@intel.com>
> Sent: Friday, June 30, 2023 05:05
> To: Gao, Chao <chao.gao@intel.com>
> Cc: Christopherson,, Sean <seanjc@google.com>; pbonzini@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; peterz@infradead.org; rppt@kernel.org; binbin.wu@linux.intel.com; Edgecombe, Rick P <rick.p.edgecombe@intel.com>; john.allen@amd.com; Neiger, Gil <gil.neiger@intel.com>
> Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception classification
>
>
> On 6/30/2023 6:27 PM, Chao Gao wrote:
> [...]
