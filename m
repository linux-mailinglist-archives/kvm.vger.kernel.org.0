Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF045FAAA3
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 04:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJKCcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 22:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJKCcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 22:32:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3399F85A85;
        Mon, 10 Oct 2022 19:32:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOd3QYSpRaHxyYN0K2E4UWK12q5fhXUHAlE1jSUHL24t96y0Oswic5AtH0HqsNle9LYMvcpmoINTY6JLw0got/VPuDX4Im7O5hmo9yA9m4QDsBFs5yhgb0bFh777ytMb4D61CJYxlgKR2MG/D8oM0Ayj6NYZFUX8U555y580VqN/JlaWv/R17lK+t1y1HEhnD1k8d3L6ePvpelf4ROBQhww40EAYU1xoAe+mKkkz6N8aLWmOlyuRsnEmWZOIGNbavSOJt3Zk1dWEJvow7rByNIOtIegKiotCvosqRPrymO44mITS9TqE1Y/dtREd+Dxv84heRZzYE9LMQ4KF5CeRig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaKusva4wnelqRC10+3Rhgg8/k6h9FlQB5ICvq5Akro=;
 b=d41dM9XE3aJLr8uMJcUwQcT7LG4rOYqy0OTUh/tJuNe1iILKfV6MBafdiDwQ6OFBoiWO3emJ7VkFkZl/csxvAVebfB/2CipZheiv0agLtjqAx6T5vGjwiFxyxyDmx3DTf2e66VBM3luTB3bdhcjDKiZWKgdDAsC9Iwr7vgXEYpyAQrkXEnoCPIuOxef5mI+BPHumnu3mzC2Ch+mnef6fTdorsykD9yeJOnJ6IzuHXiJd1Lp9kSdoi3wto1kCB6qB44MgX/1ymfXoCQb45OqJA2bBQbXhe6lRce0U45Xk9VLf5LgCR4swC/trQ8kmNwBlG4g6M5jiUyIeSNnoUe9vkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaKusva4wnelqRC10+3Rhgg8/k6h9FlQB5ICvq5Akro=;
 b=ZHMh29LtYa+VwABvT6lI4jFZK68AT2dlKaVUhTzPbxmKZPIa0JvnkJ6thnMQFI3cCKTLcCCeE9aR537UUdEm7FFIEFWZBLkqYti3E7Tv93cwNPTFhHerpCG/ssz6uNEk0bf+exzGA2XQnlr/h6R64lRr0B6KnSY6PY1Js876mvc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB6208.namprd12.prod.outlook.com (2603:10b6:8:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Tue, 11 Oct
 2022 02:32:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021%4]) with mapi id 15.20.5676.040; Tue, 11 Oct 2022
 02:32:14 +0000
Message-ID: <318682c1-34a5-44e3-a15e-ef71067d4fd7@amd.com>
Date:   Mon, 10 Oct 2022 21:32:08 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP
 nested page fault
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
 <CABpDEukNp9eH8jXpv6+Dun+e943AbEMA6G68uQu=TrOLSvh_oA@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CABpDEukNp9eH8jXpv6+Dun+e943AbEMA6G68uQu=TrOLSvh_oA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:610:11a::7) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fc73ac-3956-4601-304f-08daab30cebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +iDyGkZCmdzvRpE6+SylG4HDReHiIhSFUhbFEVrJ5TIB8o0JG7LKRHGjiw+tLnbGlMeqFUFy7w6GinaumHt/ap7EpVOOtyes3OMKKMz/YuSbtEHRtaAXBiCDRvbCRGFJQI4HrbaeT4QJz5Li++OZJc4zxxSsKZO67b/AyNOjo4zuR2sGLaoKBHK+9d8M/10hcxne30VrlmYspeqlOhjmSWx52Zl3FwfGRNN9dOZglemdc1lcRteBkFcqI7V5tHPkiWoAWAxY4kUnqq8F/khCaRPHv/eFd9yxaUgBa/Ssno0Pq6HxIf0EvLHhLIgJH1na7wwfdp05+RpaR/D0bD5f9rAZlrWuqSX1YmaT+VZ5SMEIJYv8Vvbnud6bhs9S/JUxt5PBhorY660f1TTxW3TTbBTG+xv8r7ncr3i/5IvTb3oNMcHeypQcihQSB40bPbjB7qngkmW/Ff2bvPkxGp40GXve2elK6lF27ykAyi9Lhq250SJaFaS20DOMHIcg/Mk1KxhTL0Zw1IiTbysXaH6VVYR2fDP66eW8bdpRMfnMcRwgVrzrNRX0DKrjB2SDKNlzH0FItdZgQtWJMLoSAn1K+GvUKJZjpBw7Hc+8HsDOoGWi3Yg7WWdbJXP3jkSLb3blOTM7uKG+IoGIanI5Ji3fXH0zYofwfDlPbkibOoim+LnXvEFKoSwIBxizr7DLw2OT/MwWvttqsghG86z7SrQP3A/g3B8lCTqTH2gFQjZHkNzVm3DWaXCS7pLfBaR/TZnJ+aPNPIlPIXim3PylSFuZ8wbxZ6ZuJj0ZX2jgkh1F1nY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(31686004)(186003)(2906002)(2616005)(6506007)(6916009)(316002)(7406005)(7416002)(5660300002)(53546011)(6666004)(6512007)(26005)(8936002)(36756003)(8676002)(66946007)(4326008)(6486002)(31696002)(66476007)(66556008)(86362001)(41300700001)(478600001)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHZJK3ZQdmVoZGJVSmY1MkdONWV5anVFOHhlL2pIbDE4VU9DeWo0REZIRkY3?=
 =?utf-8?B?MFJmOU80TUx5KzNLZkE0cEs2NnFhbThHVTFWSHdUblRjTmt4VFpaVzF3NWFs?=
 =?utf-8?B?M3hRWCtVdDQycWpUK255VFFQV0Jod2VOWEE4T3c4UmNzTE9OWVFDOEIvVTBu?=
 =?utf-8?B?b053WTFqeVIwajVkWGtsUS8zYWJVMXNpV1NlMzNnZEUyNGp4SVdmR2NYcHB3?=
 =?utf-8?B?emJUcDdlbE9wMkx5NkYvUU41ZFdvMEl6L2lSd0pPb21pMDJJUkF0MlRZWUJB?=
 =?utf-8?B?SnY2OU8yNUFzV2thK202UERMamJMYnViMjI5YXNNM2FrWkNndVJGR0xkaU9Z?=
 =?utf-8?B?a3d1YkVDTmQyMTBRMGdSdUt4N1lHdTY0b3pqOUpRQy9SYzIvczk1bEs1eE1l?=
 =?utf-8?B?VGd4N3MrYjRvWlJDTitQN2xEWG1IdlVmY2ZqNkVJa3YwaXRBYmtMRitNTGNn?=
 =?utf-8?B?bkRPM3BEQ21DS2tJM0czZkt5ZEt3SEdBVGxWNlY1a2lPVXNFcUtzbHE1N1gx?=
 =?utf-8?B?akJ5STk3UkxqT3g5ejYyTjZDSVdDaHFQS09BMTlRTldyeVlnNG1lK2w0cGsv?=
 =?utf-8?B?VWRPUHNXOGR5clBwYTVkNUtHaDArT0t6bVJnRHc0ZWx5WDBzYS9maVhuaHp6?=
 =?utf-8?B?QWlrb09pcFBocVRrOFRjVjZlMTlQdUxpTXA4Slh3aFJpd3E1d0FZcVNkaE42?=
 =?utf-8?B?c0dFUXhzUUluL3EzQ3ZEZU1LeXNYdWNjbVdSQUdWUitCUnJqdmF3SFg3bWND?=
 =?utf-8?B?ZzVtMWNVMjVSRFl5YUdtY0VxeXZRSTQ5dzNnTVY1MXN5RmtOOUsxVFRjLzF3?=
 =?utf-8?B?TVhJTWluQ0lZdTNnVFdsYisvWWZheVphdWdCNmtUVURwOWYrdkRiSGF1c0hZ?=
 =?utf-8?B?dzJpeWdxVFc4M0RXY3lEU3lDb2dJdEdKRXRVMHMySUxtUmk4SlAxMXF2c1h1?=
 =?utf-8?B?M1BzeEoxRzY4U280UUxmUFREV1FTRnZGY1Z4Zy8yR3o5am5RbUhLbW5FQjgz?=
 =?utf-8?B?Tmt2TXNEcGMxZHEwV1F2NGNTL3F0VVVUcGFsRVgrNEE3RUxBMklCZUlvRVZT?=
 =?utf-8?B?TGVBR1JRd1F5L3lXSGtMd3BENjB3L3dja3BFTUFva1o1WEMvMitRUW03MExB?=
 =?utf-8?B?UmxhMWZ4eUlvV2JiSWRlcG9ZdlZPUkE3c3U1VTBxanRIaEdzanl5aWZJbjMx?=
 =?utf-8?B?dW93VVhKK0RSWmQ1dTZTSmQyTzlON21MRHhhS2h0ZWxUNW1jSTdOczhwL1ll?=
 =?utf-8?B?NitERnluZmJxNGxiOHArZkJySHNZMmJoUlhDL1JLaGpkUllrcm83UWlkdHRX?=
 =?utf-8?B?OXdEWEIvYTJabWplSGdrSGJSb0NWdEZRSzRRNGdiUHMxbytlODNZY3puRXAy?=
 =?utf-8?B?ZnQzbWxGK1BsYXVreFFtaUhwZHh4U1l3ZEFQZlNBTnRTdDBnMkFXL20zcEh4?=
 =?utf-8?B?anFRdTh4Wk80U2VoM2J4U1poSDlSVzFEL1BjNzIwcHIzdWxBeHlmWk5CVXRM?=
 =?utf-8?B?ZGY1N1R0aUR0cGo2Um54Sjg2cFAwZ2xBRnVPdkluamtucStWeFZiZmw4b1lX?=
 =?utf-8?B?R3VvdFVtblY3YlE0L2JlL0o3ZWNLY3lVbkZwaENDVDErSFBVM0VrczRraXMr?=
 =?utf-8?B?SHk3K3dDcGZxOFpsTjZGVUw4RHU0REVIZDFLMXdrODNtSUJSMTJNR01iVXJs?=
 =?utf-8?B?Q3VwR2JVRlpuNHhkOW96dmpXM3FpeVhJcXljcmVlcFhKdUVlZFplVUV6YzA4?=
 =?utf-8?B?KzdJaDNtZGdOdWFXc25YeXM4bEZzRUtJK0NXQ05Ca2NIbllXRlBGaFVCWjVr?=
 =?utf-8?B?UUkrdFlDYkxGa0ZKNTdFZmRPYTczR0taejY2SDR3R21Zckd5MFMwZ2xrNnl0?=
 =?utf-8?B?bzhDTEpSUHVIbXpPdkNJa0Q1RFg4V2lKSXNvK2dVdG80ZHhlVkJpL0d6R0Zw?=
 =?utf-8?B?ME1oRytMOGRaalNHRWRSdU0wSDJ1cnBLVFNqL3ljUmtDQzFyb3RiTHR0TjIw?=
 =?utf-8?B?c1BOdlNjK2creStxNGgxMVpMU3RMWGxuNi9POXZUNnVla1V5ZVByZU9vQ2Rp?=
 =?utf-8?B?bWIyTXRxRGgrSkJYemF2ZzRBUHVLWWZSUGYreXFEanJnMHpPUzdVMlVBa054?=
 =?utf-8?Q?/zaN5IfGXpXEHqIONUPP5IjWT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fc73ac-3956-4601-304f-08daab30cebd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 02:32:14.3193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnwzhBTEf0SDG9ad5jdDkjr2tsSJRGbeNmMhUL0uphzwgGMyZNvnDfwxOVR7H4z1QVhzAFombjV3IPplXj/lKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6208
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Alper,

On 10/10/2022 5:03 PM, Alper Gun wrote:
> On Mon, Jun 20, 2022 at 4:13 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> When SEV-SNP is enabled in the guest, the hardware places restrictions on
>> all memory accesses based on the contents of the RMP table. When hardware
>> encounters RMP check failure caused by the guest memory access it raises
>> the #NPF. The error code contains additional information on the access
>> type. See the APM volume 2 for additional information.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/svm/svm.c | 14 +++++---
>>   2 files changed, 86 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 4ed90331bca0..7fc0fad87054 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -4009,3 +4009,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>>
>>          spin_unlock(&sev->psc_lock);
>>   }
>> +
>> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>> +{
>> +       int rmp_level, npt_level, rc, assigned;
>> +       struct kvm *kvm = vcpu->kvm;
>> +       gfn_t gfn = gpa_to_gfn(gpa);
>> +       bool need_psc = false;
>> +       enum psc_op psc_op;
>> +       kvm_pfn_t pfn;
>> +       bool private;
>> +
>> +       write_lock(&kvm->mmu_lock);
>> +
>> +       if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))
>> +               goto unlock;
>> +
>> +       assigned = snp_lookup_rmpentry(pfn, &rmp_level);
>> +       if (unlikely(assigned < 0))
>> +               goto unlock;
>> +
>> +       private = !!(error_code & PFERR_GUEST_ENC_MASK);
>> +
>> +       /*
>> +        * If the fault was due to size mismatch, or NPT and RMP page level's
>> +        * are not in sync, then use PSMASH to split the RMP entry into 4K.
>> +        */
>> +       if ((error_code & PFERR_GUEST_SIZEM_MASK) ||
>> +           (npt_level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M && private)) {
>> +               rc = snp_rmptable_psmash(kvm, pfn);
> 
> 
> Regarding this case:
> RMP level is 4K
> Page table level is 2M
> 
> Does this also cause a page fault with size mismatch? If so, we
> shouldn't try psmash because the rmp entry is already 4K.
> 
> I see these errors in our tests and I think it may be happening
> because rmp size is already 4K.
> 
> [ 1848.752952] psmash failed, gpa 0x191560000 pfn 0x536cd60 rc 7
> [ 2922.879635] psmash failed, gpa 0x102830000 pfn 0x37c8230 rc 7
> [ 3010.983090] psmash failed, gpa 0x104220000 pfn 0x6cf1e20 rc 7
> [ 3170.792050] psmash failed, gpa 0x108a80000 pfn 0x20e0080 rc 7
> [ 3345.955147] psmash failed, gpa 0x11b480000 pfn 0x1545e480 rc 7
> 
> Shouldn't we use AND instead of OR in the if statement?
> 

I believe this we can't do, looking at the typical usage case below :

[   37.243969] #VMEXIT (NPF) - SIZEM, err 0xc80000005 npt_level 2, 
rmp_level 2, private 1
[   37.243973] trying psmash gpa 0x7f790000 pfn 0x1f5d90

This is typically the case with #VMEXIT(NPF) with SIZEM error code, when 
the guest tries to do PVALIDATE on 4K GHCB pages, in this case both the
RMP table and NPT will be optimally setup to 2M hugepage as can be seen.

Is it possible to investigate in more depth, when is the this case being 
observed:
RMP level is 4K
Page table level is 2M
We shouldn't try psmash because the rmp entry is already 4K.

Thanks,
Ashish

> if ((error_code & PFERR_GUEST_SIZEM_MASK) && ...
> 
