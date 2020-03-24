Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F1919038D
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 03:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgCXC1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 22:27:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12119 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727047AbgCXC1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 22:27:34 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 561DB2697814C2E51B79;
        Tue, 24 Mar 2020 10:27:27 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 24 Mar 2020
 10:27:19 +0800
Subject: Re: [PATCH v6 08/23] irqchip/gic-v4.1: Plumb skeletal VSGI irqchip
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200320182406.23465-1-maz@kernel.org>
 <20200320182406.23465-9-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <0ac3af1c-5160-a528-f2b4-aac4833ce32c@huawei.com>
Date:   Tue, 24 Mar 2020 10:27:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200320182406.23465-9-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/21 2:23, Marc Zyngier wrote:
> +static int its_sgi_set_affinity(struct irq_data *d,
> +				const struct cpumask *mask_val,
> +				bool force)
> +{
> +	/*
> +	 * There is no notion of affinity for virtual SGIs, at least
> +	 * not on the host (since they can only be targetting a vPE).
> +	 * Tell the kernel we've done whetever it asked for.

new typo?
s/whetever/whatever/

> +	 */
> +	return IRQ_SET_MASK_OK;
> +}


Thanks,
Zenghui

