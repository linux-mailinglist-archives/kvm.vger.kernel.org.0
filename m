Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3212722787F
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 08:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgGUGC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 02:02:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726074AbgGUGC4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 02:02:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06L62XEw096736;
        Tue, 21 Jul 2020 02:02:40 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32dcyqx2nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 02:02:36 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06L60A8a020428;
        Tue, 21 Jul 2020 06:02:15 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 32brq962hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 06:02:15 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06L62FBo54788352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 06:02:15 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECECC124054;
        Tue, 21 Jul 2020 06:02:14 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB39B124052;
        Tue, 21 Jul 2020 06:02:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.85.6])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jul 2020 06:02:11 +0000 (GMT)
Subject: Re: [v3 12/15] powerpc/perf: Add support for outputting extended regs
 in perf intr_regs
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>, mpe@ellerman.id.au,
        acme@kernel.org, jolsa@kernel.org
Cc:     ego@linux.vnet.ibm.com, mikey@neuling.org,
        maddy@linux.vnet.ibm.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com,
        linuxppc-dev@lists.ozlabs.org
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-13-git-send-email-atrajeev@linux.vnet.ibm.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <1dded891-e5c2-ae1a-301c-4a3806aec3a0@linux.ibm.com>
Date:   Tue, 21 Jul 2020 11:32:10 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594996707-3727-13-git-send-email-atrajeev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_01:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210039
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/17/20 8:08 PM, Athira Rajeev wrote:
> From: Anju T Sudhakar <anju@linux.vnet.ibm.com>
> 
> Add support for perf extended register capability in powerpc.
> The capability flag PERF_PMU_CAP_EXTENDED_REGS, is used to indicate the
> PMU which support extended registers. The generic code define the mask
> of extended registers as 0 for non supported architectures.
> 
> Patch adds extended regs support for power9 platform by
> exposing MMCR0, MMCR1 and MMCR2 registers.
> 
> REG_RESERVED mask needs update to include extended regs.
> `PERF_REG_EXTENDED_MASK`, contains mask value of the supported registers,
> is defined at runtime in the kernel based on platform since the supported
> registers may differ from one processor version to another and hence the
> MASK value.
> 
> with patch
> ----------
> 
> available registers: r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11
> r12 r13 r14 r15 r16 r17 r18 r19 r20 r21 r22 r23 r24 r25 r26
> r27 r28 r29 r30 r31 nip msr orig_r3 ctr link xer ccr softe
> trap dar dsisr sier mmcra mmcr0 mmcr1 mmcr2
> 
> PERF_RECORD_SAMPLE(IP, 0x1): 4784/4784: 0 period: 1 addr: 0
> ... intr regs: mask 0xffffffffffff ABI 64-bit
> .... r0    0xc00000000012b77c
> .... r1    0xc000003fe5e03930
> .... r2    0xc000000001b0e000
> .... r3    0xc000003fdcddf800
> .... r4    0xc000003fc7880000
> .... r5    0x9c422724be
> .... r6    0xc000003fe5e03908
> .... r7    0xffffff63bddc8706
> .... r8    0x9e4
> .... r9    0x0
> .... r10   0x1
> .... r11   0x0
> .... r12   0xc0000000001299c0
> .... r13   0xc000003ffffc4800
> .... r14   0x0
> .... r15   0x7fffdd8b8b00
> .... r16   0x0
> .... r17   0x7fffdd8be6b8
> .... r18   0x7e7076607730
> .... r19   0x2f
> .... r20   0xc00000001fc26c68
> .... r21   0xc0002041e4227e00
> .... r22   0xc00000002018fb60
> .... r23   0x1
> .... r24   0xc000003ffec4d900
> .... r25   0x80000000
> .... r26   0x0
> .... r27   0x1
> .... r28   0x1
> .... r29   0xc000000001be1260
> .... r30   0x6008010
> .... r31   0xc000003ffebb7218
> .... nip   0xc00000000012b910
> .... msr   0x9000000000009033
> .... orig_r3 0xc00000000012b86c
> .... ctr   0xc0000000001299c0
> .... link  0xc00000000012b77c
> .... xer   0x0
> .... ccr   0x28002222
> .... softe 0x1
> .... trap  0xf00
> .... dar   0x0
> .... dsisr 0x80000000000
> .... sier  0x0
> .... mmcra 0x80000000000
> .... mmcr0 0x82008090
> .... mmcr1 0x1e000000
> .... mmcr2 0x0
>  ... thread: perf:4784
> 
> Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
> [Defined PERF_REG_EXTENDED_MASK at run time to add support for different platforms ]
> Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
> Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> ---

Patch looks good to me.

Reviewed-by: Kajol Jain <kjain@linux.ibm.com>

Thanks,
Kajol Jain

>  arch/powerpc/include/asm/perf_event_server.h |  8 +++++++
>  arch/powerpc/include/uapi/asm/perf_regs.h    | 14 +++++++++++-
>  arch/powerpc/perf/core-book3s.c              |  1 +
>  arch/powerpc/perf/perf_regs.c                | 34 +++++++++++++++++++++++++---
>  arch/powerpc/perf/power9-pmu.c               |  6 +++++
>  5 files changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
> index 832450a..bf85d1a 100644
> --- a/arch/powerpc/include/asm/perf_event_server.h
> +++ b/arch/powerpc/include/asm/perf_event_server.h
> @@ -15,6 +15,9 @@
>  #define MAX_EVENT_ALTERNATIVES	8
>  #define MAX_LIMITED_HWCOUNTERS	2
>  
> +extern u64 PERF_REG_EXTENDED_MASK;
> +#define PERF_REG_EXTENDED_MASK	PERF_REG_EXTENDED_MASK
> +
>  struct perf_event;
>  
>  struct mmcr_regs {
> @@ -62,6 +65,11 @@ struct power_pmu {
>  	int 		*blacklist_ev;
>  	/* BHRB entries in the PMU */
>  	int		bhrb_nr;
> +	/*
> +	 * set this flag with `PERF_PMU_CAP_EXTENDED_REGS` if
> +	 * the pmu supports extended perf regs capability
> +	 */
> +	int		capabilities;
>  };
>  
>  /*
> diff --git a/arch/powerpc/include/uapi/asm/perf_regs.h b/arch/powerpc/include/uapi/asm/perf_regs.h
> index f599064..225c64c 100644
> --- a/arch/powerpc/include/uapi/asm/perf_regs.h
> +++ b/arch/powerpc/include/uapi/asm/perf_regs.h
> @@ -48,6 +48,18 @@ enum perf_event_powerpc_regs {
>  	PERF_REG_POWERPC_DSISR,
>  	PERF_REG_POWERPC_SIER,
>  	PERF_REG_POWERPC_MMCRA,
> -	PERF_REG_POWERPC_MAX,
> +	/* Extended registers */
> +	PERF_REG_POWERPC_MMCR0,
> +	PERF_REG_POWERPC_MMCR1,
> +	PERF_REG_POWERPC_MMCR2,
> +	/* Max regs without the extended regs */
> +	PERF_REG_POWERPC_MAX = PERF_REG_POWERPC_MMCRA + 1,
>  };
> +
> +#define PERF_REG_PMU_MASK	((1ULL << PERF_REG_POWERPC_MAX) - 1)
> +
> +/* PERF_REG_EXTENDED_MASK value for CPU_FTR_ARCH_300 */
> +#define PERF_REG_PMU_MASK_300   (((1ULL << (PERF_REG_POWERPC_MMCR2 + 1)) - 1) - PERF_REG_PMU_MASK)
> +
> +#define PERF_REG_MAX_ISA_300   (PERF_REG_POWERPC_MMCR2 + 1)
>  #endif /* _UAPI_ASM_POWERPC_PERF_REGS_H */
> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index 31c0535..d5a9529 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -2316,6 +2316,7 @@ int register_power_pmu(struct power_pmu *pmu)
>  		pmu->name);
>  
>  	power_pmu.attr_groups = ppmu->attr_groups;
> +	power_pmu.capabilities |= (ppmu->capabilities & PERF_PMU_CAP_EXTENDED_REGS);
>  
>  #ifdef MSR_HV
>  	/*
> diff --git a/arch/powerpc/perf/perf_regs.c b/arch/powerpc/perf/perf_regs.c
> index a213a0a..b0cf68f 100644
> --- a/arch/powerpc/perf/perf_regs.c
> +++ b/arch/powerpc/perf/perf_regs.c
> @@ -13,9 +13,11 @@
>  #include <asm/ptrace.h>
>  #include <asm/perf_regs.h>
>  
> +u64 PERF_REG_EXTENDED_MASK;
> +
>  #define PT_REGS_OFFSET(id, r) [id] = offsetof(struct pt_regs, r)
>  
> -#define REG_RESERVED (~((1ULL << PERF_REG_POWERPC_MAX) - 1))
> +#define REG_RESERVED (~(PERF_REG_EXTENDED_MASK | PERF_REG_PMU_MASK))
>  
>  static unsigned int pt_regs_offset[PERF_REG_POWERPC_MAX] = {
>  	PT_REGS_OFFSET(PERF_REG_POWERPC_R0,  gpr[0]),
> @@ -69,10 +71,26 @@
>  	PT_REGS_OFFSET(PERF_REG_POWERPC_MMCRA, dsisr),
>  };
>  
> +/* Function to return the extended register values */
> +static u64 get_ext_regs_value(int idx)
> +{
> +	switch (idx) {
> +	case PERF_REG_POWERPC_MMCR0:
> +		return mfspr(SPRN_MMCR0);
> +	case PERF_REG_POWERPC_MMCR1:
> +		return mfspr(SPRN_MMCR1);
> +	case PERF_REG_POWERPC_MMCR2:
> +		return mfspr(SPRN_MMCR2);
> +	default: return 0;
> +	}
> +}
> +
>  u64 perf_reg_value(struct pt_regs *regs, int idx)
>  {
> -	if (WARN_ON_ONCE(idx >= PERF_REG_POWERPC_MAX))
> -		return 0;
> +	u64 PERF_REG_EXTENDED_MAX;
> +
> +	if (cpu_has_feature(CPU_FTR_ARCH_300))
> +		PERF_REG_EXTENDED_MAX = PERF_REG_MAX_ISA_300;
>  
>  	if (idx == PERF_REG_POWERPC_SIER &&
>  	   (IS_ENABLED(CONFIG_FSL_EMB_PERF_EVENT) ||
> @@ -85,6 +103,16 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
>  	    IS_ENABLED(CONFIG_PPC32)))
>  		return 0;
>  
> +	if (idx >= PERF_REG_POWERPC_MAX && idx < PERF_REG_EXTENDED_MAX)
> +		return get_ext_regs_value(idx);
> +
> +	/*
> +	 * If the idx is referring to value beyond the
> +	 * supported registers, return 0 with a warning
> +	 */
> +	if (WARN_ON_ONCE(idx >= PERF_REG_EXTENDED_MAX))
> +		return 0;
> +
>  	return regs_get_register(regs, pt_regs_offset[idx]);
>  }
>  
> diff --git a/arch/powerpc/perf/power9-pmu.c b/arch/powerpc/perf/power9-pmu.c
> index 05dae38..2a57e93 100644
> --- a/arch/powerpc/perf/power9-pmu.c
> +++ b/arch/powerpc/perf/power9-pmu.c
> @@ -90,6 +90,8 @@ enum {
>  #define POWER9_MMCRA_IFM3		0x00000000C0000000UL
>  #define POWER9_MMCRA_BHRB_MASK		0x00000000C0000000UL
>  
> +extern u64 PERF_REG_EXTENDED_MASK;
> +
>  /* Nasty Power9 specific hack */
>  #define PVR_POWER9_CUMULUS		0x00002000
>  
> @@ -434,6 +436,7 @@ static void power9_config_bhrb(u64 pmu_bhrb_filter)
>  	.cache_events		= &power9_cache_events,
>  	.attr_groups		= power9_pmu_attr_groups,
>  	.bhrb_nr		= 32,
> +	.capabilities           = PERF_PMU_CAP_EXTENDED_REGS,
>  };
>  
>  int init_power9_pmu(void)
> @@ -457,6 +460,9 @@ int init_power9_pmu(void)
>  		}
>  	}
>  
> +	/* Set the PERF_REG_EXTENDED_MASK here */
> +	PERF_REG_EXTENDED_MASK = PERF_REG_PMU_MASK_300;
> +
>  	rc = register_power_pmu(&power9_pmu);
>  	if (rc)
>  		return rc;
> 
