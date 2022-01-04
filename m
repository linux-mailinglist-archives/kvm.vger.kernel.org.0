Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93BD483F74
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 10:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiADJxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 04:53:55 -0500
Received: from mail-co1nam11on2132.outbound.protection.outlook.com ([40.107.220.132]:7265
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229702AbiADJxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8sxJxO6QHzYp+Zco2SOcMAaRqwmdeVSi17+INKQKUf0UH6ttKP4uE0NV53s3ve71MJekR9K5yxk5ydCI+atIczZlyC7zme2v1T7+b09AtVi50FUzQ8sQ0xULLhv5O1VZ3Rh9Xa/CaFgGputLRGh3uIMQuf4Frug2nuIHARingdfC+ta2wtINMDR6hU75x+0ZTuufyEVCjNHUeJG/Zbd4lffr99ydQJSqq+2a06RGwGuUhqVzcSTyESYarf+DyRpmI7evtvQKExDyMFbuAMp+m35Gw5QO8DGP8ZSSmFlivDUJ6Qw9XZJd7Q8vNMWLgncvsnSnaW45vnpgLj8QU1pcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ho8GiueFtcLpWEQhkfyRkQzW6+ShVTCMY6/eIbEbBQc=;
 b=ZtA6g/eCLWwEfs7tGV2vmpCz1FsHqYobmdDFjmCWsHbnkR87VWb5mldIH88D87cPB2139WX+f3dUppH2bK+4L0j02Gg+NoRiOyK2CxVCtGUDPqalBAWLsMssK++Tnq2YbmmjF+Noeb1GuGnljrwL3R4KLLfyH1sfiO6UCcgTlgCoGg81n3N7FokgNRxVLfIYmoOUMgMD8aESmn9j6VcHtKAjRul7goH4FmLUSB7L2bF4WDg31b2QpC7bQc1nR6jwJWJcey10nqY3zBsJzbxlbL7nYaxn7hVk+TiVG9ltBfRov7c5Z5qtd7bi0tdN0BQoUwB75LPHa0LoEbZYFTLCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho8GiueFtcLpWEQhkfyRkQzW6+ShVTCMY6/eIbEbBQc=;
 b=BB9Li+dStPGyeyHIYBoa4ORCrgdNZtlH8DlcElVFhq22H30/KN6OeG1s58uDOGqLU84SCTPSV3oHbzjQXQcVqCqhqk424YICSfwfIAj9DQQ7JFKQ8EIN0JP5HyV55pgBlj29Q3hH+cZzGN9nIvU1/N73zgVuXdclELqXGsJp158=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB5499.prod.exchangelabs.com (2603:10b6:5:17c::17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 09:53:50 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4867.007; Tue, 4 Jan 2022
 09:53:50 +0000
Message-ID: <2e8f9806-f11b-4aee-db44-8a5a0f30cc6d@os.amperecomputing.com>
Date:   Tue, 4 Jan 2022 15:23:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 34/69] KVM: arm64: nv: Configure HCR_EL2 for nested
 virtualization
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-35-maz@kernel.org>
 <bbf31da5-ca1b-7499-e23c-9b5281ca7901@os.amperecomputing.com>
 <87o84rvnyo.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87o84rvnyo.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:610:58::28) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5c6080b-6035-42bc-4d41-08d9cf681be3
X-MS-TrafficTypeDiagnostic: DM6PR01MB5499:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB5499D57F10452E7C77A6CCBC9C4A9@DM6PR01MB5499.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8f7u24iOnWxBMqGJSjTE6Vu2lOloMSrez/lr5cmVe5I0pg7h/hFiM+Q1FH6XW5MizyEtx80FneFO3bSQvhLCJRaUXjPHlCtqfL3vHIiIBW3CVfFxwN/OuroyueCZ/uWXvHJo/h9ICBWHRLlUVmEMNW2YXmlig4byEeEFojt/nxG/jVLqlG2i6ZmRffzfiUyiABCGYPq6RRJbj5rv0OVkFt7BzRCmsx3Kg1Qmdrs6vm8kOK62/DjsqYqTLJ1SuMJm/34QtmA1lQ21O5LKqVJrf0iZUWUaIBsUd6KZwHlDfxGyIfHbLuTOZ4PiKUonfzPPSL+YlIQAPfZ+JXnCzpV6iAswIVC/hrTYUqUO0WMY4D/EyNlVtZwo3rMMMtUtGtuOVegVviW459hbMOAx7wJScSaP7f3H157Rv6gg0TT14ccaawDgFWxu24J1rywqf96M7W9DfdbjZR0OUsnTp5CLhxRZdIT6YI27qVD4FDC5Z9EItIWxsAvyuf3Q+W9qF9r0D8ziAqEno3HDamE1pfoK4h99D3+4wVSB7Id8WI8jllsEhED3MvAoopBI1kcrPsqPTyEMow/xjDrsHkzzD7HL/2No1z+0CK1iiElJkFsNLlp4jet+EoqVlOWBJx4mya8yBE1jCTKqt65DTtLXmtq9GG5BOHEeszgzgVN4atGdbojIW/ysxHD5jm+MOue5fAdvmsI7R6ryT3VvridpkX4artJledD/3xaqbXW+6GtqUJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(38350700002)(66476007)(2616005)(54906003)(6916009)(5660300002)(2906002)(7416002)(8676002)(6512007)(38100700002)(186003)(508600001)(66556008)(4326008)(52116002)(31686004)(6486002)(6506007)(26005)(6666004)(8936002)(31696002)(66946007)(53546011)(86362001)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFR5SXZlbjJTZlE0VHJTMXpzWUMyMmMzMnY2dU8wcHBjVldsUDdPR05kNFM3?=
 =?utf-8?B?aFVDajE1NGZONVNtRWNFSUFQZ2xrOUgybmhjVlc0alE0NnM5TUVVMjhvQ1FW?=
 =?utf-8?B?N0Z0a3pzL3ZJL2pDRzRXU1NWdGZnSE5HZWlacWlDZUVhVGN2OCtjMEgzU1JO?=
 =?utf-8?B?N3VCWjB1TjY2MWczZGxBQmswZXpBME9QMHNlVVhWNXd2c2xTbVlVL05LYlpt?=
 =?utf-8?B?UloyZzZsTS9zNndsWVIzTlVSM1lLMHRvRFFYM0thbml6RjRCMG5Zb28vUWND?=
 =?utf-8?B?T2x4eWVqVG53TEZXS0Y3RTMwY0dPSnl5R2g0amdyTVJZcGlyT0g4eVFFOWdV?=
 =?utf-8?B?Wnd0ekFmTWZsZ1gwOHN0ZjIwZytyL2g2T3ZqNEloM0w3bW91KzVCekRYSFpG?=
 =?utf-8?B?bDB1Vlh4ZVByMzhQQnYvRXYvUHJKYlFKczc2dlFsT00xdWg1cjYyK2dDR0Nx?=
 =?utf-8?B?MmZMMVFHM1I3Z3NPRTBLTHdjTFU1Mm05ZTZlT3RhdWJoZWZad1RvWitBQ1B6?=
 =?utf-8?B?S3ptdk8zdXEycnhONUpVTW1pWHMxUHdxWWZVRUVJQkJPVElqQlpLYjZEQ1Z1?=
 =?utf-8?B?UFoxajFkQTZ1aUpNUU0rNjc1eW9sMnJLYmtyWEwvSW1BVThzS0tsVHd6UUlR?=
 =?utf-8?B?UEMwSE5NdmViUWNzVWlETkUyZ1h1MHdxZUlsRmVYNWF1N1BuZVZVRVZlK3dI?=
 =?utf-8?B?YVpwc2g1VUV6aE12OXJKejBLNU9uQ1pUdURhdW04Sm5vb2lTVzFKSEhOd3JQ?=
 =?utf-8?B?VmZxR1RWbGxncXFRZlFuNVB0QkZQOU1VRWcxemZlclJNQUJvOVozRWZ5Sjhu?=
 =?utf-8?B?dW92UFF3UEFFZ3pLaTlUbURHQ2ljYmREMlNWcW83U3Zya3p2SCtVbS9YZUVn?=
 =?utf-8?B?TktscjllMEIvejRCVVNkbmZlZm9ZbFJBYWtFQmlZSjZ4L1ZUdEp2SXcvdlBR?=
 =?utf-8?B?S1ZHd29oZEIwTzl4Nll0OXpDbG93OE9FT1ZLaWtGcnNoVi9RWW9ldFM4dExG?=
 =?utf-8?B?enJpR3BlWDFRbjlBNWIxRVFvUldPQkpYbFFoRnl1cGF4MVVlS3pTb2JvQzZm?=
 =?utf-8?B?Z29PU0tsK0JhbjR3cXl4Zk94bmNjTis5WWlQMjc3c013bVlNVldCVy9ycFhC?=
 =?utf-8?B?Z0pHUnkzdWhRMlpoUHhFYnpnL21DY0d6R3RsL0htWlR6NnNtV1hzajExYkp0?=
 =?utf-8?B?c3FmcU5UK2p5T3VZWVJlbzNRVjJSRUZGYjM3c3lWUU1vY2ZxQjIyTDBCTm9O?=
 =?utf-8?B?MlBPV2FEZUVSR0lybmlmVVZyWXlyMjdLN3g0QzA2RjQrS0I1aXpWUXcyT2px?=
 =?utf-8?B?RG13aFA2czZtcGN3OGgwNkVqZmdXejlrbm9DdVNtSEhSalUwRXVOclhjdXVK?=
 =?utf-8?B?ajBRYzY4cW5tYk1qcWJtdWVaSDNYT1pSZVFMTVB3WGVZSDZZcGFEZVlFM0FT?=
 =?utf-8?B?WS9JbFIreTlIeEtHSmdpSE9tRDZwSnNJd1pyVmFqZHREUXFrVzRGOEVtcmxC?=
 =?utf-8?B?a3VZblRtYy9xVTVreHBTMU9MYlR5SnVIWkoyTXBleEFEVS9UOFRFd0N3WHlx?=
 =?utf-8?B?QjNMM1VlMGYvZTUwcmdpM2dyQzNqSTBnZWMveGNQb3VOSTJtNmlFQnFXZTlo?=
 =?utf-8?B?b1VHK2JlZER5T2drZEhKRG5TZHhBeXlCQTNjK2x5T0I0Qld4NDNmN2JLYWkx?=
 =?utf-8?B?bS9jdDBSY2ZlL1pLSkc5eTZvZzBFY2xLMmZiWjJXUVJGWkVRRFBJYzU0QkhJ?=
 =?utf-8?B?Wkp6K0JmVFJJNVZHVEtqazdtbXl6MlR4WjBMNkxLK1lKcTZ2bEJYL3djeXla?=
 =?utf-8?B?RUZnd2V1TVBObWR5dmFSM0pKRkNqSVJ5TXNhejJkVmlIMHNveWM5aU9DQ3ZK?=
 =?utf-8?B?cXdIcGozSW5IMjhhd1dzNWlCczBpU01SaGN3Y2ZlRVM4UlI4cHNoWHAyRUx1?=
 =?utf-8?B?ZHJyN3pjUDJ3QnpaeWhpQzAyN0RlYUpWd1YxR2RCeG01MWhSNGFwNmtMN0tp?=
 =?utf-8?B?WUE2eS81ODFiUEZTUGJWOGlGZTRJdE1wOEVQcFpkRlo4WHdBM2JSTnpDaTlU?=
 =?utf-8?B?d005UUFJWjFPaEJyb1YxWnM0RnpJZmg3U0JUSDJxeHlaYXdLeFNNSS8wVnFj?=
 =?utf-8?B?bllaOXNuUXFXaS8xRGF0RCsvRGI1K3MyQWJDcnlrVTBkZTNWNnZIWWE5MTZz?=
 =?utf-8?B?aXVQWGM0Lzd3cmQ0QVBqUDFPYjFnMjUxNlVubVJVZElDclh6S1JjTkxyRDFU?=
 =?utf-8?B?RXZHbzZRMmVqRzhBb0h0Z1Z1NkkrS0ZodzQwbFRsWXBzNm9PajI2TDNRSHQw?=
 =?utf-8?B?QlRzZ0lpeUpuTWhyUm5QWm1ZQlkwam0ycnduZk1tNk13NFYvZVJLdz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c6080b-6035-42bc-4d41-08d9cf681be3
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:50.2783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNXTGhV4Chuw2a+IDdkoMtQV7Ek34F8+WaYXUvJ0248Cg/NkZn6ciLpne9iop/5Z/xoaMwwcgTCug7M09hrP2spEpVaNZXRSTQVm4sJFcn7UowqRTmXx62S9lxRP/SCq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5499
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04-01-2022 03:09 pm, Marc Zyngier wrote:
> On Tue, 04 Jan 2022 08:53:42 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 30-11-2021 01:31 am, Marc Zyngier wrote:
>>> From: Jintack Lim <jintack.lim@linaro.org>
>>>
>>> We enable nested virtualization by setting the HCR NV and NV1 bit.
>>>
>>> When the virtual E2H bit is set, we can support EL2 register accesses
>>> via EL1 registers from the virtual EL2 by doing trap-and-emulate. A
>>> better alternative, however, is to allow the virtual EL2 to access EL2
>>> register states without trap. This can be easily achieved by not traping
>>> EL1 registers since those registers already have EL2 register states.
>>>
>>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>    arch/arm64/include/asm/kvm_arm.h |  1 +
>>>    arch/arm64/kvm/hyp/vhe/switch.c  | 38 +++++++++++++++++++++++++++++---
>>>    2 files changed, 36 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>> index 68af5509e4b0..b8a0d410035b 100644
>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>> @@ -87,6 +87,7 @@
>>>    			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
>>>    			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
>>>    			 HCR_FMO | HCR_IMO | HCR_PTW )
>>> +#define HCR_GUEST_NV_FILTER_FLAGS (HCR_ATA | HCR_API | HCR_APK | HCR_RW)
>>>    #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
>>>    #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
>>>    #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
>>> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
>>> index 57f43e607819..da80c969e623 100644
>>> --- a/arch/arm64/kvm/hyp/vhe/switch.c
>>> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
>>> @@ -36,9 +36,41 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>>>    	u64 hcr = vcpu->arch.hcr_el2;
>>>    	u64 val;
>>>    -	/* Trap VM sysreg accesses if an EL2 guest is not using
>>> VHE. */
>>> -	if (vcpu_mode_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
>>> -		hcr |= HCR_TVM | HCR_TRVM;
>>> +	if (is_hyp_ctxt(vcpu)) {
>>> +		hcr |= HCR_NV;
>>> +
>>> +		if (!vcpu_el2_e2h_is_set(vcpu)) {
>>> +			/*
>>> +			 * For a guest hypervisor on v8.0, trap and emulate
>>> +			 * the EL1 virtual memory control register accesses.
>>> +			 */
>>> +			hcr |= HCR_TVM | HCR_TRVM | HCR_NV1;
>>> +		} else {
>>> +			/*
>>> +			 * For a guest hypervisor on v8.1 (VHE), allow to
>>> +			 * access the EL1 virtual memory control registers
>>> +			 * natively. These accesses are to access EL2 register
>>> +			 * states.
>>> +			 * Note that we still need to respect the virtual
>>> +			 * HCR_EL2 state.
>>> +			 */
>>> +			u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
>>> +
>>> +			vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;
>>
>> Why HCR_RW is cleared here, May I know please?
> 
> Good question. That's clearly a leftover from an early rework. It
> really doesn't matter, as we are merging the guest's configuration
> into the host's, and the host already has HCR_EL2.RW set.

Thanks, I too felt the same.

x>
> What HCR_GUEST_NV_FILTER_FLAGS should contain is only the bits we
> don't want to deal with at this stage of the NV support. I'll fix that
> for the next round.
> 
sure, thanks.

> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat
