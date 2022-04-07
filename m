Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC64F7237
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 04:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiDGCrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 22:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiDGCq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 22:46:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3E920D816;
        Wed,  6 Apr 2022 19:45:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc2fowrfqMu9+ID7WjrlIc4uM+x/59R3Ka0ibwzUolCyczuXqJl8fWzm7ukbwe/Wn0wBCyNoJUI2547Uz78djltEOoxiDxJE/v0Z5LDMVIFbg3NzsuZ9emDMOgdQ14wXAJwvSeY/klgXS1FOqhbzkMJpPOoFrabQzjgFxzadu4ZFwHJD6oYM3WTXzmEREy+nENbI7iQ+b7CgXPHggDGXQuX0QKoc0F/WAmFuLU8Ll0gWuJaDRzuLfZBxP/c8Pz3nePhqtThEOVKx0tXnLtMXSio6cZ8hnGWBdYWYJBUBUF6YDKBuXg4SIezPG+kmsepH5pUurvfreUgvWni3rE9Geg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqS4TNTf5cymXLu2phWuyiMDZkkkDQL2nRgKuUM4+JE=;
 b=B4GP9+ZkanhqgwR0yTKNfcIWotytOGbCARXLxwqU0TkrIeIVTY9ND7eJgUAZgzQLIMO44uc+mkjaCzP244sgrr8JycnOnfVUToMiQfEuqh7/TK/qfQX2ITpoqLlFmbdLPmMD9eej0kECT8x5gbAkmeufLrRdHMDJfmiUa71C6rr0b+rkZuQA0RPbYR/iXwvkf8ZI6Iei1QtKtbKtm5pn22iHph80s8hqDU4xQG/8jMDhNvLQ+CRNlPLIuovPu61e92M0FfBB2xj3pKrghIh5JzPDOxl7pOGvds2YJy3oPyLPN86hmwhJ6dtnh8EmIPEmkwGadXjd0UXtv4gehQf4mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqS4TNTf5cymXLu2phWuyiMDZkkkDQL2nRgKuUM4+JE=;
 b=VYjtL6irwsPsZxSW5Bl/YF/7znLpwYDTr943+f8WYpy5mUsUQVmTLq+kuZxf46rbg9cHE9TrbTIeb6ywVg0A+HobzWysiyJjXsZNA2fnGDRWNj0OZh86b4Ss2kEbml8jM5zCBfD9SAqvlUro8FllOVD4eQ+mBrizVk/rDDHhUu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BN6PR12MB1794.namprd12.prod.outlook.com (2603:10b6:404:100::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 02:44:57 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953%7]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 02:44:57 +0000
Message-ID: <dac4d609-98a3-0311-4234-1e6ba4644cb0@amd.com>
Date:   Thu, 7 Apr 2022 09:44:44 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 07/12] KVM: SVM: Adding support for configuring x2APIC
 MSRs interception
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, pbonzini@redhat.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, peterz@infradead.org, hpa@zytor.com,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
 <20220405230855.15376-8-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220405230855.15376-8-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0034.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::21)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e33eb16-a210-4579-6263-08da184099f5
X-MS-TrafficTypeDiagnostic: BN6PR12MB1794:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1794B62060AAE961904C8A49F3E69@BN6PR12MB1794.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMm7Fwbz3RLhJnmHClZ3GwsIg4uTt82AIrpqna7DWko/8wRfideEnEqIkb2LPmVAH93mNs8QDYRABnjm4JjKqP+IdkR6deHgO53adT2hD1gMcUNOjl2K6VQhcv0Hn7h3SgGbF1JYqjuuHNsOho4XNdAHcLjt9ECVA0vO9K8JT9EKkSjiQsKlk9On3iyupBQHNK54hEONR7zxKemvAb9cxt+p9S2bjcqDWQfhDoPS0HhyEZbBFV2TueFxyVRIkZ77gNoC2r7G9rBXWSXHolXRMZM/VxZaENek8QLzybPMSPj3A4lu7uBDNSSi1SY5F9jj0ERAbdDWVjuJ+UgNwCzi0E+/DDtmJz9BlgXxundEqYrdD7oD9DwSByxizUOXwO+Q9keO3+bTqjBsEl6yWCf4wPsQPfi5jDFYxyGA0dXCuqJLbrCgim0BjOGjSniZDoNhQT6kXFTBkNSWR/Z9hDZO0wCcwKUgew5D4g86UDCOhh41h5esWcW+5Z+03kdrsVJaSIYavZwFGrlrUZeFVAAFuHcIdOk9UL4Iz7joUIzqcISFFpyc/C6bfL/VUwBzcnCZNqWVBLnx3FDsru+a0gZNQEP+sNh2FRYs2375p8cfCnrpw0JxZfYCiZBfW/ZAKiY+BWFCxJYAYla0wP3bCVAUgalE2VdUGdFZri2lsLTR0UpH183NB/zNwcgs5PParkQ7123cIvCLSqkeNsjfV3ntg1iJAYp0k/pj6960cGJ6VPY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(8936002)(6666004)(2906002)(83380400001)(31686004)(2616005)(6486002)(7416002)(508600001)(5660300002)(36756003)(38100700002)(86362001)(66476007)(8676002)(4326008)(66946007)(66556008)(53546011)(6506007)(31696002)(186003)(316002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU11bmVMVVozd2l6eU9ndXFVVWVYMzRNZkhraGZNYVhZaFg4eit1US9TTVhs?=
 =?utf-8?B?V2lwc2MxYkZ6TmtoM2twRU9WSDcyN1FjV1RDaUdxOEFycXhpcjZVQ2lwNTQ4?=
 =?utf-8?B?cTVRczU4bVRwUWFFeU9rNkMrUVJYU0dmT0tFdjFoY2tSbWRZdzlwSXF6NjNG?=
 =?utf-8?B?MXRLSVRvaDZNTFFKbHl4ckN0UGlILzFTV1pQVkVaM25idEFLakZlekZvMi90?=
 =?utf-8?B?NTRVWEhVc1RDNW1aakpGNGo4TkxBenFVVGVxd3lic213YW1OdDAxdE1jdWhk?=
 =?utf-8?B?dCthZ0xlMEU3alRDZ1NxcklZazUwbmdpSXpJSzBuUHlHbUNwV2c2L0VXRFB4?=
 =?utf-8?B?OE42cFhCQUI2T1JkU0ZCQUdzdHVlLy9wUEo4VXI0ckM3aGQxOXpQZW04WW9X?=
 =?utf-8?B?bEMzQStpVlRxWlRmNUhWMjM2L3pFY0JyN2o3aHlxd2Z3cHZ3QXRKaWVyMjhZ?=
 =?utf-8?B?NEhQYnUxMkluNHNZVHpzR0dZdldHdDZNTG4ySXdoaW1NTFdxd1JXUXRTNW1T?=
 =?utf-8?B?ZThuZXNSM3lwUWFiZkcvMHA5UllKQ1JyT3lGaDlRSkN3VlhjYmx4YVc5TVYv?=
 =?utf-8?B?M2NqUzl5U1FZaUxveWJHRmlKa3JnL3NBQXlBOUd1VjVrMUlONVA1NThxNFk2?=
 =?utf-8?B?Vk4rQ1dzYkdHdFRzR0JDY1ZOQmJZNHREVXRPQnlWT2xaL0xOZHZLalZMWXhv?=
 =?utf-8?B?UStsZDRDK2NQUjlTcGl3ZDNkbG40N3N0NzR2SzhLcHVlaXBycnpLTFlNaGYy?=
 =?utf-8?B?WlNsNXI3QnBvMU1xYkRCQjFVN2k0YlkzMERKRDF4bkdxRlFCZldaQ1I0SE9l?=
 =?utf-8?B?TUhNM2M2WFBWTzlKN1hscnNrU0ZSUFpPSlFCOGZRR1VNYm1UcnN4RU9NSXUv?=
 =?utf-8?B?UFlKSlZIRERKelNrZDQ0MnVTOFM1NWk5eTFVaHU0TWNKSHZ3cmFpS2hZSFcz?=
 =?utf-8?B?YmZyMFJvamYvdUVJOWZ3d1pOdUlMaVJPYm5QaWgxZ2oyWFplSGNsWUxDVFdP?=
 =?utf-8?B?dTdWMWhhYjB4K25mMHZrWWhid1k1aEF1U1AwL1M2dlF6T1lVSS85U1N3dXdo?=
 =?utf-8?B?a2R6NlI3cG5sVTlFWElkTW9QT1RYd3N2aEUwQUQ1ZDd1VEtiRHZUQm8yUkl1?=
 =?utf-8?B?Nm1hWGJqSkZxS3R0aFZ0MUhaQzJrSnE1ZDZoRVBVNitzam9DeE9kQWlmRVhF?=
 =?utf-8?B?dnRDMDU2T001aEl2V1FkSHFPUk5EZXpzSlJORXk1VkczT05rVVJsYUZsaTF1?=
 =?utf-8?B?TzRkakFFanNQMmY0OUVmQ2N4UnR6QTNDdmZEZElOVGJjc1pEQmd4VmUrZy8x?=
 =?utf-8?B?NG1ES2VMWEFjeFVwekZ1eTdVeGdGbHdBTy9KdGJvUkhNdFRnQXQ0NW02bWlN?=
 =?utf-8?B?YzN6Q243TTE5QlpTdHBUNloweUtzN2ppOEYxbHhUMjJTZ2JBL0o5Q2RDaXRI?=
 =?utf-8?B?WWJsQ3AxYnBZSDNsSDIzaUxMN0FjdXludEV2dW9tTTQ5SVZkaVA0bG13d3Np?=
 =?utf-8?B?VGFtOG9qSlJKUkY4T2U0eTNSWkVuRnh1K1oydWlTcnJtQ1o2U0psQlJVUlND?=
 =?utf-8?B?WUdBR09xZUEwRW5oRlBiSGI1cFpzb1FLT0JWN21vakRjNW04ZU1WZ05UcW50?=
 =?utf-8?B?d2RrMUhSTTY4K01vOFdneWwrSFFlU3dSVzBWMDZVOWdvSmpaZWNyR1luQjcx?=
 =?utf-8?B?V1lGM25oQmV6WjRqaW5ENXUxQmFIdTNZRmhjaTAxdzRBb3o1RFFSbDZubm8y?=
 =?utf-8?B?NUM0bVJLYVc0ZitoemxXZW1QV0VjQkRPUE90R2V4M1hiUzl6a2VlUzlmbHpK?=
 =?utf-8?B?MURIUWpubWZFV0dDYklKNXBqYjM2Sm1KK2RZbWw4L1ZtRTdMNGVJS3Vwd1pR?=
 =?utf-8?B?QXN4NTk2Qzl5MGw2cjZ2WTFjZ0xNelhJTkJyNjc4cTN6NDJGcWVhM0NnQzZ6?=
 =?utf-8?B?cFU3QTVsTEJJdWhzNWYreWlqTTZxQ0xTUC9pY1NidG1DSDUwbUU4TW9CYUMv?=
 =?utf-8?B?UzJYUkFuck9VWXoxOXRsbTFnNWdta1pFRUNpTktWdXdnQkNvQjI5NW5SdHUw?=
 =?utf-8?B?d2d3V1JqbHAwQzdBUFpES2wxNXhPUlFMVHI4RVVaVUNweHd5V3V3OXhlS08v?=
 =?utf-8?B?Y3lKTVFQdDBEaStxbS9VeGdKMmdOcHpua0NGbjVKZ2gyVXRwTmhDYU50S0lM?=
 =?utf-8?B?NjQwamNYdGFNY1UrbU83UjNpbFVhYWUrcTQ2cUMyT1pPTWpQOHFXZE1FOHZp?=
 =?utf-8?B?ejNyd2FVMGxoMHdkREpXK2dHQmZoM0lDdDB0MGJSRFpRZkdTN0xWL2tqZG1C?=
 =?utf-8?B?Q0xNVm8wT0tDMFhKNDFLYUpkUkUxYUFFam9jdEp1NExlMGZVK3ZXWVd2b3Mv?=
 =?utf-8?Q?MLpkUkkbZPdVoHh26A76fTJIAOLrdFABrUrCB3qFF/etM?=
X-MS-Exchange-AntiSpam-MessageData-1: OkyVMmsaKogZEg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e33eb16-a210-4579-6263-08da184099f5
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 02:44:57.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4qhDolUHcc9sTgk55NqlZoekX+EreOEqnGXwODLXccTAqduyhUBEMWBeawt8fCCFaYX1snO4iHeop5wzmfAww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1794
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/22 6:08 AM, Suravee Suthikulpanit wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index bbdc16c4b6d7..56ad9ba05111 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -89,7 +89,7 @@ static uint64_t osvw_len = 4, osvw_status;
>   static DEFINE_PER_CPU(u64, current_tsc_ratio);
>   #define TSC_RATIO_DEFAULT	0x0100000000ULL
>   
> -static const struct svm_direct_access_msrs {
> +static struct svm_direct_access_msrs {
>   	u32 index;   /* Index of the MSR */
>   	bool always; /* True if intercept is initially cleared */
>   } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> @@ -786,6 +786,33 @@ static void add_msr_offset(u32 offset)
>   	BUG();
>   }
>   
> +static void init_direct_access_msrs(void)
> +{
> +	int i, j;
> +
> +	/* Find first MSR_INVALID */
> +	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
> +		if (direct_access_msrs[i].index == MSR_INVALID)
> +			break;
> +	}
> +	BUG_ON(i >= MAX_DIRECT_ACCESS_MSRS);
> +
> +	/*
> +	 * Initialize direct_access_msrs entries to intercept X2APIC MSRs
> +	 * (range 0x800 to 0x8ff)
> +	 */
> +	for (j = 0; j < 0x100; j++) {
> +		direct_access_msrs[i + j].index = boot_cpu_has(X86_FEATURE_X2AVIC) ?
> +						  (APIC_BASE_MSR + j) : MSR_INVALID;

I found a bug in this part, when testing on system w/o support for x2AVIC feature.

The following change fixes the issue.

-               direct_access_msrs[i + j].index = boot_cpu_has(X86_FEATURE_X2AVIC) ?
-                                                 (APIC_BASE_MSR + j) : MSR_INVALID;
+               direct_access_msrs[i + j].index = (APIC_BASE_MSR + j);

I will update this in V2.

Regards,
Suravee
