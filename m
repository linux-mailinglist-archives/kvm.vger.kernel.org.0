Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30053762F5B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 10:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjGZILJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 04:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjGZIKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 04:10:33 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9646776A7
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 01:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690358559; x=1721894559;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=akhJ+MGtSCMo/El7CUWSqUn4YZiv+eayTrLh3o66CEk=;
  b=FEheUOWJ+7oyH4alY+W6Am/D2cM78kuirK8KzZQJAWQ+vO5quy532w2j
   Xvd22TXRpvim8QbCz1d713NjdNRZD0qJf3ISaj5G4nrIIRz6Abz3UGMrN
   2BPkWRaVf58I4LHI3TFTbXCQPpEYTRckK7dXwMeXXWALAtch0Hf9vrvqG
   Jx2ZhpmnqOm4Nhrle2sfOxAKBoUuycJ9NkTJoxhoa6u9+z7mVCBHaFiU3
   wfaZyKa0I4lB2OEdtb+4T/frwQnwnmWhOD8R1PKeq69ACvQRqUSR+vTBk
   qp2vL0SEdfmB6cUHSauEJdGkhmwukFCPWQPn9ovKjz5JSPBaAkrLDO0RP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="454325751"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="454325751"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 01:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="900323141"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="900323141"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 26 Jul 2023 01:01:52 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 01:01:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 01:01:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 01:01:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsgSLQWgwS6yyemDx89eKtcbBmoTBAr0BO6PAa9ptCqCQCIX2ur9XvyZxEieJC/TyX6jQR6iJbOU4CH05XnQhzTfRPENvXlRyBSKcdip+18yeDfgCglRDSvdkm8AyzpYcxdiufHlefP1RpoYiATZBzZZsEJFVUOoec6n9+bUMkSnoYjAU7Qd3Xwtlj1F3riUxi/FrQMc0y4sZc4l7QCvIcbjKw8abq/VMwW2xQU9dtxGRH7K+MzHzxjojPQfpSvLnXqYU0aWGAMiVsCgy3SeIashiH8o3wBxIOvPIILyZGnJwMq+DXmEFpcxystdBR2pXV1GOE+y6iQyf2p507i3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxjnCun7vzY602OjrQZBzXEAveSkUY/lrPWn2eai1B4=;
 b=FsbeWBpeVcz6V5kzMrxQI0ybQRqqH781Xd2kLxaY6C1ef8mu7yvmaVMfu+xgZXmh80Z7anXhXFNpruCN7ok7bMiE8WThvihTFcvki0Xd7OiZ7B4SzFueK9T3USQrZ1RHI6GU1QUHePt4JM6z/nu+c0lk4eNQoCcth1ujCI2LPJrVd9JNi9fAAHFVRv4d3nEevpNELtKmpVazQgOoOnCKNGE8fPCPwhoXGEmzfxiDBGMyeL4/lVq2T+3QlxwrpbZiLfnoJk7NGGPSILnIR4HkReE1KSJoi8jieDUekzvNgg58pIs82Cnk96hSoSH+Yx2+BsJJYwdAJsYblFg0VWAIcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB7740.namprd11.prod.outlook.com (2603:10b6:8:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 08:01:49 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 08:01:49 +0000
Message-ID: <b706c959-983d-e05d-a636-6eff8dab3939@intel.com>
Date:   Wed, 26 Jul 2023 16:01:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] Documentation: KVM: Add vPMU implementaion and gap
 document
To:     Xiong Zhang <xiong.y.zhang@intel.com>, <kvm@vger.kernel.org>
CC:     <seanjc@google.com>, <like.xu.linux@gmail.com>,
        <zhiyuan.lv@intel.com>, <zhenyu.z.wang@intel.com>,
        <kan.liang@intel.com>
References: <20230724104154.259573-1-xiong.y.zhang@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230724104154.259573-1-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::32)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b230e93-66a3-4076-5323-08db8dae907a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QuH1JGE29XPG6hF5ii/+G+o9NJr30DWL+c4AothdIlycpocUdWyueuHogDA7rB3s8kXUwEtOmZarH8XP3Uba7e1NZr6IDcasMqRRGQxL5EGD0VYEW+RGQbQwgU97F7B5h4meGPGaryXga3/XNlXOYsIG6A7uoCViDHd8FRPCUS76K06qxBqXRbPfZ3/yGqKwb9Y58o0A7lHEcCs0TS1EdpxajgXS6DIsGFUYYW9vww/QVgHEWOTwnzD9eptn811SNHFJpw4HXiDWL/2JZnNIKMjVS28cSOz5HbNXZrS1FaDPPjhyXqueyZSgmkmSfklO8A+T0DjQFOMD4x70ettBQIPbPNGNt5fA2q1kEEtOKuEmiF9lRzVBrwBNlGrTYciyRkAba3OhEvBc8K47+/LYBkJaOCbKHpR8ScCc+SFNroHATeuUddEm9w1uRUZBKv2wi4zkzB1ffWkRxS7nCcloSAMjvqqzZrGnFV+EzF8sxF6c7ig/nlRAwknXds/5GQra3oCPHajZWHhS29tuFw2Hn0L1kcPV6bS+zi3VZDBHT0IhheU8qYo/EVTon+3mJbL+POZRcPHHIrcNB0W/IdIjANvlM4dURx8LRZyJMJqDsDlj8opQU2jfmZA2XUC2VeUNJCWUqDBdBk2A80AXCl7ILA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199021)(6666004)(82960400001)(6486002)(478600001)(83380400001)(6506007)(6512007)(107886003)(26005)(53546011)(38100700002)(66946007)(66556008)(66476007)(4326008)(186003)(2616005)(31686004)(5660300002)(8936002)(8676002)(2906002)(30864003)(41300700001)(316002)(86362001)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkx1YUJ0RUR5cUk3SHlteHFlMG16TDRxWUdXSnpKd0pHMG5iTitYeUdCRzh0?=
 =?utf-8?B?UmlOelJZeHU5cVJpZFFIenU5TEdtSlRjSnowMkxES09ZcDVjbG9SVUpod0to?=
 =?utf-8?B?TlhHWCtNVGZhUGttZWFhbFNKeEpuejRUMjNSMEZGb2ZGRDgydmZaaGc0Z3M2?=
 =?utf-8?B?d2ZHMkpoL21MT2JEM1o0cXZDSDQzOWhsU0RIaFJBcVJPcU5teHhlVzRnd3lh?=
 =?utf-8?B?Sm5peFdQMnBvMFhFYVJIbFlvUmt5cHNkNWxIeEZKKzh2WVNHVGtEKzVwWHVw?=
 =?utf-8?B?ZTBqWXJUK3A1QjlOeWtSVTNYYkp0eUdZNFNPZzVZcFgxbHZmYnVtS3hQcExR?=
 =?utf-8?B?ZlNsOEJWQ0RweUEzTmhQODI5VEtudG0xdUdwZlo4QkxFY244R1ExTmtRZlNr?=
 =?utf-8?B?ZjJDU3NtVG94emQyL2N0VUJDWUdYMHp3MG1MMTRDOERTYWxRR0h1b2FVTk44?=
 =?utf-8?B?cW1NT09qdWlLQXNPSk51Z2xPVGY5OXZPUXU5QTlyVm4wbWF6NEVlenduazhk?=
 =?utf-8?B?S3k4aEpXMzlpY3p2bThmVkdIeGRyMk96NVhtbjZQa0NoVzdqZ3ExZVhENzl4?=
 =?utf-8?B?a2s0c0VVMCtObk8vQk5aTTY2cFRqVkpQckVubUx2cFFCSWwwMGlqZTlaNW93?=
 =?utf-8?B?cTZNUU54VTlTUGVscy9Pd0NGcDMwcjNRKzFWNW9JMTNHZ1ZZa2poMUYxNHhM?=
 =?utf-8?B?OEJyZVZtc2NGY1FaYjhITHo0QzNGdjRlQXZBZEs2L1pDVlM0clB4RFFoMHM5?=
 =?utf-8?B?YXlWREcyN0Q3M2pSWVFnUzYvQ3VNQ2llL1JZY01NRkFsNHZtekU2YzBnOFU3?=
 =?utf-8?B?S3M2N1V0VjVBZzBVT3ZDVzdTU3VLU0Z0OTA0UUxiRVpkRTJFU3RMcE5rWjBt?=
 =?utf-8?B?Zk56QzU1blN1Tm5QK3JuR2VnRFllN0lneXJmSEVUTklyVnZ3aEZ5RCtWVVVr?=
 =?utf-8?B?M0lmNmpucm5DVmM1UXFrZnpIdThZNGl0SDRQOVc4U0xVQXdaZFNDd1FUamp3?=
 =?utf-8?B?VDB4UVltRVhtcWxxNnJ5UWVJdkxSY2d4M1NjUUZpb09SdVFlYjdCeTJIMHQ1?=
 =?utf-8?B?ZSs0dGpZZEtFNFNES3NlNXVhVmR3L3FRQzloYTJJaVdDQndtRnRKRVJKZTFX?=
 =?utf-8?B?TmRuQWdHeGVBWEYrbkNtTm5JcXdkbURuYlNUMStOaGIvTXFmeDhJbWM0L29R?=
 =?utf-8?B?cEhXNVZ4QWszTHpibWJQWVdXSHlqalhmWncxRVByRVVJSjNpNHpKZTZQYTlP?=
 =?utf-8?B?WW16blNqZk5BQWkvbzZCaDFyT2NKUGc1SFQ5N2UwRXoxME1Ba1lwSytnM0M0?=
 =?utf-8?B?VVAvaDFQazJNN2RkNHRNSFRUV2RqenI1NlAwSUVKS3MxQXdkNFl4Wlo1NTJa?=
 =?utf-8?B?YVlzMm95ZVZBbGZrNGlBZVNhMlhEajkzM3UyUTZUYThEMThSaW1oZ3o0Z0tY?=
 =?utf-8?B?NnJVcXVqOXQ0NTRiRGZyeUdJQ3d0KzM4dmJmTGVONVVQL0xHOXpJRHdzdzJR?=
 =?utf-8?B?WWdGbW5Uei94S0JjZE05MFhmZEdTSUx0THBQVzgwellDZ2g0REl0L1BZREtI?=
 =?utf-8?B?b09hN09wRWFFVWNLcjRLZlZ2MURBTFdSSFg3YUZuSkVGWTdYR0RrQ29FZUVk?=
 =?utf-8?B?YldCbmkxdTFWeGNKYU5PdWx1ZU5pTDFXRUdHQTFQL3d6TzRSV2FBOGtYRVV2?=
 =?utf-8?B?NDZ4dGdqdTZ0YU5EeHpySithdDlPYmpEYVJEc3g3bmNVN1J3WXI4dVhWVkla?=
 =?utf-8?B?UFpiNVQzOGdMZUlQb3pycnBzWXNFYTdIcU4zb3VTVko3bU5nMzh1UmVBa0tO?=
 =?utf-8?B?KysrcFRqNWo0TThHc1dQTHgxRjRUa2JvT1FMMmEvekJhVUVrTFJiSmNRdXc5?=
 =?utf-8?B?SEJ2TjhuYm1WYU5yajkzUHhEd0phTExlWmtrc2Z4M09HcVlxRnhBcVI3Mk1W?=
 =?utf-8?B?b3Q0QU41RG5TQWh0RTBzQ0Jzb1Y0SWNPYm1qODIwQXdtemR2b1Z5aDlYbjZo?=
 =?utf-8?B?WFlEcXgrRlJRdUV1MWgyTXROYVJhVVYzakFtRDYwckdSKzZEbElWNWdXUjJa?=
 =?utf-8?B?VVNTbGtOMDlFZFVEbmVQaG10N3RlSmE2SHlOLytmc3diNGRJL09lTzgrUDhF?=
 =?utf-8?B?SkpEYTBQdjRDRmQ3allvTVlyZUw0akVkRzdMTndoaWxybWgxWXlyYThnbWxE?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b230e93-66a3-4076-5323-08db8dae907a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 08:01:49.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNgipdn0TWqtIaejlIeEiAye8fSdr1/iMpoF9flfDNSRc6+7csISab+gcUuOrkNQPXalzLJCyK/LsTaDRm3PKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7740
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/24/2023 6:41 PM, Xiong Zhang wrote:
> Add a vPMU implementation and gap document to explain vArch PMU and vLBR
> implementation in kvm, especially the current gap to support host and
> guest perf event coexist.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   Documentation/virt/kvm/x86/index.rst |   1 +
>   Documentation/virt/kvm/x86/pmu.rst   | 249 +++++++++++++++++++++++++++
>   2 files changed, 250 insertions(+)
>   create mode 100644 Documentation/virt/kvm/x86/pmu.rst
>
> diff --git a/Documentation/virt/kvm/x86/index.rst b/Documentation/virt/kvm/x86/index.rst
> index 9ece6b8dc817..02c1c7b01bf3 100644
> --- a/Documentation/virt/kvm/x86/index.rst
> +++ b/Documentation/virt/kvm/x86/index.rst
> @@ -14,5 +14,6 @@ KVM for x86 systems
>      mmu
>      msr
>      nested-vmx
> +   pmu
>      running-nested-guests
>      timekeeping
> diff --git a/Documentation/virt/kvm/x86/pmu.rst b/Documentation/virt/kvm/x86/pmu.rst
> new file mode 100644
> index 000000000000..e95e8c88e0e0
> --- /dev/null
> +++ b/Documentation/virt/kvm/x86/pmu.rst
> @@ -0,0 +1,249 @@
> +﻿.. SPDX-License-Identifier: GPL-2.0
> +
> +==========================
> +PMU virtualization for X86
> +==========================
> +
> +:Author: Xiong Zhang <xiong.y.zhang@intel.com>
> +:Copyright: (c) 2023, Intel.  All rights reserved.
> +
> +.. Contents
> +
> +1. Overview
> +2. Perf Scheduler
> +3. Arch PMU virtualization
> +4. LBR virtualization
> +
> +1. Overview
> +===========
> +
> +KVM has supported PMU virtualization on x86 for many years and provides
> +MSR based Arch PMU interface to the guest. The major features include
> +Arch PMU v2, LBR and PEBS. Users have the same operation to profile
> +performance in guest and host.
> +KVM is a normal perf subsystem user as other perf subsystem users. When
> +the guest access vPMU MSRs, KVM traps it and creates a perf event for it.
> +This perf event takes part in perf scheduler to request PMU resources
> +and let the guest use these resources.
> +
> +This document describes the X86 PMU virtualization architecture design
> +and opens. It is organized as follows: Next section describes more
> +details of Linux perf scheduler as it takes a key role in vPMU
> +implementation and allocates PMU resources for guest usage. Then Arch
> +PMU virtualization and LBR virtualization are introduced, each feature
> +has sections to introduce implementation overview,  the expectation and
> +gaps when host and guest perf events coexist.
> +
> +2. Perf Scheduler
> +=================
> +
> +Perf scheduler's responsibility is choosing which events are active at
> +one moment and binding counter with perf event. As processor has limited
> +PMU counters and other resource, only limited perf events can be active
> +at one moment, the inactive perf event may be active in the next moment,
> +perf scheduler has defined rules to control these things.
> +
> +Usually the following cases cause perf event reschedule:
> +1) On a context switch from one task to a different task.
> +2) When an event is manually enabled.
> +3) A call to perf_event_open() with disabled field of the
> +perf_event_attr argument set to 0.

And when perf scheduler timer expires.

> +
> +When perf event reschedule is needed on a specific cpu, perf will send
> +an IPI to the target cpu, and the IPI handler will activate events
> +ordered by event type, and will iterate all the eligible events.

IIUC, this is only true for the event create case, not for all above 
reschedule cases.

> +
> +When a perf event is sched out, this event mapped counter is disabled,
> +and the counter's setting and count value are saved. When a perf event
> +is sched in, perf driver assigns a counter to this event, the counter's
> +setting and count values are restored from last saved.
> +
> +Perf defines four types event, their priority are from high to low:
> +a. Per-cpu pinned: the event should be measured on the specified logical
> +core whenever it is enabled.
> +b. Per-process pinned: the event should be measured whenever it is
> +enabled and the process is running on any logical cores.
> +c. Per-cpu flexible: the event should measured on the specified logical
> +core whenever it is enabled.
> +d. Per-process flexible: the event should be measured whenever it is
> +enabled and the process is running on any logical cores.
> +
> +If the event could not be scheduled because no resource is available for
> +it, pinned event goes into error state and is excluded from perf
> +scheduler, the only way to recover it is re-enable it, flexible event
> +goes into inactive state and can be multiplexed with other events if
> +needed.

Maybe you can add some diagrams or list some key definitions/data 
structures/prototypes

to facilitate readers to understand more about perf schedule since it's 
the key of perf subsystem.

> +
> +3. Arch PMU virtualization
> +==========================
> +
> +3.1. Overview
> +-------------
> +
> +Once KVM/QEMU expose vcpu's Arch PMU capability into guest, the guest
> +PMU driver would access the Arch PMU MSRs (including Fixed and GP
> +counter) as the host does. All the guest Arch PMU MSRs accessing are
> +interceptable.
> +
> +When a guest virtual counter is enabled through guest MSR writing, the
> +KVM trap will create a kvm perf event through the perf subsystem. The
> +kvm perf event's attribute is gotten from the guest virtual counter's
> +MSR setting.
> +
> +When a guest changes the virtual counter's setting later, the KVM trap
> +will release the old kvm perf event then create a new kvm perf event
> +with the new setting.
> +
> +When guest read the virtual counter's count number, the kvm trap will
> +read kvm perf event's counter value and accumulate it to the previous
> +counter value.
> +
> +When guest no longer access the virtual counter's MSR within a
> +scheduling time slice and the virtual counter is disabled, KVM will
> +release the kvm perf event.
> +  ----------------------------
> +  |  Guest                   |
> +  |  perf subsystem          |
> +  ----------------------------
> +       |            ^
> +  vMSR |            | vPMI
> +       v            |
> +  ----------------------------
> +  |  vPMU        KVM vCPU    |
> +  ----------------------------
> +        |          ^
> +  Call  |          | Callbacks
> +        v          |
> +  ---------------------------
> +  | Host Linux Kernel       |
> +  | perf subsystem          |
> +  ---------------------------
> +               |       ^
> +           MSR |       | PMI
> +               v       |
> +         --------------------
> +	 | PMU        CPU   |
> +         --------------------
> +
> +Each guest virtual counter has a corresponding kvm perf event, and the
> +kvm perf event joins host perf scheduler and complies with host perf
> +scheduler rule. When kvm perf event is scheduled by host perf scheduler
> +and is active, the guest virtual counter could supply the correct value.
> +However, if another host perf event comes in and takes over the kvm perf
> +event resource, the kvm perf event will be inactive, then the virtual
> +counter supplies wrong and meaningless value.

IMHO, the data is still valid for preempted event as it's saved when the 
event is sched_out.

But it doesn't match the running task under profiling, and this is 
normal when perf

preemption exits.

> +
> +3.2. Host and Guest perf event contention
> +-----------------------------------------
> +
> +Kvm perf event is a per-process pinned event, its priority is second.
> +When kvm perf event is active, it can be preempted by host per-cpu
> +pinned perf event, or it can preempt host flexible perf events. Such
> +preemption can be temporarily prohibited through disabling host IRQ.
> +
> +The following results are expected when host and guest perf event
> +coexist according to perf scheduler rule:
> +1). if host per cpu pinned events occupy all the HW resource, kvm perf
> +event can not be active as no available resource, the virtual counter
> +value is  zero always when the guest read it.
> +2). if host per cpu pinned event release HW resource, and kvm perf event
> +is inactive, kvm perf event can claim the HW resource and switch into
> +active, then the guest can get the correct value from the guest virtual
> +counter during kvm perf event is active, but the guest total counter
> +value is not correct since counter value is lost during kvm perf event
> +is inactive.
> +3). if kvm perf event is active, then host per cpu pinned perf event
> +becomes active and reclaims kvm perf event resource, kvm perf event will
> +be inactive. Finally the virtual counter value is kept unchanged and
> +stores previous saved value when the guest reads it. So the guest toatal
> +counter isn't correct.
> +4). If host flexible perf events occupy all the HW resource, kvm perf
> +event can be active and preempts host flexible perf event resource,
> +guest can get the correct value from the guest virtual counter.
> +5). if kvm perf event is active, then other host flexible perf events
> +request to active, kvm perf event still own the resource and active, so
> +guest can get the correct value from the guest virtual counter.
> +
> +3.3. vPMU Arch Gaps
> +-------------------
> +
> +The coexist of host and guest perf events has gap:
> +1). when guest accesses PMU MSRs at the first time, KVM will trap it and
> +create kvm perf event, but this event may be inactive because the
> +contention with host perf event. But guest doesn't notice this and when
> +guest read virtual counter, the return value is zero.
> +2). when kvm perf event is active, host per-cpu pinned perf event can
> +reclaim kvm perf event resource at any time once resource contention
> +happens. But guest doesn't notice this neither and guest following
> +counter accesses get wrong data.
> +So maillist had some discussion titled "Reconsider the current approach
> +of vPMU".
> +
> +https://lore.kernel.org/lkml/810c3148-1791-de57-27c0-d1ac5ed35fb8@gmail.com/
> +
> +The major suggestion in this discussion is host pass-through some
> +counters into guest, but this suggestion is not feasible, the reasons
> +are:
> +a. processor has several counters, but counters are not equal, some
> +event must bind with a specific counter.
> +b. if a special counter is passthrough into guest, host can not support
> +such event and lose some capability.
> +c. if a normal counter is passthrough into guest, guest can support
> +general event only, and the guest has limited capability.
> +So both host and guest lose capability in pass-through mode.
> +
> +4. LBR Virtualization
> +=====================
> +
> +4.1. Overview
> +-------------
> +
> +The guest LBR driver would access the LBR MSR (including IA32_DEBUGCTLMSR
> +and records MSRs) as host does once KVM/QEMU export vcpu's LBR capability
> +into guest,  The first guest access on LBR related MSRs is always
> +interceptable. The KVM trap would create a vLBR perf event which enables
> +the callstack mode and none of the hardware counters are assigned. The
> +host perf would enable and schedule this event as usual.
> +
> +When vLBR event is scheduled by host perf scheduler and is active, host
> +LBR MSRs are owned by guest and are pass-through into guest, guest will
> +access them without VM Exit. However, if another host LBR event comes in
> +and takes over the LBR facility, the vLBR event will be inactive, and
> +guest following accesses to the LBR MSRs will be trapped and meaningless.

Is this true only when host created a pinned LBR event? Otherwise, it 
won't preempt

the guest vLBR.


> +
> +As kvm perf event, vLBR event will be released when guest doesn't access
> +LBR-related MSRs within a scheduling time slice and guest unset LBR
> +enable bit, then the pass-through state of the LBR MSRs will be canceled.
> +
> +4.2. Host and Guest LBR contention
> +----------------------------------
> +
> +vLBR event is a per-process pinned event, its priority is second. vLBR
> +event together with host other LBR event to contend LBR resource,
> +according to perf scheduler rule, when vLBR event is active, it can be
> +preempted by host per-cpu pinned LBR event, or it can preempt host
> +flexible LBR event. Such preemption can be temporarily prohibited
> +through disabling host IRQ as perf scheduler uses IPI to change LBR owner.
> +
> +The following results are expected when host and guest LBR event coexist:
> +1) If host per cpu pinned LBR event is active when vm starts, the guest
> +vLBR event can not preempt the LBR resource, so the guest can not use
> +LBR.
> +2). If host flexible LBR events are active when vm starts, guest vLBR
> +event can preempt LBR, so the guest can use LBR.
> +3). If host per cpu pinned LBR event becomes enabled when guest vLBR
> +event is active, the guest vLBR event will lose LBR and the guest can
> +not use LBR anymore.
> +4). If host flexible LBR event becomes enabled when guest vLBR event is
> +active, the guest vLBR event keeps LBR, the guest can still use LBR.
> +5). If host per cpu pinned LBR event becomes inactive when guest vLBR
> +event is inactive, guest vLBR event can be active and own LBR, the guest
> +can use LBR.

Anyway, vLBR problems is still induced by perf scheduling priorities, if 
you can

clearly state current gaps of vPMU, it's also clear for vLBR issue, then 
this section

could be omitted.

> +
> +4.3. vLBR Arch Gaps
> +-------------------
> +
> +Like vPMU Arch Gap, vLBR event can be preempted by host Per cpu pinned
> +event at any time, or vLBR event is inactive at creation, but guest
> +can not notice this, so the guest will get meaningless value when the
> +vLBR event is inactive.
