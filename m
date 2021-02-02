Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D19730B88D
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 08:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhBBHVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 02:21:18 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12094 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhBBHVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 02:21:17 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVGQW4F44z162wf;
        Tue,  2 Feb 2021 15:19:15 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 15:20:32 +0800
Subject: Re: [PATCH v13 03/15] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To:     Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <joro@8bytes.org>, <maz@kernel.org>,
        <robin.murphy@arm.com>, <alex.williamson@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-4-eric.auger@redhat.com>
 <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com>
 <c457b450-8755-308e-7c7a-abe23b33d0d6@redhat.com>
CC:     <jean-philippe@linaro.org>, <jacob.jun.pan@linux.intel.com>,
        <nicoleotsuka@gmail.com>, <vivek.gautam@arm.com>,
        <yi.l.liu@intel.com>, <zhangfei.gao@linaro.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <04fb111d-304e-2707-e5bb-e77b5ae93ed5@huawei.com>
Date:   Tue, 2 Feb 2021 15:20:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <c457b450-8755-308e-7c7a-abe23b33d0d6@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2021/2/2 1:19, Auger Eric wrote:
> Hi Keqian,
> 
> On 2/1/21 1:26 PM, Keqian Zhu wrote:
>> Hi Eric,
>>
>> On 2020/11/18 19:21, Eric Auger wrote:
>>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>
>>> When handling faults from the event or PRI queue, we need to find the
>>> struct device associated to a SID. Add a rb_tree to keep track of SIDs.
>>>
>>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> [...]
>>
>>>  }
>>>  
>>> +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>>> +				  struct arm_smmu_master *master)
[...]

>>>  	kfree(master);
>>
>> Thanks,
>> Keqian
>>
> Thank you for the review. Jean will address this issues in his own
> series and on my end I will rebase on this latter.
> 
> Best Regards
> 
> Eric
>

Yeah, and hope this series can be accepted earlier ;-)

Thanks,
Keqian
