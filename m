Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6CF642E72
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 18:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiLEROy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 12:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLEROx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 12:14:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066371B1E5;
        Mon,  5 Dec 2022 09:14:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtPNUjTRCYO+PrSMXLuxXhFqhfvyihpC5dOTSsJBbtXjYT38jTDsJv8kkzp6sShGaDBAtpv5fbTDzAgNvzOi/9ZD+Hg3zCCFX3WE9UrJ7yZmGmSEZqk9VXdV9rGtxKQRseLv7SL1wQNVU1bBg9z1g4QN0ujj4o2fwdgQ4kpol4hghn+NKWKE3hw/bYLZkD02P6b9/r/sElTh3n7fYoOQ1wAxxfnoGT2DrWxMEjdtrrwGmC2JX5n134Gwf4fFfYtRbObQP1TDP6HwriM6oq2ZrtTI96s7uF9+aDKAedm7meopDXv/8TMck74yqH2n2lbvBJ1yw44Wk9slMfawulJa8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5n7gHOJ8KPuYfNrpgnehlOMfEvrI6xGQ758EhfGjG6E=;
 b=A5dGf640T3sTWKJREs9dsRL4bUBWfq9vwFvh4d4BXWReL44/nZZqQw8Oyl27dCGem8DlWJsJEDJnwObdvYLGXcbarjG5hLyPpFQJLp0ZCvozmtq6R45JksP4DIgMVrZ3/jbuFyan+b2qOZDE4WArclphFf0qP/E04/UCP9SacVzuvSP2W89BTgnN6xoH/4YNPg9oyfZbitFbYq8UZr9woS8f5RKdbBfGoO3ky92z4Ql0nZhm69NMfTFrRG3LlIWUTXPRL2MsvjIEaUqY5XaD3ff0TuIhS/TF0hWNZT0dJP3KTbvv29EnukuMNyOX8BMP39Mi2XD/6NBb7WZj3sfsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5n7gHOJ8KPuYfNrpgnehlOMfEvrI6xGQ758EhfGjG6E=;
 b=Nsjt3tcI2b41DaR7dvaEvZuzCJDnsvxZnYFZGbBLZbjtD9eWA97uUm9hKom8tqUtnMbuj8bu4npxgH5SjuyjU7pBaqQA78rVnaWttUfyvUen03YozNf8YMteswQbNrVLohMDBpvwqG+Zwvz5CzZKoEmoQ6tSS562xRCi2QR9NQE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM6PR12MB4925.namprd12.prod.outlook.com (2603:10b6:5:1b7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 17:14:50 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 17:14:50 +0000
Message-ID: <7efc45d1-4799-972b-cad7-482bb1662fa5@amd.com>
Date:   Mon, 5 Dec 2022 22:44:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 11/11] KVM: nSVM: implement support for nested VNMI
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Santosh Shukla <santosh.shukla@amd.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-12-mlevitsk@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20221129193717.513824-12-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0120.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::15) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|DM6PR12MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d957fd-4e60-44d7-270b-08dad6e4373f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LM/Je9XFg59K+4ol+GMO4Qet4zxQ2NNx83WvSwMBzmHpAIjDsI2ZeNElZKDq5ZlkxfY+Zsx46VRp1rHZTbkMsyGAupFSpW4PeXLBtK3LtfeGC5MHVlHf4RGdS5aL8Sxvu/7Y0+hD2jU9hma6hcrSWF6/pSN85GfBU9MRte48uPQX/ra6/34thWrj7ybRLjes9dsduVMcbE+cvhDQcZEtChbyHS+aBgQaSzpBA8NLVgdBn030cdWmfIKtQLR19j3zoiFzKyb+9xbXpKLdg4Wag5/RuJU6l2WSghm65/v8lVutiguFnR0aa3WXXDkd8rRgGuuNx+G1h/PvqSGJW6R+5aHjmFY1IoUbIsOdxCxYJmfXyRVpAz6M8OOKS9Fh3p6P0WsuZReFqAVdBKohwty6PCIJn6jqY6mTYlwpyOGYME1/OOvuSqRD50cvY3l4CwDi+lrQuLn5tzPqnzA1Rfc7jNpDFPwOOAsiNHKS1G/M6cGNLBgTfgY4VABtF8kYd1ElkuRMnY6EbzxwOQfYXbau+OfFgrTHxg+YlEyccnQit2lz7ez2u8TIK2CFrgiCuU4zn5TKShfJ1Q91KxjUN0vHAqBkDs71+UYvF2vKNykdRT4kWzngmVLVWuQV9rTAwlibsDHjGsNRrthex5UgMZJLnR1cYAytjH4RH09pXfHq9/4lEPwYLGzTv0H5UrXJQKSGJynCOYOKMHXabs/cGKPI3F7vM/ww6VB7+4RnWjUsCSI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199015)(83380400001)(86362001)(31696002)(38100700002)(7416002)(5660300002)(44832011)(41300700001)(8936002)(2906002)(4326008)(8676002)(186003)(26005)(6506007)(6512007)(53546011)(6666004)(54906003)(316002)(2616005)(66946007)(66476007)(66556008)(478600001)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2hTNGp5MkJvdXhKcTRiancwMUMyejNrSVlVUXFMTW9sSnpFS21OVDNvMDhS?=
 =?utf-8?B?ckdXWGo2ZVdmWVJmbWpObURPWVE3WWZOcEFIdWQ0RmxMdXhualhuUmZNTTdv?=
 =?utf-8?B?bUNpSEhMZWlBVlJRVWE2c0FhSXM3ZlNoOTNTdis4WDlFTEc0cVdyNS9JQlFR?=
 =?utf-8?B?NkFhaXZZa01FOEFtaUJIaGxEWWhTSmVhZG9tWWExdjZzUlVTdmUxR0ZVN1A2?=
 =?utf-8?B?NTFGckJCRDlJOFE5YytqdVNpcmYxNXFhdGtIU0VxbnEzY01lb1VBTXo1SkF2?=
 =?utf-8?B?N1FMaGpwTjJUM0wxRFlwNE84bzlSc2hrZ1ZhODZ1bDhaRExSTy8wMkxpTnVW?=
 =?utf-8?B?NjkrSEhWcmpvd3BuZkRGQWlhWitYNXZLb01lZ29td1JjQjNRazJiZytYWWlO?=
 =?utf-8?B?ZXNyR2dJNUk1QUNVNTByTC9uNWMzMGlnSVVqOW04dHNzZ24vbUpIdVlqVUtD?=
 =?utf-8?B?S05pWktEMWRKcmFyK2ZiZ1FtVUl6M21HMmx3QWRpQVNQcnBBVXpTcEFkVnZ6?=
 =?utf-8?B?ck9FRjkyQ1JnblVpWmFIc2IvYVJLWStuazlJWi8vV3BnZ1RKVXI3N0NzTVFB?=
 =?utf-8?B?ZmZOT2VUckRoOER0TUVFWklkSkZ4SStUK25Cb3IxaFZTWnVPSHlWSmI1VEFq?=
 =?utf-8?B?L0R4V3FhUno4Zzd5NzdnazhLRGlMbk9CVzUzeHBzMnpZR3Jva2NLTkRxc3Fp?=
 =?utf-8?B?Q1RlbmNENU5YU2YwR1IyNW5ydlUwbVhMb0dyQTNkYlg3VDNrYVVQVHR3OW41?=
 =?utf-8?B?ZERzOVZwSGExRThsL2hyOExWL1o2UGZWS2ZocktNeWdvSFczRmEzZUN6NEdF?=
 =?utf-8?B?TXhpM2Z6Q3hYVzlwMjRNSkdrdnZrQzhaZmc4VUJxUHdhU3FFMFl4dThnVEpP?=
 =?utf-8?B?MUxYbVBJc1dSclB2NU1nU0NQT2Z4dlBydVJZWmZMUlRsQU1VZ1NhT3NkYmlh?=
 =?utf-8?B?ckhFWmVNYldkOW1lblEraWw1Q24zRUlnOW56emFjTnBlZUFXMmN0RkdNOThk?=
 =?utf-8?B?R3JhMWJjRlBrWTVUd3FWSVV0RWhUaUlzWlU5cTVOdWd2SlpFZnJKQzg1eUtR?=
 =?utf-8?B?SXI2eFJzU1d6L0lIV1dCZ0orcmNRQmlnMGhZYTRwYkFqY0xvRi9UVUJHbDUv?=
 =?utf-8?B?Zys1MUQ2OXFKMGNCS3cxcFlNandaYjlWZmRBWDhwMEhhMmlUQ1NTUE1qdU5i?=
 =?utf-8?B?eFQ5K3pYcWp1WEU4RlRNN2JuRDhxVHp5dlQ5TDE2ZFFKSkRDNElnd2hrMnJ2?=
 =?utf-8?B?ZThQRDNSL0Z1SjhGT0FjajdCQVNVWnFkWFlhU244YzZuRm1Ob2V6RHFYeVR0?=
 =?utf-8?B?VDZSUWVtSHlSTFNvd241WG0wUjRYSGNOUW1mSmJYMnNYZHpxK0hTNU5LSDlK?=
 =?utf-8?B?QWlkdUFxL3dSNzdlTkpYTy9ML0RPbzBUZEtqZjlKb3dCOTVzU2lBR203VUgy?=
 =?utf-8?B?dUtrNkVDNTZRcGNZVUhXMUhUY01VMkoxNzlpUWxhdFd2aW1zN1VKQzZXSnhi?=
 =?utf-8?B?K0NlRTd1YWgvRTVjYzcyOHkwcU94dnR3Z2pLSGx0SU55Q1ZyWjM4RWxqSitX?=
 =?utf-8?B?WVhRQWxTdUtkY3FybU9zTHRzTFNWaEVUZ2xoMVgzSDFkcEJ5SEZJYWFYd2pw?=
 =?utf-8?B?a1NnRDMzQW1obmFuNEhML2xHSk92NDlLMjFiWktzMnJodjlZbDZxeG9sRGhD?=
 =?utf-8?B?K1RkeFVML3VYSzZZR0wvQ3ZUZGczbVM4bnBCdktWTzFkaFdkSFg3T2pUclBp?=
 =?utf-8?B?Q0hYalYwTlVaaDdwdkgvVlFTYy8vT2lpaDl3cVBPcHArQ1MyMGJhQWRxMHdq?=
 =?utf-8?B?a1BtODVYaE1HRkxOS1RlZ3B6OU43SDd4ZzNEQThMd3FtUXNQekl0NXMrWTNJ?=
 =?utf-8?B?NkhaMWRCZDU1U01TSnNuM1NDODhOdDV1OE14THVrclMwVnZjcmlIdHlPYWp0?=
 =?utf-8?B?enUzanpFRjRlS05yc0U3Z215THZucjVFN3o2cFkrN0lpaUpNZDU0VnFlb0Rw?=
 =?utf-8?B?NTlOV292ZkhWcVEwT05IS1d5OHF2TTFOSlFYclNJUzRlWnRWNE9BMHhjK0tu?=
 =?utf-8?B?OEY3MVlla01MMitOcnJvM3ZjK1pIajZYcUpiY05vWXR1cCsxNWR4L1FTZWc1?=
 =?utf-8?Q?o0CmSlfeoubG+sED1LUl6SzsC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d957fd-4e60-44d7-270b-08dad6e4373f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:14:50.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZPQjTweGJ7Uf4Xq+xILCwvwGFGHWZXT0k6sQSdbUzeMocnKnlqyCSpGY74Nst+2bqJckAN4aasnMFNSQsZ5V7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4925
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/2022 1:07 AM, Maxim Levitsky wrote:
> This patch allows L1 to use vNMI to accelerate its injection
> of NMIs to L2 by passing through vNMI int_ctl bits from vmcb12
> to/from vmcb02.
> 
> While L2 runs, L1's vNMI is inhibited, and L1's NMIs are injected
> normally.
> 
> In order to support nested VNMI requires saving and restoring the VNMI
> bits during nested entry and exit.
> In case of L1 and L2 both using VNMI- Copy VNMI bits from vmcb12 to
> vmcb02 during entry and vice-versa during exit.
> And in case of L1 uses VNMI and L2 doesn't- Copy VNMI bits from vmcb01 to
> vmcb02 during entry and vice-versa during exit.
> 
> Tested with the KVM-unit-test and Nested Guest scenario.
> 
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 13 ++++++++++++-
>  arch/x86/kvm/svm/svm.c    |  5 +++++
>  arch/x86/kvm/svm/svm.h    |  6 ++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5bea672bf8b12d..81346665058e26 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -278,6 +278,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
>  		return false;
>  
> +	if (CC((control->int_ctl & V_NMI_ENABLE) &&
> +		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {
> +		return false;
> +	}
> +
>  	return true;
>  }
>  
> @@ -427,6 +432,9 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
>  	if (nested_vgif_enabled(svm))
>  		mask |= V_GIF_MASK;
>  
> +	if (nested_vnmi_enabled(svm))
> +		mask |= V_NMI_MASK | V_NMI_PENDING;
> +
>  	svm->nested.ctl.int_ctl        &= ~mask;
>  	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
>  }
> @@ -682,8 +690,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	else
>  		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>  
> -	if (vnmi)
> +	if (vnmi) {

To avoid above change, I think we should move nested bits from 10/11 to this i.e.. move function
(nested_svm_save_vnmi and nested_svm_restore_vnmi) to this patch.

make sense?

Thanks,
Santosh

>  		nested_svm_save_vnmi(svm);
> +		if (nested_vnmi_enabled(svm))
> +			int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
> +	}
>  
>  	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>  	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index bf10adcf3170a8..fb203f536d2f9b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4214,6 +4214,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
>  
> +	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_AMD_VNMI);
> +
>  	svm_recalc_instruction_intercepts(vcpu, svm);
>  
>  	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
> @@ -4967,6 +4969,9 @@ static __init void svm_set_cpu_caps(void)
>  		if (vgif)
>  			kvm_cpu_cap_set(X86_FEATURE_VGIF);
>  
> +		if (vnmi)
> +			kvm_cpu_cap_set(X86_FEATURE_AMD_VNMI);
> +
>  		/* Nested VM can receive #VMEXIT instead of triggering #GP */
>  		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>  	}
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0b7e1790fadde1..8fb2085188c5ac 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -271,6 +271,7 @@ struct vcpu_svm {
>  	bool pause_filter_enabled         : 1;
>  	bool pause_threshold_enabled      : 1;
>  	bool vgif_enabled                 : 1;
> +	bool vnmi_enabled                 : 1;
>  
>  	u32 ldr_reg;
>  	u32 dfr_reg;
> @@ -545,6 +546,11 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>  }
>  
> +static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +	return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
> +}
> +
>  static inline bool is_x2apic_msrpm_offset(u32 offset)
>  {
>  	/* 4 msrs per u8, and 4 u8 in u32 */

