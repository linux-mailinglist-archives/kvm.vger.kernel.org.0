Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B101B3E8
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 12:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfEMKVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 06:21:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37138 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728848AbfEMKUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 06:20:39 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B2A51795AEB80AF6238C;
        Mon, 13 May 2019 18:20:35 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 May 2019
 18:20:24 +0800
Subject: Re: [RFC PATCH V2] kvm: arm64: export memory error recovery
 capability to user space
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>,
        "Zheng Xiang" <zhengxiang9@huawei.com>
References: <1557728917-49079-1-git-send-email-gengdongjiu@huawei.com>
 <CAFEAcA-S6Kh8yUqVZVA8gtDdRscgVaTfC4CwxngoS2ZPt6K9ww@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <da887bd0-75db-4ad8-cc7a-fa5df26c88fd@huawei.com>
Date:   Mon, 13 May 2019 18:20:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-S6Kh8yUqVZVA8gtDdRscgVaTfC4CwxngoS2ZPt6K9ww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/5/13 17:44, Peter Maydell wrote:
> On Mon, 13 May 2019 at 07:32, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>>
>> When user space do memory recovery, it will check whether KVM and
>> guest support the error recovery, only when both of them support,
>> user space will do the error recovery. This patch exports this
>> capability of KVM to user space.
>>
>> Cc: Peter Maydell <peter.maydell@linaro.org>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> ---
>> v1->v2:
>> 1. check whether host support memory failure instead of RAS capability
>>    https://patchwork.kernel.org/patch/10730827/
>>
>> v1:
>> 1. User space needs to check this capability of host is suggested by Peter[1],
>> this patch as RFC tag because user space patches are still under review,
>> so this kernel patch is firstly sent out for review.
>>
>> [1]: https://patchwork.codeaurora.org/patch/652261/
>> ---
> 
> I thought the conclusion of the thread on the v1 patch was that
> userspace doesn't need to specifically ask the host kernel if
> it has support for this -- if it does not, then the host kernel
> will just never deliver userspace any SIGBUS with MCEERR code,
> which is fine. Or am I still confused?

thanks Peter's quick reply.
yes, I think so, if it does not support,  then the host kernel
will just never deliver userspace any SIGBUS with MCEERR code.

so maybe we do not need this patch.

> 
> thanks
> -- PMM
> .
> 

