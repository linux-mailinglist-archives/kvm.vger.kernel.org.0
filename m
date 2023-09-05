Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0D779263A
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbjIEQEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354838AbjIEOy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 10:54:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7F7113;
        Tue,  5 Sep 2023 07:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVSnAXWFHBDNtK+rxMeJDC7013LWLldAROteX8Ze9chxSr4DIdHZJGLpZ53Yul6OAk4IwhSslCC+ec+1nAxfMSpVqK9I8T02ZW/ci4Gz95YYhB950fmPNvyIHlxNFKkJc+ix4HQ6n8PImK9+q3mMqGchYBR+VloLT/yWpgg4PHUiIKusWQUOnTZmH6lfMbzsbU9/3X0aaS7m84lxK23JdPhnovOANFupIkBv0KkIZOFm0YM4i9ValKjAyp8/1qiJjqFPOlP4AyJz2PO6iQnA3IrQYabj8disa16a5ononVBnC8JmqfQFYGy7pHIzl2m9QUv+IFSFTRPgN3395QF/Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vc2/Ryvggu9lzX0DGkqDlM6IZKwbqOq7wT9izvp74ts=;
 b=AZKqfcRuH1ofkEmEFayU7j4UM4cbb9mjyFaMWKhOcrIk8pHFRtWxUAZuUFt4/xty0ki7PTpVHb6AoqYKbJt/sc1Tcemc+lqL4s/J6B/ZQhiulIzQ6o6M3zvTMrnsDqTpXq/bc7qtiyuGCJaKBeE5J8+g6XKToqF5wbIVojje/ZiqbOKIvL5eoPvNti1Oe+eCVWqeVROCMOzY2Oa3PysAqpQ3m/3OWDex8Fnov5w86Y6naw1Mlv5nL3Y2DZeUja4Lxs7uVmjmWUApWaLz52/xnUpTwtYRUMzOuu20twlivaRS5sZS7iPksFXYnZqGumrj7vSKjI97/Snxx4xckNWuCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc2/Ryvggu9lzX0DGkqDlM6IZKwbqOq7wT9izvp74ts=;
 b=bdQXyzXSWFoSsxFVGvflH5eGI9apTMwWSrz9bAHxeQW6ofVGbjzV6HU/cq8CzimBXS5EJOuFxfEpBVLN0cWAQZJ8DWhAIui80b3JgAvOsi42KMkQWwdFO3sLyjyHbZsbxf7Z4X+jdJTnnQNNsFnkOqt6tnmwmvwqMBwadH+BMSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW4PR12MB5626.namprd12.prod.outlook.com (2603:10b6:303:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 14:54:49 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 14:54:49 +0000
Message-ID: <f792b2e1-381a-d37d-d862-427838de1e4f@amd.com>
Date:   Tue, 5 Sep 2023 09:54:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 08/13] perf/x86/amd: Add framework to save/restore host
 IBS state
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
        seanjc@google.com
Cc:     linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
        x86@kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        bp@alien8.de, santosh.shukla@amd.com, ravi.bangoria@amd.com,
        nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-9-manali.shukla@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230904095347.14994-9-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0182.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::20) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW4PR12MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 440aa950-ccce-4aec-01b2-08dbae200d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fF9L5ZhWWJuDMsVV7ZgP3TBMeLmty7pamy7hu4qWIYDPXSxRvkdwQsafZmBTXwK+sRHypRWOtcfz1mkwbIvHMtZpsZQd7+m2IS4FwmqetUc97vLddJXrHgWnI19lrtOnf8vocLwcCo96PUcsmMPi8zzdiySPb8fYnjLHo6qzHploRHXBNuK2f5+x8jqxMIaObbZVKia1jRId6KeKwg8E2VIuVV9rGyw5hDdlZecKi6ugoAoAlx4DPNHLzRc9Op5B7RQRNTZKJ8iSKUGVWIg1FSzQEHkrzyWVhu13w4CMrVUq/BQty3ZwRUilt1QrkT1of50UXJ+0PeTf36hEnedfgaMnuwhlQjxmHx8YnwAvc8T6KHVKkQHFudQXAmNcMnB3YQVz8PfHT49Q72Bn8NDTn0S8Ra4POuxZpoMxTZc3mB3uLxDVHBVHj3l3Nq4/Rx6bJl2av8z0d9deNj567bBgSaTkb93x/9r3SdAqYEXH72MCeTB8Dgk/arQ0gfAzOd3Mc3r5VTCaHXcK1Fb/Uj18BkQJl14YqYzdzbWcpLdl0DnC8In2Y9399IJ7YyC5rgww5tVZHp4YSdq6uyICm4UvP+qSHzDXzIAyjFQ+R9q8Ekv/gixzNXZ7Ki3MJXEd62uRgQe/H5mHS4FoeLmComwkBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199024)(1800799009)(186009)(5660300002)(316002)(2906002)(66476007)(66556008)(36756003)(66946007)(8676002)(4326008)(8936002)(31686004)(41300700001)(53546011)(6486002)(6506007)(26005)(6512007)(38100700002)(478600001)(966005)(2616005)(83380400001)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDM0dUp6RlNSc1NiZllwVGNnUG9tMVBUbWFHZ2MzVXRhWVBacStTN0kybnQy?=
 =?utf-8?B?WWltemVMRHo0aFR0eHVRVkZLMUlLMnNZbHhDKzEyZ2xZTjI3Q3ZGY1BPK3BY?=
 =?utf-8?B?RXgvb25TU2JUWjFjSVJvQXlBRmI2ZS9XNWF2MzhvdTk4VjVFUTVhZTRJK2Qx?=
 =?utf-8?B?cGxGTkFIZmZqbkdoTXA4dEtOZHBzV0RNZVJVenl6WUpQRE52NHJSdFVWN2Vq?=
 =?utf-8?B?anY5YlZQaDlDUXViTHplT0JuV1haTTk0dVJoOTJqTE9sMnBXeGdrcURLREdI?=
 =?utf-8?B?bk41RTQ5dVphenVtWjJTQTRPTk5jbGpDWVR1YUZveFliYWE5K25BMzc1TTBF?=
 =?utf-8?B?OEw5b2VYMGw2UmpiN2Q4MXM4WDBXZWVxKzFtRGpYdEphUGtPbHJjMDVmNmJx?=
 =?utf-8?B?b05lZ21XeUEyNWJCVmRaRTFFMVVkeEYrbHNycUlEL0xkemZHUmJDUmF2alBZ?=
 =?utf-8?B?cEo5RUUweGowMVl0bk9pVitFWjFXMmVGbDhRVElyaGRGMkZobXFhc3hJTVpM?=
 =?utf-8?B?cUliY1RLS0ZKSjA5bG5uSmFJc1FETHlpdVhlTlhPMG15dkV3Y2xNdDBtRDZo?=
 =?utf-8?B?TnZrdHdFMU83QUpoSWZaSFJlM3IvcnZnSUgzZ2pCRnRPeGlBcVdDRG1Xc0Fq?=
 =?utf-8?B?S1hqaVhyRE81UzZqd04xc0NscXVtcHplaER1UzJpKzVIMkFmVitneldVYzlv?=
 =?utf-8?B?YkJyK3dySC9uR3hhUkNaNWoyUGU0Y2ZRMzhLdUpGUVNyaVdaV3YwQmxPK01P?=
 =?utf-8?B?RG5nNVF5TERscWhHVlR5S0hTcjIva0hBQm9KaEpqRHZLemRVd3VHQnU0WFdP?=
 =?utf-8?B?endROS9tbzhxVFhhZUJkS2dKbHpPa1RNTmxTSUx3Rkt5ZTV1SlpOdlNiTk95?=
 =?utf-8?B?czF3YWdsL2pSVDZUbjM2bU9hTUp1N1RubHlKVFZOcFd6bEtrWnVVbGZodVBL?=
 =?utf-8?B?N2w3RDdSRk54MXV2MElUcm5ubTBjZWpQSDNMSmhRK3RiNjluVnFvWmVTQzNL?=
 =?utf-8?B?MFhDUE1CdnRGZVhERkNHSTNuL1Ava1cvZVQ1andlN1d3d0s2Q1p2emUrRXp2?=
 =?utf-8?B?N1lpcloxSWprTkZPOUswMGJXY3d0aUE5bHVvZGtDbzMrb20vMG8rekVPZ3ZQ?=
 =?utf-8?B?dXlBNitHellsTHNLczR3OEZPTDBGV1QwdGdNcFBDWk5VRU94ZnBicHZZdFpQ?=
 =?utf-8?B?am1WL2JvSi91cUtuQURYVXJUTVlQSTkvYWdkK2FSVEIxcFA5UmR5alE5QVVw?=
 =?utf-8?B?cjV0TVFFQlBpb3pYTXJ3d1V4TUd1aThnRE5qbHZtdlpzUlVieUJQTEVJQ2k5?=
 =?utf-8?B?V2pvK1N1R1QzNDIxOFpEVlVSa0lNYUNtY3oxYldoay92MTNLN2owazFxemNK?=
 =?utf-8?B?NU54L1BucXoyaXdFOE1UdHhvVWFSdWtnUGE3N0E0MnQ3T3N5RkEzWGhPR1RN?=
 =?utf-8?B?K3pHQ0FlcEY3eGh1bkhiVWJkZ3RDUUIxZFlYc0pmdytjQzNpSC9KWDlYR3d3?=
 =?utf-8?B?bU01ZVE5MHVxMEFPdmRTelJuZ0hJWm85Sks1aThzRDdqN1U2UE1RZE1OVHEx?=
 =?utf-8?B?aC9yZmp4dGczdmJ2bTZiQzFiOUpuenY0NHZaSUZWb2xtdTZCNHlrNFRKaFY5?=
 =?utf-8?B?TVJtWjBWcmRJUHoyMWRQSUVxeUFMQkZ2K2VFc2hxUkM1SEsxZGQrTS9RQkxV?=
 =?utf-8?B?dE9EMnNHMVVVbngwUUk1NDBETDJxTlBPQjFwT2oyZGR0WGdEL01zUDhlTnJ5?=
 =?utf-8?B?Yi9HVjlTWDFMNE9pc1krei90b0hsNzNvMDBmdzBVY1JPZ3gzZHlJaEd5YVBp?=
 =?utf-8?B?UldpdVNiV0tLODlRNjREMFV6b2hPK1BNU3pEQ1hDVlJ5WEYzUTQ2RjBOdHRj?=
 =?utf-8?B?Q3ZubzhHMVVUV09xYmtzTjFtb3U1Sk9PWjd2RzA1OENxYisrckNsWmpMVTFz?=
 =?utf-8?B?YndkVk8vQnFEVTBxTzgvUzkwQTNDVWhTSDVFL0ZzeVlRdUpIa0RWWWkzV0J3?=
 =?utf-8?B?aFBhQzdHZk5ubFpuc3hOQS9Hbm5BM3hUMHZ6U3R5ZUdibEV4ZEtFQzdBUGdH?=
 =?utf-8?B?Y1krMWpxK1FibklyaktiN1BGOVBOWXF0UFZpdmIvTDdndG8rbzc0c3hTV2tZ?=
 =?utf-8?Q?yaC/85nAYcgtVxx7MOgOta76H?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440aa950-ccce-4aec-01b2-08dbae200d9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 14:54:49.5701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dG7AJWNidnh0Ycsob8aGELPf31MKTnPYaTjJRd82oi2iAmMVb4oiPAlFdglV7FxbqYl5vhSS7YRW78jyjJ+wKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5626
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 04:53, Manali Shukla wrote:
> Since IBS registers falls under swap type C [1], only the guest state

s/falls/fall/

> is saved and restored automatically by the hardware. Host state needs
> to be saved and restored manually by the hypervisor. Note that, saving
> and restoring of host IBS state happens only when IBS is active on
> host to avoid unnecessary rdmsrs/wrmsrs.
> 
> Also, hypervisor needs to disable host IBS before VMRUN and re-enable
> it after VMEXIT [2]. However, disabling and enabling of IBS leads to
> subtle races between software and hardware since IBS_*_CTL registers
> contain both control and result bits in the same MSR.
> 
> Consider the following scenario, hypervisor reads IBS control MSR and
> finds enable=1 (control bit) and valid=0 (result bit). While kernel is
> clearing enable bit in its local copy, IBS hardware sets valid bit to
> 1 in the MSR. Software, who is unaware of the change done by IBS
> hardware, overwrites IBS MSR with enable=0 and valid=0. Note that,
> this situation occurs while NMIs are disabled. So CPU will receive IBS
> NMI only after STGI. However, the IBS driver won't handle NMI because
> of the valid bit being 0. Since the real source of NMI was IBS, nobody
> else will also handle it which will result in the unknown NMIs.
> 
> Handle the above mentioned race by keeping track of different actions
> performed by KVM on IBS:
> 
>    WINDOW_START: After CLGI and before VMRUN. KVM informs IBS driver
>                  about its intention to enable IBS for the guest. Thus
> 		IBS should be disabled on host and IBS host register
> 		state should be saved.
>    WINDOW_STOPPING: After VMEXIT and before STGI. KVM informs IBS driver
>                  that it's done using IBS inside the guest and thus host
> 		IBS state should be restored followed by re-enabling
> 		IBS for host.
>    WINDOW_STOPPED: After STGI. CPU will receive any pending NMI if it
>                  was raised between CLGI and STGI. NMI will be marked
> 		as handled by IBS driver if WINDOW_STOPPED action is
>                  _not performed, valid bit is _not_ set and a valid
>                  IBS event exists. However, IBS sample won't be generated.
> 
> [1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
>       AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
>       of VMCB, Table B-3 Swap Types.
> 
> [2]: https://bugzilla.kernel.org/attachment.cgi?id=304653
>       AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
>       Instruction-Based Sampling Virtualization.
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>   arch/x86/events/amd/Makefile      |   2 +-
>   arch/x86/events/amd/ibs.c         |  23 +++++++
>   arch/x86/events/amd/vibs.c        | 101 ++++++++++++++++++++++++++++++
>   arch/x86/include/asm/perf_event.h |  27 ++++++++
>   4 files changed, 152 insertions(+), 1 deletion(-)
>   create mode 100644 arch/x86/events/amd/vibs.c
> 
> diff --git a/arch/x86/events/amd/Makefile b/arch/x86/events/amd/Makefile
> index 527d947eb76b..13c2980db9a7 100644
> --- a/arch/x86/events/amd/Makefile
> +++ b/arch/x86/events/amd/Makefile
> @@ -2,7 +2,7 @@
>   obj-$(CONFIG_CPU_SUP_AMD)		+= core.o lbr.o
>   obj-$(CONFIG_PERF_EVENTS_AMD_BRS)	+= brs.o
>   obj-$(CONFIG_PERF_EVENTS_AMD_POWER)	+= power.o
> -obj-$(CONFIG_X86_LOCAL_APIC)		+= ibs.o
> +obj-$(CONFIG_X86_LOCAL_APIC)		+= ibs.o vibs.o
>   obj-$(CONFIG_PERF_EVENTS_AMD_UNCORE)	+= amd-uncore.o
>   amd-uncore-objs				:= uncore.o
>   ifdef CONFIG_AMD_IOMMU
> diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
> index 6911c5399d02..359464f2910d 100644
> --- a/arch/x86/events/amd/ibs.c
> +++ b/arch/x86/events/amd/ibs.c
> @@ -1039,6 +1039,16 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
>   		 */
>   		if (test_and_clear_bit(IBS_STOPPED, pcpu->state))
>   			return 1;
> +		/*
> +		 * Catch NMIs generated in an active IBS window: Incoming NMIs
> +		 * from an active IBS window might have the VALID bit cleared
> +		 * when it is supposed to be set due to a race. The reason for
> +		 * the race is ENABLE and VALID bits for MSR_AMD64_IBSFETCHCTL
> +		 * and MSR_AMD64_IBSOPCTL being in their same respective MSRs.
> +		 * Ignore all such NMIs and treat them as handled.
> +		 */
> +		if (amd_vibs_ignore_nmi())
> +			return 1;
>   
>   		return 0;
>   	}
> @@ -1542,3 +1552,16 @@ static __init int amd_ibs_init(void)
>   
>   /* Since we need the pci subsystem to init ibs we can't do this earlier: */
>   device_initcall(amd_ibs_init);
> +
> +static inline bool get_ibs_state(struct perf_ibs *perf_ibs)
> +{
> +	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
> +
> +	return test_bit(IBS_STARTED, pcpu->state);
> +}
> +
> +bool is_amd_ibs_started(void)
> +{
> +	return get_ibs_state(&perf_ibs_fetch) || get_ibs_state(&perf_ibs_op);
> +}
> +EXPORT_SYMBOL_GPL(is_amd_ibs_started);

If this is only used by the IBS support, it shouldn't have an 
EXPORT_SYMBOL_GPL.

> diff --git a/arch/x86/events/amd/vibs.c b/arch/x86/events/amd/vibs.c
> new file mode 100644
> index 000000000000..273a60f1cb7f
> --- /dev/null
> +++ b/arch/x86/events/amd/vibs.c
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  Virtualized Performance events - AMD VIBS
> + *
> + *  Copyright (C) 2023 Advanced Micro Devices, Inc., Manali Shukla
> + *
> + *  For licencing details see kernel-base/COPYING
> + */
> +
> +#include <linux/perf_event.h>
> +
> +DEFINE_PER_CPU(bool, vibs_window_active);
> +
> +static bool amd_disable_ibs_fetch(u64 *ibs_fetch_ctl)
> +{
> +	*ibs_fetch_ctl = __rdmsr(MSR_AMD64_IBSFETCHCTL);
> +	if (!(*ibs_fetch_ctl & IBS_FETCH_ENABLE))
> +		return false;
> +
> +	native_wrmsrl(MSR_AMD64_IBSFETCHCTL, *ibs_fetch_ctl & ~IBS_FETCH_ENABLE);
> +
> +	return true;
> +}
> +
> +static u64 amd_disable_ibs_op(u64 *ibs_op_ctl)
> +{
> +	*ibs_op_ctl = __rdmsr(MSR_AMD64_IBSOPCTL);
> +	if (!(*ibs_op_ctl & IBS_OP_ENABLE))
> +		return false;
> +
> +	native_wrmsrl(MSR_AMD64_IBSOPCTL, *ibs_op_ctl & ~IBS_OP_ENABLE);
> +
> +	return true;
> +}
> +
> +static void amd_restore_ibs_fetch(u64 ibs_fetch_ctl)
> +{
> +	native_wrmsrl(MSR_AMD64_IBSFETCHCTL, ibs_fetch_ctl);
> +}
> +
> +static void amd_restore_ibs_op(u64 ibs_op_ctl)
> +{
> +	native_wrmsrl(MSR_AMD64_IBSOPCTL, ibs_op_ctl);
> +}
> +
> +bool amd_vibs_ignore_nmi(void)
> +{
> +	return __this_cpu_read(vibs_window_active);
> +}
> +EXPORT_SYMBOL_GPL(amd_vibs_ignore_nmi);

If this is only used by the IBS support, it shouldn't have an 
EXPORT_SYMBOL_GPL.

> +
> +bool amd_vibs_window(enum amd_vibs_window_state state, u64 *f_ctl,
> +		     u64 *o_ctl)
> +{
> +	bool f_active, o_active;
> +
> +	switch (state) {
> +	case WINDOW_START:
> +		if (!f_ctl || !o_ctl)
> +			return false;
> +
> +		if (!is_amd_ibs_started())
> +			return false;
> +
> +		f_active = amd_disable_ibs_fetch(f_ctl);
> +		o_active = amd_disable_ibs_op(o_ctl);
> +		__this_cpu_write(vibs_window_active, (f_active || o_active));
> +		break;
> +
> +	case WINDOW_STOPPING:
> +		if (!f_ctl || !o_ctl)
> +			return false;
> +
> +		if (__this_cpu_read(vibs_window_active))

Shouldn't this be if (!__this_cpu_read(vibs_window_active)) ?

> +			return false;
> +
> +		if (*f_ctl & IBS_FETCH_ENABLE)
> +			amd_restore_ibs_fetch(*f_ctl);
> +		if (*o_ctl & IBS_OP_ENABLE)
> +			amd_restore_ibs_op(*o_ctl);

Nit, these if checks could go into the restore functions to make this look 
a bit cleaner, but that's just from my point of view.

> +
> +		break;
> +
> +	case WINDOW_STOPPED:
> +		/*
> +		 * This state is executed right after STGI (which is executed
> +		 * after VMEXIT).  By this time, host IBS states are already
> +		 * restored in WINDOW_STOPPING state, so f_ctl and o_ctl will
> +		 * be passed as NULL for this state.
> +		 */
> +		if (__this_cpu_read(vibs_window_active))
> +			__this_cpu_write(vibs_window_active, false);

Any reason not to just issue __this_cpu_write(vibs_window_active, false) 
without the if check?

> +		break;
> +
> +	default:
> +		return false;
> +	}
> +
> +	return __this_cpu_read(vibs_window_active);

You could just issue a return true or return false (depending on the case) 
instead of having the break statements, e.g.:

For WINDOW_START replace break with return (f_active || o_active)
For WINDOW_STOPPING replace break with return true
For WINDOW_STOPPED replace break with return false

> +}
> +EXPORT_SYMBOL_GPL(amd_vibs_window);
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 85a9fd5a3ec3..b87c235e0e1e 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -486,6 +486,12 @@ struct pebs_xmm {
>   #define IBS_OP_MAX_CNT_EXT_MASK	(0x7FULL<<20)	/* separate upper 7 bits */
>   #define IBS_RIP_INVALID		(1ULL<<38)
>   
> +enum amd_vibs_window_state {
> +	WINDOW_START = 0,
> +	WINDOW_STOPPING,
> +	WINDOW_STOPPED,
> +};
> +
>   #ifdef CONFIG_X86_LOCAL_APIC
>   extern u32 get_ibs_caps(void);
>   extern int forward_event_to_ibs(struct perf_event *event);
> @@ -584,6 +590,27 @@ static inline void intel_pt_handle_vmx(int on)
>   }
>   #endif
>   
> +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_CPU_SUP_AMD)
> +extern bool amd_vibs_window(enum amd_vibs_window_state state, u64 *vibs_fetch_ctl,
> +			    u64 *vibs_op_ctl);
> +extern bool is_amd_ibs_started(void);
> +extern bool amd_vibs_ignore_nmi(void);

And if the two above functions aren't EXPORT_SYMBOL_GPL, then they could 
go somewhere else instead of here.

Thanks,
Tom

> +#else
> +static inline bool amd_vibs_window(enum amd_vibs_window_state state, u64 *vibs_fetch_ctl,
> +				  u64 *vibs_op_ctl)
> +{
> +	return false;
> +}
> +static inline bool is_amd_ibs_started(void)
> +{
> +	return false;
> +}
> +static inline bool amd_vibs_ignore_nmi(void)
> +{
> +	return false;
> +}
> +#endif
> +
>   #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
>    extern void amd_pmu_enable_virt(void);
>    extern void amd_pmu_disable_virt(void);
