Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCE0663B27
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 09:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbjAJIdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 03:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbjAJIde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 03:33:34 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE1D496FC;
        Tue, 10 Jan 2023 00:33:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzT37f8Z8/LcK4HybUG8SBiCO1GaTbiA7zf5aVgDuu6KaOKB2ja4f9ir4bHaiGjTcRSsXf3d3GMr4aaEXg+HzOQUiIf77fuxiq/DdKWoYV6CPEz/n/0He2klQPbktfih/fdrpKohBKtt77FoIurR9Trpu77M0dWb/2Ib0IUD0n/zo08OMkQ6cLM3VF6v7FuTisb/7aKx4Nc3P/cXgxh+c/BTnUX1Lwoom37mZv2s6vIao5UD2fxvHuUSy58jY8/By4vyKm7kbDwXumWg9Hqk+Iu2F5Wxd45sJVvk8XLrRoSCkSyOql4ZX5yirs6zBoW6GUskM4djq4Qi/nWWemf+qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8WMbdDLDXhR08G5n7aBiFfV4X3gotJkJ3m8iUHhh7k=;
 b=UoYzHj7+1NkOpkSHKWulOTZsHeP8q/WqnMT4qFTAQNblWAQRTbjW3Xqi9GBh826SnBNePHpmm30iMe+dZY0S3YTRTY09Bum0PhViw/4938BHvMrW4uEuY2owyPsSDT/rSXkxZEbIABjohRSKDgWRumZBVWLmELIybcnhcnXgC5js89lfu979/k5yq0DhOJdq/lqk2C4pW89SmNYbeeVBtVpiGWyvI8eyla9Sq06NFKEqCBgMV3u9RJwIuShnGmwibEz1QgnTinY4YwvA0HSxLj1Wt9EIBkWogln3OXXzilaetdOz5BGfQLJ6xLmcpcl4ve4J2Z39GhtBkLMGq+3Mew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8WMbdDLDXhR08G5n7aBiFfV4X3gotJkJ3m8iUHhh7k=;
 b=C8QPewv634RdrxzRfi+mMSLYzeMSHGbt2IIRn+vAGY13BXFQTceDPGvxLgLd0QJJMsADuuc+DzG9ZETXmnH4WDWYHZ6CUhreSUWQP83QSBKvGcPFZXrR1N5JnZwpF6hvCLlTNiHyNW+bOtM3Z6mu3spcEwIo95CTQ4r4RMiaeG8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 08:33:26 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 08:33:26 +0000
Message-ID: <385016f9-e948-4f7f-8db3-24a0c0543b3d@amd.com>
Date:   Tue, 10 Jan 2023 02:33:18 -0600
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
 <66039193-14ca-5edb-d8d4-ca732d8c13a6@amd.com>
 <119075dd-5f3e-a393-f543-6cdfd34cd337@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <119075dd-5f3e-a393-f543-6cdfd34cd337@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0418.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA0PR12MB4510:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c235e30-c6fa-4c13-c974-08daf2e557ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/drYlo5GkNjTX2XrkFztCL5FyP/jCyOJN0pZ3NUHRcS+b9M9oVpbO8u3SfyoFCvEl6gCBHxwZr6WI2qY06Tk7MvQnPGKEVItGA3YdAX2NyFT26LKq0dLrRFdbVZEPINjo5uRFsUwB6znYL1Umvo3dqYeotigRvCt0bkIPq6YJg6q1AutNksnaHky9ewhxGO6Jn7PQPVB73mBdnjv0/8abtvV2H6TMWrRryhOSJvI7v+vivLgPNY92xhcvUSohB5upbaGDCIIccfSm3Y9uX3m14KOWJo1of9v1hDsKFGjGZ2ovgJEYCXcQ7srXU3OCEnw6bYtaCMtNesLsVnQ5OFp5d1RMHR13i/IrtzIb0JrgC/7tW1NWObfAE1+Z/pjfRBOHEsBKYJZ+25vgaURcw259IUqP3+JkyXDSJrgzGAGbIv8G9NA+FctI5LMDu0wLoK2XwMKkBMfANNus6b+WwxOg4kuwhsyLrZKZx9fy/+ghtGVAsgrtWynwf9/xNswH8YnhbIGbT1tk3NYRA/gOLVzfqVJ+JL+7d7GswtVHeaMv4X6aVY/fUkBv3hPUmw/8YKLjTW3DMJmXSCkWhF9OSsfprHqvjzT3pW3oMeemxQ5gYmx7xODoG6Q6DP2Sa8BUnICfsQ6Yy6w9tuh58PMdkqNrzq5hI4sYHtHHa/ncrDkuqLgqeageVbz6FLeS3bKlK90EsVVt1Qd5lJVBawmXpWBI/5ueSZHZ+ovRdr1kA1VCK0g48LIf0bF+884hI5gfo8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199015)(8936002)(2906002)(5660300002)(7406005)(41300700001)(7416002)(4326008)(316002)(8676002)(66556008)(66946007)(66476007)(110136005)(26005)(6512007)(2616005)(38100700002)(31686004)(86362001)(186003)(83380400001)(31696002)(36756003)(966005)(478600001)(6486002)(6506007)(53546011)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V09jWisvUFUya0ZCclBaQmpnd2JSSkgxd0I1MG5yN3NCVnFRSFhPR1R5RERi?=
 =?utf-8?B?Q0hrRWt0UDdxcUR6bnh1SFZaK0hGSzhlam10aFJXQXU2UG1ZeUpFSU1RU1BP?=
 =?utf-8?B?SjhqUnB2TkMvbktsNXFTQlZoTlU4b25naEVCUFV0R0QzbWxVOGNXdWRPNUpl?=
 =?utf-8?B?RUpUZ2xpSnRlSVphRnVvVWxpaTJxRDV3aWpXUTJSVmcrOW5lUmxjRWQrME9L?=
 =?utf-8?B?K25HTjFIcUkwMHNlTFhIakJSMmJlTVhha1VRcko2TWVrOUI3Zk9iUldpS2c3?=
 =?utf-8?B?MitZeHk5VCtHSGl3UWloeGFHUkh4ZWNJcTBrYjhyZmxzbDdxb09zazVZUk5R?=
 =?utf-8?B?UEx0TTdXZ3Z0a0g4THRCazBjZTlaSEFxck1LdEgvdEpwL0hJcVptRk1DS21m?=
 =?utf-8?B?WW1zRG1LcTdSaUp5RXZ0Nll1cDFOVHgxL3c3YnRtVVJGUWpkV201UTlUK3VI?=
 =?utf-8?B?YVJ6YndEcmRiLzcxV1g0U3FLS08xQUoxTWF4R2dkeWc1ZU9TNi9vbU9VaHNa?=
 =?utf-8?B?MGhDNGZEd0dwMkk4NUR6T1FXUFRmeFJCUmZRVWVlcjhySkVzL3daZzJhMVBD?=
 =?utf-8?B?cktTOXZ1K2xhckVhb1dEUXpTVk1QSjltVlF5eDNZcE5qNkd3dGdSa1ZkcXM2?=
 =?utf-8?B?TE03Wjc0dy9sZW1sT29UOEVrOTdnTThnV2h3ajRTNXFNMU9DajlLYTdCOFcr?=
 =?utf-8?B?dkdrSXY4eHdJbzhhU1Jqb1c4d2xIdnpTdW5sQkFUNlh3WjdydG5ZeXEvWjdo?=
 =?utf-8?B?a3duamhGVUdadTVVWEREN1hjRGFKTlJraHdLd2JtdjdkTkFIR0dhUDJRd2Nz?=
 =?utf-8?B?QkF5Y21wM3VaMXNBQ1FROW5LSjAybVRPY2FaM2MxVVpjandudmpodmxVdXZK?=
 =?utf-8?B?djUyWURhZmhETys0dDRQOTRNWGZHYlJ1NUVNT2p3cW5hVGZkVCtVblJxZzcw?=
 =?utf-8?B?VVR3dy9Bd0VleUkyekRENjJNTUJUUWdCbEhlemdyUmpoVENLVHp3T0ZUclN6?=
 =?utf-8?B?UUNjNFVHOU5hSHN2OU0xQlZWVWhqc0xYcG5IMmJHTi90dHB1RHZKLy9nUVhv?=
 =?utf-8?B?a0JYZ2FsRWR0OWpGZG15UzdLbVhYaDlhMHk5a2gwREkyUjlpVWNRYW0zWHhx?=
 =?utf-8?B?b1N6cjZsZlRMWDJ4SFpoWkIyQ0ZIR0FMVmFlYm05VnY3SWxCWlhTd1IwZkxD?=
 =?utf-8?B?QUE4dGNPL1hhR2pwR0dMRmhOU0dsTCtZcFJKR1VGMi9wQVk3UkFQMzdXa3Ft?=
 =?utf-8?B?TjhYMG1DMk9XOCtBVlU0L0NmK3ZSSTlnN05EZElhNDNJcmxSZmMyWVRIbUo5?=
 =?utf-8?B?MUZKcUtTeFUvVC9rQkFzMjlKd2Yzc2w4czFDWVhWNkRPSkJkZC9Zc1dDbitW?=
 =?utf-8?B?T2NzWjVTTjlkc2gwbFl6THMvQUs5cm9TeHJCK1JPcGdSWktXRmloeFdHVEVp?=
 =?utf-8?B?bisxc3dzbHZmVWhQd0tiMkRVcGlYYkhleHo0d3U2RnVmVXNMaXJ3T2hsaXA1?=
 =?utf-8?B?UjRYaVh5S1VSemJiQ3doRTdaQnhtR0pDRndhTDlkOElqQ1NKY2FZeUphRkh2?=
 =?utf-8?B?cnlOcHpwa09nNGdOZ0pEMElKbncxVm5tODBRL3ppNTFlWGk3VFN3QTd6cDZX?=
 =?utf-8?B?eTVFUnQ0R1BxYStyOWhPRFdMTTBGT3daMS83R3VDZnVtQmxEWVd2UEU3bnJH?=
 =?utf-8?B?aXVPWHFnS0h0UFhXemNMaStlNThrVjNhNWxmenU3NndUdWFNWG5YYzg5ek1n?=
 =?utf-8?B?Mmw0Y25vb0JNRzVPZHhWREh1d2Fxd2ZWazljVkdGd0R3eHdGcFR4MDRqL0ls?=
 =?utf-8?B?Yyt1VXRTaytFblpET1h5QUFtRTMvSmZ3dGxZaE5LZDIrWEFoRWRQNUh5bFlQ?=
 =?utf-8?B?WWpYOS9LcXVBNnNJMTdwbWdpcGdFTmxxRm5CMFNTQ2d1a2cxUnZacitOaHB0?=
 =?utf-8?B?M21LK2xKd1JEcHoyMm1UMUFwUFRXRWkvSnNpTnhUZ1U2NVk4b0UrU1dYSXRz?=
 =?utf-8?B?YVlobE9oVG1Fc24rUU5PYVNPN3NNVHYvMk5MZ2FEQ0hmUmRuTms4UzR2Z0Yv?=
 =?utf-8?B?TUhNN2lrS1JVajRmL29HcHFhOWs3YkFZQUhHTThvbVN6T2YybFhDM2V6Qko3?=
 =?utf-8?Q?aK4gUl+d9lShqhnCvvxrCHHyy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c235e30-c6fa-4c13-c974-08daf2e557ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 08:33:26.2823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOC6D/N4k2hf4DjeqIahXvpTrMCPdHMhfe2BgXSrf4we1b9hfvIADA+90+K5NOLL4OqGQg5FLz7uGkwswt9PmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 10/1/23 10:41, Kalra, Ashish wrote:
>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>> On 15/12/22 06:40, Michael Roth wrote:
>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>
>>>> Version 2 of GHCB specification added the support for two SNP Guest
>>>> Request Message NAE events. The events allows for an SEV-SNP guest to
>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>>
>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>> difference of an additional certificate blob that can be passed through
>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>>>> both the report and certificate data at once.
>>>>
>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>> ---
>>>>   arch/x86/kvm/svm/sev.c | 185 
>>>> +++++++++++++++++++++++++++++++++++++++--
>>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 5f2b2092cdae..18efa70553c2 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, 
>>>> struct kvm_sev_cmd *argp)
>>>>           if (ret)
>>>>               goto e_free;
>>>> +        mutex_init(&sev->guest_req_lock);
>>>>           ret = sev_snp_init(&argp->error, false);
>>>>       } else {
>>>>           ret = sev_platform_init(&argp->error);
>>>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct kvm 
>>>> *kvm, unsigned int source_fd)
>>>>    */
>>>>   static void *snp_context_create(struct kvm *kvm, struct 
>>>> kvm_sev_cmd *argp)
>>>>   {
>>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>       struct sev_data_snp_addr data = {};
>>>> -    void *context;
>>>> +    void *context, *certs_data;
>>>>       int rc;
>>>> +    /* Allocate memory used for the certs data in SNP guest request */
>>>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
>>>> +    if (!certs_data)
>>>> +        return NULL;
>>>> +
>>>>       /* Allocate memory for context page */
>>>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>>>       if (!context)
>>>> -        return NULL;
>>>> +        goto e_free;
>>>>       data.gctx_paddr = __psp_pa(context);
>>>>       rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, 
>>>> &data, &argp->error);
>>>> -    if (rc) {
>>>> -        snp_free_firmware_page(context);
>>>> -        return NULL;
>>>> -    }
>>>> +    if (rc)
>>>> +        goto e_free;
>>>> +
>>>> +    sev->snp_certs_data = certs_data;
>>>>       return context;
>>>> +
>>>> +e_free:
>>>> +    snp_free_firmware_page(context);
>>>> +    kfree(certs_data);
>>>> +    return NULL;
>>>>   }
>>>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>>>> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct kvm 
>>>> *kvm)
>>>>       snp_free_firmware_page(sev->snp_context);
>>>>       sev->snp_context = NULL;
>>>> +    kfree(sev->snp_certs_data);
>>>> +
>>>>       return 0;
>>>>   }
>>>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>>>> vcpu_svm *svm, u64 *exit_code)
>>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>>       case SVM_VMGEXIT_HV_FEATURES:
>>>>       case SVM_VMGEXIT_PSC:
>>>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>>>           break;
>>>>       default:
>>>>           reason = GHCB_ERR_INVALID_EVENT;
>>>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct kvm_vcpu 
>>>> *vcpu)
>>>>       return 1;
>>>>   }
>>>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>>>> +                     struct sev_data_snp_guest_request *data,
>>>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>>>> +{
>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>> +    struct kvm *kvm = vcpu->kvm;
>>>> +    kvm_pfn_t req_pfn, resp_pfn;
>>>> +    struct kvm_sev_info *sev;
>>>> +
>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>> +
>>>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, 
>>>> PAGE_SIZE))
>>>> +        return SEV_RET_INVALID_PARAM;
>>>> +
>>>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>>>> +    if (is_error_noslot_pfn(req_pfn))
>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>> +
>>>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>>> +    if (is_error_noslot_pfn(resp_pfn))
>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>> +
>>>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>> +
>>>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>>>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>>>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request 
>>>> *data, unsigned long *rc)
>>>> +{
>>>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>>>> +    int ret;
>>>> +
>>>> +    ret = snp_page_reclaim(pfn);
>>>> +    if (ret)
>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>> +
>>>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>>> +    if (ret)
>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>> +}
>>>> +
>>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t 
>>>> req_gpa, gpa_t resp_gpa)
>>>> +{
>>>> +    struct sev_data_snp_guest_request data = {0};
>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>> +    struct kvm *kvm = vcpu->kvm;
>>>> +    struct kvm_sev_info *sev;
>>>> +    unsigned long rc;
>>>> +    int err;
>>>> +
>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>> +        goto e_fail;
>>>> +    }
>>>> +
>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>> +
>>>> +    mutex_lock(&sev->guest_req_lock);
>>>> +
>>>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>>> +    if (rc)
>>>> +        goto unlock;
>>>> +
>>>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
>>>
>>>
>>> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
>>>
>>>> +    if (rc)
>>>> +        /* use the firmware error code */
>>>> +        rc = err;
>>>> +
>>>> +    snp_cleanup_guest_buf(&data, &rc);
>>>> +
>>>> +unlock:
>>>> +    mutex_unlock(&sev->guest_req_lock);
>>>> +
>>>> +e_fail:
>>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>>> +}
>>>> +
>>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, 
>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>> +{
>>>> +    struct sev_data_snp_guest_request req = {0};
>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>> +    struct kvm *kvm = vcpu->kvm;
>>>> +    unsigned long data_npages;
>>>> +    struct kvm_sev_info *sev;
>>>> +    unsigned long rc, err;
>>>> +    u64 data_gpa;
>>>> +
>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>> +        goto e_fail;
>>>> +    }
>>>> +
>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>> +
>>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>>> +
>>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>> +        goto e_fail;
>>>> +    }
>>>> +
>>>> +    mutex_lock(&sev->guest_req_lock);
>>>> +
>>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>>> +    if (rc)
>>>> +        goto unlock;
>>>> +
>>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>>> long)sev->snp_certs_data,
>>>> +                     &data_npages, &err);
>>>
>>> but this one does not and jump straight to 
>>> drivers/crypto/ccp/sev-dev.c ignoring sev->fd. Why different? Can 
>>> these two be unified? sev_issue_cmd_external_user() only checks if fd 
>>> is /dev/sev which is hardly useful.
>>>
>>> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
>>> attestation report" added this one.
>>
>> SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and 
>> that's why it goes through the CCP driver interface 
>> snp_guest_ext_guest_request() that is used to get both the report and 
>> certificate data/blob at the same time.
> 
> True. I thought though that this calls for extending sev_issue_cmd() to 
> take care of these extra parameters rather than just skipping the sev->fd.
> 
> 
>> All the FW API calls on the KVM side go through sev_issue_cmd() and 
>> sev_issue_cmd_external_user() interfaces and that i believe uses 
>> sev->fd more of as a sanity check.
> 
> Does not look like it:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/crypto/ccp/sev-dev.c?h=v6.2-rc3#n1290 
> 
> 
> ===
> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>                  void *data, int *error)
> {
>      if (!filep || filep->f_op != &sev_fops)
>          return -EBADF;
> 
>      return sev_do_cmd(cmd, data, error);
> }
> EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
> ===
> 
> The only "more" is that it requires sev->fd to be a valid open fd, what 
> is the value in that? I may easily miss the bigger picture here. Thanks,
> 
> 

Have a look at following functions in drivers/crypto/ccp/sev-dev.c:
sev_dev_init() and sev_misc_init().

static int sev_misc_init(struct sev_device *sev)
{
         struct device *dev = sev->dev;
         int ret;

         /*
          * SEV feature support can be detected on multiple devices but
          * the SEV FW commands must be issued on the master. During
          * probe, we do not know the master hence we create /dev/sev on
          * the first device probe.
          * sev_do_cmd() finds the right master device to which to issue
          * the command to the firmware.
	 */
...
...

Hence, sev_issue_cmd_external_user() needs to ensure that the correct 
device (master device) is being operated upon and that's why there is 
the check for file operations matching sev_fops as below :

int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
                                 void *data, int *error)
{
         if (!filep || filep->f_op != &sev_fops)
                 return -EBADF;
..
..

Essentially, sev->fd is the misc. device created for the master PSP 
device on which the SEV/SNP firmware commands are issued, hence,
sev_issue_cmd() uses sev->fd.

Thanks,
Ashish	
