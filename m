Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D76C1A19FB
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 04:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgDHCd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 22:33:58 -0400
Received: from mail-eopbgr760049.outbound.protection.outlook.com ([40.107.76.49]:41934
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726428AbgDHCd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 22:33:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbGRU2vVANkMttX9e/WHlGbfiCXhpVEbunv2vaEDhFkIXx7fM3dCF8+inDtOJWVPg2TXn04tvTaHSN3WW9nXtWL4wfGetptLVlz2kZ2/0COUymyfp7GbolpzCh5IaP3auGfX6mzQMqYeoHJtcM7RBfMToD+PmQHgoRO9QEjIbzvzmHq8IZ9m4isyU1AZf+icWIFAprFA7cv0y+H2xO5mq8oGBTrhe3dMAj1iKGH2Cf3UrbdF7XWMicK3Pmx/KkfM791Ph3Z4mqIrZbFj8SdKW+hIWSjLTZLqXAJRAMPagZO062YkfPGi0gkJ9NNIcTP6dMh/EeiHw+BKxnxz0Vu7Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UCqVgs9abZFTJCG60T9QhpKTs8AIu5WbgwKTNYlx5Q=;
 b=oZAS6Q8tsLGfankZzWl+guFhMdcafkB5L9SdMXExZR0UNIlvv6ODSpr3XqHbdoiQN5TtFZzy637dwjRy3IgGP06bLslaSR1If53tuStvHFWCuKj1NEKJisdM1SFNNSBbCJgsBY3iAQsEh/HlcAMo3+hnfLk3nFLnWnZPJgVNSUEsuXrxmIIJvi9sUFQsgUNyksj4dUTj4qXsw6aHZNKiHNmms25i5Hsh8JOQubdEyeAAt1WOXMRg/kv7Wll5rI1naoiZxAxtLv4R5cGHoUThyYxLBd1J1B3597Nrp5EacQnxQwf71x54Ku91npCzIMQi9uWSg4bKpAPTIcJg6NvQKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UCqVgs9abZFTJCG60T9QhpKTs8AIu5WbgwKTNYlx5Q=;
 b=MOcXxE5SqFOMnm/Ey1e2AChNpD/1G+HlSLz0PCiP8dN5w1C9llCTSHwgP7WyyDxfkVHAb32alEON+KoKje9WfHflv1I2tg0N2sc51nodITbmJJVsogbLnSvmwxfLsDD5FRvzItTZ3HVxninnXHZXB7uMbUxQD3dbTJrx3s/He9Y=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Wed, 8 Apr
 2020 02:33:54 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2878.018; Wed, 8 Apr 2020
 02:33:54 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
To:     Steve Rutherford <srutherford@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
 <CABayD+ekEYAS4z=L2r1q+8xaEzqKmJuzuYQhsWX3X=htgTvL5w@mail.gmail.com>
 <20200407052740.GA31821@ashkalra_ubuntu_server>
 <CABayD+cNdEJxoSHee3s0toy6-nO6Bm4-OsrbBdS8mCWoMBSqLQ@mail.gmail.com>
 <d67a104e-6a01-a766-63b2-3f8b6026ca4c@amd.com>
 <CABayD+ehZZabp2tA8K-ViB0BXPyjpz-XpXPXoD7MUH0OLz_Z-g@mail.gmail.com>
 <20200408011726.GA3684@ashkalra_ubuntu_server>
 <CABayD+et6p8UAr1jTFMK2SbYvihveLH6kp=RRqzBxvaU-HPy2Q@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <42597534-b8c6-4c73-9b12-ddbde079fc7c@amd.com>
Date:   Tue, 7 Apr 2020 21:34:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <CABayD+et6p8UAr1jTFMK2SbYvihveLH6kp=RRqzBxvaU-HPy2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN1PR12CA0103.namprd12.prod.outlook.com
 (2603:10b6:802:21::38) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN1PR12CA0103.namprd12.prod.outlook.com (2603:10b6:802:21::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 02:33:52 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 825fcef4-8063-4a6d-cfd9-08d7db65478c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:|SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4415F54DFAC0198F7441DB08E5C00@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(36756003)(44832011)(2616005)(31686004)(966005)(316002)(956004)(66476007)(6636002)(66946007)(2906002)(5660300002)(66556008)(16526019)(186003)(7416002)(26005)(478600001)(52116002)(86362001)(6666004)(110136005)(30864003)(54906003)(6486002)(6506007)(31696002)(81166006)(6512007)(4326008)(81156014)(66574012)(8936002)(53546011)(8676002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SSzJ65CZ0kG+JcjOyOV1X/grsMdjM59CoV83x6fa0QO5chJOxO67In5qYosXLMGR/p7UILQKsR1V9tlyA9VmOr/AFNUxrDWl4DfHv2hxLF69F3nB16EKp0BM60s/buruesiCuZefn+tWKlU77EYw/WEFeOJfR3PfXJzMDbne+wF/Oo4hX4wW66Fi3cGHRCXjBlrqx7aGR4+XeLq2NY5eTMsl4dHDu31SaAuPoXArCLERrBvE/19yILIGWYTkv8H6CRPkQJakxHxMliFB7CpXIYA5l0mnXs8odoGG9uS3EdSZR9ufWSZOAjjfjpDObC4mEZgDucqqWtE+Oa5plYI2YshE0M+PIn1zPjsC5PHtkV8XjTXRfudfbKvfXxyZg2nNT1usSU5B7+8IY2oepfl3ISRNPVi870KUjXpDzmkqWc6c8MPogR+8GSr4keXH7JFu7aJi/zVijB688Nx4uFTZ1hQbIdtWWrfhtE4ihde0ataaItJ2Kh1ySetvD+5GG6/XsWMGCOsTlwWMPeoqhnzA8A==
X-MS-Exchange-AntiSpam-MessageData: OHaCs98hViYpqrQ5aQX1Vn+CeP2kFUDiYCED8YduaoHAMWecvSf/6o43VIEAto0DkQZOTByNcwKJQMX5fGWpG8ohFGkso0KqvjZ3ONmusYfB5uwqFv6Db351e7rfpZcGfQYpYhpZcJDlRPN07ua80g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825fcef4-8063-4a6d-cfd9-08d7db65478c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 02:33:53.9215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNyEmLv+RD55XqlIXeAdwClz9rLGuPvcVlu8wRI0eSXHsS/VQO1AO2KtE5ZJFqTKQM+Bsz7axWvlapHMzYB7sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/20 8:38 PM, Steve Rutherford wrote:
> On Tue, Apr 7, 2020 at 6:17 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>> Hello Steve, Brijesh,
>>
>> On Tue, Apr 07, 2020 at 05:35:57PM -0700, Steve Rutherford wrote:
>>> On Tue, Apr 7, 2020 at 5:29 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>>>
>>>> On 4/7/20 7:01 PM, Steve Rutherford wrote:
>>>>> On Mon, Apr 6, 2020 at 10:27 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>>>>>> Hello Steve,
>>>>>>
>>>>>> On Mon, Apr 06, 2020 at 07:17:37PM -0700, Steve Rutherford wrote:
>>>>>>> On Sun, Mar 29, 2020 at 11:22 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>>>>> From: Brijesh Singh <Brijesh.Singh@amd.com>
>>>>>>>>
>>>>>>>> This hypercall is used by the SEV guest to notify a change in the page
>>>>>>>> encryption status to the hypervisor. The hypercall should be invoked
>>>>>>>> only when the encryption attribute is changed from encrypted -> decrypted
>>>>>>>> and vice versa. By default all guest pages are considered encrypted.
>>>>>>>>
>>>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>>>>> Cc: Ingo Molnar <mingo@redhat.com>
>>>>>>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>>>>>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>>>>>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>>>>>>>> Cc: Joerg Roedel <joro@8bytes.org>
>>>>>>>> Cc: Borislav Petkov <bp@suse.de>
>>>>>>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>>>>>>> Cc: x86@kernel.org
>>>>>>>> Cc: kvm@vger.kernel.org
>>>>>>>> Cc: linux-kernel@vger.kernel.org
>>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>> ---
>>>>>>>>  Documentation/virt/kvm/hypercalls.rst | 15 +++++
>>>>>>>>  arch/x86/include/asm/kvm_host.h       |  2 +
>>>>>>>>  arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++++
>>>>>>>>  arch/x86/kvm/vmx/vmx.c                |  1 +
>>>>>>>>  arch/x86/kvm/x86.c                    |  6 ++
>>>>>>>>  include/uapi/linux/kvm_para.h         |  1 +
>>>>>>>>  6 files changed, 120 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
>>>>>>>> index dbaf207e560d..ff5287e68e81 100644
>>>>>>>> --- a/Documentation/virt/kvm/hypercalls.rst
>>>>>>>> +++ b/Documentation/virt/kvm/hypercalls.rst
>>>>>>>> @@ -169,3 +169,18 @@ a0: destination APIC ID
>>>>>>>>
>>>>>>>>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>>>>>>>>                 any of the IPI target vCPUs was preempted.
>>>>>>>> +
>>>>>>>> +
>>>>>>>> +8. KVM_HC_PAGE_ENC_STATUS
>>>>>>>> +-------------------------
>>>>>>>> +:Architecture: x86
>>>>>>>> +:Status: active
>>>>>>>> +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
>>>>>>>> +
>>>>>>>> +a0: the guest physical address of the start page
>>>>>>>> +a1: the number of pages
>>>>>>>> +a2: encryption attribute
>>>>>>>> +
>>>>>>>> +   Where:
>>>>>>>> +       * 1: Encryption attribute is set
>>>>>>>> +       * 0: Encryption attribute is cleared
>>>>>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>>>>>> index 98959e8cd448..90718fa3db47 100644
>>>>>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>>>>>> @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
>>>>>>>>
>>>>>>>>         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>>>>>>>>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>>>>>>>> +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
>>>>>>>> +                                 unsigned long sz, unsigned long mode);
>>>>>>> Nit: spell out size instead of sz.
>>>>>>>>  };
>>>>>>>>
>>>>>>>>  struct kvm_arch_async_pf {
>>>>>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>>>>>>> index 7c2721e18b06..1d8beaf1bceb 100644
>>>>>>>> --- a/arch/x86/kvm/svm.c
>>>>>>>> +++ b/arch/x86/kvm/svm.c
>>>>>>>> @@ -136,6 +136,8 @@ struct kvm_sev_info {
>>>>>>>>         int fd;                 /* SEV device fd */
>>>>>>>>         unsigned long pages_locked; /* Number of pages locked */
>>>>>>>>         struct list_head regions_list;  /* List of registered regions */
>>>>>>>> +       unsigned long *page_enc_bmap;
>>>>>>>> +       unsigned long page_enc_bmap_size;
>>>>>>>>  };
>>>>>>>>
>>>>>>>>  struct kvm_svm {
>>>>>>>> @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
>>>>>>>>
>>>>>>>>         sev_unbind_asid(kvm, sev->handle);
>>>>>>>>         sev_asid_free(sev->asid);
>>>>>>>> +
>>>>>>>> +       kvfree(sev->page_enc_bmap);
>>>>>>>> +       sev->page_enc_bmap = NULL;
>>>>>>>>  }
>>>>>>>>
>>>>>>>>  static void avic_vm_destroy(struct kvm *kvm)
>>>>>>>> @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>>>>>         return ret;
>>>>>>>>  }
>>>>>>>>
>>>>>>>> +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
>>>>>>>> +{
>>>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>> +       unsigned long *map;
>>>>>>>> +       unsigned long sz;
>>>>>>>> +
>>>>>>>> +       if (sev->page_enc_bmap_size >= new_size)
>>>>>>>> +               return 0;
>>>>>>>> +
>>>>>>>> +       sz = ALIGN(new_size, BITS_PER_LONG) / 8;
>>>>>>>> +
>>>>>>>> +       map = vmalloc(sz);
>>>>>>>> +       if (!map) {
>>>>>>>> +               pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
>>>>>>>> +                               sz);
>>>>>>>> +               return -ENOMEM;
>>>>>>>> +       }
>>>>>>>> +
>>>>>>>> +       /* mark the page encrypted (by default) */
>>>>>>>> +       memset(map, 0xff, sz);
>>>>>>>> +
>>>>>>>> +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
>>>>>>>> +       kvfree(sev->page_enc_bmap);
>>>>>>>> +
>>>>>>>> +       sev->page_enc_bmap = map;
>>>>>>>> +       sev->page_enc_bmap_size = new_size;
>>>>>>>> +
>>>>>>>> +       return 0;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>>>>>>>> +                                 unsigned long npages, unsigned long enc)
>>>>>>>> +{
>>>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>> +       kvm_pfn_t pfn_start, pfn_end;
>>>>>>>> +       gfn_t gfn_start, gfn_end;
>>>>>>>> +       int ret;
>>>>>>>> +
>>>>>>>> +       if (!sev_guest(kvm))
>>>>>>>> +               return -EINVAL;
>>>>>>>> +
>>>>>>>> +       if (!npages)
>>>>>>>> +               return 0;
>>>>>>>> +
>>>>>>>> +       gfn_start = gpa_to_gfn(gpa);
>>>>>>>> +       gfn_end = gfn_start + npages;
>>>>>>>> +
>>>>>>>> +       /* out of bound access error check */
>>>>>>>> +       if (gfn_end <= gfn_start)
>>>>>>>> +               return -EINVAL;
>>>>>>>> +
>>>>>>>> +       /* lets make sure that gpa exist in our memslot */
>>>>>>>> +       pfn_start = gfn_to_pfn(kvm, gfn_start);
>>>>>>>> +       pfn_end = gfn_to_pfn(kvm, gfn_end);
>>>>>>>> +
>>>>>>>> +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
>>>>>>>> +               /*
>>>>>>>> +                * Allow guest MMIO range(s) to be added
>>>>>>>> +                * to the page encryption bitmap.
>>>>>>>> +                */
>>>>>>>> +               return -EINVAL;
>>>>>>>> +       }
>>>>>>>> +
>>>>>>>> +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
>>>>>>>> +               /*
>>>>>>>> +                * Allow guest MMIO range(s) to be added
>>>>>>>> +                * to the page encryption bitmap.
>>>>>>>> +                */
>>>>>>>> +               return -EINVAL;
>>>>>>>> +       }
>>>>>>>> +
>>>>>>>> +       mutex_lock(&kvm->lock);
>>>>>>>> +       ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
>>>>>>>> +       if (ret)
>>>>>>>> +               goto unlock;
>>>>>>>> +
>>>>>>>> +       if (enc)
>>>>>>>> +               __bitmap_set(sev->page_enc_bmap, gfn_start,
>>>>>>>> +                               gfn_end - gfn_start);
>>>>>>>> +       else
>>>>>>>> +               __bitmap_clear(sev->page_enc_bmap, gfn_start,
>>>>>>>> +                               gfn_end - gfn_start);
>>>>>>>> +
>>>>>>>> +unlock:
>>>>>>>> +       mutex_unlock(&kvm->lock);
>>>>>>>> +       return ret;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>>>>>>  {
>>>>>>>>         struct kvm_sev_cmd sev_cmd;
>>>>>>>> @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>>>>>>>>         .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>>>>>>>>
>>>>>>>>         .apic_init_signal_blocked = svm_apic_init_signal_blocked,
>>>>>>>> +
>>>>>>>> +       .page_enc_status_hc = svm_page_enc_status_hc,
>>>>>>>>  };
>>>>>>>>
>>>>>>>>  static int __init svm_init(void)
>>>>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>>>>>> index 079d9fbf278e..f68e76ee7f9c 100644
>>>>>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>>>>>> @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>>>>>>>>         .nested_get_evmcs_version = NULL,
>>>>>>>>         .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
>>>>>>>>         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>>>>>>>> +       .page_enc_status_hc = NULL,
>>>>>>>>  };
>>>>>>>>
>>>>>>>>  static void vmx_cleanup_l1d_flush(void)
>>>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>>>>> index cf95c36cb4f4..68428eef2dde 100644
>>>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>>>> @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>>>>>>                 kvm_sched_yield(vcpu->kvm, a0);
>>>>>>>>                 ret = 0;
>>>>>>>>                 break;
>>>>>>>> +       case KVM_HC_PAGE_ENC_STATUS:
>>>>>>>> +               ret = -KVM_ENOSYS;
>>>>>>>> +               if (kvm_x86_ops->page_enc_status_hc)
>>>>>>>> +                       ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
>>>>>>>> +                                       a0, a1, a2);
>>>>>>>> +               break;
>>>>>>>>         default:
>>>>>>>>                 ret = -KVM_ENOSYS;
>>>>>>>>                 break;
>>>>>>>> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
>>>>>>>> index 8b86609849b9..847b83b75dc8 100644
>>>>>>>> --- a/include/uapi/linux/kvm_para.h
>>>>>>>> +++ b/include/uapi/linux/kvm_para.h
>>>>>>>> @@ -29,6 +29,7 @@
>>>>>>>>  #define KVM_HC_CLOCK_PAIRING           9
>>>>>>>>  #define KVM_HC_SEND_IPI                10
>>>>>>>>  #define KVM_HC_SCHED_YIELD             11
>>>>>>>> +#define KVM_HC_PAGE_ENC_STATUS         12
>>>>>>>>
>>>>>>>>  /*
>>>>>>>>   * hypercalls use architecture specific
>>>>>>>> --
>>>>>>>> 2.17.1
>>>>>>>>
>>>>>>> I'm still not excited by the dynamic resizing. I believe the guest
>>>>>>> hypercall can be called in atomic contexts, which makes me
>>>>>>> particularly unexcited to see a potentially large vmalloc on the host
>>>>>>> followed by filling the buffer. Particularly when the buffer might be
>>>>>>> non-trivial in size (~1MB per 32GB, per some back of the envelope
>>>>>>> math).
>>>>>>>
>>>>>> I think looking at more practical situations, most hypercalls will
>>>>>> happen during the boot stage, when device specific initializations are
>>>>>> happening, so typically the maximum page encryption bitmap size would
>>>>>> be allocated early enough.
>>>>>>
>>>>>> In fact, initial hypercalls made by OVMF will probably allocate the
>>>>>> maximum page bitmap size even before the kernel comes up, especially
>>>>>> as they will be setting up page enc/dec status for MMIO, ROM, ACPI
>>>>>> regions, PCI device memory, etc., and most importantly for
>>>>>> "non-existent" high memory range (which will probably be the
>>>>>> maximum size page encryption bitmap allocated/resized).
>>>>>>
>>>>>> Let me know if you have different thoughts on this ?
>>>>> Hi Ashish,
>>>>>
>>>>> If this is not an issue in practice, we can just move past this. If we
>>>>> are basically guaranteed that OVMF will trigger hypercalls that expand
>>>>> the bitmap beyond the top of memory, then, yes, that should work. That
>>>>> leaves me slightly nervous that OVMF might regress since it's not
>>>>> obvious that calling a hypercall beyond the top of memory would be
>>>>> "required" for avoiding a somewhat indirectly related issue in guest
>>>>> kernels.
>>>>
>>>> If possible then we should try to avoid growing/shrinking the bitmap .
>>>> Today OVMF may not be accessing beyond memory but a malicious guest
>>>> could send a hypercall down which can trigger a huge memory allocation
>>>> on the host side and may eventually cause denial of service for other.
>>> Nice catch! Was just writing up an email about this.
>>>> I am in favor if we can find some solution to handle this case. How
>>>> about Steve's suggestion about VMM making a call down to the kernel to
>>>> tell how big the bitmap should be? Initially it should be equal to the
>>>> guest RAM and if VMM ever did the memory expansion then it can send down
>>>> another notification to increase the bitmap ?
>>>>
>>>> Optionally, instead of adding a new ioctl, I was wondering if we can
>>>> extend the kvm_arch_prepare_memory_region() to make svm specific x86_ops
>>>> which can take read the userspace provided memory region and calculate
>>>> the amount of guest RAM managed by the KVM and grow/shrink the bitmap
>>>> based on that information. I have not looked deep enough to see if its
>>>> doable but if it can work then we can avoid adding yet another ioctl.
>>> We also have the set bitmap ioctl in a later patch in this series. We
>>> could also use the set ioctl for initialization (it's a little
>>> excessive for initialization since there will be an additional
>>> ephemeral allocation and a few additional buffer copies, but that's
>>> probably fine). An enable_cap has the added benefit of probably being
>>> necessary anyway so usermode can disable the migration feature flag.
>>>
>>> In general, userspace is going to have to be in direct control of the
>>> buffer and its size.
>> My only practical concern about setting a static bitmap size based on guest
>> memory is about the hypercalls being made initially by OVMF to set page
>> enc/dec status for ROM, ACPI regions and especially the non-existent
>> high memory range. The new ioctl will statically setup bitmap size to
>> whatever guest RAM is specified, say 4G, 8G, etc., but the OVMF
>> hypercall for non-existent memory will try to do a hypercall for guest
>> physical memory range like ~6G->64G (for 4G guest RAM setup), this
>> hypercall will basically have to just return doing nothing, because
>> the allocated bitmap won't have this guest physical range available ?


IMO, Ovmf issuing a hypercall beyond the guest RAM is simple wrong, it
should *not* do that.  There was a feature request I submitted sometime
back to Tianocore https://bugzilla.tianocore.org/show_bug.cgi?id=623 as
I saw this coming in future. I tried highlighting the problem in the
MdeModulePkg that it does not provide a notifier to tell OVMF when core
creates the MMIO holes etc. It was not a big problem with the SEV
initially because we were never getting down to hypervisor to do
something about those non-existent regions. But with the migration its
now important that we should restart the discussion with UEFI folks and
see what can be done. In the kernel patches we should do what is right
for the kernel and not workaround the Ovmf limitation.


>> Also, hypercalls for ROM, ACPI, device regions and any memory holes within
>> the static bitmap setup as per guest RAM config will work, but what
>> about hypercalls for any device regions beyond the guest RAM config ?
>>
>> Thanks,
>> Ashish
> I'm not super familiar with what the address beyond the top of ram is
> used for. If the memory is not backed by RAM, will it even matter for
> migration? Sounds like the encryption for SEV won't even apply to it.
> If we don't need to know what the c-bit state of an address is, we
> don't need to track it. It doesn't hurt to track it (which is why I'm
> not super concerned about tracking the memory holes).
