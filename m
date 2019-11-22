Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8011079EA
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 22:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKVVW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 16:22:27 -0500
Received: from mail-eopbgr820085.outbound.protection.outlook.com ([40.107.82.85]:27584
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVVW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 16:22:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4H3+WLgKeolloxL6zNfyWtHYekCpn+8eI83HlVN6eDX1AveH2niMui0QUZ39Dmao2hE34s09ncYSheSQ960rXmAtPTRInTuc23973j4ORXPK4GF6Me/Japaw22bKNH1ST71lgl8qcI0zIqvaGr36Qkiduce/zFNu0CgyQ3IVBFOFqYjMQmwph2t3XENplvr4mPZTYzP11jOtf49kfIE2sf3LmSr4kMtSlG45P2q3EZwQbCB4DVkOCXYQSv7UNcq1sIph+4cwZPPhhJM5LaR2wvoMMFIouz+NZ4YSLew1BsS2/SX0owMZ8ziJV2hq9OdP/eTzJONr45HP1brkhFYHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRdFUu9FjuYWV99EPUWtDWPQvetk8uAx2in55LnsBvU=;
 b=QUzUFhI6ZpXdUFbK/QctogVyetAZbHwrBjlhxJRZeLNgV4hytGQBUwbUqy3nqtLCQVHpngiEOzv0g5HwxKB90zJTAachVgFkc7lYSlZi0GDWnZ1vHyY2MBdh2IPcwz/bCqWGJxhxsXgf8xUviLQF+OWFcUrjInLMR8xVYnzIITkr3pA/BGLftuFS7vhd0TxIltBG25l1LJO7fXPBoBA0kaleo9OOaaO2YBUpdQInKcl50TZcuFPszA4W2YOyiVnd3RIhhLwCC2bjRqGO8UMeTMhswPki/mBUfJj5WQab1Mb7kNCH/YAodfRtcNEEK/QnYpcmQdP9ZXM2m8gPoaqbTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRdFUu9FjuYWV99EPUWtDWPQvetk8uAx2in55LnsBvU=;
 b=Fghvy5I0wWWq81cSMjrpRNmhHTJC0tj4VBKciItYag06n/GIBUCZ92qwSoaGl+R55rcS+QAvEQ8YO8yvwjxgXhtEw+oLL/GhxWWSyO0vTM1Th1oSofB1eEAJwiXvMXrhsj0+6cuTJL7RUWggL5crmv5fK1XrRmwaRUpchdA23mw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB4267.namprd12.prod.outlook.com (10.141.187.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Fri, 22 Nov 2019 21:22:22 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:22:22 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Peter Gonda <pgonda@google.com>, Jim Mattson <jmattson@google.com>
References: <20191121203344.156835-1-pgonda@google.com>
 <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
 <CALMp9eRVNDvy65AFDz=KjUT0M0rCtgCECuMS0nUZqAhy2S=MsA@mail.gmail.com>
 <CAMkAt6paein2dHHD-wZ8Eke4tUb_8GNuiH_3-RHkiBHx=jjwUg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c423d85d-b7d4-7f1c-0b5b-d3f62b35b6da@amd.com>
Date:   Fri, 22 Nov 2019 15:22:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAMkAt6paein2dHHD-wZ8Eke4tUb_8GNuiH_3-RHkiBHx=jjwUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0601CA0011.namprd06.prod.outlook.com
 (2603:10b6:803:2f::21) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3d19842-e500-476c-10c6-08d76f92103d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:|DM6PR12MB4267:
X-MS-Exchange-PUrlCount: 1
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267ABFEB430A915DB2BD3ECE5490@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 02296943FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(14454004)(8676002)(966005)(81166006)(45080400002)(81156014)(65956001)(6512007)(6306002)(478600001)(58126008)(316002)(8936002)(31686004)(229853002)(230700001)(6486002)(36756003)(3846002)(25786009)(6436002)(305945005)(2906002)(386003)(44832011)(6506007)(5660300002)(7736002)(53546011)(66556008)(6116002)(26005)(4326008)(6246003)(11346002)(186003)(86362001)(99286004)(2486003)(2616005)(76176011)(66066001)(23676004)(110136005)(66946007)(446003)(52116002)(50466002)(54906003)(65806001)(14444005)(66476007)(47776003)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4267;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWKp3Q9PF5cs6gOWYukXzmMXOeoyVxs9rF8I0mivm9YHvC2/Mouwcq40Mzmj0fUgHWmi7eZMs9l2WEu4Zuu97YGpEZ0rN0APByH+MQAaFJ6mPjnZ3cNAV6/pRYn/heU00JxIdKME3+GGh4taYyIayUryWfK35bh/J217Cq0Q92eSVQBin1lFoYBv8D5YMJVJnzSTCp4gqsVhNGrN5Mcl26lPHg+FJ7eDX5fDf0GWZz3kxalcRb4lXOH9aK6v+QI9W+Erk1cJdKTVOxcf1zosWcUUzbV/+/xW1uI1I++HoAom25oKsRBnBniUh7ek8bvtLAvYOzqY7k6K8aWwYqWLvvLAQGvwLMj4DfPPH2/LsGunuQgSym7Zn///I7YI0uAOa1fSNv2StiJKH0ivlDEL9XpYLGIrFY+zuX79de6R8WPtcmWpNWITQLnDRRwCcbju6UiMRR982DtwG2vBINi2vlgwPaqR2wXa9UAiPZDOGtY=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d19842-e500-476c-10c6-08d76f92103d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2019 21:22:22.6619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hX2ro3gRGDng3xpAD9b1vPIuD97ov8QH56ewLLUNnWwErHa+y6mDnv3zcD1xV+ZEtvSNfCyHiOTRZf+rqVToZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ah, I missed the fact that we don't need to pass the SevES
bit to the guest because guest actually does not need it.
It just needs the SevBit to make decision whether its
safe to call the RDMSR for SEV_STATUS. The SEV_STATUS
MSR will give information which SEV feature is enabled.

thanks

On 11/22/19 1:52 PM, Peter Gonda wrote:
> I am not sure that the SevEs CPUID bit has the same problem as the Sev
> bit. It seems the reason the Sev bit was to be passed to the guest was
> to prevent the guest from reading the SEV MSR if it did not exist. If
> the guest is running with SevEs it must be also running with Sev. So
> the guest  can safely read the SevStatus MSR to check the SevEsEnabled
> bit because the Sev CPUID bit will be set.
> 
> If I look at the AMD patches for ES. I see just that,
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAMDESE%2Flinux%2Fcommit%2Fc19d84b803caf8e3130b1498868d0fcafc755da7&amp;data=02%7C01%7Cbrijesh.singh%40amd.com%7Cfe5a46e348a5464ea52b08d76f85909b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637100491764446005&amp;sdata=R6RrRO0TpcfM7uzpBbsGhVp47bA%2BVoz624IBQif%2BxjA%3D&amp;reserved=0,
> it doesn't look for the SevEs CPUID bit.
> 
> } else {
>    /* For SEV, check the SEV MSR */
>    msr = __rdmsr(MSR_AMD64_SEV);
>    if (!(msr & MSR_AMD64_SEV_ENABLED))
>      return;
>    /* SEV state cannot be controlled by a command line option */
>    sme_me_mask = me_mask;
>    sme_me_status |= SEV_ACTIVE;
>    physical_mask &= ~sme_me_mask;
> +
> +  if (!(msr & MSR_AMD64_SEV_ES_ENABLED))
> +    return;
> +
> +  sme_me_status |= SEV_ES_ACTIVE;
>    return;
> }
> 
> }
> 
> 
> On Fri, Nov 22, 2019 at 9:18 AM Jim Mattson <jmattson@google.com> wrote:
>>
>> Does SEV-ES indicate that SEV-ES guests are supported, or that the
>> current (v)CPU is running with SEV-ES enabled, or both?
>>
>> On Fri, Nov 22, 2019 at 5:01 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>>
>>>
>>> On 11/21/19 2:33 PM, Peter Gonda wrote:
>>>> Only pass through guest relevant CPUID information: Cbit location and
>>>> SEV bit. The kernel does not support nested SEV guests so the other data
>>>> in this CPUID leaf is unneeded by the guest.
>>>>
>>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>>> ---
>>>>   arch/x86/kvm/cpuid.c | 8 +++++++-
>>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>> index 946fa9cb9dd6..6439fb1dbe76 100644
>>>> --- a/arch/x86/kvm/cpuid.c
>>>> +++ b/arch/x86/kvm/cpuid.c
>>>> @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>>>                break;
>>>>        /* Support memory encryption cpuid if host supports it */
>>>>        case 0x8000001F:
>>>> -             if (!boot_cpu_has(X86_FEATURE_SEV))
>>>> +             if (boot_cpu_has(X86_FEATURE_SEV)) {
>>>> +                     /* Expose only SEV bit and CBit location */
>>>> +                     entry->eax &= F(SEV);
>>>
>>>
>>> I know SEV-ES patches are not accepted yet, but can I ask to pass the
>>> SEV-ES bit in eax?
>>>
>>>
>>>> +                     entry->ebx &= GENMASK(5, 0);
>>>> +                     entry->edx = entry->ecx = 0;
>>>> +             } else {
>>>>                        entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>> +             }
>>>>                break;
>>>>        /*Add support for Centaur's CPUID instruction*/
>>>>        case 0xC0000000:
