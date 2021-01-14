Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C879F2F6D34
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbhANV3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:29:12 -0500
Received: from mail-bn8nam12on2087.outbound.protection.outlook.com ([40.107.237.87]:1318
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbhANV3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:29:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGLVovMl6nnTrdsvDNXy6wmFAEu7XFpu8SjdH+XRt0PoUwV27xbOYTYZb/Y6T2+pKXePA2l5Od2Tj4au4W0cpjkCAjEhGqZwYklzUUZ/UTm0mgYYJXukCHO5c7DVXzsst/FlLx/CrbCNY+MVIuu384vpdc+ZkcKIzUcDqbWvW+rXd8v4IveRwlScRCDUw63UhSVBuR1RnLhrSvuWXF9ekuh+4OknTyo3hgd96AAGwcpYsbHwiFnVtB6b3MdKeQq3x9gJyCIN9PDyL8Uj9/V8wwjL1SJxDvir6ztt40oJ54gbhRvxl5NDF7ImNi91+PJCLXYvsJ8TTu6YhJh9aY1Wfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrznqTcMopg8v0ZNE7jpYBH6sMyTeXTMdQr1Xqy6Z5g=;
 b=mWXRJdHhnfGrzVx1vckkoNHCkYrWyq8D132rU6updQ6LUMB+ObHgbGH+hxpF1x7q4rkyzzcXkP6qEKEqH70/66MG/HsGlGl05puUPCykxToDrUYqdyDeuIBOpAc+K5Lhn93tonLfCkXjU8qo+cpQqp15GkXYvs3Qcb7bMeZjRD3E66UQvmCXkdxHSd1OjO2pB2RdjFjfYyynn8U0JSId1s50Cs+rTcQMx3y6JKFKEipz3D5q2n21Z48YnFRyJJLoRV+3UcynyRNrnkDQoPbjatjJqZGRtVDwVqdhJGKww6LI5lw0d07pv6jqj/PcIcMDIgivT48fb86Zzp8iO+2Q2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrznqTcMopg8v0ZNE7jpYBH6sMyTeXTMdQr1Xqy6Z5g=;
 b=oxayo66Q6umBgZGcCOvzMv3iptKXMGoVvp5AeNWt34Sz19vWRlAb0gwBa4f5Hz7laiZ9dSosHNAJKKwtpADnqzP8fhmPqa+8mIzMvoT1dwSrjykQ4HQapd+Dk2esDQUY0quCYTNK07Qugxd8xISbvkE+ekdw3xHokNneblbLtb4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2831.namprd12.prod.outlook.com (2603:10b6:805:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Thu, 14 Jan
 2021 21:28:16 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:28:16 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 07/14] KVM: SVM: Append "_enabled" to module-scoped
 SEV/SEV-ES control variables
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-8-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <523d8d1b-4044-2eac-04be-50c3365944e3@amd.com>
Date:   Thu, 14 Jan 2021 15:28:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0021.namprd02.prod.outlook.com
 (2603:10b6:803:2b::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0021.namprd02.prod.outlook.com (2603:10b6:803:2b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 21:28:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01c50033-83e0-47ec-be68-08d8b8d34e2d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2831:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB283128B04E8F586352680783E5A80@SN6PR12MB2831.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A/pYyZq7T0MWYUaH1+kfDcTO82B8G573hEzfc+8tjk+1dWpeiw4zV68ijgfa7hyO997YUu0e2UQqJd/j1s0+PsYTJbnCcgrFnKx90zbsf+y3fw0iAJIQ9G1hFHUsKVUpMeVdtZecF+DLntkN2NBzXroHzIayfPpPqdXbj9HUA3/otmz8ByPHu1gXvLba394fx18eVzaJMgZaQmZStu/9N7aZwC47/6oy+vC7xG074/dQzzuJvfi/v5AOpqpXoBZ7iMIe0TLLpQxwR+43/CxK05XC1PxoYee2hhgvGVwvcYplgiJHKPw0YBzGV+4aafdfCiwamoH3lvd1HOzvkZKhnkMlAPXUAILD3gG6nwItYrKQJkMvzNYq746LO9AnRlAOEMCijbuyMEuvIhfP9nEz2LGtPrts+Qo5QJpHHUGr6U7q2Iz7+J4rLKmxJxicPM0KauOsF0agi3Knrv+xXf6b/smUBmXvk5ZRqGycheS4T7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(6506007)(52116002)(4326008)(86362001)(2616005)(8936002)(26005)(478600001)(53546011)(2906002)(8676002)(31696002)(956004)(66556008)(6512007)(54906003)(16526019)(36756003)(7416002)(5660300002)(83380400001)(316002)(110136005)(186003)(44832011)(31686004)(66946007)(6486002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eitkZVFXbUFvMTE0ZWNaTVNJUTU1VlBkV2ZtaUMvK3VtQzBvVC9iYjFHdkhN?=
 =?utf-8?B?VkZwRjVCcUZqNzNsbEFzRnUwZG9DT2Q4VlBQTTdRQWVGZklEcDZxRzkwQWhP?=
 =?utf-8?B?eGFNT1BHb1lMUkZ3aVN2cGJIb3RwdHppK2s0VndhOUlTdE5CTEMvNlhVRWFu?=
 =?utf-8?B?bGNqNllac3ZxM2NKa3ZsVGpNT2F4RHNSNUozMktBMkZBWXZ0eS9nZ3h4dTZF?=
 =?utf-8?B?ZzI0YmdaRjAvQTlqM0ZtZTBtN3QrYytwaVFMMUlNNlNzeVhaYUFOQXZ6Tngw?=
 =?utf-8?B?cXA0SDd6QWwzQTdRL3dvK0psN2hCNkZUUUxIV2FLVGJKdlFSZ24zeGQ4Qm05?=
 =?utf-8?B?ZFFQUkJCYW9mSTh1cUVTemZpZGV3Wll0N2ZQL3VlbWtWSXB0OXZmZktkQi8x?=
 =?utf-8?B?dEcvMWVOcVgxZjdhdEwzdUZ5VWtwdm4zK1VtS2tudmxXU080TEFQcUlwT3h2?=
 =?utf-8?B?U3M0YmVZRVF3SUlDYWtkektRS3pvN1NHUWNhWjV6d2RIRis1QktXaFZ3T0pN?=
 =?utf-8?B?WTUrdUJFbzNyekwweUVnaVNNRk1KYTdvU215Y2wwaDJNMG90WGNSRERRMkVv?=
 =?utf-8?B?dUM0UkJjeHRieGlvK2t2UnBEZWYyMUpxM2pMdnplNlpmV3grYkZNNG84MlU2?=
 =?utf-8?B?dWlRYk9rWWxnQXB0c2pBU2kyRnFYemxSNzJ4QWxONk1DWWZGdTNuUkZRa1h6?=
 =?utf-8?B?Wkg4OU92aXc1RG1JSGRJNk1tc1pOUW03OU5xN1lYRFNEOGF3WWxmZ3BETGlN?=
 =?utf-8?B?QlpEU25SZGJaMXhYdVlZVXVqOWxTSU5LRjk5VnhYZlhDUm5YQVp2NldyWXBn?=
 =?utf-8?B?NGlrTGV4ZTBiK1hieXVKNmczTUo4b1pnY0YydjQ2ZXBwTWVQWVJkSDVBbzUz?=
 =?utf-8?B?My9CL2x3M1VjbmdDeS9tUjJRYnVyeE5IOThlRElSNC9JbDRYUzFOT0R0OXdv?=
 =?utf-8?B?YjJQdUE1WUdXK043Ym1rTjRKTTFFM2hBajhvOC9TeVRmTklPV2pWeWFQejJI?=
 =?utf-8?B?bEt2NWE0UThaR3FpRFQzaW5nQXloZkJhSFVrWW9GOHUxY1Zkb3FlaTlRcGVD?=
 =?utf-8?B?ZkxKN0x5aWVMUExKUGhVSDdqTmFOeDY2SVpzdkVXamliZ2h3Uml0b0RBeUxE?=
 =?utf-8?B?SDZIN1RDN1hEdG85cWRhakxTc3dtTnBtTWtJRGYvYnkrMWF3WHNNd0YrWlpW?=
 =?utf-8?B?MXhGL2ZVZHZ5bE9BYzJPSncrM3MvMlpjUmZnUnZEd3owL1RycUE0Y3RDTGRm?=
 =?utf-8?B?cnFIRC9KOUpUQ2JyYmhveit1Vml3SnN5UGdwQVdYOXhKNThqRkNJNnJwVlZC?=
 =?utf-8?Q?QPg2K372Xj1ML61oruMZHa7QG51uXC9xa0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:28:16.1536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c50033-83e0-47ec-be68-08d8b8d34e2d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzlHU+GjEqFtlbqb0tFM8BxC6rQ3Pth/kONGYtxFYd5wgGGJIVNNHEtMGxooCLsckTCaYztmSnYkHPp5IsTGew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2831
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Rename sev and sev_es to sev_enabled and sev_es_enabled respectively to
> better align with other KVM terminology, and to avoid pseudo-shadowing
> when the variables are moved to sev.c in a future patch ('sev' is often
> used for local struct kvm_sev_info pointers.
>
> No functional change intended.
>
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8ba93b8fa435..a024edabaca5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -28,12 +28,12 @@
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
>  /* enable/disable SEV support */
> -static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev, int, 0444);
> +static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param_named(sev, sev_enabled, bool, 0444);
>  
>  /* enable/disable SEV-ES support */
> -static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev_es, int, 0444);
> +static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  
>  static u8 sev_enc_bit;
>  static int sev_flush_asids(void);
> @@ -213,7 +213,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	if (!sev_es)
> +	if (!sev_es_enabled)
>  		return -ENOTTY;
>  
>  	to_kvm_svm(kvm)->sev_info.es_active = true;
> @@ -1052,7 +1052,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	struct kvm_sev_cmd sev_cmd;
>  	int r;
>  
> -	if (!svm_sev_enabled() || !sev)
> +	if (!svm_sev_enabled() || !sev_enabled)
>  		return -ENOTTY;
>  
>  	if (!argp)
> @@ -1257,7 +1257,7 @@ void __init sev_hardware_setup(void)
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> -	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
> +	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
>  		goto out;
>  
>  	/* Does the CPU support SEV? */
> @@ -1294,7 +1294,7 @@ void __init sev_hardware_setup(void)
>  	sev_supported = true;
>  
>  	/* SEV-ES support requested? */
> -	if (!sev_es)
> +	if (!sev_es_enabled)
>  		goto out;
>  
>  	/* Does the CPU support SEV-ES? */
> @@ -1309,8 +1309,8 @@ void __init sev_hardware_setup(void)
>  	sev_es_supported = true;
>  
>  out:
> -	sev = sev_supported;
> -	sev_es = sev_es_supported;
> +	sev_enabled = sev_supported;
> +	sev_es_enabled = sev_es_supported;
>  }
>  
>  void sev_hardware_teardown(void)
