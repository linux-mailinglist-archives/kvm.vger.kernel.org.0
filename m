Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B4274C947
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 02:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjGJA3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jul 2023 20:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGJA3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jul 2023 20:29:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F341114;
        Sun,  9 Jul 2023 17:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688948941; x=1720484941;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C4KyamqW2bMhd/+7umD54/1d6Qtx5ATezc41HNwc6CQ=;
  b=Ec93oL38yY2kFEWJmaR7qi/r5tlwgcwjx/thtisU4Qfmkg6ZYDb6KkiS
   w0lj8JWSX6cxXFDHTkIFoutK16On075gkfy/E+VHd9Pw5dD+EPFO/8wjr
   xth0lAzEWBpWDxXlk7XZECeztWR+3qR1AJEAXEU21VD8IA7MrxEJezsp0
   /gxXeeYPDy5Ex74x7tCCCRZ6h6wySszeM0T6X8v6J/fB4HHsgo9Cs0sAA
   9t2fV/tNsNZO/VKuhKD01l5gRI3ONQdLh3L5omuk69JRpLKaMZxdQRfo+
   viS48y/dd1Z9DcyS8ofNfl8B20+qmcq47S1x6P4pZ8Yn35iuxafb+uIZO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10766"; a="366801476"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="366801476"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2023 17:29:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10766"; a="720520621"
X-IronPort-AV: E=Sophos;i="6.01,193,1684825200"; 
   d="scan'208";a="720520621"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 09 Jul 2023 17:29:00 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 9 Jul 2023 17:29:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 9 Jul 2023 17:29:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 9 Jul 2023 17:28:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVZNKn0ma74BKp/1JShOA8QkcxFyHOk30zO65q3sxcGolTcVs+ubTxHZUlxSzwedoUstPr3HUYAFzMJUtNzuL/22AujKtcgx81bYvekUF/49SPg+kK3t6gkBCNWkME1kwSfyd6Q+VK56SG/9XrOk7RHh8C7qngjvrqgnda0+zIJzpUjX9Jh8QbM+NLoiiFETxi1sTc50VCHdTAQLQi3EZqujUhzWGmzLx5SxVbJv3TI75Nvy30sBKmAejnJQlkNjIcvbMX/qolea5gz13fR8O0dr39+ydCF6zwhSvvQa306IhKjnO18iJpEIjTqnU3JXMKwKyBfPXIeoaDJuICgLZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2J09hIy+Pr9M+Ms/0bj889jbiHr/nab4sJyge553Rc=;
 b=M+1cQ29/EQpjTK66BwM7eMs2DqRSBanMcU3IcFsM2CXAO0C/AceD/2hsPmg2+SnGRHlNT/im9JaBeqip1/b+fsFBpVwQE5jLXbdQIwZ6f8bdREIcAQL3NIpEG0jxuBsQ3JHgpXVD3wT+8T2ADUTks3VqRI/KyyjsaRTkLCebF6o9BWnMzoPbnQP8nlKrdHby6ghDlc0gyd9jjHjBbq4jkHC+pKDV+Io1D1uvNX9sljBQVDV+61646cCwdLaAMFEaNOZcOHxfAtZxQ6PJakJo0vYSAe/luUboBXmkLzqnwWlGoeEg0GoxAZWgSpj3D81ftfNclP1Ezh96xDzc11godw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6075.namprd11.prod.outlook.com (2603:10b6:208:3d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Mon, 10 Jul
 2023 00:28:56 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 00:28:56 +0000
Message-ID: <ffd84a94-abea-a813-a6da-59d45a5ac468@intel.com>
Date:   Mon, 10 Jul 2023 08:28:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        "Neiger, Gil" <gil.neiger@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
Content-Language: en-US
In-Reply-To: <ZIyiWr4sR+MqwmAo@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: 524e29a7-dd93-4cfd-8c82-08db80dca57c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0gjYm6hat+FdPUcKySDkE4bvS607O958p2JoHarBRbS9sbHxiZdszkn84YP/J5V7leO8T4Rvwp6JfF0QOB58/nRgWJL/pLLWby1JlONx+i1L1p1YZXKe2YUn3b6WpcgPZPZZt5yNvkU3ZdsdyWujcrFg4v7xz/Np9Fvy+ddyF8sLF3Ox7hKVonAtoxgtKA0si4QD9aVuOeMMfeqTiUNd2erldEfxv9Jzj5wpUWVD8zIzSUQ/aUcAqptTEr32QcrLan2j7FBDRY3Ax+QScLZVohEaY1COsFGDkdgOnjsnB9BXi6ykgZIve+PJ2T8WNleinhiSu/dovQWX6yqSO8Lu0KT0W56EKE8NYo1QmbnfkBywm74tWClNVj+yp6gCw//c67sg5F6+2W+7gpBLFoO+biFJ36ihQSMbJkXewATl7kTd52TP6Lksmz0knfcRoBH+CAk2L4W6ywijRpqr2sUmZCUkQbK3QAL4cYPasHYNy48U7Xl6e/6dPTjs5aO6gq6/e9W63aacpIVPc0cC82J80fsxQVRT5oNK+dNRR4mkBfxLAFoto+Z38KIRRNw0MeP3CsyQzorf/GDdfF8c4xQ4qVFm1Kh2ZjbXJSI0/2HWogcav4FSJSKtLQsfdwSlRrwbpz8tIS5uFoQkOOtQNW3mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(478600001)(6486002)(6666004)(53546011)(6506007)(26005)(186003)(6512007)(66946007)(2906002)(41300700001)(316002)(66556008)(66476007)(6916009)(4326008)(5660300002)(8936002)(8676002)(38100700002)(82960400001)(86362001)(31696002)(36756003)(2616005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnlDcmdSbjZmQ2ovN0ZBS1hYT3dmbXAxcm9UQ2ZnUzE3ekYvcE9nV0xnVHRv?=
 =?utf-8?B?ZjR5citmM2pROTFMb0dVbGQvSS9MeVJxc0tUMmhaSEpOazZsaDR1MW44Nzht?=
 =?utf-8?B?THNXSnp4MXZKaC9vUlp3eVlLWk5rV1UzWjgxTi9CRE5DcmcyRzBnNWRxdzV4?=
 =?utf-8?B?QXBtL1NCQ2wvOWlscFllbTQyVkRKQlJFa2lINVdrdTdTd1AxRTZHbW1VRmgw?=
 =?utf-8?B?bHc3c2RjdTN5VTR0bU13dE5OeXM3N3FrSmxFZS9pTnFpNDExWHdGMEk0bHBY?=
 =?utf-8?B?KzBJZzFSYVZQejJQeDNJSFIveHE3Y3F2dmVMbjl0RzZLWkpVaTVsVFEwWXFH?=
 =?utf-8?B?M1dyd0pwRVIxdGhHUFZHcnRlK1Y2R3o1SmhsaHVaTi9pQTExNlhqc2plWTZl?=
 =?utf-8?B?Z0p0cVFXdHRYamdkcUZteE9RdmlLMytDT0hKVmVwSlVjV0NSWXlIb1JWTmhO?=
 =?utf-8?B?QkVqKzZyUVVsRFc4ZE1UQlJ0NFFBc0JjOW96L2dkbXNhNkhVUzVBTXZwM3Ja?=
 =?utf-8?B?eDRvNDVOb0VWa3BzTmI1Rit3VVhQd2o3TXJUdzhXdEh6MWd5V1NhdlRqRlp5?=
 =?utf-8?B?Qmpqakxha1lkVHhrYncxZkRkWG9SR2h3ekdoMnc5VWUwWVBqd0RxNC9kL1Uv?=
 =?utf-8?B?eVlXazAzMmZBOU5WaGZqamxhNUpzcWUwTWZUUVNoSHRLdnB0bkgyR0ZPd2Zr?=
 =?utf-8?B?WnQrMzE2NU9OczlwNU0rYVhKYnZObmxzU3phbCtQOS9neHJJUkNvdngxS09a?=
 =?utf-8?B?RjdTRE83VmlSNmlsRmIyWmNNOUFnR1hnWDBhaVk1RTkwdFNpczUwZVdkUFlZ?=
 =?utf-8?B?RTZ5K283WEc3U1l5ZFZTblZKZjJOb3JPTGMvRW1GMFJzWE4xQnFSdUhlWmc4?=
 =?utf-8?B?Ry9XS2kvQURWd1BwK0RQdDlETnNOQ3FZc0E2ZGsyMW1QNHJIN3dUK0JGeUQy?=
 =?utf-8?B?ZEV0VkxZd3JvK1dyV21nQkpYYlpYQUp3SlQwbW9Gb0sxUVpqb2prUFRseXVO?=
 =?utf-8?B?WGdIMVlHUDVCU0x5c2E2UVRMK1JCREgxa0FhY2ZOSVI4elIvYWZYdjkwWWln?=
 =?utf-8?B?ZFY0eXVoU1kvRFl4Ym56N0hycy9VKzhlZlorNWNIZm1GdHE2UkVuZ2M1UGFP?=
 =?utf-8?B?NlBDcjdnZnUrdzZZVDBLNldNVHJrRTNHcE0wQ04zeVpYNk9KNElQSWtoUis3?=
 =?utf-8?B?OE1RT1U2MGxoaTI0bHE0NUVoWklqS3FMRTllTS82c3VRbzNlL0djUjJsQnBN?=
 =?utf-8?B?N2lRNkJQMmhhOEw0RUJqMjVGSUJNcElPTkhpTC9vZ1owSVRzWjBlTkoxMThT?=
 =?utf-8?B?L2o5dDdYcVFaaWlWV2x2NkduclFTSE9FYzluYWVBWkM1MjJwWVhBM2FzTitj?=
 =?utf-8?B?RmRGMmIzbFoySUhmZFdEV2lUUDFIMTZKYjF6ZEpZb3E3eHNldjJFTk9oZk1h?=
 =?utf-8?B?ZnVLeWpWRCtveEJDSnBOY2ordWgrZCtFQmNrSURvN1lKUFROVVR2YU54UnIy?=
 =?utf-8?B?VjQrcnViL0JBaTdCT0psTGVpVjhoTk1mNGgvYVFMUXM3ZVRtejZqaTFnZWVV?=
 =?utf-8?B?cS9EOWZwRk43elptaGxRSW1qY1h0VDhMY2lZSXZNQzRvUG9YRHM4aTkxOEY5?=
 =?utf-8?B?NXhjVGQyWE1TMTNqQ0FYMDJNYldwQllGQkwzVGFqRFBpV0FscisxT0pUTUNa?=
 =?utf-8?B?dTNqZThvRzBzaGJiT244OUFnRlBxSHZScHMybkZBd0Mva25vd2VVRDFOV0E2?=
 =?utf-8?B?cmVYTDl0dlhjUEM0OXM2czVZaWlXTTNqVlRQbmNkanp0b3lPMGxYMFRKV2pX?=
 =?utf-8?B?VlBDUmhod2ZJSm14YWxWRkxDK2ljeWovamNWczBla3czdmYvbVJ2WDd2V21Z?=
 =?utf-8?B?L3p1a2ZhWTBpT1RIMDN0dDBxY2QxR3VpVmYxNm9GaU43Vjk1bkw2WVFEQUJZ?=
 =?utf-8?B?YW44Q3AxVkcyMXhkSUxSMnlUZXphTHRtbzBhaWV4czNDL3ZxN3NSTlJDY3dX?=
 =?utf-8?B?aUlmYXBOSENXdkEzR1gycFBuTkFVSHIzNUdBUTQvejRKd0VGU1VEcjd2dE1S?=
 =?utf-8?B?amtYMzJqQ2czcWM3Z05XMExVTUhqNGxpV3BMQ1ZWZlVxOThzNEZoMjUyZjhx?=
 =?utf-8?B?WlF1N1REeis5UnVRVTNCRjZPRjJZRitFUFVZc0gzcWZXSW5CWktFRkhBWUkw?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 524e29a7-dd93-4cfd-8c82-08db80dca57c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 00:28:56.3855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRM8V2QxVa5yqT8gVH6bn3hnMq9uAuCURHsKtarhmFaAsaK1EasexATkAA4XXAH8N00gQ2vxfwQUk2zhRQ/ErQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6075
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> *sigh*
>
> I got filled in on the details offlist.
>
> 1) In the next version of this series, please rework it to reincorporate Supervisor
>     Shadow Stack support into the main series, i.e. pretend Intel's implemenation
>     isn't horribly flawed.  KVM can't guarantee that a VM-Exit won't occur, i.e.
>     can't advertise CET_SS, but I want the baseline support to be implemented,
>     otherwise the series as a whole is a big confusing mess with unanswered question
>     left, right, and center.  And more importantly, architecturally SSS exists if
>     X86_FEATURE_SHSTK is enumerated, i.e. the guest should be allowed to utilize
>     SSS if it so chooses, with the obvious caveat that there's a non-zero chance
>     the guest risks death by doing so.  Or if userspace can ensure no VM-Exit will
>     occur, which is difficult but feasible (ignoring #MC), e.g. by statically
>     partitioning memory, prefaulting all memory in guest firmware, and not dirty
>     logging SSS pages.  In such an extreme setup, userspace can enumerate CET_SSS
>     to the guest, and KVM should support that.
>   
> 2) Add the below patch to document exactly why KVM doesn't advertise CET_SSS.
>     While Intel is apparently ok with treating KVM developers like mushrooms, I
>     am not.
>
> ---
> From: Sean Christopherson<seanjc@google.com>
> Date: Fri, 16 Jun 2023 10:04:37 -0700
> Subject: [PATCH] KVM: x86: Explicitly document that KVM must not advertise
>   CET_SSS
>
> Explicitly call out that KVM must NOT advertise CET_SSS to userspace,
> i.e. must not tell userspace and thus the guest that it is safe for the
> guest to enable Supervisor Shadow Stacks (SSS).
>
> Intel's implementation of SSS is fatally flawed for virtualized
> environments, as despite wording in the SDM that suggests otherwise,
> Intel CPUs' handling of shadow stack switches are NOT fully atomic.  Only
> the check-and-update of the supervisor shadow stack token's busy bit is
> atomic.  Per the SDM:
>
>    If the far CALL or event delivery pushes a stack frame after the token
>    is acquired and any of the pushes causes a fault or VM exit, the
>    processor will revert to the old shadow stack and the busy bit in the
>    new shadow stack's token remains set.
>
> Or more bluntly, any fault or VM-Exit that occurs when pushing to the
> shadow stack after the busy bit is set is fatal to the kernel, i.e. to
> the guest in KVM's case.  The (guest) kernel can protect itself against
> faults, e.g. by ensuring that the shadow stack always has a valid mapping,
> but a guest kernel obviously has no control over, or even knowledge of,
> VM-Exits due to host activity.
>
> To help software determine when it is safe to use SSS, Intel defined
> CPUID.0x7.1.EDX bit (CET_SSS) and updated Intel CPUs to enumerate CET_SS,
> i.e. bare metal Intel CPUs advertise to software that it is safe to enable
> SSS.
>
>    If CPUID.(EAX=07H,ECX=1H):EDX[bit 18] is enumerated as 1, it is
>    sufficient for an operating system to ensure that none of the pushes can
>    cause a page fault.
>
> But CET_SS also comes with an major caveat that is kinda sorta documented
> in the SDM:
>
>    When emulating the CPUID instruction, a virtual-machine monitor should
>    return this bit as 0 if those pushes can cause VM exits.
>
> In other words, CET_SSS (bit 18) does NOT enumerate that the underlying
> CPU prevents VM-Exits, only that the environment in which the software is
> running will not generate VM-Exits.  I.e. CET_SSS is a stopgap to stem the
> bleeding and allow kernels to enable SSS, not an indication that the
> underlying CPU is immune to the VM-Exit problem.
>
> And unfortunately, KVM itself effectively has zero chance of ensuring that
> a shadow stack switch can't trigger a VM-Exit, e.g. KVM zaps *all* SPTEs
> when any memslot is deleted, enabling dirty logging write-protects SPTEs,
> etc.  A sufficiently motivated userspace can, at least in theory, provide
> a safe environment for SSS, e.g. by statically partitioning and
> prefaulting (in guest firmware) all memory, disabling PML, never
> write-protecting guest shadow stacks, etc.  But such a setup is far, far
> beyond typical KVM deployments.
>
> Note, AMD CPUs have a similar erratum, but AMD CPUs *DO* perform the full
> shadow stack switch atomically so long as the stack is mapped WB and does
> not cross a page boundary, i.e. a "normal" KVM setup and a well-behaved
> guest play nice with SSS without additional shenanigans.
>
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1e3ee96c879b..ecf4a68aaa08 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -658,7 +658,15 @@ void kvm_set_cpu_caps(void)
>   	);
>   
>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> -		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
> +		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
> +
> +		/*
> +		 * Do NOT advertise CET_SSS, i.e. do not tell userspace and the
> +		 * guest that it is safe to use Supervisor Shadow Stacks under
> +		 * KVM when running on Intel CPUs.  KVM itself cannot guarantee
> +		 * that a VM-Exit won't occur during a shadow stack update.
> +		 */
> +		0 /* F(CET_SSS) */
>   	);
>   
>   	kvm_cpu_cap_mask(CPUID_D_1_EAX,
>
> base-commit: 9305c14847719870e9e08294034861360577ce08

Hi, Sean,

Gil reminded me SDM has been updated CET SSS related topics 
recently(June release):

======================================================================

Section 17.2.3 (Supervisor Shadow Stack Token) in Volume 1 of the SDM:
     If the far CALL or event delivery pushes a stack frame after the 
token is acquired and any of the pushes causes a
     fault or VM exit, the processor will revert to the old shadow stack 
and the busy bit in the new shadow stack's token
     remains set. The new shadow stack is said to be prematurely busy. 
Software should enable supervisor shadow
     stacks only if it is certain that this situation cannot occur. If 
CPUID.(EAX=07H,ECX=1H):EDX[bit 18] is enumerated
     as 1, it is sufficient for an operating system to ensure that none 
of the pushes can cause a page fault.

Volume 2A: CPUID.(EAX=07H,ECX=1H):EDX[bit 18] as follows:
     CET_SSS. If 1, indicates that an operating system can enable 
supervisor shadow stacks as long as
     it ensures that a supervisor shadow stack cannot become prematurely 
busy due to page faults (see Section
     17.2.3 of the Intel® 64 and IA-32 Architectures Software 
Developer’s Manual, Volume 1). When
     emulating the CPUID instruction, a virtual-machine monitor (VMM) 
should return this bit as 1 only if it
     ensures that VM exits cannot cause a guest supervisor shadow stack 
to appear to be prematurely busy.
     Such a VMM could set the “prematurely busy shadow stack” VM-exit 
control and use the additional information
     that it provides.

Volume 3C: new “prematurely busy shadow stack” VM-exit control.

========================================================================

And Gil told me additional information was planed to be released later 
in the summer.

Maybe you need modify above changelog a bit per the update.

Given the updated parts are technical forecast, I don't plan to 
implement it in this series and still enumerate

CET_SSS ==0 for guest. What's your thoughts?

