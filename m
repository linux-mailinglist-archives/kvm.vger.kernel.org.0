Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C121A4BA2
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 23:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgDJVmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 17:42:07 -0400
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:22970
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbgDJVmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 17:42:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRNqiZh+HKi3rwlh75Z631ShcvcvjKEvEioDHumL7zm4+hrXz4K04gl1ImcNxFO+Re3L00jAy+d20BMyQh23JgCZ5RAGyQnFZ3LEXQLiY1T7gAF2v9sHT1WHf7lOFh8BqqMElAMo/UOKLVs4agQcwn6tQFeJy/GVwL7UXQ2pG4i757lcrZqM3MiwRk8ulUeCYnJPAXEYllJpEBYGndGGWyJQBMwJLHIO4JJ7wA1zogf+J/ZazD+yLNpUp+d0WKEE/kfWuJJSOAFnvxw3evTy/Y3CHK21Pef3ICvXcMlcOvXZwSIhaB8kv2VDrw31uBGVjo+eTujCHjDwONAVF26KEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5cO8+0UITCG3tTwj6iq4ZJw1h51ZTe4mHRkMiHl3VQ=;
 b=ElwvsRotZJsqqYZ+X6ub+AWHt/zgRhTVOq1uFzFCAd2Ap7bpq9mI7aKycrPzZAWmkgEwpMB1hf63/BU/cj+iqX1KzFDf8ZSTw7SkUdrPZPvCpt93HsoHPCno4YfQBuREgEz7+OHj/nbd8SbSKvlxr8hoYUwNXoEk52pwVNGBAYKr1inJA4yG3XpyfZs6ERBRtfr8TvJ74ZKXUtYGYbJ08Dt+84/Z/ZwiW+dmzAieO4DSPawM+1klHCGtZseBw76BZjCWanXgzzWRH8UlOaAOaz1awjEE9tyvf/LSakwaSv1BdVHtXSCtzU092IRzzMCct9UGcJyoPRDoIGCmvsYzfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5cO8+0UITCG3tTwj6iq4ZJw1h51ZTe4mHRkMiHl3VQ=;
 b=k+NPTCT6oRa51TWb3k0FDlK4CNzEx1ur/y09rBYE2MsTmNbVDxHikkP9InAXcOTtZMK85xlD6siOoM/FbjKeW0JR2edjqBUm5NvfvYYY4srJt2fOMn0Rqz8724d5dFxer2Fgm9jPK9ZnLUezE8aOi0RDNa4xeFYpwuZi4qemN8U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Fri, 10 Apr
 2020 21:42:01 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d%7]) with mapi id 15.20.2900.015; Fri, 10 Apr 2020
 21:42:01 +0000
Cc:     brijesh.singh@amd.com,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        Steve Rutherford <srutherford@google.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
 <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com>
 <20200403214559.GB28747@ashkalra_ubuntu_server>
 <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com>
 <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
 <20200408015221.GB27608@ashkalra_ubuntu_server>
 <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
 <20200410013418.GB19168@ashkalra_ubuntu_server>
 <CABayD+dDtjz7rJe1ujQ_sq88JRUzHaXXNP_hQVhD1vkXkPsXCw@mail.gmail.com>
 <CABayD+dwJeu+o+TG843XX1nWHWMz=iwW0uWBKPaG0uJEsxCYGw@mail.gmail.com>
 <CABayD+cuHv6chBT5wWHqaZWXSHaOtaOQyBrxgRj2Y=q_fOheuA@mail.gmail.com>
 <DM5PR12MB1386C01E72A71F3AB6EB1F068EDE0@DM5PR12MB1386.namprd12.prod.outlook.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4be6c1a8-de3f-1e83-23d4-e0213a1acd24@amd.com>
Date:   Fri, 10 Apr 2020 16:42:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <DM5PR12MB1386C01E72A71F3AB6EB1F068EDE0@DM5PR12MB1386.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: DM3PR12CA0134.namprd12.prod.outlook.com
 (2603:10b6:0:51::30) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM3PR12CA0134.namprd12.prod.outlook.com (2603:10b6:0:51::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 21:41:58 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b52bdda-d0a1-4125-1eff-08d7dd98009b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:|SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557B85A0E88FAA378037FD5E5DE0@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(36756003)(316002)(8676002)(66476007)(478600001)(8936002)(5660300002)(110136005)(2616005)(54906003)(44832011)(81156014)(956004)(53546011)(66946007)(6666004)(66556008)(86362001)(2906002)(7416002)(52116002)(26005)(6512007)(6506007)(30864003)(31696002)(16526019)(186003)(4326008)(31686004)(6486002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dInZawKmYywZpo6Juwx3awh3z+Tle/B6IdLohNFl2RtYJOL4XRmUjLMCfJfRELRX/ZQ0NEat4p0r4rjhu1dRg9tGj/na+G2vaty9mSgSuNVsF6uP4Tjqryq1FbF97hgpp3x4deVS6rkGMYqDxRFmv4SQ2fRAdRE9E/icHWdM1eaZyuud4oTCadLU+sgq7VKt78FM5IaR/r5YknexpRYd9xqx5dI8uAxqpBxTisg88i4ejH638ue5hWnoN5fw1OWQ+vFw/2GH8M+OO4pLZ2/RB2cXlkzOCiWrjDrdplaGG/Q1rGuJgj6bXtdnnRyyoGLR/C8ViE0A3ZmBGht4+h7SUuZyEYz4mRND96WMTYIqJUsbD0ZoVeLAdlb2Fx7dQ7Df04GgPbPcJoRjNOk+N1NTYK+yz1A37QkJIlyD4rfqNgVec5eKHlVF9kx5Ku73LWEg
X-MS-Exchange-AntiSpam-MessageData: um1F9xdJSRjEg1RH0ZDyU4qQPAhr0SBKqC3BL3Ldmx3OyNy+ZlTYcJ6R/aLrnzNZbO1FlhW/fGB5+S7fRsJJ6iq8wQ/VSKWr/lpQZ7hMJOBXnXy5woH9ozWvVA3Z7WpaqD6dH7RCb8Ra+gfUbGsioA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b52bdda-d0a1-4125-1eff-08d7dd98009b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 21:42:01.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39d6Dk+P9kwrUTfEbxjw/BnjkUbB1YBnx/sccvb4hhp/3uaRoUd/iQwSsMpu8HuHuGJZJxKzh+kEXw1lhcQ7RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/10/20 3:55 PM, Kalra, Ashish wrote:
> [AMD Official Use Only - Internal Distribution Only]
>
> Hello Steve,
>
> -----Original Message-----
> From: Steve Rutherford <srutherford@google.com> 
> Sent: Friday, April 10, 2020 3:19 PM
> To: Kalra, Ashish <Ashish.Kalra@amd.com>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>; Paolo Bonzini <pbonzini@redhat.com>; Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; H. Peter Anvin <hpa@zytor.com>; Joerg Roedel <joro@8bytes.org>; Borislav Petkov <bp@suse.de>; Lendacky, Thomas <Thomas.Lendacky@amd.com>; X86 ML <x86@kernel.org>; KVM list <kvm@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; David Rientjes <rientjes@google.com>; Andy Lutomirski <luto@kernel.org>; Singh, Brijesh <brijesh.singh@amd.com>
> Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
>
> On Fri, Apr 10, 2020 at 1:16 PM Steve Rutherford <srutherford@google.com> wrote:
>> On Fri, Apr 10, 2020 at 11:14 AM Steve Rutherford 
>> <srutherford@google.com> wrote:
>>> On Thu, Apr 9, 2020 at 6:34 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>>>> Hello Steve,
>>>>
>>>> On Thu, Apr 09, 2020 at 05:59:56PM -0700, Steve Rutherford wrote:
>>>>> On Tue, Apr 7, 2020 at 6:52 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>>>>>> Hello Steve,
>>>>>>
>>>>>> On Tue, Apr 07, 2020 at 06:25:51PM -0700, Steve Rutherford wrote:
>>>>>>> On Mon, Apr 6, 2020 at 11:53 AM Krish Sadhukhan 
>>>>>>> <krish.sadhukhan@oracle.com> wrote:
>>>>>>>>
>>>>>>>> On 4/3/20 2:45 PM, Ashish Kalra wrote:
>>>>>>>>> On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
>>>>>>>>>> On 3/29/20 11:23 PM, Ashish Kalra wrote:
>>>>>>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>>>>>
>>>>>>>>>>> This ioctl can be used by the application to reset the 
>>>>>>>>>>> page encryption bitmap managed by the KVM driver. A 
>>>>>>>>>>> typical usage for this ioctl is on VM reboot, on 
>>>>>>>>>>> reboot, we must reinitialize the bitmap.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>>>>> ---
>>>>>>>>>>>    Documentation/virt/kvm/api.rst  | 13 +++++++++++++
>>>>>>>>>>>    arch/x86/include/asm/kvm_host.h |  1 +
>>>>>>>>>>>    arch/x86/kvm/svm.c              | 16 ++++++++++++++++
>>>>>>>>>>>    arch/x86/kvm/x86.c              |  6 ++++++
>>>>>>>>>>>    include/uapi/linux/kvm.h        |  1 +
>>>>>>>>>>>    5 files changed, 37 insertions(+)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/Documentation/virt/kvm/api.rst 
>>>>>>>>>>> b/Documentation/virt/kvm/api.rst index 
>>>>>>>>>>> 4d1004a154f6..a11326ccc51d 100644
>>>>>>>>>>> --- a/Documentation/virt/kvm/api.rst
>>>>>>>>>>> +++ b/Documentation/virt/kvm/api.rst
>>>>>>>>>>> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
>>>>>>>>>>>    bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
>>>>>>>>>>>    bitmap for an incoming guest.
>>>>>>>>>>> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
>>>>>>>>>>> +-----------------------------------------
>>>>>>>>>>> +
>>>>>>>>>>> +:Capability: basic
>>>>>>>>>>> +:Architectures: x86
>>>>>>>>>>> +:Type: vm ioctl
>>>>>>>>>>> +:Parameters: none
>>>>>>>>>>> +:Returns: 0 on success, -1 on error
>>>>>>>>>>> +
>>>>>>>>>>> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the 
>>>>>>>>>>> +guest's page encryption bitmap during guest reboot and this is only done on the guest's boot vCPU.
>>>>>>>>>>> +
>>>>>>>>>>> +
>>>>>>>>>>>    5. The kvm_run structure
>>>>>>>>>>>    ======================== diff --git 
>>>>>>>>>>> a/arch/x86/include/asm/kvm_host.h 
>>>>>>>>>>> b/arch/x86/include/asm/kvm_host.h index 
>>>>>>>>>>> d30f770aaaea..a96ef6338cd2 100644
>>>>>>>>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>>>>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>>>>>>>>> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
>>>>>>>>>>>                             struct kvm_page_enc_bitmap *bmap);
>>>>>>>>>>>     int (*set_page_enc_bitmap)(struct kvm *kvm,
>>>>>>>>>>>                             struct kvm_page_enc_bitmap 
>>>>>>>>>>> *bmap);
>>>>>>>>>>> +   int (*reset_page_enc_bitmap)(struct kvm *kvm);
>>>>>>>>>>>    };
>>>>>>>>>>>    struct kvm_arch_async_pf { diff --git 
>>>>>>>>>>> a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c index 
>>>>>>>>>>> 313343a43045..c99b0207a443 100644
>>>>>>>>>>> --- a/arch/x86/kvm/svm.c
>>>>>>>>>>> +++ b/arch/x86/kvm/svm.c
>>>>>>>>>>> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
>>>>>>>>>>>     return ret;
>>>>>>>>>>>    }
>>>>>>>>>>> +static int svm_reset_page_enc_bitmap(struct kvm *kvm) 
>>>>>>>>>>> +{
>>>>>>>>>>> +   struct kvm_sev_info *sev = 
>>>>>>>>>>> +&to_kvm_svm(kvm)->sev_info;
>>>>>>>>>>> +
>>>>>>>>>>> +   if (!sev_guest(kvm))
>>>>>>>>>>> +           return -ENOTTY;
>>>>>>>>>>> +
>>>>>>>>>>> +   mutex_lock(&kvm->lock);
>>>>>>>>>>> +   /* by default all pages should be marked encrypted */
>>>>>>>>>>> +   if (sev->page_enc_bmap_size)
>>>>>>>>>>> +           bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
>>>>>>>>>>> +   mutex_unlock(&kvm->lock);
>>>>>>>>>>> +   return 0;
>>>>>>>>>>> +}
>>>>>>>>>>> +
>>>>>>>>>>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>>>>>>>>>    {
>>>>>>>>>>>     struct kvm_sev_cmd sev_cmd; @@ -8203,6 +8218,7 @@ 
>>>>>>>>>>> static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>>>>>>>>>>>     .page_enc_status_hc = svm_page_enc_status_hc,
>>>>>>>>>>>     .get_page_enc_bitmap = svm_get_page_enc_bitmap,
>>>>>>>>>>>     .set_page_enc_bitmap = svm_set_page_enc_bitmap,
>>>>>>>>>>> +   .reset_page_enc_bitmap = 
>>>>>>>>>>> + svm_reset_page_enc_bitmap,
>>>>>>>>>> We don't need to initialize the intel ops to NULL ? 
>>>>>>>>>> It's not initialized in the previous patch either.
>>>>>>>>>>
>>>>>>>>>>>    };
>>>>>>>>> This struct is declared as "static storage", so won't 
>>>>>>>>> the non-initialized members be 0 ?
>>>>>>>>
>>>>>>>> Correct. Although, I see that 'nested_enable_evmcs' is 
>>>>>>>> explicitly initialized. We should maintain the convention, perhaps.
>>>>>>>>
>>>>>>>>>>>    static int __init svm_init(void) diff --git 
>>>>>>>>>>> a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index 
>>>>>>>>>>> 05e953b2ec61..2127ed937f53 100644
>>>>>>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>>>>>>> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>>>>>>>>>>                     r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
>>>>>>>>>>>             break;
>>>>>>>>>>>     }
>>>>>>>>>>> +   case KVM_PAGE_ENC_BITMAP_RESET: {
>>>>>>>>>>> +           r = -ENOTTY;
>>>>>>>>>>> +           if (kvm_x86_ops->reset_page_enc_bitmap)
>>>>>>>>>>> +                   r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
>>>>>>>>>>> +           break;
>>>>>>>>>>> +   }
>>>>>>>>>>>     default:
>>>>>>>>>>>             r = -ENOTTY;
>>>>>>>>>>>     }
>>>>>>>>>>> diff --git a/include/uapi/linux/kvm.h 
>>>>>>>>>>> b/include/uapi/linux/kvm.h index 
>>>>>>>>>>> b4b01d47e568..0884a581fc37 100644
>>>>>>>>>>> --- a/include/uapi/linux/kvm.h
>>>>>>>>>>> +++ b/include/uapi/linux/kvm.h
>>>>>>>>>>> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
>>>>>>>>>>>    #define KVM_GET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
>>>>>>>>>>>    #define KVM_SET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc6, 
>>>>>>>>>>> struct kvm_page_enc_bitmap)
>>>>>>>>>>> +#define KVM_PAGE_ENC_BITMAP_RESET  _IO(KVMIO, 0xc7)
>>>>>>>>>>>    /* Secure Encrypted Virtualization command */
>>>>>>>>>>>    enum sev_cmd_id {
>>>>>>>>>> Reviewed-by: Krish Sadhukhan 
>>>>>>>>>> <krish.sadhukhan@oracle.com>
>>>>>>>
>>>>>>> Doesn't this overlap with the set ioctl? Yes, obviously, you 
>>>>>>> have to copy the new value down and do a bit more work, but 
>>>>>>> I don't think resetting the bitmap is going to be the 
>>>>>>> bottleneck on reboot. Seems excessive to add another ioctl for this.
>>>>>> The set ioctl is generally available/provided for the incoming 
>>>>>> VM to setup the page encryption bitmap, this reset ioctl is 
>>>>>> meant for the source VM as a simple interface to reset the whole page encryption bitmap.
>>>>>>
>>>>>> Thanks,
>>>>>> Ashish
>>>>>
>>>>> Hey Ashish,
>>>>>
>>>>> These seem very overlapping. I think this API should be refactored a bit.
>>>>>
>>>>> 1) Use kvm_vm_ioctl_enable_cap to control whether or not this 
>>>>> hypercall (and related feature bit) is offered to the VM, and 
>>>>> also the size of the buffer.
>>>> If you look at patch 13/14, i have added a new kvm para feature 
>>>> called "KVM_FEATURE_SEV_LIVE_MIGRATION" which indicates host 
>>>> support for SEV Live Migration and a new Custom MSR which the 
>>>> guest does a wrmsr to enable the Live Migration feature, so this 
>>>> is like the enable cap support.
>>>>
>>>> There are further extensions to this support i am adding, so patch 
>>>> 13/14 of this patch-set is still being enhanced and will have full 
>>>> support when i repost next.
>>>>
>>>>> 2) Use set for manipulating values in the bitmap, including 
>>>>> resetting the bitmap. Set the bitmap pointer to null if you want 
>>>>> to reset to all 0xFFs. When the bitmap pointer is set, it should 
>>>>> set the values to exactly what is pointed at, instead of only 
>>>>> clearing bits, as is done currently.
>>>> As i mentioned in my earlier email, the set api is supposed to be 
>>>> for the incoming VM, but if you really need to use it for the 
>>>> outgoing VM then it can be modified.
>>>>
>>>>> 3) Use get for fetching values from the kernel. Personally, I'd 
>>>>> require alignment of the base GFN to a multiple of 8 (but the 
>>>>> number of pages could be whatever), so you can just use a 
>>>>> memcpy. Optionally, you may want some way to tell userspace the 
>>>>> size of the existing buffer, so it can ensure that it can ask 
>>>>> for the entire buffer without having to track the size in 
>>>>> usermode (not strictly necessary, but nice to have since it 
>>>>> ensures that there is only one place that has to manage this value).
>>>>>
>>>>> If you want to expand or contract the bitmap, you can use enable 
>>>>> cap to adjust the size.
>>>> As being discussed on the earlier mail thread, we are doing this 
>>>> dynamically now by computing the guest RAM size when the 
>>>> set_user_memory_region ioctl is invoked. I believe that should 
>>>> handle the hot-plug and hot-unplug events too, as any hot memory 
>>>> updates will need KVM memslots to be updated.
>>> Ahh, sorry, forgot you mentioned this: yes this can work. Host needs 
>>> to be able to decide not to allocate, but this should be workable.
>>>>> If you don't want to offer the hypercall to the guest, don't 
>>>>> call the enable cap.
>>>>> This API avoids using up another ioctl. Ioctl space is somewhat 
>>>>> scarce. It also gives userspace fine grained control over the 
>>>>> buffer, so it can support both hot-plug and hot-unplug (or at 
>>>>> the very least it is not obviously incompatible with those). It 
>>>>> also gives userspace control over whether or not the feature is 
>>>>> offered. The hypercall isn't free, and being able to tell guests 
>>>>> to not call when the host wasn't going to migrate it anyway will be useful.
>>>>>
>>>> As i mentioned above, now the host indicates if it supports the 
>>>> Live Migration feature and the feature and the hypercall are only 
>>>> enabled on the host when the guest checks for this support and 
>>>> does a wrmsr() to enable the feature. Also the guest will not make 
>>>> the hypercall if the host does not indicate support for it.
>>> If my read of those patches was correct, the host will always 
>>> advertise support for the hypercall. And the only bit controlling 
>>> whether or not the hypercall is advertised is essentially the kernel 
>>> version. You need to rollout a new kernel to disable the hypercall.
>> Ahh, awesome, I see I misunderstood how the CPUID bits get passed
>> through: usermode can still override them. Forgot about the back and 
>> forth for CPUID with usermode. My point about informing the guest 
>> kernel is clearly moot. The host still needs the ability to prevent 
>> allocations, but that is more minor. Maybe use a flag on the memslots 
>> directly?
>> On second thought: burning the memslot flag for 30mb per tb of VM seems like a waste.
> Currently, I am still using the approach of a "unified" page encryption bitmap instead of a 
> bitmap per memslot, with the main change being that the resizing is only done whenever
> there are any updates in memslots, when memslots are updated using the
> kvm_arch_commit_memory_region() interface.


Just a note, I believe kvm_arch_commit_memory_region() maybe getting
called every time there is a change in the memory region (e.g add,
update, delete etc). So your architecture specific hook now need to be
well aware of all those changes and act accordingly. This basically
means that the svm.c will probably need to understand all those memory
slot flags etc. IMO, having a separate ioctl to hint the size makes more
sense if you are doing a unified bitmap but if the bitmap is per memslot
then calculating the size based on the memslot information makes more sense.

