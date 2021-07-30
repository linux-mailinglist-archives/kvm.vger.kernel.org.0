Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50F3DB1DB
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 05:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhG3DQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 23:16:18 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12333 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhG3DQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 23:16:14 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GbXVN0SRnz7ylK;
        Fri, 30 Jul 2021 11:11:24 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 11:16:09 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 11:16:08 +0800
Subject: Re: [PATCH v14 00/11] KVM: x86/pmu: Guest Last Branch Recording
 Enabling
To:     <like.xu.linux@gmail.com>, <alex.shi@linux.alibaba.com>,
        <like.xu.linux@gmail.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
 <6102A1A5.90901@huawei.com>
CC:     <ak@linux.intel.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kan.liang@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <wei.w.wang@intel.com>, <x86@kernel.org>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <61036EEC.4020006@huawei.com>
Date:   Fri, 30 Jul 2021 11:15:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <6102A1A5.90901@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, like.

Does it have requirement on CPU if we want to use LBR in Guest?

I have tried linux-5.14-rc3 on different CPUs. And I can use lbr on 
Haswell, Broadwell, skylake and icelake, but I cannot use lbr on IvyBridge.

Thanks!


On 2021/7/29 20:40, Liuxiangdong wrote:
> Hi, like.
>
> This patch set has been merged in 5.12 kernel tree so we can use LBR 
> in Guest.
> Does it have requirement on CPU?
> I can use lbr in guest on skylake and icelake, but cannot on IvyBridge.
>
> I can see lbr formats(000011b) in perf_capabilities msr(0x345), but 
> there is still
> error when I try.
>
> $ perf record -b
> Error:
> cycles: PMU Hardware doesn't support sampling/overflow-interrupts. Try 
> 'perf stat'
>
> Host CPU:
> Architecture:                    x86_64
> CPU op-mode(s):                  32-bit, 64-bit
> Byte Order:                      Little Endian
> Address sizes:                   46 bits physical, 48 bits virtual
> CPU(s):                          24
> On-line CPU(s) list:             0-23
> Thread(s) per core:              2
> Core(s) per socket:              6
> Socket(s):                       2
> NUMA node(s):                    2
> Vendor ID:                       GenuineIntel
> CPU family:                      6
> Model:                           62
> Model name:                      Intel(R) Xeon(R) CPU E5-2620 v2 @ 
> 2.10GHz
> Stepping:                        4
>
>
> Thanks!
> Xiangdong Liu

