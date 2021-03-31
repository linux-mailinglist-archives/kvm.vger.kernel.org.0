Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06B134FC4A
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhCaJN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:13:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15833 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhCaJNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 05:13:32 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F9LCc41hqz9tpr;
        Wed, 31 Mar 2021 17:11:24 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 17:13:20 +0800
Subject: Re: [RFC PATCH v2 0/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>
References: <20210316134338.18052-1-zhukeqian1@huawei.com>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <1870563d-4da8-60d6-22e4-242ac820f5ba@huawei.com>
Date:   Wed, 31 Mar 2021 17:13:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210316134338.18052-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kind ping...

On 2021/3/16 21:43, Keqian Zhu wrote:
> Hi all,
> 
> We have two pathes to build stage2 mapping for MMIO regions.
> 
> Create time's path and stage2 fault path.
> 
> Patch#1 removes the creation time's mapping of MMIO regions
> Patch#2 tries stage2 block mapping for host device MMIO at fault path
> 
> Thanks,
> Keqian
> 
> Keqian Zhu (2):
>   kvm/arm64: Remove the creation time's mapping of MMIO regions
>   kvm/arm64: Try stage2 block mapping for host device MMIO
> 
>  arch/arm64/kvm/mmu.c | 80 +++++++++++++++++++++++---------------------
>  1 file changed, 41 insertions(+), 39 deletions(-)
> 
