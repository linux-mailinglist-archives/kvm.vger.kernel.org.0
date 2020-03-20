Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FD318C65D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 05:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgCTEWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 00:22:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12110 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgCTEWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 00:22:30 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A24DAE60EF66344F6A94;
        Fri, 20 Mar 2020 12:22:27 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 12:22:18 +0800
Subject: Re: [PATCH v5 19/23] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-20-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <10847ac8-af94-0a83-73ed-24039840ca74@huawei.com>
Date:   Fri, 20 Mar 2020 12:22:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-20-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/5 4:33, Marc Zyngier wrote:
> In order to let a guest buy in the new, active-less SGIs, we
> need to be able to switch between the two modes.
> 
> Handle this by stopping all guest activity, transfer the state
> from one mode to the other, and resume the guest. Nothing calls
> this code so far, but a later patch will plug it into the MMIO
> emulation.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

