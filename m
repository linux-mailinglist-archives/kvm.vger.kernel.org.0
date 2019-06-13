Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F843B78
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfFMP3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:29:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728878AbfFMLX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 07:23:29 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A7DBEF7C1BDB2B979504;
        Thu, 13 Jun 2019 19:23:24 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Jun 2019
 19:23:16 +0800
Subject: Re: [PATCH v1 1/5] KVM: arm/arm64: Remove kvm_mmio_emulate tracepoint
To:     James Morse <james.morse@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <marc.zyngier@arm.com>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <acme@kernel.org>, <linuxarm@huawei.com>,
        <acme@redhat.com>, <peterz@infradead.org>,
        <alexander.shishkin@linux.intel.com>, <mingo@redhat.com>,
        <ganapatrao.kulkarni@cavium.com>, <namhyung@kernel.org>,
        <jolsa@redhat.com>, <xiexiangyou@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
 <1560330526-15468-2-git-send-email-yuzenghui@huawei.com>
 <e915c19a-51df-be88-ea3a-7c9a211f4518@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5885c607-1314-ff53-38f1-9f48b1c16de4@huawei.com>
Date:   Thu, 13 Jun 2019 19:20:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <e915c19a-51df-be88-ea3a-7c9a211f4518@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On 2019/6/12 20:48, James Morse wrote:
> Hi,
> 
> On 12/06/2019 10:08, Zenghui Yu wrote:
>> In current KVM/ARM code, no one will invoke trace_kvm_mmio_emulate().
>> Remove this TRACE_EVENT definition.
> 
> Oooer. We can't just go removing these things, they are visible to user-space.
> 
> I recall an article on this: https://lwn.net/Articles/737530/
> "Another attempt to address the tracepoint ABI problem"
> 
> I agree this is orphaned, it was added by commit 45e96ea6b369 ("KVM: ARM: Handle I/O
> aborts"), but there never was a caller.
> 
> The problem with removing it is /sys/kernel/debug/tracing/events/kvm/kvm_mmio_emulate
> disappears. Any program relying on that being present (but useless) is now broken.
Thanks for the reminder.

It turned out that I knew little about the tracepoint ABI :( .
I'm OK to just drop this patch in next version.


Thanks,
zenghui


.


