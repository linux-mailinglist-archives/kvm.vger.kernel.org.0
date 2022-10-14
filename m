Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30C5FE684
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 03:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJNBSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 21:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiJNBSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 21:18:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7095169CDE
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 18:18:34 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MpT1R0mrgzVj6y;
        Fri, 14 Oct 2022 09:14:03 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 09:18:30 +0800
Subject: Re: [PATCH] [PATCH] Revert 'vfio: Delete container_q'
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1665222631-202970-1-git-send-email-chenxiang66@hisilicon.com>
 <Y0RkLBiZc6RWl3pB@nvidia.com>
 <935149c4-984e-837b-1c6c-c3e98dcae51b@hisilicon.com>
 <BN9PR11MB527695758D3FFFBEF17708168C239@BN9PR11MB5276.namprd11.prod.outlook.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <4ee6249e-0a12-61fe-c82b-80eb4e7f0185@hisilicon.com>
Date:   Fri, 14 Oct 2022 09:18:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <BN9PR11MB527695758D3FFFBEF17708168C239@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,


在 2022/10/11 10:49, Tian, Kevin 写道:
>> From: chenxiang (M) <chenxiang66@hisilicon.com>
>> Sent: Tuesday, October 11, 2022 10:31 AM
>>
>> Hi Jason,
>>
>>
>> 在 2022/10/11 2:27, Jason Gunthorpe 写道:
>>> On Sat, Oct 08, 2022 at 05:50:31PM +0800, chenxiang wrote:
>>>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>>>
>>>> We find a issue on ARM64 platform with HNS3 VF SRIOV enabled (VFIO
>>>> passthrough in qemu):
>>>> kill the qemu thread, then echo 0 > sriov_numvfs to disable sriov
>>>> immediately, sometimes we will see following warnings:
>>> I suspect this is fixed in vfio-next now, in a different way. Please check
>> Can you point out which patches fix it?
>> I need to merge back those patches to our version, then have a test.
>>
> commit ca5f21b2574903a7430fcb3590e534d92b2fa816
> Author: Jason Gunthorpe <jgg@nvidia.com>
> Date:   Thu Sep 22 21:06:10 2022 -0300
>
>      vfio: Follow a strict lifetime for struct iommu_group

I merge back the patch and have a test, and it solves the issue. Thanks!

