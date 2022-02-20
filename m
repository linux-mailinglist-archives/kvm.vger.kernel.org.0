Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CF54BCC30
	for <lists+kvm@lfdr.de>; Sun, 20 Feb 2022 05:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiBTEmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 23:42:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiBTEmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 23:42:39 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A463CCB
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 20:42:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtdUTfeaii9bIdpBLkdC74SxCeLYYrvN2whisCElVN6oY1pyzy6q1pFIfiIzAdCXDSLLDdKwA2F6P4fhfx7IIU4IaR1r2lPdC4BcrwfbGzTdj/2RRqgJ0jE/qY9X6BoUOkoZG6YsVJVhBhHhhfWeF7twWXMABKGkv0p0S0PWAU55YAw5Fvmoi3/e7I7fjYY8INgEavo7KDU/GyPWjrqAGFioyEnOplDlSKUL8NGgubhIhUhtBM7rFMqG3++cbXCif85pUr217gUBDfHUkYnNi8wlxAVGOSnszaQEnk72NbEeOIjgczUNcVmcL+znVTvoiNeXJCZyIC3KqAYJlYJhyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RYWH1u5zETxIVxbUwOj1fE7tbMEmSSEz+HuhhBHVNQ=;
 b=gb2dsZEpnsWixeGkrhFKqw4dQEEdaXsmxbIYdJspJK/6XeSDWkHlmhLvBlhFT2k1IFs+kMXFMq+NV8+DifknmrWndcsiXnsNUx/AbpDYqm4stAhR4xjSmHAcp3NTuTa881y2StqpmAylqGp1ga8tkrs0kdvVL8DloIRYxraGue9p2LI3WrSb5JwWs4Pxkwi2KNq5NxzhL8iw+PPGFFx23VJ3LS1w1Pw68p+XqVPEuk08w0YN9i39Y98ppA3dZ/zGbA1R+atiwBzbh5228ZaoOqzMRFcXk3NhJqLwNZd0cj9RXtUs3jBvim57Azdg8JlK73QYsrAKhkHL/QZc1q26ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RYWH1u5zETxIVxbUwOj1fE7tbMEmSSEz+HuhhBHVNQ=;
 b=wIm8yyVNphIguQ8V/NKTp0SqUcxWD4GUV1ynhhAvcV11Tk8m+kNp+72nfu+0kJ3wlBzV5fcmCh1hgqiHlfDk5e+xFd34EDwWy+elA9rSHxi1OBTiAIJWB1y8uCBut7H+gPSJUKvzfmWSgw67eVKxa5DBMaGJSwOl1NeLqFgfWhw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by CH2PR12MB3992.namprd12.prod.outlook.com (2603:10b6:610:29::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 04:42:13 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c%5]) with mapi id 15.20.4995.026; Sun, 20 Feb 2022
 04:42:12 +0000
Message-ID: <f2b37d0b-353d-28d2-2e4d-d564ac0043f4@amd.com>
Date:   Sun, 20 Feb 2022 10:12:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add routines to set/clear
 PT_USER_MASK for all pages
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-2-manali.shukla@amd.com> <YgqtwRwYbJD5f9nA@google.com>
 <e9eba920-9522-6a56-4293-b60c0f1b77ed@amd.com>
 <CAAAPnDH2LXkYkHpV+JTEmEF8PAGRP+wq7hR2nJpt53rO7bb-NA@mail.gmail.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <CAAAPnDH2LXkYkHpV+JTEmEF8PAGRP+wq7hR2nJpt53rO7bb-NA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0106.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::22)
 To BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c81c435-1d67-4940-7500-08d9f42b5c55
X-MS-TrafficTypeDiagnostic: CH2PR12MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB39923C831D15F3FB4290D7A9FD399@CH2PR12MB3992.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iwne9pKGATvyQvOf2Eh8IZwGoXIzf3SZ1EVZSzLEPHSeOvlS96Li8mfWkS4cl5Ip5wym2Mnf39e9V5DYZPaCOpjeghVqmC0ZVdZFcJjC+7Ui27XtP9jrO3/wwhIMo1eZLfl/uomA/logVRAAY+6xXAn+lrvknUSMdyJhczr0CQQaUWunSgl9ucjp+MTIFC6Lk9nzBao+Hz0cy1SaQX+xu/+qrG7T+r5LW0hLNxAex9qq8IF/Uo0/Dw6JfOnEu/IG237sXNVWIjUHwjSxTtj5rVw8LxRkEf3lC2XcSo1FjdS2eMV5Cw7tTKGPmrG/oDnuP5i4gMabnA7NB2BgHzUOASYYD4VgIvHHTsLMKcenA4mXjFjn4rG1AGXrDg3PkBciiaQxrwQN3no+6wGwWdJXpQaWYeN4L4LrwRCtLu1hfRFKueoNgQUkK4PR6u3W99rPwb2xQxYq0zjpuFMBf9589/xvb7fX5phsoOUSou8qXymtlezFOBzmNOcp5xzU7Oe34AOetWEntPEEKZ9lOVhSYIuzJqSX/NZa6MbUBqj+4lI/MdBPAdxWJvr/en34Fbhw2LClbFM93o1YKcl9Ky2jM/A3Vjlv5KcVmkR/AQzdnqbp/e6RRFIBf9hD13QVRsQwjCEW3KXeVk5uAfIv+gtmPUfVVQaBaRwehMzF7uOLPi23fYPdn/hEakYfKN2J+vCm3C10VCQUTsah5uM5Bcs8zdi2tNQNx3kjCbwFY+0LOjI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(6666004)(66556008)(2616005)(2906002)(66476007)(66946007)(53546011)(36756003)(6512007)(6506007)(6486002)(186003)(508600001)(83380400001)(31696002)(54906003)(6916009)(8676002)(5660300002)(316002)(38100700002)(4326008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDBBNy9vUVRMSE9ja2hzNHQ5THlkeGRVR3k2UVZVTXlKNm9KM2hyZnErakhn?=
 =?utf-8?B?bHluQmZiMVQ4NXp2enRMdXM3MWg2dDJ4UVo3WFJRbmlXMzhBMldDTVl0U04x?=
 =?utf-8?B?MHZWSnlnUlFmQlcvZHMyS2l2MU1zZEY5cnBUZldtZ0grd09yeUNhNlNvN3Iz?=
 =?utf-8?B?WExXNnl4S2JUZmxIUmN3aXMrVmFuWVp5VU92K1UwTGwrbkV4ZWVYUisrUnFS?=
 =?utf-8?B?cUhsaEhvZFdaSXRLODBOMmJoN3BHNTRsNzR3RmF4QWdxQXJCTUttVHhkamdz?=
 =?utf-8?B?dnptVXlNd1V0SUdTTFJqVFZIUUlaSjZUYk8rSXVOR3BJaUwzTmNDZVJQd2JV?=
 =?utf-8?B?dUJpMUg5dE4xQmpwZHlXRlFONGorc2hwcEVqeHRTSmlPVW9jdEt5YTh4SW9n?=
 =?utf-8?B?NkMySDFqbzhMZEo5Nk5PTXkwTzhpRCtFSjNYVFZmUmNkdU5ENDU0bTJMYVZk?=
 =?utf-8?B?ZS8zWHFLbUpWd25KT0N1TW02SGowb3NCY0k3Z2RDQyttaU9aeGFIOG1NNFRC?=
 =?utf-8?B?MmFpTjhJQ2JYQVpDTTkxMGRXZHdnVXRtcjY3NlBrNWFhcVNEN3BhNWhVV21J?=
 =?utf-8?B?VHNvM0Z0YTNOS0ZZTFBodVJpUlY1TnpGb2RoSThlUDQvTk5YTlo1a2ZLemJZ?=
 =?utf-8?B?Nnc5LzRiT1dXWVQ4bGFrT0NDMGtBcFBzZGNEUGhXTjhoM2ZmRGxzNENyWFBN?=
 =?utf-8?B?ZWNmcGFNS1hlbHhJeDUrNTkzREgyQTlZTmtCMmJPT0dGTDZrQnVQalF2OG01?=
 =?utf-8?B?WWwxK1dNdGRyZVVYTGVBYThNSGdkUE5XYW9CT0pyV2VUcllQc01Ma1ZPYzhE?=
 =?utf-8?B?MnZGMmZ5Lzh2b24yRUM3a0I1VkJRRGcyaUorUE90ZloxZ1hQcUtwSW4wM3FG?=
 =?utf-8?B?V1FMVDRlQ1Uzck1pSWJYaFI4QVlHZEVpcDBNN3lJTE1vcVIxT1ZnYmM2ZDlU?=
 =?utf-8?B?QTFKd2dMamNydFQwOHQ5bHpBSkNPanBCcityTTYxbERvN3lXV0VydnNoRU03?=
 =?utf-8?B?cGZqZGc0cjd0Q0dpR3A4Qjk4YmtMVEduZC9FcmZZWGpiU1dBSTB1elFJdWpZ?=
 =?utf-8?B?eHp0a3ZtRGt6eUgreHhlQ0twSXV6ZVhZekxRZU0zQ01vSWhoZlNkdTc4RzVN?=
 =?utf-8?B?UVg4SHFPZDNFamx0Q0d1OXgyb2Y4Zkx2Zi9XWmdKekdjL0l0a29FYm5zbGN5?=
 =?utf-8?B?elVHVS80TFlLR1V6S0U1OWxhaHNsQXpsNWthTmFtYnpMZU9VWElOTjVWeTY4?=
 =?utf-8?B?dlRVN0NxQ3F6dUVYSXlSOW9kcVdJWHpXZVdpZGE0c05KTXRUOHpBTDFkWWtj?=
 =?utf-8?B?RlZWOSt3SzB3UmlYaDZWbVN3cTdKZlBRaVpvS1gxd1A3aTVpZTRzY0Z2TGpT?=
 =?utf-8?B?bFlhYWhJZXhsUGlFelVYMEdYSnc1WUNNN29ta3VmT3JvbS90RkNrS2twL0R1?=
 =?utf-8?B?YWxsQy80N3krVHhzVGphSzEwbkJ2SGZYdnp5Q1hjWWZnNzFRdmVCUVBpUW9o?=
 =?utf-8?B?V0R0M09BenZFZGw1TjNEQjBHVHl3ZEdjYm1RMnB4SGQyVStwWHQ5dytsakZt?=
 =?utf-8?B?MTF2UUlLKzhTOWl5azNaZm0vcEtSYUVodjVQdktTR2lKR1ZJV2lqRU1FSXBX?=
 =?utf-8?B?U082SnZiSUo5ZzFFWnM2bHFMSFQzbWxWTWZtaStUdko2WkNDNUliZ1NRQUgy?=
 =?utf-8?B?QkZwTWk2T21mSndMU2x4OHZyakFXY1ZxbXAyRStFa1l2dG92bWp1cGlkcDhx?=
 =?utf-8?B?aDRUaFVtc0hRUWZjTUhTTHg3TllkRUNDQ0l0a3I0K0cyekpjSkRlN0N5TUhl?=
 =?utf-8?B?bzVTT0pRbHV0T1NBZmlnWlI2c1luYWNlZzJ1bEN5bW9JNnZ3aStHRTJiUVdk?=
 =?utf-8?B?ck5TOUNVOHRnMHVybzBIUldDZnVWN2xZbXdKVklRWFBYNkxyT2piSWJmNVhu?=
 =?utf-8?B?bUFPenh3RFIwQmJpOWE2dUsxcmhRRVAwUnNINEhvRkFuaFI2Zy9WV1hGcjl5?=
 =?utf-8?B?Y1k5K1lxSVNkTVVMZ3dsV3lzaVcyYzVaQ1owNm1VVDBEd1cyV3U1WUdXTEFH?=
 =?utf-8?B?M0R4dlRLMlIzVEg0SU95WnBsM2V0S2xuQ1ZqMTlEZlBwWlZrYkNCaUJOS1hE?=
 =?utf-8?B?cndLRGpBaEJ0ZFpmVm9xUC96bGxPdnNHUGVMR3ZOY2M4SDNMaU1qcCtYUUR4?=
 =?utf-8?B?QUk0TDF2S0dGVyt1dFZmVHVCa0JkUTFiVVloWE1QK04wOThGQ29NKzlDRXFT?=
 =?utf-8?Q?W0jEce4kvdZJL5jUM22Qb2KlVsCgXBQWqYJ7NcABDg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c81c435-1d67-4940-7500-08d9f42b5c55
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 04:42:12.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lflCc2so8Xk7a0FrpJqbI6xvW2OVdUdl7YX6AoIiW5JHlRvBUzR24ADsS204c1mgVSyhYowD4aLx0yhQkX7tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3992
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/17/2022 8:04 PM, Aaron Lewis wrote:
> On Thu, Feb 17, 2022 at 3:55 AM Shukla, Manali <mashukla@amd.com> wrote:
>>
>>
>>
>> On 2/15/2022 1:00 AM, Sean Christopherson wrote:
>>> On Mon, Feb 07, 2022, Manali Shukla wrote:
>>>> Add following 2 routines :
>>>> 1) set_user_mask_all() - set PT_USER_MASK for all the levels of page tables
>>>> 2) clear_user_mask_all - clear PT_USER_MASK for all the levels of page tables
>>>>
>>>> commit 916635a813e975600335c6c47250881b7a328971
>>>> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
>>>> clears PT_USER_MASK for all svm testcases. Any tests that requires
>>>> usermode access will fail after this commit.
>>>
>>> Gah, I took the easy route and it burned us.  I would rather we start breaking up
>>> the nSVM and nVMX monoliths, e.g. add a separate NPT test and clear the USER flag
>>> only in that test, not the "common" nSVM test.
>>
>> Yeah. I agree. I will try to set/clear User flag in svm_npt_rsvd_bits_test() and
>> set User flag by default for all the test cases by calling setup_vm()
>> and use walk_pte() to set/clear User flag in svm_npt_rsvd_bits_test().
>>
>> Walk_pte() routine uses start address and length to walk over the memory
>> region where flag needs to be set/clear. So start address and length need to be
>> figured out to use this routine.
> 
> For the start address and length you can use 'stext' and 'etext' to
> compute those.  There's an example in access.c set_cr4_smep(),
> however, it uses walk_ptes() as opposed to walk_pte() (similar, but
> different).
> 
Yeah PT_USER_MASK is only set for text segment in set_cr4_smep(). 
In #AC exception test, PT_USER_MASK needs to be set for user stack pages.
So, setting PT_USER_MASK for length('etext' - 'stext') of 
memory will not resolve the problem. 
Please let me know if I am missing something. 

>>
>> I will work on this.
>>
>>>
>>> If we don't do that, this should really use walk_pte() instead of adding yet
>>> another PTE walker.
>>
>> -Manali
