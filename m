Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6A94924B0
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiARLYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:24:21 -0500
Received: from mail-bn7nam10on2118.outbound.protection.outlook.com ([40.107.92.118]:18753
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239460AbiARLYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:24:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVVUhUXeAngwEMG60aQW+EY3iKbNR/2/CoFJ7WfUo1sL9Rij5lN7je7t4Bfu/1DCoyBrfec5HxWaA1xpRDJ3znMy0hozAV+B0F2bAw3JG/zAzNNWHSvHEppH1QQl3WIxG4M3Q0h1W4WScCkcV1XKkIohrW+R8Bj+TqW3np5XGrkzZdopqqVb5+T2fsFWjaYFuk1spAa2Q5/V84BxyhZlobqaOhWODR+kecLgzcX1wVg52rm64Hr2XnGf35yFkPyUo9eAdUZ1aPoAyzeCy5oyCIKLpp9KfGgPCvTSV/c3j2sPuXb/30XyJsG9JEbRIhYsaIv4jBPe3ytrsaby4MOAoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9Eg/KsTduz89TTa5gQ4eF73hv+eYql9ZgFjz/Ih+oQ=;
 b=GI0543Zm8TrhigHltUIWsVLHoZv71teptfxB+i/stwo9xasUKfF+DYrqs3bVhwVS7ikBugwBtX1Nfwntk4hqbA+1cp4nnVhIFWa/Vabf8rIvI814gmarKeYSkz3Tjfo0RV7B6YIklvNmfmHSLILPpbpYFiA8kdq4IiV8y+P2EYs3yBiC3adIfa8vPRJKtcttdXTJzq6hLwzr4x1Z0Tt+HpzrtYXZ35s6DWpsubP2DrGi+UOxABALXtd84qgFLU6czh8chy5aAngYqlHkZNZhkYNHt+6oBKeluedjgzp850V3hol3NAuOhqaseWJYq+EohnU0uxUDWmcqCkj/XOqwUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9Eg/KsTduz89TTa5gQ4eF73hv+eYql9ZgFjz/Ih+oQ=;
 b=T7utxbWblnFZC0a+Bj/2Zh4ZVPxUwItC/d/YPC1yJ9vqZ99j86ClAjJ2TQzISFn9xdR22UoS808uKwgXi+d+ykO7Nh2dbCO0egG74WDVoYy4+X2cHF8ZSMWDXROD3WlRtZrGO9VDIColu/WifyjEgWZhFiWqn2NLm5E4qoz2erA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 BN0PR01MB6957.prod.exchangelabs.com (2603:10b6:408:16c::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.13; Tue, 18 Jan 2022 11:24:15 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 11:24:14 +0000
Message-ID: <21b0fca8-6b31-dc63-7637-2f80c4b3a272@os.amperecomputing.com>
Date:   Tue, 18 Jan 2022 16:54:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 38/69] KVM: arm64: nv: Support multiple nested Stage-2
 mmu structures
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
 <20211129200150.351436-39-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-39-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:610:e4::7) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81bf0d4a-cb28-47c6-d791-08d9da750e75
X-MS-TrafficTypeDiagnostic: BN0PR01MB6957:EE_
X-Microsoft-Antispam-PRVS: <BN0PR01MB6957B8614C20DE85C3621ACE9C589@BN0PR01MB6957.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: taVwbVGeVg55cOC6zJBq0L5tSkRViypRQBFNmhBvRLDmFlJ84cQf7poP86O8zZOsBIDCj3ZTHzhZXgB+nAkaM+hTaT+OxJzYrX3N82TmzqQsGtftX5NYZ79uYfrARMu9vPi1TTMJYXRgxzUyXyBrZdkFnVT3uftuRJg77nUUnJWzMSyEqmNQLavxxO2pYf71ljXNHdYlrsQ0xjyh8WsRIS8fgKmKniUrEcPcDd7YVuNK36F5tZHRY6TmnI7j0n92n7GCCnjsUmm9B5IBHcffVrol+j4jcyI1MW7/yUW4d9y1Lt5uJhb0y+ZWunZ6q5avgdQmFgx+9eUcJeMhQWK/mdyQdw/HunyQlTuvAQrJoyFsHmAAbwYJGAnX4Q+iSUwz4kz4hZMi6v09WmA3VY8yD5fnmBST6qySnPssy14maGnjOVcV5mxSW98/T4g5XvZh25wn86HbTboohvb2zME8yP7Nt0LsznUErrM12TlJaDRoJx8m4a8EHVEM+ZrCVVJ3FS18/iXkMUz+iaIRCmF+qL42qVG/AXpHhC44JSMaJBIKsoV/5Ikdb3a4ljP+xfJkCzSlrMoDzb6ZloreEHhUFisZAFKHMm5EPz6+jz0hRHduSOldln5iRumLqbwjDGtKtJChm0srG8KT0pfb+BaXjP7dWvRWEYRnhbPFYYsOZ3PWSyF0Z2GpFofj5yNriJfxsP7ZSqDxLIXc3rvqb1aFy7cpFUT3EsfRTPuCkorlHgw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(316002)(66476007)(66946007)(66556008)(508600001)(26005)(31696002)(83380400001)(31686004)(7416002)(38350700002)(38100700002)(186003)(2906002)(4326008)(6486002)(5660300002)(2616005)(6512007)(54906003)(30864003)(53546011)(6506007)(86362001)(8676002)(52116002)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGNJNkVEV1k2M2M1SjhWSVFZTmdGSHhtYXQ1OGh4SlRKa3RWR1d5cFpxWWt4?=
 =?utf-8?B?Wm9aMEN1WnM1UmtZSUJpWHRvZW9iM2ozQ1E5NXVoUmlqTC9IQVVocmZWZVVi?=
 =?utf-8?B?ajRQbnMxcS9yMmkxdUE3K3hxNE9sd0hvZVMzUEo3MTJUTU5iQlVCSTByOFJS?=
 =?utf-8?B?UkkzalVDWkl5dTA1UFpXRXh0b2JGaDVQL2c2dCtsbyt1RVVQdERsNzBIM0hU?=
 =?utf-8?B?a1prc05vL0djcDFYMjJlc25hbmhlQlJHQjlvU1pMWXFuYXl2ZHJnYlZyN29F?=
 =?utf-8?B?b0R5U3Qya04yRVNEemZPd2VCL0RnUnFqKzlncDExa1ovUWpSaER1WGlWblox?=
 =?utf-8?B?cW9ub1hHLzdvVmRrcWZrdlR3YnIwanFFeDg5L1NMTTF2cU9kVkphWWFNNFVR?=
 =?utf-8?B?OEJUbWY1RHdHU1VJallJeTNmL2xFTi9VQVlySStqZ0hhb0VENFM4aUd5RGNX?=
 =?utf-8?B?QlhXZENKTnpQTksvUmlxQ0I5M0RaYnBuU2ZhVWZ3MGVMc0FoSkdwT0lUdDd1?=
 =?utf-8?B?WUQzYmo4aUVUWmx4SDBhUGtSOGo3Q01DSngwOWNYS1M3Lzc1dDdNNmd4bjNp?=
 =?utf-8?B?a3JKWThidzdjWTlUS295Z0hJRnk2K01RcnF1YnNYMnNuK1IveHRGZHNuVVlj?=
 =?utf-8?B?Nkh5d3h2NFNSbDhZN1ZUYlpaeElrOFJCeEF5WUc5M2w5dWU5V2RZbGdKN2hy?=
 =?utf-8?B?dHlqRVdvRm1LWFYzbldKbUFneGp2TjhpdmpGNWUxUkxPbDZrNmhtNHJQUlhU?=
 =?utf-8?B?Yko3dGtEbDFSNnpUM2tzKzRNdTgxL2hSQ3BhRWI2UFVxNjVKWnhNUWhneS81?=
 =?utf-8?B?alUxdjFhRld3UEltVDhQM0RyQkg3Nnh2ZjNoQmhGTTk3TVBaV3A1bHpEWVAw?=
 =?utf-8?B?QVdPaUpGaFhLMmd3KzZHSnNlZmhhOCtzNGZDczhaR1REcjFvM0xKTGh5T015?=
 =?utf-8?B?T2F1Tm5mcEFyWVlZMXhHZzVaZDIzb21tNXVYRW9nRFFnNHpyYlhSeDVXamU3?=
 =?utf-8?B?U1NXb2tiUE84enV0cVpEeEc0QmY1NW9zL2Q5MEQwNXlleHNlZDhIanVMbmVp?=
 =?utf-8?B?RFV3bzUwWjFRSEIwTmtwUFVickhNNDdxUzRqUklnem5tUzdaMWVTaW14ODZo?=
 =?utf-8?B?OUVqVEV3RzN4L2xLODc3MGFqYldwTzRMOUkyTUNpUUs3Z3UwdVVsUlJQR2lm?=
 =?utf-8?B?TXhBVnRZTzlmRlpFZE9OeWxMaXdVVzhLY0ZQU29DWlR4MzZnODRYZnREdmJ1?=
 =?utf-8?B?RXNEQk1tOE02MVpqaFdnZ1VBZzloTVdPZ0pnZlVaSmxVcXFIV085RHAyZXJZ?=
 =?utf-8?B?MXI3ZjJMSWl0TG5IdmdkOXNnNFB6RlBDV1B0UDFBNEkyVUhjVERnYUpYb0Ry?=
 =?utf-8?B?NHpLajV1a3p5eGo1WVp4NXBVT3dBdGlSNVhybEFMaXZTTlNLa0hNRXcvV0xB?=
 =?utf-8?B?b3pkWVRhN0dVK29IYmxMTGcrWHZILzJTdE96dWFIV0FLMFo2c3VqUFRFUDcz?=
 =?utf-8?B?K3J6MjJiZXVINm1HTEVqcWhtRFpUaVhSSTdpK3hjN250ODZsT1NINzFXblc1?=
 =?utf-8?B?a2FIODVtbkVkbW01SnN1WEFkK2tQdDNqQ3JSMGUrbFp2VXlucWEwdFJmaThD?=
 =?utf-8?B?U2xGVEZzM253Zlo4NzdJazFlaXU1TGh0akU3V2JYYnFRYzZadzByVDBLcGE5?=
 =?utf-8?B?QjdXUWdDM096RXBpTno3dCs2aVhoR0V6VmJmRkR1Z2FJbWFIL3pWVVR0VGdy?=
 =?utf-8?B?d0RYd1JyQWJ0QktpYkJ2Y3h0dlBycXlGS2ROVjdTT3ZwMGtEZHB2ZVdIbE1X?=
 =?utf-8?B?cXhoRXNnUEkweDkxQmUzeC9wRksvYVZjUjBNUnBjVTVRRWNzS01rYkVIN0Fv?=
 =?utf-8?B?Z0RleEVMUkNyZWpQRWcrMmQ5S200eWMvZ0t4MmhUMkx0UkxkQjVSZGJmVm5L?=
 =?utf-8?B?MVIrL2Z3OTBUWmFheGNJNEsvZjIxbllIYndvRWFBakQxMlgxcUFQVWovMmtj?=
 =?utf-8?B?SDNxK2lpMit5eTUyTkh0aTE3eU5hVnMxWjhBVUYyT0xmNlF5cW9pYXE3OGhk?=
 =?utf-8?B?TlMyZ0dBekJFMHZLUkg3WEZGT043MVNTUDNrRFFESjdoWFBIVUlvU2xrRkNZ?=
 =?utf-8?B?bGcwNFlyWDBYUE8vdWFOTlZ0SGtBUlc4S2hKWi9FVTdCSDFZakh5TXJJcUdG?=
 =?utf-8?B?NnJzc1VMVjRlNU5xWTZyUjVTZGdJaW5lUUlVTEY4Q2dHbE04VEEwdUxNSnY3?=
 =?utf-8?B?SHNKeUljdGhkS1BZUUZ0YkR0WUUxengxbUo4bnMxOEg5d25MWkdMYXVnVUQ3?=
 =?utf-8?B?MEx4Mkk0b1R5N29XNkllc2VKYjdRSnAwZUJPOXN6SitpWEdORDBCZz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81bf0d4a-cb28-47c6-d791-08d9da750e75
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:24:14.0768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xL7e74LhA0GDmJN4o/E93AMU3gABvwMxKyIeGxpSmYYSv8I26hGqKYRkpx5k1OrE9VJgc6VR2em/KSpBm/I4wg6/LQkWo+NfqEtsk6faJITOxICWr5CwLus9ViiwiWB+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6957
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30-11-2021 01:31 am, Marc Zyngier wrote:
> Add Stage-2 mmu data structures for virtual EL2 and for nested guests.
> We don't yet populate shadow Stage-2 page tables, but we now have a
> framework for getting to a shadow Stage-2 pgd.
> 
> We allocate twice the number of vcpus as Stage-2 mmu structures because
> that's sufficient for each vcpu running two translation regimes without
> having to flush the Stage-2 page tables.
> 
> Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h   |  29 +++++
>   arch/arm64/include/asm/kvm_mmu.h    |   9 ++
>   arch/arm64/include/asm/kvm_nested.h |   7 +
>   arch/arm64/kvm/arm.c                |  16 ++-
>   arch/arm64/kvm/mmu.c                |  29 +++--
>   arch/arm64/kvm/nested.c             | 195 ++++++++++++++++++++++++++++
>   6 files changed, 275 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 6a7b13edc5cb..00c3366129b8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -102,14 +102,43 @@ struct kvm_s2_mmu {
>   	int __percpu *last_vcpu_ran;
>   
>   	struct kvm_arch *arch;
> +
> +	/*
> +	 * For a shadow stage-2 MMU, the virtual vttbr programmed by the guest
> +	 * hypervisor.  Unused for kvm_arch->mmu. Set to 1 when the structure
> +	 * contains no valid information.
> +	 */
> +	u64	vttbr;
> +
> +	/* true when this represents a nested context where virtual HCR_EL2.VM == 1 */
> +	bool	nested_stage2_enabled;
> +
> +	/*
> +	 *  0: Nobody is currently using this, check vttbr for validity
> +	 * >0: Somebody is actively using this.
> +	 */
> +	atomic_t refcnt;
>   };
>   
> +static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
> +{
> +	return !(mmu->vttbr & 1);
> +}
> +
>   struct kvm_arch_memory_slot {
>   };
>   
>   struct kvm_arch {
>   	struct kvm_s2_mmu mmu;
>   
> +	/*
> +	 * Stage 2 paging stage for VMs with nested virtual using a virtual
> +	 * VMID.
> +	 */
> +	struct kvm_s2_mmu *nested_mmus;
> +	size_t nested_mmus_size;
> +	int nested_mmus_next;
> +
>   	/* VTCR_EL2 value for this VM */
>   	u64    vtcr;
>   
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index c018c7b40761..7250594e3d68 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -116,6 +116,7 @@ alternative_cb_end
>   #include <asm/cacheflush.h>
>   #include <asm/mmu_context.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>   
>   void kvm_update_va_mask(struct alt_instr *alt,
>   			__le32 *origptr, __le32 *updptr, int nr_inst);
> @@ -159,6 +160,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>   			     void **haddr);
>   void free_hyp_pgds(void);
>   
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>   void stage2_unmap_vm(struct kvm *kvm);
>   int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
> @@ -294,5 +296,12 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>   {
>   	return container_of(mmu->arch, struct kvm, arch);
>   }
> +
> +static inline u64 get_vmid(u64 vttbr)
> +{
> +	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
> +		VTTBR_VMID_SHIFT;
> +}
> +
>   #endif /* __ASSEMBLY__ */
>   #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 026ddaad972c..473ecd1d60d0 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -61,6 +61,13 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
>   		(cnthctl & (CNTHCTL_EVNTI | CNTHCTL_EVNTDIR | CNTHCTL_EVNTEN)));
>   }
>   
> +extern void kvm_init_nested(struct kvm *kvm);
> +extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
> +extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
> +extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
> +extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
> +extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
> +
>   int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>   extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>   			    u64 control_bit);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 68da54d58cd0..1dbf63319b99 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -37,6 +37,7 @@
>   #include <asm/kvm_arm.h>
>   #include <asm/kvm_asm.h>
>   #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>   #include <asm/kvm_emulate.h>
>   #include <asm/sections.h>
>   
> @@ -146,6 +147,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (ret)
>   		return ret;
>   
> +	kvm_init_nested(kvm);
> +
>   	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
>   	if (ret)
>   		goto out_free_stage2_pgd;
> @@ -389,6 +392,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	struct kvm_s2_mmu *mmu;
>   	int *last_ran;
>   
> +	if (nested_virt_in_use(vcpu))
> +		kvm_vcpu_load_hw_mmu(vcpu);
> +
>   	mmu = vcpu->arch.hw_mmu;
>   	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
>   
> @@ -437,6 +443,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   	kvm_vgic_put(vcpu);
>   	kvm_vcpu_pmu_restore_host(vcpu);
>   
> +	if (nested_virt_in_use(vcpu))
> +		kvm_vcpu_put_hw_mmu(vcpu);
> +
>   	vcpu->cpu = -1;
>   }
>   
> @@ -1088,8 +1097,13 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>   
>   	vcpu->arch.target = phys_target;
>   
> +	/* Prepare for nested if required */
> +	ret = kvm_vcpu_init_nested(vcpu);
> +
>   	/* Now we know what it is, we can reset it. */
> -	ret = kvm_reset_vcpu(vcpu);
> +	if (!ret)
> +		ret = kvm_reset_vcpu(vcpu);
> +
>   	if (ret) {
>   		vcpu->arch.target = -1;
>   		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9eec548fccd1..ab1653b8e601 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -162,7 +162,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * does.
>    */
>   /**
> - * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
> + * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
>    * @mmu:   The KVM stage-2 MMU pointer
>    * @start: The intermediate physical base address of the range to unmap
>    * @size:  The size of the area to unmap
> @@ -185,7 +185,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   				   may_block));
>   }
>   
> -static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>   {
>   	__unmap_stage2_range(mmu, start, size, true);
>   }
> @@ -507,7 +507,20 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>   	int cpu, err;
>   	struct kvm_pgtable *pgt;
>   
> +	/*
> +	 * If we already have our page tables in place, and that the
> +	 * MMU context is the canonical one, we have a bug somewhere,
> +	 * as this is only supposed to ever happen once per VM.
> +	 *
> +	 * Otherwise, we're building nested page tables, and that's
> +	 * probably because userspace called KVM_ARM_VCPU_INIT more
> +	 * than once on the same vcpu. Since that's actually legal,
> +	 * don't kick a fuss and leave gracefully.
> +	 */
>   	if (mmu->pgt != NULL) {
> +		if (&kvm->arch.mmu != mmu)
> +			return 0;
> +
>   		kvm_err("kvm_arch already initialized?\n");
>   		return -EINVAL;
>   	}
> @@ -533,6 +546,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>   	mmu->pgt = pgt;
>   	mmu->pgd_phys = __pa(pgt->pgd);
>   	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
> +
> +	kvm_init_nested_s2_mmu(mmu);
> +
>   	return 0;
>   
>   out_destroy_pgtable:
> @@ -578,7 +594,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>   
>   		if (!(vma->vm_flags & VM_PFNMAP)) {
>   			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
> -			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
> +			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
>   		}
>   		hva = vm_end;
>   	} while (hva < reg_end);
> @@ -1556,11 +1572,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>   {
>   }
>   
> -void kvm_arch_flush_shadow_all(struct kvm *kvm)
> -{
> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
> -}
> -
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot)
>   {
> @@ -1568,7 +1579,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   	phys_addr_t size = slot->npages << PAGE_SHIFT;
>   
>   	spin_lock(&kvm->mmu_lock);
> -	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> +	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
>   	spin_unlock(&kvm->mmu_lock);
>   }
>   
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 19b674983e13..b034a2343374 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -19,12 +19,189 @@
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm_arm.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_nested.h>
>   #include <asm/sysreg.h>
>   
>   #include "sys_regs.h"
>   
> +void kvm_init_nested(struct kvm *kvm)
> +{
> +	kvm->arch.nested_mmus = NULL;
> +	kvm->arch.nested_mmus_size = 0;
> +}
> +
> +int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_s2_mmu *tmp;
> +	int num_mmus;
> +	int ret = -ENOMEM;
> +
> +	if (!test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features))
> +		return 0;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	/*
> +	 * Let's treat memory allocation failures as benign: If we fail to
> +	 * allocate anything, return an error and keep the allocated array
> +	 * alive. Userspace may try to recover by intializing the vcpu
> +	 * again, and there is no reason to affect the whole VM for this.
> +	 */
> +	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
> +	tmp = krealloc(kvm->arch.nested_mmus,
> +		       num_mmus * sizeof(*kvm->arch.nested_mmus),
> +		       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (tmp) {
> +		/*
> +		 * If we went through a realocation, adjust the MMU
> +		 * back-pointers in the previously initialised
> +		 * pg_table structures.
> +		 */
> +		if (kvm->arch.nested_mmus != tmp) {
> +			int i;
> +
> +			for (i = 0; i < num_mmus - 2; i++)
> +				tmp[i].pgt->mmu = &tmp[i];
> +		}
> +
> +		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
> +		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
> +			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
> +			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
> +		} else {
> +			kvm->arch.nested_mmus_size = num_mmus;
> +			ret = 0;
> +		}
> +
> +		kvm->arch.nested_mmus = tmp;
> +	}
> +
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}
> +
> +/* Must be called with kvm->lock held */
> +struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
> +{
> +	bool nested_stage2_enabled = hcr & HCR_VM;
> +	int i;
> +
> +	/* Don't consider the CnP bit for the vttbr match */
> +	vttbr = vttbr & ~VTTBR_CNP_BIT;
> +
> +	/*
> +	 * Two possibilities when looking up a S2 MMU context:
> +	 *
> +	 * - either S2 is enabled in the guest, and we need a context that
> +         *   is S2-enabled and matches the full VTTBR (VMID+BADDR), which
> +         *   makes it safe from a TLB conflict perspective (a broken guest
> +         *   won't be able to generate them),
> +	 *
> +	 * - or S2 is disabled, and we need a context that is S2-disabled
> +         *   and matches the VMID only, as all TLBs are tagged by VMID even
> +         *   if S2 translation is enabled.

I think you were intended to say "if S2 translation is disabled".
> +	 */
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		if (nested_stage2_enabled &&
> +		    mmu->nested_stage2_enabled &&
> +		    vttbr == mmu->vttbr)
> +			return mmu;
> +
> +		if (!nested_stage2_enabled &&
> +		    !mmu->nested_stage2_enabled &&
> +		    get_vmid(vttbr) == get_vmid(mmu->vttbr))
> +			return mmu;
> +	}
> +	return NULL;
> +}
> +
> +static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
> +	u64 hcr= vcpu_read_sys_reg(vcpu, HCR_EL2);
> +	struct kvm_s2_mmu *s2_mmu;
> +	int i;
> +
> +	s2_mmu = lookup_s2_mmu(kvm, vttbr, hcr);
> +	if (s2_mmu)
> +		goto out;
> +
> +	/*
> +	 * Make sure we don't always search from the same point, or we
> +	 * will always reuse a potentially active context, leaving
> +	 * free contexts unused.
> +	 */
> +	for (i = kvm->arch.nested_mmus_next;
> +	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
> +	     i++) {
> +		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> +
> +		if (atomic_read(&s2_mmu->refcnt) == 0)
> +			break;
> +	}
> +	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
> +
> +	/* Set the scene for the next search */
> +	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
> +
> +	if (kvm_s2_mmu_valid(s2_mmu)) {
> +		/* Clear the old state */
> +		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
> +		if (s2_mmu->vmid.vmid_gen)
> +			kvm_call_hyp(__kvm_tlb_flush_vmid, s2_mmu);
> +	}
> +
> +	/*
> +	 * The virtual VMID (modulo CnP) will be used as a key when matching
> +	 * an existing kvm_s2_mmu.
> +	 */
> +	s2_mmu->vttbr = vttbr & ~VTTBR_CNP_BIT;
> +	s2_mmu->nested_stage2_enabled = hcr & HCR_VM;
> +
> +out:
> +	atomic_inc(&s2_mmu->refcnt);
> +	return s2_mmu;
> +}
> +
> +void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
> +{
> +	mmu->vttbr = 1;
> +	mmu->nested_stage2_enabled = false;
> +	atomic_set(&mmu->refcnt, 0);
> +}
> +
> +void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +	if (is_hyp_ctxt(vcpu)) {
> +		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
> +	} else {
> +		spin_lock(&vcpu->kvm->mmu_lock);
> +		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
> +		spin_unlock(&vcpu->kvm->mmu_lock);
> +	}
> +}
> +
> +void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu) {
> +		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
> +		vcpu->arch.hw_mmu = NULL;
> +	}
> +}
> +
>   /*
>    * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>    * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
> @@ -43,6 +220,24 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>   	return -EINVAL;
>   }
>   
> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		WARN_ON(atomic_read(&mmu->refcnt));
> +
> +		if (!atomic_read(&mmu->refcnt))
> +			kvm_free_stage2_pgd(mmu);
> +	}
> +	kfree(kvm->arch.nested_mmus);
> +	kvm->arch.nested_mmus = NULL;
> +	kvm->arch.nested_mmus_size = 0;
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
>   /*
>    * Our emulated CPU doesn't support all the possible features. For the
>    * sake of simplicity (and probably mental sanity), wipe out a number

It looks good to me, please feel free to add.
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

Thanks,
Ganapat
