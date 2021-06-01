Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F6F396A90
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 03:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhFABS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 21:18:26 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3358 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhFABS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 21:18:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FvDg11D2Cz678n;
        Tue,  1 Jun 2021 09:13:01 +0800 (CST)
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 09:16:44 +0800
Received: from [10.174.187.224] (10.174.187.224) by
 dggpemm000003.china.huawei.com (7.185.36.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 09:16:43 +0800
Subject: Re: [PATCH v5 0/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Marc Zyngier <maz@kernel.org>
References: <20210507110322.23348-1-zhukeqian1@huawei.com>
CC:     <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <dcd01056-4d9f-c55f-7c84-ecba0e0a2810@huawei.com>
Date:   Tue, 1 Jun 2021 09:16:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210507110322.23348-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm000003.china.huawei.com (7.185.36.128)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Kindly remind. :)

BRs,
Keqian

On 2021/5/7 19:03, Keqian Zhu wrote:
> Hi Marc,
> 
> This rebases to newest mainline kernel.
> 
> Thanks,
> Keqian
> 
> 
> We have two pathes to build stage2 mapping for MMIO regions.
> 
> Create time's path and stage2 fault path.
> 
> Patch#1 removes the creation time's mapping of MMIO regions
> Patch#2 tries stage2 block mapping for host device MMIO at fault path
> 
> Changelog:
> 
> v5:
>  - Rebase to newest mainline.
> 
> v4:
>  - use get_vma_page_shift() handle all cases. (Marc)
>  - get rid of force_pte for device mapping. (Marc)
> 
> v3:
>  - Do not need to check memslot boundary in device_rough_page_shift(). (Marc)
> 
> 
> Keqian Zhu (2):
>   kvm/arm64: Remove the creation time's mapping of MMIO regions
>   kvm/arm64: Try stage2 block mapping for host device MMIO
> 
>  arch/arm64/kvm/mmu.c | 99 ++++++++++++++++++++++++--------------------
>  1 file changed, 54 insertions(+), 45 deletions(-)
> 
