Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64979642BD9
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiLEPcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiLEPcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:32:21 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE471EC55;
        Mon,  5 Dec 2022 07:31:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2zNliMnU1trs+9LEDYgTeeNfAshibU7FM8J6F4ceTwjwM8SoTt23sAAK8VNtM2bHxGvldnzRg9WPi00rbkkXCLUoXcx1HK17fSoDt8aAxkpcS7oZrYc/asmLezMYGPQBjThDKcu8l9A12pcezsg8eafyrKsIET1oxc2uqkUL/xlfUFH6uUCby/IPdei2262vg2onidddkx0TLMmm5JycFRY+r+pc+HEvUo72IoIN8GeALw2GpWK35aOT6+iZVUAyLcMJ9564ZXbtCt27Eu6td6r8d4rT7+X+CuiridVbFoX/V89v7/v7DILL777HyrHsMmc6MDcJUsWNTkGOsZH6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ2aQgwwUStHeh8cV4C6Ene1J4lL3kgzI+RemfRjbeQ=;
 b=ingkTWp6vn1ZKHx12gXvUlTR1QsSGMnd1gtz4LuEpZqx0lQf+Ww6SbCSXuf/9VXUNQXw5S7E+kl+FFC8AldNLXTc+nyYDrzGSA1kE0NB02ICcvQpwjOtayt4hHa+9qCqDTiCHpVR93SVeDwJu97H5rb90HvmU+NQxDAqg9dbBCe/0/n5GhVbI7E/84qgwNoQtArY9Mxj9KFrQj5GTZXg7HM1K3uJYSOwVdiiuUGF9XwCh1fTAKqQ6/UCOJfM56FgvNqPMriSittSQAF+Hpef6P3HLcNgYi0MEBr7zAHXf0o/JfRVoMqRN8OBmRR6d8imGTDBGjnw3bbflVi5EszcaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ2aQgwwUStHeh8cV4C6Ene1J4lL3kgzI+RemfRjbeQ=;
 b=U7QOg3JMXlmGcs1tFyIJdW0M/ek3uHiJPTX7Z6jt8uPjdmVcpgG/jouWZ69syPLgBEsFSrFSBkK4yb4YuEqDNa1Rsq9H1zGxLI+VPbau4uEP0VHP2Gs3ctaMvbA3IIETDzIqxGOUaFDYK2bpoP7evxDPOerXhwGQ2l8Wg96Jkb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN2PR12MB4256.namprd12.prod.outlook.com (2603:10b6:208:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 15:31:28 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 15:31:27 +0000
Message-ID: <d2f7ae61-5fc1-04b6-b021-c1f5c7a8d275@amd.com>
Date:   Mon, 5 Dec 2022 21:01:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 04/11] KVM: SVM: drop the SVM specific H_FLAGS
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
        Sean Christopherson <seanjc@google.com>, santosh.shukla@amd.com
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-5-mlevitsk@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20221129193717.513824-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0179.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::6) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|MN2PR12MB4256:EE_
X-MS-Office365-Filtering-Correlation-Id: 147bba49-18e5-4b54-9a51-08dad6d5c68f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zl2eXWQdKZTEEb7Dy14ioR0IuTYljZwsu2+hDEJxZag+7FnCe4KUOT8G+JCqhCg2BmJKy4lGNZ48eD/UH+osfQHhER4xBZcQLpwJt8WIZaoPJqF7UZr8UG0m5US6DrYCEoaYaZQXG5LIyBpFA238Ej9ssaMuvHP2wjDe72aKW9NJhmR6w7ckA++aOK3mekVXOmvWI4cesqfS5qXWUdKxjSpuBYVVmJlY3VXvmXgmtKmjpFzJAQdI4r05au7aEHkkmmZWYk7dmqA/36JKBCOXJ4TQPHpdeuzn69virGGcpm/x7dB3rpMdadh7GQnA/4iMAH3fwqIbclFKKbVX6dYbWj1lQdT4S5EnYtHUzvUJyO8E89MZV+uIRJXrqdvL0/wD4EQfqLqBkwH3AES8dM8pLUSvsIWY601/RHgH4hCVkBQUKSDYyVHValHR0tUqrmTCt0/Vwhjyi3UDB/LYN1UftPqvhEeMbk1uOZ7FBdpMzowtYZiAtcR9cJfbDSd/PYDpLAhpHMt7E9XqCez60hU/NQSOkXJWr733aZ+nuO+bEbqHSCsy+Q1zLpmv6jRK/rPAiIo0ukk7eZsR6z2P3oXZzIq/X5hXG3K6gWO0HA5s/cRtaQdTuXwb/N9T0ak/ydVt1u9ezTNKQeLC5Zpen+zbuyJsfkNaTCy9bfmUh0je3ZBXoIo0SxJQlv5HvcbfyRozlxMoC2jLUUr9ir+ui+cu0I5MiBLEKU/nw0SsGEW4MPo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199015)(478600001)(316002)(86362001)(44832011)(6506007)(83380400001)(31696002)(8936002)(7416002)(5660300002)(2616005)(6666004)(26005)(6512007)(38100700002)(186003)(6486002)(36756003)(53546011)(54906003)(2906002)(66556008)(41300700001)(66946007)(8676002)(66476007)(4326008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHNIdVNBQWt3UlZKaml4T3cySjhpYzZFTGZONzA3dEpuR21ONzlmUTZDOUdD?=
 =?utf-8?B?cnhEMVBpalpRdmFmVDdTTzB4aWhPWjJZaUZObDBseFl1MW1aZk1DaGtjNHZt?=
 =?utf-8?B?RDlEYzI4Z2Q4UGVNa3RGQys5T1VramFQUTA1NWFDZnJ2WWIrZTdGajRKc2gv?=
 =?utf-8?B?UDUvMkFGNGdwa2JSdzNlblY4b2xuc3ZrWjJJbnkzWmJGWFQzTWFleFFtNHds?=
 =?utf-8?B?Q0N0TEdGUHlUTUhOd00rWVptZ1BpT0szVW5WeVhEc094OUxnSDluWW5TRVFk?=
 =?utf-8?B?R2lUOU5OMDl5bk1mNGZsM3lpMjN2bHdCbFNKSDUyRUtXdzFNUzl0cjhPTm5X?=
 =?utf-8?B?ZlNKbnlVU1g1cXRMYmNzbGYvakVxQStoaGFwMW1ZbnRUdVJ3Zmt1cUZCR0Zq?=
 =?utf-8?B?aW5jcngyVDVrOFR1VFhkKzlSUDM3YkJlZnYyWGtrdTF5anh1VDdTYzZHQmVM?=
 =?utf-8?B?QUdwbmNacER3M3Zra1RFb0t6eFY1UEI3V0F5ZVNiZ3pEUGNGTjlSK0xJTmZ3?=
 =?utf-8?B?N1ljZFFlS2k5M0R2cDBkUmNsalFkY0oveXBxTGVmZ2pyMGFuVDBqQWhPRzVL?=
 =?utf-8?B?MG9QZTNrb1lsWGFaOUFOWTFJWithQ25PSjdKMnB6Z0t5NHFuNXErOXlXekYz?=
 =?utf-8?B?TFBxTGJRaHI1b1dnRC9ZNlRiUXNnM2E2alZERkdvTjVPRHBCM08wSVYxYnNz?=
 =?utf-8?B?S1ErR1lVVEFnWDJRQkwybWM2NzJ5K21JRG5xdFI5MzhFbkY4dHh2K1hkOGI3?=
 =?utf-8?B?b3VlV3RoaU5lYnV6YUJ2VjRwbHBNTDRueURPdHQzdFJRbWJPSDVMaEtkNlEw?=
 =?utf-8?B?NCtybkg0WEEyZ25tc05LVVFzaTlxb0thQmUyNHVkdVZyTGdIVXB5RnpYTnla?=
 =?utf-8?B?WWk5MWRYMTNPVm15QmY0K3BOdWpkK0RhVlVyMm5GV3NQUUlpZEZjSjI0NGlD?=
 =?utf-8?B?QWVTN1BETlVLK1kzZGpISm41aXlpemM4Umw3YlloQkZqVS9GMGhqOFFNc2FS?=
 =?utf-8?B?eTNMekQvcFo3bTFLQi9IWnp0dG9jNytLUERuWVpHZzJUUkNTR1VlTllvbDJV?=
 =?utf-8?B?SWV4L0lXLzlrbG5xUndQY0oyc3ZOcjl0WHFDZ3BCa3YwOWdBTHMrNUxxRXFR?=
 =?utf-8?B?RDlOZlQxVjV5emkyT1dmQ2hJZGVGV0F2aDQrcDNtSUdLanozQWk4Szl6R04v?=
 =?utf-8?B?clhoSGovdmpnNmUrOEs1bzliQmc0VkR2OXZhRDZGOWdtaVlEbnZlazJZTHhZ?=
 =?utf-8?B?cGRNWDZLTHlORDZzN3ZWeGNuQmppYnBSY2l5aWxrOE1GL2dRViswQjBNSnho?=
 =?utf-8?B?S3VTWWN2RllPU1JLTElxQVZGS1MvM1pMU2RGb2pFcFhCOGsvS3M4SXp4Sytz?=
 =?utf-8?B?cU9FUUEvYitsK2tjTWpNU3ZvRlpYRE52S0FwSTUrN3czU2ZYdjBuMFVaaFJJ?=
 =?utf-8?B?N21yaHJjbUNUdm1NMDAyOUMyNHgyZ3Uvc1dkc0p3b2ZONyt0NEVmNzRIQ0xj?=
 =?utf-8?B?UUxmcTVqOFd2VHlnWXl4L2x0QTUzV1lRcEI5dlN4cktSblNoWmlHMUFiZE9L?=
 =?utf-8?B?aUhQMmdpd0ZQaTNxcjlDVFNiM09reGFtbEppTUNpcjFEMnJ2RU5LMUpCYklI?=
 =?utf-8?B?cHlHRUpBSnJuTGNHOTRFZk1BMm9FNmVsRGhCVlYzeU1wS290N0FCMEIwUWZw?=
 =?utf-8?B?R2ZVRDVjZXhZb0hvbDR0QmtURjFwSmIxTEsrRW9abThxbnRBZWV2VlVMK2tn?=
 =?utf-8?B?TU9ZdnRiWVFSOVNSTFh5QVV3SytKMGtZMGd6Yml4L05ibDIzVDV2Zk43eVho?=
 =?utf-8?B?Qk8wWXpSKzZOZEk2V0N0eDQyalV1S2dtc2R3THlxd2VrUzQ3d1NaVnAyUjRv?=
 =?utf-8?B?L1BTcTZmUXk3cXdSb1JQNFhnWlBLeDFURVhxSWtnc3p1SGs2Y1VPdzZVcGxr?=
 =?utf-8?B?M3hHSkpmVE1UK3l2Y1Nma3o0YURyVnF3MG5ySGRBa2dISVJ1NlRFMnpTTGJj?=
 =?utf-8?B?NHA1UGVyQzR1RjVvMTQ5bURNaXlzNk12UlQrQm55K3BFQ1hOY3BBeGVDN2xw?=
 =?utf-8?B?SnhLbEZYc055RWY3cjU4djd6UTdiQnFNUHdGTmwwQzBhMW91ZXVFOE4rY080?=
 =?utf-8?Q?4TXc1OfagZvrFwDMhv9yoBIH5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147bba49-18e5-4b54-9a51-08dad6d5c68f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:31:27.8605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKq3/5+DTnFY7F88w9DDaCF9V00wNPfffQ+/ps/2u0idULg0tDuI0ItpjxnWRabnlnjrA8JV+YRaS3UhpZtpoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4256
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
> GIF and 'waiting for IRET' are used only for the SVM and thus should
> not be in H_FLAGS.
> 
> NMI mask is not x86 specific but it is only used for SVM without vNMI.
> 
> The VMX have similar concept of NMI mask (soft_vnmi_blocked),
> and it is used when its 'vNMI' feature is not enabled,
> but because the VMX can't intercept IRET, it is more of a hack,
> and thus should not use common host flags either.
> 
> No functional change is intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ---
>  arch/x86/kvm/svm/svm.c          | 22 +++++++++++++---------
>  arch/x86/kvm/svm/svm.h          | 25 ++++++++++++++++++++++---
>  3 files changed, 35 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 70af7240a1d5af..9208ad7a6bd004 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2052,9 +2052,6 @@ enum {
>  	TASK_SWITCH_GATE = 3,
>  };
>  
> -#define HF_GIF_MASK		(1 << 0)
> -#define HF_NMI_MASK		(1 << 3)
> -#define HF_IRET_MASK		(1 << 4)
>  #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
>  
>  #ifdef CONFIG_KVM_SMM
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 91352d69284524..512b2aa21137e2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1326,6 +1326,9 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
>  	vcpu->arch.microcode_version = 0x01000065;
>  	svm->tsc_ratio_msr = kvm_caps.default_tsc_scaling_ratio;
>  
> +	svm->nmi_masked = false;
> +	svm->awaiting_iret_completion = false;
> +
>  	if (sev_es_guest(vcpu->kvm))
>  		sev_es_vcpu_reset(svm);
>  }
> @@ -2470,7 +2473,7 @@ static int iret_interception(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	++vcpu->stat.nmi_window_exits;
> -	vcpu->arch.hflags |= HF_IRET_MASK;
> +	svm->awaiting_iret_completion = true;
>  	if (!sev_es_guest(vcpu->kvm)) {
>  		svm_clr_intercept(svm, INTERCEPT_IRET);
>  		svm->nmi_iret_rip = kvm_rip_read(vcpu);
> @@ -3466,7 +3469,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  	if (svm->nmi_l1_to_l2)
>  		return;
>  
> -	vcpu->arch.hflags |= HF_NMI_MASK;
> +	svm->nmi_masked = true;
>  	if (!sev_es_guest(vcpu->kvm))
>  		svm_set_intercept(svm, INTERCEPT_IRET);
>  	++vcpu->stat.nmi_injections;
> @@ -3580,7 +3583,7 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>  		return false;
>  
>  	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
> -	      (vcpu->arch.hflags & HF_NMI_MASK);
> +	      (svm->nmi_masked);
>  
>  	return ret;
>  }
> @@ -3602,7 +3605,7 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  
>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>  {
> -	return !!(vcpu->arch.hflags & HF_NMI_MASK);
> +	return to_svm(vcpu)->nmi_masked;
>  }
>  
>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> @@ -3610,11 +3613,11 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	if (masked) {
> -		vcpu->arch.hflags |= HF_NMI_MASK;
> +		svm->nmi_masked = true;
>  		if (!sev_es_guest(vcpu->kvm))
>  			svm_set_intercept(svm, INTERCEPT_IRET);
>  	} else {
> -		vcpu->arch.hflags &= ~HF_NMI_MASK;
> +		svm->nmi_masked = false;
>  		if (!sev_es_guest(vcpu->kvm))
>  			svm_clr_intercept(svm, INTERCEPT_IRET);
>  	}
> @@ -3700,7 +3703,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
> +	if (svm->nmi_masked && !svm->awaiting_iret_completion)
>  		return; /* IRET will cause a vm exit */
>  
>  	if (!gif_set(svm)) {
> @@ -3824,10 +3827,11 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>  	 * If we've made progress since setting HF_IRET_MASK, we've
>  	 * executed an IRET and can allow NMI injection.
>  	 */
> -	if ((vcpu->arch.hflags & HF_IRET_MASK) &&
> +	if (svm->awaiting_iret_completion &&
>  	    (sev_es_guest(vcpu->kvm) ||
>  	     kvm_rip_read(vcpu) != svm->nmi_iret_rip)) {
> -		vcpu->arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
> +		svm->awaiting_iret_completion = false;
> +		svm->nmi_masked = false;
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	}
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4826e6cc611bf1..587ddc150f9f34 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -237,8 +237,24 @@ struct vcpu_svm {
>  
>  	struct svm_nested_state nested;
>  
> +	/* NMI mask value, used when vNMI is not enabled */
> +	bool nmi_masked;
> +
> +	/*
> +	 * True when the NMI still masked but guest IRET was just intercepted
> +	 * and KVM is waiting for RIP change which will signal that this IRET was
> +	 * retired and thus NMI can be unmasked.
> +	 */
> +	bool awaiting_iret_completion;
> +
> +	/*
> +	 * Set when KVM waits for IRET completion and needs to
> +	 * inject NMIs as soon as it completes (e.g NMI is pending injection).
> +	 * The KVM takes over EFLAGS.TF for this.
> +	 */
>  	bool nmi_singlestep;
>  	u64 nmi_singlestep_guest_rflags;
> +
^^^ blank line.

Thanks,
Santosh
>  	bool nmi_l1_to_l2;
>  
>  	unsigned long soft_int_csbase;
> @@ -280,6 +296,9 @@ struct vcpu_svm {
>  	bool guest_state_loaded;
>  
>  	bool x2avic_msrs_intercepted;
> +
> +	/* Guest GIF value which is used when vGIF is not enabled */
> +	bool gif_value;
>  };
>  
>  struct svm_cpu_data {
> @@ -497,7 +516,7 @@ static inline void enable_gif(struct vcpu_svm *svm)
>  	if (vmcb)
>  		vmcb->control.int_ctl |= V_GIF_MASK;
>  	else
> -		svm->vcpu.arch.hflags |= HF_GIF_MASK;
> +		svm->gif_value = true;
>  }
>  
>  static inline void disable_gif(struct vcpu_svm *svm)
> @@ -507,7 +526,7 @@ static inline void disable_gif(struct vcpu_svm *svm)
>  	if (vmcb)
>  		vmcb->control.int_ctl &= ~V_GIF_MASK;
>  	else
> -		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
> +		svm->gif_value = false;
>  }
>  
>  static inline bool gif_set(struct vcpu_svm *svm)
> @@ -517,7 +536,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
>  	if (vmcb)
>  		return !!(vmcb->control.int_ctl & V_GIF_MASK);
>  	else
> -		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
> +		return svm->gif_value;
>  }
>  
>  static inline bool nested_npt_enabled(struct vcpu_svm *svm)

