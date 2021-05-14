Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C866380995
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 14:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhENMeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 08:34:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2661 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbhENMeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 08:34:00 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FhSWk1LtjzPxXP;
        Fri, 14 May 2021 20:29:22 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 20:32:38 +0800
Subject: Re: [PATCH v2 0/2] KVM: arm64: Fixup PC updates on exit to userspace
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        Fuad Tabba <tabba@google.com>,
        "James Morse" <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kernel-team@android.com>
References: <20210514104042.1929168-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1ce3b260-f17f-0e7a-00ec-8a2aa810bf3e@huawei.com>
Date:   Fri, 14 May 2021 20:32:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210514104042.1929168-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/5/14 18:40, Marc Zyngier wrote:
> We recently moved anything related to PC updates into the guest entry
> code to help with the protected KVM effort. However, I missed a
> critical point: userspace needs to be able to observe state changes
> when the vcpu exits. Otherwise, live migration is a bit broken and
> vcpu reset can fail (as reported by Zenghui). Not good.
> 
> These two patches aim at fixing the above, and carry a Cc stable.
> 
> * From v1:
>   - Sanitized flag checking
>   - Added comment about relying on __kvm_adjust_pc() being preempt-safe

I had a try but failed to find the added comment ;-). Regardless,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>
