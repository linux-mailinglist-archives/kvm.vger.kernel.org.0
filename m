Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4443E18945F
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 04:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCRDSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 23:18:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11655 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726478AbgCRDSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 23:18:13 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A972390756A414F4186A;
        Wed, 18 Mar 2020 11:18:08 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 18 Mar 2020
 11:17:59 +0800
Subject: Re: [PATCH v5 21/23] KVM: arm64: GICv4.1: Reload VLPI configuration
 on distributor enable/disable
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
 <20200304203330.4967-22-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <7f112d75-166b-24eb-538d-e100242d8e9a@huawei.com>
Date:   Wed, 18 Mar 2020 11:17:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-22-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/5 4:33, Marc Zyngier wrote:
> Each time a Group-enable bit gets flipped, the state of these bits
> needs to be forwarded to the hardware. This is a pretty heavy
> handed operation, requiring all vcpus to reload their GICv4
> configuration. It is thus implemented as a new request type.

[note to myself]
... and the status are forwarded to HW by programming VGrp{0,1}En
fields of GICR_VPENDBASER when vPEs are made resident next time.

> 
> Of course, we only support Group-1 for now...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

