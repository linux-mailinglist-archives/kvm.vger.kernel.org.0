Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1254635F5F2
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 16:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhDNOLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 10:11:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3083 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbhDNOLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 10:11:12 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FL46P3N9YzWWnf;
        Wed, 14 Apr 2021 22:07:09 +0800 (CST)
Received: from dggpeml100013.china.huawei.com (7.185.36.238) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 14 Apr 2021 22:10:47 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml100013.china.huawei.com (7.185.36.238) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 22:10:47 +0800
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
To:     Andi Kleen <andi@firstfloor.org>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
 <60701165.3060000@huawei.com>
 <1ba15937-ee3d-157a-e891-981fed8b414d@linux.intel.com>
 <60742E82.5010607@huawei.com>
 <20210412152511.igvdfilnuv6ed6hi@two.firstfloor.org>
CC:     Like Xu <like.xu@linux.intel.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        <kan.liang@linux.intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wei.w.wang@intel.com>,
        <x86@kernel.org>, "Xu, Like" <like.xu@intel.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <6076F7E7.5080200@huawei.com>
Date:   Wed, 14 Apr 2021 22:10:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210412152511.igvdfilnuv6ed6hi@two.firstfloor.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpeml100013.china.huawei.com (7.185.36.238)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/12 23:25, Andi Kleen wrote:
>> The reason why soft lockup happens may be the unmapped EPT pages. So, do we
>> have a way to map all gpa
>> before we use pebs on Skylake?
> Can you configure a VT-d device, that will implicitly pin all pages for the
> IOMMU. I *think* that should be enough for testing.
>
> -Andi

Thanks!
But,  it doesn't seem to work because host still soft lockup when I 
configure a SR-IOV direct network card for vm.

Besides, I have tried to configure 1G-hugepages for 2G-mem vm.  Each of 
guest numa nodes has 1G mem.
When I use pebs (perf record -e cycles:pp) in guest, there are 
successful pebs samples on skylake just for a while and
then I cannot get pebs sample. Host doesn't soft lockup in this process.

Is this method effective?   Are there something wrong on skylake for we 
can only get a few samples ?  Maybe IRQ?
