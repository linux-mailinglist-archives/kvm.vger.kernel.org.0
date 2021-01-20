Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71C52FDE22
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 01:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbhATX5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 18:57:39 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:31674
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733249AbhATWK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 17:10:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCoO1azGJwSU0fhWdN0saOUDRf9vgA+T2OpdXsmxvPIDgbBA1wIoc/cotmRtENqca23FT7kuxeEh9ArbZXxLLs6JGnGtbWzkmHvSBSHDHqcO/rIoUzTW4rPKuA9Y71mGyQXPOslFK/xoPiyWefiRIyf5MBobga1mrYCHkJZZUk4whXQWuJXGmesSLCyAJzdLME0xS2SMr4X2xXRGJphOYdI9EYh/ioSZ1VKCP6ycNzUoDaGZfZTZb20X/6VyngzxA61Xcr8U9q1oHfVbBLxXZMyv+Y9nj3k3zPaVsB+/pSxQLOPjALha4oe3la1i/R15go3w0uJlu73CL07uHV0R1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tjJ8V0L3A0Hde7I/RkT1zkbjax+arGA2iIFtuxnNtE=;
 b=mJwmDAQ659K79w0BR98lBEOXk73AY9HSyjDApRv2YrcpVEymJC5EliX5rsJDgAvedKd47QUxCPp1+OAmzq+gKEUxeq8o9bvTS5sYGqCRtoZYWVMBTKZkrsEHJLRuuYUVslLXGduibUhaN+0upbqqFqlL9dYADvWWCeEcVfRL2zX4OYgniWo6xc82O1mlbZeUiF65GNoFfy2cH+t+S06bY9f52nEfHsgAvIErvGHbeeVv5XPD6Qhzo667/KKGmYLxeLHtnHmav65xsy0jFyoasFbAyeYBgNgo9eqpYyovROuSWSgGCIKT0/ghGK+m3J1pw10csZ3ES1Xr2dcEWReWAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tjJ8V0L3A0Hde7I/RkT1zkbjax+arGA2iIFtuxnNtE=;
 b=kp7SIp4V74IpT4AKdDi7bCpmbJ+Z4R823ib2FRBjeMu2m06GJ0vnV8lQxwS1eVmUlqnOGmzOOXhWo0exShSEPWutAi9jD3Y1/ykkquhicKF4BvnsqnsJv1GOcPoIPucWwaulj75ystDTEOLC+OC/qelnz+6sAO5ByuRAjISD71I=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 20 Jan
 2021 22:09:33 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3784.012; Wed, 20 Jan 2021
 22:09:33 +0000
Subject: Re: [PATCH v3 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, fenghua.yu@intel.com, tony.luck@intel.com,
        wanpengli@tencent.com, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, peterz@infradead.org, joro@8bytes.org,
        x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com, jmattson@google.com
References: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
 <161073130040.13848.4508590528993822806.stgit@bmoger-ubuntu>
 <YAclaWCL20at/0n+@google.com> <c3a81da0-4b6a-1854-1b67-31df5fbf30f6@amd.com>
 <YAdvGkwtJf3CDxo6@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <ae97b4c2-6f19-f539-a7ab-f91385449e8f@amd.com>
Date:   Wed, 20 Jan 2021 16:09:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YAdvGkwtJf3CDxo6@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0005.namprd18.prod.outlook.com
 (2603:10b6:610:4f::15) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by CH2PR18CA0005.namprd18.prod.outlook.com (2603:10b6:610:4f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Wed, 20 Jan 2021 22:09:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79d43c45-201f-40ed-925c-08d8bd90103b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4526296BE8242637137F196B95A29@SA0PR12MB4526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0rtiDa3qREONucI/z5oexVqvS8htOWTNIeFOXpufwq6qC3wiS/w3GnGIcVxlknsOstEsJcBb7vtYCUrUW2lR8pXhS/h3H3vEBft1QOOiwKtXoOddaIdjpMf1BRELwwZSY6DZYEuqWTNYy4EigkbiuHpYhW8/dIzZGMjX+ors1n+6JmGb/CeJzRFSrid2+oWcJyDpNO2DwyBnaUQcIEgLelViXj+ThtaEhtORIh0lX/zMpi9pfNPkWwoE/Bu1091xAdty4tsxvOVkIgc195H3qaLtv05CweEaUvm7ZmaZNe5Qp+QC3CkVtAP+m40nbIthgQsWJPLivkCQhptxfJfNNrRX8AVB+nqlep275Om+VG2qjcZfvxcUu8UZWnv0q6yqk1gr75KQTbBwNKfVn8FAVGAJKzPBJptB5j93AnVZ3B810kyZEmm5p400UhdRINJwWwqduRoGwsQqeR8LhOxEG9Zosfhtq2l2OaUq4HSIcs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(66476007)(316002)(16576012)(478600001)(4326008)(66556008)(66946007)(8936002)(52116002)(83380400001)(26005)(36756003)(5660300002)(186003)(53546011)(7416002)(2906002)(8676002)(31686004)(2616005)(44832011)(6916009)(6486002)(31696002)(16526019)(956004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UmlYYVlHTkVqaFB1T0tYL2U5QjlRK0hWOVZSdTQzZUhtOU1vemxadkJCbGFp?=
 =?utf-8?B?d0xDR1RnZTlmY2g5MG12alhicStndjh0Q2ZlM3VLd09FMGN6L3FCeUtpVDZ3?=
 =?utf-8?B?RHg2MjNOMG9nTnFseERJaEZFMHZZTVNyMkRJOGpmYzFVQitaQUlZM0NBYlVP?=
 =?utf-8?B?YkJzTVhjVE96RFh3M2xSTXZoMGR5K1hYdUdRQ1dMbjMwSi85STZKK2haczV1?=
 =?utf-8?B?bHFNY0ZMdkd3RUMvYWxSRlhzNUZzS3pEdW1peHhhWCt0Rjdoektza3hxK0JE?=
 =?utf-8?B?dWFQbEVGYXF2RHNCUDRySXBLazdXWmF0aEN6OG5aYnhNaEVPYWZWRVBlaHlY?=
 =?utf-8?B?L0lGRE4xSEJBWTZtUnU2a1o2NHU4a2hMMXhFdkZ2UmFSSWZIb2JPbVRDdk5K?=
 =?utf-8?B?THJYbnRqSjczVXd3a2p2RWZRUDFNREx4WkpvV2xrMzF5clJHL0tlVTZsYVZt?=
 =?utf-8?B?VGwyTXNpczNtbVVSb3RzWDRLN0RPVkVkUmJnZ2RiM2dIRmtsUkd4M3pINS9S?=
 =?utf-8?B?d3U2bmphT3RzS2U3OC9MUTc1d256cTAzUXJ6YTd2ZXozT2VlazlmNURlNU9v?=
 =?utf-8?B?eXpocDNFTDhBQm1jUkFHbXoyc1NFaWp5NnBPR2p0MXE4dkJjd2FyY1FrQmVh?=
 =?utf-8?B?Nlo5dHg1My92QWJZUWRabW5KT1NxUUkxZXFyTlVNYjEyNXU1Q240YjZMNW9D?=
 =?utf-8?B?ZzFxU3NPUlk3eC8vZXY3Wno1TkhEVWVlRjVrZGR6bTJlSk1wMHAxTnFldjJi?=
 =?utf-8?B?RHczbkJUYnluNmdmRzAwN0dhUWsybFNSUzlhVUNHRGUvOWFBOVNHMm15YlpK?=
 =?utf-8?B?cE14WDNudE1qTEUxbUdoempJUEN0SzE2bFdxY3hLQ2V4ZGZiWkF0YjBkUWxR?=
 =?utf-8?B?MTN0Q3d6UVVKTHYvZEc4b0tqalFVVlVyT1VSSk1Oejd1QWJJa295NXNRSHF4?=
 =?utf-8?B?VEd4R0R4TGYrTy9naldmYlI5ekcwSnRPZW5OcWZCNXJqbG5hUWVPWnZKekRN?=
 =?utf-8?B?RmVZNWY2VWg2MW1zUTA0N0ZDUWl0NjVza1FMaXc5UG12elRBQ3lOOTRmN3pB?=
 =?utf-8?B?ZzVkWHFpeERsbU1oUExWRVRMQ1hkUWNEeXpTK0VBbmFCYUx6RGpuNDd2c2Fk?=
 =?utf-8?B?ODlhQTBiS3ZaNjBya2J5bDdlTjFzck9rR1dqU2JmbzN2R2VYb2ZxMndQdCtj?=
 =?utf-8?B?TUo5d3g3WmhodGdVQytscjIveThGeFNyanVheC9XbTlESG5ibUF3UE5jbldM?=
 =?utf-8?B?dVAxeitncVlManhqQkQ3dHJtampXcTJIeTVVbTkvWC92cmFOU2JiNkNBWHF5?=
 =?utf-8?Q?lcueusEjquKb+y8vuNmrv5whe0hS/RQTjx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d43c45-201f-40ed-925c-08d8bd90103b
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 22:09:32.9668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LkDak8h7MuoZh0nGEzwu46903Zs07i7ToPDLMQqQmLZTWUP+GcgBfyoTOvj0SXL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/21 5:45 PM, Sean Christopherson wrote:
> On Tue, Jan 19, 2021, Babu Moger wrote:
>>
>> On 1/19/21 12:31 PM, Sean Christopherson wrote:
>>> On Fri, Jan 15, 2021, Babu Moger wrote:
>>>> @@ -3789,7 +3792,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>>>  	 * is no need to worry about the conditional branch over the wrmsr
>>>>  	 * being speculatively taken.
>>>>  	 */
>>>> -	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>>>> +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>>>> +		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
>>>> +	else
>>>> +		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>>>
>>> Can't we avoid functional code in svm_vcpu_run() entirely when V_SPEC_CTRL is
>>> supported?  Make this code a nop, disable interception from time zero, and
>>
>> Sean, I thought you mentioned earlier about not changing the interception
>> mechanism.
> 
> I assume you're referring to this comment?
> 
>   On Mon, Dec 7, 2020 at 3:13 PM Sean Christopherson <seanjc@google.com> wrote:
>   >
>   > On Mon, Dec 07, 2020, Babu Moger wrote:
>   > > When this feature is enabled, the hypervisor no longer has to
>   > > intercept the usage of the SPEC_CTRL MSR and no longer is required to
>   > > save and restore the guest SPEC_CTRL setting when switching
>   > > hypervisor/guest modes.
>   >
>   > Well, it's still required if the hypervisor wanted to allow the guest to turn
>   > off mitigations that are enabled in the host.  I'd omit this entirely and focus
>   > on what hardware does and how Linux/KVM utilize the new feature.
> 
> I wasn't suggesting that KVM should intercept SPEC_CTRL, I was pointing out that
> there exists a scenario where a hypervisor would need/want to intercept
> SPEC_CTRL, and that stating that a hypervisor is/isn't required to do something
> isn't helpful in a KVM/Linux changelog because it doesn't describe the actual
> change, nor does it help understand _why_ the change is correct.

Ok. Got it.

> 
>> Do you think we should disable the interception right away if V_SPEC_CTRL is
>> supported?
> 
> Yes, unless I'm missing an interaction somewhere, that will simplify the get/set
> flows as they won't need to handle the case where the MSR is intercepted when
> V_SPEC_CTRL is supported.  If the MSR is conditionally passed through, the get
> flow would need to check if the MSR is intercepted to determine whether
> svm->spec_ctrl or svm->vmcb->save.spec_ctrl holds the guest's value.

Ok. Sure.

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cce0143a6f80..40f1bd449cfa 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2678,7 +2678,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                     !guest_has_spec_ctrl_msr(vcpu))
>                         return 1;
>  
> -               msr_info->data = svm->spec_ctrl;
> +               if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +                       msr_info->data = svm->vmcb->save.spec_ctrl;
> +               else
> +                       msr_info->data = svm->spec_ctrl;
>                 break;
>         case MSR_AMD64_VIRT_SPEC_CTRL:
>                 if (!msr_info->host_initiated &&
> @@ -2779,6 +2782,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                 if (kvm_spec_ctrl_test_value(data))
>                         return 1;
>  
> +               if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL)) {
> +                       svm->vmcb->save.spec_ctrl = data;
> +                       break;
> +               }
> +
>                 svm->spec_ctrl = data;
>                 if (!data)
>                         break;
> 
>>> read/write the VMBC field in svm_{get,set}_msr().  I.e. don't touch
>>> svm->spec_ctrl if V_SPEC_CTRL is supported.  

Sure. Will make these changes.

>  
> Potentially harebrained alternative...
> 
> From an architectural SVM perspective, what are the rules for VMCB fields that
> don't exist (on the current hardware)?  E.g. are they reserved MBZ?  If not,
> does the SVM architecture guarantee that reserved fields will not be modified?
> I couldn't (quickly) find anything in the APM that explicitly states what
> happens with defined-but-not-existent fields.

I checked with our hardware design team about this. They dont want
software to make any assumptions about these fields.
thanks
Babu

> 
> Specifically in the context of this change, ignoring nested correctness, what
> would happen if KVM used the VMCB field even on CPUs without V_SPEC_CTRL?  Would
> this explode on VMRUN?  Risk silent corruption?  Just Work (TM)?
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cce0143a6f80..22a6a7c35d0a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1285,7 +1285,6 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>         u32 dummy;
>         u32 eax = 1;
> 
> -       svm->spec_ctrl = 0;
>         svm->virt_spec_ctrl = 0;
> 
>         if (!init_event) {
> @@ -2678,7 +2677,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                     !guest_has_spec_ctrl_msr(vcpu))
>                         return 1;
> 
> -               msr_info->data = svm->spec_ctrl;
> +               msr_info->data = svm->vmcb->save.spec_ctrl;
>                 break;
>         case MSR_AMD64_VIRT_SPEC_CTRL:
>                 if (!msr_info->host_initiated &&
> @@ -2779,7 +2778,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                 if (kvm_spec_ctrl_test_value(data))
>                         return 1;
> 
> -               svm->spec_ctrl = data;
> +               svm->vmcb->save.spec_ctrl = data;
>                 if (!data)
>                         break;
> 
> @@ -3791,7 +3790,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>          * is no need to worry about the conditional branch over the wrmsr
>          * being speculatively taken.
>          */
> -       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> +       x86_spec_ctrl_set_guest(svm->vmcb->save.spec_ctrl, svm->virt_spec_ctrl);
> 
>         svm_vcpu_enter_exit(vcpu, svm);
> 
> @@ -3811,12 +3810,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>          * save it.
>          */
>         if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> -               svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> +               svm->vmcb->save.spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> 
>         if (!sev_es_guest(svm->vcpu.kvm))
>                 reload_tss(vcpu);
> 
> -       x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
> +       x86_spec_ctrl_restore_host(svm->vmcb->save.spec_ctrl, svm->virt_spec_ctrl);
> 
>         if (!sev_es_guest(svm->vcpu.kvm)) {
>                 vcpu->arch.cr2 = svm->vmcb->save.cr2;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5431e6335e2e..a4f9417e3b7e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -137,7 +137,6 @@ struct vcpu_svm {
>                 u64 gs_base;
>         } host;
> 
> -       u64 spec_ctrl;
>         /*
>          * Contains guest-controlled bits of VIRT_SPEC_CTRL, which will be
>          * translated into the appropriate L2_CFG bits on the host to
> 
