Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533E347A554
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 08:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbhLTHTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 02:19:03 -0500
Received: from mail-mw2nam10on2120.outbound.protection.outlook.com ([40.107.94.120]:64225
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234251AbhLTHTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 02:19:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUfPf5fC/wWF/eqzvuOIPQ4fVyP3z6Ciz1RSfu329AuWXP/DWGeP9jVyKd/Jn0HwW0daXIuGPu9qRN2L0QIiTD6di0Y5bzWCnrSpwe/z3CQgPWkfcJ9aO09gOym1dyG7BP/UhxHMCJ9aPXGooXjuEL2ZD/L1Qsln2hmuDf1Rn8fX+Lggw/bqzbAFosY9F75SON5J04tQ9sOxp2ONhGjT4dDtZ6g713txGgp+lEFpzdWFtM8j2UCWa0xaMk2DC6eMM7nTlC7/O03CsyEwAlAXAEu7TTstrG/Tf6l6AiyXv13VpEaqhh85r7d1DxkVFkgBs9H2bere6kuZ/zEIjTwDgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9/cGhRzPamy+JcNF98r0IDlYg4hdROg2QEzmcO/hTI=;
 b=cBWronCBPSEqUv2lET7d2xjckDhICa2evyCljgAORhtHn+NPrZkOhaDGBihJTHisAVzvgy2B9mkKOmP4NODJjqGnjf3xrxzMRXO3wM0dzoSHOb03DIJrQINzr0fE7HwjxgrOS8eiiZfjRexNo1AV2iSQeWwO5mMrMcUMTQxrqhyONmnNBYEeZm3Vqx+u2c0UHrpf+pOsh/TrLmkwdAqFPBlRiD8GhQzJVki8w/4SO6giV4wpEAnDaj+wHOs+/pwXA2z5HzODMygC+priPezHOpiJmFnDaUooY4UeJiicmcfBxmq4A4QXVjcdPhwOXMnxT4mcn6HOBJsJDTH5J7kMBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9/cGhRzPamy+JcNF98r0IDlYg4hdROg2QEzmcO/hTI=;
 b=Q3lnRe3yLkVjgjwqiIR2/MgBVoXRvJEBatfoYrhaWimRMotKfqMBlSNaliQKZgH5FJOx4kk61m56i0lKmBU5rr9t0p849KoqDfjTFAyyssX4Odn3Cl3oxaiTOai2N3+ueQoRZrP2CXkAFshKcr5LuINr1F5kzroqZonLV4DqSmw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB4011.prod.exchangelabs.com (2603:10b6:5:28::28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.20; Mon, 20 Dec 2021 07:18:59 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 07:18:59 +0000
Message-ID: <c43ede47-ef06-96bf-b8c2-af323d244969@os.amperecomputing.com>
Date:   Mon, 20 Dec 2021 12:48:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 31/69] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1
 bit setting
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
 <20211129200150.351436-32-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-32-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:610:e6::22) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b5fb9a2-87a6-44ee-0269-08d9c388fdce
X-MS-TrafficTypeDiagnostic: DM6PR01MB4011:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB40115643432D7049035A4FD99C7B9@DM6PR01MB4011.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 91clnR2gc5rR57REkTEA+DhyS5TYQlc2wZjctSjOYuUvbu7CEl3xQj2hreMSbZJJDego7GC4+PaLu9Mezn4EizIfBEPyLzBLRFatTf4eXs+WgQgUQi2RCSHFabmZs2tW6Oq6X8G8Vx77iZaPgCGfcDEQI/9oNJqrqQM5hiAeGCypHBgqvtx74JBQnYBvWm8HjjLVVHGPn2FClYs4YaVEa7hB9X/Y2zmI43heP50kLwI/72BiHubskst8bzG919nTcFuEMwsSrn6hWAevyk/8eyaYB3XgVWl07iUDVZz3nf+iX3koeVH2chW22cPlgADJKHqG2WUDRwtRwpmIGvjhBfemUtkl3UOV+dQvTUFTlquihzPLv8q4//O0IYU9ljARjlhLvKTA9SC5lxvHuqN+cYFf8Y2q5RQi0IgLieGhLLvezecc2aEOTDbBBjtbq6GJXjd3UGmcjH+s+dB7pZ8bDTSbh9CLpQtiauSTkEMw6baBIxwaWGtDrufqJEYNglQHFAmpb+vrkFzcP7GbIudsJrWTa/c8lPruoaqQqY9C9D/PKN+9G0Kg+KSGoXd9nuJFLDdH9MSPTTsrlhlcYOtqeFh71YI4tQsIsRp6PJog2x1YrJy9zduGRCYjgieJ6noedjlvivPP/R9S6mgwbSbAK4sR72FNMHgkFtFsewXxkXEE44jxV0FUjQ1rQS6M1h6Tmjc/254sXFWb7tXLp4FHGPx3jAvvgVqOTiDM2Ecd34g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(26005)(508600001)(86362001)(2616005)(54906003)(316002)(5660300002)(8936002)(4326008)(7416002)(186003)(66946007)(66556008)(66476007)(31686004)(2906002)(52116002)(6506007)(53546011)(6666004)(31696002)(38350700002)(6486002)(38100700002)(6512007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0NoWnVWOFRINUFMQTg2dXhhWllVcVZOQUxZc0hzQU9iNFFUT0ZtT3AvSTEz?=
 =?utf-8?B?NGhCVEdWK1UwRGlHQXBqcGJlWmdFT2RZZHJwNXIybVV4a3FOS0VYV3lYZ0xv?=
 =?utf-8?B?VXVTM0I1YzdmQU1OcTdLRGZEUGUvMHF4ZjFPNVJpSUl4bTFSVlM0ZDJCanN2?=
 =?utf-8?B?K2t4SSswNXpaV1h2V0EzS09CUGxSaEFJTWNrWWN4aUhTVXFIbUE0QSs0aFlT?=
 =?utf-8?B?OS9QN3F5cTRiTU9aVmdqeEl5RDZrT1U5VzBMazlTdVlsWVhXYVNZc2ZZRVlY?=
 =?utf-8?B?ZFFSQkV3cXhJZHhMc2tSclp4bFRmRXNkYTVDRk9UTXk3R0hSNDE0QUorblVD?=
 =?utf-8?B?cjFIaTZvdnZYL1BkRHZid3hDQmxkQnpqbFJwVzJoM25UZHJacEd5U0d3QVhD?=
 =?utf-8?B?cjRZZDJ2bUU5L1FRV1duQjYrbkwwY0dCeFFtZnpKc1ZnZXhRai9aZmozTkhZ?=
 =?utf-8?B?T3FSVWcxZUlleWZSaTVseUkxTWpGVmhVSGxBUEVlbnBFbjlDVGZWK2RkUFZY?=
 =?utf-8?B?Qis2N3NGdFNVZVY0VHJkbUdMN2kwcVVLNDdOTENSTExpY2J0elR6OXZjNlpi?=
 =?utf-8?B?N0lLaVFhUmhLZkxhanVPeG9Xbm14cWJSMStFRXJ2cU9PaXFWM0IvcGtmakFv?=
 =?utf-8?B?Y0pTL1hrbGdBVXd2SjNtbURpbkY1eTlCWE9Pam8rYmwxTUo2bHdjRGhIQ2Zv?=
 =?utf-8?B?ajhIUVVJNlZhaHIzUU5pVUw5UXJjcGxOUHZ6cW5PVHAwTTJrU29ReEFOdis3?=
 =?utf-8?B?UVdhN1BkVHdmenQ0T29Zb2JOdElxTDJOUWlndWRrc1JDYldwM3ZRcER1ZWF1?=
 =?utf-8?B?TnBlbU5pS29kQzY0VmZOUndtdnUzaFFmNEd4UEI5dHhERUdhTi9ZUE52c2Q5?=
 =?utf-8?B?bGp0N3pwVjNVRm9zdXFXYmNVTGdqMmlDS1d3LzNGSXl1dWhwbkxQOW9ybnA0?=
 =?utf-8?B?cjlkZVl0RE1SZXYzc25sNDllaGZJTkJRODdLajBLcFNQdFR1cFJKNDhBQTZY?=
 =?utf-8?B?enJYckVuWkVlaTJueXV5aW9Qc1RFMFJ2L1JNc3pLcG1rTUJZYXpNWU1SMUwv?=
 =?utf-8?B?WU5icUQrZ3ZjaEp6cXBVdnk0aVRxVEJXWDBKcDhZMFhobjZyd2ZiRHhwRGlp?=
 =?utf-8?B?LzlsSm5IQjR3aGtPOTJkby9LVGZwSXBIbFVsM0Vtd2p4ODc4UTRRMWx1ZUw4?=
 =?utf-8?B?VjduQlNBT0JtbXhQMTdERm9sT2ZJcWtqK2Q1MzBSMHl3L1BvSHorb3NTdGU3?=
 =?utf-8?B?SWxXUWNseXVlaEg3TnBuOTJxNEhHblB2d3ZwdU9qUWdFY1drQ1V6cmdJUkxw?=
 =?utf-8?B?dWoyZFlkL1RmVjROZkpXenN3U3FiRXVoQTY0RUJFK3dBQWkxVTMwWUU0NFEy?=
 =?utf-8?B?VC93NktURFFZOGx0Sk5lRmxLNG1JOStJMkRoMnJEZ3hMT0xIUHJDeGV2UUVa?=
 =?utf-8?B?ckJ2VEUrSEhzbkJobCtoaVBpT3kyKzhteFcwdklZWlRGUWRWcnluZk8yOEls?=
 =?utf-8?B?b1ozY2JTMjB0dElpREdEV3BNdFMrNGRuOXYwRlFyVTZLaDA3RHNLTi9hZVFn?=
 =?utf-8?B?ZXJRWlE0bWEwNVl6RWZQdjFBNEJ2NkY0VVN2clNhRTMzRDFxaGRxeHhCaGJE?=
 =?utf-8?B?Q0plS3pvUi8yTXZWTkV5TWVhb0txaVNvR2xiMHFYUmlsdnNLd1hxRmE3c2hB?=
 =?utf-8?B?L3VnMFBxU2MySVNLU1RhSEN4b084VEZkais0cG81NHVpUVk5VG9jcVMyS2hJ?=
 =?utf-8?B?c3pMMkFjUmpZNkVOa082TVVjS1N6dERyYnI4NnRXMnhWcEJQd0lVY28rVDFR?=
 =?utf-8?B?TFFSeUVrOGxsV2tHV1pEYVFyUG5VNXhvdUl4S09wdFFtOW1RcDMxR0xkYWJr?=
 =?utf-8?B?Y1FZWXVEbit6UXhxdEVCOU1BazVWSDh5clNUb2NVbzJxcjhreVk5Tkl3cXA5?=
 =?utf-8?B?WXU1Nzkrc0doRStpY2lINFZFd3FaTXVTcktBNURKd3JCdVBvTWRKVm9TMURQ?=
 =?utf-8?B?bzRER0htYW9BTVcxTVhacjVaSCtwOTcvOGt0djR1RUlCRnczY1JBMnRmYnNl?=
 =?utf-8?B?ZzlFZzRKeEdlTndYb0xydDJJSnFWTVNWQWdQbitFNG85SEJKQXhDQlJaRnhT?=
 =?utf-8?B?Tzl2UkxHZ1puM3lTeGFQZjRKRGJpTlZXcG5XclpMdjlUR0FrK0xnc1RjWnBr?=
 =?utf-8?B?TDFHM2EvSmdWUFZIazFCdjFCV053N0pnYUVzMzl1cFk5VFR3L01uaUV2ay9T?=
 =?utf-8?B?Zmx1NWpsMmtvL0V5Smp5RXlNL2hLekQ4ZTdKcEN6SFVrRXFzS3ZLQ2RwR3Vi?=
 =?utf-8?B?dTdreDlyWmtyMWd1bHhTaFBpM3V3OWF1encya0d1UFd3WkdabmxMQT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5fb9a2-87a6-44ee-0269-08d9c388fdce
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 07:18:59.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHg95tUhBQE20Y/wfLQxsPJH1MIDbYMnaWKQzWt7ZArrtHhQ7Thm/92Bs9Ir/6zuypw1ViCG6eAMkaSIvYL400fAo7vWEzv+uMo7BoZBarRSXGFrC8ECrY07FK97LIrW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4011
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30-11-2021 01:31 am, Marc Zyngier wrote:
> From: Jintack Lim <jintack@cs.columbia.edu>
> 
> Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
> virtual HCR_EL2.NV bit is set.
> 
> This is for recursive nested virtualization.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_arm.h |  1 +
>   arch/arm64/kvm/sys_regs.c        | 28 +++++++++++++++++++++++++++-
>   2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 9759bc893a51..68af5509e4b0 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -20,6 +20,7 @@
>   #define HCR_AMVOFFEN	(UL(1) << 51)
>   #define HCR_FIEN	(UL(1) << 47)
>   #define HCR_FWB		(UL(1) << 46)
> +#define HCR_NV1		(UL(1) << 43)
>   #define HCR_NV		(UL(1) << 42)
>   #define HCR_API		(UL(1) << 41)
>   #define HCR_APK		(UL(1) << 40)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e96877fc3b2a..511e06b6f603 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -288,6 +288,22 @@ static bool access_rw(struct kvm_vcpu *vcpu,
>   	return true;
>   }
>   
> +/* This function is to support the recursive nested virtualization */
> +static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> +{
> +	return forward_traps(vcpu, HCR_NV1);
> +}
> +

Shall we move this helper to emulate-nested.c?

> +static bool access_vbar_el1(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	if (forward_nv1_traps(vcpu, p))
> +		return false;
> +
> +	return access_rw(vcpu, p, r);
> +}
> +
>   static bool access_sctlr_el2(struct kvm_vcpu *vcpu,
>   			     struct sys_reg_params *p,
>   			     const struct sys_reg_desc *r)
> @@ -1682,6 +1698,7 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>   	return true;
>   }
>   
> +
>   static bool access_elr(struct kvm_vcpu *vcpu,
>   		       struct sys_reg_params *p,
>   		       const struct sys_reg_desc *r)
> @@ -1689,6 +1706,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
>   	if (el12_reg(p) && forward_nv_traps(vcpu))
>   		return false;
>   
> +	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
> +		return false;
> +
>   	if (p->is_write)
>   		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
>   	else
> @@ -1704,6 +1724,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>   	if (el12_reg(p) && forward_nv_traps(vcpu))
>   		return false;
>   
> +	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
> +		return false;
> +
>   	if (p->is_write)
>   		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
>   	else
> @@ -1719,6 +1742,9 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>   	if (el12_reg(p) && forward_nv_traps(vcpu))
>   		return false;
>   
> +	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
> +		return false;
> +
>   	if (p->is_write)
>   		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
>   	else
> @@ -1927,7 +1953,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	{ SYS_DESC(SYS_LORC_EL1), trap_loregion },
>   	{ SYS_DESC(SYS_LORID_EL1), trap_loregion },
>   
> -	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
> +	{ SYS_DESC(SYS_VBAR_EL1), access_vbar_el1, reset_val, VBAR_EL1, 0 },
>   	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
>   
>   	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },

Thanks,
Ganapat
