Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94291655AD
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 04:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgBTDcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 22:32:14 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40048 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727476AbgBTDcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 22:32:13 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 75B2729AE35B8809BAF8;
        Thu, 20 Feb 2020 11:32:11 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 11:32:03 +0800
Subject: Re: [PATCH v4 07/20] irqchip/gic-v4.1: Plumb mask/unmask SGI
 callbacks
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
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-8-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3391810f-aec4-f073-c6e9-9147b680b254@huawei.com>
Date:   Thu, 20 Feb 2020 11:32:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200214145736.18550-8-maz@kernel.org>
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

On 2020/2/14 22:57, Marc Zyngier wrote:
> Implement mask/unmask for virtual SGIs by calling into the
> configuration helper.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

