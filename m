Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7451B6E8
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 06:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiEEEKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 00:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiEEEKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 00:10:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05B54831F;
        Wed,  4 May 2022 21:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONZ6nYXSUsPRZKhYyb1smZfm+dLl7frSNn/ef0BBmvZ4YzvUl4+X2eSM57IgtoroykrioyJX8bjztUzvJd0TvmLkp5IjtZQPSuTfTpwe8rbfNxgGJI1kPajcOBgFh1kCQYsQQorpMAEOwN30BJSGlmoW4pj3AXNqJjF6LOdJq4l1I6XIvUmcZea8k0uogQ2Yu61aqo3IhhgH/Qr0qjj8F6grlGREJfv/rqgci47wsLQfbHyA5KrS2FtAr/lMCNOe6/mKf7n2RkDGdh0LbiaX2NJPOCVF+tHdLVgCinEsQRZvhztEcl1n3pTEiYk+KgpdevQJ3CdtQGQIMjx+Ch4+Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MxiMM0WaycQ7ZtKJqp92ckOrKeuxzSVc0LceALlKUA=;
 b=j8xmpI0Vl5s/nKUDw10AvkZOKHq/lhwvr3CdTZEApHQON1iR935xg70QiY+LL4dspvg4yN1neg3bghDQvXu97ZnXWWV6htFdDc6sBF8ZnvqQ06uD8zArwG8kuDt8e+UyLMNoZNRP4wq8QacZ1rhbGgDDPdSBJ7B7UDKIEUKPIYdBOQXb5E9p1DamHuGSEDZL5ivo2HbxLrpaESHZ1JVaDj2exhSqTeDVOcJo8US5xgYl0DEbMsuKPsM2HfheW08i9s+RldfjMSbO1Z8w8Du0H99Le0WyKfnPkcWEaQf2o9wNtuL5nLE/N0ROMHjyfV/K3zggF0mDOeqIU0SNwtnJSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MxiMM0WaycQ7ZtKJqp92ckOrKeuxzSVc0LceALlKUA=;
 b=S0KVOqjn4fur65kPBqulr6A9MiCGj5t4AmjnkOBx83TvHtfQUafnH2XtMgZjd+JWGzYJ5MjQLnjafaw6oFMIPrlg5Pbz82XPSj4og9SLWgpgSJgXmyc9MAL16o356QKb2zyUMcpyxvGJIknyBT4U+sGvZ9Nb9Y88MV6VgX6XtSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB3754.namprd12.prod.outlook.com (2603:10b6:5:1c4::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Thu, 5 May 2022 04:07:13 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5206.024; Thu, 5 May 2022
 04:07:13 +0000
Message-ID: <3af75c05-40e9-2371-b5a9-c702853a974e@amd.com>
Date:   Thu, 5 May 2022 11:07:02 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 03/14] KVM: SVM: Detect X2APIC virtualization (x2AVIC)
 support
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
 <20220504073128.12031-4-suravee.suthikulpanit@amd.com>
 <a883ff438d6202f2dc0458dc4d7c1ab3688f5db8.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <a883ff438d6202f2dc0458dc4d7c1ab3688f5db8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0017.APCP153.PROD.OUTLOOK.COM (2603:1096::27) To
 DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5a62c06-ff4c-41b1-6240-08da2e4cbbb3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3754:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3754C1DA37319ACF7401E717F3C29@DM6PR12MB3754.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vr/cTFZHOvmghpbRU+GUlg3+kG82Snf3flO12jtFe5Z6d56oOxwn0Sc58pA32ztU+HyblwokKHTg3UPyLQZu2BElW0x/SiiBU2g8kZL/KdKvbE6Xl8bjeX68sDYDdoE5MIe6s6ylWLTqOUQL6lcjC+/nKiD8V80K4D29t3PHozGUjlky6YiIHUV2Qi9iTuLMFY3aHqWXhaDpq5dV3n04g5ECPZXNK5rg4mWPHUUv7WfodUCN8QS6OZr3UdFJNJNvlpeqDNLeC7D46NnYqm0sqOY5PC7PpgzJMlMQUpn7YDRsBytoJ6Uck1OjPCMc19q7H4FsNRN47ud8E2LQD0LBcV9vxqLaqL8g38UVliSNy5FmYyM7e6bI7I8Kd+06+2m4v5ivq84lHmZ4es3L1P/rLK/gr5pHk39pfjm33dRaPhw597AianoM6sRmHFkTiW5SaZGHUQ++gU3nW+IY8iSrzbJQe81h7UIiPaOFVASC19gpm/DGWpmG8NAPpqwaaIZn+MJEFJdwApYzCHUiBo4YB7pxF63P+21bDOmL8LU0mrxKeRFfujoArPu21jFB84Katd/0+PN9puN8FDgBvt9qtBPjHS+8kmHLUHQ97ZvY4eBRIeDerfhWRZhxxTkXcPlwzIo5npH7gMi4cR4KH2kJ131JCQ1k4IAMOaUG1VlTTC0pr+9E3zk2a3hnw67BTvjYKabznJWe489LwC76Rw412zLJPWAees8Sc3D8KFqnk6/OS0bXCn7kOeUN96FLtAFd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(6512007)(6506007)(83380400001)(53546011)(186003)(86362001)(8936002)(4326008)(66476007)(66556008)(66946007)(8676002)(508600001)(316002)(2906002)(5660300002)(6486002)(6666004)(44832011)(38100700002)(31696002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azhzQVJvTk1QYXpUeEY1VytWbEhUUkNCZWF2Nyt2WXdkeUkrVkxrOCtnQ0Uw?=
 =?utf-8?B?SGM4VURCM2dadkx2aWpwaGVnMGZvR1ZtNkRmYmxjNlZMUDRBZE1vNy9MOE51?=
 =?utf-8?B?ZGtQMTVIQysxelFUcDhxTzM1bGxYVy9WcmxjWFpOWWxtRndmYnY5Uktabm9T?=
 =?utf-8?B?dTFWUHNhMlpmaE9NWGpUY2VBYmkxd1krWUp3ZUh3bGx3MzA0amtFRzZmeC9a?=
 =?utf-8?B?cU9td3FFSFNMS2s3SDk3aHhzRUc3aThBZ0pleUdMVWlLbkN2VnhacW9EbXor?=
 =?utf-8?B?Z1F0c3IwME8zZysrQzQ3cmVXdE9qRzd3ZGx3UUFWVUY1RlBXUGpudGcvcHU0?=
 =?utf-8?B?QXQxRE03MHNmNmRPNWl1aktDTk5mUTZGd1ZBTVdnM1cxbUJNRHJyQ296VFNP?=
 =?utf-8?B?RExiY1RoNTlvcGJNK0djRnY5YmJCeXM1TEE2TnJxc0VEZlFTSlN0R3Zlc3Jy?=
 =?utf-8?B?WVZTV3huZE5BYldNSW5QQnNUT2FkZEhrLzhNanhBb0FUYjBLRWNuUEwwK2Mx?=
 =?utf-8?B?dTNiS0prd2wwdUs0Q05rVWNReEk0NjBDR0tYK3dEOG5UdTB2b1A5THRTdktJ?=
 =?utf-8?B?c09ESk9xbEVTMkJUWWpjbzZCMDdjWW5iRUxMZmdDNHlRVDROWFR2Y0dQUVZS?=
 =?utf-8?B?Ry9WSDRkMTJ5bnZ0ZktSb0ZNR3NuNFQ1ZDVjc1RqS2ZTajczTXFPY2VhYmho?=
 =?utf-8?B?SnpzNklqSmtIeS9LN0xSVmZJQUY1T0VuV0w2VXVVR3BvWWlVN3BRaUt3dE9O?=
 =?utf-8?B?emtIRytBOU5aUXM3NWpCR0hrQ0FWejBEQzRZTVVkT2lpQ0loRlI0ZXcrMTBM?=
 =?utf-8?B?N0g1QmU0ZXZzV3FUUlh3cXo1d093WVUvYW5Md0pleTMydWFpVUFkYW92akxG?=
 =?utf-8?B?cWlSV1d5NXBLNmZOenVidTA5RlBQempNeXhIcURpVXZzMm16c0tQVmtGb0dW?=
 =?utf-8?B?MTdReE1ZUVl6a1ZBNkJpLzdOckJtS0hYTFlSc3NPRjAyMTVWTnRXMStCUHNj?=
 =?utf-8?B?OExMaGllZXNnQnlROFNDdGlQMUhHbXROYnFDLzNIelZLQVFobFBUZUhmRVBh?=
 =?utf-8?B?dlhWWHIrTUhFOXhGcVprREVUK1JNZmlPaEVra3NuK2pkUWhSUHpWazlTQlY1?=
 =?utf-8?B?QUEvL3hjUld0V0cvZ2JhaElXY2JEdFJadjY3WW02VUw0NXBQd1VZZ3lkZTNz?=
 =?utf-8?B?QXBhekdUbVZURDBSaHFQSzFrUFU2RHhUSmZlRDNSQ0dmNGlDK1FibEt0V0xE?=
 =?utf-8?B?YnN4R0hLb3dxem1peXpWUGhlT1p0Z25UODAxV1k5QVFPZkFXWXR1NVlKREIz?=
 =?utf-8?B?Q3JVTjNURkJFYndBdFRpeW1yckY5anMxNXllRXNhNTA5Q05KeHQrT0YvWnEx?=
 =?utf-8?B?bnVGZFhTSzMycFFxTlhFR1pQdjM2bEVSWEs4b2xLckZuSDVCSXRiVkNIb0JC?=
 =?utf-8?B?Z2dya2c2Y2JIeUxLQXN3Ri93eEV4aUxid1ppNEovWGVUKzRiOVZJR3dWejZ1?=
 =?utf-8?B?L2pySHlEQXNDRDZhODZwTGN6UTF3Z1BPNWsvM3E1Um80c294WVZJY0ZGeEU0?=
 =?utf-8?B?N0h6R3hiU05PSkkyZ0dTZk5iemQ0NnpTKzIyUHQwU1ZhMnNIZFh1bVFHSjVO?=
 =?utf-8?B?MlNKZFlMSlJnSEZ5bEs4djgxZWRDRG52dEdIZDA2Yy9KSDRyYXlPYUlaaGVq?=
 =?utf-8?B?T1B5S01IcG1yVU9iNlNHdWJEQStXc0szS0NyZEVDVEh4c2VObDdpdDJPZnB1?=
 =?utf-8?B?RDE1endxSHRGQm9NUUdEb2Z5dWs0NGhnaTRKMmtpZFFDN1M3ZkQ0M0x5aVRB?=
 =?utf-8?B?dlBvL3VmamIrREkydDE5WE0wZHBCc0tmenRaOTkzaXpXMU10bHJYNm11amxM?=
 =?utf-8?B?Um5HZXpjQWFLT0pBb1RpVEVqa1BsdzhLYzFyTWRIN040MEIxUEM1akRJZ204?=
 =?utf-8?B?c3Z2NGhjYlpzWkJRb0l5bUh3S2xNeFg1S2FQSndBcDlnc0FLTTlRYUhCb2pG?=
 =?utf-8?B?Vm5JeGVHd2FvR1BIc2crVmNFdjI0ZitFL2hXdHQwREZ2WEY3S0dvWWdqYWFU?=
 =?utf-8?B?M3Z0Yk9ML1MraFlrSzVheTJ6U1lFK2kyd0RkL2ROMVNDbzVtM24wZTh5Wk1h?=
 =?utf-8?B?T0tNNjMzQWtnS1p3aEh6dkM3Yjg2YXI2cjdMbFVwRSsrVzVIam1hblRtaXFG?=
 =?utf-8?B?QWwwNXA0M2NJdVN3R0NvTTVFSDZqVENIZXlCdDR2bk5wbVA2NEk0M1FQeXZq?=
 =?utf-8?B?UlBaVFpRQU1yV1FZb1BGSjUyc0ZyTk9IeE5DU1FHVFdENHZCNTNKUmlhbk90?=
 =?utf-8?B?bTM0MW5EVVZ4MEFLREJpaHlOREZGQWo0UjhMeFhQY2RBU2Y5aUI0Mjc0YjFV?=
 =?utf-8?Q?23TJZIzfbbGM4Mb7F27PuJgK0UO/HFeLKA6rGwcZvx4wg?=
X-MS-Exchange-AntiSpam-MessageData-1: i+sG8qRokllE3w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a62c06-ff4c-41b1-6240-08da2e4cbbb3
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 04:07:12.9708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pARj5nWweUPmj44YSzOf+tvWiAY9O6WTR4HAfuWfLvqdmDa5YeMbmdUvCLo/HPML2omHVFC3AQNgmjPTfc1KUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3754
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 5/4/22 7:12 PM, Maxim Levitsky wrote:
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index a8f514212b87..fc3ba6071482 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -40,6 +40,15 @@
>>   #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
>>   #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>>   
>> +enum avic_modes {
>> +	AVIC_MODE_NONE = 0,
>> +	AVIC_MODE_X1,
>> +	AVIC_MODE_X2,
>> +};
>> +
>> +static bool force_avic;
>> +module_param_unsafe(force_avic, bool, 0444);
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
>> @@ -1077,3 +1087,33 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>>   
>>   	avic_vcpu_load(vcpu);
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
>> +	} else if (force_avic) {
>> +		pr_warn("AVIC is not supported in CPUID but force enabled");
>> +		pr_warn("Your system might crash and burn");
> I think in this case avic_mode should also be set to AVIC_MODE_X1
> (Hopefully this won't be needed for systems that have x2avic enabled)

You are right. My appology :(

Actually, x2AVIC depends on both CPUID bits (i.e. X86_FEATURE_AVIC and X86_FEATURE_X2AVIC).
If the force_avic option is only applicable to only the X86_FEATURE_AVIC bit, we would
need to check for the following condition before enabling x2AVIC support in the driver:

   if ((X86_FEATURE_AVIC | avic_force) & X86_FEATURE_X2AVIC)
	avic_mode = AVIC_MODE_X2

Regards,
Suravee


