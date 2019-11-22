Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974A01079F6
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 22:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKVV2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 16:28:09 -0500
Received: from mail-eopbgr750071.outbound.protection.outlook.com ([40.107.75.71]:14512
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbfKVV2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 16:28:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9eRF7+a7v4SwpD+xA41fpSM7bagOb1QaViwLvCGPY/P38wTAyNxrnJ78VaawVqYWaBULS+zJO/Ndnebl5IBR6x83N/7YsdS8cYcaT/gEe5Kwjg/bnPa2ynrnguQom7JBme7ASzE8rniFXFN2toE5+hPC2OWBlRGgsojSUy6jvGga/ORNuXDl76Lz6zS2e4ViU3hWk0LAE9Fu63pHfKs0AGVBgfaXR3G4zqIaOWdf81n0Hx7YFUdIlu1yk6YKwPSHagCgabqQRkpjL+nqB6uhfSQYrPDyhEek/29zDW5a5thDdnC44s8wPWURwj705hrdOC6Z4+rx9n4Tw3L5af5kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6P8ktXxvleh0WeXv9SVE62kYpGSs17SbWD3R/HqAOI=;
 b=M3FAli+68W/r3NJm5G7WsbKa3ma3l09NBLNnOkpnGY3DiuOOF92G175Rb/kt41522yfXvIM80SeG3yfpYvHjInsj6jq8QfE5WU+L/Hs9EDK4mBlJsqOWrkSlZ/vcgGrf6fIKmfg9gUvJQasQqwi8VbMuyWBPUHUJrBwxjrbQvfzICGwg1FOtNsEaq70NEcWBGxqXVecCCy4kZPERXP5H5537TZVDLY5oIiC+rPdN63CXRPLYpZ8LhKhSp0esE+b4G+B75fxcCN0OUTFjMGjaQCkowceXeBc+ia5bdxqW73R31hRWGmpk4HEj1miJZHift1L9WNNcMauTM3A8eE7eFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6P8ktXxvleh0WeXv9SVE62kYpGSs17SbWD3R/HqAOI=;
 b=NiqGjdkhZ2Cz9f6mtCmnOOLH+5+Ks+UvvbmVHQHMDV7oKJOL6ecFmlEWZBFbxC+4hPyChSA8O++PX9QFwCY7aMAjaFrO9kbpx/4y1Htq00KIhNzq9/l32LuazvHGJn6hKLZEaej+bjlcEHqfhc0YxUHP+dGYe5UW72BJJCspBOM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB2636.namprd12.prod.outlook.com (20.176.116.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Fri, 22 Nov 2019 21:28:05 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:28:05 +0000
Cc:     brijesh.singh@amd.com, Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Jim Mattson <jmattson@google.com>
References: <20191121203344.156835-1-pgonda@google.com>
 <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
 <CALMp9eRVNDvy65AFDz=KjUT0M0rCtgCECuMS0nUZqAhy2S=MsA@mail.gmail.com>
 <CAMkAt6paein2dHHD-wZ8Eke4tUb_8GNuiH_3-RHkiBHx=jjwUg@mail.gmail.com>
 <c423d85d-b7d4-7f1c-0b5b-d3f62b35b6da@amd.com>
 <CALMp9eTL=j_c7HYhp2rX+1w-SKXa1zr+wAJM=GAnJjKFtuYt-Q@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <64a08d60-ba65-a5a6-07f7-d26cd6d0ed9e@amd.com>
Date:   Fri, 22 Nov 2019 15:28:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CALMp9eTL=j_c7HYhp2rX+1w-SKXa1zr+wAJM=GAnJjKFtuYt-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:805:f2::30) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78d6c68f-1f54-448c-6a40-08d76f92dc7b
X-MS-TrafficTypeDiagnostic: DM6PR12MB2636:|DM6PR12MB2636:
X-MS-Exchange-PUrlCount: 1
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2636F5310608918E89299A53E5490@DM6PR12MB2636.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 02296943FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(186003)(26005)(31696002)(53546011)(6506007)(44832011)(386003)(446003)(86362001)(11346002)(6916009)(2486003)(36756003)(2616005)(45080400002)(5660300002)(52116002)(7736002)(14454004)(76176011)(305945005)(23676004)(66946007)(14444005)(478600001)(66556008)(966005)(66476007)(25786009)(81156014)(230700001)(6436002)(8936002)(6486002)(99286004)(316002)(8676002)(54906003)(58126008)(31686004)(65956001)(6512007)(6246003)(50466002)(4326008)(6306002)(66066001)(65806001)(2906002)(229853002)(81166006)(3846002)(47776003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2636;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkoeBZI14RJxQ7mbiZe9VnC/83E6RmHTdPfSzHlI43+No9ni/O2Sj9unZB3ZkaTC23uGOgUpv0NGcXBLVuE4fiK7IN7gltM0I9KBmQehNoYh1cLg5f3KLFmoLj0QwXRgFAAUMCeFcuAoF6wwuK/r4VAC+3zHkeciXPNDzFVY2PoVToJfj/iYMLzVg/Bo+8CpSGrP0oWeq23WFUjSpFVmnHoGmId5XfZ2AkuqD5tZe3s4Y0qyQmnSzFqsnXJJsVIcZpNBoWjpiyOaZpploZwmBxJy3kViqaQcXv8zJRX5Bpa8an66veI/QwhLsCHmA9boofbj/V0d1xN0DCqkLSWhFHX+hOv0V58QeBWsSNedGPbf8oZShtY2tV/1pAIeYS5OWACHnU++WyhWev/YC+wXdveEOkjkwbJZY9wpOE++EJTjtqtUeqr7D/kH46NvF3tElIKwBCQKMPTpCmGgQVrxBRk85zoJGgukFFgF7M8ngJ4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d6c68f-1f54-448c-6a40-08d76f92dc7b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2019 21:28:05.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Db47n65B+n1Dgq6V9JokXWS5zMafWoAnZbT+SBAZ8Zu8zeMKRSos17KF1Lrc/ARkUwnRMpzI8qemPtDap25bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2636
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/22/19 3:24 PM, Jim Mattson wrote:
> On Fri, Nov 22, 2019 at 1:22 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>> Ah, I missed the fact that we don't need to pass the SevES
>> bit to the guest because guest actually does not need it.
>> It just needs the SevBit to make decision whether its
>> safe to call the RDMSR for SEV_STATUS. The SEV_STATUS
>> MSR will give information which SEV feature is enabled.
> 
> Why does it have to be safe to read the SEV_STATUS MSR? We read
> nonexistent MSRs all the time.
> 

The MSR access happens very early in the boot, IIRC calling this MSR on
non AMD platform may result in #GP. If OS is not ready to handle the
#GP so early then we will have problem.



>> thanks
>>
>> On 11/22/19 1:52 PM, Peter Gonda wrote:
>>> I am not sure that the SevEs CPUID bit has the same problem as the Sev
>>> bit. It seems the reason the Sev bit was to be passed to the guest was
>>> to prevent the guest from reading the SEV MSR if it did not exist. If
>>> the guest is running with SevEs it must be also running with Sev. So
>>> the guest  can safely read the SevStatus MSR to check the SevEsEnabled
>>> bit because the Sev CPUID bit will be set.
>>>
>>> If I look at the AMD patches for ES. I see just that,
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAMDESE%2Flinux%2Fcommit%2Fc19d84b803caf8e3130b1498868d0fcafc755da7&amp;data=02%7C01%7Cbrijesh.singh%40amd.com%7C86545e99d62e4f8e8eb508d76f92720c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637100547082927245&amp;sdata=5YsknSUmboS95T0OfLWvJ%2BcOQQk5sIllGfshNqf0j6Y%3D&amp;reserved=0,
>>> it doesn't look for the SevEs CPUID bit.
>>>
>>> } else {
>>>     /* For SEV, check the SEV MSR */
>>>     msr = __rdmsr(MSR_AMD64_SEV);
>>>     if (!(msr & MSR_AMD64_SEV_ENABLED))
>>>       return;
>>>     /* SEV state cannot be controlled by a command line option */
>>>     sme_me_mask = me_mask;
>>>     sme_me_status |= SEV_ACTIVE;
>>>     physical_mask &= ~sme_me_mask;
>>> +
>>> +  if (!(msr & MSR_AMD64_SEV_ES_ENABLED))
>>> +    return;
>>> +
>>> +  sme_me_status |= SEV_ES_ACTIVE;
>>>     return;
>>> }
>>>
>>> }
>>>
>>>
>>> On Fri, Nov 22, 2019 at 9:18 AM Jim Mattson <jmattson@google.com> wrote:
>>>>
>>>> Does SEV-ES indicate that SEV-ES guests are supported, or that the
>>>> current (v)CPU is running with SEV-ES enabled, or both?
>>>>
>>>> On Fri, Nov 22, 2019 at 5:01 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>>>>
>>>>>
>>>>> On 11/21/19 2:33 PM, Peter Gonda wrote:
>>>>>> Only pass through guest relevant CPUID information: Cbit location and
>>>>>> SEV bit. The kernel does not support nested SEV guests so the other data
>>>>>> in this CPUID leaf is unneeded by the guest.
>>>>>>
>>>>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>>>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>>>>> ---
>>>>>>    arch/x86/kvm/cpuid.c | 8 +++++++-
>>>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>>>> index 946fa9cb9dd6..6439fb1dbe76 100644
>>>>>> --- a/arch/x86/kvm/cpuid.c
>>>>>> +++ b/arch/x86/kvm/cpuid.c
>>>>>> @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>>>>>                 break;
>>>>>>         /* Support memory encryption cpuid if host supports it */
>>>>>>         case 0x8000001F:
>>>>>> -             if (!boot_cpu_has(X86_FEATURE_SEV))
>>>>>> +             if (boot_cpu_has(X86_FEATURE_SEV)) {
>>>>>> +                     /* Expose only SEV bit and CBit location */
>>>>>> +                     entry->eax &= F(SEV);
>>>>>
>>>>>
>>>>> I know SEV-ES patches are not accepted yet, but can I ask to pass the
>>>>> SEV-ES bit in eax?
>>>>>
>>>>>
>>>>>> +                     entry->ebx &= GENMASK(5, 0);
>>>>>> +                     entry->edx = entry->ecx = 0;
>>>>>> +             } else {
>>>>>>                         entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>>>> +             }
>>>>>>                 break;
>>>>>>         /*Add support for Centaur's CPUID instruction*/
>>>>>>         case 0xC0000000:
