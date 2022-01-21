Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1384958C7
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 05:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiAUEIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 23:08:39 -0500
Received: from mail-sn1anam02on2088.outbound.protection.outlook.com ([40.107.96.88]:40206
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233884AbiAUEIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 23:08:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/7lTOboCaunXEDXjz+i47jiizw15Kxu5lYA9J/zxsrdAAy3rRlkLlxSc4Y/bwFgP++xbO3qs5ZzlGUYBDEx9tMrkbYrhdwXwjTvuD78s3BUaCmqlCqOh8bfUkR0TDq0DHFPMB+91cuYyoxQZje7alx5HGMRmvtiuUfYTcnG4FRYLxVXOrl2NuJpGb8NJJAYQv82h6QOt3bDm7ovx1olsqlxX6SjZXrGq9RyVLnYGD7gIePOnmz1TAqBcN5sK3sA60habHTL0xZQL0w2mhv8yOdZ70WxNAuhS/n08B3DTig9Nckm+eDvUv0SPlH3hFCAXru8NBYaElL8SWNjHSaH0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJluQCwTGdbNKiJ3GI0ZIfSrxmeFMDwqG8sg7qsrdxA=;
 b=HQGbBw97aFQYEEYb3r4SOjLrKCNib5hTy5qWHs2WSOX7ia3ixoCtj1xdhmRfpGCOWC56CfmCPK9nHmfEZeBrPkiejvO74SI2s5VoUZAJbfNw0Y6d7fnNYAxcfFhAAMjhrjEstWFUTMQpiSEvWPEamVzQET8C+6n9XzvvLCxIh6euC00voSBp7e88s3LCPMBR7T2lV/XZXVMzCmKNtGxfe9qHjfWa8bkc4STYNDy8Dt+yhOxuEuI9e27t793fPSDUzA2ZcE6XVUCaWiPuQnG4NtrvUOZBi36v+/NOC9x5tlXa2vnUlcaDVsjwyfARq/LNPnrLEqKBoVkpcVDs5Mnkqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJluQCwTGdbNKiJ3GI0ZIfSrxmeFMDwqG8sg7qsrdxA=;
 b=QJnXKobJJD+eYdyMQhbm7Md9ZH1pnPv5J4BKME86KCXKiUnevue54rCnZde1q70I6ufGcrHT5SB5QVRjlXo5tJo62ERZot+xrx8HwfNpx7U0QyxmRtw1U+BCgBcMGTJispnYFwGbltQiaheOHhGFU2Fuks+jCApiPvbQcxa/Wkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 BN8PR12MB3540.namprd12.prod.outlook.com (2603:10b6:408:6c::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.10; Fri, 21 Jan 2022 04:08:35 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc%7]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 04:08:35 +0000
Message-ID: <4e68ae1c-e0ed-2620-fbd1-0f0f7eb28c4f@amd.com>
Date:   Fri, 21 Jan 2022 09:38:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
 <CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR0101CA0003.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:18::13) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df264885-48f4-4780-ecac-08d9dc93b168
X-MS-TrafficTypeDiagnostic: BN8PR12MB3540:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB35407EE559568CAF7ADAAEE3E25B9@BN8PR12MB3540.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RTAvUoiKwdL1h3HuZLCylOT62dsO9NMolzeCj1pAW5iA7e02aMdBBDrmKB6rDo1aZRAZqXWYuv1tupAKSIOC0qT8v+GnCmcAKhgIVaAydkM6m1b9vAgxjPwr+oHRAibIMZvk+3jrNL734UFpIhrele607T9nmaNWOuzNZz22VcXSY+AXHUGObYcYlvGeAITo1zMFfs9LU+ud4hFNMVcapyjruUfFGEjv9JGE/P7Q+GpsAUlYNK8VSFZrirPJLzKwAzJy6f7QMXn5yH6dAqne53JTr/9Wawc/+xcb07TFX8rpfFDCvEEBHT5avrBAyGqUBbleQ0dciU/DMJYvToUPuQN0bmENy3v+rY0Pzj7nEtyfZXMAHWsimOVVVnJIJ3SSlZRuVSfysapFl73PCtsj1nDeaW69L3S1bOfX6bThqv735xDozLc6nhhGkBg4qj3GPWLz+Wr4tCxBgYM+Lwk6JeYOcSGkRA63DmGJSPUl9WA6Mq+zgk+x6FwtzrI666H1N36bciaOmeVp4WkrN7wG9hXrCagoAm5vkOxctLn8CoHDb+g74Up42EFxLZ9fy56RF4RPnEwOgCSxwtWsFP08blR5Y/3ajXyAz49QBFWlHSkqn+w8ZqujbPVkxHR0pO4TORGnS4+AFCSg3SXh+P2tf+6H6EziEivHIqTnjDIblxuE6r4ZM34+LPJy2ft4E7Zo6DX635KpMqqM72I22Pd9IXk7nqmOHpnGUINAxUZ+ZHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(6486002)(6512007)(53546011)(38100700002)(6666004)(316002)(6506007)(54906003)(31696002)(66946007)(66476007)(66556008)(5660300002)(4326008)(83380400001)(31686004)(2906002)(36756003)(8936002)(508600001)(26005)(186003)(6916009)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDUyTmxrbDNHeHpxdGpVSFNlYk16RUdSWG1KUEx2VThqcURQTGxCbXlrWEox?=
 =?utf-8?B?SDJTMEx6NzFxQUpBVDVxUVdDY0VxYWdDTWd4aWgxREZURDcxaHMxZGxwQjgx?=
 =?utf-8?B?UjB6aVVvblQvWjJpNFZycGdsb1lnczRPMkt5WVdpSStyTGxkaFZ0MmJMVTB0?=
 =?utf-8?B?cUV3MzBqcVNFZ3diY2dENjBtT2k5S0dMVUtHdkFQYVVWeEJOT2IrN3ZTRVow?=
 =?utf-8?B?QzBjV1NKYjNncFp6cDNrdWJodHVTNXY1Wk5IcmZlL0t5UWNVMWlFbGNzUDg1?=
 =?utf-8?B?cjI2c2lqTFo0MlBkNjBXeUNYYjB5YWtlbUVvSXdQUG5UVjNZcFFwVlJGS1Vx?=
 =?utf-8?B?bmVVUldybzY3eU1YY1dwVTV6RFY5RmRqQ3plcEp0UjVJZnU4RlJwMGl4U3VC?=
 =?utf-8?B?dGZ0N09EYzQyay81S05VNEhUSEMvWkVJODg0ZTUySGQ5TzR2S1Q0ZVpuOUly?=
 =?utf-8?B?T0FVd1dZWHFMRHRkOUtzRjVQQjZEQ2xBNURJMmx2bWgxNG5acnhvYThWWlBm?=
 =?utf-8?B?N1h1eDgzV09yOG80bCtTdFd1VHd1eVA0VXI1ZUVGTUtOSEw4TUo1ZW9oMHpG?=
 =?utf-8?B?c2Q3VjZFaUtTd1lseVVNM1FOVEd4L3ZFRGtZajNlaVRXWTRybGJBb1RzSXls?=
 =?utf-8?B?S0ttNENIcnVxdnFwTGxSaFlqdUU2ZWp5TUlnVW5LeExHSGJMR1RkMXNlL3ha?=
 =?utf-8?B?UjlRV3BuMmd2dGZjejFGMmJmcjQ4a2Q5UWNNL3A2UDB5ZnI0Z0M3QUpkZUNP?=
 =?utf-8?B?SzZsb1NjS2JHanlrLzVQM2w0VmU0d1ljdEhnT3dCNkRSdXA5eU5jZktTMlJt?=
 =?utf-8?B?aFNOOWVnTGJkL3RFQ0MrSHVJYUtMVVM1b3hvKzVoYjZYZzlwK0tBWmE5UGV5?=
 =?utf-8?B?Rzhma0NNcDZKTXlHdUgzNm1VaTQ4cnNYeGxvamkzbWlva2ZjdUFCVHBqUXhm?=
 =?utf-8?B?Y3VhSDFwenp5TWZqTTR6enVoK1Z2MlJQbTlKbHFwTEZqYjZxZDd5VUJKZ0N0?=
 =?utf-8?B?Uk9oWVl6bjRCckl5a3JXaisremNqVkxTWHpmdEpHOEI2dUdzTndYTWZlNzky?=
 =?utf-8?B?Z0xFNWlBeDc0OW4xaTlzYVJkVmhJRmlCdDB3WFArbWdXQ3EzVUhoN3YrMkFR?=
 =?utf-8?B?Q0kzTlByOVB0TDRQYUVWeHZOVzIzVGVEV3V5YTRoQjJjZmRCU1BvVlR2RVlK?=
 =?utf-8?B?TzJyeU80Q3JRM2MrcGpCUFR2QU4zMDUyRDRNQUhKaVVCQzBlbnRZQytacmQr?=
 =?utf-8?B?SDVIMGppQkh0eGZGWlJKVHBrTzdOT1pBUG1JMkNBaU1td2ViOGtqU3puVWNn?=
 =?utf-8?B?YjhIenRrQUlaRXdHRTQzSE9OTWNyaDdGZ0k1bVVpajJ2bFVKL0tjMUI5KzJH?=
 =?utf-8?B?eXYwcU03ZGh2ZGh6aENJY1hXd250YXZLeGMwcC9LK1ExNUIvLzIycGt0Sk1s?=
 =?utf-8?B?UElPU2tqRTF5R1ZGNEo0SGVDbmM0aHNENkM0TGsveVZlQWgxdzhNSXdaWlZN?=
 =?utf-8?B?SGVjS3d1RHVzUnJ6Q2hSQUhrcVFGVW5FbVI5dUQ1SkdFMCtVV05kVzhxcDNp?=
 =?utf-8?B?L3JEdENmc0NwK0plTEFkWHdoRURva3JHSU1xVGFmTSs2UXFiVmJNM3N3dWQ0?=
 =?utf-8?B?MjB4YmYwbHphRWNtb1NqblJiVDlmOXQwaTJCb0hGL2pBalYwcForZExqdWJP?=
 =?utf-8?B?bTlESU1UcTNVL0UyelZOdlBkZ2wvTEVtZDFLM1JLMkFGUHNab0tPL1VuaFVW?=
 =?utf-8?B?QU4vc3oyRHhpUXlFMTEwblFFRFNQTCtlbHBFcWFSak4zL1I4RzNqeTBKRkFT?=
 =?utf-8?B?NWVPSG1mYjV5eTIyNkl2MWovTnVoNjNMYWdiUGVrbUZEcENlbmE3K2JwbFhw?=
 =?utf-8?B?YkFBd29hMVpyMURYVDlUVWhVKzFHcU1lT0ZPdzNaVEVTYXNoTVR2a1VycmUv?=
 =?utf-8?B?V09nSHJBU2NZdkhGcXFka0dZN1NQQU5pOXduOUw1Y0JkZC9BNXFkSDc3SzlF?=
 =?utf-8?B?MDdkWFBWQ0dUY1VzUkpyd3FwNWoxNk4zTk9NV0FQK3FIZjE5bFhoelhVeEFj?=
 =?utf-8?B?VkFkWm15amppdmo4Z3M3RmdJam9UYlFESXg1d0NCTXJlUGljK1FFNEowVmxu?=
 =?utf-8?B?Y2F1ZGlKTzd4SzlEYkJ0RUV4VUpFemNDM2sxcm4wT0JKK2ZydGlGUkZhNkNO?=
 =?utf-8?Q?LPPos+qeTrvl5ZzspoZFoYQ=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df264885-48f4-4780-ecac-08d9dc93b168
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 04:08:35.0632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/dgXr2H9QOPavgXdMClDZeiW9+C+oagp/ogOlQGSM0hk+l0c9uZFtzQhIp4qEq84/yZ25WXs5QiQJsw6w2WjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3540
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/2022 9:47 PM, Peter Gonda wrote:
> On Tue, Jan 18, 2022 at 4:07 AM Nikunj A Dadhania <nikunj@amd.com> wrote:
>>
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Pin the memory for the data being passed to launch_update_data()
>> because it gets encrypted before the guest is first run and must
>> not be moved which would corrupt it.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
>>   * Updated sev_pin_memory_in_mmu() error handling.
>>   * As pinning/unpining pages is handled within MMU, removed
>>     {get,put}_user(). ]
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 119 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 14aeccfc500b..1ae714e83a3c 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -22,6 +22,7 @@
>>  #include <asm/trapnr.h>
>>  #include <asm/fpu/xcr.h>
>>
>> +#include "mmu.h"
>>  #include "x86.h"
>>  #include "svm.h"
>>  #include "svm_ops.h"
>> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>>         return pages;
>>  }
>>
>> +#define SEV_PFERR_RO (PFERR_USER_MASK)
>> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
>> +
>> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
>> +                                             unsigned long hva)
>> +{
>> +       struct kvm_memslots *slots = kvm_memslots(kvm);
>> +       struct kvm_memory_slot *memslot;
>> +       int bkt;
>> +
>> +       kvm_for_each_memslot(memslot, bkt, slots) {
>> +               if (hva >= memslot->userspace_addr &&
>> +                   hva < memslot->userspace_addr +
>> +                   (memslot->npages << PAGE_SHIFT))
>> +                       return memslot;
>> +       }
>> +
>> +       return NULL;
>> +}
>> +
>> +static gpa_t hva_to_gpa(struct kvm *kvm, unsigned long hva, bool *ro)
>> +{
>> +       struct kvm_memory_slot *memslot;
>> +       gpa_t gpa_offset;
>> +
>> +       memslot = hva_to_memslot(kvm, hva);
>> +       if (!memslot)
>> +               return UNMAPPED_GVA;
>> +
>> +       *ro = !!(memslot->flags & KVM_MEM_READONLY);
>> +       gpa_offset = hva - memslot->userspace_addr;
>> +       return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
>> +}
>> +
>> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
>> +                                          unsigned long size,
>> +                                          unsigned long *npages)
>> +{
>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +       struct kvm_vcpu *vcpu;
>> +       struct page **pages;
>> +       unsigned long i;
>> +       u32 error_code;
>> +       kvm_pfn_t pfn;
>> +       int idx, ret = 0;
>> +       gpa_t gpa;
>> +       bool ro;
>> +
>> +       pages = sev_alloc_pages(sev, addr, size, npages);
>> +       if (IS_ERR(pages))
>> +               return pages;
>> +
>> +       vcpu = kvm_get_vcpu(kvm, 0);
>> +       if (mutex_lock_killable(&vcpu->mutex)) {
>> +               kvfree(pages);
>> +               return ERR_PTR(-EINTR);
>> +       }
>> +
>> +       vcpu_load(vcpu);
>> +       idx = srcu_read_lock(&kvm->srcu);
>> +
>> +       kvm_mmu_load(vcpu);
>> +
>> +       for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
>> +               if (signal_pending(current)) {
>> +                       ret = -ERESTARTSYS;
>> +                       break;
>> +               }
>> +
>> +               if (need_resched())
>> +                       cond_resched();
>> +
>> +               gpa = hva_to_gpa(kvm, addr, &ro);
>> +               if (gpa == UNMAPPED_GVA) {
>> +                       ret = -EFAULT;
>> +                       break;
>> +               }
>> +
>> +               error_code = ro ? SEV_PFERR_RO : SEV_PFERR_RW;
>> +
>> +               /*
>> +                * Fault in the page and sev_pin_page() will handle the
>> +                * pinning
>> +                */
>> +               pfn = kvm_mmu_map_tdp_page(vcpu, gpa, error_code, PG_LEVEL_4K);
>> +               if (is_error_noslot_pfn(pfn)) {
>> +                       ret = -EFAULT;
>> +                       break;
>> +               }
>> +               pages[i] = pfn_to_page(pfn);
>> +       }
>> +
>> +       kvm_mmu_unload(vcpu);
>> +       srcu_read_unlock(&kvm->srcu, idx);
>> +       vcpu_put(vcpu);
>> +       mutex_unlock(&vcpu->mutex);
>> +
>> +       if (!ret)
>> +               return pages;
>> +
>> +       kvfree(pages);
>> +       return ERR_PTR(ret);
>> +}
>> +
>>  static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  {
>>         unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
>> @@ -510,15 +615,21 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>         vaddr_end = vaddr + size;
>>
>>         /* Lock the user memory. */
>> -       inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
>> +       if (atomic_read(&kvm->online_vcpus))
>> +               inpages = sev_pin_memory_in_mmu(kvm, vaddr, size, &npages);
> 
> IIUC we can only use the sev_pin_memory_in_mmu() when there is an
> online vCPU because that means the MMU has been setup enough to use?
> Can we add a variable and a comment to help explain that?
> 
> bool mmu_usable = atomic_read(&kvm->online_vcpus) > 0;

Sure, will add comment and the variable.

> 
>> +       else
>> +               inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
> 
> So I am confused about this case. Since svm_register_enc_region() is
> now a NOOP how can a user ensure that memory remains pinned from
> sev_launch_update_data() to when the memory would be demand pinned?
> 
> Before users could svm_register_enc_region() which pins the region,
> then sev_launch_update_data(), then the VM could run an the data from
> sev_launch_update_data() would have never moved. I don't think that
> same guarantee is held here?

Yes, you are right. One way is to error out of this call if MMU is not setup.
Other one would require us to maintain all list of pinned memory via sev_pin_memory() 
and unpin them in the destroy path.

>>         if (IS_ERR(inpages))
>>                 return PTR_ERR(inpages);
>>
>>         /*
>>          * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
>>          * place; the cache may contain the data that was written unencrypted.
>> +        * Flushing is automatically handled if the pages can be pinned in the
>> +        * MMU.
>>          */
>> -       sev_clflush_pages(inpages, npages);
>> +       if (!atomic_read(&kvm->online_vcpus))
>> +               sev_clflush_pages(inpages, npages);
>>
>>         data.reserved = 0;
>>         data.handle = sev->handle;
>> @@ -553,8 +664,13 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>                 set_page_dirty_lock(inpages[i]);
>>                 mark_page_accessed(inpages[i]);
>>         }
>> +
>>         /* unlock the user pages */
>> -       sev_unpin_memory(kvm, inpages, npages);
>> +       if (atomic_read(&kvm->online_vcpus))
>> +               kvfree(inpages);

>> +       else
>> +               sev_unpin_memory(kvm, inpages, npages);

And not unpin here in this case.

Regards
Nikunj
