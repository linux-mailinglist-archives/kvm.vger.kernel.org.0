Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCC85444D5
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 09:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiFIHaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 03:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiFIHaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 03:30:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6A712610
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 00:29:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrccvEgTxabBXB8PJ4sMCBk3ViO51joA+vo8/5rktoJi/e+5e87/Ae7sLMhiD7ILlt/dmJw8BfGNSZK9WnPqO38YyaNb3jHUsxdRVD8TTc+gR25t3A7wRBYEoWl75p0nORC/nNunp50kjo0OOo67XRHxut7/iBTpe5Scarg6tRpvZJBeCQpon87Mejl/AJoplUYjdPjqxBoaIJI+hS2gpxNDs2B7XU0BSRuQCOWWn5p5m6OJ9I10J238wbpzw0pR9IPpRzqzIsTyS7UK+AwbArMsPKXQLTpFOql+K1ntWKoLs/hIzIQsloX3415sL2tUQ/LApnVWlM37piG28D5hiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeEPr09ufLpnXc/i2tjhRzcCsCi8w0BOdf9xnib0XxM=;
 b=SBUwkVyY9u9su3ofxuvk+avTZ4FPmhlSFjmTArh39oE7B69Ux0Ia3l0uXNNcpK6MivbkDWG0v/nd746lDcTL6G6NQtIuyx4XvfVG7TefB2X231KZb5MCEvvIx6VPgGjluBW8aOU6IU7fazIDFyK5Ld7uA3C1uGyM1bhUOhTspV+RafbtyERu4u1+pl3M97Fb0z9ZIihZoVABJFSxUfdz9UKrL+3W0wEN1qP5jxJZO+ZRqX2U6uqIoonApb80gA1iEcww9lR52xeaQj44ZJJDgoMMKq73uTZNe/HT8YeqNmlsEhe5KEsxU6GMTzucVv5skRBtPKdRdqVlysF1QNSHUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeEPr09ufLpnXc/i2tjhRzcCsCi8w0BOdf9xnib0XxM=;
 b=IdFeIV0EZL+e88L4fVPoLKklapDY+1YNNsaoMfZ5CuwktdJSW8myF67okGTlq9upijiDdS4a//qodZRUcdYINvh4r8AcXFnGM+CIYpLkheCQ4Fjy+SjuvWl90UamMMeRUFfdRPxGjUEpBo7Nidpzy7/Qni7jQyziJF6qyjfSUvU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 9 Jun 2022 07:29:57 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::bdcc:775:f274:7f12]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::bdcc:775:f274:7f12%5]) with mapi id 15.20.5314.019; Thu, 9 Jun 2022
 07:29:57 +0000
Message-ID: <29c35f14-8941-288d-2a0a-6642bf399a32@amd.com>
Date:   Thu, 9 Jun 2022 12:59:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v4 0/8] Move npt test cases and NPT code
 improvements
Content-Language: en-US
From:   "Shukla, Manali" <mashukla@amd.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, "Shukla, Manali" <manali.shukla@amd.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <1b1998e2-0ff9-23cc-aaff-4f1e5ae3d06b@amd.com>
 <420e1cda-61ad-e7d1-df50-0cd6907ff329@amd.com>
In-Reply-To: <420e1cda-61ad-e7d1-df50-0cd6907ff329@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0204.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::14) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3e1bcb1-1dae-4d04-6100-08da49e9da93
X-MS-TrafficTypeDiagnostic: DM5PR12MB1449:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1449CCFAC26D8A678CCDF7DCFDA79@DM5PR12MB1449.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSlrTGHHtY5BVFyAWFot1hbTvt4+mI+a0PluzD+ldOFcB/OvsI2P8z0i9S5xcoTG8Imt1dcu+D9wjZvyFu7DDc/shEUeWsHdYWes3WPARbqoHpEv+yle5Pfeb+GoKNaz2T6PabpxezoByuYMgXwQKat/o+2HyPSA1oyAge70Kmo6G8qerLQlNERr7ey1FTWFlF6adNJTXxpoLa25VUf9+078ydFWMO/TZlFT7Atyqz/x4I5BQiy0KK2Jj+KjL6aD/Zd3L2pB+LD8/gGgftS50vagip2I4uMJ37Gns6zalug0/ejEjMddNKhdRDf1Qg4kIYI/w9dkbpui8NlkywrIWsT9TZC4nQ6ajjDuTCBrjrOOi42S0CRY1kjefOAgXi23tix6id2WJf7n2s/DlPtv+eBF4g7qfpfOw+QbmCgCPeZKk5ejTl2SQHUeGO4N+FNNCXFw/SJMbigNaC4bvBKZi4EBKreUO81dC9DysRld13XqCB8DEwnPok+i0I1ZlsylG/ZAOGisATTuCwH+vJDOlnh/DWz4yY5ZHap1rFFN4wyjAsFYb/c318/U0pG9qlwRU5CSK4d3ibOXApinqEkwUV5fkP4rqkikZXZzqhPalhul0+goNkvwYaOzQ6kDsQmOW3gw1SdJtP8R+pQfhH3vysvBlhpN8op6Qe5W5s39hZmzlf/PIlF61kUN72G5lR74geDC3R9nx+7vsnNIRFb/Lsi6J2FQ7t2DRKqV4MSAd74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6512007)(6486002)(53546011)(6666004)(6506007)(31686004)(83380400001)(316002)(4326008)(8676002)(31696002)(2906002)(5660300002)(36756003)(186003)(508600001)(66946007)(66476007)(8936002)(66556008)(26005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHNGTDZSS0pqaUNnYjVIcEFhS2hGblB5aGN1MUlrdEIydlhmZEtIdStRdm9y?=
 =?utf-8?B?L2hEZFkvejIwUVVMeWZSSlp6RlNZS0JYN29Id3RBNEFDdWhuV0ZGWHJSNStl?=
 =?utf-8?B?YS9Hbkx6eEpSUmJwU3ZIaFVpZk9NZUlwRVQ4MXZCdXNqKzNFUFJEYVNhZDhQ?=
 =?utf-8?B?blB1QTgxSXltRTJTKzZsTS9MQ1hla3BlQUgrS3lTSk9rd3dqT1ZZbEZPZDU1?=
 =?utf-8?B?eWh2Q0djREJVbWI0SW9iZG1ieFBnRVdMODJnYW5RV0swZ0dveTdXUTlySzF6?=
 =?utf-8?B?eG9hVWdmbWhOYmNOWGFVWm9BVDVIMDdSRFBpcHVpV2oyTTRybWtoWnZ6cHVD?=
 =?utf-8?B?ZkZuYmVEZFNqR2xjanJjczk1TlBpam9pZUdCblBqb0lJSzRYbVY4TWdyd09R?=
 =?utf-8?B?QXZNc0NDaDU4YlJJMTg0bkMvblFjV2MrYXNtTEp3RjdoTnZCQW5qQ3hFeDRJ?=
 =?utf-8?B?cWxsbVkreGRYblRoSEhkRW1FVWR4WWxlV004bGtCZThmYTl1RU52Y083TFpm?=
 =?utf-8?B?NzZwTXd3ZkRVQmdYMEpKTDR6bnJJM1lyN1FoK0VzaW5OQ0NPVXBHSU1BbjJ6?=
 =?utf-8?B?bFkvU0dOT1FqYlJpWUJKM1ByeGxyVVRoNkNlSGJDOHQ4Q2dVUFVkSEkyTVhX?=
 =?utf-8?B?RytQOFJ3TFVXemtoVkVkSmphaHhlS201QThKdGJCd040c0luUTN6UERjWTNE?=
 =?utf-8?B?UFVLTlZKV0VDTkQ4WC84a1JNa1FsVHo4OHprOTM3RFpGb3crOGw1UG4rdjRo?=
 =?utf-8?B?Zmc2Z2FITW9iKzhRckpLejdKOTNZV1BSUVNtUEdPNGdKTDJYM0ZJUFE4Qkti?=
 =?utf-8?B?SVl0Q2NncERudjNLT25RWmlwTjJoYVRFMUNLNTgwWlJRWHUrS0tDUEhHQ1ZD?=
 =?utf-8?B?WFBXMXBsZWdEZzJ3WmRaOU01c0lSeGdEUHNhOWhnYks1dkUwYWtXWEVqTFM5?=
 =?utf-8?B?RlBkVndCbytjTTZsUVY0ZVZ0VzllenhGQ21oaUNEbXd6NThYMXZSYmVTUExF?=
 =?utf-8?B?UjYzZVZ2cnlPZTVVcDdPNkVJTndKWkVLdHUzcHFiM2xqSk1uZElBTFNvKzVS?=
 =?utf-8?B?TDBwNytEOXBPWTZBeGxGUXlNY2ZhOEN0SXhsTjF0WFdDTXVQOG0rY0Z6eXlj?=
 =?utf-8?B?Y0hkcmlTNUUwd1F3RTdPdThtWTEvbWFNU1FGSVQ3T0JldEhFNW55ZkdrSnpq?=
 =?utf-8?B?d055UGJoWkJDdEU2U0tiTm5sZFQ2TklteVlLUktnV1ZlQmNiNVI2MEhIYnJj?=
 =?utf-8?B?Q3d2U1N1Y0pTVkxSZlBMbmlWTUlvaGlDUjhGeFFyRDdKNHBBMllka0Q1eENq?=
 =?utf-8?B?ZVUxRzdxK1lwUUZja1o5d1BjOGhNZGpLWUN6SWN2enV0QUF4Z0d3QzJOR0Q3?=
 =?utf-8?B?c1JFcFlGN050eUlKcnpLTmdTcng4UytJeTduOFRBTlBEZld2ZG1lVGRqQ0Vp?=
 =?utf-8?B?aE9FQld0Ykh3S040ZWRMUzFGODZtdHRGazBFRE1tWE9SUHdKeEllWFEwKzFW?=
 =?utf-8?B?WTBlY2U0S29BNzV6Y3pQMElSZkRRSGxDVlV0eXpxK0dyUENXTHlwMFpKYVU3?=
 =?utf-8?B?cTlUb2ZYK3UwQ2dpUno4eXQ3ekVLTVRtcUZvK2ZGREd2RjJjNkhOTW9MV1Q2?=
 =?utf-8?B?RHhrR3BNYXlOaHZMSmpOMHRxc3dzYUg5YXRhQnZEUzMrU0JIU05ITm5QM0sx?=
 =?utf-8?B?UkI4N0d2UWdxNld5WHd3ODNTK3ZtRnZhcnl6dkc4eWR0ZmcxZXRvblk1d3Vk?=
 =?utf-8?B?VU42Yk1vM2ROaWU3amsyN255NE9HZFZjMFdyZkluN2F5YXEwc3AvRDFTekxr?=
 =?utf-8?B?K0ZLOXdicVdFUWtLWStIWktaQi8wcTljV09sV3RPc2pzQXcwMGVXdVp1ZzJV?=
 =?utf-8?B?enFpaVFLNkU1Wm1nVi9QMjRwd1J5T2YxampydG93K0sva2Z3cUsyNTFzbjhF?=
 =?utf-8?B?d1pTZ0srWWRHWUlDcWZLeGdvK3pLUUZ1R2dEKys1UkVJNWRNMHMrY2ltUXhQ?=
 =?utf-8?B?WTdmcHVaeVFzVWJmbjZkeXFEY2dwR01tQ2YwUUd2VVdwc2ZTZ0dQbk5JZHd2?=
 =?utf-8?B?TFB4VEJ5Rnhqc3kxZFQzcGgzTU1nRS8xY0R2T3VVbzhZdEVualR6RnRlVzl4?=
 =?utf-8?B?SDdaYm1QUkVMcHliZlh5OTNyb1M5bUs4OXM1MG9NMU9taGJkUnJTaG5RSDJS?=
 =?utf-8?B?aEUzYmxxeEdvSU9lc0ZxbW1oT2dpcVg0aHpqSVoxNGNKaHdZc3IxaGg0TFp4?=
 =?utf-8?B?Y2duc2xzVU4vd01UQUdBREdJaVZPcC9rbVM0ZGdNTlBObm1idm9WV0xqdkx4?=
 =?utf-8?B?dzdtclRyUFQwMU92MStadXhvWGJUS2w4RlIrRGhxOUU5OXBOQjNnUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e1bcb1-1dae-4d04-6100-08da49e9da93
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 07:29:57.2770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEw3PWmkcR6HOBUIxLF4q149U1XCFLTbRQffbf74uTG5Ae3xTUv9HpApCGVE2O5ODLitxgX48xCYSKASsKahug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1449
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/16/2022 10:15 AM, Shukla, Manali wrote:
> 
> 
> On 5/9/2022 9:42 AM, Shukla, Manali wrote:
>>
>>
>> On 4/28/2022 12:38 PM, Manali Shukla wrote:
>>> If __setup_vm() is changed to setup_vm(), KUT will build tests with 
>>> PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests to their
>>> own file so that tests don't need to fiddle with page tables midway.
>>>
>>> The quick approach to do this would be to turn the current main into a small
>>> helper, without calling __setup_vm() from helper.
>>>
>>> setup_mmu_range() function in vm.c was modified to allocate new user pages to 
>>> implement nested page table.
>>>
>>> Current implementation of nested page table does the page table build up 
>>> statistically with 2048 PTEs and one pml4 entry. With newly implemented
>>> routine, nested page table can be implemented dynamically based on the RAM size
>>> of VM which enables us to have separate memory ranges to test various npt test
>>> cases.
>>>
>>> Based on this implementation, minimal changes were required to be done in below
>>> mentioned existing APIs:
>>> npt_get_pde(), npt_get_pte(), npt_get_pdpe().
>>>
>>> v1 -> v2
>>> Added new patch for building up a nested page table dynamically and did minimal
>>> changes required to make it adaptable with old test cases.
>>>
>>> v2 -> v3
>>> Added new patch to change setup_mmu_range to use it in implementation of nested
>>> page table.
>>> Added new patches to correct indentation errors in svm.c, svm_npt.c and 
>>> svm_tests.c.
>>> Used scripts/Lindent from linux source code to fix indentation errors.
>>>
>>> v3 -> v4
>>> Lindent script was not working as expected. So corrected indentation errors in
>>> svm.c and svm_tests.c without using Lindent
>>>
>>> Manali Shukla (8):
>>>   x86: nSVM: Move common functionality of the main() to helper
>>>     run_svm_tests
>>>   x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
>>>     file.
>>>   x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
>>>   x86: Improve set_mmu_range() to implement npt
>>>   x86: nSVM: Build up the nested page table dynamically
>>>   x86: nSVM: Correct indentation for svm.c
>>>   x86: nSVM: Correct indentation for svm_tests.c part-1
>>>   x86: nSVM: Correct indentation for svm_tests.c part-2
>>>
>>>  lib/x86/vm.c        |   37 +-
>>>  lib/x86/vm.h        |    3 +
>>>  x86/Makefile.common |    2 +
>>>  x86/Makefile.x86_64 |    2 +
>>>  x86/svm.c           |  227 ++-
>>>  x86/svm.h           |    5 +-
>>>  x86/svm_npt.c       |  391 +++++
>>>  x86/svm_tests.c     | 3365 +++++++++++++++++++------------------------
>>>  x86/unittests.cfg   |    6 +
>>>  9 files changed, 2035 insertions(+), 2003 deletions(-)
>>>  create mode 100644 x86/svm_npt.c
>>>
>>
>> A gentle remainder 
>>
>> Thank you 
>> Manali
> 
> A gentle reminder for the review.
> 
> Thank you,
> Manali

A gentle reminder for the review.

Hi Paolo, Sean,

Shall I rebase and resend this series?

Thank you,
Manali
