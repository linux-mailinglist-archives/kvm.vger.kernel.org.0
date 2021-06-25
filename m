Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1CC3B4475
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhFYNaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 09:30:52 -0400
Received: from mail-mw2nam08on2048.outbound.protection.outlook.com ([40.107.101.48]:3616
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231579AbhFYNav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 09:30:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3nFSPFEAjYQ0hVldPXswoRqIdQZKbMDOXgvBeWQgpYYaVRJiclZAz7SM21BubPqFO8XvpQmv+ZQOecMjTjpnl0TqlKLVqqMyywIdBJcq40QHXdh3e+gS0Xf4yWJQX+mnqvN/ar59PIvNwgputd/LoeOiu6MZ3/sjt/umYjUb2iJSA+//lHLDkg7OcU7BvodXzKKEdg7KyeuasO64rSAHDxsYScPobQ2jUIyoKc5GZAC5BTKhl97IdjillAld6MS+4GGg9lZzrH6OkbuhEqiAAHFCSopTUTrd6kj6tI4vWKTkqUjWFD073RCJsK7sH49ZFWEBaub99jgB+69rEnqzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJdJWFoA4ddNYap3sbKOA2x8RXwrqV4LOtfh8USsJRs=;
 b=L6JZnza+KU19hXU+gJgX3IkkV9xv5eMW6ysv8b90in+UFgGm+99Rvowm/QsoVl+Cmk2tpD2WNRWH1OcOM7C7aj/DKI/i5jd6MbT/B6EXlGwUMyX96HyTQUBQZYSqTXGumEHp4vaFU5nPRBIDkXq6M6rcKGMNH3zLK/tWyHvvDuC46r2WHTliUEH8UxVuFUrLhtUshu/Bj02rNNzGoCKL9wr2N6J7bKwjNW3UclWGaLW3IsKK12OYuO5oRrljSofuBshwt2c7n3TD1eI58KDXxKO0tgLV3Gw0W960nfmdfGoCI8H3p66yIDb2hAqFFXNUgct48g9KEalEBL2ejYEfWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJdJWFoA4ddNYap3sbKOA2x8RXwrqV4LOtfh8USsJRs=;
 b=iH3fFKxOIKwTfuehyyEr5CeVfjqPEVeeDOlJUfwVMhuTn+ppEyFY9v/dMjO2SobdJbJyn7+FyKBWm+UFF37VXMonkOBaFNjIrRSxa1T4QK8VWI5uwgGbs3PO2TvQP5WiPQHIX04K88RQ6zhDW77RBwFsSCiI4H1f06mWGmO6nXs=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2617.namprd12.prod.outlook.com (2603:10b6:5:4a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.18; Fri, 25 Jun 2021 13:28:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4264.023; Fri, 25 Jun
 2021 13:28:28 +0000
Subject: Re: [PATCH 1/2] Revert "KVM: x86: Truncate reported guest MAXPHYADDR
 to C-bit if SEV is supported"
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210625020354.431829-1-seanjc@google.com>
 <20210625020354.431829-2-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <00f392ee-8165-cc53-911c-732110470a16@amd.com>
Date:   Fri, 25 Jun 2021 08:28:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210625020354.431829-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:806:23::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0068.namprd13.prod.outlook.com (2603:10b6:806:23::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.13 via Frontend Transport; Fri, 25 Jun 2021 13:28:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbc0b16a-62c9-4665-a30a-08d937dd1e67
X-MS-TrafficTypeDiagnostic: DM6PR12MB2617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB261767DEE1AE73233C940B62EC069@DM6PR12MB2617.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNk/YN8cs3jnP1AFj8goLnKXdgP6kpG1+SjnT+ufIr1q1cRlys6jnjfgUaDXfSD+NWwKTV9qMhDoDsTIMdeWvNBP5xTMa9VmC4i/zFKNkmGbjFI3x9UY2wxfiEyZ3G4lbzlkWOEJD/4byd+ifdR14Lusm+7eBNDimoHXoRdnwp/QbjOwY36shLMWgrPdtbiwyqivF8ik04X8JioyAkChpWglVjX5r260Jlzj8Vb6SzqKhInXEnsSM2FwxxXd8eXgBBarv8NybGyOCRRWVhBMvs7S3mMZjSrP3KZOQ7kM30Rnn41DJjSTCEhyVhlIbEVbRQGc6lDujvQCEkbMu9cEgFI1QEw7PP4HNK1R50OENn+q/jr5sMyi45IDmFerQO/zEPdkvgjerW3z5+uFcTizKwsLWe6Wn9gqZHjn/ru6qqB98UqVdQYKBTQEmiTWlMsC+dM7nXEC3TgCzaOgFi3p6s8VYHlxs5oai9Meko9Oyu76Kr0JbgMd3+YDTm3FH+thN/b5T2xUrOLMFmhVgJcBKKHL3ZsRWVqONuf9zn85sZrHxpMni3IMzPkflISPFp4JaFdlJgCSsOvgk8If6jtN0D8ySNgY1gmybcKP3YlGDZyWzR41cwAws5++jG0QuSjzP/Dm1EQP6CIuLauYXUwHGC5ufGo7Sz7WxBzbqCm3UACphSfbUN/Ix54teicgHBv9xnRshSRcqOrn5Li93WDIRh70yO5t9+7YvBjrHO5TRF4Qtsood/+CkfB7le7n6JgW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(38100700002)(478600001)(54906003)(16526019)(31686004)(186003)(26005)(66946007)(66476007)(66556008)(110136005)(316002)(5660300002)(6506007)(53546011)(4326008)(86362001)(956004)(2906002)(2616005)(83380400001)(31696002)(8676002)(8936002)(6512007)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Unp3Y1lDZjZ6Qm5CZUxzSnZtZTluZXVCN1YzK2I2ZW90L1lSMW1MdnBBem14?=
 =?utf-8?B?UXlYdXFVYWJWV1Q0eWM1enNsWkxGcXVrc01iMjVmNTZVRW9nclM4TzhsNjBh?=
 =?utf-8?B?ekVDSGRnbTliN21LbHJIVUNHYUd5ODY4MW5yc1Z6c3RjK0VoaUFMNnJ5bGRZ?=
 =?utf-8?B?cWExR2ZwOVBRWGxvZkcwNEx2MFZkKzVmODEyZFZ5L3NqNUpKNmNIeWF1dXJC?=
 =?utf-8?B?cEJ4UUhiM0lSdGFpSmR2UGhYNlVEQ2ZlZGxGakxOWmw5VTkxZEhhTHBuTDZa?=
 =?utf-8?B?MFlTUFF2ckJjQ095WWJiZ0ZmWUtJMkdkclJQTzhIbDFjL1FHTUpyaHN3RkhQ?=
 =?utf-8?B?TXNEUjJkaVQ2TUF5NGk3TDdlSERtTDB0SmdzSEg0cm85MG94M0lHdXJFOGdq?=
 =?utf-8?B?TmVab3NwSHV4T2d4SkZabmc2T0FpYXJuWjJyMHlVTG55bmt5TzhnemxnN0E4?=
 =?utf-8?B?aTk5VGRWRi9VWGtWQ1hUbGJaczBhdFBoMzBPOUIwTlZmWEFqdlAvYnVnRzEv?=
 =?utf-8?B?YWFiOFMzU05JN1JqVjNQOTlJWXpuVjB3RUhFYW9xRDRvT0k2WlpnV1JPSnZV?=
 =?utf-8?B?SDgrL1B4M3htT243UWo4NDBUSW55b3J2V0NKN2FPZTBhZU51RE4rckpiTXA4?=
 =?utf-8?B?N0pGQm9OK1BTL3dySHNDQ0hXRWcvMjN6ME1RMUdFTEhCS1gxWmN2cXN3WjBN?=
 =?utf-8?B?UjY2a3VrZGRuNy9XRVhmQU4vOHdMdW85UXNaUDZCR3dabjhxMXFZQ0R6TlBF?=
 =?utf-8?B?dFloUWFvbDA4cTEyMHM0K0Ira1dqTkNWTWFSd3RYK1czK1BwL1k2OEJoVzNH?=
 =?utf-8?B?WGZoL2UxSEVVWjk5RjZOZkREbnFEMEI0b0JzVVBoRU04UlpkM2k0Q1ZCRjVR?=
 =?utf-8?B?c1JNdjZkRXBEb2VHZG5lVUIyWnBUTmY5SlB4dnowK04xZWU2Z095WWNud0Q1?=
 =?utf-8?B?NEFkMytGSTBPaVk3Sk1WUjlPUTV3dkpvZ3RBWGdETUc4QUZ0TiszTFpDTDBY?=
 =?utf-8?B?aG1leXJUeGRBVFp0bHNJUUl1SnBPLzVhajR3OXUwUmxkM0dXUlM4czViL3hT?=
 =?utf-8?B?TTNYdHZ6Tkg5Q0Ywb2h0S3FLVmlSNWJCUGd6aHhBWFdZYUVlTHpWNWwrTnN0?=
 =?utf-8?B?bnpPM3VyRnpQNklVbEtrM0RROU9zMXFLdnFrb094bFJ5Vm4rd1B1R3lmZG1L?=
 =?utf-8?B?Nlpxc1YxNGRlMjkxMGhDbjQyaHN4aE5ucENrdFRLRjN5cW9uek9NTlowN2Jw?=
 =?utf-8?B?S2RySGtjK0ROMmZWamRYalBtc2JwRG5jN2dLdjNrZlVLZTJJLzQ2c3YyYVJ4?=
 =?utf-8?B?Z2JlUlhCSW94QnB3WEpBRTkvK3grdEZXVFFJUG80NXhEMjRYWDArQ0RmUHNx?=
 =?utf-8?B?SnY5TEg0enpVOFpmTnAzUTN1Yzh1eVFzelV3S1A0S0pHNjRBQklpWitMSVRy?=
 =?utf-8?B?TU5JVWZjTGsycklwSkQvV21zZ3FIbnZieG9DZWVqOU1iNmo1Tm53TDNTZ1h4?=
 =?utf-8?B?aUhTbUNYMk55Ujg2Y29Sb3NUbEZqOHZLQzdNbE5kWGlheVA5UVNScWN4RXU0?=
 =?utf-8?B?akQ3Q0p6ZkFYSXB5K05jS3BFRkJmSk51UWFKNlJCVGYwT21hTjkzMFhwNXY2?=
 =?utf-8?B?cExNcFk1S1BXTlQvYkVLWHFzMUxhbFVuWk1JQ0JzOHIwYXRvWWRLRTZaeHhR?=
 =?utf-8?B?VnBNZWszWUJHamprMUdkdEdjWUNZd2VwQ2dmY3ZuUHdTSHZCb2ZUejk2U1Nu?=
 =?utf-8?Q?wM1GsBxnYjk/p7e08BU1HaX5OTfwNP39dN28bMp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc0b16a-62c9-4665-a30a-08d937dd1e67
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 13:28:28.8883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ng1MNZqv5uDCIHdpFPNcITEdqQFhdz6X7H8+rtWuJri+YSFaejaALzN2Lk/8Z2xkF03OB6wdQXZH1QgXmxxANw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2617
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/21 9:03 PM, Sean Christopherson wrote:
> It turns out that non-SEV guest can indeed use bit 47, and the unexpected
> reserved #PF observed when setting bit 47 is due to a magic 12gb
> HyperTransport region being off limits, even for GPAs.  Per Tom:
> 
>   I think you may be hitting a special HT region that is at the top 12GB
>   of the 48-bit memory range and is reserved, even for GPAs.  Can you
>   somehow get the test to use an address below 0xfffd_0000_0000? That
>   would show that bit 47 is valid for the legacy guest while staying out
>   of the HT region.
> 
> And indeed, accessing 0xfffd00000000 generates a reserved #PF, while
> dropping down a single page to 0xfffcfffff000 does not.
> 
> This reverts commit 3675f005c87c4026713c9f863924de511fdd36c4.
> 
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/cpuid.c   | 11 -----------
>  arch/x86/kvm/svm/svm.c | 37 ++++++++-----------------------------
>  arch/x86/kvm/x86.c     |  3 ---
>  arch/x86/kvm/x86.h     |  1 -
>  4 files changed, 8 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0edda1fc4fe7..ca7866d63e98 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -955,17 +955,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		else if (!g_phys_as)
>  			g_phys_as = phys_as;
>  
> -		/*
> -		 * The exception to the exception is if hardware supports SEV,
> -		 * in which case the C-bit is reserved for non-SEV guests and
> -		 * isn't a GPA bit for SEV guests.
> -		 *
> -		 * Note, KVM always reports '0' for the number of reduced PA
> -		 * bits (see 0x8000001F).
> -		 */
> -		if (tdp_enabled && sev_c_bit)
> -			g_phys_as = min(g_phys_as, (unsigned int)sev_c_bit);
> -
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->edx = 0;
>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 616b9679ddcc..8834822c00cd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -860,26 +860,6 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static __init u8 svm_get_c_bit(bool sev_only)
> -{
> -	unsigned int eax, ebx, ecx, edx;
> -	u64 msr;
> -
> -	if (cpuid_eax(0x80000000) < 0x8000001f)
> -		return 0;
> -
> -	if (rdmsrl_safe(MSR_AMD64_SYSCFG, &msr) ||
> -	    !(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
> -		return 0;
> -
> -	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
> -
> -	if (sev_only && !(eax & feature_bit(SEV)))
> -		return 0;
> -
> -	return ebx & 0x3f;
> -}
> -
>  /*
>   * The default MMIO mask is a single bit (excluding the present bit),
>   * which could conflict with the memory encryption bit. Check for
> @@ -889,13 +869,18 @@ static __init u8 svm_get_c_bit(bool sev_only)
>  static __init void svm_adjust_mmio_mask(void)
>  {
>  	unsigned int enc_bit, mask_bit;
> -	u64 mask;
> +	u64 msr, mask;
> +
> +	/* If there is no memory encryption support, use existing mask */
> +	if (cpuid_eax(0x80000000) < 0x8000001f)
> +		return;
>  
>  	/* If memory encryption is not enabled, use existing mask */
> -	enc_bit = svm_get_c_bit(false);
> -	if (!enc_bit)
> +	rdmsrl(MSR_AMD64_SYSCFG, msr);
> +	if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
>  		return;
>  
> +	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
>  	mask_bit = boot_cpu_data.x86_phys_bits;
>  
>  	/* Increment the mask bit if it is the same as the encryption bit */
> @@ -1028,12 +1013,6 @@ static __init int svm_hardware_setup(void)
>  	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
>  	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>  
> -	/*
> -	 * The SEV C-bit location is needed to correctly enumeration guest
> -	 * MAXPHYADDR even if SEV is not fully supported.
> -	 */
> -	sev_c_bit = svm_get_c_bit(true);
> -
>  	/* Note, SEV setup consumes npt_enabled. */
>  	sev_hardware_setup();
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4a597aafe637..13905ef5bb48 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -209,9 +209,6 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU)
>  
> -u8 __read_mostly sev_c_bit;
> -EXPORT_SYMBOL_GPL(sev_c_bit);
> -
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index bc3f5c9e3708..44ae10312740 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -328,7 +328,6 @@ extern u64 host_xcr0;
>  extern u64 supported_xcr0;
>  extern u64 host_xss;
>  extern u64 supported_xss;
> -extern u8  sev_c_bit;
>  
>  static inline bool kvm_mpx_supported(void)
>  {
> 
