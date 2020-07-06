Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04F9215D2B
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 19:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgGFR2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 13:28:03 -0400
Received: from foss.arm.com ([217.140.110.172]:58520 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbgGFR2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 13:28:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05C7331B;
        Mon,  6 Jul 2020 10:28:03 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 979C73F68F;
        Mon,  6 Jul 2020 10:27:59 -0700 (PDT)
Date:   Mon, 6 Jul 2020 18:27:48 +0100
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
Subject: Re: [PATCH v3 00/17] KVM: arm64: Preliminary NV patches
Message-ID: <20200706172725.GL28170@gaia>
References: <20200706125425.1671020-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706125425.1671020-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 06, 2020 at 01:54:08PM +0100, Marc Zyngier wrote:
> Catalin: How do you want to proceed for patches 2, 3, and 4? I could
> make a stable branch that gets you pull into the arm64 tree, or the
> other way around. Just let me know.

Please create a separate branch for the S2 TTL patches (ideally based on
no later than -rc3). I plan to queue the rest of Zhenyu's patches on
top.

https://lore.kernel.org/linux-arm-kernel/20200625080314.230-1-yezhenyu2@huawei.com/

Thanks.

-- 
Catalin
