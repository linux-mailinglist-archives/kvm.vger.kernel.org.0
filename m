Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD56A642E5A
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 18:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiLERHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 12:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiLERH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 12:07:29 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF21D1AD8B;
        Mon,  5 Dec 2022 09:07:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPAczKUGre3w5G3z680QY3m7C0mesTjfgMdAy1PoWmqV4fBKK2k/rjPN9sa2/9RAf+mbxhHZI/KkUwPTWKQxgxQcWpnpNYTdzv9/D4MWKpEjMNWcgI5JXoRHlrBFt04wHNR57zaH7k7E1s3MF6G3DQ6y4EBtoq13I6Xqwblrh8/gi6pIxpWoNDduXs0iBYglqFXO7kKzyWTmUilumGL1euleO+zHQw2EgR9wJvSQ3SjamYLiTDFVmRhmvRAgUy785t/UNwIJHTZf4NtjeI+HV5bz31ULZpCRg0EhY/Qm7SzlxCewBc/ROBzDF4Ck7cg94LF/L3onGk7p0K93SQ7CDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fr+e4azkQoQDVxhFieyBx8Tp5dJq6KC7OGV8isSRlWs=;
 b=nP68PR6LsjLlvDrZf26/Oq4Q8gyB7uqwqa9/mVLcZDJferSY0cbbOucA/1H/rlawPbAlgD7Apyghu5mizcwy+muwDsFs0pxdb7DLsWa0lx82RC0CEmnlXPSLMBHn6ik7DKZfouhFGXrSswbGXj1BtN85wtG40AfwASlZCx4XGQYRlglHJh3jGHnhoUETld5HhVxM0Iid/IPnSfYnTRN1csIaRVcVyx403CtjKtyDQKayr8vGoRJlucel0jicQhSTboJJQ26AZ0qqnXZlB6gHTRsuv4gmHdKKYlJHP50yfXOmFogMADpHaJmIs1M08IsVqRtCOx3K98dQEt6yQVGnyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fr+e4azkQoQDVxhFieyBx8Tp5dJq6KC7OGV8isSRlWs=;
 b=aKykuCClXv3U88YJfo6kpH5jYVVtdxBvsUXXc2o/iYQPz7nn3OPQQzHl9OagvAvmyOEKBexz5uH/3W94NtbyTh3nU4YWuW5zRRUEvXxrmJSgUsDodqYCEGPeClKBEjXDpfuGQOpAFmVKDmX9EKWZjKc7uUgbKo3OS6IrLmzAagg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH2PR12MB4924.namprd12.prod.outlook.com (2603:10b6:610:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 17:07:23 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 17:07:23 +0000
Message-ID: <263e95bc-7b81-f30a-f809-d97573dea251@amd.com>
Date:   Mon, 5 Dec 2022 22:37:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 10/11] KVM: SVM: implement support for vNMI
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
 <20221129193717.513824-11-mlevitsk@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20221129193717.513824-11-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0041.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::23) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|CH2PR12MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed64230-a4e4-4898-73eb-08dad6e32cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rq1duO1Uc8Norzcc5No/Dx4Ymo/nQp+lYaWjUlFyA24lYiDrUAvpiS7Bmpbs/T13nPMIzNHzo+Gp3q5+L+ue4Ym507bryCidwt8kEPkgp4NNDFMRlBqh2FMkE8TIiQj+90jBiNpYIR0Q62Y4PDZWub7x/Bk7Z8VcWZGoqRqb22VBiKFF6flthaS4pO2/wzIHg6YNBbE1aBmwmWonxEtqBwM6cg8sXBqFnrd34nCmBkY1LxonylvgeC8/3G/gOuThTGlUv0fK9B2/m+3lSOcRiwA8b0p1ACx7Xdt+Cl6O7o/YKCA6/az7FvRCXnd4GGfDDmF6tVmBHtlPdaC3k5FjFypGr2QM77v++5Ntjb75W0t3t7tqjvHcH3sXYFgKop3enWWmPFEKMaWWHQjx4MIsLm/AbiZmnrzbHUzNa+iTfRTSWC7sVF1YM2GxA+OdOpg9nFHv8Hyx13Mw3HfvZrYJML3Xw4bBZ/IgLSx4ODNxUnrS3CfmYB3pnlCyHtEDMmiqyJh26uwk/2bYui5qvT0dcGuNJ3VNXI9NEhwAZfoCyZ/DeVEKdQjfvkO0ZZeOky8YmzCnFRz3eNSHWRhJ1B1QM8yjObzzb9rGaG+8XCOqidUnowb4UGpDtTd+GjtBpUKVlr4niCRTisbnR7Xb6ZIZ4NtL1i++5SXz8+HCYIBXcCXyTYIk31k0HqtQISi7HrgMQM6gcHvq4IB2pcYHiMuVDhHtWqTEvQ4HiLLgy2ciiWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199015)(31696002)(86362001)(66556008)(36756003)(186003)(41300700001)(66946007)(8676002)(4326008)(2616005)(66476007)(8936002)(5660300002)(44832011)(7416002)(53546011)(54906003)(6506007)(6486002)(478600001)(6666004)(316002)(26005)(6512007)(38100700002)(83380400001)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wi9vQk9rRWt0SGYzbmw2YVZPemNvTEhhQVA3MTdobjlNbGd2L1docWdqSFZM?=
 =?utf-8?B?NXFYOCsySjNHak12QXJ5cGlyamNLZmhrcmtnZHhhN01LZ20vaUFqVVZESVF2?=
 =?utf-8?B?djFFa1NWQ1NQYTduM1l0aElLMnhMdUJzeFIxL3ZVUSt1Kyt6cEY2OG5GdmlI?=
 =?utf-8?B?L2x6NW45cC8vbDl6V1MxVXNKMlBIcytZbWRRNi9MQy9oT0cwWFhLY0dsMnp5?=
 =?utf-8?B?aDFkM3RVS3NrQmxQc1EzbGo1eDZ4RTkrdTVpdFVXZ0hKbjRSbi9lZVovYTVx?=
 =?utf-8?B?cit2eUpBYnFScFVKWlZsazVtSDNnYjJlV3lBTTAvRVJiQktWODI2WnVVRlpC?=
 =?utf-8?B?dEZNMXhqbEMyS3A3eEEyQnh6M3ovbDFPOGdCTHJDM2dLMmQ1QUl1Y3pXbU9s?=
 =?utf-8?B?WEVRMWlsbzl1MjhlRHd0RUtkNFdYaGxGeU9oZjlHRTM2c0FKaUVMZER6UmpB?=
 =?utf-8?B?M0RWSjdlU1p1d1p6SmdWWlZNaHBrWFlDSU14c1ZaMmt6d0lkWUNYV1Nxdnha?=
 =?utf-8?B?dGlXOFlRZ25XWTg1Uk93RExJZUpXQTZOQ2h5UC9ZUmh1SlVLbEFGTmFhNG9T?=
 =?utf-8?B?dkZBdkk3OXNTcnJGMGVVRFdXNWVjY1RjVFZJWGlOQ0p2bjF6T0RlaGVRZWVI?=
 =?utf-8?B?VzhWclMxR0xBS05yS0pzUU9EL1ExTmtrTkg4RVZPNndKNHJIb2Q5aDNEU244?=
 =?utf-8?B?ZFF2R1daRmFFNnkzVkJteVo0a1N0ZXZuN213bEcyREo4cENkOGhzbXl1ODlk?=
 =?utf-8?B?cFo5Y3l1Y0ZyczJITDRFYkkrWkE4dnhCZVl1V1lya2t4STY3TkdqU1hSWGRi?=
 =?utf-8?B?ZEVHcFczQXIvZ1RwRDc1dGpxRjZJRE9tTWQ0WldMUE5tVUpybE9SMmRWaU42?=
 =?utf-8?B?MzRvVHpHWDBpZ2dQTlBBbnJyajBSbFdDblA2SGpXSGNsaXM5czloWVA5TGE5?=
 =?utf-8?B?TG8rV1pPV2tBNUx4UXNhZjg1RXVwOEZVMFd3YmhuZXBxb2d4Ym9EZzJBTm5z?=
 =?utf-8?B?cFppMnl2eXl6K1NXZUNmZEZkMmd5VkxXWkpGYVNibGpLL1MwamlvQmRZRHdD?=
 =?utf-8?B?TDVUeXE3K1lQdTZWNjZNTzFBZ1hKZ3lMbjZXT3dScjgwYXZ1R2pieUZ2S3Ry?=
 =?utf-8?B?Q2F3dGFWQzdQQmpBYzhCY3NLRWJHUDFycm5lUWZxdVBuSXUyWmRJd3hpSktD?=
 =?utf-8?B?aDd4VW0xZER0U25EKzN0Mjc5Sjh2WnROUDJRWFROWWcyVy9iSGt3ZlRxeWY5?=
 =?utf-8?B?UmpkZGFhNklSbnhTTlBGSGRRcFAwTEZVVGh4bnBNSSswcng3MFdvS1dIaXBS?=
 =?utf-8?B?Tlpzcno3dE9lR2o4RGxtRE56MWFOd3ZQL21zY2Y1NEpnTWJJb0xoTnpGVXM1?=
 =?utf-8?B?NTRFVFJrRTFBOGFDZitQam43S0IvUU1NYU9IT1lUTzM3S2xiNENYQ0JpcHFL?=
 =?utf-8?B?aDFDcjlZTG1QYzZqQ1N5citYcitKMFpxcDZYRGovaTlreUgrNVMxTWx3WVFx?=
 =?utf-8?B?akowNFZqeUJ3aktVN2c3YnV6am5mTllUVGptb29NR3ZJZzdqOFdnZDNlNzVX?=
 =?utf-8?B?OGdDSHBQTGFrODQwaTJqRXBQUUlPMEFGYk1BNk1MU21FOThRUlZPMFJ4dlVG?=
 =?utf-8?B?MDM4UkhpZDJNNGVTSVQ5a294alUyL2tQM1BGaXZoY0luZlI2allrRGxpazhM?=
 =?utf-8?B?Ty9tMS9XZW83OVJFbk5SSWhBMGEzaTJtTk1uazhmejVqdG1wZkNKZll2RDM3?=
 =?utf-8?B?RHFYTnFvMDNlOHh4blRDQnFuSC9jMTQ0cUloQnR5Z1hRZ3BEeWxmbDRQQytM?=
 =?utf-8?B?VlpTMDN4clZHQWRWK2hvRjNnM0Q0cG5POVUyT0VueDNpc0ZUQTk5cVgzM3Bv?=
 =?utf-8?B?Kzg0bWRFZlpCS3owbTBtKyttQTlCeTZiRnlhcVcwYlU4TDdLaE9QajRhZU9X?=
 =?utf-8?B?MVNiOUgrRUdaZ200UERyVXBXNXJJeU1HVFJIeHQ4cWJTOVdPVUNNNjZKRXVy?=
 =?utf-8?B?ZE10OEoybHB2YmxSbWNwbjh2UUdvTlBtUFZXTFBZZmlSK3ZDT0lENG5XYnAz?=
 =?utf-8?B?bC9wV0VEemV2aSs1YXg5VUM0MVB3b3o2Y1lBMUZlS3ZKbllyL1FVODZpVGJG?=
 =?utf-8?Q?wASZvdCZyXNuCtA20zSdL+nx1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed64230-a4e4-4898-73eb-08dad6e32cef
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:07:23.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: It/AWKKbXXrN1/JgmYqX8FS+UYe70CDGU01CFbjEaxvXcpOeVC/FOTtdT6hALhJhbwecCVrApCdc4oU7DTvPXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4924
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
> This patch implements support for injecting pending
> NMIs via the .kvm_x86_set_hw_nmi_pending using new AMD's vNMI
> feature.
> 
> Note that the vNMI can't cause a VM exit, which is needed
> when a nested guest intercepts NMIs.
> 
> Therefore to avoid breaking nesting, the vNMI is inhibited while
> a nested guest is running and instead, the legacy NMI window
> detection and delivery method is used.
> 
> While it is possible to passthrough the vNMI if a nested guest
> doesn't intercept NMIs, such usage is very uncommon, and it's
> not worth to optimize for.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c |  42 +++++++++++++++
>  arch/x86/kvm/svm/svm.c    | 111 ++++++++++++++++++++++++++++++--------
>  arch/x86/kvm/svm/svm.h    |  10 ++++
>  3 files changed, 140 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e891318595113e..5bea672bf8b12d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -623,6 +623,42 @@ static bool is_evtinj_nmi(u32 evtinj)
>  	return type == SVM_EVTINJ_TYPE_NMI;
>  }
>  
> +static void nested_svm_save_vnmi(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
> +
> +	/*
> +	 * Copy the vNMI state back to software NMI tracking state
> +	 * for the duration of the nested run
> +	 */
> +
nits - Extra line.

> +	svm->nmi_masked = vmcb01->control.int_ctl & V_NMI_MASK;
> +	svm->vcpu.arch.nmi_pending += vmcb01->control.int_ctl & V_NMI_PENDING;
> +}
> +
> +static void nested_svm_restore_vnmi(struct vcpu_svm *svm)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
> +
> +	/*
> +	 * Restore the vNMI state from the software NMI tracking state
> +	 * after a nested run
> +	 */
> +
Ditto...

Thanks,
Santosh
> +	if (svm->nmi_masked)
> +		vmcb01->control.int_ctl |= V_NMI_MASK;
> +	else
> +		vmcb01->control.int_ctl &= ~V_NMI_MASK;
> +
> +	if (vcpu->arch.nmi_pending) {
> +		vcpu->arch.nmi_pending--;
> +		vmcb01->control.int_ctl |= V_NMI_PENDING;
> +	} else
> +		vmcb01->control.int_ctl &= ~V_NMI_PENDING;
> +}
> +
> +
>  static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  					  unsigned long vmcb12_rip,
>  					  unsigned long vmcb12_csbase)
> @@ -646,6 +682,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	else
>  		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>  
> +	if (vnmi)
> +		nested_svm_save_vnmi(svm);
> +
>  	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>  	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
> @@ -1049,6 +1088,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  		svm_update_lbrv(vcpu);
>  	}
>  
> +	if (vnmi)
> +		nested_svm_restore_vnmi(svm);
> +
>  	/*
>  	 * On vmexit the  GIF is set to false and
>  	 * no event can be injected in L1.
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cfed6ab29c839a..bf10adcf3170a8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -230,6 +230,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  bool intercept_smi = true;
>  module_param(intercept_smi, bool, 0444);
>  
> +bool vnmi = true;
> +module_param(vnmi, bool, 0444);
>  
>  static bool svm_gp_erratum_intercept = true;
>  
> @@ -1299,6 +1301,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_init_vmcb(svm, vmcb);
>  
> +	if (vnmi)
> +		svm->vmcb->control.int_ctl |= V_NMI_ENABLE;
> +
>  	if (vgif) {
>  		svm_clr_intercept(svm, INTERCEPT_STGI);
>  		svm_clr_intercept(svm, INTERCEPT_CLGI);
> @@ -3487,6 +3492,39 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  	++vcpu->stat.nmi_injections;
>  }
>  
> +
> +static bool svm_get_hw_nmi_pending(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!is_vnmi_enabled(svm))
> +		return false;
> +
> +	return !!(svm->vmcb->control.int_ctl & V_NMI_MASK);
> +}
> +
> +static bool svm_set_hw_nmi_pending(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!is_vnmi_enabled(svm))
> +		return false;
> +
> +	if (svm->vmcb->control.int_ctl & V_NMI_PENDING)
> +		return false;
> +
> +	svm->vmcb->control.int_ctl |= V_NMI_PENDING;
> +	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> +
> +	/*
> +	 * NMI isn't yet technically injected but
> +	 * this rough estimation should be good enough
> +	 */
> +	++vcpu->stat.nmi_injections;
> +
> +	return true;
> +}
> +
>  static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3582,11 +3620,38 @@ static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>  		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
>  }
>  
> +static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (is_vnmi_enabled(svm))
> +		return svm->vmcb->control.int_ctl & V_NMI_MASK;
> +	else
> +		return svm->nmi_masked;
> +}
> +
> +static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (is_vnmi_enabled(svm)) {
> +		if (masked)
> +			svm->vmcb->control.int_ctl |= V_NMI_MASK;
> +		else
> +			svm->vmcb->control.int_ctl &= ~V_NMI_MASK;
> +	} else {
> +		svm->nmi_masked = masked;
> +		if (masked)
> +			svm_enable_iret_interception(svm);
> +		else
> +			svm_disable_iret_interception(svm);
> +	}
> +}
> +
>  bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct vmcb *vmcb = svm->vmcb;
> -	bool ret;
>  
>  	if (!gif_set(svm))
>  		return true;
> @@ -3594,10 +3659,10 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>  	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
>  		return false;
>  
> -	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
> -	      (svm->nmi_masked);
> +	if (svm_get_nmi_mask(vcpu))
> +		return true;
>  
> -	return ret;
> +	return vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK;
>  }
>  
>  static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> @@ -3615,24 +3680,6 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  	return 1;
>  }
>  
> -static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> -{
> -	return to_svm(vcpu)->nmi_masked;
> -}
> -
> -static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
> -	if (masked) {
> -		svm->nmi_masked = true;
> -		svm_enable_iret_interception(svm);
> -	} else {
> -		svm->nmi_masked = false;
> -		svm_disable_iret_interception(svm);
> -	}
> -}
> -
>  bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3725,10 +3772,16 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	/*
>  	 * Something prevents NMI from been injected. Single step over possible
>  	 * problem (IRET or exception injection or interrupt shadow)
> +	 *
> +	 * With vNMI we should never need an NMI window
> +	 * (we can always inject vNMI either by setting VNMI_PENDING or by EVENTINJ)
>  	 */
> +	if (WARN_ON_ONCE(is_vnmi_enabled(svm)))
> +		return;
> +
>  	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
> -	svm->nmi_singlestep = true;
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> +	svm->nmi_singlestep = true;
>  }
>  
>  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> @@ -4770,6 +4823,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.patch_hypercall = svm_patch_hypercall,
>  	.inject_irq = svm_inject_irq,
>  	.inject_nmi = svm_inject_nmi,
> +	.get_hw_nmi_pending = svm_get_hw_nmi_pending,
> +	.set_hw_nmi_pending = svm_set_hw_nmi_pending,
>  	.inject_exception = svm_inject_exception,
>  	.cancel_injection = svm_cancel_injection,
>  	.interrupt_allowed = svm_interrupt_allowed,
> @@ -5058,6 +5113,16 @@ static __init int svm_hardware_setup(void)
>  			pr_info("Virtual GIF supported\n");
>  	}
>  
> +
> +	vnmi = vgif && vnmi && boot_cpu_has(X86_FEATURE_AMD_VNMI);
> +	if (vnmi)
> +		pr_info("Virtual NMI enabled\n");
> +
> +	if (!vnmi) {
> +		svm_x86_ops.get_hw_nmi_pending = NULL;
> +		svm_x86_ops.set_hw_nmi_pending = NULL;
> +	}
> +
>  	if (lbrv) {
>  		if (!boot_cpu_has(X86_FEATURE_LBRV))
>  			lbrv = false;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 587ddc150f9f34..0b7e1790fadde1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
>  extern int vgif;
>  extern bool intercept_smi;
> +extern bool vnmi;
>  
>  enum avic_modes {
>  	AVIC_MODE_NONE = 0,
> @@ -553,6 +554,15 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
>  	       (msr < (APIC_BASE_MSR + 0x100));
>  }
>  
> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +	/* L1's vNMI is inhibited while nested guest is running */
> +	if (is_guest_mode(&svm->vcpu))
> +		return false;
> +
> +	return !!(svm->vmcb01.ptr->control.int_ctl & V_NMI_ENABLE);
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
>  

