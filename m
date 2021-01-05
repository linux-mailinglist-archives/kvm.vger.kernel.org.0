Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DF72EA83C
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 11:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbhAEKJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 05:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbhAEKJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 05:09:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2890C224F9;
        Tue,  5 Jan 2021 10:08:50 +0000 (UTC)
Date:   Tue, 5 Jan 2021 10:08:47 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH] arm64/smp: Remove unused variable irq in
 arch_show_interrupts()
Message-ID: <20210105100847.GB11802@gaia>
References: <20210105092221.15144-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105092221.15144-1-zhukeqian1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 05, 2021 at 05:22:21PM +0800, Keqian Zhu wrote:
> The local variable irq is added in commit a26388152531 ("arm64:
> Remove custom IRQ stat accounting"), but forget to remove in
> commit 5089bc51f81f ("arm64/smp: Use irq_desc_kstat_cpu() in
> arch_show_interrupts()"). Just remove it.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>

I already queued a similar fix in arm64 for-next/fixes (it should appear
in linux-next at some point).

-- 
Catalin
