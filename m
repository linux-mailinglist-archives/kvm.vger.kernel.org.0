Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1636E7A0517
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbjINNLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbjINNLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:11:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2105.outbound.protection.outlook.com [40.107.92.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2F91A5
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeBV2p6Y1LoAv7bSCfzliuwtaLxCueHX5n19onQwZnPfMjlGt6aqXK37wZ9I6ZDb5SBBV90d55Vcs4ZuV66el5e+mM98F24zEw+zI1s5DvAOembQKlmUbFcwl2MdtI4m6JU85L/HJs88RcB6zyL3pmEKD/PlFdiqNFRivlvP4QB65M09VQGQeZUpFVoTUHXU7H7opBRHZNRdHZMWzqQEuVKMG9ZCQLNfVWsKy1KsLCdT7Bz/1e8hK7cJxI4BLdz5XcgPZ0RFmv46IA6/uhA3l5j/Ng9OKFmAEClwKrQKbKy7LKf9PvU/5k5azH5cci1qu0b1veotNwczASDdbuNkLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Y5xgaV+ZNWjTmlXtqLZ3MRlMAQDbNvkH9Z1In1J1Hc=;
 b=DlG0f8XHK3Trh/2JzwtXqJcoWLFmwQq5IuXJVSTZInyr4WI5N4P+0nWDeGLwPpjnbR60T5Qlc9621uL/0jxdZeySbOauObok7NOD3/ktDxaHCMlsEq6Hfp9jqmVE4YS1ld2XBVHXIJbI1TjYBgXL4Ul2mNJhqpM8uLQCRSZ5D+aNl/3b3vwGcgn/WsV6r/5iUiBD5KPcQFkxyvxbLesxTmTkKR0ZfKZh1XEPy35ZMo4qF0Ch22OOWRIgCia/GmIC3RfSh4B41rsKacjK8FtYMMgVR98/r1WbYqp4eSkOSb67oxvOYVAYkuKNkVBfeLx3sV/dlP6SNkAgq90hnfmPFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Y5xgaV+ZNWjTmlXtqLZ3MRlMAQDbNvkH9Z1In1J1Hc=;
 b=JW/YJA9gejuC1UvZDIgwEU+6XFrpqo8lhU01KoEJ9L0McU8Wq62jWopgKGJ5wBoe5lYw3S0OjLQINIEZKNQOsWkzg2dND7mrMQM50yBxeHtLgpfOpGAS037oMtpdkfsuSKs2DytFYxqHSXCL9I/5cTyVe8Vn5FpQLPVTjBqtVd8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA1PR01MB8296.prod.exchangelabs.com (2603:10b6:806:388::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20; Thu, 14 Sep 2023 13:11:03 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d686:ac07:89b3:e724]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d686:ac07:89b3:e724%3]) with mapi id 15.20.6792.020; Thu, 14 Sep 2023
 13:11:03 +0000
Message-ID: <8d0f77a8-00db-93f7-aeae-bf96190b6f5b@os.amperecomputing.com>
Date:   Thu, 14 Sep 2023 18:40:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v10 29/59] KVM: arm64: nv: Unmap/flush shadow stage 2 page
 tables
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Christoffer Dall <christoffer.dall@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        D Scott Phillips <scott@os.amperecomputing.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <20230515173103.1017669-30-maz@kernel.org>
Content-Language: en-US
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230515173103.1017669-30-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::29) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA1PR01MB8296:EE_
X-MS-Office365-Filtering-Correlation-Id: 46e83d62-a397-446c-9f33-08dbb5240c1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q23uWWJzrlJM8oGq0nFAx1xD1FvaayZIOM/fsaN3l5opIyAfu49fOy/UCeGJhyEig6DR1kohbOmqDW8v4lqucAbbfj2SIqkLHBcDMyrJJQ+UNrBkMm4XBN+K8/5fhLHsFcw/npSy4aNkpylZ3PLZkKJRilrw4ReBIbADUKKYjc2XsI7DOdMKUPDE+wz/riDOzbtBOUdo1hZOaVxEy1FIUQAYZhmI1v+3mv1lqlm0ZdxrOcS8g0gVqcAJvRAlr4NN3/WhOe0R3yo+dwDYe+Wpr4ilh1FRekQotZN1gz5upej2fjyrBFW7Id3GGbqpz2vfJPtlTKKtdm5foFPYZGlVxazR6dyleRpKzp0iu1cV0HET85qha0csLouGw9vrKRFWUl1ok1o1+KhTceMj9Ws2YCHMR6hOkcujo+5AVUwXSbGSsWVgchJ+zdyxQzRO8Z1fmafa3BoriN3iHXTxnwwRY9NGbOsMG66WOpbO/+SJ6PZ0GT2v41JimqVG6SrKAUK0elN2+ZFnbt1PxLe78ssf3bmuwWbRQONfZp/fHGc1tKlCPmJSfoRXNzf2QV/NygejLmeycpp4a42cWMYZuG2xFVtIuzNDkiCCRlb63sYQhMEd4BM0M4BaSAUsripbQL23
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(346002)(39850400004)(376002)(186009)(1800799009)(451199024)(6506007)(6486002)(6512007)(53546011)(6666004)(38100700002)(478600001)(110136005)(66556008)(54906003)(66476007)(316002)(66946007)(41300700001)(31686004)(2616005)(83380400001)(26005)(107886003)(5660300002)(8936002)(4326008)(8676002)(31696002)(86362001)(66899024)(2906002)(7416002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SktXU3Brc3NvUGNWSVFPckc2V1orUGhrcktlTkxSN1lzTjNIMXlWdkQxUzFS?=
 =?utf-8?B?cysyN0VxZWtiUHVjM05XelJ1Tzc5VlBIcGRXaHNZeVBwYUZ6VGVPVXpXVHpP?=
 =?utf-8?B?c3VXdzIrd0RwK01mU0JnbVJDWnVZSTEyc0ZscFNFc1JZUGlUZ1NlTmVEQi9Y?=
 =?utf-8?B?RFpGNVU3Y3VacU9jWm1SSStiQ0dmTVMwOW52dzUxUm5HUENrVHZWY2ZZWnMx?=
 =?utf-8?B?NDV6WTNDQVB0djZvTFZ3bmZMSXJXbUhBSGpPYnZudml0c1BmRUs5QXhKak9R?=
 =?utf-8?B?MXVMd2lvZkJrQms5enphZUQzV2U3NlkwVVI0NmMxbHNsWDhQYllnUXhSdklw?=
 =?utf-8?B?Y2hvZW5GZGRLSjlva3pxMy94Y29jM3V1V3NPdkprUFRqRXpUVEY4WmZ6ZEcv?=
 =?utf-8?B?UUxwOGFPU2NxUkRJZkpXK2wxT3EveEdYSTYxNWNmTktKOTl1Tmd6QU1ZWHhQ?=
 =?utf-8?B?TFZSanFNeUdNOHV3OGJMalVlVytFd1N5NTVSRU5MMDQ1NUN2WEZla2dYSTNX?=
 =?utf-8?B?REltcHdPQWhNZVFSUTYraHBtd2JZSHFFL0hVWCtkRkZyVXFhMytHVGtHOUoy?=
 =?utf-8?B?dmhIWmFSZWhrbFhCeDNYd2p1aHhvM0JKL1ZMRmdUQk4zU0tXdkRBMUc0aU5P?=
 =?utf-8?B?WU9yQjNUaUY4bDlJaGMycHVIdUh0RnNkd0x0U251Y3VNMkZmK01DQ2lKbkhK?=
 =?utf-8?B?Zm94YWhyZVBoNUJ1eGRPUlh0SHlYRmxoQnhqNG45clhwZ0Q3eTROd05ZbEp2?=
 =?utf-8?B?SjdjZ2dtMWRTbTdyK25kRmlCdnhaWjQybFBnZmVBdUNrUEhJNWZib1A3Rzd1?=
 =?utf-8?B?bklLakxoc3VUM2dWUmFoOTlZandVZ2p3aC9ITCtLQVBQNVZFL0RMZTJZaG1u?=
 =?utf-8?B?NUpLRWxNZjkwL2JXYW9TSy9MODV0NlVXU3h2OTZPcVhybWwyNCs3YjJ2Q1hZ?=
 =?utf-8?B?eXNOQkRLTEdKS0xsTDNXQUx5b2l3bE0xYys5Q0g3OWRNTFp6eWtnWWs3MitX?=
 =?utf-8?B?OFdiYXArTElkQjhSTk9hcHZFTENUTmE2TEpGcUR0S3F4SjBmUmNaeStHQ0M2?=
 =?utf-8?B?Z1h5TnBOemZpUFp0NUxxZ0hyajBlazRlR0pNTkpoZWYwMDNJb1dpTU1oR055?=
 =?utf-8?B?RGJxV29nOVZqSGxYL0lKWEJmdEZCeVlDMGRsSDdOaGVIcEFwdnJ0V1hXZmRB?=
 =?utf-8?B?UU0zUXVvNUZwUnhlS2tZRlpweStRTnJSNHl5WnBzTXpkWlpsVmdNSGw3L2lY?=
 =?utf-8?B?anhvdEg5MmQvQVFXbTEyQVlMUmpyN2d3VUZLWTY3aWROZTJVdjFheE1IMEJJ?=
 =?utf-8?B?MDNEUTlBOXR4bVFhSCtaZ3JFakJDNUJlNWtKcytFTDBSTmxuVjUxQmFKMVFP?=
 =?utf-8?B?RkxxcDZzbXpjdnlCYWc5YUE4N1RldlBJQ1RWQkpYYkZoNUhXNlArVjdGT1Rq?=
 =?utf-8?B?NmFVcnp6Wnl1TkMxdFdOblp6cUlHcXpDNm1rVTVNNk1mL1ZWOHdvTnBOSTRs?=
 =?utf-8?B?bExyd3E3aTVGcjNRd1M2bUV1R2hYek01RmpGU3JYdFpBa1dxYU16c0ZYQjZT?=
 =?utf-8?B?bjZCSENuY25CaVU4Z2dFaUJMWDllYnlJeDk3UEFVS08yWWRoejJHTUNLS01j?=
 =?utf-8?B?N0NRN2NPV0taUFIyajR2b2E2S0tlWWhlZ2FxNnJkVFJPczJFRE4rbXJ1Wmdw?=
 =?utf-8?B?VnpmWlJ2NWcrS211VmM4WmdOdHZ0ZDZyM2xNMmJDNTlTTE5zakZmc2s5a3NG?=
 =?utf-8?B?NkRrTjdCc0lzVlpac3ZIZldDTmpFZjhLNDdPSEdNS3FDdlNYZVZNbWtoYTJm?=
 =?utf-8?B?RFBTaXRFczltL3duTS9rS2N5UjZ4U3piQ2hSQTdSMmxGVlVwcEZkRVJjeGNO?=
 =?utf-8?B?eFBUQUZTQWhmMUJzeVlzL283MURyeGlCbkZIM0dSdktTQjNVdEMrVHU1cndt?=
 =?utf-8?B?L1AwczVwdVhqem1vS2orZFRLK3Y2dWtwNkd6azQwQU1QMER4NDNwTGx4R2RS?=
 =?utf-8?B?MUVsUXNValhMSElhZTQ1NGRyMm1uZ3VZeGp4M3NEYSsybjZ0RC9ocGxHa1Uy?=
 =?utf-8?B?SmpzbHk0RkR4SU1NUmdWTnE1Q0RBY0JET1RMZWpiUmltVmY4TThDdmF0WE5Y?=
 =?utf-8?B?SWJDZWJXdy9TR0paVTR2dThOdnJ4SFFMVENnSnBNc0ZjWUlSSWVkOU11NkM5?=
 =?utf-8?Q?l47VDe4KnRVjIvo7BbpvyEHAg7xnBJphZ9V2PYmxryJN?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46e83d62-a397-446c-9f33-08dbb5240c1e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 13:11:03.1350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpfOuyfk8wSVfysbw6njlx9oZ24EtJPh20DYfsqtP41w4unv2Dwdev6fDKTS4qbjirEz9hBodhewPsHtyydZB4IT+f/lMSAqRrcQ/YSb8zszVMBrVcLUWWwMGrV8LKd4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8296
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 15-05-2023 11:00 pm, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Unmap/flush shadow stage 2 page tables for the nested VMs as well as the
> stage 2 page table for the guest hypervisor.
> 
> Note: A bunch of the code in mmu.c relating to MMU notifiers is
> currently dealt with in an extremely abrupt way, for example by clearing
> out an entire shadow stage-2 table. This will be handled in a more
> efficient way using the reverse mapping feature in a later version of
> the patch series.

We are seeing spin-lock contention due to this patch when the 
Guest-Hypervisor(L1) is booted with higher number of cores and auto-numa 
is enabled on L0.
kvm_nested_s2_unmap is called as part of notifier call-back when numa 
page migration is happening and this function which holds lock becomes 
source of contention when there are more vCPUs are processing the 
auto-numa page fault/migration.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_mmu.h    |  3 +++
>   arch/arm64/include/asm/kvm_nested.h |  3 +++
>   arch/arm64/kvm/mmu.c                | 30 ++++++++++++++++++----
>   arch/arm64/kvm/nested.c             | 39 +++++++++++++++++++++++++++++
>   4 files changed, 70 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 896acdf98e71..d155b3871c4c 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -169,6 +169,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>   			   void __iomem **haddr);
>   int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>   			     void **haddr);
> +void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
> +			    phys_addr_t addr, phys_addr_t end);
>   void __init free_hyp_pgds(void);
>   
>   void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
> @@ -177,6 +179,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>   int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   			  phys_addr_t pa, unsigned long size, bool writable);
> +void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
>   
>   int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index f20d272fcd6d..d330b947d48a 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -111,6 +111,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>   extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>   				    struct kvm_s2_trans *trans);
>   extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
> +extern void kvm_nested_s2_wp(struct kvm *kvm);
> +extern void kvm_nested_s2_unmap(struct kvm *kvm);
> +extern void kvm_nested_s2_flush(struct kvm *kvm);
>   int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>   
>   extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1e19c59b8235..8144bb9b9ec8 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -245,13 +245,19 @@ void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>   	__unmap_stage2_range(mmu, start, size, true);
>   }
>   
> +void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
> +			    phys_addr_t addr, phys_addr_t end)
> +{
> +	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_flush);
> +}
> +
>   static void stage2_flush_memslot(struct kvm *kvm,
>   				 struct kvm_memory_slot *memslot)
>   {
>   	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>   	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>   
> -	stage2_apply_range_resched(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_flush);
> +	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>   }
>   
>   /**
> @@ -274,6 +280,8 @@ static void stage2_flush_vm(struct kvm *kvm)
>   	kvm_for_each_memslot(memslot, bkt, slots)
>   		stage2_flush_memslot(kvm, memslot);
>   
> +	kvm_nested_s2_flush(kvm);
> +
>   	write_unlock(&kvm->mmu_lock);
>   	srcu_read_unlock(&kvm->srcu, idx);
>   }
> @@ -888,6 +896,8 @@ void stage2_unmap_vm(struct kvm *kvm)
>   	kvm_for_each_memslot(memslot, bkt, slots)
>   		stage2_unmap_memslot(kvm, memslot);
>   
> +	kvm_nested_s2_unmap(kvm);
> +
>   	write_unlock(&kvm->mmu_lock);
>   	mmap_read_unlock(current->mm);
>   	srcu_read_unlock(&kvm->srcu, idx);
> @@ -987,12 +997,12 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   }
>   
>   /**
> - * stage2_wp_range() - write protect stage2 memory region range
> + * kvm_stage2_wp_range() - write protect stage2 memory region range
>    * @mmu:        The KVM stage-2 MMU pointer
>    * @addr:	Start address of range
>    * @end:	End address of range
>    */
> -static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> +void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
>   {
>   	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_wrprotect);
>   }
> @@ -1023,7 +1033,8 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>   	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
>   
>   	write_lock(&kvm->mmu_lock);
> -	stage2_wp_range(&kvm->arch.mmu, start, end);
> +	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
> +	kvm_nested_s2_wp(kvm);
>   	write_unlock(&kvm->mmu_lock);
>   	kvm_flush_remote_tlbs(kvm);
>   }
> @@ -1047,7 +1058,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>   	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
>   	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
>   
> -	stage2_wp_range(&kvm->arch.mmu, start, end);
> +	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
>   }
>   
>   /*
> @@ -1062,6 +1073,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   		gfn_t gfn_offset, unsigned long mask)
>   {
>   	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
> +	kvm_nested_s2_wp(kvm);
>   }
>   
>   static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> @@ -1720,6 +1732,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   			     (range->end - range->start) << PAGE_SHIFT,
>   			     range->may_block);
>   
> +	kvm_nested_s2_unmap(kvm);

This kvm_nested_s2_unmap/kvm_unmap_stage2_range is called for every 
active L2 and page table walk-through iterates for long iterations since 
kvm_phys_size(mmu) is pretty big size(atleast 48bits).
What would be the best fix if we want to avoid this unnessary long 
iteration of page table lookup?

>   	return false;
>   }
>   
> @@ -1754,6 +1767,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   			       PAGE_SIZE, __pfn_to_phys(pfn),
>   			       KVM_PGTABLE_PROT_R, NULL, 0);
>   
> +	kvm_nested_s2_unmap(kvm);
>   	return false;
>   }
>   
> @@ -1772,6 +1786,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   					range->start << PAGE_SHIFT);
>   	pte = __pte(kpte);
>   	return pte_valid(pte) && pte_young(pte);
> +
> +	/*
> +	 * TODO: Handle nested_mmu structures here using the reverse mapping in
> +	 * a later version of patch series.
> +	 */
>   }
>   
>   bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> @@ -2004,6 +2023,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   
>   	write_lock(&kvm->mmu_lock);
>   	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> +	kvm_nested_s2_unmap(kvm);
>   	write_unlock(&kvm->mmu_lock);
>   }
>   
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 73c0be25345a..948ac5b9638c 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -523,6 +523,45 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
>   	return kvm_inject_nested_sync(vcpu, esr_el2);
>   }
>   
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_wp(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
> +	}
> +}
> +
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_unmap(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(mmu));
> +	}
> +}
> +
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_flush(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
> +	}
> +}
> +
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
>   	int i;

Thanks,
Ganapat
