Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C506D30A8A6
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhBAN0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:26:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12061 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhBAN0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 08:26:53 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DTpZT24CpzMTCD;
        Mon,  1 Feb 2021 21:24:33 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 1 Feb 2021 21:26:00 +0800
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Implement SW/HW combined dirty log
To:     Marc Zyngier <maz@kernel.org>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
 <f68d12f2-fa98-ebdd-3075-bfdcd690ee51@huawei.com>
 <9a64d4acd8e8b0b8c86143752b8c856d@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <xiexiangyou@huawei.com>, <zhengchuan@huawei.com>,
        <yubihong@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <3493e144-805a-033d-f90b-556a6d0d4bff@huawei.com>
Date:   Mon, 1 Feb 2021 21:25:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <9a64d4acd8e8b0b8c86143752b8c856d@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/2/1 21:17, Marc Zyngier wrote:
> On 2021-02-01 13:12, Keqian Zhu wrote:
>> Hi Marc,
>>
>> Do you have time to have a look at this? Thanks ;-)
> 
> Not immediately. I'm busy with stuff that is planned to go
> in 5.12, which isn't the case for this series. I'll get to
> it eventually.
> 
> Thanks,
> 
>         M.
Sure, I am not eager. Please concentrate on your urgent work firstly. ;-) Thanks.

Keqian.
