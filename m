Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB5A64F2
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 11:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbfICJTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 05:19:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38466 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbfICJTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 05:19:01 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 33C4E53355E7BE0D137C;
        Tue,  3 Sep 2019 17:18:58 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Sep 2019
 17:18:50 +0800
Subject: Re: [PATCH v4 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To:     Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
        "Will Deacon" <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <linux-doc@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-6-steven.price@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d55d091f-1c0f-9c47-b7b2-95c87285335d@huawei.com>
Date:   Tue, 3 Sep 2019 17:14:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190830084255.55113-6-steven.price@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/8/30 16:42, Steven Price wrote:
> Implement the service call for configuring a shared structure between a
> VCPU and the hypervisor in which the hypervisor can write the time
> stolen from the VCPU's execution time by other tasks on the host.
> 
> The hypervisor allocates memory which is placed at an IPA chosen by user
> space.

It seems that no allocation happens in the hypervisor code.  User space
will do it instead?

> The hypervisor then updates the shared structure using
> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
> reporting the stolen time in nanoseconds.
> 
> Whenever stolen time is enabled by the guest, the stolen time counter is
> reset.
> 
> The stolen time itself is retrieved from the sched_info structure
> maintained by the Linux scheduler code. We enable SCHEDSTATS when
> selecting KVM Kconfig to ensure this value is meaningful.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Thanks,
zenghui

