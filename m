Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E40469DA54
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 06:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjBUFTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 00:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjBUFTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 00:19:16 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE912366E;
        Mon, 20 Feb 2023 21:19:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPiYHsvPPfprBXDe9yhVxyzp5ukhWpB0KhL6LTlJFL5+N1kIQCb1QUSiWgQNWu9tguRCxmtTrBxwHgbfUyKhEFV8qC2ZpFETURxXsoV/JhJaLvmLgTFRJeBLsUh02OmwK8L7wZdQ6b2RknBhyNNu75l7CEZ9ppQkjSJbqhP0AkMTBBwQ7R3reC0ERIozDwhUQ5QTIukb6/+Ooy2o0xuDfiM+5R7rNbD3SptPTUelJuT/MgpUX9Dbup/v6deoMOxn7CvDOc6cOir6tklQ2gyXSQ+m6Sh8AGyGBMWSQ+bsRhLD5GL11aAaVqIUHJ9oFexUnQRMlng8QDxA32NeVcpkww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FmVhBvx6j+i0Un6wZzf6dLjRFp6WmXBtvg+Pm0w6h8=;
 b=MOxd2TvNsrTYe5/bNfFF5Nz1iOTvoeEa4p61p9Vt6rsI4eh9ndhlRWizjY2htqx+7HN6HYUrnCRwAKtoICMqE1hVhvaLbuL5ONSFsuUCfObHeizD4lj97gljGZJVQvQrt41oUGqzHCD78vPiTHDTfup2F1nODnVPkYH7UpATyjZRDB/Gpueqo+caQCP5uKfzpIGKixYOvmMox0WiBbzJNqyFNXTMjCtdiJ/cmakOKIYr1RVvKWmIQhLN3G2w6QGpF32x0VfazKU1oBMveYojdyS2R4igsYqYeNtjjgwTXWM31AO81chn+JnEnsY0dz5nMJFt0/Nyj44ep/zodOc9cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FmVhBvx6j+i0Un6wZzf6dLjRFp6WmXBtvg+Pm0w6h8=;
 b=v/4LZIL++3Skj0vpd121lDXFJFGCa/6at8kf9LANFVAaf/brXUcQWMd7Sa7Zeh50xhjnFZbmeYxL4v7Lemq4pV9n2hM65ChqVB2LHjD8kr7zI0LjfV9Cn/ghXDlfht5Mqsac3M4dPl22mnIcIknnX9HkgxDzoiegUj4DyKH18BE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 IA1PR12MB6041.namprd12.prod.outlook.com (2603:10b6:208:3d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Tue, 21 Feb
 2023 05:19:12 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 05:19:12 +0000
Message-ID: <95c83ff6-0dee-d81d-6a3c-12de24cbbf32@amd.com>
Date:   Tue, 21 Feb 2023 16:19:00 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH kernel v4] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
 <20230203051459.1354589-1-aik@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230203051459.1354589-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0082.apcprd02.prod.outlook.com
 (2603:1096:4:90::22) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|IA1PR12MB6041:EE_
X-MS-Office365-Filtering-Correlation-Id: 6857e815-ae89-499c-0347-08db13cb2ac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8nmD5tBNaNGP8kGjUgOxZ3WweDLaApvL+b98sQVNE3EVdWsJv8Qv9VRj+mzWp9Th9iEu8nbtJ9DgbftZZtX/HHgk8ZwgGAkxG9YfN05OTErfu9bTnul6yNVd4lUmTTFTzoBHtrlDcdSuZZfVqYVZpqsyntC5s9zkzCih2SiKQwhLN9B/RsoEFgld4rsF+BasmmZZmfD53a4zU+nlVZYUtWny5u0aDVbSeIbJ4gj15c4bJcOd0EnVYNPkYg/61/4ccV8yMBLmkt47hwIXHFyQaSRb8GRYTjrgh5k4qV7WHWLef9qLuHNegSYAo+3ZNugDLUEWwitiqRENQE+d6PB8Oysq8YNOc/Drc6KIDsI5cTlLCZh692NCrGbqKIeU1s18GiqJkItXWoWKCNiAA5oerSQBtcHYdFKdOszNxYqdbK3UBBEQsW5dFIB2iZOfxMzj880MQAaF4R10iD4z76w7BkFD+r04PXtTxjZmfHgMQpIVwIqWRZhDHSwtcf4NOUigQUDSXkuESBRULnxbHk5wEUoNyW429hFJbGY9mtD+uhCeU0SgaAq9DZWNipDEM0AWEnMTIyKbUXBc6dmMQkW7xyBPz+zRxmU0Yl1Dd7qLno8UX2L7SiEWV0w9QFuBfxZ0Gl6+eaaSLLg212XPS0KYNVrJWRZzD/Trnj2cRxY8rVT+0HqGfKbXLDw7Pg48sDG7QCcASHt4/l1fOcBQuaW/TpF/8Eeoc0flyWU/c3VLQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199018)(6666004)(53546011)(26005)(186003)(6506007)(6512007)(6486002)(2906002)(31686004)(2616005)(31696002)(38100700002)(110136005)(7416002)(5660300002)(30864003)(8936002)(41300700001)(8676002)(4326008)(66946007)(66556008)(66476007)(478600001)(83380400001)(54906003)(36756003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tnc1VEIxQnlRUHI1c3NaVlhFRFFvUkNReWw4OXI5bXJGSEFkcmVlZHJCTFlx?=
 =?utf-8?B?TXkwdzBHeENDOGIyZGliTFkyaURQY0hqUDlqUmxmME9lbVp0b2s0OXR6V0ky?=
 =?utf-8?B?NmVVVTJGZC9EUEpjMDFaYmViZTVvcFpwbVZsV2hidXJNWFJNc2t2WnpGeDdV?=
 =?utf-8?B?aC9IajBGWFczNEpjUm5vQ3k2N0FsWWk1bmw0LzgydDVybFFVMXN1Zmd1OUJ4?=
 =?utf-8?B?S2ZyVVRiZTJCcFJaOFZFTnFYZkFXZk5SclNTdTVCci9FQmtEL3pZaHA2OFBw?=
 =?utf-8?B?V2J5anB0ajBreVdYTGRKOXJ4MlMzeVlFNnVpNmZpNE90cWg0RExFR2Q2RGZp?=
 =?utf-8?B?bVFDZmlKYmR1ZHByZkR6LzhoQmJPaDBiTURvd1liQ3FtWURCbTNXUitIdkhE?=
 =?utf-8?B?am90U2h2MW1JUTM4aDJsdUpwdzNlQ3ovVWV2SVUxaHNTSUduNmZtN3lKczZu?=
 =?utf-8?B?b1V2bkh3SUQ3UFlOR1FrcVF4QlZVekdFdXU3d3hFTzdFTFhpNGVZbk9ESmhx?=
 =?utf-8?B?eWY5QzkxNWRYVWowL3VVY1liYVBZZ3UrVTJraUdhMXpTOGcxMUdYZW5sVkEr?=
 =?utf-8?B?T0p6aElKT3NaRHI3cm1sTFlDZDRCelM3SUhFOWFFMW5ybTdmRGN5UlF6WVRZ?=
 =?utf-8?B?V2Exc0ZsVXZCbWNET1VQeUd1SFFJVjdIOVBMNXkzclMwaFp6dnJDVnR6SUZu?=
 =?utf-8?B?LzFNOG5yS1g4N1pKeVhxMFBBZHVyMnRPNVVxVGJiN2FEd0tIZ2gxWjJOaDBp?=
 =?utf-8?B?YTN5OVZBY1FMdVRoRURsUlM0UXZDYlplSDgraE1yM3ZvNmpoTFk5aDFIZVJH?=
 =?utf-8?B?VFRGNVdMSGRuOUljanVRZ1hLSkRtUEE0bUVJY2JMWGwrQmd2YWtaRVptOXRi?=
 =?utf-8?B?ZzEwWENXNnkzWVByK0Z3VDdnWU40dlJqNlpjZ2FUaTdFQk5RZ3R2cWJRUkl6?=
 =?utf-8?B?SDN0WmdzUEpLVS9hdVdnNTJIT2ovRTdYODJ4MzRMbktNNFJZY3lON1ZFUUtn?=
 =?utf-8?B?aFFQSGlrYVhrRkQ3ZFFYeHB1dHJwTDN6Z1JHc0Y5UHpLNlE4QVdld1hrdzhl?=
 =?utf-8?B?WWdyS2VyeDhGeWR0ZGdzREV0VzVaVzRSSXlRSUZUQWkxR1UrUWNpalVsZFZk?=
 =?utf-8?B?ckZBZERodlFBeWlSdnBlVmFoTk5tNHErMTlaZzZDWW4vTG1CbGRVUG1kV0da?=
 =?utf-8?B?d3dzek95d0xReXZ6aE1GR3pieW9mQWhGdFpjYlZTOXQ0SGRsdW5mMC9wTXE1?=
 =?utf-8?B?cW1iQzFjcGU2U0M5bHk0QlFrcnUrdUVocVBBTzNwbDkydHZNallFemIxZ3hI?=
 =?utf-8?B?eWhlSDZUMjVHUEZCSnk3MHdtQlNobjJiNm5wUlExeGhSUUJlZGVpZG1OUmR3?=
 =?utf-8?B?UXd6bnhjaXZiRFdFcWJjSlRZTDRFY2FzdmFzTkhUMkFML05teDUvTDhGNUpO?=
 =?utf-8?B?Vnh4NlVmT3BBQkdFeTNWZVpLTHdlQUZzU1hrLzlhNjRXOEdjYTA2NURLWDB3?=
 =?utf-8?B?M0xHa29ISytGem1VQlk5aGRWSnYvc205SmFRZ2s4YUNLRyt4Y0lScHo3MGlT?=
 =?utf-8?B?RTFjczZEeEtTY3J0enZLaUE2bzc2N0F4VWZvbTk4L2htZk9WN2ZyNkE0a2dX?=
 =?utf-8?B?eXlON1ZHd0lORVUxc1l6S3hvdjJMUTA0aE92REhtWE8rNjFpUUxkbk92WnB6?=
 =?utf-8?B?a2RSZVcrT0VscjFXWS94Vk1JbytmbWJsMmV0U2l5Q1RWOHBzdHRuS1l2MVM4?=
 =?utf-8?B?ZkxhS3d5Mko4bWU5cXFiQUZwdTBsdzhiQ2tRdXdhVzNJNitkSmg1Y3dnNTFV?=
 =?utf-8?B?dFg1Q3VSdHNTaGZDQU92MUFUOENtdkhIQXFyQW8wbnRoeWRJRXFRcEl5aXpW?=
 =?utf-8?B?R3pHNWFpQTkvSU41MmRoRFNNeEdZK1cyZlUzYlZMcUozQ3JhWUZtVWRXbGVJ?=
 =?utf-8?B?ckVtTDNlWkgzQjhNZm9naVZNM3FJckhqQWlSZDBEa0l1b0ljZFFSQy9NODBL?=
 =?utf-8?B?UmZ0NzZWb0N3VVEvdjMwa3A1OXFibitKOEhBRkFHVjltR1RpKzZIQlByZjhE?=
 =?utf-8?B?eUdyZlFhS1BOM3JGWExNNHBmaldaV3NhWDF1QWx5Z00yTzNiZzZUL29Sei82?=
 =?utf-8?Q?inT24+TmcRdCcWEVV3+uuXuc3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6857e815-ae89-499c-0347-08db13cb2ac0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 05:19:12.1135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PGKMoKx6285AA8DXfhIK26kbC9rWrZfy8tMqlMt5YwfSbH8PsNwbnBLCUD9U6BoN2VoPAYLil401T1jN2g4Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6041
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping? Thanks,

On 3/2/23 16:14, Alexey Kardashevskiy wrote:
> Prior to SEV-ES, KVM stored/loaded host debug registers upon switching
> to/from a VM. Changing those registers inside a running SEV VM
> triggered #VC exit to KVM.
> 
> SEV-ES added the encrypted state (ES) which uses an encrypted guest page
> for the VM state (VMSA). The hardware saves/restores certain registers on
> VMRUN/VMEXIT according to a swap type (A, B, C), see
> "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
> volume 2.
> 
> AMD Milan (Fam 19h) introduces support for the debug registers swapping.
> DR6 and DR7 are always swapped. DR[0-3] and DR[0-3]_ADDR_MASK are swapped
> a type B when SEV_FEATURES[5] ("DebugSwap") is set.
> 
> Enable DebugSwap in VMSA. But only do so if CPUID Fn80000021_EAX[0]
> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> supported by the SOC as otherwise a malicious SEV-ES guest can set up
> data breakpoints on the #VC IDT entry/stack and cause an infinite loop.
> 
> Eliminate DR7 and #DB intercepts as:
> - they are not needed when DebugSwap is supported;
> - #VC for these intercepts is most likely not supported anyway and
> kills the VM.
> Keep DR7 intercepted unless DebugSwap enabled to prevent the infinite #DB
> loop DoS.
> 
> While at this, move set_/clr_dr_intercepts to .c and move #DB intercept
> next to DR7 intercept.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> Changes:
> v4:
> * removed sev_es_is_debug_swap_enabled() helper
> * made sev_es_debug_swap_enabled (module param) static
> * set sev_feature early in sev_es_init_vmcb() and made intercepts
>    dependend on it vs. module param
> * move set_/clr_dr_intercepts to .c
> 
> v3:
> * rewrote the commit log again
> * rebased on tip/master to use recently defined X86_FEATURE_NO_NESTED_DATA_BP
> * s/boot_cpu_has/cpu_feature_enabled/
> 
> v2:
> * debug_swap moved from vcpu to module_param
> * rewrote commit log
> 
> ---
> Tested with:
> ===
> int x;
> int main(int argc, char *argv[])
> {
>          x = 1;
>          return 0;
> }
> ===
> gcc -g a.c
> rsync a.out ruby-954vm:~/
> ssh -t ruby-954vm 'gdb -ex "file a.out" -ex "watch x" -ex r'
> 
> where ruby-954vm is a VM.
> 
> With "/sys/module/kvm_amd/parameters/debug_swap = 0", gdb does not stop
> on the watchpoint, with "= 1" - gdb does.
> ---
>   arch/x86/include/asm/svm.h |  1 +
>   arch/x86/kvm/svm/svm.h     | 42 -------------
>   arch/x86/kvm/svm/sev.c     | 24 ++++++++
>   arch/x86/kvm/svm/svm.c     | 65 +++++++++++++++++++-
>   4 files changed, 87 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index cb1ee53ad3b1..665515c7edae 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -278,6 +278,7 @@ enum avic_ipi_failure_cause {
>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>   #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>   
> +#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>   
>   struct vmcb_seg {
>   	u16 selector;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4826e6cc611b..653fd09929df 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -389,48 +389,6 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
>   	return test_bit(bit, (unsigned long *)&control->intercepts);
>   }
>   
> -static inline void set_dr_intercepts(struct vcpu_svm *svm)
> -{
> -	struct vmcb *vmcb = svm->vmcb01.ptr;
> -
> -	if (!sev_es_guest(svm->vcpu.kvm)) {
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
> -	}
> -
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> -
> -	recalc_intercepts(svm);
> -}
> -
> -static inline void clr_dr_intercepts(struct vcpu_svm *svm)
> -{
> -	struct vmcb *vmcb = svm->vmcb01.ptr;
> -
> -	vmcb->control.intercepts[INTERCEPT_DR] = 0;
> -
> -	/* DR7 access must remain intercepted for an SEV-ES guest */
> -	if (sev_es_guest(svm->vcpu.kvm)) {
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> -		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> -	}
> -
> -	recalc_intercepts(svm);
> -}
> -
>   static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
>   {
>   	struct vmcb *vmcb = svm->vmcb01.ptr;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 86d6897f4806..af775410c5eb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -21,6 +21,7 @@
>   #include <asm/pkru.h>
>   #include <asm/trapnr.h>
>   #include <asm/fpu/xcr.h>
> +#include <asm/debugreg.h>
>   
>   #include "mmu.h"
>   #include "x86.h"
> @@ -52,9 +53,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
>   /* enable/disable SEV-ES support */
>   static bool sev_es_enabled = true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +
> +/* enable/disable SEV-ES DebugSwap support */
> +static bool sev_es_debug_swap_enabled = true;
> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
>   #else
>   #define sev_enabled false
>   #define sev_es_enabled false
> +#define sev_es_debug_swap false
>   #endif /* CONFIG_KVM_AMD_SEV */
>   
>   static u8 sev_enc_bit;
> @@ -2249,6 +2255,8 @@ void __init sev_hardware_setup(void)
>   out:
>   	sev_enabled = sev_supported;
>   	sev_es_enabled = sev_es_supported;
> +	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
> +		sev_es_debug_swap_enabled = false;
>   #endif
>   }
>   
> @@ -2940,6 +2948,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>   static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct sev_es_save_area *save = svm->sev_es.vmsa;
>   
>   	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
>   	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> @@ -2988,6 +2997,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
>   			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>   	}
> +
> +	if (sev_es_debug_swap_enabled)
> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>   }
>   
>   void sev_init_vmcb(struct vcpu_svm *svm)
> @@ -3027,6 +3039,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>   
>   	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>   	hostsa->xss = host_xss;
> +
> +	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
> +	if (sev_es_debug_swap_enabled) {
> +		hostsa->dr0 = native_get_debugreg(0);
> +		hostsa->dr1 = native_get_debugreg(1);
> +		hostsa->dr2 = native_get_debugreg(2);
> +		hostsa->dr3 = native_get_debugreg(3);
> +		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
> +		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
> +		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
> +		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
> +	}
>   }
>   
>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 60c7c880266b..f8e222bee22a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -671,6 +671,65 @@ static int svm_cpu_init(int cpu)
>   
>   }
>   
> +static void set_dr_intercepts(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
> +	bool intercept;
> +
> +	if (!sev_es_guest(svm->vcpu.kvm)) {
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
> +	}
> +
> +	if (sev_es_guest(svm->vcpu.kvm)) {
> +		struct sev_es_save_area *save = svm->sev_es.vmsa;
> +
> +		intercept = !(save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP);
> +	} else {
> +		intercept = true;
> +	}
> +
> +	if (intercept) {
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +		set_exception_intercept(svm, DB_VECTOR);
> +	}
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static void clr_dr_intercepts(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
> +	struct sev_es_save_area *save = svm->sev_es.vmsa;
> +
> +	vmcb->control.intercepts[INTERCEPT_DR] = 0;
> +
> +	/*
> +	 * DR7 access must remain intercepted for an SEV-ES guest unless DebugSwap
> +	 * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM writing to DR7
> +	 * from the #DB handler may trigger infinite loop of #DB's.
> +	 */
> +	if (sev_es_guest(svm->vcpu.kvm) && (save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP)) {
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +	}
> +
> +	recalc_intercepts(svm);
> +}
> +
>   static int direct_access_msr_slot(u32 msr)
>   {
>   	u32 i;
> @@ -1184,13 +1243,11 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>   	if (!kvm_vcpu_apicv_active(vcpu))
>   		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
>   
> -	set_dr_intercepts(svm);
> -
>   	set_exception_intercept(svm, PF_VECTOR);
>   	set_exception_intercept(svm, UD_VECTOR);
>   	set_exception_intercept(svm, MC_VECTOR);
>   	set_exception_intercept(svm, AC_VECTOR);
> -	set_exception_intercept(svm, DB_VECTOR);
> +
>   	/*
>   	 * Guest access to VMware backdoor ports could legitimately
>   	 * trigger #GP because of TSS I/O permission bitmap.
> @@ -1308,6 +1365,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>   	if (sev_guest(vcpu->kvm))
>   		sev_init_vmcb(svm);
>   
> +	set_dr_intercepts(svm);
> +
>   	svm_hv_init_vmcb(vmcb);
>   	init_vmcb_after_set_cpuid(vcpu);
>   

-- 
Alexey
