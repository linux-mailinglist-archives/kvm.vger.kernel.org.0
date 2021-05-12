Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6A37BD8F
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 15:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhELNBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 09:01:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2717 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhELNBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 09:01:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FgFF34cb2z1BLCm;
        Wed, 12 May 2021 20:57:27 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 20:59:59 +0800
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support for
 aarch64
To:     Auger Eric <eric.auger@redhat.com>
CC:     Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <pbonzini@redhat.com>,
        <drjones@redhat.com>, <alexandru.elisei@arm.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com> <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
Date:   Wed, 12 May 2021 20:59:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2021/5/6 20:30, Auger Eric wrote:
> running the test on 5.12 I get
> 
> ==== Test Assertion Failure ====
>   aarch64/debug-exceptions.c:232: false
>   pid=6477 tid=6477 errno=4 - Interrupted system call
>      1	0x000000000040147b: main at debug-exceptions.c:230
>      2	0x000003ff8aa60de3: ?? ??:0
>      3	0x0000000000401517: _start at :?
>   Failed guest assert: hw_bp_addr == PC(hw_bp) at
> aarch64/debug-exceptions.c:105
> 	values: 0, 0x401794

FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
seemed to work for me. Is the ISB a requirement of architecture?

[*] https://lore.kernel.org/kvm/20210503124925.wxdcyzharpyzeu4v@gator.home/


Thanks,
Zenghui
