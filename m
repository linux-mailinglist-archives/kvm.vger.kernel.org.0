Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A1E2694EB
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 20:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINSd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 14:33:26 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:30433
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgINSdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 14:33:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIkmHioc8fpa8Ib1gHqpakSOzNkCgtLsNGiZPDnE4cgAUeM88ooI+Ne9erLVy6KJFJS840cyT7f3ZX57g7+8SPTLTHVEOpVBRHwk8OFWE1QNctqioChsDMY6FrnIskA9RbcMCiI+d+eoFyXihnbbKittKJ5czSDDB+irqR5mg+u0VMVSMyWwZh7gTKha5UMthzofCrQl84m5pqplQ1jEZvWwSUi90AET3CJ696oLVAb7umKgBSGpOC9XiL22AB7E8QQBZs0QlXIRkHrnHHCJpMWsuqieokcUvVY6zm/nGi0nwD20SuqyTNO8yOGdNVkXHSCpMbFaGuBpe0ccO4PTew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pe20ne4lTycaiuSW1+5GchZ+Jhk8i1KJMgcC/UPgfE8=;
 b=Q6pRFusoebjLRm7su6njYTPVEnIm7cqC7qa+UdvyXv4dCgKzEF3mDCGOylM8KYAqp/fhWPbHkLeuMYDI2KlhvAc6vkUPir3z4zkGmsg6ytPSpQnLZYf7sRfli0EEIYwHD/4Koy6NBwyVtMJcMXuPhPNq9NSwFi+RGL/d7O9HkqgA/nDKcnH73xu9Yfl1E+5ND7dmaCSHZcp8pz1Nn+6wA1sNfrcDDMEg3cP8Pt4tSkoO+DjdwSbqkiMs/pQag7GWkavLpS1p5u6o9rvV8pHt1iKOz0jWKwLh7Bw/HVzKRzIauqE0zOIjK39de7TdC9fXVoT4pbRpatEA1uR2bu9VHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pe20ne4lTycaiuSW1+5GchZ+Jhk8i1KJMgcC/UPgfE8=;
 b=rdn0ddGF50p9SGWWviNsWs8sJ5scpphr7hbSSzllV0JvhRfpWMfgQqS/l5Iae0VpGPorxRGgV4Lvds+0NzzYwv598LHZ4vSpldFMybcACKyPvesByPOm6N6sSMDufx72WgHZUma4w8+Q38BwMy7QYmL0KAKmE1biEnoy7j0z0I8=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4528.namprd12.prod.outlook.com (2603:10b6:806:9e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 18:33:20 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 18:33:19 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Paolo Bonzini <pbonzini@redhat.com>, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
Date:   Mon, 14 Sep 2020 13:33:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0018.namprd04.prod.outlook.com
 (2603:10b6:803:21::28) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0401CA0018.namprd04.prod.outlook.com (2603:10b6:803:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 18:33:18 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa5a794e-13a6-458c-e9b6-08d858dca71e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4528:
X-Microsoft-Antispam-PRVS: <SA0PR12MB45283FFD947AB4517D43323B95230@SA0PR12MB4528.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nC08vBcg62b26edxofy1z3J1gPh6P0UGZemUYQitYLPakuz8d2HcNGihh2Za8KJwQ9HB7mcbDAz04HqsFMNFf1LnzdH+WIZROSpC16vE0NvjOwHT1gk0JKjAHRzbguWQmKV44OlTpDQbDfutExqqV5qfL6x/2wDZoy7eqgr+NAPJLVpK6UGBWAjiomIWw3dR3NXuk6hRnuPk0chIvSHCtG3BI0vTQpzG+HqouvuD1leKg4wncDD7EVwGPfLBn+rKhqieY81vr1YSI/nk5N+B04aCxFFrfrS/jSbOPvZyr29Es+wNiPbsffuHqRAnDTT0ojLOxKGf2F1PIS0dlryKeLm9/nIpmcdyBlgpfiXKLze7gVs7DWBC3+x03PW70Fe+fVQn+dLKKsBGfDJpwRSgx7QocOliV9mntiKar3UNIobVJ4FOctxTF8iYbw6PHeCPsM16D1CgIep3eSsb6UySGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(16526019)(6486002)(86362001)(44832011)(8936002)(53546011)(52116002)(4326008)(186003)(7416002)(2906002)(26005)(66946007)(66556008)(956004)(8676002)(2616005)(966005)(66476007)(478600001)(316002)(16576012)(31696002)(31686004)(83380400001)(5660300002)(36756003)(45080400002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: w90H/Gu0Tq8Mb9c2tLTZmkpGJWbbcaYP/n2xRZj9D7MqwM8S0oyBFwgulos1a1QmSIaXlvc+3+/K8/4W+gKqnqDg6GtuEtjFt8ngNn7mAWFtTk+OBGBBinLq8Dh1o8e0/DofhlPZ2jKuB0NOARudHnIL41wUYuRpmzP7XnRfRzj2RxEEOilgP1Ldlm25AcpVTLiw0s1RmwQBBxuibyVt64t9R7vwtCTabLxNY8FSPVGDIy5hMzuriAX3zQEBE8GWTQoC3zftCQ0AQMdLqPOlCClsiYSEhQQSRUOxjIVB05pt95qNGZFQ/L5JlabIZhG8C/ihkoVVZHa5t7Q6vIKbtoUlVtMvwZJf7oQ7tyhtM689sSmtKmF5x2DjSykgwzE6d7F4py4XmgutPuhy5s0WkTGmM40d8rtzyteWLZAFUFayMoLazHupuvKrDGRVWYLgk5jdmnyw2MyWaqA91EXQ44D2PVknnLgMktoSj6487qqDiECRpksiBPEXQt0gXovRDqY8tU+5A5+Th2iUs1KwLtoJM5f6k/XbtbY+KOrNbgCMS+jb2dgbGrLEY3ctl/2KpmSeuBvI1wdo2vMQrl6TFkbH/B2YtEfTbqzVAXcqVq4a7tqTiLsAhA16zMUEOotUBA8Z9aKoa+NZvLNmG170oA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5a794e-13a6-458c-e9b6-08d858dca71e
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 18:33:19.5394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVyHWYNuWy8NxshM/LefKJ9LRcRdqTwBp4Bp3SVCCQJHvqb5x1o4fJ1gs6v0UyQT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4528
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/12/20 12:08 PM, Paolo Bonzini wrote:
> On 11/09/20 21:27, Babu Moger wrote:
>> The following series adds the support for PCID/INVPCID on AMD guests.
>> While doing it re-structured the vmcb_control_area data structure to
>> combine all the intercept vectors into one 32 bit array. Makes it easy
>> for future additions. Re-arranged few pcid related code to make it common
>> between SVM and VMX.
>>
>> INVPCID interceptions are added only when the guest is running with shadow
>> page table enabled. In this case the hypervisor needs to handle the tlbflush
>> based on the type of invpcid instruction.
>>
>> For the guests with nested page table (NPT) support, the INVPCID feature
>> works as running it natively. KVM does not need to do any special handling.
>>
>> AMD documentation for INVPCID feature is available at "AMD64 Architecture
>> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34(or later)"
>>
>> The documentation can be obtained at the links below:
>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Cd2bca7c6209743a7fe0e08d8573e70fd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637355274033139116&amp;sdata=C3EGywJcz3rAPmjckWGKbm7GkHR1Xyrl%2BIL9sEijhcQ%3D&amp;reserved=0
>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Cd2bca7c6209743a7fe0e08d8573e70fd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637355274033139116&amp;sdata=29n8WNNpcUgVQRUyxbiSPcWJGTL5uV%2FaHgHXU1b9BjI%3D&amp;reserved=0
>> ---
>>
>> v6:
>>  One minor change in patch #04. Otherwise same as v5.
>>  Updated all the patches by Reviewed-by.
>>
>> v5:
>>  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F159846887637.18873.14677728679411578606.stgit%40bmoger-ubuntu%2F&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Cd2bca7c6209743a7fe0e08d8573e70fd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637355274033139116&amp;sdata=D7HvBj6OArmpKsiaZj0Qk3mIHWYOOUN23f53ajhQpOY%3D&amp;reserved=0
>>  All the changes are related to rebase.
>>  Aplies cleanly on mainline and kvm(master) tree. 
>>  Resending it to get some attention.
>>
>> v4:
>>  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F159676101387.12805.18038347880482984693.stgit%40bmoger-ubuntu%2F&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Cd2bca7c6209743a7fe0e08d8573e70fd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637355274033139116&amp;sdata=7og620g0qsxee7Wd60emz5YdbA44Al4tiUJX5n46MhE%3D&amp;reserved=0
>>  1. Changed the functions __set_intercept/__clr_intercept/__is_intercept to
>>     to vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept by passing
>>     vmcb_control_area structure(Suggested by Paolo).
>>  2. Rearranged the commit 7a35e515a7055 ("KVM: VMX: Properly handle kvm_read/write_guest_virt*())
>>     to make it common across both SVM/VMX(Suggested by Jim Mattson).
>>  3. Took care of few other comments from Jim Mattson. Dropped "Reviewed-by"
>>     on few patches which I have changed since v3.
>>
>> v3:
>>  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F159597929496.12744.14654593948763926416.stgit%40bmoger-ubuntu%2F&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Cd2bca7c6209743a7fe0e08d8573e70fd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637355274033139116&amp;sdata=hvPNH827bmo1VL%2F%2FIv%2F%2ByQdVBygOpI1tkgQ6ASf5Wt8%3D&amp;reserved=0
>>  1. Addressing the comments from Jim Mattson. Follow the v2 link below
>>     for the context.
>>  2. Introduced the generic __set_intercept, __clr_intercept and is_intercept
>>     using native __set_bit, clear_bit and test_bit.
>>  3. Combined all the intercepts vectors into single 32 bit array.
>>  4. Removed set_intercept_cr, clr_intercept_cr, set_exception_intercepts,
>>     clr_exception_intercept etc. Used the generic set_intercept and
>>     clr_intercept where applicable.
>>  5. Tested both L1 guest and l2 nested guests. 
>>
>> v2:
>>   https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F159234483706.6230.13753828995249423191.stgit%40bmoger-ubuntu%2F&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Cd2bca7c6209743a7fe0e08d8573e70fd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637355274033139116&amp;sdata=rP%2BlRJ91tk1VXS3YX8TdP2L9vORiIj8gN3ZZLKIXfeY%3D&amp;reserved=0
>>   - Taken care of few comments from Jim Mattson.
>>   - KVM interceptions added only when tdp is off. No interceptions
>>     when tdp is on.
>>   - Reverted the fault priority to original order in VMX. 
>>   
>> v1:
>>   https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F159191202523.31436.11959784252237488867.stgit%40bmoger-ubuntu%2F&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Cd2bca7c6209743a7fe0e08d8573e70fd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637355274033139116&amp;sdata=IGmv%2BLF60dmGVSCwcTU6sTDMvW1%2BEWUqTA5K%2FAowuxM%3D&amp;reserved=0
>>
>> Babu Moger (12):
>>       KVM: SVM: Introduce vmcb_(set_intercept/clr_intercept/_is_intercept)
>>       KVM: SVM: Change intercept_cr to generic intercepts
>>       KVM: SVM: Change intercept_dr to generic intercepts
>>       KVM: SVM: Modify intercept_exceptions to generic intercepts
>>       KVM: SVM: Modify 64 bit intercept field to two 32 bit vectors
>>       KVM: SVM: Add new intercept vector in vmcb_control_area
>>       KVM: nSVM: Cleanup nested_state data structure
>>       KVM: SVM: Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept
>>       KVM: SVM: Remove set_exception_intercept and clr_exception_intercept
>>       KVM: X86: Rename and move the function vmx_handle_memory_failure to x86.c
>>       KVM: X86: Move handling of INVPCID types to x86
>>       KVM:SVM: Enable INVPCID feature on AMD
>>
>>
>>  arch/x86/include/asm/svm.h      |  117 +++++++++++++++++++++++++----------
>>  arch/x86/include/uapi/asm/svm.h |    2 +
>>  arch/x86/kvm/svm/nested.c       |   66 +++++++++-----------
>>  arch/x86/kvm/svm/svm.c          |  131 ++++++++++++++++++++++++++-------------
>>  arch/x86/kvm/svm/svm.h          |   87 +++++++++-----------------
>>  arch/x86/kvm/trace.h            |   21 ++++--
>>  arch/x86/kvm/vmx/nested.c       |   12 ++--
>>  arch/x86/kvm/vmx/vmx.c          |   95 ----------------------------
>>  arch/x86/kvm/vmx/vmx.h          |    2 -
>>  arch/x86/kvm/x86.c              |  106 ++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/x86.h              |    3 +
>>  11 files changed, 364 insertions(+), 278 deletions(-)
>>
>> --
>> Signature
>>
> 
> Queued except for patch 9 with only some changes to the names (mostly
> replacing "vector" with "word").  It should get to kvm.git on Monday or
> Tuesday, please give it a shot.

Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
as expected.
