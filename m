Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6440B215CFF
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 19:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgGFRYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 13:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729569AbgGFRYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 13:24:11 -0400
Received: from gaia (unknown [95.146.230.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BA2A2070C;
        Mon,  6 Jul 2020 17:24:08 +0000 (UTC)
Date:   Mon, 6 Jul 2020 18:24:06 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v3 02/17] arm64: Detect the ARMv8.4 TTL feature
Message-ID: <20200706172405.GI28170@gaia>
References: <20200706125425.1671020-1-maz@kernel.org>
 <20200706125425.1671020-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706125425.1671020-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 06, 2020 at 01:54:10PM +0100, Marc Zyngier wrote:
> In order to reduce the cost of TLB invalidation, the ARMv8.4 TTL
> feature allows TLBs to be issued with a level allowing for quicker
> invalidation.
> 
> Let's detect the feature for now. Further patches will implement
> its actual usage.
> 
> Reviewed-by : Suzuki K Polose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

It looks like I had a reviewed-by in the other series [1]. Feel free to
add it here as well:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

[1] https://lore.kernel.org/linux-arm-kernel/20200625080314.230-1-yezhenyu2@huawei.com/
