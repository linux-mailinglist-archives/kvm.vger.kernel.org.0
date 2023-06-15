Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87254731055
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 09:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244794AbjFOHRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 03:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243103AbjFOHQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 03:16:17 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD8F30C5;
        Thu, 15 Jun 2023 00:13:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5tnx1HaBvr3BnWL4PHoZRzKk2AzFRLXllmwBclsUKokvuAucaybXCMVukD8+L6cGukwZVB4rZCFxFPQeztBOJlf/JF6UaQiJzcDcCRUiO93Zg01oa7Uil7GxOgrY7B9YuWgqbikoQyyUn81lWoxnKaoT7/Y+P/6rUlVXOKe+NOl7rmhVYWJyvpFpkpjfAQlTAiLl2khU4v+mjMpRb7tTghQc0AtaDFU6MVAecqxA1wgjyH3l5ef3i1SaMKs7Cy/oneV/hXamrwUbirMvRiG4j1/C4NNlGjSD2AFJwkq2V8Ce5v2nt48I+MCk46ucZfMtoKQ+69Psq4K0gHMqa1TrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8qvLxgXdxAG4NIeCR1Lj7vzi588O4Y8bdet1z3uCh8=;
 b=Irkk5Vl1PaIi1RU676oDb72lfw8BYQglCZjBYh7lzTIJsvLLyLpXaC7zShjnMgf+bIa7mn959vuEdPSFWjWmF0zvkOc/7VZXFy8HRxGVWe4a1XL/77m6KjPZCLe69gP7H2a8h/MwwHaqqUQzI+20AXHv0JXLj5r1t5We0kmhvjtlry2llQB27vfzDQ59goeTeuvfA6V9V3ZPeaZMEJp3JtSkfaOPh2Zk7soH3nPuBRnp1re2c0h5D5zgsmbXm6wsdL4P1WwrAZ7edd9RItV+KShVnMSvMVMh9jmnhZOA95ekBb256YmBhP810+T8hEnOZ/s0GSH26bBNdWFF3VjbAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8qvLxgXdxAG4NIeCR1Lj7vzi588O4Y8bdet1z3uCh8=;
 b=cLBYZ4ClTzeCMp0T+RSAKJMjQp30pusciKZlHh0xbPPfNNYyspzeHLHGEuURTKsD1w6Z0ur6mm+FQF8EHXxCR7Q+CY4ZMNPBrU7HpKFGZCryPvIqMcuSFYEFNEyZyXMRhvNDVsPayQ3zIINIkMb3RJx+FsGIBIEN0aUnr/jool0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Thu, 15 Jun
 2023 07:13:31 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef%3]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 07:13:30 +0000
Message-ID: <a209f165-b9ae-a0b3-743c-9711f5123855@amd.com>
Date:   Thu, 15 Jun 2023 17:13:22 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel 0/9 v6] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
References: <20230615063757.3039121-1-aik@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230615063757.3039121-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0093.ausprd01.prod.outlook.com
 (2603:10c6:10:111::8) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: b2400b16-ff0d-4758-dbf3-08db6d7005e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rI/ZhZkEbLjOxXsjbKc02gePprkNSOztsNrUe+8p+TH+9slEgYPBOlNlCV9P9TLunO5d0/4SFIrn9aDNKvBFwBEYZVXq6IsUKO2EQ0VgXhYjl3k3lKzfnNX5ZN8Y9gGtMrAZeClj2QXbGCXI27XnPH7wvNKw6IoE13scGw+Y8V9WFMcj5aPOJ1rJFYTWHAPZqa2IQwn4PHQJyTnMrFOYoF6AZWmZk+iT24xUQXPxOvAZu/6Ro+mUnYHGb4NaRUD6netwfcZkMh5E4PTirig+0FBlts2OP97e49/ejfShYa7OnGMYEcyOFC6HvN4ic8KugTsRg8iS59xR3mQ2dzoYRFAzGWHO0FckHzBYRefdFS64zlKoqu/fSev0Gchn/jNWE5Kj6vPvpr6FV1Zl7gruO6+yFnrhYKRu0pPupzjyPjX3IgrqKJ9F/mySZeVrCnq600Y27ADrAqG8Nw9ctYip6PlQEO4EJy0G7bcMJSvVhfNonwHFCRqtl/27bfUmI2zZ5ROWExUfrtfntGOvFjrHLSxVuTI0SsyDgM+5jNKJxGg2193AnoSSY/ZU1bZzMhza6/VYYq//82KGRt7Si6nl828EqzF6KiPxpQ7XxasPLebN/5eX/CNFnifZCEAEDM1kO31D0LH/2ChsNGg+Bj0GnR6TK55ObprK7+0RyinyYw5cpwGVvAAzG4tPka/eiSHo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199021)(5660300002)(66556008)(8676002)(2906002)(8936002)(31686004)(66476007)(66946007)(54906003)(6666004)(4326008)(6486002)(966005)(6512007)(26005)(6506007)(53546011)(6916009)(41300700001)(316002)(186003)(83380400001)(2616005)(478600001)(38100700002)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVRPcWt6NHgveEV3SFF1S1V4N3p0Q1pHZW1pVzBLdnJ2SEZDWjZOMzJ2Z1NF?=
 =?utf-8?B?T2l1Y05oQnJrbk8ramtzWHF6eXhiOEIycHNnUkY1UVUxSk04VkViSTRqQTVt?=
 =?utf-8?B?cXNPbU13MGxpNUw4TUNGWHJ6ZmllWW5FckNlN280M1g1WHcxN2gyY0JhUlgz?=
 =?utf-8?B?a0taanduSXpsc0k5SzhUUmZqa1hPTEtrS1drTEwwMGNMS1htZ2UxVlRwL1ZW?=
 =?utf-8?B?QWRHWGJFSjhHaTYwaWp1c252T05KV2RMS3pGR2xWMHhFZnAxTUMxY2RUNGxO?=
 =?utf-8?B?UHBFR2JRdmtlZUZjM0h5cmgwZWtEZGoyTzhDZjRqOTJqUkpRNldBNFBEZTho?=
 =?utf-8?B?NlBlTDQ2aXFKT2xPWG4xWk9OVDdxcXZ0SjBOaTFGS1F2cmhDMWZubVh5Y3la?=
 =?utf-8?B?RnIwOC9UZ0lzM0huL2NYUkVNQXVtR2ExNW55VHE2R2NuL1JDQXRnUlhDV2Zj?=
 =?utf-8?B?bVBEeWdNWDczZ2JDR0V4cTcrczlhTklOSVJSc2Z1TzUvZkcrMytSWmpDbDFP?=
 =?utf-8?B?RjNZdFNkK2s0dDVsLzE5SUpROWVzQ2JCZ1lzMGFnNnVZOXNtYUlFa0xSc1pW?=
 =?utf-8?B?K2tHYXk5N2tzeU1Zb3FkSjBiQUhPWC9IOTdHSEl5SlRqNU9YRWNYTTZFdjVV?=
 =?utf-8?B?L01QdE84QUtHR0dIRFNpUEMydFRTcWh0ZmRsVTdVZ3NXM0UyU3QvclErZkFT?=
 =?utf-8?B?elhhVWg2c3hLRkNnTytjUm15STV0eUVydmtrTGFydzFhdFFEUkY5Y2lxRTRR?=
 =?utf-8?B?V0d6K0t0ZVJlenpJN3B5UUpocUNYUnpQRXJhTkswWWVYY215VHphMlhzNzJi?=
 =?utf-8?B?RURDR0p6WnYvZU9pa2Jxc0pZOGZTdS9ibC9adUMzRVBJVkRMVldaOGZsVnhG?=
 =?utf-8?B?Q29uc2VzY25yV3YzcHVmU0hGL3VmejNxWkNwRWUvMXBUaDN2QXFxamh2SVlH?=
 =?utf-8?B?Z3ViSzAwWGUwTDhVdFRLOEZHS2NZQi84cStLMHlJbGl2ekNuSjFpNmlUR280?=
 =?utf-8?B?djQ2eWFHMzNlWGdrcnkxNlh2R2ZZWktEcWZKaVBvdndaT0k5VGpsSHphMkRI?=
 =?utf-8?B?VWxwWnkzRGZLM2cwWVQxekFZaHphR0FqUFcrdVhhT09DeFdqT0VGWU95RkF3?=
 =?utf-8?B?Q1h4TnR3THltaEJib1IvSVpuMngwSzNoMXdyT3N0SERmZk1DK3A1ZGRzOWhi?=
 =?utf-8?B?MzR2d09aWGZzb1pBV1NqK2krZjdWYmhKZCt0Y1hWbG9MMkIvTzU0aDRVWDMr?=
 =?utf-8?B?b04wYzFLdmEzR25mMU9jN0tabDU5Ykp6UGM3aE5sSjFOMS8rblBKOUpjY3Aw?=
 =?utf-8?B?T015QVh3NThFQmNEcTI4cG1Ub0RGZ0RyWk14YWRSR1BBVVMrajVVa0czUFVa?=
 =?utf-8?B?R3ZGaWoxTGk2M0JicmxrWnlkVysvQmNOc3YybmpQRGRDazBZTmswcGRucktC?=
 =?utf-8?B?ejduem0vK3ZHb3N5ZWIwazRSSkRvUHhEWkxLSzBhRXEyWmFtWjlMV0VkODA3?=
 =?utf-8?B?bWp4UVFGNjJQM3U1ekxBcTN1OERKU2lGc1p2Z3h0UmlGeUFvcy9jVXBkZFNN?=
 =?utf-8?B?cXlmd2JMOFlPdy94dkdVTkVwOG5uVlEwdFlhY2hlSWlaem5UcExudWZmU00w?=
 =?utf-8?B?cXovN0Z2cG4rSEV6VGZjUURYRzJZNTFJMUQzckh0b3FYSUl5ZnIxSGpJTFZD?=
 =?utf-8?B?TTdzTEJ4aXhyMzFOVWlBWVJxWWt2RmpMbXZOWVMrWTVWRXBtek81RFJPT0FQ?=
 =?utf-8?B?OTIrakdIM1hqN2t3eS8xckdOR251aXJrU252dkxLNTE3QzhDcGF2eU1SRGxU?=
 =?utf-8?B?Z3hhUWVLWEpnNTA5OXRMY1dvalFTb1dKcVFzd001VU5mSndMQTNreWtSWUpZ?=
 =?utf-8?B?Tmk4dmdvK0VWZFBWSE9VeGVEQ2tHVzZhUGRDVklBRnNuRm0vcUIvWE5lRE55?=
 =?utf-8?B?ZXlsUFYralVONDUvTDFaS29nL1lvSWtQS3BsdW9vb3ZIZDhCY3RJQ0FzaG1U?=
 =?utf-8?B?UGpqUlZaYTFET2h4cng2YVJwNFo4a1hvNzJyRWhzdmZPeitLaFVBZHRmbXZU?=
 =?utf-8?B?MnYxeGVKRzB2bFRrVVpqOU1IVGFPbUVFMVpkTDlqOEZFd3haZlNzT3FwUWFp?=
 =?utf-8?Q?tRUYTYnHDgXIbRl0PFtx+tHbE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2400b16-ff0d-4758-dbf3-08db6d7005e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 07:13:30.8704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /215D3YWb+KzqFzHAXdt6J2ZjTmuTjgRJw+hVe4r0ykVwukTod2Ztj3QazZFyDhgJGp6FQhc7beKoviU4mI5lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ouch, forgot to mark this as "v6". Sorry...



On 15/6/23 16:37, Alexey Kardashevskiy wrote:
> This is to use another AMD SEV-ES hardware assisted register swap,
> more detail in 6/9. In the process it's been suggested to fix other
> things, here is the attempt, with the great help of amders.
> 
> The previous conversation is here:
> https://lore.kernel.org/r/20230411125718.2297768-1-aik@amd.com
> 
> This is based on sha1
> 6e2e1e779912 Ingo Molnar "Merge branch into tip/master: 'x86/sgx'".
> 
> The tree is here: https://github.com/aik/linux/tree/debugswap
> 
> Please comment. Thanks.
> 
> 
> Alexey Kardashevskiy (6):
>    KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
>    KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
>    KVM: SEV-ES: explicitly disable debug
>    KVM: SVM/SEV/SEV-ES: Rework intercepts
>    KVM: SEV: Enable data breakpoints in SEV-ES
>    KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled
> 
> Sean Christopherson (3):
>    KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about
>      swap types
>    KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
>    KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI
>      window
> 
>   arch/x86/include/asm/cpufeatures.h       |  1 +
>   arch/x86/include/asm/svm.h               |  1 +
>   arch/x86/kvm/svm/svm.h                   | 42 ----------
>   tools/arch/x86/include/asm/cpufeatures.h |  1 +
>   arch/x86/kvm/svm/sev.c                   | 86 +++++++++++++++++---
>   arch/x86/kvm/svm/svm.c                   | 70 ++++++++++++++--
>   6 files changed, 137 insertions(+), 64 deletions(-)
> 

-- 
Alexey

