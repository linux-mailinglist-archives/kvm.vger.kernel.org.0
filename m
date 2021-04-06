Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5D354B38
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 05:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbhDFDZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 23:25:00 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3513 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhDFDYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 23:24:54 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FDtBZ2RN9zRYx1;
        Tue,  6 Apr 2021 11:22:46 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 6 Apr 2021 11:24:45 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 11:24:45 +0800
To:     <like.xu@linux.intel.com>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
CC:     <andi@firstfloor.org>, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        <kan.liang@linux.intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wei.w.wang@intel.com>,
        <x86@kernel.org>
From:   "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Message-ID: <606BD46F.7050903@huawei.com>
Date:   Tue, 6 Apr 2021 11:24:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210329054137.120994-2-like.xu@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi，like.
Some questions about this new pebs patches set：
https://lore.kernel.org/kvm/20210329054137.120994-2-like.xu@linux.intel.com/

The new hardware facility supporting guest PEBS is only available
on Intel Ice Lake Server platforms for now.


AFAIK， Icelake supports adaptive PEBS and extended PEBS which Skylake 
doesn't.
But we can still use IA32_PEBS_ENABLE MSR to indicate general-purpose 
counter in Skylake.
Is there anything else that only Icelake supports in this patches set?


Besides, we have tried this patches set in Icelake.  We can use pebs(eg: 
"perf record -e cycles:pp")
when guest is kernel-5.11, but can't when kernel-4.18.  Is there a 
minimum guest kernel version requirement?


Thanks,
Xiangdong Liu
