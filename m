Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BA15A0E8D
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 12:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240931AbiHYK4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 06:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiHYK4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 06:56:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB23BA61FA;
        Thu, 25 Aug 2022 03:56:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxBuDWJkjhXu3rZaPJ815fpw+RXv+GoFTAbGCkslBXkzf6vpNnGCsPoQMEUGKKyO489OgxaCKPmp0X2PAeGASU1pyQ8hU8fUyHN36f5YicE9w8C7VPGHAcF3CkkqZK1ATLNm+BD3dAvHWI8W3Gvh4bMUycWgQiEtDnQl7LJ2payFfuLot1xQi/tJwCjoifhHYjBP1p/MI5cvIYFf4uAjy2gqejDBWAgS0s4Z23aTYTUr9KPqgCKU8VFupnBy2mF4Q9AypJacCM0GYA85geamKgFq/TcRDWXkWvifkbKYRhFvzy2k6IwpMADLZUUJn582bGIV+YCnnH4wEQmzYa77Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSoXCIx2XIvMmPkyVyclr1qyIyOfdJr3/Mbtbccmu2M=;
 b=gw+Yb4/V1QezYqO4Onz+7T59qcDHv1AIDWl1Oq5wqD2b/WU3Pb71rk+9tU2q4uoU2umZvNy5aacP7LvaPVmVFVGCZnOWMbk/b6e9UnPlLWYbSBa0Rw6OF09eBIPhmNdVDnOLU8yek3Re6/OaCXh6t0sUdw3h98IwgGt0EgRiKffWoZ3xwJDpkpL7BBY/CC3ciawIq4ozgQIpKGboo7rAkU6DIXjgR/BUuVKxvVPsSeeFqRQrBYnIdbiJDBVjImkpumrPrlHUauoh6ydyZ1MhmvrwQHId3Ve2aQCQCsdG/bfhuKLINWBHy8v3yuStrmAUEG1/r+4AR1TLFT7/ERVTuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSoXCIx2XIvMmPkyVyclr1qyIyOfdJr3/Mbtbccmu2M=;
 b=GXqxlnaw7Wgkr7c4Ieg1TEI4uXlUTP0agvaEFejMgZpkRL/3mSANnQiRyc2onfS2cp0Giwefzc1WiHpmul6RxcTJ+nnsE9kYRmAP9nUq36mf7EqiOMPEdmFX8aG5GcxQ5xW2BFtpL/+LGaJaIgniKWL1bLx5FriyDYihhVm4RoI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BN6PR1201MB2515.namprd12.prod.outlook.com (2603:10b6:404:a7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Thu, 25 Aug
 2022 10:56:27 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 10:56:27 +0000
Message-ID: <1062bf85-0d44-011b-2377-d6be1485ce65@amd.com>
Date:   Thu, 25 Aug 2022 16:26:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        "Shukla, Santosh" <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com
References: <20220810061226.1286-1-santosh.shukla@amd.com>
 <20220810061226.1286-6-santosh.shukla@amd.com>
 <bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name>
 <e10b3de6-2df0-1339-4574-8477a924b78e@amd.com>
 <f96b867f-4c32-4950-8508-234fe2cda7b9@maciej.szmigiero.name>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <f96b867f-4c32-4950-8508-234fe2cda7b9@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::13) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93dec456-fb78-4dc9-dec4-08da8688759c
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2515:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dcsqquwAwu9XhGKC4JmqgrEkNqPpTGlQLz+cWISpVYVt0i6jyYX5nmTNNVQsdZe7dr6UqkjWfOM89ltHczBuaJMq5Mhfp1Bvew7t5SJX9t9iBKY3e6EU2v0AyKhX86jatqQfTANTfZvJ450mzSskJEcq6mEgpJdQyXAdQjeijiOkBtW6RswWqwoiLl/PLjGOX3JPLmOEM/bNm1Ekng5oWcSwSb9eoe2pLusIvlyq9kVUyzFKyNER16jw9f+AjGXupDazs0lYwUZqZ4Zg/MtS9PsVWexmn8fx3rcwx5lsCtgSb+Vgbz4vlRYYKjlk7Ykt89uwMfJC8YJ6tCXZT2mtpKth/fSRZ/lTgBL5mwWyDIDD1ZgvMFJxgWBpH8ChjEvGHY+Yw7zJxH7uPdms9xiiOCDOU56AO70OTSWml/4tMdrxegiucLp74QCDPdk4TuUywFQMd+JNWY4hdyJPtX0xzibTF6/OVd3MsDfGo3HM45+zgSD8TIS+agmWZOjjXLnvDCEoVCqFdzmyHQWWD9RSsgmKUrA0kidXdfUGjqCaPlUwhLSybBAOKSKgo8Nly0RSXlk3kXxo5rOKXC1C/FjLD4u9XOgo4xHevkj1PUc9SU2ANsqwo3O+OuPhSblJ/+zvG4pk1t/OeTF15PCZZCXPoU6VjWkRXa/mhJ7KeJ8AJA89tEqAZBEsG9E8eiZ18AxWvwG6vUS6gkyONHhvdI6/ZGOACQHFLBBrcE8m4I6/lsBiTbgnVIuPl7LQWcN0oFEIo4ByyJ6cNds2qFrB9bDsc98O82Y8kXHHo0fXWFifk9E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(6506007)(66476007)(66946007)(4326008)(31696002)(110136005)(54906003)(8676002)(86362001)(316002)(83380400001)(66556008)(186003)(38100700002)(478600001)(2616005)(26005)(6486002)(53546011)(6512007)(6666004)(41300700001)(31686004)(2906002)(5660300002)(36756003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGo4NjMxdnZhMDFKNHY4b09tdng3UWVKcExSWmVUSEVlR2lEUHQyWUZsa09z?=
 =?utf-8?B?Z2NROElUR2tvTzdqSnVVNTJBcTA3R2N4T3NKQzFIM1RleEJOVmFsRXI4WnVW?=
 =?utf-8?B?K25VcHhwWDVCTzRqck1GT3lpRGdockdFV1UxM3hsNEZ6M0d4OUdkRnJyQTJr?=
 =?utf-8?B?MTRKWFk5Y3NUd3h3MzVhNzJMU2hoaFk1S3dLakRYcmh4bDRwQjB0Y2o2UnFk?=
 =?utf-8?B?SkQrdFk0Y01Kd1o4OTIrZ2dvNWlLZGFIRU5vYXhBQzUvdGpUcTRlVWREaUVU?=
 =?utf-8?B?QTJLNmRLY3VKdEM2Z3dyMk5RSTkzaEoydjAxcGRUbXZscDFSK2t0dlpLbzdk?=
 =?utf-8?B?QWVjM1RwK0lOSlJNU1BLWlZSaXd5QjJxSjFvVjV4OEs4VVZHMVVOUDRXTUtx?=
 =?utf-8?B?ak1XR3BhWXRjaS9YU0gyWFJzNGtDVWV1M0p4anJKNUxaRzRhd3VEMjNsY082?=
 =?utf-8?B?dk1nVWZPYjVod1hQRFF4SXBndWs4Ukd4b0ZiaVh2Z2F2WC96YXZQUGN5M0pV?=
 =?utf-8?B?b1lmTmpmUTI3c2VlcGxKOXh1SG92M0NQMW0rbGdFWVlOaTJnc3VtVk5Ocmg5?=
 =?utf-8?B?ZG5HQ3htUGRaOUpOT016SkV1Z09DSXRHK1NzMExiSXFrM2FpTUl6SkFkTHlT?=
 =?utf-8?B?YkUwMDgrSEgyQ3lWUXpQVkVqYUN5Q2REcUI4eVVvSS9Kb1JoS09rTDNwWmZa?=
 =?utf-8?B?eldqeWp4OHRrVkFlYk9PUThFODVuYklkdUFOSk9WK2tFeXFMYlY0RzJwOElo?=
 =?utf-8?B?Z1EvbTRwa0hGZy9iNWMzQ3VIMHhHM1QrcmgremRoc3BtUVlwMVpSZ2FvWEdl?=
 =?utf-8?B?ZHJNc0tQZ2oxZ1pPak92SktMVkFWMDF2ajBhVW8rdS9BMXozWHJ2UzNGZFUr?=
 =?utf-8?B?ME5nTHVLUjQrRit6TGRVZ0V4UTNXRGtIY1NnNEptMk5BZlhoVkw5YXlwR2lN?=
 =?utf-8?B?eXV2by9pMElZRFlGbWthQkVhTW5nU0lWWjYyL0gxckYvbXNIT0JBdytRRG1Y?=
 =?utf-8?B?cklmVGR5azRwQ3Z4RTdVMllNVmY5RDh1dmF3VG1qQVR0MXpuTE9Vd1h2dGtB?=
 =?utf-8?B?N0NGRVRGajA0Zm1xNmNaZEt1ZHYvemx1elR6TTlEWGJVWm8rRW1GR0pSZWNS?=
 =?utf-8?B?dGxvdysvU0lPclUwMURJSTFpSjVCemw4T2dEK2dYZEFXSzd2eHNlWXNWaUUw?=
 =?utf-8?B?eGdQSWExNEc4ak1vVXF0WW1BRi85aU5KbE9VRGpFb0NxVzYvQ1Nlb3RhREho?=
 =?utf-8?B?cmR1YVFwWXlkSHBGQmRWeDZGdm1pSElUWmFpRDlVUWtEVjg5YWJMaytBN0tR?=
 =?utf-8?B?NTZNSHBMM201YldSRnhiZzJvOWJ2dU1nS0IrTk5mckpGTFZzbTA2djhpTW1M?=
 =?utf-8?B?cEgwSXpDYWdLUUpoWC82UnZtR2JvRFpRK0pPekhpa01LVjEwWUpMOGZXQ1ox?=
 =?utf-8?B?L0NrOXNiUEZndnozdXI5azRiNFQ4SVREVEZCTmdrL0x2azJvdm9jcm5CUndC?=
 =?utf-8?B?RnB6amVKS3dVNHZCcUNlRXZvNkNKMDhMemp0RjhOc050VG53SVlyU2pGdURz?=
 =?utf-8?B?SFR5T2laR0lvamZsQVpGV091dDBHdmo0LzQvcmdmMThlVFowdGRESCtMRENJ?=
 =?utf-8?B?WFlhM0VkVFdnME5CdjVOS3dIaG9xQlBxbFRIemMwT2tlclBtSEVCZkFMZC9G?=
 =?utf-8?B?K0EvOTh2VkwrQ0swQ3FTU2pPVDJFYUZDbzhqaXBHMGpQU2JudFJTR21TYVUr?=
 =?utf-8?B?RXkwLzd1aFJvajhhZlN0aThzT2pnK0QzVG9reVZNMTVXQVRRZFh6ckFKem0x?=
 =?utf-8?B?ZTR6WHBCdHY0ekVoTklFMFZqOXpOL2xOUEp5Um9SRHBBNDRvRkI3Rms2SWFn?=
 =?utf-8?B?a2NrTjcyUXhpeHJyMSs3TXVxY29maGdCNjU2dks2WFVVNWFnM3VBaFFHc0hp?=
 =?utf-8?B?djBRMUR4TUM4NEZhRFlaZCt0SS9BYjJ2Tk1jQ0pHSFo2V1Bhb25XK0NnRGlz?=
 =?utf-8?B?cDlMR1lsZFhyelNLQ3FJTjdLc0hsQzNXYWdyamJoeTdUQUdCd0lPQ2tYbUZY?=
 =?utf-8?B?ZzR0dTYwK0lJRHN0WDFxNmhhdUxpNjdOenlHaVJNN3FTV1RYYWVxMXA3ZkhL?=
 =?utf-8?Q?DLCM8j70N5fVGXtvYQCfnDWbj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93dec456-fb78-4dc9-dec4-08da8688759c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 10:56:27.6684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3JHVKa7MOeW387EMHMIxbHbbmnsmo9KVors1g6VRC9nF8hUsH1d580iGXAi07mJ46pAvq5fkhetSN7tTs2/g6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2515
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/2022 6:26 PM, Maciej S. Szmigiero wrote:
> On 24.08.2022 14:13, Shukla, Santosh wrote:
>> Hi Maciej,
>>
>> On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
>>> On 10.08.2022 08:12, Santosh Shukla wrote:
>>>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>>>> will clear V_NMI to acknowledge processing has started and will keep the
>>>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>>>
>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>> ---
>>>> v3:
>>>> - Removed WARN_ON check.
>>>>
>>>> v2:
>>>> - Added WARN_ON check for vnmi pending.
>>>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>>>
>>>>    arch/x86/kvm/svm/svm.c | 7 +++++++
>>>>    1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index e260e8cb0c81..8c4098b8a63e 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>>>    static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>>    {
>>>>        struct vcpu_svm *svm = to_svm(vcpu);
>>>> +    struct vmcb *vmcb = NULL;
>>>>    +    if (is_vnmi_enabled(svm)) {
>>>
>>> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
>>> since if nmi_l1_to_l2 is true then the NMI to be injected originally
>>> comes from L1's VMCB12 EVENTINJ field.
>>>
>>
>> Not sure if I understood the case fully.. so trying to sketch scenario here -
>> if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
>> be one of following case -
>> 1) L0 (vnmi enabled) and L1 (vnmi disabled)
> 
> As far as I can see in this case:
> is_vnmi_enabled() returns whether VMCB02's int_ctl has V_NMI_ENABLE bit set.
> 

For L1 with vnmi disabled case - is_vnmi_enabled()->get_vnmi_vmcb() will return false so the
execution path will opt EVTINJ model for re-injection.

Thanks,
Santosh

> This field in VMCB02 comes from nested_vmcb02_prepare_control() which
> in the !nested_vnmi_enabled() case (L1 is not using vNMI) copies these bits
> from VMCB01:
>> int_ctl_vmcb01_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
> 
> So in this case (L0 uses vNMI) V_NMI_ENABLE will be set in VMCB01, right?
> 
> This bit will then be copied to VMCB02 so re-injection will attempt to use
> vNMI instead of EVTINJ.
> 
>> 2) L0 & L1 both vnmi disabled.
> 
> This case is ok.
> 
>>
>> In both cases the vnmi check will fail for L1 and execution path
>> will fall back to default - right?
>>
>> Thanks,
>> Santosh
> 
> Thanks,
> Maciej

