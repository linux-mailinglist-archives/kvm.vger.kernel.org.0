Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209392F8BB6
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 06:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbhAPFlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Jan 2021 00:41:10 -0500
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:52729
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbhAPFlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Jan 2021 00:41:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSngOlWFnLnCvRu3cW1jBl/jqdtC3UfsYWL6MT60FyXNIwwyeTWlzzO0UqzZvtETLz0RTqk6Zg2ztbTVIb42Vz+OKM4NQXccicBQFdXKOmsuwK2J51eZAkrJ42fba/R+1qGbLnJFYho00ZDIInoZUGbUNuPA2Qv3YkQs0LkPQgRE60/KV5NrdYYzuH4NE4gFGXsK6VccupYBA0cGNrEOQsoMX1n20KkfJqdvZypl0o5LB+wlR3Ue6imPvmlrj26WKql96tLfQtWfv9K98pvIkNMWCCFGPF5+L8MyIwQGO5FoLijrEFkqUW5iedvHxS5hGlQoTGdQ47Fu0pHrNXyLQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vj2nHtTE6mcmHZYFyIRsQjzp/7v4Pxt3hdGtwDpXldg=;
 b=MVdEZL68ZBcNGQ2ApGpIWHUoXfnavV6ERPncbFFpRg0ymma04U0dzgwzlNdCvpAL/RnbRrQPtNFHaELGN+iqLR1alfV3dkHyMGUamE/xRChMMgZx14iBI03TNmC2TwwzaV0/i1up6coE5GUadQp64XJmOqgTJgzUXNufFCRMk054ilkoh/zUObfN+mljB4RdpoJjjR6pHxZCqF+0bdxZpEJkS7BLSCqzpMrvURlTrb7iRtBi4YuGgQ/J50+fXPAHJmGmwddsvbvO6MXtj4cdSMlAg3hfYlaLmVZvaLaAWieAIxc5EIonOBOwovKB2YxgEjTt7oj1ACniWxWW+Fqmrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vj2nHtTE6mcmHZYFyIRsQjzp/7v4Pxt3hdGtwDpXldg=;
 b=WUK56kg1hRITbQDZRnsZgdpaV2gHflS+cYvv9LK6SeEL0Dowkwd3zyFDTwjt8jsxMNG6oBgSY40UEW4MxvJFCUIbRhuo6Rc627MPiEF+84FoUCjNje6n0RQsyEwWWKKOpb9k2AYE7qUedX1qbZQlIOc8bNin0GI/81hNdYqZxuk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3868.namprd12.prod.outlook.com (2603:10b6:5:1c8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.12; Sat, 16 Jan 2021 05:40:12 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Sat, 16 Jan 2021
 05:40:12 +0000
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>
References: <20210116002517.548769-1-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <015821b1-9abc-caed-8af6-c44950bd04f0@amd.com>
Date:   Fri, 15 Jan 2021 23:40:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210116002517.548769-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0701CA0024.namprd07.prod.outlook.com
 (2603:10b6:803:28::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0701CA0024.namprd07.prod.outlook.com (2603:10b6:803:28::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Sat, 16 Jan 2021 05:40:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 544a74ec-a70f-4ebc-321d-08d8b9e1314d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3868:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3868BBBFB1303C32F834953EECA60@DM6PR12MB3868.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtwRXoCAN4VgVLDP8urMUAyMrp5DiC/rkhiNnfH77/MJIJWWqTtO25oxru/YDGQ8YjsRIYD05nUjB2JIzzILeYuhLBezz0mrAJ/fvBu0O9T6n4klUKzjlZutCkJuipv2tVrYcCVdjm6h3HNnbREz3b7dByQk6lpWlstjBP7KzoUGKg2Nz1l8mZGrgDKrrH0yT/LC+L+alIREZCAZ5CLuDVvBrGWQodRwBkYoyiRX9ZSR5bnItYENRw4jLIlHVd7sQrWEvAmqm4GBLdOCeO/zHF4qZpThFhSjh+ZCLgN8xIG16BxSz6euYbuttxcaZ2ufYgd0T6JQTdvv+NoIV5QkWY3O+f3Pk66uYI6Ce59AU2cVF3X4bbFJR4yxFC6/StsRSvSV2jStYjNUhhRoI+DqSseeRMFRDP2dgUipnVD/TXUXARKl9CGZ5sBa1xWuWgS3DFrQNcCBn6rnqrDkdx87+k14jfQNNiDCOXSf6DC6x/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(7416002)(31686004)(2616005)(2906002)(8676002)(6512007)(66556008)(66946007)(66476007)(6486002)(54906003)(31696002)(110136005)(8936002)(956004)(16526019)(186003)(36756003)(6506007)(83380400001)(478600001)(53546011)(4326008)(52116002)(86362001)(5660300002)(30864003)(26005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?djlYVnl5cjRubGphRmtvSmV0b3hIbVRQeHdQQ1JkNXZxR29ZY3g3ZjB5ZzFV?=
 =?utf-8?B?Mytra0R4aktuenZKU2p6Tm5kS25iWEZWSlE2M0ptNTRsTkJNa0NValg2dU1q?=
 =?utf-8?B?VkxpVmhXWjAvNENvOUVjdm83ZVZoUWttQ0IvaExwampLdXdjRjU4Qk8xaWNm?=
 =?utf-8?B?RWptbUljQ2Rka1VHM0pLQktDOER3UUFId1B0MkF0QUlCcVA3UTVFV2FXUUJE?=
 =?utf-8?B?M081YkN0aGwwYnNQZU0wOFllbG1kTUFSU3JoNUxPSTJ6eDRtU0tyK2h5VkY0?=
 =?utf-8?B?WXYyUnNPSGJsSE94elE4bGxUNGg5cnpUeHFCTHlKQ0VhT2prNHJkSDNLZjhi?=
 =?utf-8?B?QVd0dTFQMGhiWlAyU3ltTlFLODl6RkFnLzdpamQyUDdYSmYyV1hlY01jODZy?=
 =?utf-8?B?ZUJqNU9NUWhxTXVPbGlieW1JckxucEhqc2N3K2tlRWh0ZnV5bldNZ0FhZW9h?=
 =?utf-8?B?eG1XcE9QdS8xK3loRzJQanB1d2V5WWdKRWY4Q3plN0RrLzVPTlplMW5PYzk2?=
 =?utf-8?B?RnIwaEtQK3lCdVBvUSt1RU40ZUc0dmhvMkNIMWtSM1NQWkFmRTJZVXg1YXpu?=
 =?utf-8?B?dTMrNnNOTFNlVTd3Y2FRMlc5T01tRDhSS2w0WHZSQzZ2bUM4NUI2eCtUVVhP?=
 =?utf-8?B?QlBtVlE2TjVKbmUraU1sNG03SzBIb3VrelJHK3ZvRmtNT29WcTRTVG1sUm9T?=
 =?utf-8?B?dGx5QzlheTg4OU5XYldQaWFvV1NwZWNWSnZpK2tMQ2dnUHVzV0NHTCs3VVdS?=
 =?utf-8?B?RHdMT3VuT015dHRzdWoxY1VCYW9CTWNKWHNPc09PZ2U2ai96OGZJUG94eGJP?=
 =?utf-8?B?dSsxZFViWFoxNytnWVRPaWtpUGpDZVhpN3pDNVdqdGE0ZVVlNVlkQ3VRMUVN?=
 =?utf-8?B?NThTc2VGaFBGdFY3S1hrUXU1TEVTOTZkdGNYeHJrUUl0c3hGbjVsTW92ZUo1?=
 =?utf-8?B?bDQvVHlvZm1ocUh0TVArMngrMzQ4aWtTdzJ6bE1HUi83NFhjUkErcWt4UXJ5?=
 =?utf-8?B?TzFyRHVuQXVJNUhjc0xTeTBYNGxBeFZTSXpCTVk2TTVHYkFJOEdDWTdKVFNj?=
 =?utf-8?B?d0o5K2RVS0s0eVMvL0M1YVlPblMyeXdzTmtrWlJMbS9rcEJGSzBUMXhKZnE2?=
 =?utf-8?B?ODNMRjR3d3h0V055SlcwT203UER5SXdHb1RFNjhHNnNVK1BNb3lMNFNFVEd4?=
 =?utf-8?B?bzZnbjJVamk0bXdkYlFsSkxFb1AvMlhhT0M3R0RjWUhDYUJWMDRMK1lQdGxT?=
 =?utf-8?B?SDJSeEgzR2VRQnBHSktucDlaQkZhYkgxcWJUWnlrd2k2M3RkRllVU0tSK0VP?=
 =?utf-8?Q?lQ53fyrZ5sTcSBxoBot08BLVtKFRBInbh1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 544a74ec-a70f-4ebc-321d-08d8b9e1314d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2021 05:40:12.2076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SuSKc/7gcK7J9z+E20QRHUjmTvUkymmwUOp4evHGLFVrx3A7AvnldLu4fRTmhN//rCfpt+SwPv+N2BFv70OYIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3868
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/21 6:25 PM, Sean Christopherson wrote:
> Introduce a new Kconfig, AMD_SEV_ES_GUEST, to control the inclusion of
> support for running as an SEV-ES guest.  Pivoting on AMD_MEM_ENCRYPT for
> guest SEV-ES support is undesirable for host-only kernel builds as
> AMD_MEM_ENCRYPT is also required to enable KVM/host support for SEV and
> SEV-ES.

I believe only KVM_AMD_SEV is required to enable the KVM support to run 
SEV and SEV-ES guests. The AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT setting is 
only used to determine whether to enable the KVM SEV/SEV-ES support by 
default on module load.

Thanks,
Tom

> 
> A dedicated Kconfig also makes it easier to understand exactly what is
> and isn't support in a given configuration.
> 
> Opportunistically update the AMD_MEM_ENCRYPT help text to note that it
> also enables support for SEV guests.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Tested everything except an actual SEV-ES guest, I don't yet have a
> workflow for testing those.
> 
>   arch/x86/Kconfig                           | 13 ++++++++++++-
>   arch/x86/boot/compressed/Makefile          |  2 +-
>   arch/x86/boot/compressed/idt_64.c          |  7 ++++---
>   arch/x86/boot/compressed/idt_handlers_64.S |  2 +-
>   arch/x86/boot/compressed/misc.h            |  5 ++++-
>   arch/x86/entry/entry_64.S                  |  2 +-
>   arch/x86/include/asm/idtentry.h            |  2 +-
>   arch/x86/include/asm/mem_encrypt.h         | 12 ++++++++----
>   arch/x86/include/asm/realmode.h            |  4 ++--
>   arch/x86/include/asm/sev-es.h              |  2 +-
>   arch/x86/kernel/Makefile                   |  2 +-
>   arch/x86/kernel/head64.c                   |  6 +++---
>   arch/x86/kernel/head_64.S                  |  6 +++---
>   arch/x86/kernel/idt.c                      |  2 +-
>   arch/x86/kernel/kvm.c                      |  4 ++--
>   arch/x86/mm/mem_encrypt.c                  |  2 ++
>   arch/x86/realmode/rm/header.S              |  2 +-
>   arch/x86/realmode/rm/trampoline_64.S       |  4 ++--
>   18 files changed, 50 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 21f851179ff0..5f03e6313113 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1527,12 +1527,14 @@ config AMD_MEM_ENCRYPT
>   	select DYNAMIC_PHYSICAL_MASK
>   	select ARCH_USE_MEMREMAP_PROT
>   	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
> -	select INSTRUCTION_DECODER
>   	help
>   	  Say yes to enable support for the encryption of system memory.
>   	  This requires an AMD processor that supports Secure Memory
>   	  Encryption (SME).
>   
> +	  This also enables support for running as a Secure Encrypted
> +	  Virtualization (SEV) guest.
> +
>   config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>   	bool "Activate AMD Secure Memory Encryption (SME) by default"
>   	default y
> @@ -1547,6 +1549,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>   	  If set to N, then the encryption of system memory can be
>   	  activated with the mem_encrypt=on command line option.
>   
> +config AMD_SEV_ES_GUEST
> +	bool "AMD Secure Encrypted Virtualization - Encrypted State (SEV-ES) Guest support"
> +	depends on AMD_MEM_ENCRYPT
> +	select INSTRUCTION_DECODER
> +	help
> +	  Enable support for running as a Secure Encrypted Virtualization -
> +	  Encrypted State (SEV-ES) Guest.  This enables SEV-ES boot protocol
> +	  changes, #VC handling, SEV-ES specific hypercalls, etc...
> +
>   # Common NUMA Features
>   config NUMA
>   	bool "NUMA Memory Allocation and Scheduler Support"
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index e0bc3988c3fa..8c036b6fc0c2 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -92,7 +92,7 @@ ifdef CONFIG_X86_64
>   	vmlinux-objs-y += $(obj)/idt_64.o $(obj)/idt_handlers_64.o
>   	vmlinux-objs-y += $(obj)/mem_encrypt.o
>   	vmlinux-objs-y += $(obj)/pgtable_64.o
> -	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-es.o
> +	vmlinux-objs-$(CONFIG_AMD_SEV_ES_GUEST) += $(obj)/sev-es.o
>   endif
>   
>   vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
> diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
> index 804a502ee0d2..916dde4a84b6 100644
> --- a/arch/x86/boot/compressed/idt_64.c
> +++ b/arch/x86/boot/compressed/idt_64.c
> @@ -33,8 +33,9 @@ void load_stage1_idt(void)
>   	boot_idt_desc.address = (unsigned long)boot_idt;
>   
>   
> -	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
> -		set_idt_entry(X86_TRAP_VC, boot_stage1_vc);
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
> +	set_idt_entry(X86_TRAP_VC, boot_stage1_vc);
> +#endif
>   
>   	load_boot_idt(&boot_idt_desc);
>   }
> @@ -46,7 +47,7 @@ void load_stage2_idt(void)
>   
>   	set_idt_entry(X86_TRAP_PF, boot_page_fault);
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   	set_idt_entry(X86_TRAP_VC, boot_stage2_vc);
>   #endif
>   
> diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
> index 22890e199f5b..b2b1fad0d0e2 100644
> --- a/arch/x86/boot/compressed/idt_handlers_64.S
> +++ b/arch/x86/boot/compressed/idt_handlers_64.S
> @@ -71,7 +71,7 @@ SYM_FUNC_END(\name)
>   
>   EXCEPTION_HANDLER	boot_page_fault do_boot_page_fault error_code=1
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   EXCEPTION_HANDLER	boot_stage1_vc do_vc_no_ghcb		error_code=1
>   EXCEPTION_HANDLER	boot_stage2_vc do_boot_stage2_vc	error_code=1
>   #endif
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index 901ea5ebec22..3a0393d50e92 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -118,7 +118,7 @@ static inline void console_init(void)
>   
>   void set_sev_encryption_mask(void);
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   void sev_es_shutdown_ghcb(void);
>   extern bool sev_es_check_ghcb_fault(unsigned long address);
>   #else
> @@ -157,8 +157,11 @@ extern struct desc_ptr boot_idt_desc;
>   
>   /* IDT Entry Points */
>   void boot_page_fault(void);
> +
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   void boot_stage1_vc(void);
>   void boot_stage2_vc(void);
> +#endif
>   
>   unsigned long sev_verify_cbit(unsigned long cr3);
>   
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index cad08703c4ad..98e52ec3cbf6 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -448,7 +448,7 @@ _ASM_NOKPROBE(\asmsym)
>   SYM_CODE_END(\asmsym)
>   .endm
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   /**
>    * idtentry_vc - Macro to generate entry stub for #VC
>    * @vector:		Vector number
> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
> index 247a60a47331..bc3a22d67741 100644
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -607,7 +607,7 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_DB,	xenpv_exc_debug);
>   DECLARE_IDTENTRY_DF(X86_TRAP_DF,	exc_double_fault);
>   
>   /* #VC */
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   DECLARE_IDTENTRY_VC(X86_TRAP_VC,	exc_vmm_communication);
>   #endif
>   
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 31c4df123aa0..a3f04b9b1a11 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -50,10 +50,8 @@ void __init mem_encrypt_free_decrypted_mem(void);
>   /* Architecture __weak replacement functions */
>   void __init mem_encrypt_init(void);
>   
> -void __init sev_es_init_vc_handling(void);
>   bool sme_active(void);
>   bool sev_active(void);
> -bool sev_es_active(void);
>   
>   #define __bss_decrypted __section(".bss..decrypted")
>   
> @@ -75,10 +73,8 @@ static inline void __init sev_setup_arch(void) { }
>   static inline void __init sme_encrypt_kernel(struct boot_params *bp) { }
>   static inline void __init sme_enable(struct boot_params *bp) { }
>   
> -static inline void sev_es_init_vc_handling(void) { }
>   static inline bool sme_active(void) { return false; }
>   static inline bool sev_active(void) { return false; }
> -static inline bool sev_es_active(void) { return false; }
>   
>   static inline int __init
>   early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
> @@ -91,6 +87,14 @@ static inline void mem_encrypt_free_decrypted_mem(void) { }
>   
>   #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>   
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
> +bool sev_es_active(void);
> +void __init sev_es_init_vc_handling(void);
> +#else
> +static inline bool sev_es_active(void) { return false; }
> +static inline void sev_es_init_vc_handling(void) { }
> +#endif /* CONFIG_AMD_SEV_ES_GUEST */
> +
>   /*
>    * The __sme_pa() and __sme_pa_nodebug() macros are meant for use when
>    * writing to or comparing values from the cr3 register.  Having the
> diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
> index 5db5d083c873..353449b26589 100644
> --- a/arch/x86/include/asm/realmode.h
> +++ b/arch/x86/include/asm/realmode.h
> @@ -21,7 +21,7 @@ struct real_mode_header {
>   	/* SMP trampoline */
>   	u32	trampoline_start;
>   	u32	trampoline_header;
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   	u32	sev_es_trampoline_start;
>   #endif
>   #ifdef CONFIG_X86_64
> @@ -60,7 +60,7 @@ extern unsigned char real_mode_blob_end[];
>   extern unsigned long initial_code;
>   extern unsigned long initial_gs;
>   extern unsigned long initial_stack;
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   extern unsigned long initial_vc_handler;
>   #endif
>   
> diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
> index cf1d957c7091..146dc77dc67e 100644
> --- a/arch/x86/include/asm/sev-es.h
> +++ b/arch/x86/include/asm/sev-es.h
> @@ -81,7 +81,7 @@ extern void vc_no_ghcb(void);
>   extern void vc_boot_ghcb(void);
>   extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   extern struct static_key_false sev_es_enable_key;
>   extern void __sev_es_ist_enter(struct pt_regs *regs);
>   extern void __sev_es_ist_exit(void);
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 5eeb808eb024..d2119dc1e6f9 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -150,7 +150,7 @@ obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
>   obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
>   obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
>   
> -obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev-es.o
> +obj-$(CONFIG_AMD_SEV_ES_GUEST)		+= sev-es.o
>   ###
>   # 64 bit specific files
>   ifeq ($(CONFIG_X86_64),y)
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 5e9beb77cafd..dafe13db714c 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -405,7 +405,7 @@ void __init do_early_exception(struct pt_regs *regs, int trapnr)
>   	    early_make_pgtable(native_read_cr2()))
>   		return;
>   
> -	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT) &&
> +	if (IS_ENABLED(CONFIG_AMD_SEV_ES_GUEST) &&
>   	    trapnr == X86_TRAP_VC && handle_vc_boot_ghcb(regs))
>   		return;
>   
> @@ -563,7 +563,7 @@ static void startup_64_load_idt(unsigned long physbase)
>   	gate_desc *idt = fixup_pointer(bringup_idt_table, physbase);
>   
>   
> -	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
> +	if (IS_ENABLED(CONFIG_AMD_SEV_ES_GUEST)) {
>   		void *handler;
>   
>   		/* VMM Communication Exception */
> @@ -579,7 +579,7 @@ static void startup_64_load_idt(unsigned long physbase)
>   void early_setup_idt(void)
>   {
>   	/* VMM Communication Exception */
> -	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
> +	if (IS_ENABLED(CONFIG_AMD_SEV_ES_GUEST))
>   		set_bringup_idt_handler(bringup_idt_table, X86_TRAP_VC, vc_boot_ghcb);
>   
>   	bringup_idt_descr.address = (unsigned long)bringup_idt_table;
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 04bddaaba8e2..01243ec06ee6 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -300,7 +300,7 @@ SYM_CODE_START(start_cpu0)
>   SYM_CODE_END(start_cpu0)
>   #endif
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   /*
>    * VC Exception handler used during early boot when running on kernel
>    * addresses, but before the switch to the idt_table can be made.
> @@ -338,7 +338,7 @@ SYM_CODE_END(vc_boot_ghcb)
>   	.balign	8
>   SYM_DATA(initial_code,	.quad x86_64_start_kernel)
>   SYM_DATA(initial_gs,	.quad INIT_PER_CPU_VAR(fixed_percpu_data))
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
>   #endif
>   
> @@ -403,7 +403,7 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
>   	jmp restore_regs_and_return_to_kernel
>   SYM_CODE_END(early_idt_handler_common)
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   /*
>    * VC Exception handler used during very early boot. The
>    * early_idt_handler_array can't be used because it returns via the
> diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
> index ee1a283f8e96..ab783e81b806 100644
> --- a/arch/x86/kernel/idt.c
> +++ b/arch/x86/kernel/idt.c
> @@ -232,7 +232,7 @@ static const __initconst struct idt_data ist_idts[] = {
>   #ifdef CONFIG_X86_MCE
>   	ISTG(X86_TRAP_MC,	asm_exc_machine_check,		IST_INDEX_MCE),
>   #endif
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   	ISTG(X86_TRAP_VC,	asm_exc_vmm_communication,	IST_INDEX_VC),
>   #endif
>   };
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5e78e01ca3b4..69efdd20836a 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -751,7 +751,7 @@ static void __init kvm_init_platform(void)
>   	x86_platform.apic_post_init = kvm_apic_init;
>   }
>   
> -#if defined(CONFIG_AMD_MEM_ENCRYPT)
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   static void kvm_sev_es_hcall_prepare(struct ghcb *ghcb, struct pt_regs *regs)
>   {
>   	/* RAX and CPL are already in the GHCB */
> @@ -776,7 +776,7 @@ const __initconst struct hypervisor_x86 x86_hyper_kvm = {
>   	.init.x2apic_available		= kvm_para_available,
>   	.init.msi_ext_dest_id		= kvm_msi_ext_dest_id,
>   	.init.init_platform		= kvm_init_platform,
> -#if defined(CONFIG_AMD_MEM_ENCRYPT)
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   	.runtime.sev_es_hcall_prepare	= kvm_sev_es_hcall_prepare,
>   	.runtime.sev_es_hcall_finish	= kvm_sev_es_hcall_finish,
>   #endif
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index c79e5736ab2b..a527537133d1 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -383,11 +383,13 @@ bool sev_active(void)
>   	return sev_status & MSR_AMD64_SEV_ENABLED;
>   }
>   
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   /* Needs to be called from non-instrumentable code */
>   bool noinstr sev_es_active(void)
>   {
>   	return sev_status & MSR_AMD64_SEV_ES_ENABLED;
>   }
> +#endif
>   
>   /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
>   bool force_dma_unencrypted(struct device *dev)
> diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
> index 8c1db5bf5d78..88b2435b52d5 100644
> --- a/arch/x86/realmode/rm/header.S
> +++ b/arch/x86/realmode/rm/header.S
> @@ -20,7 +20,7 @@ SYM_DATA_START(real_mode_header)
>   	/* SMP trampoline */
>   	.long	pa_trampoline_start
>   	.long	pa_trampoline_header
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   	.long	pa_sev_es_trampoline_start
>   #endif
>   #ifdef CONFIG_X86_64
> diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
> index 84c5d1b33d10..9830f3a3a90c 100644
> --- a/arch/x86/realmode/rm/trampoline_64.S
> +++ b/arch/x86/realmode/rm/trampoline_64.S
> @@ -81,7 +81,7 @@ no_longmode:
>   	jmp no_longmode
>   SYM_CODE_END(trampoline_start)
>   
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_AMD_SEV_ES_GUEST
>   /* SEV-ES supports non-zero IP for entry points - no alignment needed */
>   SYM_CODE_START(sev_es_trampoline_start)
>   	cli			# We should be safe anyway
> @@ -98,7 +98,7 @@ SYM_CODE_START(sev_es_trampoline_start)
>   
>   	jmp	.Lswitch_to_protected
>   SYM_CODE_END(sev_es_trampoline_start)
> -#endif	/* CONFIG_AMD_MEM_ENCRYPT */
> +#endif	/* CONFIG_AMD_SEV_ES_GUEST */
>   
>   #include "../kernel/verify_cpu.S"
>   
> 
