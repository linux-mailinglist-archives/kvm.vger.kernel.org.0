Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12515EF6DF
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 15:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiI2Nrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 09:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiI2Nrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 09:47:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4857C14C9D8;
        Thu, 29 Sep 2022 06:47:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xp/6jwvZWDs8bxxj2VOJy77ztkYXnbU2wiRl+Tx6kw7kXDR5wFum3AbxfK/JYaYk7NPWIQy/TQtBtX4NFZvjNbTySmSmAHi+2V+vvCCeSol0thwWfLOLg3D/gyk1FETb3mf7KHCggo47M4KR20aKXRuEuH4Sgd10ryta2Q3cekYXY7I1x+vf4sbfyt4DFnjBMRMKDin6UQMdw6wSz4QsEi+6evsHu3L4h2gv3VTTKFBHWWFUFLN3hMGTDZJqdiVFYB7/wL4ys8Y13X1y9jdhYnwO2bxztI5eVmcsHJJxGH/AvWeFGnA2CEQkBt1eO8AdMKCSqPiu4W+egqvnNRRLYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wSnYY4sqb8QH1P3An5ZkZIl//f54ppmzmzk2dPAAohg=;
 b=BdGci0LcdjQIuDRfo49c32thjtznoTHbXvBIr8y8lpXpo+zw0nk5rqWxHIglJQbnfqdB/eITxNPmDxbfXpNUaaBiD597oMuX4fL0pDm/wql+6sKQ1tXiZzVxt7kQDJ7B1kuMRinVFxJdE5ULhs9BA5nz4D1blq+yFQF6BWKRUbb/VJbMM+cs3XmmAoaDTTCl0lGxwb4sxEd4GffLYRq3BO0QQbduoo+ZEvhGk1EHaHhZljUmFPJkUbLT+ODuXbEV4/fk4FoPwzsa4trdwX8HLXqXqDhOtk1dHnB+E91aMz7GO9/uqvayC+mGmM+cs5Zl+Ukk1BDL8/E4PBey4YSMmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSnYY4sqb8QH1P3An5ZkZIl//f54ppmzmzk2dPAAohg=;
 b=hWP8ffYt8A2pUNjY2nG7sF+wO1/fWU/TKVlW/Jxsv4Bi2q2M+b1FSbwSn2CyZ42oiQewJ+OMSo0nivOghZZJYc7XsvtbuBeox/n1s9zlHOXWfs/ATgsrHBspxNa3B2exe2OAEjXNJ8zWFS+MgymRPDHqD/2qgWDYv5XTGoKZv88=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 29 Sep
 2022 13:47:37 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 13:47:37 +0000
Message-ID: <f88f3f67-20af-0ed4-0227-f2f89d5bcd50@amd.com>
Date:   Thu, 29 Sep 2022 08:47:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: don't apply host security mitigations to the
 guest
Content-Language: en-US
To:     Fares Mehanna <faresx@amazon.de>
Cc:     Benjamin Serebrin <serebrin@amazon.com>,
        Filippo Sironi <sironi@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Babu Moger <babu.moger@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220912115809.76550-1-faresx@amazon.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220912115809.76550-1-faresx@amazon.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0026.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BY5PR12MB4903:EE_
X-MS-Office365-Filtering-Correlation-Id: 99860944-0405-45fe-acb5-08daa2212b71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzDLtwgvOukU04ArKDiVnWLbgUemJoxvOhZQup49mGqPyZqRAXP+KP228tOJPHHavwEsd/2CuuL5HFGwj2Yl2M1SxBD0jfh1AhhPMUxL0l7B3HV2gwv1RWgj6uoLIi8uUGjJX4dDMmzdlXwk7psHrG/I4KBgIwgDjGyPKVCtduP+Q75VJO2q3QrTlZV8hAgnrYyDq51pQJ/OfHt/iAeOPRd7EqJtbazBvbzqLUadIQogf/z6yfmkDRY3wKPFfbBXOpOmX+ho0nqxaJFrCQgzWq0Cx2n3ie4RKubDdJz8Tg2qCoaJO45qQ4cuqEpTx1N7jEtWavU5B8kbKSumkDKtQ0bb4JMwYVTV1lobT7jKC6QHz0Rl90WTINcX4Byq981WEa1Y7BZbJ/sVJDXi0Qvv5a6I4L6rGuI5FPXLO28LQc0e+I0Ks6u6SUK+fdH/hTMtZIdnKPuocJ1G8dr7BGLokOgCfHyfM4+AtYZDVmYvYNN2Y1WXBQibwqc2Dks6cVvMJejtWjZc0n/ubYuuXoktmtiKJuPdYJcsb4vcwUA3n5x3RomLIMJnYlvCTLt0hJYFVLmzKdmPae8LcNnowN0RxBQLaQC9+kEbYliB+u74prAhR9R4vbCV6gadBBSBhQK6ovT44/dpZA+vBKwvvJ/LsBn2LNSiErAkZnm4phv1QYChUDZ3u6YkLsfueeKk4P66qxIUIzFg6JpR5qXDFO5uK58Z2XjAX2GFWUAfd4M9zdyCpkFQbsD6kJoiH1Yg2ireOOZ+uc9Ms33CK7a5diKpgUaOpubgPXmz5oBtTx0B3hs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(2906002)(15650500001)(6512007)(36756003)(26005)(2616005)(31696002)(38100700002)(41300700001)(4326008)(66476007)(66556008)(8676002)(86362001)(186003)(66946007)(6916009)(54906003)(5660300002)(316002)(7416002)(8936002)(83380400001)(53546011)(31686004)(6666004)(6486002)(6506007)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFJ5QWFTbUZ2b0poT3ZjZSs0WnJCOXYyNnFkR3JoVXpHQ3dmM1B3ZkNqcHhT?=
 =?utf-8?B?RS9KbS9sQkNCb0ZxVVpQRXZHaVJHdmQyL2pDMUp3Z1I0VmtJbHhhSVlObytL?=
 =?utf-8?B?UEFrc1NnUDlSWEJsNnpEWjNzY0E4QUpUaVJsVlVEZzR2WlBNdkkzY3JaNDJ1?=
 =?utf-8?B?c1crNmwrYktvb2p4REZxd3BYOEoxalI1cGM1eWVGSG1zQko5a2ZGU0dkRUdD?=
 =?utf-8?B?bmo1Y3lqbTRjdUVQZzk5TXVPb1F5Ym5iQ2JlV1ArcmwrZEFBMkxGeno0YVZG?=
 =?utf-8?B?V1A2djRRWUtnNW1HZzZaUXFyNnRGSmNDVm1Eb3VJU3kyYnl1YnVzT0F4c0lt?=
 =?utf-8?B?aDFKNktEUUN2WlE1RmdEOWJjRWhWYVJpdW55QWJrK2F2T0t2OS9hZ3ByZEVu?=
 =?utf-8?B?aDhNMlU3N1M3Lzd3NUV3VUZNNy9nV0JRNmpVc3dxL01Nd0U4M1ptUTBtQ28v?=
 =?utf-8?B?Sk5ZYVRKak5rS0tIY0ZMK201b01SMlk4VThyV3k0MURpUFlNT3Z4b0tEN21i?=
 =?utf-8?B?SGRpSGh3TkJhaUxHbFEwYjQ4dWdWeEx2V0JOczBRM1EwSHNwOGxzSG5qbHpr?=
 =?utf-8?B?K205cGZPUis4b0dnUUwyeG9ROFdneGNFSTVlWmN5WlBwY0NRMGJ4TXRaME1m?=
 =?utf-8?B?azIySXMvS3RScmJvSm13ajNBaS93dVRoODZ5bGJOemVMSWNYa0dwaVNxUHFn?=
 =?utf-8?B?L1VxbUxtSGNFWmdrRmtvVXl1MTFXNGRwdnVtVjNvek83OURpRExZQk5tNkVa?=
 =?utf-8?B?TEQwNEZPVXdJMDJ2bU9VZVViLzNvRlZhQUwyM0h1d1VINVFiSVFJWTFIQWlD?=
 =?utf-8?B?eWZFNDVHMWxtNDFvcHdTQVpYR3RFWnZBbTNFVFlwdzhhMkl0QVQ2WEF2VXRk?=
 =?utf-8?B?WFZrSXBDU0hRZFBodG50cWRUVWRWdzVaUHJNMlpWMUJmM2ZxZW9aZkdvUUNB?=
 =?utf-8?B?N2loVGJqeXJtTjNrQ0tTc1pKdGlaZFh4TXNPdEozdWg3QUYwZmphdjNuSkVt?=
 =?utf-8?B?OUVFSm92enE3Y0FMVEphY2ltTVliM0xvWDFvL3I5YmIxMWlJVi9ON2JzaWpk?=
 =?utf-8?B?SUN2cXluWnFUK0lOaW50UElOOEVzNG9jajdJQUp1S1Q2eFhDUjFKd2VRQVZu?=
 =?utf-8?B?MjhKZ0JXTXdENzRkZG1UcHdWcDNHY05nRXpZaFNuTVNNU05vR01ES285d25v?=
 =?utf-8?B?NXF1RUJ3SjZLV2twREQwcjJkRDhsMWthcDRhMnZ1Y3AxazgzcHRFSUhqbnRx?=
 =?utf-8?B?bGl0a0xYblBjaXFhZFd0VUFvbkhUREFOckxjLzEyUFpLWVhDQy81TEQ0ZlFy?=
 =?utf-8?B?Wmp6MWQ4VFloSWZoL09ObzR1RXI5Ukh6VCsyU0pIR05sZ2h6Z2JFamlZK0lt?=
 =?utf-8?B?OTAzN2ZRWHZOaHQwbGxxZWdQV0xPNG9taVErMm5CZ3M0TC9sTGtkdEtwNi8v?=
 =?utf-8?B?Ym01L3djUzVrTVlkbGJBTGpjWUk0OSs2RmRYelNJY1l1TExzWUNmSUxPY2Ny?=
 =?utf-8?B?RTR6RzBacXYzYXNCZG9nNzBRajFscGQ4SlNqQ2N4Mk9MbzZKL2dJOVF6eGZJ?=
 =?utf-8?B?Vk9pdVRDK2g2ZGFDL3RaSFBHWlU0ZXhSRFc0MHJUY0daSlREV3lmSG9SRGZO?=
 =?utf-8?B?cmEvdnNxdEhDd0xsd0ZQc1RjSFpoRGp0cCs5M3ZsaS9PSFRjWnB2Nm9ZZWxS?=
 =?utf-8?B?ZGIwUzhLVzUxeXBhZXJ0Snl6TzR0czVMc0c1MWU0Z1MyUENlYkk1YzJkb3N0?=
 =?utf-8?B?dFVubkNmWGQzN281b29jdVpVSk03ell4eUtOTkNCRnRFRkUxQ0RtelVKZ2dl?=
 =?utf-8?B?RHhzNmNyWFA1Q3pCWDAvNkNaNE5VMXFsSXE1Z2o3NzlKRDFDaXJaVHQyd2F4?=
 =?utf-8?B?MTlwVElRS2RVcmZUVWxkNFNyR2pnbVJYUjdYNEFZSWlaVXpRQXo0amM3V0FJ?=
 =?utf-8?B?OGdPRERXeThJQS9jMU1iNG4rRFF0OUQrVjFPVFRlVXRnS0FybTVmTjl5L3JI?=
 =?utf-8?B?NzFkVHF0ZS9MQUI5YkFlQnl2QkN0eStxTkRHUElscDhWaHFSaUpqRjZJZnZI?=
 =?utf-8?B?RTlpSk90T3IvNlpBNGV4dUJCd2ZVTXlRVlp6STJqeGdHbnl0N1Nqa1pGTnUw?=
 =?utf-8?Q?s+si5T7ilEsNfVEKirTKOziKI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99860944-0405-45fe-acb5-08daa2212b71
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 13:47:37.4086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvh6Hy/YaCDnYtCZV4TEtKI4xjlkfS9xXqx7PeX7VDlX3aT2KuqKwZkIyv2RPNbxe2ZG00AnAhTdwOFPC6t0OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/12/22 06:58, Fares Mehanna wrote:
> Support of virtual SPEC_CTRL caused a new behavior in KVM which made host
> security mitigations applying by default to the guests.

Maybe expand on this to say that the effective mitigation is the host 
SPEC_CTRL value or'd with guest SPEC_CTRL value.

> 
> We noticed a regression after applying the patch, primarily because of the
> enablement of SSBD on AMD Milan.
> 
> This patch keeps the new behavior of applying host security mitigations to
> the guests, but adds an option to disable it so the guests are free to pick
> their own security mitigations.
> 
> Fixes: d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")
> Signed-off-by: Fares Mehanna <faresx@amazon.de>
> Reviewed-by: Benjamin Serebrin <serebrin@amazon.com>
> Reviewed-by: Filippo Sironi <sironi@amazon.de>
> ---
>   arch/x86/kvm/svm/svm.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f3813dbacb9f..c6ea24685301 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -225,6 +225,10 @@ module_param(avic, bool, 0444);
>   bool __read_mostly dump_invalid_vmcb;
>   module_param(dump_invalid_vmcb, bool, 0644);
>   
> +/* enable/disable applying host security mitigations on the guest */
> +static bool host_mitigations_on_guest = true;
> +module_param(host_mitigations_on_guest, bool, 0444);
> +
>   
>   bool intercept_smi = true;
>   module_param(intercept_smi, bool, 0444);
> @@ -4000,6 +4004,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	 */
>   	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>   		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> +	else if (!host_mitigations_on_guest)
> +		/*
> +		 * Clear the host MSR before vm-enter to avoid applying host
> +		 * security mitigations to the guest.
> +		 */
> +		x86_spec_ctrl_set_guest(0, 0);

If X86_FEATURE_V_SPEC_CTRL is active, won't svm->spec_ctrl and 
svm->virt_spec_ctrl always be zero, in which case you can do the if 
statement similar to the below one? Maybe just add a comment that those 
values will be zero in the case of X86_FEATURE_V_SPEC_CTRL, thus 
eliminating the host security mitigation effect.

Thanks,
Tom

>   
>   	svm_vcpu_enter_exit(vcpu);
>   
> @@ -4025,7 +4035,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	if (!sev_es_guest(vcpu->kvm))
>   		reload_tss(vcpu);
>   
> -	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) || !host_mitigations_on_guest)
>   		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>   
>   	if (!sev_es_guest(vcpu->kvm)) {
