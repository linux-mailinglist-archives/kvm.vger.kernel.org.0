Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920D6154A12
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 18:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgBFRNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 12:13:46 -0500
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:32851
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727358AbgBFRNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 12:13:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmdzJbTxkYQpLBYYHiTIp8pThTrvWJCv47I/vLDX/qBMcqVfRKbDhG/QX4BPWSEqbMUGhfG6mHqcOYE+U6OdwnkDE+FJy6wv0lWMoql4o5/O1fiFl0LnCSr2PBq7xxchKdAVBS3TTLSqQ1s62KvM70QNlqlfdy4Bldz0qk4I6hGpiIxkcLdgQ0gzn15p/MwWziBW2ekoMGKH4z65i+x3Kftru4ybRTYNnzVWOJJwPvQEOEVVAsHBwaigTLN8JbPvCPGMdfE1/7YeXhW+AOtTnj0MmYvYvxNb5fwkp0JzUnpqj2EpXp4c5EUkr+bgyN6bzKXOUqNMD25KcQlEHgyGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SDzZ98X/wE4CDb5CS4eSakvpadWr327SGSw91hF3rM=;
 b=kISdpwEJFhcRIYnZKpg+QGH2QpjhM50MFN/NgwOhaFnxe2TksB5nvkk0wF0VumtLeM1sCYzA0z84IVjxnMbscmujHBGnBZczPvau7Tfj69BP8nSREigxlq29EX9IbooTPDSF9pdRiM8mYJO0sRrjJxT2BG0xab0EeGAr8YWMuIavB1nWhtgcr4B8VYdHklPaMHws3NcOnYAk47JcoIHA7L58CTSa52UH+SbRPduipenYWCearDhUAuBjiv1cpRzyOu0LP3EJjt9LM7nUz2VPIjdcOje1Hu/Jh5aEiMcI/U8j8+6WeHsVBjgyffG3CWJKENi22kqY2xXjKf9Bx8fyUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SDzZ98X/wE4CDb5CS4eSakvpadWr327SGSw91hF3rM=;
 b=VcK7KUjD4FOId2+Y8/YdPG1WNeuG5vRV+VyZ9myHtGE5zVC0R8FQtSygJc6wtmPEomwxIg1IwiWfx5T5z2ZTc3eQP0popx4nslobb7V9cQJupclWgACYpFQPrCErxfd4+foUUmEhRmz7h1CXmeI8bz6+nC89r/QtKab6/E2Se+s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Wei.Huang2@amd.com; 
Received: from MN2PR12MB3999.namprd12.prod.outlook.com (10.255.239.219) by
 MN2PR12MB3901.namprd12.prod.outlook.com (10.255.238.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 17:13:40 +0000
Received: from MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::a867:e7ad:695c:d87d]) by MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::a867:e7ad:695c:d87d%6]) with mapi id 15.20.2686.035; Thu, 6 Feb 2020
 17:13:40 +0000
Date:   Thu, 6 Feb 2020 11:13:38 -0600
From:   Wei Huang <wei.huang2@amd.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, drjones@redhat.com
Subject: Re: [PATCH v4 1/3] selftests: KVM: Replace get_gdt/idt_base() by
 get_gdt/idt()
Message-ID: <20200206171338.GB2465308@weiserver.amd.com>
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-2-eric.auger@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206104710.16077-2-eric.auger@redhat.com>
X-ClientProxiedBy: SN4PR0701CA0046.namprd07.prod.outlook.com
 (2603:10b6:803:2d::33) To MN2PR12MB3999.namprd12.prod.outlook.com
 (2603:10b6:208:158::27)
Importance: high
MIME-Version: 1.0
Received: from localhost (165.204.77.1) by SN4PR0701CA0046.namprd07.prod.outlook.com (2603:10b6:803:2d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 17:13:40 +0000
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0829031e-dcaa-4812-8d1f-08d7ab27e949
X-MS-TrafficTypeDiagnostic: MN2PR12MB3901:
X-Microsoft-Antispam-PRVS: <MN2PR12MB39019C43C73F7385035E7F9BCF1D0@MN2PR12MB3901.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(189003)(199004)(1076003)(6916009)(66946007)(66476007)(66556008)(52116002)(86362001)(6496006)(478600001)(5660300002)(33656002)(8936002)(26005)(2906002)(8676002)(6486002)(186003)(81166006)(316002)(4326008)(956004)(81156014)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3901;H:MN2PR12MB3999.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MaB4Y+1ls0NlMizPGXuM6j6gnpv1kUGhcfZDxsrWV0NwJw0w4e5iPRgpXFmKM0U4+SSy48isIsbvLf2doE5kABeD+6r3JnI/ydDg8sEyK3YQUlYTtpl6xQOO7oWTXC6iWuaGWtZwGjqdT0JXJIwF2YAJriC3FnnCqryB988s/FKko5FQeSHw8zjYmBNhAUbZz88MdegbiFYrFeltKcSPpC+zhCqv3wuBj41oYPhJ8a8R6uy3XanhD2m/nhHGYblzi/fJplpPUYoGTfriF/x3j0grHu0rNaYxQzzLQE4zeQp8jjlnpEOUJuV993oMvv1wTyuy1fUXywoncxtNBmxYc1R+0BiJW7NDCPm+hT3+qYdP4nZHYGFmQ9ozbNcklgMWZ9OiQWHz9208RmAbqOey9u4M3cOjuhHbbP97DYHLzQG4aShyaBUVwp5ZnE/4q/L
X-MS-Exchange-AntiSpam-MessageData: AlRlkql1wLSsgw5HN3k8qdLV54GDDp4mwtAqTAI5dNb9G9Q6N3rxNjGM24LzzbdoYvYxyL00GxNqkVJPhfU1UoUPM6KxPjPab7nNuMx/3kPjB76NUiYd73uDutOHlFMaLMdU+rCooMRFNNsaUiNxnQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0829031e-dcaa-4812-8d1f-08d7ab27e949
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 17:13:40.4409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYLgzNpNvo1BUR++4zmQLF6R6siovHyUs8918/YQRxegVFhgmKNrUUpc7sUMJGtq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3901
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06 11:47, Eric Auger wrote:
> get_gdt_base() and get_idt_base() only return the base address
> of the descriptor tables. Soon we will need to get the size as well.
> Change the prototype of those functions so that they return
> the whole desc_ptr struct instead of the address field.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> ---
> 
> v3 -> v4:
> - Collected R-b's
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 8 ++++----
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c           | 6 +++---
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index aa6451b3f740..6f7fffaea2e8 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -220,20 +220,20 @@ static inline void set_cr4(uint64_t val)
>  	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
>  }
>  
> -static inline uint64_t get_gdt_base(void)
> +static inline struct desc_ptr get_gdt(void)
>  {
>  	struct desc_ptr gdt;
>  	__asm__ __volatile__("sgdt %[gdt]"
>  			     : /* output */ [gdt]"=m"(gdt));
> -	return gdt.address;
> +	return gdt;
>  }
>  
> -static inline uint64_t get_idt_base(void)
> +static inline struct desc_ptr get_idt(void)
>  {
>  	struct desc_ptr idt;
>  	__asm__ __volatile__("sidt %[idt]"
>  			     : /* output */ [idt]"=m"(idt));
> -	return idt.address;
> +	return idt;
>  }
>  
>  #define SET_XMM(__var, __xmm) \
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index 85064baf5e97..7aaa99ca4dbc 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -288,9 +288,9 @@ static inline void init_vmcs_host_state(void)
>  	vmwrite(HOST_FS_BASE, rdmsr(MSR_FS_BASE));
>  	vmwrite(HOST_GS_BASE, rdmsr(MSR_GS_BASE));
>  	vmwrite(HOST_TR_BASE,
> -		get_desc64_base((struct desc64 *)(get_gdt_base() + get_tr())));
> -	vmwrite(HOST_GDTR_BASE, get_gdt_base());
> -	vmwrite(HOST_IDTR_BASE, get_idt_base());
> +		get_desc64_base((struct desc64 *)(get_gdt().address + get_tr())));
> +	vmwrite(HOST_GDTR_BASE, get_gdt().address);
> +	vmwrite(HOST_IDTR_BASE, get_idt().address);
>  	vmwrite(HOST_IA32_SYSENTER_ESP, rdmsr(MSR_IA32_SYSENTER_ESP));
>  	vmwrite(HOST_IA32_SYSENTER_EIP, rdmsr(MSR_IA32_SYSENTER_EIP));
>  }

Reviewed-by: Wei Huang <wei.huang2@amd.com>
