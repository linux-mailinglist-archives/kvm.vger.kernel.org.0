Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3663F492505
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbiARLgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:36:00 -0500
Received: from mail-bn8nam12on2097.outbound.protection.outlook.com ([40.107.237.97]:51424
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240389AbiARLf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:35:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Je1cU8sVSewWEy4pXOPJ17gLAOtKz0D830xqgT715jB7sVbxfd79qrWnxnqf2TB4f3jg+/ENQI6VqJ+WTF1tZN0Ccdh+MIY47QRsbnfolswBXakKDaOD7Va8mRLAfFTUI3Ay6H6klfP1v552Z6RbIHT9cx0LM350nvUXcmOansihqEK+JqjtNFzE4++j7Cd7vAt4HB0dk/jJ+LZPBgTlQHjf8mDERKaaGAXzSLjD5o4TOZQ61RHPeffeEfrMVJyBXw9VeOnx8EFhbLgjPa/oG4BwwoftWWXihhdxBccF+PQ95Grk606MYSn0ZAEaJiNUBir4KkIPuW2l0ZUyqJk/0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HP7rNY98gphorBxtXs4l/8QMsZeVyY85UjnGMr4/uEI=;
 b=UAXeXwQSqsAt/D9NiQOoxrkWB5liDUXdX0TaNLmKbZTItk3f171d9CcFxCJvlmGsQq2ib8E5psVWz8ibVSrhZnQeEowQHdugnsOvHlCU2cOOVt8y5CULd+eIM1AG+sdWYdR/isRO4MvnbaJdU45LFxDr9WN0BEwUXOaBI85MocXPJa1M3bhWEaHVf21E/Gcb1K88QCg+E+LOtd4At8y0ih7/4oq0cxjg8JynDP7PWtF8k/c+rt4BjQfrLUoPp3ut7kW61N7LSpHUwrLX87UOgqT01Jo/XGAW2tF9KIO1VRaHHS4MYF2Fyjse/8r9iluQJ/TpkPJCg5SH1rHPuCnxuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HP7rNY98gphorBxtXs4l/8QMsZeVyY85UjnGMr4/uEI=;
 b=jOjGrWQKNu0IyXJhqSvq5ntyxDsBb/95ceubxCXqg9ZDODFOw1qinm5siSyJ1PHZygwx5TClmoboP8MO0lpKJucF5CLi8+IrDvqViGnY7gzE0IMCn1JNfQTb83FNxd8Ef+UWB23acj2MYfJztpISM0DMlAi2ZZo2rn4HT+uAPnQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB5739.prod.exchangelabs.com (2603:10b6:5:202::27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.12; Tue, 18 Jan 2022 11:35:55 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 11:35:55 +0000
Message-ID: <3e161689-1f04-8baf-201c-e14d453be2c9@os.amperecomputing.com>
Date:   Tue, 18 Jan 2022 17:05:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 58/69] KVM: arm64: nv: Add handling of ARMv8.4-TTL TLB
 invalidation
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
 <20211129200150.351436-59-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-59-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0049.namprd14.prod.outlook.com
 (2603:10b6:610:56::29) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02612022-6f41-4c3e-41d7-08d9da76b0a2
X-MS-TrafficTypeDiagnostic: DM6PR01MB5739:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB5739ECA4585446C4F9995F309C589@DM6PR01MB5739.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sHGhzkrsYcV4BYfe+3B8KxFZxlmgdfLC6C8dr5eV7Rd9vXmmH/lHH2Ythc71GkOuwPQJZWjTF8o58S/To8xSfVrQwNpwl+IzteC1FaHb1F2g09STZW5pEvEeyVP5huoEKJw3Bg3Ow18b2h+c1UvlEEq5fEPsTyiXfcmPn6LooolcwkXRu6JtAqX7IAToZ73Tr4c1rgyigL5FW+YIWR3pXwcCTyFCtsfLNcHVgywZTkBSrvoeoP8vdZa8D2kRaZA0MTD1CNnvStbj40rVGSKP3w5ZueCYtRXMwSLEN2N8gd3pOiV/8kxYxO3F1SrZOm4zgoQ/46rbTOf2Z1//WUKD6IWKqu/MXgqZPymv09fOHVobRYwYIDDWC9E2PYz+um+KCNDGDJQy6mu2PVohd9OVe4f5NELOgZGTocyvEHpkurycsHrb9YaZCXY+QEylsbSeFIkDKPmpAIGi8e1r2yfaNl1TSRdmRVR86jNbJEZL0E1hk1Qq9qXUspwNnQpUDW5hCrzSRfLWCIP2DNWa+dQ5Ct3vCwxEANsvS3Z1Dt98xbSrYjug+Z6OaRmB31D7q19gCO2HtFF5IVyQGzmnAPjP7QsZUAs62MmX0YZSrZEojoOWW5VfUCquDHM8Qd96q9eUWzTBvPM6S/gaQTsFKbo0W/Kqe0vtv05KTWDTMHQlgovwwzQ1Y43MTlzdS4CrcdduUwvkimlCmiFlBlQBs8atB6MfuRweOQcWBXNXIbghdQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6512007)(66946007)(38100700002)(6666004)(2616005)(66476007)(38350700002)(7416002)(83380400001)(6486002)(66556008)(8676002)(2906002)(52116002)(31686004)(8936002)(54906003)(186003)(316002)(26005)(6506007)(53546011)(31696002)(86362001)(4326008)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUk3emN5N2Rqbnh4Z3IwREZVdVZWbkFEWTJFQ1ZqQVVZWElCaEdoTkcrS1BT?=
 =?utf-8?B?U0NsZjFDNDJ0QlZ1S1IvQW5CTDkyd201YkZoeUdWblNEd0FYSGdFMnRBNSs4?=
 =?utf-8?B?SGYzMG14MXR4WDNmWjZwQVc3MFVnaXEvRXJONDBWRWR2WVVWYWpZd24vNkNX?=
 =?utf-8?B?RGJkTGI1OXFQem0zMjQ3SndqSDZxSlg1Q0dwdUo5eGVnWVRkL3plcEsreHNa?=
 =?utf-8?B?MDhzN0lWUXZFUHZ2Y01ISEppK2txNEpTUFhHRkxObnN1czFRdTJOYlEvYUVL?=
 =?utf-8?B?THZEU05LTUJaMWFnUFE5c0o2RDlDZzVHNzNsUTZzWkpvdEdDRUtmYll0SFor?=
 =?utf-8?B?d21DM2hFNm9GdEwvZjQ4clZ6b1B6cGx4MGJtZ21BeWxFRjNUL3RPQ1ZTTTBv?=
 =?utf-8?B?aGNSTS9OeFVKUDNCa01PNVhKaG82cmtGUlhKUUVWcGRXcy80UjBKbnc2Qkhs?=
 =?utf-8?B?bWtJZkVMOFF5alJZZFZMVC9VcjByU2FDc1lXUDAxa2V1S1lzVDE1ZHFJSnU0?=
 =?utf-8?B?RldvY2p2NGd6L25lR1hZUWtKeEZ1V1NoeDlpRlFVV1VxbFIxVFNmTVpjZng3?=
 =?utf-8?B?WHgvck1VdDVocmtxcHNyRXUyREhud01iVXdQcmlIZTNCbWVkZGlyNXVnV1RN?=
 =?utf-8?B?M1ExWWVpOVQwK2VsejdLa3ZvQXB3UUVScDBZcUU2ZXhVR29idEhoZGxwajJO?=
 =?utf-8?B?TTBGelJtOFU2OXp1d0dZVUV2dE8vb2hFY3dYYm5vbkxJbDE5UkZkOXQ1ZDNP?=
 =?utf-8?B?U04rb0Jrakxma2cxU3lEL0lYWHQ0MHQ4M09Gc3VROEdDbEw3ZXhKM2pvZng5?=
 =?utf-8?B?MzAzSXl4MzJDRy9idEZSekhFcTdoTHFiVnlySlNHZWlyYVl0Rlc2VHYweGFo?=
 =?utf-8?B?TFkvbFI3bDdlSTBhQ0Vac0RoRGJOMnVCZXFFc2dPWXliVVpRcmR4YXJicGtU?=
 =?utf-8?B?Tnd1R2M1V3VNRC9ubG5sY0ZYV3ZDNlI3K3lEdGJUa2c4NG03a3ZqVUZBQmtZ?=
 =?utf-8?B?UGtiSUpKRytMcGJmdzhldzRNaWQ5QlRxWDdmekZKSWd5VUZ1d1hqL2JURVhj?=
 =?utf-8?B?aTBMYmtXRDdFOGk3bmJVNU9ZVkpXa2tIa21sSWVWSWxCVnMwWjBRYXB1V1RD?=
 =?utf-8?B?QVB2NTQwMXNBV2FkWEhXV1o2QmU3T0V6SmdnYmFMWGV3NjJKUXZIRllYNGJn?=
 =?utf-8?B?Ty8wVk15UlUxQUlLOUJqcGNXOEVMRU9YOWJlZG5QSXU5QmVqNEJkRm5LY253?=
 =?utf-8?B?TzlXTWdUSGhTNGtQV0NwMzdwRWszazEwZ2F1b1UzckluOVF6NWNlM3pUeTFx?=
 =?utf-8?B?eWhIZ21kRDFla21YNExtVkRLWFJZbmZ0UUhJaFFTM0F2UHkvc0ovVlhtOWdC?=
 =?utf-8?B?MjBzeUxkTGRqaVVCYmNCZ3BnZ0ZtV2RhTUdOSnJQS3QrWlcrM2RSZnZBUytn?=
 =?utf-8?B?eUtETVppVm1YNDRSQnJBbkMreXRxazk5RHJpYzJIZG55V1h2UjR4NDg0VnJM?=
 =?utf-8?B?czNCcm95cVZ6bFYxeUtDM1E3VzAxYkozanlCa1lLRGpyV0tudngrK0kyU1Rm?=
 =?utf-8?B?MXc1OW9LMDhFY1ZsbGtaV3FsOGhSTVd4cHNNZW5xQXZ6aWhmTWRjS0J3REdz?=
 =?utf-8?B?ZW1ENWRlUWdCSXduYldmM3BMQk8wRk5Wd0huNUxhRVl4emVmTnVxWTFCaGFM?=
 =?utf-8?B?U1ZYUHpIL20vekRxbi9yd01wWkh2UE4zL00vVzV5c2ZreGJ4WEw2U25NS0tB?=
 =?utf-8?B?Y1ZtQlVRTERIemZpdkh6RUR5aE96WnZEbGt1cjN3MDdOU0R4bFFIVXExSFRB?=
 =?utf-8?B?T290cTlBbG1zYjBnUm4yNGl0Rkd2WUFEUjkrRitDN1hjOXFXUkY2blFhZDN5?=
 =?utf-8?B?aWlBbm55MXl1Q2JmTTJYdFhaY0xRYjFFLzN6Y3hMbXNpdUVVM0xCTVZpSk52?=
 =?utf-8?B?WGpFWGJiVURYSm1oYUhLQnF0Y1drQ01VZTV5NEptZThUQVBmakpidlU5THAz?=
 =?utf-8?B?eTRXRmUyc21BL3c1dDBTZnR0STVhZTg3L1ZiaFFuWG8zaDN2RmVOMUdkM1pK?=
 =?utf-8?B?UVY5VGpMK3NQTXVhNis5REQ1N0MzNmlmOVFNTDViNGtjVG9QdXArcnlrZWtD?=
 =?utf-8?B?bW82UEpwRXl0YUx1SjdVc0o1V2NTUnhpQ2RJR0dvUEJ3VzNUZlFmZ1hVS0dL?=
 =?utf-8?B?akc1VlRjb3hMQS8yd2FDRFJsUG5UbW9xZmNGZWJzVWprZWxhcEZJUVBNZndL?=
 =?utf-8?B?T2Irb3RJVFNudjRJcE84VHowVTduanBUZnJuTTBwZFBmU3Bocm5OTWkyQXdH?=
 =?utf-8?B?NE5nVGFUNGI5M2p4NmE0ZTFUYnBSMWhudWFPNmlYd1h6YlFJRkZGZz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02612022-6f41-4c3e-41d7-08d9da76b0a2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:35:55.4992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWFEXqLOgVO42cbFa1H0Kvc2j5XWar3zXVTcF6bOcSjX/JPY0oeuqFqukpOl3DOL7BT3r8FiUVXoYA8DSIUM8D0B0uhoMYawQqbmnUz3hV9zwcTRsIicy6J2W4RxNdGM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5739
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30-11-2021 01:31 am, Marc Zyngier wrote:
> Support guest-provided information information to find out about

Typo: information written twice.

> the range of required invalidation.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_nested.h |  1 +
>   arch/arm64/kvm/nested.c             | 57 +++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c           | 78 ++++++++++++++++++-----------
>   3 files changed, 108 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 5fa3c634c8e1..7c47ad655e2e 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -123,6 +123,7 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>   			    u64 control_bit);
>   extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>   extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
> +unsigned int ttl_to_size(u8 ttl);
>   
>   struct sys_reg_params;
>   struct sys_reg_desc;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 198169648c3c..6f738b5f57dd 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -363,6 +363,63 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>   	return ret;
>   }
>   
> +
> +unsigned int ttl_to_size(u8 ttl)
> +{
> +	int level = ttl & 3;
> +	int gran = (ttl >> 2) & 3;
> +	unsigned int max_size = 0;
> +
> +	switch (gran) {
> +	case TLBI_TTL_TG_4K:
> +		switch (level) {
> +		case 0:
			/* No 52bit IPA support */
> +			break;
> +		case 1:
> +			max_size = SZ_1G;
> +			break;
> +		case 2:
> +			max_size = SZ_2M;
> +			break;
> +		case 3:
> +			max_size = SZ_4K;
> +			break;
> +		}
> +		break;
> +	case TLBI_TTL_TG_16K:
> +		switch (level) {
> +		case 0:
> +		case 1:
			/* No 52bit IPA support */
> +			break;
> +		case 2:
> +			max_size = SZ_32M;
> +			break;
> +		case 3:
> +			max_size = SZ_16K;
> +			break;
> +		}
> +		break;
> +	case TLBI_TTL_TG_64K:
> +		switch (level) {
> +		case 0:
> +		case 1:
> +			/* No 52bit IPA support */
> +			break;
> +		case 2:
> +			max_size = SZ_512M;
> +			break;
> +		case 3:
> +			max_size = SZ_64K;
> +			break;
> +		}
> +		break;
> +	default:			/* No size information */
> +		break;
> +	}
> +
> +	return max_size;
> +}
> +
>   /* Must be called with kvm->lock held */
>   struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
>   {
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 55f3e94c24f1..e0f088de2cad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2699,59 +2699,81 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   	return true;
>   }
>   
> +static unsigned long compute_tlb_inval_range(struct kvm_vcpu *vcpu,
> +					     struct kvm_s2_mmu *mmu,
> +					     u64 val)
> +{
> +	unsigned long max_size;
> +	u8 ttl = 0;
> +
> +	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL)) {
> +		ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
> +	}
> +
> +	max_size = ttl_to_size(ttl);
> +
> +	if (!max_size) {
> +		u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
> +
> +		/* Compute the maximum extent of the invalidation */
> +		switch ((vtcr & VTCR_EL2_TG0_MASK)) {
> +		case VTCR_EL2_TG0_4K:
> +			max_size = SZ_1G;
> +			break;
> +		case VTCR_EL2_TG0_16K:
> +			max_size = SZ_32M;
> +			break;
> +		case VTCR_EL2_TG0_64K:
> +			/*
> +			 * No, we do not support 52bit IPA in nested yet. Once
> +			 * we do, this should be 4TB.
> +			 */
> +			/* FIXME: remove the 52bit PA support from the IDregs */
> +			max_size = SZ_512M;
> +			break;
> +		default:
> +			BUG();
> +		}
> +	}
> +
> +	WARN_ON(!max_size);
> +	return max_size;
> +}
> +
>   static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   			     const struct sys_reg_desc *r)
>   {
>   	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
> -	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
>   	struct kvm_s2_mmu *mmu;
>   	u64 base_addr;
> -	int max_size;
> +	unsigned long max_size;
>   
>   	/*
>   	 * We drop a number of things from the supplied value:
>   	 *
>   	 * - NS bit: we're non-secure only.
>   	 *
> -	 * - TTL field: We already have the granule size from the
> -	 *   VTCR_EL2.TG0 field, and the level is only relevant to the
> -	 *   guest's S2PT.
> -	 *
>   	 * - IPA[51:48]: We don't support 52bit IPA just yet...
>   	 *
>   	 * And of course, adjust the IPA to be on an actual address.
>   	 */
>   	base_addr = (p->regval & GENMASK_ULL(35, 0)) << 12;
>   
> -	/* Compute the maximum extent of the invalidation */
> -	switch ((vtcr & VTCR_EL2_TG0_MASK)) {
> -	case VTCR_EL2_TG0_4K:
> -		max_size = SZ_1G;
> -		break;
> -	case VTCR_EL2_TG0_16K:
> -		max_size = SZ_32M;
> -		break;
> -	case VTCR_EL2_TG0_64K:
> -		/*
> -		 * No, we do not support 52bit IPA in nested yet. Once
> -		 * we do, this should be 4TB.
> -		 */
> -		/* FIXME: remove the 52bit PA support from the IDregs */
> -		max_size = SZ_512M;
> -		break;
> -	default:
> -		BUG();
> -	}
> -
>   	spin_lock(&vcpu->kvm->mmu_lock);
>   
>   	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, HCR_VM);
> -	if (mmu)
> +	if (mmu) {
> +		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
> +		base_addr &= ~(max_size - 1);
>   		kvm_unmap_stage2_range(mmu, base_addr, max_size);
> +	}
>   
>   	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, 0);
> -	if (mmu)
> +	if (mmu) {
> +		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
> +		base_addr &= ~(max_size - 1);
>   		kvm_unmap_stage2_range(mmu, base_addr, max_size);
> +	}
>   
>   	spin_unlock(&vcpu->kvm->mmu_lock);
>   

It looks good to me, please feel free to add.
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

Thanks,
Ganapat
