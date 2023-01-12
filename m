Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA526668A0
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 02:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbjALB5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 20:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjALB5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 20:57:46 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662961182C;
        Wed, 11 Jan 2023 17:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673488665; x=1705024665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O8n16ovo/4sKHN1MAIYykM19/udTIWfU8Hc5klP1LfE=;
  b=GEiEbwNVMXB9vVa4HeWf/odMEryJkkFP+AfxfMi4DFEOao3aj0uaN/oi
   nn7ruI43RrwABgY1HlJKb0FDEgiz7m+hJxgtsoIXTCcd0xA75kEDmUi5h
   UZLgVG9zLQ3+nO8ZGK7hyA5MDS1wWRETGW5bI+Yv1a9i3TS+QKhhSpSQE
   b2TBsdoDfliFsXYF4NWl6F1HP+6zIP6ZkZLmrcCWMq5pKQFoozTbj95z3
   acWidvvfhldL217JaFaspYEckzvomKU9TanwglDlJs7tmoOR91TJInIQs
   QgmrKkVMHNe0iPk5o9NzS5FUDVrcbVYuAXxalHasLIQ4MEePNuJhuSgsQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="303962037"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="303962037"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 17:57:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="635198062"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="635198062"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 11 Jan 2023 17:57:44 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 17:57:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 17:57:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 17:57:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfxVCsarHvNHMI1GRyuo06VoLoXfyMTvK7Fp3+a24OVNc0cWxLP7hBrwzvJu+07qBJf9RdpWuxjIVhKODrfv6ZPfFcoqGaJRb8lK0724t3q+uCMB/QJk96vV3YiJgYAv4vmISbSjd/ILV4k0QPvO12ammdlKgdA9c0TLumzLav40F5yDqrsaIPTNe7myWwVqmzNA2mrQVXKxgZf0iLofOY9222qZEliInS0EtwD8NoCXlFWBjoP0WmsfhP47q7tOYpP9Ppn9MLNZ+7lvJpwBO1Bs5dD1vOqwUpQtgcBeAGfQmWD2YIRp12eaH29H+R59cetpOA1+hx31RsfjGcc45A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCE5NGk0AmsUEIvVGLYSoaoRSNuLO8pnJjIajTHHvZc=;
 b=mFMfjq5XF9adNVyLHyyWEz0iGFiPSqO6qKg+2BKzfcxwRdg4f5EhEJkrfmV4QrtrsIiJ5JuGjZTaWY7GUPc8T4lWLNzDWpIdPiY4f/0eMOZIFk7VKmipwfdnzY3Tuy+d2QJkGi1aHbcfNve3FD2tytnFc8Z9RfkO3qfxOKbJwZlcLJTXNIMNkVOeUNgXxrOlY4r1isV0dV2Qe6ZtBeV3E3Vzoqofbaod/QCZDvOToaXeQZm620sRhcY0tlNFkHlk5O1YjH1ayUNllEzuuGBIVsHObQ9kn83rjPu01eHjNjBJmPcRG3Nu2iGfxY0Aor+0Ogi1UYuC+6e1QX9Tmq2edw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB6261.namprd11.prod.outlook.com (2603:10b6:8:a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 01:57:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%7]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 01:57:36 +0000
Message-ID: <7f63de4f-a690-e29b-f3d4-2397a3837ddc@intel.com>
Date:   Thu, 12 Jan 2023 09:57:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 00/15] Introduce Architectural LBR for vPMU
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0124.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::28) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: d9d13448-ccf2-4f15-2758-08daf440603d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IhV8cIorSi1/NsIaPAPDJ2/5Nl6aVJkK4NXqrW9Wb3b5DAlKYP7LlQ8cwxPJPzzYadD5Lmkzkwyt1AUtdiew7xAhIaZiCgha+pjRVnKaesof3VcuFYiDR+pmbebyaWbZPmPd33RQWexYoOWY1hDP7Lr7h9HMy1aJuaSh32T56Z/GK1zkeqoSLqcI7WdtQir/lU+LaJKyEi2F7YAbNmmxoOMUTXbYf0m50KmXHJG1gHBsblFs0ewl5tVFEYG394avkU0SItUttwWG4CdxmUsqHQ7yKMAoWEplpHFSZlHL8L9rJrVmbWGXO0eQHhaesST3kg+rgi19m35+W/fRUlE3jF08R9wIbEtJfn4Godr/kI+jHmePSB4UniGXxFWzVMRPoyqa0NHVi8NtsMWsAAQ9jDmZBp1Z8E1+XJwhHb2eh2WmrLf87TVGVsID4RQlIs2zQAsjT87pv1wepo04wviI/aXIaR2rzuVZhiTRsqJTG+KcnrJMUiRWD/6yxDuxDZGtaS4FzQxYdpW+hUgj+ILSsvfgR5WS1ZTHQ+2WSbwue1xSksCxuPOCF0imd5Gg+S1vSKeTemyKd9ef4+81tRNYfkdROZ9O3Uia2/c8WVlOOcGjZZrqDMKFwY5d5AfhW8WMnMk1IfzSd5IFEP9XGauK/KXsg3YuIWQLKqnPLqKY8Bnw1IjMNhh0QrZEHfdjR6t3+x/+1oz91VAtMAqpEKx8qErcKq2JFj/okLzAPC/G4Ums4PIGxxUXmpKQrQF9tppi4rOCHOysGMCXBE/dDZhLdFi2tzVzTJAnVoESbvO5Y/BVZpr/eOfgnfflZx06z0cV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(316002)(86362001)(26005)(6512007)(5660300002)(186003)(478600001)(6486002)(966005)(2616005)(41300700001)(31696002)(66556008)(66946007)(66476007)(54906003)(4326008)(6916009)(8676002)(8936002)(83380400001)(36756003)(6666004)(53546011)(31686004)(6506007)(82960400001)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0Y5V01TQ1BPUjMxeE5UTTRVMXdYRGdVaTdla3BHTDVPVnpxTlBUMEcrcThG?=
 =?utf-8?B?aDN5ODRTWjkzSndaMkFBaUxWTENycTVMc3V2TVY4dXJUNnZ3SGZ4T0IwZ0Va?=
 =?utf-8?B?eVlpVWRqa0kwam42U0RMNEdocng2YU4wT1AybkJnVzRhd2VMNTZqWjRmM2s3?=
 =?utf-8?B?ZUFEVFVSN0tyNkFXa2c5MHJsS0crU3pBTEVmdmM1K1NZbUZ2TmRsUWdxYzU4?=
 =?utf-8?B?dTZtQ1kvZCtOek5lZXBVYVZRQnBRUnQ1Vml0MnplTUdYUFlxdnNONm5nSEJB?=
 =?utf-8?B?bjNuTC9tajF4RFRRL0t6T0ZReHVOZ0dORHJiWU9HNVc4dHRncytWT05Gdm5r?=
 =?utf-8?B?eVVhT1lIUU5ER2hJbjVtb21lM0NHMHZTYjZrZ2RYL2tDNUI1c3kyTEczK2lM?=
 =?utf-8?B?NFArNktuUVE0MW9PYWhOaHNyQklEZlJHbG14R3ByN3ZOczdPMGlvcU9QSFY1?=
 =?utf-8?B?UGJ6NlN0S1pJcXM0UHMzQ0MxMEF0alB0T0lPS0Y1ZUt4Wk1OcVNrM2QxSGky?=
 =?utf-8?B?dHUxV0JLYlIxOG85NWdCZ0U0OEVXU3BwVWtsRHVGajdTdVROdDFHb29ZeC83?=
 =?utf-8?B?UDNEN3dBMWFyN2Z4QlVwaHNvN0VzeGVBRGR4SFl2ZVhrMHFrNUx0QVFlLzFD?=
 =?utf-8?B?NWNodVdhSlNEMXJ1MFVEOUNlbzFZWVNTNWZaa3k3NVprSFdGS3oyc0d1T1A3?=
 =?utf-8?B?Y1dEaWlIMk95bTl6WlZacyswMzgzelFoRU9aVUY3QUNHVCsrdnJ3ZUJiV2lP?=
 =?utf-8?B?Sm13bDVESjdUdHUwZ0pWdElGVXJOSko3V1lsNGhxL2JiZHhGeHFrSm9tY296?=
 =?utf-8?B?UXJLN28xMElJbXZqNmMyaGdvVDRYSjQ1RHlmRWl3VjhoOWxsQm0rd0pNVlRz?=
 =?utf-8?B?OGpMSFRDajZmZlVpU2p1dUkyK3ZPTjVtcXh1ZGtpa3M1TUtZYXZxODV0UGxw?=
 =?utf-8?B?bzhkUTV5MnJoZENuTTZ0YmJCRElNK09Na3l6aDUvN3Y0VjF2ZDU2WWp6WEpr?=
 =?utf-8?B?WVAwL0hBaWl6ekFIeHAwNyt3V2dFRUdBdzlvRUVNTnBJOXQwb1h1Y1prb1R0?=
 =?utf-8?B?T240aXhFY1Uwa2dFYVhGUC92QmR5RFhUakNyR2dPemsyK0kvN3dYQ3Jub1Rv?=
 =?utf-8?B?dW4yR011VnVWQVNrZ20vMEZ4K1Njb2RFT281bHBqa3k5MFBrajk2WmpLMGt6?=
 =?utf-8?B?UkFTV2MwY1YrcXJFc01nWmVDdWhhb05RalhPalhHQUtsOC9HQk1lSWx3VTM2?=
 =?utf-8?B?QUJ4MGdlNGFyMS9wVGRiWVZkVVRhL3Y4WEJMZThTZld0RnZqeEJVVG9yaDIv?=
 =?utf-8?B?aTFtckR1SUhZb2RCS3NPSnJIYkxLV3d6cjl5N1RFM0VEY1I3VGdsN3VFa1Qx?=
 =?utf-8?B?eTM0eDZHSFZYSTNJdCtyVkhtODlzaEJzM21rdk5IMks1cjJZckdLM3FTaVBi?=
 =?utf-8?B?TU5wOWMrWFJCZGpkTDRzQUltaXplQkdMRnpJYWRBNm00dEQvcW5mZW44RS9w?=
 =?utf-8?B?VTVXVE5yZEc4WCtTSnlIM0Vob3V5dithc0FUR2UweGY1M2xvUWtkSjF0MHpV?=
 =?utf-8?B?QlQ3OGNjdTFMNGgzTkJFTEEyTFR4U3pHaW5ibGZoUmdrSFlnUUJuSUVPaUNK?=
 =?utf-8?B?d2lxZVl3TzFTR1ZnL1FLalU3V2VUNERSRmRPcWNvMmZYazZaajE5QzkraHZH?=
 =?utf-8?B?RFl6L2ZVeTFkTUxJSWJIM2pnVHF4TWNuWjdTb0VoZXcrRWtBeHhtajgwOS9H?=
 =?utf-8?B?djJQSHcrbWk2Ym1OU0dEVXR6ZUEyQ05WcHk1RlgxYUduSmF3ZFlLaTlFQjl6?=
 =?utf-8?B?c2RpYmorQU9XSjRaWGViVTQ2ZWZVNGV0Sks2MzFqcnVRMGFGSkxOcHY3eFZL?=
 =?utf-8?B?WU9aL0tjZWRnczh3N050YTg4VmtVVEUxTnhsVnNvUGxPbGc3c2hnanQvWnZD?=
 =?utf-8?B?blVadnUvRTQ1VG5NbGg1N2x6b0hZVFp6MEFPbWljZDRBeExOVXRRZXZ2ZTZz?=
 =?utf-8?B?czd3VnIwc1FIRE1qZjV0TXF2cURnSitWeFJETVRaS0daU1VkZ0VMSEE5REc0?=
 =?utf-8?B?Mkt1dm4vb01Mdmp3dUVFdElaTHFoRXk2eUtnd1dwclBqSUMvaW5lbEVQVkpN?=
 =?utf-8?B?dVRjN2oyK25ua0ZHZmk4ZjdaSFJHU3BoYWFOMENMSWVTMGg0eWNrU3BhTE85?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d13448-ccf2-4f15-2758-08daf440603d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 01:57:35.9175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJwXi6Wsf4u4rJvnpJ/LRLeb8kG8dpiLgj/DWROmnQOsNPkQ4eRu23uUYSS+Paxk0UFQ3+Kg7toNCIN6bVCyJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6261
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi, Sean,

Sorry to bother,  do you have time to review this series? The feature 
has been pending

for a long time, and I want to move it forward.

Thanks!


On 11/25/2022 12:05 PM, Yang, Weijiang wrote:
> Intel CPU model-specific LBR(Legacy LBR) has evolved to Architectural
> LBR(Arch LBR [0]), it's the replacement of legacy LBR on new platforms.
> The native support patches were merged into 5.9 kernel tree, and this
> patch series is to enable Arch LBR in vPMU so that guest can benefit
> from the feature.
>
> The main advantages of Arch LBR are [1]:
> - Faster context switching due to XSAVES support and faster reset of
>    LBR MSRs via the new DEPTH MSR
> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>    lowers the overhead of the NMI handler.
> - Linux kernel can support the LBR features without knowing the model
>    number of the current CPU.
>
>  From end user's point of view, the usage of Arch LBR is the same as
> the Legacy LBR that has been merged in the mainline.
>
> Note, in this series, there's one restriction for guest Arch LBR, i.e.,
> guest can only set its LBR record depth the same as host's. This is due
> to the special behavior of MSR_ARCH_LBR_DEPTH:
> 1) On write to the MSR, it'll reset all Arch LBR recording MSRs to 0s.
> 2) XRSTORS resets all record MSRs to 0s if the saved depth mismatches
> MSR_ARCH_LBR_DEPTH.
> Enforcing the restriction keeps KVM Arch LBR vPMU working flow simple
> and straightforward.
>
> Paolo refactored the old series and the resulting patches became the
> base of this new series, therefore he's the author of some patches.
>
> [0] https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
> [1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
>
> v1:
> https://lore.kernel.org/all/20220831223438.413090-1-weijiang.yang@intel.com/
>
> Changes v2:
> 1. Removed Paolo's SOBs from some patches. [Sean]
> 2. Modified some patches due to KVM changes, e.g., SMM/vPMU refactor.
> 3. Rebased to https://git.kernel.org/pub/scm/virt/kvm/kvm.git : queue branch.
>
>
> Like Xu (3):
>    perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
>    KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
>    KVM: x86: Add XSAVE Support for Architectural LBR
>
> Paolo Bonzini (4):
>    KVM: PMU: disable LBR handling if architectural LBR is available
>    KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
>    KVM: VMX: Support passthrough of architectural LBRs
>    KVM: x86: Refine the matching and clearing logic for supported_xss
>
> Sean Christopherson (1):
>    KVM: x86: Report XSS as an MSR to be saved if there are supported
>      features
>
> Yang Weijiang (7):
>    KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
>    KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
>    KVM: x86/vmx: Check Arch LBR config when return perf capabilities
>    KVM: x86/vmx: Disable Arch LBREn bit in #DB and warm reset
>    KVM: x86/vmx: Save/Restore guest Arch LBR Ctrl msr at SMM entry/exit
>    KVM: x86: Add Arch LBR data MSR access interface
>    KVM: x86/cpuid: Advertise Arch LBR feature in CPUID
>
>   arch/x86/events/intel/lbr.c      |   6 +-
>   arch/x86/include/asm/kvm_host.h  |   3 +
>   arch/x86/include/asm/msr-index.h |   1 +
>   arch/x86/include/asm/vmx.h       |   4 +
>   arch/x86/kvm/cpuid.c             |  52 +++++++++-
>   arch/x86/kvm/smm.c               |   1 +
>   arch/x86/kvm/smm.h               |   3 +-
>   arch/x86/kvm/vmx/capabilities.h  |   5 +
>   arch/x86/kvm/vmx/nested.c        |   8 ++
>   arch/x86/kvm/vmx/pmu_intel.c     | 161 +++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/vmx.c           |  74 +++++++++++++-
>   arch/x86/kvm/vmx/vmx.h           |   6 +-
>   arch/x86/kvm/x86.c               |  27 +++++-
>   13 files changed, 316 insertions(+), 35 deletions(-)
>
>
> base-commit: da5f28e10aa7df1a925dbc10656cc89d9c061358
