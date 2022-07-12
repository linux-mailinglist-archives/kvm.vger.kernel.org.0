Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFCC572115
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiGLQgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 12:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiGLQg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 12:36:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD004D4FA
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 09:36:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqEjB9VKGqGhgV3K886eLZbMhvegNrA18lb5qugWnVj8EyS5/GaRB4PVYG43YcQ+9aZ8T/pz+LYFQYcrDCwKZV774C0gECwGiAHHZkn3caNy0iIzFk0CJKkPBJm75mMzWVxhcBlsBhbcM+xh8qZ3UjheO9N5ZwKXV8PoWXUV50PdOzaX/GruAB5/DBzJJBhMQoF8nx/uJAlQUnpCdCib2aGmbKrfCsNl4CRNX8ea0xS/U9Fi5vABObEcba6IA3XkTO8UuQ4FGG7Q60BB+yNzmYvpVfN0cctZI1NOgRq4jaQZGC/iRzlchb6veAZ36E2usxjHKcXZ3vd+stYMWnuk6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pxd5gWmQMz9wz9AspsMec4CRj1HG9myYQ3OHGTyRDMw=;
 b=aqKmT+3DWHC2kM/XodEcVpyd/R6JFq21Accz37z+ZWIg5TkUpu6hTJk3qJjru+0q0FF6iDiSzj0zA2dWxTo7U+ZKa2H+cD0trBh7q5bN7YopwKY0E6N2dFMgPbJJk6QFOFpzwWWMyRH15OP60P29l3++Y4bXXlsP2/rGfVUgMPY0HCQBa46ZPUkn1Tz3VkhEAMfkffjnpxX7yHRJrIz27/ilolKehNTJ2UMheFmu11RF8RmXe23OVgHSBRCB0MwDkyIyeo160BSTHXNxW2/htSx6cWmuSpFVGcNEQnjFGCAZ90KNTh1UbnFINPK6rKofsk+9ufytcDZ1BEFBRUyrNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pxd5gWmQMz9wz9AspsMec4CRj1HG9myYQ3OHGTyRDMw=;
 b=SlPZTGLBJR7tOhfD7o2uhqrkngTSJ/vmSBeQ+h6ONcwqvBo5MQgWuEZiVqWA8gucBhrCvLSTBJOIe0qQNLHhAZJrKKRD7kVrD03XfJiXJ9ImEu3nHA8jFv/65+5N5NmqajA2+oOIStsia0gFd5lun9Avw9VayNc1dCDcdmgj8jw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 MN0PR12MB6174.namprd12.prod.outlook.com (2603:10b6:208:3c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 16:36:07 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8c4a:a8c9:c7d3:479]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8c4a:a8c9:c7d3:479%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 16:36:07 +0000
Message-ID: <a090c16f-c307-9548-9739-ceb71687514f@amd.com>
Date:   Tue, 12 Jul 2022 22:05:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v5 0/8] Move npt test cases and NPT code
 improvements
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220628113853.392569-1-manali.shukla@amd.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::10) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5aa902d5-725f-4706-427d-08da64249e90
X-MS-TrafficTypeDiagnostic: MN0PR12MB6174:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0tH5qZAR7eiQ3c79p0eiZmbyL3d0vEpVdcGZwufg9Py1wzWMK/nh8yINjyyLEHGX2bIJ2Zc4a4Xiqsvb1HtNbOcLPPS72f8S76fyCPa8VIrtN4Jr1LlzNqo/nD6OE7q61pDX1XiU+gwjD7N1fqnaxaaKI1u00+YTFsnpi0gLBBSV9UL3wdtW/HXmlzO8ppLdlgUIin1+cr6PAlt6n+h83CK1jmArt+LK3FJkBJq132c6CSnhx0BXbJq07LQhcU8GIm83sF377l6S9srqEqBGErgTy8TDBlSTnsMEE418PagBrNkeicqRuORgeE+rdyzOGVprrCD8VBl6lLDz5uy/JOaCSfb0nI4KvpMtBS8kQp1DM2J22s01GrKmyP6dxgTl6Cw+UfSmoKT45twzAewRiJf9Xv+EFtpoNOe+NV2igu3HSy+i5TsR1L0KV/1qotrc4WW1GiesPwGI30ijD3aCmDkTHegDeTlVB8A76WHRw6rNCVP6HyhMFbRTklOExa6HhE94Tf/nT07ICmGlPRbgL9ZFJdgguqxpOQNAVWQ8GsiClTAWGj5/pClMFDnkbF3fPkHgi3yTswIE/XGaDoHXcPmrm3EAwnWdfvAPwdF2tzBlphsC+VjKsvPbi7DGr4kBkk4QLrngrhA2kRPDDI0torwmcMQiTM/E6ULQR9VAl4um8ZrfM0EZaiYkhIEJttMCNNAAgZv2Q1/WqPYXXaCHo8GQmoljf4/2JbcVYVULqvq9wOqGEzAitfN42RhIZX50ZlhkUwSYl1P563MjzMBNadSUpiKmHV5iaYeQ1VHNPlx7OvH9ppeycHRD0kqxquZ+s0fm58fYVY9/Gh7Ug8hXqFYtoTVvtOup3CjKbQLdYYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(5660300002)(66946007)(4326008)(8676002)(186003)(66556008)(66476007)(2616005)(36756003)(478600001)(31686004)(31696002)(8936002)(6486002)(53546011)(38100700002)(83380400001)(41300700001)(2906002)(316002)(26005)(6666004)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUNlZGEzeWk5ZUJ5a1RFZXRLcjRSaEJySm12eEVXaG5mb1packduTmhrNDUy?=
 =?utf-8?B?V1d6dnlOWm5wOXVLRVh1bjVKMzZ5WU90OU9wdXJvQ0UzcUNNempsbnlxS2VS?=
 =?utf-8?B?Rm9mWmpQbkJEVnJHUnZjVXZHaUZMRW51QUtrY2x1YXc3OGdYTTlWdUJhT1dL?=
 =?utf-8?B?bDNBNWwxVmJySlkxVzR1VG9SaWlka0doSUNGWlBhYXJrc3NtM1dqeVpjOFBV?=
 =?utf-8?B?WllRMHVNSEo0OTRJUmF5QjBrNFc3eFNlWHpTT3dFbVhXbTc0SVdHdFNuNTNO?=
 =?utf-8?B?aXBES09XdkNPUGhKVHF0SnRvOUY4bDVKS2ppcm5tbnRKNlpEVnFhV1BSQ3BB?=
 =?utf-8?B?VWJhZlNDRXlscUFDMjNzdkI4QnlsTGwvNWpyN3plaEk2RWZ1REV0WENvUFNq?=
 =?utf-8?B?azhlZHgwUnpHQnIrZnFEL0hvNE9ncGk4eEExWWtVNTNhYy9Yb2pUKytJUmlk?=
 =?utf-8?B?Z0c0Ri9GSG41YlJzbEhkaVBzc0txYmV4NGpFamNOVStpNnRiWWZocUFQMW1R?=
 =?utf-8?B?b0p2OVlTYlpyMU1aZkNWQmxpT1lWNVl0ampEL1BhWWFMQzY3YzVVdXdIb2hC?=
 =?utf-8?B?a2RaUzU4QlBLNURqb1ZnNkY5V2lIWU9FeHZMcTRpWWdwcW1LTnBUL3Y4eGJu?=
 =?utf-8?B?VGRMTHJ4NWVyWE50SzFEYm9ua2x0THZIMVBDc3BZV1NYUVlPRThXbW9sTXhS?=
 =?utf-8?B?RUFySkhxcnlWV1dUYmRnRm5vYU5hQzVTOHgvekxVQjhRMjRMSTE0UFM2endG?=
 =?utf-8?B?K3JOUURMd0QwbnBhNDFockx2QlFmWG5CUFlvSkQ1ZGZ0K0hFcFpjcW1iQU1U?=
 =?utf-8?B?Wm41TmVLb1VpTjlFazQyc2xCYmNtd21nZjZ0STUxK1RKOWV6bmkxUyt0RzdX?=
 =?utf-8?B?NVdjbHJiUDYrYk5Sdy85VWpYMWsydlJlbzNwdGFyRG5YL052RVovQXJYZkNw?=
 =?utf-8?B?a3ZCUkM0empWd3JiWkh6ZzlpWXIxOUVwbm8zc1I2bVJiQXh4RUUvQjJaUHlu?=
 =?utf-8?B?eldmeUhtenhOakRmaDFKZ2xvV3pxU0JlWmYzUnBGdkV5eVBzZTIvZWN6Z25W?=
 =?utf-8?B?dzI5aWtjc2hYM1FUT3dJSlJKd29udEQrVmdQQ2tSZUNJQUVNOW1BWDlxVUlN?=
 =?utf-8?B?QmVTUTV0T09JNURSb0Y3alNxQW9qbjRNeFFhUStXNkhjZTg2SStJd2VWR1lq?=
 =?utf-8?B?alFkblpQNHVvSGsxZGJaWlpkM1JnUE9BRndxY0pxa3pRSXR5aUZlTmU0VExn?=
 =?utf-8?B?S2pPaVVLUlUxVU4rV2F0djZkaExwWnZtcllPdnRCNW11UVdjakJWSTkrMlRX?=
 =?utf-8?B?OC9nUnRkWWErVmw5TS9YY250clNzNnh6dlovMFRSYUZ2WU9KMlZmNTlEK0VX?=
 =?utf-8?B?MTRSd0FSQ096Z3JyZjVYK05JVmExUnJMOFd1M0xnc2Jvai9OL2xydVJ2cGN0?=
 =?utf-8?B?OW95M3V4Q2RiQ1hkOTJtb3pBd3hqblE5SzNWYUxGRjZwZmw5dXQvMjFXeG9U?=
 =?utf-8?B?S2ZLWk82UE9RdjdjZmVzYVYrcjdISU5BRXE5ZXRsS080Z2VRREt6eHpucEsr?=
 =?utf-8?B?SENXZFFRZXkzeEFKVmVGaGpZcTNUcGtZcWhQMEIraVdLTlpnSmh2MzBqejRu?=
 =?utf-8?B?NHRlTkg5d0ZXem82TmtiZG9FS25iODRMTTZPQ05HOEkwVFRiN3ZTQXBHbkRo?=
 =?utf-8?B?TEthOXg2cmFrc1NETVZqQ25TZkQ5cnk0VkFZRk5qdUg0U1JFRkRkc1ZiWTZM?=
 =?utf-8?B?Rk5iNHNWcnVYdVlyS1A3MERLYTlFV01hbEpwSExYS0VtbGViZGd6UHRGdlRL?=
 =?utf-8?B?QmZGSTZyZE51bkRhSWs5ZlVZczh0d21scmszZ2J4b3pHazVBYTFRcStXditK?=
 =?utf-8?B?SVZMZTJSYkEyYWJkRzkxT0tpZCtDc3N2NkE1SDlwTExXeWFZOHVndU8rZkRO?=
 =?utf-8?B?R1IrTnZWdUFGNi9VeEwxVmRxWlNNbEdZUDhDQjNVdGpCOW5CcGVNMWlzbEc3?=
 =?utf-8?B?L05haUFXMWQzTnI1cjhUZDhFSS9nUDlhQmhReUl6ODNOangwN3JEN1J5MGtv?=
 =?utf-8?B?TkpNaVAyb1lqdHI3SlJncDVDWkl2S3NneTBzQVY0YTZXTk9CcjVPODFCYkJr?=
 =?utf-8?Q?wOFoK6pBUXLpMSfW4DD784/kl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa902d5-725f-4706-427d-08da64249e90
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 16:36:07.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJjQpK6qYFdKU4jgBzLEexRand3zsBSwiULJmfRUUpZggk2D8n473kbyAuRPJd9hqontefwTg8k6bVt1agFg0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6174
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/2022 5:08 PM, Manali Shukla wrote:
> If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK
> set on all PTEs. It is a better idea to move nNPT tests to their own file so
> that tests don't need to fiddle with page tables midway.
> 
> The quick approach to do this would be to turn the current main into a small
> helper, without calling __setup_vm() from helper.
> 
> setup_mmu_range() function in vm.c was modified to allocate new user pages to
> implement nested page table.
> 
> Current implementation of nested page table does the page table build up
> statically with 2048 PTEs and one pml4 entry. With newly implemented routine,
> nested page table can be implemented dynamically based on the RAM size of VM
> which enables us to have separate memory ranges to test various npt test cases.
> 
> Based on this implementation, minimal changes were required to be done in
> below mentioned existing APIs:
> npt_get_pde(), npt_get_pte(), npt_get_pdpe().
> 
> v1 -> v2
> Added new patch for building up a nested page table dynamically and did minimal
> changes required to make it adaptable with old test cases.
> 
> v2 -> v3
> Added new patch to change setup_mmu_range to use it in implementation of
> nested page table.
> Added new patches to correct indentation errors in svm.c, svm_npt.c and
> svm_tests.c.
> Used scripts/Lindent from linux source code to fix indentation errors.
> 
> v3 -> v4
> Lindent script was not working as expected. So corrected indentation errors in
> svm.c and svm_tests.c without using Lindent
> 
> v4 -> v5
> Corrected commit messages for patches.
> Incorporated comments provided in setup_mmu_range() function.
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
>  lib/x86/vm.c        |   25 +-
>  lib/x86/vm.h        |    8 +
>  x86/Makefile.common |    2 +
>  x86/Makefile.x86_64 |    2 +
>  x86/svm.c           |  227 ++-
>  x86/svm.h           |    5 +-
>  x86/svm_npt.c       |  391 +++++
>  x86/svm_tests.c     | 3365 +++++++++++++++++++------------------------
>  x86/unittests.cfg   |    6 +
>  9 files changed, 2034 insertions(+), 1997 deletions(-)
>  create mode 100644 x86/svm_npt.c
> 

A gentle reminder

Thank you,
Manali
