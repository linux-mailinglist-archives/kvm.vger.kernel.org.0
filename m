Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2804B96A7
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 04:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiBQD0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 22:26:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiBQD0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 22:26:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAFE28A137
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 19:26:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTZnjcsLljiKahBD08QM1BnFY0kJP4pmk6n+iiDIsh0LDgBiEXu4Aq5GT8jmGW53Nhh9MnEyp2b/dxobCCsXCXq/pNF9DSkQt9UWZ0B/ijuCTaOLUxav7OkXBBYJaSJO2mbYbtvkeLTgXV70A81Mg8QdCvfuR42PNxd/AFZvhhh9/DN64zgBghrDgQKnIrbVK3qtKhPYY/3nwFtXfLYL6tIa4y2i6SPMIo3rrsb88+ZcLybXnTfUD191w/aPaxdYCkq2lLf1mS7FtSImPs7t2YYVP82Nul20ewIZ+RERkDekZG3s/H2b1PaDhYKCm5Xy5Q0PFdWBIyct2eld34lO6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJ1tsQGDDqjjoTHL6rlEfZvIqNSzk4AlEUlq5RwcFOQ=;
 b=WFFLBP5SBhCK8PBjEiYKR5Jr5XFy16G4YY6OQqqZjj2LIS7uBlZ7qS/UNRusLogZIJglU9WIibz3gBcgQsYJUMy1IvuYKN43QzctCNNG5pj3iMegHE9tAptb2jMZE0jYQ3C6KP+iT920C+13o7H7hu3BvW0C5ko1EEKji0Ivy7t2NwxAI3HG17hapXuUIMgnzyz9fb5De/0XkbsCtuBKd6LPPfjF/t7VCqXfGDFdvQl3473XcFZQIvAP8voAwZtVnei0nw2ZuvE+Pj6+q6821wKgEEhKpbb6ThHSZ8P65H4dbGW14dBNU/hfUh+XQkLuh5GuYdUyKTz1LyJtW07Hjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJ1tsQGDDqjjoTHL6rlEfZvIqNSzk4AlEUlq5RwcFOQ=;
 b=XJ9MtaMsoxwQ/AaaVSeHsXMlxamCmsLh0AuLQJxcH1iI+OCDUtB73Ivz3zRC4+4AGP5tqPcc1j9eiX/m1u1Meh1jHlX01w/v0tO2wjag6qykEtsqldsWtFE6VXICVYaDlhFtzqW05rkF4uGKwW8kDVq4BD6rk6wSYvFzP6p3W4Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by DM5PR12MB1451.namprd12.prod.outlook.com (2603:10b6:4:d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.19; Thu, 17 Feb 2022 03:26:33 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c%4]) with mapi id 15.20.4975.019; Thu, 17 Feb 2022
 03:26:33 +0000
Message-ID: <18489ffd-c3bc-2f0c-38cf-9faa74cf3363@amd.com>
Date:   Thu, 17 Feb 2022 08:56:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: nSVM: Add an exception test
 framework and tests
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, seanjc@google.com
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-4-manali.shukla@amd.com>
 <CAAAPnDH6y6pFG+Mw_JCYYi9rome0d0+Q4UTLK3KoBzREvkJwqw@mail.gmail.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <CAAAPnDH6y6pFG+Mw_JCYYi9rome0d0+Q4UTLK3KoBzREvkJwqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::33) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ede233ee-b65a-4a84-fce0-08d9f1c54bb8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1451:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB14515D05832CCE3D7D20FDFAFD369@DM5PR12MB1451.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dVdM7O+gOXbDK2NDcdCEl7rTOTNdEtjCaZ1r5owF1+OXXyN4qgZLFA6vy4oG6spxHovnUJaOaDk6amWXrWwp2V8dzhhabWM0x9veVC43kmsGjbsJpv8KmxCOT/Kiw1NzvAoUWvi2O4dQ5JIGCkLhOBaRmgeYu4bxXXObqQK7C0tOlE9ZB3xpI5jeUqe9lpFutodowynY5p0hhH7pqZaLqieM3vtN0s1sUY48y3OxoplZWz87GQJOVJ+j67B7FCQOJHP9RAI6LuDvaqE/iYqVZnIsW063JuMf1mQG8BDGY/ARCRdmC8GwEUMupM4fuVPYCtQpRXC9w4hhUsPgz/JoiwcZ7+VDx4fpuRN15YJD/DHK7cnjR4UcnIKeco9XxWr9wymAe5Nh7Zpq3zViQtIbyIMXjqmhGmuA4kVW330EVSXXMniCoPV7100sx8SybpVgh+zlJX9fnF8tdibhv30t2ZoWnY/p/+erbNZkuejjpkuS2s1wl8G9RKJskTJKov3n/FsEndB2gLz4CbPBlhikpFUpvEB8vvGNdkcDEyhCJbU5rozPxxta4BMt/hgbGpPke4kzGyljG93l46BxAHcbVc8V3eQ23tVlktDiOxAhBwmdaeOdQtPD7/ZAuZ2fKPPciNYNXor6YNV9VpgTccjAkl3ZJoDBiXVu8wowTnMI/vR0Zg3+cFin9OKWsm1ES4w4ZF1N9oAxtLlMUhoi9FLPcl6Qc5pnuyMjpscThR0bis=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(6486002)(31686004)(6506007)(6636002)(6512007)(6666004)(508600001)(5660300002)(186003)(31696002)(2616005)(2906002)(8936002)(36756003)(53546011)(66476007)(8676002)(66556008)(4326008)(66946007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3V6dU05YnFvS0hTeU9xWlVkcTEwc2NMd0JndXFCcGZ1dXRTWlFKanJ5SVRL?=
 =?utf-8?B?NEorQjFBUlROdThCVU1LQlFER2RTU3RGSGI3TGlIQlo5anN4UGs1OTlRVkFw?=
 =?utf-8?B?d1grZEtYUXRMV0hZVnkvbXRLVEJscG5TbGFXRzhVNEh0ZDNSc0VqdkZySU1Y?=
 =?utf-8?B?YUR2M21CV3hkNTNZOExCS2JrN1R5c2RjZ3pBRnoyVnlyZ1NzclpybUpOWDA5?=
 =?utf-8?B?aUNDcDhSdDY3Qk1sZ0UxS1RhNWp0N0NWbVI2ay9wVWc5LzJjbFltTTgydDVo?=
 =?utf-8?B?SUVmRlVyR25wOG94Wjl2ODd6NC9YMXk3MG52bnoyRDA1TktvVkhvMDJ0UVpU?=
 =?utf-8?B?UWVjR3o3U3lHVTlEQXE0d09mVUhhdngyK1hiUDQvbW5WTnpjano3cnNadVh4?=
 =?utf-8?B?K0lZaGE1eHd1YzQ0ZVR3L1VVckthbTJKaDdoVWVkVGVlbVkrazVJemRyd05n?=
 =?utf-8?B?dVpid1U3L3dRR0pmeHkzWjVtVGRCNkRZclBlOFNzZStjSWZteEMrSEpXUVpM?=
 =?utf-8?B?aC9FMHRRS2lFU1VoeW1jdWtISVFxTnYyQjFnalJxVi9DU2ZsdXJDOCtaVmhM?=
 =?utf-8?B?NEMzLzk1V01xS1dVeGJ5MENVYUlFekhKSmZzNTFLQnFoRTBya0x6Q21jVCs4?=
 =?utf-8?B?MkZRa0ZHMVBYT21jdmNUOFI3VVZGVXNqRHFzVUU1dlNoQUhjdWdveWhkSW1q?=
 =?utf-8?B?dUdCRkk2YTRBQ1BLcXdXeHU2cDRGYjhmTGEyQmNrd1A2aEhFMTBuVlZ2enAv?=
 =?utf-8?B?S3lTamVlczdsWlFtWTFvMEV6NU90dGNhU3VwNVdEaExlSUkycDB0NmYxZzN2?=
 =?utf-8?B?M1N6NjFGeXRXMEFTU2VsVmc0VXM4RVg2RW4rQzBDam1ydzMwWW1uSzdtS0F1?=
 =?utf-8?B?UkVsallrVDR3S1VJTnREZjBjMjFvVnFMUVc4cFQyU0RXL29ISGxvS1phRDZF?=
 =?utf-8?B?Kzd5N0pqM3h6aUIvcHNGNEZneEtnSGFIKzdsSVJnYmFaZ0psa1pjMFVwaUJC?=
 =?utf-8?B?SXI2ekMxdVlBWlJ3aUdrUGJvVjJUVk5HcHlLZDdVTlNyS0pvYmhLdWlKSUVB?=
 =?utf-8?B?M2pRcnNPRDE0VldXVjZldUQvUFRTRlIyVVhuZWxycC9UcHFET1JyU08rQm1O?=
 =?utf-8?B?OFlEN0FmbkxxODRMMXpkQXg2SjNnMDlqQ0QyZmNMcngxNEpMY3FZWTlURWRT?=
 =?utf-8?B?V255dE5NdHJFYkxudU00YmE2SW9QVkRBaHZmZmRsQy9TUzFlSkRoeW4wUU1a?=
 =?utf-8?B?ZW9waXZiWW1zYkQxcDQ1T0tZV01tZjh1SVZWaWtNMUc3bExtallxbHBuYjJR?=
 =?utf-8?B?bVhIeFpnSDk1ZnJDQnEvNWJyeWdyeU9yL0ZYZzYzQzdNYnBNMmQ5dythV1d2?=
 =?utf-8?B?MzU4Mk5rQnBYRmhPMkRBTXJxWDU0clh6OGtHcC9uV3hxNGdLYkFzQ2NYdTBY?=
 =?utf-8?B?WUxKTXJhNGVHZGsxb0hvODZWaTVUZXdIVzZsbi95dmkwK08yVHpwY1A1RXdw?=
 =?utf-8?B?UXFEdVcyNExiS291dkFFOGdUc29tdVVSLy84NFZkUFJ0eUN2VWlFMmsvZWIy?=
 =?utf-8?B?VTNzUHlPUGNKR2FnZDdWSUdCNVpKa2RtQ3VGcnp6c3lOSW02UVZsVWc5RWdD?=
 =?utf-8?B?TWF4RTI3YTNoRTFGQ1NtUmpaS1ZoN3NqTk5tM2lWb2J6a3RGa1RFaHczRG9N?=
 =?utf-8?B?U09IWG1vNGtQRFNieDR4b1VEeXJqRE4xbGRndE1OcXdCOU8xUDJzdGlUdjRm?=
 =?utf-8?B?YWpYcHFrUnZPNTNDSDU3czFkUjFwZUl5VTgzZXd4UjAwaklpZjJTQ08yclVr?=
 =?utf-8?B?bDIrbFhaM3YxcVlhRExsL1ViZ2lZWlFhTXJnNVhhcFZaZGMzbGNMU1dxaW4r?=
 =?utf-8?B?emxqYWJEdkZUQWdQRU9rMmJmdDNkMHNlNFA0YUMzei83Vld3S2FJYnRJakNH?=
 =?utf-8?B?bEZBVlo2dW1wdVNjYlJJNkliQlF3aHh3MGZqbXRWK0tteVFQYlBpMVNuZm9U?=
 =?utf-8?B?SUtKcjlHQmNoV00zdm0vUjlVcDJqbi92Wm5iaUhucndkby9hZHBjaUlXeEhx?=
 =?utf-8?B?UnBIYzB2LzhKb3Yydnc5TjRWbTdYdFFFbGVpcTJaT0Zab2hUcTU2MzJFYzgx?=
 =?utf-8?B?R3Vlc1lnOUtOM0F2YXM5YmVOYjF3NzRJaldzbHBIMXJidHE0S2JaT1VoaXd3?=
 =?utf-8?B?U2FwTktmTUdMWFpMVHAyUkk1UWVCcDMvTkFOWFNEY2lwL3BpSGRWME5TMFpO?=
 =?utf-8?Q?z2l6jkf1mn0PbqGp7cwj+fis60RWcFAYwtqxQ+aeus=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede233ee-b65a-4a84-fce0-08d9f1c54bb8
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 03:26:33.3713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RxfD0zyy3A9FhIna96ephWbf9EKtC7Uy2cJ4TzktXaQADKw/oLNVTh6oy3iYcGsno9up46GhbKPtLV0fMkkBTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1451
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/15/2022 1:50 AM, Aaron Lewis wrote:
>> +static void svm_l2_nm_test(struct svm_test *svm)
>> +{
>> +    write_cr0(read_cr0() | X86_CR0_TS);
>> +    asm volatile("fnop");
>> +}
>> +
>> +static void svm_l2_of_test(struct svm_test *svm)
>> +{
>> +    struct far_pointer32 fp = {
>> +        .offset = (uintptr_t)&&into,
>> +        .selector = KERNEL_CS32,
>> +    };
>> +    uintptr_t rsp;
>> +
>> +    asm volatile ("mov %%rsp, %0" : "=r"(rsp));
>> +
>> +    if (fp.offset != (uintptr_t)&&into) {
>> +        printf("Codee address too high.\n");
> 
> Nit: Code
> 
>> +        return;
>> +    }
>> +
>> +    if ((u32)rsp != rsp) {
>> +        printf("Stack address too high.\n");
>> +    }
>> +
>> +    asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
>> +    return;
>> +into:
>> +    asm volatile (".code32;"
>> +            "movl $0x7fffffff, %eax;"
>> +            "addl %eax, %eax;"
>> +            "into;"
>> +            "lret;"
>> +            ".code64");
>> +    __builtin_unreachable();
>> +}
>> +
> 
>> +static void svm_l2_ac_test(struct svm_test *test)
>> +{
>> +    bool hit_ac = false;
>> +
>> +    write_cr0(read_cr0() | X86_CR0_AM);
>> +    write_rflags(read_rflags() | X86_EFLAGS_AC);
>> +
>> +    run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
>> +
>> +    report(hit_ac, "Usermode #AC handled in L2");
>> +    vmmcall();
>> +}
>> +
>> +static void svm_ac_init(void)
>> +{
>> +    set_user_mask_all(phys_to_virt(read_cr3()), PAGE_LEVEL);
>> +}
>> +
>> +static void svm_ac_uninit(void)
>> +{
>> +    clear_user_mask_all(phys_to_virt(read_cr3()), PAGE_LEVEL);
>> +}
>> +
>> +struct svm_exception_test {
>> +    u8 vector;
>> +    void (*guest_code)(struct svm_test*);
>> +    void (*init_test)(void);
>> +    void (*uninit_test)(void);
>> +};
>> +
>> +struct svm_exception_test svm_exception_tests[] = {
>> +    { GP_VECTOR, svm_l2_gp_test },
>> +    { UD_VECTOR, svm_l2_ud_test },
>> +    { DE_VECTOR, svm_l2_de_test },
>> +    { BP_VECTOR, svm_l2_bp_test },
>> +    { NM_VECTOR, svm_l2_nm_test },
>> +    { OF_VECTOR, svm_l2_of_test },
>> +    { DB_VECTOR, svm_l2_db_test },
>> +    { AC_VECTOR, svm_l2_ac_test, svm_ac_init, svm_ac_uninit },
>> +};
> 
> If you set and clear PT_USER_MASK in svm_l2_ac_test() before calling
> into userspace you can remove init_test and uninit_test from the
> framework all together.  That will simplify the code.
> 
If clear user mask is called after userspace code, when #AC exception is 
intercepted by L1, the control directly goes to L1 and it does not reach 
clear_user_mask_all() function (called after user space code function run_in_user()).

That is why I have added init_test and uninit_test function

> Further, it would be nice to then hoist this framework and the one in
> vmx into a common x86 file, but looking at this that may be something
> to think about in the future.  There would have to be wrappers when
> interacting with the vmc{s,b} and macros at the very least.
> 

Yeah we can think of this in future.

>> +
>> +static u8 svm_exception_test_vector;
>> +
>> +static void svm_exception_handler(struct ex_regs *regs)
>> +{
>> +    report(regs->vector == svm_exception_test_vector,
>> +            "Handling %s in L2's exception handler",
>> +            exception_mnemonic(svm_exception_test_vector));
>> +    vmmcall();
>> +}
>> +

-Manali
