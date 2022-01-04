Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ACF483E81
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 09:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiADIx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 03:53:56 -0500
Received: from mail-dm6nam10on2096.outbound.protection.outlook.com ([40.107.93.96]:11136
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229473AbiADIxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 03:53:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCBxN0PoQeoPbPq6vBRDPp4E1hVBauMa/cHOD9B+/qz//G97N9vG01eQI5cmgcV0een6x+UtwUbrafB4pBxG5e0i9Xoml2j9p1NGv7Ry+/fa8N3yyeglbkXOJrMa6ktHDqOhrUaEUi/afRXGi4zW6o2K7Qn1NBnxiXmh5+dtLH/8KGneVBhiVsvYKs+dnLLpr6BF/lAhS9tylVwpVx0spTKFHWRk5yjAopquWm4tlk0jW0xdJcxUDBNsO9n768l1jU2ppEJWD/KEW60s5v+Vtmjo4BQs95ui61UtjlGXhftOGi3zGceyXQZsfqLdOiSzy+vKJsbm1vwdyNYPSZTyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0OfTO4wAjVQ5r4PeLYAtxC7j1RWC/dWcZZcBQr6wZI=;
 b=Z2+ZsVJWhT4xFjib1DyqiyvtceEjOhKYFSzj34Hnp8j1wEOTY3Mm1xoqc5/nu4VnLyod3LNPk3xshp8aesmEOBBPlQlS15Nj026c5FwRE3a1gsWDEMNr1O079OeyIcYYVt44qVEmxzf60QUvKNEcGFdZdEFrwY+kGN2wpEt4oqks+Br6H6eBDXqD2Fl4stxrmZGr1ZMyBxlGHxtpsH7X/+gY2BF9cNWslMysiMGMzY3iWrfnnAM9/9SEhTvWbdV7NsSa0WqXxqdntsXcAmPbgx3vu1oAYpcAqGAj28O8OcoMhi7aMBLvVrL7pvVs0qIO+hbd01VWNBC7HwHcX5vtTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0OfTO4wAjVQ5r4PeLYAtxC7j1RWC/dWcZZcBQr6wZI=;
 b=ZvOPXtp07THHHcPjawAAcHraptPymI35U3PHC/WVeJBxqA9gB0beYoHt6J7pLXNQGbsynuJVWlisgScU5GAuwgmfU6JpHYnPRtF4s+f1xjyuQj2pCHANUCw7wspoAQ4k8k8kK1B3g/BUapzHFjpRkgnhKU3FMp8Y4UhZKjK7jU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from CH0PR01MB6826.prod.exchangelabs.com (2603:10b6:610:ed::18) by
 CH2PR01MB5717.prod.exchangelabs.com (2603:10b6:610:40::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.14; Tue, 4 Jan 2022 08:53:51 +0000
Received: from CH0PR01MB6826.prod.exchangelabs.com
 ([fe80::c878:6ac:8f42:1c68]) by CH0PR01MB6826.prod.exchangelabs.com
 ([fe80::c878:6ac:8f42:1c68%5]) with mapi id 15.20.4844.015; Tue, 4 Jan 2022
 08:53:50 +0000
Message-ID: <bbf31da5-ca1b-7499-e23c-9b5281ca7901@os.amperecomputing.com>
Date:   Tue, 4 Jan 2022 14:23:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 34/69] KVM: arm64: nv: Configure HCR_EL2 for nested
 virtualization
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-35-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-35-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY4PR18CA0035.namprd18.prod.outlook.com
 (2603:10b6:903:9a::21) To CH0PR01MB6826.prod.exchangelabs.com
 (2603:10b6:610:ed::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a6566fb-424b-4c6b-210c-08d9cf5fba67
X-MS-TrafficTypeDiagnostic: CH2PR01MB5717:EE_
X-Microsoft-Antispam-PRVS: <CH2PR01MB57178BC49A775AD29A4F550A9C4A9@CH2PR01MB5717.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Ae8BRk2SbWSsa8LorN9GChzm7q0u/10opdqrqP3uzohSsLwmr5etjoqMJYiXzWq2BJ6iLv/kxvbKY/fgsPDN7CJL/PcnFiZR1EKmRchTeg9l/8MP2l8oFk30+W4LLuR8pSISGJ+lrHkUbapU3NIXiQLXVNtFL0SvtYaEnQb+SM95TIhyChC//m/UkReX1E5CupAVWjPuVa+kWJPcTMBIIHeZWnZdVUu9+1nHIkmMGfybH6jXlli3y64UcJ2o9QJF22ad3kpsnAwXob/lYLNb9UPXYH2q6y/Yncf+08G9Yj7lGN5meFUxBoZs9SUbtEgAu7NOs+xZcZWgMFIe2txUgdB0bnejisFCZLDthRPqJsa/FMO1RfTJ5wsqDDRGDPlpIEKN4ZxHRVv4z47yJeHjwlZaUG+hA5Plo+YkkFkzHVMa6pDlkZZLyA6Ik/O3zidKE83yosdt2PpG6HIiCju+0kRx+6nxb0poaqT8Jg/hY73g0CRa/FGZvMgCRagWNWjUIc+0oGXjjauNepcLOx1B2Zzg3gTeGyZhaiwmr6+NedFukwIpg3G8OIXCg+CgOOBZJaxYJiVE/TdelHt8yvMyckcUltnnbrvFnu3ya9PQA9o5NqxTQ8gXDay253xvMQP0dtSzDjhxWbInYt+sSiXNtdxdv5tQV0aDipiKKwffK37ksQbbuJyIs5D/eLb/i1ypN3qNDWKgFhZoc0KPKS359UsPjcpsh/zvgugFz4s8Mw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6826.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(53546011)(508600001)(54906003)(6666004)(52116002)(26005)(5660300002)(66946007)(8676002)(8936002)(6486002)(31686004)(66556008)(6506007)(186003)(66476007)(7416002)(4326008)(2906002)(6512007)(31696002)(2616005)(38350700002)(38100700002)(316002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1k4Tmtvait3MTJUbGs5NGRpSlJQNW5YUndPZDJDYVNYc1BOYlRDdWVlN3k2?=
 =?utf-8?B?VkhFMzFnSUJtL2ZBR3ZwZGVEWXpLT3pFeVNZNEhjd0pVRGxnUExoMEpzUHQ5?=
 =?utf-8?B?SDlhRkw0Y21TODJCMThUWWpBaE1Gam14K0pHRTdyeHFZbDlWWnNHbFNaZ2p0?=
 =?utf-8?B?L2IwWXo3TW45WS9KanZ3L0NwdWZJb2VVMGlHNGZsaUluMEV5bm9xcFk0MHdM?=
 =?utf-8?B?N28rcmlPTkwvMk9hTzJNYWJ4ajBVL0l4TVc5YzhDaUNXczFMMW91SVV1SlVH?=
 =?utf-8?B?Y1plaXhFenZSNWh4MHkwd0pmdXZhdkFYVlFVbFd1dXZMMkFqaFJOc25VcldD?=
 =?utf-8?B?a2dvMVlEdGFrejFsNVhKcHZGbFU0VVpvMERwZDJZWEJtUUJBVVhYajJLV3Bw?=
 =?utf-8?B?T1kyU3lCZHBNRmtMY2h2OFJBZlJFY01TN0FRYkYya09wdUpKaUNiS1BVY0NB?=
 =?utf-8?B?KzhQbk9ubGl6enJCRWpLQVMvVUxoS3NxdlI2aVpreHNINUdVbzNSQUpWTmZu?=
 =?utf-8?B?SFQvc3Q0YWNIRmMzN1BncERKRzFHTWRlTGdaNmFpeWoyUndFNmgybERCZVNX?=
 =?utf-8?B?SzJYWXVSZitMbUYxMWRWRFNacllrM3BuVHlxR2xnVTFSTFNLMG5Jc3YrRXhp?=
 =?utf-8?B?L2U0NVQ4VDBoOStHUTdpZFV4UTlWMk44ajVNSStKUXY5enVaeGxBV1NWWkJz?=
 =?utf-8?B?VW9EN3J3TFlzeDJJRmwwc1Q1RlJOdFd3V1pKa1FYWk5yT2dDVkQ1T1laYitR?=
 =?utf-8?B?V0pvOVM3K1RodHltRXpUVGt2Mk8ybmRLNUNHV2ZWdDhrc01WRk56QjhINXFz?=
 =?utf-8?B?YmV5OHE4cm5xWWN4WEJEZ2FNcm1WVE9QeHJjZ3c4L2xmaWhjYTFEbFVFQmM5?=
 =?utf-8?B?UE8yWS96d1VTOXFqTDdtczRVUktnYm1lVFVlZkhjWVFPOFhIcnZRZUhqeTA2?=
 =?utf-8?B?WjM3dENRUWFQNlNpL3lDeFU1aTU2UzVxUHRFV0QrY0pGRmRmd09Ldm1CWnYz?=
 =?utf-8?B?d2ZrSktzLzVpZGJUMVF0dHR2TCthcVRQOUdrMUt2VDZSZnlzUTFxMTlHaXNJ?=
 =?utf-8?B?RDQwTDM4a3ZTUzRDYy9LSTJtbzIrZlV5VkFHZHBoSGlZSjA4dFZYVkd1TTNL?=
 =?utf-8?B?OU1UbldrTkdxNGpwd3gzNDJSSFVpOGVOYk9CY28xb2dqZHJadmRYK0FqTGpY?=
 =?utf-8?B?clZXSkl4MWpFbmVydXl3ZG1uNVd3MXNXODgrSWxiaUxnREVRcWhsRTNRNFJ2?=
 =?utf-8?B?RWx5VUxNZGNOdDZDUmlnSlFPbjRTQ3dTRGl4dW5vSnhjWno1YlNyTE42TzE1?=
 =?utf-8?B?UGFIdEFJK3Qyc01PZkxIbllPWkRnOCtwOFpQYU9pWGNQNUVPcUQyTkNyblpQ?=
 =?utf-8?B?WHBkTWRYeXcxUEF5czNpWkw3VnU5UlRyYkREWmk4TGIrV3NzdFIxOE5WaER5?=
 =?utf-8?B?S1VhSlo0YUtiblZwYVdXNTdmdTRvcGExRWVRTmVEY2tTMHViZURoa053dkM4?=
 =?utf-8?B?M2pkQkVUeWM3RzNUNEdMWjN1TngvbzRlTGM3Z3NsZHlLUkc1U2pEYkpsNVRa?=
 =?utf-8?B?dU8xM1NjVmhhQWdIZXdBS1Fsb2J5K25oMkpwOXgvc2lPSURlVUNuQzlNV3ZL?=
 =?utf-8?B?U2Fvd0RrM0hnRWVtcXlUckdUQVloQzVUeTNMM3prZDNBUnYzWUJTSnFCUVMv?=
 =?utf-8?B?TGVOdlgyOUwxODZVV0VLM2FaWUcrenhNSHBPYTMyQ0RmSEc2YTI5OGg0bzVm?=
 =?utf-8?B?ekRSTi9UN2V5L1d6d1hoeE5KdXpRNTUrZDFLQVdRNXg0Y1pKR1NOQnAwYVVq?=
 =?utf-8?B?TG1INWFsenpQclA3THAyTVkwWktCWFlnZ3pkOWR0aVRHcjBMbTFyV2FKVUZ0?=
 =?utf-8?B?NGlRQ0ZIOG94UUdEVjdITHhOYkI1dkpiYWFJVGpDS1hwNkhmQWxVUUpmWWo5?=
 =?utf-8?B?ZjBWUzNqRThFYXlHbHZjanV3SmJxODdEVzFtcksxVmw1dU51ZE1waU1INk81?=
 =?utf-8?B?T0RyOWlESldvb2grRlM1ODRnSmlsT3c3SHNoZnVtTStjTnpFZXA3Nnl0bkpv?=
 =?utf-8?B?ZGdQbWNCaGFIYVNKcGlwNlQ1djl6Z3JsbmVOT3VmVmZRMEM0eE9uNWVyQzJ1?=
 =?utf-8?B?b2l4cmpWS3h2NUEvNjc0VHlPcW1UNXhkTVJvalpnRTJyUFdFcFI3cVlaMmVN?=
 =?utf-8?B?a2EwdG5tbFZHclQrUXdJYmtCNUh2OFRmV0FkQ1djeUdEM3VnaHgvWVo3bmtD?=
 =?utf-8?B?WGNQbkd1Q0xSYWMvQjcwY2N3QUsxUE5Sc3h3SVBMTUdGNmJsSW94ZWtkRkJI?=
 =?utf-8?B?eDlLVGgvVWMzZmhwOUM4MGc3N2wyVjN5TmlvdWVvQWc3dmFSbUdOQT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6566fb-424b-4c6b-210c-08d9cf5fba67
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6826.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 08:53:50.8298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uR1tRfxv39n2RXJK+ZAWb1u04LT1rbo7akNvLmGS1Q8vxQr+UyK0zT8E5cPMBCvi75yGfNIf4ces8LL20oB6UrA1ReMvlZGF1gD3D88mwjD/1pJeJtSvsacm8cvUwzMr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB5717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30-11-2021 01:31 am, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> We enable nested virtualization by setting the HCR NV and NV1 bit.
> 
> When the virtual E2H bit is set, we can support EL2 register accesses
> via EL1 registers from the virtual EL2 by doing trap-and-emulate. A
> better alternative, however, is to allow the virtual EL2 to access EL2
> register states without trap. This can be easily achieved by not traping
> EL1 registers since those registers already have EL2 register states.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_arm.h |  1 +
>   arch/arm64/kvm/hyp/vhe/switch.c  | 38 +++++++++++++++++++++++++++++---
>   2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 68af5509e4b0..b8a0d410035b 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -87,6 +87,7 @@
>   			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
>   			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
>   			 HCR_FMO | HCR_IMO | HCR_PTW )
> +#define HCR_GUEST_NV_FILTER_FLAGS (HCR_ATA | HCR_API | HCR_APK | HCR_RW)
>   #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
>   #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
>   #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 57f43e607819..da80c969e623 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -36,9 +36,41 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>   	u64 hcr = vcpu->arch.hcr_el2;
>   	u64 val;
>   
> -	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
> -	if (vcpu_mode_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
> -		hcr |= HCR_TVM | HCR_TRVM;
> +	if (is_hyp_ctxt(vcpu)) {
> +		hcr |= HCR_NV;
> +
> +		if (!vcpu_el2_e2h_is_set(vcpu)) {
> +			/*
> +			 * For a guest hypervisor on v8.0, trap and emulate
> +			 * the EL1 virtual memory control register accesses.
> +			 */
> +			hcr |= HCR_TVM | HCR_TRVM | HCR_NV1;
> +		} else {
> +			/*
> +			 * For a guest hypervisor on v8.1 (VHE), allow to
> +			 * access the EL1 virtual memory control registers
> +			 * natively. These accesses are to access EL2 register
> +			 * states.
> +			 * Note that we still need to respect the virtual
> +			 * HCR_EL2 state.
> +			 */
> +			u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
> +
> +			vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;

Why HCR_RW is cleared here, May I know please?

> +
> +			/*
> +			 * We already set TVM to handle set/way cache maint
> +			 * ops traps, this somewhat collides with the nested
> +			 * virt trapping for nVHE. So turn this off for now
> +			 * here, in the hope that VHE guests won't ever do this.
> +			 * TODO: find out whether it's worth to support both
> +			 * cases at the same time.
> +			 */
> +			hcr &= ~HCR_TVM;
> +
> +			hcr |= vhcr_el2 & (HCR_TVM | HCR_TRVM);
> +		}
> +	}
>   
>   	___activate_traps(vcpu, hcr);
>   

Thanks,
Ganapat

