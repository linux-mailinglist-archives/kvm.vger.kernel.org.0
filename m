Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16E07D731A
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 20:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbjJYSTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 14:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjJYSTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 14:19:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C132A93;
        Wed, 25 Oct 2023 11:19:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSW8uuPm6v5oADpqNFn8PUM5osdbfG6U+vHpG+OWVAsQnd3s+wjzAh7AEnRuNu4g4nA/Hcz0IWFMR6CuERvf6041AmA8s2AQJ3Sg+BQQao8tbHKEFggHwok4mpvW4D1+u0rhejnkRiL0jjhBv8MPgdnYjJ4cEqsftXNZF4lGwNm/+tSJk7XKcaZpD0eiQsQXV7Cw3BC43uHm1OgDjQI52GhCEfWKzEFo2z97PYSi8VIp8cXAizVEZ9fz5pmw9+oLDP30tDiSAXEHfVwCGAi4lmRHuneJBdrehdLFd87FRCnrigU7UZDLIavNXg4d9uP/0O8Vc3aQr0IsjboaFQtgBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXC7Tqw4sUnfIkLcNx2p4JDp5LqXjEFNRwTZCbPSPWc=;
 b=mZ3KvF5pdIR2LRORbviU//wqUs174kso5r4E5uf/OC2l/xhbLt7LN7xd/eiDkLCcLhrgMqhGBUsoHew8k1WOSxRreSeal71m7D9KK8/Y/28D+TJRcVCA1yU3lMKnwvFxjxMmnaFKAYMPt5G3CJuzMSERak4diZeedmrmLphHnl7aMDwuwcHyJfp9bpFFOP9tpZ1FJkLNzDf0eoa6756IOvaQdv6kfPKIzGfI3mzNv/wfWrINdswYvTel8g+SbHITCJcB4PFxxRuwztSmhUjv9wj+Hk9PsSBXnKWSXo6o8njj0gbdW9to6ohuKsHhdV+P+ZU+SaJG3Cpen60v2yucOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXC7Tqw4sUnfIkLcNx2p4JDp5LqXjEFNRwTZCbPSPWc=;
 b=v/2ZhdmTkAPjMQr9VjbjgTo/ulX9wcPJAjFOuX3U7dcICe1HmIwRyAxxGc2mSLmoMBkVJSftTOvtJ/h2hsa8IloAKpxwT3pT/16PgEaEOJ1jtiDUKD3glJiRGNuztlNDV8JjN0MJQaDoudncebzmV9dPkEbThekDf4Z6QjXNSUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CH0PR12MB5297.namprd12.prod.outlook.com (2603:10b6:610:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 18:19:27 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6907.032; Wed, 25 Oct 2023
 18:19:27 +0000
Message-ID: <2167accb-468d-009c-5954-2489803a6650@amd.com>
Date:   Wed, 25 Oct 2023 13:19:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231016132819.1002933-7-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:5:60::42) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CH0PR12MB5297:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d15285-1c53-4da1-be23-08dbd586ec2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0R/BgnpTBp/YZQno39tLqwS17qRt5wdD23CKvNP4raO+mDASRk/KCFZFfDPiN9JlApdI4XBOetxHcAhq+7+OI9awtZObNJL7qEy8aWCLosLD10EcNF5D7RFOHWFP3CfdlXZkQKAeUIwZCaBMcFJGABnoHYsos8UZC7SSQDSPcSu6wRgKbfkrJIApQQs5uTrxeso+q1r2P2naRK0IAAGKiusuR7xvKrfnpCQapbUOcL30cf3w0JmvcyMWRTaopcWhjQYgLC+8FpO0hLCJQIYix8GjiyQZZ4nxdtOEDOdL11t6LNNV2PWF+iBMN8Mdqrk4v8OmO9zHOmzDQAmJ0+kLGtI8VczBM1aAKAek0snSyP7QY7770CueXp5+KdQn5HDYVasF/Y/bOATgSXQz9GEtzTFd0U/3rrxygTXXJuJ3ULtlB4dI09EYLigFDmEboJ3+DinmtGK/3Za7Vn1tU4rICDmfL/+OmJte3gL1/4ji2uFqXgAmuyGDnUrUDdTUpITbzqOvT1BahG26o+nmAOiBWjfHhySFn85gzm/gviDTcxb4BnS3N7V3LBhCpshp0Apas7y+sRz/Wf7m5ViZbkuU9uy69ofltelfUME/NMkWe4rHSYGrGBvlpsbOwU7G326PCbKurhCQpzYs/YE7yZtGPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(376002)(136003)(396003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(2616005)(53546011)(6512007)(38100700002)(36756003)(26005)(83380400001)(66556008)(31696002)(66946007)(7406005)(316002)(66476007)(30864003)(7416002)(31686004)(86362001)(4326008)(41300700001)(8676002)(8936002)(5660300002)(6506007)(478600001)(6486002)(2906002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXQzN2FiWForaHBqUEpscnVCZVAzQnRnZGorTjRLOUVndHRUYUNqRlV0SUUx?=
 =?utf-8?B?QkNrckJHcG40UWREam1GZjFPM0UycnlHWmRqZVZOMGhqRHZacEg3VzRHbmhu?=
 =?utf-8?B?UkZIWHk2dDJuSmFQbUVqc2VQMXMzME1JcEpaVHhWSTBTYS9lSGdiRktYUjVY?=
 =?utf-8?B?OHBBQmM4WUFrQzN4dVEwelR2dC9qR2hWWlp6Sm52VlF2RExoUHJZVEE0bU1n?=
 =?utf-8?B?MUtNTUFBRFhVZUtFQzNXMmtDaHA2NkxzY21WQy9YT3dQWFBVcHlpN0NBSGtn?=
 =?utf-8?B?MmRDT29PZjRmVkJCOFBHRUhRclYwZUpnZnJlVjEvYk5GRzdKR1prMTZBTk9W?=
 =?utf-8?B?ZU1FOEc0dzdBQnpqZnE3RXB2U2VoaGcvVkVXUFpacTV5TU9XaVBtRUoyOUpu?=
 =?utf-8?B?OWZ3dVBwVDBSN0RrcUpybXJMQnE0OWJHcnp3MWg5V1NKNUV2S0d3NWVoWjVJ?=
 =?utf-8?B?SU5tSGJxUm5yR0lSYUpLMHdjNDRZTGhRYmFqWGN3V3hZTkNMbExRUVI0bHla?=
 =?utf-8?B?endMQkVGUDdLeTA4OElhNFVML3lDdW50YTIzVzNsbER4VjlFTE4rK1hiT2VM?=
 =?utf-8?B?a29ZU0NPMlg3ZG5ZK2JvYWJsRjYyZFIxVFdnZVAzQ2R1dmZhbTM4VlREVlVN?=
 =?utf-8?B?L0t1TXNuVHZiVDBQa29oeUo3UzBlcDN0NDh1azBKd3pNYjZacnBZcitYVjJt?=
 =?utf-8?B?UFczR2o2L2MzUnZ2dFZRUnJjUW4zcTBNT0h2U2M0MGpQeFB6ZlRoNnJyTFV0?=
 =?utf-8?B?ZWZwdTZVS3MrMUp0czhtQTFlQlFHMjlybjlGQmJIUTEwSU9qcVR6c3hVcVBT?=
 =?utf-8?B?QmcyL1lWekp0Y1VtU0RpTk5VODYwSGZqOWxFM2s4UUFjVU03NnNZYmxYRXZG?=
 =?utf-8?B?QW9XUktjWUZMMzVILzVGcmhrbmwwQlgyMFVmbkZYMTFyc2V1dEN6WkNwK2hD?=
 =?utf-8?B?NEJqZW9MejU0WjJYZW0yUHdEay80dkovbkJlQ2VoOFhlQVN6NXBWV2NyRlJ6?=
 =?utf-8?B?cG90L3pTNnU0TjM1TXlOUGVWQks2YlNHUmoxTEtsd0ZJR1ZWL3cwS2VDYkdp?=
 =?utf-8?B?Y2tDaWVFZnNtakVZM2tyRkxGelBsSm1nTFRGc0ROV1g0L0wwSU0xVm1oZEVa?=
 =?utf-8?B?a0xZZU44ZFpuTWdhT1pWd3BMYlVGcE1LUkpORWFkSjN3dDBiUk50clVTV1Rs?=
 =?utf-8?B?dE9qUEZYT05NQkZZMUs3czhHdnBYRG9qV25ad0pHMy84V0d5dXB5WUZBQ21z?=
 =?utf-8?B?TG52Qm5QUVlTR2tTRjlhR2pEUXFQTkpVUUF2YXNPb25tODcwTGxaamxDZ3o1?=
 =?utf-8?B?anBwM0JxL2krZldFaU9RaXZZWW5lS0x0aEJGQTZRRzBhc1B1L3hkdGZPd0pv?=
 =?utf-8?B?eTRXb2VtbUJ4RzhWQWFGV3NlandwUTRRSTdMYlBKV2JML2VDekdiWWd1ZHhL?=
 =?utf-8?B?aVg0R2x6WFhyUnNVTHFSRWZvTkFSOGtTRDduVVlxcVpRUEppaDJaS3oyQlRQ?=
 =?utf-8?B?dVMwc2J5amR3MFRvRDBBbUs5aGpUd01lcnV5QytTRGVVaC9FekYvOVpOclAw?=
 =?utf-8?B?cXdGVWs2Y3hIZW1IZi83Y0dIR3lUa3hrRjJ6cGJOMmZIN2ovRms1SDh1OEdZ?=
 =?utf-8?B?c1J6QVJpMGw3clU0M2tmU1EzQUR5elNZQlVBMmFDQUhQL21vcGFkZ243L0Uv?=
 =?utf-8?B?ejYrT3FYT1RlQUZpdTJWb0tUVkdJZ1RXU2VnbVdFVTZQNWQwS2ZzM2xCa25U?=
 =?utf-8?B?cUY3dFpSUDI0UGUrMmJtQWk4TW1yRDhJWGw3SlRYVS9zVnB5K1VkSmpBVkc1?=
 =?utf-8?B?Q0E1OWV0eGlwK2ZlOWVUYndhb1Z5WVNwSkFpZ0hqY1lPNXF0WkwrUVlZK0ti?=
 =?utf-8?B?Zi9mWE90SzZITHhobDRoTWYrd1JIdGNCM0NGeksxRDN3WTJDSVpoK3N1bmtn?=
 =?utf-8?B?Rml0VzRtb2N1MVJidFFJYzBodndhSVdLUGlqSTFETUZOdjEyMVpDb1dqZnFK?=
 =?utf-8?B?djBoWk1aWEhXdzEwSlR3TnpyMzF4QnJiSHp5R2lGTDN2UEFLK2p1TDl6TE45?=
 =?utf-8?B?OTFtZXpMbG01UDYreTYvUkFJNFU0RU1yRU1aVjNKMmJsV2FJVkowbVluMUVD?=
 =?utf-8?Q?JHTUcn+utaLYbri8S658k7u9a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d15285-1c53-4da1-be23-08dbd586ec2c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 18:19:26.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwb804zlP5GL26CgiiSiK5VOVJ5p0CeQduj5FxiGv4FdYhApffIpRuZHUrtxxEcSvD5HaWG1BPMErj+NZzEIyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5297
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/23 08:27, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The memory integrity guarantees of SEV-SNP are enforced through a new
> structure called the Reverse Map Table (RMP). The RMP is a single data
> structure shared across the system that contains one entry for every 4K
> page of DRAM that may be used by SEV-SNP VMs. APM2 section 15.36 details
> a number of steps needed to detect/enable SEV-SNP and RMP table support
> on the host:
> 
>   - Detect SEV-SNP support based on CPUID bit
>   - Initialize the RMP table memory reported by the RMP base/end MSR
>     registers and configure IOMMU to be compatible with RMP access
>     restrictions
>   - Set the MtrrFixDramModEn bit in SYSCFG MSR
>   - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
>   - Configure IOMMU
> 
> RMP table entry format is non-architectural and it can vary by
> processor. It is defined by the PPR. Restrict SNP support to CPU
> models/families which are compatible with the current RMP table entry
> format to guard against any undefined behavior when running on other
> system types. Future models/support will handle this through an
> architectural mechanism to allow for broader compatibility.
> 
> SNP host code depends on CONFIG_KVM_AMD_SEV config flag, which may be
> enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
> SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
> instead of CONFIG_AMD_MEM_ENCRYPT.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: rework commit message to be clearer about what patch does, squash
>        in early_rmptable_check() handling from Tom]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/Kbuild                          |   2 +
>   arch/x86/include/asm/disabled-features.h |   8 +-
>   arch/x86/include/asm/msr-index.h         |  11 +-
>   arch/x86/include/asm/sev.h               |   6 +
>   arch/x86/kernel/cpu/amd.c                |  19 ++
>   arch/x86/virt/svm/Makefile               |   3 +
>   arch/x86/virt/svm/sev.c                  | 239 +++++++++++++++++++++++
>   drivers/iommu/amd/init.c                 |   2 +-
>   include/linux/amd-iommu.h                |   2 +-
>   9 files changed, 288 insertions(+), 4 deletions(-)
>   create mode 100644 arch/x86/virt/svm/Makefile
>   create mode 100644 arch/x86/virt/svm/sev.c
> 
> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
> index 5a83da703e87..6a1f36df6a18 100644
> --- a/arch/x86/Kbuild
> +++ b/arch/x86/Kbuild
> @@ -28,5 +28,7 @@ obj-y += net/
>   
>   obj-$(CONFIG_KEXEC_FILE) += purgatory/
>   
> +obj-y += virt/svm/
> +
>   # for cleaning
>   subdir- += boot tools
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 702d93fdd10e..83efd407033b 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -117,6 +117,12 @@
>   #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
>   #endif
>   
> +#ifdef CONFIG_KVM_AMD_SEV
> +# define DISABLE_SEV_SNP	0
> +#else
> +# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
> +#endif
> +
>   /*
>    * Make sure to add features to the correct mask
>    */
> @@ -141,7 +147,7 @@
>   			 DISABLE_ENQCMD)
>   #define DISABLED_MASK17	0
>   #define DISABLED_MASK18	(DISABLE_IBT)
> -#define DISABLED_MASK19	0
> +#define DISABLED_MASK19	(DISABLE_SEV_SNP)
>   #define DISABLED_MASK20	0
>   #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
>   
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d111350197f..2be74afb4cbd 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -589,6 +589,8 @@
>   #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>   #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>   #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
> +#define MSR_AMD64_RMP_BASE		0xc0010132
> +#define MSR_AMD64_RMP_END		0xc0010133
>   
>   /* SNP feature bits enabled by the hypervisor */
>   #define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
> @@ -690,7 +692,14 @@
>   #define MSR_K8_TOP_MEM2			0xc001001d
>   #define MSR_AMD64_SYSCFG		0xc0010010
>   #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
> -#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_MEM_ENCRYPT		BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
> +#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
> +#define MSR_AMD64_SYSCFG_MFDM_BIT		19
> +#define MSR_AMD64_SYSCFG_MFDM			BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
> +
>   #define MSR_K8_INT_PENDING_MSG		0xc0010055
>   /* C1E active bits in int pending message */
>   #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 5b4a1ce3d368..b05fcd0ab7e4 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -243,4 +243,10 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>   static inline u64 sev_get_status(void) { return 0; }
>   #endif
>   
> +#ifdef CONFIG_KVM_AMD_SEV
> +bool snp_get_rmptable_info(u64 *start, u64 *len);
> +#else
> +static inline bool snp_get_rmptable_info(u64 *start, u64 *len) { return false; }
> +#endif
> +
>   #endif
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 14ee7f750cc7..6cc2074fcea3 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -20,6 +20,7 @@
>   #include <asm/delay.h>
>   #include <asm/debugreg.h>
>   #include <asm/resctrl.h>
> +#include <asm/sev.h>
>   
>   #ifdef CONFIG_X86_64
>   # include <asm/mmconfig.h>
> @@ -618,6 +619,20 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
>   	resctrl_cpu_detect(c);
>   }
>   
> +static bool early_rmptable_check(void)
> +{
> +	u64 rmp_base, rmp_size;
> +
> +	/*
> +	 * For early BSP initialization, max_pfn won't be set up yet, wait until
> +	 * it is set before performing the RMP table calculations.
> +	 */
> +	if (!max_pfn)
> +		return true;

To make this so that AutoIBRS isn't disabled should an RMP table not have 
been allocated by BIOS, lets delete the above check. It then becomes just 
a check for whether the RMP table has been allocated by BIOS, enabled by 
selecting a BIOS option, which shows intent for running SNP guests.

This way, the AutoIBRS mitigation can be used if SNP is not possible on 
the system.

Thanks,
Tom

> +
> +	return snp_get_rmptable_info(&rmp_base, &rmp_size);
> +}
> +
>   static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>   {
>   	u64 msr;
> @@ -659,6 +674,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>   		if (!(msr & MSR_K7_HWCR_SMMLOCK))
>   			goto clear_sev;
>   
> +		if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
> +			goto clear_snp;
> +
>   		return;
>   
>   clear_all:
> @@ -666,6 +684,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>   clear_sev:
>   		setup_clear_cpu_cap(X86_FEATURE_SEV);
>   		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
> +clear_snp:
>   		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>   	}
>   }
> diff --git a/arch/x86/virt/svm/Makefile b/arch/x86/virt/svm/Makefile
> new file mode 100644
> index 000000000000..ef2a31bdcc70
> --- /dev/null
> +++ b/arch/x86/virt/svm/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +obj-$(CONFIG_KVM_AMD_SEV) += sev.o
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> new file mode 100644
> index 000000000000..8b9ed72489e4
> --- /dev/null
> +++ b/arch/x86/virt/svm/sev.c
> @@ -0,0 +1,239 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD SVM-SEV Host Support.
> + *
> + * Copyright (C) 2023 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + *
> + */
> +
> +#include <linux/cc_platform.h>
> +#include <linux/printk.h>
> +#include <linux/mm_types.h>
> +#include <linux/set_memory.h>
> +#include <linux/memblock.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/cpumask.h>
> +#include <linux/iommu.h>
> +#include <linux/amd-iommu.h>
> +
> +#include <asm/sev.h>
> +#include <asm/processor.h>
> +#include <asm/setup.h>
> +#include <asm/svm.h>
> +#include <asm/smp.h>
> +#include <asm/cpu.h>
> +#include <asm/apic.h>
> +#include <asm/cpuid.h>
> +#include <asm/cmdline.h>
> +#include <asm/iommu.h>
> +
> +/*
> + * The RMP entry format is not architectural. The format is defined in PPR
> + * Family 19h Model 01h, Rev B1 processor.
> + */
> +struct rmpentry {
> +	u64	assigned	: 1,
> +		pagesize	: 1,
> +		immutable	: 1,
> +		rsvd1		: 9,
> +		gpa		: 39,
> +		asid		: 10,
> +		vmsa		: 1,
> +		validated	: 1,
> +		rsvd2		: 1;
> +	u64 rsvd3;
> +} __packed;
> +
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the
> + * bookkeeping, the range needs to be added during the RMP entry lookup.
> + */
> +#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +
> +static struct rmpentry *rmptable_start __ro_after_init;
> +static u64 rmptable_max_pfn __ro_after_init;
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt)	"SEV-SNP: " fmt
> +
> +static int __mfd_enable(unsigned int cpu)
> +{
> +	u64 val;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	val |= MSR_AMD64_SYSCFG_MFDM;
> +
> +	wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	return 0;
> +}
> +
> +static __init void mfd_enable(void *arg)
> +{
> +	__mfd_enable(smp_processor_id());
> +}
> +
> +static int __snp_enable(unsigned int cpu)
> +{
> +	u64 val;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	val |= MSR_AMD64_SYSCFG_SNP_EN;
> +	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
> +
> +	wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +	return 0;
> +}
> +
> +static __init void snp_enable(void *arg)
> +{
> +	__snp_enable(smp_processor_id());
> +}
> +
> +#define RMP_ADDR_MASK GENMASK_ULL(51, 13)
> +
> +bool snp_get_rmptable_info(u64 *start, u64 *len)
> +{
> +	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
> +
> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +	if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
> +		return false;
> +	}
> +
> +	if (rmp_base > rmp_end) {
> +		pr_err("RMP configuration not valid: base=%#llx, end=%#llx\n", rmp_base, rmp_end);
> +		return false;
> +	}
> +
> +	rmp_sz = rmp_end - rmp_base + 1;
> +
> +	/*
> +	 * Calculate the amount the memory that must be reserved by the BIOS to
> +	 * address the whole RAM, including the bookkeeping area. The RMP itself
> +	 * must also be covered.
> +	 */
> +	max_rmp_pfn = max_pfn;
> +	if (PHYS_PFN(rmp_end) > max_pfn)
> +		max_rmp_pfn = PHYS_PFN(rmp_end);
> +
> +	calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
> +
> +	if (calc_rmp_sz > rmp_sz) {
> +		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
> +		       calc_rmp_sz, rmp_sz);
> +		return false;
> +	}
> +
> +	*start = rmp_base;
> +	*len = rmp_sz;
> +
> +	return true;
> +}
> +
> +static __init int __snp_rmptable_init(void)
> +{
> +	u64 rmp_base, rmp_size;
> +	void *rmp_start;
> +	u64 val;
> +
> +	if (!snp_get_rmptable_info(&rmp_base, &rmp_size))
> +		return 1;
> +
> +	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n",
> +		rmp_base, rmp_base + rmp_size - 1);
> +
> +	rmp_start = memremap(rmp_base, rmp_size, MEMREMAP_WB);
> +	if (!rmp_start) {
> +		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, rmp_size);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Check if SEV-SNP is already enabled, this can happen in case of
> +	 * kexec boot.
> +	 */
> +	rdmsrl(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		goto skip_enable;
> +
> +	/* Initialize the RMP table to zero */
> +	memset(rmp_start, 0, rmp_size);
> +
> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
> +	wbinvd_on_all_cpus();
> +
> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
> +	on_each_cpu(mfd_enable, NULL, 1);
> +
> +	/* Enable SNP on all CPUs. */
> +	on_each_cpu(snp_enable, NULL, 1);
> +
> +skip_enable:
> +	rmp_start += RMPTABLE_CPU_BOOKKEEPING_SZ;
> +	rmp_size -= RMPTABLE_CPU_BOOKKEEPING_SZ;
> +
> +	rmptable_start = (struct rmpentry *)rmp_start;
> +	rmptable_max_pfn = rmp_size / sizeof(struct rmpentry) - 1;
> +
> +	return 0;
> +}
> +
> +static int __init snp_rmptable_init(void)
> +{
> +	int family, model;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return 0;
> +
> +	family = boot_cpu_data.x86;
> +	model  = boot_cpu_data.x86_model;
> +
> +	/*
> +	 * RMP table entry format is not architectural and it can vary by processor and
> +	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
> +	 * model and family for which the RMP table entry format is currently defined for.
> +	 */
> +	if (family != 0x19 || model > 0xaf)
> +		goto nosnp;
> +
> +	if (amd_iommu_snp_enable())
> +		goto nosnp;
> +
> +	if (__snp_rmptable_init())
> +		goto nosnp;
> +
> +	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
> +
> +	return 0;
> +
> +nosnp:
> +	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +	return -ENOSYS;
> +}
> +
> +/*
> + * This must be called after the PCI subsystem. This is because amd_iommu_snp_enable()
> + * is called to ensure the IOMMU supports the SEV-SNP feature, which can only be
> + * called after subsys_initcall().
> + *
> + * NOTE: IOMMU is enforced by SNP to ensure that hypervisor cannot program DMA
> + * directly into guest private memory. In case of SNP, the IOMMU ensures that
> + * the page(s) used for DMA are hypervisor owned.
> + */
> +fs_initcall(snp_rmptable_init);
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 45efb7e5d725..1c9924de607a 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3802,7 +3802,7 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
>   	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
>   }
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_KVM_AMD_SEV
>   int amd_iommu_snp_enable(void)
>   {
>   	/*
> diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
> index 99a5201d9e62..55fc03cb3968 100644
> --- a/include/linux/amd-iommu.h
> +++ b/include/linux/amd-iommu.h
> @@ -205,7 +205,7 @@ int amd_iommu_pc_get_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn,
>   		u64 *value);
>   struct amd_iommu *get_amd_iommu(unsigned int idx);
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_KVM_AMD_SEV
>   int amd_iommu_snp_enable(void);
>   #endif
>   
