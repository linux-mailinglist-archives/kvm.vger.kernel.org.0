Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B054E35586F
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345972AbhDFPrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:47:33 -0400
Received: from mail-eopbgr760050.outbound.protection.outlook.com ([40.107.76.50]:12122
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239495AbhDFPrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 11:47:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUF8300kdD/kOqTc7J2hmqhUKHb3iUX8Vinsrh/1t18L5yqjL+7WoTE7pnyCsVQ2V/EKKlOhwXAh1mOsUmN+6NKLfInwgL6dE3+D9rIP+DtHky8mSwAGIPYEP/iF0YDrruc0eRUFAJYSycWsv/ZxoiC2UV7KcLImjS7we6yQSPFnj0rWJhboaNRcZwW3MR5x3gWPih5EJ7vsT+ScFDuoeR2oelEQadndZQ2gkq/O9IkQmpK4NiGAr70hqOW448jk5BHhGHSAJTOXdf+RmPwzScPrBpxtCMwOoyRCvSBET/mhSxDP28vHEDaHG2p+MQx0P8OqYEej1CbvojD/QKv9dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mtnl+ZzqZeVeL+aIMplAgL0689LO430oQCuHBm5mXI=;
 b=myFAjHygsSP7YkPr35fN3BuIijJFKbABxMP29xI6PL0cD5R8Q+PsgGWLcrabnxPtXjRhQaG7sN3KC/XeZk/e3JbU8UdWSQWbGFNfcKXv+RsABx1NTwbknkGq9sTqswDSDwOE0KMSa4bNPlm94giIHQoFc7Bf64odJnaamByMNp6JWG1vnTg0MZumpqdaO5D6DwhTZD7RQus3vu6f7DV9nvP6VEXAPWvpVrqVvk3B2UCFObCjPXjCiWtzm0rQtI0WCJ8FECzqq0aVekI/irqegKensteW93PS74Fg8NyrA/5rUO+pcdQzYKJYNKX2TS4vwW44ZF7nieahIsX1H3ytSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mtnl+ZzqZeVeL+aIMplAgL0689LO430oQCuHBm5mXI=;
 b=KAG/xe27kd2NpaehETPXd5O/iknpecRuqp1V3mqC0e7ugaGUwnb475ScAK3Bw7wjqDLYZw9Z9p7B+mszq5IsHnqqxBR+/3j2dvzDfH+BWTAwzer+UvEGgnK71fhEtaz+1+gK8qZhzzz0Kkv8hNTZ/N+ieM0BMIHhbti/aXe3WCo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 15:47:21 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 15:47:21 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate the
 memory used for the GHCB
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
Date:   Tue, 6 Apr 2021 10:47:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210406103358.GL17806@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0200.namprd04.prod.outlook.com
 (2603:10b6:806:126::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0200.namprd04.prod.outlook.com (2603:10b6:806:126::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 15:47:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ce98570-9f00-44a9-374d-08d8f913437c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB451161BD04DD1048039BE49BE5769@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I6e8AVJga11n210gxz7LQpmI0uGESBhcF9t0m95uUyozWf0rroAsxys4U44PzT54TiYxg8QaFy7P52g0LjOe9AW1ukQtWRYADCOmpcTLXEiIypwvoiNRzS+UBOLV5HIssFW+aEwfVGqDfH12O1+MJv/D3bJJ8Zp4VxzRbG8L9rs4D3Mr98EUAzfouytyyBVQteKxhOagNYMDB/x1TdYImHgomleXnK7Uv8UkDvhE5qX7Z55LHM9l0tNmB/hEcHc3vqDMa8/iIdnTblp9PqdoqoJUjM9qA7osuWoLb6O4ZI4Holbhklk9HtJ+Jxf+jksFFPJQe6Y6o6oeScolfZM+cgxJB8H7wm9UAHiV+zPipGGYUxXCZBl8LspxPtOS2MGSwDruIUkvXmBIYxsXwjVk4rQqGjsX1TGY1QpgwQURXf8U2/AKKoLv8uvPOfnQlKurZ+KRzaIUAB4KR7Tpe+X8E4gDIjDMxS1Txb5thjSp5uXG8EL+bsqPIwVDPAdOcTNkVEUuUlLTv1z+PWXAZ+PsPKE3Th8rcQkUBuW3ZCruArlsSPtA9pijkkNoeF0WRl2Zrt6P71AeNzwDN7Is4s/fEOr8omxtKMckuE6spytIn8Zy99hB+6A3UL6zGgFk2NdLSFWpSxImPJZcos090Aqni09MJDyP1HEtRNPPB06PtRFGn1kD/08dRh9iaI7OCVGeWK9guDPmj//xSlu5HBYCGJSMMuzBqiGg4gk2KiC0dk3xVQsonsxDEoGqKqcMjA8l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(30864003)(16526019)(8936002)(8676002)(26005)(316002)(956004)(2906002)(7416002)(53546011)(6506007)(6916009)(52116002)(38350700001)(66946007)(186003)(5660300002)(4326008)(66556008)(66476007)(54906003)(2616005)(31696002)(15650500001)(83380400001)(6486002)(86362001)(36756003)(31686004)(6512007)(44832011)(478600001)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UVpVZnV4cTVLb1VUTm9ldVB4Y1lVN25CcDVmMmc3NG4yYmpLOStNdmFIbisx?=
 =?utf-8?B?aXpYYzZPWlA1RDRCVWE3WWxENyt2bUhTTnpTRWF2VkFHWHhDK2R1QWxSbW9H?=
 =?utf-8?B?Z3dZZmtlcFR1UERsUGpaWXBjWTYrS0NXTU9HZVhXY1o3OVBkNTUwc21JV3h1?=
 =?utf-8?B?TlJoQ3ltc3psUXBrRlh6Q1d4eGJXZlVnQXhPdU0yS0owejlzU01rd0tZMEJ0?=
 =?utf-8?B?RVMzc2hKWUNoK2tEaXFScjVyT1V1Rkx3WWtXc2hPUWVVamNTQ2ZQL1NINGRX?=
 =?utf-8?B?RUF1UXIwU1Y2TnZTQVYvK0RvOUJoclM2dnNOSjFYdTVjUEpvMHVpLytmTVRz?=
 =?utf-8?B?N2xKcmp6YXZqcmtaaHhVazJDOGJ5bmdreWY4NU9aNC85WnZxdENjZ2wyZTRs?=
 =?utf-8?B?L0NKNitJUDlBTlp3dGlFejlTZnVlaXNRRXFnZExyN1ZGSytWU3d2SGlIZVln?=
 =?utf-8?B?UUJCb2lvM0ZFVVg3OTNhaWRmR2ZGVG45cGtJcVhabVdmZVNwV1piMWFXVVNV?=
 =?utf-8?B?ZlRzMkE1dERPd0lvRmZBY0kzdjl5MEJIL3V0WVdSQWh6N0M0cXRuSlFlUzBC?=
 =?utf-8?B?QlBMMzhaMjZOTFYxSVJseEtYQUI2U1VEZEhZV1BYbXU4cWpkVmhud3krcHlV?=
 =?utf-8?B?dUp6SzNUdG82N3RFbjMzdW9qb0FvY2tiU1BEMjExamk0ZFVZcUFsWWtwOGJQ?=
 =?utf-8?B?cE5xRnQzalMweDltdnpLQ1orZ1l2d0Q3TnRLZHlVRlZRYXJTTC9nczVBTldZ?=
 =?utf-8?B?aGFoYmRCYSsrZHBPYzJUbEVNTnNIT0tUMHQyTnZVR0gvMFp0SHhrQ0dwaGdk?=
 =?utf-8?B?NUxqT2M5UkpiNWxTeS95aUZmZ2g4YU9sNk5obDRVZ1FpTUhQQmxVK3VoZW9V?=
 =?utf-8?B?T3FHd2tmcnBhaUErMFgvNUcyUFRwbkZKZXp3bFRCZHY2eUx5RkUvTlEzSDlP?=
 =?utf-8?B?eXo5SDN6TTFkWlc1QTVROXFjN3NKVC9UY1RmNGZzYzBEaGdBN0xiSTQ4Wm1Y?=
 =?utf-8?B?cG9CRERTYUhKK3laS2IxaVFFNWFkdUxNbjBJWFlwa0p5ZHU0RXRTaVoyMnl5?=
 =?utf-8?B?YUg4U1IzaVpOUmZIS0JJNXlXU09EMjdUWTZyY0lwWG5rTDZoV3huOGZDYWhM?=
 =?utf-8?B?K1NJeTlpQ05LMUxRNFEwUTNJcGp6ZWdLRHdoVitYVnY4c2JYVnVrY2lERGZi?=
 =?utf-8?B?ZUFXZFBOTUU3VjNqdUJLUVp3V0xKS1lxclRDTnQwV0RqU0lUWHZZaS83NEZa?=
 =?utf-8?B?bkM3bnhTY0dXc0EvQXdyRjZaOVkrSGswZVlrNjR1ZmNlZCtTdnZCbi9lVmQ0?=
 =?utf-8?B?QmNsY3Z6elFTbkNKOHh4TFI5RkdlZUVlZjJjdnI3dy9hdVVHclRRKzBsSWsr?=
 =?utf-8?B?dFhjWlBJQmRaWFNHdENRbGhGT3RhdkE5aWxRM1BZOVZROGZLdHRrSUkzM2Q1?=
 =?utf-8?B?ejJLZWNUNUIwcy9peGhhejhwNFVqQjgrV3hDQytVSUd5bitBQmcreWMxOXBD?=
 =?utf-8?B?WVM4VDlKWmFDRE8zUUVrZzlWNmVEMXI2RVk4eHRKUVVkTWtIQnlaMmdyTlFH?=
 =?utf-8?B?dS9SWW50V3RXc29xd1NWUk5WUVhxR2ZjUFA0Z1QzZExMYmZ2VVFudUMraUFQ?=
 =?utf-8?B?Qld5a285UHVvQ2ZybXZyUUI5aXExdHYvdjdITHhObG9kNjcySlVOZHlqRGMv?=
 =?utf-8?B?VnhLekxwVXFiTEZHc09WMWZ5bVBpZHhmS3NOYmhTWjltcjRRZWtSdkJHdkU1?=
 =?utf-8?Q?xItQbDSIptrBDZtMT8RFp/DwwBdSeTuhTzFqTVD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce98570-9f00-44a9-374d-08d8f913437c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 15:47:21.0141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8nVlr/j+0UDLuPxnIPgd8sIQSiZDD2B02rXXROWTYA9COsmkitracfTUvAnV4RfBO9juAnHfgnGU5+km4Zn+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/6/21 5:33 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:17AM -0500, Brijesh Singh wrote:
>> Many of the integrity guarantees of SEV-SNP are enforced through the
>> Reverse Map Table (RMP). Each RMP entry contains the GPA at which a
>> particular page of DRAM should be mapped. The VMs can request the
>> hypervisor to add pages in the RMP table via the Page State Change VMGEXIT
>> defined in the GHCB specification section 2.5.1 and 4.1.6. Inside each RMP
>> entry is a Validated flag; this flag is automatically cleared to 0 by the
>> CPU hardware when a new RMP entry is created for a guest. Each VM page
>> can be either validated or invalidated, as indicated by the Validated
>> flag in the RMP entry. Memory access to a private page that is not
>> validated generates a #VC. A VM can use PVALIDATE instruction to validate
>> the private page before using it.
> I guess this should say "A VM must use the PVALIDATE insn to validate
> that private page before using it." Otherwise it can't use it, right.
> Thus the "must" and not "can".


Noted, I should have used "must".

>
>> To maintain the security guarantee of SEV-SNP guests, when transitioning
>> a memory from private to shared, the guest must invalidate the memory range
>> before asking the hypervisor to change the page state to shared in the RMP
>> table.
> So first you talk about memory pages, now about memory range...
>
>> After the page is mapped private in the page table, the guest must issue a
> ... and now about pages again. Let's talk pages only pls.


Noted, I will stick to memory pages. thanks


>
>> page state change VMGEXIT to make the memory private in the RMP table and
>> validate it. If the memory is not validated after its added in the RMP table
>> as private, then a VC exception (page-not-validated) will be raised.
> Didn't you just say this already above?


Yes I said it in the start of the commit, I will work to avoid the
repetition.


>> We do
> Who's "we"?
>
>> not support the page-not-validated exception yet, so it will crash the guest.
>>
>> On boot, BIOS should have validated the entire system memory. During
>> the kernel decompression stage, the VC handler uses the
>> set_memory_decrypted() to make the GHCB page shared (i.e clear encryption
>> attribute). And while exiting from the decompression, it calls the
>> set_memory_encyrpted() to make the page private.
> Hmm, that commit message needs reorganizing, from
> Documentation/process/submitting-patches.rst:
>
>  "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>   instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>   to do frotz", as if you are giving orders to the codebase to change
>   its behaviour."
>
> So this should say something along the lines of "Add helpers for validating
> pages in the decompression stage" or so.

I will improve the commit message to avoid using the "[we]" or "[I]".
Add helpers looks good, thanks.


>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Joerg Roedel <jroedel@suse.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Dave Hansen <dave.hansen@intel.com>
>> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
> Btw, you don't really need to add those CCs to the patch - it is enough
> if you Cc the folks when you send the patches with git.


Noted.

>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/boot/compressed/Makefile       |   1 +
>>  arch/x86/boot/compressed/ident_map_64.c |  18 ++++
>>  arch/x86/boot/compressed/sev-snp.c      | 115 ++++++++++++++++++++++++
>>  arch/x86/boot/compressed/sev-snp.h      |  25 ++++++
>>  4 files changed, 159 insertions(+)
>>  create mode 100644 arch/x86/boot/compressed/sev-snp.c
>>  create mode 100644 arch/x86/boot/compressed/sev-snp.h
>>
>> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
>> index e0bc3988c3fa..4d422aae8a86 100644
>> --- a/arch/x86/boot/compressed/Makefile
>> +++ b/arch/x86/boot/compressed/Makefile
>> @@ -93,6 +93,7 @@ ifdef CONFIG_X86_64
>>  	vmlinux-objs-y += $(obj)/mem_encrypt.o
>>  	vmlinux-objs-y += $(obj)/pgtable_64.o
>>  	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-es.o
>> +	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-snp.o
> Yeah, as before, make that a single sev.o and put everything in it.


Yes, all the SNP changes will be merged into sev.c.

>
>>  endif
>>  
>>  vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
>> diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
>> index f7213d0943b8..0a420ce5550f 100644
>> --- a/arch/x86/boot/compressed/ident_map_64.c
>> +++ b/arch/x86/boot/compressed/ident_map_64.c
>> @@ -37,6 +37,8 @@
>>  #include <asm/setup.h>	/* For COMMAND_LINE_SIZE */
>>  #undef _SETUP
>>  
>> +#include "sev-snp.h"
>> +
>>  extern unsigned long get_cmd_line_ptr(void);
>>  
>>  /* Used by PAGE_KERN* macros: */
>> @@ -278,12 +280,28 @@ static int set_clr_page_flags(struct x86_mapping_info *info,
>>  	if ((set | clr) & _PAGE_ENC)
>>  		clflush_page(address);
>>  
>> +	/*
>> +	 * If the encryption attribute is being cleared, then change the page state to
>> +	 * shared in the RMP entry. Change of the page state must be done before the
>> +	 * PTE updates.
>> +	 */
>> +	if (clr & _PAGE_ENC)
>> +		sev_snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);
> The statement above already looks at clr - just merge the two together.


Noted.

>
>> +
>>  	/* Update PTE */
>>  	pte = *ptep;
>>  	pte = pte_set_flags(pte, set);
>>  	pte = pte_clear_flags(pte, clr);
>>  	set_pte(ptep, pte);
>>  
>> +	/*
>> +	 * If the encryption attribute is being set, then change the page state to
>> +	 * private in the RMP entry. The page state must be done after the PTE
>> +	 * is updated.
>> +	 */
>> +	if (set & _PAGE_ENC)
>> +		sev_snp_set_page_private(pte_pfn(*ptep) << PAGE_SHIFT);
>> +
>>  	/* Flush TLB after changing encryption attribute */
>>  	write_cr3(top_level_pgt);
>>  
>> diff --git a/arch/x86/boot/compressed/sev-snp.c b/arch/x86/boot/compressed/sev-snp.c
>> new file mode 100644
>> index 000000000000..5c25103b0df1
>> --- /dev/null
>> +++ b/arch/x86/boot/compressed/sev-snp.c
>> @@ -0,0 +1,115 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * AMD SEV SNP support
>> + *
>> + * Author: Brijesh Singh <brijesh.singh@amd.com>
>> + *
>> + */
>> +
>> +#include "misc.h"
>> +#include "error.h"
>> +
>> +#include <asm/msr-index.h>
>> +#include <asm/sev-snp.h>
>> +#include <asm/sev-es.h>
>> +
>> +#include "sev-snp.h"
>> +
>> +static bool sev_snp_enabled(void)
>> +{
>> +	unsigned long low, high;
>> +	u64 val;
>> +
>> +	asm volatile("rdmsr\n" : "=a" (low), "=d" (high) :
>> +			"c" (MSR_AMD64_SEV));
>> +
>> +	val = (high << 32) | low;
>> +
>> +	if (val & MSR_AMD64_SEV_SNP_ENABLED)
>> +		return true;
>> +
>> +	return false;
>> +}
> arch/x86/boot/compressed/mem_encrypt.S already touches
> MSR_AMD64_SEV - you can extend that function there and cache the
> MSR_AMD64_SEV_SNP_ENABLED too, depending on where you need it. That
> function is called in .code32 though.
>
> If not, you should at least cache the MSR so that you don't have to read
> it each time.
I think we will not be able to use the status saved from the mem_encrypt.S.

The call sequence is something like this:

arch/x86/boot/compressed/head_64.S

   call get_sev_encryption_bit

arch/x86/boot/compressed/mem_encrypt.S

get_sev_encryption_bit:

    // Reads the Memory encryption CPUID Fn8000_001F

    // Check if the SEV is available

    // If SEV is available then call the rdmsr MSR_AMD64_SEV


When SEV-{ES,SNP} is enabled, read CPUID Fn8000_001F  will cause a #VC.
Inside the #VC handler, the first thing we do is setup the early GHCB.
While setting up the GHCB we check if SNP is enabled. If SNP is enabled
then perform additional setup (e.g GHCB GPA request etc).

I will try caching the value on first read.


>
>> +
>> +/* Provides sev_snp_{wr,rd}_ghcb_msr() */
>> +#include "sev-common.c"
>> +
>> +/* Provides sev_es_terminate() */
>> +#include "../../kernel/sev-common-shared.c"
>> +
>> +static void sev_snp_pages_state_change(unsigned long paddr, int op)
> no need for too many prefixes on static functions - just call this one
> __change_page_state() or so, so that the below one can be called...


Noted.

>> +{
>> +	u64 pfn = paddr >> PAGE_SHIFT;
>> +	u64 old, val;
>> +
>> +	/* save the old GHCB MSR */
>> +	old = sev_es_rd_ghcb_msr();
> Why do you need to save/restore GHCB MSR? Other callers simply go and
> write into it the new command...


Before the GHCB is established the caller does not need to save and
restore MSRs. The page_state_change() uses the GHCB MSR protocol and it
can be called before and after the GHCB is established hence I am saving
and restoring GHCB MSRs.

>
>> +
>> +	/* Issue VMGEXIT to change the page state */
>> +	sev_es_wr_ghcb_msr(GHCB_SNP_PAGE_STATE_REQ_GFN(pfn, op));
>> +	VMGEXIT();
>> +
>> +	/* Read the response of the VMGEXIT */
>> +	val = sev_es_rd_ghcb_msr();
>> +	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PAGE_STATE_CHANGE_RESP) ||
>> +	    (GHCB_SNP_PAGE_STATE_RESP_VAL(val) != 0))
> No need for the "!= 0"


Noted.

>
>> +		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
> So what does that mean?
>
> *Any* and *all* page state changes which fail immediately terminate a
> guest? Why?


The hypervisor uses the RMPUPDATE instruction to add the pages in the
RMP table. If RMPUPDATE fails, then it will be communicated to the
guest. Now its up to guest on what it wants to do. I choose to terminate
because guest can't resolve this step on its own. It needs help from the
hypervisor and hypervisor has bailed on it. Depending on request type,
the next step will either fail or we go into infinite loop. Lets
consider an example:

1. Guest asked to add a page as a private in RMP table.

2. Hypervisor fail to add the page in the RMP table and return an error.

3. Guest ignored the error code and moved to the step to validate the page.

4. The page validation instruction expects that page must be added in
the RMP table. In our case the page was not added in the RMP table. So
it will cause #NPF (rmp violation).

5. On #NPF, hypervisor will try adding the page as private but it will
fail (same as #2). This will keep repeating and guest will not make any
progress.

I choose to return "void" from page_state_change() because caller can't
do anything with error code. Some of the failure may have security
implication, terminate the guest  as soon as we detect an error condition.


> Then, how do we communicate this to the guest user what has happened?
>
> Can GHCB_SEV_ES_REASON_GENERAL_REQUEST be something special like
>
> GHCB_SEV_ES_REASON_PSC_FAILURE
>
> or so, so that users know what has happened?


Current GHCB does not have special code for this. But I think Linux
guest can define a special code which can be used to indicate the
termination reason.

Tom,

Any other suggestion ?


>
>> +	/* Restore the GHCB MSR value */
>> +	sev_es_wr_ghcb_msr(old);
>> +}
>> +
>> +static void sev_snp_issue_pvalidate(unsigned long paddr, bool validate)
> That one you can call simply "pvalidate" and then the layering with
> __pvalidate works too.


Yes.

>> +{
>> +	unsigned long eflags;
>> +	int rc;
>> +
>> +	rc = __pvalidate(paddr, RMP_PG_SIZE_4K, validate, &eflags);
>> +	if (rc) {
>> +		error("Failed to validate address");
>> +		goto e_fail;
>> +	}
>> +
>> +	/* Check for the double validation and assert on failure */
>> +	if (eflags & X86_EFLAGS_CF) {
>> +		error("Double validation detected");
>> +		goto e_fail;
>> +	}
>> +
>> +	return;
>> +e_fail:
>> +	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
>> +}
>> +
>> +static void sev_snp_set_page_private_shared(unsigned long paddr, int op)
> ... change_page_state()
>
>> +{
>> +	if (!sev_snp_enabled())
>> +		return;
>> +
>> +	/*
>> +	 * We are change the page state from private to shared, invalidate the pages before
> s/We are//


Noted.


>
>> +	 * making the page state change in the RMP table.
>> +	 */
>> +	if (op == SNP_PAGE_STATE_SHARED)
>> +		sev_snp_issue_pvalidate(paddr, false);
> The new RMP Validated bit is specified in EDX[0]. The C standard defines
>
> 	false == 0
> 	true == 1
>
> but make that explicit pls:
>
> 	pvalidate(paddr, 0);
> 	pvalidate(paddr, 1);


Noted.


>
>> +
>> +	/* Request the page state change in the RMP table. */
>> +	sev_snp_pages_state_change(paddr, op);
>> +
>> +	/*
>> +	 * Now that pages are added in the RMP table as a private memory, validate the
>> +	 * memory range so that it is consistent with the RMP entry.
>> +	 */
>> +	if (op == SNP_PAGE_STATE_PRIVATE)
>> +		sev_snp_issue_pvalidate(paddr, true);
>> +}
>> +
>> +void sev_snp_set_page_private(unsigned long paddr)
>> +{
>> +	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_PRIVATE);
>> +}
>> +
>> +void sev_snp_set_page_shared(unsigned long paddr)
>> +{
>> +	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_SHARED);
>> +}
>> diff --git a/arch/x86/boot/compressed/sev-snp.h b/arch/x86/boot/compressed/sev-snp.h
>> new file mode 100644
>> index 000000000000..12fe9581a255
>> --- /dev/null
>> +++ b/arch/x86/boot/compressed/sev-snp.h
> A single sev.h I guess.
>
>> @@ -0,0 +1,25 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * AMD SEV Secure Nested Paging Support
>> + *
>> + * Copyright (C) 2021 Advanced Micro Devices, Inc.
>> + *
>> + * Author: Brijesh Singh <brijesh.singh@amd.com>
>> + */
>> +
>> +#ifndef __COMPRESSED_SECURE_NESTED_PAGING_H
>> +#define __COMPRESSED_SECURE_NESTED_PAGING_H
> Look at how other x86 headers define their guards' format.


Noted.


> Thx.
>
