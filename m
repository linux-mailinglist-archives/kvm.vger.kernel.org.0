Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4857E1587ED
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 02:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBKB0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 20:26:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:33550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727640AbgBKB0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 20:26:07 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3F5E6365F6259C90987B;
        Tue, 11 Feb 2020 09:26:06 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Feb 2020
 09:25:56 +0800
Subject: Re: [PATCH] KVM: Disable preemption in kvm_get_running_vcpu()
To:     Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>
CC:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20200207163410.31276-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2b47b50f-1c78-577a-4216-dcf8d712d96c@huawei.com>
Date:   Tue, 11 Feb 2020 09:25:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200207163410.31276-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/2/8 0:34, Marc Zyngier wrote:
> Accessing a per-cpu variable only makes sense when preemption is
> disabled (and the kernel does check this when the right debug options
> are switched on).
> 
> For kvm_get_running_vcpu(), it is fine to return the value after
> re-enabling preemption, as the preempt notifiers will make sure that
> this is kept consistent across task migration (the comment above the
> function hints at it, but lacks the crucial preemption management).
> 
> While we're at it, move the comment from the ARM code, which explains
> why the whole thing works.
> 
> Fixes: 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com

Tested-by: Zenghui Yu <yuzenghui@huawei.com>

on top of v5.6-rc1.


Thanks

