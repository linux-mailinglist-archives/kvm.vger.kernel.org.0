Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB96159331
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgBKPdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 10:33:06 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10611 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729302AbgBKPdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 10:33:06 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 825A2710FE4D5A09D668;
        Tue, 11 Feb 2020 23:32:25 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Feb 2020
 23:32:15 +0800
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     Andrew Jones <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <alexandru.elisei@arm.com>
References: <20200211133705.1398-1-drjones@redhat.com>
 <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
Message-ID: <83803119-0ea8-078d-628b-537c3d9525b1@huawei.com>
Date:   Tue, 11 Feb 2020 23:32:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/2/11 22:50, Zenghui Yu wrote:
> Hi Drew,
> 
> On 2020/2/11 21:37, Andrew Jones wrote:
>> Let's bail out of the wait loop if we see the expected state
>> to save over six seconds of run time. Make sure we wait a bit
>> before reading the registers and double check again after,
>> though, to somewhat mitigate the chance of seeing the expected
>> state by accident.
>>
>> We also take this opportunity to push more IRQ state code to
>> the library.
>>
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> [...]
> 
>> +
>> +enum gic_irq_state gic_irq_state(int irq)
> 
> This is a *generic* name while this function only deals with PPI.
> Maybe we can use something like gic_ppi_state() instead?  Or you
> will have to take all interrupt types into account in a single
> function, which is not a easy job I think.

Just to follow up, gic_irq_get_irqchip_state()/gic_peek_irq() [*] is
the Linux implementation of this for PPIs and SPIs.

[*] linux/drivers/irqchip/irq-gic-v3.c


Thanks,
Zenghui

