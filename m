Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCCC79337F
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 03:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjIFBwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 21:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjIFBwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 21:52:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EACFCDC;
        Tue,  5 Sep 2023 18:51:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNM8MiJkQu/SfkQ8cTW34qCxlM9PLnnIupEwW/Lbi0HXPw2K2tBptunSCxhJPQmpK1sIHXDzObRN7dYgl7HzJazfFtYuSxLN0rHMlU5ldOUBT47J2YhA34p8s2x4Qab96trO89vzSsCqRjT93yTRJu/bKzV6dbbtgoHdCa/nK7RplQ0z4OfPCHXRRNWdYvsyjxqsYdXUxEx7P4SgIUS+3xJCunAVRH8XGTApMjKbNAL8HBm1L8G/E/UeGnPp4zRycva5Gndy5vD2lV+uC3w+WSTzvfViXKcAP2Lf00IdxHpUa4DLGDoWXperGWUAqErULNoFFXHSy8qe5RueVAOu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMHk+C8+oZNf+hVhZh11n/Jg6A04lJi0gjbeMEM6JUQ=;
 b=lNgoSZMrwZOy8Vh/EUjrGjzicQD8YHjRNpulk/x48RCezpfuad7YioxmY9Qbf0IUp7Yf/MbZ6Z/EkZiTGb2093SW3EbaSbC/JQB91ErNivil0tFe5DRDkJ/cyW1pkamO3yH0nJMpPrDpV37BURJCP58EJlfv62SOSlVw/lEqcOx9JD07d+WhPyMFO8eWtuxMKiLmmwO/TtheJNh0FrOFTcHOu28EHm7HVM4J4o4gPrxuK6tjmXtJQ7LGzfs+fpBE4VaxfpwfmrxAheBxj8+Z4q1rZypIY8SaMY82n4e7nHDPcsW0k9zh/CCLui91+kvrMGU/I93k6gcxPUysVpiczw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMHk+C8+oZNf+hVhZh11n/Jg6A04lJi0gjbeMEM6JUQ=;
 b=PbpPxD4tEUlczjnYcsXA7WBLxdbTMTtQoEO6EeyKnxPwla5ZRDnkGwB2nDUbyOfvuRAo4vgcJeoG519bbj+KfnzSukTGJLUXqlvklWW/T4jVdAf/J6FFw2qYbg2tk6upy11O5XIOR1mhyaBYiTW046E77eWFRGC8lblyy4aJYT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 IA1PR12MB7494.namprd12.prod.outlook.com (2603:10b6:208:41a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 01:51:55 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::63b5:d79f:f3c3:c319]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::63b5:d79f:f3c3:c319%6]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 01:51:55 +0000
Message-ID: <e05c663d-553a-bef6-6932-ccc62e3172f8@amd.com>
Date:   Wed, 6 Sep 2023 11:51:44 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH 09/13] KVM: SVM: add support for IBS virtualization for
 non SEV-ES guests
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
        seanjc@google.com
Cc:     linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
        x86@kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        bp@alien8.de, santosh.shukla@amd.com, ravi.bangoria@amd.com,
        thomas.lendacky@amd.com, nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-10-manali.shukla@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230904095347.14994-10-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0157.ausprd01.prod.outlook.com
 (2603:10c6:10:d::25) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|IA1PR12MB7494:EE_
X-MS-Office365-Filtering-Correlation-Id: 8776e047-f990-44fb-0ee0-08dbae7bd8c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nDPvKCI//JpNZsF/foRGvnhjExXmUNmNBwKRaf5DTsVAoYYwmI4KrD77hePvsT6ionq/nJz0LX8u0iqP1/BC34sKvSaWscGxquh+vc34U7a416wfs8Pb7+9xhcUA7NG0u2HIou7O61PvviDSKBGNy0DabUBLVGXyx+MA0/vhthVs09+bc2xBd71OQe4Bq66hLH8MHK7D9P5EKsv1/XB3pMiwGW2TTPkdQJRGltgX/qETmUgAM4OKov386b5UkNBGEKKin+McWTqDCfXgDowsGaZIko2Vc+7VQSh5uq+lh+Vyyqj0f5CDePrmRtQtJ2r6Sh9KdCbKLVrG3hNsQY9DOxiD7gifCEf/f4J/edvpxg+jEiNVeKXVAFgZiriNo+Gl109Sk7jFQmdbemsM6d0/WZ1QBzI0Q8Efjf0tojjE2oOk9eScSG01mHGivtaGAgN9biYtkhWA1GwGo7ApM77J+/I0zPaFGtYCJmF3WH38/wkhGn4CpfqAKoLcV96EOABH3Ni8fhaFeWnHKPIUaruCWHvSTf/qx4uIDsYK3kM+uvgJxMrnefNyiaVMKgeaFMO3WaePmsRmZM8cDr08L6rm7Xmaj9vz+tBYkxGOarnKt7S7eDj+nYaJc9rXq1nxQLV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199024)(1800799009)(186009)(36756003)(53546011)(6486002)(6506007)(478600001)(6666004)(2616005)(6512007)(41300700001)(66556008)(316002)(966005)(66946007)(38100700002)(66476007)(30864003)(31686004)(83380400001)(31696002)(26005)(2906002)(5660300002)(8676002)(8936002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWZiMURaeFg3enB5akh5cFJsQUdDS2F6endBTGxuTm5BeEVCV0FSOHZWRXpU?=
 =?utf-8?B?cEkzVjMvS3FpVXdMVjMvNzBHbS9scGg5UFpkMnRaMWRlcStGdjZQRHo0cXNL?=
 =?utf-8?B?VlRWNEtaMTVCY0NyOFBLckd6TXZaaTFabFg5Tm1jcFpkS1ZGME1lNW05TUNw?=
 =?utf-8?B?eE5tRXZmQUY2Y1FncUhNdks2NE0xUnpLaExoQmsxYnUyQ0RxcXVlcTk2SDVB?=
 =?utf-8?B?T0ZVcERnbXlCbVdPdTBQc2JtS2IwZHNxUVh4VWdobzVSaEh2bE9YTUJaeHZn?=
 =?utf-8?B?ZDJ1Y0IrUnZJYUcrM1BkQW5YVUdQS29XbVhFbFY1T2NCR29SKzR2RGdJQW9S?=
 =?utf-8?B?UXl0RjVxcEYrWk1JRXVRc21TQjUzMlVjSVN3dUtXVnI5QzJqNnRaSm5hbG5G?=
 =?utf-8?B?Q3JhalUwT2E3MjNLaXZyaVNPc05paytYZzhEWmo0K2hhY0RENEFmRkpEL0E2?=
 =?utf-8?B?TzRkMFU0aE5JV3lMeHNoa2pDdy9RZHNIeTF0TFFMZHFkRk0xYkFneURUc3Fy?=
 =?utf-8?B?SVZHRks0Vmx6dm5kTE5ESTZwZG5Jam5FRDVwQmlmblJTVlE3cUJEVzl6SFp0?=
 =?utf-8?B?L0FROWsrakNrZEF4cE9iNVRXcU1wK3Q2MXNabzlmNE1hWEovb3dDRmg4aGp2?=
 =?utf-8?B?KzRwK0plQlVFMXJ1WGpRdExNUlh1TVJNQ2xqZUJReWVFdWNtUlNOQllyZnFX?=
 =?utf-8?B?T3RBVlRWMmNtWlM2Y2RUSGlDMFNvZU9IeGxvL3gzQWhoUCt1bFprWXI0SWZt?=
 =?utf-8?B?K2U4eE5oaGN0WWdMdkEwK1hnRXBUNENzSTR6cmN3QWhsdDJZQjlPcENWZXFj?=
 =?utf-8?B?Wm1Sd3NCVzdBUm1heTl4K3hPY3U5MWZUQlpQZTFLVlloVy9wNUcrcWYrOEU1?=
 =?utf-8?B?VDZoa0g1S3dIVytXWDFvaDVXdEk4NkhvODRZelpWczFYai8zZ0swbDZLT2Z5?=
 =?utf-8?B?bWpYV0krd0FSMXBGM1YwUDg2aXRGVWJvb1pCMThqN2NhVkI1UlJmMHV4SFdX?=
 =?utf-8?B?TWtOeUpHVk1sa3diUzFDRzFIQWovVHpVdkI4TG1HYloyTm1USDVrUXVmeFdZ?=
 =?utf-8?B?dXRaSUZWRE8xZkhuMEtuS3RnME9mdXROdXgzdkdpUXhKZ3l0T1JHQ01qa01G?=
 =?utf-8?B?VG1QK1hqSzJNWDlnMXJkcWRSTXYwNXBhUjVjZDRORHNWcDd5Vk9YcG14a2hx?=
 =?utf-8?B?d1FiR0h4SW1QYVVBWmNNODJhMTR4eTYvbk0yd09iNy9GTUE1bkJCZmhjSWhx?=
 =?utf-8?B?NzNUdWp6SEpQbjFGVkRDMlZTQXFlWWRqRUx1enVrQUhsRlVxZUxvLy91Slk2?=
 =?utf-8?B?YVF1M2Exb0NxeGg4eEYrdjE5NHdKZ0doSzIwcWFRSDVBTW1WejY5c05VR1hn?=
 =?utf-8?B?QitndGNRLy80aDA5UXhRRDBwZWd3dlcvazZkSHBhOEc0bWZKeFA2RmhIeTBR?=
 =?utf-8?B?MlhjV2lUQnJqanFyUm9sd2U4ZndwVm1JYjlKbXVDTExxVjI1aUV3WFV0Rmtx?=
 =?utf-8?B?eXQvS21WUitwblhLVThodUVQSDYydUJSYWpPanpQcEg3STFrVXNtbU5Td1Qv?=
 =?utf-8?B?c0NtQ1RtRmdmRm5rdkF6SndtNHVNYkZKWmJTYU1XMVI5b3o3ZHFPUSsrRS9R?=
 =?utf-8?B?ZWRWTTFsd3BPTVZoOWlCRzR1OUE0VTZZVHNMVVJPbXRiUDZObktYcnlrMlFj?=
 =?utf-8?B?bUNWQnhUeVEwT2pqYTBMWUI5dDAweTV6SEtOZEZMN1A2dGlLVWlXMUV3TUgw?=
 =?utf-8?B?Q1RPNHpOZmlsLzlQTENsRDQ5dW1OWlFuamlUK2Fod1ZzaGxSN0NXTHlNcnUw?=
 =?utf-8?B?Y3N1Z2VwWmUvalI5S2ZDUUhRYTVUZDhUblFQNDgxUThRZVBmdVB0cXpHNzlz?=
 =?utf-8?B?K1NhS2hZempUaHlNQlR2VVVtcEpNdVFYem9zZW0xQkI0OTh4Q1lFUkJrdTJL?=
 =?utf-8?B?bEtsS1JGSit5QndSSjNQTWFadVVETVZ1bHI0alF3SU9Va2RmcEpTZDdDYzVi?=
 =?utf-8?B?Rit5NGxoUE0vWm12UUIrVVhIMVJDQktpbHFybVdseDR1UDBDQnl1anZuRmk2?=
 =?utf-8?B?aHh5NW9sVTFkRFlEbGllMUhDMWQwcXpBRmttbm1zRmxZVWRFRXhjbFBJVGh5?=
 =?utf-8?Q?f81Jxd/Xlkc7jytisZsY2+G5T?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8776e047-f990-44fb-0ee0-08dbae7bd8c7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 01:51:54.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnN2i2CE3ULEyLwKOr2WcpXQgdYK7kGQewxb3nZ3nrWZdLn340DlaqwKfvNuavJfynKZD1S7yUbp3K+Fg+AlYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7494
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 19:53, Manali Shukla wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> IBS virtualization (VIBS) [1] feature allows the guest to collect IBS
> samples without exiting the guest.
> 
> There are 2 parts to this feature
> - Virtualizing the IBS register state.
> - Ensuring the IBS interrupt is handled in the guest without exiting
>    to the hypervisor.
> 
> IBS virtualization requires the use of AVIC or NMI virtualization for
> delivery of a virtualized interrupt from IBS hardware in the guest.
> Without the virtualized interrupt delivery, the IBS interrupt
> occurring in the guest will not be delivered to either the guest or
> the hypervisor.  When AVIC is enabled, IBS LVT entry (Extended
> Interrupt 0 LVT) message type should be programmed to INTR or NMI.
> 
> So, when the sampled interval for the data collection for IBS fetch/op
> block is over, VIBS hardware is going to generate a Virtual NMI, but
> the source of Virtual NMI is different in both AVIC enabled/disabled
> case.
> 1) when AVIC is enabled, Virtual NMI is generated via AVIC using
>     extended LVT (EXTLVT).
> 2) When AVIC is disabled, Virtual NMI is directly generated from
>     hardware.
> 
> Since IBS registers falls under swap type C [2], only the guest state is
> saved and restored automatically by the hardware. Host state needs to be
> saved and restored manually by the hypervisor. Note that, saving and
> restoring of host IBS state happens only when IBS is active on host.  to
> avoid unnecessary rdmsrs/wrmsrs. Hypervisor needs to disable host IBS
> before VMRUN and re-enable it after VMEXIT [1].
> 
> The IBS virtualization feature for non SEV-ES guests is not enabled in
> this patch. Later patches enable VIBS for non SEV-ES guests.
> 
> [1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
>       AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
>       Instruction-Based Sampling Virtualization.
> 
> [2]: https://bugzilla.kernel.org/attachment.cgi?id=304653
>       AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
>       of VMCB, Table B-3 Swap Types.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>   arch/x86/kvm/svm/svm.c | 172 ++++++++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/svm/svm.h |   4 +-
>   2 files changed, 173 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 20fe83eb32ee..6f566ed93f4c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -139,6 +139,22 @@ static const struct svm_direct_access_msrs {
>   	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>   	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>   	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> +	{ .index = MSR_AMD64_IBSFETCHCTL,		.always = false },
> +	{ .index = MSR_AMD64_IBSFETCHLINAD,		.always = false },
> +	{ .index = MSR_AMD64_IBSOPCTL,			.always = false },
> +	{ .index = MSR_AMD64_IBSOPRIP,			.always = false },
> +	{ .index = MSR_AMD64_IBSOPDATA,			.always = false },
> +	{ .index = MSR_AMD64_IBSOPDATA2,		.always = false },
> +	{ .index = MSR_AMD64_IBSOPDATA3,		.always = false },
> +	{ .index = MSR_AMD64_IBSDCLINAD,		.always = false },
> +	{ .index = MSR_AMD64_IBSBRTARGET,		.always = false },
> +	{ .index = MSR_AMD64_ICIBSEXTDCTL,		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EFEAT),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_ECTRL),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(0)),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(1)),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(2)),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(3)),		.always = false },
>   	{ .index = MSR_INVALID,				.always = false },
>   };
>   
> @@ -217,6 +233,10 @@ module_param(vgif, int, 0444);
>   static int lbrv = true;
>   module_param(lbrv, int, 0444);
>   
> +/* enable/disable IBS virtualization */
> +static int vibs;
> +module_param(vibs, int, 0444);
> +
>   static int tsc_scaling = true;
>   module_param(tsc_scaling, int, 0444);
>   
> @@ -1050,6 +1070,20 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
>   	}
>   }
>   
> +void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept)
> +{
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSFETCHCTL, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSFETCHLINAD, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPCTL, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPRIP, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA2, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA3, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSDCLINAD, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSBRTARGET, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_ICIBSEXTDCTL, !intercept, !intercept);
> +}
> +
>   static void grow_ple_window(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -1207,6 +1241,29 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		/* No need to intercept these MSRs */
>   		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
>   		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> +
> +		/*
> +		 * If hardware supports VIBS then no need to intercept IBS MSRS
> +		 * when VIBS is enabled in guest.
> +		 */
> +		if (vibs) {
> +			if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_IBS)) {
> +				svm_ibs_msr_interception(svm, false);
> +				svm->ibs_enabled = true;
> +
> +				/*
> +				 * In order to enable VIBS, AVIC/VNMI must be enabled to handle the
> +				 * interrupt generated by IBS driver. When AVIC is enabled, once
> +				 * data collection for IBS fetch/op block for sampled interval
> +				 * provided is done, hardware signals VNMI which is generated via
> +				 * AVIC which uses extended LVT registers. That is why extended LVT
> +				 * registers are initialized at guest startup.
> +				 */
> +				kvm_apic_init_eilvt_regs(vcpu);
> +			} else {
> +				svm->ibs_enabled = false;
> +			}
> +		}
>   	}
>   }
>   
> @@ -2888,6 +2945,11 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_AMD64_DE_CFG:
>   		msr_info->data = svm->msr_decfg;
>   		break;
> +
> +	case MSR_AMD64_IBSCTL:
> +		rdmsrl(MSR_AMD64_IBSCTL, msr_info->data);
> +		break;
> +
>   	default:
>   		return kvm_get_msr_common(vcpu, msr_info);
>   	}
> @@ -4038,19 +4100,111 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>   	return EXIT_FASTPATH_NONE;
>   }
>   
> +/*
> + * Since the IBS state is swap type C, the hypervisor is responsible for saving
> + * its own IBS state before VMRUN.
> + */
> +static void svm_save_host_ibs_msrs(struct vmcb_save_area *hostsa)
> +{
> +	rdmsrl(MSR_AMD64_IBSFETCHLINAD, hostsa->ibs_fetch_linear_addr);
> +	rdmsrl(MSR_AMD64_IBSOPRIP, hostsa->ibs_op_rip);
> +	rdmsrl(MSR_AMD64_IBSOPDATA, hostsa->ibs_op_data);
> +	rdmsrl(MSR_AMD64_IBSOPDATA2, hostsa->ibs_op_data2);
> +	rdmsrl(MSR_AMD64_IBSOPDATA3, hostsa->ibs_op_data3);
> +	rdmsrl(MSR_AMD64_IBSDCLINAD, hostsa->ibs_dc_linear_addr);
> +	rdmsrl(MSR_AMD64_IBSBRTARGET, hostsa->ibs_br_target);
> +	rdmsrl(MSR_AMD64_ICIBSEXTDCTL, hostsa->ibs_fetch_extd_ctl);
> +}
> +
> +/*
> + * Since the IBS state is swap type C, the hypervisor is responsible for
> + * restoring its own IBS state after VMEXIT.
> + */
> +static void svm_restore_host_ibs_msrs(struct vmcb_save_area *hostsa)
> +{
> +	wrmsrl(MSR_AMD64_IBSFETCHLINAD, hostsa->ibs_fetch_linear_addr);
> +	wrmsrl(MSR_AMD64_IBSOPRIP, hostsa->ibs_op_rip);
> +	wrmsrl(MSR_AMD64_IBSOPDATA, hostsa->ibs_op_data);
> +	wrmsrl(MSR_AMD64_IBSOPDATA2, hostsa->ibs_op_data2);
> +	wrmsrl(MSR_AMD64_IBSOPDATA3, hostsa->ibs_op_data3);
> +	wrmsrl(MSR_AMD64_IBSDCLINAD, hostsa->ibs_dc_linear_addr);
> +	wrmsrl(MSR_AMD64_IBSBRTARGET, hostsa->ibs_br_target);
> +	wrmsrl(MSR_AMD64_ICIBSEXTDCTL, hostsa->ibs_fetch_extd_ctl);
> +}
> +
> +/*
> + * Host states are categorized into three swap types based on how it is
> + * handled by hardware during a switch.
> + * Below enum represent host states which are categorized as Swap type C
> + *
> + * C: VMRUN:  Host state _NOT_ saved in host save area
> + *    VMEXIT: Host state initializard to default values.
> + *
> + * Swap type C state is not loaded by VMEXIT and is not saved by VMRUN.
> + * It needs to be saved/restored manually.
> + */
> +enum {
> +	SWAP_TYPE_C_IBS = 0,
> +	SWAP_TYPE_C_MAX
> +};
> +
> +/*
> + * Since IBS state is swap type C, hypervisor needs to disable IBS, then save
> + * IBS MSRs before VMRUN and re-enable it, then restore IBS MSRs after VMEXIT.
> + * This order is important, if not followed, software ends up reading inaccurate
> + * IBS registers.
> + */
> +static noinstr u32 svm_save_swap_type_c(struct kvm_vcpu *vcpu)
> +{
> +	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
> +	struct vmcb_save_area *hostsa;
> +	u32 restore_mask = 0;
> +
> +	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
> +
> +	if (to_svm(vcpu)->ibs_enabled) {
> +		bool en = amd_vibs_window(WINDOW_START, &hostsa->ibs_fetch_ctl, &hostsa->ibs_op_ctl);
> +
> +		if (en) {
> +			svm_save_host_ibs_msrs(hostsa);
> +			restore_mask |= 1 << SWAP_TYPE_C_IBS;
> +		}
> +	}
> +	return restore_mask;
> +}
> +
> +static noinstr void svm_restore_swap_type_c(struct kvm_vcpu *vcpu, u32 restore_mask)
> +{
> +	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
> +	struct vmcb_save_area *hostsa;
> +
> +	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
> +
> +	if (restore_mask & (1 << SWAP_TYPE_C_IBS)) {
> +		svm_restore_host_ibs_msrs(hostsa);
> +		amd_vibs_window(WINDOW_STOPPING, &hostsa->ibs_fetch_ctl, &hostsa->ibs_op_ctl);
> +	}
> +}
> +
>   static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 restore_mask;
>   
>   	guest_state_enter_irqoff();
>   
>   	amd_clear_divider();
>   
> -	if (sev_es_guest(vcpu->kvm))
> +	if (sev_es_guest(vcpu->kvm)) {
>   		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
> -	else
> +	} else {
> +		restore_mask = svm_save_swap_type_c(vcpu);
>   		__svm_vcpu_run(svm, spec_ctrl_intercepted);
>   
> +		if (restore_mask)
> +			svm_restore_swap_type_c(vcpu, restore_mask);
> +	}
> +


The SEV-ES branch also needs to save/restore IBS to keep IBS working on 
the host. Unless the hardware is not resetting the IBS state if vIBS was 
not enabled for the guest, is this the case? Thanks,


>   	guest_state_exit_irqoff();
>   }
>   
> @@ -4137,6 +4291,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	/* Any pending NMI will happen here */
>   
> +	/*
> +	 * Disable the IBS window since any pending IBS NMIs will have been
> +	 * handled.
> +	 */
> +	if (svm->ibs_enabled)
> +		amd_vibs_window(WINDOW_STOPPED, NULL, NULL);
> +
>   	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>   		kvm_after_interrupt(vcpu);
>   
> @@ -5225,6 +5386,13 @@ static __init int svm_hardware_setup(void)
>   			pr_info("LBR virtualization supported\n");
>   	}
>   
> +	if (vibs) {
> +		if ((vnmi || avic) && boot_cpu_has(X86_FEATURE_VIBS))
> +			pr_info("IBS virtualization supported\n");
> +		else
> +			vibs = false;
> +	}
> +
>   	if (!enable_pmu)
>   		pr_info("PMU virtualization is disabled\n");
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c7eb82a78127..c2a02629a1d1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -30,7 +30,7 @@
>   #define	IOPM_SIZE PAGE_SIZE * 3
>   #define	MSRPM_SIZE PAGE_SIZE * 2
>   
> -#define MAX_DIRECT_ACCESS_MSRS	46
> +#define MAX_DIRECT_ACCESS_MSRS	62
>   #define MSRPM_OFFSETS	32
>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   extern bool npt_enabled;
> @@ -260,6 +260,7 @@ struct vcpu_svm {
>   	unsigned long soft_int_old_rip;
>   	unsigned long soft_int_next_rip;
>   	bool soft_int_injected;
> +	bool ibs_enabled;
>   
>   	u32 ldr_reg;
>   	u32 dfr_reg;
> @@ -732,6 +733,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>   void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>   void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept);
>   
>   /* vmenter.S */
>   

-- 
Alexey

