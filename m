Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A35189479
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 04:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCRD3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 23:29:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11656 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbgCRD3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 23:29:07 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 17D9D86B7533D136EEE3;
        Wed, 18 Mar 2020 11:29:06 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 18 Mar 2020
 11:28:58 +0800
Subject: Re: [PATCH v5 18/23] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
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
 <20200304203330.4967-19-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9c518e1d-5a0a-5438-a37d-d9250c4e6320@huawei.com>
Date:   Wed, 18 Mar 2020 11:28:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-19-maz@kernel.org>
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
> Most of the GICv3 emulation code that deals with SGIs now has to be
> aware of the v4.1 capabilities in order to benefit from it.
> 
> Add such support, keyed on the interrupt having the hw flag set and
> being a SGI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

