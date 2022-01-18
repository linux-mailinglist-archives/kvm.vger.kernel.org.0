Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9433492535
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiARLue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:50:34 -0500
Received: from mail-mw2nam10on2099.outbound.protection.outlook.com ([40.107.94.99]:32993
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239760AbiARLud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:50:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILTmNMZpqLscZQaC5xzqFK9h878Bek/1d6yZElc9zQCcJw4ALfkwTd9gdLhFtYTslaydIxGlIhtL9JAgD/z4/wuzU25OgnEHf+0vEEOeT0b+liDfdwsr0sj9iMxkmVyuIHeNfO2FJD0/BtWwf6DocwK1QGpvEbGoRdmnsgcnHxiMgnvHkHE3vT4sVBociylE6mbpj/5Jpp+xBW1QjZIHfDSsf+OiljIAqEcZs3v1NfAiJpxosToSX288qd2/k6VbY7uoxy1t4tr/IZeAostLAKS/bwQuWbBMuNenNV03W83wFweiQUQoG7AydMwvxHZIPS+hw9ScSFquszEBTd7VCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54u7WpTJYLtaHYafc1udTkdh9PqbFVAFMfy2ALLZ2QM=;
 b=hkYXQfQ8fH9AEmmL+HkQkhXg5TmLBceHjN/6C0jWYf2w8bAM1V7vy853y7rk2BtAVb4tVgx0r8xjMIjcCGCubMfEAVp2ZSq0zCu4zdHDcZ154KFrn5WqZZyLTOFnn5HPd6S88E558kOd2CaTuyuufAMeuSyOtjzuHTlZGAJv8nRTNl8gnEunkn0AKMi/tnqA0NdVHFolP0XR6mXtjtJzL1/gv7J2EIKQUnU3S9whFUi2sqPP8zsdYRHP5pVdw7iY6Qz0j4RYvKvYqMdPs7d4Z2VGo6bApdkoPQ1vqkUzRvQX6twqUBmjbmLIsURzrOKNMNYUllTlHDcdDYCsdgXHdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54u7WpTJYLtaHYafc1udTkdh9PqbFVAFMfy2ALLZ2QM=;
 b=VELLQ6u/tU8qpX0q/DYXF33vAAwDpaUm8mzYAxWbHObIpOY3EFhU8K3xbpnQUpZXGteDMBhir1g1UHpc4xAQMyeb3QIRBXrUXloHd2peLrQnaGFpcU0MKiOmzcLwEPc/pOH/1Ebjm/uj2h0LZ1sOjq5TV8frRQwW0bgTGmkVw5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 CO1PR01MB6518.prod.exchangelabs.com (2603:10b6:303:d9::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.9; Tue, 18 Jan 2022 11:50:26 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 11:50:26 +0000
Message-ID: <7fe1ce9e-1b86-ed57-a0e5-117d1b9011b4@os.amperecomputing.com>
Date:   Tue, 18 Jan 2022 17:20:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 67/69] KVM: arm64: nv: Enable ARMv8.4-NV support
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
 <20211129200150.351436-68-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-68-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY4PR14CA0036.namprd14.prod.outlook.com
 (2603:10b6:903:101::22) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f072f97-aeec-4624-2293-08d9da78b760
X-MS-TrafficTypeDiagnostic: CO1PR01MB6518:EE_
X-Microsoft-Antispam-PRVS: <CO1PR01MB6518129121C2BE61677383659C589@CO1PR01MB6518.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SQmxiMlcyaXAzuI3ccsb83kzsF5j7OgVftpUdVQxyZNX/wlbVgmxMXdSv38tvwhplLqZ5cLd99KKWg0cmiPuENY91rvzVHr3WupfO5RhpYaS8v+NJqMQ2GlbZzyQdbUa2H7taN9NA69nq1sovFVVu2bNN0hJUCRe62D94EWYBSiv5xCpsRaYTRh+SdmN3XmtjVtb7LgOzfGy9BQvJi2FEk3La5KTH2QDMQKdRxFXu3bxFnZvzLRKf1SuTK/o0cwpCnAWZTAQ14Ts6a/YsSAdLwCY8TFCQsiGG+u+h+ANgGJDuO46k7yNWdluPRSN2jjDRyGnhWZ2YxIo3pa3pK40QhVuoJkj63JlEUKggWG7sSL2WTj2BsmZB367STjF5K8VSuvF9NwbW1JqsL3bok/iGwiYld7adri4QtnnLkgGCMaCl+n+h7LO0Uqma9N7dVM45+H6oB6zFD9F/Fl6gFTm1w6b9wAZzdL9DminMlFViOOUEdGVWirhbkZ9So3BpReQVn1jj5nzhZW/SNAYb5IEHDB0t3WHXbvfv/shhsCaJ+pWVE4l51ZMQEHcBQ4k8MhZnNjL0crybBZZnrLspv6G0nwe35GwlsfKxIKaRm2VsHQdkv5933cyweZLve9RW92fpFXR4dQGXrLxCDFXFM7OXV2DJrF2OqNNZsMNWlaX92VfQSFsxpsjpmBuvITFsXJ/rnidupvgfePlk74Y62NPVXB8M6nOcKqDfPUQLRQRe4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(7416002)(53546011)(5660300002)(26005)(6512007)(4326008)(66556008)(6666004)(52116002)(66476007)(6506007)(66946007)(83380400001)(2906002)(38100700002)(38350700002)(86362001)(508600001)(8676002)(6486002)(2616005)(316002)(31686004)(31696002)(8936002)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tmk0ZE1iTVd3RW83eWdXWERwa2J2SThIeHBBa2Q2N2F0cWFTekxlZjZWejhT?=
 =?utf-8?B?WTdwbS9xOVNhaTZqU0dhZmh3cWZrNmR5dVNKK2RlWTBNYnVNemErTHYxU2tF?=
 =?utf-8?B?VnU4eGh3M2RRTE9UMDNlVjJJOC84a3BtRlV0RGdvTUg4MTNDTE9kRmVIVjZG?=
 =?utf-8?B?bURlVTUrcHZ5N2hFVjI1ampndzFDRSs3Z1FmcmQ4NmxJVW4rRjJ0MFR6TnBx?=
 =?utf-8?B?Sk5CdkJVZzJKTk50VUMwK0RQWWVNYzgvemt0S2VlbURYdStQWStlZHNtbi92?=
 =?utf-8?B?Q0hJUi9QK29NRXpkK1crLzF1amNIdDVGbWxLbXZxNUtkdTc1TzIyZjdOTDgw?=
 =?utf-8?B?VkpBU3R0eTQ3TEo5S3NMWVRBMG9Fdi9nMWl0eVYrZHVEbmd2UGJYWTdXQ0Ev?=
 =?utf-8?B?VW91STJ3MXlPWmhxZ0hSRFpBeXhEMUdhaVhmcjB2L3FVNWljejdwR3dMNkNG?=
 =?utf-8?B?NGNQdy9WOWRQS2s5ZVNJd2pSeGVjQzZBOVNtaU9RQUVlYjA5c1BaZCtMRFha?=
 =?utf-8?B?dVNCYk4weng1VWlReTNqUWx0eko2NW5TZUFIVDJjK1gzdm83dWtGbnpwQUNu?=
 =?utf-8?B?cG4zR3Eya3YvQml5NEtZZnBLbzJHUVoydDNmSVdDRGE4VHFTU3huVTBaNUlZ?=
 =?utf-8?B?ZkFvY3gvd0g2b2JsVVcyQWwySnJQOC9jeXV1dWNuaEs5Sm94djVsTFp2MGxI?=
 =?utf-8?B?cTZmMmEzS0sxWU1FZHBtMDNBdFlZOEtLQ2Q2MEw1WkVOOEdPSW94Z0s3OUJN?=
 =?utf-8?B?VjZMRmhLMmREUExqRHA5OUc2dUpLck5NSEdTTnoydzR2VkpkY01FVWNwc25V?=
 =?utf-8?B?V011aTM3akNnUlhsc09QeGY3UGdCYmVOTklRZ3Qrc09IUnA2aHR6VTZ2SCt0?=
 =?utf-8?B?RlBzbFZyaXRCTzExSG8zN2hnRUYrb2JKQnE3RndPYU9rOEZ0YVpsRHpsWjRH?=
 =?utf-8?B?dmh1VXovRUZDSlFLdDFEa1BuWnF4MjBjVktEWGh2am1rWWFZKzhlL0NsOGtm?=
 =?utf-8?B?VmZUTnBiUGdqSHZtc2VPNHF1QTcrL2E1Q1hlR3pZSWVMVGxsamR5bjJCdTZ5?=
 =?utf-8?B?azJoLzJOZFBlV1lQRVFxWnI2Zmx2Nk9GMzBkTHFtVnZXWlFCcjE1ZVk1THBu?=
 =?utf-8?B?ZDJieW04OFpyUGY0RDhQZllwSnRzL3g2UFRhQmwyNHhSOHRNVDFnVllrRGlS?=
 =?utf-8?B?ckNtZWwyVW9aZnh0OTFKTGxuVmF6ME5MYjlLTFdsSG1JNU00aStGVkhSSGFS?=
 =?utf-8?B?RHo2V2YvVUlUcDZLVFYyOTA4eGx4bkdGN3JzOWpyVXdjQlR2RjNIczRPVkdH?=
 =?utf-8?B?c1luNGRldFZOKytEOHlKTHFNdExnZXNBb2dRL3JKK3I3MFBqYlpRUE1yZHFY?=
 =?utf-8?B?SkF2RittNHdzcGtHVWUxU01KU0tvWXpGQ0p0YUw2ZUlzc2lLNWdrUmtKQmxI?=
 =?utf-8?B?NFlyTUFwVFFYa2tBTXNZWTNyS3kzanl0NFBNeEdYS0RiRkJHNFU4QnIxY2Jv?=
 =?utf-8?B?TnNMaEdDckdZUVcraXZVbWtsNGZvV0VtS1dCc1hmRnZlRUlkbzhtaXkwRW5j?=
 =?utf-8?B?dUFuSE84YjJJZnF5SXVNKytpdDFuc0hxZFc3RHZHUWU5K0NBeEtIR0lCeGMr?=
 =?utf-8?B?dWFMcU1jRUN0QUQ5VmZJRU1zM3JibDUyT09ZVk1XRUNRZGpUeUQxMllxL29U?=
 =?utf-8?B?blNYTFF5VVMzK1U4dkF0MUdvQXEweTN4WFhkQ2RFUEVHVVNWc2ZuL1VIYUNY?=
 =?utf-8?B?MCszUnpPZWlJYkJOVmN4ZXNkeEVJZ2gwRG91Uno5VDcyWWJHM3ludkRFOThO?=
 =?utf-8?B?MStoVG82OWZUK1BZeXdzSldudXVRaFRaRmZ6eDI2YzdIU0lmVkc0djVzSUQ2?=
 =?utf-8?B?RW5uRnJBMFhwT2JVZ2I1RHRVZ21BditwR0xMUmhlamhVeGdvVmRwOTd2VGMx?=
 =?utf-8?B?TnJYVE9ybmpJbHNyaDNwVjFadVdTNzVqVGZIc3dEM0tESzhPa2d1MHJsUkQ1?=
 =?utf-8?B?NXNLeVUwR1NJcGlkenYwZkV3TmNTMjdKeURtKzBTNk1jY3ZEN1ZKWnVjOWIx?=
 =?utf-8?B?ZFlTOTRtWmg0cE03ZTlLUU9NK3R3MVozUEZWRmw1bkhyeTgwR3lka1VFcEdr?=
 =?utf-8?B?ZGhSV1gxS1c5RStpWWRYYlI2RUxWRU41dVpOaFlwblhKc0FPaEtpNm16T0ph?=
 =?utf-8?B?MkNHZ0l3Vmp0bEFUOFFsOUxpWTVFZXR4b3l4N01VbTJSc29MbCtIcEdRU1cy?=
 =?utf-8?B?RmwwaWt4T3YvUlZvdjB6UjVGRXQ5Ym96QXhjTHQ4RzR6NUxIOUpUMERFN2dR?=
 =?utf-8?B?NWw1L0l0MUhML2x5TXE3ZmZFRXdGSmtpRnZpKzFIeDdTdldSNHkvZz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f072f97-aeec-4624-2293-08d9da78b760
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:50:25.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRss1NsO7O6RORlrsxj1FK1Tv2eMZpv4yoZLGd+OAPdM61Fy1QC52esEWU0y2UodFOt6R1kptpV2S0EXZ8nNOJYuDWAhBNAIZ+sU9Eb/vZ9TA0xjvFiCrklOEAcCUbGW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB6518
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30-11-2021 01:31 am, Marc Zyngier wrote:
> As all the VNCR-capable system registers are nicely separated
> from the rest of the crowd, let's set HCR_EL2.NV2 on and let
> the ball rolling.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_arm.h     |  1 +
>   arch/arm64/include/asm/kvm_emulate.h | 23 +++++++++++++----------
>   arch/arm64/include/asm/sysreg.h      |  1 +
>   arch/arm64/kvm/hyp/vhe/switch.c      | 14 +++++++++++++-
>   4 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b603466803d2..18c35446249f 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -20,6 +20,7 @@
>   #define HCR_AMVOFFEN	(UL(1) << 51)
>   #define HCR_FIEN	(UL(1) << 47)
>   #define HCR_FWB		(UL(1) << 46)
> +#define HCR_NV2		(UL(1) << 45)
>   #define HCR_AT		(UL(1) << 44)
>   #define HCR_NV1		(UL(1) << 43)
>   #define HCR_NV		(UL(1) << 42)
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 1664430be698..f282997e4a4c 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -245,21 +245,24 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
>   
>   static inline u64 __fixup_spsr_el2_write(struct kvm_cpu_context *ctxt, u64 val)
>   {
> -	if (!__vcpu_el2_e2h_is_set(ctxt)) {
> -		/*
> -		 * Clear the .M field when writing SPSR to the CPU, so that we
> -		 * can detect when the CPU clobbered our SPSR copy during a
> -		 * local exception.
> -		 */
> -		val &= ~0xc;
> -	}
> +	struct kvm_vcpu *vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
> +
> +	if (enhanced_nested_virt_in_use(vcpu) || __vcpu_el2_e2h_is_set(ctxt))
> +		return val;
>   
> -	return val;
> +	/*
> +	 * Clear the .M field when writing SPSR to the CPU, so that we
> +	 * can detect when the CPU clobbered our SPSR copy during a
> +	 * local exception.
> +	 */
> +	return val &= ~0xc;
>   }
>   
>   static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64 val)
>   {
> -	if (__vcpu_el2_e2h_is_set(ctxt))
> +	struct kvm_vcpu *vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
> +
> +	if (enhanced_nested_virt_in_use(vcpu) || __vcpu_el2_e2h_is_set(ctxt))
>   		return val;
>   
>   	/*
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 71e6a0410e7c..5de90138d0a4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -550,6 +550,7 @@
>   #define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
>   #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
>   #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
> +#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
>   
>   #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
>   #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index ef4488db6dc1..5cadda79089a 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -45,7 +45,13 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>   			 * the EL1 virtual memory control register accesses
>   			 * as well as the AT S1 operations.
>   			 */
> -			hcr |= HCR_TVM | HCR_TRVM | HCR_AT | HCR_TTLB | HCR_NV1;
> +			if (enhanced_nested_virt_in_use(vcpu)) {
> +				hcr &= ~HCR_TVM;

I think, we should clear TRVM also?
				hcr &= ~(HCR_TVM | HCR_TRVM);

> +			} else {
> +				hcr |= HCR_TVM | HCR_TRVM | HCR_TTLB;
> +			}
> +
> +			hcr |= HCR_AT | HCR_NV1;
>   		} else {
>   			/*
>   			 * For a guest hypervisor on v8.1 (VHE), allow to
> @@ -79,6 +85,12 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>   			if (!vcpu_el2_tge_is_set(vcpu))
>   				hcr |= HCR_AT | HCR_TTLB;
>   		}
> +
> +		if (enhanced_nested_virt_in_use(vcpu)) {
> +			hcr |= HCR_AT | HCR_TTLB | HCR_NV2;
> +			write_sysreg_s(vcpu->arch.ctxt.vncr_array,
> +				       SYS_VNCR_EL2);
> +		}
>   	} else if (nested_virt_in_use(vcpu)) {
>   		u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
>   


Thanks,
Ganapat
