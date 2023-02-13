Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859B06953D9
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjBMW05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 17:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBMW04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 17:26:56 -0500
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [IPv6:2001:41d0:203:375::ae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AFB2101
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 14:26:54 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676327211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSzklRkVsXJz/hVV1Smo9TgADWE1visfUN0vsS5QYPM=;
        b=Mj0TXFbTrVvFINMINi0IRxEZx6zuQM9dP26AUhQAHYasfoGVdKMDrHWEU2ch4vyel5cdqk
        PiKPSAgmF7BXi2eEKZu3o5QPP8No1fVMH+Sejuh9jFazy+Sr2Hh4qWvlOFjxluxGy/tDY2
        0gIyjgjB1jyMzvawFuPH+eAysVcRI1A=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 00/18] KVM: arm64: Prefix patches for NV support
Date:   Mon, 13 Feb 2023 22:26:26 +0000
Message-Id: <167632713104.280051.11716946551616361075.b4-ty@linux.dev>
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Feb 2023 17:58:02 +0000, Marc Zyngier wrote:
> As a bunch of the NV patches have had a decent amount of review, and
> given that they do very little on their own, I've put together a
> prefix series that gets the most mundane stuff out of the way.
> 
> Of course, nothing is functional, but nothing gets used either. In a
> way, this is pretty similar to the current state of pKVM! ;-)
> 
> [...]

Applied to kvmarm/next, thanks!

[01/18] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
        https://git.kernel.org/kvmarm/kvmarm/c/675cabc89900
[02/18] KVM: arm64: Use the S2 MMU context to iterate over S2 table
        https://git.kernel.org/kvmarm/kvmarm/c/8531bd63a8dc
[03/18] KVM: arm64: nv: Introduce nested virtualization VCPU feature
        https://git.kernel.org/kvmarm/kvmarm/c/89b0e7de3451
[04/18] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
        https://git.kernel.org/kvmarm/kvmarm/c/2fb32357ae67
[05/18] KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
        https://git.kernel.org/kvmarm/kvmarm/c/1d05d51bac78
[06/18] KVM: arm64: nv: Add EL2 system registers to vcpu context
        https://git.kernel.org/kvmarm/kvmarm/c/5305cc2c3400
[07/18] KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
        https://git.kernel.org/kvmarm/kvmarm/c/0043b29038e2
[08/18] KVM: arm64: nv: Handle HCR_EL2.NV system register traps
        https://git.kernel.org/kvmarm/kvmarm/c/6ff9dc238a53
[09/18] KVM: arm64: nv: Support virtual EL2 exceptions
        https://git.kernel.org/kvmarm/kvmarm/c/47f3a2fc765a
[10/18] KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
        https://git.kernel.org/kvmarm/kvmarm/c/93c33702cd2b
[11/18] KVM: arm64: nv: Handle trapped ERET from virtual EL2
        https://git.kernel.org/kvmarm/kvmarm/c/6898a55ce38c
[12/18] KVM: arm64: nv: Handle PSCI call via smc from the guest
        https://git.kernel.org/kvmarm/kvmarm/c/bd36b1a9eb5a
[13/18] KVM: arm64: nv: Add accessors for SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
        https://git.kernel.org/kvmarm/kvmarm/c/9da117eec924
[14/18] KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
        https://git.kernel.org/kvmarm/kvmarm/c/d9552fe133f9
[15/18] KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
        https://git.kernel.org/kvmarm/kvmarm/c/e6b367db0f91
[16/18] KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
        https://git.kernel.org/kvmarm/kvmarm/c/280b748e871e
[17/18] KVM: arm64: nv: Filter out unsupported features from ID regs
        https://git.kernel.org/kvmarm/kvmarm/c/9f75b6d447d7
[18/18] KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2 changes
        https://git.kernel.org/kvmarm/kvmarm/c/191e0e155521

--
Best,
Oliver
