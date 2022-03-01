Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEE24C886E
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 10:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiCAJqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 04:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiCAJqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 04:46:53 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5327465482;
        Tue,  1 Mar 2022 01:46:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wjos0jRO8ppvCyMubHc0Y6v/IJcInQe1ceidECX9hCVeIaTYyb1LDn62yZDXlEerBTKTfnjthbI5zv6PcklP9todZR4PFILMnIn39d+NSmQu9z9G/g73Qyy7/lHEJ0XgnZwnsxR7oeA8938lJJUaSSPu15v6I+0d0cVw3iWwaKxQoxmjR/0XcOT8yglXXofZlUOTjWcDLnrc4xE2P6ztB/PKBQsAQ3TNEEnN4LLSYpDhD8M7pf0N9J1aI/Yofv0wZn5poZajQo1LJK+3dHlEK96Wt58GsjN3rZr3ZD+tF2710Ko5ChEeJdvCUWhFZNmUutuHSPTY5iO+3VBBSalMtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/fWVyOSInr1dpBoZ9hYJsVGgvrlqkTgiiIf9s/+2ho=;
 b=l6AtMFtRoBeEVn6tQpMnhBrBE3msVzQTWR1lX80yHiJjdOUXq0HkrQBYyZ3+yG5cNt8lUR7Br0khJkMtiKsudBPGBlxFR8b8vVJ4HW0sffJ7Pg3kG594bKE0lEdC5dBy6OPsF1mL6f7cXmFcUglaXIsRBDdxb7PHAQBpqc1f4FVgkrSEy03Y66+Lp6kPKV0XjpOaSfVpJ0enTvmsXk0HTVHr5AnKiV96aFZT1cyCICPcz9F8wMiPHjSeiWQD3DbyeuoDpMrMlQ+XlSseWoLTMIXT4V4rz42HPZ4sLfCT1XG/ViqBq32bh42qu3ZgwoOffBAllr12PjALPCsIoQBngQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/fWVyOSInr1dpBoZ9hYJsVGgvrlqkTgiiIf9s/+2ho=;
 b=Tx/RzF2OEJI55iu5Q2d1aUz0podbiny0aKg+Q2L47LfezzKIBmP8afL0ZhSE/3cBlSc2btVnWL6TDeVb+EywYM+x8Jg29nn5UJLaWAK+57AuCe5hUK14FThcwJ205jGezftdq/3ELHP43OCyIYLEjyH4nxXOzGadawo+2wPtHNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH7PR12MB5733.namprd12.prod.outlook.com (2603:10b6:510:1e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Tue, 1 Mar
 2022 09:46:08 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 09:46:08 +0000
Message-ID: <3354e829-ecca-37dc-a530-aaa07e839200@amd.com>
Date:   Tue, 1 Mar 2022 16:45:57 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 03/13] KVM: SVM: Detect X2APIC virtualization (x2AVIC)
 support
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-4-suravee.suthikulpanit@amd.com>
 <720d6a8d6cc3013f2f55750982439eac7ed950b0.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <720d6a8d6cc3013f2f55750982439eac7ed950b0.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0208.apcprd02.prod.outlook.com
 (2603:1096:201:20::20) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8e9baa7-ab81-45d0-dd93-08d9fb684f73
X-MS-TrafficTypeDiagnostic: PH7PR12MB5733:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5733C7CA379AA26D47C9B5C7F3029@PH7PR12MB5733.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKJSvRaFjgwIlqX4AX+vuoAv4A5zRuconHfW1arKsRf4r5A7QKF2Xs4Zyd92dOX4CxgQnEjzBh6bwlH1UlawuAgzw2QNf637LfxiPMhpudA2BZArmIA/ywXH23vM3Crvxh2Ocdiq9Cg/w+AKALNKOE+gzPDhSAWgydbpiUauvKFsCDgczehRgwujpclLeLfhtUAddX/A8QppU9A8A41S98NoOQnSa9ilMq+HKBdK+sXmqjVB00sZT2T9E9umY0yilDnOmuM50AbslMXARRSf63Svaw6KiMcJ1AtRqn9I9H51AXPkCwOj8mC5va3X/XB0krfHfKpH2LUWOEn6XM3eptQ10zBF2yXLxQbv5CZBpVZjGuuSqGRKFn106dM9ofdG5oCFRcl/uB6wyf5kdKWbJRzoOMcBfeCYligPlKKOt+Z9dY2H1BIuhtIXJ99KOR2qRemm4CX7e0H1fL2gOjvkN5pvCXmMDzki438DhWRGH+xEa7TjdLk6HMaEkQC/zxS99PjOZV1byS/REWoRb8uOZhygFgQBXoLGC1TL2i5SZUcA2F52+DhQRp3F3Vd8FdSTJWSzvoRqEw0NKjPicO+KPSs+7KG4kHFjvfFA0vyiRVEiv2r6PShgHBnCIUvl+m5NKU1zBz/Oe+ZZ0ae1sHKbDOiKRG8ccYjGIeBhQND7elDZJMVGL9pHWbRbdRMDXJRcSpijcs0LeAGWgnlNMS4yliqYiIRW5bBEV+kiQgcgYzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(38100700002)(316002)(508600001)(2616005)(26005)(186003)(6486002)(86362001)(44832011)(8936002)(2906002)(6666004)(6512007)(5660300002)(6506007)(36756003)(53546011)(66476007)(66556008)(66946007)(8676002)(4326008)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEMxS3NkT3lzbjlaQnh1VEVFeXIwZ2p2alBxZGNVY0hkekN2TGRXaHVqdUhP?=
 =?utf-8?B?QzhqcHp5SEg3R0poNjRGSTlsWEVEckp3d1ZEbzQyT0tDV28wZUxqTkVMaExq?=
 =?utf-8?B?Y0VHNGpWS1hTT3h5SlFVMGV6dGVuL2x5TFBQUFdzK1ZwbDhCc09IQWlhbFdw?=
 =?utf-8?B?N24xZ0RoUTJjL1A2NmFyVGF2bFBEVUxyM293ZTE5cWh6akR1UXlVbzMvMld2?=
 =?utf-8?B?Y0Z1RSsySENvcmRUR1JDNVhoOHg4bEdqMTNxUGdRNmN1QThvMlBhUk4wMnpX?=
 =?utf-8?B?RUZlQ3cyb1Y2UjhZOXV4UXR2Y3ZkdENQeDAyRDNGTk1pd3UvSWRrSHVZNk9a?=
 =?utf-8?B?OXpSWGdJOStkRjBUWG1nWDVvRHdrMU5yano2MmljOGRJTkVzY1dYbFNTaGto?=
 =?utf-8?B?SGF0QjlqRWIxUTVZWWZDNXo0UUpsYjMra3lURTZtN1djM2g3QUVVOVdEUGx6?=
 =?utf-8?B?WEFjak1PRGl0SXFTQjVjVExRT0Z0LzNpeS8wRy9pdUZjT2ppOGtzclJ1Nysy?=
 =?utf-8?B?N0NjM2l0RlVwZ1RmWmJIS2xKT0VwUmVSeUF6eGFSOExaaFdKWlVJWGZKZFFK?=
 =?utf-8?B?K3lhVkpqcDA4eU5NZnlOL3FDQ09pVjZiTDVVNzUxcWpGTFJUK2N0cXFVZkpE?=
 =?utf-8?B?bDNkRnNxOTN5cVZCMng3eDczZ09NYUNSVVFJOXpuUzF4ZGpudDNyUmlsSXpK?=
 =?utf-8?B?OWoyRkVwdnNmeHVVSy9WbFJrbTBVN0lVRkNpdnZLWW45cTdOblFMOUVkTmRH?=
 =?utf-8?B?VWNxRWMzaEFDR0Y1bTJnTS9xY3VuZUZtb1pqMVUwbmZIalFOdkowMlEwcGx4?=
 =?utf-8?B?UGpoVXZVOG84Yk1qMEZheUYySTJyclZFT21DZk9zZ082VXBaU3FJUms1ZVcy?=
 =?utf-8?B?TzFBQ1V6d0dLVDI3d2RYWEVzL1JBTTlFTDhSODNBUU8xWDJLNFhJTk9rcVdu?=
 =?utf-8?B?V2hGQkR2ckQvaHhGUXZoeGwzY05PdWJEM0VVMkxLYmExaHdySU16TWYxVHYv?=
 =?utf-8?B?UGRnMEs2ZXAxL3BVbmlneXRFbCsxbUJwRlB0VTZlaXhxb0FKTjZ5c090MWY5?=
 =?utf-8?B?MzIzWENYbEpxM0RPVm42bnhvTDBKREllWHg0ZHIxcUVpUGVtOHRRejNDWVRM?=
 =?utf-8?B?YlNJRHBOblIwYm9jVGxIb0tESG9ZMkptSUhraXBLbUFRZ0NmSjhzTXJsUWR2?=
 =?utf-8?B?OThlSXUxSlJwcTdhSENlbTlFblJ1M2RZMk15UEZldFlsdURVRGNmSGZSUVY0?=
 =?utf-8?B?cGc2UjdhN0lWQkV0NGpnQTAzZDR6RTJKWXVsOSsxMXl5VW5CMjhhYy95cWg5?=
 =?utf-8?B?YVY0Zll5Y3hEOEFCUEsxcXo0b3diRlpKbElieFhNZTF5eUdYa2F0QW1rWElC?=
 =?utf-8?B?MXo5UE40U1Q3bzdqYVp0Z2hLVG44RVFmS1AybUUxeGpjRVNFOEJ0WHorWmNi?=
 =?utf-8?B?aGFGcEpQK3lGWVZFRC9kSG5vdUNITXVYd3FZRlducjdINGVkQWV6alROdUdP?=
 =?utf-8?B?dE9KQUZ3Zi9QOExEYzNKdVRLdTBJYW1Qcmg0dkRXSHV5RDk4V0JPcTJDNVBh?=
 =?utf-8?B?Y0FnVmlDY29VYlF6ZXZBNFNnd0plcVcyU25MVVcvWElYL090bWV2TVkzcDJC?=
 =?utf-8?B?cEJocnN2MG5ocnZvVEJScXhCNW13aEtZaWFjdlNvUTNiVnp5a2tEQWFZbytH?=
 =?utf-8?B?SHZkL1lSMTJTQUxrY0dqeW1DLzRWbHh1VHZlclR6OW1mWnNsVXN4cC9jTFJB?=
 =?utf-8?B?YTRqWUxaNXJpbS9IKytmRUVJb3lUU0Z1NWoyMFRkQVVUVGFHMEVrRUVSdHZ5?=
 =?utf-8?B?WHNQUFVBUEk3cGZ3bFhDN1pab1ZXQWhwWG5PaWpJK2NwZmVOdTlWRWNiU3F2?=
 =?utf-8?B?Y0o3ZS9BSkZSdWZSZDFsV3pER3hFbTM3RWx3RkVocmtUNzdjRHFxcU9ZUGU1?=
 =?utf-8?B?WStaUjVRbmV2aHBWY2NvMldsVWhTUExXRzdMY29DbWxvTysyVE1uenh4UlYv?=
 =?utf-8?B?dm1GVm9za3BPdmIxQ3lQbUZmK25TbW1qSUZBaGdNVG5wT0hIZHJzN2pMakxX?=
 =?utf-8?B?RkxXNHMwN0dVNmxPZ2lSU0pLUVFRUkhEZFBMRGNscTgwZUJyWGhINFROSDZ4?=
 =?utf-8?B?ZmNCZi9YSVhaL1NmSGJ4SUlIYUNIVjQrdFc4NXBEWk1VcmF2Z2MvMG04eENi?=
 =?utf-8?Q?ASBVki5WlYhgx2ku4UZagck=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e9baa7-ab81-45d0-dd93-08d9fb684f73
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:46:07.9250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L45Y/bpAGLn4WXEVBRq9BkGN1OWrUJSuF9wbngC8coVb3pZFPi4jTv6f7AHCUKUHAotePjwXCdoFvFN9KUGsWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 2/24/22 11:52 PM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> ....
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 472445aaaf42..abde08ca23ab 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -40,6 +40,15 @@
>>   #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
>>   #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>>   
>> +#define IS_AVIC_MODE_X1(x)		(avic_get_vcpu_apic_mode(x) == AVIC_MODE_X1)
>> +#define IS_AVIC_MODE_X2(x)		(avic_get_vcpu_apic_mode(x) == AVIC_MODE_X2)
>> +
>> +enum avic_modes {
>> +	AVIC_MODE_NONE = 0,
>> +	AVIC_MODE_X1,
>> +	AVIC_MODE_X2,
>> +};
>> +
>>   /* Note:
>>    * This hash table is used to map VM_ID to a struct kvm_svm,
>>    * when handling AMD IOMMU GALOG notification to schedule in
>> @@ -50,6 +59,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>>   static u32 next_vm_id = 0;
>>   static bool next_vm_id_wrapped = 0;
>>   static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
>> +static enum avic_modes avic_mode;
>>   
>>   /*
>>    * This is a wrapper of struct amd_iommu_ir_data.
>> @@ -59,6 +69,15 @@ struct amd_svm_iommu_ir {
>>   	void *data;		/* Storing pointer to struct amd_ir_data */
>>   };
>>   
>> +static inline enum avic_modes avic_get_vcpu_apic_mode(struct vcpu_svm *svm)
>> +{
>> +	if (svm->vmcb->control.int_ctl & X2APIC_MODE_MASK)
>> +		return AVIC_MODE_X2;
>> +	else if (svm->vmcb->control.int_ctl & AVIC_ENABLE_MASK)
>> +		return AVIC_MODE_X1;
>> +	else
>> +		return AVIC_MODE_NONE;
>> +}
> I a bit don't like it.
> 
> By definition if a vCPU has x2apic, it will use x2avic and if it is in
> xapic mode it will use plain avic, unless avic is inhibited,
> which will also be the case when vCPU is in x2apic mode but hardware
> doesn't support x2avic.
> 
> But I might have beeing mistaken here - anyway this function should
> be added when it is used so it will be clear how and why it is needed.

I will remove this part.

>>   
>>   /* Note:
>>    * This function is called from IOMMU driver to notify
>> @@ -1016,3 +1035,28 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>>   
>>   	put_cpu();
>>   }
>> +
>> +/*
>> + * Note:
>> + * - The module param avic enable both xAPIC and x2APIC mode.
>> + * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
>> + * - The mode can be switched at run-time.
>> + */
>> +bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
>> +{
>> +	if (!npt_enabled)
>> +		return false;
>> +
>> +	if (boot_cpu_has(X86_FEATURE_AVIC)) {
>> +		avic_mode = AVIC_MODE_X1;
>> +		pr_info("AVIC enabled\n");
>> +	}
>> +
>> +	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
>> +		avic_mode = AVIC_MODE_X2;
>> +		pr_info("x2AVIC enabled\n");
>> +	}
>> +
>> +	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> If AVIC is not enabled, I guess no need to register GA log notifier?

GA log is only used when AVIC is enabled. I'll restore the AVIC-enabled check.

Regards,
Suravee
