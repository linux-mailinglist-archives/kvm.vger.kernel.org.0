Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E7B527CF3
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 06:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbiEPEpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 00:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiEPEpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 00:45:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2079.outbound.protection.outlook.com [40.107.212.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF3D13CC1
        for <kvm@vger.kernel.org>; Sun, 15 May 2022 21:45:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZbz+4v3X8fc8UB4qpscxUQLnh5JnYALF1EGkoLer/IUI1ZEqzpetoy9ArYlldXUEve29/TnJXQCct7bWqZPonWYd9ZOX7rr51ysuLl6B2jGJGxw7PmGaBbXxz0l9RBAcaT2nEkiJV0N2brnkHx5E38t6yO8wMRbZ6kq64TyO87yAYBcKgq4Wrhf3dPpai9yU/LOcLOadhQtnFvJuF2/ZMnUa1fgkiNymTBXWE5r0B2dIdXYWbivs4ytdZQSTQK/78840H9rD+lNbZpVv94vU2+bukN66AgTEurg47M01IbIHpq5x93hi8qIx23QJ/o+x1069fDtNZum28QXOx56MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q46jFaPQ/myRQ8fBqbD4ppvNwoH8cIPvOPhzbRlnfZo=;
 b=QWSaJP/vIAdfem/sAdtfDVYZ7LARMI+WtoShKsAOJmS+4nReo5dic+Tu0KBylaPwnDGl1eAwMDhEm2Lfr8gHXQhxEFrlGF7oxNOiT+3GTVpm+ANo7PU/sW+IxARKQAYMGYt0Ws0LuuyPZGal7QQfRNcB2ugcjZwa+vA8NbiJDNWTETuMGII/vaWmmH4f3w5a+fH6Kw0g1TyFAFpJ4V31ZRUky8jptnomE8pk6kBJczWoC++SwTRg78Uidqi0jnPaJ2jyqMxlbCo5RoPX7Yoft9KXMCC6kPLYOMMHePCcIBQ/l7folwQN7R9PhTpRX/b+anD9pzzBoTmEgvmJrTwQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q46jFaPQ/myRQ8fBqbD4ppvNwoH8cIPvOPhzbRlnfZo=;
 b=qxsrRW7DK3mPwNhUnPgWkxzht78eiVERqXusG2oFeN8oLmxHiJvBFCQ8gFFerKdKX2zmhTFoBB99SC0TwUuKt7RC0Uofwt8ZdskGXNyyuvWwJ0wcWxVen057jKzQoQfyOhKOLsRXfu4ktXAiUURUiM2iR3raCgWg7SwnDCMlaI8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 DM6PR12MB3081.namprd12.prod.outlook.com (2603:10b6:5:38::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.25; Mon, 16 May 2022 04:45:13 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8003:f623:d223:ee62]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8003:f623:d223:ee62%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 04:45:13 +0000
Message-ID: <420e1cda-61ad-e7d1-df50-0cd6907ff329@amd.com>
Date:   Mon, 16 May 2022 10:15:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v4 0/8] Move npt test cases and NPT code
 improvements
Content-Language: en-US
From:   "Shukla, Manali" <mashukla@amd.com>
To:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <1b1998e2-0ff9-23cc-aaff-4f1e5ae3d06b@amd.com>
In-Reply-To: <1b1998e2-0ff9-23cc-aaff-4f1e5ae3d06b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::10) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d806ea0-b786-408a-e7c9-08da36f6dd6c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3081:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB308156D50149FE52ECC9F2C9FDCF9@DM6PR12MB3081.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jr1/fjM2IDeOPPJxPnYahADLuMVsOWrh4BWpVFrUprqz8BxpDdqWTB3BXAGZvhEVIoCmrGz32FfvdH3PaZTT8nS3tx2hensYMt1dLU0b1RVal7C5VnArp1IExnYdiZpyAxQxky6vKuQvyohPdtjlT9mqkEDuN66G83QwCMls9oF2BSPeP0rLwQ6ZUDTQNWa34F/zQlDUAkVc6tPUqJrOvzZU3PrPnDVlziej5p1saA3LokjuXzMaJNlfxty7c6V6udl/C50DglslOp3GE0GJNxD875ufntjergvWyR+VnmmJUMvvtJadsSB+rBSYp5LC30cY1Si5ThSuX285q4yAitSqPXkBuo1s+3DFPkuIK7tFAta7PfVsrsCdTqsP7pQxOkKug4fupz5uUgrWCvI55R1HsJbl7D5y4f6gXV3ygwRaIXee8sKTwUybCbQXzzKgZmo1BlSdaeuU+YIe+T+IZDGQBgSDrXZrJnMo6rF9LB1Ygdb69JU1K1szx/+IuWPIrN3t/lM0R/x8yZYQ8IWCu4+3nmsFldTNFN/2iY/UJFBE1IYniXummkSDzumbN6tyEy0Q3aQJqm6eeAikAbuYMC1USztiDaZI+zt5UoBB6cTP3OuLeQgiGb6TeeXrltu5dd3NqrzD9QS7HnpsQcS+s8cDwizJy0yqTD5waXrEEcgc0geIU2mdWQ6hy46RWUplzygPzog5Zdu9KpqFfJ9abuOiiJncXhfpdxT6ODgJ/4FDbJ5svSCMBLcobi84CSR/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(31686004)(31696002)(38100700002)(5660300002)(2906002)(6512007)(26005)(186003)(508600001)(6506007)(53546011)(6486002)(2616005)(4326008)(6666004)(66946007)(66476007)(8676002)(316002)(66556008)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG1tc290eUdacnBjM3N0M0ZiZkhCTXBrdmFCaFZYbVpndGhDRkR2bWNzZnM0?=
 =?utf-8?B?RXVWQzZhYytOOFp3WW5JR0JlQW5KaUJVQm92SWpBODdXMXhqWHF6UkYyR3lJ?=
 =?utf-8?B?ZXQ4b3paZStYRVBqR2xkaVJYUTcyTHJpRDJIQzZOMzdjUVArUmpWMkZITVNu?=
 =?utf-8?B?Sy8zZzRuUVE1NjBrME1ScFpqSW5UY0MrR1p6amMzcHE2OGtuVngwVDZraGdi?=
 =?utf-8?B?TGFqNW14U3MwOHpwOS9VTmZBVFd0NUg4S3NpbnhLQ2M3M25YOG1UMVVWRndO?=
 =?utf-8?B?ZjlBakZmdy9xL1RFUGpLTUNFcHJ4bFptQ2Y5c2FxNnhUZ0FtKyt6eGlpOUdo?=
 =?utf-8?B?MEZ2NUliNmFReU92NDFnMmp1SlZhZ1IxRGM5dkgySjY5RU1qTUw3UEdhK0Q0?=
 =?utf-8?B?bWwvdTBSV2FDSWw4MTh1cStWQmJ0cmNkc1dHMTlhTnpjUCtVMUlRdUxWaS9B?=
 =?utf-8?B?VVppM3ZxNFdDRk9RYUxRN0RQZzRaWUxlY200NVZVRE1OLysyVDVNQW9nQnpG?=
 =?utf-8?B?NlR4WGo3ZUxZVWY3SEpqMHRidXUySU1qOWIrMzJoNk9ZK3lZM2trVWdIZzRq?=
 =?utf-8?B?N0hkV0ErNVozZlZOSzN6Yy96QVo3c2dpOWd5bVJweS8wbzRlY3RYaUhSNjJs?=
 =?utf-8?B?RjNDK05LdTdiQm1PWTV1V3NNbFpoNUprL0R2OFpnL1BDa2RzeGFvbnNLNkpv?=
 =?utf-8?B?RHcwbTVxamdyNTRSWjdoQ3V1NjlERXBNTGwwcXFQWDV2MlNsRnIva3ZCRGV3?=
 =?utf-8?B?WGtyeXo1b2JoNG1ZT0FWM3dKTUR6bW9yNC9nOGhSVEM0NnB5a2I1SHRnRTdO?=
 =?utf-8?B?VjEwdS9GRG96cnYwRmNnbEdKZklteUZjTzJnRWwrbnY3bllBVU5BTTF6VS9N?=
 =?utf-8?B?QUNjeDd1QVd0azRjakMzcERaa21KWXFicnl5VmRSNXgwQ0VTWVNMcDdZZ2FC?=
 =?utf-8?B?c1ZFVzBCZkJrK0NzemJEV0pEVkJGT3Z1S2hjc0tva3VQM1dsNFIxZFJSUXFx?=
 =?utf-8?B?Z29SQnRkSnU3MXBhb2NhVm9pZk1LSkpweHRIV2FFMkYyUGV6Y1BMZmFKWjBQ?=
 =?utf-8?B?REJ3OWl1ZS84Tldabzh6dzZEZkdMM0IvZjFVeWdzNDBSM0lNZzZ2S2dnclQ4?=
 =?utf-8?B?bWhFVDBRQ0dNdCttdGI1QWc0RHhWbEFRTXZYZmRxRkMrdjFaa2Z5SnIwSlFK?=
 =?utf-8?B?YWFabFpRMjc1OWRjREw3REl2MHROdVNyaG5raSttQUNtZU1wdENsVlBVTmU3?=
 =?utf-8?B?Q3ZSYXZtZ1k3aEpNaFFoNnBBaTd2WVg2STY5TXFjbHNOS3puYzJjVWlXN1Vj?=
 =?utf-8?B?U2gvUGR5Q3JPZlo4dTRSWmw3LzgrUVF1WEx2Yy83MGk3Wk55eFAvRzZhQzVq?=
 =?utf-8?B?aDJVbEJZVHpyQk9Rekp3OWxVT2hxMFIvU1FDcWlBU2dFMkFaS1AwM2t6Y01l?=
 =?utf-8?B?Qmt2SWZudmh4b3hnLzhjc0llWDNxVHpRc0dFL0J2bC9kK25pTDVwY0ZjeXla?=
 =?utf-8?B?WWthTThYeWlXbVZzSFdVRFAwMXoxcERFT0R2T3JkUGpKVVRpRXZwVTFvTURC?=
 =?utf-8?B?MjdsN05WajF2MFlaYmhqbjlGN1FhZ1ZiditkQkVyaG9UbkI3dllzaXVHRzBs?=
 =?utf-8?B?YVVvQU9ZZTZQbTA0RkRsUHI5SEV2TVlnSUV3eXNWYlBRalFueTE1VXRRQnYv?=
 =?utf-8?B?MTBJektuS1pVRHN6OXlnRytTUXZPUGltOUJGUzlXQnFoUVhyM2QrczRaMERQ?=
 =?utf-8?B?Y0NFRjcyVHc4Tlo2cnNhN0hMNHNLUk9vcDhPV3AxY2x3K0FlQnZFaWR3RUti?=
 =?utf-8?B?UDFZNFVHVS9Wa3lrcVp0aE5PUEd3SUZ2cWlGYk10ZFJJc21pbVV6bEcxTDBy?=
 =?utf-8?B?N09rejdLVi9oUC9QRDdmN24weERtd2s3Sk5CbHF1cmh4RkZFMXhzb08yTGxw?=
 =?utf-8?B?Q3RoOHJHeENBSnlDcG84RXJSb0FtZHZRVGZuYWl2ZEJ2ODlrdEFObW0vWUdT?=
 =?utf-8?B?dGM2T3p4THE3RU9wOERtTDVnUlBrbmxCVHc1MDRsaXFkVFJGLzRkQVFpYmhM?=
 =?utf-8?B?bXBIVnF6ZGN3VDNYRlM3OWV0NmN4TUpkRlAyVENMb1VZanZHdW5JTnVpMDZZ?=
 =?utf-8?B?Sk40aHYyaGV3aG1scWxHdGRqUDBGa3gxakdJYW9CaHRjYmM0WkhWYk9ESkpG?=
 =?utf-8?B?WS9zVUtKamZlUHkyYmR3RUZBMXVabTlkMERHZnRSVUJUenlqcnNpVXFvOTEz?=
 =?utf-8?B?aTB4a2t0U0ViY2MvdkxZeFBQUEhveFBjTDNBQlF1N2wxWW9aRE9jSVlvTlpW?=
 =?utf-8?B?ZW5JVkE4alA0eVQ5ZWJKQ2NJUXltK0VWaUNGUjZmRzdzcXVnMnZxQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d806ea0-b786-408a-e7c9-08da36f6dd6c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 04:45:13.4395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W04FZkLyV7zhwa9ZdiNCAPckb3xEDCUhGznThFsColRDVotTjKF9H7A8HCryT4BkJ8lylgL+9L+MAOnK7jUeHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3081
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/9/2022 9:42 AM, Shukla, Manali wrote:
> 
> 
> On 4/28/2022 12:38 PM, Manali Shukla wrote:
>> If __setup_vm() is changed to setup_vm(), KUT will build tests with 
>> PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests to their
>> own file so that tests don't need to fiddle with page tables midway.
>>
>> The quick approach to do this would be to turn the current main into a small
>> helper, without calling __setup_vm() from helper.
>>
>> setup_mmu_range() function in vm.c was modified to allocate new user pages to 
>> implement nested page table.
>>
>> Current implementation of nested page table does the page table build up 
>> statistically with 2048 PTEs and one pml4 entry. With newly implemented
>> routine, nested page table can be implemented dynamically based on the RAM size
>> of VM which enables us to have separate memory ranges to test various npt test
>> cases.
>>
>> Based on this implementation, minimal changes were required to be done in below
>> mentioned existing APIs:
>> npt_get_pde(), npt_get_pte(), npt_get_pdpe().
>>
>> v1 -> v2
>> Added new patch for building up a nested page table dynamically and did minimal
>> changes required to make it adaptable with old test cases.
>>
>> v2 -> v3
>> Added new patch to change setup_mmu_range to use it in implementation of nested
>> page table.
>> Added new patches to correct indentation errors in svm.c, svm_npt.c and 
>> svm_tests.c.
>> Used scripts/Lindent from linux source code to fix indentation errors.
>>
>> v3 -> v4
>> Lindent script was not working as expected. So corrected indentation errors in
>> svm.c and svm_tests.c without using Lindent
>>
>> Manali Shukla (8):
>>   x86: nSVM: Move common functionality of the main() to helper
>>     run_svm_tests
>>   x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
>>     file.
>>   x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
>>   x86: Improve set_mmu_range() to implement npt
>>   x86: nSVM: Build up the nested page table dynamically
>>   x86: nSVM: Correct indentation for svm.c
>>   x86: nSVM: Correct indentation for svm_tests.c part-1
>>   x86: nSVM: Correct indentation for svm_tests.c part-2
>>
>>  lib/x86/vm.c        |   37 +-
>>  lib/x86/vm.h        |    3 +
>>  x86/Makefile.common |    2 +
>>  x86/Makefile.x86_64 |    2 +
>>  x86/svm.c           |  227 ++-
>>  x86/svm.h           |    5 +-
>>  x86/svm_npt.c       |  391 +++++
>>  x86/svm_tests.c     | 3365 +++++++++++++++++++------------------------
>>  x86/unittests.cfg   |    6 +
>>  9 files changed, 2035 insertions(+), 2003 deletions(-)
>>  create mode 100644 x86/svm_npt.c
>>
> 
> A gentle remainder 
> 
> Thank you 
> Manali

A gentle reminder for the review.

Thank you,
Manali
