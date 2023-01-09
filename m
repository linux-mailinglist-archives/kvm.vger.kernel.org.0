Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C2C66357A
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 00:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbjAIXlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 18:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbjAIXlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 18:41:17 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B47463C9;
        Mon,  9 Jan 2023 15:41:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMOMrybMGvyr5mX+CDyGkm88PW2je1MOCy0N/21RKUCmCqHdjU7JuZgDHHYvmLWYoNbMh9Wy3OLoZ4Z/kyjvrD7xGV/w4m/KfE5QN/2LGX7tR/gfaTge6J2N96kD3bkzyVvWa+Zcj7ZoZjh3sz/q1Ms2zvvvAofKZpTU9ajKDk8x2jr37dujF3n0/cd4cRH6G5NEJo/jCUAa0666P18nlzqXKKFBrgSQXqIW1P2+xUcd2AFTISZz5Cef7cG4dV3Y9+PI2bLIydWJZFmXNrHoMUwKLEnXi4TRLw1bKZ6COei9qqG4NBWm7lZrLEwjQyvgdG2AYcNGA75YlZKdegvEcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmeTiDNoQqv1YgkX7prYJcWbdgX4PMXoJ48PGIYJfz4=;
 b=B9X+wMq2RA9dfLqZLdvnwKZAeH7hox78U01H+ixbEHMKX1skWHDDJGMDzo3BQ/RlO3mFl9+DOeikgwAGIkpgwikO+rALl7eE4lmIsBddN+p/4Kf++bzyxYdVYqqtKXDwZFdZozfYqMUllRSPLJYEXP7XP0VIx2FcsyyiUdl2UewYpm2goHcIoKgpBqJkfX2JXliGl5tn5lYOLqoBRmGAdQ/Qo8B477Ruzr2SKBMEoD344fxO8vBn9QtwdyOnqCw9NeTZ9yBgdF+qmK+MtC1x/VE9hEx3cVUNZEo2ZqkkURfo1bf5Zi6vC+OVj93ops+3mJtLTDSTFDVGUdImws6I0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmeTiDNoQqv1YgkX7prYJcWbdgX4PMXoJ48PGIYJfz4=;
 b=JXdf1JpQkOev4f26x6CqMLUBQ6+1NujNmr01Eo9SW/RphIoDGBnVtbX6OAPG+bzv6qSF52E0NpzIePZS7QVLf7OpgN1fkKagcLZh040mH3XhsIiLMH7y41CRUGlvUydZVb30OfEBWcMwFeQLEew27IPFc2komBq0PwnChGKI0KQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 23:41:13 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 23:41:12 +0000
Message-ID: <66039193-14ca-5edb-d8d4-ca732d8c13a6@amd.com>
Date:   Mon, 9 Jan 2023 17:41:07 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-53-michael.roth@amd.com>
 <aab7ed11-870e-579d-9328-4c32d9936392@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <aab7ed11-870e-579d-9328-4c32d9936392@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR19CA0067.namprd19.prod.outlook.com
 (2603:10b6:208:19b::44) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA0PR12MB4509:EE_
X-MS-Office365-Filtering-Correlation-Id: d4b582fe-0167-49a5-dad4-08daf29afdfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tCU58gzVyvegwDD3t2AnFFEBRw0OV2vIlydxPOnWkrwhaot9BlbsyA3gsuwBRUNpBuWTHUPXSPUE7pucJkUeIZyAhJ5irwYHlje2Ej9nzAn/zuGLdo2N/vW9qFvu1nxXBXMaBiZHrAC0RI8YrtzIJ2XB+o1XQu2qEE/kds2B+NFclYhXxVkI2bZuDTgqbkelLKsIcsSohIxbq/g+xvloe7b9brHkFjyfcfFpi7zp9UVgVYaFDYkIoE95tszEtTzNsgYJ9PLgddVxkVCRUQ3xDJOa3Y3zkrRSb/pDSNx0yO82NcHpj0v7tSHEc+19JWPAv+YUGQRUsEl5Q8yDwcqYvfsC18Lo5CwFqWwVB9lEtMWrj5MuH3b7i0AEhRpRW9eWa1qzzbBvTZH2gUTjNgEWjrddRxL5unDkT/79W2oYNCtzJY8qJle3WhuSUchXEKxI2Mre/HbTfVCdj/+CTZMfWTD8tLjEfIfVvucDICn+4yLUQoGEBLM22zp8ORD78BJvyhexyZu72RINWFVrUhyaNOS9TnOpcSignM5gg3qDcZP6R4ov4lDJqFHjZa87Hpom8YyRkmf0LqpHfi1vL0uxJTsLPlsg0Ppqh9xgUSqD8epAMSEkTALC9xZEl9HuWGHksdsHOit71hlp9jUMYKEbpaKxka2NKQvD7PBXVvhynurrovCctj7qfgMEZabKaB3rfGBjwOpW34EtP6DFlo8KQMhE9obWrxXks7cssICGcSFv6p7AN8k9KRpGmSINnwvAI6uXShg0MkyzeAqgER+pOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(36756003)(186003)(8936002)(26005)(6666004)(53546011)(6506007)(6512007)(2616005)(66946007)(5660300002)(66476007)(7416002)(66556008)(7406005)(4326008)(316002)(86362001)(31696002)(38100700002)(478600001)(110136005)(41300700001)(6486002)(31686004)(8676002)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0FhYUxaVWNscEhWUGdyYkdZa0dObk9ITkxYTUxJRHRVTk52YkNIalpLRGNB?=
 =?utf-8?B?Zmx5bzB1djROTm96SUhNcXRhMXdMSHNxZGpNSFd6T2h4YTFUNi9JYzZ6Ly9T?=
 =?utf-8?B?SnpUVHNFdGthRXRaaDBMQ1dvV3Avbk1oenpGR3lMK3NqNmwyOGJmVzE4aWlJ?=
 =?utf-8?B?TU4ydUMrbkp2SmpxQlJqR2xQNERLSDZ5TStaUGFCVGFWczh5ejI4M2tzNTZz?=
 =?utf-8?B?bkF5TFo4NTNTQW9JNmMzTnNJL1NDVU13L2pNaEk5a1hvT3BReHpRVHZaSUxm?=
 =?utf-8?B?aTlxblBHNHV6VWx1MlZEZ2JST3JGK1UydTFhb0pPOWMwNnF3TzVtVCtzQjRj?=
 =?utf-8?B?S01odnNhSnkzZGhhdDdOeW1teDMzbDEyRmx1N0tsNmhCN3lZSm5SbWlkTkcv?=
 =?utf-8?B?V0p5N0MwUHZBbGlZNm9yU2UwM2hOcmRMRGlUT2k3VnNxSVZEZW02MGprRmdO?=
 =?utf-8?B?bGdQUGd1NVMvaUhGWWpPNUdRVmgzamc3ZVl6NmRHTEtZeVlsdVBRODFUU1ZC?=
 =?utf-8?B?WHlFZ05KSmdqUE82UGFrTEd3WkQ4K2F4eWRveHpzclU1ckgrRVZRRWY4S0ln?=
 =?utf-8?B?NkpkdE4rQVZMS3h6T1RpOEpsbjFHRFFGVnMvVGg1ZStuV1EyMGFNVEptMFdl?=
 =?utf-8?B?RlFvRytzNDROdkZwVjVIVS9TLzRhYjdRS2p0cm9KK1ZZZjFTdWx2cVM0bmQw?=
 =?utf-8?B?czBEUU40aUdXYSszcTRVUWQzdUlLMlpVWGM0dUtxNlFsNVF2bzFqUFpHVkU5?=
 =?utf-8?B?c2ZQOFZQUzB3VmVqb1FJQVo0K3phdXlHQWRDV2dFckNodWJOUFdwYmY4OTlC?=
 =?utf-8?B?aXpEMUZ3aUs2WmdXY3lSL1FWYWZJZnZCbDFLQkhXQS9hK0kxMUQraUpFU3dy?=
 =?utf-8?B?ZjFoUDF4Wk9kQjcvQmZDbWFWZlN3alRDUlNJcDZFTGZKM0RKUWhYSVkwMmhR?=
 =?utf-8?B?SEdmYjAvWklWUXY3bnlVUUVFbG1CL3JnVWp5S0wvTFlkRmphTGdxY1dkc3JF?=
 =?utf-8?B?aWoyMEtHTm9PeGFzdC9FY3B0TGRyaFJZN0tqOGdBYTdsaVFjNEozNGtsOS9k?=
 =?utf-8?B?a01Vb3pGajV4TTdVN2RQaXYxR3lLalIwclpxdmdNY01kaDRNRHZ2emJtWTRj?=
 =?utf-8?B?bnpMajd3TlkwRGlMbks5Y3JtNDNiQXFlUUk5NDY4SlhCeDgrVmo0dXIxazFV?=
 =?utf-8?B?ejRURXJuYlBaRGVQbW9tc0JmVmZzdEh5akRUdC9XUEVwaDRXZUZWV3duNkVH?=
 =?utf-8?B?TlVsUk9SR0lMMTIya1hDd3gyRnV2U3NSL0NBMVpJNUx6ZGJwQ2ZWOTc0cE5G?=
 =?utf-8?B?MDlSbDVINTZRTjE0a1Q2YWs2WndYZWRUQVlaUnpKU0ZSYkhUVDc4Z0w3dlR6?=
 =?utf-8?B?bmtCWW1aVTdiM3MwVVFiNDhFY1ZuVnplYWlON1VEckdVTFlqMVNNckZvT0ly?=
 =?utf-8?B?cmJWWUl6UDdka3RXZzBHTkpuR1ltSW85dHdERnJkN0xNeWVVekxpb2RXYzkz?=
 =?utf-8?B?SDRMb05QOHhFc2EwZDZZRXdNamZOMVhZS0VjbktkRnVUOXc2ZG1NZzlVMEJN?=
 =?utf-8?B?MzF3TlNXU1lPa0VOdXRxSGdkQ1JyUHFNVE4xZHZUK2tDdmI5OW5xdllPSXl1?=
 =?utf-8?B?RUM3Z2JFYjgvRnF4QWRMcmxGcHhjK0c3NjJpbE85WlJvTVJ4RzdmcjVrdW1R?=
 =?utf-8?B?bVpIRVdMbUxqODhPc2RucVpZaERhSW03SkEwT0tNWGhEc1Q5aE40UzA1R2Uy?=
 =?utf-8?B?ZjNIbVltVDhHV2poMmI2WUVubjBKSTY2bnJqcCtJMzhROWhMUURMUTIzbG93?=
 =?utf-8?B?RTh5SUN1bEk4c2ZhelZUVFF6Z1R4cmgrbkdUSEJNNUZLMmpBT082MU5wbisx?=
 =?utf-8?B?akhYU0FnM0FocFg2RzViVWZvMlRsN281cjBnWExCaHJjMlg2b2poc3JUOHVu?=
 =?utf-8?B?T3IwK3h6eUtzZmR0Q3p2dDY0aUg1OWVTQjdMOEtycEhVL0tuWmpmK3JvQklT?=
 =?utf-8?B?QVZsQmdHeGgyVkxRbTFHVnVZWHFjcVhUb0Rab1craWdqUytXTzZ5QnlVemxS?=
 =?utf-8?B?bStUYUQyWS9JK3ZndEZsV0RNNkJFNFo2anBrbWZnSWROSkNCOFNjQmdNNG9G?=
 =?utf-8?Q?96E8u27ovDTAajcCswu8gKz6q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b582fe-0167-49a5-dad4-08daf29afdfa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 23:41:12.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+MxYI/rGr1alxRC74ygmG2l9Wi28V7S8STneRHKJAZCDrbc2SUX68PV5VnoYP1laNWyyecFmgvmP049rJVbng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
> On 15/12/22 06:40, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Version 2 of GHCB specification added the support for two SNP Guest
>> Request Message NAE events. The events allows for an SEV-SNP guest to
>> make request to the SEV-SNP firmware through hypervisor using the
>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>
>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>> difference of an additional certificate blob that can be passed through
>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>> both the report and certificate data at once.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 185 +++++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/svm/svm.h |   2 +
>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 5f2b2092cdae..18efa70553c2 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, struct 
>> kvm_sev_cmd *argp)
>>           if (ret)
>>               goto e_free;
>> +        mutex_init(&sev->guest_req_lock);
>>           ret = sev_snp_init(&argp->error, false);
>>       } else {
>>           ret = sev_platform_init(&argp->error);
>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct kvm 
>> *kvm, unsigned int source_fd)
>>    */
>>   static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd 
>> *argp)
>>   {
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>       struct sev_data_snp_addr data = {};
>> -    void *context;
>> +    void *context, *certs_data;
>>       int rc;
>> +    /* Allocate memory used for the certs data in SNP guest request */
>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
>> +    if (!certs_data)
>> +        return NULL;
>> +
>>       /* Allocate memory for context page */
>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>       if (!context)
>> -        return NULL;
>> +        goto e_free;
>>       data.gctx_paddr = __psp_pa(context);
>>       rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, 
>> &data, &argp->error);
>> -    if (rc) {
>> -        snp_free_firmware_page(context);
>> -        return NULL;
>> -    }
>> +    if (rc)
>> +        goto e_free;
>> +
>> +    sev->snp_certs_data = certs_data;
>>       return context;
>> +
>> +e_free:
>> +    snp_free_firmware_page(context);
>> +    kfree(certs_data);
>> +    return NULL;
>>   }
>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct kvm 
>> *kvm)
>>       snp_free_firmware_page(sev->snp_context);
>>       sev->snp_context = NULL;
>> +    kfree(sev->snp_certs_data);
>> +
>>       return 0;
>>   }
>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>> vcpu_svm *svm, u64 *exit_code)
>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>       case SVM_VMGEXIT_HV_FEATURES:
>>       case SVM_VMGEXIT_PSC:
>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>           break;
>>       default:
>>           reason = GHCB_ERR_INVALID_EVENT;
>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct kvm_vcpu 
>> *vcpu)
>>       return 1;
>>   }
>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>> +                     struct sev_data_snp_guest_request *data,
>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>> +{
>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>> +    struct kvm *kvm = vcpu->kvm;
>> +    kvm_pfn_t req_pfn, resp_pfn;
>> +    struct kvm_sev_info *sev;
>> +
>> +    sev = &to_kvm_svm(kvm)->sev_info;
>> +
>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, 
>> PAGE_SIZE))
>> +        return SEV_RET_INVALID_PARAM;
>> +
>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>> +    if (is_error_noslot_pfn(req_pfn))
>> +        return SEV_RET_INVALID_ADDRESS;
>> +
>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>> +    if (is_error_noslot_pfn(resp_pfn))
>> +        return SEV_RET_INVALID_ADDRESS;
>> +
>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>> +        return SEV_RET_INVALID_ADDRESS;
>> +
>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>> +
>> +    return 0;
>> +}
>> +
>> +static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request 
>> *data, unsigned long *rc)
>> +{
>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>> +    int ret;
>> +
>> +    ret = snp_page_reclaim(pfn);
>> +    if (ret)
>> +        *rc = SEV_RET_INVALID_ADDRESS;
>> +
>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>> +    if (ret)
>> +        *rc = SEV_RET_INVALID_ADDRESS;
>> +}
>> +
>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t 
>> req_gpa, gpa_t resp_gpa)
>> +{
>> +    struct sev_data_snp_guest_request data = {0};
>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct kvm_sev_info *sev;
>> +    unsigned long rc;
>> +    int err;
>> +
>> +    if (!sev_snp_guest(vcpu->kvm)) {
>> +        rc = SEV_RET_INVALID_GUEST;
>> +        goto e_fail;
>> +    }
>> +
>> +    sev = &to_kvm_svm(kvm)->sev_info;
>> +
>> +    mutex_lock(&sev->guest_req_lock);
>> +
>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>> +    if (rc)
>> +        goto unlock;
>> +
>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
> 
> 
> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
> 
>> +    if (rc)
>> +        /* use the firmware error code */
>> +        rc = err;
>> +
>> +    snp_cleanup_guest_buf(&data, &rc);
>> +
>> +unlock:
>> +    mutex_unlock(&sev->guest_req_lock);
>> +
>> +e_fail:
>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>> +}
>> +
>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t 
>> req_gpa, gpa_t resp_gpa)
>> +{
>> +    struct sev_data_snp_guest_request req = {0};
>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>> +    struct kvm *kvm = vcpu->kvm;
>> +    unsigned long data_npages;
>> +    struct kvm_sev_info *sev;
>> +    unsigned long rc, err;
>> +    u64 data_gpa;
>> +
>> +    if (!sev_snp_guest(vcpu->kvm)) {
>> +        rc = SEV_RET_INVALID_GUEST;
>> +        goto e_fail;
>> +    }
>> +
>> +    sev = &to_kvm_svm(kvm)->sev_info;
>> +
>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>> +
>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>> +        rc = SEV_RET_INVALID_ADDRESS;
>> +        goto e_fail;
>> +    }
>> +
>> +    mutex_lock(&sev->guest_req_lock);
>> +
>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>> +    if (rc)
>> +        goto unlock;
>> +
>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>> long)sev->snp_certs_data,
>> +                     &data_npages, &err);
> 
> but this one does not and jump straight to drivers/crypto/ccp/sev-dev.c 
> ignoring sev->fd. Why different? Can these two be unified? 
> sev_issue_cmd_external_user() only checks if fd is /dev/sev which is 
> hardly useful.
> 
> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
> attestation report" added this one.

SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and that's 
why it goes through the CCP driver interface 
snp_guest_ext_guest_request() that is used to get both the report and 
certificate data/blob at the same time.

All the FW API calls on the KVM side go through sev_issue_cmd() and 
sev_issue_cmd_external_user() interfaces and that i believe uses sev->fd 
more of as a sanity check.

Thanks,
Ashish

> 
> Besides, is sev->fd really needed in the sev struct at all? Thanks,
> 
> 
>> +    if (rc) {
>> +        /*
>> +         * If buffer length is small then return the expected
>> +         * length in rbx.
>> +         */
>> +        if (err == SNP_GUEST_REQ_INVALID_LEN)
>> +            vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
>> +
>> +        /* pass the firmware error code */
>> +        rc = err;
>> +        goto cleanup;
>> +    }
>> +
>> +    /* Copy the certificate blob in the guest memory */
>> +    if (data_npages &&
>> +        kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, 
>> data_npages << PAGE_SHIFT))
>> +        rc = SEV_RET_INVALID_ADDRESS;
>> +
>> +cleanup:
>> +    snp_cleanup_guest_buf(&req, &rc);
>> +
>> +unlock:
>> +    mutex_unlock(&sev->guest_req_lock);
>> +
>> +e_fail:
>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>> +}
>> +
>>   static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>>   {
>>       struct vmcb_control_area *control = &svm->vmcb->control;
>> @@ -3629,6 +3788,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>>           vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
>>           vcpu->arch.complete_userspace_io = snp_complete_psc;
>>           break;
>> +    case SVM_VMGEXIT_GUEST_REQUEST: {
>> +        snp_handle_guest_request(svm, control->exit_info_1, 
>> control->exit_info_2);
>> +
>> +        ret = 1;
>> +        break;
>> +    }
>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST: {
>> +        snp_handle_ext_guest_request(svm,
>> +                         control->exit_info_1,
>> +                         control->exit_info_2);
>> +
>> +        ret = 1;
>> +        break;
>> +    }
>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>           vcpu_unimpl(vcpu,
>>                   "vmgexit: unsupported event - exit_info_1=%#llx, 
>> exit_info_2=%#llx\n",
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 12b9f4d539fb..7c0f9d00950f 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -101,6 +101,8 @@ struct kvm_sev_info {
>>       u64 snp_init_flags;
>>       void *snp_context;      /* SNP guest context page */
>>       spinlock_t psc_lock;
>> +    void *snp_certs_data;
>> +    struct mutex guest_req_lock;
>>   };
>>   struct kvm_svm {
> 
