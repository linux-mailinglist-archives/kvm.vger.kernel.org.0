Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2109F42FB
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 10:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbfKHJU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 04:20:27 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:39490 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728513AbfKHJU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 04:20:27 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 09EA77BC64AC8CBF97B3;
        Fri,  8 Nov 2019 17:20:25 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 8 Nov 2019
 17:20:15 +0800
Subject: Re: [PATCH 2/2] KVM: arm64: Opportunistically turn off WFI trapping
 when using direct LPI injection
To:     Marc Zyngier <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
References: <20191107160412.30301-1-maz@kernel.org>
 <20191107160412.30301-3-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3ca03337-2a10-4958-c551-721461dc0082@huawei.com>
Date:   Fri, 8 Nov 2019 17:20:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20191107160412.30301-3-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2019/11/8 0:04, Marc Zyngier wrote:
> Just like we do for WFE trapping, it can be useful to turn off
> WFI trapping when the physical CPU is not oversubscribed (that
> is, the vcpu is the only runnable process on this CPU) *and*
> that we're using direct injection of interrupts.
> 
> The conditions are reevaluated on each vcpu_load(), ensuring that
> we don't switch to this mode on a busy system.
> 
> On a GICv4 system, this has the effect of reducing the generation
> of doorbell interrupts to zero when the right conditions are
> met, which is a huge improvement over the current situation
> (where the doorbells are screaming if the CPU ever hits a
> blocking WFI).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

