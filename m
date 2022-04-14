Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C8C50196F
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 19:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242842AbiDNREB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 13:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243053AbiDNRDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 13:03:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4065AC55
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 09:39:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f499udE/S/N2n+6SzWJ9slvS+aFf4sS1fDxUUCKjEhuhJ7Xy78LGLVrZ+hyZguvaLcnTqG+MaHN9EzL8gyiI6OxFl1bAC3cMaUZmqxenI2Pvu5vAz1cxTiXIS7fSINAhfIKEGd2ue9dmbZBLht8QbLxNULICVSC1Db27OG3W4ZSRLgCAOKhoC4EgXEWL6ufQk/9AE7R6lPAj9j0t8JK7fHFcacXgSHz/8wX0vWiIMKHEgtFKDTYWXlLwz+VFfgalkmADsjEc7jRzv4332acXReZzn9fLZpqAEDKHbyQ03jDFye6AkzUtMIF48pIzsWlh5nAdVnd0+Fy3nb2rCGOQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycpcqLqTr+/D92FnRaq5U3+4YL9IHFl5q8aGz5s2l/A=;
 b=mlShe5fTZeh9aiqcPBygNBqvqxkkNJg4TviXrmWq5BnTczeUkz8Q6yixUW6GTWK28HdEaERMq+YrQVtxZKlQp4D1q0cbLpb33qyQhGKS5gqcarxI9ySq51UeERGwNrxv2JHnppB67d7leSppp4bjTY7KAaEAZBSiM+GSccmA3Vk1yNc2Fhlvlj5MPfehE7JxwIMQdLwAPSSqONbVdiyVBdVkZJHPNVVMdrys6K2nNRyC3gUvDuM67XFHLv2ky9zRezwmktjChgDbIiGHyIFrNinhd8JfLc/vzc/dzbe7XhQYrHb693kADAWl6Jb2lDMj4LZupviY5Xj0A2obDezbDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycpcqLqTr+/D92FnRaq5U3+4YL9IHFl5q8aGz5s2l/A=;
 b=AeffXGSQYlCw6hTIdgPwe8IihiYWxaWCYplZKXg9yVCbqgEuJhVDWMtUhKtdfwrzO+IB1+AWAELdnXMqGbH0quX1sl+csO2DRhgoB0Eb6QEW5XxiDzzD7kiRy9iZ7OQE723yvaWlxess2TiQMpg6/B0E0BiV3HN/Osm6XEqASzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 16:39:34 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::acb0:6f4c:639d:705f]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::acb0:6f4c:639d:705f%7]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 16:39:34 +0000
Message-ID: <c14f3ed6-a205-082c-3ab2-033174739536@amd.com>
Date:   Thu, 14 Apr 2022 22:09:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v2 4/4] x86: nSVM: Build up the nested page
 table dynamically
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220324053046.200556-1-manali.shukla@amd.com>
 <20220324053046.200556-5-manali.shukla@amd.com> <YldBmpd3k0sO3IEH@google.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <YldBmpd3k0sO3IEH@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::29) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7c77d64-139b-44d1-ac3e-08da1e355b48
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5350654E30B3D793906A15DBFDEF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4AKgVdXe3U9dpRVGNUT416kIF2jZWRPONAXhsd8c9KFSY4j+PCALtB1Fc8kMlPsWXEfGie05dHJebe/oXAo9cJXXYhrMh4StPetB+prHRDS5QQg9UUkju+8UmqAZbzCWqyxwPQQkeZQ0XlaRYkOyeSgD/S5nyPxTXCOByO1qTwbmIoFNbUbzlLQ7g9Hg8U09/1KYZyNtiY231SAA1+uM7GVmKU3V4GUPOePqesnOENWb1ngWoalehN1PLNIulOeRhVQkzQ30+/qTNxqudv4wVVRdfTfW0prNTYWY1lYERS350F1Y7lxM2zK7/ZAtfeAbsgQmNrwRS7uFn+sV3+VbryhTzWzv8cvn0ZfcH8lsOqmxQaVGAK3wC1rRtMO1LAd3Dbsgqz2ly/DCYY9Q/QS+4+U2+8u4iBX1DGYT8wIf2M/lwehDiQB3ca+2hT35E52aPBRirtqBF1Wbo6aqH7kGg0TF9eAklatwsmeydgN/ouyIRpTi83iks9msxQ6uOKB2gXXxomf7s52s4kicJA6x8kbgewseR6kI3C6Bi2+p2pzIN6kjEpVeRiUlP2UYdgAiHcKzDJXBGKgXkcjRI/ZcfyRmIVKvcK5zS0Y9b5soy/9ZoOjXYWNjpYetHJbyjuyztV6MhTRwSDqYgLTwMXXNBAvl3DLkCN93sk8KXpolI3COQpqev6mVfkDlS2C9Xm8ZT9LVS4/i0P0iQKgkmEnCIPsOl0PYKvnurcx+1lCEi0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(316002)(66946007)(4326008)(5660300002)(66476007)(66556008)(6486002)(8936002)(6636002)(508600001)(2906002)(26005)(6506007)(36756003)(31686004)(6666004)(53546011)(6512007)(31696002)(186003)(2616005)(83380400001)(110136005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3VDUFdrNmJrYzM0aTJ4dWRpdFoyVnhoTHBuWVJPdGRRd0NURnF6U2NLSjdP?=
 =?utf-8?B?Z3d2dWlHZW94dU9OTGF4VUJkTHJPc3JCNHg4dXRCWExRNS94M0JBQzF1ZG1N?=
 =?utf-8?B?dDRQS0RCWHdLL25JYUdaeWJ4dVNDYTdlRUZiMlFZR3EvN28rM1ZVZzV4d2pv?=
 =?utf-8?B?RmNtTDRRbDM4dEhGdTRTeGZMODZiTzlWWTZidFpKbU5hMGs4b3Y5UmZ2TVdY?=
 =?utf-8?B?ZTFzM0EyUDV3QXI2RjNyNTNEdldicHF6UEp6NkJrcFB5ckZGYThHZ3UvMUll?=
 =?utf-8?B?eWZZV1ZNVlNnTVEwb0o2aUV3MUZKeU42ZDhyV0paNGV0K1dJNFVOYThoZVJL?=
 =?utf-8?B?ai9QbzFNN0wweDZ2SDNtZE44MDVSU244YmU2R1dKYmxsRnVRaVhzdCt6Y0ZE?=
 =?utf-8?B?czdURWNTVWxsNEhRYy9NZ0tmbFd3WUFuWE5yZlVjWGdOd2JlTUJXUytlZkZX?=
 =?utf-8?B?eFl0QnV1bkloVFh0NUpSTlIvY0xSMitMV2NrVHJMYXNnMUtYVEhBMXN2WFVW?=
 =?utf-8?B?cHgybDgzR3FjWlJLd1FGNTRNRmhnWS9PbUZDK2ZWSEUxNDJLWHJOcnlSYUdC?=
 =?utf-8?B?b0RSbGJaM3V0ei9oZWZvdEc1QWc3cmxJZWpWTitxSUVMTFgvYkI2cGJrMzN1?=
 =?utf-8?B?VW9JbnFrK3NRRFU0Q2JYTzlCUm52WVo3dFJINFpTTGxrOFAxd3RxRzMyN2x5?=
 =?utf-8?B?SC9ldGJHbDRVcEpsclBkOUUxU1BDcE1WZmdTTkdPNWt1aXVIWU1TZU5RQ2hB?=
 =?utf-8?B?THRabnA2NDVScTlmdTJJT3AwR1BYVWg2RTR6UWMzWk9Cc2xjYjJEVG1pRWty?=
 =?utf-8?B?R2pKR0V5c3pWL2w2OWRSUlVockxiWlJkWmRaSFlmb0pNZWNRYkVBK1ZacVVl?=
 =?utf-8?B?ZnMrOVJlY3BhUlNEa3orWjZrMU9XelhQYWdxZVc4ZFpmT0NpRStEMDRuOEFs?=
 =?utf-8?B?K1Erd3NKUnRsODZPdmlhbEhlYU1qWTBBTE1xR0hvaHYyWllOc3RzeXozY1lK?=
 =?utf-8?B?QnpjQWErSU1UOEJGVzJYUkZBVXplMUNweU5LOW5WSE91TG5YRnlWcmUxN29H?=
 =?utf-8?B?UlprNjRFOFdlcW9uS1gwRk9zRHFBaHM5UHNBbUN0VDhCZXFGRS90ZGlaa1Bi?=
 =?utf-8?B?RVNiRzlOZTlMbW00SWcrRlVJeEJqMS9HaW5HVXlRVDAxK1NEa2RCTHdnd1h1?=
 =?utf-8?B?Nm5JZzliR1Nub2NyM0M0U0lENnZ2bXhWYm1FTFUxc0U1d2RLb1Bzbm9EU29R?=
 =?utf-8?B?R3JsWTkwWnZSWFRzQU15eVpKSSsvSDArWi90dzZIazdTN1pjQVJOV1NSek83?=
 =?utf-8?B?UEg2UlMvYkVoU2tDRWxxOWtHNVpoUnRhLzNzcTdZS0lYMXhraWx0RjRCN1hB?=
 =?utf-8?B?MERmM1VadTNCK2RJVEVKeSt1YUVOQUZQQ3JnM1pVaHR6cytpWlB6a2pWK3Fo?=
 =?utf-8?B?RlVPQUhmeVUxQzI5Z2tzVEVjK0JYMmpHQ1RNMjZkWnBnRmZaemJQU2lmNmFx?=
 =?utf-8?B?MW80SXRXZVdvNUp1elV1KzlNU2RZZnFzcWVZeVdRcllXRU5sb0JvTkh2VTM2?=
 =?utf-8?B?eGhUMDNuaHNxTXl6UVNhc0s1dVhHNk5qdjJJQkFaMXE0bnRNamxGaG16VTl2?=
 =?utf-8?B?Zitrb3lTTGZUcHpDREdCN1Y4TmFESDBKMDlOUE5wVS8rNVArRlBya2lvNk84?=
 =?utf-8?B?Ynp6SmtNaHRIOGRjVTBOcmJCc1dEMzkyaUlIc3pIdzZTSk9VRkgyS3MxVXBD?=
 =?utf-8?B?bjBlMjhlRWRqYjdDN1hMY0xNdERMY3NxOVM0WDIwOGJaV05hSUI4TThUaHpB?=
 =?utf-8?B?TTNFNm9hK2pBTWJjWXhCcGprZTFERlYrNVBKRUxnQVdHVjV6M1FYYUoweXVP?=
 =?utf-8?B?UHBkV1VValZTVEh5MTNsazJ4aHRFaHZpU3lyMm8yUTdnUU1NQ0FPUzFhRTRH?=
 =?utf-8?B?N29SeEk2L3FjSGZsdU8vK1UyR0ZmMVl3K3lmUXBPUk9mREdtazhiVjFiUFk4?=
 =?utf-8?B?SmR4MlIrcG9KcGF5T05JUVVqb1hqRHR4YS9MZ0NwNERxUHA1VDdxL3Z4NHBm?=
 =?utf-8?B?U3pITThNc1pYNTByb0xyTHUyRitMd21QN1lESFVOcklxYUluRFMvaFJ3VWlv?=
 =?utf-8?B?UW9BUWUvNDNQcSttWWtZK3VpWG5EM1pYc2tSK05tODhualh1a3EwOVZFamc3?=
 =?utf-8?B?UE1qY2ZBTVgyQk5hbXpKRlFPQTNlb1RxVVlTYUdGMjY1VVB6TVI0RTk4WmYx?=
 =?utf-8?B?QmQ3T05SSlBZZTM3MkZ0a0U1NlJrK09VdVBEc2VGd29ZWktQYzQwWnM3UHFH?=
 =?utf-8?B?YzU4L0IvNk84ZkVTTVBjbWl0SFcwUFl3UU9rTlVqM1ArUk93S012QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c77d64-139b-44d1-ac3e-08da1e355b48
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 16:39:34.3997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pht12GS9iTDeKieodM9ptqnq2/umSsCIWDRY16Tg5Or0zcUTVST3DYMkPkUFV6j2hfqsY3SyzfhvQ6gYKCzmiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/14/2022 3:03 AM, Sean Christopherson wrote:
> On Thu, Mar 24, 2022, Manali Shukla wrote:
>> Current implementation of nested page table does the page
>> table build up statistically with 2048 PTEs and one pml4 entry.
>> That is why current implementation is not extensible.
>>
>> New implementation does page table build up dynamically based
>> on the RAM size of the VM which enables us to have separate
>> memory range to test various npt test cases.
>>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  x86/svm.c     | 163 ++++++++++++++++++++++++++++++++++----------------
> 
> Ok, so I got fairly far into reviewing this (see below, but it can be ignored)
> before realizing that all this new code is nearly identical to what's in lib/x86/vm.c.
> E.g. find_pte_level() and install_pte() can probably used almost verbatim.
> 
> Instead of duplicating code, can you extend vm.c to as necessary?  It might not
> even require any changes.  I'll happily clean up vm.c in the future, e.g. to fix
> the misleading nomenclature and open coded horrors, but for your purposes I think
> you should be able to get away with a bare minimum of changes.
> 
>>  x86/svm.h     |  17 +++++-
>>  x86/svm_npt.c |   4 +-
>>  3 files changed, 130 insertions(+), 54 deletions(-)
>>
>> diff --git a/x86/svm.c b/x86/svm.c
>> index d0d523a..67dbe31 100644
>> --- a/x86/svm.c
>> +++ b/x86/svm.c
>> @@ -8,6 +8,7 @@
>>  #include "desc.h"
>>  #include "msr.h"
>>  #include "vm.h"
>> +#include "fwcfg.h"
>>  #include "smp.h"
>>  #include "types.h"
>>  #include "alloc_page.h"
>> @@ -16,38 +17,67 @@
>>  #include "vmalloc.h"
>>  
>>  /* for the nested page table*/
>> -u64 *pte[2048];
>> -u64 *pde[4];
>> -u64 *pdpe;
>>  u64 *pml4e;
>>  
>>  struct vmcb *vmcb;
>>  
>> -u64 *npt_get_pte(u64 address)
>> +u64* get_npt_pte(u64 *pml4,
> 
> Heh, the usual way to handle wrappers is to add underscores, i.e.
> 
> u64 *npt_get_pte(u64 address)
> {
>     return __npt_get_pte(npt_get_pml4e(), address, 1);
> }
> 
> swapping the order just results in namespacing wierdness and doesn't convey to the
> reader that this is an "inner" helper.
> 
>> u64 guest_addr, int level)
> 
> Assuming guest_addr is a gpa, call it gpa to avoid ambiguity over virtual vs.
> physical.
> 
>>  {
>> -	int i1, i2;
>> +    int l;
>> +    u64 *pt = pml4, iter_pte;
> 
> Please point pointers and non-pointers on separate lines.  And just "pte" for
> the tmp, it's not actually used as an iterator.  And with that, I have a slight
> preference for page_table over pt so that it's not mistaken for pte.
> 
>> +    unsigned offset;
> 
> No bare unsigned please.  And "offset" is the wrong terminology, "index" or "idx"
> is preferable.  An offset is usually an offset in bytes, this indexes into a u64
> array.
> 
> Ugh, looks like that awful name comes from PGDIR_OFFSET in lib/x86/asm/page.h.
> The offset, at least in Intel SDM terminology, it specifically the last N:0 bits
> of the virtual address (or guest physical) that are the offset into the physical
> page, e.g. 11:0 for a 4kb page, 20:0 for a 2mb page.
> 
>> +
>> +    assert(level >= 1 && level <= 4);
> 
> The upper bound should be NPT_PAGE_LEVEL, or root_level (see below).
> 
>> +    for(l = NPT_PAGE_LEVEL; ; --l) {
> 
> Nit, need a space after "for".
> 
> Also, can you plumb in the root level?  E.g. have npt_get_pte() hardcode the
> root in this case.  At some point this will hopefully support 5-level NPT, at
> which point hardcoding the root will require updating more code than should be
> necessary.
> 
>> +        offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
>> +                 & NPT_PGDIR_MASK;
> 
> Not your code (I think), but NPT_PGDIR_MASK is an odd name since it's common to
> all.  The easiest thing would be to loosely follow KVM.  Actually, I think it
> makes sense to grab the PT64_ stuff from KVM
> 
> #define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
> #define PT64_LEVEL_BITS 9
> #define PT64_LEVEL_SHIFT(level) \
> 		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
> #define PT64_INDEX(address, level)\
> 	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
> 
> 
> and then use those instead of having dedicated NPT_* defines.  That makes it more
> obvious that (a) SVM/NPT tests are 64-bit only and (b) there's nothing special
> about NPT with respect to "legacy" 64-bit paging.
> 
> That will provide a nice macro, PT64_INDEX, to replace the open coded calcuations.
> 
>> +        if (l == level)
>> +            break;
>> +        if (!(iter_pte & NPT_PRESENT))
>> +            return false;
> 
> Return "false" works, but it's all kinds of wrong.  This should either assert or
> return NULL.
> 
>> +        pt = (u64*)(iter_pte & PT_ADDR_MASK);
>> +    }
>> +    offset = (guest_addr >> (((l - 1) * NPT_PGDIR_WIDTH) + 12))
>> +             & NPT_PGDIR_MASK;
> 
> Hmm, this is unnecessary because the for-loop can't terminate on its own, it
> can only exit on "l == level", and offset is already correct in that case.

Hey Sean,

Thank you so much for reviewing the code.

I will work on the comments.

- Manali
