Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC761367B35
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhDVHg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:36:58 -0400
Received: from mail-eopbgr760079.outbound.protection.outlook.com ([40.107.76.79]:51120
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235166AbhDVHg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 03:36:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHMVOihpAINObQ76PlrxYuP8DlUkICL5NbWbPNk31h3T3Tq/0HY8PmgQrAdwxB13TLQNf5O1mPWttmZpc+aMxCBtSAYTBC16G4KfgCafHyVLhGykySOJZyWyLJDQsPvOj5AMtXhhrXpJa5tsfvg9NqwQstTyfqAN9bo8Zq965T7K8lAto+GTQ8OiPlvZF+WQEvQB+YDagOrFJnQ33LS1xJR4cun95Ait1BnfLZY8XpAL7Pf+QM1dXP0pN6VmXHl7c0sRBSDPV/W2cvK9zOQonBaRGrP3prvtUaRsfFagQN66XIt17HOJAg3NjcDc6o8BvfiNFl48KLUbk3K8fx2gFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u9zBNpjMkgwed0K8Uwqx09QjcgwWYkfb3hzBaB6UXs=;
 b=e0YI4MJcqbjVVuADD59hYjY4fB4Uy80borqdBNOwYJlrs5tk4TtUgspslvTvfsAB4K3iH4+fOJcXmyG/+8Jb/hpKdW1LZi+wCl4m9uSKawYHTfTC1u12PVfO1dDS/7b+w2g38ISvUX6R9d2xsnmTYwATinR5u4UyBtvXqJjIezMV9NlA1lZ3Zrs5RNhkShZed2rKGFWmuvseCkkbrnAlvtF250S9nxfDdWbtkk4QVr1XUAFqkdr77Egz5MDMI6vpvsuFhTLeQyDvjVoSguwjKrn9EdKdCpbPMt25RpK0474RfPrqakmdxXscmX6y6NItp79LyxNqzdw49iVtyhuKVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u9zBNpjMkgwed0K8Uwqx09QjcgwWYkfb3hzBaB6UXs=;
 b=idvu6cGfYPMY2qoL1Q6rlOvsMr1UrcmrYOYIQrIhiKHfkUz1Yhr0/2F2EuPVd3Dt0Om4Q4GUHQqrZSGUk5v8ug5dqBGXD8nsXt7jImFrayPN+rVNY5jZLEfj6YQILOZnCpkDtnrZt9hpFCTqxIHBo85QxnnlrpRnCO9dfDMo8F5WWAC37hRv7kIEvsYTFnV+qJZNgTp8IXqxskOKc8RRuC4yD/+fC555nftSHKpqFxWkysRBZcQLwEi4YR63PgrmEw1lYpzH1Ltz7sMm2J9D/O7cCcmSVBcW/tN05p3NXWVGNG3ndYSmc7lhtMcyL8lgdEchK5JXNt3zzEINu1ximA==
Received: from BN0PR04CA0207.namprd04.prod.outlook.com (2603:10b6:408:e9::32)
 by CH2PR12MB4325.namprd12.prod.outlook.com (2603:10b6:610:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 07:36:21 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::65) by BN0PR04CA0207.outlook.office365.com
 (2603:10b6:408:e9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Thu, 22 Apr 2021 07:36:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 07:36:21 +0000
Received: from [10.40.103.59] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Apr
 2021 07:36:17 +0000
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To:     Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>
CC:     Keqian Zhu <zhukeqian1@huawei.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <cjia@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com>
 <2e23aaa7-0c8d-13ba-2eae-9e6ab2adc587@redhat.com>
 <ed8a8b90-8b96-4967-01f5-cd0f536c38d2@huawei.com>
 <871rb3rgpl.wl-maz@kernel.org>
 <b97415a2-7970-a741-9690-3e4514b4aa7d@redhat.com>
 <87v98eq0dh.wl-maz@kernel.org>
From:   "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>
Message-ID: <bf782ec1-71da-5a8e-f250-20ed88677b8c@nvidia.com>
Date:   Thu, 22 Apr 2021 13:06:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87v98eq0dh.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd5ebe0b-4c30-4276-6ca1-08d90561532a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4325:
X-Microsoft-Antispam-PRVS: <CH2PR12MB43250D71E74E7ECEE0845676B8469@CH2PR12MB4325.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q6qhcFvzr4RosMmURsugpE92v3NqJJ18pY+6+Z26zcfeeWsUpc4dRNylz0uJuyVv77sBkfykhBORkUkrtL1/rxkvpto8g+hMHTlz5PzwJdDCTfshLenHLu0aILPWtQuf8RbGZuu7W5U6p9mSV+il27xFtMoqWtS9c12z6+225SH3M69WroSNR+3kUaCyHI89vZd/3ldNXb2O6NosTFLCk0tHe/f17iBEXkEmo4B8aK17AWHTK8NQ3yvfYPMFca5aKP52ip8himooqQX00IJ7L47UHQKwLbQgmWVPLLRVSoqHdk7QNMTa5mvQu9A8gRDkgdwW7hdEL+MDZqspvxFk4eJ0Hh/cQAHXCV+q9zseqcYH+DI3Px7CM4MHNU0K12P9lkIAwXbgtXlHcewwh1b/qFfVKgGMvcOoPoMtprqbw7obRruvWpAr5Gkh2L40y0eZCyZB7utfu8hJG0LROdY+TDbtFtIxxYLHfKjlhgM/bA18D4MPaKSCKkGi90/Vy5CaJMMB03TjUeBjrjnU/Ccsk+ofupbdrrDTkI/HjtB9n6aG50FBzpbz/Gl+DKfsNKUytOTAMnKckr3JAyI565Trk02v9M4CdDDJvwjC2SQfhnwmjq5PfQP4NiLbaXA4EnTF8HJ/oH+hy3W47IqUaV5+mTRt2nEXK45nNK+XeZzC2q17CwGGHANGVsQZnMSPLw1sz1zWSJH8A1l/XFvUj6c0/T9CW9aBorGmDAPn2x28B8Lx5EBPjfxgoF0Fcla4+dPWx8N//JKAiDMluDCOylmdqw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(36840700001)(46966006)(186003)(336012)(31696002)(36756003)(426003)(31686004)(26005)(2906002)(5660300002)(316002)(16576012)(70586007)(36906005)(16526019)(82740400003)(356005)(8676002)(83380400001)(70206006)(966005)(2616005)(8936002)(7636003)(47076005)(82310400003)(36860700001)(4326008)(6666004)(86362001)(54906003)(110136005)(478600001)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 07:36:21.3192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5ebe0b-4c30-4276-6ca1-08d90561532a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4325
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/22/2021 12:20 PM, Marc Zyngier wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Thu, 22 Apr 2021 03:02:00 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 4/21/21 9:59 PM, Marc Zyngier wrote:
>>> On Wed, 21 Apr 2021 07:17:44 +0100,
>>> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>>> On 2021/4/21 14:20, Gavin Shan wrote:
>>>>> On 4/21/21 12:59 PM, Keqian Zhu wrote:
>>>>>> On 2020/10/22 0:16, Santosh Shukla wrote:
>>>>>>> The Commit:6d674e28 introduces a notion to detect and handle the
>>>>>>> device mapping. The commit checks for the VM_PFNMAP flag is set
>>>>>>> in vma->flags and if set then marks force_pte to true such that
>>>>>>> if force_pte is true then ignore the THP function check
>>>>>>> (/transparent_hugepage_adjust()).
>>>>>>>
>>>>>>> There could be an issue with the VM_PFNMAP flag setting and checking.
>>>>>>> For example consider a case where the mdev vendor driver register's
>>>>>>> the vma_fault handler named vma_mmio_fault(), which maps the
>>>>>>> host MMIO region in-turn calls remap_pfn_range() and maps
>>>>>>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
>>>>>>> the VM_PFNMAP flag into vma->flags.
>>>>>> Could you give the name of the mdev vendor driver that triggers this issue?
>>>>>> I failed to find one according to your description. Thanks.
>>>>>>
>>>>>
>>>>> I think it would be fixed in driver side to set VM_PFNMAP in
>>>>> its mmap() callback (call_mmap()), like vfio PCI driver does.
>>>>> It means it won't be delayed until page fault is issued and
>>>>> remap_pfn_range() is called. It's determined from the beginning
>>>>> that the vma associated the mdev vendor driver is serving as
>>>>> PFN remapping purpose. So the vma should be populated completely,
>>>>> including the VM_PFNMAP flag before it becomes visible to user
>>>>> space.
>>>
>>> Why should that be a requirement? Lazy populating of the VMA should be
>>> perfectly acceptable if the fault can only happen on the CPU side.
>>>
>>
>> It isn't a requirement and the drivers needn't follow strictly. I checked
>> several drivers before looking into the patch and found almost all the
>> drivers have VM_PFNMAP set at mmap() time. In drivers/vfio/vfio-pci.c,
>> there is a comment as below, but it doesn't reveal too much about why
>> we can't set VM_PFNMAP at fault time.
>>
>> static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
>> {
>>        :
>>          /*
>>           * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>>           * change vm_flags within the fault handler.  Set them now.
>>           */
>>          vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
>>          vma->vm_ops = &vfio_pci_mmap_ops;
>>
>>          return 0;
>> }
>>
>> To set these flags in advance does have advantages. For example,
>> VM_DONTEXPAND prevents the vma to be merged with another
>> one. VM_DONTDUMP make this vma isn't eligible for
>> coredump. Otherwise, the address space, which is associated with the
>> vma is accessed and unnecessary page faults are triggered on
>> coredump.  VM_IO and VM_PFNMAP avoids to walk the page frames
>> associated with the vma since we don't have valid PFN in the
>> mapping.
> 
> But PCI clearly isn't the case we are dealing with here, and not
> everything is VFIO either. I can *today* create a driver that
> implements a mmap+fault handler, call mmap() on it, pass the result to
> a memslot, and get to the exact same result Santosh describes.
> 
> No PCI, no VFIO, just a random driver. We are *required* to handle
> that.

Agree with Marc here, that kernel should be able to handle it without 
VM_PFNMAP flag set in driver.

For driver reference, you could check the V2 version of this patch that 
got accepted upstream and has details as-to how this can be reproduced 
using vfio-pci: https://www.spinics.net/lists/arm-kernel/msg848491.html

> 
>          M.
> 
> --
> Without deviation from the norm, progress is not possible.
> 
