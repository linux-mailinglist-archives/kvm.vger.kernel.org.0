Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C842F1A62
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 17:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbhAKQDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 11:03:34 -0500
Received: from mail-bn8nam08on2081.outbound.protection.outlook.com ([40.107.100.81]:28256
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727180AbhAKQDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 11:03:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6/VGR0IrO0B6cKfIrQM6Ee/Ad8H3FtOijt1g58OrQ0vCoJlYv68z16GV7yEF0X84wwTIhSa+zlIUAhZiM52gLECLH50yaNAnVO1Mdqb8U1NxDO30JU1UhMESOkocFIEB1ltKoDqfs52EIgNLgp6ur3UT5W+z9jQdOPQ49Bvj1EahUl8j4cBReU8DoFZT+ywI9tKUlv6dyYL5KfzPyJhdXOga7jJ7u9IFewa37zazT//SSkaY+vWIuUioPh6okOlS7LGT+9P4iHa4527OeR46v1K3kluJJ1o42z1lgYb8CCduFEyvDXH2A/U2XY81HvplWDMrIwqX0fsa/Bg1/SVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRkBhxZ3CGsv9HOatfmHugF6kquCt7dAoRyCeQjWef4=;
 b=DpIjgU3F2WL2G4K1QCCJCe1kA3j/wgnEq9vj2q0hJMWt+33UZOd5fvk80ym219nwuFoaeqvMDsVapPrDs9h6+H8Bwu478Lf0IQnJR2Jfsw58YOjDVH5DoTevXSTvdi89sVsMVEmEYJst5y5zmKBOZ5Ivt8vtnf8AbdzxB+uPDpsTTjWsKyId/dvGsrg/xW407pczira5pwq4HU0pNzWOZiOA0edtJSu3hLypZzYpxmJB7HERmWz30ZTVhq9cDTwkAUZalujjYxgEgD3JJtOd4Uzt4WZcnvyC7pm4wefB4hXkKPpebbj3FBcpHEB2CsZFS1JfYHJ2qiFJfchySIG2ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRkBhxZ3CGsv9HOatfmHugF6kquCt7dAoRyCeQjWef4=;
 b=dw6IqMCCNv9sKP/6LuPrmh7Fh/aSINC6T5zvhuVyk/3NXOSF1Ceda1yzWz+uTVeER2nZhWcpg7ApmLtpPkl2DX98hL/yJgXG6m4lAb8tfoMVf7hAmDQfCC8yvrokqyKmKAYCooXobQ/gmrVLsliyEYsyaJDdM82KZL9+XqgZXEk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.9; Mon, 11 Jan 2021 16:02:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 16:02:40 +0000
Subject: Re: [PATCH 06/13] x86/sev: Rename global "sev_enabled" flag to
 "sev_guest"
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-7-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f6ed8566-6521-92f0-927e-1764d8074ce6@amd.com>
Date:   Mon, 11 Jan 2021 10:02:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210109004714.1341275-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0095.namprd12.prod.outlook.com
 (2603:10b6:802:21::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0095.namprd12.prod.outlook.com (2603:10b6:802:21::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 16:02:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9dec8690-b9b3-4160-7419-08d8b64a52e6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB337025C3C258F4494A43A6B7ECAB0@DM6PR12MB3370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9c18XBX8a4id1YltkEni62amtjqtrRr+qx/R9CnAG2nMz2x8QnAtwKacxRxIAJyGRebWayf17fsGx3gCKXGS1dTmcrjPtG60k8AnklVvfzhwotWoBYw1t5wViD/r8hHJyXjqi9YRf4j90BCQ8nb30uFsQSMvsKtEL3/tTYoByFrA6yXPwlhnccdVz9pjxD+5DXrN6F/ZGxbTe+LmGyLP4jr/1gbed5HKCaryPzB25Crupu/hZPDKAmIidFfeWLl9Oih6QUseIl/VJ4wyIZYqVchyKbXebKNMesSDp/G5KjOdoQJwuIRvlM+Iughm7OZHp6kY+4MG5UhzomTit1iKBkH9oG3AFNQV9Kb3fYteNl3BT0B+l0x9zt0KgcduO/ZxUdPr5fCSbqWUlQnE1+JxaaNm35W/oJ3mKZ+bhGqsCix0IDi2HGQmjyFyeJVY80hTmP82QN9lqBXlyDoommQdDCAMBckniZOg192AGlHBRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(66556008)(52116002)(83380400001)(66946007)(86362001)(36756003)(6506007)(4326008)(6512007)(316002)(54906003)(5660300002)(8936002)(478600001)(31686004)(2616005)(110136005)(31696002)(8676002)(53546011)(7416002)(2906002)(16526019)(66476007)(956004)(6486002)(186003)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dU0vR0VQdzlteEQ3YzRtQ2sxMDM0NkwvZEo0K3NFdW1qMEt3NEZqcGhHU1hE?=
 =?utf-8?B?eGwwYWtWeU83Y3VCTnNrc3NPZmc1elpwd1k3SjludzVxbUxQd3JFNG5Ca1hJ?=
 =?utf-8?B?UXJOUDBCVFhQN1hoZDEvdkZ4WXlibUZhSVBramVodzdJdnZUdm9wekdCbU1E?=
 =?utf-8?B?YlNHeFdwdk51dTQ4TGVTRlR3cGQxdWdKQXZxblYvb2R0NTJaSmVJcHo4ais1?=
 =?utf-8?B?bEJkbGlwSUtoc2ZjaFcwakJsMWFmRUYzeU85OVNiQk5aQmFPWVZ0bytWdG1H?=
 =?utf-8?B?R1YxaFhSdmRQeWdBKzJtVTAxcW9CQkthK1h1dnlaTXVqMVBNWHhDSVB5V0Vy?=
 =?utf-8?B?SERyb2JSSVJrU3hRc2pob01nZHBSTFNEcndiWDlra0FKY3h6L09IS3pubzVF?=
 =?utf-8?B?TUhyRjNSL1VKcG4zTVE3NEtvdVZidFhOUXQyZ1F6WVpPNk5kV3dUbG5jVkd2?=
 =?utf-8?B?YnlTOFEvU1lnSlBXekIzZThvYjVpRWxXK2tLQmZmQU5QR1Z4Y25kRkZIeHhr?=
 =?utf-8?B?eEpNVjdyNWJhaUEyRGw2ays2NmRyZWdPMHNZRzV3Snhvay9ieVNSYU1PUXpH?=
 =?utf-8?B?a0NyM0ZzSVRiY0lUb2EyUkVQK1I3aE4yZDdZTU9CYmdGSjZYN0ZjTFZabkZs?=
 =?utf-8?B?RDh5aG9CSUcxZzNNWWczVE0veTV2V1FlS2l0L21DeWc5NWpIUnpOL1NIdjdO?=
 =?utf-8?B?am9WL2srYUoxb2ZLWGZPeWhlb3dFdVpxOWNMSkI1VCt0WjFHTUJvc3l5RUxP?=
 =?utf-8?B?U1J2NUc4aGxPcUFZYjhURk1pdXBqZk4yL2trQllMNG8zSlNVZkdUSVQrZmND?=
 =?utf-8?B?ZXpCL1ZBcW1BS1RZdWpvdnkzUkZrYTZvTTVTWTFIUU5reXZkUnpFZkJvLzZL?=
 =?utf-8?B?cjg3M1EwUnVPU0hSaHo0cHpqOE91M2ZRcWFzVE85WFg1NkM1SUdTbENpY1Zy?=
 =?utf-8?B?Qm1LenV3MzBPM2lBcy95OVMwNVVxcFlEMllSaWlhT09Wbit6Vmlaa2M0bzhn?=
 =?utf-8?B?UWpKQnc2elB0Vk5ISmt3QklKRmVpdnZpL3JwK0dWVXF6b29vZzhnOFhob1hr?=
 =?utf-8?B?anQ3TnRibUdSMW5KSS9MMFExaDA0RjNoQXhHamc0dlAwUWdFTHZmNS9DTDZP?=
 =?utf-8?B?S1dxRXJ4VkJlK3FPdW5JSXV1V0FSb1lpSUdvREdBYm91a2xuMzVqOHkyU2xz?=
 =?utf-8?B?bnpFb2t5bzRhQ0QyOTNDQng0NnV3MVRnMGgzRXlKL1dRMlpqS3lFamxRZlFt?=
 =?utf-8?B?WTRVQzRRS09yRkQzL2YvcVhJY04wWDVIZ2dhczZOSmVjc29ROGp0UWtRanlu?=
 =?utf-8?Q?AAdpPpGi4BBbMnE8dWE6AVNMqZih638/wC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 16:02:40.6385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dec8690-b9b3-4160-7419-08d8b64a52e6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PWqVjH1t7oqAaUK2LtUwvmF9jR9RXZMVMQDUQ7sww9triFRAuJbjOaa79D1ulqgm8MuaqPOWvSzk2V9xvDmlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/21 6:47 PM, Sean Christopherson wrote:
> Use "guest" instead of "enabled" for the global "running as an SEV guest"
> flag to avoid confusion over whether "sev_enabled" refers to the guest or
> the host.  This will also allow KVM to usurp "sev_enabled" for its own
> purposes.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/include/asm/mem_encrypt.h | 2 +-
>   arch/x86/mm/mem_encrypt.c          | 4 ++--
>   arch/x86/mm/mem_encrypt_identity.c | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 2f62bbdd9d12..9b3990928674 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -20,7 +20,7 @@
>   
>   extern u64 sme_me_mask;
>   extern u64 sev_status;
> -extern bool sev_enabled;
> +extern bool sev_guest;
>   
>   void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
>   			 unsigned long decrypted_kernel_vaddr,
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index bc0833713be9..0f798355de03 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -44,7 +44,7 @@ EXPORT_SYMBOL(sme_me_mask);
>   DEFINE_STATIC_KEY_FALSE(sev_enable_key);
>   EXPORT_SYMBOL_GPL(sev_enable_key);
>   
> -bool sev_enabled __section(".data");
> +bool sev_guest __section(".data");
>   
>   /* Buffer used for early in-place encryption by BSP, no locking needed */
>   static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
> @@ -344,7 +344,7 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>    */
>   bool sme_active(void)
>   {
> -	return sme_me_mask && !sev_enabled;
> +	return sme_me_mask && !sev_guest;
>   }
>   
>   bool sev_active(void)
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index 6c5eb6f3f14f..91b6b899c02b 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -545,7 +545,7 @@ void __init sme_enable(struct boot_params *bp)
>   
>   		/* SEV state cannot be controlled by a command line option */
>   		sme_me_mask = me_mask;
> -		sev_enabled = true;
> +		sev_guest = true;
>   		physical_mask &= ~sme_me_mask;
>   		return;
>   	}
> 
