Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2366C661CB6
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 04:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjAIDdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 22:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjAIDdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 22:33:35 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA625580;
        Sun,  8 Jan 2023 19:33:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WP+cVtRPMVN2GWEPLVEl6SyHExzYT7Vyxh/75TD3PCq1dHjUfLVV+JIEgh1wtU0JjZKQAhTTWDqUtdtM2HjqWeAzxrHbiW0foQDhH1W6ErbdvpiRHSM8vsWX+AJear5R4B0AbndxiIUyeMiPXrBOW6j8T8kFe7lOUGogY03vL5I8r7nKjZ/kZpysz5ydjtyOP+bph5blC2Hu9a+eLqdGc/5PtomJ2AI04F5XV4gMChcUbBrEjhTczhwXLEbQTORym+RRFzKa9e0GAwAJuDJFvF9rh0K+F19l5Y6iIr/NKpgoyRrxRBACx2jm2bYOyYq8Agiwup4mgQ2+XYc4G8mBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JeHqvT/E7SxtTVPN0QUVMsdBSyV1GfLEf8hk7yHZ7k8=;
 b=HxuTQv81FxXoeQD51MWf6RZnVF225W7SYDodTRiTnop+QkBZp/9sGPmxZQC3nAy6AJu92kSJTmzBzZFISCaG+fxMkGvXzNB6mBePdaipWRLo2LEtspPguNUcB/l3T02vx4eyy/TTrmXRGkcOmS4bPqLyHxEybEkmhT/76XGuK0qob8aQvwUNMd2OAvLn7Wbg73V68C3TiLpzfWB03AWF7WIn5FxHOVyyzXzDez9p16UU6ZPHvZit9x7Y71XrSptEecSnU+HeQ6lVPvnzXkH51MO6vxN24cRdOWS+tf6H2akVJ9vlVzmih3NZBMFJB4ij3Tmr+8j8xk01lA6+l9eAgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeHqvT/E7SxtTVPN0QUVMsdBSyV1GfLEf8hk7yHZ7k8=;
 b=EVi2xMlSqexmmOp4UJYbARE0Udx/f0hvtC/YfPJ8V/qd+aCRd456UvyS4rAmWln0CNoOzWfsgONn1cyI1Y5YF/IyAv45VHaI+FX429npPMXmH45EQFVobZ3Fro4HWTCTQjdFEWrc2UUMkFb7pNi2qf912M2S0v3nk8ulaPBqLrI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 MN2PR12MB4159.namprd12.prod.outlook.com (2603:10b6:208:1da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 03:33:31 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 03:33:31 +0000
Message-ID: <aab7ed11-870e-579d-9328-4c32d9936392@amd.com>
Date:   Mon, 9 Jan 2023 14:33:13 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-53-michael.roth@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20221214194056.161492-53-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0175.ausprd01.prod.outlook.com
 (2603:10c6:10:52::19) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|MN2PR12MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: fd57452a-660b-42ef-4497-08daf1f24754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4i1mYJCHK1PWtnqo6nJ68yL2e+PH8F5jvnx7rLLS8lBIa+cbo/VLWHis20LtkuPJj22l1jHpRyIkWR/sDIJ9onFr+In2h65aW7fr0lbQ7AFu16uQyR44bRZIGrKTMgndgTiIpIvAQuuQwBWbnrBRtKY2xbCQycFVq2xG8MG6/t2t3eexojbvPPYQU2o6wfWI04FnDzlbWR/PkDouxdjZQ6QVwfb62fueylYkq0lzCZD7NpBMusfvJwKAkGWQ0Vj6drdt5IRKw8fpHlaZLhBGxvLUVw8yD/27tFXRPXGkB1SSvdx+Wi+IZ+MYiomhXOsEetAplLHHQLGzbdgoxQ/ieOR2KXWUrVKBSuAS/1um4zdKBxl3Y7dO9ij9DkLXHTp7rnXduf9buHfhAZUd6FDuRkMh/o2Lzb3JZh/Ol3w2e6Vpv1G4K66YIHzX2y1IVZS1jrt1rZhiNguv/g110fvlZqELz1O9iFmqCsvp+uHIK7EdZhzWSj6zYMyY+FlsNpR/hce9B827yi8nNp/DJ0RqcOjKwoBtpudvdFVuz3/GqJQrpfwJFVFRcYRA2iPHVg/fyEOs5DI8DacJHkrOfYuWJCwg4YTdZ/vxbUmnKvgLdL/OIVIK1JuJcx/NKhuwGJl9cihHU3zm4tAYxvmPsE1abICfgKxdCTd18jn5HAyBq0jWFkRi4trl+gd9NbCyASwZ/sDaqtd0l2TpjqNC0Se1OEilzuOqdc+N5SAHrzd2zw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199015)(41300700001)(31686004)(8936002)(5660300002)(7406005)(36756003)(7416002)(2906002)(8676002)(66476007)(66556008)(66946007)(316002)(6666004)(6486002)(6506007)(53546011)(478600001)(26005)(4326008)(186003)(6512007)(2616005)(31696002)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm1pMXBvMDNVT2tZRklwQndLZ3Zra2hrdDQyeHJNaDJhbHJGYnhtZ3JGcVVJ?=
 =?utf-8?B?cGZ1dDZLSWZUZ0F2OVdIdnV0M0JTSVM4WE9GK3krQlRYVEZvZ2l5QUVkQ0dW?=
 =?utf-8?B?ay92dFpzMDZFd1gvY21kbjRjaDllY3NDbGlpR0tUeU9tSlNNZEE3V0pvL0ww?=
 =?utf-8?B?STJTTlFkVGxPTVdoSC84R01GaDhEdjdGR0lTL1pyRWhPam5jZU80eVg0VVN5?=
 =?utf-8?B?QWh3eVVUTmJjb1k4UGc1OG00ZXFqZ0tVLzR4emVwNzNiUlNhSE16bjJDTnBQ?=
 =?utf-8?B?TktFa1hvQTd4MDVjSzlXZXBKVlNaLy9ZS2VTNXhhd2tjUDVpRWpBRldzdlhE?=
 =?utf-8?B?eDJwTmg1dDhTcTM3d3M1WStvUkw0T1JJck5EOUp4WkNuK29id3RXVzkyM2NR?=
 =?utf-8?B?TVpVS2FYVEFCYkJyWFY4clp4Yzgwb3h6RGVqMFRFdVVUbDJxSXlkcjhiYmdP?=
 =?utf-8?B?dUx4amd2SGJaRmFKOXZCNXFQd3BBaDhndmtNa3IrOHhiV3N0eHJ1OHBXSjhz?=
 =?utf-8?B?WWNNM2c2ZnZNZGxJMXhub1dFdUlESTY1VVVOOGtoSGpHNHlrRGI5OEhCWC96?=
 =?utf-8?B?Qzl3M3ZNcUJIVEJtSnQwZzZBcEpCampaZUZVblBLbEJPUXp4RExQUkUrOHZs?=
 =?utf-8?B?VjFpYlVEaDI4NjJEZWNUeHVDb3NYVlpVK0xtWW8yK1ZpbHllbnZBWG1TL1JE?=
 =?utf-8?B?MUowSTdURU02KzFxZlVUY3Q4bzRyQzZ6a3J4YWM0dkFUVGwvTkV2K00rMWlP?=
 =?utf-8?B?c2VPaXRxZkZDOEtBSkJ3azBkZjN2eFZEMllITjZ5RFVEWGJ5M3NaVmhMTWpY?=
 =?utf-8?B?WWJ0RTJMUEFEdlZ2VHlwd05ybkZRZ1dIM2tMS0UrUEZyQm1wV211Umd4VStw?=
 =?utf-8?B?THJtdFlDL3B3dUdYdzA3OTN1WitEZWNXam9ROTM5LzJCcmVaTWVUUFh1aDcy?=
 =?utf-8?B?ZWc5S0dZZ29GQWxvaDhxcmNjSDdKREpiOEZKYkV3WVQ2VG9BMEtvQWZ2V083?=
 =?utf-8?B?anFuSEdCdnBzZWtrM09vdExBYTdoQnF0VmRCQ3RBUGl2MGJwNXRUYkZ1VndO?=
 =?utf-8?B?M1ZJOFVLeENlb1Bsa3M0VDJmcldKNzNJaU5UMG1Ia0RPV3dsVkRyRkFNbFds?=
 =?utf-8?B?ckxYbWUwdnNyR280dU9KWFB3MCtlWENMRmUxcFpWdEJUTDdqalI0d0dhaG5n?=
 =?utf-8?B?REk4Vlpwdm1uVlNOMGJNWlJ2cGRuSGlvbVVzTzBINXYwMXRZK1F3NWh0aDEv?=
 =?utf-8?B?cXE1Skh3VTZtQnk5YWZHRjlKeVIvbnF0RFp4dlJNYnVWaERXS3gxUHFEMXdL?=
 =?utf-8?B?ejN1TFpTQk9pYllQNEdOaTduWExVWTcwTFdDVitTTWVHdlRyY1ovc1JwNith?=
 =?utf-8?B?dDhvOXBGdmhtbGZROGNBekljbjhjNDdSaW9nUjJPbndiQWN3bURmenZWMHB2?=
 =?utf-8?B?QzdyUmFZV25BQVBzTENDV2NlQ3VhQVdodGdZVzErMG93aXVFUG5PTzNBdjY5?=
 =?utf-8?B?ejR5bkoxZENIdi9IWFRBOExDK1BmRkRXZFZsbkxWZUVzaHlmY0JabTdOYkNC?=
 =?utf-8?B?VUlYbC9FbFpwRGIyM0xvOTZ0SnVOWDFBczR1MCtrZUdHVHB0STNsZXhUbExx?=
 =?utf-8?B?YVVoUW9yZm9Ddk9QdGcyRk1uOThlNnJ4UTJ6NFVHbFI2L0lmWXZPV0FUcUlI?=
 =?utf-8?B?eEZnZjZXclA2UnlCWmVINkorSGZIRFdxM1NwMU5EVUFZQ1M3TW1BdGt4dTBY?=
 =?utf-8?B?OVRlY21ITmhoTzMrd1YxSHlZYnBLYjkvR21Oa0JBVWlZUlVvU3ByUEhacGEx?=
 =?utf-8?B?NEhtM3ZCM0dTQmJhNVhteVErc0llTzdtZ09kVDBKZENQNUVwc1UwN09FRzdZ?=
 =?utf-8?B?d0pzNDRneXhYZ1FFTVlwWWdYbDVaRG1zaEd0U0hYRkZlUkdjRUNyMWIxSVpB?=
 =?utf-8?B?NDdFNXZIOTZxVWJZTTRnbFZ6T2VvUjl4bmpvY3c4MUxVV2xVdlAvV050bVZH?=
 =?utf-8?B?RVhWQTdleFZSTmZKNFhpcEs3bDNOUzB1UUhTNm5KMTVtQStScHlONlZUUE5l?=
 =?utf-8?B?MnBQQmRUL21IVUhWUkdvUWw1OTVXZitUeDhCQ0FDT3FIK3oxejhxTWFpbVh1?=
 =?utf-8?Q?iikUN6U29Ravd4KPd9wx1v1+H?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd57452a-660b-42ef-4497-08daf1f24754
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 03:33:30.9930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKyJAYWyrxH5sWvd3VppaQs0vQpYfcE50ElEl0xKcW2OGPingM3vcw0Pe4wLPp37o4pZfRScKs/heOyfAnmPXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4159
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/12/22 06:40, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Version 2 of GHCB specification added the support for two SNP Guest
> Request Message NAE events. The events allows for an SEV-SNP guest to
> make request to the SEV-SNP firmware through hypervisor using the
> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
> 
> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
> difference of an additional certificate blob that can be passed through
> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
> provides snp_guest_ext_guest_request() that is used by the KVM to get
> both the report and certificate data at once.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 185 +++++++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/svm/svm.h |   2 +
>   2 files changed, 181 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5f2b2092cdae..18efa70553c2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		if (ret)
>   			goto e_free;
>   
> +		mutex_init(&sev->guest_req_lock);
>   		ret = sev_snp_init(&argp->error, false);
>   	} else {
>   		ret = sev_platform_init(&argp->error);
> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>    */
>   static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_snp_addr data = {};
> -	void *context;
> +	void *context, *certs_data;
>   	int rc;
>   
> +	/* Allocate memory used for the certs data in SNP guest request */
> +	certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
> +	if (!certs_data)
> +		return NULL;
> +
>   	/* Allocate memory for context page */
>   	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>   	if (!context)
> -		return NULL;
> +		goto e_free;
>   
>   	data.gctx_paddr = __psp_pa(context);
>   	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
> -	if (rc) {
> -		snp_free_firmware_page(context);
> -		return NULL;
> -	}
> +	if (rc)
> +		goto e_free;
> +
> +	sev->snp_certs_data = certs_data;
>   
>   	return context;
> +
> +e_free:
> +	snp_free_firmware_page(context);
> +	kfree(certs_data);
> +	return NULL;
>   }
>   
>   static int snp_bind_asid(struct kvm *kvm, int *error)
> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct kvm *kvm)
>   	snp_free_firmware_page(sev->snp_context);
>   	sev->snp_context = NULL;
>   
> +	kfree(sev->snp_certs_data);
> +
>   	return 0;
>   }
>   
> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   	case SVM_VMGEXIT_HV_FEATURES:
>   	case SVM_VMGEXIT_PSC:
> +	case SVM_VMGEXIT_GUEST_REQUEST:
> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>   		break;
>   	default:
>   		reason = GHCB_ERR_INVALID_EVENT;
> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
> +					 struct sev_data_snp_guest_request *data,
> +					 gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	kvm_pfn_t req_pfn, resp_pfn;
> +	struct kvm_sev_info *sev;
> +
> +	sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
> +		return SEV_RET_INVALID_PARAM;
> +
> +	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
> +	if (is_error_noslot_pfn(req_pfn))
> +		return SEV_RET_INVALID_ADDRESS;
> +
> +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> +	if (is_error_noslot_pfn(resp_pfn))
> +		return SEV_RET_INVALID_ADDRESS;
> +
> +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
> +		return SEV_RET_INVALID_ADDRESS;
> +
> +	data->gctx_paddr = __psp_pa(sev->snp_context);
> +	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> +	data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
> +
> +	return 0;
> +}
> +
> +static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsigned long *rc)
> +{
> +	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
> +	int ret;
> +
> +	ret = snp_page_reclaim(pfn);
> +	if (ret)
> +		*rc = SEV_RET_INVALID_ADDRESS;
> +
> +	ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +	if (ret)
> +		*rc = SEV_RET_INVALID_ADDRESS;
> +}
> +
> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct sev_data_snp_guest_request data = {0};
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sev_info *sev;
> +	unsigned long rc;
> +	int err;
> +
> +	if (!sev_snp_guest(vcpu->kvm)) {
> +		rc = SEV_RET_INVALID_GUEST;
> +		goto e_fail;
> +	}
> +
> +	sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	mutex_lock(&sev->guest_req_lock);
> +
> +	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);


This one goes via sev_issue_cmd_external_user() and uses sev-fd...

> +	if (rc)
> +		/* use the firmware error code */
> +		rc = err;
> +
> +	snp_cleanup_guest_buf(&data, &rc);
> +
> +unlock:
> +	mutex_unlock(&sev->guest_req_lock);
> +
> +e_fail:
> +	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
> +}
> +
> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct sev_data_snp_guest_request req = {0};
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	unsigned long data_npages;
> +	struct kvm_sev_info *sev;
> +	unsigned long rc, err;
> +	u64 data_gpa;
> +
> +	if (!sev_snp_guest(vcpu->kvm)) {
> +		rc = SEV_RET_INVALID_GUEST;
> +		goto e_fail;
> +	}
> +
> +	sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> +
> +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> +		rc = SEV_RET_INVALID_ADDRESS;
> +		goto e_fail;
> +	}
> +
> +	mutex_lock(&sev->guest_req_lock);
> +
> +	rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
> +					 &data_npages, &err);

but this one does not and jump straight to drivers/crypto/ccp/sev-dev.c 
ignoring sev->fd. Why different? Can these two be unified? 
sev_issue_cmd_external_user() only checks if fd is /dev/sev which is 
hardly useful.

"[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
attestation report" added this one.

Besides, is sev->fd really needed in the sev struct at all? Thanks,


> +	if (rc) {
> +		/*
> +		 * If buffer length is small then return the expected
> +		 * length in rbx.
> +		 */
> +		if (err == SNP_GUEST_REQ_INVALID_LEN)
> +			vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
> +
> +		/* pass the firmware error code */
> +		rc = err;
> +		goto cleanup;
> +	}
> +
> +	/* Copy the certificate blob in the guest memory */
> +	if (data_npages &&
> +	    kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
> +		rc = SEV_RET_INVALID_ADDRESS;
> +
> +cleanup:
> +	snp_cleanup_guest_buf(&req, &rc);
> +
> +unlock:
> +	mutex_unlock(&sev->guest_req_lock);
> +
> +e_fail:
> +	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
> +}
> +
>   static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>   {
>   	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -3629,6 +3788,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   		vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
>   		vcpu->arch.complete_userspace_io = snp_complete_psc;
>   		break;
> +	case SVM_VMGEXIT_GUEST_REQUEST: {
> +		snp_handle_guest_request(svm, control->exit_info_1, control->exit_info_2);
> +
> +		ret = 1;
> +		break;
> +	}
> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST: {
> +		snp_handle_ext_guest_request(svm,
> +					     control->exit_info_1,
> +					     control->exit_info_2);
> +
> +		ret = 1;
> +		break;
> +	}
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   		vcpu_unimpl(vcpu,
>   			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 12b9f4d539fb..7c0f9d00950f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -101,6 +101,8 @@ struct kvm_sev_info {
>   	u64 snp_init_flags;
>   	void *snp_context;      /* SNP guest context page */
>   	spinlock_t psc_lock;
> +	void *snp_certs_data;
> +	struct mutex guest_req_lock;
>   };
>   
>   struct kvm_svm {

-- 
Alexey

