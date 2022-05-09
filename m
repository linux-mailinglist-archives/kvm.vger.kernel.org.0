Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C651F376
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 06:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiEIE1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 00:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiEIERr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 00:17:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B242A88F66
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 21:13:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMOhsr23Xzu7CV2s3FOLT7QpF6sZQ1mnu+5ip8eqgsCL2y+UEPe1Y/TG4gDTZJp0VeSOBmkv3AL0FzcNanT4yYCzHe4M2kLRATKhMGHWkzm5ZHH30E5HHIgiQl4QSqV9p5UpqWsWzG2RCJOpneT0OZCeaiPOPUOnbrCkaXnBTJD9Yi5e/WLJ1yzD/IUeVbUoZhjGhbearRm1w4LPNayJklAlHtGG4MxFbkAt5JNIi+ZkADlmZP29mPqDs3iLzQU4gfAPR10RDfAOTHk+zGi8mRuJUfx8MAxZ5G0nye8E7CaX7f7KAdPfLxv277EqNjYnKPh6xJZLRfU0tstzoaUtZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAWhbqHSfjaJW/GDi+wKdqAneOxhuHcORwWGkBsaTG4=;
 b=A67X2rwBfhzBE5PrC0NuV5gNw43fgPdccUAgF0MTtIM0ovnz/6DPk/KL4XSdZgnsCGgeXwcjNcrcTI+EEz4N+t2CU/Q/+gsqccAqzl3ZvMuGqOmKbhqhgOXezkcLfxU8d534Ir6sZdu7JLjNNTJ8HIRNtm9cbd3J+ojvyAIgZ+ug29JjRccCs2knsXtq3ag7ruNfYdkGPVYy95hRr6DOfdgOSR9tP9jrRyYl55sCRgKlrOYGeXQHLXHDsuruMWDKlRu+bz7hIyG/jvpkrIh+yTcIg9Nd5cWnZ9VynwRbzUWhbliYCy26rdtQtNnm29T298nT8FTOcpUNIUtj0GoZqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAWhbqHSfjaJW/GDi+wKdqAneOxhuHcORwWGkBsaTG4=;
 b=fSm/LuwLXmZML7fscQOIuqlNeeEAiZWkW34i6Z8NGk721yjSfT5ZRzBhzh1NSj0+kBCr0zeg4oZ1jcajf6FOFuOOfGrljV3MoJg+9EzdIhnmhobhHnBUCXuump/y6Ua2udI1+y78rcMMXRfPRR2x+vHp54/YOy+iyCPeuS7jOZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by BN6PR1201MB0081.namprd12.prod.outlook.com (2603:10b6:405:4f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 04:13:11 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::b0c0:413b:4c21:b92c]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::b0c0:413b:4c21:b92c%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 04:13:11 +0000
Message-ID: <1b1998e2-0ff9-23cc-aaff-4f1e5ae3d06b@amd.com>
Date:   Mon, 9 May 2022 09:42:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v4 0/8] Move npt test cases and NPT code
 improvements
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220428070851.21985-1-manali.shukla@amd.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <20220428070851.21985-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::6) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 634ba232-11c7-429a-69b1-08da31723ab4
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0081:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0081AB051E67B81371AD2A94FDC69@BN6PR1201MB0081.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UaJ5H7ARPct3WK5VuTN0UDcXxpHODZ6dV/zrMBhRMb+nbreDBpGR1degQKxuj4zvpmjahXh4WaQnwvbwN3jSilRnuTzS+9GNNXFI03r150dfs3okFasQgIEXajv3gCcglwfeV/qEe7PKPW0UJagIjv5ptEnnoRHkffQ9zjGUI2hRBFRZav4s6mpU4yyr7uDMw+oRBuDJyvbQF4ioGBDLXKY2ZOrc+r+fhVjZFRY7//2JNG3MJ1NWLsvJdDBLL+w3R5u/TDjvzjQQIzw0CScbb/+cnEaAosO8fgESfhED7KWnYhkSbBAoxO82GTXnVCXzkHNYyJDm00hRsRuhCe42jY8/4J7wEfqhfaV6o5d9jGyxPuHWeLLtt3qpPZcp0SJSDFyfFUjVOGk8nrvGdCfH3F75AxFWMFnGGZtWwRG3WPov4TFTslWN976Msoao9h5v+L8Wx3B/WD9zjYZDhziEavAi9KCeB79o34f3AvmjCWtGmqFG9YPzrmi1cKuNv2NX483Z0m1bEnLRIBLdlvdW9M3DNb5NtS05eIKyF090pHhhrv/qVvpEtX4cz4M0exWcFKe/FJxNNOCD0xMOepA21BFhChI5LCD0a0h9qUrEcH+HKfq3gP9Xz+3oMfBJkaGq6zKZad4zjKA6fkS7U0H5/Ax8ql5VfWzXo6PJR4Gddr+JyuKgKGRgoDsT8RWtDmVqVqPaIlMTYAxQ+YvPiRjzdXRSuu8R6SelI8Io7mJR5zJidXbmcbAL1HR1x3ljnd9t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(2616005)(38100700002)(31686004)(36756003)(4326008)(8676002)(186003)(66556008)(316002)(66946007)(66476007)(5660300002)(53546011)(6666004)(2906002)(6506007)(31696002)(6486002)(8936002)(508600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW16SFBlSXYxSGRxYjE0a3A0QkU3YXBBY2crMldjUXFOa1VDUlJYUUhPM2Ft?=
 =?utf-8?B?RSthU3lIYW9yZDNsb3RxMHo1SmlFUHB5WTRTeGZrS211Z1ZVRUU3eXhTaDhz?=
 =?utf-8?B?bGFiQnlpUHBWQWtpQU54ZEhEZ1h1dHVHSXJkYzJKN1NZeGM1ZlN5OXM0RHFN?=
 =?utf-8?B?UGhMNUNVUUhwbzk5aGlHdW56cFpzYWFHSlRqdlcrUzRkai9OY08rM04yNGNq?=
 =?utf-8?B?ZDVVZlhhMVlzYUViV2lmbVA1VFZPWFFVN1dQalJXN3BBUnVZbFpHKzJza1N2?=
 =?utf-8?B?RERDeWRGeDRIbE1HQUtBYndlbWdTMWp1WFcxZ1lJaGQvaFJZTFNzMEZpV3I5?=
 =?utf-8?B?ZXpaOUtWaHBZOXM5VDJqb3RQMFNuamxWYlErYjFWSUhJc3NUQ2hxamVTMm83?=
 =?utf-8?B?Ri9uYWxEeGpBWUIxWGNGdGFJQ0Era1dnUjd3WGIxaXB4ZkZnMjVUdFhlMkoy?=
 =?utf-8?B?aTRSam95REFNZmV4ZDFic1cxWTRzWjJNTVVIVUJ6ZU1TY1pJODNYQW5pSmc4?=
 =?utf-8?B?STlpaTh1VVBGa25aZmJmK0xyalVWaksvQ09BenY0WmVkVkQ1aXlVK0hYMVpi?=
 =?utf-8?B?V2NFY0tYd0lNbjI0aXJ2TDNuZWQzY1FXSTJoMmRSZmszWExVczIreW85YzJJ?=
 =?utf-8?B?Vy96NEFIejFMNVlDT3ZCa1BZZ25zNURPVm5xelE5MkpaUDdWTDBleWt1M2RU?=
 =?utf-8?B?RDBqQTRvdW9UM05IZFQxekFUdThZMitrdDRrQ2NIc2FZUkJiSTl2VE50UHNy?=
 =?utf-8?B?SHBKU2Y0VFdNM1p4Z1VRM2duZ25QK3NRSHNaVCs1TTd1VUUvR1p2bll6WUli?=
 =?utf-8?B?VUt1cG5yUCtOaWF2RG5NY0dRSzBZMTgyWkZ1UVlvS29DSUNKRWtPWWJuV0FL?=
 =?utf-8?B?ZXJ2UDNaQVhXMWVLQXdmYTFaWko5RVpNa1ZRRXFXZ0QzSFE0NzBqY1VKUVZ4?=
 =?utf-8?B?RDFmOUdLSWRJWC82ZDNiaEJ3UGZTcCtFQ1pLNHpjNy9WQi9rVUJ5Y29zQjdn?=
 =?utf-8?B?MUhHRjBHUnpRZFBZNEI0bUp4eWgrVWJzKzZQT2pzOERrN3FSQ1I0N1ZaMkRx?=
 =?utf-8?B?WGs2bkVvcWNvSkJwV0xVa1ZCOWoyUlptMHBydjJBNVdlMmE3MGEyaWRoRzRq?=
 =?utf-8?B?RW1OV0R4SXMrOGJOakxLdndWNWczcjAyRHZKdFlDdjJ1REo1OGFENXdXTWY4?=
 =?utf-8?B?Nmh2ckpjOWgzdkpFa05vMGpBMW9FblR3cHpENnFUUTQrbUp1NG5HWHM3Z25I?=
 =?utf-8?B?TGlrbXJKUi9qUC9BeXZ0VWg2OWR3OUE3YUp3ZDdPdjRjR3lxVTJodTd0LytM?=
 =?utf-8?B?dmRFdHRYbkw5d2dSa2pTV1N3K0VGNXEydkYyQ1piOFZ3c2YzY0trM1FXK3ly?=
 =?utf-8?B?eERLTjNDNUZla2dWRml2WEptK01wNmtOaEwzaW9kY0ZDUWg0aWFjaWtzQU9l?=
 =?utf-8?B?TTBRVzNrTnNiZVZJakovU25EZEhNNGJTV0lZVE9aVUtGUGJSNnZBZXRGOXVB?=
 =?utf-8?B?OWVlNGVRTWFqSnUvVnQ5NUJGeTBoNnpaV2dNU1FENnBzYjJUK2ZwOFBZTWNN?=
 =?utf-8?B?cTFDNU9hVktXQTZFclh0ZGdsaC9Tbkp2Rjg0Zm03Q3A4NXVqdG1JSXlGbldO?=
 =?utf-8?B?d2M0b2lUcnZXeWtndlNFL1pCZHRFNkJXUlBDcC9NWnd1eWtyZDQ2anFBREd1?=
 =?utf-8?B?L0Rpd1J0OUFwY0lyRWEzMlQvczZNRWZmc01LR3hrWGRlRzNXQTFacHZFMmN6?=
 =?utf-8?B?R20xRkxITnh5NngrQ0VjNEVBUko4TytzSEFidDZxaXZsZjhjOThYZ3RweDJU?=
 =?utf-8?B?RE1KNzhYNXRTcDh5NzduSGllRVBGYjZOZ0dMU1NDMUVtbDQyMVdydDN5am5m?=
 =?utf-8?B?ZzRSTXBLcGZLcnBsYzJrQ3EzM2lORExKNzRCdWtXNko3OThVaTlpSVFvWHp4?=
 =?utf-8?B?UFVLRVZCa0RVSDkvNmR0V2JZM1JhOUFaV2FUbkVyVHlWcktlT0tHSTBOWTI1?=
 =?utf-8?B?MTM1RGFqMWw3Ykg3SE9YQjM0d1V3RVRoOFBsa1pzdmp5ZXNhcTFzVUM3dGQ3?=
 =?utf-8?B?bFlMdkpkalNoeTB3OWp4S0xDYzRBVUlqLzJRSmFESGJOSWVHSktoMFAwSjFQ?=
 =?utf-8?B?OUcrUnhXSzdRQ3EwSS90TVg5TVhKV0JGQUdTdGhHbktaMm9mN0RmK2xKL20r?=
 =?utf-8?B?WFNVOGJEbFM3OWh5STlHdko4N0R2SStDY3Z0d0JKUi8wQm9ERG9sUlJodzFI?=
 =?utf-8?B?M2NCcXdhOTBMT25LQmNkeUthZE5Wc2IycnFjUXl4TEx6WUI4bG81c3Jkd1N5?=
 =?utf-8?B?Z29sM2NVUFdPR29FZkMrZndpOUNuby95SWlMSytqMC9vMjU5K3pCZDZGVUVR?=
 =?utf-8?Q?JEU4bxHP/sU9QvfKUaQfYsJsiJwMDYITLsDoAiaAoMmXN?=
X-MS-Exchange-AntiSpam-MessageData-1: jVAO91Rq6fYOvQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634ba232-11c7-429a-69b1-08da31723ab4
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 04:13:11.1343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Posh4HyTJE4L2YQUTdbGw0oV72wX30tSKY8+rh1CxM/gWrpM0ZbGAxws+o63dDki59JZbIGKINw/vZo32JS0og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0081
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/2022 12:38 PM, Manali Shukla wrote:
> If __setup_vm() is changed to setup_vm(), KUT will build tests with 
> PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests to their
> own file so that tests don't need to fiddle with page tables midway.
> 
> The quick approach to do this would be to turn the current main into a small
> helper, without calling __setup_vm() from helper.
> 
> setup_mmu_range() function in vm.c was modified to allocate new user pages to 
> implement nested page table.
> 
> Current implementation of nested page table does the page table build up 
> statistically with 2048 PTEs and one pml4 entry. With newly implemented
> routine, nested page table can be implemented dynamically based on the RAM size
> of VM which enables us to have separate memory ranges to test various npt test
> cases.
> 
> Based on this implementation, minimal changes were required to be done in below
> mentioned existing APIs:
> npt_get_pde(), npt_get_pte(), npt_get_pdpe().
> 
> v1 -> v2
> Added new patch for building up a nested page table dynamically and did minimal
> changes required to make it adaptable with old test cases.
> 
> v2 -> v3
> Added new patch to change setup_mmu_range to use it in implementation of nested
> page table.
> Added new patches to correct indentation errors in svm.c, svm_npt.c and 
> svm_tests.c.
> Used scripts/Lindent from linux source code to fix indentation errors.
> 
> v3 -> v4
> Lindent script was not working as expected. So corrected indentation errors in
> svm.c and svm_tests.c without using Lindent
> 
> Manali Shukla (8):
>   x86: nSVM: Move common functionality of the main() to helper
>     run_svm_tests
>   x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
>     file.
>   x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
>   x86: Improve set_mmu_range() to implement npt
>   x86: nSVM: Build up the nested page table dynamically
>   x86: nSVM: Correct indentation for svm.c
>   x86: nSVM: Correct indentation for svm_tests.c part-1
>   x86: nSVM: Correct indentation for svm_tests.c part-2
> 
>  lib/x86/vm.c        |   37 +-
>  lib/x86/vm.h        |    3 +
>  x86/Makefile.common |    2 +
>  x86/Makefile.x86_64 |    2 +
>  x86/svm.c           |  227 ++-
>  x86/svm.h           |    5 +-
>  x86/svm_npt.c       |  391 +++++
>  x86/svm_tests.c     | 3365 +++++++++++++++++++------------------------
>  x86/unittests.cfg   |    6 +
>  9 files changed, 2035 insertions(+), 2003 deletions(-)
>  create mode 100644 x86/svm_npt.c
> 

A gentle remainder 

Thank you 
Manali
