Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88B4460EAA
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 07:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbhK2GGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 01:06:16 -0500
Received: from mail-bn1nam07on2109.outbound.protection.outlook.com ([40.107.212.109]:29762
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238977AbhK2GEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 01:04:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hj6Q/HiR143zPYtxBnybvKS8mvXAcM5Xg04UVdGP11/lIfduysZhPer02CHplfEXINqvZv1uAZty3gbrY5/ayCcRHgV+DQZnqbBRLhKB2DQvAZMCdPXb/pXOlc6zkNGIV7sYu6uvaa0kGAu5I3+yUJJziB2I8l03zGIO/VSFd7IRYSFaddW5A76QbjaHEu4JGWVtWamTkdf3TP0jKjbb8Og+7D3NRSRhk4bwpY6mFxwKF9hf8mdFWPMgiTyiZ5L8zbxN5xQAMAHCRmOACoZZ/HgKXgWnH1eBMsq+8NMOeiveTsUnt2m2W+WDl1yb/j5WLEF+4RiY4mni397WkNmNhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIRu1x6KQoOkOSRcYQ/Wj3+Z12JlaVDLVItjuLRjFGo=;
 b=bi+dC9q4iuINLNNwC2CBccFZjledfsXwR6AcfDKB9ERgT40EYXJT4yaCgCrzMHxoZ34N/9aCU1PJCJ3oCstYnxst6eC9o+HxezBOBSnFOFYkP21w+XldmQEc0RKKSL5mviFsTUoVtTaELv0+4bwuHLtryiLylcygHbMXrheD7l28DJ+VgKLQd9lhOz2EaH78yqC4NB58iaWFKYHis/DUjmUjGSAXXklgAlKN0Hsfstkac0HX3KotVzrhSqd56YheeF2UtJf0vKIIj4VYtG+J4dKTNkcT5hRcfPvKZR+goizYdFFM/cpsIyq8JLeMG7KzVUyNUOHZ1LBAvK2SxH1mmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIRu1x6KQoOkOSRcYQ/Wj3+Z12JlaVDLVItjuLRjFGo=;
 b=FY+FglbxQY9mVabf6QwQRBM8FkNLF3ZYUlOsyYxnx6E5ljwVIwYZU+EoLwoJ9zzTHyKf6HD5SlE5DjXzeqXjNpxA3Pa7Dr8zPprclFBH6uiiWW+V5JKR3F1Q2rgkIAc2AeObh/yikqfweUpnjIvaNoqzLE3uJQCWDBnN1YzhlmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB5385.prod.exchangelabs.com (2603:10b6:5:17b::23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Mon, 29 Nov 2021 06:00:54 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 06:00:54 +0000
Message-ID: <afbf8081-1b56-cf38-f3db-4499b3692d9d@os.amperecomputing.com>
Date:   Mon, 29 Nov 2021 11:30:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 2/2] KVM: arm64: nv: fixup! Support multiple nested
 Stage-2 mmu structures
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, darren@os.amperecomputing.com,
        D Scott Phillips <scott@os.amperecomputing.com>
References: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
 <20211122095803.28943-3-gankulkarni@os.amperecomputing.com>
 <877dcwco1m.wl-maz@kernel.org>
 <a32b4390-a735-783f-9351-a71334d67572@os.amperecomputing.com>
 <87bl26bu68.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87bl26bu68.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::8) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
Received: from [192.168.1.22] (122.177.50.160) by CH0P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Mon, 29 Nov 2021 06:00:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48d7c26e-02a1-41a2-29c3-08d9b2fd9aed
X-MS-TrafficTypeDiagnostic: DM6PR01MB5385:
X-Microsoft-Antispam-PRVS: <DM6PR01MB538539C2A3BCF808734AAE159C669@DM6PR01MB5385.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rjXlgBCDv2x4CjPACXgoX2jsRvzXwogdJzQZCQz3yINI62ekpwoe7aYhYN7JrE5nvIocN9rNiygKqgCxFGqVI8DoW+so+uNz5ELutLm2zW0tFccwsavwkhaipKb9c2XdtLDzkxNpYJPSDPgPejh0K2+wQEmmaOGI3zjW7PzghRZIXtblk+Tjung5wr/7M82+tBmfGSpY+vw9vasJBGDgfzOGOJuaZjQeMKpPwNwE42T92A0JytTSqZq23Rb7wgL8lRcsB3BUyIUPrV+oFPnL/mQrMwFnFkbDoZnRlOGv7P5c0sRg8VPTfk9R4TsBjpiuOXl+U/0J0I7GFO1ShbV2n/KEzQGsj28mgWSnFhs3ZvPU0DvVb1fI36tdAogR2AqmcK4H9maT8GNaGj+Y1VHcnrC6RnU9Z95ltSi6m0Y14iWxR7y5Te8+FW3UCnSa2D1DFqkBf3exebdLonRZOqRMu6Tn0vwEeV91egOC3Xq74JAFbMasAsOSU+ESMJMXjD8c3a+HPwqA1cuRxPiBn4OK/7myJxTnCCqzh8jq4h5kxG5SUMp3L3QOAHRosCXw9Tp1Z1cYErhcyE9wU8jHKFme1kUeJi8td5u9sO/SMFFfKSQ5XBh2sRlESh1wRzTYmKpsnBQ02BeQhzABrfuiZFzKsIT0tfbfGj4HmTSYvvNKcySONlqe7WMi7xWT8sp7efaQZCdVvAoFTcbQx+FXA/uJ+2tK6zNfj1kqF7U8VUKgLRr5ZAoLgNKpt4EvnTZP8WByK9aj3DElsw52NQgnSKiUW7piFPdOEgVUbp7BBNi/uth6wJiQ0m5sbQPumOnFz+EpKsvdMjCcF/FkNIR7jngvB67XDP/bOmgXEmNSplxGs2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(2906002)(55236004)(26005)(956004)(8936002)(508600001)(6486002)(966005)(83380400001)(4326008)(8676002)(6666004)(53546011)(16576012)(66556008)(31686004)(6916009)(38350700002)(5660300002)(66476007)(38100700002)(86362001)(186003)(107886003)(2616005)(52116002)(31696002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmFBQ3FZVkxmZlcvUHF4Y285SE5ZT2Nna1FUVXRLRVFlcGZPMGVCanY0eUZ1?=
 =?utf-8?B?eVhEWERqaytWYjcza2tobVJ6aXdWRkVFbzhMbDVyL3F6b0VKdzU5K0pWQ2Zp?=
 =?utf-8?B?SGpWTWVnZnpib04rN2ZNckVJaUF0SHZuaTI1OFFCdXFIdkthQlllcG5WMnB5?=
 =?utf-8?B?d1drRXVFeEVkblM4K1lQbCsvYzBqd2pGVThJci9BWWx5dGZUUk5PQjlhbytX?=
 =?utf-8?B?U0wweSttMkR4eGtzQ1l5azRwRlc0UllaU0xLYjZkOEpYd1I1cFYvd3BPZHpM?=
 =?utf-8?B?dktJTkozdmxwZlpac2d4dkwzU3VkZkRlNVF3dnUwa3lXMWhrY3g2dDNDZVJH?=
 =?utf-8?B?REV2Y2EyWlhFaitHVXJJZFlQYWUzN0RDNC9GVklORGhFUStKOTlJcWVCc1JJ?=
 =?utf-8?B?dGFMQzV4a1RaNEdyeVJLSFdMaTNFS25hQWdmSkpZL2NoRVloSTBJOURkVzdu?=
 =?utf-8?B?cGtLN3B6RS8zMGsxbklCUVhJUDFISlZRbFJ6eE5kbE0xMzI3TGo2RlkvSzU2?=
 =?utf-8?B?Wks0M0p3cE5PTndMWVlmcnlYSTRCN3V4TDNZdjh6cDRydktvVkpNQXl6NGt0?=
 =?utf-8?B?aHBvdjVBdHY3WlpGTXhvUmJpMktIaE1KR0VueGlTNTRIQ0NDWUtRcVV6RlNU?=
 =?utf-8?B?NndQMDhQR2dESVg0bDBDd0FkUkh0cmd1a0tya09jK1F4LzdLR3V6UVJMM3pm?=
 =?utf-8?B?V3NMdS9sY2dta2o4WW9TU2lEVk5YMzUwemRqdVByMm82NSsvTVZSNXBtVEVj?=
 =?utf-8?B?ZGs0T3FmdncrS0h0Wk5yUFhDclRTd25kOFV5Sjl5b09WM085RHNQbGNFeko5?=
 =?utf-8?B?ZGdRcHd1MTFPMUZMdHUraDFHQXYralNUc29taFRhQW1jTHB1TGV4bWwrSk1B?=
 =?utf-8?B?SmFOU2M5bmsxd2dNVm9KRmRFR1l2Z0wvSVEvVEtQNEUyK0EzZnVQanlqMEVO?=
 =?utf-8?B?L2dhV0hZVEJsOURWbXZVMUVjV0lFSDI1TUdtcG9rYysvVVhHbUpvUEZ4ZG9u?=
 =?utf-8?B?cmxyZ3JaVjVxUSsraUhJVGVnRWZMV2o3TU43czVQMDY2RDM0VWpNYUp6RDhz?=
 =?utf-8?B?Yk9VbTFYeE9nbGNYY3d0WmJGWExVSzhxVkhNS2p3bmhHK0V4RWZmOVJJaFo0?=
 =?utf-8?B?M3FHS2xhNEJoUE4vWnJQaGRhL2puLzd6OG1mOGxDcXB1azlhczhvYzA2RFJr?=
 =?utf-8?B?bFA4UU10UkJWTVk5R3pMckFBNEw0YkdWN3h1aTl5Nnc0SW1KWU9RRnUrSlNa?=
 =?utf-8?B?V2R4b0k3aENvd1dBUnRDaFVRNk9BNDRzMlFDY0lQczF3c0R6cGtvWEtkUkxF?=
 =?utf-8?B?SFJ4S1d5MFg0cjBiMTZhaVU3NWR2L0o2Q1JBZkFvQ09QZnVMV3h5bjY0Nkpy?=
 =?utf-8?B?R0J6OU9UNFhxWWlKNC9mS2pYSFArd2t6TTFzUlZCcWdzQlM2aDA3YUFCeFNn?=
 =?utf-8?B?YmEwQlM1ODFkZnprVjgreUpsUGdteVV2NXVseDNINFYycFRwb1JrZWZJOGVt?=
 =?utf-8?B?cWVzb21JVVg2Y0lBbjZrR2lMa21xSThVV1ZXOHI0c3hyNjRGZENIYlZON1p6?=
 =?utf-8?B?b05wVjlkbG9TNzBHenhKNFYvUnRlYXV3TzNSUlRabEw5anQrWTYvYklWaFhv?=
 =?utf-8?B?NWYveVUraVpCR2JpamxUYTdWZTJIVFpyd2tuYndhYTY3eEJLRUw0NmZXT0pv?=
 =?utf-8?B?UWxCeWV5azVETytWN0tranBncm15a2tUUVZET2dab05hTmxhQzVJdTFoWGQ4?=
 =?utf-8?B?ZEg2TStFMUhycjZlYWU0c0tvZ0g0SGU2eUpEWTRpSXNra0NPYmY4aXNheXMy?=
 =?utf-8?B?YXdtWnlSeWxIYXd0VCt3Y1I2N0lnY3NCVEkreUJiVmE5OC9sRnF1VXJDa2dn?=
 =?utf-8?B?VVIrWThPbFlQbjQ0ZHY3eTltclhNd0hnTjQ4RUdGSFo2bHc4NkZEU1VlM0g3?=
 =?utf-8?B?Vmt1T3ErWHFPNzVudTNSTFo4V1pVTUVHM2gvUFF4aXB2dHRDRHg1Y2RhTXJo?=
 =?utf-8?B?WDVDN3VwRm15TWNMb0pLQ3lURXdTNHdsTG5YSWV0bVJYRUhYNVJEY2NMWlBP?=
 =?utf-8?B?TVR4YWRpeityZzdOaUpIT1Zxcmx5Y0pOOStMUWFwMGtkZ0x6Q1AwVzE1MGlH?=
 =?utf-8?B?RnlUTTVESUJtMkQ5Zlpmeld2YUZkd21kTnV0eG9QZHBmczk2bjZ0ZVFoVThw?=
 =?utf-8?B?ckFnMjlwcVRwTzZoNmVMa2o2R1AvWVZaR3l3VEl1R3pFdkhWWUxZYlcvQ1ZW?=
 =?utf-8?B?QjJzeXpkRUVpb3ZwU2JCc2t6cTlpQ1NVeEZzVlpaTjdJcThVdGNYcDlTaEh0?=
 =?utf-8?B?OVZDV0hyVDM0YVFCSXRQTUdOamNaMnBxMHRHMzRwbzdXYmtrUG14UT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d7c26e-02a1-41a2-29c3-08d9b2fd9aed
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 06:00:54.6713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GggCfCfWi6b5vL9VdxEzSBXG+WSYNYvBW8ThJRTPHyyUXH7Wm1ds2/je2uTrVbXXF9pGE/ZMD3+Z4wX3inysNWAlkPMoJyr94zoOhzrLswkduHFbr2YRP72dG5hWyUgH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5385
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 27-11-2021 12:50 am, Marc Zyngier wrote:
> [resending after having sorted my email config]
> 
> On Fri, 26 Nov 2021 05:59:00 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> Hi Marc,
>>
>> On 25-11-2021 07:53 pm, Marc Zyngier wrote:
>>> On Mon, 22 Nov 2021 09:58:03 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> Commit 1776c91346b6 ("KVM: arm64: nv: Support multiple nested Stage-2 mmu
>>>> structures")[1] added a function kvm_vcpu_init_nested which expands the
>>>> stage-2 mmu structures array when ever a new vCPU is created. The array
>>>> is expanded using krealloc() and results in a stale mmu address pointer
>>>> in pgt->mmu. Adding a fix to update the pointer with the new address after
>>>> successful krealloc.
>>>>
>>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/
>>>> branch kvm-arm64/nv-5.13
>>>>
>>>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>>>> ---
>>>>    arch/arm64/kvm/nested.c | 9 +++++++++
>>>>    1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>> index 4ffbc14d0245..57ad8d8f4ee5 100644
>>>> --- a/arch/arm64/kvm/nested.c
>>>> +++ b/arch/arm64/kvm/nested.c
>>>> @@ -68,6 +68,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>>>>    		       num_mmus * sizeof(*kvm->arch.nested_mmus),
>>>>    		       GFP_KERNEL | __GFP_ZERO);
>>>>    	if (tmp) {
>>>> +		int i;
>>>> +
>>>>    		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
>>>>    		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
>>>>    			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
>>>> @@ -80,6 +82,13 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>>>>    		}
>>>>      		kvm->arch.nested_mmus = tmp;
>>>> +
>>>> +		/* Fixup pgt->mmu after krealloc */
>>>> +		for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>> +			struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>> +
>>>> +			mmu->pgt->mmu = mmu;
>>>> +		}
>>>>    	}
>>>>      	mutex_unlock(&kvm->lock);
>>>
>>> Another good catch. I've tweaked a bit to avoid some unnecessary
>>> repainting, see below.
>>>
>>> Thanks again,
>>>
>>> 	M.
>>>
>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>> index a4dfffa1dae0..92b225db59ac 100644
>>> --- a/arch/arm64/kvm/nested.c
>>> +++ b/arch/arm64/kvm/nested.c
>>> @@ -66,8 +66,19 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>>>    	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
>>>    	tmp = krealloc(kvm->arch.nested_mmus,
>>>    		       num_mmus * sizeof(*kvm->arch.nested_mmus),
>>> -		       GFP_KERNEL | __GFP_ZERO);
>>> +		       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>>>    	if (tmp) {
>>> +		/*
>>> +		 * If we went through a realocation, adjust the MMU
>>
>> Is it more precise to say?
>>> +		 * back-pointers in the pg_table structures.
>> * back-pointers in the pg_table structures of previous inits.
> 
> Yes. I have added something along those lines.
> 
>>> +		 */
>>> +		if (kvm->arch.nested_mmus != tmp) {
>>> +			int i;
>>> +
>>> +			for (i = 0; i < num_mms - 2; i++)
>>> +				tmp[i].pgt->mmu = &tmp[i];
>>> +		}
>>
>> Thanks for this optimization, it saves 2 redundant iterations.
>>> +
>>>    		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
>>>    		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
>>>    			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
>>>
>>
>> Feel free to add,
>> Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> 
> Given that this was a fixup, I haven't taken this tag. I will Cc you

no problem, makes sense to fold this in to original patch.

> on the whole series, and you can give you tag on the whole patch if
> you are happy with it.

Sure.
> 
> BTW, I have now fixed the bug that was preventing L2 userspace from
> running (bad interaction with the pgtable code which was unhappy about
> my use of the SW bits when relaxing the permissions). You should now
> be able to test the whole series.

Yes, I have rebased to latest branch kvm-arm64/nv-5.16 and I am able to 
boot L1 and L2.

> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat
