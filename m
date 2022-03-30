Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3F64EB9BD
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 06:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242631AbiC3Eoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 00:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiC3Eo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 00:44:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E629F3DA5A;
        Tue, 29 Mar 2022 21:42:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+ZIIijW49uFe0UNSTuglcMXuihsXsJ9fnGf130Ka1lMsUlY7zDZi1NN8KgZ/o41b5O40MmYHyKbQBi0XXnYbOamd7RkMdJpTILRyXMfYd/Zfax8gK1JW16VL470VwK1iRbUUSzhSqjQ9C3Fw7VagdJLUaV9hS+VTD+QaZfObs81YWYEGXm0p6Fvo3OaKvUqPAvk9t0GoHjmWAJbaM7qk1AXxhTDD8yv9YwUgk+41TDnt/wWGWEVv8/QBbCWZEaWVclJfTwFKSajjWLdiI4+eFRRu9Es6iYTqt0dxhwLAvA1ULnO/JorNEhHdFqgr2XVy7aNWexcgYj5SKuABcItEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDorHNevYQpOdj3ow5Vj3I0DlR34o7dYkZb+19El3rg=;
 b=HRBPqNHLaoB6Jq11yUm9XvW0bHjHvK7KY10M9O0KscWDwh8RN1LH0fHRQ2KgyynaWLs9MWkkxMYeTREtCU0j2aXDVinv2p+EfwYkeub+2R7TLNcfc3blKFti/nbOLAUq7ARz7F2sN+PJ6RY9sTzpN3kxERVkVwxPkzcwUubkrzP/HwNKOGy9De0Se5F5AyaQjvl+tRqetGGqzlFfeixNHBFr3amoDQf1/fD2PMPg1jndop9pDNINNE2Bmy6TWXzreHaBsgKja53gRKCkDslp7VTRmeQ2alO3MQtsQgs/zgNeaxamGJEzJqYHcKW6UwCHw7RJIh07sS8R6ADDaif7EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDorHNevYQpOdj3ow5Vj3I0DlR34o7dYkZb+19El3rg=;
 b=pv92qW3hR/FH92wPB5hoMn2I2BJwsDu+NsaMH+uNX3zIcUuiFTEZ13tRDisp0c4GTGSfCTmAqMlxgk/58HiemGXefTsfvdErICjd7tSzy3v4+8iynvAwA88RJxPekUppDr4KwrI39GAnL7SnLCwmpHx23QRF5diYQJ5Pu/gSnC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 PH7PR12MB5709.namprd12.prod.outlook.com (2603:10b6:510:1e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Wed, 30 Mar
 2022 04:42:41 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b%3]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 04:42:41 +0000
Message-ID: <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
Date:   Wed, 30 Mar 2022 10:12:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <YkIh8zM7XfhsFN8L@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YkIh8zM7XfhsFN8L@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::30) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee415a82-640f-4549-31cb-08da1207b95f
X-MS-TrafficTypeDiagnostic: PH7PR12MB5709:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5709CAF442678FFC46077E3FE21F9@PH7PR12MB5709.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTFEmSqpRbgz00P2lCJlanU64K1KttUL2tpf9cl9JmS5TqgydWFn5Vi4tqq9ba15vKFREwCQt/q52rjLK7Mv6a4xUh/xq7d3VaTid78UJWstZM/UokW44Hg2/l2I6Sgy0O9RFGrKeTApWlsLwlhCPNWlJC6JSDsA8glfGe/8iorqS9i+cTQIoiNyEujTvXFqTi4rHVgsnIYnUQiPv3q1sPgxpwYgewE3zV9VAWI5lMcETzu+2lKA+L/3pGcOZhgjqu+HMofHP75Xi6zpkUO0xzJAreyx43md4WA7IpoZAswCbIq5jYd877DccRzo8NdnaDJnfgeWEFSACHp7eCSLfmIBo1/AicD+a1okwwO3uOVI6zaHjOzfVjHWWAYVAZIlmOD5hK7LbNBl0ClOCbHggY98TGLwPvwXWI5ZTsncdQEQ9+gRv+YNvSJaxaawJCxY0jO/IoXZ4sE7UakNpK5YbC0KxVeCZT3L6d9LeN2RDuuUif1nluQfkot0aPIu+vyUm23jZNEdlTxenQoSUhtps0tfy4xd0kCuDEmd5FeFOKi8w46F45TAJhrN1JdAXg1jT3Et8E2eI3BBzMghVr2Cxj1q4T5F76pls/6ich31wcVAtT6trD+s7nnr08qVQrLia/XgbaCv7uFToalynRwiCndnuktFwEv//qrZAhYOeJqAT3jwc9pPXf78Voby8uQNg2YKHJoairy4zGEcwPsiAAQ7Ezqs5rfajN+gJTftcGDpC5CHG+lj6bg7Wpr1CtLA8J7+uigXHukajHZQ2J6uw4g8xo5wBJyLwDkVf3ej3YiuK3Zd/6Ff3DGLtO2MKFbo34TEOIh7CxhI0OiU2rVwiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(7416002)(8936002)(38100700002)(2616005)(83380400001)(6666004)(6512007)(5660300002)(26005)(508600001)(53546011)(8676002)(54906003)(31696002)(6506007)(6916009)(966005)(6486002)(2906002)(316002)(36756003)(31686004)(66946007)(66556008)(66476007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXBtQUowNE1TSW9XQWpXQnBRYXRKZlRWSnBCZll0c0trcFFuS3hmRWpzU0tI?=
 =?utf-8?B?YXc2aDQ3M3ZLR1BKZ3lhaitSQ2JxSUFEd3ptcUVtSnZYa3RieXJPcXpsVG1X?=
 =?utf-8?B?TGwyZktleXkzKy9XTkVvNGJTN0R0WnIwaEdtaUovT1B4Y3dVa3V2MzNrZElU?=
 =?utf-8?B?cnlCTUpRK09PUjdFbVFMQUY4R2Y3VXVrdVMzcWZOSG5TTEtySmUwZVJSb05F?=
 =?utf-8?B?NzI2anh0MlhJTzdpamZyUFpWa1A3VFZZRUIzdEZWZTBkbUhPSGV0M1lIb0J1?=
 =?utf-8?B?UkVqS2pqVjZxbGNxb0xSSXNGMGZwTWRpVk1YR3BmeU0yLzZwanE4aTRUTld4?=
 =?utf-8?B?b2tMZ2VkdXlkb0RjVFlURWsrQzQxdVFGbnN3WHYwUUp4TnJtVHN1Y1Z1a2Nz?=
 =?utf-8?B?NU5SSTNPTUVMQllzeXI0akxDbSsyUU9NWVZKMGZjNDk4L05pVFJXNERRRE9H?=
 =?utf-8?B?Um5hTkc4MXN2bTE2UW4wQU9QWTNZcENrVHNDd1N1Q25PalYwdENieEt6M3Iy?=
 =?utf-8?B?THVVYTVHeEhhSkhDalduaDZWalpRQW1VYTFSVzBhajYxaWYrRVhPYk9OQmdP?=
 =?utf-8?B?dnI5UllKOTJkNjFkT25BRjJTSzkrVVg0WEI0NEFKK1NmSENuVUN3Mk51OWoy?=
 =?utf-8?B?bHp6eHYyM0NpS1dYaDNFK0VkYTBGbjZ3R0FjcHRpMVZyN0dQaURMTk55emtZ?=
 =?utf-8?B?cEd6RmIrZHBJWENiZVQwQXlQVm9VL1hTNGxpOGU4VFNvSi80MkZQY0VXZWtr?=
 =?utf-8?B?a3lNVGl0QkxnbjdKNDRnWDNESk5DU3MzejJFVEpsdWJUNFFnSDBNT0NYUHZq?=
 =?utf-8?B?NXQvd2c1T1ZZVGp2cUEyR2ZwOHIxay9uOE9IeW9yZ3hEcDgyMWpjUGlTSE80?=
 =?utf-8?B?Tk9CNUQ2NHpvWWYrRmJ4blpKTzZvOE9Ob3dzSUxiSnFLUjMvQzR4TXMwVGZS?=
 =?utf-8?B?TDRpenhOU3o0V1VVL1JLZUg3dWhHTklGYm16NExHYkVOUk55TWVKU2wxUGhn?=
 =?utf-8?B?K3VQL1Z3WHE2S01DcUNkUk1hT1h2OUF2M0h1aUxsMWhyWnlGcm04V1lZVCtL?=
 =?utf-8?B?d1d2K0NiVVZKZGptQjVnUUVKN0ozRlZuNlF3dWhYSUZmbXRNUFNBQ0g5YnJN?=
 =?utf-8?B?TTM0ZzIyR2wrdmpTTVZndFJwajFRSVdGQzBNbGc3ekR5SHFiRllaYm9VODlO?=
 =?utf-8?B?M3dVK3RBUkZwcG1NRnlFQllVM0hVS1FOVjZHWXFScGVNMDVFMkNhaVlMcGF2?=
 =?utf-8?B?ZzJROGt6UFRVa3pLU2s4NlRFakZHT2l5RjdXMHVacDczK1B5TzFUeEVFVW9t?=
 =?utf-8?B?cEdXa0pyRDJoQUxaN2RGMnZXZHJPU2FBQlhtZ0dFT1RHUGhwQzlXWTdZcU5O?=
 =?utf-8?B?aUtNd3c1Zk1rWTlIby8wZUt1N0dGTnNJa1RPOUdsVnVFNFdKQ1AxZGJyeVJa?=
 =?utf-8?B?WGdrM1pZUmozMFl1TnhtaTlEd0FUOXcwSE1ia0prNGFLTW9Ra1RBTFkwS2dn?=
 =?utf-8?B?bStpU01WUmI4NzRwRjNPR2VQbG9sWUloVjZTUkpoYm0vaG50R2ovREhaenox?=
 =?utf-8?B?VkFWR0FrODRWWEYzQS9yUDM3ck5aVnI0Sk1jb2h3dXFneW92a3FtNzk2eU9U?=
 =?utf-8?B?MW1TMWl6cElWQnFVaDNjZFAxdWZvNDdpdzVRRkF6UG8rWXkxblpldWNOSDNa?=
 =?utf-8?B?cVRnRjRGdTNXL2hpcjFnVTlsV1B5eE9Yelh3ZVNxL215b21kSTRveDRqWloz?=
 =?utf-8?B?c0ZONm5VajZrU05FWU5IYUFYdSsybVpsOXVjM0xPQjNRcHRKeFlsRDdBNFJW?=
 =?utf-8?B?alpBdk9PL1J4RW5tS0RPSEI4anFreWQ5bG1LbElTQ1JMcFF4c3UxN2JFV0x4?=
 =?utf-8?B?d2ZlbTlZNDI4MmxJc1FML2wrYURwTUZlK3NZNGovZkZEOWlOUUNuUmtXRlVX?=
 =?utf-8?B?NEFWR3NKclJ1S1JBb01oZFN2SnpKTkJJZGc4VTZXYTRmYlJXZDlBbzdBZEF5?=
 =?utf-8?B?U1loTXdjU0ZBSmppbTlDdmtwY2p0ZDV6UmR6Z2gwUFlzS2Y0N01xT2V6cTNu?=
 =?utf-8?B?ZnE2QjN6cmJBNWZwWm4vOGNJMExjM25CRUZvMjMvU3h6akVqMWNUSlpOMUtJ?=
 =?utf-8?B?dVJlUCtzbTJUVFlIMEJmeCtGY0NhNm12cGJocGdPWEhTbkg2eVNKRTJZMStE?=
 =?utf-8?B?bDlWbi9ickhubmpnSjB4Rm9ERWVhK1F3S0QzdTV2Sml3aFh1OElZUVBoVlV3?=
 =?utf-8?B?NEgrMXFwUEMrMlhoTjlMejBPREppbUkrMWtzMlo0VGpYekU0RWdoOVRYYzR4?=
 =?utf-8?B?QnExa2w4dXIyZGRrYnV5MU5raVRxMWdEcWViLy8xWCtxQi9ad3F5dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee415a82-640f-4549-31cb-08da1207b95f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 04:42:41.4815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkD2LuYFjskxqnajW35QgihVsSYvjmv8TSW0nZQWnZV5SgoHEbA5lQm1Nj04WyGFTXiI4emIUsT838T2nKVzzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5709
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/29/2022 2:30 AM, Sean Christopherson wrote:
> On Tue, Mar 08, 2022, Nikunj A Dadhania wrote:
>> This is a follow-up to the RFC implementation [1] that incorporates
>> review feedback and bug fixes. See the "RFC v1" section below for a 
>> list of changes.
> 
> Heh, for future reference, the initial posting of a series/patch/RFC is implicitly
> v1, i.e. this should be RFC v2.

Sure.

> 
>> SEV guest requires the guest's pages to be pinned in host physical
>> memory as migration of encrypted pages is not supported. The memory
>> encryption scheme uses the physical address of the memory being
>> encrypted. If guest pages are moved by the host, content decrypted in
>> the guest would be incorrect thereby corrupting guest's memory.
>>
>> For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
>> encrypted and when the guest is done using those pages. Hypervisor
>> should treat all the guest pages as encrypted until they are 
>> deallocated or the guest is destroyed.
>>
>> While provision a pfn, make KVM aware that guest pages need to be 
>> pinned for long-term and use appropriate pin_user_pages API for these
>> special encrypted memory regions. KVM takes the first reference and
>> holds it until a mapping is done. Take an extra reference before KVM
>> releases the pfn. 
>>
>> Actual pinning management is handled by vendor code via new
>> kvm_x86_ops hooks. MMU calls in to vendor code to pin the page on
>> demand. Metadata of the pinning is stored in architecture specific
>> memslot area. During the memslot freeing path and deallocation path
>> guest pages are unpinned.
>>
>> Guest boot time comparison:
>> +---------------+----------------+-------------------+
>> | Guest Memory  |   baseline     |  Demand Pinning + |
>> | Size (GB)     | v5.17-rc6(secs)| v5.17-rc6(secs)   |
>> +---------------+----------------+-------------------+
>> |      4        |     6.16       |      5.71         |
>> +---------------+----------------+-------------------+
>> |     16        |     7.38       |      5.91         |
>> +---------------+----------------+-------------------+
>> |     64        |    12.17       |      6.16         |
>> +---------------+----------------+-------------------+
>> |    128        |    18.20       |      6.50         |
>> +---------------+----------------+-------------------+
>> |    192        |    24.56       |      6.80         |
>> +---------------+----------------+-------------------+
> 
> Let me preface this by saying I generally like the idea and especially the
> performance, but...
> 
> I think we should abandon this approach in favor of committing all our resources
> to fd-based private memory[*], which (if done right) will provide on-demand pinning
> for "free".  

I will give this a try for SEV, was on my todo list.

> I would much rather get that support merged sooner than later, and use
> it as a carrot for legacy SEV to get users to move over to its new APIs, with a long
> term goal of deprecating and disallowing SEV/SEV-ES guests without fd-based private
> memory.  

> That would require guest kernel support to communicate private vs. shared,

Could you explain this in more detail? This is required for punching hole for shared pages?

> but SEV guests already "need" to do that to play nice with live migration, so it's
> not a big ask, just another carrot to entice guests/customers to update their kernel
> (and possibly users to update their guest firmware).
> 
> This series isn't awful by any means, but it requires poking into core flows and
> further complicates paths that are already anything but simple.  And things like
> conditionally grabbing vCPU0 to pin pages in its MMU make me flinch.  And I think
> the situation would only get worse by the time all the bugs and corner cases are
> ironed out.  E.g. this code is wrong:
> 
>   void kvm_release_pfn_clean(kvm_pfn_t pfn)
>   {
> 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn)) {
> 		struct page *page = pfn_to_page(pfn);
> 
> 		if (page_maybe_dma_pinned(page))
> 			unpin_user_page(page);
> 		else
> 			put_page(page);
> 	}
>   }
>   EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
> 
> Because (a) page_maybe_dma_pinned() is susceptible to false positives (clearly
> documented), and (b) even if it didn't get false positives, there's no guarantee
> that _KVM_ owns a pin of the page.

Right, the pinning could have been done by some other subsystem.

> 
> It's not an impossible problem to solve, but I suspect any solution will require
> either touching a lot of code or will be fragile and difficult to maintain, e.g.
> by auditing all users to understand which need to pin and which don't.  Even if
> we _always_ pin memory for SEV guests, we'd still need to plumb the "is SEV guest"
> info around.
> 
> And FWIW, my years-old idea of using a software-available SPTE bit to track pinned
> pages is plagued by the same underlying issue: KVM's current management (or lack
> thereof) of SEV guest memory just isn't viable long term.  In all honesty, it
> probably should never have been merged.  We can't change the past, but we can, 
> and IMO should, avoid piling on more code to an approach that is fundamentally flawed.
> 	
> [*] https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com
>

Thanks for the valuable feedback. 

Regards
Nikunj

