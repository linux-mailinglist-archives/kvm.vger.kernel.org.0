Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4D218290D
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 07:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgCLGao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 02:30:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46912 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387784AbgCLGao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 02:30:44 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 48A521524AFDBEDCB9A7;
        Thu, 12 Mar 2020 14:30:37 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Mar 2020
 14:30:30 +0800
Subject: Re: [PATCH v5 01/23] irqchip/gic-v3: Use SGIs without active state if
 offered
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
 <20200304203330.4967-2-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <63f6530a-9369-31e6-88d0-5337173495b9@huawei.com>
Date:   Thu, 12 Mar 2020 14:30:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-2-maz@kernel.org>
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
> To allow the direct injection of SGIs into a guest, the GICv4.1
> architecture has to sacrifice the Active state so that SGIs look
> a lot like LPIs (they are injected by the same mechanism).
> 
> In order not to break existing software, the architecture gives
> offers guests OSs the choice: SGIs with or without an active
> state. It is the hypervisors duty to honor the guest's choice.
> 
> For this, the architecture offers a discovery bit indicating whether
> the GIC supports GICv4.1 SGIs (GICD_TYPER2.nASSGIcap), and another
> bit indicating whether the guest wants Active-less SGIs or not
> (controlled by GICD_CTLR.nASSGIreq).

I still can't find the description of these two bits in IHI0069F.
Are they actually architected and will be available in the future
version of the spec?  I want to confirm it again since this has a
great impact on the KVM code, any pointers?


Thanks,
Zenghui

